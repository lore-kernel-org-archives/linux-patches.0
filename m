Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C0F26CE2D;
	Thu,  6 Nov 2025 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762455744; cv=fail; b=jA9L6OoqbJaAnpeBvfeN55ZsrEbiFzGEBecBAbOWdayzVMpoLRhJUzpy+xDh+qoWQzmqArTBk7hTb2l9aHTG1txENsyKSfZJBvcCJv5fb09kSdUCQ3tF+eRKw6KFdqvwth0AJmhpFQSpbq5bQEYMWoichDmE8RetqGv4IpQuFmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762455744; c=relaxed/simple;
	bh=Ka4Qyey+ffqtn5YCVzyS1UE3wnmoiZ8Quz7bPr/iKqk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=a8iRDz5IH5KzHBFFiKpJynKs2mIxf4XScU9UVdpGpJF4RQQXGqpbGa9I7+YLJO7OpmZHLZOwRxGwhPMRjuMeFZwpj4ao/Jr6Nx3iJcj+SDKB+qo1YvJ09eO68TQxJmY2+X56FakZXX1GoUarA8hraJnxrL+GPJnZuS2qHST7Bwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pm7UUlQO; arc=fail smtp.client-ip=40.107.209.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pm7UUlQO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pxDtomKfw+DwH1ZQzN/cmfLb0h4DwsPhwuYal/NZj2VT4Jg7IFV22bK+sLzChOt/UlKsVTY9HdrvhZSuViAjatyLGvW2ghHzvpkfCE2E8jdkVbnqosb07kW7XOuEINK1Vr/63CrtYHPTPTjgRJ9s6JLavgW3f5C/dn9nSdslkrJbk8wQzi+ohw0HZawAgLUTfo8yy+8TLnlkzOZbOp93yD6erg0IAXFSTwY2mjXrzTZVuaM794qTcts2DfMDcWaCuOdfylYiGd27/lEcuUCM1JIstlB1ILcyqPSYYd53gmEQrDqplfVFqle+rnYZB59Vx0sTZpwtv7hcxWmf9BRdHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=heYE+Zj9XLSFIof09QeBQZyYx0aokTVHSWQ1jZXMPao=;
 b=XoAO4+EOc49f7XQ4gZ7XkA031+a3hNZlY9mvhmpRNhCOZD5SMcUXATX/f5qjqs6IlHDYxA9I8//ZHR5JJdN5GfSBQT2VACjwfS4G4oOvnuguB6GmXvFcu0j0AHnjZwtTHYEi/BTmM11VGxZ12c/WZLx+1HNKPytRLI0A2uBQ7N1CWlfU59ofJzw6844OFHPjrbtMgnGBIKVwCe9nqm1ahfTxv4de+4R2CUk65yzNAVMT/xWtmhpPph5FTsPCn6+iWzzV+Y9gyDw5H+W1Tle9i0UcUgExYFu36t93r8sF5ACb49EgzW17MVyHIZyN+XyOaGg8P32Gn8/UcZmeln4W0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heYE+Zj9XLSFIof09QeBQZyYx0aokTVHSWQ1jZXMPao=;
 b=Pm7UUlQOVMK99LJdq/ttcFdOoPysS1lCWgoPr9G7gUQpUD6q17sMnnSiafIUd33hGSEvVtAzbOCPzv7/cOxBKt2phEP6w1KxgaIxVNg0e7Fg2a27S2yRIkcbV+IVswk7jrRv4439FU9zEeBxB3ZweOcWfZLfxhRzN9+lKClpbGpFbzIz8ixFvBT32J9XNR5n4iSBrm/Rs5xzA+xsZAZH4HPqc5y0zpURzvEMG3pQBUKWGDNTPbuq99oVFJeVOIShN97sxdWrh0WaOsmjCjIiqgPCjC44xsVwFMNkqEod0GG5M9CS5UWqmZNBo9a8QFpFOHuhmfiNQtVfkUXYARKYfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DS7PR12MB8232.namprd12.prod.outlook.com (2603:10b6:8:e3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 19:02:15 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 19:02:15 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-doc@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH] iommupt: Documentation fixes
Date: Thu,  6 Nov 2025 15:02:14 -0400
Message-ID: <0-v1-e93135a62eee+1e4d-iommupt_docs_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::23) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DS7PR12MB8232:EE_
X-MS-Office365-Filtering-Correlation-Id: c40c88ca-e939-4019-e904-08de1d66ffeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D3Hbe9kTR5jy0k5VuTLP7lJeAKU/KkfRqZemwVRVJjpJO972rLi4jJHwPcB/?=
 =?us-ascii?Q?Rgqw04ICld5YLafPjY3FwXUryjPGZx+HbuYy8MDsJQkDqZ4vJr3Q5YSa6BwB?=
 =?us-ascii?Q?fW8kjtMqzHVl2k7DQU8WMNZxyfKDvT97PwhiafhA3JAMAaY8E9/9VXnL52n0?=
 =?us-ascii?Q?8Hx0DYpIY5I673VqpX5nzXQt7MfFOEEUfsuj2pTALzbE2Gura5B7awuWnLak?=
 =?us-ascii?Q?uMaa4ExrAzXsGiatyhuPZhIHcjpvud6sjIx4sqomZl5VNLBn3t+5MiF+AmTY?=
 =?us-ascii?Q?Evtaww7Zb698sokX+ZMxWei8P4SsYpoD3IgTHcIsj3SAXXmq9OxxRazxhYGk?=
 =?us-ascii?Q?y0/y5bq7dvyRvTjqdhLJQ8QdEgQs3hBrAyu3QfCsLOltOZmDAJ8icR9c8reY?=
 =?us-ascii?Q?mbRQBUluPlMwQugH4wIm0zdBSou1oXnkAQkKJS02bNv+8Nxs91R4XJ4fiff4?=
 =?us-ascii?Q?5RycdjYMQR3vruvf9de1XQivawIYyd2/N/99oo1cIHFg+aXP0YerhFTsshAY?=
 =?us-ascii?Q?EX0sn3Jb/6pc6RAvCXPtIcGjZdPYrlx4hUWcy8ICBymAvUA9/LSPxKe0qGkE?=
 =?us-ascii?Q?fEfUVyfXqC5wbRxU8a6d9oFx3uJ8XAIdi0fZ+PZCxh2QrXIfSQllXSUz1pd1?=
 =?us-ascii?Q?EZ3wfYWikBnpVkFsaTeqZFjLZJwA8O1a1BhfWPTvE3uJPvrGxkM9+ewdIchA?=
 =?us-ascii?Q?U/0VYXjziMCNF4bPZ0phLeprd+zYMoUW0lTMHtGiYr3t2Flj4QLuCC0gtyUq?=
 =?us-ascii?Q?WdpQICtvJ8yeWsAFGUrhMgpDPSjt4UqgR9/D+vPH0kMrKYcGXPAAHinhA7Cp?=
 =?us-ascii?Q?99depQJbc6Z9ZOuuRjonniy/fELkhbRwKXzWIiS1tbXwjZam6QvzpfpC7rjU?=
 =?us-ascii?Q?OAvGG0I5fPsCuj0OmvVL1A0V2SWbSGfgD4clltbmCh4YyLKE/lXpb9QPSSI0?=
 =?us-ascii?Q?mYWSkMD+XmdLkqJnr//rL6UsLuH6EzCmBHyGL4dCS7QG1XzpD5n1ubiyZNol?=
 =?us-ascii?Q?qTFL5vWy/jjRzwEzq+MRtQprzFleq6t0/ISkPh4nsEHA4/DkoDevZRcqof+A?=
 =?us-ascii?Q?TGSCH4Xyojfpz3oZ/TJNl8+/VIKVpipLjs6UsYA9ZcHQgDjzXV1GlAkRHlSk?=
 =?us-ascii?Q?yW6d+/b3Qp1zcd68joa6SfFFGx8bCumtbCWyVS9aZng0+W8F7mHhXxjCv+57?=
 =?us-ascii?Q?yVmQ4lRx+0NkfpW8x3Lto5XeJuJ77sproGpnHx+QSVXZISMfXDD5ca6YDCAW?=
 =?us-ascii?Q?1IB8SufIH93+DlQS/1k3qbfbeKNhdb5bXEaNiPqvvM3YbDY2gcESEDWE9I2G?=
 =?us-ascii?Q?l6/1WANkIVweddeUHo/l0KJNT0q5BSZlprl2qSSOwXx7fZa653RqfiU/dhGG?=
 =?us-ascii?Q?VFaUqBgmqZGEbUI7GdARSFyx6jZA9qsRWhbsNd4vQQN7ZsN4f4rOUdO67t5h?=
 =?us-ascii?Q?weRmfILSA0/peN/2ak6v4ghzlely9vp1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QqyU0liPHPDKYDm87RJtArCZlmh1R8kPBFGSouzYrghZvSSwP+mfTVzSp60m?=
 =?us-ascii?Q?XSK4yUPGN5zHHbq3i9lxvANN3xf5QkNalMx4CTukGeD1YUtRhKLf2Ipr9XbL?=
 =?us-ascii?Q?dF21+r4NdkQeFnAf7DTn756OGBTLxxp1RStE2Iqk5yIrzTq3SPW7cMG2dCdn?=
 =?us-ascii?Q?rFqGS3sF9hwiWFRjbL/rRubSHvSQS+rX7eMnDVASOWDjMfovwl28ujQEVVuk?=
 =?us-ascii?Q?W66tkr/d8Fgx9NWINXZBc5CgW5dIUUXiLzSzKIrNFYPxejwQrBMxucEWFqjN?=
 =?us-ascii?Q?HpzKAWTSWewX5zPuLMex6ciI4/+oPamI4GZVbiWhAgCRE7D/GKoz1klwS7HP?=
 =?us-ascii?Q?tg+7/XwOrFYI6PN2Ol0EMlIVLmBuGbL+ySrKB2D05q+27KwVuKrohGLwPTur?=
 =?us-ascii?Q?gQzIy0q3XD4mMMflpvcSWLt6pKI/5EoHOLog7O/hIimwRL08hFL4Ep0reooA?=
 =?us-ascii?Q?QtWuAy7BAQrYZ9kxbh++f2gHZX+5n+wxcyjpjD4K7jwuOkM8n0fU5jviAfoL?=
 =?us-ascii?Q?Np5+XH2QY2QUgvztL5OpsSpDWhEkvxuy0H+oYH6qioMbFlyDyxXplbQcKGe6?=
 =?us-ascii?Q?RlDzRrrmdsd7wpUdjG+G9lH0/Z6QC7RfZcXtAcmlqbEO/hSku0/++RR+w439?=
 =?us-ascii?Q?2OOSeDJ9vgVLi1g9QHgP8FkXeS2YdXYsOhiBGO5ROnGAaijiB2g0xh/j7SjR?=
 =?us-ascii?Q?HpEQeTSHK3SlEmHvE9vmUiz7fSIJe423EsYHfZ3uTWEICDaeTkWe0XzUOEkp?=
 =?us-ascii?Q?uYYUx79Ywac8MJsmqrNWBWEGNy/nhBrBF9KtkJ7m7KqQk0zzcwHz06cfbIWY?=
 =?us-ascii?Q?vjy5Swpivstnd1FIqT0pAPuEDlzQS1GOlOrZYlubsPr5kg9Pj/BmFBYOQp1s?=
 =?us-ascii?Q?snLl7/Wue0JcB8mL6GlLoM9gfrhNB2TBYiAP4l+mbYxaWgnMA6V3OmC2EbI1?=
 =?us-ascii?Q?rBo8SmMQO+hBSjb+WhW4QXW6oKDM8Rh4dXh5Yo7u75usr4EsHImXKtwC75Ja?=
 =?us-ascii?Q?saSmLf/dyJ3pIrRQyMFrogSJPotn8tlfP62VUlyIgnd5bOc2P90K27znnpcR?=
 =?us-ascii?Q?Hcbq1My/LdBAn9mMFskqVD/P56ZDY/Xmg3tJoWFXdmenFdtaXAkOD+OFe1u6?=
 =?us-ascii?Q?AXQ4hPRl+q93cSHfhTaayLsMlkoyIB1eyp68HH2YcUw/G8baApyHz7Y20zdY?=
 =?us-ascii?Q?T9RFpVclCz7bmFSd4vYBd4AzjBgO9PK8GPRMQtrb2+QhWY13zvTm6VqK3RGf?=
 =?us-ascii?Q?/8oZzopF9KDvwyvueMjzyU889oqMSqH0Ge301Qczl2bjOKT6Il5IVHeErWpw?=
 =?us-ascii?Q?0xRYBZRNJCy9qprRS5CP5jYvoIhIDdg51t0vxenX2llMOGmhDqF8ZPQGp3Al?=
 =?us-ascii?Q?Do3r4okfwmpT9DKT3QArFaUA34uqfs0HEP4sRnYMbrbXjPbFF5wX2oKWP74f?=
 =?us-ascii?Q?ueI7VwFYAfQDcvUNxk0pI2GWKxt25xyUwqLFLtn6WhEWBz+st7LqNNOepjkn?=
 =?us-ascii?Q?/eYP4VBwmAGXiUzAfuAAFmc7eCWaAAAzrF/rFptbh0QEE/iKJZUOX3iZxfTa?=
 =?us-ascii?Q?tuZ+V0JWjkCooYbc+oU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40c88ca-e939-4019-e904-08de1d66ffeb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 19:02:15.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqU45AoRAdQvG1aJrTuqNfefzmnlGnyGth1QNr6OdTfDdRVbtG59xHd1YUZPvgrD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8232

Some adjustments pointed out by Randy:

 "decodes an full 64-bit" -> "decodes the full 64 bit"

 Correct the function parameter name for iova_to_phys()

 Use the recommended section heading style.

Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 2c8b644f3901 ("genpt: Add Documentation/ files")
Fixes: ac7ffd8e805c ("iommupt: Add the AMD IOMMU v1 page table format")
Fixes: e530a2c3a098 ("iommupt: Add iova_to_phys op")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/generic_pt.rst | 11 +++--------
 drivers/iommu/generic_pt/Kconfig        |  2 +-
 drivers/iommu/generic_pt/iommu_pt.h     |  2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/Documentation/driver-api/generic_pt.rst b/Documentation/driver-api/generic_pt.rst
index 7a9ca9f2878d4f..fd29d1b525e51d 100644
--- a/Documentation/driver-api/generic_pt.rst
+++ b/Documentation/driver-api/generic_pt.rst
@@ -10,9 +10,8 @@ Generic Radix Page Table
 .. kernel-doc:: drivers/iommu/generic_pt/pt_defs.h
 	:doc: Generic Page Table Language
 
------
 Usage
------
+=====
 
 Generic PT is structured as a multi-compilation system. Since each format
 provides an API using a common set of names there can be only one format active
@@ -61,7 +60,6 @@ format-specific information.
 The implementation will further wrap struct pt_common in its own top-level
 struct, such as struct pt_iommu_amdv1.
 
-----------------------------------------------
 Format functions at the struct pt_common level
 ----------------------------------------------
 
@@ -69,13 +67,11 @@ Format functions at the struct pt_common level
 	:identifiers:
 .. kernel-doc:: drivers/iommu/generic_pt/pt_common.h
 
------------------
 Iteration Helpers
 -----------------
 
 .. kernel-doc:: drivers/iommu/generic_pt/pt_iter.h
 
-----------------
 Writing a Format
 ----------------
 
@@ -112,7 +108,6 @@ The generic tests are intended to prove out the format functions and give
 clearer failures to speed up finding the problems. Once those pass then the
 entire kunit suite should be run.
 
----------------------------
 IOMMU Invalidation Features
 ---------------------------
 
@@ -124,7 +119,7 @@ on its design. Every HW has its own approach on how to describe what has changed
 to have changed items removed from the TLB.
 
 PT_FEAT_FLUSH_RANGE
--------------------
+~~~~~~~~~~~~~~~~~~~
 
 PT_FEAT_FLUSH_RANGE is the easiest scheme to understand. It tries to generate a
 single range invalidation for each operation, over-invalidating if there are
@@ -134,7 +129,7 @@ however, if pages have to be freed then page table pointers have to be cleaned
 from the walk cache. The range can start/end at any page boundary.
 
 PT_FEAT_FLUSH_RANGE_NO_GAPS
----------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 PT_FEAT_FLUSH_RANGE_NO_GAPS is similar to PT_FEAT_FLUSH_RANGE; however, it tries
 to minimize the amount of impacted VA by issuing extra flush operations. This is
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 79f65268f31212..c88971675662fe 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -38,7 +38,7 @@ config IOMMU_PT_AMDV1
 	help
 	  iommu_domain implementation for the AMD v1 page table. AMDv1 is the
 	  "host" page table. It supports granular page sizes of almost every
-	  power of 2 and decodes an full 64-bit IOVA space.
+	  power of 2 and decodes the full 64-bit IOVA space.
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 1dcd85620f9b9c..0e046fe0eea34c 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -158,7 +158,7 @@ PT_MAKE_LEVELS(__iova_to_phys, __do_iova_to_phys);
 
 /**
  * iova_to_phys() - Return the output address for the given IOVA
- * @iommu_table: Table to query
+ * @domain: Table to query
  * @iova: IO virtual address to query
  *
  * Determine the output address from the given IOVA. @iova may have any

base-commit: 1c04204b2a6df18a53bf8663c94e78f8c599a2df
-- 
2.43.0

