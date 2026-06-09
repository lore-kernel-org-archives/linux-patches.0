Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0953035AC18;
	Tue,  9 Jun 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016778; cv=fail; b=G2qRjYe0s0lsy45TY+D9UfgJ+rbiaPLuQEKcv/wjCj9ZlE/OyBy2Dk4QftOFaU+ogwM6qrShJhi+1fyTBUIvAsVh7h2KUlllK6kvtzjd8J8cUpNDp7hapFDwFNW2hiHwssbJOdNjJi1OR3tJoMf9EXMhrac7coEMxkJFQfzkWCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016778; c=relaxed/simple;
	bh=pcT8hsOX08nvGTD6iGk+PjklqZF9tbu2kVL7gP5LxEY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F96FPKzjsQfTO/0OfcbZJp9StUkn+YlVEKlatYA/mWYDR/rOqJYUNUpVwbcTeQg1bdgkczGZjDnBMAovFBkYBNMq19ozKVKlwYV2JM7p4dvxqMyLNHrXkrsWddqHNpAiE6WUEIQNFgiH68oJsiDW6+MmbuYTc9hGmilgUmvUswM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BzFi03/l; arc=fail smtp.client-ip=40.93.196.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BzFi03/l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ox94ejYxYqwTZA9HVMmf+wZEc6UZ4zmO3ARU8ZFERm0DpuOTuFMLr/ew0YuCploUjU4dNFxR/beISaAbStxiaIcfg0o7HtmKVZ92q366daVfbYjH0we5ElFZ8GOG9cwO6AyDX7KDa5lMJAlzWJSh2XV70uFjoHYnfA4aA6nQzApGjEfGjZcIfJ5F7h2M+u3pk5g7hk3oBtaRYAddVCqVSsGlrYINMzyzg95VsG5dDN44f0qEMaUtz8eItdjcXi2iyAr9Qwi6MPQ/2CFGP0u5EyhkiImc+PaoSTzScDe99RyvHf5tZUvQHebFJvtAyZ9YKlQq3qW635/A0VCUEhT76g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmjkTkU6954Qj/e/IKNEOCiXuzWGs6FV/FxjNYZ3U9A=;
 b=Kzn1dcFCog9MA9d3QJwXTpp4eaKdkOR0EAGfF1k4OwGoVaidmueOa2JWpmkCt4TyDpJ/1GX3bd5uRfiEs6UTW8ZQcNn3PrPq1FLQ9FgDfhmqHsmBQ9vJwrXMbv0QKg9Hu7PhyeONDJHvtWlxxIb+7as+RmCZFqoCSRIaoGjLYVuz+0G1ZLRXVZ463raGJgjuFwd0AR8qdwKmoSVhjplW8jZTDg5xA39m07nu1cdrOEeN82qyztirPI7Ba7P5TiQzy73UKfdn9IoTOswgFepA56HwO7A8DUtFRz7kO2NaH9qfIvTw94EdXzUmu1qDy7OryY09F9k+IXE4fCQPpknQJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmjkTkU6954Qj/e/IKNEOCiXuzWGs6FV/FxjNYZ3U9A=;
 b=BzFi03/ltkAAn3JT1tufPPnj8rwzBdCphR5wtDBKKyD/F01PdulNSGWi+CLQH0WtkrBACH7llORrJY1IkqtjAsPm5erPu8zMSuFmfGG/pDuhNofhKw6BNvWAlRi+pPtbTscsKohpRyuw6ZhVAxEjte6P6u3N4QZ7mUIjwV1SS/RqS/FTmdtmyElfqyelgWdNbKu8w6Tzzb1f0S05z1JH7LD8kh9qVs/6YXIcS6MWs+xM+gK8gxhxkK0gNUybrQFp7Vwy0c6Qossiz8IKUNddYE+nGc/rONs6CYT5+8E/yxuaGwcShzgGwwxhmtL3npkTRDoJlMOq8ba6aOH4oPtI0g==
Received: from SA1P222CA0177.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::25)
 by SJ0PR12MB8167.namprd12.prod.outlook.com (2603:10b6:a03:4e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 14:52:45 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:3c4:cafe::2e) by SA1P222CA0177.outlook.office365.com
 (2603:10b6:806:3c4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.11 via Frontend Transport; Tue, 9
 Jun 2026 14:52:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Tue, 9 Jun 2026 14:52:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Jun
 2026 07:52:24 -0700
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Jun
 2026 07:52:23 -0700
Date: Tue, 9 Jun 2026 17:52:19 +0300
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>, "Robin
 Murphy" <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Luis Chamberlain <mcgrof@kernel.org>, Mark Lord
	<mlord@pobox.com>, <patches@lists.linux.dev>, <stable@vger.kernel.org>
Subject: Re: [PATCH rc] iommu/dma: Do not try to iommu_map a 0 length region
 in swiotlb
Message-ID: <20260609145219.GC327369@unreal>
References: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|SJ0PR12MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: d4c47e18-299b-4639-9936-08dec636c3ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700016|3023799007|6133799003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nPqoTOOPD9vFlYDNrqLRYRO99xCHXtxG8wYu4sQ+3XOM4cCebjzlZp/A2mdClHeyALQ1+oY+9mHonMD9AzKIDXpr/gXfGZmPDNNpM7Hd+UH+kCtqHE8E2dq3PE24+QUJ+nMVuXHFrIBXIH5/28b2kstVaabS1O6v52VuVWDUmoKOVVgVTjOsu2aUGl8pDNQ3P57OslMapQGPnShJ881BrFjiDjciE/TxNagicQiZtAeaFB7v3uc2DP0hDPhnFPeLa3duYUQ+7BhfkB8JqwvbTakR2jAdtIKkMPOv88nnGQlG9xIwY17iWJPFmZb2GEmG3jCTC4MUXw5OLYxNtXS637d1ffCZd2+Mg93a7bMj9tuQzg5M0X5aoYzbwBPT0HEjYSCTH2MygtlfVGiGfr4oZudo9QBsXxjO61riCwNj3FchgyNTrGI+oVNnL64w2ZOKfbage8lEA5P9JrAZyGJvsjkTjNQybPFt5NDZw/tJbpcvmh7j1lEd39TelCKlTwQWkw9BxqXJNdMxQacjHSuMMIWiOvcL2sD7KYwXEDukEAYFwLOEPOKyG9jpzN0CvTQw7t27OdwS1wF5MI28WRF6YweGrP6rW3TjUrsUK3n2oalqV6ShHoceFT2LpBSBKUgFfSqQROwq8omrmqetTKQ/33qyTmvIDTuln8wv85JLpFlEQ6yRTYotjBvbZOaGh5aUXNcjZ1+grNjynicPw3+WxZc2jYAh23V9h9owKpneP4o=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700016)(3023799007)(6133799003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pIIZZwj/OcjKPMG81OjyJc7uEDOtQLXo7c3wc3/q2y7vJt9V/JAgS/GNrqgV34LlXHvmRwPuOGrNR09bwgcuMayuLgihb4KV1ei6soHBY2iQy+AZstS4ANL7sNMo4Op85Gvo6cCPhpuUmHQPEPx+SlR4sIp0tZv7jJ9dC1tuC0GtGLzEGzOsbmvo53Gl28EZkm75GQRCAEOkQ2LNCuZ2yzzkw8XDlPCHWFbyXA0D+m1+dPJHb8/Nt2beFsp2SldcbarRtCAUimEnb5V0pL3W7eEDt8qMikrZKN9Dba06qZy7jF6H/6t+u6/eJXmMf99D4DPIMVFsLLLNBwWZ9sHOp0wZmiNAAIeAcQzYN6Jxzq+DSVTUjbv/vrdFvIvP7VfyKHmPHt4s7iBqXd7Ew2t9YJL+vISnYl6k4xnhe3QY1F65qRhe+FxrzsL8+35odEnH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 14:52:44.9285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c47e18-299b-4639-9936-08dec636c3ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8167

On Mon, Jun 08, 2026 at 03:10:04PM -0300, Jason Gunthorpe wrote:
> iommu_dma_iova_link_swiotlb() processes a mapping that is unaligned in three
> parts, the head, middle and trailer. If the middle is empty because there
> are no aligned pages it will call down to iommu_map() with a 0 size
> which the iommupt implementation will fail as illegal.
> 
> It then tries to do an error unwind and starts from the wrong spot
> corrupting the mapping so the eventual destruction triggers a WARN_ON.
> 
> Check for 0 length and avoid mapping and use offset not 0 as the starting
> point to unlink.
> 
> This is frequently triggered by using some kinds of thunderbolt NVMe
> drives that trigger forced SWIOTLB for unaligned memory. NVMe seems to
> pass in oddly aligned buffers for the passthrough commands from smartctl
> that hit this condition.
> 
> Cc: stable@vger.kernel.org
> Fixes: 433a76207dcf ("dma-mapping: Implement link/unlink ranges API")
> Reported-by: Mark Lord <mlord@pobox.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/dma-iommu.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> This was discovered because iommupt errors on mapping length=0 instead of
> making it a NOP, so it is an became an issue since commit d6c65b0fd621
> ("iommupt: Avoid rewalking during map") making it a regression this merge
> window.
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
