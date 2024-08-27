Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8061494AC;
	Tue, 27 Aug 2024 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769518; cv=fail; b=RDcvMX9dAh4CT4UNqGj5xMysPBICwbJ32RLl42AZ/b5j5/gJAmG6sz2IwXcSxO/QjT6U0FA+ta0Fy2+1awmR1/6txhh9fwoBgI40Z3C5vvdG6LfNxCYuViW3SaVgcy2E3huGEjS97oURsTXY5kkXesGQYYzlM/dGGoEel/TN+uM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769518; c=relaxed/simple;
	bh=mxviM/aA6ZZh91cgo++/0BDfCVBckJUAd93mH/iybe4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QjvbZHiS3EzZArzrrX1zvw2yns7MXjIXHELdKhOIrTBu9hPCiMmJRa+FnNb0Por7buCFskm3Fs6hmHPxgp9MbgBXWv5p5l6tjKVgZmphY/nDi5ERGVzI5cDrGpVkx8dknNwSPdvNkC+HkxFy3SNX/H3q+BO1eNH6QJ8WfCAUW+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3p1ZP0He; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3p1ZP0He"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhH8h81o/yCnH8l1Zipm8v47AUkTEY5x/+TbZqqNrsKDvaie6fa1bx2TH4/B5GyM6cpDPubJ8luQ+kZgFoJBszNIdLfLigmXfEwud/8EvrAPjfyGA9wB7+0uqSJyfffFMuJ6R9zBfGYmDRufaDr21IV802d/IsXn1mrsWBxhSv+UsBhM7HYcAQsuBu7QTwX/rq0A5YYQW0liJCwFDytsmBFCyH+lwqSSSNgIh5L+mkheXq+EY33Ay6O+rr5B1yCL0De8mKJGdGpawWmgob8N1uGZ+XuM1k2SyYXclQIl1Ri9Prwmv4EJQyA0k1daU8Qc1S7prmjZGB8say+yo67NPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYIVuzLMwnqTgRK0hLGXqVRN9m7jdDRZsJerwLUqkAU=;
 b=Q9ITsMlLMD6YQaR3JXJyHIK0b+r95FYzSax89IB+7VOb4X+Q24zM8gE38ILiNdQ6FU5PsUGuXh4fJYw9deHqgNIwRN/i3sVcZqw9AqCdKGAjYpIWomaSYavCo/LMyppODO2C6aC5gqebGqYOmorzb2e+Y8i51FAZzDyzGlYDUOzb6IacWRWnkkYQcHkpH3afnFgUBXX9bKHwbLUBkTkB14ebxMBmokUS+Y7RxFYaNByAVSM38mpKmWXfsYO0oRaqwEb1+RVivFjOkzFLBQggMmdId36K8oVSRfgho6IiRTLmV6jbkieadhoi+3G/cd7J/rIF4pagxgZOEXp81rQTnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYIVuzLMwnqTgRK0hLGXqVRN9m7jdDRZsJerwLUqkAU=;
 b=3p1ZP0HeowFnwMZhem91TaE6p5nn5XlVoIqNvg3Qgldw1ExXR2h28j4pj7IPGuDjpkPTyrZ6Ccl+l+I2JKlzTDRm7IJajcl5nKT8OAFb85VkGxKrYI7VYFMA+cNOrqBZcBEtidxU3GMvath4FFoTWw0ylok28sd80SUzKRtzaD8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BL3PR12MB6572.namprd12.prod.outlook.com (2603:10b6:208:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 14:38:34 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 14:38:34 +0000
Message-ID: <b4cc1a6f-5250-416a-a83c-24f9650b0ce3@amd.com>
Date: Tue, 27 Aug 2024 20:08:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] iommu/amd: Allocate the page table root using
 GFP_KERNEL
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <2-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <2-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0039.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BL3PR12MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: 94cde351-b521-45bc-520c-08dcc6a5edda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTRGYzdjNmp1RmdIR3ZCdWtYMjZaMC9PenN6ZFhQOUV0Nm5PcUV3ZiszZTlG?=
 =?utf-8?B?OGN2djlaWHNlVFYzZGw5WEdCK2o0cEZUR3dxM3FQaUtZbVZSbDdHZnlVQWo3?=
 =?utf-8?B?TTNmSzhzLzBiT1FMTVZ3ZWhmL2k1VXVWZUcxTGRzYVIvQmJhRkwyYnJ5cnk4?=
 =?utf-8?B?elNUNm9nNEs3eGMyeS9lcUlqYU9UeWlvMmpRaEZ5S05TNmhxY05yb003NGx6?=
 =?utf-8?B?bXVyQWEybm1uZXo0ZzRYSThHYjlEckJNeitOL2cvNEY2d3hhM3ZvUHBpNFp6?=
 =?utf-8?B?c0Y2MVNNcUFtU0VicHNycUlQY0RseFdmaGZrcGZrNm1kVUR0TkIxZUtBL0RD?=
 =?utf-8?B?QVRzRmFFRzFxbUFuZVdyZ3F5aWk0U0lUSzJMY010UTlEdkNNVVRYeW9UazVR?=
 =?utf-8?B?cm5HNGpqNUttSDJGdzRFL2hpeHlZVDZVT3JveFpnZXRQRmJrZExXYzBoTERx?=
 =?utf-8?B?dzFydlpTQnlYRmNpNTFkMFc5OElmUXJZcXRaU0NwMkdlU0c5Z1dRVTVxNlN1?=
 =?utf-8?B?dkxUdUNSTXpkRzBsMjJDdG5QQkVIRjJiVnA3aCtLSDQrQ1FXNkE5ZThOVWNQ?=
 =?utf-8?B?V3pubHBnMnFjb0FnNDhlNVlXK3NlN2FpQXo0SEZZb2N6YnJJTC9tS2lrcTEr?=
 =?utf-8?B?QUFnRFlOVkM1VEVra3RNd0owUko4NzR1SUkzZkFySVlNMnR3ak52Vkk4S3gy?=
 =?utf-8?B?LzhxL2tHSXh3bVNXaHlORkRCTTJlVzc0aVIxdENBbVF1emdEU1gxcnd3azh5?=
 =?utf-8?B?NUQxTlh2WDI3Z3V4S09sOHZZMGtpcHhaUE1rWDJOT1RHSHVjLzc5OWZyeXFs?=
 =?utf-8?B?MVgzRFFJQlNLc1JUMHZvWkxHdjBnUWpRZ1ltOG1DZDdlcXlTNlJVM0lIWW9h?=
 =?utf-8?B?T1NoSFAxMitDNHFOeUtXWGh3dFhJRmcxOXlHL2FsMlBtcXFLc0pYMGdoZGVr?=
 =?utf-8?B?QlBONUNscTF5WHZXNlFlMkxGczhzVnRCb3drUm5zc2hiWTlJRjJ4b21vSWJ2?=
 =?utf-8?B?NWRUTFRxSUFXYUs4dkJHKzhydkZxVDU5ZmdCNlZ6c0pzby9XL1ZKRjBuRWxi?=
 =?utf-8?B?d0VSbU9zbFNCMU9VYkpyamM3cEg3Vm1hNVltK252VXk0QkNENnRzZTlNRW1V?=
 =?utf-8?B?b0hYSW5iL29ZNGhSQlRUNHVXVGRvMmpUaHlVSGRqM3VpVW1KZitwUU00N0Y5?=
 =?utf-8?B?bXVab0F4Q3JKZlBMNVljSjY4aEFYUklzMlpPYlNNK3grL2NMV1FjMjJ2ODEy?=
 =?utf-8?B?YlhNVXo1d2ZBMXY5L0p1RUZVTko1SDQySVNZU3VYSUVSQ1RndjR4N0I5ZUFa?=
 =?utf-8?B?QW1UcXM2NlNCZ1VJN0l2OFdjd3lvZ2ZlRTBrYUJ1aDk5ckMvbThIMHI4bGh5?=
 =?utf-8?B?MVpSOWpzSWd4d2hLTzg3cTc3LzhYL2MyMVZzbE5sMUl4cEZudkx4bm5jbGp5?=
 =?utf-8?B?QWthR0V0Lyt5L3pvZjcrakNHT1k4Q2N5N3RZT3pOcUpJSnNOZWE4d3k4cVNT?=
 =?utf-8?B?V3BJbzB3WllocW1CaStRUmgvOFR5cCtpSXAwNFdqSXltSGNkYVByMGloZFJD?=
 =?utf-8?B?N1Fva05adnJQdUtGU3FHR3VBTUJkdUNRVUE0QktYMVhkeWxKUWNSUG5iVjFR?=
 =?utf-8?B?NEtLSXg4VWhSNWVXMTB3TFBLdnZibkNmRmhqWlJra2JQaDJ3Mk9HRlVKQmNP?=
 =?utf-8?B?ZVNsSmYxZXRrRkdiZm9STEhwZ0R3cTFnK2RDWHl0bHQzZGU1bGFNVHk5enlv?=
 =?utf-8?B?VTlodUExM3JBUVhocldYZVdiVEc0UDRwMC9zdWh1M2NocFVQbnoyQk0xTXV2?=
 =?utf-8?B?WmdBNmxvVGFvNlQ3c2dTUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXRNYVJhRmNicncvajdTSHBxT0NYU3N4YU9QcWhmN2E0cXlLcytlcHRZdWpI?=
 =?utf-8?B?b3R3SzNtTnNPVEhudmN1dkd2b0E3M2h1ejd5Ujcrb1hDcE5zcHFZcWh5N1JQ?=
 =?utf-8?B?Ui9vb25hRFVpbzNxc1diUDZ5RFJNMmNkdERlV0Zlb3RDUlQvcHdLOGRPM0hp?=
 =?utf-8?B?bXc1TDh5aXNPekRmSkF3dWNPNTQ1YU1DTVBMNUdoL1ZUYkNaODArYndqVFN1?=
 =?utf-8?B?elo2MVVvbTFEYkpGemJ1akdlcDdVOUdybTh3OW02NE9uU1FVbUFtU0Q4aDcv?=
 =?utf-8?B?NGQyNWQyMUJUK0RRdHZQa0NVb25qa2FWNUhmanBCSUk4NTgwTzF0YVRSL1pI?=
 =?utf-8?B?TzNyTjhwNjBIU2tyUjQxbnJ1TlFzZkdNdjYwcWY4S1JYTGU3ZDIxWjBDeGov?=
 =?utf-8?B?U085Mis5T1c5c01FNW5LZkxkOFh6bTlad2FzYjdyN3F3aWhlSUpFSldEcnA5?=
 =?utf-8?B?b2RDS2Y4NERObFQyWHJBcWtIR1JBaGliODJ1WE4vTTk0MWwvMkt4WlliR29n?=
 =?utf-8?B?ZTBZZDhoeXovT2JSeEdUYkZ1Qjg5bHowclhDK1hTM3BONnllTmQ2Vkd1TFQ2?=
 =?utf-8?B?eHJoNWtxWDBpQlNsOC85MnBEVVRwWEx3RHhDWThnRVJKdWh6ZHRQR2ZhL3FC?=
 =?utf-8?B?SFV5Nm10Ry9MVFlydm95aVEzNHJoVEZXcFMzMkNpVDNPNU1xbzY5bmw4RnBM?=
 =?utf-8?B?aXZlVXdVWDgyc29iSmNCNi9GbDhkOFY2YUVlYWdMTnFzREE2cWlwS0IyMDd5?=
 =?utf-8?B?bkpxZXdUd1o4ekZKMmZ1cVU1QTBVZDlObGtmeFdLUDNtM3pRTUJ6VFZkVEdi?=
 =?utf-8?B?RE5aWlUzem1WM0FiSDBMR21BRkVrakwxM29kdDl0czRBam9uUERIem9kN0Jp?=
 =?utf-8?B?TmtGVlNqUlZzdVVEMEVUQ1B6b3ltVitCUUw4Y2FVUGJQZ3VhaDlJRUhzczY1?=
 =?utf-8?B?cnhPRFZpaEQ0UVdWbm1kb2VTeVhZRHR2UnpkdGVMVStDUEtUVk9aY29LSS9j?=
 =?utf-8?B?SDNGdTlKelhOT3kxSSs2dXB3SS9XL3llQnQ3UTU4QkZpNStVTHJraHVQTVN5?=
 =?utf-8?B?dG5GVTdaOVVzTnV1cFQyNmFFeUlzOVhpZ0FDcmhKcEtiaDV6d3BJaW1lcDBZ?=
 =?utf-8?B?aHpRd2VXNHh4SXFBZjY3RStzbDdHTWlVNWsxeUphKzk0Ni9selpyejgvdUU4?=
 =?utf-8?B?UHpDUTUvTWc2RmFnZ25abVZ2MUFUWllJZitWYUFyMmpQT2EvbnMybWpleEEv?=
 =?utf-8?B?T21CMGszQUxLbnRnc2pKNlZOSFl4T2RHR28wZGtUbEF3WURwUU9BRzdvcTFK?=
 =?utf-8?B?aWFPcmxyWUk2eVVYdnR0bmN1V3BhTGlKNzZHczVvNXBGMzlRZG1mOHlOYUZQ?=
 =?utf-8?B?ZTJQNlBIeWRDWkJPVzRtSllrSVFad0VaamNlQmY0Y25SRkt1OEllVEVlT3VT?=
 =?utf-8?B?YmIrM0s3aDdRYTZ5bG5GZDVkQ0c0REpjeTFsMll3ak9BTTdxZ1lzcmxBUHVI?=
 =?utf-8?B?ZVhMQlhTTUUvOUk2dHBGVWwrTXZsbllPODNzcW91UXJiYjV2UnVWVUtQUTZ1?=
 =?utf-8?B?dDJ4VHpjbG5aNFp5QmNyazg5WVJVRlhOdW0rbWdRdGZrNXNWM3pjNHVyMFEr?=
 =?utf-8?B?a2RUUlRjQktVei9PZVA0MXBycnM3V1A2WmlvOFcyeFV0eFhhcW9JVHZvN0Rk?=
 =?utf-8?B?Y3JWbmgyaGZLZ0hMdjg4MG05VVFWRzZkZ2RoRUJzcGhDR216c1lJRFgzd1hx?=
 =?utf-8?B?UDZUUU5hLzV2SnFESWZLYUNKcDAyNGg3TnZTNURyZ2ZwRWNtRUlvODdFclBh?=
 =?utf-8?B?VHVpbjdjSkVUNVJkcnlCYmRkMTdmeVBsSEZFdW4xMCtUbTNwR1FQeWpjL1RN?=
 =?utf-8?B?M2NocU9mWHhrbXNRdkU1UlB3SndNMlcvbjRSYUNUTXFrVkFyNnJWMjJGaWlK?=
 =?utf-8?B?eFlmRkIvY0trbGZxd0svVEtlb3FWK1cyOFprbWhCMGtSc01VMk9Qc0swMHlp?=
 =?utf-8?B?UERoTTdvZk5POTVINzdxWVgvTVVaQm5TUkdmUGZXNW9xMG0vOWpBS056ZUc2?=
 =?utf-8?B?TVoxdjVBTEpKR3A3ZjdvMjRQN3RRZXlhcE44aDdabWRsN3pDOSsvWmovSjBV?=
 =?utf-8?Q?arB41jMCW4cfk6qWVz7XTswa0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94cde351-b521-45bc-520c-08dcc6a5edda
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 14:38:34.5994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIWQ6FrtE9VGmorhytx8L4Dws4Sy+jgIdzUNGG/3+Z9R5VEK8jv6IHYqY4j8VH/r549bU/6hVnizoKQSQiOyNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6572



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> Domain allocation is always done under a sleepable context, the v1 path
> and other drivers use GFP_KERNEL already. Fix the v2 path to also use
> GFP_KERNEL.
> 
> Fixes: 0d571dcbe7c6 ("iommu/amd: Allocate page table using numa locality info")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant
	
