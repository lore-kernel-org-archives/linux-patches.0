Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5BF79CD
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749009284; cv=fail; b=jez2zD+R2yuGNRetmVVzvP90AvJKAG9HNP1UmdO37XMg4bptfl6LE12/Zq/jW9cvx5QToUv5ymgmy7fBbld/lMQ1Q20NQRyGico2Z3V50lnGbSDvtyKDTY68MDKD4UsMiJsW6B3zoIVew4vQnV2Kzvij0HzFavD/pmkvVT25yeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749009284; c=relaxed/simple;
	bh=RVLZ4XKIR8Lxx6p2JfcT/h29zh/ltm6B2ilEubvxq7w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O5vP+0d8XQejXXOrvNnpYUlZs4TnHaHhT4GPwvlVQd/yKvuLiyOH9l65Zwrjv1TW0ixAdDgTcA0uuW5DP0zl7klSbtY3k6v1vj/xHSbIvhlbo7hDtcRZRtAb0wp0Gk1b3kZFlqs0N4WNsJqG++borxri83giV94ZjXReI7ZstRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O/y2CuQe; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O/y2CuQe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749009283; x=1780545283;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RVLZ4XKIR8Lxx6p2JfcT/h29zh/ltm6B2ilEubvxq7w=;
  b=O/y2CuQe3bUg0NaNpOEZwvlTbP4rEH9Vio/T/aL8kJpG0u07x8/hl7xb
   cdhd/XP6zfwKA/kxz1Rr+VMlbff+FiZwBOAnIoc6XAbWrr6MFjPyCD+DH
   iB96ttXrF54cesUuIF4Qw4EIGAbYnLogCrZNrXKjEDpu4MfgSzE2OC/zd
   mCKDLySwukPC0LbD6c3eJVq3eBqimsYBpZuzhYsdaQxnn4UBdNxAPyBlT
   Dr6MxXKHTNiLoxtNAeP8Q7AteP0ayzvyA83CarF2MSh5q1m4sQM2JKwuv
   RnmgYj6v2ANlROKzcPkK/qNH/OKUWqsDsskmx/cWF1pzPWsBuBRMVeq1y
   A==;
X-CSE-ConnectionGUID: oH1wwnNyRAWvnyfeMhmtyg==
X-CSE-MsgGUID: 1H/TupizR3WA4TP8oqgsYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61735860"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61735860"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:54:42 -0700
X-CSE-ConnectionGUID: ZNKU3fNsQmW7L6haiH9vGw==
X-CSE-MsgGUID: ofNZr7gkSfyjtStegkYgSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="145027370"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:54:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:54:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:54:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.72)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:54:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvyUIbuDnI80Evl/nC+4nXBTMWmKJi+TldW5EEWXE3BJd6lCGzqgLcGHlackbkuyilKL9e1vwf/sNi4nXcX7PTPZrWwopJruWWYAPLBRilgmOqhZqV4iFyql0fCExAp93iYsTGlsSZ1hOBwQ+Nit/4DPLO2o+jsWMYnTNGn9CCRJSlOB8UnxfRK/XVVxxdGBbmraDfb40YiX9q2y50nu0CAsl5yiqg5B+wnT6QfSqkMoHiw8ylOQMlK6bk1XV/g+jqAJsMg8GgTiHUHZyBWDK3ZwZ2AVmcdsIas9O+AY3jCLxkc0Q65zJn2+a3xA+c7w7niDjYNz5PsT+f1cg7aE+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xV1XvKSVv4hoHlY4ArLeycz8Q1yLxm9LAIzS7VCZuhQ=;
 b=fv5fXZ117NiQFoiXpbIchWBl+UMlIEXpg842oMpeLkF2M4OplTzQUhE51tyIuWDzfj8puoDFmpUU71WcBApPNOTTVYhy+dcwtBy7wgOrSWFSI2MInrh54kaS+EWGrKQ2vrycE6JSk0BF+xlMasTw5NBLpELz7hZ+Br52KS7jnAzlRtpagkfGvIM/3XARIgkP83vDRRtyC+TX/QJJNqkmYZWg1VNHgG1KwbByFhWG84i793b/ZTAvyNVZyqZQ5k64dQlO1IfXjRyCOGL3af/gUeAabEaP8QCQMlxYdOGKH3ZqGJIwpSUK2SWQl4MnHuCxJu43mlXzrA5jBbMtDMz1uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 4 Jun
 2025 03:54:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:54:07 +0000
Message-ID: <368f30bb-7de4-4fc3-9706-3de14132984e@intel.com>
Date: Tue, 3 Jun 2025 20:54:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/29] x86/resctrl: Count valid telemetry aggregators
 per package
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:a03:333::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 421e443a-cec1-4449-ebcd-08dda31b7471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VkVrQnNiSmhJaytmVThoOU9SbW5iRmxrTmR4RC82MVdISmw4cXk2czljK0sv?=
 =?utf-8?B?b2xGU2p2M0F5cWpwT21yRGRnSFNHNGwyMVVRcGdIaGdFMHg4ejFWYXpsdHRn?=
 =?utf-8?B?cHhkNnFjUHNiVTVZWWlNT2REa0VMYjJhTld1eUxBR3VtYktXNWJ2eVFTcmxP?=
 =?utf-8?B?K2xaZ3FQZ1BrYUxmVDhGMFByMGU0UWlaWVplQTlPSjl6ZGVYSUJhRmF4cjY5?=
 =?utf-8?B?TzBlTUd4bGtPOVhQQmFzUUFzNFV6MnFZNyszd0NtczY1ZWx6ODFWRm5qeFY0?=
 =?utf-8?B?U05DYjZEYUtOR0dUMFlqV1VVeVBxUE5yQjloTnpQdEV3UzdkUSt0NGh3RnZU?=
 =?utf-8?B?Uk5Qd04rNWRXY3NSUXBqRHhYMEVHVjQza3FpNWhram0rT2d1aDVMZ2Q3T3Mz?=
 =?utf-8?B?QS92MC9PcHhBSzZRdFcxZlRmZ1BjZnpndVNzV0FRZlpwVjd5Z2RVb2RZaEox?=
 =?utf-8?B?UnV5SlBvQ1NkcFdZZkFSTm1WSmhBaWo1dXl4bmxSSUVCMFRBTlc0OUg1UGFi?=
 =?utf-8?B?ZkVZZnl4QlBha05UeStESlI3dVBZdUt4U1FoaFF6K05yYi9JNHkrVldkczAr?=
 =?utf-8?B?cGRtaWVuOHB0Q0RsaVR1dnU2Q0ZUK0tDZHAzNnZoNmI4S2ZVVHk1eWQ5VEJG?=
 =?utf-8?B?SXBhY2dES3BWYVB2L042RlA3VGdHdU1iWEppcEJvNWdva1JENHFycmUxb3Mx?=
 =?utf-8?B?c29TemszTEVvc2VBWHFVOUxwenk4YnJzY1JtNmE3Zm5VSnRzdzQrNkRrWVdD?=
 =?utf-8?B?djFOdXRuUXF5akl0cTFBTG1IT1F4ZXpMdFlvNmhDbkU2a1k2bDhoM1JPdDNH?=
 =?utf-8?B?b0thVk9QVklQY2lIZFIydExGY2JwMlNXdHJBQ0ZZNmFWTFB4aWFCV0wydy9w?=
 =?utf-8?B?MFhxYTN1MFd0TUNxR05Bd0d3ZUttUHRZMFJ1VmU4aWw0SHFxT2xkL3EyVE5W?=
 =?utf-8?B?aGZ1TUhEMk9MQ0hHTUFGT1p1bTBGZlhVSlpnbGZxM040RFNYZzEzYXI0R3c4?=
 =?utf-8?B?eHFFZVJwcFZBb3NnallTazlSSyswYVNSdlBVaDZmWUg2S1R1VE40WjRqSW5J?=
 =?utf-8?B?WTJMWEozdEdhanJ5cmZhWXZqSFZiTXBVa0wxVSt4UkVBb1B0TmgyeFlqR1F0?=
 =?utf-8?B?MnI5Z2FaanpscnQyL0RVYmdmeld3MlFrbVRiaUFNT0xYaXk2OW9WUkJtcS9S?=
 =?utf-8?B?WUdaR1NXOW9nUlVra2JIUE4ySW85dytOVHdCNzJvR2JrYzhVS0ZsMm1xYWxU?=
 =?utf-8?B?dlc4ZVRHeUxWM1RSclUrTlZmcDZxYXY4SklEZEdRNmtoYVplcGF2MVZUam1q?=
 =?utf-8?B?QUZhajk3VDdnTStvRElpM3VGQ0VoYUlaUXM0bndvQlpwVTFiaVZiMFpzeXY5?=
 =?utf-8?B?ZWJrUVp5MzBvVTFWUHRxVUhKbVd1YVVVSTFDMThzU3dNMlNtYTlaeXNLb05h?=
 =?utf-8?B?UjQ5cGtNNkhSRzdjQlYxMkNUYVFkWWdjZ0kwb21Od0VVbGRLS25HZVZBd0hJ?=
 =?utf-8?B?WU9yWjBuODlpZng1aFVLaEM1b1pXQU5KRlo4eXF4OC8vR1E2anNTcG5mdzJE?=
 =?utf-8?B?UVlkdWlHd3VFOVM2RXp6MWQwYk1ZL1FIcjhrR2VLTTBXT2ZCQVBzMlVEOE11?=
 =?utf-8?B?WjBLS0VOUGZkdnhtaDVlc2NLR2tvK3FxelhXRC9VayszcUFobUJveWVVVTYy?=
 =?utf-8?B?UHdOckM2QlFYTnd6YWhRT1UvRjN5Q3J4ZU1pb1hMT0VMU2ZVdDNuUW1tWC9G?=
 =?utf-8?B?ak5Vb3cxQUVZY1ozNHFWTlJPOXJzWG1lSnA4dlcra1U0Nk45NWJMNVdQNnZ3?=
 =?utf-8?B?V05pUkM2RE0zOTBFdVpQL0ZzRmNpMUZTTndNVkZxN2dvYXJUQTdSb2lJZitr?=
 =?utf-8?B?akJzTmNpWTN4NzFuK1BkbjYycTVxSkFCV2w2T0NjZHJUYW9oRmhhOXZsUTJ1?=
 =?utf-8?B?Y3IzN2JtbG4rWjlqV2lEaU91a0loSzhLMVBJK21rRkZtSlpqQWp3QnFJci90?=
 =?utf-8?B?Si93T2pwUG93PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWVOZ1BuNjlpU2dKRGFyS0svRXhxUVN0WDVYWmVJVEpNeXQ4aGZ3NzMrcmky?=
 =?utf-8?B?SFhjSWdTUWRBRTQ2QXF2S1c4RnBTbkRQazdDUWJwMjBKMUxZTUxadmRtSko3?=
 =?utf-8?B?UFBGcXFCd1NrVDNWaHFjS2lFemY2QjNBNzFVVnU4V1RGaTV0RkVBaW1SNUov?=
 =?utf-8?B?Zk9jOTFTZlpBMTd5NUt3NWlSZzFvc0lTampnRXdHWG5rNWxFWlhyU3hjUDBK?=
 =?utf-8?B?OVlLSHVBaG1UQVl2RUxxdHp1dHJ6ME5zK01pN08xdnNJblcraUpjUFRUMzE3?=
 =?utf-8?B?RTBpQnc3Wi9YNWUwakZYKzBnUmtnOEVwQ2wyZmwvanl4azVqYXhETUV3R04x?=
 =?utf-8?B?ZEg2RUl2d3ZXN3UxVGlrelZHaVMrZkxIODRVRG9UUnluTlRnMHJGcTJRaG54?=
 =?utf-8?B?VEZ3S1FrRG1wWURRcm8vU1FKVXcwVmJUMjRsMTVYNEJlM2lPcDByNGxTQUFu?=
 =?utf-8?B?NHdsSEJ3T2JOM05RMG5yNVZickxaVDJkRTFISWxWeDZiUjg2U0xNTEJGUkU2?=
 =?utf-8?B?c1prK1graTJ1ajIzNHFVYmFRaXhyanJvMis2TlZNLzk3akMvL2V0NHdtS0lU?=
 =?utf-8?B?aWZFMUk4M1lqd1d0V1VhZjBBckRrWC9ZbjBJNVVvWklYSVBzYW9uRnZFdEd6?=
 =?utf-8?B?RnZGZ0lNY2dNVGJ1NUJteVhhRW40NGpUVWIwdU5xd1psS0lVNUhOUVhsa2R6?=
 =?utf-8?B?WE16a1RXM2RuUlJIRFFhYWQ4Sm5HN0lncnQwTlQ5dnYzcUp0S0JiWXkrZldL?=
 =?utf-8?B?MnkzRTBzQnl5bXV2eElmeThhNUdwWjBNRklyMmpDS2tsdWwyNXJCTG5lL3Fr?=
 =?utf-8?B?cHFzZ2VWdFdIYTdoZXc4RUN1VnhLcno4NTFhanloRWx4dHdBSEVUUTAwS2pM?=
 =?utf-8?B?TU5nQ2RmZm4vNW1NSWdKN3BsYXpFMDVOdGU5MlI2QnVnVnJRV0IwNHFnOGJh?=
 =?utf-8?B?MGg1WUxJMGdsTUNqa2k0YjNyc3hXeTVqMk1GRDEreXlrVnFzMi9nclExZ1hY?=
 =?utf-8?B?TkZyTkdpTlcrODRLSitvSWd0WGw4NjhYeVRkRkJvWGMyTnpDWmZ4cjRaRFBs?=
 =?utf-8?B?MjFMUVZ1VE1ZRG5lWVFiamtRV05JcWlTdFFYckpycjROWHUrY3U4Q2QwYkh5?=
 =?utf-8?B?VmZGRDJSUWNQS0VKTStid2E5L09HeTNuejZXZGtRdTV4NnEwWWlkL213aEc1?=
 =?utf-8?B?em04ZzlqeXhyZ1JlOTc1em1rN05QQWx3UW14cFladkhxcmF4N0xTVmEzTmlI?=
 =?utf-8?B?dkt1dWRVWUhJNzJNSktoZ1luWjVRMTE5eTlQQlRoUFhLRDBVU3dxRXNvMERD?=
 =?utf-8?B?ZWpVN3haaFM5R0liOTVFMlM0UnAwNnl6UWt0UjFWblJReXV1aXhiaUc0ZzM3?=
 =?utf-8?B?aldpSHZZVnRIVGpZWXdoV3BNY3FGN0EreDY5a256dTlKWWFUa3VNZDgra3da?=
 =?utf-8?B?cEZXeDcwbm9NWDZKcFNPTExNWTJKWDhodnJGQ295ZlkxSjRRWE1FOUREeHZM?=
 =?utf-8?B?NlBGUW51V0tsSFA1YmtWeXNHaWovOXIvUE85dVdZdGlYVXpmVlYzTlZWRThY?=
 =?utf-8?B?VTQ5bUJRcUo2UkRJRDJXeVpIeTRta0pZODNSZFdway96VVppeCtsWk5zTklj?=
 =?utf-8?B?NHRlMEhiWHJWcWJsekpzUUM5aC9aQVF6V2NxUlRvMzBaWHBjSHNDcTZMY1FX?=
 =?utf-8?B?QUZ5NzF4V2RoWmNUalpranNBLzBnQldRUDY4Q2V2TVh5RGp0T3JJNm83WW1T?=
 =?utf-8?B?SVNscTYzaWN4c2ZienM1OU5KUWIweVNEQWRlRlhabVhmWDhkb0c0Z3UwU1NM?=
 =?utf-8?B?SzFBMlF0V3FPUGpod2RjMnNXblRQcTR4ZzhvOWtFKzE4TytKazBCSXdWTTlQ?=
 =?utf-8?B?ZlFSTDltZnN2VjZtQXgzMmQxdmtHaG9hV0ZGKzVmbUREQWprTEZBRUNxcTRr?=
 =?utf-8?B?aHZ1S2w1OTN4cjVIV0JHWnJZUGJmWi9MMWNBUEJMaFJnRUVFMW81ekFjU3NI?=
 =?utf-8?B?WlNyNVJyckVtV24xbVNtTE5qRDN1b2pKMGVCSUlLSDVTRFZZQXdQZ2tldnV0?=
 =?utf-8?B?N08xV0R0MDNKcUczM2k5bXJaZUY5R2g2ZUYrQmhCNUIvc2pRK1pPaVByVmVt?=
 =?utf-8?B?ZkdyRjc4MG9CWVpuNTNWRWpBMVRZNjBMMzQ0TU9iaXdQUDlqTmExWVo5MHd0?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 421e443a-cec1-4449-ebcd-08dda31b7471
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:54:07.1271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIdtd9kF/f5ovSLqX3i/VQbgkN25hUZzHx9JbPPavj+Dg9HzG4aKbRCr2KFLH9E459iycFj6zI4Ay4wjHqQVFOJQJvI1uu3A0ksl+JfCpbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> There may be multiple telemetry aggregators per package, each enumerated
> by a telemetry region structure in the feature group.
> 
> Scan the array of telemetry region structures and count how many are
> in each package in preparation to allocate structures to save the MMIO
> addresses for each in a convenient format for use when reading event
> counters.
> 
> Sanity check that the telemetry region structures have a valid
> package_id and that the size they report for the MMIO space is as
> large as expected from the XML description of the registers in
> the region.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 45 ++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index df73b9476c4d..ffcb54be54ea 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -14,6 +14,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/resctrl.h>
> +#include <linux/slab.h>
>  
>  /* Temporary - delete from final version */
>  #include "fake_intel_aet_features.h"
> @@ -26,6 +27,7 @@
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
>   * @guid:		Unique number per XML description file.
> + * @mmio_size:		Number of bytes of MMIO registers for this group.
>   */
>  struct event_group {
>  	/* Data fields used by this code. */
> @@ -33,6 +35,7 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	size_t				mmio_size;
>  };
>  
>  /*
> @@ -41,6 +44,7 @@ struct event_group {
>   */
>  static struct event_group energy_0x26696143 = {
>  	.guid		= 0x26696143,
> +	.mmio_size	= (576 * 2 + 3) * 8,

Could you please add a snippet to the struct description that
documents what these constants mean?

>  };
>  
>  /*
> @@ -49,6 +53,7 @@ static struct event_group energy_0x26696143 = {
>   */
>  static struct event_group perf_0x26557651 = {
>  	.guid		= 0x26557651,
> +	.mmio_size	= (576 * 7 + 3) * 8,

Same here.

>  };
>  
>  static struct event_group *known_event_groups[] = {
> @@ -58,9 +63,47 @@ static struct event_group *known_event_groups[] = {
>  
>  #define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
>  
> -/* Stub for now */
> +static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
> +{
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
> +			     tr->guid);
> +		return true;
> +	}
> +	if (tr->size < e->mmio_size) {
> +		pr_warn_once("MMIO space too small for guid 0x%x\n", e->guid);

With e->mmio_size hardcoded it may be useful to print the size claimed
by the telemetry region.

> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Configure events from one pmt_feature_group.
> + * 1) Count how many per package.
> + * 2...) To be continued.
> + */
>  static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	int *pkgcounts __free(kfree) = NULL;
> +	struct telemetry_region *tr;
> +	int num_pkgs;
> +
> +	num_pkgs = topology_max_packages();
> +	pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
> +	if (!pkgcounts)
> +		return -ENOMEM;
> +
> +	/* Get per-package counts of telemetry_regions for this event group */
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +		pkgcounts[tr->plat_info.package_id]++;
> +	}
> +
>  	return -EINVAL;
>  }
>  


Reinette

