Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E04158524;
	Wed, 28 Aug 2024 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724827072; cv=fail; b=cp5IwsNopZigEsQAkkR9/w4qS1qV/9R1XIPiKQ9mi3VUzaNgiCG69M5xUJYKSmwEkiVQiAq1FRYw2NvPckTUO04bdxAJoQcZgO4CoqIgkSoiJk/r7ku19m6kLxF1b+ibj6ZbKoB9Wl8Z8+0vLHvSSq2MKdOqNcxBrM82AyfDjqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724827072; c=relaxed/simple;
	bh=teEtDpE54dN6kDWGoXLtog+r49+v4aJppCyXFLW+rEc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tgRd06B9IRNGGfUGh2z9xiDfs3DOhCfDQqrfw2Gw+DQRNI4294CM1YDTnPF0+AU9U7IFEP3v93sMYfidADl+wkeEovFn/2IOKcrRqscASjldc7yINiIur8MnkzADbm6Zsyhn1xKIlG2DhgZW35uMqt1W4Ji1Kgs93lDRt7qOrM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fOsZgcw0; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fOsZgcw0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLOznIX7qvKELH0IxRSzZW8Sj97WrUYEfVV+u/NHliCgq0diIzMNwZwchCWYHnsYvEnx1yV6quKU+83PvXIyta2AaanDDV+Kem8zTAgwDSx38OiwpeEvcaPuQvV6U4vDIl7w1+7nSqbccC8avH2KLTcpj3eXc8Fp1Es/vls8HoKldJctXtl79IOeFQuWZ/wArCQpYxSbFjg57NeBrEhDb5bDcexi4RYhbv7oMVTPFllogOIBqUm4AtS3HwaBo8KfzfreaR7+VpALT6RkrcngwC6rJJs2PybSfNqJAf+++GXlyt7OCCQfSMjJk3ky8lhrX2uU4ClY/m1pW9v5zujlJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUZVyaG/qEL+uRKX1wcq4aPw5QGH3RLhTAY/zzplgUE=;
 b=FdOyfn9xU2BQtnR5ijc629EQCnwHDPkMLgHr9350i9ubsMxBpTYDDN0ZvFKOk2vSFEquUuo90S7Kjm7zVI/9mxCXyMTpE5eDQDIobMOEQH+mTLQQZYahhQIcqaqbVhcTqfHCi6t4I08KzewptRqn90lQltVKea5gtQFQmYQPgRyof3afeAVpIg4w3TbG92UQI4OjDVa0lue/bUskqh7ShD0vzhDgDHqlmt4bOgKmjmwtTdcVrLZU6AkaQny0IowilmS+xo691grF5EDUL+/MbW+Q3hnOIzjvZxgNtqQinJZtWddVLl5wfGdBOEokg60/qKBVkzLWvHIMU7J56sT1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUZVyaG/qEL+uRKX1wcq4aPw5QGH3RLhTAY/zzplgUE=;
 b=fOsZgcw0jZ3D/zADeK0b0YeefAr0Tjn13LHvSyW5f0cyBlrYSLC1QXNzj4FAj2PBAAwhfVmlZJb9jjvR5yOmPkcu3rk3h4wHMhB+ctvPJ7j3uN4ie/uIZfg7v/sQiogJTHaxSRCgPR50rhIpzNKmAerVriiCuakOaiBcN0P3zVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.26; Wed, 28 Aug 2024 06:37:46 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:37:46 +0000
Message-ID: <ece21189-b680-4def-92f8-00df735f802c@amd.com>
Date: Wed, 28 Aug 2024 12:07:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] iommu/amd: Remove amd_io_pgtable::pgtbl_cfg
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <7-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <7-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0184.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::8) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5666ad-e3da-45c0-0006-08dcc72bed54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDRQeEdWSXEwU0U1RGFGQ0N3YXJrOEZMbUlwTURHZ2ZWaWNueklacS9GdkJS?=
 =?utf-8?B?ZUhpcG5PVEVrZlV1T1N3Sy94RGVKWk42NStpczYyK0lHc2N4WFMvcEVSNDVP?=
 =?utf-8?B?LzRjV1ZCVkhJRWthdmh6UFcyUE9kdDhiZEh5QWtLOFZ2Und1N0xRU0FEVHZY?=
 =?utf-8?B?d3d0Z01GNVl2MTJEV3FvcUxHcDV5YWxBMURlMG0zelpJZ2ZkeTZJb1Rkc0Zj?=
 =?utf-8?B?N0RMM0Qyd0NyOU5ORCt4aWd5QUVNYXhUY2Q3OVdtU2VUbXRBS3Z6dUFmak5j?=
 =?utf-8?B?dlUxbUZpWE9rd0xreVpBZEdJQ3NIOVdNYitydWVsbzRJbWlscklSci80M2lm?=
 =?utf-8?B?YTVOa0VFWGcvZVljMEVyMFFmNUtWNzNhMTdKRytMWUwzV0lxV3RoVHpSYXNk?=
 =?utf-8?B?ZmFYOW04VVYvcVNjNTI5N2MwaExkR0JSeHc0YVNCNGdWZElEbmUrTU5sTWNC?=
 =?utf-8?B?SVE1QXUycjJXZzNQZVh5MnA5WFIvRHNJeFN6aHpEYVIvTS9IQmN6YXk1NlEz?=
 =?utf-8?B?ZnZaVW5FbjZjNExyZmZ2OVpRY0ZzdWFwMm04L2ZxbFhnQVF5NlE1MkZqTmNZ?=
 =?utf-8?B?NGRoZFEwVWdNSTJxZFI5em9aMFdPT0NzMmtqSDEybm5kNGRRbEtOQTk2dG9L?=
 =?utf-8?B?TEZwQzI2RHpRMndFQldGTDBmUVR3MCttM1NBTWRPNW9idTU5YWwybjloR1Jq?=
 =?utf-8?B?TW16WDZ4RUVhM0czWVM1UnA3TGtHaGxjRG1SWTIvdW8rVjU2ejRGUnd0M0sz?=
 =?utf-8?B?dlhmeCtqaStNbyt3YWNoeTZDOVlNa0s4enovTDR6WFEvWXllRk1MWXY2Lzkv?=
 =?utf-8?B?ZmlEWVJEZjJGaXd3MVJTbGlLdk5uNUtXNk1VYUNBTG9iWW1BdEdYM0tyN2pa?=
 =?utf-8?B?Q1ZDUjJ6cWdwZnNGcFkvZ2JiN2NCbjdTSmZMV0toRVphU2NKa0hxdlQ2cmRo?=
 =?utf-8?B?RU4zOWd3NG50ZkV1SVZObFJwYkpNQTRWZmNZekhtQXAzblNjaktkYXpycVZ1?=
 =?utf-8?B?QVB3czBOaGJybkRmb1VtVzhWS3hxM1U0SDhCSCtuR0ZKUFlBc1dwek1xeEQx?=
 =?utf-8?B?NEcvc0VXMUJvQmRkb3ZrdXNydGh5aTRDK2N6OWJvZnBEK2xXQW9QVFBlUURh?=
 =?utf-8?B?OTNNeURFYzlPVFAyMVJFbDJmczgxeHg2R1pBT1ZDTm1QaEh2NDhFYjlmejFt?=
 =?utf-8?B?dWlra2dKOWVMZmtqSUExY1R0ZHF1SzFXNHAzNTNhdmVGNXo4LzlhZjd0UTIy?=
 =?utf-8?B?eUdIMXFZT3hicUJLRGl1cmttM3pyNWVvMUplR3VacTNIcGcvTVVFYlZKaGVF?=
 =?utf-8?B?VHVKWXdNMDFBTXJ4ZS9SUEt4NThEZ2JNcWxPU3ZtdU9HV3V1TWZsTDdHVmFD?=
 =?utf-8?B?emY2T3ZjMEN2R2djaGVFSGJ6d0w3S283R0xrNGk5NVZRb1Y5c2lLNjhGRVlH?=
 =?utf-8?B?Q3dkSVhlcGwyNDNSRXJ3T2RHb21pNzY4Z1cwWDBNdkVzL3NPNjVvKzRvMWJy?=
 =?utf-8?B?VVM3aHdteVpuTS8vMEY2dWZrb2JPeTdxTkdMTFFyajhabCtLZ0g0RDEzNEdV?=
 =?utf-8?B?L291OHZHWWFLQ0tpdlN3ZGtMSGVRdXdPcTMrVG5QcUtDVUhqTkkvZHFzTTVj?=
 =?utf-8?B?TEtxdEY4WUZWRUNIRjFHOE9hcGVsY2MrWWVMQTIzVFZBWHNIc2swN2tzczBP?=
 =?utf-8?B?emhoUGlIUU10Zzl2ZW5QcElNdWtRUGR4U1dIODVjT0Z3N01PVytJb280cjF4?=
 =?utf-8?B?bVBHTE0rSFZvd0dMNFRxRmFlcFBGc1dLcVp6NDhuN3J6SXJrcmF4QVNocU9G?=
 =?utf-8?B?YmVlWkdOOVcyOXR0Y2wrQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3Y5Z0tzclczNTFSREV4bGkvS3JDLzUzWHRpRXgyNHdnZVNSVkV5dThmeG14?=
 =?utf-8?B?NmhsYk5FR1Z6enc0ZkRpQVNGY2hkK0xVZXRGNEhzcmxvMG8weGpHRTNVa3Nq?=
 =?utf-8?B?c1N1aGFQWUNHQnYyVURBMTk1SGMwODk5Y21ldmFnb0RLU1hmbEZFMEJZREpt?=
 =?utf-8?B?VGowdVF1SnFGY1EvTVVKQzVvNnp1UzUwc3ptaUhjekUrWHlvRFl3b0VvMytl?=
 =?utf-8?B?WFZmM3lvc1oyamVaQlo5UXliZEw0S0hNdFZCSFJGRy9SMUZJdXI4akRmZE41?=
 =?utf-8?B?bEpTZmRPU1luM1FzR3VFOFNQR0FFWDJJRG5OYS8wZTdMbHdqYktCVGlWS2dv?=
 =?utf-8?B?cUdVOE1NQjQyYlovUDRkRisyVDZnbnBmNlhQcFpGVk9PcjkyTWZmbnNvTG5G?=
 =?utf-8?B?RHZ4dHdCaW9YRTBjdDNKVzZia1dGQy9RbXB1akQyN3N4QmxqbnJHNHd5Z01B?=
 =?utf-8?B?SllhSFRrRVRhMXkrVXVMNlVGS2tIaUZOV3Vmc0lxY0tMRmlibGxwS0xUZWM3?=
 =?utf-8?B?Wlo4SlN4RW4xUllyZTF4bmRRSUxmVGpNak1yWlpQbW05YnJmb1I3aEh2c2Zk?=
 =?utf-8?B?dWp0UGU5eStyeVRCMDBvM3hidkMrTUJmdUJObDRXOUJBQytCQWJYQnE1bTA2?=
 =?utf-8?B?ZUdIWk05U0tKQWJLQ25WZG5wOGlHQ0loTWZOYlR1cjlIWEJKOGRzc1cvaVE2?=
 =?utf-8?B?VjlCKzJtbUFiUnNwOFY2MWRRd21xeERuUWNpb1hlcVowWDBtQis3Qk16V2JD?=
 =?utf-8?B?R3dzcDdzeW4xeFJ6ZlNPcUNHclRYS0dnYmF6d1R3cjJyeHMySVk1aVdSQ1Bq?=
 =?utf-8?B?Y0cyRHdlWTRrcXBLRDU3QUFudmgxS3ExTlZocVVJWElscERJWjgvTHYzUlZL?=
 =?utf-8?B?MTlpSGFUc1lnV1V2VjJtMklPdFdhbW5vck9mUzRGOXdxQ09lL3R2c3VIcHZX?=
 =?utf-8?B?b21NVkN1ZXpvM0J5c3ZNVmNJWEZaWSthN20xK0QydFFmek5hV2xyamRROGx2?=
 =?utf-8?B?bVdNTGtSVU1oL1FqQmQ2UHhWVUJaUjRnaTRPZHprZTR2M3R1V0dHVEJYUUZM?=
 =?utf-8?B?cjUzc1hWTUUzSXJLRFlDemEwbk9pa3IvWG9HWmNkbGZRREZsQ1pwcHhIbURD?=
 =?utf-8?B?dGpxN2h2T0tHZnpXdU1wdTFRL3dvbDJsL2p6RElpN2s2QVlCUmhFNndsVkZN?=
 =?utf-8?B?WnA2RzlGTFk2dWwrKzk5ajdENHBiYVVKUGQ1SWNBVkF6WkhXTVRNRmtxeHhq?=
 =?utf-8?B?TTNCNDhzdHBQdktSS3djS0wvU1FKUHBydllrZk1IcTEvS1pLNXlhVVpSR2xN?=
 =?utf-8?B?K1dDMkIzeExsSGg5aXdhczNJZzRwM3FQMW5ld1Z0Y0dUY3RXeFlRQ2lSMk84?=
 =?utf-8?B?dXMxU1A4Sk4zRjdodC9md29ZUkUvamNPR1RJcFRTdDNCckxtVDdETjRNY1JL?=
 =?utf-8?B?NGNnK1EvdnVGYklGYkN1K3hYbTk2dDhzay9kN2hWdjNYR3VBVUZjdldWNEhT?=
 =?utf-8?B?dlhYQkpjNjJBZURIcFBKQVg0bEdkRTNYaXdpcjI2MGdKdzFobzE4b3pNUEtV?=
 =?utf-8?B?dTh5QUtyeEg4Wm85dmRuSjQ2UzNVRmhPUzZPclFKRVdHUk13bnpDcW8zTjNh?=
 =?utf-8?B?SDQ5a29qRXlHRzNpYjJRQkFmTVNlK0ZXRnRlK0ZnekJZazZJMVFVZTMwRjFn?=
 =?utf-8?B?cHZKQ1VEWjRwU1VvdFRrTVdoZk1IMTFVNFlGTXFqdnpxUG1rUmZJaE8zUmJD?=
 =?utf-8?B?ajRoRmlPTG0rQStmTEFnMUt4OHl0V1pTdFBvdmVpTHQweEw1OWYvR3l5ZE8w?=
 =?utf-8?B?K2hhbFN4ZHdFUEdiUmVZeUVDV3RIWklWbHNzM3ZMWTdSWFJQT3dmNExOczJW?=
 =?utf-8?B?cUpuaVZCKzFMbDBQUjR0dWZ3ZDE2YXlGQmNhNTczR1BKVzdFeFh0U2pFTmlw?=
 =?utf-8?B?N2xHM1ZsQnptayt5eGNFNGlnSkx3NFFCTUxCQ3d6ZFRXdlNPc0o3MXBjR1lD?=
 =?utf-8?B?SXlGc1R5ZUV0M1c0STBSRXU2b1pCRkdxYmx0TlVBYkZjTTZYM0hFV0dNcVBy?=
 =?utf-8?B?cE03eUVOdHZFVWh6UU5Rckw1ZDBJZE9vd3hwWUNNYW4xVHl2enhqS2RDTjZZ?=
 =?utf-8?Q?IGdNvDa+zStEh9fCTQpKrusuA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5666ad-e3da-45c0-0006-08dcc72bed54
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:37:46.2291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xf4k4gtLeWEVDB96G4uIkQG4O8bn3fbhzaVsDe6EIcMYymfU+Y4m48ht8+md4eOHCCr+4MZgFuZg47eRj57pOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> This struct is already in iop.cfg, we don't need two.
> 
> AMD is using this API sort of wrong, the cfg is supposed to be passed in
> and then the allocation function will allocate ops memory and copy the
> passed config into the new memory. Keep it kind of wrong and pass in the
> cfg memory that is already part of the pagetable struct.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant
	
