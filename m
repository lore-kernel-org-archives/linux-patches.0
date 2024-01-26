Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD23208DE;
	Fri, 26 Jan 2024 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292948; cv=fail; b=GaxP0TZYuGyShrbiRtw6qZ/R5MGGXSEQg4bmQvbtkcr6yNTrs5/63yTWC1+c8oB8lgYuk4zWDXJhkOjfjkQxmV9y5rQq+X5YsuQKU/bJrkS8cFZNFVaD2i8W8IZS6TijpRvParBJLFdKdF+3+PJWHH6/yJTz4QK5shpNT4iHHpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292948; c=relaxed/simple;
	bh=p7gNrNw2qaufSGhGrcNbeYVk3cxzrznSRcdKpSHzp9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ApEc7Wao+DdrAVmMjrGOLrCwdGN1TllIgK7BNGXwpH59T558ASdEDqIhJW7Hb/yJKpgnMmimZyJukSSxBFn63hto1OGphjCul7OQXMjntYcejFE9V20wj8M5bBtHmByj3uoo27l7qKs1ilEfdCacm+IIQZ/2RIwOigyw5sRpx7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TPvo2X/P; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TPvo2X/P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUXGKYp36Uwqf5+uZh1zGrUQJEqqM0s7pxuNgv9VPrURisG8JIgVjSi2s4skG1o861DAVf1et6ENhIs9NJC3jJujcIr3Rpl67CAMBFJaPeUzKiDN5hl08id3WF3mWMxZQBCeRH7Kt2J8IdjgFUAdxOCndmAnKT7V/7JvbKpEPUagk+1Fcxq402QYrolyO3bWQDKxRqkeUij3uYGhGGWhFXcYix2D6aeZphNQ+TvJIaoX4RdpsU9PR9VBW0vYyOBeVhhOGsHyxnPAGEij9dQohZa8s0Z8xCKfxQFsgBGfxnwjNCjP3I+iHcuep8JXTB7gvA209gHkVLy8cPfcu0PDRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F22HzHoGbsw/9Y0xhGEpVBMyJpgrUsKt2FCyuH14i3I=;
 b=QZk3FsWtP7jxU/MKrBAWG2bjF7twu1kETTIcz/nNVmz5DZkPJLBI5YQQqcnKiYjzaKB8Mf1cMEYU82LgnWt3MT35iFpPwRMJMDRtdyKBc0/yMHEzaJeRapxIJM7TudpwFJy4QKId121Y+EA7XOiJIoJ0k56d06B5bgVP2fSKV1lBGopXbrWY1j+6hkZnAi4xNEd52q5AleT5zqG5Ca9xPCg8fdmEVzbhj+CMDtgemUEo1P2M5kWsbXjbIoq3oQxA7Z4SsQDbcLhk6WKdGhM0kgWhjckA1YKb2hg6SttiCb3bOkx6Jgb9pX6Pl2ml0aIxq++r/HDVvq+RPchL7u+t2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F22HzHoGbsw/9Y0xhGEpVBMyJpgrUsKt2FCyuH14i3I=;
 b=TPvo2X/PBmB8KOeEMUOhGEDhtUUU4QUzEHpdgMW8p5+/SUB20c/pwzp9spyFytogYfnIS997G8c+9/nKd/vB7KCfqWwLI8JxhPmFkVSS/CWcirKxz91EN/HCvC/RB9P4XNgNCXEHW5SJScuv+qwAwrQQB+Dp0usLAZKRAXg/ItwlXjjMQ6LwLac0nuZQYyM13jywHl2yWw+tSP+fVnWbBeYEyzNNX2JhLzBSzjUJEZIv/WkHIYim1M6P92ZvrRA2S7ggtmh9H3WNWB+eZrfWROeBVuWH2otdIwWzKQeVo2hcwIY9r9El0wL7mu7oFNgJPoyR/KaYw7Ls01qFWG1CQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:34 +0000
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
Subject: [PATCH v4 10/27] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Fri, 26 Jan 2024 14:15:12 -0400
Message-ID: <10-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:806:6e::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 9131f5f7-c5c5-445f-34c0-08dc1e9ac848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Tf4lzaF902mYgufP6bBlkbJBSmnUPVKXqtaSVoOBIAofZCn0a+X+urQ9XPszZqfAC8QcOqhNfmj0J5jBC0+diy3IGw8K9SDM05f7MJkMMwESHdU2qTsivd/p21HSBansBYwkAtziBIB6cmXGsdCq9XbKr/iTCbJak3+ICG2Id7jp2hy0lvU58orryJoO1CRLB+MaDL2ALDUyUBohKEoa/PR+cg7Q5T8UERVn6XLUibrp+BT3epMDq+KAf3dujLf0GJ7y+k8Ba/TuPuok7jQBCV2E+Bgt4NTc7YRrMHjgyGclvhC8jQGC3Dj37PH35eaw6pjFps1pMiyZSFNEatR0atslN9AeSbFlWTOrwJguc5o1k1hUsssifgipE64QJc8vdJoO+xPngjtS2shPp7fzO1NhsFkZe/IQwJymhCYK+6F8mertVQInNpjE/bZBsIvT7069PJpmMYRLKKLW/zw4BPbtok2N683s662saAgqvITAnw393ZB4pl/1ASKmzRBiMNZBKiZ0sC6hmdK13TfexzQn5GYUgpLyoe+JKnRryX8NBPaqTEcYO7sxtro1G34UC0oBErR/WPYvXjrF7mL8Qp1mJK3R5pIfS5uUz3fqugtqE50zdnEOHP9M3/KViXoFGtgp19Bd7RK42vCZxzJ+ZQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(30864003)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(414714003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+jIvnHVRsJ1o/3x7esrBkE2FdFMMgUPH4PMYMT/XELqjLttLuXrCA90GKQGS?=
 =?us-ascii?Q?G5932EGIiy/zdyod0iHQRfe3b3zHFafyLXtxDwPmBpEtcSvy25e5RkBO+Iu3?=
 =?us-ascii?Q?hBjri+gDMhPlGbWxYgGyuwF+otgvrllJXdRlrGNya11HTZlVhP1VvCv8jfLs?=
 =?us-ascii?Q?0Bu+4j8eiqRWJQ4OHO13oYCljXU3Haqv0wSKmmkEPfE5hdbwh1AWGxmnLNF8?=
 =?us-ascii?Q?yrEodd6hIbm/fD1ChIX+V10heFGKTgwAgbF+RK5nHXugI1R24Wxwakv/YyEH?=
 =?us-ascii?Q?P/kLIf9pfOyQoDTCuZjNTLWaw7jSInkEwtgvzTb5kR9pjed/61fWX/h4HSUd?=
 =?us-ascii?Q?LNKptldhZTsXeN94EFfL5IfiLTRwjS6QDwAbYk5VFgyzivvk3/MjnaTP6ZM5?=
 =?us-ascii?Q?IaYbzeaAm9gGrT4P2ZdPdtE/avAsXs5Jbn40ghbvhJAht+gmff/XgAgPgfQv?=
 =?us-ascii?Q?RA+JQz8mNtqUSxwcIVORuTuobdJsBhKDdLgErUmVa+E7ZO/vAAJESY3aSJeO?=
 =?us-ascii?Q?ANYMjnv+fkT2j6fE0n4QxYz4sWgJ7QLjJsYv7SWRDeKJS8E1Wceo5mV4uWOI?=
 =?us-ascii?Q?Qjp15/7nCvRtbBOppp54X6vRRMJvTSvAZMu6P3Y1Bqawv1rdEQ+Alzo6Cbr/?=
 =?us-ascii?Q?+YA4nuQ5xExUcpwr//4eY2Y5Sv90ASsqZ5rzOTGMrXHh9h8ZKHSYJ+bvhYqN?=
 =?us-ascii?Q?tK9iYCnyGpCIY6po6Z+UJsGPR1eCGlq5r7r/KVppHpNTVfa/mfwEz75f+b+i?=
 =?us-ascii?Q?1/jgKVvyaNEzndVbRvWKuFWdRS4mIFVlNiOEu327BfyzVeQDJ2zrBGpoP4qg?=
 =?us-ascii?Q?hxZY4Sj+J9WL5R53cVM3uK4QGOYZQl0HIy7dnuySro0JWo1bmYzFr2d0ozXJ?=
 =?us-ascii?Q?GICyviZSmCA0MESg/VNpysn6X6F0/SzaIksODZGUy9DjSyjIodwZwyQFFAJH?=
 =?us-ascii?Q?1rrtHZSirFE4NAUEgmzmShgdZx8953+d2fq8JQo2sAaBTKVmqsWNbvrBxG2c?=
 =?us-ascii?Q?tAA89E3M3CrhBWIfknWCTX1DC8Qi4NrtXOfG68CJeul8xG2t5nT/RF6Ku6mQ?=
 =?us-ascii?Q?/Nz/KD8a2Es9aM3kVw2ubhLorkQP9iN99gyru4kCGhtXlZoWaKoLgJCPiNCB?=
 =?us-ascii?Q?y1gt4UPGZWlkep4d3YYfPd/jjnPhLrEIbpKaRGdSZDgYVBowyQQX66N1vyjg?=
 =?us-ascii?Q?iIgZmnbFILxaFN3qGifE9DlM+67EJ0oYbQBMaCmZV6I6XkdhSPNPzUb6nTmv?=
 =?us-ascii?Q?FZ/r5pXmam4CHdvGJCGUD0rY4sMwR/wWHx8UWlES3LV/Mdm6DvpmQQBuRUSS?=
 =?us-ascii?Q?wCfLakUTIZ+yz0GAZ6Ey1eaeiK0Y9Q3YzrpPfTYlMZY5z+L3JtIIjFyhHSFn?=
 =?us-ascii?Q?msh68/beqjUth8VZSnFPhaZ5KzjUaOYEp7+TyAY6+MVo1vWBv5S2EqgrljRE?=
 =?us-ascii?Q?MdcL+Wz0CeK2rCwoFD0crFVy4hnvLKjKJImHyHD/S9TFnU4vmWFk9xSGzhAS?=
 =?us-ascii?Q?GXynow8n+tXcM2XixPZZsnhhkDIvrNif1/zIHoEbL176XXu/nXyWi8BytAG3?=
 =?us-ascii?Q?qJ+W6HH7vP9//+DMNoHr4DLNxKjfXvX8pwHi7EsB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9131f5f7-c5c5-445f-34c0-08dc1e9ac848
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIoMHGJgICo9qEelzfaHD6eIZnIt5jjp51oHMQAy9GwwtbP81yFkg03Lk45+CmII
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

Pull all the calculations for building the CD table entry for a mmu_struct
into arm_smmu_make_sva_cd().

Call it in the two places installing the SVA CD table entry.

Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
the function.

Remove arm_smmu_write_ctx_desc() since all callers are gone.

Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
the same value.

The behavior of quiet_cd changes slightly, the old implementation edited
the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
entry. This version generates a full CD entry with a 0 TTB0 and relies on
arm_smmu_write_cd_entry() to install it hitlessly.

Remove no_used_check since this was the flow that could result in an used
bit inconsistent CD.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 159 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  95 +----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 -
 3 files changed, 107 insertions(+), 152 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 00d5f1aecc9585..7039620c4b2e55 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -35,25 +35,6 @@ struct arm_smmu_bond {
 
 static DEFINE_MUTEX(sva_lock);
 
-/*
- * Write the CD to the CD tables for all masters that this domain is attached
- * to. Note that this is only used to update existing CD entries in the target
- * CD table, for which it's assumed that arm_smmu_write_ctx_desc can't fail.
- */
-static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain,
-					   int ssid,
-					   struct arm_smmu_ctx_desc *cd)
-{
-	struct arm_smmu_master *master;
-	unsigned long flags;
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		arm_smmu_write_ctx_desc(master, ssid, cd);
-	}
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-}
-
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
@@ -129,11 +110,86 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	return NULL;
 }
 
+static u64 page_size_to_cd(void)
+{
+	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
+		      PAGE_SIZE == SZ_64K);
+	if (PAGE_SIZE == SZ_64K)
+		return ARM_LPAE_TCR_TG0_64K;
+	if (PAGE_SIZE == SZ_16K)
+		return ARM_LPAE_TCR_TG0_16K;
+	return ARM_LPAE_TCR_TG0_4K;
+}
+
+static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+				 struct arm_smmu_master *master,
+				 struct mm_struct *mm, u16 asid)
+{
+	u64 par;
+
+	memset(target, 0, sizeof(*target));
+
+	par = cpuid_feature_extract_unsigned_field(
+		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
+		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	target->data[0] = cpu_to_le64(
+		CTXDESC_CD_0_TCR_EPD1 |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
+
+	/*
+	 * If no MM is passed then this creates a SVA entry that faults
+	 * everything. arm_smmu_write_cd_entry() can hitlessly go between these
+	 * two entries types since TTB0 is ignored by HW when EPD0 is set.
+	 */
+	if (mm) {
+		target->data[0] |= cpu_to_le64(
+			FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ,
+				   64ULL - vabits_actual) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+
+		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
+					      CTXDESC_CD_1_TTB0_MASK);
+	} else {
+		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
+
+		/*
+		 * Disable stall and immediately generate an abort if stall
+		 * disable is permitted. This speeds up cleanup for an unclean
+		 * exit if the device is still doing a lot of DMA.
+		 */
+		if (master->stall_enabled &&
+		    !(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
+			target->data[0] &=
+				cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
+	}
+
+	/*
+	 * MAIR value is pretty much constant and global, so we can just get it
+	 * from the current CPU register
+	 */
+	target->data[3] = cpu_to_le64(read_sysreg(mair_el1));
+}
+
 static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 {
 	u16 asid;
 	int err = 0;
-	u64 tcr, par, reg;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_ctx_desc *ret = NULL;
 
@@ -167,39 +223,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 	if (err)
 		goto out_free_asid;
 
-	tcr = FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, 64ULL - vabits_actual) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS) |
-	      CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-
-	switch (PAGE_SIZE) {
-	case SZ_4K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_4K);
-		break;
-	case SZ_16K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_16K);
-		break;
-	case SZ_64K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_64K);
-		break;
-	default:
-		WARN_ON(1);
-		err = -EINVAL;
-		goto out_free_asid;
-	}
-
-	reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	par = cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par);
-
-	cd->ttbr = virt_to_phys(mm->pgd);
-	cd->tcr = tcr;
-	/*
-	 * MAIR value is pretty much constant and global, so we can just get it
-	 * from the current CPU register
-	 */
-	cd->mair = read_sysreg(mair_el1);
 	cd->asid = asid;
 	cd->mm = mm;
 
@@ -277,6 +300,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	mutex_lock(&sva_lock);
 	if (smmu_mn->cleared) {
@@ -288,8 +313,19 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 &quiet_cd);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		if (WARN_ON(!cdptr))
+			continue;
+		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
+		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+					&target);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
 	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
@@ -350,15 +386,22 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		ret = arm_smmu_write_ctx_desc(master, mm_get_enqcmd_pasid(mm),
-					      cd);
-		if (ret) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		if (!cdptr) {
+			ret = -ENOMEM;
 			list_for_each_entry_from_reverse(
 				master, &smmu_domain->devices, domain_head)
 				arm_smmu_clear_cd(master,
 						  mm_get_enqcmd_pasid(mm));
 			break;
 		}
+
+		arm_smmu_make_sva_cd(&target, master, mm, cd->asid);
+		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+					&target);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 79d80de4c0a60f..8bd072ab0f258f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -57,7 +57,6 @@ struct arm_smmu_entry_writer {
 struct arm_smmu_entry_writer_ops {
 	unsigned int num_entry_qwords;
 	__le64 v_bit;
-	bool no_used_check;
 	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64 *entry,
 			 __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);
@@ -93,12 +92,6 @@ struct arm_smmu_option_prop {
 DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
 DEFINE_MUTEX(arm_smmu_asid_lock);
 
-/*
- * Special value used by SVA when a process dies, to quiesce a CD without
- * disabling it.
- */
-struct arm_smmu_ctx_desc quiet_cd = { 0 };
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -1019,8 +1012,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * allowed to set a bit to 1 if the used function doesn't say it
 		 * is used.
 		 */
-		if (!writer->ops->no_used_check)
-			WARN_ON_ONCE(target[i] & ~target_used[i]);
+		WARN_ON_ONCE(target[i] & ~target_used[i]);
 
 		/* Bits can change because they are not currently being used */
 		unused_update[i] = (entry[i] & cur_used[i]) |
@@ -1029,8 +1021,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * Each bit indicates that a used bit in a qword needs to be
 		 * changed after unused_update is applied.
 		 */
-		if ((unused_update[i] & target_used[i]) !=
-		    (target[i] & target_used[i]))
+		if ((unused_update[i] & target_used[i]) != target[i])
 			used_qword_diff |= 1 << i;
 	}
 	return used_qword_diff;
@@ -1126,11 +1117,8 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
 		 * in the entry. The target was already sanity checked by
 		 * compute_qword_diff().
 		 */
-		if (writer->ops->no_used_check)
-			entry_set(writer, entry, target, 0, num_entry_qwords);
-		else
-			WARN_ON_ONCE(entry_set(writer, entry, target, 0,
-					       num_entry_qwords));
+		WARN_ON_ONCE(
+			entry_set(writer, entry, target, 0, num_entry_qwords));
 	}
 }
 
@@ -1178,7 +1166,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
 		  CTXDESC_L1_DESC_V;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
@@ -1250,7 +1238,6 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.sync = arm_smmu_cd_writer_sync_entry,
 	.get_used = arm_smmu_get_cd_used,
 	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
-	.no_used_check = true,
 	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
 };
 
@@ -1308,75 +1295,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
 	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
 }
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
-			    struct arm_smmu_ctx_desc *cd)
-{
-	/*
-	 * This function handles the following cases:
-	 *
-	 * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
-	 * (2) Install a secondary CD, for SID+SSID traffic.
-	 * (3) Update ASID of a CD. Atomically write the first 64 bits of the
-	 *     CD, then invalidate the old entry and mappings.
-	 * (4) Quiesce the context without clearing the valid bit. Disable
-	 *     translation, and ignore any translation fault.
-	 * (5) Remove a secondary CD.
-	 */
-	u64 val;
-	bool cd_live;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr = &target;
-	struct arm_smmu_cd *cd_table_entry;
-	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
-	struct arm_smmu_device *smmu = master->smmu;
-
-	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
-		return -E2BIG;
-
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
-	if (!cd_table_entry)
-		return -ENOMEM;
-
-	target = *cd_table_entry;
-	val = le64_to_cpu(cdptr->data[0]);
-	cd_live = !!(val & CTXDESC_CD_0_V);
-
-	if (!cd) { /* (5) */
-		val = 0;
-	} else if (cd == &quiet_cd) { /* (4) */
-		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
-			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
-		val |= CTXDESC_CD_0_TCR_EPD0;
-	} else if (cd_live) { /* (3) */
-		val &= ~CTXDESC_CD_0_ASID;
-		val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
-		/*
-		 * Until CD+TLB invalidation, both ASIDs may be used for tagging
-		 * this substream's traffic
-		 */
-	} else { /* (1) and (2) */
-		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-		cdptr->data[2] = 0;
-		cdptr->data[3] = cpu_to_le64(cd->mair);
-
-		val = cd->tcr |
-#ifdef __BIG_ENDIAN
-			CTXDESC_CD_0_ENDI |
-#endif
-			CTXDESC_CD_0_R | CTXDESC_CD_0_A |
-			(cd->mm ? 0 : CTXDESC_CD_0_ASET) |
-			CTXDESC_CD_0_AA64 |
-			FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid) |
-			CTXDESC_CD_0_V;
-
-		if (cd_table->stall_enabled)
-			val |= CTXDESC_CD_0_S;
-	}
-	cdptr->data[0] = cpu_to_le64(val);
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1385,7 +1303,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1483,7 +1400,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
 	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ec7c906098ec1f..1f52f861281eb6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -608,8 +608,6 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
-	/* Whether CD entries in this table have the stall bit set. */
-	u8				stall_enabled:1;
 };
 
 struct arm_smmu_s2_cfg {
@@ -747,7 +745,6 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
-extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
@@ -759,8 +756,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
-			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.0

