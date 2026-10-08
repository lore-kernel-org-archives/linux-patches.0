Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A687A389458
	for <patches@lists.linux.dev>; Thu,  8 Oct 2026 22:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791498126; cv=fail; b=EU182CIP07ggV/wv/XKXj7TECZftZ1u/a1qSwsy602SKQhhOugfzTX6LByjJxYzSX1erlqijkhN+r6cR8yTZUWqJEiDHed9GpUvR1LJl6MGaqHjtRCCkbeCIGK2E5X4llPm6lnIx6wKCLkGL3O+megzLeSQucGucLkv7dmb8aZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791498126; c=relaxed/simple;
	bh=rcJf1EbBFltFpSxz1QJvVtnaMBXFaxLPKXHcHK0MDRM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BrJxgSIjXLEcYK4xE77Yys5MNlvYv1aGem1KfsO8M7F6SpowNqBdb3CXGKjZa2QE6M6zjwaYlOxmYF+dt2S7h5wccP2R6W/PLei4zZMjIhg+U2BsJflnafvFhlh0CoXwwXoDH+2Qwzp0362KMqklqw05yyymy7JJU6mZO73tdcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ADQwh7oc; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ADQwh7oc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791498122; x=1823034122;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rcJf1EbBFltFpSxz1QJvVtnaMBXFaxLPKXHcHK0MDRM=;
  b=ADQwh7ocVHlaYFpE76aIzR13kW2DXGD4RCJ9buYUeXHMIFygwplTUIzA
   Yd2zfl3yWTH4sZcM2kA5zPurTsgHr8Seelvu8FWKHj5SXUK0FnX8bAywc
   DZ2t2X8cCuYfJGJr07vEkWme1NaMsyjRd/zfaA87wlB2dxZdE1ASqRlSE
   rr+qV/XhQLvtaQdqWphVQNNaKaYm4Go0FgBg9yoQb7yPVxh7a775lrAlZ
   +rAUVCiXgVjsq+y6nCkmtMY05MeQ/D5y38GuQ2u+Gb4IQudK918vkr0YX
   TUUqvI0+jiqJgqkdN1yWCIOEcmI47rxC9I4y9bLcU4ZzJf8q+oQKI/I9N
   A==;
X-CSE-ConnectionGUID: 1cL2+/LYRCeh/90VpKba5g==
X-CSE-MsgGUID: NU4miJ+kROGLlCbDazTFgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="405082"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="405082"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 15:22:02 -0700
X-CSE-ConnectionGUID: jGTdm71YQsuUYifD8qEGig==
X-CSE-MsgGUID: L88fTPvGQ1azDg1avuQX+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="603437"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 15:22:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 15:22:01 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 8 Oct 2026 15:22:01 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.11) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 15:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAw7xVwc8VXgu9/vvb+lC6w6DQDC81my7+zJ6pgafVcaV396KtAH1evw9QRAMMYXPUw5uyCB+BWRQA4ZPtwC7TEa1/irgnLkeQciEsEoaAtrHKDDtlxYbD0UAfC/rmt1RGDtuVfyNPAQwcm4fd8u4AHa8qJwWElM7Cnh+owKVmfAH9daSXWQvHRFWUHX5S7L9Nv4bkLaGnUU2VcgK8K+hwftNE5Zpz1oU//Fx3W2z7D/6Lhrbj3GMsEa6s0UzcmUxb/b0fCMBj7ZNs1fwsG//fthi2efI7YrUMeZQxLLbMhdqFjyE57HWghnTPgAe1fJFD8VLPD/2xnInHb1gyS+HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvcoEXlpj0jKyjV1I8Mf+afWhQa12aEyv02eXBng5Yk=;
 b=O1Ridy5MWOd/3f/lrDY4jebPgRuR+B/B8TFT76WCv3z900w+4egn9jgLWB6hBH9tWOqQ920c8LVcrdRgm9rBR/COQg2Uk1eILmKxQKcfJas7uo9veEBxXuUIyH9evVJr7vaFuG3vreawQQSoCF74Vz4GOHqcFFYOOttBF7H9mw5AaN/1i2lsQhzfioiA9DJqddx/wbKqh3sHNqFzt8ZcjSYJvHlBm+2inLATWnhb0HH7J7HzifUmtOnVszyKHZ2EaFPX2xVWBSlCW3zy+N3legPWq8XEwtgcnZmtKoME7z7DpHYWV0PpC6BXLxF7unPYtqhFn1DSGoC3SAMj8KYuRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by DS0PR11MB7335.namprd11.prod.outlook.com (2603:10b6:8:11e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 22:21:52 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 22:21:52 +0000
Message-ID: <c96110f6-d947-4d56-bc49-205ad2ab9632@intel.com>
Date: Thu, 8 Oct 2026 15:21:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 01/25] fs/resctrl: Ensure default group reports tasks
 on monitor-only systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Sashiko <sashiko-bot@kernel.org>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260928221509.68002-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:303:85::9) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|DS0PR11MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: 083506c4-f51e-40ed-c041-08df258a8dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|56012099006|4143699003|6133799003|11063799006|10067099003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: BqzL+tmnL2vo+Fc5U5AGiMrW5HUuJG/xqTeNOYF1KkNtkvcfP+1IiSgrv4IxPmV0r2Eu78lypQhTCQvhYQsxPQR1hVWfmOlZnDA2cuskDs2qIT1pwfByMaaUSnoRT/YH5JpZTnJLW+1dpbuTF6tP2ZWiBoEdiUVPrmhDnjb4hQSb+a6xUIDyQs1Ms1233p3y2kPQeRboGGpEMTKCoLBXV/BXbhPoRlLEPCaUXpRGwxtVruxN24Xayy0M74F9bRxNCZRy4e2HTA8Oajb5eZbg3x0Pn1pC6n6h8hIMmH/LV/TGoQ+Z5cnb1SJ9yNOZ+szAdz54zIYk4+5ixfhtR+68bjbM1HjGFaNYr26oqDOMWt75AhGw8/k2Dyz1syKWtWVpvaT/Q2GlNXy4phorNf7F2VHP8+OKaQ0VpGRdWkbHHFpeoVUe6ZYPBwnH6CSJoBPdVWuRTBFZpSR4V9zFva8NslnsqGkHZrwE4jTBDqNsSm+QG4P+5DyCL40QGKO2zzDxd3oTGOsPk/vyAs5MCI6grd3sn/9EIxpQLlimeXeLwdrg7/WxmTz5T8hYLlUvsySG2f92fBspxF4VCrKOVp0NvhXqPb4QNCyd3ZSXFY9pg1rVcWz8878x2i/EpZhs6iqhbp2/px02cLSL5TTRdgWMZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(56012099006)(4143699003)(6133799003)(11063799006)(10067099003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDJsUktubTI2NHhFVldZbk1ENkQralJnYjRucHBUWFF2Ry9OeERnTy9waWhz?=
 =?utf-8?B?VWVJWGtzTmQrdUQ5UVRpcnNkN2tWeXVNekZSVG5xU2cwNU16UkRGZzdqY20x?=
 =?utf-8?B?N0c3U0VNWnY3WnVSaUFYL2tTdEtEMXdkbzVwRjNIeFprZmtKTGlheFl3UUJv?=
 =?utf-8?B?Ukt5czNIZ0puQVRiT3diNklFQldnU2xsQisxckdFM2J4bEMyeUQ2QjBoRXM4?=
 =?utf-8?B?SGVLMU9ZdCtrdWVndjV5NkFjOGJkS1RXbmp1RER4Z2FiY0FDOHMvZUVyZHc0?=
 =?utf-8?B?R1FOL21La3V2ZmZGUkZ6WnlvVFRpQzRTS2YzK1dPa0RDTTNJa3hYcEdla0Qr?=
 =?utf-8?B?ZVlrdk95TVBCcmpQTlVRMUlxTXVJRDhXL0VOa1FWOWNYM1JJOXJwSVJ3UzNq?=
 =?utf-8?B?Y2djaldiT2dnb05CUzNtVTQzMGQ3VjRLS1hNbm13dVcrNFhBUTFKWEdaVWQr?=
 =?utf-8?B?MlUzWGlzT29nVmM5aEUrUDdvTGl2USsvT005LzRaaTlRUUJGM1AzSXpXbkFX?=
 =?utf-8?B?ckFxUXJlRlp3M3Zwbzh2c3lZVlVCaFVlQ3hzOHpEcmIwUHVQYTZGdTJWQ3hM?=
 =?utf-8?B?bzNaK2xycDZRSCtzQzJqaUtVRDBJYXQvcUlCNFFvUC9TZ0RtRXRFVlVHbnha?=
 =?utf-8?B?VWNkaHgwL1UzZXk0SXhiZzBEbWV6eTRxQngxL3E5NGNUQmFjdHJVZWtwS1A3?=
 =?utf-8?B?TVdRRm5UUEdLQThpVTN6Z1hjRngxM2ZyQzhsVzhFZ0hyQlIwOHBiOW45TzQy?=
 =?utf-8?B?RHo1Tlo0MDR1TG9RTUhKcXZ6TW9wM0VVMXpSWXQ3QWdtaHQxeGtrTklVZkt3?=
 =?utf-8?B?WmplWlJ2bjhRV25qY09iU1BWVDlHOGRZVHlrK0VCLzh6NnV1djJ4RzJ0bzI2?=
 =?utf-8?B?K2IxQkxFdlV2N0hncnJnTnhKNXhMMFo0OUxDUHVZeC9Zb1IzTE9JaFpITStE?=
 =?utf-8?B?N2VVdUVXNURpMGJqOSs5Q2pKYWhTSmFuYVc4a1ZLUTdqQkF4Z1kzV0lsNlVW?=
 =?utf-8?B?dG9MaHI2bVFBVTdZS0t0R29zaWxjSzdCRlVub20vRWN5enhFTHJZc0Z1eUxS?=
 =?utf-8?B?SW9uYm5nNTVDRUxFekVNS0Q5N3NtalhYd2FUdTFCaVh3RS82STFMaC9RSzZs?=
 =?utf-8?B?d1BPMnI5eVU5UDNsQVZkaVBGaUt5MVU5WnZlc0pCWHNTWG1zd2dOTlJlc0l4?=
 =?utf-8?B?MHNlaWlaUmw3RWxjNGUyTVFvNzJXODNkUjVlaVhiUXpiNG5mcDYxQjNaSml3?=
 =?utf-8?B?RjlpKzBmOGtYRGhZZlZlSXh0Q1c2MG1PcEdJcC8xbzc4VURBbm9idy9EY3Az?=
 =?utf-8?B?TUd2a0o1TkRTT2NLaVhEc0ExSmRWMkVORUFQYkJKVWV4OCtTQUdWbFErRDVm?=
 =?utf-8?B?Tk1HeXppTGFtbDVBUWJhMUNqWXlJaERUNXgveitVaUthb2orOU4xalhLdzZZ?=
 =?utf-8?B?ZEoxN0twMHpVOFJPSUV4ck5saWd6eTNDRTNPRUducVpsRGswelUxWnBYbVp2?=
 =?utf-8?B?S3FvWklOUVZ1ZnE4VHhzQ0J1T1pURlg3L1hGenB1REhqditpTU9QNU5zQURt?=
 =?utf-8?B?TWJWa0Z5ajJoanVrZ3ZzQzEwa3F5TWc4UjlMM2Q0bWhaZzNGb0tURFVWd0Vq?=
 =?utf-8?B?bWhqUDRacWlhVFVYcERPLzdtNE9aUXMyTzQwbUU4am9ta3pEUlQ5U2hIMnBU?=
 =?utf-8?B?TUR4VDNrYzEwYk80cEFrUFJFMm5MZHN5cXVmZTgwWjBhOSsyZTFUM2xvRHdq?=
 =?utf-8?B?ekEvTEZrWGJLZ21uaGZhbllCelNTVjdRdDd6bVg4eG82Mngyb014cHpPd1cw?=
 =?utf-8?B?TThobjZYeEVQTXVuRlNZSWFuRTRYTVBwUWpWOWxrNWYxMXEza1ZDZFB5bVdl?=
 =?utf-8?B?WXhTMHErcWRUV1VDek4rZmlCeWRRalQ2d1hteGtHTGd1akdsaG1qRjdwZEpk?=
 =?utf-8?B?UmVJQVFHSzNsVXBicFExOHdFbkE3SXpKaVMwQyt4Z1d6ZUNvUXRDVnJZTnE3?=
 =?utf-8?B?WUdaYTR0ME11STgzVHFxSlNkTDgzaVZuNTRINnNmUm9DTkpyRThGcnhrUkxH?=
 =?utf-8?B?d09HMitRTFdVN1M5czA0OThGeG1kcW9HOHlMMVNSZ29qbVV2ekZ0bkNtSVhs?=
 =?utf-8?B?VzduR2NKUDc1QlJzYldraFpXaFIzVVpwVlMrZkgxVXZZazdkZVg3RzZpcndt?=
 =?utf-8?B?Q0lLbWFXOEI5K3JLZUxPZmN2YXR0OW5Uc1REdU1LMS9hMGVrS3RUd0c2c0JG?=
 =?utf-8?B?RFBaNytqNVFmcERabjdHYlVGM1o1UjdvUENBNXBxcHFhRDEyeWtZakN5Ykpl?=
 =?utf-8?B?dXQvR2lOeG9nUU9RUHBaOW5hTmVkZG9GMnVaRjJDSVJyd0IreHB4K0Y2NFBU?=
 =?utf-8?Q?TTmegJ/T5h3QCuy4=3D?=
X-Exchange-RoutingPolicyChecked: wLWIvW3xfapHJjaOBM7SWJQzsvCe9wOYfI5NT4L209VkN5FR8LaELh1bH/Vs9MJV7QysyAcyfXPz6Y6t7S/u3NLRK3Ie4Mr/2rJJeSDuwdpHLPvl87OcUZicqaj86v6EgkO9pNmGusbeMtKP53iECqKN4Thbho+0d8aQXT8RJ3xxVMWjLRAnBy/sW4IygSKa8O43Rlh6sGlb6oVfthUa48OWg2VYyZ3el8bj8eRzaQNHf9Gr30Mphpwuir/XSYH38Fsnw3q00MtczdMipfyzs/WgiGZnemJH3nWmc21tweCvaJIhdFxfZJ6ptE2t4Bm1LJ/72/OU2f827yvvkVi95w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 083506c4-f51e-40ed-c041-08df258a8dcb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 22:21:52.6072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfP09S6DhoeMwIGEIAyungTPah8ifkIwQ8gaAciTfZrhBm+0ErBFWzbM3UgI2asWRlkTizjOMZPLImHHMx8o+FbUK3htGUEWDXyMLUIxnJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7335
X-OriginatorOrg: intel.com

Hi Tony,

On 9/28/26 3:14 PM, Tony Luck wrote:
> This is a pre-existing issue, but the resctrl_arch_alloc_capable() check in
> is_closid_match() actively breaks the default group on systems that only
> support monitoring capabilities.

It looks like my comments regarding tip changelog requirements are still being
missed. It is highly time-consuming to manually verify every claim made within
these changelogs, and then separately draft feedback on where they fail to meet
the documented tip requirements.

You inspired me to automate these steps. I created a "changelog checker" that
automatically verifies the claims and checks the changelog against the documented
tip requirements. These are the standard, straightforward expectations for our
submissions.

The tool will handle reviews of your changelogs instead of me so I don't lose any
more manual review time. You can coordinate directly with the bot's feedback now!

Here is what it has to say about this changelog:

Verified claims

  - rdtgroup_tasks_show() → show_rdt_tasks() → is_closid_match() — CONFIRMED (that is the chain in
    fs/resctrl/rdtgroup.c).
  - resctrl_arch_alloc_capable() false on monitor-only systems makes is_closid_match() return false for all tasks —
    CONFIRMED (x86 returns rdt_alloc_capable, set once in resctrl_cpu_detect() and never cleared; rdt_get_tree()
    permits a mount with monitoring alone).
  - The default group has type RDTCTRL_GROUP, so is_rmid_match() also returns false — CONFIRMED
    (rdtgroup_setup_default() sets type = RDTCTRL_GROUP; is_rmid_match() requires RDTMON_GROUP).
  - The root tasks file appears empty — CONFIRMED. The file always exists on a monitor-only mount; it carries
    RFTYPE_BASE, which rdt_get_tree() passes unconditionally.
  - A RDTCTRL_GROUP other than the default can only be created when allocation is supported — CONFIRMED
    (rdtgroup_mkdir() gates rdtgroup_mkdir_ctrl_mon() on resctrl_arch_alloc_capable()).
  - "whenever the remaining resctrl_arch_match_closid() check could meaningfully succeed,
    resctrl_arch_alloc_capable() was already implicitly true, making the test redundant" — FALSE.
    rdtgroup_setup_default() sets closid = RESCTRL_RESERVED_CLOSID, and every task that has not been moved keeps
    that CLOSID, so resctrl_arch_match_closid() succeeds for the default group while resctrl_arch_alloc_capable()
    is false. That is the case the patch fixes.
  - Fixes: e6b2fac36fcc — CONFIRMED. That commit introduced the capability test into the tasks-file path, and its
    own changelog asserted "This is harmless as rdtgroup_mkdir() tests these capable flags", which overlooked the
    default group.

Findings

  [R18][R9] must-fix  The safety argument contradicts the bug being fixed
      The last paragraph concludes the removed test was redundant. If it
      were redundant the patch would be a no-op. The default group is the
      one group whose result changes, and the parenthetical that excludes
      it from the first sentence is not carried into the second. Scope the
      claim: redundant for every other CTRL_MON group, wrong for the
      default group.

  [R5][R6][R24] should-fix  No context paragraph; the problem leads
      The body opens by naming the offending check. A reader has not yet
      been told that resctrl can be mounted with monitoring only, that the
      default group owns every unassigned task, or that CTRL_MON
      membership is decided by CLOSID. Without that, the problem paragraph
      has nothing to attach to.

  [R12] should-fix  No imperative solution sentence
      "Removing the resctrl_arch_alloc_capable() test is safe because ..."
      is a gerund, and the patch never says "Drop ...". The tip tree asks
      for the fix in the imperative.

  [R8] should-fix  Three paragraphs re-derive a one-term removal
      The indented call chain, then "is_closid_match() unconditionally
      returns false for all tasks", then the empty-file effect all restate
      the same single condition. The user-visible symptom plus the reason
      both match tests fail is enough.

  [R20] nit  "This is a pre-existing issue, but ..."
      This addresses the series reviewer, not a future reader of the
      commit. The Fixes: tag already conveys that the bug predates the
      series; such notes belong below the --- line.

  [R13] nit  "actively breaks" — "breaks" carries the same meaning.

  [R23][RC5] nit  Prose uses `type == RDTCTRL_GROUP`
      Documentation/filesystems/resctrl.rst calls these "CTRL_MON" groups
      and the root-owned ones "MON" groups. Those are the terms of art a
      reviewer can map to the interface without opening the diff.
  Tag ordering (Fixes → Reported-by → Closes → Signed-off-by) matches R21. Wrapping is 70–76 columns, within RC4 —
  checkpatch's single "Prefer a maximum 75 chars" warning is not reportable for resctrl.


> 
> When a user reads the root /sys/fs/resctrl/tasks file on a system with
> monitoring capabilities but no allocation capabilities, the following call
> chain occurs:
> 	rdtgroup_tasks_show()
> 	show_rdt_tasks()
> 	is_closid_match()
> 
> Since resctrl_arch_alloc_capable() evaluates to false on such systems,
> is_closid_match() unconditionally returns false for all tasks. Furthermore,
> because the default group has type RDTCTRL_GROUP, is_rmid_match() will also
> return false.
> 
> This causes the root tasks file to appear completely empty, hiding all tasks
> on the system that have not been explicitly moved to a monitoring group.
> 
> Removing the resctrl_arch_alloc_capable() test is safe because a struct
> rdtgroup with type == RDTCTRL_GROUP (other than the always-present default
> group) can only be created on systems where allocation is supported. So
> whenever the remaining resctrl_arch_match_closid() check could meaningfully
> succeed, resctrl_arch_alloc_capable() was already implicitly true, making
> the test redundant.
> 
> Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
Reinette

