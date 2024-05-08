Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FC112CDBC;
	Wed,  8 May 2024 18:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194666; cv=fail; b=iN20NH8GOvvKXEQnzz/HaKwxDSqcSIQvkbNRdHRaE/JQbH7o0/3+YPKy7xsFAeYnD6YjoPVnEVoxWx/C7jHllIxe8dGmzm/NlXCsrTNc8NYfSVzljVPt6/i19PY4TaluqFuxerGUHa0CjPTj3qZDKQe+mpOA2r4jqXPCC/vrJf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194666; c=relaxed/simple;
	bh=e26jlwQwGvQkZ1PtUdcc4X2N01xFE8RxX72+hlOfAnw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=P1t9t3bW/v923ZlI9OxSZp5Ot2FcAIEMn5GKcAjBlEcGkjDDEcEX2JdUd74ZpjVDiPdEwGmpyUIbdLeYwexRnYLs48XcFaDnhMVeyxv5aphrF6K5gsZ40/FNvcpuVvMvBs0jW0GRSlpe0GrT0bupIIg7SO9n3s8mhtQNb+lpV9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OWTY3kMg; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OWTY3kMg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIj07ZeIkq/HYZv/uRbPc8HKctxj4qrdUSdbsuql4IwM4XXaDCbo3eUqa93pTY+tyJpPRcmnztWvUkOKT8vz9qV235o3d+jqlrVQS4nMI5c6grJqS2Cvk7UmZGnhb4vA7IngKvXcDWsk3ToXg5PuDIk6LCHM4N2PSimLVjBAq9PNAnIhYCdS02V8YYDud9fx1FQflox1U8XUiPWn8RpYqqgDcRxp/tr18YCO3Zlb2wn46JAzSmzZPAFU5FVmb4qGJQyP6xraVFq1IuAmjdGN2ltaNnjoaeVPJLcaNoZ93AmX8WO5FLd6usaE3piVDW2niAQe/PPKih7b8u00W/Ltiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4d8XVekxprJ04e7DKtnLxAR7ZpD4/g4yCeLgjq4a1Q=;
 b=AI8di1+KV7tNP+hUmDrvLKm4479jlOAuB1Z0xzP+YbToRa2vWO6oo1Spu1vujFBvmtiPd57+uFtncesxddnlMgwc28ayOOOxzsbO8mKqs4iOpiTPDkrvG9z0lRAJthWFt1HvCmQhhj2gpdyW5Yqc8xlXB3xsbbav//N5Q+qqGBmPf/Nm/9Wdqhjzn0qNXu2ddgP2By14yAGKvy5OgiU8wHzOeAl6OwmTS2rHaybeanuk/6iFhlaNDFGY/C+Ry8Nzo8iPpDdTAXyHhHZYPYkkRJKYqKzcA+HR0fyPsLJsUF1/MxLzq67WusDWhk7RUaIUABHKOdMtMc74WwIiv/x5rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4d8XVekxprJ04e7DKtnLxAR7ZpD4/g4yCeLgjq4a1Q=;
 b=OWTY3kMgJjlpaprordfXottt1MDKCi0xTtALFXW5mFy+rTGqVHu66YxnwNvsGjkf8Gv6CXkmRscrjeV6arChjd/ZHMGbxIZre22ILuBmGgsH/sw8FcwJbZsvYNDDOIj2pWuIB+B2RpGXKPB9Pj4/dV5/AGWzxHiAPqHiDffcrDEhH5c+uyQo3VkvWn5Cy4ecn1bucFtXn4WEhuX3f7uvliEX3NIMHIPHBiTStC2qXe1afIc27hza/ztlL7na38xC43E+c/c6mKNtTaGcx7TyJ92h9NzCfQeI6rYbUawiHFT2bMtP953wJEmSD9aYsXrOId8/DEzbLaJ6OzwHqiMCBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 00/14] Update SMMUv3 to the modern iommu API (part 2b/3)
Date: Wed,  8 May 2024 15:57:08 -0300
Message-ID: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0256.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d34f1d-0075-49b7-a950-08dc6f90b3f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5UsnbTWHV17vybtPQWBe7zqxm7kgciZKqPWpkolrphBmflF8uFeqIIFAAcrE?=
 =?us-ascii?Q?nZKK94lKw9v82bwHAxVLED/6Qgdh7wq8qBaBEM/9MoUjxa9LKxHSz/bsBIUo?=
 =?us-ascii?Q?ChN38Qoc+WBX8zivmTERZxvkkknrbteYfQK4yeJ2Gv3gbfeb6vK05rTv5AYw?=
 =?us-ascii?Q?lsFrsPseNcoTfVrh0cxI5YS+CIrpCAowac6SH6znLyQ8fkbddslwZY6t8UTc?=
 =?us-ascii?Q?Y3i0ipMlbNk3IrtesQZFyYdnv7AFe632fnoYJUirvB6iaiUlqsW0ozjvm1q3?=
 =?us-ascii?Q?FvCgVnwz2Go9zjnebabXts5hBXV7fy+saZUHejxQKM5zypFj0BToAyX6HOFR?=
 =?us-ascii?Q?HBwdjVt1wxuFD2mFTizm2/JAFLJuTCAttxhOztoN1UEpdZ7cbWGjrDrTnDM5?=
 =?us-ascii?Q?w7RGo1ZbxwOqzAKuNKXEZxE2Ji4ISseIOJgS+sBTXMDdvY91JXHau8cImzTm?=
 =?us-ascii?Q?Z8+YY2TNlnxYySt0Fb7BTAAr+rRr/UAMO+9TwUhJYbtTanGMaw6Idu72kFx0?=
 =?us-ascii?Q?P1EnZWLp1ebdfTHtN97kqka9mLlhu5oIFZm37m2NXJg6t8QPGbI9CmgTmdKn?=
 =?us-ascii?Q?p/2gJa/lk6kjlK16Hk/XyPXArPn1edXPqhMG6BxH5h0akgTcjkSYxo6aEpiZ?=
 =?us-ascii?Q?x3AR1k+kgPCpaMxuQQyonD3PndcVZ6lJQ6vS7xa+lMd02yzUi/OBnEaalCQw?=
 =?us-ascii?Q?dS8Hiz9CqXBfXedlgynS0tkHBzdWdGdyXvcoRGd9gHP5TQ7DPKVeC2RMSNiH?=
 =?us-ascii?Q?+d2Ctm0LUBlef2O9973pEgJxSl0ebR/K7gQkg4Nlde0zAgOfhbj7Eh+Cfti2?=
 =?us-ascii?Q?OrrtnNoKJne44/CqFEHuNPr3CaSFzOEn3ZAIQtVEICGqcdKqNMOPYFZfqtAR?=
 =?us-ascii?Q?lgQkMhCneaoc6fNub0MZG7gVughRzZpof+MU+VMAKyU9Xp7sUaIdzhVhOUt8?=
 =?us-ascii?Q?Dd0bd8WrPRGRymqFbb0BQs37wKFpdiFdZ6BjhFp/xVI4+rInV+JnUlmxgFgW?=
 =?us-ascii?Q?/Aje24DqPKOOTfn7JqXYJE8ikkRESQNAvB87tONIF4DDj+E3l6NdONOkhH10?=
 =?us-ascii?Q?ymrsTRmgh36/WByd6QSx0zZ1w3adCwKaxTMYaw2ff2hwQTZOSxbvEPBKAXFw?=
 =?us-ascii?Q?84hvjl/vTktXiXn4qhoBO5ClyW2lD0HbGNSEKxHNJVn/ILzpwFZGLc2wsmU1?=
 =?us-ascii?Q?j2XYE5JVmPF6HilAVusn9jcXQySW4iIteMYxwMIM7ry6aoBhW4VOH4FSqubA?=
 =?us-ascii?Q?7MKuXTUDf/Ghp134DxWOZ9fgEr8758TWdqzcwpNu1TKgGfliWKvn9ecazrOj?=
 =?us-ascii?Q?P2Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yuynd2NFrhjylQKO23d+QQrAskMCDQHus18X4kZyMTcN4jhDZa40Y8gSL/sQ?=
 =?us-ascii?Q?Uf9YfREehOdpmOEEFgZe6E+mZUJ1qkF1QVWDpeiRqDc1GcH4C33YSFpdKidD?=
 =?us-ascii?Q?vmPxnZTE/wZQF4d9wRf+cFFQ8cFYqo+OFhDpmOMmK1Wgb/E3eOc6ub4nKQP3?=
 =?us-ascii?Q?d/b6QT6pKURpzF2TJA/V9pif5wjyxdk9jyOIIVy/m0CVtlTyBtKXm1QhTpt/?=
 =?us-ascii?Q?VN/oaD/SwB+aWDQGNGQ8rjXeI3FPAhXHdra/9X1Yuu524w09F2q8xhCBeFqH?=
 =?us-ascii?Q?VrZJ1vVrGWWtrhj003PU4DmkA8mzylXd9k+Glbv6Tl3+dvWwXTuSH1G5lLy2?=
 =?us-ascii?Q?tiS2VCORa4HpdkDNgX6jlefLUlTso4DXXsHmEhxxX0ydmhV+iMeox1skr/eV?=
 =?us-ascii?Q?XkJPTdcwXp5Gk0bcRdpG7+QfLNT4Lv1FQybulT0bDK3mIH0Yn8L6Oh5nsEr7?=
 =?us-ascii?Q?/68hG9ujtOU6mNSSLgt1rpT0lgCSmjES8p/fluxaNYpqrR4AozwyqBTFeXf6?=
 =?us-ascii?Q?azX1gsyoVRK9TVQCmYupXKzhrwKYTcjFOswaS8c2nFVSqdfcC8Bh9Gfzlmh0?=
 =?us-ascii?Q?5OH8jV7APsu8wp40doSQafVTnntPOI8+kXgdWh9DDSIZsBJJ3l5TTCaWsL96?=
 =?us-ascii?Q?Ghk+sLae3+RPmHO3CBvCm0J55q7bCrEXEo/iqzgW5490XyhIZPD881HTHFtr?=
 =?us-ascii?Q?yjix2mv37d9QBW4ocCZatjAcooSGdTXqrXqfY/BTIyw9qsjTgDGwnM6Hx4nN?=
 =?us-ascii?Q?dEfUKy5TriQBE/irsmzig2X6cu+xhAuQgf0jyCMIBADhnwby+O6ovyZF3s3o?=
 =?us-ascii?Q?VAdJgIRxLYOgShdmsa9U+Uw+QdzIYr+G5qw9ThgXnQ84rArmy+C/FWaYBu+G?=
 =?us-ascii?Q?gfroj+T+uiYwiJmYZ6m3PSRHguBv+Zxg9db8RBaQ7G1YMrTPiaZGQeucQDsf?=
 =?us-ascii?Q?fuJSmvG4a4ESkoszyXyiliFn5mlLjXOo2SfVimeLpA5CL+MNcH+qK4Y30fRG?=
 =?us-ascii?Q?xxxhZgEkDFRs92qdZeANu9PPM1YgA9yKsq3epxsCMeNuBnk4sHQPO9hGJRZY?=
 =?us-ascii?Q?lHo8GpcG4TTNQfARoulbXksRhbwjoabRCQdSffJv+XBzyQUW/IrQLknZ2js6?=
 =?us-ascii?Q?TyP4lq9+WWku+LldAgReCyIwusBJ5+6f0OWFwqgLlo54r2jIHw93iNyF6wFT?=
 =?us-ascii?Q?e1Qf/UVBsV0lHbeBtn00UoyTufztQBUkir1s3ZTFbYH1Hp3QuE08D4S4CVC7?=
 =?us-ascii?Q?hwL2iFjJdTG8y5/aTkfuWe4uSRR71FtPQgIAyKoRZ23GJTuit7NOcNIhpP1p?=
 =?us-ascii?Q?LRS/wVp60/eWI8NeY5d5v24KisX6ls3sjIq6xzKS4s/iKB9WCJ9kIv0bB5Wi?=
 =?us-ascii?Q?xvdV21Gy0J4hLW2zHHwoE15iSxkaVdGQPKRL8Ckmm6uHoomrmJ2v6WwoKIk0?=
 =?us-ascii?Q?fcTTZv5G+jl3kDwS4B2fTGWEAjiPcG0QRiR06iQ9PNvBi6ZVF9eyWoIxMr5+?=
 =?us-ascii?Q?pN1MfYGZuBo5BlsU6OEeZLGlQDYolwgHiTs5DnADB3cubsi56kKRzSp6JwnC?=
 =?us-ascii?Q?4d35iCLuuPB+g5tEM7wUmHfGKBIm2UFvBprlR/ZF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d34f1d-0075-49b7-a950-08dc6f90b3f6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:26.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxEg0B4p85uWNtdVIdJ5QG4BIQNQxiRcKU4bzkuhHUMeHDogY85c/NohS2PV1+2U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

Continuing the work of part 1 this focuses on the CD, PASID and SVA
components:

 - attach_dev failure does not change the HW configuration.

 - Full PASID API support including:
    - S1/SVA domains attached to PASIDs
    - IDENTITY/BLOCKED/S1 attached to RID
    - Change of the RID domain while PASIDs are attached

 - Streamlined SVA support using the core infrastructure

 - Hitless, whenever possible, change between two domains

Making the CD programming work like the new STE programming allows
untangling some of the confusing SVA flows. From there the focus is on
building out the core infrastructure for dealing with PASID and CD
entries, then keeping track of unique SSID's for ATS invalidation.

The ATS ordering is generalized so that the PASID flow can use it and put
into a form where it is fully hitless, whenever possible. Care is taken to
ensure that ATC flushes are present after any change in translation.

Finally we simply kill the entire outdated SVA mmu_notifier implementation
in one shot and switch it over to the newly created generic PASID & CD
code. This avoids the messy and confusing approach of trying to
incrementally untangle this in place. The new code is small and simple
enough this is much better than trying to figure out smaller steps.

Once SVA is resting on the right CD code it is straightforward to make the
PASID interface functionally complete.

It achieves the same goals as the several series from Michael and the S1DSS
series from Nicolin that were trying to improve portions of the API.

This is on github:
https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

v7:
 - Second half of the split series
 - Rebase on Joerg's latest
 - Accommodate ARM_SMMU_FEAT_ATTR_TYPES_OVR for the S1DSS code
 - Include the S1DSS kunit tests
 - Include hunks to adjust the unit tests to API changes from this series
 - Move 3 BTM related patches out of this series, they can go in the BTM
   enablement series.
 - Move the domain_alloc_sva() conversion to the first patch, and rebase
   on the accepted core code change
 - Use the new core APIs for the PASID ops
 - Revise commit messages
v6: https://lore.kernel.org/r/0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com

Jason Gunthorpe (14):
  iommu/arm-smmu-v3: Convert to domain_alloc_sva()
  iommu/arm-smmu-v3: Start building a generic PASID layer
  iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
  iommu/arm-smmu-v3: Make changing domains be hitless for ATS
  iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
  iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
  iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*()
    interface
  iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
  iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
  iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
  iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is
    used
  iommu/arm-smmu-v3: Test the STE S1DSS functionality
  iommu/arm-smmu-v3: Allow a PASID to be set when RID is
    IDENTITY/BLOCKED
  iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 434 +++-----------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 116 +++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 534 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  52 +-
 4 files changed, 645 insertions(+), 491 deletions(-)


base-commit: 6bbed5b0a211d926fe494b722f5198a82f58a5c9
-- 
2.43.2

