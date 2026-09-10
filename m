Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45FB388893
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012093; cv=fail; b=KImlj9/XnsC8YzazHNC4dL0rKrfcQ5S+MUUlJ+hrgdd45y31LYUQ5KEUG0ETUquqFJGb3JdkOONkcRvVRRvbnle/2DMP2qNasMPQvD5xKtbotdpFL4JduyE7eNXTra2Nk52lp9XqF9oYTPQjgfPycl8PY3q7nWWEZtcuGR6nBkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012093; c=relaxed/simple;
	bh=Vah29icR/HSD6Lfg8pC1sH0YKzKupXTkfto9Bn02qtU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IoM6z6lWN3n+Fren+Rut6wIb+amIOmrhioES5RxJ1FtUQkyXbmo2dICBjuiDyrv+1sd4pE0vc1t0pbtCH7DBnKAe63Zpz5FAFOICPBneDHIFL4hG9VRWSpzbDpsNCC02/7nKpHeTaBaEAxoyI9sojAoi/jtafBShoaKdTWZEXCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uu6c/t0Q; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uu6c/t0Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012091; x=1820548091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vah29icR/HSD6Lfg8pC1sH0YKzKupXTkfto9Bn02qtU=;
  b=Uu6c/t0QiZBgX6ex9uHHkzVFERnRmGV5x/JoR1ZpR55njRD6HWlM7s5A
   d/95Lk/zyS/rEA87OmVJOmTV5KLJl+tkoweJPYjdUNntkcM5Tx0ADV3mH
   H6gPVCV0UReeaSkJuQJXl3UZFsqo8OscDNz1OCJ4whJDQERkxaDc7YrXU
   NVNqewxpgOvhr6GaQdPpWKcOsh/FoVBhmwhzchNS92nEs/v/E/gk5c2Uq
   SKLBv5l1D3UivJXVACSlfo1Ic2orxyvlfJZ2b0039h/Whi2RmxyoxM59B
   Oyz5jPkXMclXeZSRg9rz6Y0aRQrL35Q40zz0MR4HH30vXcuheH084+51G
   Q==;
X-CSE-ConnectionGUID: 7WQIqPPURbi6uItZAOfyqg==
X-CSE-MsgGUID: zXJuAGXRRWOWSYaxAX/k2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="93143920"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="93143920"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:48:10 -0700
X-CSE-ConnectionGUID: hVCcFcQMTLe/LyJG41B8SA==
X-CSE-MsgGUID: S195vrV8QIKNFCTm9tmj+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="275650764"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:48:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:48:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:48:09 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.1) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:48:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x6bd6TY5LwFUX6DJ7JNd2yi5BIWKxQIgCwa+5pAMV9aCKa4J46iy2e1Dm2xMWevPkTD6jN3nCnW1Px4J7hFM37yPJcrHsdCwgVv40cVUwklqndQT+bTZtdDQE9ti5Rm0dwJwdJc9vuKSerVyS9EZDpFfk6ZDQR72t3WIH8sNvw2vldlytlqwxKdBTRsVxpHDnuIOJ8WwDOe2kkQL16fYhEn6HGNUES6OaG5aj+NAlVlEYQMPc2wlXy3Rqr+mDErLA6wGLXZd4onfVodVgsej7v9ooduftPkoHBA/NAMnGNQ7eTNdao3DpHuGsiAHytinA4c9RQu7thcMto6nXn/QmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3HtIQcd0aNUkWaafEYUPeqjiSythQRQnffIQ+3cy5U=;
 b=u+LsK7jkzRin4NE/qvv5kPBknValVa+EqPsaajmoEzHA+8gs90z8VNr9uIyqXWg3HwSSEX/XIHzfjgQgINi/t7pYUTP7ksN3HmXupy5Wp29l+pRKlepvevTO9E6FWsCqE0zrNqnNBWoYGo5jq/LM32kzQr9ze0xA0jmHrrtaVaeRkW9sNrxDDyK9pkTyLKNdM6ticVIh6UMAWxkaivNL9664NeY9TQ6OIE/7SCMns9zxcEggUNK77LZ04d1mXln8GxJJiArM21Llf8trQVy26ul7Y+81ZpVeWnt3WvDpjBGZY/0SJm0iDmLx6nSLW4UPLsJU8vOyIu5orYnhJarTnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB8073.namprd11.prod.outlook.com (2603:10b6:806:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 03:48:03 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:48:03 +0000
Message-ID: <2a814a14-2717-4363-838a-6585557baf1a@intel.com>
Date: Wed, 9 Sep 2026 20:48:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/23] x86/resctrl: Give better names to X86_FEATURE
 flags for monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0274.namprd04.prod.outlook.com
 (2603:10b6:303:89::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0bb99d-0d48-41d1-d3c2-08df0eee50ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|11063799006|56012099006|4143699003|3023799007|10067099003|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: tUj5AsBNWLT65BCplIBGp8kOu8oNG1VbJd4gNluOm4Q/WPZUSQpYmfrHs6JCzYcTjc1cGXW1rJJtCBB9iXuS+CnBKBuMmrYIGWkD0/Y5rxbbWYhZZ5gDiGgITGxFvVNCEUlM/hyk0CWC23p3bU8YFd02bdvMuSBCOoXRH4PilQoEWOKH5DUpubFKCYkVjUOW917WvECl/2FjUCfI47a4DSNs5ra9F47xb8kg/ZWheAnzDzx5bldnqbaNorvsj2gILd2bQGxugGf0yBvBZwufCxaa6ThZfYz8iW/uvG9s/9ei50DMK6+lh4EKNXZQzPXVSltGuz1EmPRoeGsSEAIzqykRTmYh53NDxmL+fUK6phMyV2+XaWI7B84+dVXtT5T7bj2TwmbvrFiEuXCCRKcMazdAgg0Giv0/AJWD8nOkpZrtaH4ktagg/5SaMjNnA1rceSpHUIdM1MkEch01xs6oMt9tnFYPpfUS2BU1fPDcuHLtPwRUe4gQ170QCxiX00LeAiPRWimEuUKaM4cFOw9BEqsGdKcYulCDsGh2qtpJtZ6AKf6kfuZv1lIvj9daVDPRKTniReNbEDF+66pGlm5OwavrjY+kfzphLDt9qyuROkEkTsEx5pTrAQRrzIm17Dd/eNCoxSoa/jj9iWxayqBNdbc5biOYFZ/d07YpP6GwltzOuot8Yha4fZFOGcpwetQ47m1BlolOOVQ6Tu9YZp0/Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(11063799006)(56012099006)(4143699003)(3023799007)(10067099003)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXcwY0lqS0d1UG4wOE1UaHdqNnZwUzgxeTl4MElKU3BUUTdqQXFIc1NYd0hy?=
 =?utf-8?B?bFg2RVd5a25LYXF4Z0ZWaGlQL05oK01uMXY3cFQ5K3QrR1pXM2RCcmpTRGVZ?=
 =?utf-8?B?SHR6ZVJUUElqWXJWYU9vM1prbzdCWmx0YlVkb3dtUzZiN3hFSGdsdnBnSFo0?=
 =?utf-8?B?NXArS0Z6ZmRWN2FBdXVWdDg5QUdodTFIVlhGbDRueDJKMkRXaVR3UzdzLzZX?=
 =?utf-8?B?RnN6dTVHNzlKUkhqWm5mOWRoNC95RmFNTFRQTUQ4TFhnNmVFU0h6SFAreW9O?=
 =?utf-8?B?WThwazdsdGt4SVR3bjhkNDNxblBTNDhSYzU3NExQdThKZHpVbDhEN2hEWlZD?=
 =?utf-8?B?MkZ4MmRpQ2Y3QkFrL1RsYVhWUERtdVQvY0RrcVZPZUwvdE5SK2prTm9kUHBY?=
 =?utf-8?B?T3gzVHM2bWMvcDExeWllaTlYWG9PZmJZRHczWXNMeFNCbE8wYS9GUTh2L2oy?=
 =?utf-8?B?WGJNdUUxeXpKeFlxUi9FUXJ3ak1ueVhVRjJEVVNmUUI2cnoyWjdPSkJIYmd0?=
 =?utf-8?B?Q2RLejFURTZYbmpVc3lCRi9WM2F1RG5WRldRS2lHNU5hL2s1Q2VBa2ZJOHkz?=
 =?utf-8?B?ZEQwdTlicThIOEhIck1uVU8vOXZKS25aTlgxaThTNUU2Mm0vVTQ5N1BLRkxu?=
 =?utf-8?B?dTFLZ1NYRTAva3lzd0kzcERqZHJmT3B3eDk1TnhaTXhyQVk3cWV1VnQwSEpG?=
 =?utf-8?B?VVJUdUxUdFcyU0QyRUE1U0x6eTlHR04vaHFLM2MyeHJ6Uk9hZndVNEdjSmd0?=
 =?utf-8?B?a21GdDVNSDl2T09Ddml3MStqdTgvWDkvOVJqS2dpKy9zblFNUkVtN0NYcVRy?=
 =?utf-8?B?d2Q4Nm0yTmhCYjc2NHVQTEsxUytoWDQrSUJoaFVSbjhWa01sN0RXR3ZDVmFW?=
 =?utf-8?B?S2JqNE1CWDRCNEJvV1BhZ1czY2ZmaFZ1ckFGaEQ0QmhyVmZWV2MweE9WVFl4?=
 =?utf-8?B?eEd4ZjlmejVTT0dmWCthOFhBb2N3cHVua1AxVjU0SkFWZzFUalZKbjRybG8v?=
 =?utf-8?B?bDNPQjJpbmloNU5vOHVhdThzU3FnVCtYMTNvdGJMdW1Xbll6UHB2OFFkQ3ZT?=
 =?utf-8?B?dGxKd1lPRlNmSXFJQnY5aDQ3R3UrdE5vZU9mcFlIOG4rUFNENWJabVFpY2ZT?=
 =?utf-8?B?a1o2NWVwSGllQ0ozcFlGMXVtSTVtbllqcnJMTkFYVFYzYzU2ZUtnQU9GcTNS?=
 =?utf-8?B?bEZUYSs0U0xLaFpZU2lGZ3FpUjlWNHptZ2szaTM5TzluMkFBWUR5OUlkU0gw?=
 =?utf-8?B?T0JFUGMwK28zNkZCVlRRT3F4U3Qrdk8vWGcwWWduTGk0L1MzVW1tMCs4aG9D?=
 =?utf-8?B?MGwrWDQ5eU1YcHdMSVRXakZpZzJuN2tjL1hQdGlCMGFDMkxkVUo2QnNMQnVC?=
 =?utf-8?B?VzZiRnBhY3ArR3ZZVVdzUDVubEkya011d1V2OCt6QUlyZkZRa01lNVVFYS9s?=
 =?utf-8?B?ZDZmam9iUGQ4NkFzaE9vbkVYVHpSd1hYcFhVcEEyb3lnbXY3czNXU0FwUnhI?=
 =?utf-8?B?clJxbkNCcHJXWlRCaGF6bTZyNDBxZWFGVmNpNnNCQ0x6Q3dDekNyK0F6UUJh?=
 =?utf-8?B?c0xMbjRPRmJ0cTAyWDg3dFVKUVorMEo2YVV4T24zTXBpSm5XZWx6aW9LZGlS?=
 =?utf-8?B?c3hHd0VtOWMzMEdnODRmYTEzdzlpRzh1QUJhc1RqTzhUeHB6TkZZVU4zbEVJ?=
 =?utf-8?B?M0VoekE3WEluNWRkRzV2d1ZzRTlveEc1akcrRFhaUXorSjc3SDA1RFUzNTJF?=
 =?utf-8?B?V3FoY1pRbktLaktMeURRaWNrZ2NRZkd1aVQySE02UkFGVG5Xak1HN2YxV1pD?=
 =?utf-8?B?U2MrenY1dzMrMy9nTldhUmxFMWlZeUhSNEFiZDVQZEltbGRSOVk0QS9JWXBu?=
 =?utf-8?B?cFBvVEJ4OEQ0YlpIRTNJYStUZGd1RjRIVkkzdXBMVHl0Qnk3NDdrSXBoVmQz?=
 =?utf-8?B?VkF1UXM3ckhucEZrSGZsLy9vUjM2VWkvdE1Ea2dJMnN3aFJFZnZGSWFnMll5?=
 =?utf-8?B?dU5xckp3MFNneG8rNGF1WXU2MmNPUHpzY0dRTTMza3FUdDk3M3FsaEs0NGt0?=
 =?utf-8?B?cEMyMlUvdWxGOCtjSTE3MFFibUxaWjZVcTJnY2pIdWF4TG85T2NiRE1Ia0lK?=
 =?utf-8?B?Y05BNWxVOGVwQmdMY1JIdzZ2aDR2Q0dDWlNVbkFFTWlDc3JBV0JRNHN3U3VI?=
 =?utf-8?B?Y2R1eERwS3oxUnVIUStDQTVrdUVtRUR3eWpDS2hEMnpnSTZvTUV1RzhGZER5?=
 =?utf-8?B?Q3NIcmFrUDJzMGtRYnN5TGtOeDNzdmZPTFd6bkNzWVlnQk1PcjRydGYxNGt6?=
 =?utf-8?B?UkhQNzduRkY1WGZwNHJsd0pQMW5Db040U2d6TExzcHZTc1pVK1RTeTJDNWZ0?=
 =?utf-8?Q?2/scTXTpJ1loelm4=3D?=
X-Exchange-RoutingPolicyChecked: 0Ub0FcfU6lYo2rMp88okV3Y1fdWbGtbA4F2BP9LLN0SmsHY6YoHBACad7uvfPOE7ExwJLnEpsDlWcEyG2zsJfSuDoxNnUvWISuF4q4HTrtGc+20Ddqo0iO1Fg5K7OfRU3V57ILB5nBCmkjSYQe5YeYFRmyw8OYUXOJ/PUujlnZoakx+sRYuTnNTG690UTwCSj8EGwYZdD1G0J6pN+c2KtCBKeY8fkGAZf7UOSNRKPYaKCOi8gnUXpP/BR1ANaxop29LuSSC1N8tdhYfjm4Lc1z2O2vzmG68/Qms2OwuZ0vfDLiQ7moNDK6kvzcCKqEXiRkwG6yRQ4FxXJhhRkvrpKA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0bb99d-0d48-41d1-d3c2-08df0eee50ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:48:03.6326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pLDS2mJRTFEiVZNFEKjnKo6kENm1XVpbksON0Od1A8B3Odq5WeFhkWfKU5Qcy4IDpSpx9WcFnGJ6/YsCglDE8NKlvah3xTiGiYsHJmIUII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8073
X-OriginatorOrg: intel.com

Hi Tony,

Please switch the subject prefix to "x86/cpufeatures:" to highlight the
subsystem changed. Considering that, the short description could mention
resctrl instead, for example:
	x86/cpufeatures: Give better names to flags used by resctrl

Although, I do have a question about one rename and depending on that
outcome the subject could be made more specific.

On 8/31/26 10:43 AM, Tony Luck wrote:
> The feature flags for enumeration of Resource Director Technology (RDT)
> capabilities were chosen when the only feature was LLC cache occupancy
> monitoring and they were given names using the abbreviation CQM for
> Cache Quality of Service Monitoring.
> 
> Additional monitoring features have been added to CPUs and the names
> are now more likely to confuse than inform the purpose of these flags.
> 
> Rename X86_FEATURE_CQM to X86_FEATURE_RDT_M (to match the Intel Software
> Developer's Manual, and for symmetry with X86_FEATURE_RDT_A).
> 
> Rename X86_FEATURE_CQM_LLC to X86_FEATURE_L3_MON since it enumerates
> that some L3 monitoring features may be present.

Considering LLC as synonym for L3 it is not obvious why this rename is needed
(more below). 

> 
> Add missing dependency to cpuid_deps[].

nit: dependency -> dependencies

> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index f70ee74b5f92..6a7f0adb123e 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h

...

> @@ -285,7 +285,7 @@
>   *
>   * Reuse free bits when adding new feature flags!
>   */
> -#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
> +#define X86_FEATURE_L3_MON		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */

The original name matched the description and since the description needed no changing it
is not clear why the feature name needed to change? I do see some redundancy in the name with
"LLC" as well "cache" making an appearance, but none of that is inaccurate, is it? The changelog
claims that the name confuses the purpose. How does X86_FEATURE_CQM_LLC confuse the purpose of
the flag?

>  #define X86_FEATURE_CQM_OCCUP_LLC	(11*32+ 1) /* "cqm_occup_llc" LLC occupancy monitoring */
>  #define X86_FEATURE_CQM_MBM_TOTAL	(11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
>  #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */
Reinette

