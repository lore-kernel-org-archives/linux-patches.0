Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB5B135A46
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 18:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717438022; cv=fail; b=eblkgZdRYwAfTyp6sCy3qIwgDTbyE+d5o7pZKLkqNfX8aIfCSnZmP40XxTYhc6X/IESPS+rcQGyTSwzVIUSbxRd85CmaJqDT5/zNvubRQaXKeZES+1ufiDaOpimqoUqUAsV7JiFTHvBo88Nj0/Ljk0+oTg5pcaP0C2IVz36QaHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717438022; c=relaxed/simple;
	bh=H21NZC2nk2wjgim8l+RcFbvZUk/kAfX8M0DSJSdFP4g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gBe0yWwNRnDVEfUUDPw7ewg3++BRZxkF31wrIZffRp/I+haxqP595hRrh3bl7U67X3x1jsNFWIkbNP8H0EGcMnzIFkzK8OI7QJXTQtqwods64CgfgmRHU41Ne8nFtkx476r9XH78O7qUUlZ1Lpubv75I7yFuD5sefy9ncNUQp34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nSy6JKH/; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nSy6JKH/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717438021; x=1748974021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H21NZC2nk2wjgim8l+RcFbvZUk/kAfX8M0DSJSdFP4g=;
  b=nSy6JKH/aVEIEOY4ecBXciKIRE1GitAuk/r0d2FLzkurKxdz/h8FBTKL
   eg4eU373m4S2xx2YqVh2lKnQt/+mUBulgNtYNRRuHq3RN3vA6ZxP55hRe
   1aSGBKtj6tihTVbO2gYEY4/eCqBgYgNPojMOSoPIUrJbkNi9pSnumPnCJ
   wJHRB6yLU0JwMkhAFMaxKIBH+HVAHHZCBhOomr+d0u/1nK3Q9Nh6sJeWY
   yBLoZW2356kYb8I3tJ43srJcNmY3P2r8GpzXtRTlvcUaEhUrYTPWooC+A
   lrrDxYTrmcMWKC8y/b8gtMVlMQ9s9qK123th7alZL3U4fd6JjAa32b1r8
   Q==;
X-CSE-ConnectionGUID: LMd+8/18RN+cxzK/4iCl+w==
X-CSE-MsgGUID: rMxa1FloSyKWV+Xid6oLCA==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="25345889"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="25345889"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 11:07:00 -0700
X-CSE-ConnectionGUID: xK0Z77UZRcKFMQEnQUnXBg==
X-CSE-MsgGUID: pJB5PY1ESGec8DpEjTD0TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="42036083"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 11:07:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 11:06:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 11:06:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 11:06:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 11:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJRtxa63P9sF8j7bijwb9vFqD48lpHERYUWmKnn8cvahEf3fHMnUawrBkp0o0MKoypViYXBx+gq44qmf2dLBJSrsDCnecKPqNbBuSNRXWpknKlWamATKMqwaDWlx6ulZBPvOtXlV7mdL1xRpCGhJgRyFjlVy3t/smzyo6TXIhVcMk44v8+oSYVsH9g/yFOC1ygOmskFofJlV7UdrvBbMiJ/VfigMo6sbB3djnc+oUgBr5mn/a98TTDBn88Gi6A9SMjFgiCynv24Rv5f3E7A1vKQQwROVZrBnSVPwyWRbdK7Oj8A84wiNJ8Wfgl9PAMDrARh7kGSeMCPQb3ybxHolhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4v6lHnyUQHwq0dZN1ds2gQJmuCrTBCdbkXHjYENyUk=;
 b=J8tFMVwEt+edKYQ7kBc5bgjvDMWxCbHfIL8iD2OBMnaeNZP3jpIs/Nwr1XOm4bpFIAKGGuON28SNN81mxFXyrUHiRfnlN0/zdBwUX/NnjXU/zjc9HevXznoRP6+d07bmn1VF4xfvms3JkIkcOYrQuNyn/u/BXwLaZMUgRPh1owOFpO6xhe+Op6w3mKo/97ANk71bHfyoZkbQMguPJ1A8aUa2k5lHCFkeNqJKgHvWxb4ueB33ckrkLQ43eBhrHJXR3E/7ReCujnd76vIxDy91H2+NqQu8A1xy/xlaBHHG8g5skYEj6YGgBUVmRIJBwVXh7w5ZVIVObvFUOdVWcQ1vEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7383.namprd11.prod.outlook.com (2603:10b6:8:133::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 18:06:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Mon, 3 Jun 2024
 18:06:56 +0000
Message-ID: <9a283339-b6d1-48f0-a949-d772152bf7c1@intel.com>
Date: Mon, 3 Jun 2024 11:06:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] cacheinfo: Add function to get cacheinfo for a given
 (cpu, cachelevel)
To: Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <20240531195720.232561-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240531195720.232561-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0373.namprd04.prod.outlook.com
 (2603:10b6:303:81::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: e4d13fa4-44b3-42e2-35c2-08dc83f7f441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YTlQR3NpN1ZDTkxBMVVxSEpiTGFVQ0VhTmV1OWJVRXlGcDFTbmlXSGRSTUFX?=
 =?utf-8?B?cFpKMk1oenlleWRJUEE4K0tQVmpzNkFUSzRadDFEWGFSOUh4SmJFdjlpRm40?=
 =?utf-8?B?b1F6RURNWTNBSkJGUXRGV2F1SUFpTHF3YTVxWnJBa0hoMmUya2s2KzlEWXM3?=
 =?utf-8?B?V3JuSlhYODJ6TW9vRXg4S1hXSFVBc0xKblJuWjVvTXppd213MllBNWpSZU41?=
 =?utf-8?B?N0ZjWDM5Z1BWU2xsZTF4cEF6NVB0R0xrcEgrcllUWXZKRFgrSUlBYjZRNXNO?=
 =?utf-8?B?VW9Tdk1NcTdBTEdQUkJlU2IyLzJZTjBNdHlVS0hHdkpPTlpLOGY2ZDRzMXVU?=
 =?utf-8?B?eWJrQUdvcjFURkd0RXdhT3lGWjdmd0g5UlRRVnBwb1J6a0d1ZGFvVTNkTWZC?=
 =?utf-8?B?MkFaaWQzVFVHYWZpM0VoWDlxaEtiRGhuUVYwR3pMbzlPNUpCZ3h6R3ZRVWg5?=
 =?utf-8?B?Z1I4REJLL0ZKZnA0cUJoeHhKdzZ1c1hqb0s5UFpmY2s4bzJ0cytuZVlVTkJH?=
 =?utf-8?B?VEdFNkJiTE55dzZsZ0wwLzBWUjdLNFJLa0pCRHBwUUJsU2gyTEp0aGhWUlU5?=
 =?utf-8?B?ejY1bDljZG9KdmRNSUNqZWJ4SE1lV0pIcEMyTG1YeWpLeXZ6enBERzNHZWF6?=
 =?utf-8?B?eDVEWVZ0dVRHWFhUYVJTWHMrdHBXOWVkSWhZam12ZTQ2dmxPOVc0UDNOa0dY?=
 =?utf-8?B?NUlwcWRaVVRKUkVsbk1YYlJ6dUtJSXp2dkJwb2FHWS81NER1Z1d4Sk8wTkwy?=
 =?utf-8?B?Z3ZzbTBwTitoOGxXVFRzMlpjcGYwT3VyNVVkZHVtNWM0NFZOTGxCeUhyU0F5?=
 =?utf-8?B?NGI5TVBxL1lZWWhEV2FjdE1SZWZsTk9IbVhPL0tkeG1IT3R5cW5XaVpwcCtL?=
 =?utf-8?B?aEVMRkpjM0ZveXdOcjNoaHdqeDBvcitFbXNtVTRzUVVTQXRiVFdoTkN2a0pT?=
 =?utf-8?B?TzdDN1hObUVHc1NQdDllN3NUcjRlckVaT3hlcGdiM1ZUSkpDOFJsSHEvcVA4?=
 =?utf-8?B?djBxUGtEY3Jkek84YjMyUTVkZzdPNnZpZ20vbWZybUY3YUJZcG9zNy91N3F1?=
 =?utf-8?B?Z0prODRGZlg1YkkxbVRsdlVjZHNGNGd3bGdGNTJzdXZLMXFydzROUnJScmE2?=
 =?utf-8?B?YVhUQk82dEUwQk5ZdnhwL2t4endpUGRqRDFHSTVqczJhNVJ4NTVJY2diQ3NV?=
 =?utf-8?B?U3VIYnp4WDVJOXpwczByUThweHJMakg2ZklreWNrajl4OTJtU0VtenVJUzRm?=
 =?utf-8?B?MUVvWVZWc1ZSL0dHSU00SVRjMEpESUNPWXY5T0QvSUdNeEY2YjY0OWVXR0NR?=
 =?utf-8?B?dXVVUFdqMGtRTE1iaE4wVEhSTUc1NDMyb3FwM2piY2VGVVI0dkFVQjJSZ2xM?=
 =?utf-8?B?cC96cGV2bnQ2eGlUTDQrNzhiRDhrTFQzdlJpSmpVZUh1NkxFMjBUMGhOWXlV?=
 =?utf-8?B?NWdpZ2VMZEZzYzZTbHVsa3M5WnhIbE55eG85UUNMaEFrMXhIcGEyTFVuSWNE?=
 =?utf-8?B?WVN1L3ZtNy9xTFZManhmQWY1KzZ5RDJSNzBnenZQMTRwR29lNlpxM2d6NE5a?=
 =?utf-8?B?S1hSWVNBZFBrYW5NcnJKSXlQaG1DQmhHOERxemEzbkFmRHJNaExQOUw2T1l6?=
 =?utf-8?B?bWlnRUNuZmFmNlFVcVhGK1JURlY4YWZ4c2ZQY2pMSHJtRXk4SkcwNEhWWGE3?=
 =?utf-8?B?QnNhNmw0OGxMK0xBNWd4aTBrbmFWVXV2L3pzTkNuSTVRSDNnV0RFa213PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TklQUlBrdGl2VExsdUdkVUxMUGRNU2NHNUt3NGxsUHFPUUtqRkVUbnZaU0Zt?=
 =?utf-8?B?dFNDOWlkVmptUjNmYk9sR0F3eE02WGtUTzZFbDI2d2ZjSGFvcGRDekdlaDN4?=
 =?utf-8?B?dmkySUttTHRJWm5uM1RkWEtjT0FLTTlXcHF3U2svQnVaY1ZJL0M3MWhVRnV4?=
 =?utf-8?B?QW9MM2k4dDZvb2QzY3N0dEdCckJaRElJYldXbEtlUmJGbjcxMDZJTU1SbDBV?=
 =?utf-8?B?RVBwdEliY25oZVB4eVhYT2t2a0VBQnZ2eW8rMy9US0hOOVNTeFcvYm9uNEVh?=
 =?utf-8?B?ZzFGU09mVXNUTUl5aFZ0SURKTzBPL2tWbmVDM2FnZ2RFamhRdlovYTM3bUJB?=
 =?utf-8?B?QWV0dHFDa1lidGc2OTBvaVZtN1M0ZU00WXJLYVJyQllYKzJ2cUQ2dXUyVnhM?=
 =?utf-8?B?bHhaS1NjNXlPQ1JRUXBnVlk2UjZFTU1xZHRyb1d2T090WndjZHhGdU0rSTdh?=
 =?utf-8?B?N0RQK3NJYmxyVHEyYi9uRzFtMFk1cnlxYTZ1TzEzTHlqQ2xmWm1PK2lrd0h2?=
 =?utf-8?B?WEFhMTRVUThZbXNTaURKdnQ2YWhpRWd3WU5Ma3FYK0UyVDNTTHRsTDU5OStH?=
 =?utf-8?B?a3FVRUVRRWdteStOYXpaRDhXMS9XM2VzNm5RcUZaeGs2cEZ0b0w4RnpLeDhk?=
 =?utf-8?B?VmJKc1EzY3IrOFRwU2JxUnp4NjB6Ymhmb0VGcWpnU0hqT0FQU3grdkMzMko2?=
 =?utf-8?B?TGs3MzZ2bEMyREFHdGZCNndacEJlS2h6Uzhzd0w0ZXBOaTVXc1Z2SmdyaHpk?=
 =?utf-8?B?ZkdDTXNGb3RScnlKTDdpbHhnV2Z3bHV1T1ljNGI3dXBGV0pJM2NSRjFVYXVn?=
 =?utf-8?B?YWZ6eFA4Q3llckR4b3RSSXJDbTAvdGxBeS9UNDFTMi9oLzk3S0xzenR0V2Zn?=
 =?utf-8?B?RG9sVXhURkc0cDBJMFA3WWU5TFIzZFJ3UE9pS2VMNmZoVHZ0OVN0Qm82QVlt?=
 =?utf-8?B?ZTRiZTNBOWdiQ3Qwd3dGQVAzdVVUdHRLNE5laFYrM3RuaTJiZEZFdDVPS2F2?=
 =?utf-8?B?SFRSWThXOGp3Qkoxd3Z1M3JDaGtTYVhOckh1ZVEyVk91VU8zTkdUemp5UDBt?=
 =?utf-8?B?ZHJOL2cxeFA5d2QwTThNaFRyV204eUxNc0hlNjgwYXNtWkhtSmZneHVYeG4v?=
 =?utf-8?B?cjcreTNXSEdhYUQ5NjlUSUQrQmVIUzFUM0xEWUlxaHN3ZXRXTE8zNnp2TnVM?=
 =?utf-8?B?ZFlGMmhmK0Z4ckVuUCttRUtUcjdwellDcHNCS2VnVi9wdUFuY3dlTnBSYjZJ?=
 =?utf-8?B?bE5hSGZzYWlCL3RFaGVod1VVbXNiaTZpQUlaV243UitvTXc2Um44SWp4THdy?=
 =?utf-8?B?Um5HMlRoY3F0OHpxTmJSRjY1clN0WW83cUt4TW1rME9tOWhXR2FnOW9yamgv?=
 =?utf-8?B?MWhldG9DbkRab3Q3N3A5L1NHYUF6VEpaaXpnd0xqRVN3a010bVZ4VnRVZGk2?=
 =?utf-8?B?V0Y5S2huMVFrL0R6d3BPZW5pOElJN1RBQU5rVG5NWG5FNDJSTk1ZODFTU2JD?=
 =?utf-8?B?K1RDQ081VVArcFdGNGRCTlRMSEtsanRXakdUZG9wcG1pU0M1NisrcDRqYTYv?=
 =?utf-8?B?dmNCV3dES3FMcC9GN1Yrc0R6NFY4NjdlenVnaXlrZGM4a0dYWWVlcWRlNi9x?=
 =?utf-8?B?K1pPNWNzaFBRcDNyWTRERUVjRXF3QVRYbFE2eklhQUNyUG9Cb3g4ODZtb3Fj?=
 =?utf-8?B?VFJZUVJqUzFrTDdyM3VYSWJTQ0FoRjNvM1VkOTZKdStWZmNYUlFDd09sSzdW?=
 =?utf-8?B?K2M5c2NMdFZXNFhuOUtxTFN5QUhuQ1NsWTZ5aTdnRTBDLytHNWpZcmZsQkFN?=
 =?utf-8?B?d3l0VnRoSUY1dDZyOU5mRVNKOFBtNWRjM1dnczQydUwvN3A4Z2xOUitiMTB5?=
 =?utf-8?B?d2Z0TUtnTnpvUXpGRDBieUNxV2g3Y09XYThzeVlrcndQWUVIMklURnlWeEVq?=
 =?utf-8?B?NzhHTC9RR2I4VG4yN09Wa0twOU5GMDYzUDFKWUR2T1dGWm1NY2FVZFBUQk1P?=
 =?utf-8?B?Z2pEeS9KK2ZTR0lFZ1A2ei9xWDZjU1AwUmVJQWtEZ1cwZU1WQjFqMUZXbklY?=
 =?utf-8?B?VmRIcXFNdXk4MVFwM2oweG9yWTdnaEhNRU5qYVZDc2tWSk1YbVo1V3IwWlN6?=
 =?utf-8?B?c2RuM1hsVWZDSVI3dmJLRExFWWQ3RUg4OUVQQk5FZmRzWWtJZ0FJakl0bHJK?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d13fa4-44b3-42e2-35c2-08dc83f7f441
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 18:06:55.9463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRqA2SzkD0+rCihDuUBtvw109mV1WFn4gziNm0T9knCb+gmo79V1npxqU8e5RTzcIcS8EvnqS7CvogLZqEiJCIOxCRAGHlYN+GVvtMSyoYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7383
X-OriginatorOrg: intel.com

Hi Tony,

On 5/31/24 12:57 PM, Tony Luck wrote:
> Resctrl code open codes a search for information about a given cache
> level in a couple of places (and more are on the way).
> 
> Provide a new inline function get_cpu_cacheinfo_level() in
> <linux/cacheinfo.h> to do the search and return a pointer to
> the cacheinfo structure.
> 
> Simplify the existing get_cpu_cacheinfo_id() by using this new
> function to do the search.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/cacheinfo.h | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
> index 2cb15fe4fe12..301b0b24f446 100644
> --- a/include/linux/cacheinfo.h
> +++ b/include/linux/cacheinfo.h
> @@ -113,10 +113,10 @@ int acpi_get_cache_info(unsigned int cpu,
>   const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);
>   
>   /*
> - * Get the id of the cache associated with @cpu at level @level.
> + * Get the cacheinfo structure for cache associated with @cpu at level @level.

"for cache" -> "for the cache"?

>    * cpuhp lock must be held.
>    */
> -static inline int get_cpu_cacheinfo_id(int cpu, int level)
> +static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
>   {
>   	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
>   	int i;
> @@ -124,12 +124,23 @@ static inline int get_cpu_cacheinfo_id(int cpu, int level)
>   	for (i = 0; i < ci->num_leaves; i++) {
>   		if (ci->info_list[i].level == level) {
>   			if (ci->info_list[i].attributes & CACHE_ID)
> -				return ci->info_list[i].id;
> -			return -1;
> +				return &ci->info_list[i];
> +			return NULL;
>   		}
>   	}
>   
> -	return -1;
> +	return NULL;
> +}
> +
> +/*
> + * Get the id of the cache associated with @cpu at level @level.
> + * cpuhp lock must be held.
> + */
> +static inline int get_cpu_cacheinfo_id(int cpu, int level)
> +{
> +	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
> +
> +	return ci ? ci->id : -1;
>   }
>   
>   #ifdef CONFIG_ARM64

Just the one nitpick from me.
Thank you.

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
