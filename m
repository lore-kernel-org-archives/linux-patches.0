Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE216EC11;
	Wed, 12 Jun 2024 11:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718192983; cv=fail; b=aiqv7QuWm8hILDa5S/kBTH66iToOhVvz/WYomsiGtS/BpvKxb1W9TH+OtnjEfA8DoNmESvmRUlP19LZO+M3wCtjPE2zrGWBipBiRefl3utuYD9Pryod2cOgU4j26+Xr4jQxCnc98BVHglnO9qrXI8ipbhQ0tH1M2kdr6vbRQwG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718192983; c=relaxed/simple;
	bh=mZmXuT9e2OfRq5CuT/ARyPi8U+7F1P9TcGKlVGy2ATg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WQtbqoDm0Eahhnm+5Sk00ickSvzCesS11qYu0z3se9/27dQ+b8DdqT+G50HV8qAhZMNSUcky+++itKv6rDZEhiIi+EyoZ7p4/P7NrU6f0DZt9OFMdLSeER5F57S1Ev5xOoocpCazpt9LMpIPXShl29zYb57oC/7cdEJKQi4ZIsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gT3oIEEu; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gT3oIEEu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4TjYPXlzaJCVqhmWzRCml3cjJA4NrtbxqGxvQLDyrj1n/CTWnotBXsRLQ66v+2Nxr8gs8Vmim8sAjOcCVQcKwoTip+NmEyKAiBVOAb1nUxIgxqbSooqZBZIBRpdkKG61UZrSr2Or1PTtDrMClFocg4V4KXh7cffyFNp1gYd62Hnsfb/DW9xwQ3akTz7i59u0oXtJB9FMiWO/jADycbRu5thGXBMKquJilqoPI4B1PvUJaQ+0Vb4I2D/ICRLkOwevvABgFhMdKHqvSTZO3Zy7ECQXXtH/GBqOUz4twoRfcK6SjEGLxOVrAoh4KPeyAvcX7T9Cie0Ir7M4q1kcapIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGLKzrK+oSOi/+5QWzh6sird97doan2OPcCrD/zTFvg=;
 b=TPI9W4sCHgMDsQU/c87kDju0KOw15toU+dY0GhGkdn7UIhiyBPgvHxcMDl8ptne+nBwSfXz8kW/KY+6vHzHlqvblql6CLVVkSwma9GxK/33J9C2tDlm4gh7bROmkBdOkY4kOEtgBp08EISiXIsokuRFTpM34Ojrkr4y53laEGl7TW+S3kzr0M9sZdKsxYN4A8mBos3+60z+xzDBsgu86sTXi3ec2m0HCGlnzkNJMpLNjR3Tb6US7XpJm8tXfKeA80fcoOkTwGeQ5MeBmTct6O3mokSk1Lv51cB2LcqDOcJwAi/cIbegpuiwayyP1VJE9vRG54wYKu2F1PSYNf2+tKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGLKzrK+oSOi/+5QWzh6sird97doan2OPcCrD/zTFvg=;
 b=gT3oIEEuQAlRawH2IPEvd8yw5Jzc7RuoN7QlejESePy0dnHEg9y1BMSHo0VdWxro1yQVIOr7h/DdAhqjff0Z8rW4/zNyrqTYCjfdAFLL5n0xdnMQlKvQYkCvAW9MtBEAFWQlpJ0X2hOT93PP/jFfk8+gX2YDIdISVjxp8fdKq2z7MnuHT9LBAkXJ17P1dS40oppMWB9rG/BRaNRX22Nli4EORRL/CRS1NZF13EiChrj784dECpk7SmjACKrUM4AuvPohqvzR8sw2lsL/KvCveN4B88f3DRKURY76gmtTn2Ucq9QsAehjW8CMCXBnZRQSiUA3A26UmzVzTy3svVrXJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB7455.namprd12.prod.outlook.com (2603:10b6:510:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 11:49:38 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 11:49:38 +0000
Date: Wed, 12 Jun 2024 08:49:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Daniel Mentz <danielmentz@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 03/10] iommu/arm-smmu-v3: Add
 arm_smmu_strtab_l1/2_idx()
Message-ID: <20240612114936.GW19897@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <CAE2F3rBA-QHBROY9T0eo6HzYkMOs51+xMXHZLSjnz4=D6XEszQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE2F3rBA-QHBROY9T0eo6HzYkMOs51+xMXHZLSjnz4=D6XEszQ@mail.gmail.com>
X-ClientProxiedBy: MN2PR01CA0046.prod.exchangelabs.com (2603:10b6:208:23f::15)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB7455:EE_
X-MS-Office365-Filtering-Correlation-Id: 75f765fe-173d-458f-9419-08dc8ad5bcfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|376006|7416006;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akNCN0NZYmg0MWZObzkyUmpVRGduNlpQMkRLWWcrcXFpWHh4emFxS3FDVk52?=
 =?utf-8?B?N0tKeE9xYnQwOHRzTE85b3RmaGUwUWVyL1F0VEdNRWF0VitmMytidUxEQ09L?=
 =?utf-8?B?cHJndzZLMVlyU3krSVF6UnR6R1o5NEt5YW00S0ZLYUpKVnFrZzE3YjVIVGY1?=
 =?utf-8?B?N2ZPZk5td2t3elNOV1dvOHI5NUcwbUxuZ3Z1aFNxRFpxOEpNeXROUXBKcjc5?=
 =?utf-8?B?anZ0cXN3RTZqbG1CNkdwSzFmUzE2TjFESFNQbC80TjY0UzVBRHYxeUt0ejJ6?=
 =?utf-8?B?SWRkNUkzZmVBRnZINlZUcE85YzJnazhaa2dTdXp6VzV4UDJ2eEhjYXJmV0Ro?=
 =?utf-8?B?S1VjdlVBQVNhYm5IcjJlZGJYaEgrcUF0blRoZXZkOTJOY2doWUZaclRNYkdH?=
 =?utf-8?B?SksyT2FKa3dVRURIMXprVWhYTlFtRitETVh5UDNwbTFCSGs3czJNRmE0ZE9k?=
 =?utf-8?B?UW5MNEU1L25iamdsQWJma29ZcU5jbHVjbnR0MHJGUDMwMHo0VUNKRWp1TzlX?=
 =?utf-8?B?eE9NS25lb0pNUDhuT0YxNWRHMHRzdVNqZWZZVDdPZXZ2U3djNjhVYm1RUmhW?=
 =?utf-8?B?dGpjdjZNZVJTdldNSzRsd2s0NExNNjVYUDBLbXMvUlhUd1M0c1MvdW11RDZU?=
 =?utf-8?B?bWV0S05zZ3owZUg2RUxaNWFwbCsyNHBWQzdsdVpzS0pGSGJ2Q3Zmc2tMSUdK?=
 =?utf-8?B?S0JDdVMxREcyL2xiZnNpOWFsWUp5WFhheUxCNXNyOWpCREtZN0huWU4wQTVj?=
 =?utf-8?B?UDAxVDFxcnJRUFdmb05FTVdHRngwZGFNWlRveWxIUExuSnlTb2JsaTIvS0pS?=
 =?utf-8?B?T1RQN2l0aDFmekZmM1I5QVVPYzVGSXNPYzZxNlovMVdIeUlZQzRoNDJ3V0t0?=
 =?utf-8?B?L25BUmQ2a2ptQnd2bFRzbVdJTWtCY1ZvU1RpNEFkWEg5cFNtM0xRN0FOZ3Qz?=
 =?utf-8?B?SDRHTUo4ZU1IT3B2VFgxZllFS0NkUXhqa2ZkUVpCWHhyNW5XZGRLYm1FNndB?=
 =?utf-8?B?c0xDZzRqeFRNS1hKNC80cFJxNFBIc2VxV0lNcjhKMGRNNUdRMzhuS28vVWxu?=
 =?utf-8?B?OU5jempSa2YwYVdROEwzbEFUL0ZhQnJwczJEb2JrdjhXemxaWlpuRHJpOFZF?=
 =?utf-8?B?RUdDVStVZS9hSnY1UFRPdkNDVlBLMTZSb2M3S2VOTmFtVXZYRUNxbTd4ZDA1?=
 =?utf-8?B?cSs1K0MxaENDcnBEV3dSQVBENUxVUEpYVWFkUFgvTE9PNEtBNzVvbkp0Z1Zm?=
 =?utf-8?B?bFF6UzkzckZTRDBoaExPTFFvcmJBMzI0RGxxRVJTY2tYY3ZFTDNPaTVtQ0xS?=
 =?utf-8?B?Y3NPd3Qrb3AvbUZLSkR5R2ltbVdod3N0OFF1WHRVdVAxcXpRSTBVU3hPbkV3?=
 =?utf-8?B?L3lObzZIckZvVThiaTB3TkQ1b1RsaHRWcWVXNGVwTk4xTmtVYTJIdlRsV0lG?=
 =?utf-8?B?TlBBNDNVVjFNamNWN011UlZlbnpqQzYyanVQRkJYN1ZURElMWURrWldlUzFO?=
 =?utf-8?B?Ty94V2hjUW42V3NJekdXYUNjczV5MlVrVzZtRCtSdWVCRTU1ckRyUURObkF4?=
 =?utf-8?B?RU9ZMXlDTlJPS3RHcHVTSG0xNnRtTzIxTTljYjhYaFRGRHdlNUJ0bkk2elhk?=
 =?utf-8?B?OHRNUUozVmF3K2VJcjVSTnFqUUs2NmwzY0JadXhXc256by9sa2xkR01BVFJI?=
 =?utf-8?B?SFVwV05lT3FZbzNuTDZwREVMWjlsUlVkUVpJN1IxeklOeVJxcm5FQVUyUG1v?=
 =?utf-8?Q?DjruQSUEBA1I9bCBd2m7DKrrqXatya4CSMaU4Tz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006)(7416006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDJyUzFka0I3SWVCNzcxQTN2Y1JCbXVFN1BwQlVaZDhyTlBERlFtekFsWGg1?=
 =?utf-8?B?ZndvaHNFaW1Ga0ppNHhzNU0rMWRWVnlXVWUrS2taZTRadkhGV215dzFoOCtt?=
 =?utf-8?B?UkhINWJjL29aWklqYVlCNjZtV2pZaVQ0WFYzQXJzK25xaDNBcnh2ZWR2ZWdt?=
 =?utf-8?B?WS9kbjM3d1ZTY3U2YnRIWklKQ0p0NkVYMjEyaTlBc2pLQ0N5dU9XeDZYSlR6?=
 =?utf-8?B?OTNkUHo3ejc0Uk0ySmZOY3lpNDRsaVovRVYzOTl0cDZxdlhYZVJscytpYlNM?=
 =?utf-8?B?Njg5QkhMaUxBdDV4OEdWS1E0VzNWNmJEbFdhZ1dDSXRac29icGhvRHFkUmw2?=
 =?utf-8?B?bWNveUNwSGdMVmRHeGZXZ2NyN3hLMXVWWXdMaGx0OGFSZHo2TzhpL05GWEZL?=
 =?utf-8?B?OTNHYTZhS0FQRmUrQlBRbnVDTXh0S1NTNVFRd1dReXNDVmhoK3JUWWNrZVVD?=
 =?utf-8?B?OTRhb29BeTJHVjRhMThaU1ZsK1VJd3NLTGNSZHpEV21hZHlYcjY3Wnl4YlA3?=
 =?utf-8?B?dTkrOFliNmQ5K2V5RldkOHhlTXpqamFhelZVcmlvdXZYaFZpSCtQVklYWnZ6?=
 =?utf-8?B?WjZMeTNBUlRoUEZObTdtMHl2dXQ1WkkrT2xvcDJLcHYrMDlrcFE1dXhOYlIv?=
 =?utf-8?B?YzFKZTRhcWhqOGJSR2cwWWRGNy9NcjFqbGtTQk11T0NTdW1IcE5pU2ZzTC9i?=
 =?utf-8?B?c2dKUS9nczltZk96NDgrRS8zTGZyWEcvRHFPWVhxQ3NvZnBaWjRxUWRiUGhV?=
 =?utf-8?B?Q2VNSDNYSFRvczBtN1pwTDZQUlNndVhMK2ZoNFc5ODdGcEhiY2QvcXE2d3ly?=
 =?utf-8?B?Mzg4TmN1K2hHQkFPNjdkay9mMTFrR28yajR5WU1Ucnk3Y3NuWTZZMHJBVWh4?=
 =?utf-8?B?SnZhdlBjRzgvSVlLOVUzL0hhU2o1L1p5UHBUUS84ZkVCTVlYNU9Sd1U4aWc5?=
 =?utf-8?B?QzhPc0g2eHdEUjFLRjY1R0RDUWJGNU1EeldpMWJnNkgwQXJ6MmZ4V3YrZTRH?=
 =?utf-8?B?cjhyMXAzWVFQNjl1b1VkbjNiZDFHOWhwYVZ5UXBsTDd0Tkx3VzlpR0VIeEM2?=
 =?utf-8?B?ellYVGZrVHNGMDN1THBkZ1BDQkJBNFNuNzF6dGpRelhSOHRLQ2hqVzFySDBx?=
 =?utf-8?B?ZjVoWENKTFd0NUZrK2xMSmF6UFUxYzdQZjJ6NUwza2V6OCtDWW9PZWZsUlpH?=
 =?utf-8?B?b0VvenNjV0VRbkl4TmQ0SVEyazlEVzVFMFV6V2N6Yzl3UDV2VTdVUFpWcUQx?=
 =?utf-8?B?RlNCOG5BelRDWU05YXN2dytkaitXUW5nZkp6Yy9KTThkMHh4TGxqaldGcGxZ?=
 =?utf-8?B?d2xabnk4SHMwNmpEZlZSQUxwbTJNVFErTDBZUDRlVlpJdzJMcHR1b2RYRW1B?=
 =?utf-8?B?OW4yS3IvMDZ0SjRCbzdYZXRlSDJSeXVmMXJobWVGZGxWb2dFc3ZnY3NBZjhI?=
 =?utf-8?B?QlFvTk5KNGJBYlRYejRENnZLaWZ2V3l0eG4wWmFwenoyc2ltL1ZjY0JWYlFv?=
 =?utf-8?B?TlZLbkZOMmt4QjJGaTZhSnFQTFZVanE2UVJUeStzbUp4eFhMTTcwdkNrQjZO?=
 =?utf-8?B?TDBKM1ZYeUkzbWxxdksrOTJTT1gzV2puQlVQNU1HbXIvS1JZbXNJQVVuc04y?=
 =?utf-8?B?T0Q1YUhVcktVa2dZSll5dFhYMURvb3lMcklnMEh2a2xQWWh4SXF1ZUUwQWxm?=
 =?utf-8?B?OGNNZStyRnI4cG94cWd5MVBhdDVUcVNTblVydWFzOUNZU1BweWhMdC9SN3Nj?=
 =?utf-8?B?TVZnSk5YK0hmdlhKM0Z1Y2tPQWkzeWZJekh2YXhENkN0ek9SdEt2a3BKRndS?=
 =?utf-8?B?SmtKWERzaWZMRGRydGloZ0xwa3cvaVIrSFZPbTBrVW9Takdwb2poN21Cdm54?=
 =?utf-8?B?em1IZ1kzZ2VMaGxnMk9wZUtUYTJ4d1NlQjlSeDl6V2RHNER1WUM1T0xPSm1R?=
 =?utf-8?B?RjRueDZKRjZCaERncmVWRnBGT3RWRFRNTzRKaG5GYlZIRUp5U1VjeUYzUGNT?=
 =?utf-8?B?ckVqeXpYN1gxUE9qVWVRTWRlNi93akRIVjVvcXZIUVY0M2tZY1BCSzJ0b1By?=
 =?utf-8?B?MjdEWFlrM3ZlMjhqT0JOSHpuYUdqYmN1bXJhM1pHRDVlMEN6TktFY1VvdFpZ?=
 =?utf-8?Q?/dDZo49KZGHHr/KEAk+whsWkl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f765fe-173d-458f-9419-08dc8ad5bcfc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 11:49:38.4362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMr+7QBXg0zVZIPjvcBrgn1UJgku4vCFBwKQnCr434m2mdZgn/+N5R/BZls4CdG7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7455

On Tue, Jun 11, 2024 at 05:37:26PM -0700, Daniel Mentz wrote:
> On Mon, Jun 10, 2024 at 5:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > +static inline unsigned int arm_smmu_strtab_l1_idx(unsigned int sid)
> 
> Existing code appears to be exclusively using the data type u32 to
> store StreamIDs.

Not entirely exclusively, but often enough, I fixed it.

Thanks,
Jason
