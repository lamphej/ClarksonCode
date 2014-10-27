import java.util.Arrays;

/**
 * Created by James Lamphere.
 */
public class Algorithms {
    public static void PrintArray(int[] array){
        System.out.print("[");
        for (int i = 0; i < array.length - 1; i ++){
            System.out.print(array[i] + ",");
        }
        System.out.print(array[array.length - 1] + "]\n");
    }

    public static int[] Partition(int[] array, int first, int last){
        int pivotValue = array[first];
        int leftMark = first + 1;
        int rightMark = last;
        int tmpValue;
        int comparisonCount = 0;
        boolean done = false;
        while (!done){
            while (leftMark <= rightMark && array[leftMark] <= pivotValue){
                comparisonCount += 1;
                leftMark += 1;
            }
            while (array[rightMark] >= pivotValue && rightMark >= leftMark){
                comparisonCount += 1;
                rightMark -= 1;
            }
            if (rightMark < leftMark){
                done = true;
            }
            else{
                SwapArray(array, leftMark, rightMark);
            }
        }
        if (leftMark < array.length && rightMark < array.length) {
            SwapArray(array, leftMark, rightMark);
        }
        return new int[]{rightMark, comparisonCount};
    }

    public static SortResult InsertionSort(int[] array){
        long startTime = System.currentTimeMillis();
        int comparisonCount = 0;
        int[] tmpArray = array;
        for (int i = 1; i < tmpArray.length; i++){
            int currentValue = tmpArray[i];
            int currentPos = i;
            while (currentPos > 0 && tmpArray[currentPos-1] > currentValue){
                tmpArray[currentPos] = tmpArray[currentPos-1];
                currentPos -= 1;
                comparisonCount += 1;
            }
            comparisonCount += 1;
            tmpArray[currentPos]=currentValue;
        }
        return new SortResult(tmpArray, comparisonCount, System.currentTimeMillis() - startTime);
    }

    public static void SwapArray(int[] array, int x, int y){
        int tmpValue = array[x];
        array[x] = array[y];
        array[y] = tmpValue;
    }

    public static SortResult SelectionSort(int[] array){
        long startTime = System.currentTimeMillis();
        int comparisonCount = 0;
        int[] tmpArray = array;
        for (int i = tmpArray.length - 1; i > 0; i --){
            int posOfMax = 0;
            for (int location = 1; location < i+1; location++){
                comparisonCount += 1;
                if (tmpArray[location] > tmpArray[posOfMax]){
                    comparisonCount += 1;
                    posOfMax = location;
                }
            }
            SwapArray(tmpArray, i, posOfMax);
        }
        return new SortResult(tmpArray, comparisonCount, System.currentTimeMillis() - startTime);
    }

    public static SortResult QuickSort(int[] array){
        long startTime = System.currentTimeMillis();
        int comparisonCount = 0;
        int[] tmpArray = array;
        comparisonCount += QuickSortHelper(tmpArray, 0 , tmpArray.length - 1);
        return new SortResult(tmpArray, comparisonCount, System.currentTimeMillis() - startTime);
    }

    public static int QuickSortHelper(int[] array, int first, int last){
        int cc = 0;
        if (first < last){
            int[] splitPointRes = Partition(array, first, last);
            cc = splitPointRes[1];
            cc += QuickSortHelper(array, first, splitPointRes[0] - 1);
            cc += QuickSortHelper(array, splitPointRes[0] + 1, last);
        }
        return cc;
    }

    public static SortResult MergeSort(int[] array){
        long startTime = System.currentTimeMillis();
        int comparisonCount = 0;
        int[] tmpArray = array;
        if (tmpArray.length > 1){
            int midPoint = tmpArray.length / 2;
            int[] leftHalf = Arrays.copyOfRange(tmpArray, 0, midPoint);
            int[] rightHalf = Arrays.copyOfRange(tmpArray, midPoint, tmpArray.length - 1);
            comparisonCount += MergeSort(leftHalf).comparisonCount;
            comparisonCount += MergeSort(rightHalf).comparisonCount;
            int i = 0, j = 0, k = 0;
            while (i < leftHalf.length && j < rightHalf.length){
                if (leftHalf[i] < rightHalf[j]){
                    comparisonCount += 1;
                    tmpArray[k] = leftHalf[i];
                    i = i + 1;
                }
                else{
                    comparisonCount += 1;
                    tmpArray[k] = rightHalf[j];
                    j = j + 1;
                }
                k = k + 1;
            }

            while (i < leftHalf.length){
                tmpArray[k] = leftHalf[i];
                i = i + 1;
                k = k + 1;
            }

            while (j < rightHalf.length){
                tmpArray[k] = rightHalf[j];
                j = j + 1;
                k = k + 1;
            }
        }
        return new SortResult(tmpArray, comparisonCount, System.currentTimeMillis() - startTime);
    }

    public static SortResult HeapSort(int[] array){
        long startTime = System.currentTimeMillis();
        int comparisonCount = 0;
        int[] tmpArray = array;
        for (int heapSize = 0; heapSize < array.length; heapSize++){
            int n = heapSize;
            while (n > 0){
                int p = (n - 1) / 2;
                if (array[n] > array[p]){
                    comparisonCount += 1;
                    SwapArray(array, n, p);
                    n = p;
                }
                else{
                    break;
                }
            }
        }
        for (int heapSize = array.length; heapSize>0;){
            SwapArray(array, 0, --heapSize);
            int n = 0;
            while (true){
                int left = (n * 2) + 1;
                if (left >= heapSize){
                    break;
                }
                int right = left + 1;
                if (right >= heapSize){
                    if (array[left] > array[n]){
                        comparisonCount += 1;
                        SwapArray(array, left, n);
                    }
                    break;
                }
                if (array[left] > array[n]){
                    if (array[left] > array[right]){
                        comparisonCount += 1;
                        SwapArray(array, left, n);
                        n = left;
                    }
                    else{
                        comparisonCount += 1;
                        SwapArray(array, right, n);
                        n = right;
                    }
                }
                else{
                    if (array[right] > array[n]){
                        comparisonCount += 1;
                        SwapArray(array, right, n);
                        n = right;
                    }
                    else{
                        comparisonCount += 1;
                        break;
                    }
                }
            }
        }
        return new SortResult(tmpArray, comparisonCount, System.currentTimeMillis() - startTime);
    }
}

