Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793053873;
	b=5LR4HTAwhiRewd5krmJHIHtRJ69J41C4XjmmPcMyrdfTyUjy8QvVb3hj7cHWNCLXto81
	 19VgdbSvOtZy3sQmyreXjdKcasM9yz8FFimhJd/xNGwXPRDkIiabRLCgN+y6VSD45Z8Zu
	 H2+6Ac/M+R712kPFl+K+9RRhAmYX5/CfKC4LK/+lK2hv8hnoTzdACj0TtRhLvpfuKl+Ko
	 zvWO+RCPeSMfNU8bY7yHWKbVUajUHk1M7u0TCBj2lbgbuOHDaQByMNMXW2yHb7uKJgV0e
	 yZCXKH3ag+YWPb8Gnt1sjwgq92KNruACthPM2Dw/BBYLu31Q1YzmmC6xVhEB5T7Q2Vg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053873;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=uIevU4djrN6OSwujT41pa/ovMrSxYiD02uZE3uS2t/c=;
	b=PPlyYVojXZyVaY7fsCpzcXSGYcTOzL1vZdFcTUjNtVOW/9Ku2+84AEJ5KgEPrId1UcHS
	 E57+cLhNC+8fVm0vV6lL1TFPotPNu5mI0CxzX4FRmu51LjyHucHBmCBHK3Y4DADnfKAoR
	 Kvvs6ivRhlY9B22+P+5hyMn3xce+3mW9ViudhMpVPrmBxon8vf6YW2v25jhutW8Me1YK3
	 Pyqn5falKKfTApEeNQjgaY28UZdR2/JdFyhS8tH/WxuFVpgYNyqHm8K200YkvXdqKg3Qo
	 4sGLMZGVG9E9EwDbn2bUapTgwonJ8t/GJ9C+4ghkklss0kAOB6MHb7Wjvp5ReVAOzFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hg2kL7Kg;
	arc=fail smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400B8606A31A
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 22:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 400B8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hg2kL7Kg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793053873; x=1824589873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K8QktjqpPHYJEn/X/OCaVBlw3edLuJF1Y8l3Ha/krBo=;
  b=hg2kL7KgSUyBxNaiaKTupKxAPOJTLu2gUq3lQeTu9QZF2Ra4ddapJx37
   RR9wvGXYeInqPr00qF/ooHczGuwAO4XMmKI870O1qd98ID+eqI2WAo9Bl
   d3rblqb6Mf18312owUcF9ZEKZI1kA0bqOnRWNOVVHxjDy1HbVZb7rQ405
   1xnkVhTvyTtWGnzsVeQN92w/iWEOn6XWMOGTMkptaGbkCGd7DeEOSC6D5
   WncjLbGTdPsSiPzuj2ZfSLn/wZW9nqUOjc+67WRjOBNB4CQLvbWz+lLq3
   I57z/TRQhNg/XF++E+bJrqH/1ChpdWV9UmURl2JtT87ZEIvq90aTbjXK7
   Q==;
X-CSE-ConnectionGUID: YlN44ejfTR2gN9MIbW9dRA==
X-CSE-MsgGUID: 90uuYwZfSRyOLCYyO4Getw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1770458"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1770458"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 15:31:12 -0700
X-CSE-ConnectionGUID: YFKSzIF0QL+7xxun7NcJjA==
X-CSE-MsgGUID: XteeGOf3RVeKfvu9iGBLRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4365917"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 15:31:11 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 15:31:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 26 Oct 2026 15:31:10 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 15:31:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UO0+6YWsQRSb2czAXBAZOP8k8hWyKN4VNZlBqqWKVxu0xeGbkzGnBjwTqa143FlMyWH7sH59xKA7DA5cF9beXAlelZEB7QxF1Vw80bFmvdz8/Q/Z5pePmLaFd50shFgW9hl8MyE5buQESbSk+2Usb7e0mZ0q4bECZpnvVLvDLpSPvvHhaRpHwYcZHxPPFXD3PDkWXbfK56iZew4lZ9SqvpK1NuSEayamw14FN3T+0i7vT2Zy/LlkD2d3deV7G+BI8P2HQSFadqBXVlBz/tyGoD5KD+GzETqIU7+xF63O8ZJ5f1NCYbEkv8HzU1Vw7M+eI9yAirV0EDS6lWiZRDZ+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIevU4djrN6OSwujT41pa/ovMrSxYiD02uZE3uS2t/c=;
 b=b2n9wIkKE4W9BX2EfKQVRz1rN5JoQnndMo7Rv2TwveBr6XBh50aGT8LJ/4YRQwOgPrlbGDj6PviZIlse4WkL9EYKQ8lr+CZtG9BYZxlzzgqtFwUSv2szV9voD02V3PguTC2VN5hWHfEzLzFSGWCoXYvpxIzQUyxG8+I2GsH7QaXdjnnOmLzRc6NnARK/gq9WT+6ykJ6vjhUxaIEVsIaOo3dg7UpWlXSSQp6uo5eu8jS3pS3Oo27NN+nFo2JDv3Vkt7pleVmIOeHVPw1DZdL1B8T8nGS/1Fb8XNWc3yjr65FaH7ro11h11UUrUbUEMWHknWehy4bHLI7qQEC0pQ1YZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH7PR11MB5943.namprd11.prod.outlook.com (2603:10b6:510:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 22:31:00 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Mon, 26 Oct 2026
 22:30:59 +0000
Message-ID: <106caf0a-8644-4801-9591-80be38b39418@intel.com>
Date: Mon, 26 Oct 2026 15:30:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] arm,x86,fs/resctrl: Support asymmetric L2 cache
 allocation
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20261026215718.16810-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20261026215718.16810-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0240.namprd04.prod.outlook.com
 (2603:10b6:303:87::35) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH7PR11MB5943:EE_
X-MS-Office365-Filtering-Correlation-Id: 773afc86-6617-4b0e-12c7-08df33b0cf27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|261009223027099003|261021121427099003|261022075727099003|261022105027099003|10067099003|56012099006|261026140227099003|3023799007|6133799003|18002099003|22082099003|261026121527099003|11063799006;
X-Microsoft-Antispam-Message-Info: yMSgHWyyCjiWAyIyQN2PqUIxrU9ydvaLNVx54h5C4gTzkl20rNoANF6C4TqvbGjFoIuZ/Y63m+589XBQ9nwxsbEExpB0lDTROhzMvOnnl79rxVKlYYEomyqxDzV++rkg+qb8oVL4uUhdxM4qIl9F6DnqZzHm+1E9hczrCUUhITZDau+P8mMpttljk9P7ULZ897BrsgEhk9wCzrnFfaotUkXT/hXSr+dSt3osyP8gsLKEi+mzcJH8HqpuhwroMdY1tS8acE3li4mW5SO0nZHnIY7ZtD3v5bjwLjTgR4axLoYclW7br/aHSG1Wop1wDuMuujj7greiYb2MJKVamlAnNhw091yNEoXOANetTy/ydpwdyU8MxmHdyx+lH2N0IZFlvNQ3zr+JP0LYQXxEsGHlwy3iXY6GgELeIb9x/UJtm4sY1+PXBflLof3Sg/kzDAQWdppC+EPj3iGWtGYrhznGO3CFeasfWouUeV2xBADrYkSXtyZrFWAFF3mL0jP88umMjQAUJfIC88UNJIWXhvfJY9IcBSVsrRrewKrgtEnNmOKL90B0NSzw8AXLqhhMDmmK+P9pazGjof3U5kAlw+xHWDzdlAoE6Hq+xjIhI/O4z0EglxYAkTykqZItG4YuWygL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(261009223027099003)(261021121427099003)(261022075727099003)(261022105027099003)(10067099003)(56012099006)(261026140227099003)(3023799007)(6133799003)(18002099003)(22082099003)(261026121527099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cU9nMUtuaGdTVFB2YllXWWFRVENZbkNleDNrOVBUR2tad0hxYzVadUZwWjV2?=
 =?utf-8?B?OFJvUCtYYzBtdmRKVDAyOHZaaXZURG1CTUV0UUVzeURLaGNlOEVjc3RCUnQv?=
 =?utf-8?B?SVpDNzQyZUpVWi92NUpYbUZnQXh1SVFRTmhMbnhxZXNITEFCZnhNQ3dCMmg0?=
 =?utf-8?B?a0t2YlJ2S1g4VjNCbzRjUHJhNGlkQ3NyeGtuaHdQU0owSHp1RnRrbU1PYnV6?=
 =?utf-8?B?Vzh4SkovMWgyd3NWMzFDeEhmQW4wemMwMWNoWjRBcVREMzlxM3B0RjNZQUdK?=
 =?utf-8?B?eUVjNlhrdjlLZ3FtK3M4czgyRWxiaUFlTHNVRWdEdVhVajY3QitwN1lORU1W?=
 =?utf-8?B?K3BIK2FYU3FxNEd4N3hORTJTSGNiVnN0c2Zpdlc4ckdjOVcvYjFOVkszM24x?=
 =?utf-8?B?MVdWcnN2NzczWktySmtoV1M5OW5WYjlSNGNJbGphYXpGei9IK0xQY1lENlhJ?=
 =?utf-8?B?UXRiWmF1ZVlyR2JzR0ErbUIwaEJOT0hzeDVYbjFIQnVhMURLYXUxUzMvNjd0?=
 =?utf-8?B?STY3VlRyamVrUkN3STI1ZEtTRXBXZllrU3RkcVluTDNkRkNOQ0c3eWRwRXg4?=
 =?utf-8?B?SksrWmVuMXJuZmdEZUFRcDJpd0E3Q2hzVUJrSFR2d2d0QXAzVzNScUQweHlQ?=
 =?utf-8?B?UlJ5NVgyZzMzUWxEVVBNVXgydU1CVDJQTmY0M09hZkZ2S0hHN24wTUR5YzdY?=
 =?utf-8?B?djdQMFp5S05GSlk3YVRQbEpkVysveVBqYmJUaDd6WGc3VFZYRW1tUTRiQkRG?=
 =?utf-8?B?QXJIL24zVStEZ3h6OE9RWEUwOTlwMUF6QkVxeWpabXBDaGo0eEZPNzB3ZWlp?=
 =?utf-8?B?T2gxYVA5YkkzTGVUM2RhcUgwdUlkSnVPM2hEWG9BMVlOWDlKM2JoTHFWZ1ZI?=
 =?utf-8?B?TjFsc2RDZVl0NzQwOFkxcXMxVTdybFdQS2ZTSnVaZjlHZHoyOWNQR1pDWktR?=
 =?utf-8?B?amhOMFpOb3h4eXZWcGJqUWZPY0VlTkhKdzA2VEE3Z090R29sYlVTazAzN3Fw?=
 =?utf-8?B?YlpibkZ0aVQyZUdtdW5KYTViVzZ1Ky9JMG5sVkhCYkxPbXFGZnMwT2J5dlVj?=
 =?utf-8?B?ald2WFRQNkVoSVVPQytUNkR3d1pRNkhMcUoxVEdSVmZUaEdvRncyZkg5TUgr?=
 =?utf-8?B?RVlQS05rYVc0SGh1SFV4OVgxbTZRdGErQjI3cGlabm5wZXB6T3p1aG1NcG9o?=
 =?utf-8?B?UzNGNWd2R2poT0hYUEJxKy9Md3NlaXQ0aVVIQVJjSkJObFhlZkhMNENXWk54?=
 =?utf-8?B?c3ZpVlFFU2dPUkVpY0ZvS2lhbTEvZ0lreHM0M1VNaXQ0bnBFTXJ2eGozb29Q?=
 =?utf-8?B?SnZvY09XMWxibkF6ZU5UZjBqaklJcnhtMDNVU0trcHZjbzlZQ1RTc0VxQjli?=
 =?utf-8?B?YSs2RTdrd0lJTFJVcmR0R0pWaW5ncUJJSnB1ak12NFByZjI4OWhSdElxbnFU?=
 =?utf-8?B?OXNQR3FUNjhNWUJiNVJrYmVub2V0SjJpVzVQYk1yTnhhSFJFUGxTQ3ZZZ0hy?=
 =?utf-8?B?dGs4dVJjRHlYY0FjN05sV2N3alBJWE1mM3lFWjNma2VXSW15SEU2SHB5OHJE?=
 =?utf-8?B?cHpuZDh2YlduUW9JSXFVY2FsdG1heE9QQ1pLMk5URlZOOGlsZVFibTllYzV1?=
 =?utf-8?B?NlpFcEdLWXJNNGJHVnhsdVZVenR1M1JXVzZMajZIbnlLVkQ0YU1nanUyTk4w?=
 =?utf-8?B?bU54N2dGb2c4M3FFZXpvRWF2SHpwalBuNUZiMGU3QzRyM2YwSVA4a0tZYUR3?=
 =?utf-8?B?d2h6MmlkUmo4SnBpdFU5dWVlYXVwNnNmOExWMHJYakdJZkw3UWdkb1dFdGdB?=
 =?utf-8?B?YjN6b2RCUzloRU85VERSOGE2akxJcC9JRWM0SDdnSVZ4Tzlkb3BVQ0Y4NVlO?=
 =?utf-8?B?bW1rRVJLRVJvZ25kYjg2WE1UMGxjdlJ0YVZkbUlLVitOVzhxTnk4WjlPdVFh?=
 =?utf-8?B?RDBOM3FoclBUSTl4TjlHNzNvRHRVRnVmVDNyUnVGZHUwODJjRjh4bjRDOU5z?=
 =?utf-8?B?aTRqSmNKd3JaZXF6bGp0OUFQWnBPc240TEdCMU9yUS84c2pjTDhpendGMWxy?=
 =?utf-8?B?aHNBUlZUVWd3UWZVaktKaS9QL1Q2MmhITzBwUy9uUW1pb2ZwaVVCaXpYL3J0?=
 =?utf-8?B?SlQwV2k1WlIySHQvSVpueUhFVVpZM1VzYWpvcTJCNkU4VCtoRHpRV3lJL1Fa?=
 =?utf-8?B?R0x4R2diaWxjdkRUcFhRczJuT1prRlQvNnYvR3Q3WTBubFNNYm5pOUZJN2NF?=
 =?utf-8?B?cEZsWjJnaDNxeC9heE1MTDZORi9CTjkxNGFTWlo0M3JWNWpJRHJzRTRSYi9S?=
 =?utf-8?B?d2dTL1Y0UHVEZ1hHT1dSSjlSNTFoL3d3am0zVmJlbkkraGNqUE1LNU1tN3E1?=
 =?utf-8?Q?4LQwTO+Q611B2kQo=3D?=
X-Exchange-RoutingPolicyChecked: hSdqHQKiUVJ7JCmeCOJkZ8hRyCeNBdrHlbpEyYoqQHqYjtXGM411/+v3wUFaszTZfqA0ZAHQa1bZHaBe85vA8Hph/YyEALesKAHWwPrrpLLAo5+fRPoJbL5QjGzmM2y2HbdbWgUzPEFWc9f4PACR7dVRS1miaGBce+l55oPzD152p6Gy9OaVOG/fKh887ETDg6qy2uTk5gsDAPCEWhnqnEqBLzWezmdcJpvm7Qh/a3QezFF7dCVW5vXocG0uNl0t0wYN/bPGQbgXlG0c3NnNkvwObSWdT00lQT7xHEGJ75O9ChGuUtt04tL+Ru+CtcpUj8dtJ2cgHHG9rMdzSity4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 773afc86-6617-4b0e-12c7-08df33b0cf27
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 22:30:59.4707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVA2bk1Jcjxw5QZrifKx6oPwTii1Huc9lCMRpVRqDQEvBS/3o3sq26Fnsl5tgCnQHWM3OrkCbgBHMYlWBKrbkyzQ23P8JcJ+vq9o+yWUgLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5943
X-OriginatorOrg: intel.com

Hi Tony,

On 10/26/26 2:57 PM, Tony Luck wrote:
> RFC patch series built on top of Reinette's multiple control series[1]
> 
> The goal is to support L2 cache allocation on hybrid Intel CPUs such as
> Panther Lake[2] where the P-core and E-core CPUs have different number
> of supported bits for L2 cache bit mask controls. N.B. it is assumned
> that the only point of asymmetry is the cache bit mask length. Other
> parameters must be the same (but code doesn't check).
> 
> Overall approach is to add the per-L2 cache bitmask length to the domain
> and use that everywhere instead of using a single value from the control.
> 
> Patch 1 changes the format of the per-control "max" file and should be
> merged back into Reinette's multi-control series so this file can have
> a consistent format from first upstream introduction.
> 
> Patches 2-5 are enumeration and preperation.
> 
> Patch 6 introduces, initializes, and uses the per-domain cache bit mask
> length field (arm/MPAM change needs careful scrutiny).
> 
> Patch 7 enables asymmetric L2 for x86 CPUs that enumerate it. N.B. it
> renammes the resource from "L2" to "L2A" to avoid user interface issues
> with tools that expect L2 cache allocation to be symmetric.

I did a quick scan and it seems to ignore the the distinction between a resource
and control as highlighted the previous time you brought up this work. Specifically,
please see:

	https://lore.kernel.org/lkml/eaeb4259-46d6-4656-8354-669ad32654b5@intel.com/

Also, why does patch #1 drop the 0x prefix from new control interface when displaying hex
values to user space? This is a significant change for which patch #1 does not provide
a motivation.

Reinette

