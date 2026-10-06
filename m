Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2353D339364
	for <patches@lists.linux.dev>; Tue,  6 Oct 2026 19:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791316438; cv=fail; b=B7z+Sx83oa1mN2ezzEe9yOyNefQqy0fVxjdDF3o3EeJ2Ky0z9U4ub7X8Jem8JSkxLenI2mlLkPpyjmbip5PB9ohZDfaIQg1yisBd3rukKcM1DKL7Clq/8FYlgUcxRwCzdJap7nPSxUqWzPCA34Mwl1tFm31JBwtR0Pq7lEy2m9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791316438; c=relaxed/simple;
	bh=WvGMp5o9x4VZiW1U6ZsvTOVocHn0xjo6Qm1+I3jGFOU=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kNRlxRDrCCZfZEN+lS2fBuilyEmBBjT6qUvm6uk1DiIXxr7FkVuRiL2oSolIn0qVro7TVDJRrts1ZSVJumLyoViBRxglJhbxlr6I6rdmNqAPqk3iO6yMdECMfweO+j64EY8uMhG4rzPWBSNO2bUTkvBEgJZT0f4lfgS9XskmXMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zl/i/DXE; arc=fail smtp.client-ip=52.101.48.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zl/i/DXE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DLBgUD4y9Gx1h2V+0u1mXdJiC2U5aX+RveBVGqRMI/2Qwim0H3Hb0280r1/A9BiIMqElRdFY9sAYHxWipYgwN46kC+haqxfQTPJ7lrT+5BfaVy+a04dcLuMPBILX/9CnjIFN5BajgOTAGdU1rCWXjC11sAipN6gQYJij0hqLwPAIQyf3gVoAYZxVVc49PKiy4ZW58u69Np34wO/l57isXC3ELsEBSeHfLZp0kzg/hYSw0SFIY289/ZloVQ4Pmlgw+ZhZXLmSDkm/dZo4j91NO6NA7pBZyqnRB4+gp4LS0479SBDz/EYw/tOcFHKQw9llxQdwo+IxRUsCnkSnjbJA7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkTkKhHfGH3sR0dgZZsVMFUhKm/zfaAt5VBV+U9dMbo=;
 b=xF5KbOwNgQ/PPPfEw6bKI1/2MLxxE4SadiAGy0Q8nl76wONJBCT5eh+QQG4blC0UNuOtgDm/QnfdWMN/31Dg132+iuZN3mSYUJuZsA6OsKY46gY3vJWuwBHPRtrs9FPmiz2GEOps0T/Q5vjxYWUPJWJvWGFsssc8+yzboQASf4jtHr1lBjmHC71D04RALLKjGuAHpMZwPer/C+RcPbz96k8OQW2BINyNhHTyOM/d5iyRXBri8xaN9H0I2hXBXyLVxBsVhhTdbCbh7jIl28AsRJdAo3moBRmDofr03tQUR+9sxrDqAabNZsjWoK3d+fzHPSRwNkFhkMURwaqMCwpJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkTkKhHfGH3sR0dgZZsVMFUhKm/zfaAt5VBV+U9dMbo=;
 b=zl/i/DXEYZU1RV0f73IvawUjXjFWGCfvpsikHz7ih2c5L1+rA9bwMzYDbFfJ8fiIWjx4mH8o3f17gfEO+yHwkyrJXjvCPSmxLgVE8FkxunEru6uh00Ejz4hexdgXmvK4kEuqQx3409Q0RE591HX+eVv7C+a1dFgjvnrRMQGmD4I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by LV5PR12MB9827.namprd12.prod.outlook.com (2603:10b6:408:305::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 19:53:52 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0496.010; Tue, 6 Oct 2026
 19:53:52 +0000
Message-ID: <327d9248-2e4f-41b8-b4ad-4f6d01c85ecb@amd.com>
Date: Tue, 6 Oct 2026 14:53:49 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v13 13/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-14-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260928221509.68002-14-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:610:e4::14) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|LV5PR12MB9827:EE_
X-MS-Office365-Filtering-Correlation-Id: de997fb0-f341-4098-8428-08df23e38b9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|10067099003|56012099006|5023799004|11063799006|4143699003|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	L2CEd9LpC69L8s17feN8Jzcgmy3w+NIC3m1uj0kpsb2csfk7sW6Hond+kvQ3XhtXy7sc9pbkIBmONq97rF26th07a0YubgBAU4542Ty6gXhr4pH1Mfv7L5VziHmeDo+ty0UQN98ZFOKIRh3t0PPRiQMJvbVq/9QJhCD2lOjc0lgvgT3SwAyNPTLaMBI3YMjq42uoRDHo/YS+Jjy06mlKn+KK23yST/Wqlm4xUtlabOHlGuzLWot7bl6HKxKE2sDjmmRj5XtHoawcKkcrbSvWjtEyhNH/QCRQ5MHUS2ANMVK+cYGe20sMhsPa4lpBoeCpwIwa5Yq49sd9yV3oY/TeR6bXWeNitNLN7FqxZfLTbBqCD2Ag0hUiMlPf963Y/4DOaUp2pFZndCeCwqrz4bFrca9FeUc1OoMm7i/RJ4/Is9xPTyJRXRIeT4Wwy6+Lbixph4gR56x34mMrztO3QR04G6sdiqcnRNpfbsirtQzlqQE9lt3SzkrkjWidYZT0ILC5sUU5FQyxhR8/qQ02VlMpYGALiRYf3xJwUIu3rzBeYu4hiWzLW0m0t11/IFhNYLNHYaijYkTjal8iPcGwK1fSK99faKAMdHuoaAb62RpgoDwUucqyqFMxELKEnM2RlZvAkzeM/WG31tNY4a8wL2GLAkInjT0l60qYTwPu86LrAZNHVhAQ7LFH1b1Hq+li+/5ftOphkfqSXuCkGttQdQRsSg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTMrM1VNTW1zTFkyM2oxd2Y2MldHRHRFSkxZajBIMkQrT1FpbEgzWXVSekNB?=
 =?utf-8?B?VG81VTlTZXlaak5JRWRmWW1mbWxEY1grZU8vTG1MZ3o2V09pcU83b2srczBt?=
 =?utf-8?B?UTdUbXZWdGl1WmVVc2RsL2xsd0l6YWh4OUNGd0RKRVB5cUtoUTljMmV1Wmwx?=
 =?utf-8?B?TmJGTGFWbDdwMkRzZXZsR0h3MEpVN2haQnpXS3NTYVpkMkZtbTUrRUtxa1Ur?=
 =?utf-8?B?MklUb2tUWVp4a1NLZCt6TG5YTGVvQk40aXIvWExZeEdtOGlsY3FmclNGOXBS?=
 =?utf-8?B?THpBZTNzaVNJcWZmVlNyT1crL05GSWRGSnEydzFXNXFHWjg3K2hqS2JuZUVY?=
 =?utf-8?B?YlJOZ01tYmc5Uy8wMjJ0bXU2T0tmTnZGdUJITi9IUzVOWGRIQWc0UmowaThH?=
 =?utf-8?B?SFVLMzMwb2F5WHJOMEoyc05HV1p6VFlJMlg4d0trcUdZM1FsSUdZZjJnZ0lV?=
 =?utf-8?B?OGo5aUdPTTFQbkRvbHZUQXBqUGlkQndZa2duRWYxRlBHU3hUUVVDRUJVbFZG?=
 =?utf-8?B?QWQveWhKdDRjNm1LS1NBMXdRT3pHY2pLZXJ3WkJZV25mbnlteStKNTNNOG1Y?=
 =?utf-8?B?bXcrajVPdGwwZ3JRcG1oRk9HRDh6UlNOZUYyT2V4bm1TaVdTSC9iaitUVkgw?=
 =?utf-8?B?QjdEN0wrUFVoVW1DK1lCL0JHMGJONzZ1WnBXK3Z5NmFFOXBnemxJejJPQ05t?=
 =?utf-8?B?bUtOZDR1TjdPZTMzMUpWbWpkVVdMZDVBSUpTQWJHbTFqeUFLTElDSGtQWHNl?=
 =?utf-8?B?TlcvSSt0M0RFRnhlMjdBbzcrSVJJeXVkSkdYejJjemNsc2gwTTZvckJGdVl6?=
 =?utf-8?B?KzJ3bjYybUpzS09HbGdxTmdwS2doak1pSFRvK3d0RnVpd3RjS09JSzdZYmVJ?=
 =?utf-8?B?bzIvYUJ2WlNSVHErTXZQUzZmSzdjNUdmZW5PemFUZVYxL1p1SDdSRVNtQjgr?=
 =?utf-8?B?Ylc3bEtNUUhySVk5WkNwamdOaEJqSlVoTUlpL1pyVWJUcmcwb3d2cE9Xbmxx?=
 =?utf-8?B?dTdiWW9sU01IQkk3SGVtbEgvTlJWVG5DRFZFRmRvQVNZVDBraUdBZzM2ejVU?=
 =?utf-8?B?ZHNYUUI5eExzODVjWmZsTGZOeGtLZlNKSXBRREc0azVadEFzbnZ0TXIzemk1?=
 =?utf-8?B?N1I0UG9WL3Nna1RkU1U4c3RteXN0ZHhiaktIUm91RjZ2dWhVR2Z5OE1YbkNB?=
 =?utf-8?B?MW5Ma2U5NFpXVXdndmlGaVlsaWtMZzdDQjhXQk5RbkIwWlNRa0hEZVdIN0xM?=
 =?utf-8?B?TjB6ZFdYWngzcnd4dHd3T3dCTVQyUU10V3kyVDhuTjRZTGVTenBFRGJ5TmNY?=
 =?utf-8?B?TDdHb0VkWnJ6azdBU0IyWEh6U0xPekdPamxIT3RQQmNVd3JVaXlRVnNoU2ZE?=
 =?utf-8?B?aUREVWxQaVRpaURXb3AzNXh0elF1U3pST2c5Njc1bTFSQXVMZzY5bGZ1RVFP?=
 =?utf-8?B?RDRtL0h0eW96TWNsNEd0eFVuRmR6MmQvM2c5aUxMZmNEdjUxOE9kMlQ1RUxL?=
 =?utf-8?B?dGhXd0RKYm9jWVZhNnVmajdxalFPOXdHdklUV2JDc0xoN2JmQ3FVeWNTaXcx?=
 =?utf-8?B?UDhING81SVhSTC9jMHZDQTgxaTBEUVRlMCtVNHJLYnpNNmlHczQwYXJzTThD?=
 =?utf-8?B?NlBHcm9xeWhaaUYyRE9YVzFjM3VJRjluVmxHS3E1b256ZTJxT0JzL1Q3WnYr?=
 =?utf-8?B?b2hndzRvd2JBUUdWZnIwTks2akkwM1BXYmZ0WTVCdFd1eVp5aXlVSmc1TXBS?=
 =?utf-8?B?V1MwOFpNeXdVWG80Z3pkckRnN0hSVXFEb0NSajlRc2JwSEJ3VWlOVUVnR1pz?=
 =?utf-8?B?enJSWC85V01Ka1owNkJlQnFORFJBR3RMVWc0bDZVaXk0UWdWWHFVT1NJZzYr?=
 =?utf-8?B?WEh2OURiaFBzTHkrdEF2NDRVbXFXK0FnMm1aNVp5N3N1ZXdwTk9HVkFSM3Zi?=
 =?utf-8?B?dTErTlNFc2lHUWN6OGd3aUM0SC80a1JaMWpuUXJ3OUVMSGNodUtuOTdyejRn?=
 =?utf-8?B?VDRQVEt2WDE5cVMyYXZrU3JPbVBWaFcyeUF0TVcrL05RNmhXV1VZTTA5RXdo?=
 =?utf-8?B?d1FwTDZVMGQ3SGREd2VpdTgzRThMVk4zL3R4N1FFYmRwMVJGZ0ZudmpISUxo?=
 =?utf-8?B?TEhjdzVFSEx1OHcwMGJoZEU0aEZuUXVlZ2ZYY2VFWHV6ZGNGeEh2RGFHcWdI?=
 =?utf-8?B?VUl4MkxTblE5SXd1SDBFOWU2UDRsVnBPMjdkQmorWEpDZ0RjOHFpdjBEN2J4?=
 =?utf-8?B?RGN0Q1cvdWFrYm5YODljamw5TmZNVmd6R1I5cHZwaS95eDBoaVlWU2xLZWpv?=
 =?utf-8?Q?3pntKxKCyi892SNSDn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de997fb0-f341-4098-8428-08df23e38b9f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 19:53:51.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QFwNylkwBpIJnBwpKfo6PQQhRu2P2vUZQWlxFKiD1/dxsyq50Tmg3KDrtuxHoej
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9827

Hi Tony,

On 9/28/26 17:14, Tony Luck wrote:
> resctrl keeps per-RMID state in rmid_ptrs[]. It is allocated on first mount,
> sized for the number of RMIDs available at that time, and reused by every
> subsequent mount.
> 
> Application Energy Telemetry (AET) requires the pmt_telemetry driver to be
> built in. Allowing it to be built as a module means the number of RMIDs can
> change from one mount to the next, so a later mount may need more entries
> than the first mount allocated. Reallocating per mount is not possible because
> the limbo handler continues to access rmid_ptrs[] after resctrl is unmounted.
> 
> Size rmid_ptrs[] for the maximum number of RMIDs the system can ever need,
> so that it is large enough for any future mount. Build the free list
> based on the number of RMIDs needed for the current mount cycle.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v13:
> 	Updated commit message using Reinette suggestion.
> 	Merged patch 14 "Rebuild free RMID list on each mount" into
> 	this patch as the split into separate patches didn't work
> 	as well as I hoped.
> ---
>   include/linux/resctrl.h            |  1 +
>   arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++
>   drivers/resctrl/mpam_resctrl.c     |  9 +++++
>   fs/resctrl/monitor.c               | 64 ++++++++++++++++++++----------
>   4 files changed, 79 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 764c45be2d59..7afeb3bd55d9 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -447,6 +447,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
>   /* The number of closid supported by this resource regardless of CDP */
>   u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>   u32 resctrl_arch_system_num_rmid_idx(void);
> +u32 resctrl_arch_system_max_rmid_idx(void);
>   int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>   
>   /**
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2e3b9c16cbda..8702a6da2374 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
>    */
>   DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>   
> +/* Number of unique RMID values that can be written to MSR_IA32_PQR_ASSOC.RMID */
> +static u32 pqr_assoc_num_rmid;
> +
>   static void mba_wrmsr_intel(struct msr_param *m);
>   static void cat_wrmsr(struct msr_param *m);
>   static void mba_wrmsr_amd(struct msr_param *m);
> @@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>   	return num_rmids == U32_MAX ? 0 : num_rmids;
>   }
>   
> +/**
> + * resctrl_arch_system_max_rmid_idx - Largest possible RMID index
> + *
> + * Return: Largest possible RMID index used for boot time allocations.
> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	u32 num_rmid = pqr_assoc_num_rmid;
> +
> +	/*
> +	 * If the system is capable of L3 monitoring the maximum RMID value may
> +	 * be lower than the system maximum. Either because the L3 monitoring
> +	 * feature supports fewer RMIDs, or because SNC (Sub-NUMA Cluster)
> +	 * is enabled and divides RMIDs per cluster.
> +	 */
> +	if (r->mon_capable)
> +		num_rmid = r->mon.num_rmid;
> +
> +	return num_rmid;
> +}
> +
>   struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>   {
>   	if (l >= RDT_NUM_RESOURCES)
> @@ -967,6 +992,8 @@ static __init bool get_rdt_mon_resources(void)
>   	if (!cpu_feature_enabled(X86_FEATURE_CQM))
>   		return false;
>   
> +	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
> +
>   	/* Any of the L3 monitoring features? */
>   	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
>   		return false;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 7ddee8f5162f..52726f7fd03f 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -257,6 +257,15 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>   	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
>   }
>   
> +/*
> + * File system calls this for one-time allocation of structures.
> + * Return the largest possible value.
> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>   u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
>   {
>   	return closid * (mpam_pmg_max + 1) + rmid;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 2a28fe04284b..ccfb1548fea1 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
>    */
>   static struct rmid_entry	*rmid_ptrs;
>   
> +/*
> + * @num_rmid_ptrs - The number of elements in rmid_ptrs[].
> + */
> +static u32 num_rmid_ptrs;
> +
>   /*
>    * This is the threshold cache occupancy in bytes at which we will consider an
>    * RMID available for re-allocation.
> @@ -961,45 +966,60 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>   
>   int setup_rmid_lru_list(void)
>   {
> -	struct rmid_entry *entry = NULL;
> -	u32 idx_limit;
> -	u32 idx;
> +	struct rmid_entry *entry;
> +	u32 cur_idx_limit;
> +	u32 rsvd_idx;
>   	int i;
>   
>   	if (!resctrl_mon_capable())
>   		return 0;
>   
>   	/*
> -	 * Called on every mount, but the number of RMIDs cannot change
> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> -	 * until resctrl_exit(). Note that the limbo handler continues to
> -	 * access rmid_ptrs[] after resctrl is unmounted.
> +	 * Allocate the largest number of RMIDs that this system will ever
> +	 * need. These cannot be freed until resctrl_exit() because the limbo
> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
>   	 */
> -	if (rmid_ptrs)
> -		return 0;
> +	if (!rmid_ptrs) {
> +		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
> +		if (!rmid_ptrs) {
> +			num_rmid_ptrs = 0;
> +			return -ENOMEM;
> +		}
>   
> -	idx_limit = resctrl_arch_system_num_rmid_idx();
> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> -	if (!rmid_ptrs)
> -		return -ENOMEM;
> +		for (i = 0; i < num_rmid_ptrs; i++) {
> +			entry = &rmid_ptrs[i];
> +			INIT_LIST_HEAD(&entry->list);

[1]. All the nodes are initialized. Basically, it is pointing to itself 
now.

>   
> -	for (i = 0; i < idx_limit; i++) {
> -		entry = &rmid_ptrs[i];
> -		INIT_LIST_HEAD(&entry->list);
> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> +		}
> +	}
>   
> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> -		list_add_tail(&entry->list, &rmid_free_lru);
> +	/* Find how many RMIDs are available for this mount */
> +	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
> +	if (cur_idx_limit > num_rmid_ptrs) {
> +		pr_warn_once("RMID count %u exceeds allocation. Limit to %u\n",
> +			     cur_idx_limit, num_rmid_ptrs);
> +		cur_idx_limit = num_rmid_ptrs;
>   	}
>   
> +	INIT_LIST_HEAD(&rmid_free_lru);

Initializing the list head without first cleaning up existing entries 
could be problematic here.

The first mount works correctly, and INIT_LIST_HEAD() is not needed in 
that case because the list head is already statically initialized.

However, on a subsequent mount, the list entries remain linked from the 
previous mount through the setup performed in [2] below.

INIT_LIST_HEAD() only reinitializes the list head itself. It does not 
traverse the list and detach or reinitialize existing entries as was 
done in [1].

I think you need to replace

INIT_LIST_HEAD(&rmid_free_lru);

to

while (!list_empty(&rmid_free_lru))
         list_del_init(rmid_free_lru.next);


This ensures that any entries left over from a previous mount are 
properly detached before the list is reinitialized.


> +
>   	/*
>   	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
>   	 * are always allocated. These are used for the rdtgroup_default
>   	 * control group, which was setup earlier in rdtgroup_setup_default().
>   	 */
> -	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
> -					   RESCTRL_RESERVED_RMID);
> -	entry = __rmid_entry(idx);
> -	list_del(&entry->list);
> +	rsvd_idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
> +						RESCTRL_RESERVED_RMID);
> +
> +	for (i = 0; i < cur_idx_limit; i++) {
> +		entry = &rmid_ptrs[i];
> +		/* Don't add reserved or busy entries to free list */
> +		if (i == rsvd_idx || entry->busy)
> +			continue;
> +		list_add_tail(&entry->list, &rmid_free_lru);

[2]. Here nodes are linked to head.  Basically, Head <->A <->B <->HEAD


Thanks

Babu
