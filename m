Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EEE2FCE0F
	for <patches@lists.linux.dev>; Thu, 17 Jul 2025 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752774685; cv=fail; b=dJdhwKnbFk3SpbKG2NT5jxnYjt2My0z+IOq7SbXsZqhcN29mXY6Na8KJXrVflynCLIk6jkchP/J03v4ipN1q66p4tEObM2IwZXQ2cqTO8+QqHwhui9k4FOfGRrXPDWnWnKVwz4VuBc0IO/6LbQauC4E7npJ9ivNWsv7yUURiQDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752774685; c=relaxed/simple;
	bh=2qIGO7+vVNZJHxvpyafYm0Ws6ZKIpIUXv9tlaqgmgsw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PXoR+cSofYFlznoY39/vCUG5tVYc+Pm9Z0ZU2sP1Mpc8kUDh+g1o9ncJNAYJAfDFbVZ+QXIhJ/dAXBZT77R/f2h7gA/iVctmCkYHiJCm17jvkd2vQDXtMSKJvmMoCEUq9QgPaT8EGGohumavEIvikC6iTF7LAcjEggcrBBtzEDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H81ma6zx; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H81ma6zx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752774682; x=1784310682;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2qIGO7+vVNZJHxvpyafYm0Ws6ZKIpIUXv9tlaqgmgsw=;
  b=H81ma6zxGCR95Ud00svSbHeypKNeSeOV4H6DVEv8C/V1HeFE7nx/9wNd
   IlZy9ZLDa8HHxs/Wa5aGWWcTHFnEo7Dsy28EQpCtdqkXh3aHTOy9/vfyl
   GQ92OoL4tMQGK81yn2Jl8CFcAfhL25L1Mqb7+0/ClxuwEiQOxV48POvdy
   mlON+RaWbY+9//OlZyfE0WgaUJDYs3LN5xpU0ZlDfAYVc91J2F22n6Inf
   jrHp/1zpnUUw+13neXyvt8Vf87nkoHFHabhU4E3wW0n726xOwcLJiqtj0
   BEY5e/7W9O3Z95G6taAlfGlL/L75nXv8uMw8SHRXIKsAFUZYGUV4KlZE+
   w==;
X-CSE-ConnectionGUID: COTdf4b9RiWX/VdYB2ARpw==
X-CSE-MsgGUID: 9GjKVR5wRGaQpNGEtiDEgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="55149470"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="55149470"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 10:51:21 -0700
X-CSE-ConnectionGUID: H0BkFYFTStGT2EX/IjKXCg==
X-CSE-MsgGUID: Vgn1T+BBQl+Mg5gk5f3Uiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="188839560"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 10:51:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 10:51:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 10:51:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 10:51:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GS0Ln210VRO9QoRNcT2ika7CVT2ybI8f45LeyZt5i37qgNx2q1iC1kwLxP1XMXItUHoN5/Mn1ab57oSRqIV2Z/UEFUzBSkjdP2/Xj89ECMfXhebZmKuSeuniskyUUdHB9W2XjJPH04wN0/VwGsqE141QFuQKzYGdOaN0xglXb2Wmyh6cA+BBdnzKuziXuExyWVgyxTegc3Qh7/6O1xD7CYIMqbBh3aBUVl+8kp67aOsaxI0/UFHeW03sXs9mal5wkRm7ciinBBqpg3KGQKLDhEveqWVYFPB1a1qYeFPfaFBqMhkmbXrRq5xw6zclJSEhtPZXK02xxbdzEmFJ17Jf7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYCVqF5PjNSmtwlkNVfG2y8U0BbDOvN6s4btQw+Ecjk=;
 b=LBG3TVJ3QJaW0uvI11v2v9CwbZRqAa8EMN4BujPwzNkbhm8OE0vM8zfivOBW47dOFwNMBhwwK36b1CM5HwD92CFQRQtd4WQV2kLKhPva5oG33wsiio4kqiOYi5ZTvCRE2ExTu+VV8F3+va+z7G7CNTAwnDv810eB4JzfH8rK9y7T+sWi3ecJ2XsgFw1ieZmAvqotlyjd6cIcizdETw2RD0PkfYSH3IKwa0qmN63y9sxffXyUr5ooteGz/qWMBgJ8mmPY21jc8HUMV+5i4/FXHtRra66ICVjeBcHdnrs/7uiZ5M4aP7Fp8U3jk+PNs4PdjifwxFlOjJ81D5oXXv74dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7113.namprd11.prod.outlook.com (2603:10b6:806:298::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Thu, 17 Jul
 2025 17:51:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 17:51:16 +0000
Message-ID: <9dcf8b1a-225d-49a1-ae91-887ddf125431@intel.com>
Date: Thu, 17 Jul 2025 10:51:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/31] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-2-tony.luck@intel.com>
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: e68ce005-a1a1-404f-443c-08ddc55a8706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUcxZWE0SG9NNWJ4aDZGWTB1V0dudGhHTERMSy9wc0VCZWdGNGtSQ1VlWVlu?=
 =?utf-8?B?QnFIemRHbW8ydm5QV0VSZnBrYW1rbjJYWHpLcmVCbzZmWG5EZTZldHRoQ1dp?=
 =?utf-8?B?RVpEcU5lR0pMYXdXQWxYS2V6dHQwc0kyY2k4RXNaay9FUU1aYVE5U1ZVQURC?=
 =?utf-8?B?T3lWZkV6dlJXQzBUVkFNWTJScEw1bUluY2Ztcm92bmgyb1oyTW9IQWtjL2RW?=
 =?utf-8?B?Y1FvZDN4ZTdEcmtKbFB2YUc5cUM5UlFEcElXbTYvQ2h1WG56TnYvVVYwZmls?=
 =?utf-8?B?Z0NGQThEUHdHdlBhclR4bWkrcEJNWU9kTmVWSVZ1eWZLWWZXdjkzRWdpcU9z?=
 =?utf-8?B?bGtKeS9jNEFab2I5blhhRkJBZjNzRXF1RnIzTlNjK2VXMUZxdXczNHNVUmNq?=
 =?utf-8?B?b2poSlRwR2liTXEvOHN4VlFSTTBmQzdQTXpRK2YwbXBjMFM0OVNHbzRRZUow?=
 =?utf-8?B?QVFrUDlRK1h4Uk0yMjNveC8vdnN0bVVkcDBtMmJSNjhGL1Q3RGMwMy9zdk5S?=
 =?utf-8?B?U2ZSSGVZdFZRTG81UFZXUzBCVE5Ed09XMmdmY2JEN3ZTTy9EeGhjQjZWR3Aw?=
 =?utf-8?B?WWxPd1FZcHZwUWl4ek1QL0trSTBhQUtVK2pWM00zb0hqdXNTVkpKRlZKMkkv?=
 =?utf-8?B?RWtZU1I2TmpyQXJQRG55WnlISFNtTk5sd1ZwUnRtZEVQRkdnL0U4V0wxN1lT?=
 =?utf-8?B?eHQ5dUVuV2xSUDFNZkg2blFVMG9rSmZkUkhrbXRFK1B5cmlKQlFiSWpVNnI4?=
 =?utf-8?B?WktlOG9nYVdYWXBiTGYvcmJueWpRekQ1NG9jUnVuQ1V3VVlDd1JKT01QNExQ?=
 =?utf-8?B?aXZPdjV1VGpYbk9JaXhlZmJYdUpvM1ZnSjNyQlErcUthSGNaanVmYmx1bzR6?=
 =?utf-8?B?UUhoV1k0bElsOStpaDhia244ZDVDTDNPdmMzY1ZlVUpNM1NIejlFZ0xxcWpF?=
 =?utf-8?B?VFcvQTN4RW1WQ0hsUk4reThrb09WSzZsc1BkdDhUYTFDRStMK2tMYjhyN0Vj?=
 =?utf-8?B?S3g4ZFNWZGMyT1o2amFqR1BqMEhIU1dSWTkwWVhqSkhTNk4yRWloVXFyNDVk?=
 =?utf-8?B?NzJGWXZwekhVdE5NZ1lwVlVxTmErb0RDajRsalVzYjdsQWp2TmlWTncyZDZ3?=
 =?utf-8?B?bHQ1bXlMS1FHTHRLNVVzS0lnYkhDOUd2N29mZ2MwaHN2WFFUU3BmK2dGNnVL?=
 =?utf-8?B?RHlKTHBzLzZqeFBKQW1YOVRnUlRYZ2NxT2FoL2VEYmtKSTBWRUMwT240RHJ5?=
 =?utf-8?B?cUJhVldEdUtFalQ5MGpaUVJiVjJGZnV5YkVMYUhIUWpGRFVaOGpCNks4V3Yy?=
 =?utf-8?B?YWFkZDhGZ2pxTzFTOVdlekc1dFRYNDRqWWhQNG4zVWZiK25XN2hiZFNkQkZq?=
 =?utf-8?B?dzlFRmljRFZkMmFBdVQzdG0wcVBqNnVpVVdiTFQ3TTRZMmlKR1VJQ2hNZGI3?=
 =?utf-8?B?YncyNnkvaEJDamk1Ny80YVlreld3SWJEUHBWLzdtbjZ1cGxRVzkzUTV1S3Rk?=
 =?utf-8?B?d0V0QjRnb0xRbjVqV25YaHBzWHBwM1QyeEpCY1UzM0Q4bzVPQVNhTUpwdDJT?=
 =?utf-8?B?TVBMRjhZeTZCTG1mUWVKQU50WVdLa0xtWkxUcjdaQmtGS0VRbm5melFTUHdT?=
 =?utf-8?B?Z2xFUlM2Q0hKRDNHMk5VSXFFcWx0TVdXR0xCMFFMMDYrS3hkejBoWXZHcE1J?=
 =?utf-8?B?UHJ0dUhoV2xqTi9zUEZndmxaaHZZZzJUb2FqZnI1TC9IN1lJdkd6KzJ5c3M2?=
 =?utf-8?B?NnR6ejVYVm5sbllqU3RGbjgrQlZWb0I1TEg1dloxZXBzYWJjL0tva1k1eDhR?=
 =?utf-8?B?N256K1kwdVJackc4VWthRTFmVnFkU1IwdVJ5cWdZbU1DM3VVdk1FelpvbFFr?=
 =?utf-8?B?V3Nuajhjci9sY0Q5NktLbndEbkk1ZGFiN3lDK2c0RFVKZVQvVk03OWxML3pI?=
 =?utf-8?B?THowK0JCcWx5eEd3K01UQWttNTNHd2dBR1l5b3RxNUxUMGNvMmhvSEhJU0Y1?=
 =?utf-8?B?bkRiakpYV29BPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlkrV1M4alVGM2ZjMmpPOHdacnZhbG5hSEFhSWVKbW5QRE5sRjB4a3V3MzRK?=
 =?utf-8?B?S0tqWUZFMnB3MFFsVFB2a3ladmxMbHcvR1AxbHovNWRqV1A1c2czWlQ0WXJG?=
 =?utf-8?B?NkhhOTQxanlHWXp0MHIxZTNsRVJpUU9RTmRWRE5rWldzRlMvanEyTEhhdE1R?=
 =?utf-8?B?aExBZEl0TnlZeGRPaU9DVDdNVUFiaUc3ZURqbERxZmIybEcrSE5RMlBXWnE2?=
 =?utf-8?B?Wk5lekV1QjRETnlYNGZRS0ErU0VtQXlJYlV1aVBSa0ZwU1VKQjR0Z2ZOSm0z?=
 =?utf-8?B?ZDRZUTBNWFZqQkxlYjBVa1MxU0pCbWdDMmRFdkZ5U2o0QnEyb2RNLytmc3Zs?=
 =?utf-8?B?ZS9SdEtEdFBZS2dsdGx1MnFBZmxZNm15V2xhMGdSSDROdjNrVDJmWkVaekRt?=
 =?utf-8?B?eVNpT0VZbTVuaGc5cVlJSHRxcFU2VDlyZ2dMREUwYnhoZ3BNa2Y2Q2F1TmVR?=
 =?utf-8?B?aXQyMUdPMFQ4ZjVUTzVvWDJUZEE2Y20rNXdva1JFVlRGSXlmeEpTRENCZUZZ?=
 =?utf-8?B?bEUvY3NQOEluQ21kT3FIZ2t5SFBkOHFMOXJxV21CT1F3cG9IWS9KVlpuaWIv?=
 =?utf-8?B?eDBVMWxBM0pFWWpsODNvWmZzVDQ1Unc3My9Eb3l2eWlDM1pkYm1BQm1IQlE0?=
 =?utf-8?B?R0pERVJ6cUU1UDhoOXZMN2dlUWFBYUQvQUdiSEhQelUybnlFRnFkcU5xTVQv?=
 =?utf-8?B?QVNwU01zem8yZjNQUXlMU3hYNFhTTlVDUHY5dTNKK3FSWjdramR0WTU5UHE1?=
 =?utf-8?B?Mzg3RDhFNlFxNmwyZ3R2RXB6SVdDellFZnc3NjBtd0czOGMrUUQ5eS9hR2li?=
 =?utf-8?B?RHNRSy9GekJpQjNYeVFoZ0R1WThqdFBrYXJQSXBmRXhSaGVULy94UEpSWkZY?=
 =?utf-8?B?S2RSZlhNUG5DSUt3YWZucVBzYVVPSWx5bGtpdWhIVG1LZWhVcDZua1lzaVFB?=
 =?utf-8?B?NnhIZGFEQXNRSmMyVndwS2p4VlBzYmc2bnBwZTZ6UDl4VWpFZm5kbHF0S21M?=
 =?utf-8?B?YU4reVA3S1NJODhwQjlRZVk3QWRwbnkycVhoc0pXdjNKbkRzMThCUk1SckFT?=
 =?utf-8?B?RDFZSS9mZUpmcTRya2diUDQ2RVZBOCtUQXlGNmc0K0FMdVRZTkJTK2xNMDFX?=
 =?utf-8?B?SjAyME9SbWJJOTVmaERlQWZtelRpSWFRTFczcVhQbmVrTFE3TE8rcE84ckd4?=
 =?utf-8?B?RHU4ajZXck9EemNnd21QOFBhS1U1NEYwaEJKZHFHSk82R1RnclZxQjZYSWJF?=
 =?utf-8?B?cHdCSDNsRDIvcUhqZ0dVV0FGdTVmTFRXZHVMaUhCM3BQMWRYQWRJa3lxcmJS?=
 =?utf-8?B?cjRHT1Z3c3IwQURHWHcydDBtcW1rSmRFaVVNQ2RYTHZCVE05anc2NmRYRUtU?=
 =?utf-8?B?eU5vaTdMODYvLzhJZGdCNFZ1ZXhpV1JIL2NIbUNPN3g3MzhKVlpmbm0xTGhN?=
 =?utf-8?B?U3lZQmhwS0hTZEJHOFNIVGY1ME5yUzg0RDZxVW5oWUkvV1czU0xBcDkrV1ZH?=
 =?utf-8?B?QlFzMlc2aWMzbXd3KzhFNkdSNUdTSEJrQVE0aGlEUFRxcHB0YjJoMktUZERD?=
 =?utf-8?B?em1la0U1Y2Y1UHNjUTJMWUFOQXR1ZUtNQ1gvVWNPZG5QTDNNbXpQV1p6UmhW?=
 =?utf-8?B?aGQ3ZzIrRGNuTFB6TlZzRzNkWnovTEluTUd6K3QzcVZzbGZHRWRQWVdaQ2xT?=
 =?utf-8?B?bXJ4QWd0bEVYWEZPdUdWUzBNSHY1bUl3SngrdmtCa1hqSFdIQTFhR3JXQW50?=
 =?utf-8?B?aVE5SWFXeloxQ0tmcVZmT3pXU0FnbkRsdGVUTGM0dkJCVFFycFlQSWRvMXhW?=
 =?utf-8?B?bmw0MHo1UlpvSk5VcnRBUzVKMVRkejNVMUVQWC90NzRDcHNsMjdhNmFnNmpG?=
 =?utf-8?B?bWF2QUVwSStBZ014VnFvRjZYYUVYd0NUTi9QT0hDWlI1QWk1dno4MWh2THp3?=
 =?utf-8?B?VzM5ekhtWUhNaENwYkxUOXpMSmIrRGJjWlppaDNnUnlBQjNBNVIvblpzaWM1?=
 =?utf-8?B?TFd3YkdmV1RtSTg1ZXdFcDRUbmFoTUptd3l0REJ4bDlsTzViZzBMUW8rUWxl?=
 =?utf-8?B?SEpsSkFsdFg3VWJzbXhXeUt6ejB3T1p5RW1PaEhLc2NlNTJPaFFjaTE2c2pn?=
 =?utf-8?B?MHNmc2NUQTR3VkJoa0FVbjMyb3pxL2ZrTDhXZUhlbC9uWWVmVVlwQnlteG1Q?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e68ce005-a1a1-404f-443c-08ddc55a8706
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 17:51:16.2458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pz/EIveDyN5UfEycitpiNjIVuk6yO1LDGZw8+/+vr3C4gCOsGgspyQKvREK4LrrhqmnAW7bi7AKfqvo2gIcdLNNBSRjePanB4x7f3QQjcJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7113
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> There are currently only three monitor events, all associated with
> the RDT_RESOURCE_L3 resource. Growing support for additional events
> will be easier with some restructuring to have a single point in
> file system code where all attributes of all events are defined.
> 
> Place all event descriptions into an array mon_event_all[]. Doing
> this has the beneficial side effect of removing the need for
> rdt_resource::evt_list.
> 
> Add resctrl_event_id::QOS_FIRST_EVENT for a lower bound on range
> checks for event ids and as the starting index to scan mon_event_all[].
> 
> Drop the code that builds evt_list and change the two places where
> the list is scanned to scan mon_event_all[] instead using a new
> helper macro for_each_mon_event().
> 
> Architecture code now informs file system code which events are
> available with resctrl_enable_mon_event().
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
> ---

Thank you.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
