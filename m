Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825DD2FD1CA
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108405; cv=fail; b=Zo09NG3mIuoCAabLdKz+Pbs1jX6X03CUKxIUhSKlRtqPqhflC2DJ5Difve9+Pm4MB/2cRbOhWwIOvB/8UYtsMzw8YOXp9iqiMrOvuVomtQhhJKWdXCebiDQKjliDQGqCrKboarTgvGf0ikFdhB8iZU7lV0eyfNLvh3zVfu+TZwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108405; c=relaxed/simple;
	bh=BOTyFvEMcha0DlRFgtndgUnvtBXsdil473wcrzFls2w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hzlqu/pcIxvPZuuYTwG0NVoGgiSi1m6PmcO4quEAvZ0iLT3+zUnGPeArVF9WyU9JOSam5Gb/6mkY09TG9kR9aCMzwrilvvqtACM4VFWgGHkThYNrAYjTN6NQN5Pm8esa5Qz0aI1jptlB3eGlNoPA0TSisgLlCx4SGjWxH4afV6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZIHK3HgO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZIHK3HgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781108404; x=1812644404;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BOTyFvEMcha0DlRFgtndgUnvtBXsdil473wcrzFls2w=;
  b=ZIHK3HgOHFqch0F0VlZYaJkMabGKe2zus/39P5BUaWOjzN2pleoVprUP
   +zZB8cR8VZ5DqnJ0RXnE0ZUtgC7Sa/iwC0K3v1ULD3I+i3i/+2xQQrG1l
   p7qDiFViIc0A5AqF7Gcg4qIP306BuyZ5TUjvuFWR4cKXrfYPxmrFyoKJY
   4XhELkQfLO9uux391adM3S1GJPD+AdE84f4ODV2idoPZYZYt58SL7zF7j
   kftvbxy5et9A4OMysRgUvjsF30k7aY2dv2dLKt566nk44TK6/zoSJ2Djt
   /Lv9KDQDRwu6arodnZ9baVI2enmQjyZ01IVjxQRDdLy/lDc/jlwUMmYDZ
   Q==;
X-CSE-ConnectionGUID: +tc6Zw1tTI2AdevzezubsQ==
X-CSE-MsgGUID: PHWcdLrqSqmfcVyKctq57A==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81754803"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81754803"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:20:03 -0700
X-CSE-ConnectionGUID: TlMbiZwrSDSMRzsMa+bQ1g==
X-CSE-MsgGUID: A3qs+RwMSGOmvLGe9xlRsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="270218037"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:20:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:20:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 09:20:01 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.22) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:20:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YoOOfyWrwPd2qx24LfSUNA1bpozdwoC9TP6KTgONvXhxkX5y2uHqIqN7HpgOFzYEhGEbOhwXcMbrfkxI23DF4uJwgGDEHeiTsQ0ZKjOZKbBOpg2YUrkKrvSq7r/2c2auLcYK7da08CbwOckhMx7uyr57Yf4r5RF20HkglkVkOW1T4C+zFC6BubOuGRglioV/HnbY1Qky5b9eXiOwNbbmeUerBIBzGh3zHqMS5X6JaOV5cMmofv190Z5UOgEn4ohhC7R143zRLsr9gwTf3RToKVZLmPxQ94mxtl1CPH5eWIqRTgwLvkckW4pTYXGKt+GTxrbefopnBmbz4R2tkSFD+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qjQZayUY15UOLSGFLBZSsnni+x1X/f7IE8vaR5TM80=;
 b=C+iV8ZBogCqNs/BwVKTS1Z907/V8JYjbs4oCjzkfCWYNrntMrHpRD56IF0VxI3MFT1PWRkTOvfqZEcTH7qh4VSeoQfMNoNJM/iStkPfKMn9k4Tq9Y9ePikXiCeHyQ35mwDu1D0M3yVTNLXRQ4ViST72/NBQvkI0zwwkvPEsQg7pzzKEFAuQdPM+ObJVhe8RItJtFgLqPizVd7PaB3+UL23BzbaXI/VcxQss9+v8DR/7mndycpGIb4VxhdYPcY5t4sIs3n/y8GMKJvZQASDYiUy2TeTyAfPs5E18uvYxf9zDRwj8S8YFw8K084eouGQu3eOc8RQJrvJGqLe2xHCcq/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY5PR11MB6258.namprd11.prod.outlook.com (2603:10b6:930:25::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 16:19:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 16:19:58 +0000
Date: Wed, 10 Jun 2026 09:19:56 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 14/14] Documentation/filesystems/resctrl: Add footnote
 for telemetry fstab mount caveat
Message-ID: <aimOrA_DqYTqKo1V@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-15-tony.luck@intel.com>
 <4121f521-830d-4483-9305-efa31cef0f3f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4121f521-830d-4483-9305-efa31cef0f3f@intel.com>
X-ClientProxiedBy: BY3PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::30) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY5PR11MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ea1cb9-31d4-47cd-6b3d-08dec70c1d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|18002099003|22082099003|3023799007|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: n/ib4M+Lic+r2Wj7iHAbIDvoNj2JSVApvi6nPn21PfGan/prZJkZHlHUYNxqhPQMYXs9iX1baKuCrH1212Y4nnqV8ZfON8jzYQVJuK1aGDPYSg7jjTRuB+Rog4CSfPNCQOUzivwvMI7FeOAKQBGYdlnLOBUve93oMEW6630TMpC6flKi+mSS7cA6IUMdZ3FxUz/P55ubsrD6g3u3tjIbbA7TpD66mLFemtOMwtiSDYfk7eXz542i+IX/xwer5QLuRzxs29beUL6HOBC8NrqxeIaIpOQ6ablLI54SuWcbsgp8TR1TenxzJXa03s9gWTtN0OfBOD5W06pDeRw+YjMHMvpiBVZdwfGRwkFjtJftIapu41P/nAiE42hlWp8gnRV4mXk1NP69vc1xivRudkT4UOjqCrxBVoIzhXlMa7fBXTSRNcEtaqhEHF14ZI+59Qo8WCfVYcP62vV9Dny9/ePW5cu/WhhOIskOcp1+V+Xcjbzj8b45aauNGAUsyEp0+LU84GEfwCUKH3PRWmQyuKFFVzLiaTbTi4d09PN+opKQf+rERf8KXQ3WcURG+GWJK66iHE4H1buL1kCpRWtjKbKXBe1qAmRefbnWHEQShIvdMb0auXcz+GJ1hVEtQug7kLfV5XRBR40XAFlPeuI8zMqkHcr6btHwJebhIIRMvQ5x1Fa2C4WL862h8hOLreyHxl+b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IfxiNSu1p2aI9T+zVWOUYEHoOisRE9ABEgim+0RlmQpPer+D9yuePAv0iA6+?=
 =?us-ascii?Q?GKI8MDcXWB5IN4HpiJepNL5qmDCHMZdTMJjzvGK3h8msuG9Ro4E4sa0cDsxi?=
 =?us-ascii?Q?KVD4xBmIZ8NIEmJvsTRebobOTFr6zBZUh1zYkBY4PgpMfwCTYRHc6Vio/r9S?=
 =?us-ascii?Q?g8JT23Kd1ZNc6eJLUARDGrQvkUOEk8kCVeiSVQMSKBdFqB3imo6fhqK3U/gF?=
 =?us-ascii?Q?80GI+8oAzeSlyy9ZoFspOT1OK6xusZ+cRy5epYeLNc2CntAj+g8IqKv+1nxZ?=
 =?us-ascii?Q?opovdPm+S5xr4R1fmZu7fuf2OHF0S8TEFteQxZPS0YxZ61J74hLBo1DwtAAP?=
 =?us-ascii?Q?ukCFuNw8tu9FOSrDJINqNAA0J1p5xEBzFgrBaAcfRlMS/iTX9a0uk9rHIW+l?=
 =?us-ascii?Q?BoCAEUtpA+TOpHT38Fq/17XhuXz3cijatgA07ksZqLRI9VBJUelXw+9nKgh8?=
 =?us-ascii?Q?lVYXKA0voeEomBcwGjnP3pF2nY/DKvkLj2cpnQ56YkCQfNVWngxGXVY4nr06?=
 =?us-ascii?Q?qOnaNEXDm67zvrIdXpQPXV1t9uSQxUM3ngPudlnqz99coXOKVVvs1JBQ5nrj?=
 =?us-ascii?Q?K7yqJwuQtEsJeiScraiPKn21y4PXpl3LnpbSzubCp8/aDgcQl3W41+srXIrx?=
 =?us-ascii?Q?D7JfJda3Pq7OgsYy6SZHz0ernryLsOlTtJ29hl6XcwLLVqIfBWvPSol5tgMi?=
 =?us-ascii?Q?m6Xn06IjYv8lGIv/5rsJu/A6l+PvOLU7pAPeOjBkGDS98KMYhZAfY1xKbvgV?=
 =?us-ascii?Q?CdoNQvyELmKkhVYZZYPsuMiLd37zwkkDLPeUr130ZRwp0yMLYXUC52W8bt0I?=
 =?us-ascii?Q?Xd2s4eJvbwIn0D+jlAjs2zdm370jjNV+b8elmvlPhF8tvp4PcdND6oDUw0c3?=
 =?us-ascii?Q?nXcpV5ZjEDSwjUXo1uKF0BnHhsxUXtdy1+az1P+2e3DB5oA0Oh+U4MHjV8Y9?=
 =?us-ascii?Q?s/dau82sOAZQAqNV2xjHK5v3Xm1bmPNSAhjGEJMEwcG1C0+/oQW8VRpclM6j?=
 =?us-ascii?Q?vMwbe6d/RJnN/A6uVdFtWl4MKJqgx93vUoH+7SvcltsXCZvB4fiYKGMWjKju?=
 =?us-ascii?Q?RRNpJsmCWGgHy0MNfb4WeFahn7SIclmke6cjg5EC403egB+uzFuieEgVqi7I?=
 =?us-ascii?Q?pCFgGR9BFGnRI1kT9N7YvQpKjLck3B+voL9G0yxKLWSo01xQTT3DvhNSiteu?=
 =?us-ascii?Q?TYl2MD+Sta+uv6EBGZyNnCKV6n0JVEDxP2sHGMsKbkVKOObDhBRqO3wVAbY3?=
 =?us-ascii?Q?qdOgcqHxAJsXTUulfD9zBOKhc2WzDP2ktOg3OwloT5zz1sNIGqOYsX/USPZt?=
 =?us-ascii?Q?72JUxgGiBCe7on5zg3+FAkVfSuli0KOLUw/FWhr8i7UfyaaMce3V5ohDjYgM?=
 =?us-ascii?Q?D+DbUgp/vSNAEEdO6EbYU/XqiAVNUYjkn7OobXwGGPH2LtGIV0Ufc5YWT58V?=
 =?us-ascii?Q?NNDGwRSkpgNLs9et+VoDR3lgdMgMws0Y98GYpIZ/LudWNiIEAl/csfjuB9Ux?=
 =?us-ascii?Q?jfWiGxAt//I0enul0tN8boIjEPFjq5+G7Y9fZVMbYPOoCY/bhN2isHwbWLMv?=
 =?us-ascii?Q?BQ9+qcLNIxTigKNBbVpCZcaZShIJHFIfuahY7m2iK1++2ylna7x1Hb3XHmhs?=
 =?us-ascii?Q?JUY9mDXRP9X1A99aJzyjj3afG05JyjKS+PYCzzQtsn2PIzOzOF5FYE8bLKoA?=
 =?us-ascii?Q?9xtJA8NbU+FAyUCRGDm04NFCDHRxWp+6MmJZZOBMCl84HFsQrPRq6X6lJtTY?=
 =?us-ascii?Q?vvoPcbYQEA=3D=3D?=
X-Exchange-RoutingPolicyChecked: N0LzA4F3GEqCXhWj4wmL8ZW2SHEInwypL8RnMKmC7W1JaojnyI3ILH+ZZzQqfggjD7ZRsgzFiXun/KTjeTIUbjYzRaS6WWgd+pPGdJAgegq1Z5Gceu1DX8Odd8sQ/PniQgOBCFEZvKsUIUti4nZ5ZBmrXLRI0fEBu/Yc1p5ha2H/WgpT1AJgyaiL29RRNgTihdbpo/BUbWfeIdmv9p9q1n5yErYLNmjKjy6hOeHlCIU1+Aho+73s47CmMKdQBaX7zFgIOGH9j1mHt4AW6HDvgBG4eoH+PZwkK2+qTQikwUSJIWY+kesJ2KDz8FGUscQWp3E1XzNFXRaKyqLDlZ7aPA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ea1cb9-31d4-47cd-6b3d-08dec70c1d78
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 16:19:58.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaDfBhjPTzYQq8LkjTxgEXAAay74VHFQUrF3ldfRA7zbZFHCciTN6arEIcHAVGmyVPj0k7ymNPr2WU3YqydMaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6258
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:26:36PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > Add a footnote to the 'If telemetry monitoring is enabled' sentence noting
> > that because PMT driver enumerates telemetry features asynchronously, an
> > automatic mount of resctrl from /etc/fstab at boot may occur before those
> > features are available, resulting in them not being enabled.
> > 
> > Assisted-by: Claude:Sonnet_4.6
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  Documentation/filesystems/resctrl.rst | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> > index b003bed339fd..4e62b8c5e0d6 100644
> > --- a/Documentation/filesystems/resctrl.rst
> > +++ b/Documentation/filesystems/resctrl.rst
> > @@ -620,7 +620,7 @@ When monitoring is enabled all MON groups will also contain:
> >  	each instance of an L3 cache. Each directory contains files for the enabled
> >  	L3 events (e.g. "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes").
> >  
> > -	If telemetry monitoring is enabled, there will be a "mon_PERF_PKG_YY"
> > +	If telemetry monitoring is enabled [#]_, there will be a "mon_PERF_PKG_YY"
> >  	directory for each physical processor package. Each directory contains
> >  	files for the enabled telemetry events (e.g. "core_energy". "activity",
> >  	"uops_retired", etc.)
> > @@ -659,6 +659,11 @@ When monitoring is enabled all MON groups will also contain:
> >  	returned if the MBM event does not have an assigned counter in the
> >  	CTRL_MON group nor in any of its associated MON groups.
> >  
> > +.. [#] Telemetry features are enumerated asynchronously by the PMT driver. If
> > +   resctrl is automatically mounted from ``/etc/fstab`` at boot, the telemetry
> > +   features may not yet be available at mount time and will therefore not be
> > +   enabled.
> 
> Would it be helpful to add a snippet that explains that in this scenario telemetry
> features could be enabled on resctrl remount?

Yes. I will add.

> 
> > +
> >  "mon_hw_id":
> >  	Available only with debug option. The identifier used by hardware
> >  	for the monitor group. On x86 this is the RMID.
> 
> Reinette

-Tony
