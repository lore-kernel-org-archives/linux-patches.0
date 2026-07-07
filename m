Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB08C1DDC33;
	Tue,  7 Jul 2026 03:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783396679; cv=fail; b=XvTX2e7ulLi1W9EUJKaKx4Vtbf2rNWQlyKVxg6oo7h6lH0ZvstrtnbmUo5rAWiNoWNB4aPZZ86nlP7mMbZvT0UW+G33Xrs3FIduvfMR/NNJdzn5nHnumOzdEweAZOV7hd/ng0mnGVlLilyLUzg8mLQN97GZcUA/s1X+T6wcazQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783396679; c=relaxed/simple;
	bh=ut7CL/27lEBKg8k2+k1/acDPoEIU+B4e29Tt55BzpjI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnEDKiad9bnN5CKNiIr9koHi7gjZkotOrBxInpWj96R8q8QpqBLFs7eSFeWlriUSv8UooQ5E4Wo8W9WswMi5hBy0EXOWg6vEcJmGYK3u9eXvenHGu0SQgEFTwquVVjp1ehqBCBR/fLtjvx0f7Ch7peI5qCr1nWciLRtcdJ93mF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BMeLA5Ao; arc=fail smtp.client-ip=40.107.208.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BMeLA5Ao"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWv+JnehQMKvaOXUhmVQDFsg65zTBZZLhW0Us1t2zjWH2JKInyEete6v498im8X6XebtVZEsntJdbW+JoBK/gpFrex/SE/MLPkwLqKDTao0MX25ji6XQS4rg8KrECgxZkQQmKxec2dTA1eUVw1iamRV90amxAESwyyfjutZ0d3l/qxUPbQ2hDqo4VAyb7vft4n8thzP5u8+pEfGf+iTk1+4B8gbZZ0hiSVslw9BcYd/wBWNpVQcbL+k5OMio9POUR7lWxIsgcnwVArkqDlOrvS7A94td5Wo8RWElR3HoClnaPt0ZqMI6gAZCxPgltpNCObLxb9giCYeQllvefdcw4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAVmvNaMaMOMFuPfky9DnUIS22PyUrMLlLy8qqlsuzs=;
 b=Mk0bboxVQ9tBWvzw6J0J7oNdmc47l9s+nWFqvLfII8UdD3EQsjQu9s4IgDJjEcFo2MKuCBA0D7tldO0PHaI0JFq+lME+49iTyAgFkkM3RL41Nz082bqkzpSlN0kChkgsqfbqm0KwDqOuvUoQz4wdPZ7/OAYyE/83i+xtUzr2bAQ423YhtVzeAKLCplkwch5Nq65krNm3mK53TnZQrIf54q/IGZiT0KGBhrHOQzRwpq7uF+2tD/qGTYog9cP/16GAjby65WJ3DS3mPs4a+pUNAcKb+QdI/KbR9bNg4nZDCAGQa8RUNOBG9wojlp7Nj6ULF9uiS3tGYuJGWeq7uwc/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAVmvNaMaMOMFuPfky9DnUIS22PyUrMLlLy8qqlsuzs=;
 b=BMeLA5AoPs689FvHynxmkAif1227N3AtWZ7xAG46BJfRdQB4dScO8H3wfJW/MIpfS1VxgNsH9aeQwaktWE4Dn7F+OECsIS3Q13V3mMuxgPCfmJTfmzZBQ0yYP1QqVlsp759OyXtjDsQ4Hczz52ycIW2Ng3/wxFJA8VBbeb1Rw1ebQQTh9IDkDWllsBasovm33vfBNCNmg+710P2hs/pKl3cMS9NdDXBiFzOCxurxtDqAKfHuO7TMxzwVkMWvRlCneniGpCEUZVHAHkf1CcwMvVJKITEicJUF7nwhwmndChfyfYSsp09+28MhvE3vyznh6w+dMLQDXi9V8l49SBH7NQ==
Received: from BN9PR03CA0893.namprd03.prod.outlook.com (2603:10b6:408:13c::28)
 by PH0PR12MB7789.namprd12.prod.outlook.com (2603:10b6:510:283::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 03:57:52 +0000
Received: from BN3PEPF0000B070.namprd21.prod.outlook.com
 (2603:10b6:408:13c:cafe::4) by BN9PR03CA0893.outlook.office365.com
 (2603:10b6:408:13c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.12 via Frontend Transport; Tue, 7
 Jul 2026 03:57:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B070.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.0 via Frontend Transport; Tue, 7 Jul 2026 03:57:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 6 Jul
 2026 20:57:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 6 Jul
 2026 20:57:23 -0700
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 6 Jul 2026 20:57:22 -0700
Date: Mon, 6 Jul 2026 20:57:22 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <akx5IvI6bi/OPuPe@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B070:EE_|PH0PR12MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f9ecf9-da01-4495-55c1-08dedbdbea9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|36860700016|7416014|18002099003|4143699003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Th0cuOKm44o4q317D7s4Y7dxL7Gptu4I9pMIqgOEc26ipI1xqAb+DOzwA159SStzEew9qV6/YzmN79Yuo0+AQaTz6Mdaz8+eHQVfjRUr3hrireO5myug65U9Vvj4HNS4cBd8JYZewOeqS+3QpBbveypEIOD13ROE/OPigUJ0pNfOGvUjCOiHyFBf7vNZ4K5+sI22x/wFk6CLyWUXP4aqMRuipMp1qJTfyIprgsKGUMshVi3+bjWdmevt3071XAuPW0/z/++TXE7YFO8hXoJwP6Pg+AIIZv7W1xUKMs/fyM73ZZ7obB4BPqL1BUt1V924Pw6qyRpwYt40YPq/PWcVOiwooG8CVyf2gyGixYel5uJXdONC1xEG99pFgvB2JGHcafEG152ov8b9NKBBN4UUmnVsYqv0utZvOu+kCPGhzdj4BHr3uKxsfJfKz6QOaAFV7iBJNfMn8XarTua1+7UzQkR7JDl+S/ExYz630eB8LP3C7O+uCaJ47CKtxtDgw8j/nkn0/o4SH4IhkqdyiTsXe93dIWSWjncaBckD0LEYgGb9ngMbjtdOFYfU3zaqVUpuz3JPdb+k9zyPSwyregUZYfKXhqhKbJ/smQ/8h84NUKPyWFOtJQy8TmIyK/8eFKTgJnIkWGk5DIlYuMsDhHX8ZkrlpmYR2m8l7zrFlgtjo9hZEdg7YN2VmmVYwkVD9fATP8hOUkdc08gpfz8UPZ8h7g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(7416014)(18002099003)(4143699003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4rpXOpmN2axa4GQE1ePQaorhyVB9ANK9+tivBAJOmDlz4l+kO9ZVJvtD1iO4+fMBIc7V4HcIPvOiUqYpQTixFALKexAYQQ0swjFphQcEVImhjgUgETmyeRHIBRl6AU31ntLxPrvssTdGltA+7FEvSsP+y1mvhhtg/tMf13YckYwmmOYW92XRUX4xZSSnNJRZulmkINzmEsl9BHxDBeQh4ScCyDhGTIR2yxKttgf+54xY9jlv1s/ixCmbR9a9ekOzLPyw1Wi6hDK9uwWvtIHsymSEAVQAV9O75Me+utLtcXwfVGXXoo3PrTwM0J+gzuQj5z3EVHRa5o8gfoUtIf7ooJhCuvYgrlF8TBPqlRKi/ZNWtEPLsYS4BsNKIQJEieAe1YV/m6glVnnG6l1IAyoH6QZhVLTP3f10dtRolF2WxFGi3deq5MC0cz/PANa8vOBX
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 03:57:51.1739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f9ecf9-da01-4495-55c1-08dedbdbea9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B070.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7789

On Mon, Jul 06, 2026 at 01:26:39PM -0300, Jason Gunthorpe wrote:
> pgsize is a constant property of the domain, it is the base translation
> granule of the page table (4k, 16k, 64k) in log2.
> 
> Store it to the struct arm_smmu_domain based on how the page table was created.

Checkpatch warns this for "> 75 chars".

> Add smmu_domain to the tlbi and just get tg from the domain.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index a364d847c22a92..2fc695817671fe 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -734,7 +734,6 @@ struct arm_smmu_inv {
>  	u8 nsize_opcode;
>  	u32 id; /* ASID or VMID or SID */
>  	union {
> -		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
>  		u32 ssid; /* INV_TYPE_ATS */
>  	};

So, union has only "ssid" now. Should we unwrap it?

Nicolin
