Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB97021254B
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640570; cv=fail; b=Coibe/aKsG7ha6Oei8F1LE0kN1D7IWzE3DVBvOdlso5rIDk586bsJ3sIqs/wHPT/ctE1d5R9a2ym1udF4i1Dw8dy2CkOsGv0AsDF+eiv7ln3mSrOPMQG++Ow+SVK/7Qds7CN0yc9vYTkj7hlPheadXR9ZNRj2/aVIcIDY+y8hiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640570; c=relaxed/simple;
	bh=j82mUFoVGA3f8m8VbtzhSzSA2tTsoCpaiqoB7DaIAQA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Iazvuc8lLg5pdCtKenXseSC1h4NtiCdNz1kUGFtXWKvPm5W0JBeTOgv3qm8mYaau1RLIZ6pR4ei35l/lxWwOxOoTB8U5KgEcD7RciCFMN4k/uqnO5lrmHAbbqEt8tyYNnmUolDrSYqfY255M+ryuX74nX1KfvHGiNJTFgPOIJpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m5VHnpyF; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m5VHnpyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790640568; x=1822176568;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j82mUFoVGA3f8m8VbtzhSzSA2tTsoCpaiqoB7DaIAQA=;
  b=m5VHnpyFYdqxSY/SnFF002tOHj3b1X+NMoG2Vq0DafB+1GLZGwQQkAwK
   /m+9JMezjnfgx3WVdvkvVToxia1Z6L4VCXysLntCvUeYLRU4Svp78aOH9
   tiJiFuHx4rTWwv1UJ/j0pz+2g1zGw4xCOeoSR83l30xAHPhIjswiCEBxY
   yjgdFb8vEUllsYdlzAb4DzsYs72L3E65syl6SPYC7olTvf5cTouUbyNAj
   6ZKKGh35lTEbVP9P4gSc9fPLjIki+PC9TWeKgflHOqRW6vz0d9KpHaxWP
   LjgpWCk/LKgiKz3/KuI+4hEmorxOmjoGFkIYGihM08kDCH1iBiKroAu5J
   w==;
X-CSE-ConnectionGUID: vUWFDmWHRLWxsvyCUQsUBA==
X-CSE-MsgGUID: KbpcoBTiQUiMxmVrJ8aTMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="91214422"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="91214422"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 17:09:27 -0700
X-CSE-ConnectionGUID: 5h9C6hv0SbGc8G7vVeKsZg==
X-CSE-MsgGUID: DX9XyIgZTUSHUvixIK2Irw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="278561113"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 17:09:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 17:09:26 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 28 Sep 2026 17:09:26 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 17:09:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1YdSbJI/2C8Sa37zUZd6335XYIzPCDTmlwfUmbZsiq38DGnAxBuN+0Idhjgu3KzvWDLCM0tDdCNbqaIEZNKbJrd699dL3LJwQNhNngenJ3avZKqFH5I4OHlx1AiUyqjrEz83JocTq+vsyhMV1x2NLDsKqFpIoxANkaKo0TVkb+2TICfQoINuc2nyKomdnQRWJsanhhXhR1NN709zZ83F0cQvtj/QR19UASSdHm3wC3sXI6vF1LVIQ2T9DSLnIyoR3pcD/+KE1DQenLjrniedvY78Vm04jmkxE3C8otd1R59RyeE6sqy4fiohPL6eJ7KxVIR5VdcynBF3b1eoJzGdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuO1YJe+H+QW0YCNrEhaz5euhwt82SKwmPQGJMZaL1I=;
 b=mVPji5+oRfOt3J9+T4uPHhmkruHWlx70VzZC0p7AMDtDljcWkOvfuOf1HBtJ0nTDAd52ywofojOl8NMNUastFNQwGQPjD5KJ9QYZVhhBzcWfW4yzclxC/z2AwZeB7rM0fj9Ite2IyNOlaXFPBcbcHqfFSHKKdnkztBhyirieR6omsjr63LQK2+HkJ/VF1KK9LxHEg/FuWXbioajfEkqnxspFNyha41t/MQ+rS/LhrN42RNbtIg5PoT9X3f1F6q2fBlo94tef8X4nwVE9yGnIsPeIw3/UCTNMRzHr/HRrZOAKpAMP/cSwAc9jXTUkFNEjYnBgoKk815Ouiv+J5tOSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH0PR11MB5159.namprd11.prod.outlook.com (2603:10b6:510:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 00:09:20 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 00:09:20 +0000
Message-ID: <9d7fea8b-c727-4acf-babe-4c8665af2062@intel.com>
Date: Mon, 28 Sep 2026 17:09:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86,fs/resctrl: Add event_group information for Intel
 Diamond Rapids
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260921213226.14997-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260921213226.14997-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:303:b7::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH0PR11MB5159:EE_
X-MS-Office365-Filtering-Correlation-Id: 02872d8c-4d55-4a27-27c7-08df1dbde88f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|56012099006|11063799006|3023799007|6133799003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info: WO0DowUFc8tMGsLDZRjX6CaJK2LuZlEgm83N6gDWff4ijA6PAkkX+8NhzYAcaqAnY+glsqS2v6ePUBbkNFM8Yem35WPGgNOQCQvCnwfJKb7FhVpG6mOEZOXlVzu44zNl3cxB8XFkj/HmPKkmwxtyBBd1npoV+OsweGkozZU1y+ogFW5Nt+48fgKC3Ao5kNQElFHSONnzQAIeWjTw1eZj1UpAkALm4EycylKjg7bZXJfuGGrf4TDDzd+sB7JNfRqS693n0C36eOjRFChxQOM4gNKWrvdoLX9v7QRv3oWwRf2y+Ma9uoyDuqtCYw6a72dOHVW6PB2y3sZpzDIOeXiy2SvP1ugV2193mHpaZECO4WYyrlA3AqOYl5UW8ISBk3YZ+Apn5UhIQ0KbyLLFaAZJ7+5uZS+JehkhVhfdHphUXrB9v+lperfLImFAWcVDUfyI8SIhEbRxTF9drDEONzBRAZ9x1yHrRBCj9VuC+49usP/vZRdTu5AZuMOMtHYNzafg5InxLIj2pkG65UgiyJCqP/Z7rMl0lx0bQTmKyN0crJXqRy0bJ2yeLuaHbJF66CfhOAWdDxAebpVWcGG7/YzKxmniMWua9025xNQlpGO5kzpHXjnqPcsNidq+S7sOiweZdqt6jz/rpsfAcLJhgprgERODFUCMuUjuGnZT4A92Fmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(3023799007)(6133799003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SG5sRXdkUGFyMzc2M0dnMHVOU0JVdE1oaHpLc0o3QUdYM2NsNDFjNmF0L2tq?=
 =?utf-8?B?K3Mzdmg4VXVYQk1CZU9UR1c4QVliNlhpNkJPdmZQMElScVhZU1FPaldsN2Uv?=
 =?utf-8?B?b3BWUkllWHZWOENWOW9qZEVLSGhHYmdmVVFaOEdYUi9NcCtDRUxpMHY4THls?=
 =?utf-8?B?Wnl2T2hiNEQyTHdJeXpjMnNzVE14UTNkQ1A0R0h2S3hrR1hDcW9GUTFxVWY4?=
 =?utf-8?B?bFRIaW1YWGg5aE1WK3piRHEzeDQ3OFgwWi9WRktNK21hMEhZR09WV3NQMmVn?=
 =?utf-8?B?L3JiRmU2QXVQSElhRnJmRVlGY3Fkak1FODNPanRFQ2dON25UUHdWejlQd0FF?=
 =?utf-8?B?NHAxR0c1OVdPRDRzWkZHb1I5bW56ZCtVdS8yRkxaTWIyQnk4NjFQOW5pazNM?=
 =?utf-8?B?dGZseHJKRHVFWDRaYzUrMTkwRzk3R2RlNXdqYmg5YlNhWm5hRUdlSjZVd2tF?=
 =?utf-8?B?eWJUU0FTcDFMQTNabG1xc0QyQlF6b2JKdDVjU3pBM1phd0kvdjZab0VaYlBp?=
 =?utf-8?B?Mjl1TUhWTSs2YmRKQUJDMFNSeTdTMGpSdFNEK3pLbm1MQmhJbTJpaVVnZXVV?=
 =?utf-8?B?VDdDZzd1Z3ZZaFFOcHQrdUIrZXdlSi9lZVN1YU5Bbm40ZUdaU1VCN3M0ZkJH?=
 =?utf-8?B?NTJnbFRxVUsrWlMwZVBabHBYeTdIbzVBbnZFQ2VkNHlsMHE1aHJEVXJocHpJ?=
 =?utf-8?B?MkhsU3VhbVNZNGUrYW5hWFpGeisxV2RjOElyNmdZaGhMSVVSOWVESTErMDBC?=
 =?utf-8?B?bVJjWDV6SUo2dTRMb0pZVXF0eFpMSDlUcm1pbUFxbEdsMGN2RzJ2Y281QzJI?=
 =?utf-8?B?NnN1L3JyOWJoM1ByMVkwQ2h3RlVObVRGaURLR3piUm9tVk5hYWVINDVmRGNU?=
 =?utf-8?B?UVlyd0p4VElsSDZFanlWTWNPb1lUczFwRml2NXVPUjlkcWI4WUREUmR5U3Jp?=
 =?utf-8?B?Rm94L05MUmlQWEJubm9kdEVtZnBuYkdYVW1neFNBR1EzbEE4R3dLZW9wUzBx?=
 =?utf-8?B?QUk4K2gwNk1lRkhvVzdaU1JsVnFtZG0vaVV1dityV0dQOUt5RndyeTdkTWs0?=
 =?utf-8?B?ekY1Mk5TVzl0bGMvdmRLcW9UM3ZMa0pUbVBhR0dGMnRWZ2dITlRtK0FPcHp3?=
 =?utf-8?B?TEpETzV1WWEvclA0UWxVazBVc3BkYXZqN1RzNXdGSGpva3ovZUc5dUdEb0Rx?=
 =?utf-8?B?SG4vbG1DYnNXQWhKalorRDFsMzlZSWpFQ2dwVjNjVGZLOTN6TWxUK2JPR1Ru?=
 =?utf-8?B?U2crNFZmb2h5VDcyWC92aXpaSlRFaTQvdXZqelpVQVlONUMxdUd1ZC9VSWZk?=
 =?utf-8?B?TXlaOE45MzZrYXFGWjc1MmUrVzhkWnh3NCt1TEtIWTZZdnBiVkZiRmlMWDcz?=
 =?utf-8?B?NEpJQ2RSWlNiam5DeFZ1ZEZYOXF4VlNhU1B5emkxdm5DaENudzVOaGxBSFEv?=
 =?utf-8?B?NENsVmdrekpScCs3WVlWMmhhTTQ1UHFnY3FLWDQ5YStoQ3luZWx3eXhTYUF6?=
 =?utf-8?B?Ukh2ZW9GZFdyUkxtUStyblJuZW9sWEIwaFU1bCtqNldBU3Z2WFY3MWpoNmhX?=
 =?utf-8?B?QXhFOXZ5ZCtRR1NFcmdqS0hrRWM4ditTK0c5VTRZcGw1N0g2WHU1QVZNbFNK?=
 =?utf-8?B?WUNoTkhibHB1dUtZMHJzckFxRHk5ZkdVWWVKOFkyNThPR2xmbm9SU2FEblhM?=
 =?utf-8?B?czVlMzMrSWdPejRXVUQzVnU0Rng4VGFkUGVhNm9rU1gveFVSck1FZnN2enFP?=
 =?utf-8?B?ckVzNDM3RzdKUUx2SG9XSFpyTDQzOWRpN0JEMFpaY0R6NmxIWDVDdnJsQUU0?=
 =?utf-8?B?d3J5SlpBOTVZeU1YK3F4bkkzL3JKaldORG5MSUFqM1Z6NWpWWFJDTjc2UkRZ?=
 =?utf-8?B?MUU2TEJ2ZFduTnY4NmFvUDVHUjloR041YVNWQmdyUW9CbjdTUEw4M3FzcW41?=
 =?utf-8?B?ZU5DeVFISE80QU1VeWhLQ3N5R0FjNEcrTzd0em9NWmgveDQ5OHVQVHlMNmNv?=
 =?utf-8?B?VTNRdWNaV3ZCdy9hRzcvQjVlK2FsTW4rQ3U5elhHWktxK2NQUllpOGdLUzhz?=
 =?utf-8?B?OWFadDRHcXlrSmM0cUhRV3RVTVE1Kzd0ZHY2UXBZMWx3cFYzOTVWUWVSU2kr?=
 =?utf-8?B?MmpyaWk5Rk1PaE9MRndBNnNDT1NxMGwyQm1TOEpEbjFiK3FZaS9CWXJodkMy?=
 =?utf-8?B?RUNUdC9HWFRtRUprcU0wTENrZXNzSm1DOGV1R1liUzFZVThiNXBYa3l1SjdH?=
 =?utf-8?B?bGVKK0ZFcjRRS0tyMzFRL2ljRXRabWNnU2ZvbDJQUXNZcEVLeUlyaWc4ZlAx?=
 =?utf-8?B?UXVLUmxDQzZLc0lYbDNLMjRwNkF0RjN6b09mMEQrWHY5cmVzUEFpb2hjSGEz?=
 =?utf-8?Q?IuNwLHdZeOGTJ6PQ=3D?=
X-Exchange-RoutingPolicyChecked: hgHtc9ybbeqygkyI4Ny+E0ps3WyRinWDSBsIsomoUlyQy1jOeL4QHN7IzOjcaH6L2lQGeDXmuC7X37BWZxswTPK2tPtWL8M2Q3LPMdwMxQ8LWDRKkEY9mYBybNpJ7jCskGVkO1XUQzb1Ls4tCahpbVvlFrCD9+FfWJoQZgU4RIl/Ev3wOh5q+ecZ56XStuX60p2sGgqGuBYxx2Q+OUG5borEtpajGIHZsC5ZqvWcDpcahrXZQYWAz/8kaRWujxveUEqu/WZM3B34JCECwZCj5rpnFBPbyWOXhVFRUSHwrIyULfe5k4qyNLs73/qV/iUfTjHISRLNXbm8zquZlXLoug==
X-MS-Exchange-CrossTenant-Network-Message-Id: 02872d8c-4d55-4a27-27c7-08df1dbde88f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 00:09:19.9368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D04oJPaGjCeLSpgU2YPfbocrxKypFkRY0cQ0TNoidGr889DXH/5yMNEsXmIHynBaY4oiIcR8PUxQauXNmy3wXZYkT+BbyDP8nkDoXKUQndw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5159
X-OriginatorOrg: intel.com

Hi Tony,

On 9/21/26 2:32 PM, Tony Luck wrote:
> Intel published XML descriptions for the Application Energy Telemetry
> events on Diamond Rapids here: https://github.com/intel/Intel-PMT.

See "Link:" in Documentation/process/maintainer-tip.rst

> 
> Add event_group structures for both new GUIDs.

"Add event_group structures" describes actual code and is clear from the patch. 

What does "both" refer to?

> 
> There are two new "perf" events. Add them to the resctrl file system.

Here it becomes confusing since patch adds two event groups
as well as two events.

Below is an attempt at a changelog that follows tip requirements. Could
you please consider this as a draft and build on it to use accurate
terminology and be accurate for this patch? 

  x86,fs/resctrl: Add event group descriptions for Intel Diamond Rapids

  Intel Diamond Rapids exposes Application Energy Telemetry through two
  new PMT aggregator GUIDs: one covering the "energy" feature, and one
  covering the "perf" feature, both documented in the Intel-PMT XML
  repository [1].

  The "perf" aggregator references two events not previously enumerated
  by resctrl: retired instructions (INST_RETIRED), and a count of
  unhalted core clock cycles perceived by hardware as contributing to
  instruction execution (PCNT).

  Add definitions for both aggregators, and add the two new events to
  the resctrl filesystem so they can be exposed to user space.

  Signed-off-by: Tony Luck <tony.luck@intel.com>
  Link: https://github.com/intel/Intel-PMT # [1]

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
patch looks good.

Reinette

