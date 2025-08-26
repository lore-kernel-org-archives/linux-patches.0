Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1F22E4252;
	Tue, 26 Aug 2025 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229205; cv=fail; b=pfgDhTFQXtMpD6CbTjq4Lpka0lLe7sZ6CRDZ8nubY6FUt4HF7H6WIwY7un74O+zKYnjNxkIvfYd+Wd0eIpSUlJh3U48LGqCMUCf+SyjkuN/TqnreuYlQuLaZ0MeQbrLwAtliRWdnIcz49xWQfwmB6IhtVsw+e/v9PMSAP0jHe+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229205; c=relaxed/simple;
	bh=IOxwlgdRu/79FbrIQ20EncLjB6h1RWAYfippI9HsA2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LtTWI02Gp8DrovYxV/zvGYqZ7n7PwDpV/t+aD7JHd8a5jT3WX0PGuzwSBu8UrY68UXu6on7s2vbHOLKqMihEH9mrYq82kqTGQcnP+yEq61cP3J5/LsCqwSD0o/aQ7Z2w2JyElZUbyqYCW8sW1d0WHIWV9nvwQk7uYtrh5VgKL5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aCu6Cd9S; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aCu6Cd9S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QbfFZJWAO0g1qiTm0NhPYsCB8chfxQNWgNBW50hQWcSbR7h2ll47L9yTQ2YvrVMf/N5xu0fv10InAQm6NHaHZD+z/Qz9qDyPzF9typFaWMHHqaj/BLfDV9i5OKCCp28EBuMUE7C7oV9G1+niKWKwCl5SDvS9UjOW+dKruKNas+pkw05R+QF46ZK1FJq3hXjMnIq/1C94GdO3LYvQKvZQmIyYHW2EknwctMzFih4SgM9NQA/GKt7UnQLim5UNJwoqmDL9d9IdvHtlhqkGeJeHlxbDVkrILzYhtP8lKtLhbwQvGEJ5yxs+rAnA9agR+sgY2wtJS6p57yErFPI/s/tAuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNKrvMsg2gSA+q8crtqsj84PE4Es/2rpobE9b1443zU=;
 b=s5K+aOHkpXTWDp9rU8qfFm8uJi3eYx9/tq2GU4do8ikgA0LshgKcIobIjNGggSI1ZN18JikYkngLIyi01tmbBVMe/yzVsKTCW07iB7r9sMTxVvpfnLy3U1ytLgH9m/18fAkjOda4NRWQp5uUDt82c/8CnlEIGUWw2wG9r8ZvE1EjeYAO9f66FcEL3Soli5JXpVq+D2c0INdHPF3vlYsHlu1bGC60TMgn+a6KYDFJDLZ0lqIVEN6pTz0zq9ploqCkM81R6g790UAK9ktxtelFJUB6hjm3IbefX77wxU5Jysz+OsvQB3xaxKbLSHPDAMyU9W+S7ndAGi6Z+cdd/MX1Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNKrvMsg2gSA+q8crtqsj84PE4Es/2rpobE9b1443zU=;
 b=aCu6Cd9SSqPx7Xbk8zcaIT0hK51UqgJJOxhhxcRXklSCNYGMtQh7+SEkcOyXLOHyWc3Z5J6WLu/MF2Y6wODc9evq8OKcSHZrq8NCTTsXGgR5ybvhqikHUJVLyT8pC2Dx6KfI7aSC1YsfVBVsTV1G3yVshzRGTStJQ7lQmSfwDn4TXuuQabSHOzSLIB70Aqdn6hb9ROuZVLk5M2oXIbXea422FfQ/9kuxaMv/rFfwdSzmamQ8ryZAAAmMOjHwrUlEvKXocfINdwagB5jHhqrbHbK43yBe73YNmJww48x4LlDfyMg7P98kF2vCrRGfsxXLh4suhcOkMYcIlw2T8TBlZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:39 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:39 +0000
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
Subject: [PATCH v2 10/10] iommupt: Add a kunit test for the SW bits
Date: Tue, 26 Aug 2025 14:26:33 -0300
Message-ID: <10-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:a03:333::6) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: e496e0bf-8ec2-4a50-5a4d-08dde4c5b719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WxyupysBzZS4fwcW/76b1YpJN6aZe8NxszIOIlUQC9+lKgmHH7eR6GWYtpHr?=
 =?us-ascii?Q?757PdN8wpymXKq9HaxwzAworRTdIHBrDotI5ntPRuPin0U7XA+RDXsBybAof?=
 =?us-ascii?Q?C3IQ5gEaosriAZmZpDse/NbMa0h1vnAsDMQOqgOIPCadjrjHgU94sao+xEuH?=
 =?us-ascii?Q?erRAjFmIjs0BMJ5mERCmy0d1DU+LDgYblfiQp50qih5K+w/RMxUSsqf5q00L?=
 =?us-ascii?Q?kABgWr7m67yNNYbCAEgOhRzGoNFVrrOnwn4ZXR4sqfHw8F9rmh2aunTY9DHN?=
 =?us-ascii?Q?yRxAbHPWO8aab9jQ9RITex+uhMIOFIcDv6PfCU42AtIbMyQ0Nadeq3qxW1i+?=
 =?us-ascii?Q?X58Gu7EKLQD3ynvZw7Si2oggHB3COtxHXlU1nuN+EC5qoA/tj7pxizFT7C64?=
 =?us-ascii?Q?NNSQWSDm6hNd39xy0rZoUhWFXUr1QfEYoEGPxK4XP7GU1E2gEsHE13HYdka8?=
 =?us-ascii?Q?bD7RZO8tqbLCOB4FEaYbMSE9D+3Fc/P5WXKFYRFx66AMywYTFXirguK5cEw7?=
 =?us-ascii?Q?09rjXWJyMQ9GX+XXS8BKxqZAY7LbXXJh1e4QyoVIbtESPhfETZyIl36lJuTJ?=
 =?us-ascii?Q?P4jBdyUJdxx/pb9uPTnXev3VOd06WmfyBzCVwcALXfGo0B/hFumHw0uJtnMj?=
 =?us-ascii?Q?YC3LbpIejgKXzdu47YcpqhA8sPNuGszl5YwTjZ9CvViL9Snu1qUbzc0MqD8e?=
 =?us-ascii?Q?U5X+DqrS4NxsnGoKXyOmkCG5aQHJRWp/oRhUi+TY4vOec6TYVMP5ryUkdsTq?=
 =?us-ascii?Q?rGJ2i/RWwNXTCRGUNe3XZSA1fRTVn03pdxwNVB3xNmYiCzLUt7pioDqTdIjq?=
 =?us-ascii?Q?9mwqhmq9GbIxuGoA7Zkn1/dKu6voG7PpeEeRYbzOjjzoXHbOSQgdPE8CkU7h?=
 =?us-ascii?Q?G0Zob2mch9AqcOpUaTsVE9MGqixuaBt3/8e8OiXrd94VsRwWmi7rOkBgc0OI?=
 =?us-ascii?Q?tq0Eb7uoHo2WTk7LYVAT8zg3jYY4TApyHsINx9Qz0RtlIpx9Y7oTO8zbPlOJ?=
 =?us-ascii?Q?LPiNbZrzyE/taOanr844YpncrdMxblEoL3QD5E9PX5ERJqedkCTFm7pEWilr?=
 =?us-ascii?Q?HKfln69Wc2MKWRTDMXjS84xl7a28Ymoilk5gc9tDh5LUd4POnEpe2pbVVL0q?=
 =?us-ascii?Q?SbN8vXj74ShGZtFTBP3g5EmwwvxEjdx5s1QHKMr/QPvkPTlf59kmaSL1VN8o?=
 =?us-ascii?Q?pvP5kTsRUG6BCvJNijZMzUuiCusQ3Cgv+kYbxXxXksrQqwKYHR47yWXhOKK0?=
 =?us-ascii?Q?b4zV05ung01+M8eJIx3i4UhQF2czDK/AIXTMsnR4ttc8HeoXa2DR8aRZ6AcR?=
 =?us-ascii?Q?jhUzoZxdN5Z5sh5NGYGtd4huFcZFjzMJFDPCst2VOowULI7wZcr5UUIr9Dw8?=
 =?us-ascii?Q?Aj/zvEpS9tLUaPe3IA+9mkPW1A37Lu1uI68Zp1UKmId7I87hjQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gBokW4KavdLs6PTiQTq+jhgl+XlVA/n6b9b35Polv10HiWD9BNoll/M42fcL?=
 =?us-ascii?Q?xRGAnwbW18NJhzriUzkcSQlJQ7HrjbrlPea35Mo/XWa/p84YdpQU+tlWvlt9?=
 =?us-ascii?Q?lFv2GTeBHs/XSlmK4JETlFKJ4+JldXoZdagil7m35cTipwa2i2seny3mnxxA?=
 =?us-ascii?Q?DB2cr8fgHBtxpAgnhARWc4VVzGLgzgv2ZP2VhDeae99ZhyB1nA9H6N79Y7Xb?=
 =?us-ascii?Q?e7ZaVSCQrW/CHQ2D7CkOJF/Hxd7m6vE9B6jfJ2VaVdjtZJab7PrKD4MKC8rd?=
 =?us-ascii?Q?b6D7pzsDfoSFYsK2Q1rCYyWKXaS+0hFuSkEXYcZBnE5iVgszZQSG1G3PaLxA?=
 =?us-ascii?Q?6lFZoQalr8sFcHGMqlhDFA4EiQi2FARxAoJLCMYuSdK/fFim/m82m4ydnNas?=
 =?us-ascii?Q?ga6iu85xlJn5UB+rIpFeaM6isIRN8MQxNM1BB4JnebYl5PhWij0Gj9Z7bGNx?=
 =?us-ascii?Q?ljHWoIRrDIxgXMgYIU7NZ+hXQKCC0n6IUwojil4c+WFpbXwTixc9kiNJh0n3?=
 =?us-ascii?Q?7h7Cw40WhyuEjdnSwercrViYGbk8HiloyagPCfgcJvfH2UnIVHyNYzz/CL0p?=
 =?us-ascii?Q?C+ryU5q6XDpySkZkfoCvXpadq7nRLIQMRxWgntbZBo/4miAFgQ/0EEluWJqT?=
 =?us-ascii?Q?KJGCJ69NBqssV0xAUXfc+5NYpNRnlDyBrbrUNKGS2u7/HY4ndA7l/wqZYd1M?=
 =?us-ascii?Q?rkZHmPjw8w5ck+77DDUwgD7RQ3AInievHagY6MKYl37LvL8NBweFF6uTAHlf?=
 =?us-ascii?Q?O1rR5E+j78RfP1Td5tNRYtcLjLzQaQdxUjQBF44vWBu8TG993pf+hIwPak2Y?=
 =?us-ascii?Q?jslh9/1s+P/NCjoiU0QOy5pcYC+p2EDwIpZY0vgtdtCsQwatiIj6FZhYyv8N?=
 =?us-ascii?Q?cTN8fFNaUGzJ75xM/3IUKZBE84979UPIth81Cu2CLDUBDKJkJy8m3BckSIct?=
 =?us-ascii?Q?0FrWNrVdy43j29nWQ43xV8XnaVeZ3AHETnGtt4/ltmj4ZMPeRVXvWYYpgdk7?=
 =?us-ascii?Q?iKjtrCsHU109TCkoRU4S4qIIkyg6ZgwS0gtP/G9f0+Q5Pc2FzEcS/b7EV3L7?=
 =?us-ascii?Q?KI9A+itkgFMhPpK88lKrx4r2DQsKtO5Mu0kZDDEyWirKEpHDo3664z30JxXz?=
 =?us-ascii?Q?gv9XrVACBfUvb0DKirq+0nEpVRc68rjVbr+37+h8gw2M1li8lOWPGC1oqlOE?=
 =?us-ascii?Q?Y4L5fQfleFE60BkBXIEO/EuRY/1S0pnrO7edKQo/h/JntC6CynfUoBP666W5?=
 =?us-ascii?Q?MCgH7e+c8zxciV1AxqOnyouBFg0Hv0frjMYcAARU+f7BPBRF29oaH1g9k6hO?=
 =?us-ascii?Q?M+VDDGIhdL/5eJViZten7mfqAXg8tR7FY42DS6mWUynZaPTZJ8O1zYOiZyUr?=
 =?us-ascii?Q?AfyM4YTL0rv8T0lIfYaifs2FuJm89HSjeArf1NIbRzKsdLLvy+n855ep4i9t?=
 =?us-ascii?Q?f48uhdSkddWUUW6vbMMDxLV/6lsmvfbaz4PIShTqFUCf5MLPlMCgYViA5ob5?=
 =?us-ascii?Q?U4DWGcf6sKOCwxSeEFnBWJ8JXSSRw95MSR9AgHBxnDjscTeCl6ikXbj2dVfz?=
 =?us-ascii?Q?+WfBrSFQdsRhNlf9tVtYGz9zUIUCzNjQ6hLgrbQn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e496e0bf-8ec2-4a50-5a4d-08dde4c5b719
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:39.1423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpsfadR4dAQL8EDXCmKBHjKfjgdqBwTPMcxyTA57wjR8sFnJjEiRQRaEdlKu2Vop
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

Add some basic checks that the sw_bit APIs work as expected.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_generic_pt.h | 110 ++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
index 3f3eab35e5cb1b..9395e4aa295c19 100644
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
+		for (bitnr = 0; bitnr <= pt_max_sw_bit(pts->range->common);
+		     bitnr++)
+			KUNIT_ASSERT_FALSE(test,
+					   pt_test_sw_bit_acquire(pts, bitnr));
+
+		for (bitnr = 0; bitnr <= pt_max_sw_bit(pts->range->common);
+		     bitnr++) {
+			KUNIT_ASSERT_FALSE(test,
+					   pt_test_sw_bit_acquire(pts, bitnr));
+			pt_set_sw_bit_release(pts, bitnr);
+			KUNIT_ASSERT_TRUE(test,
+					  pt_test_sw_bit_acquire(pts, bitnr));
+		}
+
+		for (bitnr = 0; bitnr <= pt_max_sw_bit(pts->range->common);
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
+	for (bitnr = 0; bitnr <= pt_max_sw_bit(pts->range->common); bitnr++)
+		KUNIT_ASSERT_FALSE(test, pt_test_sw_bit_acquire(pts, bitnr));
+
+	for (bitnr = 0; bitnr <= pt_max_sw_bit(pts->range->common); bitnr++) {
+		KUNIT_ASSERT_FALSE(test, pt_test_sw_bit_acquire(pts, bitnr));
+		pt_set_sw_bit_release(pts, bitnr);
+		KUNIT_ASSERT_TRUE(test, pt_test_sw_bit_acquire(pts, bitnr));
+	}
+
+	for (bitnr = 0; bitnr <= pt_max_sw_bit(pts->range->common); bitnr++)
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

