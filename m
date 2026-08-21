Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA032D3A7C
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 21:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787346049; cv=fail; b=Kuyu5yrTVl315mh2xOZ4xAS48Q+pPZhghbvdJtVDlzp5FyWNqd6982xNPYeYnYLZZ81QFoZm53Q18LhWa9S8qwsspc3GhI/hsS92IOT8dYvGOebzhEZmO/AKPiByKdjyTAHDbV657DzBPT3/GdjiWyrr77x5snRQlWSFEzca6lA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787346049; c=relaxed/simple;
	bh=bZcgTVH7+U2daBlTwwJYECg6bf3v5XURGBRs6JtuKs8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CeaBRQ8BtvwraQ8majvfJ/Sr9L97U4Iu5d990SO9GpszfV8iWs/NL6NSGf3BJWDeRHOT9IeccyBmPhjG9KU6fHygE/GIEmyVTDdneuqaGyzZYuD8XGk8gUq44Knk2Qgz6lK/NRFj8FtN2Y8JkKbNKMULoIWt7JvvctVj+NKrOhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jpq+qHBv; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jpq+qHBv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787346048; x=1818882048;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bZcgTVH7+U2daBlTwwJYECg6bf3v5XURGBRs6JtuKs8=;
  b=Jpq+qHBvFlIwosMLXj73DTk/eEp/F0xM343mQUFeRA9EBrigiCAmvcQk
   dKRrLW21H+7iUSktBxReme28oJbsdcHZ3eSkstuZpCrIowB1eiXEvqiRa
   BHcCMDElsMhRf3qHriULGj2LTtfKrJDgFejzIcFm4KRDl4xjQwWy9xy5k
   iYD1FeIxAVkpMMap1r2wXpxw1A8etBSzcWY175UGGCxuJs/DfF6Pz+lr7
   mMC5D9DcT1r/4B51hju8g+NMEZMUaXFk9C8Zbb4bAFWDPwC2jzrdaRRdu
   49S2YpVthn5hCbRWbZ4mZU7hGZvML5wzO/vClOjnsFQ8bXOI79bSHQ5c6
   Q==;
X-CSE-ConnectionGUID: B/+sG5qcShWMlHrR6qtrQw==
X-CSE-MsgGUID: UtsXRjgGQ3qnxIcXetwcwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11882"; a="87759244"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="87759244"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 14:00:48 -0700
X-CSE-ConnectionGUID: GuyTN3ugRbOIUbZ1ztAj6g==
X-CSE-MsgGUID: 4oLJWA7VRZ26JI+XZCzCQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="263182906"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 14:00:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 14:00:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 14:00:46 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.56) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 14:00:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8PFV/kf3INnYr5LHEgdu+3X/hQzkuwpmUP7rG2oF6upcXxtpVE2RdD1Ir5DR7IskN7+UV6ADT/QaiiPVSEXeUMY/JEWMJVgMP5s0ZPIb/DaskjFXEMpl8FGvQiycyCcMUwwoaHLwaoMNuoIDOUgSN+8isPLZ+Z1TYlgYV45+PBP5W9730kcOY5jFJIWmU7ZB2wRrrc6rD0X/ClZmIt+1fXZxsYQGn+B19RRBDvEs6QL2NsrSbN6xVGUQ6o+/VMM0AKmk85JHYNrOqzGYzmzptFh8TT7BIQm8toy395/uCFUX6Yrzp+nsa1U+0B0BcRG8sR2KpuL2YwKfWYRgrAKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Pt2s9gPOJ2PbYrsYb+gU90R6h9Qx6QJ197JHzT32aA=;
 b=JXDViWy+cMImjupEilMTrFG+CIaqtdXLZTSOzF/v/oTqf/L8ILOPg250b8giJpfjy/EdnC+m5/huLwospj+Fw3CQir3zxMM5ySihe/pLaaEx+wRsoW+9n9us5TvKxFS1DHOcYJo9VpBn//RksL2PQc0HIqtAgTIaBnwczmvDEbWQAoq9oEzbjcT5PslmU8zZJpqnS/0S7AdcAEeX73OyvKLdKLZCpcdiCfe+6DeVv01j5lwTOfPRtMymvjhGvCo9tiJgSV/UWSE/9nBCnyRWIkSmY0EaUhH05/AW6kNa77lVnBtujrpkDpYe+wWBHZnNOOeDP3xKB/s0jPzjYv9+nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS0PR11MB8205.namprd11.prod.outlook.com (2603:10b6:8:162::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 21:00:44 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 21:00:44 +0000
Message-ID: <c3cd54b2-8752-47b9-8864-8444254e8be8@intel.com>
Date: Fri, 21 Aug 2026 14:00:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] x86/resctrl: Check if monitoring features are
 enabled
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260819161323.11587-1-tony.luck@intel.com>
 <20260819161323.11587-2-tony.luck@intel.com>
 <9787f9de-c72d-4c0d-b9a9-867b0f4377f5@intel.com>
 <aoiqiAEFJfCxhLVk@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aoiqiAEFJfCxhLVk@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0348.namprd04.prod.outlook.com
 (2603:10b6:303:8a::23) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS0PR11MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 888fa82a-203a-4960-39b5-08deffc743e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|4143699003|11063799006|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: gAx6Zz+ovOVwAVYPy5rFfQiF3jsXhuxwx2mQtOLh/H2R4OOd7jhgAHFcpjdLb0uIZgK6aYfDEAlHeB998U0W2i7VOsYU5+u1F3hfG+hX+df7rlqS5cr9khbr9D4jzsogUnIXH12fzrerJM0htGaZxJ0reSPF2wAIJIjV/RJUwWtuUuMPEdPTm+Nov/dXtEtj/98W+KCAPngEeKDorYlTL9KMQqSYwsXzYYOTcLxtbCrNDaOVUymJqJn4h2T1QH/viB858QL3ijKBnNI8ysfj/tXVL33HF4lYZY6rarm42IOQtJBkUXv2r+/iFMqvIl70ww9j2GJV34J0LKkz4Z26FQ0t0oXHkDpVzqluToCT9+gSuK+4TCA1e9NKqGZcwF8MI/FjHu2W3MsK/taY+APEWg6AVSSg2KDf7ikRlgav14nKRZmdS97F7iYiu0fLD7cqvNEEhftMSN8/42UhV83+r/yEfo1PFpgrZ7n5NGjyISCGbBC2ARc8dF/WjnFyXQszF7G21p0/IqF+Jb3BknvGSro4ceOZiLdesWA1HiU9IHqvNGScByxkQhzCc+nAyF9nWR2MxETqEGop5YtgEPssYl38pBgGltZtm3b9cKi+JBMYvOvaWNUE3Crrh2EAt8rrDJ5D3h/Lg6jFpOSJSkn9SNEudVvLwCLgYAl/bAMa0GQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHZ0QSsxZlBldDNsMGM1VisvUFRpSFJYQXJlNnNGQTdVMkRwS1g0b0ZjTkJL?=
 =?utf-8?B?MFhkSm5ZYkt4Wkltand2WlVYQ3E2Q0E5eWZZQmZLQnNpeVdZVFdqVGFrS0xi?=
 =?utf-8?B?dm01dlN5VmZnTXNZNHVScHNiT3BuRkRCMzRFQVk0MUtNVmJ2T2xXNWdtMlkv?=
 =?utf-8?B?RG45cTlIMGMrbGdhZmM2Ymc5aVVQSGNnWTloREpjOEJ1cDJ3bDErMmRkcUpW?=
 =?utf-8?B?TnNTK29RL2tNS1VLZHI5eDBGUjJIYlBtbDFNdHQ0engvUVI5UWpJYThLb3B6?=
 =?utf-8?B?bDZoOFRvNkpjSDNHbDMrQTArVFFMUnZucnN5S0hVMFNsQi9IbXoyT0dzVVpi?=
 =?utf-8?B?Y0xWUUtGRVU4SWxwRmNGUFRvZXBqOUFheFlUckJwNTFYN1pTa3JnSTFRL1Jz?=
 =?utf-8?B?TUtIMWpBTCsvaXFnQmJNbnd0WGM3dk9HWTlIZ3M2T1BlN2lKSE9PdUFOblFP?=
 =?utf-8?B?cUhqa0tJS2hueFJrM0RXVC9oeDhlOUZ2YWcvLzN6TzQ2RFdyY0lWa3hodXVt?=
 =?utf-8?B?Sk1iRlhPM2JaSFJkRUZ4dXUwZFcwQW9IYUdJY012UDRzYVF3OTdMSUF2dElI?=
 =?utf-8?B?OWRJWTBtM0pKMi8rR3F5STdQSDQxNXNPdUUxNWk1aW1JYlVtcXFlQXN3T3M0?=
 =?utf-8?B?MXhrdTdrVGlmNFR3TTA0dVJuTGF2bEhPeXhPa0czS3Nxek90eUlLYkswZkNz?=
 =?utf-8?B?M1FnK2E2d25MTVBERUNsS2ViUGVFZlVRS1h1dTBpSmtRakthcS85Zy95Rjkr?=
 =?utf-8?B?d04xemRmcTNaWmdsQ2w5YkVMa3VwcVNkUXgveEIzRDloaVJvMHNndEJIeFIy?=
 =?utf-8?B?NzJoSjlweE0zeWFXMUk2Qm04K2kxdUlmbUw0dHV3TDNVbitLbFd4eXlzRUFq?=
 =?utf-8?B?UWh6aitJbmdjYVYzTXU5MXBOS1VXeGlKSkhJd3RGUEw5MnEwN0EwMVIwNkpC?=
 =?utf-8?B?K2tVZktkeTFkbi8vN0FMVENjaFlKcWJrVXY4TFpxVlhWZlJ4bkpGazgwNXZl?=
 =?utf-8?B?aU5sOUs2RnJsQitlTnBqTEVLSU9COTRFRXc4UDBkOW1peURPUzA2RzdaMU1y?=
 =?utf-8?B?SFBNRmdWZDZnaGtKbWNmeklHeXRLQXAyRUNKaWJhVE1Fc3dVWTJMSkxzcVBF?=
 =?utf-8?B?eW9GNml3Qk1JcUpCcks4ZG9lWHNLTXdTK3EyTmxSaTMxZGUzZEM1ZFJSbTlq?=
 =?utf-8?B?UGVaZnpGOEZxZHB3N2ttZUxRS3FRSzhsTWRCVzhYaVA1blZDbE8xRmkrN1Yr?=
 =?utf-8?B?QjNrY0NoUE1pQUIvYlpJZll0cGdSdWErdS9XLzcrVU02ekkvaVBtS2l4cUJE?=
 =?utf-8?B?ZnFySGEyQkt6RmhXOGo0bndiZ0RQRTVVbTYwdUdkS1EwWWQ0RTBJV09XZEJY?=
 =?utf-8?B?ZkhkYzdaaTNVSS9CK01FV3kwbWVOdFM3a25XRWRjUVQ1a3diL0hlanlUOG5u?=
 =?utf-8?B?RzBqWEFXSHpiQm5jSnJESnE0eDdXWW5ETnBFMUV0QkRXSG9uRXNRZ2hWUThY?=
 =?utf-8?B?OEVXZ1lUdW1VUXhwRURVSmRaMkI5aDA4RGJMSEFsZ3d2T1dSdndIQm9taVll?=
 =?utf-8?B?WldmSFRPTjRIQm1JbkNzeGdRZEp6NTNScmNSVXlPWHFJWlZ1dTJIRjAzZSta?=
 =?utf-8?B?OG5uekhYSnIvM0Z2Tmo1MFcrL2xBUWxzU3NlalExc2FEV0hSY1IxeFdsRHYx?=
 =?utf-8?B?cnRSYnlaWGhjalJyQTUvZjlTOHEycUdwbWFSajhaMUlJVUxyOU43NUNIb2J1?=
 =?utf-8?B?eVdjbFFGa1NSSlRMbTdITVo1RkNOTmZEOTRnTkVCRzVsdUQ2VUt5T3BIcVFV?=
 =?utf-8?B?SjhFU3hmMDJuRktEdEpEQjRKNFc3OEhhOUpzRkZ1b2RMWGJOQUZHNWJ1d0Fz?=
 =?utf-8?B?RjFURkNjSkxYdE5yVFlNdmtzWDV3L3lTRUgvTHVGR0YzQ2tZclJtb1JWazBo?=
 =?utf-8?B?c0l3VzZPL0R4NUJjbkR1dVhMVytyZUxHS1hSSWNLVTZLTTJTdnFLMlhWLzlU?=
 =?utf-8?B?azJ2UzJMRGRKS0lZSkhlQ21nalhuY1ozQ3JXNzQwa3JBbVFNSGtKMERBNGdV?=
 =?utf-8?B?T0tuck1nanVKcXhia2xwamJYNjNLd0JLUTNVWE9YQUUrWGQxVWExOFJraVBX?=
 =?utf-8?B?bmNJWEt2bGtXTUo1dHhIdTBsRlJYM0xvQ1pRcjZNOVJvQWxKcDh5N3ZSR1dm?=
 =?utf-8?B?eXZBN3lBbFJSN1ZqemR6TDlJamd5N0V0SlJ0S0tBZ0Nuc3NMSnUzWjZIRXQ3?=
 =?utf-8?B?WW0yUVJkMnFVb1dMS2Yxb2FBYjBiYlJjKzdHMlRodXFuS0QrSTZDbGlNZGdR?=
 =?utf-8?B?ald6N0FJeEpLS2NqU3k0MG83N2dTMVhRcmdNZTBzWG5OdFd2amtWbGpsRi9h?=
 =?utf-8?Q?ZoBpvq5JvUkDUxY4=3D?=
X-Exchange-RoutingPolicyChecked: G83B97GGoQ3OmIMxBLGON4qFodHtwAAiEAcSEbD+WV+FXsHMKurNOuyNHHD3457z0eBmGYcdnBIWyJ9PZ9tH0/e3Vdlq5OU6y8DHYw28ifWq0QlOkxQp2HoDS8ncK2sx0rxwK5yD0fqYQkXNL5r79T2n9e+DT/mW2CK1I8oXxBALRbPkzO9QiUWc6b8v5V80W4rpeQ4Krk3pgp70z7qnfs1MaGGUfRwFzMmr0BVBgbFEDwBWSQTgDBhVVa642K9CxFTD0RXWba/ZC+kBWtPLjv51m5SExsr28qPe4C5QTzrGHKEJOChc1Jsb3n7cKW9T/bkQCSzgFvKphRqtK9T07Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 888fa82a-203a-4960-39b5-08deffc743e9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 21:00:43.9005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMRDAc6vHcDxH/UBN09MbXP739yCcAf38oNKQGUX3a5bBrKf33m+m0LnsLVkY6k5HzpOAaza1AD67qvvNTISOkPsUeH6lyofh+VHPCh/EAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8205
X-OriginatorOrg: intel.com

Hi Tony,

On 8/21/26 12:44 PM, Luck, Tony wrote:
> On Fri, Aug 21, 2026 at 11:18:51AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> Thank you for doing this.
>>
>> On 8/19/26 9:13 AM, Tony Luck wrote:
>>> Both Intel and AMD manuals say that software must first check
>>> CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
>>> before checking for specific features enabled in subleaves.
>>>
>>> Add the check for X86_FEATURE_CQM.
>>>
>>> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  arch/x86/kernel/cpu/resctrl/core.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index 55214d6fdc49..2677b8a6c15b 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -968,6 +968,9 @@ static __init bool get_rdt_mon_resources(void)
>>>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>>  	bool ret = false;
>>>  
>>> +	if (!cpu_feature_enabled(X86_FEATURE_CQM))
>>> +		return false;
>>
>> Is this missing a check of X86_FEATURE_CQM_LLC also?
>>
>> As I understand resctrl learns from X86_FEATURE_CQM whether the system supports
>> resource monitoring in general. Contrary to what the feature name suggests, there is
>> another step needed to determine which resource(s) support monitoring via
>> CPUID(0xF,0x0).EDX where bit 1 indicates LLC monitoring that needs to be set before
>> the LLC resource-specific monitoring properties can/should be determined.
> 
> Yes. Missing that check. I agree that the feature define names are bad.
> 
> To avoid continued confusion I should rename the #defines to match the
> bit names in the Intel SDM (but leaving the /proc/cpuinfo visible
> strings at "cqm" and "cqm_llc" as those are user ABI now).

Naming is as always complicated and here I do not see why the name should be
picked from Intel SDM instead of AMD's spec. Renaming may be secondary goal. It may even
add to confusion to have feature name mismatch what is exposed to user space? A change
like this could perhaps be punted to when/if monitoring of a new resource needs to be
supported?

> 
> X86_FEATURE_CQM -> X86_FEATURE_RDT_M
> X86_FEATURE_CQM_LLC -> X86_FEATURE_L3_MON
> 
>>
>> Apart from the checks here I see that cpuid_deps[] accurately reflects the relationship
>> between X86_FEATURE_CQM_LLC and the different LLC monitoring features checked for below.
>> I do not see cpuid_deps[] capturing the relationship between X86_FEATURE_CQM and
>> X86_FEATURE_CQM_LLC though. Could adding it complete the handling of relationships between
>> these leaves?
> 
> Yes.
>>
>> Similarly I think cpuid_deps[] may be missing X86_FEATURE_ABMC's dependency on 
>> X86_FEATURE_CQM_LLC. 
> 
> Maybe no? X86_FEATURE_ABMC isn't enumerated in CPUID(0xF,*). It comes
> from the AMD CPUID(0x80000020,0)EBX{5}
> 
> Babu: The AMD architecture programmer's manual just says:
> 
>   "Support for ABMC is identified by CPUID Fn8000_0020_EBX_x0[ABMC] (bit 5)
>    being set. If ABMC is supported, the feature’s attributes and capabilities
>    are enumerated by CPUID Fn8000_0020_x5 as detailed in Appendix E of APM volume 3"
> 
> It isn't explicitly stated whether this depends on CPUID Fn0000_000F_x0
> EDX{1}, which AMD names: "L3CacheMon - L3 monitoring capability"

Even if the spec does not explicitly state this, the implementation requires this.

I believe patch 2/4 makes this clear since it demonstrates how resctrl obtains the general
L3 monitoring properties from CPUID(0xF, 0x1) before moving to the ABMC feature specific
properties.

How these general L3 monitoring properties are required by ABMC can also be seen
in the ABMC counter reading code:  resctrl_arch_cntr_read() calls get_corrected_val()
that uses the general L3 monitoring properties hw_res->mbm_width and hw_res->mon_scale.
ABMC feature properties also do not expose its own number of RMID supported, this is
learned from general L3 monitoring properties.

One item of note here is just that ABMC (as I understand) does _not_ depend on any of
the individual L3 monitoring features (X86_FEATURE_CQM_OCCUP_LLC, X86_FEATURE_CQM_MBM_TOTAL,
and X86_FEATURE_CQM_MBM_LOCAL) since it defines its own transactions that can be counted.

Reinette
