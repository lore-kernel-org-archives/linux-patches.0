Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375731B4156
	for <patches@lists.linux.dev>; Thu,  7 May 2026 20:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778186600; cv=fail; b=ta40rB1s9KUdJ0M149doGgn79niV0tXCCPRTO5ngvjsyX1s4itkglbK9cr06yU2y3oyKdpFRHwXqAXe5gAXmBsZXS4qYKOQazXrhpdoYGYA0HAciH87XGMP5N/SK9JdEMkOYu83WWTmI5aOzri35vYo4LuQyxGFM35u6xmhQPF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778186600; c=relaxed/simple;
	bh=FXtkD4TP3y2Luy0RDYfUSfZw0XT7q6q6FSzlVv/Rl/4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ku5RIXNnxigrDBDDta4Z0xPFI+p/mlMv1gdRnqVdN9zgGA1yA2hPUHKw/WrLVmKb91W2tHfQgmqNX9LVhCEd4KF2fcOTsKr3+2FGgRl1SB3zp9gc2jZHhSRxEUpA4hc3zinMeJt0Pq3vtV4Hxk+tEybOxTBnW0FZfTwBXQ5pkpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VlYe5nFH; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VlYe5nFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778186599; x=1809722599;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FXtkD4TP3y2Luy0RDYfUSfZw0XT7q6q6FSzlVv/Rl/4=;
  b=VlYe5nFHaP1NbqA2ltxhwVKJwDtP3wpUlEbjDedhHLziyWQlI1GpVU6P
   ISxjNhXBG/ZakHkzfGRYpYEhFdnYSF+LJTR9TxolUHwGlfkoTmlIXzDDg
   3n7AYcCSBxQljB3kAmd3mFmNG+O/QEXU9eDkUr8R/PywP9ishJbUbWGU9
   Ouk5EJBu3wxiErCEW42rtAHokubqR1J2uNXDcwdgiVtvDS5Qv65b/nMmz
   eltTkwg29cwihkDG6mWzkQZcEmE1AQOF6hdGQF15mPx/6K+TUskQnHIYb
   Dw6nDaoyIzcDJQbcNIP/KxlkfNatR1EmbbIvAsj/xWj1yNucwH9jJjsTb
   w==;
X-CSE-ConnectionGUID: arbrWTolR0KCpJO4HeMj/Q==
X-CSE-MsgGUID: MRcZZNvITdeTD6ZDePS3uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="101825531"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="101825531"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 13:43:19 -0700
X-CSE-ConnectionGUID: GpCDN8BfRA2JEheAkjPyTA==
X-CSE-MsgGUID: haPW8KgSRqOu/Y8WhAzQdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="266941366"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 13:43:18 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 13:43:18 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 13:43:18 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.49)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 13:43:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnQGLPZjS5Wp8TG3MOhm+LccLnX6hpbJsIalq6CSbS1TDXq8I5coc4ranBfr2ZbqR6Q+e04KZCtdCimd7FB7ju/BdQ7GP0g00+diHKcWOFzy3RuswPSWIbu34v9khLc3TloKtZRKHYUYkiQ1mE1uaPuw6ShLdwVNpDq+jrGoQvlok4Xx2ubse3nu3yq3xnhu4qHbCQ3FpXTQUu7D4bZB3qVtNb8p0MSGPwYUdvArkpmQjWuf1GE2oO5v9Hc4tt52SczwaG4WUEIT/02viMfUn9+sVBpa6bx03FsncB7AZRAh6bwYU9Yj87gc/ORbH/daiMx8tPHb0rlL4keDU1oqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EarYjFh1n/5IxCKaU3flYnNYWo1Au66+i45Z3hhU570=;
 b=IhGgOgPKbgdHWRhckBjI97kok2k3sXmmYMEomknrPpb0Ytxezk6n/4OnIck7mICl/SW3JkPJl+GdrXG8Ek7dMCpyIsi9IcRsJZp9G7fENSwF5Ea3AMVXOjmUlb/unlP9/IjNMLaozNFX4WhP+PRnjSNveHmNkr6a/nVLA7W3JbY5rresLvOuebEs28EFhl8Dqycu2p2Gf1/VHKBWLgD0sNSV4ALpNL+bzWlonLWV6NMsfMtmvOQVxSeLqeNDK9AK74L0GnB3PyFxJ4Oha4ZAsf8ZUMM9LqsEyU4aS+7EKKJwyvDOm6NDhSDLcZOmxyY0RbUut2aXsHRA9cSo64kukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8357.namprd11.prod.outlook.com (2603:10b6:930:c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Thu, 7 May
 2026 20:43:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9891.015; Thu, 7 May 2026
 20:43:11 +0000
Message-ID: <b06b7660-32e1-4dc4-82a3-63ae9cc21d80@intel.com>
Date: Thu, 7 May 2026 13:43:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
 failure
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260507201730.16509-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260507201730.16509-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:303:2b::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8357:EE_
X-MS-Office365-Filtering-Correlation-Id: ee7da915-36cf-44bc-0b4f-08deac794125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 6yEN/T5wR2nAzCcz/c480jn0HY57SFippIinWi8mJeyzuUdJJG8iv/3V4ii//5AuKcNCOdennUg6sLewZgBZ7AWQagBL/PGjMwEVdDHt5Nxi8AIpfBWXtmqR6N7lvaZkulet27NgMyiMgYqAlrL6ysk8TB0UwUhnvtMHq+B4n05AysRFDgYh09QYEkECTudAaXyxPQje/y/5WuSwR81XRo7v+JBD6zI8Cwy7keeJdmQw7fHMUO7REyON+WsEonvBYETK7aC2Jj7kkgG0BqxIcf9XRCntws3+X+jXqL/eh7PFGfiLQr3OdYA/+bLrw/D5baPjtSy7IV5/morHuVwjFaINRGftBdhhB+8+GnxvPZohnhAbz/pTd9pu4MBZvRT5+6syqtrKZfwR4du5wQydKWdgu17s19Ss+QtmBfCC0bGb/VkxQq/aO2bvMUjW881aVX4dUL+OKw3D7vO25x4zkqRkKhxV+aHABP1CnEI0ywz9N+H2dgzet54CHDtzDYYGL9p2xvOWAW1EeofRG0MXoLB9CZJacHf9HEwQAoqVZ/niGVoL6KT4GFcF9uD75SKZ9Z/XgzvYrQJ8Ti+OOURPm9Sk9FOo9wJmLV6KJZO1XE4LAhkuYGnfT/EQGdl2YKlzlIR2S3nEdyahDiBsKvY639ItLZ/XYPNoM2T/hhjbF/LoRz20a50ErnC7Arg3eHXbmp8N69y9WKrcIdn5jUq1DQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW85cVRQSlUrOTY0UUFFTG9sWWphM1JHRllTcmp3UVdscWV0Z3ZhT0pNbWps?=
 =?utf-8?B?ZUhhdGVJNVIxUkwyVGdMTXg3Q0ZOWUYwZHB1WXJvRC9SQitVQlVDR3N6cFB3?=
 =?utf-8?B?QnJFV1ZhMGVTSnZjdURQUnJUd28ralNXeE1BN3hLYm9BWUtwSWR0eGJoeTJk?=
 =?utf-8?B?S2JZTDFkY2ExZnBWOEZMR1NNWlhyU0JrdVZYK3oyM0xZeTNYbi9OOWk4UmVy?=
 =?utf-8?B?R3NrVUhYVWxNemp6VUxLbHRsUjdZbjFrZ2Z2TVQ5Q0NuOHZwdGkxWHFWMWsx?=
 =?utf-8?B?eFNGREFTVHRpUXk3dXFjM2ZPelcrbldYWGhDaXlMd1dkbXBNN0RoYWhLbWNM?=
 =?utf-8?B?SkI1eUt6VCsyK0ZhQ3BLMjNDSVZQd3R4NUUrTjh6S2cyVm5oK0taeXVCb2JW?=
 =?utf-8?B?ZkJSM0JVYVl0WVhoNFFneEQyOExDd2dzZEV1T2hCQk5aV2YwdlpDSjZObUFX?=
 =?utf-8?B?U3dnKzQ4LzFNSVBCZS90M0ZXVUdOZEtkOEhGeU5lVkZqSWx4Z3JzYWFWeGhu?=
 =?utf-8?B?eVQ5RG9pZGNxOHk4NTBPZFk4QnpBQTBNcnlEblhXdDhKU0syUjRzS2tOaVZJ?=
 =?utf-8?B?ck5ZejBveW42QUpONFhDam1nQXdxcWVCWk5VWHZrR3ZXTTIwYmFVRTFpb0Qx?=
 =?utf-8?B?NzQ4QlV5VnBmOXdsSFFyY1g1cThEUHhLQmRzeklTaDNFOGdQYnJkSFh4UFJY?=
 =?utf-8?B?ZytwdndIVGdZbVFpZTRhbk5yK296bjJYQ0I5OGNOdVhFRERKTVhIMDdKVUZl?=
 =?utf-8?B?bVcwYk9iaE1yV3ZFbkNEdlo4ck5DS1BBaW1WUmZLSllldzFlSXU2M3loVXhq?=
 =?utf-8?B?bkhlMFVFeWRORlAzcWVwYS9SOTFCVklQTXdVZWgyNmdJbGZTbGlOTkNuZkd0?=
 =?utf-8?B?Sm0wSnpYaENWdHpnR1lhV2VEeUQycTdVZHFDemxHd1NyOUcyNERRd0JkRmdj?=
 =?utf-8?B?Ulo0bjAzeUhDR0dzYjArcU5EK2xoeVJWb2krbGg0b1NWSXIxd0Z1dEN3eXcw?=
 =?utf-8?B?RXdLMVhnNWFXQkRVc2dUMkQ2alZickxiTklNY3VtTjJNRUMvTzFIUzU1aFdj?=
 =?utf-8?B?OStJRUdFazNwTVNWWXZ0R0c4d09xT05UYVFEbXhGS05pZG5hY21yNldqNWRQ?=
 =?utf-8?B?cnB2b2pkbERFejYvZ2ZNY0dtRWlNVzdzVjJIckoyTDBkZUxBY3NGRU40K0ow?=
 =?utf-8?B?ek8wQzhrTkpzRXFkTVcyVFRZME93bWJDVUpiM2NVRE83OThheDJSQ0lTRmRN?=
 =?utf-8?B?U0ZJOE9nRFZEZmVYNk1ZcmtkS0d6dVIwTElveWdWTEVGcEZnT0NwWldpSDB5?=
 =?utf-8?B?K01JNHBkYk9RUHJ2dm5wYlZEUzFtcStZNmRQZkNPdm1hZ1lKYWdzS2RYNkZ6?=
 =?utf-8?B?c1Fvc3FhWlQwdFJjYkVLbmF2K2pQZDNtU0d0cEtyVnBOSjgydFVZdWs0NDJW?=
 =?utf-8?B?VHlTVzZoR0VEMjFwNCtBV3ExZ3hpamZ6SkZPUkFWTXFibzdOdGtUeW8vaFp6?=
 =?utf-8?B?eFhBejRSeis1SGZld3U4UGNoSGlIMHBKcU1tZEp2aGt3ZDZvYzEvSFMwV0d3?=
 =?utf-8?B?aldROXZ1cVhSZHJzMzBZR2VkYU5iNjBaWnoybktETnJUSzBLTkdzVXpXK2pO?=
 =?utf-8?B?djBiZ3R1b0wzRllYS3A5amhZNk9UWWg5ck9tZHVXZEVFNEo3V216L1hieFBa?=
 =?utf-8?B?S041c1lpRzE1bERWSFhnbTl1cUFjOFRSN2I1bUM1SnpMY1VXVTFwOVFpTnVo?=
 =?utf-8?B?RnU0akw1S3p5Z1p5Yi9zUHpUdi9mREZheUlUVlRweUYrV3duK0tSd0Z0d0JT?=
 =?utf-8?B?RW44NEp0N2FRVElJTXJlNy8weUNlQnozeGZkRE10N0p0UWlseGFjZ283RnZC?=
 =?utf-8?B?bURlVThwZHNiblpPK0s5dnZLR1pVYWZtZEw5L1BHVXY3dXlNU3JMck5UVldv?=
 =?utf-8?B?RURSNDlSNWRzNUdkMDdObkF6QXlxNmhJMkRWNXRHZzVDc3U2QjJQeVdscmtX?=
 =?utf-8?B?Y0J5eCtvL09laGtOTnZveGFBRHIwbVNwVHpuajNXYkJSR1hhNVVxbDQ4S1E5?=
 =?utf-8?B?Q1RISzNyZzRxdXFCb1lpcFJpeFY5VkU0Sk1xRFBFYmlwdlJEczIreWwxZzFT?=
 =?utf-8?B?bElveVp0ekVWM0d4aUozdStOZnovdVUrNXVxS2RhK2tZcTY2VmNpUnhPelRp?=
 =?utf-8?B?d0ZQa21QVDFSNUV3QkNkZTBUN3NyOCtpNkorcHBtSHNPWmNvcHdxcStlRnBU?=
 =?utf-8?B?WkI4WGhDUEpIdmZUd3NKMitXWjgyUVVaUDQzcnFzM3BEeUhhbnZVTy9hNVIv?=
 =?utf-8?B?R1FVUlc3d0tGc2xuNTRERnN5MXlVVUFGdWJxRU5rNTBGYWYyYXRaUThRYnNu?=
 =?utf-8?Q?i2vI/S5SwKFTz/is=3D?=
X-Exchange-RoutingPolicyChecked: DDmsAAH7Pxu161C5I5JvfEFW/q3d+KcCCgKCUQMfEExdI58CohlQ1FYLxcx8VAMci+lquJz9x11+bMK6C0uJob0YEbilHFQK7PiSeZia1cnMmbeth8jm7qqRDF0KOYY8yfmMOVdHNkJkLpHNAf/GfuIJdeOzxx4T+LEWYhD73vcx3nHP3QvHp0pbEx+bloUt4E3stZXC2E6YAwo6zY/ULgbGn2/d508G8qUIF8bVjqFAWrRCNeJm6sqhBXcbZEsQqn2v/cVkPvA45ALpNM1Q9VgoCZvJ0cV/xbktB+jLaHY6OJzA6zKaTfJd7sed0eBNtyUlw58erekEE1y0NpQ9VA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7da915-36cf-44bc-0b4f-08deac794125
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 20:43:11.8311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKdBAZxLYoMaypMMuotUw0LOCSKCfTtlAkftji1302qyDQbgxXvUCz06MB3gsNF6Qnk8WcgHyE0Djgttbj0x7J4pkveRONUsOGLB/m1Stek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8357
X-OriginatorOrg: intel.com

Hi Tony,

On 5/7/26 1:17 PM, Tony Luck wrote:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5dfdaa6f9d8f..aad573b62fd7 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2879,8 +2879,10 @@ static int rdt_get_tree(struct fs_context *fc)
>  out_psl:
>  	rdt_pseudo_lock_release();
>  out_mondata:
> -	if (resctrl_arch_mon_capable())
> +	if (resctrl_arch_mon_capable()) {
> +		mon_put_kn_priv();
>  		kernfs_remove(kn_mondata);
> +	}
>  out_mongrp:
>  	if (resctrl_arch_mon_capable()) {
>  		rdtgroup_unassign_cntrs(&rdtgroup_default);

From what I can tell the other [1] fix will conflict here. To help manage dependencies
I thus think it will be simpler if these rdt_get_tree() fixes are grouped in the same
series.

Reinette

[1] https://lore.kernel.org/lkml/5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com/
