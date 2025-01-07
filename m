Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE78198E78;
	Tue,  7 Jan 2025 10:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736247122; cv=fail; b=m55uCEeEwgSG7eEUb4/fVeFTZAHfrh9VH3l8KOlfiGwL3wIUR6arxSsKP8emgL02AbLjW+e2vi+i+anFl3y2pHS85pnqE4qzK9REWFGGzWf3DrEaQfOhvGeWgXPIxup8ZYy5oXX3TwOrdTLRHz/pyFutVLoPH4IuoG5bZpC0+MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736247122; c=relaxed/simple;
	bh=aq4gmCnbZUGSSf3wOMdU7lVva5b4uT9hP3AZVv0HNhE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F1PWidQaevQx2ieZy93+Q0xsFNaf915LSrABOQC50BF/C3++Yv845P2QEDTjVC0GHevz1WxMa9ZFg28r6NGAXT4PdyceWwla3yypPeeiSsd9iHjgXxGUSaW8EwoBYXhFDg9eruj+fbix9L/yfKtttB/8keizGVkfo794tf6XoJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AI1VuNJ7; arc=fail smtp.client-ip=40.107.236.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AI1VuNJ7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sy8tJzDl9e2wNmr22SyLyJ6S0HTE5DVYFu/ZIAESj8DjUn7wDlpEYrxAPSmmsg9YqT5g3JEcRx8LnGnJGVA35Cu9HgvZq5ThwqIDVMn3K2eFpFSNZpHGbWK2eXLcdER9GYQ5OydieqPyG9gQzaT93wuFfRqzViVW0gyXk+4E3KyQmMNSmS5kq6cOFwQh46Te2O0oRHav/n+/fjpHLLUJlB9UqUNEHUh83oRwmLutawSU5F1xft0kA3f4XAF+wap/dtLC4C50hMZJ4yEHKJTxe/1q/M/VZq+P2TfKa2Ffq18Q07m/npecs+O+03g6RvOq5IzWFQst82sWsfJDeCcWpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9iV3PHxccZ5uh0jXZdP2pG3cQybVFm3lHiSeqWjcQQ=;
 b=o9s1iTODDrEofUAdEU6tFW5gCeydgkTsUlNQMGFKEvp4zgb0RUFMH/JT2Ek9KpgASnQsRyEDas9uP2jFkPS5VRpU4IsrS757LCmFVXNP6SkcUlebmU0uxUA7OeJvx3a4oKGv1P5+WFDNfloB+iSVHH0iHdMvZPzZcKP5nbOvHW6j29ik9m/ZiRr3lTZlT/uaMHHR4X4difIMwJkF9IHA/A/Frh0iclTug+3bg+I6Ct0rvmArBy3xZUHqnPEVGzpTolw3gP6/fyC3uKSaNFw0heH6m7c03asy5vrhuoJbUCHEL6/gPeNnU9Nuv0fGKI31cHx40usHsu6qkCGF1c77yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9iV3PHxccZ5uh0jXZdP2pG3cQybVFm3lHiSeqWjcQQ=;
 b=AI1VuNJ7X+yVZEZU8A2JL3Sw5+STA2BJc7XfJuTARHdkkoVbEIEvPssZTf+EesOHLzytdYosqYJatbifEoZMtuW1NiIE/m8rzCEtTN7ExJNiz/UhK4iYlUEHQcKuY1zXVKeePJk41MSDptWn6ifuz2kDkg1Yt4HKxgb/+3ffZjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB9447.namprd12.prod.outlook.com (2603:10b6:8:1b4::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Tue, 7 Jan 2025 10:51:52 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8335.011; Tue, 7 Jan 2025
 10:51:52 +0000
Message-ID: <405afb37-8e8c-4abe-87b0-df2ed83d8ef3@amd.com>
Date: Tue, 7 Jan 2025 16:21:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] iommu/amd: Cleanup some of the domain_alloc_paging
 path
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0225.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::20) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB9447:EE_
X-MS-Office365-Filtering-Correlation-Id: b92a7233-2768-47f9-e627-08dd2f094b57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0hQWWNTRE0vY0YvYzNyS0tNWlFYRExuNzJhS3Fic1NNMzVnVENUV1duTU12?=
 =?utf-8?B?cFRwWFVOL3RNbmVVQUkwOXVCSHVnbHNmelF1V3dzdlRlZlZtZTF4THVrNWlM?=
 =?utf-8?B?bnRNcDloMndYMEc3Sy90U2hWRFdOT1kyNW1KWGMxZC9HdTl6TUJZMmZvalJx?=
 =?utf-8?B?Vkw2ZEdoeU9leGt4RW5DY1drT2ZRdG1zdTZUUXJDaG9pbGtYZ0tmN3B3c1ph?=
 =?utf-8?B?anh4Mk95b1Fjc3o3Y0FkczlTTGJ5c3FjOFloeWo3TzBsZVpybXlQMm5qbGVh?=
 =?utf-8?B?UHpnUGtmeUFKRnRlcHRnUWNoM3E2a0NrNHJhVTQ0MVN3Q1o1S2xDYWRTSUdN?=
 =?utf-8?B?QkdBWUYwSnlLQ3pVZUQ5dGVVNG9XcFlVSElFckdmUnI4SFRaUlp3SXR2LzNw?=
 =?utf-8?B?citpVEhtQjlNd1JmSzZkMEFGN3djcVBKSDRYT1RHSUlqWUd1aXk4SmVEc251?=
 =?utf-8?B?cnB6alc0VUd2aGNINGxPbmRpbnBPYzlSNkFlU0htbW0wRU5OdEgxVEJ4KzE2?=
 =?utf-8?B?N0VWdW9qL3dTTEd5aDRNWFRhVlZGSk9CcE5BZk1kcnNrQWpwYk9oek5RWWRi?=
 =?utf-8?B?V21maUo5TENrNkRkcktBNERqaWNBdDczdm1tQklLNHppamt3QkVETEhYb2U3?=
 =?utf-8?B?V0Z2V0MyMUluSlliYmpmdDJ3eFZWTnIxTVdMVm1hRzlpdllCb0dZOTNxYk9F?=
 =?utf-8?B?dlRGUllGV0g3QURlRXNZSXIrTG5BWm9Zc2J5ZVNvaHlMMnlvYWhYZTNPSC91?=
 =?utf-8?B?S2p1V2tYWkI4U2FkUXBxcVNZSHN0Zmpsc0NCR1lGQ1hmbHk0dURzRDVjNndn?=
 =?utf-8?B?T0VMYjYralVZTzNwTFQzdGJ5Z1lwaG5UUFUwN0pjU05IcFh6Nmh4djU2TDRx?=
 =?utf-8?B?V2lGNzNvZDNYdjNUeFRLZjFPazRNbm9mRklYejRkMnJZd0FQSklrZm9UL0l5?=
 =?utf-8?B?REV2R0Y4SnJzbENYbjFaR1pJbHViMnIrRVFMZ2UyK3lJakpJeXRRdC9sQWpV?=
 =?utf-8?B?Wi84L1p5WTNjZWF5NEFPQUNhbC80Q0VjUmJCYmM4NU9GK1dJZ2U0bHJzV0hM?=
 =?utf-8?B?SFBPTVNoV1I2N0Rhc3BnYkxFZGVSSHlQQlI5VDFPVDg3RkRJdHJVeHZvZ1Nx?=
 =?utf-8?B?SWpCR1dSVDZUOGtkMWhmTU9pa1Rndm1EaWtKR29mNURiYWdHYVRDbWZON2Ur?=
 =?utf-8?B?MlRSU2xXSTRGaG1mMHFPMjNkQXZhd0lpQkhHYlBPbmphdWFPMzhZZFFpRFNa?=
 =?utf-8?B?WTRCQXp1L0xzVjNWRXFaL1pkSGprekJhck1rZlVYUHpFdlM4UGZ2V2RORzlN?=
 =?utf-8?B?UnRzUjFydnl1bit5QXUxNXNvc0ZZZjFwZlZyaHRhaWVZcEQ0d2JPUDRTOGZn?=
 =?utf-8?B?R1VxNXZIQnRTYmpOZUgvVzBEbHFwZndpanpacGdjYy92WitaNFBwL0VXQnpG?=
 =?utf-8?B?NGxCZ1AwVW5hcERUcE5sWkhzYU1CRGk2ZDUvR1M0dFkxZUQzMVlUZ2RIRmZh?=
 =?utf-8?B?TWNvbVZIQTJFMzFsNUE4emxSbUpCKzI2QkI3ZmRvMklaRVhobWs5ZkxDUkJL?=
 =?utf-8?B?RmVpZEVlWnB3NmpRY1hjb1ZqNjRIblUwYldheXRZSjJEQUpodkZXdE5UeW9F?=
 =?utf-8?B?YXlseW5PMVYwMjV5TGZSeC9seldDVXE5R2lUczhzM0NySlFBMi9vemNFbGcr?=
 =?utf-8?B?aW9ELzVBamhEbmU0RTI2M1JpRjRnd1RXd2V3RGpEZWcxc0NOQit1R3YxcERP?=
 =?utf-8?B?cnRhT2VUSjlwNHNudys4VFVPMENXejhRd1BhT0VIRnQ2Y2ljRHBTelBhaEtu?=
 =?utf-8?B?K3V1U3JENG9FakpjRnpUUEQwczUzc0gzb3E5aTZDWFdGcDdOMG52YTd2bXZn?=
 =?utf-8?Q?cT2a0XqiO9+xj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0drY1VyVlhMV0dCOUl3ZTZEdGtwSVJtMjZiekVMOTRuSG84dG5oQWhPOGRL?=
 =?utf-8?B?cUtIeGhJTHZMeXVDZlFTdVFzWENNS3F6WERLVWREb0RnOS9pa1d0M1I1RGFU?=
 =?utf-8?B?bzVDdmx0NzFja3pjekVTTEViRGx5NDhwWVR1bVpueDYxelZVUHJUQURCcm9V?=
 =?utf-8?B?OUtVc2RLZWNkM2tGQTVYNnFkR0lkQVZuYXZ2NWNhSW56dmppQmRGQmhBT1pa?=
 =?utf-8?B?Q1d6SDNRc0hpSHdwb1BjaHhQM0E3aFJITXQzV3lPSXRLN0pKVFpjV01qMkJ1?=
 =?utf-8?B?RzZxaEQ3dUVjZ2RDLzVDQWVqUjhER3JrYUJZbWd5RHVadmQ5ckd0UFlLcEU0?=
 =?utf-8?B?SWhhTkplcEZ5VFBjNVduNEF4NVg1NDRYcEhJSVV1cjNhdXpNNmQwVThzWVVP?=
 =?utf-8?B?Ny9TSnB0QmtqTDhzL0RRdU1GN0NXb0xKaFFKZytmdWg2L1B5N2NueHVtOW84?=
 =?utf-8?B?RC9zUTN0ZnhWeVdqOFpyVzVQOUtMcWdJM2oyY1h2ZzhnY25ROU5aUXBHRG41?=
 =?utf-8?B?TFVwTXlzMGkvYUxGYTY1aS9EWG9sT2dHK2dZcFdnamlyQXYzZXJTNVMremFr?=
 =?utf-8?B?QzFPVFpCcFZqV013V1JJUmh4WFlkUS9Jb0lMOXFTcWxXU2FaTnN6bFlacWlt?=
 =?utf-8?B?QUhoaldlV2lXb3plNW1xUENEelRPWGpmWHZxUFdMb2xsZWF4ekN2N0RsdGpI?=
 =?utf-8?B?eE0vRDJ1TDBuOEQ4UWQ1c05lOGY4bXJaaGVIUm5XYkdtRkZpVk90SzVIdjNv?=
 =?utf-8?B?aFJ0bjI3cG5hU016YWVmQ0c0VU9ydnZNd2Y0dWdOR2NsbTIzZUVmbkhOdXN0?=
 =?utf-8?B?T2hMTUUvdnBCR085Y05vbVJlalhBL1IxMEtQdlk4Z0NTbDM5UFRueUdsSXdk?=
 =?utf-8?B?T3haMlY5a05tTCtYYTM1QjR0RGxSb1ZnVmFPaE9ESjFObEl0MFZmMDM5OVA5?=
 =?utf-8?B?UFVzWWt4bTRGbkI0Z2Zja3pnTUpZczNDb1h4ZFg1ZmRWejdYQUc2NFJsT0Nk?=
 =?utf-8?B?Z0N4UUVSVzNoLy90VjQ4dit3V0RvK0tIK1dmNUg4NkhTWE1PdnlTYUtWU25C?=
 =?utf-8?B?M240eFA0aEJJTXladlVQWlVIcjlZRnVFRENOQkdhNndzY0JPTVJQWEQ4YUF1?=
 =?utf-8?B?amNSQWlTSFFxcHdvU3EyZU0xWVFrWnFIMlVRT2JwSVdxaFVpVEZoYVhSSXhQ?=
 =?utf-8?B?SVQrZktQa05aRTcwRWx0TS9GUWpqd1JhR3hFQXNrcmo4TCthTDh6a21OR0xz?=
 =?utf-8?B?Q2VZTzR1bXFsV1VPUGNsdHhJWGVSVVlLS3kwTUVvN2ZHZUp6WXJVZjlDamJD?=
 =?utf-8?B?WkVKSExMdVYvRVUyZ2ltZC9zNGlyM1pKbGxidWhXZFVjdDhFWWt0Z2tNTHhU?=
 =?utf-8?B?Z3pDZkxnOXhvVmU0OHNMMUhGdFJUcmJjUXJRVUwyMFRZRGFDQSswTHYyM2t4?=
 =?utf-8?B?eGJoOXRlV3I2WTErTkI3RWFhMG40YWxRbHE1V0tjRXZuZjlLaE94aDBIaEg3?=
 =?utf-8?B?VHpmejdiSXVsNXVaNFl3TkROcmQ0RTlLKzI0LzBVTjN0M3BvQTcyS1JFZW55?=
 =?utf-8?B?Yk9rZmhmRHUxZlQyaHpwM0J0WENmNEpnR0dDVHNIR1hRckpYUGFGQ3FjWmpn?=
 =?utf-8?B?K1lOUW1yRWJUazl6Umo1RWV0TlQzWFNkRENnY0Y3aURMRzRrZElEZ3BlRUY1?=
 =?utf-8?B?M1JiQjRkaENpSUN0K1VTVnpab3N0M0RScFBXRk82azFnOEJDVk9jL0Y4eCtH?=
 =?utf-8?B?R0M5LzFGdDdNRERDamw4T3Z1OW1HUEFoYVdTbVB3R1RpTXFCVFF0QVlmNkFl?=
 =?utf-8?B?TGFNQVI3Y0dtM3N2alNEK0c5dkxEQ3pWc2kzQ0RBZEh4U1FhMldhb0lGNWVE?=
 =?utf-8?B?RFBUVGw3OVE5N2ZMa0s2N0Erb0lGSEpTeHFZKzY4Zk1GS1orOE1tUGFQQTgx?=
 =?utf-8?B?bERrM0x1bnFuTXlsZkQrMHI5NHRQVVFSRkNIWnBBUW05TlVhaEdFQVlRamd1?=
 =?utf-8?B?Ymx2N3MrcjhHZ1VVY0IwVEJMenNMeVBXN1MzU3lZS1NDSWpOeUM0ZFZLZC83?=
 =?utf-8?B?NUNycFJLdENMRVEyMlVYeTFnaG1GdEtVcmxhNGE3U09rdDNIc05kUGVmYmg3?=
 =?utf-8?Q?qfWV/Bj6maUPxsdh4r7y1u1Qo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b92a7233-2768-47f9-e627-08dd2f094b57
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 10:51:52.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGILMjFIcImVnlyxtGNPw+dI2Pkn8pEixiYRVP2U9nsw24bBIRikQuDcV6s7snDuMLY0TYwoG+oVUwxwxvkTFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9447

Jason, Alejandro,


On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> This is a small collection of cleanups
>  - Remove amd_iommu_domain_update() (dead code)
>  - Remove domain_alloc()
>  - Remove now obsolete NULL checks
>  - Remove obsolete domain types in the domain_alloc_paging_flags() flow
>  - Use PD_MODE consistently instead of mixing with io_pgtable stuff


Thanks for the series. With this we are close to finish the domain allocation
path rework. I have a patch to fix def_domain_type() path. Will rebase and post
it soon.

-Vasant


