Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58D1553AF;
	Tue, 25 Jun 2024 12:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319076; cv=fail; b=sN6QPB3ojfYV/WxN89mknfFKH+RtVcsSwBFhKw9fAOgEB26k94A5lJ2jZMhZQktZWLWgB75H9n1gs/AjaRGkORKlYJthsoBDeZA7NAIv14Xkt/5CFB4xQEGyPaTJH1OK7PQw1iSVVzXpXcOfF0Wa5wMlAUVahy8vwOQIIPv1M0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319076; c=relaxed/simple;
	bh=/mVlx3QrH12yKdmia0EbudufylITJ7W4YBm0YTqmqD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WC8dLkTc3eacovSKqPBzf7dnZr/xXDtOdqd38H6vI9s14UEreHpO09QAoQyd8ZKjcmRQNS6GArvn7JTV8WiNlkfi+7BLGlr+rDLPBhxiyK8AVB9+pBd8iM4p08NUfZS8sidTLzcApnfyatoBy9j9K1fBuw95tKq0ohuBrUuHO3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aYEjyiHD; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aYEjyiHD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIG0yxYflZAkXSOtBOHS50iKtvyxMLEwWRlAN1mroE/w0xXEWiGp463AGQkRwDpQ6q6lLSX9rdZoIz118U1VyC1Vx49yoFhffpQmnsGFh40tKopkX7PVcHrPRd8sZad6y7FSuUVWiyt64xs/AgftadH14R5RKYhXgemrSrKOZpgJWoeWG18PCelXXVq+b0Ch4UmrN85rKS3XIz0WrZdYdeKfiL+U0b0ue/y1GEvURvBCqNF9vqBMoPpkYy1eCsPmV8agUX5k6RVxC3wbjpQ7K/l1Q73aEnvc1ybsSGcVwbQ79PkVyXI6/TPTz0sy4JtOO7S0pJAkXQjXglXbpkZdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtEi5+8vA/edyn/3LkOJ4tMVBbAgVrmh1gPHsAWFYAY=;
 b=cV6nsGNw5ElT4f7cU8XlirdknoP8Wiv3Egg4LebsQ+qPv+OhhWecM4BS6cOHUiOQLAYn2rv4u+NaHOoK3BljdtAodJWAZK+EXeurYjmXGrYiHfN/aEvbvVSGXxyghiXJerMC23gpPFZY5lqQnjVBi3wlk9tLSLF6IAM8g4tSsykVS4MQeRVwI8x1XUXkyI+/iiDiEF1LmFdsNTGo1ONjWZPu+AUHYMNzhqi+hk9Ijqq45OVxM0WaZn4Y+zF5mwMQ5oTOLTX1uEIyE1sORXd7g38e9hq2mg304PXfjIcUFFHLHyCKJP1RoEhWHrR/OeAVk/vxz59aLA/yqqYX+qQccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtEi5+8vA/edyn/3LkOJ4tMVBbAgVrmh1gPHsAWFYAY=;
 b=aYEjyiHDPBogbmfI4P2sVJkmVmxfKG4qVilNOOtJFLD6PDKZ8TsY74jGcS36VFAVMBqA683MoIujRGaogMrYWaGhetZl3TxqrJRg51ils82X/2ckoTv3SaN1QCoXE6F6a06YeWac+xzIQa6rWsB9OOFbeKYEUQfDKV8qOE3G6nUnwutK2yEZ6yiyHFPfp64OycfdoWeZUhmiHnafWOoUVj9N8ulPP3gpeasslBlPkJ+J/tAgJcPKwUzd2Gwsp/fUXccvHCA3rB23GJCyVeecOBj0VIicJ28keb2NILylWKYCO1uoShBqRYarWNbS5ZA4eJC2/2ew2wue5nanrRkxZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:47 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:47 +0000
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
Subject: [PATCH v9 07/14] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Tue, 25 Jun 2024 09:37:38 -0300
Message-ID: <7-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:208:160::47) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a430ea-115a-49ca-bf43-08dc95139dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IIeCOJ1bMtWyE9Y3VIhHi4eI+YY9r4YWopAp5VAxd7og1xkIwFfPwEcO7GjH?=
 =?us-ascii?Q?TbAJrHGW9um0iwcAw9RyudX6rGro5kGupRcPRuxWgrB0CXP45NKHIs+Z8ZlX?=
 =?us-ascii?Q?ItUa9ozRYD3/YNLC1BewmmdQ1FF1NPN68pY5qS/ImQH5UHGPHyfSQkybIMm9?=
 =?us-ascii?Q?Th/W0coLdi1YgwhUfloRMd70ABfQxfyDcEZ41afZNQgAyWAfON8L6ZN77AYY?=
 =?us-ascii?Q?8Y8/YCwrNx4R2AN2P/PloAFpcB18zHz/WN3+MCT7q2Qcp0EuPWU0jRAPD5/Z?=
 =?us-ascii?Q?9mHD3TsjVEWak+TMRm4EKLJmfY93LZdaBdU6CSyspUno2j3Yfc/yd2s4MiRY?=
 =?us-ascii?Q?vcBhcWrcPrq+fwUAa46GFHx8GgswTzkZ0fThDP3TtfEAkJPFtBdKVBaq0z+5?=
 =?us-ascii?Q?hs/1aZwacFxaXI+uG3/QxQjTALqDMDw3Wf5ItZOx09WDQXX2Goa3t00IRp0S?=
 =?us-ascii?Q?9TRJANp7eb83pnr2Gj7IWvGIDG2J8wJi0eOCL7t0U4TkfqP+DACb9m8zYeGb?=
 =?us-ascii?Q?16VkMyEg4cvBtpOY/n/WLemCgYv6ZY5X9PTEWarRMZlUhwDQ84C8GzC+w1IF?=
 =?us-ascii?Q?Ioc+OOwCzN12qYg/+yuNirg8H28GtBdpSLeHdNhq0LesH4gWE/SnzIgiNs+3?=
 =?us-ascii?Q?Xhmo35oEkMKTRNr2IpfGN+9Qpz5VjL7l55rP7S0eXtkJhMs/Wy9f8udP8GTL?=
 =?us-ascii?Q?XDvvdMQ/3Af6lVRtO93KfnK/czls4TKXNhxdnj5YIxlZaVMYgRbYy7YrEzCP?=
 =?us-ascii?Q?hIqyWz8OJRQ3swpMDQ+ny3LDOOU5AWNhW+dZlQzChGrhzy8M9551e9jmySGz?=
 =?us-ascii?Q?a0v0vaNIcdqbI//eCBSStsSZQ1gKZGJHM7tWeR+objDKG2HUQLrIDrd8WMv8?=
 =?us-ascii?Q?M33Rig/IYwGmADHWUtzo8f1N0xXmwPI4ZZ7VpkHKMioRYxbpxxAS3DDAg1nx?=
 =?us-ascii?Q?eYi1sIERkK6MYU/HicvAIw64oSiCDvV/LBQdette4XC161y08tk0OvHtZ/pn?=
 =?us-ascii?Q?OTqcdPiHcxTKIpzwShCSUBzZt2CDwm61DrPBEYz8nvbY55Ix1rqf4lHmSm+u?=
 =?us-ascii?Q?XRv4RYdW9i+9WWrau9ofgqR+42nxkUEWE4bEhDRoU82My/6ent3day23Dw7Z?=
 =?us-ascii?Q?wCSq1ORlBHThy2+VhHhfs0LPitGShXzyPL65zrdTXfTWHQp62NU+sBpVaeBZ?=
 =?us-ascii?Q?nfNwlJb/PViPAY4g410xsEdPoKpM0NNZWqYeGhQf5CoqN5wZbQwA7yF2eIw+?=
 =?us-ascii?Q?rQXUOavHuzwTV4MAj6rFf7WBWThZsUSXvwtmfzjZh11OI4JlP6XuIAb0A1cD?=
 =?us-ascii?Q?pCs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ut1H+y6iEdKMbewZnPMRI9tQJDm8ShB2tFa2wGa6yXukYPuAYojQFDBfsxVw?=
 =?us-ascii?Q?jHnAAKy9dROXoCFdSc1nAIwRcbTQ+4ns+did5JOXJTAtgvvihyQhIIdq5ZdI?=
 =?us-ascii?Q?IXviHIsWM0IFiPNA6J9OUOQGkgTbKp3COx08gtoidH2PwKREn2Xzm1hNpwLt?=
 =?us-ascii?Q?FtK3WGix6OBCHy3GA5YHyfk5ilTHtuv0kTgrFaf1sqO2QDD9o8btDie/aUdO?=
 =?us-ascii?Q?369PpYsVaQzF6PzrzH04SkUYk0PfN59M5CXFanVebmsxNIu6yEt8WcDIkQHH?=
 =?us-ascii?Q?ZkqAx27AtN5na28n4IXT4gDeqds7dQuGBQCvccF39CgisjGKbswpkLqDuLew?=
 =?us-ascii?Q?Th3lr9jWUY4jfeYFDJT0g4/a5ZhvhYUfwSUApnsCp41IgpEkcIiunoUp6jYz?=
 =?us-ascii?Q?vPX6ar2Oewcjx7jOklJnbqadkte7vnOrfx7kQQw456SIq+/OMIlnCZgsKVor?=
 =?us-ascii?Q?27InTGFByEkrr7KDtjrSzFKi8/DBg4/c1G9H1RAAm4CfNmxMsI/ZfD25RPWC?=
 =?us-ascii?Q?qnqQUnKOSskWn/kKjunWFbtWvUI3+k9lYcypVp7SRt/FP5wFCuL2DiAFLF3H?=
 =?us-ascii?Q?zpzfhs5LosItQoTap6elr5C6vZuUVewrvJ2275pz6PHzxt6grazgbc2wbHWw?=
 =?us-ascii?Q?9WCd3ZIcik+d4HO4/M4NJSggNfKfHZaqDWMfcVSOstzDaRXnjgmyR+Ocswtf?=
 =?us-ascii?Q?+CDVrg6M/oPyDXiL1r73eM5QlOa6cnSKojJSclnIJ1LzCunNg2DqGe+XQCqU?=
 =?us-ascii?Q?QRyR558dasZJVFT1i2ELAfe2dKdmD9nipENj6+ryPtYqO0XTkZ4R877nMVKU?=
 =?us-ascii?Q?C8geORSOtdOq66vgKJVzqdrEqZ6m740VEyH7YKKKG6xiO8w5OGfTpu0uXC6T?=
 =?us-ascii?Q?y4biqRuc8nNUOPl2T4rJagmXAI+5TtEQRQtbmUFjCTKzYEFBa+gi3s+cj5W5?=
 =?us-ascii?Q?UD++N/arTViMrAV4XG47vfncznET1kRUDsgf+YEFBMN126jfF6JcEzaB/+Wf?=
 =?us-ascii?Q?Mc5H6BOsdxOIKYZHrgo5ZoxDVNx3yhhJZ0PK1NYGA3vK5JZUqP1L9hoJi4f/?=
 =?us-ascii?Q?PJqhTJ2cZ+9Jlhdu7DWkwWfUBYXqqXugjmcBPAJBVkIL1p45VN1uNwFaTGWh?=
 =?us-ascii?Q?iZr0AVKWJhoP9ZcBh4Fu+Jnm8q27yRxxH1SFKMv/o9d0vz1F3BUJwSINy3qo?=
 =?us-ascii?Q?sTMB6z19Lcss+F54FHZodnazUQAYT5sKh9uVcffTz4/YvxlZQr15Pmbj4/3h?=
 =?us-ascii?Q?fnrsShBc2fnt5jUSDAYSa4pJQ8SxYnVh4mhYxZ6enUmkowmRzmnwAvwuXn5/?=
 =?us-ascii?Q?GxQ1D/HLzsQpphpyhBg+CjP1QtyqGeN1P2WyW1HigtslrAhbmsydyhFyLsYm?=
 =?us-ascii?Q?SRYIZxZSVLucFeXibcJmX/yJdch6wLE0QSaFetzWfWqfBxb10UjRqt7QOzgt?=
 =?us-ascii?Q?2/Hq2lpvNLzL34FSTH4iYCZ9GeKFOXDOFOu3JPlxgJmdvvvruO1ZDH8IAyYw?=
 =?us-ascii?Q?fE6Ie3kEvLHzy3ngXvEiKki2yIUPxcBtkb4JVV/vfbXRNQL9isJf0bHmhqyT?=
 =?us-ascii?Q?QHYii3OVOZzN+lm3z9orve+woNtoiVedtvPZ5B9A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a430ea-115a-49ca-bf43-08dc95139dba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a8Dz9WC78qmiP5lJQIm730qjc+l8FeluHFG90K/nNqn5xEzVpHIglPliCUsFXcw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 38d1465a44b479..f6634c37601b89 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2005,13 +2005,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	cmd->atc.size	= log2_span;
 }
 
-static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
+static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
+				   ioasid_t ssid)
 {
 	int i;
 	struct arm_smmu_cmdq_ent cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
 
 	cmds.num = 0;
 	for (i = 0; i < master->num_streams; i++) {
@@ -2494,7 +2495,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2581,7 +2582,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct iommu_domain *domain)
+					  struct iommu_domain *domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
@@ -2591,8 +2593,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2606,6 +2607,7 @@ struct arm_smmu_attach_state {
 	/* Inputs */
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
+	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
 };
@@ -2663,6 +2665,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		if (!master_domain)
 			return -ENOMEM;
 		master_domain->master = master;
+		master_domain->ssid = state->ssid;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -2710,17 +2713,20 @@ static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
 
 	if (state->ats_enabled && !master->ats_enabled) {
 		arm_smmu_enable_ats(master);
-	} else if (master->ats_enabled) {
+	} else if (state->ats_enabled && master->ats_enabled) {
 		/*
 		 * The translation has changed, flush the ATC. At this point the
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		arm_smmu_atc_inv_master(master, state->ssid);
+	} else if (!state->ats_enabled && master->ats_enabled) {
+		/* ATS is being switched off, invalidate the entire ATC */
+		arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
 	master->ats_enabled = state->ats_enabled;
 
-	arm_smmu_remove_master_domain(master, state->old_domain);
+	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2732,6 +2738,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_attach_state state = {
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
@@ -2829,6 +2836,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	struct arm_smmu_attach_state state = {
 		.master = master,
 		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
 	};
 
 	if (arm_smmu_ssids_in_use(&master->cd_table))
-- 
2.45.2

