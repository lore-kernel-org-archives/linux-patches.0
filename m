Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAAA2D5A01
	for <patches@lists.linux.dev>; Mon, 18 May 2026 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137714; cv=fail; b=AplOwwJn6q3qMta7K3iCW2VrjetLieFdDxFHlS/Ps3N3dkFEVZom+Igyai0OLkstNuPSSpa+PFyhVnDlril5F9Mz3ZE7TFRMX8697bk2FgpShzbT59puO+V9pIjLO+E1f5K93xYP9k5dJ8PkUVv5F9alVhse+jOXW1JyPtd2/TQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137714; c=relaxed/simple;
	bh=/GKw1u5MqXLqyEYwt5WAmrW7FridGtLTpbu5bTewuTw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e5xj/ejY0hIIxH23RUBBGpYs5sRZuHnTqcELD+dxF2aWRk1iJLqxpeg4gqn492giC0ZFrBZFlpe9/c/vDfpGHNCOnoo0RourggYF/2aJh5T4MO4SS1cdzehLY33ZTbWjPu3dcn758WbDvHwhrHr6g48+sPZV2NmgBKgMgE8mZK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bNkCnsSa; arc=fail smtp.client-ip=52.101.61.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bNkCnsSa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fwJd7G2B0gpfppB4oSKCGMgotq70drLLzH6FUhnHjBh2iWhrkP2POTMlPuq6KrhbPevQXH1mUuxOokwnHtTaN1SykLzsDogT/krjyvFZN8DkjZzZ/OvkXl7XbuxxGS8Zzjo/dXo8BeYlVyxpBfMQMKKuEKKLTfkJ0JbE0unWBqONvaV2d2fkALNXvJikfcpOzCZ7/pJbjdqN1oUPWYq5ewn+qR2N9RvZ5HeuP7P5DFDVYDQqaVjeebayFIex2H3D18PuJcM8Er+avpIA2z64s7tydyaHp7zBNo1j1nDrnebe3Ehk8fGDH6mzdrK8k4vMi8+5tO4CafHdFNdk9o+xDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6iVRpTHh7Z1d3qBvk96d1k+ESd3dUksXxgIPUUIEHA=;
 b=luu8LD+xdwATS3sQrGPXgpbkg9MJ2huKTVidpbSZWIbiJHCAE2Jh6g9/W42BnE7Rqjy28SlOXiI+VG4bcwGNzVanYaOz7PFUVJLf7TF2Zff8zdiLTcgOtkooVeufTj29Sa3Z7UqtzYZh/7i63eC4NHwcm0b4k8mkGK0zQ4mor71zPzawTbNYN696jPbUieg3uONE4UPGaB02qJELOGheAk0M4Y0so12vbPAS54i2VwRFXon6VuT+4EcyR9M9THT1MuVPrl0j1IAgqx26diC1WmC0r2MAVBLO0AR1wFPGqWfO11/7vB8WRjDKemYPodGF4N8olVzT8CA/eZoqTjl1CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6iVRpTHh7Z1d3qBvk96d1k+ESd3dUksXxgIPUUIEHA=;
 b=bNkCnsSaoIoQevqvqVZyC2+SmnUdaREurtOCJ4fvgkNPlWSTZ6jszc5JVSR+8bYOfwo+tw89cGEu+ACLdjzXTZmqJFPrNh6kznMI3KNVyIkgnTNafyURylHyx0xQqrUqai4SVPs9XPIDDBlOM9y6ig4VPOYCK0SiB8h5kTL2AWg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 20:55:01 +0000
Received: from SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f]) by SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 20:55:01 +0000
Message-ID: <75aa4c10-8e5a-4a9b-b702-100d761fa13a@amd.com>
Date: Mon, 18 May 2026 15:54:59 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v2 4/5] fs/resctrl: Fix deadlock for errors during mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-5-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260515193944.15114-5-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:610:cc::13) To SA3PR12MB8803.namprd12.prod.outlook.com
 (2603:10b6:806:317::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8803:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: d1cb8896-6702-4c14-7458-08deb51fba92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|4143699003|11063799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Bc/kQtDXJ86HBiQSzQxz25DzYcPcZJrz7JPU5Xeddu93Hy/1Nbfr3IIArD+9XqFtCFqB9z6RbdZmBxJOTDuKzEdqUrGBixrmZl5es3NMyNTVpg9IYB+zCd8d3hvoJTay69Xz6KBqeVMsfAIB4y2rFI4S2roMQzCIFBpSFPyNAHLe4dJYzrkT6hsgwTNchwHXoNYnPpIPxeselrxtUjNh8PznkSSgLNtBi6t8gnZiZKVpKDbxJzxLYvbT39x0fNBvuK/oTv3JycuRr1SFb90n4rN8mEAWGywrpaTnjQp8D/58nymV6kIGf9cRSqUl7GXFr0HjdHnCsjYsSlkgN9bN+sUJKQsAyoVt0+BQCTn/0koSI7+B+WAsLjq9l+IaN4uREWhZOeRRUURZiS3c/0DElyvo51Ie35sf4sqcKQZ1Juj3fTi2Y8NEft/GWjupindWdRHjmYn3vzOKaShWIv95NsYRM0ZtSZuct6lnOBvDxHC08NEpdmi//v0438ARKUIRn2upUnnNnPX14mnfRW0E1ZsAtE98wrRKtXw7a6jYYvKszah3Qxf/343HB5mVn7E1EhUB0a7DG2SPZAKMzTV6f2z5VQFqEEblHVa2N1QHzKRmWn9SXBvfjtUIzETarEJBCWOnOgEouqNK9032cbnD0w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8803.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(4143699003)(11063799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUwrMm1ielg4U01wVnBvNnNEdmJqS3JiVnNoVWtYSUxMaGhGT3cxWXk1ck4v?=
 =?utf-8?B?UzYrWmxSL21EMTEvK3NpRUp4UmFBNFBLOWVMU2lJQWQ4OHQ0YXUvbUUwRVFo?=
 =?utf-8?B?WnFVTGV5WWZZTzRPdzQrYVNqOW91MWNycFE0MlhRVUJYZXJ2SkRYYnZndURa?=
 =?utf-8?B?bGdObEtZL1YweGN5L0ZldUlMVm1mdHNpUGFjcHluL2k5VjlXM2VPdm9hblc1?=
 =?utf-8?B?djRUWWd4c1RFdDl3ZzBXNnU4eTZzWEdna3Z0c2l1T25jdDlTS241ckp3TGJ5?=
 =?utf-8?B?c1Q1TXFlenpxeTdSWlJCYnVuWG0yWm8rTkFidHBRRmdTSFFBaXJIcVI1N2Za?=
 =?utf-8?B?YjJ3ZUprSU1sNURsdVYwblRnRDJpdmdZakVjVG1QSVNPMFcrdGxTNFd0cnRH?=
 =?utf-8?B?Y1dwcmRvZ1oyUXlQcC8ySFV5YUJISjNESkxZTHZwc2g1VjkvRTlrUEhGTkxD?=
 =?utf-8?B?S2FJMzZhV2syMDlka3BjZEZESWNaaVV5bHM2bkdrSFUrc3R4b2VIVXpPNm1s?=
 =?utf-8?B?aHpNME5ZTnB2UTFKWFpnVG1pb0h5UkN1S0c4a1N5RGp4S0xOMGUvNUREaTRE?=
 =?utf-8?B?dGt5cUhrQTZaSzdlZ0tFWVJaczFaVW10dkNKYUEwc1dMNmFSbEExSnluSkFX?=
 =?utf-8?B?eFlvb2dQZzlFcmYweDVDMWFPWHlLN3A2U2ptSVBFSnlGdFZtSHgrcmptblYw?=
 =?utf-8?B?NzJvem1JRDJ5VXNhZTBCcGZ0RDJXQnB3RktZdy82anVnTzl1VDdoaEpwV0M4?=
 =?utf-8?B?cGZ2eXlrWmJzY1Jmbk1ZUnppdExRSHh6NFRPRnhSRWxIL2JnMmdkeEpNYVF2?=
 =?utf-8?B?ZWJWZlFNWjF1U0FRbzZGb1RmSjlRU2VFNUZ5MUlWS21BazRBbytsbVZuM3Vp?=
 =?utf-8?B?WVJXekx5UGhwNlAvcThES0RMMXVkdmlxM3Z3eEREKzc2TjdSSjA3NThkRVFX?=
 =?utf-8?B?OEZHM241d1pBckhzNXNnd0VEYkNGck0wRnQ2eVZJYXhFY0dKZXMrV0tDRll6?=
 =?utf-8?B?NjFRcm1rUHF5U1crSmVtTm5UWnBzditwdnVSVWpiREM1bkxUN3NhQmFkZXJ6?=
 =?utf-8?B?ekNUVTMrRVA1WDgxcys4STZ2OE5TMzRvTFA4RUVxTDFXcHVQSVNxZVdvY2Vp?=
 =?utf-8?B?SnlEV29Va0tzRFlqZWJSTFFZRDlUV3p6ZGdEdWNsUWp3VEY4TGtVSGRPYnJB?=
 =?utf-8?B?dXY3Wkc2VHNZQ0ExdXdINWNTTVE0WWJSbW9pTW1LdWMrbUpLUE5Ua1RPVDhi?=
 =?utf-8?B?MnNSeGxBY1lHcytqL0JMTVhreGpvUlZpYXlRZXplU3RyK2JobUdSei9HSEJD?=
 =?utf-8?B?MGN2blFWMW42ZUdhQ3Ira3NaRFBKZThjYkl1U2d4NmJkU3BRYk9uaFBhNG1n?=
 =?utf-8?B?OTZpLzk3MHdoTXJ5QWlucndPWmsySUhTMXFnSmsraE1oOEthekhQUy9wNkVN?=
 =?utf-8?B?R2E5L0lSRDBCRS9ZVE9qT3hIbUFpQ2RaWDVPSHB0Qmh4d1ZzQk45b3JXRFZX?=
 =?utf-8?B?RlJpZkFJbUc0YUZQQk92dkIxVVVXREdXQU9oekZnbkNxU3VaOVFpWmwwMyt4?=
 =?utf-8?B?SncyQVZZcW9MSWgzUmFOZEE4MFNhQ1lIUHdud05GYU9QdjlaYVZLUHVsVVZX?=
 =?utf-8?B?ZFRFdmRZZVl0S01yS0pyUERDRWRCSUVLQjFhTmtuTXhvSFV0M1JGT3JwSEhn?=
 =?utf-8?B?Y0JkcTUySmNTdnA1anBtc1d6M1QwNzlHNUZyMWJMRnEyRjNhdXVuRXJnK1FN?=
 =?utf-8?B?a09MTWxtbWM1Z0JUenBWWHJtd21GZHcybzF4VXJqRWc5MktYOHZxSVFnTmxH?=
 =?utf-8?B?KzFqZHZPYTJDWDJDSUs4eDRCaERyZ28wbTczMWRpZklzaEJWamV1bzlzS2lo?=
 =?utf-8?B?dTZqWXNqTFE1em4yN2hmMENESGlEV0xubG9ManJSN05vVlYvVFNQZG5NdVRV?=
 =?utf-8?B?eVY4RXBOdXhFU1JidW5DTnd3cnlVTGxKZllqTDFCQXBiSWVEdWF2SHpJVnNC?=
 =?utf-8?B?dWt3M2oxeGluRkhwOFE4a1FlTEZraUdlQ0dFUklmL29rbEpsbXovaG9IOFdu?=
 =?utf-8?B?dUxiNGw3YTFoSWltdUx3c01YaUJReUt6TmFoeEJwNWRic0k0WHdmYk9udDFN?=
 =?utf-8?B?ZEE3REtoNkhNNUF5ZXJnRjZ5NTBkQVAzNkFvb0YyWkpYSUxJckUwSUFWa1N4?=
 =?utf-8?B?R1F2cWZQQ0EyZXYveXAzSjZOcVlCek9tSThLV3d4SHkxSm9sbXBUQ0l4bUU1?=
 =?utf-8?B?NDg1WTNlSkxrL2dWV2pPdUNDTzJLU2dDVXRDM3YrSGZjVnNtVzdiM2xWV3ZI?=
 =?utf-8?Q?Wr6aR9AKRpfwaoX/1I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cb8896-6702-4c14-7458-08deb51fba92
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8803.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 20:55:01.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqJEmyQhqkh1pXPe83lqEN0wj4YfKg1ceLeG/HtJv3vfei0FWYWr870t2aI1QkgB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

Hi Tony,


On 5/15/26 14:39, Tony Luck wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> Sashiko noticed[1] a deadlock in the resctrl mount code.
> 
> rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
> superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
> the same thread before the call returns.  rdt_kill_sb() unconditionally
> attempts to acquire rdtgroup_mutex and deadlock occurs.
> 
> Move the call to kernfs_get_tree() outside of locks.
> 
> Add resctrl_unmount() helper to keep code consistent between the
> rdt_get_tree() failure path and a normal unmount.
> 
> If kernfs_get_tree() fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb()
> has already been called and no further cleanup is needed.
> 
> Add an extra hold in this error path on rdtgroup_default.kn to defend against
> other races destroying the root which is then dereferenced in kernfs_kill_sb()
> 
> Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

This should be

Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by:   Tony Luck <tony.luck@intel.com>
Signed-off-by:   Reinette Chatre <reinette.chatre@intel.com>

Thanks
Babu

> Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
> ---
>   fs/resctrl/rdtgroup.c | 82 +++++++++++++++++++++++++++++--------------
>   1 file changed, 55 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 97d1a3648b9e..282a0acedea8 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2978,10 +2978,34 @@ static void resctrl_fs_teardown(void)
>   	rdtgroup_destroy_root();
>   }
>   
> +static void resctrl_unmount(void)
> +{
> +	struct rdt_resource *r;
> +
> +	cpus_read_lock();
> +	mutex_lock(&rdtgroup_mutex);
> +
> +	rdt_disable_ctx();
> +
> +	/* Put everything back to default values. */
> +	for_each_alloc_capable_rdt_resource(r)
> +		resctrl_arch_reset_all_ctrls(r);
> +
> +	resctrl_fs_teardown();
> +	if (resctrl_arch_alloc_capable())
> +		resctrl_arch_disable_alloc();
> +	if (resctrl_arch_mon_capable())
> +		resctrl_arch_disable_mon();
> +	resctrl_mounted = false;
> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +}
> +
>   static int rdt_get_tree(struct fs_context *fc)
>   {
>   	struct rdt_fs_context *ctx = rdt_fc2context(fc);
>   	unsigned long flags = RFTYPE_CTRL_BASE;
> +	struct kernfs_node *rdt_root_kn;
>   	struct rdt_l3_mon_domain *dom;
>   	struct rdt_resource *r;
>   	int ret;
> @@ -3057,10 +3081,6 @@ static int rdt_get_tree(struct fs_context *fc)
>   	if (ret)
>   		goto out_mondata;
>   
> -	ret = kernfs_get_tree(fc);
> -	if (ret < 0)
> -		goto out_psl;
> -
>   	if (resctrl_arch_alloc_capable())
>   		resctrl_arch_enable_alloc();
>   	if (resctrl_arch_mon_capable())
> @@ -3076,10 +3096,37 @@ static int rdt_get_tree(struct fs_context *fc)
>   						   RESCTRL_PICK_ANY_CPU);
>   	}
>   
> -	goto out;
> +	/*
> +	 * Ensure root kn remains accessible after mutex is unlocked so that
> +	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
> +	 * failure path after creating a superblock but before taking reference
> +	 * on root kn.
> +	 */
> +	kernfs_get(rdtgroup_default.kn);
> +
> +	/*
> +	 * Make backup of the current root kn being created to be used in kernfs_put().
> +	 * The additional reference taken above will prevent the kn from being freed
> +	 * before kernfs_kill_sb() can run but rdtgroup_default.kn may be set to NULL
> +	 * via rdtgroup_destroy_root() and its backing root (rdt_root) could be overwritten
> +	 * before kernfs_put() can run.
> +	 */
> +	rdt_root_kn = rdtgroup_default.kn;
> +
> +	rdt_last_cmd_clear();
> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +
> +	ret = kernfs_get_tree(fc);
> +	/*
> +	 * resctrl can only be mounted once, new superblock only expected
> +	 * to be created once.
> +	 */
> +	if (!ctx->kfc.new_sb_created)
> +		resctrl_unmount();
> +	kernfs_put(rdt_root_kn);
> +	return ret;
>   
> -out_psl:
> -	rdt_pseudo_lock_release();
>   out_mondata:
>   	if (resctrl_arch_mon_capable())
>   		kernfs_remove(kn_mondata);
> @@ -3099,7 +3146,6 @@ static int rdt_get_tree(struct fs_context *fc)
>   out_root:
>   	rdtgroup_destroy_root();
>   out:
> -	rdt_last_cmd_clear();
>   	mutex_unlock(&rdtgroup_mutex);
>   	cpus_read_unlock();
>   	return ret;
> @@ -3186,26 +3232,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
>   
>   static void rdt_kill_sb(struct super_block *sb)
>   {
> -	struct rdt_resource *r;
> -
> -	cpus_read_lock();
> -	mutex_lock(&rdtgroup_mutex);
> -
> -	rdt_disable_ctx();
> -
> -	/* Put everything back to default values. */
> -	for_each_alloc_capable_rdt_resource(r)
> -		resctrl_arch_reset_all_ctrls(r);
> -
> -	resctrl_fs_teardown();
> -	if (resctrl_arch_alloc_capable())
> -		resctrl_arch_disable_alloc();
> -	if (resctrl_arch_mon_capable())
> -		resctrl_arch_disable_mon();
> -	resctrl_mounted = false;
> +	resctrl_unmount();
>   	kernfs_kill_sb(sb);
> -	mutex_unlock(&rdtgroup_mutex);
> -	cpus_read_unlock();
>   }
>   
>   static struct file_system_type rdt_fs_type = {

