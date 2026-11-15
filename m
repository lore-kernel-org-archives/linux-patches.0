Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785454;
	b=eeba4eIprRNSHweQNw03aAR1hb5kbunBDvO6VHuGY+lJ3UAFnNer5HR63NJEbcnDPdk/
	 +Te5RsBI80iHtepy+tuNrBQBlMrvMTCAgNkMY5WXSEVJKb68iwOgQtiuEh6pyzmOuTcXW
	 IVVGrkIe0U7cYDCMy4KL1ESvuIcJprGNlWuTyQ1OsPyhIUW0b0ClCo2w+WXW9cHfaRO4N
	 gvtDOR3wIFqV1yQA7ufxIji1CTeLXIFe4oasKloCxc98vkaHW/jx4lXPL7/HsChQRqlMq
	 wPOE+PxMrk6FZB8JAxTzb1vVF1UoEL3mkie/6uPsrg5Cv6I4od1tTHtSnvGfbLSC68g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785454;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=yBceUHc0juSB4msgnOEx+rMbLLKcD6wtYjNEq68B84w=;
	b=IdVLBzLDxQrBX2Rj05KnIbXJGeUInAezgSk1hVTEjDbf19ULPHawS/1SuBtS1N2UgkXM
	 glAB5Q10WxBpEgSD8hb5JGXfwuPVFlzld1Z7DaXP0jHpbXMm27ES/zESZwsfWYt4DSu3e
	 rs9j6BwGWnCoN6KZakWuAuJA32vD0OH8CGt860nREXsBZoJ5HiGC3YmyeI3c9Oxhb1Lrh
	 UaXlCnarBsdfZrTUFY756DdkiSAWq1JsoYKeLsoAU9e2bUhrym8/lrBXrywHF1zLbHkdt
	 IxqNgQSZd0YlPvhOAnc3hJ6+XbIbPfjZTLxU9rCE+ib4bpK7usZLo9XJ9XuMlvbzxFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e+Ihbon5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.29
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C45606A33A;
	Sun, 15 Nov 2026 23:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72C45606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e+Ihbon5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4gQyQdm/z3npwHqi+kNhBAt9jrwY4Z9Kz+q0cFVyJhs3MWFxvxvK4+owO6Negy/S6BdIEiArYAZAl7s9vWHYqPiKaG6AbgP5tAzG1Qx5+c7aQeQ51D2rs0QKQ5kUAUd5edZs5VgdcxWI9tOT/f7nQiAe7zy1emZTlrCWNgN7IlkjpX54Ugy4UyTTnmEdBCr/8uAckQ6AWLGxfzxX4MBYYToXhwmtkrgymuT1seFtanMmc58LUN7n9Ok2RygWjn40ELbuOZQs/bm1POXFQDXThGrhteeYAI9KyrTTs1Kx5ffSk88SGwXQmIqqexhScVicDoxAd/frpOLuCqwv1AfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBceUHc0juSB4msgnOEx+rMbLLKcD6wtYjNEq68B84w=;
 b=RNCJNA83vtxT8WMBMMujo8oqkaWyiYFodqNpuXCsa8wkXyzr6wev3lOX0/Avh6yoxsfg/LuHzC3QHHc2vTczHG4tYHVu0Hsz7wpyie2djTnjrZ+ghv5wWsnRjQhzqkXokjiSDcUrjbgr06D7gnfl0Iv5IhPQRRpvFp8JQpbcdQ1JNc5tHNCdh85XgHuHqbmjiEWJK2GkgvuNqb3IkNHwTniEmvMrsj8vFci1mLojUxezrvXJULEYmUvdmbSSij2TW8R/dR+xqZhC/8+TXLZF+Pyh8A5PuMptZ2vQ3bbLHa4rzup6PXouuoOgIUYSJUxWamSrW/kzY0Q0e2RL9gDCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBceUHc0juSB4msgnOEx+rMbLLKcD6wtYjNEq68B84w=;
 b=e+Ihbon5E2EkgImcajZL37hITRCt08a/EUJd4flue6EhZGV52bB/hpO0/7bJwyur/xmPmeF2wtbkw6BlpfRVGJW4dHTt+CGMvtpC054A6hsbxxbN/zEyWDSNsKu327d4iWq03xczbyhP7ymcKOjGvKJ6GLgiOvpPam/V6qYjNCrRKgZ78fJ6x6cv9wqx7emZyX3cGfkl/t5dmNGLlhXqemzAGsGZj4HrL2SD+BqwYwgKKKstQR2jOvSYB0s+qnkQeZAIfDD7J+50UdRlbAUqaMwHoTV8fWXqeqeeOus7L4KELvudBa5BOMzCZjOPImfoSskbKE7IsDeLUilmFNlRIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH4PR12MB540976.namprd12.prod.outlook.com
 (2603:10b6:610:51e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:49 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 13/13] iommu: Remove pgsize from iommu_iotlb_gather
Date: Sun, 15 Nov 2026 19:30:43 -0400
Message-ID: <13-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH4PR12MB540976:EE_
X-MS-Office365-Filtering-Correlation-Id: f847bbd2-c46f-4e97-34ba-08df4370791c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|56012099006|11063799006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	4Ss9kEqkxIMRqO6pxPVIXU7qHSseS5+kRzxztDLLYuVO79EsIqEUvSuHVhwpeuQ7clT8bnjYSr5WLeBbLNl/bTZhwfnhQkgOdu5FNbgirCT/6DCdq4NkCNboo+Ac0maWQloEQT2qN0ISimv81H82wnPAb1pFCXHD2PaMFw+mGpYNYoRuxn+afaPGDpg2s841Evxb7mJuazWumk1GQTwWCUNMiycFMihSA5kg0MS3amOIkl3JHPpXVh+ymfLhKh39vH4ChZiCHcq1nfUKaa9ZMMbnHq7udZXcN1kPte/XGXYnS56zVC+gZFvtV2+7Fq26vHB6zugo4UfVyDxd6u4nmlPsXWuJn7VjmMJ5APP69f0t90WKNyBsd99x32430yXDjehWgsFdDwxSMSb9XDOvhxVip+Ngvyu/O7oZs2djJ2qbZ7ORbHQsnkiovufd2wgwPHkSST9WhCExwPvZ/JKpb/CAtyu8l+Q+PzdaSb+ukz8fW8CmI4OCHQ9qbYrDPT57Bf3AC7dXUIk26qp/RTf9GNPEjBxnbuwRydXC+YGq7QQDyDYN+sxQrJT/tFSBNvCbroUUd9c8BDG39VnAWPWNWsk3wZUAMZdN9Jsa5rLRw5W3aTajM7fJGNxq2Y9vGZqJrNvX9Iy4X8iMisnEMYT2+/GQ8k59evPnxdUFEnHD8gE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(56012099006)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+/WblEDE8f9BflmpR29TF2yY/M6exEnEubNoe0+QkEw76EY9xOICpuMwZRgM?=
 =?us-ascii?Q?WFmRrCvAxI7KaNpX13W6Ld53Bu4HCBxY8ARWEHnkhVCSKUJrEfX5GALzohFs?=
 =?us-ascii?Q?pxgzOaizFFTAuvxrBNzR8DJJzSXcWFv4TgXjUc+EC9aFP5vA3ok7F8Cam8EU?=
 =?us-ascii?Q?ZBwH26VXLO58Kjg/r/YNGT6Hk8E3MSvA8g0TmsQyHkZIx7IDk5AvJZw8Mn87?=
 =?us-ascii?Q?3eUmpKPqqLvdCaW0t8UBS4VGhZ142Sgn6MOubixe7Zc0LFzje942sE4D1tkS?=
 =?us-ascii?Q?ARWF3BDZ/0DZNDLb2T40N83pBh+UgenYgAB1nSUi9uTUBXRc2jv3l1AwXgse?=
 =?us-ascii?Q?vtVZFLy2H8hdJbVRrbjOygH3aUUidU9DIm+gMxBbw7EQD1Y1KzUoRHqDMIES?=
 =?us-ascii?Q?Nr1cMhbis/eNFk1VZOPUt85O+gG9cDgVcvNxQeLmpWW0eCfsy0mPbj7T07hH?=
 =?us-ascii?Q?V9bUqndhBG6/n39NJ2FHKAHhJaklEAyg13IW88mpaqGC+GgJuB51OxR1NvcZ?=
 =?us-ascii?Q?xiANwJkyLD/0tD8jOPgEe/wC1C1c1VAxYY3kBugm/Suiv9o2MnqpxZgKDbf+?=
 =?us-ascii?Q?g+GL7aShhlHlEI0wQvaUgWQ3oGH0M8GoyUHqXhUFfggUnwZYmad/S/jw5g4S?=
 =?us-ascii?Q?nK5sR2+mAetsxA8WFbieCelkFRDJM0Z9gs1jch8vtYPYY5Uvu7fL2VKZ3DN+?=
 =?us-ascii?Q?nJdkyUlq3fXknlrgEXOpUt/Lz4TaYHQwGZdxG5UGMiGKJAx90FBFXzaqIKOb?=
 =?us-ascii?Q?vX80EoxKAbooswKcWPwM3bOb9hEzJ1vvPUSEIqxZLTX7eOYTqfecgkbuIfqD?=
 =?us-ascii?Q?d3UrgEKvNjEvAOQJvi7wf5sQ7E0VdlhZ06d+nnciLJpo4IUt00F8gliCfYNu?=
 =?us-ascii?Q?sdroHXVVjroqVBVv8/dUTdBR7K3ZO86p2I00pL+JIyEwLdC+r1nXZVjHQhk6?=
 =?us-ascii?Q?NF2FprAU+E29ap5p+HSh4sVuXOVQV90wFIMuLc2zwbQ9JUeGJ0026aOahbcB?=
 =?us-ascii?Q?+NOSw9Y4M+5f3OOQZ4zwQuwkAX031JvoKMu9P1/ekWGvon+uAcvGCaKIL5PW?=
 =?us-ascii?Q?azAfb8/PEzRdSszbqb9YHo/WIhW6tDjNbK3LN/lYT7KFsEM6T45yHCA0zEcn?=
 =?us-ascii?Q?B4LoGA/xZdES4AnCeAuNLSodk7uWiRG5W6gABJ5YROJb3R1VA2XI0OsAYv5/?=
 =?us-ascii?Q?2WkrIzw9dT15kubFDLCotKcnmzUhlvVAv5QAuYL2c+U/DEj4g5MHUmABa9iD?=
 =?us-ascii?Q?F5nGxEioqGuJC+JjVu3pe26G4xz7RyOo24h4AsTrvJn/8ewgXrwnQnBpia/V?=
 =?us-ascii?Q?7O3w6zpgyN029dIRnwz+N6vQoARsuxfsJMrN4iWpjtQcAfZbpTnXFSqN9bRv?=
 =?us-ascii?Q?tf1v0KT0qBdrVdAzhAP1ERQtsDqkGjxxHFno0zqcaH49zUIU7xVnZHb1TL+j?=
 =?us-ascii?Q?TEw4EwAorJsCqeaQ4/X56Cn43AAsj5vUjX+G4/7PgPYvaCfvzlO6PbGmhDbL?=
 =?us-ascii?Q?puaHzD88RL8Bu8EznwwhWrNOJh5go5i+R+ngvxHcutW3HvqmJkEc0boEniEV?=
 =?us-ascii?Q?2vrPic7TVqO0nw4MnZ6b5qRE3elsqDkGNYC6AGegFsjOryiG46vpNWVj9fl8?=
 =?us-ascii?Q?WePG7lndN+pBeWCe7UD3PSQ0KBwvkN1s9i9fESPR5fbrbudks3uVSJLQsJ+V?=
 =?us-ascii?Q?bF5BtY7uShKQpXGr0FR15u7Yw6kWoJckgzz0syabaFA2xOHj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f847bbd2-c46f-4e97-34ba-08df4370791c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:45.7993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yMNNPPf0zuX0to59A17vH/e2i+Nlvpf6eGlJYRAGi3o+scEzKbRW5LQIefLS3a4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR12MB540976

SMMUv3 was the only user, remove it and
iommu_iotlb_gather_add_range_pgsize() which is also unused now.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h | 62 +++++++++----------------------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ef5043752a3651..339ea708f352fb 100644
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

