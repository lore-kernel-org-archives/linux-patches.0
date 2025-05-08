Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE4A1DE4DC
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746674957; cv=fail; b=unLIbYj/nGHgeQwMUNDEcUKoaORDPIXposhPoPtk3HK7u/lMznLo0BWNLZKcQ3y5M9xozK2sre+iAXvjkzwx6gK8lXcl4PSfxvYQQH4kJgHbh7zS1HAgyqLDxEHullrAf2WbbUpT7TZDLuUSVVNAhPko5MGJviOAebRBuXy4vEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746674957; c=relaxed/simple;
	bh=3ICnKlLqUqgoqrEFJUv/NqTpUipLuzkolP5DCuqmhkE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r85LW/QGgVaaBOPc01GkZ2gg+uNVJOsu3qRW/INMxodl1vPCsKUqergLqdqPy9Ovs/3RGGJy1/3ymAwRmMuy0rvjSU5R50H7Fs9tqw/TBa3EOsH6gSfJ/DuMuiLRANKe0bMqKYqvyzFt51gQy4bycFDqCJ5LtK5LJVvdOgnjKc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjuw8X/9; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjuw8X/9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746674955; x=1778210955;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3ICnKlLqUqgoqrEFJUv/NqTpUipLuzkolP5DCuqmhkE=;
  b=hjuw8X/9Dok3lHvDkpzx1T9ko4UOPvzwM83Q0lzOCpSqUtbw2Q5xI5OB
   /U9eK5JxCDxyBMPjnmkGC7JTgQdoBLXJnHGAIbQhurFtBmd2t5x9CDNwb
   OYC5nfW71YXn1A63pRPCM7xGjoC/6X/BoxnLFvrXxSlpPo87babvfGiNg
   /JU3pO9VIR6cOaXkUtZOrnGCg8xF/qAVSVcxoF9jCnrp0T7yosRK5bVUc
   u2JYuuRXYdmNQQJpLA4TGZ0QisQtcK0ecwahkw9EguAF3R7s8D+4D099A
   vOKDN7Hj/uuyUAilu+kYDwQnxG7RVGB3PYCPuUJUnoIH2Cx+BLTx9fXIE
   g==;
X-CSE-ConnectionGUID: ie3MgXCjQEW0Q5Q6Lsaz6w==
X-CSE-MsgGUID: NKCbPbUsSo2E8PmH1d3sNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="70942372"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="70942372"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:29:15 -0700
X-CSE-ConnectionGUID: XPKsd/QSTGqAIKNSPybNjw==
X-CSE-MsgGUID: lC/AkMdBRMeMSSBfCOJTEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="159479178"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:29:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:29:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:29:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:29:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAEPlPtdm/xpwuuHrF9/WOan8YYfONcb/6V84q43IjuqwSgaFs/VBr2ZfJU29juSliB+gMEVfvGuvU4zzJZuYzH1M6pWZ8Flo/6g2pP0U8CpmJxJLfjKCY4mtEz0ZGHiTvlyTC02AAiiIuwaAl5WzIaBtQ5XSs+Xpxxa9hH5NczMnFWoHoYKKR478qFWGhZK4h+2IabFEOz9hIcb6AbVdS9MIwXnLgTgK5kbCkRK9uM7g6QBDm6hSylAKOMHXIAuRQvIHyD9rIIurq2NG3rBycpKhdigkL4lJKRN+nYxh0NoekCw37PB/U8rSkuwNzf4mTKHLKQu5S1ivE7Zy0lD6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6jpp/86xAsEH356dVogL/JfiW5/30rSbwl/Ts4Nhe4=;
 b=le/e6Kb0/nBjIDxkwoTsHKy6zvM+MxeFMk5iNERJGlWLuA7EV76SsT+AG8DGIgSyhAk7u4Dl2diYi60LGoLQ6EMIkhLvyyZyVxbn25x8Mt21SPTDPPUk8qgQrW07UBeFixQWxQYsHgNCTfcNNhE03JCjnKBAtyeV2dSJuFZUD+1eHj8++eWQuFakB1vwPq45VCnJNhrrWumtXZxUn7n8NLfgxoJsNRwnEr5nnQaYJqjiSQcRV2wr9xyQPdeygu66p9dq4OYKCcdGgI4RXh6jWbrYaYOl2G4ICT2+o1ZoXJqQiSZcoEFuehbos7Jx7vdfmV7z6IgYYX+mrAzzthRljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7518.namprd11.prod.outlook.com (2603:10b6:a03:4c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 8 May
 2025 03:28:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:28:58 +0000
Message-ID: <eb141d41-25e2-4e8a-bfdb-6d3e6a4e542b@intel.com>
Date: Wed, 7 May 2025 20:28:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/31] x86,fs/resctrl: Drop rdt_mon_features variable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250429003359.375508-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:254::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2a860a-66cc-4f1e-4a44-08dd8de077d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QWNqdHFFcVVVeGFhbW5CUnA2em5KRWx3cHpwYXBkNjVJUXNpMyt3MytnZDh0?=
 =?utf-8?B?aGI2c0NwNkl5Vko3TEZBd2lleFRrV2NWMjVJd21VbFB3c3YwWHZNWU1UNzdU?=
 =?utf-8?B?T0pLaEtRWHRDOGF6UDZDUVJaVkYvL2t6QUVnS1pmdERVWXFsemdMTWUrbUMy?=
 =?utf-8?B?NlJpdmpPM0VmcmhmVVhrWVkyN3BJZmMvUGIrZGhlbGJpZTVtMFo2a2h3ZFJ6?=
 =?utf-8?B?R3BWdm9LcHhHV1dDL05OYUg4cWcydmcwNXNsTXBRTzRGZEFVVGRwdVMxVnNK?=
 =?utf-8?B?WWJDYk10YTZ6SWo5eWx1dWZ6WGgxSENRajJYQVc4L0lGTnhHTElOWUdZWDl6?=
 =?utf-8?B?WENIS1JXNnAyT3RqZHlLRE1GREJoUzZTcXIySFZpMGM5Z2JOV0FMMTQrZGRz?=
 =?utf-8?B?TDF5TWxwaWtWcUkvYkdPdmx2ZFdyTUQvSXNGbVZ5dmc2MmdXRmdZcE9TaFpV?=
 =?utf-8?B?L2p3REZ1ZGVIcCtVNWNPc2pIZ0lnaVdlbERtU0tmSHdjL3hyYnM4eXgzMktS?=
 =?utf-8?B?NTk3T1ZCV0ljM1ZlUUNvMFp0aDl4bk9iSmRDcTYwS29kRFZ3a0JCKzd6cFZQ?=
 =?utf-8?B?MVB0azlCV2JQMHJiUm5lUzhGYi9lVDNDS1ZFYnQ2ZTZvVGhkNi9VRFN3eU4x?=
 =?utf-8?B?bWRuTFYxd2RkWUdtWENsL2xGQ2VPaSs2TkdUUmxOcWFuSFNXUERqdHpqdjlB?=
 =?utf-8?B?ZWFHR0RNdHZEWUhIU0V3THlnSkJHRGE5dmRNRXNVMEdWNGFkV2lqK2xabGg0?=
 =?utf-8?B?SVg5SkNqR1pQNlJOUnhrU0piZHFBUjRNV0N4NlZPMWpvZ1AzaTZuZEt0R1Zi?=
 =?utf-8?B?a080MEhlNE9kUTg0S3l6ajNNcnk1WWk4K0M2NHVpQVF0bWY5dldzVWVtNytQ?=
 =?utf-8?B?ZW5YdGRxeUs2Mkx6b3pvNUY2MDBBanllMjNUVDdyQU1GT1FKa2ZFZ2x5SFR2?=
 =?utf-8?B?QlNTUXFMLzByRHZvQ29EdVRPMCt1V1FFVlBpRUNxZ3BDdTZJQTJrL3Q1MzlQ?=
 =?utf-8?B?TUJ0ZWxDUVlUbGJmRThJRXNXQ2NreDF0NjQ3a1FydWozNUJuMFJOeExPUFBS?=
 =?utf-8?B?bmgxeUc2eWxSSnViYVRYbkpqTSsrRFV1blRCbU1BZnNFRFBHeGo1aEpLelJ5?=
 =?utf-8?B?VXA1Yzl3eG45V0kzQ3JXNnM4MHdlRlBJOHMvUW9TaFlaajZLWUcrdTcxM0F4?=
 =?utf-8?B?ZHBLbGlyL0ZUY3FwU3RlMVQwRVVNODIzeWdjWG1sUGlJR3VrR2tGUjlISUlY?=
 =?utf-8?B?dG9SRm52WVI3UGh1NVdZMDM3MzhRN1I2dXdqWXpnV05NcitUMFRaaXlPZUNW?=
 =?utf-8?B?VERjUWdOeUoyZS9tcHYvcnlFQUNsbHBBVlMzSExlUUpsa1pocUd4eVdOcEVn?=
 =?utf-8?B?WkhEc0d5Rzl3ZC9kUG1OelZWOFY3QlRadFVpVnFDS0ZHTzVhQ1J3NUhmUlZa?=
 =?utf-8?B?aHZLUUpOSWlvQjNFSFZGZEZFSHoyQm96VlpTY3N1WEMydklHellFcFFBeFMv?=
 =?utf-8?B?UEpiMUhmdUNjbE0rRzdaZmpxUGdCWmhDUzZmd2prUmlPN0t5NVVUSlVjNWwv?=
 =?utf-8?B?WDdYcmVJSjdmTEZYdUJQeWNVRlV6cUpBNU1CdFI5b2hIbXF5RnVKSHY1ajV3?=
 =?utf-8?B?R215NmZPYjA3QVlEWUlsVS9XbG1SaGFyUkQzYTRlL2lFQ2pnRTR2M1FML2RB?=
 =?utf-8?B?VlVqanRyeWNFT1ZWOEY3K25ERzR6NWpETTdaTVRiTTdRRFZrTDh1bCtEZEpM?=
 =?utf-8?B?cU5JbWV4bkNwb29xaXg5WThobm11dlo1TUY3N0tKNGZHVUdRNnFEcENYMDlM?=
 =?utf-8?B?TmpMTGowZkJiZ0hkV0hOS0VkTnI0TE9kWUZpUXNGZHBOakhWVHRsZldmTm9z?=
 =?utf-8?B?T3Z5QlkxaEw1VXA5cWVuV0lVU2dFdWxHeDRlc2RQckI4dGZCS0hEU1JGR1I0?=
 =?utf-8?B?bXQrMzdVZGI2ZXVlQkxIREt3WHYxWjJRbnNJS3Jjc0Z6dFRNa2szc3lMbGhD?=
 =?utf-8?B?Tnp3bDRPOExRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d01HTldOaHpuTmxJZFYrRVI5RTYvTHNOY0xjVElpbkszTFVVdVRCeHJ5MWor?=
 =?utf-8?B?aXFKWTJhMDlBU2dCWGRVNlp4SWt4OXl6R2l5T0U1a2tiazRJMFdkT2VHaFlu?=
 =?utf-8?B?bmtOZFNJVEFNa2VNdFF4ZWFSOXFiYXJCaGRPZkg4TXRkQmh2UmZLYzNqcFZT?=
 =?utf-8?B?SzlFS2ZaQ25nRldYTElpUXpuejZTSVQ0VWd3OVN3TXFBWDVreDY4dmdZcFpO?=
 =?utf-8?B?OXAwMUZlSjFHcjJhK0s0dmYrTmNpQkVkd1dKNFZoNkR0akN2Y2N5RzR4VllW?=
 =?utf-8?B?YzJSbzE0K1dzb1ZUT1BvTGh4Q0xMTDBVL1lSYTZDS1g3RkxhMXVFQmx4VVJi?=
 =?utf-8?B?c05GT1RQSGZkRGNWaUgwaTliYlZmakJGb3BzR215M2FDNll1R3lTdFVXVElz?=
 =?utf-8?B?ZU91NnhSWCtUbHAvbWdEN0kvd1NCK3hNVmNxZFJCQlU2WmM4UWM3dHpDMmJ6?=
 =?utf-8?B?ZXl3aTlmNHFkVTJ0UE9ocUFOL2NSNXhxWit4QnJ1REkycVRVNDRiY0htb2Jv?=
 =?utf-8?B?aDZOb1Ribi9NWFRacUdFYWRISUxhb2VIZ2tOUDdxdzV2Y1FMZDJaZEdRZ2Iz?=
 =?utf-8?B?Wm41bW9URXU3eEQ1TVUwZ25hSDR0d2NGNVJySlpmMDl4MUFyYWY1eEI1d1pK?=
 =?utf-8?B?cWMyZEMveFdaSlZNZUprV3l2c2lQM1NsMW1JazlXay94TlN2M1JLUnJzUmtM?=
 =?utf-8?B?UGQ1QkpIdzFKUkxORFNnT2g2OHJkM1ZYSDQxaU43bEM3TjJPamp1TUFPUWNa?=
 =?utf-8?B?bDY5NVRIYnhKODVQRUZaSkx5TDVIR210aFRhVmlkQldUSkVlL2VOeHFvSGZh?=
 =?utf-8?B?YkZidzlhbXRDcE5qNGdDTFhmSjNxcFQrU1pTUDN1U3llL1ZxVG15R1JNZ0lJ?=
 =?utf-8?B?ZXZSUDNIbVJxZEdacWVpUndlNUJOMVNxKzVsaFpRSjNRZUkxYk5QTTFZN2hU?=
 =?utf-8?B?cmNpdE5LKzdrak9GWFR3ZEVqYit5V0d4bElKR0E1MXVvd3ZEdFNYcENBWlhu?=
 =?utf-8?B?aWhJbEhDYUZLRkFxRm1IVVNOeHZSV3NVZzVaR1FwRktqZnNnS3AyOTVkOHVG?=
 =?utf-8?B?MDB2TkozSXJPd0V5eDBvNkt4ekZEKzVid04zMC9NTUY0YjkwU0xQK01DUEtI?=
 =?utf-8?B?QUZrK1JCQ2RMWEVCcm55ZFhoYkdjVkUzWVdMcmkvVE5WWEhuVkN4MGdVaTVk?=
 =?utf-8?B?SmZHOVFRbUxOY2wra2dPUTFFWFZCVlBqSThaa0Zwd3NRSElvS3NQc0lBS3Na?=
 =?utf-8?B?cG5IaStZRGQ3ZXR4Q2tlTWJjTFlaWmxUcXJhVUZrbFVieTlCa2k5Z1lxa3R3?=
 =?utf-8?B?aWVmYWZ4OGJOcDlCMEhpRlF0MENuMGIyb1FBbG9yc2pxaW51cW1FbEVlZWF2?=
 =?utf-8?B?ZjhiZjJ0eHVaV2dhS2NxNDNmU1dxWEFDb3BIS0VvQStUMUM0aCtHa0MzZjRO?=
 =?utf-8?B?VTVQU0VwNVVQbHAxUDN5MjVVd2Jid1o0YnBDbGx0RnJCWnhGdEYrQzgvL29k?=
 =?utf-8?B?QzdwM0VTMjBGVE00eGJWdXpmRTVKWTQraE9oTG4wL3E3eTRoWktoa1IzOE43?=
 =?utf-8?B?bCtlNUtqaS9qWHNRMGJvUFN4QkZhaUg0WW1TUS9PT2hXdm9pUFZveG1CL3BT?=
 =?utf-8?B?TGdvaDduTUtWYS9kSGJhdjlOMFd0VHZ0dHU1VG9Ea254Rm50a1RacnVDa3gz?=
 =?utf-8?B?bFRkN0htS0diOTBvc0lTYWlGRlN5dHBUU0FyQ2ZZY2c0NDRFN05qWXZ4ZkN1?=
 =?utf-8?B?TUxkYThzb0lKTmR5UGkxSkE0bEl4YW9wWmhTZVBIV3IyN1UxY3UzREdlSmE0?=
 =?utf-8?B?b3pWYW1lQlh4NFFXZTVycDA3emZEWUs3cng2TytFSGNtdGZxRm0xVWRxWkdV?=
 =?utf-8?B?ZlBuZ2Izb2dNb1lkVnBkWWhnb1Z4aGFUa1E5UWlEdDQyWndRWldIQVdYaEg1?=
 =?utf-8?B?cmR4a094VkgvQlVGd2ViR1ZkUm9yTTZSL3dZYlAzUGFVb1djVXFTalZUYUV1?=
 =?utf-8?B?RW1tOUovYS9iUlcvZUo1am1WOEpTVlRVSGlaV1FoWjEybFhNRVpUejNxRG1v?=
 =?utf-8?B?bWNLWk5qS0pYVzdGeEdOSlVGcmw5NXUvUzJHODh3dlJPTDVXV2xvZjhXTkFO?=
 =?utf-8?B?eEZJL2ZKVm9QM29jN1NPeWNqNnUwMlJPRy9tUFd6c1JJclVXcHdmYzd0azZr?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2a860a-66cc-4f1e-4a44-08dd8de077d1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:28:58.0496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCguM1L83U3A1gG0014wdMdM3G/fDaPHPDYgq7KBkO3yocKg2UBzrmFlP3SVoABqjtl9gYK0y/oEJ3VouQarQSVXMePxc9Sw7T/IK1/DAEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7518
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> The fs/arch boundary is a little muddy for adding new monitor features.

It is not possible to accurately interpret what is meant with "little muddy".
Please add specific information that can be verified/reasoned about.

> 
> Clean it up by making the mon_evt structure the source of all information
> about each event. In this case replace the bitmap of enabled monitor
> features with an "enabled" bit in the mon_evt structure.

bit -> boolean?

> 
> Change architecture code to inform file system code which events are
> available on a system with resctrl_enable_mon_event().

(nit: no need to mention that a patch changes code, it should be implied.)

This could be, "An architecture uses resctrl_enable_mon_event() to inform
resctrl fs which events are enabled on the system."

(I think we need to be cautious about the "available" vs "enabled"
distinction.)

> 
> Replace the event and architecture specific:
> 	resctrl_arch_is_llc_occupancy_enabled()
> 	resctrl_arch_is_mbm_total_enabled()
> 	resctrl_arch_is_mbm_local_enabled()
> functions with calls to resctrl_is_mon_event_enabled() with the
> appropriate QOS_L3_* enum resctrl_event_id.

No mention or motivation for the new array. I think the new array is an
improvement and now it begs the question whether rdt_resource::evt_list is
still needed? It seems to me that any usage of rdt_resource::evt_list can
use the new mon_event_all[] instead?
With struct mon_evt being independent like before this
patch it almost seems as though it prepared for multiple resources to
support the same event (do you know history here?). This appears to already
be thwarted by rdt_mon_features though ... although theoretically it could
have been "rdt_l3_mon_features".
Even so, with patch #4 adding the resource ID all event information is
centralized. Only potential issue may be if multiple resources use the
same event ... but since the existing event IDs already have resource
name embedded this does not seem to be of concern?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> @@ -866,14 +879,13 @@ static struct mon_evt mbm_local_event = {
>   */
>  static void l3_mon_evt_init(struct rdt_resource *r)
>  {
> +	enum resctrl_event_id evt;
> +
>  	INIT_LIST_HEAD(&r->evt_list);
>  
> -	if (resctrl_arch_is_llc_occupancy_enabled())
> -		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		list_add_tail(&mbm_total_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		list_add_tail(&mbm_local_event.list, &r->evt_list);
> +	for (evt = 0; evt < QOS_NUM_EVENTS; evt++)
> +		if (mon_event_all[evt].enabled)
> +			list_add_tail(&mon_event_all[evt].list, &r->evt_list);
>  }

This hunk can create confusion with it adding "all enabled events" to
a single resource. I understand that at this point only L3 supports monitoring
and this works ok, but in the context of this work it creates a caveat early
in series that needs to be fixed later (patch #4). This wrangling becomes
unnecessary if removing rdt_resource::evt_list.

Reinette
