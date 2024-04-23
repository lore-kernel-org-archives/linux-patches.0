Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9FC135A4B;
	Tue, 23 Apr 2024 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878074; cv=fail; b=ik9IGPf7q7Z6LIFwMW90fTeYhEQ7uuks3BfwGW+NjSPL3uKc2QkBnZKhLVg0GmB3HQVOslQqRI8mPlC7lZ4Cjf0DM2pWkpqFiRdUuPgqkZvlgQiorj7hkbIa+eEZ+67iALGVXzUbowv+kAEGlcKkrZU4bkYV5niz5OItWz87rCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878074; c=relaxed/simple;
	bh=xsWUWoPoXPNiLEiXqHiJNSpVV7f7LJYJIhLf9bR/Uac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lHu7T+sym/SbQa6enBcY2nPeYuDZ09ACGBC67NdVJ2xA3yV30C+Lj9s62Q9ExPo1ZUBtpUWisJ7saPrJDkcnh2MO0KIyOZsLa5FRhERMeC73RLlIb/224yyhDW8LpFAvmLqlSA49JI73xNDb9e2G3el8g6nztLhXyEsAee4Ou6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fnQv8+Pv; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fnQv8+Pv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDyA+lh/GSPEdy+DyeWdNgTKumPPYXAJazOR+cLZCl1DnDJS1Vxa0fLRTyFbNIaST8lcKa1t7STcGibQCEfBqLMCEGNUzR59/vsGIU9Eq3XZtYDW9mGQT15aZ70ERa1ePMcoE22zIc0Nzp8fx1xULEekhye/ZFaUrjW+Kp8uc8Uy2HAXbQyM1+YVUXygpoPiuLdT+svpcqaEJAck/zZrlcUQEQvy5iVpe5craDuF/N3sMxKA4ALzT+X8Timv4J1H+jctYZ6fmKTJsO1EJOtj76/6RETCdprbHvDm44otE5ggcsh/zcA7ZX06MmZUgW0POYa1d2E5Uk3vshqUBSO8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6ebWMsXICkuU38FuAdTDthYKSl5QETMUq6+wiunarQ=;
 b=Pxsc803PxseswaCvaY8JyIOldq4XqnxOKyW6Y0j0xCfg/F0TPVZ0rpCGLYzotOeHj/s6pgT52m0S7F+boT8xYSIFp8tk6iPNgpI+QdjsJVrU3kM/x1xwEmyMEY8WatClFdRC1pz3ePPDN/u2bvIfhmb5JZ6FqFD0QkO6VtDexW6F7BVnN9LYlZDfMGtyF3u6HHI8ClB5NfRJZ/6mcI/GDB4Glm8OTNnhuUARwZefS3snTb0xzndvocnZ2Qnm5U9bA7tRgmYo7Itr97VArXJFpl6neUHU9d0byJ0khYLnqlrrLDtmUMSgGZRrXJqCc7D+ecKsSGVpaaPK7W4gx51vOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6ebWMsXICkuU38FuAdTDthYKSl5QETMUq6+wiunarQ=;
 b=fnQv8+PvsOmBTL9dp7jRlEEMML6e9TPuB9GZQOfqv1SfNhCMDHFgK5R4tkXnKBPwvXcuGKKtkvuK0PMnvy4zi4rwXnKj8MvBSBcT6ecV80U6q0wJR7qV3+T5iBCV/z/sYSWJyXlODTCmJRot1+jd+HGjjWh/wLDEvITvgwijvsCLZvp3Ihj+zCCl+ZuJ25m0D9BBrurY11C9VI4P8N7tfA/q+5hfK0DpFJqcAJuYXGnFaQ/4l5MGvCCu4SN1twUbUBtjO2nGqJ3j6ONzpZWDNPQcN3MQeu0plLMK5MtZpTVxNiZ8GO2iV7JHmlv0nEa3UNz5uKxO2Yac/6zSdiHehg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:20 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 2/9] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
Date: Tue, 23 Apr 2024 10:14:07 -0300
Message-ID: <2-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0254.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ead5d18-da76-4eec-b07a-08dc6397467d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zk2rSGFUtjZgGRWbgqovVZmPrQe51YPHmrI3FAMvN06n91p0ZHjc24nTtfOW?=
 =?us-ascii?Q?Gd87LJ/f36i/CDzDGDagB6UrrT1GXF5fQHaxO86g5jF6VPpPuayeuK2ijzDI?=
 =?us-ascii?Q?obxPXZHsSGbpao2Mvlscv66F7ZPlWLAenBCJbJ/+XSLQal7XZM+Tlv1s/c4D?=
 =?us-ascii?Q?zvxsI7Ts06/Ol5Txy2iLhn+JjuLGFwQl5dHWZW+hHgzFx+HXr7TL3wl9HRJf?=
 =?us-ascii?Q?Y2xkOtYyidVGyW/x/lu3irf0QxRXSZTNL+l7LoFHPWwkkiBj7GAdZ5S6uERI?=
 =?us-ascii?Q?0f9fBcGPW7wH3BPDG+gvpY2l7wshPuSmBekmnNIP1b8k8cwYtlzId2FPbS0y?=
 =?us-ascii?Q?YtiJGSViXLngqGdzVxP7rHb5jxovW2CyPCbmaLJofXz714cyEDm+STOIPqZ2?=
 =?us-ascii?Q?trcE+i2RyR9uQGb7g+4XKMJo4Gb4ruIQXbxjjTPdCy2j6TvlQQm9vQBaHLKx?=
 =?us-ascii?Q?Xe0PqHRLpraAm13jlAF+ellwN83ONUH7yEkY8q85G1VQsheu3dh3TilIvbmY?=
 =?us-ascii?Q?dNoVKF+bxKerPwebDXv7dUmcQRaZ5xzyBA6qZABuThHfeLVbklKRIQ+r+KNe?=
 =?us-ascii?Q?TNX4N+1G1fiSfB3I4xuMcEvw6W5oeCPDSCRI5NVhqct3OU+UwMspTnwAKoYx?=
 =?us-ascii?Q?F0vXufsNeVSaVcue497t0JI0EDwVqtr1J6ornePRd9L9xHoTfu0PdO/a8N1N?=
 =?us-ascii?Q?yFWdKiNqriwDJOrN5HpI8KYnwFmnQIvA6y0axrC+RX/6Zfe3Jy6AwxUVznTg?=
 =?us-ascii?Q?fSMhNgi7jzMXegywWibGE1yDoDODWcygA2mnkyRlEvHkO9RRM79P/79UM88f?=
 =?us-ascii?Q?KCNQJaxhnOZYFCBwaQXBS34AY252hUGxJlIOpB/mB7YJ9PIkSrFT0gY/avxb?=
 =?us-ascii?Q?jo6j1xJ02L0YmcrJPScSIVQUebjYqXo44ZZqOigH5As8+O780Gu+mttenzbP?=
 =?us-ascii?Q?F5FIXKrw37r2SguTqYdtk12UNbNGVoXNoXQZ9xyJ1BfxkOhWsoe2pH0Fxab8?=
 =?us-ascii?Q?qajMVI/1bF12ysakE/GtcAl8B5dMwFUZ1yTQ9LuyuKU+KDUmNJhCQYuQrzwR?=
 =?us-ascii?Q?SS0jgrSg68kqiUd+W9Y6/F4p712pOEsiXVRZ9+ooLxS3k4uadHm0IWAr/KiI?=
 =?us-ascii?Q?4yon1VlpnKRJtG2BTQjqWSeVk3EJswqt4Btck27f9/Hy8siOLcjrOCZqjYu2?=
 =?us-ascii?Q?VxvGQlIMj98+HbPKbvzsLBD1+B8tc8xPw7f8PC1g6lqS9vOvel6/KUZMESXm?=
 =?us-ascii?Q?lM6eHVzi1Nz90m+SYmciaI8X1//NozjmZ+q4E3xbZg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m4EM1JCCygtrhO28EqmvGJsXndvWqtmUPhLZvPr0BaFNHOCwNwCBL7CvEky0?=
 =?us-ascii?Q?A/8WzNI//DOhohsU4LZ9V7T3FQZwcIJVeDXTXoHkHoy10eO10tNxKmOpC3pl?=
 =?us-ascii?Q?b4yu7eFg/cLXqa6AnE8KITkYdLN7tEbqEzogw3IiTlA6V6eETpmB5CbI24R3?=
 =?us-ascii?Q?baTvqk3Xf/+hG3VWUUbckgMHVdLOz4wc4Dy4xJAzsE0QV/xd6BaCz3FPDpK0?=
 =?us-ascii?Q?FNs2lur/NlaNzSBrVyzrxXpZZyQrKquEESGofD18dlWSM4VViI4YY6P0Joia?=
 =?us-ascii?Q?P8hkKEE6h4aWCjHLgXKomqg9PNDAk+WXrpYwCSgZNpV2K2bgL85eUeBmY+35?=
 =?us-ascii?Q?OQ6qlPCl6dx7mbjyP/+jtoFhKasKJVXEF+Ou0fDszLPZnqj3fEqRCgaAe1Fg?=
 =?us-ascii?Q?tSVcCEXjgvwuxZTFiAK4ecnoRYiLpfJg8vzCe/TY1d4vL+BDFLmJ8RXEy5WM?=
 =?us-ascii?Q?iW5Wu/JfnrrEGb94k4w7D4XzLuxl/OsA1f+v1uo/vsaHHoLYlz4CpDF6tUA6?=
 =?us-ascii?Q?KK4cUpdaOFOiFGYM+7+VHNxYzejGHmgIewg+P0BjrN+kz6hjx9XohM3NE6s/?=
 =?us-ascii?Q?QDZz7uLtAD8+r2J1042zNdAR7yDIZ2qsR3SN6m3wn8TvtkN1ZbP2tDTq0N1X?=
 =?us-ascii?Q?qDMSPxwxh3c8EGBqay/q9ZL0yUJZwxgiqI0BuhE5TmKckR4TSN6e3ZBY8OEh?=
 =?us-ascii?Q?WTimrj3ycE8lM7cFWZiCTR6F+uqpNF1C50Kj1eC74ncL8oDwIxOI7QPhxXmD?=
 =?us-ascii?Q?a6Ya5DlLXwPlZXrKEW+KwHVrSbHy1HZjdslUuzwSjDol2cal1SPKbAqPSN68?=
 =?us-ascii?Q?uZoOcg8dqMwj0mxBKB5xSpYTjCNLwFYALystuS2wK+P0jPdkjIFMtCFrfmBf?=
 =?us-ascii?Q?dk/kKxiAAxvWb3bjk02GOjKt00krLgtLQFRrFRHiFPbBN5Pmc2yqz+/wf9fM?=
 =?us-ascii?Q?o7eAp5Yv58GTTsaCxNWz7pdJU+x3TmxMeBfpC77HnlA5JmQlMLwDuUw5wMCR?=
 =?us-ascii?Q?hAtsQ72pKr6zkR+qrKveXvk6JVKIhEd5uC1kNHgpYZy2nUoPuNKVBzCtsbt7?=
 =?us-ascii?Q?6BH8VnZdR44AmgcNQ24KXf4WjezHmVWctx/lMJr9PFG9dtgx4wyqDubtAWOK?=
 =?us-ascii?Q?E/lqTTupHewfwgXW6xqegb850pT7AP1lnf7lOji+V4+kQQ5gHyWDR0DSXD4F?=
 =?us-ascii?Q?oafu9JZ9IAKcUDZJeuRbFMBDUvLMPkT93eJwOtV4N5A+i/WSHr+GK7SkcW+5?=
 =?us-ascii?Q?5MW9NIX5yzkuDNHqL3UWrDJld+K8UMwWHCcoleArObSc/MITbWLhHbPmkY2N?=
 =?us-ascii?Q?3pYxMZlP5M6wdClmuB+gk5611c34ygnZ5KB/b5uf1Npjse3+L8WYKt3Ub6oY?=
 =?us-ascii?Q?Wwc8ChXYnD421VjOIhyn2GVmUPHVJ4uV9rRPbcDDKdQTfYQoceoDNKEKgDzd?=
 =?us-ascii?Q?0bL7aFKH5g/x9Gc0F6kfxZUhep7gVO0IbLyEEorRqGm4iyFP7n4BwKG3vTXY?=
 =?us-ascii?Q?vhv5IqI0/IWZKZHxwTUNkjV0jzZs5yOMwxacXlLx2T9oXhLlxchOHMV67GkQ?=
 =?us-ascii?Q?YfxhQhv2rY80m4Axlw+Gi8o1uC9Fjcp5m5FxOzZn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ead5d18-da76-4eec-b07a-08dc6397467d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.4583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t29gfd7zcIyWsHx1ale3FA1BR6psRlJelWSRKNdwbFkM6i9ecVvS7jrM83CinuyG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

CD table entries and STE's have the same essential programming sequence,
just with different types. Use the new ops indirection to link CD
programming to the common writer.

In a few more patches all CD writers will call an appropriate make
function and then directly call arm_smmu_write_cd_entry().
arm_smmu_write_ctx_desc() will be removed.

Until then lightly tweak arm_smmu_write_ctx_desc() to also use the new
programmer by using the same logic as right now to build the target CD on
the stack, sanitizing it to meet the used rules, and then using the
writer.

This is necessary because the writer expects that the currently programmed
CD follows the used rules. Next patches add new make functions and new
direct calls to arm_smmu_write_cd_entry() which will require this.

Signed-off-by: Michael Shavit <mshavit@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 96 ++++++++++++++++-----
 1 file changed, 76 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 196aeaf280042c..1a61b47eeefe2d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -55,6 +55,7 @@ struct arm_smmu_entry_writer_ops {
 
 #define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
+static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1230,6 +1231,69 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[idx];
 }
 
+struct arm_smmu_cd_writer {
+	struct arm_smmu_entry_writer writer;
+	unsigned int ssid;
+};
+
+static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
+{
+	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
+	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
+		return;
+	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
+
+	/*
+	 * If EPD0 is set by the make function it means
+	 * T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED
+	 */
+	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
+		used_bits[0] &= ~cpu_to_le64(
+			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
+			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
+			CTXDESC_CD_0_TCR_SH0);
+		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
+	}
+}
+
+static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer *writer)
+{
+	struct arm_smmu_cd_writer *cd_writer =
+		container_of(writer, struct arm_smmu_cd_writer, writer);
+
+	arm_smmu_sync_cd(writer->master, cd_writer->ssid, true);
+}
+
+static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
+	.sync = arm_smmu_cd_writer_sync_entry,
+	.get_used = arm_smmu_get_cd_used,
+};
+
+static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+				    struct arm_smmu_cd *cdptr,
+				    const struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd_writer cd_writer = {
+		.writer = {
+			.ops = &arm_smmu_cd_writer_ops,
+			.master = master,
+		},
+		.ssid = ssid,
+	};
+
+	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
+}
+
+static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd used = {};
+	int i;
+
+	arm_smmu_get_cd_used(target->data, used.data);
+	for (i = 0; i != ARRAY_SIZE(target->data); i++)
+		target->data[i] &= used.data[i];
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1246,17 +1310,20 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	struct arm_smmu_cd *cdptr;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr = &target;
+	struct arm_smmu_cd *cd_table_entry;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cdptr = arm_smmu_get_cd_ptr(master, ssid);
-	if (!cdptr)
+	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	if (!cd_table_entry)
 		return -ENOMEM;
 
+	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
@@ -1278,13 +1345,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		cdptr->data[2] = 0;
 		cdptr->data[3] = cpu_to_le64(cd->mair);
 
-		/*
-		 * STE may be live, and the SMMU might read dwords of this CD in any
-		 * order. Ensure that it observes valid values before reading
-		 * V=1.
-		 */
-		arm_smmu_sync_cd(master, ssid, true);
-
 		val = cd->tcr |
 #ifdef __BIG_ENDIAN
 			CTXDESC_CD_0_ENDI |
@@ -1298,18 +1358,14 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (cd_table->stall_enabled)
 			val |= CTXDESC_CD_0_S;
 	}
-
+	cdptr->data[0] = cpu_to_le64(val);
 	/*
-	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
-	 * "Configuration structures and configuration invalidation completion"
-	 *
-	 *   The size of single-copy atomic reads made by the SMMU is
-	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
-	 *   field within an aligned 64-bit span of a structure can be altered
-	 *   without first making the structure invalid.
+	 * Since the above is updating the CD entry based on the current value
+	 * without zeroing unused bits it needs fixing before being passed to
+	 * the programming logic.
 	 */
-	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
-	arm_smmu_sync_cd(master, ssid, true);
+	arm_smmu_clean_cd_entry(&target);
+	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
 	return 0;
 }
 
-- 
2.43.2

