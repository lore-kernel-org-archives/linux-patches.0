Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792513680;
	b=ABCtzGtSP+CHfbYitdrWJY7OQ432nKrGHnJn+TfavAGPDuBX0Xgwk9PRIditaep1huG2
	 aBo+wTaNTsWJxbPSD95t1lRdhcFYs4y3jbGT7dim6pqNS86HCf2dP/rHWYyaaGv1MI8gZ
	 Zx5lVHQWA+wh7owACeJRAhgA5LpaPcaVD2Jf7DuLBFeDlvlzYbCuj/XCPUKbBtgqly73s
	 zoU+FVHqmuvNAy/+in4vYZoecB32mhng90/QvqTqF2TUAM1TtwXmGNzpnaexxqtQDM0Wd
	 aE0AG1X7BO2LNVqaFxfRPIT6d9bCPkunEA38yiYHxYTBSMXLojKr7Y91myBJXnGJVEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792513680;
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
	bh=QeS1Qn1P7c+Lpc78VDjXLG/qiXX1K2KQJ38UB/RAQKw=;
	b=m+hd8TIW3h4a+n5NoWaxaPc+tg0rVStUH6c+IqyHOdnaHRzWE7pOl1QdfPhttpeOeoV3
	 15v+9ag/2H5QHnyokKwQ9fUHJU26hzSsb9GhOKgtD19St0iprVWdofVenu/+Tj+iMSEpa
	 GfKI96udOzcyn1914KO20k0p6+ZwuE+CNZB8OA6eK8ZFNocQAx51eWCFbeYUWMpS7ZMCd
	 CPbFpmq112x+EgW4JOewQ89t2iP5Zg1qDFgfgG0+l9BFEb69mxhFsGG6ekmD+AKFAVcwA
	 2qF0q71RR6lqB/1MoAOIXw3Kev1apDWA9Pmbf9x2g4uo/8k/EOC0dZrEqC4qq/mlMug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hmfgCrM6;
	arc=fail smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F24606A31C
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 16:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81F24606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hmfgCrM6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792513679; x=1824049679;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qICt6AOPrCVPdBlIngaVKHA6Ampw1bEpn/7se0QTUBY=;
  b=hmfgCrM6poqfRBFhaPl3oXgv1UKKdreQCm7BDwT9zmC8QXdvwaORiqxK
   b3ZGxNDvpt4+sKPbAzG0Q1yvdrZn136gn3od/wjcpV3fEwUZPeHLvlwY4
   V3dWdHFW9Z9D6wJA31zgmHrBZCi00XeI4Cd10n8r6ChUpPw5k7T3JiUMM
   gI8eqabt+y0lTKQzMepq2dJJZSIghV2e88grieaLgBXSfIJCOl7lxS5Fr
   GdI1ZjdggQR/1fGrI/+3meIKeLqBj2RNL1nRzL71K13apIKjdX0xdN6vz
   v5CN1ZGy3Rbllz07ms3yyzTtb2Bf9MuuwIrx/RCSCPZPIz1l7Eor6RWhf
   Q==;
X-CSE-ConnectionGUID: 7fv1igIvQEWdJ5+szTYsDA==
X-CSE-MsgGUID: +rkTjgcWTl+2WUhMdHuxqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1249784"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1249784"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 09:27:59 -0700
X-CSE-ConnectionGUID: 9TZ+PzzHSaq3+SHDUH7aoA==
X-CSE-MsgGUID: iR4B9n01RM+kCT0w86rEaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3258900"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 09:27:59 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 09:27:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 09:27:58 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.48) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 09:27:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NaBFZvxS0zQXQg3KHoBS0WiVCv2tmIckR4fbQHJanQznQhZ/va1V39UboVXdFG6qxKuRvr428k+ZWuaXUn2bep57vqQIdjzoMv0yO0YQ5wRw6zJq/ZWXww4f9iqnOJZAazEWpwPJp5yyZzeSMKDSkT/eM4tV38DEhWCEqRTtgOdajWzpoPT8s4wADzlMk+GDW7Y3FuSw+4lA93SGFu/mxJvqgFugTfj/vzwSB4VH+/Ww3xVzUEvoZuV3GHKJB8KYFmkNHcxpiJT3FJE7/jUHB7FTgv1VxLRhdEVbdXG8NZ6+A9Y5+sQu+sqN5JANg9prbvRTWibSbwaQZHRWr4L6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeS1Qn1P7c+Lpc78VDjXLG/qiXX1K2KQJ38UB/RAQKw=;
 b=m8cTzGJNDJy1Uf1wy4abGbbgZYOmsIxdtmstNJWzZm33Ij3ug7oJufRiAPCP5p+NXxD83Nk681FNIfE21u2J4QyLpHkWyscM7tKd+HD9AVpS+0vsImU5zTrnR4H8xcOE1ArN7n6sjKR77zcVmiqu5Kv7ae7i+gSPZaHbtiSDjPDOERp0my1KUKfDyL+NJVaEYI1pnwvsflafqmbw1GYzM8mM7cv8BwX4eDCMC0Y8XFfN8FtYdOUsVFmsFsyel1E9S7hZl1+DbBt9QbceYDq+VSQelQUXH7zeI55QmGH6MZd9uuy0pgusQy55onJzdPfRkp+vpTwaUbDK+L2ceaNSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH8PR11MB9507.namprd11.prod.outlook.com (2603:10b6:610:2bd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 16:27:50 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 16:27:50 +0000
Date: Tue, 20 Oct 2026 09:27:48 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 00/24] Allow AET to use PMT as loadable module
Message-ID: <ateWhGpyczGElZEm@agluck-desk3>
References: <20261019205031.16977-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261019205031.16977-1-tony.luck@intel.com>
X-ClientProxiedBy: BY3PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:254::30) To SJ1PR11MB6083.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH8PR11MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c1e0026-dc81-4382-1844-08df2ec71526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|10067099003|261009223027099003|11063799006|921020|56012099006;
X-Microsoft-Antispam-Message-Info: G0vw8We7zN2crCZZU4xlgAHi/wA7L+1tzKDC8AuOHUXSrvbTIksfYWa7QUu9o52EkkDZDNPP72VftENyRksqafwk1e0X4PRvhEq2Whz/dyW5VTHfHs9d7IQqVY5BFVhmcIZak7PkdmYancqQoIBnzNPdFcFujJeiXIb8B1NOB2JkgcXOjeCx5OPsLioEsasklmBamAMXOonqal/fFleV3O24TUkSE4bY/LqplhbnI9AD+aLJJZjZOoh4gtmKa3sh9HDTzTY7JjBJCC6YdjW2SLA7N8U/banMZ9MxqRMaMHnfez6bjfXWxg0R4Zm2V7SLhwFlx6rM87J6pT3sX/cAsyWSzA/yL2NVEpBWUL4D+avMm/vTf1WACKEg5ngl2tnYRA3n5Y0u8GFRNEgZ84ke5/p+4r61Z2Q4JDJv5E/5idz2IJqk4C5sEDPee2GQtPQG25gDJeNKTEl9nwzfqLuG0auWzpfXrKMUhsGZ3Mz/WwZTqNm1OelvoGMvqWNtqcwPkggwf61fBJ6z6+LMLBUzsNDmtqheJawH67pWXtZe5TBFdNm/PVqiRiHMF0d/4lahNHJI+V72Pg9e3C5J0JEIcuSz8rCY5fl0k4LCrqHF7mfc3HsGFwt9rYr50+nIoNbxbMc71bzBjZ1AcyjJnHiW2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(10067099003)(261009223027099003)(11063799006)(921020)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ul2FlqMVcLEUbb1gqSOfaP1pHiaeuuHdpiS/e8u4Dp5iVGD/MNX9a2m9asB0?=
 =?us-ascii?Q?qEdcUoh1q/jTZEwfZ2/gj3aJwDahz9ki4GfNH36Sw74iZtBJEqzeHZyBELjd?=
 =?us-ascii?Q?Zq87qO9/Ys/tbDrjcO7TFd0G/2PHeHbd2bhlDeX0noKMt2eROoBBIQdebQWb?=
 =?us-ascii?Q?LUviuzcuHo/gxXudeuBoFRqmufRB7XaIWWiKAm6Y5m6Dzo3fqP/DxgKpIkrb?=
 =?us-ascii?Q?Vo+zvvVPSOH2+XyADYj1qgYidbMcies95u+FpsGzcoBWKgpROQYBjzJcW3BN?=
 =?us-ascii?Q?Q2iwweVobkXvRMhWlr3ErSuFW3rR8ovZUXhOqfOJR7q6c0gED11negYa3nHV?=
 =?us-ascii?Q?LJ4UlEZloEzxQkPVR3aEImhkbL8ezKFmP3r973hK9YB17eJhRh+Me+I0+MQF?=
 =?us-ascii?Q?NLMOzss8clFYdgev3jSzH4CXF33rzHciIVRX2xdIFzcLWNTpaJdkLYG8neHb?=
 =?us-ascii?Q?Wgxw/uXQtYj4zavfZHPA+uCLvB+W+v/J7ArscihzMC9klBIdTANzGM80yFOt?=
 =?us-ascii?Q?d6eO76BOLltFyhcCPdtSACxyOdNUE1rx6fA9RQmB90CbzNEApzaxO/pIp0hu?=
 =?us-ascii?Q?9xf52VNdDRlEHr697Ob9PtUBmi7s/B3jLg63njm5gVx7sH10xO0Pk0qm6jvK?=
 =?us-ascii?Q?/gnO4V0Gw4BoF7duOJ+AknjzkO2+LIW7PDqoH7GdWdAskMQc/2DeaYwOz3uE?=
 =?us-ascii?Q?ptg+iFCV6viOGdX6xKrFbZZe/sv51GcLfjmEYWRaZq8VCbhBteQkQlBys2tI?=
 =?us-ascii?Q?xxvWpLnTjJ6uOPvefWffUEKfAEWyHzxDRtVhxH8WapKAntMDHX6gT6KW8up8?=
 =?us-ascii?Q?ZVYAZc4gc6er5u1FUbXP4phTzHfzokY0vCEeiki7pCTLEPuYGzdLxuXpH2nP?=
 =?us-ascii?Q?70ctPP0zfWV2Qk3AviWcnk2VH4U/0+pcTbVUN0jmxYmAHXbSSk1Lb8JhlH6s?=
 =?us-ascii?Q?lg+UIWgTCs8vHEjudqOWfuv1Gas3mEmWikiQsH1KT8dSMLxSm7oTy4nIGl/O?=
 =?us-ascii?Q?1q40J6Th1QLMpZPqKv+7vX9j7cagwt2ZAkDGT1nGzUO3PuuLWfPeZW2lwhur?=
 =?us-ascii?Q?6uEgOzoCZaKMaaR5GBLSm3BOV7pQP7LKRFknaPjVLzEH1SWc+gwL6f7qAEdM?=
 =?us-ascii?Q?gZEH4nERKrYLkdMDlSlYCuX5/zIH/1wuxgsUD4tdhulaHEWSvyn8XlPxVp7V?=
 =?us-ascii?Q?3KC8xXi5NpM7hAxF2gq9t94g5V4RKOJuPngEKCcBMTGZ0s5XwRFNdvEYTA7B?=
 =?us-ascii?Q?xSHN8w+S9Im/HiSqV6oMiwidQXZuU/BC2RCZwOVqHgtKRHl0zdjGs0Ffdlqp?=
 =?us-ascii?Q?RsPHZmc0Jl7v84mhDX4KpIMUaOuFQsBa/T8dcfIqbBkZ2HW8qBmMmjIBw8zo?=
 =?us-ascii?Q?qvTZx3F6b3ySSqh2rExa1Mtwr3fGN6tMRzK8gjKtJ23DGWh7wLdzhoc2gNM+?=
 =?us-ascii?Q?cjEGJAOVQT2xjb5Dke4oOmDT41T/tCTAdgT95sGbHS4JuxK12Eu55AKwEtk0?=
 =?us-ascii?Q?Gghi5KAcORiuJ+QvZrtLVXCh2oBgSqxP9QIb9RXE3l486aEb+fO9VTl4tTD3?=
 =?us-ascii?Q?yk33JQynui8/NVVnR+m6kvS9LdodiOH3F6JtCpVSPFwIUDRvRUFjSKqEZa/z?=
 =?us-ascii?Q?hbVe1k2gVMC934jAFM+kxXy9TqL3//JxwRwjnRD+wVPBV4qUKeSfDWgdmfJv?=
 =?us-ascii?Q?yunjtnLJhElZmYI2cJLPZH5Zn+F1u8jIGt5e66XDdkNHYHjIN/JHmlNctuGH?=
 =?us-ascii?Q?ztJ3LG919g=3D=3D?=
X-Exchange-RoutingPolicyChecked: jKqwip8k0wHikHIHujYjoHfMAmiFDynhUp/uMMK0qPWn6JqWZeQ/rFKNPeM4xVe20ICmkAFS4l87TB97D/SyQnGl+yiL7j1mxHbsSQn2opjb0HBTzr9vsL9vhLZ8Zmhqu9Y9gqvlyvK1cSgijqwuwV1tt0n3zNfoAwNhE5gFHzrQ44geGuhnhMBx9zgbIbEp+F57w952xu5y8pR9v2vcMvq3cz4BsUPZNmO5+5Snt+2i9w8z6j9FVMCQP11XrbUQZi1OIraNwCYM9EL6/W2ySr1hGUbDTf7+rf61qMMf6fTN8+WX/pcb+b1Mr4e7yEU2gxo0UB3TI+CN9IE6fYPEZg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1e0026-dc81-4382-1844-08df2ec71526
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 16:27:50.1129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6yU5AVSLKJ/Xefmzzy0cjJggQUSoRRmc7c6fkUMj9Zw2PKz+WHIrs0I0BrbmUZPeBoa3d9mid2YV7pyJVkFasg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9507
X-OriginatorOrg: intel.com

On Mon, Oct 19, 2026 at 01:50:07PM -0700, Tony Luck wrote:
> Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
> to enable enumeration of Application Energy Telemetry (AET) events, but
> unacceptable to many users. It results in increased configuration complexity,
> increased kernel memory footprint and inability to patch problems by unloading
> a module and loading an updated version.
> 
> Add a registration function to the AET code that can be used by
> INTEL_PMT_TELEMETRY to provide the enumeration functions.
> 
> INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
> resctrl file system mount/unmount. Perform enumeration on
> every mount and cleanup on every unmount.

Summary of Sashiko review: https://sashiko.dev/#/patchset/20261019205031.16977-1-tony.luck%40intel.com

Only issues in patches 12, 19, 20, 21

* Patch 12: [PATCH v14 12/24] arm,x86,fs/resctrl: Allocate maximum needed rmid_ptrs[]

Looks like a legitimate concern for a somewhat contrived problem. Users
who use kernel command line "clearcpuid" option are always at risk of
running into problems on the invalid h/w configuration they create.

If others think this is worth fixing, I can add additional checks to
intel_aet_get_events().


* Patch 19: [PATCH v14 19/24] x86/resctrl: Enforce system RMID limit on AET

Same complaint as patch 12.


* Patch 20: [PATCH v14 20/24] x86/resctrl: Export interface to report telemetry unbind/remove

Looks like a legitimate report of a race between unbinding/removing
devices in parallel with mounting resctrl. Should I care about this
scenario?


* Patch 21: [PATCH v14 21/24] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed

1) Sashiko (still) worried about non-PCI telemetry devices that don't exist.

2) Same device unbind/remove race with mount reported in patch 20.

-Tony
