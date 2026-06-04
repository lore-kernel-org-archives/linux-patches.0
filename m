Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B104430C63A
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780586936; cv=fail; b=sDtc73iXgtzCoBsci6ciZlpWm00IjiDK9fmuTR/FiywgYAajEM5F7ScR/F2HesYs84pxLZj+1IOAzLlov7XBO7nxZfXdMbDmHfyw5TKmOpMi1iImUISR+S+PbcGsUGVuNnvWPWmwS/ejZ27mTUv29/utvzw8a4BCtlB1FcvMIFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780586936; c=relaxed/simple;
	bh=d2gHyaI+No/ZpmoKxVx0IlGp6lBJwm0b5JK7elx2xIs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PHXxl/mvW98VjWBjCVP6vM1pg0vbUDf3chwyTZic/dEhsFZK044FufIfCYemKnr3Hd7aZERj27eR3RfC1pMc+phTJrrXTIa4JaCA5SBUW7w5dppgC4zHVHYbb2H7wMjWbSDdVo58eYjGgY1W5VSTxg1dcDXhLSc92LYLKU+k7TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0ughqO+; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0ughqO+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780586935; x=1812122935;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d2gHyaI+No/ZpmoKxVx0IlGp6lBJwm0b5JK7elx2xIs=;
  b=X0ughqO+ZuZaOH3s3m0Ed+GSSU+dRXIRu2jOfdk2+6SeIsIf+UkHfIdH
   Ss47Cf0IN20iJjrrwuseeqVL7g/aLa+M12GpDVtlfm16EvgFIX48xG/Q3
   jrgqP1oZ7PPf1Qlaz/lK/YwsWI5nslZxvkYC+88aoFGwT3gVQhDzF6bMb
   fjPlMwSYU0Xq/GzkuMRRftizZWl75bCkaH5RkZ70xzIAHLjEYYGic4Vau
   0uXmB+3i9fZ9orbrxJrehk0/1eU1Pfks560IMkQlyV+tUyNoJvjfD+e/Z
   Wx2fix273c9/UEyYGYsLSn5PHS9rJQAQ4DPHj+KkYYdVnNc3KhaIEthBH
   w==;
X-CSE-ConnectionGUID: aGY6E+PkQLCX0OCXyVoCHw==
X-CSE-MsgGUID: wy3hQVEPT8SiqCTTpoxEQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="92522930"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="92522930"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:28:54 -0700
X-CSE-ConnectionGUID: 5zlRlM61SZOCC0fKyo39QQ==
X-CSE-MsgGUID: y1gt6CEMTwCh5UqJFBzXhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="238227752"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:28:54 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:28:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 08:28:53 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:28:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lam9WoENX16F7aRzZEEav9iCP2YWhDezrBc5L8EkP9hr2OILnP76dxMTf2Sovo06AzsJLK276433jjeM4c6TxovLwflySHkSlAk1O6SxQm/8W49Apx8wjbztQTUMWOT3uDFPyXJ5d9svAgJzQ4TcMATs+QZ9/e81OMsofOtiESmRxeVkGYuS6SnBhrVVJwaS9NZaXSZD31kCIOiVS4fnkmipWv+s7Yx6MKjemRawCR7r3V7WLdmnqkprz18QWqSLwuA8eBz5v/9foxhPNb5bk/ASNiPEkwnBHb+HLAYBnAwn/kioEufM90dqkNcwm9XstmZ1yQ76Lu7LO7nST84rEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdhY8//TkfdfTQPNFBepQ0nqjvaanPBYqnvT2Yh0OEE=;
 b=jb4tv9V4/XcfJfER6Y/NnEpTqCdHfne9bcwN7dHIZsdC7nZkRIWucr4r70HILKb3RamrrtHp2HhwfP8Zd1BbOuC9LCdOi72pgofZkuyi+DfELc2OzvEOgIHfWmcdGZp/YRkAw2UoAHBYc8idfbwAeqNp6ysrla+NjIZbfRlI0G5paJcIFThzD9StJKFqkPxCZRmhpv+IaPZUvvEu6akQyPNuFux/MgTaEUmvGPfgR443xD+aUhFmIDQlkKLxxA3eaAEZVCrD/sbcFJZUZ3DlBFW4PZ6Z0YTDNakYiO3QjvsoTM5DEIt4Xl/HH/gyQvKrZTC3ZqZ7DHU7TnBAUq4Hbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Thu, 4 Jun 2026
 15:28:50 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 15:28:48 +0000
Message-ID: <405948c5-a5fc-43f7-8d36-725e566c2f22@intel.com>
Date: Thu, 4 Jun 2026 08:28:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/10] x86,fs/resctrl: Fix long-standing issues
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1780456704.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <cover.1780456704.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:303:b6::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cf5c1c2-7e2a-4331-209d-08dec24df958
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 4egHJl8w3QG/7d0rQa5jO+WCN9hXxEBxxU+vusXn1wt3efIk8BLcie7Z8vyjGYNa5MlUulBT4h9N5zGT9t9HRInc+fHrSTZO7gw7ZxUTtdfRWy4tDg8HjTIUDVdIcXMJG6f9xIlJIei52WsLvV6TnQzOjt6XWAjeoQMntPxEKOOI2dlc/2EeTzKC+cR19Ho/PGK+vNWqnBqn3TLHilCnjSIvysBPyUROkMijqyAInhKHsReuYpwkmTNcpIugJwcFs5bWEKJOp5DD8QsR0M4I6be7xM81OtLrqrDYdmOnuEerTBW8tJMulj3J8qXHm+yVZUISayE9cVFjlRKatjzdscbM3tNejRm1saKdyvyxrEXlYv0uiLnsUm2AuQujaPRuSpZnGoxYUD7cJEho2u3E3hKHgZgeyl0Tl8NOm7KT61v3hOOnhhcknENC/dkArcG8kdylBwGjRFb+GXztAZXtguTieb9Wr6I+hG8llqExyfh5P4IkOtk+JHOg2PvyDpzNXShJrQHiZ5saP7L0VK/UP6HByJbb7GxbIoVMcwXHaJ82aOdCqfDyuIVOlnWJO3yKTeAqDx8AwKqzSMSini54yFtrxiIKWpS7p/WPS6HmamAfYXim7AimYP9nTpqUtaNOg35P0Pus1hpptENrSPyPVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REVOSXo2LzhHOUZxRmFTUUtBUGhIWmxDb3R1Nmw1R0JtOVE2UG5JSWFsKytt?=
 =?utf-8?B?NnVlRDYwRys2VFhONk9vT2QvNzZkUjNZbWhUOG9QNG1rbDVFT0VPSnhLdko1?=
 =?utf-8?B?MU43cXFSSnpvR1c4NUdsTnFHVUc2UHBuc1JsY2tNdlg4Rmt4N3MvWWF3Rlll?=
 =?utf-8?B?RGtxY3NKa1RvdEZKVUR4YUw5UVo2UGJJTklrZitBYm5nOC9DQmMrT1c2Y0tn?=
 =?utf-8?B?ejVZbXlSc1VHWkZRZVlWdnBPNndrK09TUEdzNVRhQ2w2MXQrWmlrREVTOHo3?=
 =?utf-8?B?ZmFpYXFVR294MXpkS3Y1dGkxMmg0N0hpTXNYSStmTzJWVFNybXdEVmR1TzQr?=
 =?utf-8?B?SEw5Uk01UUZYMTBlVVdoMFk5OEtOMUZBWDg3S2VMVHZ2TElQb2V6QzcyRmNK?=
 =?utf-8?B?T0laZElSNS9rM2M5VXpVWjZ2RzQxQm9tSGRUQkZsU1hkZlRKYW9sbHBMbWpq?=
 =?utf-8?B?czFJcExIMWFYMVpMK3RCMFlnRHNucjQzaTdIeW9qaXVEaENVQWpjNUx5RzBv?=
 =?utf-8?B?ckVMWXgwbG8xU1ZVWVNXWmFsU2lKYlNMaldMV1JYdnZiWDVoYnR4eW9hUUNC?=
 =?utf-8?B?WUtTZWtJaEMzZEs5RnFlb2dGNWhmODNOTkwza2M3YnduVHdCT01KTytaR0w2?=
 =?utf-8?B?UUVCOUFENGlURDN3ZjlBOUFYdXR3eEFWWWUvQ3FLd1VoRXQ5SWJZK01BdU1o?=
 =?utf-8?B?Nk5OMVk0Zks3emdUb1hqRGQ0TkVoVVNLUU1lT0pGVWw0M2RFRkpSOVlyOEtG?=
 =?utf-8?B?WVhLWlBiTlg0b2xIdnFVVUpEVjRoYkJiQmtsQlhNN1BrWVdtQ1ZubVFxT1pr?=
 =?utf-8?B?WTdZeG55aVdIcklaMWdxd0VaWnlWMkhlWU5WMDdsZmlyN21pazhkeGg0cjZw?=
 =?utf-8?B?Qzg3Uy9XbytKWFhnQTJMZ2Ryd01taXMxdUVkWUR1M2lES1ZJYmgwL3J1ZlBD?=
 =?utf-8?B?MXVQSzJpQkhUSU9BdThxTmRhVFdTSlhwUWZCVmZaU0toMzIvaGlJYmFxeXQy?=
 =?utf-8?B?YWp4SDdmTGh4eVhjMTdLRERtSnNsdDNnbmx3L1hkMFdGcDU4bjhjMmY2aEFD?=
 =?utf-8?B?a3l2NXhBK1ZqbkRZTC85d1VhRkt0b0x5dWJMMDhRby9PdnlNbjVmRHNrWFFX?=
 =?utf-8?B?TWpiQ2NLb2tqeVpDczVSWTVwWFBwQzhXZW16cGxlVkIxajlmQ1p3U1Z5WjJR?=
 =?utf-8?B?UUl0eTlYak1qTk1UTHVOeW9EYWp5bkw1VUpPVm1scitLeVNNbTVQUWxPZDZl?=
 =?utf-8?B?cklKYjZjcmh5QWZDZmJ0SUxJUmMzRXFQYWdkMjd6WFRXMzhMdVhsZHJ1UWp6?=
 =?utf-8?B?VXVDd0JnYkx2ak5NVkFxeWZlWkRXTTBIVm05MkUyMjhlQUxuY3hHZDRwdFNj?=
 =?utf-8?B?YWt0Zi9vVldUZ0lGRzZ2N1JzcjBmdkVaT1lMb0NYWE53Y2xkdDZUTkRaZTl0?=
 =?utf-8?B?QVRSZ3plWnR0aWM2MFhISkFiN2lFdkpJTVdKVnRaOE4zK3ViaHgzRGp6a2d5?=
 =?utf-8?B?UFFZSVltd2ZwMkV3UGJBV0NNZGU2TUVaQlZwaE1pVWVUT1JGVFlJYmk4YzFi?=
 =?utf-8?B?SHlFVGhUcThBSW5uQVlhTEZ6MXhVa0JrSU94cEdQS3BLenJ2dm83Q3k1MnNx?=
 =?utf-8?B?cTh0eEJxVUtSNnAwRnB5ODRXQ2VLaTdFTXB6NWdiYWhaUHN4d1NvcGRZY00v?=
 =?utf-8?B?SEVPYWlXSkx0dTE5MHJKOHhJVEdKQWV5SHBvZkx4RzJrL1FPeWZPQTZjdmg3?=
 =?utf-8?B?QXp0b0RSUm9jUzRxRDFCckgrcWRSREVtbzFGZkhoU0lSNHJYSFNoU05KbVh5?=
 =?utf-8?B?Ump6SUhlWDVQZ04rT05oWFo4WkRxVGNSdWVZcVdROFFnK3l1UFBvS3lWMG13?=
 =?utf-8?B?VUIxRGJhQnVzNHRLWkZuQ1d5dTkvNUVKRXR0OW9kWFY4bDl0NDExWGRGcXVI?=
 =?utf-8?B?ang4aSs0emw0ZDJVM1dqRXNGVEN2RFVqZVFLMEdUZm4zcnZvSG9EL3VpOEdr?=
 =?utf-8?B?TEd1VWd1dXZRUkNtQzBSQ3ZUTGUyeWFGUHJiY2FjM1RMWnRrMVRRenltRHJk?=
 =?utf-8?B?RjY2NDYzMGwvcmxOdU54d296N0lCWnp0S0VQR2ZpMTY5aCs2akVrTllOelkv?=
 =?utf-8?B?N3c0YmVuNTRRS2xVNFBiK3VIMWpvZ0s1TTlxWGczZndNekdEbjFrcldYWk54?=
 =?utf-8?B?VE5jeVcyZERIZDBNc3V0VnNkS3ZtbkVKeUgrQUZSYmtKMzQ0bVhTM2RQNzFU?=
 =?utf-8?B?Q2xoZFNwK29MNGJ3alNMcEV1YkdXak94MlBVWTNrUzZHdktja1E1T0ZGczFl?=
 =?utf-8?B?QXUyMWtybUR2Wkg5bXpNUm14S1FsN3U3bncrNkk4VVJtZDdlS1Y2QndkTzBa?=
 =?utf-8?Q?kYIy5ODDH88c/D5w=3D?=
X-Exchange-RoutingPolicyChecked: fMhla6IAyYS7zKhOPdggZV9fgZltxitwnUPPP8S/5EJa/pwdOAZ1ta9U03MQr5xZdimGmmUZNDEsQHSCnfjl3AZa/Dq3WUeqgLsh2NWVhoGC0MqaadIEVgnrKNfKcJ/F+Jaso54Prx6o4rks/ccThoNwtYItiRqsQYHUhpdaH3kpKkY/kNMaYy5ehcqHXHR54PYin9QZwvwkK+18JtTLZyTSKHR23AU4EW0+bt67L2kAJ86lkRjcmLSIPH2p50T4gbwxdUmulzzGOWOIU7fNCT3ZMroTj68jXmeYO+rKpFZvqis7V6zCib6yzzHk1Pj+0HdcZA5HVqd2b+BGa4Q9Tw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf5c1c2-7e2a-4331-209d-08dec24df958
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 15:28:48.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+JvYT2yOdtihL8QKJ7AoxB/JkxyUSRyjf7zde3AOXd9t2h/a9MeJyOz8glAwkaIEmqfztQKXXzRqfZ0v6AHjb9n4xb5nKT51codVq9KE00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com

Hi Everybody,

Addressing the non patch specific Sashiko feedback from
https://sashiko.dev/#/patchset/cover.1780456704.git.reinette.chatre%40intel.com

I respond to patch specific Sashiko feedback in individual patches.

On 6/2/26 8:27 PM, Reinette Chatre wrote:
> v3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/
> v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
> v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/
> 
> While reviewing the AET series [1] Sashiko reported a deadlock during mount,
> and a use-after-free when an L3 domain is removed during CPU offline. More issues
> were uncovered as fixes were developed and reviewed. While the goal is to
> fix all issues the races surrounding pseudo-locked regions are not yet
> solved and have been removed from this version of fixes.

As anticipated Sashiko reported the issues surrounding pseudo-locking. There is
one new concern raised between pseudo-locked regions and assigned counters but
pseudo-locking is a model-specific feature on hardware that does not support
assigned counters.

Sashiko did uncover one new issue related to the limbo handler when SNC is enabled.
For this I am currently planning to add this patch to this series:

From 95da3282f94754e8840497be632314e542375e67 Mon Sep 17 00:00:00 2001
Message-ID: <95da3282f94754e8840497be632314e542375e67.1780586352.git.reinette.chatre@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Date: Wed, 3 Jun 2026 13:37:15 -0700
Subject: [PATCH] x86,fs/resctrl: Prevent out-of-bounds access while offlining
 CPU when SNC enabled

The architecture updates the cpu_mask in a domain's header to track which
online CPUs are associated with the domain. When this mask becomes empty
the architecture initiates offline of the domain that includes calling
on resctrl fs to offline the domain. If it is a monitoring domain in
which LLC occupancy is tracked resctrl fs forces the limbo handler to
release all busy RMID.

The limbo handler reads the current event value associated with a busy
RMID irrespective of it being checked as part of regular "is it still busy"
check or whether it will be forced released anyway. When reading an RMID
on a system with SNC enabled the "logical RMID" is converted to the
"physical RMID" and this conversion requires the NUMA node ID of the
resctrl monitoring domain that is in turn determined by querying the NUMA
node ID of any CPU belonging to the monitoring domain.

When the monitoring domain is going offline its cpu_mask is empty causing
the NUMA node ID query via cpu_to_node() to be done with "nr_cpu_ids" as
argument resulting in an out-of-bounds access.

Refactor the limbo handler to skip reading the RMID when the RMID will
just be forced released anyway. Add a safety check to the architecture's
RMID reader to protect against this scenario.

Fixes: e13db55b5a0d ("x86/resctrl: Introduce snc_nodes_per_l3_cache")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1780456704.git.reinette.chatre%40intel.com?part=9
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v4:
- New patch
---
 arch/x86/kernel/cpu/resctrl/monitor.c |  5 ++++
 fs/resctrl/monitor.c                  | 39 +++++++++++++++------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 9bf9d7e201aa..fb7024ae50e6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -259,6 +259,11 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
+	if (cpumask_empty(&hdr->cpu_mask)) {
+		pr_warn_once("Domain %d has no CPUs\n", hdr->id);
+		return -EINVAL;
+	}
+
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	hw_dom = resctrl_to_arch_mon_dom(d);
 	cpu = cpumask_any(&hdr->cpu_mask);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 0e6a389a16bf..a932a1fea818 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -135,10 +135,10 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	struct rmid_entry *entry;
+	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
 	void *arch_mon_ctx;
 	void *arch_priv;
-	bool rmid_dirty;
 	u64 val = 0;
 
 	arch_priv = mon_event_all[QOS_L3_OCCUP_EVENT_ID].arch_priv;
@@ -161,22 +161,27 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 			break;
 
 		entry = __rmid_entry(idx);
-		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
-					   QOS_L3_OCCUP_EVENT_ID, arch_priv, &val,
-					   arch_mon_ctx)) {
-			rmid_dirty = true;
-		} else {
-			rmid_dirty = (val >= resctrl_rmid_realloc_threshold);
-
-			/*
-			 * x86's CLOSID and RMID are independent numbers, so the entry's
-			 * CLOSID is an empty CLOSID (X86_RESCTRL_EMPTY_CLOSID). On Arm the
-			 * RMID (PMG) extends the CLOSID (PARTID) space with bits that aren't
-			 * used to select the configuration. It is thus necessary to track both
-			 * CLOSID and RMID because there may be dependencies between them
-			 * on some architectures.
-			 */
-			trace_mon_llc_occupancy_limbo(entry->closid, entry->rmid, d->hdr.id, val);
+		if (!force_free) {
+			if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid,
+						   entry->rmid, QOS_L3_OCCUP_EVENT_ID,
+						   arch_priv, &val, arch_mon_ctx)) {
+				rmid_dirty = true;
+			} else {
+				rmid_dirty = (val >= resctrl_rmid_realloc_threshold);
+
+				/*
+				 * x86's CLOSID and RMID are independent numbers,
+				 * so the entry's CLOSID is an empty CLOSID
+				 * (X86_RESCTRL_EMPTY_CLOSID). On Arm the RMID
+				 * (PMG) extends the CLOSID (PARTID) space with
+				 * bits that aren't used to select the configuration.
+				 * It is thus necessary to track both CLOSID and
+				 * RMID because there may be dependencies between
+				 * them on some architectures.
+				 */
+				trace_mon_llc_occupancy_limbo(entry->closid, entry->rmid,
+							      d->hdr.id, val);
+			}
 		}
 
 		if (force_free || !rmid_dirty) {
-- 
2.53.0




