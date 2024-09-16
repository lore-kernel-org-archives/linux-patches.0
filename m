Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED387158A2E;
	Mon, 16 Sep 2024 21:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726522966; cv=fail; b=Yw4U36Ccl4T3fTYXFtWBhXG29w6iFJD7eSDzlXB0tHO4V3fjPx85CqKZ3rv8SzTqucDnf5lTFFjRu/INlGniHvxUVqKaxguocnO7J/MN7ebfwRoY5YsqY1rkhpR/gaD8k3JeGlHOvjmQ93FZecunhWu1hQTLBhq0Ui9WU/8SZoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726522966; c=relaxed/simple;
	bh=nvVBC/qwhp4Wcmqa9+3Ts8aDsI7b8OmwGOaaho2BoQ0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M5gDx7RX6B7jep5XxpOVxo51XBZ6sVrBqLcX37RggVOemsPxHpMsyQ6TvPrSg0Ez65jnE4HqdYcF/P6lKBWScOme/CmarNPyswaN+huts7q9hxl7sRKNRgRd2MVNI5A6rvr16RPnqD7hDsFHrYQbrZ5gSDiNak0J/AH7ClPWzag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ew9L0MZu; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ew9L0MZu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726522965; x=1758058965;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nvVBC/qwhp4Wcmqa9+3Ts8aDsI7b8OmwGOaaho2BoQ0=;
  b=ew9L0MZu0QI5Gu4H8ZyG8Qarw/1O63mz3N81l9aSW1fpW6xpT0KUNi6p
   gitROQhz6yeu1ulZA390ji7hY1wcoHWMxX+sFtDFw5dRJZGASfNJFq64Q
   eDeyNpSdIBUXS4VJv6XpskFj9sOO436K05yfOMlByG9DuhHFUdqrJlYAL
   8hIP9+wZxiRFZCYaNk+d6xISiJKMNz2zrPRCEzha0KIyELM5Xw7LGSffS
   m2pNPzI9xAVz0MFVP6Tt+mncTWqzp+DSSZirwi7EPdpeX+cKoS9r+oP72
   +3k0zUOdm7hj0K0We6I2cDY5XIMMbU1bSnk0sdURxmx1Egnij617vjPLc
   w==;
X-CSE-ConnectionGUID: 66p5BtWeSvS4RZzk6DD6EA==
X-CSE-MsgGUID: 7kC6qcIcT6it8/oF9ThNbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11197"; a="25523040"
X-IronPort-AV: E=Sophos;i="6.10,233,1719903600"; 
   d="scan'208";a="25523040"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 14:42:42 -0700
X-CSE-ConnectionGUID: LhNQFQbdRsqmynFPnO478Q==
X-CSE-MsgGUID: 1gZdKRWeSPql+o2F8sJkuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,233,1719903600"; 
   d="scan'208";a="92289758"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Sep 2024 14:42:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 14:42:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 16 Sep 2024 14:42:15 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 16 Sep 2024 14:42:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E96mQf9QDEaP2OQET4Dyhh+1563AKCccsGXbpfCmT/DXcLwiLGAsePARd+sd60HliGRLupAqGDuO7dRvjyv1wSB/+uc1+vR2k8c450ATyEuG3sTOHkcoCA5DA2CkncuBJBg5/ns+8cOAU/O0qWvvvaFg3cV+bnDu8ynua3j27rc96PmxXl1H45baxqWXAI6ZWHdyJ+c48C/vtUW8eVqffJ6MLZL8N8Pqf+1d7L5FB4LLPBMzHWuR2xpZyHQ+qnOQoY9D97qvZtR7RFmhyJskEFTp26CPJO8E8TjUzyD6cWSGicFMiqop1KKempT2R5bx340Ct8SVRoNAxRztUmkt0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIe2us8WuPwCZ7sCFUM93pyav0Fx2gGUR15GILaKdhY=;
 b=UKD+vPao74zfKL2IJH9yefja4Mh6DO1Tmc/OGI5T6AhlQk4NHL1xsMXMy5sJXw97Laviyu3zStwPge+eVGBjhRK3HhzU4Sj1Dfw0ELWApfwrCCQ8IQXqd22PbnVIJIe0yPHpbwQg1lOZVB67R3rEAHxT9w2mVPqexOkQ8kazWat4KbRQonpOxBjmw8ZA3d1EQjSrJhBXvm55SZXPow9eFaDKh0FOo6FjX94wVMW49uR5m1KrG8aK9OuC86MM/uFLIT9p1UP5aYQXPK3noUufH8nxB0vAKsQYaxOC2Zj4NrdF7xxtoatpv5s0mJ9dnCTCkHYO3C6An9+ZvcXcLmNg/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB8286.namprd11.prod.outlook.com (2603:10b6:510:1c6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Mon, 16 Sep
 2024 21:42:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 21:42:12 +0000
Message-ID: <8e34346b-9703-48e5-8923-15800fa78899@intel.com>
Date: Mon, 16 Sep 2024 14:42:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/resctrl: Annotate get_mem_config functions as
 __init
To: Nathan Chancellor <nathan@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
	<x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0353.namprd03.prod.outlook.com
 (2603:10b6:303:dc::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB8286:EE_
X-MS-Office365-Filtering-Correlation-Id: b3da6068-dced-480d-d69a-08dcd6986c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aStRT3gvT01OTjBtVE9iL2VwR1J4dVFxWW1XZG9POUFFNlFOd3grUVRQaVlz?=
 =?utf-8?B?ZFd0dDNwaDFHSkd4ZFVobEx1bnhoR0N1V3p4aVkwK01ibG5NSCswRlR5bzFR?=
 =?utf-8?B?c3pmaTJmOHNsNHRLZG5WQ3c3QTFjNlp3UHhleUhXTWJPaFhJQjR0T2h1dHV5?=
 =?utf-8?B?U2JzK1NGdzM1V3N0SCtoK0p3eFNwV2JTN1N4WThtVlRLc3pxdHhzdU5xWWcy?=
 =?utf-8?B?b1A5M0pzMWJhS2NGSGFTQkZPOHp6NG5EcVFJTnJWNzEyVzFaMmI0OFJFOUZo?=
 =?utf-8?B?TUhHVlFOcjQyaSt5cjVzcWowdEFHQTh3TDVTa05qMGNCV1JiNktaa3JzVEc5?=
 =?utf-8?B?by9xOXE0TXFwaW41MUExcnV5bklaZTVGTHplakpDWlhlWmlENlg3Q242VjFR?=
 =?utf-8?B?RXVNWXdJMnNEeG5qMnhadzZhZGsybEpQOE95aThFZkozNUR4YTF4SWpCUTlm?=
 =?utf-8?B?aFVFSWZtTnNQaTd3RG9wS3JhaUhqQ3Z2UUtLRzBnbDBBb1BOU1A3UGl5cFBa?=
 =?utf-8?B?b3g5VHNQYWVKbWgrZzNlam5DNHQ5N2IwTzY3dnNpU0dqaElDVTZZTVBvTkJS?=
 =?utf-8?B?MGVtWGlZSzJ2eEp0VXNldVh4UW1aTTRKMHdpZVNMdkFIajBVMTNvZlVVZmV6?=
 =?utf-8?B?OFpRQXZZTGNnSHZldkZTaEx5VncxbGdhT3NJSk5UV1BadHRSTGd1REhCWkxC?=
 =?utf-8?B?M0tBbDJEblBhWEIrNlZWVFFNYWlZQkE4b01kdHR6WFBnRXd3cnpIK0ZRNkhE?=
 =?utf-8?B?dVU0TUtpeWY5Yk5Sd2NMTVBZVEhiRkc4VDVZcDBYK2pXUGcwSDZyZXZ4L3d2?=
 =?utf-8?B?STNvTzY3clh5bll2YkV2dW4wdVh2d09kaDJRMG5obU1NTDF4VjQvWHMzdmdD?=
 =?utf-8?B?eis1VUtva0piSU9jMWdBVkI5dXZjWUVoZGljelRDWG1aTWNjUzM2d1VJak14?=
 =?utf-8?B?OFVlUmJPZXhwdDdTSmJoZy9QQXBYOW9teTl1OHQ3Q2NVVnhXWHVwYmhzZ2g3?=
 =?utf-8?B?MXB5VTQ5VVdUMWtRb2Q5ZDZ0OG5Jb3Nid1VpTThJTk5ucFU1N0JrTUp4NDUw?=
 =?utf-8?B?NWtRbGppUmVobERjV0VVTCtnK3hpcXZpc2VrWmxHMkx2SGhzbWFsdTVHVEdM?=
 =?utf-8?B?Q0RvcTMzeUpqWXRYOUVrQ3dnSjFvVVZDTEJ1YjgxemlDTGlCWi9mTnFFYjVs?=
 =?utf-8?B?ZmRBRG41dHkxQ2pnVHd6YngwcnB1QnJqRlpTKzZaSFdoZnkwWnRoNDk3ZFBJ?=
 =?utf-8?B?NXZacDhKUFNCenVvS2ZQUFZHSWFwT1c5bkdhcm9Fa24zWHpXYy9hZUpGTHpB?=
 =?utf-8?B?MlBxYUZIeEpkY1lVWXl2L2VNM0FqeDNSenFXaGxXVkZFTGZOMWFhdGcrQVpJ?=
 =?utf-8?B?WExrQi83UnQwOE91cER5Y0JJSjlkcVFpWHlnamZnVE1vRU01YjFBZkhjWE1J?=
 =?utf-8?B?dTlpUzFyRjZCdnJtQ2N4U2RiaXhscFkwU1hlNVQ0Q0pNV3JHVGlpR25CdmN4?=
 =?utf-8?B?ak9WYmIzTUl3K0ZSWDlmQ3FrN1RRaG1SYmp1aXQ1ejNqN1dQR2E2VzVuMnFO?=
 =?utf-8?B?OFhEY3BIc0hGU3doRXZ5Q2FROE84c0hIeDh2K2pqWS9PVTNNOFdSS2VRRXlk?=
 =?utf-8?B?UitsU0xJK0tnam5kTXdLRENKNkorYk54Uzk1SXAyenpyTjJUU0NYT2ZSNjhk?=
 =?utf-8?B?YWw4MkhqTFVXVjRrWW9xUnNmeWphdmxtM0dkQ1RUV3I1NWVuc2Z2dXA3K2hk?=
 =?utf-8?B?eUlJMG1Yak5CWUVmMy9sbGprOWh2WFQ1aDV0VFlqT1ByMXR4Um1yRWdBSXBI?=
 =?utf-8?B?dnZBb0tWOWd0a0xiVDZrZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnVlbnovQWdkQnBrVjJxaGVwQkRib1lvUTlNNi9aSW5FcGhqOFFOMzJ5Nzl6?=
 =?utf-8?B?UXVuWXNxSXU4VkV4dmVkbW81MktHc09oc05vZHJXTWNLWUpZelhVeVBSR1RY?=
 =?utf-8?B?eERCRXlFM0xNc1UyWUlrNmhnQVJ0WWV4b09WdUt3RjRXQnd6cG5nekFvRDM1?=
 =?utf-8?B?MjRQVzdFOUJPcklUU1RGbDJBSHJoa2JDVVdzcTBFUGNJcGJpRzBSVlp3Zkkr?=
 =?utf-8?B?cnYvVXhON3V0a01TR3NjeWJST3B1a09PeGdMd2txOVdHLzMwemZ1K3VUMDNS?=
 =?utf-8?B?S3NSR0l6ZGRDVGNhcWl3TEdWdFpxTWo3ZDhKaDlUVVduTWI5TkcvMFJlSmhk?=
 =?utf-8?B?WjdyVFZ6NTRJVzVUV2IzRTFmTGJvL3M3VE9HaXgrMzkxK2k5aVA4Z1YydEVC?=
 =?utf-8?B?cHgvQ3h2cEQxeGZFTElnMGRkSDNGYTQ5S1FyNTBacG9EeE0xOG9Bc1pnUll0?=
 =?utf-8?B?OEhFc20wMG1DUjhqNE5tM1BGZERIa25RRzZmUTJUc1VMeUhzLzUreUZ4VzR4?=
 =?utf-8?B?UnBiK2o4dUd2SWZRNVhRWnZhaS9nbEQvbzV2Mm5mcE5MQ2xibU9mY21ON1RU?=
 =?utf-8?B?amlTMVVQVnFVSWJGMndvSjd5MHFySXFoVTJaZDZma1NKa2ZWM1U4cTdjVEtY?=
 =?utf-8?B?RGFURlJlMGdFZUYxS3ZkV1NjL3RMNzZRQnRqK3lhRkhBV1FtcVQ1TklaWE02?=
 =?utf-8?B?YWxtNlUzUVVMeTBhZmx6SkJlVWUreXBlOTBMWjJTcHpjcW91ZnZ3SzZhRm1R?=
 =?utf-8?B?VHdGbDJBSHMyM2lCNEh1K2hwelRLVndkTGd6NWlRVUQyWSttWDJiZFdCVlo4?=
 =?utf-8?B?UkN5YW94M0YvanN2Ri9zMGJ2UU5hSS9xdTVqbHlVSGlzOVFLRCtVOGpSZ0xr?=
 =?utf-8?B?TzcrcXRjd2dTR2ovbG5YdHRadHJIdjJoN0pVU0ZQK0RBZXZIejV3NW5pK0Zt?=
 =?utf-8?B?VENlTzZvMlR6K09neEJFZm9FcFlEd3NUQzlMT2U5WmUwMWViVndWbjNqMGU4?=
 =?utf-8?B?S2lWLzV1Tmo3OWJPQXpqaUNuRmYwS0Nlb2ZQeDd2NFZINXorK2ZZblA0eHZS?=
 =?utf-8?B?SVFMTmdIdng5LzRSV1dkaWIxUTg4UldacXJvY1V4cDgxOFc0MHFzNmhLekp0?=
 =?utf-8?B?U1Nhc2hYYWRGdWRnQURmd3dNUTk1VVVLc1B0SFRsZy9mMFA3c2tnU2FzR0cy?=
 =?utf-8?B?MXVhR1g1UzNDelp4VkhJVTQ1OUNxTFZtbHdEbGFYanUyYTZWT2N2UnF3aTBl?=
 =?utf-8?B?TUVvSUZLSm1XaGh5WWxzcUZRbGk3VlhHSWdnZXB0MmVkR05BbnlqeE52Sk9w?=
 =?utf-8?B?N081M3FWTDRvS0lMSE5kMHYwTHk0d2dnWjViN0J1UjAweUpBOEpjOUQ2dStN?=
 =?utf-8?B?T1grc29UMnJ4V2hROHZlTkF1bGFEeGZ4SGExd2w2a09uRTFORC9QUWJkbUhy?=
 =?utf-8?B?MGpZWWRrc1dkR1ZBWmppblhwRHZmQWE1R0Z1SEphYmx1VzhMVnhidXJmdG1F?=
 =?utf-8?B?OWFlendlajdYTlhGR2dnUjJ5QTBSOFY0bmp6bTRJbjNPVjFaVk43N0xjNTVB?=
 =?utf-8?B?ekhrUG5KWmhSOEhIdnAwMnR2UThDWTY4bURqQ2Rpem5lM2dxS3F4ZlNjNUJT?=
 =?utf-8?B?UFYyRkRVU2pZNjVsVXdYOHptR0lLSXl6MHl5cE0xSWRkQkhSdWVqVjE1NkpK?=
 =?utf-8?B?ek9hTVRZaG5kT0Fya0hNU0VjNFl6UFY5cFZBYlk0d1lJbUFOYWNSdnpTVGNt?=
 =?utf-8?B?bzNJYWN0NWpPNGY1dkNDTEJMbExlVzlmZVNHUlFlYnFBcTRRM0U4bENJTGRq?=
 =?utf-8?B?RWdEMXJZWjJWVHBkNUtXNEdHRG1XZ1hmR0pxMmljQ2I2WHY0UFczS3M2dUtq?=
 =?utf-8?B?TGhrUFk5Z3I0WWZXSW9TUWtCd3JmdHZ4WXZRd3lSWnFMY1l1bGFtalFaSUkz?=
 =?utf-8?B?dU1lbnZ4NHJnOEh4YzUzYkN4emM3OXBNcmhaZjRPUTk2bXZ2QnNTSGRJcVRm?=
 =?utf-8?B?YmYxZkV6Q3JpNVJwTDlsNFVuZzB0aWJHMU9CY0FmUkMxa1FNRWVGMFV6Z3dH?=
 =?utf-8?B?blVaMllLWEMyNFJqTzJ4cnlISEo1YzR2ZzkwVXA4ZUVjWU1RdTFPc3RoTUYw?=
 =?utf-8?B?V3NmTkZUalV6MnA1RkNxKzRNOVJvcUhDOXFkVGFYTVVQV2k3NmNUcGR2MDNK?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3da6068-dced-480d-d69a-08dcd6986c69
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 21:42:12.3278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXp1JHgJZDbI1MDzSo2nQrB3/XVSYOcECVEBA92hK8ml4u4BKJRxL1q7ZaW2wICGLSvonBjxhczvjM7BGuuNbaiZar76PBWvZzmQ/FJq4D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8286
X-OriginatorOrg: intel.com

Hi Nathan,

Just one nit in the subject ... this area has the custom to use "()" to
highlight that the name refers to a function, so rather:

	x86/resctrl: Annotate get_mem_config() functions as __init

On 9/13/24 4:27 PM, Nathan Chancellor wrote:
> After a recent LLVM change [1] that deduces __cold on functions that
> only call cold code (such as __init functions), there is a section
> mismatch warning from __get_mem_config_intel(), which got moved to
> .text.unlikely. as a result of that optimization:
> 
>    WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
> 
> Mark __get_mem_config_intel() as __init as well since it is only called
> from __init code, which clears up the warning.
> 
> While __rdt_get_mem_config_amd() does not exhibit a warning because it
> does not call any __init code, it is a similar function that is only
> called from __init code like __get_mem_config_intel(), so mark it __init
> as well to keep the code symmetrical.
> 
> Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Thank you very much.
With subject adjusted:

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
