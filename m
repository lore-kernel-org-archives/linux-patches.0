Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A83E3AE1AC
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772825118; cv=fail; b=TIbalJZ4dFqMl+A3hJly1RL8AdH6wB5qclnuTM69PASWhRRh/pt+ZyjSzXc+Rog5OYZh7T6M288ZUuaxqr/ANjYCieQoiYU93nmn8b3W7IdPFR+AFilV+BAqaotl7UQdCrgbOX2BmmjV1wCh6DsF2m8cWue3mbpRxxFzPykGk4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772825118; c=relaxed/simple;
	bh=s/qG+jWEaa6CPSFKutTM4EMinYEBXa4oAHJP7+mMj1U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hb1GlwCZHuxQIOaGXW8iF6jyxTQ5NaTop8lbG/1VoCD49BwyIUucSzJWJYZ+RZLi/tFw02L4zRJoTF4mQ3I+9cWgD4xvcPS2oVd4Ks4qfAtp9KKT+lswsGYshcZf8YOxWpsCC7QQbuE0C0NPW/krqoG7ZBIQ2au5tvrtl7sNRlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CoKKGsea; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CoKKGsea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772825116; x=1804361116;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s/qG+jWEaa6CPSFKutTM4EMinYEBXa4oAHJP7+mMj1U=;
  b=CoKKGsea4JxH6O9L6OWdLCeityBwDEnbUAwkSXGcAq5dasKjEFgmGfAS
   cokWIqDv9tNrPXKsjBAhYTEuJxVAuvYwoTnYxAlKarAK6XARg0N+yqv54
   IDsJbfJ3mLvnqginnjTl2Fu2uEjZuA3UKiiuxCBS2UJNPxRUNQ9uFwgNe
   fr9qd9u3gtizbcO5Ki221n/e3FD+k2UUF9TI0W3jqCclVa6UqrmU9Hj6R
   wfgdilWzPnPPnNmvfx1HlAvD1IEp5f8znV+r6/jbDgmvGyJmirynxkpcU
   Nk8K8elkVy7do50KB1JIY39LvERMG5l0NRwMseZW5pbVR9VajttL0w1Gr
   w==;
X-CSE-ConnectionGUID: g0okYTypQuWPEn5hH+ByRA==
X-CSE-MsgGUID: 2yehtIm5THqdPXY+uPI9gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="91515955"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="91515955"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:25:16 -0800
X-CSE-ConnectionGUID: Imtp3+4XSxmf/uDqh4qA7A==
X-CSE-MsgGUID: k+feu5M8Tgqr/qO51UzTmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="242106284"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:25:15 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:25:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 11:25:15 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:25:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dS/ZaPKHChEZFOPeS/GZ+NSKOz5Igq93Ar6MGhRsVKREB22okiziYE4njDtdFJpeRdIdBvSL3tb+Icr1mOfq6NC+XqEfKeq9dviU02cGuK7LqZMK2pb8sfx3ztXSzjjGUy2swQKXR10aUwzx/FrEfrtc0Z6QHQihkHdotr73DNTWzsEA40R55sM/t+ED3HDkqUwshOb051PJv0nGYFzPcirtyXmrCLuyLq/OwJeznQafnmHrieaR6cPlfLxqc6c3gjAe2UHT2KKyqFbJaqtdOSzezxPlwsNm7TRdDnIJw44G5ybYfoLHduE9ssz63o9XQvoUY+6mI7LhkSNKSUuPEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YMn4DuiiALeObpwvEIcPUJ43thX05kXx8i79lXTVSk=;
 b=PmDQy9pUCmExAU9xRfHSHQkZ3p7JzzonLKYou2IJYcpQXKpVC1ESjNHOxRPXpCl9ZDULBQgLanhNBR1xk5u2IaP+xkoM3HfWvPFo1hv0Oy6TWSqey6h3bA9hBdklp6GQgrZl49SF59elOWYS5zcvOpweVISAPf3D7aMIBTX7TV0WTot4UAzpbwYwK4wrbE50y918NhGEmUrXD3g/EtGx9luudzlH0BkmtikymZWRHhYsLsVxlbAj20fEk58HLl3keD7pWRwrrXZkyAYFkydJl74kwQa1Pj32IEgHcxYz2yqVPzI+4KIPXCbWrTWSAoqjdhWrQZk46w34O/oHsDuEIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ1PR11MB6275.namprd11.prod.outlook.com (2603:10b6:a03:456::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Fri, 6 Mar
 2026 19:25:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9700.003; Fri, 6 Mar 2026
 19:25:10 +0000
Message-ID: <9bb42ade-00b4-4c9f-b955-8282c153f5e8@intel.com>
Date: Fri, 6 Mar 2026 11:25:02 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] selftests/resctrl: Do not store iMC counter value
 in counter config structure
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1772582958.git.reinette.chatre@intel.com>
 <aaaeaa9b1dfe0694a1c6659193ab5b736aceb090.1772582958.git.reinette.chatre@intel.com>
 <ac42462a-d244-855f-7bf5-dce91d6d730b@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ac42462a-d244-855f-7bf5-dce91d6d730b@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0354.namprd03.prod.outlook.com
 (2603:10b6:303:dc::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ1PR11MB6275:EE_
X-MS-Office365-Filtering-Correlation-Id: f03fc170-4182-4014-5dd4-08de7bb614f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: kQ3vXg2w2DUZNyl1wwR16Y1lDkhsElBQbOJBR4bPvLySQQ5BTGuKDK1j+sGeIAfF4/j5AJlelH7Xkxy3a7OpgfyjN0fzluZ4Mqa1mjJatRDVW+ik6gH74RDQ8kKvn0EKOQoxG8k3JPmHcvdeNAc8mnlbuU52ubZGlgJ0eenaSRgf/bMDbn8g9i/TyrlujYe/rGbxKxhvxYVUkgf26EQzwE8LQuPq9DMzXlG+ppmB52/6ERKH+Ajfnlx+6lZOcdbeOkED4l94SOqMVz0YYinZ4oT2ttpuk5cL4lIpX811JIxLwQmDgBMhiLlvHhORYFZEM+yKaHdpYnqlboCAfutsuOycKgP99xFF0kPUs9lQRE0YZ9P52g1poZPpqEwp70G9fcnEaaY53cWErZQQQbAnJwjIAh8bwl6K9C27z6y+g3fnGcRIK0f+yamSX/qqN11/g3m9JlstEUyBbLT8MDW74fIOI1WAK6BYiN5slahDX6K3uVnMk9TXfleQQ9/5MIyNF7+lg7xbxJx8BOfxklLFhP5Qm9RvmxG04U7wyyqX6xgfVq96nb8Sni9SWwIgBxjfZb8DW5tkn5Agyi4404wcAnoH/zxxtGK6kY9rnE8RmXWMRVhqmJYf8vrySesoWsW3DIZxozaPI4hgoadXX17ohzbftvI1Lvb6a9oSn/ZwNgcLBmVuhzit+zxHq2lx8RZpAV6Ra1pbuQO836ClhthYMNXicQD/EcoE3ZkLM0eRqlU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0wxaTFKbmcwdmlEUTY3S09IbFgvcDdxMjA2RmRPaFVVZmYwcU12a2tZaFF2?=
 =?utf-8?B?TTVpdkxrbUFmYnI1RnVEeFpKaWlxN1R5MXBJVzAyOHY2bUNGbXJwNnQ5N1U2?=
 =?utf-8?B?MXhuU1FnMEZPMWNQSmZLVzFQVUNEQk1ZM1o0anVFeHA4RlVlSGljL3BYNGRn?=
 =?utf-8?B?c3VjSkgvVTg4VEZYUzRPMWd2UHJMYjNtcTVJTjQyUCtPblZtcmVyZWVRZlNT?=
 =?utf-8?B?dDAvMFlET0VKTDNjeUxBa1FaSkFBREtHQVZLaDVPVFhEYUhROXZBc2NMTXk0?=
 =?utf-8?B?Y2JGck90UHN0TFdoUFZhWnp6UklnZFR5V2tzeFpFRWY5ckY5aHFURXd3V2dZ?=
 =?utf-8?B?YnBpWW9WVnRtdmNkZ0dJYzJDN0xLb2pleExqZ24wYmhZWURxK2FIRm1kZ2E1?=
 =?utf-8?B?RFlOdXpGdDJBeC8zdFRYVUhFM0xtR1dvZHZDN1ljZlNwZXRaTzcvdzFSTDE2?=
 =?utf-8?B?TW93bkU5TVExL01lU2xyMnBaQzVvTWs5MTlhWjFwSUwxKytNVkh5T05rWGM3?=
 =?utf-8?B?cktvY2ErLzEwZ244SXZqdVVlT3dDRENIb2hBakZod0VJcWZRUm1DV0djRWVG?=
 =?utf-8?B?WWdXdTN1SDZBeHk1enNlQnMva2hhU1BWYzFGL3Y5T3lxUEJJaEpPSm9ZTnlN?=
 =?utf-8?B?S0szOGw0aklDR2dTT093SWFKRWJ2TVdIaG03VFFIcG10VE1CUkNBditnVndJ?=
 =?utf-8?B?VXV2RnVITDJPR1ZyTkhieFBhemptOEROTUtXS1pMeGorOHUvNXBYTlIrTytv?=
 =?utf-8?B?UDBJUFAxdFpEOGR1Y1pRdWlib3ZFa0YvSUd3NURSdFJjVEVGdEFVUlN5M1Fp?=
 =?utf-8?B?WDlIRDVKTGxsYmdhTXdBYmpOd0hsejBMcmR4dXplblRpcHFnNDNQcDFlMHd3?=
 =?utf-8?B?bGl0Yk9kZ245S0JSa3ltSklNeFg1MWhuUWUxMHJYaytPczFucDlFa1J4bW84?=
 =?utf-8?B?Q3c1eTE1NEVrUWZmNm8xSVlqVFkvZ2FoNWlrUm81dHA2YXRtY3JHYzdSZnor?=
 =?utf-8?B?WkthaXh3MVozdWxPRytZQ1pDSjNydFFvSnpkeVU2RTRDbVhONmxpSThicUNk?=
 =?utf-8?B?OHhSQlQ4UCtQZTVVb3N3QUdhcVFWWTdMVVQyQlA0NHBHMWlCUmJXSkZpOWdT?=
 =?utf-8?B?WFVZclRBQ3F0dEVRaWxTMFYvaFl3cXZFMDIyN1FEQmpRd0VFWFF6K1dVakRW?=
 =?utf-8?B?L25zcXMvTzlpVVZJaXZBYmZzR25SR0ROVENlR0dXc2NvNzk5VXUxR1Y0Z0hj?=
 =?utf-8?B?MEcyNC9SWElHSGdIazBhN2tsVHJqZlN4OXFKaDYzUlRVUFRydTBHc3U1S0FE?=
 =?utf-8?B?YWwvTFVQeVNlZlZxdVdnamlhbTczWWJJK2RuOER3OFZTSG12eFA1SUdYRmVG?=
 =?utf-8?B?alV5T3JCczRhTWh3UUhOSXZLZ1p3RlFONitJSVBDTjFkdlpGcmgvbnNSSGlB?=
 =?utf-8?B?YlhLTjJBc0JRN3A2NUMxOFBMS21BS0E2SndDKzRxckw4Tk1tUHRoVFhBTGFI?=
 =?utf-8?B?WmdrUWd5cTVOWXI3NDR2Mm5IeGVLeGZiR0oyaFQ3MmJIRkx1Tm5qSllpc0Fw?=
 =?utf-8?B?VnRmNDd3dUlDRzRITWNyclNuS0MyZUt4Nm1MSTRHdkdoaml6RUpUQnpUSTJk?=
 =?utf-8?B?Z25JYy9HWXNKbzMrejdUTTlpVHJqOHBScTlwKzVYRlpvT3F4VnhCaEpDYXN0?=
 =?utf-8?B?SU1lZWRyaEVWbnJ4MWMvTFhUY09XSHBFcUJmOUJXR2JpbVRuekwyQUJZNjVQ?=
 =?utf-8?B?MzhlREZIUEFQNU9xMk5BSlYrckRrUUphYWljUm5lMktLeWFsVzltQmVGUDhl?=
 =?utf-8?B?K2lQY0IxK09YUXhwbm12cG81U2ZSN1U2K3ltY2QvWUljYk5RdVpiWmxJajEv?=
 =?utf-8?B?bnVoLzVlVG5pT256amRtSlJwc2tla1pkemRqd1ByVXU5ZkRwY1U2RGZYR05a?=
 =?utf-8?B?QjZDTEd0UXZoZGc5b01JaDV6TFFoZGxpdExYenl3L2pPWUJ5NUczMkJXMGI2?=
 =?utf-8?B?QXRDaitHa2d5bVJiOGRMaGh4RCs4UisxYS80V3N1dWM4cGZreE5BbHJ4QkVr?=
 =?utf-8?B?QkRYZWlKdGd5Y0lteUdMNHU0azUzUVdWTXN5Q2l1YzdGMkZCWWFIVVc0UlQ5?=
 =?utf-8?B?QVVjTm1Oc3B6RFVKRDhxdStQd015akRzOUwzckZjOXpYVm5KZHFmd1ExSGtL?=
 =?utf-8?B?Q2UzKzRPM21mdnFkM3IxK3owaDl4TStCQWZ5dVhIUGpMaTMzdzd2OWJFVVAv?=
 =?utf-8?B?NURYdlA4T2V3U1ZqM1hBMk1DSmh4VExmMXdXZVlyY2tXb2RMbTJrTkpSNW95?=
 =?utf-8?B?Z0JjOC80TlhqdjQwKy9HWUpSVXVMVE1NOTVueWtia2ErRjQyMUxqcFlickps?=
 =?utf-8?Q?huI54lkKAJxX9CcI=3D?=
X-Exchange-RoutingPolicyChecked: Uq7QrFwzycmyKjG7QsqKGDX1tV0KsbEqZJ1dZVQE9Z7JKeo5lnNEbWwmCclSdoHjBm3iNIkPYgpu67J8c4rhCrareXcU8rUFbIHjgPtNf0oFPLaDyR2mi014zf0+qy4UzQMvAfFaH5puvqVjIYWaa2F/Cj+yRq52FkGIxjbNY/B0B34WRcknr/XReDhUGFwXKTkVVU4KJLFEAhyxhbPMGVAMCRRoPkHu0SEnYmKpDlIFF80BKnxFGPJJf2MmXvPe0aLhb4j1X7ylEpGVx5KIvgJB+Yh4PMC2H0EbiHdjf3W/hhVSOXe+19iaqnaRbwCAPWNhUW/zclOivyvh8gjqxw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f03fc170-4182-4014-5dd4-08de7bb614f7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 19:25:10.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCFJo6I8AyZwASP8bIBHPB3WCjGLNxSdoUyTlmiNB9x9UzFylUJKB3v9vYL4FvDzXFUJim8dTZHcRSSRu+ilpN11yWRloUhfnPzbfytx//8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6275
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/6/26 1:51 AM, Ilpo Järvinen wrote:
> On Tue, 3 Mar 2026, Reinette Chatre wrote:

  
>> @@ -312,23 +311,23 @@ static int get_read_mem_bw_imc(float *bw_imc)
>>  	 * Take overflow into consideration before calculating total bandwidth.
>>  	 */
>>  	for (imc = 0; imc < imcs; imc++) {
>> +		struct membw_read_format return_value;
>>  		struct imc_counter_config *r =
>>  			&imc_counters_config[imc];
>>  
>> -		if (read(r->fd, &r->return_value,
>> -			 sizeof(struct membw_read_format)) == -1) {
>> +		if (read(r->fd, &return_value, sizeof(return_value)) == -1) {
>>  			ksft_perror("Couldn't get read bandwidth through iMC");
>>  			return -1;
>>  		}
>>  
>> -		__u64 r_time_enabled = r->return_value.time_enabled;
>> -		__u64 r_time_running = r->return_value.time_running;
>> +		__u64 r_time_enabled = return_value.time_enabled;
>> +		__u64 r_time_running = return_value.time_running;
>>  
>>  		if (r_time_enabled != r_time_running)
>>  			of_mul_read = (float)r_time_enabled /
>>  					(float)r_time_running;
>>  
>> -		reads += r->return_value.value * of_mul_read * SCALE;
>> +		reads += return_value.value * of_mul_read * SCALE;
>>  	}
> 
> This looks mostly okay though here too I don't like the variable name. 
> Something like "measurement" would tell what it is much better than overly 
> vague "return_value".

I agree. Will change to "measurement".

> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 

Thank you very much.

Reinette

