os = Facter.value('operatingsystem')
Facter.add(:ptory_role) do
  setcode do
    os = Facter.value('operatingsystem')
    if os == 'windows'
      role_file='C:/ptory/role.txt'
    else 
      role_file='/etc/ptory/role.txt'
    end
    if File.exist?(role_file)
      File.read(role_file)
    else
      'UNKNOWN'
    end
  end
end
