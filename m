Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A2317F39B
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358526; cv=fail; b=TTUMZSIF7Og0hR15vRfdYhlUUe4qc8DZTP2MTtAWtDhQEwVOEA/yW4E7BZBsP5Xjn9TIIXybYntSJfNuhz226QJ5gZXZmDqVFzDgNgW+tAI/F9nLTdWNbVzSZa6GZ5RrOT7ispID49TQKsGH6PxCEUFP7ZRnf+Vc+1+uuIfjyNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358526; c=relaxed/simple;
	bh=J5YPnOchYX2RrJkSogJMiDzoTUcqiKxEbgIZ6V+lF7g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fMGsBQJYvgHSBPQzEnGAZPabhF4t0Pu+MHHeWFv4K/F/CHfqru8kyj80erIBrmjJeTVsNIsgRmXdEl8es7yPoDcSdF9y5ucgernx9Ka+3nJEF1KjefnUyP29JquNIujy7aXWJhslWha0jvCVhMVHqKDxJWgk5ej8wx6hmPd5YqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nfT/4/hX; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nfT/4/hX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358524; x=1750894524;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J5YPnOchYX2RrJkSogJMiDzoTUcqiKxEbgIZ6V+lF7g=;
  b=nfT/4/hXAEuRraF1Wz+eBLjgayJGWH08OcR63C1uSHi1K9a0+RbBTVrx
   0ZLD0/RauEjK2uUBuN1wAiEhNhmZWNuywBoPckNHLE35gG3sXreytBXaK
   kszk5FA6pjb/7V9MmriIl3Idp+NywSKBtSw0zpVu2BBvRsqZ9/AOJOUyn
   u4erzWD6u87oNEqeUho4rbZRdF7kTODveYsBaHn5yIwqjwgw2wxUM99eS
   yGOuPS+R/SzX2GbS1xK2YL7XK9QIgQT4sMRLJZ3SNadnKDHSecoIzYT1/
   HV9YhurPPWrmW5txQiX4m7l8jUp8W5ntut8tDyOhlygKsAjyRntEHaLj5
   w==;
X-CSE-ConnectionGUID: Ny+flEInSYqUPKW6XNXtNg==
X-CSE-MsgGUID: KIvklHDhRz2fRf+O0l5xvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16552097"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16552097"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:35:24 -0700
X-CSE-ConnectionGUID: kFJOwygXQry1PCBB4QfDKw==
X-CSE-MsgGUID: r77h5MfLQA+qLEjVLsu67Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="43919500"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:35:24 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:35:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:35:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:35:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SL14MOjshdkkNpXp+1fI2KWaogsOImJ2yoRAboAZzR0+AegY5pe53gg7S97Mw5Ep+J9IY/QDW7enBBJKS/BJx4HCh0BuCl+cRCBtX7Sc1ZbpT6ogCkkacXIYX3CxU2YR5tJPVdXQjCAzAEX+ylD8BatiK5oK/+EvzpA8nEwCV2i1pkeLPowPoVHXQrA7TAJwIGkw+FYA9kxhpE2ZJn5ko2nKiwGSCbiMqIic2+pVbEb3CLEqw538A2//oUXzUC6GJQNLCXLSde0NPtFyjDsqcj71rEntHt0dPehwfgW6g/Op3/9bO0YpD9BFwOBVUe5Bk0wtojFYg1qbG8urEDkdGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOBmJN9uNAIgyPxp6OeqVpZgDBPPEYIaYx/GxwktmKI=;
 b=R4Kyxcs1hkOZuvjutormanxUjY716+qQyw8CD79KPtqhIgt69OCJ3y/SDy6CduYnRuV7rM4omWHloNjK0Y7cVg40ppvRcSpS3L/Dehthf/DJCPBQ7fFri9rveY81DTzEJPD6Obr9fkdaSNA3sZPdudY4/y6YBCTMxci0Y252F3DD77jPfPKFvzJREZX0te9fOS0Cs+ycb6jTGjpmU0liLMLwQyN1Je2rBcOKlEzVxDG2PiKFArwq5EFgVaR9XgId2aZX+ZZTsbJiEcMs/kEGbZeO/Qc1AEGSONtQqvTsB9+ldyU1fOwtpJUDmaJzd1HFjkjqA4a/Qt0v25fh6kS43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4929.namprd11.prod.outlook.com (2603:10b6:303:6d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Tue, 25 Jun
 2024 23:35:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:35:19 +0000
Message-ID: <23d982d2-97c5-4f2f-a034-858bec34bef7@intel.com>
Date: Tue, 25 Jun 2024 16:35:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 16/18] x86/resctrl: Enable shared RMID mode on
 Sub-NUMA Cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240621223859.43471-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:303:b4::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 489dde7c-30af-4372-9ab1-08dc956f7971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ckszWjhXSEEvVjdkM3RTWTF1dkhLandzWlJQcEJ2YVlZT2swSzV0N1MxSGor?=
 =?utf-8?B?ZVhpcnVJQ0N0NW5ZOTFETTh2Zi9MaGYxUkthQ1IrWFFDUUNjaWVmK0VMeEU1?=
 =?utf-8?B?cCt4YnRiYkVvR1ZqS1ZBRExTOGp0bnZ5THVHaE5mMkIwcE5OVDlUM3BqWFVU?=
 =?utf-8?B?cmhJdnYxVFVJbk9RbEkxeGVXQUxPTVFvaEI5UGIzRHNKVVZGZ09nNzRMMkRY?=
 =?utf-8?B?a2FWN2cvTXhEdnlBUUtxN1g3NTROR2RMUDY4Rlk0VUtHTzRIUFoyd01WbENX?=
 =?utf-8?B?LzY5QVVkK0t0V2IxaDlYaWFHV1hPd0M1MG04em5SOTFONkp6Vm5qWHRWakhP?=
 =?utf-8?B?c1BqNmJRN2FWempxcTdIeng2NUhVWE8waHdIdE5MMVhCRGE1QmMrNklDY29D?=
 =?utf-8?B?d1RGQWpDZ28rNi9LUXVDbUFqbXBPSG9HQkREaFFvc3dtZzNlUkwwNC9sRW9u?=
 =?utf-8?B?Z3Z5WU1mZ3lrUTBudkdWRUZLRzVTTENFQ0NZRW14K01ReGYvcTlkWmoyQ09m?=
 =?utf-8?B?d0k2NVpRb281ZXg4Umo4a3Zrb3A2a1hjbTdJdUpZZUdka3lKZ2M5TU5XV2VU?=
 =?utf-8?B?VjBCanp4QW1UbWU5ek56eXdncENSZVg4SE0xS1hVY29XdVdZaU9wQjBXOXcv?=
 =?utf-8?B?WkU5QWNHSmlGdTUvYnBicmNYOEpnZnVIMzN3V2g2ZE56RjRKZW1NZTRhSHY3?=
 =?utf-8?B?RWphbDhpUkVSOUNkdThTbmorUDFWVTVTVTdBdE12WXpsQkNtK3l1MUhVQVVx?=
 =?utf-8?B?VGo3Uys5aFcyTEdiNkVsNTFOVnNjMVNQRHEzOTNJQ3kzTWZKRTNiT0czcXNG?=
 =?utf-8?B?enZjdjR2VEpZaXUzbTNVQmdOSEJOZFBJSTBZOEd6Z0JoNHk3MkxMbHJpYTUr?=
 =?utf-8?B?RnRtaDBOTWpSNlZUUFg2OVlYa2lBZ3NrdzNNaHBsTDIySExJUVpiREJtRDh3?=
 =?utf-8?B?cEdFdnd1eHpSdkdxRndTakpCRHcyMnZiWmdFTTQ3TlFHYmVBM1c4M1I4MkVY?=
 =?utf-8?B?MVZJL0xnOGdrd0pocXdQK2tEK0pBamZvMVBZSW9IL0lKbDY4akJPOUNIeXQ3?=
 =?utf-8?B?RmZpVzdmeDFIekhSd25vTDVEMUxybUZncy85UHdmcFdTQi95a2d5Uzd1M0tx?=
 =?utf-8?B?a0l2dXhHeGZrMTFnK3o4NHY5VHBkNGhSL2tTaGFwT05PdGhPbU5MVHB1a2Iy?=
 =?utf-8?B?ejNJbnNsZ3A4R3RKcjQ5MUdndEFmb1BPNFJkcnhrZWtyNmVqb1MraHlpWGZK?=
 =?utf-8?B?VUwwRUdrUTcxcUhpbkN6WUtrbjBRYnJhSWkxeUloVjQvcENNZVhlRms0eDNa?=
 =?utf-8?B?TzZSTmdUb1pyTnJvNzRUdWQ0TVZ3T01kSjIveE4zcm15dGc3anNOS2hzZ3o2?=
 =?utf-8?B?MXgrMVg4TEJZaWtvR1JyTTlHVC9xZCs0ak1vNXY1R0hsMVF6eUhCUGd1N3RZ?=
 =?utf-8?B?UHJMTFdENU1WQnhtSllzMjZHS3hjV1B2WXFabEVOYWNXSzQ4UjdoZ3IrWE11?=
 =?utf-8?B?ZEw4cndoSDV4YVlEM3JSNzFOUHZtQXRHUExaTk5WWUdwbWk0RUlBZ1J5K2M4?=
 =?utf-8?B?YkxYYzlxSGk2eGszeDk0OG9BSHFvUkRMWUE2RlNzS3d2UWMvZnVSRUpSRjVj?=
 =?utf-8?B?YSt0WkRhYnNSekx5WmtlcGJheCt4aCtTckNNWE5RSkh5ZFpXV0JDaTh1ZWR0?=
 =?utf-8?B?WCtLdTFmYUNMSmFzQjFNOVJiV3dzYi9sVHhicjlHak9Tdzdxc3pSeUJMVTJD?=
 =?utf-8?B?OFRwV1FiYW9wYXhOK2RKVEN1aVY5emdYRWVhUFFjMEg0eTdQMUR5NXk5TUpD?=
 =?utf-8?B?bzNsYXBsczNURjJTcDVCQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkxCQ1Z4TTcvSXJ3QmVVQ3UwSzF3QXRRRjhKMWx6ZUxSUkU0bC9tdkR0UTQ5?=
 =?utf-8?B?TEtTcEFqbEd4dVBrcHFnUDN4eHRJaEZDcG0rbjFCZm9lcWJpQWpNZGJCNElk?=
 =?utf-8?B?M0U0aUVZRFdUOFVqcmswSlFrbmgxSFdHZlRBVFhoNnluek1IbHRuaGxnTjdK?=
 =?utf-8?B?dW9PeWczLzRqMys1Z29xZnNvNDVWa2xMRGJhcGs5RDFRaHppc2VHbjZqN05B?=
 =?utf-8?B?MS9JSDY4Y00xZEwrZU0zdnhtNkFmVmd4RVU1bmI5cGpGTktyMzJwSm9ITXJ5?=
 =?utf-8?B?aTRHeDBiT3hOZGVzMnZZNDVORDJpMDh5bmZpU1JaZmxLa2l4M3lSV1dUQjFx?=
 =?utf-8?B?V1dNYVRPL0V4VitGWkpRR2gzSHU0UzI3azVvd25RRFd1SHhCR1dacjE5ajlx?=
 =?utf-8?B?Q052R3RrNlNTNHNNZWlIWmMwSUN5dTdLKzBNYytQNnl0dzA3TXlzZG9CcTZv?=
 =?utf-8?B?Q2dDZDdWMU9xY084K0t1WElEWkRITENjKzZkcklCaFoxcXpOc09EYmVUY2t0?=
 =?utf-8?B?Ujlyb0NpSDRLeVV6Y2tZTWFoSjNwUTRvRGliUmZJM0I2UlYweHViamJKN25v?=
 =?utf-8?B?NjcyTmwvVjRpOW1BK2hySW5LK2xUNE1TQ3V1K0ZNdHRia3FnZmNRdjcvWWs2?=
 =?utf-8?B?dERkdkFuMDVaRk1LQUJ5VVk3dkZzb3ZjcHpXeXRFSzExV1F4cUtaY1llMlk2?=
 =?utf-8?B?N0RUaTdIKzVEcXlhNTJIN0NETzhFa09Xbzg3RVAxK2ZnZjBuUG9DZVdpWktN?=
 =?utf-8?B?eUpkRHc4RFVyTlBGdHREUC8yTTdQOWFLdm50eTl2Q1k2R1c0WXBwd3pHeXc0?=
 =?utf-8?B?anhDZGhLQitOWDE4LzM1RXJ6REFMU1pjMDFoTk5mQmsxd05UaCs3bWc4QkdM?=
 =?utf-8?B?NDE4SmdQRE1vaWRwY2FIbWRQWU9HeGFFSmY0WDZsNlZWb1NWOWhyOVNWTmtw?=
 =?utf-8?B?Zk1QM09QU1d2S1Z2KzlBMDFuS3F0UUtieW9VdWR4ZEJjRmRXanhXQ1pSQy9L?=
 =?utf-8?B?K2lFeFI1Wm0zM2xZdnJ5dVJDK1d0Y0V3NmFMbkdaY291SWhvQjdXV2tNdTRz?=
 =?utf-8?B?WW95czd5dWpRcU1mU0dqai8wcXVQVmlubFNmMnRlSlN5TDlrR0lOT05STXVa?=
 =?utf-8?B?Ryt1dHUzM0hBK3JZQXVwZCs4d1lXVU9rRVlBSnNhY1U5eXVJV25Dak43OC80?=
 =?utf-8?B?dm9NbURoWXFyZjFvR05DL1VtSzNjN1VJamFHa2VEN1pjTkIzQ0ZsN3hRV3Vu?=
 =?utf-8?B?d2J5UHZHdFZwdEZ4N1RKWXhYUEhhNGh4NTI2aUc0SG1hbnNJYmNRWk9STnN2?=
 =?utf-8?B?VXFSSm5saldqOXVUQjVZNTFUVkordVhPL1M1MU9uMUhicjZHWExWZ08zNUpR?=
 =?utf-8?B?dENVS1NhdTlZRHpYRmFmbUtaamc0cEw3K3BTUGhwZzd3bDFwbFNFMEZDd2wr?=
 =?utf-8?B?dXZlTU9STjFxZ1ZDT0hhRlk3Qm1zQUExM1FjTDFHMUtQMXdldUNsT01FVUJS?=
 =?utf-8?B?QnFDWEtQL01NeWxnUDczcFZiVlQ5RHJyRFdDNXdsSVcrejViZEFTZXVuMmwv?=
 =?utf-8?B?cEtOYkswUzZ6Qi8rY1owZXFpOFNOalpGbUl3bldWanpGMkU3WU04Tk1KQUhz?=
 =?utf-8?B?OXhObmk5Z0dtZFFSNmIwNEh1WFRuODZlNFd1S3lWM0c4aGxvejBXTlJrSkhE?=
 =?utf-8?B?N0FFenZ0NzlkbnphRm1yUFEzV09xOVA2cXAyVjMzbGVoSjh4K3huV1FCY1pI?=
 =?utf-8?B?aUZ5bU5Fakl3cUFzc3ZOTjYzRVpMN1RVcXg4bmNzQVMvV2Q5d3V1RlRrK1pK?=
 =?utf-8?B?LzlLY1RHalE1blIySXhHbmpML1NmcHd2cVJMOXJVbzVFdXBEcEkvVS8xRlpV?=
 =?utf-8?B?Zk85TU1kYWRqbi9PQ1N3TDh0MDFVVmNBUmtuR095ZDBYNkRnRkRxRndWR2hv?=
 =?utf-8?B?Zk8xdjBONzRZRGZnb3JTZnhmblpNTCsvVmQ4LzJnOVVTeEJZQisyeVdETm1M?=
 =?utf-8?B?MXFEcU5HRWJDclo0eWh6SEowZW9ETEFPZU16QStrc3NncVl4ejVCSmxudWhs?=
 =?utf-8?B?dm11TlloUjJLOW82bmpnSVB6N0o0SjM0c0RBdm1xSm9zbHJaTkUrdUFKOTdK?=
 =?utf-8?B?MlJlUkluMjlGcmpjaG1MUlhDamcxVHNPdkRXVCtjcEtUUkorc3gwZmF0Umgv?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 489dde7c-30af-4372-9ab1-08dc956f7971
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:35:19.2097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0h0iajSGjvLS5v3vmOG4t64YcryK7v/nTsUD70yfdNYcJIfnVb2LlAfRhQd93GRKtB4OY66eT3GP4GdgEYmOfOJBze4ZMjY34ju9kd45NOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4929
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> Hardware has two RMID configuration options for SNC systems. The default
> mode divides RMID counters between SNC nodes. E.g. with 200 RMIDs and
> two SNC nodes per L3 cache RMIDs 0..99 are used on node 0, and 100..199
> on node 1. This isn't compatible with Linux resctrl usage. On this
> example system a process using RMID 5 would only update monitor counters
> while running on SNC node 0.
> 
> The other mode is "RMID Sharing Mode". This is enabled by clearing bit
> 0 of the RMID_SNC_CONFIG (0xCA0) model specific register. In this mode
> the number of logical RMIDs is the number of physical RMIDs (from CPUID
> leaf 0xF) divided by the number of SNC nodes per L3 cache instance. A
> process can use the same RMID across different SNC nodes.
> 
> See the "Intel Resource Director Technology Architecture Specification"
> for additional details.
> 
> When SNC is enabled, update the MSR when a monitor domain is marked
> online. Technically this is overkill. It only needs to be done once
> per L3 cache instance rather than per SNC domain. But there is no harm
> in doing it more than once, and this is not in a critical path.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
