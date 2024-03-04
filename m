Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592691E4AA;
	Mon,  4 Mar 2024 19:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709581815; cv=fail; b=k21rw8F+YphJV4gtbXyQRTnsaIT49k4qvZWXIzmeTwxocxodkX1Dw6rMNiB1FYQ7AY/NzI48rEPIW1lqkGPVdBKmSnt0eiSbjFtadSQE2K1pwldi3VFxfZLarOq5KMMIuJvjxVPFfKPqpzT/0URdzTw+c2lkYoR2A/ToxXk5IRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709581815; c=relaxed/simple;
	bh=quf4zo6ZcosdN6toK9ClmJShd8I0zqd7kjwqcIxdWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pwn8L9xEsNb+kPSsLHgLaYqkGVupVgApx3OUF/zzbLch0d4fVn1sCgCmFm4DyzoA/a3QdTZ1RGGfULD3qUAmEtDe7KFl615zP121jQorMQrDBuOX3iUiI40cAiZmtxf9Tl4Mf7grYnp4DCYnV/j5+nNlM0iTJXQLaY2kaa8R66Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mLLLsY39; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mLLLsY39"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC5hgEmtefbyha4tye6n3Fh4DozWJdIZQ5L68CPBgZb0BziArWp+qSCkflubQsir9idtVkIeRatrR3hXXJRVNp1ejjCZ3kDLpAVtPohgoJ0TNJj7NzgcWcFxmrQ5P4F6GMv+pUk+FkBNJX8RbWWIIXj4n+0apGnd1FeaHeQYjimkM5UMWCeZQcQZWjIRUT9vWAhukpASvyl5KScG7rya8TAr1it5yVwmmzaVTNAqmTzE4i36LL2hi7TlEPVbc3m4vN80gpGzEJb+fuxp4pa12fB9DhqSLVw6fn3gsSVrpVUmc9umnnJdpb0lBSXQy5/Y1iKnkO4pzKOBafaWmk/UzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bu7WOeDFaNE3Ty0TDl77ta6f8joTE9Bj+Zdo+g96Ug=;
 b=is6eNS3pE0ldAXI9YgPemjMZoFeyOMUJwphR2vxwLFFyDZOiUmg9meI8rqq2lmVAXqSlHncNUilAeWo4Ifpn59rgzzNYUMEqEx6bb5izydh847pNVsRVOE3JR64rNpQNy1T/d1uIDLWvzkdMI2yuajYqmmYtyL4aIRSU1PGKSreDp0Ea8looWzks0K3TycIhlhYARdfN+bqPJwpR0W2k7e3BVhYiS6EHqOB3N0hFbxaPAk1iYri1ro5EKUp35bjaqMbe93DhQCs8GGeH8ypWKuHPPi0ojtzhdlEcWkBw4pJgJH4r/lQJLfB1xzcyf0h6ElWWPhGZKB4HCcOIOw+JHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bu7WOeDFaNE3Ty0TDl77ta6f8joTE9Bj+Zdo+g96Ug=;
 b=mLLLsY390bVImYKLSGoe8duRZBsg6OJCGVUfVR9rpbVCbU8lYy/7VIwUMU+wKaLHAxTUYPv++bRODRQGwf84N1iYyq4zBvUCkPoTsGVDeJ5EVWodxwuIaPNjrQ9U1Yu061+oTqDsbbR0jVfP/oYYVzs6xFLzyDHJsuI0pSLGkYD8KfFPIC/C6v4QFQPmY4pZTFvZcrcGKbIY9LChLtzauvco8turYxh4LIc2xH5fJvxr2Gyb+aOP0MwlXh0seEGO7MlBl0KikNF4jIS6wRxVYOBPNcvLb0VsCfaPtWpeyv9O2mQ9xAtWvnN+9yNXCLY0u7/sFL3RYHGcHgBB5s7X1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB9002.namprd12.prod.outlook.com (2603:10b6:806:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 19:50:10 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 19:50:10 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Cc: kernel test robot <lkp@intel.com>,
	Michael Shavit <mshavit@google.com>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH] iommu/arm-smmu-v3: Add cpu_to_le64() around STRTAB_STE_0_V
Date: Mon,  4 Mar 2024 15:50:08 -0400
Message-ID: <0-v1-98b23ebb0c84+9f-smmu_cputole_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:806:121::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB9002:EE_
X-MS-Office365-Filtering-Correlation-Id: ab08e4d0-7d3f-41b7-a883-08dc3c844cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/PM0hgJOkpg42iakGPZYOAEtc0dKtF9WTWdc2xEHR4/GDUQeuyzB1pf1KP1yQ9NXqyfqE3tpP0Il/X9mEc+IuTwRvRsfG5eHYWm6h8f5qQOpcEh6kBw0xJ/jsafjlQbYczyRKSo15h3s3MgmnflqkLhBAWsboePNmPS3Pbl11oZVdQRjmUFc52peLPneb339bKiaZL3F85Ed/rJj4/yfoOPEyC1Q525OI7OwI+WydFBTzWv9EcrfVnr2rZ5pGv4sfDobU+fTxu3Hbo1CrgWAR+fUtCn1ahnN4qeEeGiD4F4CM09Y3Eq2qNBpe3wBsneX2znBzv5WJPmvqXAe9aCr/zXzcgz5Imt99hhU8cy3vm125otcfg+/6j3keGQzLq7BehiPKyDZjRLOBa97p5JBYy4NxWZKTvF/1CGwYAYCmFmfidImrKx9p9SfxboIzxWMFKsxbP/Yqk74xC0bOvC3x0P3x/lbkDXiErPIxp1wNP4sipRmnQf1Ng7Gg3ajEgBjlfR/27Mqc4v+fr8aInqC+5r/ti6px/VPVS2Pyxr/fAMYIsH1GD5+LPHgvS2wPDc5gsnzo5yQrUykNsYP0lxzbO7u7TuXVG+Rp9ANxK+VrLnl4GOgvsrdD/gUup/KsgODc8N7WufXuxsLvNRYVNhH2xAI3M0LVUPjlt+06FD6dPY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bcqbHH0wxHvPmO60g4ARhlEWN0hGHaJpT5uobnv/dLZQ1Sd8J4Bys3EL8ZIx?=
 =?us-ascii?Q?MOseTHukEjsmo23snnXFgOlP2jzhswqkMYtYcYfO6HPpImbYh/aQeGAg1z8c?=
 =?us-ascii?Q?QiqNZ19P5zz7afsBGC2eELP17c3Fa9mR5+cMQ8pf9mNbzlvbI2L6dAVccP2I?=
 =?us-ascii?Q?3u6rlSNa54vnJDBwr6Q3ayr5osM2MN7fnSwrB+33sPjFL6Fdo4Dexb998WVU?=
 =?us-ascii?Q?92Ou6MEYVseyx/0RnC82H1U5q/PHPKrjN7VlxvqI6f3LCLt0O0FPXXEToZIm?=
 =?us-ascii?Q?lGab4k6CrNcNkz0HtbfMBQkqlrrAn86fTTKBkWm30As4KWUaaC/k7bzdDZsT?=
 =?us-ascii?Q?bE5RnleGq1WKJ20swwfbDOhCzg4tigaHiIobyNhq5LSlaCkMeqGK2yxAl00P?=
 =?us-ascii?Q?GTOq3I36SQ03xujr/k7CVDC0bajQKwvn2yygpYlrsB2DukR1+kUS5uhPQht4?=
 =?us-ascii?Q?Qr+yOAoZse6Z+pUVpxQPakHvbV+wiAcMZ0jw7UFWC7DblrMd9X8mLxzFKRpK?=
 =?us-ascii?Q?VH7Npz1eZnYflHdZWzPD5kq6VeSEVAHnKBjQbHNujxeVhoNZEkR/suIcWfWc?=
 =?us-ascii?Q?FM5BJUxrrBhJVSkmLG3qTwTsosfo/mjdkjPojxVlirPGZO2En7DtMzM4Pn+t?=
 =?us-ascii?Q?vBtoLOZMO03BLc0kbcWVVRQcugXubB7uBqFQNhusR9lGTZS99uCwig5trs+v?=
 =?us-ascii?Q?v9gOxfwMNDBaYidSTOWGtVUeXxsOTLJ1ffEsAu2sajU/tOgLuyBYYsSF6zh+?=
 =?us-ascii?Q?apRMHyckAKfwzq/f91zcUkXbZYdAgQFln+w12EVYKe1gTIDwGNxIRxt/MSq0?=
 =?us-ascii?Q?th8boDG3PZ8vburng7bUS7xIHv6rKPMoCXhWAxDYL28g4TsUtvOPrfu8lG25?=
 =?us-ascii?Q?C5fFQfhqHTSc4/0JYqg4NKymQc7g1YCm9NUHBkz2+CiavO6+nJUivSLDX8gE?=
 =?us-ascii?Q?RBiJNaOnHlnSSRykOfivDO3LYAMpDUKboq6qxI/olfyTU981rRbd5+z+gZHy?=
 =?us-ascii?Q?ZnI7lK+l2FA7j52wWAtlQpbRt44RfSCDcGW/b3fvVLrKookHGPYEpwd/A3Uh?=
 =?us-ascii?Q?9Cwv1f7TXG835lLpTzdOvEthKKCECizAJ4WFvus3C9+JFSwfKW5fMpcBX+0e?=
 =?us-ascii?Q?vEB5DvHVih8jKul6W9rsKkIMT4Xwx9LCfHh39D7jY+Rd58xY86MSpGvjE+J3?=
 =?us-ascii?Q?We5wHl7Jkz9mFelk8N78DX51um2NAWm1lRfm0MGxf0gWDjlQS4FjOxuAQsEM?=
 =?us-ascii?Q?953n0anm/lsgOIDI8PyvJSN2aNp9t9xSEjOiT1L/9qT0KqsNYq96ILeLzhbA?=
 =?us-ascii?Q?tdi8x//l+Y88QgiSxNnQXdU0K0J/WPPwg35wIZlDlLdPRaFcSWIMk7OTYFJW?=
 =?us-ascii?Q?p1ss4+IeepXwH0i41RIfuVZOQwerVzVqE0roinIUx+SaOm1LrkUzkmkwiQ+J?=
 =?us-ascii?Q?Vtpdb0ZIyqvZIIfHjyLrLu+AzNvinvawwofpIWzZoBZl8luNgnnd+be7S38M?=
 =?us-ascii?Q?fdVC0RkQNSQxSwIHB9thoiyMvEzYpxcyvMPldz2seTK82g4SV28lI6Z/xsxl?=
 =?us-ascii?Q?7YBJnh9UN0F5B4nk+KM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab08e4d0-7d3f-41b7-a883-08dc3c844cb0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 19:50:10.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExbNrqznF6MuthVC3FK4wuShwsGBzqNqClCHr1ho2F3DgZUePRCxpIZadIlQZzY+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9002

STRTAB_STE_0_V is a CPU value, it needs conversion for sparse to be clean.

The missing annotation was a mistake introduced by splitting the ops out
from the STE writer.

Fixes: 7da51af9125c ("iommu/arm-smmu-v3: Make STE programming independent of the callers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403011441.5WqGrYjp-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Unclear why 0-day did not notice this when it covered my github..

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b7938f17222b4d..d1bc151a5dff8c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1144,7 +1144,8 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 		 * requires a breaking update, zero the V bit, write all qwords
 		 * but 0, then set qword 0
 		 */
-		unused_update.data[0] = entry->data[0] & (~STRTAB_STE_0_V);
+		unused_update.data[0] = entry->data[0] &
+					cpu_to_le64(~STRTAB_STE_0_V);
 		entry_set(smmu, sid, entry, &unused_update, 0, 1);
 		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
 		entry_set(smmu, sid, entry, target, 0, 1);

base-commit: faa6bc241bb0cd181f557d67bfd1de8223014f9e
-- 
2.43.2

