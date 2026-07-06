Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4B4314A6;
	Mon,  6 Jul 2026 16:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355393; cv=fail; b=XoVjhGVfqvIv+e01d5yxbU3IrJt0CAluBJUEgAhgcbpgPoSprUM/SnKhD4HCFzTUgvzaLcWONXbFR8ls9pOnxHUUC79WK6Gx5if3TS17pNeIqIhEUTu1dGBe6WAWN7tHrMeVCCAqUJT5L7HW640g9gJahnVL3UsbIuty12/0CCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355393; c=relaxed/simple;
	bh=Ltecc18rfaYcYGp9Ou+MvAxYRYyWD+b1/LgfSZhd5xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TGkqvqsoffOrRBgzrr+r5pSzR1DiG9DFIwgvW0kYlDzLbzOqquwa61qnRZlwgozVFkP/DBxEvV0hqedssDa5qITdvwMzNiqAjuWOQ8RLl90BukWpZPwkJZyYDNEweGPtXh71AAfAdfb5XXcOrZ4Sr4VtRz0llo2zQBpM0XZF6kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DdPBJsjp; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DdPBJsjp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nh9Sc90mSXnwyRMjPFhwhYn3Z+f6cBToD2jO1zGzU/VT0iw+YUoulIBRY1pWrc1OAUJjxGhlcZqM1GXc7Nl/UPqmyb1oCnL1cO2jbAfu4W4LaTAij14hTiS53JF37QP4zhscMHSuwUjaSSkXAoneWgGWpsy8MT8Izj52hpdC7ij5Nz/wO+dKIgOJYTFmnKRGrikHwsAjG8YsMentkgMhhk08/xG7o12rrjRfIxzbRBjmQH5iSjbQisMjpUfjzp7OMQjdXAawBYq0hc/El2eCgrT+aooDBIoSsnw6EVs3Ylcgn34y3JyYRy9Hg0meU11ZlM4NeQCcf/WUC+mlbq6usA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jglHIL8KoMYLF/5vepR4ekDWkytXU6Yh+ib+2a5IuQk=;
 b=rrc7zNtMSaT7ioQO7TwHV35IIhzawg+RHfaEB3Vj3Rz2IWm9ENk6tr80mxToqt/3SMWe2IqJjX0LekFnKnYMXK/YarxpTTkzSr/853lUZrHoAAREHMfOU4xERXUMOx7zSPcHnQAq0L0m0fZLEV82VSaf0BHPdJOgZvax5FNFVqwegu+IvV38g73vQUvzimPy77tiSy4ew3oL8M6q6r6M+e9C6EwtSAuCDlTrWfxkoZc7LEmciawSfe89XqUDEm7EYKlR+G6L0+9vCH5yYJGX3DJY4UqBeL6DddXKqCwtAQfLO3s5nTwEgdmr7nPxv/fO0Kq91tQ111n7js4sV/6mkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jglHIL8KoMYLF/5vepR4ekDWkytXU6Yh+ib+2a5IuQk=;
 b=DdPBJsjpGXmBhrHF/Md/Cr7Ykw1qlxIV9mk7emfympU1bT78lbgd/312oy3Lk/Z3XkhIQC5N3jd7IDbtSPTTiMSGvAfXkTTUhCTQ0gjjhdJttavDVAceIISZ95MNRp1k6OgUgS4+Rb4QGRPEbwpyrm9OLw5MGKvQFEPVnSWJHvA9cj/z7LhjHXRrvfhdxWwjlSDbr4MLdOLut9GGxzOiBq9+TpW92ft1f/1SLT8zo5T9+HCv6rfM2q4LhuSM49STwzLHYeCRAIv+iM9qvQTdjEyARYULR3QaIufYfOyFRu7mr5lqGERP8Ml06SPxTyqDRZ+1bmDax66Q/DYB2Zyzuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7926.namprd12.prod.outlook.com (2603:10b6:8:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:19 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 7/7] iommu: Remove pgsize from iommu_iotlb_gather
Date: Mon,  6 Jul 2026 13:29:13 -0300
Message-ID: <7-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0373.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: 365169f1-e23a-4c9c-07e9-08dedb7bb8b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|11063799006|3023799007|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ANjYZnn4H2Yc5v1PEu8nZDe8bOEQCcTQ3TfF57aKG5SMUlQjcekGWUbSgjpVlTBqnqEogCPueB4g4UkdEi9jjGWjbh1pBHFfaRNCMyIAXpJxIG9g8FDKiCnIdouEPp61enB6xVDXZTnRIzztts+bzaGKDZEXXcqtF3lGKsirZQrDIS3qBJdFzQRe6Yf99kaVR7BAKWTZgU2rKpUi36Fpelt6YIxAjzcuEr4KnJjmo5c2xo3B8O03l4w+E8WzhkuDoz8I0wV5KtSanSolN/nbov1sh5RbdU0GtG3VmyztbWn+qM6DkdJ+jejhw2G6JYGQkNxK9t8rZUS+Bzl+RWpTsapTr7u22Q0/7IcoGaa6gVpMIFCHL07rm7okTiGmPH9M0fc2Be7az7eUUjy4KRNUDJZ5ZKBXxjV3FrG42uDjvwvNmxlI72aMdE+Osw4YdZPBRD3A88DyujI0rzOn1/vzUQMbgUqnN5lNgdvcTS+xQlm27CzNLf+qlDMZLfBjBqKUpTQLrbfBYt+p+sP2mX2ORDY1FB8IhfVgUT3p16cIvbqqV8/NXD9zeQTmhZRQNxjtuqLy9lxs8VIYm8GdKmuk2pGPwp4zS8pGlLfenBX9qvdcrGGSxTlz11MxlqInwlvZGmhwEmOtbXmPk//NjhhWVcyFcmSoI++ce7an8i3KwiE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(11063799006)(3023799007)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1/lmkXUxUYvNSScQ5amiTIYPIzCywKcilRVwgFmYO2VNdkQK7HJyMbFKS1By?=
 =?us-ascii?Q?wj5hQDS6i5MIWRUquJOfDR1KrFvyQXm/+msLYtP5kZoRY//J9uFd1GFxSv6I?=
 =?us-ascii?Q?fM94nvpe7oPF8moIjtI1T76LfzeKrt51XM9xmZ0FXXBt2IqhD6RnsTb8Fb1D?=
 =?us-ascii?Q?MXjtNdNJNzzhsg3uZ+OQkIywhIO6VAEV66BjB94DTVQ/hOmQKW0KCnzE0Nwl?=
 =?us-ascii?Q?WfB7HPKvlUrGSK/ngI6asST6Sdv7s5QHmmg7S6218Q1Y9GSzKvqk/KbHc4SO?=
 =?us-ascii?Q?X8V8nPusRICGVyEDCqZAg87l00RzNjD9zfAL/pQiam+QAZ+QquXW4CkqFnG9?=
 =?us-ascii?Q?aEKdvUfA6jeyjKlyG3rHs+3pUwc8ZhnZtJTyIsUFUoadEdgqK5ZyRxcc8xXx?=
 =?us-ascii?Q?LJ2zLBlPCSvqt/soyW3QPa9QrrwpORwNNdRfc9EJ43qcDBE364WpToP2/JAp?=
 =?us-ascii?Q?Pr90OBjsyZ09WXp09AWqxKVZ0d6aWT2EBfwh2rBYnDUbqaXsRiSjNgmELHhp?=
 =?us-ascii?Q?GRBFqwjJpUYr8nqdKD6WKDT8AJ/6FrIu6PYi5JTpoQNUsgchLT02rIchaS+g?=
 =?us-ascii?Q?/equ9vjesRgjLa9/PENLRdlf50TtfywAf6JMzNe6oaW3/d4gOYsxgF3r0Z2A?=
 =?us-ascii?Q?mSS26ZRvuughZX3RddDCHqQCC9qGS5HezLD/H/x2zO4HKeAFjwXx5PYe4ese?=
 =?us-ascii?Q?3fwFAm43i+xhwgdLL9q2UkTJikDkhhTN7myrG+Vmf9m3UbZW8QPohHakMMpW?=
 =?us-ascii?Q?cKuW9oFX0hhAC2v5XRTkjcoMhQV87Lio6ZGtRYy5pRWQ1fJXsdkmQ3PjQUIY?=
 =?us-ascii?Q?8w+pbh1akoeouydAjoUMvIbuEFCFmqkCOlm1guIwr2HHPHpHQMO8u/4Eajy+?=
 =?us-ascii?Q?eSU12cArrv1RZEjQW/iYQhsMvbvgDl+Z/0QLg8syJNCYJ9kefFAaRcZ4/vqI?=
 =?us-ascii?Q?EvG/k4/nCcsGwxYOuY07PpvqrW4GLz2KdQTym63RsVIFyYkwxVfje5+644oz?=
 =?us-ascii?Q?fkBfQNy02tOwpdaFp54X82es670OIQTXCIkMjCw6kwWYiiI+QfDZPryZONZo?=
 =?us-ascii?Q?5vNK+rFrCYuJRjT6g65ce13ZE5xKJfyS0U6iFUExk7FCegowPamt8LCs0H5y?=
 =?us-ascii?Q?CqZftuLXDxcMz6k3zssTREzipCPlL3JZ9PPIS2KknxcLSoRWytYKEJAVw7LO?=
 =?us-ascii?Q?uQs2EUucxf6JxwjBvK6plC/PUMtNy75rPKYF4YvAc1zjfoH3T2X4bzW7d/1P?=
 =?us-ascii?Q?B3ggH8P4Gs55W6ij5fbVf1kTjiQGNP+KCPH7N/Tfrxl1KW8zHyN+EQDsSFiR?=
 =?us-ascii?Q?8YPUDsg/Sj/EU0ecnq1G4pL5rggl+3ZWXHIy5ASzC9PNTcWjQpDsUL4d8SPo?=
 =?us-ascii?Q?YRASxwfiXAVKYUO0/1rZlYk4Wm4jEssI2OVr53lfDqOHGon2rrJyX2FxnPCy?=
 =?us-ascii?Q?IVDRkqBh6R56rtmDmMchFyUQdOyEzHyuQAk9DCLC+OEzUnrNQod2EiRqTEwZ?=
 =?us-ascii?Q?L+2WoHXwwc2UNIUeqFe8dVHnWH/c5G152tXTZfwheoJBXBH5LFr8bHwdW2cE?=
 =?us-ascii?Q?1sM/VrNGTzDy7bj7+T3kgXYNOFAJBHLyaE2ODKizrIuQDn8X8QRsfOJKAYLn?=
 =?us-ascii?Q?okaCQQshOq+ckKlk7cT6hwGVIC0FaY0VAztd6/IV4ajlPaSWC41jsMC1H4Qk?=
 =?us-ascii?Q?hNoBgOEVRJ6O0i1OgKLLhN6wm/geGdYgiptNay7cffMM/khF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365169f1-e23a-4c9c-07e9-08dedb7bb8b7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:16.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmKnGfFc9sPfMIA9BYkCA1MCdbe9VpDLTFbTiHW6cLrfBGrOnQXWcUG0NooVfHM1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7926

SMMUv3 was the only user, remove it and
iommu_iotlb_gather_add_range_pgsize() which is also unused now.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h | 62 +++++++++----------------------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d20aa6f6863ab3..adc45038e7ec79 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -361,29 +361,21 @@ struct iommu_iotlb_gather {
 	 */
 	unsigned long		end;
 
-	union {
+	struct {
 		/**
-		 * @pgsize: The interval at which to perform the flush, only
-		 *          used by arm-smmu-v3
+		 * @pt.leaf_levels_bitmap: Bitmap of generic_pt levels where
+		 * leaf entries were unmapped. Bit 0 means the leaf only level.
+		 * If 0 no leafs were unmapped.
 		 */
-		size_t pgsize;
-		struct {
-			/**
-			 * @pt.leaf_levels_bitmap: Bitmap of generic_pt
-			 * levels where leaf entries were unmapped. Bit 0
-			 * means the leaf only level. If 0 no leafs
-			 * were unmapped.
-			 */
-			u8 leaf_levels_bitmap;
-			/**
-			 * @pt.table_levels_bitmap: Bitmap of generic_pt levels
-			 * of table entries that were removed. Bit 0 is never
-			 * set, bit 1 means a table of all leafs was removed.
-			 * When freelist is empty this must be 0.
-			 */
-			u8 table_levels_bitmap;
-		} pt;
-	};
+		u8 leaf_levels_bitmap;
+		/**
+		 * @pt.table_levels_bitmap: Bitmap of generic_pt levels of table
+		 * entries that were removed. Bit 0 is never set, bit 1 means a
+		 * table of all leafs was removed. When freelist is empty this
+		 * must be 0.
+		 */
+		u8 table_levels_bitmap;
+	} pt;
 
 	/**
 	 * @freelist: Removed pages to free after sync, only used by
@@ -1062,34 +1054,6 @@ static inline void iommu_iotlb_gather_add_range(struct iommu_iotlb_gather *gathe
 		gather->end = end;
 }
 
-/**
- * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
- * @domain: IOMMU domain to be invalidated
- * @gather: TLB gather data
- * @iova: start of page to invalidate
- * @size: size of page to invalidate
- *
- * Helper for IOMMU drivers to build invalidation commands based on individual
- * pages, or with page size/table level hints which cannot be gathered if they
- * differ.
- */
-static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
-					       struct iommu_iotlb_gather *gather,
-					       unsigned long iova, size_t size)
-{
-	/*
-	 * If the new page is disjoint from the current range or is mapped at
-	 * a different granularity, then sync the TLB so that the gather
-	 * structure can be rewritten.
-	 */
-	if ((gather->pgsize && gather->pgsize != size) ||
-	    iommu_iotlb_gather_is_disjoint(gather, iova, size))
-		iommu_iotlb_sync(domain, gather);
-
-	gather->pgsize = size;
-	iommu_iotlb_gather_add_range(gather, iova, size);
-}
-
 static inline bool iommu_iotlb_gather_queued(struct iommu_iotlb_gather *gather)
 {
 	return gather && gather->queued;
-- 
2.43.0

