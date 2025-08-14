Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD5B27A906
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208761; cv=fail; b=glmJD6nPDrM9k3KUOuv4Bxu5HFephEM9mGv9kWTINLlGQZeiFiIcugrdXuhFO8YkV1ydFeU7NQxFc7Pn2EROfNBd4Ij9iDdYQeuWFNZZiojEqL5LNiqva6KJM9rEKLkwXORqAMOmWQX0udK2It5Q3cUxnS3Ah2TYa2NRthdZNRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208761; c=relaxed/simple;
	bh=kChu0edvrcjezfNiG6pyLS1Wxi625z16f9OlTxS+K3o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DtlKp6N0n/rd0keQqg+rwPU7G6hqMfDLdPL4lvPlTQDFXCVfm+T/45+pzxLiYkiTLXwx0PhqhlwEMtj9u45/Fxa0U91qHxTl7e3JwfPMw8Rf0S0rIUfSLmT2JSnvtewE/n2IPIvffvVXn5FVXhb1Ly77rhFnQZcPxwYRDP1pwsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JW10Zny7; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JW10Zny7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208761; x=1786744761;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kChu0edvrcjezfNiG6pyLS1Wxi625z16f9OlTxS+K3o=;
  b=JW10Zny7qpv/2KL4/N8Ve5QAKdo7e0fCJVRs6FT8K2Ugfa/eaqexHhIU
   2062JM+4XBn7tptgqKT51CXDkFXJAj315ttElHRovZqo9gfxxiuHVxcHi
   oWClsqLUchim+zkDtzXmoW9FNPTXg7o1ob2s+ZGm/7BFa2F7odIqjKMNW
   soOx6Ahpw+nN26WnXJFPW7jye3Gt8lcBaVzyt8Tx+2du0oBZgQnfpnlQF
   hkvntQd39V8t9mMGqIuX1aiXWkIdkm3Y0FeRrRQmPX+f/8NW1m9mOjARQ
   sq2hBSU73wuPuzRGPDImDhNoFqo7zbUA8pTNe7q7oXwuj3ePBkpOu/3VV
   A==;
X-CSE-ConnectionGUID: bSc2JbYnT9ql0nXPnCWsXA==
X-CSE-MsgGUID: 1h4Cl/h1RcSbdL0mmgwYVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="74989033"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="74989033"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:59:20 -0700
X-CSE-ConnectionGUID: RONGKXD4RCm/WNfMcxqT4A==
X-CSE-MsgGUID: 8gDySzBDTtSzLzSCyjrOgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="204052548"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:59:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:59:19 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:59:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.67)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:59:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcgk5gPNpq2D6jWcqZS1G50RslMfkQXr6/z+4X+NKitAF05DPC4PcauzoonAuAbYolicIMXMCnS7plro2q/Nj6XmI9UiQD/5Esz2c4CRSDqz2o2n35N1PeawaPnL8utlleFmoJDPkRBZZz36XmdDmQOSwL+dDAnZM+MORWhYT9Xp2vSB30mm2Pdsj8l/+84pJVSYT+SK14CmOJ89N+etTgSpYRyNHXW4qMB7KD6CaTfwPQVHg3DlCa1bHDPPFJQnVbN5BoTZJimlwG9wqqTqSePusOkxR4FBky+Po1pGHr8HeyM3ySQlX0aL7o+XeR65IzDud2DtJlRg3gKrPCvcEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxoaL3UGV+kpfnY+9ixZSxqCSYhVyIex9VVoTWM3qf4=;
 b=s1JemKIuM0mLNGFF83wI2rJ66GaBH2UvXu0domecYe8NZ5zqPDOlbN9l6rWoy3kHgj0G/KT5tn9mXSZMY74AAnJDy44F+rjbxbdTeHWdXiEm1LAO9jKEBE9bxkysjad44jSRcS3eSOfskTzauMvLa1t9kz0Q25wxCCMLhAkON+QuEPDMSOhVQLGHcbOQuIt4HrdIkl42KSKhSmu9/ro1/GalGUXU8Ug4gPSU1JOlpgxgrL3FpYVO0E89ApFrJyuWVMdpPRaiIFR1wMlBbbOUNQjXGNrmfI5S4wKKmeJUdvRU89f6zTEf/aiU18ruACXVhn4g/X5aTZTHKj1+zY5IcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8467.namprd11.prod.outlook.com (2603:10b6:610:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 21:59:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:59:17 +0000
Message-ID: <52741e7d-6edc-4b36-82aa-65104e2a8ba2@intel.com>
Date: Thu, 14 Aug 2025 14:59:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 31/32] x86/resctrl: Add debugfs files to show telemetry
 aggregator status
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-32-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-32-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:303:16d::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ff5d6b-b34b-48a7-5dda-08dddb7dd08a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MTRRcU5UWTZJb2tiTGpGdWllbGtLNUlRaU9mRkdZanFUWDEyMEZ2VVBFVEha?=
 =?utf-8?B?c2JZZVk5OWpjYjJ2MTcxQlRCWHVwaGNjcXlBaGNmc3QyUDdEL0JjVWZYcEs1?=
 =?utf-8?B?VDlrcm1xcWpEMjcwYk1aZWlOV3I1TFdiNDYzb0tJaWxIdURic3dZV3VhY1ZZ?=
 =?utf-8?B?dXVseWQzT0FNdlFxbmxLajJMVW1OU2UrRGFUT0NrcWxDSE5ZeDhjeGVSbHRT?=
 =?utf-8?B?dm5CNVk5WTIvNEgvTFlLWk55MjZiR0RIT1J4a3VCS1krdGdNeHcwNjRjdzB3?=
 =?utf-8?B?UlpPMkZwUm5zRTBXZ0xZUXVHZ3FURU1WaTJzUzFzZUJNenRiL3FOUjlTUC81?=
 =?utf-8?B?SElmbG8zVzlyWFlXTXlpSjF5YW9xM0UrWWxCQVkvQVNxc3NEMkVLaXBDdEFv?=
 =?utf-8?B?NVlXZDAxM1FLcXFMU0xTZW9CbWUyRElKcno0aCtBS0FFR1dZUi9JSTZsUnVB?=
 =?utf-8?B?UVB6bXpIUm9VdllPcyt2M2NwQXFpdDVRN2R1NGN2cDlOMDBsWTA3NWR2QTlx?=
 =?utf-8?B?RFJSUWdjcm44a1RoOTRtUDUyRTJlV1lmTTNueHFqSmoraThzTU9QYkdUdi96?=
 =?utf-8?B?dXI4UVdZKzZMdzNqaitWT2hiM3hmTG40WnBqQ2lPekVDSmdSZlhiYUpLQlgx?=
 =?utf-8?B?T2d1blNMelZRR1VvTzlLVVhrQmRNQXdQNVFpazBkOFQ5c0ZsbTFia0JkcmhK?=
 =?utf-8?B?NzlrdG02OVNiTkc1Y2prbW1Rc3VCbjIrYlVscUhNSWRteFpHR2kwZk82WnRD?=
 =?utf-8?B?bTEycHF6Smc5Q0U1Z2lGNW15UUJQQWpKMmdTMTRGTDc3NGxzZzg0dlJ0bHNt?=
 =?utf-8?B?S2NOczhPWDYxUWVVc3ZTd05iMXErbHd5akhjVldSVjR6Y05UcTE1SGxVYkdI?=
 =?utf-8?B?TGdZa3BuaHN4MGpWR3U1YzBUaVppSkdaMlhoZmVIK2p6ZUJldTdHRHRwQ3kr?=
 =?utf-8?B?NERzZTFWTzRybmN6SHNRa1ZsVmdpVk5CbDZyRllrbjNpOXRybUdLa1c3NHVK?=
 =?utf-8?B?V000ckVPZFNCMEFEM0NUbEFIRXhmVFJOWncrWFhuTDB5K3NGbFVMSzdaTmRW?=
 =?utf-8?B?T2R4c05KR1dNTFJEQjA0eU8zNUorUjU3bmRhNHV1WjNTUDN1QkNkQVdQZGhV?=
 =?utf-8?B?NEtGTFRyNlEzanFrSVcwV20wMDd2cDZINHR2Y3QxcURjVUJ1RTdNYjNJQ05r?=
 =?utf-8?B?OWVXRy9EZlJ4VEVIeXE3Q3VhZzU1WCs3OGpVaHM2VXp4N3dXYXBiV1hMNmg3?=
 =?utf-8?B?QWtYMGxBa05pTURjYldlbmJqWHQvKzdOVlg1TmRBK05OTXhCZFg3a3NISy9I?=
 =?utf-8?B?U3hWemdxZVNjWDRNcXBuYTJIOWNlZWxWWUpKbEpIeDJVTUpmVGdqYzlaWlhy?=
 =?utf-8?B?QlRqZHlCT0FlNnJ1UHpyQ0NBY1lwMnEyYmh0dFd5a0JjMVBuai80V0NhR0dH?=
 =?utf-8?B?WExhQWt1Yk9ZdFFVc0s5bWkxWXFTbXNZYmlXK2dGaURPOWRSM29HaUhnbS9t?=
 =?utf-8?B?ak9Qc0l4TnRIWndYclpDOGp0cmpvUCsyUEg0OGlBaUVqSlVHWklwSGkweEV2?=
 =?utf-8?B?OWw3ejFmTXVNUWJvaE4zTmM2QWpQVUhyaTdEbjdxZVQzWWtMMTRTeFc2U2I4?=
 =?utf-8?B?ck9xU0Vkc1BQTnR0dTBGM1praEUwZmpLOFNhcGw0V3pHTkRFeHVWNUZYL05k?=
 =?utf-8?B?R25qM0xVTWk3Nk5JaWllQ1lzY1pyUmtYaWZqM0hwMytYNUhYV3V6b0Y0RzJi?=
 =?utf-8?B?WGRiQ3JhdHFZcTVjaWY0US9CVG5IRzROOUhwSUdVVnBkS1lHSGR2UE5sSksr?=
 =?utf-8?B?bHU4VUZRTUs5Unl3b25UaHdNVjhodmdVVDhCaWZBL3F0OHNmMlQvV0w5Qmdm?=
 =?utf-8?B?emhuV3VjTGEzdTE5cloyMFZTWkcwYnp6WHZ6Qjd0cXB0SzB0TW1CczQyeWdI?=
 =?utf-8?Q?nLTZsoP9rSk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHpFR0RsK0Q1c3d2VXh4eVJXRU5aVjdwYzhaTGFEOE5zendLa2xNcVhFUWtQ?=
 =?utf-8?B?STlKYXhMMHRCVldCVE13NVUyT3lyOHF4VGtpNDd4V0RQa2RWYmdZOUo4SVhU?=
 =?utf-8?B?ZDM1blJoWTdmMXZtOEJHME5zemZzRHhhRmpKWHA1S2dzWmpPeGs1TUFSczlS?=
 =?utf-8?B?V3BIZWZFcUkxYU44dzRYVnArSHJLU3p5QjJIbCtLQk5QS05vQ00vUzJ4K3Jq?=
 =?utf-8?B?Z000TzFQNmpGaFN2NHlrT25idTd6NVJYMHJiMjZKMG1wU0YvNnZyTXlZSi9t?=
 =?utf-8?B?NlQ1M0EvVHh1QU9pallnM0tUYnlSZlFaa1dzcmpheTd1VURqNTk4aW9QRHhS?=
 =?utf-8?B?SkRrREZ2bUQvYlF6Y3hWT3NwRmhnVnkyZG41STVScDF6VTNhRUhFYkJEMTRE?=
 =?utf-8?B?TnMrSklKNEN3QmpOdndzdXRWaEtuNFhSSWE2V2QzdVJkbXNWYUJvVzhhWTM1?=
 =?utf-8?B?ZUxQRm44cE5LcFBYS3RyQmF1ZzZIcUdPVVloSFllR3pZY2hGaXIrZ0Y3cTNi?=
 =?utf-8?B?dEVvSDNhaC9vbEVpbGR1ZklneEU1OWxtWjFKWHFJYmQxRWFqakVJaFRCYitD?=
 =?utf-8?B?TGFEMW5YM0x2dVJvTWVBM25SY3NwVkViOXlpK3lGcGtvZ3ExL0xVRTl2Tk91?=
 =?utf-8?B?Mms4a3A2ZkVRYkRySi9yZXpYZ2dwaHpJbkRLQ2V0bVRFTzRDUUw3SnFyU3Mz?=
 =?utf-8?B?SE9GLzU5ZHp3eHBRcU5lUjkzalJoMVlBaVhVbjRITmF5MFl4aTZ4Uko2OHZX?=
 =?utf-8?B?QTV4WHN4dmw5UlRTYlpvQXl3VjVUSmxxMWtSTGM1ZTJtdHhGcnBPV2dOQk01?=
 =?utf-8?B?c0w5OEpRUk9EeE1RR0tKVnN0VGR4SFIxRm1CNXRESFBGVis5cG50WktFSDcz?=
 =?utf-8?B?Ylg1K1VOaUNHWVN0QmRzMi9raTc0ZFo1Wm1OOFltQUFqOUUva3V1cUlPUW5O?=
 =?utf-8?B?ZFZuaHZ3UUM2aDQ1STViOTZmNy9FWldSaFN1WDdacFQ5MnFmbEZqN0p3SHUr?=
 =?utf-8?B?WjBJT3BPNDM4aWxaRDJDZ0VMUnRwSkc0V0U1T1d4MHNIOG0xa2JPUkdaRGM2?=
 =?utf-8?B?cXRXWU93eEtUQU8zTW5nS3MwUERmaVc4V2V6a3RFZk1UWEhobXlWQmRBYnk3?=
 =?utf-8?B?RDFsendPSEZRbjZ1WHVPRjhCdGRwOHZFR3gxdGZ5cFdLYmN3V3A4WjkyUjFX?=
 =?utf-8?B?RGNvMmVuUlBZVndONXJNUUZuYUVzK2x6VHZMQVRvVmJaWEsrTXdTOXd4TERQ?=
 =?utf-8?B?M2dTNFVmalRVU1Y1N0t1bCtWcHRqQm83dXhBbXp2cGFFZzJwWkw1eTFtZGJ3?=
 =?utf-8?B?bW8zclh6Vzc1UG5LbGlWRFhGWUdKNVo2UEREYUNLSi9ZNHdFU0dZVWhLdzhS?=
 =?utf-8?B?SVEvdVdBS09KblJ3ZWl6Zm9NQWNQM2lSVk9PY29PWmhvZmlPNU1SdWUyaXFH?=
 =?utf-8?B?U0pDVS9uM21yTTVRdU1GRjE5R0NMelNwZk1IZVNEaDg0S3MvdEtpcHZvSUs4?=
 =?utf-8?B?WUhOU2FDR1dMMTJKbHFLcUJjYTJscXFaQkNORW1OYldVZkwzRHhNNUFsdzQr?=
 =?utf-8?B?bWdHMTMzS2d2TG9yWW1ySFBFZkdwMlI1aDJFaDZLYUVVYXhNUXZmZksrS2tW?=
 =?utf-8?B?eWxFbzNwdUlpYnZYQUN0cFQ5d3JUWFdTRm1iWGFERG1VQjRpWTBuazVEZjdG?=
 =?utf-8?B?a04xZ2Q4L3J4eUxZbTdyZzN4bUlxVytvNm9mbEcwQkR6NVJvUWxLYXIzNXNp?=
 =?utf-8?B?SmlBelFmNW9UMUh5VWVTeS82Wm9PSkZBSzd0OWJmQ2R3ZFhkSjNSNXlLbnY1?=
 =?utf-8?B?ampJV0VtR2UzNkFpd0VGTmV0SG40NDdZUE9pNDhMZWFIQ1c5NjZzbWx2VG8v?=
 =?utf-8?B?MldIckhrcXFDd3kxd0pCTnk1U0NCUDIzZHdEb1MvT25hUVZNOGlDTEtkUXh4?=
 =?utf-8?B?eUdZMGJtS0NscVcyK0dSZEQ3bS81cDdmZTQ3eUN0bHR6Z1lub0hsMUpFL0sx?=
 =?utf-8?B?NUpWUEdpNXNyRUMrQklpWjF2elVwK2xNSjVMNFd5TGNrZkxtSS84T2lEQ1Rv?=
 =?utf-8?B?L1RNS1FOcURtZUl0QUVxdGdrYWZIZUdFWXNYcWlpNENHVEt1OU4yUVI3YmV1?=
 =?utf-8?B?M0xHbk9IVkhHVnVoaTByZU5SbnVhcG9RU0c0algrdmJud1VIcGk4VndkbW9V?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ff5d6b-b34b-48a7-5dda-08dddb7dd08a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:59:17.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVvc5SRvkTeQtLxF+tZjWhZoje+2uWW1HCdqTsPj87uNcyxARxA7Qm/CNao8F9js3PnvQ+9vbWBIWsLQPASSMmxGOOFRtMYTHpfQdF3HQnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8467
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:17 AM, Tony Luck wrote:
> Each telemetry aggregator provides three status registers at the top
> end of MMIO space after all the per-RMID per-event counters:
> 
>   agg_data_loss_count: This counts the number of times that this aggregator
>   failed to accumulate a counter value supplied by a CPU core.
> 
>   agg_data_loss_timestamp: This is a "timestamp" from a free running
>   25MHz uncore timer indicating when the most recent data loss occurred.
> 
>   last_update_timestamp: Another 25MHz timestamp indicating when the
>   most recent counter update was successfully applied.

With all three files being "per aggregator" it is not clear to me why
"last_update_timestamp" does not have the "agg_" prefix. Looking at the
debugfs files created all three are indeed created with the "agg" prefix
so this looks inconsistent.

> 
> Create files in /sys/kernel/debug/resctrl/info/PERF_PKG_MON/x86_64/
> to display the value of each of these status registers for each aggregator
> in each enabled event group.

To avoid reviewers needing to dig, this can add that these files are removed 
as part of the debugfs_remove_recursive() called during resctrl exit.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 +++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 4afc99e74cef..ff70f2b18165 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
> +#include <linux/debugfs.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/minmax.h>
> @@ -299,6 +300,55 @@ static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **ev
>  	return false;
>  }
>  
> +static int status_read(void *priv, u64 *val)
> +{
> +	void __iomem *info = (void __iomem *)priv;
> +
> +	*val = readq(info);
> +
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(status_fops, status_read, NULL, "%llu\n");
> +
> +static void make_status_files(struct dentry *dir, struct event_group *e, int pkg, int instance)
> +{
> +	void *info = (void __force *)e->pkginfo[pkg]->addrs[instance] + e->mmio_size;
> +	char name[64];
> +
> +	sprintf(name, "%s_pkg%d_agg%d_data_loss_count", e->name, pkg, instance);
> +	debugfs_create_file(name, 0400, dir, info - 24, &status_fops);
> +
> +	sprintf(name, "%s_pkg%d_agg%d_data_loss_timestamp", e->name, pkg, instance);
> +	debugfs_create_file(name, 0400, dir, info - 16, &status_fops);
> +
> +	sprintf(name, "%s_pkg%d_agg%d_last_update_timestamp", e->name, pkg, instance);
> +	debugfs_create_file(name, 0400, dir, info - 8, &status_fops);
> +}
> +
> +static void create_debug_event_status_files(struct dentry *dir, struct event_group *e)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	for (int i = 0; i < num_pkgs; i++)
> +		for (int j = 0; j < e->pkginfo[i]->num_regions; j++)
> +			make_status_files(dir, e, i, j);
> +}
> +
> +static void create_debugfs_status_file(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	struct event_group *evg;
> +	struct dentry *infodir;
> +
> +	infodir = resctrl_debugfs_mon_info_arch_mkdir(r);
> +	if (!infodir)
> +		return;
> +
> +	list_for_each_entry(evg, &active_event_groups, list)
> +		create_debug_event_status_files(infodir, evg);

To avoid using/needing active_event_groups create_debug_event_status_files()
can be called at end of discover_events() and infodir can be a global that
is initialized there if it is NULL.

Reinette
