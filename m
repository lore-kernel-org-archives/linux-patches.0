Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011027.outbound.protection.outlook.com [40.93.194.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113E25C804;
	Wed, 15 Jul 2026 01:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784079985; cv=fail; b=rMjPdd/uZQcVMKgIiPjMmzOhnui9aHW/Ttg+/TikT8zECXUSqwEYbCX0iEurA5sQkks1BZ7DxLfGs6gIWlotvjv8GdSVC3OsDmXFCu10MD44RUO+35/feUaN9lP9k2mw56NvTnlijVnxXcq7RNE7Bwerjx40dtIaFy0J3Q5A24U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784079985; c=relaxed/simple;
	bh=Hw7oTlcvp4lFe4Er19lVGxfzJaTlNWChPwjbqvWNFV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6A9mkFtWJ6sgMj9/rQ/3Ca2qnxonewOYpEf2M7eABv6fJ2eVTlUj+H1bJEI6Vxa6X8NKL6FVzDjwBfoxkOTjoFdM5JFIl9Ni9u8AppvOihKAE0nky0sDVQYNSYEysM01PGq0Hkce22EOFfjYvwHMx4GGQMLRXg30RWv+fCTb2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fRNTrVg8; arc=fail smtp.client-ip=40.93.194.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fRNTrVg8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZt+/P412BrA8rTZnhGmZkZmWYh6QPfhtIcy8ssO/lc/ix1+3CZrobPfGpAtanl3OB0ZqwQ4e6eveTTQqeI6zZWKQxRKhkLOL39806SKh2/5gR5/iv5Gi3zzMYgLS5eiHQDJhlS9w76SqxbTt+TLWe4O+qMTCDWaYUOrvqaWRP+Si7xbHBAkvM8isANY2KEFqoeTGCPnuiHq1NXbN6AacvRBKDwSrzhXvvjTSJEm8KH4IeTnmVI3gNdXcH8kVS1nNo81Z97Tyr6Gf60R7EX+9wVfknAqKEPHrayImQQrUKs/0htDQ3FPrSVRxCvHI0EK/QDyc4v0QDhyEiywuodZ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCM25cjChpjo/FAIky7LMDEbrbb9mo2wNb0RjmElhUM=;
 b=LQpldJJWe3bcEC7tx3kWk8wiY7UyRb6mY2eolEx0mr6rUyERfx4Nlpm9rf/29DZslBUcwQuMEow8rZxRxa+AaJBb2u+DZXkKoQr8R1HQOFWcZh50kfm+XBNEMEFQeGV63R+OI/xF0aUBa7ssahA81u1m8SFdXmGmxzEwz0zokZ9F3R+5OkFTpCc8Lpp2sTb1rs/kQ5FlTy1BMcRdFC7jgT+i3G/ZDVMb4ubeenGKWN3kMeOf4HIl4AWZLDNaq1Fj8coc3aBHvbATjdny4nL4OR4IyJlOECgmehoRk6RrNCUljH34wEUyanxEb9zdftuKzCaPvnt4wjIJ5So3c8Tq+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCM25cjChpjo/FAIky7LMDEbrbb9mo2wNb0RjmElhUM=;
 b=fRNTrVg8FGX9wmmd905r8Oy8gbr7x5/z+JJIJxsnJnxKEZRaZnp99a6/j9t5f2ZpElwmCFMMQVt0fj/6UGvWWbgjiHZzComLougA1CHo+MEPaO6W0GacY8Jv5KvuOr6G5x2MwMasq3Tq6ZEALxoxyMEnrBVFco97y6v8kpoHmYUOxyeceESqOItCxRGRulQbSngNS6PqptJ2fUNz/WX1SpnFjBJxHBINH1m+w71q4qHxlAOj+/2m7va7zrf2ZpQEfxHcowTHo05BBuKS9EzAzY7a6xyTXDApRLGcn+O8aB3fXfM8TwTmtPbelMA6v6kpd9r+yeZKJObCpGzg3QjVew==
Received: from MN2PR03CA0001.namprd03.prod.outlook.com (2603:10b6:208:23a::6)
 by CYYPR12MB8752.namprd12.prod.outlook.com (2603:10b6:930:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 01:46:18 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:208:23a:cafe::87) by MN2PR03CA0001.outlook.office365.com
 (2603:10b6:208:23a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Wed,
 15 Jul 2026 01:46:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Wed, 15 Jul 2026 01:46:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Jul
 2026 18:45:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 14 Jul 2026 18:45:58 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Jul 2026 18:45:56 -0700
Date: Tue, 14 Jul 2026 18:45:55 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 0/8] Organize the SMMUv3 invalidation flow so iommupt
 can use it
Message-ID: <albmU+R52NGo4nRu@nvidia.com>
References: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|CYYPR12MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c0ff5c-5f16-4250-49ef-08dee212dd47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|36860700016|82310400026|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6rwX1v03M15F6uXYWu4J5tVHZBzLDn9yXtHzXca+B+pNjKdQIWyG0ajNGJHE7LCwKxAd3fJdyhGZcPVwCNoUumdhKF9qcUCje8AYoIVQ5V6pCKjd0+xJXO9WVSNhRae/no2NjXvA9q6xGt8R4s8837zL1hXLNKH3Pijn1ALRRj1Bxjhmtq4va4oWxxm9A/vwUB0IpoW/+DhFLbNKmrAoa5OD/q9CTRuSiZs7Fd907UwpN5uNtSotCp58mwyzbLC3RCt6O9sNnJpI5v1rOJj8Dglfzg0sGzcRXQIltDk6X2uoZIvN3keUUKOCawoo8/VFZ03K59qv5ZWwrd93Sj3L95acokp6wSdmjr+vm/G0gSNATe9oFzEp6SOSd8dCUpgWxYpzquwglQ08I+17MnD+5bTvajuZ+LtQmBF7/Vis6cCi1mhh6p+BSxRCWeq7cnbLPd9bTOPEJqUnPNz8wMSIBslguS2YXokDV95GKkMU7BGRxqx+cdvTnqcpil6RNU3OXJ4PKNFZx2mgYowwQVgQMEs595Mh692GN+Dr3lMy7RYnht9pxaJhpWXnCsL8n2De3YDC90CFvYzOhGHvKzqy9P3/VbUHdiHimPIWezUivSBAi8DpJ+qO47VQnWGQ/vTnVITyvHGh1rou/jubqKGJCAg6uI9T56dxCas9yxYmw4971E90gr4RHf0GFr53gC/3lK5Scw/jcVt5YpUlM4pGFg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(36860700016)(82310400026)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sq0UN8HnnsLPpExa0yOAUnOmXwCzsrNdydc92CdG5a50NoIxNzJvIB9RxB9xVYnmqIsAu39NOGOaAUb9RZPF3duOVTbxaqfgHAHS4A7hMbN7KFHfEl71EoI20Y7/sfKd4W3cqRG/Ldnvh7DL5g33dw+P5no0289lwGdmhctkWCbqQOGLsT/5+559NfDS6GXzS+daUiJ63AETPj7YD6E+ExJvCYeKYOgbtO6N6ovu/qNCGNj7e2HxT3f7HMIqvBS09jivgJ3zoEspqifW0jB3EXD9gnj17oyWtT5XiLbgL3isltiLRFGJdCJHdZIKOei3nmcL/r9xevkv7g8AoQC3FFx/CoHIMVmCNWfUnXXlOkQnlg4NeDJPrzpPUwTfLYJUhwEIFeLjOFXyD96dmxDUaQdANNjSHIk9FBmt7TOCVMYsNYI1N1zlf0te0dmMxroK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 01:46:18.1089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c0ff5c-5f16-4250-49ef-08dee212dd47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8752

On Tue, Jul 14, 2026 at 03:46:00PM -0300, Jason Gunthorpe wrote:
> v3:
>  - Carry the base translation granule in the TLBI description and pass the
>    domain separately
>  - Invalidate the leaves when doing a table invalidation too, corrects a
>    missed invalidation but means we don't do anything about the duplicate
>    invalidations.
>  - Simplify the control flow in a few places
>  - Clarify the TTL derivation and accomodate DS

I tested this series alone for sanity. S1, S2, SVA invalidations
all work fine.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
