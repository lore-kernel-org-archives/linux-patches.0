Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644C214B959
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719317027; cv=fail; b=KnQtxKkIzH2o00REd0+8KyLinBZHcfBK29uvbrM1LSxWX1ZwKc0z3zERql8+XNYxuZZCSOylWb4GhFIOdTJsKukmP+WqiqS3CyKjdXV+Pd3NR71gQLJoVrkv3I6pPBDgNqvEGkd9JK1nVbZ+z7uraJ2jFyoKDkv9MoSIq91Khfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719317027; c=relaxed/simple;
	bh=qD9Kvh0TF7lc9xU4ZAdoHd1FK21VmjepNkgE4RPJc8Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kwXy0jnwDWNOLCOI8R06kEwymDf07v3ez0UD3Lx5hKqW3WJb1o03OXlv92KgIb6ulsYTe4cayQz7f0C3ZEIQXe0f2nnrU5DGOVen577031pTnag/AuX48TMnXvPLo5xNs371Lp75JbANqS0NVWYLhPrxTpLEc9Inf1s6HzzAPD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dvvPuGzY; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dvvPuGzY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719317026; x=1750853026;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qD9Kvh0TF7lc9xU4ZAdoHd1FK21VmjepNkgE4RPJc8Q=;
  b=dvvPuGzYfnDhryti3/QMcDQwKL/Y8uh2a4AQR+4PwNLonvUvxc9fDCOA
   9KDA/VfXyrRin2LO37B25Pm51bOrNsgsyQw6sCKZduhC8SjY1EQV3Rinj
   TTRzdTIVxlBghMDYhBJvNF2AxgEMje4j/A1b+C9ylozkasf9j8wKNQNx/
   syNx2zU7dtFvbsvQK9UuDmDDZ7QrWgNpA1nhCL6QUR6YUu5QyCC/scaVy
   v8In31N3fxqfaiuwXKar4IrV1A0tyMLjZpdRV6kOXtrouS2c/IbU33Yyf
   oPVoCzZqQnk1YlLgyYn1Y6bBJh8YKBWL+NLjbsu4ZuEiWXP2zIt2/fQv8
   Q==;
X-CSE-ConnectionGUID: nJubSnZnQEyIrw1YITd82g==
X-CSE-MsgGUID: 3hKEDvoQTdOYG62m8XdRVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="20105654"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="20105654"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 05:03:43 -0700
X-CSE-ConnectionGUID: 7MMTlZX6RgmY6oM0Wks17A==
X-CSE-MsgGUID: NY/Uw/6QSsmY8k0rlm3glQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="48798598"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 05:03:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 05:03:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 05:03:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 05:03:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/5KEaiJnQqEq2wOwooOat1VRg9XbIVuHLJn5zka47GarmakVjevT531LZsNdkrsbVIwww2OPJ1NTNYOMrWaB/gAMTMCaLpIT1lmo+QEqlmscDSbiqMsZjU3JVI15WrbW2EXTo9pKiUuX2jtFslK3Ex7XDAk5MMm8L6NxcnOi1a28GdGI08RjIkYB1/EctpezQMtFJCzmAcckgrn2YXZJnJxfF/aVC+0ekCY7gIIteI6chd5Ovup3pI76XETUL+ZXEATVNxP7aSoG6amWs5Li7QdFmTLoAM3y1Ubh5TqbMzymtMQMAQiKHRU9zXbNEsv94Rub98t+AxqSM2pmGWabQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FugLBefir6VYbcnLIC6S0U9ysg5qGtANeW4h2UdH+Nw=;
 b=Ox+Wt7gGirOLh3LcqRJY/RIbK+OEB4zfdKbGjCLrkFq8cbAOrE07hVFs+Ph853tamr8CnXBgi1HNZtebiUMHOZJIj/xuQa+9ZTprqqtHwlYLdkdHXTV2/vuhn9uuUa4PAmAOfa/mQA5fy0Io4lfX8PAtOciqm3rL4A3GmHUBOjVtjR5fCW01x+H3igjkdwZiGYJo1tuD3PbdgO6rCVOo3G/DjK/u8xaX0TIXb3HosgRZxsB0AJAH6hOw0+QczWcOFdsJYiMnM8V8DsRXrZSSe7/tNn5cA9X2JMxlyTh2RhxByMhkf09S0MFA2V56jf5UFtINM9lUwgZimfmnbodHjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2854.namprd11.prod.outlook.com (2603:10b6:a02:c9::12)
 by CY8PR11MB6890.namprd11.prod.outlook.com (2603:10b6:930:5d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.31; Tue, 25 Jun
 2024 12:03:39 +0000
Received: from BYAPR11MB2854.namprd11.prod.outlook.com
 ([fe80::8a98:4745:7147:ed42]) by BYAPR11MB2854.namprd11.prod.outlook.com
 ([fe80::8a98:4745:7147:ed42%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:03:39 +0000
Date: Tue, 25 Jun 2024 08:03:33 -0400
From: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Airlie
	<airlied@gmail.com>, "Vetter, Daniel" <daniel.vetter@intel.com>, Jani Nikula
	<jani.nikula@intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	<tursulin@ursulin.net>
CC: Francois Dugast <francois.dugast@intel.com>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, Matthew Brost <matthew.brost@intel.com>, Thomas
 =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <ZnqyFRf9zPa4kfwL@intel.com>
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
 <2024061946-salvaging-tying-a320@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2024061946-salvaging-tying-a320@gregkh>
X-ClientProxiedBy: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To BYAPR11MB2854.namprd11.prod.outlook.com
 (2603:10b6:a02:c9::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2854:EE_|CY8PR11MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bc4a259-17ad-4c91-06a0-08dc950ed949
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XWGdHjjv89DKLJR8Tq9JSLp5byoc2/icKzPaFN9J96swv3cj229xwPYc+ZXp?=
 =?us-ascii?Q?LkxrJZ0rZbn3WI2c7KI5oif/DXcBdJbw6mLUFcDZFMRzvDskXt7MghDkIN5/?=
 =?us-ascii?Q?ToeSFR7sQ6Q/b41gZDhrtz3PGeNoTUgKZChqrMKM4sOrKA6dgeg0fyGwC7Rk?=
 =?us-ascii?Q?4ObyX+gFBQD/ulOoXwm3bgNSqnVanhrBA+CKPiv2PBbJIyGxEHp3pzCZxMNn?=
 =?us-ascii?Q?uSLTX12fDYTwnDz5M/GxhoVDe+ItZWh6ZvZ4eDdlPHlBoc2Lik1nJBT8bgiM?=
 =?us-ascii?Q?LlZ83wcPQ3m8rH5iKxo5GXTLPUiNDWqEmbYpaFVOyvBxRxnGcA0doMXnz8s7?=
 =?us-ascii?Q?yr5FCmCQnONCGGdnDbG0rFr1vWq+YrBNBm8m5BLq6QARi8dS3inYmuZacKxR?=
 =?us-ascii?Q?c97lIp5QLrCnZaAudOJw3UTabHRP/tdUD82/n5M2mu4GPL29CBPdMYE1S/tu?=
 =?us-ascii?Q?zZp6te3/3z/lk6rXsGQZexGVCBiGeePdCNnpWmlAcnaA31IUqs/7vk9iocHt?=
 =?us-ascii?Q?148vNdoWWfz053MmEuETHUoepmJm/ciIO23xSkDckmxg0oIimIts7YQ9pe8B?=
 =?us-ascii?Q?kZfdAErHnX88zeNC5eMSJlF2u8AXWmel7nm4lTOMDvQIuVLkoygJhxHqiTUB?=
 =?us-ascii?Q?hJ/aDuFfiutQAG3154O1sjY42h9eY2vG5+MuDkYEa/WXJ3xQMcLMzM8fwzop?=
 =?us-ascii?Q?6NYNNthMI/u9+dAaXe78u60GQcow1mgvZmocLERXyQW0BFBeTNledjoHjbg1?=
 =?us-ascii?Q?qITqsVKPUz9+YAfpSs9PzG1MNBcqePNA2pUrRYloRgDMsx76mkoAvwJi1QSR?=
 =?us-ascii?Q?CenYsfcoMi1g0b/isz3n3shf2riA12h+Y8vNW+aGsxfS0QuFUab4OeKv8XEX?=
 =?us-ascii?Q?d1O7Tj4T86hvcbF2DXE9v4HKVjwd8UkQ1CkxAWjuGE7nB3WPeuDXUtETjMhG?=
 =?us-ascii?Q?mkms8lPcUUR0YFfj76f+bWDuzRmcs/Uzzu9utnEuUPhdGtIns1Bam6Tfovx4?=
 =?us-ascii?Q?zFkRvPZRCRwS4PqkOYzHnwS+iJQRT1qxc6AY7SzggYjFR68c6Zbmx/GtJ8vT?=
 =?us-ascii?Q?3IfV95aEzNugrvjKSAad5Ln0FCbdPNQUDVFIH7dMozhMtV1fHq1IrFB4Wh8E?=
 =?us-ascii?Q?lLbb2sM12kMJe0NIPlD7SttV4d1I5KKNcwLluq0lZQyvSSYZceU2YG6j/gCr?=
 =?us-ascii?Q?S+z+LKIboo2gbxN7/ySZX+Q7Ro0v5dogWMuEKMZtAVmieYe62H8ulBm8442l?=
 =?us-ascii?Q?HJ8gGVBg6bOzMWQsuSlU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2854.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ws0jRG/GQ24A+APwmOW5rz7v+vZz2CLucL8vbNJ//3aZ/K/ZcndVzeJjUHO?=
 =?us-ascii?Q?S12rrFVjr4LEUyy+BMa5z4CKaoPW7uhegeWZiUShWkuFw7m2ke84J/6W649B?=
 =?us-ascii?Q?1ONFz3/MKSOzyC/sgx4o/1k13aAY4uI4MWLwkn6/SSnR9d3mTUbfPRe32h3n?=
 =?us-ascii?Q?bdu0p2q6mXhhHxm4rK8LMhC0TzxsvCHECDPkDrCqSCurMHYxCnu8vZnyOdPe?=
 =?us-ascii?Q?9G0MkRuxELDU9/Mq3lLwaEeNZB+ph+wDIJp3bMsyeiQI3C7mtz46uowtOZwa?=
 =?us-ascii?Q?1spYfCWunDcj2jo1W11aViNTkg0DsbUccTI7BENzycnMNJHsivWEHCx7wgWA?=
 =?us-ascii?Q?/KbztxJzgLnp4zKq3Nj4xc1o3z/dhZCyxeiqSqRDidw8UMpujHbrs18KoEFe?=
 =?us-ascii?Q?/E+VJt/8M+9R5Cgry7lnhZioF8QELSw2B5L7EIBJfOSadLIi+fHk0fIWs6Ab?=
 =?us-ascii?Q?8KyBxVLGGXRSiEDPuOUZSiYW9zfOpkmV3o/sSOpDwSxSZqGoi/QLFdy2l2qq?=
 =?us-ascii?Q?YkzPXukGIsTGQwqPOKGOYr/yHqqhDT52UFPXWUXXTC5LVHA/SQr7UMX5jZYU?=
 =?us-ascii?Q?ogXJDdDGHNjAq8hmPTFXrc0azz97HTPbBF63U1vuCdLFJdavNgfEn/B+xPrK?=
 =?us-ascii?Q?71gTfNSnkbIsM4oEV+hy571/h0apbCFk9i6JWUBihE+dk1M22utVwZk7x02h?=
 =?us-ascii?Q?AhKcnGGO8WwQ2ywnOsoZMBeWTBhftXcnuom4NYWBuM2vaqBZ7ey+Z//5XZvN?=
 =?us-ascii?Q?sZCl0mh+iqbrSlkhEbtVZNuCyMb88X636yBMb/LQV/AlPJ/FJbIIvKXRPHta?=
 =?us-ascii?Q?tzyswYv8Z/4dTDHD6uv5a26+Bp8cE5eVb6dz+dgdHc6QgmV9+proVGkh6YJJ?=
 =?us-ascii?Q?7D+OoNG6Izs5ALPU5ZtQoeuhXLhRjXebD55tiCHihoJi+pz1HYsfmBr83fbq?=
 =?us-ascii?Q?ieY5Rxajwj2jTTviRKV8wuSSzWz2hSkXiKpTpo0tGatVUV7NPYVYwTuz8dgA?=
 =?us-ascii?Q?5iP7+x0G3dGwrS2QnwWBS2poTXPEspS4+lA09sX365cJkU7Nq6EQlhlNR0oA?=
 =?us-ascii?Q?UcYmqPeTAVaeqm/GsPPDbmfwBOjDEVvfALDc1v7W2TWetrIikpkCBG7RUIiS?=
 =?us-ascii?Q?T5rjAG0lZL26yaBsMRoZ6D+mpaCOZ3S7yOBjJa9oxrxyhRLyGR3bwC+O8Ez2?=
 =?us-ascii?Q?tjsFMRKx8fsiZDiFQjsUZEUzCTm6dztnYBPoP3+010iHg5ZnyfduIvZmliNx?=
 =?us-ascii?Q?YJ9nMZaD0txaQDhFKZQ1B7FR7Flg2oBIIzLHuf3fjWI+Ft2zpVU5JECGrcvE?=
 =?us-ascii?Q?KAmd3KvdV/zXjHpdpqKkKIv23O3Jc4ogKWGas9r+HHNIEeyYa3ak2odTUVtJ?=
 =?us-ascii?Q?cxnYLXCmEQ6nmYvhQQqi9XR/rfBgnNTdT8RgKuyjUsQsBKnG/2pM8PFeJwDt?=
 =?us-ascii?Q?vHGVHhxW8wTO9UeVPuELi1FVxtbaIIU7LycIEuRwTigUauNYN9DQO1q+eqWB?=
 =?us-ascii?Q?wvcgPbtc3qgbY+5+dAAB7Cwrnr58UW1vbS7LXbsyml3R6QTGlIuklGeNXQoz?=
 =?us-ascii?Q?l0DWnonTs7sPvT9z3xQhszK71vMd6RnLNnSH2Tx7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc4a259-17ad-4c91-06a0-08dc950ed949
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2854.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:03:39.0957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQgAtv7TqYh1ul7H19M2lFzFN//DzwmEpIlibiRzDFhekQ7f0iUF/ha8TfSAFflR71+6nR/8RAKwj3eaRvnyWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6890
X-OriginatorOrg: intel.com

On Wed, Jun 19, 2024 at 04:16:56PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 19, 2024 at 04:03:29PM +0200, Francois Dugast wrote:
> > On Wed, Jun 19, 2024 at 02:53:52PM +0200, Greg Kroah-Hartman wrote:
> > > 6.9-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Hi Greg,
> > 
> > This patch seems to be a duplicate and should be dropped.

Please also drop the 6.9.7-rc1:

https://lore.kernel.org/stable/20240625085557.190548833@linuxfoundation.org/T/#u

> 
> How are we supposed to be able to determine this?
> 
> When you all check in commits into multiple branches, and tag them for
> stable: and then they hit Linus's tree, and all hell breaks loose on our
> scripts.  "Normally" this tag:
> 
> > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> 
> Would help out here, but it doesn't.  

I wonder if there would be a way of automate this on stable scripts
to avoid attempting a cherry pick that is already there.

But I do understand that any change like this would cause a 'latency'
on the scripts and slow down everything.

> Why not, what went wrong?

worst thing in this case is that git applied this cleanly, although
the change was already there.

But also a timing thing. The faulty patch was already in the master.
At the moment we applied the fix in our drm-xe-next, we had already
sent the latest changes to the upcoming merge-window, so it propagated
there as a cherry-pick, but we had to also send to the current -rc
cycle and then the second cherry-pick also goes there.

This fast propagation to the current active development branch in general
shouldn't be a problem, but a good thing so it is ensured that the fix
gets quickly there. But clearly this configure a problem to the later
propagation to the stable trees.


> 
> I'll go drop this, but ugh, what a mess. It makes me dread every drm
> patch that gets tagged for stable, and so I postpone taking them until I
> am done with everything else and can't ignore them anymore.
> 
> Please fix your broken process.

When you say drm, do you have same problem with patches coming from
other drm drivers, drm-misc, or is it really only Intel trees?
(only drm-intel (i915) and drm-xe)?

> 
> greg k-h
