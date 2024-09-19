Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C57D22612;
	Thu, 19 Sep 2024 21:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726780541; cv=fail; b=XcuMCKFAbkrcUVcO/FnqssTdNAk/lCicq+WBCtAaGcRU5wPrHxnN3Es2RLKx05GlOIez90qFv9FKBL/qCGEZR/syhmY2nmNduM6tdj67IqZv4BEK7ftg3wQ/xpCsFmbdvg1w7TpMyKSLhv9dNTBoBvvNkZexVtb1LN5wQOJX6g8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726780541; c=relaxed/simple;
	bh=xoWv/D6N+dsgWIawqQYs8MEDvypUTydzX9IyqHrJ0+k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d4NVqGlwKi7IaiLhLdC2OThvJQYawDo1Z2jWbWbXDaFlXnIDm+sqDoFUp4bThZJhEa1FyCVcO+Ryt3pcUA4+mvY7F5Fi7vbf+iJtHCb0LLdnLw+IJErQqndriG2HIuBroFJZj61NRzx92n5u2pDi84obm02Ev2kRnQEuIIICXeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZNJCoY7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZNJCoY7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726780540; x=1758316540;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xoWv/D6N+dsgWIawqQYs8MEDvypUTydzX9IyqHrJ0+k=;
  b=WZNJCoY7F1cKq75ybcoiipjMlZ/3yeWJO+Dd+2DqbJ0zWk1sKYHne42/
   71Hcm8+CQN6SaaG4w2gR39512E2EfqfiAfW+5HrCxR5UD8L7h+L9JduV0
   V7H+FTsF2s08nFQl5IbpawHbkMNHevXeSSxF+7lmmY132psdQacD3wLDe
   daQPOwiXpGb5LdvuK2oolzSe1+p7D3K0/zWVjw+IYQcLSfvuzBhHaG1+L
   VTLtCl4rd8fnzEPJm78sWvC/QMH8H1xZmMpYFekeax5CIYzY3WWxmisxT
   8rL/SNUSYInDKhqM48MA0TGukFSh1nlfSvjcoOTwoDjhuapfRpn0XnRl1
   g==;
X-CSE-ConnectionGUID: GOv9tw1+SzGZ6TVc8Vr/Bg==
X-CSE-MsgGUID: 5ovjWw/pTWuWd0X2e0L8hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11200"; a="37149003"
X-IronPort-AV: E=Sophos;i="6.10,242,1719903600"; 
   d="scan'208";a="37149003"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2024 14:15:39 -0700
X-CSE-ConnectionGUID: Dk8mvMH/QvSsQ71wpprBGw==
X-CSE-MsgGUID: nAdTO3DuSJWU1TzVhh+CIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,242,1719903600"; 
   d="scan'208";a="69657812"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Sep 2024 14:15:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 19 Sep 2024 14:15:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 19 Sep 2024 14:15:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 19 Sep 2024 14:15:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Sep 2024 14:15:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KCS+PFhzhWDJabpeifzv1RII/Kt0drw+P2BANy7e2glVb66H/8U+v/Ao2WNWfdCkBnmUu5KJo5ej2phWVHwbBTsahGVghmopux4Ywq0tZMrqcvsv1TtGMyyEr8kgYUo6szAc4nCckAEQBTY+D6CsziRN1DXfv/tWCuWQURBBkoZbvjaJ79XlIOwtNqClxpQSs4znQucYE3Okp46kGm4MnrJKlLPJ9vUVmhC8t9MvW+HehCTAWtALWOhAQvUgZY/pq4qGnnRFyBmP1jSkv+aiy6Pxckqy31NOXcfrtDPrT7UEALZjft1V7ceRdBEscyMeTjMj0JVg2HJ+kd3kpodW6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0lEdwBLPnjFNOd2BehGKACGhJTLDtRR7v9TrfIyyGs=;
 b=YNHfX3pFa5otXknZ0IHn+z3fKAMQcI6tLBbPlpaYpM3ygu1lxhP9LobE6yngQi0SyoLhItFpMkZ4ZR0lHtl3jB2kSK3xC8/ccB8Ty8TI3tz5zBe9G+U4pNkPaZrdrOJTYzm9JhWx5KOoB9T3eVNcQN8bdoESnQOeaPET1m5ttZPgVmND171Vd9sforfXjmzSiOuv/HwidUPVlKTsKu38FW+aqqrtW8yvw5yO4lgAVeOEw5/m0EGmmf2BlWkREcwd3fiE/v2xFi/jdHmBPC4nJPY54H9NM4cSAF40TJ2jkn5BHo15N/xXyWzqil+DOfV/TDI60vw7jLe1hBVVZaA2ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB8252.namprd11.prod.outlook.com (2603:10b6:510:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.21; Thu, 19 Sep
 2024 21:15:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7982.012; Thu, 19 Sep 2024
 21:15:36 +0000
Message-ID: <2deb3b0c-121c-4dfb-9179-e919582f5bb4@intel.com>
Date: Thu, 19 Sep 2024 14:15:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] x86/resctrl: Annotate get_mem_config() functions as
 __init
To: Nathan Chancellor <nathan@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
	<x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20240917-x86-restctrl-get_mem_config_intel-init-v3-1-10d521256284@kernel.org>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240917-x86-restctrl-get_mem_config_intel-init-v3-1-10d521256284@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0339.namprd04.prod.outlook.com
 (2603:10b6:303:8a::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB8252:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c0e854-24a6-4ad2-c62b-08dcd8f03461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MG12aWlwR1BEcUh6aUQrTCsxYzhYUDBqditaMjlJTnNobnMzTzh2YmhFMDFq?=
 =?utf-8?B?YUZmRzFaVERVN1FJc1daVGtBcjJiZGNzK3AvcUdFSHJwdUJ3RzkxRWlGbDVC?=
 =?utf-8?B?UlFCYys2V0ZFdVRWMlA4bWxTL2NORTBMa3h0RklwNmhwelJIbXZ6ME9JWHp1?=
 =?utf-8?B?djFHdEUvYzBTRWlFd0VYNDlEMFB4eVFuTlIyOGNSWHZ4YWdzZ0hVZnMzb1ZQ?=
 =?utf-8?B?Y3NzR2g0U1ZUMDVvQy9LNjVVckRoei94cytKWC82K2xIL1o0eXFpa283MVBl?=
 =?utf-8?B?ZTFmS3c1MmZxNnFsaHhNbm9kbm0vQnpaYXRqZ055OWwyT296N0Nsc1AzSmpx?=
 =?utf-8?B?cjBpZmpZYVBZeFlmdk9ZWitVTGhTeDhuQS94VDdSQTdFZGRqcTNobjN6RzZ3?=
 =?utf-8?B?TkJkTDc0dkJlYzIvMlU4ZXlIQ2t2SUpxVlRDZDJzQ290VFluU1dwcXFJSVlF?=
 =?utf-8?B?ZjhRY2xWTjVETkdabWpVc1cveGdERHAvWnROeDIwdzhhMGFTakI4TlVDeVlE?=
 =?utf-8?B?aXdqRTJUM0M2aThYRk5BSCtHSU9OUmU4dXRobUFzUHZ4eHp3Skx2Z0VQODA5?=
 =?utf-8?B?UThhMEJOb1kwaE1GQ1hqK2tzNnZ6ZEtEcHB3YXJpZzZHaHVPcUlFT1MxZkth?=
 =?utf-8?B?NHI5TjJZTExJckI4WmNQNXlrRzBzWWQxZG9SR3poTTV1S1F0TmhHb1o1a3E3?=
 =?utf-8?B?SmMyNE5Ta3dBYUV4M25GaHlZb3U2c1FIVDdZeGZ1d3BUTlpMVE9FVEZSQk9J?=
 =?utf-8?B?OVlWZEFxTGJhb1cvd1RTMDIvRXptcENDekdJODR0bm4vbWZkcjlZYjhHVGJz?=
 =?utf-8?B?QTl1QlhDaTZ6Vlp3MlM2RU1xMUVJd3FBTjQ3cm9LR1gzVE1YbThibWFId2dR?=
 =?utf-8?B?Y2ZhTVBmK253QjNoblVmWU5YOEZUV0tIbE0rR25tZGYzVVNoQmgzclJOclBR?=
 =?utf-8?B?RnBtSThySGZXdlZhUnprSzlpRHJWVFpxcUNpeHFUS2MvTTAwY3NsK0dzK3p1?=
 =?utf-8?B?TitFdkF5SGpCRllPT0Fld0ZCTC9EQ3pvdDdWeTVMM0lZWTVWMjljblRLK0tQ?=
 =?utf-8?B?Z2pTaEZSSG9uRXZzT2pweWtjb2NqaHRyMWdFcGVsNGc1V1cxRlJES1ZEUHIz?=
 =?utf-8?B?RC9iR21ZM0ZMbC9rTGcwejgvcW9KSjF5ZFMyRTZJOUJwOGxWZEoyN1JZSDBQ?=
 =?utf-8?B?TG8yRFIyNFAwa0xNdFR4R0ZZNUxja00vR0xNS3ZHSVlFclVJSGJPaTVLRWdO?=
 =?utf-8?B?K0dBb0lyOHNrYnRXTENiT0JubG1JRU5FZmlqVzJxOVRud2xkNG1mWnlBVmRp?=
 =?utf-8?B?UXVDTjE2WmdKWkZNMEU3VWJ5ak5lMnVZUWJ3QWMyVkpZYmg4bGpCOEk2ZHYy?=
 =?utf-8?B?S3cvcVNYYi9WcFo4VWdLVkp1dXJ6eWt6alQwTENqSStwdXZNUWp6dXcxN2Ex?=
 =?utf-8?B?dEQ1YUpwc2ZvaFo0L1A1aXF4MlRUalBnN1NjemVuMnBoYTFlNjBrOElqSm5t?=
 =?utf-8?B?RXRhOGVLM29OZ29vNHpWWTYrem5Eb1hjaStLQWh6KzdFVkxEWTZEZUpnTVgy?=
 =?utf-8?B?RkIvY2E5ZHdEL0V1NmVmY3phYjhTRlRzZDlreTEyLzdTeE1uUTJORnBERjlY?=
 =?utf-8?B?MUt6ckYrSldoNEs4TXNoVU9INlNVME5mTVlhWVhRSjZoOEhkWi85K2tRazdM?=
 =?utf-8?B?aTB1TmR0czgwTFUzM2FaZWFZU01lTkJLWHY3anJTR1I4dFlSS0JscS93PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHArUVhyeXV0RitKL0ZrdERDMmZiUXdjbnE2TVp0eFl6enZ4QU1vS3NTZkRz?=
 =?utf-8?B?cWFkUnhCNmVSamFxOWpFVHR2OVlOTEs0bXg2QmFoN3crQTQ2MHpycHhxRXVU?=
 =?utf-8?B?MDE3RWZ0WlFUMWFHbjFYWTdsT1FVS1BLSlZuM2k3cmtLb0VzZ3pYT2VVYktH?=
 =?utf-8?B?c1VhZmRPYnNqQjZjd0RBZis3TW01Y2Z6QTV6SkRRS1l5MCtpYmhCbXlWNVdn?=
 =?utf-8?B?QWVxV2xIQjFaZ3VrMEs4SFQ4Wi9qOUNJa2xtWWR3RTRMYlVqd1E5SWFkQTNX?=
 =?utf-8?B?akROdVQzRU94SE1RZC9sbGI0a2Ftdm9PRmhtNi9Bci9XalhCekNWL09wZmJ4?=
 =?utf-8?B?S2xuSnA4ekFSalNTT2hPRFZPV1BwTFJGZkMyZVNwN1JmZ2RBM0d0blg2YkhR?=
 =?utf-8?B?U21DTmczTkJLRzQvRHJTblVsSGpBOTdWbktSRXNNRmdFb0MwZW1yRGZCclZi?=
 =?utf-8?B?LzJKdXhjT0JIeTJYYVFZNndISWVka2QrN3dUcWUrVi9QaTFJV0FRc282TUxa?=
 =?utf-8?B?bXo5eXJBdkdRckZhRzFod3RUdkVMU21IUUdLbjYwRmRNL01OeVU0SUMxamlu?=
 =?utf-8?B?VWZPNVFNZm5LdzRSeHpEdzNuQ1FFKytVMXdDZEVPbjI1MkhYbUhIelhRbnpP?=
 =?utf-8?B?NUFCVmlLanNuY25zZTN2cFdaaStFZUtyS2NTSjdjQnBuWkdSVm5hbzU0djlq?=
 =?utf-8?B?R1RXZU85ZkJEbE91N3BJeERWWnZGUXpydVBmNittZDh3N1V6MVV4S2hiVVJP?=
 =?utf-8?B?dXdXd0EzRXd5ekVoRVgrRDBFUTRQYXl1WENoL1BVLzlMT1ZHdzRSYzdmQjZC?=
 =?utf-8?B?NWlTZ0RYNUw5TldLbklzQnZLRW1JQjU4Q2tYSHlSMjVuRFZlMXhCaGhIMmpr?=
 =?utf-8?B?TUZqVHJZaUNxVGVpcVdGT1VjMXZIMjlySWk5MjZFR2w4MG1DQjZyUWlxYWtp?=
 =?utf-8?B?WkloY3lUQkovVk5YbkgxY1RUSm5wME4rbllsdTA3Q0l0Q0J2T3B2QXl5S0xH?=
 =?utf-8?B?QmlpMTBuY0RiQ3VtcStEVGF1Rm5VQ1dVcGw1N3ZxdWJNaEtSeHVNWnoydjlz?=
 =?utf-8?B?NlJKRk1lU01YMnFrczYrOFIzZWdTVHlzQURaWE91eW1CM3NtdjlITjVIdUNn?=
 =?utf-8?B?WDVYN0ZqdTJhOWZSQXZ6bUM1dzVDQTBvZWhCVlg4NjhXWlY3OS9vcFZ5cnc5?=
 =?utf-8?B?S016QWltQndITS85UDk1N3Nyd01HRlY1NGthZ1p1eHMvSFhyRmdKTlN4ZmhJ?=
 =?utf-8?B?VHNkMHV2WDNOVzVHcEQycms0MzQvR2VCQW1LRE5LOFAzTVNvQTlHZS93RTRi?=
 =?utf-8?B?N3VjdEcxNmZVVGVIMjlPZ1orcDl6MkxtSVdzU2ViN0luWnJtemF4cnlDM0s3?=
 =?utf-8?B?T2t0SUlwZDFkMUMxeTlhaGdLNjRnbzdXbjhCY1FCVWRROWVscXhlTWwrU2Jh?=
 =?utf-8?B?S1NOVGZLRW4xL0ZqL3hkUlhwRE1JdWFtNDUzTzBmeHBlQmp0OUpJMjhOU1li?=
 =?utf-8?B?U25rUzlMb0RkRE9XWjV4VTVYaXVSQ29yWXYyeUVrbkxycGJXcHdxU0J2bWZQ?=
 =?utf-8?B?MDNsdkR4OFIzNFVxRWVNempoRVgvNFF2VFdYZldIVmpQMkNUL2VuQmRXUGw5?=
 =?utf-8?B?RFIyajhBWFNPRWdRay84NW5UclV4WXNOOFo3UlVvWmZrZnpEU09pamZadXJy?=
 =?utf-8?B?dFU4TWpaTEtBRnF0d09mU0NZL095QkJZaFNoSW5wVHNiVzBkYWcwUWQ2UW83?=
 =?utf-8?B?bGd4dHNQSGhNdUZWa2NnQlFvcnR0L3NBbm1acEFMMDY4ejhveGY5N0NKeXUy?=
 =?utf-8?B?QnllMGJQcE9LdWlIZW5sZUxnRDY3NDhWUjZLUEwvQmdQbkNnL2dtbkhja3Jz?=
 =?utf-8?B?TkVWZXNWK1N5R09DR0l6OEdVV1d4ZnJuL2hBMXpIMU9tbEo0YlQ2YUhlOUZR?=
 =?utf-8?B?T0NOVnFYTCs5bWFaM3VHYmh3Mmh5WElDREN5UC9sVDF0bytWR3N2b2JyaE4v?=
 =?utf-8?B?QlRoQ3h5YktaMVJIZDlEdDVUTDBvTnY0eStQTERaNXdsMWZyTnN2ZGNjN1hu?=
 =?utf-8?B?UkJPTVNnYUg2M09VZjNsWUVvMXA5d1MrSEpxWU4va1hSS2Q4Y083U1BOaHZN?=
 =?utf-8?B?L1pjNWF4QUc5dlp3eVc2bkFOMGxpTk53SWQ0Q00wNVBzRkhNZmZZMFBUYjYz?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c0e854-24a6-4ad2-c62b-08dcd8f03461
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 21:15:36.3669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQb11Qzb+0eIyI8MHMW5d1GFhwdOlqe6/b8UYQB7Z6d8OIcKZ39k7N7+2yF8NvX7RH+kNxhbSgBtof2A3hlCOiOqUYVA4UZbnMqZTDEVI0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8252
X-OriginatorOrg: intel.com



On 9/17/24 9:02 AM, Nathan Chancellor wrote:
> After a recent LLVM change [1] that deduces __cold on functions that
> only call cold code (such as __init functions), there is a section
> mismatch warning from __get_mem_config_intel(), which got moved to
> .text.unlikely. as a result of that optimization:
> 
>   WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
> 
> Mark __get_mem_config_intel() as __init as well since it is only called
> from __init code, which clears up the warning.
> 
> While __rdt_get_mem_config_amd() does not exhibit a warning because it
> does not call any __init code, it is a similar function that is only
> called from __init code like __get_mem_config_intel(), so mark it __init
> as well to keep the code symmetrical.
> 
> Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

If there is a re-spin I think appropriate Fixes tags can be added:
Fixes: 05b93417ce5b ("x86/intel_rdt/mba: Add primary support for Memory Bandwidth Allocation (MBA)")
Fixes: 4d05bf71f157 ("x86/resctrl: Introduce AMD QOS feature") 

I am not familiar with stable rules related to compiler impact but
this may fall into the "it bothers people" category of fixes so
a Cc: stable@vger.kernel.org sounds appropriate also.

Reinette

