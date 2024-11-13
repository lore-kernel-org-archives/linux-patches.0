Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F81123AB
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 00:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731457224; cv=fail; b=HOICIDHt5dAoWSN0UKMUrzMXncsZ+krBDjtCxJDbKSK04uMKtl04CI1Nq34dWZ8uNjIhVvXpYbMfWcJhFttmJvqsobvRZUW+tb4zq7gHKacAtSD+7tgEaRxPdgGjX2XNZS4aqDeketYn1sx7eGlkOSqEvtuuxRiRri8nXlxBEM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731457224; c=relaxed/simple;
	bh=CgWolghV/qAPe2SR3mJThAt9bj+3iMy/SH6dagP1BRM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bqumil+py9is/qPDBmsJOQEWIW6Deom2jJ+cbBiQqXtK6sM0nXkWVz41pfiyfAehJ1VQcnUbUz3PVoJgBay6PSVdx3niMdigMK9jY5okpysuGGpnCEuoYrESXMLDXLf+Rcn2m1MQzFkiHAxYysIvVckOwhhtpmg3rabdES8+RWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=APETn7zS; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="APETn7zS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731457223; x=1762993223;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CgWolghV/qAPe2SR3mJThAt9bj+3iMy/SH6dagP1BRM=;
  b=APETn7zS0TH5LHIbi2F75KTxDAvexI7n6ga53+WWGgLZffC1/G7dtNxI
   oDvSJB3NA0MvoRSyWh8NAK+aUEKoLDLCTgbdoKZJ8pfxe68AO2f3LOb9H
   MQ7Z2D36iHOifM+XaLAtgT/Ru3K5j1NG0s06IbaOyUn7ru+dXC7NjfgQk
   yN6vWqb3lyt8r+GhMnyrnyjGq0hPBqsKjJuex6KhwK77pVUVXKuKIMfC5
   xKt+ge0pHO3NQ45ET7S2zllFASVvLiSCHfft2ixbRS/sFFFCD1gK7chyu
   pP+KPqzxrxkcKDFwUg5OpqhLMalTQWKgUUIRiwkJ1hN8UoJfIByurOOJW
   Q==;
X-CSE-ConnectionGUID: Be+aqto8RzKFfj/IXjSpcA==
X-CSE-MsgGUID: Vh07lQmYSjmW/Ae+Rk9jAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="35113867"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="35113867"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 16:20:23 -0800
X-CSE-ConnectionGUID: K+0nYQukTaC4HzAczHmivg==
X-CSE-MsgGUID: CPWK2Iv7Qu6jh0X5dtizeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88109806"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 16:20:22 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 16:20:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 16:20:21 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 16:20:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SoSeqpYD1P7KmIf2KRC+B4B/2oZAL7VOmihSAeMbUEHt3g5nECDLHchviC3NxRcfbzbXFy7bYtomlpR7YX2Z7aqntZQWS3vKZgEgRj9p4e2ga8BAsJTYQ7BGeyqtF1rTIR3TEwRK3fg2iP9700DotMsKDykbBv6QasoKo7uqYOItEB+A5MTldp3Yl8owe6IAH0SVW6jsB03NI9Ak2hHYGAhWrbbMVlFPHuRcyh6qX38/X2gUvHm9T664PVAeQWjgktvKACW4hYgw0Ep0ZVTgDD4QU0mT0pR001EXjx7a+ndQ/g3gxjs7BJp/3sdlr1j2Dgj0ydUtayIbVjB4XF+etg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2FxONwJRe1zKRniFXL9/pOWVTPEDQjF1UF9pamMYWw=;
 b=RSGTHJCjqHPSoLdHGLtcEVXYV5t0frUv5UJ3cdMuc0McJJYUZUZvxubGxA0WdZSaLFvQm5cB902aXVzBTaRw6RcmZKkvxUyh0T6a4gvcqJweraVlqQEg8VINdLYER44zAWlQGAFu0Fl0EXvsS2rWI2P7isrWTRqSh0IQcYslcwcEuGstVT+r4x6sLdx3L4M5q5u9GC5PB/2aokVF6am1Xulor4D/4wrBTzF6Ws1fGHQ5fvlP/Eu1bxavjb72sSWIKNEHnGzb5nlUZhGLw3ZB4pIm/T3UECyRW3Br7eCWNeisRjoNqxbwXU2NvNxB8UjMYf2AQVoI6zWqbgp8oxXQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7882.namprd11.prod.outlook.com (2603:10b6:208:40f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 00:20:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 00:20:16 +0000
Message-ID: <c748f9d5-ef10-499e-bde5-1bce20a44d2d@intel.com>
Date: Tue, 12 Nov 2024 16:20:14 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon
 directories
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-6-tony.luck@intel.com>
 <bb4741f3-009a-41f6-b495-3408d9abbff7@intel.com>
 <SJ1PR11MB6083839383802DC9127C5CD2FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB6083839383802DC9127C5CD2FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: 18924bec-e7fc-4387-a274-08dd0378f2d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NXRNNzBaUENETWxUcStoaFdKUCtXUTJzaGRBcnViaHgwUWZqcCsrTEZ5cEM2?=
 =?utf-8?B?MmhDbit5WUhIV1hjb0dwbVNOblVTNXRWam91Kzc2aTNJVjdEQzRhcXN3WTl0?=
 =?utf-8?B?a3lQL1lxRDhvSjJnbmVIbTkreXhKaXhWdXE5dVdvZzR3VytSamR2eHlidHJ3?=
 =?utf-8?B?YXBuOFpIV0RmVlB6NENrUGo2bE5JajQ2aEpRemloSGZtb2lYNjVOT0dWVGFs?=
 =?utf-8?B?QjVDck0vM2N1RWZJczVvV3NkRDl1Y1FxcFNQTGw3NW50cFlCMVJkUzVFY3ZE?=
 =?utf-8?B?LzNlRFFGZTQwSzJDcGJtcEp6bHpNK1dqUFV5SzV0UVB1UWJWR2xmaW9BTGZj?=
 =?utf-8?B?MEZxOUoySlREMk9JZEhhU2ZqNm1VenNLZzd3MWpqY2NjbHVhYWVXclYwcnZR?=
 =?utf-8?B?dk9haElLRzhJamJsSllKMFBJdUdJTU1mRzB3d1RjQUhkaEdVSDFzUW8wY3Nk?=
 =?utf-8?B?VXZ6ZEhSWXJldmgxY3hXM0R1c1ZtaG9qbC81ZGRxOFZubElyUEpSdWdTU2Na?=
 =?utf-8?B?ZnNMZ3NHeXpDNEVDNnFxNWlHMkQvSSs4QzRhTnJabkdlUVEvSU9wSW1uTjVy?=
 =?utf-8?B?V0Y0RlRwTmQvWisxSmdidW85TEZWUHRMN3ptYmdOZWlPT1djN3dvNjhiWUlB?=
 =?utf-8?B?MElYZEFxTGpYVGduQXVVeHF2c2syY01IVFZtRktiVjZYMXhWMDhOQU5GcGlI?=
 =?utf-8?B?bzBNcmhiME9TcWl5WGJVMm4zaWV1bXBCZTZWZnN6WXdMcmpmaGF1RW01Wmhm?=
 =?utf-8?B?c2h6STl2ZURPNEV4WGlMWExydjJuc0p0YzRkdG5NOWZvd0t3ZmFjelBZaS93?=
 =?utf-8?B?Ti9RSnh1WnpHRGtGTmYySjRnWGpESi9ZMmowd1NNdzh0Ry91QWtZQ1hPNDJ4?=
 =?utf-8?B?b2hydFRJSWVHUWN4M1NXeFJBR2xLQnRNRGZ3N1BkMjdaRmRYRkxicldnRUVu?=
 =?utf-8?B?aytTanhOQVl3bzBYQXpTcXVEUExmUVJ1dEhKSC9PTUdOU2YzeGlMa283ZUxp?=
 =?utf-8?B?dERrS0dzSnFUcEt6djFFT3ZkaFB0UXYzYVFZSHkvbTdZdEc1Vmg0aWZTTVdr?=
 =?utf-8?B?M0UwdnhhSk92dkorMC9YRUY3VXhCbzlSeWJLS213Y1h0QjdaMHl6NTcvamEx?=
 =?utf-8?B?RXdwRllTZGk4K2JWNWxHbEJXa2toU09PU3dZY0NvTWRhU3NKZ3J5MEJXL0I4?=
 =?utf-8?B?ZkVzVXA0ZS9EOU9NWnFpcTJYY0V6cjduZGo4dWZYWk1xOUNlNlp6ekJRaktw?=
 =?utf-8?B?NHpIMVBaSEk1QitDTlJQMVRPZjVINmxvc3IrTWcvUXNFMUNINGdzVE5UaGZa?=
 =?utf-8?B?UkNPTFBTU0hLVnlURG1uajBjcnpDelZQaWJnbFkwbUc5R21WMStmdEgzbGJF?=
 =?utf-8?B?MjNVdjNTdExNaXN2QWRyVUJ3Qi9vbmdwTmNnZlNHeUNEV2xxWWVvV1Nyb1p2?=
 =?utf-8?B?TndNZ3YvQmhYdFBOVFhscnd0YkUrem9QWEZJQkJGLzBUYTRsU2lEVXVIbHBr?=
 =?utf-8?B?WE1sZEhOWEdtZU5kUUUrRDlOSkVjNlVUQ2NGczhFY3VnMndKcUsyTTI3WCtk?=
 =?utf-8?B?V0hKZ2xyczNDNXp5UnhjekdHRlQvQ2JaYUtrdkRVL0Z0SzI2ZUlLWGJ6WStZ?=
 =?utf-8?B?dE04N0dzbXB1OWNXOERicGFNNmVCQlB2VytTUS92aFhESWdQYjlJRkh0MTVo?=
 =?utf-8?B?RVZ3RzVkKzhIZ0l1bnNaby9RcmtCYW5WVUpiS0NpN3NsWnI1OXI0MFByK2w3?=
 =?utf-8?Q?QTvl9k3H7OGiDtYxEk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE5ia0FEeERYa2xvejlsZVlncEpMdnl0MCtpczQ5RFZYUUtMZG9lYWhNZmha?=
 =?utf-8?B?T3JOSHBDU0QvdHhsTmpnQkpTYlZSb2dMVmEvenlhTHA1K3ZKUG1VQTRIbERm?=
 =?utf-8?B?OXRCVFhnazZ2R1dGWlRuaG0yK1JiWVo2ZGY4aXU5VnBCUWx2aVFHb25vOWRQ?=
 =?utf-8?B?SWNMa2llQXVpVmlyMC9tT3FaMHBRcGFUWEJ0YlMzTDNaejZ2Z20xRVlFdStW?=
 =?utf-8?B?SFBIekhldlBZQ1BnVnBMNklTVytEb082a2JpSUpTcjArdFl0dDVreDVnRnh4?=
 =?utf-8?B?b2hQV3pITnUrS0plMjNpK0RoTFA3ZU5ZQmo5cTJwVm1ubWlyNXNoelpWemNU?=
 =?utf-8?B?Nno1TDkyYzR1eStmWUFRMW4yWlpIYk9ham1GblJLM1VUbzk5MHFXeGZaaGlZ?=
 =?utf-8?B?aE5DLzExOFZmQjZ3d2o0WEx0RGZxdS90TVFDVXRZRis4MHR3aTJUYWRRUXVj?=
 =?utf-8?B?Sit0TjFYSDhpTHlyNXV1OWNwNFlTdjRNMTRlbkMyVitGVmg5MjZndlBGUERH?=
 =?utf-8?B?NEV6ODBxRFNXRzFzNW83MXpxTmpUQjVlUEs0QVJIZGU2WjZjL08vNkZwL3Ev?=
 =?utf-8?B?MkJVUS9rNVEvcWwzOW5DMmxwQ0liMnAySTMzdUlzdGxpemJlVlFGZjFFMitF?=
 =?utf-8?B?QWJSRlRSS2E2VWEzN0R2TXMvQm02dHlMbFNlbktCbUs1b1NFSFZUem9BS3BX?=
 =?utf-8?B?RVJNYVVlNWduSGNPS2NESlU2MFMxWUp2U2lrZDJFUTZUbkVKcWYxa21wUjVQ?=
 =?utf-8?B?Q1IrK1lwM0xMakF6VkkyamdYSGlSdHRZQWlGQ2tidUhmeVJKdTFyZ1FyTUxO?=
 =?utf-8?B?WkFKam9RQVdLc1FaOVRvbmh0NTR6bDJ0VTdEcUwvMEVUQmlXcU9GcE0zUzhZ?=
 =?utf-8?B?c215L1AzZmhoM3ZZY3MxbEgza0V3aWdRNmF6aHBacUpyRjlWRlBVZVZDTk45?=
 =?utf-8?B?MkxNdDVpaWV3Rjh6Y1NrbHhTMy9EOUlRS1VoTC91aEU3bXB3RWdlUi9aUkcw?=
 =?utf-8?B?NVhtN3p3b3lWaDRHaVcxU043QTJKeE5KekR3K2RiaEhyME53ZWgxdFgyTTBB?=
 =?utf-8?B?dW9CZmNreFFnT3hyZW1EeTJPcHBHY3U4WjJpTDFZRGhYL3dkUWFsZ3Q0SThi?=
 =?utf-8?B?V2Y2L2tFUDh4M0VnM1ZKS0RXc1FxdXhwbm1vSnhybHA1clh2SkdFWXJqYVNO?=
 =?utf-8?B?MDZDTjhGQmpZL1NmVjJTdktZN29iVTVZb2M2WjcyenU5TXdSbDFRQVRwakZl?=
 =?utf-8?B?RHpxdEUvRXlHOUxGT0llcTVaL0c3NDZ0b2VmcDNuQTlTQ29xWnZ0ZVpOT0RO?=
 =?utf-8?B?SHVvdVBuTFBVL3doRmtBcGMrRVF2VFA4bWtWWmhvY0NoYWtjeUFCUWZ1ZVU4?=
 =?utf-8?B?d2xxajdZZS9OUVBBTUtFYXdDbkhnUTVNU2ltdFNZcStlaDZxenhkMWJPbWxq?=
 =?utf-8?B?a2ZtMHlZcXpJMjZQcmFNWktSQkxodDFOT0pqT2l4eFhqcWFZZTlrcTlLOFY3?=
 =?utf-8?B?TGVTY1lLajJPemFKd0xGb1pHS2NRamNQZzdBWHR1dUlib2d1blExWlFoK3Nq?=
 =?utf-8?B?VzRQVkg4UThldWlzbUU5YUdrNXZicEgxbVlwNnR1N3RyNTRWZDhka0lzQTJl?=
 =?utf-8?B?UzIzSlpWTFd1WjlIOWhKbEdubzhBeHJTQkNuR3NKczFqVnNtZmJTWllVOVpn?=
 =?utf-8?B?UjN2Rit6VFdSUXhPUkdDTHRlck8xK3V6eDJWYVBaM2lsUzNCdTRMc0dmYzBa?=
 =?utf-8?B?MFpmak5tU3B4M1doTW8wd2QreTJGaTRUaEF6STRWVjF4aFhqdC9uR0lFa0FS?=
 =?utf-8?B?dzFxY20wVUFBVk92dms4QytoZkJaTVdpQmI2ZmtvT2xJYU1XSkZvcE5KZi9Q?=
 =?utf-8?B?Um9wN0g0RmZOR1pqZHZTZWN6Z1ljZEVoYXFReUNCWEFYa2Fic29vdlhldElT?=
 =?utf-8?B?KzZUcEU2NUVTSzdvUG0yRmpZUkdZdUFuVzFTNU9aazdxMVFLV1dIUTltb3Rz?=
 =?utf-8?B?MVVScDhVVjQxQjhndStXK0w4NlRLUERWNHh5RWN4R2xKVE5TcFB5WnBsK1Ez?=
 =?utf-8?B?cy82aHlPcTFVMkloTVlTdERCa1piNGZsQVZ2R3JhazMyU1dnT1YrbTJBWGtp?=
 =?utf-8?B?cEhnbW5rSTRhOWh3b3I5eVdzQk1zVTh2ckdQODhsZDBpaVZxY0QyVEVaUS9z?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18924bec-e7fc-4387-a274-08dd0378f2d8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 00:20:16.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/bqrgtxujMBPC8QkfmQsbAF2LPSudaa+3DWgfSiGoc9PssI8aS5C4vLj7kxFOFlZPwrWFcK1m2I3llw8lg9v21fQIMF7E8TOuE3qhJ4lbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7882
X-OriginatorOrg: intel.com

Hi Tony,

On 11/12/24 3:42 PM, Luck, Tony wrote:
>>> +static int set_mba_sc(bool mba_sc)
>>> +{
>>> +   struct rftype *rft;
>>> +
>>> +   rft = rdtgroup_get_rftype_by_name("mba_MBps_event");
>>> +   if (rft)
>>> +           rft->fflags = enable ? RFTYPE_CTRL_BASE : 0;
>>
>> I think this sets this file to be created for all CTRL groups, even when not supporting
>> monitoring?
> 
> No. The calling sequence is:
> 
> rdt_get_tree()
>     rdt_enable_ctx()
> 
>         if (ctx->enable_mba_mbps) {
>                 ret = set_mba_sc(true);
>                 if (ret)
>                         goto out_cdpl3;
>         }
> 
> So set_mba_sc() is only called when the mba_MBps mount option has been used. So
> mba_mbps_event_init() isn't called.
> 
> Note that on unmount of the resctrl file system rdt_kill_sb() calls rdt_disable_ctx()
> which calls set_mba_sc(false) which will clear rft->fflags on systems which support
> mba_MBps.

It sounds as though you are saying that setting the wrong flags are ok as long as it is
done in some specific calling sequence. Is this correct? Relying on calling sequence
instead of correct flags requires more in-depth knowledge of code flows and makes code
harder to maintain.
Why not just make this "RFTYPE_CTRL_BASE | RFTYPE_MON_BASE" to make it clear that the file
applies to CTRL_MON groups? What am I missing?

Reinette
