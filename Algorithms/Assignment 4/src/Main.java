import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;

/**
 * Created by Jim on 3/31/14.
 */
public class Main{
    public static void main(String[] args) throws FileNotFoundException {
        File f1 = new File("Insertion.txt");
        if (f1.exists()){
            f1.delete();
        }
        File f2 = new File("Selection.txt");
        if (f2.exists()){
            f2.delete();
        }
        File f3 = new File("Quick.txt");
        if (f3.exists()){
            f3.delete();
        }
        File f4 = new File("Merge.txt");
        if (f4.exists()){
            f4.delete();
        }
        File f5 = new File("Heap.txt");
        if (f5.exists()){
            f5.delete();
        }
        for(int i = 2; i <= 1024; i++){
            for (int j = 1; j<= 30; j++) {
                int[] testArray = new int[i];
                for(int l = 0; l < i ; l++){
                    testArray[l] = (int) (Math.random () * 1024);
                }
                System.out.println("==============");
                System.out.println("The Array: Size = " + i);
                System.out.println("==============");
                //Algorithms.PrintArray(testArray);
                SortResult currentResult;

                //Insertion Sort
//                System.out.println("Insertion Sort");
//                System.out.println("Input Array");
//                Algorithms.PrintArray(testArray);
                currentResult = Algorithms.InsertionSort(testArray.clone());
//                System.out.println("Sorted Array");
//                Algorithms.PrintArray(currentResult.sortedArray);
//                System.out.println("Insertion Sort took " + currentResult.runTime + " ms and " + currentResult.comparisonCount + " comparisons.");
                PrintWriter p = new PrintWriter(new FileOutputStream(f1, true));
                p.write(i + "," + currentResult.comparisonCount + "," + currentResult.runTime + "\n");
                p.close();
                System.out.println("==============================");

                //Selection Sort
//                System.out.println("Selection Sort");
//                System.out.println("Input Array");
//                Algorithms.PrintArray(testArray);
                currentResult = Algorithms.SelectionSort(testArray.clone());
//                System.out.println("Sorted Array");
//                Algorithms.PrintArray(currentResult.sortedArray);
//                System.out.println("Selection Sort took " + currentResult.runTime + " ms and " + currentResult.comparisonCount + " comparisons.");
                p = new PrintWriter(new FileOutputStream(f2, true));
                p.write(i + "," + currentResult.comparisonCount + "," + currentResult.runTime + "\n");
                p.close();
                System.out.println("==============================");

                //Quick Sort
//                System.out.println("Quick Sort");
//                System.out.println("Input Array");
//                Algorithms.PrintArray(testArray);
                currentResult = Algorithms.QuickSort(testArray.clone());
//                System.out.println("Sorted Array");
//                Algorithms.PrintArray(currentResult.sortedArray);
//                System.out.println("Quick Sort took " + currentResult.runTime + " ms and " + currentResult.comparisonCount + " comparisons.");
                p = new PrintWriter(new FileOutputStream(f3, true));
                p.write(i + "," + currentResult.comparisonCount + "," + currentResult.runTime + "\n");
                p.close();
                System.out.println("==============================");

                //Merge Sort
//                System.out.println("Merge Sort");
//                System.out.println("Input Array");
//                Algorithms.PrintArray(testArray);
                currentResult = Algorithms.MergeSort(testArray.clone());
//                System.out.println("Sorted Array");
//                Algorithms.PrintArray(currentResult.sortedArray);
//                System.out.println("Merge Sort took " + currentResult.runTime + " ms and " + currentResult.comparisonCount + " comparisons.");
                p = new PrintWriter(new FileOutputStream(f4, true));
                p.write(i + "," + currentResult.comparisonCount + "," + currentResult.runTime + "\n");
                p.close();
                System.out.println("==============================");

                //Heap Sort
//                System.out.println("Heap Sort");
//                System.out.println("Input Array");
//                Algorithms.PrintArray(testArray);
                currentResult = Algorithms.HeapSort(testArray.clone());
//                System.out.println("Sorted Array");
//                Algorithms.PrintArray(currentResult.sortedArray);
//                System.out.println("Heap Sort took " + currentResult.runTime + " ms and " + currentResult.comparisonCount + " comparisons.");
                p = new PrintWriter(new FileOutputStream(f5, true));
                p.write(i + "," + currentResult.comparisonCount + "," + currentResult.runTime + "\n");
                p.close();
                System.out.println("==============================");
            }
        }
    }
}
