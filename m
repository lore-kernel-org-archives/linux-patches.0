Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012001.outbound.protection.outlook.com [52.101.48.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119F41DFE22;
	Tue, 27 Jan 2026 02:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482622; cv=fail; b=VKvUB8+VSnqQ9pm806VmsU4a9EqRdViBp1ljOm+wL0bSP2hRRhLvdceT/OVclMvW3QCeuCK/QIRbk+Jv5TqFU4xaZR89j5C7PrVpmsOtx2Cu401570OK5pXy7dc03u6ZHIdup5mIL6BcLQhIFO0eFU5VDTyImkYX8XpV96EAH0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482622; c=relaxed/simple;
	bh=aKtwJu4sUsdBN1i+vrNQxVn/aOSesXMNuPSC5quvyYw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXkFMaje8U/7KHxFNwl8Eg6OZ/YjH0R4QJ0nlRhbimCva08BK8HWLZ5QHucNz7e28r4OkNECaPSdh9HtGAigw6xxxfNKddfpvd4emXskIM4HojcrJR6sirhu79QMYf3yIll6j0+QKtGaK/17P7CToU1D772AJf2DGXIxX7ohVoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KaDBgkdv; arc=fail smtp.client-ip=52.101.48.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KaDBgkdv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UiNkczwY6ysyoSV+aKYVblfJLEWSL8US2JpBhX54VC105YU59CPUSRGk4UIb/bsHB5ZeHNFG2ObPCa4FTGVHvpqrpdpoKHUD/ZPh9CuoD/EVTHsehy9MPpFVoGs9LK65GbuqMTyZc5UkgN8vii/B+QNzLAHp8+1Yz5QdvS6U3om/ZEa7wcLJF9ozfZjW/DDQlZZqjuasqfLpjHB1VVA7qGB334YhCM0L5A4oQkQITrnRnjsTIhfYxjycyTqi93uerh7YCY4gcnhiev3GGmss7UUwKoivdN/KaIUNqmJyXYwRzDjfPoc5BuY/w2NBsV47z97Y+CtN/iOslfmBp5ijYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JeiTvD7So4vaUVbC0FMmX9VQoJbCLcouYLNNipmCD0=;
 b=CTAHyJZGS02S8ye5RNuVFPieMIm9GEd3gJCR32ApaCJp6BdWMlZleSAtu14c7NrwEJkNgD8B/tZ6L4cKhF31YK1M1iNfGH5AL5oIaGFSdxcEy9Nq1/TaZx1Yccw1GZgizlDve88CHyTdefQ+PS4TVckoYQH0PXKEySMpfTzt4QIyOZv6HFqBqFVXIKw72RoIbCEUx77xrwNt8IrGALXYu/X0T0YPUSxtunv+nYXZPvyAakaMA3Yeb7xU/ln8cmKVorgCTZj3VBFsVuz4hgHn8oae90GCl3uCIvQP3FnjnBvif74rFHDhvg/AXw1BzKzMEvO8+IrMShXeMP6vL/6xuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JeiTvD7So4vaUVbC0FMmX9VQoJbCLcouYLNNipmCD0=;
 b=KaDBgkdvH1PkHoEtHZah17YM85hqMQC4XUIiQnEiGnodTk0av7TwxB5UICyMCVQgYdAPI5xvH7RzylzZ/FcAMjXY6x+nSFViEoHzAnOS20QXNE3cNSc6LqL/vDXN3kOKT4LfP1OMqNe+pZH6HKKKiWD1rA+0GLkdIqrHMKlV6eESHgrFwVksbf2hiYi55KpKEdYOfLKDiMFu/8awpgP4lR3ssW1t4q3OIzc1HgrHHJ7pDKrSVDeBNcyf4XvDZRpfDneNyQNL7d37Ua3iCb2ovH/bmChYsGA2ATm84iHXPHEdzj+RPsw3XDfqUyBIsJ3cjYwOt1m/SFEStS376jmuRg==
Received: from SJ2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:a03:505::26)
 by SA5PPFF1E6547B5.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8ea) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 02:56:54 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::e9) by SJ2PR07CA0003.outlook.office365.com
 (2603:10b6:a03:505::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 02:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 02:56:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 18:56:39 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 18:56:39 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 18:56:38 -0800
Date: Mon, 26 Jan 2026 18:56:36 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 05/10] iommu/arm-smmu-v3: Flush iotlb in
 arm_smmu_iotlb_tag_free()
Message-ID: <aXgpZJTWGGVrvqv1@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <4ee324e4f189fed601f4d947af10393b14dfb7d8.1769044718.git.nicolinc@nvidia.com>
 <20260126210833.GA1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126210833.GA1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|SA5PPFF1E6547B5:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c5f380c-0a0a-4448-8c14-08de5d4fb9fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iuU8NuoKR+3t38hnNMLs1s9x84u+tfCInSPIJxH5kQ0bdvGH5D6CPLbxxJRT?=
 =?us-ascii?Q?/29QQavrBAlASqCQfwHujrkzGNdhqppZuTWoPxUm/UNyWs/YEKyG4oEjyLJD?=
 =?us-ascii?Q?LeDTQA72YmFOO09WQY1xX+tGfzN7eW/M+wXecCFaAz/QZ3y8dBm5Wup1Xqq1?=
 =?us-ascii?Q?zck/KWRPlMqw+qKvFZsXpC2v6TT2n+PFstNa3xCt1eKR0mS39KK5UPU5a5jC?=
 =?us-ascii?Q?/OK83wHaLxwav/D8wqeKqLIDjEP1e8/qpaXYXyOMLGwFWAy8ZHswHohEuyos?=
 =?us-ascii?Q?1kYbbpH6vi2QMA9a/6A2qeBuxTYkKov2iqkGGuwHIVc4ZK4LfkDSuWq8e/BT?=
 =?us-ascii?Q?Dhciu8VhU9+fRVHtZVNXfQVmxNqeqtV+eLALxh/53PbBnOy4X11iytMXFVXY?=
 =?us-ascii?Q?xRKjMSNWZ3b233gH187Stsz2oRvXqokzh7BThE+vBof6PqXiDgzvTrAv+tLo?=
 =?us-ascii?Q?g1rXgvcwK8LpuQLsxqpuRkxUg0vEqifT5p92YhYkaWIzsyKf27CR1IITVa8E?=
 =?us-ascii?Q?bW9Y+E2cX1zrWAZ+3cM5GqHrGW+msusaEAC7L6DK7/DgGphVdyZulrYPhdBH?=
 =?us-ascii?Q?IEyCnqMeBzlDfdfAyE2jbSCD8AFsNPVEV55bdRtarggXS6pAGhWJJ4b4UeFC?=
 =?us-ascii?Q?XJIt9IjHd3eV1wXpSvtZVQFB4sMz5QL9CQEr+y5cq1egRvXzvA1RRkTd273H?=
 =?us-ascii?Q?b/to63H+EBDCMU2uXj/wVa5SX/w0YCKZEsZRhXSvAvR+QAIlN0n1k5wbNU7q?=
 =?us-ascii?Q?MyZYp0qPM/Q8lLE+AzcpG7suh/GDpQ/xWphwY3jG14CRWKqBNecAsGzsY0Ue?=
 =?us-ascii?Q?sCGTpJYM5oaXAL3DTUTG6OLJc1Bf8watTftvjZ0viN3xI68vqXnpq0f/OIGp?=
 =?us-ascii?Q?7wRHUPNdPzsugzqRutc2PRhYle9awKiK7PJGN8nomI1YGIJlyR6SfXc7J/a8?=
 =?us-ascii?Q?8DttPATdg3OQk8ZmVL0G83zKUjXpAsSy0Ch2PLRC39URjRCzA6EQWXkrWHFU?=
 =?us-ascii?Q?GXaCZJjI81kUEjg6Dh+Q4UOpPX4KbKAz6Vo6oosL3bIWCc+ULcTI4ZsRB2vN?=
 =?us-ascii?Q?otdsaCpqWgmgELHMF68ttE+wV71ODZW93hioLWG8KsjcyOlrODAIyUvQOfMy?=
 =?us-ascii?Q?pxm5XY44S3NdrngUd0tfGSc2183V1ixxkLnlgfHLBlaydP6psaRw2W2gT86N?=
 =?us-ascii?Q?odsU4mpr836+mDS6EbNkNdoEJAudJN4bb7P/Ggl9AgCKgciW1/vY7WSv2d3u?=
 =?us-ascii?Q?NsCcRni8iVL2Vw2OrDJg/IHd9xripwWa22JAaa5yZpQ/JwSyLc9h4meNWJv0?=
 =?us-ascii?Q?uNOCXbihjG4rrxgBi5EmgkB2IDMcnrAe+9oMdNls95iov27pqOgP8MWZMvVs?=
 =?us-ascii?Q?Idu6ULhzGCl40EEQwE6mhHRs1OQ01/qZd5+DasE7IVPp2gDvR/HVtEpHyeSx?=
 =?us-ascii?Q?k8V6QkYUFGK8y1LEcW5Tz3V73xwSZVy+273jlIhyR5PrPweii8g5rEpg7k2J?=
 =?us-ascii?Q?i4DZWvlXCpaz1bEdt/AeSytvB/KG8U+t6XAR3jEn9ZN0K77jyPmMrlyQpJ5C?=
 =?us-ascii?Q?nIEvsGJ+32lHU8QwUB+UY9yf/BZWCbkb0lh99BmxXd+YlKPo6ld11gOhkOtb?=
 =?us-ascii?Q?lSpIow7dmRUZpt0E5uREOrHhOTmv804b4ANbFofcI9Z+?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 02:56:53.6324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5f380c-0a0a-4448-8c14-08de5d4fb9fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFF1E6547B5

On Mon, Jan 26, 2026 at 05:08:33PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:23PM -0800, Nicolin Chen wrote:
> >  static void arm_smmu_iotlb_tag_free(struct arm_smmu_inv *tag)
> >  {
> > +	struct arm_smmu_cmdq_ent cmd = {
> > +		.opcode = tag->nsize_opcode,
> > +	};
> > +
> > +	if (tag->type == INV_TYPE_S1_ASID)
> > +		cmd.tlbi.asid = tag->id;
> > +	else
> > +		cmd.tlbi.vmid = tag->id;
> > +	arm_smmu_cmdq_issue_cmd_with_sync(tag->smmu, &cmd);
> 
> I think in all these places checking the tag->type it is probably a
> good idea to not use a catch all else for vmid? We have many tag types
> and some should never come to this, or other, functions.

Or maybe we can add an assert function?

static inline void arm_smmu_inv_assert_iotlb_tag(struct arm_smmu_inv *inv)
{
	WARN_ON(inv != INV_TYPE_S1_ASID && inv != INV_TYPE_S1_VMID &&
		inv != INV_TYPE_S1_VMID_VSMMU);
}

Nicolin
