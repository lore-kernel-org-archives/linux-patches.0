Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9CF1F237A
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761193324; cv=fail; b=gdtKrHPEiXleOsaLdanxWl/8LeSbb0725SNSgXbfaXwQWUJJYq5ZBlcf9cc5y158rWjgRLBvzeUjqtxhu1OTKGdGaDRvc/q25SqmLW7EUpEe9X76H7/3ryWume68sd+lifNzqdBmgtFB3HzDFKxShl5Qa1Q253Lo2XQVBYzVRXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761193324; c=relaxed/simple;
	bh=XAZHuRMrpIJqPLSTUiz+46reR+nQTTFVPdkOYDxU10s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nIUMbJ/2xL+r3+EJT1u6VKk+FUwSthEgZT6547dbTQ6jVuX2hjv+Zqs+ww3ZxrSmtzdlPfqMXRW6Pir2XTjK8cyw/YWefAb5GcF9g9mXMQyspckcS8g1DMUB/8kViIK9ERoxozSL0h7ZRAjSxrkW7owVt8HcSey6vdZVfL/58wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dsSoQi+e; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsSoQi+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761193323; x=1792729323;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XAZHuRMrpIJqPLSTUiz+46reR+nQTTFVPdkOYDxU10s=;
  b=dsSoQi+e2GsVR8JdrL7bnD6QofyG3KtfOcrkE2L3knpFsHvh9ECjW5We
   /KnOC6ZGsoyCtG4cbi4KjZUJmraRN6DvSBD+VnRBt0fhr6QjgiHuLDB7y
   7cSmmhBLUxdDvAsj4C39qPhCLMnlOBrCoVhcvbRLkpUE6wPDEyTvDh47e
   kyTL7N5SgEOl2lfl/rSlSe8izWSbpge+7JUUOs4NomrbGbC5wgSJhPPCV
   bkBzOcjyN/qecPfp4H+yxbCvJfxlN/ndsqiLjw2TNXEP+1yZ5YzU/atq8
   MLxwvAUJsiPZKWlcnzlWiamVS24knFZJNHhqZztlUuiBR/Exz2Xml0i+N
   Q==;
X-CSE-ConnectionGUID: xtfPacq9QnOjnrdX/ryGlw==
X-CSE-MsgGUID: 6StNY/O3SLumPf425hPBmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="88818752"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="88818752"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:22:02 -0700
X-CSE-ConnectionGUID: TDwIrUjBTRGV/6YOhJTtfQ==
X-CSE-MsgGUID: fKOODdr2RruDpUB8QTd/xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="188098040"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:22:02 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:22:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:22:01 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PRN85Smd/W6O9bB6HGtL99boffYne5WITxDDPI1LBArtGUYNs3cHrss38WvLoey8XJLGfRbFrV8kOpdVijF6j0YcvnJ8ElIJOWyws/qkr6+d0YoiFp5Zu8ptc6FAWmesX/VonbEn/nwg6Hv2zGpBdOjFnyWNDZDFv71V/wr3hCOdRQG0e1sCMibVT8wQUMBntOHEiqUBNS28uV2RUAWrTU9F/hqYoBYrT8q1EgwklQY+F9Lr42DlW2aVUbgxkVEQQ01xMFgPrqCKqt22SupJaP3sGMCjgxERDSP22NkjcCwpjufiHSRVxUuKr91A+p/O6idJxWG7IsUKW79inUCM5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVm4z01X2pfs3GlztYz4AUabYbiDgZfsC3Ylsj4v8Cc=;
 b=OhXpxgl6WmLSrCvrxgEJv7yxivIFK6ubocBcTZod5VJxH6f6QVFAyQD20Jvq7tOIXiEU7rE4hZzCcBzuca0eHxBxgTdIKMh6zYXQvemECI/XdmMn/u8m96dWWfHh4g1kMxmsvXAJB9bQ5VfcBPxjsV3QzJ9b/3FTiAyqvqlwNkHD+ct09OuxVpgiujIozuDnwLf7hG0JlvbrbwTxDM7QtkFP+eTYBVO008Fmboxiaj35aLfrUffhJqlAbOfQFcLk7CGNBoi2Y0HE72NpBTuazWdbtrGJGRWWJNpM1XV9XAQRv/m328a2yQZ9lmng30P7+6yx4VG+gYuaLpf3+6CwrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB5965.namprd11.prod.outlook.com (2603:10b6:8:70::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:21:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:21:52 +0000
Message-ID: <84c90408-b154-429a-a275-e72adf6acccb@intel.com>
Date: Wed, 22 Oct 2025 21:21:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/31] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:303:b6::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 5550a0d2-68e8-4c87-5464-08de11ebb14f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dEY5NUpNK0VHaDZTWDVVb1BaVlFYTVlVYmtEUm5VaGdpQnRHYWRkUHRTOTk2?=
 =?utf-8?B?dGx1ZlprWUtYN2hqeXV5T1FybjR5RnNFc0V0Rk5QWUdDVDZpUnRPODhYcitN?=
 =?utf-8?B?aiszL09WMFE4a0I4WUNFNkxlVS9TUEtTWjV0MzNLWEpONlNHVDBoSjRHUG1a?=
 =?utf-8?B?UXlMTnVzek5sZkFmNlk1U2pQRVZIa1ZrMnZ4MHEydHVxSlFJZTlzTnQ5V0JD?=
 =?utf-8?B?TnhpTXBNZEt2ZzZ6SE5FMzkxZnFRSWNxcWtzK2hyUnRpUStZaXlzUVd5cENk?=
 =?utf-8?B?ZzZlcGtncjZUd3NCTFExNmhCUnQvN2VyZlU3Sng5TU0rU2tYY0h0QVNCVExr?=
 =?utf-8?B?aCtZOTUreFZPZnpHSVo2b2FObGtCV2VPZWtpMmRSZlNJbDY2OHBlbm9MN3FN?=
 =?utf-8?B?U3RuN3pGYXJ6aDVibFUxd0d5ZTdqdm41aTJaNDBVZ2k0ZitFTkJYT3Rjb3Zt?=
 =?utf-8?B?TE11bi9IdGpoWXNRbUlES09pMmN3QUo1MUc0eGRUNHoyMllaOW1pUXlRYkpH?=
 =?utf-8?B?ZDJCMHZaRitCU3FzSG9idUFrTnFqU2VWR1BoSC9rR2pTQ3Z4NWQzYUNMbURI?=
 =?utf-8?B?ZWV5MDBCQmQxRno1U2k2a21ZQ3IwcFB2VGhxNmREM1FZMTl2VDRzVGJpdkNL?=
 =?utf-8?B?ZVJOM3dUQmcvcDlBdndrdUhoYkZqWFd0QzcwRklWbnZQVmpIL1AwNDhjUUhP?=
 =?utf-8?B?d1ZWTk1yZ2FOcEQzdmNQODJOUUJQNUVBVnZoMTN4VFZUN0FreFM4V3lUZjhq?=
 =?utf-8?B?bTBoS2lUcWIzUDdKZy9BYXBuSCtRblVmeHVQYnV6MDVuNUdHOUxmZ2ZpZ1RD?=
 =?utf-8?B?aTg4WXdPeDBYWkY0b0VnM1FrTzhCYTZidjQzc0Y1bHVUMTZpdGNzR09pL1Br?=
 =?utf-8?B?bEFQS0JuVHcwSVViSGZjVGpjM2QwbmZ6bmtHMCtobjZMclI3R29yUllkQyt2?=
 =?utf-8?B?bktGdWh0RGhnRzZmWXlyU3NlTDMrUWZ0TVBpTlIzRllWemdlNCtGK2FBcFVH?=
 =?utf-8?B?aFcyRjNUTnA4TGc5VHRrd05Ya1FTZVlacUtSVTlMTXZjRVVqcHVUOFlwZjVL?=
 =?utf-8?B?TmNkbVl3RDhQcjhENVVPOU96b1Z1V09UN0RjMnNVcmNidGNBZ2MyZHlaNWF3?=
 =?utf-8?B?RmpRaUZzS3p4Q0RSaklWVjNQTXlEVXZKVnhpVjl5WlpkTnoxalMzRk13QTBT?=
 =?utf-8?B?QXAwekI0Sy9KTDRWSFhBUjIvMVBqblVMRmZYU3VZWG1zTzdyTFRxblByWS82?=
 =?utf-8?B?RzlyS1JkTHlQMG96WmRvUWJnSFVvckNiT3FWOUtnY3hvUGllcmc2MlNhVzBG?=
 =?utf-8?B?WGhwMVpRb281dzhCRUVmem45ZG1ZKy9pYjdyOXJEVTFIdFBzUDNoUktaL3VW?=
 =?utf-8?B?bTlPT2xoRWhZaGRvL2ZxS29nNHJ3MThKZHcrUzBLemhQSFFVSGNETTZVTHVV?=
 =?utf-8?B?T2FMejdrMUVlci9hRXFLRnBLRjNVWWFzbGFwOE1CT2xDaUhNL21ERjhTZjJC?=
 =?utf-8?B?bUFBTjZ1ODFGalFsU1AwSklhd2dtNXY1UHh6bGFNT1h0ek5GVHNINEZEaisv?=
 =?utf-8?B?dDFSNmU1Q3lkMUZpMzZGQjhWOXhuYUp4NkZhWm9IRU5RWUJlZnF1Q1cyK2VW?=
 =?utf-8?B?cDRXUFJHM0tNMEsrQUNBUTRCN2lxUlg3MitRVnJQdVlnK1FEbDJIMitSY1Ba?=
 =?utf-8?B?VExNY3FGMUtRV2tHTUNNQ0hqT3JtWHpWM1I2S083dzUrazBKaGRFcHIyejU1?=
 =?utf-8?B?TzJ3akZibU9ydW4xRmJ6b0xUUEpnbDQxL1l5N2JoOFV6L1pYaVRwaWVWWTdS?=
 =?utf-8?B?aVovVm1uRU5nb0F2ZWFPQThuS1FHSyt4YU1GTDlWYVo0N2lOK0x4RGhxTVFa?=
 =?utf-8?B?ZmdzbEl4NjJCZlJBV2hiU3lQSkxsOTRnMXJiMUtSaHFaVDFPYWEvU1YzMTI0?=
 =?utf-8?Q?1jSQYM7sEauWc8fcQootwdR703UONjIM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnJLOElORS9mbGd3blNVeUl0WllKSVBaZVd1cjUvalJZOERIMlJpTjA5bEcv?=
 =?utf-8?B?ODBySXhGeG1BdlNkbEYrUDdzaEE3UXpiN2Z4a2VVQjFQRW1EcE00OEJCMk02?=
 =?utf-8?B?cXBQT2RqZnU2dVM5S2w3eCt2WUI4dkFYck13ZnduNXNwS2pQYklabmdpbmNs?=
 =?utf-8?B?QmpDL3kxVlJXN0V5ZEtyai9WMHNkb3JpYkQvdVNkazZBdUJWQXVGa1luTVkr?=
 =?utf-8?B?TklMQm8wdVpKWTdqUEtUWlpjWlNnQzB4WjE1MHNKQ25uOVd4cU93U1NLQWxB?=
 =?utf-8?B?YWFWd2ZkMkgvT3dvWGdsalJWWURycTE0NTNaSkh1dUNYOVJUMkpJNWV2ZjR1?=
 =?utf-8?B?ZjRlMWxoU3V5ZmlZRy80Vis5cjMrempVTWVMdGNRYURDNkM5M1ppR1NQd0ti?=
 =?utf-8?B?V2xqdHNBdER5UTRsb2tiMXA0a1lCZkRzLzM5eEFRbXBFZTB5QWdaaVhDcVl6?=
 =?utf-8?B?cC9vWk1lVGtWc2F1WENpSHR2RU1yQ2gvbXp2Y1paV1VISysyeDFLTm1QRXBx?=
 =?utf-8?B?Wng0Y3ZYd1dnU2RPMzdjdDh2cXZkUVVJeFQ0eFJpTXp1K2g1NlpSSnZkV0ph?=
 =?utf-8?B?UUJiYi9qOFhpNU5MWUJ4ekpicCt0dkdDT1loOVdNNjI5YlpOYXkrTnZuaHFz?=
 =?utf-8?B?eU0vMG5BdE5vSFZSR0RKWWxDOE9VZWIwZVVHQmtLcWx1ZEJFMDY2ZmlpWlJO?=
 =?utf-8?B?V1NMSVlsUUR0R3lMRkE0UHBWalZZMkpqUUpMd1VobS9ZVXBBeFI4YzJ6ODU5?=
 =?utf-8?B?VXZmRTVyOE5YWXpmM0hzUXFTZFFFelhRNUhzd2N1TEw4V0xyNGV5bktoTHJR?=
 =?utf-8?B?bmFyUHh5QndsNmdVU3phWHN5WVdsaENaUWtQdGIzcmtqNEc5VCtaOENJdWVB?=
 =?utf-8?B?T3Nzanh3Q3B4K3NzV29yVlp4cEtjYy9pSEdXNVJyQW1MdEplU2NVTGtjTFVy?=
 =?utf-8?B?VVpOVGhXQkMyQ1czc2NZTFhxa1JIYlJtdmFwTXlkYzBtVjNqZkJvOGZDNGwv?=
 =?utf-8?B?WWhYdkV2YVA2TjlWRnJlOWxKVnhDV0gxcndhRmN3VXk1L0Z5SVlzM1RacjR3?=
 =?utf-8?B?RzZVTEJVQzhRaVRvSDJ6dFJING11NTJHelhCVzBQZHdvc1NVclZHaURNaDcv?=
 =?utf-8?B?VXdNQ3NIOXQ2bTVxU0Q4QVROYWNVaGlJUWtJRGVPYjhqN2h6aHVsVFdOQVlU?=
 =?utf-8?B?UzF4L2lOZzJkcm8zMkY1aGNrNDNzY3FWQVMweldkbHZQelF2ZzZXd3ZoeG1S?=
 =?utf-8?B?R0ZNc0d0ZjB2aE5XZlFSQU83Sjc0TnFqdXovZHpTaEZ5RjZmejZGdWJXWjZ5?=
 =?utf-8?B?NHUvNDdwMkJuT01EQVhjSjFvc0ttcmtJTURidUJqSm9JeVlyK1NEcm5JdGsz?=
 =?utf-8?B?MFJQNmVNNHI5ZXNhRXg3TzhaMS95TW9Sc3ViYUJXcS90VXNuVGZtNzJzd1BJ?=
 =?utf-8?B?aHRCdWJkVHllQVBGZjV2MjZTY2JtU0RtSTlRcmhYTU1TUk1oRVRSS3RuWllM?=
 =?utf-8?B?RXk2UmJSSVVDS1JXbHVGTnRFcEtkeVh3UDB3eUdZL3l6TG9BNG5DY2lYQzR3?=
 =?utf-8?B?ZVVwaVR2RUNmMmZTVXIzRE5hRTJaUXV0a3kxa3Q5QlFOcjRBN1A2dVM5VHBU?=
 =?utf-8?B?c2kvcWVvTERaL25sbTdyQnRkTnBrMmR3UzljUmNhTXRESjQwekQ3dm83eTJI?=
 =?utf-8?B?c3BQOW1kL29lWVhyeEhIeVVpQlpMRzZ3bXg2bzlYdkVzTDRUUEt5U05nZVJx?=
 =?utf-8?B?Ukh5OGdVTE9HRzdFTFN0RXNhQStFMHFBZ0k4RzhkTGY4cjRVQ1hmdWxHcnZT?=
 =?utf-8?B?cDM5c2JHOVlyNjVmYnVQak1HU3BSa3ptZE5qZ1hsR2hINkJIdjUyRmx6dXJE?=
 =?utf-8?B?cDNFK3R3T25KbW0wMUpyaSt5N281cjkyUTZLSEU0Tmw5TFE4VnREb0dPRGtH?=
 =?utf-8?B?R2c5QnhQblYvN1JKSzVmVXl2akwzMmJkQ2xqV3MrWTVvOHFscm80eUgzeFdG?=
 =?utf-8?B?MGR4SlBJS1hwejcwUXBWUnFWSnZIdFZINXExcjBWbTRjU2Jtc3h1a2FGRXJj?=
 =?utf-8?B?ei9tOEdncUhVeDVQVU0rUWUyOExiNm5iS3EyeU0xUnM4TWVRWkNnampsOVVk?=
 =?utf-8?B?NUcvamo0N2UvWlQrVjI5QzJYZWdNekpDQ3UrVVZ3Q1BvY3NraGNuZTNVenho?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5550a0d2-68e8-4c87-5464-08de11ebb14f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:21:52.4085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQUlar62s9ZQooLCw1vEFyyBWV4M3OBzsAUVSql7tG4ECuQkEi36eVemR7Uk8KQqMPsm99/HEJyGRAk2hhmvqKN1fhluXcZJlnz+YCBbpWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5965
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> With the arrival of monitor events tied to new domains associated with
> a different resource it would be clearer if the L3 resource specific
> functions are more accurately named.
> 
> Rename three groups of functions:
> 
> Functions that allocate/free architecture per-RMID MBM state information:
> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID MBM state information:
> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Initialization/exit:
> rdt_get_mon_l3_config()		-> rdt_get_l3_mon_config()
> resctrl_mon_resource_init()	-> resctrl_l3_mon_resource_init()
> resctrl_mon_resource_exit()	-> resctrl_l3_mon_resource_exit()
> 
> Fixed kerneldoc "Return:" for l3_mon_domain_mbm_alloc(),

Please always use imperative tone, be clear what problem is being fixed,
and avoid descriptions that can be seen from the patch self.

Consider, for example:
"Ensure kernel-doc descriptions of these functions' return values are
 present and correctly formatted."

> @@ -396,11 +396,13 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
>  }
>  
>  /**
> - * arch_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
> + * l3_mon_domain_mbm_alloc() - Allocate arch private storage for the MBM counters
>   * @num_rmid:	The size of the MBM counter array
>   * @hw_dom:	The domain that owns the allocated arrays
> + *
> + * Return:	%0 for success; Error code otherwise.

While using % to format a constant is correct kernel-doc syntax it is not consistent
with how resctrl formats these statements. Please rather keep the addition consistent
with rest of resctrl. Since only -ENOMEM is possible this can also be made consistent
with other changes in this regard:
	Return: 0 for success, or -ENOMEM.

>   */
> -static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
> +static int l3_mon_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_l3_mon_domain *hw_dom)
>  {
>  	size_t tsize = sizeof(*hw_dom->arch_mbm_states[0]);
>  	enum resctrl_event_id eventid;

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 69b6aa31b986..26e2ecbddb5c 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -1754,7 +1754,7 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
>  }
>  
>  /**
> - * resctrl_mon_resource_init() - Initialise global monitoring structures.
> + * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
>   *
>   * Allocate and initialise global monitor resources that do not belong to a
>   * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
> @@ -1763,9 +1763,9 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
>   * Resctrl's cpuhp callbacks may be called before this point to bring a domain
>   * online.
>   *
> - * Returns 0 for success, or -ENOMEM.
> + * Return: %0 for success; -ENOMEM otherwise.
>   */

The only actual fix is to add a ":", no? The rest are style changes that (a) diverge from the rest of
resctrl and (b) create inconsistency with itself since % is used for prefix of the 0 constant but not
as prefix for -ENOMEM. What is motivation for the style changes?

> -int resctrl_mon_resource_init(void)
> +int resctrl_l3_mon_resource_init(void)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>  	int ret;

...

> @@ -4249,11 +4249,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>   * Called when the first CPU of a domain comes online, regardless of whether
>   * the filesystem is mounted.
>   * During boot this may be called before global allocations have been made by
> - * resctrl_mon_resource_init().
> + * resctrl_l3_mon_resource_init().
>   *
> - * Returns 0 for success, or -ENOMEM.
> + * Return: %0 for success; -ENOMEM otherwise.

same here.

>   */
> -static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
> +static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	size_t tsize = sizeof(*d->mbm_states[0]);

Reinette
