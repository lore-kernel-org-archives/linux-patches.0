Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FEC21C184
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008027; cv=fail; b=eqUIP38hDWi/9B9TirHNTSzTU0Lc3TnlforU4nwEmZ8RPss1u1GEEznyaIxuNMbFLugXvS9rAgekBK9yMv+Zxs4K4CeG+3E5bYakzTfybhyLowiNr+2eIxPowkprYZQNZJgc8UTqYC1ebr3SUKWalNhxswmktwe6zviNRYZGhj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008027; c=relaxed/simple;
	bh=gF6E04MqsttcHgvdwEtwrecqQs+UlMULQvIPMx/b/Sw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pLgAy1qzq9ABIMajWB2pfjECCdNRliauyEZYUfHgFYRnbGakxLvlFzYRvkTXMHuFWG7t1KQ8KW7eIxV0j9tT8rjm+2FJHiZlXSMUDGwps3o+tsiagGNT8+aPRhZQy/qMSLhSAvQhZ16CNAqXPWTUwjiBuE1xgYpq5RUN43ZVAsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjDQ7QzR; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjDQ7QzR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008026; x=1783544026;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gF6E04MqsttcHgvdwEtwrecqQs+UlMULQvIPMx/b/Sw=;
  b=CjDQ7QzRhKcfWY+zQDi9jCGyYIX5fCziQiY8JOrojwA0mVZcfatj5xUs
   PeeyfRX6gpZWQn2y2egFPHNd7Wg6ASNPoEB4CA3nBp7+ay0kIKOkmZ6YG
   KP4u1HHUHIvswGZNS4oJNOLfCyiehujbkqNXeBY1XoM/zKNVKTS/9V6UM
   xsIIhDVpGRDGWoobqz/5gCMrog68cOfM1l28luz84tUoaw9kA3WeygxNA
   IqBJbILQ4uXfOM5jAGY1tV8jSAVNqvSnBXaGWo/oFTwn5Kv2cjUXpH+Og
   qIm2Q5pz2rbXFmQsyYRqe92G0lQbeNW1lS1l1pn6qgU8j6okTElIyfL3B
   A==;
X-CSE-ConnectionGUID: 8KbacWWhTMaDdgNGGYx1eA==
X-CSE-MsgGUID: XkJkGV9TQ0KjFy9gVAmywQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65321121"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="65321121"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:53:45 -0700
X-CSE-ConnectionGUID: bH7xxdRjSXmsCekacengFA==
X-CSE-MsgGUID: ch+jKDIGT9qDRxNjtxKr0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161247465"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:53:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:53:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:53:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.44)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:53:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmaRx8nqjEt0Nw/dhmiR94OXGCwr6re/ZOxgtVN0NaPK6j6nR9FTsqA1OT9PPeGPo0HipUKLx+DdCu7Js1Dyqa3c5idlqDpxtZubNHVu4FnmBzpoJyFybqP1tDpkNxRGvq6+j2o43WRzqWC7hfpL51x1dj7iwR6gqYAfEAvm0Jr4uHi4VBraAPQiXrJfkRBSRy2tbBcvc9vmyQ6QCM0EjkMEwjXspFPDoxd11y75Pbk7KP+uBztwXxfkt3El6G4tJk/HWLYG+2sPQ2t3SPmuv92Cb/M8Y8YbgyRVxMMsC4mocMA8o7uCdWvbhBWeZ0iITXkVbe+HiyeKpukzHf7W+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcdGI0DyOAoVzMh6n4FcMZVEOzYA9961ZLhb9QaMW0U=;
 b=irM12M8FgiTAcnTdUBA+bRoUyQuMCBzx+GfPR1cmo08JjgG1EZtv2HK0e2sROBwo8Xz/owzyVZfQxweSGX8CAUtOQeu3WxPntrQHIMB737OF1AVJzgnhjQRv2y6tEnc3gINHLwbBL3mXaKBlAjKSXAhTekh+sJbozGrt2fLYLGiIwlUF0d79duqtHMTqe9fpvGO5IG2jdIk3uSidMXjLyGKbL3BfdoZQhIFZ1vdGOHX0ndqpyIpptb0kqSUKduezv6iFmjjiNb/GIMpLm6VVLDQUNPBesdjAI77W4/BSEmsWm+w5hyedV2a1G8aIMX3AB+PRfUgpFc2owgRnWFoe4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8223.namprd11.prod.outlook.com (2603:10b6:208:450::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 20:53:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:53:00 +0000
Message-ID: <a1f2528a-105e-4728-b930-dcbf24fe344b@intel.com>
Date: Tue, 8 Jul 2025 13:52:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/30] x86,fs/resctrl: Replace architecture event
 enabled checks
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: e0970163-a552-44f0-d06a-08ddbe616c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MlBvNThESlNlLzhjQkc2RHRIUFV2aWlDREY3RnJHdkVhWEozdDBicmVyMURs?=
 =?utf-8?B?N2RBMWs3MGtRWVhlbmYvYmdCNFlzQVdTVC82YzYxeW1PZkI3elVpZzFaUXQ2?=
 =?utf-8?B?WGREUkllNElrc1M0bjFidjhob1htZTJTUU5TQ2xPRWZsYUxuZDU5TTVsR0Ur?=
 =?utf-8?B?YlVhbUQzS0xvdE5zSUs0eUY3WUcxS2Q4SWhYYlRWdUpSSHFnbUxiQmN5d1VW?=
 =?utf-8?B?ekhqRDlyYzZVMFc3WHh1OGRDL3NoNmNKQUlvOC9Xb0p2RkVZMERZQjcxSDhl?=
 =?utf-8?B?dVBBSythcGJGQ1VxYkU0aVd2MlZMb0pzQlA3dmtoNXFma1JSWk5UNFkzUzNI?=
 =?utf-8?B?L21xV3NlVDBwalBlLzdlbFFWeTc3OUdBSWkzTTg1Tm1YemEzL2Fvak5HUVFF?=
 =?utf-8?B?V1N0QnFwcDYxMWFveHAzOFFEdkx5NTdDTXBZMmZLV09kSU1oc292UTgrSStF?=
 =?utf-8?B?QjVFNWlSNlJTNUR4ZVl0M0pWaXJvdDB6c3liQ3RvRkJ5VXFqWW90cW5wLzFz?=
 =?utf-8?B?U3RWVkkzSDEwMk0wWEt2Q2NLRVlSeFlINGpoMVV0Y1NTU3JUOS91bk45dW5U?=
 =?utf-8?B?TnhqclVYdWdPVFZNOTFIais5UFFmWnAybnBqaXgvV0ZDK1MwdlZOcDFqQ2FV?=
 =?utf-8?B?UnRWNlhOeGtUUGZPUmc2cmQxcFdrRVJzeUE0TjZ4K1Y1WXdZc3pQWVhpdmRS?=
 =?utf-8?B?Nm5nN3NBdFNZQjhIS21wYTQ4dGZuTUVlVCtGYUo0Y3Q5d3NCK0dQOXhiSXBZ?=
 =?utf-8?B?M3VIMy9sR3VSWWNQMWtjcWw3anBvZmIyK2hzYTBLYnF0UjJPN3hyWTlyd2Y5?=
 =?utf-8?B?S3c5andIQnVJbVRKOUVFblEyeWNSNldBODQ3d1haNVBhakNLQVQ5czFLcFZB?=
 =?utf-8?B?V3MyYlNyaDB0WVY0OXI0NExiTVBybis3ZGdYNWtOc0JzT3djYk5UTklBcXNa?=
 =?utf-8?B?TVhjQW9pdXZiZWljV1dZcnloR2VvSXlzMGVJRU1vRjJCWUxHWGVPZFo3VFRI?=
 =?utf-8?B?cHdpQ09TMERvN1RKOE1wVG5QQmlYR09rZndGRDJxUEVtODVKZDEzcW5ybmRq?=
 =?utf-8?B?eDM1RjVIQ3Q5S051SGVCWEFkOW43aVZMMmd6RzVvS2VmdzMwVmpsUHRRT2lG?=
 =?utf-8?B?RWZhbEE2OE92Q0hpK3RvQkh6cnF5QWV1eW5UOERhMEp2bllUWlRienVhR0Vw?=
 =?utf-8?B?QW5aSEY2WkE4Z3o3VGpPdjUxTDRzT0tPODJrdFV0b1g4cStQek1VSHRvZW5q?=
 =?utf-8?B?enRYWUtZS2tjZC9LWUsvY3ZEKzZpbHNyaTRkN3lrUnFLZmRPWE9MSVhRTDlJ?=
 =?utf-8?B?cFg3Q2pyUHlBY0ZCTUxSTTM3dSt1UzQvTG94Y1Baam14RGkrYXZkMmhSMitN?=
 =?utf-8?B?RHZPenpFSGRwbGZ4VFFHbTRIYnQ1d1Z6ZnRyL0tBR1N4TzNWVWhManFud2pu?=
 =?utf-8?B?V3lUcTkwbU5xNUxWUWQwRVlqQ0xLdkRVeDJ0bTdYbWloRzlianpjWW5OS2Uz?=
 =?utf-8?B?RU9wZjFMVzhuT3lod2lvaS9QdnVaamQ4cG1lRjVwZGg0aDRkK3A3NEwySVNM?=
 =?utf-8?B?NUhOa1hCcHJyUmVyL2YvbFRvRWllS0dYR25iM1MrdmV6STdZT3BiaGZOSEZK?=
 =?utf-8?B?aU05bG1oTkZybENxVFhaK0dHMEhjVGh1eDQ4U2g0eWp5WlFuWGJmMXY4QzJr?=
 =?utf-8?B?VTl2RTd3ZGd1NTUrdE5kU2RuV01WQmlUK0pWeGJGWVFDTVc4bXpDd2h5QWlz?=
 =?utf-8?B?b1hKWmJSVG1zbElhSXhHS1Bsc1lJWGxYZ0RWSlRlNFZIeFhKcURwYlV6dTFr?=
 =?utf-8?B?bFlQZHVuZUowaUFGaGd3aDdPeGJtQzN2b2NKLzRWbEdhN3orQWk5MmZCTjFV?=
 =?utf-8?B?em45dmxsZzU1ekt1azhJMkx3dGwwbk0vRkRaOUVEaU5BTEpVclQxd2ZiZUoy?=
 =?utf-8?B?eUZRRkVGMkZQMEE4T0p5Z3hPQWx4UlRwTkY3MFVTZjFFaXNkV2k4QXVRR3VM?=
 =?utf-8?B?YXhYTHRJdzFnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WC9pUFJKV1Fxc3hjQWlzdEFkUnZuWVJYQ0tmckwrbEFHOGpFZW0yVFlCdTc3?=
 =?utf-8?B?REtjeHNleVpuaWdsMWwrQW1LdDhia2YrS2FycU14eWJ3YllVeTduM240SEFJ?=
 =?utf-8?B?aU9NTXpxNzEzbTlaT0NIQVUrbnAzZ3hSdXhCY2JPRnZyUFl1Wm1tT3BuSVZk?=
 =?utf-8?B?TStLZ1JCM1BMdmxoeFliK3NzcEZkRlFmTlZaNjAwQ3c3Nm43ZFptV0ZmNG1x?=
 =?utf-8?B?a3NIa0xMT1JDMUhRV2RTbUJKQW1Ic1V4TUlPc0IzdUxPVFNhdElIYmpBSERi?=
 =?utf-8?B?blQ1SmtPbHROYjlaTWZibmIxRE5sZTFkblZJdFZLVDMxMnhrZnZpNjRIWkVx?=
 =?utf-8?B?elVqWDlIMTdQOGVkUHNDUzVFeUkrNnJyZktEYUEwZCtEdGJicmg2VHZibStJ?=
 =?utf-8?B?YlZWYjBZeU43Yk1Ob01yRFhwenlibzlXRkZtRDQ0bjlRQW1jcTFUd05VQ2hi?=
 =?utf-8?B?ZEllODVEdGJpeHE2cHV5U1h5MHVZc0FSSmRKYzc2MkZkNm5MZ3BSTVovZkEv?=
 =?utf-8?B?NUZEQmw4cmU2dzk5TXByclo0NUZXMGN5MENJdmZRcGR2YkpMQkJiUzU1T1Ra?=
 =?utf-8?B?Yk5KUndCL29PRGhVd2p3QW5nYmQ4aUdYME95QU04YUY0RlJiczZkbW5iTHd6?=
 =?utf-8?B?TEM2WTE4bVBtaXVpQkx4OU1vT2p6TkxXYTFTZWxhYllnMkZFS0lQdjFGY1hQ?=
 =?utf-8?B?eXg2Q1FmbVZTZWhVdTBDZGRjeVNDY2lKUjJDLzJtaEE1UGFKLzN1NlpJMURu?=
 =?utf-8?B?T1dadE1wRTZOOGtjbXZQT3NocW54MUVJekpDV3VRRVJyY0lFOHh0bVpyVTVI?=
 =?utf-8?B?dUluT2c3WVlGcjlucFNWMXBRNWR6dnJTWnhhbllVclVNckM4WlJVazhRYmR4?=
 =?utf-8?B?cWZxS0IxOTg5TmdHSWhab3hlY0EwTXJlVjZycVo0SzVsNEx2VTZTY2tGbzVP?=
 =?utf-8?B?OHBwZWdWUW52SGN3RmFEdWNSbzFzRDNCVFgwK1dwZ0dwYWRodjYyTW5Kbktv?=
 =?utf-8?B?MWtLNUJGRG81WEpyakNDRGpTV21JR0hRUXlubDVvalRzSXk5UW05MFdtcDFI?=
 =?utf-8?B?aE05VVUvd3k0ZXNwOHpGQzZVaUFteXh3MXg2aWpXNHdSSEV5NHhNSCtuWVEx?=
 =?utf-8?B?aS9pYUZnVDJZMTlJbWlBZjhvN21xcGFNajZVUnl6QzRIcCtLRnFhenpPN0Zm?=
 =?utf-8?B?SVFoMFRJeERpWUtQNlVQR2pCdXQ3cVdod2hyRzFOVFNnTDdTdzJjaFArZkFo?=
 =?utf-8?B?Tm9LZ3pmTkE1YXlXUm1CcEdqWW1nQXk5V2o4TGgvN1J0MlRHc2VBZ1BIMWxs?=
 =?utf-8?B?K0FxSElpVmZVRUt2cmJlWTNTTHZjV0toV1lka1B2NUNBdnY1UUZUOVpyMC95?=
 =?utf-8?B?TGVLM01pQlF5MGkxM3RPSno2WXFSZmxLMkpBcmVUanNXZFQ4MXFua3Q1Q3l4?=
 =?utf-8?B?Ym5ta3puNHNjejgvaTNJMTBNNmRxOVJrWFEzd1N3L0pQS3ltOEY3Q2pYNFpu?=
 =?utf-8?B?aThxancvYlBzaFU2akFIdTFxSEVELy9YWlJZWW1wdWFVa25FRWV1emtHWVlP?=
 =?utf-8?B?UWNBcUhqWUZSSXdNZndRamRyMm9rRTdRSW5CWnNwcGEyK1QzL2JYY2VrY0Zv?=
 =?utf-8?B?b2E5VWpOUzVNb054eG91OFVneXoxNDBlTzhISy80QTZuVjJZOWl4SkxQempE?=
 =?utf-8?B?SnIzQ09lNDVPajVXdFlCRGR3NkdwTXFiblREZ3oyamwyN2dlaGxLY1QyWHZU?=
 =?utf-8?B?WGVGdEhZUVlpZWdyK01YNkdBdGxrUE5HdFdoTGJrT0Vmb1pSbUpDMUVRNVZv?=
 =?utf-8?B?dU1xM2s2cXFzcEp1UnhDWGFvcWpxWVlXd3JuMC9PTUxkekNBZUdFWVNEYVVL?=
 =?utf-8?B?WFUvNkF4ZGV2cjVFRnpiTHZKTHRzdXhKdXh3dk03cm1NMERwdG05d01IaWp0?=
 =?utf-8?B?OENBUEkrN2JWTGVlK3IwYUhMckRSbTBrbDJXN2lZT2VKV3J4bTFWa1VuTEk2?=
 =?utf-8?B?Ti83eFljME1IMFVjSCt2TGw2ZXVsOGNSRVI0ejNZMkw2VnBPRHd4bjJRODh2?=
 =?utf-8?B?SlZtZ0RGTFBiYWhiNUphWUcybmJPdmRWc3d4cXRtQkdtVzA2Rit2djhKSWwz?=
 =?utf-8?B?VEZndGZsNFRvb0NYVGw0K1YxczM5NzBDdkZPeWpIK2x6bngxTmFxSjFBUWhX?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0970163-a552-44f0-d06a-08ddbe616c8f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:53:00.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txkUVX9q6eeAu1XbHPGgYte9M7kN90CdIiazaGQ46BxzlXBi9KInTD5q412K7bgG7vFYf86tIpwNud7hwnqlm2eGxs2Bm3TUP+xMzRy3VKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8223
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> The resctrl file system now has complete knowledge of the status
> of every event. So there is no need for per-event function calls
> to check.
> 
> Replace each of the resctrl_arch_is_{event}enabled() calls with
> resctrl_is_mon_event_enabled(QOS_{EVENT}).
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
