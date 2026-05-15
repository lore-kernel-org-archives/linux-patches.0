Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272772673B0;
	Fri, 15 May 2026 03:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778816137; cv=fail; b=aep6zNmfQDONRaBi8CrzQjEo8yxNlaC+XUFpd4tF7HX1WEFWwLtuSSOJMbw7C0/7zyplO4pXasM6WWQX5rM9dLJtcyXeguT5ZsIt74gUtrVWQl0BJeQpp3hPotrrrK3ozbNCynsMRzjEE6y40Nm7ml9ka/PkD+G7uvqSTtgVWXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778816137; c=relaxed/simple;
	bh=1Yx1UgsJhmLdSvdDBcLx/WplduQ003+qJLUvRkL4PcE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hA5T0xreag/noTFNl6PU4O0jxIAFMm6Va+qVlSklORorpAy4/OWYhMQHVGBM4P2+FAi0k0J2MPdulNOMRwVwiPctymjib9SqHKgRGzkAb4HXKZfRaOqZHwNQtg22oQuq3huC4vkFM7W5lmDz/M3h6cEVbciqIDiwFKDlvh6BeF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZrlBWvSN; arc=fail smtp.client-ip=52.101.201.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZrlBWvSN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sD5JV29QkinGgO1WeIbn8Rfkz9/CPUN9b9DDsjPB0g0xHiiuPMX9OI3SSUmNFe4eJtG9AFmGI00VEQqh5oJL303I4Cc6zkv3Rk2U1LuDwrq08Xcu7DowidSh8M0/RWPfzI0aGoGcUtUVqfdk/X8cyevfsSUCcl0tG6MBB9OoXRRfI85Bg7ATmkqpcoD3BseuGZEoqi6hGGajcHdkj2ibb9/ebhL4ymX+y9tn6yXpI/EKzCzVAD/mMRDIzM1go3IT5KVzffLjSqnFDTow+TSg3/OwtIhaRnWaa90r5n5GiWppaEhp6m2Rn6eKDk55qXAPV1QLBCiTMtH6cjtpGa2fHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EItuEazXeLLZ/GyD0MeYt1zKjv6bBvb2vGiQxHQZqN8=;
 b=LY5668iw4gGe4aEoDvu+zt7zauYlhC5yS1tufX3i/RlI9oMAB00/Y1EX/LpClOd+f3pq1BKC10zIJO8MImZDnoctydhIywyDMOIGWElqKkYxUlZ8/Ezf7HTaBN3ZXkqSHhC8SO1DSmDsKeUEelh8+dyO/6kjKToRazgiztc9DTZKVAdy82MaQxs+mZGYOxFLQm2m3IO/gncsOS4TaSenwgUQqzuQSrjtiDqlTIZCbiUFhOX9PLvl54RMIc7TP+l7Nt2gsqRUPk0eVqIZvcolLeNKM9qZUGCZCaUn0v69SgJAB5zNPAihFGl2yKjAyx5jFJwB5a0W9t/ZLy+wPqG+JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EItuEazXeLLZ/GyD0MeYt1zKjv6bBvb2vGiQxHQZqN8=;
 b=ZrlBWvSNaMFpVxkTb9FIm21nk4xdIuCI0GEx1bPrreC7mGFE8dGVV2ibYuDg5eQMYxa5viZkuxS/n48SbGxD9wv8gGC/rzD3lNP764o5Dsa3slureZ7wi0F0EGEn6vgeGyABqPEkHjYOnb/myBHUuCDs3DxS8UhC9rvdT7RQyw/iPTK9Rk1t4u/vcPChsnIPYcX0DdP5f3MWLaTZj8FbOEvxzOKIxuZCx8Z4AwypxkAp1guYLtXJO2tg1w/ZJeEGfhk8LAu+8Ue5OJFxKVYWUL6RN2zXrogo70AizVnWl72yvB/MlWS66G0P5+qdcJnEG1VKMdsroo8M5jrzfwXkOw==
Received: from CY8PR12CA0050.namprd12.prod.outlook.com (2603:10b6:930:4c::18)
 by CH3PR12MB9453.namprd12.prod.outlook.com (2603:10b6:610:1c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 03:35:29 +0000
Received: from DS3PEPF0000C37F.namprd04.prod.outlook.com
 (2603:10b6:930:4c:cafe::a8) by CY8PR12CA0050.outlook.office365.com
 (2603:10b6:930:4c::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.19 via Frontend Transport; Fri, 15
 May 2026 03:35:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF0000C37F.mail.protection.outlook.com (10.167.23.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 03:35:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 14 May
 2026 20:35:15 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 14 May 2026 20:35:15 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 14 May 2026 20:35:14 -0700
Date: Thu, 14 May 2026 20:35:13 -0700
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
Subject: Re: [PATCH v2 0/9] Remove SMMUv3 struct arm_smmu_cmdq_ent
Message-ID: <agaUcQ7zFPcjid0K@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37F:EE_|CH3PR12MB9453:EE_
X-MS-Office365-Filtering-Correlation-Id: 05eb3162-3187-4bd2-8a6c-08deb233026e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|7416014|22082099003|11063799003|13003099007|56012099003|3023799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9AREEX+zwytufM6kING8XoJX/CBEa3N6kCDhY17js0yNS+Us43wAeBaSFi9z93Ee1p4etnhsq+wVBq0wtgfcLwwDpwp1ilMOZJdAjw/Q6y8WklaFdjRVYLxyyox9jQK98nqHs02gVm2dLMgyTfnEvdsE5bZfPkitwM2j0HDGmPNkGrh88grD4vxS4FK3Cagc3Vg6T9hP4OD9+5u1Lav8i2ntQHS6jhlo2v3B/k9PnJ81IkJJfi5MjpkKLEnLfdpiW8jEZCmMyVCqtH2k0PDrLsjbF/MthRoTtFJsDFxfKOJv98UJLszuTgkDjDIgF/VfMwdEHtI2PGFs8FU8GxAmOe2TcDlEmmQH5rIP9LqpWcHMooVEBGlgwrxtDdybFO3xBbMEhXTTb0bCZmQ1P1jM0uClVgzOG76G9mH84VvKBOsvUEaHERPMrdRJBm7Aok+3a7v5tGFx1Qa3KMapbyOW1uULgbdDVBCvzOxMPoMMX1s/4CzsDqODpUpehhIRLFaXD2WkDPGbvNagH+CKwp7aQPX1L8wAi6rl+82Besqn6NL4/PPsFRIfTmyGjSCF5VHGS7tlcYCBR6rGQ4ZFXlgzX9/hm/HJkRKyuvpVxQTEKs22RJz6vVHsfhliXrQd2dP7Q4vGpSuoLf8eBZN2eXcXyGVLSRPAVg0tIVvO7yDGCKrpz3WCvC0GDN8nPUMNGUopt76HjL6vxS7AVHBQLWEr1V6+inQYmRbOkJR9k5PkLUg=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(7416014)(22082099003)(11063799003)(13003099007)(56012099003)(3023799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kCtJQteg6R5vItujmBcsPAehZzqy1qGyMfBKluu47PWt/8M1EAr72++FaylyWFotJrvr3DeVWBp8eKJ19YGT/g+rH/HKyAxiWhwFIaKZl6fSIVb8udMx2v1jfyodLQOd6byMFtoEYBgt1TPgRoJJY7168fPAWbSQUwjTB6JwofvCmArX2YyTuj3+80r8o8j6jn/I4FSPKtiqyHIH5Y3yZpNZGAZMPUw3oSZzIc4brP+F5cHGz385tqGo4l8BfRzg8/zYWROGUC0kgjw9iks2+CzzZ3ocjwFztisUxJV4zmohJjlkFiQdul7eYUWQNUmgCBHSaEqsIx9AnME1gHHCJOZ7mAlUFpwHY8YFciSE1j6rjq1ySVqAb8EHJ7IuV4yZQlzUPHWvd+XRR73jh/psUm/3SGXq5/SSTSafoYxMqlNgZgUFJfPQvtX3YgAA7Ew8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 03:35:28.5496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05eb3162-3187-4bd2-8a6c-08deb233026e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9453

On Wed, May 13, 2026 at 08:57:39PM -0300, Jason Gunthorpe wrote:
> [ This is part of the patch pile to move SMMUv3 over to the generic page
> table:
> 1) Introduction of new gather items and RISCV usage
>   https://patch.msgid.link/r/0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com
> 2) Remove SMMUv3 struct arm_smmu_cmdq_ent
> 3) Organize the SMMUv3 invalidation flow so iommupt can use it
> 4) Use the generic iommu page table for SMMUv3
> 
> The whole branch is here:
>    https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
> ]
> 
> The invalidation logic has this multi-step process where it first
> writes the command into a 32 byte struct arm_smmu_cmdq_ent, then it
> calls a function which converts it into a 16 byte HW struct, and
> sometimes it then edits the HW struct a little bit before passing it
> off to the batch or submission functions.
> 
> Instead just generate the HW struct directly by moving the FIELD_PREP
> blocks out of the big case statement and into helper functions. Call the
> right function in all the places that were building arm_smmu_cmdq_ent.
> 
> Add a type for the CMDQ entry similar to the STE/CD types that wraps the
> two u64s for clarity and use it everywhere.
> 
> This is intended to have no functional change. It makes the following
> patches work better and removes a bunch of LOC. I've run several AI tools
> with instruction to look for functional changes, which did find one subtle
> mistake in PRI response.
> 
> The removal of arm_smmu_cmdq_build_cmd() also achieves what Mostafa is
> doing in the pkvm series by making the command formation entirely header
> based with the arm_smmu_make_cmd_*() mini inlines.
> 
> This series has no dependencies. Several people have already tested this
> on various ARM systems along with the full iommupt conversion.
> 
> v2:

Sanity tested with SVA and nesting cases.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
