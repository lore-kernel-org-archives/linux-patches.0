Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDCC3845BE
	for <patches@lists.linux.dev>; Mon, 18 May 2026 20:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137671; cv=fail; b=sfLiiSqiY8Nb/VyJd5uXcRtbwzEK4F4dedT+AyNhEVlLxovuPYOGp5jpNDrNfljIC1l6c3UgsINkQszaJSrDPWHx1OgDhemKUs7NeEha38ba7DpkmJwI7rTi1FlsQ5rFdH7EpSmINbU+4lZ9+txjc+0+nT+03nvNcPLgkZEJoRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137671; c=relaxed/simple;
	bh=sWlUH9plfWSbkUdB/hgPbANbLpZpfJeeHfzee7ZYVVA=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rblWvJbRojUtsHxxxmBDRPyrcx2O7bkMqqFIzNmW+0DMk8TstwPTq6lgBn9YiBgvX6AhhdPfee5ANewsGZXepTA0yQmgsFCIfRknpGuw47978HgeKyW4i2SjdrRQcTf0i1MyACE2d0OCMmWhSZK9ErU3/D6CWwuRnBRc61KiBks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AwLK3d+s; arc=fail smtp.client-ip=52.101.53.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AwLK3d+s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avUhvuHK28Q/V/404YhjoDiTstSOK55dqkPdL/72NRXOMGspdHYbRfWd1w5QYV7NcgVKaC4NjSB8tsolMxZG3QIuAwMn2t+9xGxDfnOFSOQTZpUM15krcX0wnaeS18T2fgU/QQ/AcEDGzcr+kDgYLBsNbpMjUJYdMypqpppNJH2gdN4/44x32wV98pwekcZVeQVc3x6KjEf7n3kK8893mbUctrbyEzK8e1RcQITiGWcxmT78Usq29H0/8ADL9bclJvIwkB4tCAHE7NQLWNXG3xOabk3GILIbnAsP7ePXOc8wyx7Nld/Mqt89m7DUVDozQyswx9RBRiXYUEJcL9f3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRtwszKkrDiAp+pBad12KgkgphZfnCMaKbNSUpz5gog=;
 b=VrfieAhuIC9O6dPvnmwnsV0kNfijxiPDsW5nJcagmzudEnLp1S4/OBBkZsTdDJ4eWRcWLzpPO19TnduHPdOiUp6wHo8oIor3aDYZzJKA9qJJiDINW3BG/sgfopubmNODk8Hnfu2TSjk5sUoLszHZDg91ACYsZUrg9aKy0B8gT2suagEuRRky9/eTxY//kWtpYA81jDCVC3KioUQHl4qEUiMGMxj3ELL1fWWN4JKJqY6wbT3hRkzZHyVHbPX097cG6HuiXECIxBRLVN4/hzZ/aPgD/a69o5dOgp6Ae2p/ZiLdTzrw1MiLO2KcEsEBMCq5uKQ9H+liEgN1hsC092BQmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRtwszKkrDiAp+pBad12KgkgphZfnCMaKbNSUpz5gog=;
 b=AwLK3d+sewThxHCMwOrxEGiEBvHSLQjT6EOrDrfbfFUfLyEqiGhIAc9oPxedY9JrukTf8EfYy9CTQ1Yy4MSAFHVErsBoQ81bSNCbPSJidfs0SGRibA7dCrt/wGgSrZEIgmAl03e0d/N5JSM6Qs708F36y8sF0ynbgc/MQ4a+BLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 20:54:24 +0000
Received: from SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f]) by SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 20:54:24 +0000
Message-ID: <90b6066c-3baa-4916-9718-eb88cf1c0a7f@amd.com>
Date: Mon, 18 May 2026 15:54:21 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v2 2/5] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-3-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260515193944.15114-3-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:610:cc::27) To SA3PR12MB8803.namprd12.prod.outlook.com
 (2603:10b6:806:317::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8803:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b2a95a-f920-4ff1-7b61-08deb51fa462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|4143699003|11063799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ytNJiGVZThdMju4jX25HfZP4pVaykmpk4hYw3jjQuSRLnN182BcO/HDG7Ti+gI8FxI0GKIgEycf7YTQON6Cx5CqlHy4+IqhplzhEF7m4vIztTujvTS3tOPPmOoNcbXICsERY54Q8troYmfdnj6F/xRDn8MhgRQbwQ6tJaqXrkqdXFsP2j2RymwOlmQEFO5v90U2i3Wpf8/v2X66RPlMH3cBFGsF3JCiTwbYGjcGypOEusKQD8ZlpbDUyefqqeOG4u8RaFYHEJI3y7on6yyJKb6NYfPIhEJvWg3BtP8fohM6H8Vo9wGZOSBmQqQQw7rtuAnRXZwnaIQ4qdCQh6EqBA/RZjnm4mjWzmKPNLWS+Vg/8cO/2OCze0vRIoX8nGC1850NXN7DuXfYjEeowRDYEGkmne41VfQYWyJdYLz6t1FkY3NfixPpiPJ58KGCWchWe0SQHg/Y0YcN+yoKSsV/z378ny6130BdqyjDsTQv+apytcBrlo4j+RzF6+aSxS0ow9+aPpfnlE8MmZauCSOkJAalpKAlG9UjJqwNnoLUPjbyJVld5Nh4FTsFN6N3Erd68UdMbFk+qSZ189fXX1jI/CAogpkKBvnqShn8de0UAWw3r7jPVr1mRnSfiL1eGObS08CErlAwQUXKXuXjflqn2cxATnOwZ+F950UWdk5VTr2g7yWOcnjEFp/p6//UxE/io
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8803.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(4143699003)(11063799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mnh2b1NhVjUzWXRsTzQ3cGNFTkxNam80UjltdGhJTmlDbXFURXRFcGdSa3Jp?=
 =?utf-8?B?bGJVUkttZGMyRm5Ld3RpeVQvbm14S3JtOGpJQzBiLzdkclVjYTgyUmRGUWRS?=
 =?utf-8?B?UFBJbkphR1ovRGpXMUk1bWtQS05RQnZlQnBBeUlKMVp4VHNYWHRINnZJb2JM?=
 =?utf-8?B?eWxFa1dTNWZiZkNHVmVybXIxRzljOXJUei9pbWxnSXpNVXFEb3dBRHFCTzRB?=
 =?utf-8?B?OWtDcFhvMHFGWWdnSC9kc2ZSQURhcnh3SXhxQVlhS1FZSlJMdzkySkpOYy9D?=
 =?utf-8?B?T3VIcTJkeGs2L0VhR0xIOTQyL012UFBlc0UrM09jL1lBZXJBNWhjd3ZPazlt?=
 =?utf-8?B?Wm8vT3FBR2FOSWlySjFRWm9RU09jK2RhN2lPT0tlekVNVjAxRko1clF3RFdj?=
 =?utf-8?B?R3BiQVFVRGlEVVJ2eEJUdnE0T0NMenZBUVk2YW93YjBGZi91V0JGRDM2VE5h?=
 =?utf-8?B?MnRzekNaZWU3cXBWQW0yeDhXa25jWERkS0RoSm0vL2ZZRnhYR2ZjRHRjaDIy?=
 =?utf-8?B?RjE1YjgwQ2ltZi93dGplZWd4VGhuNzU3dnpzM1oxWXd3c0dmcGxOREI3Ulps?=
 =?utf-8?B?RGNUTk15YVUyaG1GdlRrS0xYYVcybHNHYTcrSjcvYTlHOTZ4dWhpb1BpWUZY?=
 =?utf-8?B?S0RPczZTRWJKeHhwSDZRc1kyTm1BVmpyN1R1VWl2K1hBZEFBOUtCbnduZ0Ix?=
 =?utf-8?B?cXp0ckVIcjI2SkRCTXFOZXozL1dlTDFDOEczcGRQbUFXRzZmQlFSd0oyN1hP?=
 =?utf-8?B?MlhndEhYQWM4R3J4Mzc5RGJIS2JQNHZESnJjZnNXZUVsY21Wbm5ZeXA1bzhX?=
 =?utf-8?B?cFJJVHU1MWtEcWdSajMyUG44ZUlUNVJPUkZRc2JZTmIyUXVxanpsLzZDc2FF?=
 =?utf-8?B?YVNzRC8yQmVaSmJJNXdEY0dBaG5aK2Q0R0l5cHNmQ3FrTnZOTlcvQ05odkVG?=
 =?utf-8?B?cC9NN2pBa0g0WmdwbWtyeC9LaHUyUHNLSlhhK0F0R051OTBONDlZemZOTzZo?=
 =?utf-8?B?amRPUEltZjV1Vk9NRHQzZzJPT2J3eEVmVGZBbGNsaENkR3JxdUxmOTJMNndD?=
 =?utf-8?B?aTNYTFljWFROb1FxQTdkc3RyOWRtajY2a1hFblU4Sll1dSs3MHFKL3dNcCt3?=
 =?utf-8?B?TVZ0dlJMTkQ0ME5scWl1SEYvYm1lWVZDV0svaUovODRVUEs4SzQ3OTFkTWJp?=
 =?utf-8?B?NEh6OUhrWnlpYVA4UDRhUTlLUS9wTG1LdnVDT2MrM2kxRjArelhGOFYzSEpk?=
 =?utf-8?B?MnBVWGRCYklRUDd4c0lKRjdhUC94VXZqRjlMTlBSTWJkd0ZjUDB6Tzl5SEl6?=
 =?utf-8?B?c3VxZXBJLytSL1JBOVFYVmp1WkVnVVZSc3NxL0g2TFBSdmNDVGpMWkRzaDUz?=
 =?utf-8?B?MEE3Umw5WUxTSWJNR0RFUkxOK3kzY3ozWHR1bkEzQ3hWV0NHcGRVYktCeHVU?=
 =?utf-8?B?RzdEQnBjaFNUZTV4TTRsc3JCVExMR3BPS1JzTFNJcHZnUkdLaCtGNm04eFkr?=
 =?utf-8?B?QTRPN1BlblBNZ2ZZVHV3MFF5MzJVQzdwNVIzOHBGTE9weFQrMlgvN095eWpV?=
 =?utf-8?B?QktwMFQ2YlB4c1psQWFBY2czeTF3bVllZjR3czBlK3MxSEF0c3dHalptMytv?=
 =?utf-8?B?SUJwampTNFlTd1EvbVMzTTJQRjM3T20vaklMQ2hOT2xXQ2RwZGNOQjBYZVlW?=
 =?utf-8?B?Z0hjVGptbWpwV2tkYlFuc095dkRobWRpdzVPOFhwOXhHamNvT21ZNEhhNXc4?=
 =?utf-8?B?eUtCNmFVVEltcy9Rd1BjZG9WaG94YjdRQm1TeFNlaWprL2V5MUY1YjQyVWZK?=
 =?utf-8?B?K29yUkgwb2tOd3FjTTR6aVpmclE2WGlSc1JPV3JLZ1hjVGdxWDY4MVp3ZUFU?=
 =?utf-8?B?UmJVOU5ML3Y2TFMwekVqRWE1WHhwd3B5akhJVEJlcHhlMGNnYXJQVGE1bUFw?=
 =?utf-8?B?UEFsYVlqZ2VDbGtycWVySjBCMFY3OTA5NEhtRlIwUEdLWGVDdDg2UWNNZS9i?=
 =?utf-8?B?QUdYTzVVMGFXM003VExJNEtqeUFIMUtjN1MrYnMwQXEwdldXMmdZYVZSaCt3?=
 =?utf-8?B?cWN6QzhVUUNJaEtnWldoa2QvTC9ybklncVZyakhpajNUeGxYY2ZLWHhMdEdF?=
 =?utf-8?B?RWZFQ0U3TUVlS2VQTG5ubE53dDBpdHU1YlN0bGd3RlZDcC85cHJhQng0OEdF?=
 =?utf-8?B?azFrbEdBNDl5em8ydGxzc0FnVWNabHBtZUNIU1lNMGtEWnB3cnVVMCttUHRW?=
 =?utf-8?B?RC9mUnQ2Z01RdEQwOHcxS1U0NTRkN3ZDdmdUZWtqMU5CL1Exc01XTGFIS2JF?=
 =?utf-8?Q?Q/BhtfejknfZf0s4g9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b2a95a-f920-4ff1-7b61-08deb51fa462
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8803.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 20:54:24.3575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8cwD9kUtyuPfMyHB4zV7GgNh+2OVgoNMmGl7I7ZHzHWgdqXlocS7qsvnC07pJMy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

Hi Tony,


On 5/15/26 14:39, Tony Luck wrote:
> If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
> fails, the mon_data structures allocated by mon_get_kn_priv() are
> leaked. Add mon_put_kn_priv() to the out_mondata error path to free

out_mondata -> out_mongrp ?

Thanks
Babu

> them.
> 
> Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   fs/resctrl/rdtgroup.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index a6376a3fc4c3..506b40dc9430 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3071,6 +3071,7 @@ static int rdt_get_tree(struct fs_context *fc)
>   		kernfs_remove(kn_mondata);
>   out_mongrp:
>   	if (resctrl_arch_mon_capable()) {
> +		mon_put_kn_priv();
>   		rdtgroup_unassign_cntrs(&rdtgroup_default);
>   		kernfs_remove(kn_mongrp);
>   	}

