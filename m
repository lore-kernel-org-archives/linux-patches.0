Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F61E4A3412
	for <patches@lists.linux.dev>; Wed,  6 May 2026 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778091881; cv=fail; b=Vh9ZmQmcvfOEQlyJD941j5bIzXFFBJO+6P9CIqKkmpzpC8eALMSMzrylBD8PxtDxwh6cNyEn6qdXJaKBG5sZaVPD9Y47q3jAxT4hSw0Aracn2QIm8Qxbs5YH2WVKw5avxSYaA1aSLijheeJJBmtK/Z7kx60H924d7SxHWtK3BEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778091881; c=relaxed/simple;
	bh=Uxk0exbAGj71qVToTH22TKfUZd4BaRvOiwRQZ1r39/g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NyPkCPxFixIlap+d8rQLsNQTUT3jPJoBhXkpJI+rQmM6KQ1fKhXvXidLVMb8+YHPQGh8Us2sI2pyO7AghPJsb0eZmPubFatjkY/L8owTkaYfyPMMwl/ZUTxvZ8wZCfJ0T59noU+kniBaxPc6bGZq3QuRVQOXzGagukUwV+qIOwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMWStVeV; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMWStVeV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778091879; x=1809627879;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uxk0exbAGj71qVToTH22TKfUZd4BaRvOiwRQZ1r39/g=;
  b=lMWStVeVPnqBkv0ocZOmoqJNB8TXl4WTakX/XQebthr+cVygaZ+KInzT
   COVh0d58Iy9g+BJ0jRzlBDsOHvkV5M/TYrrr+szVWzO1jij1FW5xTv59n
   AEzIDxH9nmhZQ7RC6vU0d5KkIKTTqmYhPLfq2Fn0E99l8GmC0YLpVG+pu
   0qxqq/4x2pFV0uPg9ijn45lyoxD9Yq6VEHatxjTPlQIdMy0O8CL5TpJrX
   teIeqGcaSBQ1zZOxt/+vnteP/AGlF8t4sXjjL4e4wi4kESqR1rlIhSfdf
   Vc619phjs4VDaXiY17x0KOANa3qaTmCIdXd8MYQ3YndE6ZHE/pLyda7p/
   A==;
X-CSE-ConnectionGUID: IZ+tFXnlTyy5KZ+2wsrtBA==
X-CSE-MsgGUID: yy1yM/AERCKwNruMRQZ8vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="89621870"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="89621870"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 11:24:38 -0700
X-CSE-ConnectionGUID: byO05zI8QtSjScOde3IxVA==
X-CSE-MsgGUID: 9mQ2qbClTBK2RHXM+tnFGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="235213601"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 11:24:37 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 11:24:36 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 11:24:36 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.68) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 11:24:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfZl9/QMWzLNgb293fnvg9Gjgsy1hzHI0oC7GqXmb3MPvNkYNTowmC6zT5I436eOHGKkUBdGrgsyOz3t4YEU1DALnDjUqugvHWBnTIMyVB8JL/7gtCFyZiRbI4LZCDhR81elGlcfCEesw3NAstTTIMKENk3gtO8xkqr4V6D+o5o8g6ASpu6+omvdzUKru7nw4zifaDerk/wWTK0eCJSONEXFj0l03uxy/5a9TLrQOQ36PBc6zZdJvA+o11tJrVIQKXOzfBI9s0F88zW58/dYveh+Japvy9X+5pDd2kWpJiy6JYROBIBu3DYNGIdERX1yGwVLKoBCBzeLD8h3X1G3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8BP06jJH+NlAEVPmtHOj4atG3jpTogNyGatZWp1pgU=;
 b=Tv3iRL2P0n7uoX/HDX4vvD9CY50MsmTClWArk/4bSr/6iDHik6sVUvlJ3Wd7qPRmMeav/lY8FhRa496Vx47EU9vkFSk18aH+csLAWVlu592VIwjsmShE4KXc8Q2Y+WOoRbR+3Df7qmQck3JuEdtUsYIgN2gkCvDMUsl0eZw+2Wd/lt8lKAHoU7tRvvGrcR3LIjpKV1Pfhw6tJOXzUxf4j0kUqzjrhdMPW5/ICFziiD5a7T6H8dU96vrdzq0NHnFPSvO5nyjSo2fuKuee6fFZ/wKk5ogQtJYW7BgvNZYhOYqoxe5Q0l826EgJ21da85aiwn0yaLLgyNJVXw03giOm6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8719.namprd11.prod.outlook.com (2603:10b6:8:1a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 18:24:32 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 18:24:32 +0000
Message-ID: <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
Date: Wed, 6 May 2026 11:24:30 -0700
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
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afp4OkwtPpyIwAC1@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0143.namprd04.prod.outlook.com
 (2603:10b6:303:84::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8719:EE_
X-MS-Office365-Filtering-Correlation-Id: e7aab4be-5f33-49a3-5e07-08deab9cb7df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: K56XT28MS6eYaO8AKKySeahoU95gOy/y+Pve1RnoZ/F+HO80iLdB4bDtWCG8D1JhOMSN63NnCS9S0cGihABmoc6QybyzILp+2uv3dx4UIvFNGsmvdyxKcpwT/ox32Ub8QztICOxLEAWyzqOahyhluhOF5IXK2/70Fg7PnW6ZV9gfGmPef8lLump9E6uEfxHfR/HBhzqkLvZLAQXy0cSgpJ3yz2uV0LCHCBnqXO1tGzo7cr+Wl2vKBxTxCdFzEtpZjvy4EEy8iJML/WEDm0uKzqgDoRUC9nzPzV/wf0uf1sT3JzyRBpNYJ2xqsopejVyH02rdnd80vEbdEXdvwe2B5cXa4Q31BXgBx5jcoGYpjBp0N19e8qRuaRjYw05MymrgDNMhN4B71W9qvfDYRgyBwAurYtTJzKfPKWJoXvPGzSQR2df652nqJav9vqmFiCJwjUpZXZLVeHEi/E535gNVh/bD6Dv9D+CXkeHvTxxE5Zxo/dsneoscjzlFDWQasano/6EOZdz0MdpCLQHlX7+gbIzDNN9ada1HOUnmcEmOncAfkY3i4+2IIXbx8S08KyNNPNVmw7qjd2JJ/vPqK0yzVNtKDSxfGVatqxkiUYQsCJwjeDIFiGvD/A5V1vfPWmqZ1uDJGChKLhiO94NAOxrsSCeTbzg3/16qpcEGtIKuJz9eHvKOS5dNCc77OSNW5g2D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGo5KzNUdVlaeDlvQkFkTVl2SEJOdlcrR20vRXBDRitkTmhZS3VSN2VKc3lP?=
 =?utf-8?B?ckNJbVhzTUJSaURNdjBLMm5XN3ZyaVEyaTJXbUNCdVV3Q2FCTDh1QWVqNlU4?=
 =?utf-8?B?Z1FVMHhGRWZmZmY1UHg1Yi9leGVPWno4WXFUN0xEcEFNTm5IVGVKRHMwb3FF?=
 =?utf-8?B?YWpnWTNpOWVRZWdsY2paWkQrVThlQ3Z1aG1Ec3paZTlOM2s3UENwNlZtdnJz?=
 =?utf-8?B?WFJYdGxRVW5LeGRHdEE5WGx5ak9TV2ZkTFFMNTNuM1d4UUNRZUV2R2djdTA5?=
 =?utf-8?B?bThpVmJpckI0dFZKK2QvWTBsMmErd2JscmR2Y09Cajl4a0x4L0REem5DT3V0?=
 =?utf-8?B?Qys4Uy9ia1E3MDkxb1h6aFFobm5LUUFLSUZrYUsyT29GYU5BNTlGNUxvbGYr?=
 =?utf-8?B?cThrTTdoMnFYck16MGJsYm03ejhERjJDUnlXRy9JYTRzeWxPK2xNMFM1djFT?=
 =?utf-8?B?YXNlWHFTSGdVZ3Bhclc1YkVNRmMvc1d0RnFWZ0FpSTBoaGN1d01JRWU0MktV?=
 =?utf-8?B?bWtIbjR2WEY1WWlMZ3pMajZLZWdCZXRHWGJ4d3czT3VjUzVMNXJkVWxNcU0x?=
 =?utf-8?B?VU1vSExSZGRKVnJRK25jZTQyTXBPbkZ3TEFkbk0yQXBWWE5SVlhrT05tYksr?=
 =?utf-8?B?RzlDbXVpM1J2WkJIZzQ2RnVNNjJ1RGs0Wm9hWVI2QUZVblVRckd0Q29QcWtU?=
 =?utf-8?B?b01aQmpYeUxXMFkyd1YxQ0hyQk9aWERkZFh0b3E2SUF2c29pb0lvNG1Jcnd3?=
 =?utf-8?B?blBTdG9CUW0zdnJ2Mitzd1lHVzkvTy9zZFhxRFBTNFQ5dEpocnI4Y1JjYW9L?=
 =?utf-8?B?VDFpTlBFbURUb0VKbW1QdklPUFdSNEJrSWxxM1RHU21rR0w4WlhvTk9jYi9p?=
 =?utf-8?B?L1g4bkZ5a0MrQ0dKLzZlSUN3eWRMRlpVdmNMNTVLWHZlYVhuazNiNGoxTEFZ?=
 =?utf-8?B?dWtTeGdCK2RIS1krOUlpNVhuS3U5UUUxUXVpdGJZK25DckRVbHZlUWtLUHhU?=
 =?utf-8?B?T2drTkthRU9FenBnOWdXUTV5dnp3endFV1I5R09iSll0VDNyQ09JenJxMnF1?=
 =?utf-8?B?a04xWVdKelgrRzd3WUo3U05UR2lqMHZ1Y3ZDMUp0Mlh2Y2lhN1hUUWt5dlFZ?=
 =?utf-8?B?eXBBY29vdGpFb3Jhc3Q0b3Bvb3pNcUdvckNMYXlpVmZRYzBNVmQ0dWtIRlV0?=
 =?utf-8?B?VDc3WkhqbEhjS2EzeUZ3RUFiU2lSdzE1bU0xTTBURXpjNHJIRHlzN2RDN1JE?=
 =?utf-8?B?SHRRT04xd0lRRFFITWhkcjRGeXRNSkxPdnlHM1NyUDFxQ3RIQlFPbHNPWVA2?=
 =?utf-8?B?WWl0OExQZTFRa3hlTlREd2ZxZ2NHME9qa3FiSlJncG05cmRRdi9uS0dCZnB5?=
 =?utf-8?B?UXNoSTQxTmM4RFhseFJvTjNYZW1HOGxwK3F0ZVFSYVkzRkhwYzY5U3NLbEFX?=
 =?utf-8?B?MTlZN21SZXc5OWpWSDZmbkR2bjQ3UlFBbDBQbi8zN0UyeEZnMThVOGFNK0VO?=
 =?utf-8?B?WDI2TXkzcGxia0c2OVRIMEw1N1JZZVVSdDh5dUJOdTM0N1RQT05zaTcxT3Rl?=
 =?utf-8?B?MnhFTVJmSTJmd29CcDdXQ21JcSs0RVhIKzZGNDNNTFhodEpEKzdVZElxVnZi?=
 =?utf-8?B?Y3p0R3BRKzM5VElSK0pucVp2NFFPN2xPa2kwZklhSlNiQnZsMlU1RHlNWHAw?=
 =?utf-8?B?OERiNVhwWGJWZnhRZWVMcDY5djEwNE03SEdqUDlyWTR2bE1KQm12RmFRTjM2?=
 =?utf-8?B?dU9ta2RXVHZHb1BTNFJzY1BmRFVFTjRoNk9LMGdxODBwY2wxT2VQY2RMRk9O?=
 =?utf-8?B?WEhsd20ybHBqVDVxeEx4dDdOa3JyYkJDenFNNzVwK3A1QWJIMEZaeGx1MGh1?=
 =?utf-8?B?OE1YNmFDVHQ5cmRiOUxWclpFWldwTnBNRFRMSWZkNTFkTmIyd01DeXFRVFEx?=
 =?utf-8?B?aCswdVVROE5GNzRMU3VkaDNzTDE2Q01GblFlQytRZk12dkpjbTRKTmVrUm8x?=
 =?utf-8?B?Y20yWkdZQ3hTcDNyUjZEemNIRHFQRXRybzNFRUpoRTN2Q3FLcTJxVDh4eVcy?=
 =?utf-8?B?V1NhZWs2V3JFdy8rUnRreWFMNG1Sa3hsL2pIL0xLOVQ3bjZrdDNZdzFwbzNr?=
 =?utf-8?B?SHY0QnNEOExaZmJFWFRMcElLQ25YU2czTkZNRm5HK3VQSVFjRSt2ZGJDNWNq?=
 =?utf-8?B?YW9rZmFkZTh1TWxvNG1NeENRN2xwcGRZWVlsNW95cWpYMWJOd2JwSDhjdUFB?=
 =?utf-8?B?U01FQitHT3loUzFMR1R4RkNEWXkxZWRkdFBIeEtGSTA0OXpSa0RwcjRYQ2c3?=
 =?utf-8?B?NzgvUlRzaDlPdUZOWk1DK0txT1pDNVFITXVBVjR5VWNIQVZwQjFsY2tUMGQx?=
 =?utf-8?Q?fhk12IHKpvjo6Nwg=3D?=
X-Exchange-RoutingPolicyChecked: diqLA2rfGMJ7FK0dLWUxt0Mr0CFZly4xui8TFWeZC/3BCrdeON57n+HgCLM/hNF/+ISFDPcH4Qer6F0qk7XEGpfAJuXxuHzzPPA7QPj/26xFSQNf/98X90IwYA5X6kboYZEkVca4ppb4il25u5GqVC9K9EyDysUHMN4UP9rP+6V55U6T0kjFZTNWMlZSXSMPnzPQB8jveopcpoSBuWo+36UuK8dDuE7uohCBChCgZdmW6KSQsXIV4Tz4UvoLx1eZzxI59C47u22fSs7Bfv7oetKTVTv6qs5K6/ASyqRwinIPjbGG4r4YgOFqas1ElLaWEjIZyX4ir+xRGgqi5ld23Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: e7aab4be-5f33-49a3-5e07-08deab9cb7df
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 18:24:32.3720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uola4lcus4uVPV4tsZagiWZ6H1+vycOCJ30iRJtZSOg4oRWFj8KmhOqcy2V2vtR0iwvit+f93mT1u6nH2NrxEc2uHcTlccfuKUnUlXejmT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8719
X-OriginatorOrg: intel.com

Hi Tony,

On 5/5/26 4:07 PM, Luck, Tony wrote:
> On Tue, May 05, 2026 at 02:26:11PM -0700, Reinette Chatre wrote:
>> On 5/5/26 9:45 AM, Luck, Tony wrote:
>>> On Mon, May 04, 2026 at 09:39:40PM -0700, Reinette Chatre wrote:


>>>> I still think that using get_mon_domain_from_cpu() in the workers could work here.
>>>> Here is the idea more specifically for the MBM overflow handler:
>>>>
>>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>>> index 88f1fa0b9d8d..7186d6d02d6e 100644
>>>> --- a/fs/resctrl/monitor.c
>>>> +++ b/fs/resctrl/monitor.c
>>>> @@ -856,7 +856,9 @@ void mbm_handle_overflow(struct work_struct *work)
>>>>  		goto out_unlock;
>>>>  
>>>>  	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>>>> -	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
>>>> +	d = get_mon_domain_from_cpu(smp_processor_id(), r);
>>>> +	if (!d)
>>>> +		goto out_unlock;
>>>
>>> This will get a domain, but it will be for the wrong CPU.
>>
>> If it was migrated yes. From what I understand when this happens it stops being
>> a "per-CPU thread" so how about something like:
>>
>> 	mbm_handle_overflow()
>> 	{
>>
>> 		...
>> 		cpus_read_lock();
>> 		mutex_lock(&rdtgroup_mutex);
>> 		
>> 		/*
>> 		 * Overflow handler migrated during race while CPU went offline and
>> 		 * no longer running on intended CPU.
>> 		 */
>> 		if (!is_percpu_thread())
>> 			goto unlock;
> 
> This is neat. It works well in the case with the above race on the last
> CPU in a domain going offline. But I think there are problems if there
> are other CPUs available, and user takes d->mbm_work_cpu or d->cqm_work_cpu
> offline.
> 
> Here the corner case semantics of repeated calls to schedule_delayed_work_on()

(I ended up creating a small test module to confirm behaviors discussed here)

> are important. In this case resctrl_offline_cpu() will call:
> 
> 	cancel_delayed_work(&d->mbm_over); // Not sync, so running WQ keeps going

Right. cancel_delayed_work() returns "false" in this particular scenario where the
worker is running but blocked on cpus_read_lock(). Since returning false in this case
is described in cancel_delayed_work()'s function comments I believe that it can be relied
upon as a check whether worker is running. There is also "work_busy()" that can be used as
extra confirmation that workload is actively running with example usage in
bpf_async_cb_rcu_tasks_trace_free() but that does not seem to be necessary in this
scenario.


> 	mbm_setup_overflow_handler(d, 0, cpu);
> 		There are other CPUs available in the domain. Picks one:
> 		dom->mbm_work_cpu = cpu;
> 		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
> 
> 			This sees that work is already running and returns
> 			%false without doing anything.

This claim ("returns %false without doing anything") does not match actual behavior.
Experiment showed that the work is indeed scheduled but interestingly it is not
scheduled on the intended CPU per "cpu" parameter to schedule_delayed_work_on() but
instead it is scheduled on the CPU on which the worker is currently running and blocked.
This seems to be a feature of workqueue.

> 
> When offline of the CPU completes, the worker runs, finds it is no
> longer a "is_percpu_thread()" and returns without scheduling future
> execution. So checking for overflow on this domain is disabled.

...

> 
>> 		...
>> 	out_unlock:
>> 		mutex_unlock(&rdtgroup_mutex);
>> 		cpus_read_unlock();
>> 	}
>>
>>
>> I am not clear on whether there are more than one race here now. From the flow
>> you describe it seems that when mbm_handle_overflow() runs on its intended CPU then
>> it can assume that its associated domain has not been removed and thus that it is
>> running with a valid work_struct? More specifically, if is_percpu_thread() is true
>> then "d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work)" will work? 
>> I am trying to match this race involving the CPU hotplug lock with the race described
>> in original changelog that involves rdtgroup_mutex here ...
>>
>>>
>>> Maybe it doesn't hurt for it to perform an extra set of mbm_update()
>>> calls on that CPU?
>>
>> The extra mbm_update() calls seem ok. An extra call to limbo handler should be ok also.
>> One possible issue is the impact on software controller that assumes it is being
>> called once per second. Looks like an extra call can be avoided though?
>>
>>>
>>> It will then do:
>>>
>>> 	d->mbm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
>>> 						   RESCTRL_PICK_ANY_CPU);
>>> 	schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);
>>>
>>> This "wrong" domain already has a worker ... Will this just reset the
>>> timeout to the new "delay" value? Possibly also to a different CPU?
>>
>> queue_delayed_work_on()'s comments mention "Return: %false if @work was
>> already on a queue" which I interpret as existing (correct) worker not being
>> impacted. I am not familiar with these corner cases though.
> 
> Yes. Existing worker is not impacted. Which causes the problem described above.

schedule_delayed_work_on() will schedule the work but will do so on CPU going
offline. Does not seem as though schedule_delayed_work_on() should be used at all
if the worker is currently running. As an alternative, when it finds that it cannot
cancel the work resctrl can avoid attempting to reschedule the work and instead just
set rdt_l3_mon_domain::mbm_work_cpu to nr_cpu_ids to signal that this domain needs a
worker to be scheduled and that to be done by the exiting work.

Combining the previous ideas with the results from experiments I think the following
may address the problem for MBM overflow handler, not expanded to include limbo handler
and untested:

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9fd901c78dc6..2e54042b7ee9 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -852,6 +852,30 @@ void mbm_handle_overflow(struct work_struct *work)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
+	/*
+	 * Worker was blocked waiting for the CPU it was running on to go
+	 * offline. Handle two scenarios:
+	 * - Worker was running on the last CPU of a domain. The domain and
+	 *   thus the work_struct has been freed so do not attempt to obtain
+	 *   domain via container_of(). All remaining domains have overflow
+	 *   handlers so the loop will not find any domains needing an
+	 *   overflow handler. Just exit.
+	 * - Worker was running on CPU that just went offline with other
+	 *   CPUs in domain still running and available to take over the
+	 *   worker. Offline handler could not schedule a new worker on
+	 *   another CPU in the domain but signaled that this needs to be
+	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
+	 *   that needs a worker and schedule it now.
+	 */
+	if (!is_percpu_thread()) {
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (d->mbm_work_cpu == nr_cpu_ids)
+				mbm_setup_overflow_handler(d, MBM_OVERFLOW_INTERVAL, RESCTRL_PICK_ANY_CPU);
+		}
+		goto out_unlock;
+	}
+
 	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 02f87c4bc03c..cc8620ace7ed 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4539,8 +4539,19 @@ void resctrl_offline_cpu(unsigned int cpu)
 	d = get_mon_domain_from_cpu(cpu, l3);
 	if (d) {
 		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
-			cancel_delayed_work(&d->mbm_over);
-			mbm_setup_overflow_handler(d, 0, cpu);
+			if (cancel_delayed_work(&d->mbm_over)) {
+				mbm_setup_overflow_handler(d, 0, cpu);
+			} else {
+				/*
+				 * Unable to schedule work on new CPU if it
+				 * is currently running since the re-schedule
+				 * will just force new work to run on
+				 * current CPU. Mark domain's worker as
+				 * needing to be rescheduled to be handled
+				 * by worker itself.
+				 */
+				d->mbm_work_cpu = nr_cpu_ids;
+			}
 		}
 		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
 		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {



