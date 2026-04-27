Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010033.outbound.protection.outlook.com [52.101.46.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224D3B38B9
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777331266; cv=fail; b=k9OCeVxEvRYVcYCJhj90mnGqL2gXp9DrOGGoBUBl6RyNWW6mzQjRXVE81zmEhHnW6VBZMM9toPbc07W9vY+7dDrSjUi56xWmHht9kMRqJYlYKgR380OffXZoBBwKzPpVeyisukMB075zmM9ibHPyXpR/PtjRocxdSD4N5QtXb1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777331266; c=relaxed/simple;
	bh=hrpZmpemGG9rKDg0QcqbyS77yIOFf55IycjGPo0rdfo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Yg2v6uVxCxGtdTjaaQt93C8aCkCcP4iB9QdHfQxGu4brJHOt49jdUiIWcm9sNBGuk4H880mh3Qmod6YqAlfiN6KjM317mf5o0PQM1S4eo2VlYhxPoTymI8fzLN4hHhFDLVUDXRn0YJm/f/8WvC0m3i+M4vY7FFhfp6Nx2PpgKdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s4UGLxy6; arc=fail smtp.client-ip=52.101.46.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s4UGLxy6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEvKGw+h58Hja/7PbVr3/JBbGeGria+NYj7mYwB7XO2Yw+Tl5wlGQbcUXMxlI2TvwVpXClXvHy8+YWPHmIAC7LEeD9HHU7EdAKvdgTypxH6MvNso2h2dAj8APJVVoLN44g6lMwQP/sBNjWEJShdHwo4HEsLt6vH6G2sI/h6wsWQ/LDsoh78itiphAoExbdZRCSKVYWg/vRt6QMPPH4lAS75yH1qpGzOWVSMx10hOYLsC/o+ibDluAbgGvh5TL5KUUC6hw9LsejiEGL5ZH7cTZmWOrqGBYSOU8FKRWst0KZMAMrBOi0+xjSNEsKOPKsUrnqJCI45TKjsI7qD9ycd5Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yniJPIIJg4KZQaf6s2GnV0zpKybliSC8UdH8thA88rw=;
 b=LyEsWgNZZx85eGHyD07xi2/znsto6ukvjg+tzM82IsR29MmXB6qsq2q/ScqqsxVnHisE+ChJjsCqN0jMDB40n8zioZFXzDzfbQdm4i5Pjr55VuqaJzttsv3xRHql4cY/KI0V8wIWqOa0TEfC22vhUuRFf1CEUX/1705Elj97hC2mP9mrtB6LdDvmZhuXMa48vhnqJK4S+giyP6zCaeFGeGKoCGX0SRy7So0MVUdIvRacYf6XfHMyGOvhshnpega5Sb7QEunEu53TpyKEy/rBGJKy5IcfKRFBKAUxGDyxJ46inG5HRNO7Oeq94GONBt92GRKHoriBfJpLNBEFlXmcPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yniJPIIJg4KZQaf6s2GnV0zpKybliSC8UdH8thA88rw=;
 b=s4UGLxy66RHAS/BdySSuhtKstthHhr1TJEKG0dGOmXeNTzzCNEr44wxkrUw17suF/CwIOOMj4mZNRfmBLi2Rh/rHHn7zwf8ZvhyBUYu1nvxzdaYud5Pc8mwbG+yuqn7Cb3mVN16PHX8khw+FADMlh0ClxdHVaNjHC/mCEgMZeQfc+cs5HIAdQ36jDJGmv3xse2sbm0g2xtVwhkTTHUok/8itSnb92a2oQiXuUAuCLwAq+aMfTTgtR1EMGBDcOD+3jLVCPZFTGLbBGeYIXSmaHUAm5+hX3conPkC4g1dPf5yPDrxXC8JOIGAjkzriNKPJulZe9LM0Zl3mONXKMa2QPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:431::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Mon, 27 Apr
 2026 23:07:38 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 23:07:38 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	David Matlack <dmatlack@google.com>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH] vfio: selftests: Fix out-of-tree build with make O=
Date: Mon, 27 Apr 2026 20:07:37 -0300
Message-ID: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0203.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: e83a55ab-91b8-469e-2c3b-08dea4b1c6af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kdlMDdryYSrn6OqlXexL9TNHNPJ/24oAvrxabr9w2bHY/AijYny5jljvas8WxD/2dRj/tNxJuJAmlikSHUelQTtgAPboOsHEcagaclpXrhozseKD152HIEprmUxNjRW1o2Q824V98aaIXShjcR+kI+FzauNP34HXvgSLc+ivy30beOAMWuMaV0oWt+6utfQ4fXuSR+OQ51hCUguZ6m+BFlQsVclRx4GWfplr9zxrnJA9CwUDcSsSuji3do3NeP14YyLhH7nYPbuFsKUqOxyZBhf6dIycasirE8aOF8g6UygyWXiJl2OTvXjfro+9J6s+CN8cLFRmH+4Dze9IaqkkJ8l1xX3uyNj1GG8Vd2JZmY5UymXTsicwY/1AxK3ueF+xgUBkN74/0LQiCrxemegEKyLa2Rnj0uDCrRB3nFpGo67JBv+5xYGOLFABRGyOoMRJKNyPI+w787CJiGHy1vM7dArhz707y7fzmed1vQhjsGWXq3RZBEvLhhoH8uJP7XPK+slBOMylgy6qO4OvB9cKhRaIhzqkuTWQ0SeIeW9+FjTuD00KtK8Hx+ggajRk+g/POZZFrXEwPB+iTflrT1CXEjAP3XWyIbo1ESZoTfRODovrOhFuSFGHIcJiFbeN2qoOsrQJa3TrP9UBrI+NyjipX+s94k41CwvpjGvK5m4teuR4l8QOTq0xmlaHu5JuUdvO4QeCa3atleU8VErNgjRhICSOTsd303KoFPOJWPFnPcE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvxPTW+ZdOVT/G9ffpwoDtihodTROFBHRhLIzGtrfOEtp1TvZU8Bi7YBe+4c?=
 =?us-ascii?Q?8pGgsq9LWsPVhli3YWMAvINzOjgUgV0ao/RetKMg2CabNhiUXVY/+mChBu47?=
 =?us-ascii?Q?YVgb0x8BgQdynvrpwa3U+ur3T5Asd8BBlikmoLUfgWm7fww8uMbkkHKWEbqj?=
 =?us-ascii?Q?NONo1jLj+ZWI5jTM3L7ytftKmfaVH6BLLvw8eGvanYm9AO+dGFzJF846pmvw?=
 =?us-ascii?Q?cuBQ8vW9Q5jdFGETXwXMG28WWQLYdk56q5imyXKr9Loc5UJa96cI0KE+qNMF?=
 =?us-ascii?Q?aj275onR8GWXzn78riOwGANZeUrlGFf3HaKIQd44xH861MeQVho0ktf/fHos?=
 =?us-ascii?Q?datw261qxTSDFSsuZwP+/4yx1NCvgjae63BJIfsFxO1z3yxIZZ3hLECklwiq?=
 =?us-ascii?Q?6qzstryoMLx0+wuOp/uhos4GtIDMfkTDw0DZVJT7QQ1UtcHTaZavYRGs8wd4?=
 =?us-ascii?Q?M45LuNjW6jeY51R7gpsPNUvFbmIzZp7IcGx/FUwzk3YC93bba9n/iZ+Fp8/k?=
 =?us-ascii?Q?WLlQkmNyUberdT58M8JYI0oEO95bQH3DRpbYfbDR1C7z+UAhxcwLj+PPD7+i?=
 =?us-ascii?Q?C8n/G0qQmYPlHUzSFde7aFz8Hs823il/dMnceiNj4eiHskATuCp4QFXDhUxu?=
 =?us-ascii?Q?bIQnflSwWOAFyXSheUMUYkPad7KiWVjGTgzpMd0gHZXID0VWDdz2eFnr6pum?=
 =?us-ascii?Q?UqgwMdYydffnEmqhm6rbDkcvSG3Fl4vRGxtEZS6prm8WRIfCoLAlcyk9vDuk?=
 =?us-ascii?Q?0TcteLDceDtn90rvCJBikzRIK5b874pZbiBSZlLV1+TxCsIVGTGIdF0sCvBR?=
 =?us-ascii?Q?C2qZ2sOxY6rUjKifSLRqB+f1rLZkpL9ihUNQ334LexWqGuELDSPMj3kzJbGB?=
 =?us-ascii?Q?z+HlhTfrA9cp4kfKMxhuiKDA3hOFJYFwiqG1V1Jc+sRRMECWXmqmwLlWJQb1?=
 =?us-ascii?Q?NlJQT4G+JOpEdlVR5gLJ49nXfHjt4n2fBKD+IM9o5lTG+RVTSadChfsCJQwM?=
 =?us-ascii?Q?akZWBAUNeDo6VYGx/zMQseqC0/HrgdtzdnDgVDBYIafqswXRdB4lCvBH76+b?=
 =?us-ascii?Q?pyj0bSFQUAXVPI3D1jM2hIaaJtlCsDyBwGnzinZBcAzA+eSPUbATbt0k4aNh?=
 =?us-ascii?Q?7F3OcbdOkRSNiy5+hZAuOEZMMRIgAioOww4OqDvbsGHPPPQ5PBmMvCemJ9mH?=
 =?us-ascii?Q?fi1tEksZHlo2j8ZXpFDNKQ9vF2S8ZaQ+HgLs6yO6Q95aEa9e48L6KnVkgWUF?=
 =?us-ascii?Q?X8MO3IRhvgX4BM1w7CQqVrQmZDGs96ln0ZLjE3QqkvAm/x5Pz7tM9M2bNf6B?=
 =?us-ascii?Q?pmKoka+5gXKDWsZnIrChbXpz8OyXPFBw4P5xaQcy8TNyIZd8bZqLpvLpjTl2?=
 =?us-ascii?Q?sMDaIzPy8d9YzqMrEm7NoZTXXtYqXoN5ZvZbGdENkyHGxntSe702DhLHL6O9?=
 =?us-ascii?Q?sqVgw04nAVOln3QiocJj8SHARER16KpYkF5ZwR4i8BibBz9gzToY3KW9BfB1?=
 =?us-ascii?Q?yGzPdussN6LT9KZMTTq98szvHFA6rkpoZ7Fp8JkQPp0QQHAIpT3OOb/9fdwo?=
 =?us-ascii?Q?w+zs7R8EEOp7PmAA7K4YzBFbHtjM0WeOmXyddnnyOrKEizBxPU5IB13CVESd?=
 =?us-ascii?Q?2Sp3mAzSexbgYb/K3JA7A8d1EASOawPtT/kAmedTWLPS3l8r3TgnQ57CaXPi?=
 =?us-ascii?Q?tSdFwg4Ws44WSbg7kS5BM2kLjJ2LhBKblHa1TcZCgEMaNyMH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83a55ab-91b8-469e-2c3b-08dea4b1c6af
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 23:07:38.4227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fb2WZp9upTzFDCiT9EboLZ8tICBSPQe9eTVbKZk9HawJ6Bq5dG2dtqt+LPLyoBHO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529

The test programs are compiled via a static pattern rule that requires
intermediate .o files:

  $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)

After lib.mk prefixes TEST_GEN_PROGS with $(OUTPUT), this creates
dependencies on .o files in the output directory (e.g.
$(OUTPUT)/vfio_dma_mapping_test.o). However, there is no rule to compile
these .o files from the source directory .c files when OUTPUT differs
from the source directory.

Add an explicit chain of pattern rules:
  $(OUTPUT)/% -> $(OUTPUT)/%.o -> %.c

Following the same pattern already used in libvfio.mk for the library
objects.

Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/testing/selftests/vfio/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 40165d087a0bc4..81c3be8298fdc2 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
+$(TEST_GEN_PROGS): $(OUTPUT)/%: %(OUTPUT)/%.o $(LIBVFIO_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
+$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
 TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
 -include $(TEST_DEP_FILES)
 

base-commit: 681b35420592a2e072d9759254185e72d2e914c8
-- 
2.43.0

