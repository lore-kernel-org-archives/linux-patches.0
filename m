Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9127A30E0FC;
	Thu, 17 Sep 2026 00:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604901; cv=fail; b=hvbWbnMGxAEs6vkDiIgTBMqEXVZMvzXub0hSGzQInetnlaZv+xHAEhb1fGtFVkgpmHDA65N2FXKwXoYabfkyOXOnprmR/G1Yjj7GigPZdkVR4nbFx+xYtLU2NeHud2TqdFDUVJEWKmKPa9BPH3kAvpH7DzRvu0meJHO7M3nxlY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604901; c=relaxed/simple;
	bh=KgOeGNHoA9C03JpzlZ8VPwtFVidwandsnbS4zuok6C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=relCyDQdMIkly3O7stMKi9Cn4kjaqfB8y0bvOSznqnLI/hkzWFRJUf1NC33HUOpY54hL3c0A6TVrRz2cEWMDotcL/yGc04OoYSOPP0zoq+Zc8rkVFzuiVOQ2k5beKxY3Jc6a28lK9PiH1YzCSQ2jIB8UOp6WWaUjREzEMpTHaJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X+3MW+K3; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X+3MW+K3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoMDn1GXhO2xVKKTw/qs5WjaL3wLtFJbsbyF9VqgV1gnQTwLZ+eHQ2UT+NUoMlJDoDdhxAUZ2pqE9hlDQUjG60lV8aFekf+eU8hmD+PwbhA5m9oiZ2JC/XkxpP/aXUPT9g4G26tDJEDIWxLQSQHAkrbGa3yDjFGLV0E8GSXMqF/bqAdT1p5LpBRnV1JG8JLN99rOvXoZQurIwrBJcCdzSZq+EVpEHt/JQPpaIIWNQackC9UDXmDw8Bbgu0h1rQWyufyaqZ+58ucmTE+krMwRQdpcixMY1ZBcfeBO1rmCKietqmbTBj6xL3Nns0A6vi7qF7zqmbBzj/4DjCzsqTuoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpJcTVU1S8OhiYCz0Doau3LlKh50hFECHN5hsx/TIrY=;
 b=JXmdWhEY07LK8kvGc1SCFWTe/SZHGEwbITium+VLyQa6Rrg2J9QdlfnVQnjqha6UMHc422lYRNrtc4oD8qTp5yGIWj2gdG5as7EMA1d1Due+bzNuiMZTPZuJgJDjKuu6uLd8alMBpglVYunAs4kkaJZo0HyV4RJvpKy9tptmHGlX8no6VqroIGphaCbYaXd+67ByojrNWIVDSesqhJO5KjOms8hESu+gyriPLZlfV1eeIpcjQi0uSAGS4r+QvRVRTfrB2L7IMKw4FM0FumEtVdSwPzioes/1cqhJp2gcoau6FEMu+orvkgtz4PrbHjNKbBk9hdmNow44yLuB+NYFvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpJcTVU1S8OhiYCz0Doau3LlKh50hFECHN5hsx/TIrY=;
 b=X+3MW+K3bIvyZ3yyqrKnnfwqDwS+U8Fmv4Ghtk9nni/eHAD68yGCMi4sov2hY/kkqKEmuK5x6fWp3VwtdL/zotKw1LXIwYw3CxU8vglPZCV1BI8vO60+DaL8QIgPM0G1oo/AInlfxFkbAB2l6BCWU4iVAfoLlrBIOuenXGplxzvSlo/YAfd3EDX4bdHWRrRrqjlYSGBLNDvFdD2I2ZyGi4BAVbYS2gJhy+gsGzI67oxxhEqIG8QNhrXXMkMwpM3MZxXodcVmdkKI1QjxSI0S22e/9Lvd3rbVleUd2JdUFnjlFVvtnKDwyX+lBfA7b66QQubXANs7VLjjjwQGTVrazw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:52 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v6 7/9] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Wed, 16 Sep 2026 21:27:48 -0300
Message-ID: <7-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fba5818-f4bf-48c3-c2ac-08df14528293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|11063799006|10067099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	RSKF+R+zdMypvJzybfB5aNwVLwRsUnG04AswP8A6a+jbXpXDfIIi+YIlAL6Y4oM8wNLUT0S0XR2vhDQ+9DC01cemlBxRYtfEAg+lDQcdW+ukcLxSQrwHA/huAc2QkQXIF9W7ANH5ubeM/q+Uy2u7vMjeP6r0p8anBi6DCzCWX/eokst0BLvGi0kC0Q/h2gZ4Sbo8fFei6+JqF6P2qR1lH5Rffw57uHUO6ooIYCb0Ssn/b92XRkRb0PCWKH/DP+SZnwvZ1AXAtkMi98X1ZmwHQyorLlpqlrVxBvx1d7OhUbmESkhlBzz4Py7DsXWFoodt6F9/fXh7m8HRa6T+IlXwD4/IPhulLgGmYkyq75HShpTF1ZA7GBgg+Uzy7KDmyOrlS0CUdFzxTCRQhQdUqgZA0cR9dWVnV1a6xxCWdO8kwZ1feoFMHO4lEDQiCJJ3RVS44xM2GfBneBNxxg1tp4sPJudq4fTB51gmFru4+PcYeSyhMfrXBG30H8Nh4gldejHwUhiWlQnumMAxgdwjOBh+vmsRzdR6ECHlpF1v1ND70PL0L3wCG9ie9iu81nPrVovtn7g2AvzdpTYnu8zMT+vVCWK1IPvA/oKH4CYalYfZ3RlsR40siUSu+OSpd9eRl6kYplJR1eXZR9Gb6WHwhuFOW+ySGNzS2Cs9ocS4wBIe7mqHzx5/Svk4Jh0vLyRd0+pH+B9ylGLqXfstjj5So9zqtQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(11063799006)(10067099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lk7I3QHbf80zNPBUYkwS/vH/znm48trk7HW14lYpfKZgPqXTkJPZBrDk+xBG?=
 =?us-ascii?Q?mI2WhFG1d9ZeyWQDuxJDjFArwOyweRyx1ixK+xaCCOHKZ5XBzh6Mo+HX8znZ?=
 =?us-ascii?Q?2TjDcllSenKlnrJeUDdSqbSrk6OC76Yx5o6ELf4v3RCv6K8sgjjbMDPjRXw9?=
 =?us-ascii?Q?bKiKXn4CPV2qkUkjg6EK46xrUIBJ7sDjkr/XwetcKOiTHx8FmM0EC+BtNSzf?=
 =?us-ascii?Q?8lt2B7ch7oVgkWBJDRV8e5P+bmJ1i4yzHRQQ06OpE3FPVtODXCG7AwDQprYD?=
 =?us-ascii?Q?IRPE9qrMwACQaSXJIWCc6NGAagNk5gPOgTEQQgNXFeoiEv/ymKD1/XA00ISd?=
 =?us-ascii?Q?DX0MsW1cBIznymGUomLCwkThqaD12o+/fTR1VdTwEwVyC+llR+matiIF2UAs?=
 =?us-ascii?Q?mo6V8+BGClJ9hUaSlkAw44WjT+pu/c4XQDSKTolFJnRd3F8kPqd0vuFAtlQ7?=
 =?us-ascii?Q?URpk4xmur8zqyk3rCz9YsmstNvPqnGgApco63ha6OSZHVQYvITsFqyP1cy3d?=
 =?us-ascii?Q?J691QKbWHMMx05SeDV5H+98wboxAl8GjhBPJaJLUiQDLa5lEhDbKYzu5ycjU?=
 =?us-ascii?Q?LTP6bkT+iVbZFV2oi72vkgPEwzk4yqOfC9zT2CyeL9rbHLC6iVmhOMwqxHN1?=
 =?us-ascii?Q?BwHEHVdAw78M561P1ZAuabtKXRYUDw7zOD0dCrIsoG1hAUrd9biwIx74+0Hz?=
 =?us-ascii?Q?gLz0QZE6UxyVfxM/i4WQMoBmAlMQp7Ruhag0WDwwFfYLtH0e6B2no3PP6Dyd?=
 =?us-ascii?Q?u4CzSyYcPQJt4h8yXJWJvXzWrm0g1+NNI1R7zIZdTsKAH6f2oGq5ekE+Idip?=
 =?us-ascii?Q?u3xL4FR2plqhPfWCoj3FrGpYXb6J7AKHT11z437WojKb6MtcUWSkL3VzsTXD?=
 =?us-ascii?Q?M6sccPWE5HJSk2udi+5kQ3taje1aPq2BeVXaLepU1NFAhyvlXjoNrJDaEkID?=
 =?us-ascii?Q?TXk7vYb+nmWcWRekIMKkeRiIuwHeEBskERculGDU8TQJeOx6uABVDl+umZLB?=
 =?us-ascii?Q?pCL9mV564z7bH++McMfyQaTOjm2jJ604cUiyfuXVy/NhGanchsvhluErlDVU?=
 =?us-ascii?Q?jsztp9gdMuvDqPmYbwHgGPXZoJJTDRQn796j9n2Lj72TqIbbIVjuKH7mWabX?=
 =?us-ascii?Q?dlc04X9ttsW9R5Z2R1yZH66k7JBQwm9+BxZNPSAZhAE0YPEuVE/QDKB4ocN1?=
 =?us-ascii?Q?7GFZ8qHsMtduqcwPB0fuXC8TKLJFK2o88K9bWfpo8nB2tmBqxPUFT6g3ELhR?=
 =?us-ascii?Q?T4Pv9epCujLkKmsVtQTlD4IvTpX8kpoPjenCha78bXQHQt9x68IxFym1tlC5?=
 =?us-ascii?Q?UEfjkW9o1y77m/7AbNQowD+Yce0gxtQlveLVK4GJW5GavC+/0EpXzwevDVGj?=
 =?us-ascii?Q?3RsvFNkve40mf7Paq2o35UA3BsLssSsOwiA8Z84oUaue6YXrjMyc7K5nu7gH?=
 =?us-ascii?Q?SOD+vLLeAYMXDeEl2IxNF4PqAvoDK+NCGAQlDOTuhi7NyT9ivBbBnjuQpcfH?=
 =?us-ascii?Q?EY43F2jj3uv1usmTZo6MPalAiIYGOlrdXe7xssHqeAKcYmOWXnA4KEW7Ju2e?=
 =?us-ascii?Q?Rq1+e/aKksbFBM4zjzUE6YyvVt48OiDEzBqmEjj1PppqPHaJNgrnseJEuFAw?=
 =?us-ascii?Q?U2os0oD+2S8usxMbTxGctvy4E3/8LavmNDfCBmXXcXf+ulQ87ka5Ya0B94RD?=
 =?us-ascii?Q?WcfE3jp3WpIetPpIsJZhvlbjZQ5qBR9O+0D9wTnv51zRq8UG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fba5818-f4bf-48c3-c2ac-08df14528293
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z25m88LDE6cvtzpTywBDqTR6LobB3nJr/ORzB7/Q7E5O5DvSM1JK7sncHK5SfJKz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

Each of these have their own unique situation, populate the tlbi right
at the top and pass it into arm_smmu_domain_inv_range(). They will
diverge further when the iommupt invalidation scheme is introduced.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 54 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 15 ++++--
 3 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7acb70d060ec4e..47eba08bd1161f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,16 +140,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
-	size_t size;
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = start,
+		/*
+		 * The mm_types defines vm_end as the first byte after the end
+		 * address, different from IOMMU subsystem using the last
+		 * address of an address range.
+		 */
+		.size = end - start,
+		.iopte_size = PAGE_SIZE,
+	};
 
-	/*
-	 * The mm_types defines vm_end as the first byte after the end address,
-	 * different from IOMMU subsystem using the last address of an address
-	 * range. So do a simple translation here by calculating size correctly.
-	 */
-	size = end - start;
-
-	arm_smmu_domain_inv_range(smmu_domain, start, size, PAGE_SIZE, false);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ac832534311f6..f7f08e6991fa7d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2799,25 +2799,13 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
 	}
 }
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf)
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
+			  struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_tlbi tlbi = {
-		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = granule,
-		.leaf_only = leaf,
-	};
 	struct arm_smmu_invs *invs;
 
-	if (!size || size == SIZE_MAX) {
-		tlbi.single.use_full_inv = true;
-		tlbi.range.use_full_inv = true;
-	} else {
-		arm_smmu_tlbi_calc_single(&tlbi);
-	}
+	if (!tlbi->single.use_full_inv)
+		arm_smmu_tlbi_calc_single(tlbi);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2836,7 +2824,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 *
 	 *  [CPU0]                        | [CPU1]
 	 *  change IOPTE on new domain:   |
-	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs()
+	 *  arm_smmu_domain_tlbi() {      | arm_smmu_install_new_domain_invs()
 	 *    smp_mb(); // ensures IOPTE  | arm_smmu_install_ste_for_dev {
 	 *              // seen by SMMU   |   dma_wmb(); // ensures invs update
 	 *    // load the updated invs    |              // before updating STE
@@ -2854,9 +2842,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 * this matches the instances used for invalidation.
 	 */
 	if (invs->has_range_inv) {
-		if (!tlbi.range.use_full_inv) {
+		if (!tlbi->range.use_full_inv) {
 			arm_smmu_tlbi_calc_range(
-				&tlbi,
+				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
 					invs->has_full_cont_ril);
 		}
@@ -2870,10 +2858,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 	}
 
 	rcu_read_unlock();
@@ -2889,12 +2877,23 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each single table level it wants to remove.
+ * size is the size of the table level and granule is the tg in bytes. This must
+ * clear the walk cache and any leaves within the range.
+ */
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = iova,
+		.size = size,
+		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+	};
 
-	arm_smmu_domain_inv_range(smmu_domain, iova, size, granule, false);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
@@ -4167,13 +4166,18 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = gather->start,
+		.size = gather->end - gather->start + 1,
+		.iopte_size = gather->pgsize,
+		.leaf_only = true,
+	};
 
 	if (!gather->pgsize)
 		return;
 
-	arm_smmu_domain_inv_range(smmu_domain, gather->start,
-				  gather->end - gather->start + 1,
-				  gather->pgsize, true);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static phys_addr_t
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 49ea829354b723..e0af6eaf62b3c4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1194,14 +1194,19 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       struct arm_smmu_cd *cd, struct iommu_domain *old);
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf);
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
+			  struct arm_smmu_domain *smmu_domain);
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 1 << smmu_domain->tgsz_lg2,
-				  false);
+	/* Prefilled for invalidate all */
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.single.use_full_inv = true,
+		.range.use_full_inv = true,
+	};
+
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0

