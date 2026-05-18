Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010025.outbound.protection.outlook.com [52.101.61.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B873F58FE
	for <patches@lists.linux.dev>; Mon, 18 May 2026 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779121586; cv=fail; b=jS1uEjEBUv/5Co+y8EX6dfe0JlU2ZJE3gAZuz6lZSoQAw7Ux4I3yjkwd11lZg/uV/SQ9jAZ9Qzx5s3HeogkbP5qug9Rfau1+/11zArAR7frkIROVuvGwFvhJJYiPX2g2ptrSI6EWFz8/w6v0T4KjA7bc9itF17BUwgz8SxjcoMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779121586; c=relaxed/simple;
	bh=3gK/930ruPbb3UiigjTTzcCm6Fln5B0DPsX+QqxP5/A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IGuQUvsRGgIhQ9K3TCrnFmttkC8qank0WO211nK1ZA5RN06hy9gXj5/Lnl4tiGd0FihP9FD5P9QNExPhElPYebDjqRw6PJ3RwrYN1uNfanpQDA4muV6Z1eN/uRwrXtCMhuRToWLefErx/P7RQXFP6fafHO3SR4InJjGk3LiNpCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qe35eD75; arc=fail smtp.client-ip=52.101.61.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qe35eD75"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lFqFEpx7ke+TwkWjQp8yMpvXIJzgJbfAkuEmK4NzLgvVH56MctQc6O0Dt5eoF9/WltnhG9jD2TOqiDEEofazctbO0y1Jm14ePhWtoBjpwdxTjkmX49LfYGaJUPkJ3yiwwhtbk6wLZdRQyYfv3efSTqic0P65b6+eWoprz5yfnYhH0m9X7JA4oLnm4RiBJYF295bAtEgLW1OReDJv6oT0o2EdmOIpW7dlA5D0N5V/cxeRq7oASz1+/8wCfKFn89j/Y9TXv/irDjzqD2sZEA5TiD1KVBI33Xw+N93OlTugmbs3GcouXzmrKij1Xlxb0txh04PoPGPwFdt0w780A6qiqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8T1dDuUcChi0ylmqBpr3njrTTfftUMdeBW5SeTY+xug=;
 b=cPM0rHu8wb1cPbONfSXKiLG88CJU4pEUJVFbdIVTKvso7fVh2JonB79Ctl6UpQzmAm5H73cCXImJ7a2RM4pw6tW0/MNcdmgw7U3YxpgvmeHhTVfeK5eumk2k41HozHNOzswOWm4tu0HQ+ECb2+Ck2NBNJbhqsdAooyEuHXtvWPqy81CxK2MNFs/VXRIDNUULtWIUQLalgE1wxs++u0kog871t3LJvQ1iwDYA741JYKkdMNErYH+txPEun52qUAUagdpBCy9aRlEbTEr0Au1Le2G9eIOU176rwgOe8FvgIhIDn/4wRYRpw2982c/plsshwQIVSfJfTcGyTIW+9R88kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8T1dDuUcChi0ylmqBpr3njrTTfftUMdeBW5SeTY+xug=;
 b=qe35eD75eZP44uwy6xtRiguUy7shvOpHrjhfmtwpiTo2c+tR31SSVkP8Xl1szz/nYKNOK7UgHAEf5tQTQdo67rJQhom7KME6/xg0w3Y6r80MPFYsK6s02fc50zBaIUAkWQ/WdooJLvOmHgArX5qgJHlWyhqljz7df83Np3qOayA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8)
 by SJ2PR12MB8783.namprd12.prod.outlook.com (2603:10b6:a03:4d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Mon, 18 May
 2026 16:26:19 +0000
Received: from SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f]) by SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 16:26:19 +0000
Message-ID: <bdfd62d5-87b2-4a12-b223-63229b038fb2@amd.com>
Date: Mon, 18 May 2026 11:26:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Only check Intel systems for SNC
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Reinette Chatre <reinette.chatre@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260428232657.107381-1-tony.luck@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <20260428232657.107381-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0020.namprd14.prod.outlook.com
 (2603:10b6:610:60::30) To SA3PR12MB8803.namprd12.prod.outlook.com
 (2603:10b6:806:317::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8803:EE_|SJ2PR12MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: a781dedc-a35f-4c0b-9523-08deb4fa30cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|11063799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lUHOyXvC+MEvTQO87i4AZlOVg98WJKH6x5G4+eXsPI5GwtPFKAgTqhiX5cQu8CeMMPiyfa334y1ADQXA6XM3aoyMQxsLpwYh4sZ/XJWJZTbp1/50GAPZqErGsH7tcnY7A3SzJGFZ+IH7VA3Lim01YxhNP0yuoulscUCERaaq+zDZKhpEN+tFrf9DBbNLsEq52nBVLQ6EV8nxPGkAUSL7G1U6QPd0nm8AiIuUkH2bBJlFxcI/3aPs6qHJ/hx1bFC9Cugl229tnRT1VTYIj4YApEqQJstxEslXkr0bE/wD5BYuhva0II5b1/62jM4Lt/wkyAQ6VCDcohaX6d1l+y7jUMWJQ3jr7/Nky9oIPRa/rTqR2Hr56AYe24paIFjCBZXyUXGDcDVrXfN2kEyKrFLgVL4sRn7HZCRkx8NYZrGumA6lkogTCncyHQ5v9IwicUGjyJLg1XcIYB4Obgp4MWeaTpZzzEEaIZ/PPkbAF0mFI/whQS/kC/gO6hb6fymNVQJrdI1YUCSr9G2/EKct/zKrIgp5Iq41PXixdK1KdN017aEfrV0qLxMF9/RMt/XkUVCgmgW4tO9Qr+ruerC2KjoGVE7HRGdnFco8l2C5jdbUiUX5IBAwFIwcX3sUHdQpZfXZcqWQK8ut6sv4qNpalB3jwkLdgph24wh7BiY6POXnoBqkcjOREWf4Nzyq64Uo9YEv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8803.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(11063799003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFh6RFZXMlVtc0xKTXFKRmZMVkM0d2Z5Y1RTK0plWTJ2b2JyTmhPRGoyeFBj?=
 =?utf-8?B?eGVQRjR6SHF5aVcvMkgxSWUrVmJpbUFucTAyVnNyTXNBd3RVaENxN0tHMjBN?=
 =?utf-8?B?YkVYMldHaTFjS1JPcXBqSUJBTUwwTXpMckY2alFzTGJmYnloL3F5aWNrRisz?=
 =?utf-8?B?bnJCNDJ0dUFscTZVamNLODIxdGt1SVJFVm9vdmZ3RHl5QlpOTUkyVE5vdk4r?=
 =?utf-8?B?WGNjRjI3MUY3TlRoS2svcGNZRElrSFpKb3c2NjREdVk5a3lveW9Ya2lONEc1?=
 =?utf-8?B?dW02ckZQdEtyd04wdTdTa1d3T3JiNWk3YmxkQUg4MnRQQ2dUSzBtTW9nOVJ2?=
 =?utf-8?B?S3VGREMwcCtFT0VmMlV4M0pJSlFQTUtXcW9ONWVzb2lYREtOckZPMWpuV3FB?=
 =?utf-8?B?VUlmK3J5RkRocG1temszQTBVeFVtMU1SRlBGMHh2bDdJdlBOU2JCdE5mejNt?=
 =?utf-8?B?Vy81V1pYZnVzSzhQY1BiS0pkUFlnanZyNmZjaStHUStEOXRCNlNCZ1VqT1Mz?=
 =?utf-8?B?WWY3Nk55Q3o4dmFUVktUV3dscXJ5RnZxL1d5NXZyLys4VE51WENIYmhjRTAv?=
 =?utf-8?B?L3lPeDFoT3g4R2NYOVVZb216OVdYNFRhT3lJVHNRMlB0NG5nWFQ0dHNRN1M3?=
 =?utf-8?B?NXVNK1JMOG96K2QvVlhJb3VqQTlPQkhQV3JkNWJ3cUMxZGlvS1Z4UUpzZ2JU?=
 =?utf-8?B?Y3hvMUJCQVcvTVhiTnkrVTlPc3pJTUxTS2ZBU2xZczhWOXRGZzB3Z0RUMmtl?=
 =?utf-8?B?NzJUMktJNHpWcUxqNE1aa0NSamdaWFNDMEtsSXFjRjJlWERYZ29VRUNPaW8r?=
 =?utf-8?B?MGxyWFBmRC94S0ZxNERDT3NBeU5rOUdtTmdPbCtHNWdiQWxRcjJjVWdJTXVm?=
 =?utf-8?B?bmI5c2J6ellZNWtMTXcvWUl0d2g4VGNiYmJyOUZMYVRUWVR2Zmo2UnNkWDAx?=
 =?utf-8?B?SHQwTFNqcWc3VERoWmtXdFNmUEl0Z0dyZzNRdEdEeS9VQ25iejN4ZUxYbnZN?=
 =?utf-8?B?MEVuNnY5YU5sZUZMUGMzdXQwOFFMQkUzYURVRW5rVFdSY3VlSGFqYTNXQ1pw?=
 =?utf-8?B?YmVhaXJyS3BiRktESmMxMjFaY0dITTM3WEdHYUI2a3RjSU9Sb2NzWkF5MCtH?=
 =?utf-8?B?SHpUQ0pRTE9mcTBaVHZjTGtSMThvUnVmYjN3YVBpbHZISEFydG5KcTdOZkJP?=
 =?utf-8?B?ZXBKTGNJNDNvaUFqbmljR3RBSlUrcUJaYmIzMExaQk40MjljMVcxdVlJbGsx?=
 =?utf-8?B?Q1NiYmpScTdtZVNGUldVWEFNM25FU2szakRDakRTa2tKb3A5VW5lYk1kTlBI?=
 =?utf-8?B?S2xMcXFGRXZWZFFxR1EzWU1uNUFabXNQUDB1OTZqOVBheEZDSmwwK1ptYlNJ?=
 =?utf-8?B?dm9Da2hUWkwvS2x0QkVsdEU3VGd2ZHB2UitNU1FNV1BiWWlzRFlZVUovNkJX?=
 =?utf-8?B?RXNqYTdkVHlkaG5KSFJaelFMSnVSdUszZ0h0S1dBVVFQR01aMjlsL2tCS3BZ?=
 =?utf-8?B?ZXlUYzlkTEdXNGtJaE9ZWjF2TkJRbFBTRnpIRGlmeHBEQ01seHpTZkVvTXVk?=
 =?utf-8?B?cUVDQ1RSUjBSZThqZUcrcno2TEFMTHZmTFZJSmg4ZXNXZENicGZOaDlCbzVa?=
 =?utf-8?B?bmlPVmNjQmh3Nktpa3FvdVFKbmswYUlqVE5Gb1Boekk5amNLdHJRelJSanFB?=
 =?utf-8?B?QjF4VjJ2YUdBWE5nWUNUaC9sY1BiMENtSTVhRkJtbk80R2QzazJTYXlZZkp4?=
 =?utf-8?B?eDR0d0Z4V2N6ZkROUG9Wb2ZlV0c2TTBpcUNKRDFDbmNCUHNKZG1xM3RzcVVN?=
 =?utf-8?B?ZTgyL21kejVtTzhLNzFZeUQwQmk2c0ZoVE85b2ZTbDcvdi9kT0JrU0lyNGtw?=
 =?utf-8?B?MlFJcTNhREhINXpYbGo0b05za0taTlBTOTAvZmpXMnZFVTM5cGZNZG5oeUFG?=
 =?utf-8?B?RlFHYklzazhyYWhDMWRUMHhzUTNFeHgrS0VOMnhOMTZzdTByWmhORE5HSUVU?=
 =?utf-8?B?K20vMEFQSHhWN1RUTEJWeTA3U0pkUGFyWWtNV3hiYzUvTVBkZkd5Rkp1K01W?=
 =?utf-8?B?R0ZLcUJUOXhLMk5CM3U4a2h4aWZ3SFBrNDRLYW0xVjdnVFVyVFFLQmxQVmsv?=
 =?utf-8?B?TXZRd3M2OWZyMndFc2p3WUxzWWhWSU0xM29nNmE4Njk1MEE1ajRjZk5iemJp?=
 =?utf-8?B?bkk3b0JaWUsrYWY3SnRMeEMxbVJzV3Yrc21oQXIrZnRRTTgzMVdHQk10ak56?=
 =?utf-8?B?VUluYjlkbngyNytLaVFJYWVyeDMyQVFsMEpiWVd1TmVnQTRvbjNscVhSTkdD?=
 =?utf-8?Q?6k05Tm7SFHVJ2sEaUb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a781dedc-a35f-4c0b-9523-08deb4fa30cd
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8803.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 16:26:19.0979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1X8qhglXA+3p50taalXMpOKevHAOl8P8I4MaKFxmnI3qUDTYmnKIkRrgE65zi0b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8783

+ Reinette:

On 4/28/26 18:26, Tony Luck wrote:
> topology_num_nodes_per_package() reports values greater than one on
> certain AMD systems resulting in snc_get_config() printing the confusing
> message "CoD enabled system? Resctrl not supported".
> 
> Add a check for Intel systems before looking at topology.
> 
> Fixes: 59674fc9d0bf ("x86/resctrl: Fix SNC detection")
> Reported-by: Babu Moger Babu <babu.moger@amd.com>

Should be:

Reported-by: Babu Moger <babu.moger@amd.com>

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Babu Moger Babu <babu.moger@amd.com>

Should be:

Tested-by: Babu Moger <babu.moger@amd.com>

> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 9bd87bae4983..59215fef3924 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -377,7 +377,12 @@ static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
>   
>   static __init int snc_get_config(void)
>   {
> -	int ret = topology_num_nodes_per_package();
> +	int ret;
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +		return 1;
> +
> +	ret = topology_num_nodes_per_package();
>   
>   	if (ret > 1 && !x86_match_cpu(snc_cpu_ids)) {
>   		pr_warn("CoD enabled system? Resctrl not supported\n");

