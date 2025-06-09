Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4578155A25;
	Mon,  9 Jun 2025 19:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499113; cv=fail; b=uEW8SPjTNBjBBZnAnhx6LZHGQR+bWux9PyCH6YdyJM1vfSPUadXmfc9+me695e/vAWEvTdugttwa1IsWkkxVM4tuL1IgPYWXoVhdX4ds0K/dQDQE3iuzUH7dKcAsJnHKkvmLvcfQcfV7Q+8+RwMTa6GR2BlYSSidtK/1xQWvMVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499113; c=relaxed/simple;
	bh=jlwhAY7Glh2IClMSQtzaYFFKTUpyn4VZz/uvthKp/mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jkVfatO/KXmWQerp5XOLQ+WQ1SWdHlWyczq+q9dfSRTbT1ezOZlWYryrBQfGZyyohza7aI/8RmxZ2xs3owy8C8zAPiYbN66wWOajCfA3mZJFG/15lo9Q3IGizvN+jecKvJq2j0lnjZjq6ZJWM4peiQohg5rO9dFrbNsml1Y0lRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oHOAUQ5l; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oHOAUQ5l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NjlZwASdY6x2ZaZx3X9xD415VxehpDLpQmWbL6YuKetUxsOUwZkGZpiMD+oe+GKcUH8sLl7vrHhQ3MjhQZPsdOMfewaBDDnDWDJv79O8d4rqpET6BF7dAlMFkpE6jzxcuqOfzpQg2JCM+MDvcMZ8g5EjXCmLnYqbP8ylaL/QipYlRZXk71SYcOi5784P7Z1nA0PudngqIYeTprpBL6pKt63ElfOv9F+ZHw8YFKJG5wBrnpdQZc6KcnXjW+q0lMi4OnH1vSzms0E4AkgRiZNaEJh/c3WZIIuozLdx2k4DHpHgMEA5f3r8Loq1PRBSkwcI13pa0iJCk41kfNzg1BNQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo4Hit58QTDBAfTrcW95qNbD1eRyfE5qRvlFGNYFSTY=;
 b=auAOo9QDQF0Tmj8YloPHz7ucstz+OKA24O4rqHc27Sp4LC3VaJeEcKLsAsg9A/XSNxb+6ZZhqJJShFFxwBISngUwaLETg2GS188MrMSBXWt3PrB8/D6mWkm7e40c6015Z05kn6iDhwRE4+KRRbCUahSS2/B1ogUKtljPi4oyP/pAwxCIZOHzvqPR4mjzkwOjIZatF8+L+vJRcq8WmUisGu1IYRnWiEuxF59woAAsxcc8ggik1JIBERfV6w8OEFN7V80ZnAFVZM12j44yEwSpkQRE5JavnY+g+6JVMQb2Xlhp1ICOvH1ys/uM+jgjV39crqoIzXIzhfVkv82fPvnb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo4Hit58QTDBAfTrcW95qNbD1eRyfE5qRvlFGNYFSTY=;
 b=oHOAUQ5lNC0CiMqLt/gQcZoW3zsMyePVKEJjYVU7elx+gbqiIQnFS/j9N1yYQVQGKCc5NzgB76X2Z8wYGNFg0SF7cYyGUgvyomVqH0qKCbXw+q+M8Izff9W2MKiUMsbrPq3KbCTA41GQ25RRF6hIt+um485nIyrtlgloaFz6ldIGaL9/SdDGDxPGo+/1BytNZfDFwDaKqOe3Ao+kJorcaJt6AobyE9Jvb/NtKRk9knJIXb1jQWL9dQs6MXKjZsmi2d9jLCwpJ8h/G4QAHYtLB01fS6Sn4EIqr3ghaowtnpkwLTyshmNRgYlM9MPUs54C8/avaYP1pJcjC7cTRStq/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5802.namprd12.prod.outlook.com (2603:10b6:208:392::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Mon, 9 Jun
 2025 19:58:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 2/7] iommu/vtd: Fold domain_exit() into intel_iommu_domain_free()
Date: Mon,  9 Jun 2025 16:58:21 -0300
Message-ID: <2-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 603d836b-57b0-4ee6-d2b4-08dda78fffdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L4u02BBLd6CzQigbdz1OrYR0qQpSxkrMsVB+t+sHNooR7zZDVi9RXpkYbM/4?=
 =?us-ascii?Q?3f1x3swxnh50Btu0LYGdei6dme9aXkx8r0T5CMJvP7nr4XqCNJrLPArDz8Ce?=
 =?us-ascii?Q?UI5n6yQ56WIQrpm2vItrV5VdYNrjq+dIJhbegrjalkC63mU6+FhI8IwHEoLG?=
 =?us-ascii?Q?/I0+8TTXyv8klhE6MOoxK9kamiLUe661VvM2iXvGi7/l4bh8dkCaHMWrqE4X?=
 =?us-ascii?Q?P70K7MJS6e7ES5Ruhv73UUwvi/iebxAeJ35tZquV4cMVVPC2nVbMHodfvbfD?=
 =?us-ascii?Q?LFxeuBHGWlRmxuYo9E4bvN7j7B1QA5wHTawcoVtAdCKGANOPVlF3+LSm3q5G?=
 =?us-ascii?Q?4UgWhbYAx37WsdM9XYrn4NlK2OP/Ut9l6O4YwxhsHXGdIpw90uyUE1dA7bmY?=
 =?us-ascii?Q?H8NiaIH/AM75hlNwYXpV34AB+bpuaHPOoVE00z0VWq/65LVUUpmLc53A9OUW?=
 =?us-ascii?Q?GX5mNZMUNTJebhu+M7/uYNQQtzD/OaiR735Tag07xzDO/DJrwPHkkMFx/yHW?=
 =?us-ascii?Q?1FJJh08ILQvH2Cj1Yvab4VDzGdvBLCF9Fp66BgJCwy2FH8rl5sc/KBCSCONT?=
 =?us-ascii?Q?H7pQq7J4lGAzri9yfkI+5IutZ2T+SoqrGa+IEQCW71wh7GnSfeBqQoqpGghe?=
 =?us-ascii?Q?AftcLvOmsKprYjKzCRWYc6zAlVdeEupGOh3s+X7orn4VJPiqixw0Vmca+0ep?=
 =?us-ascii?Q?sI43wNdkiPxtIAj35SxkVfP8Vquw8zH9lgXdGmTwPadZEOCnM1O3hi0XohiB?=
 =?us-ascii?Q?FTwEWIQ8zg0kcQ4TOvhbPdjCo3/kGQnjCekcHQ6BSszq+C4hP68mEMcFNsep?=
 =?us-ascii?Q?nV78twC0KDboaatZ7lSUE2pI8S3fS2LSTmpLNTswYNDNctlxphtKlOO33/fb?=
 =?us-ascii?Q?paA2aUntSrGdZrZls9NZavw2rH0DSgZhdQg8WpRBKpmEhILvOfQi+HK41MAN?=
 =?us-ascii?Q?VIMuYajpvbKkpLDl6WJLayI0uhsPB+n9JnZrkG4UI5ChCPJ1lkia2oFFF+Bd?=
 =?us-ascii?Q?e41enMOu+JqvSbVh7pzVM+76QcJF/c2lzYdzY9bXM270d27CGLxCEIM66X07?=
 =?us-ascii?Q?Wu9D/KivgAKge+AAIjZWeQZiHOW9uwIfpcMu+3FAcTslub33ltr4zN1dSiU7?=
 =?us-ascii?Q?YHZUOTLpmzSYbv8f8O4HzBAjytX/zlM634qIrrQg2P6SzZtOEqtwRcPewIbZ?=
 =?us-ascii?Q?R2Y2Bl/hDyKBnGOuCTdaFhZ9HM2F9QJJUDvAqtWvjk/Qg3pfInLult+YdJAg?=
 =?us-ascii?Q?74r4B7tS4yaNZw7+5E9aNYXmX5u5x2hdhXWcnt7wOO5I2z+6DhFYuwDO+avA?=
 =?us-ascii?Q?x6k1NBAy6XQJp6ln+XPyHhse97F/Ec7O/06za/QtmJ3aFhjhnRgj+LxbtMLO?=
 =?us-ascii?Q?hBouhudYSspBXfkBtX1ohy8KT2wFeWc9orFPvoXVVXI+zf9JSw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YylgzZLR3xx4NfsS/xpeMfDOLDRSNsLwAcm7t5V6iSxaH7jgSKXhNTvX0oRH?=
 =?us-ascii?Q?71CrCcTm7qXo5F24ZpJhTfFneifBGHAXSyAt3u8ShVHBlhH0IigiUSmczYvj?=
 =?us-ascii?Q?kJIKsroB6k1zjYOEEru0u+is9y46ewSEBJvJRHzWPoFk80P3j8bsAgeOd7WW?=
 =?us-ascii?Q?pCMsC7W4Mu0jM3AFW6eNIdbw5PoT4d2Q7Rvxd4MKXLyPzs188cAp7MqKWh68?=
 =?us-ascii?Q?c3H0MRu6xJD6vhSn9TBLj/UeLKMwX3h8991F0BNVdBGW2D0Usi4RuLyPnLlS?=
 =?us-ascii?Q?Sd4wcZyYhdPkx9QgdrOuXjQlJpZESYFYiQQmhx0r/dEHrdbncI7K99k0r4Mo?=
 =?us-ascii?Q?g/HsXgFGlmX7HGlGTKc7x2M+ZnCx5m0uGpQSRBmsJSmHB6PaB1gUCCB1BgMD?=
 =?us-ascii?Q?76XRkbSXSRtJtb26PYoDreKGyEBdJfJZpOsBbyM0A+JAMIxtu2lYVjUCEt/y?=
 =?us-ascii?Q?GdCz4Qpkp3tO8KlhgQxe9h+IwI7+OVyD1vADi6JBbidaak02vJ2VnQC21qLX?=
 =?us-ascii?Q?SRnKjsTuGtL6qhQbCMCfgXo0V3QXrEVPmJEWZnqaIDVVWUW5g3PdiOel2dGa?=
 =?us-ascii?Q?xmsXOT6vY+C5/4PS9gka+u/pRrsCb/yaa5YrXZ/y6H8Y2F/KI634lDodTDqZ?=
 =?us-ascii?Q?0Z1exNOQA/mjMieDuwTwjdsrPz8Xj+wy/TX92jIgJ9r7KewxBChFBi1hDwwO?=
 =?us-ascii?Q?mmt74zWVezguItpF8n73d6zUVsKX8zlYy+rHBoQUAsuKyWTRFvs7ptPdvuxS?=
 =?us-ascii?Q?gmD+1MnEE6xp2grb4s1xR0SiFrXF7eNEFSPvIH38qJtZ5y/1HQdfSZ9B1oei?=
 =?us-ascii?Q?4uaZgdOlVUxsvbXUxzzqfLjkD1mleC0hZfemQrUHLgIMTVsD0B1LfoWlH/0O?=
 =?us-ascii?Q?fwme1GPX890SSGrtwvhyC9V+wssqDyOXLbd87gH5uj2MSbNvb2H2dP4QIBZF?=
 =?us-ascii?Q?TJ+8KcN8I9sVuRutp7+Fh9woLQRxnC28Zx8jOEk2VT/U3znWUDt2h8ox3z/g?=
 =?us-ascii?Q?gOdbti/55lkw+MFbRGgxcn2Q+8cM06hOs04XnjH1ZDvUo85Vjx1zGEQcXg+R?=
 =?us-ascii?Q?kKFl2D4ZYS2FcPIAs5hSaSM9n+YHoDG0Bb56o2W1lOyjAVgTPZZaYCVTgcQz?=
 =?us-ascii?Q?C9Q/I2nBZLUSvlNpo3Cp4qQHHTRE1UX1gluVXu2oA4s2ZVqphvIB2IEFR48c?=
 =?us-ascii?Q?xOggtAXCprwlclCJg/nKDt7+/v9lck0ihIoHFL7qGvS2YXaU36vUtP2wpB4J?=
 =?us-ascii?Q?tWLWgEnPMHghdZHsY8M8xphXkoKGxEJYqV4cz/5hf4sc8N3NVjJfm3LsFvFM?=
 =?us-ascii?Q?1xe2qGd+HhS8CZGGt/6Q+PcyPFF1lcZTuVVbAgoYUw56x33TDVbJeSuizffD?=
 =?us-ascii?Q?SWeFdIElYhJ0UwNO+ZVyCIlB7Z9ZxCz/Zv5ps8afkLUuZjCOynE3neejlFjs?=
 =?us-ascii?Q?eMIIzex4UtOANfjyzsn3vPDJp5jWS7VPNYMdQQSTen0WaG1bct6UDDKcvWUi?=
 =?us-ascii?Q?KpoGR4lyjfHhOV80NCcTsNh5vpFNyjRQjMNf7SraubjzoDPE29+f0ONg44IQ?=
 =?us-ascii?Q?p18pZ8JPbVrISgbSxAaiv4at7MzOvOhXKjVFv8wF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603d836b-57b0-4ee6-d2b4-08dda78fffdd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:27.3779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezJO2GFH8E3C7Cxl5yplHmFfzS/z8z76K+aYQNlmBHSqCFTYRq8glSixgjDuNzH/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5802

It has only one caller, no need for two functions.

Correct the WARN_ON() error handling to leak the entire page table if the
HW is still referencing it so we don't UAF during WARN_ON recovery.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b42bb091088ff5..ceb960a796e2ba 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1396,23 +1396,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	}
 }
 
-static void domain_exit(struct dmar_domain *domain)
-{
-	if (domain->pgd) {
-		struct iommu_pages_list freelist =
-			IOMMU_PAGES_LIST_INIT(freelist);
-
-		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
-		iommu_put_pages_list(&freelist);
-	}
-
-	if (WARN_ON(!list_empty(&domain->devices)))
-		return;
-
-	kfree(domain->qi_batch);
-	kfree(domain);
-}
-
 /*
  * For kdump cases, old valid entries may be cached due to the
  * in-flight DMA and copied pgtable, but there is no unmapping
@@ -3394,7 +3377,21 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 
 	WARN_ON(dmar_domain->nested_parent &&
 		!list_empty(&dmar_domain->s1_domains));
-	domain_exit(dmar_domain);
+
+	if (WARN_ON(!list_empty(&dmar_domain->devices)))
+		return;
+
+	if (dmar_domain->pgd) {
+		struct iommu_pages_list freelist =
+			IOMMU_PAGES_LIST_INIT(freelist);
+
+		domain_unmap(dmar_domain, 0, DOMAIN_MAX_PFN(dmar_domain->gaw),
+			     &freelist);
+		iommu_put_pages_list(&freelist);
+	}
+
+	kfree(dmar_domain->qi_batch);
+	kfree(dmar_domain);
 }
 
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
-- 
2.43.0

