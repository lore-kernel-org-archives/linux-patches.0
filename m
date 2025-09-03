Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98878362993
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756924066; cv=fail; b=dqc+0tkhYPTmq9jWrW//SD1172v/t8FRiUWwzhWNzs3WSDmvvSXQjfjLdxs/TOkalmMK0gzYJd4/eA2p+TH055aqnGNpdwqXpw86VgzE5uXpsaTdzUyqAP86aUFM3A4HamDhy9/xw/Q8XeihP98EDXRQ4Ov3N1lIGT0d6TU00Ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756924066; c=relaxed/simple;
	bh=Er3GUAvaRH0f9g3taHmaPw6gCwsWybwGVQk9LO34zL4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FaahdFoqRkMBjIG4c5f2GNWYBh5/GAkaj8nOiAIahW7dpKaJG9+gm9LtRIS1qtOVnsYaarHPVgGvQeZIhG58vx5InHCVJYwyqPxMLpBgs+iNBZsOZsVfb8ZliMztJ/8hs+osZgAHUTYTBO2wQlbKA740zU9PVUAk68+YVBynjg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPFjXS5y; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPFjXS5y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756924065; x=1788460065;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Er3GUAvaRH0f9g3taHmaPw6gCwsWybwGVQk9LO34zL4=;
  b=IPFjXS5y1gf1qx+0GSpF6b1Mv6aK4biVZJRgaCoh11cP/Fet0VR3zqlH
   yaxwxUmHlU+pJwEJTk75VMt8acB4lAUFlZZdmyNTMEZa6tvk5pUG9MmEW
   VMLiKtbTBAc2ljPXgUjbV+XE8Givh4AANQisPeP4vK9rbR8EivseOEfKm
   LlkpeLmC0OPyb5netCKHZ/AIrTNDNCJ85tdjq5uUIq2yTkNFcZM/r300M
   2uqihy1l28EUiIsLQkoT5qVriJGapCgyJHdnafvxQ25QrWuxwWGIsrEgf
   bXTJ1vST51UR3aBJQopfoUIO/bpPeCJ7AOX36OxzPTZXy41nd2m/LlrEH
   w==;
X-CSE-ConnectionGUID: 5S+zdK4mSLStj+H8pT9M1w==
X-CSE-MsgGUID: s5KfqXZ/QiOUnr2N3+U9og==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="59316385"
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="59316385"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:27:44 -0700
X-CSE-ConnectionGUID: ppzEg0eYQdWncYSDTTHS9g==
X-CSE-MsgGUID: IR9KqV+PR8KsNYHc8gEusw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="176027735"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 11:27:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:27:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 11:27:42 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.71)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 11:27:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yk3iBzi+KCg2ei00vS+I187llWDQf1XDzeOfhLdTx0/DS+ODuhusiLL3+Xz+FovaAE/pJodvzAinGbgZR/1+pTEF5OS0eh2NSrY3umRq9d6ssBq64Px6kJkBcrEohvQv2w9q4nqkUSx8h8TenKAEOZMIjMcOtZZH5E5oelyKNsOdxrXP55cxYt8MtI2cYpRYXDohHeBQzPMt0HCQiiv8GhpUi6XHp8e3N54FVnqZaInuSacdne41gDlu2QrT52cLjabhlJYvTrthZWl+AfWdTJKGvdp4BfWccwDeOmrBYI3s4ZMf1sUGszor+Y5+XctlphDwhSob4zL5Ll5YFo4/ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Er3GUAvaRH0f9g3taHmaPw6gCwsWybwGVQk9LO34zL4=;
 b=blpRQSYDTA/A36VkmXYoY/UcrLUTPTmGZsvKNNczuRI1ZcJfeXxxbNgawXA4mJMVgnfieqyXwR1Y5RPNegL6sXlvXnc/qQTzdXuK2SL1FkEOj41RvjOU6+o8BlimpEXGxChMWRxsq5mrPW6OCDQq5aTN4zIe3Y2Vcmsfhd8ol0gXv3Ljl0L5vgqNTaeelr36Cc1o3R0bbR+1LPTQ6MxfAxkySSZek/LUYxbHe/klI1KlQgwDjG0/TZ531v7icuBqWe5esUd7gjDUzYPGNzpDNx+mCWp1p/HwPOZhBs1PMFoTGOKbk4QJS6+s+IpSZaXObd1MQjv8ITLVSLJHdLtLYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN0PR11MB6231.namprd11.prod.outlook.com (2603:10b6:208:3c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 18:27:39 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 18:27:38 +0000
Date: Wed, 3 Sep 2025 11:27:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 00/31] x86,fs/resctrl telemetry monitoring
Message-ID: <aLiImLfarHgDFYqF@agluck-desk3>
References: <20250829193346.31565-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
X-ClientProxiedBy: SJ0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN0PR11MB6231:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9a649d-c050-4399-fa3a-08ddeb178fca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RLWHMJQrNWXrUJKFHwXiiyvvQ1pfiEGbKReOv3xJTDnPT2KHXwXUDr03RT55?=
 =?us-ascii?Q?QlL8VKzrcETJ63x5xdC8ojG+tBNRsCuSK16gJq1HLU1w/ByYNG4EzLfBudOs?=
 =?us-ascii?Q?nxo8wgLuut9+jDv7RZF5ksqZf6W75b0c+t2wS3PrkaEHmqayam9eJlCtA3Wv?=
 =?us-ascii?Q?SXY+l1PfD6s9T+H97vqlYZaTgRLEx7NxJzfo3Ec+P2avfBglbIg3fcSbOi9i?=
 =?us-ascii?Q?hUsGPUkSn7UiGofrJ06Xvp8DCpFW6BWDTvvuGjG/sCU2pNTPuAG0tAxPurPg?=
 =?us-ascii?Q?fO/jy+0dmglss3vwqnWZ+a0dBbjhbiPCO6pJKY0Z3jnaInnpVou+sLHgZt/r?=
 =?us-ascii?Q?hzFn162K2eY0MfjhImsNtRzO1I45Mp0oZAT0TOaWQPgWHaQwO12i5i83VYFA?=
 =?us-ascii?Q?sVeZ5JiXYPKRW65iwFHAjaL4MS+W3hNDOVCZlFmJgvRbhkb2Qp56OU7eoH8j?=
 =?us-ascii?Q?LK+qwbbX78u7fSx1674M1M1G4omAV9BKzrcb71Za0kPS8pMSe5SCoovlZovX?=
 =?us-ascii?Q?RE7L7N3Gw/ClZ+miTdJ5bZiw7OuycKx9XZv40F5a3Y86d0Rde02OEMAAopoR?=
 =?us-ascii?Q?HN4o1hmQOAdDM3MCSAgYqsRxRZN+U7jWpmhEe+mn4KGybns0mWe1mzttWnFg?=
 =?us-ascii?Q?xoTZzEgKUCbsl5tskpzUBaCrgp9enfQYqqM4ZplEus2kN8wv22E51uk1W/kP?=
 =?us-ascii?Q?dNfJfXTae3XyrkriS76e3R3Le73IDb6iqr2WWBpkMtjodiSf0fnu/JCq6Rvv?=
 =?us-ascii?Q?B23o4MItQ6HeB2NB+Z1uortifCikxs4FLKeGOG4eLP1SG2ys++MLJzt9FRb2?=
 =?us-ascii?Q?3mxrek0zUSn/GvwyT2ZAMt8U5dMf5slSoZf7p6ONCAFxPVhMoqJB8Q6vz84h?=
 =?us-ascii?Q?YDnUYy8rSf0Wa2CAcP5xM9M/bvUi5nGOzs7TyxCVgkriADnDnCzDPisor4iL?=
 =?us-ascii?Q?XCWdbJdbYraeOIsswT6IxsHr3VNSfhLZH6B4eGoqsTO+E3V0bzMo4kFYtPgv?=
 =?us-ascii?Q?5Hcy3eB2oEUouW4TXkbm1aGzVQXC+cPUMPGd1veZacNHD0wSDOONzQMcXXAA?=
 =?us-ascii?Q?mEqjxG2McQZAqr4OAsDCx8R7MnZlgaQlnXAPYl7aa94q8KqZXgtRaJaQYLAi?=
 =?us-ascii?Q?IMwTojFyeQFBSFAeUDzTxXyMhFIuGLGM5+D1d+A9iMr637IEhmJ2uOvlaKjP?=
 =?us-ascii?Q?HruDPHY/m3s3roOpSqKRP4OKV1D2iVJa/EU7re/FZ8E5RkL9FOYcInn5dc5X?=
 =?us-ascii?Q?U9TTwtuJ+rrXFH0PT1aUy6uBoU6KkhsPkU/FM90pfHKoN+sQK9NDRqan1wXm?=
 =?us-ascii?Q?6giUS9suvs6hs6iv/qeruqhUOPfvxlxozRjoJDEW2co0YXSLS7/afrIZ4sGS?=
 =?us-ascii?Q?3+ilJrXQR2HhxSHJkYIWQUVJHxovP8H5AhVjB+DWOcBhU4gM7Mn0KbX42cms?=
 =?us-ascii?Q?Zh6bxeo3yxg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZVhTWoqH9vuo1mmGEyipHKDyD9lxxuUudf2WGNjhOI4ronF2jo+xdAsiw8Hc?=
 =?us-ascii?Q?eAg6zwTOSvXxe9ren1sGABvSUhzUNOVW96KDeLTUqX+sPIzcD16rH9YGgOkA?=
 =?us-ascii?Q?1ZDZtd933GMmwAVPk71E8AggOvfG12aU96CIMpSriN2c1JnwgxOxFm5DCmn3?=
 =?us-ascii?Q?nDPUC8GocfwOW2xIJvV8CBi+K3byM9XQW+PZBeBGXmOFt8Gr4mw1m1+JR+cE?=
 =?us-ascii?Q?JkRie4LjvRs13/8LtRv/RWxbKSGl8CxTZHC0VJQ1To4j0P3PIpRddlup0wkJ?=
 =?us-ascii?Q?N1tGwWVr3ExMevDDoD6j5KcX30pgtk/DubyOYLbxZAMFpRTaBoXSjr6lu0fr?=
 =?us-ascii?Q?ebuQNr/a+BcgYnL2Z7VNxgTbCto+j7r8m01Y0sB3Wj3CCbmmQpIIu7VIrxyZ?=
 =?us-ascii?Q?BBGJEU7a0P4Rb1ijJc+L42icrgNGg8K3f0tl5M1k1J4jEqGWlq2VA3w8noFn?=
 =?us-ascii?Q?PUMK4cVvb3Zu+HWL8T/i1MXbRkdEbRl/rAYCMliozih3hwwYkeRJ1ST9JX3L?=
 =?us-ascii?Q?sT12XXMuhGxXR1OYxcLraXQFvrHmTBx9Cdk80rbq2RrPs4V1Ou9AUPYwF2QX?=
 =?us-ascii?Q?XE7WW/32oI0gWc9RB9q6UsZNRakI4rYSrFINcZUwtlW/OwuOgfXuFive7rBa?=
 =?us-ascii?Q?N8BmaP3KBGMjMYKg+gKBXMOPtgN8Qg5vwRoBavLn//BqX0iBrEzAwzwSIps3?=
 =?us-ascii?Q?AWe3AZZJPtrG5JTfqgWV0dqc9HQHXCEzzDFe4ktXQFiUxRPQWRq1fDFbJBDz?=
 =?us-ascii?Q?L34TD5bngSA85v0hKrRwCCI/Hp32P0BPB3VEdwBglUfa/vAunO6hwBOZDO7E?=
 =?us-ascii?Q?6bVDl6GVQvbEwfLM+lP25VAIrgy3NvKJAQLCQhRbjiPswsVqCEyeA+sAsrkw?=
 =?us-ascii?Q?427sQ9/+FkjsXqOhZAyYdAMXaTHdk4rO8nZ8ci6Cx6DS+aKW6++E+9tbd5w6?=
 =?us-ascii?Q?58+d5NK7jaDPuy72DkVpue/z2xVunmkbZZBAiWNOUJnHO85uIIrkVsOjHlCQ?=
 =?us-ascii?Q?R2c8LSxRYgEWFv0/01n9aR5DspwtG2FK/+bcGW1u3Z+VIzAQ58Q9DB/Wspvt?=
 =?us-ascii?Q?dpXpHUCC2ryQVyVoz7UFJFKjg3oKKw1e56UZDxkVefgVdN6q9nb44BUeTPYE?=
 =?us-ascii?Q?V73ZMJyyTKLvbXTiyFFfrO3hxjLkELSJgCiDtJtwu9A9ncgQvQ81Y+28QFfl?=
 =?us-ascii?Q?0SuuXsu0RqOeaMzPj6KSh0a8lrUG65+j5KvNuc96ir5EM9dBB1QO2R9+2Q7l?=
 =?us-ascii?Q?Di9Ej3x+L32Ji/m9QCMYM6CeYhUNYW6gndOk+Z92Uj3FU+hzr126z2pnVEKC?=
 =?us-ascii?Q?lUEevdJgeY6REAskKNj0LEy3NwCzGN7Q9Vz1BUm5NBB2H2OySYmVVOTO8JXd?=
 =?us-ascii?Q?UgJH+3LO3k/F8sa2ZVtjwKTmEjLVwLhAah8wGTgPAE5Tzt9zjpowaW+yAk+q?=
 =?us-ascii?Q?VkaET5RmOnHkMsbSxyYdI8ozUrYlD/1qdNgePgW98SZiMHylsESZyagCsS4q?=
 =?us-ascii?Q?xn1dorKWljonIQdHzZjzmTr6yjF5eMc2Nmn8dnUPfDVMg5c1CO33SqBrs2BH?=
 =?us-ascii?Q?M3LZa5C5W0R3xHPJ+NvW3WSb5WIzC91g9gamngcu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9a649d-c050-4399-fa3a-08ddeb178fca
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 18:27:38.8551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehFtOXB8j+XcbMz5+E/2We9K3UUeQP9zXxHkYiDa8ErSXCXSCZ7ZRIu/xQ357VtzMEhmf0yWJv/fBXUvGdozTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6231
X-OriginatorOrg: intel.com

Applied changes from Ilpo's review of parts 17..22

Updated patches posted as replies to Ilpo's emails.

Also found some other missing #include, so added those too.

Updated series at:

git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip

-Tony
