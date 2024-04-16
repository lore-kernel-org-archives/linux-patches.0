Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C27137777;
	Tue, 16 Apr 2024 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295714; cv=fail; b=DLfqUV/YRuDtXDadA4bMnNZFVcKVcdlZc6wURif59qGrevR9CLWpYjgNkWgXbC1GOFiAvLyv31bytdseFLvFcSxZmL6rqN3HRQo4WubvMlF5AyXMmnlL2ZFIGVwJYoLdYiH1SDfcBTvBKocwg5Qrsy2mzlc9ugtzcmj3jV7QJ1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295714; c=relaxed/simple;
	bh=ansyd5w6L1qu7LTgCvDxz05aLLVEk3QQvn3Bfcg1+iU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jNvQARNl4CPxvcim+2bvFXCqyhZ7R6CvW/lYeYXUAjW8eO/t2mLepilYxYAmihvtvM9aUii1UcsgG9Ljgfgw+wTbKyLuNunuaHa0yU5Tw/cGTQsED4RqmdwmLljU6BT9DUBUNEWGZKNn/QTEirYdOPj9QtADAbJeyBO9/Mlfcw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TuZLkbGu; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TuZLkbGu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5xUR8h75crrl2YbfJCdNaDM1I3kvbBK5+rqDhUNAfHol8vOZDrnHl2InP3ogQEWZ0DMnOK69YaxCr7wqmcKHJEzaCBTZ1ryN7Oxiivb76Vtpjihjy4qGCLAui8SZJzxFBC7dIVB4lqZq4XcjpUk/tkEh0W8IULyYXZbzMJ/cY2SXJqSR7K7MC2TelgYG5onAxpEsWCBpiIaCWhi70qxaOhKKU3Du/NoDfO+YsX925Nr2R/N8CzE7fdJuU8YT6AYbw6OlziP2engUtG4WPaq2UKBt3Fw0Gw8aPvAA7ws+bFNOtL+hPCUniTuWFgATKY3Z77GNt93aAJk/Nd9lY1qRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mEQSyOTywOJaiqLujiFb/vpYuZFkIlCqvs2GEvFq/Q=;
 b=FBQkickwyWML3BJAALNrGOBFY/miJKvZoCqRoStEHKqDJT0a8pYTqk2Ubv+ba/dKJtmD58Ej7/nx4CaF0w58eIn4Qcx6DJWR0kbKCeiBEXRE2EkDycLbNp/RX+nqAfKjo0fN4SC6lvaU7wa7I6mLN5HzSM+QagA23LPFcEX9RmAgL2aMG3q7l9PeiBKo1Z0aF8WFqaLeAsuhlFSipg/RZ9tcfjuOpiBpeBClY/T6Z1MReNWMwJuUJnGiPC0S7JqmHQQHak3WlnCyDXchZOQmtffMIY54GJ9kOG/z5MXK8iJ8qiXv1rGJgGlHuFwbRjwH31crlBEYpSMCHvt2HkArJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mEQSyOTywOJaiqLujiFb/vpYuZFkIlCqvs2GEvFq/Q=;
 b=TuZLkbGuvMDF10bMal49dahN/rnI23FQBPh7KXq2ioUdV24ogne6R2RwQEbIfx1ZArwNwrUQMnNlnx/tcGO/rcaGdrAplaQ6fFsfb7O+IA2tQFnTzCu5eemZHKwlS1FEoJIqfvZU8GFHF9A2NPiodX7PE5aVD13+0vOynl5bJFZNsNjUxMThw5QJExuK/PcjSzoeYXquev5A0rbipB04+cP7QROo1B2yY2qSFOo7x5iLOTyYwFCHmugDWAihOKtztqgGEL3l4qI3RZNk9pZvcVP1nlb8uUAj3kbs2TqmHvSoHqRHspcsszYcYAPZIcRjm9odr1d0TgCXzeqPwIzw1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 0/9] Make the SMMUv3 CD logic match the new STE design (part 2a/3)
Date: Tue, 16 Apr 2024 16:28:11 -0300
Message-ID: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:806:120::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: f9bcac7c-c7ca-46a3-b29f-08dc5e4b607b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aCsvhk8+8vgjrBBWLl0wrZrFstDXImuC4uSkOWPYR+GQbV7ABd5rZhkRj+G2g41Q2Ff14CMuepRSSFn6fFnt+Pf7Dou/4dPM1OtFDD9e+ExQBwPWKMqmSlbvoKR7tZeroLTTJa9jJVZ8ZbRwOhnjTNBk9oeQupexX7Jg/VA6Yj07dD1lwWPWUfje6yASra0KAjHrVUQJZviym7Zxu4zH+t9dlBno/h+pnch0ViqdzXyohjzPfCNuYIXAV4LVf8RXY7z15HqoDE0RS/5OjBh+Bwl2r+pek3Q6F3GOniaedACNkumftc5WDmWTWVJiEP8esaaZBrUej/UY+iQ3orlSe1QrW2aZSljcKasCXBawgWj6znUC6YGHM65AZIlYwo9gwmng4119h85crs8NRfbpGWODk2aY6QEghHPVG9bH3D7AjJSboqnzCxrOly/HjhygGS98cnfSGOPnpqNzN6mk9SMovkBH01hgJEV9ldtSi9otHU9hSEvYO6DLW19g/V5myTa2+LcNhTeSaDxvRLhR2XHRiMzu/A3NCv5q2XTIjOgTmy2QEOcuRD7Rwwdw+HqFs1aJRm5pv3gRRa07dmFfh9Cqn2tc/zJoyRjhK0XN2CMMaQ4sg1gwxz6p69n6yJkjns1vtIu+yHaPCC42LJrTbCqbOdMS09ciS82rsIcH0cQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zjjyZ5cTvF+9RfTEX/3bgJFGTugyodyo7//ouOmsmDnHZufSPD3EG0avTnf5?=
 =?us-ascii?Q?97z/CeB8if1SbE6Rzf3UGl+9XkCIITMGgVdtl76KxfGZ+Q2G2VznMWN9omXK?=
 =?us-ascii?Q?eDteEiB2uFXZi1V7ZqAURfJklTRzGncc4bCV2lhpW0H29UC1DXTo8mqVUNXd?=
 =?us-ascii?Q?H/SB1av/n46fJtxhSrQP0vot6SSKe92uCVchbutSoqR+Z/x00mq1JyERTUrj?=
 =?us-ascii?Q?57t/gY+sCeQUGYnXsUl9wugOPmJ/q+oQ8z90h/a5C5qmy3yNDGVAlLmesGKz?=
 =?us-ascii?Q?J4wEj0avtGotkP0h8A/GUbHg8UQdDI6OTflBgGdbE4P1KoHI0aAuWObQ0mKX?=
 =?us-ascii?Q?1GBngsO3Ql7jHx57Wqnw+YtA9HSTfu9GEET7kDe1iTzP7ErJHHA0sDg7I38T?=
 =?us-ascii?Q?cCjIjk/e65W+/Qxm+sRilm0//efB4nPez3FaWhHFNdITZ6w1aC75y9KmGway?=
 =?us-ascii?Q?CabapY7W37GjqZd1NAK98kavbHM5v0VpycN5qeoQoMSGr3zTm2AI/wF+5hVM?=
 =?us-ascii?Q?f1G8fhoGaF131NVZ4R6i0FAU2aUqormcBmIdryHRHWOfndzzevG5ZXj9OT5Q?=
 =?us-ascii?Q?SUWMGit30MszldsTBzHZL2vvJyCfc2WAEkBRwO7aiw4o9rHG5JV+8Ea0h1mv?=
 =?us-ascii?Q?TNhDtuoHCn0H2Y1foVKZcHPF/PjDZs5Cgxx/jrydHq0xQZX1YLxUwcXco5DY?=
 =?us-ascii?Q?lC9j5wfI7jt5tIIMIbJ0H+SdE0eOYVgQ7JMw1ZTGVEaG3jM7KrD88fp3+5xg?=
 =?us-ascii?Q?tb+aIOGBlO+ecUg11UXWqrH671ZIEjIFdjyKDWOzXXwcMa/QSOuKW2DK2i8A?=
 =?us-ascii?Q?/xLNHZflCMeBXJ21krrKakik+/sUWHhlmBHQ7snbyayU2NMIahmokkOmJwKV?=
 =?us-ascii?Q?pyiAtFqBFs5FtnmI8CKAYddg2KNwD60ARYSV52a57JLDiYqfwSgN8XWGKdAu?=
 =?us-ascii?Q?NpKYnAks9z9Val2/Qj+ekQbErSmX/VjWkhePuPJ8rkr+UYZprYsX7DZrna3b?=
 =?us-ascii?Q?6V+J44ikdA99HrKufsjcpH8MG1RaRrMBDykSEhEiJWaTGcqRBsl0jmMdAgj1?=
 =?us-ascii?Q?VrNmcUQR+3Cb4ccqcf3HALrWB17LdQ7Ce8QC1BAsrwajdw2xTnlrdLJJwYjm?=
 =?us-ascii?Q?I3JrwVrr5lQ7BC9er7+VAfuUuMjf/ul9S/Ftxz3s4sWiaj1N64aFzrZGIYFH?=
 =?us-ascii?Q?LoVsayV1v8MZFIreE2Q/OP7K4z2AIbLcqTfqFMNtgwvVhkLbQ8pWJcQcaKLQ?=
 =?us-ascii?Q?tSPD6bHIduSXmAi7v+q4gatGjqFPBk2fXlcVQ0Z4s5NyN8HGGdUOFsGIUn8T?=
 =?us-ascii?Q?u2lb8Id24v+RjpHbSO9gagDvH6PE6VoCT17Qy9HbzQe6uZC4Wp0apmM9wXE0?=
 =?us-ascii?Q?6IhM5p9tWklpQdqRsOc2jriAkCPtFJSRp9gjLfuVfaZu2r9z+yrSezM/7p0m?=
 =?us-ascii?Q?05hRY0CsWUSNtV+GTItOcYF59Y0FsB01DAzhI1Vhw/X6F0ue50Gna4DTKBOw?=
 =?us-ascii?Q?6a62vElGb5OIF+XJdBfH+PPobnhWbxE2mLHOTjREL+z/+qLV/4iXBqo0EFxj?=
 =?us-ascii?Q?50JNzjNWa2tl0JlQD6A1dNzKPATvEdCLKSLRNWuw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9bcac7c-c7ca-46a3-b29f-08dc5e4b607b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:21.6081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdqzkVrvf/GoXoRHUWy1Z4Myg4ZNZeOD3r6Bvtzc22C+2Jui5UDsFGPZA2LzQJf0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

This is split out from the larger part two which aimes to rework the PASID
related code.

No new functionality is introduced in theses commits, it just reorganizes
the CD logic to follow the same design of the new STE logic using make
functions and a single programming flow without leaking details to
callers.

CD does not have as strong a need for this as STE, but all the code exists
and continuing with the same pattern makes for fewer things to understand
inside the driver.

The following PASID code makes use of this to rethread how the CD
programming works to take a caller created struct arm_smmu_cd and then
stick whatever that is into the live CD entry. This allows the actual
PASID and CD logic to be general and then the PAGING and SVA domain types
can sit on top of it.

There are four kinds of CDs:
 - Blocking (ie cleared)
 - S1 PAGING
 - SVA
 - SVA with a released MM (all fault)

The last two have to transition hitlessly.

v7:
 - Rebase on Will's for-next & v6.9-rc2
 - Split series in half
 - Include the kunit test
 - Update comments to refer to the STE & CD in the writer logic
v6: https://lore.kernel.org/r/0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com

Jason Gunthorpe (9):
  iommu/arm-smmu-v3: Add an ops indirection to the STE code
  iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
  iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
    function
  iommu/arm-smmu-v3: Consolidate clearing a CD table entry
  iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
  iommu/arm-smmu-v3: Allocate the CD table entry in advance
  iommu/arm-smmu-v3: Move the CD generation for SVA into a function
  iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
  iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry

 drivers/iommu/Kconfig                         |  12 +-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 163 ++++--
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 499 +++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  50 +-
 6 files changed, 896 insertions(+), 297 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c


base-commit: e8e4398d53f98be7ac48e0bda9ea6e26df24136d
-- 
2.43.2

