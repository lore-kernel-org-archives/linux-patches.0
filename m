Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098EC32B9AA
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921664; cv=fail; b=pGBR1/0k9n9c04GFqaqZNUO16QRJy6pHafP5qc+ZX+9Dk8K3kWKbST1iGnR6dj8B8EKLcY9DBZ2cw0PWzvfVoTqMt9vBb3xkOG3UgiVU2A7PkvhPXUXWRr6Qx5fflt+rSrcdoa2mzXw83ZdaJ8rRmZV9XILOi8XKInEkeAC/wE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921664; c=relaxed/simple;
	bh=4xAtYUfIrB7jrHjLc8OsFlrt90aWdztAcfSGLQkhMBw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YGxSP2BCVTdf574VZ/mMXaaC6gbHRmfc5Cqm0WWXGRyPv+AGsqCp5LlhihWRNFG2ZDhRLHSJF8inTX5N6zlgsvrpzH25CPuJVuiO4JSi7cNPpjwV8fYNHPN4hccBqfMYi/mAg8ywEwJtLwe+apR/07YhrcEBcOyCNI4uh5Xul4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hfGNkRBO; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hfGNkRBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921661; x=1797457661;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4xAtYUfIrB7jrHjLc8OsFlrt90aWdztAcfSGLQkhMBw=;
  b=hfGNkRBO2/1ClvfW6P9pqUAR0y+tsPnjMvwO/mG8tX+GTljnSM3EePl4
   I1cdrTs3aMjaSatP6g1BHsu3M4cv62Fed71S0AiznFt+ktNaPpXHG7ORu
   W0SfHXU66R2hACHOGcMPVXoW/m+RFr5BJQWUU4T9gbl6J6XuWYyNktkvR
   Kc1fyzltN2sXLYlssZLei/H/ygw+PebJHWFuc7j3gRh1YHyaUSIxyQuZI
   VUJShtlLrBl3GAP0Yl9bZ2zpRDBeWBvn7wXWiJeX7UrP8sHdNFrbk8gF1
   EFGXP7NB177z3M3EeRBYKm3EDleUFBqp5kXZzPriRe8UuKY/6ydQumqGm
   g==;
X-CSE-ConnectionGUID: LFIqNKuuSimiul4imkNaZQ==
X-CSE-MsgGUID: TsXwRj4rTMGVwL2HgQ08+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67733926"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67733926"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:47:38 -0800
X-CSE-ConnectionGUID: /x63W0STSoWfYRMLDqGFPA==
X-CSE-MsgGUID: 1xPrwg0vR7CoaFNO+wIwnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="229198862"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:47:38 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:47:37 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:47:37 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:47:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5tc47ZpgEEovqxkS6p6Tg/abX9hLKsBo50T1sXkWQ5V2Ee7Cog8CtvrI21m1dllAANkc5XbFln25D93jbvDySV9ur/RWjtYOJXEz6Gnuv3iXUe9y2GmJO3AaRGTliwEG5o/Z2oxj4UG63XyspouaYpjawlF5xqw1U6KjCqVAgasXl8HFyUvhBxP/GYZdlVsrpxNrT+kF4FpeKHMF96r1Co37X2pXY04RE61jNaotWRHQSAKp9j0l0EE1TxRnS5BDCdTwVRo/eOyM4MSoojH5/oMVqvvqXbI0WbIdEXd+4UA8lVj9B5HDbS+Ldkc1Zo66aognsUA550LOBUmfHelQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOgJebRnLtmIrp8TUP2tuEcRy47Ymz3uieG6kWst2bI=;
 b=KS+QGujb6bq+oIlI3K07QNo0EtWW8I4TW06ock5mMAXW0xi0zwZSjuSKOXPPe7eyQUU+WJa/b/ugw2mXW/5yYEHG4GssVRx9VP5rfrH8hZypB4u3AVs6W6e0QuGl1AzHsumW49LUGsWYq3fMUVSNqED7UJhhrqXPTZEcvUiqsqhvD7xrricJiWA50rTLE05Ea0nOYQeRf5Dn7fshchjOuS9mu957ZzFUA0MhIQABfRbl7ixlR6H2HfUMobWWp4+aG9zHHLPF3hEycOmdb0+wJ3b2WLurdchevelv4RzEpGj0py04HopIiWcJZhNL0c7+dhr3f67cCliMwBP3DoorOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6100.namprd11.prod.outlook.com (2603:10b6:208:3d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 21:47:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:47:33 +0000
Message-ID: <cfd4b8aa-61d2-4535-88f5-c7370a3cb750@intel.com>
Date: Tue, 16 Dec 2025 13:47:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 19/32] x86/resctrl: Find and enable usable telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251210231413.59102-1-tony.luck@intel.com>
 <20251210231413.59102-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251210231413.59102-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0204.namprd03.prod.outlook.com
 (2603:10b6:303:b8::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6100:EE_
X-MS-Office365-Filtering-Correlation-Id: 7316562e-ec08-4a85-003d-08de3cecb820
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TTNsMlhrZUVtbW9IRm92bDdWOHBLZlpqWkhvUGpCL2JkWU42T3dIOWdwUXo0?=
 =?utf-8?B?MlZ0R0crZ3RzMGhaS2pYY0NVRUl6VzFUK2RKNktzWGxMZ1dFVGdVL1NvdGd4?=
 =?utf-8?B?YkVkTjcrVVQ1SnRRclI2ZzZoQXphL20vRk9vaDlUY2lab3FWU2Nxcm1uZnBD?=
 =?utf-8?B?TXRXMTRmZWt2bnR5eVpXV0FkVDlEK09XaVh6ZExHVWxEZ2ZMV2V5dGloa3dD?=
 =?utf-8?B?cFJuL3A0dXZNZGt6VDlRTjN0YnNKc1dEUnhPUFZGalduQ09ENTJyVmQ3bFFT?=
 =?utf-8?B?MGcvNndGTVZCb29RYVBkWlkzVElzdHAwQVFkemRQYjhRUjcrOGp4R1NrVWNv?=
 =?utf-8?B?ejFUSDZkUlhhOGpOTEJrVDBjTFQyaVF3aThkNFdKMlhMYmF3ekhzSnpTMnVk?=
 =?utf-8?B?RFA5WjVBWVJpT29UZHN6STBvMEpISDg1aFVSZU9iV0sxbVErT1d3a2hndWNo?=
 =?utf-8?B?UVREMDhQckMxakdCV0QvTDd3dENrVFRRZndTQ2RkTGwwUWFVcXpZbldNMFpW?=
 =?utf-8?B?OUpqZ0lZSWFvMEVYY29UN0E3QUE0VklrSityeVhWTVVna2pkeEt1UnJKRmQr?=
 =?utf-8?B?bXV6Qi9wR01UenUvS2tvOXo0VC9XamlCWWlTZ3dYYS9kV0R2ZHhNTWVDL3R4?=
 =?utf-8?B?RlNNZkVjSUMxMDV2RGxpZmhOYmdnWG5TN0NCbVNaVnFldnBKL2Yxa2lZcnVv?=
 =?utf-8?B?V3NxM2tRSUxuYVpiTGFOY2ZMbGNvZ3E2WHVaRVY2N2F4RzNGb0RmbXBNSzly?=
 =?utf-8?B?dVJaaGdxbUhaSkk0WUpBcmxURnVDalFNRzBrN0VsVkQ3VUc4M3ArdzFJMVdx?=
 =?utf-8?B?Ynk2TkFsWHI1TkpjTlo3R25Mc1RXWmZzQlJycDBCSFRoV1VYWlNHTGJCVWJm?=
 =?utf-8?B?ZFM4clVhNTNzQXlzd3BsVXJzWTdnUUlGWEp2c3VpRnFmUnFOU2d3R1d1QTBI?=
 =?utf-8?B?UEU3ZGtHbTlyQXhHR0t3TTRrcWFRa0tvUkJjbmVtSDNNRGhLWmlrdmgvMU5o?=
 =?utf-8?B?MUVEdStvQUw3UVNZeXR3bWZ5d3NVU1QzWnM0S2pmaHpoR0VLQ3JVK2RHaFpi?=
 =?utf-8?B?TzQyTit2UlpQS3l6SEdGYXlTYzhkOXJweG9BQkxtWGlWWVJUY050WHBjM1RT?=
 =?utf-8?B?WjluYktBdkN6QjlYMXBsMVJZaFVOQm5ycWJDRGF0clRKTVNXd29ZZW1LQXVm?=
 =?utf-8?B?a1NzcFBPUHNzRU9NdTZxeUZxS1JDVVNMeTFSK2hWSkFmMUlVeFhQRTYwSnQw?=
 =?utf-8?B?Wk1QTmFWRVQyNVhoWndOZDJ6b0hZMGRITnFrU1dyZ3VxS0VnNXZEa2lVekx6?=
 =?utf-8?B?aFZsYmlUbm1nSkJhSWxubHA1dHIrU2dPVGZldlN6d3p4OTlOMGhvN2dTUkdO?=
 =?utf-8?B?RnRkRkpNeEhLM1NIZm9SeDkxU3pwT25HV0VOM0VhWWlja01JTTNQVmw2ZG1r?=
 =?utf-8?B?Yk92M3ZzWFNSQm82Q1dHc3ByU2ZGb05pV1RxdjVnb25ZdGorVVpmTHgyc2FV?=
 =?utf-8?B?RmZFb2lsZWpPd1dXdkZ5L3l4RW01ci83b3VndTVCdHVXaE1DVnFXLzhocWZJ?=
 =?utf-8?B?YkZyUjdaUHVFZ1JGWXJzNjd5YkpJT09NdHdwdFpVNU1MeUtJS0k3Uk1mSlpp?=
 =?utf-8?B?TldpRFllWU9aV0ZPN1pzRnRJYk9tc0Y1bUM2VllYZ0RZbzdBY0xrUnlQcmwv?=
 =?utf-8?B?M2psOHJ5YS9aMWd4RFNydXk3MVNjd3FGOGFlaGM1dkMyWXZpT0YyUzRsWEdS?=
 =?utf-8?B?NGZKZG0zdDFoZU04VFhsV3hUSk9yaFduR2QzcTBoWHNGcjFnS01yVThic3dZ?=
 =?utf-8?B?SkZSNkQxWTM2OG1YaWs1STBSQ1l0bjkvRkQzTERBQ1ZYWWM4Q3ZPd2Q4NU9h?=
 =?utf-8?B?RUJCVEM2V2lyTjVVZkQrQXlPcnZMcEtoOU5aQ2ltNWJpNTEzNmpsa0cxZGpP?=
 =?utf-8?Q?qZvhHdax9Tpe4jcHstq7Uz+nVhTkbNQ5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXFacC9lMUdCWnhOejBPVmdEQk1Xb1RsNXRHVjR5cWNPRnhvUDhkN1J5ZXRa?=
 =?utf-8?B?MkwxRXFkSWVicTN1akwvbnR0a1JTNHpSVlRNZjdydU0wNlRQV3JFZGpEK2pF?=
 =?utf-8?B?UzAzU1R2dy9BRkxpbkFoUng2K3NQQjdLMnYwd0pZdHlOL3RpZm0xZEhkMWpi?=
 =?utf-8?B?d2U2MHdseFd6enhpOGl0ejY2SG1nMnNiV1JKSE4zeU9rYWNzV2dyUUFlLzNt?=
 =?utf-8?B?ZFVPejJlMUlORC9RNnIrN1FYV3AvYUtSZlBHckRBdEhTNTZBMDVJT1Q4RUQw?=
 =?utf-8?B?dVRFdFlYVWNkMzlsNDNpS0FZUEVxWk1mNHNOcjZCbW9sNnNvQk1ncTRZRmF6?=
 =?utf-8?B?a3cyS21CSzVub0NWdkwwYXk5bzMxMFdkbWNTTVlPd2dpSndXL3NCS3k5ZC9i?=
 =?utf-8?B?Ukw4UGJ0bVZ6M0Y5OUUxb213UDZPVXBxY2wvOHU1T0JFcWJIaUlhVGEva2dS?=
 =?utf-8?B?Z25GUnNwYlNmcjY3QVVNVm94ZElEN2dZNmdvU3ROckVTWkphVlQyUDNLQVBI?=
 =?utf-8?B?QTNCTEEwUVlQVS9qWE1FMEplTzNkKzFJL0hpMTNzUXJtMmV1N21vYUk0SmtE?=
 =?utf-8?B?Sm5oSmZvOU5wTGh0SHJ6UUcyMTFBNmxyQk9IdzZBaWJibmhReVNuYWhYQ1oz?=
 =?utf-8?B?dnVJd1R0ZzhmRlMvSTUrWjRGTTBYdDB6ekZITjJkRk9NYkp0NnhXVWpaUGRv?=
 =?utf-8?B?SE5tRzdQNCtNbGlURktmNktBWWFTblg2bFpXenFWZ3Y0ZDI0SHJtUnVtNFo1?=
 =?utf-8?B?TU9odXl5S0N1ckQ2U3lDekR2bjR5UUJ5TlpHejZidVhBNmptdlBMQlJnSkty?=
 =?utf-8?B?SFEwRlk3bDI4SndGYmVIbS9GNVQ3V2dNWHZKT01DTEVBdVQ4OGxteVRSY2Uw?=
 =?utf-8?B?aTZxUE9nMkg5RWd4eXhCdklPaFdIMktRN3JuWGZuSFFWNkJpY1lYZE5jcDN2?=
 =?utf-8?B?YlUreGk0Z0luei9VejBqQWkxTFFJN3MzOElxMkZjTkU2eFlGTW9NWjBWNHlC?=
 =?utf-8?B?L25MV1BNb29HOE1SY2FvMThqazVIdGlnN3hOR2NLcys4SDBIWjNjVWNkSnhv?=
 =?utf-8?B?d0pXMFV6ZEM5MlFkeDI1SFUvY0hHazB4a25xZHhsUjZkenRCbUl4L29VdGN2?=
 =?utf-8?B?YjJFbFg2b3FydFR1L2ZJNEovZjVnZzM2enlERXVpdWo3cWFYK052R3ZTcFEz?=
 =?utf-8?B?N2Z0MW4yWTQ4eEsxSmtNaHFXbHdhSWlWNHNqdEFwelBSVkpFWkhCQXlwR3M0?=
 =?utf-8?B?aFdQeUg5eG5yU0FlcXByOTU1NjE3eFM5VWNVVmdyOEhBWHpuWUxUcUV2NXZJ?=
 =?utf-8?B?VjR2eTVUNDZTeXI5YVVmK1ppVkVtb0k0SGpLdEFRVUtidkxBVjlvK1BzRHF2?=
 =?utf-8?B?ekFxMEFNd0dVY0dRR1hPQnFFVU5aNzBpUXg2R05rK0d1b1hMNXRsbEdkMzBy?=
 =?utf-8?B?QzF6MnV4RU51SjRjeG1maHBQRU1rWEhRMkkxMytHSDlqVHRjRWllM29tc0sw?=
 =?utf-8?B?RXBVR2FZY2VCU0hLOThDU2R6YUZKbzdaL1ovdnFReUhJZkNvdkdXdEVSMC9I?=
 =?utf-8?B?VytDNmhsZXRLM245WnhrazY4QmNlT0FvTExhTEZoRWxiNTBpWmx4c0VyRnRF?=
 =?utf-8?B?N0RWZTZhLzllTnp1WFFEQ3hFSEQ0c2pxOXB0cjFYQlB2ZmIrbC9aME1xZTEw?=
 =?utf-8?B?NEJHWlEwd3h4N25ldndGZTNtNnJzbE83ZE14MWJEVXhIU28ybjgwaWZOOFlU?=
 =?utf-8?B?aHd3ZTFDWWNnS1VZWVlBalRLWlFiMTBQT3FuMnZwWnJPZ0lXOXU2d1ZXZllk?=
 =?utf-8?B?em10cnRZTnk1d05JMUhBL0t4U0Z6RStIRnRPOXhpT3JXU2RwQjNuREg1V3NR?=
 =?utf-8?B?SkxCVElHMHdvVFhLOEp1SUIrVUhkS01keFRERlR5RWk4alM1YTRzTm5tU3R1?=
 =?utf-8?B?Vjl6RnFJWmRqdm03TmZCcCtacXowdE5PM0lNek4yaTEvWU43L2ZFY1ZNd1B0?=
 =?utf-8?B?Y0VpNm1hWk5vSkM4eDZyZ252NllBdFdaK3BPVVBrQXROeCtrUUNLU0U5MStn?=
 =?utf-8?B?d2N0NklVWFBHUEM4d01IQnc4UDR1ZEF3VTYyVHFTVW5peXVuNk82eUVaSElo?=
 =?utf-8?B?bDR6Y0dncTVrL1RjTUNWV05xU25JWVJWYXVnWDMvaE9Lb3QzQWs3V2l4T2I3?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7316562e-ec08-4a85-003d-08de3cecb820
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:47:33.3076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDJPeFuNWPwW/p8CxPUMU9w3HNIpwkyBncweD8VLfNZ38KfqxIS9r5J/LhDctMFkP2wVT+5C6SoeOAzc7522xy8hP9Oi2nrAreh4PfGDo7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6100
X-OriginatorOrg: intel.com

Hi Tony,

On 12/10/25 3:13 PM, Tony Luck wrote:
> Every event group has a private copy of the data of all telemetry event
> aggregators (aka "telemetry regions") tracking its feature type. Included
> may be regions that have the same feature type but tracking different guid
> from the event group's.
> 
> Traverse the event group's telemetry region data and mark all regions that
> are not usable by the event group as unusable by clearing those regions'
> MMIO addresses. A region is considered unusable if:
> 1) guid does not match the guid of the event group.
> 2) Package ID is invalid.
> 3) The enumerated size of the MMIO region does not match the expected
>    value from the XML description file.
> 
> Hereafter any telemetry region with an MMIO address is considered valid for
> the event group it is associated with.
> 
> Enable all the event group's events as long as there is at least one usable
> region from where data for its events can be read. Enabling of events
> can fail. Each event group is independent of other event groups. So even
> if no events can be enabled from one event group, keep running to enable
> other event groups.

Above describes how event groups are independent while I see the question needing
to be answered here as "Why enable an event group if one or more of its events
cannot be enabled?"

How about something like:
	Enabling of an event can fail if the same event has already been enabled as    
	part of another event group. It should never happen that the same event is      
	described by different guid supported by the same system so just WARN (via      
	resctrl_enable_mon_event()) and skip the event."   	

Can the "should" be replaced with a specific reason why this can never happen?

> 
> Note that it is architecturally possible that some telemetry events are
> only supported by a subset of the packages in the system. It is not expected
> that systems will ever do this. If they do the user will see event files in
> resctrl that always return "Unavailable".
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
