Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63499244677;
	Thu, 12 Jun 2025 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738714; cv=fail; b=roBOLlu2REquYhmv/nRox770eUc/HZsVg6praHuEDKLiPL7G1W6i6ahIjVzyY1AUUiXE95O37Qpim7L8u+7JwAKUa1u4l44jJ3ROjW0l8FqRLc4pSqVYzLdxU8/dEQqcaTtDUztp4ReX+f3ZC+eVlFVV3GYUY1wxI2W+rWgEplg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738714; c=relaxed/simple;
	bh=L9hhzEuHKOwRNswSaNhRkGcGN4PxRoD7MJ25io8zCt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b0vaxEsyDeNIpIkfjh1XDG2mJnjIwkX8tcOeu84XHEjSnA8Kj0xkMANky3zyY2c2ygva8/w3V7tUgM2kZEdfaedOq2j82pN3he6+U0Boo1+zCKtP3P1fCC6CvBpF187gSaV4RQkzOxmpAubG/beZLxFxx5GnRPT0ePxGn1uNJm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lk6j9iZw; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lk6j9iZw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aFy33J3QnpSRef1WdyYbD7VW/kr16z23NU+2KV2rZC4i2CwUQGdHk0fIZsmhcUXAQ24y/W32xlRBIk4exM+BxboUHBRHyc35SVWM99fPGve3UMuBvs9hFTRyTCaVImtutO1U2IaiUeBs4qC+PiLGZyLhu7I/Fw6NwhEGov7ZEPnUh99GOeja2eJ0pFKaSsIDVlulzBk+CwGUoJf35KLyObjRwAoKJDtKIKqj2MhoKY5S1ve7lLLKoqi4rvJN7pD91a/hHtETA07Iq+bg1W7wq9ZfeSBLBBaMLzQ2OYgnR47TT2azFfk9l1uP7bvafCfb268rljTvr+kbFe6jsJJmBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sb+jUjV8SSxLOwBr4bkGUbgK3Wb/1R4d9khVxYf9BoE=;
 b=gnE8CX6Y+Dq4u0VyOC4FV+JKzXCdEMbv1mgeaOSMcQkOsOq4C99uJcbAqlTQkHWL4wtSGhpLwi5kJIR5lmefQTNRgcwk4c56KT328C2kulqE3sxfQz5ykYCqG81H6bgysj7KzHd112IRwOMO4UsKpmx3csCEsnng+FXtpsf6mVtF9f7kwrfehLkGZdiPpV+Ype9EgyN2UhxwhjRc6AUsPqC02tQ+uOZ0x4MqzHqQdxu50LArKEz2K9Q2Ya79nRcbyECwJwukIM0qrp7OEjUn92At3I/Dd4aT1iCJwEhiRZ0mvdoX+xPsi8d2uDKcm+zHKG3y5J1o7/BwpWVNYF0nYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sb+jUjV8SSxLOwBr4bkGUbgK3Wb/1R4d9khVxYf9BoE=;
 b=Lk6j9iZw3Fz1srqBjSF6GMzKjYBzwL17XPEH+rQSUBASXfGDUjFVqtpjAoDGfF3m9/yRixMkQ+wpLDjJ0Z7+CsrQIVw3r97ZDDxvshzGBqOVZfvOe7NOZuvf5pGOFaGtRE6EnbPFpfKjRLe1wdy4p6nF/H+0Rx5Uch0ZKy3d+yC2WEYSdKk8bf19zOyV6Y8ue6owkBmk2+EMW1XfTg0QmY24TBYIAdEY7yQFBZWAZwEDH4XBZ4FvzoVg035Q4ca8OlgsRRbXi4UXYivIDT4uCm9Go8s1aJzjGrrMbQbHV0rM6DJvca1xtBIaEJi69K3ybeBIEOsEFD467bYfPd+euA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 14:31:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 1/7] iommu/vt-d: Lift the __pa to domain_setup_first_level/intel_svm_set_dev_pasid()
Date: Thu, 12 Jun 2025 11:31:33 -0300
Message-ID: <1-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0065.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: a198e587-596a-45b0-34bb-08dda9bdd922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cBJoZYdlfpPIBsf0AmsuhBAPNqlbSlnjzsVBrn/o1o73SgVBWBu2+TiwG/72?=
 =?us-ascii?Q?yuCHTz3G4A5rIV6gVQU5rslANqclE1muoFUJRRlXtmYEz2aFHNTLbPRHIuqE?=
 =?us-ascii?Q?kV0jpEXq54niSpUs6rTzgM9SgdmOLu9xzeeNrU/nHe6w4fmZ2y9X0ifdvjdf?=
 =?us-ascii?Q?IaFvAXeSkfZKQzMxKWBJ9WwpNrhJD00rZcQ2faIeFHEzbLKzEV03/qR/qW77?=
 =?us-ascii?Q?q6WY5zV/rKzEwHavo80U8qhrvbILwn5LACu6gvfFy13EC7xTuux+i1sLZ8Xn?=
 =?us-ascii?Q?dtm2cnfoJeR8RUKr/jG3lAZ+Jj6QhTtsPVdu489Igyczp+cATLIdu6/Tzmb4?=
 =?us-ascii?Q?d9gT6rTDISZgkrPmu1Sn0lYE0bj/kMaNUe9+yZJVpr6pns5otG4ZHG7XDUVi?=
 =?us-ascii?Q?67JkWqnxDf0O+1v1m3N881jX7hEbWcVob1MDbmSPVK16mKbySq7hbpPIQbFK?=
 =?us-ascii?Q?ecJ3cjn+LPsA58ekEAzswqX3l3pS6ADevLSCaNedr34CCLhZMaKUXQBqPEmG?=
 =?us-ascii?Q?2QdYVv6mXZMoYCXtD/qv8a6FDnlOQIjreXhKF7J+AX8St4AppwrsN/64Drbh?=
 =?us-ascii?Q?nl02tbRQbdf9O7gm7o7eBx/KvZqH9vzJ1tT0M/eBacNRNJaZjNrZNOZrDa78?=
 =?us-ascii?Q?UUQbERZAJSTp6U+EIXf0P5J2IhPUZzyobzVZ1D2MZtq/8RO8Ufddlt4shEoR?=
 =?us-ascii?Q?BCPiAppsVycPnkodv+9XBH/aBl+5d6CY1cFc2yMM29H+VCHj8/7OLUMAJmPv?=
 =?us-ascii?Q?B+IVnGfR6Exe+AErDVmPWnARvS/51s9UW7DWktLvkdmZvWSJj0YiZ0Dx2mOs?=
 =?us-ascii?Q?47fQ4fB+XjmGZRaC/Oat2tqjQf2hKHSOLj5oM6BeMK0PSiUpCEYxykg0l3y/?=
 =?us-ascii?Q?oZAIfoSTI5iMxR2naBK2qm0fHRvyQ32bC9XRG/AccpfNe5cF+TUiIJVjT8CZ?=
 =?us-ascii?Q?22SZ5jKVE32USLMiLfiPEEqwwYfQDiwuHKP20VCiym9Hdd7LTXsPz5zTvU6M?=
 =?us-ascii?Q?2hPiBQs+bOnYastxH26MUzTs2k+Zr0I0uCjP8OMgNoU8QSZLgAz/vbuXSS0z?=
 =?us-ascii?Q?4zWT7XbXT1ntCsWFe/AmWe5TE2V0U0/DbMpgGCdx0YjdBOKoF9T05wAtf6t0?=
 =?us-ascii?Q?fau8GyaOjeUNA/HQzfEvSzKxIJI0zlfuJ/DznoLnRcUlKHXgatOYKPDFX4s+?=
 =?us-ascii?Q?U+XgWznG78A52wi1qJofp07UZI5OoQZk31OHRdBu7C0hqFlv8Jkb8HFvS3tI?=
 =?us-ascii?Q?WijwQMDTyoLJjkyojpeQttAJGUTnpElq2HX9Q5mcCz+UTXxDck3fHsXork82?=
 =?us-ascii?Q?fhClYJPjepT2+sAN13T7I2lxmQqXmN6kObXDjjrfnVkpk0QhP3Uq5DJgQaiW?=
 =?us-ascii?Q?LhLMhWT5zU1tZZQU5GU0z0S29UuaZ4Bpy/SwNVa6KwFycZqNOQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wLAJ4NwooEJtVCQL4uQ1C6JmE1hOuBr9oAKT8viG/Hk9XMz/tmbeOcEIxcm3?=
 =?us-ascii?Q?3I4o1vlgoFyCeiktIb7ChE86U858k7zr9yOWdz6CroSN9FSrZWylXFEus2g6?=
 =?us-ascii?Q?7kYg2P0FT7dIOXpF/1p9QuyKIKBNxyA6cPxrKjZjLofNzRtr5rE6GT28s68O?=
 =?us-ascii?Q?xuYzQN2DIzZ9Pcf61GxUd6qjtPI1iKGeesFjR6PK8hbPZHs501SqKpb7hahJ?=
 =?us-ascii?Q?n6P2uGc7J5f6EgLSErdeiSouV9/OUUQT7+L3EsN8COdSiaM4Zs3z8FCfWNvX?=
 =?us-ascii?Q?c48oAixl30MNh2h+zbN/jkkigh5pk+9sH6yrpfemWZpO+z+bh/GMJ5zN2QEo?=
 =?us-ascii?Q?Ksp0l4WiIC4CN+Boeg2lNkKRZDCx1gqYzizFsHO2lJqms0e+121Y4i8op0cN?=
 =?us-ascii?Q?wD+0QdCRZ/sMzvw/dM60mOSE/EwpyvhozLzi4xJjUfL1X+yXqg50FlwenGhn?=
 =?us-ascii?Q?4fMFYSu8M1TnbcI4a9hronZbQ6+ivnUkCWtwLXUG0bOL+13njyY9oArR6JBx?=
 =?us-ascii?Q?n/0ijRBMr5YPQNXN1oWoV0YIONrPyozdmaGtOzI/Ac9jTfiWqK0rwevaCBeW?=
 =?us-ascii?Q?GCkFXVR94b3n9rTMt/W6huS4iHJySps0B8DT7MO/sBj/M+FTAPHgXFZ+u7I2?=
 =?us-ascii?Q?EU/SAEBsezcbxcKa4in4VQMlarKOurJ4os0ljWQHDc8Mb6XiBf/rmFXzgl0b?=
 =?us-ascii?Q?2AeYBH3ZaOqfK464w46hoWR9FQwKUT1ORwG+J9icGb7stsU+1iV4HWCML+Sb?=
 =?us-ascii?Q?yzb7awbTEBmlZUnnaN8DrcI8B4Z7xDp68DiyAL/3m9PBBCSRnAT7CUJkAH+o?=
 =?us-ascii?Q?mbNDY13PVd0Gw14/cCdiu6UGvlWPOFCevWIS5BEuYxZHiLF82adTUzNS4dDZ?=
 =?us-ascii?Q?PDVEe5FHSEq0NMTRWvKDS+pGiQq30I0MBd1mrzqDg4vmnC5kiUeeG2qnw5Cz?=
 =?us-ascii?Q?GMv504BNh+JkJlS7YHJzpXBJcn87Pe3orB1SJBvj4rywDJUVDPBhzX01CmtI?=
 =?us-ascii?Q?aJ+/3nJvc2YclguRy3j9DQ5fqeG3IFfRaOmxXp6/xiU7ye5MlO3qWTQBlGZy?=
 =?us-ascii?Q?tFjhFbnZ/ykHlgoNwPeGDBNIYDCpcH76nL7bQsP7zIQh5AhCSjNT8mE6mitl?=
 =?us-ascii?Q?zQrfYRTLQcc5ER3Ua/MbS5gGBmlv/qM9oWgiqWJHbdHsuVS+Y6HIZDPOHh88?=
 =?us-ascii?Q?m0lAiu8oygQi1nB/myElxFB8py7TuwMSTaER9AeSeEVhVenTogOGTMraNSrt?=
 =?us-ascii?Q?S14xcrWMQNocb0LntCDtQBR4MlI2Fk7rVTrQx/0RrhY0AokFmf2qVFyS7eZx?=
 =?us-ascii?Q?3FS4B0GojPIHbeQm2aehEUuDGJzStdxhc3krrytncytjxQoV0xx+hwhx783M?=
 =?us-ascii?Q?f0gCZ5NJXAW+yJ8rmRo9JTtiv3uAqoOcPZt7HJfeW0pRjqp7Br8Qis1cN5Hd?=
 =?us-ascii?Q?qGIKxD8LsYFdUaedlegFNWnSDOw2z1eJgVxAYFH4x0VZbapt8kpqWLvINQTP?=
 =?us-ascii?Q?d1V8tzlOW3dYIGE43EeFyYJxihTATVECu76T8f1BVjvJokfsO1T5sialgr+A?=
 =?us-ascii?Q?YFPvwD1rY1mtV2kzu3tsyUI4GhPX38acIks2PuWA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a198e587-596a-45b0-34bb-08dda9bdd922
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:41.5374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+u9FSkxxXnppHBzbRkX2er7NlysbOBWncD1aopjuAGGGxXKU5eWt9z2hfkPOh0h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

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
index ac67a056b6c868..52f678975da745 100644
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
+				    struct device *dev, phys_addr_t fsptptr,
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

