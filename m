Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE25645
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759536743; cv=fail; b=U6JLZyoRwDaJLjGfCbnpC4ys6XrYYiy6VuCndDAGHNL9BapwXVopfAuRYTc0gD0+AqFqXtULRg7+tRwrm8UQ1in9/B1hAxd4v76w4chYuuew72C9Y9ZyX5HnOBf4+Ihg677jfDY6b2wX+TxPm0EES5KacgFJsdwDREDbdJt8GdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759536743; c=relaxed/simple;
	bh=QP79nnQ4xF7QbKav+30xuABXAQ5xua+BeWTMsPmFZu0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XC0kVaTkV707T5TGL0IdVyDpl/JpTfd3E6mTLBgNMbtxm6+H7rbnYEiEZSCgLSxjHy+WKhpPoayCXCF1Fymb0hHnJ0r6yEU+GRKfgR9hGnXHkYaOCJbD/jbxDTFB2qDDCG2IJHv3u+9S5N26PnqbDY2vMsTLxHrENB7KZRncDAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fxe6Rd8Z; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fxe6Rd8Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759536742; x=1791072742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QP79nnQ4xF7QbKav+30xuABXAQ5xua+BeWTMsPmFZu0=;
  b=fxe6Rd8ZSu3zCkzzZSGWy84SAXKIirWhlHiVllQB4M1BhGbyKuigwJfQ
   s4M0rbcZEyvTnP+5WrXA7Kls9yclUk0XiFQFVxlxJcLOqM/t4HXabbcDJ
   Cp1S1lSmBPYLRSA1wZmQRrZ8xXGEWcRwlfcd7fMASyReUmt+7/bE9jiZj
   cCEG37ORaWiQAkwc5Zg6mxGyedni49HfLfLyBAkMZW+w8c2j4lMB71JZm
   ejIEMotin10EKYsj78qxBws4q7WUbjtLCcb/Oo4lYRCdFr+jmC6TvoXwQ
   8QtOcMTgzu53zMn5sCJRljjuOuoxgaN2PY7edonw8h5OFw2w1W4FY1Iml
   w==;
X-CSE-ConnectionGUID: YbVIE/PNSdyVuZYsGE6pgQ==
X-CSE-MsgGUID: 1bUYejZlRjCrEpL9BhM2XA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="49372335"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="49372335"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:12:21 -0700
X-CSE-ConnectionGUID: Ixxokd9xRie0i+ryyOYN1g==
X-CSE-MsgGUID: ehZou2QaR0uSjMD1eDqrBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="178695713"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:12:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:12:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:12:20 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.22) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:12:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxvIZwRgQ0F8ADYnjBOdai8BfXyh6jQ2w0t9Gbn296gxqg0r5VrOipNN7LoT7Y/FoUhFxOAnclXwH8LfZ55o4nrqgsK6mJM+nvIKdkY6JuNxDxq+ls04ViTv9BTO4wINCKWJkQFww+jca2FmxygWDmNeqMbSLukR+HwXv/OLNO9hPEYvcyNl9TDIHkrm3Z19d1UYAhLlpXyZD57xdHZMe+sC5/SJ/p6doPQpDqdki/HYlrFrQfg26Nzgky4eOxIj9LAiCKZDvxs38Eju/w9P8ojumg4Wcn0vnBm2ZCin7hPXSbgVeixfyclv8nPRl1q5yEqrvjrpZ8xo+wr6D/52FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mr7xpmoK46h064wKFU0roI44qLZquTSNdkczivy68B4=;
 b=Oi+HOqm/cqIK1p4ah81wmaFJUXnhEiFO6DMi+YyK3uzShGPhntUJDbW9R4GsD4Whe3g5y0yfvodSANRBMRV+n+np1qELAAWCPdj0BIbbodWwslqXtShNRBuhZU8cQ6IqyRWtkH5D4FpqGj1DKQOXfIjSSL1QV7N+DlvLRnS2enLwRID/V7MPK5ZrxTPncyi4FpSGxvnBPpn5UwCurcf0v3yJ85hytzqowqbhP6kw37hrUhj/6SWJKjYhnIlEhh3k3j+4yRoXbbO1szJq3uxDXpv120dQTmp93Tw6uY7/L4r+rMZOgOdJByNbep5jdLpfLLxSuP4Lssm5VpgMpEIwVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Sat, 4 Oct
 2025 00:12:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:12:11 +0000
Message-ID: <0c092359-c407-461a-be0c-289c5e424f05@intel.com>
Date: Fri, 3 Oct 2025 17:12:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 26/31] fs/resctrl: Move RMID initialization to first
 mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0030.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: bbd6c7b8-9e28-46ba-2037-08de02daaa45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OFRsS1NQYVE5SVV0c0JIZlRCdHFPUmZaMkRacEVtUklCTVViOVhITUNYMW0w?=
 =?utf-8?B?b1gvbVNpc3JHL3pGdTNraktIdEt1TjNkMjg5L0orVjgwczNqZ0VySnRHdTZh?=
 =?utf-8?B?clBEUGErNlBKVXFZWVM2VHBuNVllQ2Q4ekdUYUx2dEV5K2I2Yms2NTFiaTJx?=
 =?utf-8?B?YTRtN2xEdnh2bUI2cFA5YVZjM2V1ZHY5YVR0TEpucFhQNnkyTDZzMjRHTE5B?=
 =?utf-8?B?UWR5bWRheEdLMTdRNWdwR3ZpZVI2aVdBUnB3RGt0OG5xT0w3aE9rcVlLWk9G?=
 =?utf-8?B?NlRsRjI1blcvMzI3UStKK1pLbVQxaXNkV3NDdFdYSHdSOUptWHlMdVk2S2No?=
 =?utf-8?B?SUROcEVCRHVjVU56aytTTG8wYWFmWVdEZUpGbXAwc3FDR3ZDaXdtT0hxY3h4?=
 =?utf-8?B?RUZJemEyRHphSGlsOTByQ2lVUmNVRUNxSGQ3L0NWUGRkenRWY2RLeGhEc0pp?=
 =?utf-8?B?M0xaY0ZzcmpOd0FOVkFqa3lDSDhjRnhnMk5SMVVVcmRFOC9lbkVJMElnY1FB?=
 =?utf-8?B?K0lMZ05SZFVkMWxoRHpvaWZGOEdWUDVkUWU2enFmenRsWUFGYlJiZkk1OE9I?=
 =?utf-8?B?aFFsTWwvTHNBRzYxWE9XK1FTN0FteFd4MEROY3RRTnZZL3VzdFF0RnlMODVy?=
 =?utf-8?B?MkN4VzdyNUxIaXQyYXJXY3hKYm93cE1obXVveHdYSVhWM0IxWGRHNjFBejdN?=
 =?utf-8?B?L0xEVUEzTDR3NVlLY3Z6RmlCTkJuSllDMEt1dUVFcUs4Q0ZJWm9mVFJXVnUz?=
 =?utf-8?B?eG0zcFpRUi9rallZUXc4aE9nTkNiSjhyc0FOV2xNL1prcFZ6MEwxTEs3cm9D?=
 =?utf-8?B?MHd6MW1nS3Z5TzhwcTBmdVA0ajV4Y09lbHpNbldHR2lmQUxvRkRGUnA5TExJ?=
 =?utf-8?B?Rnp2RHhCWm5UcHo2UmNVZzRzcmo4SFhOSDR4SXFBcVJXWDlZa0JMeHNkODU3?=
 =?utf-8?B?NDZBeXhSL245YXptMWlySEMwMVBrcmxvamIyczlBQ0IwQ1piVURNb29YRmJQ?=
 =?utf-8?B?RFNYbC91SUQ1T21yTVJJd2Q4T09VaXdzUnBDVGo2VDQzcHRpanNzKzNiekxO?=
 =?utf-8?B?Vk9FbFRwWWp1dDEwcDRzMmpMVDFUM0pHSjIzaTl2VW5JbnBUdEFVWSs5MXQw?=
 =?utf-8?B?NEV1N3F2Zyt4YzN6b2tvWlVvMUxkTjBkaVQ1eUlENStpUE5rWWozSVRwYXpB?=
 =?utf-8?B?ZmVkbDEydHdCQ2tEeHJvRVo0bjE0Tk5VM09vZDJseU5JMG9yblZnVXNmUTVy?=
 =?utf-8?B?SjBEYktrTTU4MlRNRjJUaW41RUlGeS9sK3lyRFgvSk1iNjVVQWkzZkt4bCtN?=
 =?utf-8?B?b1A0QlBoSEJ4RVBadEJNWGpqUHJEMm1QbkRBbmVtVEJVVUxkZFMzcmpPN3NS?=
 =?utf-8?B?a2dKVlhZZ0xISkVVR1RBSXFpM0ptdG1rdXpKSFhvWnRCcHF1OXl1MkUxYjlU?=
 =?utf-8?B?cFpkWi9xYldCbkYzdGQ1VUoxVnF3K1pwUFp5aUlzcWZhQkIweWxwMXRWSzFh?=
 =?utf-8?B?MDBVUHZ2OU4vMlY4VUdCRENwYzc4NDY0azhuNlQvd0NDWEMrWlJDbTdCMXhL?=
 =?utf-8?B?M3hXakpvcENxTFE2OERGc05WSFdyL2V2Y2VTTFZsSjdBVGhRS0FQcUw1c01t?=
 =?utf-8?B?U2hYeXpaTk9hTVhsSDhkblluMHl0dDhzb21JdkpkOSt0S1YwYzhPdjZpL1Ry?=
 =?utf-8?B?bWhkam1yamV2MVNzYmFnZ3pQRm01Ymg5bFc1RU14V2RsQVJuYjNGN3JGVnJ0?=
 =?utf-8?B?NFBma3NBZWtEN2txZlJCVVlTd0toMEx4dkV5eG1mZWIyRDlNdnVWM2NGVG9S?=
 =?utf-8?B?WG5TNW1YRndscEV1YUZVNFZPMEhpczZQWjVsV0tMeUU2RGdhWjJPN21kOHdv?=
 =?utf-8?B?T0NZUFRoWUJtb3pGR0k1NXJVTHBTd1pRTTZqMUsxSkZ0UnR4ZmVyUlE0S3pz?=
 =?utf-8?Q?B8PtZMyLyj3TdfQ7FwlREJ+QzOCiVsdd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWp1SUkxZWU0UFJJMlpQQW1sWGhONUplMUdBNEdpQitZV3huSjFVUG1QSVpY?=
 =?utf-8?B?aUtXSWdreWsxdUV2Zi9OTFdjNWF5L3VYREUrb3ZMb1liQytjcEFnaHc0Vkox?=
 =?utf-8?B?ZnZtbjJFdDRVQ2VYZzVpendsLzc0UkMreTBXcUcrTjYyNU1WUmdTWmlPT21R?=
 =?utf-8?B?M0tXU0NZSXpGWkpPSnFudENkL2poQVBJV2kvd1NJMWZNRnRLZ2c5b1NXOGZC?=
 =?utf-8?B?K1M2VTZOV21WYU1ScDBzVDFDclpnQUFpa25VNU9vRlFuMXkrSkdUckdtNnpJ?=
 =?utf-8?B?UDdEUEtBWHB5NzlOeU96alVQNHFXQ1pkQzZEUE9WYmo5UFNLbktHeVJQR0N4?=
 =?utf-8?B?S0pzeGd0T083eUpOL3MrRzFsV3Mzb2VVRnpnMVNGeCtwU1ErRTByTC9HVVNH?=
 =?utf-8?B?TTlsb2t5U296S1dYNTRRcndMNzNMaXNEY3REa3N1eitkalZMVElYWUYrSXhH?=
 =?utf-8?B?NUxjQ0xGMzRpWG5nRTA2ejlkb2VqT1F3ajJzb1VVcmI1VzE4azA5UTVXZitD?=
 =?utf-8?B?cG9Nd2dEaWhiVzNGMnJMRCtrVnhqbldtQnhld2pkd3hhVHEvMDlLSFZjT2c3?=
 =?utf-8?B?Y3hzZE1rV1VEK05ObzllRncrcVlNVUgrNWQ0WXlwV3RST0ZoT2pZVUhjSWhz?=
 =?utf-8?B?ZzF5YXhCZEVJWjZTMm02RG1TUE9weDFoeVVON2tpTVhoUzA3QXJzekFqTlhr?=
 =?utf-8?B?UjRuL01nZEwrR3dYaEdOMHdITjNiN2drcFBrT2k3RjNaYThudnZGL2RKcWYx?=
 =?utf-8?B?ZmtCOE43QnMxRkwxQm96M0ZXTzIzUCtzWHozSmFoN1lGa3Y3VVpTYURpT0RY?=
 =?utf-8?B?dFNBbjVSTjlKVko5L2UvMDVTcmlzbzFxekV3eWtEdzdwOEdmNjEwZXJiaWlY?=
 =?utf-8?B?S1g3dTFpbDhMY0Q5RXhCRWxGZlNMS0hlTU9mU3BwSE9kYUEyQm1kd3h3Rzhx?=
 =?utf-8?B?blhIZjlnbmZzUHppOUd3UmE1MlZTRjh5YjlLNGxOaFVzeHB2N0hjUXF6NGJk?=
 =?utf-8?B?NG94RnQvWlRqaElOMndPbm0reERqOHV1ajJzR29XRXpWdlZqaFhFOHhwY3JV?=
 =?utf-8?B?MkRISWdseG5TaFlldUtJZGg1Y2hwc0xpRGFvT3FYN1VMcHRsNHN6TDFJWVBO?=
 =?utf-8?B?NGo3RjVKQUUyVVRxaHU5TnUvUnBiVFIrMTYrT2pGOGNGWGRScTVPUFVPcGs3?=
 =?utf-8?B?NitmSHZpT21uUldWOEFTTkhKcEsxVUg4ZUFISW9FeWRwSTI3VUxGWFZLWDNB?=
 =?utf-8?B?UWRZVTY5ZEt2SHlLNjkwcXAzZ2xnYUZBT3p1NW5xZFQ2SzlnYktqb1ZnSDl4?=
 =?utf-8?B?NEVLRVE4MDh4WnA3TG5Zc3BLeHkvMHlLcXR6MnZsOHRYU0NKdnpaa3Vsd0ZL?=
 =?utf-8?B?WVdxaWh0cllDM0FjN0JmZlgyM1pnckFqOUxIVmNZT0tsdjBJRUtxTmVNL015?=
 =?utf-8?B?a01oRkc2MnFjUGI3cjN5Si92MEwzbm91N0lLTWlLY3lNSkRrUWdYcC85bUhM?=
 =?utf-8?B?RThHUkw0cnVaRUhFcHl4LzR4ZWxxNDNFMno4aW9TcXJBb2p2NEtGRzRFUWI3?=
 =?utf-8?B?d0hVZ0NyNlkvQmVMcTBzendzak5FQkk0YmNBbnBrdmlTekdzRVBvbHFQRmU2?=
 =?utf-8?B?QjFFdCt3MEpxbnhkVzRYcXlMOSsycXIwRmUya3dpTHlGM1l2emlVNm42eGx5?=
 =?utf-8?B?cUM0ODVmTis4ZDBlNjltVU0zbGpOd2taUUNQZC92TUx2aTNEVy93eVc2RzB3?=
 =?utf-8?B?MHFRcFZRUUlSMlNCWXF1V0pGdkh3bzVsKzcvOXFMWEZSR3g1K0hWMFJIOG5h?=
 =?utf-8?B?UTR4NjFQNGVCcUhYY0pRWFkrY1I3Z25lWFZUaWxRNkZzeFRCNERYd3ZtbnZz?=
 =?utf-8?B?WWxJYnd2N2d3UDkrSmdrQ0FFYTRYTU11ZlZDdnh1eGZqRE9sNUYxcFQ2SWZZ?=
 =?utf-8?B?c2lLbEVlOHB0SjJ3blhvdUdKcnFVenNnZlBEUFREdlNlVGdZREZTand3UjNo?=
 =?utf-8?B?cHRzb3ZWU0hESGVPWWZzUEoycEZrYzh5UXdLWUNlbXlTYWN2OW93MWQwRnFm?=
 =?utf-8?B?UWNXb1RRb2dyZzNRZWxTV3FFSDBNYmc0NnUySHBVYldmbFUyQTBENUxaSEFm?=
 =?utf-8?B?eTN3Z1EwdWo4QThzOCtoTXhuMEZxYklKMW5JaW5Ma1krVGU0ZnZZaG8vdGRp?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd6c7b8-9e28-46ba-2037-08de02daaa45
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:12:11.8205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5k6XT4Sz+1x469D5ypTyXR4KE+80f/dYKH8rR607/woeS4l94snH1x5YBNvL7KXZ/91V7lu0u4cMMbUa2/3DlOhKCqidpQKiXk0qyqMqfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> L3 monitor features are enumerated during resctrl initialization
> and rmid_ptrs[] that tracks all RMIDs and depends on the
> number of supported RMIDs is allocated during this time.
> 
> Telemetry monitor features are enumerated during first resctrl mount and
> may support a different number of RMIDs compared to L3 monitor features.
> 
> Delay allocation and initialization of rmid_ptrs[] until first mount.
> Since the number of RMIDs cannot change on later mounts, keep the same
> set of rmid_ptrs[] until resctrl_exit(). This is required because the
> limbo handler keeps running after resctrl is unmounted and may likely
> need to access rmid_ptrs[] as it keeps tracking busy RMIDs after unmount.
> 
> Rename routines to match what they now do:
> dom_data_init() -> setup_rmid_lru_list()
> dom_data_exit() -> free_rmid_lru_list()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h |  4 ++++
>  fs/resctrl/monitor.c  | 50 +++++++++++++++++++------------------------
>  fs/resctrl/rdtgroup.c |  5 +++++
>  3 files changed, 31 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index aee6c4684f81..223a6cc6a64a 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -369,6 +369,10 @@ int closids_supported(void);
>  
>  void closid_free(int closid);
>  
> +int setup_rmid_lru_list(void);
> +
> +void free_rmid_lru_list(void);
> +
>  int alloc_rmid(u32 closid);
>  
>  void free_rmid(u32 closid, u32 rmid);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 5960a0afd0ca..c0e1b672afce 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -880,20 +880,27 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
>  }
>  
> -static int dom_data_init(struct rdt_resource *r)
> +int setup_rmid_lru_list(void)
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();

Should this be done after the resctrl_arch_mon_capable() check? Seems
unnecessary to determine the number of RMID on a system that does not
support monitoring.

>  	struct rmid_entry *entry = NULL;
> -	int err = 0, i;
>  	u32 idx;
> +	int i;
>  
> -	mutex_lock(&rdtgroup_mutex);
> +	if (!resctrl_arch_mon_capable())
> +		return 0;
> +
> +	/*
> +	 * Called on every mount, but the number of RMIDs cannot change
> +	 * after the first mount, so keep using the same set of rmid_ptrs[]
> +	 * until resctrl_exit().

Could you please add the motivation that limbo handler accesses rmid_ptrs[]
after unmount? This seems a much stronger motivation about why this is not freed on
unmount and thus valuable for anyone that wants to refactor this later.

> +	 */
> +	if (rmid_ptrs)
> +		return 0;
>  
>  	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
> -	if (!rmid_ptrs) {
> -		err = -ENOMEM;
> -		goto out_unlock;
> -	}
> +	if (!rmid_ptrs)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < idx_limit; i++) {
>  		entry = &rmid_ptrs[i];

Reinette
