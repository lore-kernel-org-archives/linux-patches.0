Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792511533;
	b=fyE5+mssBOsmH3aHAI+/Zih4ubM4prYfjg96EPS2gXuKpAcHmIqlR8Rknpc7jMYhkJYY
	 KOIz9qBlITSTROR4piILkor4k+fNK6CBiLxkux/b6v+Miir+xNo57hV1K8M1P9KJUEuBP
	 9wujhN1l0XaTslSAELmvxm2WEHMZ1JxRSGxtGqdsBUp9SmgnOBnxMTkWZBeZYs/17ofHS
	 0xy4oiAye2v+Dbl37Pg8TdoX5Qgo4xQZe5BSzW019ebNTA4yuEDaESp0xLvhIk1GJnFy8
	 B23LH/BOCnF3+v01E8FEVc1Xl0c6jwDwKEHxU/Eookx0foy5KMnMaoJI+/Y4bqHojRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511533;
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
	bh=Y5oOjIuasN+NMutuM85BWYdaa+7ynF0AobGXEVAOTWI=;
	b=ZFWUegHW2IzTJniD8xSUx5lT6QRdWQz/XhcRA9Vz/tJUITQS73GfUboBCFttnw7GJjEK
	 S/fCgqdGvxAR/PUdweIwdI/4zm50aUpYA00cNZHsFAgz3e+8dKy5MtSFxj0VP6lvO5OUi
	 ZJmfRpCUVtvxIrLI+UKmM+PsuyS5q2IP4RpuZWhnwfVvf+6VaHmHUDBUjD2OjoiEIZHcM
	 d+3jKmdqdYa+RmvzdxUdS+vRBdzd0GzsgLwAcJOjXNVSWEZKYmW4zLmtcxc2Qm11vgx0J
	 i2jRg7S+S5KNPOsgQ280to1Bo61RQSaLLiXZnb3zWDQstOfiE2FYRmW60jPALFBGSeQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fqG1BslX;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A52606A33F
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 15:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24A52606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fqG1BslX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792511531; x=1824047531;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+IqMsQcRUVuGllNiSFdFa8OofarNJzKZeqRyB8XcNZ8=;
  b=fqG1BslXsuBJjU3D/kiYsjqlFAnOIUQa5cRoVVT0iCK+kcO4+sbmWSth
   ugQUDt6SP/IaaqqxgPIj/4Bzwc/IByO8mELHPbNyNzetLk0KCs/ciuEb+
   n0HUtYsggtPd+604dxWwHCilhCFUm42sv+npY2f3y2n7Y0Ccm0U0Xibdm
   Bzw8j69zWc5XyxMmE6OFyxLZdBL0BLtB43zx/eUOr82zpKEduu3BBXLYX
   5OkF/ivG46WichoRFFjNMs+Bl3XjF5AV/t5UHWTe2x2XK3EBJtK+ipiO0
   D8iKiHVlxknhYWPHOD3QdBLZOue6qpRf/wYuw2TslIkSaE9Ur7wnAQBmk
   A==;
X-CSE-ConnectionGUID: HxTzPOY7TKKXvuzOsiclog==
X-CSE-MsgGUID: GrzJFUrYT8+Mytytme69Fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1103112"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1103112"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 08:52:11 -0700
X-CSE-ConnectionGUID: ZbJ/o1E1QkaYfsyyeMrUDg==
X-CSE-MsgGUID: ZBUVB3E8ThCojkrTdPiORA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2792887"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 08:52:11 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 08:52:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 08:52:10 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 08:52:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tKl7o1Q11Lrd/YaRyG4EjNemw1Y9Ko2m+H9jJ8UAtGlp1qriFZdlhaoiGJs6hm5aPJA5kLsuop4z292aYoIAyPz5YnChX+UKe7sv4eoXzgDbNHasfyAA/7e4AgN0lgiWoShun4gAkQlIHELeAoXfaYua7ZpXDwNieDlVa5Ol+Zq8yNQM0nxYt9TmE9cejOBOgD4irdoRI3JkULguuicpLBwmUDUofX4mV1YV71RCa6V4y53S40lyt1s0y9IZCVPvJDCBlUifofLUTEnpf1Dx+uqnH/OuHSMcPwg8PH8tw17T/53GrjUYkaZjglUBgRhoSmr5SpCvi6GLmjWqKwDVMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5oOjIuasN+NMutuM85BWYdaa+7ynF0AobGXEVAOTWI=;
 b=guldPWiYrziv0bajlPpyyZioQcCmtq/yFH5+YeuFtnu/36ayepqZBOHxNJvZKr/q4RpvTYFAJ/eAqYdO5iVTG+DLShlTW6MAMw1KxA72BkLPfiwMn95y3cISQm7k9cFbSt/sbXeVpu0++e3WOf0DXNvbgg8xv6+TAwLj+nCPAsMIfQfgCA0W3zewnXRE2imgRfz95vwXJdJuzH/p4D3AryN17pYw8ejEXqakTwF4VxscT70QokDh8yp8RneBrIn3LFK+leA3r5JfJQTgWDe8Cf2hltCqfWgrtW19n2+lqeTF/ryOLcVUKDfeWLfixOvb+xmkZdRZ4xcrICMivNi5Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 15:52:07 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 15:52:07 +0000
Date: Tue, 20 Oct 2026 08:52:05 -0700
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
Subject: Re: [PATCH v14 09/24] fs/resctrl: Remove redundant calls to
 resctrl_mon_capable()
Message-ID: <ateOJRwy3zNDNpXy@agluck-desk3>
References: <20261019205031.16977-1-tony.luck@intel.com>
 <20261019205031.16977-10-tony.luck@intel.com>
 <atdu4Ws7iH_XNSsc@chenyu-dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <atdu4Ws7iH_XNSsc@chenyu-dev>
X-ClientProxiedBy: SJ0PR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::26) To SJ1PR11MB6083.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5815:EE_
X-MS-Office365-Filtering-Correlation-Id: b628b1cd-7bb8-46e3-1d56-08df2ec21808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|56012099006|4143699003|5023799004|11063799006|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info: HgEAAhtY3rbg1QvAEkF158KAmMuKBhnVQcX1TMxttOiQwy5dZP97aFaCmOkx5pf1TDtVNFs+z53FxP3WnY3R7q4TbkrNaYYF7mkmjsrTxEiTRHqfjrQPzLyPdepogExM56nBBvpQwLpJouvrrXtCf26nVbL2oV1i5HVvxc9eM+c2jcdDMrZCyYonhZ/7mcTklAYHGBOwXrkAE5upDdMITfvtd0e2C4RZ3mjHOloCSbqcWcNoM/tqZmjx/kQ6xfxgMaL5QR93wb5w+qG2CevRQ7tcyF5JQbBbzy69SUKbsfPxIXqbSPV6hhbMPWZ4DPaDKb3EiQk2eQ4ClRiEtArfMrnkwn4yVVUK8LL5elhIEcAW6apAyQWbLFcZrzt5hY3R7nzcBQU5aD5Mq0cXhtdEMRNnAzYpMp07af4yJf4T5mDQSPRgjU2DtN50eCHROfhCQ4MAQKHqJUaRgf0ZoGGahgxVYdXIb3vr1uS9v5LLlUpubCYRpMX9UnNzb8RTcc5rnJ67NNkGq+SkE78sw0rlOATD/vjPUlx+PWVAVAi333pwqlo7UFs1JHeJQm+fLd3SjaeaBn86M4zHy4nSQ1F9macJl2wiS+ow7bQx8924JAg6oadlpxmyiXHGOMTt96fKbwVJwkFCjHfSCDjEwrE086E1WzsZowYo8QiEzyIa+xU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(56012099006)(4143699003)(5023799004)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gtDJTeVU2wzxTr4vAqgqIX+ncy2s3gNXQlZn7Ma1g2kEZYLWHZfij6VxPTQ2?=
 =?us-ascii?Q?QU6Hg7aJcJNzi7I59qEAnheyo/xCDln8qLsjWrrdiDXcD2euHG4m7tXAHmsJ?=
 =?us-ascii?Q?I6SZhxZq98gc33CBXDkneoCwTONClpDE1y/yrzalAFcXS0iKzh0VNPAQ6lCq?=
 =?us-ascii?Q?VNmHmFaV7UbhvRSKLoIoztursIdFlQY651DSPC3gHN1nL/h5E/J/LFhZ7R6y?=
 =?us-ascii?Q?hklkAdksOO/CmDrD2Qup5A+vVSalKVdLgavrWd33kj3RUz1HCHS6ij9O8uaA?=
 =?us-ascii?Q?F7Hv9+ZeOADJUKk1WKGocJw3gw4dFICNqmM66+p7oTWrwo2o32zRy8SzkzKW?=
 =?us-ascii?Q?zE3EgxRRu2lFAj/iarWxBFjr7zji+MmYdua4zpiR/lQBVd5pq5sT4CTH0wRA?=
 =?us-ascii?Q?zniKQ6vzZ4L3U2SJKJXGBfAwO9lskwg1b7yjf9nxKb6gllG196FrR6dPgIV7?=
 =?us-ascii?Q?KzmU0ccqHf2oov6SyHTugXupC32qg+pvsqmIxiDck8UERP65Y/QFGVzXNovR?=
 =?us-ascii?Q?LxPggKizztgdk2xER1fvFeRGVJGtexfxKpG8jzQVsTgbyKcZtFH7JhVHLH7q?=
 =?us-ascii?Q?IcjgHj1X/q2K5WsJbhFxu7vGjX2cvJi/38G4MwNJ6N8yyjhOKmhgkSHpGGDX?=
 =?us-ascii?Q?vyCdib5jmT9MisEM6Gj8xup82mSb0uP8tjwgItbyQ/Mm5DhD1VZcjx8rkeHZ?=
 =?us-ascii?Q?Ll/hmDcZyw4rIEjaqmXS/BQwq34yVqfDH1hcDiW9lQxWvlgEBobLIY4UGn8D?=
 =?us-ascii?Q?Emt0rc+Wi+LwUzrAiiqc1Q+0o2ZQRpwwiY1eZn7ZBy6Vu0NZOaUEc8jHHExh?=
 =?us-ascii?Q?xZiOWsRmkZAra5NXaZn0B7xwvuAihUKkFqAW8NGCJDa8ced6aZ0q/ZfUOeX8?=
 =?us-ascii?Q?0DLMSogIZFEh9/DIBooPft15X0KixAECNxhD7hPr/8OO7ypg0i6jysygIq4X?=
 =?us-ascii?Q?xAsQk3ATa67ARyUJP7GHOuF+lI+7K5GGKmD+IJD9acHI83grNyFbMe9lDYDN?=
 =?us-ascii?Q?buSFMPSkr2u419g5+5ctvZICitAHlGVARghNz7IPkop/sqfkouBmCRFP9mYF?=
 =?us-ascii?Q?dAQOCxyMzvvxKqWURlhkVxibhMk3iVHRusxmFq8TK8DLgudr63C8RVLDZKmk?=
 =?us-ascii?Q?Qs5CNuts8mm7tW77awplzPdLA7iCIRepexv4VOFTYSQ8swSpaSuS+3CP+Pix?=
 =?us-ascii?Q?WTIadzzwH0f/kY1ueBNzmq9jTcE+muI2W1u2KG1iUyx9c8Oyra5dF6E8IFeE?=
 =?us-ascii?Q?kH8IwMUM1xQaqbpRK2xLabRkAMdqkKh+ZX4fdAP9nHfYcXIFOgCi6ttv/4vx?=
 =?us-ascii?Q?hM49OK4fRf95bp3+kLaYRzVsHCH7NqAiKmv2WGZEqYU6BVZygP3ft0ZgU4aV?=
 =?us-ascii?Q?cuuRgW1n8RKAg0DxmBk5K72lg5TkkCrv3Qr151pwvu8kah6hHGwqBN7XH1Kq?=
 =?us-ascii?Q?MUZiCz09BbwHeKzp0vsiFjtU2ve51UdnuhTBwtRmRxG8/Uh0x6O0oOPwi6Fp?=
 =?us-ascii?Q?a3HAp1h2VHkH1dApyr5PP8uhbaa8KxnVgoDk0qcq6jIrKSU1ud4whqQG2nwx?=
 =?us-ascii?Q?KnmteVogc4rpyaDqGrNZ8vu1musBYBj7rzKSp5ajrK98A2GaLUnVjj68+E2e?=
 =?us-ascii?Q?6HLGl0WRMXWzinjyPz7XryA4SJ03Abkd9dJe2Wryq+BxOnJsSIhoKIMLAeN8?=
 =?us-ascii?Q?6OSxUkUuZWVqBiLJGOkCk/hYWf+d/PguU3SAlyn3KkWXVnWKa25uPwQLfZhZ?=
 =?us-ascii?Q?8WYNhOPeWw=3D=3D?=
X-Exchange-RoutingPolicyChecked: txlceHL4qDmzNDJjae0uifq7Ss68ZOwe99XoFAhoq0apjGR8y3HGiYNc7/pwhvneDVEIr5lG1htlhiFJGR0eRwfJwfaf7X3zeVADrdvzphavoz+YaCp5IZe/Svr5B6WoZUN2xM7bhctFvf+S5ByuQ0cvh7oTzyz66SuLyQ7uODrtw3pP+1fGUZkSxN6mhTQWGdIlh5NLNz//I8NJ6gxvpBnE/nErn/jFeJLQ+IP+E3Qw54UMhK5KP1w/NCQTCXRgRqv78soHETR2iHc4COheIFJWcNlf9RMy7M47cQdNQqtDoQNioHDLEvX/pZlBukiBOwTYtIYTwXW1ym0RTriDJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b628b1cd-7bb8-46e3-1d56-08df2ec21808
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 15:52:07.4194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gY5ajb4jFN10MKmwSahADD3GyJt1xOs5HWCD237Ex8VCOEy8uvqBgK6MUayX3jYOBwdtLoIOGxRso96Ktlq8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5815
X-OriginatorOrg: intel.com

Hi Chenyu,

On Tue, Oct 20, 2026 at 09:38:41PM +0800, Chen Yu wrote:
> Hi Tony,
> 
> On Mon, Oct 19, 2026 at 01:50:16PM -0700, Tony Luck wrote:
> > resctrl_mon_capable() reports whether the system supports monitoring by
> > scanning all resources. On x86 it used to read a single architecture-provided
> > flag. Calls on paths that run repeatedly now pay for the scan.
> > 
> > Two such callers already know that monitoring is supported:
> > 
> > 1) mbm_handle_overflow()
> > The MBM overflow handler runs once per second on each L3 monitoring
> > domain. It is only set up when MBM events are enabled, which requires
> > L3 monitoring support.
> >
> 
> There is also a resctrl_mon_capable() check in mbm_setup_overflow_handler(),
> do we need to remove it too?  But it is only called once in mbm_setup_overflow_handler(),
> leave it as it is should be OK.

Yes. I was only worried about calls in hot code paths. This call can
happen more than once if CPU hotplug removes and adds a domain. But
that's still not a hot code path.

> 
> > 2) is_rmid_match()
> > Called for every task in the system when walking the task list to read
> > a tasks file, remove a group, or unmount. It only matches MON groups,
> > which can only be created on a system that supports monitoring.
> > 
> > Remove the call to resctrl_mon_capable() from both functions.
> >
> > No functional change intended.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> >
> 
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>

Thanks for the review.

> 
> thanks,
> Chenyu

-Tony
