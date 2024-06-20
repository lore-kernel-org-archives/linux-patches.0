Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9843A7E0E4
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918015; cv=fail; b=ggGLI7dqJWc/Y8GGFDfOpXDz0TDsqmDY09T7bm4DQEYIOOYZHGOrCDKubwa19krHzrbH4TRt6iWXCuhBh508kX5Te10OoyoT2bz4SrlGSoEAYVCDZwj7pnKD8BfAA+6iE89NbqmreGB+lp1XZfxoAo2cpe3O5/jfIMubt8kSSRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918015; c=relaxed/simple;
	bh=ilS1WbRtBG0tSMwaJYIPIq1V3m4Cq/MNrObt+HBtcPM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pflez/ZetmuGLOlSgwhkMfv0pc1zriaHldiD2TyqtrS25JMv5c0+D+Z0ld0JSQpEPWRS1G4VoKKcvIkwz2DbKzdUNNldPQCuPoXiTMrR0IR/+Cin7FLKAm3o/Ruyhnau7tPu32J1PeG9Fk99Hke14bUfj0UjDWCakeZozGcqcYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQsHCPtZ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQsHCPtZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918013; x=1750454013;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ilS1WbRtBG0tSMwaJYIPIq1V3m4Cq/MNrObt+HBtcPM=;
  b=NQsHCPtZUhXXUkYpe1hxFRvBqkaw0L52FJCG+fwGPJbxq+Di67qHqKMJ
   4PHPatoiT1K3Zb2MrvtNrc8VsdOekuoT2ZjbggZweyqnjJSe59JzbZTdh
   leGvRNS2KbB93fxZX3APAP8T/EVE3E+ll/V29p2XYTY/6A8Q8L3Jjqubr
   Y21XFLgjaLZ3pSdnawDaoHKskbudFZrVsSh30InKPG4TP8VRyq+cwbRC5
   D3RstH7WoIk4iF8oeGTtN2jUCZIkB+UenHdDsWcfUkvbJSHLKg+3GV4YE
   jGdPpvBoPWFRvAVgNofq1mSHQeaWEDnDp1zo+h7ATs2v4lJXw+AP9vOIf
   A==;
X-CSE-ConnectionGUID: XXKmjH0OTKqBAxKhHBf9Ww==
X-CSE-MsgGUID: jBBTmlxxSZe/579wqkcVOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16056670"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16056670"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:13:33 -0700
X-CSE-ConnectionGUID: kqX7cLtrROyK9kMG7OCZjg==
X-CSE-MsgGUID: 7QUhwABtSai6jzilOzn1Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="47319193"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:13:33 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:13:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocUz62hbwfMMlDpZ7EEbke0yEu46vFdtnZN3OToOoxegfgpzyIiJwr6/VdjnLlBghfqf9/EvHzNdEjRR2BwszbmKlpCv16lX76fZFncLxXLhhiU0bGi9YUAU6EaZkD7Zc0bYzBwh+7rCiBkVgDh74NvSdVNy+iRtAhbSUTAjsAEEPcVYR9eRYlzK61F0cw+xdkXZ60gpLNsMA7rq2LCIRDypoCIrveqZNUiko4bRVXvKst/ketXhbFkybOOhv1liE3Pn0h6R12viwNPsafnkcBkxV32jHGUYoYcCDsBoywupyp+0XZep+rsDogzyGgX4OJNOwoJxUQcp8+laoLnpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GU73n4XBk8j1tmOQpvQSgrniHXhubrZ/o3QAwRNqsQ4=;
 b=JJgqgfizfHNN6q/SKZ6ZS4V8iZBnpiKwuViHcpn+ddrdXHWuVzCIAqcMnem+Yo8IP+7kAJwuXfI4q2LTu1XLteTQOMYW3bqSGfs+u9ZQSirbt8pTtGZN3qFzgkunzICjp5pkaJs0GnGYMTh4HHzf3HrAGbTnxh3VPYORU+3mHLtkEHVUGp0yoG3+6rwuR/Nlr1+P/9IKYuKpn7VgzZT5vy5nCXBMwnx4bkCXiScrhdTXWWUC9e7oyvfiFCrBcU4otQwi+NKL13UahoMmgJfGGaykJD5qe5cf+ALHCBGFsL5RpL6BJBdNX3J6TIyTc5qzZwEX6qJoY+UtizGn//xgeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6878.namprd11.prod.outlook.com (2603:10b6:510:22a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:13:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:13:30 +0000
Message-ID: <cd626d5c-ea2b-4a09-8d94-689996f7ac9a@intel.com>
Date: Thu, 20 Jun 2024 14:13:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 03/18] x86/resctrl: Prepare for different scope for
 control/monitor operations
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:303:8c::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3ea747-a331-4565-ed3a-08dc916dd5c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZXdUazNmcEU1eTcwY292R2JMaW9OMXZFQlpkKzlOZCtneVF6bkUyOUMzeW94?=
 =?utf-8?B?QVdNTW5QbVdIT0FNQ2NNc2phUTVYeHk2Q0RQU2E1L2lyZnJwL29tNi9GbE1T?=
 =?utf-8?B?TmRXVW5lT0pYdHpsdEJpMjI1bXExZWY5eDMxYjNJV09xT2tleXllZHhrK1k5?=
 =?utf-8?B?WkdMMWgwRTkrK2drN2xPM0JZc2c4c0krTDFoMGc1OUZ0WDZzdi9CYXdrczlJ?=
 =?utf-8?B?S0ozMWcrVUhMNFNQczdYLzZKVUN4V015ZkpGQVZXVHdtOTJXcmxpZDJ6VHZy?=
 =?utf-8?B?SWpFOUFMQnV2Y2c5K2h0Z2NtblMxUHFPeWVBTVNTMlJaM3p3MGVuTGdUREor?=
 =?utf-8?B?dzd5QmJGZ3doL0UwQ2cvTXdlRFYzcGRDMlpHK2doQXY5Q1padUthbHRQK2lk?=
 =?utf-8?B?ZXdYUWwwSnpiaXRxRU1rbE4xcmtIQXJwUjBjTXZhckdqU2dPWnpuUnAyVnh2?=
 =?utf-8?B?ZE5Kc0ROL0twY0VwUFM4SWM4a2ZOaVNwbXRRdDdCYWtTNTZIZ3prVjlaVktN?=
 =?utf-8?B?YVAzR2FzZ3d3UEpUTmhRMmlWcHdGSEhHQTYxSEFTS0hIYzVOZVFhVllMYU5w?=
 =?utf-8?B?K0JLQnkxS1R3MFF1UVAvTVZyWVZ0cXZrZ1pYd0cvTkVSRkxYcHUxQXgyVW1x?=
 =?utf-8?B?eU4vUTBPRDEraUxxeWVmeDRiSUxBS28zSUJMZXlPaW50Q1EybjU0QUtkQ3JO?=
 =?utf-8?B?djAzeHVQZ2FPbDhDMmVYa1p4TnBIeStZSDgwSUU1T0RTZUxSY0hFeUswT0ZW?=
 =?utf-8?B?OThHNU1abTBXWWtjNE9mWXY1OGNHd3F0T0FNUmUvVnFqZkdYTXU5Y3dPcnNG?=
 =?utf-8?B?V2gvWmNzWlZLRHNRVDZSSnR2dHBCWUgwWTZZNjdLUktSb05WS0NSOWpLaVJV?=
 =?utf-8?B?K2F1RzZqQTQwQ1Y5YXdwWlJpR0xscVQ4ajNwZnZzN0c3T1hnR2I3TVlUZU1r?=
 =?utf-8?B?aHkzNlVaS0tHTDU3b3lzTU01K3BLdnVpNGhURVV2aFVUNlpwNGVoZC9OU0lh?=
 =?utf-8?B?Vk1uQlg5SE9RVlB5cThrQ2lFRUdUYnR2d2ZQWUZ2RDdjMWFHRG5VVVZ2VHhp?=
 =?utf-8?B?SEdRcS9rU0Z4bDlWbDhsdkp5bTRsK25HSW4yb3ZEVVpjUXkxSUtua0c0TW9T?=
 =?utf-8?B?TXFIcGJNdE5tOWl6M2U5eTZSSUVJMHpYWHFPY1pVUDBZQ1ZjQ010Y3FFK3pm?=
 =?utf-8?B?My9aRXFQR0p3YkxXWkpoU0hZQTZUak1UU01xMXJUNk12b0E2d1h1ZU9LU3pT?=
 =?utf-8?B?R3cxUzBMbGYxaTNrK012ajcvakNCekt5WXNmc0ZPaGE2ZUE4K0RiMEZKdEhF?=
 =?utf-8?B?WEdEeEwwWUREbjJZR1dWTTRCM1VqeFMvbXBWTEVldmpQUkdFcDF0M1NhdWJ5?=
 =?utf-8?B?bzNPUmNWQWN0bzBDTTcwcGlaSnpBWVkySEdLVnh3NjRKc1hheGdPZk8wWWxP?=
 =?utf-8?B?WEwwclNJZXg2bTQ5VHlqbVZXbHVZTEhuM0ppbmRjak52U3IxWnMvQW9vUWZ1?=
 =?utf-8?B?UlN0dVgwclg3dm9IUkpDMURYb3h3Y0d2TDJSVThkNkNHajhSQVovOEdmOVdX?=
 =?utf-8?B?V1duSjRTVkRtS21JVjBvRzdoZExoQVpodFhpdS9TK3VUK0hVL0hGTkhjd1hs?=
 =?utf-8?B?WWVqcEJyR1drVlRFbFNHdUNpbnFlb0ZrV2lnNTlyYUZuR2JOWFk3TjNTZC9G?=
 =?utf-8?B?U3NSQ2hTS1NCMXFqM3U5NSt5OVBHeTFqSVNJSXdBV3BGcnFzaHdiSk84R1ZM?=
 =?utf-8?Q?UaAxQBeAJPKbW8mXlelSOpYqhKN/ZujukQVHeM6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDM5NGRqTjdyRUNsMnFBVGZoVkYySCtyTkdzZ1NoVU5menF6UmdVaERMN2R6?=
 =?utf-8?B?R2RZbDcxb1h1Y3BGZmNZS2o2Nkw5YUh0TG0xZEM0M0dJbk5QUEFvMjJET0dZ?=
 =?utf-8?B?bmhUakxxYmhDaWJsMzBEcDdRTXEzQXhDZjlkakxDZ3lzeFlBMUFQSHViRFFi?=
 =?utf-8?B?SGNibGRDcDBlNWNtVWVZSDVHUERMemc3YTVpakVRdGFKVlEyVS90UVV2SHRa?=
 =?utf-8?B?ZG0yTFZ3ZWtZVW0xQXJzQWRVTmFSd1E5Q0xmV2c5SzVhOWx3aXdYaUNpUStO?=
 =?utf-8?B?MGRic2ZWUE9WU25BOEdMSXR6VUpkZkhtRlZzNDFzQmxzWVA3M2UvSjNVcEIv?=
 =?utf-8?B?QlZCTW1Hc3I3KzBtdXB6VWozZ09qeEprSUo5bXA1U1kvUm53azF0TU9CMmdy?=
 =?utf-8?B?M2Q4NllvOXl2RDB2VjNjSmdjTUhpTFVHQ1BRT24xK1hnd3h0TnJ3UEVmMlhX?=
 =?utf-8?B?UEpFTkV6cFByYm1UZmNyMzZHL1BqdC9PUlpCY3NCZDdHT3JmYW1KTFZkeWNr?=
 =?utf-8?B?YUErSTVUa1dLeXFlV05JdkFXb21oYTdBQnRtY3B1Mm1pQVkxTHN1akJoRUd1?=
 =?utf-8?B?TnBXNHJabmVKTkJ1MzZZbjVONDVHWEhUdlp6MnpaWGtwcjNYZHIrTXdQTG5O?=
 =?utf-8?B?dFZjNFc0NEx1bFFpNlowQmpTSVFOZGJqankwaDRod3RBY0EzSUx0cGdiRlBq?=
 =?utf-8?B?VzRSaVFSaDhtOWZiT3ZhVWJGMklEUXZjc1VSZ0o3b2lXOWFRVFVGZ1VIRklQ?=
 =?utf-8?B?Q0cxUUVaYzZPL3IxOExxSDZuNjdWek95a3hTejNGZzBiVW1CY1NSaWNiZklE?=
 =?utf-8?B?MXVsM1phUG5ObjFOVFNuU3BRVXArdDJ4S1lmUFUzZUVzSkl0aWZnd056bjM3?=
 =?utf-8?B?U2taeE5mL2dtbys2TllUVGNyZHd2ZFIzaklJTm5VUWFIaU1nRTZIV3l1bUwr?=
 =?utf-8?B?T1dYbnVJL3FTVzhtTU9EZzR3RERkQ2M5T3hSSXhROEhyUWxTS0NJSlJ1Wjg1?=
 =?utf-8?B?cGQwQVNpamZ0cGhKQzR2dzJneFowZyt6Y1dGaHpSVG42VGduS2xySkR4VXp2?=
 =?utf-8?B?V05UaVE5V0JVNHlNbzBvZHZUMEZpdEIxUHQ0MUNrSy9RWUsxMy93ckhpekUz?=
 =?utf-8?B?UVhTWEJHMGlMYlR0alVLN25nU2hMbUc5alVMaUp3MWExUUtORUlFcEgxZXFN?=
 =?utf-8?B?K0FiS2RiRUpjWUQ1bHhKaTdOS2ZRcm0vWFV3eGxCQjR6S2E1UlFGcVNrVFF2?=
 =?utf-8?B?ZW5NYXc5cUZyMEJHcTczVjFKZFY3QkRLVnN0T0d4eGp2TkFjbFFheGtYWTFV?=
 =?utf-8?B?UFE1aVVTWjY0OVVmSC9mNW9tcFB6UUplWWlsdU9mU080aTV5UXFKZXBCVXBJ?=
 =?utf-8?B?R09NM2lDelZYQ21rNmhURDQwN3BQbUU2azFsZW1UVzY5YlFvL205RzNhR1ZN?=
 =?utf-8?B?bWs1ZW5JMVBORGI5cFRoM0FSMEozOGlnTnY2aEQyOWdkeUlhOEUyaFI1VEFJ?=
 =?utf-8?B?U0xpdUw2VCt2eXU1TGVuNDdOcVV2bkV6bTdxaEtFTnhna0I0RGxPTmIyWGRS?=
 =?utf-8?B?c1hZQmFDbloxWmdnMTdEcTFLWHI4aU5vR09UeVNJZXZlNjhlVFlMbURSdnhF?=
 =?utf-8?B?Vy9YUitWVGxxYURvZUxpTVMrcGtxcjMrT0g3YW84cDRiSlhtSURJVldqQVZR?=
 =?utf-8?B?czcyeWs2Q0Z5clI3SDF4NjdEUDdiRDF5clVFQ0hESDVGdmdDZEhvSE5CN21M?=
 =?utf-8?B?NnZ6VDlQa3ZyK0VObGRTd2xIaGYyYUZXNm5hcGxrTWxGdG92d0hLRTdzNnNj?=
 =?utf-8?B?bnVtMmQxZzlmUGQzYjBhU0dNODZuUDI4RVdibm5EN0l0TUdibmFNNmx4WGE4?=
 =?utf-8?B?UUFKd1k4OXBtMU1LSmwwWUZIdXQrMkpvVml2dWtJdW9va3VNOThSbkRYYVh0?=
 =?utf-8?B?N0UydE1vdUFTRDJWWGNsWXdZYXF2Zy9zdmREQWpiYnd2U0ZobHpnVlJ2alpE?=
 =?utf-8?B?NklVQ1hSTHZaV0hmcGt2N1Z0dkt0cm9GMmNKWnJPZWlZaUZBNFJIQ1JPRERQ?=
 =?utf-8?B?ZStYZXJLS2dOZGhVUG9MMkU4UnBoK3FLYzhFa1pEQnNRa0hLTUpPRTA0RkFv?=
 =?utf-8?B?NVRxOWlncElBTktKN3RhajNVc3Nhc2ZyNmtlWVdKNDBuY2pBNFljVGg4MWhN?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3ea747-a331-4565-ed3a-08dc916dd5c8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:13:30.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMhrbAeKKTF69sXS2/iBPxf6RmOtsVm9mZEQl+ap5Ge4QlilRl6fhN2Ur81Wp7D+keZGQYThNGYYbC6eSA0hav1HosTxJf1E1Sz5bOyZGjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6878
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> Resctrl assumes that control and monitor operations on a resource are
> performed at the same scope.
> 
> Prepare for systems that use different scope (specifically Intel needs
> to split the RDT_RESOURCE_L3 resource to use L3 scope for cache control
> and NODE scope for cache occupancy and memory bandwidth monitoring).
> 
> Create separate domain lists for control and monitor operations.
> 
> Note that errors during initialization of either control or monitor
> functions on a domain would previously result in that domain being
> excluded from both control and monitor operations. Now the domains are
> allocated independently it is no longer required to disable both control
> and monitor operations if either fail.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
