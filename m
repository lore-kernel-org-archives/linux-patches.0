Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD0286889
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770796633; cv=fail; b=k7+f9CeOI9Aqzt9aXKslQXvtd2LxgiiaF4y6nylTUQiC/Wxej+Bo3GbSwLhkztJC5YUhoSfjkfGiqRoo1gaH0zvcoOqBBQk5e+2HRrRPTDMTStgYtg+t04lwKaMukUwhBfc78yTWy5qq4e63jweOPuKuZ7qLh+ui0AASu3U+4EM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770796633; c=relaxed/simple;
	bh=VqHSfMgSvr0J9NQe/nJ4IwtxEJZCbL16U84evNl4Gv8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kxcL0xGER8ZkPFO3FPsCT74uM9JdUqR3s0qCD8M0NmxWeM3706EaWdxpoXnUUM00GzssLbqYIYfhdalTLLnlChqxA4/WJ+drl6Y94+1XKz4fdOJ5SG3yUfP2j2J3BsN0ApOa/baUFDh0H8GkY2dxOqj33PPLyB7wrxRDRzD72UY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PdDxBBVX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PdDxBBVX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770796631; x=1802332631;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VqHSfMgSvr0J9NQe/nJ4IwtxEJZCbL16U84evNl4Gv8=;
  b=PdDxBBVXRarHzpu7tHaRNjcYP1+J66f8yYxF8o3aGwTVproHFKsmpqe+
   tMD5xPCIEbnzQYxH4uErFujSRMl/45swlidmHgWLHhBtzvkcHSklMLIVd
   8by30VkK0vzJ4TAvEQFksUPhTYdkto+W88HuMof/lB4o4I0p5TIALeT4G
   71a5Ru7rx1GstRSg2X1iOUhg8kRFnI+ObSDxOiw79kAdcdKy/xTvmTtxY
   B3zwLr9TR6O5pllIPXMWnX6MMDyievZJTBOcyiR9Dd4lYFP5qkmJKrSWZ
   Iy6KEhZNVOTt1qEW8gJh0scAoI999lJx+9BleRPQ73JMSaeBbyq4KpW4/
   A==;
X-CSE-ConnectionGUID: 6YqtZHntSyqRMSx4OwNv/A==
X-CSE-MsgGUID: RuS9XHtsRUWNaiCq6fS1og==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71835655"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71835655"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 23:57:11 -0800
X-CSE-ConnectionGUID: DmVsULZwT12V5dsEZx25kA==
X-CSE-MsgGUID: GxGThdKMQxGd908k/47bMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="235152588"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 23:57:10 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 23:57:09 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 23:57:09 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 23:57:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUSJ2spZyGfX2GFl5kpPqgda8GlfwdPgP00HSG34RViIcKGBvEiIGSUZW1IiCgbWTCwf6g+XvHufQgY97p7C6FBL5zIPcATs+q7BTTGz3wEmkEcXCmQ3woBw5GQwcIWnpP4WoZxSh00Jeff+dG8iAZ9XVG5aZ7jBRZh0kRxD6Q59e0toII/fn2fAGVapH7iDa+IFtzuVYntzGlamvxtg1TA85abk8HWtPlL73pMnFfCwrQBPTiVup5bMt1slDGU8VBT/BN03kHf+uhwbdGIO6cWc7CWoDJxpYUfLG9Z26624PgvccgqAQnfyrxw7TAkIAtYjFwqoqEeVpCTvQaSwsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y79BzEfTpzBwascXl6XM2K3UTMqYFT8Apf7dCQT93tI=;
 b=WHsIFTmduVwzRVV22+15MH2CZVbvBTG9qHvRELeVnigOFK4fUEAsPuXnGpZcYU8HDocxcVsNr5/cMli0U4sZNtjK8oBtjBh4eB08SOzNa9MR3DDjSLLgUfFCFhsQExZ4Ccx3R3LgOmyxDrjVSFAWm8sda/0ACWmRmW+f0EslJ0FYnqsdBSKrNhZ5Btt8LPwF+iiCIPVegHUQMqMwSvSSO+x/uxrxx2QagMcFLvQjlPZmWwcTuTTSbhGK78/Vptg7qbzYl39yQ2FmOC9a7qPBYhS68dIPyYfC2N1lfrUAQNKdxODGjWCTa9SAFQFehhg66z4z7RYjrOEQEOKtx0GKxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7215.namprd11.prod.outlook.com (2603:10b6:8:13a::13)
 by SN7PR11MB7973.namprd11.prod.outlook.com (2603:10b6:806:2e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Wed, 11 Feb
 2026 07:57:08 +0000
Received: from DS0PR11MB7215.namprd11.prod.outlook.com
 ([fe80::cba:8493:6cff:5cf7]) by DS0PR11MB7215.namprd11.prod.outlook.com
 ([fe80::cba:8493:6cff:5cf7%5]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 07:57:07 +0000
Message-ID: <f9edb8d1-cc00-4497-898e-b3472ce2e925@intel.com>
Date: Wed, 11 Feb 2026 09:57:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.19-6.12] i3c: mipi-i3c-hci-pci: Add System
 Suspend support
To: Sasha Levin <sashal@kernel.org>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>
CC: Frank Li <Frank.Li@nxp.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>
References: <20260210233123.2905307-1-sashal@kernel.org>
 <20260210233123.2905307-9-sashal@kernel.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20260210233123.2905307-9-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::21) To DS0PR11MB7215.namprd11.prod.outlook.com
 (2603:10b6:8:13a::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7215:EE_|SN7PR11MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: 260c4c91-6b07-452f-27db-08de6943275a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y3F3dWdidHMwV3IyNkhSR2JFelIrd2FoTzZjMVhZSGY5QkQ5MlF1OWora1pi?=
 =?utf-8?B?WGVXQStIdFdwaC8yUnJxT2xOdllrSXoyd3o0SGgxQXBKZ1VhMERObm9Yc3Rm?=
 =?utf-8?B?dnVZc1RNU0ROUXM5cW42WUlFaUEwbkc2a3E1SnVSVTl1R3RtV05qbzZVRWdF?=
 =?utf-8?B?TU51NEQ1M3l0cmpWVnhsbHRDTkdub0U2RHRkM2VUMEozbTFWWmhhSVlmMlFo?=
 =?utf-8?B?MEZaRDFKRzdkcHVyNHI5V1YyVURuUXJoM095VFgrYWdrUmVFbFA4V1E4MVZE?=
 =?utf-8?B?TTZNUlRjWDJMSFJBaTNRMXNOZlJ3VjZEN3dOZUpVZDJRdWp3WlpLZE1vZjNJ?=
 =?utf-8?B?dStEYmI2ZjE4bnZ5ZEVRSUYrdVVCZmRlZmJuZW4yT0lIYTl5RDRXOGZpVDUy?=
 =?utf-8?B?bzIwRkVlQVJyTlZTYStEeFU0ZVJoNWNQNldoVVJWOHFzUWdOdzF6VnEwVzVL?=
 =?utf-8?B?ekg1YkJqWWJsVXNJT0l6cmtzejI3MGV1MkF0TDRKR3o1YVBkVm5mSlVhcmNt?=
 =?utf-8?B?ZFNyMDE3NkZKUHhPWVR0cWNmR1VsYmxkcmpwZzYyamtEVjA1Y1hFS2JpQUpm?=
 =?utf-8?B?TGphTFU3a2h3M1h1bTRhQllScHNsNW5RUlFkaGo5WFVZOWdNRGJ2SkRGVlc2?=
 =?utf-8?B?Y2l6ME5lMEs0OG5RbGROM3JOY0F1Z1lRTjA5dWN5Q1lSaFFjdXRRUjhRQUNH?=
 =?utf-8?B?MlhBbVV3djh5THdLRnJadmJMRWV2U1dIdmNPcnFyeVJBUXlOang0TWxlRG1k?=
 =?utf-8?B?Q3R6ckhKUDhyZkJlMitpc1FjamM3aFlybyswaWZleDZwQ0lGNmk4TWFuR0ls?=
 =?utf-8?B?Y1JSZWFHaGVGbXYrTGh2NGJlaVd6NVk3U081VVRJbzRXcDcydDB5VTRsTjVL?=
 =?utf-8?B?czQ0L0RLT1VtdEZUQXF5NDV5NGc0MXBxT1I5bnBrRHphZUxxTTE3cG9uT2hV?=
 =?utf-8?B?eGtJYXZGMFhlakh4cW04aUV0RlNnajZxL3FrRm1BVjg5akhRUThlL1hESktY?=
 =?utf-8?B?cWpWYkhFNVZnUVFWVHN4VEdZZTZYdkZQZDBCT0JLdmRUQUlyWDU3eGg4M1lO?=
 =?utf-8?B?alVuK212ZGw3bkREM1B3cEZvOTZsNU4rSTZPUHZHdm5OTUI4NnkwdUptWXZN?=
 =?utf-8?B?TXhpamo4QWNYNlBVaTF3bmNZVHBqaTZnY3BWdW5TZjhaVXRYd2RwMWJzOFUx?=
 =?utf-8?B?VUpSd29FZDVJcXo0TjRNWnIyLzlpSzlLN29icWo2cnliMzEyS2N2QWFtSS9p?=
 =?utf-8?B?cmN2WGQrS1p4Wlg3RkcvNmdacFFSWXBXa3JpdlNMeUZpOStHSDVROEZ3M1k5?=
 =?utf-8?B?Mys0YTQxc2dFa2hzYnhaTmhqbTFURXE4bW9wRmd6WWlPM1NOSGtuOFJOU2JR?=
 =?utf-8?B?RzVQTEMvRXVYamowVm8valdRczIvd1Y2bzZocGg4eHo2ZWtmQXJQSC9BbTFO?=
 =?utf-8?B?Q29RWWlOcjZiOTBaM0VpSTVxa1ZuU3pwbEVqbElGZDFrNnoyOXcvZkJzNm0x?=
 =?utf-8?B?L3BISjFXakpkYTRsaHVjZHFKSk42aDNNWS9DeStTS3dCc0FiNGVUWWt1Q2FX?=
 =?utf-8?B?dnBsMGo3Tmx1TVpNdHk4b1NFeWpmV2FLcjVvejdlSTNHcWZEa1NLakZhK3B4?=
 =?utf-8?B?WjI0dm9yWU9MbUpzNldYR29CZHlLZHhidVY1dVZ5RWx5a09FUlh1U0Q5NjhN?=
 =?utf-8?B?OW1uOVlDdk94U2RTZy9SYnNsUEdZSG5pMFdhVFFBQW5rZHdGOXNacC83RUxy?=
 =?utf-8?B?UWIvL0dtUkRTamxjYmY4Z0o2ZmZ4c0t3Q0Y3b2gyelJhUG5zUGRLODRHdjcr?=
 =?utf-8?B?emF5S245bEVlSC9MQ3UxM2NvMGRMbmhaSGhGVThDRHEwcDJ3Ny9qVzhxWkJ2?=
 =?utf-8?B?SDQ1TExRTDEwdnFTWjV3WXlnZ29MZ1YwWmJWNERpcFR6d2E4anUyRE1qcmF0?=
 =?utf-8?B?d2NYUWdSVktxbjBHbC9oZGFld3JVbFZTdG4zeUptanpKSTVCRXNDNTJtTlNx?=
 =?utf-8?B?cXBWYXpVUVZmekZYa1E3eTU1KzB6TUttUWtCM1Y2VENGSkxhWDZYYlNtN2E0?=
 =?utf-8?Q?VbNMC6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7215.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXpIS212NE54WmdsMHlhUGRqL2dBaGVvaThOTDh5MHg1VGp0NkQwTzNPR0R4?=
 =?utf-8?B?ckNVZ1FFekxmTU8yNUhEQ1lCdjVqZEhpc0l2MCtJaTE5SWRHaWZuamo3VnNH?=
 =?utf-8?B?NDFqVDh2S2l1WDkyRUFhRVdYbkZSdXZtajF5eUFGSHF2akZwc3k0TGxsS3Bw?=
 =?utf-8?B?bFlFTnFZdXQ3Rk4xMW9jQ0pFZVVUWTJIZk1HVE5JV2ZwYi9pbUtxdHZqZktl?=
 =?utf-8?B?RlZSSm5kQWwzYWY3azIzK2hUQVFJd1B2d29jcytDem5PaHowWTVlT3JtZnpS?=
 =?utf-8?B?U05sT0JCdWhVcE1qV1l5T1QxVnd0ZUM4TUlTL0VnZ01zSEVLQnVVak1YVGsr?=
 =?utf-8?B?TEg3R2c3Q2tuV2oxa015TUdHS2lNTjRYNXdjS0x2RlBWMk8venVldEhXanNJ?=
 =?utf-8?B?VlZ2NEx1a0Jkd01YL0hWTWtNWmpqU1E2aWxraUQzdVh4c2FGRTFQKzRHUTcy?=
 =?utf-8?B?S01RNEk2L3BKMlBSSVJVN3JsOXFNTzE2bXhCR1F3aURMQy91Y3BFd1IvbGRF?=
 =?utf-8?B?MkQxUjhLZGMxdTlGVVBJQ1hZb1FFa0ZhSXZXRWRLaGZxSDZ1aXdXWTdIUFNl?=
 =?utf-8?B?OS9wcmxJd3NwVUlwR1NsNms3Nmw5dDAyeHFhT0ljZkc5cEgzNkFBME5LWllh?=
 =?utf-8?B?aU9kdlJlT1JYY0dJTVJvY2tRT2xpVGJCL2doL2J1VUpKeTRCY1NyWlU3Yngx?=
 =?utf-8?B?RDR0eGF5VVF3NjBmRlM3azRBQThSQXBGMnB3RjhYRC9WdUF4T3FiQWx6ZE1s?=
 =?utf-8?B?SUN4eWk5UzUxOVlUU1ViQXRNcFFuMmhVd2NSQzlXVXdsRCtLMWpzUmxycm9o?=
 =?utf-8?B?NEVURS9nU1JuRVhSMVdUek9lMDZxTTlyT3p2MHJBdlVBNGpXdW1Tam83S0cy?=
 =?utf-8?B?Q2tTUjM1YTI0Vk1UTEFycmVsV0Zucm5abnJGcjlVMTNVS0Nsd242czhNYm1L?=
 =?utf-8?B?TVhKZnVNaGVrUU9KNFNTclJKS05OZFZpT2JTNXJGaGJYTDFhV3Z2L0Vwckdn?=
 =?utf-8?B?VkZPcmxrZGZubWV1akZ0YUkyNnNDdHZvOTZ0UHZSbmNJbFdrU0c1b3dhSjMx?=
 =?utf-8?B?aDBONWI1QUxZelVIZ20yNExDVkNZOWxaWVNLMXN3Tm9VVzUrcklqTjI1ZUow?=
 =?utf-8?B?dmx0bzk2SkhUU2NhN1BDemJyWWdwc3ExT0dFMThZNitVbU9yTk9TT0hxWnlQ?=
 =?utf-8?B?R2EzRTZ2YlZtOE9MY3A3dkpVenovN2IxOVZzRGl0ZWhDbWkzVEtiemVFYnJT?=
 =?utf-8?B?WG5PNS92OVZuVThjK01KKy9pUEFIZ204QThKZHhqNnpNaFBUMFJNRWdlY0Fq?=
 =?utf-8?B?Qy80dmVBZzhwTWdwaStHU01pSm53VWNHai9LZG1rQ3lacEhaYlhhbVE3YXdZ?=
 =?utf-8?B?cjdRbGN6bUFvUklNMGNFQ0tOYWdpeDRhQlF6YWgwZTZQYlhEMWNRQ3hZVDZH?=
 =?utf-8?B?NWtnM0xZd2pneFlMOTUyeks3YXZ0bjhKaDR5MXRLNUhhMUFlUTdISEhMUHB5?=
 =?utf-8?B?RStWaGFZSkVOZGRHdFJBajloS3VtN2xwSStreFY3RnFSTTR0RnVWME1FTlQ0?=
 =?utf-8?B?VHdrVVphRHY5d3VFSHEyNENiL2dBZEQyRUppamx6czllZytQd2FwUWFYMWJP?=
 =?utf-8?B?KzNoZWxYby9udk5jRFN5MFg1ZnpaeEZ2b1c0by9MYW5pUWc2aElsNmdYWTdK?=
 =?utf-8?B?S1F3d3hkcjFOa1RDRHkybjlUNkZ5YmFEOHFmYzRJQkNURGRDV2YrMllMK3I3?=
 =?utf-8?B?OUxmY2I3YXZpcmFoVXBuU214bk1JVHdqbC9OOEZCUFExaEY4dCs5aWlTTHg3?=
 =?utf-8?B?eHU3RkYrWlZxdTlhYit2UFJ4QnVOK094YW1zS1paMy9qc1VHWDNlUVFnV2Yv?=
 =?utf-8?B?ZUdEVlMrY2E0dHduNS8xcHVyb2FMZGFTcHFLL0xZTTlpYS9TMEdKanB3WXB6?=
 =?utf-8?B?R2dEYXhlMjRkYXdFUC9uTnFub3ZKT1ZHakxzTEZEbys3bmcrUWFJWWpOcXc2?=
 =?utf-8?B?UFJRTlRXNTVoYkNNQkVrdkpiY2k2ZU5qcE1nYUVpRlo5Ym10UmpDUVhqOGs2?=
 =?utf-8?B?Tkp4RGEyUFkzT0pqaDhmWEUrVUtMUnJUUkgrQmNYU1hhWmp3Tk4yUVBmSTZt?=
 =?utf-8?B?Tkxic1ltbVc1NVBDWFlOUzVzcHNDSjNpZ2tSSkhRbGhxSlM2T205T2tMc2tW?=
 =?utf-8?B?VENuZjZZTWY2OTlVaGJCeDhyQVNxc0syZ05nbDlCUlN1OEM2N25rVy9Wc0VG?=
 =?utf-8?B?Z2FpWTY4NE1YVmFFWmp6bjNsQWZPZ0tZZ2dZc0lITW1meHZDb21EV3BIQWJ6?=
 =?utf-8?B?S1F0SXdHUFl2VHlwWHp5MmhNN2Q0cDdpS0hKTGRYbjBmWkpXV25kdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 260c4c91-6b07-452f-27db-08de6943275a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7215.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 07:57:07.8502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEOleYVdJO3OFEk5pDFcTUB1qYJdeD1WvxrHAVHlyAezsULOMZTEr5znD8DGEWmpy2UfJtneKYbIs3NHRg+Xsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7973
X-OriginatorOrg: intel.com

On 11/02/2026 01:30, Sasha Levin wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> [ Upstream commit 4280197d154cae1d1d5acb54484da26da04eac32 ]
> 
> Assign the driver PM operations pointer, which is necessary for the PCI
> subsystem to put the device into a low power state.  Refer to
> pci_pm_suspend_noirq() which bails out if the pointer is NULL, before
> it has the opportunity to call pci_prepare_to_sleep().
> 
> No other actions are necessary as the mipi-i3c-hci driver takes care of
> controller state.

Back porting this patch by itself makes no sense.  The entire patch set
and previous patch sets are needed to support power management.

> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Link: https://patch.msgid.link/20260123063325.8210-4-adrian.hunter@intel.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I have a complete picture. Let me compile my detailed analysis.
> 
> ---
> 
> ## Comprehensive Analysis
> 
> ### 1. COMMIT MESSAGE ANALYSIS
> 
> The commit subject "Add System Suspend support" makes this sound like a
> new feature, but the body reveals the real story: it's fixing a bug
> where the PCI subsystem **cannot put the device into a low power state**
> during system suspend. The commit message specifically references
> `pci_pm_suspend_noirq()` which "bails out if the pointer is NULL, before
> it has the opportunity to call `pci_prepare_to_sleep()`."
> 
> ### 2. CODE CHANGE ANALYSIS
> 
> The change is extremely minimal:
> 1. Adds an **empty** `struct dev_pm_ops` (no callbacks):
>   ```c
>   static const struct dev_pm_ops mipi_i3c_hci_pci_pm_ops = {
>   };
>   ```
> 2. Assigns it to the PCI driver structure:
>   ```c
>   .driver = {
>   .pm = pm_ptr(&mipi_i3c_hci_pci_pm_ops)
>   },
>   ```
> 
> ### 3. THE BUG MECHANISM
> 
> The critical code path is in `pci_pm_suspend_noirq()`:
> 
> ```863:866:drivers/pci/pci-driver.c
>         if (!pm) {
>                 pci_save_state(pci_dev);
>                 goto Fixup;
>         }
> ```
> 
> When `dev->driver->pm` is NULL (as in the current driver),
> `pci_pm_suspend_noirq()` takes the early exit at line 863-866: it saves
> PCI state but jumps to `Fixup`, **completely skipping** the call to
> `pci_prepare_to_sleep()` at line 895:
> 
> ```886:896:drivers/pci/pci-driver.c
>         if (!pci_dev->state_saved) {
>                 pci_save_state(pci_dev);
> 
>                 /*
>    - If the device is a bridge with a child in D0 below it,
>    - it needs to stay in D0, so check skip_bus_pm to avoid
>    - putting it into a low-power state in that case.
>                  */
>                 if (!pci_dev->skip_bus_pm &&
> pci_power_manageable(pci_dev))
>                         pci_prepare_to_sleep(pci_dev);
>         }
> ```
> 
> With the fix (non-NULL but empty `pm` ops), the code:
> - Skips the NULL-pm early exit
> - Skips the `pm->suspend_noirq` block (callback is NULL)
> - Falls through to `pci_save_state()` AND `pci_prepare_to_sleep()`,
>   which transitions the device to D3hot/D3cold
> 
> ### 4. USER IMPACT
> 
> Without this fix, the Intel I3C HCI PCI controller stays in **D0 (full
> power)** during system suspend. This has real consequences:
> - **Higher power consumption during suspend** - device draws power when
>   it shouldn't
> - **May prevent platform from reaching deeper sleep states** (S0ix/S3)
>   on Intel platforms
> - Affects Intel Panther Lake, Wildcat Lake, and Nova Lake platforms
> 
> This is a known pattern - other PCI drivers like `surface_dtx` and
> `aggregator/core.c` use the same empty `dev_pm_ops` trick for exactly
> this reason.
> 
> ### 5. DRIVER EXISTENCE IN STABLE TREES
> 
> - **v6.14**: Driver first added (148 lines). No `.driver.pm` pointer.
> - **v6.15, v6.16**: No changes to this file.
> - **v6.17**: 1 commit (Wildcat Lake-U device IDs). Still no PM.
> - **v6.18**: No changes.
> - **v6.19**: 13 commits (major refactoring). Still no PM.
> 
> The bug exists in **ALL versions** of this driver. However, the diff
> from the analyzed commit targets a codebase significantly different from
> any released version (references `intel_mi_1_info`, `intel_si_2_info`,
> `mfd_remove_devices`, `mipi_i3c_hci_pci_rpm_forbid` - none of which
> exist in v6.14-v6.19). This means:
> - The exact diff **will NOT apply cleanly** to any stable tree
> - A manual adaptation would be needed, but it's **trivially simple**
>   (just add the empty struct and pointer to the existing `pci_driver`
>   struct)
> 
> ### 6. CLASSIFICATION
> 
> This is a **bug fix**, not a new feature. System suspend is expected to
> work correctly for any PCI device. The driver was missing a required
> piece (`dev_pm_ops` pointer) that the PCI subsystem needs to properly
> power-manage the device. The comment in the code even says "PM ops must
> exist for PCI to put a device to a low power state."
> 
> ### 7. RISK ASSESSMENT
> 
> - **Risk: Essentially zero.** The `dev_pm_ops` structure is completely
>   empty - no callbacks are defined. Its sole purpose is to not be NULL,
>   so the PCI core doesn't take the early-exit path.
> - **Lines changed**: ~7 lines added
> - **Files changed**: 1
> - **Reviewed-by**: Frank Li (NXP)
> 
> ### 8. CONCERNS
> 
> - **Dependency**: The exact diff won't apply cleanly to stable trees
>   (context mismatch). A trivial manual adaptation is needed.
> - **Hardware newness**: The supported platforms (Panther Lake, etc.) are
>   new Intel hardware with potentially limited user base.
> - **Not a crash/security bug**: This is a power management regression,
>   not a crash or data corruption.
> 
> ### 9. VERDICT
> 
> The fix resolves a real power management bug that affects every user
> with Intel I3C HCI hardware doing system suspend. The change is
> trivially small, zero-risk, and follows an established pattern used by
> other PCI drivers. While the hardware is new and the issue isn't a
> crash, broken system suspend is a significant user-visible issue - users
> with these platforms will see higher battery drain during suspend, and
> the platform may not reach its desired sleep state.
> 
> The fix meets stable criteria: it's obviously correct, fixes a real bug,
> is small and contained, and doesn't introduce new features. The empty PM
> ops structure adds no new behavior - it simply allows the existing PCI
> power management infrastructure to work as designed.
> 
> **YES**
> 
>  drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
> index dc8ede0f8ad8d..f8ac1ae371cc9 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
> +++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
> @@ -265,6 +265,10 @@ static void mipi_i3c_hci_pci_remove(struct pci_dev *pci)
>  	ida_free(&mipi_i3c_hci_pci_ida, dev_id);
>  }
>  
> +/* PM ops must exist for PCI to put a device to a low power state */
> +static const struct dev_pm_ops mipi_i3c_hci_pci_pm_ops = {
> +};
> +
>  static const struct pci_device_id mipi_i3c_hci_pci_devices[] = {
>  	/* Wildcat Lake-U */
>  	{ PCI_VDEVICE(INTEL, 0x4d7c), (kernel_ulong_t)&intel_info},
> @@ -287,6 +291,9 @@ static struct pci_driver mipi_i3c_hci_pci_driver = {
>  	.id_table = mipi_i3c_hci_pci_devices,
>  	.probe = mipi_i3c_hci_pci_probe,
>  	.remove = mipi_i3c_hci_pci_remove,
> +	.driver = {
> +		.pm = pm_ptr(&mipi_i3c_hci_pci_pm_ops)
> +	},
>  };
>  
>  module_pci_driver(mipi_i3c_hci_pci_driver);

