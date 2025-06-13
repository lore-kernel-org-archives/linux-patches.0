Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682948F6C;
	Fri, 13 Jun 2025 23:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857006; cv=fail; b=qO2x7ZMdyrLhDbMSruYK/LOsU1HeHVZHBzjnzjJc9PHVNGogg/Bp6miBibpjICFyZhjApBaBIJ3nAic6No5hPgeii3PCEtJxkk6URmV09fhY54TnwTgCy7Df6Y/IUb/FEw+H7zGb9TQKyeE2qLndggHYVBp4eVytLfX6UmLDzUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857006; c=relaxed/simple;
	bh=nozdN/oYIJhmoJ4nK6ZaDIpxGc2XqsN6Lx8+Df6AOAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Zx5Ks+aZMNmKPxifHz9PJt3QlNLjabbOtYKSGWdB1MwCtmHXWlvnOAFaEhAynZl/efSPmOq/UbkcmoGElpa9Vu4eAhDw702xRKn+nMqDxmiirFwh8ri6sNlcA/rA422pWegfySyUuwyv+4l+dkin+9fyVa+6xHfYqr2ZEuoJAlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k0gZkPGZ; arc=fail smtp.client-ip=40.107.100.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k0gZkPGZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pO4bE8zRwXVQLtVci/NFzTixesoX6KhNPvoOmRM9oJtgK4PlP6rzpsHc/XhjQIOkwZwhuW0fzp42212k06/JQb3hhdlGLJGasfLHw2U3dlKsm/jgcsoF9n1V/sbIp5PsUeApRiNvDExtnN62rhBlyrX0bLqWMNtQ5V3Oc7eosGgb3Z95yJUWgKAieffNV0RePTCFgk0fZh/7b+wnlSDLfKl6vStc3+/r6IbS15xCqA3cDz6KM0XNR+GsfmUGD24S4+lkVOq2YOfDbm2dKHqbY73oyC6dro+qS7NfxpL4DLrqZnlhn2yEP3pzguRwaD0Wdq8/LaQd7tTowDtOednvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFUN/bD8h7KQWLPLzET8OHvrTr7+Vn//rzxu/pD5E/o=;
 b=fLJpB84wkQWIcXWKC6qN1KUvba/EcXsNw+bA3kPy8Mkf7s9dKdLCQc1h9wLeVtavPgf5w/QMMOB9ZdCox0KXAyby7hE9xoXT5woUteHnNKileJ0oXkSax/Rhay0iDnQ2e0goODvJX70dA7tdyjfJoo9I31pze+UlHxmxtqJJmtjvmWoQS7qTg1QP82YQPXXHPTme2cjwh+Crdtv0Odn6NZoSzaFHinB/D15sUGKsyiKwQqfIBzV6EHVVm2JnoJLvWYfP/lIj7N1Naa2Y2HIYjXJD4n4LD8muDfRLnimO3ftLUlgiPmV3mQHsQBe7nxJB8fSLST2k3sxxMcHcHD4uTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFUN/bD8h7KQWLPLzET8OHvrTr7+Vn//rzxu/pD5E/o=;
 b=k0gZkPGZHENrygo/iKs9SZcXkpl7uuKE/OuhqNGmR32Dp+APFhP/HWfozRwvnh8Oswt0cYyQpIZJWuJF4Bid4zq75NibKK8ryOMTM1m625tU3ev5jUNlIZb0TwygZUb1s0+BE+a61I8+BCDJNfjP8ykgqABwO6v0JpW0B2mpjevrDQWGaEDPtBAF2vN5H2mpow74HcDYdE9b5KCHpBaEEA+SsjHDj/1kevrWWEwQQig2eHpp6PSFyrqHcye7lgBtx118W2uLyJhL6yXUBfhOSakLvosooZO24aEOuUZv/pZZfvTBc9HxS24iZ5mpZD/sL1zl/RU9jWSyKVQ+Ks3ZCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7877.namprd12.prod.outlook.com (2603:10b6:806:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Fri, 13 Jun
 2025 23:23:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 23:23:21 +0000
Date: Fri, 13 Jun 2025 20:23:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 06/12] iommufd/selftest: Implement
 mock_get_viommu_size and mock_viommu_init
Message-ID: <20250613232318.GP1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
 <20250613134522.GE1174925@nvidia.com>
 <aEyH1YPkmW1gy2da@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEyH1YPkmW1gy2da@nvidia.com>
X-ClientProxiedBy: BY3PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7877:EE_
X-MS-Office365-Filtering-Correlation-Id: 72cd5b27-31be-47ea-8658-08ddaad14910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LvuvQfSpAUC5xKxosRzPdvlf3P3QkEZfl3xTUz0QsyzJRkqgo7SLsO+Pxqg9?=
 =?us-ascii?Q?kXNjGWWsT1FPsW5H4ApsCnBGmA5kUypiUza9ADZABXzgLxVuW/eeirQAm9mV?=
 =?us-ascii?Q?gmvnUQlU1uxSs0cf5qXdsKW2hkXxjzDkhIVvZmCMHO78Y0lbn7WGeoNYyMbs?=
 =?us-ascii?Q?1SmHknYTQwZp5VWka5KMnO8gaWAnbUB0HbdIpoKrwhvkI6RszyTKRRufr0jy?=
 =?us-ascii?Q?ZZeJ2L+D+/k/X5XRqXyNbqDe9HugtOwj0AXHsYRdXUmMWPtA9JRkFhUNdXFj?=
 =?us-ascii?Q?lex1ZbO+NiaPq/QTmBOCAc9PdHIyj7fun4/oM7WeeZBa4/UUza7E3B6gBYNb?=
 =?us-ascii?Q?qwfSTzCEp6UigDNjt69x5HxvtrUt+nZeYeshRaGmCHBPrkY03klJBOBno2lG?=
 =?us-ascii?Q?1si2tKvp+x2MsvoW44XMyvFXFQARuwwd7kpchIf91zBsB8GRPTimIYoyqJkS?=
 =?us-ascii?Q?eKyvMoVJbvZQgWW/vHiH33enxECRCPpxHg+rqu+7QIRb9kdN0HAtIiFnkIIk?=
 =?us-ascii?Q?ytfyj5nc+ogAblhoAJkFip+Jsb1HepL7C8BDj+oMYl+wbz6J88rSWPli3Ksb?=
 =?us-ascii?Q?yuH5WeNuXXAXLzHkODqO+qN3Plh+WxZJjEOMsi2MiySczLOxDcYU0vGFUK6z?=
 =?us-ascii?Q?8I+rSiJKf/NymT7KhuWok0kjQEUCQxvEguqXyPbRj21JwRoRA3WoXZEBUr1w?=
 =?us-ascii?Q?JfnXU3tizwhwqlEzpl5kuIOVzZ4fxAD2EFQIVSjGHr1OGP4OUkYFG4y73Jdj?=
 =?us-ascii?Q?R7kqmHZVQ8qDN/gp61H5H66kSN3Zsqrv4Zsv+ZfZ5nv49eE8lQa18mFSSREm?=
 =?us-ascii?Q?kosYG6mNm8Dz9U7sXUi3APrqNyy5kvpX7BvN3Sv3pq5cJXK4mbJhs7uatSEt?=
 =?us-ascii?Q?tQygxotwCaMPUVo0rpHQaNjFSxVAY3kYkkX/9ypDRA4t1rQoF6elM0Jn9uyY?=
 =?us-ascii?Q?Y9/ZMQn9L/7ux3wLiLwiHOJYqi/cbtPgnasst3eawOgDxNcq6AU1LUp7jOhe?=
 =?us-ascii?Q?wJjdYRwahrqi9oqYNPTKzOCdXCy37awA/9eisChvztZTF/bW5p+Y6ys2lOqy?=
 =?us-ascii?Q?oDCzoZOPPUp7in6/+eupk3UJO1pxaMweHp6qvC6Spwyzsjf7fzs/JU6NretT?=
 =?us-ascii?Q?/9/O1U2DCv9zaVwuYqEpV2Ma1gyChYl1X4gSJtPeZoJjE0wU4qpCo/Z3RlZw?=
 =?us-ascii?Q?8/GsOn6+8nEwhwNGEL+Pf56Y3Tl/CgCZxwTYkDtJAmaCB0mz8p2Csz+09IYt?=
 =?us-ascii?Q?x85Tt7LrJBg9FNBwLFZDDb1StDJyQpCG8sYJbQGXLyNjSiYL+zuX0qCcCJ9H?=
 =?us-ascii?Q?ceyzf1BEw8xGr7bi5fx/HeZ6S/38zkkOQhxXNzPzeA9/aFNNw1QuO8EVJImm?=
 =?us-ascii?Q?2oWQZiW0pfkThuuuFJAhXPYTQgmrShzGnO4a6n/Ktmpja/pcXg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Hum4q+KQ5fPnaHu4WYcAJkl5MADk1ns+YNKyncfg9KF2D84lGsr7Ls9JGa+?=
 =?us-ascii?Q?GYShZjaVKLkTUKsp3LaFPWU21dbUtKG9315TseNylMVq7CHv/y2gwVdlo7jJ?=
 =?us-ascii?Q?5LOdvZkd3xN8FDlavkh5sjoeMq7/VrjN758RigrrZ2lGV8M5pT5t+Mp0I5uQ?=
 =?us-ascii?Q?x/PAR3CZ0P47i1zQdrt2vilVI90s3xKE3ZJsASamHzBRhjVDKY8nw4SvFQI8?=
 =?us-ascii?Q?mGmW0gEc5srEETRiaoTQLI9g3dr0MIIS53G3ie7CdVrmS1V6Ia+/2MUy1Ftn?=
 =?us-ascii?Q?DGtT2ULQDe9sdBdiPCYkrEVj3cZPtYmDTZV+m0q/VfYSPXBxSscPmw7qKalq?=
 =?us-ascii?Q?aN0jrMN5vJ8PEYz6QA69e4pzJqOsrycPKLvwU59OTuSZJorf2EkcqNzENTB4?=
 =?us-ascii?Q?CI7mfZtj4LeqaVVL28WQ7YFv9WUNUo+hPZZ+eud1tgsUek/RKU7mObBSo93H?=
 =?us-ascii?Q?zbZDDEHqPpsvu/sA0Qwi98DwwTLrzToofbjA3UcsIO2vGvFoyTA6kn9YeZyt?=
 =?us-ascii?Q?dSG1sth9vnnS4N1Te2uXloY3m0lVxc+ww2naEC3awm0zYb0SNYd0CZ7rIKM0?=
 =?us-ascii?Q?h/ND6l0Mz8FMZ4t2IWCzjRJcLUSPpXInxwY1/+q2IP0TS/qn09n1LSHCqid9?=
 =?us-ascii?Q?2wxHLZLQYL0HgYY5DaN0ZSS90hWVrYCvadjJrZ2eHMmfeo4nJsiw9ngSo8Fq?=
 =?us-ascii?Q?b84m1L7UYJ8Vn/KYg7L7yZcPB0zGGQcyUAyioZfZgORuvdWalJ1BP51S8JQP?=
 =?us-ascii?Q?0lzn41+gFugUPUXUDAmj6FRChs+Onm5/FIfKMgXKHqx+L9BjHSWZUvmw/7l6?=
 =?us-ascii?Q?j4OFI32/eDq7WoqKl/objOWm7+BoF4CtJ6SH4EGCVG6/ZV31L7MeF+eVChYy?=
 =?us-ascii?Q?qKfn+b2yty+ZG+wJVB0joIvsmF04J7KSbpG38g+Tt0eYikR93UnKoL1vxbIU?=
 =?us-ascii?Q?fqJncu5v1i/8L2ZTxRHzlDyzZtGghZOSkNLhl5rcQNyrK4UFfMblfiW3dXeF?=
 =?us-ascii?Q?BS1ollYCwHqtGRLLTRJtbAH7sNpPVF/NSaDRa1y17KLA610dKR9oBir0Vfi8?=
 =?us-ascii?Q?JwZDKEfkBRjyAgWRXaTuOxkYmNtNbeJh/ViF14KrlcVUgnE1AuJ4ysyf1lnt?=
 =?us-ascii?Q?hc3UISL9ecBABym5RcB40RAzIif5Z1Mqsy7SqXKFrbDQFjOkcV7p6rVU+nmY?=
 =?us-ascii?Q?DSV/TpuUYInm2QAHwbBYLa5jMLkfjE6L6TatvTcpXLdd9IrYJZnpu7D82q+q?=
 =?us-ascii?Q?bDTHhWN5rBaPVk+SgY9MloIHzcur9fIi8WmwCgFUIrmFaZAMPePq+WjmXn5g?=
 =?us-ascii?Q?tfXD8wrxeRegAY2l2linqlc/IvWVyl61f4bNw9y9uMy45Mn55r4WHUdygzA0?=
 =?us-ascii?Q?tJyBj2KltYpJRXS+qQUVj3AHqBLSy7mfzPFkpceJuXPG8TyLDBnjrH0iv8wZ?=
 =?us-ascii?Q?ATz5lL6I+AKmsqIa4O9oTvNvpGtze2ry4ThepO36sj7RSvsRwR70stpMQS0G?=
 =?us-ascii?Q?DuIcxm3xpzS2A+XIsuScWehUne5JyPU3b7bK6hfuNJ8d2X04mgFWvqen3Xyx?=
 =?us-ascii?Q?SGbB1p33m4pp4iyG/8CmUVXAu9iokns4i/2t0tll?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72cd5b27-31be-47ea-8658-08ddaad14910
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 23:23:20.9899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41i25hFFCg8S0CO8Z5gyjp6GtT9kGoLjsDWHoGGVGUbDeWOjJBvhRL3eNVwRgrJS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7877

On Fri, Jun 13, 2025 at 01:19:33PM -0700, Nicolin Chen wrote:
> > The patches will read better if you add the call logic for init along
> > side alloc based on init or alloc ops being non-NULL in the prior
> > patch and then have these driver patches replace alloc with init.
> > 
> > Duplicating alloc into init and leaving both makes the patch harder to
> > check.
> 
> I see. That will add an additional patch tentatively supporting
> both ops.

An additional patch is not needed, just add calls to the ops in the
same patch where you add the ops.

Then the patch that removes the old ops removes the extra logic
deciding which set to call. This is the preferred way to do driver
conversions.

Jason
