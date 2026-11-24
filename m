Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795498312;
	b=DSIP5V+fa5v6Z/joLMD4ZEnY+b71M6l0dSfJqFc9JhaCa/VLwXf7wX2+lo+tO6+uY5Ab
	 w1ELq3cKK03X8tipISgBAzz7iKoHXPaBjD7KrqQX7jc0hfMQM+TTtW75RPd4qD30IDEmB
	 5FkoBcXVXfIFIvnDRoL6xk7keKIU5QPyN3Zku60PwvwkD7NjiUcsAxYoIPGsq2zctNvPm
	 tDr2FsiV+MYOwYLSAutTAaOwPkyZlflh4sRC7ovY1iny//8feUOmNbMcZNACW9sGZGuM9
	 Yq0IGFjR+erODcYqENSpVGm3uHAJH6nExSIZxJF90Wy33NhbjRhA4cg2jXjkdDQMs/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795498312;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=GnVF9/oyvYxcSrZqGwepuUYe09zzYIK9UbOsHmO0TQk=;
	b=RUQimvFKxu1wa4KvI6HYOW7iQnfB1BcpM57JAngaKXdqXH2agvU7jjLo86w2leC9AW0q
	 rvexEFFiU4fx9/xJKW0B4GocrQyPI5AffBpvCi4O/DTBWNRQC3WNW9p/ac2RR3q19YxYo
	 ynZAlx5kYx9ePBZwuug5GYTpqZAluMQ6SRUc3F2J5IE1HFqoIH5MjTdHp8VYrZO1EfPJT
	 aQTEUGFigVop+gbh9dY+6ey+GGOHClLFo8kYjfJp6ALvZemOu6iDI6R/b0xpDMI74Laft
	 ozb+ict8a43+eebINViP9B3kMAW07ETFO5ZHLXHadO1lahIbHXOGI19Z7s4LhA0vVZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O+5ecGrL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.60
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD569606A321;
	Tue, 24 Nov 2026 05:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD569606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O+5ecGrL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QkcZ+NJxVs6s44rqZlOKbQhHAtOaKgGRlqRMwXCJEt3CIbCUKjMIYs4BSQFXDdg8hYSd9HzhQYeDSB9te2y7vptl4fXfcMrxV9mq9s51Vu2EUYL+OHyJJ3pfmGqginTyr8MiHxbSwEKhuR5twY6I+tE43P5cKDG4c8cru3KEV5cnjOI7zEaM4sJH2a0bDy/Yz7q9tH/gG5PJVKLjGVjPESnsIC92ccl7IiCxGoRRAVdSkrDHEl1iApFgOLNuMZvXD/DU9I3k/tXg2kXlv/YlqETWI6Q/naPbefCPfjDUGu+wRNws5zC1YQl/yyiMe4LFLHqH1GeesHgRnHwDTKcFXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnVF9/oyvYxcSrZqGwepuUYe09zzYIK9UbOsHmO0TQk=;
 b=EUP4zDAZzllC+5v6lDk8jtRE4ArvSuZomiFGvDqMs+yCbEuCmAHEosEhIxdoEzceyYzx0ebUgMtaFkI9gBsFdkypbeO/SAe6MsYsdH0v+9bjkT2mEqOxpTRikbtyx3pMl1k3mgov7t8CPYGcBVGo2gIOZ6sZUvynQyrAHsUaEhfVxuf7TTtW1l1e1OvQF2+9IkonZlxksxhH5msJWh/kGFYKdV/veRwN2vp+XDMZ3hz+bNs+XOR4WDiJP7Q7/xO/ctgVbPYZqKhMBDt+6Mue/BKDGlSD+DDdPnOscyETOcKt4lDSJbL7CP8V07Q36hA764ScSp6hJF2aehh8EvGdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnVF9/oyvYxcSrZqGwepuUYe09zzYIK9UbOsHmO0TQk=;
 b=O+5ecGrLarHROtBc8Q9j4xKsQCQaSjhDYqzYjr69SQhZQUWm8y5Ggu6dOkOSFrlH3vTKQvIxGnYiiFhuLjH0J+ZZE49WzYjCilGb/AFxxPy5hOtATiDXhfsAb2hEybJ5S6qKTtqPiSGFj/z2KaGE4CcJwACHW38xSprpODRM/0X5IicTIWLKeOeOoqNDY1/q8L3tWuEltw2ZOlYkcUU+AIHnnBQPBaVeB+gaDwDImk95yGbVZXNdV64mnKjliF5qcMv/uJWPZcDK9e/4rCZCBNsMyyADeF5HV1575QNSTS8yzP5o7aq9H6KtGYeDzrC0bJddvfAKPPWMn8QXJLopsw==
Received: from DM6PR05CA0041.namprd05.prod.outlook.com (2603:10b6:5:335::10)
 by DS5PPF5FAA0E762.namprd12.prod.outlook.com (2603:10b6:f:fc00::651) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 05:30:12 +0000
Received: from DS4PEPF000001C3.namprd21.prod.outlook.com
 (2603:10b6:5:335:cafe::77) by DM6PR05CA0041.outlook.office365.com
 (2603:10b6:5:335::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Tue, 24
 Nov 2026 05:30:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS4PEPF000001C3.mail.protection.outlook.com (10.167.23.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Tue, 24 Nov 2026 05:30:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Mon, 23 Nov
 2026 21:29:56 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Mon, 23 Nov
 2026 21:29:56 -0800
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57 via Frontend
 Transport; Mon, 23 Nov 2026 21:29:54 -0800
Date: Mon, 23 Nov 2026 21:29:52 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "John
 Garry" <john.garry@arm.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<patches@lists.linux.dev>, Pranjal Shrivastava <praan@google.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 05/13] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <awUg0O0WQUBcuUvC@nvidia.com>
References: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PEPF000001C3:EE_|DS5PPF5FAA0E762:EE_
X-MS-Office365-Filtering-Correlation-Id: 32ddf42d-090f-4d4b-6609-08df49ec02e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|23010399003|36860700016|22082099003|18002099003|56012099006|11063799006|5023799004|4143699003|261009223027099003|261102123227099003|261026121527099003|261022075727099003|261026140227099003|261022105027099003|261021123027099003|261021121427099003|261021135927099003|10067099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	PD5ISDiQoFLLHzo4KlbJM2dkHLBbcslIaKm48MSpYixmIqetL7p55bF6twea4j5sbZPvHMXK/G226Ff7E84ImKaIUUCLTB5wGdCRj9RrVuz2MyiGUzJWPCaeOBaccsHKG1pi0etOQw/E15DFblRPY9UYbWxZ8lQ7Rkhy7x6cCLdsbCNTO8uu6piskuhitgfs2k4bhI5hxt1eaMzY8zEon2g9z4rHK2R0vHkD2a15tF4YUulfveABsqsXttwTBcqLAagzpwv4lOzNgFgOsWun5jU5DIaSMz2HK7lyVoXl+bfanAMM7iG3zOcKIer9Q4CYe725jpI8yI9nE+neHFY85OI/XminoOYeI4s4HFPHbmwC8nnG4qSd2TEwBdgE8ubZHwP+WyYqAz9HTqXRT1t8Ofg8CIR40/24kXADhtCvNMwrXm6RTovrYcQ5wqTOhgCxbTIB/WE7C8+D9Ky/co/lUmJj4uFemo3Z/gSWwa87foO0heD1GSNeHJ+whXMjSn8wqyv1QCgMM1QM3Q0sNCQMSaMCKzrZ1BA5+q9D86dIyLB3124E1WS3dW1dJXQX6miDyiYCfeSLaQD10cN0LeD1az60b1mMrhAWMV7Jrmvqgf8oDhUEmUumiD+ZXWasM6wig9hQiX445zEjBLpG8K3zv6yA6c2MpGVcjmaKSQlsQ9LYqCphJjZoTZ/iDDL1TcXikRqFvw1lBn3NaKHVt7GIOQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(23010399003)(36860700016)(22082099003)(18002099003)(56012099006)(11063799006)(5023799004)(4143699003)(261009223027099003)(261102123227099003)(261026121527099003)(261022075727099003)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261021135927099003)(10067099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iD9fBs5Tqp5Q/r8KVxu+4mcWayhfpS74hqDIG5EXU3bM8N3Y5WLNQDQZXKPJBxZHUjQffR1Ouz/hR8UFuo2xZNW+XJeZqjY+Wyd0zt/QpegDIM2VX9wvgmvNfpKcnx6ChVsi4M2JMK0W5yWdEZNR3pbM94wdDEkysP0Gr5EcccBBLoGYrrYJPm3YsggJI19Bpc2WgpZB6aCcjkMLwXcURyPAo8yxnyz1SHs3hJV6Rfg0UJmIuztD71GwqjDk6t5Rc3L93nWoA1N587x6wAwg/NGncjtcSR4kbvqKKWF2mrwY0JVPCgRKf7quWa6UTbdqjDLyKdAqkLAk3Bx4NxrkDFMzUVoMFI2r9/4BYD6lmnyQnHdKguDSFwgnui0ZG/gUogWX1ENSt5SdwLzAFpx8fqgLRDTV8Ak6CNBLpbei73u5dVEnvNA0O+/Rc2FpHc+e
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 05:30:11.8074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ddf42d-090f-4d4b-6609-08df49ec02e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001C3.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5FAA0E762

On Sun, Nov 15, 2026 at 07:30:35PM -0400, Jason Gunthorpe wrote:
> Some of the tests configs can test features we don't currently enable,
> like TTBR1 on ARMv8. Instead of blowing up, skip the test. When
> CONFIG_DEBUG_GENERIC_PT is set all features are force enabled during
> the build so everything can be tested. That is the normal mode for the
> kunit.py runner.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/kunit_iommu.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
> index 79d7f9c8e7868f..558e161eacb05f 100644
> --- a/drivers/iommu/generic_pt/kunit_iommu.h
> +++ b/drivers/iommu/generic_pt/kunit_iommu.h
> @@ -134,6 +134,16 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
>  
>  #ifdef kunit_fmt_cfgs
>  	priv->cfg = kunit_fmt_cfgs[((uintptr_t)test->param_value) - 1];
> +	/*
> +	 * Without CONFIG_DEBUG_GENERIC_PT only the format's compiled-in
> +	 * PT_SUPPORTED_FEATURES are available, so cfgs requesting bits outside
> +	 * that set cannot be tested.
> +	 */
> +	if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
> +		kunit_skip(
> +			test,
> +			"cfg requires features not built into this format (enable CONFIG_DEBUG_GENERIC_PT)");

The patch looks fine.

But I tried iommu_pt_kunit_test on Grace with CONFIG_PAGE_SIZE_64KB
and got this assertion:

------------------------------------------------------------
 KTAP version 1
 1..6
     KTAP version 1
     # Subtest: amdv1_mock_iommu_test
     # module: kunit_iommu_mock
     1..7
         KTAP version 1
         # Subtest: test_increase_level
         ok 1 amdv1_mock_cfg_0
         ok 2 amdv1_mock_cfg_1 # SKIP max_vasz_lg2 fits in starting level, no growth possible
     # test_increase_level: pass:1 fail:0 skip:1 total:2
     ok 1 test_increase_level
         KTAP version 1
         # Subtest: test_map_simple
         ok 1 amdv1_mock_cfg_0
         ok 2 amdv1_mock_cfg_1
     # test_map_simple: pass:2 fail:0 skip:0 total:2
     ok 2 test_map_simple
         KTAP version 1
         # Subtest: test_map_table_to_oa
     # test_map_table_to_oa: Test should be marked slow (runtime: 4.997639265s)
     # test_map_table_to_oa: ASSERTION FAILED at drivers/iommu/generic_pt/fmt/../kunit_iommu_pt.h:473
                   Expected priv->orig_nr_secondary_pagetable == global_node_page_state(NR_SECONDARY_PAGETABLE), but
                       priv->orig_nr_secondary_pagetable == 157 (0x9d)
                       global_node_page_state(NR_SECONDARY_PAGETABLE) == 174 (0xae)
     # test_map_table_to_oa: test aborted during cleanup. continuing without cleaning up
 [...and all other tests continued but all failed...]
------------------------------------------------------------

I asked AI to fix the issue, and it came up with a patch (attached).
I wonder if it makes sense to you.

Nicolin

From c7e0332ce5c2854e4ff23ac7cb024ad837d11986 Mon Sep 17 00:00:00 2001
From: Nicolin Chen <nicolinc@nvidia.com>
Date: Tue, 24 Nov 2026 04:41:11 +0000
Subject: [PATCH] iommupt/kunit: Include per-CPU deltas in the leak check

The leak check reads NR_SECONDARY_PAGETABLE with global_node_page_state().
That only returns the global counter. Each CPU also keeps a small delta of
page updates that is folded into the global counter only after it exceeds
a threshold. So the value can be off by a few pages without any leak.

On an arm64 KVM guest with 64 KiB pages, test_map_simple frees every page
but still sees 5 extra pages. The assertion fails in the exit callback and
aborts the cleanup. Then the dummy device stays registered, and every later
test case fails to init with -EBUSY.

Add pt_kunit_nr_secondary_pagetable(). It adds the per-CPU deltas of every
node to the global counter. Use it for both the initial and the final read.
The result is still a best-effort snapshot, because a concurrent fold can
move a delta from a CPU to the global counter between the two reads.

Also change the assertion into an expectation. A mismatch still fails the
test case, but the exit callback now finishes its cleanup. So a mismatch no
longer breaks the test cases that run after it.

Fixes: bc5233c0904e ("iommupt: Add a kunit test for the IOMMU implementation")
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_iommu.h    |  2 +-
 drivers/iommu/generic_pt/kunit_iommu_pt.h | 29 +++++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
index 558e161eacb05..3c098be0d8f3f 100644
--- a/drivers/iommu/generic_pt/kunit_iommu.h
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -84,7 +84,7 @@ struct kunit_iommu_priv {
 	unsigned int largest_pgsz_lg2;
 	pt_oaddr_t test_oa;
 	pt_vaddr_t safe_pgsize_bitmap;
-	unsigned long orig_nr_secondary_pagetable;
+	long orig_nr_secondary_pagetable;
 
 };
 PT_IOMMU_CHECK_DOMAIN(struct kunit_iommu_priv, fmt_table.iommu, domain);
diff --git a/drivers/iommu/generic_pt/kunit_iommu_pt.h b/drivers/iommu/generic_pt/kunit_iommu_pt.h
index 9fc71db74234d..29b882dd5b0ed 100644
--- a/drivers/iommu/generic_pt/kunit_iommu_pt.h
+++ b/drivers/iommu/generic_pt/kunit_iommu_pt.h
@@ -438,6 +438,28 @@ static struct kunit_case iommu_test_cases[] = {
 	{},
 };
 
+/*
+ * global_node_page_state() only reads the global counter. Each CPU also keeps
+ * a small delta that might not be folded into the global counter yet. Add the
+ * deltas of every CPU on every node to get a closer count. This is still just
+ * a best-effort snapshot. A concurrent fold can move a delta between the reads.
+ */
+static long pt_kunit_nr_secondary_pagetable(void)
+{
+	const enum node_stat_item item = NR_SECONDARY_PAGETABLE;
+	long nr = atomic_long_read(&vm_node_stat[item]);
+	int nid, cpu;
+
+	for_each_online_node(nid) {
+		struct per_cpu_nodestat __percpu *stats =
+			NODE_DATA(nid)->per_cpu_nodestats;
+
+		for_each_online_cpu(cpu)
+			nr += per_cpu_ptr(stats, cpu)->vm_node_stat_diff[item];
+	}
+	return nr;
+}
+
 static int pt_kunit_iommu_init(struct kunit *test)
 {
 	struct kunit_iommu_priv *priv;
@@ -447,8 +469,7 @@ static int pt_kunit_iommu_init(struct kunit *test)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->orig_nr_secondary_pagetable =
-		global_node_page_state(NR_SECONDARY_PAGETABLE);
+	priv->orig_nr_secondary_pagetable = pt_kunit_nr_secondary_pagetable();
 	ret = pt_kunit_priv_init(test, priv);
 	if (ret) {
 		kunit_kfree(test, priv);
@@ -470,8 +491,8 @@ static void pt_kunit_iommu_exit(struct kunit *test)
 	 * Look for memory leaks, assumes kunit is running isolated and nothing
 	 * else is using secondary page tables.
 	 */
-	KUNIT_ASSERT_EQ(test, priv->orig_nr_secondary_pagetable,
-			global_node_page_state(NR_SECONDARY_PAGETABLE));
+	KUNIT_EXPECT_EQ(test, priv->orig_nr_secondary_pagetable,
+			pt_kunit_nr_secondary_pagetable());
 	kunit_kfree(test, test->priv);
 }
 
-- 
2.43.0
