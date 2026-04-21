Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021107.outbound.protection.outlook.com [52.101.52.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB047367F45
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776796399; cv=fail; b=e9JYot5aaLJ3vO9I4kKZedCUVqgHDO2kJlU5X5CzI4MgHhPNj+fvSObCX9YoHrQXnjGszzKrfi8gr+zC50Yj3etP2OvEE7M0kWGqx3SKhrxxX+vzfNysxBBfgsUmw+0h806kS33tLXFQXDdJDPqhyrVPqMZ1RkR0i5TbV+PE3IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776796399; c=relaxed/simple;
	bh=6GRocwXn4B5iB2VhqArTJgpANXy5uOXVoPWFsJOneB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BweRnwj56Y0avucFquRY6xF+/5qkYFz7srqdAO5OdHyZg+1eUk6fqE8LAwMPznnghfWjPIq3GWvSXAiTI/eDwCEhlPlSAkCaBeGX0rA1qZqu+TZAnfaG7kccXb6R6PyP0NSvgtwGqTPB2NQdPOWESOqfg8cqY27+2KW91kbLw20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=Fiyyp/gU; arc=fail smtp.client-ip=52.101.52.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="Fiyyp/gU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wb0GaVkEq0RDfwZhClrYdxNc162hmG2Alcf5Pk3u98epXYWPpnUuitGREcUET+J4McDUsfkzWmKtJMe16TLYwyFbzQfkmZlEWl3F7c7hMCWH+wi/FL0Ch7kgnfj2SRbcrPuGYxNMvoW4RTJIb3RJecXhISz0AnjrAKrustriYqLU8B18+N0HjH5UNVLkjnQOuPL9AtptS7AYXcWY2RR222V9vlQqs0iBmFlayx7Mp8+Rwpue0OltSFNUOgXwCRkNopnDKzscKuTWRr4uHH+J/UUUr4l5+7mZYSkKczedRVO3NTkLl1fKl16OCJuVwshmCyfNxb2n8FKyozsCqhC+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjtY3Tt2Xe8zlqbu4RkIKDZznpMRQuzPHu1nQP6ObzI=;
 b=AAbBD2A7RnEuvZ8GKZDR4Eh68q2/XypChh4ce4RewN93NHq5N6LP8tVr2/u0vyGZKwL0I3rrvxxzHVDhT7QhT7UB8eQbQA5APi3IIFEDVzq6r09RDMM5opQQ02dh+7jinTWbL46htLukx6H0Ye570km8XATSwnh5+5Pbypm8sO8HPATlcq1j8qg8tQTBFaNgo2U3KpXpbHrMGVbPsxBRsKILiU6WaueHzYFJEUTJP5a+kDBCzoOfOVwBGyd1gOgCxgqYA/CyOUDuCsegqyVhNpucpOde7E5WBnGkR30PahwpRMuzxAa5n4losfymeV4bP1NmTXNX4ndm24hukM4g5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjtY3Tt2Xe8zlqbu4RkIKDZznpMRQuzPHu1nQP6ObzI=;
 b=Fiyyp/gUCPsgP7EXAVZTFQQiITFx+NQBvV3IMHIH/E2co/vcYrXaAtMblKhiknXYxjxSRpOZ3oxVx+p6GUa1C6VrU9pwZ4DwwHsjyb0094dVWfwr2l2V0+Lx20PNU1Yo01poWS1zA2+/o7WunkR4910ZvoYuj9V2ZQbJwd0bHdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SN7PR01MB7903.prod.exchangelabs.com (2603:10b6:806:34f::17) by
 SJ2PR01MB8297.prod.exchangelabs.com (2603:10b6:a03:53d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.33; Tue, 21 Apr 2026 18:33:00 +0000
Received: from SN7PR01MB7903.prod.exchangelabs.com
 ([fe80::7ab6:8a9d:e17:bd3b]) by SN7PR01MB7903.prod.exchangelabs.com
 ([fe80::7ab6:8a9d:e17:bd3b%6]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 18:32:59 +0000
Date: Tue, 21 Apr 2026 11:32:56 -0700
From: Zaid Alali <zaidal@os.amperecomputing.com>
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Herman Li <herman.li@intel.com>, "Lai, Yi1" <yi1.lai@intel.com>,
	Jiaqi Yan <jiaqiyan@google.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 2/2] ACPI: APEI: EINJ: Fix EINJV2 memory error
 injection
Message-ID: <aefC2OXElPoiwRWw@zaid>
References: <20260421150216.11666-1-tony.luck@intel.com>
 <20260421150216.11666-3-tony.luck@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421150216.11666-3-tony.luck@intel.com>
X-ClientProxiedBy: MW4PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:303:16d::28) To SN7PR01MB7903.prod.exchangelabs.com
 (2603:10b6:806:34f::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR01MB7903:EE_|SJ2PR01MB8297:EE_
X-MS-Office365-Filtering-Correlation-Id: d2439a04-bf34-48da-f886-08de9fd46a34
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	490QYCdPUnx/bJs0sbXvIAl3NkMJBc7KGkt4jkkaCORLQVzw1ol3KlHAhyCiW4H5t08OJKkZnr3oJPLeenXC+eb66qNe4uIP7NHVbKxFSD9Ymd9zWR/bxmmJuBiADH/PSBJCQQk0A+W0ExUpNZfnUPfpiux6dnCHWq3DANzpv0rYu0+MgUC/66kt+GRSQvmApkYzceheV3CO5tNhCnXtv5/ZlcQFIlenJ+ZRjnk8oY+hEiCwjmrqHdro9c4n9nIxMwxgEb/EGNZX5Ezfc5jEY3N9ZYpyNInIQfQbszCKoYCc5q7VHvEsvlW5HArXKEmPXyZeXw9ejEbOorz9QHPc3Xt8ZkFETE2Vr2IB/kqWTyQlVpfLWyFL3+YrhrldgRIqTS218czeJ27avadaFtCAYUc2NR9ToAOXdIOOizcqNun6BbwGKA1fGwQ/nf9TyRr8uPlBFSWs5ZyHnotnT65TFsFdgppwm3zpiJlHKPCwL6eJc1v8e/ppACid6sz2E/TEhexWvGqtACCCP/fpXOe740bEnB3+mgfiCOFLGC1yGvbPM2dxzmpFVQ4Nvc7kZPAmQQcF61S+7QPQttgS5IP7QQ72+k9V7xxiFfIDvwXtGHYAh2VsG+5RRDutDTKlnOQ4QFR0Z26SCrOCVc2U72F1SQL57OP0xB7DUvjviCTRWIOST/7SOp4WJ1gsJ6sIjQlr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR01MB7903.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qbHjOxTCb0myib8YHAik0COP05s0UZmMHjthsK70PHsKXsF9nAXQvpP0xGwx?=
 =?us-ascii?Q?+2c7FV4mrHp2Z9SM235riesuopPOVm8OdXMI6GeORJVEYkojzvyONkG4UYVT?=
 =?us-ascii?Q?wVoQR/kYfgfwS4LuxU87MdC+UGAI5sfGN1X2t5QdD2QmJ8yv0TSb340iytFU?=
 =?us-ascii?Q?4nVxboGSL2f1u1vYJh8Zc/PopdXTZms3iKt7EmbHcRc4FR2pHQ9lZ1d8JgmZ?=
 =?us-ascii?Q?dpIWRlhpdI14bQjYcbgXfG8fEN0QpZFiCLyon/Ge1xSBIUcqjQprmlUsCf6P?=
 =?us-ascii?Q?7FapCsDlcVCa5ho67+TowD26Aq1frugQXCBggMqJQFcztxJHv+Cwl/PE6TbP?=
 =?us-ascii?Q?FIB55suO3eohT9eImYV7kvYgiuATzf2gpqXdLlUYj9FJRbsSQk0D/GQ/yDYo?=
 =?us-ascii?Q?006O9180p7zxpTTQkhXIBEgy8+uQaF8WFXnaA9w2HnpiLEbQh6gxszzbiaiw?=
 =?us-ascii?Q?2kOwyW83MwbNRiacYVuhZ3CAXxDD3LvxmYzs5CyVk3ffFTChXzLrl944N1jU?=
 =?us-ascii?Q?mbM9UGUkkArDfKC1DHXIobxTmZN75iQ2bGUPdLJTuEDmPGdVqt8sT74oBrZ/?=
 =?us-ascii?Q?//mcNe/lrva/YJMFWUt4mhOjx3GPnYx7eIkqqq/ZV+L4lQWx6RIZC9JtCigG?=
 =?us-ascii?Q?1doQopRAe0Vdg6hBexqBEx3frW1Kojhvbh6pKHIvopw2U9Zp9o3otsOFxK07?=
 =?us-ascii?Q?saoG6Ni6aB39wE+GP/H8Eb7QzP2nv5yFzvU7gwzGsqGTnxH5VMZqVD14c9hG?=
 =?us-ascii?Q?bTKuXvWuBnmX9eOADML3Xbne9Tl/evs8JGGfjK/6cULUdw4v1+8HQelKY8UG?=
 =?us-ascii?Q?Mq4hdYCakfoeSXqHfVqHi/hv3Qt6FPH16ONKsvUNxvGFfOAHfeZhX3sDo06M?=
 =?us-ascii?Q?vnof5rpFUJeC3w5xtNTFzjxLh5aReCSy6rvYBQv2cmCiLnSUylqv2qK6DJoa?=
 =?us-ascii?Q?RmvMda1yPE5Q8lgJ8/nBi5F6gOviKLLQ63HVtnLVYXYBV4JBR4mF0o9h9aem?=
 =?us-ascii?Q?lb/c3e0XaNC0kv5yUTleQzdFdkscS6FEVFkUaRMr2531fDk0nfHTM9OCTrhV?=
 =?us-ascii?Q?mE1V8s44crH38V5mXHDX5QUvh8DSHo2KrFeNhMiDFjJUSdKi6u2fxcwZcexb?=
 =?us-ascii?Q?i8cWsWDeaNsqzSnYmaCNcYW3pXDE3C78EcCTpe9oZMG82PTM7hNGf09pUV3j?=
 =?us-ascii?Q?Uw1MEdlFoSNuFPonBcDB+4nOq1MICw55XI/+M/Fz48h4zL7t8mroGwi+hZRW?=
 =?us-ascii?Q?ohoXyJLrHrzd4UrPYf1lhA+Lz4JrKYndp6o45F4syhteVwzRznKpAUz1lXkq?=
 =?us-ascii?Q?ZG9NoAmY4BIICHzmqx7Vrmh3WXLI1Ymx6VIyfTFB9wHDyDV7rqIGCDMY46/2?=
 =?us-ascii?Q?/Lsp3T38mj5/7/Y+lsphYSsdTBWQflk8sc9SPAQ/MBvLswqyekmWujISEXuX?=
 =?us-ascii?Q?O4uzAsX+PNP1NFAHdU4hHqqH5vbPW2+wHslXNbhhMWUI8JyHD8JLTJc5fZpF?=
 =?us-ascii?Q?o9KF+JMoZpClzk1spi77ys7UIveTvgCLLhMgdV2X/hH60Ie51fpTai/va1JC?=
 =?us-ascii?Q?n+0C3JIJsz7R3+ygYSf9u1WVYn0YeAx0x32XITnapJ/dC9W24E4P4vjfueWV?=
 =?us-ascii?Q?g5sMSjoA8p1hyFIQV7s5t5zTnfYYVLMSKQvLbAEkG06iNAlQ59J8tJnHHqrp?=
 =?us-ascii?Q?osJ8BPokD/6Y+o7vkLdgJwZZbvEINkbaPUcfd7qRBAUoMxcJoRPvjV6RAHAq?=
 =?us-ascii?Q?cJV5b9KyjMFQUKf6sANOkwCSXjAMaV6/5lAXQGBBO0peRAP+XhMA?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2439a04-bf34-48da-f886-08de9fd46a34
X-MS-Exchange-CrossTenant-AuthSource: SN7PR01MB7903.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 18:32:59.8931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Q+93EtJqAqcf16DnBTsd9I7sYoUBuKt1IQtkJTMrCnm8OxSZdCxoVco8Pg/NaxTtSf810ktmR06aJ+/sOcJQ7kppef5VpUFYBkacej14xR0DC3pXnr/h4gqKmbpHQsA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8297

On Tue, Apr 21, 2026 at 08:02:16AM -0700, Tony Luck wrote:
> Error types in EINJV2 use different bit positions for each flavor of
> injection from legacy EINJ.
> 
> Two issues:
> 
> 1) The address sanity checks in einj_error_inject() were skipped for EINJV2
>    injections. Noted by sashiko[1]
> 2) __einj_error_trigger() failed to drop the entry of the target
>    physical address from the list of resources that need to be
>    requested.
> 
> Add a helper function that checks if an injection is to memory and use it
> to solve each of these issues.
> 
> Note that the old test in __einj_error_trigger() checked that param2 was
> not zero. This isn't needed because the sanity checks in einj_error_inject()
> reject memory injections with param2 == 0.
> 
> Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
> #Reported-by: sashiko <sashiko@sashiko.dev>
> Reported-by: Herman Li <herman.li@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Tested-by: "Lai, Yi1" <yi1.lai@intel.com>
> Link: https://sashiko.dev/#/patchset/20260415163620.12957-1-tony.luck%40intel.com # [1]
> ---
>  drivers/acpi/apei/einj-core.c | 45 +++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.c
> index a9248af078f6..1f3fa2278584 100644
> --- a/drivers/acpi/apei/einj-core.c
> +++ b/drivers/acpi/apei/einj-core.c
> @@ -401,8 +401,18 @@ static struct acpi_generic_address *einj_get_trigger_parameter_region(
>  
>  	return NULL;
>  }
> +
> +static bool is_memory_injection(u32 type, u32 flags)
> +{
> +	if (flags & SETWA_FLAGS_EINJV2)
> +		return !!(type & ACPI_EINJV2_MEMORY);
> +	if (type & ACPI5_VENDOR_BIT)
> +		return !!(vendor_flags & SETWA_FLAGS_MEM);
> +	return !!(type & MEM_ERROR_MASK) || !!(flags & SETWA_FLAGS_MEM);
> +}
> +
>  /* Execute instructions in trigger error action table */
> -static int __einj_error_trigger(u64 trigger_paddr, u32 type,
> +static int __einj_error_trigger(u64 trigger_paddr, u32 type, u32 flags,
>  				u64 param1, u64 param2)
>  {
>  	struct acpi_einj_trigger trigger_tab;
> @@ -480,7 +490,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
>  	 * This will cause resource conflict with regular memory.  So
>  	 * remove it from trigger table resources.
>  	 */
> -	if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && param2) {
> +	if ((param_extension || acpi5) && is_memory_injection(type, flags)) {
>  		struct apei_resources addr_resources;
>  
>  		apei_resources_init(&addr_resources);
> @@ -660,7 +670,7 @@ static int __einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
>  		return rc;
>  	trigger_paddr = apei_exec_ctx_get_output(&ctx);
>  	if (notrigger == 0) {
> -		rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
> +		rc = __einj_error_trigger(trigger_paddr, type, flags, param1, param2);
>  		if (rc)
>  			return rc;
>  	}
> @@ -718,35 +728,30 @@ int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2, u64 param3,
>  		      SETWA_FLAGS_PCIE_SBDF | SETWA_FLAGS_EINJV2)))
>  		return -EINVAL;
>  
> +	/*
> +	 * Injections targeting a CXL 1.0/1.1 port have to be injected
> +	 * via the einj_cxl_rch_error_inject() path as that does the proper
> +	 * validation of the given RCRB base (MMIO) address.
> +	 */
> +	if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
> +		return -EINVAL;
> +
>  	/* check if type is a valid EINJv2 error type */
>  	if (is_v2) {
>  		if (!(type & available_error_type_v2))
>  			return -EINVAL;
>  	}
> -	/*
> -	 * We need extra sanity checks for memory errors.
> -	 * Other types leap directly to injection.
> -	 */
>  
>  	/* ensure param1/param2 existed */
>  	if (!(param_extension || acpi5))
>  		goto inject;
>  
> -	/* ensure injection is memory related */
> -	if (type & ACPI5_VENDOR_BIT) {
> -		if (vendor_flags != SETWA_FLAGS_MEM)
> -			goto inject;
> -	} else if (!(type & MEM_ERROR_MASK) && !(flags & SETWA_FLAGS_MEM)) {
> -		goto inject;
> -	}
> -
>  	/*
> -	 * Injections targeting a CXL 1.0/1.1 port have to be injected
> -	 * via the einj_cxl_rch_error_inject() path as that does the proper
> -	 * validation of the given RCRB base (MMIO) address.
> +	 * We need extra sanity checks for memory errors.
> +	 * Other types leap directly to injection.
>  	 */
> -	if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
> -		return -EINVAL;
> +	if (!is_memory_injection(type, flags))
> +		goto inject;
>  
>  	/*
>  	 * Disallow crazy address masks that give BIOS leeway to pick
> -- 
> 2.53.0
> 

Reviewed-by:Zaid Alali <zaidal@os.amperecomputing.com>
