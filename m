Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F511DF751
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743464989; cv=fail; b=ZOjdZzuEggFO0dH+GmMep1enFRa74+GFRioBxPqcdZq+vP3/+9bZuGHag/dJJA0mRFokd5tSf0DZI5qWyCFVuhUYitZMmDmKJe6MctyMBaInuEwY0lDrVG3nYdVuUkDrs48R61lSq3kVKO0TWldCFXQKv20oIPcujcomwa1fvJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743464989; c=relaxed/simple;
	bh=1p3vRv+d5+eboC/5+GGzE5gP+Wg6smK147XmV8pyt14=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cJlyTDhBzjFwcjGcTINI27ee6dzDDDylYuHoSkzOrkZCucWOiUZAleZ+lcymDfqMzPH693dGS055BCjlKKtNeMFye2gkpmkiaG1m1iWTFI7t3L4t8JuBsgsDPxdfWybXPB+wqxYn+Xn39s3N6vtuVnmXnWdb8A8CijlSM97S7RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScaqztHN; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScaqztHN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743464988; x=1775000988;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1p3vRv+d5+eboC/5+GGzE5gP+Wg6smK147XmV8pyt14=;
  b=ScaqztHNSYO7/tpgvuUhdSjjbGPMzfxQa1z9IoXZ9TnUbfkRAUCAgjRq
   URaXhiqu7RcO5tqN/6qrUKbbbKMr3tkcldaVSNRA9rK6mLv2ptc3ihVW+
   sJwUTswnq7usr+xZsCMCozKmZad2BfmjJVYGCCWOevkETZUquX7QOY+DJ
   8Ti/qOsql0YJPfxHDOiyYcRsmkkPK7TWENbKFf9gcT5aOwbD+1haTb3QS
   gMqYMpw1WRFPsuNRbYtMFv69IsGlKGENi7LbyVx06uiJtfosv0dW6DSBz
   y73z/gGlnbAiuUSXPbyFXlaDAf3Rs+pUIFmW8rx+J+Ai2y/+PzXrk8CSo
   A==;
X-CSE-ConnectionGUID: AYjBtjfgRh2zPCdL1Kf9DA==
X-CSE-MsgGUID: u15XfbSVTw63uXMjzNrG7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="48558369"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="48558369"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 16:49:47 -0700
X-CSE-ConnectionGUID: Ubas0hPKRxO77sGk/2uJrw==
X-CSE-MsgGUID: fP/s4RqbTquZAkT9Q+W24g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="149414351"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 16:49:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 16:49:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 16:49:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 16:49:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8EiDWAdSBtEfuDtC2X+DOUXYphjLEz3XAc2op1XHZiJ5S/x5pxB7n8EM48bTqvhj0khyIc4JYCWgw8WIw7ahtENtesoqIvfAf9VckGKoyPcK0A7yzdwGz/xYapweWJyANNrcw02PvaI2T5X69Ig7rTGQrAeqk3Hyu4PSlYcw+QWYDgSyWCaAai7Uj60J78SAa6nK9n5UCa9J8GGY3yVxAfRc92rTeGG6BgrqqszxPh1yoGIxy6TGo+TTSzDssyos7izSnyJcHjxm6LKpLmfNvbrwafX94lCgn8YQugU6Tjj94W3oBCrCb65kBhg0cDJIWcovoMjw7Nyh4mFs+O0HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zxNW3LUmmWdsqI7uR03ARyIN7D/eZb2fV+1feAhU9E=;
 b=Lj6xi8aPtYULaq/25jLxqMgdtQ0NXAV+dwdtwWPZn77SpJDM60y/4WHStQJFUZzE6oeYF+jaqwEJt6Vs0mkeJiD3QLynRVgpGocm3drDGBrktF/rvyEMprZjSHrr4X4FW9V3ovYiBXmQgMWHKDnLL9TyLXvHN/st51/jLQlSWc11YkbQt7gA7kiY0YKnp+KBxLm9vrlBsmSARulXggVMRhBD89QecVRa7J5sGWdhbXXrfo0PZjSRy9wC1iZUM8P8Jpvo0uLUlimq7m4+VKmOLcvhhteZeN7V501oDZ2ywf3Y4TU2nZWrCMnP/YtMA60BVTk5pgdK9P5iCtBTNy1mMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7576.namprd11.prod.outlook.com (2603:10b6:a03:4c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 23:49:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 23:49:27 +0000
Message-ID: <f323fa5e-61b7-486b-931d-289f561fc4d8@intel.com>
Date: Mon, 31 Mar 2025 16:49:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] x86/resctrl: Add and initialize rdt_resource for
 package scope core monitor
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-6-tony.luck@intel.com>
 <1dcd185a-17b9-446f-a19f-fc2355c4c6ea@intel.com>
 <Z-sHjRxLDwGDP68i@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <Z-sHjRxLDwGDP68i@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:303:dc::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc76563-2398-4c93-19ea-08dd70aeac16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?amg5RkdFdHkxd2FWYndtcEY1Y2xrNkhiWGVSRXNHTTh5VWdoVzd5dWg3ZFdH?=
 =?utf-8?B?a1FBaTIrNFdiNG4xUTZKbTAvV0M4UTVtd0ZtekNPQngrU1pseVUzcGV6WmUz?=
 =?utf-8?B?czlBeUtuTlk5SWZDc2dLQXZyZkI4Z3BXcE5pWW0xM1Rpa0F6d0xZQmtwWW5C?=
 =?utf-8?B?QUk2Smo0YXphSmlsd2lCelJ3Z0FFUlJoS0k3UDVrQVllZ3NzdkcrbXFpTkFH?=
 =?utf-8?B?d01zQ2ZCWW9CR3FTUFRSMkd4a2l3UzAyb1BmR0orcHZrL2FhZXhJdU5rbjUx?=
 =?utf-8?B?ajJ5SC9Qcm52V1dYazNHODJmcjVFdzF2TkM2SGV6ckxxM3pHUC9iTzdKemlx?=
 =?utf-8?B?d3FIckFWTEwwVFoyZDE4WnlBTzJpejVxVEYxZkFaY01KTGxWVG9JK3VpQXVw?=
 =?utf-8?B?WVlRUGNQVWZJOVpQVzZpUFpVM25IZzVRdWFWR0c2TUQ2ZFJaOGtSVlNCVTZp?=
 =?utf-8?B?Mk44YlM4a0plbFdUR3d5cWl6WHZ6MGtnNjBRT0M0ZWtSWjJTNnUyQmRNNStk?=
 =?utf-8?B?RFRqK0RxU09mcHpQZkErRU9TbERVVEZzUG5BNmpJSEprYWV2Y2g5MUl1US93?=
 =?utf-8?B?S2ZSc2k3ckpDZFVsM3lxcGpON2xnbGdkY1Ixa25uZGplQ1ZXTEtaOGxrQm8w?=
 =?utf-8?B?d2FyRXNycGMwY1RaWXdLU081YlB2UDBESmpVUVk4OHlGRXBQNjZzUGpKaU9P?=
 =?utf-8?B?Y2k5bmprdGIxYXBKN2k4SHhsVXJITS9MelBmUVpobzhVTlNOdEdIVmJ4QlBD?=
 =?utf-8?B?ZE9IQUpodG9VeHBER3RuZUtJRnhqQU9DYno4SHdCUjU1WThkTE5yN0VUZVFT?=
 =?utf-8?B?RnN3V2pwYXJOUkRxR3FvODFzMW83Q0wxZ004dWtOam5SWHVzRGMvdk5LYkJx?=
 =?utf-8?B?RitYQ3FORjNpMmI1cjdDVFlPRG5jWHJMYlg2aVhuRW42QWhwSnlwTmhLT2J5?=
 =?utf-8?B?QWliMnVIbDhWWFpCK0FUa0s4OHNGUEkyQW1DLzNrQVA4ZWZnR0dBMWZVZW0w?=
 =?utf-8?B?blNTN0RDZ21Xb2xIUTNyVVV5WkQ0TGYrQit4Ky9UdU1sT0ZCTks4YzRTNzds?=
 =?utf-8?B?T3FpUUZJSXkxLzVCdHRCSHRhRmVFZC9nUWJiQ01BaGcvdW1xeWsvUjZvWmYv?=
 =?utf-8?B?bXV6alpuTVcySGVpWm5BRGxRODl6RVRiU0I1VzBGbEVUVzBIUkliZ09NbmpJ?=
 =?utf-8?B?cC85QmFZTm1NcExodys5bExRMzhBaVNCYTBIaU1qcUs4T2NrMklzNkZCRmRK?=
 =?utf-8?B?RWJub0pNWW1BdDU0cEwrRHkwcUVvcTgrTjZoZWVaMEdreG5qd3FlWjg2bTFT?=
 =?utf-8?B?a2FaK0M2R0xpVS9GUUJzOEt6K0lTZVFoRHBxTmJTWU00Rjd3UnlCVkRUcmlR?=
 =?utf-8?B?dkdvZHMzbEdzamVlZVBlczh1NkR3SEJnRGUyaEM4cVNKU2haQkdrNUdxNjdC?=
 =?utf-8?B?UTFFNlJOYVROK1I3TS84emtQU2lwaDB4M1FsL244LzFFazlVTkRGQVZPR0R1?=
 =?utf-8?B?MzJQdDZZcy93ck9WNTEzMXdhM0xzcDVsRGw5Vzg1Y1B6REV0WC9kTEF0UUIy?=
 =?utf-8?B?eWxtSFk4aDNRd3I0SStwQ0FvczA2b3M2SlFrMXNRYyswTzJJU051clNSSy9h?=
 =?utf-8?B?SzhpcjZHNWduNUc0bEk0dWVNZGtXSHBpZ2MyQW9hV1l1RnE2dUpNWlR1UXp4?=
 =?utf-8?B?a2x4by9xcDNhOEc4S2VtQVVpK1dmOXI5N08xRkdPR3dlMHZ1YVhXUlNpaitO?=
 =?utf-8?B?QnVSUVpoazhPcTgwOXBxbDBVc1NrQ0ZRV05hWnEwd3kvaHNiSkZQMnZLK1c4?=
 =?utf-8?B?ajlyaGIzTFloUzRncW51REFBcGZRb2RyV2dLREw2MjlSVVpibyt1alU2Um5m?=
 =?utf-8?Q?Z5iVXPGAklnn9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THJMS1oxUlQ5MWNOeTg1WWlSMHFlQzdyTWFHR0JySFExVm1EWUlFZXRBc2VP?=
 =?utf-8?B?Z29vU0wyMy9DTlp0V2xRSWhiSUF1MTFFbnNaRnhvUlNiSW1jdWZkUWppTFpo?=
 =?utf-8?B?VWVsTWtPaFp1UytsWmdBalNKMWNpb29EbHA1bEZiOWY1Rk1vKzRubTVzZTJO?=
 =?utf-8?B?eTR5RGVQaXd3WEFiMnhqMWxLYW1iOEkrMHpVc3l4dXdmaHNzcWt3Y0V2TmJH?=
 =?utf-8?B?ZXpocW5XTmcyZThoRkVUM1YrUWpMOGdKdFpHYUNPOUZnSmNkRHg1K3JHaEwy?=
 =?utf-8?B?Y05oYmQxZkFwZFR6ZWw3V0JuZ3BZS2IyT2VUYXVLdGd6d2NROE9HRlNIdU11?=
 =?utf-8?B?bS9hRDhHT1Q2VFJZZXFkV0F1Uk1qWkZ2S2VDMFBjcGg4MFVHNTRFdGhOQkYx?=
 =?utf-8?B?K3YrRVpJaW9UZUp6NUpEVmxBdGg0aFI2QUliVC8ydnEzWEU3ejJrcHhNMXJq?=
 =?utf-8?B?elpHN0IyYlhtQ1ByRlZTdmhvM3lEYWxlc1JFNUJSb2tPMHgwaEYzVmh4VW9v?=
 =?utf-8?B?SWpzUGNTbmVVM1ZCUy9uMlZhYlpTQnliaDNsUjdSR2s4dFVuYWJhTmtHUWdM?=
 =?utf-8?B?czl3S3JJYWVZSkhzTzRPSDZwTFYyQ0dNTHBQaXJGdjFyQUsrQkxmZWNhNVdQ?=
 =?utf-8?B?NVFrTkpRNFNDU1RZb25MQzdDWHM0bWhqNWVDMDY3ZXlZWitFZVJQK2xaNE5q?=
 =?utf-8?B?QncxYk14U3h0TzBZeWlkV2N0V3N2UG9CN0lPblhTSGZQNmM0akxEUis1TFRq?=
 =?utf-8?B?R09ac0FoaDh2MytQTFlhSGREUXBhVFFEV25kUFJDaklzK2RjUjBDYjBPSWxN?=
 =?utf-8?B?YWpLOW5xOVJGR2YrS2pqbEtBS1hydTluRHRMV1F0VHg0QnFiQysyclMwTmJZ?=
 =?utf-8?B?Qld2QmVvLzdIUDZLWmxUZ3FmdjVQclZGVzVzSjAvSDJwSll5ZGNGSmxmT3M2?=
 =?utf-8?B?VDhDSEVGVkZ1SXpPOTlIWjhpSkJVVFBTMmtZRk56WFhDcWJIbU13dmdrQmh6?=
 =?utf-8?B?enJWbjVFMGlSYXkyeFFWYTJsQVp3Ujl2VkdmV2NISXduMnJwUGJTdG9GRnFy?=
 =?utf-8?B?WDZFZ1lCdk10VFVsVXhvcHEwWlpOWlkyZ3kxMW5VN3Q0cUVxQXBYWDZVNHNV?=
 =?utf-8?B?aDlDOTRnVnIvU2c2R1NzSTdUdzk3NnE4SkZPcmc1WHFKQW1HbHVnMHpTNlRQ?=
 =?utf-8?B?T1cyNVVUa2JXQWhPSWo5SjRocjB3Y1FoVmIzdDRNVWMwVFlPZnIxbm4rNHZy?=
 =?utf-8?B?Z1dwaXRWOGhkUS81dzB1enRINDNIWkt1NldsUVpNTzNUQ09GVE5GTGpqWGlB?=
 =?utf-8?B?Sy96aHcyQmVYcG43ZTk3WnpCbUNDZmxpVWRWYU1GeFlxQytVTS9YVlZsVXRw?=
 =?utf-8?B?MDZwSDZJMndkaXBEMzBUMGJ6UkFIZmNudUtZZ0p6STh3S1J4RmFRbk5ibVpk?=
 =?utf-8?B?U3hKUU5BdlVqclNURnNPSmlNY05TcHFYZkpYeS96d1hEMldFWEROOUNGczda?=
 =?utf-8?B?TVZONW9vRGw4ZDB4TUh6ZStVTWEyeFQ1YitrUmthWlZPQ21SOGFsbDFyTWdy?=
 =?utf-8?B?bkNXSHMrbGxQWGtZVVg1WEQwZzVHNXUzTHdQQ21WdVkzcWhKc0FaYlgyMlgr?=
 =?utf-8?B?Zmw3MUx1QWZsQjhrSWlCZWdFNFdqNlJycUs5TUZNL3Nxa1NXclhpUEdIQTN2?=
 =?utf-8?B?S1dJaXJTbEFwVUVqYXJlQTlBL0taY2RocDl0SkZ6U1haK2dCbmxpT1BDZVd4?=
 =?utf-8?B?RUJreDkrRjhSRWZSYVVrQ2tmYkNneXE0NktwZERRdmRhUFVaVzNUMXQ2SzJ5?=
 =?utf-8?B?VkhwbmNvUEUrVDBNdUVqOFdyZWRLck16QW0wR0NQLy95Y2JMMU1uQlo1WWx1?=
 =?utf-8?B?cm5PeG81UUMxcTFmdS9OWXVBbDB4VzlDNTJVRkxJU2hSdWJPeVhldVUvWGVv?=
 =?utf-8?B?NFVBNks4RHQ4eUNCMU9Nak5vYlU5VDFGZmNZcGZOVTJzbFFBaWJETWd6dzQ2?=
 =?utf-8?B?d25GbzRibFQ2OTJDV0N1aFVxQUFNdFlUd2Y1N0pIS1M0aDlDUTE1NGtjcU9V?=
 =?utf-8?B?ZTcvRnlya1lRNU53Y09Lbk5aaTdxUnVKcU53VXgvT3BRQUpRaTJ1U25mZEJI?=
 =?utf-8?B?V2p5d0J1a05OalRkRW01cmpnUXRJQkdJTW91aUtiM1p5dFErNy9nK1VTQ3U0?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc76563-2398-4c93-19ea-08dd70aeac16
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 23:49:27.1626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfnecyGy8hbt0VifxgWDOzg5VBGr3xPGq+ipOvAlBwWPkyHuRyrEaCp5l32DVdIu/1dFVoXiCxX9HSC8SKUT4+BGk2iuzWhA53KUPbFdOSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7576
X-OriginatorOrg: intel.com

Hi Tony,

On 3/31/25 2:22 PM, Luck, Tony wrote:
> On Mon, Mar 31, 2025 at 09:18:12AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 3/21/25 4:15 PM, Tony Luck wrote:
>>> New resource for monitoring core events reported at package level.
>>
>> Could you please add proper (per Documentation/process/maintainer-tip.rst)
>> changelogs to all patches in the series?
> 
> Will do.
> 
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  include/linux/resctrl.h            |  1 +
>>>  include/linux/resctrl_types.h      |  1 +
>>>  fs/resctrl/internal.h              |  2 ++
>>>  arch/x86/kernel/cpu/resctrl/core.c | 11 +++++++++++
>>>  fs/resctrl/rdtgroup.c              |  2 ++
>>>  5 files changed, 17 insertions(+)
>>>
>>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>>> index 25c3ee78de3d..6c895ec220fe 100644
>>> --- a/include/linux/resctrl.h
>>> +++ b/include/linux/resctrl.h
>>> @@ -233,6 +233,7 @@ enum resctrl_scope {
>>>  	RESCTRL_L2_CACHE = 2,
>>>  	RESCTRL_L3_CACHE = 3,
>>>  	RESCTRL_L3_NODE,
>>> +	RESCTRL_PACKAGE,
>>>  };
>>>  
>>>  /**
>>> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
>>> index a7faf2cd5406..8f967e03af5a 100644
>>> --- a/include/linux/resctrl_types.h
>>> +++ b/include/linux/resctrl_types.h
>>> @@ -39,6 +39,7 @@ enum resctrl_res_level {
>>>  	RDT_RESOURCE_L2,
>>>  	RDT_RESOURCE_MBA,
>>>  	RDT_RESOURCE_SMBA,
>>> +	RDT_RESOURCE_INTEL_AET,
>>
>> This is fs code so architecture specific code needs to be avoided. Any other
>> architecture that may need to report similar data would be forced to use this
>> resource name.
> 
> Maybe  RDT_RESOURCE_PERF?
> 

Would be ideal if it matches the name of the resource (below).

>>>  
>>>  	/* Must be the last */
>>>  	RDT_NUM_RESOURCES,
>>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>>> index ec3863d18f68..3a100007301d 100644
>>> --- a/fs/resctrl/internal.h
>>> +++ b/fs/resctrl/internal.h
>>> @@ -240,6 +240,8 @@ struct rdtgroup {
>>>  
>>>  #define RFTYPE_DEBUG			BIT(10)
>>>  
>>> +#define RFTYPE_RES_PKG			BIT(11)
>>
>> "PKG" is not the resource but instead the scope, no?
> 
> Correct. I missed this one when doing some renaming. It should
> get a "perf" name (to match what we pick for the RDT_RESOURCE)
> 
>>> +
>>>  #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
>>>  
>>>  #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index c316268b4442..c8cc3104f56c 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -99,6 +99,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>>>  			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
>>>  		},
>>>  	},
>>> +	[RDT_RESOURCE_INTEL_AET] =
>>> +	{
>>> +		.r_resctrl = {
>>> +			.rid			= RDT_RESOURCE_INTEL_AET,
>>> +			.name			= "PKG",
>>
>> The resource name should not be the scope. It should be a name that reflects the
>> resource being monitored. In this case it is "core"/"cpu"? I understand that this may
>> create confusion since the data is provided at package scope so perhaps the "resource"
>> can be "perf" and then all the events can include "core" in their name? If the intention
>> is to guide user space in how to interpret the domain IDs then we could consider
>> something like "perf_pkg" or even "phys_pkg_perf" that prepares resctrl for future perf
>> events that may need reporting at a different scope?
> 
> "perf_pkg" looks like a good option. Should it be "PERF_PKG". It appears
> to the user in the names of the "mon_data/mon_%s_%.2d" directories. Also
> in info/%s_MON.
> 
> Resctrl uses "L3" in captitals in those places.

I do not know where the capitalization custom originated but PERF_PKG does seem like a good start.


Reinette
