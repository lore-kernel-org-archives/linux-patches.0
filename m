Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9B36AB54
	for <patches@lists.linux.dev>; Wed, 15 Jul 2026 00:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784073637; cv=fail; b=CvxlWNQ9JXqmkPyIeuYcw5cVhdAUMtLz6fpQ5OoWQyI0s77HNRhl5KRIN2M2JhpunjAmf052DTvOiHaDD04/NSBWFOv6afvIbkBDZ7XsKOQWxnGGLuuZwVtLI1X+Er0JsVSoA39CngDBMFhkhvZz4d1q/dDVaKmB5QCfzePef0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784073637; c=relaxed/simple;
	bh=T6ZMKahMB54laUPaB2kuj0fCgpfSu8HzKxiAd273Reo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=axi7fPUfb+iGaPo+YJMFbEApzpWvFRC7fXlmcAZwcH30Xy0Pspdv9wGKZheqnZMNsbsqwAIdKWfHU4UEvaOrcXUf/r7CUJbQOz1l4vu+kNQETyZW3QXa9ux3sj2bJC2rXf75BqFn4eBLrpLoHLaDvWpj9jHi4xW8fqm2Wk0e/mQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLq8WZTa; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLq8WZTa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784073636; x=1815609636;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T6ZMKahMB54laUPaB2kuj0fCgpfSu8HzKxiAd273Reo=;
  b=jLq8WZTa8N0vHbtCzhQAssjjjYV45AmdjUG9rG2Js8EbJPpLgcr0fR5f
   Kx62FbT5eM6voP79HvMvBWvKptaeclF5p3tznEpD4TNEALJEs8ZvEB/Uc
   Xd2LqCJ0Zjdnhezwst59wk9iGlQnyDq4+ODJiu4j0leB8oYjAsNixahBJ
   Kc+CSUlOl/sEz/E3AeSRL/Wy00vLallj1VkxtL86xocNEz4VoYclvASp5
   XQMqilMqOqSy7/DL1vbIHfYj1hBWBbBUrS/rDPcT1zU6Mtnq+zZbsZjHL
   UxRVb8ODhUUScn9jEpZ40z/ZhXoBbnm85V52X+W1Tgn8LrZAnaDfX5vqd
   A==;
X-CSE-ConnectionGUID: D/145oqRQOG0USptO7J9cQ==
X-CSE-MsgGUID: 7l9m0CdoTtGWj1PnLPapkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96215839"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="96215839"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:00:35 -0700
X-CSE-ConnectionGUID: bDcNHGNnTb2YmW4ImhMUMA==
X-CSE-MsgGUID: SFgf7kbGTLSrfBGI4zqMFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="253384745"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 17:00:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:00:33 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 17:00:33 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.41) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 17:00:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HufAOkDR4fn7bcmvUGsExc4t+zttyxNnFlmyQDxWGTDi4Fykevsc3g1C8K0NV3AWbEqqkaaKaL0mssABydIgEaWPqZk2rNmsCwP+ZL9VLGPnh0ISkn4VDTh4sF2mtFYuBbU1HlHV1EKPjixIbhtJVS3oPlhx1SHlqSOkLb2NYF2b4RLuoNoq5N75pUcfw3ALfynYJDQtueK+c6b/DD86bN5EMkAi1aHHqjQsWvPOaXTkbsarQ0YMkYac7UrgRQyB7Z9OF0AW4RYCpONSuufRdUPQqQG7U0BEhm5HZetfDfzvtOXHXRIIxFoOe6WMvGTzKp5RnD5QfUDgfV55Hp854Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y48vl4irHHbFDMRi6yqcKcjZLfK881IL7PO8qNsDo4c=;
 b=IT1PdwbgtcJClfVWMxWpUaD2/oh9z1UMKcQe3UQ6qd8a3DqDWhtlyj59bOb4nnPar92lxDdtMqHMec33CpnoSrha5cmjMUGf20NYQN/5EZiD4XdLvxMlAhf2eLsWw5rc0DmgtsaXyelQ3HCd05SMW2LKviE3FCi6BM70UpLjqB/iLhqnX2RUeEvk4HzWmZT6HtNyebZGExGQrrWHWlQgxyACzLhyGNqBtHpT1eJezDY9ycMsde3sOs8d4KNQ5wnl6tQdx+g6gqq4oDQmNpkMI3y5KMhcWRZ6zQXDORbcieOSWzYNPQo7RTeZ7UdrjaDCRjx5oTJZzvmPOu4HqMEZzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CHAPR11MB9679.namprd11.prod.outlook.com (2603:10b6:610:2ff::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Wed, 15 Jul
 2026 00:00:31 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Wed, 15 Jul 2026
 00:00:26 +0000
Message-ID: <ac1be212-1135-4a6f-9b46-d69dbd4aa6e7@intel.com>
Date: Tue, 14 Jul 2026 17:00:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: "Moger, Babu" <bmoger@amd.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <88a6f85c-254d-4efe-ab2d-2ca41b05618d@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <88a6f85c-254d-4efe-ab2d-2ca41b05618d@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:303:6a::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CHAPR11MB9679:EE_
X-MS-Office365-Filtering-Correlation-Id: 16704f54-9364-4074-e3d2-08dee2041304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: Gc1M1mmJysoKv/69Fxfr068tbcrwZP7zNVWpBQ8tVQsEfzlgVMb8qa+KrW8LpuyMLfEPsuCZ1A+qNe5hnT7pQ1JwB+l1b5EPm2yVVtgKWvcGwSYtL0djRRcdt2TOWQ4Ias/KD6t0lMi2tu/EuFJr7Vyfjv5PoImryxxSnKjUTeVsFK6ShbsilSVahsTYc8qzAWxssJFbE0o+thuICK9dR0xMX7GbWeUoz+ZJlfrD48NYz+Bc6+Zu41qclouF0Qu2UDrZzM2O5xSB+Z46oTrrlvGLQFz6vyL0lg7/s0g9FDZfD43msAS50XtDVu+a4GMoUnNYl/u3U0LlGmWWtnYY0O8NQa5EisFZenzl03ygtoazvkbZWwHKVmAOJmg3XIIwFbtA4AKiy4eScv24JVdgpZqDVe/vWZoK6kHO+gmYXYVF/laLpQdddfcE0wqwETza9lDAziaFRO+cs4OM0SG1KgETZdwmo0ZiVlkYBkGZs5ktL9gxgk2zHPjP9RmXdcNDXXa7HZwS5Ts3j431gI0s0waIPs1WBzOsxeOIu9SDeiIPMGvNFCBRf8J7ARjN1yLRekCeLPXHhcPNcy9pidzdybxc00xwWsrzOc5i4i1oPx7159Az2MwyFRd7KT8/nCZiSSs17M8Hl0rr2iwllKu1XcS35exByr+K2RnL2jm/U1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUVzZ25oU1B2em54VUpHbWRUc1BYeXpPdjJ2UkMyU1RvTVJ4aU16MjZVYmc5?=
 =?utf-8?B?OEdvSUVYbWI3ZWdYNDNWZjNzU0JNckFpOVc2VFhmMnI1YzNJSGo2QXA5SzdL?=
 =?utf-8?B?ak1rR0VsSSs3UHAyRVF4RldOUGNUM0c1MG9BUUprak1LMU5MTnQvc1B6Nklt?=
 =?utf-8?B?bnR2RWlUSSsrQTRCTUsvaGZFZzF1d0Q4V0kveVEzdklUM2JYRGR4QVNXeHN6?=
 =?utf-8?B?V215UzdSS3UyTG9CcnJpRUEvQ3RmS3RxanprR2JCNEM0UXFUKyt1bVVIcS8w?=
 =?utf-8?B?NjRRMzVlalJ4YkRtL1JYS3BjNEsrQTZFVm9DVGFzMDRLWUczaTllZDBWcFYw?=
 =?utf-8?B?SUJsS05DdlhueUNWcTluSDFDU1RiZGRTbzFWTDNYSEhieEFzWmtrMXNIYzdI?=
 =?utf-8?B?ZVB2WWt6aFJpNDFNRWc4UXZjMWNxOEdxblRTM3B6UlRtSU04eFpLaU9QWG9l?=
 =?utf-8?B?MkJSUXZLT1o2bndaZ2tmVXl4V0oxS1pQbmlvQlBZUzdMeTNhWTAwM2xENnRL?=
 =?utf-8?B?ZHIzMUd6VTNJbFRSTTlaUmJkaWxPZkFPR1VHNXJvaDFjQmNNSmJQT0dINjNP?=
 =?utf-8?B?T1lrMCtlV2JZVzNzLzRuMWJOd3B2MkZocGpPN3A1SWd5b05EQ3JuU1VTZGx2?=
 =?utf-8?B?OUdLM002TndIYW5hVVJpZFdydmtnam5OMEtKUUh2a1NTT3VNaG15RTJtdm4y?=
 =?utf-8?B?NUF6U1hTWGkzeGU5OFZhMHhncVJUeTNUYU5LNHJuR3o3ZmVRRTZja2xWV2V6?=
 =?utf-8?B?QUUvUkR5Si9HR3NHWUQzV0N6bGZ4cUl6dlJleUxPVkt3YXJiU1V3UHhCbmJT?=
 =?utf-8?B?b1lpT0JIMWUyS3NGNHZNcXh3MU8wQnFyS2hFb01HS05VQTBySWNoSkloenhH?=
 =?utf-8?B?VUF1QUpjOGROYU1hNXVQSm1DdGVtVmxxZVNnV0dlQVQ1MWxReENZYWNKUnNV?=
 =?utf-8?B?L1k2a2pLamxvZiszYVh4SFZoeDIvTkRCaVZGV1NPai9MQTRYeEhQRm94SG1t?=
 =?utf-8?B?L2QwSFVBVmoxTWY3RXNDSnNpQWx3c1dQMnRWYTZoU3B3enhFQ0NoaXVpSXlS?=
 =?utf-8?B?bnA2cTJTbllVNC9qY1BnN1RWejNwTklRQmlqVWJpVVpMRldlcHdzMG1uczNX?=
 =?utf-8?B?cDNNdEQrWWN4emJBemhHMjhxclh3MFlrYlJRbUVtc2FMVFZXRlYxSUgrUThq?=
 =?utf-8?B?S1lJTGZ5NjVuem9OdnM5ZTZVM3BqKytkYU9mdi9qaTR1L2FzUkdiN3FPZnVN?=
 =?utf-8?B?bGFxbmNjQXBUYUdtR3RNYUFxWVZkWTJPVHNjZ3FYdUlXamJ5b3NHTVBKVnox?=
 =?utf-8?B?N3d4Si92dE43NVhsR0hyNW5ZY3dvN0tuamhFc29jU0w4YlpGSmdHRkFWVXFo?=
 =?utf-8?B?WU5WMkRxaENCaWhjMlFXUkFLczY3K2RvU0dYN04zN0RjMGNCQ3Z1OFdjdjF2?=
 =?utf-8?B?NTJ3S080TFJLalNPL2o2SVFWWEJva3VFL3g1YXNYVnFveTBnU29sRi95VnQ0?=
 =?utf-8?B?UnFwckdDd3o3aTZxcFZEMmJST0sweHlCcVNzc3VXM3RiZ2xxRWtTMFo1TGY5?=
 =?utf-8?B?S2l3bkhJamViY3hCUkV3OFFkZ0ZWdjRJV2NDZEI0ODd0K3NlaXFSQmo3Wjg4?=
 =?utf-8?B?REg0VHQ1MUdlWmM0R20yWnZnT1R2THlQaldXbHpZUnZGZTRyZ1RramY2dW1w?=
 =?utf-8?B?QTYvQUJYWW1iNEdzZi9KQXdQYW9UK29oU0ZSNFpORUpwcXFRSlhZTXZ3bjJh?=
 =?utf-8?B?akFuTkZFeDIyUS84RmpPWXFyTW1RTSt5cjI4S3hETWE2OUo1L29zZDZqdXpT?=
 =?utf-8?B?SmtsRWxWelBiK2dkem1rbm01dXFhZHQ4Y2JoZ1grSWlheDBobmlhQ0ZWUTZm?=
 =?utf-8?B?ZEtnNWU3aUQxL0l1VTJOUFNaaFV1QnhaeTF6L3JIYUg2UUl6cDk2ekRYcmVG?=
 =?utf-8?B?KzNnclExT0xYOXFpTjV2S2JLLzJidnZERlg0Y2hYZTlsWU1aSUk4L1p3dXI0?=
 =?utf-8?B?YUNwajZKTC9uQlFJZTFSNENxRDhjSk91V05VT1RXQjViQzRMbWdURDQ3TDBj?=
 =?utf-8?B?QzA1NlpwM1VSWEkwWWNtWmJnVXJYN0hQNEEzNFNhWmt0NS9hZDNmZGNYU1hQ?=
 =?utf-8?B?Y0FFUU01UzFjZmswMG85SmJiUXB6Y0dXdlh5Uk1NVkpnc1lyeXl0UlVodzlq?=
 =?utf-8?B?cUpPUitISW5tWFJlWXhKRG9CdWVqY2dwUTNtVWFMTlIrQkZzVGg0eWdZNmRY?=
 =?utf-8?B?UjA5ZEIrUElvemkyWG11VUJJeWxsUk9BcmFUS0I0enpLNDRLYUZmeFprbTNr?=
 =?utf-8?B?alR5U1lYUzN6OWZLekwreWE1RlJITlEwSTY0VEpiblVwTFBNMWRuK21WNlls?=
 =?utf-8?Q?rzAQq6u5d+sf8cB4=3D?=
X-Exchange-RoutingPolicyChecked: RhuvbJeXOZ2ctDUsG3ZUT99tl3a0N151cP/E3RKLexzCd/49V/uvzlKAVvz2udKp0x/z0wanXoBeKlrHpkCuOXe0l1HKAztCj/WCYGQJLF6c5bT/koo5LEYFr/S0to1Qt6v6qeuaYpaNuCSqqdKC7IevGxVKGVvPWKzJJeYwNoOcW5gYq9O1nK+3Q5XcJYSArulb/KSVp4Hq9hHuSyEKBSYNO6+JGCDB3hCNTNSZcmRK7AyTiCfQrMue2kNjEAAG/ZGUaRJxX7TuVnR5P1i55p67PIy23SDh/p0Fujq6lGXKckD9Q1FT/H7Qqcr1SHUgW2c0sMVguAPivjpaOa33sQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 16704f54-9364-4074-e3d2-08dee2041304
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 00:00:26.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgjTsslraIS0snwD81jGvlJYgra/pRD+AYU36pR1rkTFlVopLEDEcHi7Wt7oZlcaS5hKlnwaRzEldNpDuawm6unIhXTSNXlt3IF7MacFV5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR11MB9679
X-OriginatorOrg: intel.com



On 7/14/26 3:45 PM, Moger, Babu wrote:
> Ran few tests on the series. Looks good.
> 
> Tested-by: Babu Moger <babu.moger@amd.com>
Thank you very much Babu.

Reinette

