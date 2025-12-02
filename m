Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2B23EAB3
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693268; cv=fail; b=FYWdchCkjERHnY0lI/4X6N0yzmJiOThfRc3T24X2UY8O+uUI7QK2baCm4lOZllgfPz98YwyV/T5UVnLOFWpC5R2mX/nIVlvqKMo+E2Nyzc+lFAKryRPwI/RzTLDyMI34+NQ18yPV2H0sgWg4qzoVZODXlvq4oodVkutR8zUceYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693268; c=relaxed/simple;
	bh=h0J39GheKNqoBJeI2cUYCkIOc7moHqhTQ0rLCImU43w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YOVmuljxVGWHyJNdlWM6LKiTrppDC37ykaOXOdLoUbxUo2asztvQw2oT1VFbQM1F5vCOWLc0NLyTEtPlT3OoLawpXrmlEoRPqZKATDMbyjgV3bpLpn36PNbuYTFOjHQOHsbRqWkikcNljntP8isK+kRo31PqD+TN9u4mTHAE83U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3eI9UWU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3eI9UWU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764693266; x=1796229266;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h0J39GheKNqoBJeI2cUYCkIOc7moHqhTQ0rLCImU43w=;
  b=I3eI9UWURmaOuWEXq1KLRVfDj2/DkfVFy2AtOVLCxdTVBuPVTGAMo67v
   MOOXvOwmtbcJUWvMGbAS/96BaVCiuX8qsRM5si1badzZzxNuMC3HmQzis
   eKDDRL6yNiKOzvpeRQNQsf83abdrG1V8b7zfvpxFFzOEX1I6ocWYnxIvK
   dteKPa868Lu7zs0njcn8m5z9fQoHce3UvozHF+ErSfa0bR81kX6YTL6l1
   muBuGSxEmjuZV+vexsWhHgFSO392djRx7DIGbrx3utnl7LOWaaqGQnH7N
   wvHzLoTFdC61qRwWHJnivRJOIN06cE/qqGcZk29abMRfILQpVDqf99oK5
   g==;
X-CSE-ConnectionGUID: FOEmmmd7TDe5E0cP/SYx+A==
X-CSE-MsgGUID: 8d6ILXluQAiTWkS4Q3DJSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66559771"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66559771"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:34:21 -0800
X-CSE-ConnectionGUID: gBHOu5/ORHCgixw63Vyvfw==
X-CSE-MsgGUID: uzPFQ5ZOSk+wykLjQhuBfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="225112625"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:34:21 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:34:20 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:34:20 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.2) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:34:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehV0sKa6RFUn/Da1gxZFnglMKQDp9XnEWt1p2/IIcalFvy3BJHjFbzfgBwsAYgMbeUYIWX4niem1MlMP3KsHIXhhvSPX+FyJPUSL4w8pmmCBZREI+U7LE8NBMYBHLTq5RG6GpBeVO7EvRqjMOhQ5k3t+aqnfXc0U87+s0ctKdOG5Fmod+ZjbwBj1mKqoU+jQbl1O2A/V897Sr0b2AYRht+j4I7s4Qx0I2RQZu2zmPFagzj5JiOCtyC/Nco52C+OaMjZuYbaKGblQGCu5QqWjcXNm3KuR/DCu+dAehUen+DUKFMotQTBIu+KwAU5AE7K7wfOUCshZgWYqUocSLmWVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0M5IsRrx6+XJa+q5tMVE7mlUa6wbT5IFKeenrfAMhcg=;
 b=Rw+MscppX3scBhZnqEaAWQ2cjV1SVoxjljIcVX7mKn4V9Vwf4TGnMSPo9TfYbQ0TCO4JwvhZQJkr77vAq5KyM/NyuKOMh4ggYURr54vbxeJDxtj/RQcNB7wnr5VWG1qDQNRf0MKIlyY8vqViDgX/t2EYpuXnUvhFKAKeM77e05H4VYv1Ck5B/Qm/YKoirJQ00f7NXSq/yrT8hc75Lc5vgD2w5G4oI8OarP70gUEhhOgXBzLGl1QRTyMO6HVfh0RhqnYbk9vTia263N/DY9oqz4GCecWnbBgUdtAsfx12bwLvmSN79AzgrfvAP/uS6NyAJArMmNVpVD90fXJ2AAR58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF2B89F77E0.namprd11.prod.outlook.com (2603:10b6:518:1::d11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:34:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:34:12 +0000
Message-ID: <40858873-6cae-49e3-b3cb-065f9722b178@intel.com>
Date: Tue, 2 Dec 2025 08:34:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 32/32] x86,fs/resctrl: Update documentation for
 telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-33-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-33-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:303:86::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF2B89F77E0:EE_
X-MS-Office365-Filtering-Correlation-Id: bf923a2d-9db6-435e-80e8-08de31c0a013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVZ1ZmJUN3A2Qm5TR0tRRHY1UTZkNkRKeEI1RmRRTWJCN0hWRjYxVlpWeU5W?=
 =?utf-8?B?b3A2QjRCTkNLYU1iTm5mWnZNVWNYQ2dlQm5VRXRpYk14OXFyaVcrWHBvN3NO?=
 =?utf-8?B?cnBHREZlOE5Cd3VLSjdhbWp3Q1ltTW5FUGhPOEVydEhrcjA5dmVuVEUyNFd5?=
 =?utf-8?B?UmJJZERDdnlYR1Z6SWFBYzNKdWhKb0NhSWgyZFp4L2YwbmdZOFhpZFoveTZH?=
 =?utf-8?B?M3J4aVd0a3c1c0tGeFlvL3ExWlBLVUQvUHlIZitRbkNQZzVKS1l1dUU4U20y?=
 =?utf-8?B?a3llczhBWmRUYUowVmlkbmNzUTdOR2lYaGZuSGR4VFVySDhpNmlSY3g2R0lF?=
 =?utf-8?B?eXJIVHF3cG9tL1Jwa0NEZjAySG4vNFl1WmE3TWtQRmFHRTJTL0g2VytVTVAw?=
 =?utf-8?B?V3diSGpLb290VzAxaWQ3L2VWdWthRTFrRkZPbmdsb1VnQWJsS2UzY21hRnYv?=
 =?utf-8?B?TklyUmZDQ0ZaR3ZCMGVFS3V5cU9yWWpLWDdTcmVhYlpjZ3ovVldwMGJJSW5n?=
 =?utf-8?B?a0s0NFZZVWFKRXJFV1UyOWRZaEo2djZ4UnJMQ21nY29PdXlSSnhvK2ZaUTB4?=
 =?utf-8?B?K0tSN0cxdTUvYzNIWG9jd05pVkJqdXNYYm9FaUFtOVNaaGxUTE95QmVRbFIz?=
 =?utf-8?B?K0FnK292QXAvSGp2NVRZdU1jK0xZOC9pTEQ3eEdkekxBaEtkb3RZWFFTTWJn?=
 =?utf-8?B?Z0VjMU41d3lYSC9GSHhBb1ZDaXdiNmluQ3QxbDlOOGVuREdNcVdHaDV3NHc5?=
 =?utf-8?B?Z1VsTFRoYVNjTi9EdkU1WVd4S01sdE8zVExqRnFKaGZpYUtybjV1Q0ZlU095?=
 =?utf-8?B?dEFzTHVISzBjM1U2Z2FnT0tTcGlncEpodldGbG1nTERDZ0pWODNxVDU2cDNH?=
 =?utf-8?B?ZVd3ZVRaaEV3QlVoWWpPOTZXMWRUdnJIbXFmZVliUml5SWFwdXZ1cWFMV21j?=
 =?utf-8?B?bUE5RUNRdzFHdXpTSmcvdnNGZG9jYkJyd2VwOUU0TFJLZHpLNUZlejZ2MW1U?=
 =?utf-8?B?RXNGQWJMS2lBcExzKzh6QW8yQ1VEY3FrLzFrMldIdWdpaXh0QUgycTd3YkhX?=
 =?utf-8?B?TFcvRGw2bVREdnRxMkZ6NW9tOFdsUDNjNDFOd3Y4bTBXak1LajBvTGVMemVj?=
 =?utf-8?B?YjA5RW5FZU5sWUwvZ09jZUoxRUF6blk0Ly9wbnhtSmg5WE5UYkZpMzl6ank2?=
 =?utf-8?B?VFV0NmVCWkxEbWxidjFHMkJSYkNiMnFPemFVV2hqWW81VlBmSVhJdldKdjNN?=
 =?utf-8?B?ZTBkVFE0OFhkMlVhRDVxS1JWaE1kb1BOZ2xCQlBicGdjTGhlMFhSVkYrdnVO?=
 =?utf-8?B?Vm8vU29uQUhSQ1duSnZuZkdER1JSSEV3WGhSTTdhOHJUL2hNK2xHZ2FHTjRq?=
 =?utf-8?B?RmlSTzVjQmF1Znllc2VscDBISUxncDN2KzdaMkRjQ2ZrVVAvYVdEdm5zK3l1?=
 =?utf-8?B?VkpSQWpBUWtJSFBCdTdTdUFFNmlKeHgvTHA0azhPRE5DQndOdEtuTkdqanVn?=
 =?utf-8?B?YklMWXh6NytRWk0weERpaXYrWmdJVWphVHBvUk5zdzlqelZpVWJqTzJUUEVj?=
 =?utf-8?B?ZnRWVVdleXlwMTBXUGVKOVdWUlNJT09tTVAxSjNKVGFwaE5oMnF5R0NrVmtv?=
 =?utf-8?B?S0ljVzhvR3hYY0l4Wk5sVWZWUGNYRGJ5OVVzdDRmUnA0SWNKT3NyVGhDQVVF?=
 =?utf-8?B?UG8wb3ZldW0xUXM3UVhqWEF2RlFOZ3hxV1NuT2Y1QnRCUU1oTXRyemx1aXBn?=
 =?utf-8?B?TzhOU2s3QnRXMmZFcHh3ZXJJSnFhMjAraXlCSS9BMVZEanBaR04zZmlxTkpJ?=
 =?utf-8?B?cVptM2NFNVJOZXRiZDExR1d4eFdPblQrcVRzYm1CZGwvcVFuQ3JyMFNnOVFi?=
 =?utf-8?B?UFRQRVdUMm1vZGR3VDZ2cEdnWDlCWG93dEVqd1BhMEN6QjVtZmljR1lkeXR5?=
 =?utf-8?Q?e0FlUhm++PLfxV1j14nQlJ8tTnp5W65d?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3plVVlLSE12V2E5Z2Ryd1M1cENjTXhMbmNubzdITU54dk40NTJmUU1EMmll?=
 =?utf-8?B?Z0NITUloaWtpanVKbTIvV0F4QjlvQmg2ZmRnU1hjVDZ0SGRSVFVaMGlnTUxv?=
 =?utf-8?B?QjdSMUpYTWUyWFZicmVSMEEvZC8raEo3Z3k3ODB1Z21MaUx2b2Y4V2U0dTVv?=
 =?utf-8?B?Ykg3dXNGVXFmdU9LTEptN1ZVTXZkWGJaU05jQi9lNkF6YjBUS2ZwK2p3RzMx?=
 =?utf-8?B?Nllob0JIQkdRTUFIWWJlVU83LzR6U1pGUE1MTzhlL3RDMFltc1ZSZkQvaUxU?=
 =?utf-8?B?QWpHOGpHMUN3akkxZ0orSHY5QUVUdnhkVFFXdlJ1RkRlZVNtdmVyMWh6a3Qr?=
 =?utf-8?B?MHdKMjdwWFRYZkNlWkRoaGxuVUZMODkrM3FMenB0TmRTUVY0Mm9tSkNINWgz?=
 =?utf-8?B?bjk3dXR4dzFjaDZWTFdCcjBLWW5BMFI0NGRPZXRzMmRhL0ZxMUFhQWhnNnpp?=
 =?utf-8?B?RkdMdlNOYS8wSTl5OGhTYno0bi9jYURBczkxWFJ6OXZtRW0zQm9XNVd1dk5L?=
 =?utf-8?B?K0dXek5pNDljSks5cWp4cmljYmp0L3VvdExuNFE1OGc3dVVvbWFoYXppOENn?=
 =?utf-8?B?ZXU2VytvREMwNjVXVDZLcUtTZTJJV1BiRzJKbXQ5VXA3L1VCUC9tMXVBYWtU?=
 =?utf-8?B?Qmp1WUQ0cmkzTitnY3JQdkNTQkJVRThkeEN0UmM1S0UxVEYvSFVWZllKYmtk?=
 =?utf-8?B?aTkwckVPQ1VZK3JuNlY4Mkl2VlA2bFhqdU16K3hpK2xEUXA3YzdZRHFFYlhG?=
 =?utf-8?B?VUFGckpBSUVkUFBocFRUdDJHWTFSemdUemdmQ0R3NjlyTUM5T2ZJNCtzSTdG?=
 =?utf-8?B?WmJDREZBVXpGUG1rcXdjcVNvb1hNQ1F5YU1VOGRtMEFsMmtzYTI3aFB3bG9N?=
 =?utf-8?B?eDhUZkE4OTFvTWJzVS9OOXFWRG5oLzV0bENQQVc4RnVRS0FHT2dDZGtoTXVm?=
 =?utf-8?B?ZGZncjV1b1RiN21IcDl2R2w3VFY4Skk0ejdFS0h5QkVYTm5wS1dvTlRPMS9C?=
 =?utf-8?B?MGZzYmxvQ000V3BIVnlRRWRsMnNEZnU1R1htTDlWeUlCV0FlcUgzWWFhSjQ4?=
 =?utf-8?B?YmhoZDVvaXlVbmczK1ZSbmI4dHZiMTBXOHZPUzMwSnhCOUZ3N2J6MDJpUDR4?=
 =?utf-8?B?dEpCZWNyQ09UdXQ0VTJUSEZHVXJiaXhKQStYelJ1N1VVVk1tK1JLRFJEcmsr?=
 =?utf-8?B?Y1FmRzdNSUtHMDZHMDNTQ1gvYy85QlJUd2kxU0ZaVVZ5b3FDNlV6SU5mcGVV?=
 =?utf-8?B?a3VQeUN3S3VmazdhT0VlNis4Rjd1YTQrcmpVRUg4My9HcUE4TmxMRTBMRGlo?=
 =?utf-8?B?Zlk3NzRHczFVZ294cWFFVzNoWEtHQUgzUHpNQ0hsRDlWVUpZRlNiaUp6SjFL?=
 =?utf-8?B?c3N0b0cwYXYyc0tyZDVjaUVxSVlxSFdHMU0wYUhpTlNJZU9IMDFGNEM2cE9j?=
 =?utf-8?B?WitTMVdJL1gxRnRqK2lYQjJORk9XenVTSS9aSzhqTzVCZGJpeW9RRklqV2tD?=
 =?utf-8?B?aTdoUzVtTXh1Q2ZxMERnb0hpRnpLcWtaRmJTT3Zac1hOL3IwUFVOUTg3bDhj?=
 =?utf-8?B?c0x3L2o2bGNlVGczdVhZS0VEN1Jpd1lUUnl0Y3RoTCsxSCtJVXVwd2lzeFpH?=
 =?utf-8?B?NmVCTE1tTzRQd3VHZWdoOEdERWoydXgwUlF3SDBkRzBOYldubW9xQ3hpOG9I?=
 =?utf-8?B?ZndVVEFIRE1xRDNiZDZRY3ZVdmtXZ2VZM1VuYmk4VHlVY0Z6QWlCTHBTVGNy?=
 =?utf-8?B?SlEzd29Rd3AzMG9xd0J5T29iN1Y0ZURYeEQ1L3VVNVhyNjV2Z000UXJlWS9L?=
 =?utf-8?B?TkZFNUMwdDBsYStjTjhsaGtPbnJpM3RkVWV2ckZLd2wwd0IwZEg1TU9lZ3I3?=
 =?utf-8?B?MVY3UU9OeFBnL0NPRW5TUllocnRaMHFWYjFBZXhQYm0wS05JMmErSlZjd2Vs?=
 =?utf-8?B?YjNzdVFzRWdlSHhiODFNdWs0ekVmMmtKaVlVUTJoanJPbWkyRnR3djRFSmlh?=
 =?utf-8?B?bndCa0FadktsVzBzd1krN0lSMzN5bFJMYk8rTCtxemJROGVuRFprTmJId01X?=
 =?utf-8?B?WFcrNEVuTVRCSldscUNiT3JOYms1SkJYOHNvYnhnZW1qUDNPUkxrak9QSTVP?=
 =?utf-8?B?UFB1dkxXOE4xOCtmYWI0Wk9DVHZ4aG1kZWxyYXFKZ3o1c0tFYnZjU2FnQk4x?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf923a2d-9db6-435e-80e8-08de31c0a013
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:34:12.3962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PfFU/LczMsjPdXo3wkk5RJ7tyCezOo+V5I+Sc5k4wlt+TRP7HRsKhS2zVGwjiYTebo1548Hj5EP4wunox0RGtPbQ2eV4STabXl+MRoPUXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2B89F77E0
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:54 AM, Tony Luck wrote:
> @@ -484,6 +483,25 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be a "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of RMIDs for telemetry monitoring events. By default,
> +		resctrl will not enable telemetry events of a particular type
> +		("perf" or "energy") if the number of RMIDs that can be tracked
> +		concurrently for that type is lower than the total number of
> +		RMIDs supported by that type. The user can force-enable each
> +		type of telemetry events with the "rdt=" boot command line
> +		option, but this may reduce the number of monitoring groups that
> +		can be created.

v14 changed implementation to no longer disable all events at level of the type.

Reinette
