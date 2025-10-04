Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4D934BA3C
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759537572; cv=fail; b=qzr/eI1+Uvwd/R7pUpywSR6qy3C/DairRtZ3gFAFrMauj+Hc0BDfYP+fU2FsZVkzv8RgFHxs/JS8TSl+Xp7BdWp8Gw8E8GgWsQz/7yPjwNpoMMpRLMzhTl3CDExYCxyw5KEJ2Ws8NMgOJbBivBYPywNGiZLrWICRwyNOQr8GbiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759537572; c=relaxed/simple;
	bh=z2MsyBtFFZjwAQ6yW4tGYj5P4OuDK4B2rPEo3HxLbq4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UktpjzBcIqDg9i/ibJogEYlY4r+ZCoIDWKNQtPV+w+UcgZFs4ypLWaz10ZUErtjPVJTHRB/IP/smqyYR3B6wtpKfaHJ4xi3SJ/NYB4b8oOO1ocHpKf3kBYtvJyIQsz2ezgDI36Zqr3fxCkKZu53/NkLtQmgmeAmZmO34Ey2OlVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCQyw1jD; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCQyw1jD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759537570; x=1791073570;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z2MsyBtFFZjwAQ6yW4tGYj5P4OuDK4B2rPEo3HxLbq4=;
  b=oCQyw1jDsSvLYXY83DP+aQmKMdT5T0y+2qRRmtDzo/gQiriyitVCkBmX
   yxN/WWN7OkomA8naUORuVlrJQwV5BTpK5icYCar2HN5BbDePSSkt4nbut
   ABtDPn2Ay3OLBJ+aXfkGK60ZC0Yw2RkTitQvt5a91z2srqothDI/WBK77
   MOJ06M0TmLc4JDreXi5ET1fsgDN9TqTQ9ymNccI8uh+FAZsRLSddHbGwh
   9hmBPWIA3wvqd7IM/T3SywSr1Zm7uOz2D0KsylKaHgSt986GMlH0y7Ut8
   GLoZ5rmFpAX/lw1Z8E+tzazgRrkoHQ5PdwahmJJbjcFFEZpcIobJgA9QQ
   w==;
X-CSE-ConnectionGUID: PdHOFntTRuugAY2cxYaG6Q==
X-CSE-MsgGUID: 2kY5Ku9WTFq5/5ZmpX5oIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="49372923"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="49372923"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:26:10 -0700
X-CSE-ConnectionGUID: Svr0QtoCQFiEnh2E0+2Erw==
X-CSE-MsgGUID: e7WTLnD6SQqF6pp9UOuuKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179834572"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:26:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:26:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:26:09 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.4) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:26:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ookC1IYTdRrpLbWWYTj31EEsVUV3RusM8K0LaUPicPignyem4C9/R+xA8L1RApO+cfi/xtInGFbkWO3Y41rtdacK6aGX2aCfHdBRuhjlxd9SdZ3WmUgDBp2/SByWsE0EYpKJJU5ilk811+jvzZmdruz0wLynD5HOQQ6gC9HEWEbc981qTMO9cxxN+sX6lCtv6wHjlhpBsl6xYOHiJwQibndeveAiLL578qw9gZPZ9oi5HkPPmvjNvh/JD5SJijelrv3p2Zvcp3FTdXvjGzRH22LLxbajN0TM7jtdAoCiU40ctaR5Rc/S2JUpL3zRro0D71AJlIWT9ObqvjJssezx5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQ2F5yuAKOzNjF+qwusKqnk/0jCnNi09OFaV8frMaG0=;
 b=jmC1i2OP5FrVdG2cQ6/UJi5jYwkv9qwtKywVPaK5whlXgVym48qlysUaCYAhN8cxZ9KrvEoKxXLdcoxH7s4gNxV8xuDgG7XhQVoFN9yrtY0Ooy9PQg5VlHDMMR0iJ/48KYqYWWvBfD1nAk02FShryUdSz3TUt4Ed4IDlItzCKMkoFUqeSL76VpygNFlvINhj36ez892YQr1KA5Oia/rm+VIHDd7TAu8v/oSk4dkZa+Ku36XydPpsahsge/OgFGrpxHMSH3ZQ0rpZm4A9AajXNEYH8jAKUNkCFrt2izwghsehJe2fTu3VKgix6rgLTSJFEzIOzd6LFzjPXpYxongloA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF990BCE628.namprd11.prod.outlook.com (2603:10b6:f:fc02::3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Sat, 4 Oct
 2025 00:26:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:26:00 +0000
Message-ID: <3780808a-c6b5-45ef-ab31-f8ce1153e9b6@intel.com>
Date: Fri, 3 Oct 2025 17:25:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 30/31] x86,fs/resctrl: Update Documentation for
 package events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-31-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-31-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:303:8f::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF990BCE628:EE_
X-MS-Office365-Filtering-Correlation-Id: d1dfd38f-5a7e-4c4f-b71c-08de02dc980c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z2x4YWduRHdNeW9qR0JlRUh6V2pwa1RLa3VmZjJTaXhuUlhSZE9lTm43Nm5y?=
 =?utf-8?B?TVNjWDlWNENqVDZiYkt6ZHEvT1p0aXRMT0V1TDl5S0szb1lrZ3V1TTNVT2Jh?=
 =?utf-8?B?L09qNkZMckxrVDhjbzhBUDI5S3F3aGd6V0pwRTlzd2VDNkdkQys2WVBOSDg5?=
 =?utf-8?B?TXQxK3AyaDJCTWhCbGVvSDk2RE4rUm0vMXhuZ1F4MU9ISkNyWlhEU0lBU2Ey?=
 =?utf-8?B?bmtXNzljZlQ4TUFPWTJVR1p4ZnhJOG5BMTF5OHh1aGIwWUxHV3hzczR1VDNR?=
 =?utf-8?B?R0ZRZ1BmNWsyNFYrRkF2T015dElFajNhdW1iaGFaSXpMN2l1MEtKeDJBb0hH?=
 =?utf-8?B?SXQyQ3h4R1hlWTJIbmtFVUl5TGFRN1ZPUkxaWkk5b1VGMWFOdWd4OXROYlRZ?=
 =?utf-8?B?VkZ4bWVqMndsV0pNNTBKdUNZYjd1R3d0bjRGVFJkQmhINlNXYVU3VlpSdGFT?=
 =?utf-8?B?OHRoZHpSL1JuVWlsRWRWRWtqZW50SnFZRVF1RjZham1raVV2MnNXTGZkNm1S?=
 =?utf-8?B?N0pteHozOHVwL1pDUHZYUWJ2amRSQ2dHeTFiSm9wUU03ajQ0aUpaTi9oMmRR?=
 =?utf-8?B?UnAyQStFMnJqWHpKd2ttbmIxR3ZlR09ualhtbnJ5RjZzQllLbEpGc0tYM3B3?=
 =?utf-8?B?VHk4QUFzUkhxN1NUWWNMaUFwZkZXVDFrTEdVWkJjR0QvSWxJajNpajlHU1Na?=
 =?utf-8?B?VTg0TnJuNmZwODA1S1VSZjE5VTlmQitYVkY4T2NQTjROYmowVHF0ekV6bXlF?=
 =?utf-8?B?UElGWllud2l4L1VHQkx3TzFndk1hSFFJdXJOL2J4d1RpOE9uc1NpM0FlSEVn?=
 =?utf-8?B?b2hRZG1Zbi9NMkM4b3NCejBJcGw5OUJnMzF5Q2FYUTgrMnZHdXB0TklSWDl2?=
 =?utf-8?B?SDRrV0tYQXdLR0I2MHBOUUgwOEVNSWx4S3RvZkZ1cWJaekZTU2VKR0VGQWFy?=
 =?utf-8?B?Tk12U0U4aENaR0lxblIra3doN2M1MnR3WjFFOXNMaCtGZmcxYWM5MFhReHJo?=
 =?utf-8?B?YVROajFqblp1Q2IwTXl1ZDhzRFV0ZFh6MDhGRktBOXl5MWdEamowWWF3WnBM?=
 =?utf-8?B?Uk1QR2hsREVWU1IvSjhDcE53cXoyZ0ZZcmlVUCtDTUpFZFF2YzQ2QitDdDlR?=
 =?utf-8?B?SXR0N0ZSdk5ER3p0SjdvOUtvU2NvWHFoK3FFUmpTSzgyL0dHaVYwMHhqQkR6?=
 =?utf-8?B?bVNWa1RUUjV1R2g0akk2ckM5OEw3MlpuZnFxRitodVlpMWJvcCtXKzZqNzN0?=
 =?utf-8?B?ck9qbE5LNkdVZHJ1b2VnY0VaeTZWeEtSa0xYT093QVljdU4zalJ0V1gyaXNh?=
 =?utf-8?B?MW1VejNFbjd5N2hVTFZpNWEyRHcvZko5VDBPYXE5enB6cDBQK1pjbzhEK213?=
 =?utf-8?B?Q0dMWC9icEwwNkJ2eGtDS3B1bFBhNmN2anRQTjVRWUNmQU1SVTZBbncrdlBC?=
 =?utf-8?B?SXp4aXIrRkRuVnZuQmhTdFFNTDRsd1pvUG9LUzN1bkh3ek5SeU9jQWxxeDN1?=
 =?utf-8?B?c05zaDBsbFBmM3IwWWpsWXMyb2ZDemxiTzVIbDlzMzRJeThBenpYVXdqNTMv?=
 =?utf-8?B?L05US2pKd3hlYVovMm1DcGFONVIxSGxLU2Ixdm4yYzhWamw0MmZETURjQWtq?=
 =?utf-8?B?VEtzS1JZSWx5bHhQVUdIdDFOcWl6Mml4RXJid2lzNWlEL0F1Um1EeWhoT0o2?=
 =?utf-8?B?MytzZ3RyNHh3d3doeUZrREMyeURVcXlKZ1B2akpQR3ZJTXMwN2pqNGVGV0RM?=
 =?utf-8?B?VUsvRlNiTzg3akFveU1LSm14UEtwSEduQXhSUUoxQVdBUXlRaTdUYThJaWtV?=
 =?utf-8?B?QVRVdExTNlJHRlRwSlVZTFZJazQ3QkQxSnY0cFE2ZlN4Q0tpWURILzRoSVdo?=
 =?utf-8?B?SWVZdC9BclgzOTBIMG5hT2RiMFJNdm1tZVVwOXo1Nm9CVTgvQ1ZsWHpKaXV2?=
 =?utf-8?Q?FQj2QwkMokEZW//zKn/8zQreV0Og6AnY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGFCU2xpSk5WRmljcW1OTnlPYWFOZ2U5cExBZmd5Y2ZFSHVQbWZvNlNSV1VZ?=
 =?utf-8?B?VTFHcllGeitiNWlIY2dJdUgxbURHSkxOVEgrcW9pcldhVmlnbVYyakRMSWlw?=
 =?utf-8?B?NGdSaU96THdWVmFZT1BmTXpZa2JkaitGbXZvTnVZUFdENFVPL0NlSkNySDlH?=
 =?utf-8?B?WEhPOWFXc3lvQk5WRTRJNm8wQld0SkdqT0J6ekF3b0xuUTV3UjUyWGZWdDNU?=
 =?utf-8?B?c2I1TXQyOWY4OXpXYW1UNnJjTGc5OGF0cXBJcVNwWGNFSHd4elBCYmJvcytq?=
 =?utf-8?B?ZEdyWTlNcExtOERrNGNtSU1YMnp1R1NYRHMxLzBtcEZxelhrWjFUMEhnTzRt?=
 =?utf-8?B?L3BQT0JzRnJFdG1Cd3F4QnJGNnlDb2luVVpWdjcrZW42OTVxK1RiV2NjQ2M1?=
 =?utf-8?B?dG41WWhoTGNyN3dFM1ZoRmpZYWhiT0xMMXBFQ0hWcExWZ0xmY2V6UFN6Mk1t?=
 =?utf-8?B?M1hmL0MwcmxpenFONFNOcWtqWXRuZ2c5RVhIaHF6aDhVa1htWU95U1A4Zyth?=
 =?utf-8?B?M2FnOW12TUdRb1ljYmNWV0NaYTFRcms4eGxjbTRxWTBHakM2QWdxSnhaWi9Z?=
 =?utf-8?B?WW5DTWkxUlRiNjNHL2ZXTlZlRndaN1FiM0NBUlZGenJCbE9sVlNKYmNpN0Fl?=
 =?utf-8?B?Y1h4MHdvc0FPaE5LeEt0MmI4Wlk5ZzE2aXQ1aWdOckMyWFlKQ1B0a2RsR1lQ?=
 =?utf-8?B?UjFMajdYVWtEYkZUaWRJdGlUZDhyMVhhc0N1QzZlbWpRZjE1VWRjNWl5Tnhr?=
 =?utf-8?B?SngxL2VrM0t3NnVGdUM4dVdpZ0tVRGs3K1p0WUlMQWhuVlFsVUpsWkJaV2Rk?=
 =?utf-8?B?dGxCRE5FdzREUXFMQUZ5N0Zqdks5MjJlTkhLM3MvSWhUUUU4SklnOCt5U2ZS?=
 =?utf-8?B?N0pGVlF2aEJtREVYR0Nyb3kybWhwdEpHZE5LU0wvOVovUnF1cEEzdWM4Uysz?=
 =?utf-8?B?b3VuMzR6NzgrR095RnZSRm1VM2cyd09SZk9HWVRCRHFUTVNheGk1ei8zWEhn?=
 =?utf-8?B?dkY3QUVYa1JoZXJsbHFVUnR0Q3crQnRNSFhzcmxMQTU4N1l0T0pFem5HaDRU?=
 =?utf-8?B?RDR1b1p1QzBITEVUdE9zMi9xOW9VNHgvamx5bXNyTkdkVWN0NktTVXBhVnNI?=
 =?utf-8?B?WjdQeFpxTXJyTTdrMW1acmZPVlo1QU85Q3BxZFpDbHZUTGppVkl5a0I1NzM4?=
 =?utf-8?B?b3FjOHA5ZkJjTVF3azVhS2l3MXFGNm0wSUhkM2xVb3VvN1pXcWo4T1F2bTZH?=
 =?utf-8?B?bFVqeDA3MlJLWVh1SEh0UERWeGtVaUxmMUtjckpReDE5RWFVL0ozRHZ0aFJQ?=
 =?utf-8?B?TktCODBSQ2k3dU9JUTM0Z0dDZ1V1Z0VHczIvVmFoNkNYMC9BbTJHV1haTXhN?=
 =?utf-8?B?L1EwOVVOSzBsNXdGaXk0a3hLMHhNemFFSklGa1kzeTRnSVViQmR0cHp5dExl?=
 =?utf-8?B?YjRrRVdPeVluQWQ3cWs4QWtuK3pILzdzMVJtRmVlbVRMejNPSVd6NUNaZ2JR?=
 =?utf-8?B?bkRkQzVJTlZOTTRYMEpCbWNDeXhjd1NacEljbXkrK0dmV3p0Nm1oWlNULzkv?=
 =?utf-8?B?VW5pb2pwek5QVVE1a2xjanBQZWxia25XYkJFaTkwa3FOQXREbVV2RlpYV0Zj?=
 =?utf-8?B?aDFHNU9SdkVTTzBLNDJCalYwOTJJMmhJRVRHeEdVREQ5ZDRtZTNid3FaeWJr?=
 =?utf-8?B?RlY0ZkZQU3dzckErSUo1QVZLeE1BblYrY21XMkIzY3ZlRG1UZktTRlF1Kzhx?=
 =?utf-8?B?YzlvVzY3UW9Bd1RRRHlIVldxeks1eFlVejFvSXdvNWF0dW9aSkRDV3lKUFdr?=
 =?utf-8?B?QUJ4eTBGYm95R2JFK2kyRlhUR29WTllXMVFtUFZUODU3RCtObVMwS0FmTUxK?=
 =?utf-8?B?Ri94NzB3R2hvemppd0MwWXFWSVAyV0VKbmRscUQyTFNhOEZHMlY5WXJ4MXlj?=
 =?utf-8?B?c2M4NnBkVUdhNVlmYkpaUU5QS3h0RzZsSG0wZytjUDYxcUg3WFkrNUFsckVW?=
 =?utf-8?B?NGNZemo0c0dnNnRWZWxTWnRad0JJM1JMYWV6WmlrZjRhUDNDS29vaVNCTDdE?=
 =?utf-8?B?c3BTNmo4LzdzR1BVeG9OZDV3clhsSXpvUWN3aU55MHRWdWhnTDNGYWdkcGE5?=
 =?utf-8?B?QksxZVhoQkdMMmQ2aDhYMHZ6WFRxUkxZQXNGVTgvYTlqOHJocEZOVjQxT2JO?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1dfd38f-5a7e-4c4f-b71c-08de02dc980c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:26:00.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzEXCFyEXEeBku/9PQQv8aHUh0frB5bij2rjsAl1I0Ak8nhBlE1WnAQegUhdtpxpUwn01etuWxCiMgkkhm/bPCTPYXnHIP1cg2JJENxH0Fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF990BCE628
X-OriginatorOrg: intel.com

Hi Tony,

Two nits in subject:
"Documentation" -> "documentation"
"package events" -> "telemetry events"?
(this is the one and only instance of "package event" in this
series and does not match changelog that follows)

On 9/25/25 1:03 PM, Tony Luck wrote:
> Update resctrl filesystem documentation with the details about the
> resctrl files that support telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 100 ++++++++++++++++++++++----
>  1 file changed, 87 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index 006d23af66e1..cb6da9614f58 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -168,13 +168,12 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If L3 monitoring is available there will be an "L3_MON" directory
>  with the following files:
>  
>  "num_rmids":
> -		The number of RMIDs available. This is the
> -		upper bound for how many "CTRL_MON" + "MON"
> -		groups can be created.
> +		The number of RMIDs supported by hardware for
> +		L3 monitoring events.
>  
>  "mon_features":
>  		Lists the monitoring events if
> @@ -400,6 +399,19 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of RMIDs supported by hardware for
> +		telemetry monitoring events.

There may be some additional detail about how num_rmids is determined that could be valuable
to user space since from what I understand user space seems to have some control over this
number in addition to it being "supported by hardware".

For example, if the PERF event group has more RMID than the ENERGY event group
and the user needs to do significant monitoring of PERF then it may be useful to know
that by disabling ENERGY it could be possible to increase the number of RMIDs in order
to do that monitoring.

Additionally, from patch #23 we learned that "supported by hardware" can have different meanings ...
it could be the number of RMIDs "supported" or it could mean the number of RMIDs
that can be reliably "counted". A user force-enabling an under resourced event group will
thus encounter a num_rmids that does not match the (XML) spec.

> +
> +"mon_features":
> +		Lists the telemetry monitoring events that are enabled on this system.
> +
> +The upper bound for how many "CTRL_MON" + "MON" can be created
> +is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the
> @@ -505,15 +517,40 @@ When control is enabled all CTRL_MON groups will also contain:
>  When monitoring is enabled all MON groups will also contain:
>  
>  "mon_data":
> -	This contains a set of files organized by L3 domain and by
> -	RDT event. E.g. on a system with two L3 domains there will
> -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> -	directories have one file per event (e.g. "llc_occupancy",
> -	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> -	files provide a read out of the current value of the event for
> -	all tasks in the group. In CTRL_MON groups these files provide
> -	the sum for all tasks in the CTRL_MON group and all tasks in
> -	MON groups. Please see example section for more details on usage.
> +	This contains directories for each monitor domain. One set for
> +	each instance of an L3 cache, another set for each processor
> +	package. The L3 cache directories are named "mon_L3_00",

I still do not understand the "set" terminology. There is just one directory
per domain, no? For example, "This contains a directory for each monitoring domain of
a monitoring capable resource. One directory for each instance of an L3 cache
if L3 monitoring is available, another directory for each processor package if
telemetry monitoring is available."

> +	"mon_L3_01" etc. The package directories "mon_PERF_PKG_00",
> +	"mon_PERF_PKG_01" etc.
> +
> +	Within each directory there is one file per event. For
> +	example the L3 directories may contain "llc_occupancy", "mbm_total_bytes",
> +	and "mbm_local_bytes". The PERF_PKG directories may contain "core_energy",
> +	"activity", etc. The info/`*`/mon_features files provide the full
> +	list of event/file names.
> +
> +	"core energy" reports a floating point number for the energy (in Joules)
> +	consumed by cores (registers, arithmetic units, TLB and L1/L2 caches)
> +	during execution of instructions summed across all logical CPUs on a
> +	package for the current RMID.
> +
> +	"activity" also reports a floating point value (in Farads).
> +	This provides an estimate of work done independent of the
> +	frequency that the CPUs used for execution.
> +
> +	Note that these two counters only measure energy/activity

To help be specific:
""core energy" and "activity" only measure ..."

> +	in the "core" of the CPU (arithmetic units, TLB, L1 and L2
> +	caches, etc.). They do not include L3 cache, memory, I/O
> +	devices etc.
> +
> +	All other events report decimal integer values.
> +
> +	In a MON group these files provide a read out of the current
> +	value of the event for all tasks in the group. In CTRL_MON groups
> +	these files provide the sum for all tasks in the CTRL_MON group
> +	and all tasks in MON groups. Please see example section for more
> +	details on usage.
> +

Please have this text line length be consistent with surrounding text.

>  	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
>  	directories for each node (located within the "mon_L3_XX" directory
>  	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> @@ -1506,6 +1543,43 @@ Example with C::
>      resctrl_release_lock(fd);
>    }
>  
> +Debugfs
> +=======
> +In addition to the use of debugfs for tracing of pseudo-locking
> +performance, architecture code may create debugfs directories
> +associated with monitoring features for a specific resource.
> +
> +The full pathname for these is in the form:
> +
> +    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
> +
> +The presence, names, and format of these files may vary
> +between architectures even if the same resource is present.
> +
> +PERF_PKG_MON/x86_64
> +-------------------
> +Three files are present per telemetry aggregator instance
> +that show status.  The prefix of

Please be consistent with line length and do not trim lines so short.

> +each file name describes the type ("energy" or "perf") which
> +processor package it belongs to, and the instance number of
> +the aggregator. For example: "energy_pkg1_agg2".
> +
> +The suffix describes which data is reported in the file and
> +is one of:
> +
> +data_loss_count:
> +	This counts the number of times that this aggregator
> +	failed to accumulate a counter value supplied by a CPU.
> +
> +data_loss_timestamp:
> +	This is a "timestamp" from a free running 25MHz uncore
> +	timer indicating when the most recent data loss occurred.
> +
> +last_update_timestamp:
> +	Another 25MHz timestamp indicating when the
> +	most recent counter update was successfully applied.
> +
> +
>  Examples for RDT Monitoring along with allocation usage
>  =======================================================
>  Reading monitored data

Reinette
