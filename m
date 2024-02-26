Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FBC12F5B0;
	Mon, 26 Feb 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967261; cv=fail; b=enhzL2/szUHN8yBuNvlX7JM7mblnY5XhXBi+n0bq85NCjIdrntgAMx0xVa/sqR8Qa5+Q6YEaPefWDDujQbgg8XfD1KsY5yp4WOo28I77GuqtffyUXbaU/nroeb+sU4lgBKOru7UcJIKetkgk5kxe+nWhf1m69w52r6M7dG0fZa8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967261; c=relaxed/simple;
	bh=SnUyIjK7mntPSw4YFGDj2SAiE0ZOW558HuFcVXmN8T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jeA9yC092mqPO9gWg+Veio5hwwvh2EDxz/61ts1trXCnqWT99mACTFJHdUAwssNAZ3GbwkgttdCydP9ZJSbbVIR6oyMcbRlXKJvkijt7gckOipcK43ggWLrqOPMtRc/zFs8t0AC8hFfnQGhk/vo3q1hxvUSo5zjDdJ3SnKAxexU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HkigGeog; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HkigGeog"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/Ag6Q2/mFaivBdDIPyjVVNf6pHkHEPzVRFuu+hnOnKwACjPBMeeW+IMbJjw/9AXAm+ECaLmKdV9agD/2QgM0THqUnJv5Devbr0vhivzP/YmvZD2bg0SABT07WWLELFd9k07V7kBE7+ibt2UvJLdUF8H0G6om9FPGD1ejBD67d+skj0xJkelGZge56a/8j1J9VTU4E845qisJ70hY7WN8S5cKPpUG7QNZ1MiouxXk0zDPktDfxFWV6F4yQ7CmZf/VgsXnZ/CrfPDDfA1LEx3Ak6wx86Z4ZoTARTs1Pkv9qDFiNscPO/lkCVO5cUavFeBSIvaxOuoTEqvgq3ZKokWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C88f9NuSQXK5UjVS+I4LS+ehiwyTVUnej0TZ9JTb3G4=;
 b=Apg3+AdDDndigK/dMA/xbVVWG6QvFMDXnX+pycThHYn0kw7ADUzYeLSpSlM7faj9/O0qsjf8NiG9MT6wK+qJ79KlZo9NfwElth5fpNQvCkiBlvLnsycdovVQFKddChYxQ3tJaMDNx0CG7V+yOcEqTvkOKDYaU61MOs6R7rgXQt7Te7+OyO5eBKiDaZEXe7gNE1kqbA7LPn9ctVEUnB7nr4X4Zhv4M/RSOGSoIMJJsdmuElE3tOwnWupjLN/0TGmXfAzZ47fk1lcNyIfLx3M5hhtAUdEimh8G4cD90jLs2+J9FeQ81q87X78KdqTHqzqCn43psB5KNOLiG3lbVK03LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C88f9NuSQXK5UjVS+I4LS+ehiwyTVUnej0TZ9JTb3G4=;
 b=HkigGeogwXx0579vSZUL1uk3mj2rVwLsEiV65XhbxiWs4GttevpTw+vMiqwS3YWw850GIrHXTapwhTrjf79NLmuX1EEhSGOEI+uPPUNwD9n1qd32EzxSciGasROCCsSU0SixTlD+k6R/Tqgpstp7W4bPsC1N0DymwaMBerFfcLug1XBslE20i3A7wxhPEaiH6bogHjBQVdkeVSfweCR9PdcyfHNWjpi+uO4tD2EFPH53hvcX1QONvKPQkp1QzvIWmBspIa2PN9ZuWvibZ9eVClxk+D8XNkzJfgCuCIwMTE+ztEBdHXz9QDNxobXFOzAhxk4/mXfuasQQ+McpPs1gkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:31 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 04/16] iommu/arm-smmu-v3: Build the whole STE in arm_smmu_make_s2_domain_ste()
Date: Mon, 26 Feb 2024 13:07:15 -0400
Message-ID: <4-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0035.namprd15.prod.outlook.com
 (2603:10b6:207:17::48) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: b74601dc-1721-451a-b01e-08dc36ed6a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s/Gnk3EihsfFpUaKSJL+epbtoFwLkKUV8CE/uTQgDhPxpUOrniZ33jJgvGHIMvS0oqE1I3DySfU4Bp2/x39F/bH2wC+0tzX5iRUtXinPPO0DCzFmpWvMUOOQNCoh2qHB0mGUG6Vx1OEXCSBCplYcFG0jjcGp7QovUrmK7M9MMrDpZeoS+7Hux4reaAkSMf912qOvsKL2dhj8DnGD6O2cyqYptetb1lBHhObeoqFKlV3BncDxAyKlfs4UFEVv9gJ8lENhUu7cMZfumTM93JPNzFYCdhqzqY06Il4MUp676s2oov82dNEfT3bR2zxWpuYO6iztNza1KWxljxgtHYyFsFuM9W/Ozfz/N3t4pbkuA8FrsM1W8FV9vuN5Ylap84BLjlyweawZp/6heJ8hFN3qUAKVBllXtDtnh4mO/GhDi310WLeSt1X3PHrwEjyWhuJ0Nl09dl5V3HF/y+Hjl/Xp9Yg0guAGVAnEVYRuhSMNm4ZC7j1TfCLeNezboQGYiSWcWnx7Zo/BjWyPqKwL7FRsC6kS76f3yfxz0Il4fkog3UeE+xb1vcibcpSKLrlcWUXu3WYdulbitV9+uCByFkOTi8uSx7pyaT7U9o5agvDGb92HzCUHIdQrf/A8PRmzRoOffxHL453ArjXexKZBn1wcRw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HiqiGvPB+e4Wce7aZZroeC8qq+XJihA9nQkahLn+SGFoh7fqH+ki8hdrqR9+?=
 =?us-ascii?Q?U8UuJqY2rnZUb6MXWt7Xvzgxj9lvU1jnSbmJEJf56v/o15RkrW3tdmO4LUuL?=
 =?us-ascii?Q?JVBELw0y2FCoiekofGhMTTPFyFCgPpx7deUfeta6zWjsbIPt3uen8cr32g8F?=
 =?us-ascii?Q?iJwwds+FjGO6YwlSUIsenOHQAwIMBoJmvsuMADNu7tIw0YCWhl/fdwo5IwMl?=
 =?us-ascii?Q?UTr5ociTlrKSgwjyN+PcMSiIfFbK/Si1+g8wUIR2+UZw/lyGUAefOb+ti9hk?=
 =?us-ascii?Q?UkyuCRyt2YuW5mSBM6ggIzX7e1EXkw4+y0xOnTlbzi1yrpD/8pGHCGtwPOF+?=
 =?us-ascii?Q?k3D+vbIbyPVDdFX1tCKg9+ZFVFbSwQcgV1AIohtTF1LtaEo0wpP7ldMjrGBj?=
 =?us-ascii?Q?0kWLBywIUyFTs5iqH7heHSpyC/k1E/K15/Z5wzcvA20IbEuTLopGKILWkBO6?=
 =?us-ascii?Q?yM7DyynbQW/v9KcWc0dDg+s6lECwoCvJNX8oLEchnADwd+Z0BAZGA2vWL5rl?=
 =?us-ascii?Q?0UNmXZMlO+2bQUh6FINZR+WZTGmhQzhUb/JaoucngVbJxSeHgz32lOIyZZ99?=
 =?us-ascii?Q?PxoWiX6/rozVaomvD3N+kJ/nHWkded7V6DzFrIszyqXRMOzewi9neSd/EtwZ?=
 =?us-ascii?Q?0i4x9gZyW2SutfP2Yrk4JVrHmcTr4+M9WPU1yQqtQkvpYAoq92n2Te0if6Cj?=
 =?us-ascii?Q?hbcLKGe0ydhyC9JDK+tPwV3IrtF/btpu23UziHhTv3RZ8bnMXopXVUDAcpF5?=
 =?us-ascii?Q?j/GMlxFnlL5GceYO6uEOCqSAbxH6BummiGY3F2IBr5oXfEVC1qyUxsBX4tgd?=
 =?us-ascii?Q?stsC4w6s/wTHLbdHxOoGUvJ5dWoEHxG1i5UhJcE/ZaT9enfq2dRYaNDpcaLl?=
 =?us-ascii?Q?Gw12qUQ+66oTuLA0utfsEuWYRIttxHnZ/iw+YwJ1LELHaA0AHApfWbO2lfbn?=
 =?us-ascii?Q?bJQ6VuPXN29Bc29MENC+0Qq0m6LoWkzXc7tX2B2iXVWGxi5NCDBFna3cE8w+?=
 =?us-ascii?Q?yQpKe47Q/utcqrhZxErEofQRfXmdh+DHJbCeBCS92JQZGQ0x9yQs+dAmZKMu?=
 =?us-ascii?Q?SFWLTf06gU5woen7Kd1onW93pGVjS5JYMMUqo0jSuiulr7Cvm2htyaaklIkD?=
 =?us-ascii?Q?EaAg4CgVbpy8bAEHLNbpbRjtPhUdlbHcp8Al/lE/N3mufI+7Tu9l6w69IRMR?=
 =?us-ascii?Q?ZUbt3/kZVxClGrkP7xTMc8Sl7o1XOLSkMYepRTFEf7F0ND9uQf4TV6gW259u?=
 =?us-ascii?Q?Md6RsWtfEpEOUVIt057ScI9MvocNjkih3oJUoD3OJSfSAL6RQOa8svSF0Pqh?=
 =?us-ascii?Q?q8sRK3kNRT1xbp8osQHj2yRNOMxQQxz5OE0/uzFjJ8FyUdQaU7l2YhXBiGih?=
 =?us-ascii?Q?fHuE5vl4DuzfaUfg0HbBfRmfxJKWHe+LeLVw10pT/R8qzDs8X7tSYLc+1W1X?=
 =?us-ascii?Q?+3nLl5jV+afOUTgB8nIUgJBRbSx+oJR69DqyBvNM4t4k68THIU9hAmIqlQRW?=
 =?us-ascii?Q?Gliq5f5+v72rc/6CJe/i6W618eiLXCUNO9Qvq5voSKBnaFE7FZNTzQU6HG0X?=
 =?us-ascii?Q?IGwAMVEsI/ns1ltR60J9RGSMJOIBS3VqurxQvfRy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74601dc-1721-451a-b01e-08dc36ed6a0d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:29.5840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuLqrnW2HUCKcCxMAKfF0DDL4/zbD/Kg6cILiN81II/erGZszxSM15NvhrhRTjRb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Half the code was living in arm_smmu_domain_finalise_s2(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 ++++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 --
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e34c3181966934..b81e621a8e5921 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1520,6 +1520,11 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
+		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	u64 vtcr_val;
 
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1532,9 +1537,16 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_SHCFG,
 			   STRTAB_STE_1_SHCFG_INCOMING));
 
+	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
-		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
+		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
 		STRTAB_STE_2_S2ENDI |
@@ -1542,7 +1554,8 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		STRTAB_STE_2_S2PTW |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
+				      STRTAB_STE_3_S2TTB_MASK);
 }
 
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
@@ -2302,7 +2315,6 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	int vmid;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
 
 	/* Reserve VMID 0 for stage-2 bypass STEs */
 	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
@@ -2310,16 +2322,7 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	if (vmid < 0)
 		return vmid;
 
-	vtcr = &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
 	cfg->vmid	= (u16)vmid;
-	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
-	cfg->vtcr	= FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65fb388d51734d..eb669121f1954d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -609,8 +609,6 @@ struct arm_smmu_ctx_desc_cfg {
 
 struct arm_smmu_s2_cfg {
 	u16				vmid;
-	u64				vttbr;
-	u64				vtcr;
 };
 
 struct arm_smmu_strtab_cfg {
-- 
2.43.2

