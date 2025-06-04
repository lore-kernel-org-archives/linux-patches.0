Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F59E230D14
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007601; cv=fail; b=Y8xOwKO08BMBeNCuuwquooUkmt8V3Gfp+P5KffX4UAWFAA7WaJ4KjzBoCowjogxsFjsifJsu/rtG6BxQS0BLp2kyC+4eXBOTQE3OwlBNSJPaCS/YexartuOrid65UIqaK7b+b7tyxoxBcXgiqPhGqDjwnI4ErvsCwcZFFGAyF7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007601; c=relaxed/simple;
	bh=vFIi13l0iyy+EYS2k46/3u24xMKaTvStfWVW9D/OMUI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CI7u+UeZgFXHBVbHixSSmeC5QnqFpc88vEpaCc1H+Hy7YkYRcJ3JSPTWnNIaOUW613pPqGY0ZLTGZZjPKqG8ZeLhMP8Ro+9BTzi6QXC0Rb7+drv2Z2ADhBvDWk0uMIZ2/HpABMLlcPDEii9qTtx+JAkmocrFOA7UNT7vfq8U6c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJrpNtOM; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJrpNtOM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007600; x=1780543600;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vFIi13l0iyy+EYS2k46/3u24xMKaTvStfWVW9D/OMUI=;
  b=VJrpNtOMpyS2ftpxH4GcnqBSaqQEt9cWB0YWgigEY1UKf/zWyVb1nMSp
   MWChkE1XbdTTsXhRZdzFLG5Jh8CraOnm3+rW3tvgPdTTs1bpct5ecb/7m
   FzS36A7Df47hzkOUedzMRwryAJK86OQzqBpeBhJdQXd9hHvGBPdi5oH32
   Ghrt05nX4wR+FPDB4dSLT/gpwzNWVfz5dOuI7/h99fNIoQzGdpasWDnm9
   6zDWhwZrLNxvsW26OPL/x+X5Gl5SliZDJ0FdUAHgbX1dQGtZpTjkA135L
   W1DCrlDoy/OphPGIEHHlaWSp8/0rTgqgpJsv1S/7eWTj/MdmG56xAbYAt
   g==;
X-CSE-ConnectionGUID: KbbVwYuxRzWv1GJRdvsO3g==
X-CSE-MsgGUID: eppkPyfOSMaM9O8SQ8ULOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61692437"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61692437"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:26:39 -0700
X-CSE-ConnectionGUID: /dKTncFTQCm5y9jQSbZeNg==
X-CSE-MsgGUID: de8i0uAZQyuv6vTUVkOnnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="144921800"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:26:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:26:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:26:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.75) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Amo0SLfH0U9lIc7CcjejcbNuDM33LNM8e4NdhpzwdeowOw8RoKRoYmeAnbWhrZR/k9GcKKLA8a3wBMdNTmxUFR0ct2Eettc2YQyIdAQcfJvIlF0Oto+gNYPvgaICle0F1gFU0qqNxKRiq04F1va7FZ5746XbhOie7uzOAEHNs2SqDv5ipPE8qGb5EXbDhaCxBKHyGyB2EAMDl3bOiajzFfDtAm/TnpeZ2OyJ0A26GwrQ98BG0s9BIKoZq0YbtsnD6vUpsW59ZHXYzAmHpX8qOEF/6gUAzq3RANRZFlbC/NFRV6FpTPBqod/PsGTtee49Fe2wUx+KSY7Su7M3gLYK+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhYqX9EkB1PmmAtRrOttR04RMmfom+N9jOY5oeZZzGI=;
 b=kOtK8bZsF0j7nTAoOklvbvwVh1g3NGwwcyE0FygGSD5O9ix/OVx55udtV9fxTzaVREaSi9vpgnJFuSwtwqRkUSxWWBqpdkQy/ekjCR12w10Pg74XyHirm2F9/T3VNUa+RbPYm+bPVPDVlgQahikk2000IMRKfgIsf9Dz5usxsPL0rfqYWKxZuw+/3+R9EkADUEXgNvqz14Uj9bNNIMDX/l5dMGZ74abzsI8CvEGGeOYEUPUA/PApVAWCV7Ff2gr0Igmgr75zQpO7WkJGXAdc+fvtUZQSKMAaQVIfvGgXEd2/ytb9r6MX9PJyd6nFNHS3jG0RgDuFO1oXXXKUK7X3aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 03:26:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:26:36 +0000
Message-ID: <9e114b7f-688d-4a9d-b817-967c76ce99ea@intel.com>
Date: Tue, 3 Jun 2025 20:26:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/29] x86,fs/resctrl: Replace architecture event
 enabled checks
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0112.namprd05.prod.outlook.com
 (2603:10b6:a03:334::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: bf5e7513-b5ff-4426-d1ec-08dda3179c7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ajZWcDZBbDhScUFBTkh6dXFUN1JTQjdBMytBTUlGUDJuRlErMWs1bzhFUzhm?=
 =?utf-8?B?UEhiZkNWeFlPQTREc2FtS1BWNEhzWkZVdm9oL2cwUmVZY3RqUGFJV05Tb0cx?=
 =?utf-8?B?dkh2ZVZPTW9ZNUQ1aXBDQ21UZkhIVzVtK1Zmano3bEVuUE9kT3pVTVpDL3E4?=
 =?utf-8?B?U3JEK20yazhNOWhFT01IU0dPU0tDdkNSNVJ4TU1VMHc5aExpRVBEeUdYc0Fw?=
 =?utf-8?B?WkIzTUozSmtJTm9wNGFpbHBDMVhLTDVFUWlFdDlibFJlMFF5dW83U05kVmUy?=
 =?utf-8?B?Y25NUDdwSnFnclBvNEZMaWJVSndGMk5FbktmVldBQnlXS1J4MWxDbmM1ODJz?=
 =?utf-8?B?WG1VMFd5eWVQRGZsKzVtUWFKSCt5YVVoS3N6NlFQU1ZnNEtZMCtRNTZxRncz?=
 =?utf-8?B?Ym8wM0ZIaU8yNmtoRmdsblhyQmQrZkJERWFacW9JOG5GOUlpUDV6V2xkNGE5?=
 =?utf-8?B?UXFWOC9ScnE4T05nbW96aEtZM3lTNWVmVkxiL2VJSDVXMFVyM21hV282eENi?=
 =?utf-8?B?aHROMEtsa01mVFpnb1ZIZmp4ckJWdktXelJxWTlOVE5wOXN0MzN0Y2MrNkNV?=
 =?utf-8?B?ZGxJZkFnODNkOTNWY0lBS1NQV3FqTHI0ekxyVy94VnhxQzJLZnlBSW1RakI5?=
 =?utf-8?B?dk92clQrZzlnQnFmSEdsLzRhVGlWUDFvQlMzR3dSeVNsTUdTQkQxMkJFTGoz?=
 =?utf-8?B?Wm9Kc3p0TysySzZXTDhXem0yc29pNmcxKzMzZncvT0FJbVVkRU5TUkZJNUtW?=
 =?utf-8?B?N3UwcVdNTGlQZmcyL21wc0E0RmlUcHF0VkVxNGs2NDBoeDM2UzE4RE05OUlG?=
 =?utf-8?B?RXZTYk85bHFLRTh2OW16WUpVeGJPUWVhZjkxR0kwWTUwSVJIaXFmU0RTbG8x?=
 =?utf-8?B?cWs5VGl2bGp4WldORWc4bThXa2dkQzRVR0hYYXZmOGxmOUtWa3o1ZmVmVWFL?=
 =?utf-8?B?dzcydWlUR0FWNk50SXRLcStBbWZUUlhHMGdJNWIvVURrR0hTak05QjdMM29z?=
 =?utf-8?B?OWxyVUVueTRNd0ZCQ1l6WFUrQm92a0JZKytwRmVFOHRHTVl5bnZsQy93Tjdq?=
 =?utf-8?B?WEY4c3NoWDZ1cDYwZzlYTFpyb21nSlpoNUZiaWtEWXg0TitVMUw1QXIwQU8y?=
 =?utf-8?B?cHp5b0FOWXdyNHhSTWROcWZBUHRYZmc3RzA5dEh0Y2FHNnVLS3o1MzBnK0hm?=
 =?utf-8?B?M1VYRU01Q1lFdFdIWDQrc1kwVEJhdWV0eGl4MWphY2FkRm9NZWlWS1FSdGRw?=
 =?utf-8?B?d1FSdllhM0ZuZUZ0eXp2NkVPS2ZadGJZY3Q0d1FBbVV2K2NRS0JONmZBZERP?=
 =?utf-8?B?TjhXdUp6LzcyQWw3NzNsWFF6eXBYUVp3UXhuY0lpQU50MjBEUnQyQnl1a096?=
 =?utf-8?B?TnVxbTVyRXgyZUlRQnYyV0RTU3c4SXRFVUlGV3VHay9yRnoyM3cwS292cVlY?=
 =?utf-8?B?azA3Um9KTktIYnFkVUt2Q3FpYXhIdnBWZTFTOWoxcVVHVS9FV202cTNUVTc0?=
 =?utf-8?B?dXlVaThuNUtDT1pMc3NEYzhyc0RsWHRDK2pySWUvZitwTy9uWGRqc2cvRDZh?=
 =?utf-8?B?TnJSSTJNL2dXbkpXQ1Y3dFdMUStKUHV0ZHNHcUk2SE03SFZ5WENIbUFlVGUr?=
 =?utf-8?B?eWtuaFI5czB3V1hrSGEydXU4dlN2MlIwRS9LdlRQbW1NbW1VRTNrcXdwd3ZG?=
 =?utf-8?B?SmJtcTN5VUMzdDdpZ2lzeUZxTXcxYkxlbXh2dWlJZTBjM3BZZzY2UldXY2VS?=
 =?utf-8?B?K0tYbmJxSUVmLytpNE9tTDZpeElkS0M5aVJlbEdaZHNsUnpQWEJzM3JZODR2?=
 =?utf-8?B?eUt0WTZ6R3BpQkZyblBUeUVZVVdXVEdmSTlQUlBHL3NVU2IydUlZbXN3VDJy?=
 =?utf-8?B?M0RXRm9iZGNneWVnVTQyaVFHT2l2R1lHZjlWeXI2R1JzMmVJbU5CK0Z3bVlx?=
 =?utf-8?B?QkwyemJsQnhsQkdsQlRZTWNKbHhJMkRxamI3RExwV0dyZWlGcFVWNW0zZnhS?=
 =?utf-8?B?dDcwQUZZVnZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3p3aHdZTDJhbXZaRzBGRnFxcm9DZnlNUjJTb3JNZ2tOb1B1YWEzb2x6SHox?=
 =?utf-8?B?aHdsYnBNWGZMMElCcFJ5REpOSzJPRkJoZi9ReDN0NFd1REhtc2x3RFl3VWR0?=
 =?utf-8?B?MXV0NDZFS3VmTHhaTy9FYjJLMVVHcEtKNUQ2Zzk1TjVka3NyWVFnNnNodkdE?=
 =?utf-8?B?eWdxdGtkSVk2SXNKOUsrVnhLTzZlN1RsMEtBVHU1ZU1xNkwyUUJPaEQrTHdT?=
 =?utf-8?B?cVF6NGxQZGNaVTRBdzBQWFNKNDRPQUE3VUJQdGsyek9DRnVWcmprTEVUT2tR?=
 =?utf-8?B?VDdpZmdDa1hRUFptc05wSW9jakhxWkF2d0tnd1Vod3lwSUhoWTlQcDZxMDhH?=
 =?utf-8?B?c3JJTnZWUmptdncrOUNhZDFPQ0J2L1YvZ3d0VnZtREwzcnF0V2s2ZExOeGFw?=
 =?utf-8?B?NGRiclJDSDh1OGp6VkNoeU95L3FTMG1QTHJETHdlWHdpaTFvMUlsaU1qZjdk?=
 =?utf-8?B?TWc4R0ZOa0VCTENJRlJVWi80RnFCYjRwVG81KzlBWmtDVmowMjNjUWo3N0FM?=
 =?utf-8?B?K3Y3WDRvMnJxRnlQL0VQLzVOdHZoZnJWdGI1c0k1bG8rYi95eDFSazNZcExY?=
 =?utf-8?B?dXJLZHJUZXZpL2E0VUlHa0dnZWliYmtBczdpSG1ySlR5VzNzY1dHTkFWcGtr?=
 =?utf-8?B?bUhKdGs1QXY2ajVlMjBNd3U4dkwzNWQ0V20vWVRGOTB4R1JYSEtDcmZ5N0Mv?=
 =?utf-8?B?OUQxbm5PbGxwM3VtWUxIMWRRdFJvMjhZUUJDa1k2VlF2TXdQSnVoWGQ4WkMy?=
 =?utf-8?B?RldkRDNnUm9IWDd5bThGSmlFcTdQa25jNHFXc3o5NGhmZ0poK2RSM2k2dFB1?=
 =?utf-8?B?cFVXTk5YRDJZbzhvRE5nN0x4d1RiMHB4QXZKOEZVeDlSQjV3bHhjMEt5Ym16?=
 =?utf-8?B?cWpwYjJZNG0vakZ6cWdZZzNlK0NNRVVQS1hLQ0N3V204aVBLYjFXOERQVXNI?=
 =?utf-8?B?SkY4ZnV3ZDJRVVJxTnA3OGhZUzVyQ2ZZdkF4T3pBUDhVOHhKT2g1TDY1dlYv?=
 =?utf-8?B?a2hBTTZSSjRVNVd3aXlvc3o2MDV0UmdQSnhERVRNSVhmZ2NoSnRUTUl1dkFs?=
 =?utf-8?B?eFBZQXFQbWRxRS9ZRVdYQTd6Mm9PZUNwajhWbVhuMEJKWVBpMXBlY2o5b0dz?=
 =?utf-8?B?UFcvT3hJVGJYeGl0QTZTY3l6NnBWSUFVemJVb055NGVId2hpalRmRVdncW90?=
 =?utf-8?B?SnVlZmN6ZEJBL05RZW1zMzlBNGozUzhkWUprVVhDVUpUaHlRZ1lHcnZWd05h?=
 =?utf-8?B?bFE4MXBvdHJHU1N4WWt0aUxucFB1Rk12WW5adVN2MWJyU2d2L0hHaEx5Znpq?=
 =?utf-8?B?QVpHMjg4WlBrS2VzSGRjNjNzc0t1cmE1UXZJb0x0Vlora1NNdlprTmZiTU40?=
 =?utf-8?B?emJvMXFiZFZ0TUVzcHdZWXpNQWErQjhXbEFHVCtxV05sWkY2YmhoNmJmdGN4?=
 =?utf-8?B?UEtCVFQweUl2R1VISU5GekRVWkJFMUpBNVlYbi9SWml0dFVWdmhYK2VsbGsz?=
 =?utf-8?B?SHgwYW9CUVBndHhJai9HeFUzZkM0SVV0blJRK3E4eTlvS2diWDBVeDRHK25x?=
 =?utf-8?B?b3JsQytyYmRyRnpZRy9jaGxXWVFxQzA5NVNUUGxOQTRBREhNMTJRTDVNZ0pZ?=
 =?utf-8?B?Y3ZiemRwVUNQUzNiaUFONmpvei9pRlJIQ2cyei8rZG9FZDhDbk4xY3g1a21O?=
 =?utf-8?B?bVNtY0N6ZGFvUlkrSXlPbDVydzdoOUdxSDF4YUhhMEthZ2s0MUxpemhTeHNG?=
 =?utf-8?B?cjNYb1I1M0lDYmhIN0NFZEVMWVJpaXFMdlJzYklIZzZwNUtTLzY5MXBTcjkr?=
 =?utf-8?B?cWM1bThwcFpsNE4weHpkWWg4Q2ZLb1UzU1VhaFY5SU5CL3hhMXJXcUdhWGYz?=
 =?utf-8?B?TW1jeWtOSWkzK2NOZHY0cHRwZmxDZlhDYldpZFZ3STM2Y1NsS2Q0RHlYNmpK?=
 =?utf-8?B?N2FMV3pYa2tqSVhWajY3NXJMaFNXcDNTVE5iZUdqay82R25IdWtlMEdJZVRH?=
 =?utf-8?B?Z3VCYTVxU0lIT0NhaC84Zzl3L1o0VG1CTDNWV1gvdkhQSHNlblAyUVUwVFpB?=
 =?utf-8?B?QytySnNXS2VIVjJmeDd0aXJ2Zm1wZkhnU3hMbnFEcDh2K3VHOW8xbHoxSE9r?=
 =?utf-8?B?Y1dTMkxEeWZ1Mi9lcTR6ZGd1bkUwZVJ5bWdmZG96ckcrZHZNSG1Ec1NONFJX?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5e7513-b5ff-4426-d1ec-08dda3179c7e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:26:36.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQTaKOpteiGcQx0RGSN+b77p9ZxBkBUe9r0BT92v2CG0hwuJ8qDmLygJZvhDCm3WGByLdC3f2haQ/wwHNX9Nfu9AV8sqFZIhYxiP+TQ2k9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
>  
> @@ -877,6 +877,11 @@ void resctrl_enable_mon_event(enum resctrl_event_id evtid)
>  	mon_event_all[evtid].enabled = true;
>  }
>  
> +bool resctrl_is_mon_event_enabled(enum resctrl_event_id evtid)
> +{
> +	return evtid < QOS_NUM_EVENTS && mon_event_all[evtid].enabled;
> +}
> +

Similar to previous patch the range check here looks to also benefit
from a new "QOS_FIRST_EVENT" or equivalent.


Reinette
