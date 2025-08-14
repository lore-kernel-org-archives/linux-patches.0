Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4488B2114
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144729; cv=fail; b=ofMeKnvXInBG202BG1ZHlX5Pzk+LDcxMITM99gKQMHuBLoEA0+Fa82GATemJ8Td6Rs501wr7GtRBkg5ZNIaQTK0og6sCnys5n3PHLZLl0GUwS6ot+TnkZSScvxzBRrqyXCTbYEGbH4cinUUT1OWslyrcBFehv3KittFS6kdQ9co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144729; c=relaxed/simple;
	bh=YQd9AYiDVH5qjM34UUHwRTQ/HglRknHcoGr/R2GoSUw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z/dWOFtJ7UVKnJIPLPns/l/h3T2N5zcc7guqSV27XWKx5ARLks5Dl7Zs/Tl3fEwW52gmM9w36ysU63v3rsz4iaBaI6HS8S+j8AClaNM0rYz7WFPgXEynhulbdrklMmWzSE8lur0Sut7tiQmidte+xCcM4pljYQzFszzudJOthM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOL2o5TN; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOL2o5TN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144728; x=1786680728;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YQd9AYiDVH5qjM34UUHwRTQ/HglRknHcoGr/R2GoSUw=;
  b=gOL2o5TNbkoUWSDkq3BubtL/RGZpwQeMGodNJJEgGQ3395EQ890Ap2TD
   SU8rHo/FDkEBTT5dPOUKc5bg1b9RTTUe0g0zQO3zstI8/T+HaqmYep8f7
   m1pxnJMFyXQkaqaioipn2rwiFmCZ2qkxJkwaWH7ny/P58Lm2qxLXlUuzH
   5hEMCCeDR/qk95+8ewBewxt385rkX9fGNgkS9DKc+PbCCdzoOhogCAGYe
   xopXFf+TMD2y2sLx76NxafysJUlhXrpEO5eXAMkDRS9wUBShuB8sjJ9IB
   C90BKAAMXaVyxU6t1Fg/keEvnCpbTC8HuktQdThNTSV1uD8MdABzIxFp7
   Q==;
X-CSE-ConnectionGUID: lGBtU1k7Qxe6cg2rGSSmxA==
X-CSE-MsgGUID: kStuOQZkQ2eMIw7ODtQBBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80030078"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80030078"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:12:08 -0700
X-CSE-ConnectionGUID: o0p4bAmeQtqN7CSTjLlbgA==
X-CSE-MsgGUID: EMuukiuGSDmLEnfnOmhV2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166568777"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:12:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:12:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:12:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.64)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 21:12:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thk769TD4gJkwbBZMPc9Yd4NMvi6DXA0LefNlBaxWYO5hBd+Cgz32FJs+K5oyGcFliTwz2IxGmCY1Mky3Eo4aYMvCAhSrY3RqZIpMI0iCZV6RGToe93wLjC92vptOs9zoSC7KJyzOE4To5alcfzEUsWxQTdT+42ykIHiVh8eI2lCXfgrNM+Lm4V/IvHHNv1MZUZJ4PHbdsJDodoUeFglu16ScIjxjnmdu+1UUFrE0aYgt7Ea2tbLkM8kv1TnEjFHyNQXOzVbgzbbQ6IEYISGfB7bb83o0ZJyjT/X9QxnVEMrrTRdpHCMVANEYinswX7HNsB3LxY3mFGJVVc2Pv8J0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85UjyU/wDJBZqnUuLGSYHYprfDBvJcT7Q1izlfPPijU=;
 b=YrgpKGVOSz59H/U3VpHq/UyiU1AHgzdolw/zAIZyzeT1o/sl4pFaX61LPlW5Q2cguzfl6Y1VxwN6Ce5drPJFjGBegh6Pkx6KhYRg3pcFxMKDB1mBE5tyLNxXdfM5krgHwc+ed1ZfGX1Bi2bSWb3mJf0G1u35GMg7PBTxCW/ZKSBbbC5BDy2hmPTEeba8bCoW5t95+syjOPbl7dO2FmeIEn9RN70AqjL4zn/94Jo54HBmx+w+78B93w/FikZSkejax69T1DvjnrjG0lAZuEvdgavEDuj0rZol1+pFpWqMdFf2pqvCzk5kBSEC30MDy1mCLLFtKV4yGmPlmcHd4Mefeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 04:12:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 04:12:04 +0000
Message-ID: <28b4983f-76ce-4fb4-8943-ef98d2c2fb52@intel.com>
Date: Wed, 13 Aug 2025 21:12:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:303:b4::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: dfb8113d-5efc-4893-b693-08dddae8ba31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OWhrbzZPaC9uMm1pZzJ1L204cWhNL1hQNDh2dUJZMXV3VDFCL1Z2eXh5bG5D?=
 =?utf-8?B?WWMyY3MyUFZTdUc2azNaS3NqRFIwaDNqK1RtV05uOHhNa3VGVzZINUZZeU8w?=
 =?utf-8?B?cGpZbjkyK3BRNkgxU0JZTTBQK0FvM0dBZ2pueTFQR1JwZ2o0dERqbjdzNyth?=
 =?utf-8?B?cm13dHl0a1ZkbE12TTVWRVRXam9wT1hHQXFFRDMxVnI2WjFXVWVtTEVLdGp2?=
 =?utf-8?B?eUtGeit1Wmo1Zit3Vy92SURlRms0bFRPZTMxRFFsZ3hWSjN5bHpEUmhWcWxE?=
 =?utf-8?B?Y2FYdGg2QklBdzJ6K0VKL2hpZDVyeHl2TUlkUHkvc2E3MlRaUit6aEZsK1dl?=
 =?utf-8?B?MXllZGFhc1dkK1c4Y1cyeWR5aStEdk5FbUpQRjkyLzJaWFhhWDQrNkJNWFMr?=
 =?utf-8?B?OXFZNHlJVU9adlV6bG5ZUE5WYjVsUnBrcE9rbDdLR2xBUmorWFlQYkZTWDRB?=
 =?utf-8?B?UTJlTjV2NXJnOFVVelN3b3JvcmxYWldLTFFOcEdXdUVqcDI3RFovRXRKVmhW?=
 =?utf-8?B?NXhodkdjYjFEa2didG9JZ1p6cm5EYWZyVzZwRnp2bjY5SGNWakdUSjN5V0FW?=
 =?utf-8?B?ZWwyb3kwTXBuOUNYRzBYaDVFU2JXRC94M0NtL3ZFZGNPNGxBeHNUK2crSTEz?=
 =?utf-8?B?TEg2ZEdLQnlYZllxcjVYUDZuNnUrV3F2RXNTb1NXejg5bmk5MzduQ2hGQlJE?=
 =?utf-8?B?TTdXSU9RRzdIMy9nR0MvdWk4Zi9jbDErMDdKVjZ1NUV2Ti9GeWpycDYveHRP?=
 =?utf-8?B?WVFxU0JIY1Y3MWhSMUs3VFRJcnQ2MWVZZjVrcFAzcHcwR1hURUo4OWgreTQ5?=
 =?utf-8?B?UyswaDJEUUVUYy9KWGZtaCtCM1haZ2R0Qk5GZjdvS2hPUVE5anN4eVpGSTdm?=
 =?utf-8?B?V2ZEMm9SSlJSeGRVQ1AyRnlDZDVMNWJORUV0REJySW1GUTNmdEVCSGgyVVlE?=
 =?utf-8?B?R0g3WU11VkNRUThscXc5ZU8wN0RBbUdpamk5d25hWGxsT2N5QnlRS2E5cmp1?=
 =?utf-8?B?bFhnOERsMEp5Q2pLUDRGbWh2Mi83U0hJRHhWdHlpVnIvRndFRjFVNEdmU2t2?=
 =?utf-8?B?ejJBL2pkd0pJcE9BT0lxQ0FCK2J0ZFRLd1RmUDBVRTBmeUozYlBUMjNGa01U?=
 =?utf-8?B?Q3pIcVgwMUNwdW5SMEdYd0xra1JDWmQ2SSttVE01M3c3WDQ1MDhacy9QNzlQ?=
 =?utf-8?B?clJ0aXNDSVlySCtweFYvaHQxQjBOcC9WZ1FKT3pDZG0rdzdUZWVWNXNjY25V?=
 =?utf-8?B?Rmt0dUw2MEoyZUNBSzhSTFUydWptb21rUzZWV2dyd0xPaFl1QlZKd0V3d1VJ?=
 =?utf-8?B?dU5EY2h2Tm43MXRIS1d2YTZFTDlUSGNOL1lVYm1KTFA2RWJpT0IxeGk1YXRr?=
 =?utf-8?B?L1VxeDBzMXJ5Q0hsOURLaXNMa3ZoNW56ZjVlRzQ5VFlSaWNodVdyaDUyaUtj?=
 =?utf-8?B?T29CWnkzTW1aNG4xbmNhQnlZL3dnMk9NeDBTZnloa0doWUxnNmlxSFpVV1B6?=
 =?utf-8?B?czVsVyt3bmVScS9MNVZNVXFjVzRNRDhnb3VsTy9nSHNLcGVXY2oxNW51SXJC?=
 =?utf-8?B?V2ZldjRIT2RuUXFFanlTTjQrUDZ3NHZSNUIzMkhaUGVuNVZ4ZzBzZjY1ckRP?=
 =?utf-8?B?dmRiUEk2SHJDWFgzeHN3Sk1UaFpUTU9Gbm5ocGI5N1MxK3pRT0syYWttSmhS?=
 =?utf-8?B?dTVHVnd5cEZ6ZmNSaEJOdENZc1ZNZkMrSzg3QUMxUXRKUDF1cngzRTdobk5s?=
 =?utf-8?B?YWMzUjVIWVEyQVY1R2s3b2xWcEN2RFRmVzRpWUdOVlJBL3JsWVRja0V2UGRP?=
 =?utf-8?B?QXV2b3FTK2Y3R3dteWltNGdjdUh6NG56YlhqRkFIdzdQRHYza2xtT2tCRXRj?=
 =?utf-8?B?QXJBTHFhT1dkamJmZTBsa1RjdSt1M1kxUXV6Rm40SE5jK2c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG5GU2xGeHpzNFNQZWpWeW5EcGpLbFJvZVM2ZnBJalRwUzErZU1BelZCZmtx?=
 =?utf-8?B?SkIxWm5wd0ZObVlsWjFWZzZPc2tJcDVTVjFON3NwazJoUkdZbHRIT28vYlhp?=
 =?utf-8?B?RVNwOERYd3Y2SHdQT1ljdHFFdGhYRGRPMnJsU0NLRnVaSm1rZ2xQV3JxeTJT?=
 =?utf-8?B?bTJodXFBN2ZQMnNOOUxLWVBnMkR2WU1iNUtiQXVEVXRlL3RnT3hxNWJVOWxy?=
 =?utf-8?B?emVFLzM4WG1UWm5Ja0lpa1RtcWwyOWoyRlduYWEwRWY1aDY2ZS8vSVpiSHRu?=
 =?utf-8?B?anZpUUlTVWI5bCtDNk14bDIvNm5GQzhEQkc1WVJmL3A2MnlaTm5iQUZNbi9W?=
 =?utf-8?B?MXhJUW42OEVKMzhyMStVcVJqWG04c3pjN3dvY2RrR2FPUzVxVk5vaVQzUkFh?=
 =?utf-8?B?VDl5ejVDN2w4ZFpMaitMQy8rOTdKZXIwK0taZlcvenFoVUJTNVdVc29hQTB6?=
 =?utf-8?B?VUVTWXlsYlNVWXVFdFVBSHpkK3M3TFBqREZNb1J4YVlkL3gvd0pNWU0wbU4w?=
 =?utf-8?B?WFhHQmVqVm1lUVJSTGdqN2ttOS9SdWtHK3dpRnVVZUVmalZuMjNQd3N3TnlT?=
 =?utf-8?B?Q1dUMVZrVTA2UmovL2JsdjNCbXppdDZDU2dvZitJenNSMTVOa2xHNnl6cVNV?=
 =?utf-8?B?MFpxZHF3UG1rUlNuNmE0c2FsZUtNNk12V2ZXckhuVXlOS2UyeFAyMFJaTDJl?=
 =?utf-8?B?bUxCVVRjSk5Ta2o1eGZ3Y0FCRWtRL1FSZlFtNCszUWlZT3N3eWcwV0lOdFVx?=
 =?utf-8?B?TDl4T0tPYWtoeEVDZlhOT09SQkZ5VDJmRDg1eDBnSU1zenI3YUNFYWdKRGFB?=
 =?utf-8?B?REIzSmNRbVZiRFByOU53SlcxOEF0NmkwZUpmSndzbjhPQi9uVGVSYUI3Y0RR?=
 =?utf-8?B?dFlxYXBaUDdtTFBNMENWVEl0VGxDM1ZaN2RoMWJwT2Y4OWNaclNCb0w1Q0lv?=
 =?utf-8?B?WWxHRURtemNNL2x2STBMQXJqTFZuMXJQOVhXTmZQbXZTbWJsSzViOFBhUlQ2?=
 =?utf-8?B?UWhaVTk2WXVhK1g3cjlpWm4rdjRiNm1iMlhjUGVmdis4V2dWQXk4RG50eEhH?=
 =?utf-8?B?MGxuQzhKOGR0Qjl0dlV4L1d1d1dWOFBsY1lmWU4vMCt1WUMwcFNMWkhseGJk?=
 =?utf-8?B?NmxTSUhQY3VBZCtxbFZ3YmdWaUVyekJVNHl5V01SUWJKMjFzVnFQRDBKTVI5?=
 =?utf-8?B?YUEzYUI4elhPemFKem9HUkk0dzJlV0xLN1FjSlJMQ1ZNQXRXSzVhSTh0S3pN?=
 =?utf-8?B?WmNqZmtYME1wV0dFVFBGM09lRXR3VDA0dFJXTk0wSkVzSGRZaFFHcUlOemRF?=
 =?utf-8?B?UVpTWTBUeHp2UVFid3VEMlMweFJENytCQ2pqVElxUk1HbDZlWWxLVUNQYUg2?=
 =?utf-8?B?bmRIRUdOSDd3OTdkejAyaXl6VnlZVFA0YWJWNVJPdytDdVVLRTlwSWc5L29k?=
 =?utf-8?B?a3RtZitjMkFyQkVPZE1hU2QzUm1hK2VsMHhGZmQzK3EzdDJoVlhvY2tlNW4z?=
 =?utf-8?B?eXZnRVErSVdGaXk1NitraUR6SG5GSHNiNWY5SFZkZ3JxZkJ2Q2NBaUdVcENv?=
 =?utf-8?B?TTAveDBIUWYxS2Rla1VWcjhxS0ZQUFRlWHNmbmhRSzB4R2dYUDR6KytvQmdp?=
 =?utf-8?B?OG02cDZRVzlzZVhaLy9Ec1hUZk51TkVkSDljZWg5OUJHSjhtQldLVDFwbkRi?=
 =?utf-8?B?a0diSnR1SzhUZTFYeEJpS0ZFcUdTVE5XbjY4Y2JVcENlNnJ2YndFQmNjUy9l?=
 =?utf-8?B?Tjl5ZVhseWs2aTFPSkQ0U012a0o3LzRWQzRYSjl1OFBVcFg1MmNHN1ZRWEtj?=
 =?utf-8?B?U1J4ZzdhZlZPLzUvMi9tS2d1VW1uMXhTNFAyaWh4UllxMHdaVjNpbE45SkFK?=
 =?utf-8?B?VWVITlpXdDMwSjIvWlZRMjBLaDhYdGpzMi9GY09iNm1IRjdUa284cStVeUFN?=
 =?utf-8?B?Tk56ZkhnaTB0UVhKTXdnbzAxSi91YkdXTFpPa2hJMUJ4ZSs1V2F3Nzh3RmNt?=
 =?utf-8?B?U2t3cy9RekViZXVaYjU2Q2pvaVdGc1N6RERyYy9MWWpwNTE4UE5jN3kwenFx?=
 =?utf-8?B?NzlBZTZHZmh1ajhtM2lyMGRYVlBtNXBrTzQ5aEVNSmJXckZTcmt4dGJhRWw2?=
 =?utf-8?B?eVErSVdnNmd2SkxnWHZmVnVSTC9KWVN4cFQ3YUVSQkN2ZmQrNkxmWktUeGhm?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb8113d-5efc-4893-b693-08dddae8ba31
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:12:04.8752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+KEpRN2R5UgGn9VZ6K8UL3HXkXsISBBKqnSX/K0Omko7lgJP7iDF5coZ/ziW01YExYdiHXFRJwH5InoSGDkkujk7uH8iDEU5EXGouxYKdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index c3f697da612b..d6585f7d1c9e 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -356,15 +356,47 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
>  	return state ? &state[idx] : NULL;
>  }
>  
> +/*
> + * Called from preemptible context via a direct call of mon_event_count() for
> + * events that can be read on any CPU.
> + * Called from preemptible but non-migratable process context (mon_event_count()
> + * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
> + * smp_call_function_any()) for events that need to be read on a specific CPU.
> + */
> +static bool cpu_on_correct_domain(struct rmid_read *rr)

Function returns bool ...

> +{
> +	struct cacheinfo *ci;
> +	int cpu;
> +
> +	/* Any CPU is OK for this event */
> +	if (rr->evt->any_cpu)
> +		return true;
> +
> +	cpu = smp_processor_id();
> +
> +	/* Single domain. Must be on a CPU in that domain. */
> +	if (rr->hdr)
> +		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
> +
> +	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
> +		return -EINVAL;

return false?

> +
> +	/* Summing domains that share a cache, must be on a CPU for that cache. */
> +	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> +
> +	return ci && ci->id == rr->ci_id;
> +}
> +
Reinette

