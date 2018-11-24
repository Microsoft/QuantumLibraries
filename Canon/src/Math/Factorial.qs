namespace Microsoft.Quantum.Canon

{

   //This is a function that given a nonnegative integer n outputs its factorial.

   //The factorial of a nonnegative integer n, usually written as n!, is defined as follows:

   //if n = 0, n! = 1;

   //if n > 0, n! = n (n - 1)!.

   //For instance, 5! = 5 * 4 * 3 * 2 * 1.

    



    function Factorial (n:Int) : (Int)

    {

         

		        mutable f = 0;

      

                       if (n == 0)

			{

				set f = 1;

			}





		        if (n > 0)

			{

				set f = n * Factorial (n - 1);

			}



			return f;

        

    }
