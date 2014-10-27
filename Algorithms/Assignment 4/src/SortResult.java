public class SortResult {
    public int[] sortedArray;
    public  int comparisonCount;
    public long runTime;

    public SortResult(int[] array, int comparisons, long runtime){
        sortedArray = array;
        comparisonCount = comparisons;
        runTime = runtime;
    }
}
