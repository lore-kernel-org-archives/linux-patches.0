Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA24541E6BE;
	Tue, 14 Jul 2026 21:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784065399; cv=fail; b=Mj05f1d3jagwVL9kSgor3sTRsX6FZtUU++HlRWiUF0rI7cj8nMJnsKlXxzmTAD+QtxGPZW8hdHfAxUoI7AOoipHDkAB1W4uh6/145soVu55Ondes8ACyiTjuRyy08KW1KXQ4M4FS+MXrhs/RTWXr9eNxmqVwoUVgVY9yYu0zPLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784065399; c=relaxed/simple;
	bh=Am4TTqysd2zjynDeDfKM8dNXPEJqqLfmDTI8rZQeQGs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NqLOJnTOZvRGEjDGdx8bTT0+rzoYmz8fyUcydvdePfn0AlDY8je8LDRFRiXl5ZIeCTmHAqoVv/TvtT92Ldj0LTudSh1mjV0LiAk+o1xXzBgXWjW84YaO/NjEVhi9+oBHJSkneaNXQH2886dtu48MMfiHmMSU9YsWMmJB+RGJz6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NZGuKeED; arc=fail smtp.client-ip=40.107.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NZGuKeED"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqqktgXSBSx2xmp+DHyKEjIa4MfKv7oH6GJskMMBtoMxYWsOPLD/RgZQqMkexCwYzRGuW3vWtMPsLeIelPXIZ2jxKay/Y7aP7TlWXTNGyXZcpzdkGRdaX5LooL80ptQAZ/TJgksiKUoCH7Z6C05W8sJLNaSBK4fwVWQw5hUYRmtwIpxhKgtHL2YEDgZNYmAlncZSiFUGSBZOyjf4cG2QHm/ABJDtWnzjtIxnZU73K/t01jvipnsv9N6z9157j+CQ70sRoGFTc+Gi0cYkkxUVSKQMqHdf2KEzy3Yxaka1d3HksWVLCDJ6bJmpuyf0BCuu0cKpi7soatioNx9B9aig6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jp25cGdFWPegj+l2hwK2cryM5V2pVbptsdKYRXNVGRM=;
 b=XdlGM4TlTPWMxSQ1JKGzhK8VNzNNMgE1YDtx4PjgrxGWLYzdwjE4mIZ6nZuj7nOA53u/NQt8iQCRNWe1V9dGNf/7HCucAjmEbkxjx8nswr+ik/sI096lv1mJXLr2EXXuzlv4XSVg/uo/uO/OHlDOYnWqXOjplAkxybvt26aV0RtIEk2t8PAq/rB3SGRwmaSK1CAI1DWKsyRqoajv0W2QqZHwS65yXTKrCpokxbAgqR383axyAsZb+RwglQ+js8sFpde1EsUdkYqAcQc+nUEbRXCUb9HNLWwovJvPFzR1PzVyQnfs8UXaUvoqLARYZPAuDJfx2xJWAFyFSIA5eNQyJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jp25cGdFWPegj+l2hwK2cryM5V2pVbptsdKYRXNVGRM=;
 b=NZGuKeEDWFGumHa1oaena+U9U4xgTEyHcl4WRQP0Zv9oBShyaevEV9o+Jw+C8pInGM6Hp+gZL6apaCMGy33sB463ucIJeMcPnzsIfhl4eVedI/cneDuxqd7nqsNnlr0aP+fyMcE7KloPqUTe2H9HYjxnnnwMhqIJD9wrrZSdXOSVb40asxSPDJQF8XpijXdEIvO2RZ1vdiRb5AHHhsHG04aNhxi3G1wlZk+vKiZwokTjNDdmA8eU1KJ6zbJXzM4qk3njTbqtIDlStYwzGyisOdfR7f9ELDw7Uw6VJtlng1aQ8Y7chbkuWBGGD2XF98vhy6pHrag6qywztuvgdpzUBQ==
Received: from BN9PR03CA0589.namprd03.prod.outlook.com (2603:10b6:408:10d::24)
 by IA0PR12MB8422.namprd12.prod.outlook.com (2603:10b6:208:3de::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 21:43:11 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:408:10d:cafe::3f) by BN9PR03CA0589.outlook.office365.com
 (2603:10b6:408:10d::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Tue,
 14 Jul 2026 21:43:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Tue, 14 Jul 2026 21:43:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Jul
 2026 14:42:45 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Jul
 2026 14:42:45 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Jul 2026 14:42:43 -0700
Date: Tue, 14 Jul 2026 14:42:41 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <alatUaE6LmsETvnz@nvidia.com>
References: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
 <5-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|IA0PR12MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 4459db2a-1a59-49af-268e-08dee1f0e5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|7416014|36860700016|1800799024|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	3KBavc24e5WVvMNBrl4FXobLZXiYqG0jB/gTafJ4l3hZYe3dv+GLl756VSlihW6MNNb0hobHTAoxkqtD8BQx9p/WGL+LhApdDSZC0WlTQFb8St8uFoV86hxyl6uCCAgLYecTOt7ymcmBkp+N7qBnERh80pUFfR5dFlhD/1zagYLQIBAsbaxeURR4Kc0n4z2UFN+mhvovI0PxM+/6B0Zl4JDKyg9vfcOP2KNblZTiQpjDdJSXjXHSTRIbdpel7puaJpTR2ZEXld3ld5b6FhLQUEPCQ2p7J4/vCdrhOv3htj0PPP/OLz5zm2R0GrcEfX3EccZIE8cUmjaWCQ6iqWZ8CKggHn7QpoUwA3Y0IntAe/aQszK3LxFxjbmEtJEh/n9OBcVuPRgjZJ8xMpEKd6DR79Mtnr867qVuH7z3mDB3GJbTq2Yy9AzhS8/jzArsjra0HcK91J29+dKxyX7rLhnOWsgeCszlFjJmxF+ijMTL9YIWuS0KsZqTa7765jGqjipgF45BYBAM8gUjhZNiXUxw3uWdUJSASd8sCVL8klSSqJX8y2QPsTBvtPMTNdylkmfqY0I4R6YU2SQ8W5tRFoAo44eLMmJjMSaXGamG5hB6u4/KGV8/ZFyW1FTV2HNMM1RjYeF9D3N7any5W0/7MqVY7zLNn9EzPBFJAD+20OdFeEhC8wxuUK/C9lNfbsFtLo/77r82zjJNx234ZRkuEaKUeA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(7416014)(36860700016)(1800799024)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1sNaTU6YHgFvbAhT8wHMVxehgVo9y3PPPCxx+3HR3gpSbafKEZMEbZ4wsd1U+vvITLv3HZPEcP5hogrxiGg/4rTY8f+xlmq2gl2KJeLBhgo1zsoJyVJZx7PYZa/T+itJol50MUY41/jXLQjzpIQrWoto8Q+3D/DW1n9GN2+RfCQ0zlT5anweQwEbYp4+DL4d4yS0jQwTyZcExV8lsbHIWq0tO9MQjEgAN59iJuPdQh8vx8kzV/25TxHKFR6ermbVvjhc0/OYYaIUxXcd1JDUMB1U4tH8VDmOXF1enHmCiFT4KcjNzjo7/RTN4Rd609Gd8IvrnIwFebvj4/601nnOqt4hD6qo8Ri7cK6g1l1EmuNmuKAhtCCcWLqRI7cSfqRMYmil9upaD8QXCSQwBEfZ+inqKb66QcJ2+SjRbO3/rk6F9jJf+NRFzd9LJH/1Vbs7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 21:43:09.6499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4459db2a-1a59-49af-268e-08dee1f0e5e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8422

On Tue, Jul 14, 2026 at 03:46:05PM -0300, Jason Gunthorpe wrote:
> Store the required cmd data in the tlbi and just copy it out when
> processing each item in the invs list. The cmd form only depends on
> if the instance supports RIL or not, otherwise it is always the same.
> 
> This avoids redundant calculations for each invs entry.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
