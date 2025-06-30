Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EC28C03A;
	Mon, 30 Jun 2025 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295853; cv=fail; b=YWLabVrpzcksWuBAdA7EjYMa9OBNusHJQv5ecNmMhtq7GfIkDD/g5AB8go8/oJ5XgQ6q4fG85GhwsR0S85wlEUbUvTo7mC69YhWLLIOyqItwBW6BnTIj1HJPrbJ+WRdXRJFqFHyWCLOZMeQGW419St/4nLfY2C0Hbn6ywfXdOt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295853; c=relaxed/simple;
	bh=+oX0Qv6X6jEcDCBr/yLBP/9qZHII7T/aQydPQ4lFrio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K/UdV6YZODuVjneoumug1yWcR5kS9YDqC59SKY0NHtSeSkM3fN4gD834Yl+o37nVL48jiONP4tuht1wfcl1hE92Seu9dKY+Sysk7lu6PLk03axLqMj7ZVGpcjaJFKLiLv7ZvUefhmxFXy4tcq2NNy/r4idlRaPzzAwwYKtnQn80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E1lNIH6f; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E1lNIH6f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJrvqnoyHY1WOGpATbo+fBv45C/8rfEQdz+RVYiaJ0rXIIdHScBrcS4rT7T6ikzu7aPjZ5fyFbfae7q8mJAJzDQYwmA+39Re0KUBAv1WawVYyic8RpRmJ83xoQKL9Evgj+DGRxFQSmCrMzybuHlle9m/LKVSjqKqbTZX/dnKjg5J5oR3fEg8bQf438C6BVRkafXswJKxhLfCakFlYG1HzTbPUkvtpEeNfHe3zWEQPLp1p5RB7RPEw/6vd52vjA/Qc2GPtvShfLw5SkdNVQ+gGFSm3/Db5mLZiJxVfsov+nPtyVVDhPr6vKKYB46fXBsq8BxFgfi+tvttwTED1dFc0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/98r3i8OXnSCj+IVmuW2Ig98YpgrQGsgWE1BKjhONs=;
 b=pclFaMIUVRtutHfAILsRpTbeyg8MCy/9FfS2GzOsCKFVy82dc0C6uFqa822GHjid2/ZK8gwWjXAIRpuqUe0e8Zai0wGojN4cln1emRz/ORO2ntTxzp4Bc4giBIOXnsIDDStMjGidqX5dHML44pbZrumcK8j40dWM9uzUUaDzj9vt9r28wJzhxxNLapeoHJ3qjrwa3piMwFP+/JPqn391wgAzPus6Q1Vhn9LUJfwDykRWN8+3BNnEBt1deAb/0BH29YGL/vODqzTpOB0euT2onOi9verlfU3UWFW/zSzg3ss0nZgycJitfgVZkyW5Y64fEkCaXOgUTVaxri5w9UfnZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/98r3i8OXnSCj+IVmuW2Ig98YpgrQGsgWE1BKjhONs=;
 b=E1lNIH6fs8T32kryESYvP+FEndocN9JqyRCMAt+ongLCMTzTwEwNddcvlGg7y1O1jgUCHkWbG0gqtYfmjUl5G2raeLr3jrT04yJe0mu4FQ/Z07F/AsVH2oEWavgQ6QmQ6UKn99adVQMLUmEZ68CUKsbJIJjTkxmdrwJ28zRDPwctCesEp9ruRRjhBGxX2CwtrjXv/HmDM0xAe8sjBUiJuito45bv0ZREfbPTDxlcYbAtQjVg6ylkniJOge9jVbsZZe0r8Y//g2jzePoH3yh8bVJmAWiDkaEgtPFcZi846WG/fB6Lg+h4Vk8dJsbXEww1t6/3mZYkf2yfpn1q+2IW6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6123.namprd12.prod.outlook.com (2603:10b6:a03:45a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Mon, 30 Jun
 2025 15:04:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 1/7] iommu/vt-d: Lift the __pa to domain_setup_first_level/intel_svm_set_dev_pasid()
Date: Mon, 30 Jun 2025 12:03:51 -0300
Message-ID: <1-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: 29df5458-27c5-46d0-da4d-08ddb7e75b02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AouBjsb079NmQX4epRmWiBaM8IMWqf2aV1MWMnkOitbn1gPnM0UHyk6L7IUr?=
 =?us-ascii?Q?5pYdN1eh8LBwB4Nv+2O4wob1jS07jIn/w4zVIQC362ZiySiSSPkvIWx0+zvg?=
 =?us-ascii?Q?ulGdER7PyP3bon8C4H2yf0T3htLTWLt4ZkyakwtqduQTa8bhVLoVBi+Mwc3X?=
 =?us-ascii?Q?henIRk7JK/yR/pMxdbRGY2zBSrBldw0dgFesbqdSZykX3blWdHdVBdsD5Rnb?=
 =?us-ascii?Q?Q78GDE1CT38JDih/+SNPZrHYJMsZitebMJJyf8VIxTbXFaBpaf+dtjjn9gHf?=
 =?us-ascii?Q?iI92oBj5/U6WssCV1m2s4Z0P9mHbn7dD8FjBUVtK9dEX4kJfpa2IpoFqc/hT?=
 =?us-ascii?Q?g4EjRMJLIlRZr1vy4I2fEV57e0bsbgfYkIROaNivM+gxOs5UbZxlmRpBcE0N?=
 =?us-ascii?Q?Ut3xCbdoV5gZEWEepZLy1rAPM90WBcf8iK8EDXXQhsigY/7GsEt96a46qg1z?=
 =?us-ascii?Q?GkRBDmmSkFXQgjWo3YtIdDIGtzF3ipF9p60rqRTBnmwktB26IXfAV4DZd8Lw?=
 =?us-ascii?Q?jH4fqGteybAJrb5OPGBfX5AsPmqNZzUVpWCbRYmL5tLVq6KMf5h84UqTLyCm?=
 =?us-ascii?Q?VVwZCNx+qZuMjkU1vLAcx1FIeLP1k02kRtWFYp8s2o8innF5JASv2Wd7r6vA?=
 =?us-ascii?Q?VYYSRvIjekTKZmIunEONqoXzyoGGtXhlxEli6TWAongV2R7YvB8RRZ9EecuG?=
 =?us-ascii?Q?kJfG/TqxsFRD9OzSoyfJzSMKWAdGLBcE574umHwxlCRESQ7sme3Cd75EQ/As?=
 =?us-ascii?Q?vDWQdUF2ZV6RBe7LJq6b+xUbZ1zcd9f9RRCwYoaeSDdiR0bEA5YJOnWzMUCT?=
 =?us-ascii?Q?Dx0S3iKTo4l9OYCB15Xedc5eopy8sZ4v33R5MhffhL73ultJyr9DuJgPhWuu?=
 =?us-ascii?Q?7ldNVaarzjUa1oI/ecsdnP6jIB3rmXH0avp7meiHsir8fZ+Ns/FfJ6U1LomV?=
 =?us-ascii?Q?f2iUHvJMifck4Nb7BwE7fnJWOM1/mYqQSfY40j205XaMbVOADWg8qTzXRHKE?=
 =?us-ascii?Q?dqxx/QgHVialvm/2aAK7f+8a3E/Hab3BtILw6Qk1aMOuYx6uzK2+kvZ7pP6o?=
 =?us-ascii?Q?EoD8Zo8pctV8LXmBGXhljqP8VTlvUqhwP8vrYnioK0hkGB2zM+sT+SdtjhwD?=
 =?us-ascii?Q?ya6Bz6tnueroAbxhO2i4A7z9t5K18PgIv6gP9EYG8QuoSnqlrjxFQAy3lK6U?=
 =?us-ascii?Q?FQJpzOhO/+6lpM9J2p4/G3W4KHwD8fuX4cXD1fD/jqvOBZfAcqCnvUgELZbw?=
 =?us-ascii?Q?YXwbv2GDKIggFMgs3bzZAEdXO6zjirkzQZEFgBKTqZiMxyuu9PLIWAT60P9V?=
 =?us-ascii?Q?7LLNTTdrcgeWK0RyeVoOzj13CAi5dEk9oKXlR5Jsq26digN45oOTtzRSE3k1?=
 =?us-ascii?Q?LyKeMtANAsTO5+En6qQc6rmqEScljwrCw//oGLZ2KrSXoHALEw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?waME1VPurq3UUZCAAcINHmpoeoiGRp4y1fdmqDZ9YKhazueo64WjaksXYiHP?=
 =?us-ascii?Q?UQBAlab0elMwK662/rdjz9duY8sQ8vgfdkrVzlkz4yujyfP7aJzT3eFzXu9P?=
 =?us-ascii?Q?ZLgNp60YSMQoBWZwiVX6JI7f+wbn2AWU4nLv2/gef6gaYorAc0PzFpkjnje3?=
 =?us-ascii?Q?5aRZ6u/OJ+UtxNSXle5s4X8BnNTgJwjgvBJrwIeArm0Ec8xrbvzoAIEYy0vo?=
 =?us-ascii?Q?le1FYipMsutkn1O+crDFfYLsj9Mdvqss5rMv6+Em5RTd4ze9K1l5ovnW5ivn?=
 =?us-ascii?Q?63cgjCzOLh3V3lmWKR671tQAbYA1pHM2mp882vf3Ju1WXK6YMb55cl9DTE36?=
 =?us-ascii?Q?x2Z+oGS1C8YFMJu2IdraQBPxZNtt2fHPi4wYI27zXAsuxOWmPNM8fdzkJeoX?=
 =?us-ascii?Q?5unoDRQ8gB/JO7g3nQIYUjl+qtMSccbRbA51m8ZzG8D/kHj6xdNny4vqZ9f2?=
 =?us-ascii?Q?ojO4xdHSbvsr4Qsbj/bNsoYOEzCSmWztMkGv6GkIzIB9Cut0W030p1xfcCw1?=
 =?us-ascii?Q?afP9szFu6Lzfc3yVCyyFshp/LDmXPj27GXs9JS7XScuHej9F3TIi8dnjykCA?=
 =?us-ascii?Q?ZPNctSlUZwv/zD+1pOhsoY0psj/mSd3bHKTWWPy6uUitTW8Oax4fe/J1F5zL?=
 =?us-ascii?Q?FvNK8U0RIZTS0lte6zUdqsqSdusAKFTCTPtAxaJ3pWHJnTKtwcryhqSupdT1?=
 =?us-ascii?Q?E+R0hbBZye0I51csBKOAapzM89dmMIZZS0mzBs8ddp9bk4ZEdBL+DpsYIjy1?=
 =?us-ascii?Q?3dcoBUDxAGrjInalBel6z7me6ZLCuxLMM83na/DxtX+J9vzWzrTojz5vyLXM?=
 =?us-ascii?Q?/4xOtKrXQroxwfeJw1sZ22HxSthyqtR3nuPrxDmfPLb8dHr1e+ISPSep8Zj3?=
 =?us-ascii?Q?DNzfYvIgup6XzgF0vdLWWcX/k5DsPgiSLce1fWs81Di4wbykCH6P2p2DbdAZ?=
 =?us-ascii?Q?2ZdRDkVw97szbgzBwsRAz6kgtZc0U/C7I3JgbOrMIECECsNW/rkzGoXABlZI?=
 =?us-ascii?Q?6fJitk0dNgkfNrhsB8az+SUcC/rKel8x3zqfN97EE02TEE9iQTRbYKLaIXO8?=
 =?us-ascii?Q?YmtGjsgUdrGoOp0as2qx+HSPHxALbzGvE/V/CXjURckpWwgf5Aq7OBlnLzEu?=
 =?us-ascii?Q?ICmZF9qdv4VH69579NkQDGDGE/OaT8KUpry2nip0EaMKoqaTpCr1RD72aqaX?=
 =?us-ascii?Q?Yb75/9qYub7n6lMKsPGc7QoCMrltuziCIvueLjvzAtv6olMArt/N+cce4BWR?=
 =?us-ascii?Q?XtUiB5Un9Zao9raam6QuBNY7CdoiX2LJ1mEk/InS9GYskuqUgt2JdSoOYcTC?=
 =?us-ascii?Q?OfkvM8QMii02Y7xyRRWpSprm5L20QeyefW+BvLWtgt9PGBJJZIulpsFVPBjB?=
 =?us-ascii?Q?vLLX+LbRbfBrxeRXo+A63H4cpBI1qh8m9aoqEy9siPdpbXkWWjvJcMN+m0Nk?=
 =?us-ascii?Q?IrEHX/4yzI6e01+PAtJlz46tcnnRCYsIdrDRkLNBdvigwWoXBhDbesj57CGO?=
 =?us-ascii?Q?6kxTIs7Vn2oY09nJAg0sh6BUlA/3lTGHKhNvj1r+tfYb90Z9quyFMxiwy65N?=
 =?us-ascii?Q?xAN2kdiZY5WaldhQB53tbJEy3kCnz+dxtz65o01c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29df5458-27c5-46d0-da4d-08ddb7e75b02
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:04:05.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: piKoQ7gpAzKHowHa6l+6mcej5OGWat4Fa/BDDw5g07dINYGsYIceamzCvQUolxUC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6123

Pass the phys_addr_t down through the call chain from the top instead of
passing a pgd_t * KVA. This moves the __pa() into
domain_setup_first_level() which is the first function to obtain the pgd
from the IOMMU page table in this call chain.

The SVA flow is also adjusted to get the pa of the mm->pgd.

iommput will move the __pa() into iommupt code, it never shares the KVA of
the page table with the driver.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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

