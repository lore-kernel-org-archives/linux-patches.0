Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6633A6F19
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 21:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775856106; cv=fail; b=L00TgppnBvT/xzaPeCc3/hw5RZJn+gvTTgDf5Zhiy0jxHWnHK4ffJvnAAulqs0nh/brkRBDAhs5fmT08usmX3B7EdUKse098QsYFaOS/E41Tjq++etZpMKnAT3/bsc1qZV/hn8WXu0F0wa46Us0MlxvN2EWcYVcBY90A8pVq2xA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775856106; c=relaxed/simple;
	bh=NzPjdpryOdmA36jur5GBxt2Vh5YIXAV1yGlG3KFoFEE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ilQtVXeWz63d1uhu75SYVWvjhLlhOvFXQ7h7Z7cc7TXnImtO0LPkpxRB8jh3lzoQCWn/gEWZPDG5fwyYBcfH0bKuB7RpZL+wTSIEFO7/iidF+9C7bi3KkBXIalcB6CIGBs4kplTZCmy+pVvrCnUKAB0dv8chDKTxNyOsg2jRJCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F1hlgYRs; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F1hlgYRs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775856105; x=1807392105;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NzPjdpryOdmA36jur5GBxt2Vh5YIXAV1yGlG3KFoFEE=;
  b=F1hlgYRs61eAR8brdbUGC/c1kf6CSS3YaRYEe7zA9Eha0kJcUL0nEH6I
   +BF93pL7iTLkhnIKr5ESA2UaQUiopaaviOamdRPrAcreFAptDrVJCWtgk
   owP3+q1wuuFeq0PdmwB++x/Sd/X0HL49CRXFpUlGsKWwCw+gyHlggKNZX
   fhs6Fx0+kTr1b3uru76dSVoye+ocWxS/hK4fJZWTvaJ6Efh1JgraZshO9
   sWUvDd7a1Kmj+qEuVFkUYfqaJiQcYbmX482oSPHW9gN/21J4WVAdm2p+h
   TEwit93+t3DXkK+08k+h/orJNw75jPrbwlIkTDWYvcEVsOD0J2WgRg5Rz
   g==;
X-CSE-ConnectionGUID: v/y4o7kQRQyLaJ8DBwXYDg==
X-CSE-MsgGUID: IgeJlSdTTFuW87rjlWufZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="80473303"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="80473303"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 14:21:44 -0700
X-CSE-ConnectionGUID: tg35kT8LSTmYBYnGHJ9ceQ==
X-CSE-MsgGUID: BC7RR3fLQZqTDf82uMkK4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="252563688"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 14:21:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 14:21:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 10 Apr 2026 14:21:42 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.45)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 14:21:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsNHos5YaC4rkh6GV9MR3aerfALlLXGfY8QI7ccy+QwKQ5Gv3I1v8htk5prlv6XXx6L0LVcinoj8b+BRfyHlP3kLH6j0wvJ1bwl0DbKsY5g+Nvhv1dngfITK/CzPuEIQuOXpScP6+NgHMZUjOPJM7ooqqR11zOOCgmx3R4xyBdz/sHZ8mvrt9MuEV+qL3SgPm65f2Tu61BIF2VVFIaI3mRqqmq/z4Mq1HpaQkk8TLiC6jQlGtdJe8umsv8mBMMz3K3/cM8KGqA2GKET4FSRFoSE/Wh5CPIxmEouKYbOGJYyYXGcoX0yhXsZtot/pyiGwPFmP7NSLXtu4wQ7hIvl+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POIoLAFd++yNzu2lKMnu3mB94xs4U6dcy/DSJYCdxXU=;
 b=N563vXvfBzqE4+HdhBSF8gXRrZl74aZYTtUGTiDloCuzHgqvjc6TyDPy/RH/IUFRPCgosYnEPSrl8s5pJwvFj7LKO53KUgy/C3fq2YB/PnQRfwFg8GspIvl3lKJMHtMVaYbh3EA9m1Dgb8EpCMXvUEqTwCQYJkX7XVOPWGJ+yq4agdJ8f0Mmh1KtgGN1QBGdyf0rPcCBNtXxh2pQJ73vfj/89qq517HcyJzKqvugLdnSMKAbLH2u2+WelHJvuW0W695BY4SrzaSVnpUFwj5AvUhiSlnmtaNE7Fk+5C+VpNXSnKTDMSNg5fbk6mzQ1BWWNjPV5Boh3Gp2CS6t6PD8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.15; Fri, 10 Apr
 2026 21:21:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Fri, 10 Apr 2026
 21:21:37 +0000
Message-ID: <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
Date: Fri, 10 Apr 2026 14:21:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <adlIdusn61pKB3oq@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: fd410011-9da3-424c-872d-08de97472639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: 7mqxNW0cSDM3HA+oy7Pz+mavwN+v2EN4hiJbX0Zyv/d3U7hH4PcY6XDE+Znz31uTgwimiVfrBET1r/i6knIlD/LAfOx6hX7KSY3WifYGuUb3CMhZvOe4ve6u4x6gJXTrnrDysRcW9FJmTi6UupMyuNjodaSOopr2OHynVQPrN5tBicngL4ycPap+VUNJmWST9WDK5FlC0kRB6n6qE/aNVwtxwCW5qM0NFRPbhhgg3AfT+dWoUGRP09kv7NWR36X7Yg4byxN1mUCpPEkYDC7y6QrDR8G5msapKTzPUmWGqy+d8No9Jqvmg1SC35YZFtjObDXMRnd2AE6BpUb8rxechLcCSI64U16CLiwTQ2VOTWQp8MGF0BJnH3unpierp9xNSfl+u8OJg2FhzD8Y4a6wvawjB10ANWVhO9Z11ijLAs/t3EaDPDs+Se/Uvf4oFCUruwv2c3Kg1mrai2/RrX+Bh71Xbhj14pPg4+zyMrdnUqws50hVhqVC9w+hZV0+B9GKSF1TZepzhr01HAI02Dh9+s0impz4j2QRmLZiUBiU5rpIouhRe/J2XT4wHlln8rulbouWsB0dNBSiSkeM13+qKzNILtMowDqAfYQ+GCIZyvVMV+wMqtUaYsEIzrPY2XU4Af4e74xHN2HEGcYCn/2tG4s9yGiw3+x6jqspjAv7npkIledzO+DBdd0/46+otO+d0tOwHV4zk8Q9a+NkZPvaMTImQ8pFnEdOnpNVLmHhJqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG1IRjV5WmgzbERwMWxCbFROaFk2ZEdSbFRBVnUrNzA5K2VmcGhlTGxSa2hD?=
 =?utf-8?B?d1dFWVB4NCtyeEJtWmpqZ2VPUEJoVWI3SXRXbTExOTZVL0xHUWk5VUdud3F1?=
 =?utf-8?B?L3NHY3N4c0p1SnZ5N0QwanExTlRtMzdaSTJUeWI0RDFaVlhjbEdPc2wvc2tw?=
 =?utf-8?B?RHVDS2tkekxaWXJmbytZb1YvcjYwbDBvN1NGZFZDTDhVTVVUaWk5MkdxM2Jx?=
 =?utf-8?B?UDMwOEdpRGVuUVMyODJwcldLaC83bmNxM0NzZVdra3NVR2grT3R2L0FGMWli?=
 =?utf-8?B?OTZKN1NtNlNyejdyZXNGRjlFclVZUTgwbkxpVnNXTnB0RldqSXpXcjd2dEtV?=
 =?utf-8?B?a213NitnQ1hBVlhwbU5vaFhhM1ZWRG9sbUJXell5ZWEweUxydFg1TlRnb3FT?=
 =?utf-8?B?ZlJ2THRKVUo4NDlnd0YzVnYzT1NxT0k3ajBRdU5QOWlhd200TzZpZXBQTUNn?=
 =?utf-8?B?NnBsTWFWS2VTYWRjeFg5cEVNa2pFUUVLd1dFaGFneU9xaldickNPayt2QkJt?=
 =?utf-8?B?aGdnT3o0cDVMaVJtRFFqOE9VYkZYeEhXUXpLZmlhSDgvbnRrQkx2aEhTNENX?=
 =?utf-8?B?cUNuOUttN1lzenlnNGl4SWVtNFI2MzExbEVtdkRhSWVXam9hbkt2aWI3RmxU?=
 =?utf-8?B?c0trOXNDQ0FJUWZzUzBXR0dxZUdoLzgycTQwWFNQV1FXZ1VVRXR3S2dtTjVt?=
 =?utf-8?B?ZXVlUlVUVmx5YmtDemVpWEI0ZDkxWkVMancxZ0VUbnN1MkRFckgwNWxzT1Mz?=
 =?utf-8?B?NHQwa2kzRStPaUVCUnBSTURCb2ZSRU4xN0JCaWRQdDcrTWNUWTZxMGZxVHBl?=
 =?utf-8?B?Umc5WVZkSUZHSmFqQUliTTBQNWFVVnVrT2JtSEp2alpSMkxKTnAwa1ZaRUtk?=
 =?utf-8?B?OEJVei9TMHBadFVld0NKdEIyb1ArQ01UQWZpYUJOVENxU2x3NW5TMFo0czhp?=
 =?utf-8?B?L0E4VCtQOGU3THcvdGgxZ2FZZ1JOYU5zVlRhVVVXdnY1TTZHeEFXQ3BMQVd6?=
 =?utf-8?B?MVZvOE5TY1BPVkZFTkxVUHc1Y3Vjc1Z5NnU5b2YrVnlCQ0xTTVdONDFNeTZn?=
 =?utf-8?B?enVEOTM5S2xheXVUc2ltM3NocklRZXZkdG9FanZPb2U4QkJRay9vcDFqWWNr?=
 =?utf-8?B?ZUxvWGQxekZrZGVERXlrYjF5V04yL0JSMXV0NnBmbkwrY0FJMjkrQUF2ZU1Z?=
 =?utf-8?B?TWxzdktVL1ZrM3dycVpuUm5NV2k5Skp4WnRNRitxbldKaElzWjVoQ21GQVF2?=
 =?utf-8?B?L3A0OE9uWEdadUN4bWVZdkZOek1pNWZ1UWczL09XYWsvc0Q0Zm9FTmZsR1Nq?=
 =?utf-8?B?SUpueU9mVktucEorTlNrS3I3RktFbWZMQmsweEpPOGc0ZHFPUzRJQ0hMd3Fu?=
 =?utf-8?B?ZDdiTERJOUFmem81MUFQa01NT21rakRDeWpGWjl6ajg5VlJZMVBPNWtmeEhP?=
 =?utf-8?B?eEx6VFJ2c3V5M01WOVNVZGhiTlFKclAzSXFEeElUWlo1UG1kMnBjS0p0RmRU?=
 =?utf-8?B?aHE1c0JRZjllZ29US1JsbnhhZU85b25Sc01lTjBsNlQwUkJ0Q3ZpTDc5RmlN?=
 =?utf-8?B?UDlrV2FFNi9lMnNZWkZyTDRWN0xuSjM1alVlUThCaVBZUXFGRW5iWnpYS0FM?=
 =?utf-8?B?NjR0NEpHTDhENzJDUHdLaHZ0VyttcU8ybGZZbUdLWTJqRzVOSklHMVFoTHhw?=
 =?utf-8?B?bTNBZXMvczBhY2t0QWRXMnhlbVM4VFBtcWhGcDdJMHVDTjNGZzIydXcwb3dh?=
 =?utf-8?B?OVZLRmVZMjBUZFJPZzNheTBSYjZhWWJLOElFSnpscTV2a0hkQUVQT09kSXZ4?=
 =?utf-8?B?N25YWnBaenBXSExuUVR4TzU0Nk5Na3F4SHhvZk15dlFPRDBjSE1MTFdTVjdi?=
 =?utf-8?B?bVpVUnRBZkZma1JGVkxkeUtKbUIvb0V4RTZhMXljSDlYTXdwNWsrVWwxazdj?=
 =?utf-8?B?QmlVc0IxV2RrS2F2THU2bHZBMlBmK3ZxQTVtcTFuWU1GTmx6OGtPdGxRMlhy?=
 =?utf-8?B?bEF1RGlMaFNoRmlwWnBvTSthTGh1SWU5bitOZmNFako5cDlZYytka2ZVaFVn?=
 =?utf-8?B?ZEViUmRWR2xtUnhjUmdhVU5KOFlmNVNKUDZZQnc4WGZpcVRBYVRLZXl2dkwr?=
 =?utf-8?B?QjB3OTVwWTQ3UVUyQ2gwOHpRVVQ4QzBWakNOR3J3a2NSaStBd1ZmY1BpMDU3?=
 =?utf-8?B?WmphWVhqMjVWS3ZQV2w3UTBtcjB3WVQ3ZC9IQ29zQy9qYU9CRVhhdDB2Y1Nq?=
 =?utf-8?B?MWFyTzcxekRoZmxxbzJjWS91RlFTVTYzM3g1OUxsV3RSZ015bWxEL05QLzFG?=
 =?utf-8?B?UDZReHBib3hOWlRNV3RMN0F5MmUrZTlrMlA5SHVhazVzTDlscFFvTzNoaXg2?=
 =?utf-8?Q?GRiLiO44LjfzZDUo=3D?=
X-Exchange-RoutingPolicyChecked: q7HkiWX4rXgtnHRycKxI/Nv0LikpoHBXlJfx7Ydiw3x/7w5tro+h7of7ZsTypExDgnB5i1hCgAtCWxq717ds44/Up4F1V2JENcDlXbvX+cWniY4MIiYmWUOfyxfbBo+xnrlWsslklbeXtVkGeKsZNGwNPzBG2unVBFKHwyHDNAFVIA/ExR436DtxJqSY3v4XRGPHhLfo6K0GUtNEFFlkmuX+1SslhYbp6+6tQAPvTa3FY2id5bYbnvkAeZTS6MEoCiTh8WX3unspmqep4+jy/0LBZSJdxrGOTLx4ySPE4Cy07tKRtOHbZ8Yz1AbSVcDW0D5WOpIzl3VV4NyDpx8nKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: fd410011-9da3-424c-872d-08de97472639
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 21:21:37.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxDXUvBCPFhtZsA/CeCmq+7KLbHuLYmFdckMI0DCGZ7JksARg+45Pn0GCNspHuZCrGM4pqEqhp0sn2wsEz3BATsXudf6i8fAonhgD5OV4kU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com

Hi Tony,

On 4/10/26 11:59 AM, Luck, Tony wrote:
> On Fri, Apr 10, 2026 at 08:16:50AM -0700, Reinette Chatre wrote:
>> On 4/9/26 1:35 PM, Luck, Tony wrote:
>>> On Mon, Apr 06, 2026 at 02:16:46PM -0700, Reinette Chatre wrote:
>>>> On 4/6/26 1:35 PM, Luck, Tony wrote:
>>>>> On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
>>>>>> On 3/30/26 2:43 PM, Tony Luck wrote:
>>
>>>>>>> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
>>>>>>>  	return ret;
>>>>>>>  }
>>>>>>>  
>>>>>>> +static int rdt_get_tree_wrapper(struct fs_context *fc)
>>>>>>> +{
>>>>>>> +	int ret;
>>>>>>> +
>>>>>>> +	mutex_lock(&resctrl_mount_lock);
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * resctrl file system can only be mounted once.
>>>>>>> +	 */
>>>>>>> +	if (resctrl_mounted) {
>>>>>>> +		mutex_unlock(&resctrl_mount_lock);
>>>>>>> +		return -EBUSY;
>>>>>>> +	}
>>>>>>> +
>>>>>>
>>>>>> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
>>>>>> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
>>>>>> but resctrl is not changed to respect this throughout resulting in unsafe access of
>>>>>> resctrl_mounted.
>>>>>>
>>>>>> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
>>>>>> needed synchronization belongs in the architecture. Could this instead be accomplished
>>>>>> with a private mutex within the AET code?
>>>>>
>>>>> If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
>>>>> AET code. But there were some complications.
>>>>>
>>>>> 1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
>>>>> which is legal, but makes code more complex when call chains need to be compared to
>>>>> check that the mutex is being released correctly.
>>>>
>>>> Why was it needed to hold mutex for so long? I cannot find explanation here or in changelog
>>>> of v3. I did not remember correctly and considered the AET code to be doing the domain
>>>> addition. Even so, I do think a mutex internal to the arch code can be used to manage
>>>> the synchronization. Could you please elaborate why this cannot be done?
>>>
>>> I tried to move the locks into architecture code. But main problem is still
>>> handling when a user tries to mount an already mounted resctrl file system
>>> and gets -EBUSY.
>>>
>>> In that case file system calls resctrl_arch_pre_mount() with the file system
>>> mounted. You suggested that the AET code could detect and ignore a repeat
>>> enumeration by noting that the event_group "(*peg)->pfg" is non-NULL, set by
>>
>> It would be great if resctrl only needs to enumerate once but I do not see how that
>> is possible since there is no clear indication from PMT driver whether (all) its 
>> data is ready or not.
> 
> That was the root problem. But allowing INTEL_PMT_TELEMETRY to be a
> module adds the additional constraint that the module cannot be unloaded
> while resctrl is mounted. If that happens, the mappings to the MMIO
> space disappear. The existing intel_pmt_get_regions_by_feature() and
> intel_pmt_put_feature_group() do not do module_{get,put}() to prevent
> that. New series under development addresses this.

ack.

> 
>>> the original enumeration. But that fails in this scenario:
>>>
>>> 	# rmmod pmt_telemetry
>>> 	# mount -t resctrl resctrl /sys/fs/resctrl
>>> 		... succeeds, but without AET present
>>> 	# modprobe pmt_telemetry
>>> 	# mount -t resctrl resctrl /sys/fs/resctrl
>>> 		... enumeration success, but now calls resctrl_enable_mon_event()
>>> 		... with the file system mounted
>>
>> Thank you for catching this.
>>
>>>
>>> I think the bast solution for this is to change definition of resctrl_arch_pre_mount()
>>> from "called on every mount attempt" to "called only when resctrl is NOT mounted".
>>> This is because architecture code cannot tell whether the file system is mounted.
>>
>> Does this mean the addition of the extra locking in resctrl fs? I am not comfortable with
>> that asymmetrical locking.
> 
> Conceptually the change here is from "architecture must do all
> enumeration before file system code starts" to "architecture is allowed
> to make changes when the file system is not mounted".

This does not seem to be something that resctrl should enforce in general. Architecture
could theoretically make changes any time it wants and stage them for resctrl fs to
consume when it is able to do so.

> There are currently several limits to what is safe to do because file
> system only does a partial cleanup on unmount. But general development
> direction has been to move initialization code into mount path. For AET
> things need minimal tweaks today. For some future feature more
> refactoring from "init" to "mount" might be needed.

Right ... and we need to consider how the architecture and filesystem boundaries are consistent
so that this is managed well. Just adding a lock for convenience does not seem appropriate to me.

> 
>> I think a problem here is that resctrl_enable_mon_event() gives the architecture code the
>> capability of manipulating internal resctrl fs state directly. This is a consequence
>> of the original design before the arch/fs split. I see the additional resctrl fs locking
>> as an attempt to make it easier for the arch to manipulate fs state but I do not think we
>> should go in that direction, instead I think it is better to improve the arch/fs boundaries
>> here.
>>
>> To that end, what if resctrl uses its familiar "capable" vs "enable" separation here?
>> That is, the architecture informs resctrl fs whether it is *capable* of a feature and
>> resctrl fs, based on interactions with user space, determines whether the feature is
>> *enabled*?
> 
> For the AET features user space could look at /sys/class/intel_pmt/*/guid to see
> which events could be upgraded from "capable" to "enabled". But how can that
> be conveyed to "resctrl fs"? Adding more mount options would seem to be

User space should not be involved here and I do not see any need to add new mount
options. It is the architecture that marks events as capable if it supports the events.

> the only choice. Config files under "info/" are only available after
> mount. But by then domains have been created and the top level mon_data
> directory populated.

Why would this be needed? 

Here is how I understand the relationship:

- arch enumerates a new feature at any time and calls resctrl_capable_mon_event()
  to mark any event discovered during enumeration as "capable".
- arch is responsible for domain creation and is trusted to do so *after*
  marking any events as "capable", any needed per-domain state is created for
  the "capable" events.

- when resctrl fs is mounted, before creating any files, resctrl fs automatically
  sets all "capable" events to "enabled". resctrl fs will create needed files only for
  "enabled" events. 

- if an arch discovers new events after resctrl is mounted then it can still
  enumerate the events and mark them as "capable" - resctrl fs will pick that up
  on remount.

- arch can only disable an event as part of the unmount handler, this will clear
  "capable" as well as "enabled". This can be enforced with a check in the
  callback where only rdtgroup_mutex should be needed to access resctrl_mounted.

> 
> This also runs into problems if INTEL_PMT_TELEMETRY is unloaded between
> telling the file system that some set of events are "capable" and the
> file system asking to enable them.

This is existing problem and sounds like you are solving this with the module_get()
and module_put(). 

> 
>> For a simpler addition resctrl could obtain a new helper, for example,
>> resctrl_capable_mon_event() that only marks an event as "capable". resctrl_enable_mon_event()
>> could remain as the "early" call that marks events as capable
>> and enabled but may be deprecated. Both of these *have* to be called before any domains
>> are created since per-domain state would now depend on whether the system is "capable"
>> of an event or not. resctrl fs can assume that all "capable" events needs to be enabled
>> and it can mark them so at the beginning of each mount, resctrl will only expose
>> "enabled" events.
>>
>> There are likely some simplifications on top of current implementation to not make
>> this too invasive.
>>
>> What do you think?
> 
> I think it opens a new can of worms. Maybe the most challenging is for
> the file system to add a "hold" to the INTEL_PMT_TELEMETRY module when
> enabling an event.

This is a different problem that needs to be solved also and it sounds as though you
have a solution for that.

>>>>> 2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
>>>>> in next patch may be redundant) because intel_aet_pre_mount() is called, but
>>>>> needs to do nothing.
>>>>
>>>> Right, I do not see need for extra state. In fact, since it is not clear to me that
>>>> PMT enumeration will be complete when intel_pmt_get_regions_by_feature() is called it
>>>> seemed worthwhile to only rely on event_group::pfg - if PMT enumeration was not complete
>>>> during mount N it may be complete on mount N+1? This creates a poor user interface
>>>> though since user would need an alternate way to know if AET is supported and then
>>>> a "remount until it works" approach.
>>>
>>> The race remains, and is lost if resctrl is auto-mounted at boot from /etc/fstab.
>>>
>>> The user can tell if AET is supported with:
>>>
>>> 	$ grep ^ /sys/class/intel_pmt/*/guid
>>>
>>> and checking if any of the RMID based event guids are present on the system.
>>>
>>> Delta T for the race is small enough that delaying the mount to some other
>>> startup script should be sufficient. Users are likely to have such a script
>>> to create the CTRL_MON directories and configure schemata for their workload.
>>> So annoying, but easily solved.
>>
>> I do not have a clear understanding of how the new implementation with registration
>> function will look to understand the races involved.
> 
> I think I'm ready with v5 of the series. I can post (as "RFC") so you

You consider it ready without completing this discussion? I interpret this to mean that
I am wasting my time trying to discuss. 

> can see, and comment, on the details.

... and it is already posted ... before this discussion is complete ... unless you feel
that the hour between your response here and the posting of the new version is sufficient
grace for me to respond.
The first four versions of this work were all sent within one week. I tried to
collaborate with you on v4 but now you sent v5 without completing the discussion.
I cannot collaborate with such rapid attempts at throwing stuff to see what sticks.

>>>>> Adding resctrl_mount_lock to the file system code made things simpler. The
>>>>
>>>> Adding complications to resctrl fs to make things simpler for x86?
>>>
>>> I believe it is necessary, since architecture cannot tell if the file system
>>> is mounted.
>>>
>>>>> pre-mount code can't be called with rdtgroup_mutex held because it needs to
>>>>> build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);
>>>>
>>>> ack. Can an arch-specific mutex be used instead?
>>>
>>> See above.
>>>
>>>>> I need to add more comments on locking. resctrl_mounted is only modified when both
>>>>> resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
>>>>> read the value of resctrl_mounted with just rdtgroup_mutex held.
>>>>
>>>> ...but not to read it with only resctrl_mount_lock held as in snippet above.
>>>
>>> Holding either of resctrl_mount_lock or rdtgroup_mutex makes it safe to
>>> read the value of resctrl_mounted as it can only be modified when both
>>> mutexes are held.
>>
>> I am concerned about this approach due to it not being symmetrical and how resctrl fs
>> now adds additional locking to accommodate drivers.
> 
> I'm not sure I see the asymmetry. File system code already calls architecture
> code with some set of locks held. This just adds a new lock (at the top of
> the locking hierarchy) that is held across calls to resctrl_arch_pre_mount()
> and resctrl_arch_unmount().

The asymmetry is in the inconsistency which locks are used to interact with
resctrl_mounted ... in this version at least.

Reinette

