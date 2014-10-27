package A3;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by Jim on 4/23/14.
 */
public class Main {
    public static void main(String[] args){
        int[] tmpArray;
        int index;
        for (int i = 2; i<=1024; i++){
            tmpArray = new int[i];
            for (int x = 0; x < i; x++){
                tmpArray[x] = randInt(1, i);
            }
            index = randInt(0, i - 1);
            int selected = Select(tmpArray, index);
            System.out.println(selected);
        }
    }

    public static int Select(int[] arr, int k) {
        int comparisons = 0;
        if (arr == null || arr.length <= k)
            throw new Error();
        int from = 0, to = arr.length - 1;
        while (from < to) {
            int r = from, w = to;
            int mid = arr[(r + w) / 2];
            while (r < w) {
                comparisons += 1;
                if (arr[r] >= mid) {
                    int tmp = arr[w];
                    arr[w] = arr[r];
                    arr[r] = tmp;
                    w--;
                } else {
                    r++;
                }
            }
            if (arr[r] > mid)
                r--;
            if (k <= r) {
                to = r;
            } else {
                from = r + 1;
            }
        }
        return arr[k];
    }


//    public static int Select(int[] array, int k){
//        int m = array[randInt(0, array.length - 1)];
//        List<Integer> s1 = new ArrayList<Integer>();
//        List<Integer> s2 = new ArrayList<Integer>();
//        int ss = 0;
//        int ss1 = 0;
//        int ss2 = 0;
//        for (int i = 0; i < array.length; i++){
//            ss += array[i];
//            if (array[i] < m){
//                s1.add(array[i]);
//                ss1 += array[i];
//            }
//            else if (array[i] > m){
//                s2.add(array[i]);
//                ss2 += array[i];
//            }
//        }
//        int[] as1 = new int[s1.size()];
//        int[] as2 = new int[s2.size()];
//        for (int i = 0; i < s1.size(); i++){
//            as1[i] = s1.get(i);
//        }
//        for (int i = 0; i < s2.size(); i++){
//            as2[i] = s2.get(i);
//        }
//        if (ss1 >= k){
//            return Select(as1, k);
//        }
//        else if ((ss1 - ss2) >= k){
//            return m;
//        }
//        else{
//            return Select(as2, k - ss + ss2);
//        }
//    }

    public static int randInt(int min, int max) {

        Random rand = new Random();
        if (max > min){
            int randomNum =  rand.nextInt((max - min) + 1) + min;

            return randomNum;
        }
        else{
            return max;
        }
    }
}
