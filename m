Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9448B29C344;
	Wed, 16 Jul 2025 19:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695878; cv=fail; b=W1n6ri1grbvEesXfP8APOna/IivQxXH8AsRKW3g/5e9wW5pdnJPpab4ovwRBKNP9GhwQn4qgDtOCX67/oPG4zYdTs0gy+rrdXvNePoFen9QJwjEYIADjx7tvF0v4VONfAM35gCC614pkgSx8cjb4cmHupmhjenS70RtevD4K0Y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695878; c=relaxed/simple;
	bh=2iYrvSFef7bKysUi5ycpMAQ60aEfUYucN7blS0H73rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sje16sInDFR5HbEu1TAN4tCFfA90j5ViHHskJ1bHuU5UKbmrMQ+31vJ5GBCqnvniJ+4eIqheUM64/q0LiI7MkN7jJisxPQbB0MdimSS6MT+1vGdOZbGt8GFczcFUiNQjShheDTzhJGXd58oqZNupzlt9oEnbembyfqVagmKfphs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gBksyDsu; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gBksyDsu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RvZM7z/EOKmEEdTEUQqDnpBGpM14F4dNkvFewMoo94FqYm1ekK862xvxCKdOzSOai+1rd1s6OODWvwCUQbnGyEgb8cPRVGM6IxUcU9t2QMKQBJGASdmyDk6cEjKT76dkmRFCWhCEr1I+4MB73Lfzaa5qYCv+v/1epaiuZOBa5v8d53sSnMQzldihJTdzTdtv15YOVffbHblo5B3mioHTYbShc4rKoz60VvPazNtZ/tSQ7xQNmIGGIV1Yd1lJ5F1+icAGHsjVFFE2U5ZgoquOX83maXiz8doHAK+gCUfec4AFXvkJHXOOxsuZmbKAImfXMSgpLuQhAWm2v5i5Z7136g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+6kPRyfy4yVZUWkr3F/myZ4X7peVj/kI1TJEcwclo0=;
 b=QT0ha9AhBJMqHISWHbPGNrWYPneYMMehMb3Oj9SQd5Zq4/mRmyiDnLynwmSvbZu7B0cU3FDvz15mYo8ZjjWh3/wkm+CP66KP03bdZ4NMnYZG3X9bP/VW1suh9KbcAImq7I7GnZiBjAZLvTukiipJAbYeD+2k5BACOZS9HFdpP3OPUD7HOSaerS0Zw1ObMLsyYhxWESQ1r5bPULxyrOKi9oNN2v0GKLDLXHIr05BuQqCqjOChWpCffptEpS/2YPpSRJfOt32D0LIi/voW2t7rtqDgqYS96j3izYTKn0em0SKioGXHzxzuXuP6CTIRSGvFs9aIYJGP40oU3985JDUJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+6kPRyfy4yVZUWkr3F/myZ4X7peVj/kI1TJEcwclo0=;
 b=gBksyDsua1kWfRz5DfWf2GnakXzYxGmlUBsxm4YE6/Z2CASYam6Ry4FKe5fiZgl/qo+MMrAJ/Vj75FFJMCs6uQTNMtEQ2kXUCMMKLpdyE5Oq0K5QFEzKe22Skvio3YmLgerB/95dheVXSadQyQLGzVA72zVe3zl0hdEx/I7tr7fO06tsw+//De2lXmd4+nki+VsvxZ+m3t+ylZ8hKmXkNYXWS/OBHBhx/XT4N6LmTgcKqgiM6+JAj0MKhR5aAynC0lpgKjtbEE2XqUmf1Eg+zGQFsezIJX2MlSwBJXJ8LOFqdCjXwyIhBa7w49bymA8sFphB71ao9Su4y4v6rK2scA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 7/9] iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT
Date: Wed, 16 Jul 2025 16:57:43 -0300
Message-ID: <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0018.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bc38f5-b1ae-4f01-1699-08ddc4a30a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0qgC+BlaqxZbn6AeVdY8tozNHvWMbXUQ/alsbhFCy/HZ1BOF3k3taati+pKR?=
 =?us-ascii?Q?1bwnr0D+LRaYNkK0SReJrdWJBOtHuTIPfu7FEtdoAV3+XWjlUsrwm68ToRet?=
 =?us-ascii?Q?d3kF50pLMpkHXOjX2XoqepMttFH/CykOtqh5FOT1mm6nWcUFxUraCAETYtgy?=
 =?us-ascii?Q?iIBVlE3tvusmgxtb/OpoH8r94PiU9XjaMvHUHJrRXZ0elzLojPqOZ+zlFcHB?=
 =?us-ascii?Q?pNRttW6N/EysI6n1YlKTOW/GxMoHNA1+pVffFVVtLDPSKcNBNcBqMkZ4YPDA?=
 =?us-ascii?Q?JbFXxItsHUvmolByOGbSTX9uz9KPw15bBCR9Godbt27ruvC4h2l37qWbyTqh?=
 =?us-ascii?Q?ABBludzO5VSpaujYQnGpy1ld0SOrZKQmzWY1TYV30C7WHZeEDZaRdyN9Ihvd?=
 =?us-ascii?Q?fWg5ldZpoHKuscaZg2sdyPJxWYF3IMiS4Y/j7dFUtwcQvEz4itKumzxY6rLd?=
 =?us-ascii?Q?TSgO9JX5MdZaRzpmuYDDpljEj17BUy2ehDlwttIwxn+/UdbV/eMtCFMAmXId?=
 =?us-ascii?Q?vvERJ8HunQ9/D9tev0UCsEY9VmUtytAwlCoiHeYhjetC2peNZw1BVcqQTbAU?=
 =?us-ascii?Q?o9iIi8ssBQu7lEmXUNkvvR2xI7xztPyHqFpZGHCV41DaUUmV2zRZ8PiQfA4A?=
 =?us-ascii?Q?S8nnEjOsznc/hBvBLqHo9ZI+hiTKo2gwDxRza56lHwL/ryCrjrI6PVHI6euL?=
 =?us-ascii?Q?k1jrGD1sIodhG2fR3bgNJrmWVs+pormU7KaoyH7fe563HqA2g5xIVQlXxVaE?=
 =?us-ascii?Q?uZHhUSItQyQRh6hnr4om8mZdkPd1VbnDZj2aXH53eeboLZlWJhGzjcyLm7jr?=
 =?us-ascii?Q?COwDptEQfnHV6E8tdUXQt7GnpzlRM7sAdU/CVaXZJw26nCQe5A3kzYV7ehUt?=
 =?us-ascii?Q?PNzt0o8blkzanXhFLTL/rrsN0Y4Nf2HJwntJqDeX50tY7rHBBlRgm2Sp0+7u?=
 =?us-ascii?Q?TdfVrinIGSl76fHyCK1oiA2cOKP3XNIvu5PGWu3VNEcRqXN8X9XWniXW8ADf?=
 =?us-ascii?Q?YCGEKWqEDD31cQPEC3jNHA4+vKu0X5neYrjAYtnquwi6pYfXnEM1xoTlDfkK?=
 =?us-ascii?Q?vW2xMNsJNrget4WWXt2jJ+GcWw9QSeXobkXklsBRM5zvEKI3ZckhQbj43m7U?=
 =?us-ascii?Q?Em7tPBOrjyGpaveK0f+su0DHNUxa9qNcjCRoJ76th3oz+bmhkBWP28yCetc5?=
 =?us-ascii?Q?9Cf18qamaINGGK9pMiv7k7oow3GRGnqp1TgI93NDvGl4+PeJwMn6Yf69lvM/?=
 =?us-ascii?Q?JVmAlbT6ny1G7vgXWVRy4Ppd1l/3QOvu4e9EUNiMAPbUaYC9BbV9xNUTiE4j?=
 =?us-ascii?Q?UtVq53G0+EmfsecAVmoC19XMw2CwA/IS2HjU+YyaSoDshN9M8DOy3PRdSc6H?=
 =?us-ascii?Q?9CEf5PdAsINP9ZpWdYdRWoyAgp8YQs1QEqr1nuXdwjMWJgwTVaQbv0n31HIv?=
 =?us-ascii?Q?BbxFkiNMOOw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DAnnUvuTCynWKqG56319TuZO7M2oWPo1UbbjDp+hncoq9oW5RCi3GweJ/RQD?=
 =?us-ascii?Q?HGyf+AoKUfC0hDJczYZFOvu5+wkrqc58DB8QkHTNJ27WO/L37EMrcn98w3jO?=
 =?us-ascii?Q?GgyZ+FmmC4Xp1/vXzQ9/KuaOPN1ZW9DJUX4KdzB3DuyYALnAlk7L68ZHeW8p?=
 =?us-ascii?Q?EJrulwOm9G5wKc7/j/aLF1BVedlgqXsCgdY/boqHqmGbAAGgYjURqGqalDBJ?=
 =?us-ascii?Q?6BjBoR+/XlrVObjtTIQ8ul3qNfaeuA/OYKvRdwSf/fDZs8mqz5Bl1Fqcrugc?=
 =?us-ascii?Q?Dg4+B9vkZ3m9vVKCLd+duEKN6rfOhGaiPVqKuR7V9akQZX+GiCWlr9+LPxKG?=
 =?us-ascii?Q?duoCHhXMP+EVM//l25yQ3NlPTYJu8CQRpj93dXhXMutVSRGEV7LNZIbGOivX?=
 =?us-ascii?Q?9wOhet/usXnEAHL0IIwBwClQFHQjqHNAK2CQRQuSW8D7iFoxaB5byV0KqRf6?=
 =?us-ascii?Q?ct3+IOy9JOqZma2ibvGhWSum5JhXAwBfzvBqbw5KnB2llH7TUR/FmnkFemqd?=
 =?us-ascii?Q?X3n91vUeM/GZ95v4b5RamAtV4iduvKD1tGWyA+3RCqwhjLgx5e6XUIEHHcW8?=
 =?us-ascii?Q?/5qnhtta4hTFgnSBOVcOugUmi2LDDTLPBY1Owlacq2A+Bav/ciER2Li2jJVm?=
 =?us-ascii?Q?gr9sOiWjW29n3tFxyKL9hYIIsTMS/9T/rRfBUDyymCe6+oCXtzN37jUYJ92T?=
 =?us-ascii?Q?IzYj85RS3n4cE1xAUdQ8Pey8fP80OWCkmycb9B+qMFI9dSCli4JaDh816X+m?=
 =?us-ascii?Q?qFy+Ja6/VRyuX/hCxL4Wcht+9i6Aq+vNPe8rxhjTiDpynyKqzz+/hdSvjqKc?=
 =?us-ascii?Q?VU2ZK73xCfNqu27p704/nGVx2svER8QgljG5Tez1UfOxHEDqyO9GIzA/05y4?=
 =?us-ascii?Q?V0wM9/psLWJVzpv+F+8QaG8y73mGGOIrHfcGYMUuxEW4q34CHvlrX1PXdHbC?=
 =?us-ascii?Q?8rvCyzrif1fcLrmBqOYd7lt1kv0t5j14/Emz7lWFBjrVkfe7H37nPEzJM9vV?=
 =?us-ascii?Q?sxw0jrCD5fMO4UFsxwhHrFbWc8w/wfwEekW8VLVnMq2tyCMwO8gd5rNE8/lN?=
 =?us-ascii?Q?tloYeN+DrXkOQpDe4ojJiKnUeqDrrGx0NhAZ4l7GTW3GN/x69mTEssqCNlfy?=
 =?us-ascii?Q?Gzq8r+R9zht+vkk978UHaCyseMNc6zIrNzN7pS0Bkzy5XJsxYjsgXMIs2qU+?=
 =?us-ascii?Q?lmNdph4ZAK6iDqV60Y7AT0tX4f7/+IlRgO6Z3Oc2JJndqa6avxd4vqt8/N/K?=
 =?us-ascii?Q?Ct722fU6Off0dzzWW37ZOezcUQWi2hTDVDZLzQ6xjdhwRQZXyflHcLXuqe90?=
 =?us-ascii?Q?NDvsa1nbaPPL8p47nScownwfR/IViI73REP/rkWWo7O652zyLCEkkhphtEvj?=
 =?us-ascii?Q?ggGb5ljOpj0zGmShAraBViqZ3fuBNkV/Fk8gXK2T4ZXlwPgfAJhFXvvqgrEy?=
 =?us-ascii?Q?+H0t0i0kqqYPaol2DVTEOfkJZHdExv8WyRKy8ketEWC/YipSA8Y1JvHYMcEK?=
 =?us-ascii?Q?nTgXCi/QYhISrrJpwEManMytHut42rjWXWW3UkupPXzrplUqzIpi6/+fAr1F?=
 =?us-ascii?Q?ZJR0P9ngSN9Fwnevy/zSItGZ3K9EkwBNniOHoLuP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bc38f5-b1ae-4f01-1699-08ddc4a30a22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:48.6773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPOGcBeVQePkeLoqYUUxsIQx88BOky6zMgUHQaa6wdd5tbw9hzOU7H5/gDvlbrJA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

VT-D requires PT_FEAT_DMA_INCOHERENT for the x86 page table as well,
implement the required SW bits and enable the feature.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/iommu_x86_64.c |  2 +-
 drivers/iommu/generic_pt/fmt/x86_64.h       | 27 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
index 5c5960d871a32f..5472660c2d7156 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
+++ b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
@@ -6,6 +6,6 @@
 #define PT_SUPPORTED_FEATURES                                  \
 	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
 	 BIT(PT_FEAT_FLUSH_RANGE_NO_GAPS) |                    \
-	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES) | BIT(PT_FEAT_DMA_INCOHERENT))
 
 #include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index 60f8bd6b164b54..1b691f7cbf82d8 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -160,6 +160,33 @@ static inline void x86_64_pt_attr_from_entry(const struct pt_state *pts,
 }
 #define pt_attr_from_entry x86_64_pt_attr_from_entry
 
+static inline unsigned int x86_64_pt_max_sw_bit(struct pt_common *common)
+{
+	return 12;
+}
+#define pt_max_sw_bit x86_64_pt_max_sw_bit
+
+static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
+{
+	/* Bits marked Ignored/AVL in the specification */
+	switch (bitnr) {
+	case 0:
+		return BIT(9);
+	case 1:
+		return BIT(11);
+	case 2 ... 12:
+		return BIT_ULL((bitnr - 2) + 52);
+	/* Remaing bits 9-8,6,4,3  are only available in some entries */
+	default:
+		if (__builtin_constant_p(bitnr))
+			BUILD_BUG();
+		else
+			PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit x86_64_pt_sw_bit
+
 /* --- iommu */
 #include <linux/generic_pt/iommu.h>
 #include <linux/iommu.h>
-- 
2.43.0

