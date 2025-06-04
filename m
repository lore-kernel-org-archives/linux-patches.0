Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E987C238152
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 04:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749010277; cv=fail; b=cAzCVi6kCK0RbX+bjRPyVOprQIs+fYqJOcu1kNfwHYHAozLtWL4mghrcOdc2tabjUeC6v6rmYxyLual7s89DbcEMLFA/3hUSD+9io1rqO4GIwPVDNO2jsPH31eNWIFhUQE2L01uWYsvmwp1giRO+0AQN3/lnf4E0cTptirZDOWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749010277; c=relaxed/simple;
	bh=3xZDRi6X0ff11tXYFaRZVed2oh1400/oQMgnXAsxGTI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qJv2KOAIwpfmqQ8RwC2ggHARcbThSLIPY+BzcrSzeS/Bs9IQbk5wqrZMBhx1FN7bXpMxPD8MUuCO8F4wJ2wALiqcWGNvu/T7kZapUSJj/lxA/E5ZpaWFImMMWu4xCdjLF99RNu/KrS5Odd+1Szt0ESeHKHDcVhjzhW0YdZjuFPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T6/enkyt; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T6/enkyt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749010276; x=1780546276;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3xZDRi6X0ff11tXYFaRZVed2oh1400/oQMgnXAsxGTI=;
  b=T6/enkyt2gjzokooVdGvYqZ5XLC3zwSbNPrgE4Sfy+LgBSTnQaMpexYe
   OoF3frtbeq/piZJIdBUqnK7RqXVxfUt24OqfaCtNKHqDCFNnboMnAqoGE
   tDs9QHuhlUWFhczjfNO1CWJznNXfiTNcbfKQGjhlMRXAmstRSN/CYnikJ
   4LCpaZ1aP0LqEOJlSDRD00dQG7Q2bjEhs2tq/bRYuiM0Yxgr6GvEYSFaa
   n3mDSdOG9E3L4JEXqP3nBZUUmTvfOFjlba849oucNFwM0NgAroWzPPQV5
   bDNYzTiBq1MRBFtOP8DJwbXsU7znv6jm90Ba+0nw/9NfFOfFLJFlDGeFq
   A==;
X-CSE-ConnectionGUID: ZtXXBej6Qfqepdhekkz1EA==
X-CSE-MsgGUID: ZqpuOqSbSfKZZUxaidUtGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="62465889"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="62465889"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:11:16 -0700
X-CSE-ConnectionGUID: SEcI3IHYQVed/ryYRpQTnQ==
X-CSE-MsgGUID: HhOfnY0BRZ+g0QvVt0Rrog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="144943754"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:11:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:11:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 21:11:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.83)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 21:11:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eZEfEpTtjwyWOZG9jPpXzHsvTW7lkyJcLLBDGrcq24zY7CoJQZOXhYu7RNHfP0nYPeenNkpoSkLnS6YwVWziBsBtqrQynE0a8LhF2J39fQouMDBtnFYW2xXWbgmDM5s3E38aOL5oE+7Wqy5xKSFnk/S064EiJZSku/RxtXRiSiABO/QpoWQ05M0Xt+XWhXkUyK4fNJ/FpNEVZzxYeECe0LYRjmiffyqdpSLXbVmYLTkh08lHOg/RhZeU1tslgvmNeVcAvhcsnoKDsOVnFeq87Jxwaf42Qwchvjre+rqhjpooxkIw15jm88hFCUILS7wXNZtNAJfLuRRKDTMFI7JSmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5XCdz2mKm+3hbWHFCj+9jWxvW2fY1hgPb8S56MB/GM=;
 b=LfB/1SeHr3C+K1EbV0l7YmXNL5PBW7Is5Xl+FM3f2BalHLpOsUb1DaTPfS5GDsy5XWN2uF2FmQz8WFHYHvo84Qq6BfOmHe3VCfARqf4rCNcwyqcCqc4RbuaednV/DpUw8PKcWgN6LQTuuW3aIMUXRr06U1i28/cF1K+n0tjdZBtXtJvJkekMNJD+aKNcqDlfK1KU45eO6gp5J3JwX4Ourk3DlOrtNXpKBF4o/kYneftQ4iDuI6pOawCLUOaqNCIh2jRB/kleaMjfzu5lRtJypQLiTwtdAMbSBSDQHa6u/TmfDCykbUV4MT3i/X5lViem2+I/UCNFQyGR39WoLCsDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Wed, 4 Jun 2025 04:10:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 04:10:44 +0000
Message-ID: <47769188-cbe4-4008-8046-b4ca7d9f805b@intel.com>
Date: Tue, 3 Jun 2025 21:10:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/29] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-25-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250521225049.132551-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: b88eb50f-edda-4b77-a720-08dda31dc712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RGhHR0E2UHl5YTFrSjFWTlNhWWRzSHBoUHBvelR3YVJiOFd0ckpOdm1jMmZZ?=
 =?utf-8?B?UngwdkJPOU5nVE1kcmJ1cjI3N3p0VnFHdi9oNGRaeU43Y0x2NnNaY3RodXVW?=
 =?utf-8?B?NEdOM0RUK01BNWg1V2pyN1VYd3lrSTZDSnorT0NJN1gwTjljNG83MFF0ZGFT?=
 =?utf-8?B?VDZuQ0VIb05rNXdXckYwUlBOUjE2MzBnaXBNUE8xVHRtR3ByU3VlUFBRM2pn?=
 =?utf-8?B?MkJSQk0wYW5GYzVxZWFsY21qeE55ek1JdjNmNUtqczUvbVBMWUt1eVZSSTZj?=
 =?utf-8?B?OFdWYlFtakdnbGt3WFVtZUVLOFRFRXhUQ3dQM1Y5eUhMZ2lkT1JXcFN5SmdW?=
 =?utf-8?B?MHZxa1V1UWpvMThFcEVPOG0wQXQ0aTkvL1Nyc3JGT0lPRy9EZGUvS09WYWM3?=
 =?utf-8?B?bmM4SVdpRW9VRmJhWVErS3RXa3R1ZjJLVy9QS081WXQyU1JwODFhVTQ4WmhC?=
 =?utf-8?B?ck5MOTFDLyt1VnRILzdBQytHL2NZVE9xVzBHaHo1UGVncmZNemEvMWZ1Umx0?=
 =?utf-8?B?dVJhSi85ZE9HcHB5RG8wWXR5MFZ5TjhZTDR3TjRjN1hTbmxJQ3ZkMDZXaHBp?=
 =?utf-8?B?YjlKQnk0NXFCNDdXOXYwejZyNHJQNHFVcXEybkxqdjJDRmNib1J4bW9LMWJD?=
 =?utf-8?B?YVppYTROQVNSbks3OVhHRm9TUTNMUHpEVEpUWkF3M1d0UitSKzNlYnhXSE0x?=
 =?utf-8?B?bS9HMnhnRW1vUEl3UUVHOHpSaDh4UzNnTVdvZDhBM3lEL2c0cmFOcXNOR0ZO?=
 =?utf-8?B?NjNJbVVxWDI5cUZOMkdHcEIycFR1UFVwVHA5ZEltamhWTE80NGszYWxreGpP?=
 =?utf-8?B?d3Y5WGJWV0hnUm0yMSt4NW1yMDlRRGxjR2pIeDN1ZHRHc1U0b3VGUWc4djBC?=
 =?utf-8?B?SjQ3S1pzZ0Z0aUIzTzFRM3pUVTJRRkpYWXNoTk1hRDZiaVlOU3B1V2ZDRUMy?=
 =?utf-8?B?ZVYyejVFV3dKdnJWWTN4ejV4czNud1VzKzBVQXFpeFJHZkx4b0RNcUNubkkr?=
 =?utf-8?B?TWFldVV4QklDZW1XNFVkM2RZS2ZIYjcrT096ZDNsdDNqSlcvbldHV3JwYVov?=
 =?utf-8?B?Ynk5b3dNbWU4cVBzRXN4Zk9HdHJhSTFCTmdyWjNONWhxYjhyU1E3ZWZFS2Zt?=
 =?utf-8?B?QWozRjFKS2t3aHJZYytRbzdkNEdKalRaRDdSc3FnTkdWWEsvc0Q2aGFueU93?=
 =?utf-8?B?dC9EWkoxNSttUDN1RFAvMHNvQ2cwZmFoNnJpc1dlYmlBdXdlbnlKZk9FMHVu?=
 =?utf-8?B?d3ZPR3dpdGppYi9YdXhXTERPRkh3WUZFcmg3Tk15NWpaN0xBYTh1dWI5d0Rq?=
 =?utf-8?B?TGY2QUZnTWt6aWVuOUJxaVRLdTNrMUQwNmdKQXdGcU10alZYV01FTmxGY0V0?=
 =?utf-8?B?V0tmUGxsc0h0V0prRFQ3RVVBbldzQ0U4d3IzOXRJcTU3RHNEYzRSM1ZRQnFT?=
 =?utf-8?B?VnlDSXhtUS8valByeHhrbkR0amMwV20rdnhxZG1TQi8rRksrUVB1ZTl1KzZl?=
 =?utf-8?B?dWQwT3JWMHpCL3M0YVBwVzZ1RFEyYnpmYlBwT0VDWXB5My94RVR0Z3ZWdkF6?=
 =?utf-8?B?T2h5Q3Y5eWRTZ2dSZEE3dWlzQlBPZkhMNzRrVEJ4QnlYci9RNDM1U1ZDKzJD?=
 =?utf-8?B?dkpNdmdtSWIrMmVycnZyR1BMNHVZRjEzYUJwTXhzWkI0enBpSHltVWxWOWtK?=
 =?utf-8?B?ZGE2UVgwNEFTcUt5UEtDTUt0Y0VlY0ZsT3U5TTRPSjBnc2E3amwvVmZjV2U0?=
 =?utf-8?B?M2RUQnFMcTkzM2ZKeFNvMkZRODVBVkRmSXJHbXJjcTQ4NjRhdUxWcE0zUkhX?=
 =?utf-8?B?VktPT3JqMUxud1d4YmVTQnJPMDFlZzd4WnJhaUVpT3lLeTJCM3VlLzBHY2hQ?=
 =?utf-8?B?UVN1bFpUUHJhdTgrc3NFQWM0QitLRHFxTEYveVNuTTRYZU1wcU50S2xYSysz?=
 =?utf-8?B?VzdyL0d3R1lQVWZDZDd1U29NRnBQMUh5cWcwcU5lRFFFNDFNS0RHckFZRUJW?=
 =?utf-8?B?d3FXZU4rTVpBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlVaRERVVXhqRTcrWFQ3SnRHd0ErMmFGdVhTSFpSTkxmYUM2MythOGpZT2VG?=
 =?utf-8?B?SStWemh0SmhieGNZcUJlYTBXYWd4Umt0OEd1Rm9YTDdOaExzcGYwa3BaeENS?=
 =?utf-8?B?Vm0zdFBNdkFrQzdUdE00RHVjcXpadGc3VEpMODMwSVJOUDUxVkYzb2JyZU1u?=
 =?utf-8?B?V1I4c2F4dS9ydTkvcTM1K2JSczhiM1p4RFNCOW91VFR3emxmSnhmWHNMUkpv?=
 =?utf-8?B?TXFwR0pQSUlwWXFpM0VTVVRnTHEycmkyRis5U3A4MitwdkxTOEdSVVBud0RJ?=
 =?utf-8?B?ZFJTUGJQb1RiTkRyNnJmRFI5S0VqUlVEdzJQcEJ5clJkN3dYRnFvNm1KdDdE?=
 =?utf-8?B?OWcyTkNZUFpsYTBhSkk5OVJwQUtOc3pGcFJZQ0FtenE4aXh3QTkvUFhVcGND?=
 =?utf-8?B?UGo4YVZLazlwMFJHMVl0Ly9PWjgrOU1yVVh5ODhxaU12bDJaZWw5eXBLM0ZB?=
 =?utf-8?B?bXFzdGUxbDRZZVBHZzYxVGxZay8vdFlLWlB1a1VHNnBBYTlnS0JweDlLaWdp?=
 =?utf-8?B?VUEySjhQYmR4UGp5NVdGZDNHVzlyTUErNlBEM0JrQ0oyYnZEdGl1dTI1eHh3?=
 =?utf-8?B?Q2UzQ2lRaHdPeEFLM1QwbEtiMHhhYmZGbU1FcFB2cmd6T3RqaXZiUTZNWFA4?=
 =?utf-8?B?RldzZlFqTHNnRmRYQysrTVJ1MWFhWDlXSEhaRFpQbSsyTzUvVzdMRVFyeUFz?=
 =?utf-8?B?ZEpuWHl1aStGYklqMDFrc1VuTDdnb3hCMjQ2VXN2QTlmSDVsWFRwTnpWa3NN?=
 =?utf-8?B?YWVxVHNDcWg1d1RLRjdQZnBtV1pIZ3pYSThhMG5KUllNdEJhYUNva2RtTTV1?=
 =?utf-8?B?NUxNUGw0bFNmMDl0d2UrQ1hXbzRlVmxRbVV6aDY3RHo3eTRqSzJ3UUN2aDZv?=
 =?utf-8?B?SzdkclpWOFI2dkkyekErb2h6emptVVk2b2FobEdUYXowa2ZBR2V5NHJrQ1Mz?=
 =?utf-8?B?Mld3OVVrR25SR3haVllXekFCWUZZZkJsZ3JxcFhTRkFGOGU3QncwUUxRUXJN?=
 =?utf-8?B?Vk1Gb3N0Z01QZWMwQWU5WEJWYmpLaHNrQ2xWVDlPODk0OFVNbmtjLzNIOVk0?=
 =?utf-8?B?ZW5DaURxeDdjVkV0WVpnQUorMVBzNjhBOGtMTysvM2w3aUtuTHRkMFgrL1k3?=
 =?utf-8?B?dkVIeWNkbjNGRklad2p5RUhWUHVhYm5iVEZLSlR3K0NEd0JqbFRBb0lBNU1t?=
 =?utf-8?B?L1B5RTNzQ3RTbXl1YU5KRUdOaC9NTW1hZXlYcnQvdjErVFZPWjZ3NEFzQTZV?=
 =?utf-8?B?NGRQNyt1TE81bEdSYmhXYmM1ZTlLeGVGc3JaVEUwai9DTExmMmQyV2kvM09p?=
 =?utf-8?B?aERyVzFXWmJuakkxLzE4MWdsK3NwVk5aZW53OW1pZXJicXNob3JlTktvL0RE?=
 =?utf-8?B?dkpPTStLeGw5Q29JcTNWSjFnaE9MZFVrMTV2NzJnV3p2WllzWDljYVNkOXFk?=
 =?utf-8?B?Y2pMUWVWV1pWaHVsNFE1VW45OXAzN1Q0dW5HV3dNUG9xV2hVUFRXWGdJSHJS?=
 =?utf-8?B?WnVIRUlxdnVTSUkxelcxMjVXRTJSSStZbGY3TmRWS2NrMGg2bWl1Z25JV3Rq?=
 =?utf-8?B?SnhjTEhvaGpzMS9zVzdIZCtlZjRmZWJ1ajJHdkVHWXJaZkM4Y21OalMvMEtG?=
 =?utf-8?B?Z0JzUkhHMkFHTEYwdzJGeDBwR3BrUWg5NElSSEtKZWpyZzRteU15T3RxSlY4?=
 =?utf-8?B?ZHh2MEZLQytEa2hkejV6c2F3RUJ4bkhCZ3VCRzQxRVErdS9OY0haK1JqR25N?=
 =?utf-8?B?UnNUYWxHZDZyVmc1Sm1yclhSbENyT0F5emVtTFlQTFJPK1VUMklLT2tmeU9W?=
 =?utf-8?B?K0pOT2hoNnJqQ1lES2FGMGwvc1ZNNVJ2WGo0TktFMkdRV0pEam9RWWs0Uk5B?=
 =?utf-8?B?bDBjV2swVHVWYWZUNjgxbDJOdFgxcGNseTNCKzJkSmpUcmJDSDRjSm5ndXNn?=
 =?utf-8?B?Z29TRS9ZTHpMekxPamEwZFFBU0d4RFpxWEhVZVc0ZC9JVDNoV3ROdGcvVXJv?=
 =?utf-8?B?WU42VmI1MkoxakR4blpRWStKdTJXUUpHOHFqWnplRWNNRTZaUzdrUmlYUUhJ?=
 =?utf-8?B?QzI4aXIwSnY2NXNmYk9PSmhtWHJNRmJvRXpoZXBLY2tRUVB0UExhVUc5K2hq?=
 =?utf-8?B?YWZzR3RQMXJ3QXQyNkFKQnNRR1FyS1BQWWwxYmZGQ25pTjlzSnF0MHFOZE8r?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b88eb50f-edda-4b77-a720-08dda31dc712
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:10:44.7261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7AOtozcQm94GaTNXXS43ARDIoXJGHtfOmbxdrJq6VQr/QeXejHK5jKUNqZnmiZEvg5oZSEfxqujqELG/u0P67A+i0gSHSdi80sa5pzMYnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Users may want to force either of the telemetry features on
> (in the case where they are disabled due to erratum) or off
> (in the case that a limited number of RMIDs for a telemetry
> feature reduces the number of monitor groups that can be
> created.)
> 
> Unlike other options that are tied to X86_FEATURE_* flags,
> these must be queried by name. Add a function to do that.
> 
> Add checks for users who forced either feature off.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h        |  4 +++
>  arch/x86/kernel/cpu/resctrl/core.c            | 28 +++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c       |  6 ++++
>  4 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index d9fd26b95b34..4811bc812f0f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5988,7 +5988,7 @@
>  	rdt=		[HW,X86,RDT]
>  			Turn on/off individual RDT features. List is:
>  			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec.
> +			mba, smba, bmec, energy, perf.
>  			E.g. to turn on cmt and turn off mba use:
>  				rdt=cmt,!mba
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 42da0a222c7c..524f3c183900 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -167,6 +167,10 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +bool rdt_is_option_force_enabled(char *option);
> +
> +bool rdt_is_option_force_disabled(char *option);
> +
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index f07f5b58639a..b23309566500 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -797,6 +797,8 @@ enum {
>  	RDT_FLAG_MBA,
>  	RDT_FLAG_SMBA,
>  	RDT_FLAG_BMEC,
> +	RDT_FLAG_ENERGY,
> +	RDT_FLAG_PERF,
>  };
>  
>  #define RDT_OPT(idx, n, f)	\
> @@ -822,6 +824,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
>  	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
>  	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
>  	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
> +	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
> +	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
>  };
>  #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
>  
> @@ -871,6 +875,30 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +bool rdt_is_option_force_enabled(char *name)
> +{
> +	struct rdt_options *o;
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name))
> +			return o->force_on;
> +	}
> +
> +	return false;
> +}
> +
> +bool rdt_is_option_force_disabled(char *name)
> +{
> +	struct rdt_options *o;
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name))
> +			return o->force_off;
> +	}
> +
> +	return false;
> +}
> +
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
>  {
>  	if (!rdt_cpu_has(X86_FEATURE_BMEC))
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index be52c9302a80..c1fc85dbf0d8 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -51,6 +51,7 @@ struct pmt_event {
>  
>  /**
>   * struct event_group - All information about a group of telemetry events.
> + * @name:		Name for this group (used by boot rdt= option)
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
> @@ -62,6 +63,7 @@ struct pmt_event {
>   */
>  struct event_group {
>  	/* Data fields used by this code. */
> +	char				*name;
>  	struct pmt_feature_group	*pfg;
>  	struct mmio_info		**pkginfo;
>  
> @@ -77,6 +79,7 @@ struct event_group {
>   * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
>   */
>  static struct event_group energy_0x26696143 = {
> +	.name		= "energy",
>  	.guid		= 0x26696143,
>  	.mmio_size	= (576 * 2 + 3) * 8,
>  	.num_events	= 2,
> @@ -91,6 +94,7 @@ static struct event_group energy_0x26696143 = {
>   * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
>   */
>  static struct event_group perf_0x26557651 = {
> +	.name		= "perf",
>  	.guid		= 0x26557651,
>  	.mmio_size	= (576 * 7 + 3) * 8,
>  	.num_events	= 7,
> @@ -247,6 +251,8 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>  	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
>  		for (int i = 0; i < p->count; i++) {
>  			if ((*peg)->guid == p->regions[i].guid) {
> +				if (rdt_is_option_force_disabled((*peg)->name))
> +					return false;

I do not see how this supports the "erratum" use case claimed in the changelog.

resctrl supports the "erratum" use case for hardware features and how it
works is that resctrl forces a feature off and those features can be forced on by
a user via the rdt= parameter. The changelog claims that this supports the same.

Consider the scenario when resctrl forces a feature off because of erratum,
for example, by doing something like __check_quirks_intel():

	if (/* test if quirk applies */)
		set_rdt_options(!perf);

The above will set "force_off" for the "perf" feature and no matter if the
user boots with "rdt=perf, the above rdt_is_option_force_disabled() will
return true since it does not check "force_on" that is set via kernel parameter.
Thus it is not possible for user to enable a feature that is forced off
because of erratum.

Note how rdt_cpu_has() deals with this:
		if (o->force_off)
			ret = false;
		if (o->force_on)
			ret = true;

rdt_cpu_has() deals with the "erratum" use case by first checking for "force_off"
that will capture the disable due to erratum, but then allows that to be changed
by checking "force_on" next and change the setting.

>  				ret = configure_events(*peg, p);
>  				if (!ret) {
>  					(*peg)->pfg = no_free_ptr(p);

Reinette
