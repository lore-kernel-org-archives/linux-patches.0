Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D4020C480
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749508833; cv=fail; b=IRl6HWmN9UX5oDSrYYD9bfGkZixD0rjAVMqhmHTifr6mC5qcqcqTbk7r9aGCnQj+Wyv3OkNlj/4eihKrCaBpJ51nwCvi6Ht4GEZe2KMmFFeypWnHODmI6qHRS/I+tb9hKa4IRIGduNC8y11qG10P5LvTa5vIZHxGSOivqqScJzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749508833; c=relaxed/simple;
	bh=BDmL9yWTiZoaCr4MoIdgi30U20uDKs6vZHzqiC2IqGY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SPs2w5DIjg9MOMLtcHxfQwtGfPyW0lMP0YlbSoHpC5ibPTneP9MBtOHuwFIfXuJgbHTBEus0wm4MgfRDOFrxuiVjMnj4qt0UTlQtrioIn5JzoEXwu6TJPJ+l+cEF9UbxF/ZFCMP060M2Qk9fQPjO9T+tZ8gA+2poW6JzjK1/z5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RxpMbmlG; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RxpMbmlG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749508830; x=1781044830;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BDmL9yWTiZoaCr4MoIdgi30U20uDKs6vZHzqiC2IqGY=;
  b=RxpMbmlGFtYMJUgIi9bBYd6UboOq0GgHBUEdSI5C5aTm/QRb+YDRdTlv
   vpKZWQrACi4K/Fah8EdFO5CORgzyXnVCGpIPKobUc65xtFgkxyrUmHUqo
   tajAyNGdSay5I+vZuZKqawL1P+EU1RU/CrgI2uMiB/1EtD4D9zPGQiDQ5
   IHiocB1zeEzhNdppxtSYCdrwyaey1X/jTgkEqG0GpYgRn/PxjbDMsNglm
   YF1/ZjezgGOw5qPqqXTSSi/T6bycoGMmNd7ekXTVfgGju+rFYQTLFCkFl
   8rG20IwYFvbIwCE3IkxjvZCWSelfK9GMZH0mDn/4e/uXQFoONGA1La3vR
   w==;
X-CSE-ConnectionGUID: PcWA1uXTTjal5QUtrp2PFg==
X-CSE-MsgGUID: DrFX8vF8SoimPX58bzBW7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="55406660"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="55406660"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 15:40:30 -0700
X-CSE-ConnectionGUID: ue3eUlkdS8GvHo4+yOvsKQ==
X-CSE-MsgGUID: k5MTvjBtQ6KondByxGI+6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="146625944"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 15:40:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 15:40:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 15:40:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.76) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 9 Jun 2025 15:40:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7WPaunAenmhpq2/QXGy2pVwPKwxj6Hj4lsZ14T4umqV+CF4hTh05cwuecNibHIFARuHTjnzktdbwnNqFP5FaTJVUyEMb3SCIuUcuoES+80mUeboV2ZkHtgUpuMPbv51Blud7gLH3bcxP1Vto0etsezG9bqjYR65Uz/dm5EgJ0n321CVsOWIaRJ9Xog4E8vcXrRcPfpq+zFoAPg4DMR40PTEtPGXjJU0igDlQ2Cv5CQofhVIlViIMlEnNXYcQ4+X9vKGTuy38TrgyNFEEuvxR7BT1b3+jJjVp5TBRUijx+LiG4GNroYn3BLUxQNtEScmLJMNmPJHsiHI1s0tKYBHOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Umq+BH+QW87RapmSbsxm8TKZJWGoEQNAxOdFvCi6eQo=;
 b=RRKQQQ1XFmBMcyAcJrZQgsXLya/gxR3x/oiragDwSZjE67W+ocrdUxdlG4LxjJ0kB6wB8eeeunhQGpgQNvTfdq2S5rVQFNBvT5GzUpCoHGeVAlKhApB2ej83KkcZ5F7E0UmUqQPbqvGIvXnTHbmAe9X7NpK+6w8ATXFzq+vYnkSUORvbS+Db2X0n8aIXjMpBVXdIEVd9fR4ssacDyURyJeSzbC3ayt7GF8Ux9LXcy5tfEpc363bft4lLotll63TNlK7JVkYK01BCU+V2DA6AJncjFeK84MWhWa5lykNkP4ZpTFhPzM93uNRq2dil1q1p4aBFTYLWnrZer5ytK1yKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7081.namprd11.prod.outlook.com (2603:10b6:930:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.39; Mon, 9 Jun
 2025 22:39:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Mon, 9 Jun 2025
 22:39:45 +0000
Message-ID: <fb2396c1-3799-4d45-ae24-ce7e6f0d42e2@intel.com>
Date: Mon, 9 Jun 2025 15:39:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
 <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
 <aEMlznLgnn6bK9lo@agluck-desk3>
 <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>
 <aEcsxjWroliWf3G0@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aEcsxjWroliWf3G0@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0052.namprd17.prod.outlook.com
 (2603:10b6:a03:167::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: 0662544c-b563-4fc8-3a58-08dda7a68887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?akMvUG91TTR3Zit0RjU4Q1pxTHRoQWdGOGNBVjRqR0kyMXNNYUJLaU42K0lt?=
 =?utf-8?B?WmlWbU9RbmlnZ1c1UWdJZzlXK0gxS3JPL1hPTWZMdTB4OTVnd3BtelhvUUhq?=
 =?utf-8?B?NVZkQVZSVGNUS3VicVRnckFOYnFFa0twa1hqNk9lbEtPaWdhQTA4NUZEZkRu?=
 =?utf-8?B?ZUttVWpQVFlnR0VYaitPMEZTamI2YUNBYS9YUVNxaWpOTDhMUzlpSlpGckFW?=
 =?utf-8?B?d2ZOaHJxcWpiZ01EZ1NJcEd0NC9RRjRTbndkWFlyYkNPNEhMZWdFZ2JXaGFw?=
 =?utf-8?B?Mm9BODV5WWFBb2VzcW5hZzJwdTNaZDA0L3c0bUR4Z1lzTGpxRG9MR1o0anJt?=
 =?utf-8?B?RXg2RlZsV0xRSWYySE4vWDBQWUE4WC9jejZwa09CSlFjcFBlM0wvS2k0RUJw?=
 =?utf-8?B?elF6SjYxaGk4Rm1oK1psR1hoN0hzeXUvWUFETWFCS1FQN2hURGJvdWNoTUs2?=
 =?utf-8?B?bjR0c1BlaS9XcDVhbUhQMkQrTW41SGE4ZStNUnJsRHBSQSsyaUlRSENpc0Ry?=
 =?utf-8?B?Mkt6ZGZJdWtOM0pkMElLMDhONzdJQTJROTMrMVNuUktPK3RVekNyTTVQbEZr?=
 =?utf-8?B?T1NoOUpSTVBXUEdBOGpKdDlQWnd0OUJJUXRZMWE0QklnVDRqbjFTU3VPbWVo?=
 =?utf-8?B?QU9YRmpzbHNkbDB5dTF0cGt4aE4wcWVYYlJ0K3BUM0RvSzNhQmdNRUF5K09t?=
 =?utf-8?B?SDhlRFg1U1FqNGt3VXBaUXJuV0o3MWN2akpMQU5DWlExbmZqOHNsdFdPRXpj?=
 =?utf-8?B?bWZnOU9XdEg0VjZicS84NjJxRGlMcGoydHp4aTZMcnkyRHZmajFjUERwUE9Z?=
 =?utf-8?B?WU1CaVFVWFhKRU5mbXdjVFc4anlqdFVWdjRQNHpObVBMN2NjcEN1eXVkdXFH?=
 =?utf-8?B?UVJxYmd3M1hXZ29VR01ROEUzeTNSR0hxN3BpSXBnTjNUdllYcUJWcFMra2Vn?=
 =?utf-8?B?UG5jdENWbTJ2elUvL2QwQ0w3OTQzT1F0aWtYdm4zejRNRlMrUGdhSkdZS2dl?=
 =?utf-8?B?dEcyYWZTWTgza1lsVTVEMWUrMDFpc0JuRUNaK2g5U1hnK2J1SHc3YkFmVS80?=
 =?utf-8?B?eDNJN2p1d2MvRTJyTW5kOVZpaytoQ1dzTTdWMFBiV21INmE5aG1EQTMvejMv?=
 =?utf-8?B?M0FNdC9UV1czM1JUaVhvb1NWZFhleGU5OHBLMFhNMk4waHBKMEJOQ0pHaDBF?=
 =?utf-8?B?bm5KdmRMSklGSlprTGlnN2dPd3Y4ZS9VQy9jV0U5TUY0cFpTTkk3Qkszb3Zv?=
 =?utf-8?B?MC91L1E3SEJrS1AyQWVFb1Q5bVJFVEJSbDg1Tk82dk41OVJmOEFSVEorUnlw?=
 =?utf-8?B?LzNtZGhaUGtrYTdqdUpJcGs3Z3B0dmpFdWM4YXAvWmlXTGlmeVR0WHk5TEEy?=
 =?utf-8?B?WjJiMkRJWDVUbE52d05pYjhuaGFQY0RXOEdlSUxKazlpSUtnNEJSbkRJbkNB?=
 =?utf-8?B?a0h6NGtPaHRRMEdwWi9DTDI2eXd4dGJDVERFRFQ0Y3VZL3Y5Z3ZLR3RkZmJZ?=
 =?utf-8?B?ODhnTVRaTTgrZnk3bk16WGdaYkE5VHpOeGNGV28vMlRwNC9ZVFJNMWoraGZr?=
 =?utf-8?B?VDVVbWdScHp6UHNieVdnUERBTWlHUVBpRWZaMUZaK0lyZE1XbCsvaDVvWDR6?=
 =?utf-8?B?QjBERnN3cFZ6bEg4eUpKK0JUMFk0cFBVRlp3RW5FTzllUVh6bjNFU01rZDFl?=
 =?utf-8?B?QjlKT0F1N1JwSGR4NDgvZlRESzZWdXRUMHoyRUt4dzRJNi9RRFE1L05idFFs?=
 =?utf-8?B?eGNOeUlHY3FBWHByLzlIV2xVeW4vdDJJYVlmQ1RZelorbHRDc01rZXNDeTAz?=
 =?utf-8?B?UnhSYUhzUzNoOHJiVTNUazJMdG44NEJSQ3I1L0tsNzhvNlNhZTlsL0FMQ1Vx?=
 =?utf-8?B?MElkcTY2b3dGaDI4SnFJMmd3YkNsVTU1R1NhV1FNWXVZdHZhVnBZZmU3QzdH?=
 =?utf-8?Q?unaymYqnMNI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFdFcGZVNlFOY05TZm1IeERuUU1RSGEvY2lsS2w3OVVQbjl1TVBoNkdCaWFV?=
 =?utf-8?B?OEUzWWdMK3ZWMFZkNWp4M2N2YXk4OFh0VmFMc0hrK0JqenZ5R3IrRjZzOGtE?=
 =?utf-8?B?TGkzTnBtbUlxTFZsMmloY29DTUI4VUYzOU5EVS9EaTYvSDVqcFYwR2NtS2pa?=
 =?utf-8?B?eEc3RkwvdE9JUkdiSHdjaTZ6N3kxVGtFWFNZb05rS1Jnd1NnMzA0eWxYMTZi?=
 =?utf-8?B?dGtGbGhjNHBDK1NjZm9WalRDRit0a2hIUXpBQ1RsNXJISlVMUWZ2d1VHaUli?=
 =?utf-8?B?SlNrd0FYNm1YZDhnY2pVV2RQdmJYb3lmcUxyZHpZTEZDQXFOQkxwcVJCSWpW?=
 =?utf-8?B?eDk3ODBSaC8rVlZEMkUwR2hyeTNROHJEclRJK2JST294d2d1ZUlCbjRuVy8z?=
 =?utf-8?B?b0xWcVZ6c2wvdndoUVNBS2hXdzJmU2pqRnFzNDczb29jMS8xajFTMDRES1ox?=
 =?utf-8?B?NE1NV1AxZlhMWU5oLzcyVmI1SHpiVTBhQWFibHIwYlZFbXlabkF1SEU3Nmcx?=
 =?utf-8?B?TElzUmdpMml2NFlpVTd1QmNmQ0RjYjZ6eng4ZkMxVkV3dXk3cjZIL2s0eVRa?=
 =?utf-8?B?c1RnSjh2azZIL0Z0RlN1OWhJRFVEUFVlb3pHS1ZTczk4VEI1djBlbkYwVC9G?=
 =?utf-8?B?VVg5L3VSOWdDd01hUHcxVFQ0UWRFV0RNQzZkcml2OGdtb01YMitLOTFwUi9W?=
 =?utf-8?B?ZXB0STBqT1N6blpjMjhIWmsyT3pDWStXcmd5ZnlPdW5WbjVEQ05tdjRlckZv?=
 =?utf-8?B?dlVQN3JTZVFxYTRobGhBR0lwY25PZHVsT0lGS2FEcCtrNTZRdWJRbzRhQkJh?=
 =?utf-8?B?VFkrWXIwQ3ZRZkQ5M0FrWVcrTkw0bkF4aDRUcnpTN1AxODdLcHpJcHgzN0E5?=
 =?utf-8?B?YlhLMXlvN2x5NEZKbnM4MTdxY3pzVlBpMmk2MkNSWHZUU1RMcTEzaFUzcGNB?=
 =?utf-8?B?bkdhaGN2Sy93L05sdTR6UzZ5TXc1RTExNzRLUGcxTFV3cHN4bXYxdGFSS0pE?=
 =?utf-8?B?cjZCM0ZLS0ZlTnJOMngwV0ZDeHRQSFhZdVBkUWt1KzI0TjBFNmNIRE5yTTgz?=
 =?utf-8?B?S0hzcDI3ZjJ3VHcxYkJ3Rm5FdXhRTW9UU0tlT0IrTnBvTlpPWDRVY0ZoQ0I2?=
 =?utf-8?B?THluNXAwb21UYkRWQ0piSC8xbGR1WkMrekVnbnJPZlRNUXovaXZ0RmV3TWsr?=
 =?utf-8?B?S2hieEN5aE9XQ085WTVEZ0FWMDlBZlNlTmtZb3BmUFNwR0JkbS9zUkpYeUlU?=
 =?utf-8?B?bUMzSWY3WlFWUit2MlQ4RWFDOVF2Y3VwUGhuRVpveHlaVXZHdm9kNWZYUjBi?=
 =?utf-8?B?ZklEWEFPbGpTOG1Gd0gvZmF0cGVFTG9ZamJtV2djN3Jad3dPNHZBWHZseWVH?=
 =?utf-8?B?TWMrOGZvZ1RGRHhDV1JidjcwMnNJL1ZBTEJNMHFHQktodUhhNUl2QkpIbzhy?=
 =?utf-8?B?ZitKU1NYYWFMT3ZOeEZXMGlqVCt6S0ZYUGZ5RW83d3dDMDJpL3cvaG93T3dF?=
 =?utf-8?B?SEZ2Q2haeHBEdzJJUHNCUHlmVXIzakQvZ2owVm5lQjlaVTNwclFKVG0ySGQ3?=
 =?utf-8?B?VUtwTmN6cjV5aWNWaFlRY2hNTHppMndCRlVocG9MdGlvdWJyNGlvWm9MWnd4?=
 =?utf-8?B?aDVVdjJZRmZpUXQxRTRuMmNGclc2SEd1b0x0bW41VGU1WThXWnViR2UrcUlH?=
 =?utf-8?B?eHpHWGNSSGxMSVZidEtXS2dzcE9iV1gza3BBV3JQQVdoNE9Jb3pIakRCK1pI?=
 =?utf-8?B?RnhEUVFJS2xiOEZadHRGcWpuZ2laemhJcTBQbUVEL2s5Zk5HM2xRUm9oUG1n?=
 =?utf-8?B?RXNra2ZYaW5IVEZNRUI3MXUrdkZLSUhGdHZLRDA2cHA0bHIxZlVWc3ZROGhI?=
 =?utf-8?B?N1BWYWpTTWxUQThTSnZVTU9hTnl2azl3d0VkVmIwQkhpVnBpOWFZeFh5ZjV5?=
 =?utf-8?B?WUFKeG5oTmM4aW85V25mWHA5NzlkaEsvd2dsMEltanRrcDlybzBzQU9wS0Fp?=
 =?utf-8?B?WVVZVkxDZ2ljN2lOTXlHM3NsWllLUDZaQzhBem5rSTZzNlhGS0pqSDc4TXRa?=
 =?utf-8?B?L3ZOaXFDTHV1VW5Ccm1FcHBDYjkwSzErWWRDaDR5WFREZDJTNVFoaHZldVI0?=
 =?utf-8?B?cHlaL28zWENSbFdCelJScEluVTVtRk1hOUI0RFRiREYxNDlEYWs2VUFkSDlp?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0662544c-b563-4fc8-3a58-08dda7a68887
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 22:39:45.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfWULrDCG8/DfZwUsqIeTnq+yvKMCUs4u9kZMp8t89nM39T8cjodmK+lFRBNrVVaiAwAA40Y3wpGhhb/lQkcv8sL76e1pzeY/WJ7Lx4snqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7081
X-OriginatorOrg: intel.com

Tony,

On 6/9/25 11:49 AM, Luck, Tony wrote:
> On Fri, Jun 06, 2025 at 02:14:56PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 6/6/25 10:30 AM, Luck, Tony wrote:
>>> On Fri, Jun 06, 2025 at 09:26:06AM -0700, Reinette Chatre wrote:
>>>> With /sys/kernel/debug/resctrl potentially mirroring /sys/fs/resctrl to
>>>> support various debugging scenarios there may later be resource level
>>>> debugging for which a "/sys/kernel/debug/resctrl/info/<resource>/<debugfile>" can
>>>> be used. Considering this it looks to me as though one possible boundary could
>>>> be to isolate arch specific debug to, for example, a new directory named
>>>> "/sys/kernel/debug/resctrl/info/arch_debug_name_tbd/". By placing the
>>>> arch debug in a sub-directory named "info" it avoids collision with resource
>>>> group names with naming that also avoids collision with resource names since
>>>> all these names are controlled by resctrl fs. 
>>>
>>>
>>> That seems like a good path. PoC patch below. Note that I put the dentry
>>> for the debug info directory into struct rdt_resource. So no call from
>>> architecture to file system code needed to access.
>>
>> ok, reading between the lines there is now a switch to per-resource
>> requirement, which fits with the use.
>>
>>>
>>> Directory layout looks like this:
>>>
>>> # tree /sys/kernel/debug/resctrl/
>>> /sys/kernel/debug/resctrl/
>>> └── info
>>>     ├── L2
>>>     ├── L3
>>>     ├── MB
>>>     └── SMBA
>>>
>>
>> This looks like something that needs to be owned and managed by
>> resctrl fs (more below).
>>
>>> 6 directories, 0 files
>>>
>>> -Tony
>>>
>>> ---
>>>
>>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>>> index 5e28e81b35f6..78dd0f8f7ad8 100644
>>> --- a/include/linux/resctrl.h
>>> +++ b/include/linux/resctrl.h
>>> @@ -281,6 +281,7 @@ enum resctrl_schema_fmt {
>>>   * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
>>>   *			monitoring events can be configured.
>>>   * @cdp_capable:	Is the CDP feature available on this resource
>>> + * @arch_debug_info:	Debugfs info directory for architecture use
>>>   */
>>>  struct rdt_resource {
>>>  	int			rid;
>>> @@ -297,6 +298,7 @@ struct rdt_resource {
>>>  	enum resctrl_schema_fmt	schema_fmt;
>>>  	unsigned int		mbm_cfg_mask;
>>>  	bool			cdp_capable;
>>> +	struct dentry		*arch_debug_info;
>>>  };
>>
>> ok ... but maybe not quite exactly (more below)
> 
> Would have been useful with the "always create directories" approach.
> As you point out below the name is problematic. Would need separate
> entries for control and monitor resources like RDT_RESOURCE_L3.
> 
> I don't think it is useful in the "only make directories when requested
> by architecture" mode.
> 
>>>  
>>>  /*
>>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>>> index ed4fc45da346..48c587201fb6 100644
>>> --- a/fs/resctrl/rdtgroup.c
>>> +++ b/fs/resctrl/rdtgroup.c
>>> @@ -4274,6 +4274,8 @@ void resctrl_offline_cpu(unsigned int cpu)
>>>   */
>>>  int resctrl_init(void)
>>>  {
>>> +	struct dentry *debuginfodir;
>>> +	struct rdt_resource *r;
>>>  	int ret = 0;
>>>  
>>>  	seq_buf_init(&last_cmd_status, last_cmd_status_buf,
>>> @@ -4320,6 +4322,12 @@ int resctrl_init(void)
>>>  	 */
>>>  	debugfs_resctrl = debugfs_create_dir("resctrl", NULL);
>>>  
>>> +	/* Create debug info directories for each resource */
>>> +	debuginfodir = debugfs_create_dir("info", debugfs_resctrl);
>>> +
>>> +	for_each_rdt_resource(r)
>>> +		r->arch_debug_info = debugfs_create_dir(r->name, debuginfodir);
>>
>> This ignores (*) several of the boundaries my response aimed to establish. 
>>
>> Here are some red flags:
>> - This creates the resource named directory and hands off that pointer to the
>>   arch. As I mentioned the arch should not have control over resctrl's debugfs.
>>   I believe this is the type of information that should be in control of resctrl fs
>>   since, as I mentioned, resctrl fs may need to add debugging that mirrors /sys/fs/resctrl. 
>> - Blindly creating these directories (a) without the resource even existing on the
>>   system, and (b) without being used/requested by the architecture does not create a good
>>   interface in my opinion. User space will see a bunch of empty directories
>>   associated with resources that are not present on the system.
>> - The directories created do not even match /sys/fs/resctrl/info when it comes
>>   to the resources. Note that the directories within /sys/fs/resctrl/info are created
>>   from the schema for control resources and appends _MON to monitor resources. Like
>>   I mentioned in my earlier response there should ideally be space for a future
>>   resctrl fs extension to mirror layout of /sys/fs/resctrl for resctrl fs debug
>>   in debugfs. This solution ignores all of that.
>>   
>> I still think that the architecture should request the debugfs directory from resctrl fs.
>> This avoids resctrl fs needing to create directories/files that are never used and
>> does not present user space with an empty tree. Considering that the new PERF_PKG
>> resource may not come online until resctrl mount this should be something that can be
>> called at any time.
>>
>> One possibility, that supports intended use while keeping the door open to support
>> future resctrl fs use of the debugfs, could be  a new resctrl fs function,
>> for example resctrl_create_mon_resource_debugfs(struct rdt_resource *r), that will initialize
>> rdt_resource::arch_debug_info(*) to point to the dentry of newly created
>> /sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON/arch_debug_name_TBD *if*
>> the associated resource is capable of monitoring ... or do you think an architecture
>> may want to add debugging information before a resource is discovered/enabled?
>> If doing this then rdt_resource::arch_debug_info is no longer appropriate since it needs
>> to be specific to the monitoring resource. Perhaps then rdt_resource::arch_mon_debugfs
>> that would eventually live in [1]?
>>
>> This is feeling rushed and I am sharing some top of mind ideas. I will give this
>> more thought.
>>
>> Reinette
>>
>> [1] https://lore.kernel.org/lkml/cb8425c73f57280b0b4f22e089b2912eede42f7a.1747349530.git.babu.moger@amd.com/
>>
>> (*) I have now asked several times to stop ignoring feedback. This should not even
>>     be necessary in the first place. I do not require you to agree with me and I do not claim
>>     to always be right, please just stop ignoring feedback. The way forward I plan to ignore
>>     messages that ignores feedback.
> 
> So here's a second PoC. Takes into account all of the points you make
> above with the following adjustments:
> 
> 1) Not adding the rdt_resource::arch_mon_debugfs field.  Just returning
> the "struct dentry *" looks to be adequate for existing use case.
> 
> Having the pointer in "struct resource" would be useful if some future
> use case needed to access the debugfs locations from calls to
> architecture code that pass in the rdt_resource pointer. Could be
> added if ever needed.
> 
> 2) I can't envision a need for debugfs entries for resources
> pre-discovery, or when not enabled. So keep things simple for
> now.
> 
> 3) I think the function name resctrl_debugfs_mon_info_mkdir() is a bit
> more descriptive (it is making a directory and we usually have such
> functions include "mkdir" in the name).
> 
> -Tony
> 
> ---
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 8bec8f766b01..771e69c0c5c1 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -564,6 +564,12 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
>  extern unsigned int resctrl_rmid_realloc_threshold;
>  extern unsigned int resctrl_rmid_realloc_limit;
>  
> +/**
> + * resctrl_debugfs_mon_info_mkdir() - Create a debugfs info directory.
> + * @r:	Resource (must be mon_capable).
> + */
> +struct dentry *resctrl_debugfs_mon_info_mkdir(struct rdt_resource *r);
> +
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 8d094a3acf2f..0f11b8d0ce0b 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4344,6 +4344,22 @@ int resctrl_init(void)
>  	return ret;
>  }
>  
> +struct dentry *resctrl_debugfs_mon_info_mkdir(struct rdt_resource *r)
> +{
> +	static struct dentry *debugfs_resctrl_info;
> +	char name[32];
> +
> +	if (!r->mon_capable)
> +		return NULL;
> +
> +	if (!debugfs_resctrl_info)
> +		debugfs_resctrl_info = debugfs_create_dir("info", debugfs_resctrl);
> +
> +	sprintf(name, "%s_MON", r->name);
> +
> +	return debugfs_create_dir(name, debugfs_resctrl_info);
> +}
> +
>  static bool resctrl_online_domains_exist(void)
>  {
>  	struct rdt_resource *r;


Why do you keep insisting without motivation on handing control of what
should be resctrl fs managed directories to architecture? Twice have I suggested
that an arch private directory be created for the arch debugfs and every
time you create a patch without motivation where arch gets control of what
should be resctrl fs managed. Again, if my suggestions are flawed it is an
opportunity for a teaching moment, never should be ignored. I highligted that
this is not ideal in the message you are responding to. I'm done. 

Reinette
