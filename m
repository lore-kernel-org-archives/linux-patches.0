Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792435831;
	b=z5au3KutVxqBp1/+9frGpfpmeZvDmVgBT+VSDoEQwknmh5gOgs/JJMikQ83c8qUiLMFK
	 A2oHlJaneJPZaDVGgReFEHdP1mwHby4TE282LwvCCxkqh8CxTw2C1cVlw7Hl/FaVE9oJa
	 cFtS1xevCmFyDfrBFG1BHHdJNx/iFJSAkp2wELDVLS0EY2VFLxdor+sMii9aDH3I3H/7d
	 rlxLCaeFW+h/f9NhWzFjfIQ9vlUbdcpWzzvFtMzMiq5OQ9Us4MibEoBwBemR94V0u9h1K
	 mp57Q6Hnpm06W5RHl85GN/86M0g2JC2cAZ6EhtgQQ56CWQyB/4/pJr1fpELKZtozeIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792435831;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=prFxCTKy6apq/Jn6aJacJzwvHeCYD1CwAwd34ScT3Kc=;
	b=5B/+ORMLTlLWRvPKT3gNOOS0UpRYLCmKlW84cGfFOZfJmhtXsjK8B46rbAQovZ7e4xZp
	 G/WMfArJecEOVafNe7yha8g451bwiYMFc9KGMr2gBReskFN0u4G48OZypLgYCBedi9Mmz
	 af885q4oWzu4LYMZipPW2JcWd/VbtYYG0b7j+R3o5Daeonf/MRM4lS5Uv7Wbj84c/ClWn
	 jrEaZizzk/hMkXdQQobwagEcHZq2eJctLSEVhFeuoS5lVXM9VjH2tOkIqiH/9Fv6kj7a2
	 sOsUqyfq/mczA3Q5orJ53L6kTCtuslGDTU+2EES+ulPK8mSvWBOIrPudOTiYu9IxMtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jqc43mhh;
	arc=fail smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E39606A31F
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 18:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80E39606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jqc43mhh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792435829; x=1823971829;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NtB8O1e/H6INNNp5XkefiyCz2MyTfoXf67MvpyygmdU=;
  b=jqc43mhhXkTy7AHjxZ9JsINuIAJnQ/Th6fsi5LBpfHXHBHw3+XhcnI9c
   KG3V3oaXnAejQn2YhPYmu9TxbWmfA3L884aqklEsT5MGA215f5wh4t9yV
   bQDomRldHN6ni0UUSh7H9mLujhBi3CWFmrQWUu8yoXFkzOFQSzT3fE4Im
   exDhxrffbbNI30dTSulsijqYV+fG2UvZhrvLg6+4Io2mGFHcgemzV1eaT
   ra/k7mpVsWSZr2+ER0GgFkqd/h0CkPQUTcsir/GU7uFAoezA2MFEKzrir
   +C/746rqREe7Hg3V+QQwOfux816TyALopEHjYKkMppt4CNrUt/SzGYE2Y
   A==;
X-CSE-ConnectionGUID: pcc4RF8MQ4uSPx2Z0xnzWw==
X-CSE-MsgGUID: cySCTUpESoG3BntZOX4sSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1023158"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1023158"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:50:29 -0700
X-CSE-ConnectionGUID: bMpbFAvMScSMcbcOjNpRbg==
X-CSE-MsgGUID: 4BKYS89RQg+0gwE68y3tlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4436289"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:50:29 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:50:28 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 11:50:28 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:50:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTiVv6t1D86TanUicX4zEhK38pWqJqnBCtRmYaOkFRo810DU0uv9ytQNPl+uswXdjta4zS3NQqs2QkGyrEb3iCMhEWwo0Jdfa76CYBCSOrg2OYzvILcfdNXT4mC/pLxvZ4sgcjJaMs1Su/X+INwVgqO7Qw2vt8Wo0d0p/cXtX6YUCE6Jb5mxq2MatQk50/Ux3GzapJs4zYIqJpLqKI0WyPj6l8k98mc1ztBLpfBDhv2H4+yBZWKe9A3GIh9BcZn6sK69bFxMyxjZFNSD8SbKuw9dpXvviJg0/wfH7J0L2kU36+zcF9XlXKZXISoYOldYolqaQh91nPDe+BNma7Xj/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prFxCTKy6apq/Jn6aJacJzwvHeCYD1CwAwd34ScT3Kc=;
 b=UpD2MSj8ZXMCz7yfkaOa0zVJtam/HxUHy0XmicrY2J8bGKQf1/ZJw9r5RFXXwoYivTY5XSuCljwLtAqlFLM8CxUPutre9++mcl7CJkFzFiS86pZCr0/l6chfbet0EqWBeGX18YNhU5GZKaztJ5sgDtKUQoAKlszYrJRZo6QfeP1Eq31VKkNIFIzPLAj1jSRFXsyuVgRflGH6Vo17vPHvHBtKuFPI3x0Zb7GwUMru3oamp4PP4zQsEVD4thbwSalLhsE2NFeaa0IVTliaC0CUR7t9Oxbjo2o4Gq2mywAvQEjyMATAt44F8h8eZ8TVv9k+4iZs6haXjFz7BOLgseXfDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA3PR11MB649961.namprd11.prod.outlook.com (2603:10b6:806:532::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 18:50:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 18:50:13 +0000
Date: Mon, 19 Oct 2026 11:50:12 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 04/25] x86/resctrl: Centralize monitoring feature
 enumeration
Message-ID: <atZmZD3vSvZHNofi@agluck-desk3>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-5-tony.luck@intel.com>
 <atY6FPFvbwlat8JG@chenyu-dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <atY6FPFvbwlat8JG@chenyu-dev>
X-ClientProxiedBy: SJ0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::16) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA3PR11MB649961:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af0cca5-9af2-4a68-2572-08df2e11cf46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|7416014|22082099003|18002099003|10067099003|3023799007|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: y4pt2ivk81eYVpcB3iIHjLw6OYvfxCSx7Gj7xNDZoY4jserSHleHoUyYyoH/Ym/o/kgIhHxMW86M6XhMq1lOdDQy8Lp2alv+RymtiU09p3B2VAFI0Y18T8OQf+A0rwyrz66t/iZzwom0H0f6kqRQHUykI8Sqo9SpLfrbL0RWL4fUWuqeQ5mKaUZ4y8R1Bi4QDBoLP3SADRUZIVRkDXX0ogR/0glVWv7i2po6J28EBuuB8vLljv9IJbxEznmbElFlJhvYIXfqa2aDq0e5bOAe+o/aZ33RFFRHBVbsF0HIJYsqDWQS8+uFAgbkZdRprwb8xpnHDevujsCFbAgmQWHQa28ajMtaTrSNARPHhYez0FEnBvu/nco+yPz5P2Zt3o35PX4oEwS7ld5u4HQyit5dVRoDvBvhqQ76hrZjuxLS/tvGAvqyKD2IscCyyPCYspIuoccPTao8eIopPQtBS5EACElXzdFrTUG3eUDhZvl+JUu2NUOchKnZoBAnYc2jTFNLOg4Vv4noC3vw0VbtsEr7CRrCRDUH1fpZbCAmGkLRiGKB9+JSpcP381k1XjK3wDxhiIVHw1FdM0fwGlEj6srYXs5VFwehagiBwvfCxpyAIhe10YLlRmVMIAwPBothp55qbf60Gm/d+zugX+gC9ZJQ/N8wnRcj7EIvhbDzbyU0r38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(7416014)(22082099003)(18002099003)(10067099003)(3023799007)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mo6xKj3cC7+9MCghpcADkDurjS6v0P50Ph5tDJ9qNR05jHerfZbD1wbQtOQw?=
 =?us-ascii?Q?P8w6RJ6dfe2j1hHH1Adlku9GcsbGQf4FCtfWgXnSX709VT7hdau+IMC+tyDt?=
 =?us-ascii?Q?03wSa5LHddA5ojeQmGzg5VTi5T5fzGGviKf8wHwZerJQXptxPea4dLC4TqS3?=
 =?us-ascii?Q?pQAqlxF8+TJ21hNnK3ktFByITnPS7DJqp7kQtN9FeikFTXRghwU7FacGKvmV?=
 =?us-ascii?Q?fi58WZ3SZIf0Yg5Nv3+5e7r0Socw1T2rxmk+zddW15jE3jyJORMBpfbxHz2m?=
 =?us-ascii?Q?kKjh+FfEEV0uI9BZ9PFnYvB/u5XqLYaGIg53v1F2GQAqCFnguMwPzp2sgDHO?=
 =?us-ascii?Q?Fq8Jmi2HMNgZtEy9pZrCfPGAdZh4R5Np8wI6+4WsP0ip2YB6gSrFEUhgsCYd?=
 =?us-ascii?Q?3VQp3APs4B6NRfWROU5MtBYgyKcz+9NBTN5P8SMvPm/lx743GpFT1LgjaS+9?=
 =?us-ascii?Q?ib22qIYlxjA9ZZ1DKo0zzQuaWtegM9QhcVYvnmfKQ5V1MuJAKayvEpZUh3rc?=
 =?us-ascii?Q?YK0TC6LqTjCY4N9ZRnktI8Sr5Yom/y2gq0eovG2cfzWcTxjQsQeCZTyUPXoO?=
 =?us-ascii?Q?KDjDm6ymlOGDE/9vUF+IJNz0wnkSzVMmkvqUYKm6W4XDyFe8Ho559OMRUu9M?=
 =?us-ascii?Q?sOAE5sgfPsRmGpVaX70ODDLN9a12akWmuwjlkntGTTrsL9xYqcJNwTFqqvbD?=
 =?us-ascii?Q?HHYFGPS0aNAfSE4Fa3BOSctho5s1fIoBgRh2WigKRY2WKEd3n4njMGVQ6+P1?=
 =?us-ascii?Q?mI9/39sIl2n22gMvSASq1KBXp9EeFzSnwkAu8cEmfgB81hc62JJLdDki/kyI?=
 =?us-ascii?Q?f+CZNMLaBCn+dF1aRQ5QUNh7mVjNkTV+lBDhqlVqLQGedS1Hgs4zPP3pRoq5?=
 =?us-ascii?Q?qQlnXlhJ4lcqjug0In6NJJE+Med54j8kjQMflgpdcBPkGGZHVX0ztM2+JHye?=
 =?us-ascii?Q?RCdL0JnatZWeNvahf8i6t1aCGmzNS73d2M95xU8ahVO+ZuNiglPr8jURCe8X?=
 =?us-ascii?Q?LBumyMyLHwO/UGFCdDfVPH++DDVSGfrztPvQQKB9f/DhSaAEBenxYzfgLwBh?=
 =?us-ascii?Q?BEwurO+hd5f2PWliNpqUQ/Ls+YuryiXKekBzrzfISWaCipZiYDelwQpG8bOR?=
 =?us-ascii?Q?JKG2T/UCyMood7GUabrK484QkJylakUVvDIE7QQzz8sO6dk54ApSE3ih7tk+?=
 =?us-ascii?Q?/v9JDqOXO1EAjbfXiti9SpwCNrUQSVJThygMBI0Yicjk43n/FMVBX6KdAZTD?=
 =?us-ascii?Q?cqDNEy580Ji4tyxJWWBezXlirKg6H9NFsds/uLWNgoE0jbnI8EU5OlRayWe+?=
 =?us-ascii?Q?ZEWsd2SFkzE+5mTCOlaXO50euMdzlcCxJ4/618ijKQAj0kOGTZiMRIGjyx1/?=
 =?us-ascii?Q?SrOKZxUdcW+TTv0vtywKReBcn4tT/7rjR9hAATEtmrX8OaJFguFh7c9/W7fP?=
 =?us-ascii?Q?/COgQpjOgPsHkOWZMTx40bLvQiUtc3A6XkEvOdXE+iIb7QlQQIZnX3HrcFHQ?=
 =?us-ascii?Q?dEGGBYBFn74eGwYgWNo8abxkpvJwb1QAYlJlYG0Q/DZmkQLI33yuJiKLXL/D?=
 =?us-ascii?Q?/hCmoqT2tELRPKl3gUquYLvSj+RwnCWTRDZ9ga5WlMjgkzjb9T9EDN0KIEFm?=
 =?us-ascii?Q?ZkZBR/ctKU5iqBZUkeQlOWgogNgs7FlHCEPsQcdf7xHYuiXmEoCVetGrLxl5?=
 =?us-ascii?Q?1J12ij0tkkgpxaYpFlR9/FA1YwvkLJvYP1yJGxX82Zofy0vpr+zwaIAm3uHS?=
 =?us-ascii?Q?zVpgZy86yg=3D=3D?=
X-Exchange-RoutingPolicyChecked: Mb+scOvu36r00C7nAf9HRCTTKwqlqgTaVXBajxh0dqi22rvlhVBEMt/F6E/xpcL66rZ8ARUOwVVnsrrvBiInSwJS8bJEi4ZXqKAT+AKsRkT79Mvs1PsWBKsoHcXUOXpkg0cyVtAfwtmF2Xemua/rv2zmOiO8GW6ru1M8Dr7D0/2CjGCOZ2szNBWQ7XXRvr95f4E2wS9wtlTCnWme9tVKMemEtNxHo2eCwQ1XPHd4xPGybK6ujOnqcQhFdYo1APKj4EWMiBINr4KH7zBnwGBe8kFtRNX1XlKZFSMuD/0ZBmbW1bIvkowVlmfKrd92GwDhDE/WbWTeAvke1C2+672/VQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af0cca5-9af2-4a68-2572-08df2e11cf46
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 18:50:13.9027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TaOFtdRCrICN8ktHECHD0OCfhhkhRlPrnUH54Ly4qNfLPd3MJldtBdoZoA7f78a57i+wmi2Rp1ykzMfV2ioGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB649961
X-OriginatorOrg: intel.com

On Mon, Oct 19, 2026 at 11:41:08PM +0800, Chen Yu wrote:
> Hi Tony,
> 
> On Mon, Sep 28, 2026 at 03:14:48PM -0700, Tony Luck wrote:
> > The original implementation of Intel Cache QoS Monitoring (CQM) planned
> > to integrate with the "perf" and "cgroup" subsystems. With that plan it
> > made sense for parameters from CPUID to be stored in fields of the
> > cpuinfo_x86 structure. But that plan was abandoned and the resctrl file
> > system user interface replaced it.
> > 
> > Centralize all L3 monitoring enumeration within resctrl in preparation for
> > removal of resctrl fields from struct cpuinfo_x86.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> [ ... ]
> 
> > @@ -132,11 +133,9 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
> >  
> >  static inline unsigned int resctrl_arch_round_mon_val(unsigned int val)
> >  {
> > -	unsigned int scale = boot_cpu_data.x86_cache_occ_scale;
> > -
> > -	/* h/w works in units of "boot_cpu_data.x86_cache_occ_scale" */
> > -	val /= scale;
> > -	return val * scale;
> > +	/* Round down to nearest h/w monitoring unit */
> > +	val /= rdt_l3_mon_scale;
> 
> I wonder if we should take this chance to check if rdt_l3_mon_scale is
> 0 on broken hardware?

RDT has now been on several generations of CPUs and so far h/w hasn't
been broken in this way.

> > +	return val * rdt_l3_mon_scale;
> >  }
> >  
> > + */
> > +unsigned int __ro_after_init rdt_l3_mon_scale;
> > +
> >  #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
> >  
> >  static int snc_nodes_per_l3_cache = 1;
> > @@ -418,16 +423,37 @@ static __init int snc_get_config(void)
> >  
> >  int __init rdt_get_l3_mon_config(struct rdt_resource *r)
> >  {
> > -	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
> >  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> > +	unsigned int mbm_offset;
> >  	unsigned int threshold;
> >  	u32 eax, ebx, ecx, edx;
> > +	u32 num_rmid;
> > +
> > +	/* Resource monitoring leaf is 0xf. L3 monitoring details in subleaf 1 */
> > +	cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
> > +	mbm_offset = eax & GENMASK(7, 0);
> > +	rdt_l3_mon_scale = ebx;
> >
> 
> Sashiko warns me that ebx might be 0, would 
> rdt_l3_mon_scale = max(ebx, 1);
> be doable?

That would silently hide this theoretical problem and give strange results
to the user in ways that might be hard to debug.  Better to crash the
kernel with the divide by zero. Debugging that would be easy and quickly
point to h/w as the culprit.

> thanks,
> Chenyu

-Tony
