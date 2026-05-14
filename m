Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E45330675
	for <patches@lists.linux.dev>; Thu, 14 May 2026 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778774692; cv=fail; b=PK6s9FZXcbtHYS5kdk6fK7n269POLjSEgkSSEDdHT3jIv/FKyjPMpdI9NMvCPfTfyygJ4QILuy3eBIepI0rp8s6Ojy92eyTFkIlaJSzE2IqK4zLGt3bDq5HCv9gyH5hXA534rafV6VgQp1CzfJwTurl4Qp2kA0EG0hw/UU0noW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778774692; c=relaxed/simple;
	bh=iJS8pnveStfj4QwO7CvE/cZnFZOfuTVx3W7S7DxFsyo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=R32b1N39K7BE7GLHhh/zrus1tB+JQvHEemaASHUfiZ+xfm/Ihm3KfqoKdok/9RNZJqGbdY94eiR/uARERpMNuwfiWz8gtmp6RvnesCLPQs/fryucpAWxJXKpPF/D31XmqGv48QJa2o/ILHGb2HosYmc2XjrUrIbUFx4jMNh4lW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cD1/EeJb; arc=fail smtp.client-ip=52.101.53.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cD1/EeJb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zG3C+oDM1J+OdMuVjuz4WFuQZw8BczARSPy1aThbLkVYGtCTqziWS2qcElFKrrFR8VwpBgvfymAMQnVRuZGN3g5JEDYSEgApCIz0jdu+NRSY9jid8v2dh/Aj8d08eWE5YObvkCzNPNWcrKCek7DZLYyumSM+mkqj8eg+Oiar0pdJxs7VRaP3qd9V+/v8nHFXHZvbj18iyBfMw45NcIkiKrSOkxUNrCZMWDsE2TgUM28HmtIhWzrwDzIh4BwhZTmljrYOrahWQ5gqSdXdJvU0r69zEP75rfRslWu//7h+fPd/x0P3KEmbegxxVfEIx64xwL3oDCLS53sJA4Yhl+ZjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rBKi2K5AlTB4xfkGUhNurBgjtOdTzg8LETWI6PDwug=;
 b=mwthFm8ICLtav7ul83Dwsux5ymEe8Zk2aTSUtJVRBRmVNfOHP1gS7ER2AGqw9C1BUPjI+++Keed6CCaOBCf+RQvFHFoF+Q5LQguXe01Mnu9RHEAlaUHV3eRiGDDUALFxVcXWaliqiTfpIpD3D1+PIdsySMIzM4eAAQQDE7eMd6zPTGbXc2sCvWhjzFinhDv0alkJ4A4IvM8B/UGCawRVDkZa4nNxxchpqNHayHerz3QlhZu6Kg8Acu6mYLUM02aOdPmOXYigMxoszKT51PqvL1z9X3uLz8gcWIZvfmDvKGqJvAmvmsPUq1+SBnbw7nkVvzTxSx20rHaAPpVhFc0Ovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rBKi2K5AlTB4xfkGUhNurBgjtOdTzg8LETWI6PDwug=;
 b=cD1/EeJbTPWnEtv9GbOWWaQGS77s/JOSiNsJwFzlU11cmP4F5/0H5XrxqAciE/F3als592QHToL5tcnKl9BzKdknZlGoqhwhjK/rL9q2NReQQejhymXxqdCeXvSZK967ntbdUk4o54QYOhTj1RN91ypTpOK7ycByOlDAbBSWR+EY5jf249uHPT1hB+bZf5IXTLwwi9bfL/l/HDngAkgZLi3DKqWnzllnl+5RjejotctEqNbK/2iVCUXVzuGXzC8G4VD+KmSGtmX8zCbbTP9TsPG2/L0UZeKNJonLDBUeaUZaKzF6AQ0XBbCm2SoVUlGNJWRMCwRFL2Arrpu+Sn8unw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 16:04:45 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.012; Thu, 14 May 2026
 16:04:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	David Matlack <dmatlack@google.com>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2] vfio: selftests: Fix out-of-tree build with make O=
Date: Thu, 14 May 2026 13:04:44 -0300
Message-ID: <0-v2-4ccc247e6aff+1d93-vfio_st_make_o_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0051.namprd15.prod.outlook.com
 (2603:10b6:208:237::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: ae784180-fc1e-48a7-67c3-08deb1d28442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|3023799003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	97sOADTGxQxrdHnwDbjlyYv8geCj3DegKHsM/JlGi3y0Vd34Wf7yfVtPt5eChR2Qe2pUH2xQXjFSOCBtN/o/b8AcAp54eaz6WuBj7h/TbJ0w0JG2Jh+OQLb0iiGIL035QmnEcTm9rb0Liar02MF3rD1EAXiulElM50960WiqClfXK/aHjwkA6CykNhLOq6g4cK31odnhDaYyiFSgw+SFXq+FjAggNmCi67giUu2pHxtgGBMgBmtkTT+9sM5XJkdB5lQKcB5oxyc0+oM0dbVJoOcEoUEEUt8h+T2Y3qqmExDae9IdaWA946qc5GUTrTPUeqmdw8a9JL00/4OOkRGQyHqsTSkooqd92fGUKgvPFsN+tesQq7Zq1ZWB+9mpVHx3nq2XfLGCDigE3fCx+apqNIWao0z4h+kNQFFwRnSP89Yb0qhphdyctsAMF34v/JzEsaD7Pr/OkGTVvyNpeypa14VqXxjYJzJvsQQTWBr6ym2RQVT/xsNtfP2L8yWZs2lPlB/cRDxx9aENa/pTIPK3NE0viKp+0EIi7fNrpD29/fG2+mDqENROJX4DWdoumV/3VtCHIYyfkIDxrg2TksdgusA4VRbbSGMl88fxIRww2JXX+Zqy6EiMq9e0fts5WhVcpTmAr37WhNkwg3PpSXOKTTz9E75JHkbTfU9nHY8u0iEoC+WtFNcs0ndjpGOFhw0O
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(3023799003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jDq+d8xobI35iu0ktfZrcVUjje77TSYIN33mhf6K1SWuu/UJ5sOgnq42L2qC?=
 =?us-ascii?Q?9jHquACCNQRF6ZnJ5XzbzCYi4ZQ4PB1mBKz7X1/v2Tn00E4vlIp8am3rU2XI?=
 =?us-ascii?Q?OWQsEyAK1BgcN9FpB7Inrm8utJxWybyWxT+jIBoXF6BmumlWD8B1sI+SuGLW?=
 =?us-ascii?Q?OsUZY+O18OI5iYgq47fl/sN3dCzeJ0qzA2aP0/ol4wzhU18ymd2gqB9m+8nH?=
 =?us-ascii?Q?KlW3M+r41RQyoPFGdHAcSijMYeZVdtWGfU+2ICzRULCyKKt+cxlE/fRa8Ece?=
 =?us-ascii?Q?0SybF+l+CgAGqSgHnPBgEkcSNqBGK8fjZ7thlq9I5Q6VETOaq1QQpeml6jm+?=
 =?us-ascii?Q?U9tRG3b4/6vfPIEPWHr0n4MLa/tBbr+hAgexLIrhqniqjTvWXnzawE7968QI?=
 =?us-ascii?Q?kYyfY0Ztige5HaF+P1GqvZJd8zieYdOi5txfFilicKb+4D5LUFq2wOGmT5X6?=
 =?us-ascii?Q?ovNT3anZsDaP4gKhiRCRcSi8Ry53DcsRxng/U+B96a4kldoyn4RlAjmJN1W9?=
 =?us-ascii?Q?n+JBPHGmsaf4wa1dw4TqtT7HGx4AqUbtNcSdOoaeJTg6ZAoU9k7RnMl41Jge?=
 =?us-ascii?Q?Yuk/BU08Z6c4RpA5QAxCP+WLv+JDypWmlL+9egjEuPTV32DMbOZKUyVOE/yF?=
 =?us-ascii?Q?Qqfa5Y7IYLf1zC+7fwOxw15ZoZIcqvgnK/uKo+JATwU1ZtYtcqK+axNcQZsR?=
 =?us-ascii?Q?cL7/ExjcJ+Xbw6+bAwUtLC8QSuGk+ZIBlI1AlETQGVvBM5Xrhp9aq7ftzkkQ?=
 =?us-ascii?Q?MK+4yY+OcbWZQewYRqeja2hSq9SPDZK2J1leNAi2frgROuIVaBMnllSD8EBf?=
 =?us-ascii?Q?axZxQEGDKeC2/Qt8rhKrfc6h658T+8DxiImdz9DBzcQgOcojsFGj/TWFKgYQ?=
 =?us-ascii?Q?0S0wRaHCLjrXJdLrwf6a7zUwRN7mes04vMRlg/JsiAMRhWr49OvOqGKCh150?=
 =?us-ascii?Q?xU5eHI/Bx2WXEbb7zYGlSWJ/UWAP/N9n5TgSoDXIRd2ltVilSGcn6K0qZe14?=
 =?us-ascii?Q?Xs8/oJufipljq2GTlHDSeq7P1Tt8Ym6lW1gbrOi/eC+T4kSBfbe+IR36gegv?=
 =?us-ascii?Q?WaCYnjckv/H4rt4GEiumy93qO4aHwTA0edcxL0w+iAvYhXfIWQky0IdikKGV?=
 =?us-ascii?Q?jpjtx7XhJwibQhJIQILvFzaA1kvfHhMkwGpNCrXOyr25OJxpCG+jcsDXvilZ?=
 =?us-ascii?Q?RmFaKjqGRwFODCoHglm+JaaUOnlumzzkadPMtZtChLY+JXAJjR5q8elKPaGF?=
 =?us-ascii?Q?3WEBpB7apLI9VLgKNOkz74FSF+Nv8HnKDuw2lpBrEnmgn35XLndfanXRSDET?=
 =?us-ascii?Q?999VN886uGXEFtWbV9z/SJ8io4/DuhzU11ekyPayFPV2tC5LoN9djkIuITpp?=
 =?us-ascii?Q?4dhjUgmI/FdQ5wEmeg/eJaYDFjY4HWKqXu0qvNlbNY2PrZrrePsW8GsAfVXC?=
 =?us-ascii?Q?aDcFPdZ70UDtFnguJ8Hs4wq6nH2ktKOaDmSGEvlyyEVAPpQh+/1aAhTpEJ6K?=
 =?us-ascii?Q?/Ifkfmym1qK34Wv/o7CXLyuIszdxIlYP+qadfFfvkjJFY6mL62KrvGy1Myea?=
 =?us-ascii?Q?l7KAY5nTHKzUDRSXv0/hDtC/msP7U9tCPZtIyjZyvdG80MkwD97lIV02FYx+?=
 =?us-ascii?Q?1k+GEMSjSEBJtjGOMU/PkQdGYw67/4DVDxwyHMX9DhFP21tcN0f6NLB/G7Wa?=
 =?us-ascii?Q?/toCS2XvgQ0usuo/KO0Xsv2UFkrWxVeLBF2SFp0buBK2b2kY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae784180-fc1e-48a7-67c3-08deb1d28442
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 16:04:45.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLobFi29XdXRy9NXwKOXo7aS6R+tuSL4isxXs1a4/xJOkV3mxo3BK9QsH6fLKrfL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8200

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
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 tools/testing/selftests/vfio/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

v2: Fix the typo

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 40165d087a0bc4..0a4cfd1a6c7ed6 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
+$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBVFIO_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
+$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
 TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
 -include $(TEST_DEP_FILES)
 

base-commit: b5953f774781f0b489ae1f34d49eb08fefe176a6
-- 
2.43.0

