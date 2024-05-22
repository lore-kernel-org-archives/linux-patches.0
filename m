Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEC3F4E7
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412850; cv=fail; b=RGtWheQ68qclmoWlBS8tBmkqsNs2e6z3uaiZNIDBv3JlsLTjE75V259+FwJfhi2YWpYt25BO33DERldZKof3PaSh47okEeUaSfp2Ksgu2bkKZ8v3dQQIEYFnjE+uQfdOXQ5YPJlRPvv7W5dNO5dV5iHmbjV2IJhQu5HCMt2DWtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412850; c=relaxed/simple;
	bh=7t5HwqO2IhPFQu3NpRknFspRIw4i2KhD6OY+QtzzREY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ijAJ0HRDMKdoQdXD+0JJRTOUKyXLnqsKi5MNlTUM/MQ46BoiZs+2nVtOVJu6z4AWCP4AU5aT2WTkfs6Ob5IAD0vXJFPr9m/xZVZAGjenTqDKGpuS/BCqcS1xmBdtHWMfeqzxEeXsNPjxqL2ByuBJwQ2xmM3w5G9I1JKGrSedKFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MSFXptxK; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MSFXptxK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412849; x=1747948849;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7t5HwqO2IhPFQu3NpRknFspRIw4i2KhD6OY+QtzzREY=;
  b=MSFXptxKbQ0cA4BgXtrO6Ld36XlEcvJZY9IKXQnU+QvtJemUi9G8ZlF0
   ZwWIjOAqnAoFGT/gyuJFKnDB7hms3Fqqn5dWuJrhFWZuFxF2OHNqfUZ9O
   oTOk4/oYo417f3qx3lwC/5fBLAqOwYPryEObJfmc9Gs4jU4XyRRQXGuIo
   Q9ewTKeSE/bpmVcY/qmTJcBuMf0mgDpMeiH5f9zfDvPy0XTa8J1YXGi4R
   hwVUwrydlwNCwb+2NlDErTfD+xa03LCukLtyw/cCGkCVzPZtAm/taBBVB
   FjBf3eQKOdin262NBwxXeLO/qjDvUIiilZSplu785y/7RnxNK6iPqMbbK
   w==;
X-CSE-ConnectionGUID: kdSu+pDCSmS9tPU9L1IRHg==
X-CSE-MsgGUID: v0rjnWkxSl2bDcxoZBuEHg==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12546332"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12546332"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:20:49 -0700
X-CSE-ConnectionGUID: TGMyFR8TT0GSDXZzhW499Q==
X-CSE-MsgGUID: RpA2hmSwTPiXiBeShASn7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="37904166"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:20:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:20:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:20:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:20:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:20:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNVEapGDTh09uHK6ItyWshg2LGfc1uCdn/8izk4XGif/FR3n0IK6WgdiGZQ3aCBHii7Am4TBtFi5kPFryJW7LLsKTt9K+DHsL4xBdPvgpS3POFumSh/Vwwg1g8Rc4/NvzC4+Cw2YDT/iYxGXt0CFJaGAYnYExCzyob2XsjzTyPCFsPWbBfSE5u8nOiDyFcJ8/AMluceA6QYQxYH7G0JEiCLSfcX1KcXKXLCrZXWeF6+knR7zdfW8f0AuK28iMpGqby44SZa90x2mANlyMgz1gIzlKEYhgjMh6UROIWZ2ABNOPd6gmamuzyILcZY4PMOEmoUYD8qK9zcML/tqeyEUkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/fYgsefMscpu1hfNAIQ9teNXUgNCbcUzdlvKw+PYRw=;
 b=oNOqBrSb7gAOMTLCttLN/MX9Djd+lDcyqqQro4sRAKe2prKKX1zYfnifL2C1/26CDLCe67JYgjqWw3gwKuCGsdnBMDIPFlG51AmR+j00aGm5Ym3ufqht+5zbXVwLxoobuCd+rDYlvt5CdRzuct+gCCJxYuU9TP0VP321/ZIB2yF34D0M3QfCK8r5BqnwbMI2CL459aohzYGmJpLag/20PUkbPWzOWsT80rj6rPaNVHfqGLww0qT3I3XSGj3F60ZSqeAFN725DCDloEtkTyLtomFmPYGa3KfBUdU6ObNEJp6q+iDLfjnv/g/iuBSFx7Ez1uXxR4iBUz9TEkJLNXhT+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB7422.namprd11.prod.outlook.com (2603:10b6:510:285::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 21:20:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:20:42 +0000
Message-ID: <7f72f98e-65ee-466d-a931-35bd744296f2@intel.com>
Date: Wed, 22 May 2024 14:20:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 13/17] x86/resctrl: Handle removing directories in
 Sub-NUMA (SNC) mode
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-14-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:303:b9::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8cdd93-b9dc-4e18-860b-08dc7aa50927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWNWZDdJUzRkZGJGSVhiQW5IOFQ3VEhOQkJMYjViMzdpNGZPN3VTc0ZObGNu?=
 =?utf-8?B?dDN1eXRvTEU5Z3ZkZktUTHV3ZDMvYzRkOXR3a1djSFVSbFdxbUl2MTVDT09u?=
 =?utf-8?B?MHp3eVQ5WGRUYmhCOGN0QUd4NzNMWXJidHJubnhaZTR2bEUwbUJwbUp3L3dk?=
 =?utf-8?B?RzR0ZlltWE9pS3NOWXBVVHFHSkFQdnVLWWRvT2FrR1A4OWpadkc0R1UwM1ZF?=
 =?utf-8?B?bTJ1RmRBOEpFQkZkVm9KaEtIZzlpNEdSR3BUTnRiMk1qZ3Bwa0JEM2NTOGc1?=
 =?utf-8?B?VnRyR0NjS3c2Qkt0ZENiaUdYUmRNcVVVeWx3L2Q5UG5xUjBETXU3LzZYYjBL?=
 =?utf-8?B?dHVPTks0QWZra1l4UlR1Nzg1amQ4QXo3VThldE8vaHJYZnpqTnBIbDNiaUk2?=
 =?utf-8?B?aWRLMVBFVU5ydUJadGZDbitTdnNHckVyRGNEQUIzZmJpSHBtb3lqMFJUNGFy?=
 =?utf-8?B?c0M4RlVzNU1WSUxMbGIrd0F4NG1UWHpzSXp5S0JhZGhvRnJBUkRZNUN1NGVQ?=
 =?utf-8?B?dmN1RWRqRXBhZE9sUzg3NFBpa1FuUTRVVm4xaEs1Q0ZZbHBXd2o0UmVXbUox?=
 =?utf-8?B?ZkJJUXJjb01ReFk0MEM5YVZOT1ZWTzBJUk1nWHpkOHNKN2I4dlN6QzEyamYy?=
 =?utf-8?B?elRSV3Jwb3lFNlBoWmN6aFo4ejhzUjBkTDR1YkZCY2NmUzVzSXdaV0JZSlFp?=
 =?utf-8?B?MHVLUGgvQmJkcWFEUDE0dkJnOU0zTFBNSWIzWTRlWGVaRTZyTHpzSzhXYWlU?=
 =?utf-8?B?YnZkS2xKaWlPR2o2SW51MHlSdGRwNFJkMUdSRGt4MUR4NTV4dVR6VUpNYlZh?=
 =?utf-8?B?TDgxVEptbnI5ZUhIUlRaekJsV0I5NWgxdkVnQmxnS1Bkanc3SkR0RHJhM3pn?=
 =?utf-8?B?SGszeFdKeGYzYXFhemh3QkZBYzc4MVB5NEFkWXIrSE5zZzAxK1RnSFlQeElY?=
 =?utf-8?B?SEpZZjBGQkpsWlAvclBzRXhhelVFZjJQSXFkNnpRTWN0c1NiUFBwUXJIbGg4?=
 =?utf-8?B?SXgwMjEzUGVNWWp0cTlNZzlLeW8zZlF2c2JWcjhtOXM5VFFWVkh3Z0lKNUMy?=
 =?utf-8?B?aVBQbzI4eE9OYnVwMXdCeGk1QmdjY1Fybnc5Y3Q1S0RyZUdZNGc2Y1A3U1FW?=
 =?utf-8?B?bUpHNFRqVU9tckdsQTdKeWVkOHg0SHRVRVNWYXFMb0tQMXlEZXZ4SUFyYlRt?=
 =?utf-8?B?NiszM0dyM3g1Z1Q2U2NIZTJSK3d6VFlKSUw5UjZsbGZ3ejhSUVUvUXJ3R25I?=
 =?utf-8?B?L29jOUFZZU1nYnFEM2FBdCtiOEV0cGlKOEJEczluSDQ1MGx6ZHRlUUZndGww?=
 =?utf-8?B?WndVMWhsbkxudG5kRE5WclpVSUNCNU1GVnpEN2xhdGlrUXNHSlpsUVh4V1Z2?=
 =?utf-8?B?NUVacitYaktnSGg3Szh2MGo1TEFJNStoNXFVMHdxdWxnblZybjZkSmVpcGpo?=
 =?utf-8?B?RlZSZm15RWl5WWNpUmQzUldDckNmM3JrOUxFS0lsNWhFaXJ6U0ZId2FMbjZF?=
 =?utf-8?B?UENhN2Z2OTVEUGpXVkZid255Z3ZrWVhraWRMOHJWaHJLMUgvTUZZRVVNYUlD?=
 =?utf-8?B?VEoxQ25YT3kwQ2hXby8vT2FQS0Vka3RxT0toREZYTzYvYmppSzEwZlFOMEhF?=
 =?utf-8?B?T3d6OTB4d0VzQmNaOG1xRXVaOFl5Z2VwMitudVlwdGsxSElUdnA3WmNUTEFr?=
 =?utf-8?B?SWQwek1BN2dqNHZYRDQ4aDdtZWhiNzBSOVdjZlVQclpMUkxjT2RrYnR3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWlQSDZHMUNaOEpFUGVnQlRwRkp6cEJudTk0VG9mWngxTm9IWHVXaVppOEpn?=
 =?utf-8?B?djdrYjhoandHVVdITSsyQStiQ2s4eXZ6UElmZnZVQWNEcW1GeVc3MVlyWnBp?=
 =?utf-8?B?T3ZBYkJlR1JMVm1IM1ljd2lQWmh4SVFWdFJNOHhjQTB5bzM5ZTk0UjFCdXdx?=
 =?utf-8?B?SGZEbHhzY1FkTXJIaU01dWVnZ2M3Uk13T0hWcm9IdUZhVXk4SGRmQkUyM1NM?=
 =?utf-8?B?RWlLMFdoUGxVcXpQOUVnNHRHUm9Xd0F6Z1FsOTJQNjJxa3dxa3BSS01wRnlV?=
 =?utf-8?B?QXhtdDZkOGdCYkt4ZmJCcWJ3OWlMN2NmNGhKSUZoeVI1TC96VmtXbnVEaDRj?=
 =?utf-8?B?YjU4TGJCSkxmVmsyTHpaYVRhN1RqdVhkc2tYWmlDUFBFVGdyQStHNWRES2VF?=
 =?utf-8?B?RWkzTnpGdm0wL3RlZ2ZlbHRacmNLUWt3UWxNSTl1QWMrbGZoVHlEWjJCbUxt?=
 =?utf-8?B?eTBBYmNQODlYZFpNQnJsK3ZaUnh3YzVVRWp2ZFNPS0xSWHM2OGl5dWhZRUFJ?=
 =?utf-8?B?bUVlenZVa3VCZ29aMGF6RmtXNGNjQ1NCVFRrU2VVcUp5cUJ3Nkt3OEl3OExo?=
 =?utf-8?B?bzFXMDZyNmpOM0pSWU9ieVRZa1hyeGxvdzBGa3BFb3RWNStIeDFZWWZDLy8x?=
 =?utf-8?B?OEIrY1hvUEZYUXdTU2NES0hoRWs1enhNbFk1NzVoaUhLczZKOFRiQ09ET0xU?=
 =?utf-8?B?SXg5dnBBQ083dGVjTDU5Z0xaR3FrVmtjQ2x6ZnRJL3kvVXhvdXpCcTNWWnJi?=
 =?utf-8?B?Nm82cjFHTUJmZzdWOXFaVVVrcklPZ044RXBzbmFHM3ZWckg2V25RUThLSEZ5?=
 =?utf-8?B?UmlnNjQranQybE5FNTEwcXptalJvR05rcm1sN3pleHluYi9WejZMYW9YNHdo?=
 =?utf-8?B?WW8wcGs4THdEbjFyOXJ4WVBuZUJaSktWZHlqV1A3T3ZPSXM3amxHN3htYlE4?=
 =?utf-8?B?WHFFL0g2SzFDcitiVWRCVStBVVRuNjV4YjYzODB2Z09rMU1ncXkrQkUzaEhO?=
 =?utf-8?B?eGlxQWl1NTRLckFxRHJqeUtVZ2Rla3pDQzFRZFhRZHJMUHZ5TzBjOFBVcEc5?=
 =?utf-8?B?TkxqcGZsVHByQWhESW5BbzBlS1hFK0hNenU0eUk4Z28yOTU3YnlHUEtTQXph?=
 =?utf-8?B?QXRZVDZtbkNRZVlHWE1Hc21PVld1emt1K25SdzZZTzhTUDVxMm5PbytFZG9F?=
 =?utf-8?B?cStHS3NHRmRZQVlkblF2d1cwZmJSNEYrUWhCTGxubHYzc0FubW85ZXJJd2xh?=
 =?utf-8?B?aVo0WGNYZnRsL004UVZUNGtydGxjZkdtZFpzTVpnTS9nb3NiL3N3Ni9Rb2Fy?=
 =?utf-8?B?aHpMbHNDaFgra0hqd2tja2FZRXFSaTJjYTdPd1hXNStkYlZFVVJ1ZEs3SHRC?=
 =?utf-8?B?N2RNRUFSSTMxVi9pZ0JpWU03eTJVVi8zNFM5VEtSZnFBZTNzS0VFaHp1bSt2?=
 =?utf-8?B?bTlKUVhUSy9QZlRJa2dKQnc4M203bTVXaEhBdmdOV1pKblFWNEcxRGNXRzBH?=
 =?utf-8?B?VnhaaENNaWQyMnppeC8wMzdnRm44U2NlZ2swclByQlZQYmgrNVZVVXBXNU1U?=
 =?utf-8?B?UFhOTnFnS0hBM0MwbTFWSzlyMUNNQ2gwVzdLOWV1T3BBT21OTnNqOU5IWmRZ?=
 =?utf-8?B?VVFieUxRc0hNNEFESC9SQnppejEzSlZsVXVFRklFN1dLU3lBeEZaK3BEZU9y?=
 =?utf-8?B?clBOdml4QlRQZjhrY0hCYUM5QVJmd3l3Wm9hYkxOSXl3S2RkdmtISWNqK0cw?=
 =?utf-8?B?bnQySjlxTkpNT1BIUWhKMjZMOUdrSklGbE42c1l6N29pdlpzVVpvczJXOURt?=
 =?utf-8?B?RDZSMnUwejNPdjJYMS9ycGZodVBBd2l4RWhMVEU3N1p0Nm1lWHpicjZJdnlB?=
 =?utf-8?B?aEs1UC9tK1QrRG8vTy9LNk9vNDJGVjNheDBuaWxsY2RGU1NSQndpbVB5ZzFU?=
 =?utf-8?B?SWpVVEkrdzNRM25rUzFFazBJL1BEQkk2RkR3T2Z3bFpPVy9iV3RDb2pCaFBV?=
 =?utf-8?B?T0k2SkhLdmZJZGZkdDRnTGkxRVZsRjdpV01GUjVSTXNsM0Z6NmJ1eXNMcFND?=
 =?utf-8?B?d29LNFZRUXpDSVZsTFh4OUYzQnZEK1N5Rk9Wby9MbEtTSUNVVXRTWVpodzd0?=
 =?utf-8?B?Q0NUNjJhVUdlbEdleWJEYUN3TTlNeG5ZSWIrTHhUNTRMMUVPWE5NbzhDWnlw?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8cdd93-b9dc-4e18-860b-08dc7aa50927
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:20:42.2858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4K/XCarTjaU7i8tvJ49trH6LfoZEQBRPhzLa6ux5CS20nlzwv4BXTFvMoRSjCyLjXsl+c5eAQtTApRDuYblziXOdmGMw28c7b12ouKH55XA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7422
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> In SNC mode there are multiple subdirectories in each L3 level monitor
> directory (one for each SNC node). If all the CPUs in an SNC node are
> taken offline, then just that SNC node directory must be removed. In

imperative tone needed

> non-SNC mode, or when the last SNC node directory is removed, also
> remove the L3 monitor directory.

There is a disconnect between changelog and code. The code tries to be
generic while the changelog is as specific to SNC as possible. This makes
it hard to go from changelog (ignoring that changelog does not follow x86
customs to begin with) to patch.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 43 +++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index f0f468babdea..cac32ddd3afd 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3011,17 +3011,46 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
>   * and monitor groups with given domain id.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   unsigned int dom_id)
> +					   struct rdt_mon_domain *d)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct rdt_mon_domain *dom;
> +	bool remove_all = true;
> +	struct kernfs_node *kn;
> +	char subname[32];
>  	char name[32];
>  
> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
> +	if (r->mon_scope != r->mon_display_scope) {
> +		int count = 0;
> +
> +		list_for_each_entry(dom, &r->mon_domains, hdr.list)
> +			if (d->display_id == dom->display_id)
> +				count++;
> +		if (count > 1) {
> +			remove_all = false;
> +			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		}
> +	}

This continues to look suspect to me. When I took a closer look during previous
version I thought this information can only be accessed via inode. Seeing this
code again made me look more closely and it seems there is no problem to just
query how many subdirectories a directory has. See for example, kobject_has_children().
Doing something like that seems more intuitive than this quirky way to set and
use a flag.

> +
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> -		sprintf(name, "mon_%s_%02d", r->name, dom_id);
> -		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> +		if (remove_all) {
> +			kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> +		} else {
> +			kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);

kernfs_find_and_get()?

> +			if (kn)
> +				kernfs_remove_by_name(kn, subname);
> +		}
>  
> -		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
> -			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> +		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
> +			if (remove_all) {
> +				kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> +			} else {
> +				kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);

copy&paste ?

> +				if (kn)
> +					kernfs_remove_by_name(kn, subname);
> +			}
> +		}
>  	}
>  }
>  
> @@ -3111,8 +3140,8 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  					   struct rdt_mon_domain *d)
>  {
> -	struct kernfs_node *parent_kn;
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct kernfs_node *parent_kn;
>  	struct list_head *head;
>  

Stray snippet?

>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> @@ -3984,7 +4013,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	 * per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
> +		rmdir_mondata_subdir_allrdtgrp(r, d);
>  
>  	if (is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);

Reinette
