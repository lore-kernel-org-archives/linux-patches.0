Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4224FD26A;
	Tue, 13 Oct 2026 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897218; cv=fail; b=qNybFufd+VcYyCQIrgZOvWe/Mq09DbqiI3SFQanbKK+vzy2ERAhFm/jmGaP1JQqFfpLvKcradPdGkD0S/xQi/5HVxiaBBWLTIOEH4aMIuWrwGatGCY0H1lDHgza8unor/N60dkFfNzbuHY2gMEJ8mq/7IksbX5ZQ711e2iDo7/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897218; c=relaxed/simple;
	bh=vMlCHz2j4YhUK8vY0fLKaDrQDGkJMox32QFRBlVIyLo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kkN3b8b9mOo/sXRh8WGKbEhzULv3gqvuJzAH+Dy7r1lEms0N1Cax3p4SQ+5JI35rixGqOaTvEYctn4Wwzei3GfhUUFSDfjsxdcNDN7EhqOqa6o23WtufrgJfQXvAnvJKfcB4tLSVIU6nKckiFrdnCHNhTOWxQ4tQwwFOHAKRIJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kiJ0DJvN; arc=fail smtp.client-ip=40.93.201.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kiJ0DJvN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2BAuqnDQX2PZZs0t5GVHuWOOQuvi/WnKSxakFHogNU6/6TGaiMUgaXMQVOkXU/YYXbltQ3lTvFk386NGkeCPXDUbQOFKZb+vJVNJ5wsJ/m5U2QYeyXKaI0TL3zQeYZJuLVrtTS1HNKZJa7I5P/YC2pZx+jTgYK5PJYZrQGwtq+2dN+Yqc1cfjsjcuZKk28ajFFw/B7bKSPWl/0PTK+ta8YC0U9xCiHuQbuGl9JlGY4lxmmHHg/jEILY6hYRjqRke5fG7H1abW/6Qt72YGFPS23kj7UtzP9fyugmfnBXEd/MdegVmXz/Ll3BhvjAiO8SUscZO2m3WSj+gSSToKwi6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxxmNufu1bvVEx8NPwWistpvY8pRZkfC4LT1nUJ7bkA=;
 b=nRDOntj+Nuv15W4X5ORGaIeFeR8bV41L4Oq5KcB3Q0R4wNoIz/TmlS47YWcLfp/Bbu0vcE0gfnAfWeV6bU7H+lWRHewNgvSDeAmzZGSDR1HL8HoJ+dm9cRs5SRCIsOLmsGVTnUNTrM52wErKlAq1afqMMvx9BefNrLGx6QXhCIrxHOUfvGXETXRizaOkqCSSrRCzbB/8u+RSNwi4tEs1Dkun0hgGI1TFhU6mxzGA+L2NjTnu86yQErGFXMkoH811RTw71l87rHamEeFcz53bIJEA4M/+w/DQg5ml9y8Wz8rBzm5y6FtxSPgNFQyizQyMIFnKx6igf1HbSiQ4mtYkxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxxmNufu1bvVEx8NPwWistpvY8pRZkfC4LT1nUJ7bkA=;
 b=kiJ0DJvNR/1Yi3kk3tXNK8XDFg7sze5WVcIprGiAQk3yM8giyMj58Q0FdHU1zGxloRq71K4eKB7ugG47Xf218BKDABgEju4Ik5fSN8HMAbjG3ff7+q+oO9S+IPbrO+hm9CF98ZqhEXda4iBZIrZMtafqviLO3+aG2yyH7vrIOtJA/hgyhVJucWqMd/aAIQyBpsyqYAHLXRDkjrqR5CXE/LUjt6OsZ0pUhSUtMoWyT/4BFB7jqQWwXp96XFxNc+50NGZ8QLNEuCvsKRFeQzo3bZC9K4FmTy8XYX+rIGuZ4VlUtrcP8KWp+bS+nrr9s70rP1btB1rRmZBZYs7SZMirwQ==
Received: from CY8PR12MB8195.namprd12.prod.outlook.com (2603:10b6:930:77::17)
 by CY1PR12MB9628.namprd12.prod.outlook.com (2603:10b6:930:105::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 13:13:34 +0000
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY8PR12MB8195.namprd12.prod.outlook.com
 (2603:10b6:930:77::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Tue, 13 Oct
 2026 13:13:32 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 13:13:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev
Subject: [PATCH rc] iommupt/kunit: Use if_changed_rule for the kunit
Date: Tue, 13 Oct 2026 10:13:30 -0300
Message-ID: <0-v1-fb494403c1bf+137f1-iommupt_kunit_kbuild_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:408:141::30) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CHBPR12MB731189:EE_|CY8PR12MB8195:EE_|CY1PR12MB9628:EE_
X-MS-Office365-Filtering-Correlation-Id: eacbf424-14e2-49cd-ff2e-08df292bc78f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ytihDzFwu7m//ZVlsRF5/S9fOgsCygrgPBKy3Vr+I1+Ml1vpF3hLR5zMyhW5vu+xwE61rmU7gQGxNkS5j3GcHaH6eUQb95K06a7G9T2/NTJ9FXLuqTjglFCARIfpCio1QKGtp5suuSY8GcsopJ0bQwXH4q18uKul1YTUUqaKaF4gTZCqhAlaX8NGPOf04D5EsvEYReeD8ZFphrT9S4HFAJfKt6+P0EiqXjBVc0RN6yi4XWPSc+fCcqzgDj330uSwmN430Jw2jjxa9WenqclcCInjxmrcr670h4DB1Rfv43v5g06h+keQrLxmvBndwiDfV7DPW4AR2fx6gVGDEldKjvVSSv0aRJwsO786Z16tZyOobZPl37myPet5o2fDM95V91V+2FmnxfBkZB8eAWFGhBQX/zCO3wzavAK0h5A0XMdhQEs9I7uF49sUVssmK3GIIUm3yMJea0AAEMMQ6LczSz70yq/NHJo9OytvgpYdOAvAE81Xx34p2kTzL/TBFXfsV1b7vZAdU0RJyZ1s/yNrpyo9Bs0rQPivNuv+3F2na1LnRGiF36JPpOqEfGT1A9nSc7oUuObFPLsvmkn51lIRurCgohPqGr88ATlwZsBSpGU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8195.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J2Em09mP4GxPthx2jgKGbieskaEYpIwbDcLwEebU30dxL7fmGA2VLDJ8SH5i?=
 =?us-ascii?Q?BrpyzgczD5p9/g9KwS3DvD5tdcXG+v6/hJoHYVGs2W98DO9j3xwwgt2I4oGC?=
 =?us-ascii?Q?8BaPLgth9RNtFBQEY/jQyT/mFqYJAxiKtyCC1S0TTd36UdpMzC6OLtl4JCSd?=
 =?us-ascii?Q?h3wFWyDkj6o3EzF88S6mLS5SqR/trmBtUht5KmNMKCiru0hZl6Sve/7CwZCA?=
 =?us-ascii?Q?eIdHWWM5KeWcVfUyQIz2m/R/0OQ0yxrWYoGzIZb178mdwB2Aji5e6it5S+Gx?=
 =?us-ascii?Q?jIyO8/dF2fJupsv45bwQOOw812bw9rrK1hpKBrBGFstNZT8Vfu1THhVL2eVS?=
 =?us-ascii?Q?raZQfMFmLPmsJfVVHZ5wFmZWGWkllNb2m1HE0Il7RuVqMfK2Ard+ZCz3xN0v?=
 =?us-ascii?Q?E2T8k8jh0qcPgydk2zpl7FNwlyymUWj7OrbcZ/SHZZVYr32zSMMxWOnM9unI?=
 =?us-ascii?Q?D3HBsQ7b/QghvnLYKtbXoVv4+Q3ddqIkBYu4XhdxJmI6twsRund3j1s7Eqxv?=
 =?us-ascii?Q?t4ljXC3Tj42mRM1VRZpvsJLt7w+wKxmEiiwlHjx34/4zE6pdbFUwwEOut6Km?=
 =?us-ascii?Q?AALUbBOFRlp3dO+whW55SusR5a0eBkAx5KZZBGqKj+y4yoaFrvWnjxxGcWIh?=
 =?us-ascii?Q?FfyYMMNGmSaSk7/9MH7dOyygCR11z2KK2+vaLCnvtgvwePw2WYrqlQyET4+I?=
 =?us-ascii?Q?SwhjWYUl2iF5r3vlKzdGjLmJdZFY3HweSDeRwWqbcAzKcHxXCSN06zm1aS70?=
 =?us-ascii?Q?yrHdflRqi4GDNhGFe02dXreP0wMCNlgvLGIGRfcFarGvthJQJ42IGXTTwaUV?=
 =?us-ascii?Q?BJto1IpaiSHmHKOI8mRy4RTEmknSbOMWcz9ZRm5O13AVorydKiVcaDKjCPxK?=
 =?us-ascii?Q?XiJW5mvEqOOX7sfoiUnqz/K8cZvLHl+qQo1jND/JLa9uVPdKYIlexAn64yoQ?=
 =?us-ascii?Q?4jtAz2CMumlrgkBDu/dTNFA4pEkNS91mmEIAISMsBPDKyiEaLv7JGNR8PVl4?=
 =?us-ascii?Q?YLdBWu+oyqbSVQDeAldF5YCLQvTt7slGh5ZLNPLmE802l3AuJgVs4w/laTrQ?=
 =?us-ascii?Q?eO93Cwt94ZE2yTccCQwP1JD+1zoq+XaBXa/il9O5bIxFK+ecAb9BljcKbyU2?=
 =?us-ascii?Q?4Mr6D0NTZoIFnlaytVk4zetcIfQj6wSu5CxFBjQTn8LzdzOFCZrSOyIKfSTv?=
 =?us-ascii?Q?FA1xWASaQsCiKEPgLKLKGP7WOOHxWVZWPuTBwXQ0L6xLE7/SOQu33Q3a3TUS?=
 =?us-ascii?Q?uO06DzSK0K2Xf4RTgBFpojl/rXX9FJtFWpn3VwhZdt3OAYDYjLm9TLgP2BR+?=
 =?us-ascii?Q?iHiBj2w8P8ibgybStFlwM5DOs7OrMS9BbsCc7gYpq0zbOikkK4aJFJoWAN50?=
 =?us-ascii?Q?tJ7htImPsfKtYz2bwt7b+9EFREK2WcP3553Q57mDz8aLBds5KUPkD7zDEIGr?=
 =?us-ascii?Q?5Qep3/6ZAbk13bJTc3UeYbHLg+MpBG7mRaBAbrCBYFKi634i+VRNiP+asMw1?=
 =?us-ascii?Q?ell2WorDEPWWwQ6/bz0l5DxyBJz8L4yeslREAuK4fCK0cidldbY+AP0TbDKy?=
 =?us-ascii?Q?QXy/31GBlg1OLAWB0ZspwB75GC8zcpIR7gtphoG/c6L+Er3AJZ71F4zW7rfQ?=
 =?us-ascii?Q?O4b3vPiN+wCuVSzCuBhNQNRDVdVSevsKuycaAWrL/LEiDdXzlxPHnZbMY3tX?=
 =?us-ascii?Q?Me321y+NUgqquu+pTlop8l21iXW7HPCOTRckrYrOLS2KAA8E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacbf424-14e2-49cd-ff2e-08df292bc78f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 13:13:31.9211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAvYT9lK+Ugke32U4IV2x37c8oUcA52UvdljopTZ2rIyUxryWWCxUNavdN1rYI/4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9628

Use if_changed_rule so rule_cc_o_c runs cmd_save_c_flags for the kunit
objects. Without the saved flags CONFIG_LTO_CLANG_THIN_DIST runs the
ThinLTO backend with no --target and generates x86_64 code from arm64
bitcode.

Fixes: 1dd4187f53c3 ("iommupt: Add a kunit test for Generic Page Table")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610110841.120JzAJG-lkp@intel.com/
Assisted-by: LLM
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index ea024d582594ee..e308760d02b7db 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -25,6 +25,6 @@ $(eval $(foreach fmt,$(iommu_pt_fmt-m),$(call create_format,$(fmt),m)))
 # with -DGENERIC_PT_KUNIT
 $(obj)/kunit_iommu_%.o: $(src)/iommu_%.c FORCE
 	$(call rule_mkdir)
-	$(call if_changed_dep,cc_o_c)
+	$(call if_changed_rule,cc_o_c)
 
 obj-$(CONFIG_IOMMU_PT_KUNIT_TEST) += $(IOMMU_PT_KUNIT_TEST)

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

