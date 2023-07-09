#!/bin/bash
<<doc
Name : Pragati Kumari
Date :07/07/2023 
Title : Linux Project
Sample I/P : 	1
Sample O/P :	1.Sign In
				2. Sign Up
				3. Exit
				Enter Option : 1
				Enter Username : Prachi
			 	Enter new Password :
			 	Re-Enter Password :
				New User Succesfully created
doc

function start_task ()									#The start_task function presents a menu to the user with three options: sign up, sign in,or exit the application.
{
	echo -e "1.Sign up\n2.Sign in\n3.Exit "						#It displays the menu options using the echo command.
	read -p "Enter your Option : " option						#It reads the user's choice and assigns it to the variable option.

		case $option in 							#It uses a case statement to handle different cases based on the value of option.

			1)	echo "Enter the username : "				#If the user selects option 1, it means they want to sign up. The function prompts for a username,calls the check_username function to check if the username is available, and then calls the enter_password function to set the password.
				check_username
				enter_password
				;;

			2) 	echo "Enter your Username : " 				#If the user selects option 2, it means they want to sign in. The function prompts for a username and calls the enter_username function to proceed with the sign-in process.
				enter_username
				;;

			3)	echo							#If the user selects option 3, it means they want to exit the application. The function displays a farewell message, exits the script, and terminates the application.

				echo "Thanks for using the application :) Have a nice day !"	
				echo
				exit
				;;

			*)	echo "Wrong Option selected !! Please Enter a Valid Choice "	#If the user selects any other option, it means an invalid choice was made. The function displays an error message and recursively calls itself (start_task) to present the menu again and prompt for a valid choice.
				start_task
				;;
		esac
}

function check_username()								# Function to check if the entered username already exists
{
	read name
	name_status=1									#It starts by initializing a variable name_status to 1, which represents the existence status of the entered username.
	username_array=(`cat usernames.csv`)						#It reads the contents of the "usernames.csv" file and stores them in the username_array variable.
		for i in ${username_array[@]}						#It iterates over each element in username_array and compares it with the entered username. If a match is found, name_status is set to 0.
		do
			if [ $i = $name ]
			then
				name_status=0
			fi
		done
		if [ $name_status -eq 0 ]						#After the loop, it checks the value of name_status.
											#If name_status is 0, it means the entered username already exists. The function displays an error message and prompts the user to enter a different username by recursively calling itself (check_username).
		then
				echo "Entered username already exists "
				echo "Enter a different username "
				check_username 
		else
		echo $name >> usernames.csv						#If name_status is not 0, it means the entered username is unique. The function appends the username to the "usernames.csv" file.
		fi
}

function enter_password()								# Function to enter and verify a new password
{
			echo "Enter New Password"					#It prompts the user to enter a new password by displaying a message.
			read -s pass1							#It reads the input for the new password and assigns it to the variable pass1. 
											#The -s option ensures that the password is not displayed on the screen during input.
			echo "Re-enter Password "					#It prompts the user to re-enter the password for verification by displaying a message.
			read -s pass2							#It reads the re-entered password and assigns it to the variable pass2.
			if [ $pass1 = $pass2 ]						#It compares pass1 and pass2 using a conditional statement.
			then
				echo "New user created !!"				#If the passwords match, it means the user successfully created a new password. 
											#The function displays a message indicating the creation of a new user and appends the new password to the "passwords.csv" file.
			   echo $pass1 >> passwords.csv
			else
				echo "Entered passwords do not match "			#If the passwords do not match, it means the verification failed. The function displays an error message and recursively calls itself (enter_password) to prompt the user to enter and verify a new password again.
				enter_password
			fi
}

function enter_username()								#Function to enter the username and check if it exists
{
	read name									#starts by reading the user input for a username and assigns it to the variable name.
	index=0										#It initializes a variable index to 0, which will be used to keep track of the index of the username in the username_array.											
	username_array=(`cat usernames.csv`)						#It reads the contents of the "usernames.csv" file and stores them in the username_array variable.							
		for i in ${username_array[@]}						#It iterates over each element in username_array and compares it with the entered username. If a match is found, it means the username exists.
		do
			index=$((index+1))
			if [ $i = $name ]
			then
				echo "Enter Your Password : "				#It prompts the user to enter their password by displaying a message.
				check_password $((index-1))				#It calls the check_password function, passing the index of the matched username in username_array as an argument ($((index-1))).
			fi
		done
		echo "No such username found ."						#If no match is found, it means the entered username does not exist.
											#It displays an appropriate message.
		ask_user 
											#It calls the ask_user function to check whether the user forgot his username.						
		echo "Re-enter your username "						#It prompts the user to re-enter their username by displaying a message.
	   	enter_username								#It recursively calls itself (enter_username) to repeat the process.
}
function check_password ()								#The check_password function verifies if the entered password matches the password associated with a given index from the "passwords.csv" file.
{
	index_no=$1									#The function accepts an index number as a parameter, which represents the position of the password to be checked.
	 read -s passwd									#It reads the user's input for a password and assigns it to the variable passwd. The -s option ensures that the password is not displayed on the screen during input.
	 passwd_array=(`cat passwords.csv`)						#It reads the contents of the "passwords.csv" file and stores them in the passwd_array variable.
	 if [ ${passwd_array[index_no]} = $passwd ]					#It compares the password at the specified index (passwd_array[index_no]) with the entered password ($passwd).
	 then
	 echo
	 echo "Sign in Succcessful"							#If the passwords match, it means the sign-in is successful. The function displays a success message and prompts the user if they want to take a test by calling the ask_test function.
	 echo
	 echo "Want to take test ?(y/n)"
	 ask_test
 	 else										#If the passwords do not match, it means the entered password is incorrect.The function displays an error message, calls the ask_user function to handle the case of forgotten credentials, and prompts the user to re-enter the password by recursively calling itself (check_password) with the same index number.
	  echo "Incorrect Password Entered "
	  ask_user
	  echo "Re_enter Password "
	  check_password $index_no
 fi
}

function ask_test()									#The ask_test function prompts the user to answer whether they want to take a test or not, and performs actions based on the user's response. 
{
	read ch										#It uses the read command to read the user's input and assigns it to the variable ch.
	 	if [ $ch = y ]								#It uses conditional statements (if, elif) to determine the appropriate action based on the value of ch.

 	then
		 take_test								#If the user responds with 'y', it means they want to take a test. The function calls the take_test function to proceed with the test.
 	elif [ $ch = n ]
 	then
		 check_choice								#If the user responds with 'n', it means they do not want to take a test. The function calls the check_choice function to present the main menu options.
	 else
		 echo "Invalid Input !!Enter yes or no (y/n) "				#If the user enters any other value, it means they provided an invalid input. The function displays an error message and recursively calls itself (ask_test) to re-prompt the question until a valid input is received.
	 ask_test
	 fi

}	

function take_test()									#The take_test function allows the user to take a test by presenting questions, recording their answers, and calculating the time taken for each question.					
{
	
	lines=`wc -l questions.csv | cut -d " " -f1`					#It begins by counting the number of lines in the questions.csv file and assigns the result to the variable lines.
	for i in `seq 0 5 $((lines-1))`							#It then iterates through the questions in groups of five (5).
	do
		echo
		tail -$((lines-i)) questions.csv | head -5				#It then displays each group by using tail and head commands.
		echo
		
		for j in `seq 10 -1 1`							#It uses a nested loop to provide a countdown from 10 to 1 to indicate the remaining time to answer the question.
		do

			echo -n -e "\r Enter the option ( a b c d ) : $j "		#For each question, it presents the options (a, b, c, d) to the user and waits for their answer.
			read -t 1 answer						#It reads the user's input and assigns it to the variable answer.
			if [ ${#answer} -ne 0 ]						#It checks if the length of answer is exactly 1 (if [ ${#answer} -eq 1 ]) to ensure that a single option was entered within the given time.
			then
				t=$j							#If a valid answer is provided, it assigns the remaining time ($j) to the variable t and breaks out of the nested loop.
				break
			else
				t=0							#If answer does not have a length of 1, it sets t to 0, indicating a timeout.
				
			fi
		done
		if [ $t = 0 ]								#Based on the value of t, it determines whether the answer was provided within the time limit or if it timed out.
		then 
			echo -e "\n\tTime-Out"
			echo "Time-Out" >> user_answers.csv				#If t is 0, it means the answer timed out. It adds "Time-Out" to both the user_answers.csv and time_taken.csv files.
			echo "Time-Out" >> time_taken.csv
		else
			echo $answer >> user_answers.csv				#If t is not 0, it means a valid answer was provided. It adds the answer to user_answers.csv and the remaining time (10 - t) to time_taken.csv.
			echo $((10-t)) >> time_taken.csv
		fi
	done
	echo
	display_result									#After presenting all the questions and recording the answers and time taken, it displays the test results by calling the display_result function.
    	sed -i 'd' user_answers.csv							#It then permanently removes all the lines from user_answers.csv and time_taken.csv using the sed command to prepare for the next test.
    	sed -i 'd' time_taken.csv	
	echo
	echo "Want to give test again(y/n) ? "						#Finally, it prompts the user if they want to give the test again by displaying a message and calling the ask_test function.
	ask_test
}

function display_result()								# Function to display the test results
{
	echo
	sleep 1s									#It begins by printing some formatting lines to create a visual separation.
	echo "<<------------------------------------------RESULTS OUT ! ! !------------------------------------------>> "
	echo
	sleep 1s
	user_time=(`cat time_taken.csv`)						#It reads the contents of three files: time_taken.csv, user_answers.csv, and answers.csv. These files store the time taken for each question, user's answers, and correct answers, respectively. The data from these files is stored in corresponding arrays: user_time, user_answer, and correct_ans.
	user_answer=(`cat user_answers.csv`)															
	correct_ans=(`cat answers.csv`)
	
	score=0										#It initializes variables score and j to 0. score will keep track of the user's score, and j will be used to access elements in the arrays.
	j=0
	lines=`wc -l questions.csv | cut -d " " -f1`					#It determines the number of lines in the questions.csv file and assigns it to the variable lines.

	for i in `seq 0 5 $((lines-1))`							#It loops through the questions in groups of five (5), displaying each group along with the user's answer, correct answer, time taken, and score for each question.
	do
		echo
		tail -$((lines-i)) questions.csv | head -5
		echo
		if [ ${user_answer[j]} = ${correct_ans[j]} ]
		then									#If the user's answer matches the correct answer, it increments the score by 1 and displays the relevant information along with a score of 1.
			score=$((score+1))
			echo -e "Correct Answer : ${correct_ans[j]}
			\nYour answer : ${user_answer[j]}
		   	\nTime taken : ${user_time[j]} seconds
			\nRemaining Time :$((10-${user_time[j]})) seconds
			\nScore : 1"
		elif [ ${user_answer[j]} = "Time-Out" ]					#If the answer stored in the user answer arrray is "Time-Out", it indicates that the user didn't answer the question on time and displays the correct answer, time taken, remaining time (0 seconds), and a score of 0.
		then
			echo -e "Correct Answer : ${correct_ans[j]}\n
			\nYou didn't answered the Question on Time.
			\nTime taken : 10 seconds
			\nRmaining Time : 0 seconds
			\nScore : 0"
		else									#Otherwise, if the user's answer is incorrect, it displays the relevant information along with a score of 0.
			echo -e "Correct Answer : ${correct_ans[j]}
			\nYour answer : ${user_answer[j]}
		  	\nTime taken : ${user_time[j]} seconds
			\nRemaining Time :$((10-${user_time[j]})) seconds
		   	\nScore : 0"
		fi
		
			j=$((j+1))
	done

	echo										#After displaying all the questions and their details, it prints a separator line and shows the user's total score out of 10.
	echo "<<-------------------------------------------SCORECARD----------------------------------------------->>"
	echo -e "\nYour Total Score : $score out of 10\n" 
	echo "<<--------------------------------------------------------------------------------------------------->>"
}											#Finally, it prints a closing separator line and ends the function.

function ask_user ()									#Function to ask the user if they forgot their Username or Password
{ 
		
	read -p "Did you forgot your credentials (y/n) ? " op				#It uses the read command (with -p option) to prompt the user with a question and the user's response is stored in the variable op.
	if [ $op = y ]									#It uses conditional statements (if, elif) to determine the appropriate action based on the value of op.
	then
		echo "Your Sign In Failed !!"						#If the user responds with 'y', it means they forgot their credentials. The function displays a message indicating that the sign-in failed and calls the check_choice function.
		check_choice
     elif [ $op != n ]									#If the user responds with any value other than 'n', it means they entered an invalid input. The function displays an error message and recursively calls itself (ask_user) to re-prompt the question until a valid input is received.
	 then 
		 echo "Wrong Input"
		 ask_user
	fi

}

											# Function to check the user's choice to continue or exit
function check_choice ()
{
	read -p "Do you want to continue to main menu(y/n) ? " choice 			#Asks user for their choice
	
	if [ $choice = n ]								#If the user enters 'n', the function displays a farewell message,terminates the script, and exits the application.
	then
		echo
		echo "Thanks for using the application :) Have A great day !"
		echo
		exit
	elif [ $choice = y ]								#If the user enters 'y', the function calls the start_task function and then recursively calls itself (check_choice) to repeat the process.
	then
		start_task
		check_choice
	else
		echo "Invalid Input . Please enter y or n"
		check_choice								#If the user enters any other input, the function displays an error message and recursively calls itself (check_choice) to prompt for a valid input.
	fi
}


while [ true ] 										#Here the infinite while loop repeatedly executes the start_task and check_choice functions until the loop is explicitly broken.
do
	start_task									#Within each iteration of the loop, the start_task function is called to present the menu options and handle user input.
	check_choice									#After the start_task function completes, the check_choice function is called to handle the user's choice of continuing or exiting the application.

done											# Once the execution of check_choice is finished, the loop goes back to the beginning and repeats the process.
