Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2BF1547C9
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 03:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755143851; cv=fail; b=a2YqeP3N1eSi+LS2HWV+cfajdHjzB6N0ZkeawqzIRGKd0DaEENj9WIMCOXyvstEHhw0CfBISwkaLCM1MYalYWWEPCc7ap4mUEgWSt7Q6n1X+h1brr2tdE6EE0ovAMPjoeM8q/6a0jusQzY9yZLAdGS/KO5dGgCaqzNmtVoiIYJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755143851; c=relaxed/simple;
	bh=5ysPZgazoFDM6gqHMgEKbJ4vZyvYvUfzSIAXoxDr0hs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nUj21/2IUVGtNKBV3U0vk6efJ4XaMo8DFyfkOgY4RGBBFmrV5brYdHNUtxtoXbCPkPJNyT6sdn/7T7sXqHcsszwSRRvCXABY0iikJNM2Eo5fzKUgEKqu/lHhQiVfYNt1oWY2kkZQVb0axnpY8+Svh3jMkjv4whYc/GzNqdgmzO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f7Wj4s51; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f7Wj4s51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755143850; x=1786679850;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ysPZgazoFDM6gqHMgEKbJ4vZyvYvUfzSIAXoxDr0hs=;
  b=f7Wj4s51mAe+dOD7msd6vc06MMVOdZKtiXjHYgxjvwYGV1vOJgv6VV2B
   Rlie71a4YE+sEz7ASGqtfejyDAd+kzVzw6rbSm3G3AL5fn+mzdVTIzsw3
   TkA/HRsdkNZZpRvwpV+0za5TDI1FVMq4oTg7AboQ2wjPzEHlyns56dc4j
   m2cfOZtAi2QyNuHNlrLZnx0XcyQ6Q6QiCi/g1JmUBROCAcjRMNb/MppgE
   NnwoapHfKCAX0gPyTL2+hLCe3TJP+6o7u95BB82PzQ9qg2omQLDbfw0LA
   Yhaz2ClglA5+cgtHFXAAgZgNO+nd2PfMZU0f8Vv6NcBQt2tHoEH/Q9zNK
   A==;
X-CSE-ConnectionGUID: CPUe6YM8SzmJWzD9rN1HaA==
X-CSE-MsgGUID: sdvW3UhcQY+YFa68RGvjuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61256911"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="61256911"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:57:23 -0700
X-CSE-ConnectionGUID: Iwcyn83eQE2Ertw5TMroLw==
X-CSE-MsgGUID: wHw1iB6KThOpgEbSY/cipA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="170855470"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:57:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 20:57:22 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 20:57:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.77)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 20:57:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9mt8Bvn+iEYHaNrjU+tI05J3rnmZJYqJFcsC8VvX/cv6WBNspOaYBfUlZO3Fi6ISj7YqXoDpTI6Y1n4fphrlbuusDAWPlFnHnJFje418fcC6KszYD7VI91iLbf79M9lc5X+hEHP+tX3f4rMwyH5tAyya/lm15VrhQpCsDeBq/DpeBfaXiC/JkwaK7oVk10esUWiKlT5E/REDEOT7Cx2Yp4+MTGqJPoJHDgk8xUIs7cq/JhFrcjQgpFKrGvUntOsS/DDwpN/JVlUNrzfz5m8AVOMUSOjcBRVOP6JZwi8rlm8q0YFMNHqwgQFxR96/iz4PpGtEU4zzg0m+5CV2hM1Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPFANkikstlHp0Tb5AJSyYAkFoli9DoZvgXEUcy6YlA=;
 b=Ul+gLPtpXPivaYtpll3VB0w75wBlvauowqexxWYGaCCObQIslD6ea2XPcNNLz7KdD7nmPN0x3NZ2Cppis5nnKy6cLpEFr+hwHTC+DavynOQvS36TiQOWkflliPuMjscuqUQBTJyz24xpeMg8sd7OcoQHUxPWT3eDmIs6AtPprUSMRIjYmdUm4a0QKT6MzNguTxLqz2z48f0AkZRaUFYyR1RyPLuMiWihdJPi96cECqfHttPSJj0wEdB8Ol+Ty9zcPyiPBTft8Lf7awDGR8eX7apBy2FeRa8cOsSfbIJn+krUKzT/Xp2M4i/B9aEJADJ8qKRgSckey5YaB7yPkty0wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5198.namprd11.prod.outlook.com (2603:10b6:a03:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 03:57:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 03:57:20 +0000
Message-ID: <2e0cdccc-ed1e-4bcb-8bd7-b0274609928c@intel.com>
Date: Wed, 13 Aug 2025 20:57:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/32] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e8bdfe5-14a8-4de1-9334-08dddae6aaf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Rkdwa0VzTmtqT2tYWWFJNVBOc1JWd2dzeDYwMW1CTkNwQU9xM2dtaFh1SE1E?=
 =?utf-8?B?dGpvT00xNTlJS04rN3JCeG9yUTU1UWZGUkNiSXgzMGlza09wYlZyRXo5NDRt?=
 =?utf-8?B?STByaEJrRGFvaFY0N0lIYk1NVVdtQm50aFJZS3BYOC84RXljajZodEQzSklP?=
 =?utf-8?B?U0Z1bG9sNjlvZ1U4QzRscUNlbndVUWlMc294QURxRExRN2hQb2FQN1g0WHla?=
 =?utf-8?B?NDA4bjNJZ0FUTnczdWU1TmhWNm84Rm5aUXIvbEFiSEZYNk9zOVFHU3Nmd3ZH?=
 =?utf-8?B?RC9tajBrOFJUN2JIcG1QWGlnSmhidk5WN25nVGFpNkFyWVAwVmlTOTBjTkVy?=
 =?utf-8?B?KzBhMm5zbjY5eGlxN0xEZFBsOWJpSHBIdGRLU0N2eU1SZnhFY2dNVHVuVFE2?=
 =?utf-8?B?dzJjZGNxY05yL1R4d3NtQnBCNVFnV3p5S0JTU0srak9wNTFIK3gyK1h0RStM?=
 =?utf-8?B?OG0vbVEyL2JLbEljR21xS1BQMitqVUJPTEZYQjlRVnZPQTFwSFlqY0wyU0c4?=
 =?utf-8?B?V2tNWWtmS1NhSHExLzVDTXdyY2NPTndNWFF3NWNySERTR0IrNDMrUXIvbWxy?=
 =?utf-8?B?M2JxdjMwUHdpeGlsL1NXVEJHa3NBWUxBUVo2TGVycm5zU0lMVGJ6VHJFYlZL?=
 =?utf-8?B?OCtOWGZvTkIwMk9zVFdDZzY0Q2Z0TTZRMkJTYVU1ZG9NdmZ1OVhjZHh2eDIw?=
 =?utf-8?B?Mk5GbXdYQTh1TkRYcE9ZajVpelVyWEpSREJrZzc1ZjZUdW1uTDlZeEpLS1Nx?=
 =?utf-8?B?U0lsUnBTS21GcnpnL3JSYjhCTFBjakhjVXNkR2xTbEJsZ3VRVWU0RmxsWUQ5?=
 =?utf-8?B?ZWQwQzZJVWF3UDV6TlRWV0dSTndBRE9RTmc3ZVNtazZMVnd4WTU3VnFwL3My?=
 =?utf-8?B?akJnQnBUY3NRNzBiZkIxNEQvOHdZRnQyVGNMbjZsNzYrM3ZGNDdONnByVENS?=
 =?utf-8?B?S2tWY0F1Rk1EMWdpOFRQTGlTcjVUV0lIVXZobDZ3SE5YcHdmVm55Vi9iaUJa?=
 =?utf-8?B?NlBRbjdZZW9neitYY25wSk90TnZNVkJ4ekY0NktRUm9iZUdXSEtralJMbTdQ?=
 =?utf-8?B?L2NsQ2trSUpCRHFLcWxsWTRNU1paT0xuUU5zK3pQZ20zcERodExlQWh4Rll6?=
 =?utf-8?B?ZldRQkw1Y3NHbEZQc3JCT25BcTM2T2I0OTI1TXdDZXEzZmhJZmFleWdsWGZ5?=
 =?utf-8?B?YWk2bE5HdXpwY0dKTFJlWGpqQjRWeUlGRGcyVThCNVJ1c1d1dFQ3UmpZZzkx?=
 =?utf-8?B?L0VvNytMbVdSWm8vTWZ3ckE4KytkMUN5b0Q0WW1GTmQxSTRlN0YyditRSExV?=
 =?utf-8?B?Nm1kbjFrVzNWZW5sYnR3WG9lUnh0MlRVK0hUT2VIKzZhSWMvZDVYV3cwenIx?=
 =?utf-8?B?WFljeEJaOHNMdFlkdGdNeFE5ZnViVGJyRUUrZEc2dkpUd2ovK29CQ29aYTJm?=
 =?utf-8?B?cHducklNYmQ5VnUveE9GTURBYTBxbEhBb09XTHJBSnpPaUQ0VW8xc3hwak00?=
 =?utf-8?B?VHNLbXJ5RFhYNG1mZGZtUEZ3dXpiVWpGcFNJemJtbGgwTkhjTko4d1MxbUJM?=
 =?utf-8?B?SnM2V2k1Zzd4elRYdlpmZjFodUhOYTRobWtUZ2I0aEg2c3Y4VGVqVXRBVzl0?=
 =?utf-8?B?REhVSXROcXVydWhRYTZ0dmhjWEJuckhPSGxhUERCK212UGRSbEZQMktqUEJ4?=
 =?utf-8?B?OU5NcVdMdXNvQlNjb3JrbElKYnN2QkxDUTlKdEowSDloZTBKOHJuVDQrUU9t?=
 =?utf-8?B?TzJMeWczRGFzc09jTlVCK1NsMnh1RmdRdkJzNktkVlVnQ3NIa1NMZlphdGM3?=
 =?utf-8?B?amxkT3dHU2NoRlgwaEMrK2JXWE9IRkk1UGdwNmVNOFNGUzN3akh4VG5taWpR?=
 =?utf-8?B?Qmx4ZmFVcE9zRnVEbERucE95ZWpSWUhFWVRnbFV0aEY2S053cHlyTWlSZjNY?=
 =?utf-8?B?QXR2RXBOYXF0QnNLMkJydUFtMlNhZktoQWxlL3pnUGpqTjE0S1F1SDJoaTR4?=
 =?utf-8?B?V2phSTBJcmJRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmFsa1g0cU1WWUtUanB1TU9uTDdvNzh5aUtES01JZUpyKzV2ckUzTkFHWkFy?=
 =?utf-8?B?dkRqQkFVczhkMWVnOFNOUGZBdzYwaXFOTkpOM2NZVzNwdUJCNlAvN21NaytQ?=
 =?utf-8?B?V1BqVm5Iek5qcHIvSWhzRE1YSWtmRzFwSEFneDF5M2hQZ2p5RStnSXR3N3dK?=
 =?utf-8?B?OXNvODNjUWZZSUZqa2FJMHNxMVdLaGJqZHRqUjNJV0NJd1Z4UnVVNDVsc1M5?=
 =?utf-8?B?RlpKbTkwc0lpanphTGtIM291dm1sc245R0NJWmFWQTFQOUtKakZiQkR2UkR4?=
 =?utf-8?B?RFcrZkY0Uzl4cDBKaWpHcDJxT3Bmcldid0JQRGhlMzBaRUQ3dUFxVTluRldj?=
 =?utf-8?B?OUYzMVZoNGZRQ0RMM1FjRGEyVFZEWXF6RjJXSlZSWmx4L3BvQXhXZGJjVkNM?=
 =?utf-8?B?VTVFUzVkTmhrQmdRYkMvWU1mbkhseElvSnFoUGtTZUhsSEtRZFowV1o2VkNX?=
 =?utf-8?B?NW5kb0FaSXZNSlk3ZVZDV1U2dXBjSjcyelUzZkZ4cFB3U2YwQkh3bDNCYnpt?=
 =?utf-8?B?bHRNVUFZRFdEYnNHVVI3ak5keUR2TjY0Vnh1RStFUkpCamVxbWV2M0Fzamlu?=
 =?utf-8?B?NW1YMkhVbmlYZW1sTy9kMXBmY0VBZ2tmR0xlTHhmVjhRMkdTOC9Nbm1tWG1R?=
 =?utf-8?B?N0hLb1BsWUNRMmVhdWtMR25YaXUySml6MHpBZXpkUkhPTkNCLzZlVHh2UVU2?=
 =?utf-8?B?WnJNTmFrUnhDeDBmUm1IT0lVT3Q2SHlCZjRTYVVCSEh2ZWdIc0tNU1RVSmZu?=
 =?utf-8?B?ZVNQeHhRNWc2V0pRWUxKeFVZdWZnLzVwOXRaN3hYTkNXOGh3YnF1QjVMNlYw?=
 =?utf-8?B?MWFsTmt1U2U2TXhZKzRkeWdPcnlCb2hGNUVUSUgxdFZLdE5wdkVDSWdmaXo1?=
 =?utf-8?B?TmZtdUpyUEQ1WjIxUEE3czRxQlM2c2RsdkVJeFdMd091RlMrYVRvWUhFNjlw?=
 =?utf-8?B?cnRhOWpFNWtBUWx4YXo1cW9XZzZmM1cvbno4SmhibGpUTGFCZzM5RGtVbHdw?=
 =?utf-8?B?cXdWUG1NSlBaSVY5N1lMbTRmSVRnbTQyaWtQY0lhVFFSTXAzR1A1K01sYWo1?=
 =?utf-8?B?bkUxeWUxVnAxb3dGUUhXWmdzd0JUdVNqMmZEb0RjZmxVaHVISFg2RUM2T1d5?=
 =?utf-8?B?bGc5TXEzTkxENFRxNjRPd2xzVlVUd1VBTkVtazZmektPempZUG5VcUpQZVNG?=
 =?utf-8?B?MjlmbUFEUmdPUGZKdlNJTDVFaU1jYkdZcCtnUFFuOVZWVUIxV25OaDlTKzVi?=
 =?utf-8?B?M0xkV3VQL2dxMzVQWU8yV051L2k4K24zTk1LY1RNMmRDMHUyZWxXUUh6cGpP?=
 =?utf-8?B?R1FuOTltMVRwamhnc0RzSjM3RkoyT3NUK3grc0ZYenJLNGYvYkJkMXdNM2lu?=
 =?utf-8?B?VUoxaTUyb05BRkk4Z01DRm55cEsrSkJLNlpOeStZN1VQcjZSQ29hR0M0WGJi?=
 =?utf-8?B?QjA1eXlZSVhhV0FsNjNZaHZ5cFBSMkV0VzJrbk1WSmpqelg2TnlSYmVhK2tt?=
 =?utf-8?B?ZkNUZnF3ZFJxdjNwZGlLMDJGRVZqTmNOZWdLaUsyejJNeW9GdmlkQUVGTERM?=
 =?utf-8?B?MjAxcFVEbERoYnJweFlpSHl3Tk9OeWZWeUlhTlJxSFZvOE0vclhxb3Jla2pm?=
 =?utf-8?B?N25oaE9UT0VIVHFGRkp6aFRrV1l1SDZ0SkZIMG5HNURkNjRiVlNuT3YzaHVm?=
 =?utf-8?B?NTRWbUV6VlJjUlA0ZTlLK2RCc0JzK2RMby9POGZ2czZsaDZ2S2dpODcrWk51?=
 =?utf-8?B?Rlhrbm5KRkljUzNNYXl3ZXI5Mmx4cDZRZ0k1ZldvQzFHYThkWTllTmFVVVZD?=
 =?utf-8?B?M1Flak9aaW5zM3lUSmR1UCs4S0pqdGJLNFlYZ0ZSTUZFRVJ3YzUvVW9wcE5V?=
 =?utf-8?B?QytpbzZiSnhUZlpNNmVydzVVenNkS1VUNzk5Zi9iVFZUczhLTGphNWtrdmRI?=
 =?utf-8?B?RXNKSjZWUlZ6dm9ZM1dNVnNrRk9Ibnk0ZDZlelFNRHRWL0tUbU5VNXVFRjlL?=
 =?utf-8?B?cWZjSEx3d3orc3VKeldTSm5jNkJndFE1UzR3VGd3Z256SG9WQW5RMWZHbEZn?=
 =?utf-8?B?Z2xTWVRKdGpmcjFpTGRTMUpqeG41UTdRWFV4OGlvRG5QNGNadWVENFpSdlJN?=
 =?utf-8?B?ZFdMZCs4WW1ZdnF5VlR2UlA0ZnFDYTI5d0xHT0pPbDBObnMzcUhuK1RkVTN6?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8bdfe5-14a8-4de1-9334-08dddae6aaf7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 03:57:20.2984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwhECfO6HX/AMCEweaI0jjDwFeoFhoEyqK6PRxPJ9J2RuNxaYbfZrCmkMhNBs8oKleidcSnJ5STUV6LOovI54SII1gWQY68Tx/U8gaYOqfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5198
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> The rdt_domain_hdr structure is used in both control and monitor
> domain structures to provide common methods for operations such as
> adding a CPU to a domain, removing a CPU from a domain, accessing
> the mask of all CPUs in a domain.
> 
> The "type" field provides a simple check whether a domain is a

"The "type" field provides" -> "rdt_domain_hdr::type provides"

> control or monitor domain so that programming errors operating
> on domains will be quickly caught. This is insufficient to
> catch errors when other resources besides L3 support monitor
> events.
> 
> Add a new rdt_domain_hdr::rid field that is initialized when domain
> structures are allocated. Call domain_header_is_valid() to sanity

Needs imperative. For example (please feel free to improve ... this
and any other suggestion I may have):
"Add rdt_domain_hdr::rid to contain the resource id and initialize it
as part of domain structure allocation done by CPU online handler. Call ..."

> check both the type and resource id before using container_of()
> to get a pointer to the associated domain.
> 

(sidenote: The last sentence above is very important since it
establishes a requirement that domain_header_is_valid() should always
be used before container_of(). This does not seem to be consistently
followed by this series. I will point out the ones I noticed, please
double check the final result to confirm that this pattern is
consistently used as intended.)

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

