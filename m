Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C180E338581
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 20:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817514; cv=fail; b=C39ryPnGLrK0WpdYpi8+PNQFTCM9wcDp4CBj0uQ1rihVSt99N6WGa51K6UhHIIaPWQ+5soR9uffIVcFjSS43UMQXehYtlZl5250WBD4EANkDR75ghV2ETOQ1t2Ca6ydb2u8a5J2UeZZOKMQliX8wpKqWpB+gg0vbGI2etx5+e3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817514; c=relaxed/simple;
	bh=vMf7xPPfPaVGyRylDnYE4e/VKmuqd1vOiyIqosND/lA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lzwTBVnTDkJn8nlPLyb+Rw9CG7xk9CPh6fwWCmhocmanyQCUJ+hZ+q9P4XjnO1aXwuq9Nuv2S3c+t36Z7vcnFPhbgUlz35fRWQpzPq2ochk7vXjvBrUWvKq61zWp5DlnuaE0myg3npgo2nTL8XHhtdi5oLadzYHIGjJo3cK2Wkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Peq3QvwX; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Peq3QvwX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767817513; x=1799353513;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vMf7xPPfPaVGyRylDnYE4e/VKmuqd1vOiyIqosND/lA=;
  b=Peq3QvwXFsb1XEwxMftDIPjLF0CSPOOB2GBndiGE4Xd5hBKhfcP5z2gc
   QTYrB1rjxJqGA6wUsNTkaa3q20P1Vlu68JndidYZmMj0SKaEJEm59QRjr
   djZRUGRBrqZVTYnR50erU2wRWRzKx3uUeZF9bpU10Qg+f2pcQgeqNejOv
   yvvKSy/CRqF3tFXC5ED4XVs/RUP5FBrRhTQunoaz5deggT+XlzNDuhMMA
   Nvn8cW9Hkr08iG8hhTxvbnFmr+gq3VFda8SYFcTmT5gdtWji0j/crX6+0
   Q4Xna0cTwnEtIeMH2xcNnx+0Q5OpPbXp/dmvZDB3D3zarTSfGilYwUOxV
   w==;
X-CSE-ConnectionGUID: EDEXMyFNSuOfliHL7J4ALQ==
X-CSE-MsgGUID: KtarYrsbRQOGXiJHaSPLFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="80647505"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="80647505"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 12:25:12 -0800
X-CSE-ConnectionGUID: lujp2dd3Q9WQOLjQSKe5kA==
X-CSE-MsgGUID: fGZTlEwNS4mjQ6C4mjvo+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="202924224"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 12:25:11 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 12:25:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 12:25:11 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.43)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 12:25:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fvP916T27uVLTUbVOlBey6AtX6iv2h5LfQuoP71ZlRsTDHAuEf/Zbx4bsfe/LkplfTCDjZUOsB15kx+jzKT0ZIY1aKH+s7gnWFqREHaA9SFhBZCN8sFh0AALjOzHSL1ezEHFFhJC4yiX+sjVlmfYQW5AqtZuRC1k1XIuYu4cfJn/9B6Z6NSObx8zB1VR52ndnUdzAWZ5kb30LtcY+sy0z3TnyZjaMz7vEJhwp+hHymPZ4tM+BdK+m+TVTmVLYkofwcOyiJTQAb9t0gMY5u7EjbsmuIzPpBtdMD/l10qMJBgP+BuO0ULi1Sf8t5GEZmFclusKF3jEjsqSsk+cerjKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OpyuGMYjeefWl0O9n9i7IDTc0CubRZsriY1APBhwCM=;
 b=BtHv5SpLIWsXwH5A1RZdvI2pb+QFtbfKyfXBLBVDkoraRuYPKTsBigBPcV/B9+GxW3vxm5+Y3SIDdmxY//uUZB677z1Ogy7uIGz8eUV+ARVo9a41wMqu3BbD0oTev6K98Hi4+j0Ce6CY9ENnU/UIOpfk5AODsmL1I0UhlvZnK2bC5W6ybSxt9XK+D62esBGHkzsFEjmn1jOp2kkMtqxrmJWnLVLDiir8uIRHtSevRK4du2FEA8tRdSVLOFA7BpjxBmiLTAG+6H7NawllloApMzMTo//cMN4ilMtKLN+HHLypAgiGkBT6AX9HFfVUL6EvGtmpuw2si4QKK5yTrdK+Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6697.namprd11.prod.outlook.com (2603:10b6:510:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 20:25:06 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 20:25:06 +0000
Date: Wed, 7 Jan 2026 12:25:05 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <aV7BIWu7cSSgCv1v@agluck-desk3>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
 <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
X-ClientProxiedBy: SJ0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: fbffa942-5e61-42e5-4808-08de4e2ad8c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BeBEUt4bCQjZfssrVZjufMOhXY3YxREaKj45u0Mw+6vEB6izMDbZJguOXE5G?=
 =?us-ascii?Q?EJURXWRaw6S2j5TK/Vc2tBslyItw3LYAnjSXbPlLbwdqvzysesUoGIK4iIv3?=
 =?us-ascii?Q?sMfQJgXzEmp+q41emT8uLtRNbgc8wG829KgiCbSgkb/VbwNEUEN5BHBnwkSi?=
 =?us-ascii?Q?eHY378DVuzzuQ4a5r0iJwWW/CMClVgw8LDcDFPNlS3ssVdKSbuHLrGGxNFRW?=
 =?us-ascii?Q?pS77XPGlvc8JM5ycdDiXrcI/DPfzwk3tGIs00rCUxew3ludUWwpl0cz7kT1c?=
 =?us-ascii?Q?xdO7h4R2ROV+CAEM7mWqYPt6U1ea7gySxg2j7uJwUqvLNjsAcSmvOg0mAcJ9?=
 =?us-ascii?Q?S/KlkdEC2cVKHf3+60rSknoujaWo+XUZARFsKzL1tGEdWb+G/7HogVlZbOu2?=
 =?us-ascii?Q?KCRWPzYHLtsBASfUshmOXfp8xFGiZrqJvXkfa7RRUHwDnfww7UCa8+fradMn?=
 =?us-ascii?Q?SYSiB4wxy1UyzaDYWlpKnzc7Bhru0ESt04Osly6ItBrolz/x1yKJ5uX1KLOH?=
 =?us-ascii?Q?5HRvtXqfeWihXFR7iYS8TIr1Xi7UdYmYVC8y6IIpAAtcQh/nnNyttDI+kp4S?=
 =?us-ascii?Q?Bf3/0eIfCxqRdQyUmfG0ntb5AiKwWxxYaph+d6/ZOi2ZokHL2BpjB1jDokVa?=
 =?us-ascii?Q?G1etvoLcY/zsneyZxRksfY6UN7cGDcun/vcIuWbb0KQQ1fm5gWQ1W3elZIz7?=
 =?us-ascii?Q?R+6gwYWp2lNTwLhuEPumspB9ly37nVANlL3jpQP8c2C2EyEF4IABoRDRvAw/?=
 =?us-ascii?Q?Z2MCW69nWRxaqRDeK5M4GZq0zUnKjJ3EGjQEndQirgRtt+VNrSgK69PWowP0?=
 =?us-ascii?Q?kUj6TVgdei0uvYJVSSwKGErj2/KDeZnGRpo/v1KCWBZeIwLMX17g+dIIgbpY?=
 =?us-ascii?Q?BCJULQ3kdE9WM2WanQqv3ls5LgHUsbu+s9V8ZQus/A88bfQ/quDnaKG9lzMh?=
 =?us-ascii?Q?Y5DPE7LnpvuHDfX1vgoNWXfQXa4cEvCb9E+8wPv9BNGperkrwTwPd7QTY1V8?=
 =?us-ascii?Q?NYYCzWDCUz0OhA6r12esvAzmN9kddMuCHNeb2Ly2cp/zx1UJLBwMA4o9s+Ls?=
 =?us-ascii?Q?llr0p18OpLhs01mqrE+qbpJqEFRTCJwdMv15JUcNdHraOjztI5Jt41YaToNc?=
 =?us-ascii?Q?AcjrAEn2biPFYdS6NY26BcowiqpJPHPf8cLxpFdZOjLGWCYWDluoq/l/lqhJ?=
 =?us-ascii?Q?PRpbHlyNpjXxAZj6kXWR/Lnn+uUUEBEKFtgs58faE4HeNVzOOKFxnpcg5PWh?=
 =?us-ascii?Q?ZRRT7+a92Sqq9jFxTfsZki3sPuxdPH/oo40n5I+lUqbL1JaD9t0lfuaotvtt?=
 =?us-ascii?Q?d8VbsK6IVJJZaz3H7XtK4+IIM9LTcBMMlPutHmd4FzTAZ0Nkxpx5dp2EM68W?=
 =?us-ascii?Q?CCG63sxf7Zsj/hEQhozXOkebYuN7AaC9nxXhj50ddOY5veybBrK9gIOk+6iM?=
 =?us-ascii?Q?pqabp+EBsO2vCbf6IofdlHaXOYYMlL3Q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7YozM5CYMxRUhEJaV/DCaOC0HVqSjc54t0IOj2Y3ycBJlTbmIxxVj4GbCZyB?=
 =?us-ascii?Q?ARYipm4N3Gu+wfK3lC7UaHxtspTNnPkzMIRuCOmLlV78pUjjgLNISkXflZeM?=
 =?us-ascii?Q?8lXTEQ8CmKvERI50KOWcpqlCpCqtMF/yzFgzOBVRQdZWcwD1fpe1wE4KttPQ?=
 =?us-ascii?Q?oFbFYd59h9WHQerHYBYlK7CtyjKyObxOCHjuz6QMYOmBCUhrxhXe20cu1eQR?=
 =?us-ascii?Q?gjiVQe2osmRHXicd633ElOo6o7A1nuit++hhzdW3kmV3cjtmxQO9qFnLzUND?=
 =?us-ascii?Q?6eaJJrydV8IV+SuPLTJVidxo2fVIJz1Il1sErEZCjyFM8UI6Fl9MLSuH/TrF?=
 =?us-ascii?Q?qtcwgv5bbdrMZeiyU+YdMdJdytBu08trvUDDg9tmFARdtUB3Vr+bMMcuQiOj?=
 =?us-ascii?Q?Crs+TtB80sNMBtK4DvCwvOMfpD8m7Xr5RssF5zX/dZyrpCPEkJD3DYNXZjcJ?=
 =?us-ascii?Q?BNjqHVcegRTKjcfHFRRZ7QoT0yAxB74yf10WTAkMLjKd+qei9b+RVDnrEhUb?=
 =?us-ascii?Q?aMqevDzRZKtOmFsKhze3A0s5o9WbnOh+EnMvDzqTSBTdnM+Kgeszvdstjk8V?=
 =?us-ascii?Q?AlFm4LobiAv9wOakp/rcjAzrTQHsDdHc4TIf2jzbUiEzNNa98KagWq3oRJ9s?=
 =?us-ascii?Q?LlAEbigM28rKOxx0v4T+XZY8WG4xbHq8rlI+F7zwd7pPapHkZ2fq+4PTjHbj?=
 =?us-ascii?Q?6EfHupCU3QlVOq1kASj5L5t9foOMAF/AicW+VJGSsTGKEccEYYlUcPsw2ONv?=
 =?us-ascii?Q?t0FgZzeRi17+2nyshAnS9ji1T3KC3dmPpYH2i+q7uXaVyXNBuRVnZRKAgKrc?=
 =?us-ascii?Q?sT6prMj4hnNf3C2Ft69T3LdM9PxxJar1Mupd6gIogjszcMfR1woocllGTE6f?=
 =?us-ascii?Q?B7H1crf3u8X3poCV3Fsz6aJLqfarQ0hFq98cq2MKRfGPODI0BoVHYSPkBsiX?=
 =?us-ascii?Q?wuPHGBGFAdagltilUGS/xsIFVpcG0y9EbNKNFrHSuIXLKfsgxQfeA1iLmGLg?=
 =?us-ascii?Q?Xrugwvwgt7D8RSSGCnxWxurF7t/M9uPPg1rkJRzxYCXlMZ3HJ4S+eUyxvgxw?=
 =?us-ascii?Q?NlimkcV7C8UGfOEoa1i81uJYiTtDL7pvFmY+vC7kg16qk/gzktj8cAtCkCnM?=
 =?us-ascii?Q?k2/anxP1uf5OOSRC1rhjDpbA9YUu7krs+aPzI6W1SKUj2XqLMK3+Evp19nJX?=
 =?us-ascii?Q?bJU/snfpK/ZlWh41PaZ4b3n9r4vKUedPQuQEkdcAyBvKugluOZF+4ZfCWPhx?=
 =?us-ascii?Q?kC4nhu7jq6+k4y9CE8Ba1QmVtSS6cZNw9WSbRZJ4ENfU3EUGquD54e/auUR9?=
 =?us-ascii?Q?0D53JnG9du3I/6DzVu5PSHzIZRFFC8LDhEFLyWKpasxI3CkX6wSSouNisD9U?=
 =?us-ascii?Q?5jb4t6vL6/Esm3J1P3/rmiL1VBTmKO6MwLGvtU96DuABpAjGvfbgUXVPYgiY?=
 =?us-ascii?Q?uS4/0XkluKIuazWHk8SSpIQT7krwPPefy4+35p1Gob4eg7/YZlvso6hvVUAF?=
 =?us-ascii?Q?K7lfOh5Xy4TeLGeH3B76W80bWQgzCrk8KcJwS0f/OxKUKQZs3xVP7xWk5RXm?=
 =?us-ascii?Q?u4P07ZEdvxTofRIhUS8LfruT9BN01G7FwSRcsaTvfkvFGCxeWynCo7kYtmsE?=
 =?us-ascii?Q?Mk4Ru3RCQ0xhayWTpouMUK3ReGC0RqJVHv0OZE2sCa6ZPYrtN2+rJ5b++sKi?=
 =?us-ascii?Q?HlZpY0mN2q5pOqACWjrbH9NFyfxmXqavhtOot1j8xUzn7AQETB0DcanAI8gV?=
 =?us-ascii?Q?kJdCPvXRxQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbffa942-5e61-42e5-4808-08de4e2ad8c1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 20:25:06.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvDbCQYiV26ApLljcTPh2mkLnszUMEzmqBhzQ6hQhxZs8rpe/X1qkWereXucW4epmHlAvpPUq4wjNr//JfoXBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6697
X-OriginatorOrg: intel.com

On Wed, Jan 07, 2026 at 11:33:26AM -0800, Reinette Chatre wrote:
> > A better summary of the change is that the "only once" logic is being
> > moved from open-coded using atomic operations in resctrl_arch_pre_mount()
> > to using DO_ONCE_SLEEPABLE() in rdt_get_tree().
> 
> One thing about DO_ONCE_SLEEPABLE() that is unexpected to me is that it disables the static
> key in a workqueue that seems unnecessary. Original motivation for the workqueue on which DO_ONCE()
> is based (per commit a48e42920ff3 ("net: introduce new macro net_get_random_once")) was to support
> calling code from atomic sections. Looks like DO_ONCE_SLEEPABLE() copied this implementation. It switched
> the spinlock to mutex but the changelog (62c07983bef9 ("once: add DO_ONCE_SLOW() for sleepable contexts")) does
> not mention revisiting the workqueue. Looks like deferring it to workqueue does make it easier to not have
> to worry whether helper is called with hotplug lock held or not though.
> 
> Do you see any issue with deferring the disable of the static key in the resctrl usage? Since
> resctrl_arch_pre_mount() is called without any locks in resctrl control it now relies on fs code
> to not have rdt_get_tree() called concurrently and thus risk resctrl_arch_pre_mount() called before
> static key is disabled? I just want to make sure here since from what I can tell this makes resctrl the
> first user of this helper apart from code for which this helper was created and there may be implicit
> assumptions that resctrl does not adhere to.

Reinette,

The deferred reset of the static key does seem unnecessary.

But it looks like DO_ONCE_SLEEPABLE() is still correct. If there are
multiple parallel calls before the static key is reset, then the 2nd and
subsequent instance will block on mutex_lock(&once_mutex) in
__do_once_sleepable_start(). When it is their turn, they will find that
"*done" is true, so resctrl_arch_pre_mount() will not be called again.

Side note: This global "once_mutex" means that any other subsystem using
DO_ONCE_SLEEPABLE() would be blocked waiting for resctrl_arch_pre_mount()
to complete. Same is true for DO_ONCE() where parallel calls from
different subsystems would be serialized by the "once_lock" spinlock.

If these DO_ONCE macros are ever used heavily in run-time code, it might
be better for once_lock and once_mutex to be statically defined in each
invocation of the DO_ONCE() and DO_ONCE_SLEEPABLE() macros. But the fact
that the static key protects the spinlock/mutex from being called may
mean that it is practically hard to hit problems.

-Tony
