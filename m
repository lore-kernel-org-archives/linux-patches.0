Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7A5259CAB
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453166; cv=fail; b=SPfFeo5U8C5hJ1BHvaqaWEiOR9F1Q7Jv3oyuI4/D8KUkgbj7ntBJjpUZmaXKdOcryH+6IniOshwURGoePFOcM+JL7WaygNYAYBh8J9WirC+EumDoYG0V8W8JXh2W8QQTMUdL+oAz6zQg122n8sJbfHMQSh6F4s3RUE6xlconyPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453166; c=relaxed/simple;
	bh=T4bvpQgOlCFdvWqX+GErfQGOJkPNsrpA8xGAo+Uzn4I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VR3MqgrQhR5tV1dpH+N0fzhZ9ipSKDU9fK9sOOINNWB8OKmjn06oKsziVTxEU8m2tmHdTYw4t437TFBT1nPAEeFjmXShKXlwB9BJbpCuGA5YSRHSFmDC+0RoLOaR1Vnv3YNfhReG6oq9iLjZETiTK4S5pUP++hL0h+FfrvDPdgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7edmRbi; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7edmRbi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757453165; x=1788989165;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T4bvpQgOlCFdvWqX+GErfQGOJkPNsrpA8xGAo+Uzn4I=;
  b=T7edmRbiGbB2n8gmnjeeav9N8BEEwprUzxYll0WW2xUOHuHHpU6yNIn6
   g1RzSop2PjAWZgfV5VbUAVFvhFA5ou6N5zvzO0PDHpmYLi/A58iMacVBE
   3+PnYxKWNRuwjIV6Go/89LH0ZVBhiRr2IBBWUbUz6dAVT2HLWF2FYiAQj
   Fo8Nyx0HDzVP5b0JRabs8wqEiLFZJGyoVK/b/Z7ks+xGw6vRyS7Wmfh3X
   45OKPRJGl/1ZwU1cNhP+gmHFtL2U69rTChkGOTdiYVxw7r7ikBGWbWuPC
   M28uxBdZ6J+CWnUte/t6pZzEy0df5/zglnKFRLlfh0lgQF6wfsg7BnVlf
   w==;
X-CSE-ConnectionGUID: a0Y0uP+wQHGJUcCJSc6LJA==
X-CSE-MsgGUID: 0kxmONc0SfWInjREc0h5uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59703889"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59703889"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:26:05 -0700
X-CSE-ConnectionGUID: XIL4aujfR8C8EemjlZ5EUg==
X-CSE-MsgGUID: fPFX9WTPSEKNJJ4HrMyXMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="173657819"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:26:04 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:26:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:26:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:26:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hz8C4krq7S9XdBLovdOmQibj/mfqX314VxtrSJkm6Ies8b9exYjpqoX2ub3USSa6jpZm+mUH88E/IVvie3gv1jhpwzAuHenkWBTNg6Fp2ZjG4E/8iPBjtGO/xNQbduXsvhGjsP3ekhLRS4JhO/Z5ZdNkfmqhlN5J+/JLgJakOnmzMECrJ7gZ0aUYndbJJ/UniFPgdxCjalZ3lHRi4ojn7rJxxnYlNWThOol/c7/mOLBqlTSvjGxwCFw7EyhG9GLlkzZA0g5mC+Ji0N4CMwyAtIlB94456Xx/EuVhuSmh9kcGCEyhUZcvVLxMmxmt1mdut3tp+us5rYwvYmfy47XENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cUTuuThtDD3+fnYkqXCNc7t7iA0YvMNjMIDLtFAydA=;
 b=b6GG1DT9LIQ1pxKa75zf/o+3yCbtiRZJkQ5Z52UgL/1m40s3bI8CFZzu54PPAN6H96Roccek1DWBQiYo0rf5jwR7IY2NPQdaj4Ff3Mcj/ZiLqUf1RiBDsVXRfzwKG5VvbgZbpULN7sjZdwsQTR9NVcpPOkN6yyaVWCzTvYPDdlLyYOZAPjvyPQEWS7sLEdZUTlnZu3ApgG3EUjN72gLd5leKy85/B9kLeSEBm53IgeetSaW2DZ7/r8WRVN53i8ppv1GZndqcRBeAnWToXhbs7a/uQD2mpfoTpyTnPP4r+eNNF3XrJesk1X+pyHdpSjAHMO6TEbZLEK+v2U8f8IY0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB9136.namprd11.prod.outlook.com (2603:10b6:208:574::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.33; Tue, 9 Sep
 2025 21:26:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:26:01 +0000
Message-ID: <e1a99d65-afce-4d42-a145-7c13631bbfc0@intel.com>
Date: Tue, 9 Sep 2025 14:25:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/31] x86/resctrl: Clean up domain_remove_cpu_ctrl()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0123.namprd04.prod.outlook.com
 (2603:10b6:303:84::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d26ca11-3afb-4e2c-9a44-08ddefe779a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Nk5GZnJiOVdhT3RXV3c5bCtncjJDcFNaMisvK3R3bDJqVGRRVDU1S3pBaG9q?=
 =?utf-8?B?NHBpYk5IN0tKQnkrZ2JYOUQxa2kwbS9HeDNYNVhpNG1zNmRQeTVFZm9HM1Rm?=
 =?utf-8?B?K3NKWTRLbGFnSjMySVNBV3ovYkR0cFY3SkY2Y1dLbHdqMlFYbWpiOFkwYXZl?=
 =?utf-8?B?QzlidFRtTHQwSFRJMHEzNG8yVHZGdXFJa0E0MDBsTnlEM0owK2VHMWQ2MDdU?=
 =?utf-8?B?M0MyRU9EaDVpcWFPVGUyN3NCRWZSNHdkL2xXRjBsVmU5TCtJa1prVFVoM2E4?=
 =?utf-8?B?UE9GQzRWQy9HcGRnUFpTcHZaci9kTnJKV0V0SkxzaElLV1dVQWQ4M3BFQWkr?=
 =?utf-8?B?UXQ1cFptdnVlY2lleEo3M1lwOVlmd3NWaTZxd3ZlQWxJTEJjRmR6Vk9qNTE3?=
 =?utf-8?B?RG5EYk1mcXhoZG1YMm80ZE1zejFHTEdiTC80ZmhOT2VTZU1JYkUvMUU0Yk02?=
 =?utf-8?B?ZVVwdE9DNFFJbFBtTVR4WlpLWGdCazNXd05WRFNXOCtIZHMzWWUxRGRVNEZp?=
 =?utf-8?B?cEpsZ1A4bHgxckpYR0RqVG5wYSs0dndoUmIxY3FSTlJzQW5LQmdkTFRvQ1BY?=
 =?utf-8?B?cmYwcHdxQm5NWExUc2RpWWJNcDJUYWdkeDlvdXgrSlRyeGJLbjVuWkRqajVo?=
 =?utf-8?B?Mkt6SnorVUprV0dmbDNFZTBoV2xYSkQyRENyeWFCK25hb3FOemRHUTF6WXZO?=
 =?utf-8?B?NEY5dnpNdnpyUC91OHpHR3RTcGF0NFVvSHNDN3hENFdkNTNEVXhGbDVQS3pV?=
 =?utf-8?B?eXJXSXRXbmpFMzF2ZGZlOWdkZkpRUEFxc2JML3kvbXRYM2RPWldPYlhRVVFl?=
 =?utf-8?B?Vzh2M24vdVlJU3pQZ0tock41Qm44d2JlU2dyaWZBSjl6azFIRXJDMzNYR2NC?=
 =?utf-8?B?YUUyRkp2Q1JBL2FqQjc1Y0dFdldIVzFhMHRLZ25WZnE0UTRYQm9tVENHS0lu?=
 =?utf-8?B?QXZreitPZ0swZ0MxQTltQkFiU005YzhRVE5ZYTBWcWRoK0VsNFgyUmptZ1E2?=
 =?utf-8?B?STRzQllrZlN0WDZIa3M2SVJUOUF5YWlqMGhNVjF2OHJ3NEpqbmxUQ2dSMkFM?=
 =?utf-8?B?TFA0dys3V1JWbXEyS2YzN3hwQXNMOTBQTWc5V3VzcHhHYlB5SC95T0ljNnBE?=
 =?utf-8?B?b2s1Z1R2YVJSMjRNa1lyOEt1RUFYa3BoQWJHcU1rTHBwdmtOMnJuYnhWMEpO?=
 =?utf-8?B?bk9UVWVHVDRHZkZnbGg1K004bkZGUVlSOHdWKy9CZmxZNXJiTjZJRE51Y0t2?=
 =?utf-8?B?NWdCNTc5Z1dIN1F1aldlUTltQUFFcmxlU0NhQ1A3bHZ5OElLYW53Qlhqc3F1?=
 =?utf-8?B?SWVtNS9Vb3J5WEdKcVFNK2ZhS2h5UERmMVJwajk2SXJvVzIrcUFvNlpMWXBz?=
 =?utf-8?B?NVZrc3B2OGJrY1N1R3B3MXNFQ2ZDb2NxYjZmc3ZBS3dmS050RFJFdGsrNEta?=
 =?utf-8?B?R3JUUVE5Q2NVS0pjNUttdHJibkNpbWpWWml3cTZYTHh6dWxTNmdSbThkc2Ji?=
 =?utf-8?B?KzRucDlFekE4S29TcW1sNmFLL2N1OWZ1N0FMaUdvYk0xb1hHRkxpRjlhQTZw?=
 =?utf-8?B?OTd0ZDltYmMrV3VmRGFDR0hpU1N3QW5ucFhIOHhjc24vY1NGU240bDBhM3FX?=
 =?utf-8?B?bDN6VTZncHZzSzM4NS9WeXpLSnUzaHcyUzVNNTJ6T1pzcjZJTDAwSFRKVnVv?=
 =?utf-8?B?cVJZUloyRTVES3R2QS9ObFlsZU4ybmJDV0NsTlFQTGt4cmRXNDBTekJIaEY5?=
 =?utf-8?B?YkJ3eURteGhZaWdnNUoyaFRaditvdkhCYTdIamRWa3Y2dE00NFZ1d1NZTEQy?=
 =?utf-8?B?NG00azBZZFAxRGNvaTkrVkErQk1Db2Q2OGRaUFp4V0YzNnc3OWZPYkFrSzVt?=
 =?utf-8?B?eC81UU1DOFlQVWVWTVhOSEV4aGdRWHdGZTQ5Y2RXcGkwUXBra0RGRTZZRGxX?=
 =?utf-8?Q?C/elcyB61JM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEtoQmlkOXJ6K1lxTUVOUzd4clhsN1JaejBuWENqWm42MGRGQWs0YVZKcUNI?=
 =?utf-8?B?OGJOL2h1ZU9nTnJXYmJLQVp6Z2dHLzhFVkhlWlhHdUczWFVOcTRYeGpIVnd1?=
 =?utf-8?B?b3BOc1BaS2dmT2dPWkY0UWdZMEJOTEVjbkxKSEpoZ0NUVjVteFpHT2ZIMVR1?=
 =?utf-8?B?WDNXZytMRGNreTBMZzl5RFhRQURkZWpNVEo0NHdBaWIyNmVOQWN5Q3V5RlBN?=
 =?utf-8?B?WGl4ZFpoSG9wQ013RHoxMnNJeGNUTmtyc1dHdE13Z3hiSUE0N1pOalZGTjUx?=
 =?utf-8?B?WnNCVmVyaVkvb0sycjhRcUQ4TUNiVHlmT2VRWmVxVjBCTXJuMnJLbTBaWlVw?=
 =?utf-8?B?S0FmWnB0NXBDdzZYbmNWQjNtaENTTzRTOVdyTkF0cm8vMlQ0UmhuMkloTFds?=
 =?utf-8?B?L3I0azk3azVFTXE5UXY4MkFGcTNVVDhwaEVCWmZTa2NlU3lBOG4wWVlwWGVE?=
 =?utf-8?B?WkxSbHVYWGNRd215VStTdysxeENPWGZURjliWS80b0t0VXBUK1N6T2Z2MW1q?=
 =?utf-8?B?Q3FzRnVaeXNibjBVbndha09nZitwTDRDYTZRMWJMWlhoZnQwelVXMlJLZEZN?=
 =?utf-8?B?b0FWZzg4THJwWldVYUg0NGlnWWR6dUtUakVzaGpzV21IM2VqQU5lLzhDckpO?=
 =?utf-8?B?aU1QY1B1THkyeEhHTGYxMUJyS0JuS3Rqck91eU1aTFhLR01jaDdjcXlOVXNT?=
 =?utf-8?B?elYrUnczVm5TSm41ZEJJU09lMTdzRHMzZm1WRE5vVUVnUDVkMVV6WWl3NVE0?=
 =?utf-8?B?QWNwREwwR2JZQ0pzOWh0eDFvMldrYzU0OTZVTVlCODRYSlF2Zmp4WW5VL2NJ?=
 =?utf-8?B?K3FIZ0ZPd00xcEs5b0tqMGpsUFltOCsxa0xsa05kTjBHODVIcUdBVkxJWHJv?=
 =?utf-8?B?dTBwYmZjcXIzOHVUNVhEdTBpZG9MbzZwQTVaNFRFUHpESXhST09oZFp0K0pq?=
 =?utf-8?B?NTc4cmlScnBPMDh6SGpSSWZoQjAySzFEd2toNGx2SlpKV29Tdkp5ZjN4ejlo?=
 =?utf-8?B?bWFiMTdobXdsc0J0cGRETEhnQityRVRYSEREQ3U2QXBmYWFodEtVa25JSkJG?=
 =?utf-8?B?Q3paMXZzcE9RVG5LS2RZY0xIWlc0ZGZYWi9Ub3lWTGUzTjVmRTMvbVBOdXNR?=
 =?utf-8?B?a2tHWXN0VG8zM1NFRnE0QTQyMzcvZzFic1V2eEYrK1gzcERQTmtvY1ZEZXky?=
 =?utf-8?B?ZmZjZXNaOWpWSG1zNFpnandXdjB4azdyRHRHejY3RlhMb1Rld3NMWGxZZy9J?=
 =?utf-8?B?aFVxaEFEWVZwOSsvL0JMekRPMDQ5RkN2eDBFa0pCdDNlTDlpWVcvcG05Q1gy?=
 =?utf-8?B?SVZXazdLd3RaNUpxR3UzYWMwN2ZxZnVVUE12RERhR0VTQmlRMnVzNnhUK0dJ?=
 =?utf-8?B?SmJ5TzlTakk1WjNpeC8vdGpwZE9NVU13TUtQdEQrVWFhbk11b1ZnWHFWVWRI?=
 =?utf-8?B?UXlRaXJLVGtVdGxERW1VblZzSTh4djZWSkp1N0thaHNramdNZk5BcVdwOTkz?=
 =?utf-8?B?bUQ1aWltUzZwTERYTkhCbUZDZWFIODNBM2x0SVFwVU1YKzBoQjRiVUJpZXFK?=
 =?utf-8?B?Zm1jZXVHckNpUXRCeTg2eTVMZ1FERDhtdS9HN0pRY2JQbUdUMG5SSHAxN2tp?=
 =?utf-8?B?ZWpxQlF4WHpxNzIraUVmNmJrQzc3SXd0Vyt2anZicHBBVlI2aWI0MTZHVVFo?=
 =?utf-8?B?ajhVWVJEN2RhVVdicURmdjUzQjh1K3ZnOXc0ZDE1TGNvbjFxQ2RpT1lXTm1F?=
 =?utf-8?B?TGUxRE1iUUNCazN4QnhuNVUrdEw2SE9mRE5Qa0RKYjl6S05yOE5Ja0EyMmdw?=
 =?utf-8?B?eFlvelBRZ2tMdTY1OE5yeDExK2MwTlZUZ0JpdGtPY08xOVArMnpxbHZnM0Vh?=
 =?utf-8?B?ZXQ5WTU1MlcwcU9nQWZTaGE1SFZUbE5mZ1pVL2lLL0NOOEcxdGJzL1lGUTla?=
 =?utf-8?B?WTVWSEIyRlpxL1JaY09kMjZIemtlN2RFTS9NV0lPU1VjYUJYdUg3TjAwMHV1?=
 =?utf-8?B?d1YyRHZ4TG1PS2ZTT2F3R1pjSk11MFdEZUN6eks5V2k2ZW5VYzA2L3ZhM3Yr?=
 =?utf-8?B?K0laYm1KbXhNT1ZwdFcyWmJpZ28xZG5zRzdLQ3ZrRXRyQ2VBZ0Vqc1hiejV1?=
 =?utf-8?B?TDUrWkc2d0RndFlZWE56MjBlOXk3MHQ0cXhEcnFqM0daTy95YVlOVWd5NFpM?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d26ca11-3afb-4e2c-9a44-08ddefe779a3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:26:01.5041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19RWvaEvZtDNVBdsSXFH/tD+4uBIpvTema7SS9pXVhY52rYeuJXtYfJf1sbaSrLNJGaEY0rMQrOQO+zxyrA2VPu0xX9JuZ8b43kGPAgU+tQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9136
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> For symmetry with domain_remove_cpu_mon() refactor
> domain_remove_cpu_ctrl() to take an early return when removing
> a CPU does not empty the domain.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

