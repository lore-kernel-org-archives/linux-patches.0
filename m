Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013033.outbound.protection.outlook.com [40.93.196.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214334D91B;
	Tue,  6 Jan 2026 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727345; cv=fail; b=VkcTCyfK17r60IJ0sv33TV3UKevsquAH37X/tK6po9zIS2zPehiRrWj+/+h7i3xhBEzzoVhW75Ir8hxJ01nSTT2fmTinde3TfAcevHmKAe3S7QyF7ZpVQjCq91ldTi6Uo7FCTwSkgdjRgt/twotS+N9nZ9xHnH2x5Yu4CcQft3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727345; c=relaxed/simple;
	bh=AeOE6nDnl2yCCDILXCvd5yK7DroI7kAaErYyS7t8piw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dJieoi6nkO+Jn5SNgCe45GvtXckD/7QGOijXC9ioAcvx+wH6xYA9ferF1W1BJ9UP3g1aq1sgQSdjEYw36era/fqgPhXWdngL/86qEKOuFiIw5+Y8I403MS2uM3UbjF2ngAQWH9XBTrpaofxLPVfwYwI2A0W8gJ+TBv7RA2QzY18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pks5peI4; arc=fail smtp.client-ip=40.93.196.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pks5peI4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oXv/mUabuzsPSFHeozd9uAuH6hy6CJlKHcgKCdcAmX/9mD4rDaM1PAPnLQVUai+t/BjQcG0E8J/ulm5IdJP3wPZQ8aa7wsUWOduQUK4xvSLX3lfa7LdyuLAsgXgv/0nTTjA66P43XzEBKjfY1aANYDVNhaVkYm34poWEMInKGi13tIpg1u2P0F2u1rBuAInxWqu51vPAeEvQ9jHd4zl0mpA18C/V+aJR2dD90L3FoOHavFElnz+FebmncJCMesPXCJ3PsFFZmsB1RS9UuMQ79J8iTCNVV/HwW5hGiusrfxYYIv/YlfEMtX5nLAFCyvHNT6ACVCMB4+2Qnm5FTehDsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WbktUqC8t0Lht8l8Ib3AoVtmBZZrGFbis2W0DkjI5U=;
 b=QX68+PNWxiLdSQMMZDJtmS0DxtlS5g+rj8HF59WY42qVjx5bb05lRx2tw2VlJdpff4izrfY2OHYA1tMlETVfDG9fOgxx9jJ8g5a7i/TH/UkgMpsgHM+iW6lP62qFreLAys5WSBTBogKMMPq8IPPzbRgaTIB1GRDtFriTrZBZNubwCFaXBcbwCSahD13Osk4J6gI3cfBDxCf66z1r0XXg1RSIk3DriUTXOvCSCtIANAcWRxDDTb+BwyQzRC3Oc5XzfTcr0m64WB5zTNUw+FatDpAbWvGCaE8v3DitPgUrWtZWePqWPbNx+ge3UD+mDR0xg4UWDD43KhK847lELLd5+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WbktUqC8t0Lht8l8Ib3AoVtmBZZrGFbis2W0DkjI5U=;
 b=pks5peI4JH9iTQwlTs2eONnzlAYPV5poQ6KLaNFSN1yDEyNbt9RHoXQ8lS+gnpmWlKfgbA4w/keMYfJeHQMTm5r8Hl/QjISNnA880wP38QmI60oTUDygpvmK/PBX53d7cfoTANNl2KHlFG+8loZqLBuFgR0rwhlg+Bazy1YUhsW5ZeRyb/MqssbrhGle0mt2Jqdm7uJIB8g/u8bpTCXMUGQAiTW9s/zv+sm7CnwUFpDbRe4zYZy0ECE0HCt8S7aVBKDPOjjRtKqLqfJdTLzaAG73HfjDPjM243Y0yss/VQyi6yaiSyMc2sB8264FCKu8yu1jqsNlCLfE1nEhzuZOtA==
Received: from IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22)
 by CH3PR12MB8484.namprd12.prod.outlook.com (2603:10b6:610:158::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 19:22:21 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 19:22:15 +0000
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
Subject: [PATCH rc 3/3] iommufd/selftest: Prevent module/builtin conflicts in kconfig
Date: Tue,  6 Jan 2026 15:22:12 -0400
Message-ID: <3-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
In-Reply-To: <0-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|IA1PR12MB6209:EE_|CH3PR12MB8484:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b70786-436c-407c-1930-08de4d58e5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0WkDIa4zKhc5R5/VRW5RKhfKHzUb/S4MflwMtV3tptBen1KIn2IkTtSGyoFb?=
 =?us-ascii?Q?b/FxDsAL4HWLbD2mrlvt/s7dKiBGXlNyXiBfF917GxonJGA29yk0GcHGkTot?=
 =?us-ascii?Q?L7eOylaDNu+G29phSrUgDlhCNW512eHYJRoJsjucosixA9UvZ2e8ymcQNoZR?=
 =?us-ascii?Q?nHFSf0lP3kMtshlpAyUZMKEe8x2e75Y0QHmpKlTVqDXHsAnANbVDfvsstpjd?=
 =?us-ascii?Q?/qo/bP6qxHacULMqq76U30MmaUFgWW2S3kdiI3ljo+wXyKUEcSCSKhMn/mCc?=
 =?us-ascii?Q?yiJ0Mrdmdy+ndx0UltKqxiuWn34HWdSEHPj43bgBjwvulhvhCLpraK9akTLS?=
 =?us-ascii?Q?IIB2uKR919U+JswagD9f0pyh1wX+KueYnV0zlKmUyYTwRaoEKmqvVHY7mUpC?=
 =?us-ascii?Q?otMMJk7dLhZ18FIBmRgDqODh/JnYc0tYdJDY+NJ3YJos9WjbduzVuFRMEwmN?=
 =?us-ascii?Q?hX3ZvCUnQ/B/WTfMsKZUjEASTmFOC6Bv9bRNYHnMVGQgDIXyNNLzGpPEXPkW?=
 =?us-ascii?Q?KCOsxOIIzlbh9iq93Gc55jU1kiNaINePDEFfna6GCjLEW8m2ET8/sbXGcFDL?=
 =?us-ascii?Q?e3Yaxgp3ImnuZqFgoDVs+KvuxWSjjZBmBwu9ncRk4NUmqhVWXp+mOycla3nQ?=
 =?us-ascii?Q?een1XPCTZJxxedPX2uxqFXfQQRArs7Ksqa+nVbbWUihYVOJqA1XUTL5OOuG6?=
 =?us-ascii?Q?li+zlTexxnMSgmvfjAdDwql52xclGgCuXD2teEpNLfN6VLDzMPC3ibgfHx+i?=
 =?us-ascii?Q?z31CKdPIxzo87c2Yg3zFW7FK/mHq8GVTrwqy7SHpwV4PtTtxnoaaS6BSRE5o?=
 =?us-ascii?Q?t68g7pTNdNn0ZgEp2cdRuI/0S1eleh3G9ktkLRmmPdhXvJD2pHXMwUo7xHTn?=
 =?us-ascii?Q?6UJQPTuzK5K0W6ZB49j7KRnLnbew8yjewGZQufj0zKFgePGlOXK2YNsUu+nH?=
 =?us-ascii?Q?tnH7dmKIJN1t/4suGw20glomV2IaKwrYwETkKzUcpxIHW0FZjUzq1r0igYBA?=
 =?us-ascii?Q?9NJWM3bkH/f5R5qfMoTUe3YQDhjLJPEQ8fDSM7uq+1Lxlwv949ev55YPXnFD?=
 =?us-ascii?Q?K/auR+O1aXDS3PV8QyxYZL9DQa70ULSEJ2oKrYGy+iNC8/+MFndCkIyobDH3?=
 =?us-ascii?Q?zB2ZFMPKwDJjoGWupfJv82laWSBzeutoUqcSO1dxooWRqphtpHIASQzt6KDr?=
 =?us-ascii?Q?PB16mCqyV3KDlvlo/qD+CmYSuaTrmMSaMWaSQawBRAxvuWKc533ztUFQ4bk8?=
 =?us-ascii?Q?OiToKYqhjuIYm6uMg0anmGsIu224v4UL8wYqti2ZfQPW6Ia0E7NT3ZI3NTfu?=
 =?us-ascii?Q?9lFVtXgup/vwWh2wjq/6XbjgVunu68Dze1YGHP8VZojkgRne4sWFiYf+xzri?=
 =?us-ascii?Q?dPFaphMABbr/Wch0PIjELLALqyh4pciMz5TmWel/XyJKtu1wVIGpvBjBLlh6?=
 =?us-ascii?Q?ZhGLOFBCp52WhzWtYEn4Ybvmt8skFmZw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aJOevE/q+8J2gVFd/TzmIgvWOqT60XUC5/kXZxoqtNs68LQCZ804kAnh2trK?=
 =?us-ascii?Q?rJaRR6vJdqr0htaCNKaOTEJW0/iSIlu7l8V/AyiUR6vh+/XclKer6s2mOwuo?=
 =?us-ascii?Q?eu5XbL/cTBms5maiVww/7GzKL/71roFVLppmkDi1nFgOycTGA9w9WUhhdr4v?=
 =?us-ascii?Q?ZGpILojbuOtFfRZrB42XJ+WTqWNvUR6uDR+dHnQA7PBgXv3JG2EwxcpPb2fV?=
 =?us-ascii?Q?4dQb51Ob8FH8LF/S/wl+Les1X8D2OIAP6n5gVLg3CC3/4aptlCbKLAxcqNQe?=
 =?us-ascii?Q?XtDY6BXGzCGt8iVFzzQ8eAuUjC1QmWeE6jPt4g7xmK4RsypZNu6UiCQTECdn?=
 =?us-ascii?Q?yubumYDBwCjCb1m6RquwryS/67mfx0L9sdOjxD2CD8m2lIoy8Lg02Nr/uqgX?=
 =?us-ascii?Q?8aZZbO1rbZOoabIE7N7myFqhgXOz3AcT3iLNdRw5N55M3BYHKypS4CCkiIH5?=
 =?us-ascii?Q?zx6611efe2+2j6Fc/HDnT4nXhTkKkB+kwRJf+wWYcaKdEXsC/YLlDa6UXW//?=
 =?us-ascii?Q?hqd/FKgcuz0HMCv9FkIw8LCK9KgCpE1/6o76yGvu8g+aGcgmpfyi5SWAgenw?=
 =?us-ascii?Q?OnxiOfYjrtU4L4t5kzYw1BWLhf0D1kHO0IHCrd8/BN3x/1/YWTVjtu3j4v7A?=
 =?us-ascii?Q?63tjUvp20uoROtY2WNqBSoXGFRz2VhV2SZe1VqH1xDhaWVzRCb8gjjL5YFgr?=
 =?us-ascii?Q?UQ31Ki0yCR1gIXuGuFvDOM/m74jhUmYTVFtSRJdXCsquiETK1le62AKXPhHV?=
 =?us-ascii?Q?OBoys3gfgIcnerkxL0hfjVVxWwvoWE+wxvBWcQKe7tqk4hdB1HGznlHUopfo?=
 =?us-ascii?Q?xIQV8G1pumrzIuebfktXseb0yozorGXhkV6u14CdwqDIICAOFj4LGFrqvAfV?=
 =?us-ascii?Q?KGs7wey1/JWjvI/PHIjlGI9/Ps375Lzrqp5JuC9GSZPUsMzFMiZO+shA9+lm?=
 =?us-ascii?Q?M1CcuMlTQmiJxgpvYsh68ugz4+p1QZDjKYFIr25QQcpSDbqR+uV9X2MxgAL+?=
 =?us-ascii?Q?QXAcOo1D6mYWzpyckkUcljtyCRZYeYTWq9LtuglHg38hEK9Gvp9QpOsDGKG1?=
 =?us-ascii?Q?HoXwxxaUa8uA+AWPrkHYP7EwHTcec2zoEgVPOlrknQXEtVw0XVnUfmLwFlFX?=
 =?us-ascii?Q?0kybzR3C5//D1UN7zdyrAnYT1of6o+5/A/ib4U7LQh3Cr9uLdHNdo9ARJD8X?=
 =?us-ascii?Q?IisnrQ/VPRN+aPmfuPrKyuuNv5jshxy8Ofjn+wic3lhTlsNEKR9TBPhqAUZ1?=
 =?us-ascii?Q?JdQrTDerzVRbuNso3Avx+VRqePH7FG1KxDb/McafYxOWAf/J6CeAZZe8WkID?=
 =?us-ascii?Q?4nnetEcxPuVQ80Tq6acYSSXcG4NxcAn/bMIKZll2lvTTSa/cBQOyhmOTssA6?=
 =?us-ascii?Q?dR06Qq6AVkYu7++O3n2j43nKxeempMvXHttLmX3l6//Pj5OKgjAfF/iq2NN7?=
 =?us-ascii?Q?60TTOMvb5Y34Z+fEP2yrbBJnbjq6+O/MnScnMW101lzhjuLq6QAaXoThXyGE?=
 =?us-ascii?Q?ZcY8vpR3w45DsOH+hI1qJKe/BnnYAgm0Svc1VU7/bZjuw3l6JfbbIC3RP9fm?=
 =?us-ascii?Q?pJSGSVx7lWuyPinpLjVZ5j0ziqMHkm/VLWuyf0PmiFE7s2Xt7p7//FQPDQFd?=
 =?us-ascii?Q?0n60+te3bw4W1uMG/zNuFebvpsX2a/jxajm6T/VgMxP8civfco9Ft4Ho2wCk?=
 =?us-ascii?Q?xHrIaIMMlgKyQtm8YSm//UGvziEjfZxPaCRYfTI/lg+l11VKn4E+eOlV6tOo?=
 =?us-ascii?Q?3+enD83Hdg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b70786-436c-407c-1930-08de4d58e5d3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 19:22:14.3204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMnCoxq81vMsm178RYpUWXMxFkrjUGn9e2RDWOMI3TPMpq1FRgUagDNGMXmnDiui
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8484

The selftest now depends on the AMDv1 page table, however the selftest
kconfig itself is just an sub-option of the main IOMMUFD module kconfig.

This means it cannot be modular and so kconfig allowed a modular
IOMMU_PT_AMDV1 with a built in IOMMUFD. This causes link failures:

   ld: vmlinux.o: in function `mock_domain_alloc_pgtable.isra.0':
   selftest.c:(.text+0x12e8ad3): undefined reference to `pt_iommu_amdv1_init'
   ld: vmlinux.o: in function `BSWAP_SHUFB_CTL':
   sha1-avx2-asm.o:(.rodata+0xaa36a8): undefined reference to `pt_iommu_amdv1_read_and_clear_dirty'
   ld: sha1-avx2-asm.o:(.rodata+0xaa36f0): undefined reference to `pt_iommu_amdv1_map_pages'
   ld: sha1-avx2-asm.o:(.rodata+0xaa36f8): undefined reference to `pt_iommu_amdv1_unmap_pages'
   ld: sha1-avx2-asm.o:(.rodata+0xaa3720): undefined reference to `pt_iommu_amdv1_iova_to_phys'

Adjust the kconfig to disable IOMMUFD_TEST if IOMMU_PT_AMDV1 is incompatible.

Fixes: e93d5945ed5b ("iommufd: Change the selftest to use iommupt instead of xarray")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512210135.freQWpxa-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Arnd, I think the above kbuild report is matching what you were reporting, I
was able to test this with those instructions.

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 7e41e3ccea7587..455bac0351f289 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -41,7 +41,7 @@ config IOMMUFD_TEST
 	depends on DEBUG_KERNEL
 	depends on FAULT_INJECTION
 	depends on RUNTIME_TESTING_MENU
-	depends on IOMMU_PT_AMDV1
+	depends on IOMMU_PT_AMDV1=y || IOMMUFD=IOMMU_PT_AMDV1
 	select DMA_SHARED_BUFFER
 	select IOMMUFD_DRIVER
 	default n
-- 
2.43.0

