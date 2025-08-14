Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8018418786A
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 03:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755143892; cv=fail; b=jX3u61yE13H/yOb4cirwtUlP9uGL7Lsg1nSh2S/Gm4RQ2KOLTTpfg47RjfPp1dAwo5itrpIyWyGL3nuzkYsJNoe+JxUH4hQp4iDtsnDsgY/Ya2BWKAEnL28DzW+apHnCvBQmI/JtXbLKMfw8e7xpdxXeg8wcDjjoZm6JYUDr5JQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755143892; c=relaxed/simple;
	bh=99sY1AwxWb7Z07uEkzAZt/KnoFY+GgGWG1XNkpHou/4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aP/Kiimy62vjBbesZNpX7J6ex0J0Kcs2+pmwf0B+e8O7LrFTcymDVA3xMe4po7bkP75RpchElJ4dtH0OD4ln+k7spaeoEnRRrrcoDVrPduJ+ilfJFGapcJkNKZw0AzWC0gmMqxTcNUZKNASA2v+LqLV1CAchaFSfADS5n5UBN70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGOXtaLH; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGOXtaLH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755143891; x=1786679891;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=99sY1AwxWb7Z07uEkzAZt/KnoFY+GgGWG1XNkpHou/4=;
  b=SGOXtaLH6wB6RNQq9GL06oYYOCIDyVmLyGeZD0SJ6xvbgj6dBg+vihX1
   cQtD/d9AGcJZZiM3QcWikJ3jFoA3G8aZ1TqX7z0uj2RV3gO9ev9oLKbA9
   FurU19zbvbSK+AIDA+TVuZxj1DgGI4ZPVPEJzFC6JH7TQnSPJOoE2Z4na
   qJq4+YTSYvXbt+TbsoyHBnQIN4NvuBrI5kLjXQJN7u3Hbk1eCeAvr6eR1
   1j6SO0/bGs2WrLTcu+8qpYr4FNUkZRbQgQ/dxp35lI6z+bh90yJAeqnQf
   Bi2g9CGsQC18q3xFkWO9BQFQEXpyEdUutJCFLaJIMdB2/rJ3re0jW0KmN
   w==;
X-CSE-ConnectionGUID: 6QEKQaeEQFGuy+f6d90zQw==
X-CSE-MsgGUID: 5uNaSgh5SiOJGWqn/brjBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57355745"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57355745"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:58:09 -0700
X-CSE-ConnectionGUID: 2vT5LeyZSmKDDRpxu8buaw==
X-CSE-MsgGUID: t9xasNBuT02Az5PzZNnspQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="165835533"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:58:09 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 20:58:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 20:58:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.84)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 Aug 2025 20:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcvlR3FtOc9UaUGqKljWsdZl5yXvnw5Oym+lxMJP0C/wydPFtXpQ9D9VLqKq7at0az7NUDTr3A12aosIBZigpm1QryanHyBcL/s/l6+h2v0HRTqUnNrQ4zePcAWPGgI/DPTpJvn6nAH4LECrDwAid2KL4l60WgWTbeo0ptyHjwAkhpzM3PXeG+EFa0xR+ibjJS3onBP482aflnMoJ91Rgq8Cra/0X2Z8pfM49KpqxOOpXa3bap6JJyiCOBR/xta4q5bfJ7X1EqhaHBTX77XFgEjeddJhWzZJrRjoFKaSmR9q0UFr6RxxNvJMJvN2CU/2yGa7sOfswi9rZo/2YAETnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMt4VdZvTI9Duc88QjLBqY0vQfYtTFdiKe3FP51sv+w=;
 b=hJuNto0hHrwfSrybGrrniwtFRbwoftrJqLdwSKhC2DhryFWGRk/xJJ0zMlBCcrKrsqikPOBTTSZQPbH1xFnX0WOJESdEzyezfu3ELv2BNXsy5rI2sD5X5l3v25/LhsfHMWqo/VSXzBB+Mh9eU7th8B045CdJ7zpKQTs/P+xWSv6FSVXMNq0aNlW9vB3JTZ/hzRiT8OP0Uc+155e4K6+QG4tlnGv3BnkS6P5ZfizWWhh5Hw9bs9OMfyz+DQ3SWoVPrqfjgeszhBNwaUpPVygZzjUm4lm7FMaMW9tEHgWZABawI/Xg3RFKO+AETu/2eAtIcA/iV6a0z+xhNo4CtSaAMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5198.namprd11.prod.outlook.com (2603:10b6:a03:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 03:58:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 03:58:07 +0000
Message-ID: <12a40a52-1e9d-4afd-a143-f337b6651f14@intel.com>
Date: Wed, 13 Aug 2025 20:58:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/32] x86/resctrl: Move L3 initialization into new
 helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:303:8d::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c284fb-65ab-4067-782f-08dddae6c6fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y2ZLR0xkWk1sSUwwZzgxQUFZL1lHQ05Qbjg4Rmh2TGg2bEt1d3diNXA5QVFU?=
 =?utf-8?B?MFRaSWpqSW04N1RsQXhNYVlleFZveTF3Vk1kWWNDVmVRYll6a2p6cVRnSnJ6?=
 =?utf-8?B?SVpUVTFZWUcrV1R1R1NGSnNzK01xcmNMMGRVQkE1d2NqcXM1MWU2V1QvQ1N4?=
 =?utf-8?B?Q3BMR2xjK2Nmc1hrakRxVlFZdnlvTkpvZ1AxamlsTGdnT0wxL1c1WGtQSUJ2?=
 =?utf-8?B?NWd5R1hqVWFNUGM0Y29QcWlzRkNFUG05UXN6bTdNbkQ3ZUh0UHNvZ2pna2Fw?=
 =?utf-8?B?UnhQck1aMkRuWlh0TEtWRDVLVHBibWN6U3p2QkprYWpmaGt0emVIYk5FNy96?=
 =?utf-8?B?eVlxZkt4MC9BRU03Mlp1S0NybDRpcC9udnp0eTBwQzg2SEdObmNsVjlnTXhV?=
 =?utf-8?B?QzNWYkVRbXZmL0FCWk04MWxOK3hVZEZyN1cvQXhhNXA2U2VMWG9pN3JZa2or?=
 =?utf-8?B?RWpkK2RPTGZ1ZTdYSHl0VnB5SEhZZkZrWkxzWWFoTzZCVVRtc2x4T2lZeUxs?=
 =?utf-8?B?Y0xqY3JHYzhhVTdMMWpCcktDZ0ROWUpqZmt6WmNpdUNpTVpWWFZvR2RUSTkz?=
 =?utf-8?B?aWFHbDFWTEdyRlc4dFpPZjB1OFNHWk1lWmNCOHRyWTN5ZUtJWWdBckU0b1RW?=
 =?utf-8?B?cVNLd0g1b3NnWVV1Ny9penJScmQ5YU83MzVrMHlmTUJtVlYzSStUN3FFMzNG?=
 =?utf-8?B?Z25FWTE3d3hZR3YwRTBzUnRmenpmMkdCRXdFK25ZSG5PdUx5enVNbDZ3elE3?=
 =?utf-8?B?T1JrZGRKZDV0Rk5VR3pieC9DQXZrejh5bWs4Z2lPSmNzVCtOUFg4UzNtUW8y?=
 =?utf-8?B?TjNObG1lbFI0UDNYNmZLbll2bGdEM1FVN2lSSURFNmRiRTZCdS9LVjdpN3cy?=
 =?utf-8?B?ampINFd2LzR3L29ua0c2bGFzWGVHWnpkTnJhNW5seUgzdW9OUkI0WCtVT1dM?=
 =?utf-8?B?aDF0ajBrUXhzc29UVVo1aWpsYW82Sk1QbDJOL2l5RWh3cmt1YVB0eFVzQytm?=
 =?utf-8?B?THBzZ0IxYjRJMjdQUlY4aGlrUWgzekZmd3J0QVJGbTJ0YjhaMm5zdmNTUkRP?=
 =?utf-8?B?TlhMVlljNGhkNTgyYVRmTkNpK1diMUs4dHM4ZUxjcXB3ZE5CSWF6TkE0M2Y4?=
 =?utf-8?B?emNQRHEwdzBaOWFsbkdyOTBGZld1a0pGVSs5cE1wTUIrTTkySzNZbGZvUUZL?=
 =?utf-8?B?b1VEV3JTWmJFQktJMFFmUEwwNW1EdG5KYmJGZDlkbnA5SWNNSm5WOThUdVJa?=
 =?utf-8?B?c1UzVENCZS9mblIvMkdYL3p2QUNQTGsybEVhOTBmWnluTDJPNEcrWUhVb2pm?=
 =?utf-8?B?dm16MmZQS2VqVTg1UkJpRzJ1WCtudkZjM0pBWTNlQUQ5dTVBazhaWktHUTlG?=
 =?utf-8?B?eUFjV2xQeWdDaTF4UUhzQVhpK0FZUnJaTlpaTlA3cVJWUlpxUE9jVVE3a0d0?=
 =?utf-8?B?L3o0VjB4QWxQUjh0a09QWDZxRWRkRU11Y1NwRGZvQUF1am1rZDdrRVJoOWIv?=
 =?utf-8?B?dHhmVlhER1cxVk1kY2pXSXMvbVBPby83aW1uend2emdYQUk2NGY5TFdUdExX?=
 =?utf-8?B?MmlBTTBaaUl0NWZoTlJLTHpYNzNma1RRa2o1emFCQWUwT0VTcnZ2YldDM3l6?=
 =?utf-8?B?djJ3K0JqbnIzeU1KVkdWQTJnaVJHSlRPRWNBL0tYcktia1JreENWOHUyaHFw?=
 =?utf-8?B?M250a1gwY0ExZkJwQjNQc3loVzVieStJZjRlc2txVW5BQWl5UFRmZ25JUC9B?=
 =?utf-8?B?djNXa3JnTVJjK1JpRUtmWExmWHNKZ1BIOGRtYW9xdzZqZ1RzL3ZDdkMwWnJk?=
 =?utf-8?B?K1FIZnpyYytFaFB6YjhXbWNzdVp2WXJLaUhEb0d6UDgxNC83U3NoVGQxRjJ0?=
 =?utf-8?B?bks5ZzUwcVdraTBQSkNzelFreTc2aHJ4Y285SHpaQ0hpV2hibHErTmVCY0d3?=
 =?utf-8?B?a3VqbnorZkVXNUV1ZE8yRUxvTUkzekRvS29PcmM4cXdxYWtvVVFTWkhiZkhV?=
 =?utf-8?B?RXBFdUJIZUhRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE54WTVDbTJEUWJlZVNqNHplejVWRHI3OHVpeE40VTVYUDY0ZmxaSXhSS2xy?=
 =?utf-8?B?bER1c1ZGQit2SXdJb3ErMDhuRWVic2JvdENnQ2RFZEI1cGQ2a28wdCtZSExH?=
 =?utf-8?B?R3BrYnVZMk5TWFY2RWZKVXdPMXZycjBFeHd3RjFuS29TZDhISTJzaVJDblF2?=
 =?utf-8?B?YnVVZnZwVEg3cWtud1MzSzliT2RBbTVPam9XK004amZjUmZpcTM4WGF6RkJz?=
 =?utf-8?B?UmpOU0tuV01UNEdmNTJEWHg0Y3B1RHhaKzdublVXeHIwbDUyeWR1a2t0clFn?=
 =?utf-8?B?emNGRHYrWjNFcTNkcTNsUzRnaFJvbVFTTDBEMGI3Mmkzcms5ZnREYjdhb3Ar?=
 =?utf-8?B?MG9pZ0YyUHNkNjExdUJvbk4yeFlqUUtNWm0xMjNXMnJ1ZThnejNvYSszWVQ1?=
 =?utf-8?B?eDlMb1dwVTJKS0Y4VE5Gc3V5SGhxcjVGbllOM29jWElibDFucDkrTTBjcHRL?=
 =?utf-8?B?b3dNU0k3OUZEZFllMmNLcFR6WDZyRzhtNEo1WVRRbGZ2TDFySXJEM0FUS2dD?=
 =?utf-8?B?QmJWUmZvWjFhSUVmYm8rclRtV0h3STNPZ3JRUWdLWFhwektSMW42L0pMWXY0?=
 =?utf-8?B?c3llL24zUC9nVDdWcXY2ZFJDaFBINkhJdEdSSTBSY3JUOGo3MW5VRW80SHg0?=
 =?utf-8?B?WG1JUWZtSVJUeFVEYnZhWUV1ZnFnTXRnR01TRW1wRkpMdXBPZUNXdE5pRFdF?=
 =?utf-8?B?bVFuY2RMMllacFRNekJGa0VLL3FaNm5PajMzMU9ZdG04ZndYeWhBZkUwTjFK?=
 =?utf-8?B?TzhUazNvankybDBhTXRCaWFFRWF6dkVOeTQveWhKSEt3ZGhmcVNwbTIvNERV?=
 =?utf-8?B?cllGb1hRMG0xcS94ZExTd0x6ckFnS3k5ZEY0RXk0QzZrVkgzZ1F3amljSTJT?=
 =?utf-8?B?SlM3ZkZKYkxoN0RJYWlhK0QvSVRLUm1CbzdxalBmajZId3FjYmlPWGNaajJi?=
 =?utf-8?B?a05sTXluZStjQVl0S05mQUFoN2t4citCOGZxMkNJMUhsVVB0UDFDaDd1QXFO?=
 =?utf-8?B?NG1DNVBuUmpUZ3JtOWF3VmJFdFdvKzd2b0Rhem5ueWZocFZpMng0eVFPT2VW?=
 =?utf-8?B?WFV2Q0NzZVVGR3lDQ2hzL2M0UFVnN1JGcDViMHpHS0FWSFhXaVRFaXd4NHR4?=
 =?utf-8?B?akt2Y25BMk9wUVlnZmJPYytjQ2pDSU5QSWNjTlMyQkFyL3hUWGRqcExKQ3da?=
 =?utf-8?B?cEduamVwVHhLbTdvV3dOMkEvc2FHeEU2VVhuMnhnK3lYbnNzWGt0TE9zMkx3?=
 =?utf-8?B?UjdjN2ZhYkFaM2RCSlFRNWN6YURuNkczdG1lWnNNYjVtN25nT2lkZW9aRWpa?=
 =?utf-8?B?aHRsUjFNTmxyR0RjSjJhdGpka3EzVjViNVFaekdLdlFJQm1rd3lEZlZwLzRm?=
 =?utf-8?B?UTM5N0o5a3lqcC9hV0JhM1BWRkQvQjF5M1hEWERwQTMrSThYencrR0Z3RzRT?=
 =?utf-8?B?WUFhRmNhRUpjOU9DTVZmRGVDR2E3WnlRL1lHbTVUTkxabUJIKzZxQzlyWFZm?=
 =?utf-8?B?d3BMSXNVRXNLeTlqYzRLOFpVVjQxTW9KTFZUWE9id2ZlVUlSSnJjamZMQkxI?=
 =?utf-8?B?WkYxdFJUQ1FjOFltbWxQU3d4R3FBTEVoWTF2S1VJYlpZK2NxRk9tL0NpNzFN?=
 =?utf-8?B?RnRsOXp0cDVpWDhBM3N2TUttbVlmdzdxN0tCWE8vVVFwQ3BQQ1A5ellUMmhn?=
 =?utf-8?B?NWxJd0ozQmtEbjcxbHN3dnBQVjdGSjY2WTZQVE1URjFKMVlrSWJuUHhhRVB1?=
 =?utf-8?B?eTBqOENHbnVjU04vS0pyNk0vMGFHSmZmNmUrRm1rOTJkU0hQa2xVMlJGSnhC?=
 =?utf-8?B?M3grL2lpRTJPTFA3YnBESUNvQlZVTDVRTk9lSTRrSWZ6T1UyVFUzcFdWcG5s?=
 =?utf-8?B?a0l5bG0vOTJDbjNzc2czYjNVNWIvdmQvM0l1NUdnRnBaNHhCbWl1bUFTMGJK?=
 =?utf-8?B?THNFcG0yenpXVnR1WWdZdU9ZdTF3OXJpVXNkaUMyb3NqQVhFb3NmNTdPajhs?=
 =?utf-8?B?cFBJNCtPajFjcktvTm5kbU1QWnZMcXlUbGJRcHZKaVJLcFZaWFVsSURWcjZC?=
 =?utf-8?B?WTlQY1Y4ZEJhM3JDUEJYZkZYL1hxVlFVcS9ObkVBaHJlcnhncFJXM1hEN1Va?=
 =?utf-8?B?SjRxN3hnZG54UldwWXFpQ2lRb091QmNtVVo3TTFyWkkrOXAzbytoVlIxNk40?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c284fb-65ab-4067-782f-08dddae6c6fd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 03:58:07.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uArYJFjh5IWwgqbG6eKM3vi5NnWRwldw+fpKYRgLRz1jndZKkhVDpaeVnx2u2Dto+A3J/Go0hDKBE85eK6OQGbFvnIDaeDvF6ZWAdjSJ05s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5198
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> +static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +{
> +	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> +	struct list_head *add_pos = NULL;
> +	struct rdt_domain_hdr *hdr;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	if (id < 0) {
> +		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> +			     cpu, r->mon_scope, r->name);
> +		return;
> +	}
> +
> +	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> +	if (hdr) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return;
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
> +
> +		return;
> +	}
> +
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L3:
> +		l3_mon_domain_setup(cpu, id, r, add_pos);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);

As mentioned in v7 feedback [1] this change is inconsistent with similar change
to partner function domain_remove_cpu_mon(). Since you did not respond I expected the
code to be consistent in this version. Specifically, this can be:
		pr_warn_once("Unknown resource rid=%d\n", r->rid);
Reinette

[1] https://lore.kernel.org/lkml/6ac15beb-7306-4507-b88b-b6f6cca66def@intel.com/
