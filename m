Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7959A249E5
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 21:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732311249; cv=fail; b=Fcg3XDNGEu+4+OEIZE19QWB+S24xKTYA217EcjKcUY/TqrSYsKKC+okLTK9w6dAWso/Nyvllah1rLv6ztRc3jCL0M2bz4htKjuRvgQc3wsdH00a/rTIDKxIw6VRWOrtFp/yx5l8pcA5uy+KCHoTCmFtl/s5PRJu4IgjtRKGmOEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732311249; c=relaxed/simple;
	bh=ocZQydX9G0CMJ4vPtP4cVvhtG8XIn4N9yAdFPjK4NcQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qG6NssoOtNIhh6r0sPi+SyRLmWDsH1jSj6abg1pLx7SnSnqvG/uKbQitmvKzWUFMkNPgeUSdJIApsxJpn7mZBs+Np8XoYa5veDmizE5Q+4XpmJR4n5qvnlyEFy1SyBdQpt99g9j8LFnHlXr/aOqZmEAX9AM9u8dSh1ZztM25584=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4uSzdE1; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4uSzdE1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732311248; x=1763847248;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ocZQydX9G0CMJ4vPtP4cVvhtG8XIn4N9yAdFPjK4NcQ=;
  b=F4uSzdE1zB3gKRqFKKMI2ugynCFP7WTWRX/bK8sVpSfXxsHSMqc1vU9L
   uahE+xTF0IizV563FTHMJKjf85I1mJpjcQCBLCrjR3tjorXdjWwn99Ahf
   Nrln7V3iAXya1KDVpI4eOwjzeT0IcRNxXKiAJAu296EPzmY9K7UzycDZ3
   tGZelGQuTE8wCDuZRR/GVe8W7mBoSggL9LI2VT+BVGIkFiAvSdlAHo0Eq
   tjxsQIZGNTYwupfWvF01MZLBTZdtm/IbRzb55/sLiZ+MiujAH2sVBFX5y
   dmW3TDqquM/j7Ljy9eBAJPHzm50To3iNtZdJpq6/8TQjQytHohuHd6mrG
   Q==;
X-CSE-ConnectionGUID: wGclneb0TqaxNVIej9aTOw==
X-CSE-MsgGUID: /S+P1hc9T4a60I/8zzGCNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="43858497"
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="43858497"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 13:33:24 -0800
X-CSE-ConnectionGUID: 7l6T05vBQBSaJUB+HZpRCw==
X-CSE-MsgGUID: +KJXmttdTfSdmVwNi6j1nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="91045177"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Nov 2024 13:33:24 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 22 Nov 2024 13:33:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 22 Nov 2024 13:33:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 22 Nov 2024 13:33:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JCbDGT/9kgo/nsWH8E0lSVxxEgKgqsbsTBmAv7F4Ro0M+YWvcf97qo/ErptcsYnCguNK/X/rnJaBTFKkKVCLTDQY6KenbBsarfF/BSNt9F+SY5nkwgrbgk2PDq0jSlhGuCqqKz5vRcMBW0UAZRVAv5dvAtqC2QeK6yUNZzwCdKPSapOQq0Yq4vLHYNpjAXNLGguCMygYmUxfy9VXPQOf7DXSg3LUGEzlD1fvJLUvmudMOtKgZYDf+sLXbUdhCDKObYnzxtV03KKRwNqPtM+JG9QKOY3VcvFpePh07B32pN8FM3zL48u3XgbobejAAExp/JGzfW4V5N/J/XML1KipWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X78Zy5TXsjw1qexl0Soevx0/aRYrtmXxiGX/PJHrVlw=;
 b=OqHIFgZYrzuo8RdcLsTIAgw9I0hVdHYLcSJUWNtFBQa0uVAG8U82zr7+AB7s2/AUwMxyBv5EZZHERVgMjPZ7Z8lypOGw1PhIEPC7fJLXp23a36YmXWxaEnSOeRdnzMmuZmJaJ3YlyL+1mnb4Nia94EqbM1nc9QBXzwmmat7WCFhf1xZjrjMYkhJaiuZfOXcyMazDnm01ZO5EnFAAAUubeDdZf99sN0dcWpzfAJjwPQ2WE2IL9PLFfdZdEDTAuOr8AF0AlFTkt1kmdzfJrjUbZU4IZZTYRAyn07xxvV3pa4/5RkwLX+/fVzEW2vUdI5Z4hVlMVUSG6n2WCoqQHDV8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6462.namprd11.prod.outlook.com (2603:10b6:930:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Fri, 22 Nov
 2024 21:33:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Fri, 22 Nov 2024
 21:33:14 +0000
Message-ID: <053297de-b2bb-4077-8700-997564f93fbf@intel.com>
Date: Fri, 22 Nov 2024 13:33:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/9] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>, "Shaopeng Tan
 (Fujitsu)" <tan.shaopeng@fujitsu.com>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-3-tony.luck@intel.com>
 <515914f2-501d-4df3-894a-2d255d18be1c@intel.com>
 <Zz9u-JcQBlxKZia1@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Zz9u-JcQBlxKZia1@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0302.namprd04.prod.outlook.com
 (2603:10b6:303:82::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: 469854aa-1ff3-440c-245f-08dd0b3d4530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkl6ZE5oZWtOZklRWUJ3RkZLT3V6empZR1cyM2pSd0J0K01PdDNoMkx2VXB1?=
 =?utf-8?B?MmFRY3F5MFRoelZDSFBzTWtqOTZCNGpiL3JFN2x2WEg3Y0NYU0ZWc29oK3RC?=
 =?utf-8?B?SXBLU3ZtU1FqR0p1cUp2QWg5Mjc4cjVBNkRBaDhkbzgycUFDSDBySHlEQ1BB?=
 =?utf-8?B?LzMxZjMremh3UjhGajZuL0lRODdmZEtJVnBnSXdEZFRYaFpWaEtFN2wyQnNI?=
 =?utf-8?B?d0h5ZnFlNmw1K0NxT0dWRU9XWDlIRk5sUEl0OTArQW0xVU0rTVIwZUQ0TUcy?=
 =?utf-8?B?eUc5OVdUbDhGaXpweG4yNjQ0aGNEOGdlSWxFa3p5SmtlNXo3ZVVlWDVmNHJ0?=
 =?utf-8?B?ZlBJYnhFdmpIV1BXWjg5a0ZlcFErQjNkU1hIcEdHdDNhZjdPUElldHAvOUlO?=
 =?utf-8?B?MWdsTnpBUTZ2OTg2M1lYYi9KU1g1cVlUU1ZPTG9ieWJCYy9NWUdyVjloNVR3?=
 =?utf-8?B?ZDhpYitZb3dzeUxSSXcxZG1XaFpJb1RTeVVla0gvWWNWSkpNa3ZEZzZjMVhm?=
 =?utf-8?B?cVcxMU95M3JudUpXVWN4aFV5MThLbjVnZW5XbkVlSUtDRnJjQlFqanJyRWZE?=
 =?utf-8?B?dkswNFhFNXZHQkJBZ0NsMGd0T3FaRWZMd1hUejBkUlluMjFvWUFBYUNSb0xU?=
 =?utf-8?B?TnE3ckVZSURMTjhRaFdjdTBxc3JiVjNIZzVPRW5RdXlOb3AvcGphYXREblNr?=
 =?utf-8?B?RmpkS1MzOHloelowOGVNd1lyVzl0cmdkWUlBV3hqbnBXY2haRTVJOTVYNnBp?=
 =?utf-8?B?MGhlbUtTRHZMbEVaM1U4OFozamVJSWpsOFVDQVdXelZrUjRkbVlQRVJYUTIx?=
 =?utf-8?B?SWFjVnRoa2ZWNzJHYk9TZzN3RVNkUVlMSDhRL25Vd0Q1SXdlcU1LWkQzMU1q?=
 =?utf-8?B?Rkt2NE9qOTliR0tMQm1PSUFaMCtOL242MGhWZFJLZUlnbUNrSjlvaTNNL25K?=
 =?utf-8?B?bVQvNzZVNjhMc3hwNWh3OXEzTnZRTTAyZlU4R1ZGZkFzdnlCWTBiSllqeU5n?=
 =?utf-8?B?K0Ntamg3K1VORVJIemRkN01vK1BoNmxzRytZaEpadzBRTEd0UDlSQ3BMV1hk?=
 =?utf-8?B?N0QvRHFXYmdPQjRPMFhiSzZhRnRoQW5yaEo5Z1Y1dGc2bnFjRVNQVC9LeUww?=
 =?utf-8?B?SWQzQ3VsZjhVY3NtQVdORlQra2NNQUF5eEdua2Nkbkx2OVpMMURpcEExbVNO?=
 =?utf-8?B?QjEzcllhUjE3TXk1eG85VGM0RCtMY0s2ekVIenBBR0VMeXcxK0l5RGVaWDJ0?=
 =?utf-8?B?SjNHRkxvL05yMlA5TEFpM2hWOFJYeVo1dm8raVNYV3BueEs2N0dYVGZON09V?=
 =?utf-8?B?RVdMcDI5UGNNOTIxSUJlNVlmSUMvRCszMVljSm5QZzVkcjI3bEFMOWFMYUs5?=
 =?utf-8?B?OFY1Y3JqWHg3c2NWaFlLdk1kQVo3RG41My9ja2MxUXU3UmdmYzUxZWVMdGl0?=
 =?utf-8?B?R2tlYjdYaTRHSkdmNWQ2OGI3QzFWU2VHUUh5czZhZlEyTFJzaHQ0K1BUbm5L?=
 =?utf-8?B?bS9HYzhuVVMyd1hxN0dYU2I4NGsrVkZvR3UxMXBtZFk2ZVhpQWFONkxzUXls?=
 =?utf-8?B?TVErNEMzUU1sNUUvT0dCSmd5RU9OL2NURHRqcVphbkZKbVRZYTJGZlB4Qmdi?=
 =?utf-8?B?aUZmVG1XcUg4aEw2SE9INWIyUUdMalBTdXdSZXBEeWp0Tlg4QXJlemxaM1A1?=
 =?utf-8?B?MVRSeXVLL21XN3dIRVFJNzJkalVlUWpYOTN2SXV4NDVvZDQ0b2sxZldsN1VW?=
 =?utf-8?Q?zxAj3VGv+XRueyIe5k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2lCNDJRM084d3FTeTZxVGtUVkhRVlEwNUg2WmpSSnFmckFnSExrci9uQ1pJ?=
 =?utf-8?B?NlJHVVhlY0FCYm4wQk96RWxWbk5qam9KUVlIS1Y4SVZsNHc2bEZ0ZW5qb2NV?=
 =?utf-8?B?WVM5SDgrZVd4YTRucWdpV3hqRHZhUjNQd01DdkVLL3pBdGNuckJadksxRjZo?=
 =?utf-8?B?d1V5SVA5blFaOHFLTXdSK0xiQStMRTR0YzVhUjdIYjR6MHB6M3U4NmROdnR3?=
 =?utf-8?B?MlJvSUozanV5Q1JoSG5qNGdWSGovYnF1QmxmaVVVQ2hhWmRIQmxJc3JCUHQx?=
 =?utf-8?B?NmhyNGxNUzAxVStTZURROVZNTDJqVXRjTHZ1ZWdUZUt3Y0J2Y0c3YjBiRjlY?=
 =?utf-8?B?YzVOeUJaU3Z3aG85ZXFNbmFjV0ljL0NOZWExSXhDblFlcW90N1J3T3pUZnc3?=
 =?utf-8?B?R2p4MjA2MysrMHBuNnByWVZXUmZkWnlOZ29VUFVHdGE3TzNzdzRhcnpXbjMr?=
 =?utf-8?B?YVZVYVNCT09ZM1Nvd1lkNUQrSjY1ekU0OVZlNUt1RXI1dm9KZ01wQU5kNWRS?=
 =?utf-8?B?RU5LSjZ1Q3pCL01OUGljZ1BTTjBQREpTbVJQdE8yYzNBYkJ4bVdZSnB0Zksv?=
 =?utf-8?B?UHlZSU8vS2dUN3hRZVZrWisxTVZKNmxpV1RZUHZCNjV2ODkvSGFJNjgrUXV3?=
 =?utf-8?B?dVFEM3JjaE5saVgvNFF3dkpmZ1FtU1RjdHp3SmhoMkRGaGdSNnN1cEdpYXJU?=
 =?utf-8?B?WGxxaXhNQnJHZjc1WDZiUGhwZ2JkQ0MwYUI4dGpmc3YyaDhJcG9EVkdraEdm?=
 =?utf-8?B?NFhyNGcvcWtTRTRuQ3ljSWdvOGFBenYzL3hkNWc4REI4V0poMjBWcWpZUXh3?=
 =?utf-8?B?ajNNT2NvdFJyOGptME41bXRtZ3VBc0dBTUZUV21RZTNUZkFNeVFsRDQxTzha?=
 =?utf-8?B?a3RJR0RrQlQrakpRRVUvQ24rT28zZVp5T2xZbGJvS3VEQXFwNFJKTkRQbE15?=
 =?utf-8?B?d1lqUnhRanZ0M00zZEk5d3A3SGErUEQ5T3pYSlpRRFoxU3RueEJhTHpVdGFv?=
 =?utf-8?B?SkJPOHY3ME5sMVZzbE05TnViSlcrM3ZidURLeEI4dVBYMElGWlNCZ21nVXBK?=
 =?utf-8?B?UG5rdmVGZ2I4UXdIa1M5bnI0M0tXazA2bWJKc1NGZSt6aGNHdFpLd3hGTncw?=
 =?utf-8?B?Vm5Ha1FXNkxzK1BVbGc3YUcyZDJVdjlmWTlWbXVSRUhzU0xNb0ZpQnVSNEc4?=
 =?utf-8?B?RTJIQ1RiaTV2a0VmM21BNXNmV0hEdngwb0tjM2t6STgydFlIeUhMKzk0MUNK?=
 =?utf-8?B?QUUyUWpvZkNOeDJSbFVCdFdwaGgyTzJLaUhacmJMY2JIbExLeUdPMW1sWTFu?=
 =?utf-8?B?WmpqcXA2VUlybGVGYW9XdjBuSVZza3NRU0tkZXJ1b0YzR0w3UFZxMlRPWHdF?=
 =?utf-8?B?SUtEeUdCOVByQ053SE4yWTgwcDZXSDJzSFAzRTV3V09ZRTdJSnlkZysvbDlp?=
 =?utf-8?B?RFVWeW5IWjRRdktaUWpFY1FLVHBnZ3JTVGJFcDQyUklQcExROFVXSUdkRjVO?=
 =?utf-8?B?RlRaRDlpc1kwemF4amExR2ZrUkQvdEt2dXA3TnpvYUo0WVNqcXhqTVNuUmNp?=
 =?utf-8?B?WlJET1J2RXU2Q1g2N0RtUER4UG9uR1pEbnVvNVJrZHRJRkdwMkNpNEZ6Tmlw?=
 =?utf-8?B?QnQ5czlvY3c1K1pqZm81MWo1a0F6eU1ONEc1VEREQ0JLL0MrNFIrd3RqOTFw?=
 =?utf-8?B?Q2RWbk9kUXQrYW5ENHc2eWhxYXZFNkhRU3lQUXdEeUNMWVo1Z2dCTWpvcVFG?=
 =?utf-8?B?L0U2cTRjWi9PR3ZiSTJiVFNXaTlyUVVndzRKVERJZjFnSzJibE16N2pJWWt1?=
 =?utf-8?B?SzZxVVRYMkdTS0x0QStPUTRLSEttK0k5ZVVLbXdQS0paRzlxSW50MmVXRWxy?=
 =?utf-8?B?ejdQek9hcWRTTFpkdGRFRy9OdXA5QTQwYTFPdHFFdkREeDJqSjBCUENlcWFs?=
 =?utf-8?B?REFTdTREVktaSkhtNVJzQXBrZWp1Uy9aWnBKQVk2NTZIMFBjbEJ3ekxqZ011?=
 =?utf-8?B?VGlRclozWUxRdk90REZpWnZIK0pINGtkengvSlp0ajMvS2xSQ21OTVYwRWw5?=
 =?utf-8?B?dGZsMzdCR1dnUlpHbjlpRmNxR2FOS3BMSFRXWW9CZVB6STRoL3NiM1pMa0RY?=
 =?utf-8?B?OFRxc01Ba0lHd0p1aGo0L3NwR2hwOWNEcnlaM2owd1diODBGcFBmWjN1alRy?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 469854aa-1ff3-440c-245f-08dd0b3d4530
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 21:33:13.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWWkaOy/FgCl5lkFo5y8Ikg9WGItdwZqun+zDawaI7hDKqOmF1BKZnvPvebvOvihFhyizj7c0RJuQzsCu6kniLunfYe2U07vvRXDpNB67bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6462
X-OriginatorOrg: intel.com

Hi Tony,

On 11/21/24 9:33 AM, Luck, Tony wrote:
> On Tue, Nov 19, 2024 at 05:08:42PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 11/13/24 4:17 PM, Tony Luck wrote:
>>> Resctrl uses local memory bandwidth event as input to the feedback
>>> loop when the mba_MBps mount option is used. This means that this
>>> mount option cannot be used on systems that only support monitoring
>>> of total bandwidth.
>>>
>>> Prepare to allow users to choose the input event independently for
>>> each ctrl_mon group.
>>
> Hi Reinette,
> 
>> The lack of detail on design and implementation leaves a lot for the
>> reader to decipher. For example,
>> * the change appears to create a contract that rdtgroup.mba_mbps_event
>>   is only valid if mba_sc is enabled, this is "documented" in the
>>   structure member comment but not connected to the rest of implementation, not
>>   here nor later in series.
> 
> I'll add text documenting this to the commit comment here, and also a
> comment in the code that defines mba_mbps_default_event.
> 
>> * the patch uses *three* different checks to manage new variables:
>>   is_mbm_local_enabled(), is_mba_sc(), and supports_mba_mbps(). Reader is
>>   left to decipher that all checks are built on is_mbm_local_enabled()
>>   and thus it is ok to use these checks before using the value that is only
>>   assigned when is_mbm_local_enabled().
> 
> With some refactoring I've got that down to just one new additon of
> "is_mba_sc()" (protecting the assignment of rdtgrp->mba_mbps_event
> in rdtgroup_mkdir_ctrl_mon().
> 

Just to clarify, I am not stating that there should not be three different checks. Clearly
if some initialization is done before resctrl mount then the mba_sc checks may not apply.
My goal was to highlight the investigations a reader is forced to do without
guidance from the changelog.

...

>>> @@ -3611,6 +3613,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>>>  			rdt_last_cmd_puts("kernfs subdir error\n");
>>>  			goto out_del_list;
>>>  		}
>>> +		if (is_mba_sc(NULL))
>>> +			rdtgrp->mba_mbps_event = mba_mbps_default_event;
>>>  	}
>>>  
>>>  	goto out_unlock;
>>> @@ -3970,6 +3974,8 @@ static void __init rdtgroup_setup_default(void)
>>>  	rdtgroup_default.closid = RESCTRL_RESERVED_CLOSID;
>>>  	rdtgroup_default.mon.rmid = RESCTRL_RESERVED_RMID;
>>>  	rdtgroup_default.type = RDTCTRL_GROUP;
>>> +	if (supports_mba_mbps())
>>> +		rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
>>>  	INIT_LIST_HEAD(&rdtgroup_default.mon.crdtgrp_list);
>>>  
>>>  	list_add(&rdtgroup_default.rdtgroup_list, &rdt_all_groups);
>>
>> I do not see the default resource group's mba_mbps_event ever being reset. This means
>> that if the user mounts resctrl, changes mba_mbps_event, umount resctrl, remount
>> resctrl, then the default resource group will not have the default mba_mbps_event
>> but whatever was set on previous mount. Is this intended? No mention of this behavior in
>> changelog.
> 
> Good catch. You are correct that a changed event value in the default
> CTRL_MON group is preserved across unmount/remount. This was not
> intentional. Moving the initialization of rdtgroup_default.mba_mbps_event
> into set_mba_sc() fixes this (with the added benefit of removing the
> supports_mba_mbps() check).

I am curious how this will turn out considering the fragmentation of the rdtgroup_default
initialization.

Reinette

