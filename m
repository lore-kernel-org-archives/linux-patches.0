Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16011135A4D;
	Tue, 23 Apr 2024 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878076; cv=fail; b=OKNocgpsMSYs5TGCjTAJ2YpPK4PWpItn9exvE2r9lXl11ZKI/caXHbPDiC1bZ629e/kS4sJoOzHmrK42k+zq9BgbGoaSShYoFL+SS5oIiqLCLkPIRjH59SiC+Pf1jl7fMU1WWPmLaJEdoEGpaohGnryvNyh6ywFSraO61AcXSTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878076; c=relaxed/simple;
	bh=Ol5I1nabWDh9xFiwT99Bxb22Bvmi/dEwmLN5bxfe/14=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LMOdyl8QA1ku7xlt+Tpu6+Nmy1FG4C7SGv2edE7uYYPclCodegMHXRmaBrEEDbWRuZJa0elcXjtR6I+r1TWtBYNBQpR2oF/ZuMZUCD0JXp0lPZDIMoAfTDnKAe8IPulVvaUQ4bL+F6Bx/qJ1Phjgs2/wRO/lxZSJV7gcj+OIVT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gNKnK1FN; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gNKnK1FN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xhiq89R0eL5Er705famNhbnFlEbXJRnAcpf9EXS0beeHN2R8EHULBx44gcvEGriUtDeihrnx6hI9fhjBRK5r9gs9lFb21QFqH3ZrTwnE3ywQbM74df1sb2UFh3uDxfRt7Cqkf3f0A13qPRpX/LWRGjZgBjDxIAcxMHPaRklWHV3q2fXSk5RvVqGN9NSLoQl2mIzFR1AVVib6170H75UOpwHYP8/Q96NlrKPjemnqTpUeMKmfGPf8i0yBYHoUZKMvYaZ312OPWJfQdbBftoieR/J//hVNbluMxfuR3PxJ8Y3wcwBbKzCvDisrVV7y9lbGmo9AQMHTbdFBJd+NqUVlKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XocpU0tFjlHL+rmZCrfxaLKuFktrIUjMB+U9J7W3n9c=;
 b=aS8EdnLR4uytMOXckzQx9zJlnsTqs3q8sUuU2tUr4m/Lms9Zalxrks45qYWfpu5CdUcm0yx/hEVZFl60yjPFHU9s8EAHrQUsCE6l5bfVPGCGWwBLoHIAKTK5Ij46ubTUbzZJrkEd7yWS52L3EEmJuTfpibYhof/qctFkxhUAhBb71ha/7lJFXOtfFGKepXk4rwaOTx/scOk/puEZdqloAe/WvMawrEUtNNYEF46NH9RBDlmr3GMNTwqrDMeQYwNBbdb9KiFehjqUqfDoNE1NKIrp4OhxlIee8w6GzcNQchi14hcv63yYT3gCzJ5NjgZHqECx08O+4OceYs/moJrfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XocpU0tFjlHL+rmZCrfxaLKuFktrIUjMB+U9J7W3n9c=;
 b=gNKnK1FNHIPVOVQk6dsht9rYiOGF+F2NhGI5NWYhJTN599UVhIyX1peM9JoDuPjL0r3WoR3B1UpRRQjOS1QzlOwJwGo0S30HDleeraTK5BLOCJOSAtJ+nunUwyVwivXfAuWuctg8L/WytzmHMlB+7nPwXVQn1pc/9GAaOk5mTDtdOcTReFEAsDBA43n+6xw2FWPV1kYo1LtKK8S8Rd3KpTBjBaIlpiIL+krDLpyQah/p/DCfawLctYBYKSQJh52LXzd0nIiJOS46GN84/iPVmfrN9w76YagZnIzVkCVmVUfsLjXxYQjM0GGQjdEHelV1+m0wzHC69sWqqPw6z/NV9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:16 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 0/9] Make the SMMUv3 CD logic match the new STE design (part 2a/3)
Date: Tue, 23 Apr 2024 10:14:05 -0300
Message-ID: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0373.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 591bd20e-fcda-49e9-732d-08dc63974669
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FS/FFva6/ZNSeDp94n1r8IkAyL0/Rn+p7/WY3M34k+5V8nNfnnF20b8prLQ9?=
 =?us-ascii?Q?ZDIOHTBNiIiECQRpoW6j93TKno2DYJ9a+9CnIEo6lcok32s4vfWXwQYiIDZI?=
 =?us-ascii?Q?KL/89mdWcpJ1Ar7521c45FitaGRY5r9Dzc1k0V3uovGQAOJlJz5/xkWTcM0x?=
 =?us-ascii?Q?5260szpt5eH/kZ3oMzRcemzPbjf6+ZXJCyUN1lvC2FgEHK4o/zLTqPhJc993?=
 =?us-ascii?Q?cBTfP2iQyOHpHqbDXWS9qV5SAGm6nUYQMliSbA2zh6u3XL80pfjB7w9NmnIl?=
 =?us-ascii?Q?L29Qmrqf4NyAd7RvBDgrbPFxwVIdG2RbPyZ+KI48hSKVX2Aqc6n4tHyOfxjG?=
 =?us-ascii?Q?bK6ypHQmTuuK1P6L+maRI4wrVW7WldN6Hyl4/UHKQubr7L433ctWIZUQyPKq?=
 =?us-ascii?Q?G896jHn8MSa5iPXi16kDb85q/S2v9j3TcA89f+GHwFnoJeEXaD1hggsX4oc6?=
 =?us-ascii?Q?WXg2v5aMP/DyuZ6c/csjGi/c6943Mf2c7Gx6QwyoIrCEuxz21CyrpdZmA5n3?=
 =?us-ascii?Q?8hS8s8qlAtblnX+hFOqxcCXBfgV3apcS2Mz9uuSYAQI50IDwoqyH+wwCB52t?=
 =?us-ascii?Q?/XMBkE3cMj8yBXRUEXTiKVgeC9Hh6DPjfApEDrVEm+o/XlcZxv4hRNndhNmE?=
 =?us-ascii?Q?B1N95b61VReZOz0rrgEVV+KjF/lbee02YYRzsKjToF8lX4JjcnALItTvkMeS?=
 =?us-ascii?Q?3PYwpxo2QgzdNj9HTZPc3jQc2xTQnbFCec1LQryhqgphI+UNre4J3kYHzxlH?=
 =?us-ascii?Q?U5WbnCTLSFWnVLi1cVbZ1zzrIEEm+WPPTr8PrPwoXE8gKMzcNu7K69CHEVzH?=
 =?us-ascii?Q?V5y67wbygSALPZrunSCTk7CiHLyDISb+Yh3/u77X6+JdJ6RiFStgz5+9O5uE?=
 =?us-ascii?Q?DZpJfS8v1sU4YgiOyD0iNv9oEUNKM0jG4oLBumuM38QUhty/e9LZN/zDJNBq?=
 =?us-ascii?Q?47AUOOVAYMacQlkjvP5grdnX5UNJqHjmuavdVwCDKRGk2Dv23omM7kZnLgnh?=
 =?us-ascii?Q?vAUdWG+B0j6tXh17JORDFk1moFxr8M6AIdDvOrpIAsHdI7qk+WkHpLoo1n1q?=
 =?us-ascii?Q?aRMWh6bmExIw/TcchQFUDdK5ExYED2Ss+2QZ6kl6FjaWEdntt/SBXrs/L0aI?=
 =?us-ascii?Q?LEkKexTJx1WoPB3R33eKFoV/IwyKRhu2WMJeWrl1wtIpLLlCYTZ3wBUqOlh+?=
 =?us-ascii?Q?PpltQCpPnS6h2XnT00kWHfzSjRDwvUMVkei/WhxgBvQ1UYpnaNv5c7i1b0G8?=
 =?us-ascii?Q?fqngy3pmeade+LgjAf2OSfIMUn+SCSPKlP/Wj3WoIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xDBGPfgBq9jYa3HqWAXwJo7W7QSy/frRaawJBE41nohZb3sU9cvjVmz0aiZc?=
 =?us-ascii?Q?DCfRfNQNEOKBGrvnzlBdG60XiC3eMtaIcUiyv7c3A/7bdlq+IotidA9ezgVV?=
 =?us-ascii?Q?5FWEjStkPFO1H8hOK+qcNl8T+p/kvjGzmkAl/Cox0QUPq0iGmc8b38q++Xzs?=
 =?us-ascii?Q?EeIaeBvP7cAwrKxQ26RZWueK8zgIfSlUVdp+MDUwtorRKQLuR5SlttwlfA/W?=
 =?us-ascii?Q?u7Hzt/fHEpYbCzfUwe4UlgmA+MAX3fR3+rnfQ43GwPVRdCYJfHiI+gQK5OZl?=
 =?us-ascii?Q?OjUT9979XNBJEpzB/8bvm5Eva+IhEx8r3Q5wlLlodv/Xh7i494pPwsadRqlv?=
 =?us-ascii?Q?bRYO4cbYf29zEiTZAl5G6ZkDHtbeHmCKx7LKNFBmqgNKyX5Voauyjav55kNR?=
 =?us-ascii?Q?qrTNX49mCcHSYA9MV3cGEgTmSGEaOVfabpyk4uscb2F9X9Wwx2rMpe7T3Ub5?=
 =?us-ascii?Q?ce3dovvTGe1EYFt7A9m4DsO60ugnCNHd0OJuWFeomGLlDmeaTHRx+0u59veM?=
 =?us-ascii?Q?WbOpwca7kg3Y+6vlnO5ofmCq2atZpDQKMtjL3B5AJYDB4bH+rnP1FkH8U0VV?=
 =?us-ascii?Q?7ciSs+jKAWdwSPbZ6A8wDjyVQ8si+xQ+fE+X2/XTCxTHfM16AQ1cDWMLTSxr?=
 =?us-ascii?Q?a7xyZJX/EZhtLknqe8jBVHksjvh/AZ11Npi4Z5kuA/vtk16Vfiq9QNX8A9AW?=
 =?us-ascii?Q?W4s+3vq6d4u6f9Tov4xeMaEtairH/LuL34S2wCqFrLSpxV67jdkmb2sAzRE6?=
 =?us-ascii?Q?3pRT+W1rfr38fd5alTI2ZBRNWOtg/Lpb4rfTpAuu2xAeZEsi0ILK1NJf77Zm?=
 =?us-ascii?Q?hOHpwHDVUDNGCG5hjvxF968uG6SjlRR0TJaCoZ6qoBe16fq77IE+U5hyU3oN?=
 =?us-ascii?Q?HQ/YaxrAb+A6ElXCYDFxsc4Hn8vlL2jdzO9eeC9+f9VEUtoEyiLe8pOjmMND?=
 =?us-ascii?Q?K5948Fk6yosTJRtfeefuZpZRSsyo+5SE75+wQJO0FtZyxyPm4JtigTVDXwlm?=
 =?us-ascii?Q?XPSlxwthY+wviB11RkK0cTpHPipyfseJ7ZqanOYnnNt6mXLb1yqOKZ2SWfqk?=
 =?us-ascii?Q?gz8L3r9C6+Rmy1ZLsZ6EkJ+cz+1ZBvvaoUKIT//lWXJi94uGRBKbIcPyYYtq?=
 =?us-ascii?Q?L9ZOec2mx+lYDQAxV8PjAKVDdUMN8fw63GSdd3w2XawchvjY9+cE5eu6mKd0?=
 =?us-ascii?Q?paA0EFWJLv6GtoYqvB+8250BaG8zjbSHK6JWU1QgSdN4bo8OGbJlyGrVoOe2?=
 =?us-ascii?Q?rzJadyfuI+n4jrW2XKEz9EiG7jaNVfyAtWY6S6wJxx8NSDPprhr0hDuIGUeK?=
 =?us-ascii?Q?3HBm6zDua+nYtlr446pghK7lkzLhtv03L2GMbwLhFX8kw+t1T6SQREYs43q8?=
 =?us-ascii?Q?GXVdHWR8QpKIZoNbyLgmdv2D7OkHzeeEG5JKhCTx+abYoTCQrE1i1uoMnw+d?=
 =?us-ascii?Q?pmpj2KkjPbrVfIVitOKH37uaZAb65UfdoSUCFqRaiThvqbueF746qHfQji/Z?=
 =?us-ascii?Q?sVgpwiAkTbb/dW9qxSVb0r+a0x4ELNHQT/YV0B20JbPdwibBxvAkho5eKjLz?=
 =?us-ascii?Q?Ob6P4ZdbJW6BQyIDqah/283hoPIn0eZhBzueBOoc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591bd20e-fcda-49e9-732d-08dc63974669
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.3396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsYKg1xZHen1hYn1ZySNzpHt0S1ZtQBwRrVVdM3RK0oyxBr/jtWCrwOM9rK3WNGY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

This is split out from the larger part two which aimes to rework the PASID
related code.

No new functionality is introduced in theses commits, it just reorganizes
the CD logic to follow the same design of the new STE logic using make
functions and a single programming flow without leaking details to
callers.

CD does not have as strong a need for this as STE, but all the code exists
and continuing with the same pattern makes for fewer things to understand
inside the driver.

The following PASID code makes use of this to rethread how the CD
programming works to take a caller created struct arm_smmu_cd and then
stick whatever that is into the live CD entry. This allows the actual
PASID and CD logic to be general and then the PAGING and SVA domain types
can sit on top of it.

There are four kinds of CDs:
 - Blocking (ie cleared)
 - S1 PAGING
 - SVA
 - SVA with a released MM (all fault)

The last two have to transition hitlessly.

v8:
 - Remove ops->v_bit and just use entry[0] = 0
 - Revise commit messages
 - Revise comment in arm_smmu_get_cd_used()
 - Move hunks removing code from arm_smmu_write_ctx_desc() earlier for
   clarity
 - Consistently avoid CTXDESC_SPLIT and remove the macro
 - Don't check master->stall_enabled for the STALL_FORCE mm release
 - Fixup rand config failures on the kunit
 - Use VISIBLE_IF_KUNIT
 - Move more mock structs to .data to avoid stack frame size warnings
v7: https://lore.kernel.org/r/0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com
 - Rebase on Will's for-next & v6.9-rc2
 - Split series in half
 - Include the kunit test
 - Update comments to refer to the STE & CD in the writer logic
v6: https://lore.kernel.org/r/0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com

Jason Gunthorpe (9):
  iommu/arm-smmu-v3: Add an ops indirection to the STE code
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
  iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
    function
  iommu/arm-smmu-v3: Consolidate clearing a CD table entry
  iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
  iommu/arm-smmu-v3: Allocate the CD table entry in advance
  iommu/arm-smmu-v3: Move the CD generation for SVA into a function
  iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry

 drivers/iommu/Kconfig                         |  13 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 164 ++++--
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 465 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 504 ++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  53 +-
 6 files changed, 903 insertions(+), 297 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c


base-commit: e8e4398d53f98be7ac48e0bda9ea6e26df24136d
-- 
2.43.2

