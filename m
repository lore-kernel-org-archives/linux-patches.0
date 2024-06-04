Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1574B2119;
	Tue,  4 Jun 2024 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460179; cv=fail; b=cVUysqoqE5O+hKTL6mY3sXA142UKSsL1yI+7vgGPgr2aSuz5qX19yIw+oLw/Earwa+V4fBP9etZ/8KkSulUVec97YPlWBiaU2m3G5ebpXx2vA4AcFNveQzfoIr+xLoVeP0UolC0wjuaMlbYFvDWjcXyjiXSbdjaeJiq8+2veq04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460179; c=relaxed/simple;
	bh=7NlPToEhLKWp4JBsg1bT72TcVIdsDrYakhiJmHuWpac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n0mmtvlWCVkCooWs9hJcnDhMsYDKRMmg+N+Bx3Igr2In+i6ExW5/8GT29HeXTi2sRMyG5t7O9AZMU2AqrfqYXgea/Lr3Z6bEu6ASqJo/ykdBwdSlsSFbV9QVAR9+CXfBCtswjjFK8dPSSbxo8EUX38i1hADe3BkRMp0yx5EG1l0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kakmpo2n; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kakmpo2n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1+yxjMwur7U+nH73TDhNIAgd56XVdn4729z9kRHVJGBAFlp/eNJkNjlM28jAzgnemH6W0aZgAmaFkjqVH+zrsm/cYZY4wCjVbTH645wkidYw9S6UNx9CggHyt0S0jw2LJ29dgW6uhyjpnvIMkHX5VAcN2u5J+WLoMt0hPHKmlpZ4TORwTgXaG8IuLCHouOWwIL1Wxtak3pO8fZAg7mTVioTXNKG8zgA2EzSLdo9GAtic0Mvn45QzowV3MktlU4aLh8ESomWwIbUmY7q8mtS9/FFdZJGLpn3CeY3RHCj1TQ7dtP0th3QpUGs0CdMRM+GR8aALGja9mudSE/5mi6IBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bSNGu6tQCzzJLAcHFS1wQqKfLhgXoSFyjeA6C5JJTg=;
 b=loomH1yF1R94fdFp8VLzL6//60mUGthc5rhLHy40h4Rf1QlRDTCF2b7fFSTiLUdA4jiiXYn+Fv8x8vIbOm5tNVo9xr8EGkuxZeqKH7+hA4+zQt1u/vEPYK6x+62GXZNj7bbeZP8gO7ts1BP9Db+GPZ492YbHkjTQj7QzWo8J7W3nR/4kjQCAD8Q/+uBSEWJi8RO4BoXc4/aQxvCJawvK9uNvfRkgNK+JargvvWn4j/106PFJwVT8kv13Pu6uGC1q7gbPjb5e6EftT4KNP0hTIdoy3tCsjj1i9ijUdsjjTMYAYjxLKr09Bs3lkluk0V+1ag1fZLO4143CE2OfgJuaTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bSNGu6tQCzzJLAcHFS1wQqKfLhgXoSFyjeA6C5JJTg=;
 b=Kakmpo2njG9rEtyz/Rubp7sJKejPnSsCjJmI8+k9kPHRzJlWEMx7PFRwv0Il9WH8bHzEpVM3uIva+spYj1x4Zb83A70MMXXVuOqpZjl5PxKexCcqLLV1RrxlRoJ7xB+jNSPd07gizlGFI8fy1bLqeU/KeWfL9Yr++5xhxBc5uZUufjimhhJSquGMlqPa+NFP12ElycJwT13uIr+6M+8ED4DHP7hn3jpGotsSoz1gpyCvRtN7envCIU5lHqop1VGxM6UVqD2u42KQgSe3jFt7T982UyCX/Y2canX9ugpdjTAm7NgqPbhLDdc0aGVjLW7RhM2K83MqDHyH98Nn6MXhBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:07 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 03/14] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Mon,  3 Jun 2024 21:15:48 -0300
Message-ID: <3-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0429.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 31a869fc-9546-4ad0-133d-08dc842b85b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ir+D3UHNv+iUk31d6pufabtrCuBz2rGcNVQ8C0xjwdwfES7LBJceU517MoNg?=
 =?us-ascii?Q?XvRbvDkp+v5G/7uvkLsEesJDLjip1NrqyokTPaJeCjLhZRYelPv6mEWRQsUY?=
 =?us-ascii?Q?HkPT2AGbT+f2t2h0FVDVqbKanSakn8Fn0KDWxQ27pB/vUjk+SJnpGunoSdoT?=
 =?us-ascii?Q?i9VX3Jp46tsVWNsppv1fgjRDCUIzwLzWJghIpJKpAM3msXR5yQWUXQq107fm?=
 =?us-ascii?Q?gtcS5PRgTaxhwLF+rHmbyQUuq7jfWMgacVhBFilSJ7PKahiMz0TwtdTdjysu?=
 =?us-ascii?Q?vSmsRrKoYhGjYIDKYGQ3FTXGuV9QDOOzG8SCtdv+FdC9vLm64JvP+faF4LL5?=
 =?us-ascii?Q?LlBZVR17jc/ZIpRqiyWhnMHbGs3IbsFwNzf9vUkKEz/RSsYd0D10rTUWyCR4?=
 =?us-ascii?Q?jY6nMIJb0frWXDclAfEONZsWPjZiir8uAykTbmVRxeKm8wmqAPKlp5pBrCkV?=
 =?us-ascii?Q?9chgLhI++AOtlhmVDQywFTdk7vyjy2yYsEh2eVDiKd/KnQNDDLzYqkdgm8Pk?=
 =?us-ascii?Q?JWB8UAZNZBgwKj8yxsaL6jIni72caiFc6vEMlKQngux3++orLkcT3AfIiH1n?=
 =?us-ascii?Q?vAUcdAJ589n1EUfFHvkQ9GvGebkEIDtzLzBou2VCGSbwgH42mdWxQmYyd9fI?=
 =?us-ascii?Q?jXl15Qu9pH5/9aVL8dhVvzce4AwQ6vbxZ7MNALalBctJJ+FAo8852ByDXFpR?=
 =?us-ascii?Q?QKynJno6SV8P6ZVhFoJ26r0vFKVGsxuLFx+1BdNOrAP3tjCcuYZBtG1qgECs?=
 =?us-ascii?Q?MQv2BO6ihf9ialHixTxJiI18k0gJICG3L0DWWDMGhjzkTSubGNUwWlTnqo8h?=
 =?us-ascii?Q?bhBbph3mfRPLAAggk276qfmU8JIGXcY9g5KzNBRQw0KCvqvYjEeOJQ9fjjmN?=
 =?us-ascii?Q?LuZw2WxaCTvbVITNv/poFKpWkcixGFIh/uHkPFYB47WWiUpwn28zRjMIpRWS?=
 =?us-ascii?Q?sAk9saQrQDqI3QfKy42iEgmL0yYLVNNwj71llxMVKujg178k1qwKxe+OxdIj?=
 =?us-ascii?Q?chd0ROv3J2SB54uzxhAKdX9CdGhJe6tiGRlR4tfJ/i1Gdo7LMd2rr8+/7wt0?=
 =?us-ascii?Q?3c2GamSWEoAU8ZvulT1HYFiuoHNrtbj9YsnUta375eF7UeQOc13SDcZARRzb?=
 =?us-ascii?Q?HFe45krf9LHiOIp1PF3LTWMP4FhbPeh+MRImBZ9efgvpwcUJeT8LdzMh0kGf?=
 =?us-ascii?Q?M++QiVCjJCZIQxTXAc8RwBgZBDh15j+wJkXz388qrP9agS/dQwiXiwkxaJ1+?=
 =?us-ascii?Q?IZX/pEp0bExfDcCvlHUfhovcmb0U/tvR2goRXS9Dgw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uoDPsxXReYF2gZgejRQrpdE5ckTVqM9KRqPd/N6ATv4kb3WKHG0sHlQGAt2n?=
 =?us-ascii?Q?5UFjjFHjKp+SlCkxWgtLC/X2/LhGamf9T5L4hD/u8exfGxEZZoQIqytNk9/n?=
 =?us-ascii?Q?Xmp8aezy7hAQmWsfBpzR81CsfcYCUVDKYYKi46qXMuNBY85EQj2cXXoVyeeE?=
 =?us-ascii?Q?ImSVUvsRHxo5xG9YXTSG1XVDK37RSshlZ/rneG6UFOLHghR5rmhLsc4qhqzP?=
 =?us-ascii?Q?FcTwwBPG8/W85mdrtxlXlF/APpF+OgHeF51C33cfkw5a+4ROxoBs8v5IVpW1?=
 =?us-ascii?Q?VrW5IMCy7lXMw/Hrl07zbqUFcPZ/wa7GfLIDZxAwR8+NSsU8VaPB5VFNXach?=
 =?us-ascii?Q?sTSri8RnoPf14wpLfLiLKBFPOsjG6a8D5ANhp9/eb6YXSTVmLyVsTRi9KZqI?=
 =?us-ascii?Q?9NTuNrWFaeCLg0FHvGj338q9aofUbQOsTEmzfYKvK6uvEscnOGlGfWPABz3L?=
 =?us-ascii?Q?rC9KCEINT7xIAQZ02VYsHDQT18/HfERGRl/DUEsQ1oaFLhlEeJ1s9g60d65B?=
 =?us-ascii?Q?n7H3Zv2B9X4GxlHYdXy/yryk2pHuduKxGp6xvmvskNuYSP7Q450WpOgl7KxD?=
 =?us-ascii?Q?zDAHCpUv7LAqkIS+nHIsFpBcEHDuwHRmly/wqSdyqalyiPbR1lA14EQJHVs8?=
 =?us-ascii?Q?tMnPgrqcjrFHzcTwCB3qgfm+nlGy8V9Ey0rw61LgiuZXW+y5+zu6VzkZYo4i?=
 =?us-ascii?Q?V4o06tVWc2fktXZm/rqppA2uMljOJ4oJ9GOt2LnmAyF4eWfHjeuGpky6N+Uv?=
 =?us-ascii?Q?e6QV5lmqQKco1ONis25KxJh5P2CIBv8YU5k6yFm+sPVhoN0m5slIQt60mmfX?=
 =?us-ascii?Q?5Wicu7HBd6Le7mmHHS5BUMgesj3T5JSQKSKW+B0Od0N3BwIR3jvb4N5Dsx1/?=
 =?us-ascii?Q?4DG/njibBCVUYpmCrU1Z+3PG74UpONUh7EzwBAIR93U39xRj8K5A+InofYOs?=
 =?us-ascii?Q?lC51fMxqCjFKuoBKUSKI3nT8QVm3bcwNzl5OS3kZbD0u4r495jeXVbr9djUf?=
 =?us-ascii?Q?LLyJ51D9bp4bb92UxK1rOaALaN+JeLH2MvOSE9226q2BH9WMLSxCsxEqR2MI?=
 =?us-ascii?Q?b8312TPYf9YbyJ2AfuluiiY7D9AdVOu/6+w/q7EgcthrqM3YyOHmW33USxCL?=
 =?us-ascii?Q?AgU7rCRGjuEdCLv+H4osc6JUl0TZTyALAu7w+tfx1ibBgEdeWvd90/nNOfYr?=
 =?us-ascii?Q?uqndmnXAMhLC32kF1F4tj2ipxCtHY1seAjbTNrPsMheqzO31h138wwo4oMyb?=
 =?us-ascii?Q?y9wNBX1ieLALWUn93C/gCUj5LEiCpLZGphHrftHb698gHpTB3vL95KnLWQTv?=
 =?us-ascii?Q?DADzvlOX01qvj8iRRfiurwQ3ZogwEpvIyupW3uXJGltXgZCoBm8ZEnHZ5iP3?=
 =?us-ascii?Q?gNcfMpKDWX8fA7ikcBOz7QHPwL/Y6EvuT5G5D5OUlHI7NGn8cP7c/czk2dBU?=
 =?us-ascii?Q?m3HDO7wg8sPr4F1DIVPAXGBOhBkdhSCyZ0cgIK0jiaiNtIg5vqQcacJEnku2?=
 =?us-ascii?Q?sgP6Yasb+MECn0PRkzer44vVot5kmdIkyiCU0zQlKQl876mju5GVlBHdSORq?=
 =?us-ascii?Q?JmbtompfIs4j+/WpKrc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a869fc-9546-4ad0-133d-08dc842b85b5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:04.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7Fjtomy25QGsiFuKGrYkqLC65wtNriGzWPkKVXKDQwsb4DqeqyeloEagkKlkZaB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 71ca87c2c5c3b6..cb3a0e4143c84a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -38,12 +38,13 @@ static DEFINE_MUTEX(sva_lock);
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
 		/* S1 domains only support RID attachment right now */
@@ -301,7 +302,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -315,7 +316,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * but disable translation.
 	 */
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3f19436fe86a37..532fe17f28bfe5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2015,10 +2015,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size)
 {
+	struct arm_smmu_master_domain *master_domain;
 	int i;
 	unsigned long flags;
 	struct arm_smmu_cmdq_ent cmd;
-	struct arm_smmu_master *master;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
@@ -2046,7 +2046,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2534,9 +2537,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
+static struct arm_smmu_master_domain *
+arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master)
+{
+	struct arm_smmu_master_domain *master_domain;
+
+	lockdep_assert_held(&smmu_domain->devices_lock);
+
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (master_domain->master == master)
+			return master_domain;
+	}
+	return NULL;
+}
+
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
@@ -2547,7 +2567,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	if (master_domain) {
+		list_del(&master_domain->devices_elm);
+		kfree(master_domain);
+	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	master->ats_enabled = false;
@@ -2561,6 +2585,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2597,6 +2622,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2610,7 +2640,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2925,7 +2955,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6a74d3d884fe8d..01769b5286a83a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -697,7 +697,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -731,6 +730,7 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
@@ -767,6 +767,11 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  u16 asid);
 #endif
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.45.2

