Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4848B187339
	for <patches@lists.linux.dev>; Mon, 17 Jun 2024 22:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718663807; cv=fail; b=dlCVsqXgMRxGDAcqiz1cnQIYNX6v9oisnhSAKLZUlTgrvuvocUg35umG2YlvuRvBrK6byRRSioWeafw20nxNy229oIOG4h6sgHlui6UQ5rcGDVGqonVnakQeeJMikbIDdWBvQOsksyRWCzCjliv3NXP8WDgixvECV5rkL5Y3uwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718663807; c=relaxed/simple;
	bh=M4sHE2qpASIvbf40+IlRhmkcuzWNq9L/HHxfzds5suc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ra+l/N7wShPNdkewlQVRc+d+243DD0jLcyl2PjQIKKoJ8oLjvMhU0dnvCxsyX+3+secgXcQN6bwE81aPDWyGQbf3g2UGpb8A+11SGQU+eZml02hQTdkPBL6AC6x9bpRqcpoJ6bc+kTB3s9jqtUhB1YlbTXKROWkXM9IHqVjSYsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=22EMsdFS; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="22EMsdFS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lskvjxr+GnaChYYCVFk28XJR7VBt9QU76TJQLvhXhOyBFPtDZbX6PYU09Pe/dMQXrg5q0Cw2WR8eeUJoEYy5U68GZodQ8HmWnIPyVxZgMDnkXu3LYZEY8yL7M2o6BmowEpofG8MDVv+VQu5futaYH7gLRzqG2QlQ2pmJFP6kqa2CxWQrOVCnbnk10vrtrLpFhDQT/yYSe2xGXKwWAoao3FEF8PGP1Qrh+baZh8Xxqyd0LEiSCiYxgvSth8wr1W9eDkMS7RrgjLjPlZ3a8cn5zDdhTqV5smg6LtXJZZbIptexDLOhQLkZD+bB5PLLMqAHehlBBvByDKHDAlKHD1etjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQUXENKiJZO7Kl8z1968pYx6oB57NFee+2eTyKQH14Y=;
 b=fS5grzENPoJMXoLWP1DvpKLn063tLNUi2R001ujmf//CDa/vvdbPli1qnWkVltlFIrBPchu/x5J6nkIXAH/b34dnqE1yripqXxPMK2fCNxERYmiE+lb7Or+I3ilsH9uNIjOWRgsWaKhVYqIIkZSHGtssjILvMc5JpNpYcRmNQyXkdcXJZW/Dgj2vZyTef2z0Exswnix9YAT9ljVqsVI8BhIqqM9Uys+fjagf5pHMkuneyFfi4fMAOFnxYuadXeTeCL/qaA/9+H5RQjLH+dkBDsW00lzK/DP7H9iY0BVev6GFT4oojY0K915Vnm+fOc8JeKfcx6QRKlmHr0aHhUu5rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQUXENKiJZO7Kl8z1968pYx6oB57NFee+2eTyKQH14Y=;
 b=22EMsdFSM7tHgfskjmDB3ad+GzPNZUKxEHzhBIMQO69Qqh9CGA4EEiEK9Ihq+Wb8mTj006irtPhs4GVa2MtlCwxB2ISpN9x2ds52yvIrNhnFfzKg5TYlEUHn2+WdzZbm9jJddfWo6kqg28jF1FhsUF2NflHkKRgcVRUId6u7kXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW4PR12MB7440.namprd12.prod.outlook.com (2603:10b6:303:223::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Mon, 17 Jun
 2024 22:36:41 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7677.027; Mon, 17 Jun 2024
 22:36:41 +0000
Message-ID: <67baa15a-76b6-5543-56fd-d2841d6f6b03@amd.com>
Date: Mon, 17 Jun 2024 17:36:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 06/18] x86/resctrl: Introduce snc_nodes_per_l3_cache
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-7-tony.luck@intel.com>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20240610183528.349198-7-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::13) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MW4PR12MB7440:EE_
X-MS-Office365-Filtering-Correlation-Id: 87336498-3adb-4578-22f5-08dc8f1df57e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021|7416011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjdDNDc2YUZXZDhocnZaWUFqS0pKenNPRXRiZUlzOVo1MVdQeWhlWUdMVncr?=
 =?utf-8?B?WDcxUTI3bmRTUzBadmRHcU56SDc0cFRLMTZzN2V3VUNNb21SR2oxbkZVTFpx?=
 =?utf-8?B?bUx0RTVUU1llbjUwNVY0Wk9ybXVBVkQ2T3EwakRSSDFLMUd0Vm9ld2t6NUJC?=
 =?utf-8?B?eDBrSmVMN2hydm9JVmZ5Z2dWS2c2NkVER1U0RUJieHE5OThWWTRJM3poQlNJ?=
 =?utf-8?B?WjVsN0xIbTBEckJ2RmRaVUxrWHBQMnBXUVE0bzE4cm40L1Q5b3VrVFJvM2cy?=
 =?utf-8?B?b2tnaXNUeVhnNGwwOEh2R0l4VnQzY3BJcDh1NnNMcGN6NWh6V2RNK0hUYVBZ?=
 =?utf-8?B?QjlwbWxUZjdzTElWUXF6UG0rMlM0N3ZBMWpZbW5Rb0UvU0U4Q1kyVHZEdHA0?=
 =?utf-8?B?WEpwdW83eGtnS1dVcTV5Z29JeFltYzE1RjRLM1JjVkcyTUlZV2ladFUwRnFW?=
 =?utf-8?B?VjJ2eGVjOThIL283azZhODlVMXdnWUZkWVlNcTVhWURheVhFdDFmNDdvVUwr?=
 =?utf-8?B?S2lhRW9sMXRNOURrU1hkSDNNUE9MU2UvaFFFQ1FLMnpSbGxiZk5nNm83VlRi?=
 =?utf-8?B?WUlDY0VtRXBqYkkxZWg0RFhycnZ3TWhkWEVqS0lhbkRuOEFOclB2WVJERVZr?=
 =?utf-8?B?N0t5MENNU3JGSGtsRXJkd0syazUxN1J2TE5EZUduSWdWeloxa0F4R2RnRkVD?=
 =?utf-8?B?VWdqTzB0NmdneGFnbWtLNmZGWENYclNqeDJ0SGxtdEZzT3FFZi9iVnBHL1NL?=
 =?utf-8?B?M0NKVEFvQllwb3RaZG1WR2grY3hKQURIeTM3aGk2QlFlc0pKTlI0WlcwaEZh?=
 =?utf-8?B?Nk44WnFOUGhySHUvNldNb2tWSmpkcS90dnp4WElmQWxoaGZqZXY3UnNYQWRW?=
 =?utf-8?B?YnFYU1VhMEkrRGJ5d3BaeW1rcmpHaGR3ZjJzZ2JqRkQxQnVKTGpGS1hqQUFh?=
 =?utf-8?B?NmdOZ1pXVloyNVBmMTJHQ25Pb0ErVk1tMWFvRGhFOEExZE5HcnN4Sk1lNDBE?=
 =?utf-8?B?Vkx5RVFLcXQxMzRacEVMN3Iyb3BaWThmK1U0MnZ0emtoOHJ3aU52UGtSTXdQ?=
 =?utf-8?B?ckJVTUdhVTZsQXU3bzJLMGhtWXdGelhkOGdTbjJUYjVyUEpRTi8rRjQwNlAr?=
 =?utf-8?B?YTNUT1l1a0FJeXB4VjV0bXRPYTMzRlFJV0JKSTA5N2VtdGlaa05tOVBlUjZQ?=
 =?utf-8?B?dEd2YzhldFNqOThSaVBRZEJ1SWwrVmxtVGcwcno2OVlBbC9iU0RyYVU1WUsw?=
 =?utf-8?B?RUFWYnNSbTFoZU00TUM1eXdyQS9QcEo0aUV3VGs4KzVXdWV1Y25SaEJEVGU0?=
 =?utf-8?B?dEx3dUJTMkR2SXcyblV5emtLYmdjWUJvOVpwcG5pcmVHdUg5bjA3QTN3NnB5?=
 =?utf-8?B?cFc0ams0M2lRaFM5cGRiT1BIcFVLaFV3R25Qck1VM2ttb3BHRVkwQmdQWEZy?=
 =?utf-8?B?NGE3UnZHdTBZaGg5SDVhUU5MT0srYUoyb1AzT2w0VWVPT092a0NIT3JUMDd2?=
 =?utf-8?B?d3NJY3o3MkIrM1FTVWZPWEx3c29OSDlSUXgyWjZRQTVIMUtXM2c4T3NlMFhp?=
 =?utf-8?B?NTVqTUFGT3FTQjN1c0VjUTVvWVRWMlhxQjlrVEdocWpVYllWRERjSmRRV3Q3?=
 =?utf-8?B?ZnRuSVJPVzhqN0FjeE85ZWhRdTdLdjV1eGd4azRyZ2JPZTUvVW8vQnJPNVBj?=
 =?utf-8?B?S2FIeUd4T2VyU1k0WnRwOStWSnBkd2FDczlEK0g5KytkN1J6YVZUQWxyQW5J?=
 =?utf-8?Q?oFSxi3O24U44gTbvBU34IBmZ8RGqynIWYJnAJon?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1k2Wk5wYTdGaU8xUXQ4anJzRHF6UGFRbURWRUR6TjFUUXBNcGllS1hCOHlL?=
 =?utf-8?B?YTRvYUViVE90MEF3U0tmTFM4ekhpRjVMdk9DMmp4V0NFOEJEU2lxUnloamxz?=
 =?utf-8?B?VFFLOHVOdGVUaFg3R1E2WVRHY2ZVTHZoQW5rZy9BMlNRYnZnbXJLZWVqT3Vr?=
 =?utf-8?B?VmNCSFFFOFRqK1hqMUJldnMwU2o3S045T25UMjRoN2REUGJHNnkwTGVkanVW?=
 =?utf-8?B?WUJtd1RvY2k4RWxPaDBXNFMzMU9xdTBvbXczQ0lXTkxpL2VkRkRpaTFSbXBP?=
 =?utf-8?B?ci9DVTg3UkRQWU9QTzB6Sm5uT1BwUytCcDdjODAxZzZoN2pwL09pS1VMMUV6?=
 =?utf-8?B?dWZqRDJPN2VtY01sNWhUTlAybGlPK29xUmFvOVNoUERHRFQ2NXUvN2tEUGVz?=
 =?utf-8?B?QlpEVG1mbXVZbXE3QTJOS1JaOFZpZXRRU2dKSm90VGttQ2h1c3JFWFFxY0x0?=
 =?utf-8?B?cmE4akZ0WWE1TzR1bTNTZlVidU1Ob0dGZzZhOTduMVluaTZvK01rbUZIdjhM?=
 =?utf-8?B?ZFMvSDFSTWhzdUxGQlNwQnJodUhaWTJCcW1DYjNPbHQ5eG1PN3RsbTZ5dU5j?=
 =?utf-8?B?Z3NRT2F6a0E4TjFtbncwSkVxRGJ0dVlYZUVVU2swZUI0d0ViMnlhSGRpaE5V?=
 =?utf-8?B?Y2ZEeGRhOXBDNGE3OC9XOTRSOG9UU0t3d1Z2MjdVemQvS1pJTy9ValRVYnBW?=
 =?utf-8?B?allsR0gzQm1sWWFLemZScTJNR3lGRUVzYVliY0o2QnZFcVkvOU1zVVRCTXN4?=
 =?utf-8?B?UlJiSVgrZnVnd09IbngxeFhOVEU4Zjk0a1daaXhUNzVoVjZjbWJVM0NnSTh5?=
 =?utf-8?B?VWQ5RUxJeXdlaG5rMERVNUwxQ3YrT3ViZUMrYW8reFUwdTdLOVhYSXZXSUsw?=
 =?utf-8?B?ck51K3ljSHZLcEFkMndLSW9wZ1Zid0tCWkw1cHZVRGNiUG0vK0F1OFFvUGF2?=
 =?utf-8?B?enpBd2EzOWtKb0l5dUc2WnlKMTc3U0xRaHpod2JZZnZYbEoyelRzYTJDQmxV?=
 =?utf-8?B?aUNNN01RY0U1dXNENkt0MjBldGxJMkVRWXZ2VHZReW4yT2tOS2dYZGY0OW5x?=
 =?utf-8?B?ajVtOXRLYzlzUStWeVZrc2E4d25ud0Y4b05IM29sZVBNNUdsbkExSTExekRr?=
 =?utf-8?B?d2EyQ3BqemttRm52VU1XR0lCM2o3WEQzbS9uMno1NmplSnFxdHUxQWJMQ2hy?=
 =?utf-8?B?VWgwTVR1ekE5bnZOVzZCRjhKVWcwVGtMZEZ3SmFVWjJNRTFMUTdnZ09pZXV0?=
 =?utf-8?B?dkl6WS81V0c0cUdNN04zWXBIdjZ1WEQvTGtzVlRWMFhDL2d2NTVSRlJ2Ull3?=
 =?utf-8?B?UmdJRXIzZE1Ja1JES3d6VG1UZkRJWTNUaHEwcGV2WUdjWUo0ekVhRjA2TWZo?=
 =?utf-8?B?WWhpRlA2S3dTaERxVmNyK25OSldRR2RzWmRFcjcva0EzZTVOMXlzdGxsK0do?=
 =?utf-8?B?K2ZvZ3J3WVNiaFg3Unk1enlPazNTVWduT2hERWNXUEE3Z1J6TU1ud1daZXlv?=
 =?utf-8?B?c1ZFYnloM0dCNmpCZ0dXa2k0QWtMYmNLSDV4VnpnVjVQdUs0ZFpEUEtGd3p3?=
 =?utf-8?B?Yk5yZlVCTkF0UTV6QlAxZTMzMm81Tk5WcTdjQVNWUTJrUytTc2grY0g0YXl3?=
 =?utf-8?B?Q3YyYkxJVURsUzNnWmdOdU85cHlKUnZoNHVHWW9Nc3c3MHd5TnNNM2pNRldX?=
 =?utf-8?B?RlMzRHprWE1kb0xLL0Z2OTZENTdOTmJ6blYwWUFicFdlSVl5N3RSZzhEblBj?=
 =?utf-8?B?ZndYV3l1KzYxaVUxR3JabmZPM3hHUFhsUURSaGMxZkVyRkE1R0U0ZWIvN3BX?=
 =?utf-8?B?M1RweGxubXpES0hXbm0ydmRpbHFqSVpFZDN4cTEvWHRRbUphQU1yeGczTzFv?=
 =?utf-8?B?WnpnSVpGWmdtUHNNaGhSQjJFNEZPL0hPUytpY2xUejdnaUtFUmdqUkdNZ1ph?=
 =?utf-8?B?QXpybHBhenJqWm1oVjN1aDNIeHkrSXRjeFRFWndpYmwrMHg5UzJqS0hZSTdR?=
 =?utf-8?B?Nmx4QzhRbEtHU2xSL29WQ0NnWmVBZ0JxWlE5aGVYeTI4bituV0YxMzVkVXpl?=
 =?utf-8?B?djMwSkNtSmIrd05RYUg4OGlibXNCMzlYVDZqcUdMZ1VGb1pNNkJCUUp3K3Ba?=
 =?utf-8?Q?MEJI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87336498-3adb-4578-22f5-08dc8f1df57e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 22:36:41.7367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxhLK4tCskkElo3UETwRzrZttuM+LHLcFnZrZba9+VmqqLZkrVdcDMMwUy3PJUur
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7440

Hi Tony,

On 6/10/2024 1:35 PM, Tony Luck wrote:
> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> and memory controllers on a socket into two or more groups. These are
> presented to the operating system as NUMA nodes.
> 
> This may enable some workloads to have slightly lower latency to memory
> as the memory controller(s) in an SNC node are electrically closer to the
> CPU cores on that SNC node. This cost may be offset by lower bandwidth
> since the memory accesses for each core can only be interleaved between
> the memory controllers on the same SNC node.
> 
> Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
> to track L3 cache occupancy and memory bandwidth. There is an MSR that
> controls how the RMIDs are shared between SNC nodes.
> 
> The default mode divides them numerically. E.g. when there are two SNC
> nodes on a socket the lower number half of the RMIDs are given to the
> first node, the remainder to the second node. This would be difficult
> to use with the Linux resctrl interface as specific RMID values assigned
> to resctrl groups are not visible to users.
> 
> RMID sharing mode divides the physical RMIDs evenly between SNC nodes
> but uses a logical RMID in the IA32_PQR_ASSOC MSR. For example a system
> with 200 physical RMIDs (as enumerated by CPUID leaf 0xF) that has two
> SNC nodes per L3 cache instance would have 100 logical RMIDs available
> for Linux to use. A task running on SNC node 0 with RMID 5 would
> accumulate LLC occupancy and MBM bandwidth data in physical RMID 5.
> Another task using RMID 5, but running on SNC node 1 would accumulate
> data in physical RMID 105.

The differentiation of physical and logical RMIDs are confusing. For me, 
they are all physical RMIDs. You are basically using the different 
physical range based on the snc node. It will be helpful if you simplify 
the description. Hop

> 
> Even with this renumbering SNC mode requires several changes in resctrl
> behavior for correct operation.
> 
> Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate

File name is not helpful. Just mention the name of the global.

> how many SNC domains share an L3 cache instance.  Initialize this to
> "1". Runtime detection of SNC mode will adjust this value.
> 
> Update all places to take appropriate action when SNC mode is enabled:
> 1) The number of logical RMIDs per L3 cache available for use is the
>     number of physical RMIDs divided by the number of SNC nodes.
> 2) Likewise the "mon_scale" value must be divided by the number of SNC
>     nodes.
> 3) Add a function to convert from logical RMID values (assigned to
>     tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
>     to physical RMID values to load into IA32_QM_EVTSEL MSR when
>     reading counters on each SNC node.

Please simplify the description. Calling logical and physical is confusing.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 56 ++++++++++++++++++++++++---
>   1 file changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 89d7e6fcbaa1..f2fd35d294f2 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>   
>   #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>   
> +static int snc_nodes_per_l3_cache = 1;
> +
>   /*
>    * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
>    * If rmid > rmid threshold, MBM total and local values should be multiplied
> @@ -185,7 +187,43 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>   	return entry;
>   }
>   
> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> +/*
> + * When Sub-NUMA Cluster (SNC) mode is not enabled (as indicated by
> + * "snc_nodes_per_l3_cache  == 1") no translation of the RMID value is
> + * needed. The physical RMID is the same as the logical RMID.
> + *
> + * On a platform with SNC mode enabled, Linux enables RMID sharing mode
> + * via MSR 0xCA0 (see the "RMID Sharing Mode" section in the "Intel
> + * Resource Director Technology Architecture Specification" for a full
> + * description of RMID sharing mode).
> + *
> + * In RMID sharing mode there are fewer "logical RMID" values available
> + * to accumulate data ("physical RMIDs" are divided evenly between SNC
> + * nodes that share an L3 cache). Linux creates an rdt_mon_domain for
> + * each SNC node.
> + *
> + * The value loaded into IA32_PQR_ASSOC is the "logical RMID".
> + *
> + * Data is collected independently on each SNC node and can be retrieved
> + * using the "physical RMID" value computed by this function and loaded
> + * into IA32_QM_EVTSEL. @cpu can be any CPU in the SNC node.
> + *
> + * The scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is at the L3
> + * cache.  So a "physical RMID" may be read from any CPU that shares
> + * the L3 cache with the desired SNC node, not just from a CPU in
> + * the specific SNC node.
> + */
> +static int logical_rmid_to_physical_rmid(int cpu, int lrmid)

How about ? (or something similar)

static int get_snc_node_rmid(int cpu, int rmid)

> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +
> +	if (snc_nodes_per_l3_cache  == 1)
> +		return lrmid;
> +
> +	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> +}
> +
> +static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)

You don't need to write new function.  Just update the rmid.


>   {
>   	u64 msr_val;
>   
> @@ -197,7 +235,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>   	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>   	 * are error bits.
>   	 */
> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
>   	rdmsrl(MSR_IA32_QM_CTR, msr_val);
>   
>   	if (msr_val & RMID_VAL_ERROR)
> @@ -233,14 +271,17 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>   			     enum resctrl_event_id eventid)
>   {
>   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
>   	struct arch_mbm_state *am;
> +	u32 prmid;

snc_rmid?

>   
>   	am = get_arch_mbm_state(hw_dom, rmid, eventid);
>   	if (am) {
>   		memset(am, 0, sizeof(*am));
>   
> +		prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>   		/* Record any initial, non-zero count value. */
> -		__rmid_read(rmid, eventid, &am->prev_msr);
> +		__rmid_read_phys(prmid, eventid, &am->prev_msr);

How about ? Feel free to simplify.

           if (snc_nodes_per_l3_cache > 1) {
                  snc_rmid = get_snc_node_rmid(cpu, rmid);
                 __rmid_read(snc_rmid, eventid, &am->prev_msr);
           } else {
               __rmid_read(rmid, eventid, &am->prev_msr);
           }

>   	}
>   }
>   
> @@ -275,8 +316,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   {
>   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
>   	struct arch_mbm_state *am;
>   	u64 msr_val, chunks;
> +	u32 prmid;
>   	int ret;
>   
>   	resctrl_arch_rmid_read_context_check();
> @@ -284,7 +327,8 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>   		return -EINVAL;
>   
> -	ret = __rmid_read(rmid, eventid, &msr_val);
> +	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
> +	ret = __rmid_read_phys(prmid, eventid, &msr_val);

Same as above.

>   	if (ret)
>   		return ret;
>   
> @@ -1022,8 +1066,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   	int ret;
>   
>   	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
> -	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
> -	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
> +	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
> +	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
>   	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>   
>   	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)

-- 
- Babu Moger
