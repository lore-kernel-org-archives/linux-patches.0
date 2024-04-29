Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BAE75810;
	Mon, 29 Apr 2024 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714399308; cv=fail; b=RW66GjSDA3Avd7YcD8XevjPJ2VlIVhfeZymssi21R0N9vIUG/N3/itFc2J0liF8BIOXl0LD6zfImYsYYLf212RqjElMOVXoQsQs0imDSO4M7OIbU7vvN330C5N0I6Wstvuy5iAV5hhKlTwzJFNLUxL78YUkThFIJ9LDmP6hV82c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714399308; c=relaxed/simple;
	bh=IDvn48IDRRmrtzrn1HuO1ZTQkitA1PATNXYYW0xCMRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jckOUq7Ey92vsaAc55I/UdAK+UDTs3kkrwN7+VB+zJXrnKrsfEYrVHPtC3INj2EqFHx8bSVsh2hiBbq7FecAD+bxHIgwFfZBlgXWCVVmZG8fImTwDTDgrCFA++Ag8A5KetLihTyrTZ8DnYMCMRzu6nNQJEkxRvLJr23hy4LJWCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b28d/5xP; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b28d/5xP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1Qm6JlL2l/VQivXEB5bQDrKt+TH2GCS65xf0GHr6vo0Lyyj5FJ4sLHvp8kWREAeRHMFi6Tjob1npLwmUY7MjT4rHZ+HGi0xcm50BeO9tCfsVsb/+N1QdJp+NZewatoI3BU5HiS2qXuXV4i1ZdzTVeQ9MwVIXdPadd205CMmKvlP7W6t6X0Bt+os02oc+6hCWGhdYLF95KsfP4C0hvsmEOk14vBcAaiRezhPU/VLG9Kvg/90ogGHIW5dNi68ADnBK4a6riwAvt0MkPWeDVL83fhAsdcGwfEMZZmmlGpvS3HS48qFxubf4CcQsXAICRl+M6A/s86kVZPE3Y6vXcGKkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiIse+KTnLBnJWCzEgcci9TPnkzXeMngqpsuY1aG8Ss=;
 b=KMN5TD5WwBOHkp9ZRTUfyB5vTt/UgyodW9yJ44MukrWlvZlCQLjN6uxabXVkyO1Ua3ibKOdoGr0qNgjbx0RPJC/h5FA1BaZ4eNoa2cIKP5gDhSKSSklLHVd8SaV86tMS7TAqOsFkPbFWmoCEFs+meTz/FX4psZ0VedF0Ayq5ltzPfu6ejAkB0A/Li/ViiFOCkkOFy6WVkHj9vjoey/FRaovT5q3EAYj6Cpm3McAxaA+7a784RoX02U/hLxlp6F27Qe5Fbevzn7K9kpN5JBaTgggQtexz/3UL2VUpWeawPa6x3amXw+a0IefFZXil221dgYKRHmPnMM34YEzALABOdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aiIse+KTnLBnJWCzEgcci9TPnkzXeMngqpsuY1aG8Ss=;
 b=b28d/5xPd0VZJ6pyLYbaYiozBf0zHwG/pIQTh7HfUhHEDS3+gkvXPm3lHj+N2WbRtzuNd4EazimFO5PqzOBf69sY+wCdCov5TbOYBIB3W0kqnBA+A7ghw6lvC7YGL2Zyh/dpQh9WcEpCzvgzCaP+k7V/6xM0S4vYEDjQHKF208jqVbBoMVGb7XS5XtOcMiUu5dM2aEXME5QaYi6YodTFrkKsaDD6IQNIe6rLjdw9k+xY3qKa7StfDltlmwTGawgZM5YvkGS/QrAuDBDAvnIpLilH1tgR/k0j12W+IfJwdEerzg6L/kdmlMLzYKBAJUa++h6pvdl2W4TRHEdbadbk1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB7554.namprd12.prod.outlook.com (2603:10b6:208:43e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Mon, 29 Apr
 2024 14:01:39 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 14:01:38 +0000
Date: Mon, 29 Apr 2024 11:01:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Message-ID: <20240429140137.GE941030@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLerRK1pXvt-HML@google.com>
 <20240422142053.GD49823@nvidia.com>
 <Zi15-dcNj6E0k4jK@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zi15-dcNj6E0k4jK@google.com>
X-ClientProxiedBy: MN2PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:208:239::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: c67b8f9f-43a3-46f3-f13d-08dc6854e3b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUdWWU9BWWV5S1N3TDNpdUFzQVFicUhNS29wa3B3WWZ6a0tqNWlPSlBxVEVw?=
 =?utf-8?B?NzA0dUx3SjYzWFlhR2FLREg1NGtWeXBVUDd1cWIydEl6Qit2QlFGZTRvVm55?=
 =?utf-8?B?VUcxazhocW1TQ2tDYU5kcmlSanVUMXNDS3Flb3MrWmx5VzN4M3hsU093b0t2?=
 =?utf-8?B?YkpCWjZ1Y2hMa05DRjFheFlzTTZkSzRVejN4RjZGYk9rNGhQZVVJN3BLS0pB?=
 =?utf-8?B?SHJoYXloZFhzeS9yZWlVaDc3SThiVTdSOVhFUHB1c3JoKzZBdmlOZnR0RlF1?=
 =?utf-8?B?U1o1clpKVmNxOVJOMmswaGFrcDFIa1VtLzhHc0l3NWhiU3c2bjQ5NUNGNjNZ?=
 =?utf-8?B?MzY2cWdWTjlQMnVnclFHSUxQQ0wvNlhUSHhiMEJxeWdUUEVwZ1Q4ZFRwN1l2?=
 =?utf-8?B?VVd4M0lvVDUvNGllNVJmYjNhR2pwc01TVVpGYXAyS2t2SFkwZGJzMnoyRUFZ?=
 =?utf-8?B?dFo4bVZHVW9FSFZMRUhZbzl0YWtIS2hXN0dGTUVYa3Vad1JBUlhJdndqTUNT?=
 =?utf-8?B?dElUL2NFL3NtTVJVby9QeEdmOXpvU2VFemNJQlhtZWh3cGx1T2tKQk1mclVz?=
 =?utf-8?B?ZzgyemRmaEhTT2E0SWgybXJQYTIySVhyb3p5RloreWZCY2J0bk5vTmV6aWE1?=
 =?utf-8?B?d3M1UlVjek1yN2tkWGNGT2E1MFBLWlNsUVJPMHVqa2ZNUEc5cTV3VW5NcHly?=
 =?utf-8?B?SXhaM0V3VjRiZG1TNmhjYmZGSDN5THJGYnlyNWlqRityU2JlWUpLaWI3STNN?=
 =?utf-8?B?RnBiK0ZhYmFpaTk4UGd2ZTloRFljVFkvMHVvSnFVSzQ3UkkxUHBaYTQ5M1FL?=
 =?utf-8?B?RnZGV0Q4TzJmeW1Na2V5cTFmenYvZnNrazhVaWdSUHNFTmpKZVorTjlHV0N4?=
 =?utf-8?B?QVRsTVN3cjZHck9kc2lINktydmhFL1NSSHM2S0hYTzErY1ZmZGI0Ly9ZMGpr?=
 =?utf-8?B?S0NmUlBsTWFUOURlY3FDZndSRjJuSVJETlBTNkNma0sweCs0dWtoMENwb29O?=
 =?utf-8?B?VzJid2xZWW8vaW5zdncrNitIUkdHR0IxT1NiN1cyeDBGaU15ckNWQXBPVUlk?=
 =?utf-8?B?YkoydXhEOWFvWC9WUjBYQ1BMUTVCLzlSOGt5SG9OZ3hIbWhETHVlMWhmVkhu?=
 =?utf-8?B?enBzdFpwVzJuSE1wb1IyOUxlME9tWXhNdWV2Q004YzNvbjdqcGdKTEZ0WFF5?=
 =?utf-8?B?SkNxZnR1aDlTTWwrVjNKdWhPWDVneUpxa1UwVTVtNGN2RHlncWE4TUZzTllw?=
 =?utf-8?B?MkF6ZUh0ZWUzK1hiMGVVMnNEUTBLZnJVODZxTTR3WFhvRHpIT05CMitFMmV6?=
 =?utf-8?B?eHBGTDlndXZ5YW5QWWdoamttSzlXZUpNSUxpakFiMkZ5OFhYMmh0TlFkL2Vx?=
 =?utf-8?B?R2dpQmxOekpEVWFtOTExaUhnT1g0OXhWWFRoNXlpbjc2N1FEdEoxcXNXbkk5?=
 =?utf-8?B?RVp4QVBzdGVQTTRNT0pOQm5FbkcwejBpWFk4NzBRd2ZwMWc1N0pSZXhsSCtp?=
 =?utf-8?B?cFVhNktCYk1Eb29vNW9aeXdwclh2RTgwRjNHNTZ5WjRvbXRJZExwOGtEYTMx?=
 =?utf-8?B?NXZSakx2V3JqVVlhSFFqL05zOThPS2lDREZTVHl6Q1JIMDdWQ21DdVdrSGF6?=
 =?utf-8?B?emcrVTRYR09zM1k0K1I4UzhBK1VVS21JZFBOTWFDUkc4NUQ0SUhGeWNib1Ft?=
 =?utf-8?B?aVgzbE9FeVlhT2tEWENFbG13QjFKaUdLd2FKcmk1UU00NUlRd2FkQzRRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHRaVXJJME4rdlZyNmJpeStxdFYzbXRoSklTQ0k4WEpiL0lkV0NrZ1EyRldj?=
 =?utf-8?B?bjZCSm1mL0xMbW5RYmlsSC9naCtoUDhBSlQvS3U5MkRNVFIzZlBLdzJFV0RC?=
 =?utf-8?B?UFlkN3RySC9sVURoSXFKTFcrQ001RzVwcCtqNFZvSDRVQVhwUE9ZcXJ2OVlP?=
 =?utf-8?B?S1FQekNYZXBHQ1R0aUk4Wk1OOG4rZkkremxKOVJXWUNEd3FtMFJCNVQzUHZQ?=
 =?utf-8?B?bnhWdmNUdGdnUUIxN3d5N3g5cit3UnA1SFBydWpINXlPOXp6c25GQTkxa3NI?=
 =?utf-8?B?S2hoQkdOdzU1Y1F0THNLOTJhMWNYTkI4dGYwZHBtUXlKVWZJb3AxUTExNnpE?=
 =?utf-8?B?dTFMemFaUmZsQ29uV1RsKzVPYVBBRjFtUHMwUWx0c2FDN2dueFluUjRrd0tI?=
 =?utf-8?B?QWF2TGMvQWFiNUpYSzFaMUxZTVVlb2l6MkVvaDRRMjVXK2kxSlZNcXBFc1po?=
 =?utf-8?B?SDVkL0h0NlQzbk9QTUFQVDRwV3VjZGpzNGFVSEFCWnQ1UVdwbWlhZTA3Z3hP?=
 =?utf-8?B?WmFFcm1WdGNkTi94Wk1yRGk2WVVWVFU4bTdEcHQvc3FzZzF4Z2o2SnhqWFg3?=
 =?utf-8?B?cHNadW03TmUzQjl5cDNwSWE1blRTSXpoYVZjTDZycFJHbGpaNjJQVlhJQlZs?=
 =?utf-8?B?b0R1UEFhS05raGRFcStYRzhsKzFUNkFMbGFUaXoraVA1Q09oNzJveTU1TmRi?=
 =?utf-8?B?aUFJMVpMUjlWWWp5cTF5YnVGcXR2TUhHc0hvN1BvM2tqZHhyOVlHN2pKYVYx?=
 =?utf-8?B?MVpBaVdQbGZFdEFwcC9xNDZlaDRZU05EaTNYcmpKMzFFK1puZ1JGU0xzTkpK?=
 =?utf-8?B?T1dINEFCd0xwbERCZHkyenBhM3hIRkEwSmo4ZVBOUFplL2lQTGlMUWtrdzdI?=
 =?utf-8?B?bk5DT2E2WVRZQXRYaGNaTFVqMWRWbmZrazg1VDcvQWNlUXR3OTEyS2VuZ0lu?=
 =?utf-8?B?Q0VtSW9TRU9tallNUDlUbUJmN0xZQk9pNGZXZkJBN3JWcmZhOWk1MG1yM1F1?=
 =?utf-8?B?Q1JGcERMMFczRHl5R2VuQWNUMG9KUU9nZzR2d2swQ1pxNzNPZG1jZGJVV1Z4?=
 =?utf-8?B?eHVpcGpucU91dktRQlRMbW8zbjZydm1OMmN6QkRXYys4UGpQejkzN1BDbTd5?=
 =?utf-8?B?dTVDV2VYT3dvaFNiQkpqdjF1c3BsUXVLVE9tczN0U3JZL0xtY09xbjJRNmtp?=
 =?utf-8?B?YTNjWGliWDhYTWN6QjV4bDB0RG1FMExPRVlxTkU0NjFCNlBTeVVWNmFlMXJM?=
 =?utf-8?B?Mnp0azNCQU9xMkQ3NXcxK0VvSmtERTJSNVN1YjFIWW9LL2hzbXdRNk9DTHZz?=
 =?utf-8?B?SGFSL0xsajg1RlFuRkRxZmJzQVRqaWJoVHhUa2lhZGVxVGVIMms5ZlFmOElk?=
 =?utf-8?B?VjNTNUZaNS9wNFFUK3ZhK3p1bVVVMXpYR0dXNm95V0pBdlZVRVpTcEpGK1lR?=
 =?utf-8?B?enpNSC9wTjUrTVY5d3ZxY0lKdFZYWUgrYmYrblNtd0MwS3JhZjRVcFNkNldn?=
 =?utf-8?B?RlZGSkhGYzhFVnJ0Y0pwNzBZVW1oQmV0WE1IM1V2ekRHcE9Yd1Z4bWVkQzJm?=
 =?utf-8?B?TnNmQ3JvSTBQY3NrVU5GWHJmVk9mSjFtZ2E0MU1IbEh5eGFEVXJ6eTY1WndR?=
 =?utf-8?B?N1VtNVVyUXVwdWh6MEpRQUh2RGpuajZaZHFvcEhHQ2dZVVJvaEVHY1F3OHEx?=
 =?utf-8?B?cGdTajFpRm1FbjFaVmxQbThLaU4vS0JrQ1A5d3lkYWlsVGlJN2JaN05rSWk3?=
 =?utf-8?B?NS9HQTRaZEhLaUQrVmFhVUdTM01QS1BKU0lmSGc0ZkNEMFZNM2JlOXI4cEQz?=
 =?utf-8?B?d2lQMHBHQmpBSTIxRzYwMWlYNlM5Z2U1NXZid0JsUEFDRkxWM2djSzNMN25o?=
 =?utf-8?B?NkZFWHdUTkFPTmhiaDVkZzdQeENvelg3bUd4Q01qcFRIUHF4N1dpZ2FlNThI?=
 =?utf-8?B?UEtnbGdLU3paTkJCU1FpcjNNVjA1NnhSYjZsNThmRlg4cmFlbjh0Q25yNXVU?=
 =?utf-8?B?RTZ6UE1aRlhYbVhuOFdiQk9lOXA0WWtYT01aT3hnNDRmWFB4WEt1Vlc2aHJx?=
 =?utf-8?B?MjB6a0tRVWtlSWVMWGNBOUhZckF0NnhzakVGU3hKdzM2QTFYeCtWSzkxWElz?=
 =?utf-8?Q?R3w2iBrpZ63bQiJr0kI8K64RW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67b8f9f-43a3-46f3-f13d-08dc6854e3b3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 14:01:38.8017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkhdwAHXSADMJzdRS/wvhnKNy+WlTobgtdJJPvt4oz0nN4+g7VwMerpwr3bvz6CO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7554

On Sat, Apr 27, 2024 at 10:19:37PM +0000, Mostafa Saleh wrote:

> > I'm not sure what you are asking? We have two versions. One is called
> > alloc and one is called get. That have different locking requirements
> > on the caller so they have different names. I would not call them both
> > get?
> > 
> 
> My point is that arm_smmu_alloc_cd_ptr() doesn’t only allocate the leaf,
> but also the L1 through arm_smmu_alloc_cd_tables()

Sure, it is called alloc, it allocs everything to make the CD table
entry usable.

> IMO, arm_smmu_alloc_cd_ptr() should only allocate leafs. And inside
> arm_smmu_attach_dev() it calls arm_smmu_alloc_cd_tables().
> This makes it clear which path is expected to allocate the L1 table.

The PASID path sometimes has to allocate the L1 table too, why
duplicate the allocation code?

What is different about the L1 vs L2 that it should be open coded?

Jason
