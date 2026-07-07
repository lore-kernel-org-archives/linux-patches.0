Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB69262FF8;
	Tue,  7 Jul 2026 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436430; cv=fail; b=hGuksrkLYsoFlF+y6cDuPKSEgP1W91ybaDnHIKTuqEZ+jZzPf84kXsbNZA4Ysa3O0msBKlnhgbp22zPTGVYTeBGc0Vdysm6vYMQXhsDyXAIxua4eSSbQlSJ0uex+Pc/jcUXKXvPjhcgQ3HWYqHhzM8ZdwoReAbEgIvyOPiu+DuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436430; c=relaxed/simple;
	bh=wdiWF1d50Wbg7M4U3pf8YvyH+q4ICoEqhsSNKzj1BkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b/KGBgCtuvKTUJFHYV9oGi0ff4Kbgi24DKiIc5LVwKeJG+WXpcn0peZUD7mqU0/h26NF8cgPMI7dgTaTMAIIPNdBdq/Ng/0kwgdDe4JL7YRILiahjokuD3OGCetFje6F6d7TPwi0qNCsERQCAMSPLWhfJYz4mtzTglUbXTQU54w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cJacWRF+; arc=fail smtp.client-ip=52.101.43.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cJacWRF+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/3+8eOg2Q+wvt6NIRKor3bcbrGdn1OiUIWtp0hkWvuOoV67xYzVdnGjwxlbg+mavQnYA8Z1b9c5eeMqZc09g9JeZTJjk1DCGy6Aed9a+qyW4508HhDbU2Muqs8J6XV0msqt7OkVGuO626w1qNktpK/qhDGQER+eDZrxelT/yMeAbwdLsXEKkDf7JcNbn+b1BAYdLt830E1ZGImYlAWNNDya1QXKefrhFRz9pYvdv90G6CWbTuZa3cRETFAQ1Di55ssqih01TyHlLma0PhZ88/k75seePA2tCresID5UhLCee/oQ7uhiBo0fY94x66pkDm8HUfD7YX6j35GZl8v7UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkRHiqyhXo/zrnsP0FtniaJd3Hyug5GB4wISpXxc5Mc=;
 b=G1t6rtq21DeGi0gnm7twtEYUd/I8vvLhWl9ETH83yKMymlCUPpoiOCm2/URk924C+LYrb2UZIf8APAX5Ti+YKfiO8vNlFLbHcDhBIs0Y/IIULzN71PMIfayn1N4dafl7ln2NG0Ks/iWi263FFPTjYlQVXWi5/rc5KSPwf+47YMPQnIjdWtSGkGc0/1obooRTg+0hBhVwSr+eYPkmMU7vEZ3fsK9CjUUqtWgVLrN531Ix6rX6jj6oj9baCcCLTdXwqGRXooGRRp9pYVnS2UCS/llOSIW1Bew6YYRh0FAlMs0aArRdRj0V6/gyIE7x31+HeQ367AIux606b38seiN4sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkRHiqyhXo/zrnsP0FtniaJd3Hyug5GB4wISpXxc5Mc=;
 b=cJacWRF+qMZGXzOcL+R4RmkhWtAt8ZCtONKSBs04qWIK9VX0uuXN4VfC0wtckXmBBdX1TQH5BjHWRkYYyk3iU/RBlSKWHchbfGbeA1JxMJYpAYy4tC9/qjJcISTvG0uO+LybkyGQc8Ejw36O7K0qe7WB+1ih3wTcBGBWA6pXIvWBlZSqAZcerduDN3JCD5OfGGfTcCayEKi+qhwoY0kFZYacXd2gd+Zmqg8+8dO8SIm84OWhZYHvJ66m75pnzfnpVPtQxPj+Wr81mpdoP9BMncHKtBpqLKfR8WuT5QZkHaOidILRmVz3JXk9NHNdLMLb/vdk/oTrMuFT/Kpo9ogk2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Tue, 7 Jul
 2026 15:00:24 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 15:00:24 +0000
Date: Tue, 7 Jul 2026 12:00:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 0/8] Organize the SMMUv3 invalidation flow so iommupt
 can use it
Message-ID: <20260707150023.GL220801@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzwJFpHTsgMrOYI@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzwJFpHTsgMrOYI@google.com>
X-ClientProxiedBy: MN2PR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:208:23d::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA0PR12MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: 14fa9d4a-8fbc-43ed-1fb9-08dedc387932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4nsjA6vaJN+XhTnEBPv3GMUa4vAEsRbrGAvqTyfJRwxAmbIAOoXfa5/DMnADacxA8xSoFcPjON+qnZ4bFDjP/oN08gJFf1qovlvgT2IHfR0sjyRsuKF+Cr8Fov4n4VHLfbrJ+EpQpmrBg79rgzEnxAA3MfIhWTdY9NzHGUxOmB+oZB1szc4Ku34eBI4akzTVP4N/Hz0Dy6uNAyBIjkC8IEggKCVPKAxn9wH8a2SZkZOogrvl9VM53i4tt+UmX87igc+vzxRn0qsfVn9lPo5j9mdvsOWPtLrYJjqf2Nk0c9+cN44gZKBNVL0PPXLm3L6DTfDR6Iy6XtxtH6+YPtHzLq69gM6ZRgoN3UpujgWXquTalfp6Zx3xKpw5mjj4KVdAIG1XrmO/qkmYI+rzKdp6u1YVnsdK9vlwsFWrOCjZDmOtK22heBdgIu5Hbvnau+4WbVMFfEj/AC7y24sPBGpCzvFiHGcyj295V47KB3PpJrYgGmc3/kKo4I88zMn9DovkgjXr4yDvINB1XtwmhuL9ixDMIjAdl3aZmYrrCAMkcS9TkOFgar51+vRRHNydOUQb2FoazRrhvjxQWWhlFAKLep37YGxFcrzLhvbvCVRPc3LYzNGBkN4MO6ow5gxz8xYQASkQ8gYgPxEvId8vE1DHKCLumik3B50CB5XwzEIWqxo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Vk2TIgW+ugq0JH8M/JYJJ7F0IkrYOSRLRHV1+zfPf7rQ9iwCAkA1Y1ckBTL?=
 =?us-ascii?Q?5hIxloYix9BfZfFJB22o8Ttkp+EQjWeDhwc8fKjMCOlqPS8VHuQ8mzk4YCOt?=
 =?us-ascii?Q?K8j1J5uujYQfviSa4IC87FqjoAEsr4N+IzSXvT1FMTJfsVd5+1xHE+QqumuD?=
 =?us-ascii?Q?uPGJFGl2jaZdI05+6IEgCkV3rwTxkYzqDv/xf4XsHRuIfzLS4aiz4gVPvID8?=
 =?us-ascii?Q?w6TeFkCgI/caMVVWQvuWX+hkYRTjUY8uKeWplDybMwGdcLGzTZGWVoQ8EwJ1?=
 =?us-ascii?Q?xHCW91a1FFCeyW5x95y6HTdKlSpy6+fGBMgINgTjZk8XEBH1l70Vkz/gBI96?=
 =?us-ascii?Q?7iq0qb65oaLhtJn/z/n+vnm/AjogNLhPCp0+nCKDahvWwta4EfK46M2IPnHk?=
 =?us-ascii?Q?Wytce7Tgpx4moP145IqGgWkxSf5GOno35B54zLwBC1sXTjnxOQmktOp6XOyG?=
 =?us-ascii?Q?5oenfkX7+IoO8OQF+/alY1IV5WFSdWIOxPTKjmhF/OY6mlLgwvBtyoIgaB30?=
 =?us-ascii?Q?RTcOMhur+bc1gQNjbZfnNl2Ck+ky/m0j4/au0/WoiWxi5V9AoYgc73hY4viB?=
 =?us-ascii?Q?8gp1pSsWtqMrqE3kYHEFQ7JLQ/41pImqMV4V3zf2SwwTpV4vb41WHk1zjB9P?=
 =?us-ascii?Q?uFYvB1wBOyY5C+Qh2N2eijoJ6KGnTMkaWJuauVGpyf55gzVw+BBXxIZNoH9b?=
 =?us-ascii?Q?wq8+FTRF8R/eWfK9pAQHtHLhoJyUr7pUscW5su39+2319Bz5VS52tAu+tf5F?=
 =?us-ascii?Q?vMZs/hIdYZOxQjgRYR1MZyrs1pO8g7VHEa9GstBbUYxHgpnuQiht7c0WbmtD?=
 =?us-ascii?Q?GYa8HCz5OL8b0KcZeQq3XDDJs3YcKse+xMqB+8Cb2u5OTw1VL6PNvxQLHgDl?=
 =?us-ascii?Q?rrSEen+bfcTDXYHVcwSffDoJjco/05cCQzvf3JwEwkRnr03baeH4EWIChXaI?=
 =?us-ascii?Q?jBpf4yxUGpJiH/iSbO9BV91QEY96DkHL332NjUWP9M/JdZUyR6G7i+SQu9qh?=
 =?us-ascii?Q?gLMr7V3mbXgEt3D8z64BnAewYwCgd0yBHY8cdD6XshMwlreP4iIwEreDzrNB?=
 =?us-ascii?Q?fvv/rJH/fWfiaFDwC1cP+fqKc9IKMxyLTRrsGXF46YJL+YyvJ7jaBgjB68cI?=
 =?us-ascii?Q?1MXzOLmCnjciWxFIZ1h+im/KMH4/aGVT/NIQHYALmhBRYu0bdQb9PwFO1xst?=
 =?us-ascii?Q?79m+AJF7wETPF5Y76AYCFrUtJDfDExJL/0o20j5DXorSKhdH458Ocb3S8dzA?=
 =?us-ascii?Q?K934aHxdE56ce3UvUQk25nlgkgDtn1bSBiRi+UJsPrKVWnTVNuhHV4gQgbt+?=
 =?us-ascii?Q?w2enedR0IVzBsA2mmflmNH1aJfmiZPpfrvinpiDezwwYtbr3Wy+sfMoVAXXr?=
 =?us-ascii?Q?LJtuEnfEcoX0eVUn+bQ+D2kTzwajiBWm/1fbEzqW3/vX4dJnT/Odd018qNYt?=
 =?us-ascii?Q?EXYSw5j62jVJod6YbgfWLGkVowPLtTTvgqy6VWetQGuFGztYXWGW3/xkLwiy?=
 =?us-ascii?Q?jWInXUFuzhpKLVOSvUqh74b8xiOizhjtb6zmvg3+lzLsIAsDemgzrRMpOwPo?=
 =?us-ascii?Q?Z9Fu+4vPSRZVI1r0Qa+yRmWyJTBhQXfxi2OwcF+gd83ziYxFRA9lExzFHC6A?=
 =?us-ascii?Q?rJpysMNIy5VCIb8PYUQ9z2Bk7XT8vaHavXW0GFKs35HT4srK9AWZSNJrlWT8?=
 =?us-ascii?Q?gjpD3wJ+0XOrkFVC25mSNrJfRnWp088eMthn6gVAHM/XtBtP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fa9d4a-8fbc-43ed-1fb9-08dedc387932
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 15:00:24.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlHiXtBp46B2Du9j0YJ9SLXQ68ij4lC8IlMa+pkQU+vzCTLSX09ZS/LkDHCaQ06f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366

On Tue, Jul 07, 2026 at 12:25:08PM +0000, Mostafa Saleh wrote:

> I quickly went through the series, and left few comments.
> As discussed before regarding the TLB invalidation logic sharing
> with pKVM [1], 

Great, thanks

> I still think after these changes both drivers can
> share some logic on the level arm_smmu_tlbi_calc_range() (+ tweaks).

Yeah, I'm sure, but it still would be nice to share more than just
that..

Jason
