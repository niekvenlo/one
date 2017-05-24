describe Person.new 'John', 'Smith' do
   it { is_expected.to have_attributes(first_name: 'John') }
   it { is_expected.to have_attributes(last_name: 'Smith') }
end
