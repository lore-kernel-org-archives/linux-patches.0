Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012051.outbound.protection.outlook.com [40.93.195.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EEB4F0553
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790012715; cv=fail; b=N8Nazs7J6igtLFU2aCvaFMEfd2BpwGo6t+kciRwaSagjFwkQEFx6nS39ib2ZKbmzekKmBoBQsVoTtH+e0AHmO6EnKwFRJ8nlq7jUnFXWB+68ndL6WSHOvhsq2K/2JLITkdUban8J09VtUBIAMYzTlJpmil8h5WiKV9go/FsepCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790012715; c=relaxed/simple;
	bh=tpNYysF2IQI6Z9dIzVsUpY5R7cLfr2LAPUePNzmjPHI=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eR/vKtG9LNGDtcDY/mlKntC+ETHgiS8mkTKkyDOKlwceaX0PoKz7qXab8owNtormjuXWqepmSbJhNv58xuepcXQY9W64/lAIC4cpcK+qCj7Bomn87b/kd6xfQp7Z9efBPY5PftBqt0WF4XqI2onoovtrOBYPyRTUFCTOfEVIwqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j5RCJhjx; arc=fail smtp.client-ip=40.93.195.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j5RCJhjx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TWzjYHEcTWB+7VObvSMCEXdb5dg007KR/Hgn2OZoeeKBNFSCWp94P9xihFMwMK/RKGKJHXfGbUqRiyLJ1NkPAIRPtBxEXWcWDc5tJ0ZbokpDHxHfWZfjFQFqEKKT0Ayx2OBt1UKnXqgOZk+jdURfvADcHXsv44pax9qaBfmRoIsaYUB0p2/yeRHTdr719XHDW8Fc7f4fgoFKoWLjZn8G1pW4uErwfgArOtHikH7lZ/aN8Us6b146MwFnEAhjwtLW64Id0tUYVJ/b2HtxRWorX4GrqaFi2Bp1FvXRetM8qF/07c8R9uzBEuXHjlbsa/wkJmv8g63ZAW2MJjcEPiL8HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9EgtPtlNfpVm5YjvgT0z2WHgB2MFEpx52v+tC7i/qI=;
 b=N11xOIvtAqzPZWkRT2vt7A9jGnbB/8SPZaSbuAh5lrnfcKtQjCRNexfcQrYpywR5bQGQTus//7cE4TINmkKSPLzqrVV3pi5B8r0ZkuUnvaKiqvxxty4UvSZWqDDks3FOrI6uOAIHlhOdwH9kZwOhLnx5LBfhJJcCGrwyAC9BBWzZHStKIEcz8cPKbfajxaOJDRH/F6NYzR5dhpas6e8WJFteA8oNtRYUqRzcYRWpF5LhFyL1dlCP1TauDFRXTVf+jpzyCweKwb/rShHi9vpEIQXR6JDNaK8pdTTTKiGbrFHb83FpZxDkCpOT3HLMhxB1/TAuvpiVbJLQnnuLtEaQVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9EgtPtlNfpVm5YjvgT0z2WHgB2MFEpx52v+tC7i/qI=;
 b=j5RCJhjx9G3v+6lVsw8PJyikJmr7zh6SoWGxrDPNeRtdAGelZE1i5sZdJAqtbjUX7aTC/BDv7XIAZmnw0J+44G2bJuBp2J0FbXC89e6oaE4U11fAgn0I9+6qqhHTig5wwiEOQ3XJ3Y8q3WiNXeC/4G1Hkg6hY1a+kAIkhgGzeJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 17:45:05 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 17:45:04 +0000
Message-ID: <8e553b96-0755-4d23-967f-5d8a7a725474@amd.com>
Date: Mon, 21 Sep 2026 12:45:02 -0500
User-Agent: Mozilla Thunderbird Beta
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v12 04/25] x86/resctrl: Apply Intel MBM quirk from
 rdt_get_l3_mon_config()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-5-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-5-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:610:e5::25) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5e1406-db78-47c8-43fa-08df18081195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|921020|4143699003|10067099003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	xZUENJ6mLqId24sUjZWY7TGH7JQibYQ00tg1WGchk8UFUtm1cy+iEgGCn2mP2MN4mRG7lOtH8S3ra2e/RHjpIDQJFSppEv233DV9LhB4YVtMovFjIgFVKTGe/Yld1TPZDOKdPuSuklcHVuN43MyICBn66jJTSomk0lT1fQaj2V8Su+gvnIhD2K/b3C/lpTeuYI/37th3jyQ3xf6BNh+U2v9TtcBbiyBQ747bPXiA5jqhDNlWejTTjcy4TAAvCqwxgvCjaWNO4leJ0noJVWc163lyJRGagqdukM3+/VKJlkMEOgjKKm1dwDvnEkiNLfTFWX+k/6WzXHG+s7Vwo++b59JGisqQ02Iv9V/uKM2H9oNR30mQpq/3AO1ykH6VIBqSi0ci5k/GMl7e9cCjy0x4mI21zsIU8RxvL4u2NXKsJsD4/+GW2GflV+F9VyWXk12LZz7ot40MMD6gbDnUox7cglGlMpc4shdhtyxDPzq+YW6tNa+GKBuyBP/2Q6cEpYjfL66h9y6v0FbtOOsZ0oqjz9zBVc/CNPIVeP1Y0lfo9LDMP58/AhGvnfS+NhdpJCdN4ZEbHyhsLBxYomeGBCQ3JN0v/h0j+69a4XC7KXBOe5LkuHGz4EZMDz98Uj0E89WpRbKeYqyDakLgw/7vZ0z6TezvcK+aEkEW9S2TO7ch23TJRyygiu0IE+V1kiuHI5HYZFl7xR1CTztrZ1pBebgi7w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(921020)(4143699003)(10067099003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0xuQWN6bGptR3JrRDNaK09JM3g4dzZrK0ZqZGphNGxCaEs5NUhqa213Sklh?=
 =?utf-8?B?NUZZQUd1UDJkeUt6MXhmTmw0QnI1ZkVhWWY3aW8vWno2MHJmN3Q0VHBIdExt?=
 =?utf-8?B?V2lMVG15UHp0NFBmcGRURU9FcVllQlNmaU5Hb21DOXg1b3ZCL2I2SkloL2VS?=
 =?utf-8?B?Tm56TlUwR1U5eEFKQ2U4b0VBY2M1SVFJK21IRnVCUkJNTFp1TlExVTA2NlRx?=
 =?utf-8?B?Zi9qdXFTbmlrSjJnUFpJZ1NpSnB6VVltMnVjS0F5WFhkamtTeE1iU1BhZ1Z0?=
 =?utf-8?B?RFRiOTBLUktFajdHZFdVdnJlT20zdTZ2WFNOL1VxTTJmMVU4Nm5rVElZRjN3?=
 =?utf-8?B?MzhQeGovbUpWSE1vdkU4c0NPS3pmR0p4NmZ0R3JoOFBoVGRKSGVqLzBlM25M?=
 =?utf-8?B?ZWk0dGtwOEdhemQ3aXo2THgrMjFPckVoK2xTdE5RMmxpV05PdWxISGZ5dUZ6?=
 =?utf-8?B?bmUrSE5aS2tpc2MwaFJRL0lINVR1YVIzK1FEcjEwK2h5Y004ZzlkQjBNaERF?=
 =?utf-8?B?MFhhYkxlR3ZmSFF1SzdnNWlldkt5M1B2RXh5bVRGUUNYUFArOEJBQ281YVd5?=
 =?utf-8?B?SnpvVUx6MGgyOXFzckNvdUNxajZ2Z29kZitZcER0RzAzbGFHVC9OU1Vxck5i?=
 =?utf-8?B?S2xiMzB2UjMvTGtDLy9kUURYOEx0TS8xTkpjT2JMQzloQkVqV2JEdDVUc3Bq?=
 =?utf-8?B?N3FZcDU4cERkR2lvOXcyUTJUbkJGRHU3M3gxVWZUYzl0a3RtN1BybWhaUEpv?=
 =?utf-8?B?eDFCOFBDUzgrWjVIRTZEMU96Q3krOGhCUlcxeityTHFUR2FteEtxYmpQOU4r?=
 =?utf-8?B?VkREN3JyWFJpWEEvd2lxTGZRUEc5YzlEUmYxWXQvbG5QNHhrR2V4bUZUV21H?=
 =?utf-8?B?K3JYWER1UW54a0l4WGZZejBrRUVFT1dCVnFsSWVLcFZQUHFoQWpmU01MVkRm?=
 =?utf-8?B?d09CM3Q5RlkrVUc1TmkxZE4walZuQ3JvZlZmdURMN2JWdHp2andyM25yZ3dZ?=
 =?utf-8?B?WDJzTW1yNi9FZ0ZpQUhOanNzbG1sWFMzanRpVFB5cW0xK0lFdVZmWndXOWcx?=
 =?utf-8?B?WFVpZzAyVHVWbU1OWHRlTUhBcWM0dEhCVit5ZEowcExucUNPNHdXYlJ5Q0t0?=
 =?utf-8?B?d3BnU3hGTXZ4U0pLUFJQNGZ4Ym5Sa3ZxZ3ByWFU5dlB4TnlWcE54WlZramg2?=
 =?utf-8?B?SWgzSGJPYjQ2UWpWRW1WdFRpNzNhSmYwNExwQnlWM3VtcHdZVDNZMFJ3UG9n?=
 =?utf-8?B?ellFemVPMVZSeVBsMG5ZWGRVTHFobUNTNEdjbFdvNHdibFIwMUpnaFZvMHQ4?=
 =?utf-8?B?QzdWbnE0ci9oSzY1K2x2SjE1bVo3N21MU0JjZW54dUVxajNpeHhDemovQ29x?=
 =?utf-8?B?VUdVSVZUZE82KzlLdHNLb1VVeHlpNWRtdjBtK0hMditpdkkrbXNJTCs3Y29S?=
 =?utf-8?B?QnJGU1N2c1VQWklBVTlOZ3orUUluVkZ2aFpKdmZ6RHVMS0JKcnJlVDdMNHA5?=
 =?utf-8?B?TVJMMGdTM0RBbWlSaUVWd2c4a0xaeDlQdVBLTGxhTTFUd0EyUVlXcUlMb1pr?=
 =?utf-8?B?OGczN0s2WHdRTkZnRWFNQkVMMEUvVnp6YUM4bzBQTnVCbVBrVElNUFRxQXFK?=
 =?utf-8?B?Z3EvNGZ3WmlZcEYwMzZWUHB2WFBpVmV5eGw2ZEExVkl0N1kwZlRqbzlVbzJP?=
 =?utf-8?B?YU04YmhQbTZ4aVJlNzJ6QitCdStwaElxOU9hS0JZZHdmOXF2MnpJaVpjTUZD?=
 =?utf-8?B?OGNpaGppcXVCQ09hS2ZYV2ZYQkE5b1Y3cmY4VVFXZmlhVlB4S2RVeVVqTDFI?=
 =?utf-8?B?RmpORDlqN3cvTHcwU0YrMlNYSlM4MFRGc3BSVmNDNDd3TmRXbG5XVVdCcUFp?=
 =?utf-8?B?eEVCeDAxWnNqdFNBT2VveUtTUFVLYzdkc1cvYWtrbHd0MjB4bDlXbDBaUzRC?=
 =?utf-8?B?QTVzNENMVTR3bTBvTDFLanc1cGl1ZlhFWTZVbGhyN09NQzlCT01hOW9aSVl1?=
 =?utf-8?B?OHZydjZsWVNpdmhLRTg4UVhOaXpwV1RLbWlmY0lMWVpmbk1HSVY5OUtDZ2Z0?=
 =?utf-8?B?S3ZKSktJd0x1T3Y5QlY1TndTaFUrRlYxdXFmSzlETjVaN1gwNU8xcnBYV0NT?=
 =?utf-8?B?UFFtQzdzRE9rdjNoYVQzK0VIc3JPbmIyZWNiWExvbUgxRVIvZHVwbVEzdGhP?=
 =?utf-8?B?SzREdlZpS2VqZWNGSXFuNDlJcHQza2ZtZHBHdDhkRXY0V2U5OVhBc0ZGWkZF?=
 =?utf-8?B?VmtTVHI4RjE1SUJZcFRwY3l4U0hLVXdVRk5mSGo3MTkyQURQNUJwbnl1Wmxo?=
 =?utf-8?Q?TDfz/AfsqIHAACoxNI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5e1406-db78-47c8-43fa-08df18081195
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 17:45:04.4888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apOmGzHr2llybPXPRJhcx/Ts/2wHXFhv+E5RPh8T8Vryoh2OrnyADHwb0p+AjdVl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965

Hi Tony,

I cannot test the AET telemetry functionality, but I have tested the 
series on my AMD systems. It appears to work as expected, with no 
observed side effects.

A few comments below.

On 9/16/26 18:12, Tony Luck wrote:
> The Intel quirk to adjust Memory Bandwidth Monitoring (MBM) values on
> certain CPUs is applied early, before discovering if MBM is supported.
> 
> Move the call into rdt_get_l3_mon_config(), but keep the decision on
> whether it is needed in __check_quirks_intel() with all the other
> model specific tests.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	Change type of cf_index to unsigned in intel_rdt_mbm_apply_quirk()
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h |  4 +--
>   arch/x86/kernel/cpu/resctrl/core.c     |  2 +-
>   arch/x86/kernel/cpu/resctrl/monitor.c  | 35 +++++++++++++++-----------
>   3 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e3cfa0c10e92..e46eb9a4c725 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -151,6 +151,8 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
>   
>   extern struct rdt_hw_resource rdt_resources_all[];
>   
> +extern bool __initdata intel_rdt_mbm_need_quirk;
> +
>   void arch_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
>   
>   /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
> @@ -228,8 +230,6 @@ int rdt_get_l3_mon_config(struct rdt_resource *r);
>   
>   bool rdt_cpu_has(int flag);
>   
> -void __init intel_rdt_mbm_apply_quirk(void);
> -
>   void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>   void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 34ca3c7cc046..82b27a0157ae 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -1011,7 +1011,7 @@ static __init void __check_quirks_intel(void)
>   			set_rdt_options("!l3cat");
>   		fallthrough;
>   	case INTEL_BROADWELL_X:
> -		intel_rdt_mbm_apply_quirk();
> +		intel_rdt_mbm_need_quirk = true;
>   		break;
>   	}
>   }
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 89b83cc7e800..ab9cb34145c5 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -37,6 +37,8 @@ bool rdt_mon_capable;
>    */
>   unsigned int __ro_after_init rdt_l3_mon_scale;
>   
> +bool __initdata intel_rdt_mbm_need_quirk;
> +
>   #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>   
>   static int snc_nodes_per_l3_cache = 1;
> @@ -51,7 +53,7 @@ static int snc_nodes_per_l3_cache = 1;
>    * 1. The threshold 0 is changed to rmid count - 1 so don't do correction
>    *    for the case.
>    * 2. MBM total and local correction table indexed by core counter which is
> - *    equal to (x86_cache_max_rmid + 1) / 8 - 1 and is from 0 up to 27.
> + *    equal to r->mon.num_rmid / 8 - 1 and is from 0 up to 27.
>    * 3. The correction factor is normalized to 2^20 (1048576) so it's faster
>    *    to calculate corrected value by shifting:
>    *    corrected_value = (original_value * correction_factor) >> 20
> @@ -421,6 +423,20 @@ static __init int snc_get_config(void)
>   	return ret;
>   }
>   
> +static void __init intel_rdt_mbm_apply_quirk(u32 num_rmid)
> +{
> +	unsigned int cf_index;
> +
> +	cf_index = num_rmid / 8 - 1;
> +	if (cf_index >= ARRAY_SIZE(mbm_cf_table)) {
> +		pr_info("No MBM correction factor available\n");
> +		return;
> +	}
> +
> +	mbm_cf_rmidthreshold = mbm_cf_table[cf_index].rmidthreshold;
> +	mbm_cf = mbm_cf_table[cf_index].cf;
> +}
> +
>   int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>   {
>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> @@ -500,25 +516,14 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>   		hw_res->mbm_cntr_assign_enabled = true;
>   	}
>   
> +	if (intel_rdt_mbm_need_quirk)
> +		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);

Not a bug right now.  Is it cleaner to send num_rmid instead of SNC 
adjusted r->mon.num_rmid ?

Thanks
Babu
