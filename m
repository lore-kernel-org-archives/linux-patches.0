Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595FE236453
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 20:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791405838; cv=fail; b=ne1cB5zXqwCqqnU6eEu/CpzP/5NooUEviS+xjnuq/WiCHyhS54pugu+5bFD3GRsaw6qDTEgedkw1UA3gQXTQeJB6ubOhgpKUSmDo66t5sZwh5XJMn9H2fzlaDxH0aD19eVqCiXkstbk2Uoe5tSH6fX/NelutQyGXf9UT6u9mzNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791405838; c=relaxed/simple;
	bh=bCMvWIx34lr1VlEbadinWlORNq2msKpQCFATQZF6Yhg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dgYpq9QsfqT0HHJQGgSZcGyjQjo9eX5n1lj5FN03A6JgLCJuDSnNYgbz7W5O6F8yyxqa0td4bmDRRVHjbRbh+uMd4ygasHPpeYA8k2LxBjMwdWRjBN4Fq7U4vhnYc/NbS2CfFfOZeJMnO88qayGomAxeMMEGqnsv21IZEs36RQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuFAvF8A; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuFAvF8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791405838; x=1822941838;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bCMvWIx34lr1VlEbadinWlORNq2msKpQCFATQZF6Yhg=;
  b=PuFAvF8AiVBJNV8mwfJ6YcHwqr4ZSqAV7Df2X857nzW0eIyi4+p+sVCl
   D4ojGemHLi9SVxxPH/HQETFMBG1acv5km8KDK+PVeJanpgRqnTtBTGtp5
   YAPDnPbtJGp4YZ91A3vZ1RNJa73lozrzEh3svuackPewU2ez0AC9QQkwK
   aNNxxjLv15YBfKOebk7CrcTRbde76f78wi+FKfj2RjnuzRqdCrPSvhEek
   7zdyWy+VegSXGrpRF86JVgtH6pSXVlT3vtfACACWLrTtecKCF3WbLIRhF
   SiuM+jRxbhJk58TjqeTOm9kjVLlunYC5Gwcb5/NqXAkdDA3wK89MsENAt
   g==;
X-CSE-ConnectionGUID: ay7SZuz7Qfawg2YAhLzoeg==
X-CSE-MsgGUID: Dhon1s5DTqKIAStnMpDLRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="81660"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="81660"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 13:43:57 -0700
X-CSE-ConnectionGUID: OIu9/ulwRsWCup6T6DBRFg==
X-CSE-MsgGUID: gFCUl7G1S0uGE7hj26NuYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="285629240"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 13:43:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 13:43:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 13:43:56 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 13:43:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QwgBOljHe6F0d+GsFdihfNoKcC6Lt4AMjmG/zoDs85ZZJ4WAFY8gYDLUEd3FL9i3Qcu8EYBROMeuCf5ejFG9isTYG0vNaiwIXRUuyhVNde8x/+WG+qcsSTTymzgD0jD9xBJC8tv50Mxo+3y8mcPg87A/OTLSquIwmbWbIkeZJDbIOC9C+dmvyb3ZknSyjNGLPR2nTGj2DZIFMuw2v3G/KAZPJMImQ0amWusQeCGocxuTOIEQTNHmb8VBzQX1vN36RsZ5R+++h876C8aD4LYioxE+BijI4YCnIUUvLPrar8LNLR7VHwwkUX82ZLPi/fT/B82MKlwXPZBuCol7hpFA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Q5JnwTcluBSvIzl53GJ2SuFVWX+GM7B9VMgV6rdqao=;
 b=XoyVIggzHp/TUBJUU6bQjOcgdQj2doSdKMCihRT+NQcj9sJlFe6PSFYQ28GQ+N0xl9IOBY4GGczDtvU/mPj+QhoF6BJIWMFVz2R3CESBvDGfJ+3GrZYTDu3uWL7+GuZ+KjPK2Wl3OpU0ePw8Uq9xZFTtRUiIyo6b5fGHgJ/UE/Ln+FeVOOj2/c/6/k4QCwVlWCbARMqE62es6t2sHVXAQAFjUqEbVu4FFhBOgDicTPPWcf6L/8VhYJ8yNmNzGLevOO6cte3ie9bAiquu+ZtZFoi+quDFTmIjt2JXSUP2iN+Ou8afFepY3AicxCddjpyZJbPvxHOiTEzYMG0GbIFM+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6312.namprd11.prod.outlook.com (2603:10b6:8:a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 7 Oct
 2026 20:43:53 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 20:43:53 +0000
Date: Wed, 7 Oct 2026 13:43:51 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: <Dave.Martin@arm.com>, <david.e.box@intel.com>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <hch@infradead.org>, <james.morse@arm.com>,
	<linux-kernel@vger.kernel.org>, <maciej.wieczor-retman@intel.com>,
	<patches@lists.linux.dev>, <peternewman@google.com>,
	<reinette.chatre@intel.com>, <x86@kernel.org>, <yu.c.chen@intel.com>
Subject: Re: [PATCH v14.1 19/25] arm,x86,fs/resctrl: Enumerate AET on every
 resctrl mount
Message-ID: <asavB1zyPs8CMLvw@agluck-desk3>
References: <20260928221509.68002-20-tony.luck@intel.com>
 <20260929175231.16576-1-tony.luck@intel.com>
 <4aa18085-49b6-48e5-83dc-33d87a60a99d@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4aa18085-49b6-48e5-83dc-33d87a60a99d@amd.com>
X-ClientProxiedBy: SJ0PR03CA0163.namprd03.prod.outlook.com
 (2603:10b6:a03:338::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6312:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b2a2671-bca7-4564-e776-08df24b3b2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|18002099003|22082099003|3023799007|11063799006|10067099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: ralxS1gq1hz3HoATjOdWUiU+wUEJlGt/9eZPVtueSDJj/B5byyCSRuvohGxENuWo8fW4T/9EGrhe4tRv1ijLBjsAsOPxQTDfrRhK90vduJVovWckr/eazy7Id7I68jVhJFSCiVoYdca8gCDLbTHc60jNpBSE3Kat44pOo8GNf9EqL2evj13ovn1edc9XgNaWx7s78Jna4bnG9moKKjI+5jyXZlte92cGZmDMs2XYcNDrk7FzRJvIGAOisVsxzkjRWIpINyGC0jAQMwfr+qK1UYLtXHtRqScf1zdzHnco5viOQsJP1Ev4K4X0x96CFeyLWHmzvRAm4sWanRavrCY8dpsXvYCaXd53oyWNRFF5DLuxt87pw6f+P+ZkCjWMzSGekT1+CtUkVHhzMP948yjbZe0S58EcxmpPOHjLTH5LhPchkn1yFwg5TbXQUX6vBi72n+lg2pL4pcsv2UASfPAVLmO5WdPp83FWDQE6o8cP8+/bV5mHtyfV8Y5mnJlCkJsUD386HT9YfsZrxVB1m/og3PIub9pMJN9y+K/IlVFEXe1K7q6CpP/j4HrdKef/EsFZ1rVQokm2TLc+8fUgBK/NyvuwRG4bOQ2egyD6LLFKmwAY+OyVwOG7U+mWbE0xSe3Uodm5Bg9/fwWssscND11u/GprWHLL1FAeAmQiGlyECro=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(18002099003)(22082099003)(3023799007)(11063799006)(10067099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cpTxkA7+RQkWtew9HINs6/Amjqx2f1RbxRX8xXWXqZcZmUiRZpOyKTRPvMfP?=
 =?us-ascii?Q?SuIuRDptRsbAicDFRDiMwvoht5N8bMNaDjiNRYJ6MLsHoOF3NZFEhNjDJoI5?=
 =?us-ascii?Q?YKaTmbpXMKzjPbRH4w0L4O+e1GJ0VG/3kykRRHqAKpNEgoNNfjEj2FUy/ye0?=
 =?us-ascii?Q?YB4VkBX1KekmK0KwfdncB16QU5bZdUZuYwI8mP7qVvpttsqhOT3ZJ0tp034v?=
 =?us-ascii?Q?23I/b/R5FP8CTGCaYiLDBl/YpA1OdyuiucYcZeIGg6zIo0/r5JvFRfM+o5EL?=
 =?us-ascii?Q?ACwdG1c+h3dcShwCywccyemN3v32herccGCbrD01hN0TTpg/IIXR4geT4Xat?=
 =?us-ascii?Q?gczNsHz+iR7y02qRTOMWPlVQvqnMWS/CxQPLUUGRfAKpwtAv+R4+8zkwwLVE?=
 =?us-ascii?Q?rdYPDutuZBgBGlh+5VdwLFJAG4P/pCgmEXnzjX+35jI7EatNIj5m5qn6neCb?=
 =?us-ascii?Q?d7Hgw3qAws0AoO8Kih19XBG0VkNebfQMtTTu1IECO00gNdh0/ZVnZtbVk7Ju?=
 =?us-ascii?Q?MDl1ORySTGCzxlzevuz6ScSbe7YVAXcHqiG4MIJIppcOFBQC+h9uPPCaC2dc?=
 =?us-ascii?Q?aAxJmVnayvRM6R/AwQO0HgpjJj08OeIZr7h1cnSPOW0a7xmh5H3eQsloNq73?=
 =?us-ascii?Q?WbsmqKOYzJS94ssjS40xQ2M8xAGTlY/SIWbgZhfqDj/SUmkGi54qLM/my5qd?=
 =?us-ascii?Q?Ld6SiWUiQscMCpAH/EnO1t3JxdT8yFcg1X1jFiZzpf4D9O/vzHIvT7r5PjCZ?=
 =?us-ascii?Q?qQgkansGu7ldwJKAU1IfY+hg+vlgTNV9d82Dg/Wz1/whcCTwxIr+oZRsgMzA?=
 =?us-ascii?Q?I6H2WLhNJ0figq+FGCLgQ/oEJS9jCk/aLngUVC2C642PHN8xcKRqZEtOx64Y?=
 =?us-ascii?Q?ZuzjFMSBrzo4027zHxfM45zXvtPUo/4odiNngJeKcDA40Eh4ict1S2yMXR7V?=
 =?us-ascii?Q?RlcBz8y6BUm9+daUaC75necViO7aumjrNJUrf0KkZX6O9S5OtDNkFqw71lSS?=
 =?us-ascii?Q?4Grrxu72y524OM6M03402RfPyBRaZ1nz0MrNK6ZwPr7BQMUpTPfaKVUKIjaE?=
 =?us-ascii?Q?PsFz99aY76upWYzKzfCl2tdAJB0WMo0dxdo6G4qa+IapUErSy/xECVfhZreH?=
 =?us-ascii?Q?tgCYDaxXLJk3Gil6l90Su0vvsf8bdEki3LgReEETnLyfHMn4jv51eDLr+Cg2?=
 =?us-ascii?Q?eOvdhd/XUzNINf1WLlHc/EsQfhVhD0aFrRgDBruAXPOmdi1RKXgL5GGGf1Ja?=
 =?us-ascii?Q?wZsEzOiRVlH/R4pNkZE4drIe9s6CclCIKOUOUOxdQ9Lfv/JEcNOy03LmO6d5?=
 =?us-ascii?Q?CiExG5nmzmCc/2TMwmcNAaaC6LLBxf/BT1GYcSkZLayU4ckD6RCS6ktoZXm0?=
 =?us-ascii?Q?0vO0w7OQQI/N2F72TJjoB4uMTw+U6VeBvvbIVcB+9YmBaGjSZRVyZFKnDQ/b?=
 =?us-ascii?Q?JGA4C5kvcVVeHxUxV2LIW1mXfDcHhgiH51/DMjlouV3WhmupKYMYUmwNBF1L?=
 =?us-ascii?Q?iDn35QVyFvu0CklPA4hazWLw0NJfEX9O1x8ajEnz/K6dYsDp6od3LYzSCohb?=
 =?us-ascii?Q?IXXTMHR136XdWa23X6cZvwUdQCLIS+idahmHVvPhN445kLDCdiuR8DjTd51w?=
 =?us-ascii?Q?Jk3SVCkSr5GKAgQTePN7tg6t1FsE6OUcWddToQv392eaRMS8amMsj4GkUKsX?=
 =?us-ascii?Q?9bVORfNfFzh0ZGnaUnreBcaL2VkHH99DK5ebkIcEo3oWJIaEPtBjj/+JpnpJ?=
 =?us-ascii?Q?jbA7vFVJUQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: jNj+d2cizraLGVUtfCtGIdksCKBp2PmsSQi1CI/YH7/6lLs0skrrvcopILVuCVyF/sedhlsmJ2l+PFm5wrOarjb+mB/wXZQlvIprhnFXUZE+1xCfgDit/ro2cdJZ/wZC2uwZ8VpffHOQMLTHE3dikoOZa0KlevNeOptwI8PJbF4lwIuieDdaYpbXzj6tIYWbymraBjOeyPxIK95AZqE4PHVT30ktdY66gpRGwGIvH3Gsdu+LLgKfP+J+snbnogpuYkJzIZSX+Azr7C8zXgjqpp/4gVKPlMTJYtrpLAZz8VEyjCA+cDzvnIpnlXTz8F/KU86JCyErfZiggbQ3Q1t/1A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2a2671-bca7-4564-e776-08df24b3b2e3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 20:43:53.0606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPe+OYyZRHDeCOVzWdxDNYaNplKUhoLoypsZzDXrnA5MgSN7po04uVMw9JpkRwsoR/4GDOV3e8Ji+61w9w841A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6312
X-OriginatorOrg: intel.com

Hi Babu,

Thanks for looking at this.

On Wed, Oct 07, 2026 at 02:55:30PM -0500, Babu Moger wrote:
> Hi Tony,

> 
> I dont completely understand this.
> 
> After this function call, e->force_off can be permanently modified, whereas
> previously it was only altered by the boot options. Is this behavior
> expected?

You are correct. e->force_off will be set for an event group that may reduce
the user available number of RMIDs since resctrl will take the minimum number
of RMIDs across all monitor resources.

This parameter of an event group won't change from one mount to the next. If
some small number is enumerated on first mount, the same number is going to
be there on subsequent mounts.

So saving and restoring e->force_off wouldn't make any difference. Every
subsequent mount would just find the same issue.

-Tony
