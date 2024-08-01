Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4A418950D;
	Thu,  1 Aug 2024 12:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722515172; cv=fail; b=JM7NYdbFVFVS3VrraME7sS5ozNp56Rpurd5mpCIDuExPdOl/WBrQZ9onrxgUpM7jcXb9ZF0cXLB543RpzYmiffCOluzOIjEKJwbBuyaLyjg58YXuIJt7du5qVN7+WAAzJDLrVV+jjp9+7MrZ5nyP4E4P5nJ26V5BVX83C4QThU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722515172; c=relaxed/simple;
	bh=KoN78HtHoLvSRYi+rx6sDzxEyu0TNsSblC/hQdf+42A=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ObEDgMm1TRSNbO3S0W0IaV299xiDb86CSxqXbMyWMA09MZ7Ok3SJK3onJFXfUrbD5Ah7aNFpK8E+bCr8wm9l9b/XzMob+wo5ZpMi3z3gtN7jHw3/ZXpWTqGcUAZLbyQQlo/uPNNzESm5qUwxvuCNcKopla3tjJzlJzlGPGYculU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XGisK8lp; arc=fail smtp.client-ip=40.107.244.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XGisK8lp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRgyog//YV6nBrxtSVLuJnMBWMBXRHUtrVMDptYuikTAZy+/SS1fqL2T5zuZBOX/xUKX71DyGmyQUKHDoe/H5gu+XVe2dsAukjR52vPe426Uw8WaakI/wf8AXJdewjuoiQrjmXi4lFWVMHUEUz9bEvwIpmLaPDkVJ1koqkdyEyVTz3mqBllJmknRnCPZG5kMM/0wdJmqjDIXzKpVNRoPbqDfYfF9zTWr0PvBIb0Kj8WyBv+zWeiTvZX4XdmIhNtASXEor67SHP9sOhg/5IsMEdWel08zakZuyS0+9iX7g2iu8oP60UebSwydlrk4FKokRIbEyzsyqgrGfoRumOH2ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OF0duuvxW7rjFB7nhQaVnQX+P3AmzDlpBVstxy8dfrM=;
 b=C0vYXkWn2Sevbw8vKgMiwf97/+AhvH546mWfqG5QEIHRj6a7LX6cvVrUOBCzm3nbsGvTcLiYrz+UHh7tUf/Ny3t/uHn1fzE0hHaP8JKQh2cbSW2ioPSnw/0Nz7kiH5i0GvPSY/W8XE/NJ/GglWVvHclVRB9lxFyAV6TtIPAp65BOjAj694R2qt+qAjVvId5MCgrg65ogZkyap/92fDb5G6s+QRJTt37DUPVuKlV0piHOs6BCUtNuLHhd9Ox+oNwBkKswoxcXBNblA9NAfI8kjVpNJAyyjpJtKnbaznIISs/OBYYmWwmsQY3outIMTI8t/fLUFBPIMnHE2XAtcfAq3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF0duuvxW7rjFB7nhQaVnQX+P3AmzDlpBVstxy8dfrM=;
 b=XGisK8lpsgqp109GlwB2iEzxyQd8jCAdJe7gw/Y+t/CdxQBznhh2MR7/ed9ydHXVG/Tz5a4n62iljQU3SeXg2KayvqMF35Y8zrFDV9hCj3hgt82THbA3GuwnI+eeM/p8bdzHp0DtL8j1DoFxddQ4jk08jVMt9Z9Dfp2nEi/LSNQrPoqirmlm6nCPXw+17nVI8hYz7wyp1Ne/aD9fbVnGizg4OclhzFD03+9f/jkh3J+eXuenqsuQTzlnBx6aWCWxzGEGmIIIV2ZBAet9Izrj8fn606HFR/xEDui85bAWiUarKBLSoPHupJ8bzX6fDuuhNh2DPIx6VrZnH7pvEOGe4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA0PR12MB7650.namprd12.prod.outlook.com (2603:10b6:208:436::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Thu, 1 Aug
 2024 12:26:06 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%4]) with mapi id 15.20.7828.016; Thu, 1 Aug 2024
 12:26:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Barak Biber <bbiber@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev
Subject: [PATCH rc] iommu: Restore lost return in iommu_report_device_fault()
Date: Thu,  1 Aug 2024 09:26:04 -0300
Message-ID: <0-v1-e7153d9c8cee+1c6-iommu_fault_fix_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0016.prod.exchangelabs.com
 (2603:10b6:207:18::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA0PR12MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fbd763d-3af7-45bb-2f04-08dcb2251da0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UXLgyyFbfRJhxbLtRrRKUqoRv7pbIh9DbYmHsRlcSljMD4RShfLJV+XwwI3l?=
 =?us-ascii?Q?+pThmXc7wI6ELOi/k2T2O/CE/O1HXUe7RyYTDOcL6R9ZPPAIvuUnVQIzbCnB?=
 =?us-ascii?Q?6yZq1jA+HISTkdt9+cszmc3uKqKmKSeWmBgebDge5j//RBZMiq1YzwANbUjk?=
 =?us-ascii?Q?zjLl94x6vBnrTBe3Cd2Vjz5IX09YmUuxdITClVLu5OEQhukoXgPv/oGMjhxR?=
 =?us-ascii?Q?rbR/NWDCK9RYattvVmqVBE4uuK0V+CLFM3UmtOBOmhprSs2c9gScUrqoXrcL?=
 =?us-ascii?Q?dhBnzhXTNsfATI/QiyHuho+lK6y15Ak5vn6oSN/P3cwVYqH/NcRt/F0232X5?=
 =?us-ascii?Q?IIPYRXUuzyITBfb3S1aOp30Z0afOvt2KFRjR+yoWHlABq8H8i0dPxD41/xiY?=
 =?us-ascii?Q?ejt/N1p3G/dNILvfmBsuZhO+0pbwHG7pdaZhFCF996jVOrnDE/+sgnrs3rOQ?=
 =?us-ascii?Q?8VrepkAev/AZTYUj8xycMQjsb6zp4xh1X5FLE/Hf2a4k4S3LaJXzYlYS8Dq/?=
 =?us-ascii?Q?v+62njxtana/rudSE8Zf8R45kHLJ/zwkLluvbRDT1x1AmoBGpBFEVP47MlLm?=
 =?us-ascii?Q?wmso1TPtJmqF621LYGI4CEbYc48pHaxeFvaQG5dmIFNVF99gu5u1/42Yk8ek?=
 =?us-ascii?Q?T0MjfhLVUQxVBrkUTJjKiu1uRxNYPRu44Yh8lcQkeCPU56rXGk+P3D8UcN6y?=
 =?us-ascii?Q?2ig1KOZ3pudy8AJEJ2ee5mrxxX69ChqYJbfR9LR3kQQd2TMwXp/c35orVKPE?=
 =?us-ascii?Q?gqc9bsLePx+AfdnezFV/Utmm+Amvqvr2zdLvFjMiiSYT3u4yjXGsHXIPLeLf?=
 =?us-ascii?Q?SUavWbjp8d+9CegxBoGBnNj13MR/y6PoGImqyKNrlRBuZz/ia+9NPl3mcmbH?=
 =?us-ascii?Q?SnyAB7h/aF+4ziZ5I31C2Jx0v0y2HwUVUOSKevrD9jO51lpgRm+bZYJcZGy4?=
 =?us-ascii?Q?d2phNLN90fO/fFp3NWxq8dlLybaVgmBaZukta7/Au2s5cjqBBo0ins8x3CrD?=
 =?us-ascii?Q?dP/907jM07kKuYl61JbQYPN29mOIt2tIikxgCQEwreQYY85HPi9a1KDUC8QQ?=
 =?us-ascii?Q?B/Nm3vB4Z5DWXuZDKxzY9tFGVnKHCoLuW41Rinx14YBoTaPhHvdXAWB5xwuc?=
 =?us-ascii?Q?JogM0mpSZ1Vlft5SxNgya8DAuNTDkqNw6zH+gBlC303ec6Y2fGC6LDfWrRgw?=
 =?us-ascii?Q?cCaSwLVz2vK+PIVHbEovlEUUGOznfWFAfctEapRUAncK9ZFSfXxkkQdclO7y?=
 =?us-ascii?Q?3gMm/CYV3FDIldqseb0yp5Cug+nRCBVbgoCAmC1/HlCTOUCS1BQgdQyDwViA?=
 =?us-ascii?Q?a/9HOGXTS8gpxHpluo5vk4h4VQvpIZ5RuZMTgo1qXA/sVg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NhUNb8YtbrSrOrIaZGI9NkcXwvA8Ie6rdZ5CDcmLVA2IUbwNPVesdFlwgQug?=
 =?us-ascii?Q?xCKjl7hFBSBqQY5SNn4A8OR1US6MRsKfwV7NwPZ75lt1DpogPTsY5NlXyNKv?=
 =?us-ascii?Q?1kLDgCbYV2e5qExxy0Vf9rrP0AWb65mQqr943WiYr/SXaPrJqFsx1AW5aWBP?=
 =?us-ascii?Q?Lhq0D8jNj32uD3yfO05Co4tExUc9x3Te9a3JS+O7/+XmwT0JQLUVQtNn5GrB?=
 =?us-ascii?Q?S9HPYE9Mh9g9EKE2MldUkj6A44ZY+sH7DhwxfiDXnarbAbyOn6z4ZDcmN3Ga?=
 =?us-ascii?Q?VQxqajFzlHvMgI3P6QNoHHFke1kwa/nIM4y5mHGhBiqjA0nu74g2FSZMpV5/?=
 =?us-ascii?Q?87dZ7mrrTAiZ3Z39gDdpuA4VZWmaVBlxiCwbW8MO3gQglkWxfPt3+Q2uCzpA?=
 =?us-ascii?Q?rtjdmJhUevxc2sXvE4Ux8OQ3pNm5//OBSv6ed2byorMIHDwq4xOBchgo3r+p?=
 =?us-ascii?Q?PGjlfFafMtwpmzZqhi7ls7AarnBIR08brqICIwDjsoxL6ebuhxrddz+OOTpc?=
 =?us-ascii?Q?X7LFhpt64Op2SiZC4KPBvMBDrYoMbP8tVDQmbJg19dExSO5ZCSH79bov39Wq?=
 =?us-ascii?Q?KzlhzRMwz3cgQxQSPzKKN9vZ70slwUXqwIlpOCa3VVj3UhUCIeh1FJZVhcT9?=
 =?us-ascii?Q?4WPgRkKyV7I51byyL36W1WPqAA0pzqXkAmq21oND7jGVxnL7Ccn3OiCgGOFu?=
 =?us-ascii?Q?rhPcAhP4F4d+U90eEcZQ0p6VYigGq2/y3keCNAoFgXHHN3/6SZVXX1u7VoKk?=
 =?us-ascii?Q?P5ZZ0VGvJTd+4P83aCu03cOVjYRXqVnmHX95ufKVxc4tY0MY/1T5Yt6tz1JQ?=
 =?us-ascii?Q?pOMqLRQOG18wOIL2TYe+TyVihu2c4SjM3f0Xkt/fAztq2GRYGHNTTKJVhjUN?=
 =?us-ascii?Q?nl5A24gGlVkP5FmbmzvcleDSLvQ4y58sV5s9ZObNqUNxzg6EAJ8mAjiIR0PB?=
 =?us-ascii?Q?TapBj++fkDKNFjEUE0o4WNB9lMu49vviK7ofRMr2PGCMXfxDMxMl3u45U6IQ?=
 =?us-ascii?Q?Yt+sLKa84oQOVbd/ZLtwlG+Nkeu3ZDZ3y+RWHqxrl6CVSVEnsON+Ka3qlpr5?=
 =?us-ascii?Q?OxkAZsKwQfiF8AczOIX3FGDjufYYc3OFUsXnkbCA+v8qkOph+NnpHtPRZavW?=
 =?us-ascii?Q?f8S/RgOAtrugUIEXXAZ8K4M8oFEKvuogWGl0YeVPfOR363I5Y8Z+KLOTPZ2U?=
 =?us-ascii?Q?Um1GDti6Nd3dHRENRKHfMgOp1lJvTyDElXZRMbE2leW8yrlN0/nAKKqqc2iM?=
 =?us-ascii?Q?+TTPkdS2R8iYv/3DvAT3beQKuw94qIT9l/w5WMLLLNCTmP6sMaQm8YEC0cUl?=
 =?us-ascii?Q?Dhqjtt/mTC0apLcm3yMMsAW3/bYdsfuKacIXeufAmXuvNhl9Omt7U/e7dr35?=
 =?us-ascii?Q?A7U1Vu/Tvj2HvRixgmWauXYo6W4t23hktidJkuqKVQbFzBSEJ34q6wNdCJ28?=
 =?us-ascii?Q?ALvr4iTj7YlSaKoQ1XDHhn0Hi24g/xpOyyKF6bwRDNpal3x+yKCIyry17EEB?=
 =?us-ascii?Q?1qMCPpxYPus5lt6Gnr6nSWjaeBuFwgZ0gymdaIJzGRsgXl0j6eIQoHQ5AVtc?=
 =?us-ascii?Q?tCgVtFhvqYKlmf53C58pGo/J8hSGGmF7MnLfrB2Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbd763d-3af7-45bb-2f04-08dcb2251da0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 12:26:06.1858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ug8fkYZJjGZOI7I7lH2cmBi46X3C0Ciq8OvvYtxV937a3tNnu2hEhx48a1WfZ3G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7650

From: Barak Biber <bbiber@nvidia.com>

When iommu_report_device_fault gets called with a partial fault it is
supposed to collect the fault into the group and then return.

Instead the return was accidently deleted which results in trying to
process the fault and an eventual crash.

Deleting the return was a typo, put it back.

Fixes: 3dfa64aecbaf ("iommu: Make iommu_report_device_fault() return void")
Signed-off-by: Barak Biber <bbiber@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/io-pgfault.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index cd679c13752e00..81e9cc6e3164a4 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -170,6 +170,7 @@ void iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 		report_partial_fault(iopf_param, fault);
 		iopf_put_dev_fault_param(iopf_param);
 		/* A request that is not the last does not need to be ack'd */
+		return;
 	}
 
 	/*

base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.45.2

