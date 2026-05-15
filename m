Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012023.outbound.protection.outlook.com [52.101.48.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FD93D0937;
	Fri, 15 May 2026 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879009; cv=fail; b=DWmYxY7Ioxhtu0hJ1wuBz/QvTjXMadThk7hiWYZ9HgZLhnmxQsHe22u8JsIMWxppyfoLity4RvBG3uoy7kzAH+3kd3qfupyfNsFbs/hj2In9v42N6cWuYb+05PKEjBiGUADBJl3n+ZOpVJ01qTccf4FrZk6Llm9kdDLtKr4Puio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879009; c=relaxed/simple;
	bh=xIHlPSnmoBFtL0PTC7ilp+YDY8seGur5sXtElS4vOU4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9BsTEpOPgsxG0pLAdcb52bFlUwqX3wGArK2NRJHgkgOYglwvQL5v8BlvzoyRaoLLFKDnR8GYSMP/MvngOmCa9ERmEVZFfdP6dgnJWPhwZfotVWtZGMu56RDFyUMZp2Z7V8gpmnWTU/xchJ99ESQqSmuQmoG/4KGobOjOVjtUyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rxh1Wdt7; arc=fail smtp.client-ip=52.101.48.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rxh1Wdt7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0RfgoxjDCTMvsv2HjEUD1AKy8zolIKhcyfu5PTmfiN1l3mUpACrAHA4jC15jzcOQpd86sh/JNkrq5lKJP1vcgjNbi1xeNaYRM4/YMFt5maBJ17099d/AqW86Z2/PrDvQ1paaA8Ay6xeLxLmOOcdFw7lBpVAUCmM4rEXuw7l7yCDWPrFRSmgyOirn8yydge3Pn3DNiKRns3y/wZ06KpqFDTJgC4Q3v4Qd3ZkjX0r28UKV7dHipCcYbJgUl6WKWgYySd/lUu0r4sMKHHhUowg3cmpdHtOYIUrX8AwowIULW06BIHyuWZ35no0/qg4s29ctfeikxuYy/poSyEH3i2EUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKcFwPeea/9VwL8YT+o0/mGEQbWW+vWbTOi8vtsGE4M=;
 b=XKtuETXTpfsN/3QVXheWRhRV7tUUCio9C7DdtfICielhGdFUO9l/6plgAjOc6BXRatDXv8yml3EEW93LVbmnMDYVjuZHeXhFGYHWiAOoH76+EIUob3i8rqvatywb2xdVpU+05pCnbIqEAGU4eBsR/YKjF1x5v6Vbcof7TdS3nfpWqzaMGmwJucKRn8XqV0AtdqhiInozzcTZ9hJKf0RvDLKEikO1sRR7kKu4nrBIWsaGt9ltu16otTq0sagyuE0yaVArXZnUzc0PTFQM3GGW3pi1Q0ycZYTYEZCrqlM6qhOs0Tx0zPxV8qE/u7hGqfIZK65mRqEk3VkPIziqIkzTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKcFwPeea/9VwL8YT+o0/mGEQbWW+vWbTOi8vtsGE4M=;
 b=Rxh1Wdt7yL5TWrynl3mH2NURsQx2UQei2IJablCkriPJklSr/Ialmt0CMTnYUxwzZG1ePvNee3hya6XzFFz74YTRAykxfdVPmP++NoJ8isCdz68SERR7aVYashnz+BqLixwo+QU+aBY5l5jOumupkHq8WJObrSgJwSbVkNuy4KhXvJqVbNUYUmbAcXWkX39SVNZTWO/BlJv4d0QesyhGFtpXCMKYRnbe4fHIZwlvAOA5GO38MU/Xb241xaQRshh/1r2EubskPX/5InZHy2WpzgtHyG5qs9VwgDo9jw0mkSFmQjRHTobUfTjro9QSPE4oMCe350kQVqpCrfp9ltpDaw==
Received: from BN9PR03CA0933.namprd03.prod.outlook.com (2603:10b6:408:108::8)
 by LV3PR12MB9257.namprd12.prod.outlook.com (2603:10b6:408:1b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.20; Fri, 15 May
 2026 21:03:21 +0000
Received: from BN1PEPF00005FFF.namprd05.prod.outlook.com
 (2603:10b6:408:108:cafe::63) by BN9PR03CA0933.outlook.office365.com
 (2603:10b6:408:108::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.22 via Frontend Transport; Fri,
 15 May 2026 21:03:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFF.mail.protection.outlook.com (10.167.243.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 21:03:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 14:02:59 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 15 May 2026 14:02:59 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 15 May 2026 14:02:58 -0700
Date: Fri, 15 May 2026 14:02:57 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Jonathan Hunter <jonathanh@nvidia.com>, "Joerg
 Roedel" <joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-tegra@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Thierry
 Reding" <thierry.reding@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>, "Will
 Deacon" <will@kernel.org>, David Matlack <dmatlack@google.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, Pranjal
 Shrivastava <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in
 cmdq submission functions
Message-ID: <ageKAQC7yAzI0xB6@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <3-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFF:EE_|LV3PR12MB9257:EE_
X-MS-Office365-Filtering-Correlation-Id: 62feb9ad-0ea0-4b61-939d-08deb2c5657f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|82310400026|3023799003|18002099003|22082099003|56012099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	SgcbjysddkVdOxaC8DU9j0cJs6gM4Bpz2BCy+CizH8ZY9RSZr+fSDDOUKeN/X0ECJHkCaj4ZXy6Dogjv+9hLfHKyynGbuWfys9BdZuuBfeyQronfe0feRA/L5oolvu15JirEslf2GjlHP3Xt/alWc2jA06Op8Jxgp3417OsLg04okn17PDdtyhBk0nWvvMMHZ7vAkzPwlila2VPkGcirF/jXGeG1E8kp0EzVRn/GAu4vhq5WmRMaKnQKcIJPB7AFm55TtBGkJ+zL1h7qoCnjjVouUMyuxQIpnDpns6D/AzwVDHJ7L3hvaiA1coGa+09diSDXUWrWolzYkkf4APeaG5N/2/qcECIf/4cElJOlzNNpjEMZ0pQ6KsrKaIBH+oLA/Q/oRj9FUnaDZs4hOMYsV79v8uufh0NXOOZOHJaFZ+EJlFjAYx/tuZcKX0bQLi4qCacGUsK7mwIoHRrwzL50QsO1famlFN8UU016YZAofHYaJRZfJ5EtprbCbcYR1NQCbrn5N8a3p4eQquSqkGQb8umNnjMg9lgj0upKE1yG15+lTebeTt9MIIa0bifTaJrAR2dImiiRvjPzkfhtDb4oYGqVjdk0KDVL8tsNX2nusxBLc0ojoZDXmm39m6nynZm74EDw1lVHGLypuEJOxVHXB7KvQ6BmWVQqhaJCDSyz93YtvNJdpaOkE9tCz7n1DqhuRIknxUeiPGJTwU079ZLgyNcv0XXCQnojOEAEUdeDNdM=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(82310400026)(3023799003)(18002099003)(22082099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ip1cdjmp4XwMZxYkmNRi2yirekCdoaLpHq2RgjizvQQBXAdPfleBMl0fpQPLHj3qMYlrnkfXVn9yaIb+9oO432hfOOC1WAHgNj//dVeOX6o53LCGOV1HRTbnn+zAmbAT+uQ+iOOYRE7EYokNJp9zU9H/hKBudenn7UjbtcifJNrbZmxsUvMEy5OCA+0iqqr5v48d8N4Xd+PiWDx6+7Lze314UuYWbLG7Ns4CNasFTr5Fd6rpfdNZkbsqN771Z8e/OUHtEUL0zl99FG6z4JSIEIeG/DJZ3T7/mbYi018y+BXFxpGOwQ4phJxrvvJu33BKMgO7dXi26FykuOZNS0sf4PbiCbzc8paa/5QSS71Bwhc6kWv2gQNFF7BrcNyrQ9/8Jaf80ce6wVahIzOOv1u7ex0qOhQUE/B/t8auq6kQGhbUmp38hBVyeXJ2eYLJMRC9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 21:03:21.2420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62feb9ad-0ea0-4b61-939d-08deb2c5657f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9257

On Wed, May 13, 2026 at 08:57:42PM -0300, Jason Gunthorpe wrote:
> Continue removing struct arm_smmu_cmdq_ent in favour of the HW based
> struct arm_smmu_cmd. Switch the lower level issue commands to work on
> the native struct by lifting arm_smmu_cmdq_build_cmd() into all the
> callers.
> 
> Following patches will revise each of the arm_smmu_cmdq_build_cmd()
> call sites to replace it with the HW struct.
> 
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[...]
> @@ -3446,6 +3447,7 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
>  static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
>  {
>  	struct arm_smmu_cmdq_ent cmd = {};
> +	struct arm_smmu_cmd hw_cmd;

Following the other pattern, this could be:
    "cmd" -> "ent" and "hw_cmd" -> "cmd"?

That being said, at the end of the series, these all get removed.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
