Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E53E1E0B86
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438247; cv=fail; b=ky89f3oBm7fk1Rhu0CsuEtFPsVpm3QKjibbRMYgmzGkVIm+/RonMKeH1QVDX5HxsYM2Nt1U6oAj//MG24zQeC29BUvs1KCbhjp3eNSqzXLb4J6tc0895lrCQZCI8GiNso0y0qsYJmOIs+Bxm2FlSlKgLpVQGy+f0DnbJUJmxNSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438247; c=relaxed/simple;
	bh=d+WmL2d1khpFv1hIIgPRDqa8L0tXW+vNsL3RC/3BccY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jp83YMqftMe8qcx//yQdRgtW7NXhAA2spU0nQjhtUy9dkMdPnmHe6RYuHVy631Zpr3bfppOXMTfH7SJ6MC1PODhWeESAqWgrYrmHaDBYw4fO7BVDrVhnNOaAbxAupLzKWcaQDv1JfIbeld3ur7iQ7L87ZDu4cwe7i/zvT/W8Qzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFUzem/J; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFUzem/J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743438246; x=1774974246;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d+WmL2d1khpFv1hIIgPRDqa8L0tXW+vNsL3RC/3BccY=;
  b=KFUzem/JTk3VDLjASvkTtyNRLnXIrXR5+Rjx661R1TJDZEOlh9ON2y31
   XAcAVxg6feGaGkjFibCys6rKs89d7+ES3HwbzAXc0LBszhjakIU7MsnTG
   jqtKJXlmpS6hwORFB9A92gFOS+TIAPY4WDaRWxs1I4jUu7sACY6sqS7XD
   JM3aCdcnNEWhmML9Fwtl4KnTRgbMyheGK5WXGXhwffRqdGmJR4WlB0vIE
   l8SHqNz8s4coMCHAzkV2h0fTRZU9zFWsVy9gwBCT8+TabjfjdBiW7HTRm
   XoFAbwDmgRhUtUgwdKiXPSkfevJ2ilFzlXvP6wT6MUV7WoEtsip0WAje3
   Q==;
X-CSE-ConnectionGUID: RVtaBw2wTNiSP0x1VmFgjw==
X-CSE-MsgGUID: DhE8cUTNTciOIpohrIqliA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="62266611"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="62266611"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:23:54 -0700
X-CSE-ConnectionGUID: CVCDQ5zRTRS9kahbVMsWHw==
X-CSE-MsgGUID: 8YYKx2bdSQGyUUpPdAcHFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="157128318"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Mar 2025 09:23:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 31 Mar 2025 09:23:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:23:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:23:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRXwr27Qzp1EXlpJFULy6MmX4qh1y4cEcdcKbZ9z4iVQH944/7/u6V+rOBPgca7zGnXYH9sKAA3yPdExjl7E6MjG9UmcSoKEe5h6ZLgRfmD6Rsymyl4nNECTW5PGjjJuJYj3Q+hfk3RzX5WPa7SqE+wcvQPbRETeWaSsYb0n0xo6JTS4MlR9d/jzGCWt+K29A2p6Ol2J+SUPvOpgLl/dmBQgPOrud3EhtD9+eHyJ/fGmu8EocCXl4+9QJ7RCZOTmerTwUBodAvErDbioslV/pNr55Wpnmh2PtzAKmJE0R52uhNMcYST7QnlO3XwHkJVMf7U32DrmfgaGHR28EUhPBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1Lbjzlqj2sRtWZUXURi7jxFerAWGTtSdZYroqCzDFE=;
 b=h3nZvWx+RKLwmLu+vdKLFWXsYTIQjVyEJ7tvkkpk1tJ+AITrdtTPV+ggJmBJEw36HsKKad6tC6oKFrfRstrP3XWjtzSbL649YvwZEcIrHLHuVkozqzH9swOMhwgSLSCKmqD7w3pCLsOwgTkKlWrHfDKzQtsYE7h+6yXD/uFWL6fRBtZIyMer4XpVAk6Tkb3vwrZMUIhcva3cVLdwf1AQtDKAtOADAdZ1H8kXuZGrVexow3aVTIPRdhy1O3psBM7PjyNuccUBg9uzDWfYj9FD8fApFarlFqA+O28ZD/BiH3oOt3SZrO/BiV8qUr6BfJ4bR+Pv4GrlIpAZd0CmsHBNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6440.namprd11.prod.outlook.com (2603:10b6:930:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:23:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:23:50 +0000
Message-ID: <bb1ceb6c-e855-41c6-b15b-cf3eeafd7da8@intel.com>
Date: Mon, 31 Mar 2025 09:23:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/16] x86/resctrl: Add code to display core telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0280.namprd04.prod.outlook.com
 (2603:10b6:303:89::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cec9f5b-7969-4a12-7e60-08dd70706bbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXlZUEFaYU0wMzRjTitCcVBUenI1MWxwNTh0L0E5aitaZWs2KzRKaXpGOW5v?=
 =?utf-8?B?WERKMkxnQmRaZ0hzL0hMUTlyMnhNOEoycmNTQklXVC9BZ3JWTTI4WFpSc0pN?=
 =?utf-8?B?bzk5L3dTcGJKcEVPNnVZSEVxRXhtSDF2WTI4MGRnRGd5NVZENGppU0VnMHl3?=
 =?utf-8?B?SFluMVJIQkJoZWFGQ2xTRXZObWxSWjFvQTh6NDNLR0tvYXNCZmF4Z0NmVmc0?=
 =?utf-8?B?NXNHUlNVVnBSMGNVNUVzS2h4dWhGQm1kS212TUFPOXcxL0tNVG1yWi9mMmxP?=
 =?utf-8?B?S29zTGtDTWRkd1lZOThKQzFNSHBKMkY0MU5uU003a3pMcVhmb3A4aVJETmFO?=
 =?utf-8?B?bmFkQVYyQjJUc1V4WWdIdFVGM3dmZlF6eDdlVExXVG1GeXE3dnBCYUlOS0h0?=
 =?utf-8?B?T1drUnhkYm9LZHZVOXBVbU51UTVhY0pHckZFZ1A5TVdNYXBVdUhjamh3Z0ND?=
 =?utf-8?B?c2ltaVVKUjQ1azJzV0R4UlVva0piYlVNNFR0N1VuMDJZelF4SzExZkRxRmlq?=
 =?utf-8?B?bFZnbk1pQUhyV2ZSLzFieTgvWXNsWENUb2JIOEo4M1lOQnZ3djZrb2ZCVEZS?=
 =?utf-8?B?NkZSMERpUnBoNWZiejFGb08zVXZhY1VJTXlZRXJLM2NZQWU0WU12K0tlQjFL?=
 =?utf-8?B?bStLOGx2TjZ6UUZlTm51czd1dzlQWkFPaThNQnNkRGpuU1ltcTM2aXVFOUh4?=
 =?utf-8?B?TWdGVGlTZVovTGJtK3oyQmZ3WUU3b2pQd3FXSVlmUEFwRHdOSlRzakg0K1hm?=
 =?utf-8?B?V0I3WG1tZlJkRkZRNTh5N0plVzJNSUVIU0pBYmlldDJzUjNpNnhqUkFMSzdB?=
 =?utf-8?B?bEsvT3ZPS1Zpd3RxMjBRWkRjdXBRMkFjMXVXdDZRZlkycThwQWNSL01ERjRC?=
 =?utf-8?B?WFFudEg5SG96cllxYlFJQW85RUVNRGM2TnRoVGFQbzhBWENURDYySzI3dEd0?=
 =?utf-8?B?Rm8vMUZaSnUzMXNoMlZiK3o5OXRJbUMrTVBRVzFhRzQrbWhZWmRFaGtvcGxu?=
 =?utf-8?B?ZklvZjZ0WjdZMWdYd0x0akJKeWRDYkpBb1MxaHRuMjRTZlkzNERtdnEzVEpK?=
 =?utf-8?B?VTh6ZkdKa2g2U3V2S1ZtUlEwSzR3TGZEcm9ic1RxaGlIN3h0S3VtZFp6dG1z?=
 =?utf-8?B?MmdMSHNtNmJjbnFuMy8yQ3lKaWpWZUozaGpUWW9zTFQrY1F5UWNoMzV5RjBX?=
 =?utf-8?B?VWVZVTRGMVF1Rko2SlNXN201UVoybkY0TERKVDdQRUk1bzhxM1ZRcFpDbzly?=
 =?utf-8?B?R1oxazFDaUNnMzZZbm42RTc4NHpNT0s2Y3RTSUtHUXZhbzA1T1VLT2VQOHlr?=
 =?utf-8?B?cElQakdmWHRsZ0g1NmU0VTdsLy9MeEJkckdYbmZCNUg1aWV1SS94aFd0UkNS?=
 =?utf-8?B?MXVXd0xLajFrNUNPTW4xSXdQQ2xMbzZNRFdXc3d0aTE5VFpQNG5yZThMaUZ1?=
 =?utf-8?B?TGlSUkN4TGpoa1grQ01ySHZlRFdZNXVRM2xIWSt6cUdJNEdrTEpMRFE1K1Bm?=
 =?utf-8?B?RHlIVGJyNndHSWN5T0dNTFphcXlpVU9Oa0p0NEJWb0VaZXIxcWFWczZ1WlJq?=
 =?utf-8?B?UzdIVFRNMHlTcWdGQVh1bnREMGIrdks2S1NldHZHMVcxQnZSRGlKRm9CdUY5?=
 =?utf-8?B?ZlZDUllFaGpwT1ZieW53WjhtWEpMY3J5UmpKamU4bGh0QktHMjFMUHBuMVB0?=
 =?utf-8?B?ZENGcU9HUUF5OWdNTW9jUlZoaGlwOXlmNFpRTnZocVI2a216RkRFQjNSNHN0?=
 =?utf-8?B?RjZJVFozS29QMWZBNG9nc0JQV3dNSGV4anlyb3pJQ2YwdlNlQkphbHVkQWhK?=
 =?utf-8?B?VFBpMjV2VCtadFcwWVdMMkNBeGdEM2MwRXYrTTJJa2poNGg1MURCbDNtdzJQ?=
 =?utf-8?Q?XJctwmOQJkNna?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODlOM3pseHFxYjZXK0ZtcHN2VmpNcnEvcENZc1hEeVFKTi9qNVhWRUJMUDBY?=
 =?utf-8?B?d0o1dXA0enhzVnIrUTJndCttOHNOOWhrazhXTS9YQzR5QmhBM3podUdOSnFG?=
 =?utf-8?B?eUU1c2NjdjgveitPMzhJRzMzdWVXakFVN1NmRGIyMWx5MFdtZmJpVkRyOHh6?=
 =?utf-8?B?MXIwN2NGZXpCRk90bGhtU3JKcmRCZnhWMnZnVmdzZTIzZTMxaU1CQ0pHQzM5?=
 =?utf-8?B?ZXh5Wis4eDk3LzVMaUhLbVdqbDlJSHhkVlVqYmpTM1krUThNcGRWa3BTUng5?=
 =?utf-8?B?VDJ3OW44WnNET0t6SmVMbkNLRWtzSTlvekdEbDZ0eEJwY3hSUHBJSmtRdmZS?=
 =?utf-8?B?bmROcnJjS1lSQnRyd0h4NzNhU2tWOXNuTXIvVytGQThBL28xb2hld2R6SXJH?=
 =?utf-8?B?dUkyZ2grOG9zUWhRUDZYSFJFSldncXdSNE13eGp2bUtIdEFIOGV2c1BuRWlV?=
 =?utf-8?B?K0REbmtWSUNyMm91dUhPVXUyNXdYVkxRRmd6LzNlWjdKd2trRnc0aDd3WURv?=
 =?utf-8?B?T05IbHpkVnp4eElsZnU0K3VHZnBDTnRURXhQN0lheVJDTmtjaDM5bzRPb2dG?=
 =?utf-8?B?NEdVT09UMVhacWJxT3diUThLRXZrSmRMelR0Nm0rRUlXK0c3VUZrbko0WVoy?=
 =?utf-8?B?TzEyWjBhcVB4cUxFZXg3ZjFYc3RQNU1GNXFsSmpFbHJjVVlraVRNdVpRSjB4?=
 =?utf-8?B?VndhcFA2cHMxUjJaRWZwWXU4aW1ONGR1RGJieFFpdGhsZklsc0lSQVhReE9X?=
 =?utf-8?B?ei83WkZrZjErQkdsaWNMa0tGeUFXMlhDYlVyaDJ1NDNtSlp6a0VIdTQyT3NJ?=
 =?utf-8?B?azhXa08xbnd0d1hUd21CL2FmbkZyRGpIbG03ZmUxbEZYeTMrU01TWVdDTnRx?=
 =?utf-8?B?N0MxTENvdGx6Y1p5Zm9SeGthcHdPcktSRVI3eFRENFlRc0FEZ3UvYUlqc2d4?=
 =?utf-8?B?aERIN0dsL08xQW1EdWxRbCtjQlh3bCtzbFpzRHE3ckpoWlBJMFZOaU1vZW9V?=
 =?utf-8?B?WUMvUjd5eVJaNTgxaGRWSWh2Zm5BSEliMlE0Q2xtL015bzl0OU14N0VaLytm?=
 =?utf-8?B?aXRyOTZ5dDNuUktoT0JMVkhobFZpazJnRDhDYVhHOS9OQ1BXblRaN0srOUVX?=
 =?utf-8?B?em1ZMVNNRHZKaUh0RkhwM1pVekNwbjJ3STJ0Mys0VGUzUFkwOW0ySWdHbmZ3?=
 =?utf-8?B?RTFDcjkyYU1vVlZoSTlUaXkyVTdZcE1vcVNrT05hbXBVdTRRNnR0V2pCZ2xz?=
 =?utf-8?B?dEZpUXBCamVITi9xN3ErOVZsbW8rb2RaNElqU0UwUThnODcxRTk0NXRmWHN0?=
 =?utf-8?B?UVVRTEYzRm5XMysrcmJKOXdDSU0vL0VmSkxYUFVRazhIR25iMjJUYlYySDdi?=
 =?utf-8?B?SEtxN3FUMjBNaGl3cXhtUTRzY05QdGhGek1GOUVjOVJnZWEvdUtkdnR3cGNI?=
 =?utf-8?B?MVBZVWRoLzFjU1F5djh5TlNXZUlzTTdTaFB2Qjd0T1JFaWJCRlNmd1N1Uzh0?=
 =?utf-8?B?MlcwVUIvcldXdTlpOXpGV09FUnY1d3hObUc2T1JSSWVKSUF6MTJnUVhzOGdP?=
 =?utf-8?B?dC9xeTU0SDNYZzJlS3M1OEljakFaa3VkZWg4RmdlZkYrUkNUWVRadlA4Tm4x?=
 =?utf-8?B?R0cwT0ZhT0ZNNW4xUlg5WStkcEsyN2VsVmo2cUxvNVRXNUx0TjZsejQvbXZp?=
 =?utf-8?B?RTlHQkVoZHdhbnhLdGh0bmZGY0YzWmIzWU10SDZZeEJWWmk1bVpPWDdqY1VM?=
 =?utf-8?B?dGprL0FTS0VWQ082MkFJVjQ2ZFN6L3ZTY2JEY1dIMzFhbXdSMXNENlRsSVFH?=
 =?utf-8?B?M1YwbkMvbjczb3l6UWQ4N2FuaGwwV01IU2ZtT05mQ2pWSGZrVnZXdWtESFN3?=
 =?utf-8?B?M2pLclBFQTZlYk1XZExKcnYrRlYwTWl2NVorbSs5ZHZJMVArbkk1TVd1Mmh1?=
 =?utf-8?B?UFp1ZE1SUWsvdEhEOGVocDNlTGpPMDl2RlpSbEdmZ1ZabW9jaHQ5TUJ6eDA5?=
 =?utf-8?B?M1dZTGw5WU9xVXMwUENiSGdLajAvbStPUkhWdk9ldlhidTNXL2tMYVUwVkpm?=
 =?utf-8?B?Smt2Yko3MEh2bUpUTEk1SVNaZ3V3eFpKMzQwNnBBTHNLZjdSWVFZcFp2T1No?=
 =?utf-8?B?Ulk0ZDg3Nm1pVXdlTlk1bEJpWUh2RlFaNExRR2txaUxYYUc5V0ZObnlLUUZi?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cec9f5b-7969-4a12-7e60-08dd70706bbf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:23:50.4563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: baJMCwT7EcoIU5I9M7LNn4rf3a6f4Jw1JYEfU7KZo4bIKsnBTqNyn7QOKzdZ9kvQAIMdC+Hhy1L3ipFCyoHEnGVify5LFYeC9XHqrDTpVhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6440
X-OriginatorOrg: intel.com

Hi Tony,

(nit: "Add code to" can be dropped from shortlog)

On 3/21/25 4:16 PM, Tony Luck wrote:
> These can be read from any CPU. Rely on the smp_call*() functions
> picking the current CPU when given a free choice from cpu_online_mask.
> 
> There may be multiple devices tracking each package, so scan all of them
> and add up counters.
> 
> Output format depends on the data type. Either a 63 bit integer, or a
> fixed point decimal.
> 

At this point the architecture and fs code is very intertwined. I hope that
some of the items I mentioned in earlier patches will help to support a clear
separation that will make the code that follows from here on easier to split
between arch and fs. 
For example, I think this may end up with the new event enums defined in
include/linux/resctrl_types.h to support new architectural helpers
that take the enum as argument that the fs code can use to request the
event value from the architecture. 

Reinette

