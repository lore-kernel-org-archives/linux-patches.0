Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBFC38F9A;
	Wed,  8 May 2024 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194657; cv=fail; b=AaQsT+ek/28Wwj48OfSQarsqnxxIHDA7IGJBqojdMN3+6TiR9MtcMBgFAkG5LeLRiAAu95ci8tATvHbGNltox7zMabjO/pruewOxozJccLrX2sn5i2wesYVrQz87CZYpaI7HOJoYZQ+acF6Mk6SwqU7Se0n5s9tlziNm3RV8QH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194657; c=relaxed/simple;
	bh=vJ/0ERresZUgQHZzFHh/WL2kCG42LNfMqF/XfVnhUPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X4L3qHPwJ6xnFGiO9FmzNOfXIT3PiqEA4oUBSqLmVfBckvf3Ty6qa5KA6MtcNanFLJXeEBqDUSoSBoU89ZdVYCiBMVdbEVZZ9Ot9u/f8XIBWSHyxLf0qh5tINclMk4LjAdDnDNiJypOcRTYAKoIfVTbBVMdVwETJKRP8jZKDiNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jJyuQ9fk; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jJyuQ9fk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTGgWaVhKKJfzpRRJ54/8LvyjIZNaK6Rr/gXRA6uvNxF78Xj7YW4qVcu3CR42TJ4BmxqsxwzIbd87uqZeCudVr4xcsBorgFIBuDw/VL1oBo8oUhYObxsSZGcxcFv48jaC0ajm2xgRUwgG4OTWOZ6XY4r806w+o8eHMGXx3W+IrOEn97O1uu5P2PJqETHmWJSF57dzDkkKufCGKfqm9lx+I+TBM9jSrl2Axz5K26gxDNx06ixFHnK9rUFWGOFrzjxr1QS0OQXIinVMlVtyJBjXq+II3ScURtPvLoEgSloC1x8AUzRyZGGymtBa4Yt5bV4mqo1qrmdQ6Bd5safn9+ZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NT7IIbn9fz06tsa0c2eTS+8dpxS2z/WQIjjoLDkyu24=;
 b=TM43J4JQoFjYULv3gsR8AAuJu8WO06MJkDttgzq/LjtTRUcD3TSBRkLizHnBs+sKINSm+RxoZrlKFB5KLjnkHHt57dbg7PC1UGlMChbluSHu2WMVX2TMJKI9yVx9mS34n/BGMsbjpVD2XvR5bLZ57ZuA661P/8P/RQoDLgN/fdmmyjQCoV3Fjoi8D4KbvQMkBtw5lqpbNlNETRZohntKTlv5gh734ptCc2RZ/Vwnku+UmPJwpJRTeH00FT7CMLG+CFJIVt+sSMkCugiaezvwMpk5N5PR4HSk9l3Es2Arrx2HLR2MzJZEM7W5q15TB1oix65AKgmwBNdnNiKSxc8brg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NT7IIbn9fz06tsa0c2eTS+8dpxS2z/WQIjjoLDkyu24=;
 b=jJyuQ9fkzbPx2qbT3p/idYfQY3mwIm5UcdfGwdkwhzZXe4Bsiv0rP2q+TFp8nNcXTgT/j1aTh3DET1ZUN4nwVsViqSUqRuDPdV4Tke2kZ/yorq6Me3oprppD6tdGskZYe6j5pmPsUOLEbLpP3OFFiaZvbSxE6dh9VHgDxVT+ePVfFWUCoWMeh3FSWQfkLybQjdkZ73s9rTUwS7lJ2LvVk6nU3+0jHb7M4hCjqQtU8MMPz94CUF6zKOh/Y357PBeQeaXEXGIYcxdjZeNPOCd7Gn3/Uso3M6YJ/+A2nkd/s+QKisoL1TSUxgPI1+2NM2LZf6X0ZQuD1+uIYZlSe6W9hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:26 +0000
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
Subject: [PATCH v7 11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Wed,  8 May 2024 15:57:19 -0300
Message-ID: <11-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:208:2d::46) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ff2d49-ee49-4c8a-670c-08dc6f90b324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7JlDt9uVDSr9FOmQEV44TbTQWou1kVOrgjb1tgje9UkrQTm7nM0ikOd7Jh6k?=
 =?us-ascii?Q?9/K3OcKxvHyuvTdEBsA7POFb8iI6qDuFIfb8zb2urLDxwsFtR3oSxIZqXY8Q?=
 =?us-ascii?Q?FeGFDImJIl7gBmfrrhMbNqInzC3VUkFcxrZSMUIB92Ue6/a/Jn0Vs+/gUmJ4?=
 =?us-ascii?Q?T9eLzoj7y+2bNaHWwvFYItU9t5uCT86rWwos/P0RJ/mjk+TaVavsWixBx0a8?=
 =?us-ascii?Q?iTjYv1afXkWVLueg4wqNdNnM1PW+7gwSCio2m2rn7abStzCSP101g72nCUFF?=
 =?us-ascii?Q?aowtYYaVH2I/hA0DLNXpLln19lr3ejvgxF4bLg6RWF/XjYIDLu1UABeUYmUw?=
 =?us-ascii?Q?BG0T0aZ1vDviUH0hy0CzP5MZSAH5ajjrTZoP5Mgq4Z5GPFOveQt0fmoT2fth?=
 =?us-ascii?Q?u7Oi/ooY3SfbRonygz3eZk1DgphnoNY5rlbfCRaKQncT2R62SldUbF5b3ixE?=
 =?us-ascii?Q?HlF/TrSAGPaPcr8bvSwKfNuwZ5Mwb7rfRK9/np/Ck/3CwHyatwLp8qvf5ydC?=
 =?us-ascii?Q?H3FYcIwAicRGaGwuH1zzc8q+nxdIEUMFmyzktyS1+210yJVjSPh9Jils0FLE?=
 =?us-ascii?Q?mnRAndSG5y8iy09vAFVy9f2npLBIoYSN/V491QNIJulBSwQx9ZioFqdNIA0P?=
 =?us-ascii?Q?W9h1S5u8vcmyAYaC/3dGbV92IoXVRO6KoRBOqGEPwVji1cB3lMLbnFceYEK8?=
 =?us-ascii?Q?m8g4CCz9gzZxqyD0XVAwR0gm4qafKXGojXDCT5TnszoSRyMXxUvh/Inq89jT?=
 =?us-ascii?Q?MnJ8RUKNde0IlreQ2diK3DVeHN+dNLYbGRGkgN4+MhA/gqUZvvD3hkhfWyIH?=
 =?us-ascii?Q?kRWwv798N5WO7yIf0z4JueW1GeBhWI8kIcdMSV62lSE1hX3zVcCFS6ZhR1ay?=
 =?us-ascii?Q?zcKshmTmtGpud94d+clBr4T2Zy1l5BAXVMreAvSDhnIhKe1ddcLrJ7OJ1Pp/?=
 =?us-ascii?Q?85+ykg4+uApCTySXourI9dx0Wto+mCswR+5xnTQClIB13q04vbNOIwQ8Ctas?=
 =?us-ascii?Q?JIax250k7yAV5BXtjUSMmW7uu0R3q10Heogqu+8Sc99OaczHzeMhkGd6Evsv?=
 =?us-ascii?Q?1STRs95JCyw3KXstB0y0Hw+PPRnm+muUxrtYZogxdeYBvY9MY80tZZXcjTr4?=
 =?us-ascii?Q?zH+Q/NwODifm54OEw4XeUT4cYT9nHsJ1nCe6iIzpiCQg5pF2+tw4APalSsWd?=
 =?us-ascii?Q?Kscgyt9r3izG+69Dmsq8/y5oiRblbkkbI9jLGd/AIk7R1M+m0/vo1mxn0Xlt?=
 =?us-ascii?Q?gGE33yQmmmxm4SU8f2L7ZUxTi9OuwHkVZbXR6jbRcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aOV4llNp3mQBiGzPvHrL99JRP0s6aZ+1TGL9UPF3XOlpDup7lg2VsydV5qKB?=
 =?us-ascii?Q?YAKtvVWKY7ZmIfu89kZbRr7C9t8/RF+/fxS5t2LO1E9kXoNyBWRW/vuRnmlY?=
 =?us-ascii?Q?ivqcAvvlwXfc5xMO8DcOiffk3yx2vlIzVb8qcb8O6G8SWH20dElZJZLbAHAp?=
 =?us-ascii?Q?EuMXyPRs4tYvwDlY4YXLoGw8xOkE2SlIWB/GyJO11CVWJsfu4f03iVaXXg5Q?=
 =?us-ascii?Q?T2r7m+ekpZcJTvPbAWZ9OdHsJfwBpWxpsuiY/o267+MOKNSY2B4dTHTcEPXM?=
 =?us-ascii?Q?xpswEseT6u6yoZetCJhoPz1YFvSVfPoOAoDCS+cPnuKit/bor6MDE9yIXp1h?=
 =?us-ascii?Q?jgYdc+U4nNypiS3TWEUCilcebJriZYZtbzj2BnZ3cxUDFVrc2vDZH0V2tPIz?=
 =?us-ascii?Q?95+GSKvxhInJ9wMRhVwEf2Fo6v5ooT+IZPC1U667EKhgvZUiyAvEt1Levrnf?=
 =?us-ascii?Q?fFiNn95MAjaDVJVMEIRhfGfNReTNOct5QkMWIxEPAL5i0XYsXbx4uXa+TzSl?=
 =?us-ascii?Q?gIZlG8m7VxrBk/AUlrO1kDp5IEh79JvSP8oRtCpd/pDmF/rxTZNPO+bm5zDn?=
 =?us-ascii?Q?D6By5S3nz+pivWMlYSRFeAXSRhg7drbaumBUwO2xHQ8Mbzlgz8/9ks2t8/pV?=
 =?us-ascii?Q?Wh0FJ7VDQvH8QCDS/VF3nDcyf6Msv4ftDQ4KOEfU3u+abSYRVAS5/aVVsC8h?=
 =?us-ascii?Q?QJXaV/jvz84aK1RZ7taJFFuCZCZe15GuPPygyWHwtKPwExqa50Fp9B5sthrH?=
 =?us-ascii?Q?7TTkHDqepz2yinbmaPcgSTG/opxJGOvtYUFI7wHnRN0x6ayaKXfnKFEyDswp?=
 =?us-ascii?Q?d0zA/hGoMVfzKeWilwSMxkg4wys06GLSK0c5nqkCde7Xz0NcYcplk5blolVg?=
 =?us-ascii?Q?KciSN3AQtADYvKWdMHE28CS8iXxmYZDOaQgHzOEWlxjBzMMhyac69aesQpTE?=
 =?us-ascii?Q?cyhBePeWvGzTt32lI7roKpd2cv5Ql3FoJv84A2gfJqevKxjQnuxR8/InNfS5?=
 =?us-ascii?Q?d2a6pAAdRugbFYB86JDTHq2lxUTlYutRG2liybtpmN1ExCMHIVg0IdhvUDLr?=
 =?us-ascii?Q?j3sEqi99esRJZXTImYdkmfi5rDO1YtBEgqWcCjEOu7nkgEBR4Fvt148O4Ft/?=
 =?us-ascii?Q?A3Y2IEy+oVNjkkt5ruJLko9LcGpb0o5SqWFVZhZxDSeobyk8Hsla9DztijTm?=
 =?us-ascii?Q?mDAtuvXYKcUXxJCJwf6wXJF6GxZKo0M1uAUp6KZjvS6lhGPi8zytxy0sCpiy?=
 =?us-ascii?Q?zUtbN1axccW33n6b4gJ9HzbOD3n1vmYUBJk2acUXYtWeDgUCJmVP28+0XUS8?=
 =?us-ascii?Q?C1isjmxJl4/72r8cjvmzuCqxy5DTrcHSujSU0SgcEEAmGYLCIy5aymBvIhRU?=
 =?us-ascii?Q?QbM6N3bO5BM3a/Ye4caI/G5qbU8Tvlh7Tg9HMsymFJP59J9ug0225A60rAQX?=
 =?us-ascii?Q?YMoEIk8t+4U6+rFc7jdH0/7hMiAWNW8f52EN+rsef1DKePzaYStpOytzCJnl?=
 =?us-ascii?Q?2KjqgJKyw6rSOv5t0YtUAMiXJ5Bh+I2bm36Oh7qDNXGJYZJkqO1Pm9SJTeO0?=
 =?us-ascii?Q?9eVN2deT5CL0LStLS2IBkSRclIsPy7wwAimxcH3i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ff2d49-ee49-4c8a-670c-08dc6f90b324
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:25.4428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqbI2EUItWs1GapQavis6faYVbGjvjQL9q6SERpF6yoAXKdWpffpmjA3icHTU2ma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

The HW supports this, use the S1DSS bits to configure the behavior
of SSID=0 which is the RID's translation.

If SSID's are currently being used in the CD table then just update the
S1DSS bits in the STE, remove the master_domain and leave ATS alone.

For iommufd the driver design has a small problem that all the unused CD
table entries are set with V=0 which will generate an event if VFIO
userspace tries to use the CD entry. This patch extends this problem to
include the RID as well if PASID is being used.

For BLOCKED with used PASIDs the
F_STREAM_DISABLED (STRTAB_STE_1_S1DSS_TERMINATE) event is generated on
untagged traffic and a substream CD table entry with V=0 (removed pasid)
will generate C_BAD_CD. Arguably there is no advantage to using S1DSS over
the CD entry 0 with V=0.

As we don't yet support PASID in iommufd this is a problem to resolve
later, possibly by using EPD0 for unused CD table entries instead of V=0,
and not using S1DSS for BLOCKED.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 67 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 +-
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index a460b71f585789..d7e022bb9df530 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -164,7 +164,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master, true);
+	arm_smmu_make_cdtable_ste(ste, &master, true, STRTAB_STE_1_S1DSS_SSID0);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 15378c131a5bc7..41d7a0664a445d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -991,6 +991,14 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
 				    STRTAB_STE_1_EATS);
 		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+
+		/*
+		 * See 13.5 Summary of attribute/permission configuration fields
+		 * for the SHCFG behavior.
+		 */
+		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
+		    STRTAB_STE_1_S1DSS_BYPASS)
+			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 	}
 
 	/* S2 translates */
@@ -1531,7 +1539,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master, bool ats_enabled)
+			       struct arm_smmu_master *master, bool ats_enabled,
+			       unsigned int s1dss)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1545,7 +1554,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
 
 	target->data[1] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1DSS, s1dss) |
 		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -1556,6 +1565,11 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if ((smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR) &&
+	    s1dss == STRTAB_STE_1_S1DSS_BYPASS)
+		target->data[1] |= cpu_to_le64(FIELD_PREP(
+			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
 		 * To support BTM the streamworld needs to match the
@@ -2733,7 +2747,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master, state.want_ats);
+		arm_smmu_make_cdtable_ste(&target, master, state.want_ats,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2806,8 +2821,10 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	mutex_unlock(&arm_smmu_asid_lock);
 }
 
-static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-				   struct device *dev, struct arm_smmu_ste *ste)
+static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				    struct device *dev,
+				    struct arm_smmu_ste *ste,
+				    unsigned int s1dss)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {
@@ -2815,9 +2832,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.ssid = IOMMU_NO_PASID,
 	};
 
-	if (arm_smmu_ssids_in_use(&master->cd_table))
-		return -EBUSY;
-
 	/*
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
@@ -2825,14 +2839,29 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	mutex_lock(&arm_smmu_asid_lock);
 
 	/*
-	 * The SMMU does not support enabling ATS with bypass/abort. When the
-	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
-	 * and Translated transactions are denied as though ATS is disabled for
-	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
+	 * If the CD table is not in use we can use the provided STE, otherwise
+	 * we use a cdtable STE with the provided S1DSS.
 	 */
-	state.disable_ats = true;
-	arm_smmu_attach_prepare(master, domain, &state);
+	if (arm_smmu_ssids_in_use(&master->cd_table)) {
+		/*
+		 * If a CD table has to be present then we need to run with ATS
+		 * on even though the RID will fail ATS queries with UR. This is
+		 * because we have no idea what the PASID's need.
+		 */
+		arm_smmu_attach_prepare(master, domain, &state);
+		arm_smmu_make_cdtable_ste(ste, master, state.want_ats, s1dss);
+	} else {
+		/*
+		 * The SMMU does not support enabling ATS with bypass/abort.
+		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
+		 * Translation Requests and Translated transactions are denied
+		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
+		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
+		 * (IHI0070Ea 5.2 Stream Table Entry).
+		 */
+		state.disable_ats = true;
+		arm_smmu_attach_prepare(master, domain, &state);
+	}
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
@@ -2843,7 +2872,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2853,7 +2881,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	arm_smmu_make_bypass_ste(master->smmu, &ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2871,7 +2900,9 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste,
+				STRTAB_STE_1_S1DSS_TERMINATE);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 100e6721e16131..71ecced1db0226 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -761,8 +761,8 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master,
-			       bool ats_enabled);
+			       struct arm_smmu_master *master, bool ats_enabled,
+			       unsigned int s1dss);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
-- 
2.43.2

