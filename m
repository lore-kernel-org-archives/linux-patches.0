Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AD5268C7D;
	Fri, 14 Feb 2025 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552909; cv=fail; b=IRI55BzoxOBxCqVvj8PgnaesClRLaeIDeWfHHyo4cfAouZP2zUIfFgKhsszRCOFkl+eSXbhppjLN0RfUPCgswNYaByB/FwvUSb4eoyNnCl3sbFxJAKc9ig51+HGdYKrUJSsJKlUG/wRm4SZtLkZ0FmzTcW8dyriv0iknnQZyNqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552909; c=relaxed/simple;
	bh=AI19P7i9oyNOGwOQ9kMy7FLN14cg1qLCKbtVSFm1N/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U0Eck9Df6muA1fIgNBDiVuOsx0hZUQjG8/Dmp8bCG7je319cdqV1sfKzcFlxZzLyQ2rm+SVQZhpF/gw8atFoQIbdCUynzTk7WkJtDldlQfzojvhoGOZVJVe/xl6QumBov4uN5a/BIu4ULsmsuY6RJtYerZjlMXRIRhY7951/D9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m4lM/6Pk; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m4lM/6Pk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Im4imTBQQu+xomluAxUsr2MgJXERScbPnTkjE2mxMIYRsVRR4bxBgUQareFF0fKLIwb6Nf0IAAqDNnaqewhHb2drSKOzkbzb1ui39AqvD1NpfvAyHhla13zze0OaosBB02XYNFZRp9ODaV1yVT5Q8eKtMsrWl94R9F9m+F5yzfqFvLn88X0gCOJXrbDLfRThDUE4I6AGSKxDkfC6upkx+Fh8RFs/akEeM7X8PsjbhJqRKAFCwyDhkovF4U53t6/7YiyGUgAIwQKl9HdJTCo+n45XNTLpSqfm5V+3OgTJuVWE/gauYb4YNQDfY6JxNnP0J/imO1Q909Lr6lG+C8galw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GkJ0gfobnQmpYYeUTVw5DCLTO83CKAZMfegZq4vbCU=;
 b=XSKXvMhL77kUh4ipThTi71DAgphn3x5NjD09raNDl6VCbSkd4Emo7HpNd9lViWAdNWcQfwCT4/SfDnyAYvaowtZbirERxLSBfAJUPTZHEqMMikrkdzmX2QMTHfTOtIbPoEGGMesy9AuTer+RafVUo22IV9KdNbCgiei9y6OoRPmnQtHu7ugVBu4Fy9aFvzdRTMdAPctrCfO2Gao1J3fp1B+B2VAhdf08ADa+ons3RL+1A9WzeLtoTSmwcp64/jjNIKw4cT6Fc8v5latwBVlm2wWBZW5utnC/11QkZ9HKg1YfuqVlwOflsuZR/UE2i+TSyUX0n7Bm7Wh5KC6oC/prHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GkJ0gfobnQmpYYeUTVw5DCLTO83CKAZMfegZq4vbCU=;
 b=m4lM/6PkIxk/6g1DsV45I2ll/zq8lzK8DpUTp7D3NhTBZZwqsBQCGkQ5IfbtXYbW39pH5kn17RKQh4nODJ6N5OykPYfdOr8qyybUdVHv0G84C5wB6VrNBOloE27Hx96zhcKjiY4km3eeMZtaK5gZXaRfKIw8JGqfRHIR7+c1JVAklcLl255VnHNx8q+ITyQ1fdnphF6dSFoo8A9xN9jSdr/3Betb+vNNue/950kXE0zUmwjaV45oc/noI0fk/529wtztjDkfQn7JNqYLzZ+Og8xs9iF4VdaNPrpi0ookL7VG/PsLUpr/vlYA9fhhAK3CBK1CBxs/gSu7XZqE9x1WTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:13 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 09/23] iommu/pages: Formalize the freelist API
Date: Fri, 14 Feb 2025 13:07:42 -0400
Message-ID: <9-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:208:23e::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: ec5bffc9-2968-46e9-9bab-08dd4d1a2306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ck7c7SsKZ4TxsVUENL+WeCXnqnp0ftdbOVxW7I5yDAGE5xNiPrFhe5U3DuJK?=
 =?us-ascii?Q?UJfuAVb/Ur6Neh25sHSbDLLnnXhClll9T6J42m/8TQhv16m5/FRw7n5bULeW?=
 =?us-ascii?Q?5hrphPP44aEihrK8/AVU+A7C+QqbdrP3FMcZ/LMdm8YbEQyiRkiGXZcn3ZuI?=
 =?us-ascii?Q?ltf13S7pJVHk+AP6bR1TUGyEdoV0skW47OdZ3loWMHjBx/FdCL1e5enc5whY?=
 =?us-ascii?Q?ZGgZ9eBlkLqDkwIhMF++WPjwqGvwaN5tWOXRIX7b/tgx2XCFi2yy9xL359Vf?=
 =?us-ascii?Q?hHFi+Swt5A34C1Lf5uyXVpcYJw6a5dg1uR9/bRBBbVVUMRh7oV0uYQL7fehd?=
 =?us-ascii?Q?pREgkEtOFGzORMUOOnyrn6XMOSz4Gwz8kBphAxkSMlOyd95O3XgdgCMbTO1H?=
 =?us-ascii?Q?BxKH138YTQ8uXS6IA/K9XepXn21P7pyjm551yiWA4iTwXAgeynOkNEHcZyBc?=
 =?us-ascii?Q?3bCtz4M4LLKtHgd8X0TpenTZ/GMKG49oe6BEA0f+Scm+CI0ym6jupJZj3MWG?=
 =?us-ascii?Q?MhoK3+8TOVJQcaa1+HHDkyW05LVpnL0RpBqgarjSRdAPfeYqZ07R7zOs0Yck?=
 =?us-ascii?Q?fx4V2F66P0lEpoODaQeFKx0sjElSwoBML9k7CdQe1/OtlYEqOmwz7iO2oGb5?=
 =?us-ascii?Q?FvF+cSVwx0kSCpWqx0Kuvxbof6k9Mm+yvd/5BUlHQfo2VJEZjQ2D8zTppblX?=
 =?us-ascii?Q?B5rr75O8a0QYIDn//rBfuJ7vSoGgvDvKGAInDrzDEJhvu5TrXHdF33z2zTGg?=
 =?us-ascii?Q?AmlG6/+LkoCsJbisuGBT3aLvPhJLPj1gDjWA1SEp8Byeb/9EECeK0N/a/MCq?=
 =?us-ascii?Q?UC1V0B3k5U/2kh/Enu5KTiKFu85J+0m6TkHWztz4BRqJgj54YLIqpPSQvL82?=
 =?us-ascii?Q?QfFn6MWa6SOlBXu0stbV8XTRS0VE+xXWMQ9L8KKxOIOsUtdwqySC0YxBywQx?=
 =?us-ascii?Q?SqGi0S2/HSzLFTvf0aEDA+MfFDXS+wdjRnqiW5u4MiJFonOcPbT/DHy7LzSb?=
 =?us-ascii?Q?+qgltRbtVy/sNPNz/EOlnOHumqNiTmuV8TMiBl+Xx1i7PE7vd7Kvlz4DHrZc?=
 =?us-ascii?Q?MpSx9i7my00HF/vSrtn1EOf2jEj6tw58WcAay1QpkrnFuENJQOqswoqhd1Bz?=
 =?us-ascii?Q?D+Nn4P2PjT5zYwoikiGlWHU9cggfPfpRPEDNbNAfP3C58X4HMaAxJY9FIGOf?=
 =?us-ascii?Q?whE+F9TE5pxDtkicItLf2GVo9YTBP1XbnpLuFC2o2TUiDE9t6ly5KcADd3KG?=
 =?us-ascii?Q?9IDkpyUrr48QOvKjeooQ8v32BDX33zs5vT56Bc7eioZCom5BT1ebSVXORbbA?=
 =?us-ascii?Q?VtLJgizQcrtllGW0vGsAxBYmtM0I5GDDn5FDQJ2PzBoqaDtQXIAYf3kHWSv3?=
 =?us-ascii?Q?CPsxH6DirJxFJk+WR8N/gwhgPKT/vNO6nae3dQaZDdba5PFHngZn/RCCUISM?=
 =?us-ascii?Q?BnTjkhYiAwI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5HaDzIYuNVLg3lbBAlgzQ89JhPUGzeUpZ24C1WpcfrgspfsD0EdK6tGVhYm+?=
 =?us-ascii?Q?0+PWl5V8LX1KUiq00F5f3m6bDit9Qlmj9GBwdDaRD7q/Hs0SCmlGfbn3o5Ee?=
 =?us-ascii?Q?iQdHDpYy69IjpTmNZTkpS2484cInhfzUgbGRQ6w9n5NXXitWXUtzA6n6809o?=
 =?us-ascii?Q?+Ek8C9kwGfNJVTGpOSe88SsQmSOSGH3ovaWBHvRT1v555vzdE05T02GvHtZU?=
 =?us-ascii?Q?zwtSKfb6kORyxs8IHEpoe93+83SxBYMRYGhSyy4bHsJyT4vHYzFbuS/G0mxW?=
 =?us-ascii?Q?98dL+jD6VTiUFZ8QFViQNtny+JY+ivVK3hlyYFmhaFHWbOGj0IUsY3HepT+z?=
 =?us-ascii?Q?uQKH62MvEjjMCLD1bjnJMyvO4xqqqzK9wak6bRt6Dy/DntiycHNw5oYxe+45?=
 =?us-ascii?Q?iJKr/mpHrJFX/ub35pisqDyflqPdcb+xHjCpN7rA18Vkuywf2aS3D7gQ08LR?=
 =?us-ascii?Q?TtN8SuAD90ITqD/B53MYtuAteB2xbCHqkEPp6wbLv97aIdPq+trek3vf8QeX?=
 =?us-ascii?Q?i8wFmfoimyLRbCf5glTycXQ25Uy/c9ZyXwDMLiUC5+rDAS7ZkoVbJbl5HFBg?=
 =?us-ascii?Q?GYRrXDC7cF5gHSFo19BUbhXeL0eOtDhvbZVC4k5MbqI/ZYOj69Ye3Gi8VIPT?=
 =?us-ascii?Q?nqi6jWZER6x+quoPBwIaL+tGAhul0SglfeavO7Vqgdn+QeSvk5JwAK6wPoko?=
 =?us-ascii?Q?wDE5zYHoiYPKkXDYq3tL5tvLN0VqvxMS/VHim/vtndV+5Bof1bNj+4eYOtUF?=
 =?us-ascii?Q?STVeqPg2o4vtqHwbfANPvRVFmY3m0KNZ+hLuUIR0KkNVaMJBE4SBFrP6pLm+?=
 =?us-ascii?Q?KbBdPr6ZhTLNW/RWsbixRJQeLUcLz3Lxk8BuFqgLbc9eOllaDAIfrKl9ONqh?=
 =?us-ascii?Q?BJVR84ej4lWS+mRkfr5UZLCPIzx+S2OkCtlfaK09HlipsLDvblG6ePk+956p?=
 =?us-ascii?Q?lojZPoi+QLpih/neC4P4LYkzJAZ0EauQFr9SUGOHBf8Ja7QDfW0I0YCFdWn0?=
 =?us-ascii?Q?d7M+0Rh6xn2GRxrBevz9+BVvgx90I6xVnjay5cyIhflZFLnRSHl3A0+896TD?=
 =?us-ascii?Q?fFNjeZtNytzIiRDX+uft49bmkY7+idp6yEf54hHf7By8/458oZZ/apOu0nbN?=
 =?us-ascii?Q?B++G5RSZ7SKmA/re6eALvlDUGn+65rRFFcD77DWSbT5zhjQ8Qbt/VfphbvV6?=
 =?us-ascii?Q?tbfTabiXD4RmTUniVWzWwA4PzEgGC0UFiPg37qniPSSluGXnLYTsD5mXOSit?=
 =?us-ascii?Q?yl4/2hHXME+jkjD6dGzlB90b6ZSrKw6ONlXN7D+UUG7KMMTUif7/BesJcck5?=
 =?us-ascii?Q?qd01Ze+HRIV7wSgDxalN+F9b0CCNSKadbMzHQyl4YeIW+hB6LS3CUvx1PDW8?=
 =?us-ascii?Q?xcSRreEb6fldUZhzJcmQR9voRxA5TxsmyMq5OfQyPEnd6VXwwQAlM8ariidW?=
 =?us-ascii?Q?DUTcNsNLJVjZ/VDgl8sVnQ7HZeGzpDtFpbjD+dYkG7SbcOO81dsSWzhLZz8Y?=
 =?us-ascii?Q?oy4wKn3ojdNv0plSwl6Grr62jygxml8ex46KFVOwLNJdR/RnfGCDG3+qXp+R?=
 =?us-ascii?Q?aZf7hYueMU9DchlHHKk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5bffc9-2968-46e9-9bab-08dd4d1a2306
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:01.0466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejjKj4X4N61WjCEYfkztey+spxkQrflRNbY3Df7+fCmgJDmfzM4AQv6uGrkL+3kV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

We want to get rid of struct page references outside the internal
allocator implementation. The free list has the driver open code something
like:

   list_add_tail(&virt_to_page(ptr)->lru, freelist);

Move the above into a small inline and make the freelist into a wrapper
type 'struct iommu_pages_list' so that the compiler can help check all the
conversion.

This struct has also proven helpful in some future ideas to convert to a
singly linked list to get an extra pointer in the struct page, and to
signal that the pages should be freed with RCU.

Use a temporary _Generic so we don't need to rename the free function as
the patches progress.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 23 ++++++++++++-------
 drivers/iommu/iommu-pages.h | 45 ++++++++++++++++++++++++++++++++++---
 include/linux/iommu.h       | 12 ++++++++++
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index dbf7205bb23dcc..1739df8c8b304a 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -67,18 +67,25 @@ void iommu_free_pages(void *virt)
 EXPORT_SYMBOL_GPL(iommu_free_pages);
 
 /**
- * iommu_put_pages_list - free a list of pages.
- * @head: the head of the lru list to be freed.
+ * iommu_put_pages_list_new - free a list of pages.
+ * @list: The list of pages to be freed
  *
  * Frees a list of pages allocated by iommu_alloc_pages_node().
  */
-void iommu_put_pages_list(struct list_head *head)
+void iommu_put_pages_list_new(struct iommu_pages_list *list)
 {
-	while (!list_empty(head)) {
-		struct page *p = list_entry(head->prev, struct page, lru);
+	struct page *p, *tmp;
 
-		list_del(&p->lru);
+	list_for_each_entry_safe(p, tmp, &list->pages, lru)
 		__iommu_free_page(p);
-	}
 }
-EXPORT_SYMBOL_GPL(iommu_put_pages_list);
+EXPORT_SYMBOL_GPL(iommu_put_pages_list_new);
+
+void iommu_put_pages_list_old(struct list_head *head)
+{
+	struct page *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, head, lru)
+		__iommu_free_page(p);
+}
+EXPORT_SYMBOL_GPL(iommu_put_pages_list_old);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index e3c35aa14ad716..0acc26af7202df 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -7,12 +7,51 @@
 #ifndef __IOMMU_PAGES_H
 #define __IOMMU_PAGES_H
 
-#include <linux/types.h>
-#include <linux/topology.h>
+#include <linux/iommu.h>
 
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
 void iommu_free_pages(void *virt);
-void iommu_put_pages_list(struct list_head *head);
+void iommu_put_pages_list_new(struct iommu_pages_list *list);
+void iommu_put_pages_list_old(struct list_head *head);
+
+#define iommu_put_pages_list(head)                                   \
+	_Generic(head,                                               \
+		struct iommu_pages_list *: iommu_put_pages_list_new, \
+		struct list_head *: iommu_put_pages_list_old)(head)
+
+/**
+ * iommu_pages_list_add - add the page to a iommu_pages_list
+ * @list: List to add the page to
+ * @virt: Address returned from iommu_alloc_pages_node()
+ */
+static inline void iommu_pages_list_add(struct iommu_pages_list *list,
+					void *virt)
+{
+	list_add_tail(&virt_to_page(virt)->lru, &list->pages);
+}
+
+/**
+ * iommu_pages_list_splice - Put all the pages in list from into list to
+ * @from: Source list of pages
+ * @to: Destination list of pages
+ *
+ * from must be re-initialized after calling this function if it is to be
+ * used again.
+ */
+static inline void iommu_pages_list_splice(struct iommu_pages_list *from,
+					   struct iommu_pages_list *to)
+{
+	list_splice(&from->pages, &to->pages);
+}
+
+/**
+ * iommu_pages_list_empty - True if the list is empty
+ * @list: List to check
+ */
+static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
+{
+	return list_empty(&list->pages);
+}
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 38c65e92ecd091..e414951c0af83f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -326,6 +326,18 @@ typedef unsigned int ioasid_t;
 /* Read but do not clear any dirty bits */
 #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
 
+/*
+ * Pages allocated through iommu_alloc_pages_node() can be placed on this list
+ * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
+ * can be used this way!
+ */
+struct iommu_pages_list {
+	struct list_head pages;
+};
+
+#define IOMMU_PAGES_LIST_INIT(name) \
+	((struct iommu_pages_list){ .pages = LIST_HEAD_INIT(name.pages) })
+
 #ifdef CONFIG_IOMMU_API
 
 /**
-- 
2.43.0

