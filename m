Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298C7FBB7
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611510; cv=fail; b=sJOGSRCt5WCvljfC0Ji/jlcPIoGowrxuktwzGTqKHPVBxk9UUYI4tVzuBYhmgGb/pAGlKpgWVqmCs0VRdMw1Hse/pbzO3AAoppPpUAYAIFlATdZVdFHZ2UM6mTTiA+EDGDG5gXzqBMVzWTic4UZ+LDnzJgSfklAWi6J4H0UEYdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611510; c=relaxed/simple;
	bh=P0ek09M69oyGW0hfBD/nguuyLTpxrJmSOJCYemUs3x4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m/5RC8PMuxJJe3kcWlUbD/iZpIMdaCAy+IHYUa+W7BHWtirB6rI8Q/3MR5OghekFVr8BkTaeAleV28tf8fY+FoQZF1Yl8f4TyapU58aFOcGrrmc5iSeWAR7ZGAuJonP767Px8XwdtuA73XWkmoTrmJtaxYsLsIsrWJU6CCyEjBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JhJrwFdu; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JhJrwFdu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611509; x=1751147509;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P0ek09M69oyGW0hfBD/nguuyLTpxrJmSOJCYemUs3x4=;
  b=JhJrwFduRv9K1BNdefFIYIWB+EQK1I+2rMWtndTQdEZU7S2JEmdwIhz1
   YfKSi8elSfM+K1k8E28GkDlSLsT/2FIO9WIO+6U8X49JUMR92Lu7e1JDo
   DisLjBOrbjbxH9qe7sXFqESYm9YCKyRUPgtSUo8hNYb0uln8zmiMZ62Ef
   F1FKeo1Zi4XJ+fUsfKpZ0yByVpltw1bGELHoz9YEqmIEvbI/VuIdtEzD/
   pI3MBNM12BoWsYCIq6Th+/Ogif1UDRJySvk1y9jZprOqnKxH0y3UaXFtT
   wiXrJTDf0hf1kn3w605jP6/BMjlkaLKkDXnma0250o3gVMRl3jBkfd8Z4
   w==;
X-CSE-ConnectionGUID: 7Ffx7aqlSKuJl4wjvIwQbw==
X-CSE-MsgGUID: zybFYHUnSBu4CNdCqOOQdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="20568434"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="20568434"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:51:49 -0700
X-CSE-ConnectionGUID: VXWAipVHRYWsEBCa4bX3wA==
X-CSE-MsgGUID: 6mBk9cmgQ6arVs/qGsGtEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="45608229"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 14:51:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 14:51:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 14:51:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 14:51:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 14:51:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mChwAk7p9kI2LEBDehou2nKh/ttuqjZ9Qc4MQO52WzkMtIteLrpbU3UDb1VvugQAQJR50I5wNe5mszaWS0+EzmE5jmAa0zysq/fyuOiPu3708j4j2j2fPZsmaNZLKSfvpFqdEfkJEXMCzhuc/QTiZDi8ctJjs9oKHYy4Bfn1113mKT5Wg63e43nKZE6GbimiUaJw3h4mywuTAus8VEUyVS5cDuzRCJrLL2dw1dvWXZaNMer1T3QOPxFc/Bq+Jw8aAHfIDlKXP2NmTkj3i0sH3xmyqicOv6OomaW74yqn0E7AXhPqQ1HhWGgtCynxZWvs2K75DzzRG92KCKtOFjwlyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYMNY+XYp7tEfwVheJ2RDu7uPMFYdkI505IkDUbBfk4=;
 b=XK6b+Z9b4HZX+COABx+GfJoR/ZrY+HNScYfqjwWUI5YlOEfw+aiJwa4hnJZ4zDJLXR2kGNIz4eNrh4AJyVkj97G5MOurd2COcE30RCMFiJHc9teLYSbCrJkmq9sA/9ENWL7G1UnJu7xxPPiObx0t/Fvmrl0VlUxYzP+1e0PnKSlNTHvQFkBKkSiPgv0eKLF7pZ5TxoF2CGH6WlrawwlxaoBJ4BHuCrhwhDii1iub9C3x+2bZ5vm1B05Pp4Ujuz9CHsM4stOQoMatJE0rYpeB1/ptGYKV6ZAhk2yuzxsKVCWGaNmkKdjrEWQWxj3JOS/iwoo+pyqdnEuxKTlcbV1gZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6089.namprd11.prod.outlook.com (2603:10b6:930:2f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Fri, 28 Jun
 2024 21:51:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 21:51:45 +0000
Message-ID: <f0e47790-ea7d-41ac-ab69-d8dc0ec9f230@intel.com>
Date: Fri, 28 Jun 2024 14:51:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240627203856.66628-1-tony.luck@intel.com>
 <20240627203856.66628-10-tony.luck@intel.com>
 <2b155124-1a82-4a23-8de5-0c4f5c89186d@intel.com>
 <SJ1PR11MB608394AA9279A8BC9134E61EFCD02@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB608394AA9279A8BC9134E61EFCD02@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:303:8f::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 2249b1dd-2ddb-440a-2295-08dc97bc80da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OXBTcjNSTUczVW4rbnY4VGRwR2NPdXVHZFV3ZUs2c1A5SkRxdHB3OFQxdlFr?=
 =?utf-8?B?YmI3OERvdnBhZm9ybzFmY3cxcHprc0VnekhZemk1M3JMMTZSTTdjUCtjY3VS?=
 =?utf-8?B?ZHFqVFJzaDVaTnB4aFRhdURLTERjU1NoMmkzRWExMFFrMjk5bU9oVjROcDlF?=
 =?utf-8?B?enlPMkRaUW5lTmZrNEtTQzUzNkdUU3RXLzB6djVta0pXNHdNU0lscVFtNzAy?=
 =?utf-8?B?ZFBkTUJPTEN5QUxpYUwwcmc2bUM4ZTFwUmphdHZLenZxejRDd25mZFB2UU9l?=
 =?utf-8?B?ZjdKRjY4UG5Cd1pCY256Nks2OU56QVpScUxmbDI4TG1sbU1OaHFPb2lJOUF6?=
 =?utf-8?B?aVgzSVpKTU5DUURKcWZRSUE5em1YcDhqV1hQNGxQWDFjcWMwZ1JuUjJ5ajVT?=
 =?utf-8?B?dElNWkU2SG9pUFM0Z01HbnVVTHRTNWx4TERCL2Q3TnN2RTZFVkxPNTJOcGpw?=
 =?utf-8?B?Y2F4MTVoSmxqNWErWnU5RCtkNnVJYW1Wd1EyT3I4SjNueVp4ZkMrMzFmenM3?=
 =?utf-8?B?WVpabjN6WU5ObHNWNlkxYkRLaUMvbUJGa2N1ZjVyNUIrWC94VHkwd3hkZHZS?=
 =?utf-8?B?bzNhSWxCanJKSHdlOVZyRGxOZG5TR0puZ1FRSkRHajZUREhLWWFka2RteGsw?=
 =?utf-8?B?WU1UMm5LdHFCcHhmbTRoYjVWZjR3NkhGZCsyYWdaSjVQWmY1ZWNVYU9yYmU2?=
 =?utf-8?B?ZVluZmVjb3NpdFhIeExiK1lKYTRBMmZmV21rd01vRzNCbzZ3VVF3UkpxVjJl?=
 =?utf-8?B?MjBZUmljdFhMUDFwWm50dXpJMnFBcklDQnNYVUU3clpyNyticmZ4SG1Ba1E5?=
 =?utf-8?B?YVZWalUrNHhnMjlzbXd6cUZGekZTNlM5K1VuNWFMckJtbDJneGlFUmtRdDFr?=
 =?utf-8?B?OUY3Nis4aUFKMGxZek54eHBlbjdRM0FaVk5UNUhuK09RVWVwRUJOQjNab0NW?=
 =?utf-8?B?SUhIQkgxVDZGbVVjcVc0cnpaU0xzQm8vbmcyNkxXL2ptam8xODYydjhYV0FD?=
 =?utf-8?B?eEdQVHhFUGhMVlJ2THlaZGJJdDczQk11M1VpbWc2NjVHZE44YTA3cDdHc2M5?=
 =?utf-8?B?N0tGRTVmbFJ0Q0FpZWRRNkc2RldrdjJXd0xqSXFkRTF0ZFUwZExJTnltRVBS?=
 =?utf-8?B?S1k2Z1JobFFrWXY3ajBWdEV5eUlobGM0U1JxSU1IVEdReFJDYWg3YmJ1Z3l6?=
 =?utf-8?B?Wjg0MFBVU2ZnSC9nc1pXMERPclhUL1NqT3VyckhzVHk2QW81VlRDQ2g3RGwy?=
 =?utf-8?B?UlQrTUVFOEZya1Nrdk1TVlNzUTEra1BtNGdLditsWWdQcmhwYjNwSW9FSkJz?=
 =?utf-8?B?NUJGTE1ubWdMejZXdzloUmVMeWhWNnorengwQUMyVHN6cWdneFMxN1d1OUZM?=
 =?utf-8?B?VHRFMzVaU044Vk9uWDcyK1Q0SUpFeUFCajVCWU4yb2hMbUpBUVkvK1ZsR3pn?=
 =?utf-8?B?c1NuUWFTRExSQURrOGgxVlpRd1hXRUkwenN3YjZJZVFnRlptdmE2eHo3bmp1?=
 =?utf-8?B?bTFiem5Ia01YNHRKRFNSdmI5RnU5cURpME9GdmNaNzAyVUFmcWdZRHN4TEVx?=
 =?utf-8?B?ZXV1endmUktmWU1JZ1JoMjhPRkhKMDAzN0V4ZCtBWWg5MnhMN2VKM1lvdEtF?=
 =?utf-8?B?eUE0SUFvNGlNanVIU2ZuUkx5UytjdDIxb0xRajRpbCtBc3QrTVhtSVg1cjNp?=
 =?utf-8?B?YjB1MDNVTkdlWW4vRUMydGlVYkRGcVhqTmRKeCs0UytjbE1FYkYxZ2ozeWh4?=
 =?utf-8?B?VitZVjd1S0FleVFTUjFhZXdDUCtOdmY0QTQ5VnREcENFS2NNb3doK0daQ01r?=
 =?utf-8?B?VFk0KzhxSVlWMGdPVXVzMXBMU0YzdWdPVVdGb1l0NGNZSW5iQnVjUnZkNC84?=
 =?utf-8?Q?9zKcowIINO562?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SW1XL1RMUkU3RVFJMzk5SGRpTGFiaGVHRElHbmVGdXBYd243RDN0d0NYRHdq?=
 =?utf-8?B?OC9DUmgvVVdMN2svL25zQnFoMWlsc216dGJNVHppdUMzL2ZMTVR5RFlPZ2tv?=
 =?utf-8?B?Z3BtcWEwUkpEQ2JDMWhIS3pETTA5KzZLNU9kWDRPUVdLU2FlQVFmcjliRXJF?=
 =?utf-8?B?S2hOb0RYaFVia3NYM2RXTnF5SENTcHlTRFdteEtuY21DYVNpaDVnOVIvd3l1?=
 =?utf-8?B?RXBQd1dnbnNDVWNoREt1eVBPbGtxSUQrR3o0ekhMZ0wvL3RIUDMwT1dWUWJ5?=
 =?utf-8?B?QUYyNUE4MktIVUxFUVpDSEZIOUx0RkFKVlVlSjc0VXJ0N2cwbjRsWC9OQTNq?=
 =?utf-8?B?QkhlTUJzRVhQdEE5TDNWdURrTTFwYkFpbmlQcEVBZURQRjFKK0FHSlJpSXBO?=
 =?utf-8?B?aEhZZVU2S1lRaGtVeVphdytuMUJZWmlEOTlaZWQyNEg1bmFtQzN4dTVQYWhX?=
 =?utf-8?B?U1M4NFFNUm9ZcCt3SWpwY2RkQmxPbnVCRWdaZDluVjE2a0tlcU4vY2N2UFFu?=
 =?utf-8?B?Q1FFR1F6cktRa05TZnR3MXhBZTV0WDRjaFVMRk9ua1FKcS9IWjZMQ0lWMGFu?=
 =?utf-8?B?YWJZZlo3SFNTMWliR0tzUlpUSnMwUUt6YXk0a2piZ0kzRWtDY0hrdHY2cHdW?=
 =?utf-8?B?NDdyQjY5QkVTNlhCdkl0WjhWaFFZZjBqeEhzaVFJd0JnK1cvbXJsR3hJY0dD?=
 =?utf-8?B?eEV6MkM1WWkrbzRXQldITExtM1ptcUJwOFdYN2t4WFZCQURlN1ZMaUZXbGxL?=
 =?utf-8?B?VSt1SEJvT3hGRENDVXV6VE1XV0JmTm9wZE4zaGNOTDlJRkdJVURPM2hiYVZu?=
 =?utf-8?B?WnBxbHU1Z3N4KzU1eUtmTGhMdWJqS3M1L3N4Smw1VS9lcHRYa0hSMXVEUkQx?=
 =?utf-8?B?QWlINjdLYzlseW5kMTZ5OXpzeFl3U0c2blk1bTkwM2JzR2haNTdqT0xBUmNG?=
 =?utf-8?B?T2JFemNWSUZNUUhhVmNKdS8rRkZ0ejJUbERZdmpjbWpYZ256ZUZsS2pJZFI2?=
 =?utf-8?B?aGtZVXFlN2RuWmtlWC9GTjVINnR3Zlk1RWcwQzIxd0xFR1gzcEdIb21yRDN3?=
 =?utf-8?B?aVczN0RycXI5SUlEQkdMUzBSdXBnUmdvdVBaU2R5VFdFSThmQlRPRnhrcHVK?=
 =?utf-8?B?ekE2azNzc0lKK1Vja25nU1BjTHBGNFpmdExjbHpETEpSQ2hrWWJCaXhNOUw4?=
 =?utf-8?B?NE1YbHh3Q1I3NXBpQ3dDamhQMk5CNmFWQ0JhYUg3Z2NyWDRCaUlHMlFMUWVV?=
 =?utf-8?B?YnJ0UllxOURsRVp0WHVZaEJqbUI4Q1VpbU5wWVBwbS85M3ArVXJaUldYRVc4?=
 =?utf-8?B?SDhhN3VyUFhJUWZBejNmdWZhUzF3TWVtZDJhWlU0UzV0U2pxY0xEcXpSdEx4?=
 =?utf-8?B?bkM0bW1iU1BmU21VQXJTdHRnaVZZUXJGM0FzaTJOUnZvSW1HMVNGcWorb09I?=
 =?utf-8?B?TWVqWFo2Wm9ydVZ1Vmk3R1BtQ0Noa3VySVB6eUVFVUI0c0NtVnNyZ1lOSVZi?=
 =?utf-8?B?UE5UTStKaHVQcmYrMHVsSE4xalFKaVdRaDV1d05oVWlRaXUyNEN4ZGVRaFhM?=
 =?utf-8?B?Z213dDgyR0Z0S3hqTnJvc1d5UDRLZWdMUWxRSFgycjR6dmZKcWpTUExrempj?=
 =?utf-8?B?UG9KWi9aNFFOdTdET1hYRXM4UlZuRVFxUDAwc1htTHpsRUdGdlJWZ2k0Zzd3?=
 =?utf-8?B?YWZhTVorZ3g5TmRRemlWWWN4OStCcTVEREExbGZCanMwK25HQlpZTHNpcmha?=
 =?utf-8?B?bldPVEZjdW1vUUJjR0pvMS82NXZtVk5GT0hycmJZWXBLZ2g2U2dISyszbk5s?=
 =?utf-8?B?VVJobjZQRGxZRnJGamcyVDdsQUtDcGcyd3F2VGpsL1ZOQkRsejZyR05NRGRz?=
 =?utf-8?B?NDJtc0UxelZZQkVCdFFQVVZLUTBZcVZOZHJ1elJadkRvV1RvdnZWU2MrNUJZ?=
 =?utf-8?B?d3FQbG1GYmlLeDBpS3krRXFRampmUHY1NlI1MW10Tnd0bXZETW0wUkhYMHZa?=
 =?utf-8?B?cW5nQXYxNmFDOWk1R281RW5oWG9PMmltM2pWd1RwZ2RxTDZsWGhqUU1FbjEx?=
 =?utf-8?B?M0ZoZ0xJYjR4VHFwUXg2N2FKbXphZmhMVjZPMTB3VjhxUklrZzB2Zk8yZThV?=
 =?utf-8?B?QlZzU3U3S3NEakhKS3c3VnpZVWpScjQ4cERNL2tySG1VMEZqVWJsZ21QVlJ4?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2249b1dd-2ddb-440a-2295-08dc97bc80da
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 21:51:45.2678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sl8OqQNPKosk3XgBweu5uLyLC593apN2DssNCdYKb5LyCJ7Z9GfQqubJO30a+crHF6WiXjsXdZtVBU1s4R1aC9ndzEPAuQt5KvF459ev6mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6089
X-OriginatorOrg: intel.com

Hi Tony,

On 6/28/24 2:35 PM, Luck, Tony wrote:
>> For example, something like below inserted at this point in changelog:
>>
>> 	The new semantics rely on some struct rmid_read members having
>> 	NULL values to distinguish between the SNC and non-SNC scenarios.
>> 	resctrl can thus no longer rely on this struct not being initialized
>> 	properly.
> 
> Just checking whether "resctrl" should be capitalized at the beginning of
> a sentence. Digging through logs there are half-a-dozen places where it
> got a "R" and three dozen where it didn't.

I am not familiar enough with language rules to know what is correct here.
Either should be fine. If I have to pick I'd vote for consistently
using resctrl without capitalization.

Reinette
