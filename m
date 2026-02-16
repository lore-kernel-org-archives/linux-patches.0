Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAE02C11C4;
	Mon, 16 Feb 2026 04:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771216080; cv=fail; b=eOjf/+15XBN6jVzTtwlUAmd2ysF5yU5K2s7ahoxq93z2N4RqOm3DaTbwhW62IBJ7BETTCm1lRKG8NWUbIGT74pptvjYtBgRx2mLl+Fg+uoPmEk4W5J9ibT6yfWTbxMyqqYpIP9kgrWUw1RrAzGZGYnuxygcrTD2ZRiu8vrjHX5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771216080; c=relaxed/simple;
	bh=K7A3Sv2tNofkIMwWoTIwZgDsegZsa5oDEABUsiAQa00=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cf5Ak3nctqBjUtH9RgRstetBpFELbBselHfPdscjuHOcZt2AarHwPZ911D3/RnNWJScUt4SIbk66DHQWTmb9v4kNM2QncknWHtHRNbIyUB3B0GarNMIdJD+h6fDY2mCQn7XZ5513v96yiQUppDJdY5yapTsLfGFWCki0YY9QhdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4yM8kj4B; arc=fail smtp.client-ip=40.93.201.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4yM8kj4B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jYqykuX0wLNbaxLWNRvF/aM42pI0+yHk3mnEeF9TSz0JxQwdyGpTe6FPtnt53hneDUZf/uWgSwI50mTrIDc9ASVR4CDEszJzd+rkhBzr3qh/jge3LCAP6i3R17UDHnmUZjGHtNKGoHYAd27glmHyktU0vx9gxYZ/LrmRv5lJc6dZjwuMk12eHLl8lLLBf+IRvyon0fed/JdJ5bUoj19GSyncf8Mh7GPV2wdVk6HwgewaseCS4ux8FnlCxg1Yr+bCorZewlgKsSzkMTVlIvKMz2jqzeROvxrRkF8UaGg6oTuVgWxK1wze6Ei0pawO2pI54aE3JzAupdENCYSqknlecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dfB+8pbQjNY6cJ1YQJcgDbcJ102r+3pkmj5Ggd04TU=;
 b=k9jfJ3aKjRchOHloq+9VLMcDBeTRdeT+WiLsq8cAafKlHEfAFD8E3PcuaE0nNELIRynAQWIftVb5Zk0DN/uSQmTW+EVkKEosFkX8bbmKuVQKGVX8bTo7GI+cCnrSXxLmjE9QmqiqqL5xVxegNu8C9RFbPplXakTmRQHgu7rASSQu8wRQKBVK6qiBz7rmPVtGy4fx5NYqdCpSmL1TwQNbDKn5KB0a5BdeSXEIovMjZDlssblNEkWlut5TBvRbO8jdSLXBths84d0BiozpcVLw6aW86gGsKnsIH0nIEFbOeBs+8e6vb7qV6Jhhs3bR3S8DdEw6ean/4C5k2IwsZc0cdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dfB+8pbQjNY6cJ1YQJcgDbcJ102r+3pkmj5Ggd04TU=;
 b=4yM8kj4BRV3B7DcDxzmfFYm/j7PRvSMNw1aJn4dMF2RWbdIyWT/ZUCmkichzNBA6kQLmcW7occKB0fWxLZ9KaJXfioSC4Yu4OvhH1l+XvVdX/cMDc2uMc7ZHbp/lUqrUXlG+9+bIokjndibQXvUrw9YI9G9bIbLmZD1RGGPTddI=
Received: from SJ0PR03CA0192.namprd03.prod.outlook.com (2603:10b6:a03:2ef::17)
 by IA1PR12MB6604.namprd12.prod.outlook.com (2603:10b6:208:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 04:27:53 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::b8) by SJ0PR03CA0192.outlook.office365.com
 (2603:10b6:a03:2ef::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Mon,
 16 Feb 2026 04:27:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 16 Feb 2026 04:27:52 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 15 Feb
 2026 22:27:52 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 15 Feb
 2026 22:27:51 -0600
Received: from amd.com (10.180.168.240) by satlexmb07.amd.com (10.181.42.216)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 15 Feb 2026 22:27:50 -0600
Date: Mon, 16 Feb 2026 04:27:39 +0000
From: Ankit Soni <Ankit.Soni@amd.com>
To: Sasha Levin <sashal@kernel.org>
CC: <patches@lists.linux.dev>, <stable@vger.kernel.org>, Vasant Hegde
	<vasant.hegde@amd.com>, Joerg Roedel <joerg.roedel@amd.com>,
	<joro@8bytes.org>, <iommu@lists.linux.dev>
Subject: Re: [PATCH AUTOSEL 6.19-6.6] iommu/amd: move wait_on_sem() out of
 spinlock
Message-ID: <igfz7pgt4cfa267cgz2kmbv6hqcenv6ciyphxxovkahkvl2p2a@3gekp2natjr4>
References: <20260214212452.782265-1-sashal@kernel.org>
 <20260214212452.782265-94-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260214212452.782265-94-sashal@kernel.org>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|IA1PR12MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: d3927035-4ec1-4cce-f1d8-08de6d13c03b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHBPVFkxTDFKU2RIMGVtcWRFZ2pYYXp0VTVMdnZnbXdPWVNIQXpJaXB4ZzRK?=
 =?utf-8?B?alh2MUM4NTUzNWF6OTJKTXBUR1FmenI4S2RzejNzd2RPQWpYQ0tTY2F2Nk1m?=
 =?utf-8?B?T0l0WjduenNjYnRGRU51NFVORDZYUXFGbG1hQTU2UDJOeUM5NFNnM0NXMkRP?=
 =?utf-8?B?TVlQeG9XSi9HZno0Z3E0N256Rng4b0hhWVBUd0ovNU9yMkpYbG5SMlBYL2Er?=
 =?utf-8?B?Q0M1Q1RYZzh2MTQ2RDJjRHVXRzNTMWtQQjYwWUN0akNrejhkeW1YUk1lZEIr?=
 =?utf-8?B?ZUlCMGpoMm05WnJQNTc4eG5LNTRVQ0RKSEx0b1k1aERCMzJpWnpwY3lsa1da?=
 =?utf-8?B?dmo3NWt4MWhvU1dYaktqZytyRTFDbjdpc2pLcVBLb2tDcmpkK2g2bDN2SU9i?=
 =?utf-8?B?bmF5YUdlSEtGVE9wcWlBZWhzYnBEWW14SVFmbW5vQklpMjlYU3k3NHVDR0kr?=
 =?utf-8?B?OEhGVmZFV1BpYlpCQUhnRzBpTk5lNkhhVzdra2R5SkZTVUwwaElwUk9hRWFW?=
 =?utf-8?B?WDIwcEprYUF1NlVWdmtWaHhla3hBR1hWekR1R3NwNmZLRDE4SzlrS2xnQVJ3?=
 =?utf-8?B?OXF4ZEQ5N3dJU2lCS3NoVXdCYkFXNG5HdFpPVEdKMm0yNCtVSk9QTEVURUVV?=
 =?utf-8?B?YU43b1V6ZDNadlowTi96OWRtVHRxdHpQd1FuODRWajRLMEJ2aUpvNlo2dUF4?=
 =?utf-8?B?N0NMNU1pc3lKSDZjWjI5UGxlaHFuTEl2N1ptTEFGak1yZ0lTR0g3aHlMWnZs?=
 =?utf-8?B?aDdmemNXNUowUWRWSFNScDduWmUvMWdLUnd2YVU1eXU4b3llSEx0bFZYd0NR?=
 =?utf-8?B?RWgrajRRbjU3aEd6S0tLQ3NRQXpERWJnK3hSUzI1U1E3aUZmc2Q2S29zUFMv?=
 =?utf-8?B?dlRlUjl6SjJLN2VRRUllY0hJNG54ZTg0VVNxNTdRNVE0NVVQVzlPcXFUTVNT?=
 =?utf-8?B?R3oraGh4T0lBUnVkQXpJYlJ3dU1qOWVJZDQ1NWRjL0JlZ2M2cjQwMURKcUx4?=
 =?utf-8?B?RStOYVpnWE00WHg1WkZwQjQyckJaSkhSRTh5cE00akZxaVJhUFJxUFN4L1lL?=
 =?utf-8?B?THB3bm5JK2tqRDRCUzlSQkNnZVF6cXp2VUJ5Y2xlNUtzSy9UR2NyN21kcExj?=
 =?utf-8?B?Witic2xZL3RyNGh2V3lsVzh0Z1NUbmFld2FmWUxZL2ZYaEpLd3NKc3JuU3R5?=
 =?utf-8?B?Vk8reXlvbUlrMXN4N3B6eVhpQlJOc1RmT2VGY2thNnROcSt1Zm1kWnpqMTdy?=
 =?utf-8?B?ZkxWdCtIMW9mKzVYc00xSnh2RW9tbkNaVFpqT1h3RG82NkdWRUtpM3ZNVDR6?=
 =?utf-8?B?dTZjQVBNaHJyVWJYUFZSWDhJQU5NSmZBbTRVc2l1YlhPQ011elJDc1JKY09h?=
 =?utf-8?B?MHA4S0FrTllISDVHeHA3QytoS1huei80eGtZVjc3Mk5FTS95KzhyT3I3SUx6?=
 =?utf-8?B?cmsrMDgzVitHdmMrY0FZVUNrQUdpbmszME4vUXNXMm1LS0ZtYTFPQXl5Vng5?=
 =?utf-8?B?TStXd1RwejViTlpnQ0hGckpyMFd5RyswR1RwNXF0SVQ3UnhQMzM3b0FYb25D?=
 =?utf-8?B?N0l2eXE1NjRoajN4Tm9WV2VmaFpvR3dpSXdxVEgrT1RLUUd2d0RORytnemIv?=
 =?utf-8?B?bTZ0K2IvSGpxV29UdWZBOVJRL3k0RjA3SEdYRWZmNFQ2S2poMVdRTHhOKzZa?=
 =?utf-8?B?ZFk3Qk9TaVFQWDRzSkZzYW1BWXcrbTI2ZjRmWG5BTjdVS2x1Ym1UOFlRdFVv?=
 =?utf-8?B?YUZ0TG14OFJhY2RuTmNIb29WSkMrWkQ1L2R3ZlhlQlQ1NEJibjF2ZmtkUTBZ?=
 =?utf-8?B?UVFoWG02MUwwcytIc2g4UVVGNXdQQjl0eTFURnFBVkNwZ2JkOTZuRlNKc3d6?=
 =?utf-8?B?OVdaYmRxenQwbFJ1dGtiMkNuTHhaNVVTRm1YdWlFeUFHazREWEwxdFZrT0lY?=
 =?utf-8?B?U2YyWFJTM2h0dXNHS3I4cXE3Z3hUcmt1KzJnQSthVkFpVXhKNW5wM0JhQ2I4?=
 =?utf-8?B?WS82cDdPZ3FDeXArL3dJMk0rdDF6aHl1dVltSTlMVHA4NmNTQ3ppbE9sYWRu?=
 =?utf-8?B?ZEI5aWE3OHArNUxaLzF4Z21hMG1Bc2ZBeDdId3VSd3ZOZWlsV2pBc0NkcWtn?=
 =?utf-8?B?UnFKSzhOUEdjQ09KaXV5S2FjWitxS2ozTThveU5SYTlIU0dUbGEvbWphR3JT?=
 =?utf-8?B?YmFEeW51bWRqK2lzU0lCSmZzdDNsK1J3WnRBbHJpZWxvNTJjZmZMSW9hSFhC?=
 =?utf-8?B?c3JrdzM3Q2FRaXAvTDd4S083SmdnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+nTPjCw5J2i9HkELT4ab8O59bThJx2+MgnO+94N88s6JonJAgKAfqMqNQ/E3WIhCEstjnGcDAxRHFZEbSs8tgcTtRopj7cGPbEpG2dpGHIzSD5AO48nGI4/yg9vyytV4VZWWbv0S76J53EyLK80anBXDNQKqdjI6PUizyho2z6Talm2f70rc4bTnRz7D+ltqYDTEFrj5O+mK2zfWKekF+6Nq+zT0pNPoz4xiDuBnQRs/I53o/LwJpqC0+EALwLPAbFiasUTdZqGGrPS3AuWwxts25VOmLORqxuDkWB6cRHMHvzB/uxBGvZwSNnrYrAXqPKWnuJDAmfCvDN1SUWOxMgDQaAhBBvxbnSZSenh3k2981Qn5y5xQWHhLEaowFw1j1h19NzuFNvtND0Dq0Cm+Nx8EBXIaH+3S+j2wG5WNFTYj83UeCAX+tVZJgGG1Zauk
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 04:27:52.9054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3927035-4ec1-4cce-f1d8-08de6d13c03b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6604

On Sat, Feb 14, 2026 at 04:23:59PM -0500, Sasha Levin wrote:
> From: Ankit Soni <Ankit.Soni@amd.com>
> 
> [ Upstream commit d2a0cac10597068567d336e85fa3cbdbe8ca62bf ]
> 
> With iommu.strict=1, the existing completion wait path can cause soft
> lockups under stressed environment, as wait_on_sem() busy-waits under the
> spinlock with interrupts disabled.
> 
> Move the completion wait in iommu_completion_wait() out of the spinlock.
> wait_on_sem() only polls the hardware-updated cmd_sem and does not require
> iommu->lock, so holding the lock during the busy wait unnecessarily
> increases contention and extends the time with interrupts disabled.
> 
> Signed-off-by: Ankit Soni <Ankit.Soni@amd.com>
> Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I understand the full picture. Let me analyze the commit as
> presented in the diff.
> 
> ### 3. Bug Being Fixed
> 
> **Soft lockup**: `wait_on_sem()` busy-waits for up to ~100ms
> (`LOOP_TIMEOUT=100000` iterations of `udelay(1)`) while holding
> `iommu->lock` with interrupts disabled via `raw_spin_lock_irqsave`.
> Under heavy IOMMU flush activity with `iommu.strict=1`, this can trigger
> soft lockup warnings and starve other CPUs waiting for the same lock.
> 
> This is a **real, user-visible stability issue** - soft lockups cause
> watchdog warnings and can lead to system hangs on heavily-loaded systems
> using AMD IOMMU with strict mode.
> 
> ### 4. Changes in Detail
> 
> **Change A: `wait_on_sem()` comparison logic**
> - Old: `*iommu->cmd_sem != data` — exact equality match
> - New: `(__s64)(READ_ONCE(*iommu->cmd_sem) - data) < 0` — monotonic "not
>   yet reached" check
> 
> This is critical for correctness when moving `wait_on_sem()` outside the
> lock. With the lock held, commands were strictly serialized. Outside the
> lock, the semaphore value could jump past the expected value if a later
> completion overtakes the check. The monotonic comparison handles this
> correctly. The `READ_ONCE` also prevents compiler optimization issues.
> 
> **Change B & C: Moving `wait_on_sem()` outside spinlock**
> In both `iommu_completion_wait()` and `iommu_flush_irt_and_complete()`,
> the spinlock is released immediately after queueing commands, before the
> busy-wait.
> 
> ### 5. Concurrency Safety Analysis
> 
> The subagent raised a concern about a race condition: the
> `atomic64_inc_return` happens OUTSIDE the lock, so concurrent callers
> could get sequence numbers allocated out of order relative to command
> queue insertion.
> 
> **However, the monotonic comparison (`< 0` on signed difference) in the
> updated `wait_on_sem()` makes this safe**:
> 
> Consider the scenario:
> - Thread A gets seq=1, Thread B gets seq=2
> - Thread B queues completion wait for 2, Thread A queues completion wait
>   for 1
> - IOMMU processes: completion_wait(2) first, then completion_wait(1)
> - cmd_sem is written to 2, then 1
> 
> With old `!=` comparison:
> - Thread A waits for `cmd_sem == 1` — would work when IOMMU writes 1
> - Thread B waits for `cmd_sem == 2` — would see cmd_sem jump from 2→1,
>   missing the match!
> 
> With new `(__s64)(cmd_sem - data) < 0` comparison:
> - Thread B waits for `cmd_sem >= 2` — satisfied when cmd_sem=2
> - Thread A waits for `cmd_sem >= 1` — satisfied when cmd_sem=2 (or 1)
> - **But wait**: cmd_sem is written to 2, then 1. After hardware writes
>   1, the value is 1. Thread B checking `cmd_sem >= 2` would fail because
>   cmd_sem=1!
> 

Hi,

It’s a good catch and a valid potential issue. However, Srikanth Aithal
already reported this earlier, and a fix has been added.
Please check the link below
https://lore.kernel.org/linux-iommu/c20ac675bae8565ca6307eae65efe8b71345e62d.1769054653.git.Ankit.Soni@amd.com/

Thanks,
Ankit

> Actually, this analysis reveals there IS a potential issue with out-of-
> order sequence numbers being written non-monotonically. But the key
> insight from the commit message is: "cmd_sem holds a monotonically non-
> decreasing completion sequence number." The hardware writes the values
> in command buffer order, and even though the queue insertions might
> reorder, each individual thread's `wait_on_sem()` checks if its own
> value has been reached. With the monotonic comparison, if the hardware
> writes 2 (from Thread B's command) first, Thread A (waiting for 1) would
> see `cmd_sem=2 >= 1` and proceed. Then the hardware writes 1 (from
> Thread A's command), which doesn't regress because... actually it would
> set cmd_sem to 1 after it was 2.
> 
> This is actually where the companion patch becomes relevant. However,
> examining more carefully: in the pre-patch code, the
> `atomic64_inc_return` was also done outside the lock! Look at the
> current code at line 1434 — `data =
> atomic64_inc_return(&iommu->cmd_sem_val)` is before
> `raw_spin_lock_irqsave` at line 1437. So the out-of-order sequence
> number issue **already exists** in the current code. This patch doesn't
> make it worse; it actually makes it better by changing from exact
> equality to monotonic comparison.
> 
> ### 6. Risk Assessment
> 
> - **Files changed**: 1 file
> - **Lines changed**: ~25 lines of actual logic change (moving unlock,
>   changing comparison)
> - **Subsystem**: AMD IOMMU — important for AMD server/desktop users
> - **Risk**: LOW — the change is logically sound; `wait_on_sem()` only
>   reads a hardware-updated memory location
> - **Regression potential**: LOW — the lock still protects command buffer
>   operations; only the polling is moved outside
> 
> ### 7. Dependency Check
> 
> The commit is self-contained. While a companion commit exists to further
> improve correctness by serializing sequence allocation under the lock,
> this commit stands on its own:
> 1. It fixes the immediate soft lockup problem
> 2. The monotonic comparison improves correctness over the existing `!=`
>    check
> 3. The pre-existing race with `atomic64_inc_return` outside the lock is
>    not made worse
> 
> ### 8. Classification
> 
> - **Bug type**: Soft lockup / system hang — HIGH priority for stable
> - **User impact**: Users with AMD IOMMU and `iommu.strict=1` under heavy
>   I/O can experience soft lockups
> - **Fix quality**: Reviewed by AMD developer, merged by subsystem
>   maintainer
> - **Stable criteria**: Obviously correct, fixes a real bug, small scope,
>   no new features
> 
> ### Conclusion
> 
> This commit fixes a real soft lockup bug that can cause system hangs on
> AMD IOMMU systems under stress with `iommu.strict=1`. The fix is small,
> surgical (moving the busy-wait outside the spinlock), and logically
> sound — `wait_on_sem()` only polls hardware-updated memory and doesn't
> need the lock. The additional improvement to the comparison logic
> (monotonic instead of equality) is also correct and prevents false
> timeouts. The commit is from AMD's own developer, reviewed by another
> AMD developer, and merged by the IOMMU maintainer.
> 
> The fix meets all stable kernel criteria: it fixes a real stability
> issue (soft lockups), is small and contained, doesn't add new features,
> and has low regression risk.
> 
> **YES**
> 
>  drivers/iommu/amd/iommu.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 7c12be1b247f4..c8b65d6d971e0 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1185,7 +1185,12 @@ static int wait_on_sem(struct amd_iommu *iommu, u64 data)
>  {
>  	int i = 0;
>  
> -	while (*iommu->cmd_sem != data && i < LOOP_TIMEOUT) {
> +	/*
> +	 * cmd_sem holds a monotonically non-decreasing completion sequence
> +	 * number.
> +	 */
> +	while ((__s64)(READ_ONCE(*iommu->cmd_sem) - data) < 0 &&
> +	       i < LOOP_TIMEOUT) {
>  		udelay(1);
>  		i += 1;
>  	}
> @@ -1437,14 +1442,13 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
>  	raw_spin_lock_irqsave(&iommu->lock, flags);
>  
>  	ret = __iommu_queue_command_sync(iommu, &cmd, false);
> +	raw_spin_unlock_irqrestore(&iommu->lock, flags);
> +
>  	if (ret)
> -		goto out_unlock;
> +		return ret;
>  
>  	ret = wait_on_sem(iommu, data);
>  
> -out_unlock:
> -	raw_spin_unlock_irqrestore(&iommu->lock, flags);
> -
>  	return ret;
>  }
>  
> @@ -3120,13 +3124,18 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
>  	raw_spin_lock_irqsave(&iommu->lock, flags);
>  	ret = __iommu_queue_command_sync(iommu, &cmd, true);
>  	if (ret)
> -		goto out;
> +		goto out_err;
>  	ret = __iommu_queue_command_sync(iommu, &cmd2, false);
>  	if (ret)
> -		goto out;
> +		goto out_err;
> +	raw_spin_unlock_irqrestore(&iommu->lock, flags);
> +
>  	wait_on_sem(iommu, data);
> -out:
> +	return;
> +
> +out_err:
>  	raw_spin_unlock_irqrestore(&iommu->lock, flags);
> +	return;
>  }
>  
>  static inline u8 iommu_get_int_tablen(struct iommu_dev_data *dev_data)
> -- 
> 2.51.0
> 
