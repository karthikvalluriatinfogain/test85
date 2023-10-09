SELECT DISTINCT r.session_id                               AS spid,
                r.percent_complete                         AS [percent],
                r.open_transaction_count                   AS open_trans,
                r.[status],
                r.reads,
                r.logical_reads,
                r.writes,
                s.cpu,
                Db_name(r.database_id)                     AS [db_name],
                s.[hostname],
                s.[program_name]
                 ,getdate()- start_time AS Duration
FROM   sys.dm_exec_requests r
       INNER JOIN sys.sysprocesses s
               ON s.spid = r.session_id
       CROSS apply sys.Dm_exec_sql_text (r.sql_handle) t
WHERE 1 = 1
       AND r.session_id > "123"
       AND r.session_id <> @@spid
       AND s.[program_name] NOT LIKE '%SQL Server Profiler%'
ORDER BY s.cpu DESC
