Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECC422550;
	Tue,  7 Jul 2026 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783461102; cv=fail; b=tgE8o4dahoIp/zd3jtmhN/NYO0t1ye2zSDJqVm8RRqTeDJTJM+Bs23vvEeIZLahMpjqLPEQh0UaZwjyIIbwbtkeQ7B6toHyam82TaQZDFVH0gnqwIPonPGYkI7qy9I5jgRy8JY+cb0l9gBNmN3MWVpyT9NKQKg1uRjwB/M/Xq/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783461102; c=relaxed/simple;
	bh=eMwJEFKfC61DNBwGyzkAoCHE+u84wVjUdX5VtcsffA4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2KEb4jE9TWi2rn4WwCU5YKD+v+wx+mqAi8Plq4jGmPQ5j4oVU+XBGUXONKj7S/EPXr90/ShklCrogWm4KoXP+JKD7Ja9P9+r5FaHusrUesjpnuQPXfZ8wpSMM7Pwl1k8CteWN9YH+hzyb0NuUGi36BqhsEtRpGrOs1y6npIdgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q+9itPAF; arc=fail smtp.client-ip=52.101.48.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q+9itPAF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUCUZrX74II8rc7NdRxUJ69KDV4HdN5LXjvdOsosXYnZvCPAFUV58KDh9LGGqK9UNJKYyl0u4IHTr9kNKT9BjS/ZHK2Kw3CZWH2l2wPQZOuVFXWRaK7zU7KfUCDh3v5+ZQkiGMeImrRlVLqjGY7aOTvSZ1zY19P/lBeNhr6szV82aDQkROaTqEwPuj6ErCVk3ije1CZXK6AjU6TnAc3eTLC4mw/erJdK8zY9+GZaG/EV5Z//TvHI3eXmVh5x3a3f2zoGu5GUXLFEw9bs06eObuo6WZV7q4dsBciI8kzxyPhAl6T6VXSI9iPJQMujq7IN3V/hvvHrp7FiCbRb6VB32A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4Nr0vWXqyBnyiCIvBQ2G9NfFj7ignJ42iChTICfMuE=;
 b=gZ3+cCzP7pFqiZbPl0IzC7HpOPRpjVHrhQdF9GJaiakWOqh33McxLQNkvWLV8C7tnQynE0aJs2Wyotw9XansHP3yy/0qVlVr5UruuaemYTy8mdwCXnNXtDFB6sjy8w2PzwgsZlxEIU/7wEimSf4r2Aqua6Bi8hZVrZvjb2QIiwODcTkcgKhW78v1AyRFpAbTOQDTfPlzY+QCrWlE5PSVaOFH/MVb5P2I7JiuBqGI6nztN+GwVIszBQHkL1t7UKBRCbvenwm4FL7F1RjgOeiZeuBSjdC+CHl9dQB2rj8EfZidQ/nlEIf8v8hB25hJHdqlfbvcVVbhlMwfOu6HS2M3Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4Nr0vWXqyBnyiCIvBQ2G9NfFj7ignJ42iChTICfMuE=;
 b=Q+9itPAFSdQw5OUCU3s2UKOlow/rw0s+YR3uAVKcVXDDDncAeDi1CcsQqdTpV9TXzJPcu347g0An22WMjSKAB9ZiBw5u3AVMUDCnyzmLDKrUaBIEQKKlYncWRDrUARE4IeJAVIIK+GD2NShmZDYw1/sIysjd9WicDhOSON4Er3oKqKKmcev4i6kk+cbzkWD1RsevTXmym26I++vOWln+Yp3+fi7M0MhuS6/O/RgBPForC4F3zdfvC+DzrX54IssUzJHmpISf/YjNaQWy+MQO2wg0N/xwgPe1pfrDygXTRZv1UosKS5FhqE/Sv15arOWN8lE2/QnEuOQ6quLeLN62DQ==
Received: from DS7PR03CA0065.namprd03.prod.outlook.com (2603:10b6:5:3bb::10)
 by DM4PR12MB6110.namprd12.prod.outlook.com (2603:10b6:8:ad::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Tue, 7 Jul 2026 21:51:33 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::60) by DS7PR03CA0065.outlook.office365.com
 (2603:10b6:5:3bb::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 7
 Jul 2026 21:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 21:51:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:51:17 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 7 Jul 2026 14:51:15 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 14:51:15 -0700
Date: Tue, 7 Jul 2026 14:51:14 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <ak100gBEybGVrMZ6@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|DM4PR12MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: 802f3041-709d-4736-97d3-08dedc71e92c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|7416014|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Edq6bNDCDuprShpwDEoi54Oh5z8tvvRRtH0iJmqcQ1QrfVqg/TpESp3HKKNCZtFa7X1M2113fqgL4TiDcbBorLeHA6V34BIshSrNdrl1DaL8Fi27cfLDkPHWlSzkxz2jWttwMGUIF5iGUQYrleQkCGt4OakcMqQPSXeD6ZSb2EW48MfohgO7cTBZrglT0LMcTtMA7nN+TCC2IOMUAykBbsZSsb8W0ptZ/Q8IdYdE5cY9ijnQoxRzMOYUEUVYEBxuOI+1DtXpYEysv7/Z/nBVjUQxEHDquAAuVCaPnxNSkytk2p8NM0HFUapPeNXrQJnQ/OaYBkdmbtdnmbyJjAqIABhSzljw95KYEOimISUDTkFhl6rIWGM2JgqTfW4KFMwPtURv/yYnGc3h7pLkuHdwtvfQR6z0LGLOJiPwcSXxqEq8F0mONOwLXoK8jgYKDWRvzxNNeDPdfyBfUAqNHv/bLFb+rIHLzVi0C6OGPWIl0PDAr/t/sxbCDtP7Ao9HvYTVTVj2FPYPHfLWwmcZwVPfjDo85EPR99LE03Rx1sBjMITQQTzm48SEHtBjzIupTQGV1ovRSmYpH/RnidinUa6S0v30EXrUz8lvlObZk7RWgCCl9UJzPznV8ikN4IGh+y2CtPHf68z9ZlphWgj8tJyFEoUNYuB/D3nAgD9AwQMhPlSMfw/xNODPtAeAQWWgGHWK1/jXubruIcahALk5yh2Chg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a3jEu2f7drt/ieQF4bGTS/OHzNLJD03vMH4CB4NraS2Bb3WCLAM4c+VgpInOWPfA4HGf3CEz0WjD+fm3bbREja4HIeRpQkpnRfs9p3afT8ryZcCDpo3AAz5ecsQivAyaAtKm0rmbL5JrCTcofOYL0b3gR5Ir6L41S2gylsoOl/GpMPE25NFMgOS8YeTeOgMVTPao2yiNY7dNHSpWjPs+B+RE5m/jfsmoxuyeBtSEJlF4GjTFgpNYjOp6I62zd3wmO68jRsiNfdOnJS+P0WLYKnIoXXVQo9LJAeWJ+n5XaVOKsf7hEfTxvKq+uG29vEwdeDe+Fvn3SB2wjw0J3epoPMKhCjcppDVcqLjunhFoFS5BqO7mDd48GstqsGDTq9//UTgz6gqtgNeCmsflp0M+YUa2FiJzkoZ1WCfGX5qe25ksn5xOlS9ZtkG3ZtYX38oC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 21:51:33.2969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 802f3041-709d-4736-97d3-08dedc71e92c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6110

On Mon, Jul 06, 2026 at 01:26:43PM -0300, Jason Gunthorpe wrote:
> Each of these has their own unique situation, populate the tlbi right
> at the top and pass it into arm_smmu_domain_inv_range(). They will
> diverge further when the iommupt invalidation scheme is introduced.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> +void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi)
>  {
[...]
> +	if (!tlbi->single.use_full_inv)
> +		arm_smmu_tlbi_calc_single(tlbi);

My comments might belong to an earlier patch:

Could arm_smmu_tlbi_calc_single() be moved closer to the _range()?

It only has a couple of small steps, so it shouldn't be too bad if
running inside the rcu_read_lock?

Nicolin
