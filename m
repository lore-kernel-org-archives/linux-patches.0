Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1921421C
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025958; cv=fail; b=I0oCKLUlTvN5NICaFZL7JW4xLz4U3OM5gLz8uxtR6MX0y1ipjo0LM3Y07CbKLQWAb5dCZZ9LVYYPEeDr5T3jgJ+5+1IgeZcU3d0/0dumLVCtZFRynGlakZHmQN/CL6jae1mZNbBC4qs5ClPdD3HYLzBew671xeF5MZNUsI6eG9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025958; c=relaxed/simple;
	bh=6mhpXYm9wqYdNJlQz1yKoKX3Bdhnp8sE0Ntvwnz495Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=AaNEiERCVzPC2Ew7dEgxWl12h4m2SyyR5uyIf08DBMK7V5gWg+JhcAg/AjH6GQu1i2fUF9XkjG2inM6f0yZk68QAoaaBmAddyRt8BpVdAOHU2dZGREudbR8uRujHYWy/FsZTAvF0eCtPJ8hnMUtSe5A7Zu96B4cbBogvsq8Gfhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z0Fqkepz; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z0Fqkepz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDbiOKCAYTE0Bw3LRPh4iMlo4YgMR6e5GsjyfpqV+JSob2H4bKylfXp/LHdQrWJPS3cbuCYA60Omv7iF1FJjYTv7cBQRZMDd0N5FKrIhUlfk04ntjQWe9ZTik64/GeLpFInkyxe36gGRl9CyOjk4Clnxhr6n+FYlVLr5PGVtSziTMSWl0hysytBcdSR+pU2oSMf7VD/jP1+MdFS2NQWVftnrdodcUAGdLbmc6pakuBuYuP2HChyNQCFfMBklHzZ8RyYfw2ucHG8LR7eR5Vht9lgukXPvaGusuCeojz/pgMBIlqiark4QfCqGJMSIJeqPMznuz1s7MTjmXJJOF0VvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzM2DBx3l4UvygxZOwokyX4n7ro3gZbwwj/0VfOvaDU=;
 b=RVEnHt9hYRYreXbsW1JJRVn2rWHMErf4rqVRfkLJ+BBB3tn4S3HLhHVTPm1mF/SetpdHR6g+LEyuguYSJPkOC011JTJS2LihduEfqYCmcSUVKA+G0w9C2p/aseZharCo/bVjgeqWPAzPMa00mrZJOmoFZFXOywfQTNk2hM49qrnR/jzvLgzGR0X0zRI2/wCeZsHWcTh9R23KHydBggzSw2xb3TYpCLgwU3ohN6J2PvwLcx6SdXMohE5kQg70dsv/jQphXxZuil6JIRoBpvs/dEXoz/gSwX41totjFCydgd6fY5mF6h5M0NROKHPxG+MNf7pIhSlZE3/oc9GWKi/Z/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzM2DBx3l4UvygxZOwokyX4n7ro3gZbwwj/0VfOvaDU=;
 b=Z0Fqkepz4YuATOiHT03XVPi7f7ycMg0kjV7NELs+XA7HJVunko1KK5pnD0NlDb5p5z70AAocwblN5peYMimgoje+88vIipfE58izh35pPtyvOYCSRq2ezA4xuUf2jpR90fOQR8PQNVZuWWzEIHYeDQzWR4QR0J2YcXmns8UtJhw=
Received: from MW4PR03CA0081.namprd03.prod.outlook.com (2603:10b6:303:b6::26)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.17; Thu, 12 Dec
 2024 17:52:32 +0000
Received: from CO1PEPF000066EC.namprd05.prod.outlook.com
 (2603:10b6:303:b6:cafe::20) by MW4PR03CA0081.outlook.office365.com
 (2603:10b6:303:b6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.20 via Frontend Transport; Thu,
 12 Dec 2024 17:52:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066EC.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 17:52:31 +0000
Received: from [10.252.216.179] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 11:52:28 -0600
Message-ID: <d21a8129-e982-463f-af8b-07a14b6a674a@amd.com>
Date: Thu, 12 Dec 2024 23:22:25 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 440/466] sched/core: Remove the unnecessary
 need_resched() check in nohz_csd_func()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Peter Zijlstra <peterz@infradead.org>, Sasha
 Levin <sashal@kernel.org>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144324.242299901@linuxfoundation.org>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20241212144324.242299901@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EC:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a63d16-c38f-4dc4-b360-08dd1ad5c04e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjltamtZS01IVWRma3BOaHd3ZzFCSnBCWkMvbCsyY1FiKzVoZXZodWNrWVNT?=
 =?utf-8?B?VXZ4Vk9sdjBYaHpoUThDTFZCWk1uYm85Ukw1LzNHUFRFNU1wZVhhdVgwSDg4?=
 =?utf-8?B?YWdsM2o0bnFxZUFyUXFwdHR3ejhyNXRzTmpSd0tqUnRTVndUV3p3d0hpYXg1?=
 =?utf-8?B?YWFqNERNNE43ZXB5SmlFWGp0a2lHc0w5SnNGTUdINyt3eDI1UkowTWhUTUhr?=
 =?utf-8?B?S3ZtckNDMHNDVXF2a25TbU1vaGgxQjlkNDFyVkQ0YUw5cTd2MVBhMVllcjFU?=
 =?utf-8?B?OHpUTFdHVG5DR2lVV1JrK0ZVbUhoVjBiM0cxbWFpNHdWMmdNejNhRnlZdXl6?=
 =?utf-8?B?YjZmZFk0aEl6bUdtcWdMNjVlTTgzSzFGUjZXVU9Fb0c1TUNZdGdabzQ1QkdW?=
 =?utf-8?B?T2VNc2IrelVjczlFdjdVMGluWGlQbEhNSk4wS2lyU3dEeS91Rk0vRHNoOWxR?=
 =?utf-8?B?NEJCaTBDdGhNcitCZmFYL3NvNnBHUGtYRGxzVzI0dHJKemZWTEppRHVrd2wz?=
 =?utf-8?B?VEJIekZFVUhQcHZVODFHUnp1V1RuMFgyVzVETUxnUkdaUEJVVkdwQ1FXdExk?=
 =?utf-8?B?a2NCeDcwRjdOd2FGUGFoVzRnTkpGa2RCZUNVRnM0NngwV0JXQ1ZLbS9CM0lq?=
 =?utf-8?B?d0RvdTQwUDlsWjA3TWdLSW5DR1NqSHNYUEh5WWJMRUdMaVZTTnlwNndOOHJw?=
 =?utf-8?B?cVVwQ0Z1MEdhTU00WmNYSXJ3c0prRkkyWU42aDNqaWFYbDdYMkFudHdwYWtW?=
 =?utf-8?B?NmkxRlMremxYaXVVemZVNkd0QTZvZUV6cCtnLzZVdkFpa1VwWUx6cnVORHdM?=
 =?utf-8?B?ZmVmaTlMQk83d3E3QkpwUVZwc2FzVUdBRnhwQVIyWlVzS2hNa3NSSGttM0pD?=
 =?utf-8?B?UjBsT0kxYmh2TTFWSnYwbHVodXlWeFJLengyMmRTL0tGa3pwelY0V21YSFNX?=
 =?utf-8?B?aDFRS0R1cjVZY0dLSTdzcHg0UkVPTlBpS295ajdUVm5hYldyc0tMYzJQWDNo?=
 =?utf-8?B?RzVZWHR4eG8xTTFVRFpTR3p1ck5OMEN0blRnQjFiRzBmN2l1Ym9WbG9HaVYv?=
 =?utf-8?B?NStLNzFwbFFCSWY4bnk5ZGZsbjYvczhPYmFGTkhldllNdXFkazk0RUZCbVN5?=
 =?utf-8?B?TmFyOTRNK25laGtFYlF2ZDJDSVBaTHZaWnNwTnlHWHdsSGZlelV2OGtBS0Vu?=
 =?utf-8?B?RU8wZ0NlQ21MU3N1WFQzZDJQNVdpcXp1MmtWcER5d2EwK1doeENjNy9WdHJt?=
 =?utf-8?B?TzdTZmxpSEltTDJkVVdJYm1Nd1Z3MVVwR05CV1VhSTVNWTFCbXRXa3pmZU9O?=
 =?utf-8?B?eFVUUjYvS3d4eS85VEpwakp4K3gwTE1EYnJmbStXZmQwVklrYVJNRXdNeEdV?=
 =?utf-8?B?MDA1NVg0WDNZaTM4cEowb0xXVGtDVkZyeEFSanBHSENiRHAzU1lna1FDRTRp?=
 =?utf-8?B?NGZCaXVsLzl1SEFuWDFxekl2bG9EMDd0eW5pSzhCV0Z3NCtYNUVkNEprSlZ3?=
 =?utf-8?B?WFJ3eXh0bHJCWVN0UW9hcWMvaDQ1OVk1V3huMGY0b2JISENoaEtpcDI1NTJn?=
 =?utf-8?B?QmorZCt4aVhNNDhObmorcnV5Y0VseHRpckVCaHRGT3R4SVJmak5PWVFqU1NH?=
 =?utf-8?B?YUZTZzkvUWh4ZGVTQ3E3cjlLcUExcnQ1ZlZwMHhWOUxNcHNNSXVGeUxoSHVO?=
 =?utf-8?B?UnFndEx2YWdNQytDT3pVemVSTTBZR1o5aFkyNDdxU1h4Mnk2VTJkb1RqMXlw?=
 =?utf-8?B?MlF4by9ScHZkVkF4N3V2OHJQYXp0YlNzZjRLYkFMRUVRaWZ5OHNtSHBOd09u?=
 =?utf-8?B?VFVCdm1Janp4RFZMbUQ3ejFUSVpZMmxXS3dJYyt5VDdWaFhBa0svcGlNWXNF?=
 =?utf-8?B?TCtmdFo1RU5ZU0dGTDBiOTUybHI1ck5PVEVXNkRlWEsvU1o3WUVWdHFQczFi?=
 =?utf-8?Q?vt08IVr59xk2GZIdujHOlZVFDKl8hnA3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 17:52:31.1499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a63d16-c38f-4dc4-b360-08dd1ad5c04e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

Hello Greg, Sasha,

On 12/12/2024 8:30 PM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: K Prateek Nayak <kprateek.nayak@amd.com>
> 
> [ Upstream commit ea9cffc0a154124821531991d5afdd7e8b20d7aa ]
> 
> The need_resched() check currently in nohz_csd_func() can be tracked
> to have been added in scheduler_ipi() back in 2011 via commit
> ca38062e57e9 ("sched: Use resched IPI to kick off the nohz idle balance")
> 
> Since then, it has travelled quite a bit but it seems like an idle_cpu()
> check currently is sufficient to detect the need to bail out from an
> idle load balancing. To justify this removal, consider all the following
> case where an idle load balancing could race with a task wakeup:
> 
> o Since commit f3dd3f674555b ("sched: Remove the limitation of WF_ON_CPU
>    on wakelist if wakee cpu is idle") a target perceived to be idle
>    (target_rq->nr_running == 0) will return true for
>    ttwu_queue_cond(target) which will offload the task wakeup to the idle
>    target via an IPI.
> 
>    In all such cases target_rq->ttwu_pending will be set to 1 before
>    queuing the wake function.
> 
>    If an idle load balance races here, following scenarios are possible:
> 
>    - The CPU is not in TIF_POLLING_NRFLAG mode in which case an actual
>      IPI is sent to the CPU to wake it out of idle. If the
>      nohz_csd_func() queues before sched_ttwu_pending(), the idle load
>      balance will bail out since idle_cpu(target) returns 0 since
>      target_rq->ttwu_pending is 1. If the nohz_csd_func() is queued after
>      sched_ttwu_pending() it should see rq->nr_running to be non-zero and
>      bail out of idle load balancing.
> 
>    - The CPU is in TIF_POLLING_NRFLAG mode and instead of an actual IPI,
>      the sender will simply set TIF_NEED_RESCHED for the target to put it
>      out of idle and flush_smp_call_function_queue() in do_idle() will
>      execute the call function. Depending on the ordering of the queuing
>      of nohz_csd_func() and sched_ttwu_pending(), the idle_cpu() check in
>      nohz_csd_func() should either see target_rq->ttwu_pending = 1 or
>      target_rq->nr_running to be non-zero if there is a genuine task
>      wakeup racing with the idle load balance kick.
> 
> o The waker CPU perceives the target CPU to be busy
>    (targer_rq->nr_running != 0) but the CPU is in fact going idle and due
>    to a series of unfortunate events, the system reaches a case where the
>    waker CPU decides to perform the wakeup by itself in ttwu_queue() on
>    the target CPU but target is concurrently selected for idle load
>    balance (XXX: Can this happen? I'm not sure, but we'll consider the
>    mother of all coincidences to estimate the worst case scenario).
> 
>    ttwu_do_activate() calls enqueue_task() which would increment
>    "rq->nr_running" post which it calls wakeup_preempt() which is
>    responsible for setting TIF_NEED_RESCHED (via a resched IPI or by
>    setting TIF_NEED_RESCHED on a TIF_POLLING_NRFLAG idle CPU) The key
>    thing to note in this case is that rq->nr_running is already non-zero
>    in case of a wakeup before TIF_NEED_RESCHED is set which would
>    lead to idle_cpu() check returning false.
> 
> In all cases, it seems that need_resched() check is unnecessary when
> checking for idle_cpu() first since an impending wakeup racing with idle
> load balancer will either set the "rq->ttwu_pending" or indicate a newly
> woken task via "rq->nr_running".
> 
> Chasing the reason why this check might have existed in the first place,
> I came across  Peter's suggestion on the fist iteration of Suresh's
> patch from 2011 [1] where the condition to raise the SCHED_SOFTIRQ was:
> 
> 	sched_ttwu_do_pending(list);
> 
> 	if (unlikely((rq->idle == current) &&
> 	    rq->nohz_balance_kick &&
> 	    !need_resched()))
> 		raise_softirq_irqoff(SCHED_SOFTIRQ);
> 
> Since the condition to raise the SCHED_SOFIRQ was preceded by
> sched_ttwu_do_pending() (which is equivalent of sched_ttwu_pending()) in
> the current upstream kernel, the need_resched() check was necessary to
> catch a newly queued task. Peter suggested modifying it to:
> 
> 	if (idle_cpu() && rq->nohz_balance_kick && !need_resched())
> 		raise_softirq_irqoff(SCHED_SOFTIRQ);
> 
> where idle_cpu() seems to have replaced "rq->idle == current" check.
> 
> Even back then, the idle_cpu() check would have been sufficient to catch
> a new task being enqueued. Since commit b2a02fc43a1f ("smp: Optimize
> send_call_function_single_ipi()") overloads the interpretation of
> TIF_NEED_RESCHED for TIF_POLLING_NRFLAG idling, remove the
> need_resched() check in nohz_csd_func() to raise SCHED_SOFTIRQ based
> on Peter's suggestion.

Since v6.12 added support for PREEMPT_RT, you'll see the following
warning being triggered when booting with PREEMPT_RT enabled on
6.12.5-rc1:

     ------------[ cut here ]------------
     WARNING: CPU: 40 PID: 0 at kernel/softirq.c:292 do_softirq_post_smp_call_flush+0x1a/0x40
     Modules linked in:
     CPU: 40 UID: 0 PID: 0 Comm: swapper/40 Not tainted 6.12.5-rc1-test+ #220
     Hardware name: Dell Inc. PowerEdge R6525/024PW1, BIOS 2.7.3 03/30/2022
     RIP: 0010:do_softirq_post_smp_call_flush+0x1a/0x40
     Code: ...
     RSP: 0018:ffffad4c405cfeb8 EFLAGS: 00010002
     RAX: 0000000000000080 RBX: 0000000000000282 RCX: 0000000000000007
     RDX: 0000000000000000 RSI: 0000000000000083 RDI: 0000000000000000
     RBP: 0000000000000000 R08: ffff942efc626080 R09: 0000000000000001
     R10: 7fffffffffffffff R11: ffffffffffd2d2da R12: 0000000000000000
     R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
     FS:  0000000000000000(0000) GS:ffff942efc600000(0000) knlGS:0000000000000000
     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
     CR2: 0000000000000000 CR3: 000000807da48001 CR4: 0000000000f70ef0
     PKRU: 55555554
     Call Trace:
      <TASK>
      ? __warn+0x88/0x130
      ? do_softirq_post_smp_call_flush+0x1a/0x40
      ? report_bug+0x18e/0x1a0
      ? handle_bug+0x5b/0xa0
      ? exc_invalid_op+0x18/0x70
      ? asm_exc_invalid_op+0x1a/0x20
      ? do_softirq_post_smp_call_flush+0x1a/0x40
      ? srso_alias_return_thunk+0x5/0xfbef5
      flush_smp_call_function_queue+0x65/0x80
      do_idle+0x149/0x260
      cpu_startup_entry+0x29/0x30
      start_secondary+0x12d/0x160
      common_startup_64+0x13e/0x141
      </TASK>
     ---[ end trace 0000000000000000 ]---

Could you please also include upstream commit 6675ce20046d ("softirq:
Allow raising SCHED_SOFTIRQ from SMP-call-function on RT kernel") to the
6.12 stable queue to prevent this splat for PREEMPT_RT users.

Full upstream commit SHA1: 6675ce20046d149e1e1ffe7e9577947dee17aad5

The commit can be cleanly cherry-picked on top of v6.12.5-rc1 and I can
confirm that it fixes the splat.

-- 
Thanks and Regards,
Prateek

> 
> Fixes: b2a02fc43a1f ("smp: Optimize send_call_function_single_ipi()")
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lore.kernel.org/r/20241119054432.6405-3-kprateek.nayak@amd.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/sched/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 76b27b2a9c56a..33bc43b223cba 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1242,7 +1242,7 @@ static void nohz_csd_func(void *info)
>   	WARN_ON(!(flags & NOHZ_KICK_MASK));
>   
>   	rq->idle_balance = idle_cpu(cpu);
> -	if (rq->idle_balance && !need_resched()) {
> +	if (rq->idle_balance) {
>   		rq->nohz_idle_balance = flags;
>   		raise_softirq_irqoff(SCHED_SOFTIRQ);
>   	}

