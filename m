Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E75C3DAC14;
	Fri,  7 Feb 2025 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939581; cv=fail; b=sh2EWDwypiNAJAckuAHWBO/goi7+YIsw8IiWAVXgAvMKp78DfsqaX+a2RyU5imCWrNAxA6wrHHUPJitv3r1vVnKxpn1/N8fEBhxC4tugSlwe3BsHKEYNE/KWqzLahfcEugf2ihNo3N5GxMfKLw2JxZm9bjNJbX5Nwz92VOFbx7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939581; c=relaxed/simple;
	bh=/DsZanOKUiRAxi15K4X8kaW3F7lumtANzuJcQlsRWZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ndAYIw7VGcgN53rsT5qT3yZL2Exj5YbswnQnATd5edujjWQ9m4vYBfZo8+xhTu2gwh+cbQx+h6q+VCQeyys9lONo1EI/ArOjvRwU7nCICegcQg/P32Ti0XUjJofees7b1eZsB5e2pHZsSspTIf2PmAADoXKL2QiUHSTjUbgupRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PT3d29Tg; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PT3d29Tg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qV89OXa/1daUYsk481R/bq/l4/hK6nGtU+4NMSdAtM5YlE7w03lfcCmVwIgmgjYwfZzJThojR54BG5jpbnZWCjO2HwvUgFXYzcS8X7hOYasFLB5HEma3jGD4v/v4BmiCFFgnx0CcULiOOHeinNE+4mrJRbxcHvLLYjSjJrsEcKMQaqkfdzk3rpntczkt16p6lQY3tSKHIfapUi5zaapjN+8dGHgdYj0iW6XW3IcBQK+frJ5GNl/QRGvKtLXGTkxFGhmC1/W6VTSSrnh+58iZeeafPu1S45uESRHDBI5gs/c14fQiDN0OECZsryy+nPROn2hZMRDPVQc0VqU0AeT49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taZDL+P8T4R41VAWufBOZjDYvZwW2jUtgpxbnymPEiE=;
 b=PtUik+h6JIcWmTMef+BAfkOgJErlZuT8BGsRZqE0P21c8ObsIf7++ehmKk5HilSfJh07zKzy3ay2rSm9/vTALplBSVNpGhJV7ihJL6+RNsWmYgXb6i3HLpJ+dWYw9XCspQQAnWqDX53zlMotpSZaxP1QmALRqq+xemJxpZWfex4NLJSWNnyozTv0qLsVrRzfN0bdU11LyayKaeCvnfQlAc3sQCbUl/MF0ZZ+wD/t+DXZvzs1gwjjGXcnXaURIoea1VnU83GkqGe9mSyzObLzzftcgOKIF/GijJxC/2s55/k4hsHZoYDI7JQWsIg7ERbT2v6CXMxWatJpZaaJP3CGnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taZDL+P8T4R41VAWufBOZjDYvZwW2jUtgpxbnymPEiE=;
 b=PT3d29TgGQgES1agX5/l+mNv4KTfNZHChowVXtQ4JKoEv/bqAtKYe7jtCMfJ/Tct0H6Vs8Xk8zbQ5p8I3EstG7pbxN0BK3f5vbC0XZt5uuN1KRqU0yVGbE5jWUFGGSRTPXs6ErT7fFrLlXyQb8rua91H6TLUNjSlHxdEESe2GgG1HoOBF20v58MPJKn/RG6gcB+ece8+GnE0PFmM0eHTLTlBLHJAPgO3znOOhyXZVEPH/JNtEikusxc8/bEXQd1sYCeE2a04tQCCWXtyoTzj5TF//43+nQfkzZETrniXb8dr8wdGpt9UbIfI/1tPegDRgu+dHQB6ARwYAEiV7WeBLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 14:46:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.011; Fri, 7 Feb 2025
 14:46:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH 1/5] iommu/virtio: Break out bypass identity support into a global static
Date: Fri,  7 Feb 2025 10:46:01 -0400
Message-ID: <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0413.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: e787b134-2bea-4cd7-4dc3-08dd478627fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ksmaViMHItEOPLzhy2zFbs856X4vo7HFPsIynUQTA54/gD/fDtDqfTYvGc5C?=
 =?us-ascii?Q?ACPkOBiuOIBniOjHkPOHgWtprx58uhUKGjkCF6Fx5ERoqlKPtgj2ZWctPk9+?=
 =?us-ascii?Q?4Vd+WRP2N3Wg1jRQN40Aw9qOQAGLvRBc4jCNtAWG9bOT5wQScr44WUAj2mMg?=
 =?us-ascii?Q?ja5ZNZU8PJs4XmJrxFJuSyeHghpqCYdeOAoLZiQKhu15hswQnNIsBWYUG8+T?=
 =?us-ascii?Q?U4chLaYoKxZctXmgjn+LKxYGJOmxXQnXEv07M6TM1aJHafRx8OBnTtWplV6s?=
 =?us-ascii?Q?WUyFOYHvByVyzU2F7HTy0DryBXFHiDdcpYvPPnKnPCpRjI41gLkrepkuNER4?=
 =?us-ascii?Q?tfRNq15VesGIO5ZZkH1EI0NwAmxhNePbj1mMFHDxmbsr9032/OaNzwK/b9bp?=
 =?us-ascii?Q?92SDC7pFwk5j97ZqU48Kxxp8AiIe9yYA1uk33h9sN0GS/ubz+kJ4GkZ77/Pi?=
 =?us-ascii?Q?6rAqJa5tod8XKRVsgv9fnGq00kFohkn501oBj06C7gf/abBtoqm6bYQO3u6w?=
 =?us-ascii?Q?H41smOVd9951GzG+Y6ftyfT2G55q0C0OoXWyQCRppUnUUW4xRI3Wvrm1ydE8?=
 =?us-ascii?Q?SyytDTN7ctIWtkZkTGqlwRXEiWLliyh5yfrrBs1IgfbMT8aFUhZCNpgN/B1a?=
 =?us-ascii?Q?aoRe4ksWpeDPIo8PkIbIRTGjZ0UkbidDuOKAQPv5rGo23zarbE79rgf8WUoe?=
 =?us-ascii?Q?EbZHKoaiZ/1Y+zYCzN5OukH06k8Wj6H20lxF0Jz+5YP7G0KoGdRfZ1AseF58?=
 =?us-ascii?Q?JPN7rhXB1GItpBI8wg6XLVoxsoH9sJWZC9zCidRRjnChuash8nlC+Ap7MheD?=
 =?us-ascii?Q?A/jg8c9cEriTPaKRpdz3AGmXfGe+Dyz4B+N5hyqaZlEvZYRPybzCcvfy1iM7?=
 =?us-ascii?Q?5U58RJ1R4eLYAuD5vYBor4qBTzdYeZKbNCd9a9QKjaXYYNdnUGM333CF3mJy?=
 =?us-ascii?Q?L30vzlUnyweZmJyFTkrDLLDzwA5OViIoL+dVjR4KgmcVf2cnrA4uYCul6S3O?=
 =?us-ascii?Q?kmoxUfEnrHWXDhCKggjjAzdk8+igyVZYBlQELlXtsDjxbbZx55wXE6jGQjKn?=
 =?us-ascii?Q?YCxiZ8pl62h3rWeWMuBZtoSN8bCUcbbIhZFhOxcZX8fpmKMKfbhR64+ORPMb?=
 =?us-ascii?Q?rkY0qYIjayl/tWykAql1aE4vjZI2OCdNBuFOa4ktrBsI+S+o1R74t1JJwqaf?=
 =?us-ascii?Q?Vd9tXldvNP48G2kWcJTxV0bkxfNetsvyWk+HNw/7oL2QGa6IPuYLDBkgOty5?=
 =?us-ascii?Q?7Z60TTbFz1LXSo3OeCS1BM0iX/098X/L2OXQPIOTUK3DDJYUd5exeLHRAp5C?=
 =?us-ascii?Q?yvpkTjL0l7yot9PbqgxLWbz17QIQpgiN12lSAjSjVhiyjLddHAbWOXo4kt0D?=
 =?us-ascii?Q?cTAA8D3gutj0uJ84wDyh1Ynku41t?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OwqFAaSefWCEwM9RjTfA75XV6WUla4WQTrbFrHfSGZus3cwntJ5PCTvadbj2?=
 =?us-ascii?Q?vcHb1MEwbsI9NBvften06dLTCE4ZSij0h+zcn5fLGEqbEfYbBoPFpKau5oVH?=
 =?us-ascii?Q?tFXBntAl6x/c5i+Wa5BxHdJvkEy6sb0BeWLjcPWYm4DVTdiJa+CKTX+f5wBG?=
 =?us-ascii?Q?01CKvy4DwGRzH4mzljtm1teNSoENN8zWJwr2UyAZnn9ZbgdP2XtSnXBZSNzu?=
 =?us-ascii?Q?XmbjgkREiCCkrBpMbVTaeKg7tL+7FaPJwoH7fMmSUKO+owJKe7SqihYnH5e6?=
 =?us-ascii?Q?sTpXIw0aSIFIII5R+IDg9yVJL9YFtcvrxvIkF2fetO/by9jnauWBEgd0uTq+?=
 =?us-ascii?Q?//I4vRNQabK63NZB+sq/Mvg75RsYa3UjJTqOHm5v7aRqutqxZaKRm+xghYJS?=
 =?us-ascii?Q?jCtjYxaOmXSa2PaZuJJa5TtmWKFS3Q6f/qYdQ8vs7VSi8Dl881KZmoLrT7RP?=
 =?us-ascii?Q?IQnfTAf3Czn23fwocK8hRFf1EFzKFH2Ily8G43ZzXPcqELKBj0HIsEYsJ9RB?=
 =?us-ascii?Q?Xx8rnzWT+5gugARk1DV012HwgeOVk4xSIyy2UBAASsF82QSjDH640UfSXlNP?=
 =?us-ascii?Q?hyKLFZuAJbNbJdODLE8krAdocNJbTsE+8QvLPKLPs9oyUhls7+eDo80rcNbt?=
 =?us-ascii?Q?+hK66UGyOx02o2hWG86epZYevWp5EQfbSsQ6I6vy3pRXmV6Xu45yq/C6as++?=
 =?us-ascii?Q?vm/zoBV2gdVWm+B6otpiEZnlKlEjTscXCY12kqchCZtnFqssvR9Dtx3/jEdW?=
 =?us-ascii?Q?5cK+OYeO3KXRjx3s/ARAFUJacc6d7rshLaky+lpkdvTCFJ10CtRFP0tQxS+w?=
 =?us-ascii?Q?wjlfLl/UT41lPhmcrrI1rGBODyicrHUApj68kHTbiU4tkjTB3164rIbuhieX?=
 =?us-ascii?Q?whyWpFNpYUKdi7Q/Eofd8WcbMI35a+MNbIUb0MeQe6gzzo+BQ8agQqyo0WWg?=
 =?us-ascii?Q?mKhmrwyHjSP/GSQwNLwEWNpYTsa9g3b4mgKms0k9UgKM9HrO5OdZB2owybjP?=
 =?us-ascii?Q?lRuz5vYgm3VJsiwAjpTIVpdXGma9yU1M0avQGQBpgPcnxh1t4fKOLds+UeQ6?=
 =?us-ascii?Q?tJ34nrPvxOUQg3tiesE69WkNwM2+h6PVWPS3+HimAabwwbprlIBc6UMOsZpo?=
 =?us-ascii?Q?o1r14h9xDrPma2vaBK7al5D1hqQYuWjYQsqECEC8vsKMLq2lPaWgofMBazig?=
 =?us-ascii?Q?o1f+0XrwD1+uIDTGFy3cdscCICmni08n1xCi7xp9gtCiTvF+8FOHajso9EQr?=
 =?us-ascii?Q?/hvopWMP/2//kViSV2VArkuU9glPuDvs9/F2l6QSmKRc1norBss+3Orhm8de?=
 =?us-ascii?Q?cjpYBA2Tt7F+l62HAW8qP16IwDy3fWx4kxO+tRuJS0ybTF1Az2BJMjMBSM2P?=
 =?us-ascii?Q?CXMhGcOOl9QRyfXqviypXdgPQFoLbD5bK0M8lxCd/UqLbeL5QZLvTIO1W5RD?=
 =?us-ascii?Q?wu5koSH4UE5ALcgEykpoesujuzIsjUY7g16pUlr1T36Hh2SbZnZSSQwuwbbI?=
 =?us-ascii?Q?tGQnxLGiSIV7fti0bt37SE8AJl/56mQp4VC8bEKzcBfvxqNPOCsHPCkYl4sX?=
 =?us-ascii?Q?2rVmEbQslTsIpcXsSl62v6fTNOAA+pLJVqoqiCoH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e787b134-2bea-4cd7-4dc3-08dd478627fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 14:46:07.9682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otjLrpz3Gg+LKsEQI3ClCp9WkiT8ffdvuTBUd87YCWHog7xy+IErw67HtuwZE0FD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

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
index b85ce6310ddbda..c71a996760bddb 100644
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
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	int ret;
+	int i;
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
+	if (vdev->vdomain) {
+		vdev->vdomain->nr_endpoints--;
+		vdomain->nr_endpoints++;
+		vdev->vdomain = vdomain;
+	}
+	return 0;
+}
+
+static struct viommu_domain viommu_identity_domain = {
+	.domain = { .type = IOMMU_DOMAIN_IDENTITY,
+		    .ops =
+			    &(const struct iommu_domain_ops){
+				    .attach_dev = viommu_attach_identity_domain,
+			    } }
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

