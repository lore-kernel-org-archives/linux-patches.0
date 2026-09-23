Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01B7530DF6
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169700; cv=fail; b=iwvuElRs1HcdDRp9sSmugwECm9mgWfQK5ptsNV0hy4UtEyKr+3Q0ndk3i4+iBFGbVnlMcFzdMvQw7QSb+yfUSY0LtalJ42EwsqOBukWOpz+4TILUJcl/8OKrGuL/y4sBNRqWQ2ZwRctQLvdt5/2Yflg9uppeVVvBSLeUi0Wul9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169700; c=relaxed/simple;
	bh=G21CvvhM2Q+3PaXUbt+m853FKVie79Z08NwQ4G22Fck=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uCHZx1en7hQMa1coH07D7lMYO4taWs30veekaaohnljiX25KHevxWmexe4MZ+WcaFca+1aIm/EbkDpOEAbpjir0YTkljjgZteJP3IYba7aLqqYUAv7mawF51oUdsYlE+WZX1Ag5bYhfdt11042hGKEKUGR2tetPqCCdR8hnRMFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MI0ag8Qp; arc=fail smtp.client-ip=40.93.196.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MI0ag8Qp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aSwLBk4b3GUGh2y5Pk+tk9QkhV8/+51I4o1R8w/ymMS2sXT66ykcP4E7DWUOkElUW9DSlzNfbD5J1C0o4k5jgWDorZPVts8XZ5x0WTdkoWgIzuWGP3v3L0UJswBZFqHZQHizvxs6i4jK9/BqF29GJ0hSoArFvkNSHh4TpH4jKOR86YUJkdKisvhq7/GXumld+4dczzJzj/UENWL/AQYaQ8D/CnCt2Nc/9bsl1cq+bJURfHgSLUkI35wcWzFGjz6r63dhaRKcpR/cE7M3ZWecYe5UtuPCCWnLo+U6cJzt6C5kF8kfVfNITarh7zB1istMAco4euoBAHOydNENGQmnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13Gd5ybzxGXqAd22cWhLtvVXmY6XmrTLbrHolND17yo=;
 b=clZjpMmF/PJncYrJejh6znPFdh/IfpovUIWCtN5GxEkyrxCYfFZQ3VIafWFMlRVwcnwPWEIFiYsww3Sp+plSZBv738dRxmfBeJ1lvRKt52gNwNbnQxJ2xgdxczMrnZgE6ikn8Hl2USwzz7GBZSrIYbsIJVRpzHeWcCIyD8Yg9uir2nyvbQgaiN98DldUMM6NX5de11o/cB0UfztcN3WYtRZbDK93CukiSkpXwU6BE9q/CyF++QqiiqfphQfVghSxP0SRukoaV+HTsYRwHc0ubouI9OCNo1XEcx7RIrmNLoCF3Q8qYEeQWHx0Lx9EijEbhHwrE3JsV9vGIseRpgJhrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13Gd5ybzxGXqAd22cWhLtvVXmY6XmrTLbrHolND17yo=;
 b=MI0ag8QpqI/binpYUQhh7TOI0LsRmRRGNCaF34VESEoMnKyM9BavZKmRJ4zF64iRbrmD3U1ckmeebbTB4YVJHmMUsLC5XISb3WG26rvI71hVpbMzMC1fUruEGjjHrb6PkVFSZ2mrreQVoH7PdxqDOCmaVOxlPA9jlPJrm2b30G0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by CH3PR12MB8851.namprd12.prod.outlook.com (2603:10b6:610:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 13:21:24 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 13:21:23 +0000
Message-ID: <b8d1774c-8599-4777-87b4-261e6ce48bf1@amd.com>
Date: Wed, 23 Sep 2026 08:21:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: RE: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each
 mount
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 "Chen, Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-15-tony.luck@intel.com>
 <8bd7c456-c11f-4c8e-9b95-6825a00194ad@amd.com>
 <arLlcFYZiu7OcBFc@agluck-desk3>
 <a6a2e7a1-9b07-40f1-971b-9e9866bee048@amd.com>
 <SJ1PR11MB60836386E446E04EEF226029FC832@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <SJ1PR11MB60836386E446E04EEF226029FC832@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0114.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::21) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|CH3PR12MB8851:EE_
X-MS-Office365-Filtering-Correlation-Id: d11491e2-93a4-4b46-dc32-08df19759083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|11063799006|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	bd0a0OSSbsphdjt1/GZ1DHdre1eXuaUN2ep1/c1mSu741pdEztUnr4Pi3yJ6i6GFWhNAhml4uZ9NLqSD2f+L0wy6vY8lFHo/agS4Hw1Ea27zYKH0B2NFjA//GRxUPnzbL7A6AoECfZIB/nfj1Uu2nTnn16dxyRRaNb+Pl6C7kQEcgEF4KZzMfdP/JqGLWA5lOmupS+GFaZZv5O3RXOrSsV8+zdXs2saSCJixLDtsfGQZEXmWhOky/q65cYu3svOfzEDtXHLc/KLDW9uWtRH411ANGIMtPMv8OyUYFf/MHkiVkFh8POW4qhcyqCUzJGTow9c5lfZPDTrTQA3/4+sTk/bs7kHO++WmxX3S85cPE0pu+/FMuTvTd2ZrerFHhTrPQ2EyIBOa08BRE87nvgHAUDfGsZTPPFMqziRTVB7up/K6jL45uuTojd2/wishEvXX9TnFljQLdBsl8T5k5ttfTeOThHSFF41MaQyD8v2yDl6ag2OcekxVbZz26FyV1qKOniwErf2e3Vv6CM+OibUCOkYUNCtQdqig6DG0oNrwNVUDTzz4lUa6/2d1+HduiJ8wRD7IE9E5x0znx6u9gMHBtTeWnC/chJ6vSMorw1sg66meuXo86G+gPM/hxh5+n5GAjXCoeEKBfLAtwU/dTFakpcRJNDJGb9ItCCoWm3vCg6E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUl5SVpQNTlWY3A1dG8zSEFidGpCMCtOQmMyZURQb0hBZUlSbzByWmYzZ3Ex?=
 =?utf-8?B?aUFJbC9yeitIREVIU1E0WldNdzJSdkZKS3pZSXpFSzkrNWM2SThWenFhOFZO?=
 =?utf-8?B?MjNmUWZ4cTQvdnF1cDM0L3lFYUlLdjUxOUU1blJ6dnkzRGlQTDJJam9yUmZ0?=
 =?utf-8?B?czhlUUM2M29ZeXorcFlLd09DdjFocFRsY0JjY1BKaFlRUmRlUnlieUpUQ3l4?=
 =?utf-8?B?RlNKZzROOXJIcnljWTRteHRld2liekszeEZ6b2cwVnFWVjB4UUtRcDJZd0lL?=
 =?utf-8?B?cmVMenAzSGdvdHFUSEVvYzZlNy9zTXlXVkY5Y1VkdVNyZDByeDFqR0dDK0sw?=
 =?utf-8?B?aWc5emZyZ1lBaDdJc3VFckk5MXFPNXg2d3Nqbm1PcFdyamdwUCtENDF4RjJw?=
 =?utf-8?B?T2t6ZUx2eVJnWTgvRCtTdy8xL3BWcE0yeVZRUmhwc1pNSWtMaUFjWG1LVlRs?=
 =?utf-8?B?STBrQVJNc1hnQVNybDBpSjJjNUpLNDJwaXZWaVdNUlNoOVZ3YmRyVHZRWlJQ?=
 =?utf-8?B?bWlhNFh6MUROVGd1UHJ3ZjlrdThma1BpMjFlSFBrcUVrZmVLemVFdVQ0Tk1s?=
 =?utf-8?B?VUdjRThZdUVDMktVMXk5NWMvekwxMVBMdDVqNXhLRjJ4MUZHOEo5OGJTRVNB?=
 =?utf-8?B?bmIyRnN1dTVQS2paby9Lb0EwbHdFemtkY1d0a21jVzZzZmNxSmRPc3oyZ09T?=
 =?utf-8?B?SGlNWFhVajVvVXFtN3hMRHp0VU4wMkhWUUh2ckY5RkRmcUlrOVF5Smc3S3py?=
 =?utf-8?B?L2Z6NWNHbElENm1FamtRUEtBUStyWFJJRlczcjhLbHZrc0t4VDdDaGxMUDhK?=
 =?utf-8?B?NnJhZGpFcFREa3VYQWdCVUJEMFlKVi9DSXdVYmQ2czB2VVJJSWxFQU0wVUZP?=
 =?utf-8?B?M085YW1QS09HTGFqZW1ad2U2MU9DUGtpbnR6MGxIcjByWTg2V3g0ckpXNTRF?=
 =?utf-8?B?d21STEdjNUxzdm9jRnc0WGJEeDEreG9udE4vcDV4d0pnOU1nZWQ2UEcrb1NF?=
 =?utf-8?B?UkgrQ0N2MFBFcDcrNGgwYTZjaHprRHEwZzlBMGRvdWM4WkZ4dTJOS0lNQ1Z4?=
 =?utf-8?B?THFzRngyZFFNczNkLzB1UzdYRk8zL3BHOGJXZUVybHFzeVZwcWwvckZlV1hJ?=
 =?utf-8?B?aTBLaEtiOEF0ajdRU3B1RU9weHl2clVxemZEQjRYMUdsdE5pV0ZJSU5uVFlq?=
 =?utf-8?B?eUVrTmhyZWsxL2ZlbVIySEIrYitWWCt4TUpyQ2hqY0s3ODNUaW9BYlJDQTE5?=
 =?utf-8?B?OVpaOE1wQy9DQkJQajNKOWFBeHR2L2VZK2FrdmdJTllXWm9DNEw5bVRLcVNX?=
 =?utf-8?B?RmlrQitSMHBJc2QzMzRPem14eU0raXBqdHAxM0FRV2ttYmJoV2ZRUW9yTFRT?=
 =?utf-8?B?SE1QZUpCK2hjd0FqaDBxeWVPQTl1MTZQSzc0c1p1eU9Ed0hTZ0M2N3M2elZL?=
 =?utf-8?B?OVJhbEUzYThrQXV4UmhCRk1SMjZlT2RBNmtJUkozaENlRU5xRldZcytxZ3Jj?=
 =?utf-8?B?QXc5L2lhOWlrNUhyaDdJUks0c3N3Rlh3ZjBGYU9nbDVWV1NRQ0I1Z3F0Yks0?=
 =?utf-8?B?QnBzZDBJYVN3aFkyUDNBSTVUUU9yOWdkQjd5UTZBaXEvYVFBNU9XTDBlaTB3?=
 =?utf-8?B?OG1rZUZqQ0NHWXM3azJlTXpDYVZBdWxxM0s0dFBwdVNPY0xsWEhKU0FGUG94?=
 =?utf-8?B?ZW1vbjhmTHdPcGFYUzNNdWZVaUMrMGNrYlVlV1BhSytlMFlQK0ZrRmNpSDhO?=
 =?utf-8?B?UUthZGtVSVRIeWJ2T2hOb016dEFiSEJEU1I1SDNOSmF0SFYwYmdqdldMN2xq?=
 =?utf-8?B?dEpTMmsxb2pURkxwNUNod0QvS21WdU9IMmUxdG5ManhLbVp3eWRkYXF2TS9a?=
 =?utf-8?B?a29yOVoyS3dGckljQnpibGdtSWcrYWdYd1hZU2lVY0lOc0tYeklXWW0yUFpw?=
 =?utf-8?B?WkdJZDlWYnlCN1daMjg2YnlCWWdrV0dVUTlHRzFUMWs4YlQxVHBKeEJPVXFk?=
 =?utf-8?B?MysxbmRaTU5KS1J6UW1rckNMRk5HNXV1UkNEaUZkWWtHdjI2eGM0K2RhOEFj?=
 =?utf-8?B?Z3ZqUko2V0dQeE5rbTFqTDlwNWlEK0pqczI0ekNMcXZtMHNqZ0NaR1dKcUJv?=
 =?utf-8?B?SG9udUM1TDBRWFRHczF3OFZ1aUxWL0pEcTVIeGF4TnFpTCtGVU1iakYrT3Iv?=
 =?utf-8?B?d2VQMDloQW1tK09OMTIra1QzRkh1STZ4SzJoZ3FJOXhCVTl3czZhYjlEV3cr?=
 =?utf-8?B?VnozUG1UQmpzTVZhTU5CdlF4QVFCNzhXbkZ1MURxNDlRWGszdkFMcEtFQXR1?=
 =?utf-8?Q?/TdXOLu0z7pY++28pg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11491e2-93a4-4b46-dc32-08df19759083
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 13:21:23.7663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: getlZW41aDMLqUZpyH9thYr/qJDhnmHfRkZTa0qKF2hdOnMfkwhKzZZuwXIhC2iJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8851



On 9/22/2026 6:07 PM, Luck, Tony wrote:
>> Will something like this work?
>>
>> list_for_each_entry_safe(entry, tmp, &rmid_free_lru, list)
>>                list_del(&entry->list);
>> INIT_LIST_HEAD(&rmid_free_lru);
> 
> It would work .... but definitely going to provoke a "what?"
> review comment. If you remove all entries from the list,
> the INIT_LIST_HEAD() becomes pointless.
> 

Yea. True. I see kernel calling list_del_init() all the places when 
cleaning the list which does the same thing mostly(calls INIT_LIST_HEAD 
on empty list).

thanks
Babu
