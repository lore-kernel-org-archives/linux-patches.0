Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9157036124
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 03:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757475585; cv=fail; b=WLdnYTfqkN8WvQutEwBwZDFbkgTtiAa4hqal7RmKHNqf6K3QmkM+NXQDbTjElkDMkPQB+T4mBvWI/t4yTDQWjFAJeF3vCXnqheuJGApvxcfdE3mIb3ddaGOUmstboFZindctsv2x6KHq5vaPtg0F/Ezvaf82GSgas5jApTYx/NE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757475585; c=relaxed/simple;
	bh=SE8UEhlq2XUoyuUYxjbImQhgPHQ8ywqWE/gVaop032o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uYKIwOEJBeHjY3mwL1dIzFSgvkTdGexSbfhD8QJwrCh6lciHzbBZiqiFnXG9iX1jFTPQxPNSsvMLcvAQfJCQgVpCIfdQ6fneHox9/xagQpTNDdLM3BDxw8/ORtb4e2CzKcqu4DrZO3iz2d3ZlF25bkLLzKE3uiwCYCkQcs2Jx0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cqsNJ435; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cqsNJ435"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757475581; x=1789011581;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SE8UEhlq2XUoyuUYxjbImQhgPHQ8ywqWE/gVaop032o=;
  b=cqsNJ4356VQqlsxjQ8T2e0uZ65sZ8k4mSLU1IO1lMX7nnHuTVIp5G4GH
   XFR+dfLp0yQSHEVWcerjqlX++tkNhsgWkqSF28mTiRRGONYTkfa/127a2
   WECJxcp9VJi2SPjt0Zlo41+iWSQvRTiRh2+sJ/eZ8/av1zQMSRn/9sdIj
   L9o1D0y0mCpLCFUNd48ATHTkw22Ogxberir3+kzi39ljqpxgU0sQx0Igh
   95C2asePQX18SBJ0ezBdDPNpqJoI8wTtJh1XVyNHqUyNfKzfSekN5WCjU
   EtZRMrotLkzL7qG0B4qScEvDt+tcYCWkcIRwYbbZmISVnzJlkTwyOTa9G
   w==;
X-CSE-ConnectionGUID: 45SJVin/T1yAqmTmSVZSBQ==
X-CSE-MsgGUID: YK3GKeBBRFmuKezVajkH3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="70392170"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="70392170"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:39:41 -0700
X-CSE-ConnectionGUID: oNvo6X3SQbixJH4amDP6wg==
X-CSE-MsgGUID: 6KJJJeBLSMOK2Lb6pJrHSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="173658118"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:39:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:39:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 20:39:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:39:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJtXlzRpzYL4+wVRa4pWUMp72eKTykVmpB1g7PsSpqLmAulBv1ATpfYe5NRAiyriHWnqoZEsvpZga6KkDlNq/IcDh0S/C4C4+20UFpftYMLx3bPl84FfgzqN6xfvdSGzV1qhOMlIamXummQfd67qriYFVUzTn3N6uNvkIhYrO7o4Ca5iTLnAT8auu8zQ5r7aUbGTS6Z+LImwyTs6Vyy7KQp4WFwGNCe+uwsdwDfQUn79g918pKfzfYiXMpvpDu3eV1NTwgtJu8civp0SStONkn00HDj1JEj3FL6W75KJVldPYZhLuaFrVCZpr9i9colodieWdIySYkFERJlkEDdUWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZtPLZU7Rj//j1PdS+dFuj2SnYOCv6hKRK8VGKPh85k=;
 b=OhubieT9dW/1ueK6RABTxW8SNrTa+WLMmB5rvy1w+7jdHf2wix8yiKP/Z+bFIv3S2NLPnQqNw/9xm7bEhCfyw9l15LqX5C3RNLRm29Mu/QtOa5OduHPEOHIGEvLVk6RkSU7oBvmJ7HsONKa5qRcPVVah0KJ1RmuSaP6L4kPvaeiBXnmuwAdraFhVm0z2XTRp7slDNiOjGHvspAYrUkhlmN1xCsfLFFtN4E+U1jvmwWX1GhFkfXuvxvN4uLcqqo1Q/6mKcsH2Wk5+ccapbcJfPcolhqHTHuPYAFxN2DQ1dcge0KuUJrIkmDMky0a2+bdc7TA7WRx6v1KYXnkqOUe+qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF66B2E927F.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::830) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 03:39:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 03:39:31 +0000
Message-ID: <f706f57c-0955-4437-a3ec-9dd081d40c20@intel.com>
Date: Tue, 9 Sep 2025 20:39:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 17/31] x86/resctrl: Discover hardware telemetry events
To: "Luck, Tony" <tony.luck@intel.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?=
	<ilpo.jarvinen@linux.intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-18-tony.luck@intel.com>
 <1cc035b1-7bd8-8fa9-e3d5-f530bcdec517@linux.intel.com>
 <aLiFCRiM4UgC8c7C@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aLiFCRiM4UgC8c7C@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:302:1::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF66B2E927F:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b48b978-3b74-414c-ba7f-08ddf01ba6af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WTFmK250SUJjYW5xUUw2M2QvLzVBVHVpanIreDREWEZHLytkeXFxclRDMElB?=
 =?utf-8?B?ZWlJai95b2lkK0hic0VLT3V5Z0pIUGYwZEdkdXVDLzNJeUNoZW1lb0h6OEhw?=
 =?utf-8?B?dXI3b3NoM2pMMVUxT0lRb09PK1ltQkYzKzBKeXBwcDdGVitKRzNjbkRsT0xC?=
 =?utf-8?B?VTkxRklFRDlHd04ydFVyQURId0lyYTJZMElRMGhZamZxWTRPU2xsY1JnV2tk?=
 =?utf-8?B?Tll3VWFIS01ZdXpSRFRxcWQyaDFIbm80ekRGZXRpcEp6d1dQSWo2WnlNOVZo?=
 =?utf-8?B?MjZ1dWNFZzBKM3V5S0FrYnI5TGFRaUxGNGxrbTVtbG5zY2kzZTZadGdmSUd0?=
 =?utf-8?B?VmNYNXcyNVp1N1Q0L1pBeXRyQ0FPOWdwUDVpOHlYSDVDRURrcGVGZGIvZHdQ?=
 =?utf-8?B?bGtoOW9pcWh6ejIzSW13K3c4Q0tINDJYby9SajAxdTZsaUxaN3hBUitjOERQ?=
 =?utf-8?B?OCtHZFF4amd6TDgxY0lobTQzc2Nla3ZVRHpNTDg3UDU0WEpERjY2QkVqTnc1?=
 =?utf-8?B?RVV2cG5ZZGQwZGxFL0ZYNDN2UFdYK2RoMnJtNWIxWHJkdEdvTVUrV3BBZEJR?=
 =?utf-8?B?MllTTUc1VmJKVUoxYkxWZEZ6UW1iT3RodExEblNabzcxQlZaMUNlTjYzck9X?=
 =?utf-8?B?MjFSaWF0bjVVS2R1ZUpoMnoyUFJJSEtqTHR6TTI5ekU0c3NUczJuZ3BoUExE?=
 =?utf-8?B?MFk3S1NVZzZlejZ0OWF0YXdzYnR6OUpDOVlWS3c0dExTa3orNmVxNnJJUXlL?=
 =?utf-8?B?ZEMxWE1SQzFrSGR2Q3Vhbis5QjgrU0J1NkV5YVZqZG9QdUxXVXREeHNqV0dL?=
 =?utf-8?B?R3RFcG8raFZHQ1B6MHBMUUQ5UDVaalNhNk9BcjZ6S2xJNTFkNUIwYmYzcFdS?=
 =?utf-8?B?YmZob1lVeVVPQ1NFVHJPNTNNQ2dEbTBtUlkwdU92YWt6Z3dZS1FtUGt0WDI2?=
 =?utf-8?B?d2tkWXptSmZDQWNldnp1Y1dSTkhheUZEbklCNmhTTlA4UEpDYW1RVVRrQWU2?=
 =?utf-8?B?TGUxM1YxWURxWnVlNVNsLzZxY0hZNlFldVJWWGZzMTh1UmFxcjJ5NGUzK1Zi?=
 =?utf-8?B?akdBWjY3Z3hpZ3hUVkdDRW5QRVRZdmt6NjRWenFDVWJTcGM5cUZWc0grbTNS?=
 =?utf-8?B?ZURQK2l2bDV3VGVyb2cyN25LelNvSnZXaEx3RHVLWHpHRS9vSGxjMVVCOGhP?=
 =?utf-8?B?RUNHaWxOOXByM2ZzUjM5ZmxCWlZ4aFlrU2huRVFzSlJ5UVJUajM0OUtZZWVS?=
 =?utf-8?B?U2NSS3dIK2QxYnZNUjlNNkNwUzhCV0NhY2pCTVpwL2NHTkJlejV5TFFwMDY5?=
 =?utf-8?B?T0t6UXlwUGpMQzc0ZE9EenBRbFZwRDFaR0pvdG4xcTZ0V1VFZEloOEU3bjFO?=
 =?utf-8?B?QkN0eVZZMldSYnBpNTZMWW91U3pVN2g4d2FWSy81YXNzUGpQU2ZVWUhxMzkv?=
 =?utf-8?B?eGp3dU9ERUx0S2FNTGdOSldMbjFFOERoeGI1TURBRS9BdGJxV2hKQ3VhcVdS?=
 =?utf-8?B?bjJ5RVY1UkNvaDZmcjdjbXk2aDUzTCtmSFVveHc3bE5CcjZJMTNwaS9uOEJ6?=
 =?utf-8?B?ZEM5MktPaFp1MUxEdnEwTy9mZzVXejNOekIvVW5FSHNQMlYxUXlkS0MrU2Fq?=
 =?utf-8?B?NmdMT1lFZ0UzeXU2L1FCV1drbC9CZHI5eFVHY0VsWW9jTHE0bU5tT1dRQUtw?=
 =?utf-8?B?U3Z5dGFsWlBEUXdtMys5N1lvY1hSa0ZsY28yVml2RHJRK1V2QXhFYTZYSVpj?=
 =?utf-8?B?Q2xGWjA4QmpTYnorcHphNldRa3BGa1cxcGtlbWJRWmQ1cENQeEgwdnJoQjE1?=
 =?utf-8?B?VXY5b08yZHQ1ZlJwT0tZUm5YUW5ldmpldktSYUxRTHluK0tOb0YrTXV5TDZE?=
 =?utf-8?B?a2xUcVZNaUVObEZuR0pZZGdQWTg4NVBrWXpZaHEzVnlmR2VaamFseExRNUxC?=
 =?utf-8?Q?tw9Shblz5RM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0s5MlFPVEk1bVdaaUZoc05vVEpEazNYSFJab0greWdQNDNFVWxnSGkwY0Zs?=
 =?utf-8?B?YmJtT0pIYTRpcjl5S2VyN3F4TjlUT3MvbTcvenRDTXlCdkdnaDE1MjBRM3N3?=
 =?utf-8?B?Q0tNaEYrUU9kQXAxMCtwQWxLdUV1UzF6c3pQNTgxSjdSbTRDKzFWakNKcWR0?=
 =?utf-8?B?WmZoU3FUQnZhNGIwMndSTEJjcDlQa2VlUjZZdTV1SlJESUU0QlZhNUNkM3hX?=
 =?utf-8?B?bXVTNzhCcmIyZi9mOFVBYVJqVGhveEhSTXhqRVAxelRyQm02NmFob09La0Vt?=
 =?utf-8?B?Qmk2cmRMak1NQm5nYTR0K3FYb0lFNUNpeFNoTXB3YXA0TDRHeG5yTFBDTVZL?=
 =?utf-8?B?bk8zbWZBY2ljU1BuQ0lFcnhqdGl5Sy9TUlliNXVmS2xnRVA2UmREZm51aXdS?=
 =?utf-8?B?M3U4eHpVTitrM0RTUk81UlhENVpXcVdxaFBiZW1sTC9nYzN0ODFWUjA0ZStw?=
 =?utf-8?B?SlNscjZzdHlMVVVIclJHY1ZVeThFM1MrYVJjTG4yVit0dXNCMUJhdGNic2M1?=
 =?utf-8?B?ZTkzblVTY3dvcWZKdW1TSHFrMWhiT1dYaWtNV0JXU2hnenFhRlF0QkNVZHgv?=
 =?utf-8?B?Z1lURVNDWmg0S2dDYVIxdzV5aENLV1JjWEFDS3g1UTN4cWxWUTVCNWVqSGlx?=
 =?utf-8?B?d21NcXRwVjczanhkTGFQakVTT0pUZTJHYVJaMWFKNVl2MytwS3FnWVo4MEhT?=
 =?utf-8?B?amZRYlc4am9EcmFGUXg0US9DZEcrNGp4ZlBMQ2UwV1JxWWxhY2hCK1ptNXVO?=
 =?utf-8?B?Zlc5c3ZCQkRIRzBnN1F4LzNseHBlb1dKb01IZDM2S09OeGJqWGVxQjV6cGpT?=
 =?utf-8?B?VTFOeVphLzdFaFpUZ0dKTHI4SlFGVkRIRFZhWmpGbThoMGxUZ012MGxXdFNW?=
 =?utf-8?B?QmFVQnA3VlJUdEJsbjNnc0pwZC9KbW1haHdYSnFHMlVRanhjRHBra3dxNll5?=
 =?utf-8?B?eHJEcDVyUGY3WWVYdUNGMUxHb2ZtV3AxVDdWRkFhTVVEMkdQeHJPN2trRHhL?=
 =?utf-8?B?VE9iMHJkdEgwcWx0b3FoS0dxRjJ1QVljb2lIeDRSS1gxVm9RS3FWOGdOUHFP?=
 =?utf-8?B?N2tyd2c1dTl5NG9raXV5ZUt0bUsvRXA3QVdEOXVPcUdTYkFwSnlhN2ZZVVhr?=
 =?utf-8?B?M2JLU3pVWTcwMlA3ZUYxTkJxTndCNEtFS1padXduV3Nvcy91L2Rib21zZ3VB?=
 =?utf-8?B?S0RkUDBRQlpQR0NvSjc5OEkwUUNGR2haMFpiNFdGZE4wMTNrRWlkbzl0K2hu?=
 =?utf-8?B?SG1RNWplSGJiZ3c5WkpGRHJZOC81R0s2SmkzTUFvaXBFZkQxWS9uUnVJVVRp?=
 =?utf-8?B?ZHhmUU00d0pCbGNoS0lUVGVzblZ4WEduekZFOElaSEJ3bTZyUDIzRE4rb3pG?=
 =?utf-8?B?MVVCUGN3YzQ2S0hmSi9FaW5BWXgyUUJTTnR5TUpxbGR6TzBhTllFbk5HNHNF?=
 =?utf-8?B?TkFmNmMyTG0ycnV3aVVLRVN6a29PaFYxcmZxL2ZnaWRoVFZYS0tBMFR4ZVhZ?=
 =?utf-8?B?YUZnSURiaVRRRTJScXRHMFRaQVFSYXQ0VjViRVFLdkUxMm5WenIyYWVsZ2Vu?=
 =?utf-8?B?dGRwdDdzWVh2WGtlYWNrTEcyUTF4QjZ6WWVGdjBmRlorWUFOQkxzS0thbmla?=
 =?utf-8?B?L3I3NzN6VHdJcVFCUHhmellTeHpaNGduSVI0b2hJWHpzM3pqeC9jZDM0MnJl?=
 =?utf-8?B?Q1o5STVHTmV5NVZWN0FWNnM4MXlTczVxQVdkVk1ab2VEMnFzSXJPNmxncW1o?=
 =?utf-8?B?SUo2VktPeHM2V1ROWjh2YVIvV1F0aDZnRmZsN20wUWtDZURpaHdZaDB1YkNE?=
 =?utf-8?B?SnlNTnJhQ3lGQjZ2T01YbnpPZUxxTHZrNlFvYzJwdEhRem41OE5BczFrampK?=
 =?utf-8?B?MmVIN3k3dnpWQTFDOVJRNjFSUkVYRjB2dWcxS0FHd1hPc2hNSnA4T1A3TEZl?=
 =?utf-8?B?UXRjdExETERwYUNhMDNmRjVqNm1HUmNQOUJ3bDh6N1NVMHo2a0VRdjBQa2dM?=
 =?utf-8?B?c2tLUDVLeGo1enYrVnFBemJROWd1TXBFVGFLa29zb04yMGUzL0swanQzQ2N6?=
 =?utf-8?B?b216OXhSR3UxVlVVcU5ybUQxQ25DMlpGZHZudzBDUFlON29XaDlJeFFqTTI5?=
 =?utf-8?B?NVVadWFvejlsSnZxanFuMnB0OG5scEFtRTFvNHRRNWFpNmpmdXZncG5WZTcx?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b48b978-3b74-414c-ba7f-08ddf01ba6af
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 03:39:30.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Hlvqj1qR2WN9N2v+Bb4tUkTiwKJjK5zT3uf3Otq/HPnq4ktcU5qSpy1sBzgQIKaaeYqVhxzH9bxPokbhKoePuk5jiyneahL/6HTAi/W7XE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF66B2E927F
X-OriginatorOrg: intel.com

Hi Tony,

On 9/3/25 11:12 AM, Luck, Tony wrote:
> 
> Ilpo,
> 
> Thanks for looking at these patches. Applied all your suggestions
> for this part. Updated patch below. Also pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip
> 
> -Tony
> 
> From c717ab20b7781eec8b6dcf711eb0e2f8255aef8c Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Mon, 25 Aug 2025 10:45:34 -0700
> Subject: [PATCH 17/31] x86/resctrl: Discover hardware telemetry events
> 
> Each CPU collects data for telemetry events that it sends to a nearby
> telemetry event aggregator either when the value of IA32_PQR_ASSOC.RMID
> changed, or when a two millisecond timer expires.

"changed" -> "changes" (repeated from v8)

> 
> The telemetry event aggregators maintain per-RMID per-event counts of
> the total seen for all the CPUs. There may be more than one telemetry
> event aggregator per package.

... and if there are more than one telemetry event aggregator per package
do they *all* maintain per-RMID per-event counts of the total seen for all the
CPUs? Above is not clear about this.

> 
> Each telemetry event aggregator is responsible for a specific group of
> events. E.g. on the Intel Clearwater Forest CPU there are two types of
> aggregators. One type tracks a pair of energy related events. The other
> type tracks a subset of "perf" type events.
> 
> The event counts are made available to Linux in a region of MMIO space
> for each aggregator. All details about the layout of counters in each
> aggregator MMIO region are described in XML files published by Intel and
> made available in a GitHub repository: https://github.com/intel/Intel-PMT.

I expect the usage of "Link:" will clarify but until then we can keep using
it based on guidance in maintainer-tip.rst. For example, "made available in
a GitHub repository [1]." with the "Link:" tag added to end of commit tags as:

	Link: https://github.com/intel/Intel-PMT # [1]

> 
> The key to matching a specific telemetry aggregator to the XML file that
> describes the MMIO layout is a 32-bit value. The Linux telemetry subsystem
> refers to this as a "guid" while the XML files call it a "uniqueid".
> 
> Each XML file provides the following information:
> 1) Which telemetry events are included in the group.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for this aggregator.

"this aggregator" -> "an aggregator"? As in, all aggregators matching
"guid" will have same MMIO size, the MMIO size is not unique per
aggregator associated with the event group?

> 
> The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
> This driver provides intel_pmt_get_regions_by_feature() to list all
> available telemetry event aggregators. The list includes the "guid",
> the base address in MMIO space for the region where the event counters
> are exposed, and the package id where the CPUs that report to this
> aggregator are located.

Please note this switches from earlier "The telemetry event aggregators
maintain per-RMID per-event counts of the total seen for *all* the CPUs."
to here (singular) "package id where the CPUs that report to this aggregator
are located." Please maintain consistent descriptions to make the
architecture easier to understand.

> 
> Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel
> specific parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY
> and INTEL_TPMI drivers being built-in to the kernel for enumeration of
> telemetry features.
> 
> Call intel_pmt_get_regions_by_feature() for each pmt_feature_id that
> indicates per-RMID telemetry.

"for each pmt_feature_id that indicates per-RMID telemetry" -> "for each
per-RMID telemetry feature ID/id"? (goal is for changelog to be less of
a description of the code and more what the code does)

> 
> Save the returned pmt_feature_group pointers with guids that are known

All guids are saved, no? Not just those known to resctrl?

> to resctrl for use at run time. Those pointers are returned to the

"Return those pointers ..." (but see below)

> INTEL_PMT_TELEMETRY subsystem at resctrl_arch_exit() time.

This does still sound as though resctrl obtains a pointer to a data
structure within INTEL_PMT_TELEMETRY. I think it will be helpful to
highlight that resctrl obtains a fresh copy of the whole datastructure
for its private use ... and not document the code so detailed when
describing this.
For example (please correct where wrong),

	Use INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() with
	each per-RMID telemetry feature id to obtain a private copy of
	struct pmt_feature_group that contains all discovered/enumerated
	telemetry aggregator data for all event groups (known and unknown
	to resctrl) of that feature id. Further processing on this structure
	will enable all supported events in resctrl. Return the structure to
	INTEL_PMT_TELEMETRY at resctrl exit time.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..1a9b864e2dc7
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/array_size.h>
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/intel_pmt_features.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/overflow.h>
> +#include <linux/resctrl.h>
> +#include <linux/stddef.h>
> +#include <linux/types.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			within the INTEL_PMT_TELEMETRY driver that contains data for all
> + *			telemetry regions.

We since learned that this is not the case, no?

Considering the new usage I also think it will be helpful to add a usage snippet like:
"Valid if system supports the event group, NULL otherwise."

While doing so, please keep the columns consistently under 80 chars. 

> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_energy_event_groups[] = {
> +	&energy_0x26696143,
> +};
> +
> +static struct event_group *known_perf_event_groups[] = {
> +	&perf_0x26557651,
> +};
> +
> +#define for_each_enabled_event_group(_peg, _grp)			\
> +	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
> +		if ((*_peg)->pfg)
> +
> +/* Stub for now */
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return false;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> +		if (!IS_ERR_OR_NULL(_T))
> +			intel_pmt_put_feature_group(_T))
> +
> +/*
> + * Make a request to the INTEL_PMT_TELEMETRY driver for the pmt_feature_group

"for the pmt_feature_group" -> "for a copy of the pmt_feature_group"?

> + * for a specific feature. If there is one, the returned structure has an array
> + * of telemetry_region structures. Each describes one telemetry aggregator.
> + * Try to use every telemetry aggregator with a known guid.
> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> +			    unsigned int num_evg)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	bool ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> +		ret = enable_events(*peg, p);
> +		if (ret) {
> +			(*peg)->pfg = no_free_ptr(p);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask INTEL_PMT_TELEMETRY driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
> +			       known_energy_event_groups,
> +			       ARRAY_SIZE(known_energy_event_groups));
> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
> +			       known_perf_event_groups,
> +			       ARRAY_SIZE(known_perf_event_groups));
> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	struct event_group **peg;
> +
> +	for_each_enabled_event_group(peg, known_energy_event_groups) {
> +		intel_pmt_put_feature_group((*peg)->pfg);
> +		(*peg)->pfg = NULL;
> +	}
> +	for_each_enabled_event_group(peg, known_perf_event_groups) {
> +		intel_pmt_put_feature_group((*peg)->pfg);
> +		(*peg)->pfg = NULL;
> +	}
> +}
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58d890fe2100..50051fdf4659 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -525,6 +525,19 @@ config X86_CPU_RESCTRL
>  
>  	  Say N if unsure.
>  
> +config X86_CPU_RESCTRL_INTEL_AET
> +	bool "Intel Application Energy Telemetry" if INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
> +	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL

Could you please help me understand why both the "depends on" and "if" syntax is
needed? With the above the config menu displays:
│   Depends on: X86_64 [=y] && X86_CPU_RESCTRL [=y] && CPU_SUP_INTEL [=y]                                                                                                                                                        
│   Visible if: X86_64 [=y] && X86_CPU_RESCTRL [=y] && CPU_SUP_INTEL [=y] && INTEL_PMT_TELEMETRY [=y]=y [=y] && INTEL_TPMI [=y]=y [=y]

According to scripts/kconfig/menu.c the visibility usually matches the
dependencies and that seems to be what is intended? The changelog only
mentions dependencies so it is not clear why there may be a need for
some unique visibility?

Reinette

