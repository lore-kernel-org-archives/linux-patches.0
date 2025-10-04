Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CCDDAB
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759536054; cv=fail; b=M4K3I9xtOJ9JrPAazAluHGGh6bWRQA8JcTSQ8++Rh7Xsobtn7DJJw78W/glOPsljHE7Y/KMpexqEBZqVQyayF5gJQWM/7Oktpx9h41XbM9jGmqA1CDao37cp768acUgvsmVQCQComFNapRsRWTnaH1lk7u1IZ/KjGAkNI5Rm38E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759536054; c=relaxed/simple;
	bh=jKx3FYmEswHesbsY3tnQmk3ukF3UB7hN43KzZ/MGWjc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UgjWp/0T1te7rLwx50k2j5WPjfTWSOLoVTIyghBhP29ApsLYa6IT2C6kVA4MEEmp+xtS9G5TbjXfpfjf4iK67c3OYnVWYARCGVbxZ5bVv/BaPZFiSi8r3qNGVVmRf+HIH7RuUYGOb7wcoVhGph8p0G2CAAtigIqKNa9dSHRJb4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T2Tb4PLs; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T2Tb4PLs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759536053; x=1791072053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jKx3FYmEswHesbsY3tnQmk3ukF3UB7hN43KzZ/MGWjc=;
  b=T2Tb4PLsm3n+XsthtsKzBu5jkUabJ/JdPiHeCRLbDCtKkS78DYasr8+j
   pXhgAcjwa9hL6odwvntBkyUFfJqsUoQNgeWSQtGHizG96uAkubzw1ZrbU
   p22VD/RurvtLjxQm4S1Wr+XhGNIQswEItCa3jx+S2grP6dpfdzVXh+0Em
   vPlCiZAYzyHfw3U+UgAWcRbXlogW9M2u19AwpQxQvczTx1hqD1F0Ptull
   7W1z83lEYp+uq3W2mr9/wuffRrk7HNyD/C3AEVC2+W4Zy+j68RX5U9P0t
   ewbyqlAkyrJTSQNZY81OLCShMTUUz1MkRHRDlO/r+yMC2sp+iCciVeQc2
   w==;
X-CSE-ConnectionGUID: Sn6XblwNT8Gj+d9vp5Ocqg==
X-CSE-MsgGUID: EtCEiwz4RNSmtGbQPGAanA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="87276842"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="87276842"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:00:52 -0700
X-CSE-ConnectionGUID: S2FzFzLSSfqHnyWiMZJeEA==
X-CSE-MsgGUID: fAqM0xWLR1211zd0SZn/HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="178536345"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:00:51 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:00:50 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:00:50 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.23)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:00:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRPmb6p4i/Nt8OZmxCeqiMBxMPl23XAqqlJbvvpQJRoakPB/nMuCMF3URfePrMKb7NsSeS69qrJqCrIa+rq0GWVUdKi+1pYZi55Wyk33DXdbaTo7wmrz0LAOECU/5+6gEUDhZ2LPmv+WQo7W2LRPjNFZnPvjs+Ik5S2x8QIAUNFgBHMIztXx9wtewafRCKeYnQGZc9MUUGpcHlAOjLNUAnJ8vcHTcdy0OxWGcBtEyC/ciYYGK/sGV27bXVcMkxOJloV59ZABmb+QC/9vaz4L2vq4E1B1eJvoDv/Yxhexi9n/Gj0naSk0MfCJsNlVNJLQrP3g/hVKEQTdtCLwz3OCBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkMpdoTRC8AxWpHBAOeJ391yFiDZmFFXZXm70jqXqwk=;
 b=WOeO3R2NTXwcQSiADCC3aVYcPShOJsS/SFgL6ezoMQZW6dUWpQuo6gqyJF+hfblUpZpvUeXoIzlm9MjwrT0UdJhMDP417h0/g4zGoBulF9MTpHt9igYYASP+Vq3+8o7as2M6wNL7vUUp0LscOFKYg+GPHDkM4bGapD72HcYLSjXAmdcv/kzwyZDbKVHe8p1NiIE3npv9xqKMwhMgx5YTY5OplEiNKM10p9PoXzj0MTzT/AWLrcLSrNfXn0/QY2d05c9dgsJ/0DDrR6qDPyvWlyaJqFELQLFq6MkE9Q+9AZgfN2u2Q9FWjUuXs0j31VHvXQvwXyi8Cxr0akQDgWvcrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8715.namprd11.prod.outlook.com (2603:10b6:0:1e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Sat, 4 Oct 2025 00:00:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:00:42 +0000
Message-ID: <a7c9f234-d0aa-41a8-9723-66eabdd687f8@intel.com>
Date: Fri, 3 Oct 2025 17:00:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 21/31] x86/resctrl: Handle domain creation/deletion
 for RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0208.namprd04.prod.outlook.com
 (2603:10b6:303:86::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: 49827279-8a86-4b50-1a28-08de02d90fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c0VPSm9IaEtwRjNBRmxyWWNhTloxMDh5cjZnRWhZbFg4ZXZueWd6M3ZNbzB1?=
 =?utf-8?B?SGhXekQrSzlJV1hMOTUrUUMzN3MyQWJsRVdrR2JNUGN2RldvbVFYOGpHem5l?=
 =?utf-8?B?eVlLWC9qc05oZUJVeXRmQ0pMTGM3Q3RDc3BLMmExUE9qYm80MFkzNCtNYmgx?=
 =?utf-8?B?VmRLd29RZUltK3VEdEhPb3JaUFNqTDcxSU1mdkU4VmF4ZDJJOFh1UDdzaE9U?=
 =?utf-8?B?MDJmT2F6SnRPWFpoK1pOM1M0SDBiRnJTamtzdWlUQ09icGVHMzVhWGNaZ0wz?=
 =?utf-8?B?TW1pc3VEVWtGQU5JZHF1OVZ3eXFuK3dWdHBHSElTc05xTWczcFVod0RDWG1I?=
 =?utf-8?B?Q3NZOC8rS2dtS1dMZ2RjVEhnTUJHcGRGWm9HOXpIMW9tVzYrTDBRZWlzMDh1?=
 =?utf-8?B?allmMERPcW5Sdmh5djJ2eFJsTlhjbjViNDN0Y3c5c3Mza3FqdFMzbUdEd2pM?=
 =?utf-8?B?TEhMSFJlckxZakFTUzZxRGpGL2QrYlZWTmg1VEZORnN0RTFNWHBkSW9UVDJB?=
 =?utf-8?B?bHp1ZzZ5OU1LMGRhN1JjZXpZUDgySDNDbWJicFY2WXZGWTczRkdFWTJEek02?=
 =?utf-8?B?dXVoOUZ4R2VVTGtUeDFqU0Z2djNPRlVQaE5qLzNEU3I1RnZVaGZkVDNrN1Bq?=
 =?utf-8?B?SDlDV2krYVppZ204NjRWRk9SUFdkeGpNbll6b1FUaDJCZk9tQ3k2STlMU1Zs?=
 =?utf-8?B?V2E4K1NoaENvTzZhaDNjQ0dxcm14N2thTWtmWXZBY1hRRVlmZTNQanViVGgy?=
 =?utf-8?B?d1ExME5vZll1ZVlOaDh4ay9MQ2ZVRHJoMUFVNUZjMDl0ZEx5WGc2YzJCWW9v?=
 =?utf-8?B?Vnh0T1JDWGRnbnFob0FBQURsdERoUlpLaDN4Tll0NDgzR1drUUUwcWxXbUNi?=
 =?utf-8?B?em56dk9VWDhSWFdkL0VyODdJMFBHUGlCc3VpcUNLSzZYN1ZqeUpIcDFyYVlC?=
 =?utf-8?B?d0lNK1dNaU41amZRb0NTQlpOMUJlbGduOGtuWDR3amdybXBnaE1OMmJvRkd5?=
 =?utf-8?B?TG52Q3g0QjZLNEJTNm9GenMwM0ZqamoySXEvcHFrTGJ4M0FPMlorSjcwVUIv?=
 =?utf-8?B?ZHRsMUFMdUYrMmtFSE91cmNERmhGQndWYXAzWXczZGFreFlibk1WRklyRnBz?=
 =?utf-8?B?OEY1cXNHc29uYmpzNHpYZDZGUW56RUF2eFFGNDBRYUNsSXcyQ0IxYVVLcHhm?=
 =?utf-8?B?eTR6azlSRXQ0YjNJckcxUUdlRWpacE03a3htUlJnM1VNZGNyRGIySVoreGpX?=
 =?utf-8?B?QXVjVXU4a0dlNkVnbUh0UG52V0xUVUdMY1RxUmdTVC9ZcUk1YmNsZVl0eFQz?=
 =?utf-8?B?QnFocGhiVXYzMElTYVlTTnF2bkoweGJOelZ4b0xjSVY0WWh4dXBESnBhL2xO?=
 =?utf-8?B?aExYM2kzeVEzcHhkZE5rMDFNbkNXRm1sNXJLbUF0QllnWCtCV1VGOUJmVjhj?=
 =?utf-8?B?UCtlS1lyYjhOeklpa0RkV0M3d2dOanlpVkJzVjdnN2xHTit3NjRDN05rQnJ0?=
 =?utf-8?B?dEV5ejk1N0V2U1NNd01jWUVNdWsyRXBOL2hyQlNEWStVTnA3MkFwVGdtV1Av?=
 =?utf-8?B?ajVDazB4eUNtME5HbUF3dGtxL3ZmblhFVlhabmZaQVZBNGJMdHo0S2E0MVZS?=
 =?utf-8?B?b1FoajlzLzE3WVgyZ2RKeFJVZ283UXp2RzU4ZXk0WkM1bTZJaFJiT2xSU1dN?=
 =?utf-8?B?MjVsM0duNVRmL0NzdXJETjBqbW5DQW96QnJQMXBYSTd6QlJUM1R5WFp0UENw?=
 =?utf-8?B?OXR6NlFDSExxT3ZTTWxrVzYrd2FjY0tUTWRlZVpoVGJDZFo4R2cwcUFiZW9i?=
 =?utf-8?B?dGkvTzZiZUV3SmsySFdRTmNqSUlGWkY0OFB2RUp1akRQVzhKR2VENGNuTXE3?=
 =?utf-8?B?L1FWdnhLZUdtbGlWVnl4UHEzd1hFNGNHckdiVXRHWVJsWndIR3N0R1V2UEoz?=
 =?utf-8?Q?R3ZrXP1L/mEH8QLygGqJ57IysQFxL2Y2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzlZWlFwNmpON0pDY3dWT3ptVFMrTnp1c0lNZ1JQMDRBQUFHYlpPTGdiMytw?=
 =?utf-8?B?enFyT21yYUVTOTdkcHJWdTVMMTRkVFFYcVByWWMzZ2lDeEdGcERleUY0bERD?=
 =?utf-8?B?VC9qVkZINWJzWXIyNGt0Q3hqcGVFbEsvK1dDRFk3WEdmME56WXlLYnZJdmMr?=
 =?utf-8?B?S1dSdDlKaUlxU3FOVmU1QkNLWWJPTG9yaUc3Yk9VOExtcUh3bW5xelVSYVdl?=
 =?utf-8?B?Sjl2QlUvUFhobEY5Y3NlTXo1UTBrU25KT1IxSkxPQXk2K1hCQjk5YVl2Slc4?=
 =?utf-8?B?czZNenpYd0QrcExZUXVqeUJCcm45WGxuZ0piOERJMGpYdFJOSGhBa0VlMG4z?=
 =?utf-8?B?c0JlTEpNWkxPUHdoeUlrYno1L3BCTDZvQVFlNFlSNktPdGV3NXZtcVlNR05P?=
 =?utf-8?B?bTZITU1HY1lYQXhYUnBnM2UxMWJ0Snhqb3JIWTFDaVZtd1AwOXk1NlBxKzNq?=
 =?utf-8?B?Z0t5b0M4dURPQWRITDAydjZ1YXk5T2krZ2xxSGpjVEcrcmxJdGdnYmMxQkZ6?=
 =?utf-8?B?VUpRcWdUbG04U3FpUmh0eTE4ZGg4OVlnaC85OHVOOVZRaXVvVllmSHZoTDdG?=
 =?utf-8?B?eEhNU3JUZFZWeEVIcTlqRHlvU0hzOThaSEQrM0kxWEt4WEtydWN4WW5zeFNi?=
 =?utf-8?B?NVFsTlNEdlBBN3BuSldJcjI5VVZ3ekk3aWgwYVFRVmpOS00xaHAyNFZkK2M2?=
 =?utf-8?B?aWVQbS9vSEl2OU93azIwcmd6T2Qrcjh3bUljanhHS0cxNi9KMmdsUHQybVNr?=
 =?utf-8?B?OU9Db0ZzbHZUTXdHZXZKVllVRFlTV25BaWl2ZHh1WnRJVmxOeEpNQUV5Z05u?=
 =?utf-8?B?MWw0c1hjUmFjYlUrZ00yOWp6MTNmVVBxOUYvdGRWWHBmVXdHa2hNQTl3OGFJ?=
 =?utf-8?B?ZkxyNXZvNXpwTUFSUFhiUnRsd1FpelJzK2tMWmxxWDV2Z01DSmNaVTNSdm5l?=
 =?utf-8?B?TlhsZWFmSkErMHR2Y1d1SExVZm1GR01PWnFYWE94MWp3OTg0dXpDaEF1d3kw?=
 =?utf-8?B?UmpwMHNlNWpBVDdvTzNrQ043L2tQcUFSTVprRjVKSlFScC9GY1JwbDdrWXhm?=
 =?utf-8?B?RTB6OFFpZm5qOTZVSkd4Y085dWRsa2R5amdId3E5b0o5ZHVzVlQ2QkxuWVNK?=
 =?utf-8?B?YitaZFNmeUh3MGpzMEc3b01EbUNMZnVVM1Q1Z0NWRHBkczN3NTdWM0duK0ZD?=
 =?utf-8?B?a1JISjZQTjR3QzN4ZHBTdk81alYxRitTUFRLYjFST0FTUDdONEJWVDZZcXZu?=
 =?utf-8?B?TXdwNnNqUkZaUWdIalp5QW1pQTBUVG1PaVFRQzJOVFM0dFN3NnRLUVN3VjFL?=
 =?utf-8?B?WWRiWGo2MWxKUWo2Z3NZVmhtaStXKzk2eTB1dzRkY0JBc0t6T2w4UWZaQy9m?=
 =?utf-8?B?ZjBSYThFMjIzSVRrSU5NRkF4Z2luS1Bya1c5Ym5Cd0h2RFNNZldyWXMyUmJx?=
 =?utf-8?B?ZFg3WVcrNkVTUGlQTVlOWG1aYU5PY1EycTVyTHlkNnJxcHdUK2U0NVBTNHU4?=
 =?utf-8?B?M3BFazNaZDdHd1NBMlYxQ0FMdW56UVFJc0JwUEMrVG5SdUJjdWN1RDFSbUZI?=
 =?utf-8?B?ZDZoWWJScnJUOEs0d3NEMmZCeXBMOThtYnExR016M2FoNlMvVGpCa29DODNT?=
 =?utf-8?B?TDgzWHRhL0JoRkNOQnlxU0RDdTdIaWUwWjBYWVNkcnprRGQ1UzRQR011bEx1?=
 =?utf-8?B?ZitLaEwwRXFoOWpobzM3SG9CN0Y2S2xuazJnS0Z0dktmOHN0UkpHSm4rclhJ?=
 =?utf-8?B?ZjM3eElsd09iTENoVDNQVldyRUZmVWZ1Vit1T1MvRWltaUhWeTFvQVFCTjZT?=
 =?utf-8?B?bDJOc0M0TGQ2Ym1MdTlPTnNDWnZadVhCbGt5K3FaN3Q0eVlqR0UzWGFOT054?=
 =?utf-8?B?K0xLZ0JYN3NweXdwTWI3WnJYMGNMMzBGc2daM1ptVDVGWlk0dEpOcmZoUEMr?=
 =?utf-8?B?cFBSV0pkeXNHVVhFdEFaV1NoREpCN0l6QXl2OTJjKzFnS0ozYjFJWkRieHQ3?=
 =?utf-8?B?M0JVUlBCbFR0TStWMCtHZzdRdGZiMUkvQkdjdUdHdEQvUndqQU9ZaFhHTlkr?=
 =?utf-8?B?NFNFZHJ5UVBTbExHUjFzb040OE4xZGdxNGV5K3FKM0poWHQ2UjRCZWEyOXVT?=
 =?utf-8?B?T1d2VzE1NU80QVdEbDBFaldLa2R5SW9SdXpmMXg2VTdRN05iZzBTVE9CSWRa?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49827279-8a86-4b50-1a28-08de02d90fa5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:00:42.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4EgkrehJc9G8AhizqcLuwoNqx06q1BeKTvTGwo+vqPivgd2tV6SZwFZoH9m3Op4iu8PK4E7rHSkBMBne7E6h/y0VQKfuhPg36CeReHq4ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8715
X-OriginatorOrg: intel.com

Hi Tony,

(subject prefix missing the resctrl fs changes)

On 9/25/25 1:03 PM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are per-domain
> structures that hold the 64-bit values of counters, and elements to keep
> track of the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.
> 
> Support the PERF_PKG resource in the CPU online/offline handlers.

Above can be seen from the patch. Would be helpful to highlight what this
support involves since it is not obvious from changes that just adds 
gotos.

> 
> Add WARN checks to code that sums domains for Sub-NUMA cluster to
> confirm the resource ID is RDT_RESOURCE_L3.

Above is clear from patch. Is there a "why" since it is not clear what
these changes that are related to counter reading have to do with domain
creation and deletion topic of this patch.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  | 13 +++++++++++
>  arch/x86/kernel/cpu/resctrl/core.c      | 15 +++++++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
>  fs/resctrl/ctrlmondata.c                |  5 +++++
>  fs/resctrl/rdtgroup.c                   | 10 +++++++++
>  5 files changed, 72 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 97616c81682b..b920f54f8736 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -84,6 +84,14 @@ static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3
>  	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
>  }
>  
> +/**
> + * struct rdt_perf_pkg_mon_domain - CPUs sharing an package scoped resctrl monitor resource
> + * @hdr:	common header for different domain types
> + */
> +struct rdt_perf_pkg_mon_domain {
> +	struct rdt_domain_hdr	hdr;
> +};
> +
>  /**
>   * struct msr_param - set a range of MSRs from a domain
>   * @res:       The resource to use
> @@ -222,6 +230,8 @@ bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id evtid,
>  			 void *arch_priv, u64 *val);
> +void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> +				struct list_head *add_pos);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> @@ -230,6 +240,9 @@ static inline int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_i
>  {
>  	return -EINVAL;
>  }
> +
> +static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> +					      struct list_head *add_pos) { }
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 588de539a739..5dff83e763a5 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -573,6 +573,10 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  		if (!hdr)
>  			l3_mon_domain_setup(cpu, id, r, add_pos);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		if (!hdr)
> +			intel_aet_mon_domain_setup(cpu, id, r, add_pos);
> +		break;
>  	default:
>  		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>  		break;
> @@ -635,6 +639,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  {
>  	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> +	struct rdt_perf_pkg_mon_domain *pkgd;

Please move this declaration to resource specific case statement block.

>  	struct rdt_hw_l3_mon_domain *hw_dom;
>  	struct rdt_l3_mon_domain *d;
>  	struct rdt_domain_hdr *hdr;
> @@ -670,6 +675,16 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  		synchronize_rcu();
>  		l3_mon_domain_free(hw_dom);
>  		break;
> +	case RDT_RESOURCE_PERF_PKG:
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_PERF_PKG))
> +			return;
> +
> +		pkgd = container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr);
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		kfree(pkgd);
> +		break;
>  	default:
>  		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>  		break;
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index d53211ac6204..dc0d16af66be 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -17,16 +17,21 @@
>  #include <linux/compiler_types.h>
>  #include <linux/container_of.h>
>  #include <linux/cpu.h>
> +#include <linux/cpumask.h>
>  #include <linux/err.h>
>  #include <linux/errno.h>
> +#include <linux/gfp_types.h>
>  #include <linux/init.h>
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/overflow.h>
>  #include <linux/printk.h>
> +#include <linux/rculist.h>
> +#include <linux/rcupdate.h>
>  #include <linux/resctrl.h>
>  #include <linux/resctrl_types.h>
> +#include <linux/slab.h>
>  #include <linux/stddef.h>
>  #include <linux/topology.h>
>  #include <linux/types.h>
> @@ -282,3 +287,27 @@ int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id eventid,
>  
>  	return valid ? 0 : -EINVAL;
>  }
> +
> +void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> +				struct list_head *add_pos)
> +{
> +	struct rdt_perf_pkg_mon_domain *d;
> +	int err;
> +
> +	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!d)
> +		return;
> +
> +	d->hdr.id = id;
> +	d->hdr.type = RESCTRL_MON_DOMAIN;
> +	d->hdr.rid = r->rid;

In this series l3_mon_domain_setup() received an update to hardcode the resource. Can this do
the same to be consistent?


Reinette

