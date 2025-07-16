Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4272BCF53;
	Wed, 16 Jul 2025 19:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695881; cv=fail; b=WyQ0yA1SeSMlaiZg2wTwfW5tD1B7fkydtmpPRm0ZyyZuhsLO3dVKONe9C7NwNpiQ1FriDvOGgtXw5qujyhVEvL0q/yPQyY7W5NTcZCea7emJyPFIrAtd+hvLmIU41rLY6DDdLQTgu3yE8AJb4Q8pZ3FWCxU+hj5BOJaRklNGp4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695881; c=relaxed/simple;
	bh=fWrfSI/kcQfU+RInQ7KM3bg6gnbq3HED7yXolFG59nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rUEfjl3NN9+1S2CuTGxlybANTGKPq2f7dnnIQeqOoGlY7cjNmLabCuWG0g8WjnNyiGcT8/Wh1sa6KifJ8avbSS87R/XdsyDsFsgjX0/42ajkYu8JZNMMOxXtssjRk0FujGqKWs8NTjbjnviNetYpaWBGZy8XMf6HrW23T5aWBOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iGveswzy; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iGveswzy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hoQgZVfl7B5FeWcBxipTDW/hM97b0C1y88Focz37IOkb334TwaxPcPxxb3eoId5K566bQW7qu1bARp6eZXn7AM/cWrlYcIlkVd2fkIUSW4b1ihK2R5S4YhNdeRleWmKYDFagdsKnerc7kUs0bGXQ3vkhsajVKZZAD8NU6sSwYDIllByrbGTNtKfjvZYZhIPaLzwifU0pO0WoPkm330T3SqnGxFg25WpVkKO5agNKzF9R+z8gHx1Gxkd8hokPNdmi1YuwYEKmVoWg/yCicgHHx/EudshoXQHFpO5bfwKpau6BRad6XQkMz/Iy/m+8iAHs+KyrUlaIrRPhUCSrkr5xjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB7fpMl/O+XudakatIPSqTV06UpZEzP7+BBwganFfg4=;
 b=Oh/oXUGLtrqijRIzeA2fgjH0WtgF/j31o6oYsFRrdaf3Kuje9dzmDE/wGrcMBPGRI0tJcjajCjHWIwq9OILyJacV91FFudqxXYMJzs+E1SXkhpSSxyHe89GB8UhskFAnBFju16CC6G28Cvm3ZgJ6PpkzHnOIv3MgoJmFFB+q4VrJqtmAh5/rQgNAOCdtCyvagrD+DuwN7bHu1+SnGisJvpS7g6OjfxcKeXvwxqm68HVzGllLfBCqrm3M9QQK5bjfakl+va3yFUoD0o9bL8c34+XC2/52nKURteifrB3xxQ7KKE1gIvhv2Z7j4jm7vIdGjLvKT48rAQG7oRjn+WG6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB7fpMl/O+XudakatIPSqTV06UpZEzP7+BBwganFfg4=;
 b=iGveswzyHSxw4xRw9GSxSWs/NLH1dn27brhpkMNg3oTTjq62me0mkPJwhBKDjeOi2FSqGBZV+LfZPQsV+n5xUusJx024Uh6jWpYGRytZs4Gnc/9/T9Y2m7jgziA4K47jnOfrK0Q8nLwGH6SLinGx/Esw67lpay61DSJB1sKJK97ez6GiD9PgrwCHPJb9JIoRxi0TFPjISWawECiVci0UjwoikUcOYhyhoaAxM8nFWBn/EcTHgG2TStsORTMRkY1gRn1KVLoSfc0Jil6e7F5eI9Hc+LpRvWVAYZTeCjNei2TE66TacG4VAyYSpI3ot7KBIOMLfgljwaXt6cEfj1Zd0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:51 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 9/9] iommupt: Add a kunit test for the SW bits
Date: Wed, 16 Jul 2025 16:57:45 -0300
Message-ID: <9-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0006.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: ba712ef0-84f6-4613-2e8c-08ddc4a30a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BP7lm9ORzxp2HF8NkoPYsRTFN/oHytpGQT3GW1QN6YuNxLdsESw/ZuVRtx+M?=
 =?us-ascii?Q?eWTi/rdNBvxZ53z65Sx3DosfDoVtWqOVTs+n07XflWdN1AofkjdIYkOiGP8R?=
 =?us-ascii?Q?UvKRcfMfptVmJuJOKGs8BzrPAUXNbeFcQMGPmzIPW5qo4fEUmfO026tRR0eH?=
 =?us-ascii?Q?NbaxV4A2aVN4+fUUDmKRuQkOqedACz39+9wKcY6bF2Pjkz26OGJV2h6m+61n?=
 =?us-ascii?Q?oty9fDXFXKlGa/Z+mDdvrmZGfCcdJNh3+iKe3pmJJR+upJMLsYoplYTlCPdX?=
 =?us-ascii?Q?aBgLOwXZr9uPyH4fC6Rc2Xnbkm2l3m8yQ32iXrX5dX7tW40un1+Ds4Frp5rE?=
 =?us-ascii?Q?e7tD/dj1QOJpvm8XDXcwrOt/1Go3Up/oKJJL8L9yGTnp4pF1vfFrXHs+fZ+C?=
 =?us-ascii?Q?FtG8VN30sRQPKE2tFe3oUpj91oKaIThXj4H1VSuVEEFoPBVTzJK7IiY+KEPm?=
 =?us-ascii?Q?BMpuikt+nOViKepVfPqbOpZldRSa4SrFF48Q/Wbeej4Gvf6qzqx0SLltNQKr?=
 =?us-ascii?Q?iP2mIN5TXYGendkbzZYpjiTGFBAyCwiepHtE5E9bSCoD7pt9bxSTMtavtUlu?=
 =?us-ascii?Q?uCnsFEZ0hwafRoAsqS1HCWxYpXmqqhDYQElRf+fHr70+csqfvtbArnaSmCBQ?=
 =?us-ascii?Q?ZC/DzvQh+IhaquUjIhVaq8A7PVcE1d0mzK7qQObJS5SXxsl+jCi3amfZuiVP?=
 =?us-ascii?Q?3reXRNxZUMc0l+MPK1yBdfyO9HuM+XX6zEK0C1XiFTgdSKpFS8orNzfgIFUs?=
 =?us-ascii?Q?3gx0fRd7y9o4RyOfO0xgrAmKXvLH4AsBer0PanADHZW0T9J6tpss5rprmaEl?=
 =?us-ascii?Q?jO6HL2eLveYy2utR4soBFS+tPLBQTjq3sY8D8L1HY5rLeytU3duyl8lx4RhN?=
 =?us-ascii?Q?Ag45MHugQBM361R+CakIJ1oIRUovd9JsQO+zqetXXlUeLHpI1Ts1ruKGkgLP?=
 =?us-ascii?Q?peBzh9PPPyyO7OwXOQ9gwEiAPwHPRciBXXEkk0moN21LIrxKqga58fc0YprX?=
 =?us-ascii?Q?4dwE2jTr8P8/B1FOu+UXP9+tcCwlbVKZlT3s7qDE4SqfeFScbC5PMpa/Klvm?=
 =?us-ascii?Q?IHqYTMqf9Yh5qzKqHAo5vIoR8FS6Obg6M4UvV5Jokioj8upVvcOlQvx8u+Hd?=
 =?us-ascii?Q?QiOvxBl6g97TKddnQLYtOTE9HjOnFmnthDrUE3cyym3En4pTZIcdlbfBZpoO?=
 =?us-ascii?Q?OxmO3kxrxWHK04emHSCp+WKdyEbqwLoLBIWpKrd3CHUQN4YfE88goLQzfIy3?=
 =?us-ascii?Q?untMMw2o+EmsfItLmyg2QXVBW/In4FZHLzdtmpS6a2dFbJPQNCm77x5YErYr?=
 =?us-ascii?Q?n93AaMjqFMB7xiW3Hgi8z4Vedd/2CXpCEoFaxSMqMVLOE+a7j5r8Pp+SMjup?=
 =?us-ascii?Q?tnSFoKTWbTwq7JYZEWiVU/nWpFLUR8tfgbMoaoXHvD1aHNimtGpz1N1qL3fB?=
 =?us-ascii?Q?CgylB8KMf8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C8lMk7S2i842HBE/4TqIQC65blKQWbY8d5mae2wQpH2WY90+sCJkL9+EOBfK?=
 =?us-ascii?Q?X+mjQXbgINNeoXl+JhCeo4JzpQS0Cv1mPBT7FPj+Ii/+kY4HNhWBwXP8MWg7?=
 =?us-ascii?Q?/8OtHS2phd9xij6s2XolUo7YgXP3eRCtCNJq4P2lK1O7dtT46yTTuoWz9M1F?=
 =?us-ascii?Q?+k6E8/9LIVbJkWGbCt/4/Ob7TJlM2EbkcLCRkb/0jPjXsjsK9giwZkUUGLwJ?=
 =?us-ascii?Q?Gsc2/qs9ViYZrlKY87RRKqxjmQbxjRj2mFxpPaIBtOXwfG6Z0WC9ufT+KRIh?=
 =?us-ascii?Q?DyJVIAQPOChrdfuw7yQKdMs7pAth+tbX4GZVpD4JLFMCyWmt1bKHIds6bXfh?=
 =?us-ascii?Q?KWfLPTPmc0j+EGUxiIWYS2a0U4ONNJtEKgwNLN9VJzPIkj8khuaGGAqe7IPT?=
 =?us-ascii?Q?sMw5alcRh/hp7L322AcOO7YAlf19BhxbzPxO+lkBeEOwSC8U9uUqJX1Njz5U?=
 =?us-ascii?Q?LsCU6FFbDWBlhMbr2EMswyXo7p62H4VspkfFdoNd+zynIfiCzqZg+KHWnhx0?=
 =?us-ascii?Q?j0pK5EncjYgOke+UUv3ezldjKkGYAnj/cj9MHCH2AgYSq7FtHLV6ti/mmcot?=
 =?us-ascii?Q?Fx8ghKMUpqZGLp0jvErlLzR7T9360OH2fSFQu8yyGSZrqqPTjY0EDvQm+RWa?=
 =?us-ascii?Q?+gVWTJyveJP+pQ3mRLvvLvM3cRYFz8Qmq39mBHSjrPV/eDW3R9B9d+U4Kn3J?=
 =?us-ascii?Q?pYJ7F8mZRSw+2+cm+PinyYKbTEaFudFT4YQyHwxPSKLEXQ3NiLAR8EaG4A47?=
 =?us-ascii?Q?DZVCA6/i/JMfxzOEJjKU7PQwkiODrzuQV+bezOWXS4v6kc1bzy1qcF2Q0/KR?=
 =?us-ascii?Q?7P2OwC4uFRa1wP/g+hLO0jLjt5/h37mvm1bIpZeKvoyBAILlVG9Gi/4YoPGh?=
 =?us-ascii?Q?Nq2Imsw/jnB9MKAiWfxHgAipcgYbh6xIURZa5ceF2QsqfVYjVI/oWjWD6wYB?=
 =?us-ascii?Q?9MflzThd86BD+bTneTF7NTqwLlM8PABQ7+ATQYZ2wxlpNn/vsKo7sRaApWa3?=
 =?us-ascii?Q?xdMHmN1ObIptCeEX5WJMfA8Wy07dokSHC5kUQBi9K9c8TiWhcLUr8Sz/n1It?=
 =?us-ascii?Q?U419hbQTYWAcymr54x1ejTYY9aiGogQdH999wreL6eEcTnPfaR5Ff/vSTg9z?=
 =?us-ascii?Q?1xAqgf0fw+TpnaKTK2BY1faqkJUhN8xhA+VL01iR1WO1s4wjuekn5p6AeEkd?=
 =?us-ascii?Q?ekJwc+XR3s/eW9zndSkyKIJBRFnqFQZMZ98Q5GizHB6H7nTS+T+CC2bUtPje?=
 =?us-ascii?Q?o1ga9Cb1PjACa1jjJJy4ZWrpBnlurmPNydBN/1oY9WVXaUkOO2LxQZq/7Uc2?=
 =?us-ascii?Q?QBnbqdOG3Ma4/006FhCMvT/ZxhvUdrP0/0+FP6C0PRyTlRVRgHpRfbNLyOGK?=
 =?us-ascii?Q?n8ZL0FfQ9+MIlQiOPa2qIvzH+eRqC1uYHGed+LQbmK5+ZtIxG+0P1xZ8wNpK?=
 =?us-ascii?Q?XpD4+HGyJpbe+T1gOPxnCjxtSsmwg93Hr3XXJjAe8R5RsRQk5KT52aSXg2Rd?=
 =?us-ascii?Q?6FenY2dghW/gGCwZYud/eDAh1hpZjFd/dKVcIQez9YLj/g9HyxKStyDoPzFM?=
 =?us-ascii?Q?cbZ7xf4nDR2JLRw+grZ3Uz8ce9uX7R6tpx4OMOFs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba712ef0-84f6-4613-2e8c-08ddc4a30a2d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:48.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMiTz7gGMNOXWw7DxgHIwKwZv05dnE6Xgl5ud6W1FZE/5a8M/ZCFje9CtwyxWswc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

Add some basic checks that the sw_bit APIs work as expected.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_generic_pt.h | 110 ++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
index 3f3eab35e5cb1b..f35b6b3e42274b 100644
--- a/drivers/iommu/generic_pt/kunit_generic_pt.h
+++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
@@ -664,6 +664,112 @@ static __maybe_unused void test_dirty(struct kunit *test)
 	check_all_levels(test, test_lvl_dirty, NULL);
 }
 
+static void test_lvl_sw_bit_leaf(struct kunit *test, struct pt_state *pts,
+				 void *arg)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	pt_vaddr_t pgsize_bitmap = pt_possible_sizes(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	struct pt_write_attrs attrs = {};
+	unsigned int len_lg2;
+
+	if (!pt_can_have_leaf(pts))
+		return;
+	if (pts->index != 0)
+		return;
+
+	KUNIT_ASSERT_NO_ERRNO_FN(test, "pt_iommu_set_prot",
+				 pt_iommu_set_prot(pts->range->common, &attrs,
+						   IOMMU_READ));
+
+	for (len_lg2 = 0; len_lg2 < PT_VADDR_MAX_LG2 - 1; len_lg2++) {
+		pt_oaddr_t paddr = log2_set_mod(priv->test_oa, 0, len_lg2);
+		struct pt_write_attrs new_attrs = {};
+		unsigned int bitnr;
+
+		if (!(pgsize_bitmap & log2_to_int(len_lg2)))
+			continue;
+
+		pt_install_leaf_entry(pts, paddr, len_lg2, &attrs);
+
+		for (bitnr = 0; bitnr != pt_max_sw_bit(pts->range->common);
+		     bitnr++)
+			KUNIT_ASSERT_FALSE(test,
+					   pt_test_sw_bit_acquire(pts, bitnr));
+
+		for (bitnr = 0; bitnr != pt_max_sw_bit(pts->range->common);
+		     bitnr++) {
+			KUNIT_ASSERT_FALSE(test,
+					   pt_test_sw_bit_acquire(pts, bitnr));
+			pt_set_sw_bit_release(pts, bitnr);
+			KUNIT_ASSERT_TRUE(test,
+					  pt_test_sw_bit_acquire(pts, bitnr));
+		}
+
+		for (bitnr = 0; bitnr != pt_max_sw_bit(pts->range->common);
+		     bitnr++)
+			KUNIT_ASSERT_TRUE(test,
+					  pt_test_sw_bit_acquire(pts, bitnr));
+
+		KUNIT_ASSERT_EQ(test, pt_item_oa(pts), paddr);
+
+		/* SW bits didn't leak into the attrs */
+		pt_attr_from_entry(pts, &new_attrs);
+		KUNIT_ASSERT_MEMEQ(test, &new_attrs, &attrs, sizeof(attrs));
+
+		pt_clear_entry(pts, len_lg2 - isz_lg2);
+		KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_EMPTY);
+	}
+}
+
+static __maybe_unused void test_sw_bit_leaf(struct kunit *test)
+{
+	check_all_levels(test, test_lvl_sw_bit_leaf, NULL);
+}
+
+static void test_lvl_sw_bit_table(struct kunit *test, struct pt_state *pts,
+				  void *arg)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_write_attrs attrs = {};
+	pt_oaddr_t paddr =
+		log2_set_mod(priv->test_oa, 0, priv->smallest_pgsz_lg2);
+	unsigned int bitnr;
+
+	if (!pt_can_have_leaf(pts))
+		return;
+	if (pts->index != 0)
+		return;
+
+	KUNIT_ASSERT_NO_ERRNO_FN(test, "pt_iommu_set_prot",
+				 pt_iommu_set_prot(pts->range->common, &attrs,
+						   IOMMU_READ));
+
+	KUNIT_ASSERT_TRUE(test, pt_install_table(pts, paddr, &attrs));
+
+	for (bitnr = 0; bitnr != pt_max_sw_bit(pts->range->common); bitnr++)
+		KUNIT_ASSERT_FALSE(test, pt_test_sw_bit_acquire(pts, bitnr));
+
+	for (bitnr = 0; bitnr != pt_max_sw_bit(pts->range->common); bitnr++) {
+		KUNIT_ASSERT_FALSE(test, pt_test_sw_bit_acquire(pts, bitnr));
+		pt_set_sw_bit_release(pts, bitnr);
+		KUNIT_ASSERT_TRUE(test, pt_test_sw_bit_acquire(pts, bitnr));
+	}
+
+	for (bitnr = 0; bitnr != pt_max_sw_bit(pts->range->common); bitnr++)
+		KUNIT_ASSERT_TRUE(test, pt_test_sw_bit_acquire(pts, bitnr));
+
+	KUNIT_ASSERT_EQ(test, pt_table_pa(pts), paddr);
+
+	pt_clear_entry(pts, ilog2(1));
+	KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_EMPTY);
+}
+
+static __maybe_unused void test_sw_bit_table(struct kunit *test)
+{
+	check_all_levels(test, test_lvl_sw_bit_table, NULL);
+}
+
 static struct kunit_case generic_pt_test_cases[] = {
 	KUNIT_CASE_FMT(test_init),
 	KUNIT_CASE_FMT(test_bitops),
@@ -676,6 +782,10 @@ static struct kunit_case generic_pt_test_cases[] = {
 	KUNIT_CASE_FMT(test_attr_from_entry),
 #ifdef pt_entry_write_is_dirty
 	KUNIT_CASE_FMT(test_dirty),
+#endif
+#ifdef pt_sw_bit
+	KUNIT_CASE_FMT(test_sw_bit_leaf),
+	KUNIT_CASE_FMT(test_sw_bit_table),
 #endif
 	{},
 };
-- 
2.43.0

