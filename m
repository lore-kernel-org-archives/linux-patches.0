Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAEB405F7;
	Tue,  7 Jul 2026 20:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783456346; cv=fail; b=MKDqUuiezKTAxMsOHVrAFfRF6S2tM3eAmCn0AC8plg8JdVt8SS6Eq4+TTX+/6YWNn1NSkhvPWITWNpHsFfRVfBQwrxGJmSSMf8wMtRQggrB/Cxx0noD/qaDB/CBYW70URGqgGB5VenXLmObeN9oCC+2+v+HWr+OjguLE8QjybkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783456346; c=relaxed/simple;
	bh=ogM41E9zrvTEct/uT401xz0Yu8Tl4gHF1pxmxGoXXlE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2PTKidWdsPGm3k/bNDOHdxuLryXU8OotlSrRFdSK1tYF1M2TrZ3k6POUzyAXKWsvHl8tLPwRbl+m5lE83uCsGWyKazObDexI1mTyE72PseqTknRRxrAtqbueBgBd9ArVTRPt0Jkwx2wHP4dnrJLyTcqtCINjw8BdAeXjFoQ4gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fdDMsEal; arc=fail smtp.client-ip=40.107.209.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fdDMsEal"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQH8BUGrYmRCF+QcyZixvjhPGrVIKUDDmt81FZoIBwop6Z8oCEFIEFn/avWox13A+x4K4EyK+hEbf05zOutOh5PxrhQMP19XU5yAerLLsKPMXGXkJV9EWGisCGN2COOl3M8v/UbSbuPShy/3fiFnKztAspkKK3bDKid5Aj2vvZ5oKrCrhxfP43EuTgonvHw23Uw6SAZkFRfCRuYRhWzxao+JPICNnbcpt9d5mjh2yhnskcHR28mUdI9MssIGniIHblqfy4fLC6nfQLoz9sY0GCYQ919H5kBL4/sWbUYxxB/XTjht/bJ8vAcSw27WWC6HlIYqr6v/JpRao2Y3dAEucA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H35h3WmMjNx5Te0fV3LGaX0YlCHWBQl/br6tE0lP+k8=;
 b=fF9XVIbXtMIwViVFe94vqh+bJjwyhsTMeLraoi9arR0SipCG/xWkYqYwk0GTnl5VjkyTBgV7EYXKgjkHVhhFQiJ2FJPq0LafpOyrsn+hU52lr49GrRh96XHpCjo1wxDdmeWwFYmh7GitkvyDQJQOZCK/UrQFBUH8qP3+gkz9bRIQsBX2UG67K3cSaObDxciNCRHPo+A9vsRAKFF+nyiqFBPgT1bUalZQuwORiKHbFCDBO58mKHvahqo/G+oXGYbwKaKguXp+NfHHQBMNkRySxsHTrdaZIOjaQXHT1tcWkjcEh4J9RV7nqBeH7yCeS4UnlIBdY2QRmK4/brMYErjDfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H35h3WmMjNx5Te0fV3LGaX0YlCHWBQl/br6tE0lP+k8=;
 b=fdDMsEalD6Tfvw7LPA8McSzW3JTKOte1oWbwswv31NJeiYKxJDHvH2Zy6+cBM+Dr0jO7JQ+Jes/cMucQ+9IKDrPZV/kEmsDQYC9nK599pOO3HFDeTuNoS3HIhNDeturOHIsApGEcLc6uZLKSdXJmMO3pt1F7/xFGS4N2Jg8yAhv8B2FR+3HjjQ64MoJDObnihTaa56/I9XqJFIHpUceUMeVQmh6vkus8lcMAOZ6PAOL96P6/98X/dswLiTfwsuJw3a/rW0nsNnPImVpPezZUAzY9dD9nCSXHUCJbC7fvqv1VODTD5PioXoF8eMvciUsI64v6c4+mJYlMN7mZcNR2+w==
Received: from CH0PR03CA0202.namprd03.prod.outlook.com (2603:10b6:610:e4::27)
 by DS5PPFA33D606F8.namprd12.prod.outlook.com (2603:10b6:f:fc00::65b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Tue, 7 Jul
 2026 20:32:17 +0000
Received: from CH1PEPF0000A347.namprd04.prod.outlook.com
 (2603:10b6:610:e4:cafe::79) by CH0PR03CA0202.outlook.office365.com
 (2603:10b6:610:e4::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.9 via Frontend
 Transport; Tue, 7 Jul 2026 20:32:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000A347.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 20:32:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 13:31:56 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 7 Jul 2026 13:31:55 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 13:31:55 -0700
Date: Tue, 7 Jul 2026 13:31:53 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <ak1iOWrvLv/6ACsP@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A347:EE_|DS5PPFA33D606F8:EE_
X-MS-Office365-Filtering-Correlation-Id: f9578ac3-5f1a-46b6-a5c3-08dedc66d5e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|23010399003|36860700016|4143699003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	e7pVy34+sQr35pqc3uyNaD8AaJzdJsHV6VGxpqJcG5F/FlOkoRtGXBvYyzs7XWBys+pM68WaUyas39rr9CJaPTLlWwPf4Zw9T3no+46b0d8eM26BLZwHEAYI6ppa7+DFrzisWfarXTxKwcUlFddUaAX4Dfn2sCCjIjhwDB6TxKe4ZL/1p3GjfEakgG9FQZnOlJEcWuxTteYDzFvN/XAz7iNB8g1m3zHjMiJGrhd1Fwr8BLKUdZDRZj8bp9Qny6BqhGgea7iGimvCLSKfYRgNjKg9nDc8wdU6Xzb89E6zBUWiBgN6tfPq9bWvmWdI6p6n5B4+w+RBlS0cDd6JB9kTYl/lfqJN9YQ/dtW9SYZnHV8b2LVfpjGDg/fJUQr9sCUKwylOliJlryHRdI+05IEy7KHWrQkDAVTb8zSDbLjIegSseNZ5kGj99Hebw/zoxKm4PNiFoSRod7A76MT+To8Lzgrisb3yiPZBfQGT2MfnEKih/6xpChVLNAhjHuK9Ql5qGl+PIa7CyAFgruS8oa9wvExqSiRQqDe/r60naksqlP0YaDNgMlW5hl1b9K3ldlqbz3ioVCL/8kKGtc8spi9BK0ZmI1gRK4v2tYDs00wHAfgimT+hKSsAsTJQp+QaPNTARZ6lQa/6ms54zyHEjqUYXcDmaZkwRADEs7PLMEhF2StWZkkIzPWE4sZ5pCrB3DssrFIkoAcs9elKxt+9XWPHQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(23010399003)(36860700016)(4143699003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I7EG3n12OcR3txj+9h6jmPBSMtr2Pg0I77HlImvyNNy3hXPkmfB3d+h4NSjE1YHFrLV2ThIa8NzQYCQ1AVKvzNQmwLzx24VYJ3sVOe9IbBdjzpdCbk+LoItz7KFrJNKANmXndk0su36jH6ZzKie10JHHpv4LNOxd6/MBPsfmPAq4d4dy5zkDso8uEu6FnYRnWtx/5nQLdKwFt229ALYLCnJWMInHiFUEY7EH/UBIklOILUUSA2XAp9utm2yT5oSoqSenfpOWRqr/RTJ88g4LLauNgz/XdXqH78XoC7nc2J0I1/EzPXoavi+odEhtD7gNRzXCf+BJIyGlmDDjoFuOotpg8X5G2+n21CgiA1GBaESZkl86RfO3IPxmmPj3T5WwdfSSDd9kJQP9nG35EFjcrRK8a8QGrY2KhCB5rd4EaNRKNChV5KK/HtKGLsKJdbvD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 20:32:16.5197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9578ac3-5f1a-46b6-a5c3-08dedc66d5e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A347.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFA33D606F8

On Mon, Jul 06, 2026 at 01:26:42PM -0300, Jason Gunthorpe wrote:
> @@ -2471,10 +2451,13 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  	if (num_tg == 1) {
>  		if (!ttl)
>  			ttl = 3;
> -		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
> -					    cur_tg << tg_lg2, 0, 0, ttl,
> -					    tg_enc);
> -		return true;
> +		tlbi->range.data0 = 0;
> +		tlbi->range.data1 =
> +			FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
> +			FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
> +			FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
> +			(cur_tg << tg_lg2);
> +		return;
>  	}
[...]
> +	tlbi->range.data0 =
> +		FIELD_PREP(CMDQ_TLBI_0_NUM,
> +			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
> +		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
> +	tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
> +			    FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
> +			    FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
> +			    (cur_tg << tg_lg2);

Could this be slightly cleaner:

	unsigned int num = 0, scale = 0;
	...
	if (num_tg == 1) {
		if (!ttl)
			ttl = 3;
		goto build;
	}

	scale = fls64((num_tg - 1) / 32);
	num = DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1;
build:
	tlbi->range.data0 = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
			    FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
	tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
			    FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
			    FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
			    (cur_tg << tg_lg2);

?

> @@ -2711,6 +2711,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  	rcu_read_lock();
>  	invs = rcu_dereference(smmu_domain->invs);
>  
> +	/* Only precaculate RIL if it will be used. */

precalculate

> +	if (invs->has_range_inv) {
> +		if (!tlbi.range.use_full_inv)
> +			arm_smmu_tlbi_calc_range(&tlbi);
> +	} else {
> +		tlbi.range.use_full_inv = true;

I am a bit unsure about this line since invs has no RIL entry.

Is it set for a defensive reason?

Nicolin
