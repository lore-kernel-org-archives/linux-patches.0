Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C420327;
	Fri, 26 Jan 2024 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292937; cv=fail; b=mIrecRSSMqevPRLPEexazt8mWrnpGpMS8tYQr3WV0rwtPmaXU7mN/9NKZcyU/xe9wgNY8rSRmc4rXzUX/Ll22sXajaZ4sYfCjRDz+i8hxRVryohJJsvXSZ0zjKJRVQcGcFIsUisaoikx4k+sW6SgXAWUpILA4HSDQoKQclIDNHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292937; c=relaxed/simple;
	bh=9azznfjJk4mTkbZBoXuQTI1o5j0GKJKStgPh02Lldc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kPk1huA5bNnAqu6PU9ur7O1dZ8J3uWL6EmgT6cyIvuHpxLh1H+YInfd54TSTi1JuUTWvP/ibHA+/+fXnz5oqXjNBxV0fvQ2CT2gwKcTBq9KeJZfsQ5vSei0kUMqZYS6BiZvMAwUjVpAfIUrPSuX3doa23269LqHgr0nXSi98/Y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nOq8TtD1; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nOq8TtD1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbB+nwmiRJk6cOyolxh/4Mkjo7Cmaxozz35ke6nh/n9R670nx4HthrA2YTOk6K8RRWAvhzMNc27c2gvj3lkuK1OuJNkMjWWJQl4jSb/t3y632TaQfInXhiueyKhvIC09GwEzlqpEGoDd9izvDn5dJIxcIFHqHX07qTLMu75w3W2m+wjbRXeujv0FkqN2avxKxeVH3VnfJUE/8l9HyL/G1JkIihjIk3i+TsUxe8FRDDz4iC86/O4CwGiNMkV65QAF6yYP5p/wKAm5ir7gx/iZsRF3639Zzpfb54QOhuyWvgu73Ob7QMSx5rG8U7QSQQ3n7Z3odOWQBGMkHS4FpawhRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ybsX7wNoMXvzNRhE2TPKWkiCMQRM+vcy2IroGqTkis=;
 b=XXTTvQt2fWO7o+qwMktpLn1aHypJO+6Q7hfiExZoHwahZJSNfBsTxM5hJZgncEQ6Atg1F+l8ce/7nVJv7KzDDm2CdW5g3EHbPSHhULZfP9h67vWAOPFGJlfLTht0JmmTRz/2lHqpmpmTLz4h+gh/9etbWJDrt4hC4kq4zfskoazPBNjC+qDqH5/vTG7VMykgJpbHEJWA+52lPf+2S6rUUCctJVh7eLrOgyFwjokcCeisZAFhxZgHHfC4kRPiFPXLTqbF0cPjCbt9seDR5fsYErrjg6NKVc3wCgf+LzDpSlXjJVdG16HfCwTIIRKMfm+O/sEQfoOPCfejC3T9D7oZ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ybsX7wNoMXvzNRhE2TPKWkiCMQRM+vcy2IroGqTkis=;
 b=nOq8TtD150obOeg34RbZqBTSRlJaQU+mXKEMAQEfGNIqbwjXzggeVkKrVWCvELdKwMYCCnNthb9e/oYUU4mLRaKOsX1znk3Vwi7405QAP7UnLurj7WgPUppsye35kNytSvybgp8csr12t5BpHSCGTs7fCwuxdiJ83HYXDTxGsJeWpPIK3rbl4zW5QbQR+TERrvQe9lNilNZRbJi6FhLeOWvR5z0G+f9qVgUA6H9Sy9fns38Btsjm1Zm2yszAdLUVYEkIY0FVHrhCRxxx6MlrauwOYc16VuLHQkMTtM70Khvax29CDdfucXIXIaYDIyJhf2KlPvN8R1Q+kFA0u/Xsbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:31 +0000
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
Subject: [PATCH v4 05/27] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
Date: Fri, 26 Jan 2024 14:15:07 -0400
Message-ID: <5-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0127.namprd05.prod.outlook.com
 (2603:10b6:803:42::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d7b5b4-f142-441f-e2d8-08dc1e9ac811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uQ0yGpslr9/siVdFKite5/FNTFgjOmJQsJw9Q4gdRNm3ZMw4ybJgDGymsD/RAfeGMsRPsPPM4y4TVNMaVYgR/h5iYzx552+d0zD6vHEAW5nIdRhI1qVPoYX4E2HlKGqMBFpluWJjbGDwi6Y40juPYgS7NDNTbF0t/yuIyofqWViaSFSN1yaR2S+DKbeKjDpW6QBJf3iN4auGEmtJN7EjX7AKG/FOgtkiO/1dAoVHIsoPh7geR92KETcvgmRzwydF32oqJRlcBUTZ2Fxt0Ww7j7G2eC1GVBDnUgr2SIgS1UoeS7Wr/KelJZLdCtuxOi+4xCW5ZXS/hWBQMzbo1nF1vx9pt9SuPEMhoO4mIA3wc96GkxPLGXwsJ5w8dFeoxXvnfNvM03LqhtLgl18gQSL0hTaWNWjXPzSJi8ZPmIPZZLbaWfSQ+hHOYDQZeD2Flfk7sPFcTEHy18ZQlr8MCWPcM7qqF50xAPM+twJY0AyEFFFofXSPa1TpbCqjiNjInLAX0MpNfEGqQ50gfPe9ob5uXB4q+C82/RCM5/DhvUTpjUnbqI4776+Q3cjWboKHbNR1CZtoSbvk1LS/xlpKJhG9wvn7C6Us0BioSNTPcblm5Kw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kvo3CylqvSSP71KeILCtBBEEwGHQWP/xChS/SAi5TquQ4RaQuIPlCdtR5XcL?=
 =?us-ascii?Q?oPUUzp1tVBRnQzqVuTSiC+mWOYKoIlV47UJvXInoRYbfih9Cxje/nnQALR2P?=
 =?us-ascii?Q?nwvgZY2jQqzmjxJiA4MEmwtVwPdxbYchkOJPskFTKyDvFeLe1LqgXEHF1iFw?=
 =?us-ascii?Q?LApGeReFuoXISfr7Z6pbI+9viQEdeTi2XVKdHuW/MyYesUpS/u3OC+rIHkLR?=
 =?us-ascii?Q?0zwggXCg+ODL76QiK5jcZNx7q19dKyDrPn8B3cxI55XkXRnjCRnrhKkKtm1N?=
 =?us-ascii?Q?wVC2P5J9PU9PAasI7TmA9yIv6LqGk9qf3H2tYDD4u43G1X1+uPjUi7TFuFuK?=
 =?us-ascii?Q?tR8cRhHc0Suv8C4JKMSPP+PKTTYFydUEa1kPmuka23ST400DCFi+ComhN1eB?=
 =?us-ascii?Q?MOps/cD/SkiJFofejCwqcHzIopBkhpwnyzpJh68lJSyoXZBzXDQlnXSJwR9m?=
 =?us-ascii?Q?YOQU8XvZR3bJlyZkkezuy5nS+m3K1x8UuYW5/qZKiUCtMiDO7rWw+okuLojk?=
 =?us-ascii?Q?PkqTq6aybD0xWFdQeChIotYGGUrpRP1ohiQWdJ4GLuJ53SNNMuuJzTYbyty+?=
 =?us-ascii?Q?3w5stWR5zmnWXe1BTaI6ZhC8ov1Pr7BQX53c+cZNCWyTDoKrMXI0dyw7Js9a?=
 =?us-ascii?Q?QEXu8zb8K5zoATlC260jrIuRATWhXrF5uAuhZ/eHviFFYNq7JByTNf3T0KIE?=
 =?us-ascii?Q?D7RUJp8rWjMbsv5yaYpEP5ejOMVWcKZi9Ad4El3wHAuBUkjvlsGKm7O42cUd?=
 =?us-ascii?Q?1rO+SeKLMHaXBin9YP2RDpIGn+6HfJh7IPNtSPxEBHhWMsOS/A+bSWkQaljj?=
 =?us-ascii?Q?9eCL07roZkwOIJdgigXulbPaAlSueE0R3ey0lkV3s6DbxTgmVo9OUrXXnxec?=
 =?us-ascii?Q?dJc+i4xoSBzL8EUfamuNT9QBOOVzymEju0vr21qc9zKcTDFDwZFHAN0ByR2w?=
 =?us-ascii?Q?XCqIrAsx6mOuXJ/4/A4udoHvJvUxIrfQSUvtETwY4bLjaQ5W2wFDBEkMh0Ao?=
 =?us-ascii?Q?JPs9q2pJXba2/zTr0JlLGIdOGZaOmwdMdBulH5v72q97qfOVyiO4I+PVPyyC?=
 =?us-ascii?Q?PGkdmRI+Li2gk/FK6PWbrTyWLvnb5Yd2RL+/T9Wtn1RiOW6Z9Tp5pfx6HEIh?=
 =?us-ascii?Q?GBNjO8d2FUuYUSztUuNjkdiU2soqlsuQ2PlE6ABd+mphyLE2KpX1Pzcsif4/?=
 =?us-ascii?Q?4LEl4OVE5ogHmoApBJYpEBPWdMm8+DksEQnaDhiqTW42vCTGewGZQxNh/AB/?=
 =?us-ascii?Q?37A6wFk/f9hrterWH0fno/EVQGn0IxwnonxK70a2VDPogSk+n6GoXGcukFed?=
 =?us-ascii?Q?Dbj60KzUyQVOTvWaG9oILpfYWuBpc4mcJ/j8eEGd0UaLEw8MMIQQL0wSYlWp?=
 =?us-ascii?Q?AYwst/an0UUZZlABXL35PmjVdOPLyuGYbwqocYTD08iUAwbjWl+FAhpPjvot?=
 =?us-ascii?Q?CxTgJjho/2ClpxLENo2lszrJsf/t0k2NJqoJ7deKVBIWl8CG1hc7cCAaeShT?=
 =?us-ascii?Q?Ht5lBKR9FwVXfWcPui76FLxHxvE+B3/x8t056vuY5YyfQGQZEwHDqXq+W8fF?=
 =?us-ascii?Q?/dNc9eN914BoRPX2j7bFW0vITApweX93Z0FEovjc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d7b5b4-f142-441f-e2d8-08dc1e9ac811
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.1209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZUTCuzlKmtvMDzvDRo8cZRALFnwvdc6WMdHvrCb3EADz1fjiXdvJxvSFUs32SrZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

CD table entries and STE's have the same essential programming sequence,
just with different types and sizes.

Have arm_smmu_write_ctx_desc() generate a target CD and call
arm_smmu_write_entry() to do the programming. Due to the way the
target CD is generated by modifying the existing CD this alone is not
enough for the CD callers to be freed of the ordering requirements.

The following patches will make the rest of the CD flow mirror the STE
flow with precise CD contents generated in all cases.

Currently the logic can't ensure that the CD always conforms to the used
requirements until all the CD generation is moved to the new method. Add a
temporary no_used_check to disable the assertions.

Signed-off-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 102 ++++++++++++++------
 1 file changed, 75 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7798a53e14124f..faa60827d72726 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -57,12 +57,15 @@ struct arm_smmu_entry_writer {
 struct arm_smmu_entry_writer_ops {
 	unsigned int num_entry_qwords;
 	__le64 v_bit;
+	bool no_used_check;
 	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64 *entry,
 			 __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
 
-#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
+#define NUM_ENTRY_QWORDS                                                \
+	(max(sizeof(struct arm_smmu_ste), sizeof(struct arm_smmu_cd)) / \
+	 sizeof(u64))
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1015,7 +1018,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * allowed to set a bit to 1 if the used function doesn't say it
 		 * is used.
 		 */
-		WARN_ON_ONCE(target[i] & ~target_used[i]);
+		if (!writer->ops->no_used_check)
+			WARN_ON_ONCE(target[i] & ~target_used[i]);
 
 		/* Bits can change because they are not currently being used */
 		unused_update[i] = (entry[i] & cur_used[i]) |
@@ -1024,7 +1028,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * Each bit indicates that a used bit in a qword needs to be
 		 * changed after unused_update is applied.
 		 */
-		if ((unused_update[i] & target_used[i]) != target[i])
+		if ((unused_update[i] & target_used[i]) !=
+		    (target[i] & target_used[i]))
 			used_qword_diff |= 1 << i;
 	}
 	return used_qword_diff;
@@ -1120,8 +1125,11 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
 		 * in the entry. The target was already sanity checked by
 		 * compute_qword_diff().
 		 */
-		WARN_ON_ONCE(
-			entry_set(writer, entry, target, 0, num_entry_qwords));
+		if (writer->ops->no_used_check)
+			entry_set(writer, entry, target, 0, num_entry_qwords);
+		else
+			WARN_ON_ONCE(entry_set(writer, entry, target, 0,
+					       num_entry_qwords));
 	}
 }
 
@@ -1201,6 +1209,60 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[idx];
 }
 
+struct arm_smmu_cd_writer {
+	struct arm_smmu_entry_writer writer;
+	unsigned int ssid;
+};
+
+static void arm_smmu_get_cd_used(struct arm_smmu_entry_writer *writer,
+				 const __le64 *ent, __le64 *used_bits)
+{
+	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
+	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
+		return;
+	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
+
+	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
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
+	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
+	.no_used_check = true,
+	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
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
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1217,17 +1279,20 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
 
@@ -1249,13 +1314,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
@@ -1269,18 +1327,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (cd_table->stall_enabled)
 			val |= CTXDESC_CD_0_S;
 	}
-
-	/*
-	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
-	 * "Configuration structures and configuration invalidation completion"
-	 *
-	 *   The size of single-copy atomic reads made by the SMMU is
-	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
-	 *   field within an aligned 64-bit span of a structure can be altered
-	 *   without first making the structure invalid.
-	 */
-	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
-	arm_smmu_sync_cd(master, ssid, true);
+	cdptr->data[0] = cpu_to_le64(val);
+	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
 	return 0;
 }
 
-- 
2.43.0

