Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E8049BD9C
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263678; cv=fail; b=LDQ9xhL0KOBBLeNAxdjOxExQifLotxntiSeosBXxoppMSWFlmrS/mDpjDF38QC/BKaIBj0pbfl/1wbn+oDDEmqhzIN3Wwo2wtN1dmVDS/T9v/sxU9lKyOYd5vYVBXuzI3QeaDtMfcKPGBl6/1L2yPWaMEq9bfS/nOUeEqT7NK3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263678; c=relaxed/simple;
	bh=RRGhS4J+6eUIY2/Hk70xq6rjrhAcuRtoICcWhXU47d0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ux4sfavep02xreV1lEoIFbKfvKEhLwfJfl9XpeBzp4b4rPKDEGn97tjUPH8GCDA0HK07yuzkPUgqGdKoyLTpT8zIaZVgIwNt6FkkMRv8c878wsbjaF7R5VLRtGH1B2n/KX7I0bClGrBxXxMFdm9lz2ILdLdCz1oKKFx5Vlo8HDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JPqH7O7v; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JPqH7O7v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263677; x=1821799677;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RRGhS4J+6eUIY2/Hk70xq6rjrhAcuRtoICcWhXU47d0=;
  b=JPqH7O7vO6BA+kQDh30GgHx9U92slsV/9lbLBBOgvYjfQEpuLU0A/720
   riTVzahFj312I6iHrMi6IkySZRgpp6iRTUl+be8OMrslxF8+Ga5ChIm+D
   UkjolWX8iSYIc+edw8Meen4siN48Qz3Rc743StYu7EnkBluZHzd478cvV
   kOviKcPEYB+B5XGYdjQdDE+0h5a/qvUl4RbN6qn3U1/O3y7GrIF3jJgWT
   P2wPgBN0XKfKYNHWBSjevx4ykzl1uEJPNEVCsAkjT/zYgktuMk166M/4p
   aaJTX4HxAahXCZK6XrzOQOHQikmH8zHrqc1Q23kTeXBjJDunwgSWtT2Np
   Q==;
X-CSE-ConnectionGUID: RqD3ti0iQwOA+RiBgg49NQ==
X-CSE-MsgGUID: EOYvAZcFQeCScRZmp4UNGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101696939"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="101696939"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:27:42 -0700
X-CSE-ConnectionGUID: xGI1NRCtT9m5UoelC0Q7Tw==
X-CSE-MsgGUID: 7V3d4cvxSEmrhQ1vvz1euw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="271888695"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:27:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:27:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:27:41 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.23)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:27:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLeuCnPjnpGa7+89oPU8uniRqbO0kaKFXmE6bNexOkQp8ZZe/woUJ2aMwEk/xoH8cJY3Ksgul5f6pgz6S3V93+8IUSjLgZEujpJBCbQCtSeWdvEIaaQgthbxKS8yfTD3PVmoaemEwbR+MVSie4icPqoXkvZvEXTCjhLqRUrg+0vp8MR6lSwfYhGgsPYVzBLJAZdH7GZ4hKh4dOOBgFwMUr7d8b1hnh2ihoXOirfOE0fJaFdW5vFW+42EcVypUgaJVUr/R5WEceaqoMTBaQHnZAk4whq7dhPe3/ipbHBRiKDWJ+2a52JpyUBNU01RKqMOimqxk8wSvFjmVz3Zm9xRgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UaRbzs4CKuP0K5vz/YrfDSPEhDBcU7L/AgHqkVGiqg=;
 b=XUwm9a0AD659lIbt3tF2ibsxg3wnaRYN7linnTWOGVOUBNtpSRgL5zK1vDMnM6NSZGdDNhFZhKHrILmNWqaA2ksbRrYB7AoFZ80MJYYQG421sWs66KWx3g+ya3PcU7BPkKuZlYzgKMskZ3nL2NBzoD8PP3fFTZEwNnguY8knFVPdI6kDBm3FVObCJOcB13rNE/Qpa+9jD7ltH0Q3o9b2ZymqWhnAGoPdZdYgu2vqE2Kw42Gl9xhQsynypLoswUTEa4+1K09QGSUG3EbiNccF/Gj1r44BHGjkGM62NmjaLO0kfJxnlZohyHeE5TPs5NGKAWp7x66trzePb3/V8QrTIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW3PR11MB4569.namprd11.prod.outlook.com (2603:10b6:303:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:27:32 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:27:32 +0000
Message-ID: <26f421b4-670a-4045-bc06-e801df65cfa8@intel.com>
Date: Thu, 24 Sep 2026 08:27:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 07/25] x86/resctrl: Update special case for Intel
 Haswell enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:303:b4::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW3PR11MB4569:EE_
X-MS-Office365-Filtering-Correlation-Id: bb126bed-4ce9-4fe0-1230-08df1a505a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|56012099006|5023799004|11063799006|4143699003|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info: fuB7AxeZ76ueTm/Ma6yNYwoL01Pws289lj6wR6laJ2NVAwUd/SkxDkX4TceGKwAXzQybRAuvBoEFZpX4IminC2h7F8Ta+MyWgLJ9lLMXZNasbKLpboq+bqBsqbfR5lKRGmg0hH/VDqFyA/GXLMkyh0cNZsZmEmgB/qGRMDzJn3Zbm8ILbX88xBeiTUgspmkFHXyhY8UD9a6wtlXoDzMXKVNa43qZ8Jo+5slDHC3tOnk05ZAycgDErfh5tb8OCxCTNp8QmwMcoJFKB7PClIWUF50i3CwyInqvOnVPs0TthddHDb4EWHq47Sc/mwh1rrd9ZqDdfX9FvlRbrGrzmEUKHvnctf+AjggaDoH3yXJ7tEsGHQ/YAq1xEjIK6jPsCZsBrdpuUUfbIKEb+un77qltzKhlF+VEJkr2rd4OWav5mDpXItoZc0QIgpNZcIOZPLU3wkiQ6LhbFQ0BqvPZBSXs1HC1pIS/+CveY4GbCfDuAmaMe3bX+MJn/jZK2aSiDOy6pg1D/e62qk/bPjnj+EL/ObIe9wHduARx4kdTPZbedkomURJxpPl2oY6c/EtrL9hG3GwkiE/Ae6Vup5r3T9bRlQzc1MZ5qAKpLtAli+5SfhHd7DiU8fKBaYxghL7ZbkVyYVtQr0ZTagUXv8BzRZgcwhJu9Jgc5PqGiV7+s3LXvgHJledzWYsaX/i4f2ndpvGFIMQ6TgJQiKLcgALUMlqlJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WW1rYkdwNFIyOGVjNVAwMVJTWlhadG5FVjU3S3VvNzk4WWo5ditxanlabUZ6?=
 =?utf-8?B?ZjQzdHpyS2dkdFJ0NWdrMU9mVTNHU0ZIbldpMzdBWTFWWWNsRzFJT1VGTTdq?=
 =?utf-8?B?bjRtQjBPWE9ZVEtXQmlMT3FjSTRBS3g3UzJmV01NcmFGUU14UVZ1ZUwwdE1h?=
 =?utf-8?B?ZEh3emxzODF2S1YvanBGYXAyQ3JQdittRmtQL2V6M1ByenZtMGhsVjN6V2Yz?=
 =?utf-8?B?WWMwck1GMTd1WmJsaEtWQTRxc2d1dzFKOUR2NkRrOUlhQjgya1lzUEF2RVMy?=
 =?utf-8?B?RWJOZlpsV3liNkk2azFDQWtHOEF5cUw4YXdoTXlsc2FycDNnM0xLT1hIRXF5?=
 =?utf-8?B?UjJlaFU3eU9GZ1F6dUdmdDFUN0pNRkFoeERoamxqNUdkYXh3ejNDT2VYMVBD?=
 =?utf-8?B?cFFBTWJ5YlhlclVTSWZEb0xzMmNad0Q4RGFlK0xqVVFzZ0RBYXB3Ri9TSDhP?=
 =?utf-8?B?UG1rVk9rZFJuK0FJS0RyTlVKMExsTVZkQmdFRTFkN3JEYk9RaFJUa1Q4VWY4?=
 =?utf-8?B?cjl4eHRuWXlmTjBzbllLZnphVjJNWTg0L3Rjd2lyTUkrY1RkTU5lb1F5cCtC?=
 =?utf-8?B?VU13TG9GR2RFM0lzWW5HcHFKd3VsNDRab2VpUGJVL0p6RXdzakFHdGNlbEI2?=
 =?utf-8?B?Rkp1SjVIZ1Z4c29rUS9CaW5uWERCYVdXQm4yeFM3N2tyWlljY2Q2eklackx4?=
 =?utf-8?B?WXhITTVZYmtOdTBCMEUwMGIybFZ5TEZZNE9LQ0hSMXJJblg5c3hvWU1yVGk5?=
 =?utf-8?B?Zllhdnk1Q2d4RGU0aDJCZ05EK3VWWHBHcnRQeWtBem9TdUs0aXptdThVbHlZ?=
 =?utf-8?B?UVVZVU9NcDBZcGxlVmU0NE40R1BMTUNnN2RYWW5nRXVtUVU4YVhidGdSdnl4?=
 =?utf-8?B?NGFjZjNoRmk4bkdZTnFnN0Y1Q3VYMkpSNGh4ODdLU2twbVhxRE1sRHpCUmkz?=
 =?utf-8?B?MzhSZ3NDaGNna0dkOHM1dVJHM3lQaEJSSHQwMTNDbStiNnBTL1ZhSDRxRTF2?=
 =?utf-8?B?ZXBPT0huSHpWYlUzd1FiaEtWVTNSUFMvMlZya20rV29FZjFkQUNsNSttSFFZ?=
 =?utf-8?B?end0cGYvUjRZaWpUSUpZeTRicXA0dzYvdlo1VG41T3dCK0ZjKzBpZGJrZlhQ?=
 =?utf-8?B?eFIzYSt2Q0dmK3RHSFpQaVlUSjc2UnQzVUk0T3l4M2Y0ckhzRW1mdFExdWhs?=
 =?utf-8?B?YWlZdmhGTW80bnM4aDUvNktqQ0ZzTk1JamdZR29BUlRjeHFFdXFTcW9sQ2pL?=
 =?utf-8?B?dHBwNURTeVM5LzI4MnFSdjRHc1J0S3RydlRJbDBXazdIc3NVMWNHUzgzRTBj?=
 =?utf-8?B?eFJTL3NGcyt5a29PK1A4Nmk3cGZ1UU1WM3A5UEVZdkU5TG5Ea2NaQlhtRSta?=
 =?utf-8?B?dXJiR1hvU1FDMXRwL2FMZ0hLVHFQSFB4cXhZTW9EVno2T0h4M1FlTDlGODMz?=
 =?utf-8?B?SnloUDhVZ3A4MjVndCt0TzNndnpKcmJoVG5mblF1MFV6ejVGL2RTM2QzK0hr?=
 =?utf-8?B?WlNNTk94dlI1YmJBeUl3ak5tL3BUSFI2bFZkeHN4cDNuTldROE8wM0FMUG9i?=
 =?utf-8?B?WlA1Yjk3ZGFHeVhqOTZYT1cwK0VkVjNSMm1vT2JmemJjUjdIWGlKTmxaKzdD?=
 =?utf-8?B?WWhQNVNCWWpUdjlnRExxSGNmczBtVTVheEdpUEZOQzJTc1JYRjZEMkxRQUdq?=
 =?utf-8?B?bGtZMG5TL2NXRlV0SW14dUwvbitOejZoZW5ka0cxZWtqWTNicWJIYTF2UnRY?=
 =?utf-8?B?d2FQQU5OQ2Q1RGcwYUlmOFR5QWhETGhCRUlWaDhZMFREekxwMjlkTUxwQ1pR?=
 =?utf-8?B?d0N3MStFck1DSlpuRlFpUTk3eEtqUUtiWW41RjAvbVZYSWFib0ZuYlNmQlVX?=
 =?utf-8?B?SDlpbEpFbXA3Q3d4N1MwRkNRZ0lUM0Y3TDhYUUtORDF4bEtsRXYwdUVCZGxY?=
 =?utf-8?B?VnV2alJ3NUNrSEI5Wm12UkxnQnVmZTZYTCt1OEtrSm5HRENHdVhqb3VFZUc3?=
 =?utf-8?B?L2VXcGJDTktOdk1hOGs3UjNVSmh6UjZqUVZwYUE5N3ZQZGxZeUprQlo0RkZK?=
 =?utf-8?B?MGFaSURqL2c4a2thMlBSSW5PQ2dETG5pOHpNVWo2dzRoWGtueGN6dUdjTHlJ?=
 =?utf-8?B?RjhyN3prNkMwKzdTVTFVM2VWeklvMEQ3eDZLWXhxbmsrOGlXRi92NmtkeGVN?=
 =?utf-8?B?SGJGdDhRNTFlcFRWTXkxT2xnNDExeDUxbmxVVWQySkduNlpndmpMTzg4TTY3?=
 =?utf-8?B?dGlxeHoxQXJuQUI4NG10NlpKZHdCaW9MRmRHODNUWXBTKzBaSGY0T080amU3?=
 =?utf-8?B?bVVtRUM0K1pYS2ZCemdNb2JKc1V3bm9PcnRFYjFHcDd3dmJyQ3VrbzI1OEdB?=
 =?utf-8?Q?bK0LWyTiLNYUgEIA=3D?=
X-Exchange-RoutingPolicyChecked: fX1meZRFb/7FlTSJemsCuzkCc5vCzkl4P18pNWp5VqJYtw5G6qKZOcIEdla0edBZP9Vb6K3YtmGK2qzTEIundtmsZG2Z2F//44KY/5hwucQUw2v1Sg41Z7A3w9v/46kTCxDgv6tu525rtq8Ig/HugtLwcgozydl0keoEBNo3s5qzaQEuDfL7jMPMEpzhZuC/D4ZgEHrLiPWx7wYm1C05TNQs0UaEYhAn+h3H3uZHW3GCJLWdd4yz5nfv7rdCLPqMg9WmLqO+x4Qe5sU23f3kMUeQ0vrgWVqeQ/GXPpYn+cwMMuWJtr8Cl8Evn2+DSXWr4rb3khdOVtrWku467e86QA==
X-MS-Exchange-CrossTenant-Network-Message-Id: bb126bed-4ce9-4fe0-1230-08df1a505a07
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:27:32.1934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ekdoNDUpaCrMUVhTP78sk6UPiSN/0yl5fNRn4q5mNtQ/YK86RFmsF7SqFFRVx8CWLg5grbxxOtjIq399M5pTtA1qW4HejBTgR5HWk5OeeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4569
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> Certain Intel Haswell CPUs have support for resctrl L3 cache allocation
> but do not enumerate the feature. There is a quirk to check for support
> and provide hard-coded parameters. This quirk sets rdt_alloc_capable
> to indicate to get_rdt_alloc_resources() that normal enumeration is
> not needed.
> 
> Drop setting of rdt_alloc_capable in cache_alloc_hsw_probe() in
> preparation for removal of this global variable.

The changelog just states "Drop setting of rdt_alloc_capable" without
any explanation *why* it is ok to do so. Consider something like this draft:

	Certain Intel Haswell CPUs support resctrl L3 cache allocation but do
	not enumerate the feature. A quirk probes for support and provides
	hard-coded parameters. The quirk sets both the global rdt_alloc_capable
	and the resource specific rdt_resource::alloc_capable, only the
	global is used to signal that normal enumeration can be skipped.

	The global rdt_alloc_capable is redundant since rdt_resource::alloc_capable
	already	carries the same information.

	Stop setting rdt_alloc_capable in the quirk and rely on the resource
	specific flag to prepare for removal of this global variable.

	No functional change intended.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
Patch looks good to me.

Reinette
