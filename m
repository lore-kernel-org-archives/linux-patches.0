Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A48433B3;
	Thu, 29 Feb 2024 20:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709239706; cv=fail; b=GjM9XsnCx2uzDMdyahOi4dpSv+F7WlM2xdUO3BWy0fmaTz+c/IpagOBaJOdDtiG8/E6dDioqw6fjBn2qdBvIESPkxjLFV4MZfV5zJ7TJmG4O9dm5HS4fyCAbiNbOs7X8rmbnNdFF+umOcepwbX1AzC9WempLANiZXqYcAl8RiGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709239706; c=relaxed/simple;
	bh=+9xHp0v3HrTZcjjF1Yk+O1ZBkpicXaBgXoGj5OVUhGc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOedfi4j3MXg011gSAEqujP0thEFJUk6GL6Nm7YAboPCjW0myMo5AJs7Ra476q2qQJGoHXTubuFdZd0ivxk/9zXIw1Znaz+J8q5QPTP5pK+IXn2I5GUzcGUyJio9LezqG5ngCsMHpBHVnm+2UdiSpc5bU+zuoGZVicdWtIkyeUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eXOgXHnJ; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eXOgXHnJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9eeqbSxMzMhpK6EDW1f58fIGKNhlvhoPg7wYz/E4elQGt6KKvPqSLQ5OEZqYjHJuYsAbkJq5BT6rDYVylWeC7wuR09ZNh78Rr65gWYuRpmBzolNzGL3ZLpviQS9K1z6tyKFaPfnGIi2BCib1UKBYr/XYsDpVxeTGyRfKJG0anjxprHr8PEUNAkVaaZOB/1Z3hnagEzwv0KW3yix0h2bfl4NZ+NWdx/ISZdprRwBcpoKZfhfJivVt/dplHUmF8/gAijCT3odPBREM8IlJqU5z+VbtnFbT13AnoA+Gitg8LTsmvZUYYFXMvrmQWAP/og6flmji7wc+1PM0/G/UPhmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cl5aI6IKxcMmZNyx4M6C9vJaSBfwoTykm+mY1PpdZk8=;
 b=iwBxGHVroDbQQNa9rVq7kils5DpUO5zKFz8hnoeMJbZQpucPk8kBbnu3Bb6xvi/0xgYvt9Fh70iNrOFgJu/6idUjR49TS+YgTBraKTMGhOWE+zDVO+sA24yCgzZdY3rr4iunGloQuZoYh9d5oGvTk9d4qlsJz5D7Q9NnjAtR3w0rXGj3cDVEIyvQbJT3CBV2VyVRPuCr9gounK0zQcHWrDVuCGmJAbV+ZEi2qRcoD8msQ86IrIHNv5SXoy9Bo5pOeI09nJB5nLF7vdmGKwQM/7dr0Z+5He2Y4Z6Fy9OkZOE2zgR+CRoCgb2zXxt73xnML2rJlHRLBJy0RXtS9QB1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cl5aI6IKxcMmZNyx4M6C9vJaSBfwoTykm+mY1PpdZk8=;
 b=eXOgXHnJ2UQQ5WmAubAGoID3pv+KXPSRhO1mbM78B4+A1J/cK+Uy6HZ3tPMxVKQ2BTjtLUSKNtQcJUuaxp2dr4ZY4nWpACda7TsqE+NeJgB1Sfxz/CO5Eo4OacRbQPRkK+iyC0kpB6H0CEULhD7u1SD4GKJewvwINsCRoYBf11n68rrpRIPSGEzhmqPtqHiEmooBnu63xHaRMiHYRTFkiFJwFhF86BgEBMoUxjMJzglyTJsx79drfCkJ5rNZFKaETcLdOSFkiTJRP8lql5t0V9kW38Zts2A5Ab27VA71DNLA8/rsX49fHFv0dHLrKWe+t82OL2/LJCXpzmuTneLB6g==
Received: from SJ0PR05CA0156.namprd05.prod.outlook.com (2603:10b6:a03:339::11)
 by MN0PR12MB5955.namprd12.prod.outlook.com (2603:10b6:208:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 20:48:18 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::e8) by SJ0PR05CA0156.outlook.office365.com
 (2603:10b6:a03:339::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.16 via Frontend
 Transport; Thu, 29 Feb 2024 20:48:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 29 Feb 2024 20:48:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 29 Feb
 2024 12:48:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 29 Feb
 2024 12:47:59 -0800
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 29 Feb 2024 12:47:58 -0800
Date: Thu, 29 Feb 2024 12:47:56 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Will Deacon <will@kernel.org>
CC: Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	<iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, <catalin.marinas@arm.com>,
	<kernel-team@android.com>, Michael Shavit <mshavit@google.com>,
	"Jean-Philippe Brucker" <jean-philippe@linaro.org>, Joerg Roedel
	<jroedel@suse.de>, Lu Baolu <baolu.lu@linux.intel.com>, Mostafa Saleh
	<smostafa@google.com>, "Shameerali Kolothum Thodi"
	<shameerali.kolothum.thodi@huawei.com>, Moritz Fischer <moritzf@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>, <patches@lists.linux.dev>, Moritz
 Fischer <mdf@kernel.org>
Subject: Re: [PATCH v6 00/16] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <ZeDtfKMUXnOnJOic@Asurada-Nvidia>
References: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
 <170921954415.3073552.7948276252050662200.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <170921954415.3073552.7948276252050662200.b4-ty@kernel.org>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|MN0PR12MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: acf5afd5-2660-4167-e345-08dc3967c20b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V6TTtQSYaRy9PDcXZrtJWCNA58ZlApphKSarsbptQWAKlS26xFRwHu6DGpRsuRnG4+RvM2/8Q6yX1r+DDOajI2JakJy3141jlx8il+nATk5g4zuHSIhqxGA8N6JwyP/My37A7OUPHq0VAY9lVuK6aHe/nj2km5ayt+sATpIpO9nAlrfRWU3S0EMBXNCGZCTyQswWf2Fpsxkf1+/714g2tsIk2wY8k/RjqGHd9NkwSjKaXfGay1NVp0k1rE/KMaPm2sxygUzLvg/afj5HLu5XYtnY984cSx9g4TXUj9F2UJzJS9oq+d/e3rIf4YBSWsTxIdUXH6ocM6Dq7tLBwFWYA8k3gwM1VCFNb0mzm+9gRFm/PhS1pu79/MtezQdIh0CpDZ2UDDWYbilnfVCKnuctf7Xu4IdkifDe6m3C91aJuqDzmue1MbAfUaUSOtGCUOSh0cEY+YZEAazMNei7Dug96YCBYMEvlfaRRA6k4cOvJmYIwudbhu9BFSzmzrvcO8gdL/Oa5nu+TnsUCzZCx/Blrfua+PixDhZ1h9vzVed+Aem7Lvm0ZxS882pwWTS1MFHbRcowL3nEOI4QOdvVFLMHiA8WFyraB4TP01Nbucd61C+88KU8HYZxp4/iY9vS9pIRinDFTr55oR1u8pjhdhSO5epugOe7ixiJFCoTb17RHINyjA2GwzsTdhPx2eet4m0+RaBnBPsfdVK1MK+XPgAG11buKxCUnsysva1FyEh5FB0vAebsl9eajbAfKxCxCtvP
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 20:48:17.8022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acf5afd5-2660-4167-e345-08dc3967c20b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5955

On Thu, Feb 29, 2024 at 04:34:13PM +0000, Will Deacon wrote:
> On Mon, 26 Feb 2024 13:07:11 -0400, Jason Gunthorpe wrote:
> > The SMMUv3 driver was originally written in 2015 when the iommu driver
> > facing API looked quite different. The API has evolved, especially lately,
> > and the driver has fallen behind.
> >
> > This work aims to bring make the SMMUv3 driver the best IOMMU driver with
> > the most comprehensive implementation of the API. After all parts it
> > addresses:
> >
> > [...]
> 
> Applied to will (for-joerg/arm-smmu/updates), thanks!

Oh, that's a great one!

I just found that I forgot to leave my tag at this updated PATCH-1.
I have rerun sanity with this part-1 series and more nesting cases
with the other two parts. If it's not to late:

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

> [01/16] iommu/arm-smmu-v3: Make STE programming independent of the callers
>         https://git.kernel.org/will/c/ae91f6552c30

This link somehow doesn't correspond to the PATCH-1? :)

Thanks
Nicolin
