Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190941C6FFB
	for <patches@lists.linux.dev>; Wed, 21 May 2025 02:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747795346; cv=fail; b=Ain/7B4x6y2rMyD21Q0YusiGFtNEmRJpXImmDVCn9rcIbRnibmBynWzULl/12GHFUpWKWQQ84hAjmY54/3xW2i3iVF1p11XseNaH35Zrr2ACloHNrSfeD7+CErq78yX5cUlVXWQf4HNMlRI+bL5gi/HQoBJ27oAL3wfDuK4xtXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747795346; c=relaxed/simple;
	bh=VAjTh3T3o2qfL/2hHkCfhme4Ap5IWWJD+88ImerXFyo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M2GmqcEIjYfY7W9dYIZrDEsFS+rOGf+PWKMGDOfAisgp8lMOyecxcQilgzLzWaVtWAaLs8ZiemkwmBnlo7xfrOCqYYdH0wWKBe6Ee4iEMndwIqpQTC2l3L8TE3gbPuFvziCymL1m6k2+r2IsoUhOfX/hXZxZLYh6DQIiVEiW1Y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tZt82H6D; arc=fail smtp.client-ip=40.107.92.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tZt82H6D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZY17QOeFHmrKm1V/zHNSRPAya2KNixjWo6kOPATWnqdeSMyh9ivlT+UuKOPwlYMOkfIwFEG/8EWiSmTb8B3p4hpFWSzUuEsr7U5+G1NnFsOGAeOBRqNrbAPN/v1H9ur7O7jm4CD0uqtofF02pBT5wAU2vxQQDgzYo36AP+O9OSLEzV5YmIoIwCPYfouNfrE7CsUqoEmralIeBGakCR4yBdiYKdFa9e+ueJoNRHMKNbb2XI5pidGYvtNmyKyDVdY2XysW3UbkmVVwC3S5LmfmRQhBp9/LYallT6QjrCfdDNR/gsYB22o+Ssbe7GikCsjunlifcMM/h6sXxWr9DXwJ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44TtuONdK6P1DhyETh2fQGl+uVnU+lppvovmfub6UJM=;
 b=Idew9odSbJlGHjFzv00VKdKeYXmxVYex6MBXUPpDtD8DiQftB4lD2IIEe0RAF7evDC5qsJmAY+xlLKTi75Kbk6GTTLATr4wGB0qAHNiAgDPN6s3dBMinJ4R1uv3D1dkdQ4Wtdp2nziMFLtjgfl7GJ9RHasYnGA2X5luYPfE2luLBMFe//y7TvRD6GmFeA8SkdH4WtqxbZpOq2q/id1GM1in7hA1U1N9qu6k9vKPp7u+9GmkD7xOonUq3ADxx2uIDnUGLspCMvlrAwXDrO890NCaXZrHQHemZgbpqW073sSjpfkW9nx7N3z4Do24zDMdA1zITtUpX1/91Q0XDa2+eKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44TtuONdK6P1DhyETh2fQGl+uVnU+lppvovmfub6UJM=;
 b=tZt82H6DKClPN7KgLp4huJFqhpHMSfXddhwlhFa8a81HRtELJA8V1OP9vGotn4QpAL50eJf4+EKPwwKAaj3v/TZ6sBEgS7IwSRYdeOh6LPSDEuJ2t+z5PZ4Dq9QRlfVqiTWAIyRn876k7gXguWajhahg1VFQ0rGoVKArrCUqjU8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DS2PR12MB9592.namprd12.prod.outlook.com (2603:10b6:8:27c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 02:42:19 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:42:19 +0000
Message-ID: <c364e0d7-f3b2-484d-869b-095140e2537b@amd.com>
Date: Tue, 20 May 2025 21:42:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Eric Naim <dnaim@cachyos.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 David.Wu3@amd.com, alexander.deucher@amd.com
References: <20250520125810.535475500@linuxfoundation.org>
 <8db9b7cb-03ff-4aca-aafa-bcab4d1b5d82@cachyos.org>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <8db9b7cb-03ff-4aca-aafa-bcab4d1b5d82@cachyos.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:8:2f::17) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DS2PR12MB9592:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c01aacd-0581-4877-fc3e-08dd98111b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjZsYjhOWVJuN0FnSnp4WHBSUmppODVObnBJdmR3QzBPUDVFZVlrZmdtSUJF?=
 =?utf-8?B?cWRUMWI5VTZFTi9pZTlISFk1TElXdW8wUzhzSGJqcHMwQldlNzlLWGl1Y21G?=
 =?utf-8?B?T3NFMXJlRzFIYnpiYWp0RTlvRkpESTFzelNXVEVjbS9oT0JacGxiNDNyTWtR?=
 =?utf-8?B?Si9oSFJDeW1PRDVaaENzRnV5eFBqRWhodnhRcnFGQ2Rpb2svVy9pcHYrNWI5?=
 =?utf-8?B?MERkNEV4TmZLUlRSRWdSSmhRQlZ3WFFUcFVacHdNakU3bWVoa05uWFArNVht?=
 =?utf-8?B?YVhTZzdBZ2JyVHJKczJrRVYzcjhMQmE5cFh5REI1RTFJZXlxcUxUYUtEbjZ5?=
 =?utf-8?B?R2R4RDgwRFhtdEw3eFo4QmdWYmNCYkk1ajY1Zi9EZnZyL2dFS25WalNTdnJ4?=
 =?utf-8?B?cDRTdHdrOXhKQWVkdDRJYnRTSHNHVGZNQlhxQVZWbm4vNjJMZ3JwSHJDRGRx?=
 =?utf-8?B?WHVjaHJ0cVJuQ1AvNWIyRTBtd0tVMGpVcDdGSWNUTjl4VGR4S25hRnBMR1k5?=
 =?utf-8?B?NElhMTVGeTFrd0xoMzk0ZlBQVWtYMmlkWXZRRklpSFV2QkFLVEYvajFaUWF5?=
 =?utf-8?B?QUc3MW42VFJGMkJlS3l0bTVET0tVTnBtM29SNTVmbUZaalo5NE1IazZwR3Rh?=
 =?utf-8?B?YS82YTV4MDBFNEo4WXlRYUZqWnNJM3VmNmoraGNrNkI3aVRtcWQ0QUtDRXVI?=
 =?utf-8?B?UVFYTEtjZThjRjdPeE93QjU2VGxsN2U5S2xVZFUwWTU4dTFMbmpkVnZWd1ZW?=
 =?utf-8?B?NnA5cEFqQ0Y4ekRSZlY5Y3VFajFqZFFaTWYwTmtIVm9OaWlLMmRSVlFnMDlQ?=
 =?utf-8?B?dXlOQWJDc1JhN1d6a0FKVkh5MjVGemNDcmdGYUdSd2NoK3BVNWhaWlFnV0Zx?=
 =?utf-8?B?c3ROOTNSMDZUQ0lBVDBlK1dKNkxpK3RqU1E0NDRXcWZxbUF1WE03NHF1MVNz?=
 =?utf-8?B?QXNudXBSa2VNdllDNUFrWThaMzVlUUtaU0QvQXdyT2orY3pxRnJRdkxFSnZn?=
 =?utf-8?B?UitZTTlRMFZ0U2hnRkYzMUtJUUxXNEFjRFVCTzVpN1ZYS2JOUU1heFE2Mng0?=
 =?utf-8?B?aEpDaEFYenpKTDQrWWxydHRaYlZudjJGZUZKZjBSTnVPRE1VUW1QaE9wdzgx?=
 =?utf-8?B?bkc3SGhUaVAvTVJaQXFBaGI4QnN0R0ZXM0lWbUVJd1VvSjdEU29XT1VRc29h?=
 =?utf-8?B?OUFubmcwYjZsQ01iMSs5K2trN0M3bkJWb3oyWmNtaVB0QUt1djBOcWFWd25u?=
 =?utf-8?B?SlJJWnUvYVM3azdLeDZob0dDZ2lKb29ZcVNYMmFySVFLd2FnR0xRMzc0ek94?=
 =?utf-8?B?Q0luRWhlYjFJSnk3K2tzSnBKdzF3VG5nd2ZsRjd2WGZXR0xubm1nWTE2b2tN?=
 =?utf-8?B?eU5YYStVb3M2RlpFd1BLeVhnZlJ3WU1FNkpURWxldFFKRlRmNGlLYVVOQ2VB?=
 =?utf-8?B?Kzg4UlVuRHdZU3hHN2lHUGMwbklRNDBYeGgvMGRiRTBtaGRXazNNMXVBc0xR?=
 =?utf-8?B?N3k4MkZJNXVBT2ZDMWlMSHdPK0ZOU3F3UGpXQ05hRkhuZUFJNHhyaGVBczk3?=
 =?utf-8?B?cFFhMkp6Yjl2TUJKYWNhSU1vVndiQ0VabXRyTFo3a05ReGw1dnJmSVpoZEVm?=
 =?utf-8?B?Mk1OVXFDTzZmSFRtSFBGV1ROVk9VM2hDUjc5MHJZWlk4T25UN0FzR2Q5aDRP?=
 =?utf-8?B?Y2I3a2pPUkd2dUFIQmlwalNTQ1VRWVRhSEZNREwzcGFESnR1MXJuTzF3YWU2?=
 =?utf-8?B?VEhoNW1ZaFlZYmlLNGdEOG05RExlVTZ2OThHdnovcUFQWUttdk5BMm5WZ1hX?=
 =?utf-8?Q?VNkYs4+oMvubUBnuwCjU0UwyzsX/NowWfi4bg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tmh1WUQ2RTFRUWVmNk0vVXV1N2RKbjBySnBWMldPajduWVBtVEZ4TENUR1lM?=
 =?utf-8?B?T3JiRHRQMmlhVFl4YlRwdmxMSmVxbzNxNE9EN0hDMFFEVWExNThucWdseXpT?=
 =?utf-8?B?UDZVeVVwVXA0QVlyNUNCSHczM242SWl3NUI2YXQxRDVZMlVhOXh2MXRrWGw1?=
 =?utf-8?B?ZkZ3V250V3gwOGpGbWRzbjBDWEI5emhWRG55THloZ29YUFYyZnRFSXBNTlJZ?=
 =?utf-8?B?OHVLc1F6UTZmNGpXNXJwZU84TjhFZzVhU2Y4aGFFeHhBVm5LQ2FjcXovdGE0?=
 =?utf-8?B?NzM0eDI0WmpoUW04Wk5YZkh1c3BONzRmNkoxcUcwNWtDTStReEtDakh3TXZS?=
 =?utf-8?B?R0F4cTcxNGJDSTQ2cm8wWlUvRER2K3pCVDFrTmFKUEVmY1hLa3QvZytTVWJB?=
 =?utf-8?B?MHdQaVdiMFQ5azJxaGtBOElkV0hEMEVOUjU4eEJzMWdhNTF0T05aRjRoUDFo?=
 =?utf-8?B?NG9wSDNBOWFwdEd0aXgvcVNDUW9RVVFoMXFXaWdmTjIyZHpZSitnUHpGN25S?=
 =?utf-8?B?Nll6dDBwaGRhTi9qNnpqWGtPeDdGbXYwamo0QUlBWnUxbDN6YjFqejhKbUFn?=
 =?utf-8?B?WHFCQWlCSHcyV21NUzhaeWk2Yk1kN2RXb21reWhrWU13bE9jamZzOW4zOVov?=
 =?utf-8?B?a2pLN1V0SStSZlFKZGZsbzhOeW5nK1RjZ2JQNFZObXlhTUN3emc3clAwL2pM?=
 =?utf-8?B?R3JnUko4ZjF6L0Yzc3JjOFVWYXJsM3l3bENCZ0JzeEVhU1ZCVG1Nd3JrUnlT?=
 =?utf-8?B?UDdUc3hQby8waVU2b09zVHc2U2RlRUtnSEFBeFBkazB6V0NsVExMY2FGTzJZ?=
 =?utf-8?B?ZnRJME9EU3V6RGtwR3dlZEh3Y241b3dhWGcvdGw4YzFMY2FmYW9mLzhMcGpU?=
 =?utf-8?B?QnRGS29DUDN6UCtLTkw1YitmQWd5NVpodkFUdGVVSGNYamwrL09pZWhkS293?=
 =?utf-8?B?UXpGelZFUGtGS2FBTjJnUUJSQTZRdlN6K3I1R1BMVmVLMVM3ejIvSzJaeENK?=
 =?utf-8?B?MSs1UWhCM2VTbmFDWmJ3VW5oK1RjcmJ5TGJOcENwZVlEYlkvR1R5YW1TVmpk?=
 =?utf-8?B?aUtIeEtwcDJNK1l3LzZOWDVXOVRDYkFoZFN4ZFZFZERWcnhsQjRTaVRFZDBG?=
 =?utf-8?B?TTJvbEZ4QWlTNXhsNUE1SDE4b1Z5V0JiUnRnV2hYMUlCTVRSVzRLSDJyZmU3?=
 =?utf-8?B?S25DdWhRWiszYjBLSGl4RnN4SnQzeFlpVVpMN2xZOUdOSytVMjlUUVNraGNu?=
 =?utf-8?B?dGd3MkY1Tm9wSGVCK2xpMWxXUVMrcG5jc1lObVJUMTl1ajRTamhyUFRXTjlD?=
 =?utf-8?B?eERaZU9rV2dFTVR1Q2hrRDdsbWEzVVpzV1hPOXRRUVVKY3paU0VGVWhhKy9i?=
 =?utf-8?B?SVlMaHhDLzdCRUFBOEJIVzUvcmM0cHVibEpXb0JvekJMdGFpb1o5QVI0RWpT?=
 =?utf-8?B?MGViM1YvRCtQalhaZ1lnV3lFMHBaUVlyUE9FZmN6aVE1RVJyNjVSazJ2VUl3?=
 =?utf-8?B?UkoyUzN4YzFFcmpuUkIrOHYwaElKcFpreHpONmUrbGVKZWZVUDU0cnBRd0Fl?=
 =?utf-8?B?a0dpTG5QWUc4OTNKNmZINVZLZjNmNUxFMm1nQk1oM3h4WHg4SGtOUGxLcmdh?=
 =?utf-8?B?VjNYdC9sOFliZU1yQmU2RFpOS2tCdVozUzh1UHcxaGUrMGZoNlREc0dkK0lT?=
 =?utf-8?B?SnRrS0Y4WE13dlJMdnNNUXhWUEZZTmlCREdtL2lLNFJ1VEMvYktrQXVaY0hL?=
 =?utf-8?B?OWxqL1lmckFhSHBBOWluVkNVUE9uZjFlVlAyRi9ZZGh4MnR6L1VJdDYwQkFS?=
 =?utf-8?B?NGh5aVJiT0xhY21jNW9vOE0vR1FnajU0NnNiY1BVdUdqVFplaWlhblErSnRX?=
 =?utf-8?B?Nzh1TXpDQ0FqaTNhdEx3SmxMd1B0NDN4Q205QjJwVUFSZG85WFE3NzY0ODdG?=
 =?utf-8?B?MUxGZ1FPREUzdE5LbnZ3bDVQTHlOS08yaXU3Z1l3blRUOXM1eXJaams0cnhm?=
 =?utf-8?B?V0lrdlcvWXNMK1RMcFJlaWVnc2doVzFHbEVBVmV2NG5QZUpnNEVwVUszdGtl?=
 =?utf-8?B?N2VDMFNRRXBLc09mTWd0RHh6RWlva2tWZHRsYUt3SU9yYkU4aUhuYjQwV2VR?=
 =?utf-8?Q?Q0yeJmrahmvXGO85V5J/diFjw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c01aacd-0581-4877-fc3e-08dd98111b46
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 02:42:19.7605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hn/RZAhVzC/UTtHoZ8BsBRrLDHvwid5EXJ+FJWqtWprga2bxGtEBAh6TiKTCl2kM1W0Mxz0izuUnp5mQ4cZ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9592

On 5/20/2025 4:34 PM, Eric Naim wrote:
> Hi Greg,
> 
> On 5/20/25 21:49, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.14.8 release.
>> There are 145 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.8-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Linux 6.14.8-rc1
>>
>> Dan Carpenter <dan.carpenter@linaro.org>
>>      phy: tegra: xusb: remove a stray unlock
>>
>> Tiezhu Yang <yangtiezhu@loongson.cn>
>>      perf tools: Fix build error for LoongArch
>>
>> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>      mm/page_alloc: fix race condition in unaccepted memory handling
>>
>> Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>>      drm/xe/gsc: do not flush the GSC worker from the reset path
>>
>> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>>      accel/ivpu: Flush pending jobs of device's workqueues
>>
>> Karol Wachowski <karol.wachowski@intel.com>
>>      accel/ivpu: Fix missing MMU events if file_priv is unbound
>>
>> Karol Wachowski <karol.wachowski@intel.com>
>>      accel/ivpu: Fix missing MMU events from reserved SSID
>>
>> Karol Wachowski <karol.wachowski@intel.com>
>>      accel/ivpu: Move parts of MMU event IRQ handling to thread handler
>>
>> Karol Wachowski <karol.wachowski@intel.com>
>>      accel/ivpu: Dump only first MMU fault from single context
>>
>> Maciej Falkowski <maciej.falkowski@linux.intel.com>
>>      accel/ivpu: Use workqueue for IRQ handling
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: Refactor remove call with idxd_cleanup() helper
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: fix memory leak in error handling path of idxd_alloc
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: Add missing cleanups in cleanup internals
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: Add missing cleanup for early error out in idxd_setup_internals
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
>>
>> Shuai Xue <xueshuai@linux.alibaba.com>
>>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_wqs
>>
>> Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
>>      dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
>>
>> Ronald Wahl <ronald.wahl@legrand.com>
>>      dmaengine: ti: k3-udma: Add missing locking
>>
>> Barry Song <baohua@kernel.org>
>>      mm: userfaultfd: correct dirty flags set for both present and swap pte
>>
>> Wupeng Ma <mawupeng1@huawei.com>
>>      mm: hugetlb: fix incorrect fallback for subpool
>>
>> hexue <xue01.he@samsung.com>
>>      io_uring/uring_cmd: fix hybrid polling initialization issue
>>
>> Jens Axboe <axboe@kernel.dk>
>>      io_uring/memmap: don't use page_address() on a highmem page
>>
>> Nathan Chancellor <nathan@kernel.org>
>>      net: qede: Initialize qede_ll_ops with designated initializer
>>
>> Steven Rostedt <rostedt@goodmis.org>
>>      ring-buffer: Fix persistent buffer when commit page is the reader page
>>
>> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>>      wifi: mt76: mt7925: fix missing hdr_trans_tlv command for broadcast wtbl
>>
>> Fedor Pchelkin <pchelkin@ispras.ru>
>>      wifi: mt76: disable napi on driver removal
>>
>> Jarkko Sakkinen <jarkko@kernel.org>
>>      tpm: Mask TPM RC in tpm2_start_auth_session()
>>
>> Aaron Kling <webgeek1234@gmail.com>
>>      spi: tegra114: Use value to check for invalid delays
>>
>> Jethro Donaldson <devel@jro.nz>
>>      smb: client: fix memory leak during error handling for POSIX mkdir
>>
>> Steve Siwinski <ssiwinski@atto.com>
>>      scsi: sd_zbc: block: Respect bio vector limits for REPORT ZONES buffer
>>
>> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>>      phy: renesas: rcar-gen3-usb2: Set timing registers only once
>>
>> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>>      phy: renesas: rcar-gen3-usb2: Fix role detection on unbind/bind
>>
>> Oleksij Rempel <o.rempel@pengutronix.de>
>>      net: phy: micrel: remove KSZ9477 EEE quirks now handled by phylink
>>
>> Oleksij Rempel <o.rempel@pengutronix.de>
>>      net: dsa: microchip: let phylink manage PHY EEE configuration on KSZ switches
>>
>> Ma Ke <make24@iscas.ac.cn>
>>      phy: Fix error handling in tegra_xusb_port_init
>>
>> Wayne Chang <waynec@nvidia.com>
>>      phy: tegra: xusb: Use a bitmask for UTMI pad power state tracking
>>
>> Steven Rostedt <rostedt@goodmis.org>
>>      tracing: samples: Initialize trace_array_printk() with the correct function
>>
>> Ashish Kalra <ashish.kalra@amd.com>
>>      x86/sev: Make sure pages are not skipped during kdump
>>
>> Ashish Kalra <ashish.kalra@amd.com>
>>      x86/sev: Do not touch VMSA pages during SNP guest memory kdump
>>
>> pengdonglin <pengdonglin@xiaomi.com>
>>      ftrace: Fix preemption accounting for stacktrace filter command
>>
>> pengdonglin <pengdonglin@xiaomi.com>
>>      ftrace: Fix preemption accounting for stacktrace trigger command
>>
>> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>      i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
>>
>> Nathan Chancellor <nathan@kernel.org>
>>      kbuild: Disable -Wdefault-const-init-unsafe
>>
>> Michael Kelley <mhklinux@outlook.com>
>>      Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()
>>
>> Michael Kelley <mhklinux@outlook.com>
>>      Drivers: hv: Allow vmbus_sendpacket_mpb_desc() to create multiple ranges
>>
>> Michael Kelley <mhklinux@outlook.com>
>>      hv_netvsc: Remove rmsg_pgcnt
>>
>> Michael Kelley <mhklinux@outlook.com>
>>      hv_netvsc: Preserve contiguous PFN grouping in the page buffer array
>>
>> Michael Kelley <mhklinux@outlook.com>
>>      hv_netvsc: Use vmbus_sendpacket_mpb_desc() to send VMBus messages
>>
>> Dragan Simic <dsimic@manjaro.org>
>>      arm64: dts: rockchip: Remove overdrive-mode OPPs from RK3588J SoC dtsi
>>
>> Sam Edwards <cfsworks@gmail.com>
>>      arm64: dts: rockchip: Allow Turing RK1 cooling fan to spin down
>>
>> Christian Hewitt <christianshewitt@gmail.com>
>>      arm64: dts: amlogic: dreambox: fix missing clkc_audio node
>>
>> Hyejeong Choi <hjeong.choi@samsung.com>
>>      dma-buf: insert memory barrier before updating num_fences
>>
>> Nicolas Chauvet <kwizart@gmail.com>
>>      ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
>>
>> Christian Heusel <christian@heusel.eu>
>>      ALSA: usb-audio: Add sample rate quirk for Audioengine D1
>>
>> Wentao Liang <vulab@iscas.ac.cn>
>>      ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
>>
>> Jeremy Linton <jeremy.linton@arm.com>
>>      ACPI: PPTT: Fix processor subtable walk
>>
>> Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
>>      gpio: pca953x: fix IRQ storm on system wake up
>>
>> Alexey Makhalov <alexey.makhalov@broadcom.com>
>>      MAINTAINERS: Update Alexey Makhalov's email address
>>
>> Wayne Lin <Wayne.Lin@amd.com>
>>      drm/amd/display: Avoid flooding unnecessary info messages
>>
>> Wayne Lin <Wayne.Lin@amd.com>
>>      drm/amd/display: Correct the reply value when AUX write incomplete
>>
>> Philip Yang <Philip.Yang@amd.com>
>>      drm/amdgpu: csa unmap use uninterruptible lock
>>
>> Tim Huang <tim.huang@amd.com>
>>      drm/amdgpu: fix incorrect MALL size for GFX1151
>>
>> David (Ming Qiang) Wu <David.Wu3@amd.com>
>>      drm/amdgpu: read back register after written for VCN v4.0.5
>>
> 
> This commit seems to breaking a couple of devices with the Phoenix APU, most notably the Ryzen AI chips. Note that this commit in mainline seems to work as intended, and after doing a little bit of digging, [1] landed in 6.15 and so this cherrypick may not be so trivial after all. Attached is a kernel trace highlighting the breakage caused by this commit, along with [2] for the full log.
> 
> Also adding Alex, David and Mario to Ccs.
> 

Just a minor correction - VCN 4.0.5 is on Strix.  So this report is not 
likely from a Phoenix APU.

Nonetheless I agree; I suspect backporting 
ecc9ab4e924b7eb9e2c4a668162aaa1d9d60d08c will help the issue.


