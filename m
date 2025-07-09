Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DBD230BFF
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099538; cv=fail; b=imJA+V1YisO2J08gVFa+mEbLjJlsweXmWyAbZqUSVeGIXs6ue0uhy3SsxozzjxUojn+AM5E4oHSnRjKueQ4tv5HfUarsGVq2MabXdMJW5vTcrUMjs1LfjC2H3mEtN5KJOgw/UD9Kz0V7ZKBA+gluYxAG9nWYrYs7PcbfJrO8jcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099538; c=relaxed/simple;
	bh=jn2iDZ6drRtWcfM+ip+geOmndSzFK88n9UMGOxaWsNE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NJ3cOXtZtRy7SGBJ5CQ4DquQlfvg+fkYBTTbxRng/VsYpMIU7YOiIrytPDvAkdkmfnBnxHHKC9kTC7ggTAbI8ECqcIYQnpA2L0wWUq+P2yRS4rklwWlGpCNZhXeF0N/b8x13X0acyaQHV9SyQRvIv7IJ4tMix9iWpfAOy5wKwQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=doH1RAnn; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="doH1RAnn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099537; x=1783635537;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jn2iDZ6drRtWcfM+ip+geOmndSzFK88n9UMGOxaWsNE=;
  b=doH1RAnn1h6vcsTg8FtiBr3Xtnfa3CeaICTRMe9Rjy5rHzmWu/v7+GbU
   9gRiZEEwHBee8ObR/50KSLxiw5V1bItE6+5ajsf6SBHXP17QsE+MGrdqh
   r4xKC8evCS0PBE9rGetq+u3Zz1IawC1PbT/CH6FLBxcv7wkDZ6B8nxfzG
   mSPl7WNM5pkdgxljkEsJm6JwsPpR70wu9DPXeHDar0or7cvxmWP/6Og6Q
   /vFJiC/YEOpUEyxh6YCkeuQFj3itsWNVDNtlW09215d/zoukgCyCT7xEC
   i4XYB05MHEljrNWQMKQfvdMagsRmwBLrmaRUW5J2VoJ2N9iaycr4qwhP9
   w==;
X-CSE-ConnectionGUID: WBQ0R0n2TYKT++w9xf4ovg==
X-CSE-MsgGUID: 70/hARTAT++c9HNkjrIqtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="65723092"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="65723092"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:18:56 -0700
X-CSE-ConnectionGUID: 0V4fYZoISCaO5gEXNbIFVw==
X-CSE-MsgGUID: CZ6J5WlVS0Cf2mTnFANp9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="186866497"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:18:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:18:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:18:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:18:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ylP7jE8ttxGfjmpyIktQCxC8B8ZFyQKDFeMS/H9jgP0ljHd/cHKVN8GMy/QNN0sUj/wRQPXgecSun+MdDdsR+PP/QVo0R7IOLJNAIGXEL6RpGdvkEKdQG/5y9TVFF0DTDk4ViPE2dkSVO+b+rdSILfmO4JTbEHQUxWDiax7D9oktZIcbv6X4MEdOYc9fY7Wxqy4pYBVB55DhclIwEttLybipyQ6+boBbL5tWK9usiNZYJl0u/nTdbXcwxQPcyotzvsZjXO+zv8MbmZaI6I2C4C0wvOi4y2W3jIcFZWCvSQuArVAiQyPb4N1XK+wEFiQDykj00xcpBydR0qkRNtwmOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFQqiYfD71C+m9EHuCHPZRfUMGUG0IC8jPmxq6o8nKw=;
 b=Lzou26lmse2LvDl5c3j0y02kQiSzfpxsWarx34isb2ryyQFZeEgpw+Diql5Ozz3ja2TLH0qv/hdWUIdJQMF8wbx7H0MX6BeIDgGrEOYMAAV+JpyoC8U8aXsib9GzSPrc6o4ywNu3HSWzoQLsAJr5T/BJz7paMSOP19WGYgsVRlRyL743NbbCX1Dyu3yaj1vQhaoUAl77yOrFMdcLbq76os4I4XHlCqBIpdkaZO1x+y3ECGASwyGjYvA26ph0+apGdQfaPq6/1zNU3cuqoePTnss53cOyXXJA/equhhevHLDm2dH2sSu1/Z/gAsfa8clyoVSQhOhRzWLGKEDQBZp3zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 22:18:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:18:26 +0000
Message-ID: <db76238c-253f-4cc8-a761-6548be76f862@intel.com>
Date: Wed, 9 Jul 2025 15:18:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 26/30] x86,fs/resctrl: Move RMID initialization to
 first mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0129.namprd04.prod.outlook.com
 (2603:10b6:303:84::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d1683e-61cf-484a-4d2a-08ddbf368695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N1FrWXVDak5Eb0VxOXNTbGl4dTZvLzRxNlp0SGVNNkxGeVk0L3I3dUVYSFkw?=
 =?utf-8?B?RGZOdFpjV0Y5Qk55SXNZTnNubCtkOERXY1RGbU1DdW1zZExIa1JEUWFZSHhm?=
 =?utf-8?B?cTdML2o4cVNIVHd2c0sxQnZGTXVOYW5iR1lZclYrR3N4UEFQS0xVU1pZYzdQ?=
 =?utf-8?B?WENqVTI1L210WVZnenZtbXVpeGc0YTdnWlFKaVNLK3VvSWlwREFXeDQzK3JE?=
 =?utf-8?B?Qkh3RVl1dHFWMUp6V0ljUGg4UlNwU0VBWFdMU0UyL2pCSVlLYjEzb0hjaGIv?=
 =?utf-8?B?RmxHbzJvUzFFUFRJVEY5eERkWTFBRFpMRkx2elhYM0poQ0ZmbEx5Q0ptdEFG?=
 =?utf-8?B?QmJpdG91cW52eCtLRk5xM0g5UEdhZ0grTEtOenFNa1Z4WGJPY3NVbHk4Z3Ix?=
 =?utf-8?B?Q2dWckVMTWQ3SDgxTVFoeG84Z3kvVGZtb2xKYis2WXVpdWFrdFVwZkhoenoy?=
 =?utf-8?B?Qys5Y2w0bGxPWnJ2MXIweEw0NzBVWGMvRmdqRkloZXNSdm9sL01zTFZIUUZ0?=
 =?utf-8?B?L2VRNkxPbHdBejI2YU4xdGxSemVpeFM1blp3UGJnSnZvY1prdjJ3NWJTZHpE?=
 =?utf-8?B?NE1TQmJCVXhzZDlIeTNKa00xY3Q4VkFqVXVLVEhYODNSWmxsem9aYmRTTkpp?=
 =?utf-8?B?enB3TUNhcnU0QitmUTF3TGhRNFU0b0VwMlZWc0FjZjNhRGlQVW00ZU9DOU5Q?=
 =?utf-8?B?K0tuVm0xM2NFTTUrSFN2alBmeFU4M3RYdVdkN05aSEY4VExGRkhSVlRUZk1y?=
 =?utf-8?B?V3duSCtEWG5kbDRuVy9jUFRlZXVSYmcwZHNTci9RUlhVRlYyZFZHLytJVlRp?=
 =?utf-8?B?UXlNVGYwUHluS2tRZEp2bWNUTGczbXN2OXRMQkNiV3M5SDh4L2lNYWxSUEs0?=
 =?utf-8?B?cTNRaTJ0RlZVTXpKZWU3a2cvK0Y1andzUzRhdlI1Yy9lQ0xmU1FxODNrNGF3?=
 =?utf-8?B?OFNyY01TMkEySmR0YXZPTjBlS3Awdm1oUk9pS0o3RTkvRTIxTUlJbHdMNkw3?=
 =?utf-8?B?K1FJZTl5UmVzQURHdmZ6YlJUNk9sVE1MZ0h1VWM2UDB2RE9ZNnVmT2ZleHRl?=
 =?utf-8?B?TE1zYmJmLzZRdGpsTjZLcklEQmNFcDROMjRsUi94M2xLRW01aDJWSzdCVkNp?=
 =?utf-8?B?RGhJT2s0c1FLRm1wVnN0U0ZRQWdCOEdjQ0Y3Z29OOGdVTklYM0RtN3JldWNk?=
 =?utf-8?B?VVNXcWJzd1liSnNoQTZuSkJkRW9KK0k3NjYvVllyMEtVMWIwNUVVcnFTSDI3?=
 =?utf-8?B?ZzVSdm02SXBDZTJNMjJLSlJGcFFVV2JzRmZCRHdabWc4TnJmekhHOG9JU1dC?=
 =?utf-8?B?THZ0WVd2NUVVRXZUeXpQUUptUFFUN2gxdG5YeWlUN1Vqa0V0TUdMYTkwNk9S?=
 =?utf-8?B?OWhDUk5uelhRbkdpajdUS0tKd1lyT1dkU1JKWmE4bW9lZnNGM3RJVkhXSnBo?=
 =?utf-8?B?NmlwQUVJWjhybXhBbkJoYWloNzFHdUp0RmgrSDdFbnF6QW1rNzJWRU9oQVhG?=
 =?utf-8?B?MDNBenlLVUowMDlkRWxxZ0x6bThHbWNFQVBxNDU1cWpWOHlWNEM1d0hpRlY3?=
 =?utf-8?B?c25LdXcrTDV1OGxISFhiOGF6RklxSlRYWExQYkZ5OXZGZFpnUEdNYzR1WW05?=
 =?utf-8?B?eXN4QXVSbW1qeFdjcThxSkxoNXh2ckFWRjMveGx4MGtyM0hSRzNGaUNaaVVP?=
 =?utf-8?B?UEZ6MXhrUEFCV1l2dWpMdjdXNFFCWWJFaHpVU3VqL3MveVQyY2crVTRaaVRF?=
 =?utf-8?B?d3FEcVpScDMzell5dGtsa0t3bzVRekR3aENZeGQvUnlCREVTOHZsY29DUXhB?=
 =?utf-8?B?SUQwRXRsQUpOYVpaL2tGSjNkdlFRbjN5bkkvMkJ3TFArNExnSDl3bzBXWWVX?=
 =?utf-8?B?bGVZYjhqVU5HU0lsVHRxdGZYL1JnQnp0NXNrc3RvbDV0b1JoR3pxajh6SFBF?=
 =?utf-8?B?UHNLVnVnWkNHSGU5UWtoRUZGNGhsaFpVTEhRRXdvS1pycFNkVTMwTXpGZktl?=
 =?utf-8?B?TkJNRmFpQ0l3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mzk4Q1ZRWXRlS2pvbytqTHd0VHY4a29BTzIrbmFCUXVOWTZmRWE3UGdzbkh6?=
 =?utf-8?B?TlozZWE4UUFoZXB1YkV3SHFBbk14dkhrc0xPbWJRdFBhU1J0bWdONHpHeVpq?=
 =?utf-8?B?eU5oeUNtQlVUU0xKNTV2THJwUHg3UWRpRlFaM2VNend2VEppVFhJdm1ySW01?=
 =?utf-8?B?Wm1saWg2ekdwckQ0TjdHcEkyd1ZGbGkzZlB5YmJteTVrTHMzc041RXdnMlBn?=
 =?utf-8?B?bkxXSEhHakEvQzA1RFdkL3Qzbi96SFFCVnNRMHNGeDlkNDM3cWlocjA4WnRV?=
 =?utf-8?B?aHRpSUt3cHZKZUhKTUVMT2M0aURNWDlFUGZmQzAvYm5DUzMwb1Y1Q1B1NlBq?=
 =?utf-8?B?bmIrVFQwbm5BOEJoSWFYc1RmaUlqM1YzZmZhODBaY1hVcnFFcXB6d3FFQXBh?=
 =?utf-8?B?MmlIYXN1c0k1aEZOdW0vejVsbUFvSXdzQUpIRUVvaGFIbkVWUkN3UlRDVnNM?=
 =?utf-8?B?enNNZVpLeGVyOHJ0b1FtWndtL1dIY2k1SHBhU2k3NUxsZUxsU1F0VTExemRs?=
 =?utf-8?B?L3ZIeW14YTNmMXZyYjV5RFpwUU9Kall6VjBqeTBiekx1SXBFampDeGlNNUNT?=
 =?utf-8?B?RUIwNWVSaXhsWmdsQ3JyZHZDMzl5VHJOeUVCQ0RCNEk0ckI2Rm1ZWEtSelZt?=
 =?utf-8?B?K2d1QkhVb1ZTcWFCNE4vOXlheko0VGtMa1NxVFdDQjkxeHlVbVI5YWlSNDNt?=
 =?utf-8?B?S0dOTW1Qdkpvd0ZtSkVVRERWbUFxZzFvTUQ0ayszN25tUTUwaTVCWWFLNm5Q?=
 =?utf-8?B?QkVRRkRvWWhyZG1nUDZvaU1YVWdPOGtVSDd3Uk5xTEtCY2luVGp6NUo4TGZR?=
 =?utf-8?B?RlhFV05nWTgwRzdmZEpYaW0zbWp4bnh2MlBuZXcwVHZUdGxNU3VnRjgxMGR2?=
 =?utf-8?B?MlFPb0dUS2lvQlFZUERFVW52YVpSVkN5NlVyOGZFc2cyS1lTVUhMaEl5Zndk?=
 =?utf-8?B?cnR6eldQU0pXa2poMGpxeGRYa2pxV0tDOGxPNHR3ZGZ5djB4NUZOVGZwWEJ1?=
 =?utf-8?B?Z1VGdnNOZHBtU1ZOenJDbjNDNlhFakFXQmZxZVN6R2c4Ri9pTkxkNXkxVTB3?=
 =?utf-8?B?dDZGSGFQbU9zby9SZkN5MGJ6UkZmV01zcmFDQXRvdkJSb2FCTmplSUdxRGRG?=
 =?utf-8?B?Q2hZL3hXOUs1NHRqcXBSRTNjdTNZclVmM2FWa2ZPbi9SYVZ0cC9rU1JOSXBq?=
 =?utf-8?B?dUR4bVVyTmMxNjFMZG1qa0ozYjJ2WTZPWGZvM08xeXlzeEJVTUptNkxaYVdH?=
 =?utf-8?B?bVduRTdJR3d4UFEvSGx5N2RZcGFadWlucVhibEhXRjJ4Rm1qSENtcnZWcXIz?=
 =?utf-8?B?K3FpRkc5aUZYaTVDYXVSd2hTS2xvMStUTDkyaUo1ekZmRzk0UmxzbGJRNldK?=
 =?utf-8?B?cEMxYnFiQXA3YWE2SGFVakI2em9DZG1pWkdGNi92MDN6bDllOFBZWDJZdmdW?=
 =?utf-8?B?aFcyM1ZCVm9FSnBXSllWYlNEQVRSQXZnYjlQSmEzNVU0NWtzeSttYUpyUmtm?=
 =?utf-8?B?YmJSNzR2cWhjbnlUOUk2TTIwWE1QN1FycXdBbDJFZTgrbFFBaUpxRkg2SG1s?=
 =?utf-8?B?aFdCSnJXZTN4dWhoK2hnUlhteEN6bkI0cEk2Q09KQndkeWpyaGYvZ0ZZUG0r?=
 =?utf-8?B?SE1tdnRmOStVd0NpWFJ4V1J6OEtFVUI1RjlDdC9GTEsxOW1uR2dIbEo3YzVL?=
 =?utf-8?B?RkpqMVYzZ244WHBGQWdHMlp5YnVDRXNsa3ZraVc0SEJiOXRZVU5MQU1yOFpV?=
 =?utf-8?B?L1FqQTVUOHpBZDkvOGZkTGlyRjZwMk1IK0tIN0d0Ujk4SXF0cTRGQmFRbksx?=
 =?utf-8?B?YjlOK1pLb3V4TWdPUkl3RmpVRTJ4OE5JTWpPTmVUUkEzYytDTDREd1MybHpL?=
 =?utf-8?B?TytEaUxLblZHT2lTQUhSblVEUE5pK1lmM3J2SC8reldQeGlFVmdBVGEwSHFr?=
 =?utf-8?B?YzlkSkg0M3JuMEYwSy9YYzh1WEJMRTkyNGF5MDMyMUFGVFo3a2V6eW9GRVFm?=
 =?utf-8?B?d1NrMFNiRVBTQysrZXRyeDdCcklPcU52WHdOdkE5cjJIV2l1clFaVElQaGtV?=
 =?utf-8?B?ZjV1V2tIdXJINE9HcXQwVmFUd0JZejc5bHp0WGhBbTR6ZG14MjFrSEdlcWlV?=
 =?utf-8?B?S2RPejlYSlZNOWNOaDVLcWFBcEx1K1N5aXhRQ1pKZWJXc09qTkM3aGkyLzg4?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d1683e-61cf-484a-4d2a-08ddbf368695
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:18:26.5281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exlbLxclEaj9UwVXvXbiSyOsvqQT9pergXu0V0QGuOg/hQRSOLo47c7Fpo1WaxOc9gzs4z0X83I72zen44kmVxRif1LTZKNUIQWRRQ3/Ieo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> The resctrl file system code assumed that the only monitor events were
> tied to the RDT_RESOURCE_L3 resource. Also that the number of supported
> RMIDs was enumerated during early initialization.
> 
> RDT_RESOURCE_PERF_PKG breaks both of those assumptions.
> 
> Delay the final enumeration of the number of RMIDs and subsequent
> allocation of structures until first mount of the resctrl file system.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index c4b092aec9f8..e877f5b97d18 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -796,15 +796,27 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
>  }
>  
> -static int dom_data_init(struct rdt_resource *r)
> +/*
> + * resctrl_dom_data_init() - Initialise global monitoring structures.
> + *
> + * Allocate and initialise global monitor resources that do not belong to a
> + * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
> + * Called once during boot after the struct rdt_resource's have been configured
> + * but before the filesystem is mounted.
> + * Resctrl's cpuhp callbacks may be called before this point to bring a domain
> + * online.
> + *
> + * Returns 0 for success, or -ENOMEM.
> + */

As per changelog and the goal the intention of this change is to move RMID
related allocation to first mount ...

> +int resctrl_mon_dom_data_init(void)
>  {
> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);

... this is a red flag ...

>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	u32 num_closid = resctrl_arch_get_num_closid(r);
>  	struct rmid_entry *entry = NULL;
> -	int err = 0, i;
>  	u32 idx;
> +	int i;
>  
> -	mutex_lock(&rdtgroup_mutex);
>  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
>  		u32 *tmp;
>  
> @@ -815,10 +827,8 @@ static int dom_data_init(struct rdt_resource *r)
>  		 * use.
>  		 */
>  		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
> -		if (!tmp) {
> -			err = -ENOMEM;
> -			goto out_unlock;
> -		}
> +		if (!tmp)
> +			return -ENOMEM;
>  
>  		closid_num_dirty_rmid = tmp;

... looks like this L3 specific initialization got caught up in this move, resulting
in L3 specific monitoring initialization unnecessarily split between
resctrl initialization and first mount. 
I think this can be simplified by moving closid_num_dirty_rmid initialization to
resctrl_mon_l3_resource_init() where it seems to belong to be with other L3 initialization.
Doing so will make resctrl_mon_dom_data_init() dedicated to the RMID related
allocation that the changelog describes. As part of this the function could
also receive a more specific name.

...

> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index d9bb01edd582..3d87e6c4c600 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2585,6 +2585,7 @@ static int rdt_get_tree(struct fs_context *fc)
>  	unsigned long flags = RFTYPE_CTRL_BASE;
>  	struct rdt_l3_mon_domain *dom;
>  	struct rdt_resource *r;
> +	static bool once;
>  	int ret;
>  
>  	resctrl_arch_pre_mount();
> @@ -2599,6 +2600,13 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	if (resctrl_arch_mon_capable() && !once) {
> +		ret = resctrl_mon_dom_data_init();
> +		if (ret)
> +			goto out;
> +		once = true;

Instead of the caller needing to keep track of this the function
self can just not allocate the RMID structures if it already exists.

> +	}
> +
>  	ret = rdtgroup_setup_root(ctx);
>  	if (ret)
>  		goto out;
> @@ -4298,9 +4306,7 @@ int resctrl_init(void)
>  
>  	thread_throttle_mode_init();
>  
> -	ret = resctrl_mon_resource_init();
> -	if (ret)
> -		return ret;
> +	resctrl_mon_l3_resource_init();
>  
>  	ret = sysfs_create_mount_point(fs_kobj, "resctrl");
>  	if (ret) {

Reinette

