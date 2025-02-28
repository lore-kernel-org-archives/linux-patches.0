Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFD346B8;
	Fri, 28 Feb 2025 00:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740702015; cv=fail; b=oKPnBuxtuKUH1f/AQaa7dGVTQoYIxa5sN1kuWsq8NzhfoIW9yhd2WD4lQLJS8Mr+roQXscdE5txW7X/445c2MhTPyHYhGOJt+KX3PodedjwBpVhPRbX5eflmjd9mME8tS4Bmq9POVX4qLXZMPbv7ryIBghRPao/cKY1Wjb6J3zQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740702015; c=relaxed/simple;
	bh=ccXCrlZY6Za72Qi//cY+cGqRV903qA6GJA/oGh3iBR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QwbkmNSFHx0u4+dGbg6f/6uxyQcYxB9flxrcpmWU/HFiklJJG+oo3sJILJS/R8BPgixph+e+blx4NhczbcVgXaj27FSUSRcGq2hMr6YB4tE6YNwCpkl3Jws9XO3M5Um/ilesovudDkIgq+K1M1qfN5uPNHhjZZNYU6UfSDrfN5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Awpp/muu; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Awpp/muu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qf0/W6b3Ft2ZcJO4imnZ4nfTpL9jVWOrRb1O5Vm1u8EcR0fnW+NXCUpmmVjY+6/IVYf1VYVI2UWSrUjptuYAsgdiVj5CLhzGVPRG2sLq86HVitSFVq/1u2wZvtsf5E4nXC8YSBP2rTHQ6S1KrDZHhHY3DCR7b3Y5FLinRjr+U6aDyrZXqGQn50PHN+KH/bBYmGo1A8I10PDevy5DKhlRNR/4yteQ2f93g1IQfSDemXCnmN10AClyzZbaxohe+Ka1lEkOYNB5AjeHBjIbAPNV9EMWnScHYGECM2+AitW98kJnRg3Y7EKLhHL4Xq7r+jL7xm/2DU8PHXeeyAIH8NQkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFsNFaa/RGi1ajQOjidwsoz+ELtvVOKOZI8sLxbhULE=;
 b=XjgVY0dVilGVEnmZGnpA7cQyBmCWB60tSEmh62uFCpomucc2ggWco3NqExmnD7tZWVHUN2Glrz7vlAgXfYTIUHPLc2ITiX4S/gX+wDOs8iDyKMtJ7nthoZcYTsy+x6d8sgadMEbgBfO0vM8jg+qCFuI+7tAUx689W5dCwlzRF5zQURtLhc6jQMZutrJV+fACubtuAoUgsHFA/0XRY+j3BkAbF4sdYZ8lNoEO8Aaa6Z8KrWXwXrZKuPQ5nyCccG5K0323YqK3VoobXFQf+StE88mmKW4ZGtzMCONJaEojgt12k0f9yoMS4AJZZ1p2TBEfCRSIPaBDaovXEA85al6S2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFsNFaa/RGi1ajQOjidwsoz+ELtvVOKOZI8sLxbhULE=;
 b=Awpp/muu26Jx/R4Zkzzq6E6BIIyg0CDkNoQ/aXLufXvJZFMhQVsUu+QuPW1KBPdSmPalbkaIwrjH4tsJuTd6bd17wdTJF1y9oDUDOY4LBlc29D5bsvh9u8ihaf7qajUMqHGs7v/I9tlFkF8bmnbwENipSPV1QtMz/GLcwKUnBIj+eYDacqga9PaL2qA1vPeYtxHszM/ieBmBJ7kplgV4MU28f4xeSy9zkNX7cpA4Vzt7O93QgLFzPBWPpImA/DSgATprK/cKVbGfAg/KqdilXfF6lEN0MSyDezNmYkVaFE64JFfzhWJdWMhznbkV7Mzn4laorMUHenJ/NjriUyk0xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 00:20:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:20:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 1/5] iommu/virtio: Break out bypass identity support into a global static
Date: Thu, 27 Feb 2025 20:19:59 -0400
Message-ID: <1-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: 59800929-dd0b-4d78-da67-08dd578da713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fxmkYh8ALZrZ8lVBUpvz5eVLAuE1qAxHkTh4Yd8/7W5WgnOXPoQtioDQ20f/?=
 =?us-ascii?Q?zEa3OS/34GRUOhSbyzUnKKcHUvp1645JxLoC7U5+XxUC84paff39BbK1DRJm?=
 =?us-ascii?Q?7X6SdBnbkoY4Jp1p0Kt14Gyh83969fmXLoek/GPX0iI81NrvrSyV3qB19ce6?=
 =?us-ascii?Q?UfudNHpy67S7Z3HL7okJUS1chDoSoxdDuD0+sTk5uFimC1HwNO5Rn6stoDe1?=
 =?us-ascii?Q?PkiBJfxyPcskT7+ZSl0zLI854DsSDQwgqR04cydE3w2JY0yrJ7HjPPyOD28T?=
 =?us-ascii?Q?dqv40hHoJGCXmbyNdc12dxhvUIkqjGe4h80M8L37Ao+rfwBigw+zyCO+7SOg?=
 =?us-ascii?Q?9j/A8dsmOFxT8j4fBhupd+fSvEl151DcGiiK8QB/BYQL0AsuG1GM/m7N37K6?=
 =?us-ascii?Q?KQG46USPw3ZZTGNMJvW4ksxszxCWhBKI79ehqm/h2mCFZ/qLwG16GWC3c/l1?=
 =?us-ascii?Q?mGk3bwp6q21GVbWxudljtWssh56bFbcNvIzayp87Wl/tXJo5gVAXgUbA5D8O?=
 =?us-ascii?Q?PVExKZLTlT6RWi46OQd9/cAYiZ9hNjmkzRDg1QhetEf1qUgeSIsLOfr+De0v?=
 =?us-ascii?Q?5m6j7ReMXRO6L311DAr3n/gZ5rXJCBvR2Tk6mLWX0PSu8rvzG2DyTDyeACbb?=
 =?us-ascii?Q?3MzLUMWt5T/oMjVIU5MPorbOwdcRt+UovAJsMepf5hWM/jWKsezjHC765GzR?=
 =?us-ascii?Q?1woj3yFhwan4+FiX/Yeoe++R6xePUbyfvzBC7nByFnxvs1L7avJAhGtlPND9?=
 =?us-ascii?Q?nJ6KVJ2pcSATZTb6ewz+gl7uq9k9ttfqkqgx0TTWGV1LtqheCKTeEHBdYPsL?=
 =?us-ascii?Q?WCQytJuQ2lxaPLi6bp5TQCIxa/gKX5EfnyA8stzoy43og5sS5LNW5ur2UFQk?=
 =?us-ascii?Q?9HCr0ufZ2FFRWnjwpH4o8Yk1z3BEd10Fe3ia0AXPAxTLLqeLgJsmfeVyJ4tR?=
 =?us-ascii?Q?261jrl2tDaordNhS9uIIuRgo5ozYCU8wdFKGMcCJ7POjEMs6oceqpssoMqNw?=
 =?us-ascii?Q?4bQ7MJ6rQ6pA9TyPMLXxmIUGYga9Bli/KqGfnc649mr+Pr28di//PRtlrfrz?=
 =?us-ascii?Q?eWmvIRCK5dhSPYaKe35xeWjJToTJvEF8tCEDcGQcjXKQ96ygCOy9Ed7K588g?=
 =?us-ascii?Q?+NNDF35N8CJuwiq3Tcf0wBbdN7cwE1pRp9A472e6g8PY7rvfiC3ja5P9NRkt?=
 =?us-ascii?Q?UH+5Fm2JNxtZ6TP6J0FSra1yWkAjffWK6C0jIPHn+G/gECK4OEDP62xTDpt6?=
 =?us-ascii?Q?PKZbCQQupjkeeOxeJBwQhmp6kelXIrfFoyJ3sXsVbHZsw+ttGT4/7F2qXlmi?=
 =?us-ascii?Q?DeQQG/kj00Ux646yHtKMqQo6r5sm3m+pL0t9jSqpAv1BkOhIfg8XSwHVES+C?=
 =?us-ascii?Q?T7ANRfJtHtCLJIp+dk+TW4fJsfkV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bMqVhtLvuP2nOOfDHIlNbPktNQS397qaNRzuEqkN/+IB2AqGiydl4Pihh/NS?=
 =?us-ascii?Q?9hFnmqgY48Ia9PIGP8KT7K/3D/60dbNkaGvPVyRySTgPpiij6nZSFWlrhYTN?=
 =?us-ascii?Q?YlDWWBclLfflBU55zke78QkogLoJNMYL3zvTePzlNgeKiZJx2rdYRLJKV0RI?=
 =?us-ascii?Q?grSMgyzYu5JmA/3GncJ4DbvD75JRUQap3jXwjfgr4b0cOLdst0Sw+jZTg6JK?=
 =?us-ascii?Q?GK3NFEKaC74axFFinVnBf/R12BBCqHP2e0n8xQrV4Sgy3EJycGepBbsKerOX?=
 =?us-ascii?Q?D2IgFp43cwFjcDAlgVKeSPGMJrUClFy5GfxJTyYhF0UmgZftqWysQcZTMn1D?=
 =?us-ascii?Q?d9J32+CKn/9HBHHUR3ATwpWLachJ2VZWoVvsKE27ghQzy09atl4qZgEXuwCx?=
 =?us-ascii?Q?iI+kXZGkd4hTpPgfe/JYLaRZcGZzwWq5Q1a3e88fiE42tYtuIPgWPdOJ1X6N?=
 =?us-ascii?Q?wFh8guMBAVj7T6aMR5Qp7EYUKAYXGHLn7I2PP+Kglz0GjQiv4dCPOdJPqM/K?=
 =?us-ascii?Q?RaO63/y03rTC4XGjsXuNEQFntI2QkS6/uJDfLg7bqw9GW/48uo3OYZRpwI07?=
 =?us-ascii?Q?f/a5/UwgvncDiSdbfz9fyoXA2lXvjDspBo2qpi1ulfa3dsSDoZYeLBxWXK76?=
 =?us-ascii?Q?erTXolpVzsEaObllwgUgahsg5p5LVr8XS/TKD776cNzKo6UE8ujYyih8eI6u?=
 =?us-ascii?Q?cJqSMqurGOwNI/BYl7rrBb3M8MlfJmCZOCCdgHHn40FzSnRqF6omO0FPKAAZ?=
 =?us-ascii?Q?VE5KZe0MrUG+BYMY7Jfq185tMaAThDHh5pCiFyqvhQy6J2SmtmcOUAIxYTlg?=
 =?us-ascii?Q?dI8rjmnZjPkIAZjidbC906zcr7aXCh4QNc8/xA8DieSHlUr/tzHkqENU4sfK?=
 =?us-ascii?Q?QLjSgEK2HviuSfu3OQ+ncY2qCn5zAo/S16b1NJs/EcfH16RWfvQr427g/x7C?=
 =?us-ascii?Q?vv+wyR1wfu8J1puQBclFKnxStvGygLSqNtYkJ67OhfVj3JNNm8GWtDV58PXX?=
 =?us-ascii?Q?+9SCKg3gOSyowqEqCEO+y9JXn4qPHLHP/wopGRsCGo/5M1oVKVVepnyIVwbY?=
 =?us-ascii?Q?iA6GyWJARP13Iij2ckq7FNAw5YTIWO03y6vDZbA4hAfinEF+Qcikz1ct9Udq?=
 =?us-ascii?Q?Pr25B/9TaPX22/QmEtkXagZ3dC8LMNz7hdFg4uzAAUi+M0XeOdvj1gEsF5pV?=
 =?us-ascii?Q?utb5s7y0dvkW9yUNGHw6m7LnThwMmuTTi714aRsmsdLGouGeVp/MoHl94Rgd?=
 =?us-ascii?Q?3ZZ6sV33WlZVJcd8od3kN10GuSECFIQ6D/sPRVUoxZu9xOoAm3VeWUHOYJcQ?=
 =?us-ascii?Q?wD3s6s2h+CQmRvffS/HRQKYwkvZ5reo3ZcdcN8ENI5WMqYj38vh6cRmNMmRX?=
 =?us-ascii?Q?JeroxXfWopuA1LCN9QFANo5oGMiMA7jkmxoAtmdao3LVvTc9MZV83BCfq9xN?=
 =?us-ascii?Q?Fm/Z+9FksfjoBtkf500LccozAQ8Yz1gDsZE276zGvU1I1hixgAXPS7GxSoqR?=
 =?us-ascii?Q?fidm/fHTOCvsDa9gM0gqHrV9wqPA1r6XSjFbsz7j0usok9rTF0WhAyziijDc?=
 =?us-ascii?Q?r1hbKySMnM9TjM/9Ghs4pb2h57Zz1mNZWL49OhEq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59800929-dd0b-4d78-da67-08dd578da713
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:20:06.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BA0LFR06/dECF6ztZHnCafzom9BH7honcpXDLmKhopVxdBhDP/6SAO7CxuJwxw0J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

To make way for a domain_alloc_paging conversion add the typical global
static IDENTITY domain. This supports VMMs that have a
VIRTIO_IOMMU_F_BYPASS_CONFIG config.

If the VMM does not have support then the domain_alloc path is still used,
which creates an IDENTITY domain out of a paging domain.

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

