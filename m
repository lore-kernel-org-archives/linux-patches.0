Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012031.outbound.protection.outlook.com [40.107.200.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A721FECAB;
	Mon, 18 May 2026 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779075061; cv=fail; b=VgO1Q//piPRSOkLdD5PTmpkSF0CtMA9OvJNacVh9AQIaM6YOZ5nFDS7/Z+zYOEqOeU2qbD5SmqcmEVzDjSzuQdZ8ZEs5Ujr5EdbEdbTKBBjYRCBwOsCwlrJ7bkCvNRkwjq5dYcQfLiL7WkT7u63WOtEyzgaUfAmSYRJcj/8YlRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779075061; c=relaxed/simple;
	bh=AxvOXn7uc9X51MGeEG6QBL5GgntquV1Os/IFITiCSHM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APuP6+28NppDJ2CrPnf587SkVp6OAjSNhYjNqfrm0xicUGjCetCVBY9KHsN+rv655qQzriDHIwUjsk4a7XqW3ZHpRDFj14GBWHVM7EU3qmg+H1/TklBhrP4QPJEw06tLGDpmfiq32Ds22jfH/Z8yNKXk7q4p5VXOHKYvpanMGHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=heM6MW1R; arc=fail smtp.client-ip=40.107.200.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="heM6MW1R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpnehzkNoFu6wpm7VCepE9Ez0V8iT+TR9GTWjR5WFi+vLJlXb1c+k0Qm4kL2BmgafmF3uABMbAERk5q8nW4mINXHZCMC/IKgsJcSXOAyA1emB6cxcadHWC00RZ1VspovAZNpOtWM5YAijuSLMmPSmeWjzUe6ku8FofqegZRmAmrQWnYPKuTFCcUwHc1DXO+pjLBe/2ylhKNptCdABTDJ/fULhkODq5S4ZJUXL0O7OY7ZpgSggcItO5v0jUg/ZzDzjNQFWDBRhlqU2KRhf5kzhbSZdAHg31HLWqyKOJP13hzgOANxjj2mn6viG+bcvWDGJYNNIL1IOnDd2lDHaRFGdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huIPI1tt4sPNeIqxXEbnalkGO6aRWnYJpi2oUIK/l5o=;
 b=V1/4yAfPa1nkKMsKIxJ4U+r67aVrWlRTJAb6ivlNtnAWTduwsraTUO+BQPuoucwZA1e6RXLNc0wKnsXwCejZb2FvECqZSUqAsIDkaRfhMVFP6wIQqkycHBS7mL+dooiJoUVKRWkAFvnkOtQluGLKDBv8ymq4pO4eEZ7Nc66JGM/7pO1nq8+BrHTtSLx6/zzbxyNTZT+T2fX/MBmH59mMNs32dV8JQC3nnXdE4a77qYrXxsmrsXKD7h2TXE0duyQj7T44kAPKEkx+xInIPlsWHX00pRJnXjpTD2/a5o0fUp3EQU87kda8YZs6H/FsbeIeKDBeddzTEbYld2ZsDWJRqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huIPI1tt4sPNeIqxXEbnalkGO6aRWnYJpi2oUIK/l5o=;
 b=heM6MW1RdRusf+qnhvNRbKVgczAjf3fgWJzDOOEaHw6a/rll2FlJdiKnLoxAS8n8bMh6HaSZ410P8ezgewZPVivlNUoPP0aoSq6rDd+fHP5j3XR14yvolBfEZOAwawashjo6Vry0/5ks0ukRaB1NQxwe8bpgHousAmSoDw5jmQN5V+m6aty2jQiKt+gN5Plr/X/WRvsuUJg9efuOx16h7IopdZUOKZ9xIVPk6Y/6z5f3SqSu9+9Yugl7Uig96hi1ipa0G3yC5Om1aaI/ENmn0Vc0QTKoqYv80frumVVpIDoXecuwNLDE241hjb8287AtLSYRwbNUqW180fujsqVpXQ==
Received: from BYAPR08CA0053.namprd08.prod.outlook.com (2603:10b6:a03:117::30)
 by BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 03:30:51 +0000
Received: from SJ5PEPF0000020A.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::cb) by BYAPR08CA0053.outlook.office365.com
 (2603:10b6:a03:117::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 03:30:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF0000020A.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 03:30:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 17 May
 2026 20:30:28 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Sun, 17 May 2026 20:30:28 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 17 May 2026 20:30:27 -0700
Date: Sun, 17 May 2026 20:30:26 -0700
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
Subject: Re: [PATCH v2 8/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_SYNC
Message-ID: <agqH0s1p6asI3EOL@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <8-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF0000020A:EE_|BY5PR12MB4099:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c749afd-907a-4fc3-94a8-08deb48ddc6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|7416014|22082099003|18002099003|56012099003|4143699003|3023799003|11063799003;
X-Microsoft-Antispam-Message-Info:
	pbDKd+MfZIGyf3cm5+pOoSrFVfpSXbVGCBZbxe+Sbcr3nY1URSYmGbl1LTDCGNlV9mhayQcCpP4T0Dr76IQyjfuGmFWIqYiZibI+UuKgY1S/1OACj+j85fV+B7qyMWcHen47cEOdxf16oy5h1Fmtg765eEhGptKsBmIcjsciwZBhY8rGJj1Q07pFw5YYe3cxzOedHG6/7iiBpKHdxhtZq+95wGEQYMRp4kPmUYCTSv7F5sLjplW1ExCW3cRCtp1LlVlqgNQbzYx0MPVw4x6umtRdZApJDZx2kmvtOshsdg1PIOwErL7sy+JWnHVb+wlo9PR6rrkWSmWkOl/6MX8lz4oF89+iaUW29jtDEiwQMVWSNGfGL65TyuvVnoHYRSbDq7buStvMFIIuTl6N9bZruy/1PqPSHJotpKDBW1K9E8WmmAI79/TqQ806q+nqmvEr5y3Yd8KgYLppI9YDWsstn7koVKCYlEV/925lB6rIpXxJgWrkod6wkl4e2oz/HeE4J5oAkCIGyr5NgpgjOHTS5Hmdq1VPxBApE4xgGYHCEj7KTZwo6RIm52G8eYeGiYicSnaf4wJ21gzlWcQuF2ucN63zogB84TXpZQ8yVzOamXu57ZqHhrs1IIvfUbgy+9AKAXapO1wc7SoRyfzmQIN/9JPvdzUkeMSeMMhc/8TLs6SoHv0uB9N8bo8kfRvpiHlBgTI2kUQPPDpwlSoK3FNsBUSFkLNDDCMXAXia3rml8aY=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(7416014)(22082099003)(18002099003)(56012099003)(4143699003)(3023799003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T0xdN5W2Qj+H1Y2Hdu0cs4CSjw0chdDkErtQXglg5H5kxk+wjuRs6JvBNNiUg0KbQatCaQdy36U9KOtgFnVVUpKCADhwRHfz3SUsbKFnzdbpjCd2JxeTvHmbl8o4E7peO5Qdk4/jm7qmFE/LfSPQdcTgaIMqB/LG7StBIOYg8LqDnOE4eT0B+GBNHafH03LdMIiKPkFPMW6vk53Ggev6PMnnQ+Xqfjy1ALARpAQ9sIa8Fkd7OZdlMzjozXV9aatJi45XZmAmkODyyFD9sK7lXVOij17N/Z7lee9fB2fMkz5gN+upZeKcohhTnTuo4kn+Q/yX1LWXVY/P/v1RUXUaZ0i4Vh0aYTGCajbjz5bafgyZxvlkGtHX2nEqrpWp0SxqJO2F1WFYLBifs1HgQX0R8eKd1EMqSzD5ASx1lhUgcSE0uJPPuqpWkrNqs97/Qso4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 03:30:51.1866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c749afd-907a-4fc3-94a8-08deb48ddc6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF0000020A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099

On Wed, May 13, 2026 at 08:57:47PM -0300, Jason Gunthorpe wrote:
> Change the flow so the caller controls the CS field and remove the
> weird u64p_replace_bits() thing to override it.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
