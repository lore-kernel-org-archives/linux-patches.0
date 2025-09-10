Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE28223336
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527054; cv=fail; b=kzGy2h2QGFyQP/4h58FG1ycPekXtPfYcwVUBVpNCD7epc/QlUkCaultvjiE6L3rOkW3b4jvgmpNxprmd2A/r92UEuiDzngoNWANvsnJ/1a92rf42rHseg9a7lZ5h6Kv5HbxkYM87OnL5L0Zv3bMXFFTfs+J2flMUq6cQ0LhpgKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527054; c=relaxed/simple;
	bh=Rj8m52okLGvGsjZLPt7DQUYhvMYEtJBJt4dqFC+U9d0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BYXBsPw70/YLUUVZyVUhQsb22TfsC7W+YvpMZnw49KqVmv0LKLaii8AySJW6on2GuydZ1/iCFMThZXwzbdvHZgxqrHkFxK3eQP2HFbvo0hE5Cz/5lp+erzw1ACei3qHkFnFXbiuLP5XC5ZMGxWnZWxrte+3QjlIiKQ0yvIbfiZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cxxEFO3E; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cxxEFO3E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757527053; x=1789063053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rj8m52okLGvGsjZLPt7DQUYhvMYEtJBJt4dqFC+U9d0=;
  b=cxxEFO3EiP5nNoEJ+qz88c3AJ3NLltWn+F80bI1cjoC5/i1J6dI9sKoK
   2VmK2bHk+JQ1xXu3LSNCj84erHTojBXZRxoysI8N2GSwl3ZsOYcloA4XE
   Dlc0WHzj0tnQJ7b978DFoXMDRIfM8UfkU8zG3oq0akExWirLWgMhkyujo
   tVpMvna9bNbrY7mwZ6tHQz8DEXem9zw3JHO6548bD5U28LyPvWqceiEId
   oseSfm+oazD0HPWviqYFb1H3XPqh/bG9/Ll6+VYQPyBSLCMzVYJ4WtIOG
   FbusIOPuCiuszMvKx0WdGr+tgFLcc9I9XYuXxzcF5Kqxfco/BwtJmTH4b
   A==;
X-CSE-ConnectionGUID: zMr+UH6SQXa9zCzuwjQ2Ng==
X-CSE-MsgGUID: AsD4NfSkQSW9V6ZEJc06cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="70102659"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="70102659"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:57:33 -0700
X-CSE-ConnectionGUID: 6RQqvpTkTMC1sjlXrHU45A==
X-CSE-MsgGUID: g+vIfIRMTHGCIxdnyisHYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="172750607"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:57:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:57:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:57:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.73)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:57:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qq80+Jm2NPmZim1AaA5E4XoAq4pzmdQBMgVMWj8dY+/e16beF5dMtW0XWGLMVz6Ljk1AaygbVt1Ko3PSQv+BxKCjKXqxLvnifp0HzQK7AL8e5nau4oEIbsSzL8bFD59YTUtAAXbzepJqWSS3qMeJBZCmHoEYpJLpsV3qMXKkCXgISt1o93KmoyT4d/ocmy5LlOEgr+6rygHjQukdvvFeiVq93nKB09BEOD/0Qs5O14asMV4Hu5ocpm4IiZEIwokHFwYaLOF4XRTwMsjCC3Py7G3URu6U2a+BrFvnI8i2bMf6+Y8QDpP3MAP1nAuWImFeLDuf/ZowMA2bWmVhmJwkYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rT/tPp8T9Ym078Qd4Fya+4mTgTmKWdCy8qGhLYpvsss=;
 b=wAETfa0wtweE8PuutTsxfqhhET+6sV22dmrqYWqPCNoGNgVUVE+1WK+jMzSgIXqTWbMIxtrlqpv8/SPXfUPSVBZ7DLNpgQDsYOVlkO/iZtQssApNIqBWPVXS/Hlja28v1iZVFFdpUu6lIb27CYDmwCZ0vzQAKRsp7uf9be8rF288G3vHiuHj7qjitHAZlqlIfr6Sz1UVwxaQ1c20FXp62ft/oeUFfojI2SHRe+yoPXXQNpK26yRSO987tIQcHPrU/N7Tjx4oxOV4SsFB2PYOgqpsy67XoYIus+vW8opo/0y7xrElhu84vqR38wmUOZmoamoHJz7+G8BLUw91W3Yqzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4694.namprd11.prod.outlook.com (2603:10b6:208:266::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:57:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:57:29 +0000
Message-ID: <c56d91d4-84d4-4098-82aa-7c0338524417@intel.com>
Date: Wed, 10 Sep 2025 10:57:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 26/31] fs,x86/resctrl: Compute number of RMIDs as
 minimum across resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0261.namprd03.prod.outlook.com
 (2603:10b6:303:b4::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4694:EE_
X-MS-Office365-Filtering-Correlation-Id: 345e6568-8bc3-4195-bc4e-08ddf0938235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anVybnBLd3JXbHFMQ3dMTEgzM3pXaUd1VGU2ZGFOSnBrdk5yKy9iVjN1SGdL?=
 =?utf-8?B?eEhKcnF6T0NzenRDZ1JwSzFmUndubVpiekRGOTFidXdKaWNMcmx0ZGdkMGN2?=
 =?utf-8?B?N1JJUkNXWjhpVURxRGhORzNlMlFnM0svVm9RWFlMUXh6UEx5QWI5MFozcWZY?=
 =?utf-8?B?QWlPQmhrSlR4VjJJVmlnTDJLMjlBVE1NL21KTURNOGI2VEZpd2k5Z2lLV09P?=
 =?utf-8?B?UXF6TUdZZXNTMXBYVFNSM1lpRVRBZkV3bjNCak9WR2Zxay9HakFuZWJnVEVr?=
 =?utf-8?B?THRFM05SN3FwWklrVTB0b3FlLzNNZmNBWXZHUjROanFJM2VRTzJpYnNqZ2dP?=
 =?utf-8?B?Um5QZFlXYVRIVzljdW1PdThmdHJzb0tyK213elQ5QkJnZFpBUkYxclJDWktz?=
 =?utf-8?B?dW1sVS81Vzc4QmdrcHNoV3FUVHNQd0tFdFIvTkdqUURqTlBXbUszbm53WDlD?=
 =?utf-8?B?M3BjM1YrTHgyUS9PNnhXRUJEL2RIaUtlUTlPZktxWG9melZvdU1xUUtKejJq?=
 =?utf-8?B?RTZZRzNteVRPNkY3Nm5peFJUTVdRbGxJdXRJSkdZNmhYcW1Ld3BLVFhZMmor?=
 =?utf-8?B?d1dIUy94NW9Mck5iSHRhRjRTNDY1Ly9vcit1K1hOb0lqNmpEcnYyTE5INlZO?=
 =?utf-8?B?d204SStMa0xkMmd0c1VNczlBdnBrNFptLzNsTldGRVRPWTYxLzF1OHJxR2VG?=
 =?utf-8?B?R1ZZVjdlZHNuUEZCbTRPRFJWYk1kNmcreDB0OUg3aXNRRE1jS2huMGZ4aTJ2?=
 =?utf-8?B?VjNXbEExVWJESURISVVqOEwzVTFmRC9sWDhuM3VkdWxITFVEa2xFYUpoMGJM?=
 =?utf-8?B?QStwYVBvUnRVL3BWZlhyUEdzUGVndVpIRU1UY2RBcEQ1cHVoeHlQQlZyTzMz?=
 =?utf-8?B?VnluTTlRNDdGZTBod3VSLytVbXgzSUJzWXk2OG1QcGZPWW1HZlRlU1M4d3NK?=
 =?utf-8?B?aENkTGZvRzNxZEtEdllTcU5Oa1NiVXJEM1dyVFpKUjZJM1VkeGZSVnl6Sksw?=
 =?utf-8?B?OGRxTDdZRTBpQlZzRWxEODdjSUM1OHlUV1B1T2x6Rkxoc05tc2ZoeUwwZDhO?=
 =?utf-8?B?ZEp3c1gvOGhmOFRjNW5sWHFURlJrQTlBZzQ5ejBHd1Q5cGQrTE0zOWRLMlQ2?=
 =?utf-8?B?SjBhOHk2b294alNPZ0JheW9RNzVWTk9iZ3dDMEdYeTgrdHlOdkFQY0RYWWxE?=
 =?utf-8?B?MCtnUTB5eWlYSCtDWXo2QkZsZUJnc1QxYXdqREVZVkRLVjVHU3hSQ1RkYzVu?=
 =?utf-8?B?ZHhnMk5penlQOTVxSHZSNmZjb0RwbXVEZVVzb0g5Yk91dGVUU2dsbWViN2lK?=
 =?utf-8?B?YWQ3OWo3V05YWlgvdjY2dkdqb0hVaXlhdkVRN0VONFM0SUwvSVRCWWJaR0Vx?=
 =?utf-8?B?VVgzSXJyM3B2V1pzak5NdUlxeUhHamRvdnVid1B5ZjFPTVRVUGRFYmhNdkti?=
 =?utf-8?B?RXkzYjZWLzZMeWRxeTlYb1FnWGE4clFmU1lrVG1aR3FleXlwRzFGQ0MwYlU3?=
 =?utf-8?B?VktFbUl3RVkyYkxrS1BQZXN5WWQvR3A5a3pCeWJzTGJ3by8xOGZmcWpBRkZn?=
 =?utf-8?B?dDJ1SEthQ0tQemlscVpLQktTWk5nRjc1WkNZbXVVbWdsZUZtUkdCWkFNRWIz?=
 =?utf-8?B?ODVpcHpPMWh4VG44MEhxMnJBNWdGTm1XV2hONGxLMGxKUlR4cy9OMGtDSEFN?=
 =?utf-8?B?VHJ3c0dCdVc2c2VaR1lxQTBqMm5CbE9pak8ybW1SN0hpY0hZYzRmMWdqT3dw?=
 =?utf-8?B?RW9RVjZmY3hDYUQzN2dtS01sZ3NwaUdyMWxXUHRiK0RKeTZ0TGE2aE44SlNo?=
 =?utf-8?B?SThQWVRKZG94N0VLMEZpL09vdTV5d1NZd3dCM3gvRGd6b3RxdDUrdmtRSU5H?=
 =?utf-8?B?bTJXWjQwK3B4Wi9oR1o3TklYdko0eE45SXk0c09CWVhMNDM0a3o5YWJVM2xo?=
 =?utf-8?Q?oQHmg7mSFhM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1ZRRXd5VGFOOHZmSlVNV1RXaVBjaFlSUHBQTHhhWE54TFRYSWtTbWxXcGtO?=
 =?utf-8?B?aTVHVnFqYTZzcFZZRGlxYlBsUmM5dDU5Tng4bTZ0bVZnREZscU1pQXA5U29w?=
 =?utf-8?B?bmpIL05jSEZvL3RwdThlR0tHaFZMdzZCVjhIQlFQMDlZbkJETWdkZWlOcHc5?=
 =?utf-8?B?MEovS2JxaHRvU0wrTE9aaXRMTTRLUEh6bGt2MHplNnQ4a296Z3ZpMlVVZFE2?=
 =?utf-8?B?OXoyTlhvdVM1WXhVbWJBelhXZ0xLUzRQMG5VRHkwTmwvbkxsNnZVWm0rQ0xz?=
 =?utf-8?B?MjBYclVBdkxpMkFEdTNqYU9HQlhwZ24xUDIvMThEMDBKY1FhRG5PUjc1TWZD?=
 =?utf-8?B?NmFEUjZPNk15bGNiRUdReHFWTm0xMGlLdDRnYnVMc1ZvbEVobVBLQW5XL2ly?=
 =?utf-8?B?RlltcW5wdEZ0eE1NRE16T3c5NXJDM2p5RzF4dlNMUU1ZZXcvL0xVRG9oRFpw?=
 =?utf-8?B?Tnk2SU04V0lzZW8waEZIT21MZWIrSER0OUtZZXVZTXZQQTNlc3kzVjF0Vzhh?=
 =?utf-8?B?dzBOVStHZ3ZNci9Nd3VlcE5sa0IvMEN2NWtXby93Y2xPK2Y1OWVjWmxUdHFQ?=
 =?utf-8?B?QzNNbURuem1HbXhpRXg2NVRmWnlDSUlQdkxVWlY0RmhHUnQ1amxGczNDdUZS?=
 =?utf-8?B?TkJ4azhncnBYTVhWRVFyVE4zajloRStmRjRsYjZqaVo1WVVpTTF0L2JGTTAy?=
 =?utf-8?B?QTZpcWNueHpqYkJhV01FQktXdE1PR3V0TEJyVEh0WXFPeExvUWV6NlJmMVY5?=
 =?utf-8?B?S012eHFHZkVFY3RqcGt0MlkxUzBTK2RxR0NFeFBUdVJmczNZcDlYYkZ4MUZ0?=
 =?utf-8?B?ZkFVQTA5YlJjeW5PaGxwelZDVGtXWTN2UElaUm9QOUdXbUJyK1RZODlHSUxL?=
 =?utf-8?B?bTJxdW5ZTURLKzR4dW1xTWUzZjljcitPNmVCY3ZtRlF4SUNDazFOWUpsZEtv?=
 =?utf-8?B?eWRFQURXcUNyNkJmY29FeHpKZm5mQ29MakFTTmkvWmc3NVhWMmFBcGU4SEZS?=
 =?utf-8?B?dDlqcmpaY2Noakh4TnIxN2lSNThpaG5qNDBwa0gyM05ZeElieVhuT1A4U2hU?=
 =?utf-8?B?MkRPdDBCajdIa3o0ZXVxalM1OS9VSGx1UVN6TTR2cmpVUjJVRlBqOGhiWkNK?=
 =?utf-8?B?dzBNR0JwOXRvWmNhQ2Z2a0wreXpEMmVaM25GaXdJdmZJc2k5aUdoV3VmajYv?=
 =?utf-8?B?bENMZTgwWXZNcElCaUdkTFJxUmh1SWZVMHNhcHVxd3dnRlNrRE9Td29ZeDdS?=
 =?utf-8?B?QXBnUTB4cXlwZEhOaGg2eU1ZZnpvbDF3UklQcCtUZUFTcHFSZmlPQ1dCL2Jj?=
 =?utf-8?B?NVN0dzA4Vk1wVjNHT3kyc01iQjRQVm80cGkyd2NPMXhpUjd5U2JvaXhIMmtL?=
 =?utf-8?B?MnVUcEVxVzl6OFlLano5QklMUkNWNXoycmQ5QzBjSStRVGs4UFEzODNJRDc3?=
 =?utf-8?B?S2VOdDVxVkd6UG5iLzBXbUt0R3JzOXJiNFN5bWIxK1V2aHc4TE9Ia2gyQ3B2?=
 =?utf-8?B?S2tGZS9NM3FEN3NHemcwdUpjS0o2bUFPWHV0RTlkRDBPZ3JyWmU3Y0h2S21x?=
 =?utf-8?B?ZWhZTEhPZ2pEMlFiM0hLd0lHUnRtTEVjS1h5NUkyNTVUeXdKL3JRcGdCeEJ4?=
 =?utf-8?B?ZUJ3VXVtd1NYZ05yVEU0dVFrRzFkUWNvMHJZYkhZTnJBdElqU3EyWkJ2c3FG?=
 =?utf-8?B?Nnh4TFhibE5remdCa2QyTm00cEZGYVdTT3RleWV1RU8wNWF3MmFLTElubWRT?=
 =?utf-8?B?K3pYci9pSUsrOW5idW1OeWZBQjBFNlRqcTFaeVppUnVjWGh0QllQQ0NQYWY0?=
 =?utf-8?B?UHJmcmVSYlNZQlVDditJOHlzTC9ObUdLMWlvaFJhSEN3UFhrQVZuZE5LZHFY?=
 =?utf-8?B?dndZYldJVUs2ZDB1S2R0YmwzVU5qd2NqOE02dkRBWUNZN00rOVlacVBVQUE5?=
 =?utf-8?B?TDNoMWU1NUp4RExIS0xWR1ZsTXJvN3RtMzkyeDAvMlY4VnFtTmVVb0lqV0cz?=
 =?utf-8?B?Z1NHT0p6c014WlVNeU9LeGZQZHBvSC82WGJhL0FIQlhiODVObCt6d2FkY1d6?=
 =?utf-8?B?UHVEb3hLY3BzbCtVeTQvMndHamxpYjhBWHB3cFNJQXJwZGZaaGduUUJrYW5X?=
 =?utf-8?B?Mk1qdVQxS0ZKdStvR3JqWUIweUorbXhPSEdQSWZsQ3ZzU05MdXRXZGt2dENL?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 345e6568-8bc3-4195-bc4e-08ddf0938235
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:57:29.4042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFj9sXAQS0KEzTff7mvPF4pYIV+eUxoA5QKschUCzrB8/tJi766i8waNVn+o3iuNg2q7WUcX5BW4Qb2eRyN0Qtpg8iXvw6/83h/hL3DP2/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4694
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> resctrl assumes that only the L3 resource supports monitor events, so
> it simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as
> the system's number of RMIDs.
> 
> The addition of telemetry events in a different resource breaks that
> assumption.
> 
> Compute the number of available RMIDs as the minimum value across
> all mon_capable resources (analogous to how the number of CLOSIDs
> is computed across alloc_capable resources).
> 
> Note that mount time enumeration of the telemetry resource means that
> this number can be reduced. If this happens, then some memory will
> be wasted as the allocations for rdt_l3_mon_domain::states[] will be

Same comment as v8. :(

> larger than needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
>  fs/resctrl/rdtgroup.c              |  5 +++++
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index dbad8d301e03..8aa7d9105971 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -110,12 +110,23 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>  	},
>  };
>  
> +/**
> + * resctrl_arch_system_num_rmid_idx - Compute number of supported RMIDs
> + *				      (minimum across all mon_capable resource)
> + *
> + * Return: Number of supported RMIDs at time of call. Note that mount time
> + * enumeration of resources may reduce the number.
> + */
>  u32 resctrl_arch_system_num_rmid_idx(void)
>  {
> -	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	u32 num_rmids = U32_MAX;
> +	struct rdt_resource *r;
> +
> +	for_each_mon_capable_rdt_resource(r)
> +		num_rmids = min(num_rmids, r->num_rmid);
>  
>  	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
> -	return r->num_rmid;
> +	return num_rmids == U32_MAX ? 0 : num_rmids;
>  }
>  
>  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 01e42130e98b..3201e9cad8da 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4116,6 +4116,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>   * During boot this may be called before global allocations have been made by
>   * resctrl_l3_mon_resource_init().
>   *
> + * This routine is called at resctrl init time. The number of supported RMIDs

Regarding "This routine is called at resctrl init time.":
domain_setup_l3_mon_state() is called during CPU online that can occur *any* time
after resctrl init, including after resctrl mount.

How about "Called during CPU online that may run as soon as CPU online
callbacks are set up during resctrl initialization."? (Or use "CPU hot plug notifiers
are registered", whatever terms you decide to use consistently.)

> + * may be reduced if additional mon_capable resources are enumerated at mount
> + * time. This means the rdt_l3_mon_domain::mbm_states[] and
> + * rdt_l3_mon_domain::rmid_busy_llc allocations may be larger than needed.
> + *
>   * Returns 0 for success, or -ENOMEM.
>   */
>  static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)

Reinette
