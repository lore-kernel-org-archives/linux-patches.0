Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0833594B
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007776; cv=fail; b=LiBfw4zuE7qxHReclYu2tKVP+l5bTexnDD2KGQoaSGjqU1LsD+czIwFdYDnKSURjHRx0YuobKS9XxcaDaBsgFTW9tN1cmG+/IYTx1drGysz/dpw4WkklISqgIw4G08VKos+rup8lHFRfuVi38l1wjYmHw7JX52Z0QqhZ7vVZVWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007776; c=relaxed/simple;
	bh=Xh2Oxizoraz4VXmYSOTMbFvFj13GCVflAJf2EvP9z+4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=szXqvXMJgWWlyMmlBKGSe1ZJA2WywvClnrPToXJzmw9etQWCby7HbZw1lC8QcCB3oN20nP/CHjEtOuVzrXOCGF+IXVil/qpYDQ/ud7t3b0eRi2cfxpaksSeamA9ZzgoKPcoSCQ406Q3PqYcCWwDY2weUNcBjD6yQ1wcAhnLzN04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ni+SQO+W; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ni+SQO+W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007774; x=1780543774;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xh2Oxizoraz4VXmYSOTMbFvFj13GCVflAJf2EvP9z+4=;
  b=Ni+SQO+We2VN/og/y0EL63QhNKOqeCOptwPfvYLfo4e2+KWQPnnsaX59
   /4m+qQHu3QGFKsSFWZl/ewftkH8CIICc8cEpvZSL/mTAMPdoiFL68VokG
   /6ff2qpOlIvGwuaSoiUuOae+zPts+huLc7HHJPspc7l/OOEQdkw5194g/
   YfuXzGgNbHCC1WMd1Mqd43uaAPRbsgFcZNZEFy5k60uqyA8OJDiAGXZuQ
   qIP01gWXSQInD0xhEYtSV4Lzw1iVhbDr6mS2xGqgv9W9pC2v6r1HEAycm
   7KguTvFvxG2nKmfgkFwt3YTGFS1qaCCyUYBN4JrHcYe5yDrR6enmDuhot
   w==;
X-CSE-ConnectionGUID: Dj+BeGS5Qdy7ZeOmKowIyw==
X-CSE-MsgGUID: EuEgqMS6RVK3YGB2/bvz3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50985337"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50985337"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:29:34 -0700
X-CSE-ConnectionGUID: ySMd8JhDTOauUksoULzvJg==
X-CSE-MsgGUID: bQ0N54LeQKePYyMljG2guA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="145660411"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:29:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:29:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:29:33 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.84) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:29:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbZyBSYr+sn1+7a4UwAJXD1kvkf56/fyqp1IMptPH/FFhEYh7IPdh9f4Y17lOA/qQzoZX79oubAu8bX/teJzw4QUT5uxS8g93eOYum4k47r6d0uTQONYipaIJXeOZvZRmi3hvLmnggTGW7mRRmpF+GRvIDnKIVcBIoIKczmj4x6dVU8gmkSmIim2m6TCzRV06+bHcVbbfKnLqNO/lJ7POAIUcWkGSfG7MeSaHmcsKM8Wk78pKD2xPxmkxCkRT0j2Kx7BohROEcWJFRkGezk8nWkpWkMPMEScwGw+nFk/NKjkubPVYKPYEF6Ydy3KWtD3Kpy+SdGtxv2BJvRQ4DBypA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjO7AXpuyfZ9hPxv8PNFO0MyCGCdIaoOyo9hTq8Uc88=;
 b=dbanf6qkL0k0f2zI7lyWGJd0/jrCdS0P0MswD2jMTuByquvaABIQAlLgngD05zWg2p1zQPm0ov3NyBGfC5KQLa/HwcQ0duRKzDYRZR3/YMp+xEtwey5to/vCj+Y0gRQqvJRAL2AeeA43FEU1edIK/H/KaW2XT1REUkmIZnUjBpoD3+FnnYfXP8pmn31LhPVlgX8oxcerNJ58EFIpaHe2z2kfRGjPRvgiPAGxSaKUqNmz57t9jKYm9k/KptpUowOGzDGvFHm+M54KEdqWoZGVDy6cUPKukvQBnguViZlT6M8Qh3+ko00QB9xOGuljSk40BcErmg2c2WCjA5+yo0hUKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 03:29:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:29:17 +0000
Message-ID: <5f836ef3-bac2-4b86-9978-56e913ea222c@intel.com>
Date: Tue, 3 Jun 2025 20:29:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/29] x86,fs/resctrl: Prepare for more monitor events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b2b4f1-7625-405d-a144-08dda317fc5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SGNIaWNTUjUrKzN5WC9VQWEzS3RtR1RSS0Y1RHNzVHBVdExDVm0yUm1QRzJ1?=
 =?utf-8?B?c0FoL0NHS3J6S2hYazltUHVrMTBiVy9Sb01jOHo5SDRvZit2WTh1L2FibkxF?=
 =?utf-8?B?a3JEK0M1LzdKWW9XV1piWE02M29KNDBhWVhlS0loNFVXcjdpQlVLQTVxM2Vl?=
 =?utf-8?B?Tkx3Y0lXVHNwWlhYcEJYRFQ5bUVSeUtjMWhWUzFYZXFCMDFxa2cxOHZUVzdk?=
 =?utf-8?B?V2lRQmxFdlk4c2twRHBEQkM1Nlo1ZXJPWnpaNzN0NndmYVlaZnVxVFZRQmF6?=
 =?utf-8?B?RUlGSWlVYjVaVFlZQk9JcEt6UFJnZVBTN3RyYUQ1NjFtWEcxZ1FabWlJR3kw?=
 =?utf-8?B?ZHlnTTgvVnNXcmNqelA2Y0VsUXV4eVB2ZDg1SlA2cms2Mk91Q081OWkzbUQz?=
 =?utf-8?B?WG1VcmcyRUNwckoyblNmQnQwZDZVNVpjeVlXVjFReXVHcEdkNE1NbnpRYUZG?=
 =?utf-8?B?RmhOY0VyUS9wYjRuMUszWkx5aXZyVGNjQ0NYZk5ScUIzVEZ0dEI2d1k2OHlK?=
 =?utf-8?B?ZlhJU1dZY1kwNERZeHVwYnloS2QzbUhnLzNkOHQ4SzVTNlFrYkNZQU02YndR?=
 =?utf-8?B?TmExZWtRNU5Fdmhtc1RCTzB1VkdoRDkvZEhQeW1NS2U0VkJvQjMra1FBV0d2?=
 =?utf-8?B?WFB4YzBuOWdXTi91azhpNGNPaTVnKy9DZ2Z6cXNFZENldDBnbHE0Ylg5QVQr?=
 =?utf-8?B?S1hJR2RabVZyK2ttSkozcXlYd1JrZXNhUk03eEtIQUo2NTlBUCtpTVovV3Js?=
 =?utf-8?B?U2NQZ0NYanNNYVpLaGw0bFIyN1BhcUY0bVlzN0xuNDVHbXZSNlJMc2U1Ny9E?=
 =?utf-8?B?aHNzSmx1RWcrZERSQ2ozbXc4RzYvdEVka2lYSkFCVHZnU0pvUU1GMU93THZW?=
 =?utf-8?B?bVJXVXArNUUrS3htVCtCVWNMUFp5NUJ6UTQzRFdnUXMzSnBMZEtQSmFXeEp0?=
 =?utf-8?B?WVp4alF0MFpGMWxCb3lLSDE3K1hZRWZvUDVyWEJNcWRYbXNBUk04MTZCOE9T?=
 =?utf-8?B?ck1ZRVlZcnV6b3lEM2ZHdCs5U0ZxczloeW1KbVA4V2dVaUNYb1dXM0d3NEFp?=
 =?utf-8?B?M0Y1M2U2NDBOYVNKZko4d2lpMUNPMnVabkRuek9melhKbm5QUzJ2SWFDbzlF?=
 =?utf-8?B?WG5TZXg5NlM1a2ZVOUNyZDVzNGxpd2l6dHBQVW80eUtUU0FHQ1dvaEdxRmVG?=
 =?utf-8?B?YUdFQzJ3MmM5UTM0RGhsV2Q1WDB4ckhXcmFrM2ZBOTBwbWwyYmt0SmZlTHNo?=
 =?utf-8?B?S1RQSzhPbm9sZS9hVFNVZm9qTmwwUy9sZmg4U3EyKzVwaHFnYVErYkljRjF6?=
 =?utf-8?B?U1FJZHc5UHNhTUZxdTdRTzFpT0YxNDV2KzlOZXZhQXFmR0JSWjltZUpqcnh6?=
 =?utf-8?B?MEE2UWJvVlRlNmVMd1Z6aUZpQm5UQ3kxd0JhS0FTd296T0JGMkhnV1RORlo2?=
 =?utf-8?B?TE80ckMyeHUwZWQ0Rkdsc2wvMDBXTEFhekcvTkhxNXBrenpVWFRDcUxsTlI2?=
 =?utf-8?B?cWZvTTFheElWZVcvd0x6c3dDOUExQktxTDdia3QwRGsvYXJXT0dBcER3SThr?=
 =?utf-8?B?TVAycHhubUhSR2ovM2lybmw4djUxZ05WUEF1OEdtSkVyZGtrM0d2bEtkYUtN?=
 =?utf-8?B?SGlSeUNhRHdRdzVUSjZPSjUyK3JQQmJCa2N1Zzg1TXdQSkRiR2dCRXZnaHFD?=
 =?utf-8?B?c21PVDg4VTlhVGZ2U0FJTzVhVWJwK2U2SlNJWmlOblpLcTBKdXQ0dFVwblFY?=
 =?utf-8?B?anpxUkh3UThoT1A4QW4vZXAya1kreHdYV01qTnEyd1p0bVpTUUpncXRaU0o0?=
 =?utf-8?B?YTJlc1BYRTlLUlZHNWZwWWdUd2VSQnA5U2lmY0dDSEZmTGZOclVFRmM1ZytD?=
 =?utf-8?B?aUJNYUtFZitGbFNRZktFcDcwUE1GTGk4aTExSnp2V0dycGRveDNqeHkxdUZ5?=
 =?utf-8?B?cDEzbFdwMVNoNUZxU1hzN2ZDU3ZIMG9Kd1BDQ2h4Z2trR0prNVByK0l6STF6?=
 =?utf-8?B?bmMxd0x2T1Z3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mkt4eFRiQno2TlV3Q3c3TU5PZnFRR0M4VS9GWWErT0hqUWMzcmtPS3U4R3dL?=
 =?utf-8?B?U0FOWGJsK3lZSmJGWHMya2o0dzBqQURMVE1aTzVhaWlwOG9PMFlmeXNyWVRY?=
 =?utf-8?B?QXdTREdrNWg2cG1hWFZmWGFHVW1PMHlnU3N2QTg0aEZoZlRDakJOQ0dsM2ts?=
 =?utf-8?B?elZOL0hia1NkNEFXcDBDSk42NG11YUdwRWs2Y2R0Z3dJaHVBeDFuUUtsUXhi?=
 =?utf-8?B?NTZ0d1FRTSt4bExuMkVVemN2WGEyZWZLckdIS21yWmNmKzQ2QnZnMEllcEZm?=
 =?utf-8?B?ZllZSlNhTkJsT2xVaitkWWMvVGFUcFdGWVV2SEdUK2NhZ0JEOVRRVU0rTVV0?=
 =?utf-8?B?YmZqSHZ6bGgxenBFNFVFMGhCZGhMa2dwR2tmSEg3REFtUFkyWnBReFh1dHcv?=
 =?utf-8?B?cUxwMHM0UXNBUHpZRVNxR1VwUEw3NnVYNFVtMXBQTEMxaTYzNXhvMUxqTmUw?=
 =?utf-8?B?L1d1UWllanN5MG10LzhPUjhnZWxGOHJxTHgwemVVV3AvNEVuTEdNamZhdndi?=
 =?utf-8?B?U28rM2NseG1KWDVkcXUzNVErN0FqVExJVUJJK1NzT1hMMElWYXllbzdRRmJi?=
 =?utf-8?B?UjRJK3N2VlB1bGpsUG5Lbi9rSlhIV1BWZWtEOVlIaVB0eW9TRjQ5TnE1SVRR?=
 =?utf-8?B?anNWSlVKd3RSUlJBWVY1WlFoQlJkQTB3ckZSNDZHNFpSUlNhRUxmZ2ExQklv?=
 =?utf-8?B?WElnNExVWitoZTJkZFhJMnN1NGNVMGxCNjZnU2swbWNsalhpc0cydEpFS0tn?=
 =?utf-8?B?b0xlNFY5TU5ubEFuYkRORVR3QzNvQW40NmwrcGV0TUhiVHJJS3ZTSHJTOCtH?=
 =?utf-8?B?ZkhvU1pWanBSQ01qR0FjdU00dnh4NWNydUtRT0ZITkt3Q0thWGJsZDVzaFBX?=
 =?utf-8?B?MGFMUy96RVdtcDQ0UklBa0tIUU1mOFF0MUdwdUV4dnN3eHhQTnU5eGJqTlRI?=
 =?utf-8?B?Ny9nLzBuaGdua2ZuNXByaVVNaFdrek5ibDZGb1NjdjZYZFBBb29sRmN6K3h0?=
 =?utf-8?B?MDN0NXlTbVhiajZZMXdiMC9jaVF1TzNEOGFvQmJWV2FJcG5rVFV3Rko5ZlJB?=
 =?utf-8?B?ZlQ3VXozTjBKU0I0OHJaMVVHTU1hQlo0eXB4azdJQlJWK3gwTmp3MW1waldB?=
 =?utf-8?B?TmJXSU5RcGp2UWJ6YjNrdThEQ2JMQzFOM3JodzZvb1NndjNGK3MreHhsT1J2?=
 =?utf-8?B?WFVpMzJBU20vYW1vOFdscUF4YXRMSzhacWRhckZNUitkeVNmdXpma1ltRzlZ?=
 =?utf-8?B?OERaeFc0cEhObnFiY2xTQzBsOVc0UDVRRVQyK2lXa2plYnlRUU5CMmc1NDUr?=
 =?utf-8?B?NTlEcGIvZGNSaGR1M21KR3NXZVAxa0xMTDRORGFDVklmTTFQbzFlMHhJT3RS?=
 =?utf-8?B?aXl5TVFyVjQ2eWo2WmFSQzB5YmZvTFVSeERhTzFWcjVtVzhZbVhNL0ErSW5R?=
 =?utf-8?B?R0F3OXo3Q2x3bzFiM1NZS1dDQnlQeGM3b0FMMFF4NXpoYjI4NUtaeU9BMmlO?=
 =?utf-8?B?VUdya2dVdVY3L0pqaUxzZG8zckp2a0hadzNNOGR1YTM2R1RTaWVKUWl1WFZ6?=
 =?utf-8?B?ZjZNdjY5RUR2NG5qb1ZzbTc3WW93bGwyeVlKUjNhMWFMQXNTeWRodVBsT1dK?=
 =?utf-8?B?eUlCV3RrTGFSNStTbVBHa1lseW11b2YySGhPZlBZZGdpSHJCSEhvL21QSHFi?=
 =?utf-8?B?bkRSYmZWN29CZmpVUGtxbUYyMUZRYitFTzIzSDVMYU9TTDRUNFVSbENob3NY?=
 =?utf-8?B?T1JkOVBKK1Izc1lqOEhPYlRvMEJGT2xTK1BXdlVhdVFVeGJsRlFGL2o4L1Fz?=
 =?utf-8?B?ZkRqclZFZHR0cGZ0amNKeTk3ZFFaTUJ6SlJGYldzMy93OTk4ZUhtdGJscVN6?=
 =?utf-8?B?MlNYcXE3V00yRVhOSm1pK2FZb3gwa3hXSWx5a09vb0ZDbVBrYU5UeU4rMDFR?=
 =?utf-8?B?NzRKc2x2ZzlHRnhlY3ZscjMyUEZ6NTRGSmh0MktwOXgxNHl5aFlzTDdIdnpH?=
 =?utf-8?B?eE8yTGpNWGtTVTY4MjFOQ1FkcXBNUnBpMEh4clRNNG5PYmNNbTF2akwybmFZ?=
 =?utf-8?B?T2tUZ2NEY24rZFI5MWNDWEd0L0hOL0lTME84emozbEhYSkxrOXJBRmttY01Y?=
 =?utf-8?B?TnpZQlpmbElGY1A5YTVTUnJ0SW5qRmZDemhORVM2Z2RheGQvY2RQakp0ZTdv?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b2b4f1-7625-405d-a144-08dda317fc5b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:29:17.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJDRRJla687mw5Mh6xyahzMCNGPANUtjy0/dcOl075fPg9BdQrAO7h53HM9+MlhhSuYWxvBEXLbrvOw+wl9PSTD+1HuZehJpk2lJyFD238w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
> 
> There are two MBM events and resctrl is coded with a lot of
> 
>         if (local)
>                 do one thing
>         if (total)
>                 do a different thing
> 
> Change the rdt_mon_domain and rdt_hw_mon_domain structures to hold arrays
> of pointers to per event data instead of explicit fields for total and
> local bandwidth.
> 
> Simplify by coding for many events using loops on which are enabled.
> 
> Move resctrl_is_mbm_event() to <linux/resctrl.h> so it can be used more
> widely. Also provide a for_each_mbm_event() helper macro.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 15 +++++---
>  include/linux/resctrl_types.h          |  3 ++
>  arch/x86/kernel/cpu/resctrl/internal.h |  6 ++--
>  arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 36 +++++++++----------
>  fs/resctrl/monitor.c                   | 13 ++++---
>  fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
>  7 files changed, 82 insertions(+), 77 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 843ad7c8e247..40f2d0d48d02 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -161,8 +161,7 @@ struct rdt_ctrl_domain {
>   * @hdr:		common header for different domain types
>   * @ci:			cache info for this domain
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> - * @mbm_total:		saved state for MBM total bandwidth
> - * @mbm_local:		saved state for MBM local bandwidth
> + * @mbm_states:		saved state for each QOS MBM event

This can be more useful. For example:
	Per-event pointer to the MBM event's saved state. An MBM event's state
	is an array of struct mbm_state indexed by RMID on x86 or combined
	CLOSID, RMID on Arm.

>   * @mbm_over:		worker to periodically read MBM h/w counters
>   * @cqm_limbo:		worker to periodically read CQM h/w counters
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
> @@ -172,8 +171,7 @@ struct rdt_mon_domain {
>  	struct rdt_domain_hdr		hdr;
>  	struct cacheinfo		*ci;
>  	unsigned long			*rmid_busy_llc;
> -	struct mbm_state		*mbm_total;
> -	struct mbm_state		*mbm_local;
> +	struct mbm_state		*mbm_states[QOS_NUM_L3_MBM_EVENTS];
>  	struct delayed_work		mbm_over;
>  	struct delayed_work		cqm_limbo;
>  	int				mbm_work_cpu;
> @@ -376,6 +374,15 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
>  
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>  
> +static inline bool resctrl_is_mbm_event(enum resctrl_event_id e)

nit: e -> evt (re. patch #1 comments)

> +{
> +	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> +		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> +}
> +
> +#define for_each_mbm_event(evt)	\
> +	for (evt = QOS_L3_MBM_TOTAL_EVENT_ID; evt <= QOS_L3_MBM_LOCAL_EVENT_ID; evt++)

Please refer to comment in patch #1 about possible name change to"for_each_mbm_event_id()"
or similar.

> +
>  /**
>   * resctrl_arch_mon_event_config_write() - Write the config for an event.
>   * @config_info: struct resctrl_mon_config_info describing the resource, domain
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a25fb9c4070d..b468bfbab9ea 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,4 +47,7 @@ enum resctrl_event_id {
>  	QOS_NUM_EVENTS,
>  };
>  
> +#define QOS_NUM_L3_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
> +#define MBM_STATE_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
> +
>  #endif /* __LINUX_RESCTRL_TYPES_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 5e3c41b36437..ea185b4d0d59 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -54,15 +54,13 @@ struct rdt_hw_ctrl_domain {
>   * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
>   *			      a resource for a monitor function
>   * @d_resctrl:	Properties exposed to the resctrl file system
> - * @arch_mbm_total:	arch private state for MBM total bandwidth
> - * @arch_mbm_local:	arch private state for MBM local bandwidth
> + * @arch_mbm_states:	arch private state for each MBM event
>   *

Can also be made more useful like previous example.

>   * Members of this structure are accessed via helpers that provide abstraction.
>   */
>  struct rdt_hw_mon_domain {
>  	struct rdt_mon_domain		d_resctrl;
> -	struct arch_mbm_state		*arch_mbm_total;
> -	struct arch_mbm_state		*arch_mbm_local;
> +	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_L3_MBM_EVENTS];
>  };
>  
>  static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctrl_domain *r)

...

> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index fda579251dba..85526e5540f2 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -160,18 +160,14 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
>  						 u32 rmid,
>  						 enum resctrl_event_id eventid)
>  {
> -	switch (eventid) {
> -	case QOS_L3_OCCUP_EVENT_ID:
> -		return NULL;
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_total[rmid];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_local[rmid];
> -	default:
> -		/* Never expect to get here */
> -		WARN_ON_ONCE(1);
> +	struct arch_mbm_state *state;
> +
> +	if (!resctrl_is_mbm_event(eventid))
>  		return NULL;
> -	}
> +
> +	state = hw_dom->arch_mbm_states[MBM_STATE_IDX(eventid)];
> +
> +	return state ? &state[rmid] : NULL;
>  }
>  
>  void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> @@ -200,14 +196,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>  void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
>  {
>  	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> -
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
> -		memset(hw_dom->arch_mbm_total, 0,
> -		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
> -
> -	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
> -		memset(hw_dom->arch_mbm_local, 0,
> -		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
> +	enum resctrl_event_id evt;
> +	int idx;
> +
> +	for_each_mbm_event(evt) {
> +		idx = MBM_STATE_IDX(evt);
> +		if (!hw_dom->arch_mbm_states[idx])
> +			continue;

Interesting change of pattern to switch from using "is event enabled" to
"does pointer to state" exist. This creates doubt that an enabled event
may not have its state allocated? The domain would not exist if the
state could not be allocated, no? Why the switch in check used?

> +		memset(hw_dom->arch_mbm_states[idx], 0,
> +		       sizeof(struct arch_mbm_state) * r->num_rmid);
> +	}
>  }
>  
>  static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 325e23c1a403..4cd0789998bf 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -346,15 +346,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>  				       u32 rmid, enum resctrl_event_id evtid)
>  {
>  	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +	struct mbm_state *states;

nit: The architectural and non-architectural states are managed the same way. Having the
two helpers look the same helps to enforce and explain this. It is thus unexpected that
one helper refers to the state as "state" (singular) while the other uses "states" (plural).
This causes reader to squint and try to see what the difference may be, but there is none.

>  
> -	switch (evtid) {
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &d->mbm_total[idx];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &d->mbm_local[idx];
> -	default:
> +	if (!resctrl_is_mbm_event(evtid))
>  		return NULL;
> -	}
> +
> +	states = d->mbm_states[MBM_STATE_IDX(evtid)];
> +
> +	return states ? &states[idx] : NULL;
>  }
>  
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)

Reinette
