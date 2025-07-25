Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773DD188000
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487111; cv=fail; b=EczP0kOVvN3kQrFAwk8j/JavXHDZs7Eew8kigeXWmpuns8dgsP6i8CtVFdW7TivWRxGUBKzH4O7pct+K2FzsAcBXQl5KUSZ/+TZuZexcBvggKBgqgs2Fl5n1Ih3QH5o2xwVAUYusJ7ZeZxV4kV3p9kwAUA460sEWIxBABRQpcIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487111; c=relaxed/simple;
	bh=U543dBYVjIi6C3tWDqTXIUhffIckO4HCmKX/ktIX4lk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I7GgnpvpLnAPYs9PFSI83K/lTuvetMcHJHpoYTMYOsoP0lbA4XUOi6yzdbW1Bf9Nea8q5BbkdwZB5hVsoAbIqaI6Ht1AJ+Kr9ULOhZCvBlNF6cRFnz/6qWcqG+ae9O+mlxQ3U6L3eqGVF+NZfCPisEsjvqoij5ZbVdLnhZ3e7PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBkXYw/J; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBkXYw/J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487109; x=1785023109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U543dBYVjIi6C3tWDqTXIUhffIckO4HCmKX/ktIX4lk=;
  b=KBkXYw/Jgs4jWTvLR3GSjVQQFGDek0Lr8qO5zKubR/z4KqE0g3ijrrg5
   grMygz2FYTh9joVvdTaupYArw783mstKyxNAEUEWDU/ZkKf8ArrgpiYAq
   1qM0S8bsbflqozA0KQc33kU+FLXFmGxN73VDc4rWcgQoRSNIBVptB1mbJ
   cHozUu+uClTxzdP18CNnL2qhFcmuZMv0K4dZGYPaIhIT+ybgF1tRNS9WG
   65el7Jj5uwRr3HwaT0LkTjwugFAbzqUmnXnesQQ53Wu/RGJ3MYFwFka2b
   wJBGNqLnVyiJbgq5gH94R0bp7D62L8eFQBfd+laQpGDKpsgIq7dWsCBih
   g==;
X-CSE-ConnectionGUID: gDXYKBAoSU2lI7wXQBKqNA==
X-CSE-MsgGUID: t7cnbSe2TJaaXsDB80Itig==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55039742"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55039742"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:45:09 -0700
X-CSE-ConnectionGUID: 4XrJAj+pR9WKzPQyj0nRsw==
X-CSE-MsgGUID: EK2ZcCRhTi66HHhK42F+UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165697995"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:45:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:45:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:45:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:45:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sU7KMTiRjxHSNq9bj5ndtBVktoJJUOtQQH6yr6tGdfh8ynuOSUloK+r7OL83HXhdqRayiTlZwtk0jAoQnAG1FRfJoZfU31Nfsmy3Jf8LubNOjYjkBNT2Nse3CTowctSenrzsidzYjd7zf09t2iB+bMPxEIqc3u5nnEbLypQVD/lQMQWIPFnpWHA7pNzyjN6sWFbI9fyQyfhnWW68HA/5IW0asbnF0QeFvS00YkPQitWTBRRzaYXyktRCAsaDpNJglEzQgB1Obcc40xWsjbcaZx1qR3LufCvrFu59RhVHmF7QRUqrHelqcsz9ADbrs6p+KPVFn9Ev+siTGFcEBnyfRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tf3HRa9zPD2BP0b7Ir8T+bxNveFoGPJAwj5J6bRsDc4=;
 b=Voxklg2mwfOkhG3nu0iYeKkkz4TcKM9olEfpGAXncvVyOl5kzbV4Dw4mPVWZCMaCGjaZ2Cev81BJaZW9ORQif32lzCG/95Ibf1PC5bVldDHmlvbYaIILa8eje4CDXRsBc4/Q8UIxf6YcxZ4uxrzh3zdXCBzBAESloPHTQgxIhimUhRkyqMf4dP89evRuRsbRGCy2jd5rPgVS7bRvfWblDrpBl09Od2YLOyDOLTWtU+mgQXwVAsZuF0m2ovOdmkcd0F/cUU6mCYcStjR/4jfnv3lqEMeu+32LB4ZX4xPdyZFKLtQ+q9Cq2YXFGzp3WhVcoFJdvbYPPhici8w4LvBKUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:45:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:45:06 +0000
Message-ID: <bf760139-4401-4fe6-8926-94ab72aeaab6@intel.com>
Date: Fri, 25 Jul 2025 16:45:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/31] x86/resctrl: Read telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:303:16d::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a980dbe-9e06-4ed0-32cd-08ddcbd5487e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NGZybDJnZ1RtSnI3QVVOcGRSUUV0UzQ4QXMrMmhMR0l3S1BuakR4blZOaTRa?=
 =?utf-8?B?S0dyOHFyTEIyeFE5ZXgwYkl2cklqMjZ0Tnp1OFZKTlByR293UE1jc3JtUWtQ?=
 =?utf-8?B?c0tGdlZCRTFCOHF1ZW5pelRqSFhhTnNDQXRpZkJVbVJmZTFUNVVObmFsMUNY?=
 =?utf-8?B?akhaUmRMU3lRbzVzTkNTNFRIRDdOR25YZURwcyt1RkxQbVhYd1FYQnJDZ2d4?=
 =?utf-8?B?QXFZMnlPenB1MEsveFR1QW9XYW9HOHBTNVZUSTRZSW94L3VpV1gwcXppRklY?=
 =?utf-8?B?RlhsQkxhZERPOGNuZSs4YXZ0VmUxc0lCdEtwQmN0eHlNdlZPK3crbE42MVEw?=
 =?utf-8?B?d001a1lDc2E5bVlBZGszcHV3dXkxRnlZTkh4d0wzNlBSTUUvNm1YZ2pGNkFr?=
 =?utf-8?B?WlphQkZ2T0pScjNCNFROZUNLZ2NGQ1RrcmphdHJ0eThjMkxBSFh3a0QwTk05?=
 =?utf-8?B?TnB3YUlhRzhRUXZqTzRqWTVJWTA3bjlCZy9uRUJqdmVJL3hnaUJTREg1U0Vr?=
 =?utf-8?B?SkU1eUJlbDJoMXVoa2JpWTYwRVFDSHJRZVI1eFNORHh2OG4wOGY3eEtBbmEw?=
 =?utf-8?B?M2JkL2w5YWVrRm9rclFsWjNUdmkwVGVBcy9CK0NJaU1DT2wyYzM0am00LzEx?=
 =?utf-8?B?UWl2TXoyekpZY2k0K1NjZTRYa1Q5V0FWUFFIMkpZSlpzQ2pBZUJmMmdKVStw?=
 =?utf-8?B?Z2NZR2puUTNOcWNjS3ErRmRldkc3OTB3TTVPb1dJK2dpM21MQkM4bGFsMDdw?=
 =?utf-8?B?WXlCMkRxa3JTUmM2RVFEeFdqbUo0aGRIdTNlbitHSGl3OFNydXVNcFZrVkh6?=
 =?utf-8?B?U0ZPRCtjTkJEdG14TjkvTWtoSDFrcGNmSVQrYnpQcDZIVFZ2eEZYR2ZXRTNl?=
 =?utf-8?B?ajlVcUNKNVlIYzBvYlNuYWdpNW5YUktScEFLakY5RmsrbHBVMDVQeDhvUXZG?=
 =?utf-8?B?YS9GdFd4NlU3OXdhRHhLWFJnbElXQUdrRUxBMFZqbVlGL1E3VEVwN2UyaWRK?=
 =?utf-8?B?Y01OaFh2djkvR2lleHJINjREN0NuZEI0WndXMStrZURZdzkxQUE1czAzamd1?=
 =?utf-8?B?bHpFZkp5TUlUMSthYktMdjgzcEhXbUJlMzVYZ204QWxaM0xoVlI3OEU2ZVNI?=
 =?utf-8?B?VkNZdnl3UlBoSXlnbldxczhndkJkSk4xVXdFQ1k0a29DVDZjNGlsR1BHdC9D?=
 =?utf-8?B?dTZjaCtBaVE2N1QwYjNNdEtDVG45ZzUza08xWSsvT2JPdjRKdHFJbHl6VE1Z?=
 =?utf-8?B?bzNMS0xxQkUxK2tValREd20xZ1YzTHBqN2V6OGpzQ0ZXWUozbVd3cXdxWVlp?=
 =?utf-8?B?MStUSTZqT1Q1T1JTaEtsRURoRmtnbGRxQnF0bmtHUHNHR0I3eS9aV1g5RDg1?=
 =?utf-8?B?SjVZNjNLRHFWcVNoOFlTblBDMEtnTFlxMjhVZUpVVFREZHdRSzN1Wmd1SFlq?=
 =?utf-8?B?Mk44azFqNDZvL0JxWXE5K01DOEVNbzl3NnB2VjJndVhxV3NhaUFuMjRTWDMr?=
 =?utf-8?B?MVk1TlErR2hpbThaNW1XTGtCcEZ4RXYrYXdaT3dHM0RVQjBVWWM1eHlGVk5v?=
 =?utf-8?B?WjhaUThyN3p3RFlnTnpVQ3RMN2JmQThzYURJaXA3V0wyVnl5MW1GazYrOWh0?=
 =?utf-8?B?U1Z5R1VWY0srYmZ4MFJZM3N5a05FcTZTVlpxVlR4cEY4NWVlbEcxcCt2K1Mx?=
 =?utf-8?B?dm1LLzFHbHdTZkVIL2ZpWWNSQWhucXR0RkhzSktzeFVQOUtoMlAvSXU2Zk9H?=
 =?utf-8?B?Y0d0ZzA0MkE1LzRtdVhuUWVsSXZhUUxaN2xrMTRPL21lOGRzQjJJQVkvYTcr?=
 =?utf-8?B?Z1MzcUhxRjRYQTJTVFYrQzY2ZmtLRS81dVJFR2xRNmR0c1ZRblR5cjRVQytj?=
 =?utf-8?B?SVVpanFqbVpXMTNuRTBOMmJPc0NoNGVmL2pFZnpFZXdCYXFsZXYrRTQxd1hl?=
 =?utf-8?Q?3WW4ruhb4ZI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1BQWlQ2enFYaEc3Q0FBUXdCT2VacDZZT2xGNVpxbjV2aTY1Szk2d0hKeHh0?=
 =?utf-8?B?MzFveGNHZXN6azN3OHo3UDRLQTVsbGthNFNQZExkclhtRkwwa2RZMytLQ3BK?=
 =?utf-8?B?K3NMTmllOSt0anM5dlRGOXBpZ2FNOENNVWtuS2tUYWx0VlJDV2ZSdGd2SEpm?=
 =?utf-8?B?RlpZekpTRjd4Q2tKQ3IzSG1JaVZOMFFCaFRPT1V1a3VVS1dtM2ovdGNOUnJn?=
 =?utf-8?B?eFBEeGpiQkw5dlN6VjdadDhxYVVUZHIwNGlpdm1BVzU0QTJXVHN3UHJTUEdQ?=
 =?utf-8?B?RXJqYzdyMVI5QXVEZzl5M1FIZkxma3BIL0hnb2E2WmNjdDJudVhybnR6L1RY?=
 =?utf-8?B?OE03VjVocVJIekZ5RVRzK1NOVUR4M0RrU1dZQTVFOXAvakt2S3IvUWpSYnc2?=
 =?utf-8?B?Wm5vWDlvVFAwQ05IYkhJOTdVaWhvTTE2Qk1SS0RSMTZ5dW5Ua25EVlZOZTNp?=
 =?utf-8?B?L081QjBpcHJsUEEzL2ZUd2Q1aHZJVnRPeGlkbi9xN2R3MTFJWjNES2NvWkJp?=
 =?utf-8?B?OFdjZGllTWdGNnNrVExMQW5JVGk2M3h1dkVrOHN2OW9sd1RnYzgxSHdzaTVm?=
 =?utf-8?B?R0Z1K3VHam8yZVFkdHhwdE9ydm5wTVJ4eW5vc0tFYVhZTk1LR1VEMjRWdVdj?=
 =?utf-8?B?eEJkcHJrVE91ZXNWcEN3WCsvd04rTzJUOWdXMjgyeG1VNXpwRnVtdHY1NUFS?=
 =?utf-8?B?VTVhQk9nRkx3eFpFTE1RL3U3cnF1RTl2b2lMd0NlZm9CZ0NkWDg5K3czWXhr?=
 =?utf-8?B?L0Z2ckZ0Y3BFS2o0Z0EwWmFLbVBkbWsxMVN5NWtOVEdmZUVrSnF2dWZVYjlR?=
 =?utf-8?B?RUJuajJ3WW1oWEJKL0JnQ1hVMW5mdE10MXBUTVdndTQvMVNVMFNhcFU4TllT?=
 =?utf-8?B?R21UVkJzcXA1ekdReEZMK2NxVUozSFgzTXZrK29IMitXMEhUZFpKZFNwL2pB?=
 =?utf-8?B?aVI5K0JGQWxkUUR2dWg0bk1MSEdIS1cyU2IwK3BUSEdLZnB5ZVA1UHg5bUpU?=
 =?utf-8?B?cWRDZDFPOFpRWkczT3luSm1tdVZwMkNYMUpLK2pwczJzbnJ4Q2VsMlpUOWZ6?=
 =?utf-8?B?bG9XTWxrOXdqczFzbW80NlJYNjc2cGlWYlU2SzNiSGVLaGxXMEZwYTRVcmFv?=
 =?utf-8?B?VDFUR0k0eGEvL3ZMVWVYWXJlczd2OWN4bGZBd0VJWGsrenA2QUNUaDJEdGpH?=
 =?utf-8?B?SnFhcThETzJ5OGtlanZOY1hHdU9JVFpHWlhpckcwVWNnWmVXTEFQOGZjZWVH?=
 =?utf-8?B?N2FPY0M4RGhQbVhrMmEvWkdqSXRBOWUrZjUrczFGRDlqdVowUWRkUHdKaWUw?=
 =?utf-8?B?K1M5d2tlbEFqZnFnN3VheVdRQ09HdVZRajcycDcyelhkcHRWdXp1Qko1b1lG?=
 =?utf-8?B?UmVIMVFxdUlQdUEydnZSZnovVTlZQTZ0cHkyU1B1b0UwQUg0RE9tZUM1bmFX?=
 =?utf-8?B?aDB4RkwwQzlWWEVML3h3SkYraHJqNmxqM09QbjdvWDdCUjNkdHFxVmhKZUJI?=
 =?utf-8?B?TkVoNjlTYTF2bFZqTU8zd2ZSTHRCUytvVmJnSjVaazJkd3V5UCttQXdUMDZt?=
 =?utf-8?B?aEZ1bmJjblNINWdRQmtWSHkyTFRwbnV0U0hsaDhLN0tRbWlHcW5zSEU3SVJ6?=
 =?utf-8?B?N1BLTk9pbmM1aFEzR3B4UzNSUktiRDk4cFcwZjNDYmdBZFNzY2FvSUt4bVhP?=
 =?utf-8?B?RTBiUHYvajByRXBPMkhYaExXUDYrYlV6YWdqV3MxV01GMnJaQmdCVlZDVnFO?=
 =?utf-8?B?UDNZemMxWFVXVVZMWmJjT2dZditsYlNrMU1qV25YM2lqckNLOUVsNVRvZDBz?=
 =?utf-8?B?aVRHTEpEb2wzWUVRd3YzMFQwd2FHUDFEN25lY0FXeTVLdHBJKzU4M01sUzFR?=
 =?utf-8?B?UHdBRy9tdDVCZDBQRmFGOGE0MFNONFhlN2pYelg1UjhhdVdVaGxLa1dzYWo0?=
 =?utf-8?B?Wkx6ZUVMQjFsT0NyRW1kdVZBUkRRWVp2amRETkRaVVYwYzJnditCMUpGdDlZ?=
 =?utf-8?B?Q3N0UkxKYTZyZm5Zbk5RS1kvZ1RLSThGZXhWeVgxd1d6bXZIc0FzM3dBVExD?=
 =?utf-8?B?ellhY2kxWU85WkIrSGZlSXdyVzBCYkVMZEZjL3Bac05TcGt0aHE0emRwRVMv?=
 =?utf-8?B?eXFGUWtwNktuOHd4UFkvRmZuMG1BekZEV0c2VytSbFRzOEk5SFkvazVEUHg1?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a980dbe-9e06-4ed0-32cd-08ddcbd5487e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:45:06.2542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHgCfFBcUMD0sqhoUuLiTzK+/wJhQT8xlmKAzPDckjFxOC4mSRVlmXJz5roBMdSiw+furll2I+WGQTcnh0rJRpvnh2II9fjbM9zLpgV+anA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> The resctrl file system passes requests to read event monitor files to
> the architecture resctrl_arch_rmid_read() to collect values
> from hardware counters.
> 
> Use the resctrl resource to differentiate between calls to read legacy
> L3 events from the new telemetry events (which are attached to
> RDT_RESOURCE_PERF_PKG).
> 
> There may be multiple aggregators tracking each package, so scan all of
> them and add up all counters.
> 
> Enable the events marked as readable from any CPU providing an
> mon_evt::arch_priv pointer to the struct pmt_event for each
> event.
> 
> At run time when a user reads an event file the file system code
> provides the enum resctrl_event_id for the event and the arch_priv
> pointer that was supplied when the event was enabled.

The changelog ordering seems random. It starts by describing how reading of events are
handled and how counters are added when an event is read, then describes enabling the
events (this should happen before an event can be read?), then how data is passed when
reading an event (that should be followed by adding up the counters?).

I think it may help to clearly describe the phases involved. For example, start
with how events are enabled during enumeration/discovery, then how data is
passed during runtime when a user reads an event file, then how the
data is collected.

> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index f4bf0f2ccf26..bd6011a95d12 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -14,6 +14,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
> +#include <linux/io.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -213,6 +214,13 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  
>  	list_add(&e->list, &active_event_groups);
>  

Should this addition be documented as "step 3"?

> +	for (int i = 0; i < e->num_events; i++) {
> +		enum resctrl_event_id eventid;
> +
> +		eventid = e->evts[i].id;
> +		resctrl_enable_mon_event(eventid, true, e->evts[i].bin_bits, &e->evts[i]);

Why is eventid needed? I think using e->evts[i].id makes it more obvious how
the parameters relate.

> +	}
> +
>  	return 0;
>  }
>  

Reinette

