Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BFB6D1C0;
	Tue,  5 Dec 2023 19:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gI/s9GYH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTCVpBV6D8D4QalGbZ3pv4kLGubGyFbAaQd6bDL+ABPeNYT2j2UGJt2SZdvhxUr9zZ3wD4tgzi2Z2GgJEc+mdoLO39KXtBno4k1pkol24Q6dmaOMZRGQATB+h0UXOZRg6N+JJcWnNQa739xKetjJLiYNRfr85zlw7vwXYjPk60NJTmqzzx0ZMVS28hjpGFBcT8H1U7w+BV6ZQPbRBKuqHacXl8edqjztyyBcbJhkXze8c04YBa+lmh4hn/Yz5P9AIEIHV3qVlVclWfmOf1A9no/6bvoOg6MGv25Zo6QGPZqnjuUYuCBtnyd5sxPdVsfv64SatkuDWzYpFnjBnPXP4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyQmqoVzFh3+XBvHtHKt794KC1uiq/uxnFNhUjS5O0w=;
 b=lMrwbpiVH/Hd4iByVH6y4mYQE7w3YkUFG2IVzuVX9iHqDQFD+Oh4+3Kgak4IZY2s+KpR6mbiikID0EYqRnvvoSekfSGZWfDyEKpBXITIFLKWK5v8U/tXNNBg+oPSibyW+5mWLUFz2A7FZcWAmJ4NRH43FRnDdunmn6MV3Bvc9TpnKm+IowfNWQ+I9HWLc3YWppcLniCqx/oF5z9wnVhAJpj6OYBPOU6UrIkwHRylTPRoVtVbBaWZ1ffLGdWm8DHTqvz+5C9zzkJ22tAea/c9VdZyLEOPLaFeHLzbvtueI71GRx0UjWwZpYvLu1DvWb2V3upJZReDnMCUFn6KxnyInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyQmqoVzFh3+XBvHtHKt794KC1uiq/uxnFNhUjS5O0w=;
 b=gI/s9GYHPsDkG8Q+NYQx7akfVgO5GLDIWkGpzBNCRWRCDfvVz6bWa3BHR/RRhqRDo61rwnWlZlgHdNmmoW4HmLbTrU0DYsGD0MLXsXsm/ZUVMcI2PgTULE/c6tKYHZ/E32VZYMjny7dpOMCKbd4X+wTBCeprebFrUXKM5N62U43VW2ced/NeshQyH59qPLiuF1QAgLbOQud+ho9vdwL9e9oi4fg4zHXeZIlUm7cedRjMk3aIAf8x6WcU1Ai/aMCR0p95M5cJ9XJbNVOjZM6ePv5Da1hJk/EtF8ZsTcBKCN7NY9gXtm68GsUFhN/mxxtWubBXFRogQM8ruAD7ZZkmvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:57 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 04/19] iommu/arm-smmu-v3: Make STE programming independent of the callers
Date: Tue,  5 Dec 2023 15:14:36 -0400
Message-ID: <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0149.namprd03.prod.outlook.com
 (2603:10b6:208:32e::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: c4ba44e0-41d2-4966-b04f-08dbf5c67561
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qo5Adn1ws+mWpQhqCamqZkToKtBHfT3JVI3Wk7KpmjbfDdzAKmSTRovTCbMePWKN8ues9Gr15sYrchzjLWQLCJSGsWDGZgPrBXjJEuiWI/E7UXzYuUwNXc7AjnM0OQue/uj6aSUXtF06aCHzQ8WYgjHThg3czU9hYnaOy/A+zFeTPi/o0V7ScM3soUkXNKr0kkUNNbDw4U3cxn/09bDLqIKvuWjzP/SsL1Fp5zOY0H8IBM6hk6cTmZK/xXdGfs5LIHGF2ISOY+brpPUdBqOi7I7B4OFSvK1IA9KgRvLNc5JssW+LM7iLyGAQIVdnUTb8bMeSUHwemMnwgl2Opt/glffxjKLMwWFADfXO3wCy4IlwGXQuKaAoPVI8JQIzh9xfy7yZ5o9h+b/eM5KIthp0+YCRGBWxyUHZsqYMy37Md3BGI8bPyLrJ3WGi9lKZLixoXrmE0qcuNxNZP2uDQVK7jIAM1hs5arUzpRMNlWxAIcz+vpti5alDec6MMBSWFcSjliGaR15Ho5WcSprHQodF5Cc04Qd2kZxkirrHTQTd4uXBvPz07XPldrtgOC5AWKSOXNEcA7KpohSG1RVNpa+3bo/kryDlZkRyM9wg4wnoxPM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(30864003)(5660300002)(2906002)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yg/n6w7PAG5zng3QpwFNSIO1TsKBagQQO0YxAyKgdbNMVi6Lxe7P48v0I8/R?=
 =?us-ascii?Q?qHx1oZ+3ArPxWPGNZPtWInZ2bLgGVvcemFFp0LHNHMbmx9GrdGWpyyCNgvJV?=
 =?us-ascii?Q?mgbOCSvVCEhe8mzeh0yHH+Zi1TkSFYxQRkCYKncQveH7ym4tv4zjIOVaYpzJ?=
 =?us-ascii?Q?LbPWC3vhlkDBtV4wfVIDaFtDqzrTxZSoL0QFDui2gQkL1Jq6J4p/N4UKMRag?=
 =?us-ascii?Q?u0ePTW5bSa078BpnBU9PAVWTZfb0irqwGOHNNZPsKqUdbTaXBgokzH2d2s4h?=
 =?us-ascii?Q?U1P7Bc4DFLisDcwWzN0NNlPH0DLLUN9tDLlzmZTJAIkpIJgL6tRSmX/JkmAG?=
 =?us-ascii?Q?OVLnIcIikg3iBgrb4VfC8kwxIvWQXSAgERUe0xrk0VBP/HriID+v04Nhfbpg?=
 =?us-ascii?Q?D+84v2/GUgfzRwID8wjtmo7TiJDoYDUSO5Jw7MQr/egfJSrovEefYgIBu/9D?=
 =?us-ascii?Q?DftUU96Yxi2JuJZUrTbk+MzYtY65P/MFkLc2q5PLfKX/jk9X5J4/F1xUJWo/?=
 =?us-ascii?Q?D1xAQGHOymGBS6ZR6guqNXzEyPBaq3XXJz7HdWbukZ5ORtUI/sEHLwzRuILZ?=
 =?us-ascii?Q?sDNXyjDk/3ZJSpDMoj2KlCxV0ArLEw1zrmHlYjfzfmRaGZbHb8BhrB3l/9so?=
 =?us-ascii?Q?pYnPCLrazbEP2A6c1JIk89cRZEoOix2wngNYJp5kcoGmgSaYKblId24hNSWc?=
 =?us-ascii?Q?TxkLolOPlfoYW8Ovnwcs2VvewMfTHucx97go80jEeWdxWGkbDpFmUhK+Ue5c?=
 =?us-ascii?Q?AzUZWDSSaFnUe8HfZxteLtovvYn7fik5yl1+VwNiqbuzOcS2lRjsHQ6mfp2b?=
 =?us-ascii?Q?BUKy+yP3UYjapSFi73DhX3XQaVflA6QT+CNmbKHrDzNDNCuFaqenuErAi0le?=
 =?us-ascii?Q?qDDb39AFHmaiZIRATmOvoNdxMNP8MIEOyST3mQVW7ZqiyXBBomF1QONNBf+Q?=
 =?us-ascii?Q?Y+sl5TCEAXIFBX6KLZh4LfrQxMbbUky3/g6bn+9sk0KUVp8/d+smBSL4lwNf?=
 =?us-ascii?Q?XtanvijWfeNeqDjbwww4v4HkZtyKyz6E8w9L2EXQ6NkKHeaNWWnK+r2aeKiM?=
 =?us-ascii?Q?LXnKRbw+VgNS/PD56qvsx3/5gd7Njpq1znCSANNpf7rapQEugFYCneImOPav?=
 =?us-ascii?Q?SYCwHakbNfB5IUjC3kdhDMbe8NJ3gF1ggovtakzKSPGjzfhmfJWdi8dOZRBZ?=
 =?us-ascii?Q?UBwKGMMCioI5fPaIq+wzWRi0LFLyqsFnYpOhhjgpvuy82pGkdvu/zjFvWhEc?=
 =?us-ascii?Q?k5T7+T6TXMXEmMHLyAvMlBBzq/D6C/NiT+ViS+gicYBnAUScEbyY7j2vwdfg?=
 =?us-ascii?Q?oB9N+8dHbKg5kOYdouFWsvCCI7PDGiZvJVzZK4C9d/L9qKyC+lf/5wRjz1AC?=
 =?us-ascii?Q?kSTU5fr1PI8DMoVvp1pUnFKFWQ2jeUVeioniEGbwOZ01t7FmW4CFoTivO+qZ?=
 =?us-ascii?Q?aJGh67HqYI3uuy7mHhBQALyevUNIHxReyPpdkODDPAg2ElCUXkDyr5LQKLBf?=
 =?us-ascii?Q?tKGXh4BU6onWvpuA1BPnS9IzfjbxrpiRu/W3djQsVRtPEX5v6qu7U/5iOr5j?=
 =?us-ascii?Q?DE8XDPdo/lkWe0gt6dr4zvm5FmUlayxU3wwCkbhv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ba44e0-41d2-4966-b04f-08dbf5c67561
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JrWF/iFA0GHHJL+qAP1bcNRmViolM8CIJirstNAWJpxEzphcofQKbfjZIKk+aNnu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

As the comment in arm_smmu_write_strtab_ent() explains, this routine has
been limited to only work correctly in certain scenarios that the caller
must ensure. Generally the caller must put the STE into ABORT or BYPASS
before attempting to program it to something else.

The next patches/series are going to start removing some of this logic
from the callers, and add more complex state combinations than currently.

Thus, consolidate all the complexity here. Callers do not have to care
about what STE transition they are doing, this function will handle
everything optimally.

Revise arm_smmu_write_strtab_ent() so it algorithmically computes the
required programming sequence to avoid creating an incoherent 'torn' STE
in the HW caches. The update algorithm follows the same design that the
driver already uses: it is safe to change bits that HW doesn't currently
use and then do a single 64 bit update, with sync's in between.

The basic idea is to express in a bitmask what bits the HW is actually
using based on the V and CFG bits. Based on that mask we know what STE
changes are safe and which are disruptive. We can count how many 64 bit
QWORDS need a disruptive update and know if a step with V=0 is required.

This gives two basic flows through the algorithm.

If only a single 64 bit quantity needs disruptive replacement:
 - Write the target value into all currently unused bits
 - Write the single 64 bit quantity
 - Zero the remaining different bits

If multiple 64 bit quantities need disruptive replacement then do:
 - Write V=0 to QWORD 0
 - Write the entire STE except QWORD 0
 - Write QWORD 0

With HW flushes at each step, that can be skipped if the STE didn't change
in that step.

At this point it generates the same sequence of updates as the current
code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
extra sync (this seems to be an existing bug).

Going forward this will use a V=0 transition instead of cycling through
ABORT if a hitfull change is required. This seems more appropriate as ABORT
will fail DMAs without any logging, but dropping a DMA due to transient
V=0 is probably signaling a bug, so the C_BAD_STE is valuable.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 272 +++++++++++++++-----
 1 file changed, 208 insertions(+), 64 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b120d836681c1c..0934f882b94e94 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -971,6 +971,101 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 }
 
+/*
+ * This algorithm updates any STE/CD to any value without creating a situation
+ * where the HW can percieve a corrupted entry. HW is only required to have a 64
+ * bit atomicity with stores from the CPU, while entries are many 64 bit values
+ * big.
+ *
+ * The algorithm works by evolving the entry toward the target in a series of
+ * steps. Each step synchronizes with the HW so that the HW can not see an entry
+ * torn across two steps. Upon each call cur/cur_used reflect the current
+ * synchronized value seen by the HW.
+ *
+ * During each step the HW can observe a torn entry that has any combination of
+ * the step's old/new 64 bit words. The algorithm objective is for the HW
+ * behavior to always be one of current behavior, V=0, or new behavior, during
+ * each step, and across all steps.
+ *
+ * At each step one of three actions is chosen to evolve cur to target:
+ *  - Update all unused bits with their target values.
+ *    This relies on the IGNORED behavior described in the specification
+ *  - Update a single 64-bit value
+ *  - Update all unused bits and set V=0
+ *
+ * The last two actions will cause cur_used to change, which will then allow the
+ * first action on the next step.
+ *
+ * In the most general case we can make any update in three steps:
+ *  - Disrupting the entry (V=0)
+ *  - Fill now unused bits, all bits except V
+ *  - Make valid (V=1), single 64 bit store
+ *
+ * However this disrupts the HW while it is happening. There are several
+ * interesting cases where a STE/CD can be updated without disturbing the HW
+ * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
+ * because the used bits don't intersect. We can detect this by calculating how
+ * many 64 bit values need update after adjusting the unused bits and skip the
+ * V=0 process.
+ */
+static bool arm_smmu_write_entry_step(__le64 *cur, const __le64 *cur_used,
+				      const __le64 *target,
+				      const __le64 *target_used, __le64 *step,
+				      __le64 v_bit,
+				      unsigned int len)
+{
+	u8 step_used_diff = 0;
+	u8 step_change = 0;
+	unsigned int i;
+
+	/*
+	 * Compute a step that has all the bits currently unused by HW set to
+	 * their target values.
+	 */
+	for (i = 0; i != len; i++) {
+		step[i] = (cur[i] & cur_used[i]) | (target[i] & ~cur_used[i]);
+		if (cur[i] != step[i])
+			step_change |= 1 << i;
+		/*
+		 * Each bit indicates if the step is incorrect compared to the
+		 * target, considering only the used bits in the target
+		 */
+		if ((step[i] & target_used[i]) != (target[i] & target_used[i]))
+			step_used_diff |= 1 << i;
+	}
+
+	if (hweight8(step_used_diff) > 1) {
+		/*
+		 * More than 1 qword is mismatched, this cannot be done without
+		 * a break. Clear the V bit and go again.
+		 */
+		step[0] &= ~v_bit;
+	} else if (!step_change && step_used_diff) {
+		/*
+		 * Have exactly one critical qword, all the other qwords are set
+		 * correctly, so we can set this qword now.
+		 */
+		i = ffs(step_used_diff) - 1;
+		step[i] = target[i];
+	} else if (!step_change) {
+		/* cur == target, so all done */
+		if (memcmp(cur, target, len * sizeof(*cur)) == 0)
+			return true;
+
+		/*
+		 * All the used HW bits match, but unused bits are different.
+		 * Set them as well. Technically this isn't necessary but it
+		 * brings the entry to the full target state, so if there are
+		 * bugs in the mask calculation this will obscure them.
+		 */
+		memcpy(step, target, len * sizeof(*step));
+	}
+
+	for (i = 0; i != len; i++)
+		WRITE_ONCE(cur[i], step[i]);
+	return false;
+}
+
 static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 			     int ssid, bool leaf)
 {
@@ -1248,37 +1343,115 @@ static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 }
 
+/*
+ * Based on the value of ent report which bits of the STE the HW will access. It
+ * would be nice if this was complete according to the spec, but minimally it
+ * has to capture the bits this driver uses.
+ */
+static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
+				  struct arm_smmu_ste *used_bits)
+{
+	memset(used_bits, 0, sizeof(*used_bits));
+
+	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
+	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		return;
+
+	/*
+	 * If S1 is enabled S1DSS is valid, see 13.5 Summary of
+	 * attribute/permission configuration fields for the SHCFG behavior.
+	 */
+	if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0])) & 1 &&
+	    FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent->data[1])) ==
+		    STRTAB_STE_1_S1DSS_BYPASS)
+		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+
+	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
+	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]))) {
+	case STRTAB_STE_0_CFG_ABORT:
+		break;
+	case STRTAB_STE_0_CFG_BYPASS:
+		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+		break;
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
+						  STRTAB_STE_0_S1CTXPTR_MASK |
+						  STRTAB_STE_0_S1CDMAX);
+		used_bits->data[1] |=
+			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
+				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
+				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
+		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
+		break;
+	case STRTAB_STE_0_CFG_S2_TRANS:
+		used_bits->data[1] |=
+			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+		used_bits->data[2] |=
+			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
+				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
+				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
+		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
+		break;
+
+	default:
+		memset(used_bits, 0xFF, sizeof(*used_bits));
+		WARN_ON(true);
+	}
+}
+
+static bool arm_smmu_write_ste_step(struct arm_smmu_ste *cur,
+				    const struct arm_smmu_ste *target,
+				    const struct arm_smmu_ste *target_used)
+{
+	struct arm_smmu_ste cur_used;
+	struct arm_smmu_ste step;
+
+	arm_smmu_get_ste_used(cur, &cur_used);
+	return arm_smmu_write_entry_step(cur->data, cur_used.data, target->data,
+					 target_used->data, step.data,
+					 cpu_to_le64(STRTAB_STE_0_V),
+					 ARRAY_SIZE(cur->data));
+}
+
+static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
+			       struct arm_smmu_ste *ste,
+			       const struct arm_smmu_ste *target)
+{
+	struct arm_smmu_ste target_used;
+	int i;
+
+	arm_smmu_get_ste_used(target, &target_used);
+	/* Masks in arm_smmu_get_ste_used() are up to date */
+	for (i = 0; i != ARRAY_SIZE(target->data); i++)
+		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
+
+	while (true) {
+		if (arm_smmu_write_ste_step(ste, target, &target_used))
+			break;
+		arm_smmu_sync_ste_for_sid(smmu, sid);
+	}
+
+	/* It's likely that we'll want to use the new STE soon */
+	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
+		struct arm_smmu_cmdq_ent
+			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
+					 .prefetch = {
+						 .sid = sid,
+					 } };
+
+		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+	}
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
-	/*
-	 * This is hideously complicated, but we only really care about
-	 * three cases at the moment:
-	 *
-	 * 1. Invalid (all zero) -> bypass/fault (init)
-	 * 2. Bypass/fault -> translation/bypass (attach)
-	 * 3. Translation/bypass -> bypass/fault (detach)
-	 *
-	 * Given that we can't update the STE atomically and the SMMU
-	 * doesn't read the thing in a defined order, that leaves us
-	 * with the following maintenance requirements:
-	 *
-	 * 1. Update Config, return (init time STEs aren't live)
-	 * 2. Write everything apart from dword 0, sync, write dword 0, sync
-	 * 3. Update Config, sync
-	 */
-	u64 val = le64_to_cpu(dst->data[0]);
-	bool ste_live = false;
+	u64 val;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
 	struct arm_smmu_s2_cfg *s2_cfg = NULL;
 	struct arm_smmu_domain *smmu_domain = master->domain;
-	struct arm_smmu_cmdq_ent prefetch_cmd = {
-		.opcode		= CMDQ_OP_PREFETCH_CFG,
-		.prefetch	= {
-			.sid	= sid,
-		},
-	};
+	struct arm_smmu_ste target = {};
 
 	if (smmu_domain) {
 		switch (smmu_domain->stage) {
@@ -1293,22 +1466,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		}
 	}
 
-	if (val & STRTAB_STE_0_V) {
-		switch (FIELD_GET(STRTAB_STE_0_CFG, val)) {
-		case STRTAB_STE_0_CFG_BYPASS:
-			break;
-		case STRTAB_STE_0_CFG_S1_TRANS:
-		case STRTAB_STE_0_CFG_S2_TRANS:
-			ste_live = true;
-			break;
-		case STRTAB_STE_0_CFG_ABORT:
-			BUG_ON(!disable_bypass);
-			break;
-		default:
-			BUG(); /* STE corruption */
-		}
-	}
-
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
@@ -1319,16 +1476,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
-		dst->data[0] = cpu_to_le64(val);
-		dst->data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
+		target.data[0] = cpu_to_le64(val);
+		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 						STRTAB_STE_1_SHCFG_INCOMING));
-		dst->data[2] = 0; /* Nuke the VMID */
-		/*
-		 * The SMMU can perform negative caching, so we must sync
-		 * the STE regardless of whether the old value was live.
-		 */
-		if (smmu)
-			arm_smmu_sync_ste_for_sid(smmu, sid);
+		target.data[2] = 0; /* Nuke the VMID */
+		arm_smmu_write_ste(smmu, sid, dst, &target);
 		return;
 	}
 
@@ -1336,8 +1488,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
-		BUG_ON(ste_live);
-		dst->data[1] = cpu_to_le64(
+		target.data[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1346,7 +1497,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
 		    !master->stall_enabled)
-			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
+			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
 
 		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
 			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
@@ -1355,8 +1506,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (s2_cfg) {
-		BUG_ON(ste_live);
-		dst->data[2] = cpu_to_le64(
+		target.data[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
 #ifdef __BIG_ENDIAN
@@ -1365,23 +1515,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
 			 STRTAB_STE_2_S2R);
 
-		dst->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
 
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
 	}
 
 	if (master->ats_enabled)
-		dst->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
+		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
 						 STRTAB_STE_1_EATS_TRANS));
 
-	arm_smmu_sync_ste_for_sid(smmu, sid);
-	/* See comment in arm_smmu_write_ctx_desc() */
-	WRITE_ONCE(dst->data[0], cpu_to_le64(val));
-	arm_smmu_sync_ste_for_sid(smmu, sid);
-
-	/* It's likely that we'll want to use the new STE soon */
-	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
-		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+	target.data[0] = cpu_to_le64(val);
+	arm_smmu_write_ste(smmu, sid, dst, &target);
 }
 
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
-- 
2.43.0

