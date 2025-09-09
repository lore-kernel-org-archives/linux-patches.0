Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E38125784B
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453230; cv=fail; b=tTFBG7/mLuCnO+FFQZ7QSiOcfEuW2QoRRdoH6EgIKPd+kCE9bpsWXiVneB0oBdJ+X/JxEi1UVOPivFLUS8j4M5SIFyaUHlkhvIlLZ6Pgc9vIfwDxqXZ7cbXaD5tpZODx1tczO1QeO7B8vKQTc8PDbpXN2IBgXW/twKVaJP8MvdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453230; c=relaxed/simple;
	bh=0sICJWEuVHnOk1Z7PnrrDP3ogqbysiSq/6gCwtR22jU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ScdFfJBzyDH3+midY9mJGq3/UcgccXj50XPoEYiD4RAsdCq83P+R8pcRz9Z8YdgFP0vMpnle/rmZG3CXSlhsjLqLKpZcFFVEBLxVuGqkaz0YXeArFw/ghpLezCfc86MJwVqqMM0RPjLHF+bNxvjuWTHgNRt/s+q0FtQxD5wx0/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XDDjtuw6; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XDDjtuw6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757453229; x=1788989229;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0sICJWEuVHnOk1Z7PnrrDP3ogqbysiSq/6gCwtR22jU=;
  b=XDDjtuw6mwUBR0ZIPty7VtLnvlARWRp+TG6t2j5fxCY3SBlYT+p90LG0
   ignT7UtErif9zNvQOhPCj2hoc4pTkcLYAQ5ASFKQTw2KKm9VJDFavEj7t
   CiVFmkNKpEoZIGroAyvI8GkbCHZVhkb0Sn7F8jfPm4MBs5kK0Fgla7f0L
   nuqhKqBdFmLYV/pP4bWdtzROGOMtALzVIE42/SA99UGeICA2mnzL1HTE8
   KqA3RGV7FaXWVTxhfd6V4ZqbM+0m75aOqmCvm9oYFMyAbR+ioGTHq8AxI
   IoUFeb/lh0PTgesHA6DAPAqKhuK5q8jSDo4eBb5wJT3uhOjUfYudfRykX
   A==;
X-CSE-ConnectionGUID: liielGYFS4+klEQH9YylZw==
X-CSE-MsgGUID: GAL6hBGwS8Cuw4RLNN7NwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="47324799"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="47324799"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:27:08 -0700
X-CSE-ConnectionGUID: DZA+dhHNQruns5Tqj1tnOg==
X-CSE-MsgGUID: rp7astGkSaC6BjjukhoW/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172481243"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:27:07 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:27:06 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:27:06 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.86) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:26:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDtZJGJONjMzt1LXTTpUQ8zHu0asMDcI1WNrH1atKdbwuuvCmtUwOJcev43LF9snEzRFWkdz95hjebG2Hmrw3+tBwhKPCx8byAgzXt0FbjVQGJaD8DHwMwJL/W0psOW7gKp3MF9Xi/GNLeEZ+WpxagnOShXZHWd5XKTw4RMgKfEyca10XftpR3xsT3GD8nAtVt2E6OUTPY8eo8UnUeLdHe1v1WnhqYBRVKF3T7ol1gGLuf0AaaG7450GEEyd9+1V5STkKpLP/Ix6ZT7Tk03o8gYvFqFT1BrhXj5lCFYjh+Y8FE/ZSDhBmQuAaUgq6P5S5LU022KP1wqFIpMeHZqwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSH+Ni5t5ibIUS0B9Fh4No2MJswPA36C4TN0AbQJFf0=;
 b=l3QPwd82okJbAG/Ik5c99WKgIoy86fbE/FjBk9/VZIytSlWEZfNZrNX8Ds9jrpGU+SD6VP735T1W8699vZRNlSEAa3Ip6xF7Ph5otNn1v+x65EGng75+u+dhLBW0/is0mJQn4HtVrcxrDB+0Ntb7Tu8h67GPFU52Dl6VN2plxqqJEfwAFB+hxbm7h+SBnK08GrCBobjXG3RGRKonuoh3ghT7IKpDWGWZAR8ovxNYhrN+Y6xSjsrNSyuaK4xtrvo4EmYxqCqdeGlLyuCV/F6FxLt5Td3P4ej2vfvyoEx4sJZep1kL8euymlNQNGnL9K2GJm/LrIPHx+DeQUy6UcOznQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9297.namprd11.prod.outlook.com (2603:10b6:208:56f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:26:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:26:57 +0000
Message-ID: <7483f56d-c542-4a37-a9a3-affcb4d3d14e@intel.com>
Date: Tue, 9 Sep 2025 14:26:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/31] x86,fs/resctrl: Rename struct rdt_mon_domain and
 rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-11-tony.luck@intel.com>
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9297:EE_
X-MS-Office365-Filtering-Correlation-Id: f7742d36-d7ac-4280-c916-08ddefe79ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b21XVUthVGpkdi8rL0NkTGhNdFhlMmpwTERsM2I3OFgySTRxY3VDcjVWNjBn?=
 =?utf-8?B?U3hPZ3ZYWlZUNzZsV0NKNnB6R0J5TjlNdjhCOHB3YkNrYVNNOVZMUzcwMGYx?=
 =?utf-8?B?YTNVQ2txaWFjVVB2RlozNUpRSlRFaDYxc1ljZmV6QUlLZTZNbVVrM3hjVnNX?=
 =?utf-8?B?MllsQnp4Z2w3QXcrL0JmdkNFN3hRTmdNaGhXbi80OVpNL21uTjQ1b3drQ2p2?=
 =?utf-8?B?MGhSajNSbmVKanhEajlIdElKcjh4U1N6SGF3NjNWZnRLSHAxMXh3MThvRVNO?=
 =?utf-8?B?c29XdXlVbGZrTFNuejIxYTVYNGJpTUcrdER0NjVDOEFJdHZ4N3Ezc08yUHc0?=
 =?utf-8?B?ZlZOQ3BrcWhLV0ptK1A0WStrWFBzWUdTWFV1SWhBbEtISFpzWVZaZXlPYmla?=
 =?utf-8?B?RzlWdVVxOXV0cUNZTm5xQ3Bla2xaM0hnbUI3aFlnNGdreG15dXRtNS9YdXVv?=
 =?utf-8?B?L2pxOTlMVXIvQ0grRVFFeDlNT3BySUpMbTY2MWhiUUhTdFoyY1RYRlBMdm1w?=
 =?utf-8?B?cXNVYnJYcTJ2d3lFemJHWkl5UjBVYzdiVXRYRVo1WFdDblRMNk1mM09HV0h5?=
 =?utf-8?B?MG5ObmFwUHFnQThmRzI3bjY1Y3p5bVdDQVp1a01JcTloZDNkeFpCeWdsTzJS?=
 =?utf-8?B?dy9OVDJTQm1CKzJtZUZYdWlLeUNoaTNHajZGeDJPUnRCbTNkVDJoQkVTdHAy?=
 =?utf-8?B?cUtSOHdYQ09KRyt1UHdLenc1WmZ4aFNyNlVFRnI5VFVSZG1mSzlIeStCTEQ4?=
 =?utf-8?B?M2duNk8wY2RnbWVBaTd4dkE0RXJZc3FIMHUyNkY3ekFTSEtwcys3b1g5NUZa?=
 =?utf-8?B?N3ZIOS9pSExWcUYvMzVpQkFVT1M0TXBuekFJcmh0MnZaeExvcWRHN1pWZHlq?=
 =?utf-8?B?a2Q1VWxBMnhVVHpma2xEdStIYi9uNjBrcE9QRlloaUJ4LzBtalpSdHJvbGF3?=
 =?utf-8?B?NGpVQWxKMDJNQzNpNyt3RmxVeER6ZnZWRUlXQVRtbzdTdWdiOEppT0E5V0JZ?=
 =?utf-8?B?UlFmWDVoQXRzQTArbjZjSGZHK3JjYWhPbkI5NGxBbVVnUDNLb2pvVmsyK20y?=
 =?utf-8?B?dzAwU1pMS0dzVDFBbThYZ0FPbUNSejZzRWNmbXNseEZxdFluQ0RwVVBpaXl3?=
 =?utf-8?B?Y09CcWhYaVRESzByV3E0M1dLNmNLSkV5cWFPemZYWW9FTXJJNzFQVXAyMHN6?=
 =?utf-8?B?bkMrSkRPUWdRVVhsZkh4VFg1Y0FrVDY4VnlNR0QrU3prM21yQkNub2p0RHpo?=
 =?utf-8?B?SXdQNkR5L1JGeFpHR2k2S05leW1wZlErNy9JY2ZKdkZENnhmeW9ZV3E5Uy9M?=
 =?utf-8?B?bCt2ZUdBWGhzeitQcitrU0xzOHZXbktvd0xaV2pGRU8ydWpnNjdLMUU2UlhY?=
 =?utf-8?B?OWRNeTNFbk9jMndQK1RhTUYrL3MyWEtpeThOVldnYkIwREJwNGNaZ2w0N0Nj?=
 =?utf-8?B?MUtEOEFmTytJTk16OHRLZk53TVpab1V2VmRYNEVkOUs4ZGI5VDNHSm5CYXRl?=
 =?utf-8?B?Q1pKc2kzWjIrZjJJLzNHQlYrNFRSaHlES1FkWWxvNlQ2YWUzQ1ZmKzdSWDRC?=
 =?utf-8?B?ZDRkZEtSRGN0RWVCSTZQeGE0blUvMUpTa3BScm5jdTl5STM5My9GWDc0eS9l?=
 =?utf-8?B?MmVENUdVK3UrU3dZWW1oTDNMcUZKdFhoTzdZOEZzWU9tSVd4NVA1eXdnbHht?=
 =?utf-8?B?WnNyWmFhUTZyMFRHdEFDMXMzYjlFd3phRFFMdFE4YUxpUENtcGJJaEV1TjU4?=
 =?utf-8?B?MmdjVWNXcU1hOVRyZEZRQi81OGh5ZDJnL1lObVZVU0t4RklSc3ZHZFBkSHdJ?=
 =?utf-8?B?bW9yVldUaUovQVNZL3JueHBpNlFCdVJUZU42SDNjdUFaNUVpeThwdHN6dGRU?=
 =?utf-8?B?dFd5d2UyQUxFRU9JdGNOdGJ4K2R3eUVCTG1YVVdDQ2l1M1prWUNMRU8zVDBh?=
 =?utf-8?Q?YuLC1rrzAkQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rys2ZUxndHJLQ3IvQXY1eHBBdFg2cDJXdVRsNXdUZXJRbjRjdjY5UTB4VXNn?=
 =?utf-8?B?aXZLRW5lYVZWTEpyeStHeFFiWDJENkhFWkdBTTFlNUVjV09vVEZNRFV3Q2pJ?=
 =?utf-8?B?UHFTeUdPbkJNS1hyMFF6VFRwRnNSSHo0WjZZQmxnUXdCSm0zWXk1MHNhS2dE?=
 =?utf-8?B?M2VBcE96UHQwV3V6WnFNMkRsQklnb2o2SFFtOFhHblZod0U0T2xUWVBCUUhH?=
 =?utf-8?B?THdTSFdMS0R2bXJuYm03d3FZd0VBdms4V3VtbUxYL1dCVkc5L2JBN0c5L0w0?=
 =?utf-8?B?L1lWWmdYU0l2RlBxd3kwdytRbXFrSWN6RWZiYW5VbTlzOVVGRlIyNnc4MjJs?=
 =?utf-8?B?RllpQ2luY2JUQUI3d2lZL1ZhYXE0aDI1dkRYNlFnNHVVdXUydUlmUDhSaWx3?=
 =?utf-8?B?eGtaQ2w1NEF3RGN0UHFSbVZJVk96QklnbzUxdUwxRGdrbHgrQWtNMVM2bnNp?=
 =?utf-8?B?N1lnamk5NHZBb20rNzRnZDYycVMyRkFSNmlBTk1LLzBTUVRYdkw3L1JBWkxI?=
 =?utf-8?B?K0NERktEQ2tjb1JlelBmS0l5NkNEbGRvakVNTFRNTUZHdENVYndKV2JkNGE2?=
 =?utf-8?B?TjhFNmU0M0FlMUtTcGl6UHJEUEt4ZzlMeXVpcDRqTzRRaVpJaTgxNGtJZjM2?=
 =?utf-8?B?c0ZvQmJHc2R4ZnpSc01CSDhQZHNrMFRIWWNhUGJaKzYvRzFYS3d0Mks4eFAw?=
 =?utf-8?B?Y0JnMWg2YTRmcVEvUjdQbytWR1p5VW1DNi9odzNBN2Y4NU50REFWOHd4ZnJT?=
 =?utf-8?B?Vk95SGVhaTFSMVJDaVJtUlNCczJpK1FDblI2UHVWOXN2WTBCUDEzSDBFOW9W?=
 =?utf-8?B?TGRxRmpIUi8rYWhMWTBwd2poMjRxb0JYeDFqN29QdU9uWWJtM0xEa1Bndk4v?=
 =?utf-8?B?MldjSzB4R0NicDY0cmFaQVByb0hOeU9hNzdQSDZZcVhleE4vZDVIZktvdHAr?=
 =?utf-8?B?M0R4OVozcEd2MmVZd2RRajNpazdKSUNiWUpHOEViTVpmU3hIYTVpbHZNQ05r?=
 =?utf-8?B?Y0k5NW1taVIrenBrUVpaS1I4a0tWQURLU25NWkVKeXdvZjBiT25Wd0V2U2Zx?=
 =?utf-8?B?dW55U3k5UDR1aGo0aG42SWFQaXQ0TTNtbE1EQmhGNkdZVmMrYTdjQmVEajlv?=
 =?utf-8?B?OUFTRkZSOGF5QmJTL1dyUnJjM1hoQ3p2MS9TWFA4T1JmeENIUENKcU5uNHpR?=
 =?utf-8?B?RVFhYWlFaWdvZTFpVjc4d0ZUVGF1SG5FWXlJdEFLdE9OdWR2WGlUQk1hdVc4?=
 =?utf-8?B?KzVqYUF0KzE3RElxSXQ4TVlYai9xK2lvMmdDODBYY25lSFJNeTI2Rm1OL0M2?=
 =?utf-8?B?U0xSV2xGRGtwWUFpSWtrMHdpcDJlT0ZXbnYxbEx4MnZISEZFNjBqclZvSDh5?=
 =?utf-8?B?bkM2eldMSE9VK1JORld3TmJuajJGWlhIaU1QM2FXTlJYLzNiTE42d2xXT0Q3?=
 =?utf-8?B?RS9VQnRLTWxvVWdleFpiTlcxQytLdDlORTFuZml5bnRRVG5idWtLUHR3NDhB?=
 =?utf-8?B?TGhPa2dwUDlmc0VYRGhRMUlFMzlGaUhTWjdGWmJTclRMbUFsRFluc1VESWo1?=
 =?utf-8?B?UE5LVER0cHhBM1NyZGRlcWt2b3BhaFJzcTA0Uy9LVFV3Ri9IaTJaQjlmTFE3?=
 =?utf-8?B?U3Q4UjlPbGV0WXJ5aDFDSzZqSWVBa1FNWXFxVDFQWGd6VGlieGpiM3A4VTd2?=
 =?utf-8?B?WGhYay9CVjZpRXNzbzB1cmN5Tk1vM3poMnlGWUV4YzREZGVhRnhHck92bEtM?=
 =?utf-8?B?RDFKNllMWXRhcy9kbklPVTJoTVdodnlYTXlsT3RBYVhGaitXVDAzSzRSVTMz?=
 =?utf-8?B?YzVpNVlPWlErQURoaHhEVzVnbklBTTFnSlJtNDhMaExtOFpGb0FwMHRNMjFZ?=
 =?utf-8?B?a1VPeVVaVVM3NCs2TERQRFJyM3JSVG12clJ1Q25NU1YreU4rNjR0WDYxSUIr?=
 =?utf-8?B?aFlQeUhQQm92c2F2ckFpZ1l0ZjJGZXlNR29tSk1KMWxJMlV3SGx4c0Z4bjZN?=
 =?utf-8?B?M2lTVHdEUFBNS3N5bnZhMy9hYnZWYWFvZUpWWUhMRGtTWkR2eUdNRCt5bjFZ?=
 =?utf-8?B?VnROKzNOdG1vaURWQWJQaC8zbFBFV0R2bHEwZURlRm1Gc2pMRWtIbFdyNHZv?=
 =?utf-8?B?K3REcnFqWHhyUjR3T3p1M0JxbS9NTkQwVzlrenVYaTIrWmxMYldFV1J2cHBl?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7742d36-d7ac-4280-c916-08ddefe79ad8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:26:57.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSU73hZY/mVSR/GEOuWOYM9PiAY1kcbxpqn0qSSBDeYmYrN0Jo3Zdpt6C6pr6/PlSZ53wFMcNHKQDxE/iNz1b9gaFy4AGMLD1d7Z3QauVZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9297
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource.  The per L3
> domain resctrl fs monitoring state is maintained in the generically
> named struct rdt_mon_domain while the per L3 domain architecture
> specific monitoring state is maintained in the generically named struct
> rdt_hw_mon_domain.
> 
> Upcoming telemetry event monitoring will be tied to another resource
> and requires new domain structures.
> 
> Rename the L3 resource specific domain data structures to include
> "l3_" in their names to avoid confusion between the different
> resource specific domain structures:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
