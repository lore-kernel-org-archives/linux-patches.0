Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C421E14BFBF;
	Tue, 25 Jun 2024 12:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319071; cv=fail; b=o8fX6s5+duvqYkKIessmUe/XvPNNQWuVKlLdAZT8+TVVvM8KdnfoNOW9BgJjftKfRF4Oo8zfhF2HjsdQuAgbFqiUdHggXNeqZ77J+rsHJbd2n9FHsrPf7mNrf943DFe53ZxVNd1EAF2VehNo+jsbCBxiZHzWrpA2KbHi7LgTZKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319071; c=relaxed/simple;
	bh=90UvaWJygA27krvjZzyBfcAON9izoZPOxn7arxK/Prw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=txTQa9thXB3Yp0Ueg1reHvbrFI8GLur3RL6UohSOzm+zn3tSVIbA1EBZRkrY6BMJmJ/kesc0ebzbSj9fE02DdEPJoKu1SCrsK2GO/FOmdDjHBygGznCqEDb1yKdPaHTC8RGWi8VGGHiWAcd2pIynQ7pifrXyl4mfY4pMIu3g4gQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g2GWgdaD; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g2GWgdaD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgB4Bn4kDe7hBBUvKICIDNaRoB0EF4ly8OgWTfpkF0kf+HyEZhtcCOMfMMExgSF99wG9abGHCc61mAJ/Fl6sTirQOwM6/jE6jAE9uohMuMK7tWKIE4Yx4XPq5Ys1NnyhxlxPJhdJ41J/3fA1fjiC165gsONZYGr3HAHzO+8EIrobl3WECTiEPJ1/tSThsYCJc020f3pa8ArWFKw1pvjxdeNp2fygfY2I+QkY0AoklgmrbbnX5oyjMLz/YmyRT70YMK1iB4fiEFBKUSJk1VUYQb0pinG4uYbYkVE4IjV8ddFA0dRRzCz/hTZkarKi6THWtb8RBBgJ66hII0UKiy0K/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrTXGyZLQ5FtW0AFYk6OXLwD0FCE7zEIQ9P+Er4Ywho=;
 b=ilpnnwa0R544jxeEHQ18lH2ogLiC0J8cNMOEsGkoDU+QGDKlA97v47N6CM4JtWCofOWs/B+XgpnyStzjLsafHLpXr3t2iCHYtXlt8gnVByIqM/mjL17T79SOPxEWeZQjbykwdqIZXSJaXlvt3ES9nyi7vN7m35E+RnjMHUgymf7zkhGwTzYJAmXtJE8K1fBF9B7seOlPlqCUc5oNDGnX59LDHOnN5zgt6kwu56zsUFa3BOL3u3gZoPOY4fN8gUzJmEwMKyHRkIQ3NRt0wR8YMab/4pBVg7nh3QewH+drGjcZm/RaH5O27r/Qyl0/rOFNQdOuyS6qswgf44c7GktOfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrTXGyZLQ5FtW0AFYk6OXLwD0FCE7zEIQ9P+Er4Ywho=;
 b=g2GWgdaDB1jX0Yvk6F+/zx+N6jWsw0qkRR3Uy8CQh9iR3Ibo0eAjKFx8UCygkSVOkGHHMDzHznbyuZwgZ33hl2S8YOjtn8dWJll/se9kKlS8LGmtV5IZFY1cgD6LCZVTXX3Ct5rdcqXgQMNO4WHggvVqXlR2kVcB5r9pnVDWQTSc81HFRMvyQdBYfJvE4xsQqcGBsVBUjZa50gjQRnnSedYQ7+wzfCAi7xw3IutJaA8K6tsyoYDyoWh4dPPmwO3NiB0C+tSgie4TFI5xxwe+pkmBWwHIdbDzXJMkukHXyNly4WDPGHUQed2CbW+DXHtC2ezSG8F+6pnB9uphHlkl7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 06/14] iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
Date: Tue, 25 Jun 2024 09:37:37 -0300
Message-ID: <6-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:335::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: b0699e82-eaa0-4319-564b-08dc95139d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mWAtimW9ZYLezF3TlbHoxGKfa6tl/BaTB7LS4fa8znbscE/b45gesX3L+4II?=
 =?us-ascii?Q?XHs+LdyffNpV4Srzm5C3fcAx+PC/xdJyJSfhgSLaWr+Nv7tfRETZlEWoALZt?=
 =?us-ascii?Q?61dAW69LiAyY7NEvU2VKcu30ahsZQycOR+UciSK4NiV9DAfGTWfuzaj1X1kj?=
 =?us-ascii?Q?uhv9JEsfoDJwsXWxy5lFKXALKA7/sJ74KoDTg6O8fTqX+BT2xF0YoDD/bxI1?=
 =?us-ascii?Q?60vCfuZ5qngMZGa2j4FtqcpzO9RIhFJmTEDXsb6dsFhaiAe8o2U/k6egiQ5c?=
 =?us-ascii?Q?fk+IIptY5TES49XKnLorbQjEAPLipnHLCXvZ6vfrWQzrsn/62KiAvFyQyHD7?=
 =?us-ascii?Q?qbz1KMMxoyEG1DJFfXAo3q+BbY4Y0fHKoFBvCwnctEYiiIGE+R0PbAfNnoux?=
 =?us-ascii?Q?DZ/tciGk6rBXq3Yf19pyElsUVllhpv+xtA38M/qmjDc1Xl8tEX6hzRkQHuxV?=
 =?us-ascii?Q?LivZUPljGcGk4wwNwSESDPtGAm2+OO9HDYE9pd3d5StLOhcx3FiOx2XYj8Ic?=
 =?us-ascii?Q?jkUr0jf0coOFkmqDFvZ6QpANCar6REp7U+APox/xuTLCR1Tg+KQJMFsvJvRX?=
 =?us-ascii?Q?GdfLjh9a/G4tiyURXnbLgGEI2BSN/pfye80OGMUMS8elnZT+kHe2UWHVYusL?=
 =?us-ascii?Q?2Xy7CkrilLZXzIGk7FkdB4BxwKmDXQvM/Z5DWfmujVFfW2tkEKk45McrNHhr?=
 =?us-ascii?Q?Rby09F0gWAIFwCIZzZE7tMHDTtdlckkxmJbIxwwb44MWAvzI60Y3JURcRlav?=
 =?us-ascii?Q?GKyDDdsOSiy3ZE8yqQ6334H1q4dSMZ11X+Jvm/0qfjlb+UME1szZLvzx4854?=
 =?us-ascii?Q?W8mK5N3Tagg+KY4av+QK/oCUXNmIrtfA/BLcKogzlffqYdWVA2ZpTsXTqpWr?=
 =?us-ascii?Q?+G9On/VfbubqdWp79/TBtHA5gbrcMwaJRvaugp87vCq/XH/spHXMD3dL2XyN?=
 =?us-ascii?Q?FAutffEDpPe5dSMQQRfPsvfUkss9Tr3KDhEnZk6wCuSeQ4blmKWeGaPUFDbu?=
 =?us-ascii?Q?MejVQjr7xrsIjSTLWRJ0gPIQzET26LZGOobVzBDKFhtRxOFQSoY6dmHmBbHL?=
 =?us-ascii?Q?BkuXYRwloatvGnANmnkWra8zV111Klno+mx+/MRIV4KKchd9YmeS/ihNEERh?=
 =?us-ascii?Q?DeAA7mHRC4EVVzERRbuXZG7Jzk7aYkIqw5df9e3nowH1WIJBI4n22HO1Nrje?=
 =?us-ascii?Q?1SHZktIr5JcsprMH54PWPcjzLLoltiVbzgttdOjVIts9D+GA4X+APWkYWC+V?=
 =?us-ascii?Q?Kbk3iLgS4xI1/GrGIsQD3zeGifstxWGP9w2RS/rRmqz9+VLrvU1Ttv0yNVM9?=
 =?us-ascii?Q?mEE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q7TaxrlNgHfvtcxWZEpDNKtKOtVMWATzq9YddGITonua2YVRbS48ixrtNxIF?=
 =?us-ascii?Q?GrTaM970hvUXJfQNj6ykb7Noff1GuyjiDMoHr6BcZfahoW/wGhSnyG8iO6jK?=
 =?us-ascii?Q?t3rAJBRJvh6q7s9ZoiKEvdZeRDiHtOIUvVVlfnAeON1z8pMsoUfm1MqB5Ur2?=
 =?us-ascii?Q?zM3IdHW0ZtjP+36VIL4QGAnyhnmW7gwmSVOUtdVVzkZBXEQFHJGKbpSSod88?=
 =?us-ascii?Q?AC5mRSSJcEVGsVKscPQY+TWjXKr0HSLx4o0WlbBkslhf6hx9xkh/xy4kGwgE?=
 =?us-ascii?Q?TZUSbAuwhOLnGMSOiCspHSlyAVgnEFZQzZD9D2ErTwN8+8mE9mgTMjaCqx1f?=
 =?us-ascii?Q?vjStObh+QNjzogc9WOtj4Dy7uBTLeNhf384gFLKZjpkeJvMKcyajDn2TW79I?=
 =?us-ascii?Q?2GAmyf98ElTGSTmiPDQRqtMybeXBWmZFAO5rJyqqAw9KTSFza3kJISJfU3hE?=
 =?us-ascii?Q?8fnX6ouCKjpGhdRoItOMT75u82tLVHHUqoC4DaS+ng8KaOySX/Mly0vy3ft2?=
 =?us-ascii?Q?4IA4XPHEjjWAYJlDjE2cjGCwPZNsMcElAnL79BG97o8JMmGuUaRem3G2X/Sv?=
 =?us-ascii?Q?HsYSnoFcMkMrDZSXDokIY5ChnV+AjCSU2bvvbvx9u+joAvLfv4EFR9BOBxn4?=
 =?us-ascii?Q?QkT8JzZn3QEZzNRppMqRbWrPqqxt6VqCOZYgcImhOKVKdtSns5C185eMoejs?=
 =?us-ascii?Q?/OL74dKs4HakfNjlJ3DkS7LUAtuFvMcLEpbVa5+tekubhbf855sT3BDDF2Vp?=
 =?us-ascii?Q?iMwecdahQzz81Wwy49ekPQdprDHuPKAMHiLXrPeainiDfhCRVEMJU9vuQPXd?=
 =?us-ascii?Q?qjIU6aqIwsxNLgvkI1DYypOYF6QZenjJqjogz/5pEgHeH8uFgYdk0nay++vm?=
 =?us-ascii?Q?L1lXO2KuNTt7Q8AuFp6GwZWzMiKbf5507dbim0i7wKF/+GXIHEE+dLQO6CDp?=
 =?us-ascii?Q?D0KfjXpZKwxmBf/Cys+SRDx9fOSl8hfgBYKmMk+vAhBLBDzY/r0VBbJ/I0lz?=
 =?us-ascii?Q?m69FAicphmT52uyBFTpKnnio6OrG/nhzcSeg5WlfCV8VBxIlTu/Ks28Zo5oQ?=
 =?us-ascii?Q?1GJHb+/rBTybTuB3UlvxuKYCaPuYtvFnoIR5ioSKMg8rjSkTD/NzIm7kZkTT?=
 =?us-ascii?Q?D5wBlwSqZhP+Q2RKVhjSQVlI3MXvmI6M5xU4flGepGvhfna02c3tf408cpqL?=
 =?us-ascii?Q?WKDDPKEftKRn01HO+rBwESszv4e0zvFJWotLREE3sSj3pBfVdVlz2QINnomV?=
 =?us-ascii?Q?3C51fVi4rqVLtMZquOLWwddqnBpr7g5XwMUTH80T/uT7nqbkMTiRAjk3yhjT?=
 =?us-ascii?Q?VYjfnPYTvisSWyQxJvlQ1uIfWmIpDscbaYk1oZlH5Mu+wExjpmk38dC7o0UD?=
 =?us-ascii?Q?B7vBNyO8WTmdAycF8czRfJlRH9AtDKiZ+ekPpwogCHZTU4tQsylJ8tMLi6we?=
 =?us-ascii?Q?z9wLr6RCv86F458QsN5QG4Gs8lMtjFQHegQ4fDWZKUpdrQKkyQyz1MIXnoYQ?=
 =?us-ascii?Q?12V/WmbQzovlqlAa2dup3MntE56KdVrZAjuKrWFEIw8TbfaknU2Bm39X0bbP?=
 =?us-ascii?Q?ahfURV6TpUjIDa3dituDlrB62KfRIw16IgRX8zYM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0699e82-eaa0-4319-564b-08dc95139d92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: itlpA6hHhizlF5h3LEQrktS33wjI4/fNXICGG6N1ATzPmOHEIB4H93t3+rl3wGFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

We no longer need a master->sva_enable to control what attaches are
allowed. Instead we can tell if the attach is legal based on the current
configuration of the master.

Keep track of the number of valid CD entries for SSID's in the cd_table
and if the cd_table has been installed in the STE directly so we know what
the configuration is.

The attach logic is then made into:
 - SVA bind, check if the CD is installed
 - RID attach of S2, block if SSIDs are used
 - RID attach of IDENTITY/BLOCKING, block if SSIDs are used

arm_smmu_set_pasid() is already checking if it is possible to setup a CD
entry, at this patch it means the RID path already set a STE pointing at
the CD table.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f563f2ee6fd76d..38d1465a44b479 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1289,6 +1289,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target)
 {
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
 			.ops = &arm_smmu_cd_writer_ops,
@@ -1297,6 +1299,13 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 		.ssid = ssid,
 	};
 
+	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
@@ -2733,16 +2742,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2758,7 +2757,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2831,7 +2831,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.old_domain = iommu_get_domain_for_dev(dev),
 	};
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f4061ffc1e612d..65b75dbfd15914 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,12 +602,19 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
 	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.45.2

