Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7332C923
	for <patches@lists.linux.dev>; Thu,  7 May 2026 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778173576; cv=fail; b=mOZ8ROFAiEh4eJntlVI+Usiw3x90LDdt+mXbEufz/POqgzLX4XSQlKsbZ0Hcxj4ibuFQmeiLrbZdSHkeEPPgRcl4qz/RmQYxS5T8GTTY6B8CuzgzMQ8SdtZYJL5b6WESZ1im4NkIWry4YNrj6a0M4DCY5uwAdBk+bsfIsC+GdVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778173576; c=relaxed/simple;
	bh=bZVjQ1i4uyemr6yJEsBlTplD3VH2J+4EgpNHzORjyBo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SlrC3WrDCsVYheTJimQyJqBBxhbq6uaUTSFHHP6zsyVgUoq95btvO9GAPLxIjILjICVMCXUOyLRUz1qGYMaZBfToChUzfa42gINXgnj/bHgC85flHbbVX7wCm1uVzEfXY9+625UlrUv7BmkiD0j40TQ17/D8RmPVwG93W1rwYQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JXHiKQTy; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JXHiKQTy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778173574; x=1809709574;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bZVjQ1i4uyemr6yJEsBlTplD3VH2J+4EgpNHzORjyBo=;
  b=JXHiKQTyZhIVh/v14H9M8wO+VMFN/9l9dhgMjN9EVcascb7x+ZjuHBoO
   8AZ9kA4wO4GLnZBQVzNkO7sDHplPiVY5c5P1cNFZxQrs6E+Ybiwtt1eca
   SvkpXsnC3sbd5l2zRdNzL+0tmr2yKy0+yABjC4pYlXMR+Nyai9AH5zBBY
   xTuWYd44N7/kHUiLXkKLCH4n78GPKgtH95DUE/D54uWFV74HXVTDSLLna
   4Oq5xgIoPxWJ5GairqtQgg+4Rtqzrocro9b7vNWF1NjtdnMUSr1GLVzWd
   mBAWLdJMsvMFi51tHh0v62Gc04kTaqkH3pyXDdGnj2i9i8+a0/+BcJaKR
   g==;
X-CSE-ConnectionGUID: g9zQ3I/3QweiNdFFtIgjWw==
X-CSE-MsgGUID: iexqldjfTJSu5ev8ruELQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="96560679"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="96560679"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 10:06:13 -0700
X-CSE-ConnectionGUID: E3jqrTbnRyS1kR8J8WggQQ==
X-CSE-MsgGUID: RDD1+/IwRdu63SttbD4uvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="260230882"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 10:06:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 10:06:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 10:06:13 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.47)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 10:06:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FdHYqbTY4DpQj+WYCrqtHzp/8vXx1Da8s9aWefTTBBcQRK0G5MvcPLvnNQdcrq98toqRIhO87HRIA1EGsGKJj/JP244tisUHmwi0raYoCCY1ikgva2ZFgciZS2mWCmjhCDGUFbns5LlxQukVQ3c6P6+MrQXQ7v5GugZfqwcw8xhOOmFKCiTul56ETzgata9eYm31uDP8nxRI0FGc7Y4zRGPbFIY13WdJt93+MGIWGUQzdzD1Ayu1DwwqHJnpTYxDUkk27RRTYsxNJwuu4i/lXAuUfi1DBB96FGPGMTuB/OXgJWd+D05+xr2fkfdKoQFYfQmhIWr4jZLd9eSQQXIMNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqv0u27bHrrGsOxlruBRuAgZf3sezs3wmZj2tqiRRAk=;
 b=Md1JngdkvoO5RoEhkU9I8acXInTtzHXUHyU4E5tTJgVY2xThWBwmgchXwNs3koa46vyum5S9UnLQQ2BSY+6EGNn4GCvpPTLiSIVw+QbkD0E9Qto2YpQ4+e3fPDgA7t0WZ4ipGVUN1r+YlIl/8yS2oY8x8gykO8I48Ed55vXGt1WE9kPRtEYXd1vH1RSSR821Xy82thX0qEJGMzLyKwzrvfSgn8HGxiHIuj/qrk3ZpyIZ5dQapmt56rRAin+ZuzRgrsyhgR2U/zLnB7zkM/tFUbDmkvKM7ZvFNuZxMiU/k89KhLyvsJxKLdrIGER9pDP/5CkuS21jeV48MopzJHJw9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8186.namprd11.prod.outlook.com (2603:10b6:610:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 17:06:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9891.015; Thu, 7 May 2026
 17:06:07 +0000
Message-ID: <58652f6b-77a6-4655-a8b9-59c6b97cd49e@intel.com>
Date: Thu, 7 May 2026 10:06:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afy0VG8ctiJBPyf7@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afy0VG8ctiJBPyf7@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:303:87::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 48de2476-b6fd-4f60-4689-08deac5aedaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 2mi2ma1A/MoLWBUn5FAUi13i3CwsK2XH2Bz5eqpOqKhmfdFK68F5UA67uZuxpAOC4c8aFy/zNv9Iwx/V389iC/3RJcGt/x7X6OV06s3VlHTZvHDU8flFX6G0vd1COVYms7QVthcbL5pfQARERJHJRESagB0MlaMjcvvOtwZZrwVPEGV2/Dgk/6A+F0xmYLXI3USX3uWhV+C5uiccJFDQCP0jiId+jRpWsly7ksTxvO/p42T3Kms/yxoVz3y2SacenROYUAAJINKn4q2fT7w9FkIOkHCHD5vGiyyunOdB0MMR3+HnWergh7zeoWn7uX+tI1fXbUjpfUIPYh9FYPLvNquNz3ktnBLMWNp04QmlI5296FHj1Ruq+2TOZjUKsrA9r9RDMDPlMHTQKYg13osFu3N1ttuddK3enw9ncRViIiStWdsG+x2U5pbJEgpuFPyLU+6SX/A40Ww7EL710Nz6yQbBbKBbTN5CXz7O2a/lzM7whn0LXzoQGH+AOoLLb5L6L2Omn9TzFWupLJ4SydFPN2vqA6xuiL/recCrWqI8ndwr/gELkT/ZYyXT2X/Wbqh+XJMaq2/VAs/ZijzKL1tGLMhYZI08RITvGhZbmlBVIFAvYwfPmwU+XpNwlPdQIIR3ZbMp6+qz+jvhEs3OxBn/b7hxHqguJKhuOqXhaab0U9rr/JIa4qj5H5k2QNK3IP6zeSXm1/XdFusSfKgWOT0uRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajFPZ040UWMvYlRVS0hSclRIQTh4UE1XajBQU1A3cWZ4Mit5bklQYUcyZVZw?=
 =?utf-8?B?Z1lXdE1hb0VQazNzek9GcFpjalU5UFVRMWlIUU40aVRDcGZZN1BKSE5tMzhr?=
 =?utf-8?B?SEtlNitxVDM0WVVPOElaemR2WmVkMWs1N1UyRWMwclcxME9LOWR5SldmWENk?=
 =?utf-8?B?bkc0aEZzZkVsUkVpbVFoc0N1L2NTRFZlZ2xpWXJtRHk5QUptMitQRUFXS2Za?=
 =?utf-8?B?RC9tNFIyL2R6Rmp0a1gxeWNWQUFTcjRUcTVGUXZJanQybmJFRy9jT3N0aHph?=
 =?utf-8?B?cVYyZmJ3T2tVejlNVmo2cUhoeHljd00xZEhBZmYxZkJlZ2hzTDVzNHh0VGFS?=
 =?utf-8?B?d20wUUtKL1lNTFA2YkZJNStKS2lnNUdoZlpIdXhqNjd2ZVg0Q0FuT3ZXT1Y4?=
 =?utf-8?B?dnVJOEdsV1lKNnFSMjFoMVhNSEtVSTRQYVZGL3pHUmN0UFpabmNSNmhSREZX?=
 =?utf-8?B?NVRPcEtneXpGT3Evc09JWHVldHh5L0ZqSXpqU1RnMkhnUVdQek9vN0h1R1cw?=
 =?utf-8?B?eXJLTkRORlQ0VmF5WnFXR243amhWUU5oVlovMTg2bFpsQlJWU2sxa1NObzgx?=
 =?utf-8?B?N252cXpDbUZiTldRRk1IemJsVDhNQ3Zrby9rUVhlaWd6NUZjSzBKLzdocmI2?=
 =?utf-8?B?bCtsVnVwVWpBcHpJSGJLb0xJTFFjSGJRKzl0YmVjU04zaUVFM1lpaGFkWk5C?=
 =?utf-8?B?bzRDYUFnVEJwQjI1UHIyMkxDZHlrZk9hVUtuUm0zMGxVVy9LTk81UlAva3JK?=
 =?utf-8?B?NUExL1NLVS8zTXhSVE1BbEhFaUYxKzg3SllieFZjc3IzSHlndWxtZGhNR0dT?=
 =?utf-8?B?dk0vb3dwUTJlcWVDcUNYQm1ROGp5UkF3NzVKM2s4QkFqZEtzVHNkSkhoYzA1?=
 =?utf-8?B?SWtJOEZpWEhIbmEvMzNhcW9aZ2pCakxNbEIycXZmK0xLK1NQQ0laWUhNVmpr?=
 =?utf-8?B?VitiUnJkSnNsUThLY21seXJwZHRqVEFkVzJjMmRkWWVjek9NeUpHeUZ1b1RZ?=
 =?utf-8?B?RWVxbHh2b0ZZQUpiRVJpZFZvZXpOR0NTSGhIQmt2a2JGZXJhSjNwQVgxaWQ2?=
 =?utf-8?B?K2tDejdoM0lNdTNURlVRYWtEeFM0OFp6N0VCNExFRzRGU3cvYWZIL3Yya2li?=
 =?utf-8?B?WWlteWVJenFIN1dTVUtxU21lOU5XTlR5VG42N3dwU3YrRFpSQUpQejNac0xP?=
 =?utf-8?B?dzgrSDhPV01ENkpVcVhuZTk4RS9ib2pyZThzU3hxUGg2ZTZOR2Z5aW9wV2U5?=
 =?utf-8?B?dUJSYVNRM0JJUUtxcTVoU3JqaEJVZU54S1l0NGEzMUtoZGNBTGR4a2xNaUwx?=
 =?utf-8?B?Zy9hRFJ1cHMzUWdFTEpTTGE4MUU0Wjg5cC9hOWdOZW96Njc3WHRPL0c3S0Vl?=
 =?utf-8?B?dTR1bFVLS2ExaVpOZ2RJUFdsTnVxMUdLN0M0d2J5YVdqZEVJRThTYVJRN1E1?=
 =?utf-8?B?elRwNUFjalBQQ216YmFqbHFYbG80aFVhZW5OdE94SVlPb0FxUDRjMWNKV0Fa?=
 =?utf-8?B?ZVNRTWRRYVdCSDdUbXRSVnlFWFZZclZiUnJxK1JCdW5JY1FTKzQ5RUp0cVZY?=
 =?utf-8?B?eG5HMWt0SnhvNTNYY1V3VkpLUmhSR3duanNOcEEzWnl3b0VHVExqbzJheDNJ?=
 =?utf-8?B?WTdHNGNXc2FjQytGdWJreHVHei9TWDVUR3pPdG5aZkVaYzloeUNZUHVpdEg0?=
 =?utf-8?B?MXpBZlBPSlU5dVlFTzNnQm11QjNneUQvK3lZaHBMdWNKUFMwcnYxenJrekxX?=
 =?utf-8?B?NXhKcTltZGwvRmwvOFFyMm9oY05yOW5SdEx2Z1l1MUoxTW53TzlaMmVkNmJ0?=
 =?utf-8?B?UFlRSXkzVUw5R3NkdEgvZlF0U1ZHU3pxRmFERzJLNTgvV09SdHpibEVMM25s?=
 =?utf-8?B?U08rVmNYM1AwQ2NGSHEvSFVWZlBEZHM3bERkUy92eHNydDhKcXVvOTh3elI0?=
 =?utf-8?B?Sm5sby9Gc1pYbkxadHphSFFLNmt6ZDUzVDBjcko0MTNOWEhmYmgxUDd5SEFr?=
 =?utf-8?B?WThkWjV2MGhNMGF3SDk0TmsyeHg0SU1pWW1ycU95ZHRqOC9aMzVUdVBZWGRu?=
 =?utf-8?B?alJsZm11SHFnWFBaNk5NVVRYcElDQTJ0VlhGSmRURER0ZkQxaVF3TWZZMGZS?=
 =?utf-8?B?ZWh6OGpDV1dXdUphN24zRTlNZHMvNmlyVU43MXliemFHQWxiSG96Y21EeVlD?=
 =?utf-8?B?bWx4bWpRVitkN0hIQ2tBWk5naUFzZWpvSEFzWGFCTnRxUmJwVmljeWpMWWtj?=
 =?utf-8?B?SG1uT0VIZGJyZENobTlSU3JoZnVIeHlzSFlmVzVkQktIdm1qSU1QRHpuMCsx?=
 =?utf-8?B?SGhZbmtzSVpmUEtETnRWK1duMDRqLzFDZDhrZWJWMEs1OERiR21QWjNyTmRw?=
 =?utf-8?Q?ik47eMeB191DyQIY=3D?=
X-Exchange-RoutingPolicyChecked: Bt7aM0a+ac4BiK59xEPhjVy6IIMyWAS5cKOAKYC5Uv575Z7fimUzB5dzbnRjjqRgQbGjaVqMSPkdv2ZlsuwyrkGT09u0i43mhOZcZ84vLGvDcwMzq21moJImVq0z3aBVsynbnsKB/szJHWk3SPZZhmXAuyXVyATAnPaDFr+0XcY1olP7swbr/XDS93UP/GgOTxjlQ31Q6BB0ycHAvcd5lAmEVvb+J68MlkLzSxyXzwPGasG2HrvSaMKFemTv5esBq9GEHB3vs9QxD5bQ7cKn7uMFySUe1O5qViJAUGV4U7Ke/1SNcr+6yKemmSUmKv7rA1NJH+tl7xWG/LaB0d47Vw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 48de2476-b6fd-4f60-4689-08deac5aedaf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 17:06:07.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbHB07LweDzI7IEha+vs3EqC+KGWs2fs76OxU04DAhOSLW/RC+oguw3ChMqfJW7cBO2Bl6PeNVmzdLO60lH3fXf9Biz0cRmbKtsBI6NbM6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8186
X-OriginatorOrg: intel.com

Hi Tony,

On 5/7/26 8:48 AM, Luck, Tony wrote:
> On Wed, May 06, 2026 at 11:24:30AM -0700, Reinette Chatre wrote:
>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>> index 02f87c4bc03c..cc8620ace7ed 100644
>> --- a/fs/resctrl/rdtgroup.c
>> +++ b/fs/resctrl/rdtgroup.c
>> @@ -4539,8 +4539,19 @@ void resctrl_offline_cpu(unsigned int cpu)
>>  	d = get_mon_domain_from_cpu(cpu, l3);
>>  	if (d) {
>>  		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
>> -			cancel_delayed_work(&d->mbm_over);
>> -			mbm_setup_overflow_handler(d, 0, cpu);
>> +			if (cancel_delayed_work(&d->mbm_over)) {
>> +				mbm_setup_overflow_handler(d, 0, cpu);
> 
> Per your comment[1] should this "0" also be MBM_OVERFLOW_INTERVAL?
> 
> Does the same "delay 0 is magic, ignore the cpu argument and run right away" apply?

More specifically a 0 delay means the work is *queued* (not run) right away. The
distinction is important here since the queuing logic has a "non-reentrance"
guarantee that may change where work is queued depending on whether the work is
currently executing.
 
To better understand this I found the following comments and surrounding code insightful:

	kernel/workqueue.c:__queue_work()
	{

		/* pwq which will be used unless @work is executing elsewhere */

		...

		/*
		 * If @work was previously on a different pool, it might still be
		 * running there, in which case the work needs to be queued on that
		 * pool to guarantee non-reentrancy.
		 * ...
		 */

		...
	}

From what I understand _queue_work() first checks if the work is currently
running (see find_worker_executing_work()) and if it is then it does not matter
if the new work is requested to run on a different CPU - it will be queued on the
same CPU as the currently executing work.

So it looks like that if the work is *not* currently executing then a delay of 0
would indeed queue the work to be executed at earliest possible on the requested/new
CPU. This is what the snippet you quote intends.

In above snippet mbm_setup_overflow_handler() is called with a 0 delay only if
cancel_delayed_work() returns "true". Per cancel_delayed_work() function comments:
	/*
	 * ...
	 * Note:
	 * The work callback function may still be running on return, unless
	 * it returns %true and the work doesn't re-arm itself.
	 * ...
	 /

From above I understand that the work is *not* currently running and the the
other planned change (the if (!is_percpu_thread()) check added to the worker) will
prevent the work from re-arming itself.

It thus looks to me as though calling mbm_setup_overflow_handler() with 0 delay is
ok here and will indeed result in work being queued onto new CPU's queue. 
What do you think?

With this reasoning there may be a current issue since mbm_setup_overflow_handler() 
is currently called with 0 delay irrespective of work currently executing or not?
Fortunately the work always re-schedules itself instead of staying put.

Reinette

 
> Link: https://lore.kernel.org/all/389bd92c-47ba-46af-81cb-9b669533b1fe@intel.com/ [1]

