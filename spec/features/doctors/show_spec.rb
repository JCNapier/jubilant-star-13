require 'rails_helper'

RSpec.describe 'doctor show page' do
  let!(:hospital_1) { Hospital.create!(name: "Arkham Hospital")}
  let!(:hospital_2) { Hospital.create!(name: "Metropolis")}

  let!(:doctor_1) {hospital_1.doctors.create!(name: "Bruce", specialty: "Surgery", university: "Johns Hopkins University")}
  let!(:doctor_2) {hospital_1.doctors.create!(name: "Alfred", specialty: "Physical Therapy", university: "Stanford University")}

  let!(:patient_1) {Patient.create!(name: "Jack Napier", age: 90)}
  let!(:patient_2) {Patient.create!(name: "Selena Kyle", age: 80)}
  let!(:patient_3) {Patient.create!(name: "Oswald Chesterfield Cobblepot", age: 70)}
  let!(:patient_4) {Patient.create!(name: "Edward Nigma", age: 60)}

  let!(:doctor_patient_1) {DoctorPatient.create!(patient_id: patient_1.id, doctor_id: doctor_1.id)}
  let!(:doctor_patient_2) {DoctorPatient.create!(patient_id: patient_2.id, doctor_id: doctor_1.id)}
  let!(:doctor_patient_3) {DoctorPatient.create!(patient_id: patient_3.id, doctor_id: doctor_2.id)}
  let!(:doctor_patient_4) {DoctorPatient.create!(patient_id: patient_4.id, doctor_id: doctor_2.id)}

  it 'shows the doctors name' do 
    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content(doctor_1.name)

    expect(page).to_not have_content(doctor_2.name)
  end

  it 'shows the doctors specialty' do 
    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content("Specialty: #{doctor_1.specialty}")

    expect(page).to_not have_content("Specialty: #{doctor_2.specialty}")
  end

  it 'shows the name of the university the doctor got their doctorate from' do 
    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content("University: #{doctor_1.university}")

    expect(page).to_not have_content("University: #{doctor_2.university}")
  end

  it 'shows the name of the hospital the doctor works at' do 
    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content(hospital_1.name)
    expect(page).to_not have_content(hospital_2.name)
  end

  it 'shows all the patients this doctor has' do 
    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content(patient_1.name)
    expect(page).to have_content(patient_2.name)

    expect(page).to_not have_content(patient_3.name)
    expect(page).to_not have_content(patient_4.name)
  end

  it 'can remove a patient from a doctors caseload' do 
    visit "/doctors/#{doctor_1.id}"

    expect(page).to have_content(patient_1.name)

    click_button "Remove #{patient_1.name}"

    expect(current_path).to eq("/doctors/#{doctor_1.id}")
    
    expect(page).to_not have_content(patient_1.name)
  end
end