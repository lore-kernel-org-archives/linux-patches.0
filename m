Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB243277C8B
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758232185; cv=fail; b=a+avntWhnJajbAeve756raLQMQ5pVSnGuUPGum3SdxuM4VbqWSPNxG6/d9+q19Cmw14qpX5aPKYc+yJQ4bmtnb6XX9KThWY7LRMxywArSehBv94ZxfP6tvS4RGKScwr4LR+7Ziabs2wfVE0YHWg5K6kngGefQcZQCysEdQj79mE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758232185; c=relaxed/simple;
	bh=TFzBWRkgPGZYuZcmMr7nbpEMRribiTgKumyLkNa2yB4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ILUxIqwCgif4fZYErUAqsnEA9Vu/r+3jmNRcav90lAVDyXhGpreFj1pFeppaZhQQMEkEn7UERJ6mFLaqGkttHLGYnGs/HTOz7itcogEjOu7waIR64H3R6xCjJzQMHjmXURTx8vl+lVRTfM4ZBXKtpfPl/bDrgVd7ISADk/x20fA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PV4B3Qqj; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PV4B3Qqj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758232184; x=1789768184;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TFzBWRkgPGZYuZcmMr7nbpEMRribiTgKumyLkNa2yB4=;
  b=PV4B3QqjJJEH8O7Zj/5kHlxLZcalIgOSAmf0Su+wYchY1HbGWHW0EUwY
   lyrubzWtxSvtDXfBNd625+VN+4Ai+Zehz+8lHIbH/8Jcj4JYS7cKTyzyx
   puDjkQY/l262N0swSOMAfc1MhY3ZAGgLmYN/Zru2HcZslEuuree3Ti1UX
   wc5h9ufk+99giHL+5/MEYtZnk5X2pR1cIJVTydEAuZZPUkTgpNuisBC06
   VmqsDU67vYO5NSujPxmRFV6v7sZ4FwT0ZA49xQhFfvhC3e4625yKNH1Rz
   GGmivJhNV7JzxLAtNSTaRAjpXJ0b9/1B4/wjZavxmWAkiTIGGRubj1iYh
   Q==;
X-CSE-ConnectionGUID: K882NBJ4S5iDsLsUhkndnw==
X-CSE-MsgGUID: TZ9XMoSkR2Wp33jRvF+aqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="78180364"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="78180364"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:49:43 -0700
X-CSE-ConnectionGUID: ENzZUBp7TFKK2hk/7JkM2Q==
X-CSE-MsgGUID: J//g3k8sSKSUURRpLb9pZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176472314"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:49:43 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:49:42 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 14:49:42 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.50)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:49:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=puPbJbJolLuMTCCPkFTxbSTnc75K0Hq16A844Lnalr78P724R1AvLuzefWIh9LA2pLSOPPUV2qsH47KUixR3xb9niTYO9zfAhj1w+JsAYnJ2eY4xOAf1qzQl49mjamVHQ/yS7J/hewN5T4CiOSeEarr+BTGLtD7LHVUOx8p5vA8jJ9bRhwzb5neo8C9B7yltZlD0Db5SONkGjUZqsqwmbGl1ztMnI7AeTUWlY1UCzlfrdJnXspklxDNhQfUa4970hucDx6g+k3yiLyPuBgC8CyQAq+8A4jAbhW8lBzK4VnF8StC9DROZWo4p1IzAiqkskJRsJ9V9DcMeycaLCocwYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJI7P/xfdjADK9k0DY1jSKO1+aYc+v7pvT40ekgusek=;
 b=OKyFlq6WctJF8ntChom8FZ07wpfu7dFbmuVORFgciyJ5juRFkITInzT+44r5YqzJapNKYCY8v7mTBxpx6bWjzM5VWsWKEdhlpVXWzASw2xxWKReWdrF6RE7wmGgJ6O/Yh6cbeZPIyPsQp7wjXJ/wJoksa8HV6+zprIxvQVM+QN8C/wLoqnfgPS/kYpRc2EVG34ys/T+t5YQTlOvmcCAvMNFhsJJMIVRR3RLHe1Hq/LjqbLi3kgf0+xcrkZajRac7IWrhCSTDAuKu9BL+08fDC0NCdudW9I9tmstVBSyWUVEDFBJUR0U0AxsfkkkoDTY+POtTNYuVMqfWuJoI3Zj1fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4799.namprd11.prod.outlook.com (2603:10b6:a03:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 21:49:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 21:49:34 +0000
Message-ID: <502228b9-ecc9-4c2a-b268-a51fc14d4c1e@intel.com>
Date: Thu, 18 Sep 2025 14:49:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/28] x86,fs/resctrl: Refactor
 domain_remove_cpu_mon() ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250912221053.11349-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4799:EE_
X-MS-Office365-Filtering-Correlation-Id: 82ba214b-1ff4-44f5-5930-08ddf6fd41ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2drM3lIMDVlUmNKenAwSEIzRlJId2t6dVdzdllJWGI3NHU5QS9wUEhCUkdK?=
 =?utf-8?B?a3RXN3ZrYk5pZzVucWU2N3JKSk5PUVhNL0Y1SzJYMWZneHJxZlBBZWZCYU5Y?=
 =?utf-8?B?MU9PWjY4VWQrME1Wb3d1cnRLUkYwUGxKU1UzdHZMbkQ2K1M2MVVoY3QvUEZt?=
 =?utf-8?B?T05BRGk1Uk5xZzFiZ0NoK01zdmFXNFdUc250aVgrQ2Nhd3hUaFRvSzZDbHpL?=
 =?utf-8?B?dEhiNFptTnVIN1BzOStOZUdSeW50SDJLS0M0ZCtBY2tPSW85MzR4L3k4dlc1?=
 =?utf-8?B?Z3BoM1BXUlVnQm00Qjh5Z2VUVVl0WnZ5WW1ONm12azNsVzJBdGRSNnhIVDZP?=
 =?utf-8?B?KzYvUFplVTZwek9zV0llcjVObnlXYVMwNUh6cDNRSWRWenRvZnRlRVlDcHdt?=
 =?utf-8?B?eUlpZUVhR1NhQzZSejF0Tm1nTE00MEZlRWRVVzY4eE9JemgzU0hVeUJ3TElp?=
 =?utf-8?B?YmFHRXp0QlBqOTB4SGJxV2Vqakk5aEkrZnVrd0x3Z1BlZHRQaGhWQUxJdWsr?=
 =?utf-8?B?Y1loRzdoTytUVUNqSy96Z2haOWNCNzc0cDJoamR3T1pwSFFHSVBrUXNFN1o0?=
 =?utf-8?B?dVpOaWpKZUg1TjhJL2NZOVlVQ2p4TkhIM3N3S2xTbHJPaWkrSktLQlJzZURC?=
 =?utf-8?B?c01VMldkMnREaXhlT0x1RXY1NzVwNkppSE9YQ2ZQY2FZdkU5aUEwWVAwdWJj?=
 =?utf-8?B?YlB6WlMyMlovdHdMeEZackIzb1REOGxSNG81cXhmeUh2ZWZ6b2lnV2RxOXJH?=
 =?utf-8?B?N3VwUXMvRjZlTm1vdDhNQ1dZMVp3R1BsTW5Bdm5RL3ByNXNKMEE4a0pvV05I?=
 =?utf-8?B?REFyNXNtZi9rRXo2RXNIMHpUeXdZTjhEL0YzRmpnTzlSN09ycVdnNCszS2ZI?=
 =?utf-8?B?VmJOUFlid3JNNTJFRnByOGZtWDhkWklYVWJ2OU54MHRjRzV2bzBlRk8wRVJt?=
 =?utf-8?B?Sng3MXNwbXFleVNJOW9qcWdqczlaQnJJWUhNcW11Y3ZUbm8yQXBZUnN0U1lx?=
 =?utf-8?B?Tk1xZk9abWNPbVBSTDE3cFhydVJwOUxJN3lSQSt2MkJIZHZpeEJTbTlPUlpo?=
 =?utf-8?B?Z3FlekZLbkRscDlua01JMS9xQnk2VVhYVUdEOHN1bkZuYlZxN1FmQ3c0cjVv?=
 =?utf-8?B?OEovd2x3SS9COE03TUtuQnc5TkZjdzBPdTdPTEdPekRseGYyMy9EaFVLS1pF?=
 =?utf-8?B?V3lRU25RcnFsZHZ6Y1doZTFCZERwNkljMEhEM1VINURheXJPRHc1bjNxWFJO?=
 =?utf-8?B?WHRORTJkVktXajMvWjZMTVp2eDNIUGRZUzJEUzNtanR2M2I5bGpHTmtrUDZG?=
 =?utf-8?B?Y0ZlV2lDTm0zdXpvMzdKMExwcE5CWk9IUWRUeHNUQVp1d3QxdHYwUm9vN3A1?=
 =?utf-8?B?blFKNHZuZGdFcEFKMHhHb0JJcFZHMVJLQjRsMXcyR2ZEc1ZvekhaOEEzWW12?=
 =?utf-8?B?ZGRZcmNMalJORG8zQ1h2RWlsRmdBcE13Mk45UXZ4ZlRxM2RoMDE3N2VSVkx4?=
 =?utf-8?B?cTZ6SjJoczJhZTNUQ3JmTE9LUGVCTzdpUGZqR2Ixd09nby9RbWpPR3pUOFlt?=
 =?utf-8?B?Y0c3a1RYYWNqY1A0U2R1YzErY0ZmakRTMXpETTF1d21QWDIxTWV0bEY3dVdK?=
 =?utf-8?B?RzhHSHpTL0xjU09wU2UxT01kUmt5bFVSM0RYRk9mcDFlTllRNU1ZeDZjcXVW?=
 =?utf-8?B?c3lwaW1wZjJwUGNBM3k2MTdLYWl0QkoxRnluRmc5V0NSbWt0bGszZFl5akVP?=
 =?utf-8?B?MGZwMElKd3FtMEo1VEZHMFJuR0FINkdsNTFZemJnUVFxRUNQK2hpaDlDZWly?=
 =?utf-8?B?MGFKNGpCS215aUk1UVNwbHpYOWVXWTd6aFo2RjNkZWFzV0h0Qk92Q0RwaHZt?=
 =?utf-8?B?ZnJrRG8yV1NXYmpVcHpEaXY0L2JNZ3JwZ2F2TDFpMTdQT1JBUGRZZG5RVTIy?=
 =?utf-8?Q?KSo3ajljNsA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFNTVnR3UDNVUHk1L2lXUWduZTNiV25oN2thc3R1akkza3hIV0l6eUNrN1lC?=
 =?utf-8?B?TlNNd2RrSEFTR1E0aHNIekFRYXQ3UGxsQ01GcDROazFScnV1ZlVpKzBENkZq?=
 =?utf-8?B?UmVySm12UzdhQnlHbnl5SW9UcGFlSW9RSDJrTDZMTUk1Q2tCWERub1FtQjBN?=
 =?utf-8?B?MjJBak1EUXZoeEYzU2U5Qy8yT0l4TTk4ZUkxb213VTg5bU4veDFGSllJaWYv?=
 =?utf-8?B?YU1WV0xURFlJcXVKcEdGN0J3WTNHY2o5MEx1WnRsa04ySUYrUzVWVmFGTXZH?=
 =?utf-8?B?ZDlWeEZiRkE2bDlEWTNJWVlVTlkxb2xVdWU4cWxGQ09seUFJVnM0emkrU1Ar?=
 =?utf-8?B?alM1a1RMdG5ucnhheTY4Z3FTT1JJYWt0ZUxCbGlsQXZCZ2x5bytYOWwxRzQ4?=
 =?utf-8?B?QmtyeFNqTlRpUU9FM2RjY0w4VVBqUDM3QkJhSkdGNE9YbXk4SlJPUFlOWFpx?=
 =?utf-8?B?azhmN2V3aHJSMHJmQW5aamoxMHUxNWo4Wjc0ZlhwOS9sR29FLzBIb3BQZWti?=
 =?utf-8?B?Q0FhNzB6QUF6Y29aa1hEdE1pYStkV2F5aVZxb3E2OWh4Y0FxeVZkRkJ1b2ZW?=
 =?utf-8?B?S2hlU0ZFT3hJZDJBbnBrL1dMOVg4Y2dMUFJ3TW5QYWcyelRjL2xIbkY1anRv?=
 =?utf-8?B?TWV6RHlJV09PM0xwMDN2bE9uYlVCeFhWdFFLSFBtaEtFVVljdkJQQVRsb3lp?=
 =?utf-8?B?WjFodlVtWkNlNm8vSEF1YzIrcUd5SVFBeXpiOEQyVHl2TVk3SEdabXZmMjVs?=
 =?utf-8?B?WWV5b0pkV0pnTVhkZTlaNTdSYXl2VnZnRFhFUzdCd3NqVzZXZEpUeHM2Q2Ji?=
 =?utf-8?B?NTZBNWJ1WmJZaVRDSTMwVEtqZFV5VGlsMzRrSGh1d2RZZlJNYnVhbUYwQ3R4?=
 =?utf-8?B?cW12Y0VDZ3N5OW1GTEpCVzhpVUVveWxneHJhTFltV2swbXVlY2UyWDhmODRo?=
 =?utf-8?B?dy9PSFR4a1VSV21uekVhZ2x0UWxuOTVueEhNdllLT0pwQ1Vhdm8vNElQVlJV?=
 =?utf-8?B?Qm43OTlhS0xpdlFnOHZ1QWJGYStNdVovRnNyMW9DTDllazEwVVR2Z2NYQ08r?=
 =?utf-8?B?V2NySDliSGtCbmQ2aFUxOVFrQ1preHdXWXVpbDVvc2ZqVGw4NTk0ZE5yQTd4?=
 =?utf-8?B?cWhBdjFFNjBnYjV3d05wamxzanZvYlhXVzhLU2FYVU1Kd21IdTlqRUpLWmZ5?=
 =?utf-8?B?SmkxMnJCM1JkT2hOc3U1ZnZUUTlNYmg2T2pjek9LcnpHTnY0RHZRMmZRS3Nv?=
 =?utf-8?B?c0ptSFJMaUkwZEFHcDA1Rytvem5aREtGU2FTWTFaeEhJN3RaNkhyUDNwYlNn?=
 =?utf-8?B?T0tqanBrMmFMZFNGa3ZvSW5SWks2c1F1WUgvWjNHL0hiM0RUNVN6VU1kQjQy?=
 =?utf-8?B?TXBERTYwdzdDeGVvdldRYTRrMnJHWk1heXBTOWM5bFBOLyswUXpnL3hOOUUy?=
 =?utf-8?B?OTFFUE15OUZYL3JQWWtnYWxtMDVDK3BHSkNSOGJYWndMSXQzTWthM3JCVXBi?=
 =?utf-8?B?Zll1Wkw0cER2QUR0VmR6TzNIR3dyMGV4OUx3bzJ0QjhKRTVvSkFtU2hJaDdj?=
 =?utf-8?B?TkJIanB5R25oM2pmV2RQSktFMTFhUkhRc2pGdFJ0am5UYVA1RTlHUzFkbldx?=
 =?utf-8?B?cGU1ckQ4YTcwZUpHZTVMMHBPMXhybk1hYml0ZkxzdGtsVU5VcnFXNVpSM3RX?=
 =?utf-8?B?M3ZDM1NqWEJDWUVUNnBacEVMc21HZ1pRZjUxUHNqaXgwcXUwL2dFZm0rcjZq?=
 =?utf-8?B?eVVuNEpZNXlGSC9YNks2Nmt0a01IUnBSM2h1TVkwZng5TmpWZTEvK2JyMCt5?=
 =?utf-8?B?bXFBV1FLbTNyQjBVcW5xZVM5dU43ZURhUmt3eVRsUjZobTdQNEIyRnBibGZL?=
 =?utf-8?B?WGg2RzVydjg2NWlLT0RLemw5d0JTb3lsamNrMUswU0JWaHNPaUNZSkJkUVBw?=
 =?utf-8?B?WHJvdFpLU2V3cUExKzV5RC9FNzNHYzk3ZmpmTlFwbmM0T3VRdGNXOTMxVVd1?=
 =?utf-8?B?T2hQcThiVng0aGZNUVcvWUNyUXNCMkVjSGhpelNiK200NFBDbEpqNFRpTzFN?=
 =?utf-8?B?dm1DZzhiOTVBMG1CdURyZ00wR2RnRElOZkozYkU2SHhNYlpIbHpqaitNRnVt?=
 =?utf-8?B?K09xb3M0SG5wSTRwelRXb1krd3Iwa2tPVXpUZWVNNFZwRnpqU1k2SXJLZ0pB?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ba214b-1ff4-44f5-5930-08ddf6fd41ba
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 21:49:34.7685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7HMPEgfwZ6y+K946OrZlERACf69SGjEiJIcjHRrhbhU9SnV3f83FHozXp6dtU/Y7W7olIj9n+5EdigmkQeBg08xsu/0MHpNy6ZtamaKj/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4799
X-OriginatorOrg: intel.com

Hi Tony,

On 9/12/25 3:10 PM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource.

Above sentence can be dropped.

> 
> The RDT_RESOURCE_L3 resource carries a lot of state in the domain
> structures which needs to be dealt with when a domain is taken offline
> by removing the last CPU in the domain.
> 
> New telemetry events will be associated with a new package scoped
> resource with new domain structures.

Above is intended to be problem statement but the problem is unclear without
connection how the solution below solves it.

> 
> Refactor domain_remove_cpu_mon() so all the L3 processing is separate
> from general actions of clearing the CPU bit in the mask and removing
> sub-directories from the mon_data directory.

Can "and removing sub-directories from the mon_data directory" now be dropped
to match the change made to this patch?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
