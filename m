Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A949C349B13
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763487342; cv=fail; b=VJoMCFMI2x+SGvVXTiVi7mRZW2a/RJVqBre6bcWSb9f1Ftjo2VFnN43YI+ESlH1XSdubLrKi2ycdk0J+ud2sROG25LqY0ZLa8wyCQsN9eXaXJIuTV6I8/JzdUDHQ0tdOqaAlz47zlHEc/hFPAHrmCbDzEVyZZJCeEScaopCjJIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763487342; c=relaxed/simple;
	bh=nayXs5hlgbaFxO4CoULAK6a5SjpjyQjwdHwJCHIwaQE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EWrrMddhFDaNmDexKgdFKjR77Ln5aFRF+Um+VGpUap8PiO3hQxZq944jF3UfSRri848q0XODC8Y8HBdNMRQ6EzfdLfZ/yLDo2N77tuexiyHXNTKgnfH2TN+Bn/rMxRMusaykp86O2UqCh+cbU+BF7BTSVjavRvGw7YBHmP2HcvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMUs9piz; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMUs9piz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763487340; x=1795023340;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nayXs5hlgbaFxO4CoULAK6a5SjpjyQjwdHwJCHIwaQE=;
  b=mMUs9pizh2U1XDze+lJAx0xuhHTnyEul9s9y3MuQwA5htHoW8hfp5Mc2
   VOahwa3oFRbElvyBa8i+0wzgxf6qAmobnkXpckpyMfbHvE5u43pKwUq3N
   WNnad7cieW7EUi4QkDCV6UnrFNesRplGbAK3dsngZ8zuJa1/DyEM2lPDh
   VOy983W7eRBgq9If3oMo83P7HTgM6dV4K5ewHLnCdZGEN7shlIbaNStzl
   Nf6PtBooovircu5y1eHr4BreSiEWXJLcseN678tWVQB3KVujPC6xbRgD9
   5Lt/T+8+sDryBo2AFH/7va+uUrbhgOe6VbJjl1Ixrpe+W/RJshMDtJ9J1
   Q==;
X-CSE-ConnectionGUID: cYLpQrCbTbSLPfX1LpUfbQ==
X-CSE-MsgGUID: bo7bVO38RJiTvNjCXGLH9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76123535"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76123535"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 09:35:39 -0800
X-CSE-ConnectionGUID: AX1OL29zTv6tq/JMxgTcxQ==
X-CSE-MsgGUID: CYABykACREOvIEPconakTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="191046493"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 09:35:39 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 09:35:38 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 09:35:38 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.21) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 09:35:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nn/KTL1zdl6PKhXCfqxJk/OLgl5HVU+w6tUw8URNgMtosN7y6iD9KvOnxQTqfnG6NlQdFLPTZ8x9ZpZWaOBZ/6Yjf3X9tGPczzb7Rb+Ftjr2MRQ0Oy29sa4mbV5rzgEbzejFgCYgGaCt9flhgG6LNyTVTh5a6PBbwNNzQbZeG5UP/GFiBQWs3gXkWlqFMaH8z9dWqSvdDmPycn8S1Ew8xK/oMRN0vo8ehcFBXNJtUJZXlVTxMNnSHI2ODwqXeJ78BXE280knOogEuvDwdz/mO+3WZPxSvmzA8qIGurlc9w6RXnBRTSO/mrXHG4OAg8x+nyauHsHGdJ2Dux+GpM31CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6KgPXtObOXgM4TTkgUhzr+575dNHj4kX5ueqwkA9DA=;
 b=U9f8DmYzuTn17FNT71Mo5sSg59mwMDO6njOkY88pVxqwTNXBQHWxFmEWEbKD0GbkLThwaomX3qnNoAhC3ZLuv//houT6assa6eQYLOYu2DbFEhd0sHFfMUXA8S/pFvVETH/2ntYtiqwzlxuQkCgsIlGSEAeZcshjntyb8DvmfsEhdNrpey6aODBoWynoG20efuIWs8HKnM2p0GYVpskgTvfWraCdLTctYE5tHroGTFcFcn/AMqj3pcfQhIyiJjvlc37iYOuumveR8uYVNnCbKZ8cTCskizPy1nVf83LX659tbRgroqK30dGRGvh/XTnDS4FpN/e8CeyR2D2tEd1kHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6980.namprd11.prod.outlook.com (2603:10b6:510:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Tue, 18 Nov
 2025 17:35:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 17:35:35 +0000
Date: Tue, 18 Nov 2025 09:35:31 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
Message-ID: <aRyuY_TF5d6Me7MD@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
 <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
 <aRtPL9IQXWiKfhEk@agluck-desk3>
 <cdbc23f6-cf4b-4e83-a037-0aaf7c076e8c@intel.com>
 <aRtu0J4os4bXTLV2@agluck-desk3>
 <f3ec7e8b-b042-4d38-823f-4f4174cb9d09@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f3ec7e8b-b042-4d38-823f-4f4174cb9d09@intel.com>
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: 833de379-890e-4b80-69cc-08de26c8e095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PkjoRtFKz9bys9kjcP730I59JTFbjj9zLzH/VyyMJoFgBcVU1Y2JWDT2XB00?=
 =?us-ascii?Q?2ZhKpKR/3wSznS/3TKXRE6QbUHsi5mMLn4+nAoEguYlSw7V8j8eF7Wbj15UG?=
 =?us-ascii?Q?JiSFTXScstaYpBiZfp2OTJQJl3Jf2Uythw+8xtTvxfkyrkwgg2uklAQmQsPN?=
 =?us-ascii?Q?1++FQZ9OJZFmTbu4zfHTz6nJ4CSG3pHlR/QikUFLXfgFb1mRvyARjfxoSN9P?=
 =?us-ascii?Q?D6lO+QOBFl17jrDaDRQG/I9t6Zw1faxtuAD56a71fRYgyDabGo+LKRL8NApY?=
 =?us-ascii?Q?8q2XhbGNzFQyVPBJcXXPZj5nd76e1ilsPGI4HVC8EaytDp05yJP6mY1+psJL?=
 =?us-ascii?Q?32y+wMSxn0+38/pU1kVlguOG4ceMlQCA+3gTAHpIemKgWNlA22z4/ZsvQFOH?=
 =?us-ascii?Q?pbLkqeURltvRYK44cskz7vO21drvVP4secjgtk7+pA4y9fhUA5aVARgI9B6z?=
 =?us-ascii?Q?CdXdsiYAyKsfDBTIhQ1Wv8NwOnSjingj1/5phmM2I+zVi419Gy7a8nAj43BB?=
 =?us-ascii?Q?G64euxZVIS0oI0y6FDkRHhf14nuCyuY5GGGWMVssmijjPifVBjMQbKVjxHaA?=
 =?us-ascii?Q?2TH/pSLTpzNr47Plggc5pOLOuH3sn9U5+JhNmVqKZcNt3FZ3k+KAjYoERof5?=
 =?us-ascii?Q?gutqFa3OickkpMg4fs+1V8vBPc12bOJ696fL4UHV0I76bWrpmBe+VuXMh8bz?=
 =?us-ascii?Q?QTFpEeBjVwUWrEgHTg5HdAtyDifKWzAaB7HYk3Pv6+FlGxZOlEt15vvxJYBP?=
 =?us-ascii?Q?U2wTV0A3L4XlNoQvqoxOqU/Woj7jhnhJxlhnWuS62eiuoW1RbL6cRekgHVnF?=
 =?us-ascii?Q?7UWXe8bhApN4cqslq5+rAKo2cklyCvMEWzGv5kqg2V+u0k/L6uYjQOYTEqXm?=
 =?us-ascii?Q?O44qhU/obFkk0CDrQdIh7y4BhRFrwomgcJwvnH9Qntjk45KgodkCWcy8e2Wl?=
 =?us-ascii?Q?N5GUeT1vMfU0Yzw4KEDirtqIo4sDKapCi7Eo4nXb3lHl+gS4O2kZzU8i+N9y?=
 =?us-ascii?Q?aCOqvUdJEyYyVprG9Je9XVsHraLLIZ48CTIGnFmscORk5CgUOtaDnOojpdSS?=
 =?us-ascii?Q?WTqaz7FrGJ+CaWhJYjGiHjNFx9cAKj2oRpbIsuxgxyEm/SUWwYtehCOOupKs?=
 =?us-ascii?Q?8/LFn+N7AY1i8pbxIL+YWwMVGEWHwA9Qzk6329Qt1RZn3cpgLAlAqiw6nmF0?=
 =?us-ascii?Q?LI1LN8KrX8Jn/wSBIwOyQyUslQFD45kmIU48mDR20ElZNYATL2BRuqDY9q65?=
 =?us-ascii?Q?xCytjSO2vV8JbVyCv4VpsHiXK+U4Jd8sKesZrEmq130ryRyXLDwF+iAlnfe2?=
 =?us-ascii?Q?gFQxaobIrV0sEwJlx8npRMyddwvIGz3U6+Lkb/5Py3rqck0HYSTbkGyRUEhb?=
 =?us-ascii?Q?m36OI7wi8IrwH0pmGQr/Bm4yvrNN0c9fkjSgLgf0slrUE8JR7kAvHmj+tMia?=
 =?us-ascii?Q?vJStXi892IrdWQ/4HWo5YXp4gG6rJcpe?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GysEV3liTAuxyGGeYwK/N70KyGY5KDtph5UsL6uQjEe2GSsLbaZWNLbtZxJX?=
 =?us-ascii?Q?7nAW5MHCr7F/DpNSF0Irk7F2FUWqAr7UQpOvqnb778Z8PFIaadexLYeUDAqa?=
 =?us-ascii?Q?3oKKweY4LbLlGm0RAOCVuEYIp25+otA0InhD/xLeoibfRR4lovyZrEsFW2rz?=
 =?us-ascii?Q?AHNenaT/5cuM1pEIY55G9hIOa8Z/eloTbyTzojOXXhRRs99nblAt9K7I3BOC?=
 =?us-ascii?Q?fvllZ59HHzxB2igGAzV5Zl8HDQZb6v6pGzm79N5cXv8J5SpnXzXGVb646i1o?=
 =?us-ascii?Q?Jf/KfStlgFjJZ8TdVRS7llQDa4NalUCJAwOLB+YbKIdCH+NBwMmTk088d4do?=
 =?us-ascii?Q?CqgYKdHq59FrMm3J+9tA1DM1QzlQxzWtp4cUlkzROHMMY1mh+JaiagzSNmFr?=
 =?us-ascii?Q?2CzezfdGufXc4uGAdNPhWYmpm02u4YDbkiCGvHa/+vEgWBeFsyONtQdz883z?=
 =?us-ascii?Q?TnT8bcye531JKy5AHtJQJP8YxuAmV36DifDcd4n6FVh9HSMdRVWLW/mkVHcE?=
 =?us-ascii?Q?yZ7Wr0+umln/uaQGKU1kaJ3Lh0JUqHsx2am3bzFEWsLG6W9iHeo03h2Ql3i8?=
 =?us-ascii?Q?8Pm6OaOt0G+jBinX64Z9ixj4JzT/JO5H9qeLnRZQVwrlug9dn8X7N/5I2XgJ?=
 =?us-ascii?Q?w2md6vgx8sYkCq5GP0O2hKgxxEcMKO/1CGagb33xzmkdkK5OsoP/z6IiLO1b?=
 =?us-ascii?Q?kovRD+7tV8XZCgt12tb4aeRxmltn58BNVnwvU9fIsqVMAO8T8H70Dc4ACznl?=
 =?us-ascii?Q?mjPr1gScqoKVXOmfNI9oXyuawrgKaSh/3JXSH85oYreL5uBcMhVPn8V7jeMC?=
 =?us-ascii?Q?l9xZtTCRjHOkUFAa4dbF9QPZSY41lJ/c3q7wFhidtGVsz5hR0524ktsfVsBz?=
 =?us-ascii?Q?o3AVX0GejsDUBAN6I8iPgIekqacFk3ySxvkhKhtx8GC70r4+EbrMcw98xmwR?=
 =?us-ascii?Q?WRYqKgHimlRBS+rMepRIkpEOm02sAr0DQALAFj6LFg5OTS8wmFRfJ2V5QuWb?=
 =?us-ascii?Q?1ss0+4AC6VjA/Z2MIbDOUHDf36KQllkvVWZjaPfFt5cnt1UMo7/HdUO/9h9b?=
 =?us-ascii?Q?wPwBZdxRjCFqgi1qCD5Q2SnerCiLXKEc3ycGoTLyiFpO2krjQmrR4Ruen/Ve?=
 =?us-ascii?Q?Ain1fAf//v2mJerQNpnnhB4EIX2LeOd2m8t6w76BzYrAU6U4j1hEnUL3VLlJ?=
 =?us-ascii?Q?as6RQDMGB+RrtlEDz0Fx1dG/i9kdc6rmirZSbphzhzDvnQa7eLcdTsT6/ILc?=
 =?us-ascii?Q?/QegrIytwP1/ualOWzN8y8c3xCbGQPyEAWquoY1f1WCnJoDGWY4WqfSsm7EA?=
 =?us-ascii?Q?vC29rSJ3xDk7+Aon8GG4VdK0nqN8RuOEl2UsMcL6PJ0lZ04T4L9rZDEp/jNH?=
 =?us-ascii?Q?I9+7L2ZoiVS2kMRE3LtI6x7l6yDk/lkhcQGRApxWbLFC0DCqXrd5a5gc+eMy?=
 =?us-ascii?Q?AmK4RHbWJ5cwueWbVSZ7k0XaFob6t5mdkZV8xx8V/B5oBvnLlmTnb5f/Z2UX?=
 =?us-ascii?Q?p0Yz9g8O00EQvFsb4ai1/hL81QcRCwEN9bjhxlwHwOc9KeF5VmDCJGFUqk6i?=
 =?us-ascii?Q?In0uIKRFYMaFHc7KTaBsNSTmwDBnY+vys7zOMKp/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 833de379-890e-4b80-69cc-08de26c8e095
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 17:35:34.9259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNiqblJagFVPvvvKVM80lirdZFMRyDt6XE0Jxjv5P/cLTlyYbyNceAmz1yNiDHxJwnIUz2jiO5S0+IdphExD2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6980
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 08:48:18AM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/17/25 10:52 AM, Luck, Tony wrote:
> > On Mon, Nov 17, 2025 at 09:31:41AM -0800, Reinette Chatre wrote:
> >> On 11/17/25 8:37 AM, Luck, Tony wrote:
> >>> On Fri, Nov 14, 2025 at 03:26:42PM -0800, Reinette Chatre wrote:
> >>>> On 11/14/25 1:55 PM, Luck, Tony wrote:
> >>>> How a system with two guid of the same feature type would work is not clear to me though. Looks
> >>>> like they cannot share events at all since an event is uniquely associated with a struct pmt_event
> >>>> that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
> >>>> will complain loudly but still proceed and allow the event group to be enabled.
> >>>
> >>> I can't see a good reason why the same event would be enabled under
> >>> different guids present on the same system. We can revisit my assumption
> >>> if the "Duplicate enable for event" message shows up.
> >>
> >> This would be difficult to handle at that time, no? From what I can tell this would enable
> >> an unusable event group to actually be enabled resulting in untested and invalid flows.
> >> I think it will be safer to not enable an event group in this scenario and seems to math your
> >> expectation that this would be unexpected. The "Duplicate enable for event" message will still
> >> appear and we can still revisit those assumptions when they do, but the systems encountering
> >> them will not be running with enabled event groups that are not actually fully enabled.
> > 
> > There's a hardware cost to including an event in an aggregator.
> > Inclusing the same event in mutliple aggregators described by
> > different guids is really something that should never happen.
> > Just printing a warning and skipping the event seems an adequate
> > defense.
> 
> My concern is that after skipping the event there is a deceiving message that the event group was
> enabled successfully.

I can change resctrl_enable_mon_event() to return a "bool" to say
whether each event was successfully enabled.

Then change to:

	int skipped_events = 0;

	for (int j = 0; j < e->num_events; j++) {
		if (!resctrl_enable_mon_event(e->evts[j].id, true,
					      e->evts[j].bin_bits, &e->evts[j]))
			skipped_events++;
	}

	if (e->num_events == skipped_events) {
		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->name, e->guid);
		return false;
	}

	if (skipped_events)
		pr_info("%s %s:0x%x monitoring detected (skipped %d events)\n", r->name,
			r->name, e->name, e->guid, skipped_events);
	else
		pr_info("%s %s:0x%x monitoring detected\n", r->name, e->name, e->guid);
> 
> ...
> 
> > ---
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index 08eb78acb988..25df1abc1537 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -241,6 +241,7 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
> >  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> >  				struct list_head *add_pos);
> >  void intel_aet_add_debugfs(void);
> > +void intel_aet_option(bool force_off, const char *option, const char *suboption);
> >  #else
> >  static inline bool intel_aet_get_events(void) { return false; }
> >  static inline void __exit intel_aet_exit(void) { }
> > @@ -252,6 +253,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
> >  static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> >  					      struct list_head *add_pos) { }
> >  static inline void intel_aet_add_debugfs(void) { }
> > +static inline void intel_aet_option(bool force_off, const char *option, const char *suboption) { };
> 
> (nit: stray semicolon)
> 
> >  #endif
> >  
> >  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 5cae4119686e..68195f458c0b 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -842,6 +842,7 @@ static struct rdt_options rdt_options[] = {
> >  static int __init set_rdt_options(char *str)
> >  {
> >  	struct rdt_options *o;
> > +	char *suboption;
> >  	bool force_off;
> >  	char *tok;
> >  
> > @@ -851,6 +852,11 @@ static int __init set_rdt_options(char *str)
> >  		force_off = *tok == '!';
> >  		if (force_off)
> >  			tok++;
> > +		suboption = strpbrk(tok, ":");
> > +		if (suboption) {
> > +			*suboption++ = '\0';
> 
> This looks like an open code of strsep()?
> 
> > +			intel_aet_option(force_off, tok, suboption);
> > +		}
> 
> I think this can be simplified. It also looks possible to follow some patterns of existing
> option handling. 
> 
> By adding the force_on/force_off members to struct event_group I do not see the perf and
> energy options needed in rdt_options[] anymore. rdt_set_feature_disabled() and
> rdt_is_feature_enabled() now also seems unnecessary because the event_group::force_on and
> event_group::force_off are sufficient.
> 
> It looks to me that the entire token can be passed here to intel_aet_option() and it
> returns 1 to indicate that it was able to "handle" the token, 0 otherwise. If intel_aet_option()
> was able to handle the option then it is not necessary to do further parsing.
> "handle" means that it could successfully initialize the new members of struct event_group.
> 
> So instead, how about something like:
> 		if (intel_aet_option(force_off, tok))
> 			continue;
> 
> >  		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> >  			if (strcmp(tok, o->name) == 0) {
> >  				if (force_off)
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index 6028bfec229b..b3c61bcd3e8f 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -69,6 +69,9 @@ struct pmt_event {
> >   *			data for all telemetry regions type @feature.
> >   *			Valid if the system supports the event group.
> >   *			NULL otherwise.
> > + * @force_off:		Set true when "rdt" command line disables this @guid.
> 
> To be consistent, can also be true if event group was found to have insufficient RMID.
> 
> > + * @force_on:		Set true when "rdt" command line overrides disable of
> > + *			this @guid due to insufficeint @num_rmid.
> 
> "Set" can be dropped to be explicit of state instead of potentially confusing "Set" to
> be a verb.
> 
> insufficeint -> insufficient
> 
> >   * @guid:		Unique number per XML description file.
> >   * @num_rmid:		Number of RMIDs supported by this group. May be
> >   *			adjusted downwards if enumeration from
> > @@ -83,6 +86,7 @@ struct event_group {
> >  	enum pmt_feature_id		feature;
> >  	char				*name;
> >  	struct pmt_feature_group	*pfg;
> > +	bool				force_off, force_on;
> >  
> >  	/* Remaining fields initialized from XML file. */
> >  	u32				guid;
> > @@ -144,6 +148,26 @@ static struct event_group *known_event_groups[] = {
> >  	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
> >  	     _peg++)
> >  
> > +void intel_aet_option(bool force_off, const char *option, const char *suboption)
> > +{
> > +	struct event_group **peg;
> > +	u32 guid;
> > +
> 
> Can use strsep() here to split provided token into name and guid. Take care to
> check if guid NULL before attempting kstrtou32().
> 
> > +	if (kstrtou32(suboption, 16, &guid))
> > +		return;
> > +
> > +	for_each_event_group(peg) {
> > +		if (!strcmp(option, (*peg)->name))
> 
> !strcmp() -> strcmp()?
> 
> > +			continue;
> > +		if ((*peg)->guid != guid)
> > +			continue;
> 
> If no guid provided then all event groups with matching name can have
> force_on/force_off member set to support user providing, for example: "!perf" to
> disable all perf event groups.
> 
> > +		if (force_off)
> > +			(*peg)->force_off = true;
> > +		else
> > +			(*peg)->force_on = true;
> > +	}
> > +}
> > +
> >  /*
> >   * Clear the address field of regions that did not pass the checks in
> >   * skip_telem_region() so they will not be used by intel_aet_read_event().
> > @@ -252,6 +276,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> >  	bool warn_disable = false;
> >  
> > +	if (e->force_off)
> > +		return false;
> > +
> >  	if (!group_has_usable_regions(e, p))
> >  		return false;
> >  
> 
> rdt_set_feature_disabled() that is around here can be replaced with setting
> event_group::force_off
> 
> > @@ -262,7 +289,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> >  	}
> >  
> >  	/* User can override above disable from kernel command line */
> > -	if (!rdt_is_feature_enabled(e->name)) {
> > +	if (!rdt_is_feature_enabled(e->name) && !e->force_on) {
> 
> rdt_is_feature_enabled() can be replaced with check of event_group::force_off
> 
> >  		if (warn_disable)
> >  			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
> >  				e->name, e->guid);
> > 
> > 
> 
> I believe changes I mention would simplify the implementation a lot while making it
> more powerful to support the, for example, "!perf" use case. What do you think?

Agreed. Simpler and more flexible. I'll make these changes.
> 
> Reinette

-Tony
