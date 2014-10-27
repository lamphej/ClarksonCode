import java.util.Random;

public class RandomSelect {
    public int ComparisonCount = 0;

    public int Partition(int[] numbers, int a, int b) {
        Random rand = new Random();
        int pivot = numbers[a + rand.nextInt(b - a)];
        while (true) {
            while (numbers[a] < pivot) {
                a++;
                ComparisonCount++;
            }
            while (numbers[b] > pivot) {
                b--;
                ComparisonCount++;
            }
            ComparisonCount++;
            ComparisonCount++;

            if (a < b) {
                int temp = numbers[b];
                numbers[b] = numbers[a];
                numbers[a] = temp;
                a++;
                b--;
            } else {
                return b;
            }
        }
    }

    public int Select(int[] array, int k, int a, int b) {
        int[] tmpArray = array;
        if (a < b) {
            int index = Partition(tmpArray, a, b);

            if (k < index)
                return Select(tmpArray, k, a, index - 1);
            else if (k > index)
                return Select(tmpArray, k, index + 1, b);
            else
                return tmpArray[index];
        } else
            return tmpArray[a];
    }

    public int ReturnComparisonCount() {
        return ComparisonCount;
    }

}
