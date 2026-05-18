Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011026.outbound.protection.outlook.com [52.101.62.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE32E212542;
	Mon, 18 May 2026 03:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779074144; cv=fail; b=YetAnP08wDgEDSNl5FQAxgukdcVgICuMeZje6RWOsPb3b3H6IWbruRSO6CDGrKU9z4rj88RwdBhcvjX039avaTy6MdFbEGUQ8sxiK4855NhwZw2rC3jSfBZT2zN0hzembFA8R5XLy/jKYH32wQ5mae/0i2qZPhv75NXKKZd0zlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779074144; c=relaxed/simple;
	bh=K4qF/MCgei/vu3dWPQdNLuawm2eDWeFTT+OzrVYSZ/Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUs9+U3Uio40K7KnyLyVuONJ5ip8S/1FcH8nTtN8d8aVD0T2H/n6kqLmyRTEMoH4268JzC70t5TsGa/z/0vk/F2fCBby1zg9Tsu6vnqT7FRuEXBvkvaMKCsrdaChbPNWdkaEvxL7mOqqwktr10huhsZMaO6qQANWUj+HNF8wzXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q8ye8UtU; arc=fail smtp.client-ip=52.101.62.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q8ye8UtU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XaRtJlJ8kfAw6Cdl+8vM8KmGd/N+aC0GJ0/CO1YYpeYytABW3tzSCBDJvVu+PnwOepdV9ERJU7aiKL6D5JgivHoIMKautWEolumJaybQ9YqDYfBRCfdQIJa2dfTYTm8ZQMzXXtrYkF91bTop9aGA/V6ZVgS0tha8j4pv9Z9uf5j4Wb6Oa9JW4lVb0r4RCJ2D+AxSc6ScAeXrLM77p9fzSPGO1w1huvc8RLS4+ijXXNKIdVX+nxaexUmphDvjKc3Mj4K8zAZUJdX05vouC1RmwdmBvCZIaT0QusedXhSshXiyr5pq9hzZiJh9uzB4lMDhOTTks/S1tTW3JHZ9QB9jgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4jdAoevTHHhN2+Y4q/JE6c7Its1YTawwiY1En4eWs=;
 b=VKeaKThSwEPTi+S6zTh6G/RjLY3YhoOe1hCnEaE/qhYEs7DN4MxlBGMne1ZzzV8lnXBR615zJBjK3QjDNFkq078ZyNty58tiUjole4O5yV6FSPKZwVQ5BB6R9oq25cy0PEGfQ4Toj+KP75ccH57+SJgBPgRPP0P16ZPIIC68tmVcHCWPsSTa0JwScj/P2cQ/2k9YxT4p4a999TMaiMHlDpY6CWfDEUTPLEaJFw6fSJAmbK9YUVbGH7HnIQ2htxyjk4Oc/KDleC7gJpLkJZQOeCweQXAHoX1rqZ8fppisE3UPiIOFjZmF7200yrXfrVeHusUKh1VEHLtBn3IJdB0bUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4jdAoevTHHhN2+Y4q/JE6c7Its1YTawwiY1En4eWs=;
 b=Q8ye8UtUt9MX6UKmEN9x4h1gcbpywuNxvdmBGi1Vhv4Tz+cr1NC2K8aTpvg85EFrlrTYlhKtWSIoJGv2KxGs8GljWwnvBUfTiBNTmoF1tEFPWwN+tDfqnJJRfJ9TXh/HPMQUINx55Nwr232a0cFOzKJM8M30az3dDhGZzNBBf9NjD/ysm8jkdYDBio2LQtk2XvEF8paXFfKCNSh8aa2GTj+/wXj0xXvAQHu8kImwRpLJcQy2ID34DR2wo4w4RB4zN5fuqoJk04WBiFN8OpEU/ZppbaM7lpZ5VidmRsUpJT0D7o532zWrOnTkmw+CVeJJFblL8yYiNOWiLP1RPI2NKQ==
Received: from BL1P223CA0011.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::16)
 by MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 03:15:37 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:208:2c4:cafe::93) by BL1P223CA0011.outlook.office365.com
 (2603:10b6:208:2c4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 03:15:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Mon, 18 May 2026 03:15:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 17 May
 2026 20:15:28 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Sun, 17 May 2026 20:15:27 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 17 May 2026 20:15:26 -0700
Date: Sun, 17 May 2026 20:15:25 -0700
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
Subject: Re: [PATCH v2 6/9] iommu/arm-smmu-v3: Directly encode simple commands
Message-ID: <agqETancvNtL0lXc@Asurada-Nvidia>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <6-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|MN2PR12MB4488:EE_
X-MS-Office365-Filtering-Correlation-Id: 54907d23-fabe-49c6-6768-08deb48bbb68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|56012099003|22082099003|18002099003|3023799003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	4dYzc8CizASQEx+jk7EaePXPu8GQH2DbyXE9FS7bhgvBDPalja4RjrLCW4ogA+uiiWXrCfzeqDWssfAohRWEqaZha9XylZQB9e2oX1jSONeJuFham6LYDdPk16/LM2YUC563fqQTuCzjg8vdmMhHGpePvT2YHRSUmE/KfuKajfrjzcYSuYqTw6vSwH1x/daktIEeY2FeyphxP8bPDFJbHW9aOTgtV52xYFDzyKtpNeFTPApwi/bbRJnWY2KQyayHt7hn9AlVspUgAqogZLCnJvH9SHFBiaOw4lfAtQ7h3nrOTWRsOiT9Za9j5/+wXXv53f4gX6wJvhQpBW09cCqMdyyM/cvSnQtx1c80HGIeTuBkJRdMzHFbrVd2XVgUTussGT/tvWltZvbjjTVJd5CV1HYCaRV5RAb9XZJLP77vqyJzSyNJhAYlWG/r9X3GHozYD7CWHaRA1pkhBSq8D3xZiKNdKXYQci9g0ssvyus1CqImDnnRiR6pTJB5GtYjnE4N0uM1OAuicNbvpRqkkLPII5tPf0gFcGe8X1ve2hiEvkMrFElB21EqGv5PawcGxmxJdbbExCX1bej5uN81tYQ/mgnDze047xHpEYOIdKcBHMzqAEc1H+L5tSGUoZad1edq+hb6nxCVL5fsRczLZTF3+KqPoraqvKMXfLjLzTwd6AAAA7or5UtLPVrSGj6z0moQrgs/MMn0jfJt3maqWjUgXV2b68d2rveU7pCv07OTadw=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(56012099003)(22082099003)(18002099003)(3023799003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5cVLDkbMLRc/XSmHIcdnBnLIb8wFiMreW6w6rVGo62H0xOkgDT6/u7n63e//1iVV/lOm4/bsLrCe+urum0lhK+ZXTIsslB8ScJ1Oh5XpRGYRN35mEqIxZj/Hz7EwnRTZxePDyc7fevayNSB5hBLXZin9xoCVqjHlkNxMMCYINrgiQyJeTSLc7EgobKRMwL1h1VMZYQ3acVr4I9LrbGe8a6Pq1SGRkwuqHywHYo7nS7b/4u1SfZtGbWi2NLcKri8VxQDN08TR5DUC0EUYTXu8kqS9TXrlPaWw4EZWHCcK/k+YH13kVkMER3X+szqCGvRkgGxhtxcoSTbfJRw+HKeB76vs+uniipZSy3atrGIhgHaELds+CrKkhyfVmXzqz3qQ/2eqscxF44sIHoPYDML3AkqTpwBi/kiLit0Tpf/qdxKpRZzjjRwSKCesVIxEpUMf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 03:15:36.8819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54907d23-fabe-49c6-6768-08deb48bbb68
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4488

On Wed, May 13, 2026 at 08:57:45PM -0300, Jason Gunthorpe wrote:
> Add make functions to build commands for
> 
>  CMDQ_OP_TLBI_EL2_ALL
>  CMDQ_OP_TLBI_NSNH_ALL
>  CMDQ_OP_CFGI_ALL
>  CMDQ_OP_PREFETCH_CFG
>  CMDQ_OP_CFGI_STE
>  CMDQ_OP_CFGI_CD
>  CMDQ_OP_RESUME
>  CMDQ_OP_PRI_RESP
> 
> Convert all of these call sites to use the make function instead of
> going through arm_smmu_cmdq_build_cmd(). Use a #define so the general
> pattern is always:
> 
>    arm_smmu_cmdq_issue_cmd(smmu, arm_smmu_make_cmd_XX(..));
> 
> Add arm_smmu_cmdq_batch_add_cmd() which takes struct arm_smmu_cmd
> directly to match the new flow.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Pranjal Shrivastava <praan@google.com>
> Tested-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
  
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_cfgi_all(void)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_CFGI_ALL);
> +
> +	cmd.data[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);

Optional, might retain the note:
	/* Cover the entire SID range */
