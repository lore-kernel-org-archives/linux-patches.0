Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D231917FB
	for <patches@lists.linux.dev>; Fri,  8 May 2026 00:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778199827; cv=fail; b=ADRbpiI9eCyT3+dPa8FRzeMAAsUuRI1c0z4u9EPbKNZSXiTqxDcJyd8KV38Ybg/Ba8ar54T33YlZLwsQ90i5yZYwc++KqQpkFwMnW4DAM9r4lwjwKndgRzEFuFAycUKPtjKeb+rWz2wKTQCA0WLGnbPlQS9tjMXTEW1kyG3tTt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778199827; c=relaxed/simple;
	bh=k368iNfjHLzEeUzUMEEkoEIOec28Y3BhNESuotFllOA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QW9yn474pknOK6ieGwQOaQjnBlU401liECEnGEhdGxhdvjoreL7fQojSqwaT4r/PjmqYLKCEcjlGZttjAvcSh8DcFXxSUHFYmTHc/LCeoQYjg7YQj7tMtvomcTyUIq4Lz0Di71hCOwm+lPGPa3C8sg7SfOaYo2aQuXux7t57EkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m2nnbqVK; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m2nnbqVK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778199826; x=1809735826;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k368iNfjHLzEeUzUMEEkoEIOec28Y3BhNESuotFllOA=;
  b=m2nnbqVKsyMLtTPaxqgCNtR/nyQsuhQT0BiP6P9XS+5V1rnD6ei0FhXN
   /fkc0uFtqNq/74UZYhNtOg80l8T3yRAv/D7zmdAhlPXZ2/v+u6pOWldyg
   pMT9qr9Jph9Mo4A00R7izlxQ9l6yMXD3Z3qPoQ6wBjI9TAzjRRWPuTs1L
   zllyCC6GcUSfCL+a5DujgwuEUhZ6EO3tqauVIZnCGM3UgAJke1WJpl5Oi
   lTCR2kKgetZFuiP8EXhiDz4aMUaUnTlpKfNGHYbSdp2pEgnGn1hytptiR
   DlnI/mGJ+hpkwDz3xy3Bf8tPuUipz0F6NdBzbdPH86A8QhQ3gh2YPBfEk
   Q==;
X-CSE-ConnectionGUID: TXQvHHVDR0e/8BY7ZPUhSA==
X-CSE-MsgGUID: sSRiaOKhQV+n+Nl9uHRgQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="104624218"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="104624218"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 17:23:45 -0700
X-CSE-ConnectionGUID: nsYebPseQa6+IYOz/Q4NZg==
X-CSE-MsgGUID: sV0NkpThTMiTylxS/0X5UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="235785420"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 17:23:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 17:23:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 17:23:44 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.21) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 17:23:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MoUlStdxOOTnmTx+aLET440WmzP6YEwlMP/TC+7QnMpUxlrR9nfRxdEUs8xtEfXHxBDEiIeanKg5Sgn/YsZ/E53zP6WlHigN4D/FrczX0qSW3KJxccVK9ki8ELzKKertuRfh1rClRQoi4seqLkSBY0b9Ryzd3H/r33I+9JY2y5Z8UZPXKO0zIPKkCbc9dkfaGisiOvK+WAtwYDG0/WDHPNHz3a+KsZ+xXSWjaZ5u4NwxjSzT6NL/5TpnMmNZd24sfRPSsMKtJAxLlCxG6t2UHkMOdSkFbY0i0hn94xxcQLX77+UyDaZzWdcSIF2P73O59Mls4G3ET7/GYmHcmjJs1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBKxGSG/UM8v28uVmP/mf74MJrWx3hJUB7d1gLJy0CQ=;
 b=MY9UVx65hrMT5mp5PU6ehh6y8sLlK9N5CkOvg02Px/xl21uAyy66rvkdaNk5Xpdw313QtsvIWOdjavZKt3sjF0musHCl0ytmmFygCCoB8ajrm97ZJLHT34u1918rAGu2o4Sx92rZbrWPcglqxEj5/MZXknFRUYgzk3fZvFuxQFgvwlPqxAIm0RusDCUzXoqQqEMzBhg/iCPA8UyjBLRg1XRN4CcGcjCeEuClz8VZA9E07S48AhMDHkfLFDz5jw0Z7kn6+t2q86D50PQdj+CrBcZZdjt6UfNSh5NY9HiCu7Sngphxp3LjzIy5cnWHF+cySFInRBb2YWxeA7Ex23234Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA3PR11MB9487.namprd11.prod.outlook.com (2603:10b6:806:47e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Fri, 8 May
 2026 00:23:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9891.015; Fri, 8 May 2026
 00:23:37 +0000
Message-ID: <473d7fd6-fefb-4b68-bca0-33f3cd89b95d@intel.com>
Date: Thu, 7 May 2026 17:23:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/resctrl: Fix deadlock for errors during mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260504220149.157753-1-tony.luck@intel.com>
 <5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com>
 <afzQFkVPiNW8QR8J@agluck-desk3>
 <d3b1f1c1-266f-4d17-a049-0f12cf5a9360@intel.com>
 <af0kGMDXHBBjOyhU@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <af0kGMDXHBBjOyhU@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:303:2b::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA3PR11MB9487:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eb8a5bc-21c6-440b-6f7e-08deac980bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: KdTwh+L2n8GAWTduaAq7nxPvSQL2hee6XzqcgQjpm9E8aBr/1vt28A158S17rx7dKvc8coAnCGLPb1+nzov2jnBZHCXFs6udZ0Dt+fL3RTmpr9kVUG2rnNlkvyzZCAZWarF7aJxOc1IuSDjeWaJjAIrgwjNadw3DvnNYoSXQTMtpTrSwjWpqBjnQf1VwJ1By5OJW42xEvpH7qrLi1ZzFhzQDWhfOzt8MsfTuLu3m80Ojqe/LIPdrrFHfcaU616a5DnUPghK/X4w3uoDklQosyVMoZskErVO/LOLLIJ4grCsfKlgboNwSdjEP4ZO2+NsHDLOmY86ReVHPVo3WfKCodBmuPlN2ZQjuBPBVLUHq8AQtS74Zm7TVkvuzS8HroKAV5ZUK9OIDzHoRmNSN2JR45sreg9CxM7v9cgHUvfClkbEDKv9Nzwdm/E03DZMvFrcno5q0E7xZM76jQjXxwEev+zazpDqNYwxiq5t71lljvoH8z0/GRDuT9qcwTBy3V2qRlFmfU/zZPA/yFAGVk/ErqW/X5P1lZ53YXyuTY/G4Wf6ZAujZtFooAFbdwyEzNprTQKYynbOK4I19INw/7ajeJb1KoWYyuGzv4CmnVH8f0g0bDpMKFt8HIoK3MivnNevJ01WjOJy4dxWtbZPUtwMcaSQRj4gZzyX6iMCDA8dHfWrj9vvjGDBnRzcpL+zdVrCj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0Fnc2xkOW40bjFBbXpjNDVGMW1pSEZMZmZZNjNaWVR5TUpPV0srdlJJK2Fs?=
 =?utf-8?B?enJadlh0bHlMUXFRMlJmdk1QeStSMmdzUG5xSlVZSFA0TmxmbmF3aDVUZ25t?=
 =?utf-8?B?dHRxdXlIUTNDdE9jYzFIRTZIb2RsSE1Kd2hxQnVvUEg1TGtNS2FZb3p3bjBx?=
 =?utf-8?B?TlhocnlpWW9RRVdSN25SYnhmb2JaZmtWcFh3RURXcHVtZzZ4SUZrSHdBZ3Z5?=
 =?utf-8?B?MHlmYzNnR2xIbGJrckpXNGF3b1lQcUI3UldxSW1sWEtWMFQzc2ZBTG80clBT?=
 =?utf-8?B?MnhlMzZjcytJaFpXL0pmY2RsZWgweFltbGdhQjRqWW5vVTllTU53WDZCN0No?=
 =?utf-8?B?c2RDa1pDWFhFUzRwRENlb2FldnNDRitVM1o2c1VUNFJTd3lXWEQxcUNENXVJ?=
 =?utf-8?B?UVR5a3NvVGN0NDFZYkxROTdZUUd6Z3BHa3FMSHlKU01SKzhwdFMvejd1UzNo?=
 =?utf-8?B?WGdMYkdwakZ6dWNIVE9TdmZxdHBDYld3VjQ4cldCNnppQUxEczBET1d4RlZ2?=
 =?utf-8?B?SlkzM1k2VUFBcklMWWJxN2g4VFdvMXVTdFFXYlk0ZmdkaUdyY3U1aWxKc0Ur?=
 =?utf-8?B?SlRIMzJHZXlERDJRbmh1U3VCOE9Ga3ZxM1dPdGUvU25VVUJlc05SVmwrSGlP?=
 =?utf-8?B?ei9acjJWdVFDYk4xOXBNNVJaV1V6RnB3VGw5WHJUMytvazJHKzIrZThXaXR3?=
 =?utf-8?B?WEFoMzNEWHlYTmpsWVdLK2l6SXNmV2Joa2swNW1PREJCZ0ZGMUFackhpY0d1?=
 =?utf-8?B?dHlpZnYxQ05ldnUwT3hlck1XWXRzdG9kNEV0WkVHRGlsMkkyQWQxUTBCV0xj?=
 =?utf-8?B?cVV2RGxTcGdPTFNGTVEvRCt5eTNOamhYRGRZYXA1eHA3QktvaVNMZUdrRDNq?=
 =?utf-8?B?T0RGd0g5WERDdlkxbHc3cmR4VmcwSlRGTXhGU2FwRzdTRXhTeThCcnJ3TnhB?=
 =?utf-8?B?RG1zKzNMMERoTHh1VVhkVkNZM3hHNU5WOVdWcS9QWlJJaW9jWnQvL3VhMUV0?=
 =?utf-8?B?cGllME5zS3c4MTZNU29GZ25zSzBLU2xKRG9NMnQ5SHFybTBZTVVxazkxbGFF?=
 =?utf-8?B?dFdUbThKNTFwK1pZa280L3h2Um9NczB0aS8yS2QvanJYK25VcTN5NVV4eEFz?=
 =?utf-8?B?NnBtZEZTY2dtS0JoNG1hdmFKbFI3WFpHOWlKcXZ4M1VsaVdJZTBRRzJKKzRz?=
 =?utf-8?B?cHcwd0NMR1d4YlMxblovOGlHYmI5K0Y1eG1XeTRjeDZkWkg5dkhqWGJ5cEs3?=
 =?utf-8?B?MlJOcEFEUjRRWDErWHRjZXkwQithTy9TMkxqa2xnOWFqNldmZWljL0VTK0NU?=
 =?utf-8?B?OFdieHdRY2pVMGJxVXE3dXg0VDlXU0lKUklIN3VwbEFyMEFINUdMZG9pTCt4?=
 =?utf-8?B?byt6U1paSnUxcEx0VUo4a2h1Q0dqbHhraUFqYk54MU5OdmxyZ3lHT2QyblAv?=
 =?utf-8?B?d0kvWG9EMkVvL1BydmdId09IdUJYd0Y0bnF3azNXQW5SSFB3dHdjdXkvbzFa?=
 =?utf-8?B?ZkZrV1B0MXc2ODRKNkY4QSs2N2pXVGlicjNJaGRWYjRxb0F2UXEwUmVDdnFU?=
 =?utf-8?B?Tlo0UjJpbTg5T2UvZVZRZmpMNllGdHlVQkt4SFovby9ka0psZk1rc3ZBSFp5?=
 =?utf-8?B?c2NxQ1FHT1M4Y2VpOWVzNkNZYWZqN0tpbjh1U3RjRWxNM3lvUlBxSXpFRDJs?=
 =?utf-8?B?d1V5S2RoeHhnTmVCaTFGSjhMY2pvS2RuVDFaYUhzcnZVdTRQQzI2VDkzeUNl?=
 =?utf-8?B?WFhZNU5tbEFGdzJnVE5abTNIUnRROEVoZWExUFNkVXdhRm8rT2pzQ0ZyQ0Va?=
 =?utf-8?B?T1VLVVpvYlU2Zk5ubnR1TVJFZXM2TUV0R1hRek54bzRqWlprNWsxdGNzODk0?=
 =?utf-8?B?Uzc3RHlZMDBaTUIxbGFOV1ZlMUZ6K1lZZEEzQ3IrSTErSzlKMDBCd0J2dHcx?=
 =?utf-8?B?RlZvNWNIdUd0eEh4TGlUTkpVdUF2T01TWHZHa3UvVVA0QlYyRzlkTHZwcUFZ?=
 =?utf-8?B?aXdiZWJlU0M2WTlsck9ML1V6bDljSUpxNVV0VWwxYmlHMUtOcG0rd2NYbzUw?=
 =?utf-8?B?YURqdWt3bGFGaDV3dnlGUlJTYmZaVUh3SGNTdjl1L20ySTJLVlYvN0ZlWVp6?=
 =?utf-8?B?S25EUnBSTW1hNXpvREpzTjIwalg2ZndsdVB0U0piVGpEdDdlWU5SWE9Ucm5h?=
 =?utf-8?B?NEQ4czk3VU5WMlU3aW80ZVpGbC81Wms3OUc2eDVHSDlQWTVLeGdoYVUrd2t6?=
 =?utf-8?B?M29JQVhBSk1ncnpXdjgrd1p1bHFpdTRFV0pERkR2aFN1MncxM3kyWkJXeTMy?=
 =?utf-8?B?VlhaOFJzdG1OZms3QTIxRVFRTGk4MVk2L2l0UzdCT0p6WHVESEJFMWRja3F0?=
 =?utf-8?Q?q6pSb2dPxs3qc0h8=3D?=
X-Exchange-RoutingPolicyChecked: gYmJMJYj46OlIUBGQkGPsEclGF1tppOMsZq7pSuHIftc8jYDghVnD2QOid/aElb9yw1buS7gIzFPwUEaZG5P9YwbDpA+qq5w2ZKER0dT/FXMrXRKxlm4xOjNSW8pwLoTrm68d/45QI34wrX1KbXOmwz3DIxyPGyKotPULmrMsZ9mbPeHsZNvVL++3jV2rMZvXvKgIOyPgs1mWMBEZKFKZApSm/bXhpntvPFm21A7uinG/A3dMEqMstPAZm/l5nWtnCtm1c/Pgx+lvZ4+M8lIoNYtmZpilnuW1ZZQYaX2j/JtLU/Yz3/L55/odv/5Gun8cFEV7OoP90ouFF/HUDG2eg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb8a5bc-21c6-440b-6f7e-08deac980bd3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 00:23:37.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5o9puWuM81BP8hYZ6SyV6sYqu+s6uBjiyASrkDmDl9UnrQM7zv8nWV5lzHJ9IuiqTIjRRMkYSpCB5acPFwkDEZaUgsjk58UBI9g80ZD99nI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9487
X-OriginatorOrg: intel.com

Hi Tony,

On 5/7/26 4:45 PM, Luck, Tony wrote:
> On Thu, May 07, 2026 at 11:30:53AM -0700, Reinette Chatre wrote:
>> On 5/7/26 10:47 AM, Luck, Tony wrote:
>>> Reinette,
>>>
>>> This looks promising.
>>>
>>> I'll split out the missing call to mon_put_kn_priv(); into its own
>>> patch before the deadlock fix.
>>>
>>> Going to re-run the tests I did before forcing kernfs_get_tree()
>>> to fail early without setting new_sb_created, and also late.
>>
>> Thank you very much.
> 
> Tests pass.

Great. Thank you very much.

> 
>>>
>>>> +/*
>>>> + * Temporary forward declaration for testing only. Move functions instead.
>>>> + */
>>>> +static void resctrl_unmount(void);
>>>> +static void mon_put_kn_priv(void);
>>>
>>> Question: How much are forward declarations hated? And how to handle
>>> this?
>>
>> I am not aware of forward declarations being hated and I am not aware of
>> documented tip rules about this. Even so, I do find it cleaner if they
>> can be avoided. To handle this a prep patch that just moves the code
>> without any functional change should work?
>>
>>> Moving the functions around in the same patch really obscures the
>>> actual change. Is it OK to have a patch to make the functional
>>> change including the forward declarations. Then a separate commit
>>> that does the re-order (where it is obvious that functions are
>>> being picked up and moved without any code changes)?
>>
>> My preference would be a prep patch that does the move with new
>> capability built on top. It seems unnecessary to me to add a forward
>> declaration in one patch just to remove it in a following patch.
>> I agree that moving code as part of functional change should be avoided.
> 
> OK. I have a three patch series:
> 
> 1) Pure code move, no changes [while I picked up a block of functions
> and moved them earlier, "git show" presents the move in terms of a
> different set of functions moving]

If the patches seem awkward it may be worthwhile to try --patience or
--histogram to see if readability improves.

> 
> 2) Add missing mon_put_kn_priv()
> 
> 3) Fix the mount error deadlock
> 
> Internal AI scans have only two complaints. Both appear spurious;
> 
> First it says that:
> 
> 	if (!ctx->kfc.new_sb_created)
> 		resctrl_unmount();
> should be:
> 
> 	if (ret && !ctx->kfc.new_sb_created)
> 		resctrl_unmount();
> 
> It admits that current code can't return ret == 0 (success) while
> failing to create a super block. But argues in some twisted future
> that might be possible.

I think kernfs_get_tree() can indeed return 0 without creating a superblock
when this is a re-mount but since resctrl does not call kernfs_get_tree()
on a remount (instead returning -EBUSY) this should not happen. If indeed
something changes with kernfs API to cause this to happen then it would be
safer to return success with state than return success with all state removed.

While the change is not necessary in current flow it does improve robustness
while making the flow easier to understand so I am ok with it. I think a comment
above the check will be helpful though.

> 
> Second:
> 
> Code used to call rdt_last_cmd_clear() unconditionally on success or
> failure of the mount. Now the call for the end-of-function error path
> is gone.
> 
> This is true, but it doesn't matter. If the filesystem did not mount
> then there is no /sys/fs/resctrl/info/last_cmd_status file to leak an
> old error string.

ack. I see this similar to unmount where this state is not cleared
either.

> 
> I just need to write up the cover letter.

Thank you very much.

Reinette

