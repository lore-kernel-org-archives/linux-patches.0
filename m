Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990EDF9EF;
	Mon,  3 Jun 2024 22:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453901; cv=fail; b=nHIyBXOjAAm0RaadV3haIcubTFAiNGmWipBSaCBVHvhdajNxCDv7EYJxXP6MWFLTykGnv3EHy4ng1zvQ84+HITqYf2urhWXZA/ZX1f8LWHMMpwwXfQpDo4C+PP85ygm8lUiN1IAjsx4tJRdDT5B0metQgnJ+PX57b4Nd3Xpis6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453901; c=relaxed/simple;
	bh=zO4soFzFtps3p0VnywdvEluJF0n/YuNGW38by9G7BEo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Nj3QqKiFlJZqUVtaZ9fPTrRV4tiePJxWqz1ufSu35ZzbSvbHrKITJ+s4h2o5yPqCOisYG6vyz8yaBufgogF2qSKaXvgTjTV2DW6jWbhYrj4cTci+3uFXc6st/uPJh9JzlE/UZwM7NnrjQCeuPZlZV2sYJCOxl255b43391kZXyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H4pK9WQk; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H4pK9WQk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEWdTCxgq8mnOLmY+OV+Er1RxTklqoLvFO54/EqAKu1/0mAaV7iESNZZan+ZyBPFSrl/L8R+OWuqqs163pFAT3WCYxuxcj8qpzk4fB7y4iLypRqQGoXL/oSAcnPpn+k0K4/l0R5Pa1yQQGiBG1SIr66nCGGcmVUMv/WTNz0XVSyfRMVI/SgIJx/qHGJ0XvFmNNPBfl5GGRYiX/QxmEkcmrbSlgvxBibxFOwoUaFNlmCI2d675Ui+pmGGtTBPxf0E0H5wzrTaxEXEZdATeeuM8/cWhVRCDjApWhMNfip8HsZmtZ5r5ve4DVJGrq9OUQ4h+TnR+f7sAcnEXtgXJP2u3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cm/PLX8K+7cT1j7xlSrZuZNIM0h7fLcJt39pxErzC6g=;
 b=hFOn6rk2vuYYNnTH9rLUb76uH26P83cDD8hPnneqDpbm95n1IO0Fgcq/w8dfRfEYyD1iTZFFbFR3RjzMs//dcZBNYclSaSLXKqchwcGmWiUN0OBkNh3XICUz2KE/7THtnFZNsNH5ZQIxhK5N57lzo7nTQcFC1Y3WsdIlham9eWHr4K0xWQNavzd7W5BdpEm9dsYZTVlU/JXVcLiyDu9uHz4Yek0Tog7mQBoNCttVJ7mXRoWkQIpyf29/BnyyPygJXw5FBalm1+33qJ6UgYkNixua3gs8353a+msGzXZECvrHb289GdYd6xtWSH0Fv3JwvSyMSx+NjaAUmMMr/Y1gHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cm/PLX8K+7cT1j7xlSrZuZNIM0h7fLcJt39pxErzC6g=;
 b=H4pK9WQklrtEsgJHQXiDBpl4kbqayiC67pnWYbQDalGv2ikUEQCqWq9UICfg6pox/gqIaV/jMt4euWRHLsMqgYXEctMRZyfic+Ps6pIRwvoYrdIZMhbp5Z2GwsU+5ZdEETT7CjaIGlR5iSic0zjh7ivoLohcz4tHu//HASfB8mR3gJPLGrkvwWGwstoVeaSHJCnMDHc80WQQee+nxMSkoy1qWCNgF2m7qp7/14/XDtOu2zB0d+Uvv/rt8bTAkyit8oJsebA/HZOp2hDOA5BFWh2mAKNrwS4V7AcFAEqTELyrY9dT8O+/NOAm3bYfTPk5+e5kZQkYzPF1xPpnbX8GIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:35 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 0/7] Tidy some minor things in the stream table/cd table area
Date: Mon,  3 Jun 2024 19:31:26 -0300
Message-ID: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:208:239::30) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: f9919bc5-20ce-4042-b615-08dc841cecea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r+Nvppe5n/MYjuJpsUYbDumcMs1XiWr7X8h0hNhAiLQaR4dte4dMbBveN4Cx?=
 =?us-ascii?Q?nIalqGObS5g+a7rX0iYyF70ChqL84JuZT8S6KTJunSr0YV4LrN3KJY75qS/A?=
 =?us-ascii?Q?sbw9rn0MBizCgCcv8UD2W3DZTaeTYIKP1S5pPMx+yQUsbsXhNhD9gtaiZ6JK?=
 =?us-ascii?Q?StFIOOeoai5/7pWiWA4b75/N+m+ucX1tcCXjxpgPnV+Yj01DNjvi/9hWc2mo?=
 =?us-ascii?Q?+gNjGFLdQj300aZ/Scg6dwV7itP+Ma2+IU2mBVWIYNwYvkRv8vTKzRqi/eqH?=
 =?us-ascii?Q?RM2/HZSKAMC4FUi1Aa56rbvoqWwFT3DyfG7bw8HT2aVRS/90B4s3vI5GJhZx?=
 =?us-ascii?Q?x25dxH/29ufnqmyakXnJw79vM3Bt+JHNAlaWqU0BpXt6loR2dFkIE8oF2k3o?=
 =?us-ascii?Q?oYV0f1npmjdoPOyzQ8jJy86RiyXKjkJyNju8NYs+hrLWUMWzqKiuByWLVkgH?=
 =?us-ascii?Q?x6n8zYLn1rlI3O9LoIlPSSo2jmC7xk12RVkFErtBWp2sN7fazZ/4nEvbAL6s?=
 =?us-ascii?Q?7NFwnKEGbwDSOZTFpNWKaazPY5+WV0//BsjA+/wpf+eAqcddPwqJbsmdco5/?=
 =?us-ascii?Q?mN1Zn94mlkPfNHh9bpcLnsw9R/bO7WeeeFamA6+TtYIDBQgQpvw3TXkNagBs?=
 =?us-ascii?Q?bolHDelxxuOaVqg7OZ1qyyJ45UnQfrc3CAaOButHKsDSGxlajaWEg6K4qdHD?=
 =?us-ascii?Q?IrCn4amqi19w5FPMgKIXtmw/WtkB4lgV2Vm0bvQXZmbyVXjdFC2zKoQcNJPd?=
 =?us-ascii?Q?ny3CyxuV/FgPiNdxavtX7UgUmAtSktw+WYp6RQM/idsZtDPzUAC/eFJtJBU+?=
 =?us-ascii?Q?AF7+oUtL3+8/ovW6GUOWMLRRwK1mhs/Ra1errTNQBBpB6cfV7uEUiWl/vQZf?=
 =?us-ascii?Q?R3DnO6+2ggfAYegz+LrtdC4zLtIiEG9wZvzleHWMYjjYLY8XTa4IHCm1YigI?=
 =?us-ascii?Q?982ZzvfiVggRkpj2UsFxGiIWkCu4RQQAv0qwkUY1jjzvilDzJKHQvlq1nG0W?=
 =?us-ascii?Q?IqdzY6HSHlhlq9H28lHt7AeL8IIHlVbr9TR50gS06BtF9u+JOnKm1TRFkNNB?=
 =?us-ascii?Q?k0AGP28VQ3FGJM/RcGO205enKTpGjPmU3+aDjlpL9A33rSilieSqXJkgcfcx?=
 =?us-ascii?Q?w1BTpI+cqmr4QIDr/9eXfua8qebyuNO4KRz/Yj6iyRmHe+9F+uis2rymWl4w?=
 =?us-ascii?Q?C02d9dthrxnnVzmFf7SzZ7MOCYHKBoo2V1Dbs4ICrtymOoHZ6nJPUh8nPCnw?=
 =?us-ascii?Q?ghblBStrhcM6FDgvXA93WayDeG9Y0fi84wvSd868Zw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2ueU3/H6NfkqR84pJrAdfjaFgGfHPRkZvk8y9UBMsBetQDju/4yNX6MYcpMc?=
 =?us-ascii?Q?kz6enuZ2RThAVa7Zxz4eNVSrgmfxteit9LHIMTZ/I+mUT6cYRJ8eGqpahBsx?=
 =?us-ascii?Q?VYPHxM6JJh8d5BGW6AJw/WcGUXSY6c6Ag4UmnD2JaHj0NdQPp1Qe72uZQE7h?=
 =?us-ascii?Q?aUIMt9MZsb1rmNT2FdAL8uALHN9Yymo6n9zzg4YC3K5LYG2Ntwdn0MMzPA/V?=
 =?us-ascii?Q?HaMmC0SWO7x3WGolw4aWwlwac1gBG34Jff264rVFbWzrFfjRNkQxx8awde+p?=
 =?us-ascii?Q?nGxf0c5B6pW7sTzhg3vB6bjAPSkvIdaZHjGA12YOhqZlK/PlSEJO3VYIia20?=
 =?us-ascii?Q?xK3xuFwg+UkSx4CcL20fOv2b7Z2KlfqkXi5+W7l+j4aELBcb/W+GI9/0f0XX?=
 =?us-ascii?Q?AIGbmfLXlX8mGwF+cyG3ta4y4LwjDZeIKjz62NlDEYUfTc6ZHA5CpwlBaUZM?=
 =?us-ascii?Q?ANKqdfEo8b1SyL76N5iTmnQq+3KuxKMHQJiWzMrJbCdz3xlmmkkuPxBfupEJ?=
 =?us-ascii?Q?GOFpXmi080wcRrtmmryoqS42w4lzBDYNJifpftRhPtqHS0nd9/I9q1ML5n9i?=
 =?us-ascii?Q?SvS3C6JRXhlQZmo5Y8a7B+lzErPWl3+ENthM4PW4+NxEHy8u7HDdYlrCTvxe?=
 =?us-ascii?Q?zHVIVt1opyXGFYXYuyU0wFL+y0nR8dVCrAwLsbe+70l1Q2PxV5v/los989Y+?=
 =?us-ascii?Q?xbrt/BWFshVuZMg6AicOc9oRzGOnXQkj8ZQhwh6/rwLJRVxCQ0BzGqhpEAXm?=
 =?us-ascii?Q?AsyShJHWSb4aNiBVzEBAydDVytvJfd18ysqK2J2lV+MyKEmyjUagJYm29zEP?=
 =?us-ascii?Q?+8djKq7JABbfn+9Bz/Votrh9ctM7AHWOVshvoSKr0wqYWOrCJ0UYa9RRUGE0?=
 =?us-ascii?Q?BlF6b8DMsOofO3UqnSmMUcMcerNjqyXrPCiK/XyO+ZFEBb35MLB99HDh4YvS?=
 =?us-ascii?Q?5rMJg4PR7WY7QiY0x3+QmfFEoz6gb52tKBJCHw1bYRn8JNc0CmR3lAyBOEXJ?=
 =?us-ascii?Q?iai9yK4WTxCdcJzE4VlDAa7AjBa3Jka4FhF888bx4mO3TV1xvIqlcoX3rt5U?=
 =?us-ascii?Q?gMyB4r8TmIWW6KVEmnYmS0p+h/DIS7vp5R7rAv97/Hlh659SXOwk8CoQ5JDS?=
 =?us-ascii?Q?WIIc7M+xygobVaeFR+e9r++rgDegy/6IIGPJaTfV+1g1Dplg993xUpapB5Gt?=
 =?us-ascii?Q?pHOVDYO0aV+zOEd4NcsXWUwxhN+05KKMW8QmSOdQKv7vWkbBEoI8zu2pTSyR?=
 =?us-ascii?Q?unxnAsW96Adt37XV/UXSBih/dK2eEkSS9SaGC7kYPEL7Mc4oNHqqv7aIj9ij?=
 =?us-ascii?Q?lGcehLQRdp/hGzgkpO6I+6AkMBzydrO2PBSOOzCgvS09c1IHktWGXiExFqky?=
 =?us-ascii?Q?kULGT1sco9ifVI8Bo/p92gGi6AEeFb19SZMq42DgwQf+1dc0T5WUT35o55Dg?=
 =?us-ascii?Q?57pKaAlA/m4fPv3bb2+JEXfPpLFxfAXP/fGCvI1mOlDcnbMugHxj84E8CIuj?=
 =?us-ascii?Q?33EzxD5PYjL9vcFlcawLzbA39l7fSGP/7YWFWg8+jXgXyD+KD1h4T8JCLRWm?=
 =?us-ascii?Q?GS4k3LOZArWMKudlEpg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9919bc5-20ce-4042-b615-08dc841cecea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:34.9551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /g1a17R++JCGe+zVuIH7abBtPNlH+LlUV+GSYf7Lp0kI2o7v84p8B4lylG8T59TO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

Will pointed out that two places referring to the CD/STE struct did not
get the new types. While auditing this code a few more oddities were
noticed.

- Correct types for the linear stream/cd table pointers struct
- Remove redundant dma_addr_t's and save some memory
- Remove redundant devm usage
- Use the modern rbtree API

Nothing is particularly profound here, I've been sitting on these for
awhile, enough is merged now that they can be cleanly based and are
seperate from my other series.

Jason Gunthorpe (7):
  iommu/arm-smmu-v3: Split struct arm_smmu_strtab_cfg.strtab
  iommu/arm-smmu-v3: Do not zero the strtab twice
  iommu/arm-smmu-v3: Shrink the strtab l1_desc array
  iommu/arm-smmu-v3: Split struct arm_smmu_ctx_desc_cfg.cdtab
  iommu/arm-smmu-v3: Do not use devm for the cd table allocations
  iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
  iommu/arm-smmu-v3: Use the new rb tree helpers

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 234 +++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  30 +--
 2 files changed, 119 insertions(+), 145 deletions(-)


base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
2.45.2

