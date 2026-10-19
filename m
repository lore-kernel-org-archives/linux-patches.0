Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792425016;
	b=eKqo++o+H4yvV2+im5CHDk9UYJSvJyA2aoxy7hgpQ2hPz5s9W/+xEszyBwfhVK/DtS4o
	 jvJqn3T5NrCT/autb7XzzOR1pW/hxpf28m3T6ueDw0YK4AZq2BCT+9hyYT0mbySobSSkr
	 d3AwWcMNc3GzUa/BsNEbM8yT7pHfRggmBwmkSAUJkfxbMzZ22EsKbxPQCeYwMNUn4lpRK
	 Sgx0L4W3sVGb9gjUlq0IoIXQ+lIzQlEjjjPveQYW6iOy06Fq0+ToijrVgPHxACWk3wI3F
	 vh+HmivPWESe8rn8h02jLOY4r96QmeY8W7fj3n0udZ3zFe4ik6iyKrR4dQ/ZNxiQ95w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425016;
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
	bh=o6yApKGP8VHXJcJA7GvHCJR7/pOFvP9g1sQ2RIQgNrg=;
	b=lOmUEqXGQ11RP9bfBVB1W2oQN15kS9SddwHSLBCLN2bbl7cugi6Mh5vQfcDShgalQFGK
	 BWAWztKox9zmV3DNyDxy0CaE//0srfBIu6KBeUCPh+PGkFwZ+qeeS3+GO2xRV3NKE2RBM
	 iR+CWggmzPn2FC5Mr3fHpWET7bBHUEmFRTageTz6WKkwRU0CLO51hlmZj3sBzMz+3nvkt
	 dZb0PJDNUuqmO6ci5KSqzhlZ6f3k93tf2i3jok6Cu9z6NzqQ1Y9M7DxVjfz8d07BC304/
	 l8NjTkrictGql2WUtQoHL9ulLeKGwlP1L6DJ7LZbi/mAiIcKiciKr5l1obFvVxih57Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="YleDZi6/";
	arc=fail smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06AB6080A8F
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 15:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C06AB6080A8F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YleDZi6/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792425015; x=1823961015;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eUTKvkQnTi/zHdZ5WWb3V0WygZKhvcigIHHBySGjYrE=;
  b=YleDZi6/cqOC4pHNbQcnHMIeNDEDYrvIfmcNxRpwu3y5Z89ub1bwAPDV
   cqY37In3obmo7c0O2tTTiiKcQVmznlV/llTzBuWtoubhceD2Cd17QOvrf
   uFFjF+WVyV5zHnGGqpxD6U0AzN6HyHIW9KthXMBF5MEKcTxYNOdb0Xocm
   lfxBbNdCcDipMRoEgAiTu6XxvAvDV5LHz4KLHM+y7XWDaOPyoEyhTI0Ug
   VkrgvAseWPpoYkdgcs7TJqCbAUJe/N5XrIHk1TzrtkyJr6z2CyqjlduZm
   J/yEGuDHL2oTTBbzolQb9NAX4ehjYa8UkwXeJUfXVMV+bObhCZXl9IM0n
   w==;
X-CSE-ConnectionGUID: ZpPL0fR4Raau/F/0mJrkBw==
X-CSE-MsgGUID: Xct5LsKkQFeD4aPKQ4FANg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="995017"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="995017"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:50:12 -0700
X-CSE-ConnectionGUID: Lg6NNJk6TR6HY+zEnVdVxA==
X-CSE-MsgGUID: +p5Vy/qpRiKbumacL0a7EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2567395"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:50:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 08:50:11 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 08:50:11 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.35)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 08:50:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmCphu27w9Vfv4kC9vpvIaSSBVeCoOsnoeERNLLOrZn9LHnW/q0N48s8+3zK//rg5XfYzUM2mSyYbPyK+vPhLAvjSfOOezHWOnXxKhqLZsg0aQYjZcUzoNsfKviFiSAZHDuXIZJGnrErg+v8rSoWRr1TLZLxYiV/xT7N2DfA0L8yhuPztr/OaAR82mCFsr47ZXA+8ubVUDVjwwxkOs4kvNZtQKQXc2F96LKjzVaeEIVSl9n+QhXKwfcWrhSH5e1lGHyudHUnnSNYd6WDIGAEUzOCVy1Yt82p7ht1awkhcCGBIfH58/RKRmmm41acLD/apWBCQbN6OeVQ/VgXzhERDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6yApKGP8VHXJcJA7GvHCJR7/pOFvP9g1sQ2RIQgNrg=;
 b=DR2HmbMwiJtMdFG2YMHNafNmr5uleafbvN1zW7hqslBoNpru32do5VBVdHsMrLvhNdqGDyHoSA1Dd+ge9zJhJNIfLoeoIWs0ScfXijCOvDgHODSGzu7mRBofHPez+1STzuRo0DbKycl8M19D5HRsGqvkJLmhfEskVDZAe01JaIFvy0GrLJcIfTbS0jcvw2A6MdnaHo9UdC6a1WICkG9Se1Aub8SN+O2sbBOf2KYkc7zQKn/0kuzGTTTh+OZHWyxSmVS0coKc9MUWtCSy1ap6pVkr0fqFL6K4T7bv2i2Dn/2w4c2kjn/ahaMmgtoRxvA5MA8nTXaBT6EHL+1U+ymhCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH0PR11MB5109.namprd11.prod.outlook.com (2603:10b6:510:3e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.20; Mon, 19 Oct 2026 15:50:07 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0496.021; Mon, 19 Oct 2026
 15:50:06 +0000
Date: Mon, 19 Oct 2026 23:37:06 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 03/25] x86/resctrl: Check if monitoring features are
 supported
Message-ID: <atY5IoVB_WL7TB5U@chenyu-dev>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-4-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260928221509.68002-4-tony.luck@intel.com>
X-ClientProxiedBy: KU0P306CA0078.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::10) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
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
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH0PR11MB5109:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb46c65-6327-4004-df9d-08df2df8a561
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|22082099003|4143699003|11063799006|56012099006|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info: Mprn5SChZTbmlKqhX0yebAo7jbx7oNkXD9/rJNnTg0nf+Snngh7TKohjQopUgdGNLyyHrZfbvxWBTULxTULGVOGI/3K3IQoiiTkgR+HKoIQp3qAYVovmDJSTxdmV185CSnOXc/U90Q0qtsLUZGqBeuooLkvbZzsspkUmu5jvfr10zxS9NNcmLAOCFXy0PUaJ8kWWSZnuTjtKTVwH8owY8m+RC97BtadNr1VhvZdNr1BpzDREHF1kiG30BjIgJUpN5X4d2TR/Als77X+/eHzSjjdoCBIcyTwNvxYeb0KbosFmGAMi1+5N8+3DFxIswqo1FIcAjQYhmpqWmAUz0mrckv6CgB0NizRGYvP4KjmlqzICTGV+tdDYb+T/dyE0Sn5uOKXL74bnOngJdIAodrJsWHaVDff8ta2tVBUrFPi/+7ds/aGwzSSceiBBL99xIi3b/csEFoyEl26SnJmxTsvEOX0t9o7c8iZj2ibSvAj/D/f/08MT/b81Y6CDbVuTgmq6gqr6tZNhoQa2ysfUxOo63wwqYRibjesNk/ofsFYCJ+1roQ/QIEOfymfKxIEDwLTzKbrcEY/y3lAd34EGWPuyjI2CsEzEZxa9coOXyseSIc7d/rtX+dzzz0OKkUfJVPkRlAWiWo9op/Eisj4eff+0TgU21ynCrLhuFCbPKD6kIZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(22082099003)(4143699003)(11063799006)(56012099006)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GmREnfopkG0W0ZdZJ9wMnh3w2YGHrEwwL8M9eESN++Q4ASam1lS+Q9prSP9V?=
 =?us-ascii?Q?5eWJNNN8ThQ873XChJA46D4LvyWD0khKFGU8CLHmhmLqjtQmngBnbzVKdoEE?=
 =?us-ascii?Q?oF+xeuPReChWGkKU740mX7sdf26O36CTDdiILqVnXsUygr/xJYGX93BCBSHj?=
 =?us-ascii?Q?DAmSQKsL/egunJB9poSGaZfyduW5xq911flj1NWGJTNacNCb6gnooWFQD/Ws?=
 =?us-ascii?Q?WEM0INq12g2mX7QdHJYwC2pAlxqj8e8lUgn3cWgPNG95CRLEEfQwcj+WM29C?=
 =?us-ascii?Q?lEJ0U73CCVqazubWQfcSNqBRawwVqUA2LmWNY3G8LSbsqKoZh1pB6d1CY9XR?=
 =?us-ascii?Q?tB0QasCyuO0aCgGWVdy+kVJDoMAQ06z/W2GFYLqj42X/SZ+VdIBTcp3PbDTJ?=
 =?us-ascii?Q?01W8/YnYdEKmYVJm672XgVwBn8wHAPSmDTog3w9uitoOVoqa1JYteXpsj+HY?=
 =?us-ascii?Q?/drgDoL4IRrMtwjn6VBZjV0nozzLqEZCq8vhg4Ixx5k6CcocRirbsVh/Yko7?=
 =?us-ascii?Q?mw0I/M/JMMEZdsuDxwJZEPMZOkp5EWoPR5u1O6QuB+Zewx59BD/PgsgfBav0?=
 =?us-ascii?Q?rxygo6ZT+brcNoOXV5u5n0Cu3o+QiLBts7MLh6AUP7fGFMfKLd5l21bwc6Da?=
 =?us-ascii?Q?YwGIUB6v9KA5upxf0QvxRTK/8xv7T1nFbr8+g2n25MA4tzPTj9HOom+byTR1?=
 =?us-ascii?Q?ijSppk3pf9Y8nmXOaAsdLzeCpnql441AnMW4z5olu6dzVfXPaHJsHKIuw27/?=
 =?us-ascii?Q?Li0vj5U+4se0e/A4YNsSk0F7BS4p3uY9bTLct7sPNR76QJK7+oqz1FSxg+p2?=
 =?us-ascii?Q?TwNeoKgwFmrrAy6IwMHMU7ivHmBhIf1P4i2N1ITdeJCyrwwUL0xbopdvSdEc?=
 =?us-ascii?Q?/87AL2xI4TMBmsW8v2BXi2n1cBHuEvSh+Y0FCW1RFCNa/8HK4/ZGUTD4ZISX?=
 =?us-ascii?Q?umsE99DoUj7SY1xMkeviVjlLkThA99Ej2GusAXm57wmT5fLbskMdrdEtVSWi?=
 =?us-ascii?Q?S1qrFmrAts3J9DZeOatQMWoMVMOPlyPZheJ4gaWcS4bvRcIHzNX344QA/v9O?=
 =?us-ascii?Q?UB/uA9C+PH536tmjXhVi/P/QpjYfLwcBmEyBdXt2q9SedNOua4ynMMEJH72N?=
 =?us-ascii?Q?a/9g9rD1TjbLjPZeYmnAe70F+k0+6LYEij+6lD1Q4O7qIyhbqfN9OU5h9EHg?=
 =?us-ascii?Q?GXUaYa+WzYqnirlz/shqzPRIeQsWR1doGyTDltD0zabews8blf/iS9FCwbhJ?=
 =?us-ascii?Q?fMIMkYa9sor4IwqArvFkUuGeQj6EQDDUWDV2xaAyw+Z9465oPb1sgSSX4CjD?=
 =?us-ascii?Q?A2lnFCLkrZmREW8EHrGja0KPztGM1eaFgJA+kCQkjegmMyuW0fDln2+/XUtK?=
 =?us-ascii?Q?8GDcouoQsahwueaIxmlCU2XfWyTLrqj7vA+calgJfhXXvVspypPYYykvdT4N?=
 =?us-ascii?Q?1MfCc7oRLIai/B+pugQlwZLKEZHcn53AKevfpEgJvAVOjAFrdIqqXkDQKdOh?=
 =?us-ascii?Q?dj2mBTBrEpx68UD6i7LLBAC+vSuj0GMk5HFjPwMGRZryZM7ArlfLSyxM0+ZD?=
 =?us-ascii?Q?chGbEu8o95hJO3ocI4LZDasry/n65iegxYAfaGezvb7LnK4KlFYp25xSoEhk?=
 =?us-ascii?Q?SYMh5KZnEaG6wH5hW7fWMbnTe6sz8Ygd76UeIINecFEwfQ7wtdx24PMc6P9C?=
 =?us-ascii?Q?nquTqhIh9EbuT1unx/NS9fuZa4iFc75TO8/oFNfF1HUTglyGYzfYJerAVthL?=
 =?us-ascii?Q?3HabxUZD1Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: XyRkXNiXbEXnehImKSNfBSz4uaAe8yN/7K/N15i2hE+szcW3K+1PJ+A4caIXygMTij7aV5o9ANjdc8RW0TBspIl2GQLtWePNzY8+JinXmlzD0P4W1W9oTtGT72kdo4n3dAFaEiJrVF9g8D8QDkCopibgQ4MFysLLbP2IwY7Lo92Iv+mhMLbZ4tf86EqhPgCZJvilYt3CmhPC7fYj/JcyL82zxpVUNpsGhnfj4nHYxaDYO4hP4N50oer+84nrQU16flvko0fePW5w1c6M88SbSP3HS99guKBm+Du0RGERYohmO1v/HzOK1OSusc6ef5lWEZU1UmGoHrycCpEL8iBAQQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb46c65-6327-4004-df9d-08df2df8a561
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 15:50:06.4609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BlHHizD4ja2Wnw7baOQWcF0E49nGynWhXT/kJzNKX7JuXQ3aVgeNEK3Ukce++Xy8iSCxoVVFwOdRy7HfUbumXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5109
X-OriginatorOrg: intel.com

On Mon, Sep 28, 2026 at 03:14:47PM -0700, Tony Luck wrote:
> Both Intel and AMD manuals say that software must first check
> CPUID(0x7,0x0).EBX[12] to see if any monitoring features are supported before
> checking for resource specific features supported in subleaves.
> 
> Each of the L3 monitoring features is further gated by CPUID(0xF,0x0).EDX[1].
> 
> Add checks for these feature bits.
> 
> Maintainer note: No need to backport this fix. No issues have been seen
> from this failure to follow the exact enumeration process in the manual.
> 
> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Apply MMIO-based CMT patches on top of this one,

Tested-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
