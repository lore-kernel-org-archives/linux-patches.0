Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795478678;
	b=mp3HbmYBT1l8bYo2snR7d5B27JfxrmiqWmdSKEhwQM6yBS8L9kWms2Y7bpmaMe+gd+Yc
	 5YSfig27ONjQmMshVsC2RB710/bpwSgIyKEzGN0JT5AKmJcFuB5NClbHa/TgYtvBC9TqW
	 FH0P5PmLN9SHph1w7gtItd8dAtSGdc0mru7Qd9kgEB7o50qJiFmVnSXpF7OukhEghGvhr
	 PVW5X2U1qGrLY2z6zN94CVpOnmogk1UyqQfQA12w8Xj5LLa2fUnjSluxGEc5ID0lrm9Pa
	 fbpNqsAQ2NkRV83mUEI5LJJWETKp+rTLAsOhdDHNRHpclZyueeXj1RygeaUXTTf6UsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478678;
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
	bh=OTOen+uE2NvCSz2hn8cSwaaEY4y+LIf4EpnICteK+Ns=;
	b=o1ImEPLcNa6Jpb8p7P18u9Sb1htxKnFUHziHPYfYU+OHvvl78EyNaG01bioaAVwYquyK
	 pfx5TBHJHSoAgFi89OKb6aSuxMVyQA8DFdGTJlMa12tHdIwLHzHxcLqgCyG6jiOI5cNzg
	 l1IF9zifinXxa9YBA7nx4cEuT1SXtgUKntQNF957N5IJlG9rPDN07OecsD9f9UEvA1Sth
	 KYPB9QjzrzRinbZqNDbGx6/r7U+CqmzPAKaks2EzlzVqKJdNtLoLMEck9pENxMCaIqbAl
	 /ic6dT35PhD2KmTgABOkwxTuTbt7d8upNk/pnTE2sjzJ3HaBJ9moPe7P0MJtW2TcaHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tXeP80Nu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.29
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010029.outbound.protection.outlook.com [40.93.198.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D271606A68F;
	Tue, 24 Nov 2026 00:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D271606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tXeP80Nu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/IMW4FHrug8JuP3q05faBkK2mgTm9e1i9kfo4fzc/3zJKZcJifY+zUTjwZW6RlobXGdtLQ6N9LYrZi1uc9OqE3Z7Z3SEvXR2jQLQ4s2FXHB+1kZL0SZNQg32eKatlDOg3RM4AK+VHKWG8zJ45GRisrP45PJ9AMLY6rs7WrlNamQigiDPlD1zwvvMlFF8JoiX6QNl4RNckAFZQqn6AcUPueUe5McPui0BIDakscxddxzenlHuV71OrWBzpnRxgZ22to7OKc3d5fuRDfGowccLC7+7T/BdOgPTOkVNCDTEtHKwrINYldy0kePIfs3FlFp8IEE5aRwvXRTddZNaiQBaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTOen+uE2NvCSz2hn8cSwaaEY4y+LIf4EpnICteK+Ns=;
 b=bv1zZ6OaskU4keewdhLugXwZ7AeegLib56ymp6C7av9Pm3nwpcMa9BvUv+1mOA2pr5LlOIOSljIbrBbt4cnaoxBrCwDxj0bUmjNpAe+HjOOC/SIpopN0gfU0f7dQ1R7JA+l53cYxxgMM4tN5xYQXsSYPlFZ/JzMlLDAeqn+S4RFw8FG6/qUP/jQrytXCBC7/kLWBS2UUS+y2TvaqzS1HD3ROoLFt+V8pE+mCOU6R7iPZymeytEGCaBv2Smb5cMT0IsUuEhv2jgNgoNtSdfVfpLJAcYntwiVXFwq6Jl5a//81Mc16yXK+M3bpCjk1zbiJhhBlldcLvhwf88QDweDKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTOen+uE2NvCSz2hn8cSwaaEY4y+LIf4EpnICteK+Ns=;
 b=tXeP80NusvB1Q8vFccOgHA79C1lrPANnNAnUS1FsT99pZX9/UlOz9YAcHm8PCyfOf9jHtrZyCKnsFJudODBkMW/cVcZOtroI77faBgn/q4VukwyPXETPkphRHf8l2QsEGKsRxacOZWFuw9aQrnfCwjKHnwwiBhrQro1DLUKaNXHQzV1K2P59xlptTTC5+2Qmcqcu5/R7xC1JksmV9m4YiFTPClPrhFhMVwW3BJntiPl6G7xeq+lNhA2JVwbTz08RTLAgTZlgtD1POM+uTjs/5e4IeNYJeSsHW1o/1yva08I5ah7/Lg7UILX7oHzBmYnYKbX3zcIbRt1zvQHK3fbaRQ==
Received: from BLAPR03CA0047.namprd03.prod.outlook.com (2603:10b6:208:32d::22)
 by SA0PR12MB4462.namprd12.prod.outlook.com (2603:10b6:806:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 00:04:33 +0000
Received: from MN7PEPF0000014C.namprd04.prod.outlook.com
 (2603:10b6:208:32d:cafe::8e) by BLAPR03CA0047.outlook.office365.com
 (2603:10b6:208:32d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 24 Nov 2026 00:04:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MN7PEPF0000014C.mail.protection.outlook.com (10.167.254.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Tue, 24 Nov 2026 00:04:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Mon, 23 Nov
 2026 16:04:18 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 23 Nov 2026 16:04:18 -0800
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57 via Frontend
 Transport; Mon, 23 Nov 2026 16:04:17 -0800
Date: Mon, 23 Nov 2026 16:04:15 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "John
 Garry" <john.garry@arm.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<patches@lists.linux.dev>, Pranjal Shrivastava <praan@google.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 00/13] Use the generic iommu page table for SMMUv3
Message-ID: <awTUf0ShS7NWKYEV@nvidia.com>
References: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
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
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014C:EE_|SA0PR12MB4462:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eb6915f-dd04-4ec7-4634-08df49be84f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|18002099003|22082099003|261009223027099003|261021135927099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	rcAMEBKc7HJpFqQD7HudP/Q+X8mraxptlLvT2Bre7s2XrbWsNQCWCqMHaAsm+Ir7IOdhX1hdxBIFYlDhIjVETeyGovCVM5BRMsHSCIBG1ZtvBEZjkckxY62I4hJILVdAQ83fR8MlzVvizr4UycGuv9q4t6nxNqP1/WiIosSqgcMOKgOKq6lDrxrWwbOxkAbZzL8//qMXLWKG1XLQOi+1gf3kpP+krv0q8in4rBNyxMLAOlbzQRm6IiXFTyL8jkDom/VzHVoOov1B66AL9+oNXctVtZLXTSBNWj6NiuFj5vsxsdwv5HLSx7km7XOVrvKYvnDdxb+kDzAFrDv3CFxw6C5xSFNN1ikvar9bpG+bjQKvlYW1RBfhNMKEEc7MbW+FEq40Pn6Rr0PH5G9sNomjVeeNEXiwI+JOBRw+nMc1KqbzufEkH9FghTQiiAqO6NafdjUCjMsBtTYkapUJMBkQZTar8416z+xuJTcv76sKPiJ3kgoReDVaD0sbiiGSz7xRH6xZtgsrZvfwKdjfrxuKqQcOBxwrCn2sAdzz6gSbLKCmEs61PSPmiQCSZ8WDh+9iypx7wNymA52Pzyy0ZWXgBTQhFj+DjkP7NXdH/yNektyNs8j0z0E4sfFB50ofBRrofavf9u3pu8OdgulMKxHMAouOsl2zSrbIyUS2n4vmkSCP2hbJq9H4iHiHGwkCtLx+GQf3cPz8NPkmLhjT0mM5/w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(18002099003)(22082099003)(261009223027099003)(261021135927099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SayQUmGq/HGTGNWwaUlvbehBmxeHmHsukp/fxmtGwbiPw4zPwVurl+yWV22AUOcf3XvlD7zRWhIdy6aumVBoZlhoklL8G1Py9Jteqy4fvlgA3j3tLLgEESAqZ6wzdP+g3NDmg/s3Tt4M6wx9fyqJaYA4Z3JDNAfUvtKlBo45n4RnmfCACzE7w1dY+iryhmvABu83Ibx4740UgWgQY+mYCGj4b/PuQVcym+o3Lin1GbahZj8N8XbtNcVD5SQvvyLYKRDIjf370PzeoLjzbHGxmfWYjIxFylqOLS6zDfTeTkutk7+7L9JYCe9O+veYNniQShzg/S3+kPz0mcdrffR95sRc2enEwO/G0H1rFOM1XQaLsrzPsLsuhobnY9quyhubglY8VyHTDhVxlURGlGlR3cTB1i6Pdr+fJxrQ7gcVQ8chbdVcnn+zTyRqbX9zUeZ0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:04:33.1709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb6915f-dd04-4ec7-4634-08df49be84f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4462

On Sun, Nov 15, 2026 at 07:30:30PM -0400, Jason Gunthorpe wrote:
> v3:
>  - Rebase on v7.4-rc2
>  - Split the armv8 patch into three parts, generic, db, and iommu
>  - Clarify some comments, mark some more debug things as WARN_ON
>  - Use tgsz instead of granule for consistency
>  - Refactor checks into armv8pt_validate_features() and add more
>  - Drop PT_FEAT_ARMV8_AARCH32
>  - Fix make dirty logic
>  - Use arch/arm64 constants instead of copying for SVA
>  - Mitigate the CONT under invalidation errata
>  - Pull in the left over two patches from v9 of the precursor series:
>      https://patch.msgid.link/r/0-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com

I've verified v3 with S1/S2/SVA sanity.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
