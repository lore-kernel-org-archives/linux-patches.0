Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0657A22F175;
	Tue,  8 Apr 2025 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130162; cv=fail; b=hby1GB6+HwgNGOWEYY1mCkS3yrOUEuOLfB4qIn4tabpujz+DVzLuYHdspwk1ul+rdtiLSI3GJsQaZO7OIcf/KojGZKz0vP4RMznHI9jnuTCu26QQPR7eIwr0WqEDQK0RJQwQpGK5RxekNv1LGc+4HmI6SN6d0WSiTvesS21+Q4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130162; c=relaxed/simple;
	bh=JEjIsfJKdNbu4F2vubB7wbz3QGOUBQ49pWpx5EV5lUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jz9eX8/Msi/u+FufUIYXxYkR59gZqNwTynS6cUbDq7oOiz5WlRJ9u9JAGLlm0J1iNHZEo22TDuFJ4ea7Oq+dq2PNzEn70CC4SSO+Kwfz/dVGQFZFQhyf5OD/Z9UVA4WtE39Bi3PfFR8idRtMgORdzmQOwjYPoO5fdhoJQZogpCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kyJ2+OiF; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kyJ2+OiF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6IK7NN96v98tp2V+zyFIVorjRbz14B/lUlxV0uE9rXi7XBw16a6+suO/5ra740T2sXCKlDAj4Fo9ci5gjCXBpM88Z1CB50FlWgXxj0xqy5GyAS5xn6KYfBEgRekx7eGOHsEyAGsAgWZBQtXvzv7GxooTTGkEfc1iDq5AqDgzpwxU0+BSfXZcc6ewZ74UInCnI8N5UoNXyZL9j4qYkpqRMa12bBDfE2whTZbRxGVS7hGG6ZRRbrGpM5jnIvTU7V63b187OHZV+SFdFCOA30Z2/bmWfkRp6QjPNc82FpjnlFiXcSXSbosjjfpnNmpSVAMKBCLNv8H5f3DDD6gNsJeSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9Cl0HOw73/dgt1KzMqmyOKXk4lFgbO8rnzDD+fNCMM=;
 b=fep3oatSrlpmVFOYwOW34L9K54CDNELeziNYYCiEQ/lMd+JULAhiiCbM4IZdDWxdCYphkomr+UOLELAIJX8m/sdmENYExP+JOZoi37aHK7UdfJxyeRFXV6QsHe1TKSc9BpNKU19j03V0Dwwbt8pu0hXjxq3M8ntpYUvfZRxuKJaRjI9P2MahIUsvq0Z0o9/onJAS7V9f3uHFyYmhMreqlzy8dj35Ew92cpRy8q/AZN3es4QF97+m8mwtFXBvt3h+Bp+MQZsoGWthgtNyR+6Z60gzT+yWRVu/rW1drDoPNRaPIynaHylytLTA6tBBVhPfFcoI8fhtnIUov3ka84DzjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9Cl0HOw73/dgt1KzMqmyOKXk4lFgbO8rnzDD+fNCMM=;
 b=kyJ2+OiFxq9Cgbk7sVTNJy6jjTOeBBua30CUWDAL8xRrPgIuomhWI+Ma3nYMM1udpmeJlssmx7oix6HINz/SqEjJzcoEXgFJYpgPrUF8kbZ1JbaURv0iwGzAodj2f8YSA9DFvf+MqD+jnVKa/ek7wsnzROQDjLtFgftuSwGD4p53/bYoqYyxeDI7X+SibrXovxtiadwF0bB7Kjr085Hd26HnXtFErV6bokpVy3XKSikicvUlfdIimJs/Rn8RgJRhf8WRTJZ7FxkNnYJLHjpHOo3FNIlE0e92Pypw155nK76CylxWd7z6oIE0U5gdFPL9u//1CVfQC+A17S+L+CASEg==
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
 16:35:52 +0000
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
Subject: [PATCH v4 1/5] iommu/virtio: Break out bypass identity support into a global static
Date: Tue,  8 Apr 2025 13:35:47 -0300
Message-ID: <1-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:408:f5::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 00132413-9253-44c3-2ccc-08dd76bb6d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BuxWI8jpwaJ2+JfCiatobJKkq0SOYN0KLUHtBCH5wiMBLvkFgPlDodTOG9xZ?=
 =?us-ascii?Q?y9YBFMIzP6C+3SDILqGFM2iAIW6x0C/9RIwZpSIvJYkHDVLhUpmYz+NHQkkZ?=
 =?us-ascii?Q?GZTdnEjynUgkoThTTu8SYKgEONLoYjT2nIAQ/f5DE4XcqO9umJIHPZoCLmaZ?=
 =?us-ascii?Q?CA18ySBs2PfOGmg6vdXi4sVLgD5TTSdklPXSumIx86VdowErlLGA6duqNFIU?=
 =?us-ascii?Q?AXv5XUO11zH9yWRHu8bKt4SGC8AE55fcoBulMvwO59WqqAojdW+sQmszh3n0?=
 =?us-ascii?Q?DvZN5NQyZ9SRiNlGnmkYluMiPYY65Mn8xqB4wuF2zZYwiDxo7kh8R9rZfzwP?=
 =?us-ascii?Q?v0cfGGtVMTkmRfIm5fEPckmyByEKLwxaL8CCoePXuBw0SwhCprJmbhSGwJGa?=
 =?us-ascii?Q?cYbs7qYl/VXzpEkntNmaHRsT3DAPdq7DYy4oRZvdKahpkqnaA/IwqJ7YFOsv?=
 =?us-ascii?Q?XiP4eInmX/cSJbmvfQKIqRDCUWEuzkqLkLks5SiN4dxyWCjkAwhXVIHpWSfB?=
 =?us-ascii?Q?8g3nVyRQAqRDU2Ahwi8b64HIkYGc+6h129A2xOYgAeNGIWnWiLcUel33C/N/?=
 =?us-ascii?Q?1D+nXynM3nFJ9ZHyhtQKvZuKLPAY8mVtW7Zw9a42FstNv0nZr5o+DMvukYAO?=
 =?us-ascii?Q?6LAn0y6QMzKSTHg+jFDzNe9xW9gWJlcOkqZit5vHFYxw2pWURzDxQzLXv1Kx?=
 =?us-ascii?Q?A5t63jkZqINQGCy4hPP6BBsScUy36GFFK6MNiyAu5jfbohKbziHO+nURppOc?=
 =?us-ascii?Q?HG0WbA5o1W6dnoWfkMqcYeBVvHQyRAatt4WdSspHkiFGYSLFbdl1z9pQyJJw?=
 =?us-ascii?Q?5j7PWIL2MBFfSWugr+6ZwefMaR7qKG4Q/l8mp2DU/XOShWo9iOUwm553f0rH?=
 =?us-ascii?Q?ktvGeKmGj4WENEi1BpOViOSX6jb8Wo88Vbddt0ug/CRd7anlPoyyXVSluVnI?=
 =?us-ascii?Q?wg75zv/+ojiSg/sIZUFbY8jp6gV+oI9bnUiYUkg131sk2zEriYFZDzUEJcwe?=
 =?us-ascii?Q?Qkb8PUGPwFkP8B2PJ0T+iG3HwiwODpM8Q84mSF42UpFXxLtvn2oWzRuELHJK?=
 =?us-ascii?Q?L7+FMTCqHglTSkX332XZGgnaLim7QsBKAEQedjDKCQBD3ed6BQQug3wM9PeU?=
 =?us-ascii?Q?5TJQ8omJn3k8QE5gU117gSZdhChhtWmUEZ/DdsTYSEKE1n51SwQwomJ7FXdO?=
 =?us-ascii?Q?AVj2mKxlZXRrErQHDxsnVpRtSCaYd21R1zYmjbYv3VEM9knlouGpsNxCfIQo?=
 =?us-ascii?Q?Ht8uFOjHK1hzugo2Zly/08JcNa09uq4LtizbtPshxEAZvkFqF1Ey1qdBBgVg?=
 =?us-ascii?Q?1x9TorwcCT95CaQfyFQYAV4T/XEETZ4b0kDERuJLXTZKVPphM8DLdTEFdCho?=
 =?us-ascii?Q?fUexhXUouzXjVYVgLPANrLsFH4ZYftgKYkK0hG8iSgT+AYFP6Qq8PkY0N4JV?=
 =?us-ascii?Q?gcW/XAO/N/U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CIBGj91j1cUXwWdqVMM/e4/6H+bvUCp2gjNcu94uMg4AdfCUHb0CXDwnY10Z?=
 =?us-ascii?Q?+LIWwrOGjjfo1bCOmuoqABBjaA9uzCFjygyeNDu+Nf/t9TOjuEbhj25pJFW8?=
 =?us-ascii?Q?PfJ8VHj6SAOngQ5HUsR0ju/bMntO2ggXGe1wQ7xOyfCokEhz2L5j9AIH+aVd?=
 =?us-ascii?Q?qs8QaSusczMFjvMm/od6SkG6OkuAfcNBi5T/hnei3mbr6e/dr2+1gs3ffhUg?=
 =?us-ascii?Q?hLEVG9Fu0r9I/z8AjAGcuHgFLhZ7nk+9xFISJUAv2gmIXkw8Higgn2TnRZOV?=
 =?us-ascii?Q?oMGfBBK+H63DLBCIYVOQcF/RUT+hnGlnzrPoOcYpv6EqljDayI/9rpLunAA2?=
 =?us-ascii?Q?RvYvdyjKQqb8XPanP2r0jzLZHgcMi7KGoK2qjqzl1++7zl3t9gD2XQ6uat5J?=
 =?us-ascii?Q?q6E3itR90K9jn9iqtLVTTHDrKVaYcXZdZ3ZXC09uClUnuSgp7EF0Q5r3D7Vz?=
 =?us-ascii?Q?TIsKWV6zDpgjmi10B2XvJmWUCMQFP9I7P/s8iGIB3QFYJnEbpmKaCWZtKcV1?=
 =?us-ascii?Q?lrlGk48/VS8Opuuol6iyydPECM8p9E2/QTvKo4YJ6k88aScetaa4f8p8F3if?=
 =?us-ascii?Q?a+dYpHmPqk677axcEs+xgwaHB3CL3GMs8tw903zfY+Z5pwVQ/QGumU5y848R?=
 =?us-ascii?Q?jal+aqWTwkmgz8660CoiLRW/gukOTID6JZhn9K37DsASB8gv/bAhHevfo/5Z?=
 =?us-ascii?Q?VUZDWNSxLe9mIfgzlAvEtnjhR4Q8gnWDkaL9lKJw+ctgBYM4t186AVRVAExG?=
 =?us-ascii?Q?L6cpOO5D4WsBz7oB2IgsTAF2knqBSkWt1GPVA75FmrZ1ImF1xYv15mvEzW3U?=
 =?us-ascii?Q?r8cqlGT9dC9B34A7VyALZbSUm7u/e6M3qkF7KX1E4RYdGntmcTpkze92gtbz?=
 =?us-ascii?Q?nyEJkU1ZzHlXnRf/LzRit+FIWYd32mvzP9nRZ1atMrJEgz4cfctIWHeg3A8O?=
 =?us-ascii?Q?NWr04rTTPMm3NyG/XDEbPsCWHGgQ5zGb+WvezFr8MfV6aACkd3W3ILub3K1x?=
 =?us-ascii?Q?dUfT7LCUnx8VXDiJsj7SznpWZK9hT1uPTzaeWg+WBQLKUeW7rxzQBzwXIA3U?=
 =?us-ascii?Q?F+42qxwvJwGEuY2th13nFB6OxPi+Fkv9XbUWiCz6/gGGuSnLi1hKRjjK1RCs?=
 =?us-ascii?Q?bujQYxOT69Jxf87FAxf7h2u7SoDx9xgjycFVm8L3V96YuNx2pMpjSh9Dc5iP?=
 =?us-ascii?Q?Vruv6kXiYgRwVYF3dShSkcdhWot+QBZ5VtLWYb+cCIEMK2z6Ims0OebPMQJI?=
 =?us-ascii?Q?ZhiFBXkXKbfHqT498b4zEAZVK/PBXV00gaVSJ1lu5xDoFnHqoFxKIyaXlchv?=
 =?us-ascii?Q?/Th/qqmp0Dvw5Ry9ZQXxlDeU5E1b3B9wCTE33OTX1DqEBnoricXz97074bdM?=
 =?us-ascii?Q?4tFJp7sWoV80WJhqbkRRJ4H9/5ug4RZdmwNyRl5SNbZUw18+MtcCL5rl1W0C?=
 =?us-ascii?Q?vEFBWWq/uOyeqAeU5WFAZatTX8EfGr48Uc2SPmVOd68VWRCRYQg+5Tbs3vPo?=
 =?us-ascii?Q?oQEbmDqtSyFOirSjJ2chOlNXsxKtw48xFH1TPpI+MRIWRlc699FTOWzpZv6h?=
 =?us-ascii?Q?j9/KJoQDnk33KJ1ghKHl5WWgYPhesKk8V5rVZN1M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00132413-9253-44c3-2ccc-08dd76bb6d8b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:35:52.7268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnzIlA6Vbqsk/1QQ2gxyKmhZa9wXTlLALUWk4hqhlEIUNOLw3BuI85aiAQvuOXmj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

To make way for a domain_alloc_paging conversion add the typical global
static IDENTITY domain. This supports VMMs that have a
VIRTIO_IOMMU_F_BYPASS_CONFIG config.

If the VMM does not have support then the domain_alloc path is still used,
which creates an IDENTITY domain out of a paging domain.

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/virtio-iommu.c | 86 ++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index b85ce6310ddbda..55a2188197c621 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -48,6 +48,7 @@ struct viommu_dev {
 	u64				pgsize_bitmap;
 	u32				first_domain;
 	u32				last_domain;
+	u32				identity_domain_id;
 	/* Supported MAP flags */
 	u32				map_flags;
 	u32				probe_size;
@@ -70,7 +71,6 @@ struct viommu_domain {
 	struct rb_root_cached		mappings;
 
 	unsigned long			nr_endpoints;
-	bool				bypass;
 };
 
 struct viommu_endpoint {
@@ -305,6 +305,22 @@ static int viommu_send_req_sync(struct viommu_dev *viommu, void *buf,
 	return ret;
 }
 
+static int viommu_send_attach_req(struct viommu_dev *viommu, struct device *dev,
+				  struct virtio_iommu_req_attach *req)
+{
+	int ret;
+	unsigned int i;
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		req->endpoint = cpu_to_le32(fwspec->ids[i]);
+		ret = viommu_send_req_sync(viommu, req, sizeof(*req));
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 /*
  * viommu_add_mapping - add a mapping to the internal tree
  *
@@ -687,12 +703,6 @@ static int viommu_domain_finalise(struct viommu_endpoint *vdev,
 	vdomain->viommu		= viommu;
 
 	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		if (virtio_has_feature(viommu->vdev,
-				       VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
-			vdomain->bypass = true;
-			return 0;
-		}
-
 		ret = viommu_domain_map_identity(vdev, vdomain);
 		if (ret) {
 			ida_free(&viommu->domain_ids, vdomain->id);
@@ -719,10 +729,8 @@ static void viommu_domain_free(struct iommu_domain *domain)
 
 static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
-	int i;
 	int ret = 0;
 	struct virtio_iommu_req_attach req;
-	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
 	struct viommu_domain *vdomain = to_viommu_domain(domain);
 
@@ -761,16 +769,9 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		.domain		= cpu_to_le32(vdomain->id),
 	};
 
-	if (vdomain->bypass)
-		req.flags |= cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS);
-
-	for (i = 0; i < fwspec->num_ids; i++) {
-		req.endpoint = cpu_to_le32(fwspec->ids[i]);
-
-		ret = viommu_send_req_sync(vdomain->viommu, &req, sizeof(req));
-		if (ret)
-			return ret;
-	}
+	ret = viommu_send_attach_req(vdomain->viommu, dev, &req);
+	if (ret)
+		return ret;
 
 	if (!vdomain->nr_endpoints) {
 		/*
@@ -788,6 +789,40 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static int viommu_attach_identity_domain(struct iommu_domain *domain,
+					 struct device *dev)
+{
+	int ret = 0;
+	struct virtio_iommu_req_attach req;
+	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+
+	req = (struct virtio_iommu_req_attach) {
+		.head.type	= VIRTIO_IOMMU_T_ATTACH,
+		.domain		= cpu_to_le32(vdev->viommu->identity_domain_id),
+		.flags          = cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS),
+	};
+
+	ret = viommu_send_attach_req(vdev->viommu, dev, &req);
+	if (ret)
+		return ret;
+
+	if (vdev->vdomain)
+		vdev->vdomain->nr_endpoints--;
+	vdomain->nr_endpoints++;
+	vdev->vdomain = vdomain;
+	return 0;
+}
+
+static struct viommu_domain viommu_identity_domain = {
+	.domain = {
+		.type = IOMMU_DOMAIN_IDENTITY,
+		.ops = &(const struct iommu_domain_ops) {
+			.attach_dev = viommu_attach_identity_domain,
+		},
+	},
+};
+
 static void viommu_detach_dev(struct viommu_endpoint *vdev)
 {
 	int i;
@@ -1061,6 +1096,7 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
 }
 
 static struct iommu_ops viommu_ops = {
+	.identity_domain	= &viommu_identity_domain.domain,
 	.capable		= viommu_capable,
 	.domain_alloc		= viommu_domain_alloc,
 	.probe_device		= viommu_probe_device,
@@ -1184,6 +1220,18 @@ static int viommu_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_IOMMU_F_MMIO))
 		viommu->map_flags |= VIRTIO_IOMMU_MAP_F_MMIO;
 
+	/* Reserve an ID to use as the bypass domain */
+	if (virtio_has_feature(viommu->vdev, VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
+		viommu->identity_domain_id = viommu->first_domain;
+		viommu->first_domain++;
+	} else {
+		/*
+		 * Assume the VMM is sensible and it either supports bypass on
+		 * all instances or no instances.
+		 */
+		viommu_ops.identity_domain = NULL;
+	}
+
 	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
 
 	virtio_device_ready(vdev);
-- 
2.43.0

