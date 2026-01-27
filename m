Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427923093C0;
	Tue, 27 Jan 2026 03:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769484517; cv=fail; b=hLBGdbDtgjNn9JA5lDAIeDNt0XgzFs+PFzTvhuDiJ4LeQBsR6Kqsdl7JjJsXxA70oKLIX3f6MncwXxU9fIFoe63xyp8URByo/H1fKRwhE5AWLOPRiQfsyBtrL/ImOxW+DUPIkxSdYeNk6l2D0PUgppLbjs92Tpe8aSiGjA4UYcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769484517; c=relaxed/simple;
	bh=X0rLnaLeAKFuNOaNaowxxXPAsysFx+B6MehHqsPkCcc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVXuVkBsStpVPAtocYUfCUUmh6TBOFNy1CuFVwx3RB6NbogmMQMh6XEkSEsGXyN8R4gzUJu0LOgxagB8EROuLUGb1RO/cg2tutswiXTCyI801YjJHFvTnnzeRMiC+wJweIsu0MRJ2OYgPNRPT6IYR+v2BBnvf61Dl2HQJ65MZiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GCCxhP4F; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GCCxhP4F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fuitC6cx+kO+u4j0DODSO/TBofHgzRogctzmUWe7Bu9Z37EdS/w1t4kLnKMfS4UbNf+cQpQPFbkhqKU4UuSIOKbyJTOuee1a9owh8Q3oHWErKtvP7UfB5cFNZoz2jwbZNLIy6tadtlZ2r9rAuP1VRPssjNGVn5Tkla0BR0TXW7mLvZJOUU6sRDytaMj2PW4Iaykf5LFZqhRGYGo/qpyTOnTNNDFNbYYexT7GfzYfTwR/xMZmj7YjPgCPHMXmLfo0mvlIcr9Sis6ETCBBl6ntLvyrk+Qo4J7Br9EiO1NgGySPls8ZmcLFG2wWpju2nNXOV3LTLu5yFNL13HbuNQqmsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3BVirLKhiOqd6RVD5q+Y02m54Z2HYnU6z+App7pQoTQ=;
 b=k4esKuaZwOXiCjnAJ5iCiogNKWa3/ZS6k5RELcC6sEUWiniyTuL5t7CZSetXwOWbGJgtxr/iXTmVPWOeUI99cpiv8MkMEnQ8pXNozE1VaTLU8RC//k1gbNF7WU85GTlmt71RSaHMdh8K2rDi76/xG38JmmyCAlX4It0PgeJRVbprDIGFUVeUyIWj1sr4/u56QxzWrn37cuRZ10lS1NLLSR8i9hIGn+mrF7SmHsLuSf7jRlkFDz7jY1PK/Z+5CaJjmSOW8Fxv/mH2jSWJoUqDBnFBYtgIfpE1a2NbGA+OP0fjoRQIQWBktA32/19EDN5cgUsmxtyKjHGX1vN69eNB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BVirLKhiOqd6RVD5q+Y02m54Z2HYnU6z+App7pQoTQ=;
 b=GCCxhP4Ficg5cs+6o+kuSJvX7ZSIufIdExf8IgFlIefBdQe3azD2kavn4nddXfSoVkR9USe9uQehiFrRd/5eXkrDGxxJWtQV4B5dGaxnNiyi27CDd1OQG1yEr2kqs+eUyWG2OfUt9TJsMSiL2qVAhQpEGL5/Dt0sck+42oZDwLjD8Pg/iUJ9QkVyQmV38PR+3Qf0IcZFeqG+fsyFzX9wLTpNh9venP09+DCFPZLtFVrwcSL8z9tRBAsCc5SNLkAyfExnUq4pnSrcjp406b07eLcJ0vLF4Mp0O2za1yVxXqQn3ynE8jnmmFc3eAga0ubBPE2yGndTtK40HafxSEtz1g==
Received: from SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30)
 by LV3PR12MB9268.namprd12.prod.outlook.com (2603:10b6:408:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 03:28:32 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::a4) by SJ0PR03CA0295.outlook.office365.com
 (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 03:28:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 03:28:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:28:26 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 26 Jan 2026 19:28:26 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 19:28:25 -0800
Date: Mon, 26 Jan 2026 19:28:24 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 02/10] iommu/arm-smmu-v3: Pass in IOTLB cache tag to
 CD and STE
Message-ID: <aXgw2Jozu0pwFNFI@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <b151df032c200f4c1123bb184102665ded00351d.1769044718.git.nicolinc@nvidia.com>
 <20260126205358.GA2140991@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126205358.GA2140991@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|LV3PR12MB9268:EE_
X-MS-Office365-Filtering-Correlation-Id: 4baa2bb8-4af8-430a-8b96-08de5d54255a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?04fVqESRmsBfxyF+kgNt81LCsWTob2kdEOfLUEvtznUqL2no3J7RJs8SOy3K?=
 =?us-ascii?Q?myPPftHO+GzEwbaEamA8Guq85nODDZzpcYGvLgT4AWwUnmuxYOPl0jL8aKjF?=
 =?us-ascii?Q?sNC7tqegyrMT5AIwQyfQygsZGRlYKt9NNYzIJR1C90W/7G6C4ybqdFlHVmUr?=
 =?us-ascii?Q?bBlLSDOqID2R7Dsk1v4smJXIJe51tYE0yxu62wNaUrqR+/M9jWSRU2D+aWTj?=
 =?us-ascii?Q?sZXsVWHaRcgUCrZ+w0yluzHRdFTwFgvg5/cY8S1y6YljG6cMQOZibiCAzNZZ?=
 =?us-ascii?Q?HhDBkS4gQgKzDwmrUtvA0mZey3u0Nl6wBSRF3V6i/3S3DbBngAbFeHt5uewc?=
 =?us-ascii?Q?+V1YhboW22PavarN/lWkwSXu2ubeDh3n6O4SL1tfXuD9LS9mCMF1y3hwpOxl?=
 =?us-ascii?Q?G0FVPzCyeMzFCCQ85k/CEmD6NzPNJArO4ZGfgz+VYZn+rN3T9jzbJxCUh8tk?=
 =?us-ascii?Q?FthKuyX69ZzHztkk86EOBFhjd8QHdhKBnVmjBcaobLHv0eLI81gdijQZ4Ghv?=
 =?us-ascii?Q?zOWX3fTq5lw9KtyCeKti0v8QqAYloK0+DZpcp8o3raKA9oQHhnw7kceieCab?=
 =?us-ascii?Q?Ee3b1gJDs/lis63P2gS7jfeTjlblakbvoKcjEReI1V2KqnzBB4Dxmh6N/y/f?=
 =?us-ascii?Q?Nq4HM8RaVXY5zd45HSvUd5n3aiaHrYmat+Z6f70V2mjdpV6vLTSRRrysgmNc?=
 =?us-ascii?Q?m8kS0ZFPxs6HWlBa9YSzibK7Mq5UIivG8Kv+yBo0QJ6qxLe3/QMMoq5x67CV?=
 =?us-ascii?Q?ws3aOD3zd3J3blIjizrqvqN+50E1LTHQ9GjET9fu2a5xHRiuwxsXFff4x5Dn?=
 =?us-ascii?Q?asPBHlra4WV90vXF9gyt3D85Eegait9cc+cTg0kNocOpd6ldOk0NFpdqWxjh?=
 =?us-ascii?Q?WTGMZrmw2pEbxWu6Ux5DU5vNbjHLPUpbgOscuf+JJtHstvliodf2KsA4Ci2B?=
 =?us-ascii?Q?ZBEesd0JQJVyFNZZdgVhfMn4ze0nGpad0jVMDaOMowdNxSS2n+ksA5E19xe1?=
 =?us-ascii?Q?apSL5mUo9mj7PNkmjKCZtQw69ec/MMt/Goq5oOcWo+iJ7laJ9g8GwuKWr1vJ?=
 =?us-ascii?Q?IYiWkbeqtn2dNZ+zj3utRzv3g/K9oIUpBwQYlN3SAgrMyw8x99zgaW0wtU+e?=
 =?us-ascii?Q?XWdp56UBryu1KlmmUweoE8INZnajlUncrhB/Px7WSMYPegF4eKxwjL3KP//V?=
 =?us-ascii?Q?pLaSbIhf3N7PJCu+luBh4fxOee7T+QWWznZ1WtUxZU7l1XPga7At/AjqxPw4?=
 =?us-ascii?Q?lyKN5dDaenC50o3+r0fHtxASeP1kW6utoHWI4XJOBJr4QrA5GV575vOJaFAj?=
 =?us-ascii?Q?Pi7wkJeNXqFmNyCLk8SReejoxWnZ2lyrMRlgH4aeWlmaGSZ2Aay+iaq2hhyc?=
 =?us-ascii?Q?v59z0nbsPATY4rug/+4JOJ+Nqoht0KY2toscBAmCUqGXASsYbZTDmuac36Su?=
 =?us-ascii?Q?3IxqyPVkYtfn1INbGq1k7HM9+237f5/pTga95yH99SJhbk1nkzqGOz2i4tpR?=
 =?us-ascii?Q?3JDhpucYC6H62pBnnTzCwO8DN30ZoaKWo0qmxIMtkMMrtZoBOw8RWsxu3Lts?=
 =?us-ascii?Q?q0zUy+0MvKgKwCQC3ellABzkmOZiMkFRGlIcu9e9ukAIwEG7GSQUBhsHeYWe?=
 =?us-ascii?Q?fpiqWZs3Cva+dyhMSzoWjy5OtMXaHAh1wvYV2bC4imggk9OYBLVhp2DnSFh4?=
 =?us-ascii?Q?SavsFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 03:28:31.8192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4baa2bb8-4af8-430a-8b96-08de5d54255a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9268

On Mon, Jan 26, 2026 at 04:53:58PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:20PM -0800, Nicolin Chen wrote:
> > Now, struct arm_smmu_attach_state has the IOTLB cache tags copied from the
> > cd->asid or s2_cfg->vmid of an smmu_domain.
> > 
> > Pass it down to arm_smmu_make_s1_cd() and arm_smmu_make_s2_domain_ste() to
> > set in the CD and STE, removing the references of smmu_domain for its asid
> > or vmid.
> > 
> > Note the two set_dev_pasid callbacks finalize CDs in arm_smmu_set_pasid().
> > So, it is safe for arm_smmu_make_sva_cd() and arm_smmu_make_s1_cd() to use
> > a dummy iotlb tag (asid=0) because arm_smmu_set_pasid() will fix it.
> 
> Maybe it is time to fix that up?
> 
> I think if you make arm_smmu_set_pasid() take in a function pointer of signature:
> 
> void (*func)(struct arm_smmu_cd *target,
> 			 struct arm_smmu_master *master,
> 			 struct arm_smmu_domain *smmu_domain,
> 			 struct arm_smmu_inv *tag)
> 
> It can accept both arm_smmu_make_s1_cd() and arm_smmu_make_sva_cd()
> then call them at the right point once the tag is finally known.

Ack. That's cleaner. I will add a preparatory patch doing this.

Thanks!
Nicolin
