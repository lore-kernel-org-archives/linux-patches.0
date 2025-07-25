Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40CF25A645
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486576; cv=fail; b=lOE1Cl9xiL/k2Att2LsT4sPkoXN4t0l5xkcvOjfmh79ZJl9tNuHALc7ygKTQsL17BSzAh57Y2VSZG7DI/zv2SoYTBykzXx2UrBUK0YqrNC2KxahPeW5EFMOnQw/i7hvmz2vYYaUx9IrlVSFccMXdyA7JKjG3980jAJIOXdzFGqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486576; c=relaxed/simple;
	bh=A/3fLvFCvrhmKw6BnYJx2B8h6gM5vic1gb1i66W+km0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sr0r9m05gRB3FYSppnnBoONJGKxYrkf/Ddrxpdekac1RWXjWlAapB4JRZZoO4OlYKZwyLChL8XBlmmAVqTXBipdG/aBtJHEZTAmop0VC22Y7cMu2iKvN5RBPwuajSeyydvKK7LSmkE6V3dajORehmyygEqwK/eT104Cj1DOUl0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WiByWIQi; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WiByWIQi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486574; x=1785022574;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A/3fLvFCvrhmKw6BnYJx2B8h6gM5vic1gb1i66W+km0=;
  b=WiByWIQibEfn8HuuLx4BWses9Iu2KG/Ylf5gOv/p4fAEFysO83tv86Mx
   xxDCV0OkhmB0MzQL7sMqum5qeASmf18MfRaOFbKdiumPRKncc5hEDMSid
   NtXIa87mbiZKzDI4d6VMrZkTX3JKEufpTNfjPI3GC0293PMPDQKcVQCj0
   RLA0PGdjJD6CvQOlLz5rilRrICn1mBGTvM6vwaq7bwHcJbJmlqK/hE2ed
   KTdIgR6nvHJ2O5BDLt36HfgmvsQU6p962EGSCB2xuVQ8M55WlPHB68hbs
   E0XnmmYYOffHJJNN7Hl8CdvrSHWqEXADUqqaT40S441nxbX3rQ9L3NRTp
   Q==;
X-CSE-ConnectionGUID: jpxmat2yRuG+MxBruCNNHg==
X-CSE-MsgGUID: tZF3JI8bTX6VTpKq20gU3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55909886"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55909886"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:36:14 -0700
X-CSE-ConnectionGUID: /EytojNpSRKYBnKp/moYmw==
X-CSE-MsgGUID: 4UEke7kMS2yCDOEhv1zBqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160517515"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:36:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:36:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:36:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:36:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYzjYk9IHkmWhknzuQTW8U10cj7XBIyxvS3f7aFuIwWwW+UNQ6T3ggEu5heGBsp7bdHA6VxK7LuEeXcReFM10jLqNqxE+S/4Ad0MozHHHfxOmsFzHMngnbHYHIMa9k9Vnjr/Q0gArFzjKZM1z49fyorkj20uKj6VucuyWj8Z9KCesqST1sHNwPPevzU/hK3x4J/DrcqoH7TM0y6ZEgjR0uhKpa1VTD7KG9NdYPKlR5dUBVeNOpOxpfjgTRs6gbaLHLf81TE1BQzRddXJLexigIiuw4gpo/VXrJSBcz7dMaYpvzTa1bRzdeUVJrcblJJab+uDsG8h2aGNXlJc9BYVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxVkQoVSrzketj27og6russ/iFUfNFcZZz9d5E5UHVU=;
 b=dnN9XrM8j4ZGGKktNXizX3le3IpHAHxqkxjXKczrvdDV+9vaqKsGh81cvjIU3YL8iRyfIzE/0iZGX5aGEnTFdjEmXAWvqNmpm319DEvKMk/p5dTw8Ml6t2ikyWxw5w3upSrVlNuL+CP/LHxnbvR7nDi2XelNvCfG4Y0lMKxFQnlx7fEu8I84tIMoSn3WKpPeYMXxfLPZOvp++VshN2ApOeEWj0w4k67eDoIFgdU1NNrP7Ey110P7YeB+zhGCWpQHmHha26e3zKsGqDbNKmDNMY1+sMxyn9mi+ubGz1jRMeki8/tHlFqzfcfjdDNed0Zhqg0+6yAk509gnDtYJUz1jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 23:35:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:35:38 +0000
Message-ID: <66018504-0acf-4c8a-a467-c89c9088be61@intel.com>
Date: Fri, 25 Jul 2025 16:35:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/31] x86,fs/resctrl: Add an architectural hook called
 for each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0313.namprd03.prod.outlook.com
 (2603:10b6:303:dd::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN6PR11MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: fb18029b-2d7e-4eff-44e3-08ddcbd3f5b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkVia0lMOGZTSS9XbS9TM1dPVkdYSncwUldCYjRsOUZQRHFseUkwbDBBZG5D?=
 =?utf-8?B?V3pMU01qdGZjNk9BeW5qUUlBTUZjbXRjdE8xNk5sME9KVEpkQkdEOWtFZjAy?=
 =?utf-8?B?a2xrUlN4eWlPNEZZOWU3SEZRTExsZWFZTXJjTURiK0h1dnJQTXNYZ0Y2cWJ0?=
 =?utf-8?B?LytzdmRKeDFlay9lT0dDdnEvWG5EZkp2Rmp2NUV0U3diSHRDclMwcGd6ek5t?=
 =?utf-8?B?QVQ2dXlVc2wwamMvUWtJV2E4SG1Pd1dZM1FrZHRDcko3NFpZNW1hb0RSblQr?=
 =?utf-8?B?OE9tT1RBRUs0aVo2OE9Pb0EvemdDOVdUWEJBaitJN2MvNmozdHk5dGlmY1Rk?=
 =?utf-8?B?dTJBTEtEVndtT2p6NmhsZTNrQlRVdVBRQi92aGpVVnJVN2RiNXBVVVVYeCtB?=
 =?utf-8?B?cXNWYkN6ek1DSkNlYk9RZVBJbURPM0N6WDNDc1oyY0ZXWThkSjNDY0tLU2NX?=
 =?utf-8?B?SnhmYXdHWERXQ05nK0VUenlnVGU5S2xxaWNhUVFubnNORmx0d3QwcEVwK2Rk?=
 =?utf-8?B?WmxlTitxaWRhOVYrYnQ5UkV1RkREdmJ0WXIzYzZVbmhIeE11WEllL29jZlpw?=
 =?utf-8?B?eHdRbzBJQmsvYVlxMEZCemlTd1FsTXVPTmxsVzBVS2c1M1dBcjhPZEEwdGZq?=
 =?utf-8?B?RGZhOHZRYkpodjF4R3ZFL2MzOWtkQkpDUHFXbWl1WHluREdqNUpVWEhFZURS?=
 =?utf-8?B?ektlVEFJV1NUcFhETjN5aVhvRGtYY3JoNk92SENhalBNT2VGZnRJalBiS1Vp?=
 =?utf-8?B?a3lWbmtxajZWL3BkaVM5bmZNekxLUzBjeEhzUXNLQ2h4S2lPOGl4Q2lrTkxU?=
 =?utf-8?B?bHh2enI5Wnh1MkZwOG14ZWJzU042ZG5pbC9RYXA2OUJTZEdNREZ2Mm9laCti?=
 =?utf-8?B?VXRqUEJxbXpaSlJyajNpWUZoVzZjb2svN3AwT0VEK3ZOelllcmwwWEFrQ25L?=
 =?utf-8?B?N1BwWnkybGJJL09hRE1yWCtSMjU1QmsrMjRiMFc5c1NmSnBWMW9sUzRUTDJ2?=
 =?utf-8?B?Um1nWDNYNFlVZTRlUUdoQmNRdHB6ekM2ZnZQNnlONmEveU5nd2FVS3ZNaGx2?=
 =?utf-8?B?cUVOdW5aU1kraU1yRnVLMy9Ra1hHOFNRcTBRRWpvUXNrR0pSK1NsYlVGUE1T?=
 =?utf-8?B?ODNwWE16Q1U2WlZOTXB2dUw3TjNBbk9TZXE2M2NmdnErVWowQkRiNk8wbGhO?=
 =?utf-8?B?LzVuZkloR1N5a0hObVVMYmtodHc2c2FCeUZ6TEE3TlNuZmtLSzZYQ1ZsbmdW?=
 =?utf-8?B?SC9XeDNGdDdGSmRDZHJKVk5jOTcvT3VWaWJtRTR1Y0d6M0VvZzJVbzRoU1pR?=
 =?utf-8?B?bWUwR1NxZCtJcld0dzk0WVU3UGZsaWFMdG1mQlQ2MEVCYW1uR3RiTDBuUGEz?=
 =?utf-8?B?RFFYRVVnamk1M1NySy9VMUVhZzJrK1R5eXovc25RZXBYdW53TXN1QXpuTXd1?=
 =?utf-8?B?ejE1UURwSS9kZE1BZDZySTB6QzRDMXVPcWNzN0g5MnhCSXN4azNFQXhXd0Ft?=
 =?utf-8?B?MFZyS1R0TmhFNzFwbkowc0hMVHAzUVFpeFpubmk2QjQvQWIxbHlzNnB2eVNi?=
 =?utf-8?B?L3BwallpVlQ4TlFjY0FVVFo0Nk5ZUEpmZFc2QVR5eENhOFJrZDdrUU5sSS8v?=
 =?utf-8?B?NWc3RnZJS3o3aDI3Sk1KejhnRGcwbFZRVHdyaFltdEFoaGZYTFVrVlU4Sk1o?=
 =?utf-8?B?cmw3TUE4aVRkOXJhU0RIa2pqeTlyc01vbkgrM0dxbDdZdW1Gd1diZjJRU2tp?=
 =?utf-8?B?TE9vdW53aVp2cmgvWFlnZmFnMDVaNU9ZTjJDeW9WdEt6ajJrNXJkSFJMVWp4?=
 =?utf-8?B?OFJXY2NnR2w5MlhPM1BQNXlEZmdrdUs2OWRJeFFPaTd5RXFTRGhJRzZZL1VY?=
 =?utf-8?B?QUdOK2RTdEkwbDdVaG9kNWVyNTQ0TzRRSzFZUjFPV2xxMnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmJvdzdoeWpVSCs0WWc0V0pXSi9ibmNPdlVURTkxeDIzaEp5amcwSmw4RU94?=
 =?utf-8?B?RENsL2NsQ2xka2M0T3dZZXBEQXMxM2h2MHhuRUhqV0hsUzZlaGxaNFdReWZB?=
 =?utf-8?B?TVRzMHJyeFRVZTVQUXVyTnNoQjN3UWpMY2dqOEw1eG9oN1hlR1NHT1pKQXVB?=
 =?utf-8?B?emYvRFpLa1pjc2xUSHBjNFduY1JwempZUWhUR2RQcnRHcWlDZkdvQlJKOWZW?=
 =?utf-8?B?N0dqTnhVZXV1UzVxaWQ2bldhYnRGWSs2QkFiTXVuYXk0c1gxbmNoL2pRNlRt?=
 =?utf-8?B?eElGUEdrVTBuelUvbkUyeGpTY3JJVjNPQzlWWEpVRDdqNmZKMklweVRwVlkv?=
 =?utf-8?B?QkFTbGcwaDRnSUhXY1RXMFZhWFJlenovdmVGWHlVOFlIVEZmQ212bU5YYzRr?=
 =?utf-8?B?YTZhTlFJc2RCRFplYWNDWER5QkZ1MG5hMlNsS1NwaW5YVUkyWDlWTHFmOWpF?=
 =?utf-8?B?NFUrMGtVRHllZCtyRWdaRG1hSjdrWUZTdjN0YXcwaC9URDFlMHpOb1pCbmRF?=
 =?utf-8?B?Qm11bGFhNmFEWWQ3T25Yd003MWx4UHdDNnhaZElOeS9SZmgxM0tZb3gycC8w?=
 =?utf-8?B?SGU1UFZqckxldWtxdS9xbEltWDR5UWJPaXRiQW80cGxwK01mZi9CVGhhUTdM?=
 =?utf-8?B?QjBsVHYxbnZTanhCRCtNUWJ5Tml3bFg0aEhBMjhGOGJmWWVEdVZ3VnhVNGZh?=
 =?utf-8?B?WURJK1RVaXN1T2dPL2o0TUptaUw1VUVGN3J1aGVDeXRUTkR3UUVCZHlVRTVv?=
 =?utf-8?B?RDd2bXkwYTliT3FpZDBVdHNYcUc3Q3VuM21MUnFzZTIvWS9VeDRST1JjUW84?=
 =?utf-8?B?NHp5Z3VVb0Z3R3hUK0JsOFd5Q1Vwci9UYjlObTdQWkNOdHR1WmQrekVLZ2xt?=
 =?utf-8?B?ZWdDZ0xSSmhCb2ZRcjUvM3RuWVJjZ1N1M0w1ckZpOGxycllScHNBSUthTTNZ?=
 =?utf-8?B?TWVUTEd2NGhmUnIvOWFMTTRqb2VTeko0Y3RLMFhnTFpENVdPZ3JLSTByRC9R?=
 =?utf-8?B?eUZzcklDS3ZuY2tYempsc0pXOFhuME9RK24vU0pGcVFScWVWRXpkY3NQcXpY?=
 =?utf-8?B?UlBRc1ZDcWJ0WmFXczU1bVhLRUgvOUdwOVZwMTRKbys4MmV3NGZvaC8zUkJS?=
 =?utf-8?B?eXZmaWZMYWwxV1hBbmRLZkY4MXA5aEhHU1hQSW0wa1hpSERiYW9VOTRDUlhU?=
 =?utf-8?B?QjBJSnZrVUpVeXFRN1dUeThES1pua2RJR2ZoaXZkRmxxM2FreElUU2NUUFkr?=
 =?utf-8?B?Vmo2UldTenpBSUZianl6OHZTbFB4Z2dpbEZYaWd1TC9UYjc0WGlhbDBXc1JU?=
 =?utf-8?B?YmxaQ3VzOVlFTER6Y1hGOW11Kzh4U3R0VXJ4NU0ydmxQL081ZUU1TW9zUk52?=
 =?utf-8?B?UEhlVFJHUnI4VXlGZEMxSmZsdUNDUUdpQytyM204OWQ4TTU1YVdURnJuSkN2?=
 =?utf-8?B?WEdWVXFFdWFFNmVUclppbktNamRadGlsNDl0VjVkWlh3L3ZPUVRzWVdLU3Zy?=
 =?utf-8?B?OVlPNGRodVo1M2NQdUxvbllJSzQ5OTBNMXBwRWRuYVlLRWN5SDdrOHBPT3ll?=
 =?utf-8?B?MGRmMGVnV2hORlVENE5nR2pIVXc4UDh6WDEzUG1UN1NDRDFsSnUwRC9BVnd3?=
 =?utf-8?B?dnJIODFIZXdPazdmZ1BmM2pGQjdHVmRqNFAyNlNDVzBQbkljaG9TdGZMVVli?=
 =?utf-8?B?VHV3RVFqQ3JvMFJ0OG9JeHlTK2NnczNka05IZXNlbE9qK2xmN0MyajRMSlNw?=
 =?utf-8?B?Y3orZFF0RkJnSTV2bllEMlZENXhUVFVqZTFvUnN4VlExSExNZmJiVk10YkJr?=
 =?utf-8?B?ZFdHMkdjTEtKOHdoV2NPaHhCTWgxMUgzdDFKRTF3eE1rNkN0MEtVc0V0elBw?=
 =?utf-8?B?KzljY3dIZEc2YWVpVEl4anRjREY3RUVSeXUwMHFmM1ZkRVpDaWQ4enFDNVNr?=
 =?utf-8?B?S1JMUzgyS3kvNUVDbnFtQkY0YjdkdUZCcCsycWZOQ1R0dnBwTHpkWTQzRXF5?=
 =?utf-8?B?OHcya1IrRitXTmJTQ0lpMjBPUXZYMmRmc2FISW93a2gvbmxyZ0VGbENuOHQy?=
 =?utf-8?B?QmJ3b1BnSFFIVVMySUVzVXFYL1RGTXpIOFlaM3pMblZjTUxPcXcvU1cwSSti?=
 =?utf-8?B?R2FyMGRIdlE3dzNoU1dyL05pZFpQY080cVVaSW9LWFB2V04vVDJFSExPNVpZ?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb18029b-2d7e-4eff-44e3-08ddcbd3f5b7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:35:38.0074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owvulNhEdq3LV5os180Y2STjA4iIYuNNKPZXqFMbruiMZQzqNF2adUoohaG3sE4eqAcfdhb8I3bw7Bxe2LQYjixofTy2759B4Q51LgoBst8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Enumeration of Intel telemetry events is not complete when the
> resctrl "late_init" code is executed.

Could you please expand the context to provide detail on why
this enumeration is not complete at resctrl init time? What guarantee
is there that the enumeration will be complete at resctrl mount time?

> 
> Add a hook at the beginning of the mount code that will be used
> to check for telemetry events and initialize if any are found.
> 
> The hook is called on every attempted mount. But expectations are that

"Call the hook ..." (I do not think I need to point these out anymore,
will leave to you to rework all changelogs)

> most actions (like enumeration) will only need to be performed
> on the first call.
> 
> The call is made with no locks held. Architecture code is responsible
> for any required locking.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            | 6 ++++++
>  arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
>  fs/resctrl/rdtgroup.c              | 2 ++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index e9a1cabfc724..d2fc0fcd0226 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -460,6 +460,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>  void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
> +/*
> + * Architecture hook called for each attempted file system mount.

"for each attempted file system mount" -> "at beginning of each file system mount attempt"?

Reinette
