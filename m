Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D42634D919;
	Tue,  6 Jan 2026 19:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727342; cv=fail; b=AoVZMV3sfM5LLh2fEg562Jyv4tgKkX6xUYIhIht1VRtHIrAA7TqaJE8LZGWGdAZd6vJ9jvgGqzC65BxrXgAc8yMlrdYMr7BdnPrFJvotJw2uzrpOu3yoVmAY8MOcNbC7jEcVM0mYWWHddjhbU/KUQRJB/nkX+9tlg6DWzzPAXw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727342; c=relaxed/simple;
	bh=DzcnuWlmBe3VRMGCbAwZqa28gZjFRdES8zJDF7XDdDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zy1kwOYFqQXB3cKAsx8VLp59rcIgZs68bH6DjVHxND8yRrRe0PXd8/uoMGk7RZiLyTcEr78IUgK5PTfk7bI61ka05ogvEAjLjGCtD5os+YEYW7iu0xyukkEEWKPRmr/H4oEfREStQ6hcIFiGzN6ponxiIbeBNGmw3LhuMhE3g90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N/R9w7T3; arc=fail smtp.client-ip=40.93.196.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N/R9w7T3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lxnaTdvlMMYJ/Rvpcl96bOmw+HJJNIY4eTOyI8WxrWHNB0GgB10oH93kETmadFVwopX0EBwD5kxqBXu789m9S3xF74U49l4re/5nee4rFR418i4ef7UV2tW+27OZ2Cd8z7TzX7Xfsd9PR6T2jV79flH7IBVQURvDEIirGBFTZRCISyD2n9TRKqjEcvrGLm6Yt9NKqf7JrrwM4g43HK1k5daL9AEWJVmIaLKA0WbUKN0UR48IQdpRN+SI4Dkutx/7SxN63YbDdt2bSh+smAnMVIYaTd1wFfz4XroP1qxjaVHpznGW3KfuKdR4lL0iXSz0kWrwgIIDRItwfXYivfqx1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/eTA0qDo76UAOSDoHDG7v05KFuZL4uosksQOttOnJE=;
 b=gEEMLSupRD8XM856Wck/e3LwK/doOOvHRfPZ/Os5UNZPC/T7Jxf3ec7NmtVI1PlRqXIuQQKkooGebLIyZgyzV1MuFB44Y08Ebww0dURzD51y/Np1Wl1b8C75zcWC9Ovk8tnaWiYEHM+HGuYyYhGK1rU9ILjKE6F0l2zvMUux4z/Hk3E4shsOi2UrdQffXrdkMUTerViOll749Yhkf2ic0sZqHVinGooJdlnahvKeyxmd5Kult+6VZiZgxAh6Hxr1AmNbwOFadEdlIMT2B9tGHXgqySjInIaxs/CwjyjfQfJJNBA7alj6ozRM0ml2KjrQqPAyIFtBvGwCZprtPlooiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/eTA0qDo76UAOSDoHDG7v05KFuZL4uosksQOttOnJE=;
 b=N/R9w7T346zsZtW4/CgImCg1gCHT7cWjWEfoO8xLYU3cto/h6HsF71J7MBfwbO7aDVME8v/r3SHjGSuUtp01p1/Hrhtf0z+QZW+Y0Klx3ntJd4ybTT+qVsl4WvweJlUMYmtAhMeMGWFWKnzC31EaHSsoi2a7L14VA1R/IWjDz8YzGd5Iixi34ckwD5Bu6k/zDsiXs6N97nz+fEgF3zxqAiGCs+ScOl6KsYYPilkN9EcKSM4o1bC2xagaNV1OezIfXHhNRIi9tKgn0HBiiZcfreVdZlfcjJ47A/r7fMwKxsbjsbWjb+39zESX9Z2qVH7+YzRzdUZ/bimBUCNhM1PHuw==
Received: from IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22)
 by DM4PR12MB5987.namprd12.prod.outlook.com (2603:10b6:8:6a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:15 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 19:22:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH rc 1/3] iommupt: Fix the kunit building
Date: Tue,  6 Jan 2026 15:22:10 -0400
Message-ID: <1-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
In-Reply-To: <0-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|IA1PR12MB6209:EE_|DM4PR12MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8c8e53-cdb6-42db-29b3-08de4d58e541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6mDEaO8FimF2OT2OR5g+nruMYsnpn3IylxBZK4cWGAN7Kj3aZ3+bu6//NIXW?=
 =?us-ascii?Q?5+8YY3PeciZoMcikkBoYFv9/69LSnZbNcuU6bYnOMAdYQbAxsJjR9YqflJ38?=
 =?us-ascii?Q?iKzzRItMi7ZTObuC9KsE8GUcwTbUaFOz36IU/eVCE5ZrxQ+iqFsREFGzcwF2?=
 =?us-ascii?Q?GA57F/7avr2qUZpMmjpLUMmA6lHfgXLXJ866PnzHQ6ljzExHTDbbKohXmHc9?=
 =?us-ascii?Q?9tUm/LMlAgjBggwqXSoyQ3z4M96FMVIpqxS2l039/IaJPrbSe2m/7OK1QtQq?=
 =?us-ascii?Q?YPB4/wKSofnOpdhlheX85rCNqlhZZDjPRKvzKqDxm3gTEHvaobYsUgKds6pL?=
 =?us-ascii?Q?Q+HAb/riZzgN3yIPwj7+EM1hrCji8yNnn2pBEYHTmv+L1r8u8Jtm20v+3zI/?=
 =?us-ascii?Q?SspqGwYfriu1hup9Ih+m21c1PTywg57L3yu9Nl3vL9qXlq0g/OqPU8RI1+I2?=
 =?us-ascii?Q?B727Ml9jClhzIvo5pkkU3P98UZwF/brLXfeVQJaFh/pXSL4FMXO8n+pRBQVW?=
 =?us-ascii?Q?Y01KkCXBoieUAT5mjkKfCEMdv/YhO87e/S9ZBykc93TBziy56E1FeI1A9rQ9?=
 =?us-ascii?Q?CaImA/kfKt1rmZviYTd+xkag2Z+x5wVV4MWf6OH9EuyGy9MLSOsus7LzOtvy?=
 =?us-ascii?Q?CiUwdeWU9mDNDHYC1wrDyX6xoXISEatyEtwBxDJRPOGURm6KUqogk3sRQLK4?=
 =?us-ascii?Q?746JcoyqBqdQtTQPz1jFGFyyL8fi3it6u4WE1ZlNrV+GbtWAKpOqW9j0k/eu?=
 =?us-ascii?Q?9v50VUhZ3xS8bkfFRgRxnjLfhapZ2o9WazGUkG6zuAUzct7kGNAjZj5gtRsM?=
 =?us-ascii?Q?W9mNKT/8s+uEFb8h8c3tJXO7lIOjCy/X5C/21/ybMOgTj5/BpVbfSwm+4Z2S?=
 =?us-ascii?Q?W+5ysJK/665V/hHRziJAiJwTHHY7kfyOv8dkX+ivRZMUVnylo32gL1hwJ6i6?=
 =?us-ascii?Q?/V5ZYZ8D8ZLVtncXE8sJmO81gyB3g9b4/Z+Yb/evkGQG2YEytDuH0ICC23tV?=
 =?us-ascii?Q?ttZBXMotsC53lT8Q70ztAkqv+8+y2/iAQ2HAHFXRUtV7jcbf1ymk94RU60gr?=
 =?us-ascii?Q?DlF0VVbCdvhudpOtJxYmGgkzDYxrnT7ccQLttaK67gzpmrNjt71apQeVSH3t?=
 =?us-ascii?Q?ix+hRdSAsByEmHzVEPcfR9B8nzQrYN4ByzqxFPGl3hzbZ70s/InF6NTc6HSX?=
 =?us-ascii?Q?yJQ6PTvmGe3Q1E37tRhXmWQSlBpX48WWIPU1VMLS3h3AVkX3zDh5FQZoH9g/?=
 =?us-ascii?Q?DQ+qOklzOWATjeRY0xao9JksN3yvXjXCYTQ/OulO1Tv9kqQMTpqxPm368CQC?=
 =?us-ascii?Q?0+e2IwRkHTIAytpV145DNEDfPkmKh8GBjtLi2Z6H51Gcz9trmN/GC0iM91Ik?=
 =?us-ascii?Q?fW0RK6hri25C98DFGTXGMT1jcmapmkB1kZtyXDo0QQ59e87Df18FIZkoAAAA?=
 =?us-ascii?Q?KhCC22liNGS0rX+HVgjPMshrFe4WJaxt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ODGckDJ/JL21iN9gViq41EOQLpk0HveMZpe0ZUkgKUaslaw32h4alI1TttmR?=
 =?us-ascii?Q?y2nTxtbN7j6IFyfeghCdP3OOX6LKalZkLguOI+NQWK0G3yACoQKNlIX6oVRG?=
 =?us-ascii?Q?Dga5YcLlgFuXhpju/26+h91dHklRDR6Yc+BvSoSEH3TFHrOEIjIx0mF5pt9y?=
 =?us-ascii?Q?nLBWBrf6tYkEOtWWHTpLnkbYkvEIe2Kq5XGpuZc9YOdAV58nG887+Lre2rzA?=
 =?us-ascii?Q?VTNluivG9BkCNtyBvi/wWNQJoGt/MqDiqnKbqVjcxj4BUcCZuf1uvgym6zBW?=
 =?us-ascii?Q?pPMWSxJfWvsCscZ2osNw0eR+8OOixQB6ND5YvVf0UoPgtkUG1pA0OGAh7MOM?=
 =?us-ascii?Q?Jusffs6MY1RAk97GoFiJCil6KNDfxP/uRLdnUsHqtBmguo2SP6+mjl1kUHVN?=
 =?us-ascii?Q?LEj3qljGItSGRedPas86juptqUK5bturnrZdhyaALOlYgWAJtPu/nXWwYNR6?=
 =?us-ascii?Q?RauLjHvkNCXys4BLrPdlkw7D+Nh/0RCfc+aUAmlDAo6uqUIiSXfOn4/pZeBR?=
 =?us-ascii?Q?aik/Q7uv6LZa/jtEY0p94Iu2QP4iuYss3KXvIO6SjjFOVyeGwxk+FNmmzwgV?=
 =?us-ascii?Q?Ak49PoaG0K0JaFVYHdIQB8W6/EFiGallxfzal3jhLsS0KGdvyDpdofjjXfiK?=
 =?us-ascii?Q?sQncHs7J/s8Mpz7sM5bmxS8gSCdw2GCN3FcNZxVWPWh+lj+fvPjom3AVYQgi?=
 =?us-ascii?Q?nP3H1Fyz4REOrg8IKUimUaswCcN8A2+Q6X/jLs0/bxhr0nmIf6FEwR+66lOD?=
 =?us-ascii?Q?QP5GTWPUt0K3mPU5Pwo2FjfJ6My5f0pNwJv9DtDcLe5677JBCxTHOx8fdpMA?=
 =?us-ascii?Q?p74/7v67/vO9crN6l+jltWq4nsPLvp42cVXS6ZmsbwFLngO3JkAR4dljNbG7?=
 =?us-ascii?Q?ZDsCX+A8Z2iolwy4jXDX88aaMGHkZqbT+W1AfysBG43bJnQKJOlcKgde6gao?=
 =?us-ascii?Q?NE2TLp8qlmeQgGryQqcpPO8APlOmMExt8gk7WVWppb2jOC8RAHlyMfABwpS9?=
 =?us-ascii?Q?GbhdHqVCPSpC7DUuK+Q37iFmm9A0Euak60Jk/mRb2Lnu5ZTLa13TiWLcHSbn?=
 =?us-ascii?Q?Prm2VNM5jxtolXXl8v0wlYIDdM+lng08LjyqEWJvkGHaTfi1BZkCLWReMS9N?=
 =?us-ascii?Q?k5Q2bOeP4DGyTJBxSt2XJvnsCRS8Ofvzx+Fcr8Aom0JE0sygD35PBmHkhcb1?=
 =?us-ascii?Q?pavEZTTQ2kTTyx9P0IF3ISprmffSk0RqZ0tpoa3xB726C33UsDNNbWAOfG8L?=
 =?us-ascii?Q?xQx/cRFwfR3dvwvTMfJeL9pXAbSu9KsVv0tFvBzeL14GFd4wEIsyfbiEchIu?=
 =?us-ascii?Q?uOjjS+8rShdsJjKP/BpdQD5zvL3M9AzZvP0sDOdFb55gkeAQcXUnWdyKtq15?=
 =?us-ascii?Q?TLSW3XQRKcv/qFqv+KLfZL+KwQa5dVPKra3Goz/+usNGHUUAdvqCTPQ8PdwK?=
 =?us-ascii?Q?vQn22eg0iWe9zkbXulRPFylB26G7NMWgGeoVdigfDJUMovKFQsgD4q1w5jPG?=
 =?us-ascii?Q?ekWOsSVhdklXy4+QRWUMlDIhp8DvNgviffa3FlAJf4yM9GVduLt0qjuaUz/h?=
 =?us-ascii?Q?6paXjNaWWX+YOc0r0Jp8+xV3iA8XOSQwHXsfaNszJ6ajUU4xOsg/dKujotmL?=
 =?us-ascii?Q?Axm+rGU180/v/44p/68MuUAQuILRelAlF0GhXEoYU8Amib72ofD7cL+RimoJ?=
 =?us-ascii?Q?AlwVbe+EA/39ixQREOjNejYsO2D0ZWnHclP7KfuBrujMBFS8Pp4b3wcFWdWU?=
 =?us-ascii?Q?+DAaqmh00Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8c8e53-cdb6-42db-29b3-08de4d58e541
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 19:22:13.6439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/25tGEpdRvbzrQo00p/pQVMNhJR+V2CObbjJHRk5HOnPBQNe2OsS4E6aYXI/2wG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5987

The kunit doesn't work since the below commit made GENERIC_PT
unselectable:

 $ make ARCH=x86_64 O=build_kunit_x86_64 olddefconfig
 ERROR:root:Not all Kconfig options selected in kunitconfig were in the generated .config.
 This is probably due to unsatisfied dependencies.
 Missing: CONFIG_DEBUG_GENERIC_PT=y, CONFIG_IOMMUFD_TEST=y,
 CONFIG_IOMMU_PT_X86_64=y, CONFIG_GENERIC_PT=y, CONFIG_IOMMU_PT_AMDV1=y,
 CONFIG_IOMMU_PT_VTDSS=y, CONFIG_IOMMU_PT=y, CONFIG_IOMMU_PT_KUNIT_TEST=y

Also remove the unneeded CONFIG_IOMMUFD_TEST reference as the iommupt kunit
doesn't interact with iommufd, and it doesn't currently build for the
kunit due problems with DMA_SHARED buffer either.

Fixes: 01569c216dde ("genpt: Make GENERIC_PT invisible")
Fixes: 1dd4187f53c3 ("iommupt: Add a kunit test for Generic Page Table")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 52ac9e661ffd2b..a78b295f264d23 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -1,4 +1,5 @@
 CONFIG_KUNIT=y
+CONFIG_COMPILE_TEST=y
 CONFIG_GENERIC_PT=y
 CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
@@ -11,4 +12,3 @@ CONFIG_IOMMUFD=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_FAULT_INJECTION=y
 CONFIG_RUNTIME_TESTING_MENU=y
-CONFIG_IOMMUFD_TEST=y
-- 
2.43.0

