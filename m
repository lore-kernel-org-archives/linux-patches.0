Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876D713CFAC;
	Wed,  5 Jun 2024 23:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717631474; cv=fail; b=jGZZC/6DwAJI1SlF2QHBA3mJRs7zlz4yMp2GOm36Go1kwp9eW2UszTAPqCAZQSjkgG0ccVyM7jqnPGuOLVMlgjBe8ZIrLTspe/KqFz99F+MaNyfIscEd3g1yaKRWvl4qvTeqkEMb4pOCIB69+bedxn8f5xcSm0x4EL/mx8OGO2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717631474; c=relaxed/simple;
	bh=2Tft2O9hjYxtBQBgEF3G1qs9354bg1G3Of+nesOObhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dGxMw2ZXMVziR/2Aj/q6uqJBe6a/7Mgl8coSiYdxOdXowlEUDAf+DIzDsvjx9KHEnInRMz1nzkEydSvjJw047qvldx5pyBXE6Ia06MBMgEEVkV0a44fVHVcQn60yK0gyd/SionY9MPaRIvD0qGbX2qzWKPb0tvhX4Xg8jCEiQ1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JHMU7tH3; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JHMU7tH3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtCKI+WLRgROEqtJgUaC4kihX3TBJt+M7S+c+5qbr4+NsphfDqlp7/IlbK3TtB9KwLnRcTFycuQo5mvM10S19L0ZFpAGrRLgx8B/Ae2aR6fKo6aORTaoUvrcSO/ipIlAN7P2GIx1GC8m82m+NCarXUM1R2TsQ9Ipzu+McVvEfom2wRSO7maqdg2ZkDd9DmPogfyp1feUP5X6SxjaSjhMisg1rDqKMaY8kyFGfcldl5UH7ML7sHRoowLp4KYa+hXD4KxEb7whKmSy/F8mWpsHyiFRe4jUMp7znJF2bk5BjeF25B03z1G9gARyRJI1PPgXIOjdzqcoJFrSDwXfS9GAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IuzZwSHz2mtZwZafJWlU3C6rJ/x1nuOFOIbX0zz3QeY=;
 b=UObd9I7YmePnQYSsT2bWjFSmxdiiEzUFkfL73kGOtbzyWbMmRekachA+hpXzhtKeJQdJN8H4p1QT6coqJ7NZYq2CrWqmwkaEKIu2imuGSsKVGydFgg2qiF3qRktRQjcUYcMfPIChNmf0H1l++JE0oAcqo3wRVtH+cpUZ5En7DI4lo0tU7J/K0YCBWfhQrFB9TGGWKVgYoCyFpo0y7h9fZL/rSA0YDrJdHQMqIOtBfEI4sYdulcYDo7urWVdTU/wkdSxTRsmhxUzUjEryYH8DwFzqhHR4omMvfWunMLDVmGyliGV5ahUQ9RQF5ButQ7yIOla2G0s+3DHtxz86EZxziw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuzZwSHz2mtZwZafJWlU3C6rJ/x1nuOFOIbX0zz3QeY=;
 b=JHMU7tH3lkU4XBwgma6zvYbfTWEG+D61zzEjZFMPTvWXA5pV/V3T9qJ7BaK8iM1uE6CKYqSKDAGryum+izGw+2W/OpGbuQl/2CxF69Ee3MRnRX3XhWt9gSKOgTcQSb4JvAZXIRqwHr50EJrQvRYPnorn7aqeG/EvKXxaCM8Q4zttSm07a2u+fPTSw7hEah5tsBHzklTnIaHJUCf9ixvJ/cSwnNZwB53hbl1mswoTNeJ4wo2bkxNm6yygNCsvpQ4qFt6XOiJSp8CbupQIo/6+u1ZpQ0EuFjaZSQGkUQeDC/RQex9y5DeGuU5gZVKgq2TNNwnxaT5f8TVH9iqe3w/uHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB8510.namprd12.prod.outlook.com (2603:10b6:610:15b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.32; Wed, 5 Jun
 2024 23:51:09 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 23:51:09 +0000
Date: Wed, 5 Jun 2024 20:51:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <20240605235108.GB2030792@nvidia.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl84JwoxGFOLzKSC@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zl84JwoxGFOLzKSC@google.com>
X-ClientProxiedBy: MN2PR20CA0059.namprd20.prod.outlook.com
 (2603:10b6:208:235::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f41a16a-372f-414b-81cd-08dc85ba5fab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXNEditGcWoyQWhPNURiQjlQSm5NUHZ3U2RWNEp1c2xNWWVtUTZNa2dYSkZy?=
 =?utf-8?B?TU4rWkhBU3UzY1VvYjRxVXZqZ21XdS9iUGlDU0E4dVp4dTBXMjVOMGVKbWhj?=
 =?utf-8?B?ZWZOTzFFM2N4N2Rtejd5UDMzd0xLNDgvMHFSendGS2RlMlpkdjRXbStvTjZt?=
 =?utf-8?B?S29lME9qb2tmMXQvL1NQN2pYMFRyTUxvZ0R4MG9Ib1pqSTg3UHhYbmlsbDhh?=
 =?utf-8?B?U01XdXNMWWo2SWxRR3EvcmhLdlR0dDdCZHhsaUZnbUdnR1NzQUZuTmRMb0FJ?=
 =?utf-8?B?dUVialFxakZjMHZKdnFjTUYvSnF4UFIrb0MrSDZ4akpTNkRBQWpBRGxNd3Zp?=
 =?utf-8?B?V3NlSVE5cGpnQ2UydnhjL1NJOUx3NHdZaksra1ZaaXg1VGZoRERaVnMzR2g2?=
 =?utf-8?B?UWlqUWt2TEsyditjZEVYVmk0YzlXRTJRNlBaU29yWENWc1VIcmllVnl1aEZv?=
 =?utf-8?B?U2ZLa055SUZkTVN2M3ljK0FlTGZKbzFBa2wwWklLcitQOHJteldzbUlvQzNU?=
 =?utf-8?B?cURUaUZMV3RqamRBb0xBNldKRlFidGJ3VHlwQUdWbnJ3NW1BbjNMRFFQb0JH?=
 =?utf-8?B?ZFVudjR2b3BkVXYzajJ1YSsxd1F6cStPVlJUckZVaWl0RVRWVEpSeTZweXFC?=
 =?utf-8?B?WGU5MUJtdVNudGthajFaa3ppUGRldmhMY1pPV3h2SnVVUkV1T3FCMTAyck43?=
 =?utf-8?B?dUZXUmVlNEdSRytNeVd5cktvKytHRnpvMVNWbFRweURMYldTWWVMdHRlVVNn?=
 =?utf-8?B?a2gxbzZ6UC9RWktyMlMrV3d5YmF3Z1o4OXlRVWp6SHhMNlhub2pRZGs3dWhG?=
 =?utf-8?B?SjZXczhSb25jVytlNWdySURmQ0FjcThCYWg3TWZZdzJHRUNlM3BHTVRZZkhC?=
 =?utf-8?B?UXV6bTBwRC9Pb3BFeG9pUjlFeElPcDdad0I4VzN6bzRWYmRNaFJDelVIRFJS?=
 =?utf-8?B?TVcwN3BsUjFKcmloMVZNU2l5elNCRWVFdTFiR25IM05MTzNaTjltVWc5UERJ?=
 =?utf-8?B?c0pkTSt0K2R0VE1XR3IxdXk1bVMwSGZHbVpiL1NOUm9DQ2ZEcmhZc1Qxcnh6?=
 =?utf-8?B?SGlHTXd0MmdoT2dIU3dpMUFqY1FEVXM4a05rSjFpbWJrNkFYb1A0cmYvTzhP?=
 =?utf-8?B?THhaTi9xdW82cXIzdlRPNEUzZERvVWN1RHdvdWFiY0ZXcjBRNWJYSXRFMlRR?=
 =?utf-8?B?Y08wQmtSenJWVU1UMEE5cUZ6aDliVmVoUlFBWi9UMTVwWTE2c0hzUWtCWWxG?=
 =?utf-8?B?Zysxb3BmTHM4L0pIbXZYWnNQM1Q0MnJpYjRLazBiM0NqT3VKa1diUGpiMk5M?=
 =?utf-8?B?L3V4a2pFc1gveDV4SDBTZU16dUp1WUpUWWZQR3EwVEpISTE4NHR6OGJLVXdW?=
 =?utf-8?B?a2NVaCtDZmRRWkthb3NYcGZaaUhUb0g5eDVwbnVYOEZQOVZoSjJXbVBrVkVZ?=
 =?utf-8?B?VkYrb2FlQ0dFUVZXRjVYMWdoWDMxTlpjczRycW54Y3F0V2lEU0oyZGIxZk5x?=
 =?utf-8?B?VmFDV3dOdTgxanJhNGZVbG1oMUdGT0FqMFZIWW4rRXhHbHBXMk5TUjBzcEVQ?=
 =?utf-8?B?WWlXM0pnWThUclBTWW1YbFZkTnRLYnpLeVdDejdsZUdjN3BrVVgrbE1TNXkz?=
 =?utf-8?B?alZtZmtEdkgyeXpuMm51S2tKUXJEZDFSWHlTMlFLV3puRCtWNWU5WmtNUkFn?=
 =?utf-8?B?R3Y5aFRtL1FSQ1J3MUQrdC93a1dYd2FQSXk2NmYxRFNZbmFRUzliYlR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUF2YXJOZWtrSW1SMGRCS2laWVFvdkNUMkloUlAwZXl0Z24yQlpEb1BET1Z0?=
 =?utf-8?B?YzhyUDhYSEg1L0h6dmdLOVpTT2V3M3pSYnNYWm16dmNKa3NOdmhaME5JT2cy?=
 =?utf-8?B?OG1ZckN2bmtQOTVHWEl5dGdTckZzdURQMFpidGJSN1NEVDdyZXhQVmc4Ulhq?=
 =?utf-8?B?UXpqWHJtcnp0RE54cTRCeWtNOWIvaUhkYWU3eGNpOGNrbjRQeU9TOCtwMUFH?=
 =?utf-8?B?RG4rcExBeks5RFZXMk9MK25xMktvMXNNOG1OdWxITWFBWUIyRXlSZVd6UzV4?=
 =?utf-8?B?Y2tWTGtkVEtkZkwwMDdwTGNuRStJUnZxQmtNcFl4bHlpZEhyTXJxTGtLZ1U4?=
 =?utf-8?B?eDV4Szc2UHl2Umhwbm9LL1o2YXMyY0w2Q1lCWmxIZktsWmZUZWRlL3lIdTgv?=
 =?utf-8?B?Z1dWOVordEM3dWR6M3EySWdwbzFzT3M1VHZVUnlELzBncjhpLzlrU2xXcVYy?=
 =?utf-8?B?aWV4MDdzaDdFd0VMVnQ5aVRjekpoeEtkdHA4ZkpoTVlsTmxwTWZ5T2RDQy9L?=
 =?utf-8?B?YTgxcnNQdXVab3VWbGZUSGRISWc5bzRMSnhjV1p2U0ZnTkx6MmF5OWtTZHB1?=
 =?utf-8?B?OVBtOE5lZzQwVXRySnJ6NmZXWm9WOUdHNTRHVG04TWNXS3BuUS80YjRzSktW?=
 =?utf-8?B?OWl2REtVTDZJR0Z6UDBCMFA3OWxLRG83dW1lQjFrT1ZZa1RTOVhzT1B0L2I3?=
 =?utf-8?B?dGJXV0tVbThpclZUY1oxaUl0RjR6ZDd1NmRNcTJIYXhxUWpZS0xWdUQwbWtz?=
 =?utf-8?B?OHJUcTFHaXBkV0xkMEVOY3JaRHhaWnBSSWh4Q1piMWlaNGw2aHUxUk9XVDI1?=
 =?utf-8?B?YkR5dVo1QmpoMXA1aVdTQUJNaVpXeU5IYUhtcWVJZy9KWDNvQlFLZURuTHhK?=
 =?utf-8?B?TW9LSWJkeGptNDFCM3BzelNNdlRZd1FpMkRDUlBPb1RRV0VRajF0YllCVHJq?=
 =?utf-8?B?M0w0R1dNOFNPMTV5dVN5Vy93cTJsWmZyUUlUWElacjlxYnBtajZPczhHNndE?=
 =?utf-8?B?OS9BVlJ6WXY4REdmSVdwVHBna25nZUFXUFQ0dEN0cjBuRThXWE5XekdtWElG?=
 =?utf-8?B?ZW5DOHI4RExHU0Y1UzVrcUVMT3VCWWFWSWR4eTZuek5aUnN4d3Nudk80MWlT?=
 =?utf-8?B?UEV1d2RUejNJVzAwSzI2Yk1rSjlLeUVleWFFOTZaVFlVcDdMejV0dVRYNEhw?=
 =?utf-8?B?QUl4MDNLNSt1MUNGUGFJMklWSXIxY3FMQlk0dHQ3MFFYQXFscVp5NlJNQkRn?=
 =?utf-8?B?aGFoTC9QN3FGZVlXenZQeWhEOTFJTkZ1N1JpaXpJdmU2MzZQQk90amdkMXc2?=
 =?utf-8?B?b2JscUFlQ01FcWN4V0QzOGZDczRrU0F5bmVBT0FkbDBPUGJYU1QrbXkyOERP?=
 =?utf-8?B?Q0ZVT29QVXRrWDVjbzFBMzJtKzcxNW9OU0RydWU1UUNZRi8zSFRQWmh5SjlY?=
 =?utf-8?B?NlduL2dEeklkc0xkRjErVTByNTZneUFzby9tNThrUm03QmtCZCtsV1hJRnhJ?=
 =?utf-8?B?U0hvNUNTRkRCdFhmTmFHU05yWE9GTkQ5TENlR2NtSWtlaUxsb2J3VXVmYUhI?=
 =?utf-8?B?WWhXMVcremNMbmNTQXUvcWEvZy9vRXZPT3ZWRVo5WlphMVVsUDViTThuRFBh?=
 =?utf-8?B?UXBhaHVDTmtheTZEcmwyUkdwRHc5NVZDb0FuaXB6YjIzaXFoUEl3NHZsaXJr?=
 =?utf-8?B?NUVlU2xxVXpFMVpaWlJtRTAvZVdFQzVxUEIzWjRQcXdXYzZ0S3N5Y0xCZ2Z1?=
 =?utf-8?B?RW1RcE42cFhNRjR4TmJHVHhtT2pzcFV0VXVkNXZuV2ZCclJTUDhZNjZyNXJu?=
 =?utf-8?B?VkhHRGNYenA1dUd2R0htRmtWN0trYnc4Q0liT3VreGdkbDBsakNDaFZsaUU1?=
 =?utf-8?B?NEdiUEhZUHFYa3RRdWgzd3RPYVYwblozYktmd2kzRXVibytsNTdXYlJvQVBm?=
 =?utf-8?B?Um4zcUpCdmRFTjBXcE5GMjVRUGJKL3pOYktLYURDcUJFOXJ5SDJyZTR0VTMv?=
 =?utf-8?B?OGU2RWNqYi9HL3pzeHRaejhlMjQ1cjZ0eUtneDh5VmpHbjJKazRjc1E2T09C?=
 =?utf-8?B?d21CS1VIaWV2Z0kzNVBYN1pVaXlGV2JneFkvVGp3Smh6U25VWjZvSDFoTWxh?=
 =?utf-8?Q?unaHUB7o5Q6Sj+Zecbb7ijbyC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f41a16a-372f-414b-81cd-08dc85ba5fab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 23:51:09.6563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ5/wz9F3PhuqzVCEawOBovMH/UhQFL2puhsSDJnd0HiBMHkKgRs7t9FFGh3BmRe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8510

On Tue, Jun 04, 2024 at 03:52:07PM +0000, Mostafa Saleh wrote:

> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index ab415e107054c1..6b4f1a664288db 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1661,8 +1661,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
> >  	if (desc->l2ptr)
> >  		return 0;
> >  
> > -	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
> > -	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
> 
> I believe also STRTAB_L1_DESC_DWORDS isn’t needed as l1_desc has the same size.
> Especially I already see sizeof(*cfg->l1_desc) used in some places instead of the macro.
> So we can remove it also as STRTAB_STE_DWORDS.

I didn't want to do this without another type, but sure, it is not
hard. I ended up with:

struct arm_smmu_ste {
	__le64 data[STRTAB_STE_DWORDS];
};

struct arm_smmu_strtab_l2 {
	struct arm_smmu_ste stes[1 << STRTAB_SPLIT];
};

struct arm_smmu_strtab_l1 {
	__le64 l2ptr;
};
#define STRTAB_MAX_L1_ENTRIES (1 << 17)

struct arm_smmu_strtab_cfg {
       union {
	       struct {
		       struct arm_smmu_ste *table;
		       dma_addr_t ste_dma;
		       unsigned int num_ents;
	       } linear;
	       struct {
		       struct arm_smmu_strtab_l1 *l1tab;
		       struct arm_smmu_strtab_l2 **l2ptrs;
		       dma_addr_t l1_dma;
		       unsigned int num_l1_ents;
	       } l2;
       };
       u64				strtab_base;
       u32				strtab_base_cfg;
};

And we drop STRTAB_STE_DWORDS and STRTAB_L1_SZ_SHIFT.

> > @@ -3285,7 +3282,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
> >  	u32 size;
> >  	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> >  
> > -	size = (1 << smmu->sid_bits) * (STRTAB_STE_DWORDS << 3);
> > +	size = (1 << smmu->sid_bits) * sizeof(cfg->strtab.linear[0]);
> 
> nit: maybe be consistent with "sizeof(struct arm_smmu_ste)" which was used earlier
> this patch and "sizeof(cfg->strtab.linear[0])"

I went with the struct version in all cases

Thanks,
Jason
