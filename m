Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C0C313E3F
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 09:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776243688; cv=fail; b=THT+W21LXCYIpFL91ZVMCDY2BqJEOEgbZ+8uUgKi6qUrZg9nznqtkIw+ZeNHvhUh+F2K6o34xcfsfcCB3+z39QCWTWaoHMTrwJMlkgP00r4cxQUK/XLcejYN7HvGzd+Kil+1352QeEPvDsOhXn722pZ1fsMvNRa3Vm1KwZFc6Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776243688; c=relaxed/simple;
	bh=kntCP7WDby+yyR1Q/GTVo0VaPM7stxkOqi1bnorEJGM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ixBxeOvM9tcmIDxrSL9JPxDOBMTvl7Q3dzXyn9yE7OenwpQyFYwdvgVTNxeE5IoYXUO/WjY/iCsgLt5/mI/nMVoYzHsyqpsHIDrVpqXbS1/qON8GUNCVxv/BKRF0B3no84/GCGs/8vucDlXGaAk24BGVc4PDw2fqCc0fY9rvNpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZW33SPQY; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZW33SPQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776243687; x=1807779687;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kntCP7WDby+yyR1Q/GTVo0VaPM7stxkOqi1bnorEJGM=;
  b=ZW33SPQYXhS94AXQs3w9KRULR7iAZOvnKcm9XiKx6BVBZeYZDm4xVfOu
   wgNy8QO1ZYE0rkul2bLHea/5ZPdWF6s18hPK5lIP/VzfaIjwDvwgdRpbC
   4m/kyxil+Ckmy+a7RZujvfcyumsjpBLO5q7CwF8V0rsXJQJAJkTcD2gCo
   OJabOWj1vrkS/NpMIGQClM64PRyXfnQiOwyMzXAPAriw3kR6n+KaME4NW
   GJW73pSNFkezosS0+eqK/wvqjNOqPyDy/2GrFfBFsxw/KkTGeJ16NpJfa
   MHXWnjlSDfggO3Vpwyd9ytLNRhyjsbFfVIBsttWWfUxYNRqWk7Ye07rQp
   g==;
X-CSE-ConnectionGUID: t1+Kjlw/RT673IvOE393Dw==
X-CSE-MsgGUID: M80zyJUeRcqT7nZjAmi6+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="79799088"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="79799088"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 02:01:26 -0700
X-CSE-ConnectionGUID: YvrxGSHPS4imye0Ie5pqhg==
X-CSE-MsgGUID: p8aFAU7NQ+engj9YeQi0VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="234763100"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 02:01:26 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 02:01:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 15 Apr 2026 02:01:25 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.55) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 02:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Owmcyb9ZxAM0ReFVpNv28k2attLXkl3dFQ7tdpmnjH/LBqEPvoD370xrulTGURoLUBcm+6zqeGJV9RO4beo+VH8aDjvyQuy9o/PdOb7jePGCk7n0BEbn1rkQyFutlHKR253CyA4qc5h9sdNXZgxrzAGfJ+m8biKEgUqLiJWC4Ac1erTnHGMB2QRofwVJkPZEA0PaKf2ZFyjF2Q0bQKgEEu22yUwE1nUE3FRBta0dfHyyDArR2Fnn+c/gwBre1MlxpEHnjqUn/5InlvZBudHkaB05lQtwTGtPWbXGFg1x5jBEnAs4cByA5aH85P7rASv52VGWSWJUJgeu/d233MCnxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XVvOBYbh1vB9qxBulPosGxUwrPs4hLpRWtNFAKHWa4=;
 b=DeHsDcWe7Fs6pIf1WstgSvTbIbBvTVHYyPsWYAJ3A3xzyyAWFtUMDBy6KZhiGt/o7uTf6y8gZMrSW1QeGy0Jc8ekDxDX6FgHPZ5pCJBEhVKWmg87vJnkpBL5KzAvYN+VPLZDrjg+jEsAGzSCxAh5y4NAo69204WWh9cH4Nxh8KSeNMZpDVb6+gnxeQVIA/C4z91QVhQucSAxQaVoMp5T7UCSnEMTq/WQ5spZdY6+5DVnVUZRU17JUDNF4KPmZjvuZGcMjWaWTkWyqfnZARLWUmWokFTzAjwTYQBYb6fD9scopRVTbJmKKjhDEgjoAoTGR6jONFUqDpWPRiiq1w4Tjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6967.namprd11.prod.outlook.com (2603:10b6:806:2bb::15)
 by DM3PPF83579A393.namprd11.prod.outlook.com (2603:10b6:f:fc00::f35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.18; Wed, 15 Apr
 2026 09:01:18 +0000
Received: from SA1PR11MB6967.namprd11.prod.outlook.com
 ([fe80::36a9:3aca:a63e:c8f4]) by SA1PR11MB6967.namprd11.prod.outlook.com
 ([fe80::36a9:3aca:a63e:c8f4%4]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 09:01:18 +0000
Message-ID: <f440a674-b146-4977-904e-172b4e42a6c2@intel.com>
Date: Wed, 15 Apr 2026 11:01:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 070/491] ASoC: core: Exit all links before removing
 their components
To: Ben Hutchings <ben@decadent.org.uk>
CC: <patches@lists.linux.dev>, =?UTF-8?Q?Amadeusz_S=C5=82awi=C5=84ski?=
	<amadeuszx.slawinski@linux.intel.com>, Mark Brown <broonie@kernel.org>,
	"Sasha Levin" <sashal@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155821.667271642@linuxfoundation.org>
 <5006a2a4e34e7fbbb89fc8969facc6b80c7d00de.camel@decadent.org.uk>
Content-Language: en-US
From: Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <5006a2a4e34e7fbbb89fc8969facc6b80c7d00de.camel@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR06CA0142.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::35) To SA1PR11MB6967.namprd11.prod.outlook.com
 (2603:10b6:806:2bb::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6967:EE_|DM3PPF83579A393:EE_
X-MS-Office365-Filtering-Correlation-Id: b49a3cdc-649f-4903-20cb-08de9acd8e8e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: x5+p6So/JMvXKdajIzyMKGsct7rcU/o6/CKy31AqAQBqlgnPm8XjskitcOjWFYdpruivRh1+2ZcOlmLc4W8SnLxj1eMffI252DIrfKKM+AD+lxZUBMwB7VeBbSyrXVV7mNH9BrU8Cv3YL53bu8xBPgz26JbscFwNUxKaP+SZqsabVd2WdB1VX3DasqVKcyyjC7mOmyNSRsMxKL/6vji5i8tpK1lJpOxrg9NNxr3WwcZWOFTRGKBcky97WnaplDmiERgjQESrfAoILpEjUsibaq8aX+my6SMh7bDy8ChKyWXlRu6Fa5h+uQQYuvKGRWkBbgy736btpiCduZzwdNI8N6+fCUv++hRccoB1loydeGCYLXOYsCCjWs8JMJTMMC4AiUrPoh3AITes9N+yhd2kaSYamp2YAUGeJ1OSvSHTyD8U3DMT/pdrFFXV+76AInc6QA0XlQ/OYcnSCN+kZlJcAoKrdwyVK1ZfgsYJeakrPDuKZldwukgYI/f6dStzVYVApRqfIiCIsCWbFhWgIi6apDF6Y9tfyhK1A5ZQloP30hj34x9rDKwaMTjwzczRQG+Tsc7llW127LByRdMoJjldwfU3gCkfm68FZlumAW540hryOPbzUoeRBVg5uCW2kSdZ31wmVw3rJUGZzQBzfjhqFeAsAJ1i6XwF+36Y7Z0mUKBVYYFsoU2i3SDL7DUeB5FICdN3uOS9SVqmP2EcHk1jBFeeKcTfZKkafGPBwfDoHGM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6967.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RndpbmVGcFhpVURuempJbSsyK20zSlJwQXp3dVpiTnh4RGh5WWpVMk9EZ2hy?=
 =?utf-8?B?SE1UVHJhOTMrZXlxbnNhMjQwYzV3TUJDcVlEMm9VQlFTRURJNi8rM05kQ29W?=
 =?utf-8?B?OFQvdm9NbzIzYTVMckoxYzdGMGx0VXgzUlZhaTEvcFJNWnE1dWxwQmZXVW9M?=
 =?utf-8?B?Um42emxxSXp0ZE9aYjRtclZOQ3JoUFNrd3BBUU5xWElRUUlXZFI3UFFpZ1J3?=
 =?utf-8?B?NjJGSS9Yei9INTFCRTgybWNtd3h0WlFqbmM0N2Zpa3lDbncwYUJZWEVOQXE0?=
 =?utf-8?B?ZE1JblR5MjRQb0ZDc3FQVUcrZFcwbEpROFBBQWxrbnUraFd0WHR3cS9XMXpZ?=
 =?utf-8?B?WVN6WnlJalA0cUhnNEMvQ0tzMVA4cXV1ZGJqNVNmd2k3ZW9nS3ozTWhrazFm?=
 =?utf-8?B?c1N0MU1HOVJYUkdwMnI0bmtKeGw3REVLUU5hV2o4b0hRSnpqTlhYOFNaYUQ3?=
 =?utf-8?B?dklMNG9zVFEyRDJucHRWQk1YaUVnSnZyMUdqN09OZ0NIT2NONVA5aUJtSVh1?=
 =?utf-8?B?bmhDc1l2Q3BjU2xEOExhWThYdk5nSFloNkp4NURYK3h5RFZMYW40dDBDY2lF?=
 =?utf-8?B?Wllvckt5NzBvdFdpdFBYMTh0UG9wRzhQdVRPRVpqeFQydktiSWZrcHFZTzh3?=
 =?utf-8?B?endlV0habEdvc3ROaEdpNVI4RFl2QjJKT0pUVXNuVkhzaGpIVnZhK3lkZUJT?=
 =?utf-8?B?N05POTRQeXVQS0t5YlBVUktIYXljdW56SUNhV0hjRHo0dXJMT2hLQjZ6Tllv?=
 =?utf-8?B?UDMwaGRwRVBiYjdJZHNtVHovOGFDR21IUW5haldSWFVIdm55VlczZ1ZxemIr?=
 =?utf-8?B?TytzTmIrMmplaTgyVUltMlF5NmIweXNCb1JVeGNtV3dWU1ZLOGpxM1VHaVd0?=
 =?utf-8?B?SHh5SW1xVlVBTGE0bDF3ODZJcTVtME1jU2NxUnZNUmg3OXZua2daK0JqSjZq?=
 =?utf-8?B?cmVSU01ibkJGbitCcHlIajRQeFNaRGpkeW5WcndlNlpPNzd4MGN4NmhUZUw4?=
 =?utf-8?B?K0VtQ1ZuaGZ4V2tvSGVBV1ZHQ0dUdUZveUtVbUROQUlPV0x0UTg2S1Z1dFMy?=
 =?utf-8?B?UmhMZU5GUE1HTW81Y1RGTmlrbEQwQUFrV3ZtZGp0emd5bXQwdmtsNmhmMFZS?=
 =?utf-8?B?dW0zVUx2ZmNxa3VXTngzY3N3bkZOSitFSHVNSWRkbndiNlhabGVJaFdsd08v?=
 =?utf-8?B?dW15T1VXNDNuWGNNN0lPV0pIcHhFU25pdG1RcGhKck5Jb3pvWjBoTFdrUTVr?=
 =?utf-8?B?KzBITUFpc1l5QmFFNWp4ZnBoTnIzNUtZZlZDOWtwWWNGL242OWtOQk9ML3lW?=
 =?utf-8?B?anhsSHk1VDd4eU5NUFZ2NkRFQVo1U0U5MVR2WFBoZ2dIY0VjdWp5OHZQQlJL?=
 =?utf-8?B?VHdVMzNWdVNidTB3Y3FXWnRYSURRVUt2Q3ROQ2Y1NWlRUk0ycHpOWnRjYU9o?=
 =?utf-8?B?Qk53Y1BPK2UxZGhKait0eEtybjNMblR0cW1NSTU2dmgwWHhpY0FudEVZTG5T?=
 =?utf-8?B?NkJDUlE5bDFudWY4bDlvUndoOERBQUQ4MWxWVTlXT2NWMlJzMzZRRnZoMkJH?=
 =?utf-8?B?OVJZUVN3bkdHbnVKOCtzTnA4N2RhbXNjRHozSHFxVTArcDc0amJ1TkZQSDhr?=
 =?utf-8?B?aTlKa29mcTFEWGt5b2RDWDhoTG54b1YxZUZhNnJsZlVqUDFMYW5UQVhPRFMw?=
 =?utf-8?B?TWg3emdtMGt3ZUtaL21hK0RCdTNwS29OQVJHeTA4ZSt5YVBFWWxkZEhuZjBk?=
 =?utf-8?B?RlZnYWxRYXVNMnFWUldHWG1FaWRoa3l3eTNNZWpTWktFc1ZxRDNzTVFrNU5U?=
 =?utf-8?B?UXQvWDcwWC93MW5yNFRLN0FBRkxDdU5yeXdHTWVzb1I4bGtSd1VUM1RxK0Zn?=
 =?utf-8?B?Z2V2alBEZ3J3SnRPQWxES0tpeWZ0VDNJZmtzZnN6VE1Nak5ZWWxvZWxEVkxP?=
 =?utf-8?B?cUdRY3FmZkxUa01JeTBIMW1KLzJHUSs5VjU3aTRQTEd0djVzQ1AxTlZGZWVl?=
 =?utf-8?B?NTZ3OHVha2U4aXZ1UEt6SWtKZkdva2x5OUNTRi9KcUZFK1QyQmtIeFZJNXI3?=
 =?utf-8?B?R3hKaWRTcFhQZGxtSDFWY3ZCM0thZnRLc2szK1FPeWEyb2lKeUtlYldZamFN?=
 =?utf-8?B?VFdCSVRqdHZTNmhhY2lIYkRHUGQxNFFNL3Z2aXZtRi91Mmdzck9zS0l2NzU1?=
 =?utf-8?B?YnJTRDdHbGxEWGhWMFJ6Tld3eG52NUpuaHFScnpmb2UzSFlIbjYyZjBrQ2s2?=
 =?utf-8?B?bnV6Tlp2UE1RZEFLb0tyNy9RRDZ6RmNrNUVsWWdSTmluUS8yUmFRVnAxcTlj?=
 =?utf-8?B?aUZjbTNEcVN0ODNTYTJTd25DdGhTTkkyYURJRmgwbW13cUR5dEZxK1VCbnYw?=
 =?utf-8?Q?Z3Qr1Crf9t+8U6lE=3D?=
X-Exchange-RoutingPolicyChecked: i1inRzYHD88QhGM2SGsDbXwWVSBfoghMZUF+ILxGqwH8PQEZtwfjLXoCZXBDxpnqdty9qyftUPSNWUYNVRcJ4RUprL0QDMkdhbE3YF2yO1XLex2Xips7Z88iYrXhhbufzxeE29CDJhZyGlnheUu+0ppHPENfITgD2zB6HaJcDfxQzzo+DQrSsud3YhzDUuvwelbOBTv1+BLQCysdwP05GuGPOjpkGiN2lVmEbnW19Zo+a+XwLajk1wCq+Shlhp84Aqfx7q+wAKNQVntN6Dyl1dC9NEIgsYR7gItH4uukzLmOYYLZ52AdNf5hiLLIFSNatJlzdtEiKyaevqtvwq1MKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: b49a3cdc-649f-4903-20cb-08de9acd8e8e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6967.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 09:01:18.6716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UosYuV6qeN9LzcfkP2zG6htro+anUGSsTqSQ5+DDWcs9ER/8hXtbX7H5LNZFzk9A1ssQPR0MFx6nfp/Up3nzYXNp2i8UTFzaUyZrWb7WAwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF83579A393
X-OriginatorOrg: intel.com

On 2026-04-15 12:15 AM, Ben Hutchings wrote:
> On Mon, 2026-04-13 at 17:55 +0200, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.

...

>> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
>> index 4294206dff362..562fbc0fb3475 100644
>> --- a/sound/soc/soc-core.c
>> +++ b/sound/soc/soc-core.c
>> @@ -962,9 +962,6 @@ void snd_soc_remove_pcm_runtime(struct snd_soc_card *card,
>>   
>>   	lockdep_assert_held(&client_mutex);
>>   
>> -	/* release machine specific resources */
>> -	snd_soc_link_exit(rtd);
>> -
>>   	/*
>>   	 * Notify the machine driver for extra destruction
>>   	 */
> 
> snd_soc_remove_pcm_runtime() is called from remove_link() in
> soc-topology.c.  I might be misunderstanding it, but it seems to free
> the structure that snd_soc_link_exit() accesses immediately after
> snd_soc_remove_pcm_runtime() returns.

Hello Ben,

Good questions all around.  Now, the topology is typically loaded during 
ASoC's component->probe() and removed during component->remove(). 
FrontEnd (FE) DAIs spawned during the topology-load process shall be 
removed during topology-remove process, so component->remove().  That 
remove() is the last third step - after rtd->exit()s and dai->remove()s 
and just before the general snd_soc_remove_pcm_runtime().

rtds->exit()
dais->remove()
components->remove()
|_snd_soc_tplg_component_remove()
|__snd_soc_remove_pcm_runtime() // rtds spawned with tplg
snd_soc_remove_pcm_runtime() // rtds spawned without tplg


> 
>> @@ -1928,6 +1925,9 @@ static void soc_cleanup_card_resources(struct snd_soc_card *card)
>>   
>>   	snd_soc_dapm_shutdown(card);
>>   
>> +	/* release machine specific resources */
>> +	for_each_card_rtds(card, rtd)
>> +		snd_soc_link_exit(rtd);
>>   	/* remove and free each DAI */
>>   	soc_remove_link_dais(card);
>>   	soc_remove_link_components(card);
> 
> So it wouldn't be safe to defer snd_soc_link_exit() to here.
> 
> After ff9226224437 ("ASoC: topology: Change allocations to resource
> managed") upstream that memory is device-managed, making the lifetime of
> the link structure long enough for this to be OK.  So none of the newer
> branches would have this problem.

In essence, the patch fixes the teardown sequence of a card so that it 
matches its startup equivalent.  For simplicity, component marked as 
(A), DAI with (B) and rtd with (C).

Existing v5.10 startup flow:
(A) -> (B) -> (C)

the teardown:
(B) -> (A) -> (C)

assuming we have an ASoC sound cards with components/DAIs/rtds utilizing 
their custom probing procedures, it's clear that one may hit unexpected 
issues when tearing down the card.  Code implementing rtd->exit() shall 
be able to touch the component its paired with.

Let me know if I'm missing something.  Perhaps v5.10 has more modprobe 
<> rmmod related problems and that's why you're hitting an obstacle.


Kind regards,
Czarek
