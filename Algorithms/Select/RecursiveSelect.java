public class RecursiveSelect {
    public int ComparisonCount = 0;

    public int Partition(int[] array, int a, int b)
    {
        int pivot = array[a];
        while (true)
        {
            while (array[a] < pivot) {
                a++;
                ComparisonCount++;
            }
            while (array[b] > pivot) {
                b--;
                ComparisonCount++;
            }
            ComparisonCount +=2;

            if (a < b)
            {
                int temp = array[b];
                array[b] = array[a];
                array[a] = temp;
                a++;
                b--;
            }
            else
            {
                return b;
            }
        }
    }

    public int Select(int[] array, int k, int a, int b)
    {
        int[] tmpArray = array;
        if(a < b)
        {
            int pivot = Partition(tmpArray, a, b);

            if(k<pivot)
                return Select(tmpArray, k, a, pivot - 1);
            else if(k>pivot)
                return Select(tmpArray, k, pivot + 1, b);
            else
                return tmpArray[pivot];
        }
        else
            return tmpArray[a];

    }

    public int ReturnComparisonCount(){
        return ComparisonCount;
    }
}