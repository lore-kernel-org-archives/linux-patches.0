Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7859959155
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 17:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989842; cv=fail; b=V/rIS9Fz/Rqd0T2wt1ghxKyE8mp4lKsdTI6uZrN5qTR+HxffviAb0AErWD4dvJT9xJDtT9o56fWsz9J4uxjM6U++z3ZjJ45E4oUYhGO5jhuv3Ev0u2EQhVjpwrRUPO6NyV3lBjoBxpAVfSTDN3R/NNnV2zVq0b3pB7y1hKUSD2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989842; c=relaxed/simple;
	bh=kCN4DYri50//LCDViPt3ydAL/XCLrBdo53uF3NeLRb4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tzNIiifjigHSGj58OeN5zkEanty7+ArCaiBrurUTRfd4OXCFqp11mNga7SaNNPeJiemELMdR1xrr03xmEsM4vbmkuqjuGTEw25TpXkWgW+c+Bkwr1MMD7oxvY3PQTGs29RM1U+YwdYtnc0Wo5AR8+hUVhbQsSkQhzwlnenfzsKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XGLqQpnn; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XGLqQpnn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718989839; x=1750525839;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kCN4DYri50//LCDViPt3ydAL/XCLrBdo53uF3NeLRb4=;
  b=XGLqQpnnAxYoKhkEp2CeQWm2ARyo3Ubz8sn+EOlmwopwDuOSBDuaqELO
   6iXqmtBD6krSDbPgbHlTk4i7r6kVuYP+8ljCayPtr+L635BhL5zB0RakC
   A1Vwn1CPeY+NXWET6LmhqZUMf+iDiYihn+SP/cqb7jFE+vRlwL4hbZFNk
   WwTV2IgtwdMYuY4iLpMlu7l2CX5lHS1Nk/hQN0tPUTL1HTx+4LrI/1PtO
   x3f4cnfoTJITWdCxmpe757T4hxCbOiZL+TBvyVUJtO1ltKm4UzesGfriL
   PZ44sRrx4ISftAMwAaK9aINGGQfqhBmxWZxnUaJSBW8D64u93CihBOokl
   Q==;
X-CSE-ConnectionGUID: y0+95VGSR1Oaz6Ophu1iVg==
X-CSE-MsgGUID: y1gMpaQcQnqOUBewm0VZvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="41438901"
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="41438901"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 10:10:39 -0700
X-CSE-ConnectionGUID: IwJJZvYWTUOe1o4UT++Jzg==
X-CSE-MsgGUID: W9SWX3vvSp2hvSKSbW7Aog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,255,1712646000"; 
   d="scan'208";a="47566852"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jun 2024 10:10:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 10:10:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 10:10:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 10:10:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 10:10:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cR9SXHf0tPUU87lifH+w3zjei0LVaYtZcN1/nSYg6xyx4L61WAPL/IxKQouqXbTnSVQIa6OsoHVXml5b0YtlAHhy/GgsIQhpAVmny84aXhE3G/sAYl3Cih51dbwl1O38te4RKKkZAFhCsxvk66l3EJQVu9XOdSp9O9F7P1RqZYDtE08/N/Fvv51zH84Lce49u7qjNVF/epGx8ZKtf0db8W3ZgDpczuIdo4LwltwRVplGpo3SKmYVGETgOTX/Sp4gQd30aAkunyztqFOFP8z6OrokSNcBwqwMvp8kA/KjMwCMQkuPbBuDo4r0gIlqqwYcXsOm7tUs+YwJADlWdLPGXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbJd8VpZJuazD1B0p+qTAvsjDlJcAcjgkA/mjUp9wNU=;
 b=d3vAJ8lbtDlka0yhC+gxQIjRf5ANNNxhu+udzpyfOA3yNXVW5Cbtm1+IWVxxgdoOB0PPUqekWrEBmyUOPpqii+0X81JiTYoT0Kix4m+gIS4XW/y5edfmqINE8a9jnzd2Ebl+B7HwhGWgHQb7YX6bMhFWHcOU8OMW5kfF0dmNj64cWZFizgsiu3x8pjrJx3AoXraaQfF/z5D15vPQcgCvwlgxIQxIrLN6e2FDAJ4t8WBTKfv8laVZyBwlbsCtuBp1br332dcVo4BkP3kvSydYrOXIfok5nJLIg6aQ7GOp10YftjG4jKmORT3WVdJrojt7d/Q3SQoxdHuDJzUCeVqu5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 17:10:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 17:10:29 +0000
Message-ID: <2e083f94-d982-412f-b212-1d520d7743c5@intel.com>
Date: Fri, 21 Jun 2024 10:10:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-10-tony.luck@intel.com>
 <1bba8391-6ee3-48aa-935f-b9c08bee049b@intel.com>
 <SJ1PR11MB6083E7C6C3FB2345A2495480FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <cd5c42db-2dea-4a01-bf02-b4316b0ba11d@intel.com>
 <SJ1PR11MB6083DDC10766D10326BE7D6CFCC92@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB6083DDC10766D10326BE7D6CFCC92@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0349.namprd04.prod.outlook.com
 (2603:10b6:303:8a::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV8PR11MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: ce33607b-44ff-473c-e52e-08dc92150d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011|921017;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SktvUzFvSklJTWRaRU43SjBINytXYWhOdnRIM1I2UmhVUThnR2lLZXhkdUU4?=
 =?utf-8?B?ajJjWmRwNk5tZ1JLQVFmUFJwUkdQN29vMkJWVVdxWTVkV2xVOXF2S2JPZ3ZM?=
 =?utf-8?B?dGxST1pBaXlTMFZ3MnNHMG1xSGZZbFA0YjhCMWlCMXpManhzaWx5TGpXUnlX?=
 =?utf-8?B?Y3BWblJ3WkxTbTRscVdSZml2MWlXdHRsaFE5RDRBRUM5Z1k5MVU3d3B0M293?=
 =?utf-8?B?M044SUdYZkhiaGF3ZktTOEtGWjltZko2ZEJidElFWVJVR005em5aWGpQeUdi?=
 =?utf-8?B?SzFOKzk3Sy9qUHd2S0JyRmNTNjdtQnowWUxpTkc3bmpKcGdpcGV1c1EwOWZU?=
 =?utf-8?B?Y3VEV3FjczNpcThjcGdQNy9ka3dNTnFqSitNQkJTM0pxcjdRRldVd1ZUTHFV?=
 =?utf-8?B?UFUzY1QvM2xSYnFjSngzbENhUlVrTFNySkRKWkx0TDBZZDdtcEd1eEpjZmxl?=
 =?utf-8?B?NGZWRkFTenNGZXNpeVdYWE9RRk1nb0JiTStjRndGSFF4WHBmNE56MExzSGV5?=
 =?utf-8?B?UFJpZnhlcUN3OTJLT2ZCYU9zRzlhM3Rya3RSYmp6cXUyOCt0WEd1MENjUjZ2?=
 =?utf-8?B?dWdJVVZhTnNPdm1wTlZOL0Y4RlRaUzMzeHFyWXo2UGRSN1J1Z1lZTnEwZEVs?=
 =?utf-8?B?cC91NTU0enIvWnYvUVNsTDJHemx1ejRnTStwOUdVZlZHRG5MN2VHWXBLNmdv?=
 =?utf-8?B?bjRXaG9ocXRTWmZBQ0dpcVRZQTQ5UDFQWVpOdTVvR1hZc1Z3YzA2bnYrUFB1?=
 =?utf-8?B?VjRIbnAvb0RDWlNNTDNhVkJYR0M5ZXRuSnZQb2VOcGNXbHYwM1NxSVRkQ2k4?=
 =?utf-8?B?eHkyanRseWl2ZndpZUZXTFFiakwxa3RiNUlGZzNUWS9iNkMveGNoL3NXaFh2?=
 =?utf-8?B?NzRuaFUrTEZRVHBMNmZTdzUvYzFaZ2hMd1lzQVpTWEpmZklmMk42ZUdNUUJX?=
 =?utf-8?B?cGhDZ09rQzdrWGhzWkhhSVRUeDRTaW5kWk9wZm5xakUxT0FvYnl6SWJXNnh6?=
 =?utf-8?B?WHBWckl2VDViUWRHTUxRTFRibmJZdHVnWVEvNXJxZHMxd1Z3UStoK1cyRFdL?=
 =?utf-8?B?Z0FiZjNzampxZ0ZwWGlOYk1TUUxLOXArcFc3RUZCSi9kbTViYmlTTzNxQmN5?=
 =?utf-8?B?OEZkb3pmT0pld2ZkSlpNUndYcnYrNVViOGZ6SGxHbEpadmpkNmJCR01TdVJ6?=
 =?utf-8?B?UC9ITTlXR1I4THZod3NwbGk2QlhGQU96blk2azhVTnNDY093ZlNHUEVlR0ha?=
 =?utf-8?B?T0Yyd0dSM01xZUh6S2k3TmhodE9aeUlkWUppaDV3VlpQVnlsdXVRUGhBSFlM?=
 =?utf-8?B?N2ZPeEZxenNoRnVNbGNRUUpsbnp5KzVNWXp6b3UrUWdiZWlNWS9SQ0ZsZUZm?=
 =?utf-8?B?ZGExWUdGSmFqV0FrUUpOcTRpU3FjcFJ1S0ZuME5zRzJnOXdOQ0txT09KRWxx?=
 =?utf-8?B?NGtMS25Id0QzYk1oZ0pQaXFJREEwcnc3L3FpNm04d2hXZXMzMU41bnhFR21i?=
 =?utf-8?B?M2ZXNDNYaXFtYm5FdklZNG8ycTBMbDUxYzJ0S1FudjlZRVd6d29uajBaam1p?=
 =?utf-8?B?RFdWNmlnUmF1RlJiVFBBZWkrVC8vRi9NZEF4R2tNdmRGakVvbkNUZDFMek90?=
 =?utf-8?B?OXNvOVlIcjlETFpkSTRrcFR3d1oyK3VCcTZHWTBuVVY4a2N2NnorTXR0Q24r?=
 =?utf-8?B?OXBpMXQ2cU9RdTY4WE1DdmdCRmwyRGs0d3ZjZlRQZjNiQVdnL2pLTEJSMGlV?=
 =?utf-8?B?eVZpdEhUMis5VkRlSXo1Tm1SWTNPOHVmbGpYa1J0YXhjRGloQ09GRDBlLzh4?=
 =?utf-8?Q?0uFsYM2/L5j9u0v6WMhBHnhJuwm53yPrDYj+I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0NiNGxJT3NXZG1WQm92bkd5c1drWFBhYUV6dFNyaXF4SU45b0luSk5qTFJE?=
 =?utf-8?B?b1JZZUxxYjNXaWhwc0t1OTV4OHFaakU0ME1RMG4vN1FvVGNwZk1wNnM2OE5i?=
 =?utf-8?B?SFBWeGdITmZKMytUVUwxNGFkN0YwNGRUZm41OEx3a2hDOU9CdzJXSlpqZU1J?=
 =?utf-8?B?eUFGbUVGV2I4OUdJcytBQ1ZzQ25ERmlyTTBmMEZmZlhEYkZ5QWU1eGFEaXhy?=
 =?utf-8?B?bUJ2Z0VXb3o1bWlKaFcvcEhhd3lGT1BzaElRSFU0eS9hMmRVeFl5bnNiOUdq?=
 =?utf-8?B?d1UxOWxvVXV4dlRTbm5nSTNFMnZTTi9qM2tIZHdlbjJSb1hGd1dnYWRQK1VI?=
 =?utf-8?B?bTV2MXY4bHBES1FvczE4U3JxRExCaHBvZGJ0cjRnd0FQNFcwWFBidUJINTVD?=
 =?utf-8?B?R3BsYmZwQkV0TUdsNXhqb0NBWmYzQjdDbUVONUtkSHFDSTA5RlZOSmhQdm5z?=
 =?utf-8?B?ODlGcXpaQnpBc0piTlVabHl5V252THQwVWhNUTdEQmZSSnNCVkZhZ3M0L3pQ?=
 =?utf-8?B?Nm5SMUo5MUFteFlRZDg0M1g1ZWVJamVzQXBtYzEraStLVjYrR0R3R3RWSmd3?=
 =?utf-8?B?dEd4Tmp1U00xNXZJY1NHN3pZeVhFNUxyN01SVlRDT3YrUFg0S3pid0NwR1g3?=
 =?utf-8?B?ejE1d0N2WjZjclUwMmx0RTQ1NnEwcDRsMHVUZ01nRTNaSTBhblVqa2N5STV3?=
 =?utf-8?B?Tk85UFVVOHd6a3ZjM3NIa3NJTXhHamlHdWVmTCsyeGZwckV4US9KeVMrYktP?=
 =?utf-8?B?TGdtRGd1SURiVjZUc082cWFJVGNpTTBIekh6UmorUFJ3U2xLc0tSeVd4QUZE?=
 =?utf-8?B?MTNMaG1zbW5GbW0vdFVIbXZWR2Q1aVZkUVhid0xnR3V5Ynd0VDJ6ejluMUVz?=
 =?utf-8?B?bm52cnF6ek1CamcvVGN4MHZWVmRjUGNJdTNMMjBxSkhtdncrWHQ1OXpYZUpT?=
 =?utf-8?B?dUtqck9YL3F4OFRidllzaHJ0bkFlUTkwTVVUWlVFMFIzNFZRZWU0MUtQdy9l?=
 =?utf-8?B?RHJDNkN4TVcvajVsajFmMVVxM2xEcFZQZHV2SGU1enpMMVM4ZVhGVy9Jc1VI?=
 =?utf-8?B?L0phNHB5aDQ2TkhiQ3NPUW15M1gvcmcyUXBCd0JGMmhadlNTaHV0dVdxWFdt?=
 =?utf-8?B?cUF0RXJsWm5nMUcraFpXMWhPUWlWNGlEQ0h5Qitxa29Jbi9xZHgxWXA2elBh?=
 =?utf-8?B?a2tOSGU2K1o3anhvbWkyYzllRzUzRGUvZU9OUXB5amo3L3JyVTBJWHlnTzM3?=
 =?utf-8?B?V3RHc1VMa1hRb2lDZk1YV2ExZFk1anE5cWdhWnNkS3R2RFU0RWNOTnFLa2JT?=
 =?utf-8?B?VDR5eFc3QWxkSjdSNldUWGVNa0JBd3VNSExPbkNkMTRxaFpsWlhEUHg2RTdw?=
 =?utf-8?B?YUNERlY1SlJ4ODVPNEJ5ZW4zVm1YVDlTbnBiWXltZnR6UWhlUDExUnI5T0Iw?=
 =?utf-8?B?OW94TFFmalNROVkrc0JveE9ueDJQdUpNZThCd05iU2JGTzNNazdZSjhMd0JO?=
 =?utf-8?B?TDNwcFFJVkxKZ09ZU0hZZm1XQUNYRmZiZFdnTVgwV3dVNTdaampqUVBhdUI1?=
 =?utf-8?B?VVBpaC9SNCtaWXBuNHZFUEhLT2ltSzBLMCsxdGc5ZDJjQVBoL3ZUdDJyRVBm?=
 =?utf-8?B?dHE3RlIvajRNOWx1MzRBY0JMdy9YNVFJTGZpQ0FJY2V2TjBaYnJlTTd5bXVn?=
 =?utf-8?B?MUJ1OFRQTm5MYnFyN0JGYlRwcXVsVm5OdHFPN0pxQjVnS0IycDdUZ2x4Rmg4?=
 =?utf-8?B?Tld3cjFVZ3N2bkNxZmt4ZUV3MjVDcVRxU1dJSE5VdEY1RVNXaDJreWxrclRh?=
 =?utf-8?B?T3dIbUNuMjhzanhFUnFyTTMyNndoR3YrNHc5YUtXeDZ4OGNCZUxpOTV1eE5Y?=
 =?utf-8?B?TnZsdFdXV1VGdzR3aGJuU2lQYTYwLzFiSGJPOUpEZFBpblRBTXlCMnplbE42?=
 =?utf-8?B?OWNmU2R3QWs5WVBqSGtyM0RuMkt0VXZEKzNPejVNVjl6a2ZpdGsxMUxZU3hp?=
 =?utf-8?B?WFhIcVJadHFDY0xOYlQ3Q0s1aG0zaExBb3JFRU05ZVo3V2pxaEtFQ1h2VGlB?=
 =?utf-8?B?VWVTRXY5UFM5cFBBZ29lYm5TWUNOQzh0MUNlM3dnbHk5SDg3Mk9lUU1mdXRl?=
 =?utf-8?B?SWpPWnlybFVDT0VlcHRxWDlUTnJUTWNIbTYxNGlhQ1dPTVRQU3hJWFdoZXRi?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce33607b-44ff-473c-e52e-08dc92150d20
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 17:10:29.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ymy6jPiOaVLK3J2ORXC0nvFjfItdeWJvhmXezf9PVJ5ReurwxSvQ7RhRriUgMeQS9P+T/yUAGgGE8hLR4b7NBUJK6crgwhMbGK+hOTn0ucU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8724
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 9:07 AM, Luck, Tony wrote:
>> I do not think there is a need to introduce new syntax. It will be easiest
>> to just have all sentences end with a period. The benefit of this is that it
>> encourages useful full sentence descriptions. For example, below is a _draft_ of
>> such a description. Please note that I wrote it quickly and hope it will be improved
>> (and corrected!). The goal of it being here is to give ideas on how this kerneldoc
>> can be written to be useful and consistent.
>>
>> /**
>>    * struct rmid_read - Data passed across smp_call*() to read event count
> 
> Should this end with a period too?  In the resctrl code a few cases use ".",
> most don't. So no period matches resctrl style. But the example in
> Documentation/doc-guide/kernel-doc.rst does end with a period.

Having period will be ideal but since that does not match existing style it may
look out of place. I thus do not have strong opinion here.

> 
>>    * @rgrp:  Resource group for which the counter is being read. If it is a parent
>>    *      resource group then its event count is summed with the count from all
>>    *      its child resource groups.
>>    * @r:          Resource describing the properties of the event being read.
>>    * @d:          Domain that the counter should be read from. If NULL then sum all
>>    *      domains in @r sharing L3 @ci.id
>>    * @evtid: Which monitor event to read.
>>    * @first: Initialize MBM counter when true.
>>    * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
>>    * @err:   Error encountered when reading counter.
>>    * @val:   Returned value of event counter. If @rgrp is a parent resource group,
>>    *      @val contains the sum of event counts from its child resource groups.

contains -> includes (to indicate it contains the count from parent as well as children)

>>    *      If @d is NULL, @val contains the sum of all domains in @r sharing @ci.id,
>>    *      (summed across child resource groups if @rgrp is a parent resource group).
>>    * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
>>    */
> 
> This all looks good to me.  Since you have supplied 99% of the content for this
> patch in the series I should assign authorship to you (which requires your
> Signed-off-by tag). Is that OK? Should I split into two parts? First to add the
> kerneldoc (by you). Second to add the new field (by me).

No need to split the patch. You can keep authorship. You are welcome to add:

Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

