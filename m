Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DD53307B
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918532; cv=fail; b=lWu/v4UkoACgU91odbljNsxc/XbPBf9EwfQKPYL2G27RabxYUkH/9giYWPiXq503jNz5wGJsOrZyyYWjCzhtrAOlY1q1L6JONx1rmNqes2jJl0EzRcfu9EG4552TjFw7qeNy1+Kra/wnMFiU7OdgmTHQMjYhNKrcERlMcguHams=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918532; c=relaxed/simple;
	bh=0wtOcTNMaCaxSvr/FMn39/aNgNBQjwRp/LT7ezUBIDg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NVIs8S78bhuj/DW6546g05NiE22d0cRMBoo5XMy3A0AE6eyFshsc6M9df0h9g5gOGyT2ea2sPh6U0pF3CL+TvG/9K1aPLidcvVbn4pD5HQ67q3wecDX+x0n57mHtFPKmM4RDU5Ofk1uQ/p+eU7QPHY+FYJKMQq2EX6eZQVVJonE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HF3mkHVM; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HF3mkHVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918531; x=1750454531;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0wtOcTNMaCaxSvr/FMn39/aNgNBQjwRp/LT7ezUBIDg=;
  b=HF3mkHVMsmB6q0J3P+G/UlbQ5Co8B5BUNuMOKgMD7Z9H7JbphXhvVE6k
   LY38SM2ZqpVJsyPTj5X9PCJ0dV1+qRnmOswuXZojuspUB4AZ2jb0FVOi9
   Yn/tKWTSnjtswCat43iCKiG8T2Zl9YdE8zcLxHLdjA1sGcPtF/ixtrApq
   e+7350z1SILrFiu54cAgHBfVQD9/kxYV8QPaivvjEIxk4Dh/Nu4Y1uHNT
   kM9JhZyA/2sha8+I0o2uFsYlKMRMpL/dMDXLZWJhz8L9HnZ5fVRu0ygm8
   Hxyzwrh0gs5zCluEzxn8eDoOuivd9g8MLQA12BHMqsn+rHA35jANozZq2
   g==;
X-CSE-ConnectionGUID: /xnrleEEQqali2/G8sUfCg==
X-CSE-MsgGUID: jzzlpIOdQl6dA77i5EzZ+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="33474707"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="33474707"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:22:11 -0700
X-CSE-ConnectionGUID: uO0vc6VoStG+tBkg5Fc0iQ==
X-CSE-MsgGUID: FSsspg8oTAyPfi0wlBoy6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46721014"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:22:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:22:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:22:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJSRj+gcWeM7PZnc80XcVLe+OmgzhmsERYZdFe5TykmP1n/WPmfgWjZAKaig5Bn2Qw3S31QmNm7oxUazEqd6hp+AVGz8k1G4qbznola08lxfmjvqIHIG0tlzJ8IizUN+zrys4DL0nBPD2k8TjMVKVysfLYebO6VeFAKYOKQ6Ot8qMcKDSctzK2oTeVwZ5o+tsmOy5fjTUUID9yiOoEuISDV5Ikr8u+/ZP9hbfmrYVYz09NjkMWY3lZ5ZrqTR5eGiNLxa1XOxtlSX4p27UWNh7muRZzRAcVZndqu5PluxtyVG6qAj4X9HniyB3xPt2iheJPftD+hT8dwHRl2iMxMWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QdRQqd/iw5oBrKSQeq5W6Y5/y/QvPSucDs21Q/fXn4=;
 b=Q5DQOTdp0vy9Wq5ZF//bLLkqkORiHOBpOmRpZnkh5iwBW4cYIkUPe/VV+KSC+QlbaAxDYzdCX5nwOFLCvoalcAPJ25FP4rTMNfzzKcSJa3kg4Vhxg4UPJ5V/sTs5a32yiVqvnEIxuUt4FZFJiVuTIBkqP/Ba2HLwErOojNEBAS7JupconMKpokbQr5nk6F+cNpqXJjiAxccRbKETLFxu2G9tDOZAnHfJHl3qIC0NzTQAnAgtXReCc1AqWgdZonvMs39/q8V8mJw2kjXORE0riF8HEReKUorsOI+ijv92m7r0yBBbegLIVyl4SBFUN+zSBWzAkw6Dwh63vkeMu+6bxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:22:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:22:02 +0000
Message-ID: <cf52d740-8617-46f7-98f4-b4a8ec1d3d2d@intel.com>
Date: Thu, 20 Jun 2024 14:22:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 08/18] x86/resctrl: Prepare for new Sub-NUMA Cluster
 (SNC) monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR2101CA0032.namprd21.prod.outlook.com
 (2603:10b6:302:1::45) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: 23396771-5948-4575-000e-08dc916f06d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0FQWS9sbzk2WVNuY3EyaWo3R0tUL3ZBWDhJOW5pdnFreUY1VDVYcXRFVGM4?=
 =?utf-8?B?R1JRazAvQzZGSFkwbk9neEZXRUFqNURzbHdWK1VHSzZucitQQUtqMXh3T2hx?=
 =?utf-8?B?RVNpTlcxeEVKQ3hudFhvbGVKWGNHUmsyY2hXVlhzbUZMb29BWnZINENwcmhu?=
 =?utf-8?B?cU90TlprM1hsMDFBQ2xFNDRXSW9PclRoRkZ4WEtGY0k4cDVNcUhzZ2dlN3dT?=
 =?utf-8?B?anlCNWhGY25OMmI2UmZLUm1xbWFnUTYzWEphOXB0OG5FY1hnaFBibEV2RlZL?=
 =?utf-8?B?ZTNGOHdmRzBIK0xJdXhZa0Jqd2ZmVUdyaE50VTdrdHNrcWlXejI2R3ZhU045?=
 =?utf-8?B?Y3ZqMHc3a1M1OWpvT2FjU3gyMFE3YXNHZjE3S1BkTnhXMG5ISDd4R3gyd1hH?=
 =?utf-8?B?QjJWWVNmUmdha2NGMkFQbkF1VnpRbUtNYy9DQnUydFdKcDFPMVN6KzdabjNB?=
 =?utf-8?B?YmlCZnJjeTcxQnhBWjBUQVBCQ0Q5cEUrOFRHOFV3R2hVUWd0M3pLTzVSYVB1?=
 =?utf-8?B?eldQNnV4Q3NlVy8wMUpFUFBxNTJ6SVJVUWlQWlhHUFJZWWdIV0ZwOHhrNGxE?=
 =?utf-8?B?NkRaa29EcjJvMTlDZUlTKzFKV3JaVEJ5ZnJNbS92aDJCLytmS3d1WWc0VWov?=
 =?utf-8?B?ZnA4RHloQTBnZVV6b0hKRW9TN0huVS9LbFh2b0F1WlBtSkFjOEFwdlAyVnZl?=
 =?utf-8?B?UG5wU2VESldLYVlySXVhcGJiSkVHenpGVW8yMk9uNUZUN04rNkoxS2hxdXk3?=
 =?utf-8?B?V1lBZFI3a3ZXZzVZcFNadUVNRFd1TWVVcThhak1xU2dkMXJmQkZRR3U0cmo1?=
 =?utf-8?B?S0NKSkRVbzU4VXR0Rm9iQTJqRDRFemsyakVWb3RTd2tXd2dvUzh3YUZwZWtW?=
 =?utf-8?B?RVBoN0VFVllRRUNaOFBPRkVYZ0Y5YnFuN0hGNzdHaWtSeEZVbE1aRTNqQWcx?=
 =?utf-8?B?dmIyUERTaktRR0R0YkEydDdqczZmTldTaVdUT3B3RGcxaG8yRUV4ZlVPOThl?=
 =?utf-8?B?MGdGSUROU2FPUlpQWk9HL0lQVEQyQWFOb1pLWkZybWZuSFhEakNiWWhERGJW?=
 =?utf-8?B?YW5ITi9ZL3ZEQ3JqR0FtL3BFUkwyQmNneGhQRFEvZlFtaXV5SVd4K2VQaXhW?=
 =?utf-8?B?bjcvOStqeDFlZ3pyMDEwdmRtOWVmdHJUS0lFNkQ4YlRibXNONElqdXFJazRL?=
 =?utf-8?B?UjlaMnlSdGVtNmtqZVdoQkp2WVRJTHNIN2M5UWxtNkMxWjZoOVhuVHA5d294?=
 =?utf-8?B?V0E0a3kyZmtYUlFTZkJGUzBrcWo0amtGaW1ZaThzRHBvaVdTWjBOdHFaVkVK?=
 =?utf-8?B?RnpCcTZNNzV5RXgwRlFzN3d6UndrOTBWSkxuRUFkZWo4RDlFQTJWSGoxWE9D?=
 =?utf-8?B?QU91OGpmb24yMEV3TUlwSXQyazVpNjM4RnhidkZyOGM2QkpSQjMyakxnV3hm?=
 =?utf-8?B?T21EemtUL2JNUTJ3TmN2ZmxZWktSQWowNFUyMHROeEhJSjArVDNLZVM2c3lS?=
 =?utf-8?B?UDRCVDBjaEN5aDRlQ0NqM2VQN2RSYnJ5dG9QbGpHSS9nT0RpMHN3TkVMRFhU?=
 =?utf-8?B?UzlwRVJIS0JvYklUT1UvWXRJV0V6S0RZNVZxclpxeERsaFRDbHpRcmFqcUtw?=
 =?utf-8?B?LzJqZGU1RUhxSnduMmsyaGI5ZEc0SVVqR0JhcEMwQWhURDFPeVFQTFY4bGhq?=
 =?utf-8?B?OEM2WDRVd3N5dFovOUlNM2dUTitzdzVtcDNBNEttZ0YzOHlYb09TWm8yU24z?=
 =?utf-8?Q?qdAf2nr9J3M9eH4FyanbfN28tOcSzRiHv3QVrks?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3JMVERCR3VjN3dOUTFKblZKOUw2a2FrSEw1bFFRUW82NU1EcEJONUVydE82?=
 =?utf-8?B?NlVEZFh2L095T0c1RDljeC9tdXpWQWpHbmpHTHJ6ajUvdDZ3M2daNXJ2SEMy?=
 =?utf-8?B?Qk9HcXJ1SGV1eWZLVlRPM0x4aGZma21QejIxYXNDT1ZKQWs1czRtSDcrdUVZ?=
 =?utf-8?B?TVpVZ0N6eTdTckFlYit1bFdSd1A3K2VCbkVjbDkyamwyOUQ2ZE1pc3M1anRJ?=
 =?utf-8?B?aFkyQjBqODVHUnAwNWJuNUpoU3hyMzZCNjVseE1ubk5BejA0Z2NncytXY0d2?=
 =?utf-8?B?UnMvb0xLdnl2Y0NENkpJRGE2SGx1ZTdOUVN2WkVuRHRvN0dyN25aZlF0MVFp?=
 =?utf-8?B?QjR1TUtmYzVOWGR0SGJyQ1dJOGZnQWlRa3RiaVhEd0M2Y2ZYMEl6TktjYXBk?=
 =?utf-8?B?cHIxUFU0T3BodGVvSTlXUjZuOHY1ejUxNU5kMC9WeC9nOHRSb3NUQ0xwSmV5?=
 =?utf-8?B?RTMzOHgyY3N0aUdQWlpKMDdNWjJqeE4yZytoeUxFUm1vWkYyUnNlZ1NTSjNw?=
 =?utf-8?B?T2w4elIrUHZTK0dEUE01bEZ6eTU2NlNQdXFhMFJhR3hBQ2pCQXNGc0wwa2tH?=
 =?utf-8?B?cTFSU0RPY2FlaVRBRHk5d1hXQm9HUzk4K0krMzN4VVI3QW1YcXYrZHR1VjNG?=
 =?utf-8?B?S0pUMUU4MkFGdWJUUjlRVFJHSU9tMklwVUVaRHZjdkhMeFpTTzJIR2ZqYkxW?=
 =?utf-8?B?TFczeXZ4N3VZZVZmblhsLzdEblRWSzl0WnFQU0hnNXhzUGQrMWNHdWMxbDdM?=
 =?utf-8?B?eHVESzBGYUUwNDk0dnd1d0R6NG1pbk1MSzJ5Rkd2TUFmZTd1YWYzMGFtNXQr?=
 =?utf-8?B?M2dzVU5oSVdBeEtGbis1VGhhRFMxeW91U3lIRk5HK3l0cUxHQ1pKcEw1WmJi?=
 =?utf-8?B?dFNOVXB5bTN1NDJSVWxRbUV3QjJyR1BIMVB2WWRIRXJPd1g3VmpOV1oxR2JT?=
 =?utf-8?B?WTBlRERXNU9HWFIvb1MwS2ROUml3cGFiL0RBYWQ4OEhsZFB3ZUdJOWdvTmdh?=
 =?utf-8?B?eGM3T0RJbnhOeThCakJ0QzB5dnpRRWkxUllIM09XTkRsdTB1MFFwWXIyY3Zh?=
 =?utf-8?B?Yk4vWDdJcDdoSURoRUZMM2JPUzFOSVNUMUlZOHhQUjRDT2Jhd1FrdDNPUkcz?=
 =?utf-8?B?aDdpTm9yL0xId0FDTDNhckh0Z2U0N0U1OUJqTnF3N3lCaWwyVlM0SitMYTV6?=
 =?utf-8?B?QTQxTEhkRVowanZZL1ppOGZEMFkvNXppY1hKeE5YTVpkOWFPelVoK2xaS242?=
 =?utf-8?B?YXU4ZktMVXBXTG1MOGd6SllYbnFvSHQ1eGFWM0t4YW5LcTZZekE2UGI5dHZj?=
 =?utf-8?B?Q2hra1FFa3l0ZnRTQStIQWlHN2tqYlR6L1VRaThhRkp3bFBHalluRHhEcldD?=
 =?utf-8?B?UXgrR2pyWU5namE1Qklrb216RnZGcEo5c2Q5cHVaY2RHSU5KRU1jUG1Wemx2?=
 =?utf-8?B?amF0QzdsemxZUGlIQm92YkNEY0F5bmY2SWZhaDlTVEZTQ1RzOFcySGlsMldB?=
 =?utf-8?B?eVNycUdRb2hTa0JVVWxlRXJXUkY4UWtubHVVNWt2SEkzVTNiazlET3VHdVV2?=
 =?utf-8?B?cVlxUlR3czFmVmxQREpkRU1QaEFtWklhWjM1VzVBUnBaZExQQXdQQ3FybEEw?=
 =?utf-8?B?UW9ucmw2ZUtDVmY1bVV5NGh3SVpFT3Y0b0NnV2xFRk9hdXg0K0FzZEk5UkNo?=
 =?utf-8?B?YnBiUFBURWNRb3R1VGJEZjFnYURzNFNuOXdQYlZnSm91SlFCTzNMSkt1WEtI?=
 =?utf-8?B?THRVZWw2bmFwVXlmQUxkSlh3VTRkMTF5RWZSUXJudU5Oc0xtdzhxOFNhbDNQ?=
 =?utf-8?B?NmJPcVRZOHdvd2J2QTI4MmY2aVBUVjR1Y3BBa3NwTjBERGwxQ242dEZ4QWJ2?=
 =?utf-8?B?Y1h2ZUVLcGN1UXNjOVM5YXZINVRjdWUwdXpyd2JBZUg5YktUai81bGZ5QW5V?=
 =?utf-8?B?R0s2YXhETVRWb3pzKzQwaGo5aUdRVUl6YmdCSnlweGR0TGpOMDNkeWJpQmhN?=
 =?utf-8?B?djJldE5yWGQ1WllWbnNIZk1RWmtQZ00wODVIekcxYzFWNEtkYXpQdjRuUWlK?=
 =?utf-8?B?TmYwRGIvRGQxVEhIZllteFcwaXR4UUFUa0Q5T3oybWR2Z0tOY0lOZm9xVGJw?=
 =?utf-8?B?QmZPRDFzZWdwS3p6ZjJmUnU1cmhCd2tsZ3JVRTdkWVpHREpyVEkzaXFCNlNX?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23396771-5948-4575-000e-08dc916f06d7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:22:02.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNpUi+BV5gL0kns1aWOoiTbeEuYD+UWPkVlR7h4TjiBI6Wrj0dCoJGpNDJ2bLgmXYzcxkq82d0qxAkO13XMmNUsbKNnJL7wIQHBxg51gZkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> When SNC is enabled monitoring data is collected at the SNC node
> granularity, but must be reported at L3-cache granularity for
> backwards compatibility in addition to reporting at the node
> level.
> 
> Add a "ci" field to the rdt_mon_domain structure to save the
> cache information about the enclosing L3 cache for the domain.
> This provides:
> 
> 1) The cache id which is needed to compose the name of the legacy
> monitoring directory, and to determine which domains should be
> summed to provide L3-scoped data.
> 
> 2) The shared_cpu_map which is needed to determine which CPUs can
> be used to read the RMID counters with the MSR interface.
> 
> This is the first step to an eventual goal of monitor reporting files
> like this (for a system with two SNC nodes per L3):
> 
> $ cd /sys/fs/resctrl/mon_data
> $ tree mon_L3_00
> mon_L3_00			<- 00 here is L3 cache id
> ├── llc_occupancy		\  These files provide legacy support
> ├── mbm_local_bytes		 > for non-SNC aware monitor apps
> ├── mbm_total_bytes		/  that expect data at L3 cache level
> ├── mon_sub_L3_00		<- 00 here is SNC node id
> │   ├── llc_occupancy		\  These files are finer grained
> │   ├── mbm_local_bytes		 > data from each SNC node
> │   └── mbm_total_bytes		/
> └── mon_sub_L3_01
>      ├── llc_occupancy		\
>      ├── mbm_local_bytes		 > As above, but for node 1.
>      └── mbm_total_bytes		/
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h                   | 2 ++
>   arch/x86/kernel/cpu/resctrl/internal.h    | 1 +
>   arch/x86/kernel/cpu/resctrl/core.c        | 7 ++++++-
>   arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 1 -
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 1 -
>   5 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 64b6ad1b22a1..d733e1f6485d 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
>   /**
>    * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
>    * @hdr:		common header for different domain types
> + * @ci:			cache info for this domain
>    * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
>    * @mbm_total:		saved state for MBM total bandwidth
>    * @mbm_local:		saved state for MBM local bandwidth
> @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
>    */
>   struct rdt_mon_domain {
>   	struct rdt_domain_hdr		hdr;
> +	struct cacheinfo		*ci;
>   	unsigned long			*rmid_busy_llc;
>   	struct mbm_state		*mbm_total;
>   	struct mbm_state		*mbm_local;

With struct cacheinfo used here I expected cacheinfo.h to be included in
include/linux/resctrl.h since it is now needed by resctrl fs?

Reinette
