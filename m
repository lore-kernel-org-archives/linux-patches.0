Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A74B1B6D18
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745011358; cv=fail; b=uX5bCIcpqJT/Jk3zQenxsEO6Ch7t1UzE+C/vNseXGUBVannJXnm8AsH1uCwwziAiKEnJhijipFgFr8QUx5vB8TFQ6ZEFqHeAW34+zA8CRd30dS2RMuN47/A2t88JwlFuAS8jjBi6U85Oa7TM1pX0gWzcWbK5565j7Yydwe8hv0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745011358; c=relaxed/simple;
	bh=eVlakVBy0+hh6P2udRDt/V6JzVhaEivEub5tBFfND7U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=abwSAPYYoGaIK8quAA27ATpKvUzlnB1klONJpMmbh50zRplyOrSZoZaTQbX87f5PQYpx+V1FAwesS3z4+MSYN4xTitgPcXz2gKtdNxtVEbsMtdZM3AbEkyOdyEM9aB6Mm3UgrW1Yb9dx7fpGVJXQxDwd2Q6x3gSz3cqv0V7I9Y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lTTRW+Lq; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lTTRW+Lq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745011356; x=1776547356;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eVlakVBy0+hh6P2udRDt/V6JzVhaEivEub5tBFfND7U=;
  b=lTTRW+LqXYpO+ZXk1pcGd/jsIz1kl9nIJxpohRP9ZASP29ZXbiPibNu3
   6Lh0two94LoRzAUvQia3BXi4YLTcNhL+u+kPG7dO9q3foGtC/amEqj7tL
   UiB5ddocw+mdwkmnUZiTWRZstS+wzoAIxDnwZbZSUNcle4ALtouXkChH7
   vSheXDZILOHjy26WThoUAdVTXVXc0qgx86JUQrrZ44E8zw/0+F1yDTQws
   7gg/iSggVyyZHzm/JnerJECw+PMEPe394Z9YgbjBBo4C62pHRTjQdx8TH
   K/Nc3i23Uy8YUARN9f01w6drEHNMi4aDgn1EJy6YQR9TgVqgy/mtufX3n
   A==;
X-CSE-ConnectionGUID: pptPG4bsRJepXQe6nXiSCw==
X-CSE-MsgGUID: cHqq4WBtQYO8vpTx0YQqzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="45878275"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="45878275"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:22:36 -0700
X-CSE-ConnectionGUID: 7iB34EkXS4irYS2e8heWeQ==
X-CSE-MsgGUID: kgOkdOq6QNS0enbV400pqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131158435"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:22:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:22:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:22:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:22:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HhLiFWHpzJ/8v2LZeh5SqWJKeWEbHT9UfvZU9NA7rL9LkYrXyxo/qRX5Pr3wDjZo+RLhGXnZV/0f69V8ZWHT6ESxFXtBjP+XYEFNPSwq+aceraesTtlnq6YxZ0FhBv3TaO4pSvjNFXfAPwJkSYTpz1nEqe7EPhQ08i3TJxkPNJs9wiJ85Gfwrp5cx0MsNZrdCWqGB7q1Qkt6drBdiKfNdkV0dUCHAcPGpXTpFgm8r18k/yD05HL1YvKyXGL2rfcaXWStRlaGZyqt1klgfiLuya8/8hLDhdcNtNrnf/mXNMJxKvqKyh0gbfI+gqkRnvpPdSB+i7JWWjP5PDm/5kpFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiiBMAMAMJNE3BCPOcclzK/8DpGmwsfHK2Myd5yihwU=;
 b=JL1EyFR64/PDSuQ2l8hPOOw25BAP2MMYXVXth+5u9E4aY3PMLNTYqGr22WBj6ZNaSDja404GjE8hL8JQgr1/xdqQM3lYqI7R9YmvOfU55VM2VKBdlFvzEc5orSkwlT7AsXWESI54YkNEzGKyHNrGUEW45sxTxj6xPrBHvF8i+Aw3hCspvwvdDVoeXR6yICh3j+/bhau18y49HP2g5drl3a6NsulA6KlgpyEZTgsVj3iRV4eDr95Rj58j6XQyVE6j1mSWq280CdsfpqEOzAfdDTZj4LsMjMDD72ijvYo1eKVQnAt5SB2eZk1TkbkwJ3DfgaDK9yRcUSg+PppLWDPMsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5124.namprd11.prod.outlook.com (2603:10b6:303:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.25; Fri, 18 Apr
 2025 21:22:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:22:33 +0000
Message-ID: <e3ee6d77-6b83-4b8b-8ea0-bafc2946aa80@intel.com>
Date: Fri, 18 Apr 2025 14:22:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/26] fs/resctrl: Change how events are initialized
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0277.namprd04.prod.outlook.com
 (2603:10b6:303:89::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dba97e5-0642-4271-9f7d-08dd7ebf21d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WkswOVkrL3dPQytsMVNrUzMyN2tKdSt2NFBMYzBCNUF6MTltak9kMjUwaThY?=
 =?utf-8?B?THQrZ3pwRW1BVDdGMjJDV3ZGcmZaK2FDNkYxdDd4QXdBSkQzcmRuc0JHZVd6?=
 =?utf-8?B?N3pmd2tFMjdLRUk4TWgrZ2JleW1QOS90MjZTcHh2WlNIMXpPQllUTTBMRVo2?=
 =?utf-8?B?THFGbmVkMWhsVlJFTnp4MzhQTVFVSFkxckpPNi9yWFNjWmJxZmt1ZTdqeis5?=
 =?utf-8?B?Vllkb3ZEci9tck1JalNDUXBFdEMvczc3KzdEeEMzZ1lFUEF2OXRBSXhhendI?=
 =?utf-8?B?cUZxNWgzRm9tK0ZadVlON2xKS3JTU0NyZG5JbTNQSXBlbGhTVHVwQTNJZ0kv?=
 =?utf-8?B?dGU1N0hZQ05JcXBSUVRRNFBJc01IMmduZEJqMThNTGhGM3ByMExIQlZRWGVn?=
 =?utf-8?B?endwZWt5YnFJU0hxSzI2dVBXRUhhU2lleTlrSUVFdkZYY2l3Mko0NEJENzRz?=
 =?utf-8?B?dzNZdm4yREpkWmM1SWRYNmJ6YmpMSGFEcmZBVXZMbHVBMDNnUmg0ZHRCMTVR?=
 =?utf-8?B?WFFqdjJ6WVB5cisrVExPWVF4OTRCbkgrSkR6N3dzQm1aWk1qbU85V1dQKzQ3?=
 =?utf-8?B?a1J4aGo5eHdONGdKTjdqcDcyM05GOVV6WHdOdHBUMXhxMTJlWFFaWm9MYVp2?=
 =?utf-8?B?QitHN3hoWThINSt3ZnEwYWxDV1FRWC9Lelc3MHFwdDIvWjFNVzUvRmsyUzJt?=
 =?utf-8?B?a3N3VHR5UENkKzYybjZKVFl2UDFDajIzeUpXWVdoc29DZmpTMEpmT3c5SWV2?=
 =?utf-8?B?SVdjZ3A5Q0haT1ZrN2tMK3pwUUI4MGZuaGJKSFNhald3ck9ZYkh6S2F1bWwx?=
 =?utf-8?B?aWl4R2VGdmV2Uy9OOHBPUjhMWHAzK29mZ1VtcUt5Zlp2aktkdlNIakdWOGg1?=
 =?utf-8?B?emxKVSt2dGZUV04yclV5NVlmdmFTWWx3ZFFra2JQSCtVbmxuUmp1dkNYaC9z?=
 =?utf-8?B?a3ZtVGcxREJuSm1qS1VjbmlJNUFtaWRiOXdDMjRQa2dJUGxZK0NUMFpvQVUv?=
 =?utf-8?B?MU5sRVZoN0N4SEt3M3JveGxHVFI1dCt2cUw3bUJqUTVpN0paOVU4dGQwS0hT?=
 =?utf-8?B?MDljUzlZdUhKN0FIUDRWZnRlQVZZNUhVOWxwRWdoSTZyOEU5WTNycEdRbE9t?=
 =?utf-8?B?MnhBbHExSUZoTmpmUTFkekdhYmxEeTlFaGhtMnAzRDYybnhWY0piRjg4RkFR?=
 =?utf-8?B?anJ5UDlQT0RsNSs3RmZaVFVMdjh6ME42c0JPeE1UZzREV09FWDgxYnh3NElG?=
 =?utf-8?B?UTlkK1FBSWlJZmFpdjM3clBlTDhhWTNIYUVRRFZ3TlRpTnU4MlZ5QThBbWNl?=
 =?utf-8?B?SzVHTFNnZkdBNHByeis4RHhoYkpHSXVXM3BEc3BTM1d6Y3Z5S3lTdktzbFM2?=
 =?utf-8?B?cDBhTW5lTklaZTZWM1FaNHZzcWhocndNSmlac09haEo2Skp5TnhGYlpHWnly?=
 =?utf-8?B?NG1BU1VFRk5EWTNhTHJOLzRZQTE3UnI1T1R4b1hFZXFGWXdCRkZabVhrQjJl?=
 =?utf-8?B?UkV0U0hMZWtlampSTmsrbXVpbHo4MDVmK0pHZ0doSHJMQ1dTNW9lTEluVlpC?=
 =?utf-8?B?dlFiSEQ1d3c3cVZObGRpZVVNV05Lcm8wbSsyZnBDTkJwN1ZqSktYdi9UVEVY?=
 =?utf-8?B?eUdpRHM0T3VqTVJDWTRoOTdrc3E0NktaVDBqUkhmcGJiRTRYMWpvaXgwSmVK?=
 =?utf-8?B?VUhVbVJyY3haYy9sMGY3SlJFZEJxNFRzeFd2WGlJZzFSejNoUkdBL2UyUjBU?=
 =?utf-8?B?SkpIQ2w4UEF5WjJ3WnN5d00yQzNsc0Y1eVlMazcyb0NFcVJuaU5NRnZRMEY4?=
 =?utf-8?B?LzFzTkRib3hqY1kyRi9aWTM5bER1U295WUJhMlM3KzRGRjlmeXFyMERvRmdF?=
 =?utf-8?B?MEJhcHZiclRram91aUhYdnNYcDU1N0FZNG45c2srbjBXcVNDbi9LcGVIaGk4?=
 =?utf-8?Q?lTCemIqYW1E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZwL1lCZjBSMFRjTytSSUdaRVdGVGJHRGFhcHhrV0tvbU5zZ3BNcjFoZkNt?=
 =?utf-8?B?bm0wYlBDUVZLMHdrcERJODQwNHo2UnRnRU1pbE8wVmlDKzhhd2xHenU1R3Fi?=
 =?utf-8?B?bzVZZWNNaVFxVWZSc0dBQm5VamMzTnA3Z0JpWDFDY2NyN3NBenJxVWY5M1lR?=
 =?utf-8?B?dVdRVnRtYnB4aDJmVkg2OWQ5TktPKzRhZGU4TGVreDVxc0JXRXNCQzF3dDRH?=
 =?utf-8?B?RStURHQxRHJCNTNqTEhLOGwxdnVySFRONUZsQ29yWlVQYkt0WXZaUHd2aUVt?=
 =?utf-8?B?MjlSNzVlbitrQVNMT2NReG9oL3hWSHN4ZmVoNndyU2VmcG9zUlAxVXNhcWVs?=
 =?utf-8?B?MjBKVkE2cmJTUWtnQ3d2YTdYZllOWGR6Z2x6YjEwcWsybWFEcm9DT3hKUTBl?=
 =?utf-8?B?K21PaHJpVTdPRDM1T1czWDlmUEhhWVdMYVpKSEFqZmVXOTl4c0xUQVAycEo3?=
 =?utf-8?B?VTNlQnlIUUFtbmhHRnpnalJSZVpSWmNpT3p3S2pZVlkvNjlva3ZoWGpVTCs2?=
 =?utf-8?B?UVJGSnQ3VGlTeTNrcVBKV2pGVTdBd245U0p0RlB2aXNjTVJlYkxabSs1dmJj?=
 =?utf-8?B?dmJocGVTOXF5M1Z5SEYwNUtMbm5qSUwvS2VHS09ERDVKY2d5QWZYY1hxRjFG?=
 =?utf-8?B?OWQzSmYvRW5ES1QwcTBaTG1xK2xmQmV1dTRpUTV3ZjVCcDVrb1czSVl1Q0FS?=
 =?utf-8?B?VGpGbUJIT1ZnK2NXWGI5R2J5Z051ZHhqTTZjSmxTZHFPM0R0MGlqYzBKN25X?=
 =?utf-8?B?MXlCTldrdnl3VTBJNVdzS09ETW9TTHZabEVsSWluK3FiUGdjVTh4c25PVXR2?=
 =?utf-8?B?RFBrcTVEN01WVW5EYmhrNVlNd1dhZmEyT29Jc0VlcjdDN1NNSFRzaEU3RXJO?=
 =?utf-8?B?eTg4RTZ6T0tpa0doZ3RzNm9tZkw0WUpoek5jWlRpODBya3Q2c2xTN3M5ZjNX?=
 =?utf-8?B?d1BqdGlsUG5uQnljYStOOFg4K3ZiakxQWTV4aWFMRzFNQTdEbWFKOHJhSDNG?=
 =?utf-8?B?ZTQ1VElBUDZtZmdxM09zcFd0aW9vU3lmdDVlalVFbjFPeFNzUWRPd3lUS3Yx?=
 =?utf-8?B?S3lWWjYzbmFQbElaMEp1REdaU0xJSWI5bnFPV093WUNOZ3oxUy9JMGx1eFBi?=
 =?utf-8?B?eDdYRjJOQm1YR01HSGdvMjFDckZySmgwQzU0M2F2ZWRkODJ0QnlwU0VwOUVW?=
 =?utf-8?B?WWFIMGpFZVpYVEZqa3VIRnRicHJrazlnTDBTN1djMEF2dkRVTmhxRDU4YUZP?=
 =?utf-8?B?YURUYnlGNFhsNDBJLzg5L1Yvb1NHVGJ2ZFNJMUo0N05aQ1duWGtCelFJRHpZ?=
 =?utf-8?B?MG05ZjErRkVINnZUZzlXWG9FNXA3MmU5dmZTMjAxSG8reUhVcmMvYU5EUk9N?=
 =?utf-8?B?cmk2eVk2b2IvNENSSVg0Z3JLRGR2NDQ3NHlpUi9zSDNHYUxtMkNaR2luTFpZ?=
 =?utf-8?B?UkRmNm52U1BKR1FKU2ZvejVOeEEvc2lxOFJjSXE0VTBWdWt3Tm9LOUZmemVE?=
 =?utf-8?B?SU1YUVBrZmxxUDZuRFIzOWNwZ2pWQlpNazRCd0pKemZzOWFlMTUyOVhta0tB?=
 =?utf-8?B?azRPa2FudDZaOWtQSE5ZS1Y1U0hGN2NCNzNDK3YzZmxmRERZSGpsQy8wWHha?=
 =?utf-8?B?TmdZczk5czVMMlJXU0dMRUxnWXhZZVZYVjlYbTI5OU1UYWU0MWRCYXBxR20w?=
 =?utf-8?B?MEowUGRSa21tN28rVTFTRHAwYU8xMGZ2L0Q2U0V6OGROdFhxSlJKNkxpdGI0?=
 =?utf-8?B?MTVsbk1NbFFPZzA5Y0xHQ3NBMWpSOU1Wbzd2YUd3VXhMTHlubVRXWkN4Z2V6?=
 =?utf-8?B?amNRZGM3bXNLcUYxa0lIamZ4QnZiMnl0eEhabmY2NmY5V1RTN1VEWEdxQW80?=
 =?utf-8?B?R3FTL3IrU0xDM29uNG53bVNkdU5wYkg5MG9IN0pIK1Q1SUg2NHZQVjNJcUp5?=
 =?utf-8?B?WHJtNk5NOXhCT0xlN2ZpclYydU85UFBpeWorREx6QXJvOUVQQ1ZBSS9WQkxi?=
 =?utf-8?B?U1owZnpobGNqZnNxeEYxQWFZaHNOajF2YzBVTGNTMWhzYTFYVERzYjYzSjlt?=
 =?utf-8?B?QzB1bVI0Z1JFZzB4RC9jWk1PQmJ6N2FjanpFT1dKaUpNcTFhdUFoQWFCc2NO?=
 =?utf-8?B?RGRUMVRiK0diMVFkL3hzQm9zU1dwK1p3Yk5BbHpCTERBWVhrZEV5UHlURm1P?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dba97e5-0642-4271-9f7d-08dd7ebf21d4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:22:32.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJz4aSUTHPi0WpPpYqO+5dL70+mKzdFh+Kbl5YmY2IdpoInlNCerjvkRxDfQffdF8efSrUGn5bmLMSv5o35buwIJXMDVlh/2ILOrHF5EPUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5124
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> New monitor events break some assumptions:

This changelog jumps into a problem without any context.

Please follow changelog guidance from maintainer-tip.rst.
Specifically, "A good structure is to explain the context,
the problem and the solution in separate paragraphs and this       
order."

> 
> 1) New events can be in resources other than L3.
> 2) Enumeration of events may not be complete during early
>    boot.
> 
> Prepare for events in other resources.

Please include what this preparation involves.

> 
> Delay building the event lists until first mount of the resctrl
> file system.

Please include in context what is meant by "event lists".

But ... previous patch reminded reader about all the event state
that is allocated during domain online, which usually happens
*before* mount of resctrl. This work thus goes from "use enumeration
of events during boot to allocate necessary event state" in one patch to
"enumeration of events are not complete during boot so build event lists on
resctrl mount" in the next patch. This is a big contradiction to
me.

I think it is clear that not all events can be treated equally but this
implementation pretends to treat them equally when convenient (this patch)
and relies on code flow assumptions (previous patch that only allocated state
for L3 events during domain online) for things to "work out" in the end.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h |  3 +++
>  fs/resctrl/monitor.c  | 30 +++++++++++++++++++-----------
>  fs/resctrl/rdtgroup.c |  2 ++
>  3 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 7a65ea02d442..08dbf89939ac 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -76,6 +76,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   */
>  struct mon_evt {
>  	enum resctrl_event_id	evtid;
> +	enum resctrl_res_level	rid;

This structure has some kernel-doc that is not visible in this hunk but
also needs a change when adding a new member.

>  	char			*name;
>  	bool			configurable;
>  	struct list_head	list;
> @@ -390,6 +391,8 @@ int rdt_lookup_evtid_by_name(char *name);
>  
>  char *rdt_event_name(enum resctrl_event_id evt);
>  
> +void resctrl_init_mon_events(void);
> +
>  #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
>  int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
>  
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 66e613906f3e..472754d082cb 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -846,14 +846,17 @@ static struct mon_evt all_events[QOS_NUM_EVENTS] = {
>  	[QOS_L3_OCCUP_EVENT_ID] = {
>  		.name	= "llc_occupancy",
>  		.evtid	= QOS_L3_OCCUP_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
>  	},
>  	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
>  		.name	= "mbm_total_bytes",
>  		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
>  	},
>  	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
>  		.name	= "mbm_local_bytes",
>  		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
>  	},
>  };
>  
> @@ -878,22 +881,29 @@ char *rdt_event_name(enum resctrl_event_id evt)
>  }
>  
>  /*
> - * Initialize the event list for the resource.
> + * Initialize the event list for all mon_capable resources.
>   *
> - * Note that MBM events are also part of RDT_RESOURCE_L3 resource
> - * because as per the SDM the total and local memory bandwidth
> - * are enumerated as part of L3 monitoring.
> - *
> - * mon_put_default_kn_priv_all() also assumes monitor events are only supported
> - * on the L3 resource.
> + * Called on each mount of the resctrl file system when all
> + * events have been enumerated. Only needs to build the per-resource
> + * event lists once.
>   */
> -static void l3_mon_evt_init(struct rdt_resource *r)
> +void resctrl_init_mon_events(void)
>  {
> +	struct rdt_resource *r;
> +	static bool only_once;
>  	int evt;
>  
> -	INIT_LIST_HEAD(&r->evt_list);
> +	if (only_once)
> +		return;
> +	only_once = true;
> +
> +	for_each_mon_capable_rdt_resource(r)
> +		INIT_LIST_HEAD(&r->evt_list);
>  
>  	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {

This is fs code so this needs to be done without peeking into
rdt_mon_features.

> +		r = resctrl_arch_get_resource(all_events[evt].rid);
> +		if (!r->mon_capable)
> +			continue;
>  		list_add_tail(&all_events[evt].list, &r->evt_list);
>  	}
>  }
> @@ -922,8 +932,6 @@ int resctrl_mon_resource_init(void)
>  	if (ret)
>  		return ret;
>  
> -	l3_mon_evt_init(r);
> -
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>  		all_events[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_total_bytes_config",
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 8d15d53fae76..1433fc098a90 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2574,6 +2574,8 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	resctrl_init_mon_events();
> +
>  	ret = rdtgroup_setup_root(ctx);
>  	if (ret)
>  		goto out;

Reinette
