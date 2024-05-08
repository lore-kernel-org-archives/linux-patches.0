Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F55182;
	Wed,  8 May 2024 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194649; cv=fail; b=QUowYzNfy7VmO5bRnenRrfWxbHdWR2ZaNq1Rw/PWA/BiDUDl/cb0Zf4EknWLYVwZwsnyxy08jWWU/kPgXRhlR8fB4Q3bdbc9n30hOmvkWqFIsnNx10LNezOx785naYoDt8DkQ6OmTCz8Uufci56ER8n7832JK072+9DWJ76O/2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194649; c=relaxed/simple;
	bh=LoBrJ2rqTfxoQ0+CxNLV24jaSq+PWooN02PHi/h/yoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tklx3h8G90ZeZzr+3Z2p8mA/mUBNki6r7+KaWvQAn+l17W3p4YdoN9Td/LVvWLZnsRKqYFnWapWyZW4ohfJoX+pEEvii4/xEzVgHlB6DPc+ShZsFSKHjRqKW6GkN2dWXhDZcPMrjQb0con7NoyDgu6kCo86vBj4EuoOv3GXERWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WBTKpaDT; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WBTKpaDT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUgQDJAWDCsj1o9lBUUADb1Fwglf2kBZ5qBb4GLJHpWD9OsVbkxmPJE/bBVAIXC+jSfWUCQYnVUW3/mG1xvjdvJkqte9wc+jNVQ4X4h8zh02+ni2JrKGh2myG99AMUzGNo2Rm5zNhnOlmjF+GAl/7v6HW3jJEJNC7+GPFR2/4uOFC170MUApcqlQSEaZQ3F1cHLqklniEEb0Nowgf7Ruabe/1gG8qrqrc2knctgNrclpoDX4BTfVNCiNA0eJVAD4WYwJqiDLYW2fIzk/AW3X68cdRngWaAmq5OiuET+dEMBsZax3IFqV2Ccz655sxSDcPPxV2VyGRwjDx8xPoBKQHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eFo+6WoFpIg+epk1sHwLf15bM46gwJfBKn6cttP35g=;
 b=kNDkSeW0r4ilPYJtWvpYcdRreRNINYh1MzybneEN1ZHcaBdYXI53Uf2MyDefmguiF3zuSFLR3Lm4dR8sXv8Iy9g9nR8m4yYLOjnZ9FxuKLdrqW59/MIh9Z2ToVr15B46DuEB3xvaEc3VsSAYOFVnmk0kvs/c9Qn9N2ynJepdW2OgYLpjoOa4umwDPSbFs7BBpHOkGYQM3a8CE8DsaW07aby4ZKwl++tOS8oLBRes8j2A6uSwZR8QdMBT6hh4Yi+38rO9bZPdtpc5w8S0DF594lz03TaXJwuYn622yNUQ684AIiWUNyPMXhSGQxYqrRb7Z+XtQ0f27BoF+UwNnR4r6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eFo+6WoFpIg+epk1sHwLf15bM46gwJfBKn6cttP35g=;
 b=WBTKpaDTSPpj5/YA3xWmiGnB1tVeIJn1rt1RLEyJVNneSDnEds4+S9Qf6J3/Lne96nJowLUE7LazwWmYB8s/vDMyq8wuaIOhPkA/3ADMOK9drl3T3st2YPlwgNoXEn+O953e4VTOHI89frATUugRs0xPeeM4aTF+hphJLaYhU8ETlERS4ujNsJFbp5oiyQTEh07vmb7q8AxUUjwYwe3tPBKKoDamx3KefovoqhJr7awMD8KYFKdkpha7k1Een5NRfDIK67m5g1kufvgaRG6V4eUXPgyT9dvDL2xBVwwrnpCwbp+sDWkjMtRA3sthG3HeoFK7KI/VKHCWwfzzVyLnuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:24 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 09/14] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Wed,  8 May 2024 15:57:17 -0300
Message-ID: <9-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bde1df9-a641-4c1b-2bdf-08dc6f90b28f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0bj2ja3dtW7ljf9I9qpeRbQ4uFyTdsNCjL+OunrtmnLkRwJURR0LxH6RToS/?=
 =?us-ascii?Q?M3wKtrtVX5fQzYZI4gmFdwwBOKK7Te6Lf8b+nTF6Sz2vPCSsiu/yOzpLq2c2?=
 =?us-ascii?Q?DNxsfye8ZSdBqEQNfZRdZU3RQNE5XiMk4CJ80UzGOVAsKpfjkXYaRFoy7tyN?=
 =?us-ascii?Q?3g83OBpPXJpBh/4IUx6mcjrJ+7CJ6EEki1MUlG4t6FhZl1dSk8qsQv14eUfg?=
 =?us-ascii?Q?oo/TTBA97oe/h5YhHWzHBuHm2TpK6EHb7j2xxsFxCG5Eo8WhDAkU1v9+1x2M?=
 =?us-ascii?Q?aTkjLwlBHr4B00Z6UghRmIKJ4h9dlHzNJD7torwXttBQwffwNq1A/g3i+FV0?=
 =?us-ascii?Q?ufdO73FHkg5nvMWp5gAv3FAd9ZMnEpBfXCLBnxx3nlet0xTnyjMmIs71A5Pq?=
 =?us-ascii?Q?Z0LByr4p9cF8J9eDF33gV5HmAfiUtB3CB53e4Gs2d59fcp6Xl8c/sCVaLO0F?=
 =?us-ascii?Q?CQGf9LH8aONQ0cLGnvSrNyzTikAVXZn1gylvqhsheYo/CaLzXTgIhL1VobE6?=
 =?us-ascii?Q?KLmuf/z3JlLm9EIDaHM4Py0WcFWJ73O1RZYo4uw8DC130EvzNFTinWWbTQW0?=
 =?us-ascii?Q?c85UcdRgOT0isDTzmc/6RfaOsPZBy2wrNY84tn/fczfae7aWVCHj/jz6WiC/?=
 =?us-ascii?Q?2GptTvwHriCTEmbX7PLL+4z2aLyBMOaZ2/NDx+ogfWN9/jDZi2FfEWSSJj+H?=
 =?us-ascii?Q?ugHRAWRzIPrkGSTihtr6FC6pH/TPzReZpy5vierx6IaYijHWFLkjgLgNNE74?=
 =?us-ascii?Q?xh7iqWCwe9pc+U0N5l8fyBXWK9u1CIQcYklTGHEhFHSWJltRDbiRRhghhfiH?=
 =?us-ascii?Q?4VruF6ot+zNgP90rvvGSqWtIikEGwQgsG81uRw0Tvz8RDIDd8C4EOaKvJ1E6?=
 =?us-ascii?Q?/cBkWVdz1dLJ09PllXTTm2B0ZwWl4/9rp1BlvAoCrQG57WOwR1CncJzGsv8Y?=
 =?us-ascii?Q?/ph4T47V3S6mi3IoTBEBc20rG8G+Jnqj7WBZ1AfIlhPGatnm2F0ZF4vLHx8j?=
 =?us-ascii?Q?TXiwik97gO7VFbo55gAqYq3m9H/FMWznFjxtmbKYOFpdrBi9e5ISgAlO4Uql?=
 =?us-ascii?Q?WuwULWhkfPegNlVmxuGyhdS/l9z+PluSgGAjn9ledb7UuhMBmmx19a1S7yf1?=
 =?us-ascii?Q?vth9pE7RE6ZTn2mKn1vMbDojoifmrvAJK1F30f3Mz7rSj7Xl67PusYsk80Bh?=
 =?us-ascii?Q?YDFhQ2qwd7clHFPP89W1jJevVIBChvJjDR2aoirSkFSv8T39bNthzY2ktpuw?=
 =?us-ascii?Q?Joae2Ny/bAaHp3aLugUCvDrpBhiSHHbRetdcGPK3Og=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jxBhpp9qT3oIEnJrVcq3sq3j1AxCvf0DZ02Rdf+vZAWjMIBUFQokxE+P2hTc?=
 =?us-ascii?Q?euB0261jbXS6UJ3EemOUK9Xxmir4wdViJoWaC839KlnUcqnBKAbAnLrmUhwX?=
 =?us-ascii?Q?PKjsqBGaoQhZ8g2eHohKJRMmACrc73MRpPVJ24N6N1kKNlnjqDq3do8WBDTI?=
 =?us-ascii?Q?NoyG0zhqNkHXaTQ50ll3sJtSDeG/ewMIIFU/CfDmOUbdcfbA2zg51kjDji3P?=
 =?us-ascii?Q?D8Mk0OGUbW7+gZ+fNXSNjY8RUA8yX7LRHvutEmpzGXTbpnRaVjOZybA6/dRy?=
 =?us-ascii?Q?slqljyQCMa7ySttTyOX/g/rpbvPM2Rv/ErwEKqm/pXhU9kyfruCtjt2ukj8w?=
 =?us-ascii?Q?B6I6PybX8fa1YQJ52OFP9aQ436M+Dgs02i3YXUeqYdZ94pmbZo9EC09BwUdl?=
 =?us-ascii?Q?7N+rQJL82Q0E/RE58of6vpgT8V3gDUONZpi2hgXo/uiYxhRkzH6evtCX1kPu?=
 =?us-ascii?Q?EAUe3TeCnlzn9iSgHvD1+LXSO0KigFqT3jgD2mCDSKb53SctFDwlNBNnjza6?=
 =?us-ascii?Q?cdJm/kXmRaFtHMlR8th/cnp6gUaUkTAFlb7hFGehSc7EEMNguEkKtz1NGcFD?=
 =?us-ascii?Q?1MBB1H1lJcsQbp+GF9byvdiGrXpEpDNefP3PJt8a7NXatWoJtMiS0lt2eimH?=
 =?us-ascii?Q?bj4HjKvNt3K+UN4vkHA5QHBVJCdb2rV/2pDfJOqWQ2laJocycRv15fUAbEDa?=
 =?us-ascii?Q?STMwY70xC2N7xeMA0wib/oOKLIse0+epysWguj18wmLhSgxM28kbHxuY4cAR?=
 =?us-ascii?Q?1tEzZriM39DrYmM6RjwtpI8Ug5IFzHKYrCd0Vh3ef5fjgQzFtF63DhwDiNjQ?=
 =?us-ascii?Q?QScWfRIQP+xAAl8aS5VXQug/uW5krr+ydKOamabkC+te5c8yoJaaw7CxK+68?=
 =?us-ascii?Q?4XIp5vdvNnzMZ2sVyTFdLdo/HEOohIuj6xetSDrbahMOV6KlE5clah3YyuN2?=
 =?us-ascii?Q?TxqFGxxiiYDk2sGtYoOcznLEyHI31mFBCGsWOFHIaJL3vE7WbftP2oH2PZo6?=
 =?us-ascii?Q?rz8wCKYk2O2eFfHsDLE7M76Gxjtt5C9RJpWWkhq1tYJddInzEVy10KAYmXRF?=
 =?us-ascii?Q?vFXp6SbPxLn8MxM9ISkh5+vj529zzg38R878nEJUSoFbRfGZON7ubVqQ74Li?=
 =?us-ascii?Q?NXz/UqBpnMPLS8r6dSH93uD2YXGYYIszwW5iQcZuDdo5jVLMD2pIGkmzGG1w?=
 =?us-ascii?Q?jDmlmlNWyrqpcZANTGorMYUEVE6rw0w1Dsngtd3Int2J+ym8YoPnc0GGRjGt?=
 =?us-ascii?Q?GsWSuZ2+opgp1lNUPziXdFpjwtF/uXJ9Z25U1oleGlakbgfd2NsW8tOFAroY?=
 =?us-ascii?Q?T6FRu7fO+cuJQpyKezex0DdQMRt4euYA10Fu6USouqn0sSOkp40ERH18pnNU?=
 =?us-ascii?Q?9Daw9aXlN157NAI5RYqUNFzqX0EaB2ip5tnS/E/6jjmB+uTK4P1Z/khYTQ2Z?=
 =?us-ascii?Q?aT+Dg5Ko1GkoFUFb45UWcSDvJG5BCbmOQ7aKFPpHvkFaR5pjFxwNlw7Dj2T8?=
 =?us-ascii?Q?QfkZhKnLCttocOVJdcNS3iuv5sSSfrVpTFj+8eSUP0MpmMNBX/z5YGVKTFpW?=
 =?us-ascii?Q?94V7WVljysJTpcy++J1W3uyhkYt8XkrBPHu23550?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bde1df9-a641-4c1b-2bdf-08dc6f90b28f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:24.2940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mwK+hUp8izQpSiY0FuiOJPSWJzQWi0jj+sR7W3/MZRj3VV4cknbS+DQrqsLIEuS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

Fill in the smmu_domain->devices list in the new struct arm_smmu_domain
that SVA allocates. Keep track of every SSID and master that is using the
domain reusing the logic for the RID attach.

This is the first step to making the SVA invalidation follow the same
design as S1/S2 invalidation. At present nothing will read this list.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 +++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3011eb10763bee..020e4efdf8fc06 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2587,7 +2587,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	/* The domain can be NULL only when processing the first attach */
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -2793,7 +2794,15 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct attach_state state = {
+		/*
+		 * For now the core code prevents calling this when a domain is
+		 * already attached, no need to set old_domain.
+		 */
+		.ssid = pasid,
+	};
 	struct arm_smmu_cd *cdptr;
+	int ret;
 
 	/* The core code validates pasid */
 
@@ -2803,14 +2812,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
 		return -ENOMEM;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
+	if (ret)
+		goto out_unlock;
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
-	return 0;
+
+	arm_smmu_attach_commit(master, &state);
+
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
+	return ret;
 }
 
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
 {
+	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
+	if (master->ats_enabled)
+		arm_smmu_atc_inv_master(master, pasid);
+	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
+	mutex_unlock(&arm_smmu_asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-- 
2.43.2

