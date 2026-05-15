Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC361ADC97;
	Fri, 15 May 2026 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778887824; cv=fail; b=fCHX4RXl5BmsOlhDyzrNswjxeKjEJXciwm5Llp0P6X7qBXJ+SSLLyqlIuYphe6IbR93hnb0D7GXx8l/0FrLDBD0fIshLWG/g9xlUhI6J0fskuIpmJC6yN72NfbXRJczEIIhEMvTBkgEz3tqtEcUONmWCMHpJx1M93TdXSe8bTjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778887824; c=relaxed/simple;
	bh=4aglhG3yiBaxWA70i3nmBx1kRxYaz410jw8u8D3CKKI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M86HnlFXKRts8sHPTnSYSnqYRZtGSFI44Ior908iYDM4/Gkome25tyZYcySIwwwx0SfKi4QL2pC5gbdb6LKNGNqvQ6RoD/pl82jbQCx1Sr8zkrEKq+zjeFkShokRNOF2M70mjIkzwgdXSbOI37GDVY0yvFGtNYAHyJsR13nMpbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K4U4XAIg; arc=fail smtp.client-ip=52.101.43.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K4U4XAIg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=suFeXs15sKrt+AQVIf4r1llxX30EXvK5d0PhiccrK/nHP+SNwl+myB7BLRIfiUXYt6KEDX/6S2l/WteJObBMYtX0Ct2ReCrLT/5OvFIMTn9dX1lhEY8ZN5RykfqG3rJFhnIYwyHY4RExrR6fhzO7UX1AiMfgYM8Fzw4dtPj1DJgEE+1luzC67e5w5InXl9wRtAmerXQmynX5HJM4cyhMR79EqD/xLqCKDG+A7fhYTHIai7ER47XO2NMDth/lurrNiYcrMM9elaXGgv+ghOnnzG5AjRFquDjhwW4fxEKIrUBodtqtreaxPa0nC044X1NpusNWNZsD4U87zu3FFxVj5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hxdFYX0NrCooEGJIy8ZSeSxLvLyFiXMAAGzwgRKyJ8o=;
 b=p32+6oyDhOZ7bmf+3hrhOuVpgGrjeYZLdcLegSgjzF2UoTx73MxNMpjhDBxKt1UsiPGZwPKQ+Vyw3K9wxtkr8lRLsgyNr8DudfRn3eU1WLwwnXCA4DiYpOgNuvhPBceiz7kOQn5GuHWDUT8zhoqN/m28voBF0q+3Z08PUjxeHAj3P+ulljnUQDhHwbfbz9RC6fnlwnbEq+CRA8igJQlbfffhExXwSLct0Y5VmrRI4oDHXLx3wfBTW/AMYuqqyihs2qCyBMftn7cEV7pnteO1ld2sLqgwUP/pI8ALXjxlk1vA7jW67SgBqxSQmNs6yP5domJvFvVxJQKGDbG7LVL0jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxdFYX0NrCooEGJIy8ZSeSxLvLyFiXMAAGzwgRKyJ8o=;
 b=K4U4XAIg6rNiRQs5hD8xg3LpENi7T3ocjS4fZGEy5iPPuEJirMh+Of3NJzhQcI0AUoCYRX/WOsbFEA2nnTdSfbq1wgpJXVrCfe8Q1pdb2dRGbqZ5AGBYA5CKMwVDDbAm102RN/edBUt9Kx7AzhChzO/kUwVl/R8T6pvIyun90As84Tqp0oNWtuh3H5hCyOirH/RlNUBqcjsQDCKMlkTM5OtTbCUaKIvzZky45l3VC/jUXIX2u14H3/v47cP8R5FS8UpKLpP61rIRHsxDssNDyOnn3oyLN1YD6desfWkGvVQw4xjhZ4tl9ihetXnc5h/PnyQE5SfnUIbUdtxnrI6YWg==
Received: from PH7PR17CA0052.namprd17.prod.outlook.com (2603:10b6:510:325::19)
 by DS0PR12MB7725.namprd12.prod.outlook.com (2603:10b6:8:136::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 23:30:15 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::79) by PH7PR17CA0052.outlook.office365.com
 (2603:10b6:510:325::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.19 via Frontend Transport; Fri, 15
 May 2026 23:30:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Fri, 15 May 2026 23:30:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 16:30:00 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 15 May
 2026 16:30:00 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 15 May 2026 16:29:59 -0700
Date: Fri, 15 May 2026 16:29:57 -0700
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
Subject: Re: [PATCH v2 4/9] iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch
 cmds to struct arm_smmu_cmd
Message-ID: <agesdZNkLPExzUpx@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <4-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|DS0PR12MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eef110f-455e-43bb-cc48-08deb2d9eb1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|7416014|376014|56012099003|22082099003|18002099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	WOMXLrQgcvNyyKs5XE0idZqQUzmVuGhuWV1u4dyd5cpq/0dmPKn466ExaNuhwgB3OOFc9K0S2hsi9bQG4DaOzgJVLjXGJoLREon+BHv4z0rUVi5rrwhEJHZlqi3Fxi4tyuNhB4HMud1pAIT7m/SIp9m6Jsqxd5WIe1NnvbJd+2njrVACyATjsRYfdok7n6guta8QH/ytjDGeOgTQS5dLrGd3p/5yZyTJp+fX1jCb6VXG5xIornbRgDyvRdKlKVsclR4yGaSJ4cXlaLD63jUOv3lZQED+r3pcLkGlQVOZix1i/f5QzmBY808j1VxEVRsXL80Mnr/sT3QsUKCgXd0d8UvvU/+uxgrWx51B/XwtqDIbYbCajAMzsO+38WY/lvcTQXGqGNng3cGh417Zi98rh+oX/6z8UG/utX/6t/Wvgvl+pkrq0EufcLLIteTo2LP9unwe3Qs7YPw/d7I6ig4Tf4WHuYVeR9fDsB45d96m3diKTkGmDynPw4oN67IwRv90l298F3tUa8phiRUvXAQsRJT8MPc0IxNc9XFFmlOaON4EH3j/vfwkMquYo2JKx0B2UGNYsaQtvNDcAsSr16yQCTg7nMoCbQ2G0kGHA/ck0mwQcAeLqrO1etER9DnM4ybGg+8fvh8INyuPRwt+knIG6+QtoSjYWqmvRVh3hBRDB9QkbR2dPCkfieQnumQZ1qWptwEbQUQHEp/p/VXzV5dbJeb8pwc7rzSQM5uVy2plJLE=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(7416014)(376014)(56012099003)(22082099003)(18002099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UOpsLU5vwyqod/o1WFWxEXgRRm0r4MhyzosHXf7JI6z/nXHd8eNK3WRMhTP8Xb8FsxOEBNuFC1pi5HI0upxI/ecd1R2P+a4s18H9ooFojKPmImxaHwaRV322LkEte5Bq1gOZfE7fNQFArnF6gRKvYSwjzh3HT24JCVHYhYc3rpp0YtUfyb5G4fraKPqtPlLOmpQlFXy7UPMJxLwlljCi1JEG7Jdb7ExujFrZtmnuFpH3mk+UuSEscMm3/9Se/aITfcwKCv4NyUrg8YDAhIQ9+GVD6T900UV7fLCvX37VpIqq5mvI+J6iYGNDdF1jnlb8SklQh5ziHT139mBKWJ8mB0kiFpklvf/4uktwNpHybpx4yazmg5ZOagIti8O1JmTNM+0kcnOmmbF8HgBE2t9ikwXQp27sKU0QyMVoD7tlSUayHQB4tPzkGTdiW/uFG23H
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 23:30:15.4135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eef110f-455e-43bb-cc48-08deb2d9eb1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7725

On Wed, May 13, 2026 at 08:57:43PM -0300, Jason Gunthorpe wrote:
> Convert the batch's type to also get the remaining helper functions to
> use the new type and complete replacing naked u64s with the new struct.
> 
> The low-level queue_write()/queue_read()/queue_remove_raw() functions
> remain u64-based since they are shared by event and PRI queues which
> have different entry sizes.
> 
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
