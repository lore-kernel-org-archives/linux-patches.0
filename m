Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013012.outbound.protection.outlook.com [40.107.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F74B5CD2
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 19:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402939; cv=fail; b=Mjkomtr35CHuhea+w1HxkKwQaUnOixMuDi3HMMpwLhyf8xnRRaQNqD2ctif5SB1gM7y61/k5b3RP0Zrlbch0KUu5/OVSU8EDcymVXEgWXE97xf1FbHl2HuTqQ+FqsiL38p0omxcJX8R5y86Popvle6uu9vLMCNL/Cgkre+SNLlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402939; c=relaxed/simple;
	bh=bTx69nQ4KZKsPd2Adpszfdhni6ZOBJdrKV2TsPg6XK4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=THZZLKh3YrZ+YRhW+KDmajdEBbfDc/vX+SOqHrTRl2jPGRzgOFxgGWQfVi/bQ3MtykzSoHAda53xx4OZhPts5nOJldvZ9QC/nzodlB7xVFeuK/H85M1S6hDdRfAFxDiKMzm6qIDy6eFOyR1wu3Q/Yeb1g4k11O60J+irWvRYstM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FucaWOFI; arc=fail smtp.client-ip=40.107.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FucaWOFI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nF79U+tLgkf0IizaIjBb6jZhTA0atbqO73IdFZopu7+Jm+DYgJrYs1pshTEpIwjOT25+tblvp3V+mewu2/QBd5H1e43gFyN4lgO9iDZ8uj6LnKCUoX4D/+TY8WdBANV5ugYk4z31R3rY02YTk/ojs0PjrItiWN03pv9HwNXgtJTIbwVK6VVHJpQmClCXjxrhzMvFSwjgbAgwVfcQm6PiaWqgxndR+A4B6IGkb4lTcBihNO8E4EBsKTaEx2BN2PMVahobRMgGpgwSPcWJfpGbXZ/GjM8YfhpdDGYsFqENyzrLdVE/HQ8s1+oZV0eULo2JD5AGMth2epNyRVSqwkXdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nk+9F9+kGaRmNenp6EXF5BS2vEk410cUjpaaAzunMdQ=;
 b=BWZlPt3uU3haHHSYpo2NdLvy5NFVVsDPt8B1m62uboHgBvCOAWsfTW3xcPKWHD5lLfOStETVh0Nvj0pdzZHjJUBEIaL/9tqCGbjCUjr+KY7TR0YXd7lBS1nFf7UoSzO98AWhywswD7rghYTE6/rrTicr8YZa/fReX9fOToSUKE1pczY5GveH445F4NMTdA+YQZe6UHe02N8ZGB4c4ZKhynnaTRA3peVRK0DBy9pu1VYyFdEjWNoGhmkso5ummYAuSZUytrmhahz9goVb8oGeE9ZkCTWagdmfyWWeE2S6313GqdYw1vF8Buzllxi5PPhXuuSOBKfeyoO+YaasgcWLeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nk+9F9+kGaRmNenp6EXF5BS2vEk410cUjpaaAzunMdQ=;
 b=FucaWOFIRv/Lx57Q2KSAFRYOTwT1Z7rusHa4MKfFstL2qyYwMYVarh7UdP8ITprYRzU+1T+fMUmSqOdad7zEfZr+JdJiaDcxmKhG0mBeP4mFCt7I3UsNVGVv00otEWGtdpbxDwoN4Xex387NsnE8S7KnVsfgbpwE4qFStawDZw4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by DS6PR12MB600424.namprd12.prod.outlook.com (2603:10b6:8:499::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 19:55:32 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0496.015; Wed, 7 Oct 2026
 19:55:32 +0000
Message-ID: <4aa18085-49b6-48e5-83dc-33d87a60a99d@amd.com>
Date: Wed, 7 Oct 2026 14:55:30 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14.1 19/25] arm,x86,fs/resctrl: Enumerate AET on every
 resctrl mount
To: Tony Luck <tony.luck@intel.com>
Cc: Dave.Martin@arm.com, david.e.box@intel.com, dfustini@baylibre.com,
 fenghuay@nvidia.com, hch@infradead.org, james.morse@arm.com,
 linux-kernel@vger.kernel.org, maciej.wieczor-retman@intel.com,
 patches@lists.linux.dev, peternewman@google.com, reinette.chatre@intel.com,
 x86@kernel.org, yu.c.chen@intel.com
References: <20260928221509.68002-20-tony.luck@intel.com>
 <20260929175231.16576-1-tony.luck@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <20260929175231.16576-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0048.namprd14.prod.outlook.com
 (2603:10b6:610:56::28) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|DS6PR12MB600424:EE_
X-MS-Office365-Filtering-Correlation-Id: 81398393-93b7-467c-943a-08df24acf1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|5023799004|56012099006|22082099003|18002099003|10067099003|11063799006|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info:
	PDUE96Xl7BxxJ4Qy7+Cdy/ZwOYkoPFUP4iqkZiar5bP6zVR+JP+5kKZrBL2qVIPG0RYULAdsq1t+NGFrQ5islm0Px7zpVtP5dMjt1xn1L+zeK79LHZHUkpJ7uSxINWez3uzsLw9h/GICGx3qjylvSfWNF9oTEuXcNc0F3MFdAOcngFUTEZHnwMGQ/IqI87/M5/9BbG1mXQE+ToIshfWQ0YluSohKUr/zNZ1Ymnc+ZK0WVeEnT+C5gveLujHl9rAhkwgvrXfxOtmLBMZavwyAUmFZxA758HfZFe/RcqovkoqS9xTaump6dnHavQrlLoT1ql63acd0ABQpHoSaunsxLDVka6Ay52QfVUX3i5Cr+ETzKLHQoTZnvEs+NmJ4jXCvKxJ6Ia3pUBQTRvmdmEt6FhoVn9NQLlU5qe37hPh7IBmoifQtz3ptmWiQMGOxaP58mUV4ZK75CmyhkvWa/jP+D8QIyj+ijova0Y4hLkWAoh9Tx8JTgYUUMQwbz0NRho90hasvat2g/2eUwDCyxtpjmVYC0UQHWB9RuBysgMNH2uSRoGQLaQxllqaiRtFn0lHQstoKYNO2fxB712JzOidPauF0ur1aYZsX6RerXHGanZoQM5Ryv6K0fbW6i2/QaB7Wm6RaCnIh8TXk0AzL1PdjcOyNh+dLiUpTLnyopIL0i/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(5023799004)(56012099006)(22082099003)(18002099003)(10067099003)(11063799006)(4143699003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzZHR2Q5RHNNMGVBanZCNFFBWkx2Vk9hZVJiZE5QUkNlZVRYS1oxdm1sd0Z4?=
 =?utf-8?B?TndkMTJkYWk0azczNU9NSjB5aEJYY0Y5YzdpT2NsVldIZE11ajhLM0xrbjFX?=
 =?utf-8?B?VFpSTCtYQzNkV0ZPWnU1K3FJZFFBcUJGREZRYUVwR0R4aEE4ZjNrc1hUMUVM?=
 =?utf-8?B?WU94TVRyMDUzQW1UR0ZQeldtTVdDZHJLUGpnTHJOVE9KN3N0N2lDVDhaL3hj?=
 =?utf-8?B?b0VBQ0RTRC9XR0k2MjY3RlN0NnBJUjcyQVRLdm01VGxmUEJaWWdrTm01SEoz?=
 =?utf-8?B?S1R1NUNlTE1YUkFqc1c1Tmt3K1h1SlVMdHNWK0VUeWo1N3BsQ1RyZmtmajg3?=
 =?utf-8?B?bm9GdlpmT2JmMG9qTll1ZGg2dzZYemNjWkY3c2dwQ1g1QmZ5eDh0cWRWK1JK?=
 =?utf-8?B?RXFWd2h6aVpicFVMTWtJd3RkS1d5cUlBVXNPK0I2VjlpUjlvQmxUT0Z6ZE5S?=
 =?utf-8?B?MFZ3WjZ5NHQzMTZHeUFjZEhTTGhiL3E0bnIxT0VHRXZ5RUg3emZ1RmlTSDV5?=
 =?utf-8?B?dFJaRDNHb05CdnVyVERMUjlsMkl5R3g3MmNFb09QUG9NbHJ4Z0kwWkh0MEhz?=
 =?utf-8?B?ZU8zQjkrWVpmak8vK0RDenAyU1I4Q09MYkJQcWFaTGlwd0VBNnV4RmNCeUZk?=
 =?utf-8?B?L05kZVFCcWZzZXBjWGwweC94SUVidHhXTGM0Ym9US0IrMnpVTFllOW4rUmJs?=
 =?utf-8?B?RjR4aU1KRU5lZ2NKL0NZWnkrTGVGM0NsNE5MZEZQek85bkZoTFlSVFRublN0?=
 =?utf-8?B?aXhEOU1LN3kxa3liUTEveHNUREFFUmE4QlVxaEh3Z21wSHptLzBybzUwcHEv?=
 =?utf-8?B?ZnBKTkNGOUw3YnNwU0xGdEpQREs3cm9hdGpyV3lxRnBYWHp4OXpobUFkSU90?=
 =?utf-8?B?VzFQd3IzK3laV2ttTzQ3dEJtOVRKMkVremNabWQ4cVFJMjZJaFFvZ085dENi?=
 =?utf-8?B?RkIxZFMwQnhPSmxtazBLVHlOdE10ZysvWTEyOGRTdEZQMHVCOHhuV1llMmNV?=
 =?utf-8?B?alp3ZW95dkxYeUVnOW9zRExzNFJWVC9WRjRBSTJkdG9GZHFhRElLNTJKajZ6?=
 =?utf-8?B?YnhFaDBFSnlNNktUTVdJdEhzdU81V1NqSTRXb3lJTHoybWNDa29mNTVrb2VU?=
 =?utf-8?B?bm1FL1B6VkhRNzh0QnpjMnk0MWV4MjVBVUdFRFBqUlpCVDBlQWZmbWI1RHlr?=
 =?utf-8?B?TlVwdmNDWU9IWHJ6YUVhTG9qa1dCbW9helU0dW5Cdzh0ZytBcDZzeDhITEVk?=
 =?utf-8?B?NzQyc2kwVVFpMU5iRHJsamtCS2lTUmZsWDlvOUV3Qlp3Z3U5R1drNW1GNkgx?=
 =?utf-8?B?VTFoN0VsM1lBeW5MVkpDYWU3Q3NiSGp1QXExSSs0UE9CZ2p2a2NtUnhuN2oy?=
 =?utf-8?B?UVd2eW9GREQzaDJmWExoaUxpVHk5YWJSY1RkYnAxKzI3Wm8wZVFwZmd3Nkh1?=
 =?utf-8?B?T09VNE5PeDJGbUdWNEpLRU50UlQ0d3RCS1J1bjMyaVQwK3BISkpadEtkbEto?=
 =?utf-8?B?QWRuNlJhbGxsbmZkVEpTVTlKbDlOemdBRldHM2MyWFJaQTk3MEFYTG1HN2Yw?=
 =?utf-8?B?N3pIMURNbUc0WWZpcHZ4NStHaERNMGtybUh0bTlaYk1mNXROTVZsRUdwc3Ru?=
 =?utf-8?B?U3kyL1ZzODZxNEkweE9SbWtrQ043WWlicXBaVXduQlZHRVlINWpOK1VUa2dG?=
 =?utf-8?B?c05YUW9ZYUsybk8yWU9RNytRbE96eWlVWW9aWHU1L212NnVvbS9WYU0xOGxD?=
 =?utf-8?B?dThmMjFVS3hkMnZSdXVRTE15YVF5bG1OZWpBdDZhM1YvRE90K0xQcHA4U2lG?=
 =?utf-8?B?Q0VwTHo2VHNzWFc4cXkwakhZOUxaM1VHaCtzMjdhUmZYTFpqeDZuUEF0OVpJ?=
 =?utf-8?B?QVNhZ3lLSHhQaU1JblVYckk0RWJKZUtUUlZ2UGJpa3RaRG9zWWlvekZlUFB2?=
 =?utf-8?B?SEhPOXVjczJleGUwSXYzVHI0VHR0dFprT0djenBMOWZ3TGZxY3RkbnlyU2FM?=
 =?utf-8?B?cjRmbjlVV1JCYzFPeXlpOVZqdTlzU2VjdXh0aUhXUDkwN3M1SmpEcVN4dFNx?=
 =?utf-8?B?T2V2WnFCVmJhNHFCY3B1b3lucmxYYUppdFdUZlBvVnpMSlRoamVGRzI4TGxm?=
 =?utf-8?B?bW85amxNMTEwVzVjVXRyUVNWb1pWRHcwbDk4YU5pMEJxMWszd2ZlSWp2MWNl?=
 =?utf-8?B?Ym1yMEJEclpHT2R6MjVNVlMyVFRSYWlNbk00N0NKT2prUlRrb2VjMXV6Qkt0?=
 =?utf-8?B?R2l1Q1VPM2xXMngxZTFMQ1k5TW5pN2ZBQjk1bmZncHR4Q3JZSWRoYjRrVVRS?=
 =?utf-8?Q?W6P6K90Sa3AMAjULnr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81398393-93b7-467c-943a-08df24acf1fb
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 19:55:32.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2JOrR5yPh+2vHvjESRTzOmo8jE7LU//Q43jiYIJIzJ4U1kVSCSFxNT98FN/yris
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB600424

Hi Tony,

On 9/29/26 12:52, Tony Luck wrote:
> The pmt_telemetry driver is built-in, and Application Energy Telemetry (AET)
> is only enumerated on the first mount of the resctrl file system.
> 
> In order to allow the pmt_telemetry driver to be a module, changes are
> needed to place a hold on the driver only while the resctrl file system
> is mounted. This means that resctrl must enumerate AET features on every
> mount, and clean up on every unmount.
> 
> There are changes to three software layers:
> 
> 1) resctrl file system
>     Call architecture code for every mount and unmount. Locking is needed
>     here so that architecture code can be sure that every call to
>     resctrl_arch_pre_mount() occurs while the file system is not mounted,
>     and resctrl_arch_unmount() occurs only to clean up a failed mount or
>     to unmount the file system.
> 
> 2) Architecture code
>     New function resctrl_arch_unmount(). On x86 this calls the AET code
>     if RDT_RESOURCE_PERF_PKG was marked as supporting monitoring by an
>     earlier mount attempt. It completes cleanup by removing all domains
>     used by AET.
> 
> 3) AET code
>     Disables all AET events and informs pmt_telemetry driver that it is no
>     longer using the pmt_feature_group structures it received during mount.
>     Releases the hold on the pmt_telemetry driver allowing it to be unloaded.
>     All cleanup is handled by intel_aet_unmount() and intel_aet_exit() is
>     no longer needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v14:
> 	aet_register_lock name changed to aet_lock.
> ---
>   include/linux/resctrl.h                 | 10 +++++++--
>   arch/x86/kernel/cpu/resctrl/internal.h  |  4 ++--
>   arch/x86/kernel/cpu/resctrl/core.c      | 21 +++++++++++++++--
>   arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++-----
>   drivers/resctrl/mpam_resctrl.c          |  4 ++++
>   fs/resctrl/rdtgroup.c                   | 30 ++++++++++++++++++++-----
>   6 files changed, 81 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index c77e24c0d8b6..c40d72e4a957 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -611,11 +611,17 @@ void resctrl_online_cpu(unsigned int cpu);
>   void resctrl_offline_cpu(unsigned int cpu);
>   
>   /*
> - * Architecture hook called at beginning of first file system mount attempt.
> - * No locks are held.
> + * Architecture hook called at beginning of each file system mount attempt.
> + * Serialized against other mount and unmount attempts.
>    */
>   void resctrl_arch_pre_mount(void);
>   
> +/*
> + * Architecture hook called when mount fails, or on unmount.
> + * Serialized against other mount and unmount attempts.
> + */
> +void resctrl_arch_unmount(void);
> +
>   /**
>    * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>    *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 8406addc05f5..c66954bc01e7 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>   void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>   
>   #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> -void __exit intel_aet_exit(void);
>   bool intel_aet_pre_mount(void);
> +void intel_aet_unmount(void);
>   int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>   void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>   				struct list_head *add_pos);
>   bool intel_handle_aet_option(bool force_off, char *tok);
>   #else
> -static inline void __exit intel_aet_exit(void) { }
>   static inline bool intel_aet_pre_mount(void) { return false; }
> +static inline void intel_aet_unmount(void) { }
>   static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>   {
>   	return -EINVAL;
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index ac67b4523b2d..40466f29e48e 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -811,6 +811,25 @@ void resctrl_arch_pre_mount(void)
>   	cpus_read_unlock();
>   }
>   
> +void resctrl_arch_unmount(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	int cpu;
> +
> +	if (!r->mon_capable)
> +		return;
> +
> +	intel_aet_unmount();
> +
> +	cpus_read_lock();
> +	mutex_lock(&domain_list_lock);
> +	for_each_online_cpu(cpu)
> +		domain_remove_cpu_mon(cpu, r);
> +	r->mon_capable = false;
> +	mutex_unlock(&domain_list_lock);
> +	cpus_read_unlock();
> +}
> +
>   enum {
>   	RDT_FLAG_CMT,
>   	RDT_FLAG_MBM_TOTAL,
> @@ -1161,8 +1180,6 @@ late_initcall(resctrl_arch_late_init);
>   
>   static void __exit resctrl_arch_exit(void)
>   {
> -	intel_aet_exit();
> -
>   	cpuhp_remove_state(rdt_online);
>   
>   	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index d79c459f4c54..e7cd7d8a80cd 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -297,7 +297,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
>   
>   /*
>    * Serialises AET's view of pmt_telemetry:
> - *   - pmt_module, get_feature, put_feature
> + *   - pmt_module, get_feature, put_feature, pmt_in_use
>    *   - every event_group's ->pfg
>    *
>    * Lock ordering with pmt/telemetry.c's ep_lock is ep_lock -> aet_lock.
> @@ -311,6 +311,11 @@ static struct module *pmt_module;
>   static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
>   static void (*put_feature)(struct pmt_feature_group *p);
>   
> +/*
> + * Track whether pmt_telemetry enumeration succeeded during mount for use during unmount.
> + */
> +static bool pmt_in_use;
> +
>   /*
>    * Request a copy of struct pmt_feature_group for each event group. If there is
>    * one, the returned structure has an array of telemetry_region structures,
> @@ -395,19 +400,33 @@ bool intel_aet_pre_mount(void)
>   		return false;
>   	}
>   
> +	pmt_in_use = true;
> +
>   	return true;
>   }
>   
> -void __exit intel_aet_exit(void)
> +void intel_aet_unmount(void)
>   {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>   	struct event_group **peg;
>   
> +	guard(mutex)(&aet_lock);
> +	if (!pmt_in_use)
> +		return;
> +
>   	for_each_event_group(peg) {
> -		if ((*peg)->pfg) {
> -			put_feature((*peg)->pfg);
> -			(*peg)->pfg = NULL;
> +		struct event_group *e = *peg;
> +
> +		if (e->pfg) {
> +			for (int i = 0; i < e->num_events; i++)
> +				resctrl_disable_mon_event(e->evts[i].id);
> +			put_feature(e->pfg);
> +			e->pfg = NULL;
>   		}
>   	}
> +	module_put(pmt_module);
> +	pmt_in_use = false;
> +	r->mon.num_rmid = 0;
>   }
>   
>   #define DATA_VALID	BIT_ULL(63)
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 360a50eb0cd3..ecea2239afa4 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -121,6 +121,10 @@ void resctrl_arch_pre_mount(void)
>   {
>   }
>   
> +void resctrl_arch_unmount(void)
> +{
> +}
> +
>   bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
>   {
>   	return mpam_resctrl_controls[rid].cdp_enabled;
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index ecdb5da50179..20e579067570 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -30,6 +30,9 @@
>   
>   #include "internal.h"
>   
> +/* Mutex protecting resctrl_mounted and mount/unmount operations */
> +static DEFINE_MUTEX(resctrl_mount_lock);
> +
>   /* Mutex to protect rdtgroup access. */
>   DEFINE_MUTEX(rdtgroup_mutex);
>   
> @@ -48,7 +51,10 @@ LIST_HEAD(resctrl_schema_all);
>    */
>   static LIST_HEAD(mon_data_kn_priv_list);
>   
> -/* The filesystem can only be mounted once. */
> +/*
> + * The filesystem can only be mounted once. Can only be updated
> + * while holding both resctrl_mount_lock and rdtgroup_mutex.
> + */
>   bool resctrl_mounted;
>   
>   /* Kernel fs node for "info" directory under root */
> @@ -3147,6 +3153,7 @@ static void resctrl_unmount(void)
>   {
>   	struct rdt_resource *r;
>   
> +	mutex_lock(&resctrl_mount_lock);
>   	cpus_read_lock();
>   	mutex_lock(&rdtgroup_mutex);
>   
> @@ -3164,6 +3171,8 @@ static void resctrl_unmount(void)
>   	resctrl_mounted = false;
>   	mutex_unlock(&rdtgroup_mutex);
>   	cpus_read_unlock();
> +	resctrl_arch_unmount();
> +	mutex_unlock(&resctrl_mount_lock);
>   }
>   
>   static int rdt_get_tree(struct fs_context *fc)
> @@ -3175,24 +3184,27 @@ static int rdt_get_tree(struct fs_context *fc)
>   	struct rdt_resource *r;
>   	int ret;
>   
> -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> +	mutex_lock(&resctrl_mount_lock);
>   
> -	cpus_read_lock();
> -	mutex_lock(&rdtgroup_mutex);
>   	/*
>   	 * resctrl file system can only be mounted once.
>   	 */
>   	if (resctrl_mounted) {
>   		ret = -EBUSY;
> -		goto out;
> +		goto out_mount_unlock;
>   	}
>   
>   	/* Avoid races from pending operations from a previous mount */
>   	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
>   		ret = -EBUSY;
> -		goto out;
> +		goto out_mount_unlock;
>   	}
>   
> +	resctrl_arch_pre_mount();

I dont completely understand this.

After this function call, e->force_off can be permanently modified, 
whereas previously it was only altered by the boot options. Is this 
behavior expected?

Thanks
Babu
