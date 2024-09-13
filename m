Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B276BFD4;
	Fri, 13 Sep 2024 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726263631; cv=fail; b=TMETljh1gwA9U6DfJZTl9aazx02cX3jKzCYLakBSzH0yKPdQhlwUiO0yhyy2qxo/OiiNpy7rjl9Oj0RRaASkjL24fRWJAsMJIZljnUFcjBleSfScfDLsqbTfNcMzHen1S6Sv1Lqt1FYBEWayVAmnBAdsLfm1YCLzV6HccUwzmDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726263631; c=relaxed/simple;
	bh=BIPKEwMKez09muGVg1radX9kFXMNOlf7CrYb56blcYk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sUhfZMQ2dnXcVre+M7Of1s48VCpdYH5BG58y+ZGCk2rabTbf36qQ3aHW68KpsZ8CF7hD5QE8yzSLbf7wfIzRQqO+rvk0zdaM3RcRMThAppO3H/OpLA9xtdvRB+KP6MeIRTDtv/r1iLoGQEYesikltXXvU4i3FUiTzM7ehmQixVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFA1sy7F; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFA1sy7F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726263630; x=1757799630;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BIPKEwMKez09muGVg1radX9kFXMNOlf7CrYb56blcYk=;
  b=jFA1sy7FVE7kuNIMi84elINdQnAGloKG0KacP8IpNa/TVa5pTi920kgO
   OtJmlpnIfBZQZvRXl6g5XvjC3RCj7nGCK3UTft5vu/IwKdbHGc1b6lTbx
   fLix9gKhZ3sIsCAQzTz51QS9GtSZO+4vy9NvFJIEzrJTVVk1jRWhhaZDh
   5zjlEvhz+eduK8O9iVR5JzfkQjjSOv9lCLh35pH92DRR7KrIj7+Gz9DAS
   CdbwRZ0hf8gAsFXLez7GXM1+XdtC3O3yPYPcmcOlDxitb3/H9Y8fqfqzX
   SMrpv+lGZc3IZI0oO+1/iZ9N0Z6C1moVYvBHS+KfJOtjTDMqVjxIG+05u
   A==;
X-CSE-ConnectionGUID: OZvNBlwzTbOptVOMM0FTCA==
X-CSE-MsgGUID: aSIhJRJbScG3K886xIApFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="25063901"
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="25063901"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 14:40:29 -0700
X-CSE-ConnectionGUID: /3x78EcDSxq46xmj2FgdFw==
X-CSE-MsgGUID: 3LjI0K9AS2G553AEvUyXPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="68450450"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 14:40:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 14:40:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 14:40:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 14:40:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 14:40:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5po30vUjJyApt7V1lbWK1Kcyk5K3yQgNCpDhmE9mdmKRX+NwVYG1jcCeYMPhEn/jaFlIZa+ALDNaiUWJ3HLek7a8yw9YflS8dCY+0tAITC4xcTMwfPePdbdlGoiuL8etAgajcoa/q8ZiLg/Fzy4875yEJ08MEhW/2UPs3TG6Ci12N5X1QpgxYa0GgM/sOvUnmAukNb6hC2JMTeXLt2hkgyjwKnysFeZbUJGXROuXEXxf40F6g1rlHnrGqVlfREUX5W4oVd0eKhQ0oTGPgzs5JkSexGL5x2bF/vvsJKurzqyxbtpULtlGtu7pqLPjtUHCXOeAM5M5rDHFxyEf75+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFJZNZuS6d5CGAgF0NJ/LmuM1ION+RXCWAuC3Fk7AA8=;
 b=vz/WEc6jph/Qo06OGgo5Teo+iFE0hYnDos+DbwG554v8P5yjD8zBMB5Jxr8kshLiV0f4sjm4/Xaz+OSoiEYLjAqZkfBTCreveK7Jc8B4xDMSPatrJ7mWZwh9FUcZrpTJlSPQDW9zwTegqKnYiHVF7GimSvWxDDtnqg92yXexJMqlaG4D12ggPmvc6rjh3rav+XpvVXY6H5Td4edT3ERlJb2VkNqIBK/ENTKYsQNFz1q0/5o0Av0PLuGA/VrRaKr7+0vw7MxAUFRQFT4mZbR0tw+0hcmDAWXehePGWOJmavfW+hBgY84TjVGttHF9GYr+2wzzxc+JhZDWdOyV6zcG9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6433.namprd11.prod.outlook.com (2603:10b6:208:3b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 13 Sep
 2024 21:40:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7939.022; Fri, 13 Sep 2024
 21:40:06 +0000
Message-ID: <b77ee442-77b5-48cd-89dd-3c6c487d767b@intel.com>
Date: Fri, 13 Sep 2024 14:40:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Annotate __get_mem_config_intel() as __init
To: Nathan Chancellor <nathan@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, <x86@kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20240822-x86-restctrl-get_mem_config_intel-init-v1-1-8b0a68a8731a@kernel.org>
 <fc49e252-6283-4a37-b4e8-bd329f326e68@intel.com>
 <20240913194155.GA4188687@thelio-3990X>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240913194155.GA4188687@thelio-3990X>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:303:6a::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 48703b99-93d0-4791-fd26-08dcd43ca228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UGhZekx4VmpyRXFmUjlFbStKcHdSSWxhM0gxeVUwZm9LYTVRZVpSdmFadFlX?=
 =?utf-8?B?T21CMUpSc3ZlQkl4dW1YUGtCVUxSNE1jRWxabk10OXNlZ21objVaaTc3cndF?=
 =?utf-8?B?Q3c1RWVVYlZDTDJ2ZDBjWjd1ai9Ib3B2a2MyMTFoRE1RNXhHYzErVmlzR2lH?=
 =?utf-8?B?UXVuSDJJU0ZhZWFDUm1WeWhyTWdFMVpqcEZmenVqcUg1dkJoWktRM2t4bkpV?=
 =?utf-8?B?enV0S1J1MUNDM0diT05uV29CNHpzRVRhdTJldG1hRVpUZ1JLNXBwNGUvaHFP?=
 =?utf-8?B?VFlnM3RTelNOWTl3UWVtWjNSSjBNV04vNFU0SXhqM1E0MnVWSExoYTFkRjVv?=
 =?utf-8?B?clpYaFlwWGk5bFdwRHlTSUduck5RZHRZSWE1UUIyT29NNFk1UTlrNzd3bjhP?=
 =?utf-8?B?eDV4Wm5tc2o4c2xYSWlSeS9qMStjdWZqWFU0bkRBTnZPNnJjNXhTdmFzemFu?=
 =?utf-8?B?MHJGeVZVYjEySU5JWEtHaml3Uzd5cGxnUXUyb2kxdFVzemN6Rk9iMGZvOWJa?=
 =?utf-8?B?NzM5dGV6anRhOTRZbHRvWEVtL25aQVFXSXBLaEJyWkE5OForUkY3OTV4Qk5W?=
 =?utf-8?B?aGF0ODVzUjF4R2NBTC9RS1I5aXRzOERqdGYwcjBzbDhXUmNXMVNnb3IrRTly?=
 =?utf-8?B?bzNMN0ZnQ2FHNkl3ei9ITUdrT0tTRXNaVUN6Nkl3dktPaFpLVFhXL0dIZUpv?=
 =?utf-8?B?RTNIb053TVlOVE54S3IwZnZPb1R3NG5ZcWxxenNubm1DbGI3dTJ1Qnd6RDEr?=
 =?utf-8?B?RHdrUXFHMVg0Z1JXSkRKTGRHblZKVDU4Ty9jdklmVVptWVp4VEh3VCtreURP?=
 =?utf-8?B?dXZ2dTEzdlcydkErZXBhQjBGOUEvWTZVL1FlVHhBUXhJYUVkRTR4SlZ0c1Ex?=
 =?utf-8?B?Nmp4MjJJa1JkWjRSYXBaSDhBRHdUUzkvUmliTEx2czhEN3kwNnpROXh6NGRX?=
 =?utf-8?B?VmVjd242b3VpSzNqWXN2a0JpYmprd1ZLUGh3RzJNNGtEWGRXUzN4WXN1K3ZR?=
 =?utf-8?B?UWVMWmJ3YnBjUTVqeWExZ2xxSFNvOERERFJXZHZXOVo2QzNKZVo0RGhpOEJB?=
 =?utf-8?B?V0lRb3Rra2lBM1hkWUlNSHhIVFB3SWFsOVNkZkJvS2Vma1lhTzFrT0lIUjZn?=
 =?utf-8?B?NFdEN29vVEd6UXdodlBQaFl3cGMvaFhwanhWVERtd3pWV0dlOVRXQ1I3WUtm?=
 =?utf-8?B?TWg2L0VIRWZEaXlMdVpuV2Vwc0E4RXI2aTZaWXZITDdEWG81TnlEZkRldDBl?=
 =?utf-8?B?VkYzcm9iTVB0Z2x0Qnh5RXMyd0QvbmpVRkdXa2I1dU9jYUtVYWJPcVdKdGU4?=
 =?utf-8?B?L3k2OVhOWWhGWTdvSGRzMUxrVWhmMUxZQkJXWWwrYU56NWJHbVUxSllkTUxB?=
 =?utf-8?B?c0RPdjBJbW9KZVpYcjB6MEpsd1lwc1cyd3NZKzFFdDZqcGF5clhKYmQ3alA2?=
 =?utf-8?B?MVdpUHlkcVdTOHJicE8yaXVSUUFCQU5rSk5NUFc0ZndsNms0RTdPZk1IeWJs?=
 =?utf-8?B?c3F3SmdBQkNCZWtxLzI3TzVTRGdoY3JrQWVKTjRZNURZdXg0TUFJNDN1TGpU?=
 =?utf-8?B?QXMwSW9jVkxUcUhuQkNNcGI0U0xyMC9Hc2FYbVpUQUxJYXNabEJWVTA2bFJ5?=
 =?utf-8?B?Z3V1WTF6dXZjSGJtL29DQnhDb3owM3BDazFCaWdYbU1uSkhocThoMSt5dTk2?=
 =?utf-8?B?dWRDTjlkUjFRb1JXeGt3cExYaS8xWk94WjVVdUh4SGpab3VpTko5NnpOVlY0?=
 =?utf-8?B?SVJ5NmdXTENjSE5aRkZFUEZNUDE3UWxWbkpOZjNQYXhyUDJBdUdMNWFrN1By?=
 =?utf-8?B?Y2dweUgrdlM1clJyekNwdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVpIUXd4TERkR2ZwZ1k3cVNFdFdnT3IxbTBtelRMaHRIODJIenE5alpvc2ZS?=
 =?utf-8?B?YnVJK2VMRFdWc0RiVFR4S3g3QzVnUVpTb3gxcWtBeXUycjRPT3V4OU94ZkFX?=
 =?utf-8?B?R3E1dmRjSWt1OHlzZWV1QWRvSGxQeVBhdWt0Qk84c1E4RWR1Zy9SeVRhMHYv?=
 =?utf-8?B?NFNqV2JCUHljOUxMSkwvWnlWaTYwNmRFS3hJdUJBenovNVFKNysvN0dpbTE5?=
 =?utf-8?B?Y1NtNVV1ZVRBZUpVdUdoVGtQQ3N3VytJZEFicFlOZnhoZDZ2QTZPalVMVEN5?=
 =?utf-8?B?VFE2SFJHd21peFZIZ1JHQmloNTJNbFpST0FxOUZ6NFdqTjNCMHVnSHZiK0FC?=
 =?utf-8?B?TisrUVVnVDV6elRXc3VUcjF4TGNxN1ZUYmNJMDdhTml5UjZXQllpVzIvV1BY?=
 =?utf-8?B?aUhFc2NiYmZlaDdSZHE1S0FuSitLU2YrMmYzay9peTF5cDlaV05wSmh0NVFr?=
 =?utf-8?B?TFE5ZkZjeTJUZTRBZjdGbmdlRnVjaVRtdDh4S1FzUEk5blVuaS9vLzFpck5t?=
 =?utf-8?B?elBEb0g4b2lpVHFQQlQ4RERDaWo3dGxPZGkwalVUYS92WDc3b3oyNnRrOTVn?=
 =?utf-8?B?MVZjQzdrRnNxM0tRTTVzaFZycnFHcXo2OHFTd2Jya3g5MWtlSU0rY1Rvalc4?=
 =?utf-8?B?Q2g3SGZXQlZwSm5NS2s5K25USTlyTW9JT1llSUVQd1p1OUVRam56WEJ0Tngw?=
 =?utf-8?B?Q21UcGVqRnN5SzJsSjVGVWZ5SnBDZEhhbCthNFRoOVBDbVJYWndZTzNRejB3?=
 =?utf-8?B?OW1VY05Oek9nWVhKdXo0bmJ2empRTzlmWTQxNk80ZFJjdHNQRWhiZ08xZVpT?=
 =?utf-8?B?L1FMdEpPTFBoWHcvTjVZTS9GSTRzOW53N0pmRDQ4aTdFcDJ0aWllZEFMN1BH?=
 =?utf-8?B?RFVLazIxM2VjNlpSa01qSzNRTHBZUUNxS3FFVDRCNTB6T3FXYVZNWVVUYVha?=
 =?utf-8?B?Unl0MGhxSGxkL29XUlVWK05jZzB6OGNnTHgzUS9hQmJ2OUxzb3JoUFBUUy80?=
 =?utf-8?B?MjRpY3VyNTMwZWJRSW1BVERNMEhSU0hnWS9rNHZHeFM4dnYzSTNzYzNORHF5?=
 =?utf-8?B?V1IrY1ZTYjc5ZGpFSjFqMjVXUk5qUzdXNHJXbFpia0toYmc3Mmk4RXJ0dEF6?=
 =?utf-8?B?WWxBL1Y1YStVR0plYVNsalpqejNOL2ExWUtpOFRCS1ZpWERCOTNXaFl1ZEhm?=
 =?utf-8?B?Tzh3SWg1OEQ1SE1EQmFmZmVHQjRGdkJ2ZURxTGxYK21wKy82ZmlWRXF3SkVt?=
 =?utf-8?B?ZUs5dzdZRXkwclNFL2U4eHlEc2h0V2RvendCaHd3cCt0YVUwUTYzYjJNSVBq?=
 =?utf-8?B?ODVSRkVpQzRlZjAva2VqU0hnRGNwZFU2S0pnSU1Zb2p2QVZZL3F6a0EyY0da?=
 =?utf-8?B?YTY0QUNrSHo0RDUyUUhDRmljMDBoV3NWbTZoQzFSbitmMkh0MlpNTEFWYkpj?=
 =?utf-8?B?SDM4TytIWG5sRlhOaW1RaWVVZlJpMHBLMDlOSEd4SlJZWmp1OUlBdklBWEVh?=
 =?utf-8?B?SUZXZVpSOGdWSURsbVpTV3RMeStEY0JzUFZRNXc5b0NFeGlWalRQbXRJa3lR?=
 =?utf-8?B?cjE0cnI5Ujd3RDBDWGlncjVWLzkrL3N6eWROOGZmRVRHQXRteFFnTG1tYmtT?=
 =?utf-8?B?MVllNGd4aUFCRVZ3NmpyZVJCRWpFT0tWcWhnekJwRGI5YXlXT1VmWUlPdXBP?=
 =?utf-8?B?L2I2NTExbUtaU1ozVHNRbFR5V2twVTRUWi9YbE00V2tIcXpFdEcwNzRKK1hs?=
 =?utf-8?B?dTNTTTJmWjRWcTZZelgwTjA4dW1KWEhDL3FISjFiU0JZRkt1OEtIWGlPWTFF?=
 =?utf-8?B?MHo4NThJRXJ6YzVPUVRlaWdkaWh3d3JLTFVGVGpybG9kaFYrWUJnVnkxZ1RU?=
 =?utf-8?B?ajJHZnYxMk5aQ2J6eDEwNytiTG9acEZkRUNuZmtYazF1c0lsRlhCT3FBVXV6?=
 =?utf-8?B?eVozc2Y5azRHWERXY2U0YVRVb0FuQ1JCVVBVamRtbW1WS3FWSmJyOUtwS0wy?=
 =?utf-8?B?eEN3dEc2bDNGVHl5UzQ5YnYwRGFHaWloMERFOW1XUExSdldtZnpHcHNhRlpv?=
 =?utf-8?B?eG1DdjNaM3lhNkJGWmhndkgzM3k2bEg0cW5FdEdSMFpaWDZHa0MxWUU5Y3g3?=
 =?utf-8?B?Mmlyd0V2Zngwb05ZbGZBK3BTcW5oOGQvRXMxeGJHaGlRaDBLRTlwWVFyYXd5?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48703b99-93d0-4791-fd26-08dcd43ca228
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 21:40:06.4386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvX7EPskMktD1NfgmzbyrrIqCcrvlu9+kwV7+6UK2/H+xlSBwvPOKiLmE1F/TQht9SpI0lsEUSDpJiSu48zFL1eOh0Wf2xrjqozfKTv3EUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6433
X-OriginatorOrg: intel.com

Hi Nathan,

On 9/13/24 12:41 PM, Nathan Chancellor wrote:
> Hi Reinette,
> 
> On Thu, Sep 12, 2024 at 03:33:09PM -0700, Reinette Chatre wrote:
>> Apologies for the delay.
> 
> No worries, this is not super high priority (except when the section
> mismatch warning is elevated to an error but that does not happen in too
> many real world configurations).
> 
>> On 8/22/24 5:12 PM, Nathan Chancellor wrote:
>>> After a recent LLVM change [1] that deduces __cold on functions that
>>> only call cold code (such as __init functions), there is a section
>>> mismatch warning from __get_mem_config_intel(), which got moved to
>>> .text.unlikely. as a result of that optimization:
>>>
>>>     WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
>>>
>>> Mark __get_mem_config_intel() as __init as well since it is only called
>>> from __init code, which clears up the warning.
>>
>> It looks to me as though __rdt_get_mem_config_amd() may need the same __init
>> treatment
> 
> It certainly looks like __init would be appropriate for
> __rdt_get_mem_config_amd(), although there is no current risk of a
> modpost warning like __get_mem_config_intel() because it does not call
> any __init functions, which is really what triggered this warning.

Ah I see ... I missed the part played by thread_throttle_mode_init().

> 
>> it is not clear to me why __get_mem_config_intel() would trigger
>> such warning, but not __rdt_get_mem_config_amd()?
> 
> Based on my understanding of the LLVM change linked below my comment
> here, __get_mem_config_intel() gets implicitly marked as __cold because
> it unconditionally calls thread_throttle_mode_init(), which is __cold
> through __init. If __get_mem_config_intel() does not get inlined into
> its caller (which could happen if a compiler decides not to optimize
> __cold code), that call to thread_throttle_mode_init() will appear to
> come from the .text section, even though it will really be from
> .init.text because __get_mem_config_intel() is only called from __init
> functions.
> 
> __rdt_get_mem_config_amd() does not call any cold functions so it avoids
> this problem altogether.

Thank you very much for the detailed explanation. Much appreciated.

> 
> I can send a v2 with __init added to __rdt_get_mem_config_amd() if you
> want, along with the style update you mention below. Just let me know
> what you prefer based on my comments above.

Could you please add __init to __rdt_get_mem_config_amd() also? I do understand
that it does not produce a warning today but __rdt_get_mem_config_amd() too is
only called from __init code. To me this already indicates that __init is
appropriate and ensuring its storage class is accurate protects against triggering
this warning in the future.

Thank you very much.

Reinette
