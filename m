Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00CB7C09E
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918589; cv=fail; b=DZtugniD75AvBwzy49yxpsU880spBvLkLuyPnqOAl/XWo/bRNvtkEsa0T/gtUqZiH1H0jQsC3KPEENYjPTqcMDvIJySV43eULWO9SiGDMCcR3FBAFcrHh9KIZ0tyvizjYgRbuCSthPuDr+Oz11/KQrVznzcWBI6fsDPfpPpgk00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918589; c=relaxed/simple;
	bh=9kErUjBnj4s71TpjeoozzWMgI+2SG1y5oti9ORGN4OQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LiBu5YEvz6YeIR/dUPJndCL32S8ZMTIo14hxETTJy2De1RmoNIbhuqZfqI2ZCR6/r21JMUwLLwQj3ZDNRgvuojyNlD37Az3fLO6jATlJKfeErE0Qt/ASGkJkfqEGA2/1pY3TYkxZTRdz5UqboEBLa974RmNKZvcuy2SxFrvoPL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wh7W4qwa; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wh7W4qwa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918588; x=1750454588;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9kErUjBnj4s71TpjeoozzWMgI+2SG1y5oti9ORGN4OQ=;
  b=Wh7W4qwaBMoV3FxZJ8Cz7q6MQS7/xiBy/kdZ5vnb4vvyaztu9z10BrIH
   ne+VFD4cYbhW3Pl0m1f/ZEmNk0AXJMDccxJmdyPo8j4MI+moKEpIJAQqs
   PEaslLqlvpAtw22I2cWV46SuhPVdI8vq+4I2JQsxt7kvJbDOmeu4GYux/
   DS55vA/Sqa16pJRs99jlMRLMQtg4inS8xE5kVpmoJba9syRE21Gf5SRUl
   +0IYQZX2okWzfkoqSoUkkOuptrlMhCz9eXHPq0HxIXN+M0h28dzIIUQBg
   7vl2tVSYO0DsEBQXZ8yjqjgplFtRdozD3LO4WcBviNLTsw2ySYy3NMD7n
   A==;
X-CSE-ConnectionGUID: BS3Rg/ryRz6x/r0zeNt/Yg==
X-CSE-MsgGUID: kgMqu5k7SV++425HXdXq8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16044477"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16044477"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:23:08 -0700
X-CSE-ConnectionGUID: bOw0APziQ92tioFMWLXWvw==
X-CSE-MsgGUID: 0KJjBue3QE+c7YthpcERZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="43058790"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:23:08 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:23:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:23:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:23:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:23:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgLskMGlZMJk+jSebAd10eiGWxIr5v6v5GFwmsInKDUITbFVcGqnwI0BZGVgOTSMS2eEnBebhr6SC3cKrBCxSFn0boAV5P3uWvsfof29aU1COQUZRZl5jMwecBjYYLKJfxjvTwmk0Xz3dnHKeute90q54kcCPLHlOne4LcafZRNqtMdekde5j7kUIdsuRdl3jEFYxSK/L+lkp3uizblYU15js+fXqt0Z1Em0zLdhkjLMYQwxtw6uI8CK75mY0/R7O4YvmWJhLLi1Sw8DZO/XNZjLO7XBvXNqmEBxYspA5Jpx3+dRp60TXLHPY0vQDuXXMpYiJCIi9yjjAfoXaemP5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXyioNdxjOAu5ld7bxbfWydXLlwf3KtPYactLjFzZPQ=;
 b=CQbt/CVMjm9lFKJTOJ+ZPEXmYbzOZIP4DKzc/EuR/FIX8vQuHMg++fWBseM/czuZNS7MDd4QWbiANZ7h+ijQ7vavY5wKObzZcAVo/7RkmO2xIJEhZfHuL6rjM7kpjp+xZDyBp0AgwwVryyKCvAyap4Xu3x2JH5i79J0DOs0eU+s7qGOUpEPupo6xtJv6j55M0aKhTYBqC6ulPMQw86VSv8uv9A4f+sCn4fjDdm82CWubbrnUYnzyTM+LvCdCC+GgF+kvE24DfPT5p9Xf3awf03lPm7XrLT1y6LrU/Uyr2nHZ2HnAJB3yGp8fthhU4izMyamKsAwGys9xdj829+juYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB7254.namprd11.prod.outlook.com (2603:10b6:8:10e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 21:23:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:23:05 +0000
Message-ID: <ce952bb2-adde-4b96-9686-7b0609fe58f7@intel.com>
Date: Thu, 20 Jun 2024 14:23:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 10/18] x86/resctrl: Refactor mkdir_mondata_subdir()
 with a helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0303.namprd03.prod.outlook.com
 (2603:10b6:303:dd::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: 8157f4be-fc7e-4fd2-989c-08dc916f2c03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OTlreXFuMlpLOE9sOThiSCtHdWJkNm9NTDFwbnR4VGY4ckk3MUlLTmdjYXBt?=
 =?utf-8?B?ZVNQN281eUlzZ21ZcUdiK1VrUlpvSkR2VmYxSU1PUFQyajBQY0xyb0ZGajd2?=
 =?utf-8?B?eTFIQmt3RWRPVythb2ViOVRlV1VFcU1qYlB5VEFJb0c4ZUxBZGxVdnN4TFFY?=
 =?utf-8?B?MFZRZlBETStEL1dVakJoRzBmWE5uVlY0aVlURlk5djIvazY0dGxzM0pCQlNq?=
 =?utf-8?B?M1puREJJRVhDS1cyTGs2b2N4OXBTRHN0b3RDYnFSQ1VPVk5BSGZlSmtuMTg0?=
 =?utf-8?B?QjZ6K2xmNTdXWUxCUTNwb3B0UTNDZGk1Nis1QXpQR0taSlNNcXdKWXdxWFdC?=
 =?utf-8?B?ckpoTHNVK0hPMW9ESzMydlROVGN1M1VmSHE4cmNnU1VDa3NHU3FORzdoNHlT?=
 =?utf-8?B?dUMySzZFa0Z6RXZyZHhqemRaWDkyWmVOUm1GK2ZjY2k2MzloY3Biem0vOFFz?=
 =?utf-8?B?cUx3V3NYTGNBTlVjTHg5WHdpRkg5MFhWN2I4RCtWVlc3UWNydHljbFhRa01M?=
 =?utf-8?B?elFiaFYrMGcxL2tpS3JIL3Qyb0lpdEttbkJYdTB6REQ3N2ljMW4wRUxUVS8y?=
 =?utf-8?B?UEN0SFlXb1JONVRjVDIxQWNqclkrdDVwK2I3RVJZU2h5Y0phWEtwd3liZHJX?=
 =?utf-8?B?ZUxqTDVMN0xaVk11NTE1RzAwOUJ4Sko5a1laOTlGOHlRZyt4WUJaWG9hVUdQ?=
 =?utf-8?B?bEpteEszZjRnNDdXajhGdk4rVkxGZXRBNzhhNGU2NyswQ00yMXdYUDh6YWcr?=
 =?utf-8?B?UmdsRDlKV0xLK2gyME5sQkd5STdHN3ArdkRyVnVsb21LbVJreDVoL0lPaUpD?=
 =?utf-8?B?dk9lNENJeXBRVDFjK2FtcTVIWGpKTzJ4OG9jZG8rZk9Pek9GU1puRWQ1eXlk?=
 =?utf-8?B?R1poZ1pyelFUbDl6citwZnpRK05abk84NVlBWkM3RWF3Sy9XTWZUSlZmcTFp?=
 =?utf-8?B?cng2aHlKcHRXME5DVEw0a0txc2lJRnRUTEJVNEVXU3NiNFBCNit2YlJ1VGg3?=
 =?utf-8?B?Q1c5YkVnQm10bkNSM1B6dUY2MmVEOS93UzJwWXFLNVdUNXBieVZnMEx1L3Za?=
 =?utf-8?B?MlRONEdseUhlV2NWbW5zVWxoeVBqU09hbFZTemU3c3NXR0tRbG5pSFFaMmpM?=
 =?utf-8?B?MWpzRmFqc09jai9haVBxcnRUR3EwRStqODJjTVJLa0JXQ2VBVDZSem1CdDdD?=
 =?utf-8?B?eVpNYnV2OTZrWDRqUHRmSTBhdlczMHhhckF3eVlDZDU2aElqLzhVN2FIOHBO?=
 =?utf-8?B?UTB6b3dVR21xbkE2d2s5dVMrNnlPLzNneVgrOUY5amdCSWFFWnZMbXBnbVU5?=
 =?utf-8?B?emtuTU9zRHh1WU92MUQ2WHYzR3Qydk83ZXZDcGY4VXlUT0w1dkQvMEx1NTA5?=
 =?utf-8?B?YVV1Q1hEYklaVndQMmJiRGhiM0JRbEZLWkRFcDdyL2E1Z2NUUmxkdklRb0dZ?=
 =?utf-8?B?UGhSWG9UUHJuZTFJRHc0M2U1SDZEYlAxNkF4RW96dTk0Y1JQejRBOFVBYkpY?=
 =?utf-8?B?NHdsdEMrcDNmVnpjZzN2d0djQkl1N3RIdWh1dGkxVFgvV25qQ2o3TVl3d3dZ?=
 =?utf-8?B?VGRBWmdCbmpPby9ERmdPNUo4N0RFZkxKY0hjNitaVmlFYWZoSklVMlRYNFcy?=
 =?utf-8?B?Zk5ZYWl3bE1aVzMvc2V5NzZYdzdhRFVxRHBFTnNSQ21YN1ZKQWxVbEN0M1F2?=
 =?utf-8?B?dm1iUVJLaXVxOUZPMzYxQk9yNkVraDdrRFI2eXFqV0xqcTN3TldXRUppOTVF?=
 =?utf-8?Q?SfW66KMpVah1zBM+9/hCmy28T4LNsdLpnt3ZRkw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2dlVFJPL2RJd3pTbzA2MHNEYUk2T2ZvTXBkQ2R3OE9aVTBhZnJYMlRiWU9i?=
 =?utf-8?B?eE9GT1RPY2YrU29XQWVnNWtjZTBRdUFiYWFOQmx3dUtKRFl0Y0xYVWJJeUNX?=
 =?utf-8?B?YXhUYzEwUC9TTUErYlVzR21PR3ZNRWlYcm1iLzhSSUo0Y1NpaXQ1U3NJWWNL?=
 =?utf-8?B?elRVRGJ6VzJkRUx6VUlBRzhmSk0xNVJMUVdQQnd3UFlVWkZVNEJrS2hNbTNy?=
 =?utf-8?B?ZUx4a3hCRlpXcTRtcW5vbGp4SHA4YjNCd2xqVXlHd29hdWxzSkh4UjBGV2Yx?=
 =?utf-8?B?d1d2dDAvZVVUWFU0ajV0anF5WCswOHhoaEthTE92azQzZTA1ZkRrZnBBNEg5?=
 =?utf-8?B?Z1p2S1FDekFRQnh6VkJKbjg0YkZaMXB2OUo2bXJjYm03M1ZhTXl4YzRrZlNo?=
 =?utf-8?B?Z2FNRmNMUkUvQk5ERVRQeHFSaTY2ZWtORlJZY2J5UU1XVkhLblhDN1E2MzI3?=
 =?utf-8?B?VjhIc2c0Q004MDM4WWFZRUhLcWhSbjZQRVZnMUpIVUVpZnVOWmxSUnJtMjM5?=
 =?utf-8?B?REREdmFkNlFQYkNqMmE0QmhkUWYzUFJNYXU2L2xONW1YU1Y0ekNpNDRSMHJB?=
 =?utf-8?B?bTR3RGE1aW9DZE1BQVZRTXpSS3Z3NlFRcUZrY1R5MUJYNXVtU1lJUmlCaWYz?=
 =?utf-8?B?KzNnUlZ6TFFkSHo1dm1NeS9zSXZjVWQvSmVuc3B0RkJlZDJuWndoZmNZZnFF?=
 =?utf-8?B?ZXFhVHpjbzNWUTRXMUFNMEo0VGtkQ2pOY25GMG1OQXVqT3djeHJrZ2s1K2tB?=
 =?utf-8?B?bGlzeS9SeUgybEIyTWZ4RWN5alFyYmlRemVMb1d5TUZmZlBDZklieEhtQ09D?=
 =?utf-8?B?Qjhyd0lOVG51alZaeEdVUEJZeTZlM2p3cW5rM0RwQ3hHbXF6UDREZnluVERE?=
 =?utf-8?B?SGxLeVEvd3V1RFdxM3ZyTlpvYmxYcDNHYlg3WGNJaGtQOUZGM1M2dElSKzA0?=
 =?utf-8?B?UW1icEVRbmkwTG9HSHgyMkgwUnl0NG9Wemx5ZXFMTC9yUGZxWFpxekR1SjJR?=
 =?utf-8?B?ZlNBZ25TOEhMU1d0VW05UlJHY1h4TUF0Nmxic3NYTXdUYVdTSWNML0dBMkor?=
 =?utf-8?B?ZWxBbTRUOXhaT055L2pINXFHd3RLaTdNdENiSThGOFFWMVJ6Zkl2ZCtIN01P?=
 =?utf-8?B?MXRrb0JPMUdPank3bFNlMGV2U1l2aHlTL3VWOHNZR2QwZWx2ZWtzd293UVdZ?=
 =?utf-8?B?WnN0KzdUOEgrVWVjS3RsTzV4TU96WWxTVTFUenJEZUZhbjBpY3V3TFkzRlVy?=
 =?utf-8?B?VmplV1VkTWhzZGVDeWM5bDdybTBKVWlzcUhTOHBHVW1DWG5zajdrSTUyZ016?=
 =?utf-8?B?SXorbWpxWmlLK3NKNUo4QSsrcENuRXdodVN1R2x1d055NTZHZndGbHRSVmNZ?=
 =?utf-8?B?MVJUK2R3enI5M3VUUzUrOUE1Zk5rV29iWTlBV0JvUVZTTGJ2N0JCRG9DTU9E?=
 =?utf-8?B?V0xwT0x3N3RCeThWbVZhZllmTnRUN1lTaDF4cE8ySnlwSmZVdjdvRzQrWHFB?=
 =?utf-8?B?Z3ZFZXBHY0s1aEtUVHlpOFVxWThtS1ZBUmFjbnRnT3JPeTNvd21GTjdTWUM0?=
 =?utf-8?B?Q2drN1Rtd1ltMjY4am91TFRXc1d6akdqYkcxdHJOczFMNlRwUlQrUnBPQXFx?=
 =?utf-8?B?elNjaldFT0loUjZqNExOSkFGcy8yZG82cGhWVUFlcjZJcjhPN0xQTUtoek9n?=
 =?utf-8?B?S05zR2d3Y2EzTG9SQUNGbGJlTFNjYmFkdnRSVVdxdjRWeHZxSHpQLy9sVDhT?=
 =?utf-8?B?U3B4bDVZOFZvdmdRUmd4NEwxMlNlVWNUdkdBWGt4WldST1JlYlBpekFwQVZx?=
 =?utf-8?B?UUgwenZCeDZlbFFVRnRsN0J0S2xNcmErT1NPTjR1TGxIdXlkV1Nycm5FYldh?=
 =?utf-8?B?NTNtanpsVFVVcmhEczVpWGFBLzgyVVNOUnZ0b3ZJd2FKbHptODdqTmJXS2pE?=
 =?utf-8?B?SGZGOUkvNENBbEh6N1htMzQ4cjlnTXBwVnJoWmU1cktMU3V3UzA5VTU1dEsz?=
 =?utf-8?B?K2VGREVaMUU0Z1BPQW9GYy9tWUg4WWRxcUlxODJFb3c5T3JpTmRxelFqMEVh?=
 =?utf-8?B?dklMeVVHaVVIMnhoS1NEaDJWNmRzVWVhbXhFcW81bVlDa2lFUWVRUm1PSGgv?=
 =?utf-8?B?STZUNTRzOXR4Ykc4TWNaWFhrOWpuUVZaN2g1UmgwWm96UmpWdFBqQnRSRzlE?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8157f4be-fc7e-4fd2-989c-08dc916f2c03
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:23:04.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrJvn8waOytbtTthwzxWb1ZfIWclxP8AzrMPoOwF4KOb7zncMogmvLtcy0m+ZbRG5lu7+VrMp/6kBWHNhu5KWY8Sq0nj+YEYAJ1Hmx8VlX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7254
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> In Sub-NUMA Cluster (SNC) mode Linux must create the monitor
> files in the original "mon_L3_XX" directories and also in each
> of the "mon_sub_L3_YY" directories.
> 
> Refactor mkdir_mondata_subdir() to move the creation of monitoring files
> into a helper function to avoid the need to duplicate code later.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
