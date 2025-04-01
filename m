Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C292E17E
	for <patches@lists.linux.dev>; Tue,  1 Apr 2025 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743466077; cv=fail; b=f1BztvXqgSvNzAPGu5OF5mnf2/heqhrZSLbuly7Yi0vj+9s3zJlp15PVfw77hwC24HJzJcMyqtocH6nUNlqAsiv9bfKTtjbpFR8B9+k7p7u+XBg++da3/Pmh1mkSH24Nn6yaoRdECZciniPnyIDtbO+mIj7v5TwKT+g6u+Dw2cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743466077; c=relaxed/simple;
	bh=FF5wWS4c8VeaPQeuP5a9PKr0cUzQHPz2X/psc8FLryM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lK3f0birTdZqxVAklbVZXa5g0RGHGQ8jvsPOGIsBvg/JvzvJpB7iF+jUG4k0xyO9JeXUEt1GX4uxmXbkihFVNdwTE4AJ1oifoD2+ypTqERxS5WchytmfPRDnyiSWkAKT7x9k3td49NnWREub4WP2tBsi6iWAm7xx5AlTzjpjnOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkOZcLGM; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkOZcLGM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743466075; x=1775002075;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FF5wWS4c8VeaPQeuP5a9PKr0cUzQHPz2X/psc8FLryM=;
  b=DkOZcLGMNYBELk7SyyQSPG6AWwkW36scmO0rzFnOCIdnilnd9HWWOugz
   7g3H4a+QjAo9VeIsHhS08jPRsolkbGarscIijXTMr6DIgrKScO1bLn0yl
   C9UL8qN9Gu1X1TnqrE7L0vS2uwsJT4mMs7N/z8Ub3kSXsZR51gNjiCQOD
   FXShYuj4AB9eBz5QnaYeLl5DBH3cnV6xrn3tv7jPbX9oCEOQMLkldpTKf
   yuN/3QQ0Bj+eIL4jukJ4rTrrzwKbT4nM2VVtodP7fbD6FLDnZ0cSo8AYh
   LPmsyNtB2fnvPjXHaDtAMy+1kHmKJrJ5bq6kZVMSC2rMm0OgCxvgppyEf
   w==;
X-CSE-ConnectionGUID: 6UznbJcjSg2F9oNvOw0x/A==
X-CSE-MsgGUID: v213pEbCSbSgZ5McD6e2ZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44902264"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44902264"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 17:07:54 -0700
X-CSE-ConnectionGUID: 6il6iaRNSUy1+an+O5uWow==
X-CSE-MsgGUID: NmSd4KsdSUq6p/VVWr0dvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="130337533"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Mar 2025 17:07:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 31 Mar 2025 17:07:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 17:07:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 17:07:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YBoz6SurKSZJCQPJzOAXx1tMPI6J0UoOm9XZ7nVL3VVn8zb1c0SGoPv46+wNSAuDaPy0nrQUaMIt2UMomVumyTiiV0wj6eLB8x5yCt0QO0JdMhuVcJ6QgyJmN5YAMQOstQ1ucL2y4uIlvYRLyzlJlLzuY/OI+u3NLjnU+0AK6Z8TCGF5nGvhUoAywufsYhlk3DKd0dgIq0Q2c53zQIpNeBtzBYVEXWwjjZpDpfeIf6gFxTNygeTQd/6t2Ybg/dx/1rz9ArMrjhDQtzVKmvwUL6Epyuru4thOruXmUE69bAgLimCXUQxSuALiOaFqoDZ+EtCTkGFcdMUAB2UmK1nc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBSBlf7SCYVn2hL64NYeGQTkabrrgA+0Fl8siLR30oA=;
 b=gLbRtZX0g8VHf+ZQt4CaNAwzXF5Fd32o2NQqxkAEmWbg8P1sVtnFJRyksxPs212QgkiCMNY1Ta+HK91WIH+RXquOwsVRwwR5KRaurUnMgw4CKlJZAW9HEf4VW3wR8HLypDomtdCoImA2nJ2mel+DNbKIrKAWQKLZzv3GtFs1qeVsrGc1klfASsGT2zKnQUmt6RYCNvAvoZcxwDESYBC2dX5VLBq8O3RTkaAh/3l0KTnmMK5Uy85ebtAYDFM3v9gYLO1jcntHN9GJ8asGPRTE9H86qL/VTz7GEBBW4JbHzkZOyB3W8Kh6kMh8sUrxAJtA/JsRG6zcCuv4I1WDkHCVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7503.namprd11.prod.outlook.com (2603:10b6:a03:4cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 00:07:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 00:07:50 +0000
Message-ID: <44b25d54-5af3-4d70-a3e0-2322696ffc42@intel.com>
Date: Mon, 31 Mar 2025 17:07:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] x86/resctrl: Add initialization hook for Intel
 PMT events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-8-tony.luck@intel.com>
 <8e4b51cc-9405-4505-8bd3-07d46f246efa@intel.com>
 <Z-sO3G8OdzVwnvo8@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Z-sO3G8OdzVwnvo8@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7503:EE_
X-MS-Office365-Filtering-Correlation-Id: a4273032-03ec-4a69-60d0-08dd70b13d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NUlLY0Q2R3Niejh0ZGRlR1I3TElQbkhFOENIVFp2NCtvcDErazVTV0tHeWtY?=
 =?utf-8?B?WnduZk1yWi9aQmIrZUZiNVgwT1ZuSkRuMUZWdlJhMWlUYVdDQ3B5ODVnVzBz?=
 =?utf-8?B?a3RhbWhmd2w4dHUrUzllT1pIc2hWVTh2R09GQ3NTdTFXN1dReXBTUzNFY1My?=
 =?utf-8?B?QzRRSGhoU1JJV1lmTUE5Vm84SmhFTXVmbkhJRHpHRHNSOXFDSUNoclg2bUp2?=
 =?utf-8?B?REkxK0NHSVFvZVEyZ3l0SkZnckRTUG1XT3NHekdsTi9ESkpkUHVNbmluelpn?=
 =?utf-8?B?UE5mZVhia3c5RUVyWnJtME5ZMUs5VmN3MWZEemJyT0tFWGNrQkpHYk5lcnVY?=
 =?utf-8?B?MDFrYVJWS0ZmNU9SREtOL0RZUnU5SVkvNmtCR2F2b3FwbFM2TCszc3RtdTNT?=
 =?utf-8?B?akNBWndreCtidmwvdzZyWnhHNmJkVDYxNlIwL0x0VXVzbFBvRDNjTEswdHRk?=
 =?utf-8?B?d3VQNFJMbkNjMVhOUmpTRVFST1Y4QW9oTDdSVHhkRnNNY050YUw4amdWY3l5?=
 =?utf-8?B?M2FrbnFUOXNTOTU2cG1RcVU5Q29UM0tZUDZGSDhnNm9FSmZvN2ROMkpEYVVh?=
 =?utf-8?B?dkRnQ0E0UHovNzgzNDBJQmFuWUJ0T1pIcS81clJBYlhxUGVBWE56UWJ0M0RW?=
 =?utf-8?B?ZkpLVDZRK0x2ci9lOVpLa3FuM3I1NHlQemkxYnMzejE5UnRTRlR1b0hINHNZ?=
 =?utf-8?B?Ym1ySUJ6dnpPNWtMVzl1QkZaTWtCZ2FQZThMZlNWNWNzbkxlK0V0a3h4UG5T?=
 =?utf-8?B?OWszOHdvVTBvWUFPS2pMTWxrcUdiT0ZPZzgwRk5vRzZTNDNCTDFjVjlrMDV1?=
 =?utf-8?B?U0xvRTRtb1lrZDVCOXNoQ0RWelVkakRRUDdYNjlqaGJHL29RUEJ1YWJSSjM0?=
 =?utf-8?B?MURINW15RTgzQUJNRWRWVzEyL21QZ0hzTG9LeXpNTksvRHQ3T3dnc0p2Ty9p?=
 =?utf-8?B?OXg1VHU0dGJXOTBlbWdBem85bHNqdFR0b1I4ZzRrcWF4WmQwMjA2ODdOVGxX?=
 =?utf-8?B?Tm0rdVlXdnZ0V1VsT1A4bW5qeUkzOHNMTWduTkRvdjhIMWJVVUlSNTVTYmg5?=
 =?utf-8?B?OTh0VHEwbXNuMG1mNkwwS1BhemluZVZPa0tPR1FjTDZ5MWgzbFFUclBBSitD?=
 =?utf-8?B?YkVmUzBFV1gwVEJCMGFmU2F5YmVUb0dQU0VXQXdQVkVyaGVQbmJMMGZMd0hh?=
 =?utf-8?B?eWg3YlVNR3orRjNqUm9sdWQ2L28xTDFiaHZsWFBJbXZKY08yQndXemdGMXJG?=
 =?utf-8?B?V2FkbysxKzRXdFEyditweTA5VktZcXVnWGNaRTZWc2ZKYVBrY29NcElobzQz?=
 =?utf-8?B?ekIyeWliSTRoUW1JSnA3dWN4a0c0NTRxNFRiZVBWTkVVSDZha3lTb1duNkZi?=
 =?utf-8?B?ak9YQjVIcmVCUkIxNUJoOHIxSkZ1RmtpV0RYcDAwUWNvVHd4UDYzMXNPQ2Np?=
 =?utf-8?B?V0M4ay85QlJWc2VqR2p5OTV5ZWQyalREMG0rcTNBOGVIb0NPeHViblVZM2Nl?=
 =?utf-8?B?eEJWOGZoaGxNb2p6WjhJdEgvbUZ6VUNLTjBjd2FCbEJOdU9hdzFrSkV6QXhq?=
 =?utf-8?B?b0FpdTJTQWJNVXI1b0Qrb08rb3I1bDd0eVJDTmwrY280c05Tc3g4OUU2WCs4?=
 =?utf-8?B?R2p5eUNONmMwWUFUdUNGbnFWbXRzNnBKMGdWMm9xMTFucGNoVDB4QVBPSGZF?=
 =?utf-8?B?WUNLa09PY2tDUjRyUm40b1lBUHBiUzR0aHNCUDRpMEpseVZPYUZUb3lDNzdn?=
 =?utf-8?B?Um5JaGlTckpEeDVVQzRrRnRvdnhUMVF3ZElId2xFZlZGR1VVci9lQW4yM05n?=
 =?utf-8?B?RXJBQjh0Q1RXZ05WaWUvRjRXYUljYnE5aFlueEl2V2JqODJvRm14eVZoOENJ?=
 =?utf-8?Q?kDUz/ubtxUivF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkJ6K0tKVTZHVUhka1VmR0xNaGVHbTRWQ25MT0hoQ0Juay9MeFBGKytXMUdN?=
 =?utf-8?B?N3BEVGNYVUxvN2UvTmRRK3o5Tk9hQ1FkQXNUeTJsWlgyS2tvalIvTlBuMERu?=
 =?utf-8?B?cFlZNWFZRkovOUJFQVpFRGk1ai9sSWZMdElHc1pNZlBDRVNRY3ltYjZHZ24x?=
 =?utf-8?B?T2F2V2xEdEZVcmlTQnRSVGNMVnRNQ0c1SW9tSnpoZHMyaWUwVFpGemZKeko3?=
 =?utf-8?B?Rm1ldnZxRDM1bzJaTnJmL0RibzVOV2RCdzRjZ2hsRXBRWEUzdW01a0RRL1FN?=
 =?utf-8?B?MUs0NU9NUGVWclVoTXBQZW5YbTZGcFFoRW54VDdCTzJQRFc4dmpySktPRENo?=
 =?utf-8?B?UEdDdjhjR3FkM2JvN0NxYlRjT05RaFFZTWVCWmo5Q1hUNWMvOGFrOHZTcisv?=
 =?utf-8?B?WGdXalVOR0g3dUwyY1NYY0RXRWY4OXJOWlZURStCc05HMFBaSnJGOERCUE8v?=
 =?utf-8?B?emJaSzlaWWJUTmp2djA5cndhUHNIcVF3bG94WjZNQXdjSEtWRGo1a01pZHNh?=
 =?utf-8?B?MHdWRjdla0NvQVNsQnM2R2Zqam94Q1pSZStMVCtWNlY3cUd0TElyUmduQWMz?=
 =?utf-8?B?Vzk4bzV0N256eW9tb1dub0FVbUw5V1hmRWpibkxsZ2dURDZuRzM5VUwwejBv?=
 =?utf-8?B?RXNCRlhuZGI0Vi9RNUpCdHZZU21kMGlkNk91SHorOTBxa2pvVkIrQXovNGNN?=
 =?utf-8?B?NDZYVkVCUHF2aytUcGVKQ3M2d1pDSEF1Y1hBOFFBbExTdElNVk5nOXV4cHph?=
 =?utf-8?B?TkZpVkRYZkpSck9YcWNhOXliaWIzZGllaWE3K1FuMnkraGdaOTNsUno2K09U?=
 =?utf-8?B?Y3p3Ty9FYktuZ1A5T2tlbXRDU3cvU05NazZOakx2NWtNVkRMWFJuR1lZNGxJ?=
 =?utf-8?B?QTloNWVjWWpMcXk5WDg3NCtVSlNkaU5WQzcwVUgwT3UrQ1pNeFVKQjRsdDVV?=
 =?utf-8?B?WDZoMExaNnJSS2xYV0g0R2pKaXd2TS93ZER5b1djRnpmWk1sRVpmVFdIQzBZ?=
 =?utf-8?B?enVWT1hncWV3ZWpqNEs4MzllcCtPYmJNNUxDa3c3Y1hkdytHTUFPczNNc210?=
 =?utf-8?B?RGtaU1llajBROGQ0aUV1NlRKQlFQVWJPNGNhbjZpVFh5bUZDTGJSTFp6UU85?=
 =?utf-8?B?a0hxdUJyZjE1eUhMWGoyNmhIMjM2TXl3bVZOZ1lwQTNVcHd3bFU0NTBtUTN4?=
 =?utf-8?B?RDlsUVEySFIzTUU0MWJXZ1V5bmRjWXV5dkxWUWs5MXM1YlpFbnpzYTlLMUEw?=
 =?utf-8?B?Q2RtZkFuNFlVOHRiSEdOeTRNbndSMHk0c0tCNzEvT2tmZEhjdEZTUHhKZFRn?=
 =?utf-8?B?V2VsTjlwVExoUXkySjNib0srNmg4eC92R2ZFNmdxQU1MVlBCY2xTMTgvTjgr?=
 =?utf-8?B?cEJWSHlQUXJoYUNFazRKakFlSkdESFpaRG85NURUYVdqck9kSjNCejA4QW5Z?=
 =?utf-8?B?QURWL3lDQStZQ2hNQStuSlZCWkwwT0h0dFRHckg2bEM4SXhVSDArV2YvWFht?=
 =?utf-8?B?d3I2Z1RqVHlkWHZ3UjIrTFNwd050UG9SSy9UWWYrQlYwbEVDZElVZXR5RFc3?=
 =?utf-8?B?SDNRQjdLZ2J0QVRsLzhkQ25kR0dwbFd2RHZuMFg2UEhhNzNuMUxjamtSL1Zt?=
 =?utf-8?B?cGN0WlVVNWhCNVVqcTVrd05pdVZpMzVlZVBCUUJkTEhFazFJb0FyZlNnVExx?=
 =?utf-8?B?ZFdrY09oSVJHZW95L01zMCtGZHlvLzhQMWU0QXlYWjNVK05NYm9MRUtkeVdn?=
 =?utf-8?B?RC9ZRWZNT0JMbmpjYWhoSUFGUVhtUFZTZmpEY3ArWlVMQldweUoyajB3N0Jh?=
 =?utf-8?B?a3RTODkxTnBEUDZKVHNCN1Q3TnFNZTgvcWhwOHVrWWxKT1crZEswMVkrTHE1?=
 =?utf-8?B?cnlEdkZzUmxYQWdmcHVkaHdMYmxyRlhzVFdBT3dlU0QvaWlwSlQ4WlUrMnhj?=
 =?utf-8?B?TnNSOU5CZG1tUENTQ0I4TitPL2kwU255aEpDYmFNZFFRQ0Z3NGVSajhFVTBq?=
 =?utf-8?B?NE81MVpyNTBPZ1JyTlE5WDh6dEgyeGRDMUFFMm9sdzV2SUVyQ0oxTFBJK04r?=
 =?utf-8?B?M0YyWUpqeW5oeFlEdWNtS2EyL0l4M0IvU0xrNWVNeHhtSGtoUGlWaTlrOVNr?=
 =?utf-8?B?d252emVBRXpEbUhiUVRWQlJpenlZWVhyckRpVXZwdUU0Ujh6eURmUklvV3A1?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4273032-03ec-4a69-60d0-08dd70b13d70
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 00:07:50.0120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSSKLIwmuR8R43gTgzuTRYB7GFfqqCQ8QWX+PGrUMeuozmvTNw718S/Lf9c2pgYV73AfEaTin29V0MDVfoCHGcTbGuvjWqGXMzrKMMEpTX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7503
X-OriginatorOrg: intel.com

Hi Tony,

On 3/31/25 2:53 PM, Luck, Tony wrote:
> On Mon, Mar 31, 2025 at 09:20:07AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 3/21/25 4:15 PM, Tony Luck wrote:
>>> Call the OOBMSM discovery code to find out if there are any
>>> event groups that match unique identifiers understood by resctrl.
>>>
>>> Note that initiialzation must happen in two phases because the
>>
>> "initiialzation" -> "initialization"
> 
> Wil fix.
> 
>>> OOBMSM VSEC discovery process is not complete at resctrl
>>> "lateinit()" initialization time. So there is an initial hook
>>> that assumes that Intel PMT will exist, called early so that
>>> package scoped domain groups are initialized.
>>>
>>> At first mount the remainder of initialization is done. If there
>>> are no Intel PMT events, the package domain lists are removed.
>>>
>>> Move definition of struct mon_evt to <linux/resctrl_types.h>
>>
>> Why not include/resctrl.h?
> 
> I put in in resctrl_types.h because it is a type definition?
> I'm not sure of the criteria James used to decide what goes
> in resctrl_types.h and what goes in resctrl.h

Changelog of 
commit f16adbaf9272 ("x86/resctrl: Move resctrl types to a separate header")
explains it well.
Essentially I expect a new entry in resctrl_types.h to have a user in
arch/x86/include/asm/resctrl.h and since cover letter shows no changes to
this file the addition is unexpected to me.

  
>>>  static __init void __check_quirks_intel(void)
>>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> new file mode 100644
>>> index 000000000000..9a8ccb62b4ab
>>> --- /dev/null
>>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> @@ -0,0 +1,211 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Resource Director Technology(RDT)
>>> + * - Intel Application Energy Telemetry
>>> + *
>>> + * Copyright (C) 2025 Intel Corporation
>>> + *
>>> + * Author:
>>> + *    Tony Luck <tony.luck@intel.com>
>>> + */
>>> +
>>> +#define pr_fmt(fmt)   "resctrl: " fmt
>>> +
>>> +#include <linux/cpu.h>
>>> +#include <linux/cleanup.h>
>>> +#include <linux/slab.h>
>>> +#include "fake_intel_aet_features.h"
>>> +#include <linux/intel_vsec.h>
>>> +#include <asm/resctrl.h>
>>> +
>>> +#include "internal.h"
>>> +
>>> +static struct pmt_feature_group *feat_energy;
>>> +static struct pmt_feature_group *feat_perf;
>>> +
>>> +/* All telemetry events from Intel CPUs */
>>> +enum pmt_event_id {
>>> +	PMT_EVENT_ENERGY,
>>> +	PMT_EVENT_ACTIVITY,
>>> +	PMT_EVENT_STALLS_LLC_HIT,
>>> +	PMT_EVENT_C1_RES,
>>> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
>>> +	PMT_EVENT_STALLS_LLC_MISS,
>>> +	PMT_EVENT_AUTO_C6_RES,
>>> +	PMT_EVENT_UNHALTED_REF_CYCLES,
>>> +	PMT_EVENT_UOPS_RETIRED,
>>> +
>>> +	PMT_NUM_EVENTS
>>> +};
>>
>> I expect the above to become part of resctrl fs. Actually, I think
>> all properties of the new events, the id, name and how to display it,
>> should be part of resctrl fs.
> 
> I'm not convinced about the amount of re-use that there will be
> for these events. I took a quick look at the current plan for a
> processor that follows Clearwater Forest and I see 22 events, only
> 3 of them match events in the above list.
>

This is not about re-use but instead these events becoming part of resctrl fs ABI.

 
>> We do not want other architectures to create their own display names for
>> the same events. I expect that this will require more plumbing between
>> arch and fs code to communicate which events are supported, similar to
>> what exists for the L3 events (for example, resctrl_arch_is_mbm_total_enabled()).
> 
> Supported monitor events are indicated by setting bits in "rdt_mon_features"
> currently "unsigned int" but could become "long" or a longer bitmap if
> we really want the FS layer to keep track of every possible event for
> every architecture.

That sounds fine. rdt_mon_features is x86 arch code and that can change as needed.
Previous discussions ended up with rdt_mon_features staying with x86 arch code
and accessed from resctrl fs with helpers. 

>>
>> This may result in struct rdt_core_mon_domain to no longer be empty but instead
>> for resctrl to use it to manage state of which events are enabled or not. Theoretically
>> all could be managed by the architecture but I think that could result in inconsistent
>> error codes to user space.
> 
> rdt_core_mon_domain seems like the wrong level (unless we expect to have
> different enabled events in different domains). rdt_resource seems
> plausible ... or just expand "rdt_mon_features".

Understood on the domain level. This work introduced quite a few new data structures that
I have not yet digested. I cannot tell at this time if new resctrl fs helpers will have
easier time with unique perf related data structure or if x86's internal rdt_mon_features
need changes in addition to all these data structures.


Reinette
