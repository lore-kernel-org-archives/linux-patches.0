Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C3320A0B
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767972515; cv=fail; b=SDenJISpp6FOvA+/1LaZ8JYa/1Zy2OhWI2mUfnu4aXWjHOMRJ2hxPpBumEMxh+W3AEwRN6L6cHIJR2sKGH6zaV3JPXaJKsK65gxHZukqB18AymK/FsI3VaFa4LJfUyT8Kdx+5rfwcFzTUibOoLKtOSXZX8Lhon6uv98mEkAC5R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767972515; c=relaxed/simple;
	bh=Snrpyv6mIpW14s2ZIywvM0Eiae2hO1yemqqhGGwlDzg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gXKo9YbmCrzal+mbzDyTpQ2GsZvQY4HUtFwpcietJ2Zvkw4g57IkSzHixATFygYQ5bXVWYeoheZn80MhaptBDsrLVgyp3G7APYPd+MIv5N9Tvs0IzJkZyF+4tBa/4XBVMUd0F8slotp5Ptt5rTFHq8694rg/fxEqyrxYSA4mSZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WzBfQ/pz; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WzBfQ/pz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767972513; x=1799508513;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Snrpyv6mIpW14s2ZIywvM0Eiae2hO1yemqqhGGwlDzg=;
  b=WzBfQ/pztyf5Z9++I5sdi7i0RMps10SQFEYojAbHxXUzoxdvg03Ci19A
   il7WqthiyCmOjv8tInTuxaqAgauo84Lnu17cRUbgd+H4xfoDuR5DUBo+8
   7l36dWBiq2a3uI1d7TdqwHYYFJlaP0len1ZBOlv7pJKtYwLHOWjvxrXAO
   Gm+yyuvlUX8Ip3Ve+qRDb+h9ymkkb29kHWR0PW6sp1DvUFtso+EAxRn09
   mv7fEqVA1WbnydzPeSTROlbzGZpB86QIr3NnYv+bpYxgaRcFLZXDpqpWi
   mwynRz3QxkgBaVgZ/HqvdtrED/61AmvuhYVaqefa+wtzfseranllW9hgP
   w==;
X-CSE-ConnectionGUID: I8+xlSz2TWKFGr1Qi/t5Zg==
X-CSE-MsgGUID: kDwml/juT4SaSg3kut++nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="86771431"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="86771431"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 07:28:32 -0800
X-CSE-ConnectionGUID: IR8cYn3MS46IpadxUTQdww==
X-CSE-MsgGUID: exA6Zn+kQ5GihDW2iLTm9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="208326145"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 07:28:31 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 07:28:30 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 07:28:30 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 07:28:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4U5O0x6QYaScWaVrdm0skAnh8eEI3FE9kN7LD3uRbIERbhcxE0hAc2luQBjQisqDglOqEjW43t2ldV9QXO3Q2qp7M2HRgkQTqA6ZMG1HBvyHbtJe1JZkS9cmhT3mihExD6KoEhrKuBEjxk58e2HrV1BWWpG5Us0Gj31GI9nyz1ixLAk/Ux3ndBOZo0kmZ/LzFUtBbDboMGeidUdQQ9cx6vyapsT1iSpt6t7ZcOrq+U9Wsbu4uFzpgnu9tkQtT/InnopBKmNTJnbHBtH8p4SgYdvd6BEjyohB0Ooj2BH3mf41BTUQyRzsmmM8nk7mi6a3OOR3eJjx48FN9lJe7IqRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBCZc/35OIN9yqOsFpFJyW+ILzacBpLV8mDp4G8+LZY=;
 b=I3MdF+bx1VOovEsNJrWErFz81mcaVEMYxiYtq/m5cl+QNQcXAAnhEENHZ3Z11HAZQV5DVJdkHDClJWo1DX9E4bO7XbRtVOIumuSrrAH2uIdGzCTnnNsq9t9H/mHFTCFIOLYbasZTT5h0/xCPSXXuGjg3JSCE5b60JiY+O0moQWUrOzVmgcIOJPrzpmZPVpH/X4eYlo1p5kZ6xh9QW/QTKAxp46LVPPMPgEsm+7/RIGVhX3piTlhGs4OaKhvTwDAaYRtVqpBI+spm+5YZTmcZh01naBlosex7z1aKZSFz1q1kiTDlR0ZeZT3v9lrBUFqrn89thku1b0Zl99MYq634MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6826.namprd11.prod.outlook.com (2603:10b6:806:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 15:28:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 15:28:28 +0000
Message-ID: <f3a5f539-0843-4643-9b52-8bb7315441ed@intel.com>
Date: Fri, 9 Jan 2026 07:28:25 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/32] x86,fs/resctrl: Add an architectural hook called
 for first mount
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260108174227.11307-1-tony.luck@intel.com>
 <20260108174227.11307-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260108174227.11307-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0312.namprd03.prod.outlook.com
 (2603:10b6:303:dd::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6826:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a6ae7e6-c55a-4bda-a99f-08de4f93bc9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MWR5Ym5OQ1NjZTN5TlZUT0xpbGppUHJCY3ZCcFBmai8vdTBaREtOM0E0dHlo?=
 =?utf-8?B?QUxqeFN3MWUxaktEMkkxMTJpN0VNMXBScjJLNHVkNUxRRENiRms0dkhWUnJQ?=
 =?utf-8?B?Ky9jczQxMmlYU3dJZHgweGE4V2JzTlc5MjVVMjY1dlEwa2pCTUpMTXZ5clhp?=
 =?utf-8?B?eVhRdUtqN05taW9EZUkrQVp1eHFqT2FFdkVnL3JQT3VDSkRhaFNncnBCV2RM?=
 =?utf-8?B?amtQdlp6MUNvMXBSQ0MydTNSdno2OE9WR3hIb0g2aSt0YVNGTlVYNlhPelpD?=
 =?utf-8?B?Mmp5Tjd6ZEs4ZktTS1JxTXluakRxYXBrcnk2UHU0MjY4REg3ZjI1UWhhTmUr?=
 =?utf-8?B?R1FMMGF6RW5xcXArZTNQOFd2N0o0aTJ5akw1eVQycVo5K2JSUjNZd2hQTnVo?=
 =?utf-8?B?NUhBTFE5L29qNVVjWEs3VnFHSEFuNGd4eVUzOGNuRW5XWGVNaDVUYmFOcUk0?=
 =?utf-8?B?MmFSaVg3WUJRQ2M2TE1BZEc3MUd1bFRmZ1JwWUd0SngwS25jdmtxZDRaU1Bv?=
 =?utf-8?B?M1hKWUJPSmMwczA1Yk1Ua0wrenA1UnNTL3N4WmtnT0dRRS9IUDRweUs2WFlC?=
 =?utf-8?B?eE10N1c3L2lPc1M2blYzbkpOYlBIZ2FYT2c4N2hmTURsR1ZoUFRaMkxzQWQ4?=
 =?utf-8?B?eU1vdDR5eXB5Rk5DZ2d5R3JyelVVVjJiWDdTUTNtc1d4aUVMc1k3dkwwU2ZV?=
 =?utf-8?B?Zmp0SGRlRk9FV0NBL1h2eFlSa0pKSytINFJMc2dGRk05ekFSWGhpbTM0OTA5?=
 =?utf-8?B?ZXpZaldocFdRa2dnNEc4T3hmWGV5T1dPZGZER0V1WFRLUFd6UUtBaG1vaEh4?=
 =?utf-8?B?bjlQUXpZTW1EclRaMW41UloyK2JnSEkwWFVtTndEQUhrcFprUlYxRW1sam1H?=
 =?utf-8?B?WWN2Yld6ZEI5S09DSzJNZTBNaCtMT1BZTEhzblUyY3AyOEhUM21TcnhtQ0E4?=
 =?utf-8?B?QWFveFYxRkJJTDFPYXkvNTdKekViV1F5aXM2MTNjZmdDVFpZaFBjRHJPT25t?=
 =?utf-8?B?YlFQZ1VqdG5zNFllWWZyUExHNitPNHQ1TlpyTjlxcjBFU0RRNm52N01Sa3FZ?=
 =?utf-8?B?aW8zalAyMU0rZWdESjdYK01YRFU1S3I2UnQ5OUYydUcvKzBMZkc3dDk0UjhF?=
 =?utf-8?B?K0dJeXJMeE42WStnVmltYkRZU05YM3VxdWFaUUEzVUVQb2Q4VlZ2eHgreXUw?=
 =?utf-8?B?SllIMEU5Q3lRVkJtSGkwKzExQnNDejU2NjIvTGkrY1YvQUpaNnlOV3pBMjh2?=
 =?utf-8?B?L2gwelMwWE9GYi9RcFhaRTVkcERiZ240Mk1NZGN6YktWaEpHQUt0VG5MM0g0?=
 =?utf-8?B?azE1SFNLNS9xVXZOcStjcGJVbGdnYnRjUWRDeW53WHdlSFhQdjVxeG1IaHlT?=
 =?utf-8?B?Ti9yWFBLSjA2SkNVQmFybGM3YkRHdjZIQWNhUy8zb2pFZUswdmNGc2lZUkZx?=
 =?utf-8?B?L0t3ZUdGczJ2QjhyRmFteWdVY1pTUVNVeStoclJuWFI1SlN1ZkppdmV6enJJ?=
 =?utf-8?B?V3VkWXo5VWlmaEVHZDRVaC9idm5jM2hSS0pLVSthQ2VUWjhGZWk0eHNhSDNq?=
 =?utf-8?B?ZU5adXF4QVdjS2ZqbzBYdUhJUldyNTgvRnNoTzlFbjE5R1lieGFKSVJ0NXFy?=
 =?utf-8?B?anBMVWZqNDRMSS9rL0FNaDJuMU9yT1pXdFBGak5uSmRBcWhJSURJbllLRWZG?=
 =?utf-8?B?YUdEOS9NelZHakdjalhmZUtsWVYxQVpsYkZmSXZla3YvRXI0VUJiY0NJQ3Qw?=
 =?utf-8?B?dHZnMHZCZHBIMURvcitMU0IyeXgyYzA2Y0daOEQ0cEszS3F0R3dkQ2ZGVnl0?=
 =?utf-8?B?VTJtNU9uYk1iMWM0bUNLYkZoTjVjQW9IUkgyNG5NNU5xUHhYcjN0bkFUZCty?=
 =?utf-8?B?ZkVqUzY2ZEJxdTU4R2UxSEtuczZQTXFGNit0eHl1YlU2djljeFg0MDl0ZDIv?=
 =?utf-8?Q?DZX1dFKzI9m7ie3Kcg3iuhbqVJBhxhsL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWJlQ3RyTkNmejZTNjRwK0ZaL3J4NVlQUUphR0c2TGRRK3J3eXU1Zm83Yk5F?=
 =?utf-8?B?bXNlRnZBWDd1eVMzZkhhbVU4REVoY0l4Q2ZvSGpybm13ekFsV2VKNU9RUHRi?=
 =?utf-8?B?R1EzaDBpT1JacE1YSTNZbnFCTTVBVE9rQ1R5dVJ6UWVoYzRoT3JFOG5GdWNE?=
 =?utf-8?B?NTdqRjBDZzB3Rm1FK1ppNlVkK05BY280akVMdWlwV0RqZ3AwdzRYczFKenRz?=
 =?utf-8?B?RzFrMmVsTC9qRit0T0MvaS90UDlKUDhBRHIyOWdOcVVmbjZmRUJvVzRZQ29R?=
 =?utf-8?B?OFVNc1YvTUlDZVBTaENPeUpySXdDUjgzbnpXaXdldXIwU3laR213R29mcHcr?=
 =?utf-8?B?Z25lbkJXRmdkaS9HSy93R2JRSXU2cWZ3MG0wank5QTBwVXVGclRuTGVTeE5W?=
 =?utf-8?B?M2k2azdETU8zNVc3OGNqTmE5aHJlMThRWEpuVXo2ZXpwRVM2N2ZrajB6d3dQ?=
 =?utf-8?B?alFGMTE5MzJVVlo0WjZEQ0U1cHVad2RzMTJtR0duTWtWcHRXZXJhcTJtY2N6?=
 =?utf-8?B?anQ2TUdseWpVc1dhRjZYb0NPSGV2T2Y1WktZTmZCbVk2cDN1TFJoZXZydjE5?=
 =?utf-8?B?TVFhMWhWMW1UYjVnNVFqaE9HQmlyQmdydWtyNmlyT09RaGJ6ZGp1UjJaTU9M?=
 =?utf-8?B?S1FtYWhRSGZJVFNMclI4enlvZkVhNTdWVFhjMUpycEs2d3JjVGlkaHNnQWZG?=
 =?utf-8?B?SkNaZnVFMW15R0NkVDlhQUhEVUhkZ05jMGZ6RFF1UjNuSk4vM0pNZ2tES0pC?=
 =?utf-8?B?QlhUQTdabCtLR1lmbzVwZmlIQTNCVDRTYW9KdmNQL2t0anhMSTJYR09BYWpH?=
 =?utf-8?B?THg0UDlGUEdCemo1L21RMTZBMzhzZ0loZ2d3ZWR3bWptZFZPK2xnUEd4UEVZ?=
 =?utf-8?B?Ui9KZHJWdjdQZWVZZkYvS29xWnJBTGFtaHZJM0M1aEpEZGUwR00rQUF2aG05?=
 =?utf-8?B?dTdpcWkvaWZEVlIrVmoyZC9OM005bXl3QzNLYklVRGs5WjJ3WHRNVldmNTB2?=
 =?utf-8?B?T2RES3FydEN5blp1VkdBU3lnWFJJNzhJaFFhbFpaVzNHeDNYR2NDWGI2VkIr?=
 =?utf-8?B?SExEa2pLU05YNVROWERkVHFoeGtYaVU5RERjTWpVcTR1SWtBbmswUVIwZ09X?=
 =?utf-8?B?NThzdExHdzllK2VveXkzWkxYQkF1UUhnY0ZhMEFIcldzWUZtZnFPbnBEMkt4?=
 =?utf-8?B?QklVckFzRjVOMFpOTWN4UHZHNE11aFpzL3dvMmdoeHFlNExlRytQUUw2Tklh?=
 =?utf-8?B?S0FsV3hNL2ZyRHVnV1FjblRDL2NhWUIzcWdocnFqQTZVVTBRNFBhRWlNaHdi?=
 =?utf-8?B?L0F2bTN6VnlJRVFMU1pGblR5V09pSDdkOEtEY3lSZG51MzFQTzdpUU9rd2dQ?=
 =?utf-8?B?Wm84TURuaDl5VURCcDA5NkFPSUZSWDlqYW5pdnZxd0E2V1o5TXY1YU10T0Nh?=
 =?utf-8?B?d05ybHVWVk80UXAxTHNEbktvOWI4bUZna1JyaVM3ZWhINUJmSTRFdFJTMStS?=
 =?utf-8?B?VlRMK3NwK0JEQW5wUDkvOGQxL2JqRGg2TW5ITUZXRXVORWpTdFNHSVBuVGN2?=
 =?utf-8?B?NTE2ZXFJSmhXb21sMVV4RndWZ09wTDdwejVoZmJZN0Z5SjAyMGxaVDNaSUl2?=
 =?utf-8?B?MkpKaHJtTFp0M2JYcVdyQit2bVJyZm5BRDU4dXk3V3FXZFdJcEc4L0p5aEY1?=
 =?utf-8?B?d2VzZmZSbnhWQjhUOWZydDc3bk5wU0NnUC96ZTBzSEVOeDB1YnB5ZnhmR3BW?=
 =?utf-8?B?NmFCclhsTzluQjgybDgxaWc3Z0JINjIxOGsxKzVXV1U4SzdOZTBwZ1BFZHoz?=
 =?utf-8?B?S0pwamNrZ3d3SFpiWStxV3Z0M2RHZ3pFNnM1SGhadUdLd0lVQUhUV0d1Vitp?=
 =?utf-8?B?Q1BQNGxSTlV5Q1hCL1BlajBmSFRQd0QwWVVrWDIwTGtZZk4xMVZnOExEOXJQ?=
 =?utf-8?B?OWZsanhvSjhqVGtQZ01hbTZWd2NwR0VLZDZUT3J1enBqQ3dSSElSUlkrSGRI?=
 =?utf-8?B?Z2hYazlsSElTcGFWVVlsUTdyUGlyUFBoZzBjZkt4d0ZNMmdsdFZhU1FxbjU3?=
 =?utf-8?B?Y3Q0SnBVejZtMDcvcXp6M2hMYTR6TUhlWktON2cwekIxUXdPSEg2M1VmQzM5?=
 =?utf-8?B?MGt5YmVxNW15OElSTkdSUzgrdjBmcE1zTlNhNE11dkV6K2haVVVxcUlLckxL?=
 =?utf-8?B?eUMwV0hhYTM2aXNpL1hzVWIrUmREbU8vQ2g1N0ppZWc2ZXRDc0pMdzBVd3VY?=
 =?utf-8?B?MWFOaHB3Q2htLy81RDE5ZnpmMDJ2ZFMveDBnSDlMZzlwcU1RaC9zK1pDMnA5?=
 =?utf-8?B?cDVXN1RkcjVVTW80c0xTcitqY3kvRCtyWmd6Tmp2ZDlKMDJRcjlaaG1wZFpT?=
 =?utf-8?Q?qG7/2CrNRzqVxgxg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6ae7e6-c55a-4bda-a99f-08de4f93bc9f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 15:28:27.8781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMMC3DzD2JgDfw3PmLfqQQggEmIORNTpNm5LiNRk7kHlAInBxtRTpiGDDxxUTng49Kdbo71A08K6lsqFmKft71V8jHioVsPHctjSOsz1daQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6826
X-OriginatorOrg: intel.com

Hi Tony,

On 1/8/26 9:42 AM, Tony Luck wrote:
> Enumeration of Intel telemetry events is an asynchronous process involving
> several mutually dependent drivers added as auxiliary devices during
> the device_initcall() phase of Linux boot. The process finishes after
> the probe functions of these drivers completes. But this happens after
> resctrl_arch_late_init() is executed.
> 
> Tracing the enumeration process shows that it does complete a full seven
> seconds before the earliest possible mount of the resctrl file system (when
> included in /etc/fstab for automatic mount by systemd).
> 
> Add a hook at the beginning of the mount code that will be used to check
> for telemetry events and initialize if any are found.
> 
> The hook is only called on the first mount of the resctrl file system as
> that is all that is needed for telemetry enumeration.

Needs imperative. "Only call the hook on the first mount ..."?
Although, to help with brevity, the last three sentences could be merged. For example:

	Add a hook for use by telemetry event enumeration and initialization and
	run it once at the beginning of resctrl mount without any locks held.
	Architecture is responsible for any required locking.

> 
> resctrl filesystem calls the hook with no locks held. Architecture code is
> responsible for any required locking.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

