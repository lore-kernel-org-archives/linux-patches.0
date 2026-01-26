Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BEE305976;
	Mon, 26 Jan 2026 22:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769466237; cv=fail; b=D7IEk1NSvxzzdmqkKx2CPqf9mWwgBRAUYjqp6iwjPyzD/l1elXzbdQeAqhaNcvha8+m8s44w5jME0NQQo/axtfK6MmkrzPUlmI6bmvfZO6//M8OFM0V/zZJvoqLEbRriMjlu3Lph+Y7t5Q4wTyaKiu2Xy9HpB/8/hzKFsYcKnxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769466237; c=relaxed/simple;
	bh=GwfYaozpyEXkbW46oKQRkhLS3BRkFTopsHnADkl/uAo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrTXNK/Zde+YOwyVUXwPpEP1h8aPIj9s9ER2YnGr/SwWbux9RkTKgbT8luS8pKthj1AfDzBNxzvUk/VIL+Q+OpmRxQP1tAMYB38XEo4qm47nvv2BuF/AgBs52uvRF8eVyYqp38LS0uitYBz/dYa+cumpukV8PX3m8Itwc7JdM0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p2dG5nbg; arc=fail smtp.client-ip=40.93.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p2dG5nbg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qEjAqFGWjcVpNQN3roxhHO9sgvxJrbx3rHqbd2jBSQNZ4w9Swr/fXkBvBPBLt/wEsqlv1IZbNPAdpTfdR9yltZyC47iaEZlPl37AkdmI696R/FCWCtgI/5GxbyzzypG1cAcImlVGnWYI21m7MD4PdXZzWXCvVBHQaAD/Ay86mzyFnMGsLPctEvMhS+pBVHjKmICCzmIaXejKItT2a3HkJE6jaGMK/GO1ATdw/XhnWNKKqA5dGVNRj+8mgTr9AW50Xbr2dTsFz4g1iMpuYwHTi2bvpOds/ENlxIu0ocYYJ/nY2oSBqFMHMc6nQ6EefwrDI5f79+daqwHAig39v1G5rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhR4yWjTIl2YacihjTVQ03R41mA54Hnbd3YT7SWH/SE=;
 b=nqRYkS+uv2aiDtErYkP4dvgqdEQyH0bJg89Se1QwJMXuFUFtH8YIVgdqtMmJOW4dXtCw2qq1+bTocNfZdHUxBHTPz05g4v4DvihQnJXI549piP1DFSkuZ/nNOr5z9G1KZIwD7X8CxDHj6+MvtI1T80XM71EDIK9yRsbPHc6qiqPXa6NDYm7nRoHakT+OYIquAfuKVx1bFJ6w9wnX4CJEyClomL+AuwQLw28FrApJ3ETBC+hCXlI7OrhbN1sjhY0x76mxsxpSxy/TAUIeZiEY3S69lePGrLhmuvPD96vOaySUTKqPhl9pLS62gUtyKniMkgwtdlBX7mKFjhu49usvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhR4yWjTIl2YacihjTVQ03R41mA54Hnbd3YT7SWH/SE=;
 b=p2dG5nbgHoXFc2WedvqAPD0j0knGHjofHsr8RUAWmeHZxHD+TIcfyeFW3yMa+OMKbGgJa493K9oFus4uT3p/nB+zhoozaGGoYRPzfCK6VzeoXEIdzGUU2DiFVbqvxYuw/unLX46Sj2S55O/z1NYli/0z3M3PMEUD+QKRolAU5EjK74MO/lBlcUO7373ikbEqcVvuA6HF39XLFHdnF9+8fwnbbxkD2QqSIBqKdoZaWAPYaQg5poNZoeXLsI/X6ru/W5rYc4RyQM0zr2A34XC+sjLeGN5JzuDrJN9LKnzSX98eMObMxPIoLQFhLSHxTDg6OJINnSIHkPEdx79GRT550A==
Received: from MN0P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::34)
 by PH7PR12MB6634.namprd12.prod.outlook.com (2603:10b6:510:211::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Mon, 26 Jan
 2026 22:23:52 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::94) by MN0P220CA0009.outlook.office365.com
 (2603:10b6:208:52e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Mon,
 26 Jan 2026 22:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Mon, 26 Jan 2026 22:23:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 14:23:40 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 26 Jan 2026 14:23:38 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 14:23:37 -0800
Date: Mon, 26 Jan 2026 14:23:36 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 04/10] iommu/arm-smmu-v3: Allocate IOTLB cache tag if
 no id to reuse
Message-ID: <aXfpaN4UCYcY9W8T@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <85f3361fa07ca6884500ccc917da6f6b84e13a6c.1769044718.git.nicolinc@nvidia.com>
 <20260126210640.GZ1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126210640.GZ1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|PH7PR12MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: adde9cb4-aa93-49fe-6f28-08de5d299576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0TEwoPo5IYHUxUIoa62ln/ogkSpB/bJSsma1PTP8utEh9IZYPVcNjWX2oW+y?=
 =?us-ascii?Q?WQmPgCzR5ddw+r1L06xMUMtVy2DomhWmfN2MCnqe+91omf0rNJYF5I0nsLU3?=
 =?us-ascii?Q?BjZ4Hv1L+JyTn51bOutgdsIa5XMVLLOl5d/yKHOhrnkbIxRj3AzlprZ4+c/s?=
 =?us-ascii?Q?ATZ93t1o8YHbRYXy/mzbrOcolFbPeL5Og2Zc/1YeRqUPXVyCtN4rUXf4lDjq?=
 =?us-ascii?Q?RDBLbL151Pf0HghDS9qPFllD6JuU8uspTo/dbIrp00kanVZW5g3BMwCEwh71?=
 =?us-ascii?Q?E8aNnDQoiImv5m0hBBJpOPUY6shUMaPZADJaFysjyJJyPSe8Bw2LdYI1sPwi?=
 =?us-ascii?Q?zMLNxnxfro8lZYigL4iGy2L4cB1wsFiiNFc+dpd3clsMdzP9QZyQM2PJ0wer?=
 =?us-ascii?Q?CqlmKi9emWJEcARKZis/xUSuZaXN0lAAhlZvdzzb6BRVdYiSbqaj+r4Ii1Jv?=
 =?us-ascii?Q?kc0F78adBvSlOP/myubL15zZrtsvi8PZU8m0wdnepUtuWJMM2IdhmPpkX7hJ?=
 =?us-ascii?Q?5hIlMA/AcjXMFKlamvOWfIfNog/lZ0Un1N9AEiSf7scclbVU7GHKvXvvqsvA?=
 =?us-ascii?Q?kyoP2mQY561UE0wiVaAEzvblMlIz/r0IoGIaTKZcKxfbr7yOpNlh+jdKXc8I?=
 =?us-ascii?Q?KEAEnxza3oNHfSkfeXWg5XOqiKELMTdMpw/rDC7YzXp8eOUEJzUInnZjKy17?=
 =?us-ascii?Q?nAKfCjUIIb9DEzUagRvY2RtoFLusLENxz4+/GHS6ND93CH0V5KyhAKw5Hvs0?=
 =?us-ascii?Q?5hpBaFdzrhfjexDhneSGJPVGyLuld2oEHp8yfCIFqUiXuKYwBLNxKCpXWYzK?=
 =?us-ascii?Q?iUyL6K1etTtrMbT0ttkEs+yM0JZlSmkZK2L2zwZFPlP2RP4Z+TnmQLbBaisD?=
 =?us-ascii?Q?Ao+3suNILimSUvdjCqrN3Q4IK3PfokRw0iYVmSEjHW1kYqeRXNTlnnVrSrlw?=
 =?us-ascii?Q?uQPfjNm48Spq//9xeu69OfKrwCJLMPiJEfynbmXodGflkrCzStUcud9MfK0l?=
 =?us-ascii?Q?laoZ6D7T3mTDxPqNZMNxa99SYGd4+aABk1vfKMY39FsrslGFO3fFIUH0EE81?=
 =?us-ascii?Q?8GqznnuKw5MF+b4WjLxY5n9xRJ1X7o6zk1V3OC1M8IrQhYQlxs0ZirkuWPhN?=
 =?us-ascii?Q?p+d5vNKWXJzS4fPrUSovX75GOhQvvWsXZ1ggRPG+SaH6O3JSLJlFmFtbYtay?=
 =?us-ascii?Q?tY3DKHwnYAkj069X9OTyfb2H2I7ZMHyqGUMmv6U3pkxlZlwdhYrXunITuwSB?=
 =?us-ascii?Q?cJ0tlVO0V2fB8O5g+D/StpVjK6oarenozErSCrXqxU5pTypaL//dopOvhBb9?=
 =?us-ascii?Q?Tq+d+4fZfWgODRJWG5z+LgW7fTooRsPONaD26v+tEoG+/p9RZa76t/NimqQA?=
 =?us-ascii?Q?ef/yKITv7HCLnq71Z/hl1cWMSt4u/oYE6PoqiGHFdlu2WAsfnduQOAUZ4Iyz?=
 =?us-ascii?Q?JCdGrzuEbImwdiMovqaFMxxXwGJ+gH0RywRk4dcOsvjRcc+asnCcNpPqC7k0?=
 =?us-ascii?Q?IA/F9yANtjN+sStT3tPBdDxaW9OhJExnh9x+zOujc6I6QAmm0YUwyT3u6oeL?=
 =?us-ascii?Q?TYHQ6xBCE3/MOeXjrHQhhuTKDZ6Yi/PDsz8G5yC8+EhAaVO4W+94I77+93P3?=
 =?us-ascii?Q?WOaDHmzDOrdLwKD6iDuQceKUWgmp96b4QjZqho3cgNYwI2HvQacTrSFUcQF2?=
 =?us-ascii?Q?Na/kvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 22:23:51.4002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adde9cb4-aa93-49fe-6f28-08de5d299576
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6634

On Mon, Jan 26, 2026 at 05:06:40PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:22PM -0800, Nicolin Chen wrote:
> > @@ -3220,6 +3241,9 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
> >  		break;
> >  	}
> >  
> > +	/* Set a default users counter */
> > +	refcount_set(&cur->users, 1);
> 
> I think abusing users here is a little too hard to read..
> 
> Can we just keep track in the state somehow with a flag?
>
> Or maybe union in a "bool needs_free" that is for the on-stack version
> of this structure?

This doesn't only apply to the case when a tag is newly allocated
during the attach, but it can be used when an old tag has users=0
during a detach, right?

Hmm, perhaps I should have just followed your suggestion, letting
arm_smmu_invs_unref() set the users at all:
https://lore.kernel.org/all/20251219170551.GF254720@nvidia.com/

FWIW, I am hoping to squash this into the base series (v10), so we
wouldn't add a free_fn function pointer in the base series and then
remove it in this followup series.

Nicolin
