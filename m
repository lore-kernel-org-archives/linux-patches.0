Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5853F1D61B7
	for <patches@lists.linux.dev>; Fri, 12 Jun 2026 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781287482; cv=fail; b=d5vqXBK2CBOn+GGs+sVgmGEHI0ZSnrafxVwEDdlWmGBcQHERmZ1whBNKaDVFqMaWvzun6F58ZbYnuNPgrO02IMc5e211fnPUFUi0ZN8XkZ+pPh+4sAdiOJtVXGCHpHF5hVwUH+ZnBs4yrf9l1fWyL84sAPRfdV/bOQo2qmFd+Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781287482; c=relaxed/simple;
	bh=pho3pmFi0uX2PlUSYDsB8esBxnjw076D7HbUA88V52k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kyzhl4DK4Zjh0GQU2U9bRJWdyWP0htXXB/LG3+s5HTr4miNjIdFoHjiS9hxy+y652fhgGL8hA5uTKtZPctNi1smD3+5WsMJiUTaxDydCerOtFO/fP3Wgf7/8VaEZPSANjeH3Prx8RaH47mzfHf55ZEvH3fCWJ7Iyzyq/39i31Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZTLMB/9m; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZTLMB/9m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781287481; x=1812823481;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pho3pmFi0uX2PlUSYDsB8esBxnjw076D7HbUA88V52k=;
  b=ZTLMB/9mZWFAII6qjLHqQ1fGBYGi0VRQ4X9G47ayUHhhpc9Wffp+8Bwi
   uPgMCXoTKP0AAYyQG5U940jqOeU8QeSpQfQJvLDAzGyw7sfiboJ7qJAjJ
   aZ4m96oSF2CvenB3RrODp6RSHSQoBKksh2ekz0aNKwlyKpgBFrGC+MezK
   Qvf1yVX8g0UdUUVY6DhaWVk8plY1Jmewb7cSghF85M3CRcc/YHtFqwuHO
   wTOwE8+QXZNPD+Oa7zaVB/EDIyUTflyLhTO3vFWw7/TZ2g6Trh3fx8XBi
   nZ10/VE2xtYDN2IA6c7y9r4gczdEjS2evNX0XaeI4669EMl/oGEGSnwrA
   w==;
X-CSE-ConnectionGUID: DKFmLC4eQhmKv2t0M2oMjA==
X-CSE-MsgGUID: eGgZfksGS5CK8C2rzKpLlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="93617096"
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="93617096"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 11:04:40 -0700
X-CSE-ConnectionGUID: 2ED7RN1KSNinjx5yqWtGiw==
X-CSE-MsgGUID: 4m78y8dAST2HeyA1CCkzjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="240536181"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 11:04:39 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 12 Jun 2026 11:04:39 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 12 Jun 2026 11:04:39 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 12 Jun 2026 11:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=POF/8yFZHRaJJKDc0lswmx/IFQJk/+Zl6JZA+A/cTNGIFtBEqraqdF/3AiOtPjKsOfZut5Ta+8sr0TfHkx4IaiU4zw7Uo2HTVLpMr/J+aGuM85DMR6dXTo+nFdHdAuo3ovUqR3QzfYFILlEGumS7KlbTv3O7vWw75i7uc717jkcvENmUmAa8y7SMlfpyUrQNsHFLPHGGzvQ1HPxYvBMwKw1C82HH8DaTnYq4rfVHd2BNx5Ob/3jQgMQMnfiR5OkhSx+yT2C1RSn97i5i8xgmN235OE7WtKzwPU5Eni06zPM0h7lnIRljf9v435j91gdQx6w4a4u7PGDpFGxt0EGlqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvAFQxpix0kVYNECFtcRr7/iHqabUpI8zS1vI0/R+P4=;
 b=kr72x9000xCpf/+fQR5SFVwWqgYuxK3tOFNo4kWwyiSwq+mkbLUpwflVhwKW8sEzCCsx9rYamvFRMMQMmIyCVv+WoLdz7cRObUc1RWQ/UjirJBervi90oMZlTragZl/iQZOiGVZ+d+o7YTYYwn1nJkCcFaPY0dOvK/y/LCEfpX/dHecj3yhQga7sFxb+e6QU5QRLyJn+/h+z0u1gDTAHwvhlALIDANidPgCHQtJWVht36OpLYOcxgyWdt8nnd3zxuz9aee/gRKrdBPlF0SqFJPG2ADKydsu7hxrAie49X+pZSkQeDcSTB9uTVpvkWBhbcB1kX9KPOntdqEjpQmvULA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7035.namprd11.prod.outlook.com (2603:10b6:930:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 18:04:36 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 18:04:36 +0000
Date: Fri, 12 Jun 2026 11:04:34 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <aixKMnsLbeAfrNRb@agluck-desk3>
References: <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
 <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
 <aingld8Hoz-x5MTj@agluck-desk3>
 <air33e4js_onwUik@agluck-desk3>
 <84004bd5-db4d-4abc-a676-6565abf6320d@intel.com>
 <ais2ROlQe9JqsN3w@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ais2ROlQe9JqsN3w@agluck-desk3>
X-ClientProxiedBy: SJ0PR05CA0114.namprd05.prod.outlook.com
 (2603:10b6:a03:334::29) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c19a10-8872-4d97-b8f8-08dec8ad100c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 9xC2Og6JrKMbrFpp83ZJ3Xv9WKZG5uusGTsQYi+IUycJgQpoktTojagoLolN8uTlbg/pf9tcGRyGOSGHUvIPA5mNo18EmvuKVa66LjyiVeM7WmavWSlTYiCXFiIRQHlA9thmR0JrBLcbPsukRaza8g+dC1JjreRSSsLnjd3e0J1b4DADU4uAH4JM+BjJfWNJhM5Ogd5CWFJrDLroW44qOkEPaj56Fdkv1J5B0ZzhFiGYRgrH2rsw0k1DmO0SW5hy5PcjZPNWdSpZrfjR26Thk5MTRpuPDGBQV8U+rbuwpGuxRC3uDbt1dHHHydA19c+OVhVhoYeagZFarpO+6Z/IlQH59Zz4nQMKlzsvz2QWkBB+OlPgfS8Zn2xdAmoj4dMMmb6BWfvvvp9u2qcGH0vXZthWz1GnEZjGcCkpMftDnbn1+wO9TJMgCIsxtRhyo55GyGBuFTQpP/Qi2aZGVewmkveaItdDzLslCmrZDQBze9r2r1dVqZMqEmMpS2noyfHm8vKH8apPqIb6jEUsUA2KWR0sFH/juOZcTsogYhjDLrEeLdex9m4OE7mxA6h17nmDBeSA6C96QkoAdmC57gvbO5AadF6WIKmIJQl9CTvnot6hhzwSJrSZwdP/BKrvcUDCaKItNBgscfZtv6yLhnyX2tAuwGq2h8x1sMAZ2+10kdkbw8VUZwgDkNh8B8CuTbVF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZSXeCcYzY17xGWldSVLoXtpB8JNR5GlhvaXg/NQWioY0voUjY31innvbOBs?=
 =?us-ascii?Q?OOuDH0iE4jeOA3yohcUOa8iq0MaHG5uA3RZtIyred+2V/sdKSW6Nt9yxhpfF?=
 =?us-ascii?Q?6v3PwQSSWnPRLSe8TuHz6wFaHfeo/ldJfSNySfYBi96eUDgtyTYTWFp7UQMd?=
 =?us-ascii?Q?Pm5ol/6Cd1T4OvbvtZ8203t3vn8J+qqjfWyw6mKQE7OVZQmPoLG+EV8ZlY+r?=
 =?us-ascii?Q?+yZKfGxOlEKYI5AFkj2iIWjOkMLxReAIllKvWYRI0x6Mo5h0RW1gDQ4dsONx?=
 =?us-ascii?Q?+G4iGmbpuW++iD8+bfiEoLYZm3yW0iqelfeB41gfZmEwArKysOqbSoMX7EiH?=
 =?us-ascii?Q?W91tOiKkPTCxD5wCk+78A3Bf7GoAwK5Int/G8xdd8/asx3uNgEQjp+h/QH5O?=
 =?us-ascii?Q?/KbynqTzeemK+rEaXz0PS+mXwtEFgux+C8kgMT4z/MgImf3lIwkQOMNEcCjO?=
 =?us-ascii?Q?1sSFMN8LKm3tEHL8PL6ueCCrkwCZIP9O7IJ9PdzY/dlejnAwHaIi2ZKb2rD9?=
 =?us-ascii?Q?O/NcQp9CYO94WbZr7YzXFyz9xlpx6hV6ekQOGYG9cT6klYqomwb1lpQceDF4?=
 =?us-ascii?Q?Z62/n8nBmXMq1ZO7+UM0feuqxpahcydEc7jXZmb4X0FJJfAmdDF+tBm6fVHQ?=
 =?us-ascii?Q?479827oIQWMDby24HAcHBYFj0Bbfft+t+e2s1i72c8AUI/9P0MK7HcTMihfp?=
 =?us-ascii?Q?slGk8gQsNunaQu3D/T3w1gKIprLS010RpOfDUTLECR/aD1E6f3urXSpxBJk6?=
 =?us-ascii?Q?gAxxGonwMBGTTNjCpzhEVo7gGicK8+cxjMGmhXpRljwSuaEszbbKQU1Rkt4l?=
 =?us-ascii?Q?JO5d2ol2GmanCjH+9R1ff5g2MBeR3ap04cq5MmDn/48ROKvZOSC5hyJXD/uU?=
 =?us-ascii?Q?8xOvQkDc2X5zaYo7u+aTq5v0oTrfzjhqtnLjNFlGQvgqi1byXJH6Ac729n+f?=
 =?us-ascii?Q?HnP472Y4GWoiruMbBsbW5gW8ghmKjjAsC+ZCpJW2UT9+gqk2c3GeqdDtW4BM?=
 =?us-ascii?Q?JgDqXl6Asa+/vU2EJnzYwG5QAUHlszUib5vnMz797ZR5+vix8Wk2CWUQKvXI?=
 =?us-ascii?Q?G+/XQoiWaaEaTXeSr7LE5CiPoImKqwne5ENdbJ8ekMsDfFzS3BY9bDcmEn0V?=
 =?us-ascii?Q?EuiRaVbC8fegMCp+pKRjTrIPWYwCDoxs3vHyXE8QpQLTlKYah5VtC3NVIdXx?=
 =?us-ascii?Q?mn1hWC2SWyi22XACKZu4YSAbYJjuqPwX6CvFefnQiydo2FWR645c5MQBxoaX?=
 =?us-ascii?Q?KEtuqgu1X9A3q+k3cdXC+mWEI1rPtwOdLuBtBKKKvZkD8yGo0us9aYfSwQWP?=
 =?us-ascii?Q?nQxZp3SdeTNAdfU87QW3oMCb337PrslXjn22oRh0DW9ZWe5+Z/Xset32o2Nb?=
 =?us-ascii?Q?vPSSNj5AQ7p7x09e6LThb/ZCnWFJJt4zL5XG79km37Q4OJ90kY1UAg4o035e?=
 =?us-ascii?Q?6tiQ23CRGNxW8nYKa9Jhfn6p7eAUkbx8x3bOwhtIYUnMuexRlNtzIqxRq0fz?=
 =?us-ascii?Q?SXIqYXIdZymJ/nzGqdK6orMa5SVFIxrMyQ4ZdM6zbjfAhNE3wG2gUF+Tn3OZ?=
 =?us-ascii?Q?qZ5/RVhyLrFGIkzTXcmR/HUBotuJpFLZmfyCD0afhhgfk1fjd8jftZ3DiexS?=
 =?us-ascii?Q?R5aUtps3RxOkLgun31kC/cTBsc6mvkgT8ptq9Q8XC0h5h9h5UDytaoT32DfY?=
 =?us-ascii?Q?dDr3dNAthWDaaAlzPshT1+htIJimVemWt+Dz5LOyBWrhlcCxHhRTECUMSTab?=
 =?us-ascii?Q?VBVPHCvMNg=3D=3D?=
X-Exchange-RoutingPolicyChecked: PtDR6KNtkdPEb5qkuctmIhkz52Sn3Vm530/lbG2cLve3ySOEyvqootsIzmL+9WCkunZoj7WDHm1f9iFI/Y5cKajNuQAW2mokJtKytnw6uNQdyu94Gp9lEdbZO1yBOgVFHt61uEIGY8W9poEr3LSNYL2TXE64Z+nUukUoyyGOHjtzImsvDRipuD8ZqU+J4omMxOc62HIBkf0+ma/8c+tb2dtbyTfbHQp764kwqpvFG27qDAUWq4LVw0lO2eur/gc2eV+Henh8oaFcbN9Gl9MV6ew90WN0sCeoFIJkiJp18usHG9B+jHJ3Ec0kG6jskUFLTELeW3wZWdRk9/rEjkX9Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c19a10-8872-4d97-b8f8-08dec8ad100c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 18:04:35.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fN0Asf6HiNd5Vj7R7h8I9gpoX5ofljVoO0mhlo9VD7EoomKj5KqA0iBKLRGE8Orp/vbB2ElWDfOHD+T9Of9AmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7035
X-OriginatorOrg: intel.com

On Thu, Jun 11, 2026 at 03:27:16PM -0700, Luck, Tony wrote:
> On Thu, Jun 11, 2026 at 02:22:23PM -0700, Reinette Chatre wrote:
> > Hi Tony,
> > 
> > On 6/11/26 11:01 AM, Luck, Tony wrote:
> > > With renamed variable, and comment. Is this clearer?
> > > 
> > > 
> > > /*
> > >  * intel_aet_register_enumeration() provides the value of "THIS_MODULE"
> > >  * from the the pmt_telemetry module. Note that this is NULL when
> > >  * CONFIG_INTEL_PMT_TELEMETRY=y so it serves as a flag to decide whether
> > >  * try_module_get() and module_put() need to be called.
> > >  */
> > > static struct module *pmt_is_a_module;
> > > 
> > 
> > Using a single variable to contain both data and state has caused problem in
> > the past. Could it be helpful to create two utilities, for example get_pmt()
> > and put_pmt() although naming is not at issue at the moment, that contains
> > and makes obvious these "is INTEL_PMT_TELEMETRY a module or not" checks? These would
> > then be no-op when INTEL_PMT_TELEMETRY=y. This would simplify the code in the
> > callers by containing this logic and not rely on callers doing this check so
> > many times.
> 
> I can code this up to see how it looks.

Eye-strain "if (...)" are gone. Code is now:

--- internal.h ---

#ifdef CONFIG_INTEL_PMT_TELEMETRY_MODULE
static inline bool intel_aet_try_module_get(struct module *mod)
{
	return try_module_get(mod);
}
static inline void intel_aet_module_put(struct module *mod)
{
	module_put(mod);
}
#else
static inline bool intel_aet_try_module_get(struct module *mod) { return true; }
static inline void intel_aet_module_put(struct module *mod) { }
#endif

--- intel_aet.c ---

bool intel_aet_pre_mount(void)
{
	bool ret;

	guard(mutex)(&aet_register_lock);
	if (!get_feature || !put_feature)
		return false;

	if (!intel_aet_try_module_get(pmt_module))
		return false;

	ret = aet_get_events();

	if (!ret)
		intel_aet_module_put(pmt_module);
	else
		pmt_in_use = true;

	return ret;
}

void intel_aet_unmount(void)
{
	struct event_group **peg;

	guard(mutex)(&aet_register_lock);
	if (!pmt_in_use)
		return;

	for_each_event_group(peg) {
		struct event_group *e = *peg;

		if (e->pfg) {
			for (int j = 0; j < e->num_events; j++)
				resctrl_disable_mon_event(e->evts[j].id);
			put_feature(e->pfg);
			e->pfg = NULL;
		}
	}
	intel_aet_module_put(pmt_module);
	pmt_in_use = false;
}

-Tony
