Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75128682
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487687; cv=fail; b=qfc77oB30/cx0CL8Zo+LoudU7uUbb+bzeO2y/iXvk89KH0/qLGrGnznrgAZUQOObzqvWaSi7UFfVMYDOJWKt07RVzyx5GWacT/FXBdAwA+/AgWJqkOUgSpfIB11ytKw2NQyzaLuVzAZ6sLyCv0LoiIbuI+hWTrsnsf6scpjGFTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487687; c=relaxed/simple;
	bh=WvzTPLmguq92xbFS852M/2zJbttv/8rmy6VoeXRdF6U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rtYnQZm1HVxw68mXh1k1Pv7fqlxuIwzsuwDImq49T3tU8d/BleWzpKUtY7CWh0NOZxGEXfUe3/ty++MXxhD49JngQU8ypUmDZDCxi7uHnOG2H3RwJHVtZ6zNchEe/yzst0V95CwEptfG1AzjZUJW4aeITlTTMk5obbzHBvp3yM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UbXbWcd0; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UbXbWcd0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487686; x=1785023686;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WvzTPLmguq92xbFS852M/2zJbttv/8rmy6VoeXRdF6U=;
  b=UbXbWcd02L0xACPvWEIsTt/mw0/v2KXsEMzVFNepUCriMRzxg3nMwtZe
   zUyRbUwqiILyMVs0pFAzmokde6keoljr801pWLi+v0dbGXP/g8nPE6EIw
   x7gLl4rptpHBL7cU6jrIGn7gEymMRIyPmecMUA3cGxQqFbTdNpr547yzi
   YDpFDO1llfCoc1PeuTYiXM2NkSIneOUSDOmfDBN2J8XAhBs6A5mdYAXav
   /0L8w8aQtqkL/yMBHhff+bapM2KIpbYlcqHMwoTwK5jsjeLiv5A5YlPwr
   DYR/TTkQK9k8MGIRg0M/rZiYDkXWG//JZcgVBkqTQx1FevbPecifc0ZHF
   Q==;
X-CSE-ConnectionGUID: vvXD4Zq5QdOXMaBSkfF4+Q==
X-CSE-MsgGUID: /xMRqQrLT52FD8SOnmy1xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="59628747"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="59628747"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:54:45 -0700
X-CSE-ConnectionGUID: bvlgkCZITUmBP9QDRmQ8qg==
X-CSE-MsgGUID: kZniadp6Tt6WUGXDAEULdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160401958"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:54:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:54:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:54:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.59)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:54:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtM+z9ISl7Zvd9aD5WCP2Lhwd7u5qABjs0FAK6GAQJdHesnjgOW/XSWxEJAebxmGCTBVkNfkflvCeS+zKJWWMgMSRTh4c+Ss0qO4SGKkGNH8BhGzelsNQR8Gt6wZWUsPadDvKCmBU1QeTDQ4yTlyOIG96bpGSNms115AvM3DXhEeyOH019kDDvLPEHb4NjV3dCord6/ZuzxMfk/tuSYm6hnlN6mpNzPhJz7dAH8w4pGFnTcSGok4A2E583c/d4OhLgCCKIIRyk00/Bc4Df/j1HuD35SA/Pfnyr6iUMe0djjetn7qKECwFCDZXuaihfOuV4drLl7WqPiTmstUmm/HdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Rwc1Z2CU66Gbqo2XcnU0Xsp7irEPSXCGzzjc9Lsd38=;
 b=XQEA2oS0qhkAv/CN3NwqSZuOOu/cw/Iubd1T1CUzHutFtRHkgikNt5imZMfymWlgC8ov6t1nYU9rS2py/40zEVEOB28nTV4g8DwocZBwtLaLepstx+oB7MR+nCbapNciMr79R42Cf75SNlYtBg6OiegSqnsyDXDnTICwrqhTGNCmRPEcuN4idAWZzQkcg6+x3TeldQ07/BOQ4nsswkiK9aMGcSoeGtKPx3rn/FzDBF8spi9Zr1EnBz6yNFsHzvM+FYh7Zit1G+aDy+ZNzWVme/xSCgs363hnmDoS9dH/EQPXKaq5Nxo2lf7QfHBEwxqpnRO47SEr/IqlHO6LxNMB1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8826.namprd11.prod.outlook.com (2603:10b6:8:256::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 23:53:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:53:59 +0000
Message-ID: <215dc37f-bfcf-4560-8f31-3774307f4ede@intel.com>
Date: Fri, 25 Jul 2025 16:53:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 27/31] x86,fs/resctrl: Move RMID initialization to
 first mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-28-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:303:83::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f2edfa6-c021-400b-7695-08ddcbd68684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2JkbWdFU0ZreDl4eVBJQ29xSFFHalV5SWZsY3ZuTFA5R2NiRm02ZXdSYjNV?=
 =?utf-8?B?UmNSRzJhcmVhMVJlUFRDaUViVEJrWE9SdVJYOFZtYkxzd0NjbjNhbENMa0RH?=
 =?utf-8?B?VER1b3FleEltQlFIS1EyTU9rTjltc0xNLzh6TGdka2M1NENZTXNWQ01zYzVy?=
 =?utf-8?B?QW5oVTh5bFRwa21jUDZGMHppZXl5dW92R0czdEs4K3ovNWExY0VHVm5IQzhq?=
 =?utf-8?B?cG5uNFdpOHp1eUZjekdPVSt4TVVKNTNvWEpuNTNXT3Q5NThwVVN4RHhYOGhl?=
 =?utf-8?B?ajF4VSs5aG80VHNoTkRRRFRXNE1qa2EwQzNibTM2YzA5K2w1bGNmdVBkRHEx?=
 =?utf-8?B?WjB0aUMvZU1hSUh5WFNJajdmQUova3oxK0l2bFplNzFHbFpLTHowQ2NBT2sx?=
 =?utf-8?B?TDB2U2FxUDRTVXdUUzRaTU9tTnFxNkUwVExKNkhFTm1GSVY1RkJzUE9NcTYv?=
 =?utf-8?B?Ujh0Z3JoRm5laGZ6eEFVSEhXUFhiT2ErU0lVUmZhcGlVaHJXd0dUci9XVXdq?=
 =?utf-8?B?TkZtNzJZeXgxNEJwM3Y4UWwvclJ2TG13U3RTbnhBTEExSm5MUmYzSU5QWXA5?=
 =?utf-8?B?NTFCQklvcXJQZnVCSVVzdE1ZNnRsSEs4elR1OC9BM0txSXhPTkZtMGdjRGlW?=
 =?utf-8?B?YWQxMndTd2dmd1Fud3k2bExoV052QWRiZ29RbTd2R09zN0YyTkhrRTFYejNN?=
 =?utf-8?B?bjN1QVJ2TDZEMUZKMm1ycWRUdjkwaEhZTDhCVjdtUGpEd243akxFSzJaenM0?=
 =?utf-8?B?SDIvaXhaRFV2M2lkTTJVVE5RREtNYTdPT2tKVXBiYkNwQkZXY1hnMU9iLzdl?=
 =?utf-8?B?L3U2N09IZExPajh3YVVvaGNBRTZ0bEZLTjJETllVQitwelorUDFXSzRQcUdp?=
 =?utf-8?B?SjE5a1BCWkh4TjRrL3RFZmN1SXNFVU05TDVPSVFTQmJUMFBWVFdUOGZ4RHhv?=
 =?utf-8?B?UE9zYkRxa3pENWUrVjd1ZDArUFJ3bWp0UmdUOU5XZlM3MXJ5ci94UXZDSDM0?=
 =?utf-8?B?L0FsMXFQeGxWaWMrYmhOaC9lN2RlRUZtNTdITVhDMGY5TFRFYklOUlo4OU9M?=
 =?utf-8?B?djJlVy9wOFdtSFEvM2ZyRG5kNU1KTVRTNzM4anppUHlXTnJTUk05bkhRL01L?=
 =?utf-8?B?MFNTN3oxK2NKMkZ5NGRocEV5YkdWR2NMR3hObHVUc21Kc0xzMXZhcWVmc1FO?=
 =?utf-8?B?TTFGRUY5ejBCSkFUUytaVk9RMXNsZlB6S3hKK3NOQlpTRkdicE41emxVaVlH?=
 =?utf-8?B?c251a1I5NTh6YkRGWXpTQk9rYnEreTZWd052L2ZndVBSRVV2VkFjZEp1ajU4?=
 =?utf-8?B?ZFV1dzBDL1VEYjBSY0RJNyt2eHBmb0ViM0lVUEo4clRvRUYvckNOZHYxUlBK?=
 =?utf-8?B?MEZwN2taZWszaUhYZUQxbmdEeFlkSlFVVWRpN3M3ZDNzSWdJc1JvYkhBZHc3?=
 =?utf-8?B?ZUYrTE5xd3BNa3pGNStIdmJJQVc2aWtjV0JaUjRMT3Zqb0JuZDlNTXpzUjZ6?=
 =?utf-8?B?VnU1b0g2VkhmdVhCc0ZQV1luc0I1VTdBMG9BWEQxUHdmV1RRa0laRXBEKzRo?=
 =?utf-8?B?VUdhc05lWTlVQkxEeXhHakt1QldQcEVQbEROR0dmTU5IQ2xjWlExSUJtZVVH?=
 =?utf-8?B?cUNJRkRTOEdwYytCZk41VjdXOTJTalMvVlNUZEd3cjR1d091bFlDL3pPUjMz?=
 =?utf-8?B?V255UlU3K2tlcVNCVDZGdE56SW1WVnhjeU1MbzQyam5yQTZOcXBXUXN5M05R?=
 =?utf-8?B?eENBOEhjZk84SjQvNTRCQnU0ZXRTcXVhWlFDVnVIM0ZHNFdyYWdtdldrOGFP?=
 =?utf-8?B?MVJmbU0zUTZjRkV6dWNqd1JWbzZRN3BITzlLZmxqY0lXdWZ5Q25oR2R6MERG?=
 =?utf-8?B?NkVPcDBhTVZOcTY2UHBGYlJZQ2s0QTBBd0hXMlA3blFQaUVidkFUVTYwTUpZ?=
 =?utf-8?Q?nbhYdfuqvTg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkFqdkxTWVR0cXl0bFlqc3Z3Vm5UaStQZXpTTEpRTzNzZU1TaktmQjI0QnQy?=
 =?utf-8?B?TEoxbkdxMFYydGIyMUtwWnNwNHNSTllFaFBVOE4yaWpjeWpJNHY3am1GRmxv?=
 =?utf-8?B?NmQ3U2tlNmFqMnEyK2I5U09VMHZMRExoM2lPSk5BUitDbVpHWGNwRmZaWnpY?=
 =?utf-8?B?cnZpYzhqTVdyWU9TS0ZSblAya2JtZ09paTJPdnZwOWxIaW82NWdLKzkxeE53?=
 =?utf-8?B?NmdnRGVreHNlWExoaVQyUmZhdEJ5VlB5a3ZIZklTQ2VtZzEwT2l6b2tqK1lU?=
 =?utf-8?B?N2VkQll1RmdPaVBhUVZXVkRwTnBQWHQrUGZpRXVucDExbkhxMW9maXlMa2Jk?=
 =?utf-8?B?MXoyZ0lXMjVFSjVCU1I3QVBXL2o5dGZORjkwSGdnUnhLQldrOElWUlhMenJR?=
 =?utf-8?B?NGVLRmlwYVgxWFdiYXdUQmFGSk5peFVmSHVBNGZCdEpkaWYwYnVwVlBoc21r?=
 =?utf-8?B?WTcyNkdoUEVNaUtMMm04NnoySHpBK3JzSENRUHp1d0tvM1FrNTRXVUExYi9E?=
 =?utf-8?B?YXZRZHhnZGYzdXA1TXIxYmJBYVpXdW5CcGY4TmR5S3hnUmdzMmJpeVc3bUJi?=
 =?utf-8?B?WjhMU01EZC9CMjE3T250MXg0T1prWkw0d0htTWYvaU5ESGoraWpxanR4V1c2?=
 =?utf-8?B?RXpaTk94TG9kb25vTEtZWHdoK0JhdXRDL3RPV2VZY3lLRlFUZ2JLejlMTTdy?=
 =?utf-8?B?bER2WDMyUUdkZVh5M3M2MUxDczBBMXl4OXVqb1hNSkROdUxGSStSYXdXU01u?=
 =?utf-8?B?Um1LVTVuazQ2dVJZcGVqc2UveVJzd2VJNjQwWWtLV1Q0azZzZHdXM3E5NFpR?=
 =?utf-8?B?QnB4SlhOYSthSm4zZGh1eWlIMVgyN3IxK1VHcEFKR0tpam5TS2dYUUxuSnRN?=
 =?utf-8?B?MU9NNXM5Y2pKVDhrWkVlQ2dwM3hzcEg2eGVpdmR1cGpSUm16ZDkrZS8wSXRn?=
 =?utf-8?B?MFJzMC9VVTZKMEwwdzk4RUN3TWRQL2d0VmYxSG85SlBZUWcxdk5yWjl2UEp1?=
 =?utf-8?B?dUx3dG9MLzlVaHNyaVVGbTRjNGIzQUxuZHp0MEZnMUl3M2k5a0RnMlBLQndq?=
 =?utf-8?B?WGwyYSt5SWVMaFh3eFZqbkNLM01iYlR1Y3d3bno5ODg4SXAwOVNtOUI4VkJG?=
 =?utf-8?B?MkM5VXVvb2FDa0g5ZWdjcFo1K05SR0lOMXZPdFlFUFVDZUc3dHMxcDByRXdD?=
 =?utf-8?B?L2VIckJib2lTL1RmZ3Q3ZXQzU1ZxdU1tQ2grT095blNsZGgwa1JwYkJNUTI2?=
 =?utf-8?B?SDNDcW9idVVLeEh5N0xoQnIxVlpQbnFlMC9xVHFjVWNXNWpZRFdwNlRpOHEr?=
 =?utf-8?B?QzFMbUd6MTBMYXVjNzUvbVNHVFlxMm01ZDNtaGVrUHNLNEtLWkRZVHhPSXlQ?=
 =?utf-8?B?UjZaZ205aWVYb09YSjdrenc0Q0IxOUl3ZnEvZVozeDVUMGY5bDNlRmhFY3B0?=
 =?utf-8?B?U2MydENudS9kK2NaZnQ4SjFrQTQ0QUJ0ajNBQWVLSXZzZG9EdEovUXB3YUo1?=
 =?utf-8?B?SHdCRDJ5dUZTTlo1R09FaWhLdnlLc053cmxrYWV6OXFxZkpUeDRuTXRwZk5K?=
 =?utf-8?B?SFJrVm43NEFtVnNXQTVWL2xaU0pUSkdhWWhFVUtFZUdxNEt3bEl1ZU50L3lo?=
 =?utf-8?B?aEhTM3hzeENzcEg2bzltZGZHQ2lXUFNRUFVid0lRUjZmdjlnQkNhcWVNTlpv?=
 =?utf-8?B?OW9EbWMxU0Q2RXltbjV2MHdhQlc3dUQ1Tkl1NnpjVlRpMVRHVTNEblBOaDBB?=
 =?utf-8?B?bEdscHBBazJPcGl5NXM1YUhSTGQvWmc5WktlM2Z1MGJKN3FLZ0Z3blhtWnVW?=
 =?utf-8?B?dW51YkxKNkowdmdJQXVqTGJSVm9UUWZOTnFoc2tZMkxUSmJvaUNLVzBFalov?=
 =?utf-8?B?NDNiU25SZDN3bFhSd2tIQTVzeCs4NVo2YW8xR211RUtHUi9EZldVY3FuNjRP?=
 =?utf-8?B?OXhiSllvTlVtS0gvOGljNVNqb0ZmbkdYWk1DYlZHdnNrVFhTVHpRZElEbktv?=
 =?utf-8?B?VjcxczRNcTl5UkdDOFEwVG9KdW9hNFlIQk50VmtiWXlXbEVDdzR0N2pnaVF5?=
 =?utf-8?B?M21QcEhkeC9WendPQ05IUXhrREo3MWJxa1U5cWZYWVJ1bjVsN3RpbW5KbGFz?=
 =?utf-8?B?YTdHVnJzSkxPSTZGTUxnaG9LdGtOUXM3NDByOE9UYVhoam9qRFpKVWw0TmpU?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2edfa6-c021-400b-7695-08ddcbd68684
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:53:59.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYCFSMZmx6bHal4L4PZPztgVksTy9KsOQpVL8nE5W51H56XZ9biEuLxxWG+kdN5bFXapnfOHtJOl2tXt+8pdxk7FlNMhLa8AuyHvYGhGvms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8826
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> The resctrl file system code assumed that the only monitor events were

resctrl assumes ... etc. etc.

> tied to the RDT_RESOURCE_L3 resource. Also that the number of supported
> RMIDs was enumerated during early initialization.
> 
> RDT_RESOURCE_PERF_PKG breaks both of those assumptions.

Please give detail how assumptions are broken. 

> 
> Delay the final enumeration of the number of RMIDs and subsequent
> allocation of structures until first mount of the resctrl file system
> so that the number of usable RMIDs can be computed as the minimum
> value from all enabled monitor resources.

This needs more thought. The idea of "final enumeration of the number of RMIDs"
does not exist. This patch modifies resctrl_arch_system_num_rmid_idx() to
compute number of RMIDs differently but there is *no* change to when
resctrl_arch_system_num_rmid_idx() is called. For example, 
resctrl_arch_system_num_rmid_idx() is called as part of L3 monitor domain
initialization during CPU online that can happen long before resctrl mount.
resctrl_arch_system_num_rmid_idx() will return the number of RMIDs known
at that time that may be different from the "final enumeration". The
L3 monitor domain structures are thus created with potentially a
different RMID count than what the system will end up being able to use.

Claiming that this "delay of final enumeration of number of RMIDs and subsequent
allocation of structures until first mount" applies to all enabled monitor
resources is false.

Allocating the L3 monitoring data structures early based on RMID values known at
that time may be ok based on how system-wide RMIDs are chosen (it can only be smaller).
This will thus result in wasted space but I expect will work just fine.
A comment similar to that used during closid_num_dirty_rmid
could work but hiding implications like this just makes resctrl code
harder to understand and maintain.

> Since the dom_data* functions now only allocate/free structures
> used for RMIDs, rename: dom_data_init() -> rmid_init(),
> dom_data_exit() -> rmid_exit().

These names seem very generic. How about setup_rmid_lru_list()/free_rmid_lru_list()?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h              |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c |  8 ++++++--
>  fs/resctrl/monitor.c               | 26 +++++++++-----------------
>  fs/resctrl/rdtgroup.c              |  6 ++++++
>  4 files changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 28d505efdb7c..7fca1849742f 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -358,6 +358,8 @@ int alloc_rmid(u32 closid);
>  
>  void free_rmid(u32 closid, u32 rmid);
>  
> +int rmid_init(void);
> +
>  int resctrl_mon_l3_resource_init(void);
>  
>  void resctrl_mon_l3_resource_exit(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 31fb598482bf..1a6635cc5b37 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -112,10 +112,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>  
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
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index e3eceba70713..3fe81c43e5e8 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -833,20 +833,19 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
>  }
>  
> -static int dom_data_init(struct rdt_resource *r)
> +int rmid_init(void)
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	struct rmid_entry *entry = NULL;
> -	int err = 0, i;
>  	u32 idx;
> +	int i;
>  
> -	mutex_lock(&rdtgroup_mutex);
> +	if (rmid_ptrs)
> +		return 0;
>  
>  	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
> -	if (!rmid_ptrs) {
> -		err = -ENOMEM;
> -		goto out_unlock;
> -	}
> +	if (!rmid_ptrs)
> +		return -ENOMEM;
>  
>  	for (i = 0; i < idx_limit; i++) {
>  		entry = &rmid_ptrs[i];
> @@ -866,13 +865,10 @@ static int dom_data_init(struct rdt_resource *r)
>  	entry = __rmid_entry(idx);
>  	list_del(&entry->list);
>  
> -out_unlock:
> -	mutex_unlock(&rdtgroup_mutex);
> -
> -	return err;
> +	return 0;
>  }
>  
> -static void dom_data_exit(struct rdt_resource *r)
> +static void rmid_exit(struct rdt_resource *r)
>  {
>  	mutex_lock(&rdtgroup_mutex);
>  
> @@ -965,10 +961,6 @@ int resctrl_mon_l3_resource_init(void)

Please take a look at all functions modified to ensure function comments
are still accurate. For example, resctrl_mon_l3_resource_init() still
claims to manage rmid_ptrs[] after this change ...

>  	if (ret)
>  		return ret;
>  
> -	ret = dom_data_init(r);
> -	if (ret)
> -		return ret;
> -
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>  		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_total_bytes_config",
> @@ -993,5 +985,5 @@ void resctrl_mon_l3_resource_exit(void)
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>  
>  	closid_num_dirty_rmid_exit();
> -	dom_data_exit(r);
> +	rmid_exit(r);

Please do not call rmid_exit() from resctrl_mon_l3_resource_exit(). Doing so
breaks symmetry with resctrl_mon_l3_resource_init() which is especially
confusing with resctrl_mon_l3_resource_exit() called on failure exit 
from resctrl_mon_l3_resource_init(). 

It can just be called directly from resctrl_exit()?

>  }
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index b45f3d63c629..9e667d3a93ae 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2599,6 +2599,12 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	if (resctrl_arch_mon_capable()) {
> +		ret = rmid_init();

The reference to "resctrl_init()" in comments seem quite stale now.

> +		if (ret)
> +			goto out;
> +	}
> +
>  	ret = rdtgroup_setup_root(ctx);
>  	if (ret)
>  		goto out;

Reinette
