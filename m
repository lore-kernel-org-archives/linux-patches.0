Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785454;
	b=eNJVZlECp7seobWwUK6Ugdum2UZZeYPsSThvCznGqS229um71Al+w8rEU+cRdH376qXa
	 rV9YM/MesQLblKNx4G8II/03LQP05XP/3VrGHGEd5zchfhgFeJSA16mo4vpuCMPwbC2MI
	 bd6UEnfo8nc1FL1LDp1at4ShDu9Dq7HauzenYAZ/SsbuEWmA5AQy5RgSrGKkwky9ECxdK
	 NzjK1Wkq2S2heEOT/g/Jp/wh2QVj9tGjMzb/H/JkcY2j1t3pEbo7HlAfS3VZvORTkWPay
	 WdiHjl8o1wsjhvIKGMLzDqB6gj6Rxj+RdSCjtYkoHqOaiDUHR13NuOdB+XQo2DxJnaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785454;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=0I0DieiIC/tk1nYV+iwKGB+XTRAvsxV8q1Jo7w9ab+o=;
	b=aU8VnPgg1XnjuY4pLPXH3VMnP5wOIdte6vUjQXnP1/2B1XkQnt3r3dgn2NpglJbmfwp5
	 tYBqyChbfK03Sbmtd0VQvWhpQ6bnasAlKv1RMnAZ5IGeoDOgAykTjpDq6Uz4P48Mdb6sY
	 6CEFnn0TuEdIZxaeMA1z7Y+3Lovg8+RcGpxYzHAPLI8qtZI0zR+fCHHgVY8SBAi8Z+p5V
	 Ub9nFdyuAkTi67K7ziuRT1g+zq/ZLX9QjzogJjXeUPpxvCgT3etmCLry0sQJ07qUEck5j
	 v/paotgrMoZgVtqkPH60j7qStkt/surE58Y+dlB1dGlFEpmbOEHR8h4C39zA+7TsdPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qUyIe3AR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1443B606A880;
	Sun, 15 Nov 2026 23:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1443B606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qUyIe3AR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRgybpnaUsphjCl2FMPQkqH36yZBNdwqx0s3/CaZj9AF6SoI48jk5WPqmzrcJduaJ44Tj79jqxJrruT5p0PDd83BbepPgVZLh6mr4of00H+NA55KqNh/OdANdtzFVT7Cf9InwpuKzsDXCZrSgV9iEiDwaP4xVal0K6VD2IhHujam+2Vu/XrbvkwowTr+ZupsSN/IUk/SUsHOgYUOjTf62Gwa1qA1qZFH1uZvtD8z5z6qzHF+Ji/uumZRt70y1cKTEEvIR4ZpNU2+X/6iXd9xrqx0sbOwxtb4b4mYipR1bQE5o98+a8EyoQ8lOOvtlKLCpD7sXWNDea/y1v3MNngu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I0DieiIC/tk1nYV+iwKGB+XTRAvsxV8q1Jo7w9ab+o=;
 b=QU8Gg6VbN4CcnWbxKxrJP+iDcalfsd0EdwdaDPbFQKVJg+zqfThGmLSDd6hOK+B+FDoAOTk9iHLa0zQkoUIVNjWYGw8aX8kkpbjm0iLGD5IW6Thrb7nEBYNsyNFU/648WLNCUCRuUKftPlUgxTO2h6lZOPRxLaPjDfvK42Egu+d7pgvUZI4dxwfv8tVkLtgXYvRK6QUkl6WLtSFQgQbN30/lkzANrgi/oTWHBHw5PFfsJu/g/7zD8lyZq0J3+dub/nj78hTHOl9cv8yj9db8L1IW54UQvyjBRT6FW/bYhmc9i6IFHWTgAkvOvM+KdRnQS3io2zDw044Pdm/OZUoThw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I0DieiIC/tk1nYV+iwKGB+XTRAvsxV8q1Jo7w9ab+o=;
 b=qUyIe3ARfFQL88IrEbkLoOplL1bHqwQoS72+hl5wGPtd42cBsNlVJKIkf1mr5qWAGMEnz/KfF3DVNp/u5kse0vRQlvmd5Ny3aPxRUfaM8AhjVturAHTWPDmHrBtjEF2A5WBP4mhr70PVEFwkY0aAc6Zm8/cDdjRUI1tIXzP+7nZSi7r26qUknSuYdlUGdziVSRkcvbY8pbvTMj8elOvRDb+j0PzNZoe0aIG8ATI6Ww5w7WTfdwD50XA4qVjIg4aJQsRir59Pt+8cvSFY61DgcY05uNTgZGmSgZOJlFsZ4qij3JwJdg+nFeQmfreHU6MUnPkFK3MH4f8ESlzMFNSsRg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 08/13] iommupt/armv8: Implement the iommu specific components
Date: Sun, 15 Nov 2026 19:30:38 -0400
Message-ID: <8-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::7) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: bf3af44a-a424-46fd-42f8-08df43707876
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021135927099003|261022113327099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Y2GUNDVfkDr8R3ic3HHMXWW6C45SJ/gMZvjWco0i71iIlRCJlTcVDHqZehs4gRvvmR5drTLumMklntpiwx+I3/Egif7unieZUVa8S6zM8hM2XYyyM6OSZSi3FX9sU4nPkplOI+4AYkDniGqIXo8v7VaU2pJGqX11faAS5DkawIi7bnrFFT8sdrzme9clinW6M8ZuNKo0d0WLl9D1ARAEosVBBfdjxhl0PTzQjZ4FD6qa1dW3i9d+la2Z9ZCpD3KY21BiEAcSjciOljjW2ibLfE/olHOrU4Xy3UfMx+kg/syRd1iFhDwETfAD38N4r/EzP3Ofvd61wVqYd8h3FyHTi692tHicDQfuIcgzJE/KXO1IcxMqqwGV4p9zd4UJOog4p+lO+jHNOblllIQhKxURDVSQVRET1B2RUflMt3dNefR8D+IC6KcD8Qx5ZYXgfDq93yhcUuZ8pudGg7C4dzcdKznJ2Pb/vfIMv8e47Dxc0WkQqTmiETbYVGzQh8KAsOWyCDPSqZYYe4a7YQD9rOcutcGcP8q7UQtGZpEWCSCY0B0/U3qbcjvZpnmvUlxYHvuERH33E3+8HgDbfW91ZvxqmwAFop7VvZmaEwxkA5q6gTE9frHoi/Ow+Dnf1FTfRV0o/N5rWE2gC/T+XIHLUIyVnMvaOXl8tNub4113rIbVlz4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021135927099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W861z/wOqn4EpvLIAGq40I4dSKKTA0A/o5FBgHQn8TM8BIe3ROP2Qa+SIMVp?=
 =?us-ascii?Q?Nddo0kSn8Q20hUy78aFWqQi0gqkvzOYY2BO04VpnR019/DbPZtwsvYbs/Fh9?=
 =?us-ascii?Q?WYFwE46FYlH4+cO4A4FKD0tgNZ/w6CuaWRYTfdZdmX6LquMZHGRzMHXl1yDb?=
 =?us-ascii?Q?czDKbdmUrqDkmDwQuQb4UDDhRxo2eiM0dZk0kOIsTQUsvJt1I+WafZTFSw7H?=
 =?us-ascii?Q?egQQGRXUZl/EQs7QhDVEABFKAxP8le4dnUIPX5HcvJuFYb26u15ne7UEBnHA?=
 =?us-ascii?Q?hXEmHMOBkP/LaGqXIUaLKa1qJEMBWqm+Iqg+pt1dsVsOH+Co6vUWAi/QI8+z?=
 =?us-ascii?Q?bJZYu0saVMrO6dC2U822ZwPFmnLEKCeUtaxI/nLz5xHNOZFcSZ7J9v+NfO4+?=
 =?us-ascii?Q?NgXMC4Jy2qjH/lbwuOAi9tmnFrAKIO1cXEfqZ8lllL03RMDF80hwjJcd1F4O?=
 =?us-ascii?Q?mNZeMNIw2NU+1V6a6bUtdlItSlzOKQZ/giChUQ5dNTqfcmQPw9UHJYSKdjjc?=
 =?us-ascii?Q?E6r6MKE8zHwtvF96eagtI7LB78bDnDQpTB4Vi4PPrXqt/DYr6ngn6JsA7eri?=
 =?us-ascii?Q?h8ik/dzoqklLzKPUzVxsYoQOKh76kll5pR5uHurareOI54nglz+tQxrKDYG5?=
 =?us-ascii?Q?i3Sb0UseCfWhyiz2usdbLIZlFMm4KjLUnRAkkbVbkM6pXgT5IAi3+rEcXWcN?=
 =?us-ascii?Q?Q/O2u8YWogFkoXZ8y8vQMEdX/vlk9kiZ7k6eF04AaaJhI3W2Dxipl1Mgx3q2?=
 =?us-ascii?Q?2IRrauBuYVm19PLVirZqHJphgxHxDa1YsZoXL4lhfC9kUVKPwxmSFOnRr8cj?=
 =?us-ascii?Q?hce7sc2ZLxtAcwDYFjXhELTmFPRzmKN3k2RrmS5gg2srFM0jz9vyzQ6ydZFQ?=
 =?us-ascii?Q?SJoysNx5EqqVV1yVidVGRzsMq6Pbla+kDhcmdz8ooVRsKmG2HNB2cTWloiDC?=
 =?us-ascii?Q?UgBSJP5p3Ze2fvVl7wVsS7Fh5gUdgFj1Zo6Hh7VSSVzeTtsaFdp7iFbkSNsd?=
 =?us-ascii?Q?owPsflv2UNrBIa57Wi+2aMSG8Yqxto1E51Fk+h/YQDwCbz1nAAd9u0J6qGUd?=
 =?us-ascii?Q?WYnT2LgyiGehCtkeSdkZZPwaprYIwC/TmW5iGta+jUQ3dQmqCT7LzLKiBqFP?=
 =?us-ascii?Q?prevH/rBY44dkROH1Gq+FrNWXAjcnjNWMP7EA0Bf7RR9fxNFvUf9Ai2UGNBy?=
 =?us-ascii?Q?Thoziqq9nNoclAFLRYnVqtHqQY4iL1FE7XbvIE4rg/iH/RExw+O30FL7fPP8?=
 =?us-ascii?Q?V6hiEaInOH/OQs08gxmzsoe1GLaum3zOlEdi6EbPPM6ssJ1GdG8NM/ykF47c?=
 =?us-ascii?Q?Mo0PRDlWyI+Po69wdJ3IFT4bXZB2ol0IU5pOwn5y4goB7I7j3yXIeCfNdFUw?=
 =?us-ascii?Q?JAbDu9GLtsBX3WpmUCzeTCH8AUJ/RcMVHSQrxBykKav/fy/VFxeNsZY73N1C?=
 =?us-ascii?Q?QepJCI8Sj80IdSu8eLSTePwAbrZ8VnuNoxdlxYA5+VLXhHzjdQ6D1I/prAOm?=
 =?us-ascii?Q?i8ME7tKD0RtuET8j5Na3oKfpmsphCbC1/tOsx5xYetKw6Cy+9Zd3CgOmztAV?=
 =?us-ascii?Q?m4whExr9gXEwy7Mt+aPpVk2+1YdxfTv+3pfvUUo9zwE2riF/bV5GnBB78Axq?=
 =?us-ascii?Q?LFE2Ps+YmbSheV+w3xQ9rPN6qlFXv3cQlIVzX9mkm+dKWU2hWTekVKewIOeO?=
 =?us-ascii?Q?D0BX9BC1WGz6usc3OKVUYQzNCkaDJ4WBgF+XaH29PDKJctCF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3af44a-a424-46fd-42f8-08df43707876
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.8032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tROIY7R2cMBBju2nfDwTbtf4jM+8Do8MT89JVwWH/xpAqkwo4CvEh3DOYjggvHgh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

The iommu page table is built on top of the generic components, add the
peices required to turn that on for ARMv8
 - Makefile and kconfig
 - pt_iommu_* functions for ARMv8, including the complicated
   initialization of the level and structure from a typical pt_iommu cfg
 - pt_iommu_hw_info to return the field values program into the STE
 - 12 kunit patterns covering a range of operating modes

Include an inline helper pt_iommu_armv8_choose_granule_lg2sz() that does
similar to what iopgtbl does to select an appropriate translation granule
size.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig      |   1 +
 drivers/iommu/generic_pt/Kconfig           |  12 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/armv8.h       | 495 +++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/iommu_armv8.c |  13 +
 include/linux/generic_pt/iommu.h           |  72 +++
 6 files changed, 595 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index a3da74328f12fc..f5832b8189d1e2 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_GENERIC_PT=y
 CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
+CONFIG_IOMMU_PT_ARMV8=y
 CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 2a81dac960ac02..0a44608968f246 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -42,6 +42,17 @@ config IOMMU_PT_AMDV1
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_ARMV8
+	tristate "IOMMU page table for 64 bit ARMv8"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for the ARMv8 VMSAv8-64 and the VMSAv8-32
+	  long descriptor pagetable format. This format supports both stage-1
+	  and stage-2, as well as address spaces up to 48-bits in size with
+	  4K, 16K, and 64K granule sizes.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_VTDSS
        tristate "IOMMU page table for Intel VT-d Second Stage"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -85,6 +96,7 @@ config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_ARMV8 || !IOMMU_PT_ARMV8
 	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index a43f3b81d2dbc4..42e66ad940aebd 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -3,6 +3,8 @@
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
 iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8) += armv8
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
index f204f6906bb14f..581487a58b9f02 100644
--- a/drivers/iommu/generic_pt/fmt/armv8.h
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -579,3 +579,498 @@ static inline u64 armv8pt_sw_bit(unsigned int bitnr)
 	}
 }
 #define pt_sw_bit armv8pt_sw_bit
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_armv8
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->armpt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, armpt.common)->iommu;
+}
+
+static inline int armv8pt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	bool is_s1 = !pt_feature(common, PT_FEAT_ARMV8_S2);
+	u64 pte = 0;
+
+	if (is_s1) {
+		u64 ap = 0;
+
+		if (!(iommu_prot & IOMMU_WRITE) && (iommu_prot & IOMMU_READ))
+			ap |= ARMV8PT_AP_RDONLY;
+		if (!(iommu_prot & IOMMU_PRIV))
+			ap |= ARMV8PT_AP_UNPRIV;
+		pte = ARMV8PT_FMT_nG | FIELD_PREP(ARMV8PT_FMT_AP, ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_DEV);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_CACHE);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_NC);
+	} else {
+		u64 s2ap = 0;
+
+		if (iommu_prot & IOMMU_READ)
+			s2ap |= ARMV8PT_S2AP_READ;
+		if (iommu_prot & IOMMU_WRITE)
+			s2ap |= ARMV8PT_S2AP_WRITE;
+		pte = FIELD_PREP(ARMV8PT_FMT_S2AP, s2ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_DEV);
+		else if ((iommu_prot & IOMMU_CACHE) &&
+			 pt_feature(common, PT_FEAT_ARMV8_S2FWB))
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_FWB_WB);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_OIWB);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_NC);
+	}
+
+	/*
+	 * For DBM the writable entry starts out dirty to avoid the HW doing
+	 * memory accesses to dirty it. We can just leave the DBM bit
+	 * permanently set with no cost.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_DBM) && (iommu_prot & IOMMU_WRITE))
+		pte |= ARMV8PT_FMT_DBM;
+
+	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
+	if (!pt_feature(common, PT_FEAT_ARMV8_LPA2)) {
+		if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_IS);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_OS);
+	}
+
+	if (iommu_prot & IOMMU_NOEXEC)
+		pte |= ARMV8PT_FMT_PXN;
+
+	pte |= ARMV8PT_FMT_AF;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot armv8pt_iommu_set_prot
+
+static inline unsigned int armv8pt_max_top_level(unsigned int tgsz_lg2,
+						 unsigned int features)
+{
+	if (tgsz_lg2 == SZLG2_64K)
+		return ARML1;
+	if (tgsz_lg2 == SZLG2_4K && (features & BIT(PT_FEAT_ARMV8_LPA2)))
+		return ARMLn1;
+	return ARML0;
+}
+
+/*
+ * Debugging validation of the S2 initial lookup level against D8.2.
+ *
+ *   Table D8-8: "Effective minimum value of T0SZ" (R_DTLMN)
+ *   Table D8-9: "Implications of the effective minimum T0SZ value
+ *                on the initial stage 2 lookup level" (R_TDJSG)
+ *
+ * ARM initial lookup level = 3 - top_level. Table D8-9 constrains the
+ * shallowest allowed initial lookup level per PA size and granule:
+ *
+ *   4K:  ARM level 0 (top_level 3) requires PA >= 44
+ *   16K: ARM level 1 (top_level 2) requires PA >= 42
+ *   64K: ARM level 1 (top_level 2) requires PA >= 44
+ *
+ * The valid level set grows monotonically with PA size, so checking
+ * against IAS (vasz_lg2 <= PA size) is conservative.
+ *
+ * R_SRKBC: 4K granule at ARM level 3 (single entry level) requires
+ * FEAT_TTST.
+ */
+static inline void armv8pt_s2_validate_level(unsigned int top_level,
+					     unsigned int tgsz_lg2,
+					     unsigned int vasz_lg2, bool lpa2)
+{
+	unsigned int max_top_level;
+
+	switch (tgsz_lg2) {
+	case SZLG2_4K:
+		if (lpa2)
+			max_top_level =
+				vasz_lg2 >= 52 ?
+					ARMLn1 :
+					(vasz_lg2 >= 44 ? ARML0 : ARML1);
+		else
+			max_top_level = vasz_lg2 >= 44 ? ARML0 : ARML1;
+		break;
+	case SZLG2_16K: /* ARM level 1 requires PA >= 42 */
+		max_top_level = vasz_lg2 >= 42 ? ARML1 : ARML2;
+		break;
+	case SZLG2_64K: /* ARM level 1 requires PA >= 44 */
+		max_top_level = vasz_lg2 >= 44 ? ARML1 : ARML2;
+		break;
+	default:
+		return;
+	}
+
+	PT_WARN_ON(top_level > max_top_level);
+}
+
+/*
+ * It is a bug for a caller to pass in an illegal combination of features and
+ * tgsz.
+ */
+static inline bool armv8pt_validate_features(const struct pt_common *common,
+					     unsigned int tgsz_lg2)
+{
+	/* TTBR1 is S1 only */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2) &&
+	    pt_feature(common, PT_FEAT_ARMV8_TTBR1))
+		return false;
+
+	/* S2FWB is S2 only */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2FWB) &&
+	    !pt_feature(common, PT_FEAT_ARMV8_S2))
+		return false;
+
+	/* LPA2 (DS=1) is only valid for 4K and 16K granules */
+	if (pt_feature(common, PT_FEAT_ARMV8_LPA2) &&
+	    tgsz_lg2 == SZLG2_64K)
+		return false;
+
+	/* LPA is only valid for the 64K granule */
+	if (pt_feature(common, PT_FEAT_ARMV8_LPA) &&
+	    tgsz_lg2 != SZLG2_64K)
+		return false;
+
+	/* LVA is only valid for 64K granule Stage 1 */
+	if (pt_feature(common, PT_FEAT_ARMV8_LVA) &&
+	    (tgsz_lg2 != SZLG2_64K ||
+	     pt_feature(common, PT_FEAT_ARMV8_S2)))
+		return false;
+
+	return true;
+}
+
+static inline int armv8pt_oasz_to_ps(unsigned int oasz_lg2)
+{
+	/* Stream Table Entry: S2PS section, Context Descriptor: IPS section */
+	switch (oasz_lg2) {
+	case 32:
+		return 0;
+	case 36:
+		return 1;
+	case 40:
+		return 2;
+	case 42:
+		return 3;
+	case 44:
+		return 4;
+	case 48:
+		return 5;
+	case 52:
+		return 6;
+	default:
+		return -1;
+	}
+}
+
+static inline int armv8pt_iommu_fmt_init(struct pt_iommu_armv8 *iommu_table,
+					 const struct pt_iommu_armv8_cfg *cfg)
+{
+	struct pt_armv8 *armv8pt = &iommu_table->armpt;
+	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
+	unsigned int oasz_lg2 = cfg->common.hw_max_oasz_lg2;
+	unsigned int tgsz_lg2 = cfg->tgsz_lg2;
+	unsigned int max_top_level;
+	unsigned int levels;
+
+	if (tgsz_lg2 != SZLG2_4K && tgsz_lg2 != SZLG2_16K &&
+	    tgsz_lg2 != SZLG2_64K)
+		return -EOPNOTSUPP;
+
+	armv8pt->tgsz_lg2 = tgsz_lg2;
+	max_top_level =
+		armv8pt_max_top_level(tgsz_lg2, armv8pt->common.features);
+
+	if (WARN_ON(!armv8pt_validate_features(&armv8pt->common, tgsz_lg2)))
+		return -EOPNOTSUPP;
+	if (WARN_ON(vasz_lg2 <= tgsz_lg2))
+		return -EINVAL;
+
+	/* R_QQQSJ: Limit the OA to what the format supports */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA))
+		armv8pt->common.max_oasz_lg2 = min(52, oasz_lg2);
+	else
+		armv8pt->common.max_oasz_lg2 = min(48, oasz_lg2);
+
+	if (armv8pt_oasz_to_ps(armv8pt->common.max_oasz_lg2) < 0)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(armv8pt->common.max_oasz_lg2 > PT_MAX_OUTPUT_ADDRESS_LG2))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Limit the VA/IPA to what the format supports:
+	 *  - LPA2: 52-bit VA for 4K/16K (S1 and S2)
+	 *  - LVA:  52-bit VA for 64K S1
+	 *  - LPA:  52-bit IPA for 64K S2
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) ||
+	    (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA)))
+		armv8pt->common.max_vasz_lg2 = min(52, vasz_lg2);
+	else
+		armv8pt->common.max_vasz_lg2 = min(48, vasz_lg2);
+	vasz_lg2 = armv8pt->common.max_vasz_lg2;
+
+	levels = DIV_ROUND_UP(vasz_lg2 - tgsz_lg2,
+			      tgsz_lg2 - ilog2(PT_ITEM_WORD_SIZE));
+	if (levels > max_top_level + 1)
+		return -EINVAL;
+
+	/*
+	 * R_SRKBC: For the 4KB granule, an initial lookup level of 3 is
+	 * only supported if FEAT_TTST is implemented. See Table D8-9 and
+	 * Table D8-24. FEAT_TTST is not supported.
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	    tgsz_lg2 == SZLG2_4K && levels == 1)
+		return -EINVAL;
+
+	/*
+	 * D8.2.2: Always use the S2 concatenated tables feature (I_TDMHR)
+	 * to fold a top level of up to 16 tables into the next lower
+	 * level. Since FEAT_TTST is not supported single level cannot be
+	 * selected here either. Notice that there are a number of cases
+	 * in the spec that require concatenated tables (eg R_DXBSH),
+	 * since this always uses them it is OK. See commit 4dcac8407fe1
+	 * ("iommu/io-pgtable-arm: Fix stage-2 concatenation with 16K")
+	 */
+	if (!pt_feature(&armv8pt->common, PT_FEAT_DYNAMIC_TOP) &&
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) && levels > 1) {
+		unsigned int topsz_lg2 =
+			vasz_lg2 - (tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) *
+						       (levels - 1));
+		if (topsz_lg2 <= ilog2(16))
+			levels--;
+	}
+
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2))
+		armv8pt_s2_validate_level(levels - 1, tgsz_lg2, vasz_lg2,
+					  pt_feature(&armv8pt->common,
+						     PT_FEAT_ARMV8_LPA2));
+	pt_top_set_level(&armv8pt->common, levels - 1);
+	return 0;
+}
+#define pt_iommu_fmt_init armv8pt_iommu_fmt_init
+
+static inline void
+armv8pt_iommu_fmt_hw_info(struct pt_iommu_armv8 *table,
+			  const struct pt_range *top_range,
+			  struct pt_iommu_armv8_hw_info *info)
+{
+	struct pt_common *common = &table->armpt.common;
+	unsigned int tgsz_lg2 = table->armpt.tgsz_lg2;
+
+#ifdef __BIG_ENDIAN
+	info->endi = 1;
+#else
+	info->endi = 0;
+#endif
+
+	info->ttb = virt_to_phys(top_range->top_table);
+	WARN_ON(info->ttb & ~PT_TOP_PHYS_MASK);
+
+	/* D24.2.210 T0SZ: The region size is 2^(64-T0SZ) bytes. */
+	info->tsz = 64 - common->max_vasz_lg2;
+
+	/*
+	 * Context Descriptor TG0/TG1 use different encodings
+	 * Stream Table Entry S2TG is the same as TG0
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1)) {
+		switch (tgsz_lg2) {
+		case SZLG2_4K:
+			info->tg = 2;
+			break;
+		case SZLG2_16K:
+			info->tg = 1;
+			break;
+		case SZLG2_64K:
+			info->tg = 3;
+			break;
+		}
+	} else {
+		switch (tgsz_lg2) {
+		case SZLG2_4K:
+			info->tg = 0;
+			break;
+		case SZLG2_16K:
+			info->tg = 2;
+			break;
+		case SZLG2_64K:
+			info->tg = 1;
+			break;
+		}
+	}
+
+	info->ps = armv8pt_oasz_to_ps(common->max_oasz_lg2);
+	info->ds = pt_feature(common, PT_FEAT_ARMV8_LPA2);
+
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
+		info->sh = ARMV8PT_SH_OS;
+		info->irgn = ARMV8PT_RGN_NC;
+		info->orgn = ARMV8PT_RGN_NC;
+	} else {
+		info->sh = ARMV8PT_SH_IS;
+		info->irgn = ARMV8PT_RGN_WBWA;
+		info->orgn = ARMV8PT_RGN_WBWA;
+	}
+
+	if (pt_feature(common, PT_FEAT_ARMV8_S2)) {
+		/*
+		 * STE S2SL0/S2SL2: Starting level in VTCR_EL2.SL0/SL2
+		 * encoding. Table from D24.2.210 SL0:
+		 *
+		 * 4K:  top_level  ARMLx    S2SL0  S2SL2
+		 *      1          ARML2    0      0
+		 *      2          ARML1    1      0
+		 *      3          ARML0    2      0
+		 *      4          ARMLn1   0      1      (FEAT_LPA2)
+		 *
+		 * 16K/64K:
+		 *      0          ARML3    0
+		 *      1          ARML2    1
+		 *      2          ARML1    2
+		 */
+		info->s2.sl2 = 0;
+		if (tgsz_lg2 == SZLG2_4K) {
+			if (top_range->top_level == ARMLn1) {
+				info->s2.sl0 = 0;
+				info->s2.sl2 = 1;
+			} else {
+				info->s2.sl0 = top_range->top_level - 1;
+			}
+		} else {
+			info->s2.sl0 = top_range->top_level;
+		}
+	} else {
+		info->s1.tbix = 0;
+		if (pt_feature(common, PT_FEAT_ARMV8_TTBR1)) {
+			info->s1.epd0 = 1;
+			info->s1.epd1 = 0;
+		} else {
+			info->s1.epd0 = 0;
+			info->s1.epd1 = 1;
+		}
+
+		/*
+		 * MAIR value for S1 page tables. Matches what io-pgtable-arm
+		 * used.
+		 */
+		info->s1.mair =
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_NC * 8),
+				   ARMV8PT_MAIR_ATTR_NC) |
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_CACHE * 8),
+				   ARMV8PT_MAIR_ATTR_WBRWA) |
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_DEV * 8),
+				   ARMV8PT_MAIR_ATTR_DEVICE) |
+			FIELD_PREP(
+				ARMV8PT_MAIR_ITEM
+					<< (ARMV8PT_MAIR_ATTR_IDX_INC_OCACHE *
+					    8),
+				ARMV8PT_MAIR_ATTR_INC_OWBRWA);
+	}
+}
+#define pt_iommu_fmt_hw_info armv8pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_armv8_cfg armv8_kunit_fmt_cfgs[] = {
+	/* 4K granule */
+	[0] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[1] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[2] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* 16K granule */
+	[3] = { .tgsz_lg2 = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/*
+	 * See R_DXBSH: 16K granule + 48-bit S2 is required to start at level 1
+	 * with 2 concatenated tables.
+	 */
+	[4] = { .tgsz_lg2 = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[5] = { .tgsz_lg2 = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* 64K granule */
+	[6] = { .tgsz_lg2 = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[7] = { .tgsz_lg2 = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[8] = { .tgsz_lg2 = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* S2 concatenated table configurations at smaller IPA sizes */
+	[9] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 40,
+		.common.hw_max_vasz_lg2 = 40 },
+	[10] = { .tgsz_lg2 = 12,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 42,
+		 .common.hw_max_vasz_lg2 = 42 },
+	[11] = { .tgsz_lg2 = 14,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 40,
+		 .common.hw_max_vasz_lg2 = 40 },
+};
+#define kunit_fmt_cfgs armv8_kunit_fmt_cfgs
+enum {
+	KUNIT_FMT_FEATURES = BIT(PT_FEAT_ARMV8_TTBR1) | BIT(PT_FEAT_ARMV8_S2) |
+			     BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |
+			     BIT(PT_FEAT_DYNAMIC_TOP) | BIT(PT_FEAT_ARMV8_LPA) |
+			     BIT(PT_FEAT_ARMV8_LPA2) | BIT(PT_FEAT_ARMV8_LVA)
+};
+#endif
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv8.c b/drivers/iommu/generic_pt/fmt/iommu_armv8.c
new file mode 100644
index 00000000000000..95878105d35e18
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv8.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT armv8
+#define PT_SUPPORTED_FEATURES                                  \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_ARMV8_S2) | \
+	 BIT(PT_FEAT_ARMV8_LVA) |                              \
+	 BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |  \
+	 BIT(PT_FEAT_DETAILED_GATHER))
+#define PT_FORCE_ENABLED_FEATURES BIT(PT_FEAT_DETAILED_GATHER)
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 13ebb72a67de31..7319fad4b7ad46 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -309,6 +309,78 @@ IOMMU_FORMAT(amdv1, amdpt);
 struct pt_iommu_amdv1_mock_hw_info;
 IOMMU_PROTOTYPES(amdv1_mock);
 
+struct pt_iommu_armv8_cfg {
+	struct pt_iommu_cfg common;
+	/* Base translation granule for the page table */
+	u8 tgsz_lg2;
+};
+
+struct pt_iommu_armv8_hw_info {
+	/* translation table base: ttb0, ttb1, s2ttb */
+	u64 ttb;
+	/* physical address size: ips, s2ps*/
+	u8 ps;
+	/* input size: t0sz, t1sz, s2t0sz */
+	u8 tsz;
+	/* translation granule: tg1, tg0, s2tg */
+	u8 tg;
+	/* 52-bit OA / LPA2 PTE encoding enable: ds, s2ds */
+	u8 ds;
+	/* endian: endi, s2endi */
+	u8 endi;
+	/* shareability: sh0, s2sh0 */
+	u8 sh;
+	/* inner cacheability: irgn0, s2ir0 */
+	u8 irgn;
+	/* outer cacheability: orgn0, s2or0 */
+	u8 orgn;
+
+	union {
+		struct {
+			/* top byte ignore */
+			u8 tbix;
+			/* translation table walk disable */
+			u8 epd0;
+			u8 epd1;
+			u32 mair;
+		} s1;
+		struct {
+			/* start level */
+			u8 sl0;
+			u8 sl2;
+		} s2;
+	};
+};
+
+IOMMU_FORMAT(armv8, armpt);
+
+/**
+ * pt_iommu_armv8_choose_granule_lg2sz - Select the best granule size
+ * @hw_granules: Bitmask of hardware supported granule sizes
+ *
+ * Used by IOMMU drivers to automatically select the best granule size from
+ * their HW support. iommu_domain works best when the granule is the same as
+ * PAGE_SIZE, it works well if it is less than PAGE_SIZE and greater is not well
+ * supported.
+ *
+ * Return: 0 if none of the HW values are supportable.
+ */
+static inline unsigned int pt_iommu_armv8_choose_granule_lg2sz(u64 hw_granules)
+{
+	/* pt_iommu_armv8 always supports these */
+	hw_granules &= SZ_4K | SZ_16K | SZ_64K;
+	if (!hw_granules)
+		return 0;
+
+	if (hw_granules & PAGE_SIZE)
+		return PAGE_SHIFT;
+
+	if (hw_granules % PAGE_SIZE)
+		return ilog2(rounddown_pow_of_two(hw_granules % PAGE_SIZE));
+
+	return __ffs(hw_granules);
+}
+
 struct pt_iommu_vtdss_cfg {
 	struct pt_iommu_cfg common;
 	/* 4 is a 57 bit 5 level table */
-- 
2.43.0

