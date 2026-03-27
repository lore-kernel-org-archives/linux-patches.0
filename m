Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A462A331A57;
	Fri, 27 Mar 2026 15:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625154; cv=fail; b=Zz33MKd29mscJ1W7H2BvZ8WAeN+oVNyR3wzPjXV9SXgnu66fWb69ItWrW2x2KLXbZj5RFo3sMOS1iB7Rj3vqrXg+nnc1rInqLYIqqLNzVfZIm7vBxaty4w4hK3WUVGj6jOTXoFPHkPGiPddfR4YV5/WLv7hSMz/wP5swAOBl2dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625154; c=relaxed/simple;
	bh=LhVyX2JzvyHAQcPk6+EEL9ST7jYylZe5SLadPG7Vi1A=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=D8KnsMjk3nLzyd7Ejrb0oLwgza0zrRhgVkie1teFwZC5HdIT/894IYW2RT8pvhbL2An2gHV+3lx4EA3irpmg2McuKumjxbKYZRPt1oim/v8SyFSGJFvUdhwiTnuEHANNo2JAzXDlN4tGgpoGpNRlQT+CFMrAQBg6nEqHhq1gUa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VSijnqG6; arc=fail smtp.client-ip=40.107.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VSijnqG6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZZD87OJT/z9WfSUG3bD7K3MYpVkbMnKqxUgVd5hTDFDlHUpWxAkqz15FjJ7pPZ5HNz0/cBVFuwIzpjLQUmVxEK4bZL+RdViWhnyDZt9Gle0XzrW4oUQUnv9K9xyTFeS3VXgNRb32psB8D3ZGmTmr06N4gkDKlJqnyla7qWHv7hZQSuHfWiATrZL7fgxGLVH1mcq1aOnYvivbvzBWeo+oV3aZnWzVy+VLQCXxpVSS/fK6SxwChCnS8fqQGucXVZOwWYq+Ruz+Ve8ZAOO4qMk/letfYAZMxO/XxQ7RR/4AS3NflBnsitcHnG9ahgG/U0yi5RYjmojncS6wR054R8gDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNRgrJUYwLD6L0I8ZWAbG6+M8KHDBuMWOwCNq63MFd8=;
 b=dTC4qevlY90jf10k1xF4zifwzLKYm2/5YaE+Io2vBaIBO4pz9i12RcOk4iF+/VTL6T3+mWdZ5/LNkWUFEbhk0PCNe+jspCT0/NxIgjeRJTA8et1FdNa1N/E65WJAZZVM4XRQKeVWEKjgD289JU2GHa2oar/4frEyhlsYzMXclz+sq1Htx+uKC07888TIO8db/rD2lOcQgx30Or3F5f081nG1kUlsII5jT//AhtTxWa5lWVaquNGg6pJRsSuYUZbu5at3MWH77d7OlMEyI8q1uelbnWkDbh+va4YPHmME2+EInjFf3+x1WFl3yrrDv2zQfOihVrQUXwh2uhJ/hJeZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNRgrJUYwLD6L0I8ZWAbG6+M8KHDBuMWOwCNq63MFd8=;
 b=VSijnqG6HQdAUkrCURkfkBF2NI9zbHAVVlxvpb6VSSFil2zgU81bswwduwym5iTibZQswDExERi6Hy1bGkDjmeaa0/AfT/D1tDoTP1BiJixRY9brcOBr+redYp/bCTE32swXRmwe/AksTMSy53yiPRpE8nq01BdRfjVZoYQRh/9fEUmvSDz6nbHruJ434v1nfn5p54Bj5CiNbfz70nGw9PcedZmz5cNc9pK3FUG+cp9zRtuZPH3z88Zl+cJZe8OAHz0h94sIRNgznK22L+mAp3GDy0KZGpsFBaEmlVryNfNdHy0wHAB3O7BoR7V1pwYkAiCOAcmK0gnj9SsB0v0WWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:25:41 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:25:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 0/4] Improve the invalidation path in VT-d
Date: Fri, 27 Mar 2026 12:25:33 -0300
Message-ID: <0-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:408:ee::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: e67c4f03-bcec-452c-1be6-08de8c151a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	r+6OT8PtzGG3y736b7gpcfzIK+CaD6Cui0+D/AenvDHk2CRy06V2uhUp22RxSB1ubp8c6eJ0O8cPC856n+ZX9lXMhq9Qif5a4KtJ6Xw4TgjHqV2qxwK7UCLFVF9bHnk/1sni/DGl3YcHPt/hKNTxMAkJTewYZw86mv3iy36NdrBTVE5IXaSJzf8RJ6zwrFKZJ/YOT0CbNBWkeYqhBo9neYMRQI8J1MMgsfPUiYtb9tVhiovbcyImUO4Fb/N5M7RDPM6M6LNHuaMtX1DpDd2mzpPpuAncDdLu9kdI0+V7Q077nh2gCAbAYv3WiCKE3/6txA173OcTFB41q2p6zVRDui4eC2/MsFtKwCj7RZ/c27wTR4SB9q42cQzCBYR1IhAAU7SrvWwNPLtBrmWy8ItiMLid6NkUVL98FECNzRflPJg15baWCk4u5K9Qa/XHcNzPqM+DSmClrRyXoDCxvFtxle1Le5nfzTx1sRRlkVnCKqVHxpM7wmj6Fukx4oFW0Pj5nnrCmJYRxIDOfQpAr/E5wXb1hE6EjTyI4Fdcg4ifc20rCuOh0XfoFkoa2n+QUgxR5NHcW7VTva+M77sBGYZL2+Oz3iO3hdhQMcy/IKLnmmJFDaY7AfCoLoJk8SLI3+nl/1QLkYtUpj/GzJ2n3T0EfJyJlM5Z+56aUi+CwX/rJlUE5oY8mSVirLup0GLWUW3WFy561OT1GJ36j1++4iGeO6MpjkOkrlQG5BzYDau4QOw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WrT8UYF8J8OK25zzoXIKjHQNbnK611Q1jYJB1dMi45D8OgoGsiq7xVxGFoWM?=
 =?us-ascii?Q?E7EQqe4Zx8Cq1fKuOo/7nXOBhPl7gMsKE7vmRZm8dzp4AeJKhyyKfYmGPeFu?=
 =?us-ascii?Q?CV+ERS/sye3qm14ylJw/LKB2X52OgzKtbRgF0jS4ggcN1tk/LOp5423ZcuUT?=
 =?us-ascii?Q?cwtSRY1+BQSowBDwe6gkr5gqOlAql9gDvDdf0NHgc/Jyc0DcNQ47juSeym25?=
 =?us-ascii?Q?a6I4MoLevFFA1E000VZemHmlxjCPIaH/MX9cKT9EInEBOUZXjV+X3FeJgEG+?=
 =?us-ascii?Q?UnPSmNoIw6Ro2POeSJyNwV+mT2tJTUnhi5gjgN/WsUTgjDq1y4swA0sdWV9R?=
 =?us-ascii?Q?kgV/jDaWBlj7p/h0Uwqy15YfRYfwNsKIa2p+qCM3jzgRT4dE9N9eFAQrWFPE?=
 =?us-ascii?Q?QhQrOWS1NyU5G+Nn53Tmn0DWWHnOvLKavZB8By2VFYOfj7chOSNB4hogM7AY?=
 =?us-ascii?Q?juOF2wkPaiYteF50FpsuuIM9Vy4EyyEsROxutvuzGZX6VsD/lHxiTF5FY/Ba?=
 =?us-ascii?Q?LNqtqF7Fs/HP+HXNKaZl5XkFaXGzktBKl0ZKF5Ibr96oF5EjFwEy49Eftbyw?=
 =?us-ascii?Q?Or+WH8AtJNlo5Aerfn5QskPVJVAHPzmXYxECEa9wY5seJh0cTsAsDuLL7nZR?=
 =?us-ascii?Q?DeHloToxZv5Xc94Nezufstkk3XFCpl0re/UM7q04JwTdBc7kzSg35te7Pf8m?=
 =?us-ascii?Q?5ZoPQ4p6jnZZ2KYXIITW0TKSdSrZC/ZlQMVyTUOdgFUmAHlFpZHBmKZzijvE?=
 =?us-ascii?Q?rnPm0+A3y2O6Wb7H/VBTuDuJ6du2ZZv5NyWSFpUMns5ydLkiFNWPjVwY3gI9?=
 =?us-ascii?Q?EL04XvfgqzS5dd30qlhrQA27489pHSJbhyzLvaRNUz8J7ta7uz1Ktacw6Pqm?=
 =?us-ascii?Q?rp0Hto5l3YXHyObeAop5Zyv475M31KtTQ4elRDpKunn2+DJCDdWjJV2cOEod?=
 =?us-ascii?Q?jXurqmSQ72nls7eMvEvKzH1xTPyXjqH0t5sHTtyiYTjjvcc0TkUW6OkYJqpN?=
 =?us-ascii?Q?+lDeu1vIUlMznLzgJLx/mSl+V8bHkpH44SxrHQxHQ3z6WR6dM+z2+IceCq1s?=
 =?us-ascii?Q?GFtMSvwSHy8WezeF7BrTS9DdKqW2zc5O3lJ2jhhZpKMhYnnsDgX3SqkZJbS+?=
 =?us-ascii?Q?t+ez96kUWHjmc9Kiq9dl0AOUJGsAlchsNNbuxGaocMQ/JgonTYIMcYaCd1g0?=
 =?us-ascii?Q?P06AFhzXbe8pRCXMazr0RuEqSA7HfkNd/oYgQkkHZ8X5ODFQmOZPYWJBQMOo?=
 =?us-ascii?Q?uNWjJ7AsdmKhUTqqTPMf7zHrwIz78CxKvvPt3iViFNbwC4UNTW8hkxKrX5WB?=
 =?us-ascii?Q?geYBpt0Lzyr6/46k7SobYEjRX7yQf86zB9vH9P8dcsiCx3XTmOsLcNNqcDxc?=
 =?us-ascii?Q?UZgCM2p8rD6LQR+5KitulgVPMrxr2JRJpGE0aq2HeCIHUoz3NepDpsGdfrdo?=
 =?us-ascii?Q?wXRSbQKpT3g7DC4HlqHl2G0WHNFj0QtenlFcdBFZjUrFhf8KhYp6pjlw5Pfe?=
 =?us-ascii?Q?85Jrv//0Dm1qZ8FOjTczbjOesXAYeLEsG9T89ubUhD7qCiPlV7etUe4K1KiW?=
 =?us-ascii?Q?8elQ68e1PKm61tMdBnfF1DNs6SmYmZsouMI1Q+m+73qPEeAHh9P03QpORiak?=
 =?us-ascii?Q?5NlwiZFMtAZ9HFYeQv+3jjFohVe7B5wIgpcvB2O7JjSjSdLKIrJkRTqKiXgj?=
 =?us-ascii?Q?iN/zzd32oQfa6MkON2qX0/9PIbHpkD6a4IGtmeBc/TMoDWV1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67c4f03-bcec-452c-1be6-08de8c151a54
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:25:39.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2l2UTUJbeApykOzd7EU/186Nzr6eHliINkjs/jqF+a4JRfA4AaOVd3hBYO93U2C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

Auditing shows a similar unnecessary complexity in the VT-d path as
AMD, simplify it.

- Don't intermix all and range invalidation flows at the command
  building phase
- Don't compute a size or pages for the gather range, stay in the
  start/last space
- Use the much simpler fls approach to compute the AM

Broadly this removes a bunch of unnecessary logic from the
invalidation path and makes it simpler and more of a straight line.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (4):
  iommu/intel: Split piotlb invalidation into range and all
  iommu/vtd: Pass size_order to qi_desc_piotlb() not npages
  iommu/vtd: Remove the remaining pages along the invalidation path
  iommu/vt: Simplify calculate_psi_aligned_address()

 drivers/iommu/intel/cache.c | 100 +++++++++++++++---------------------
 drivers/iommu/intel/dmar.c  |  19 ++-----
 drivers/iommu/intel/iommu.h |  43 +++++++---------
 drivers/iommu/intel/pasid.c |   6 +--
 drivers/iommu/intel/prq.c   |   2 +-
 drivers/iommu/intel/trace.h |  18 +++----
 6 files changed, 76 insertions(+), 112 deletions(-)


base-commit: cc9c4e71a8dd4f8842b0b958deacc2410ce465bc
-- 
2.43.0

