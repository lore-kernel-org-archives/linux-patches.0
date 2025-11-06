Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB683C38
	for <patches@lists.linux.dev>; Thu,  6 Nov 2025 02:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762396081; cv=fail; b=pY0ZL65qJQxyaOQqrUWbFmi0vxB1g1PX8s0ME3GOYTJ+fN1AzWPX3AfvY4usgc29dQlD/OQq7v+25S3L9wLpX+xKiUi9ODC0FdhMSmxfHnMntGx/tBoPzB6VNgdNULTyro6gw5ZLrdn0M9zd4ZKrvj2jELm+dT674bvrV0czrR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762396081; c=relaxed/simple;
	bh=0EaKYgcmwi7iC9+DxJG33aitCClxjGGUMEJCL4u7pFU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rPSoinu4pC9KqUNWULShesffjMETtiCSQtVBrthv61yP9G2W4ZedRw2jFvGnPBxzibjnbTKtJIs+ho79CWM3jAuaHoJYmI5bmAlJ1je9KKchMzz/H7L5Di59ULVHDSyGGtXkzeOALNswtwn/yOKTZ17kweSUJYKKRWxgN48n5V0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JldGYPOn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JldGYPOn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762396080; x=1793932080;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0EaKYgcmwi7iC9+DxJG33aitCClxjGGUMEJCL4u7pFU=;
  b=JldGYPOnY4QFA9q57SNo5Il92z9WaFGdIltrIidFGgr0yT1QmsSKzccf
   pjYDeQEAw+v43nzngQZj4a8OGgQwIaGebBNIKHlR11GawIYICxtLexvdk
   bB1GCPN53cy9nDI2SC/Xcwg+Ei9GYoE/LUwBwYQlewO6JhDf6XWTTa6VK
   Q3wJiNSPR97JnHScQuo+BCGpoO6aDRPtcfBlJUJ6Z8Zp8d9zA51TTeKvh
   ZkjU/fI3prmrNuczh+dggAONMQBwtnQqGHe5TJVcd5btCyTxpvW9auVRm
   TfF9nUquRIbOvPBhL9m68lTV7mzKCo4O/Umjh3AJAXC48RbJEwJbzkEN7
   Q==;
X-CSE-ConnectionGUID: uEPq6a11Q8CUeDbxhP/2HA==
X-CSE-MsgGUID: mYPro9AOSHWuztnv817k6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="68385168"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="68385168"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 18:27:59 -0800
X-CSE-ConnectionGUID: byx/l9fRSMm73rsPU52SUw==
X-CSE-MsgGUID: fKFnFs4qRlOJ7BocAFiBig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="224877522"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 18:27:59 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 18:27:58 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 18:27:58 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 18:27:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykWJvgdeYbMbehsmkCEMP5mCthWzADJiCKQR/Ks7bdMu5jsDy2ci917YHU3GfMM6MV/C2ULpoLmK4SAmSi5KBPaQeje4gRzV8sJNF1dYy7YaWqtzyenljhApwYc/kFQX1x0Lwv6LHjhngms3KB137Z/sC8HTsDSCRKxl6diwSWOlKjoY8zM4D0hdIqUNyrXqmRjhrkBoTYv6iuN2gwtzJKenjs4j3PmWmAwitWAfAjD/zLBzjW/VQcAx/dcpHjL3BCk0ew93Shp3j0SbwH76m+lxt1eUF2py8da7vMR6homOdCvg+jc+Mvo26L84zdgfctgNa3UApdzlv5nAlmhezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovaJVYcFMh+LzdnFieGkq0u7+w5jUli4CuTiIkJuNFY=;
 b=fnBnY+K3WoOJAcwYciUwGqY+LiBO4uORhHy12vOHwTn3UTAoSwRIcjJ5oD1pJftj9nZSu1th+E6qxN1dgjIsZUBkQjCouR6J6q19qVbeU310YRl9sD3tXSSzkFhaXSGQkvTYz1Nr8C3LrqFTbSpfHG0rVKOqU/MVQPiSb7jpDQJic1KPNrt3yNhWZOCxnyzHtm/Up23KRS/escwXZrWS31nQO8tIOkLdP5iajCblXAYJPEh1CsXwUob0Gox22uOK0QNdJxgiIDpC/9s+l3F0k2qwcgFeBupWHh0plzPqs0xRWDLeAmn25l7L5duQyAvzb+9T7j59kwKuhzZmd3QAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ2PR11MB7716.namprd11.prod.outlook.com (2603:10b6:a03:4f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 02:27:50 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9298.007; Thu, 6 Nov 2025
 02:27:50 +0000
Date: Wed, 5 Nov 2025 18:27:48 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Dave Martin <Dave.Martin@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aQwHpFEfHGpoaVW9@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aQveOz66Pd3R0FfI@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQveOz66Pd3R0FfI@agluck-desk3>
X-ClientProxiedBy: SJ0PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:a03:338::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ2PR11MB7716:EE_
X-MS-Office365-Filtering-Correlation-Id: cef510f5-d220-44cf-d716-08de1cdc147e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ek5MMP374X5gaesHqugdCcfwlS3w0a61yOMimiWuATTFwQ18cbpgmiSaVQI0?=
 =?us-ascii?Q?j7VGRD6FV2wtxuFpb0j7vlyTwklqEKBup4A1Jfu6wB6UWZUqx/SwVSzGXoq5?=
 =?us-ascii?Q?ELgxMMtsz4ZEQNBhyBoyr4qmuritBKlSxq924FTWy4WnTexKHf6thk81Xg0f?=
 =?us-ascii?Q?8xqiRW3KfR8HmHqCBRPKdlV/PBVBo1TQHHJ/VPONgL6TtdBjUKYdJ4C7tyio?=
 =?us-ascii?Q?m7bEtCRbsF6y3G8PHJ3Ojp0oTnojS1THRh9EPAtJ69Ou54OYm2m6x6govbWA?=
 =?us-ascii?Q?f9iKI+nYlZk61Xk1uMObPpG/xEXrdv7RUcEn0mLW0iKz6K2VKjYSEb574gX6?=
 =?us-ascii?Q?4YKnzhnPFWH+YyL85MZ6ktOPGevVlef3hheMYvYSXUNB0eFMG06PLJS97/xr?=
 =?us-ascii?Q?h3iEF0VYgoX0Ye71AIe6x2ef0B63N59GyDS0FIAeudqj64na/Tsnm05ColvV?=
 =?us-ascii?Q?KeK/JXiOvPv2hThQF6n+eo/NuIZ25OZdHIB9iHh+RXZIWcAbypRioHewILWC?=
 =?us-ascii?Q?ngkz8EH0s0LyOgxkGxQFKGIAvvpl1ZGN/XSeu7lFeQisOQnhqctQyb9TrkHR?=
 =?us-ascii?Q?mAiLru63nG7k0wrYG+uPU4hSPK7HkDylAdSuxI8VXEZ6ZBHQM83jAlXY8hVu?=
 =?us-ascii?Q?NCh4NonaiRn5q4XdlbyF4tDemkVVA/bn++PbhfaBc9gt14ul8iNzIKmO+U+n?=
 =?us-ascii?Q?uhbYmHuEa+eH8AMo0gjhAhlXtyY2MzRH43NZ5rgH903QCdY04YfrUkbu/LHn?=
 =?us-ascii?Q?5E5yCqvGgtSdH80gAdaQgsdJRYrD5JndfNdXmljeYZ2b9m6z9yBSwgOlmiq1?=
 =?us-ascii?Q?/vq5p2ROY93FBePOji4ZXx3M/YtM+ReC+Yt93AWj7y1IcrxwyRMuA+DOsuxD?=
 =?us-ascii?Q?esjoz7jdfrne72dgoRr0NOl6En03JTKJo2KSn62Vpjv66f3jilUFSfrMFszJ?=
 =?us-ascii?Q?AHPy8zIC0Adxo3utAAJt7UYMJ7BAdXhnpjJi6aKs/KNwQvGVf3KFFJQP4E5T?=
 =?us-ascii?Q?SIabW40hFWnx5EjhhT4OTatC0m5Z5QgaOGOExr2vqpsBYSq+RaIXExPrDsB9?=
 =?us-ascii?Q?ra1z6TpYpIsysQU8+n384LM/SjoOwKLaiBMiMcs6MTos8E2AHongJ9Ex/7XS?=
 =?us-ascii?Q?lgx52vLxE+S9rFcj8fnRrKZcFYADzwVwy6kjEggUJKzRbhoLE3veekh91nmu?=
 =?us-ascii?Q?6W6UMOMAQ4EPLSJWGCO8wIwLuUsjhbb42OIbwS+96Ko5EDO903rO7X4oNOM+?=
 =?us-ascii?Q?+j8BZzkBksuA246vhurKg1++O1UL63OY1mB3bbVhbDiBALSAJsQiNGfTJD+5?=
 =?us-ascii?Q?zu8ZZaw4zwqIw9h4tLz3ScMERQTg63B+aancHK8ZEc/z2hH+ncYgAy/0KOyo?=
 =?us-ascii?Q?plmEPB4S8xLcdTfIliIeAUYM6jB4UChgt230OqKDcOhdyGAIHnXlHi2NOgHR?=
 =?us-ascii?Q?uwJ/Mc28BunNFNUW0p1j0KE5M2rdUIG7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zSulxeyPZMghgj5997Q3v0JJtBJsGFmAZ0ZXk4o2zP703dF26QdtOrxZyadV?=
 =?us-ascii?Q?6jqXMwtgE53xMYXBgJ8H1gJNzSVRUigCiJUpQa6ROAy/ih1jl1Se6vtuBFuD?=
 =?us-ascii?Q?OJD8W/OlEVMyE6KlLhlcmfSsztxUtC2wtJLW5ewyq/NQAF2Xw6Ox8+UBBR0k?=
 =?us-ascii?Q?OwHojGwSK3x0Gc8f7BYlX4efspS6qVx/j++BJyOUp5bIqqJLMhHxupNLcEis?=
 =?us-ascii?Q?W+vZ4j79SS9fSCdd17Um4KwwUHA+5pJvJciSffw9NZ6Zq6zeHzKMC0nGcXDt?=
 =?us-ascii?Q?mNrpD5v+A3ULQUDp4cQh4G2IwEwE4Jo0wpwIIj+OnxHTpstHgbaH4po7t3Wd?=
 =?us-ascii?Q?U89gqkjt0G10CQh4fz57kAqV12+NXq20xT5YC4Nwipnwo7FH2bq9eFR9Mvsm?=
 =?us-ascii?Q?uPa33egHCaC6az+64QS2kLAAWdcOsBRH7XcKBrcRHABi7gPsPR9miSHTwhtt?=
 =?us-ascii?Q?6pAf04FnhWJlNjnmw6+GGkERQf4VH9hJBGWVZDTCcqZ4WJ7jUia3nPXYcFdq?=
 =?us-ascii?Q?k/8yheNUAU52jYT99lroUHQZ1ukHDOPyDFEfAhMM0twnxs773m9lCwWemF0I?=
 =?us-ascii?Q?8ZEJOltGeXI0dolWe6vHyIku6RvNMoothRh4ogQ/YV3S66baJmgSrQplONhN?=
 =?us-ascii?Q?J8d3qxlBU6H2bNoSiqSbXobherpBmgw4+wNdQoDDT5UtXOajIx6z3dvbGLye?=
 =?us-ascii?Q?P7GJOlzwHP6wb9gaqVtFG5NtC1uvIkk6b94IK6M23ftWAZf60jpTVpcft2hb?=
 =?us-ascii?Q?VHQWw3W3Ux7W9LaJfShoMst4/rchtG6dAXoIxgGm2NUtFO0v7RpZTn/lTyke?=
 =?us-ascii?Q?e6YIYI8Eml4pYoMD+Cr9v4S2OnPt4qdBZIlzVsZfzmtAU53+R85FDmDHEZCM?=
 =?us-ascii?Q?L4ap7tPjwl93VLCuPbU8n/tJ99Io9Xx1KW4jV/Af+LaGGpd+r/CFHuJSOIHz?=
 =?us-ascii?Q?0fhpuTYs7s3rkhvge3LKTOJpziR5ELBV2QP+tJpc7+w+Lv1GONemMqQXA8vi?=
 =?us-ascii?Q?HIYXZm+xXy3oYbJzEX0niHx7QjTQKQl72s6iQMqPcwwujQvsRR4iWBDMDqi8?=
 =?us-ascii?Q?fOOQT97K/KdUzIa3GCxodZIOLaEejfbkXnhTbFQVPMn+K8tpbipyr6pl5WK+?=
 =?us-ascii?Q?r8rFOA3hed3aULTdZCxWkvSnG51WF9S+VhjF5Ra1U/kJ3Z49/CP9utU77sJn?=
 =?us-ascii?Q?7CldJ8HYG+8gOj7J4dPEXa28D6IsWTdyXxHeH3yjdDpHMRT9NVz3RIJKPnfw?=
 =?us-ascii?Q?cbWokGRJDNlpdTOiv18BlcWe3bNCNwa++p1XCuQpicKI1gXel1YemxElcM6o?=
 =?us-ascii?Q?aGCshP4SJ74mBprHtqnySxWLSKSFp9wP6KSy98IMBA6kAnptXQxOQC1LNq3Q?=
 =?us-ascii?Q?aCEBLOodnZI/xgJXwUmNn+0PKhZ/z9abaHD45f2Jvs8WVD4aH5GJSYFGif4H?=
 =?us-ascii?Q?IESm05dR8HhT1NaBYwVjAnuQFQcC8MUpUoL1mmCZHCy36bHqL/OsAfUKW+eX?=
 =?us-ascii?Q?VBgtMqkv4Ac/O1G7ZB304NF2ysMIAVagSMTnBST7fEQRXOOa8RY2lmNx+cid?=
 =?us-ascii?Q?jI3BmbwzezStqTJTbF2UVk4HX73gkB4dBmccEAJN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cef510f5-d220-44cf-d716-08de1cdc147e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 02:27:50.0034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0g+TpDrGNryVu0uWQV+Fy1w1g+A2aM43DTTKM9JupCs87ngssBROmOZvWiXMtH933YXg26FREebENbG0xtcg5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7716
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 03:31:07PM -0800, Luck, Tony wrote:
> > > +
> > > +	if (!binary_bits) {
> > > +		seq_printf(m, "%llu.0\n", val);
> > > +		return;
> > > +	}

I can't completely escape a test for !binary_bits. Most of the
flow works ok (doing nothing, working towards frac == 0 when
it comes time for the snprintf()).

But the round-up code:

	frac += 1ull << (binary_bits - 1);

goes badly wrong if binary_bits == 0.

I could write it like this:


static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
{
	char buf[decplaces[MAX_BINARY_BITS] + 1];
	unsigned long long frac = 0;

	if (binary_bits) {
		/* Mask off the integer part of the fixed-point value. */
		frac = val & GENMASK_ULL(binary_bits - 1, 0);

		/*
		 * Multiply by 10^{desired decimal places}. The integer part of
		 * the fixed point value is now almost what is needed.
		 */
		frac *= int_pow(10ull, decplaces[binary_bits]);

		/*
		 * Round to nearest by adding a value that would be a "1" in the
		 * binary_bits + 1 place.  Integer part of fixed point value is
		 * now the needed value.
		 */
		frac += 1ull << (binary_bits - 1);

		/*
		 * Extract the integer part of the value. This is the decimal
		 * representation of the original fixed-point fractional value.
		 */
		frac >>= binary_bits;
	}

	/*
	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
	 * representation will fit into chosen number of decimal places.
	 */
	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);

	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
}

-Tony
