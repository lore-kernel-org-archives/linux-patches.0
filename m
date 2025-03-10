Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7BEAD2F
	for <patches@lists.linux.dev>; Mon, 10 Mar 2025 01:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741571851; cv=fail; b=mHFvwezfqQLvN9CA4rWUk9b9dh4J9LXbb8BqXC7JH4S+0H0yx25wosooHjv4HdfQiBRC38x2NZtI/b/lzprairZnq2p8VhPMeR13DyweVv8fqinhzam3hfJqqiQYCL6N4+1fCmyqz4NuhnpPQvPlNXqjuKiPQakRqmRBzaxQnkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741571851; c=relaxed/simple;
	bh=NOyWovth4r8ZZX0SIhGbjznUyPGbhCx2xQiEjruoaTM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2KLC5mLZz1IE/6mrAN5ScxUxUG1matrpnkahFBG+n8Wc1se6/JAscHxYryRR4TC59256uC/xdRaxneloCwz/hQAnuk7VBBW8mrbbpcdamzvQ1JTAHMcCTYn8T/CRa0aY5i2YVscuAslFR9NOrLc6BB9HoZ1lWpDO5PNII+f8+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eng.windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52A172gg027129;
	Sun, 9 Mar 2025 18:57:12 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 458p9qh62y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Mar 2025 18:57:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nt0UnJmoCcuO6qzdlSr2V/lV17HHZt5OE4aRfjwpdMqzEn+uBd9P7B2Nm7hqDKrFS0ZnUbEU3sgqf0bbd7BWpHgXnub0aJ2xhH8dXNtvTvHvN02A+ZGpYhVE93EEew+xHtmQycABPGMjQ+bz13bTKjF+KF8XywpJqTT02X+AyIfFaR1RCEly1A3g8vDgh4A+Cj7LgDvNi9o+97RqaUf6qPx0maWR6eHMfwedKZ19Z2I/8uxdXylUpN+guo0WjoVfoINA3KxL+LCr4RGwujqEXyqax5i7KOleoTTfJS00ARRDw8mgXMnfO7xt2oGz05pB84MVZ7olCtYGGpqgHhU7ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urC7hqkbd6wxQ2t2Dd+NiK/NJZUNcQMArlkxciAPeXk=;
 b=rue2WSNPA8JsQR2pUCGt56/Ud+q3iJ4XNqsKkiN4EE6CmZu4ZnVat1CrS1/1JM+JWIEDYrVAomug12ila/gPFVXC0Yq7+p5DOmnIGIMiSmgA4lGFsR/bjTl4Vs3Y3/9ss0qToZvILBdy93GGJ0P1Ffhsg/JMCosP9LGkGqoizNa6Sg2PEYcqxud1hez1PZ7pWNyab/jZrXCWqIFctUr6iEiic5MBjhR7Jvt1YM/xrffaovC+o8pK16hFDlHYbP3ZZLkjo4MQeMVEZyUA5+vEPr9SKkJ7cLmt7JlxhcRvTqP6SGumx5qJl2awfoM6pFOjUTHBCp+s1zhuIoY+h/ZFAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from PH7PR11MB5820.namprd11.prod.outlook.com (2603:10b6:510:133::17)
 by PH8PR11MB6902.namprd11.prod.outlook.com (2603:10b6:510:229::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 01:57:05 +0000
Received: from PH7PR11MB5820.namprd11.prod.outlook.com
 ([fe80::582f:ef5b:81c2:236e]) by PH7PR11MB5820.namprd11.prod.outlook.com
 ([fe80::582f:ef5b:81c2:236e%7]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 01:57:05 +0000
Message-ID: <60675919-428a-49bf-8329-e609c07fe085@eng.windriver.com>
Date: Mon, 10 Mar 2025 09:56:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 174/176] Squashfs: check the inode number is not the
 invalid value of zero
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
        Ubisectech Sirius <bugreport@ubisectech.com>,
        Christian Brauner <brauner@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        He Zhe <zhe.he@windriver.com>
References: <20250305174505.437358097@linuxfoundation.org>
 <20250305174512.422582645@linuxfoundation.org>
Content-Language: en-US
From: Xiangyu Chen <xiangyu.chen@eng.windriver.com>
In-Reply-To: <20250305174512.422582645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY2PR06CA0046.apcprd06.prod.outlook.com
 (2603:1096:404:2e::34) To PH7PR11MB5820.namprd11.prod.outlook.com
 (2603:10b6:510:133::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5820:EE_|PH8PR11MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: bde2fabf-5a89-498e-7ba4-08dd5f76db80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enFtVnlqM1RLRWVDeGMvYmN0bGRYTE9haHpPdWtNeTBweVJkeFJmT3BoT0lo?=
 =?utf-8?B?cm1zdWcwL21wM2h0MlFhZENqOEFUODNGVXRoTmhRZ2Q5VFF0ZG9iKzE4R2ZD?=
 =?utf-8?B?R3d0aFVkRGhySTFhd2EvRzZlOTZZbU5scGk5c0EvV0VOQ0NGSHpBT2RJaVBv?=
 =?utf-8?B?VS9NRWNUUjg5d0t1NGZ3TUxYL0xHcWE3dDJBM1ROVi8wUGM0MjFYd1FNc05q?=
 =?utf-8?B?OE8wODZIeC9RME52bUlrZHR3eDVjdjROajFkdVozbHFLYStjUTYydVcyVmFs?=
 =?utf-8?B?cGNjNjZkYTBVUk1ncEU1aDdtaFBMYjJDTCtEaUJBVzFnbUMwY2JYamYrZUFs?=
 =?utf-8?B?SUQrMkhlTnZZL3hTMXVPK282TzdsVWtndldmeStPN1Nub1NvMzFvckNGSDRp?=
 =?utf-8?B?UURzcUpoeEt1bzZPWXJpUmtHVW55QzFlUk9meHF2MldVb0YyV21UdVFEdnZ1?=
 =?utf-8?B?RjlOQldrTnQ5cHFsU1B3cHNtU1Rab1JDS0xZL3A4QVhtN0hwU2ptc1VMNXM3?=
 =?utf-8?B?RUl2aHNFNUgrb2s2QlZoczBGS2dDSTBITnQ4Q1VwT3I3VDBtZzBjeHJ3eGlD?=
 =?utf-8?B?czFrdFFLbUtzUUsxeFBYdnpndFBMalB1REhySXBGK2pOR3ppWTRjRFRhd1lL?=
 =?utf-8?B?bWt4cThiaTRhU1VCcXJEVlB3N2NrQmFJcDhSZWNWL2QyZERYQ3lwbmFUdEZq?=
 =?utf-8?B?VlZxZUREMEZTSERvQXBZc01SaDFCbG9FTXdSWXA3MVpldGJIeFpkMjJ1VVAz?=
 =?utf-8?B?R0FjM1NYaDVGaEFkWjZlZFc2Tzh5OG0wZkdkWkIxRitZY3dQNkNmMjNOU3pY?=
 =?utf-8?B?b1NvRmFmcml0VXJjRVIwUGFXbUFibzdlcHc1STZ4alhOU2loR0JSR1JqbERE?=
 =?utf-8?B?VGxaVVhmQWRkTTJlQTVseEIxaDBrZWhIY3lKREtzOGRuTzVjZHM3RWdsbHBu?=
 =?utf-8?B?YW5wb0ZzN1oxNUFBenU3TFlEeGdkNXdUMXF1blVxM0tlOWJtdmNrOWhlTDRi?=
 =?utf-8?B?WFRqZ2NRSFhpRHQ4eFJjWjJIU1dCdnhoamMvWlRPZXl2ei9aRUVIZVdYZ0l2?=
 =?utf-8?B?QjFrQXFCdVdxUDRsaGxuNHNUQkVCNmx3cWZqUXlUeEdCblR3eGNkKys3VDBz?=
 =?utf-8?B?M3k0MkNBOEhHRmN1d0d5cHBkaURtS3h3STJDRWFEUWtvbUlOVkRsOHpwc0d6?=
 =?utf-8?B?VGVGbFBtMzdqZzdwSU5ad3pqWkcwMFh4aytpMmZtcE5iWWhlc3o5MExTTmp3?=
 =?utf-8?B?bW5TRkx4V1M2cFBGUEJUUmRQRnc5c0l2ZGc3OTFpZzEwNGkwVWxiWkM4aGxQ?=
 =?utf-8?B?NU1NTkNkTFpsSjNBb3R0a3YydDE1SXZCSFA0ZGd5Rmh2c1JRS0dzZGRaeEJa?=
 =?utf-8?B?bjV2MUZ1UEhBaFc4SHFuUVJQQTN2dnNkMlMzQVFkVkFlaGZ6dmNrSlEzNEVB?=
 =?utf-8?B?ZjFxNGlUOTJwNC9LL3p6STFWejZQVnVRVGZqQVA4OU1qVExIb0VkVmNYQkY4?=
 =?utf-8?B?Y2c1RE4xaGl2RFF5aVUrU1Npem9NSk9FTVUrOXBER3pKQUVmUFlLT3dCNnY5?=
 =?utf-8?B?Q1dHOUV2a0c4UzRhVUNVd0JDZ0NpVTQwQ0ovTWR2akFsYUQ3bWlLS2xDNlBF?=
 =?utf-8?B?R04zNUdZVW5jWW8zODRBWHM0amIza2VUOS9veFdtMHFGWEFOTURuWmpFVmlG?=
 =?utf-8?B?dE1MWDAyZ0hZOU1hVGx5N2wzUXA2b1BuL0VpazQzMzJWZUVWQTZyVlR5bW0w?=
 =?utf-8?B?UldndSttOEdOTUw0dm9qWVhYOWFrRmliczE4Z2kxZlBrL0x6ZC96M1ZwN1Az?=
 =?utf-8?B?NVZSQjVxL2xMS3UrL2VoY2ZsWkVxRHVlMGdacHZNbGtwQnF6UjhSUWRnS2d3?=
 =?utf-8?Q?LGTIcuZOTx9SO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHBTMUFDZERsb044QzJmRzB2cU5GSy9vT3V3ZVltLzNGbWJiQUJuRDU0ZXdt?=
 =?utf-8?B?SlowSUExc1hyK2JIS09lVU9GRWlhbXVZaFF3UDVZazl3Mjl4WFlaQUZUcG1M?=
 =?utf-8?B?Mjc3ODcrbklwdS9LKysvcEpoSlRGVDEra0xqZnAzaUozVmpOdUxTdnlyTGY0?=
 =?utf-8?B?ck9wSzhmcDl1aThlNGs4UjNYMmlDNmwrUE1HUXhzSHVZQWJKejltWW5OcElp?=
 =?utf-8?B?RTRsNG9HUFJ0My9IaXpncnA3Ynhkd2VGb2JrNFEyMzkxN09qcmVUNlpsMWVt?=
 =?utf-8?B?R0FMRUNrWnJPejJlVVdXMEUvS2dYdTRwMTVQNWgwZ1VqdW4xMGpmYXlHSlVY?=
 =?utf-8?B?WWplb3RKUHRNcXBpTkFFYm5LNnRzYjNKQUdRck1McEFlM3JLeWlIdEpKcHJR?=
 =?utf-8?B?QVl4UFcwYXZlOTFZM0h6elJCQUJnclROakxPczNpaTFwOGVFS2x3eDZxMW5h?=
 =?utf-8?B?OFovSVh6TUpydEtvTGRiSldhSFltYnhrMUVXMzhWYTJtRW9ZR3FObmIwVm9i?=
 =?utf-8?B?ZmluWGNlSXBQejh5b1dPcExJZDBobHpIb3RPR1BZRkVRNWZneHFLeXRzV09F?=
 =?utf-8?B?bThCbDhadllTTGdBNGxZVHV5S2thaHlzaUNBT1Z4MHc1LzRHUStlR08wMzdo?=
 =?utf-8?B?QmF1bkZYOUYxS2wwVEE2RGUrN2Z1T1hCVjhVS2ZtbWpBRGxEanNhQmZicU1Y?=
 =?utf-8?B?Mzk3UjRoTkZNUmRhYlV6eVZBcWt1d0JlU1dlOEVtd3o3VmFrcVlNMjU0OXk1?=
 =?utf-8?B?cjVNVmlUL2R0Z3JKMUVPeHVIYzN3OGpSMVR3dzB4MENtM0JJdDArUEtvSlcz?=
 =?utf-8?B?NlFsR21sSC9ORjRtUHVWZk5rU041WktXRENGZ01JQ0txcWhJdXpnVGFFbDJs?=
 =?utf-8?B?b1kxVjFaRWxlYkVvbkRhQVZRMjBjVW85cktjWDVrajNhTDlzN3MzK0hiRkZL?=
 =?utf-8?B?aHBIbDJsV0VaZUpCaXhFdkNnblk2VnJsMnRNMGhmUFp0OUJmOFF2c0o5NW4x?=
 =?utf-8?B?M3g3czdycStmOEozMkcxMDhtVkdsZVh1amM3eml6cngrUGN2Zm14bjczKzlE?=
 =?utf-8?B?Mlp0dHV5ZFo5Z2w5Q29LOENLOE9QMHFGa25zcW9NVGptSURSZkNqRUk1bUg2?=
 =?utf-8?B?RFFGTlhxeUpIWUFWRVVNVEwvM3Q3ZHN1MUp4RjczRWtVWjh3VjRPci81M0lh?=
 =?utf-8?B?TUQzSmhMRS9XWXdWLzAydXNRYjA2aE9lb0V1Q2pDR01MQTY2MGJXdkUwK0la?=
 =?utf-8?B?TGF0RVorRmZmT1F0STkvYUUwOUtzSnlBVnRqMlBmWHg5R2hCN0plYVZQZDkv?=
 =?utf-8?B?ZXRIRGtCZXNzOUhKYmJEQjhHRmFxc093eElTdTRTZWNZR0l1OUUvckExYUpm?=
 =?utf-8?B?VitPTDlEdkJ1UzVCbFYrYzRxUG1oYjB5TXltZ21xZ3pzL3duZFVKSnBpaGtG?=
 =?utf-8?B?QkRQN1lBckdsSlBQaDFQb3hvWWdneE15TmV0a3hTNU5GVlI0YWhVK0k1VUhY?=
 =?utf-8?B?YW8rQnlvSUc2Y1V1UEtpRjNLcndnRFVmYWxxN21VS3p0Qm4yU0Vna3RlWG5x?=
 =?utf-8?B?blBqN3ZVd1BwdEZHSGdTaUtpWkxlZ2p0WnFoMEJ0ZGx4VGxsWE9YMjlpSkdE?=
 =?utf-8?B?aS9MT05wWEFlelZzT1BiTXBmT3dPMnF2SHcvSnM1SW5qR1hWY0V5RnNpVjRm?=
 =?utf-8?B?Sk5oa2lXdi9hdE9Rc2RtbVdITkpWaS9EREJkYXloUm1VRjFqZ1RRSjA4ODhY?=
 =?utf-8?B?aG1UdzdBbTdUeW4xb1JMQS9zd05hODZKUTVMbWdkeVpFbmR1bUIvcEIwR0Uz?=
 =?utf-8?B?Y0grV0dWNU9LUU4vaEZaRDlaNlg1Q3JzaUNkckN0TTdmS3gyK2JRRDM4YS8w?=
 =?utf-8?B?U2tSbXFTV3E3TG9mcXcrMW9MWEE3MTJ0SVNNSEtYK0ZMT3E1cWhPam5aUDI3?=
 =?utf-8?B?eVl5VWhRcUp5ZFgvTGN5TUp6N2cwTVQ1NWpjMmZ3V0hqcEoyRnJ3R0ZoeGxn?=
 =?utf-8?B?ZEdRRGdIbnk0Vld6M0hmeDhpSi8zWTFXUldRWWU3UWowYUhQbCsyamVnaG44?=
 =?utf-8?B?bjNSd1RxaG5qcTJpQkwvV3VONHkzcmZyb0loSmNzZ0pMRENUenpqaFdpU3hJ?=
 =?utf-8?B?Z3haWWtqZzc0YXJTZGJUcDlWS1hzL2NIcVpuYkVvUTJvb1czWUppS3A1Mnk2?=
 =?utf-8?B?eGc9PQ==?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde2fabf-5a89-498e-7ba4-08dd5f76db80
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 01:57:05.2436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQQlS+GLSsR8BmVICEwHq2/XYJUZdXzug8a56gO8pYVvdjCR2CzFlqd7jc/VYL1nm9jA0mXCOqA+gmqUc+5NQNk581LELlBnvpYxUjdubAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6902
X-Authority-Analysis: v=2.4 cv=QNySRhLL c=1 sm=1 tr=0 ts=67ce46f7 cx=c_pps a=ztkV8ooph0rfw1Th5QLTnw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=XJTnSpgKjpJfBdNX:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=VwQbUJbxAAAA:8 a=FXvPX3liAAAA:8 a=1T6qrdwwAAAA:8 a=ag1SF4gXAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=lFf8MJSSQo8cxbnM8X4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=UObqyxdv-6Yh2QiB9mM_:22 a=pdM9UVT-CToajMN3hxJJ:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=HkZW87K1Qel5hWWM3VKY:22 a=FdTzh2GWekK77mhwV6Dw:22 a=Omh45SbU8xzqK50xPoZQ:22
X-Proofpoint-GUID: mlxr3NfRXUfBcHmYt35oh8ZzIgEjQ66W
X-Proofpoint-ORIG-GUID: mlxr3NfRXUfBcHmYt35oh8ZzIgEjQ66W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 clxscore=1011 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2502100000
 definitions=main-2503100014

Hi Gerg,


Could you please help to cherry-pick this commit from 6.1 to 5.15 and 
5.10 branch?  Thanks!

This should also impact on 5.15/10 branch, I tried to cherry-pick to 
5.15/5.10 in my local setup, no conflict happens.


Here is 6.1 commit information:

Squashfs: check the inode number is not the invalid value of zero
author    Phillip Lougher <phillip@squashfs.org.uk> 2024-04-08 23:02:06 
+0100
committer    Greg Kroah-Hartman <gregkh@linuxfoundation.org>    
2025-03-07 16:56:51 +0100
commit    5b99dea79650b50909c50aba24fbae00f203f013 (patch)



Br,

Xiangyu

On 3/6/25 01:49, Greg Kroah-Hartman wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Phillip Lougher <phillip@squashfs.org.uk>
>
> commit 9253c54e01b6505d348afbc02abaa4d9f8a01395 upstream.
>
> Syskiller has produced an out of bounds access in fill_meta_index().
>
> That out of bounds access is ultimately caused because the inode
> has an inode number with the invalid value of zero, which was not checked.
>
> The reason this causes the out of bounds access is due to following
> sequence of events:
>
> 1. Fill_meta_index() is called to allocate (via empty_meta_index())
>     and fill a metadata index.  It however suffers a data read error
>     and aborts, invalidating the newly returned empty metadata index.
>     It does this by setting the inode number of the index to zero,
>     which means unused (zero is not a valid inode number).
>
> 2. When fill_meta_index() is subsequently called again on another
>     read operation, locate_meta_index() returns the previous index
>     because it matches the inode number of 0.  Because this index
>     has been returned it is expected to have been filled, and because
>     it hasn't been, an out of bounds access is performed.
>
> This patch adds a sanity check which checks that the inode number
> is not zero when the inode is created and returns -EINVAL if it is.
>
> [phillip@squashfs.org.uk: whitespace fix]
>    Link: https://lkml.kernel.org/r/20240409204723.446925-1-phillip@squashfs.org.uk
> Link: https://lkml.kernel.org/r/20240408220206.435788-1-phillip@squashfs.org.uk
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> Reported-by: "Ubisectech Sirius" <bugreport@ubisectech.com>
> Closes: https://lore.kernel.org/lkml/87f5c007-b8a5-41ae-8b57-431e924c5915.bugreport@ubisectech.com/
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/squashfs/inode.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/fs/squashfs/inode.c
> +++ b/fs/squashfs/inode.c
> @@ -48,6 +48,10 @@ static int squashfs_new_inode(struct sup
>          gid_t i_gid;
>          int err;
>
> +       inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
> +       if (inode->i_ino == 0)
> +               return -EINVAL;
> +
>          err = squashfs_get_id(sb, le16_to_cpu(sqsh_ino->uid), &i_uid);
>          if (err)
>                  return err;
> @@ -58,7 +62,6 @@ static int squashfs_new_inode(struct sup
>
>          i_uid_write(inode, i_uid);
>          i_gid_write(inode, i_gid);
> -       inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
>          inode->i_mtime.tv_sec = le32_to_cpu(sqsh_ino->mtime);
>          inode->i_atime.tv_sec = inode->i_mtime.tv_sec;
>          inode->i_ctime.tv_sec = inode->i_mtime.tv_sec;
>
>
