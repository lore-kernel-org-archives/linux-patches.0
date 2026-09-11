Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC66E3B4EBD
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 22:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789167127; cv=fail; b=Xild1fIENocGgjmE9J6uY4MBszt8INXvj3Gmi/5si9ZLB+dgYd+qm8iF2m/GCfcYGuA1Q+AAOY8Jip6Zf0zBevaGgukCYzf/1GdZcDNtwPNh1opAoxg/Pfz071spxuBGxdY9F4OkfO79GNi6kdp/CvwaC5oOpolTHigNCfcQvuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789167127; c=relaxed/simple;
	bh=9tuazCQBhRBao3tmPcVj85msIxDHcWh3DokgJ8c0HHA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EckUF10GDSP7dCXLO7DT8NYHVfgdyg0VaQS95A6cBXj73O/8SLFRTVxeWKVEb4PMQeXKj5NkYSlLV48JgEnepRjlyxc5Gku/6BbBTre3RRmRWJAY15HTWNIccNK3VLWprVAAzN/J15yWdxENqOzvnFNRmcj1E4zTIjnDQN7JwSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BiKm1jez; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BiKm1jez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789167126; x=1820703126;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9tuazCQBhRBao3tmPcVj85msIxDHcWh3DokgJ8c0HHA=;
  b=BiKm1jezdkjKJjTCMQSbqWnyUdV8JmVayzLHeevAHtEoQ4gMfCtuIYxb
   EAUYXeIcT/X4UVQ+KrdW8bvOSu4XlAVY/VZ/KUaLms+7hnt/g88sTNLek
   DithNXXFqUNi1cx8CXfCS5e9OCD5Yt+nkWK6LzdvaTNahIEaPv8JgkZcu
   AvAocjg8CBsN5aM5V1PCJhsdGG9NzzsyYvb0RgHwzsrD9CpetauAMUqad
   3jmdvKHzYoHv/J5N2WID64mfqZR+5n4S6z0az5iLn5VDr1Av5jHdQDzkY
   ul+aL9Trn87aFA0riviIiZ8sLyKpaHCeiqBQEEjjd5XLCh6MvxSl0FMwc
   g==;
X-CSE-ConnectionGUID: yu4XM05rQ9OdLvGrD56vKA==
X-CSE-MsgGUID: 5e61xGlIQ9mUSAOJ028WuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="101154561"
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="101154561"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 15:52:05 -0700
X-CSE-ConnectionGUID: iIHd5QLqS8CBR4CpK20V6A==
X-CSE-MsgGUID: VazZnjFkTFGi9bTY9etN4w==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 15:52:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 15:52:04 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 11 Sep 2026 15:52:04 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.8) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 15:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0pPCA/7wAWSaG1lMnP7SQZQGIX90bdqOK54hcn6y0Jvdwd0LZ7DTrHIWd/NaQ02Swh9gBuaeCQis1mpqBQAx7IBlvShh9lDDatqUbuD2smXP49sX0P707RV7yYPo791DcMAkzMaFrUHp+r2XwuBn5Vvx/p+Gw90pA6xZ9TUgAiV4MHN1C6pRsgMVhOy6iSX7Z2w8PRPmiZytMYyVnhVShki7nZcahzXfmX3LZAg+UlI70JEUmVuuKsBzvo2s04qrouPMdvZnY8xpKHei8SH9vvnZ7mUtZV41G7kyHdfGBJThxZbsEYvPzoC3eCV+gLSrykjNzBrxnJZpYgGG8/AHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tuazCQBhRBao3tmPcVj85msIxDHcWh3DokgJ8c0HHA=;
 b=NiGncfU+VM8vYXEpa9rT+FhzOSFh3OO8HmCT+BtideTkgNPTZGTJH0x11bzycwvja+P/8z+qyS2583LSAU/RnUyFg42faJvFhSQjsJqRp3s/cEc06Lcy8HJezVbMtv3r4v0wrBeEy4k1b29HjsokMRwFYwygl/9MTr+M/+8FBMMcLZW/p/BNOpyo/X9MjNP3dbN29YT+Dx++UcfjjcdgkV8vrqisCm1sTnEO511Pwfw7fQnZYvKNth2nUaDVrjoEhF0S+D4mPSV4pSx0GC+3GvVsUL+rkgjSc/ljZq3wa8XNM0KHc8z4h4NAJv4OBxbz4EaNatRiyJkDdcWUBtkdhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 22:51:56 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 22:51:56 +0000
Message-ID: <1a3eef17-8086-47e6-ad8a-8a24b64b9cef@intel.com>
Date: Fri, 11 Sep 2026 15:51:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/23] x86/resctrl: Give better names to X86_FEATURE
 flags for monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-2-tony.luck@intel.com>
 <2a814a14-2717-4363-838a-6585557baf1a@intel.com>
 <aqNGFA6JtddxEn54@agluck-desk3>
 <6cd4a7d4-6f93-4970-82de-be483fe45267@intel.com>
 <aqRGre8eEhxycLel@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aqRGre8eEhxycLel@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:303:8f::35) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH0PR11MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: deec2926-fe80-4e6e-0e20-08df10574796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|22082099003|10067099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: cn3+G+kRfYHSn7fRmPfa+6JNcQ2ZJvyl7iLyINkW5L/FACKbSExxyi0C0cFEIlSvR91rLl1pw/Y+mDtS75jmRu3kgMUR9hpCOnU3CwAQO7WpEOFRxnJEV/J+k0HIbh6j7oO5rfV9KBH+OeF3Ioik8tSjN8AWkwFbY1ulyii7Kh5bL6WkWJygHYWV/d6xZbeHcHbKGRYYc7m1j4BhrYkmEjWoPA/cgbbEHn0601iPZhsyK00MT0uIXsLahXy4JQQtfH5BT3986feSCXjEgsdg/XMA2Hrs1xrQEiT1wXE4yfepvDIdjr5v0L7M9V81+thzKvJQeqZ2Mvvz79Kjsjta9sIK6tYzOaSzfbc6QYccXguo3z12FBd1nPuxxeYXazZaObc9OrjpJac0tE6nnQ6eSfa83We6nmPfk0ka0cCzHy4yrAwVZ9V6e/PxbQq1KOfcMREr0yk0Q+7pUrjWPRrOeXs6fjJB5y/1hQy8G5WzkmirIxpeqVblKnMztYP98+ndcc7RHzo0xbLh26qK2DwrS5u02lbtRuJP37ri+9GBIdBxseF/gSQtiQBUVNAOTgjhg4f70baTyDI/VBSN7r2TJRqjZBfC2eCSkHXL5fpOfmwBBmywicsj3eZDhEp+GWp9zy0Nk7qeyhWJpxwlRzGv0WbB/+Fiu0XNYFWEIl2I7QE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW11eFBUczQ0a2phOGZkTy9GLzEwZ0grN1RZeGJzZitRL0dmc1pyYlFYTlA4?=
 =?utf-8?B?ZVNlbUNrN3FLZkI0RWdVcTVBUmZnNU1SVUJJQzZRdGk2aHEzWGcxM3dzSXJ6?=
 =?utf-8?B?aGFvMTZiZUpMT2gzZVV5TGh5U3BIVFh2ZXZUczdFR3lzSXRsK1VSZFBqbmxz?=
 =?utf-8?B?SVVCVXN0VDh5bytwcE5BaGFvZU53WHVSKzNqUlZPaW9kRWFHVHVpWGx0Uldl?=
 =?utf-8?B?R3VranhjTVVMNUNVSnNQUXFBdTJNUXZSTjVtMll2VXphTnFDelk1b2MzNlFC?=
 =?utf-8?B?K2lVMWs5czNkZGRXT3NaT1BRWUxwY2FCckVHUk96aEQzbDdweThUTndQY09K?=
 =?utf-8?B?aUZnQ1Iwb0dEODhCbzcwckdLT0tyV0NvdG1kWUo1V01UWUtqUTkvRU9TMk1M?=
 =?utf-8?B?QU9CcVJFYk9GYUtlbWVWNmM4UmtNeGRaampHZGZUdGhadDF0cFpOY2pOQU1h?=
 =?utf-8?B?TVgrTmUvcThGb1R1bzJvcVdLNW5ad0tlQnBTZEk3WkpBRThmSnVFV0pnQUZ0?=
 =?utf-8?B?OUoxeStzbXE1bVBrT3JtYlQ4WFgvbFBEZWtOSzlORGxDb2ticEYyREZpd3dp?=
 =?utf-8?B?SVZubHVKUnJFaXVmVlhIRUlqeEdrNzFGeDJXbFAvMmRIK1ltMFJZM21RYng3?=
 =?utf-8?B?bXV5dTM4WFA1VUJSRTl1d0JWMk5MTzdJT0I4NnFZRWd4YlVOaXdVbTMyd1kr?=
 =?utf-8?B?L2h2YUVEUjZtMW9xQ3RyOWZ3bFl4TjdHNGRDekJkNnBjSXlnN3Y0SnVUaktG?=
 =?utf-8?B?WS9CdGRieWZhYnpHR3R2L0liYlBzWk5rTGU5c0tKQW9tSm9TbngvN0dHL1hm?=
 =?utf-8?B?djFrT00wVkdNcVZBUS9JMkhPRXZrYXJQczZSN2R2Ly9RTzcvMTJZV0l6cUFi?=
 =?utf-8?B?UlNkM1UwZzZIaFRXSktWd2Y1S1ZQT0Y1ak5rNE00N01VS21nKzlGS1VZdlkx?=
 =?utf-8?B?UER1OURvUk1EMXdVT3o4MDZDWnJCUklIWEthUGZXNFpyUzVhV1ZRdmNmSUdy?=
 =?utf-8?B?R0t4dXVHcWtiaFpjSEFaN2dqWk43YmxxSHhpL1FYM2dZVytIdjd5Q2d1Z25U?=
 =?utf-8?B?RE9OblZ1VHIySkF5SXowMjgxTXZBRHVYdEhsMHpwZEE2MU8wbnVwZkVaNklX?=
 =?utf-8?B?c2RTZWE2S0p6RVp0TmI3ZjJDRkhFbW9xSDkxN0JYMDU3ZXA1RFp1Q3N2bU1L?=
 =?utf-8?B?V2xuekNLTkhzQ1FubzVJNXNFSmZURjgwZThCdkNrcjg2NU5kbGZOaTFkeDNp?=
 =?utf-8?B?YjZvVVZleCtsYmZHTkFVaEdENmIwaXNkM3N6Tll2ZldZTU9jNkpXaEFTTHZy?=
 =?utf-8?B?dUphKzI0eVZNZFUyMmpTcGtwNU9nTDZtSm91cFh0YkpFclB2Y1NaYWU1Tk9j?=
 =?utf-8?B?U3REUTBRamo1M3ZHSjQvL0FtWlBpY1VjNlpXWjA2S0h3K1ZyTWlDOWVMMkdY?=
 =?utf-8?B?TzI5UTFqOW9zOVRWcStoVTRKWmNZTmxMV3JjNTk2UlN0NFZ3MVF0SU1XTDZ2?=
 =?utf-8?B?aVlRT0FNR1hKMVQrWCtGaUl6MVU2SUtUaGdKSzZ0bWlnK1E3TFFjZk1BTGZh?=
 =?utf-8?B?U1VtN3o0d1NhS0JidDJqaHFRODNjQjdjMDJlU3JCVEJQdnFDR0ZDeTB3VGkr?=
 =?utf-8?B?aFN2WTJZemRCVW5MTmd1OVdQRlMzOXlwZnFQaTZtUnZWUGkyeFpKSGNsMkdV?=
 =?utf-8?B?ODRxdnZBVTdWOFJrZXQ1Umd0VG8zU1VWWHNzVXhRTE16Z2s2RVhNRzVVSURB?=
 =?utf-8?B?a2lYVGV0dTFQWEhYWVFjeThoeERNaGVFYmxEQVhXSTI2STM3Mk9DK3c4alRw?=
 =?utf-8?B?dzlYZXRMalF0QUFFN2E0ZXVpZHZZaEZ4UWxVR2tDd3VDb1Qxd3pHNGsxSHlF?=
 =?utf-8?B?MHdmV0NDN2hKR1pZZElXazZYWmpmYzV3NTZJNURmZTVtNW9jU1dUa0dNa0dD?=
 =?utf-8?B?QWRwblJNQnpHNXE0dDhXSTVIUWx3M1lPYWZLUzJOdEdPekpwbDJNMWFURlR3?=
 =?utf-8?B?QXRGZm9qQmhkWjhHQkpsak1NdWI0blVkVnhoQVVkekw2Z1RoMTMwZzdhSVVP?=
 =?utf-8?B?NjhvZ05QK01OUFB3S21aM1hrTUlLTGdPcFlDcXAyZ0RvbUxwWDZheVVuRDhi?=
 =?utf-8?B?REN5S3c1VkdPSFo4aFlMZDlxbGQxQXNYQVgzSnBQd0FVTEViSlAvWHRXbUxv?=
 =?utf-8?B?YTNOYkQ1RW9NRWdxYTJnNWhFRFlUV1RsZEc2dXpDM1dpZm44Yzk5K2lOWVd0?=
 =?utf-8?B?YnRPMnVSS2xmTkYyRGh3MEsxcEtSbXpaTGpwS0EvVjExK0xYVVNscStESGRh?=
 =?utf-8?B?N3A4U0o3SDAxV1R1OVBZOFd6MUtXcGc4ZkN3YzJxTGRpVDQrR21lUXJyWEI3?=
 =?utf-8?Q?ywsKN48alcZf7i3Q=3D?=
X-Exchange-RoutingPolicyChecked: vZZjZEmfvRiDo15HPPb21sHokWRprn/vNnAKu5xNixnunSiPeouITyeX3AfXSKnTeZQunFbDWCKKysQ87Ck8qHNMAqfSe5EWRIOfWIshcKTeeYEESz1Bq2U2OWCiuJtJ3yzdHs/wIE9iwGSOhvXC7DTSlKEEUePYUQ7IHnHuo0vnXczYarjN71oviBjnPffXnWhSTnsZRI3xa6yioZu2idCI6HGh14EdCF9aC4pQxVSHCaVyzKFmW3BZ8Bxjx6iaiZPQzPaeCUvuMHpHUjTg3BdDTECHkStZK5a67/BGTOMIl3PFb/1UITtu0oyKCCJ0tdn5FsW0/PSMx6aMkfi9TA==
X-MS-Exchange-CrossTenant-Network-Message-Id: deec2926-fe80-4e6e-0e20-08df10574796
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 22:51:56.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlyGccGvaer5pJoGNSdbf1c2WuIPS5lH0te8IeaIF5XVP3QE9sAzrfOZli7It94/msFFbhEYDyJAA8YC/YyeNVdhgHtGJtK4b9v7YRphcyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
X-OriginatorOrg: intel.com

Hi Tony,

On 9/11/26 11:21 AM, Luck, Tony wrote:
> I'll drop the #define name changes.
Renaming X86_FEATURE_CQM seems a worthy change but certainly is not a dependency
of this series.

Reinette
