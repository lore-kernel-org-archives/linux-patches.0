Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E681F462D
	for <patches@lists.linux.dev>; Wed,  8 Oct 2025 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759944027; cv=fail; b=QZt+dU6UOcVzjasctB/+eYWQzNby/1oKfSSPAiroo1JghQYDJxmoBEbRRB4xnLgOPZUgKpC/7nRVpexb6k3MrTRQwsRY0LizSvDo25lNQ1bQ9upysmewDJkV7vUGEcY80B4RU7M7hbljj4Xt2MDlZMFd4e+aC50P8QXjP4uJwdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759944027; c=relaxed/simple;
	bh=dPnPMagLwqoASIsWONOC2bWznsl99tXOEvhFV+LXM0E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hxr7d71Zv9vX6DBFGTKORp70TL2c2I8QawTN/CY02qMtctSBl6hT6OouJ7ANsKDwsJPj6VilZsMAAs/JCySO5k48a8x5GUJWJ2WZdQVrMWI8LsvopZST/I6EmWPVj0Mp8Vr6egngftpAbwPEwOiDGlZiO+F9N3wPmogFAL0BXWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b7CKYsai; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b7CKYsai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759944026; x=1791480026;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dPnPMagLwqoASIsWONOC2bWznsl99tXOEvhFV+LXM0E=;
  b=b7CKYsai9FNWGBbKa5Q37UpqNSN5D6F+46QoZMMUgvAg3RenbC5NDOvh
   vNIym50TGl7aXaeIdqSFd6gh/SN0muok02J5wmc2vF2YQwxLxBqyxsW8H
   UeaRp1OfckrT5Bg4N1X+BIg++kS+FqKITFTY3DVUYIF0JQp5YshaEhBq0
   V9Ol2EJokhqMVkn2858vDV6Nb86J2PUH2tfxF3P4m5Job3J2rE+Bjqf72
   QG0lRQYoxUrzOKrAPruklJNzIK8aQeAnbS0GLC2Lbywv+akXljHuEJz0X
   MB0ls4DprKaBvLrReiXA1rAamtkKpWo9LMXtG3FBYPs8gjoVWo7Xo4trH
   g==;
X-CSE-ConnectionGUID: 58/V6PblQ1a+daVanHOX0g==
X-CSE-MsgGUID: v5smhIIIRwqjXtOv1JALRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="64762423"
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="64762423"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 10:20:25 -0700
X-CSE-ConnectionGUID: KAJD4k84SoKI1r6Z3e7IRg==
X-CSE-MsgGUID: xoufcRvuT3+AhpSjRH+nFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="179752801"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 10:20:25 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 10:20:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 10:20:23 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 10:20:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoYe9LVbAyRs0PpxU/IR7VLkwriqkLoPGJwyaGfB1a/liKotcua+TxnnkjSpSZ+hgL12rmBXmHZM+TeM62h6g0kXntcjI7OxfEhc/c6m841tdSffUN1bCJrSpq6I6uC697CG+5dMDKDFYloCeyEbABYXr1ugTg1I9xYBMmTKx/5+fV3Ns1xKUbrc2dMmj/Yz8mnhMWN8yqbyNFlv89Pmq4nMTXfCrFL2XP5KBUxKvt1nkMcZAeY0lGh1WIOUd5Dc0lITYR2yStECOJ2HC4j+ST7iBUc7asbXZvLvIomDSrbwPswzfXd4kvCAaxhL+2bpMWiky1pO55KcwYgj/BrWZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPnPMagLwqoASIsWONOC2bWznsl99tXOEvhFV+LXM0E=;
 b=JzqkWna6EsNNusTN5D3+YVGEgyLToDM+ol28CyylPWj33zyMybh+JIwa6V1wf0DaFUZPxawhGXL0Fh0xWNSjNEu/e7raipj1Hagw2+SUywsoSQMvW2P8rBxAGDxDitz/7VY3jB47onEK/QWJ3q2hzWRTKBjM2Jo6iHtxdRfNlBqgHicZaoGWh5FAFbsWu5FiNHQLPxhWgjsbR378EiTYgtTR+IhznmNY1ME7lMiSghJigGyuG5kJp81zQMKm3i08snv0hdhyIghZVmaUbahPyJADoFJT+O6dRQEgt8JNhmBGv+VXnWcHjHxtvU78EgBwrFNI5u90kUPY2l7xS6m1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 DS0PR11MB7309.namprd11.prod.outlook.com (2603:10b6:8:13e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9; Wed, 8 Oct 2025 17:20:21 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 17:20:21 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
Thread-Topic: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry
 events
Thread-Index: AQHcLleTktotCfnUq0ms6b733SUBErSxIAmAgAReyoCAADYRAIAAA/mAgAGBsQCAAVY1AIAAAV1w
Date: Wed, 8 Oct 2025 17:20:21 +0000
Message-ID: <DS7PR11MB6077067F8807424708439981FCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
 <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
 <aOQIMQsgBOta0PRP@agluck-desk3>
 <89e640fc-6bd7-40b1-8968-ca1a85005f4c@intel.com>
 <aOQ44WJMXweGNlL2@agluck-desk3> <aOV8bFiiQxlPDske@agluck-desk3>
 <a011002c-a4af-4ae5-8cd1-a1180a0f62c2@intel.com>
In-Reply-To: <a011002c-a4af-4ae5-8cd1-a1180a0f62c2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_|DS0PR11MB7309:EE_
x-ms-office365-filtering-correlation-id: 9d2d28fb-5b50-42ed-552c-08de068ef5c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b1ZISEtPa3Byc3c2bitXdUVGeGlqVUtZTnkxMzFlSUluam4wS21xNDh6cEph?=
 =?utf-8?B?S3dXK2pHYUFDeFY5UFUxMTUreWZLUVVVTk9sRmZUMnJodFpmaWhGTGJvK1NU?=
 =?utf-8?B?VEgrWGtjbzRxNWJCYkNpNmduNHFPUy9BTEhQZE8rM2xUVWxPREZmL1owbm5k?=
 =?utf-8?B?YThLTldiY2s0V09vNkJJaVNjY0Q3djdKTDlZVjQxbjR6Tkd0aENwV2p3c1Jp?=
 =?utf-8?B?WkZEYkJPcjFraEpSeFlWQmlPY0tyanRpU252aVdZSmkweE1QQkp1Rjd3am5H?=
 =?utf-8?B?MjZLL0hlSzVaRmpWQUV6SFcrdmVCYjV1K2dVMEQ3QUtlMFkyRHcxbDBIemFo?=
 =?utf-8?B?c2JCNUFFT0FSS1NHckhkc3NSeFZrN2N4UWI2WGF2T0tJMElKak0wODhPSFVP?=
 =?utf-8?B?U3NpcTkxbnVPbWhrSHgvR3Q1K2Y3bFdKVFFVMW1sQ1R3aGhoVWQyMjMwRk5R?=
 =?utf-8?B?YjVPNEZDY0FhLzVNUDlBOWF1S0RId1ZXeWFoZVRVUDRRSjdOWFVNa0t0T3Vw?=
 =?utf-8?B?MDN2WG9EVThSQlp2bTIySC9IN0xGcnkrbUpaaHpGeG82bTRJblgwekNtQVky?=
 =?utf-8?B?a3V3RjN5OVVuZXhxbSt1WTdENW00QkZMdGYwQmtQRmRvZWhMUTFzM1l5QWZU?=
 =?utf-8?B?YWoyQmhESjl2SisxNW9QRlVicTZUdWUxbGxwNTA0RzRzd2RIMzlLbUxQdEtu?=
 =?utf-8?B?d2NEWUFxUWhNMjJPYlZ1bnUyU0pLeGJtRVB1d25DamZDZ284SG41Y2lQUFVH?=
 =?utf-8?B?Z0ZuVHV3bFg5cjNxRUhNNVpxZ05aTWNRbjJhQXpmbU1mRzRRZnZ6ZXc1Q2RV?=
 =?utf-8?B?a2RDbTlyby9OVzluK3hDb3NOZktBdmJmYnk1cm95Z09nV3dGQm1Hd3ZqdWI1?=
 =?utf-8?B?b2hEcm9rOEJXYStienpBTzEyN2JTUFhaNCs1NWF4aW9KRDc4MkhXYkN1WE04?=
 =?utf-8?B?ZmJiOFFHazNuKzA5Sjh3SFhiZU9lTjd2Y1BxOStZS1FJZ1VxYXd6ME1lNnNa?=
 =?utf-8?B?L3pnamwxeENJMWQ1V0pWblViNGpuaHkrT0N2dnZOVTJoMUszbTY3QzBMMnJj?=
 =?utf-8?B?dnM2ZThHNFFSbklHRUcwemxoNHlXYXlFSkdvTmo1Vm51cEpMdzJGWm93WE1z?=
 =?utf-8?B?OWlabEpsMDJvNFk3cER1cm5iOS8wZEsrVmhxdjFxejZXVENUWUpwUWVIZG52?=
 =?utf-8?B?K0EvNmdwaTZmOWNyVHg2OE95NzhRNWgwM2tOQ3VLS3krRUtsZGF5TnVraUht?=
 =?utf-8?B?aE9Ia0xpdGpFMVFQSVhIS2tsVTg0bnBDNFRjNWtQOU1WTDBtWHZ5RmxyQkYx?=
 =?utf-8?B?TmtqdE92dFNjbGFmRGNaZjhsTU1QWUNsamFHS2NjTFl1THoxb29oaE1taW81?=
 =?utf-8?B?MnIvdHBSb0phMkxSZ1FTbWttajFPU0hJdDVmL1kyaElqTDgxb0lOUFZzK05O?=
 =?utf-8?B?T284dlpIdEpQbDYvQ2dZUWRuOS9lVHV2NVRlTW8zajdaZEdwOEdBWEZmYUpZ?=
 =?utf-8?B?SkpScmVOamQxalpMQ2NRWjJ5UVlFaW1mR3RXOTZhTjJPb0tGT3IycTltRm02?=
 =?utf-8?B?Y1IxZUdvMWRHZm9HYktCRWYvWVlXaVpPd2FQSmVEMWxNWTBJWVVVd2x6Z2Fy?=
 =?utf-8?B?YkhTNEJJOGg0ZytYSWtMK1RFYitBb21RODNvblpzdjdoa2ovVTB3dllyQzBT?=
 =?utf-8?B?Wkk3UlgvREt3cU90K014UlhXZmhmdHdXdjMrQ2FmZ1BtOXgyNVFQU01td2pY?=
 =?utf-8?B?YXJIdG1pYzlSNFA2Nmh3cEFBSGFabDMvSkR4c2lUZlRvck4vUnp1ZWpuSVVR?=
 =?utf-8?B?RFR1b21qM2lpUlpGblg3a0hMdlFsbER6amwyRzJmNWdpSVNkbGVZWU82YWg2?=
 =?utf-8?B?N1JrQVMxVStVRDlDdlNJQ1VTT05idzZsRWlYaUZmRW9sZU5tMGVkM2tZTktx?=
 =?utf-8?B?UlBEdUwxbmJsckVGc3BlZGhyQkI2c3pDc2lYeGk4OTd1ZWhKWEUxUXR5RE9m?=
 =?utf-8?B?ckR4YVEvbFJQVXhtdXhsMFg4dGFpYm5BNUJVTmxRc2ZVMUMrbzhPeUlvK21p?=
 =?utf-8?Q?4YTkZq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjhWbVRrclJ1Njl6MGxCVTdqbDRKUGszMzloazVOcXN3d29kVm4zcldXTk16?=
 =?utf-8?B?TTVJVDU2Yi9ndDhNQ0dIallITHc1QmdWeHBPN2o3N2pKajJSdXZaMmtEOERY?=
 =?utf-8?B?aEQyTCs2MlJzcXdsTXN0Z3RPOGl0OUNYS2k1NU9vYlRubkg5azJjMHlKNjB4?=
 =?utf-8?B?N0xubzlEZTNGVlJmOXk5azdQNG15UGFLbElEclE2MGxWN29hUC9TYjJkRkhV?=
 =?utf-8?B?N3JraHBSQ21XSGozT3VKL29CTEVLTkxxekhidnZSVDhuWXlra3FmbUsxdFJR?=
 =?utf-8?B?ZlIvOU9pTElXd1BiMS82eXF3TkZwbGdsUEc3NTJMcnlxekVxTFBvK2tBdUhN?=
 =?utf-8?B?R2t3cXVUdHBOMEN3S3pRTkRNaEE5QjVBWCsvMnZCb3IzSHB0SUxodk84aXhP?=
 =?utf-8?B?WU1sanVvL1RoRzNHRmxRRWhDL1JHZUQwS3ZvYndNd1BYRlpWRmFOb0R3bkQr?=
 =?utf-8?B?OGw0djlJT29ib2FpS3R4M2w4ZW9xR3VDbnBIdS9ITXRBcC9sQUNGckZIdmZs?=
 =?utf-8?B?NHlhUG16ZGppT0xBVEpIQStUbkpwN2s2QWVBQUZuQnFrclF5Y3JpY3pPRWtv?=
 =?utf-8?B?S083ZmJDbk5BbHJLazl3b2pKRUdTeG5TUnNHTng1TTFza3IvekVwY2xEaU5n?=
 =?utf-8?B?R3o0d2lINFJ6UUhSSHlZOW5nQ1pQbytSZFUvUy9xSnZsZnZxQUZSdm50TkhR?=
 =?utf-8?B?OThJSHdKWklyYkx2aEhyNk5vZTVwcUJ6WFluY2VmNzVmMEh1R0dMTG9kTkpm?=
 =?utf-8?B?UC9SeU5mN1RLYUlmSGJ2dUtKUzBXMVI1ZXFoanFiaUdOeHYzSTIyUEZ4bU02?=
 =?utf-8?B?Uk9QWnc1Q3FybEd3QkVNRnlSWCtxZFdURUFodUZqRTZIUnRyTm9zc3FiODdL?=
 =?utf-8?B?VnVhT2drY3YvT3c3SCtMbkZOU2I2R3B5ZXh2NkFBMy9Zb2s3b0NvWlcxQ2JD?=
 =?utf-8?B?Q3ZFeU05NTFmMDZlZjN3YWhhQzdvaHR6VFkydzdkOXVXUml3TDc2ZGg0TkRz?=
 =?utf-8?B?VWc4eHg0Qk9WbFNuTWlZR1pnOWY0Mm0xS1M0SFhMRWU1UE5mWHFVL3BESUpV?=
 =?utf-8?B?SlBSYjBab1FGUENYNUVDWVFRbXVydGpLWFNnQjdxem5uY285QnNkQSs4bVZy?=
 =?utf-8?B?ajJ6RklIWGtOeE9NYmpYMUxBeWRUaDJNczNWS2xsZmR5QVlGUExQajl4Y2VT?=
 =?utf-8?B?UExod0kvaTNwVlU1N3BMcFF2ajdIMUcvWVlBd2lhVUJzUnYrT0RIOVJORGxJ?=
 =?utf-8?B?Sld2S3BYZFV3ZDQ4dityVWlraEs4NGl2VGc0T3gzSE5iYUxWME1BWlV0ck1i?=
 =?utf-8?B?b3pKTzJmSnZqdlM0U2xEYjc3TGFLeHE0R0RVa1ZhZ3pQemRRdzkxV0VJNVY1?=
 =?utf-8?B?NTE0WSsyZ2NsRkF0STFNWWI5VnlxS2Qwem53VEJhOHVjeTJnNzI4ekpDTUZ0?=
 =?utf-8?B?OHpoejBxd0xNTGFIVmozZmp3MmwyaW9hRUZGOTFkWFNWSzBtMEF0bGgxaGc0?=
 =?utf-8?B?VUVHSENqV0s2dGFrYWpvRzVUNGI2ZWZNMHI5b0xNTDU4bWE1R0o1Q1pGamtQ?=
 =?utf-8?B?Q1ZMSTFGTXJrelluM3p1UTl2SkczKzVEUzFjaFJMalZ2bEltOVNsYVBrbEtI?=
 =?utf-8?B?RVB3cU9HZXpiZElBY1BIWElONjY1TmNRNFNtL1Y3M3p1TTU0Mmt3aFBCOW1L?=
 =?utf-8?B?bTN6THhOV0FSWXFndEFDTmkrTmJKSjVZSTZxaEJKN2tCdDAyZEQ2OFFJQmFp?=
 =?utf-8?B?bThGK29JSm0wV1JYTm5meXNzMUMrdjlsNGhSZzk3NFUweW9UZXgvZjd6cUtt?=
 =?utf-8?B?OFlqYnBtMTQvWjRaUkpNakMzS1FqQ3JqckE3WGVQcWMrTUR0U0w0UUZmekNB?=
 =?utf-8?B?c1paSEYvak1seGF1Q1JqUHNkcjVKWWlaTkIwdnh3aGFDV0JxMTR2T0xZcmk0?=
 =?utf-8?B?UitlK2VZT3BsSThOaWNCbWlsVlV3MTQvaVpZV2ZPeVUwKzRQWmNvT250aFZ1?=
 =?utf-8?B?RkNaZERSdGFEd21PVlQxNWx0WDRMNVRTY0JNcWJDVk5NanVwMUJIZDFyU1hV?=
 =?utf-8?B?Lzh5U1dYNVcrMDJBblVsR3UzZjR1ajdjQnExd3RrcE1LWmVGZjhFRE9TNHp1?=
 =?utf-8?Q?2vcQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2d28fb-5b50-42ed-552c-08de068ef5c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 17:20:21.1550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOO70TazKCnwMYlNFvGTer0BBzdufDTDqd742lGZRwQvpIPv1m+xAcbxpgXfRSrJ4JzzjbZfGJRPywX+XAofZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7309
X-OriginatorOrg: intel.com

PiA+IHN0YXRpYyBib29sIGdldF9wbXRfZmVhdHVyZShlbnVtIHBtdF9mZWF0dXJlX2lkIGZlYXR1
cmUsIHN0cnVjdCBldmVudF9ncm91cCAqKmV2Z3MsDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgdW5zaWduZWQgaW50IG51bV9ldmcpDQo+ID4gew0KPiA+ICAgICBzdHJ1Y3QgcG10X2ZlYXR1
cmVfZ3JvdXAgKnA7DQo+ID4gICAgIHN0cnVjdCBldmVudF9ncm91cCAqKnBlZzsNCj4gPiAgICAg
Ym9vbCByZXQgPSBmYWxzZTsNCj4gPg0KPiA+ICAgICBmb3IgKHBlZyA9IGV2Z3M7IHBlZyA8ICZl
dmdzW251bV9ldmddOyBwZWcrKykgew0KPiA+ICAgICAgICAgICAgIHAgPSBpbnRlbF9wbXRfZ2V0
X3JlZ2lvbnNfYnlfZmVhdHVyZShmZWF0dXJlKTsNCj4gPiAgICAgICAgICAgICBpZiAoSVNfRVJS
X09SX05VTEwocCkpDQo+ID4gICAgICAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+ID4N
Cj4gPiAgICAgICAgICAgICBpZiAoZW5hYmxlX2V2ZW50cygqcGVnLCBwKSkgew0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgKCpwZWcpLT5wZmcgPSBwOw0KPiA+ICAgICAgICAgICAgICAgICAgICAg
cmV0ID0gdHJ1ZTsNCj4gPiAgICAgICAgICAgICB9IGVsc2Ugew0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgaW50ZWxfcG10X3B1dF9mZWF0dXJlX2dyb3VwKHApOw0KPiA+ICAgICAgICAgICAgIH0N
Cj4gPiAgICAgfQ0KPiA+ICAgICBpbnRlbF9wbXRfcHV0X2ZlYXR1cmVfZ3JvdXAocCk7DQo+DQo+
IEkgYW0gbm90IGFibGUgdG8gdGVsbCB3aHkgdGhpcyAicHV0IiBpcyBuZWVkZWQ/IEkgYXNzdW1l
IHRoZSAicHV0IiBvZiBhDQo+IHBtdF9mZWF0dXJlX2dyb3VwIGFzc2lnbmVkIHRvIGFuIGV2ZW50
X2dyb3VwIHdpbGwgc3RpbGwgYmUgZG9uZSBpbg0KPiBpbnRlbF9hZXRfZXhpdCgpPw0KDQpSZWlu
ZXR0ZQ0KDQpUaGF0ICJwdXQiIHdhcyBsZWZ0IG92ZXIgZnJvbSB0aGUgcHJldmlvdXMgdmVyc2lv
bi4gWW91IGFyZSByaWdodCBpdA0KaXNuJ3QgbmVlZGVkLiBUaGUgInB1dCIgd2lsbCBiZSBkb25l
IGluIGludGVsX2FldF9leGl0KCkNCg0KLVRvbnkNCg==
