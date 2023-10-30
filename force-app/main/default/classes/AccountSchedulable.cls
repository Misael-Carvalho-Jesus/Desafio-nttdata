public class AccountSchedulable implements Schedulable {
    
    public static void start() {
        List<String> times = new List<String>{'0 0 1 ? * MON-FRI', '0 0 7 ? * MON-FRI', '0 0 13 ? * MON-FRI', '0 0 19 ? * MON-FRI'};
        for (String sch : times) {
            System.schedule('Limpeza de contas inativas', sch, new AccountSchedulable());
        }
    }

    public void execute(SchedulableContext context) {
        Database.executeBatch(new AccountBatch(), 200);
    }
}