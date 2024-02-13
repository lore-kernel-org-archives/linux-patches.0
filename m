Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB741C75;
	Tue, 13 Feb 2024 14:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707832839; cv=fail; b=Tx98gjkD4kgkfajWa0wbCGc6jZ8xe1yfo0DGYdSowy9mvOfYxux3wWQSYes36UO8xxSMwj9+y3I8GljVJ15+7TKFaxHl5X4sX9Dx9cpiPytlO20y3YYt2V7piehZEFYrulJoK8uZWPOkPqQGk8iqAzYD9ueqRmRue/iJ2eVwUJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707832839; c=relaxed/simple;
	bh=A3F30XF0C/j0Ai2ylnqq8EMvK3LUI0SrU7CgxUM7nU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o2IenAed32CJS3/J1Z8zbmNtH/TTSlozeRMERk+9XLrBpu+gewEkUpRHQLM2Pfg5quZgiEvdeH/RC+AsmhraSZafYPg4fzdoY86KaBcU5sSabjpsaFldpwdTtsqMjkA81MS8c/Xf3sfIaF2jR2g4Kqj3CjOCAGzU4qTNEp7VL8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BVV3srEm; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BVV3srEm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALRQtrW5FPHgj40q2rAqdI4hk+qYAQLXjAy3dwyEbiKjGWFbfgEAJqcE7Q6jhryhSaYFs7ZfNBcAQgDhXOvbwJqiVEXkNuHOxC6QO5iOu9K7ANFBu0wN57Cm+MqJ+kufT/Lpu8O4qdyPEtxDdG6cmxfEpJfBBShzCQpJ1dJ3Fk8SB7B2GQ+6RvEzj22eOsLnofX7QoWsy3oxMTimah7nB8K+feGLfE6Zf/hFRJMQDa64ZYqPucCUUB1SNBw4SUqNtW6LO+/j7PlLv9ewUOkY3Z2gbNc3MxNGc+xdpidgIS1OJ4w+1yJimvV2slYO8UDHMOvIA7939JbGhKQS3WBvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3F30XF0C/j0Ai2ylnqq8EMvK3LUI0SrU7CgxUM7nU8=;
 b=TlIPjwZmPmcEGwXqNoVC70T/JHCQ8+j3GXBIdjwzhctaqynYn0I1j6aplHKdZ7Se03zGkZiTJ19tLph105x2lE6nL2nAeoH/2hqfkw4dLRavn9GmTQ8mLUBZn6cCeiPXLRFDT/9s+d422Yrt7ItF0fTgR1dRa2VqUKO3PdTh+C9j9ieCVyCEz/hUQwY2qxC43Q1+gSwUSaibU6kl66f58BmKoJ7SLRhJsjHzreI4Wrkg+gxwAc5qEYjRV/2BwjVl+yG2DLTMACrJTPPL7gT8F9EjsZyfq0DUHUZ7v666hsIe9MLchKZmnAyTSbGXTvk3Xns69rwF9s8WWpzi7KupCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3F30XF0C/j0Ai2ylnqq8EMvK3LUI0SrU7CgxUM7nU8=;
 b=BVV3srEm0OD7r2W+d8c4wzte6kEBQSHY95l0FBD/4xXQg/dhvG762pIEIuc3rRr6sbDSyL4F6GN5o84Y08DIDqfK0wqyKpZAcRIUEgV8tkmrJEbkpJyW5zqb2D11sYaZh46sRFisgIbAwpB8m0bbDoKYA8vAegJTKSSHGahIiwulGbnIr2s5+PnIyXon+ksgYavbavfTM5z/OnWIwqhK8lW11+Y+kdwbjtlB51ZE5qFmqvZ5AvuK+41in7iGLUb351AyJUE/R9clhpyix0d53uixzoYBLV2G3zj/J1oAc4m1wpYj1U6qoLWEDgC527XoILTHxivAUvCgaaGzHMnrbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV3PR12MB9186.namprd12.prod.outlook.com (2603:10b6:408:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Tue, 13 Feb
 2024 14:00:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 14:00:35 +0000
Date: Tue, 13 Feb 2024 10:00:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240213140033.GB989297@nvidia.com>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
 <20240213125456.GA28844@willie-the-truck>
 <20240213133045.GA989297@nvidia.com>
 <20240213135627.GD28926@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213135627.GD28926@willie-the-truck>
X-ClientProxiedBy: SN6PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:805:ca::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV3PR12MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d914cc7-d7da-4e75-82ca-08dc2c9c264b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5Vb7jTGli8OnDYW/64QwJva++KMkTs/0HdaoGgddRFzfr/4Yw13aye/+l3/8SLrmQK+BhLpZi87hlICr2RLFbO/XNaEMpWBHwgYI0QzU6wlk8O8uDseA+EtfeQA1/+LoOcclSPsbUZXkEg68vfVD/iivfp2x1x8QyPWsXRsEti6OVSxcV2B1v2PxG4g6Z2Q4TfoQ2Sf/sfXiJAnppeExewemru4Mbw4/hlD48gQ45amD/Xb+0yyBR0hUj8fJk32BPLrEberuhKQAQbaNywb8jn4QH58jv78f+ijJKu6IPi3gVNM8tXEng+/3fyqdWgoh0CiCGZUYdd7YyYzJKdwzGNb/O8I/dEDnvkxZz3hBDlAE+dN3wG0uSFiivSLwQcZPJE87WBYJ3Z9EXrVg3oYdH/+cmy96Tby9tYqhCNUfqZrfcfkwritPid2ctdJAzU+hXlYBeVPch16oGaYvcmQZN6wnOXhoLsCEFZ0GET8nQ0tHy85BHHvxVHhiS7WvS33Oi26r7DgTNgb2xtifw9DWqbS6ASfFqzAhQf8NLvYD3IqIMfsKG1xtXhzvuSi1Fu6E
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(84040400005)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(86362001)(54906003)(38100700002)(6486002)(478600001)(316002)(6916009)(66946007)(66476007)(2616005)(6506007)(66556008)(26005)(1076003)(33656002)(36756003)(6512007)(8936002)(4744005)(4326008)(8676002)(41300700001)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0K17dY2wNE6y8G4c2YL65qANktiDkfsD+E2t40vI8JPbYI+UYaVgtFcHl+pq?=
 =?us-ascii?Q?j5qOaftEfjLPvjxRCK33tlQiknAF+1MhphXxLIley4Go1Kf9ZVCBr0ceFCu2?=
 =?us-ascii?Q?s8MqJqBzCVNpK80LOnhBmYVdDp5bHnRwMPXmimTekosewmzJkMn1DaNiTJaX?=
 =?us-ascii?Q?LXdIt63tbbKkdI0gq8ej5GDP+b/t67FRkVMtb8qG/kXCeNXi58DzfUTeL0q7?=
 =?us-ascii?Q?8CR5sAXhVfVDx56cFUGADm8o1fItYxwSS180rVGgWzr1Oa1eEoMgxEkzFoq+?=
 =?us-ascii?Q?XtkHJX14SxQTnluMCbTN2v/VpxdIzehlvbwAeXaOvTORqo2IaLmE8z1XGfBV?=
 =?us-ascii?Q?xcuQz48z/a3yHiO2flnip+ooQ7MncMa/0Ofv+15ybXTGHBa7K0p9wnpkg9Hl?=
 =?us-ascii?Q?EXysLlq53IUfhbKsyEXk9+2fu6V3MKVVzz9Iyr9QJSrda/OkqGBJf3tZDJbC?=
 =?us-ascii?Q?AV9H4iPyF/mhUNAHCf/pEU6Cd/BEUwqohE5iw2tZpR/HxXfmeXjwXtRpr6M1?=
 =?us-ascii?Q?m+oxzhRnjeYIKiKbO7mbXiD0odFl2JIrrRUw0Aen5XibgdiFUcOLwOVy86n4?=
 =?us-ascii?Q?Iz5XkFALT92rxEfhwZv1Uk3Da28IEJFQhk4GAN/w3ppuETuanvRz0MwOTlpU?=
 =?us-ascii?Q?pO3W2LFgCTVDbq9lMFXckdoodnqWCFLKznPV+h3X5rvYvQW/Ttg3YLojKGNW?=
 =?us-ascii?Q?50uO2k4mxKNQRvBFjC0NFZnFXE5iKl8vVUzWxfWpI5gEXcv17EsOHiwsBRYI?=
 =?us-ascii?Q?vUc7rYjSDxwFUuWVxf6XyhfSzoddIezQu4biBK6uJqedC0Nxv4bAC5jJCpNS?=
 =?us-ascii?Q?7eMrCkYgvEb+6jGp3VwDyk2RspSPCCYs9prs213JB2ZkosdwteNUtBSPsLdj?=
 =?us-ascii?Q?eYbaLY0WFvzVnhTy8Gn37tsjuwV/0rl3TK6vdAE1O2tFbdu+5QJ1eIKca6W3?=
 =?us-ascii?Q?/B/uLmfdUpV1ceu9QeRXyMxfkKfipBKFsfGbBm+rXFDlVq38FOC27MI+ZZYZ?=
 =?us-ascii?Q?FQUJvs65IeFUVgOv6Mz/kzNPlfKWbpxNPZQ5wJ/sjI1UQBHzNtOidBgJIG50?=
 =?us-ascii?Q?JIIB6yWyJ4ulo5Viig8xaqocspbJwEXtdLxvGxrFhEv+VW46FnX9c7LzBPW/?=
 =?us-ascii?Q?rIMqoofn99dPNVwlYec0F4ovBA+HuF2uZfOjipWL1gIUfUynS6YJq780b+qs?=
 =?us-ascii?Q?of00u0YjNETZ8xDd34Dc8ftx1IkxmwuBQSiB4sWzZylLmD7iTy7hnhefnlvo?=
 =?us-ascii?Q?ubgkkHA6ybIA2NilaLbWo5pniYPQod04o8HoBQ9nUPDRGRZQ15c4qTxyYrFH?=
 =?us-ascii?Q?fWUKpxP4gYUpwzQMqwLHp0HLFv3S/+f9y66PVyd5k1htvczrltrAQTPjitcD?=
 =?us-ascii?Q?MQCanQiLCGsz7HL0Aeu+utvpxycZV6m/aZ+iDp6Wsj9HGw8aBQGS7K/WMtTG?=
 =?us-ascii?Q?1j01Wh0lpRdb0xB5M0B43FBgONssOW6Zzw3t6snOCoPV6mhy0rVQNVjSbK6G?=
 =?us-ascii?Q?kcjkNNhufFaWKyPcpUjjO6y0uVLAIpqoxSVdcGBIQtnSMghGt7y6LtmLsaQX?=
 =?us-ascii?Q?hQvf2OEo06nGYdq5Oyoi7a3DgHbvM1+rwlQIlnuE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d914cc7-d7da-4e75-82ca-08dc2c9c264b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 14:00:34.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7O75rToO3cm1LWppXxGDQOCmvHf6XVjIPKQmExc/vJzer+7Tq38T/HGAy9FANcbH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9186

On Tue, Feb 13, 2024 at 01:56:28PM +0000, Will Deacon wrote:

> I can write it as a full patch if you prefer (and I'll need your help to
> test it), but I was really hoping to continue the discussion so you could
> spin a v2.

No worries, I'll take care of it, just need to understand what we have
agreed.

Jason
