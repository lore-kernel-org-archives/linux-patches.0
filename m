Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF8E76048
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412620; cv=fail; b=jNNXQtLxoVCVN1rNeO1RsecdUoZFa4FHn36gOobhGA6B5RxLU9+AVOIqNbCxeoaHIxCV6bsqxhqkNhEDq4ewEWQsj2SiV3wc6riWjKpSnSPqqKCl5VjhGNynz5zeRwSKdZQAk0oHk0pgrQd4MdV6cMbvr8Rdp+3TQ3C1p8KWirA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412620; c=relaxed/simple;
	bh=k0wC43wGX4nN5MKVv8/ao7VhdyKIzVFCP8ftcgq1v7w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dt9rUIirrwKH5QGflBd+73Glf1HKGCCCiAZq4HE0Hxbthw4UYvJzl+BPLJP0hg5T82VQFj0XTY04oHWw9fJfnrvXyHEd7nIjyUhy00BUOA3gqABRpaGXvXwCVxMAbqKjFLO40FuXi/x0IgDd1q9niTjuomaXzsPZaXibjIZ8zDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jVeq7kmb; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jVeq7kmb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412620; x=1747948620;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k0wC43wGX4nN5MKVv8/ao7VhdyKIzVFCP8ftcgq1v7w=;
  b=jVeq7kmbBxNX3H5zuJfKOQD4Vx6XDMdyvhy3qzG0RnASMjmxef/+V+7K
   7YRkZGSQQVqeWXBrneQKIwfdNhuadPRJkq7Y4bWzbfs1QgmK3CIzQYgIs
   ZPtJcSMUu81a8SJXPyduXELxG5WRq8nmIdI7Qk1F81tEWQvbVRadIgf0N
   /iaZkkPfhhEjScPV+xkVgiRdJzY/vBYBEoABPsLGbfoNLcPubwFMtWn7Y
   JnDmNVFraSL289wIvjBlM7kCR9RTCDlvVYvjKfprqFki4jPkZRhiNl1I8
   gEs77k9KlK12YBgrVkH/lf0zazyct1lUVzxAMvcfNaEhdsaxXBVlrc48O
   w==;
X-CSE-ConnectionGUID: on3bTeCKT0CgNjfUcSI2rw==
X-CSE-MsgGUID: QXj6lkN/TP+/ozv45pOs5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12546555"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12546555"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:16:59 -0700
X-CSE-ConnectionGUID: shHhvvPVS5y7gYPTIw2y1w==
X-CSE-MsgGUID: UR9G3gAJSo+gpw4j/1k+5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33422808"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:16:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:16:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:16:57 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:16:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9lQAfvSBBvtY+mWwhle0S9mKsC3WZVT6uCTAbi+K/OrXMCqMI36v/EIh96uZ6n3itM0db5E4/j8hjOW+cjjkfe04bqZjn8C/1JMhgVqYjSSKapFfFA4rKtrplhvutnSb8DztMCUFCkKq4egDTyb8CKee6ooYPLdPLkI5DUCozMj/InG3LGjeGFE+JwOfSJvCVfMxXKylntD5Y6+7rG0dhshrDm9bL8gFGWnWQM5gPi+ZUHcFEHjHLuB2CY5Emy/LJel37QNJDfyTEcp07L493mgco3GYq8vkSdcTF0MaLENhmDTazGpr+8adQ+kooM8qqJLeQ9w3c5xS9mLwR8DCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJJFXVzis5Wk9vV3kYopnXgt9Cp1AAPg0dExv7gErrI=;
 b=ePzl/deVMz7FduY8Vtzt1oU2O3kKWdxXNmi6pr2tNRhkcvJp6PusS/s4cmjxEVQLoJQ49g2S5oUSlctLbWePHJOgovDIFBpyZ5vcTXcp5APtCcTwwbT9Y57yOuB9A/MxoHcK3fYRci06GD7snVevYSl59Dl4+996plLKWDUNR+shZ45RsV0NfJV2TYaZyj41gbZD5iH/xp725rrW3PqJzEWv6AepQpExbispOBB/tIAuurRf9Es/VUpnTDl4K1DkdtyEvr2cKt7OJr/QLhM6SJE0afj4Wxez2YTWaLhdlivszWW6CHHtC4don6OCu/PwoHEQ7pWgg3jYAJugQkOvZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 21:16:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:16:50 +0000
Message-ID: <7764b46c-85e7-4d5a-947d-87cf51c27bb2@intel.com>
Date: Wed, 22 May 2024 14:16:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 11/17] x86/resctrl: Allocate a new bit in union
 mon_data_bits
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0301.namprd04.prod.outlook.com
 (2603:10b6:303:82::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb621e1-e9c5-4284-ce82-08dc7aa47ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R0xGWmUwUkliSWh4b2orL1JGVW9wMU5VMDNUY0JpaUZLTmZTMXhUUzl0R3VM?=
 =?utf-8?B?YVBBTTI2dXFOaFUwQTJXWW9TZW1tRkFESk1IOVB6OUFzbERiZUs0MXBVb3ZX?=
 =?utf-8?B?Uk80a3lLZ1NOejlxaEI3Q3hTN1E5eEJBdDhxbmJjVWRVWlg1S0NiQnB5bDFT?=
 =?utf-8?B?ZjZVZUdFT1ZIZndzS082eXJQcVFJZUxnbHhveVZqS09rd0xkRUo0VHdlRkFK?=
 =?utf-8?B?czA2OEgxSEgveGh5WTZSeG9oemVhWm11czZtczNCaERPQlhVRWkra1Q1OUwv?=
 =?utf-8?B?VVp4SWdIUzNVYkhsUjhEdjFCZGYzTVZyaHN0ejcvMGppUnRpeEpHeWEwMW5E?=
 =?utf-8?B?czczYldWSDdoV2paU0FGWGdzY245VC9tTkxMWU1iZzNBK2tWV3F3bjRxcjF6?=
 =?utf-8?B?RUVoMmF0UDBiZlBuUWg4OWN6VTZlUGFnU2JtL3BHWWxiQkNQVE1RWXFEMWVq?=
 =?utf-8?B?V285cTZYbmM5RTRwWWFVaTcwTUd4TGo1WjJRMjJJQ3BoSXY4R2pOSEFmU0RZ?=
 =?utf-8?B?NmhhWDNZZU8yUlRzemdpS3N4UE1KQTIvQXN5Sm8zNzEyS3c3S1NmTTRDcUZn?=
 =?utf-8?B?M1NQK0luUnRncWwwNmFzL0RHWm5jaVlNRUVlZkY5UU9rTVA5ZkxiNndPSWpK?=
 =?utf-8?B?a0pnMHNJNDBEZDk1M1VSZ3ZrUUtXUjBUTGJRZG1MTk1Nam9lTzRzTzB4VCts?=
 =?utf-8?B?WnVYSEwxS1ZqVHBXSGM2MUkvd2V6bGVrTGQzZmo5N0k1cTZjajhzbWYyWFRt?=
 =?utf-8?B?eUR3OFhwL2xkM0NDelAzWnplYTFpd3dBb0JvdW9sVVdoTTZseG5LRm1xSFdB?=
 =?utf-8?B?dDdiZFpXWlEyTHJpRTRCM05ia0d1eXJUZnBGWStYeFVCUmd5M1Z1cnlrMm02?=
 =?utf-8?B?VkNDemxRU2hSbnFWcjIwS2RCUW4zRlRpczlpaStodVo2Y1p4WCtWVDhhMVZz?=
 =?utf-8?B?VGlrM0tERjBiLzZrQWMzZmJ6cjV0Mmw5Z2RyMkRub01CdTNzL2VjUG1UQkVt?=
 =?utf-8?B?WHpGWTZCMzZvbEhHOWxuL0xNTEhlZm8vSzlIRHJQMDl2RmwrT0NkK1VSc0xy?=
 =?utf-8?B?eHh1TXVlbHl3N3pFcThBR2k0cndNMVJ1aWFHQ01UQy9rTTZrU1F2MTM5NGYw?=
 =?utf-8?B?bEJVZ094OVRNQnMvZkhKb0hoSlNRckozRTdFVmN0L3lsZ0NBVUhqZ3k4bXcr?=
 =?utf-8?B?QXFHTWFnM2dIakVmOVh3a3FBRERZcVlaN3Y1UlphSExEZlJ0c1dWUUtvUGJK?=
 =?utf-8?B?UTRRMlhLZkZSNUFZWWRNWUkxZ3JGTmo3bHhvSG9XQWN5eC9yN0dITElJMDhX?=
 =?utf-8?B?ZHBpbEg4ZklmVHdZbFpjbG5Pcmo1M0lhWXRLcmpUcnpNditBRG9TTzZkekxL?=
 =?utf-8?B?QzRPWlpid2xic1c5aklmRWpZT3dzZDJXUCtuNjdTT08rMUl1cHcrZUliZ1Np?=
 =?utf-8?B?SmJFaCtub1FBb3l4L3JaRC9Xam1JYjltdm1nbFZjZExrZUVIZUhBSVFRcTcz?=
 =?utf-8?B?TTVIUWtBbklBMnM3VFNMSTRCZmMrdlJIaVAzQm5jZXI0L0NzdUJmTUpwNG9x?=
 =?utf-8?B?SXIzMmFXU2ZFREtaMFJ5czAzK1NDT0Zrbys3VXlkVWxTdVJTYURhWEJYS3Ez?=
 =?utf-8?B?d2hCVXhHRnZ3UFNhNytNRjlQNHdWK0J6OHVoN2NzejdQRUs4Y3UzaUZaOTgx?=
 =?utf-8?B?bDUrZ01KMWUwcytEV1l6S0FUcDk2aE1tZlV5UFBsVGg5MnladkhGZXlBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEZmcGpyRmVPNTlUTnRyVGNhcVZGcVhvZVB6Q3BCSXQ2ejVZc1pVVVZFMTVU?=
 =?utf-8?B?cXBmR0ZrMjJqdFRWbDY2L0RLU1VUaWo1K2dIb0JaWDVSS1VJcXRvMkdTZlJy?=
 =?utf-8?B?UGt6cW5IU0NvRHBHajBpdzI2WTVGQ0tFYXFkMkZCcDdHZVJ3U2F3UGdVY1lR?=
 =?utf-8?B?bFNCZTIxVUJwK0pSNHExMjZvQm4xVy9RNFJVaCtVbG1SRE9COUJ3V2R4L0Z3?=
 =?utf-8?B?SEY0TnZUZXBTVXN2SVF2NS94TnhoNElTdlZlS2dIcU15bDF6ZFZnY3EwZGl0?=
 =?utf-8?B?WldqTXRNR2JnaVJHSjhFMVNHbWlaSjY1MVF2c2pKdC80ZmJqRkFPcHFXUENK?=
 =?utf-8?B?cHBJSUVvMXBnSjNJYjZlRG9SOE9ybkNEQ1kya3AwZTRhZ0cxOFJjUHhWUDFU?=
 =?utf-8?B?S1hUYVZmSHYvWjU4U05NdWpsS256QVJPeFRYRXZLcFpPV2pjYjlXb2VXRk54?=
 =?utf-8?B?U3lHbE5pbk5VNjZyVnU0bk9EMmkrTDBYWkQvd3hrQmltMmdGbStBZTU5VDFO?=
 =?utf-8?B?SXk2WGVqeXhRcU95UmJSUmFjZGM1Y0Y0VmxFZFJxeUtLYi9ERnpBME5PY1Mz?=
 =?utf-8?B?TzBFYzJHTEM4aU9ELzB2UzhQZGwzNlpWaGkvWmlhMlpGYW5SNkF4aVNBUit5?=
 =?utf-8?B?MmJTblZ2WDhSQWU2WUV3NHU2Q2crK21PQTNTdStHYjVDdW0vSXd6WFVwR2pE?=
 =?utf-8?B?NEExT2VKaHlXSjRLRDFwRjF3WElTTk1Icnh0VVM4WWhjTTBMMHUzNEh3M3Bo?=
 =?utf-8?B?aDRKYklZSG9hZlVHZDZFM2VMZHF6SngxVCtmQ1NKamJIdk1lNUFmRk16WDZh?=
 =?utf-8?B?N0ZCVXdEcU5WL2tBRGc1cTFCeUNFM001bEdsK2puUzFuZjlLZDZpeVdaZ2FX?=
 =?utf-8?B?QXFUZHR4STdQY0RzUndWMURHd3lUTVdOY0p5RDJESDZmbWNFQnV1ZzJIVkoy?=
 =?utf-8?B?NTFsL0pENElJNU81YnRIYmFGQkNpT2dwVWsyTXcvcWxJUnZDa2JDTnhYNzQ2?=
 =?utf-8?B?Mkk2VkZocHd6UzhwQmtQOHRQY3FUcStCRk5kZ2k4NnpGRmx2ZTV3UlVleWFE?=
 =?utf-8?B?K0g4WmpQQXkrZmdXK2VsUk9yZ05NS09TOEx4THBhV2U4bTVyUEwvQ2hhNi9G?=
 =?utf-8?B?VTFRR01iUGczMzJoSXpJU0N4d2RtU2Z2NnJYRHo4U2JsTWhoTVhJRVV1dEsw?=
 =?utf-8?B?TTBHVDduZEZJbEE1TWl0aHFhYWtYM1pOY2hlWmtxcnJoZWxpRyttcHBHbWRJ?=
 =?utf-8?B?NUlNWTBHVTFqZzhYMkVyaFRjaGpZdXg4L2lFcFk5QlROZDc2YnFGTThrMGlE?=
 =?utf-8?B?RUwwYkN0MzFKbTFzWEdhTW9Pcm1iRTNrTW9EMWxLa1V6UkJhZmxPVHVTVEQ4?=
 =?utf-8?B?T2FKeDljSWFlOU9kb2lFSTBCSkloN1p2OW95UGpHU2NBcG45TDFmTlYyR3Iw?=
 =?utf-8?B?K0wzTGhIZXBydktKM1lLYndaQlFYMzdLUkNXVDFhNFFVRmw3WU82Ung1VUdO?=
 =?utf-8?B?RWlScjBYOVFYOWF5K1RqdUFDRGVsVityajBHU1V1cTBZUGtkVjV6Vk15WENR?=
 =?utf-8?B?eGt2S1FvRVY5eE5aeDBsTFp5WEhTRDhhOHRTbWphanQzdlBNcHlacmw1SElR?=
 =?utf-8?B?d084encwbmNFd2FpMkU4dTBMRytNdUpQRUNIMm1jNEtOZVk2MjFQOUJ3b3lq?=
 =?utf-8?B?UHozSExpWUovV0N6M2ZOL292WkFtemM1ZFU3YlBxQUhxWnNOVUFma1Y0bVor?=
 =?utf-8?B?a1JjMHU2emw1akMvaGVjQVBVOTJTenZCUExmNjBENmNQN3UzZmpRMFNHbjBH?=
 =?utf-8?B?MEwvdkRZWmtpSkRDQUtnbGt2VFdka2w1VnR1THRtdVdvVGRLN1JkNXU4UktD?=
 =?utf-8?B?WmdkSzJkS3FaUm9GenBPZXJRcmhyZXZ2eEYrbnYvNkp6c21Wb3RPVTNQUFkr?=
 =?utf-8?B?QzZ3ZlUrdXlyQ3VuNi8yVGRxUXNJd0JhQUJZTXkrekNNLzFkb1BkVDhlZ1pV?=
 =?utf-8?B?d3hXVndrbUdWZGd1eDVoQUlzeUZLNklUcTduYSsrLzcyZWJmY3g2N3dzc2hp?=
 =?utf-8?B?SktkWFp0OE1ibGpiREp1Z2RvUmdURFFhaU9QR0U3TXpQaTgvTll1ZFdzeUt0?=
 =?utf-8?B?aHBrRUF2cTNpa0VnTlNDbnpJNVhYcmhlaU5aZ09WVnBIUU5HTndLOWZYK1Vy?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb621e1-e9c5-4284-ce82-08dc7aa47ef0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:16:50.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2U1nBtQF0wgFxLKRZIh2SqHtueSr3Py2nKCGFZTXxTJ/EqSMGXtAfCjhXAUijX7wa4hvWaoGn6BsWcDgKprMI6m5G+qtGoRDNppl+6RY/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> When Sub-NUMA (SNC) mode is enabled the legacy monitor reporting files

Sub-NUMA Cluster (SNC)? (I'll stop pointing these out.)

> must report the sum of the data from all of the SNC nodes that share the
> L3 cache that is referenced by the monitor file.
> 
> Resctrl squeezes all the attributes of these files into 32-bits so they
> can be stored in the "priv" field of struct kernfs_node.
> 
> Steal one bit from the "evtid" field (currently 8 bits, but only three
> events supported by Intel) to create a new "sum" field that indicates

This is filesystem code so should surely not be just about what us supported
by Intel.

> this file must sum across SNC nodes. This bit also indicates that the
> domid field is the display_id to match to find which domains must be
> summed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 498c5d240c68..c54ad12ff2b8 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -132,14 +132,19 @@ struct mon_evt {
>   *                     as kernfs private data
>   * @rid:               Resource id associated with the event file
>   * @evtid:             Event id associated with the event file
> - * @domid:             The domain to which the event file belongs
> + * @sum:               Set when event must be summed across multiple
> + *                     domains.
> + * @domid:             When @sum is zero this is the domain to which
> + *                     the event file belongs. When sum is one this

sum -> @sum to be consistent with previous sentence?

> + *                     is the display_id of all domains to be summed

"is the monitoring display scope id shared with other monitoring
domains to be summed"?

>   * @u:                 Name of the bit fields struct
>   */
>  union mon_data_bits {
>  	void *priv;
>  	struct {
>  		unsigned int rid		: 10;
> -		enum resctrl_event_id evtid	: 8;
> +		enum resctrl_event_id evtid	: 7;
> +		unsigned int sum		: 1;
>  		unsigned int domid		: 14;
>  	} u;
>  };

Reinette
