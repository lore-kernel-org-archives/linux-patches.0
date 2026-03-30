Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776683A0E85
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774904791; cv=fail; b=bxXK9dhahmJuSIXI79U8/efspn7jqQceHFLClzYA9cut2Bncqko/357PXzrr5PDtvrkhkOYu32nG3dhW1XLFxUte8dqcqxO3S40Oi0ifuPj4eqPbPh5DNtSJm7E8xTpbP9r7j1LclZGv3YGPNfluWAUE/BhMIcA61r0QhhVpvvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774904791; c=relaxed/simple;
	bh=ETx3ONTpYLjEwkGKtJD5wt7XIJqQ4TIjo2Oqupa26ks=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qEq9XBjK9Z9pqUGjnvY02O48tPV6PHLKtx1sWMqc7EhbAr7aCMJS8tVmmQsXs4MUi88dlq2Sm4XbBwRQRKzzmbj0xIJZ0QfcQZaFFL5BH1rLELYXewuHwvz0XSgvmQTqs3+kVySvzaB9OMgrPK3VZ/MGT2sO4aU+EHweQP9uzHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rw7Gghe3; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rw7Gghe3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774904789; x=1806440789;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ETx3ONTpYLjEwkGKtJD5wt7XIJqQ4TIjo2Oqupa26ks=;
  b=Rw7Gghe3QeRoLIKfO5vT/5J+7+q9jxdbh1WJQC09FMYd2rCCp+yS2KnK
   G9ASvaEnnlSNB9Hf0rlLWtOhaILcCszZbCulrJ3xuhthFoW9jzkn5xsJL
   8FEB9lYuCeENBmXioMkXqJwnidoJuFLIQAoSfG3+3Eg/pln2W65iFYCsv
   3F0+ugnM6nwUY5J9J85H2B3sZG8ScXF9KLOPplGWlW6jq7bOkzgLdP47q
   wX8TQcF55v6IeSEvKOtHFE3oEVflSznxYf3gxqGV2JUITQsXF5CJ9fhb6
   OAKaT1UAOpW8AdqFUGeb+f6B2Z5UnIac7K6HQmV8ipXqA8YDIUzbLtDU8
   w==;
X-CSE-ConnectionGUID: Koew2rEnRNWSxnlegp8adQ==
X-CSE-MsgGUID: vd4tqMD5QfSCM/CReQcVWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79809197"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="79809197"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:06:29 -0700
X-CSE-ConnectionGUID: MwdC4V4cT7qdusN+yCs+7Q==
X-CSE-MsgGUID: ZcpEprQoS06mArqfB2tBoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225179032"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:06:28 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 14:06:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 14:06:27 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.57) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 14:06:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2T1u/ufh0vcccpvi/+g8FeIJtZgeAv9MsaYVDpo7i7SrfZtwm8IU16EIUJ7+MxUQ0n+Fd4nM7CJNSqPCnrBQ2b0/L6kBN5g2O4Gyhe3XyoWX2XkyqO5YzoWY/NVVquWg88J0yb78jnQ+LZ3NmhBcCKHbGz3i4eizZNesDThdqDjKIMXHnHhOzGfIJcYeKZ6QVD7O1qdGaxiIxlXxJQGrj7OG742lL67ih3V0LCNkDTa4CgNJxof7cLYFgUyDAeyncHthM263KbhrbbDGB9wjkDv2Q7+aDbPhOxjSudkLCRtYcZMZS8ejyUWBxbSue0QbbBtOIBgokET9N2ulStU4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JN/z2snD57P5fOfpjIWpXFl2KIjMeQhHIGk39+BJaM=;
 b=hCdGNsEJmgxqMbwnIb5ijW2lboiB2oiuXv7LzQ0XE6ozmLN8RGF6pgjKTzQXBfM21CCkSzzOb+DaryaceevqEPrxf6S+y7Z3ToV8MkxHF+8cGRe2z6RkDZv1S5RQznutImxM4RtGAih+x7RNhzLk8ntNkynBzDrjC5Owpmv2RG4Z+d4v1Ax19thLcvoyN99Immod5CcszW0PEU9ISV+gdjoXwSclsFHP2+RmE4hlTotQIfWT5jXIjaEvcMViFm3b+vniBW0PbMFWmY0XMgYFL1lZmdEak8/pXQ1myVIg8grbTna3Q7pAonLGSBPKDL076Lv+7FSgZhW6vrtiDL/Z6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW6PR11MB8337.namprd11.prod.outlook.com
 (2603:10b6:303:248::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Mon, 30 Mar
 2026 21:06:24 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Mon, 30 Mar 2026
 21:06:24 +0000
Date: Mon, 30 Mar 2026 16:10:17 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 2/9] dax/cxl: Fix HMEM dependencies
Message-ID: <69cae6b941f04_17924f100ce@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-3-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-3-dan.j.williams@intel.com>
X-ClientProxiedBy: MW3PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:303:2a::27) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW6PR11MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: ae819e66-2517-4ef8-9969-08de8ea0332e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: wz27BSjuXH8Q+ISC7ThaLIyjcNqwx+Gv4PzHmBGgxIy3PFU7Ycg0KPjcI2UmE9Dbn8bZpLDsEH5R9IIPA63wdpnvYSMZtWxAXf9Q4vm344k8uK7hssg6z3qtXJhqktLvlw15De030dnSBJOdmtF9m5z4UU8XdXb0KldbwFERxoo2Pv14ye92a4yGQO6C8oK49KO2IJMZ9VEnvzDCYR0KU1eHtyOXdKE6UW5X8b1zkHupoRk+y2wg0qrhDyKjDF7+SH5jjYltyU/BVHvkZrJhED+M1TE4hVJtJfsfyeY2S4iwHHJn7YJzz0b1vhUE9og4MyLn0HeOM8mGTnI6Ne2fg7xgXnFShxRn3qeO0tPoHcrxa+L8unLP8X/fzEtDILMgXwywgvUfG/Mk3mo4sr14IjjibaMQEcxth5nnR0u8nVBZ9ysL2nLwENZH8dnRAp8Upmd88ixL4JbvLqHKiuBZvfYKq88lFYue1F03yENk9DbTnkbDvIthix0v7yG6eFwXSJk+QrzCmKt+5aOXoMFXgdtVOXStXBXMrPReWbf83W7TNBNZkP6hwST3TPcZx/iOgF8QG0qA9AjHwDhbQvZbd7HmMg/F/JK3QlfCZAk9TZQ9csRozKB8sMvMgEtcphu8orZqlhBTfSR9QqaQEn+hNrJajpVVEKbR67OoyfHi0ofuiAuGWYLAvT0YBwOgLQfDWz81HXwC/eBR4G4/MBc5aVrOoVzMYTeJNh26au4KvHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i8dmznitf40icqfv2pRPg7XiQD2AHr1FFlxGTY3EzzC4nW3Nb0H9Wrmzefby?=
 =?us-ascii?Q?B5BLHtVNgB+hY2xmx00KHndM9kKOJiOmarmh6JAejyE697D4mNmEFFjIXnqW?=
 =?us-ascii?Q?kVI0nqRHb79Rw0rZjsqvOeENU4b/Qbn9GudxZt82Pov23L43Ilz1o5pklnY/?=
 =?us-ascii?Q?AKYgvlq46V1uqTBZtzbGvHvRl0+5g/Y/0cLGjmiJ56CR5ICCRGUszZ//v741?=
 =?us-ascii?Q?YKOc/JP2K1bvr+t5dp/44kGX9cZG2jHynvEv33gv+lGkiZzwQs8j1ZEhEp23?=
 =?us-ascii?Q?SgQtE4fSIVtkAEPgDUtZKs/dPyjmAMGtcccpr5BBMbu/3bxd4sqEVjyn/EfF?=
 =?us-ascii?Q?TQ7h2O4OXuYXNfFZuXkyik8seff0ScJsmnJgBKxPbxR5f+kofU7bVFBd2qHn?=
 =?us-ascii?Q?9fMDotymKh3n4vRmYvp5CLL6yspr8m0MJC7cEx/hHz6SNj1a3F6AF+SuFWy1?=
 =?us-ascii?Q?TmTM5lzXMk4cneky5e0V+TFVb68hTKNtPQBo5pfu7AriSucAIdkigM1PB5e2?=
 =?us-ascii?Q?Sxq4XumPpjagyw9bxG/JDNUAUohgmxSd88BugH+txh4V+GJba+PbEYpPxIWX?=
 =?us-ascii?Q?+DrcDUD9QKmrAVDoiHi0Y9RvyUckxw1l/DG1nqUboz/jRaP/x+ZkFWJJCVGU?=
 =?us-ascii?Q?22RIxyRdyh5s/TROT8jrH1tIFhyimljLJx7/4MpN4tjDyAeqnjMPMtpyKoYF?=
 =?us-ascii?Q?yGyU32s58nASH4LJFWHUOSjbnQOIfeEp4LKeJPQ9BpGHo/nwWeFwD/LW9XmO?=
 =?us-ascii?Q?3gwPBDV5e9mCkFVzx3IybScLqfqFl2ioB7FQxJ4n6KaVvdX8o8+XuOTUCOrn?=
 =?us-ascii?Q?wf7qTjgYfufzpavA5/r9HWkOm9SDs4ML5Vm8W/p894Kbgx5m05C2bCMDkhN6?=
 =?us-ascii?Q?Ppr/E5/7Ht4pUTYMdns4we+rC6paLD5fI1+zMZcBe4dTDiw8baWg2HwBO7S/?=
 =?us-ascii?Q?pcKYDXHZS+ja/e3Zn/EzkJWo5GT7cBC8nHde/7xYw4Z4nWYoJU72lHZeHL8X?=
 =?us-ascii?Q?EnApwb/oeHpueCZ3+aGq4+VzZg7peTq6LjdtQC2443WSVnfqOhjWMARgAZ7D?=
 =?us-ascii?Q?ALNsnDIAh2hBkHL4wsxr7XQKXx68oC3TCP9OrGzcUus9zF9X/358KN246uUB?=
 =?us-ascii?Q?Z/j6ZoFW8Z3Uso5wy2jIyxPUmrblhnM82sUqQFKeT7OgiyQt0oVHsRuWR2RE?=
 =?us-ascii?Q?gMyL+YPJubZN5A1ui3HYyS2dyiO0clqa++aXmnU95YRWEWHvaTO0Gk0ksqm4?=
 =?us-ascii?Q?EHJ1gzPbNclz0qw59+ShmzQp3JAmr9M8E4yYBMi4dcV7u5oCdfxPW938kW4A?=
 =?us-ascii?Q?mbef9i0uXGc9Ko4axxSQJSIlyEo8rUJ2WFK4ScnsmCtzV847+t5ElUcS+Nmf?=
 =?us-ascii?Q?QigTt+M6ffXQFt4SVBXzKfELGwI9jCAdh+S+8ka8XyiCFxe+M1+fuaUd2OLW?=
 =?us-ascii?Q?53zuerwrKaiX8ZmwD4zyuhpj6NbD4wDMGDst+rbb8TW9AAdFSCiW8JN9/FS9?=
 =?us-ascii?Q?jjBtveBnc5E9Bql8OuH3FY9ZYf8/ii2qigxeiqTneC6bEprZDtbsq6X9YpWh?=
 =?us-ascii?Q?jwfrAx+kkJ4OH1YGRVWCN4UrYXNKcodwlO8MScdQQ3RUSS0IQs7QAFfoIs39?=
 =?us-ascii?Q?nrs6wrfV8KdMf08xbjaknC2QstxhxqPfXvJsct4dUor3IX3bFAX5TTp1xp9n?=
 =?us-ascii?Q?4hlaqLNJ0WGmej+o7prDfSwS75cwOW3KwFOFLFY03NhZJrIphjZ2Z0BWDwdQ?=
 =?us-ascii?Q?ddQ3JV+1XA=3D=3D?=
X-Exchange-RoutingPolicyChecked: m2sK/gSvVkwGMvuwxgwJncMxfIFOdjwCk2OvEga7gewC3YRPsZTgURhc1VeTttY4uWLy01NYgXgLeSom+bv2Vpa+sfGPfzSGGxej9dKtPK+KjBO0XHPkbht0ThimxY91JxIDocnI+BzamCsdmCpNJ7SYGyZ72gAXR+isabACb1YloHFscX1wU6sQYgtNrQdmp5ZgyXu0U+JQ2E3bF38qQWnC568K+SDLbe6xWlNE/esaB593tloWd2GzQlbpvyxC1/fHg1w3NzLw3D8+8SVKt/VRkeFHR+vbYjdCduEzwMoINlcyt71We/oRZr1qiSk07WGGpZTDpZ9XwtuScg1nWw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ae819e66-2517-4ef8-9969-08de8ea0332e
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 21:06:23.9684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ab2zoTg+vZlFfjPnpkZTMjAdm9VCNLQi5rGDBEE71EbL0S4ilgMeLS8MDi+ir44BeLXASB6KZPIrZ5d8PBpdnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8337
X-OriginatorOrg: intel.com

Dan Williams wrote:
> The expectation is that DEV_DAX_HMEM=y should be disallowed if any of
> CXL_ACPI, or CXL_PCI are set =m. Also DEV_DAX_CXL=y should be disallowed if
> DEV_DAX_HMEM=m. Use "$config || !$config" syntax for each dependency.
> Otherwise, the invalid DEV_DAX_HMEM=m && DEV_DAX_CXL=y configuration is
> allowed.
> 
> Lastly, dax_hmem depends on the availability of the
> cxl_region_contains_resource() symbol published by the cxl_core.ko module.
> So, also prevent DEV_DAX_HMEM from being built-in when the cxl_core module
> is not built-in.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
