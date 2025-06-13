Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1442C08BC;
	Fri, 13 Jun 2025 13:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823103; cv=fail; b=qz5h8yxty8uN26Zq84/e9/xiAuJmaS+t3oBQ2k1dDQqO18WLQ2ffy3HUvPbdC8ZtSqkXx7988jyS/C3cV2dwHjk5hXRr+BG60F2V3MwQ3sspefSGPluDmhkbJaOoPwQy+2EqBREQt3zvyDIpqCOn4b1Tv0fcs6saOX5YI8Zwuiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823103; c=relaxed/simple;
	bh=0sHdb2Kjps4Iy34yeO/YmNnt48mgyL2Suw1gMfIHEFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QqlFh/qephM42TE1qCkreOLShE2yw+/jx3B5sHA33nr4ndw4W2gMcODPVB+96kYz/zIBzol6/mhXZnqB4uN1N3OTJ6bwGIweeMjqwEEkh4Lek6XsjEBz8a50RbKi0tXuPOe2dLjzo/ZD1oElbnULZpBB82PbmvC5lg+upN20Vig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DSJWD2UX; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DSJWD2UX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+vKv2dJPxXA15UUnULSR75YGTgdNVquIXwteapKgle4TlYq4veYIv7ofsuFN8xR8XGXiqazVfYRUe7VzN6wFGYoncsXB3wlQfWST0BlLur9x7YMksu5YDt0Zbi3kvGnIvmQ9P9CZHJoVTd4g7ztgCdGOw076c2uEcNm21haWvI1wEJD7SkigSBXiwAS1U2Thb6sQv8BmfyN7pZPxQVTesFq7+QYLXlVa9KgV2EqxyWJnRcN82Bv7VDAgrVHQJl/CopIuOhluis2o9YNH5gMSxykUaVBIf9tWhp88yp2TIS6eLmPtqk2uuq75IEZmJPj3zaPvzeQy/3QMGHiwu3k3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCqC0DsBKOt7gZ3kquw8pD3YtbJoYf+bFynjgEDzhww=;
 b=yXfO8Hg18TXPgDA2rhSASpUCv3zKhO/8JFxXx5xAuXcMJfqkS+1NrU97Q5IB2gY98qwDYXBMiOUhyLMUbdRedEKoT0wmtAYIBz1pzfli6pQEwZohFGAN+yFkp4SOkWIFd5p4EYtpW2JRQKnCsKXZXMUvp7ws7XBp+oPI1AZRAzb37SYlyhp5SLn3zYQdLyezu5z90ieQbFVr9zssW/lo8L7bGP78h0iki3IbCrzt3dkMaN01aEvi5JwuS9V+2TuJsZFdJNMCwTYp8dtvUdBlfEB9BtkGznHDHVHinMBbIVg7z5P7Z9eJTGIa9qx01IiNF8f8EcrVc1t6G5Tg/0Rlyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCqC0DsBKOt7gZ3kquw8pD3YtbJoYf+bFynjgEDzhww=;
 b=DSJWD2UX9yJKTZ7Qg+/CY/03JvN7LtWsj/FULOZlO/yiaCtuqrXyEiCtKsuiFImpLcwWdf2HVyhDNoWdzeNsl8WnwsvjQXssSKfiG2o8xlkke6j34m/J9n5rvcKhBSKg70vS6rlJC/15MWkw+5ILqFBVJ2Ez+hwbQMKlE+owdsKVfw+E1yM0RGrOwbYjGqQRgCJc6O99C/5xY+8bcVazl0nhZJO2lPrabvgF3qtQAp6Xe8fCo1pc1wdWbfDSO1jEzlf+xJFlbA75LVsYduBT9iHsLJ4qNKHfv/KoPo0GGbAXWXz5BpkFoy5WnJW+3+bqOLnXYVqZsPHJdpDJZJ+YHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7420.namprd12.prod.outlook.com (2603:10b6:806:2a7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Fri, 13 Jun
 2025 13:58:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:58:19 +0000
Date: Fri, 13 Jun 2025 10:58:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 11/12] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
Message-ID: <20250613135817.GG1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <52edfd3e74c264f0f7b1f706d29e9edcb705e2db.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52edfd3e74c264f0f7b1f706d29e9edcb705e2db.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT2PR01CA0011.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7420:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e94419-cc5e-49e8-11af-08ddaa8259c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fFRWaAMmYAzkTOtUE+xnaScLptOCt9+ZWmVwL9emujGbDpIlEGi1mkusoytm?=
 =?us-ascii?Q?dS3ncQklW1RXdQpz0aISrhZuYK9GBDGYbVdvt+QAeSlCLheMQkvbIhLA2I/z?=
 =?us-ascii?Q?fukw5VGjZ/JWOaesZjCPw3yHz57cxuqLSivzzWiSlPRtr+7RwXuPLUPrDGwX?=
 =?us-ascii?Q?zTXY9cgtoW9oYQVvywy6QK/0xios3DC+nexn0V0EARj03QbpRSGZ9q9w+BZb?=
 =?us-ascii?Q?Cdlqkzv0SA8Dhf/d6qby8MAX6t9yo7apuARdW6eh8jUBpgdo3aJxWx5qTRCw?=
 =?us-ascii?Q?HdAxDOIiF4fXjl1nG5iPCtHcnzVVNFvSimVVIqAd8VVFyXWSoGfhdwYR4npr?=
 =?us-ascii?Q?KCwL66kUVCG3T1zfSEFlztB7Q/kskyIuK1V7G1SFAv+3zGEAol24jK9lcfCZ?=
 =?us-ascii?Q?KXl6beo+KEtZo+mlp8/0fTJRcHDEXGC1k30O9n/4c8rAlZa1c45tRORcdm+d?=
 =?us-ascii?Q?+iK3Q9xsJ2z/w0XM9SwoiCjNaxRVTNOZ5TGIg+V3w2qA5lP9HawX6oQ4LguH?=
 =?us-ascii?Q?WQhUa/uW0UAxok/pITX4WK8ngF19K7gWI4MjpNJJRLij+42Tk7Btdze8U2Jy?=
 =?us-ascii?Q?hY2IB4zd+uLL2mrlrSUDMoI/BTXGqaiuWGN7OQ5gNdzgR7JBoJW5mNGJP4EZ?=
 =?us-ascii?Q?VEX8UetLsBsdSb9mkj0tuJewPpuPBNLBDJMOqO+afcYb5FO4tKWnbbb3kHnY?=
 =?us-ascii?Q?sf4MgOY2RCmTnLCsZhIHQFc5oRBt9ch5C1ia1hyO09rwOuOQNqQtVPEbIyHz?=
 =?us-ascii?Q?wBl7CZCMgziEBR4X8j7D6EaWOiXGCewKRCocLG7arXQLTmsFO3nkqFhzBeeT?=
 =?us-ascii?Q?hLsE2gGwuPTKtzdG1lckXkpdZa6uE+imP6O1lVDFB5gveaJd3KZQXSqUceQL?=
 =?us-ascii?Q?X6vExcFOz7oGlPVweFz02B3xZ1+ro1GFPLTi1vg6EJyp9fT5HPGDxf6k5piv?=
 =?us-ascii?Q?UBZWstYk1FFOR9E7kYntTIyuC9TPJZ1KuEW+ocx7E8e5in1g85EXZetoQr0q?=
 =?us-ascii?Q?Ss+KfroOCmVXwZpWZU0bF4zswFpAIMJiYsRuRVDgBzpfg5W1kj1sfPL6IjNe?=
 =?us-ascii?Q?4IZ8FIAx/tPp25B6nF2OtDi1kTpOqEhc+PVd0fCNCAEuj/qmK+/+j9cfPF5B?=
 =?us-ascii?Q?GKZaFISi0xzui55JhrIKeUWK0rZq57fNHaahQtDVAvZ2FHhf/eH/ANpBIjzV?=
 =?us-ascii?Q?cbFA2HN77tEsuuH1e+g68bRKcueFfPuSBzoUDx3fnOdFF90r7f5XVg9SaEbC?=
 =?us-ascii?Q?sq0d9iwYoiQWE6P1v+k0nPv3JVVaBiIaAl23I3AEfnc8aw9JXx277jFtOeYb?=
 =?us-ascii?Q?Nfg1AQe5K+JxM7hUbymuyYhwSxdgv9jRBm84hNsBqQLl88aeLkDjAUb9Hf8G?=
 =?us-ascii?Q?XUg6HFwm05VrdGvhWYR0XqutbgOfEwAdy9AZfq4Oqb0g8u6oYw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pKA5rsD7+oyICAfW/rQBwa4+Iu5aDA/EkUem4C0Hgg0DN+AF915giPsjzlEh?=
 =?us-ascii?Q?LQUStLfqPakYK6HoMezrbLbtJR6PFmlbhgF8oXeJQ4GRkwSCLYKxQklsr/FD?=
 =?us-ascii?Q?DwS6Bvx6Y4SfN8DfdhkIJpOk1++tMjNFWwC2M7il+XW67jXyTrCBxI0A2wQ1?=
 =?us-ascii?Q?ffDcLeKQqCAyksPR+g9FBA+zWXETgXkjlfez9gb9bSafBf1J7i7rmj86NQ0o?=
 =?us-ascii?Q?aJhNBaOk3085vakltXcecEIrGqyUHmdDX+7Wp9D8YcbuTrn7HGH9YrQxbh//?=
 =?us-ascii?Q?oZyJK3WBo/Sfw5OUxitHD6oJLGjeykU3dQwpyrzRGdP943UUqnqjH9+Z9sSb?=
 =?us-ascii?Q?WyxA+x+dArVgpSuf70tlrn7LnOJ+0bIDTUvjg6TNDE0xgry7mbkK1DzpHPGZ?=
 =?us-ascii?Q?T18NIkpJA0/U6DcpdvL4Lui11vUehdaTpg5VM3gGK7PAShk+HPgnOCe0Xd5c?=
 =?us-ascii?Q?jmeGhuxOznRr5cAMemPpuPWQVBoYvMGjGYS8JaUSXX/3IDPeiKTCITypQA+2?=
 =?us-ascii?Q?5bvSmB/yguwzCRGhUF2xcybJAWGBYsdXelMz7pi2GUpTN4w1xSOmng4Em0f+?=
 =?us-ascii?Q?ZYDXf5bIGPNV+aGGOzi2JsG1XANLlSUty8zisyNwNePZBBnEnJEzWdqfgtiV?=
 =?us-ascii?Q?rXZbVCrHVCw884dINO09sm+Q+wR2ndq5yZUvWsBvRyDPpJCcH3+O0wPMisqp?=
 =?us-ascii?Q?wBfoYJ5pj01PGwI6DI0JnQZWCkvWSmUmbuTFxz6gWfIQ0TgVd8jHUZlofLQL?=
 =?us-ascii?Q?og2gEICxFfgJYT4Jg68rHA2WT++DBWpIcABb7A6w4PUpAh6xm7VdgpM1IMun?=
 =?us-ascii?Q?QpAKKuGp4qnAz6UuQvCF5pocJKpT9YdaCwZZmoSBRsart3tgjuiP5QfEwhwr?=
 =?us-ascii?Q?dhJA2+BBRnqEdChuFU9Op33wN0CJfc9NbIr9B69SqcTYfsLih8i5W9JBTMKr?=
 =?us-ascii?Q?6pOywT6gSJr/ZiwGI1XbG91P6Nfg/UaRcEgk5xWBSKbvdPbeBijcqQH3QHYd?=
 =?us-ascii?Q?IfJl2KsCy20N8h+H5KULWs1fPd+1KAmVVoi1/vZY7hTIpr7LgSEl+PVJt04L?=
 =?us-ascii?Q?qiR7puOiD3YBU3C5OJxZkeRHTau2NYhBRK0LHk4CwMH6cQxKSrzmVAke7pte?=
 =?us-ascii?Q?iWKI2a0ZCui0dLvfeYxoqXLMG0lzp59aTYevbUgbiBvcR5S3SjvD2lt8KP/r?=
 =?us-ascii?Q?4ISXYYc/RC1DTNMl4+/SvtTTXvOawoMTtUhNiQUqt0gqPacWTrUQy9RBYOlu?=
 =?us-ascii?Q?P7wppfDjbD1JFPH/eG2jkRPqlj+/Va1Yv7xMf+X2+8Ax10l9XlBjqvOtBvw/?=
 =?us-ascii?Q?xsqj4wbAvKoBcY5m8/4pR5+VFnLBCXsXZtFNstyZ9r8Sz8iEuA8QllOX7HyC?=
 =?us-ascii?Q?eUq/1roLx893Y5WSiH1hvnjn9WpqWxrWNDqN/7fW0rwKg6uNhTbikPG9G8Jj?=
 =?us-ascii?Q?p9jN3jW0vNAqw2Si2nSwEj1dgmD4XJJRl1OcqoclvV9mtfiHfmqdfc4GkeuZ?=
 =?us-ascii?Q?beAJlBPanfmPilsNss1ABw/kx0fvfMxrPxL6DlF6lMJ7hS+eAuyHPQah5Rf8?=
 =?us-ascii?Q?lMkaNVyH5n+diMosw7rAULiXQzIIQSAvxe19Cw+Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e94419-cc5e-49e8-11af-08ddaa8259c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:58:18.9129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OumelCGSJ0YNm2Wc8APcxkUI/nHn6nzu+ig8+3T//o5kUOQwzBEfIAbJxRyeOcDF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7420

On Mon, Jun 09, 2025 at 10:13:34AM -0700, Nicolin Chen wrote:

> +#define iommufd_object_alloc_ucmd(ucmd, ptr, type) \
> +	__iommufd_object_alloc_ucmd(ucmd, ptr, type, obj)

Lets add a comment here and on the normal iommufd_object_alloc
explaining that this function automatically calls finalize and abort,
the non ucmd version requires the caller to do so.

> +struct iommufd_object *_iommufd_object_alloc_ucmd(struct iommufd_ucmd *ucmd,
> +						  size_t size,
> +						  enum iommufd_object_type type)
> +{
> +	struct iommufd_object *new_obj;
> +
> +	if (ucmd->new_obj)

WARN_ON? Something is coded wrong if we hit this right?

Jason
