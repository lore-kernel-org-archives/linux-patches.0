Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A4270EDE;
	Thu, 23 Oct 2025 18:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243766; cv=fail; b=rU61t0eA/fqrgxoqzDOXXZCQt+JU4GaKOGk+pq4FWSNfzgV62QDfH1i4hQGDKzGNPigQ98RWA0ZTm81oPXql3FtQCaXIVvxWkhmNKhvkJ1qVaFvJ5KmPXTNrh+cEQ5URUeB/9eqGlz4q84MRwLZJL3Szy0vySXUOA9axxLcb1Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243766; c=relaxed/simple;
	bh=d8eSIh1fhlT+l1qonN9gUM3m+klqehn0eecFUXaT8YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LpeN1/NOQ8ZaRiFEWCnno3s+XsNRl+mGm3X1TbL6Ernv3jXHkdNCaA01nPpEdXsyiHJC8I6je2tXlxPyAQVh77T68tdW7JuT4ec4QgRKCNehb3n3L6AsgS8nIJHQ+mPBBHDsgiLBDuzw7HQZpkLARtMRbpFzVP3ZAp0gqWX210I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mj8It2wq; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mj8It2wq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJ+kmljL5BBR4NRmKabyG+rw/R+Ws3BFI+EuvzconKkiD+dkp9P47xGS3mnEYCwITYBEQmppXFyMKCj6VeToc1qvJZdNAsWlfrqYWC0HjmuSIvQPyD1S0F+pJgns0ekxbj/OlW8sx/DDOFx1tqfvI9Li6ahsZVYUzqePb+oVEt40FhMUrRwRV8lyPmQfdn6x5MIPk1mo3gAUR3BG5V3zKgucMykNr2oMUneL7hb590yRL3uXSbPePszQyPrPEq+w3vDH19lOTk0goZhXxMaMwoAz24vxEkSbN/NA4+0Ocnb2BKIbe41ElSgCXtdESOHzh2xurEBksP3i7IMei0z4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmdf+FDuM1Q3pUMWWBQq8P8Zd7e7AO4TujPnU7yIsz0=;
 b=nCJbhyE0uKrNCax4zntLgbMgCmSHastaMW8Mt0sfJKNsXxEL9XupOEl9S9r6SdzYd7MQtdMnTDKkyHSlGwgC7e45Z0Zvat8AwjSFXs6kTBRHKdxQSwME9x+anvAOdkl2n1Me6eUlWlj6CJ/6EyEydnC88Eu+fIPzdv9VDsI98y9wcx8mLMieTSLr2DTJog3IwqDZMtCmQK3qNnjjGhL4t02IDPbEXe4ZMtWixzlapTHXz5+WT1KEXnQI6YpmmofNjdQ5gZrX4GQKuY5kqEEPASyL+1igJGJJZ/Cgo9W2al1/pMrVban0MgjOe920bFP7fLQDkkFu7GVq8vNRg8s3Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmdf+FDuM1Q3pUMWWBQq8P8Zd7e7AO4TujPnU7yIsz0=;
 b=Mj8It2wqEfHPqwqi7jVoyqdLv1liMwSBkwtW3w8bOClLgFy9DaobvEFbLku9iWOT8MUM0ATyX78rVm+sfw1dww6vF8rk3p1s0xPIAVGkNL6ULM8Z0WVHGLfnt3YKRUnLWEPBBWuKZY5e786YPbg2ohxQ46K6RXPlAKOqYzcb5ILIi/Fhg6USqrXUebOhpKEfygl6uWeV/g7SdoQlNSK9EktYaGTD1KAGYC1erY/bXlY9JDSgZkAkEvpORuTCCd7QcmuOzYZtblcl1ueUAKqLCdAEX2JpnX7yTI8w9xgN07H2sBrFy1aL7scKwKPVCuI79iv/HUM3bKesc0AdkvgFdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:41 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 10/10] iommupt: Add a kunit test for the SW bits
Date: Thu, 23 Oct 2025 15:22:38 -0300
Message-ID: <10-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::28) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 4318eb3c-30fe-4a69-2965-08de12612707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uh+WdEGNA9U15CLGVE97uFdbVo6+0/s2n4hu8jXZ6yaRi1BAy279brDjkac2?=
 =?us-ascii?Q?hmi0g9b14rw7Oppnx5ji/fBqJJEwmTLryb2GjdpfdxlVStGQ/W8qAGjhEobN?=
 =?us-ascii?Q?BfP++n5GHJRMM52Zfcf4V/owyAzqtMeeU3bQUS0v/L8yT5BhGHEpJplv4gzO?=
 =?us-ascii?Q?t36U79IvjJufyzJDZd9vxUFKXo2ZgoFqC6z1Xz8ga9yQmHTF5rZTUUwadD3N?=
 =?us-ascii?Q?ltpYB5nqIOkQ41B30jwovBR3xXgdThpxPp69tiJTqxsx5phtOL/Yqkyoq4/6?=
 =?us-ascii?Q?uTta+yxfvbjpdnuq0xc+K73U+YS0qYvO/0Pbth9vmq5Fkk7JGHYUoYbGZ8YY?=
 =?us-ascii?Q?Qu+5m7G2PcxgrpA9wKkjNmmGUQ3QXE0mkiPr1vACXSh2rRMTNr54YvBbu+H3?=
 =?us-ascii?Q?wrNqSIAW/RyofvhUu+RzuFc2floNEPCG0lOgGMFldLjdYZyp40s1hZZh6cox?=
 =?us-ascii?Q?u+xG4RD+STIIan3urcMIJECt2sN1KbyyLx23anVCnrP34z5TFqTOLcWReiHL?=
 =?us-ascii?Q?FTSOloNNEl/bt0c2ZMPtrwl60/2fAUQJNceXXx9kEJVD9PhNtgO7EAcOPhqT?=
 =?us-ascii?Q?VYZBgLn0T0PozVUdzUjpveI8ThzaY4PDsr6OgJUJp8eaBWtpehdQ3oQ1/8A+?=
 =?us-ascii?Q?P8mGVmVEpY7Atr78rPhHFh2avDkLVgyL6IdC2u+gVUa7sfatcvKMltj0pZqO?=
 =?us-ascii?Q?DlRHDfzQR4fMWKqdyXUJzjxcTUWKqpa42M0uVloBP32g4IAphBnblm1K65CI?=
 =?us-ascii?Q?ix7NNoosTqji2YwDc613TcWxplTu1Uf+3lXTyw2sVy0lfM6SHxFxmxKhR6vN?=
 =?us-ascii?Q?OZMyj/k16JKCzLwiCMoMwOa8saYcthbVGrybZPg/W6DM+/6cAsblAbmQtSSn?=
 =?us-ascii?Q?DdaUamE7MUs+Hewwyk0OHWqrpXRl0XzhuVX/l/Im8fP6ymWRuvq2Rt3E5jIW?=
 =?us-ascii?Q?M7dcD2bWFym/ii9ZBMnuAfS2K75FcmgFQZksPAPoSyV61Yy1uCgJTR0DwB47?=
 =?us-ascii?Q?KzOm6mQa4qylM1oCKvHtmaI1wEURXDGDi/BGMPTjic3zjWdWf0rQ7XF+RSGy?=
 =?us-ascii?Q?N4qoqDOa1yfG4B9qsLU7zS86svp5aBxgSoA7B3u5bhGazvpwA9brNRx7VX9v?=
 =?us-ascii?Q?zBtjc/WOA95Nkl6Pu22kO/QlLn30gOeb4VYoDjAHl6nKxKI3EU3lxx02iDw+?=
 =?us-ascii?Q?3/LFvUJneYjDb0vSe0fHFx277MQUprESmZ0+T9TUREf180MXnJTnb7I0L8oW?=
 =?us-ascii?Q?UEHQWWC5kiEHPKwHJ7HQUOs2h/vQ0HEIZs7A5sS5VWbmAImml3C7EvR3+LCW?=
 =?us-ascii?Q?1S6ib+DT1YWaNY+/SBO5uZF88HGJtEr8aS/7oFRkBff2POFULwaiuqNHhl6x?=
 =?us-ascii?Q?FYs6cu7Gw0IQsia/2fL26dsQ4s/diM0LkRx7RdCHREc/hwQrUDavQ9QCqaox?=
 =?us-ascii?Q?vkFMXO54TaO3al5oXHcPWFV2Dl5l67Z0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bgvC3DMzlxP+Aa0twwPTCJwoMTmXCA6N/8BpHbK09mcVs/7VRPLmF4K+P3kx?=
 =?us-ascii?Q?XeriiITKsc29bFM3FFl07FVBDvw3tJLVgR73Iohf5K1gVgiZkWtRMjRMB8aN?=
 =?us-ascii?Q?E1do9r8x0A+x9LtJBPShPTdTcotNLjGMAwHuZT/smmx4yNeUEc6EmkRd8gjy?=
 =?us-ascii?Q?EcnhaPCkrEILX+Rw7ty9AAdutI7wsGFTmag3cCLV2L0moUIa3Z3m+yFUHJd6?=
 =?us-ascii?Q?OAOJoKW0dW1WGf1M6RSBywSMJc+T9R6dQP5IisvNmzCC80O/UTeFplZqr0T1?=
 =?us-ascii?Q?hrqvypIOff+xPi6VPsODP3aaB5mUorCdSzxQn183w2gAuRHM8F4cLDtuvDX9?=
 =?us-ascii?Q?YQ/gUys4Lgme7Wg5PPr6WwI6pOimZ2xmgkwzQkzsviGg4/1TAUN2xQaIkeyr?=
 =?us-ascii?Q?T/tcRqtZFgjAzb+R9n9KnLA7dEElBkosyqleyBSX9b0WTklB932QkeWy0iRf?=
 =?us-ascii?Q?Nef5rkk3B54Fts+Hit+Rgg/SFksYUCjgXmQcETjAUmCsiuQWLb1zwhqKQ6w6?=
 =?us-ascii?Q?fYBpqitrTjGRR5LJwhONdbqwxangY/rxWhwvKhx9eYfiFzQ+l0PfQKR1pZ9y?=
 =?us-ascii?Q?7K1z0nkWqqASsZozhC9j1MwDq/Iu8khUdnkX4p3OOaNAIe3DAinjt1CSTbUa?=
 =?us-ascii?Q?HBUyeRttBNLkB69cWmd/42gSIqlFxc6mye67gUFWMrpCPlQif3f1+gNStudb?=
 =?us-ascii?Q?1EV/VFjAc6/Vh2K2bEGXWTYQ7NyBoZYhguF3g9ntuU5UlaI7UMJtrq44gEee?=
 =?us-ascii?Q?AmEqWB9GS0/y0DqW+h6vHeTzz6z2u7kuBXskeyQ4yX617HGUAGqddq7tJ36d?=
 =?us-ascii?Q?G8NUyIS2VYpF6BFtXQyhwmdMX6NiwSXLBRr5McZY6qnV+aQRHX0UCv4zBChk?=
 =?us-ascii?Q?jm9LaqgOq01m1o1k9WzyOtwTR/HpDSWbVDgiDwztBpJD/TAQZ6mp5JIT87C8?=
 =?us-ascii?Q?l8V35MK7rlVRpxq3jE6rZJBWvRc8Ho09L8961UqrjZaN+1igqSeR5zyaMqR5?=
 =?us-ascii?Q?u+n5RpQV0b8lpqorlmKBvN0FXjtFBOJNENFTkYTCLahbVoV3DHBeVPpZhkEZ?=
 =?us-ascii?Q?r2SRE8OtfxKFtILc30uQ1M0FrEZcyzXJO4yqQPgHvF1qKWgHlhaFY9gip998?=
 =?us-ascii?Q?0/egig3adTfuMKfJF0/0ra2yKepAuAhhmj+Gh3d/76ok6XHEKfrWtrgbFH5k?=
 =?us-ascii?Q?P9+XjUpg6J+EljgyVu94ycoSllV6UbkYeTxZbMJqS5zX1q0RLROLJo7xIAB0?=
 =?us-ascii?Q?hoYJcKZBANzgRw7pG1LIkGbHjkYLi3E2sxHrNS+5XKCoC1+612yqLUZjaCez?=
 =?us-ascii?Q?PkHhbB5HMayqtKBTNOvXx5TQrLSodApSHGrEiJF4wD5rZ2u0ZUcuSZsfn7T0?=
 =?us-ascii?Q?Z32wIiexZe+Wo1tBZbJa0zuWpV+D+cQ+inHlZgm3EbcgNWR6xeglkEMjrA53?=
 =?us-ascii?Q?LLKndTgut0PVy8uqkx7Mm9hKMBKt4na9jcWDq4uoPTCGOPhJCwi4B3XKgZep?=
 =?us-ascii?Q?HnPGSTkW1+rC/xfDbbBtxTKE05c7kBXu5eNBX7m/eOtD+YgDfPgyEJsCB1st?=
 =?us-ascii?Q?7exSGiqRxzKRttbCcJK3EvuZEnFCLNtzq8Ub6kfF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4318eb3c-30fe-4a69-2965-08de12612707
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:41.1762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89MvRWL37u+LLBayb6r6h/ozsXbBNNljUoAX4qQT/LKBticlKibIFsTWOzGmZOM7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

Add some basic checks that the sw_bit APIs work as expected.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_generic_pt.h | 110 ++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
index ae8c160966302c..68278bf15cfe07 100644
--- a/drivers/iommu/generic_pt/kunit_generic_pt.h
+++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
@@ -660,6 +660,112 @@ static __maybe_unused void test_dirty(struct kunit *test)
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
+		pt_clear_entries(pts, len_lg2 - isz_lg2);
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
+	pt_clear_entries(pts, ilog2(1));
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
@@ -672,6 +778,10 @@ static struct kunit_case generic_pt_test_cases[] = {
 	KUNIT_CASE_FMT(test_attr_from_entry),
 #ifdef pt_entry_is_write_dirty
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

