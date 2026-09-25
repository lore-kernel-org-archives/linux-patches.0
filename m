Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F7A4B2032
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347054; cv=fail; b=ThARsr6jvz6m6D+2mXbZacx4Nb77geKZMX8majSkmZkkGP6dE8zMORRQVMCC4M9/ftmkT5gBLpIhx4aagaBsDVG8rdW7yIDs1blm6rUgCWCwDTbWPmnhwgP3u83flfnsVwOnZYvCj6c3F+BGdRSr8pgU4n4pmkmT18PzsclDl1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347054; c=relaxed/simple;
	bh=jduzcqZKvR7EgAiuT3OZ8Vg//GIXDzXd34YVAO6OB5I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FO17yITMFBpVzCh0F4il9ipyS3UAKCJkFqj51TUSL1KWCPkJ0lztEIHB6AKx8OXF2wVo9vB4lCi/gg2mJJooMxhuY82LE0WUJszwpbIW28PQ5RVI91aD2H7P7FRNDTD6lW1fPfzj9yy1ioV3vhtOVIpuip4Wt9MBCJJ9uyi3U94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AVS38Kcx; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AVS38Kcx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790347051; x=1821883051;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jduzcqZKvR7EgAiuT3OZ8Vg//GIXDzXd34YVAO6OB5I=;
  b=AVS38Kcx7dTfpNKJb6VqwJoX6S23z1MGrRarGn9NI3mgxgYypFlTyoGa
   kRWQsA/u3yuSBiiyYFbqj/eB37Tgc0z7aHvojUVPDF1ZWQjHebbrwkRna
   ccl2hnT0MFmEirKZhHAQxl5+tjIpW097dw9p5LgIB5ikh4lHNkv28eQqq
   BnJy4AmfYEoc3juRaZlxzdtK+OdsarMgdNJ0/heOReKjjKiIgngE95ZDU
   I5jvzIRTcQoqsa9gFFC1vypwG63T4hGEyGmjX25zURmYgnfgJnU7YyenM
   1jchB4RAOZVZikUsCI3TyNJm7HQz41Advt60ZRzrrol+atl3dfMNaf5hf
   A==;
X-CSE-ConnectionGUID: qv9BkUVjSGiwZUzFUslg5Q==
X-CSE-MsgGUID: 2XB6FMudRsSQfHpSvDHjNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="101793075"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="101793075"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 07:37:26 -0700
X-CSE-ConnectionGUID: tP6x5YpYQRu2C7cTxk7XQA==
X-CSE-MsgGUID: bV7wpymvSuiWE8+RCQ5cmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="282427023"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 07:37:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 07:37:25 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 25 Sep 2026 07:37:25 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.61) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 07:37:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQiusi2YfT9yhNl7sLQNq6zneALT90O2YHWKRjzczdnhIHFD/amvgOQvSuB1mSn2nf2t3CO12J1z6gN2gnS62CUVD/wGhyoGpIhnbl3mofgBIVHI1jXyFXLrUvmVqDBCQ7/v0iQowBep23ExLatPJ2+UFGKZb0TLcmWwJs5ESzyzRXy4ERlLkojpS6hUHZ0GvoIJcqlLpeYqK0O58MxgZJ1TaTeK3ogVUv4oiq4OUivFhPezhRE6NVqnH9BgWMbGdvLC+PHg9cj6eadCTMm5H3bEqjnUfnNNfEnQYR/gYx+Fqs8Nnd1YVDtwDPte3KCjGXnYsrekZ3txhqEhojbHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbJAc1qBNJPCLVIrSPampKNgsV6ioIWRseNbUKlGDHc=;
 b=czwnq64+dOa1SY4OK/2Ev5NjkmavvYjyTrBEPew/Ix30BnPGqfy1dSk0KKe4mAjOv/1IRo2/I5mUiIRXqy6skSogYdomX5SHwXp5jf8xI7qPJEuZLwsfCuj/nbXLIA9k06S5NRjb/xyOM0bscqvI0uueTcJWOMsU3Ec3P8UurgCiVXZzaMOPLKa2VUuWoy4Mzvvuo8HrJJhZDhxNTpXW3TliSxKlFHa23qJsEbV69sWFh9VDN5Sze4PmzA9pHy+bpMgW3XS4ZbWtMyzxhX0rBdE7hR2GxmBm1paf5nRVbl3tzSL9cX31iTZZ+fqI1gOnlNYR8Mci+LTfHVf/A2EAFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CO1PR11MB5043.namprd11.prod.outlook.com (2603:10b6:303:96::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 14:37:22 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:37:22 +0000
Message-ID: <110d2c7f-8354-4d25-aff8-cd5ceb46334b@intel.com>
Date: Fri, 25 Sep 2026 07:37:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is the
 only resource
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-16-tony.luck@intel.com>
 <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
 <arW6xlQWVWkixiWe@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <arW6xlQWVWkixiWe@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:303:b9::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CO1PR11MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fb20713-9cd5-4513-88e0-08df1b1282a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: rtDZNaT5TlgHGAvHk2OY3mXhiA027JtYDNte8Utt9dxbqvcPze1KOTyfey2CwJhdEWhmlRz8vx6TiNBHOVL/jOi5jxnillgDKqTHB24DCWEs9pmXWML+3ixsAxieufq/pbyuFxlVnGOiGR37Y3irkaAU2+hprAjBdelQ+K0lE35DlX0RtWnhkKlXmyjKhcUAM616Tskuit5TYel/NXqDJvTWmjzd1XKXnwKVZRhRFMwMR1iEq9UCm0mug4cC3Uizdc10kIWnp53G6AKBwrTaS0sXnp5K6T2BEOAib74nJQPrBP3VZ7NY44MYQV0kmeQ4LV07OfhEOpMDDtxDs0yfQ+Rn5sn0+W12oSGCvbisfBf1hvRDa6qrTGKHqFnRW0XypHa72eqB+qJysOxVO8WtTULM36ZyyHWrvECijxXlccTqXxQmEuaYGwS+GZ0m4mgdN72j+ClSxJftcrNB8mIt13OEtmmlUbnI/70NZ93D/Zh3Jy4ycCB9euPsJEMUmTWKawhqD8tMB+KvdllqPJbLdMeb10YH1O3Xv8MHNpoBtqLaSJKM+6DQ1iVPXsbQmo9qGom6pxbjJylY45ogOElJTzreGS46LGN5Zh507Ygrx6jOqZwyMUe9W3/0EYPM/xpQX8u/a7b7pGNMSUr750MJftzgP9PKLgSHOoQoJLZAqeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHAwZVY5VTdpcjlXeC9zbDh3ajUxdHpwa1U4SGxxdkxXeDBob1MxR3BXVlFM?=
 =?utf-8?B?Mm9SRFpLU2RBYjNrTHlvMmxzYTJOTTU5b1NpblhZMlJyMTVSSDVFT0JTMkJQ?=
 =?utf-8?B?bTJSL2puKzYzQWtPSFE0ZmNwUGlwZ3pJWVRCZDdTSStiSE5vNFdTcHY3cnRE?=
 =?utf-8?B?K0lvczUzcENJNmswS2R1bzJQZjh1ekI5cktBVlRXTVBtZkdEc3Q1WFp0MGxK?=
 =?utf-8?B?NFlLMytQU25mT3Jwb3FDMTN4L0FSR1JHelRKSFpZekphQ2RpcnAwZTVma0hz?=
 =?utf-8?B?N29ObGRzSXZ1eE5FYlcxMFV4V1lPUnZVUXVoNGxaNEM2N0czdUxRby9IdUhE?=
 =?utf-8?B?T2RKT093RStydmJLL3RUTVErekZRcFJRcFFIR3hOaHI1TGNhNk02OVZmT0E3?=
 =?utf-8?B?Mm1wQjkyakNXZGVrZ2VocDlaZ3NDVFVXQ1Vsb2ovK2NLUFc5bnh5NVplKzFC?=
 =?utf-8?B?MWJwT3g1Z0twbGQ0SjlRVUtUUUNmN3JJRERnalY3ZStRaE5BVXljd1QzOUZ0?=
 =?utf-8?B?TkpUS2RwcTRqME5XZXUxSHhLUjVqcWFuaUJ0ZE1Ba2Mxak14emM3Z1VhM3Bn?=
 =?utf-8?B?VnB5NG0vSWJyY0NEZVhRTTVTek1YOXVPUklZQk5KSHUyTmtWeDBReEM3NWlT?=
 =?utf-8?B?c1RLNUZoejlONmNOaDNEZ1d4NFZoc3MreFh3dGdKRDdCeUZTVC92UmxkeU52?=
 =?utf-8?B?ZkFRcC9iM3VDV1kzYUhNSnNqeGNKUUVaNHNzS2lsT0hkUXFMZmhvZFFFU1VE?=
 =?utf-8?B?L2tkMmdsTTJyL1hmZzBaNjRFYTlVbXFhOWFIRDVPL2Uxb3lLTis4R2dWcVlF?=
 =?utf-8?B?cWtLY2tMZG5pSkpVVURlTEwxdGMzajNBUHQ0Zi9LZUt4cFZzMkxIQWhGQnVh?=
 =?utf-8?B?VWxTZ3RxMTRCNXlKMWRKY043R1Zzc2pEWnlYYUpMK0xuZnpjYU5OMWhDVUhp?=
 =?utf-8?B?TnlGZ2VpQTFkWUxkemhodEpvc2x3SkV4UzVTQ0ZNdExWck56dXF5M0hqMWJL?=
 =?utf-8?B?WG5COE5DQnEyTkh1cE5kdU1XeUg5MUhMekhzSzU5RUJuNEl5NGlnR2R3b2Zq?=
 =?utf-8?B?OFV3SmFUeERiS00zNjFPZVBkajlJN1kxSVhSOHJIMUM4c3ByaUY5dWpHUWVo?=
 =?utf-8?B?eUVuOEJwcnRoVTFRY0w5NXZQUFBHQk9hcDBBejIzbUxtTDE5MGdMZGJ3anRO?=
 =?utf-8?B?S1hZUjlWQXpGMmdPZ0ZSZXlPMlNDaTRxRTBtanZoRnBqbUdrNURJRHAwb3VC?=
 =?utf-8?B?REE5cHBqT3hPKy8xODlWbmV1YytYQUcxdjdZanpWZFhGV0FCdlIzdmVPTUEr?=
 =?utf-8?B?UUhpQmFkY20rK1M0M1dMeGZWT05scnVBd2pSc0lzOHZvVmRqano5MHZueXVx?=
 =?utf-8?B?bm84S2VRTFpPcUROVlRzaEY4dHhiQVVaS0RndlNpRzQxNHNOOTdMdG9SaGxm?=
 =?utf-8?B?dHdsY0hkU0FocXBMS1p2aUhEUlpTOTQ0eWQwejlteFZ5UUJyNWVXYW9WdjBQ?=
 =?utf-8?B?NWhHcGNRUjZzSkNaVkhDZ1ZDRitrTzJ5aURTODNST3lROUFTUGFvMlZiRVpN?=
 =?utf-8?B?UzNtM0wreTRnT1FKVENtaURzTDVDQngvNkJxTEFlbEFTNjJpcnhXU2FTV21P?=
 =?utf-8?B?VHV4MWxSL1NyWU5UcW1YbFREalgvSm9POUZYU2lKQXEybjlEeDkxMDBPWWRQ?=
 =?utf-8?B?QTlqbTAvWGxuRjFxQmtaRHR6MTIvTDZDMDd4TGZWNzBpVUhsVkV2WjZJcjYw?=
 =?utf-8?B?M0U0dENtT3duOHc0UXB4b29EQzFXc00yV1IwVUxLaTNwZVZLdzZza2VJazZt?=
 =?utf-8?B?dFZhOFJnMWdzM1VDTWdZTldpajNFZGNvdXFjVFdPMTM3bStyY0dEM3FVd1FX?=
 =?utf-8?B?a3lxdXZEZW43NkFzZmNqTTZqQ0ZNMWFPM09HcHZmbzBqbFk0dmZCanhhT2tU?=
 =?utf-8?B?d011bm9BTnp3cDNGckVTMlBWY290ZTRYQTgwV2ZSZGk5ZFRyR2RUSWszNWJk?=
 =?utf-8?B?VTZ4dEpSOE9RTUpUMC9mdzB0SkR2L2VUNFdnRlpEaE9ncStueS9TV2pLZUdD?=
 =?utf-8?B?WEJpUEd3MWg1SGNaVXZYRHNvMmhrbC9UeHhBTk0yd3pLL2ZwZXFYcXdxTGhy?=
 =?utf-8?B?cWJ6TW5RSktienlCRUhEN2RRM1BHYVdLd0FwZFFRWHp2Y3kxYlRhcnQ1Mkc4?=
 =?utf-8?B?SkpqbjNmYU9YSEdRUVhTZGFrUHg0bnkvUXduTm9JUmx1dk1vMnE5ZE9Gb0Ux?=
 =?utf-8?B?WjdPc2U3NGJlMlg4R1hNUGJHcS90dDIvNFBkMFpWaWNmZDArU0V2ZU1UL2dG?=
 =?utf-8?B?ZkNlVGRCaEhodXFHY25NYjhkeFJlR2F3c1E4cVEwNk5hZFRocnlzMWhidW5n?=
 =?utf-8?Q?MhwHejUlmXUPJxyo=3D?=
X-Exchange-RoutingPolicyChecked: ERqx/l/3nKytdakJdGVX5BJ9lEKHFnP7Fopox4ZLhskTOCoJxOWv/FwkHXfGpLwHfeHFeC3Pvm1jayB51CTKQ1CyMFvw2v1MznNVIk8ErTvSzPXydMtS0OTz0d+AsTC9T0jSFZN4Hq8iMica7OAhVSzNMzTtfS0lP6uvqRJXAIAZebmaTCcadgkZq51W7rS5m271NxJac+R/6RxXsRGohxZz5hfr2XOoydwl37zbhwwv3sA9LrzZ8McKzS9Lz+KdKELAB8FTqknceJ3B5MbqLgE4104Ux9LEBHlaWtU9Jkj9v0drKBytSLhNvEzUtInEHy38Za7eFIt9jLy0fBO/HA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb20713-9cd5-4513-88e0-08df1b1282a9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:37:22.7437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5tifH9spgUay58XZhTXDbnlaTAX7ND8rAYVDhyZOJ/PX1p+E26qmqGv2yyXisZF0XcGYhD710wfPMc/+LJ3o+3IyoVgRztT7tp83uaMlmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5043
X-OriginatorOrg: intel.com

Hi Tony,

On 9/24/26 5:06 PM, Luck, Tony wrote:
> On Thu, Sep 24, 2026 at 01:41:48PM -0700, Reinette Chatre wrote:
>> On 9/16/26 4:13 PM, Tony Luck wrote:

>>> @@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
>>>  
>>>  	/* Any of the L3 monitoring features? */
>>>  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
>>> -		return false;
>>> +		goto skip_l3_feature_checks;
>>
>> This goto looks unnecessary. Why not just "return true"? Even so, this 
>> also changes behavior from the previous version in a way that is not clear
>> to me. I was expecting this to consider the number of RMIDs supported by the system,
>> now that this function added:
>>
>> 	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;
>>
>> Should this be:
>>
>> 	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
>> 		return pqr_assoc_num_rmid > 1;
>>
>> Although ... looking at this closer it does look strange for pqr_assoc_num_rmid
>> to be 1, thus reflecting that the system supports one RMID, when zero may be more
>> accurate?
> 
> If X86_FEATURE_CQM_LLC is set, then monitoring is supported and the system
> must support at least one RMID. I don't see a need to insist on more than one
> RMID as a precondition for using resctrl. It wouldn't be super interesting

My suggestion was not to use "more than one RMID as a precondition". By copying the
relevant code not shown in the hunk

	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;

I aimed to highlight that if the system returns zero then pqr_assoc_num_rmid
will contain 1. The "pqr_assoc_num_rmid > 1" is thus not a check for "more
than one RMID" but instead a check that the system did not return zero.

> as all activity would be captured by that single RMID.  But it would be
> keeping counts of events.
> 
> So you first instinct above to "just return true" seems reasonable.
> 
Reinette

