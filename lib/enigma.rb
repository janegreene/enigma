require_relative './cipher'
require 'date'

class Enigma < Cipher

  def encrypt(message, key = @key, date = @date)
    shifts = generate_shifts(encrypted_key(key), encrypted_date(date))
    encrypted_string = shift_message(message, shifts)
      {
        encryption: encrypted_string,
        key: key,
        date: date
      }
  end

  def decrypt(ciphertext, key = @key, date = @date)
    shifts = generate_shifts(encrypted_key(key), encrypted_date(date))
    decrypt_string = reverse_shift_message(ciphertext, shifts)
    {
       decryption: decrypt_string,
       key: key,
       date: date
     }
  end


  def encrypted_key(key)

    {
      A: key[0..1].to_i,
      B: key[1..2].to_i,
      C: key[2..3].to_i,
      D: key[3..4].to_i
    }
  end

  def encrypted_date(date)
    squared_date = date.to_i ** 2
    last_four = squared_date.to_s.split("").last(4)
    {
      A: last_four[0].to_i,
      B: last_four[1].to_i,
      C: last_four[2].to_i,
      D: last_four[3].to_i
    }
  end

  def generate_shifts(key_hash, date_hash)
    key_hash.merge!(date_hash) { |k, o, n| o + n }
  end

  def find_index(character)
     @character_set.index(character)
  end

  def shift_character(shift_number, character)
    character_index = find_index(character)
      if character_index
        new_index = character_index + shift_number
        @character_set[(new_index % 27)]
      else
        character
      end
  end

  def shift_message(message, shifts)
    split_message = message.downcase.split("")
      split_message.map.with_index do |character, index|
        if index % 4 == 0
          shift_character(shifts[:A], character)
        elsif index % 4 == 1
          shift_character(shifts[:B], character)
        elsif index % 4 == 2
          shift_character(shifts[:C], character)
        elsif index % 4 == 3
          shift_character(shifts[:D], character)
        end
      end.join

  end

  def reverse_shift_message(message, shifts)
    split_message = message.downcase.split("")
      split_message.map.with_index do |character, index|
        if index % 4 == 0
          reverse_shift_character(shifts[:A], character)
        elsif index % 4 == 1
          reverse_shift_character(shifts[:B], character)
        elsif index % 4 == 2
          reverse_shift_character(shifts[:C], character)
        elsif index % 4 == 3
          reverse_shift_character(shifts[:D], character)
        end
      end.join
  end

  def reverse_shift_character(shift_number, character)
    character_index = find_index(character)
      if character_index
        new_index = character_index - shift_number
        @character_set[(new_index % 27)]
      else
        character
      end
  end

end
