# frozen_string_literal: true

class Warrior
  attr_accessor :experience_instance, :level_instance,
    :rank_instance, :achievements

  def initialize
    self.experience_instance = Experience.new
    self.level_instance = Level.new(experience_instance)
    self.rank_instance = Rank.new(level_instance)
    self.achievements = []
  end

  def level
    level_instance.level
  end

  def experience
    experience_instance.points
  end

  def rank
    rank_instance.rank
  end

  def training(args)
    WarriorTraining.new(self, args).call
  end

  def battle(enemy_level)
    Battle.new(self, enemy_level).call
  end
end

class Battle
  GOOD_FIGHT = 'A good fight'.freeze
  EASY_FIGHT = 'Easy fight'.freeze
  DEFEATED = "You've been defeated".freeze
  INTENSE_FIGHT = 'An intense fight'.freeze

  attr_accessor :warrior, :enemy_level, :battle_report, :earned_points

  def initialize(warrior, enemy_level)
    self.warrior = warrior
    self.enemy_level = enemy_level
    self.battle_report = ''
    self.earned_points = 0
  end

  def call
    return 'Invalid level' if invalid_enemy_level?

    check_for_good_fight!
    check_for_easy_fight!
    check_for_defeated_fight!
    check_for_intense_fight!

    warrior.experience_instance.increase_points(earned_points)
    battle_report
  end

  private

  def invalid_enemy_level?
    !(1..100).include? enemy_level
  end

  def check_for_good_fight!
    if diff_level.zero?
      self.earned_points = 10
      self.battle_report = GOOD_FIGHT
    elsif diff_level == 1
      self.earned_points = 5
      self.battle_report = GOOD_FIGHT
    end
  end

  def check_for_easy_fight!
    return unless diff_level >= 2

    self.battle_report = EASY_FIGHT
  end

  def check_for_defeated_fight!
    return unless diff_level <= -5 && warrior.rank != Rank.new(Level.new(Experience.new(enemy_level * 100))).rank

    self.battle_report = DEFEATED
  end

  def check_for_intense_fight!
    return unless battle_report.empty?

    self.earned_points = 20 * diff_level.abs * diff_level.abs
    self.battle_report = INTENSE_FIGHT
  end

  def diff_level
    @diff_level ||= warrior.level - enemy_level
  end
end

class WarriorTraining
  NOT_STRONG_ENOUGH = 'Not strong enough'

  attr_accessor :warrior, :training_info

  def initialize(warrior, training_info)
    self.warrior = warrior
    self.training_info = training_info
  end

  def call
    return NOT_STRONG_ENOUGH if training_level > warrior.level

    warrior.achievements << training_achievement

    warrior.experience_instance.increase_points(training_points)

    training_achievement
  end

  private

  def training_achievement
    training_info[0]
  end

  def training_points
    training_info[1]
  end

  def training_level
    training_info[2]
  end
end

class Experience
  MAX_POINTS = 10_000

  attr_accessor :points

  def initialize(points = nil)
    self.points = points || 100
  end

  def increase_points(number = 0)
    if points + number > MAX_POINTS
      self.points = 10_000
    else
      self.points += number
    end
  end
end

class Enemy
  attr_accessor :level

  def initialize(level)
    self.level = level
  end

  def rank; end
end

class Level
  attr_accessor :experience

  def initialize(experience)
    self.experience = experience
  end

  def level
    experience.points / 100
  end
end

class Enemy
  attr_accessor :level

  def initializer(level:)
    self.level = level
  end
end

class Rank
  RANKS = %w[Pushover Novice Fighter Warrior Veteran Sage
    Elite Conqueror Champion Master Greatest].freeze

  attr_accessor :level

  def initialize(level)
    self.level = level
  end

  def rank
    RANKS[(level.level / 10)]
  end
end
