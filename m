Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4071E6DCE1;
	Tue,  8 Apr 2025 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130160; cv=fail; b=a6gchFAH81owfgKMVZO7e6I9Mr/lMN7ueEXLogmcNwuAaG/ZcksXHlk8b0qAE9sQC9ap7uJASg7aYcZDuzlKzn5i1Xf+0kZZNjOvie2HIIWoKYkFAt0Zf0x6KZ7fkWP7n8j9trVFbLggd9932/xGL/ERnOU3rvuGqzTxyZ7WMXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130160; c=relaxed/simple;
	bh=z7ULVMfIhEBGYb8+8cn4K/DJQ4QpofApMhjH4Uz2Mxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JZEO5vOG9GaR463URrzvwxjfKODLv6fDtzF3TMRTAvKukRoKbyj5NBAOuFp04Tl57tlm2i1Q7WcCuJkr+OoBDP9+2ffj+ijc2hM7/Rn7t/sYILZ7GTRf8TnmuoyH0Le3xOYEjMgO8ZCsdROpJdNhDaYqvgm81CcgJxlYz1E9Yho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f582vwVV; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f582vwVV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmTFrhk9AsRcSTBz9APj1ufHRRiveSF3g2kEtdHh/s5s0Qy92x7NLOlaNGtM8AJ1xlkIz7d0jhL4/NAz+dfMWIn8D46yss4FjFuug8x0DUescektHzmSaaMXkG6Xe5E9TNW8Gsnl4aAZdzkMsrvq5/OKMc3wFqK30Zqtx163RoKdBOYHsvqt4ocwuPyftav3e0TdD++KEMrakcjEMm4n8eXD/xW42YrRYlm+018TbQAa7CWlCg6QuJrfFp+M9/dWUFBxrOKad+TDRoavr3qff4PbI2sUNYIGRTn1fvPHOtNRJsnnSm/+OU7LbfroemIKgVIhWFd66XmM+NFp1/HXmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJYcLMqQAe8XLxPnm08i4F2+kGbZSrDe4LUavT9is1g=;
 b=ITui9CpuC8FX1NmDwIyEbaJey99KEBBYYp1WvHXiR858huUbfnZmN1YCKSuotmt4+/XaTWseVSd0kU5HV3OXEldjKcOp4fn0LW4wsBwQkywVqhf7NUwsL/MJ8t2gdZpZMz3qNKOqfNoOtLjldlYfeRBX9yVeq0JHPc8uPPRpJNy4W1lfFG/exeXlTXU9nEf4BOpP5PP8fH8ZeUUkZpey+hFELX3ChHc/mxZejsTtc4VkvFOTW51dOs/h+3DNeKfMgRsNwER5V6ykP70IiTpz/eUVWtR5kQyUVW9zs9uUPtSgIolGC3F0nQMkkQE8CUbTqaKYI65jYw+/aajsqyMDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJYcLMqQAe8XLxPnm08i4F2+kGbZSrDe4LUavT9is1g=;
 b=f582vwVV4qyexykl4rFQnqe6FFHTuFkmizdKBfaRFLASKgGcdYgngOlPzgS4/nq56NdO50MRWSlWdA3PQ8hm1l6c/g8uURnCyjEZkT8U+iv13wAVIiRH0ODtghkFWXBa5OjrfDLRPqfSX5faxMKS5uboUjlvo/jF/4HXV//cWlO6d2zTYYl/GJpMELJnmnA6chy/YB1ptCJEtOnOCla0zIWbN0Qp2YQ48rLVOKQUMPMpoDNT7zJROctvRxTj007ZnZbywf0R1PLvfg5oGHy26m1F/YpbcxiwaIw8FUgFVTTtcDVEsuyMsPsh8Il75O5/MJizCv68bG7BAn2/jq0M/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:35:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:35:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH v4 2/5] iommu: Add domain_alloc_identity()
Date: Tue,  8 Apr 2025 13:35:48 -0300
Message-ID: <2-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:408:f5::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 73bb02ff-5e6a-452d-3049-08dd76bb6d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NZbANhIwN59nB0API8q5z4ZqPwvuGfP85IYCHoZGAWIjigwu5Jrld+olgYFr?=
 =?us-ascii?Q?dbKMvlq+VzOLBNu+jk5ZxVsKxnbJCgm+tvHezEuea8pDgyMgrrLqTQHtS7f/?=
 =?us-ascii?Q?HUslgNqN7P/Bexy9HP4LRUk67FNRUANnb3IGfxARZur5jE7xNh9HY/fTIuYP?=
 =?us-ascii?Q?c7kgBeZFHhnGcyDCWYzq9xlTmX2suQJxrj0v8fvLm4DWTV1mvyb6QopVsHAH?=
 =?us-ascii?Q?L68JYdwoePos+LtYPe8wl4ByIfhov6dvGgJyQthG9lx7ahtEKx5fqbkheRlP?=
 =?us-ascii?Q?AZO4WsaUYkXBoi3p4uyf0rMEDdbu5XrsTEp1c5udZhhaPXv05x772dGG2j/U?=
 =?us-ascii?Q?F8DdmxV4LtQMlZNgNdIbRdnEAGotUTFwm9LrswsIw4M0Rd0LFOYWXyEE5HW7?=
 =?us-ascii?Q?lS+pm1JXrdOw91EoKTY2CtIi/FsXb2Ka/DYI2ZMT785zlaQNVRt/MIlx5AIg?=
 =?us-ascii?Q?GHyR9ie+WJgvr2O3inCXl/twb4E0SkEAjr0M7JhiPvXlPSKAtonO5qxfj9iN?=
 =?us-ascii?Q?Frb71KptpP4eJiVlxNF8QMfCLRvPExdADTOJyG3b1mGOaqUiBdc/3KKAcaaF?=
 =?us-ascii?Q?SJwmJh83wBFyQeC3CwRx+QjlqpC1oOOPCNE++OE2BYw8yTyE7yIpLNEpP8vi?=
 =?us-ascii?Q?tixc8l3T4kkxvz/FQT+T3iR8xAiXp+uL62+xjyyit3HbVeeoJa76VjC6X2rd?=
 =?us-ascii?Q?kXlGnwn/Ye1gvVzBvUZO3LlOoRIET6qcXPWqkZuc008ZdDiEFu+nyuJPue/w?=
 =?us-ascii?Q?dg70L1vlaPcR7c/AAKM4/u4Bbkf0XlDD3UIL+jpg3V6i0OTCsA2ydaNf3IPE?=
 =?us-ascii?Q?k2+UUQ64GJmsDhS+gFRb8u0ww9lz1CVpHWKYO8gk3DHFy5pDtSxMzorPrDc5?=
 =?us-ascii?Q?6Gcet7amiZh+OTeZeagOItz/YG5bzWlJfpS6iG9E2n9Wdvl6BaeMrf222rdn?=
 =?us-ascii?Q?fPCVmVxZVBw0ZxKE7MHuP+gb0Lsloe56rF+xm+NETX7Pm/zoqskLlDF+/G3p?=
 =?us-ascii?Q?puIqu3xk4wQrfu2FTSbev0jPF/8fdIXOxOjz21yt8b4ZfFcT9Jykc1beShhq?=
 =?us-ascii?Q?adf8S+WKOOpjWfYUjsMgOwtRvgG8ptfHhQUFbgCtcEFEKvDP4bEJ2fIRmZI1?=
 =?us-ascii?Q?/Wsbz4nRXj+fFcxZQUZ61CtZhP/1JLzifIhmwcEkzP1SyAKRYwjfZBrd/795?=
 =?us-ascii?Q?rPw6X41sX35Ot1vv3FMP9CX11IFqjpLU/s4f3ccAov3VejLJ8wAm+OLwqqVS?=
 =?us-ascii?Q?AOQ5MP+rzJM4IFWw8AHWyz7PpK0Gas1Dj2MQEKQlFf0jiFzcIFUvBFpQoYFi?=
 =?us-ascii?Q?XjC71+5uw+4yfyr2ox69Vrd5ldgjjggS280BDXctGhqoYvwW7LSoaFqumBar?=
 =?us-ascii?Q?BNxdTPd88sQFdnbkrdewK8yX3nkSB9xKprpN8Bhq5Qb7JuTG9+QiFoZGSW6k?=
 =?us-ascii?Q?csRN2TByhNw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WHE1hVPrWycPypEIICOlqz7PqKfbdFcp1yBXdwuhikrtI/cNPouJccjrkSy9?=
 =?us-ascii?Q?kLfdENBbw+IUuWGRrvXh2gYgxKPoV0Xdyf98lWoaan0YrbRTYssRkZk+O0Qh?=
 =?us-ascii?Q?x0MxWpcrxec12jgkgRAsqOWMQXIdRUn6h6PiNtg7mg9F2xoU4/SLvwH/I2v3?=
 =?us-ascii?Q?pvtrFIeOjR0rhUPIxUXFC1e4Uxwa2IhRSbK9mQFQtUUfV3HKOScjFBWRdmfi?=
 =?us-ascii?Q?LnIVOI666wICX1iI7BbfWB01DiS6B0e8AJUgBGYP1X5o1Gkd1vFMdZRvTwdh?=
 =?us-ascii?Q?XFkmbaJlt5Bl3xDqSB1Z0XXGfnXZFT25h5DIA1gGxU9XhMbFYsijToQ4XcP1?=
 =?us-ascii?Q?ot34Y6fR01Y0cDOatHn+f7ri2nsybs9+heLUbS5OoOX9vq1AEjtsZm/rCo9n?=
 =?us-ascii?Q?p/rxQ3thu2mAzWDuX2ssWh15DptNfHnxvp0JIxsHzCdzQW2zGtkAFmwNcvqf?=
 =?us-ascii?Q?Zl/FvQa5rU/AUw5PnRutRmDA7+CRzZL3N9P/yGo6+ERxMVdzT5ss3pLSGmHV?=
 =?us-ascii?Q?F7woOYZX0KIbOm5lB7WvjW1h27iHZbEQ8pQ4D4i5ZncxrxfpvMCPg4tH+fUi?=
 =?us-ascii?Q?XbP2Wtsl6PiPgjjhueTy/no3TGXoP7WJKwfYcnVf1oJ4uyRVQat74zNUn0pF?=
 =?us-ascii?Q?UWLj82v0H4R3519rcYpQdwW0fZ5kR2hsVjlUXgu5T2N4gd+xfxckEbFVzy9D?=
 =?us-ascii?Q?bQedHyS2N5wAp2grTY1waG+q/pypQ0Wytb/mWaMKFGrlpgJzKFgQ4PBdTxze?=
 =?us-ascii?Q?Dm+dHmGo6+Iiab/XKC8h5+QG8xedEjw/uzUxML9jtsBpjLOrJaJSEOFkV8LV?=
 =?us-ascii?Q?MZaIrJzhrNRlFuCCvN6vUZISz2S53jmgHhX7EPk/FlUJKWvGkCc6L/AhDt+f?=
 =?us-ascii?Q?81B/qP211+k/ya9uM9rqAqDcUmDI8SLhErErh7J4/13rMWlslkzgRRVO5Jbs?=
 =?us-ascii?Q?FjqIABgkHHL+tlqcYYiDbl02+VdgbR8dwp8vYP7U6N2jesQLvlJNb7TRcZ2v?=
 =?us-ascii?Q?Skdvmp4KB4JwSkIDyYFKYALhdXdf+8TFsK+fplwfMUWnc5W2rBT6m/av7Hbh?=
 =?us-ascii?Q?O4NQVxs5c59DcehPKcDEub2+51LFOMgNtNLufh/ReOug7vweSKSyEVmB+hV5?=
 =?us-ascii?Q?TlyDiKx1hNUto0Mc/oXbjuvFv7ANrRw6C6G/6VAR2g2ftxqEEvY5DRZwbXyJ?=
 =?us-ascii?Q?wB0hxmw/RYI9yL2GmKyZtdCWO38vDgXRutVVAU7c55HIOhQ+K9RXxlUa9tul?=
 =?us-ascii?Q?O7YwTEsvK6Egyfhhf9R99RW7zf9CyWg4H3xtbDBWIOrzkzT6rSBvR/T0+rdk?=
 =?us-ascii?Q?hLbnbrlYIM7ThSlrzo+6qOxphwiNEjqiQ9+FeYTAsvMFVJBABiEm7xkIOAMr?=
 =?us-ascii?Q?DfIbQyRtcV4bR0joHkVpIX4OseLBa+TbP29Jgm3vtWhvZtLtV78UdxEu8wvn?=
 =?us-ascii?Q?8eu/T5M7lIp57pfUEk7v/X3tbtpdErMyXUo2vu7X5ji/IBzyWdoBulPHDN2+?=
 =?us-ascii?Q?CsPn1wDY261oLbU9cUjHLoYldIAFvENWhbYhbv8Npj2fqmRKmoM7IbOhpb2b?=
 =?us-ascii?Q?vfe3OWpmIu/ujPW+kR9stbIrxKWQMBlpbNgJdULd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73bb02ff-5e6a-452d-3049-08dd76bb6d99
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:35:52.8846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dFVkETq2pZKuq3VxlZ1YCkAcVhNsUUnv/a2qWx+d3O3Ky41mtPsQSeeeGo/pg/P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

virtio-iommu has a mode where the IDENTITY domain is actually a paging
domain with an identity mapping covering some of the system address
space manually created.

To support this add a new domain_alloc_identity() op that accepts
the struct device so that virtio can allocate and fully finalize a
paging domain to return.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 20 ++++++++++++--------
 include/linux/iommu.h |  4 ++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c8033ca6637771..a61cceb706ed43 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1626,15 +1626,19 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
 	if (ops->identity_domain)
 		return ops->identity_domain;
 
-	/* Older drivers create the identity domain via ops->domain_alloc() */
-	if (!ops->domain_alloc)
+	if (ops->domain_alloc_identity) {
+		domain = ops->domain_alloc_identity(dev);
+		if (IS_ERR(domain))
+			return domain;
+	} else if (ops->domain_alloc) {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
 		return ERR_PTR(-EOPNOTSUPP);
-
-	domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
-	if (IS_ERR(domain))
-		return domain;
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
+	}
 
 	iommu_domain_init(domain, IOMMU_DOMAIN_IDENTITY, ops);
 	return domain;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ccce8a751e2a55..0f7544b4da9e93 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -572,6 +572,9 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  * @domain_alloc: allocate and return an iommu domain if success. Otherwise
  *                NULL is returned. The domain is not fully initialized until
  *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
+ *                         use identity_domain instead. This should only be used
+ *                         if dynamic logic is necessary.
  * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
  *                     input parameters as defined in
  *                     include/uapi/linux/iommufd.h. The @user_data can be
@@ -630,6 +633,7 @@ struct iommu_ops {
 
 	/* Domain allocation and freeing by the iommu driver */
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
 		const struct iommu_user_data *user_data);
-- 
2.43.0

