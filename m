Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450BA35B122
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761194073; cv=fail; b=mk4WH3RItIdUtnFOQLMEnMwmv+1lZrzAsQDbjyMjaSPg3qLxupa8pdQHU5PxhnGCbwDOeio2gBcjYqTC8nz8Oz1YCPIdSqtMCQJ9sRsJN250jRYqAyk0jVHhKCOKw8RLOM8Reo7yfRrBpfHsgjHtTaOJuojIN7ygh7AiKtKWCw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761194073; c=relaxed/simple;
	bh=jMxMmGXSqyMRpTmR4IVA31e+/9EDe/K2ZQinhtMIr9A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JVJ00EY2wasK6zoFIgfMRdc5VQtwzcsY5tikBQpwjDu95/5Y+jhh8346gklyBhcXdS4kY7rO7yC1aaav6YAADhkeUJbBzZZsO9YdYVec6TgkfUdjZXZvOGzmrZxruJhOxQf39pLiwii5Gu33YS6nK7B6cBf/YaZYB1NNGeOsTCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRfjnTp5; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRfjnTp5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761194072; x=1792730072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jMxMmGXSqyMRpTmR4IVA31e+/9EDe/K2ZQinhtMIr9A=;
  b=jRfjnTp5FCuC75RgYL2NCH7JOL0rx0fKWfjYdrBm+2vUEFIDsbjW6Xiy
   bJ9xwr0NaSLxLdZoMMjOpMlHLqaJOFvRxC+/0h9rWduK+nDEs46Tt5C0O
   TeBSPJi1X79JOfiRGAir9KIkRdIGoUdXFiTgJBef+yRxyuSnyithS+a8Q
   gT77KUDQ8ag5ki0KRLv4qUvBdYdftBFBJPMlNV9pEWBHjYuwOSgocIhz5
   kmfHA5qKmbCAI90PcE6txbrf0lM/9H0cvoJIbCIqfDJl1v25c6V3sZIMw
   yR190j4xeBccZ6ZkE4FPtVLoY8fXnB+mfZFSbEeXXgQ9gjc9b2QagsFHu
   A==;
X-CSE-ConnectionGUID: WnMPUV1fSSSgsustPrOS5w==
X-CSE-MsgGUID: bZYm+reYQrO1UUL61xe2Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63393024"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="63393024"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:34:32 -0700
X-CSE-ConnectionGUID: PGH3V6UxSY2fBHSHhz0Cog==
X-CSE-MsgGUID: KJ29btD9Sn2BbVsASyVo4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="189181701"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:34:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:34:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:34:31 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.48) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:34:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ktwt520kL/htk0Ndm/gED2JnjuKkRdcBmzdEacM+rEVeTjgU3EztSznt0aFjEo2Dag0VSFHTxF83WGs3EontTRFI2VbAS8QXGxIMokYnL6WhRNELpscIF1ojdglHkU8MVtpZVtcB4q3ei/dpmSvRUwS6BVfgOD0n8KLjKnSVa/j5r6e+VKOVBTcN4UrntKOnACUC9hYLXwlZtlSWKnQlgoXZ3Dr5lAaPcgCUQpQ3AM9oE1bmvfPAOmw1uSxxDQCZU/QfVq/UPk6/7DzNAe9y0nO2wUqbZhkeoXlRY5dq3doXs0Ut+PcJhdeKjB2xn6ZeI4fZt1pdxqrt5gldNdQa6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZnUjJrPrzV865iS/841sMh73QH3JatnIfl4/nF/e4U=;
 b=nnIDnaAKA2j4DdfSdgwSc2uJ8g7v06Z9f4GriViX0+AEjwEDnXnBelOeS1kqWtaPGZhtbNkAT9Uf5eC9xeDazMF9YfWlD9Qf7AWkSQBG0cOXcExsyEk7ezjDYR24iscvzHrIUCYe1lIn1D1KAWAGYmA6ly4VcuBxgcQ/+ZDoet3dhb2xq8xy42Dmems1n1NEm1tcsnG/zCetTtJxRbGirg7NP5E+dVqP8Jd2hb2r9INWiDMWqLleX+/+85+2Y4dHhm+w2HHGgmaP2sgamYS3CjKjFLXf9Fnppssn1e5ANQLGRheA5remE996NZxDV3u4p7HioLJOjJZD5X9P6ULb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 23 Oct
 2025 04:34:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:34:29 +0000
Message-ID: <090a9b56-c714-4a5f-bf33-41f47e29bb4d@intel.com>
Date: Wed, 22 Oct 2025 21:34:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 16/31] x86,fs/resctrl: Add architectural event pointer
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:303:b5::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cc212c1-b6c4-498b-183e-08de11ed74a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VXNldmFjdGkxaUFSRkUwVFN1d2t5czNHR21HTjlEVE9zT3Vhd0hVK0xpNWVv?=
 =?utf-8?B?eGRwOFhxcDg2WWpxS0g5bVlZcVNJZ1F4SEh5akhFT0prUXMyMzhTU2s5ZmU0?=
 =?utf-8?B?SmNoYlo3SGxPaGthQkowWXBWRitPQTRqdFVQOXpDN29yNDlhdjlvcy9pcDNQ?=
 =?utf-8?B?ZCtQR2ZJcWRKNWVXN2xyRlZ1ZlVscEVxbTBEdDdxQXpZWitVTzZGSU40SDR1?=
 =?utf-8?B?SWpMSldOZ2IwVVhkbXRNdVcxTGVBWTlPcCtMbmxxNHJGYjFCczZ5amQ0K3Fo?=
 =?utf-8?B?YjFhSVRpWCtUODNoSVhLZjlvQ2pkMmtvWUpSOFQvQmlSTUM4WkF5clZVTlA2?=
 =?utf-8?B?R2pobEtwejBEOFhLdzdaRWx2dm9nT2N4TmdSSWt2Q0R2TGFXVHFFKzI2amZw?=
 =?utf-8?B?WW10WTJUMzNWaXE0RDJ3N3p4N3F5VU5TQzNwUVlTZldUQkJPcWtFSmY2Q2xm?=
 =?utf-8?B?aVNnUGdJZFVVNmJvcklwc0diOEM0VEJZOTBxNEViOUQ5NVhqRFdrbDY4SWdv?=
 =?utf-8?B?amtXRzI3aVZuZ0ZXRjhHbHBGaUNWYXFkd2V5UmpsMjlYVHlma1B6NktIUE84?=
 =?utf-8?B?NTZvUVNHUFVEVmpEcWhycEViQ21iYTBzejQ1QUY1T25GN3l4L0xOQmdDWGYv?=
 =?utf-8?B?L282MUF1NjFXTGFGV0V3WDh5QXYxd2NJSnN3R1hYZGRORFE1TmtKOUY5di8r?=
 =?utf-8?B?V2daUXpabGdLejVZVStJMURPMGhZMGtRRmYwcjlpS1IvWXBtR1kxOGl4L3Nj?=
 =?utf-8?B?bndHQjB5NEY0eVovdlRvY0kxL1paM0RPaXZVTXN2Y2kvck5lNnNWRkx2NEQv?=
 =?utf-8?B?Z1Q5c2dBenVndm9OakUvdkw2aXZFd1RXbVVPUVdYOSs1OGtxRUJSYk9CSjNE?=
 =?utf-8?B?eWxZY2tyTnQ4c3kzdk5jczlmNHJzOTRaWlFJYTJyaVVPM0NmT0FFT2p5amJz?=
 =?utf-8?B?a21JTVRETlRFWnlITDc2UDh4bHp3cWZzTllJSnRZemFDejZJS0xNYm1XVDE0?=
 =?utf-8?B?ZUtVY3VHUXFDM3gzOTFqRkpHTGxsMC9SeUxpNG9NVkNPY3V6c0RHZ0V5MHlB?=
 =?utf-8?B?eWlWQ3hjaWszTG9rWS9ubzJYeW4zZW1HaTNra1RLd1h2QlVXNWttMy9qK2po?=
 =?utf-8?B?czZ1blFLbTJjQlJCSm1sdU9VelBHbWI4L3E0aEh4YjFLRDA1SlpWOENTc2Zs?=
 =?utf-8?B?cVJXSENkb1B5bDRqbW02cWFWTnNWdlF4OWxpN3pJMG92S2doNDduOHJOY3cv?=
 =?utf-8?B?bm5XMXg0SjNDcExTNlh4TnBvREJsQ3VqTC9sWEhVdTFzdkIvL0xnUGJNejJo?=
 =?utf-8?B?MmluaTZ4Ri9OZDgvMy93amNtT05qTC9qcEpSeXJOVThPSy9RSjBIQkNhc1Vh?=
 =?utf-8?B?WlVhaEJTQmNHVU5WM01IQkw4RklXZTh3TGljWUdxVGJtekpjSUtRSTJoZGl4?=
 =?utf-8?B?S3FDZ0N6a2hHdVRnOU9maWdjK1VrYU1MSnluZVZDeGxPaWtnNWs5a3Vjek5x?=
 =?utf-8?B?UXdpZHdLNjJEMlNCa0poSHpzM1AzdmtjYWhIWkg2WENudmVKaThBbGlGbktu?=
 =?utf-8?B?ejFrd20zM25TL2ZWeWk5QlU2RW9zQW83M0JNMUdaYjhVbEZNYlYvaUMrYXlN?=
 =?utf-8?B?MFBBSHBIVXBka2RXQTQzckJmQ3p5dmhxSE9zVWZ2MFp1YXM2YS95azlRWmNR?=
 =?utf-8?B?dU4vYnpBZ21CTUNxSlpwYVFyU0xyUjBWVGt0RTlPVWxGWU9lTk8wMUwyVTNo?=
 =?utf-8?B?Y2JEdllCalN6ejA5WDJCbW1oQVNZbHRuM2VrRmNiTHdxTnBqZzMzbnE5QUxS?=
 =?utf-8?B?aXFBT3FJSUh4eGhwOGVzZmRaWW9hR2x1dDlKSmRQdEI5ODhRS2tpUkpEVlk5?=
 =?utf-8?B?SEZJNlY1QkwvNmN1ZThISGNGVHNobkFOQTV5Uno0TFBObGY5Sld5WXM2QW9L?=
 =?utf-8?Q?IjLBGjt/guwQoH2ZaWvNFuH7XbAE47bp?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0gzWmEwdlJQTDhxMmh1dXp5N3AvU0s0eW1yeC9MZTdjRHc3VHVxR3BMSFp2?=
 =?utf-8?B?SHhOQndjMkQzTDM1aVd2S2E2Vm1xOXVLUWNPVGpqMThBM21ic0hvV1pmSUJh?=
 =?utf-8?B?MVBBNjJraDllajhiNFhJQ0M0SFd5VjE3Zzd6Y0ZHRklTMnpialRvTFRHckQ5?=
 =?utf-8?B?RmZyVS9kdndyL1JYMlhkTnhwZDA2Nll3ZFl2ZUE0MGFYSlZSUFFCT3JXQSs2?=
 =?utf-8?B?eDhFYWdnU1NCMng2NGRuUGN5WlJlS3JiMjB4Tnd1SU4ybDNrOVZVbnlmT0x2?=
 =?utf-8?B?UFVtTzh2eE9ZcjVOVHY2WTk1ZE13UmIxTTlsVzRvWUw1dHlJNEM1V0FKOTBi?=
 =?utf-8?B?T1I1Uk1nYVV5Tk5QSHgxc1NaT0JMY3l5SVk1bk1ud2ltckxJUEpHRHpJT2dK?=
 =?utf-8?B?WWpVWCtkL0pVeDd2Zm5xZ090VnBDN0xMNzlkZVgxMW4vV1ZOZ253WHJIQ016?=
 =?utf-8?B?ZnhHVmZvZDVjZzdVc1JPS1BiMXZsQTJuSFZJSERVb3g0cmE3ajh6aDhVUWdu?=
 =?utf-8?B?R1hxK0JqN1QrYmMvUXhoaUcyMGw0dFJ2R21RZjNoMXc0by8yZDExZ3g0WHc2?=
 =?utf-8?B?YzR2VG83SUhvWWl2V1dMeS9kOW4wOGdRUE9EVTMzTm5PWUN1VjBjcU5QZ0FY?=
 =?utf-8?B?YWlNcHNQaUdzRHdtbFVLQzUrZEwwdTNSbENwWXhZTDJFK0s0N0RyN0NDcTg2?=
 =?utf-8?B?YldsOUhEY2xLY0FkQXdyRnk2VkVoS0FXWUgwa1JDN1ZsMXJKaDJ6T2NQdDNZ?=
 =?utf-8?B?anpBSlFkOC9CS0hubVZGSHgxeVd5dWI0Qmx1TklJT0tmT29uVUZLeGpjbG9W?=
 =?utf-8?B?YitMRkNpTHFTQ0ZjRVRGUGptQ205dWthMG5nOEUxWFp1cmQ5Wlg0QnFJa2x3?=
 =?utf-8?B?am5NRXUzZFNGeDlSZ05Za2NCSkVjTDZXc1hiaWFXbm54SXZicVlmeFMxa1lI?=
 =?utf-8?B?blBDNys5Q2UwQWNOaktXdXNMaXNhOERjQzhRakRZY3RXVnFTMlFxNWpxcVJ2?=
 =?utf-8?B?MEhBb3dRUjdUc3kyMlQ0SzlaOEVTeWFkK0ViUHFESWd0TlVXdW5jbHVmcmZ6?=
 =?utf-8?B?dTVBaGlyYk9HM3VXaHdjNitCRHB0RDRTb3ZsTExtUXUyTmxGWnhQRjlIZVBL?=
 =?utf-8?B?TlNWeUJKcE9rM3d6RjVSYVRkVU1XNUNhaTUrK2k0QnVMTU5Jenk3aDdTNE5W?=
 =?utf-8?B?OUNWdVNKcUdGZHI5UzdJRnM1dnRIWUx5YlZrbnNzQjZtOFdWYmhxZUw1NDZo?=
 =?utf-8?B?TjZYQ0tCZjlVUU15Qm43TVQ4Y2Rld3VqUEtPNFQ3bnhCN1JQd2JtYW9kNmJD?=
 =?utf-8?B?dTgzOTdpY3pyZ1prUTBNNUNVV2RwTkREcnRLUDA3MzZRRlcwVGJvWmM0ci9S?=
 =?utf-8?B?OUZvRlBYSEFzMWFkbFZUWDVVL1FmMHV6ZTBNd0NYTzMzVHFMb2JBYTJCNEJ4?=
 =?utf-8?B?TzNPSTY0T04vMDZsa08xUzBmQTdKUE5HOTVTa3ByRk9DMmEyK1AvQzh6bnRq?=
 =?utf-8?B?eFFaektiR3JvZzFLeWJaeFFvcnZRcVNpRHpYOW53cXRjd3NWNTdxTGZTbm1K?=
 =?utf-8?B?ek9BeVNlR2ZRQnBRTVZOK1dsOVBJRTZidndGWldxd3VEMzQ2NmxkL2UwaXUw?=
 =?utf-8?B?VzJ6VnpWRm5MbFhqUFhtZnFmRzdZbk04RG5tUHFReTJ3cGRsYVFWSWFPUlZi?=
 =?utf-8?B?Qzh4T1FZY21NRUZwL1ovRmFTMktMdGgrcFpMSU9JZ3pkcnZaYmZNU1BHVnlP?=
 =?utf-8?B?b2VPaW9RQyt1RkhncXNyZTdraGtQNXNSb2pJVjYyVy9ZUVU4SjR0enJvSmFO?=
 =?utf-8?B?QmJtNG5NbkI3ODZSb2w1bHZod1Q3Tkh5R0N3Um1uZzNqMzQ3RU1LcTFlOUZL?=
 =?utf-8?B?OFBMWWdSbHFOUldjM1JobWpjN1BxK0xrUjNYRjdhK2p6eFRnUnI2eUltM0p4?=
 =?utf-8?B?dmkyaTZQV3JpdkFMRWVKMEdsTnNSTkpzMGpjTmNURWd2VXd5MUZqQlpBcm1O?=
 =?utf-8?B?K2ovVGs4L2VmWjhqYlFmZUc4cmdJZUtOdmNlOWpwakhCcE1OZzhlc2RXZTgv?=
 =?utf-8?B?TVByL3V5ZzdnbThGZVpWZGRsaXZqR2grcHFhN1QvOFBsMGord2F1UGJuSUJU?=
 =?utf-8?B?VEJzdENNT1l2bkRHbml6YmR4ZHBTODUvanhWZjhNYkRiV1hUZWljVGpPR25B?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc212c1-b6c4-498b-183e-08de11ed74a2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:34:29.5780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cc8wk+WMeWVd7uG/7nuDLUlMIw813siVzUdTPWnOdUfC7XLMGRRqJ7gPbXGFwdQBR6WyMZtvDU7InWbiY4JLC3bc+hdgVfb3Y6ZECTon6fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> The resctrl file system layer passes the domain, RMID, and event id to the
> architecture to fetch an event counter.
> 
> Fetching a telemetry event counter requires additional information that is
> private to the architecture, for example, the offset into MMIO space from
> where the counter should be read.
> 
> Add mon_evt::arch_priv that architecture can use for any private data
> related to the event. resctrl filesystem initializes mon_evt::arch_priv
> when the architecture enables the event and passes it back to architecture
> when needing to fetch an event counter.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

This will need to be rebased, but that should be straight forward.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
