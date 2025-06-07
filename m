Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27632BA3D
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257168; cv=fail; b=aeg9SLkyTOrxLpHSwti+tk7HQeR+K0X5bKVtX2eLhyc1+bCASvgl2pbADwqWOedHI6kAleTkz7iZlGEtqFuT3FIo2J3KNqLfZeiu6ACpBQJoigxk3DJsMCY3syDBNPQjYTki/7LPVPRRT8F6CtbCI0KONsJGoghlRCpA9Z6EKCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257168; c=relaxed/simple;
	bh=FYwSd6h7nw8Da51KdTDJt/n680jNq20St3yr1ckiMP0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QCMDAUNpKKPPCPKgj9dwCzp7+g+CkZavWBzUqQYwUZdzcUN3n+DjMFMaMD/yKAWZicaY3QTa51MEb5XyQEQMDKuDXfwR2WjLodSjypWGKBGpq9wHCk/s5k05C4MBAYWZHdduJJgzugR85ARZnzALliDZk2eVQaJM5HrNktBr0os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jjwox/gN; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jjwox/gN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rCploUGeh+0vxmqfOTCiHTj5gkeO/IzG58iv0utL0AYb/HKCjFqeiRo1Kah6iF8gJaD5xq6SSFL8CBpf0gQLlCt0OmzWMLIpIOC7goLG825qczMxj+HHpIuKJjVU175nzmvCXSb072zcedCyNvb2KouX9KbHLRbf/f5t1WlJtTTkwbcSjEW+abbarOr/4vXRkv6YG9XAa0i+vmLvk38BMH10J12IOhvsKqvptp7QWw676txFBf9evAKOA3jVeExhP3QBZ4ccj46fDFpPoNn2DTRHBECyRu71AQseiaaMsAe9Gd0OPhIfZqvn7v4pUT0yZKuFRO77lBWuGtm/CLJY1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OACl90BbEF8qzErYujmKzTdrG2WhufvmTNjJiD8LGxg=;
 b=oeNKIHpHzY5Dw+59Vc61viqz1uD6KDX5SzTbFdoXJZ541bYt4py5IvJYLQ1/GcvqLA9OCRENyGOE09RIMox1ehCv79FAi6ejO7pnjt047fQ6DYMTh26wWEIB7eDtrtGODxkLop5FM5X5U4d6RdxcxXFkx7eDiLo6LoItlq+fGCY42CQcPwuUjrg5Wg02Xr6qTTqRK3eSvIEkE3iClinPk4c8mZMaMqXEmQ/69mzzsfM4gZqvZdwSpzFp1E4ArjBHNf1mY5J7CffvuEC/GMN+eyEqHT5sRZRjiJEyZBKcDA8ckaO8pJAw+0SbuDVsHHHVDFZOLtsaSogEbXSIaToGig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OACl90BbEF8qzErYujmKzTdrG2WhufvmTNjJiD8LGxg=;
 b=Jjwox/gNV4k+7tVEwX/W7gXC5hEWMg5alCM9Au7Zb8A6sFwk2b/VTGlX+rAiINdxCIeEt7UHNZh0RaOJBCk5jKZxghwYXZJnmeN+CxafkWJbTSaxm6a9aAjG+GPOjdX4qxgPcBjDs5fBCWlUWnsyPbPwVPW6vjxq3IyxwiK7qs7OYwXMs3x1rxM6q29uOsPN9K0iqbyRfWtK/2DvNAMuhOXRNBfipvrrV53RkmZCgHpfs488uU1qKj6CM9kTaHm/pjM8QcCMPig+I8vDGfOuzNf6JFQkFm6yqu/hi4sJEYSqBTHmSgW56Z4UjoWiJJkNoCHE3LzfPGKm98qinPb6fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 SA1PR12MB6993.namprd12.prod.outlook.com (2603:10b6:806:24c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Sat, 7 Jun
 2025 00:46:01 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8792.034; Sat, 7 Jun 2025
 00:46:00 +0000
Message-ID: <462eb5cb-56bc-4639-9029-5166cb71b5bf@nvidia.com>
Date: Fri, 6 Jun 2025 17:45:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/29] x86,fs/resctrl: Prepare for more monitor events
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-5-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250521225049.132551-5-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|SA1PR12MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: a138cf0e-8717-4a4a-4057-08dda55cac6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vy9ob0NRV29UUkpVejJvLy9kdk16dy9jUitHWExmN0JhMnJMTVNZS2JPZ1pH?=
 =?utf-8?B?V3FVUTMrVkM3TU1EQkxDdDczVVpZQkNEWU90enh1dWdvT3liMlY1WXcyWFlp?=
 =?utf-8?B?MmdkUmdJRzhYbVZFMnVHZUplQTlDS05mNHpZSG9LS3A3aENFd1BDcUlBSjFn?=
 =?utf-8?B?a0lCYXUxV0ZSZ1I2Qnp0Q0ZrdkZUMSs1SnhPVEwxRmlscjJEZ0pNd3VIaG1Y?=
 =?utf-8?B?RjRoS1QzRnI4QTExcEJGaDkyeS9rQmpUWDFrQUVWVFNxeUlGVDNmL1VySU1l?=
 =?utf-8?B?eVNnSnVyaTVzQmdrKzRLdTlNS2drbmpyVk11a3FEUFFmMjJKcnNZZ3hsVCth?=
 =?utf-8?B?NXlGU3pvU2o4QjhUZGcyR09FNkE0elhRTGxmQmE0UEdydWo0LzFNdCtRTjMx?=
 =?utf-8?B?ME5xTHF2ZVJoNFlWek1Qc1JKTUFBWlg4cmIzSFA0Z0lzS0V0MkJ6UitUTWVr?=
 =?utf-8?B?bkdaTEx4UmNXYU93U3k2QVpHOWg0UVNLNUYyaXBoc25OMnRMWGJUR04yQXhL?=
 =?utf-8?B?dWt6MG8yV2tqN1lOVFd6TDBoSExxNmt0eFBZeGI2elZkbmFJL09Fbm5mcUNN?=
 =?utf-8?B?QXdIY2Z6VXVHTCsydHRvQ1lwUEJ3azdYVUNOQy9GTU5WNEpRRCtSdjB4NGZm?=
 =?utf-8?B?SFQ4SDhJbm5IQ21DVjREdVE1Mk9OTEkveXhhdFpIWEdpSUhZMnJRUEtTeG55?=
 =?utf-8?B?anZocDVaVDBVZ2NSQ2p0YVowSEZRSDdUUGdpVWE0Z1JiMk1yY29VWXBkQldl?=
 =?utf-8?B?cEN0bEZ1QkNibGQ1akN2TURYOVg3OHZ6SnVtdzFndjJhVEJCSGtCOGNrTVZj?=
 =?utf-8?B?TDYzR21KUDI4MVNKQmpTOFB5blFjbWlhejVlVVlKb1Z6aEVIYncxcEl0Q0tL?=
 =?utf-8?B?VG12Q3cxQTN1M2hTemFwY0J6VzVkK2RqMXpPNVlHQXZFUVBlT2FlMGZFNXU5?=
 =?utf-8?B?ZUVMc3dmRHJqbjQvZFNHU0FON3huSkVUdWU1Z0paaisxbjExRkhHakFocjRZ?=
 =?utf-8?B?TUpTUVBvaUo1eklINFljZkc5eWI0dHBaZmM3NCtHWDQzTVAxSUdwV3A0TS9F?=
 =?utf-8?B?dFMrdHhuM1NldUZpNnkzRldETWw4Y1YxQWxlanFwWXlhRFlRdlNFN3dIT0hv?=
 =?utf-8?B?S3RNaXBhejBqQkxtSElWR29EOVhFb2tSMXBjbFlhaDZYWmFVVjBoeHJqeGY3?=
 =?utf-8?B?dFJKNGdMMmh2Z3dPOWVqTTJic1BjcHMyN0Y2WlN5YjRSaTI4NlV1ZCtua3JY?=
 =?utf-8?B?Q3UyNVFHQTJ4cnF4Y2cvbE1aS3R4bE03Z3luU1ZlT3ZWcEdTMmJuaWJWTUpG?=
 =?utf-8?B?NmJEaWs3eFc3Uk9mUjVzQTdiRUkvbkNJVWpWNFQwWWcxNkVmd1B4aEY1U1lm?=
 =?utf-8?B?R0F0ekxkeFcwcFNSQnJEZEVTNE9BOFR6WGpBazk3RVhzVk5LOFpmUHQwS1Vz?=
 =?utf-8?B?S3Z4aHVEVE1lYmVaN1NNTXEvenNlaVpDY3BTVklkaXdwWFpLR2dvRUp4NE5h?=
 =?utf-8?B?bkt2aW9VNTdpMisrOHVENmxrdmZTR1Bub0x4ZWszQU92a1plcVZoSUtUMkVS?=
 =?utf-8?B?Tmp3WlFCL2RMVDFsOHp6bnJtSm1saTlEdnp2dnJhbTVBYTJJNm1ISTRET3ov?=
 =?utf-8?B?bVlJK2FJZU5WRDF0MFlML0d2WGJMSGhiUXJUem1EaDZIdjQ2UklKTFIxbnFl?=
 =?utf-8?B?dVdmQVJBMFBISWE4b0JhdVlWclhEMFM5Ty9jc2NmU0V1cHZsSWYza3lkU1BG?=
 =?utf-8?B?MlN3UHJxeThVYlJOa0E3d2lFQUZYbjNhaVdROTlmKzQvNGNoNm0wdEFHdWhH?=
 =?utf-8?B?MGlPWUZrRG92cVEyYUxLMm9mZ2dpU1RmbnJ5d1hnNUFmcjk2ZjB0OWM3bU5W?=
 =?utf-8?B?eHNXcXpDQm1MU0N3SFc4aW80L3lrSlozeDU0UmN0aFdwQjRENXF1Z3JZNTdv?=
 =?utf-8?B?MmRIN1NzOFMvTStkcHg0NGpUcTFyRnB6K1JwY3NRN0pZcXR4akNmSWdmMnpr?=
 =?utf-8?B?U3Y0WEpPMVVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlgrR0JHYnJQTmtyY1VWdjNXMkdTOUwxaURsZ205R3lPMlJGd0xyOTliaXVw?=
 =?utf-8?B?azFOb1c5UzRvcTZtVXpvQUx0dmJJUlR0VzA3bFRhcW41TWhFdmhVR3FvWmJJ?=
 =?utf-8?B?ajFHKzMvM01NSE1nV2luMUwvTEdHbms5Vkh6TjU4TW5nNjJKR21aS0h6QUpT?=
 =?utf-8?B?cFJHckRWemI2TElPN1BJQWVKbU1GdnNZaXhhRDcrZGliMjBacGhWNm0rSGVj?=
 =?utf-8?B?OHNMMzEyVmZpdCtpcktUN3NxYmhmb3hodGlNcW1OYkRSTlJraWNTd2R5R2hj?=
 =?utf-8?B?WTZaVVZqOVV0b2dRd0VwT3ZRSGh6SGdDUlRUaStXNGZKNzBuY3k3eFZoWHpk?=
 =?utf-8?B?SlRBU2g3L05TUFhjby9ocjh4VEVrdnFVL3pwSkN4MWhpSndKVi90YmlPMkNH?=
 =?utf-8?B?NXlmcFhNSmhWNUpWZk8yMXRDMVU1VkE2LzJzT1pNNDQ1bHMybmsxMGZsVG1Q?=
 =?utf-8?B?RWJsTG1BN3ptem5aNk1SN040N2dudExRS0NQZWlDK2dKZmNRZlhsUUdrRTl2?=
 =?utf-8?B?UThXWHN0dkptTnBTZU1FVXAyZis0Zndjd2trNDJRVlN5OC85OStTRGNJZkI5?=
 =?utf-8?B?TktvRTdxRmFwejBkRnJnSWh0d2YySGlnRURJOHpsZDRrUTIzZ0lmemFlcDNs?=
 =?utf-8?B?ZUNmNUxsckRHUmc3SU0vUkdWN2swQVlSRXIxb0cxOFpBQ0JSUjVHTjhXVU1j?=
 =?utf-8?B?WDM0T2IxYkFBOUJraFJwY3FhRnlseGxnN2lBVU5iYkp6YnE4T24zQ2w2NnhB?=
 =?utf-8?B?YXYzWWxtSzM3WVo5OFIrcFdTVlEyUzNoenRVdHZYeWN5SW9iVHloZUdRYTNY?=
 =?utf-8?B?bGJkbUR0WU51ZjhoZ3JlQ0dHbkg1Mmg4bjhja09pVzFBc2RnTjlyZnprZHF6?=
 =?utf-8?B?dkJxdzJzVExhZVNoZFdPU052WjhLMGlTa3ltU3JabStNODBWeGh6RHhFTDNl?=
 =?utf-8?B?KzNQSU9peUE1VCtLdG5WYVJzVkdiYkZoOE0xdmlYZmZHRitHaUZSbXRWZUtW?=
 =?utf-8?B?SmNQMlVkeERrN092b1pGbTlEWnFwQ3Fjc2NIVnZNSFB4Mys4bFNVVk9yZEpr?=
 =?utf-8?B?MWpoYVF2MThFUmsxR2xuWExwYWQ2dTlUdmlmY1YwUlVTcXVTREd2THZNOGE0?=
 =?utf-8?B?NGNzVHhrVnU1RnBDTGkxUW4yT04yWXlGUGFZTkIrZ1NKVzJhb21CaWh6V2hs?=
 =?utf-8?B?eUpybVZ6UUl5dVc3TVlmVVhsWEJJS2UyQkZXREQvd3JxVXF2Zldsclpwc1JH?=
 =?utf-8?B?OVNUTkZheUJCWGExTlkrTHM0Sm1sTHZxUk5CVnBzVE5pVFljNlVXT0s5YkNq?=
 =?utf-8?B?ZXp1R2MxZmlDZG9KbEdWUGpVL0hwNWFyTWM1SVV2RkNVVFIvZVo2dnZKNG9p?=
 =?utf-8?B?RTk5SXdudmFKdEtVTS9YVXJuYWhuSlZsdnZZWEE3UkhlMWZ2enVWTWM4cllM?=
 =?utf-8?B?djF4S1pZN0dTMk9wM1ZNQW14aHBVbElUcHEvblhLYU1xakwyZnd5WmZkdlVr?=
 =?utf-8?B?MHdDMGtNYldlT2ljVnVqOS84QVlHeUFSUGI2dzhBekpKRWRGQnFHVUs0Vk9y?=
 =?utf-8?B?Q1h5Q1dDang2NStSa041Y3pwVC9vMnFRQW1PZzQyTWZuS3hyOXdtdDJEbVNq?=
 =?utf-8?B?eS9hYUU4aC9DT1hyeWNkV0lwN1JRbWl2WHM2bFgwY0R2VTR5dHkyWERqVTYz?=
 =?utf-8?B?bks5UkdRNnptTTBOSG8rMlJ1aDc3ZUw3SHdzaXh6aTVTV1JLVVRFYkZpNjZS?=
 =?utf-8?B?MXpKVlBIWmZBVk83eGlRUmd2c20wRTVpcmZZK2xBNHo5ejV6YmNUajBQUmRU?=
 =?utf-8?B?Y3V2TFRGTUUzVmE3VldoaGJnWTk4bndUNXlJTGhucXZLNGxNU1lRWGErTnZ5?=
 =?utf-8?B?VWg2eGtEVVRya3lKSXIybVRybFJFT3hxNXlrY2dZelNtSVdUZTByZ3VrTS9U?=
 =?utf-8?B?RnRBcVJCMjV2S3BXK0oyZ0g1QTZTK3lJTUl4cXhPQlVla0FnZTQ2djZWTXVk?=
 =?utf-8?B?RUdyTlBtb2Jadnh1SExtSVJuaERHZFk2K1RKNXpnTUl6V29reUd3UU5HVHNU?=
 =?utf-8?B?TEpaUUFuRHhRVS9DOG1rLzBsc0ltYURmWFBPUko1NE1QZ3F3RldXdXVSVDVG?=
 =?utf-8?Q?Syqnk4mvY0r7QD5D1yEO22B5L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a138cf0e-8717-4a4a-4057-08dda55cac6d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 00:46:00.7520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3Kju7UgzJ2AThifOSce72ujB25KbwfRA3ZVPELL8tW1OjPfvEU4iCFFtLOtAoOPJ72CTdo2JxS0p/pXTH1CnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6993

Hi, Tony,

On 5/21/25 15:50, Tony Luck wrote:
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
>
> There are two MBM events and resctrl is coded with a lot of
>
>          if (local)
>                  do one thing
>          if (total)
>                  do a different thing
>
> Change the rdt_mon_domain and rdt_hw_mon_domain structures to hold arrays
> of pointers to per event data instead of explicit fields for total and
> local bandwidth.
>
> Simplify by coding for many events using loops on which are enabled.
>
> Move resctrl_is_mbm_event() to <linux/resctrl.h> so it can be used more
> widely. Also provide a for_each_mbm_event() helper macro.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h                | 15 +++++---
>   include/linux/resctrl_types.h          |  3 ++
>   arch/x86/kernel/cpu/resctrl/internal.h |  6 ++--
>   arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
>   arch/x86/kernel/cpu/resctrl/monitor.c  | 36 +++++++++----------
>   fs/resctrl/monitor.c                   | 13 ++++---
>   fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
>   7 files changed, 82 insertions(+), 77 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 843ad7c8e247..40f2d0d48d02 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -161,8 +161,7 @@ struct rdt_ctrl_domain {
>    * @hdr:		common header for different domain types
>    * @ci:			cache info for this domain
>    * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> - * @mbm_total:		saved state for MBM total bandwidth
> - * @mbm_local:		saved state for MBM local bandwidth
> + * @mbm_states:		saved state for each QOS MBM event
>    * @mbm_over:		worker to periodically read MBM h/w counters
>    * @cqm_limbo:		worker to periodically read CQM h/w counters
>    * @mbm_work_cpu:	worker CPU for MBM h/w counters
> @@ -172,8 +171,7 @@ struct rdt_mon_domain {
>   	struct rdt_domain_hdr		hdr;
>   	struct cacheinfo		*ci;
>   	unsigned long			*rmid_busy_llc;
> -	struct mbm_state		*mbm_total;
> -	struct mbm_state		*mbm_local;
> +	struct mbm_state		*mbm_states[QOS_NUM_L3_MBM_EVENTS];
>   	struct delayed_work		mbm_over;
>   	struct delayed_work		cqm_limbo;
>   	int				mbm_work_cpu;
> @@ -376,6 +374,15 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
>   
>   bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>   
> +static inline bool resctrl_is_mbm_event(enum resctrl_event_id e)
> +{
> +	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> +		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> +}
> +
> +#define for_each_mbm_event(evt)	\
> +	for (evt = QOS_L3_MBM_TOTAL_EVENT_ID; evt <= QOS_L3_MBM_LOCAL_EVENT_ID; evt++)
> +
>   /**
>    * resctrl_arch_mon_event_config_write() - Write the config for an event.
>    * @config_info: struct resctrl_mon_config_info describing the resource, domain
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a25fb9c4070d..b468bfbab9ea 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,4 +47,7 @@ enum resctrl_event_id {
>   	QOS_NUM_EVENTS,
>   };
>   
> +#define QOS_NUM_L3_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
> +#define MBM_STATE_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
> +
>   #endif /* __LINUX_RESCTRL_TYPES_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 5e3c41b36437..ea185b4d0d59 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -54,15 +54,13 @@ struct rdt_hw_ctrl_domain {
>    * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
>    *			      a resource for a monitor function
>    * @d_resctrl:	Properties exposed to the resctrl file system
> - * @arch_mbm_total:	arch private state for MBM total bandwidth
> - * @arch_mbm_local:	arch private state for MBM local bandwidth
> + * @arch_mbm_states:	arch private state for each MBM event
>    *
>    * Members of this structure are accessed via helpers that provide abstraction.
>    */
>   struct rdt_hw_mon_domain {
>   	struct rdt_mon_domain		d_resctrl;
> -	struct arch_mbm_state		*arch_mbm_total;
> -	struct arch_mbm_state		*arch_mbm_local;
> +	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_L3_MBM_EVENTS];
>   };
>   
>   static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctrl_domain *r)
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 819bc7a09327..4403a820db12 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -364,8 +364,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
>   
>   static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
>   {
> -	kfree(hw_dom->arch_mbm_total);
> -	kfree(hw_dom->arch_mbm_local);
> +	for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++)
> +		kfree(hw_dom->arch_mbm_states[i]);

Is it better to define a helper for_each_mon_event_idx(i)?

#define for_each_mbm_event_idx(i) \

     for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++)

Then the above for loop can be simplified to:

     for_each_mbm_event_idxd(i)

	kfree(hw_dom->arch_mbm_states[i]);

The helper can be used in other places as well (see below).

>   	kfree(hw_dom);
>   }
>   
> @@ -399,25 +399,27 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
>    */
>   static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
>   {
> -	size_t tsize;
> -
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -		tsize = sizeof(*hw_dom->arch_mbm_total);
> -		hw_dom->arch_mbm_total = kcalloc(num_rmid, tsize, GFP_KERNEL);
> -		if (!hw_dom->arch_mbm_total)
> -			return -ENOMEM;
> -	}
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -		tsize = sizeof(*hw_dom->arch_mbm_local);
> -		hw_dom->arch_mbm_local = kcalloc(num_rmid, tsize, GFP_KERNEL);
> -		if (!hw_dom->arch_mbm_local) {
> -			kfree(hw_dom->arch_mbm_total);
> -			hw_dom->arch_mbm_total = NULL;
> -			return -ENOMEM;
> -		}
> +	size_t tsize = sizeof(struct arch_mbm_state);
> +	enum resctrl_event_id evt;
> +	int idx;
> +
> +	for_each_mbm_event(evt) {
> +		if (!resctrl_is_mon_event_enabled(evt))
> +			continue;
> +		idx = MBM_STATE_IDX(evt);
> +		hw_dom->arch_mbm_states[idx] = kcalloc(num_rmid, tsize, GFP_KERNEL);
> +		if (!hw_dom->arch_mbm_states[idx])
> +			goto cleanup;
>   	}
>   
>   	return 0;
> +cleanup:
> +	while (--idx >= 0) {
> +		kfree(hw_dom->arch_mbm_states[idx]);
> +		hw_dom->arch_mbm_states[idx] = NULL;
> +	}
> +
> +	return -ENOMEM;
>   }
>   
>   static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index fda579251dba..85526e5540f2 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -160,18 +160,14 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
>   						 u32 rmid,
>   						 enum resctrl_event_id eventid)
>   {
> -	switch (eventid) {
> -	case QOS_L3_OCCUP_EVENT_ID:
> -		return NULL;
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_total[rmid];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_local[rmid];
> -	default:
> -		/* Never expect to get here */
> -		WARN_ON_ONCE(1);
> +	struct arch_mbm_state *state;
> +
> +	if (!resctrl_is_mbm_event(eventid))
>   		return NULL;
> -	}
> +
> +	state = hw_dom->arch_mbm_states[MBM_STATE_IDX(eventid)];
> +
> +	return state ? &state[rmid] : NULL;
>   }
>   
>   void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> @@ -200,14 +196,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>   void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
>   {
>   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> -
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
> -		memset(hw_dom->arch_mbm_total, 0,
> -		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
> -
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
> -		memset(hw_dom->arch_mbm_local, 0,
> -		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
> +	enum resctrl_event_id evt;
> +	int idx;
> +
> +	for_each_mbm_event(evt) {
> +		idx = MBM_STATE_IDX(evt);
> +		if (!hw_dom->arch_mbm_states[idx])
> +			continue;
> +		memset(hw_dom->arch_mbm_states[idx], 0,
> +		       sizeof(struct arch_mbm_state) * r->num_rmid);
> +	}
>   }
>   
>   static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 325e23c1a403..4cd0789998bf 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -346,15 +346,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>   				       u32 rmid, enum resctrl_event_id evtid)
>   {
>   	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +	struct mbm_state *states;
>   
> -	switch (evtid) {
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &d->mbm_total[idx];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &d->mbm_local[idx];
> -	default:
> +	if (!resctrl_is_mbm_event(evtid))
>   		return NULL;
> -	}
> +
> +	states = d->mbm_states[MBM_STATE_IDX(evtid)];
> +
> +	return states ? &states[idx] : NULL;
>   }
>   
>   static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 80e74940281a..8649b89d7bfd 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -127,12 +127,6 @@ static bool resctrl_is_mbm_enabled(void)
>   		resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID));
>   }
>   
> -static bool resctrl_is_mbm_event(int e)
> -{
> -	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> -		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> -}
> -
>   /*
>    * Trivial allocator for CLOSIDs. Use BITMAP APIs to manipulate a bitmap
>    * of free CLOSIDs.
> @@ -4020,8 +4014,10 @@ static void rdtgroup_setup_default(void)
>   static void domain_destroy_mon_state(struct rdt_mon_domain *d)
>   {
>   	bitmap_free(d->rmid_busy_llc);
> -	kfree(d->mbm_total);
> -	kfree(d->mbm_local);
> +	for (int i = 0; i < QOS_NUM_L3_MBM_EVENTS; i++) {

The for loop can be simplified by the new helper:

                 for_each_mbm_event_idx(i) {

> +		kfree(d->mbm_states[i]);
> +		d->mbm_states[i] = NULL;
> +	}
>   }
>   
>   void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
> @@ -4081,32 +4077,34 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>   static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain *d)
>   {
>   	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> -	size_t tsize;
> +	size_t tsize = sizeof(struct mbm_state);
> +	enum resctrl_event_id evt;
> +	int idx;
>   
>   	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
>   		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
>   		if (!d->rmid_busy_llc)
>   			return -ENOMEM;
>   	}
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -		tsize = sizeof(*d->mbm_total);
> -		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
> -		if (!d->mbm_total) {
> -			bitmap_free(d->rmid_busy_llc);
> -			return -ENOMEM;
> -		}
> -	}
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -		tsize = sizeof(*d->mbm_local);
> -		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
> -		if (!d->mbm_local) {
> -			bitmap_free(d->rmid_busy_llc);
> -			kfree(d->mbm_total);
> -			return -ENOMEM;
> -		}
> +
> +	for_each_mbm_event(evt) {
> +		if (!resctrl_is_mon_event_enabled(evt))
> +			continue;
> +		idx = MBM_STATE_IDX(evt);
> +		d->mbm_states[idx] = kcalloc(idx_limit, tsize, GFP_KERNEL);
> +		if (!d->mbm_states[idx])
> +			goto cleanup;
>   	}
>   
>   	return 0;
> +cleanup:
> +	bitmap_free(d->rmid_busy_llc);
> +	while (--idx >= 0) {
> +		kfree(d->mbm_states[idx]);
> +		d->mbm_states[idx] = NULL;
> +	}
> +
> +	return -ENOMEM;
>   }
>   
>   int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)

for_each_mbm_event() can simplified mbm_update() as well?

-        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-               mbm_update_one_event(r, d, closid, rmid, 
QOS_L3_MBM_TOTAL_EVENT_ID);
-
-        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-                mbm_update_one_event(r, d, closid, rmid, 
QOS_L3_MBM_LOCAL_EVENT_ID);
+        for_each_mbm_event_idx(evt) {
+                if (resctrl_is_mon_event_enabled(evt))
+                        mbm_update_one_event(r, d, closid, rmid, evt);

Thanks.

-Fenghua

