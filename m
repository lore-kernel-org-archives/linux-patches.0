Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754882727FA
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534045; cv=fail; b=Jf6gTbAZT+6NGerxvhNHv16yS2qpEZ+mNcINZ8SjKvKSHDY/bE/k25Pw6H6kN0ZcKUcxv/lNQf47bWvFFTpgnguSSL15CF8rhfuY0k685bBIGs2W3vMRT+57hbYLI5hDgy7XPl+1NKIDkE3g0Qh+RKndu8A/OB+OC8c3S1Tnzeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534045; c=relaxed/simple;
	bh=1zl2fIJpsRjZdiy3ry/1AEpg0izsUFIGGaqYA/ZHxQg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DBkKSmVDV9U+NsDpSl3OvWme0vD0S5qrWvenFyxIClUtds6rFgJunwneTeYPKE3mpCyKY5rPMwoUQsHamu7A/rHATJkBzeox/PY8j16Ad2IdDnnBnDLgJVWW7OzfYnR1CyhP9vAYuhxVoBkUAwpZ3wGNLPj/kDHObEPlK4oKag8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmerEFt9; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmerEFt9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759534044; x=1791070044;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1zl2fIJpsRjZdiy3ry/1AEpg0izsUFIGGaqYA/ZHxQg=;
  b=WmerEFt9dg/PBa/vHwm2hYNq9bO3i7AgFQQYAjQ9ieK53N0O/KXiFiGp
   3BvbnOW81p4ioh45MIUBQtSxlnKE+WSGdHktKubxH819pcpuiSxH2hOIC
   xrV1B22mYPqn96VA+BeS2dq4+SLKxmuY7KR8+KPAJ4NO7H4/5NICDhSqg
   C9sb9ivEk2nAEWyf1Om7kdvpPFJHFFNaUBX633z6WCycbatxHrm3SIAiS
   LPDa/0DOd3LoBY0cNytukRRPDVZEkibqQa4pucgG45bf+sS8OYbr1hYQE
   ex9WLKk8KU++UI2vlvpGvC2BylTbm9FBdRAbYPuciUifbi+NiMRO7uKV6
   Q==;
X-CSE-ConnectionGUID: gD8jJGYpT7u69n4aeMqViA==
X-CSE-MsgGUID: ZKULSAGOQqe58aTXAVrvxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61862742"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="61862742"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:27:23 -0700
X-CSE-ConnectionGUID: Fsa6QYpqQIifKqcRfYlIxg==
X-CSE-MsgGUID: QzNWrVD3TO+C9t1dkwknaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179826410"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:27:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:27:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:27:22 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2qd4DwYZq/DF/T5E85oNOVgJC2crUIBR43QIlsh0xAP0lTj/qlmub60S93MKo4mMoaQMwCT9mOpyt7BVDVULTttDqxo/GKui3KpQOaSQVmcNt3oKGxNs/AdfPQIUF/uu8UPUbJDAQvghfQ9F0Pw2lCHINHRFf5fEvHL7/NyrPOTrcbdkZaW9UFyNXzrtSNVkZAA9mY74eAtBAzh1ifNYU16r4G7RyXYIzIq+yrT4KXxzb/VLN8wAa1p65kpKhTzvsOOLgwcKdetBHEk/Ik8eOyKe6sTMqZlCa9vvIwjS+l43d+AHPVRxYAoDLx8Xjme72CKbMkEVqGirstO46dbdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYaale+nkhADoNiUIRxwJZZ49YtMuRtGUU4qZgFxnK0=;
 b=OsQaPlrH3m5Z8pFZzOqddNYHV0igGpsSnyykWsnehNcWdxZ3j9vIfP1RgJ7gibThn+sRv6ZMTQUvIYJG+RK7o6RiRIKoMPOfC1AHHCqYJ+azDSYyPKKDvJJ/JwZmiJXC3IMSqLgBF4F90Wn6mwPEG9Ptg1yM3khffLGCjBMZ4Yg2YBg4tGXuU3ur5Iz9hWWx2TjV70YT6qlRX5uSudDavovxVif/5SkR4asslgqJ/+NOP1fu33KW2UogCv2IN1kdpUS88u/tPHJofge90eGrRynkERTyKRmjgeO54+8a51j96EzC8G7gDiDBdBJDXoWMTFtpDAbp1u0GH4+nd27ARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Fri, 3 Oct
 2025 23:27:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:27:14 +0000
Message-ID: <6ac08f9f-3f48-4178-9b59-b4c4f93966cf@intel.com>
Date: Fri, 3 Oct 2025 16:27:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 09/31] fs/resctrl: Make event details accessible to
 functions when reading events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-10-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:303:b4::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 3167769f-5e24-418a-fded-08de02d462ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZzZJMXFiRUlTb1c4QTRncnpxYXFyVEVjeEMwVys0ZmxDRFpnY0s3cThmb25C?=
 =?utf-8?B?Z3pIdHJxeEVDWGhwZ3ZZQ3Q0dS83M2pYcDBPS1luWEx1YWxZUnFTbTVRa250?=
 =?utf-8?B?YVdIZWswSjdPOXJCcmJhREtPSlhtenBTUFp0djAvbWw3M1hkY3Jjak5EV1dq?=
 =?utf-8?B?Mm96MVFXWW5weHByQkNhdjFLSVNMTWJ4STNaT1d0RVliL3dqMFFoMXUzak5o?=
 =?utf-8?B?dFNlUENBalAzWWUzQno1Rkh1K2IzdU85dkdMcGgzaWEreER4ZEIzZXhCa05B?=
 =?utf-8?B?RS9EWVdVNVNuZVpLRVIvKzRtdzRSOGN2YkVPYTJ5RlJuQWQ2UE1mK3RkQnRK?=
 =?utf-8?B?S1FwUHZLRVYzY0tuekI5NFY4S0NQTFZ5SzZZT0lQVS9qcWR2SDBaeFZZVW0z?=
 =?utf-8?B?clpJWlUvaGlQNmlmUmtaZytwVGtZNVoxUmtSck0vOWJkNUhxTkVTUGFhUnpK?=
 =?utf-8?B?K0ErTUppR3pmSFpJMWljSlc0bm9YYkVsZUIyZE1PVUNUOEVDYXNnUkVIQUJn?=
 =?utf-8?B?KzQzWlJmK2FWbjBQR1VkMzlCK1o2OThLVDlsWVF2Q1hYbUVDam1KQmM1ckV1?=
 =?utf-8?B?WnRWZDRuS2FiaTN5cWFxbGhXWEdJM05CU3RSenJLVUMxeHhDcGdpTDRreUZQ?=
 =?utf-8?B?enRFdm9iTm1ReGptQ1Q1MG96c1ovY0lEMjZMdHBQRitZQU1RNmtFbE9Gc0hM?=
 =?utf-8?B?TDNHQ24wMlFhUWZ6Y0xONXBhQlFnV29YSWxWR0xCMncwOEwzTjlXVzFBamd1?=
 =?utf-8?B?SmlIZksvRmFRTjJqTmhoNSt0Z3Y0UDM0d1J1WXJrU05iNS9YTXRDNXVISzNR?=
 =?utf-8?B?cFdyU0dNSEJhank3T1l3bkovejdFZitvZTQ5aXVvdjlmZmNmUXppbis0N29j?=
 =?utf-8?B?d0hpd1hxNFBlQTU3akQzMEk5cmQzaGxCbmpjWVFxc2ZKZkZoK01GUXZhZm0r?=
 =?utf-8?B?SUZJbHY4eWFlSnZmUERqVVdqZjU2WDRrcnVFS1ZlZTlpemJkMTYvWkJCWU9B?=
 =?utf-8?B?dUx3OXVESEdUaWx4MUxCQWlFSm5sSFVxWDVOK1VUS2lacWprRFVwRy9EcDdL?=
 =?utf-8?B?c1RhZWd3c3pJeXMrK1VZVlNUd2s2cW82RHBmSEZZYXc4VzZnZ1ZVcWVtN0lz?=
 =?utf-8?B?SnplbC83bWZnM2JUc0xkSkVmTkdwZmw3Sm1hOXhXL2xFTUNvdUpzamQ5bDl5?=
 =?utf-8?B?MjUyNnBnQVFmL1dCNzBkeXBQbjRaa0cwTWM3NXBQT1dSeDE5cld6UndWRzRl?=
 =?utf-8?B?WHFlR1VGMjlYUHRucTNJRENlalo3aGo3V0hPUkMzeDdibUhLN1Mxdnc5STFj?=
 =?utf-8?B?ckhQNWRmeXVBc3dqdE04OXc2TGhwUDRyRzNVMERzQndsbC92OTZraFJBaEg1?=
 =?utf-8?B?VmJ4U1ZWeGhvd0RiQTQ5UDZ1aXVwQ0ZmcGNrZUdwM3U4YUYzMmVlOWlZY0hv?=
 =?utf-8?B?bUlsUzF4dURpUzFLNnRkTFN6SXNZekczZVdSdit3N1hJYWNUd1ExQkZCM3NC?=
 =?utf-8?B?SFRsdnlLejZrTWZsK0FTY0pYV1dlVklUNTBRZEJjSy9aVmY5aUk5U0lBTklS?=
 =?utf-8?B?ZmRUMk8xNVNwSWFXRnNzMG5DZkxSQzAvUjQrRjFvRlBmWlc3UlZwOEFRajE1?=
 =?utf-8?B?VVJhQlE0aTBqSmFqbmFIaWw5NjlURTVyTksxSUYwQTBvNmFTbjBKT3J0Ry9E?=
 =?utf-8?B?TWhwY1VMbi8zMXUxNHJEUFprbUR4cjhRWjNKTThHM1I2NVhSazE2bGlmblIw?=
 =?utf-8?B?MnVhNU5JNVVPMy9NVFlGYW90b2VqVk41RjNhVDFOZWdqeTJSUlZHdWlkeEM2?=
 =?utf-8?B?bk12K3B4WTd0QmFuWHpkdENBU0FBSVd4K1pvU0NuYmdtSSt2WWIvUWZtTGVo?=
 =?utf-8?B?eVJ0cmFEMzh1VHV5cWRMWjBPQ29WZUFNRUQxMmNMM3RPaytnUk1iVWc1ZVF2?=
 =?utf-8?Q?sii2rKxA8uaj8QMw5mbD5guAKRdysfCp?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW9paWQwZDVma21SU3RTM3VWM2o5dFIyZ3Y4c1NtbU5DL2tlRUJLdmpjc2xW?=
 =?utf-8?B?WWNPY1RodVZyRjRLeFpTaGhYMjNMNXRSWEg3N2pZWFd3UmZySWkwb2FsVlBh?=
 =?utf-8?B?c3BwVzUrRTFOWWJua3g5YUxuVGwwcm5HUDlMRkhrbkN3QmpEa1pCWGIybWZH?=
 =?utf-8?B?OGN2WDBKVmdrbnllS3JnWHkyaDBFUHN5bFBsTTY0c3FsMWpRcXdzTlZSOWwy?=
 =?utf-8?B?MnFoNmRsMDdRRGZ1Ym9ZMFlBUWNQNUNwRzh6QWppd21ESlpDbVd1eFJRdUNu?=
 =?utf-8?B?MDhTSEU4Zm1SMGxZZXBqdzlLd3VwM2lNaHFPQXZOemNKb2FCZ1NFRTRvTlVG?=
 =?utf-8?B?TVVKQ0IzT3dTNUJLUEdKMTd0cDRRUkI3VURtNFMyM0R3VDZoLytJVE1EV09T?=
 =?utf-8?B?b3pIdTNLUjBjSm5ldytPUHZtUVdqQzI4MUNuUlBiVytRdW83dHdMME15ZUJ0?=
 =?utf-8?B?bDN5eGR6aDBDeHAzVzBrQ1F3QUtGZkRWU1ZYRzEwRkhQUy9yOWRybjIvWUZE?=
 =?utf-8?B?RnMxc2ZQVUVVaHFaRHl4UkIyQmFscFgyRWxFUlI3MGRkcFlGQlV3Rk40QzV0?=
 =?utf-8?B?VVZZeFhEbGs3bnIvQ0pZSG9mWkhsU1NDaHN0UzNBeG5hTWNBVEtxVzJFYS9j?=
 =?utf-8?B?MzdxeUhZc1ZYY284eWZpSXIvMSt4YWk5dmZrb1BGZmQ2VzVVdlpoUjFCajY3?=
 =?utf-8?B?NnZxMmFSUy9zOWVVbGQvVm95aEpqNHZzOGh6NTlwMlpFVnh1YWZNS000QmNT?=
 =?utf-8?B?MnlNenlXTVFlakk0VEVUZkYwQ1pKWVJUWTlFWk5qZWk4Y1U2UG05dzBqUzdQ?=
 =?utf-8?B?Ri9udndOdERsY2dxOVVBOWVUZzM0dkg1WG8yVmQ5Y0xaQXA0RnZPNG1qVy9k?=
 =?utf-8?B?bWZtakRvdXp4MWZZWWw3bWhOL3c4WlBBdnJHNmFvUWJJL1lIeFJQM2dIWnhm?=
 =?utf-8?B?VnEvS2ExdEN5K0paYlQ2YUFmUjBnK0NLQVQxQUdndXdjNHA1NWk1S1c3ZWR4?=
 =?utf-8?B?KysrdTIyYVNHSVQwYlI4dnpTbjFkQndDS1FHNUZ5QnM3eHd1Y1gxVVV1VUlV?=
 =?utf-8?B?bWFHVDdPcm5vYVZHVnd1cEYxRGVCMTcwZkJYN3FWMWV3cERtdmpCNm9YbDg5?=
 =?utf-8?B?THdhZ1RNVlUxdHY1elRpZDl1cFBnTCsrY0xWeUNXS28rTVFIOC9SNzU0L28w?=
 =?utf-8?B?Yk8rNUI2WFNXNVFnSUduSkl5Nys2YlRaRVJ2L0dhUTNPNWI2VCtBTEdvdTlv?=
 =?utf-8?B?UGZCeUV0V1pVaVRFOVJiSmtYU1h6eTZRbi9ZdDJveHlYcjR1ZWJMeDA1ZFpV?=
 =?utf-8?B?WUwwOW5HWkRpVjByRFZvRUJ4RXc5SnJPL3lTSHQraDlhREw4dzNTdUJubEk2?=
 =?utf-8?B?ajRPcklPRE1Kckkyblk5SHVSZlNMelRZUHZBeFFwaVBVOTZpRkVYRHBzT1dq?=
 =?utf-8?B?UGM4TDYxWWwyMEVSUklUM3hQK3Vsc0RUYzRCbzl0OXJqUnZaK1FNdE9HQ1Vh?=
 =?utf-8?B?NXpxZWpYM2dtS25CMjNKZ1U5dVhXbWRFRmtIMlBtRktHRWswZk96WklCTE41?=
 =?utf-8?B?bzdobGxGa1h0RWxYUEFMclVxYklHb3pxZk5HMEF0SURzTFk1UjdSbkNhbU9m?=
 =?utf-8?B?ZHZlcU15TVI2YXcwczdHYm54bzRUd1NXbnRhZ1ErVThjeisxdjg0VXY4YjRU?=
 =?utf-8?B?NFdjQm1mSERoZjgyQncrSmVXWTUvTTFWcmtOVm8veVUwSUI2TGxmVUowMlJ5?=
 =?utf-8?B?YWVpcDFvY1lYMUxqYm03dHFhemhiaThSSVV4ZkdINDAyVHVaeTJhamxzd3ds?=
 =?utf-8?B?QjZQOTdjRkFRdGRwTEdyKzdIYS9pNmQ2NEFDTWI0UVhYNXVVWnZjZEVGaEJM?=
 =?utf-8?B?eDI2SmhYTjhENmpWbjNEQ2dtTll2YmFGemJYcWJqckdLcTNhOUdWYnpYMXZH?=
 =?utf-8?B?ZWpKZUovc25EL0dUMGpTSUg5MzJ0SVMvNlE0RG92SVZPU1NSeXhha3R1NDJX?=
 =?utf-8?B?bnE4QUNQMHlMRDJEaFNUUlI1aGJZTTJLSTd0YlhFWmNnV1BVeTA5aHRKSk51?=
 =?utf-8?B?NWNmYURFdDZMREo1RCt6Q3RDeGNXSXVaWUtaSmN6MGc2WjJwQS93TnNnR1du?=
 =?utf-8?B?RGxFYzR0V3NLTy9Id1cyNjdYd0U2UDJzdkpYaGV6RTkxeng5UHpvL3hGSXFk?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3167769f-5e24-418a-fded-08de02d462ad
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:27:14.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYbSn/WJrnrP8AWvtVaK2jrTc0GfUEv07zo0hHUp0kn2ENDUT1FeEfqqiQ67qrb18LZ7QVf+G0wRyExwnl7T4Tvj80Y1aT/8h7zYrJIU7pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5028
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> Reading monitoring data from MMIO requires more context to be able to

To tie this together with the "instead of just the event id" used later
I'd propose:

	Reading monitoring event data from MMIO requires more context
	than the event id to be able to ...

> read the correct memory location. struct mon_evt is the appropriate
> place for this event specific context.
> 
> Prepare for addition of extra fields to mon_evt by changing the calling

"mon_evt" -> "struct mon_evt"

> conventions to pass a pointer to the mon_evt structure instead of just
> the event id.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
