Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DDF288C20
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770796624; cv=fail; b=PkFzq0YlzWds1wwjI5uqy+ha+aTlnICG90sKbN4Pvvvt7+7G5L2abfQvpEwEycAykCnDf7218qHt0faJKWEpYgFwPL8whpKHY2IwHyNCrSbc/3qGgubO+nmeK89ILyyQt3yKSpe97SyGdWnOz54lkMyLod3PEUXlv/GQETA21eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770796624; c=relaxed/simple;
	bh=GxqfQuOQ73gMgW5gXWss2NFa0VBix2UNcZw2AkYkqFc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gf7IONDTTryRZc0Rt/4mzoQrfasQUJl3CNTch3/10RRebJ69E/4E+kbCpxW4pX3j21VyNyazp1oqAVcr8UEcy7Ww9q3b5gEN0ew6HRNK2cCtWf5k8WavUTgkjw4UxyNEhXNfgL352xn3moBuJj+Y1aUx4r4xfdgg22ftPJhKvuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwHDSzKi; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwHDSzKi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770796623; x=1802332623;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GxqfQuOQ73gMgW5gXWss2NFa0VBix2UNcZw2AkYkqFc=;
  b=kwHDSzKiJV/QmW+g+UALeDKHw62KfZ0LJnJyu3iUi4AY9dyUjlGyi0fS
   VwXRQtULVTRN1/7wld9iXymC+ep0KFjOj038H92FDdv5onbkZkKZziT69
   3CL9iSuGNNlsemErS543IaxhDhahus0kBIjIC8Um0i8StZnJqwEQUcxdd
   STIpyq3TB+gO2Y0YeQGuJmiN1qhBp0wny62zn0KFXZYFbmKfSZDpp1eG5
   qFTghnPDb2li24lcsxMRvaQG1YmH+giiTwnV4UpY75slnTaejFxxCdq4c
   Xng/JLKRV8oAtmtIrBI/2F0ex9n+mEcK7BaWQFaaEAxizmqwC9N+el2e3
   Q==;
X-CSE-ConnectionGUID: 0eR7hBotT4y7nXoU+Voadw==
X-CSE-MsgGUID: PdIb8qHIQ7qiK15xG2Lctg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71835572"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71835572"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 23:57:01 -0800
X-CSE-ConnectionGUID: 0gh+PcLKT1qVxu6ZOidaAQ==
X-CSE-MsgGUID: 2a0ChPMfTP6kU1UvqRApjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="235152504"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 23:57:01 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 23:57:00 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 23:57:00 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 23:57:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+aUpowgrR+JN+gLFlrsInobqc3ieaPRJFuIxkTTZPrA/B8njPWz6GhJyhrIVTIlDXiT4L3dkKBbY6efuY4epslZum1ooDkHh7Qr/pp8AKk1ervQs7QQeKIx5aDrwFibP2jg8LK1tColEpXIZLr+qC6ho5hzYOUcQEwI35EQsHnyM+7nWA5H3Oli0J1JHlw6w4emjgjSjb+WForCRDSois6CDyAVyhZM/GwnEI9VUPwK144MCYP72/k6LWwz8vBf0gkA4Tv6El9PZtUnDlanZrrmrAZL5HEL0pafRoam6T+zwXuql6h7r7kzS1cLLtOkVK5pbXFj/y0XqtowSMowJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPJu4n/DUVPN7yOOIi/cc5VlFGYCiG/EPfOe+RRD+0U=;
 b=MOrBcskifQnIg0SDRZNP5LtUZeQCfjBYTQ+/XpiUeVRNanNOWrsiCWjqqiK3S4tGPTaF5oNBMTQF2DVLcXFIhLRqSoJ1XUotR2ycRA05KfJ0Bdu863HJFMqLls6Ks0ti46eglkVFQun8+RcP9GCLa6Q8A25PlPDkS6pJKQ4JcN21tbzp5v4bVBwokwSwmjtsA8clDxaBpABjuRYgtPapab4MjkiBeDiAIwrraxJbqWEpsz8WI48+uciwN+HZLZ+z8Ie/7wKlZXn2OCwGtgmJmDVylx/xT0xdBIv7aW+41ykN0ZHC7y2KUgd+dniqe2BW1GWSmDWFwpKTQfC9IVEtxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7215.namprd11.prod.outlook.com (2603:10b6:8:13a::13)
 by SN7PR11MB7973.namprd11.prod.outlook.com (2603:10b6:806:2e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Wed, 11 Feb
 2026 07:56:57 +0000
Received: from DS0PR11MB7215.namprd11.prod.outlook.com
 ([fe80::cba:8493:6cff:5cf7]) by DS0PR11MB7215.namprd11.prod.outlook.com
 ([fe80::cba:8493:6cff:5cf7%5]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 07:56:57 +0000
Message-ID: <ad382e94-db03-435c-ba68-8ab11a9e813e@intel.com>
Date: Wed, 11 Feb 2026 09:56:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.19-6.12] i3c: mipi-i3c-hci: Ensure proper bus
 clean-up
To: Sasha Levin <sashal@kernel.org>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>
CC: Frank Li <Frank.Li@nxp.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>, <billy_tsai@aspeedtech.com>,
	<quic_msavaliy@quicinc.com>, <wsa+renesas@sang-engineering.com>
References: <20260210233123.2905307-1-sashal@kernel.org>
 <20260210233123.2905307-5-sashal@kernel.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20260210233123.2905307-5-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::9) To DS0PR11MB7215.namprd11.prod.outlook.com
 (2603:10b6:8:13a::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7215:EE_|SN7PR11MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: 772ad9cd-c9ed-446b-ebcc-08de6943212a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UTEwSzZLR09xZEVSem5nN2tUWXFGcmUrU1ppNkdmdTJrL2l1bXpqZXh3QVFU?=
 =?utf-8?B?bUlCb0huUzZtNUtMUDJjSllmQ0krMmtlb0VFR0JRUElNQzdEcUdoNFdtMWYw?=
 =?utf-8?B?UUEzRHNudDB4YllSQy80THpyMS9FeDU1bUozSnUvZUtqWG9CbysyRlZBUWtS?=
 =?utf-8?B?U1dJNlJzcytqQ3oreU9ldFpnK0hQd0dSQTJ4UitHTmxZbm42RzdoTWlSL2ZJ?=
 =?utf-8?B?S1JVa1dNdHkva2gzT0d3NlE5UlZlMHpvUmQwRkh6cGh2dzl1QkdkckJhTU9y?=
 =?utf-8?B?UXBGajZSWjVFM2F4c0tUR21OL0RLei9VY2MxdUtReTBWZnhrMHF1QXI2Mkgz?=
 =?utf-8?B?QnJZbG8vSmpwUzNHdVRFNVd3MFFmbjhlZWVPc3dXVElDRUpQOVhrNzV0WGpL?=
 =?utf-8?B?S1dKeGp1a0psTVlSVkY1U2VTU0hCd01zWVk0ckVsTkZJdkIwM05PZ1I5QXQz?=
 =?utf-8?B?SG1PMkt0dEM4dVRpSUlQcW5qRHVnbVRySUxDNDMxTVJTS0N4RStCOExBMGVL?=
 =?utf-8?B?NGR1SzlhSjEvTmxEbHY0djhZNnZZQzIrVm1qbUFMWllub3ZUU2RlU1dYU2pp?=
 =?utf-8?B?bU1TMEFHc2REcHVFY29LTjFTa2tENXRxU0pXTWxsdzhzT2cyd0oyZ29YdFNH?=
 =?utf-8?B?anFPbStJL3E1cFAxVkZySjB5OFR3bzRMUFRyOGFoc0xuVDdaRnEzNHV3djdp?=
 =?utf-8?B?ODFFQ2JzZGpUK0EvZEtxZ1VUaThrTzNqT3dnRmNVRE85V210dFdyUE15Ukgy?=
 =?utf-8?B?dVZXdUl4WVJGZnZkNGFPMnR0N0ZMOGwvaGRDaVJMRm5zTGhEL3VMZTBsRjBk?=
 =?utf-8?B?Vjhka0hGZmdZZVVLSHo1Q24zZ3ZQQVkxTFRPcWxtYktNMHo4VnVHZzRmbnR5?=
 =?utf-8?B?dEZZeXZGSXFMQkxTS1I5dStuWnhFK3REZUZ4Y0x0NnNMNi80OFM1cHRDZ0ZJ?=
 =?utf-8?B?NzZMTzFiR05DOVhPYng1T2NJZGsvc3JsQkVtWC9UUThGVlM1bDF5T016Ky9y?=
 =?utf-8?B?VUZRWTZueE8xSkNqODgyeVRlK3dPbEcrMmlBSFAwaisvcVlxd0NQb05JSWpm?=
 =?utf-8?B?STdOUlhGa0RvMjRBY3Y2NHRtbjF1VTdzc3ZGWGdhOVVxVDNzaWFlM3hDeHp1?=
 =?utf-8?B?MWxtdUVoT2kzWmQraml5T2svQkp3ZUl5Um9DeStuMGg1UDdqTTQyTWZBME9U?=
 =?utf-8?B?K2Q4blcwVVVqcktzTlZMaStTakdjdU52elYrUVVQZlJ5R0xNZm1rcytJbXdL?=
 =?utf-8?B?c2JFb1ZOZGdla1hjK3ZuaXVFbGRjNG5sbzJUd2ViUmRkWFJJT3AvNU9nQWlC?=
 =?utf-8?B?d0pPUncxRjFySktRZ3FjbDRUL2JOcmtNVXY0dGxOUnJJN1BkRXhJZ1VLUVk4?=
 =?utf-8?B?RjlYR3hCZG5IaVJTR01OblhUcTVXQk9Ob3drMHBHbkMzVi9DRVEzVDQzVmZV?=
 =?utf-8?B?eVdqVkU2S0FZbEVudk5tenh2MlFEZmZWdDlOMi9ObUhKdGw3QmR0Z2prZGNY?=
 =?utf-8?B?Z3ZNK3VjTjRKM3VsbEY4dnh5NHpiYkxSSytGWTBtTVc0UzNmZE9aOUFpdE1q?=
 =?utf-8?B?em5PdVk4N1oxbjZoK2t0dytXRFBmNEtZSGpGL2dzREJ0OVI5U2dobEl3L25q?=
 =?utf-8?B?QldoS3Z6UzN3QUs5WER6K1p2L3BFU0dxMFJqZWoycW1TWW1tZ1JaeXRVK3Fr?=
 =?utf-8?B?Z215MXNwNEMybjBhbVY4V0d3YS9OSlJTeGRVbzMvcTF3YW1WcStPdDYrWkZH?=
 =?utf-8?B?QnQrR2MvRE1vcmNGZjNmdlNmQjFwTndqNWMrelZLMVp4bTgwY1J3b0tobWZG?=
 =?utf-8?B?aSs3dkdUV0x4QlJRWFNHbzJrZnM2VzNhYjBCSnhzSlpsL04vblMvdUkvbnc4?=
 =?utf-8?B?NVNnSWl1clJFcXNIbTJaTFZvSFB0M2JNL3RZRVB6V3JiK0tOT1lDWkd1dGlQ?=
 =?utf-8?B?eWlzWFV0dFNlWUJQRDJhYXRrVWo2a3NoRnpvTDRKM3B6TmpBbmNMOEFNQmxr?=
 =?utf-8?B?YXBpdDB0QXBlQVVQTHB1SHUwYkpNNE1jVERkU28vZkxHMEJIaG1xNExYNURE?=
 =?utf-8?Q?1Ql2xr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7215.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajA3MUtMYlJMcFFjcFB1bWN0em1GNGQ2VDVQUHh6bnNvbVZuTTlOcXBmanV2?=
 =?utf-8?B?UWFpV1NVaXNzZmZQSTVUd25TdGZtQ0lubDFCZXc1SVIvemNRTnBCZjRTV1Ra?=
 =?utf-8?B?aFlzMWFodGlSWGc5NVlMcVNCV1owVG5QeGUybUtSTC9LZEE1N0RYNVFYM0Fa?=
 =?utf-8?B?WUtkbFA5Z2ZhV1RQMk83dDAxSC9jSVlFaXZPOGFmVm8xalBESEVCeVFLc0hZ?=
 =?utf-8?B?TFYrZzNGVW4zM3ZFZG5TNU5pdEJxRnhvZUFPcHVoRUttTTdLOFNITGpKRy90?=
 =?utf-8?B?OUk0bFQzK0lDaUFOcDZ3b2VzZ0FndXY3Vzd0SFBNNjIvbUlqQUJpYllIVDZZ?=
 =?utf-8?B?cTBzZi9LWWg3c3VMYzZuMkZmZ3BaUStjYzFwdE52YXlwZUV4ZXRLWFNxVGZW?=
 =?utf-8?B?MjJzNGJyQUxjUWRzUUZjaHlESldFc3hxVk0wWnNjZUFvOEVQMU83d09pMUV3?=
 =?utf-8?B?VnJ1WnpiK3F2Mlo5UUZ2NlhLU2pqbGRML3piZHd2Nm03blV4ekFhOVJiek9X?=
 =?utf-8?B?OVFLWFdOR2M3bkh1V1NQZm1DVzBLbFIwR09oYlgrN0Vpb0xiSWRIalN3eUVS?=
 =?utf-8?B?bkpEOVIyb3A1OEVuWUpCQVFJT3VQZkNuWldBMnkwYVJKaWhTQ2ZCdUZSd3Vz?=
 =?utf-8?B?MW9zWU9iQUhXZjJhcVNBOTM4NVlzMXUrelpGTFRBR2VLS3Vkc0ZmbHMyVDhZ?=
 =?utf-8?B?QkEyZ1oyS2gzZ0xJMERtZnE1dmFMd3c4d3VWczRIL1Z0b2IvRXZVVTludVYw?=
 =?utf-8?B?M2RPOTNHL2E1bjFxRHpqUHNLZ01JODJreGJSSzl2NnpUVDI2cGFDMjh3WTM3?=
 =?utf-8?B?alhERXRrME8wU0JkSHVXcFhVNUdlM1pBL3FaUDFxY2JheWpqT3JFMlpRWTE1?=
 =?utf-8?B?NVRvT0NTL2hGR0JORE5nYy9YSkVDSkVEbjFKSm9QNUIzQTA4Vjk1OWx4Y0Jj?=
 =?utf-8?B?YUd3dU1RWm1PMmNsUDJpbGVQV2JvZE1ZVnpjRkVSalJHaEhKSjBJWUNuQTVp?=
 =?utf-8?B?eTRmZ3pDYXd4Nlg1bnhVbHdlelVtUUJrQVlCakFHQzZVSXVhNzE5c2liUmRB?=
 =?utf-8?B?d0dhQ2h3SW5DOGtnTlhESEZvTUt1aURJc0JBOGhVREJ5c1JoclVaSkRuV0c0?=
 =?utf-8?B?ajQ5TGNyMEFML0NLc0xkSnRlZmlrdms1aHMxZ2wrOUxzTEFObmc3OVlkUGhR?=
 =?utf-8?B?bFdrU0JlLzRmVmREWGp1b1ZoWGVLT2JtZCswdUowaDNkSkNpRXk5elVVWGhN?=
 =?utf-8?B?bWNpVVVjVkRSTkY5bDJCdWE5NmpIN0pBeHBuVnpZSVYzdzgxa1ZSOVlVVUE4?=
 =?utf-8?B?azFybTRPTUlKcGpiZWhRRUo0cFdURk5TWmFWVDdUbkp3cjdkYTVUb0hSc0dE?=
 =?utf-8?B?ZGdGUzUzcU82UVp6N09vRlFFaHJIazZYVlJ2SW8wWlJ0TDlUeEFsZm5yZUEw?=
 =?utf-8?B?RzRaZ1BOYktUUzl1NnhLQ2pCeFFGMjUzS0tseDFlY2VlVXI5VEg2NjNVUHZi?=
 =?utf-8?B?M0ZSYXM3NjMvVGlMbHlSYkVmQkhDVU1td0Z5NFdQRm1wM2tXK3ZqRUhjeEtz?=
 =?utf-8?B?OStFNERPNXh0U0JPNldYR204bEozQ1FZVHR1ZzZkMlZnV1NRWmdCcW5rQnhT?=
 =?utf-8?B?aGIva3lQMnlyTzVBSys0WlYxZFgzZFZWeEhJdExtNmVYT2szQ01VOXMvNUhF?=
 =?utf-8?B?Tm9sN0kzSVpjT0xDUjlLYk9FQkdUUkZCdUdZMUtwWUZvL3ZWMW5jSVBtenhs?=
 =?utf-8?B?SFV3N05IeE9FTndnWHRVSCtpbFhvTzRobUNlM0t5WERyZlRmRE5hMEdjRWRG?=
 =?utf-8?B?TUs0U1RZdUlta1BSZ3RmdEJHa2o3eWg4RFh6aG9tL3U5V0xwdncxSE9xREY4?=
 =?utf-8?B?VklkeTVpdTFBM1lRcnMvNThqY3VUV3hVQnhIb0h6QklMQkt5TjJGaUVHczZ3?=
 =?utf-8?B?U1RRS3c1RTk3TUI0dTZaQS9zOGlKNUZqWVdqeXg1aXFCSUdxSy9LcnZqSkE3?=
 =?utf-8?B?NVRaSHVhcEdvVHg4N2pkWlZNTEdONU1nbWt6bVRTNHJ3ZUwxQUNwTlZESmZC?=
 =?utf-8?B?NGRjR1FFSHA3NU1TMmRFUXVJd2VObnZGY1lSMzd5azk1a0pDaU5iTFIvY2NC?=
 =?utf-8?B?Qk13Tys3ZGZuSlYvMDB5ckJLY1llTnNkb1hXV1VEc0Qwb0dSeHU0a3pjdDVU?=
 =?utf-8?B?YnRZdTlmaDRYUUE3dkN6U0JpWHNlaUJWUVd2NzJPN2JZdTFBbEROTGlhdGF5?=
 =?utf-8?B?TFRrbC9OTkxSZU42V3FqVDFjVlRuTjlsSlpueXU4bC8raGRUcjVOa1IxZXIx?=
 =?utf-8?B?YXppQU1LUGlna0k1WUZUZlBRWWkyaktPdjFmMU5qWUNmUENMYklzQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 772ad9cd-c9ed-446b-ebcc-08de6943212a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7215.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 07:56:57.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUH2tk+TMHU8YRlwrEEMZuTfkldJiG3VWp57wwFnlPeZMQGhAFHGTmqqHfuVymn+vo1i9CftaOFTyyY6tXy8uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7973
X-OriginatorOrg: intel.com

On 11/02/2026 01:30, Sasha Levin wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> [ Upstream commit 8bb96575883d3b201ce37046b3903ea1d2d50bbc ]
> 
> Wait for the bus to fully disable before proceeding, ensuring that no
> operations are still in progress.  Synchronize the IRQ handler only after
> interrupt signals have been disabled.  This approach also handles cases
> where bus disable might fail, preventing race conditions and ensuring a
> consistent shutdown sequence.

To expose the issues raised by AI, it would require either a misbehaving
I3C target device, or an I3C target device that attempts hot-join.
However the driver does not currently support hot-join.

Also, as I mentioned before:

This patch was part of a larger patch set to enable support for
Runtime PM.  There is also no support for System Suspend at this
point.  In my opinion, someone serious about I3C usage would want
power management support, and would therefore back port the
entire patch set (and the subsequent System PM patch set) to their
kernel.

Consequently, I doubt back porting this patch separately helps
anyone.

> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Link: https://patch.msgid.link/20260113072702.16268-3-adrian.hunter@intel.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Good. `readx_poll_timeout` has been used in this file since its
> introduction. The new `i3c_hci_bus_disable()` function uses the same
> pattern. No compatibility issue.
> 
> ---
> 
> ## Detailed Analysis
> 
> ### 1. COMMIT MESSAGE ANALYSIS
> 
> The commit message clearly states the intent: "ensuring that no
> operations are still in progress", "Synchronize the IRQ handler only
> after interrupt signals have been disabled", "preventing race conditions
> and ensuring a consistent shutdown sequence." This is unambiguously a
> race condition and shutdown ordering fix.
> 
> **Author**: Adrian Hunter (Intel), a prolific and trusted kernel
> developer.
> **Reviewer**: Frank Li (NXP), an I3C subsystem reviewer.
> **Maintainer**: Merged by Alexandre Belloni, the I3C subsystem
> maintainer.
> 
> ### 2. CODE CHANGE ANALYSIS - The Race Conditions
> 
> **Bug 1: Bus not fully disabled before cleanup**
> 
> The OLD `i3c_hci_bus_cleanup()` does:
> 
> ```155:165:/home/sasha/linux-
> autosel/drivers/i3c/master/mipi-i3c-hci/core.c
> static void i3c_hci_bus_cleanup(struct i3c_master_controller *m)
> {
>         struct i3c_hci *hci = to_i3c_hci(m);
>         struct platform_device *pdev =
> to_platform_device(m->dev.parent);
> 
>         reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
>         synchronize_irq(platform_get_irq(pdev, 0));
>         hci->io->cleanup(hci);
>         if (hci->cmd == &mipi_i3c_hci_cmd_v1)
>                 mipi_i3c_hci_dat_v1.cleanup(hci);
> }
> ```
> 
> `reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE)` merely writes to the
> register. The hardware may still be mid-operation. Without waiting for
> hardware acknowledgment, the subsequent cleanup proceeds on a bus that
> is still active, which can cause undefined hardware behavior.
> 
> The new `i3c_hci_bus_disable()` uses `readx_poll_timeout()` with a
> generous 500ms timeout to wait until the `HC_CONTROL_BUS_ENABLE` bit is
> confirmed cleared by the hardware, ensuring the bus has truly stopped.
> 
> **Bug 2: Use-after-free race in DMA cleanup path**
> 
> This is the critical bug. The old flow is:
> 
> 1. `reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE)` - request bus disable
> 2. `synchronize_irq()` - waits for any currently-running IRQ handler to
>    finish
> 3. `hci_dma_cleanup()` starts - iterates rings, disabling per-ring
>    interrupt signals and freeing DMA buffers in the **same loop**
> 
> The race: `synchronize_irq()` only guarantees the *currently running*
> handler has finished. It does **not** prevent new interrupts from
> arriving. Since the top-level `INTR_SIGNAL_ENABLE` register is still
> armed (it's only cleared inside `io->cleanup()`), the hardware can
> deliver a new interrupt *after* `synchronize_irq()` returns.
> 
> If that happens, `i3c_hci_irq_handler()` runs, calls
> `hci_dma_irq_handler()`, which accesses `rings->headers[i]` (including
> `rh->ibi_status`, `rh->resp`, `rh->xfer`) - DMA memory that
> `hci_dma_cleanup()` may be concurrently freeing with
> `dma_free_coherent()`. This is a **use-after-free**.
> 
> The fix splits the DMA cleanup loop: first loop disables all ring
> interrupt signals and ring control, then calls
> `i3c_hci_sync_irq_inactive()` (which disables top-level interrupt
> signals AND synchronize_irq), and only then the second loop frees DMA
> resources.
> 
> **Bug 3: Same race in PIO cleanup path**
> 
> The `hci_pio_irq_handler()` accesses `pio->lock`, `pio->enabled_irqs`,
> and other `hci_pio_data` fields. If an interrupt fires after
> `synchronize_irq()` but before `hci_pio_cleanup()` disables PIO signals
> and frees `pio`, the handler will access freed memory.
> 
> The fix inserts `i3c_hci_sync_irq_inactive()` after disabling PIO
> interrupt signals and before freeing the `pio` structure.
> 
> ### 3. CLASSIFICATION
> 
> This is a **race condition fix** preventing **use-after-free** during
> driver cleanup/shutdown. It falls squarely in the category of fixes that
> should be backported to stable.
> 
> ### 4. SCOPE AND RISK ASSESSMENT
> 
> - **Files changed**: 4 files, all within the same driver
> - **Lines added**: ~40 lines of new code (two helper functions + loop
>   restructuring)
> - **Lines removed**: ~5 lines
> - **Complexity**: Moderate but well-contained
> - **Risk**: LOW - changes only affect the cleanup/shutdown path, using
>   established kernel patterns (`readx_poll_timeout`, `synchronize_irq`)
> - **Subsystem**: I3C bus driver used by Intel and AMD hardware (active,
>   maintained)
> 
> ### 5. USER IMPACT
> 
> - Affects users with MIPI I3C HCI hardware (Intel, AMD platforms via
>   ACPI)
> - The bug could trigger during driver removal (module unload), system
>   shutdown, or suspend/resume cycles
> - Consequence if triggered: kernel crash, memory corruption, or
>   undefined behavior from use-after-free
> - The AMD ACPI entry `AMDI5017` shows this driver is used on real
>   production hardware
> 
> ### 6. STABILITY INDICATORS
> 
> - **Reviewed-by**: Frank Li (NXP) - I3C expert
> - **Merged by**: Alexandre Belloni - I3C maintainer
> - Already in mainline (v6.19)
> 
> ### 7. DEPENDENCY CHECK
> 
> The commit is **self-contained**:
> - New functions `i3c_hci_bus_disable()` and
>   `i3c_hci_sync_irq_inactive()` are introduced and used only within this
>   commit
> - Uses `readx_poll_timeout()` and `synchronize_irq()` which exist in all
>   stable kernels
> - `<linux/iopoll.h>` is already included in `core.c`
> - No dependency on other patches from the series (the other patches in
>   the series appear to be PCI-related, not core driver changes)
> 
> ### 8. BACKPORT CONSIDERATIONS
> 
> For older stable trees that lack `9e23897bca622` ("Use physical device
> pointer with DMA API"), the `dma_free_coherent` calls in
> `hci_dma_cleanup` use `&hci->master.dev` instead of `rings->sysdev`.
> However, this is in the *unchanged* part of the code (the second loop),
> so it should apply cleanly or with minimal context adjustment.
> 
> ### Final Assessment
> 
> This commit fixes a real race condition that can cause use-after-free
> during driver shutdown/cleanup in the MIPI I3C HCI driver. The bug
> mechanism is clear: interrupt handlers can fire after
> `synchronize_irq()` returns because interrupt signal enable registers
> weren't disabled first, leading to concurrent access of memory being
> freed. The fix is well-structured, properly orders the shutdown sequence
> (disable signals -> synchronize IRQ -> free resources), and is self-
> contained with low regression risk.
> 
> **YES**
> 
>  drivers/i3c/master/mipi-i3c-hci/core.c | 32 +++++++++++++++++++++++---
>  drivers/i3c/master/mipi-i3c-hci/dma.c  |  7 ++++++
>  drivers/i3c/master/mipi-i3c-hci/hci.h  |  1 +
>  drivers/i3c/master/mipi-i3c-hci/pio.c  |  2 ++
>  4 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
> index 607d77ab0e546..0a4d8c9968c9b 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/core.c
> +++ b/drivers/i3c/master/mipi-i3c-hci/core.c
> @@ -152,13 +152,39 @@ static int i3c_hci_bus_init(struct i3c_master_controller *m)
>  	return 0;
>  }
>  
> +/* Bus disable should never fail, so be generous with the timeout */
> +#define BUS_DISABLE_TIMEOUT_US (500 * USEC_PER_MSEC)
> +
> +static int i3c_hci_bus_disable(struct i3c_hci *hci)
> +{
> +	u32 regval;
> +	int ret;
> +
> +	reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
> +
> +	/* Ensure controller is disabled */
> +	ret = readx_poll_timeout(reg_read, HC_CONTROL, regval,
> +				 !(regval & HC_CONTROL_BUS_ENABLE), 0, BUS_DISABLE_TIMEOUT_US);
> +	if (ret)
> +		dev_err(&hci->master.dev, "%s: Failed to disable bus\n", __func__);
> +
> +	return ret;
> +}
> +
> +void i3c_hci_sync_irq_inactive(struct i3c_hci *hci)
> +{
> +	struct platform_device *pdev = to_platform_device(hci->master.dev.parent);
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	reg_write(INTR_SIGNAL_ENABLE, 0x0);
> +	synchronize_irq(irq);
> +}
> +
>  static void i3c_hci_bus_cleanup(struct i3c_master_controller *m)
>  {
>  	struct i3c_hci *hci = to_i3c_hci(m);
> -	struct platform_device *pdev = to_platform_device(m->dev.parent);
>  
> -	reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
> -	synchronize_irq(platform_get_irq(pdev, 0));
> +	i3c_hci_bus_disable(hci);
>  	hci->io->cleanup(hci);
>  	if (hci->cmd == &mipi_i3c_hci_cmd_v1)
>  		mipi_i3c_hci_dat_v1.cleanup(hci);
> diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
> index 951abfea5a6fd..7061c44243424 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/dma.c
> +++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
> @@ -162,6 +162,13 @@ static void hci_dma_cleanup(struct i3c_hci *hci)
>  
>  		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
>  		rh_reg_write(RING_CONTROL, 0);
> +	}
> +
> +	i3c_hci_sync_irq_inactive(hci);
> +
> +	for (i = 0; i < rings->total; i++) {
> +		rh = &rings->headers[i];
> +
>  		rh_reg_write(CR_SETUP, 0);
>  		rh_reg_write(IBI_SETUP, 0);
>  
> diff --git a/drivers/i3c/master/mipi-i3c-hci/hci.h b/drivers/i3c/master/mipi-i3c-hci/hci.h
> index 249ccb13c9092..5add9c68434bf 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/hci.h
> +++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
> @@ -147,5 +147,6 @@ void mipi_i3c_hci_pio_reset(struct i3c_hci *hci);
>  void mipi_i3c_hci_dct_index_reset(struct i3c_hci *hci);
>  void amd_set_od_pp_timing(struct i3c_hci *hci);
>  void amd_set_resp_buf_thld(struct i3c_hci *hci);
> +void i3c_hci_sync_irq_inactive(struct i3c_hci *hci);
>  
>  #endif
> diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
> index 710faa46a00fa..9bf6c3ba6bce9 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/pio.c
> +++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
> @@ -212,6 +212,8 @@ static void hci_pio_cleanup(struct i3c_hci *hci)
>  
>  	pio_reg_write(INTR_SIGNAL_ENABLE, 0x0);
>  
> +	i3c_hci_sync_irq_inactive(hci);
> +
>  	if (pio) {
>  		dev_dbg(&hci->master.dev, "status = %#x/%#x",
>  			pio_reg_read(INTR_STATUS), pio_reg_read(INTR_SIGNAL_ENABLE));

