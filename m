Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A8916D9A0
	for <patches@lists.linux.dev>; Tue, 18 Jun 2024 22:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718751504; cv=fail; b=asFtbYTZqUGGHjQ86JckUlg77IuF8rZgSmrn1VjTdyhVwhtaUsNUCo1PlLrEz04wIdeseoTJxNrOg269gNftkvbtjh8I/iX7mWqfmlnV8Oa1m/u9xAJo4CVEW/JQZPo95R3WwycA6I2PRM+kBpG/iCr3/9luMiG4f/DYgekNKgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718751504; c=relaxed/simple;
	bh=It4A87E7HQR4dU1tg39edulJhixMUxrwDbctb/YU0WQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r51LNagxIx+h1U0i2nSZ0IEt9js8HnfNUdYXOlIQmi8jU4qBYziHYz/LVe+AXUKndt9hJY1m/fzaSSKrJBB980CVW1BOr+WhfJYkg/pssJB+1b5aIiYIm6wd541aMajkHsfDNpH1nSuWYJlsXcuwIQxBw+9LzjAC9QMvzkQqnqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H8y9Mkec; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H8y9Mkec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718751503; x=1750287503;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=It4A87E7HQR4dU1tg39edulJhixMUxrwDbctb/YU0WQ=;
  b=H8y9MkecQx+RvSDivpnRloKE93pFYYef1rcomuHiCZOjU6bSa0Tfn6X8
   ZWb5HL526QBLmZ9zw6p9U1dMrUQEzPm5M14VKTa4Yyab0+q4exHeJe3n8
   jxnZ9o5hagRHUcDlcBkebq2sVsKpuMu5Ug1+KpEHIj9JVIK14TJMIBVqL
   TL3L98PSc9TEr49qBHIaDJnBqupEwXfB34Aq5noudCgo1i1Fv5JqI+sdO
   zYpdTbLa+gTQXbTO44aJdbN//cWe0H0ojrxZJQo2RsHZwa00TaC4a7sF+
   oJk3p83Kqj4y2zeeIoY1EDtsZop6vnDs4UeZhi3jyde6byP9Edveif++2
   A==;
X-CSE-ConnectionGUID: IuP9YuxUSBSNNP2OgrOfpA==
X-CSE-MsgGUID: 1jJIDyXQSGCovu/BmYE9Xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="18579611"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="18579611"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 15:58:22 -0700
X-CSE-ConnectionGUID: 5gBgNmKVTym9MasGchMJCA==
X-CSE-MsgGUID: 3/zNOt7mSTWpPqM+T7mwJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="42423266"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 15:58:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 15:58:22 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 15:58:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 15:58:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 15:58:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VR8nIhzsZr1/E2RN5TnGjlngYUFppKxpff3mzci+nJhiHlRtA0YxfO2DekEoSzzIyLDgjCTcdZezQh1qGOIN8kwxhq6uTa1uIfNFMis+M0zKTes62lH+kP8ral03yUmO+1rjp4s/ULBCRrgvcO9ST3X24EOkO4moZeLkvfStoveg2NnIUarIpKp1j3uuxML0LbL48Hf4DdD0UkxbelOlu7XYRq1PtK4XA0utYfXr1mxsr158DHE8aogtQQxTxlTYkYX3WQg5Az6OH6jAHEOKduKjOVStK1w/6UX6vRAfXhR4fCOY/ARcjn8wFMubK6Bp4tMlinWlrRqf4WRz5JYvRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHyASZAh6VdOz/e3N+TTnzgvkKfSR7isqssxgR3yjOw=;
 b=J6kRQvqUtniYMafxvLzGPamxyB9JhPhtx9ATRsnHBVRYmDZvLpL1VkjmpgTwu2kIDIr6bZMbivGDqUfvSNqlxlX8nFx3ZcD9aJwZEKrFxWDL5xHGjGN5lGtnMLA4fErHy2Yq1z0QiuJrJ94aX8UNCmTz8h/Ek6wA+Y90T1nkhfZPwtZHAAMlTFSfoswqnsZQS+iH7I4wFFjrUZHudf1O5tz2OOuTcA++NqO7PfEjT2fUXMwFtJDlVcU3W5wOmLttTSKo+LUeYDRqxH/FCxUKzEbcSvC1Di1lK1i4UaUyYTtOsvrflpcQvmaNJQSGf2Xhx3qnyTB+tTiY+db+5ccKsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by SA1PR11MB6919.namprd11.prod.outlook.com (2603:10b6:806:2bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 22:58:14 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 22:58:14 +0000
Message-ID: <bbb72852-6c9e-412e-abda-8c4ed72978e1@intel.com>
Date: Tue, 18 Jun 2024 15:58:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 06/18] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu
	<fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Dave
 Martin <Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-7-tony.luck@intel.com>
 <67baa15a-76b6-5543-56fd-d2841d6f6b03@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <67baa15a-76b6-5543-56fd-d2841d6f6b03@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0210.namprd04.prod.outlook.com
 (2603:10b6:303:86::35) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|SA1PR11MB6919:EE_
X-MS-Office365-Filtering-Correlation-Id: eeda9c14-1469-4ade-0972-08dc8fea22a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?emhGU2VtaWlFV05qRTVDU2ZLMHMyLytCU3lNTCtUNHZwN3NjSmxkMm5OS0lQ?=
 =?utf-8?B?Mk9OUzdTREdvMjRFSG5qL0FTNGNtTXFHRy9uR0RFWDREK1NHMTFkWjJ1SUx2?=
 =?utf-8?B?NmU0dE9EbVVYU1ZoZElhWUdBWi9jSkthcGx5a0s1Q1hXZElZTXdBWTl2QjhU?=
 =?utf-8?B?eFAzRU4yZDVqNEs4RHJLOFFhWm9mbUtJS2ZjNnpWUGZZQnlFbjA0c2EvSlZG?=
 =?utf-8?B?VHR4RE4xZ0pVbTVEUHpqOFlyb2NkK3cyMGd4ZHYvaTRlczNLc2FDUVdsbU9p?=
 =?utf-8?B?ZHgrYW9TbXVmbVowNnFIMFFjRFJnN0VmU2JBZHFEQjdNNjdON1ZpQWFOdWFJ?=
 =?utf-8?B?ajNPY0RVRzRaUUxLcTl2OEUydVVDZ2ZpMVBsa09VK0NzTDVrQSt3dVRhV0RY?=
 =?utf-8?B?L0tlRnEzMENDQ0xianhvRmgxLytQVDNqK3drK3NrVDFLZ0JSY1g1N253TFBm?=
 =?utf-8?B?dmUwbjNUVFFkM1l5S1cxSFBCQWJUMkxoL1BKb0ZhQlJoK1RuazN4dUpBUWZM?=
 =?utf-8?B?MEtNMHB0YUllNFlEZ0xtdGxIUjFlTXFhNkpwdWZJbjNPM3pqd0NZSmtmWTht?=
 =?utf-8?B?ZHRoYWttaEUyTlVFUEFXYnJzUGhvUHFkb29FM0lRenRYYi9IdDBuRmZsNlND?=
 =?utf-8?B?ekx6b0hPa2hNb2cxQytYT1NSU0FIT1BMYUNsOGZwRXNDSlhZSVV0aElPUEhU?=
 =?utf-8?B?dXBzWVd1RGwzMDM0MFZSU0Q1UnBWYTFObVZab0QwOE5BYTJOQ0VzUFhNS0Fr?=
 =?utf-8?B?ZmNsQnh6b0dkNW9OQUtMRUV0MzlRdng0aTlsYzM1TVI3TEZBRHVuZndWOGFq?=
 =?utf-8?B?cmh4dTBBTHQvNkhXWUtLRERhVlppY3hwRHR2WUpZVHdFMU11Z0t6ODJyK2pu?=
 =?utf-8?B?a1RKVDdTa1RlRENvNkdPOXl3MHRSUGh2Tk9vODdYb2h3UnhQZndSTGo0ZC9s?=
 =?utf-8?B?MUQ4REVYZ29CV01PYWltc09TdTZYOTBQbVBEazA3WktiZWkvY0RlNDZqM2k0?=
 =?utf-8?B?bjYvOVpOaFVhdEY5alByQ0MwWHRwUkpZdzRpNHFEWnhvTi9HNlZ2Wng5QWRX?=
 =?utf-8?B?azFOcnByZUMxODFmR2NsTTczRy9UQWdDWmpRRStKT0w2akVjdGhieHkxZi9i?=
 =?utf-8?B?UkRiV1l1WWcvYUlRWkY3OTB6R2tYYTlWN2tqQW5pV1VkYUdVR1JSZG5Rekhv?=
 =?utf-8?B?RUx1WHRPUDhtUlhPNlVMZFdhTHpUQzZQTDJnQUFyZ3NLUFVqT3B1WVQ2VW5K?=
 =?utf-8?B?eTNadmlBUUc1UXZ2cE5iYU01NGMzSXBVWTY3b2l2b3llODd5WE0ySXRwYzQw?=
 =?utf-8?B?OUVzV2oydTZHUG1lY2VVaENmNURZZXh5OU1xdThpZ2lsbjhLcDE2OENYYWNw?=
 =?utf-8?B?WHloWmg5eHNTMGpKcGUrb3dVMHEvQS9kR1dnc0JDRUpnZXZFSTRKdXJqV1lQ?=
 =?utf-8?B?alo2dUZXaHRVQWloL2w4OWg4bGRQVkd1TDFBTHhneE9tajMrN0JySEU3VmNt?=
 =?utf-8?B?L0s0c1VnVk9Nd2ZhSjhWSUZydUdPZG9kT283OFVGY283TXVERnZTRldhNkpV?=
 =?utf-8?B?ZXl1Qy83Z1RLTUFwRVIrQktTRHhUck1IMm1iVS9vTlVXc29MM2llc2IxTXVM?=
 =?utf-8?B?UjRMOFpmUHpBUGc4eU9TcVBxS0RGWmZyRlpnVVVaVlc5eHZRRWtNNGdDbXZo?=
 =?utf-8?B?MmNlRzRuci9jZWtHQmQ2cHZqUmZHVzhmS1ZFV1JsdFpmYWZ4UXBpelMzWlo1?=
 =?utf-8?Q?BxZDMhR3AX7taNUcGWBnx36Y+YARTJJJ4wEyxWY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTZOMTlqdG5KSWhTUnRYRWxQK2JlbWFBZFFnRlpsd2NxNk5YeVk1N0JJc2JS?=
 =?utf-8?B?alhyVVNORzlwd2xWSWZOejdqazVObDR3TzcybDVseDdNVnNDUWg0RCtqdkpY?=
 =?utf-8?B?cHVxTjFLbjlGSHdidStGUmFLUkN0bEVPVUM1S3RCTTd5TDN6UlQ3R0M0Q3Ny?=
 =?utf-8?B?NXZweVJpRWhSd253TXdKR0N4S25EUUlOSWlkNm9uZ2d4SW1tL3VZKzg0QlJL?=
 =?utf-8?B?ejFMWFZmY0ZqcjQwZ1FBc3VXVElwdzJLdFFBTnhPcXNiL2RaeE9IM3ZKazY4?=
 =?utf-8?B?RDRMRE56VmMxMTVHRC9QNUJXU0dBZ2tyZlAwLzJWaFBzdnRMbnJTVStUanlx?=
 =?utf-8?B?dUNqSEpzcTJST0V3b2FGSHQ4TERjUW8vZGlOODVpTVJUQXVmMUhNNlBWOTFW?=
 =?utf-8?B?Z3JaSTd2bkoyVUpQVjNMTkZjTWkxOFEzbzNzYkU0aVFvY3BqMDdRaFVZMytm?=
 =?utf-8?B?R2Z4dUdhcGhTamdITzBwcWNBTWVyQ2NxL3JkL0I3YURmVGczazJKeVJUSGw3?=
 =?utf-8?B?anNPU3BJVVdLYmRsdDdza3ZoQTlRTDZudGl2Tnl4bVpUUzZ3K1BrMVFUN21r?=
 =?utf-8?B?UWJtY2EzUXJwWEpLaEpSMG9LY3k2M0F2VThSanFXK210b25jY2ZxUnhHL2sv?=
 =?utf-8?B?MFpnVzE5Nkc0bDBIek5ZV2ZJcHNnWVBhT2tEUXhBeGtoWVN6bkJIMW14aEFq?=
 =?utf-8?B?eGoyMlFZQXJxcXZSVmFwMEVHcHE3cFVJbFJkMmNmSDlrbW8xa2JZUjFudG5F?=
 =?utf-8?B?TEYwOHpkTEUxSjh6WXJRSjdqRjQ5YjFmWlNRK1JDWkpqU1E3Nkp3NlhtUmkw?=
 =?utf-8?B?YnFIN2FqZ2dOM3ZQeHBrY29xdmZtdkhHNWRIZm04VUVpMDc2aWhLZGg3bFVY?=
 =?utf-8?B?THMwZCtJNThHRDJqdlNSczNoWFNkOVhLbFFrRUlsbUljTnk4bFM4OFVRdXoz?=
 =?utf-8?B?TlgwWFJsK3lhN1piTzJ6eUxhMWw5ZjZHS1A2VjFPWkRVeUVoUWNxNEhZOThM?=
 =?utf-8?B?VkViYWJxVkc2NGxpdnBtUTBVd1R4RGZtSEJJaFBSYWQ4U09KWEsyRHFVQ1R2?=
 =?utf-8?B?T2tvVGprL1hPbmZFaTlocVpOV0hvWDNySW1kM3JhUmw3aDhUb2Z3c21nVWFT?=
 =?utf-8?B?NUNsb1N0cFA0WVFwVGJ6N2o5TW01STgzaUdEc3hvNFU4YStEcW5FMXRwdnp1?=
 =?utf-8?B?dllVUytMWllWT1pIZDFENW9YNEpZNHAyWnhTSGxkWnU5RFFKUUs0L0ZUYkI0?=
 =?utf-8?B?RUNjbDlTU25rTG0yOFpTaFFiT2hGS21jbDJVTmN6OEpKZ2NxMUZiaWZtNmJt?=
 =?utf-8?B?ZzdYRzN6eDZCaXRuNGVZUkowUE5Dai8wVk4wRkVrdUVhencwRGZ3dU8vTHg1?=
 =?utf-8?B?ZWhvUGhxVjI4WHhyZ0ZKNyswMEk0RUJBR0lpREhmVGtDRS9jTFhPRFA1N2hI?=
 =?utf-8?B?Q2RBYlJXNFFCY3B4Mlc3dkRzell0WXVVVXdBUXV0dmw2dWE1WFRaemhteXJB?=
 =?utf-8?B?L2tRMVpKd21kelk0WDBBamxwRGMvY0hZd25sK1ZGdmtMNUpjcVRlVDhZd1ZT?=
 =?utf-8?B?SlZTSWRFOVF1cHUxSGR5S2xZUFV5cEFOZHNmVk95K2JzUkFzOVI4MnJTL0Q3?=
 =?utf-8?B?QTE5dGlBdUFoQTZhN1ZxRlF2Y1BLMHRUczBQWDY3eGpDbnlCRTJYS3E2NVpY?=
 =?utf-8?B?ZUxnbUtTbGpaaGZoa1pWL2FvaEF2aFhHTGQwUkFzZkYxeHJzbURycm96Zkoy?=
 =?utf-8?B?OXY5WFRtcEpISHlrSEJ0cnl2VndGWmhrY2ZSeW5Dd1VPMFJXNHlVY09mTG1N?=
 =?utf-8?B?TWFnTnJJN2Y2VVBEV2FYOHdJTlFocXpNRnU5SVFpdTBGbnZDT3dqYnVwcHph?=
 =?utf-8?B?UmhQSmVvekdvTzAyUkw1WTdrMlpSbFk5ZW13OFh3K3FqQmlrMWQzMnF5UWxI?=
 =?utf-8?B?OWRNeGN2VnlZWXl5dU10Nkh1QkIwWjZZZmJpTW54MjR6UU1xLzBjMEdNdGgz?=
 =?utf-8?B?V01VS2NwUnR3R1FLaFBnNGZGVHVzYWJYQUhRZEVoRFhQNzJDaDc1RHBBMDUx?=
 =?utf-8?B?QTkvTjN0Yzc2ZWlrY0xRN2tUcHpocEVhTnhLa0w3aHhSdjBNcnZUMFJXenlY?=
 =?utf-8?B?UllybEtyaWczUnRKcitpUEdtVW9XVUxvRG1BcHk1cndLUzJ6VHdobzh5aks0?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eeda9c14-1469-4ade-0972-08dc8fea22a7
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 22:58:14.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39cCtP4H12B1c07hClWW4suAIbGFXhWCQWnBWK6Or5TMFc1FuTFy5XnVrGk/27ZSsv9WDsmgUl+Jrw5X9ykvzS2yK3OD0agIWTfWnf/vyFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6919
X-OriginatorOrg: intel.com

Hi Babu and Tony,

On 6/17/24 3:36 PM, Moger, Babu wrote:
> On 6/10/2024 1:35 PM, Tony Luck wrote:

>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>> index 89d7e6fcbaa1..f2fd35d294f2 100644
>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>>   #define CF(cf)    ((unsigned long)(1048576 * (cf) + 0.5))
>> +static int snc_nodes_per_l3_cache = 1;
>> +
>>   /*
>>    * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
>>    * If rmid > rmid threshold, MBM total and local values should be multiplied
>> @@ -185,7 +187,43 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>>       return entry;
>>   }
>> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>> +/*
>> + * When Sub-NUMA Cluster (SNC) mode is not enabled (as indicated by
>> + * "snc_nodes_per_l3_cache  == 1") no translation of the RMID value is
>> + * needed. The physical RMID is the same as the logical RMID.
>> + *
>> + * On a platform with SNC mode enabled, Linux enables RMID sharing mode
>> + * via MSR 0xCA0 (see the "RMID Sharing Mode" section in the "Intel
>> + * Resource Director Technology Architecture Specification" for a full
>> + * description of RMID sharing mode).
>> + *
>> + * In RMID sharing mode there are fewer "logical RMID" values available
>> + * to accumulate data ("physical RMIDs" are divided evenly between SNC
>> + * nodes that share an L3 cache). Linux creates an rdt_mon_domain for
>> + * each SNC node.
>> + *
>> + * The value loaded into IA32_PQR_ASSOC is the "logical RMID".
>> + *
>> + * Data is collected independently on each SNC node and can be retrieved
>> + * using the "physical RMID" value computed by this function and loaded
>> + * into IA32_QM_EVTSEL. @cpu can be any CPU in the SNC node.
>> + *
>> + * The scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is at the L3
>> + * cache.  So a "physical RMID" may be read from any CPU that shares
>> + * the L3 cache with the desired SNC node, not just from a CPU in
>> + * the specific SNC node.
>> + */
>> +static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
> 
> How about ? (or something similar)
> 
> static int get_snc_node_rmid(int cpu, int rmid)
> 
>> +{
>> +    struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>> +
>> +    if (snc_nodes_per_l3_cache  == 1)

(nit: unnecessary space)

>> +        return lrmid;
>> +
>> +    return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
>> +}
>> +
>> +static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
> 
> You don't need to write new function.  Just update the rmid.
> 
> 
>>   {
>>       u64 msr_val;
>> @@ -197,7 +235,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>>        * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>>        * are error bits.
>>        */
>> -    wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
>> +    wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
>>       rdmsrl(MSR_IA32_QM_CTR, msr_val);
>>       if (msr_val & RMID_VAL_ERROR)
>> @@ -233,14 +271,17 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>>                    enum resctrl_event_id eventid)
>>   {
>>       struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
>> +    int cpu = cpumask_any(&d->hdr.cpu_mask);
>>       struct arch_mbm_state *am;
>> +    u32 prmid;
> 
> snc_rmid?
> 
>>       am = get_arch_mbm_state(hw_dom, rmid, eventid);
>>       if (am) {
>>           memset(am, 0, sizeof(*am));
>> +        prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>>           /* Record any initial, non-zero count value. */
>> -        __rmid_read(rmid, eventid, &am->prev_msr);
>> +        __rmid_read_phys(prmid, eventid, &am->prev_msr);
> 
> How about ? Feel free to simplify.
> 
>            if (snc_nodes_per_l3_cache > 1) {
>                   snc_rmid = get_snc_node_rmid(cpu, rmid);
>                  __rmid_read(snc_rmid, eventid, &am->prev_msr);
>            } else {
>                __rmid_read(rmid, eventid, &am->prev_msr);
>            }
> 

When considering something like this I think it would be better to contain the
SNC checking in a single place so that all places needing to read RMID need not
remember to have the same copied "if (snc_nodes_per_l3_cache > 1)" check.
This then essentially becomes logical_rmid_to_physical_rmid() in this patch so
now it just becomes a question about what name to pick for variables and functions.

I do prefer a name like __rmid_read_phys()  with a unique "prmid" parameter since that
should prompt developer to give a second thought to what rmid parameter is provided
instead of just blindly calling __rmid_read() that implies that it is reading the
data for the RMID used by resctrl without considering that a conversion may be needed.

I do understand and agree that "logical" vs "physical" is not intuitive here but
to that end I find that the comments explain the distinction well. If there are
better suggestions then they are surely welcome.

In summary, I do think that the "__rmid_read()" function needs a name change to make
clear that it may not be reading the RMID used internally by resctrl and this function
should be accompanied by a function with similar term in its name that does the
conversion and includes the SNC check.

Reinette
