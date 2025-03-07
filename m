Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B65E2417E6;
	Fri,  7 Mar 2025 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741371460; cv=fail; b=P123PPA4yKYc1JTOTB3FSOnhht2JUs4UKwEgniDVAqxVs92tMOwtrN+6VS9L3+CjLO5eZTUbQbKXwE0K2ekw+SQHVMW01UE0UNi4npbIZokgn83BJ9nmb00b7vwi1/VgiZEeKiGVVcmr3xE5wjSqPFSWYPO4zm/kvUwryD0ZDKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741371460; c=relaxed/simple;
	bh=JEjIsfJKdNbu4F2vubB7wbz3QGOUBQ49pWpx5EV5lUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pas1kcsWgsNLK5E3zMlF4d2kKXxNr3Ot/tsF7wjO1lLA7KHwWDDnOJs3r8iUka0tKi/cTayal3AVvVzevLTgcpWYWMoD9o0upcuGu4DknwpfUIna6gedXrTWeCB8Rm7iersu8KDqvCH5aUYpW65qbGJPJ0Q8I3NIZFR9E/FaztM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eTcUln5g; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eTcUln5g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+ycGAKwxQ/LirclzdXJUarMjAha30yUpNszAOx88xMBjBV9DCcJm/bPy6zbJi7vqxEE6pfXZ6XIR4DiT3H/o36QnAk3c/MpJD3cZIZcieF8OGMcRKEvdZWPQeuDB9aeSc3ydB+GXAvkyFJKdpRbFQHEAjgEisJjzDjruwE9UGLMwQ5RRwabkk3IZUujQ4wcCvzGo9Y4H2ooYpGeolku8HtbeRnbqZBiP1ndumkgXCPqB0RSahQLcjVE6IFGfA/KH23q5FGVXkqobI4Q9CZPvodWmrBFCLjB+yqW/3J6yTAbiuSTRQzwAVcAFLu9q0W3h8F9Bon9ojAkZRdURXbTiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9Cl0HOw73/dgt1KzMqmyOKXk4lFgbO8rnzDD+fNCMM=;
 b=mDiDCKLzh+gQ13wjGzt+fW1vDVNVKMxRMB6fgQmCH0bs40nC8alx9yY4VWLKlc22DNi2rwXDID2VWk9wjB/fe9J7iiFrthB6pII+/DOT+IxLmUbhZol8fiQDQPFf7YTQ76rCirZLws3NMZ6Tyc6CgNGKlUOM4VMQ5f/c9ZgZeRD+HkuYnuEZhrAAT3WFodZTtj1WmQXFiI2uUyN0CzcDV8u5O5MyY1DgTdLPEom9M/0Hf2CV/h581e8lS5RTqskdCb41K2/krdBzRSdmDmeyzwHTQ99b2SXKclYyYDZmm8D1QNilfUk1PEXF0xKqodgu+dojww7xg8wRzWhpCxKyVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9Cl0HOw73/dgt1KzMqmyOKXk4lFgbO8rnzDD+fNCMM=;
 b=eTcUln5gpnFwIUOf8T6t7JNrGOj5EHW/Q9hvL9GnPpRhvQXnl36osvt7NkYk+OJIT1G09UwcJbq9IXPhDF73bylbNB7erkSeYAk9rDodQHtALuRp5NDhXXqCB3IybGolqtT1YQEQ4DhlcldyimO5Y7M9HhBg7ZqCZ7R+pq1rF7E4j8GZhPLBk6Tr72EUl3hpgMEw/7nhdv+lPNpw1LcABCnToSrZkKxA+f+HHGpmRnJJeNDVYJ8MEcYIYeB+r10jj0PCAwBkxE5QUUD42C0Uw7Nac8TVM+6ttaEwZaB7JHt2gFPAC0pgAMOL3XRjhKGLbD9pul4ePXZGu+8JYbDi4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Fri, 7 Mar
 2025 18:17:31 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 18:17:31 +0000
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
Subject: [PATCH v3 1/5] iommu/virtio: Break out bypass identity support into a global static
Date: Fri,  7 Mar 2025 14:17:22 -0400
Message-ID: <1-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0875.namprd03.prod.outlook.com
 (2603:10b6:408:13c::10) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 66b24bf1-5e7b-4093-aec0-08dd5da452a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lQro+NjYHnQg45kSIdD5PEUNsXdDrm3jGelFODlCY5tXtbXfmzpkhLbGH3nm?=
 =?us-ascii?Q?I3pV6M4ThyUBQTs8xfR81DJYouMUx4L4DLqUBCc2KoUv6XBY4nA7NzyuI4kj?=
 =?us-ascii?Q?V6UKrMf32FYkbTsu+1tQa9P3XYzBp8I3Epcw2wbkEXUudSU5CQYf+hRUDDSo?=
 =?us-ascii?Q?CQrJIeyeXPqrvDD8Oh/t9CO4mNU7y+0Tnr2yQjo4MhU7QxHKJ+qlRDOw7LmS?=
 =?us-ascii?Q?lYTAbP1TxIyPlzMzxHh+EpNVHwOfmuun/iHAR3W4KP71hP3SIeaay0JMrKYL?=
 =?us-ascii?Q?2vTD9+soYUM77S0RB+kKyJe1wI0WwAE+6HNb7djfjPD0q+cydlp4VAYq47rD?=
 =?us-ascii?Q?xC4Udx92wHDswCmdCv7287waJeSTzcA0iyMdR1cD/UWsg2UrxZyK01AcprRZ?=
 =?us-ascii?Q?0Q/VD+OAv6B60tf+4N101LyZeU2sfW7WyJKdRoXasNf9R/7vEXPxNdx1OSyh?=
 =?us-ascii?Q?IXGWlmXpOuKIngIoVfj08Gm7pqyXj5YM6JI7+gkgLwAJMmdT+Ln7JjQotFhG?=
 =?us-ascii?Q?AiGa/AO2akWR0eWn9VJGNZ/ywpmb0EVR4fp0mKe+fySMYfxzdwyOxGKJrJ3R?=
 =?us-ascii?Q?G1RAUPPtRCpH/FtXxHvKr5jvmIkhp8lwuXfqt95h79bvCuNXqPGO8sA7vgrQ?=
 =?us-ascii?Q?iEZ06BXqYlcYOz/CKLXzHJi5VnftBMBhRL1oF0F8iQRoaUApGoDsnPaDu0Ms?=
 =?us-ascii?Q?9YmXg/9h1VX6YaxHzeDgP2W99yAAl6Ae0uI90sdzg2hUFnssiEdYowZVxZVH?=
 =?us-ascii?Q?SIGV+3mq1mQ6qerye/0TG2OeBzAbJDHfIvi5qFczavgw+dnEM2L2+IIMwezo?=
 =?us-ascii?Q?rv6AFFVRogC4mFwCFiJhf10PaffQvjSAubxrTY9hYTT9cZC3luBbaAH1Yoef?=
 =?us-ascii?Q?Qi7EWCJOXH5XMzeuZnej7aVxGYKhKocZuGk6IJBBAea2YC/9Un0Im4dHlLfz?=
 =?us-ascii?Q?GNytyj0crik82CVCuePkgtk+7W/Us90YvukwaDupWISpA/8KMkqmUt8MBPDR?=
 =?us-ascii?Q?kTksKbbsbiT2QOjkKnNR4uj8BhSuzEbkcwHqmMM8xJ9dtr3VjaVZGMaZNmpI?=
 =?us-ascii?Q?FatJWbsPQbQrY17481KjeiYH3ESc1u5wKilY5E6lx2nb8SYc+AM0OxStcJB9?=
 =?us-ascii?Q?9NPUrx/NbmX1+be5qGFQX7BFYtkfx186zArs64lefhlkl1KpWx+j7lPFCjon?=
 =?us-ascii?Q?xvg2up3zUc/88KhO5rxi369xmI4WnPX3ostosk05iHE7PZhSFteyO0iN5hro?=
 =?us-ascii?Q?lsIjTysyfFHHXtzaE7D2S7mmwAKfIknK0GPaf7syE/7B+57Ctk9XXLUgjeJk?=
 =?us-ascii?Q?EjYgy7mKVaCaf2q4kBUaK/Cl4MsEIxrPhs2XolT1s4nOkFcgJDErwPxz8Jgh?=
 =?us-ascii?Q?QWTkPLiXygsQWYpmHjwB5V1Oe6oE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N5U6fjCBBphy+urTFXjYlGZxyHJZHKIrP9VQE3sEZsOO51eWgEVdrXn6kER5?=
 =?us-ascii?Q?idKlggWeA3LUCxwqXjoYPOBi4rhkqCki8Gyz4OlSLpDpiT5Svh/QKjzcv7Jm?=
 =?us-ascii?Q?CqOVmKP+RPDOxtpsjBF6qIHi7BAZdrdgUtR+ZHOsHVFx81VPjKjvYB5eqXkZ?=
 =?us-ascii?Q?cd096mY5hk3ewa79PQ83f36HrVCNgXbPFNLWVFJQJDrIgzA8ayfi3HuoVi/K?=
 =?us-ascii?Q?Q2AdjaS05IkVPVEQJKTlzrq9cPBjdxQ0e0ifmZHyqDIsCYOs1RUsUOTTfPmV?=
 =?us-ascii?Q?c9U8Babk++0ASiDoN6JA5MLTNBRRHptn1fuP1yQVhHBEcG/G6XTxmPwgG8kB?=
 =?us-ascii?Q?LvS3A5NPgNP3CUfqJjOx6nCPEYSzdTl/hovXi+KtBOsW+oIuIhpd6ZRlE4lb?=
 =?us-ascii?Q?9xd160o7Fhl9a3eFuV5BFvMobBq0z48HrYStQUdt3AgdcAOBRoGCzYSAi1rC?=
 =?us-ascii?Q?lfLMyebpCXYncYiVPOlpsr12AMUFIaujwP+RfMdNdgT0OBYiTM8HwVehK2K9?=
 =?us-ascii?Q?P6l587/dY6NuHZkH9A+s1JtlHctB8g8E3J9gHtwwiuRVn2JhfDoIfS0/DEv0?=
 =?us-ascii?Q?wWcLwEnesRQu0DBb9BQ6madcWg4+gyApm0IDxdZz9ttiRyEURZfIK0S1kxQn?=
 =?us-ascii?Q?pNu2w7XXoY+hJdlPw+8QCtB3tEkcEbWIRJfRWMzgfh/A0jfBQHhpaX1M9ol9?=
 =?us-ascii?Q?C899M/m2DraBtYSwT+07Id/QnluFFWJ/UGVDcBiz1+1z27VP7zjQ/h3JYbjl?=
 =?us-ascii?Q?Ujgi39Xg+C8Dky02XLhLOC1t4BaCdFSTdCDOotw1P6tuKZX7cAZDXb3Cl3V+?=
 =?us-ascii?Q?syu27RF8l98mFMir7/rgTavHMayE70qhAJqNJbtvN3VtM7B/6U5SgZNHb1RF?=
 =?us-ascii?Q?b+OCOr9yp8T0SaWTD9WSUQyOe+RH2RxB+X0pki30UMLHwgO2sCq2+m7M/NpU?=
 =?us-ascii?Q?w/lKij8CpmjMUNuxiPy+An4DbyxP0MAOsReAULWmgxAkNrJ6+tIXQMsbbnn+?=
 =?us-ascii?Q?FZz0sTVsEu2DHNTbnfB2k23hceYG2rpY+/xO1APabk/IPdr+qUCm0tbupxtM?=
 =?us-ascii?Q?xNmwAnvUjDUOOqkxMiGEcQySDUlrwJGIBgvgVocs4xT4CPUobYck8GLPA4YL?=
 =?us-ascii?Q?+/LFlhJYWaIweRZvtX58XGXMEItri0wQzOc7Cblo4O2Oae3vv9W+U50vCTHQ?=
 =?us-ascii?Q?zCI+yH17AvccjTP99YdhJSr8b0r2gV7LGfQAn3TrbVEnAaxX8knkqJdV3Ivj?=
 =?us-ascii?Q?jSC3674wZUUkldlAuZDD7b8O3dMq1nSVgopR5dzqauVUmhwALhUHc1+Aw6Ia?=
 =?us-ascii?Q?s6feFcrI/o/L4acHbQyslIga7rtZkarFgLUpukyyjAvvhawruxnkvJLjzZKf?=
 =?us-ascii?Q?qbx1km3JqV5yQ4bYOCB280Clz/gpollUoxb/EJm/6Fj57rPI9hdoueSqR4xg?=
 =?us-ascii?Q?EKY/2rERAyy4v8tzFQYeBlf9mf6Zt1Cdg6OvdmZGD2F+/5uBPZKHJEHT6Gqg?=
 =?us-ascii?Q?keZEWKh5o1KVrxydsGFCySUYzJCAMAk1PoQmpPs+Yj+izg1C8Gxvbv0neHts?=
 =?us-ascii?Q?zaFEoaB4mG9XEJFMlpEYg9egH5SKWXrY2lePGzh6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b24bf1-5e7b-4093-aec0-08dd5da452a7
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 18:17:30.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MjD3nh3OyP080u10PXlOT3ZHkriC1jpEV0DbbJ2VezT4PS9smQVAGX2O6I3nR8q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

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

