import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.Random;


public class main {
    public static  void main(String[] args) throws FileNotFoundException {
        for (int n = 2; n <= 1024; n++){
            for (int i = 0; i < 30; i++){
                int[] randomArray = GenerateArray(n);
                int index = new Random().nextInt(n-1);
                RecursiveSelect r1 = new RecursiveSelect();
                RandomSelect r2 = new RandomSelect();
                int result = r1.Select(randomArray, index, 0, randomArray.length-1);
                int result2 = r2.Select(randomArray, index, 0, randomArray.length-1);
                String recursiveOutput = Integer.toString(n) + "," + Integer.toString(r1.ReturnComparisonCount());
                String randomOutput = Integer.toString(n) + "," + Integer.toString(r2.ReturnComparisonCount());
                WriteOout("Recursive.txt", recursiveOutput);
                WriteOout("Random.txt", randomOutput);
                System.out.println("Recursive: " + recursiveOutput);
                System.out.println("Random: " + randomOutput);
            }
        }
    }

    public static void WriteOout(String fileName, String data) throws FileNotFoundException {
        PrintWriter p = new PrintWriter(new FileOutputStream(new File(fileName), true));
        p.write(data + "\n");
        p.close();
    }

    public static int[] GenerateArray(int size) {
        Random rand = new Random();
        int[] array = new int[size];

        for (int i = 0; i < array.length; i++) {
            array[i] = rand.nextInt(size);
        }
        return array;
    }
}
