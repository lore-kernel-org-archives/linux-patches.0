Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686DC14E2F0;
	Wed, 27 Mar 2024 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562925; cv=fail; b=kNhq9tHYDmWom0POwF0Em75d97cpDIPWE8/2CNZ0/d3dRyoWu2vxyGoBwKsHAfjPsNNlsXTNy/HWE1isHIPRncD7lHTd8jLC+7/2hE6eqR6pp4B1+YPmkidYCmP9PXuHBGw0lR2d7Rqr93L4FI9QlrsQApvxL37nEB74INaXYCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562925; c=relaxed/simple;
	bh=5kPQcURuNZw5iMjrikv5x8XFXH2MfIF7MvIA/SW8xk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tOqruJNKtV4S0W6enRB5iN4glNtKnpI/35Ry0vT2qc25FqbWOkP39g+RI6ofxhm3Hjm+BokelWsuvRh+leJhKzw+fvM5orvlCzyGotWpamfgvwj5GS5vshIN7v3+/RDKIObGodr5ywDqVdb2R4Ivobo+T0Xx0SFcy0Lv81fijSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YPOya+o/; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YPOya+o/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWr0SW3I/7tVSK8mu2s8GbK/Yd3H3zsi9m2763R8/0IX+BtI/PGvHiP3g5rWWAhPnMdlC3FC4v7Ne+8NzWj/AFP5GQPDFPA0if5Flu6BIFy8siwpN05pl85e3T5IcXNlnlaY0elrMVoZMAYiROPiqVWpjXsGIXc8I0gGU7dEotS763isTdmjmjPoKpFaYJ1kvm49OApAaPM0CN08IFUTLuIpReihSVgJ/kL/PORfmRs82SodmeIUnSlZV1oS3WP0c4tQ2U83515dNcu6UdxOQ8LYK4y4Q0uRnaxMDMyBT5mkU5ON1/S7xXeyl1NlFwzuCKqNyuVfy3ypzPCKl6pjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7STOWmLSNyS2xjMxQ1maFHfALEUKGwqSgk/uQYibJkI=;
 b=il+TzTmbOV3xfAtzsx/DtKPIIbyNdPBtEo0imym8Kzdg1mi63VXRW4ukw69sjYPb8orIBmxXtXYvMMdGhJyWXU9mP9KE4qlAAGyxN3C32Yepk2o+NBNhbPXTmzS1ddgbsAOODoNbWaJ/AOOErvfDiJsF+29Pph40/FeOP3mLgT/Dnr2eUp6PpTw/xG4+miy/01JhOclqn8ooq7lcM6x8zEljHVnFqYprPtQQFUSXFLg+MsYuGfdrdfAXSXZAyjQ5WggI4OCljDQaHUNJ7iSzqvObI59eIx15TE7ZEGqw5f9FfEa6EU3rRJo8CMCQS+LSeOlFXEEI4Wfj+TiEJJxV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7STOWmLSNyS2xjMxQ1maFHfALEUKGwqSgk/uQYibJkI=;
 b=YPOya+o/cpWd+YMNY+9Vmh46jRASEsl3maBhGs4JIkaQ7yjOidHhnd46y/eF9kPBJGf+N09lVucvvhmcJ7bcDluxY06lACjXYPMn5E6iqTn21wWFH+GxB5/xriz3Ks00tmO+AECuw7bMIBjaKqZjhHzfvfXPlQ4edEY6sgzuJaxK8ECD+f5p36M4ErXpLwvUsztIylghZGLLF9Clx1G6V+TNhEfgXp2ZajuXB1UAFyUUWlcYilhtqL7rkrRDgVXZDYvfgkMwF3oRWnzosuS2L6tUGhI0W/GP55StVzwihshUfZCJ63ZWlFs5CgqQpYykDFrDpVfaF/q4Rlucpy/M1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 27/29] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Wed, 27 Mar 2024 15:08:13 -0300
Message-ID: <27-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0302.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f7d57e0-d3de-4e17-fa17-08dc4e88e19b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qFX8F/p5iEXqE6tml/BXo+kyN4aKWbmKtdi1WXRo3146UuF5jsxqMmH7t+YCTfVF6z6gvng9m1nSd1a+Y8TEpFaPJJ5CynD+UT1z+l3jxzfqO+cLw03pC7u8VNpL1VVu1yoIcx8zyVEiUW5G3Ip6ZFzYPTT9PFS+VW9ycfFOJxL5MzQ05ySTJPRBPJoGTvEJn6uKc4aXEMTgU5XldzKQCyNjUp4uFzTOGFYznkHzA19aysrTdfZAWikCOhJrhcWCztadEhb5EHS+tHjB0Hc10Lxv7xIvJQXbeeYJvO3AGLa30veu9GLBrkDls0co/ktR7jGu5DalHuSXPKVABZaEaxRrWdLF+leee1QoUtvLnUUjCqltJKluqyV+1PmrlmWh+DDeh3dEzaWGnGLpDB7rXvdamZ4D+0Eix9ZS1JBTUNkAleh9AlZXq86zVEmoTDGw2MrjsHMAVjsLzb3mDDfqjm7SwCYlCew+Ul8DM9emCKQti9dv4M443fKK0b8X+m9aAGM6ostZ4v4i8zxUFQFTN94uSxQng9sTjjNwH/iIXEmJMrgUjcs/tdZUwTdnzgpCvrdLzLWxG2WILcd3yBgDhrUDZhTqwf/Bb3FeW198NSmeOyvDOXZicYEefcH01jjL960uGWF0lSZ7M8MGj65yyw+sRwND4EuxiCx0TOp7N7o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1UudNqNLMGj2t2xPzJI/uBrPR1WeNINg/jwgfljS3dN9JFZLoBFVKD2tPt5s?=
 =?us-ascii?Q?mKgHylMcZD0oqC9rfJTT3VfLdRlxKHb6g9HpE96IJYSz3PYDkA5LmpfCcVm5?=
 =?us-ascii?Q?1FZkHva/ytlB3QtYGPU9JyTEb65kmcR5GIWl+c0TNel/SxklXnRtfzQoBLfF?=
 =?us-ascii?Q?q3cH7bq3Eh5zyqYg8HwEai4o36uHWR6xgJRtrH8Ko91mWvZZDdaogXshCv6Q?=
 =?us-ascii?Q?67VeugdoAHgTsKfIkjlvNCI2hPPoI7fOFFLpUnLWvP3EqIgIH2Ix4emkf29P?=
 =?us-ascii?Q?0yx8o/xeu7WvYiIwk3Kt34yZVuDJLDbfFR70AJ9s0Q3DOIyma5B7QTtQlBCO?=
 =?us-ascii?Q?IbyOggdclzVjkQ0tXi8iwkMXA5z3jn4FNdas6gygU7gSfDtMBJjCM0eKYgpq?=
 =?us-ascii?Q?2H2SvmMsNSnMR0mhk4eRe9Mgb7UtzAXwjthd1YKX113eLjQM+/DbCfWmcav7?=
 =?us-ascii?Q?iBguKdZNnL8l/UBtBJW6mmonh/wEPh5o8Jf0yADk5dwuJ72F+Wgvw+bGM3uW?=
 =?us-ascii?Q?ODbH4PqevFckMUn54uGsnarke6wG0wKMzZLKHu4PSv8odEFn96upiL6OiVKr?=
 =?us-ascii?Q?cXiZZOmg3l4l3ilThbeYsxi/A2QB7Orux3HxPCkYGxX0ALgCVx/zMRquC/gs?=
 =?us-ascii?Q?RLYuIQv/fvPMnEOWA0u8v4oun3vXaWO+UiVhhLLCPHLiY4n34sfiFnmmdMJ7?=
 =?us-ascii?Q?gUL14L9O8G0g+Vcee29/3DIRXXhNQWYaLIU4rbXpMdiEFQB+bQZPaUED2oLY?=
 =?us-ascii?Q?auNzRDyjjCw3YE2MMKanwIIn7m+J4GxClA6WAYiRw/YiElH9/qaK9juX/3UY?=
 =?us-ascii?Q?I/BcC+BwruPtQF7xtP5O/e30f2rIPBAQ4VkYuenZnL9jISOKNPS3xKG79vah?=
 =?us-ascii?Q?bo+EMXPslo+X1RvS7fhrYpKcFaYynmjd8f6g3BlZkjI0coEcIDniRZGnimod?=
 =?us-ascii?Q?M6X4sDQfH74W+1g+tHZ4m0mC6G/y6n+pAycWTBbTE+BwjKdrOlGTwP2IkoAF?=
 =?us-ascii?Q?jYMxsSB0DnH+wEjwvtYCulFGphd083Db6NEbCcqD8M/gEMzR2+P8p1fMne+Y?=
 =?us-ascii?Q?v55h7/bTxgIx/FjiUdREhM3T2kplfpKBHfTZvnJtsa0RKOjXkEQ9MqeOffRe?=
 =?us-ascii?Q?ZN6CpLJUrKdY0FaMMEZnFW15CY6isISeU6P4uORbOb5Z2UXEakw1vO9jK71f?=
 =?us-ascii?Q?zmmbLW33x/rtDKNSBtsy/kTZ7wc5TkXwJK+wiiXxUypcG7Vs3GouV3U5pUFP?=
 =?us-ascii?Q?7YFDo1gMz71YsBvpfc5oNHuZENNzUbEHc3f/hBUev0TZLmPn2W3HwJKjA5ov?=
 =?us-ascii?Q?L1mKPIVktTzXgIiI9FnjzuBJ6WDmwaOTR8bEjdZI+RWryRLU2wRQ6lmQkKpa?=
 =?us-ascii?Q?hNN6ohxmQFIEFZPAs+ZyMNiqxTS9+3d+CXeetjMQg9CL9qGQUTsV8Jc9Bd86?=
 =?us-ascii?Q?cHI6T/riE4n21YZPgdbLNCbZXqMVSov+ywaUEpy8Ta2g7N9Xs4M5dnpL0tVp?=
 =?us-ascii?Q?p3GC8wdyymlJKf4sCJWcDVSscgb+gTM4cAE4qR99CRyVhdxf/9Xt/l28helX?=
 =?us-ascii?Q?LNRQLWzO09iFjQDWjdnMkb2PVjjw6oiKZKZpJMQb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7d57e0-d3de-4e17-fa17-08dc4e88e19b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.8791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqtanR7C6CH99JegimZGlnXeSrmesVYkBE6UU7c4RvDhYQgyz2dwzQEiJ8ykF0Rv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 65 +++++++++++++++------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5a2c6d099008ed..69b628c4aaacdf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1003,6 +1003,14 @@ static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
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
@@ -1531,7 +1539,7 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 				      struct arm_smmu_master *master,
-				      bool ats_enabled)
+				      bool ats_enabled, unsigned int s1dss)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1545,7 +1553,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
 
 	target->data[1] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1DSS, s1dss) |
 		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -1556,6 +1564,10 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if (s1dss == STRTAB_STE_1_S1DSS_BYPASS)
+		target->data[1] |= cpu_to_le64(FIELD_PREP(
+			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
 		 * To support BTM the streamworld needs to match the
@@ -2732,7 +2744,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master, state.want_ats);
+		arm_smmu_make_cdtable_ste(&target, master, state.want_ats,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2809,8 +2822,10 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	mutex_unlock(&master->smmu->asid_lock);
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
@@ -2818,9 +2833,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.ssid = IOMMU_NO_PASID,
 	};
 
-	if (arm_smmu_ssids_in_use(&master->cd_table))
-		return -EBUSY;
-
 	/*
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
@@ -2828,14 +2840,29 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	mutex_lock(&master->smmu->asid_lock);
 
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
 	mutex_unlock(&master->smmu->asid_lock);
@@ -2846,7 +2873,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2855,7 +2881,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2873,7 +2900,9 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste,
+				STRTAB_STE_1_S1DSS_TERMINATE);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.2

