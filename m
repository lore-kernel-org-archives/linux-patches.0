Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4880515A8
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759536592; cv=fail; b=olyUomyQvyZxCbWKz4oV6+Il2LPZ8AGBxhfXsP+9ioU8hlE2W0m+SSme1byv4turzMzEmLKV1DYaPfyHLwQG4m2vpP86/wlnVaH0OO0tOVoFKubPJptQubQ9fcC4hYDXl7/L1FO8o+wGb1eWHO5Q/Pw4jmv9CzQbkeHx7Xm4ZvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759536592; c=relaxed/simple;
	bh=IPK1EKXOhlPbKT8bYzKgEYlkIRTl4C2KSUntu62o+OA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BtCQAedHVX8xd/ovA15SbHFmKoooELKbt6PtW9I5N7xbsnmJRqzKd6qto5/KjWwFG3k+IBywyLH3H2nOCqa6da7cn73IVwY690nzkoNdvQqvJAys0bQiMlRhozUjJSQk8pP8662xRXYwlHbw66U5M8M32754iUP5DMFBQBGpSE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NUlDxc4P; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NUlDxc4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759536591; x=1791072591;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IPK1EKXOhlPbKT8bYzKgEYlkIRTl4C2KSUntu62o+OA=;
  b=NUlDxc4PPqUMWNufBiM9bCbSyUAQjnS/OxrCttuSkUG9BSgK+zKGv2wQ
   h/TFAHZvjWMrYs6ENqh9QcgiFJyeQ7s95MhW0eJFyGsnyPPlyV1o4wvm3
   ds5DP22C5fbMF0aoUMdzG2e6Jx/c4LuXjZPGbKFmQ+FnwOSPVEsfVnBxh
   UcHm/EoQRbb/HJBCN9Yp4nrBMBcghXkNNey4YAWPmNbUTysYgjjHw43+V
   2KvCRLXeErDMPSZH0PcWe4ENn+0cf7A0VVcpNGa1uJALe55i21yk1ciTV
   qy3e//mP8KwKLiNuz5uxI/274ofWnJ/Mogfk13c97RZuiSqpmtrOjH5JM
   A==;
X-CSE-ConnectionGUID: opiX/CWuTdqtCxxmRkcb8A==
X-CSE-MsgGUID: N1kTjxjoSSu4CnFjV+onYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61737269"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61737269"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:09:50 -0700
X-CSE-ConnectionGUID: qFgKfXKWS6inlf0Q5O8sdA==
X-CSE-MsgGUID: fsKUlQZXRr+H2hvsW0lpsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="183409210"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:09:49 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:09:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:09:48 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.41) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EhNAuat9gHtRYpXTO7DTF7UhaM7ozjgPlOjFeBuqK+jQpr/kBEfeNI8zB0wy2FjdJo3yBF3Q/Lpp3KhsHuUr72FwcY0zhKy/02dR4M6TTCIuBYSiZC2sipijyIknEowfbk2ztG9QHz88+erGyxka2uHt89CZmW7gjMhUBIpOZeNR/g5NC1KT7vEIyYbJIe0Oaslr4Pcew7cymLlNN9wZShRaQ2f0dJI2ghKqjSbXII3PKveTVOs25g6EglhDiDk0IXvFxX8w8vVjFVOb1U8RKZjPnax9oh1kL4Tsy3vUX09WWOWBofuSlwAuGp/6qvKgoMivPqjVUXhYqnlVIiLVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyQywzziTv4ZXsJn44/OKVM3Nb0DAtvC8ut1v/7N1HM=;
 b=ezyuUC9GNtgl9lE/kGa/qcwwtbSwcDMJdJI+GYkuGNdQLRaED3Xz7dB0o+1sDtTBJaaOtpygf6vgptUOEfQETr1gHR2AMEdvqSNs4UOLNRaqNbk+GAOzDl33f4ejmZL03JD4PMnALG+qMogZ3so0xt7wpDy3aK3LVXs2r8wa2EInVF1LFVziMkc0B3WjwUtT4+Kf8rVEw99qysiZz4Gxccn7rieI/4UagtODdBB6Inup1987308j6oyV8p/6o1ct2xy+UFqHxV9eJSFd+t69zxImTHytyd2FHAlPK1vmRelPnY8WDdM8rka6OrgW0B6Tkjy6HTPgY5QmuhBAcZ8t4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8715.namprd11.prod.outlook.com (2603:10b6:0:1e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Sat, 4 Oct 2025 00:09:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:09:42 +0000
Message-ID: <24bb7dbe-45f3-48ff-a255-0b0259e81c2c@intel.com>
Date: Fri, 3 Oct 2025 17:09:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 24/31] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid[]
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0230.namprd04.prod.outlook.com
 (2603:10b6:303:87::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: 30aa045a-9e59-4b79-def6-08de02da5148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bHNPS2FRcWNpZEsrUUVmK1FSM0RFYXo2Nlp2NFpyY2RWWStLQWZtRHhwZ3NI?=
 =?utf-8?B?L1o4ZVVUZU5zQTgvUmlkZzBZbEhESkZhQ1pmRW5JZzdhNnIyeURvNXJMMXF4?=
 =?utf-8?B?T21HN3p4eFBFdGkrYWRta1lGcXNZT2xGdC93dVNLaWlCclNrVnY3RTY2aDRS?=
 =?utf-8?B?K3Y3VHo3SVhsVUlmTDlZMEJBRVRXUjFmRUY1enhiS0pSMUpFeTMvV1oxZnRN?=
 =?utf-8?B?eGFTY1hGeEROeFlvTFYzR1p2bGpOWjY1cE15aVpiYTdMRG1qRUJ2OE16eDR2?=
 =?utf-8?B?a1cyS0lJM3gxb2R6bGJyT0xZRFAzbU9HTk1VVDdMRjB4K1puZG5SekxPcFhl?=
 =?utf-8?B?WUI1NURtWlJUN0tlZ2kwVXBkZ1cxa2dQUEZxeFBLZlpUQ2VWamtCOVB1czA4?=
 =?utf-8?B?MFBjZ2drbDlCbzQyNVhFQkxuTWp6K0ZBNWkrM1N0YkREVGp5RTdmZ1RYbEZq?=
 =?utf-8?B?eDFHbHdjUXdYamtHb1hsSUpTRzFnYkF3a3pnRmJFeG1ZOWpKS2ozZ1BZeGd0?=
 =?utf-8?B?UnVLV3NOTWRnL2ViaE5aLzhiWEtnOE01MWFmWnNWT3dMbU9pbkxCbWtXdENC?=
 =?utf-8?B?SGc3R1pGb3owZ0pkeEVCLytSZGM5c0tDaWpEaSs5bWU5NTBqd2RLZk9udHo1?=
 =?utf-8?B?MlUxV3I4SUhNV01GNlFwcjMyNDdwcm9XZ2M1TGQyOEc4V2JoUGFyNGEvdC9F?=
 =?utf-8?B?NDRVU1JFY01MWFVnWHcwaU9HMi85c3dlWHZQMlgwVW5HZ0ZkKzZ6UkdmY0hy?=
 =?utf-8?B?Q2N6MXI3WjJxY1IrdHdjNEpsRkxDQ3ZTT1pVeHdkWnVjTmUxUTlvUVRCM3Q3?=
 =?utf-8?B?R1RjOCs3V3k5aEZKdTFjM3JHVUtUZFRDa1A2K2xjQ2dsVHF4anl3R0F1SUN0?=
 =?utf-8?B?YVBuZ2JPWEp3Q0ViTUV4amNUYlRZSGJ4K2l0NSsrUERsbTNsbzZ1Rm5uR3Ra?=
 =?utf-8?B?T2J1cG9yaTIrMWlDcExibHZFdjZlemh3UjJUNUpHZVJ4YWJ0OFdCS3hXVFll?=
 =?utf-8?B?MmtXOHBUeGF0aUppVk1WZXNYNThlZnN1cWFCa0hRSm0wTjdETVF5KzlHVTF2?=
 =?utf-8?B?OHhUZ2llYThWNFkrczBNMzlzNUdmb0JMRlR1VGMvNDA2ZTVZTllLUXJIa29Q?=
 =?utf-8?B?YVpEL2ZRblA0Z29qYlBiU09mSWVuRjFmTEFNTVUxNXF1M2pZUWh4YnRLUWhY?=
 =?utf-8?B?NDJobTFmTmxPMDhiSTJOQTM1U250eEtIV2lBTUpqbE1QdWlFaXl6L3lFOUhm?=
 =?utf-8?B?U0xBYmdGeUg0bnJTSmx0aGxFWmlxL0pncCtES2pXSW5KTWJWcWpkTDY3UWp6?=
 =?utf-8?B?Z2xVU3JDRmZQclgxcXVJVml2RHRnZ0dTNUpBUndkY2tmM3NLNFpsMGcweFpR?=
 =?utf-8?B?UFA5L1Uyc1RFcjNZOFlBaHlORnYzTWh3aGswTTNXMGxvRENaZUN0M25VTGxT?=
 =?utf-8?B?NG5oY3RUM3BvNE5MU2tCOG9Mdm54cHB4eTJFT2tOQmZuYktSeTlWVDZmT0lF?=
 =?utf-8?B?a3FaZmx4aW04SUlIQTdMUFNvMlNPQld1aVNwMXBnVnFBbWdHWHRXeGVyVmxG?=
 =?utf-8?B?TVEzODhnM2hiZDEybHZRWitPclJKTmwraWVoZy9xVDRldTdDUXF2cGJ0UTVV?=
 =?utf-8?B?Ukh0aEI5bXlGTlRLQm1mQzF2R292dzlPM2l0Rmo1NVI3SzJERi8xZysyVkVo?=
 =?utf-8?B?SUZjTllpSTd1SVcrNUdMeEJJL3RXSFhSbjMvc05tWXNmaThKUHNqdW4waXo1?=
 =?utf-8?B?MVdoOFJobTBhZTQ2RWhDR29aZC84QzJkand1NmZ5anJzYzU3ZjBLYVR4VFM0?=
 =?utf-8?B?WG1qc1daL2pBb2dmS3hmeFU5a0dMUG1WdkZqVzY4aS93bldFczVTZTl0WmZT?=
 =?utf-8?B?MjRZaC8zNzFzcm52a2hTTCtidVhUWFduKzZnVVB6TVNZMEZSamNGcWFJc2Iw?=
 =?utf-8?Q?qxVJNbLlKiRykv7m19v+/taBrb1fpNPp?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkZ1L2tIMU44dXMwV1ZSMUY2N1crRCtna2Z5K1NmRGZQcVBkT2w3aUM1cnNl?=
 =?utf-8?B?U2k1TGpUQnFlTVlZTFZiSWtwTFlEV1FpcnJaVFd0UngxWjZTVERMV2RCR0Yv?=
 =?utf-8?B?OER1VlNMdzNnY2tDWlVYemNBT2xWckZhbHRwTmZYUWJKYjZ5MmFpVGErOE1D?=
 =?utf-8?B?TDJxQ3BZdEt4UllWS3FmaUFLOTlFOE9RVEtISUxxc2VCTmdva1hudVAyKzlv?=
 =?utf-8?B?RTVEcXpNZG5wV1dlTHEwZzNIVHJ4V3VSQ3FrS09BT3JRRjhZQ2tmQWZia2dY?=
 =?utf-8?B?UHplUWRlaW1XWnRoVWhqZTkzMzEyWVg1STRzc1FMWlZOa055clNzbC9QSjh3?=
 =?utf-8?B?QlFzS1dIRUZhRFFZdEduUncrL2hCQWJIeEt2TE5lZ0t4TlVZUTNab3hoY0lB?=
 =?utf-8?B?V0M3bEVDNXhrV3BKL2U5SzU5Mk9JSitqRElTMzI0ZE9XTjdwdlNJd0JIOTds?=
 =?utf-8?B?R09tVjIxOHA1YXpmbmNQMlVsc3RMZGtHc05Zd25jcWlGQWkxT1lQVFJDSndk?=
 =?utf-8?B?dVpxdzVBTWtlTjZhZHFuV0pmZFB0U3dKMDF4b1pscVcvRC82d0xUakNIVzB2?=
 =?utf-8?B?cWpPOTRHMEJESGp6dEFxSWlKZ1NkSE0rTjVrZU50b3VwbXhFWWRGc2lXM1ZT?=
 =?utf-8?B?aE8ya1BHVEk1aU9rNDR6SS9HaHU5aGdxYS9yelBJc2RrNVkxNnpEWWZWL0RF?=
 =?utf-8?B?OEZZaGdCeFNMZHVpVUZ0eDBwOXUxbHV4bjRYa2Z0d2NndTFMM0prbWpTa1pt?=
 =?utf-8?B?aDFVY0Q5eFcrdy8rb0ROS1lYUnBLa0VHck1LeFkxMlY1bXVHNGNyQmo2czVk?=
 =?utf-8?B?cWZUbkJiL2Rla3FrVHpYUk94NWsxQXRiMjBZaTBqSGRSTHJyYWhqTnNwWG05?=
 =?utf-8?B?YVpGTDF6V3V5SFA3RDVFTUNuaTJwTHVVWDU2TnBzamFvVStnd0F1cnBrZmxM?=
 =?utf-8?B?Z293UDVOT2FtYklPdkpFQmw4Z1dDejlVV2VKekFUdG5oVXdxQWMyMm9USnZI?=
 =?utf-8?B?Znp3STVMdlYwMkYzc2p5SWNiUE9nZU9UcHVnNDRvbHAwY1hVTC9ubXhPTHF0?=
 =?utf-8?B?ZFFqbjlSU3p2R3JyazZYamp4bSt4MTA5UFJ0M1BjTVRGWnc1R3BSbWZCNm9h?=
 =?utf-8?B?a293WEduazhpSWJ6S2NsdTd4YVZZQThZelRjNENhbjFzelRpeUt3L3p4Q3cx?=
 =?utf-8?B?RXYzK3A3ZzAwL1puaW4rQm1TenlKQUpNaSt2a3NIS3FrRndLSW5zOUxXam5S?=
 =?utf-8?B?Ry84OEZCZThXMGxZNjloQjBBL0VJa2lqa1ZSOG8vczlNUk00SGt4QVNCaUhz?=
 =?utf-8?B?dW5XRVkvTGpUNE5tYTVEWW13bTVzUWo4SS8vT0dqeUhVbTdGQVpBQkRjRDJY?=
 =?utf-8?B?ZCsrcHYzcG1zbkVoaXlDaWl2UmYxblNUVDlLVkN3Rmp4TG9UM3BZVi9JaWo5?=
 =?utf-8?B?SlcwQU44NEJZRERGb0FtQXpDZ0VHYmFGV0NabHdNWXhVUVFFUC9aOHRUNEcy?=
 =?utf-8?B?YTlLOGQxbVV0NjJnQm5hZkhMTlQrcUdQWTBsWjVpMmFKZ3hXSEowNGpxcHY5?=
 =?utf-8?B?NWpKUEtIczM3a1gzSDd6YzBBZURHcmxiek5Rbnlwc1ZxNVhCMWt0U2c1R1F3?=
 =?utf-8?B?bHpacXVXbG1yd2dmNGNjS2lMMUtpOFBaWmM1WlRXS29od2oydWVMZEZOWGQ4?=
 =?utf-8?B?aVg5SVV1MlJsVTJpNjkyMnJWRDFRdHlWa0diMGl1RHZ4RjNmMnN3V0owelVi?=
 =?utf-8?B?ZFFVbVRXOXJjWEFUaHVkTHlSUmdHc0V1SGxmTllOTW03MHE4M0xGWnNrS2NM?=
 =?utf-8?B?cHRHRkdIaGRwbm9OVmx0a29TSlVLczBBaDlMckJjeE9yMEpjcEZVOXVianc2?=
 =?utf-8?B?QXp1VnhJcjl4ZlFaMGIrajZ3RE5sK1ZReW00OVZGTUhQWVBPVFJoVkNVcVY2?=
 =?utf-8?B?M2pJRm44RnhPS0ZJSTliV2p0UDBrVFk2WDNoZFVtUXI0dUhqa2hubXRzanRt?=
 =?utf-8?B?LzhyU1NnVGcrM21GSU5acFFlRlZTWCtDSDJoM3dRcTlWMW9TUFRjTE1sMHA5?=
 =?utf-8?B?TlA5YWdFVEd6MXZ1Tnk5WXg5eEM0YlRkZFhoU2JsRlVLL1hZWHptYzFadnNO?=
 =?utf-8?B?ZVFKV2lxb1Q0Vk80cUtTN2Q5Nk1FSVV0QmRCTDk1NmtjdngzdXV3T25GR1Z2?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30aa045a-9e59-4b79-def6-08de02da5148
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:09:42.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZut7RvjQ5MBzb15lL7iRnLOw3Tw/YjiKRBfji/zGUhLfsdZOEcmyQ5ct9QBB5k6j3T1xbGUrlq3WpFEvoIQU8B5wbs7DCTDkXN71HYWNkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8715
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> closid_num_dirty_rmid[] is allocated in dom_data_init() during resctrl
> initialization and freed by dom_data_exit() during resctrl exit giving
> it the same life cycle as rmid_ptrs[].
> 
> Move closid_num_dirty_rmid[] allocaction/free out to
> resctrl_l3_mon_resource_init() and resctrl_l3_mon_resource_exit() in
> preparation for rmid_ptrs[] to be allocated on resctrl mount in support
> of the new telemetry events.
> 
> Keep the rdtgroup_mutex protection around the allocation/free of
> closid_num_dirty_rmid[] as ARM needs this to guarantee memory
> ordering.

I think this is heavy on describing the code that we were asked to avoid.
I amended the changelog below in an attempt to address this, please feel
free to improve:

	closid_num_dirty_rmid[] and rmid_ptrs[] are allocated together
	during resctrl initialization and freed together during resctrl exit.                          
                                                                                
	Telemetry events are enumerated on resctrl mount so only at resctrl
	mount will the number of RMID supported by all monitoring resources
	and needed as size for rmid_ptrs[] be known.                                               
                                                                                
	Separate closid_num_dirty_rmid[] and rmid_ptrs[] allocation and free
	in preparation for rmid_ptrs[] to be allocated on resctrl mount.                   
                                                                                
	Keep the rdtgroup_mutex protection around the allocation and free of            
	closid_num_dirty_rmid[] as ARM needs this to guarantee memory                   
	ordering.                                      

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette

