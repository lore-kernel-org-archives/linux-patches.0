Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674D621FF32;
	Mon,  9 Jun 2025 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499126; cv=fail; b=W70lIc3K7oGVS1xhBxFGwVuqfxwLal1tlXYb7aejL97cJQIpaLZDcNMXfwzdtiRF+L7bk29W7gU1T7KXf8vhJIUEeYCkK6/oyiLWxJkxL769Az3Fvp37FiW9j0CITw3vNij0vZ32BWT+oS7N0Ku5fNuFHXVdUv/dm01p2fRpP2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499126; c=relaxed/simple;
	bh=xLrHcN3Wsdv45kkv1zddSWc24lXY19gBFv5wZR8dcJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h9K2jU3OeSINAEwTnCtMCsd8cfDS1pNgxstirJBJbcHZ98e4te3TmohSI8Gr1+sCECfu5kh0L58CGuBiJ2IcEk8Qj+llkM+Nvidi+f9dMbUt12RymC6Lv/4Rue+4VV8JgLl2lxNcCjwobe9Kvr6tJ04CEaHk74EnEnaGJY5cqQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YNhPEDXi; arc=fail smtp.client-ip=40.107.96.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YNhPEDXi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQTjRjZzhX7bMenaT2NYuKTgj8+DoA7dsP4Z46idKVw00KxU/xb7DJLGVTIrwb6S8CO/OerOCU1XTmtMicRLjAZQNhI9Sfbg49AMQjKXZvNpjjWU3vP65vcY2xmoer55YwHTkFC8OHLfzkTNI29nndoVArwFmpjJ2ItaiZw7Qri+zEdDxEaZmds9+RlVW+Znqn5PmINun1j5an6Dx3qyV2hvYhi+El+JB/9SfdnMGdTt1dSi+g9WVpGm0h58204o6qOJrNP0fA/cpp0ZlebMzUSt8tYDYKDZO4e3KfXtw8uJBcgk3SOUTeh1OpJVKKphA2j8l8Z5hul3Xg6juqdIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9yX/g2mtUd8viuIo/vfiGZ07JCvVpGSw3C/fGrxbJ4=;
 b=cnHYwNIbHATzGuKWKVrelFxgAjBwW69dTn34nGDrYn55tImsXcZ3VDLR+emYb+lnr8V7T59NSbdf+gxdp3mgpbQTfilqHH+92i80IHqfbTnfAIbNVa1Z+C/xIUx4YeWvQFQyXz01069o5SctrUDCtG8jZoUgpounYsqMdIQqhsE21kfIV/0lMmu7WZlSqW77qhpyyUaPBBb6+zcRVbCON/LPfuX1+bQ8z3WQemcL/qJ8p8wOC2uRf+vpMhxYkZ7kddJRCOiQklPcCaomftDl43SiKCG++Fzfos9es1fnYhWSJdi/OCyiObJUB3IDozbVblW1dL3pi1BGDqmMydugjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9yX/g2mtUd8viuIo/vfiGZ07JCvVpGSw3C/fGrxbJ4=;
 b=YNhPEDXiFBH8088Yfslw+qzWr/6pYvBCqY7gY0GuzEouESQWT6f/p9Rvz9cQHWZNMpOa74nrevCrDkX56ulItkaQuO9tuKsP7p/rrfHj/hCLh6F+fjd2Rqe3mYa6uBjXIUgQOiWsTXxf423orGG8+ZgvAyL+CwNR8OabuRWesQyilYjISzWRXPVlCjWunLFNTeFukC2arx8AzlNhlsg2KFyoK0jJoElht3h1pnAo7/lAW3aTZ3sfJC9IyGo5914AoNSTSyr+uFyg3PsOIYriOgHBq0vsGdBw7uNWcBviA5mge+3TFAXs2MMKBf5+JqdjoX0zF3i1N+mq2491XMOr4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 1/7] iommu/vtd: Lift the __pa to domain_setup_first_level/intel_svm_set_dev_pasid()
Date: Mon,  9 Jun 2025 16:58:20 -0300
Message-ID: <1-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:c0::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: d602e9a9-03a9-4b74-9613-08dda790015c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SX8ruLPRJldnxR2HzNQnyQYGAVOWyfWvNSfy64E14l4hUwT4GOn5iU4yVX+N?=
 =?us-ascii?Q?22WYc3xxyQqf15T5mhN8PBYrdKeVA/XK6NgMRjeC72inl5Ae3mqGpQzcaWlE?=
 =?us-ascii?Q?I2XkPIYknceJOAfxxz6CL+pVVaePLqkG6BVseEAlNFEfmEGAvv1sRXFfshLv?=
 =?us-ascii?Q?lMrTWfSpJyQAm1Deo9vsGsoTZnLK2govuZZ0xa8aefgxUUo211Wvmk5OoXQx?=
 =?us-ascii?Q?7VhDgRTHs1sKVXtft+rJkzfH5pzG1N6WVrbo2QRq1NGNXl3pF6CEc0p1fkv1?=
 =?us-ascii?Q?OufslC2a7kerffvV29bmAUJ3RpmqQTVJcxPLY6mTaW2k+868Y9vGSYgRNvKE?=
 =?us-ascii?Q?1RFDihNr1jZSflpWn/BMHAoppIIeAHZcAXDInWNatvWEafxgaVEzmR9VRU5U?=
 =?us-ascii?Q?Atv6U16ajdlFhZ9i4nBX9hRBShNo7Gtsp6audJ9ZSCi+kV3sKPJDeP0sewOJ?=
 =?us-ascii?Q?UQGghtMChutBXSTrNkBWtA2vpnC5GFNJACf8L8T3XGiE8LNpHhl3rsPirF+V?=
 =?us-ascii?Q?0mToyULUV9b4UgzMbQAEL4oeCyVlDFuFnhQN06EKhDlPrA7SJc3uh1lRYj/m?=
 =?us-ascii?Q?3+e/f400QAjaGmepLIQWTrZ4PgNToD1zK5bTNihRpYh4E8QrKiq2TwAf6k7v?=
 =?us-ascii?Q?ReUlfGDIigNULHmdaQzq6HmdVwJI1Q5/IEwoL7sCQR8ewChLEVoS1HiPRhRJ?=
 =?us-ascii?Q?8WWRbH4Q5XZwe8ZAC3eKa+MwpCjU4V8GSL+VzmRTY19FOirPgVUtAmg1tYsO?=
 =?us-ascii?Q?QUnSc6mrq+Cj40g1ruU2osake89GN2ks6o5YHQuxd8LlaoapCwdL4KAN2ajl?=
 =?us-ascii?Q?L+pi0Pj2kwwg59RvDVAb9h6cX8yyuzid/EOdBgrOsM00QmWdMZdE3kRsiTOS?=
 =?us-ascii?Q?2y+YWErPmXc7q4tEO0JJ0CWdfLTznq5XPoyC1EplSy8E/1pygVv8TEOQDywu?=
 =?us-ascii?Q?7XSLZm6g3R2DYum2SPRY8C4OMrQzvpPeth5cagzII9gUuE0qiznBOcnGNDgZ?=
 =?us-ascii?Q?x+9R9+KGlEutvd6ulcq2MgnCsxc7FKpCx/Od2w4MRRfuvGqgZYkQ2GjbdxFG?=
 =?us-ascii?Q?KudQqb24OVv/HrzMISXF/+xk+fUKGoaX086l/YmJT4lK1dBrysGQWbEfXy+k?=
 =?us-ascii?Q?fjc64zAInCR4RYS4oIzh7jh7pMcPNZ4DapRnaxdPPJm6NJmWK41f6U6Xf1PS?=
 =?us-ascii?Q?cQ3Dod9R109DGgdYbvhJmUSFsdJg+MxLnVMXLTWz3lDRiVgRNkaUFejceVU/?=
 =?us-ascii?Q?kyX/kKO/6MiRCaI8rsHToyeusStMNXJmbrf77sf99bqcrm3xx24RO4AmNxUz?=
 =?us-ascii?Q?Jv27jM0SDEroCnRJWnJcEdtJrHgneayOJDETWO/d0CmLv5jAH0CrQp08Ee8j?=
 =?us-ascii?Q?6FBWdATwMZFPLoEYonwRpbOlUmdbwazGHsc7v+ui9gYKFkZNaw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nhvcbwy7fShZTZojOx90QbRL/XkxN3h1NuDRwm6RULhR557QK9DCbP9mdoF4?=
 =?us-ascii?Q?N4cTzvr9q+adfQbjrmNkLwar30aS0E9G6smP4IejhsJN/E33+bfIIUvB5MX9?=
 =?us-ascii?Q?GYMM8ri+rUd0RRt6ujd+ec1ylK23Gi8q/37/lzDE6qGobh7clJOFCCOWaOUj?=
 =?us-ascii?Q?PDy0ABhyuJrVmEbgMcaot5DY2cYKnXubnqMQICD/pUCEatEFC3aBOCKLb8cT?=
 =?us-ascii?Q?64OH/FypElLs4dJaTYSDsDh1KbPKMVLEZl0Y03DbbYMEvLf7Zaz1NYttsoLr?=
 =?us-ascii?Q?+rXObUpHNNDYPidpSBDpxlBEE/mN0cLudoGyttLZgj5kBrdQI0ey7RbkcUsd?=
 =?us-ascii?Q?pqPMTuRYTyHidmggixeZfiQXocC2MZa0xBaYLBdDTspHoQ8Nz7Cp3YzDm9I4?=
 =?us-ascii?Q?dBUzURvjH9cW5cj3e1BkNVFti7xQpyAQl1pu+wwNP1DriOPxBJwidftvwr/O?=
 =?us-ascii?Q?voSis0CvDadJwvY0RgTwTJN6ZsA9erne1bJoN5WHKvP/ESerlCVMqMufgJnv?=
 =?us-ascii?Q?8evl0o5bSWTyDFtNT1WYccaHY84+/lwgI2qhDcZV+JH3cWNsyeIIr2KXiwEL?=
 =?us-ascii?Q?oZAKtF6f7kkNkSZp0RCPOD5/8Txn5UAggxDbAyEGU0MNKvMpraHcFZ9lqNAH?=
 =?us-ascii?Q?RQWlwe9YR24vY7RGU6EMC2nfPGvznTji6K+eWM6g54YIRPMapYML+7DoVekj?=
 =?us-ascii?Q?c9moJE8M+WddQKbnk/Ncec+OQFuYIE0HpHU71EEfBE2DCtOURRWT6vD+LM9S?=
 =?us-ascii?Q?EyP7ZI4Qz2sVk6KGukKcJdkVfk0FlTFYMAcAlMi+UOPe6SpDcuc3897ghTCn?=
 =?us-ascii?Q?d25EUk7emlbQHxOwynsXr77Y/+prRObJp6f0l6ZQh3i2pdIlszLY7KnYJ186?=
 =?us-ascii?Q?SRW5NrjhlWwM3CnTYXwD5xDYhBqkPUR2S3C+H+jUnottt57AVFqOP1t3Myiy?=
 =?us-ascii?Q?CKDmI0aS2H4H6rMgPqCkha4rkA2JF2ejtPw4TkVP8gYyJ/LN5bYLzhfDB7Yg?=
 =?us-ascii?Q?dYOPUbjwZydwim0oIwt0vB4drrBxsUOPaGPL+brE1lVjAsDl0ZhwqkNMldjS?=
 =?us-ascii?Q?Lhg8SUHHKXcF5XIS/0zOLUTuuH5D3oWXy9qWN1LljBesNc8ncq4KInPO/FHK?=
 =?us-ascii?Q?Wgcyi8nFFeHMJF8ONnh6RZ8AAN0+heDfZaDt9/b+lnqb3dAzaPuXFJhVvpwg?=
 =?us-ascii?Q?G8cZx+UKenmewjI4cQG1NyXpcMmN3uDDQSMmTk7Ss4xwRjEn/0b1VLkcO18X?=
 =?us-ascii?Q?1RAwyrlB8VI5rNUI5z8b7sZDZtjt4yDwZZ5QBtABYaDBrAJhMLiKmmUkaV6V?=
 =?us-ascii?Q?xM/qLY9FbvZHAwiLCt7nEmRMuIKrrEKJLIVUUZd0/siKmFVbzXc0rdUONIib?=
 =?us-ascii?Q?syZWRFWe8837OdvapOT7dBsPwv5RdsGcwofJOzkYGOkkj/+o60lRkyWpuLP5?=
 =?us-ascii?Q?XD8Axyeo3f0jtt1HgyjDxz/x9QIr24F3X99+U5Haesbt5J69QBh2lQqI3KRb?=
 =?us-ascii?Q?9w6BKosNtmNLEvx3nnunNckCiLjRMv7WjprCL4LDo9fqAuw7V3P+Nf7dOlUm?=
 =?us-ascii?Q?YLtLmCNldXupDEi+zL7TMPqbB+Iy0FUlh5FZ3j0l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d602e9a9-03a9-4b74-9613-08dda790015c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:29.8916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RfZHEAtnsCOY4kDTmpUW7TuGgDXgfQ/EjQxI5vZthBbMg+NXiX2MH23cyBesQ6ZF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

Pass the phys_addr_t down through the call chain from the top instead of
passing a pgd_t * KVA. This moves the __pa() into
domain_setup_first_level() which is the first function to obtain the pgd
from the IOMMU page table in this call chain.

The SVA flow is also adjusted to get the pa of the mm->pgd.

iommput will move the __pa() into iommupt code, it never shares the KVA of
the page table with the driver.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 15 +++++++--------
 drivers/iommu/intel/iommu.h |  7 +++----
 drivers/iommu/intel/pasid.c | 17 +++++++++--------
 drivers/iommu/intel/pasid.h | 11 +++++------
 drivers/iommu/intel/svm.c   |  2 +-
 5 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7aa3932251b2fd..b42bb091088ff5 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1736,15 +1736,14 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 	intel_context_flush_no_pasid(info, context, did);
 }
 
-int __domain_setup_first_level(struct intel_iommu *iommu,
-			       struct device *dev, ioasid_t pasid,
-			       u16 did, pgd_t *pgd, int flags,
-			       struct iommu_domain *old)
+int __domain_setup_first_level(struct intel_iommu *iommu, struct device *dev,
+			       ioasid_t pasid, u16 did, phys_addr_t fsptptr,
+			       int flags, struct iommu_domain *old)
 {
 	if (!old)
-		return intel_pasid_setup_first_level(iommu, dev, pgd,
-						     pasid, did, flags);
-	return intel_pasid_replace_first_level(iommu, dev, pgd, pasid, did,
+		return intel_pasid_setup_first_level(iommu, dev, fsptptr, pasid,
+						     did, flags);
+	return intel_pasid_replace_first_level(iommu, dev, fsptptr, pasid, did,
 					       iommu_domain_did(old, iommu),
 					       flags);
 }
@@ -1793,7 +1792,7 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 
 	return __domain_setup_first_level(iommu, dev, pasid,
 					  domain_id_iommu(domain, iommu),
-					  (pgd_t *)pgd, flags, old);
+					  __pa(pgd), flags, old);
 }
 
 static int dmar_domain_attach_device(struct dmar_domain *domain,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 3ddbcc603de23b..ca6843973d4393 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1252,10 +1252,9 @@ domain_add_dev_pasid(struct iommu_domain *domain,
 void domain_remove_dev_pasid(struct iommu_domain *domain,
 			     struct device *dev, ioasid_t pasid);
 
-int __domain_setup_first_level(struct intel_iommu *iommu,
-			       struct device *dev, ioasid_t pasid,
-			       u16 did, pgd_t *pgd, int flags,
-			       struct iommu_domain *old);
+int __domain_setup_first_level(struct intel_iommu *iommu, struct device *dev,
+			       ioasid_t pasid, u16 did, phys_addr_t fsptptr,
+			       int flags, struct iommu_domain *old);
 
 int dmar_ir_support(void);
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index ac67a056b6c868..26561dbbbaaac2 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -348,14 +348,15 @@ static void intel_pasid_flush_present(struct intel_iommu *iommu,
  */
 static void pasid_pte_config_first_level(struct intel_iommu *iommu,
 					 struct pasid_entry *pte,
-					 pgd_t *pgd, u16 did, int flags)
+					 phys_addr_t fsptptr, u16 did,
+					 int flags)
 {
 	lockdep_assert_held(&iommu->lock);
 
 	pasid_clear_entry(pte);
 
 	/* Setup the first level page table pointer: */
-	pasid_set_flptr(pte, (u64)__pa(pgd));
+	pasid_set_flptr(pte, fsptptr);
 
 	if (flags & PASID_FLAG_FL5LP)
 		pasid_set_flpm(pte, 1);
@@ -372,9 +373,9 @@ static void pasid_pte_config_first_level(struct intel_iommu *iommu,
 	pasid_set_present(pte);
 }
 
-int intel_pasid_setup_first_level(struct intel_iommu *iommu,
-				  struct device *dev, pgd_t *pgd,
-				  u32 pasid, u16 did, int flags)
+int intel_pasid_setup_first_level(struct intel_iommu *iommu, struct device *dev,
+				  phys_addr_t fsptptr, u32 pasid, u16 did,
+				  int flags)
 {
 	struct pasid_entry *pte;
 
@@ -402,7 +403,7 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
+	pasid_pte_config_first_level(iommu, pte, fsptptr, did, flags);
 
 	spin_unlock(&iommu->lock);
 
@@ -412,7 +413,7 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 }
 
 int intel_pasid_replace_first_level(struct intel_iommu *iommu,
-				    struct device *dev, pgd_t *pgd,
+				    struct device *dev, u64 fsptptr,
 				    u32 pasid, u16 did, u16 old_did,
 				    int flags)
 {
@@ -430,7 +431,7 @@ int intel_pasid_replace_first_level(struct intel_iommu *iommu,
 		return -EINVAL;
 	}
 
-	pasid_pte_config_first_level(iommu, &new_pte, pgd, did, flags);
+	pasid_pte_config_first_level(iommu, &new_pte, fsptptr, did, flags);
 
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index fd0fd1a0df84cc..a771a77d4239c4 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -288,9 +288,9 @@ extern unsigned int intel_pasid_max_id;
 int intel_pasid_alloc_table(struct device *dev);
 void intel_pasid_free_table(struct device *dev);
 struct pasid_table *intel_pasid_get_table(struct device *dev);
-int intel_pasid_setup_first_level(struct intel_iommu *iommu,
-				  struct device *dev, pgd_t *pgd,
-				  u32 pasid, u16 did, int flags);
+int intel_pasid_setup_first_level(struct intel_iommu *iommu, struct device *dev,
+				  phys_addr_t fsptptr, u32 pasid, u16 did,
+				  int flags);
 int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid);
@@ -302,9 +302,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 			     u32 pasid, struct dmar_domain *domain);
 int intel_pasid_replace_first_level(struct intel_iommu *iommu,
-				    struct device *dev, pgd_t *pgd,
-				    u32 pasid, u16 did, u16 old_did,
-				    int flags);
+				    struct device *dev, phys_addr_t fsptptr,
+				    u32 pasid, u16 did, u16 old_did, int flags);
 int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 				     struct dmar_domain *domain,
 				     struct device *dev, u16 old_did,
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index f3da596410b5e5..8c0bed36c58777 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -171,7 +171,7 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
 	ret = __domain_setup_first_level(iommu, dev, pasid,
-					 FLPT_DEFAULT_DID, mm->pgd,
+					 FLPT_DEFAULT_DID, __pa(mm->pgd),
 					 sflags, old);
 	if (ret)
 		goto out_unwind_iopf;
-- 
2.43.0

