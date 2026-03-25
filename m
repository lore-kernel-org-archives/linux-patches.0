Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C00311975
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462776; cv=fail; b=juEdzHy1jKf8GOncH83CZy0PnzHdeCzxBv0kcokK/+q+srh3phWDEP0BKGlPWpJusVR2O01v+Il8wdMRrmfBCKJoBM7jHZBXXG1L0WpbTIK52hZpzYaQS+3ildikOCSXeP4BYlw/n2HdqKKvY6uPEEM1BLnpBLJ1Wpb8gv0SA3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462776; c=relaxed/simple;
	bh=eSFaj66dsr8FRozfaGyo7zc1e8fU5RZ2vofdPHZM06c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qPeVnmVuOydEAWtRqNntZNbO3zKOm14+J0Wp1JfbJmI2t6pu6YvoYChzjQD8Oh1M5QR9YZK52WoI4zXnGuNI+HHcILsV9tdLUeTRoZNpKIoB8ATHUi24k9TdQrjCihPU/6OR4ebq59LhOe62BjaVTScCXq3/UJEcdODOXR6AQew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eiUvT0ge; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eiUvT0ge"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774462775; x=1805998775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eSFaj66dsr8FRozfaGyo7zc1e8fU5RZ2vofdPHZM06c=;
  b=eiUvT0ge2nKWI0tsziOsjf9J53swvY/hqn0/rViF4hoomL7iG5RmI8ob
   kmdl8BVOWVzac1EtlUHW3aD1GSp6erAwpRb2RpE/KGnY8taEzrBT6f1SB
   /zzWyXdR6fZyiqFRGSN8LO76Vmcg6g8ZXVDpDQgp3Kx4mSMNiG5QGNCI7
   QuhyRfDN23DtDAbj9tCvEhxmufZcGbysP3cv8mqrr2lON38PYYhXovLtq
   Eq9jHJ1rnpYKkI07Al105gG8e3vKlY8GsdHqTw4cC+1Wvb/5tow5WYihH
   uUANC5yZ9EdltdBX7aOlA1w3YcDxVe6q9BnYhROiSBLQQXBo2/HSbkGRI
   w==;
X-CSE-ConnectionGUID: xUR0fwu7R7+epxgHQGdgBw==
X-CSE-MsgGUID: QywNOybESRKWMZmQdnXJNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75412684"
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="75412684"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 11:19:34 -0700
X-CSE-ConnectionGUID: jC1Gql4aQSWR8kO+1Q10Fg==
X-CSE-MsgGUID: fBcMOXTrR9Ch6DnOC/ZRpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="229534676"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 11:19:34 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 11:19:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Mar 2026 11:19:33 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 11:19:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5aa+YodXs2HZZRojwPY58V/7TMfA/b8NZqdOz6O8Fw54LfIy1f0OqVqbqR1Aqc2ZP8n60VonOUnDk1/gIXPIRAsGXcFEUzMD5M1sbT0AnPWJBuATpQC9HlK6FE2387FxNf/ciVexh6Q7J0cAtANXbC5+cHABTCrnBZPsNSl5WUMtUMygd9eMhR0+QBU72XJdKKSM1qujUYWngU8wvmX/Vx6Nmtt8bB+kAB2BsSuWHiaCOKIqfOxQqyJPYJNYyNDeEqXSGTMg/G6zREr+Wvj4lC1Uahu7DuTyUgsi4Q3ppuKPh35r/4AWxzITKIik5Y9/EiFoPlCI7lD4ocf4MG+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PV60pV5eDXGb0koGtYsuyufdfaUbGO+5FFQssL9QWo=;
 b=FGhmin3RH/d3FXZWEPJ1b0Chrts9XJnje0/LnvsXCktQDDpkmv095AsSTBj+dS1wGXKGpcW/uCPNo4GuVqjDADmfMFQpY14sNiLL+N7PXbunyHX1kgBOSSWtKgYnObK3v9Siz1sp4BO2KZvyEEl4NCJXcmLrDSl3z+2PkhV4zpDZqc8o8BAUDUWPedPd9OZlX3zdnSAZT/ej6HhZFKXUEInGeJflMA8s/ORQxu/ERHfWgbIVBd7bVekJyvu1cF3+tQeGNAjzxCrKZp3zGUj+gjbvqG1OudobGfqba3w5BULcvzAb+quw/nYkggptCESTqepScevZTkr2EHieuDm5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8382.namprd11.prod.outlook.com (2603:10b6:610:173::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Wed, 25 Mar
 2026 18:19:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.006; Wed, 25 Mar 2026
 18:19:23 +0000
Message-ID: <0361e817-b673-4108-95df-c22d0795323d@intel.com>
Date: Wed, 25 Mar 2026 11:18:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/14] fs/resctrl: Use stricter checks on input to
 cpus/cpus_list file
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, Chris Samuel
	<chris@csamuel.org>
References: <cover.1774043709.git.reinette.chatre@intel.com>
 <744ddfbc6365832a5707b4d1631158f42e121401.1774043709.git.reinette.chatre@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <744ddfbc6365832a5707b4d1631158f42e121401.1774043709.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:303:8e::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8382:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fd8efa-bd6c-405f-bad8-08de8a9b0a36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: pTeTpz0yLsvtpCUyNmAPmiCRJduPmjfOtKRJwHp/s747buT04xWCx7aCM3GW57SO5ONUErXOLUbtaFVMGROOWSJTD+bzDsxqBhcXdoV9kcUW15BEnfj13tK+ttmicrso6w+isaXbRsSbXOI75C81O5l1TSu0FGd6LEhJOGUcgEdt6oQ4Q/pvW8tA7l+t/s5CIkG/q3MUe97iQo7J3kTPtbHMQ9bavQKNb1mLBF6u7jaN34/WVRuuP3mWBiBJzW53Pb6Mg/d+cSY7dLbbYlxcHcHP+vuLM5ZWxHdSwTXuMcQFvAk8i/iFmgsP2BxgyoOzwKQroLAi3bFKsWSdtKBR3UfiJK9LEpN4Mug+sia1bW/+P687kGCP3L7cPGfJ8v+Mr5uQG1yjdRRIgb5dWKARXo2Gq7k2cod7PMUND9CNkYETL3DS0GaDnF/nkA/uo6UrhxPMFaAXt9G2VdUweMx/uBXGT/P0fDad2F/voOA9TnRpM5IY3UANwSn9NOSTC5Tk5uOPZ75qxF0nfKHu5OOP0hta6NBE/oKL26wL8Nvx76E0xGXy1hFVFl74zhDOWkia6s7M/n3QoRnwGceHcf9kb9wvJFSXZpJXEbv59zviqZbbT3cyFvxbjgZtJJgtJJkC30NhTtZGaDOojbAz3lVTK7DpjRy62OcjJSi3ZX2vgcUOzuBzeL2ixtwtCQNisjNNfW0xWcKq+K1Z1BhPvCAZP/y42TofLvy13LMQTbLMHX0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkFYSTlzWDBpak5CaGlzN3VBWVV3bUYxdUNmY1lCTm9TV21Kc05vYktxT1N3?=
 =?utf-8?B?WlVHbVhpY3lodVEvdFp2eFNZVGVuek1PQmpkaGtJNGptQWFDMjFZYVV2amwr?=
 =?utf-8?B?bWdvTUg3QWpvaGdZclhRVlg4VFpoR3NaNjhlWnZvNmd4UVd5MHlKSGdHL3hx?=
 =?utf-8?B?NEs5OTdIbjdzOEM3TG9LVGpjeUsxbFQ5cFJQUkM2Z2lQZnFmUGxHRUJCOXFM?=
 =?utf-8?B?ejdPdTV1cEswVW52c2tqYVkxR1RHQ1luWld6blhPSm9wNHRsYUFoVE1TTmgr?=
 =?utf-8?B?MWxjSzdTMTROeWdVem1VWFN3VE15KzRldnRMWXR5dTZHMG1BTDNiU1JpUzNE?=
 =?utf-8?B?S0Rqc1ltcVpDdE9VWVRlVWFSVGI0U25rNnhaZ3pKV3ZEMis3RENOWXRtQ2Na?=
 =?utf-8?B?NFhyaHcwZDJTQ2hYOTV2aHIyaFozSjR2TUJ6N1Zibmc4UHZrQit2LzRKT0Nu?=
 =?utf-8?B?a1VXK1hWUGZqazFKSjNUbWozT0FCNWFvMXRSbTN6Wk9NeDhKZU54M292Uy81?=
 =?utf-8?B?VnpLUmtyK21BVDdDQU1iWVhrcU1QWmd0OHA3bDZoZlNvY0RQOE5JN3pwa3Bm?=
 =?utf-8?B?ZkFpaDRMK25TaXpuODhoR2RLcTJycXVrUllWUHJkMVZiYzNwNEQvS0svc2E3?=
 =?utf-8?B?MjJEdHNyVFBzUUtoa2ZyY2w1V0JwVU11akJJd0NWZlB1dzh0cFA5azdwRjZr?=
 =?utf-8?B?WlA4RHpIYnJMeHlHQlFwbVBZUE9sd0lSUXdVVVl0dDFQWmJSTTJiTlRKNEM5?=
 =?utf-8?B?S25zcmU5Tm1yaDhyZjNUTldrZXc2NXNQQTV5UXN1eW9BanczcmtMcUZPK1dv?=
 =?utf-8?B?U3RnVGtER2JXd09MYnd6bzVuNG5OV2xRRFVIdis1N1pDMXMwendoSnlBVFky?=
 =?utf-8?B?QWlsekxKdFdtYVI2dXk4M2U0RUhQMGlBOEJXNXFxMFRsa2puL1A2RlhzM2pN?=
 =?utf-8?B?aG1aZDJxeUxmYy9XOTJZNWs1dUFaMXpsRTFaQ0pOVkhJVEJMd2Z1ZDNDalYz?=
 =?utf-8?B?OXh3TXh5U2daYkx4ZGtHZjFmT2hyNnBscGxuVUhLRWhhME9UbC9UeFNkR25W?=
 =?utf-8?B?a1dHM3lGOWN2TXNuVFlSbWZRL01FUXVzRkVqREJxM0p2UFk3V05oUlp6VG9B?=
 =?utf-8?B?QVcvK2JqcElaR1F5UTlxRVRWYkxjWUlhNHcxTXJRc0VLTGd3RENjU2J2RXpO?=
 =?utf-8?B?ODEydmRiOWQ5RUZQY29TNlM0TVplWlNBbUZHVThPK1pmTU9DU3pNZHhpWTVI?=
 =?utf-8?B?VjB0OHlaUlFVUXo3MG45azJiajhqNE51MGYrNkRVeUEzS2dqcGIwN2lkcW1B?=
 =?utf-8?B?Yk5LS2xsdDFaRE9IS2k0Z3hna0hacmx3Zi9XRnQ2L0RvWjhCZUVyMi9jYmhT?=
 =?utf-8?B?ZnI3MDhVRS81ejhkYmF5T1JzUWJaaDZ5enRFbWpsUkhrWVlTNjFnaU5kMzFB?=
 =?utf-8?B?c3gwQXJMZGk1SmE5QmdDVlJPMVFCSnBOMERUNCs0ZmJCZ2VENVdVc1MveHJl?=
 =?utf-8?B?eHZhbGZaR2IxT2tHaUk5VDFiOUMxdGxxeVFFOGVBdkVwVC9IREVsUys2a2hj?=
 =?utf-8?B?TDhsRmVQejlaa2F0OWlJb0tUckFVcGZpM2JyWGJNTEdKVUx4WG00YzY1cXU2?=
 =?utf-8?B?ejQ4SS9QdDFvVnNpT1orL1BiNnJqaU1leHhSdlFwRVZDemRZNHBRRlRDTGFW?=
 =?utf-8?B?dWlMb2dJNERBRlJ3OTVTQlRhWHJQWUpJV29DbEdSNHA2OGIwV01EUjFRUDRZ?=
 =?utf-8?B?RWdmcDFtWE8wSXVlVlJtbXVUQW1CSVVUVmpFalAyaURRSlJUNkZjbUJ1Umw1?=
 =?utf-8?B?d01ZMkp5YmZTTUlkc1RTWHI0T01YbFVQMUNQNmgyV0FwMm1QTkcrSEF5UjN3?=
 =?utf-8?B?Qm9ycjdwUHNrcHFSaG9Jb0k5djdqYUFCQUloVXNBUWZ4Wm9BODFUSG54R3Jx?=
 =?utf-8?B?VnQwZnRwUkxOWTlGemJhajhLTVUzNXdRTzd6RlpidVU0cWkzSGxMVUMzVVJL?=
 =?utf-8?B?YlRxeWlocm5vaEZkakFJOUdVenV4MUdPa3JUcHp4QXRId2pzd3l0dDJHZldL?=
 =?utf-8?B?WFc1VURDY2JON21xaU9ZRnlwV2xFTGRSak1FNkI3SGdaQ2RaRHdqdFhUUUdX?=
 =?utf-8?B?Kyt1V0Jsb3dZbjlDRi91d1ZlVzZIYlo0bzJLNEtVRkhSUTl4YThpZE1jekVk?=
 =?utf-8?B?eWtoeVlxYXhFVVh0RWF1REpvRFJscTVub3NxcEJobXowdG9rdlhIWHlna2g3?=
 =?utf-8?B?MzZ2Y20wZmQydjNRcm9oaDBBVXI0aDJIcnMwZjk0aS9kd01ONVZ0eGlDSTNE?=
 =?utf-8?B?ZmR0SE9pUUtQZjIwdjJOQWc5RXVrMFFmaHAyR0NWOTVBT3RCbEdwTXNHeEdI?=
 =?utf-8?Q?Saw5VMzXS/3QSuQ8=3D?=
X-Exchange-RoutingPolicyChecked: QiFXXWwOH446CLMPvKYQdI6eTQ7Z/DHrByMMp9ODtcw+VnOa/vcX7jpDZDFET948Sd+H63Fh01/RDFxidsq6LfF5NcyWLV3sl9YJEeRM6INCBc1xWHqdZp86ITKwBmKptNF1kZUeVFvag41Mm4R9jYqICm4515UXQbBmxMY78lRm+529CuUSiXuFAbJSs/qb9BUAtK1Lt81YpgPEBwHTyTg5PhEz/CZQrloLfvX0Isulql+iQZ6arGLMWfEIR3C6Bb07s1k86EL9Zd6azjn5QpCws+AqNmMPsLvYo6Zr/iawScs2tFRi1c8AdRLs7CRvGxHiFVhAGI0hc80z0CLnoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fd8efa-bd6c-405f-bad8-08de8a9b0a36
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 18:19:23.0596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIcx0PadX9q2Dwnv7mFVO6D+HCmQaGf30BsUijpBpHZe8m9kuezfNbLEJnBK95l/61ktkwTg5KmzIdZs4YcyAh6nJj6hsDL6KCRyhQrXJuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8382
X-OriginatorOrg: intel.com



On 3/20/26 3:03 PM, Reinette Chatre wrote:
> Callbacks handling writes to resctrl files are called via
> kernfs_fop_write_iter() that ensures that the resctrl callback is never
> called with a NULL buffer. Even if user space issues a write() with a NULL
> buffer and zero count the resctrl callback receives a valid buffer
> terminated with '\0' and the number of bytes parameter set to zero.
> 
> The NULL buffer check at the beginning of rdtgroup_cpus_write(), while
> making no assumptions about caller behavior, is not useful. An empty
> buffer is transformed into an empty cpumask that is passed through entire
> flow that results in no changes.
> 
> Ensure that the user provided buffer contains some data before attempting
> to parse it using the same check as other resctrl files (the familiar
> "nbytes == 0"). The custom is for resctrl file callbacks to fail on an
> empty buffer and this brings interactions with the cpus/cpus_list file in
> line with this custom. The risk is that if there exists a user space that
> uses empty writes to this specific file then those successful interactions
> will start failing.
> 
> Exit right away if there was no failure yet no cpumask could be created
> from the input. It is of no use to pass an empty cpumask through the
> entire flow, just return with success to short-circuit the existing
> behavior.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Chris Samuel reported that this breaks a legitimate use case where user space
could use an empty write, for example write(fd, NULL, 0), to remove all CPUs
from a resource group.

This change thus ended up being too strict and should be dropped.

Reinette



