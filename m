Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D18418A47
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784067302; cv=fail; b=Wf75NjYXL/Y6mPKWsjw1y/2N3N8UwihGtj4+j5rrhord3Q+h3YI4MRr4Ja3udGnaMLtJ6YnWxVSoIK4xfD18gemvxMyrZfJk3ZvGby8TjB39rwEsH7Dv3B4r1IpW6LGaqh3Ti7aVJ430X8FBgvAgmd5IacDz2BVRBPAaTvSmdNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784067302; c=relaxed/simple;
	bh=gR9XuGrcegQteq5tZFxm7EeM/tz/t0FJRdTRueKi8y8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NMV4gajlw6O6C54av/yWdfAKRGO7aJe2gSAcrgcCgGevT6QeMu2ZZTeAyFF8Bb7ndfT8UxMdavkUhuqkjrdBJ87tDqgJtPzUx8mYfl/UDT6jsEnAzPa5MjbC3svYrVUe9SuJ21CbYqnoXoJaGdWvEUtODXMs+qDckg1aJ6WkG/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/9BlFMB; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/9BlFMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784067296; x=1815603296;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gR9XuGrcegQteq5tZFxm7EeM/tz/t0FJRdTRueKi8y8=;
  b=d/9BlFMBnn8EU5veV0Nr/EJ5xBdF/qnGaGgbLMleJyYYEuoszfwc968D
   000WH7r4tpcrzKogJ8ZgrsWMcVP+Hrrl18PAH3vtkqAs3u1jgYfdL0EF1
   vHXJM1rN4qKh7Q5OXAPuWhB4FSqJ9jGqCYe2LpRvsyAHEvGjPA7h8WkTp
   ciy1YGXO3cxCL3l5+5s/0qbOl9LuA0tQ22PXLAa1kSLrgValA6wKgUhf2
   /TzjT3a1szhOX5ruj0RUchGIvUsj6JV9BD/OCBAEjnT6Qo3RqrXrNvTED
   zs5BhFLAFxd+k9xW0DBvzvhDFsPT6Bisk4Q5rvo646fhVaX5hL8BNyUuK
   Q==;
X-CSE-ConnectionGUID: O56xZLBtSJ+xyiU/qiZvrA==
X-CSE-MsgGUID: M3+BeJNRT4Cd4bvJNsgEww==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96064283"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="96064283"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 15:14:55 -0700
X-CSE-ConnectionGUID: 80WmSYJ8SVuXskb9eWSGEw==
X-CSE-MsgGUID: UV2a8Vy5QqaeW31xggUTig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252017812"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 15:14:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 15:14:54 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 15:14:54 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 15:14:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wosKjYJy1f507Hqa6ZW5hQ8zCbuxwyOM7yiQ0ZUZtd4Fi2LSBcs/1zkdXfTiR/HCsBdj+Pjdau8DKSkf7U0LgfJICqqEXR6cxkAOvMoZcs56GFqpZe1BTh9Y/8/jVqPZkrc4Wg4CSM85scygQgyp5elfEQhFX+64wnqh3qg0pwMTonkVD7K3c+i/AAMgLbsN9AGrYl8LwGPn9o7wm3G4VdC7C1yQXwXF/0HeQOWqVXr3vCmjyVOnEachbfR9GPwRNjI11jglYhEzq3mWVAeWwLSKrECHW65xLXthTgBbCIkcQk7yon57aFzu5nm6BCtgtLjQb6d4UqWuARNl+Ihd0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knKa9JwKhpI3dlUXFgcqRJ6sScyXIiRU1G+MN6ludBk=;
 b=zPC2VSkMW6klai55fS5KDI4o7UABmHbGdkaw+w6NJHu/zcKIptnaW+FaeOq2FvstDonrOgU4ZvFbwVhVII8YYlVWddAJQECh3/RfBOaogOe4JO6+b2hiOyXa68aIyz+iTdXTgIZcIVixHUWeZYTurhkaGNrEQP2OMXs4K6ULn/ui2sX+7hIpmjc6Yguti2T1NDSRxsUm6TUAJgl3JsdGxZIiOWAWqxWD8CHUk9TGOxo1u42kGScSpo7bi2iM0Y4y6ccXWlDc710dreTGHtK2m7MChFZ4SElPZLVye9KNGRTfvUKRJP1Ulbui5V0PpaUTxAAHRMi7EV2twMR2sSH2RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 22:14:49 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 22:14:49 +0000
Date: Tue, 14 Jul 2026 15:14:47 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
Message-ID: <ala01wjf3cBob2_u@agluck-desk3>
References: <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
 <alZdWe-DACOtDwm0@agluck-desk3>
 <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
 <alZ2-eJ3yXWHVelp@agluck-desk3>
 <4f0124ca-d4a5-40a3-9bc8-3a1e75ff576a@intel.com>
 <alacCy4Ja4gF97PU@agluck-desk3>
 <1dac7a0e-8b69-4b4f-81e1-c010d186e69d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1dac7a0e-8b69-4b4f-81e1-c010d186e69d@intel.com>
X-ClientProxiedBy: BYAPR21CA0011.namprd21.prod.outlook.com
 (2603:10b6:a03:114::21) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: c19ec8df-7fcf-4698-f805-08dee1f551b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|22082099003|18002099003|6133799003|3023799007|11063799006|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info: tPjAYj36Qz0w7WaaaPKEAgLbONd1nmcttyF/iGQtnPtquuUFORIoGjz1Qh6Nkd/CzmDVHEh4340Dzwu7J66V0lciiKOljADA/p/PDNHRB7OtuSjLWYq2ZGreK0DpqhJDaimzWwJRh4JJs2DS1E+U7GFaz8C4GIaIixTJqttQ5c4TqQD7q8sDSJ+G2T2s/sMSjtsCOZp3O7fGIXEQbGmb5xge4RWa94F9YM7O6W6j2y24bZK5afUIwVR0K0IMxcoTC44B3vnIM02bpGZicUgTu5GjJYpiaBXO365BYlCIDOcxzcA0hNq/xEdB6cDfvsJfGsUdaKI1CkpCzSh9/UWKW8OMoEuiBo1FndxPsoAhwZASIplLXlt1ZEomWy+vLHvla5+ZbkYXiRuvLoNO99FyiHHYj5FC8wt2zo1ouoKG4HxMMIL6SKJFm9/f7czBCvZWuWEYEvJo1tzLnrmxLatr/Z8CLYWpiyLhgkg8BcRQUbCUEsJGBX49W13amAmECU5QR3kIZxbmcrdOaF01/3K2GucilXTpqSS+fGulCB4AcxH4gIa4dzPdpiEgXel9Vu4plMbkTCT7Pj913Od169TMEvJWFvRx4FVWIreaqNjYO27vtDhfcMu0oupRfcn0QHMV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(3023799007)(11063799006)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8TqGxPmeu9Aa1j2Lkbi+gLMldpkl8TF39j/Ll+EaXovZRWmrJtXaTrFQG6j?=
 =?us-ascii?Q?9wOPwJ/Ngari8J1V9GSPUi6tmLoJ0nYJMji650CGaPWUtNcwSsQJqNe1O3bR?=
 =?us-ascii?Q?7H88AeOvVX5cyruEPmBgrtMEHpTXhfSrd8h/azla0O1vJZsObakifSOmGc3m?=
 =?us-ascii?Q?QwfTkI0JTLsm/7Sej6DvJassUTOeYMJBYNZzkF3Lk1Y4xN4aI8SSQS3vHnn2?=
 =?us-ascii?Q?GOqvCn4pUhWFlnHPdJzG1M+uoj+lsTX0SdB4eZip99ncp3e6QEp0QhCDE6E+?=
 =?us-ascii?Q?mOD+rH0A7w5mQshZkcqv37+g379f6tZhYZQRsBsWZ2Rawb5m6KTf/j950zip?=
 =?us-ascii?Q?aeQUxgWseAWX8u7Ntm5UWfZ3JH1X461Jes45SB4AnAcwG0VxKCqj0FzWbOVm?=
 =?us-ascii?Q?+Y1IVkRyA/YHhVesQJY5vF8fKsJ8lhYOclu7E9PTTaCP8gpwz1U4XBoAbli8?=
 =?us-ascii?Q?aezQnX2Bmji7SyBGa56PssgLDBFNPGnkQr57SzJanyiisqNgTlTM6RLMYkmu?=
 =?us-ascii?Q?avBrh+PtjUrFOlPp5fzqs2RFZ9m+QCekC5uj3LfBPbIg4nAv+vQY+YnQVL3q?=
 =?us-ascii?Q?8hor26E8scTHYxvWQg3JB/kbmu6FhuHA+ZeOVxqowCy9DzrG7dlXgm7RqEY+?=
 =?us-ascii?Q?VWd0I6XoiFLECGX0G6Bt5Is7h1M/y9XiAT+3csUNi66DrxGFwwwhAmVjpMG+?=
 =?us-ascii?Q?QLIXKBC0o3SyWxv+KQPkEMoxQqrZwpAY+YO2EBCk/NKGz9oWayKNZ2KWMZ7Q?=
 =?us-ascii?Q?lOlh5AqMhwjX0Nfjm7by8PuUzXXRvM7zZ25QmWCoKA0NCIPUx77TJcSPjQuT?=
 =?us-ascii?Q?m3BSpwQwZ12j1gdtsFoAR7t9r1fl8+2TzH89sv3h7Zd3v+TCzP7HPFD/Bu3X?=
 =?us-ascii?Q?ixh2Bj+4Xf7DheMPVke8wtYwNWwzm6OpRPRsWDzYhkHL1UGtiCU7Gzr/XsEK?=
 =?us-ascii?Q?Qh/Qrqi/y8+INXOLxARYOleFxewB2+E8Wjiu74zDyKJsgay9QOaff1+cWfXm?=
 =?us-ascii?Q?jcbxd6GLLdVex0rMkFJ0iGoA3CvQKPee+u3N8iwr+ZO/sNE3NICCoNb+LPgy?=
 =?us-ascii?Q?8G/IILux4y8onvx8Geoo01Dx+k0B50iIpcZlr2jpUk3EjdosOqbo8PlbBRGo?=
 =?us-ascii?Q?LUIh1wUEwwaPEcIiWmhohoyjoq5JxtZMk/DY1H7fcEFuSmOwq9AOkeikKPUd?=
 =?us-ascii?Q?OKXWJwldRnAuY6Lg2RLgNQwPmwBn0eILB8aEuoXr3Vz3zpgzJFGgEfLXkew0?=
 =?us-ascii?Q?XlajY9WO5DdHk+QmtmjMrei+qXFlkb8WKubHNSHg+ckkWnK+bApbiZ/2zCy8?=
 =?us-ascii?Q?a6SX90EJtEvGW6fzuZnvr9fLd/nD0XTeiKVNvUF09dUGhWjKFBZt8XY5e3ZP?=
 =?us-ascii?Q?ZozpFkN13rToS0U0QgaMXOsIlQIfQvxCvcnV3u0uFXI3rByBS3F4ePgscO7T?=
 =?us-ascii?Q?TcinBQCgEo6KKGZriearKco2VdxXgp5Z5HpKZZHK8ZoaFiXHoMRR9o4cN5VD?=
 =?us-ascii?Q?mFI9HE5iXLqEbzxJ7pyKbjGNktckoIM2500fSec/X72qY8nwpSrh0McDXIEf?=
 =?us-ascii?Q?WQTDLmcQKfKjimjeHVH/e1Q/8TXaLw0ds7Jt266Qg/00wUtrYVAVxngW5kEk?=
 =?us-ascii?Q?zas/vCHlYGwScZ/0ziVng1UbYSpDrksrom6sURat2e9Y6gdpAUA39V3Z3pry?=
 =?us-ascii?Q?kRg0Jr8K6FqpdTnXKd/fxGBP9+n/MX2vU98Tr5qj6n+QyqBYaTYyP/st9IAZ?=
 =?us-ascii?Q?zn/ZWc/svg=3D=3D?=
X-Exchange-RoutingPolicyChecked: hnFMZKXbSpG1vWHUytkTiVj/cl9+CSgKrBu8Zuk/VnWvb5OZopNqUFD9mbbOeVOkhPw4Zhz7U3hQHRCnPgbPuVzXGKFbG3FNgHJBPo3X8aQf3nIWhIwHr3vrLwrPTThR3MWcFoxhMEFLnq/GfkXzQuuNAXM6vp5wE6QtQDSu4TrvzxaprIND522ZfbU9JscSM590z71eQYD1lW00Ro5//T2Y21laGtnAzRT7OrBzgDNaF914R4nnghfRLgXSU9fQ9V8yXxqzlXJtflxJCAu5I+Fetdi9M2I/u23EybzDvCm8GeZiTGv/EeyEtEZT3AEi+SU5f/J86Sg8kzYZqsR1DA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c19ec8df-7fcf-4698-f805-08dee1f551b0
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 22:14:48.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pPTobv5HHlodw6dVIT7oj4AFJJUTdkYiNXSh9qhiTAgBRgjNZp2XD3yAZ6cSmaUWkx8VjLLdSEXRoDkudKnuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
X-OriginatorOrg: intel.com

Hi Reinette,

On Tue, Jul 14, 2026 at 02:07:17PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/14/26 1:28 PM, Luck, Tony wrote:
> > Hi Reinette,
> > 
> > On Tue, Jul 14, 2026 at 11:16:53AM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 7/14/26 10:50 AM, Luck, Tony wrote:
> >>> On Tue, Jul 14, 2026 at 09:45:04AM -0700, Reinette Chatre wrote:
> >>>> Hi Tony,
> >>>
> >>> ... trimming to open issue ...
> >>>
> >>>>>> How much to rely on CPUID is not clear to me. The direction seems to
> >>>>>> be to move away from CPUID, which makes adding new CPUID dependencies
> >>>>>> less ideal? 
> >>>
> >>> Where is this direction to move away from CPUID coming from?
> >>
> >> This is the impression I got from the discussions during series that adds support for
> >> LLC occupancy monitoring via ERDT (https://lore.kernel.org/lkml/cover.1782866200.git.yu.c.chen@intel.com/).
> >> If ERDT is the future direction then I do not think resctrl should assume that the
> >> same data will always be available via CPUID also. With ERDT there is a separate
> >> per-domain maximum RMID that should be discovered via ACPI.
> > 
> > My view of system design today is that architects have a box full of Lego(TM)
> > bricks for features that they clip together. The bricks often have different
> > parameters - sized based on the maximum values across all systems where they
> > might be used.
> > 
> > In this case you end up with different components supporting different
> > numbers of RMIDs.
> 
> ack.
> 
> > 
> > For RMID the absolute maximum usable value is defined by CPUID(0xF).EBX.
> 
> Would this be the case even if CPUID(0xF).EDX == 0?

Yes. Looking again at definition of IA32_PQR_ASSOC in the Intel SDM the
width of the RMID field is defined solely by the value in CPUID.0FH.00H:EBX

In contrast the definition of the width of the CLOS field refers to the
"max of all valid RDT Allocation ResID.EDX[15:0] subleaves"

Unclear if the RMID width didn't refer to valid monitoring subleaves
because there was only one such leaf? Or perhaps deliberate planning
ahead for a day where there is a system that monitors only non-L3
events that are enumerated outside of CPUID(0xF).EDX. Either way,
as written the max RMID value does not depend on EDX.

> 
> > A WRMSR to IA32_PQR_ASSOC.RMID of any value greater than that will #GP
> > fault. So, while you might have an ERDT table saying that it supports 500
> > RMIDs, if that Lego brick is plugged into an SoC that has CPUID(0xF).EBX =
> > 399, then you can only use 400 RMIDs, and the extra 100 counters on the ERDT
> > device will sit unused as there is no way for them to be accessed.
> > 
> >>>>> Here's my current work-in-progress version:
> >>>>>
> >>>>> u32 resctrl_arch_system_max_rmid_idx(void)
> >>>>> {
> >>>>> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >>>>> 	u32 ret;
> >>>>>
> >>>>> 	/* CPUID provides maximum possible RMID value */
> >>>>> 	ret = cpuid_ebx(0xf) + 1;
> >>>>
> >>>> There is also boot_cpu_data.x86_cache_max_rmid initialized in resctrl_cpu_detect() that
> >>>> could be used directly? Looks like resctrl_cpu_detect() already scales the number of
> >>>> RMID down if needed when L3 monitoring is supported, but it does not take SNC into account.
> >>>
> >>> I looked at that, but rejected it because it isn't adjusted for SNC.
> >>
> >> Right. Neither is cpuid_ebx(0xf). Is it necessary for resctrl_arch_system_max_rmid_idx()
> >> to call CPUID every time or could it use the cached value in boot_cpu_data.x86_cache_max_rmid?
> > 
> > Yes. Necessary. See how boot_cpu_data.x86_cache_max_rmid is derived:
> > 
> > /* Runs once on the BSP during boot. */
> > void resctrl_cpu_detect(struct cpuinfo_x86 *c)
> > {
> > 	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
> > 		c->x86_cache_max_rmid  = -1;
> > 		c->x86_cache_occ_scale = -1;
> > 		c->x86_cache_mbm_width_offset = -1;
> > 		return;
> > 	}
> > 
> > On a theoretical platform that doesn't support X86_FEATURE_CQM_LLC or X86_FEATURE_ABMC
> > x86_cache_max_rmid will be -1.
> > 
> > In fact you can get this with boot argument of "clearcpuid=cqm_occup_llc"
> > 
> > I wonder if that test should really be for X86_FEATURE_CQM and thus
> > check CPUID(0x7).EBX[12]?
> 
> It seems that doing so would match the definition of IA32_PQR_ASSOC found below that
> you highlighted earlier and should result in a valid x86_cache_max_rmid as intended?
> I am not familiar with the history of the original enabling
> (commit cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection"))
> that resulted in X86_FEATURE_CQM not used.

Nor me. I didn't get involved with RDT until shortly after that, when
Vikas was doing the coding, and there was the great debate about trying
to implement RDT inside the cgroup subsystem (that ultimately failed for
a variety of good reasons, and thus the resctrl file system was born).

Plausibly a simple confusion between the similar names "X86_FEATURE_CQM"
and "X86_FEATURE_CQM_LLC"?

> 
> > 
> >>>>> 	/*
> >>>>> 	 * if system is capable of L3 monitoring the maximum RMID value may
> >>>>> 	 * be lower that system maximum. Either because the L3 monitoring
> >>>>> 	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
> >>>>> 	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
> >>>>> 	 */
> >>>>> 	if (r->mon_capable)
> >>>>> 		ret = r->mon.num_rmid;
> >>>>>
> >>>>> 	return ret;
> >>>>> }
> >>>>>
> >>>>> CPUID seems unavoidable in the case that the platform doesn't support
> >>>>> (or has disabled the various L3 monitoring events). In that case using
> >>>>
> >>>> Since L3 monitoring is the only CPUID supported monitoring resource I do not
> >>>> think cpuid_ebx(0xf) can be used if the platform does not support L3 monitoring.
> >>>> I expect that would mean that leaf 0x7 would indicate that monitoring is
> >>>> not supported which would make leaf 0xf invalid? Interestingly resctrl does
> >>>> not seem to consider X86_FEATURE_CQM from leaf 0x7 at all and just goes straight
> >>>> to leaf 0xf.
> >>>
> >>> I disagree. The definition of IA32_PQR_ASSOC says:
> >>>
> >>> 1) The MSR exists if either of CPUID.07H.00H:EBX[12] or CPUID.07H.00H:EBX[15] is set
> >>>    (in this case bit 12 for monitoring, It does appear to be a bug that resctrl is
> >>>    not checking bit 12 before looking at leaf 0xF).
> >>>
> >>> 2) The supported width of the RMID field is Ceil(Log2 (CPUID.0FH.00H:EBX[31:0] +1))
> >>>
> >>> So I believe that a theoretical system that supported AET (or some other
> >>> monitoring) but didn't support L3 monitoring, would have to set CPUID.07H.00H:EBX[12]
> >>> and provide the max RMID value in CPUID.0FH.00H:EBX[31:0].
> >>
> >> I see. That would mean that CPUID would report a max RMID value while also reporting
> >> that there are no resources being monitored. I assume ERDT is an example of "some other
> >> monitoring" and it has its own per-domain max RMID that is separate from the different
> >> monitoring features. How do these different max RMID values relate? Should this
> >> architectural "get the max RMID" be expanded to also consider the per-RMDD maximum when
> >> ERDT support lands?
> > 
> > Yes, ERDT is an example of a monitoring resource enumerated by ACPI.
> > 
> > AET is enumerated via a combination of PCIe configuration space VSEC
> > entries and an XML file.
> > 
> > See above "Lego" explanation for why they don't factor into the "max RMID"
> > calculation.
> > 
> >>>
> >>> For resctrl we have the practical case of booting with "rdt=!cmt,!mbmtotal,!mbmlocal"
> >>> to software disable all L3 monitoring.
> >> ack.
> >>
> >> Reinette
> >>
> > 
> > -Tony
> 
> Reinette

-Tony
