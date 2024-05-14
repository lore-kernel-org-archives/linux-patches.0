Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A140144D0D
	for <patches@lists.linux.dev>; Tue, 14 May 2024 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715699314; cv=fail; b=UL9tyfOg66GXXACtP5KD9k6WBkbPC66dYRi9ja+Z8f0DHfWO5OprSVGrIs6W9crp/lC9/z42FCQEw7oKddALMmqqsV4ez5UDoavKo2Cbj8WDfYSxcvkkEuNDYi8M1T2Oy753Ogp2Kc9LF8cnrPG0nbHedIWPrYRXpPfdjzS9hKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715699314; c=relaxed/simple;
	bh=/lES2RE+H2+4uOzN+qBKbpv9Q5rCCsc5Apt8Kra6MN8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YHjbQ7KI8HgYRRCspeS23pj3r8PhpyT7oEiUWSSqUgMgjtUA9Ml3TyBjtemx2eWpMBjwbZm1xAwckOeho6Fh3hFW+VC3GvnjYfsBTYFhgn4K4wI+JcOVjJlMJlEAq4sKBnDzYJSxH+BFuxkq4KDf7ONH6oE9+FTQQz2Uzw1z01M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kS7JoB9M; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kS7JoB9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715699313; x=1747235313;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/lES2RE+H2+4uOzN+qBKbpv9Q5rCCsc5Apt8Kra6MN8=;
  b=kS7JoB9MDhNSdd0BgYx1zXcSydF5sdYuHKTifZFpjvVm0Du8bgjtdMbQ
   Ewp+nSYVeaktUhL1co5SB+c/vr9ofc1RJbwvLKuqhmu4EeH2mO3SHZuqJ
   d+FHnVs6TbWCG5Al1wtvnjvFS2WiSz0bHKvXgAx36UkojSDF6/MeB446U
   gIZTD4Ugnkdl9JTzFY0YT6z3JsU2U7x/i/EO+2eYDXQfDZO0S7e/Y1Yqo
   U84FRHdxxz/xSH+ukaqN4pVO1jd6xQ0SpLJOVB9V4ZxBHnTvEV/Gr0L3o
   HmTSDF17KEWu+Qw96FXXIzyM3h/GDSRoOJ71G+URzuGY0dv9wI91UBaxe
   g==;
X-CSE-ConnectionGUID: YmX6lPVqSIKq3xts8eGR7Q==
X-CSE-MsgGUID: 8XJcjNUNRHujQFwFVc92rw==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11809337"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11809337"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 08:08:32 -0700
X-CSE-ConnectionGUID: KbbzLuiwSuSTQ/dlw+wx1A==
X-CSE-MsgGUID: vvn+ZXGRRsalBgIl/hMFQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="61882759"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 May 2024 08:08:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 08:08:31 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 08:08:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 14 May 2024 08:08:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 14 May 2024 08:08:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qcl2FiiJau4v3Y7hn0xBhDrdi7vt9gU7BTvBGDZM/0N9r+/VjIhpEBdIwstXwRFZQgIayeUn2Y16aJPJf1tCFh5TnNcX9pY/+zNtwNqIFaaEo0q+yPyHoDjR76o2U/K0PYIWIUG/2832BWo5M1u3TDT5HQwcWsYIuyfBEXYl/FxQqboQYT9zxLTb00mQswey+Hv03PGBMtef90hAx7UJT5u1v4FBAd0Lsdx7xh72PYBuWFgM+pt24TqjRUJ+EVZXXSw5DlJ4f7lAjw1tXbn18lGG44V7g4qTQb2HG8twnlKDRc8DwlHmfYR59QFEW93FIt0ZHWZvdvRMI/uqhrFFdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7XLbSQyZn5kodxfyfv3loS/TQ0KxJAwpt4z98HL8X0=;
 b=NiU//sZYm/WbpuFe67lIdPRGLHVL2M25wv+Z/fAdV17ic4DugqOxMZtc8Od1HHIsQHDH1YvjkUpPapcnH+ZuW3ktsHzRlPOz3R1vbP6sRYx+updTWmWuSldQmiU8vs8ZC9jxwIdvHIAuGgfGVVfBjqh2dtLsO0jpzDS59NSPQr0x6K+06O/FdKag0+EjoOmBXpSvYpkbwjQ4MrGYyCHG4G/fOtDQFNGWQTWl6kbUSEKyg+sQtjO+N3K3z1tJOAi5EkpdS76R9+hFvSXCiV0R0hCR/Sgipr8/UjUYuQeqMSrFkl1k6MLpLPVuX7v+W/4b9oHfRBZrL733ZIMZaGe79Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6865.namprd11.prod.outlook.com (2603:10b6:930:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 15:08:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 15:08:21 +0000
Message-ID: <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
Date: Tue, 14 May 2024 08:08:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
 <ZkKupOKRu5S7Rkgx@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZkKupOKRu5S7Rkgx@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0125.namprd04.prod.outlook.com
 (2603:10b6:303:84::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: 535f3ebc-34ca-4da6-81e9-08dc7427b174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHNySlBjY3RBNmFsWDJzOVVEaGdpb09aQ2REbVJBS2NPSmN4YUszVjJkWitj?=
 =?utf-8?B?YzV5a0pxQnJselc4NUVxblZ5OXArNno0SnRyRjluOGpWcSs0SnBPOUplellX?=
 =?utf-8?B?TW52djdxaWQ2ajdIVUZsNlhhc0Exb2J1SnJFZDVJMTNIdVpQU3R4NnJDbUU0?=
 =?utf-8?B?TnpMcjBsVU45cUY5TDlUWVZRS25HbHRCeFo4eUdnb1F1L3I0TE9yOEREZDRF?=
 =?utf-8?B?b3RneVJsdGhDeUt3RXBsdFoyemRRayt4d01ML1l5eXVvTXhHYVpsdGRDREpF?=
 =?utf-8?B?czQ2bnFNZS8xY25rRVlPYkJoOXU0NVhLZjlqODd5RWtSaDVSYk5idjUrMUd0?=
 =?utf-8?B?akRsbm1qRElNSVY0Sk5XVzdldEJtM0h2bFBtUHFPK3lTTVlXTU5VRnFSak9U?=
 =?utf-8?B?RnNtMXRzMmZOWVNjSk1Yc2JZKytqY0NLZjJ1VE5TL3poQXlsemZhRUtFcmJw?=
 =?utf-8?B?WUloeklpeFNEek5LRXV5K3VlY3A0MXBqd3UvamtSQ09QRnFTYjVlYTN6MHp2?=
 =?utf-8?B?bUFvMUtBUTUxZy9FY0hiMW1kSTJ3OHp6cWJwdGphV1JMRXYwM0dSTW02YUl4?=
 =?utf-8?B?S0tEaEVqeU92Z25nd0tzWlA5TkZKcVIxY1JXNDZERkFIUVBDQnl4SHYwbGh0?=
 =?utf-8?B?Y1lRNFQvN2JuYWJBenVCZkFOSGd5eWFHYmtwTDBaVURadGFGbS8rb1Yrelk2?=
 =?utf-8?B?NEN1YWluejZ6YWtxWXlydktjeXh1dEdZWmR2MHQxbWl5cnZUbEFpV0FsbDdS?=
 =?utf-8?B?SFRDT1BRWWR6N0FNZWFVVzRURmp5TGpxUFNnM0NWVkQ3L2JMMkNQdVNkUTMy?=
 =?utf-8?B?NVRoUmZ5U00ya29jK1NWWlZ2ampnT29MQm5aaUw4S01zSXNwODJtNkRGNHRQ?=
 =?utf-8?B?b0plME1sakpDemNtNk4yL1lZNVFqRGpLNEd4eTlaZVd1d0YrYnA5RG5TTnY0?=
 =?utf-8?B?N3h5UGFWQXhMU3FPbzBFWGlPOUsxa2c3eUJkUFpXNWYvK1FEdDFqYmVyemQ3?=
 =?utf-8?B?bEt5d3B2WWxaclg5dTNPL3NLUU1kc1FiNWpyZHMrelNFTml3S1M5YmtpczE4?=
 =?utf-8?B?V0lXejBWM1VSV2p2NWoydmNReU1iVHF3VTdkVW9VK3JHeGxTN3hMc2RyL3lB?=
 =?utf-8?B?VUVrRE92cXRWclFzUFhKVEUxREZxRlBjUUdNallHMHZ0aElEWDNzMk5YL24z?=
 =?utf-8?B?SEVaMk9XMmtsaGxHVXROM1pJdFZZNlFWRFFYdEl2VEZRUFNnclpqZWQvd2VI?=
 =?utf-8?B?aXMvSTZTaThxeC9Gc3BseDJjbm1mWHBsNFppN1dVV3dIZGlsMU1zTGZ0ZU92?=
 =?utf-8?B?bmQ5Z1lZVHdpV3RwbEp4RnhiRGxxMHpKQmUreU5YWDRTeGVjc1FMWWR4dDda?=
 =?utf-8?B?YWdmZ0dsazBNaVhWejN5L0RCeStIUlJKbGhhamg2eXNma3JYaWtMOFY3VEkx?=
 =?utf-8?B?enVoWnBGSmp0WDZSTzlWak9LKzNEblFPbFg2ZjIreTZuQktFVGhSQlRIck50?=
 =?utf-8?B?dklCL3paTkI4OFA5SnlaYWdaeENXUkE5MWl2bGIrekI0RHRnNmZ6QnBFRlhO?=
 =?utf-8?B?QW00Smd4a0pzRE5yNVlmdUluME1rVzRsdGVhckh1d2oxK0c2T0tLZzZMT08x?=
 =?utf-8?B?bnFPNzE0OWltWXF3Q25jdjQrM3o4MWlRT0czWkxNZVYxeXIxUk9wM1RtNnZt?=
 =?utf-8?B?SHdnSGtpbDc1OUxJZmpwZkNHYzBNeU5wQUp3MkxxSml0azlVbTlTaUZ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzkvQ29mTW9ZdkZVaUhZN0lwamZmR2U3cG1leHBOakFrczFHQyswZVZuVXF4?=
 =?utf-8?B?RGhnQkUyRHBQWTBsc214VC9XeXNKcWthQ2RDSm5pRzVPZEZ4cnh3NFRaMWNC?=
 =?utf-8?B?Q2hha3BzdDBZMFAyNlp3WDh2dXY0bEZDOTl5Q1ZzWmQxN0ZVZkVrUzFzWWMy?=
 =?utf-8?B?TU5wWjBTSldwY1lCN1loV3BKRHVuc0o2cXBOTjdNQ2pmOWwrMHowSHUyOXpz?=
 =?utf-8?B?eUk0ZVRoT3cxaGs4VHQ4ZzF0RnpYSlFTcDdGdnlXRE9XMXNrcDRrNUhFTzhn?=
 =?utf-8?B?U3ovcGttTVdQQVY1S1k0ZE1tY0I3VnpTazdQLzcwUlFkd0ZpSmxIdE1PMUt5?=
 =?utf-8?B?V2RvK0ROY3dFbzlGeC85M1NEaDV3bXN6WEVZTDRWYmlLYWRxcW5sSXFCd1Zz?=
 =?utf-8?B?N1JUWUhiOElscGZXL0NXaHM5bjVkZTZudWZzdWRXbUFwMEZlUzE1dVN1NTEx?=
 =?utf-8?B?K0lZSzlzS2NDM1BjZmZ2WUwzM0pwWTB1Qk9Qd24vRzN1azMyTVZOdDU1Y1FR?=
 =?utf-8?B?QVA5RjNmUHhibjVKYndmSDcxYmpyNnZkVVovMzRyaEY5NDRKZFFWRmRGK1lN?=
 =?utf-8?B?QlZEY2VRZjdIWCsxcVpYZlcxQUZCK05FN0V3VEpNQndaRlltR1prT3lwMk1z?=
 =?utf-8?B?OE5scUIwL2ZDMXBoaHB5ZXhVeCtFR2xMTEV0ekJGSXdSYlFOa1ZjQVdyWG1i?=
 =?utf-8?B?dkxlV3hNS0I4UzNsQ0o1THZheGlTTXZkakx6S1BHT2JvbFYxY1NSOEIrK25Q?=
 =?utf-8?B?Y001c0RoL1RYRkNBTDZ4L1ZPa0FiNyt1ZC96OTd5SUxpbU9lTkdGMzJ1SDMv?=
 =?utf-8?B?aUg2Tll0SFFhSjlMMzBQeUpCb1c5bFNnZ0V5WEp5VFpSaUI1cEMrWVFoc2w2?=
 =?utf-8?B?Y2pZQzRzK0hqYUYxeTJaMGVXeTl0TGwwcWI0TWlKK3V2R1J4UjBQb1puaE1l?=
 =?utf-8?B?U3JHNmtuZmVZZkZrZmdPcHVMV21YMlFIeDlrZ2NJU1JJa1ZLTXUwQ1dNcUlO?=
 =?utf-8?B?aUxBTlZ4TVhJY2NQWnNzM2FxUWdKN0hPbG40U1dJQTNGalRmd1pzYldOZ0Q5?=
 =?utf-8?B?SUdGL0hEaElPcTlDZGpFaUgyYVFYZWhPS3h3Z0ExcWo4eDN6M0NqeXdCZDA3?=
 =?utf-8?B?ZWJBM0t0MzdtalQ1TFQzVHdqdHZYUmg3YlZRUU1INlhXNFVjcmxGSkRFUjFL?=
 =?utf-8?B?VXMyM1NBbHFSOEJQMTcxQTJEbFVBbGV3SnhzVEJISTJwQzNKTmxiUERSU1Ay?=
 =?utf-8?B?SjFaY0hYWUJ6OUFWbU93NWxqN2pPeVd6UkN4MUNyaWQ1Y1hNRG9lVnZvV0hM?=
 =?utf-8?B?UEZrM2ZwQ1NycHBIMGFIbTZQMlVvMnVzOEp5VDdlZE80Tkt2UlRvS1l0SXZQ?=
 =?utf-8?B?UzA1UTZBay9NRWJ6b3ZWL1ZkOWxubFlLWXFiTHdPSUkvOS91d3pQdmdJMGZn?=
 =?utf-8?B?bFk3KzZrbS9FbEx2MGdFbTA4K1p6YndqVDBCcHY2SUVOeld4Y2NUMm9mRzdk?=
 =?utf-8?B?cmJZZXZKcy9CeWlLWGkxcDNEdnNxY1E1UnZpZFZFaklMMFFGdm4yRjd6L3NU?=
 =?utf-8?B?L2RsUDBBTWxZdWcrQlhTc0J0MlFNWHV1MzZEbDhkbzRyU2w0NGJ3VG1HdWR5?=
 =?utf-8?B?SVV3VkU4YXQ5WnpBRU1tTDRBWVJHNWJpY1VGUEpYdko4aFhkTmdjS2UycFhC?=
 =?utf-8?B?c0x4TW1hYkRZcFRJYVBsOXo5LzNDNVREZVlWamFOSzhLSXlsbHdSNnBZQTdQ?=
 =?utf-8?B?TURUM1VVYXBMZmpUQ2VaUTE1V2JPeDRJWXphTkNrRnZ4RlQ3cmlGRXVMa200?=
 =?utf-8?B?TWNUc0ZmQmhGa1BxM1plV0hVUEVISENoVWg0TUdXZUFiUnNjWTZCMEpaVVZC?=
 =?utf-8?B?aE5wdWdNT1RGaHZWTnZDVlRPdytPWGl2R09laDlod1p6SkJ1MVU4L0RNWVJ0?=
 =?utf-8?B?WWUzUThEN0VaOE1xVFZjVUo1OUtPUlRzMk9Iczc2K0VRamFobGZoNE5US0RU?=
 =?utf-8?B?Z3dZQlBaWk8wd1dHTVUwRmhxbXR6ejRINHVXYVhZY2JpVDVaV3UxNWVrdjNL?=
 =?utf-8?B?UTZKTm92UnBzUmpjWnEwa0dxbTg5MlV6WGZ6R1loSUoyUk1yKzlOUVRLNmI3?=
 =?utf-8?B?RE5Wc0JydXJPb2dlNU1ONjhvZHdVM1piRmtsMmRyNXQ2eVNRZ2szWEJWTmFo?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 535f3ebc-34ca-4da6-81e9-08dc7427b174
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 15:08:21.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0Sqtr0X32KBSJUHVqyb0ZgL6EIKU1LlGg+RInN1MUnWHgqC9QrqCJfNtWa81K7qFKxMh4rMO+DmLXDE32qa7yOLks8bqAJ4M/k0dfUSrK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6865
X-OriginatorOrg: intel.com

Hi Tony,

On 5/13/2024 5:21 PM, Tony Luck wrote:
> On Mon, May 13, 2024 at 11:53:17AM -0700, Reinette Chatre wrote:
>> On 5/13/2024 10:05 AM, Tony Luck wrote:
>>> On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
>>> Thanks for the review. Detailed comments below. But overall I'm
>>> going to split patch 7 into a bunch of smaller changes, each with
>>> a better commit message.
>>>
>>>> On 5/3/2024 1:33 PM, Tony Luck wrote:
>>>>
>>>> (Could you please start the changelog with some context?)
>>>>
>>>>> Add a field to the rdt_resource structure to track whether monitoring
>>>>> resources are tracked by hardware at a different scope (NODE) from
>>>>> the legacy L3 scope.
>>>>
>>>> This seems to describe @mon_scope that was introduced in patch #3?
>>>
>>> Not really. Patch #3 made the change so that control an monitor
>>> functions can have different scope. That's still needed as with SNC
>>> enabled the underlying data collection is at the node level for
>>> monitoring, while control stays at the L3 cache scope.
>>>
>>> This new field describes the legacy scope of monitoring, so that
>>> resctrl can provide correctly scoped monitor files for legacy
>>> applications that aren't aware of SNC. So I'm using this both
>>> to indicate when SNC is enabled (with mon_scope != mon_display_scope)
>>> or disabled (when they are the same).
>>
>> This seems to enforce the idea that these new additions aim to be
>> generic on the surface but the only goal is to support SNC.
> 
> If you have some more ideas on how to make this more generic and
> less SNC specific I'm all ears.

It may not end up being totally generic. It should not pretend to be
when it is not. It makes the flows difficult to follow when there are
these unexpected checks/quirks in what claims to be core code.

>>>>>  	}
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>>> +				struct rdt_mon_domain *d,
>>>>> +				struct rdt_resource *r, struct rdtgroup *prgrp)
>>>>> +{
>>>>> +	struct kernfs_node *kn, *ckn;
>>>>> +	char name[32];
>>>>> +	bool do_sum;
>>>>> +	int ret;
>>>>> +
>>>>> +	do_sum = r->mon_scope != r->mon_display_scope;
>>>>> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
>>>>> +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
>>>>> +	if (!kn) {
>>>>> +		/* create the directory */
>>>>> +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
>>>>> +		if (IS_ERR(kn))
>>>>> +			return PTR_ERR(kn);
>>>>> +
>>>>> +		ret = rdtgroup_kn_set_ugid(kn);
>>>>> +		if (ret)
>>>>> +			goto out_destroy;
>>>>> +		ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
>>>>
>>>> This does not look right. If I understand correctly the private data
>>>> of these event files will have whichever mon domain came up first as
>>>> its domain id. That seems completely arbitrary and does not reflect
>>>> accurate state for this file. Since "do_sum" is essentially a "flag"
>>>> on how this file can be treated, can its "dom_id" not rather be
>>>> the "monitor scope domain id"? Could that not help to eliminate 
>>>> that per-domain "display_id"?
>>>
>>> You are correct that this should be the "monitor scope domain id" rather
>>> than the first SNC domain that appears. I'll change to use that. I don't
>>> think it helps in removing the per-domain display_id.
>>
>> Wouldn't the file metadata then be the "display_id"?
> 
> Yes. The metadata is the display_id for files that need to sum across
> SNC nodes, but the domain id for ones where no summation is needed.

Right ... and there is a "sum" flag to tell which is which?

Reinette
