Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA972E7BD9
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570417; cv=fail; b=LvU3nwN3nQPzPozA7fePy4+UsJT+uMvstiv7peqv1cSLVMykbenPf6VERk3X6w0DdL7U1RYWPQMm/wu3Q8LBCnec0aqYP0YBinjja0CNmUyb5+rY3fEUqmTvjrXaLaE4ngDSR47+X9HAg3PGo6Q+96Riocxh7JSch0WEcgxCfSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570417; c=relaxed/simple;
	bh=dj9tvR2pBry8/mRzVkZEQkNyZcEjEfnqXD4hRE3Yrl0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g0cF9qRQOcw/nS5NLCKjf7JneYdf3lu2ZmCZx4kYZxhpO5ar4lKQAe0nf8SLr2B4mA5QPcJ4dsRZZqkw+0Oi6EG1xZ+MPS4JbRvHccNv3qqYKNew/p41DBWjbKMfQjYrDNE7nFp0w4GV3WVKTuaaYeL8uHte2cXwEf8cMEicez0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GG1F5nHt; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GG1F5nHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789570416; x=1821106416;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dj9tvR2pBry8/mRzVkZEQkNyZcEjEfnqXD4hRE3Yrl0=;
  b=GG1F5nHtMi/L4EXYBr3l5t8FAyJ0b6LMsNj/n2dcsMYuFYhWKzcg5p+s
   0wD4lYljdsZOPOp6NG9GWa50cetWiL/u5i3xfXwhye6M+Q18tBjgz073a
   bHvbgI0VsJ30623kv7enFKNrEv96AEKPU/MFIHw0QAKzt7aCn4mfSfdLs
   Ys2UGfvTNMOSbRlGJj6OlUovMmyZ/sm+zmIZx1BJpBOdc6blyU7OqtZZn
   6fPvK8nTms7MPtx9wmexTGZ9/HVNx4yB3779FmU3H+RXFxuPCjQzzxB9u
   JgXbjBuB3aVzWYymhTYVvZp/sjXeel3WI6rbYU8RIIO8FBcIpKIRFy7V2
   g==;
X-CSE-ConnectionGUID: ga2wm/SUT8GkFf41FEsuLQ==
X-CSE-MsgGUID: OExLRewjTye17zCDw/4fDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="92455635"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="92455635"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 07:53:35 -0700
X-CSE-ConnectionGUID: l+8IfGSKSyi6wYJQ9FNIJA==
X-CSE-MsgGUID: sk6j9RgUQ7uLuAJN07rVYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="1581537"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 07:53:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 07:53:34 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 07:53:34 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.55) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 07:53:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q8G6tPl4QxvLSNHFr55VGzPJwgG6RJ0+GAdlUJbTwcTAcfYtbSv9eO8HGIfzNPwvFuSQbkMFwBSZb8ET0y/iE3PMsL57VutKE2awOAKjPFEfknOxdgpwbM/3rsx2INmyoIc8pxTuSdXzJjYJeoKrH8KOcsFVlG9T0J/H9XYD78npCUyejxxCPPV2H03N3zyjgeK6l/VlhT0bVuibp9lUIQ5tLTBRGZ75+kS7u2fUjkECd0bkbyeQDzKNvIUT7kdJBwagjrCvMRU1TMGgrTEnLWK2fZLVm71V+eAWCmWyJM6bXiCrA6kFayXyYAkFlhcnEeHvUt9eaPF4De8yl/oOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DbxzfuNVnZU8dPXYH1omt74KHAX4cxen7ab7p5F62U=;
 b=FSXFewDsZ3LwmXYWvxQ7wgfXh6vQ13z6QIOtD2edFNzYlXtj1S5Nu+FL6pLJT9CBfH/LxrytezIw8NfWj4PryEus76VYmNtKIdDfKSd8YeWN4fRlr3M2Zzp8D+svJPiwZ3VV1gb+To5/7dnerw6PO9OHdyimbFYfuoXLcHiQIctikNDlImxGF3wafi04x5Z0zQyPt2IddS6AGA9vZY+G26UGZIe94h9BO0r75bdDfVmtMsHAyrwaO+vR5i7/VSb95wVyjd+LsmEDVAk/Pz7XAby7AQNB+KOhYFcL+CCYwSmyNAJH/Nl8zXhu1A6aMfSu6pD5UpsR3tmU38WR9tpW8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ0PR11MB5165.namprd11.prod.outlook.com (2603:10b6:a03:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 14:53:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 14:53:25 +0000
Message-ID: <3bf4859f-bba8-4b98-990e-f49124d61412@intel.com>
Date: Wed, 16 Sep 2026 07:53:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Update documented unit for the "activity"
 event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260915190431.18189-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260915190431.18189-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:303:b7::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ0PR11MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: dba4c290-19e9-445a-e847-08df140242bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|3023799007|18002099003|22082099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info: IU54yIDGfnagobiTrJa+3vZsbNXPQCsV7EtPqHr1kePOm9ZIgOwB/UhK/juZsItx1LaGFdrseo7Dvz2KZHM6zW5QQjWis/zub/I7AIxF57fssBq/hNcDbztlqyMc5tFF3EYk6qTlCfY/t9tzIcgeZ5spG+G07oiPd3Ob3VnbFXj4UYyN+zJJoq9MRODOOdzlVEA9sWSFBt7nUDmxm9PCvX+gr41LM8RgBktFRYgzE3IRn+OYNRSUO9ZJp0hujBF/I5BmWUk1tIdqF/78SW9XBzqjmFcPvcvbp/2Y5JRhGWqrTSYEV5H0n4wTcwEWViVjx6p8U1I6ocTB00rclJgOUWGnHcxq11t5JrBfNnINqDFRZjWQ8Ht889fk/CxrwutMVFheWSgEVcjoVD1SeKim35J6RWaiDHp7ubYDDJ02ldMn87gCCFm8/r12HFBhJlzIfAOAYulN3KjCSCtj6Yo4bbX/mTQU2iCRdmcWyCvi6BXEVTzksfaKJ/hl8JiNNbDivr2X3+hI/V/X7Sd2brFYwCOKkuzvqgy7SNUZMpeKyV3NjQZVWGkUmat36UbH9za4bK30tOU5kRJousayZcUq4vpdz5uOtQowhbbXRuwLZe3tu+q2GxOaVjjblPnsr4ArkO/ZHCV7KKH5q/qP0NSUh4G2Znd2z8V8ZC2vCx8i7jL7abp15z6PRViFA1wdA54XDCw8/0noSMAEI3yjMlihzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck43V1R3Nmp5b3EvTlptZGQxdVpzSWNOWTBROUc1bDAwaHo4WWZmQ09WWTJa?=
 =?utf-8?B?bytZNmdKemtYWkpVNSt2TC8zSGY0ajF0VTNUa1JZSVA5cmk0YzZBU1lCRy9J?=
 =?utf-8?B?bjRiWXVzVW1kUUp4VXBUQW5zV2ljblVNZVRFTFRHQzFKZVJLQUdJV2RxKzNS?=
 =?utf-8?B?eTZZcmF1dHY5OEFzelRDQkpuczZUWVNIRjd4Q2xKWGp2SS8vM2N0anQxbUwv?=
 =?utf-8?B?YmFManpUaGlUSzdheHRROXBrTW0waUdJVm1hSytReUVtWXNvd2lmenNBM3pQ?=
 =?utf-8?B?NzJlRmtNOVI2MFFRaFZRQ2pMWUNPZG82Tjd3MUpwSWRkMmN1WTl2Vnl2SVda?=
 =?utf-8?B?ZzVVZUtFdzVMTi9ITUNwdWNVcFl6TUcvYXVwMk1ZMkpEVEFXbEpaVUVqQTY5?=
 =?utf-8?B?dXR4TmlUZUx6dDR2b1piSVBqVkQvSWlVWFU4NDhhdkpMalVGdjJQTVBhVW9Y?=
 =?utf-8?B?aG5sZCtTcjZBTW5acG9CUUp6dzhWMjdSZWtjbjJ0L21kMGpTOFdpSWlBd1Q3?=
 =?utf-8?B?NnRCRHczbUJCWkI5SS9JeFFsdjlPcjhhcjJuZTR1d3JUcWZRY2NhWmtIR3R6?=
 =?utf-8?B?WVZ2ajVPU3lzZW84WUV1cm1DQk5KWmo5ZlQweERUTWEwaXM3YmdWajlzdWtq?=
 =?utf-8?B?VXcrbnZiemRYbEQxTlBkQXMwb1NTd1Y2d2s4TUFoNzFiSjhLWkZwMWdURVR3?=
 =?utf-8?B?ZXYvV0hMc2srV1ZWRjJhbzc0YTFEcXVMVnFTbG1qVWRFS01UdGE3S05SeUdR?=
 =?utf-8?B?VkZ0b0JQdmplcy93RGY4OHBrRWhRZXhONWlndUkrNlZ1a2VnUkJyMWJxeVZU?=
 =?utf-8?B?akdqeGlyanp1cDgvRGcvY2pTcURES3hPdngwUjJiSFNSYWpTZGJxSnE5eWNw?=
 =?utf-8?B?eEVWUFM1MjdnSHE5d1VqekhLNnRCTDRYR1M0MkRKQkdOT21pNWZkaDdjd1M0?=
 =?utf-8?B?MTFsUThHUG9kNy9LYk1Sa3M2bThVeFYvMG9MclVEVlFxRkJhbURLOWlJNmdy?=
 =?utf-8?B?L1hYRDFtVm5zcnpXWlJZNXZPS3lvNk84d1QrMDJGYkVCNVk1TFRiOS9oN0Rt?=
 =?utf-8?B?K0w0SC83MHIreis2VVM3Mmo4aGdJLzJKV2hWZ1VDMjloKzY1ci9jMGovU2xF?=
 =?utf-8?B?RVpVTHl5eUgvRXhjTmFnc2JwS2dSNS9SQXJjVzI0NWRQb2FtbnFqcmtwTnNn?=
 =?utf-8?B?NEFWakdGSlZ2a1pnMFZ6RDhhQWtLVjcxcE5GelhnWHdCdkdhUlJYa0RMd1lQ?=
 =?utf-8?B?S25panlTVGxYdHp4YTRLejFrZ3Y5L3UwTHNEUHorSEdFWnJWRXdTOVJ0ek1M?=
 =?utf-8?B?dTNCbmV5dXNsaEpKMXNDbkcwOWlTZzREOFArMW1Gc0xWS2g2dDU3UHlVNW9o?=
 =?utf-8?B?VS90K0pyNVAvVndVR01SbXV0K1dDTzVSY29yS2xjdjJEaVM1YjhQWU90MUxp?=
 =?utf-8?B?ZnBuNjUwcFV5UGdQYmdkUDNqSkpHU29lVTRSdjNtL3RjeTdEdzRwRXpRYlE4?=
 =?utf-8?B?WWVsc1FjOTd4US9vOVd0VS8xSW9mNGhnOVJMc3dIeUZSbDZiRDhWdS9nL01S?=
 =?utf-8?B?dXBBNXVRVzFRUWR4MHFsbUszRlhZNTdLdVMvOS95TGNqejNFWEFYYmNQdmhX?=
 =?utf-8?B?R0hzTDRQWlhnMVlwckMrYVVOQ1owRFAvSGY1aUU0c0ZnUEFRTEFPb1B0QmJ1?=
 =?utf-8?B?OXMvcTRCVHVXalM2c2NMS2VvSGRNTmQ1TFBnVzF6N21jUEo5ZXZXMXdsQ1pP?=
 =?utf-8?B?OGlLN2Nabzc1Smd0MW5IZlYvR09BZlBBL3ZySExRSXAxK2d1QjZXWktZTUJW?=
 =?utf-8?B?QmhjTW5oSkY3U2cxaG1BSlp3M1dWWXZqejV4blo1OU1VdWgzZkxwa1VIdDNh?=
 =?utf-8?B?V05ZZDRoNStiUU1ReUhkbVBGRmI2N2JFS3dhK0Z3bFhvNjdKSWJ6UURTUFBN?=
 =?utf-8?B?SkpFdkFUOEwxbXVERkJTTHVMd0FGUGs0RnB0Z3djdXJJKzRlbkoxZVlZaHVt?=
 =?utf-8?B?cTRGODdleCtldkVQQnNvZmlEKzFsNDRLTjNoUnhhTHAyRitBam5NaGdCaDc4?=
 =?utf-8?B?dk1JZEJxZDVmZGEzTllCbnFIRWRtRVFZcisrRm9GaTVTN01sWTIzb1dqbnJz?=
 =?utf-8?B?dThqMFFHdS80VDBNNzFJQjZxTGQ2RTZZRVFUb2xsaGs1QVRYUW1NbDF6eXhK?=
 =?utf-8?B?V3lhemVGY2NydXdOVXpxZDJ0VXltZkFRVmNwRUV0N1hGZmFGNzZQK1Zpc0g1?=
 =?utf-8?B?QUVQMGV2SWRDaXFEcEhIYlBKQWJsV1AvVkllVkR2L3VjT3hLVXdGNEgwTmRD?=
 =?utf-8?B?cFNGdEdOSStvaWZqRm1uU01HRWxkZE9OaTh4T05OMmJKbFhBdXhSTzdXdHNV?=
 =?utf-8?Q?UbVE1NRCWAU1AcC8=3D?=
X-Exchange-RoutingPolicyChecked: ADfM6Cl9EDDIuOQTNatOHFRiQNoUaHpCR7oEwPOxnW9aZEQkWyeWgJlQDjFeOnNoPb2NjPhw7rzQXi2F3obD5QfCYSix41fm0vg1To/mkeexmnpuzoAiA5CPR5ZwrYzdUVnDGFlXzoZlV1fLf57Tf+0ijGA9ck3Hiq0mAOsJpuyRD9yxn6LnOOncIGy9Tw9uC1DbC+jRXu9lfTw+EBQzI8rW+9yVO/TOvljpIfpXqzxneccPu23zEpnVG8ZHo+uNBWvgtw7a71KB05WxonhiT3byX1IOPY4haCIm2PqS0od7hJ3Iau6+T18juuF4bbmEX7Zsw/rMqsO+o//vcoLjdQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: dba4c290-19e9-445a-e847-08df140242bd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 14:53:25.3462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVeKFCbr7H7zJOLNnCETwiWZt1m+Wlh4A9emGfkdC5B6qDScoxOpMQp3RspyMTTww22JMWfencoRmdhJ4hzoIM9juh5toHTU11f/NBTwZGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5165
X-OriginatorOrg: intel.com

Hi Tony,

On 9/15/26 12:04 PM, Tony Luck wrote:
> The unit for the AET (Application Energy Telemetry) activity event[1] is nF, not F.
> 
> Fixes: a8848c4b43ad ("x86,fs/resctrl: Update documentation for telemetry events")

Should this go to stable?

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_common.xml#L9 # [1]
> ---
>  Documentation/filesystems/resctrl.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index e4b66af55ffb..a52cd812c261 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -643,7 +643,7 @@ When monitoring is enabled all MON groups will also contain:
>  	during execution of instructions summed across all logical CPUs on a
>  	package for the current monitoring group.
>  
> -	"activity" also reports a floating point value (in Farads).  This provides
> +	"activity" also reports a floating point value (in nanofarads).  This provides
>  	an estimate of work done independent of the frequency that the CPUs used
>  	for execution.
>  

Thank you.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
