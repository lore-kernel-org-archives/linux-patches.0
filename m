Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CFE3B95E9;
	Wed, 13 May 2026 23:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716675; cv=fail; b=VReYWJ4uBCrxxsDDRbMVRX49GcZq5HKyB2ATyYj8s6orrN7X1iuOs4LDQDU9pxyZpnD9FcEt/cknkBh/f+l55B67IEWf7bhE2eN9mghnY1I1TF3Zzr4G6K1oKit6JRtdpPdDV2od/o7Dqc9IUQTlZemYECBq1ntaxAhjsSWAxYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716675; c=relaxed/simple;
	bh=UGLMdELvIgQA9BkyLK9jSFEGm9LxCuOQU6ACJOlJbk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K5A48iyT+gR22UtU2QzEbd6WmHbHH04JtTLxAFaW69S56PbDhOK4kCksIQS6FXK4vdzponan9ajsZO7At0F8Dc08YEmmyNhAeOBgrYTX5JH3baBhZDCXNJPUSaAiC1vYuki/Ak7fV+b90vEATD8Cptk67kVF+lgzX8iZIwY/CeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vf9K2EeZ; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vf9K2EeZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ho4UjJrEest5BDBHfUWJaf6rd2R9Yqxx06JG0rRyzm10Mdg/EGN8DVz6NJgnmRLWKFe+OfFDbgA4iQSN+IMSBXo4I2sPjcsMi2Wf8UeMt/6xQfmU8OcMuxgGpxsBblwSc/aTVOXzGz+4Fx6PPjBjtrCWkgkOxcVO4/5nidwaMC56Fl2aUsYbseUGiocPK1Q8m+iEm7bgUahFrWZIJ9RtjipDzr5sJggH7ahSAadfJE4k9McxULfUh/KVIeRVtABp6lepKiq+iQcQRRBNLzoDr+eTQCg/0BLXVBG7VwAf+3REEYP1GgUY31QVxUzT2Q5CpTh9FMwDK2nrlgTwQecTJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Yct74R6u5xZnX3Os6NlsUYpj9wSRVWf8fshvIp3Uws=;
 b=Xo8n2gYWwS4TumuG7vglYP2rzng/8HPsOiIK+44Tf0bShkwM8ZmTXqV3jffkuPoVUZPFvcUfBMq8u7ngTS7nWDSrBtGw9QHODM0TxNBEoPUlK3p/4wb4rrkxtEDcytnwFWAeH90XNtg/jPLdhREL7suNZldPo1Tf4LTqFCPnmsbFthTUFJNaxAgw12MnlcBOFK58ZM0oyY3AAx71ddf2ZmVQjm7OyKz9W5tR/sqRCYvIGktqcXUKyPxe2O8HppCEJccMOO9ETxjo7s85IqeAIRbv/8C8LAuFowsWmlbfKHlszCDbqtyoE1Cd6jlrpuc5qJnIiki3nm3VJffI0kmO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Yct74R6u5xZnX3Os6NlsUYpj9wSRVWf8fshvIp3Uws=;
 b=Vf9K2EeZohBZyS674/FW+vtL0Ji8rFM8eKZrbs8b6zIl9uTkOVsnGBQjOa8XuLjmFBesmEIp4cwfRigCO/1tZNwXMmnuaMk7kwCoswS+pon90gMzp2mlMaeoTfkhat1RkO51i1ZD35yDLTUL/S/UQ34/8IsvJa/cr6T2MXrtb7q1NIxbV8pybDPiujL/KqXmyVSQylNtS0igtYRGT1Bsz9yaonoLJlSTCEUXAsV32ACpnGAKYeCceH7HeUCAQZisxcFT0ogWdNdhRYwJ9x12kys8tI4dxmRdeGtEj0gbPzxnvwMqAUx6BnWH1Ez5+jw/01wJyOuTN/l7xaBpPdfuLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to represent the HW format command
Date: Wed, 13 May 2026 20:57:40 -0300
Message-ID: <1-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0020.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 213f3244-31b6-4d80-5557-08deb14b7007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	8InJTFH8vW+g3ZjOmcnXIV5iA0D19IjSKPyIltDvKqLubFORFpnEDzx5kFuNNNkQh/s3frzOhrgAhT1gU+ppb0gAa029rHt3N7NGQPvRAkl9YxC5ihoKKNguwd8wTZZIMQ494HEcYYl+jDSnwp7BUrP6vRw3tbelQgggfh8gs+ahGNLlf8vEfievIJP4cUV99Dv/PVXiC5XrrhGNuD7UsMeBly2yvcfMWCVFfm57+ZL3DKbwDysz9IW0VWKbS8q7Ss9co+PQn0RuD8Z5RPaklXrb3FQLX5z2C8SLn/Z+39q6Kx9vGv6jGeZfkaIqL8IZ1YDeCnNVJk9VhIetBgFwok7zL3SvuHW99yE3tBWukPUng+w4PbrdduCI9DA4bNfDmBUI3YIPB0zWycWnAKflm/z7SAJUT2Zz5EpniW20eXyaa+3dVdahkorm8Zu7Xir/6b8BfoXZg+cufoJh1unLOLwQdPMXDHu2TEyF1Z3f5jkFlT+Ft3IVIiXrxF7Lvbs23rMlTyLDvOxXGWynbP/h5vDJfBCsCDOQ4JRdezB9gvD35l/Sk5q7vcQSnPET8ZAPmOzGoIdCRYgr0F6Q2in9im9RleyfZ5yDqBURLuFdl/etTpW4YRG2y8iHeDoOv3Oro33JqPAod+LQDVC308q97RFtwKoAc6sb5t/IRLFUeHXPGtsh2zuXwSDtuJrs03rK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x7c/T66fusXNK5LaMx8bkPffMH39IGljhS2i0b/Z1677ALw1+mJtnn4BuhbD?=
 =?us-ascii?Q?q6X8k4FBjpsewZgymOhMEeIRomhlzAtWIJ3ArOce6ZN3/9TZrGUiZP/+PWXn?=
 =?us-ascii?Q?0jvzD05OvpbX5YAcb3PbZqOWjWX8VRoioY2uiKKj3RbYVH8c7BxkfYOS/Jcq?=
 =?us-ascii?Q?FkkFrJZONj5uODSVy4EXjlvCFXABH2HiBJ2gX7x1SFW0lKNIXEmBtjDWiLEL?=
 =?us-ascii?Q?BvKTOSKvVObpsjnQKoOYxhMz/M7eQvStUUToNFILQA+rVYf5HNdf/iLSjkme?=
 =?us-ascii?Q?Goi/k8LLmEqanlBokuBJK2p+4rOgxLJRlh+xVJmfGfxrHws9edWrAgTyOw3C?=
 =?us-ascii?Q?2dqX+yJE2QIRBtjohuqPTw1aqoAHtM5aM/YypCwGr2wzeVTcSoIVUWyi+lOy?=
 =?us-ascii?Q?38wh9nGCxLtvkFRpgPfMwaxikOyJNNDdXypg3mxsY/X37Nn0R8QKTbtppigE?=
 =?us-ascii?Q?Mb32PBc9hz2Jm6rHE5QAS5vfdf6hqB9NBh8fi+wA/zRvNVqGLQPFrawZ3v3n?=
 =?us-ascii?Q?Rd/otQ9OFEfe3g9zYw8O4x0S2KnN++oo908B6f7HErXaZwedbQMEaezX5FLe?=
 =?us-ascii?Q?GA4zfphNdwPtwsMPlAwkwYpOYt8VQdDNOfRXNFzPPMu+D0RR7iS8N09TmyCG?=
 =?us-ascii?Q?vMGMuYwIPdYhsO5XDo5Dg4fnm7hgbmb3IVo8S69ovIEw0vIA+852muRfMIuH?=
 =?us-ascii?Q?COd+bGCXtWPsIF8PLa0EHWbIoXOQ/ZxlR8LaKQkvqUvdIhL+a4z2sIxToGfK?=
 =?us-ascii?Q?c2NL0vjIfz1Ny92+4Na2f6OVUtXvF+2LU5IJYQbl/3nh6iHtOZIFRrJsVKgU?=
 =?us-ascii?Q?io5uj5PuyCjIIRJt/QIIqw7T+itokOGTwnDo56/mmukYYPdEXq/hBwB3aEot?=
 =?us-ascii?Q?h7o2xNRBUP0/NsBEudNNWHlnchBZkTiAxDuxBPe6MF0u8Aun7DoLVbSZ7Yuv?=
 =?us-ascii?Q?WwEfYQ7RKYNYBHKE8C7NFbfvJ5sevazBAGfQiOYaULgQikwcPs6aZ/Nr5lEe?=
 =?us-ascii?Q?705scuEom2C0g0ygbDVo6xJoAL60pH3KgkGQNl/qWkKhK+rFP4LAcvjF0JSi?=
 =?us-ascii?Q?YXSSeP23VJpgjMDscMxA5NiO7MEsBYnTQEAGCGQJsHQUjg/isgZatlz9FXYQ?=
 =?us-ascii?Q?kAl17whLrJ044LLBypph8e5+HKmfnLOsbUpFwP5hhuaVbKf5pwxgRHrDDMMI?=
 =?us-ascii?Q?/Op7ZG/he8f3gVTHr9sf+UIAMlNEEk268ssX7f8zWseP7T+Zwdkv9aJ2L9Fw?=
 =?us-ascii?Q?van4nkl0Jn4ec58MC48HtjFmRfgnRjMcTue2ebzdi/iu2QJkU2RXIpawfETZ?=
 =?us-ascii?Q?BgUw4Bm7zHdoGVWGAH2HdAyQyovATQSXqL59HCl6N//Gc9zQZ9dbsSLXINXI?=
 =?us-ascii?Q?LHs1C1+8P6qiPXxNe2w6yX+NwKAJiEBHgcuVj1bW9Pymc1GyUcQI0AyEdxMI?=
 =?us-ascii?Q?2Yry2Jf3T7hxWnVdcIAunYMEI4p0HWUG4T7BqlA9QJdz8XQuioRTQQd7QQS1?=
 =?us-ascii?Q?ZKmoA1K4BjefXhsft/qatDPz1fqxJMZLYXkLp0lp1BYKBxmooCQS3prvt/sG?=
 =?us-ascii?Q?BjlhIy8JT6WxFa9TzapF+OpUe2/shYQQY/WU9ODas4r+fMGxyYsiXelKOHwt?=
 =?us-ascii?Q?W+ipwuhqZ9Mm5KO05Q7z/iN2H+fHU6781qshhEX+tvFTb5qC9920jlJEcYbF?=
 =?us-ascii?Q?TBHQCMkzs1+ev1GP7LWxb1JPEzVEfZTwdbYZCzNvkkd87lmy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 213f3244-31b6-4d80-5557-08deb14b7007
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:49.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYwD2jGcfbAdi1xeRZRhf0wtnHMouDArEHPnEwldUCWeD3meE1opKpNlIqY0XG69
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Like STE/CD, add a wrapper struct around the u64 array to represent the
already FIELD_PREP'd command data. Unlike the STE/CD this is a u64
because the command submission path will have the swap to le64.

This makes the API clearer when a u64 is referring to a formatted
command and makes the following changes easier to follow.

Move the command constants out of the struct and into an enum alongside
the rest of the constants defining the HW format so the entire HW format
is self contained and independent of struct arm_smmu_cmdq_ent.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 48 ++++++++++++---------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ef42df4753ec4d..092179f689e9f1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -390,6 +390,10 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 
 #define CMDQ_PROD_OWNED_FLAG		Q_OVERFLOW_FLAG
 
+struct arm_smmu_cmd {
+	u64 data[CMDQ_ENT_DWORDS];
+};
+
 /*
  * This is used to size the command queue and therefore must be at least
  * BITS_PER_LONG so that the valid_map works correctly (it relies on the
@@ -426,6 +430,8 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 #define CMDQ_ATC_1_SIZE			GENMASK_ULL(5, 0)
 #define CMDQ_ATC_1_ADDR_MASK		GENMASK_ULL(63, 12)
 
+#define ATC_INV_SIZE_ALL 52
+
 #define CMDQ_PRI_0_SSID			GENMASK_ULL(31, 12)
 #define CMDQ_PRI_0_SID			GENMASK_ULL(63, 32)
 #define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
@@ -447,6 +453,28 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 #define CMDQ_SYNC_0_MSIDATA		GENMASK_ULL(63, 32)
 #define CMDQ_SYNC_1_MSIADDR_MASK	GENMASK_ULL(51, 2)
 
+enum arm_smmu_cmdq_opcode {
+	CMDQ_OP_PREFETCH_CFG = 0x1,
+	CMDQ_OP_CFGI_STE = 0x3,
+	CMDQ_OP_CFGI_ALL = 0x4,
+	CMDQ_OP_CFGI_CD = 0x5,
+	CMDQ_OP_CFGI_CD_ALL = 0x6,
+	CMDQ_OP_TLBI_NH_ALL = 0x10,
+	CMDQ_OP_TLBI_NH_ASID = 0x11,
+	CMDQ_OP_TLBI_NH_VA = 0x12,
+	CMDQ_OP_TLBI_NH_VAA = 0x13,
+	CMDQ_OP_TLBI_EL2_ALL = 0x20,
+	CMDQ_OP_TLBI_EL2_ASID = 0x21,
+	CMDQ_OP_TLBI_EL2_VA = 0x22,
+	CMDQ_OP_TLBI_S12_VMALL = 0x28,
+	CMDQ_OP_TLBI_S2_IPA = 0x2a,
+	CMDQ_OP_TLBI_NSNH_ALL = 0x30,
+	CMDQ_OP_ATC_INV = 0x40,
+	CMDQ_OP_PRI_RESP = 0x41,
+	CMDQ_OP_RESUME = 0x44,
+	CMDQ_OP_CMD_SYNC = 0x46,
+};
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -520,15 +548,10 @@ struct arm_smmu_cmdq_ent {
 
 	/* Command-specific fields */
 	union {
-		#define CMDQ_OP_PREFETCH_CFG	0x1
 		struct {
 			u32			sid;
 		} prefetch;
 
-		#define CMDQ_OP_CFGI_STE	0x3
-		#define CMDQ_OP_CFGI_ALL	0x4
-		#define CMDQ_OP_CFGI_CD		0x5
-		#define CMDQ_OP_CFGI_CD_ALL	0x6
 		struct {
 			u32			sid;
 			u32			ssid;
@@ -538,16 +561,6 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
-		#define CMDQ_OP_TLBI_NH_ALL     0x10
-		#define CMDQ_OP_TLBI_NH_ASID	0x11
-		#define CMDQ_OP_TLBI_NH_VA	0x12
-		#define CMDQ_OP_TLBI_NH_VAA	0x13
-		#define CMDQ_OP_TLBI_EL2_ALL	0x20
-		#define CMDQ_OP_TLBI_EL2_ASID	0x21
-		#define CMDQ_OP_TLBI_EL2_VA	0x22
-		#define CMDQ_OP_TLBI_S12_VMALL	0x28
-		#define CMDQ_OP_TLBI_S2_IPA	0x2a
-		#define CMDQ_OP_TLBI_NSNH_ALL	0x30
 		struct {
 			u8			num;
 			u8			scale;
@@ -559,8 +572,6 @@ struct arm_smmu_cmdq_ent {
 			u64			addr;
 		} tlbi;
 
-		#define CMDQ_OP_ATC_INV		0x40
-		#define ATC_INV_SIZE_ALL	52
 		struct {
 			u32			sid;
 			u32			ssid;
@@ -569,7 +580,6 @@ struct arm_smmu_cmdq_ent {
 			bool			global;
 		} atc;
 
-		#define CMDQ_OP_PRI_RESP	0x41
 		struct {
 			u32			sid;
 			u32			ssid;
@@ -577,14 +587,12 @@ struct arm_smmu_cmdq_ent {
 			enum pri_resp		resp;
 		} pri;
 
-		#define CMDQ_OP_RESUME		0x44
 		struct {
 			u32			sid;
 			u16			stag;
 			u8			resp;
 		} resume;
 
-		#define CMDQ_OP_CMD_SYNC	0x46
 		struct {
 			u64			msiaddr;
 		} sync;
-- 
2.43.0

