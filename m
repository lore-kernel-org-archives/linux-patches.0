Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011050.outbound.protection.outlook.com [52.101.57.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181AD306B3D;
	Wed,  6 May 2026 06:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778047919; cv=fail; b=N7q1+d+RzzP2OAMhGwnJfUHyeJP68Pwk2/RaM499xzfXXu5CgCPcom0hFb4nuUy8QMWqe42p/oL4Z9FQmTYn6+WP+p2ie5rReQ7pgDy8b0YAmGhEoi6+95VisAoYZisfvoI+/yWMQahn4cigY5ZcJoTqqNtXwdzYk3dMB3qar5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778047919; c=relaxed/simple;
	bh=LoJpkhfbYtESNwQe5ViRW0WHqFp6Cow3X2AoFGWhx7Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjOxQciRijnaHh57iPlfN0fVsaiKSZQpVDg0VzTYg7iqG+KRA/NaYRHKQSuIsK79IO4sbZ/he/j2G/y0SFwZ/lNKhGzq58p+2yk80eq1sbHbHnqob64Gzsw5Ib8T0qnTWrWsG67lQuuUqbdNH2mn5wBhHBAUcVy+qQoKoXyVABg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=powSkruu; arc=fail smtp.client-ip=52.101.57.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="powSkruu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQWmNHjbhF9Q+94ZIK7JoOQYooLuFS/g8sNqrJxP0/+qHj9Ir/ez+MW2yjxPCdafNp2Jtmi3tNIjDCj0UUTOLj9IJ2E77ew5cQz2VtLAjiBmMtYsb5csiwUEv8L9dDqxv7eF0S/DpwXA9es3aProJLVgR7saHgxxeWD6Uj/LyQgf33DFVR5YUEevplkRxxGq7uA+sjsp3riWeMBQeNWyl1XdkYAoDe92zJY6jt+9x6Kr01X5gQUe79rAbHw35zycWSo/HjqImnIsT8q2QeqEVV8cuY+LUejnCxfJh3Uc3ItbcPWPls6moqW/1/2qjR4BBOGHwhtZ3pQ5mHTSFMqatA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVN6e2XkmFqmabK7+ZBMtAt2PpBLGy1gsGYGviFXBgM=;
 b=f4zDP+DoFcm/7jyogfsvtqppASR65Z1OEBptiFWPpJtwn8sBVjVVEp4zURfuThhZqla/mRDrt72bnbpRW2xI/f7JTxroo4d6VwDXRwS35ajGzuTSuj6dM6QYIJ5AYhSKTf0PmltBS031DmDF43RvlKVOqyC697FGgPtfkJqnK5oYxoaWeuY6cN+hGdEjkbEeh74cS2fQZNnPmPa4K3ApR9CxZ9AuTsDT8n+i5zjyfXiJzoA/+UNAI9F9ECzSZ1NKzhrlRTwjuaos3PLxwkLaykTmt4aVsD6i9lytfOtKSsLJASj5QODJgtyZxdo0IX2dtAW6L8WCrnyiANMiJ41VuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVN6e2XkmFqmabK7+ZBMtAt2PpBLGy1gsGYGviFXBgM=;
 b=powSkruuZWShvOciDdTVL/7d7mWH0NLdNl0NjbGbLjTUq33+dVYs6nzf/l610dFsg+UBia6SXi3vYYGctqBsMNWpUUkhvjbnrimxXqIKPoP1qMy2sO/ArkTDi21Thk7B7W4sGYaKna1XBDtn3x/7X+uxnlkoGhi74NRlVs2D+gzcod56ll9A1MW5hjzsThISRqRL/oRR0EX9KP3Dz4zEj8+bqyCnb5C7gAh72xp2ScSCACPuFF+aJdh6TSn881PGKxGm4M6JmVRcTrbz6MjQ7QYT4Gl6p2USt7wN+FszbnUEROPbPSHpop5tC8rTvXplgjQsd94/R6QHVH6q2nb2Ng==
Received: from BN0PR04CA0061.namprd04.prod.outlook.com (2603:10b6:408:ea::6)
 by IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:431::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 06:11:48 +0000
Received: from BN2PEPF000044A9.namprd04.prod.outlook.com
 (2603:10b6:408:ea:cafe::6c) by BN0PR04CA0061.outlook.office365.com
 (2603:10b6:408:ea::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Wed,
 6 May 2026 06:11:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044A9.mail.protection.outlook.com (10.167.243.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Wed, 6 May 2026 06:11:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 5 May
 2026 23:11:31 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 5 May 2026 23:11:31 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 5 May 2026 23:11:27 -0700
Date: Tue, 5 May 2026 23:11:24 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Jonathan Hunter <jonathanh@nvidia.com>, "Joerg
 Roedel" <joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-tegra@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Thierry
 Reding" <thierry.reding@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>, "Will
 Deacon" <will@kernel.org>, David Matlack <dmatlack@google.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, Samiullah
 Khawaja <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to
 represent the HW format command
Message-ID: <afrbjKNmTI7xyKF2@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A9:EE_|IA0PR12MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf27f82-230e-4462-a324-08deab365b90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	aDfIiovrda9ZFDPP6aICXnB59Ay/C5osfoQMf0K4Zq99T4WUBiZH0jSKkE05Mg4NaketMXtflpJYMPbT/gPTUr8kmNJS/Vd32tRriuhm2T/rtRlv17oa1xkqX9qkhuyifctGTKlO/sG8FAM0HJTA1D6LKzktzxcaB8tUozvlu87wyN6QNYHqL/5vWf/p2EiDXsb+S7L1XvIekXlJyY+RLWcbuc2XszE6qHvM7VIaK9E7o6Jm2pwwK/6abWWokMbbZFC+GFvM6jgt8u5alOT23+0CCiL8y87aNj4Th/hPlUURGzG2drWOi1WIoykdsK2ysFujEuyY6uRotFFa3MVQnefhNpFP1c5JAon5WOWkpRdyrF7DilyIWf12CzJdy+LdLciJN3wu6nT8JS7pmM9QS7eviuIvAzgNfYeFQoH2klbfcIUHBkWDG/5BJOVfmZpn6KMCCXOWzpcIs+s4u/a6zv5Ba/FXup6s/2I1jvOGaiF8plnHce0A6dts3fDyvFdoezNdWvgDjIytwxfkAJqjMq3n4ptrCrrs9n/Mlv/dc7Mw1O1TaSTvUH3MDLj9hN8Ds7SoF6BBq9wiz1kmJq4tE21/uesrZzxmGTCsSCQRnbfBjbsGtiOL4J6pB5ovkqQlrw7PKCvegOq0Q8BkNST74S7pVprhRyVgF0eJtKDmZM60aU/gb4UwqyCxA4tH2c0NFiYSICxya+GqE8f8wOS5wM6XoQsBRMbSTfvTm/kT+z4=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	85Tc6Ieql8x5tU3JbM/GKXh6Y1TJ0u82D48qwZ/qE3iUdO/+Obh5KAnOriYQrUNloUVX+gFPC6bBaGLCBR1VATzHnbom6TNsbfsYzfFTT422DJF8FIf1zmItrRMtiv/h+xa8mNFxj4Jb3pFthKuVFvqXkCeCeH+curuWSXMbps4TJH6h3mLOma5+OD4kcmmafNL31Zds1iprObcSRtPArkUDf4RVuU14XfaWZEEoEgGEaHjiLgo9k7OyK23qUtgN63T7LyWoc9w1SsLLAm9xubtea+NzzatPhmbc1XHZsJbPHkeQUpEi4mKcU9w/+spSWzxJXyatO2+BY3WnZ4BEs9FazsvSFxRKYX/bd/RIaE29rpJ8TeUln6fF0eUoJ2+I9VA52AKTUtgugjPv37TH4wokP0IBWworl0zRMZQzmqgQcK3ia8+/ciZa1maiShTG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 06:11:48.3989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf27f82-230e-4462-a324-08deab365b90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529

On Fri, May 01, 2026 at 11:29:10AM -0300, Jason Gunthorpe wrote:
> Like STE/CD, add a wrapper struct around the u64 array to represent the
> already FIELD_PREP'd command data. Unlike the STE/CD this is a u64
> because the command submission path will have the swap to le64.
> 
> This makes the API clearer when a u64 is referring to a formatted
> command and makes the following changes easier to follow.
> 
> Move the command constants out of the struct and into an enum alongside
> the rest of the constants defining the HW format so the entire HW format
> is self contained and independent of struct arm_smmu_cmdq_ent.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
