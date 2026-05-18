Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDAB395D9F
	for <patches@lists.linux.dev>; Mon, 18 May 2026 20:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137686; cv=fail; b=IDT/8ocnjZ9PIou6pa78vGp7TF4UA1ucHsgDlvEM7UgCrcpAigoRWHR77z8L4PR0thZjSRzwM70tvjHj03Bx4Rw8K+aAZPdzy+xzFu2kxZoEh+KPWAMkmIT0WXOtbX76S2FfjWBTV67vctBj1BDRELOGp4EKGVh/HDE5fJwey7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137686; c=relaxed/simple;
	bh=K6FXiYRIoDeA00Ht6cMCUczNYRkxUxbj3y/8oVwL9Ls=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R8Ua3rwkWq+RoAIRw9RfVXD/amraxapbuI9qciNIZUnp8/HwOopfqWLo7r5Lvo/g8PKocXmNN7z51BraQsoPvjRFMUmkIHhaT0DUKXdrUn9C5YQ7pNaPrK1sysKVrue3ZR3eb1NjHlcigzKlV/9R6faWfwHC46lpfiw8LXFE0t0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NeBWX+UP; arc=fail smtp.client-ip=52.101.52.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NeBWX+UP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QS+v+WuP0ON9K4ekhYM2tSNSoj27BD6+gMBwOKFcDhUrHNtu8yDJPHZbZ6tzFkkcVUDxcAHSDnz1mpIq/t03IoMolMGJEy4KmvAzlpRi0mxitcjaTgzvg0OoQ3HzDRJYpg2a5GjRjOVtiRVdt2azB5Q2eRWVpJjf7bG7ZWSo1Zkolky4R6yc1S02qcsjoKHj8Cj7MNl0YqBaGflgLkADY95jdLt1f6pv8lw9gJ19bIPfy7i7PAVUQbeZLKMH+pDZb/gXc64851hidr3dkyFQaf5dLTsebaZnp3dq6FgBh+/gWleBZI0/I3/A/fElE28ZAEGETpY6d4+HPpYoCX1mPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E78bgc6LVHX+MYCFHrQgWqfGg6h61LhnUcjjpAu7krU=;
 b=KygoOT59qpTX+r0xt6R78w8wjM1m4/OWQeaHm2DIG36EVRx76N04ZYvJ+Pn9iE9hXfyyz6+o2xmMH86RNEBobo9WcEjrm9v2m0PJYxzZBjQU7WFmRWekCuIyHtK9zOuHupLgh7mwUR5T89sjky0YKMauc7v8EkEABjJLUKhRfewbHCjCa8rRoMB1usbsFhw/Be0OlhcMKSmmlk01ri9h6sdcd/fCOw7utI6WfExanIHmVS/axEmg3e8tQBpZo8Xgrh2s7TcPT/kxU/P+6mHqEEb1KyI1jeVxgvJ9YWSPBXBSbqLNvGijyDzjKcPAoBDAO3L+gRxWz9mV6EpCoDECvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E78bgc6LVHX+MYCFHrQgWqfGg6h61LhnUcjjpAu7krU=;
 b=NeBWX+UPP9pyz670RrUFPbeuoYG4O44iYV2rwcZMqKKTA5CsSjv6uH5ot5lE/sZGUIemKkGgTuud7dthdNXfIctJrm1GJNJ6GANBK6Qyod1V1wHmidMKrpnhZesG6a9l74rR/fZT6ezdpLr+fEocuNCxbvD9BUjA5FXoNkTynhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 20:54:41 +0000
Received: from SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f]) by SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 20:54:41 +0000
Message-ID: <78343b67-92dc-49c9-8abb-2ee6cf21ea18@amd.com>
Date: Mon, 18 May 2026 15:54:38 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v2 3/5] fs/resctrl: Fix use-after-free during unmount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-4-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260515193944.15114-4-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:610:cc::15) To SA3PR12MB8803.namprd12.prod.outlook.com
 (2603:10b6:806:317::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8803:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e5ab9c3-ed79-44c4-d9b2-08deb51fae93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|4143699003|11063799003|18002099003|56012099003|22082099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	CMwVNtreUDQP+qGiKafeal2/d4JLICOLdKjp5EPIAoU47BExMEikeF8CICm1d6L2GiWoD/1lPAnAwqR8A1Mb+BWnOC/g0drpfT8uuiGh4UQNMnphYoxUnV006EhDaZdtkAGMKIAlQN9BD+VzpyKQQ5PIWzTEWc/TEt6sWi/+vIM++6NMq1/6g5ZgcrM8ii+BEEbMzRQ0Zt7/Hrxh2Y4OnnA3jSvJxh/r59PqQxc64qN3eX0oxyO3DZWvRKkSCaE11oezvv6iITqQwAavhlgUYUG9KLbpi1V6EoXn688013mgvDDBIQsw0YbBu6RuPP0OYSqEnS2+4AEDLxp3BhwtwKjPq5ci7yVCa3WcU1YzTjI7Wkon1oWkfBS2KSg8vu3Gt4kvZZf39l96IiGufTfCCUOuAIEbOEM64KsKOrFIWLKRhU4cQF+/pIqhBbiH1P7EnvF7i7b3tF1U5B4qY5AefTEAzgi6yhT3JEQSCKq2RmZGxz/kXh5uHa34OYvp0OQqXowpvpMYNBmSoKeM6tOi0ZKzpaoTZJmeoVmgHxod5vH0XUABGVFrb7cxJLjIXt8HrLxD++Ud+fxaWhe5/lwV2TitmY2cnd6z9dCDenyF+9R0lNL7jpRt1vCCKmJtRmeviFa5eHQVWrxRQzmpxUR8MQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8803.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(4143699003)(11063799003)(18002099003)(56012099003)(22082099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1JwazFYUHVDYUtYS1U4N0lDNk85Z1RnUWRyN2NZQnNvTGEvb1FTM21ieXlV?=
 =?utf-8?B?akpPTVhwN1h0QWM3WkdaWEc2RXkvR3ZwZ2kvWU5yM1dzRWc3MTRwRjMxbkVq?=
 =?utf-8?B?c2w2MHlFK09iMGxmUW1QclZGcmp4R3B5YzhJd2cxYkZJeDJVb2ViTTY5SGw5?=
 =?utf-8?B?cEtucSs0MVFnWElUT1dhVk9XZENUQkZCRlY4VHFyeStzYUNsdmFaUGJhcW1S?=
 =?utf-8?B?ZXpLNm9ud3JqVGRrUGpGZ1JvQWlsZ3M3V3R2VUtlbXdvN2kyZjB1bXQzMEU0?=
 =?utf-8?B?cElZZzNUdjhKZm0wTGJybUVWbXMrZlhTUG01V0trZGZONkZEakZzZnZkQzdD?=
 =?utf-8?B?ZlBGcHZNU3E4b2tzVUVqdEpIMlVOZ0NnTTJGOUMrS296NldnNk51THBGNjIw?=
 =?utf-8?B?YThBZWQzZzVVeUt3MHNDeHZKWDBUby9mcnBvZG40djhDRWgxWWJnTFhFQWNL?=
 =?utf-8?B?WEVnL1J3bjQvTmN4ZWJZNm9JeWdKU2V0VU9idkZlYzNBNG5FOVhIS3c3OVYw?=
 =?utf-8?B?SUV3SnYwSFRGU0RrRnVUVGRiTGZLdFVWbWp3VUtnTEI3MnJ0ZkEwQ0NyeTkw?=
 =?utf-8?B?RmlNcFdHODNQQ3RLV3lMUXdFMjJodkdtdjBOTGkrMTNQTi9KMlV3cGpWSXFo?=
 =?utf-8?B?ZUZpNFdRMlJkNDZlK2YrM3JzbXJJYkU5YVE1MzJnVDdEcFQxLzZ6WktvR1Vn?=
 =?utf-8?B?bGJ5SmUyRWJTRU1WME0ycDN6eUZrUXVlbER5ZktSaG9EelNRQ1JVZXlUWXNE?=
 =?utf-8?B?OVRWL1NvTVI0NEp0VkZmYjArNldLN1ZUZVpPVW5XWjZwOWJ2d2tQS1NmZGVP?=
 =?utf-8?B?N1pBbWdQS1NoT3QwbVZocEQzNEkvTUoxd3hXYnhRTE5yWVNTTWRUUGl5a0hC?=
 =?utf-8?B?ZUtlTlhEUmRsTlhVN09jcWdpdmpsdTJZVlF1TDVKb1Z2MUpnaU9UTFowZ2N2?=
 =?utf-8?B?Vys0UXBaT0h0cVBTUk1Pc3VwaitWZ3FuZHI0aWpTemxaV2pXSUJGNkVPRyt3?=
 =?utf-8?B?WklYSmlXWXRoZzdLRlF3eGpWVmdJRmI2UmVnanFTL3ROSWdCTU5zRUhGYWRu?=
 =?utf-8?B?WWVSZ0o2bFVJNFlpRTJZSTk2VUNzS1FFMmdiRzlHNTZmR2R1NXFmWjJENXpK?=
 =?utf-8?B?a2hhVVZtdy9XYVduWmRBSU1VT1dZSllPRjRpMFVUcHBramo5b3JQcFU5c1pi?=
 =?utf-8?B?b001RlJ1T2QyRmJaNzF0Q2J5a3RmRVVMU1VWY3ZrcFZIVmlldHAvdGhKME1j?=
 =?utf-8?B?aGFWaW42akNRMmZVeUgzWUJ1QnZTd3RVV2ZKSlRQRG5sMjFXYkVRNlVFWlJ0?=
 =?utf-8?B?L0g0VForWnQ2TDQzZTBnVkQ2a0ZNN3NUZ1pkN1orQzhhNVBtNnBjdGthM3Q1?=
 =?utf-8?B?dUVHR2grS0xDSVNyeHF1aitHakJ5VnQ0T2dtbUVlMzJjd2l2aEJUMlZVZCs2?=
 =?utf-8?B?cmVJdEUrM2ZGTWVIUUt1TG92TkUyTWY0SXJIM2xIdGVUaGNBN3JzdllQUTNG?=
 =?utf-8?B?a3N3SktMMEJrcHMvcDRsWTFDL0lVOTJpWitJVkx1azMwUWMyMUdZY1EzV3Zi?=
 =?utf-8?B?YnRwTGZSTS9McVR2alJmLytNZ2JvekxMS2lzVWpDUFpxdHpiYkd1eEQ5aXNM?=
 =?utf-8?B?Ukd5eVU3bERwSCtJVk45amd1eHJrd0xFa3JDODN0ZFI2a252MStiUlppMDc4?=
 =?utf-8?B?L1kzcDFESnpMMGtiVmdLUEJMZkNjMnJUbGZ1WHlPUTVmNkpkeWMrM1FrT3g1?=
 =?utf-8?B?MzUvYXNFODhsRTh2ZTRlaTNYY29mV1k4ZVBkajBIK1ZzYmhuTXgvMktaWHVa?=
 =?utf-8?B?K3dCZUJ1K3BxNFZUV0dsR2RDUWVwVE1TZHVjeUdJVzh5MUQ2R2ZxOEU5a2dL?=
 =?utf-8?B?N1hDbFV5NDNUWHJmODM4eXZTSWhMY1VNZmNCWUNkL3FZODROYXZyNjdlcVlo?=
 =?utf-8?B?NWNQTEFhTUhGR3daZEZnNXhYdU5lZzl5VzVtKzBEVXpCVEt6UkRnZ081aXFB?=
 =?utf-8?B?MnZrZEJEckdZSm5zNDRVcEhZejRNUldXK0dTVGpkUXNRYXZhdFpJTTh5UklB?=
 =?utf-8?B?SFdhUWJnZHJNWVFGdldQWGVNb2NpRVZaWTVyREhmamRrOHYrcVRBYmtSMkJB?=
 =?utf-8?B?QzJvVFMvK21DSzArN1ZsOE5pYVRCaGlFc2pzSm56SUloQnAyUWVlY1lDRHZS?=
 =?utf-8?B?ZlNrQXlTUzdmVEEvZHJ1by9oVkMyNEhwZHlkZG1RUWQvbElBRXdUL1I5Rm5O?=
 =?utf-8?B?K016eldLWDRxTzFkMktxU2k1d3Z4R1BGOUh4dnNoanZBeC85Qy9qd2JDS1cz?=
 =?utf-8?Q?jEHMCFF6rstsYPNY2J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5ab9c3-ed79-44c4-d9b2-08deb51fae93
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8803.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 20:54:41.2458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yf0F571pAEa9uw+XUmmXttKRoG6EJkLHKtBmzMdSeNDJf+iiPbNCTrAQ2q+DLb+U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

Hi Tony,


On 5/15/26 14:39, Tony Luck wrote:
> Sashiko reported[1] this issue:
> 
>    During unmount or failure teardown, resctrl_fs_teardown() calls
>    mon_put_kn_priv() (which frees all mon_data structures) followed
>    by rdtgroup_destroy_root() (which destroys kernfs nodes). However, the
>    RDT_DELETED flag is never set for rdtgroup_default.
> 
>    If a concurrent reader (e.g., rdtgroup_mondata_show()) invokes
>    rdtgroup_kn_lock_live(), it drops kernfs active protection and blocks on
>    rdtgroup_mutex. resctrl_fs_teardown() (holding the mutex) proceeds to free
>    the private data and destroy the nodes without waiting for the reader.
> 
>    When the mutex is released, the reader wakes up, observes that RDT_DELETED is
>    not set for the default group, and dereferences the already-freed of->kn->priv
>    pointer.
> 
> Set RDT_DELETED for the default group (if there are any tasks waiting).

It only mentions about the one fix.  It is better to add a line about 
fixing  "Avoid races from pending operations from a previous mount".

> 
> Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
> ---
>   fs/resctrl/rdtgroup.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 506b40dc9430..97d1a3648b9e 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -593,6 +593,13 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
>    */
>   static void rdtgroup_remove(struct rdtgroup *rdtgrp)
>   {
> +	/*
> +	 * Groups created with mkdir() have an extra hold, that doesn't
> +	 * apply to the default group. It is stacically allocated, so

stacically -> statically

Thanks
Babu

> +	 * does not need to be freed.
> +	 */
> +	if (rdtgrp == &rdtgroup_default)
> +		return;
>   	kernfs_put(rdtgrp->kn);
>   	kfree(rdtgrp);
>   }
> @@ -2965,6 +2972,7 @@ static void resctrl_fs_teardown(void)
>   	mon_put_kn_priv();
>   	rdt_pseudo_lock_release();
>   	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
> +	rdtgroup_default.flags = RDT_DELETED;
>   	closid_exit();
>   	schemata_list_destroy();
>   	rdtgroup_destroy_root();
> @@ -2990,6 +2998,12 @@ static int rdt_get_tree(struct fs_context *fc)
>   		goto out;
>   	}
>   
> +	/* Avoid races from pending operations from a previous mount */
> +	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>   	ret = setup_rmid_lru_list();
>   	if (ret)
>   		goto out;
> @@ -4265,6 +4279,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
>   
>   	ctx->kfc.root = rdt_root;
>   	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
> +	rdtgroup_default.flags = 0;
>   
>   	return 0;
>   }

