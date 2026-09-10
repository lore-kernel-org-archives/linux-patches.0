Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB9324501D
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012918; cv=fail; b=Ddoz8ExhCyg+xDxlOYz8kFH+1LBCCzEA0GMiDRLWbXZKp222v7O4bNaDNngy0U7M+f2kk/8FvydDMltu4bS4PjZ19axkxdUutaSbqSk1FYqlIA0fqiXxowcsJCGO316oHl5RVy1V2uh///fdgTUqLImuX93IomSAiDyAiwLkf1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012918; c=relaxed/simple;
	bh=F88WSGGlMc8VCfzTBZgwrR/60+6hQx7RuPjXoBvyCr0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TGhTMedmc3IOGpTAVuCYpGULzMBnj0nDE65ofWAhxW+GhYdY3LxgOqACOHV1IQTsEYHXnq3wXAs3Li/l5xFP696jdTnXyMUDa1zAn+Sfu0Y4a/T1SY8xpryqw6M0HCp962Q6xOGuUU4HrB1dem/485+amK7ZqIopmrsh80kGn5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LhfL/wkO; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LhfL/wkO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012917; x=1820548917;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F88WSGGlMc8VCfzTBZgwrR/60+6hQx7RuPjXoBvyCr0=;
  b=LhfL/wkO7Jwk2NaCkki2kMKHXIJEpCMqPz1e9o046/BFNMO2NiskTLsH
   c3H+dF+b9OasLQYv6wMYOA/DKMu4pGkH7nWT04QzENrI2hiewLwUILGjV
   6h5Tg4vXe6KKY6qDANC0ETaLOXZ/5bkkB0Zs/xaVwp7O7Yd5f50O+8fmJ
   fbRSNDp0jSUhrvEtnCGhqdDfRMjyt8etCZ6y1wEB76cIBHHBhULiSD/qR
   Vz6Fa2IXEf/9yb2A0sxRjC8vd/UuAvKWf40ZfTwlkso8L3rPMQDwkU3qv
   gGAKqxL/4R6PNmfLRyTdH81jMoOH9A6XmpfWFmmHkJRUt7Tg/h9zlB6Ye
   Q==;
X-CSE-ConnectionGUID: z1WXUjw6Qqmd0pnv9Tas5Q==
X-CSE-MsgGUID: KCXCjr17R+WVEloHk7sPXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="112225722"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="112225722"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:01:55 -0700
X-CSE-ConnectionGUID: P9gHyZWTSvmiHtwnUXCloQ==
X-CSE-MsgGUID: G4n9sJ/SRz6IsgZEIg3WjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="267821307"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:01:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:01:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:01:52 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.57) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:01:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4ozyvQ91oalWaefV9fKPg3TU55tVzQCy8uuFQUTUR0JOH12MQyt/BPgUGc87Vt7tnrIbtAn5G+eRySVhQOydtWHMET8v+fp/bX0O7+2W3bZd3C3sAlbs1o3bZTpkZ7C3UeID5mlSEglOP7ExQudhmovomPOi+TsiPwnAPeBNm08IeAmbDpHUKElfDHp71dFBoy2A7xuNOuRWCJ7Rt+zzA+RAfDeYFKo29yucWqw2EJm3q8rBcnS2uJUxBkoe87oKCY9Ly3c1xiIK0IalOjv8AClyJSXZDUaVK5a+E49fHRXK1gkXCE1pmJLTJ9/6diEPBVK8BurzpAgX8AjnMv1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nWQv1gOAlpwUpwiehgfj+4s/3HDjCuZFHFakzZ6tZI=;
 b=eo6cVPYenCL47EcL/Ktpc6jDQMiUn5RRSFXWSd6hXyNuNMMnCwR5tnlGzi6uiRFRAyBOApK93CoBeHtl4M8mdK8SnXAf89m+BgwzsBsvIYlk6cOjwK80QZY5pPGj6dSdvT3i6hyvjQH7kl/MVAxKydxe/2o0agqnBmDJetaI4C+nwONYilGk1GIfL6hfLKteGmkPuIuGwaHPv9VIauXnsevTNcO43MyUdTRPjCOx515GUGX24nHIjnY8v3/IvbZnhZrnuurLONVAlHWgy6JpW1IJUA0aLizMYudvpkyyc1XDmhi+V6ritciJ3aMw5s1tfh7cwLHcKVGtwtmIePUkwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 04:01:38 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:01:37 +0000
Message-ID: <0ef770ec-ac65-4a80-b676-a8bd92caea88@intel.com>
Date: Wed, 9 Sep 2026 21:01:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 12/23] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-13-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: d3503225-254e-43f9-91f9-08df0ef03663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|6133799003|10067099003|56012099006|11063799006|4143699003|5023799004|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: ffpNAKBdBkxmESUwZuwkRKrEEF17xYUeUkrlnmXlJAm2kprVr5UZZvy+Nf6UeGpeBOgYZNCfwyQI1H5tZY8Ov7jk8UZNQUU/PaXxzDPiA+3o5Qlvch5g/echWjXSQD+GyJs/TvCrlwzby93khwXE/icYoQbM8EGhxecpm7pDwHCkPKzsYnIKSRc/qMWQfgU8p9YciCXGlE3rwLW0Hoacmy9+oKvnWHw+QddTUuMksszOyRA5L+qmp5sXvkgvIliCJCbUSKP4YESHWhjHUm9JJyJvVn7N5VJnHXsJM3LlP3qywQrlux7vlGNbPP7N0lEL3jIsNHXLyXX0cAk/6sfwBy3vhkB3DixX8VjxLKYTiWV3WIP4Jptwm5YiuyxsL4P5e5tlBvucl8sEyfsSSLCEp2uqGm9GzIypAiuJgqbEx8pF1capjzrB/iqNwxrx/0RcYo/Z6MkSFOt7P8qWCFIA43yGv3ucYsjL5tGeSKlXnCpyoB/MwqejhwjKwx2SznbBbnzT6IhVXD1oXyRktviuU5jNqbW09Dlb0MsWNb7h7CTHYt1eSHwOznzRACYUTH/KXFQXo2Y6M/NXJ6T7F8ZTGq4sob/C9qIEJs1jJQ/ebtiJqIKlVrNz97Kdberk/B3Dv3etApSACITF6LLh6qO3qeVjOTtmPi/a1KD8XQNLSCCXMYmuQI4B1cSgKqquF+UPRLEO6Rk9uCWq47+jRpY8pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c056dG1mOFRETEZxWGxPRUYvbVVYN0paeEU5bzYrL2RwUm9ES1cxQTNJeW9J?=
 =?utf-8?B?dGNPMnRjOWlqRTM1akI1UlB0d1RVdlg4WkQ5bERmVWRQMnA2REN5NHpLcjg1?=
 =?utf-8?B?OWtMd0FsUUFRWVJ2SnVlTVlvUG5uczViYm1GMlc5aTB5Slh6dVVlSjdQL3Zn?=
 =?utf-8?B?dGdYbSsvUS92R2JKUVE4bDVIUFlTV09IK1YraXpkekJEUkw4UEpJcmNWR0hx?=
 =?utf-8?B?bnl6MHJvL3Jkdnl0SDkwb2pFSWdvWFFkeU0wcXhXeUFrYnpmMFB2NXNrZ0V0?=
 =?utf-8?B?eHcvd0Q4eGk2eElWa1VmSlc1QVRWaWVJRzdmbkw4Rnhhb2hNMy9WSGx4czYy?=
 =?utf-8?B?Q0RBc1VkVUo3SGpNWG5RMFAyMGpheC9LUEM3LzFNK3dwelkxb25GZXpaTEhY?=
 =?utf-8?B?RDAzV2sxSW5XWjhLKzlDdjdRZmhYOFhwZHc2R3k5RUtuTkRHYzZTNStvMjd6?=
 =?utf-8?B?Y21uZ1JKQ240TjFQWWthTCtpcnZnZm1wOElkSUxNMFB4dWczQ1F6c3dXcHF2?=
 =?utf-8?B?eHg5YVZwSzU3c0hQOGVnNTIxTThHQTh4cWh5T0dJcHZsdkZVRzJhSzdHa1A2?=
 =?utf-8?B?VmN4bDlWaU1XMnJHSUNpb2ZQN1lHQmFMWmRTS1VDRWo4T1lkZUE0MC9vZkJr?=
 =?utf-8?B?VmpZQkhKSExtRE01Q2ZrMldaS01FTXdGVXZtYVV0bFZ4OFVpNk9vbFJlUU8w?=
 =?utf-8?B?NHByZEthTnBaQlVCeU8raUVDOW90Qkp1TEZZRXV1akJCZzNiWDZWM3E3UVhV?=
 =?utf-8?B?T29Zek9hZ3phVHJRY2ZRT0kwVHFIV05yVmhlcDVlSGc1TzZtd2MzbmxkL0V6?=
 =?utf-8?B?WXh3UUhTS0hEK1RFMnl5SS9jckg4K3EzRVFEWmtjUkVzZHJtaEtYbnRsemJx?=
 =?utf-8?B?eTE5d1UvMTRFTUF2WmxzYXVWVU9TU3pTVGVPSTM4U081bUwvcFZBSTZBZVM5?=
 =?utf-8?B?MUw5RklDRGlGQVpPVytQVEZFT3paV3hnSGFYUUZBY0FQbm44azZHN3dINjE0?=
 =?utf-8?B?TkpqeXFndUVoVUJFKzlVZTN4SFMreFVnSXhjKzgxa1puWThYamRvWlpJZnR2?=
 =?utf-8?B?RitkNU0xbXZWUGdERFJkL1ZScVlqcUs4RXF5bWtxbXlwYmNoL2JIR0ZQdUZY?=
 =?utf-8?B?d2dmM21DVlF3NWRMNm41dzUrU3RDSFozSnpXRzdYWG85d2FZQlQydGNSM1RF?=
 =?utf-8?B?UWpBVEdubnRGK0pUcEMyaTlVYWNIV2M0WUFKb2NOZlNXd1UzMERjZDFaRFZS?=
 =?utf-8?B?TW8rUW82bXpjOFhad2o3YzQ2MkorUnE2cG4raFdIemd3OHJydzVYSVhzcGJr?=
 =?utf-8?B?TE1PMGMraE96MHRlVHF3a3l5c3J6Zkhwa0NBL29VUFdiTUFWL0Y1emV4blRy?=
 =?utf-8?B?R3VlaW5rWDRNanZKU3lnWG5CTUlhK0NIelZmbDlyMTd4dEJRKy9oYTdMUXMz?=
 =?utf-8?B?aUpaRkZDdkJCL2FlbjhPbW5SZ09FVFNTdGlQcEVLZC9rbUV5MHloVko4MWhT?=
 =?utf-8?B?eFBmbHlFdHhZTUpuNHRJQklCSUtmU3J3QnNLcE9JNjJpdXhLLzRtSVVSOEJo?=
 =?utf-8?B?TlVPTzc5UEp0UmNXWnRSemVaVm1mTmlzTHN1N1VDM0NMYVExWmU2M3pTRG8z?=
 =?utf-8?B?ZW1pQ01jcFg4RSthZmtNTHhEeVZ1NDBJdExGbTB1eDZVMWVHVDM5bGduTjF3?=
 =?utf-8?B?M2t1TzE1OW1mb0ZCZFk4Q25wU1N6TXBVODNqdTgvdWtMTXVMRnZlb0lUVlYw?=
 =?utf-8?B?MDZETjRodDROZGlhMC9JR0dpS2pqK1hxenpCSk83OUxhT1lnUGFOMlhwejlJ?=
 =?utf-8?B?YXluWm5TTS9Dd1l1L1c4RjRKc3lyVkJXVitxSXFwWkR5UjM2Y3dxL093YUty?=
 =?utf-8?B?WUpMWkJaeUx3VXJySlRnYnEzNjJ4SnJmMjNrQmFkSGd0Mzg5RDNwbTBqaEx1?=
 =?utf-8?B?dGNicmFOdUFWWGRLQ08wUjUvR1RMQWZpb2F0d2M3OWdDbzhYdytDVmJsV3p2?=
 =?utf-8?B?RHBSTzloUjJWeEYvdUpmNnYrNU1obDZRS1IwdzltUURlOWg4VXM4MERwS3FR?=
 =?utf-8?B?NEkwOThsdHBIZnl1K3hrWnFGdkJTZ2M1N0lZUjFNdXdpQzhLYnU4RUl6cTJk?=
 =?utf-8?B?c0UrcFRkSXpsUVVJQVJLdHU2bnBFNUN5UnA3VFBRSnNhYTBaOFl1RGpxT3Zk?=
 =?utf-8?B?NkpYVTVaOHFDaTVtckpyNzlGdk9pZzZtM0tUa0lzc1QxNFR5Z2JYVWhwVGVB?=
 =?utf-8?B?Kzl4UlNxTDJlK0pZdFRXNXE5MDYrUzJabUswRUZ6M0tUK2xkQitlR1dCNVNH?=
 =?utf-8?B?MzRoVFBIVEdrall6cEd1OGF0MkxoWHNENmNlcXRqejN1UVhtOWdHQlBCOWtn?=
 =?utf-8?Q?aOwxztPcYb0qYg/4=3D?=
X-Exchange-RoutingPolicyChecked: xUexB4qNO5AjP2HyV9W51wyZ0ipTHJhe+qOI7SW/AXoheimzJ43GJxE8S6dG6K6Rqmm6CIlGDgxEyLIkUl70qvuXFaKcKwYpfiuAOCHChKbWxdIpAvRaPEbFzScCsfcQ6IsqCGTuNObT81rjBDUexdpLfnq+aEE/cPJoFCx9hjA2D3PX62iKynoy061RLZxKLhJYQyKmykkqwg3ObCp+YIYzR08sEaOo+WSTFxLXoZci9r1Um+Fn2JmxfclfgDQQeUgDyzQjiJVfHnU2+H53TpJieXFGE+vw+NM9FppQzyimvg2fCjndq3FmcZ4cZWkSc0YOY9aIASBojcHdD4JloQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d3503225-254e-43f9-91f9-08df0ef03663
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:01:37.8794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PUE4lTc+n7zZGc3ORYBaxP4AK+tbs7F+w85wp5/QK6sCwJ4FXv9yYzl3e7B54gWRXC6DVCW3jY7KREMM/fYIdC/yUtt3OLh04q9hldWj6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Application Energy Telemetry (AET) event enumeration takes place
> asynchronously. Linux builds the pmt_telemetry module into the kernel to
> kick off enumeration early enough that it completes before first mount of
> the resctrl file system.
> 
> Allowing pmt_telemetry to be a loadable module means that it is possible
> for different numbers of RMIDs to be supported on each mount, depending
> on whether pmt_telemetry module is loaded.
> 
> For simplicity, calculate the maximum possible number of RMIDs and use
> that value to allocate the rmid_ptrs[] array just once. Use this same
> calculated value for all references to rmid_ptrs[] instead of calling
> resctrl_arch_system_max_rmid_idx() in multiple places.
> 
> Add resctrl_arch_get_num_rmid_idx(r) to report the maximum RMID index
> for a resource. Use it to allocate the rdt_l3_mon_domain::rmid_busy_llc
> bitmap and rdt_l3_mon_domain::mbm_states and when operating on these
> structures.
> 
> The limbo code must deal with changes in the number of RMIDs from one
> mount to the next because some RMIDs may still be "busy" when the file
> system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
> for the remount. In this case RMIDs that can be released are not put
> onto the rmid_free_lru list.

(last sentence needs imperative)

The changelog is reading more like a list of changes. Can some of these
be split out?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Add resctrl_arch_get_num_rmid_idx(r) and use it for allocating
> 	an operating on L3 per-domain dynamically allocated structures.
> 	Update kernel doc comment for max_idx_limit.
> 	Update comment to explain why all RMIDs need to be checked
> 	for LLC cache occupancy.
> 
>  include/linux/resctrl.h            |  8 ++-
>  arch/x86/kernel/cpu/resctrl/core.c | 30 +++++++++++
>  drivers/resctrl/mpam_resctrl.c     | 14 +++++
>  fs/resctrl/monitor.c               | 87 +++++++++++++++++++++---------
>  fs/resctrl/rdtgroup.c              |  6 +--
>  5 files changed, 114 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index e9094d886ba7..4fb06d434c85 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -183,10 +183,12 @@ struct mbm_cntr_cfg {
>   * struct rdt_l3_mon_domain - group of CPUs sharing RDT_RESOURCE_L3 monitoring
>   * @hdr:		common header for different domain types
>   * @ci_id:		cache info id for this domain
> - * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> + * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold. Sized for
> + *			maximum supported RMIDs in L3 resource.
>   * @mbm_states:		Per-event pointer to the MBM event's saved state.
>   *			An MBM event's state is an array of struct mbm_state
>   *			indexed by RMID on x86 or combined CLOSID, RMID on Arm.
> + *			Sized same as @rmid_busy_llc.
>   * @mbm_over:		worker to periodically read MBM h/w counters
>   * @cqm_limbo:		worker to periodically read CQM h/w counters
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
> @@ -440,9 +442,11 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
>  	return WARN_ON_ONCE(1);
>  }
>  
> -/* The number of closid supported by this resource regardless of CDP */
> +/* The number of closid/rmid supported by this resource regardless of CDP */
>  u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
> +u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
> +u32 resctrl_arch_system_max_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
>  /**
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index e851da431dd9..ef37fbb586d3 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -124,6 +124,31 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return num_rmids == U32_MAX ? 0 : num_rmids;
>  }
>  
> +/**
> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> + *
> + * Return: Maximum possible number of RMIDs used for boot time allocations.
> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	u32 ret;
> +
> +	/* CPUID enumerates maximum value that can be written to IA32_PQR_ASSOC.RMID */
> +	ret = cpuid_ebx(0xf) + 1;

This patch with its one caller of resctrl_arch_system_max_rmid_idx() seems ok but this
series adds more callers and with that the repeated CPUID does not seem necessary.
Looking back I wonder if it will not make this work easier to consume if this RMID
count is instead enumerated from get_rdt_mon_resources() and stored in a global
variable. I think doing so would help to understand the dependencies among and capabilities
of the related feature bits. Something like:

	get_rdt_mon_resources()
	{

		if (!cpu_feature_enabled(X86_FEATURE_RDT_M)) /* or boot_cpu_has() */
			return false;

		/* Maximum value that can be written to IA32_PQR_ASSOC.RMID */
		pqr_assoc_max_rmid = cpuid_ebx(0xf) + 1;

		if (!cpu_feature_enabled(X86_FEATURE_L3_MON)) /* or boot_cpu_has() */
			return pqr_assoc_max_rmid > 0;

		/* L3 monitoring enumeration */

		return resctrl_arch_system_max_rmid_idx() > 0;
	}
			
With something like above resctrl_arch_system_max_rmid_idx() could use pqr_assoc_max_rmid
instead of calling CPUID every time?

> +
> +	/*
> +	 * If the system is capable of L3 monitoring the maximum RMID value may
> +	 * be lower than the system maximum. Either because the L3 monitoring
> +	 * feature supports fewer RMIDs, or because SNC (Sub-NUMA Cluster)
> +	 * is enabled and divides RMIDs per cluster.
> +	 */
> +	if (r->mon_capable)
> +		ret = r->mon.num_rmid;
> +
> +	return ret;
> +}
> +
>  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>  {
>  	if (l >= RDT_NUM_RESOURCES)
> @@ -360,6 +385,11 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r)
>  	return resctrl_to_arch_res(r)->num_closid;
>  }
>  
> +u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *r)
> +{
> +	return r->mon.num_rmid;
> +}
> +
>  void rdt_ctrl_update(void *arg)
>  {
>  	struct rdt_hw_resource *hw_res;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 0db62dd2a71c..a117aa98ae90 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -247,11 +247,25 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
>  	return mpam_partid_max + 1;
>  }
>  
> +/*
> + * File system calls this for one-time allocation of structures
> + * during initialization. Return the largest possible value.
> + */

Above comment seems more appropriate for resctrl_arch_system_max_rmid_idx().

> +u32 resctrl_arch_get_num_rmid_idx(struct rdt_resource *ignored)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>  u32 resctrl_arch_system_num_rmid_idx(void)
>  {
>  	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
>  }
>  
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>  u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
>  {
>  	return closid * (mpam_pmg_max + 1) + rmid;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 2a28fe04284b..5340c764bf7f 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
>   */
>  static struct rmid_entry	*rmid_ptrs;
>  
> +/*
> + * @max_idx_limit - The number of elements in rmid_ptrs[].
> + */
> +static u32 max_idx_limit;

Please change this patch to avoid local variables shadow this global.
For example, this patch adds a max_idx_limit local variable to
domain_setup_l3_mon_state.

While the name is technically accurate, could this variable perhaps be
more descriptive with a name like: "num_rmid_ptrs" ?

Reinette

