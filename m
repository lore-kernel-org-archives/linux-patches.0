Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223C812FB18;
	Mon, 26 Feb 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967270; cv=fail; b=jgvRt3XWrKAX4Ly5X3+I4VqkJPT7yjodQcsyPZpqebE9oiaW7uqplWkAj6aBkjSV0uhV4582tIGWptVm1Mx2M69bGhcgkJqKATVu8+kfbzEuaGvjF7q8tDrvruqClZieEtvZ2InB5vG+sAv41qzBOncTzknDke0b/Vn47QokYPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967270; c=relaxed/simple;
	bh=NNCOl/wseY/UdIhRQ2fz1rSUa/znUAcgqeEzPTgVI8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n/q3Jitc0yFfiz7SAKsUp1gRNPEicM93260OcNGUZQhcZakIEqRdI2JY2vp4RoNTqq6tFf9Ral4FclmarB7iOw07t5CcRM6huWc6OvIyPK2iektPtwWv7wNj3n8h8ZyaoTEFr4CmAxMC8ubnavRJGeouKxmcVqu6ZbpcnhHf/cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J1A5cWx/; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J1A5cWx/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rw28FjVxULC20x2h4wO/E3GNWkUMX05M9kTZt/UUmdEgZuthXXtcIF9IqX4h/EOrCwFCcvwu+LX2R3sY/ykR2etMoXcgVnqwOEH36Bi9MUFV59Irdc8JMiEK1xFbs3R55p9UTTH6UFawXiKft+pA65ezqCDtfNb1IYsceeMK6dS44NggliJ01smfuRtOMRA/4NZA6hvglQyM/mVIAqF1HBtVA8QfO028h1dtfXQL6ZgIteJvvqerSOriWWFHJfe0dPx1LvCl35k50gyFydEoi7Hy3+c8fJHIKkxyvBF9Eh4mDaqjOd6mNOpluEwTeNjp56YnMfAk1gD75iMHVEEG2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bsm4AyVj6JAv4irvxq8zb1l2uVRXCJk8t63xPJB2GM=;
 b=EGbLGuqVlA3zXF3jlgHH+M/oZaBoyH1KXHXRTcgtywFu96/45j0f/hNT3h8lnfuqfxRDa0peSUa2kOpeh4/rlZ1U72NKb0rZeeb0iAR1A+45vBqclbbJ6/FOEMLB2+x08LmrQf6E2Siyg6LjFGdKaGgrcIHuRu95oB67HaD1sBb6mJbhEGOujR5D+hE8+PXWR/ivDWPXU2IMzW1/ywRqIo9curjgQPVWZzfsMl8Kg9EojtEpsp/J7nGjpxUw+m8UzoyJSy1xK06dE1hk0iI33KxOjAsEUd9oy8LVenTNTVwK6f07Zfgf/8ZLErjM5OU5p7K4PisM6tuxYxoLnXWY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bsm4AyVj6JAv4irvxq8zb1l2uVRXCJk8t63xPJB2GM=;
 b=J1A5cWx/mHF6xbQdgLAmt3YhuL3gItyFyTowMGvvWAV3/9l5AzUxmSvqL8iBr8WQWNg8bapcxGi6k82e+Wvjuh+9BgMu55m4MJuMFmH+YbUIfKaU6TDxbjcFAXQnMWINweL3y8poF0yKXPVCBUqbc1wnxxcePEghzLglaxaEbouqdvwB/ES4LCpNcDeJ/UW2R6oAOPwuidrVtDGYEYbwIwLR18aTtTIwjJeYtmcF+EOkbsXehqbtBVZe7ES1s/q+kryBM3Iy5uLhcSK5SoPAcAbM8N2v/GUqSs/cCYtMtcXtc+fCMpIf5splgI1HT/McnGns84BqrBdj0xwDI8MA/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:36 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:36 +0000
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
Subject: [PATCH v6 14/16] iommu/arm-smmu-v3: Use the identity/blocked domain during release
Date: Mon, 26 Feb 2024 13:07:25 -0400
Message-ID: <14-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:208:234::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 440554e3-6684-492b-050d-08dc36ed6b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	R56mmCAsDp/lDa+JLaQUJ+ivTsdDuOxLUgp1QnumNJzp5G1HOG7mtVOLp/cUSlBoynbI/ITkg08Jrv478CTBf8ztah1Uzh0UNpfjmXIbtSF8bYyUS0vHUukkdJ1416WAk5bt9+6ZqHHcwOKjj8C+eJiuPx/d36tPqVuK1uVxlrNcTk3wS+ebGWstUOcKrrB5hJH0GeOYva86iaQwiKrrqoaEFVnTVaQGXx8DOfrtaqYzgFNx6k5oQ7J55tWP/4fE+CixvBL+appzE1cryrnL7b6u9wVtR1w6XDj217F9k+Mpa2ESRn5ivo0Dhrf/+s8uTfD1q6MMNFtvypNHN29lCWnB2lH+NIyb7rTOmabrdwpUw+0ukEEXvSj7GbrHaPwG+jscBnwQ34XwyXMfYlv1cpNfHBtHMgPCNiXEdCO05bDMjRc6bfMzeVM/8lIekTaW2Fq8rDk1dg169ftTTz5h/lHsJS7A7pMugyHpmECP/SdaBSbGLhu1uGhwGBUGwJEhENa0PmeyiMBjmaFwpYJN6wpwFECER0sypSEO8AVXW9r4PHDI1Tvmf2LtZGoYD86leSz5Cy1AtCivrHCihgnr2hv6Wd3tVoJTRxEI637h4bHmLy4EN/2xki9PcKhfll0Q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zW0GhHDUQ/N+iZSh1T7/7VxEEmT32PMqda52ptUbSXcUdfCm7mQMg5csYkQc?=
 =?us-ascii?Q?s9Vz92+LkPIAcPVLGQgqz9XvSdzPaCQvSZFeaZVN74RRtkO8QRP7RdV4nmTi?=
 =?us-ascii?Q?+mx3H+q0WMsLaEoxzS3cWpv4lqg5ce0wlz+JEM4+KW5ss3RmCgkxqwJw/lKB?=
 =?us-ascii?Q?gqZa49sPD0MYJKUfrFmdSLNrRGUuSX7baUZE0AdAbDB064GQ80VDPZzS2bKs?=
 =?us-ascii?Q?J3ITcdC17btmUZHvu/VwF6dbdnjxamEE06WeN5SeXlVJhg6q/SVRRp1OT4Yv?=
 =?us-ascii?Q?DmVoqBjuXec3bzc30xJMOxuW3N3RrVghTVUtjd4UrlzWJ356NZi0DKeBTZKW?=
 =?us-ascii?Q?BK40cfZ/LmOAiow01XS2tg/FJRDmFUXd3LXfYIyw0LdKe68wCMOA0o/xSq0V?=
 =?us-ascii?Q?YeuguL4howyaMIyPdfEWtd5A/cLfH1TYjiDqC5mhYXNKQq4B9QqJepSY+oXR?=
 =?us-ascii?Q?OVUXA0XgPPWb2YXjbo/K3yyZhyH0037Kbwzke74HGtbheXBsGEr10jIiF4g8?=
 =?us-ascii?Q?AgX+1UypVMKOZWKBxcWwiCRo5UtYErGmcgmblGd26f8yuj90paNcYLPG1Vrz?=
 =?us-ascii?Q?/fo2VuKH0bjMo04ePijG+3lQBW/7YOrqzD7uAhjZvlEjejAidDwzwpPdiw8P?=
 =?us-ascii?Q?P3WQ62urmmUPB6zhcIosIsxHTFpM3kZK4ZOQP08bRwVLdokFGaJxYLnli/+1?=
 =?us-ascii?Q?jBqo6sKbTNteAj4LPaD02rGTzbpWjV6vDGbbfmpCQQdUi/YKI/iypjca4M0b?=
 =?us-ascii?Q?LMZ9N49eOSH/X9XKls2DFnFesN79W+EdNbXL5FF8dJZ4RrqjtZyPyXt1E/RC?=
 =?us-ascii?Q?UXI9xyE33vehUGPpG86BPVRXNoPjAQwHKbDELe+QE+0T+rHsNleey5Fi2veQ?=
 =?us-ascii?Q?YADc+nq1HLAyT3J6QTFz3wBxn8E05R2bmW0rLkjsmnZIVyWecymiyETa75G1?=
 =?us-ascii?Q?ptYxfiR4Ovjgn54cGLOW46eR9Tss6fjaBl9gduMvgly8EzDXKU7KB6zg/7Ko?=
 =?us-ascii?Q?bDrKoM/GvNh396d6v9IWoJYhO3GkZ7nWp1IVH8t8iWlrfMjKEvTWi/rXDs4J?=
 =?us-ascii?Q?U+N2IaCOflXMWAwFQhQVOlK2Ae0XfxOQSYV4zmStnETGcIpxF5Ewa+QvWCd6?=
 =?us-ascii?Q?Rwt3rfSHK1m0lP9+A3DFe7bkCNZj97jg8VJrPCD0xRkZvnhzDo2kEQaIdBuF?=
 =?us-ascii?Q?Z5fRwNjKfiAXKC+DK6Ge10hJCgHx64ywhKWnNkD3Q+srXFdN0ajM56bLwZDB?=
 =?us-ascii?Q?FaC08ZMSQviVsbiIWXI3nrECCkNxju2REBvdInBT91wRvKzoVooSQCsENCXp?=
 =?us-ascii?Q?xHsRTG2+buJrfEY6rpnY1PYuwWoqp+BbVLMEDaZ9X1qDzJyadnpadP23IcxO?=
 =?us-ascii?Q?lJIJwoRG8K+qlMCFPKCgZR6M4gvQzlVXT4cp9nqWPgAEA9J0WzBtgQtlCpEs?=
 =?us-ascii?Q?0jAhkrVZGLqr+ttfIviakhf2Y1PBdqD7h46OqzAD2U7e1agB97tuz5b980Dq?=
 =?us-ascii?Q?DizHPFxf15sgnS7uutlF9WTo3s0R01/1I89jxZoIHQuXdOGMH041huXzWsbP?=
 =?us-ascii?Q?66wsWxjYCUjvdRgIg+rE7BgZXxF9dMRETLfl1p+z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440554e3-6684-492b-050d-08dc36ed6b0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:31.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5w6i5Q3W+Ab3Ip5ta/kUKWXFPNWl3N6eC5iiAo2OK4PF1XXgNCyZoKU16WnILZz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Consolidate some more code by having release call
arm_smmu_attach_dev_identity/blocked() instead of open coding this.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index baec827e6ae446..1303e9c603fc6a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2924,19 +2924,16 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 
 	/* Put the STE back to what arm_smmu_init_strtab() sets */
 	if (disable_bypass && !dev->iommu->require_direct)
-		arm_smmu_make_abort_ste(&target);
+		arm_smmu_attach_dev_blocked(&arm_smmu_blocked_domain, dev);
 	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
+		arm_smmu_attach_dev_identity(&arm_smmu_identity_domain, dev);
 
-	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
 	if (master->cd_table.cdtab)
-- 
2.43.2

