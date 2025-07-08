Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EAA1C8610
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008675; cv=fail; b=ILQW49K3ME0OcjwiK1mUtcvgFslYDkZsKttpK3Zbp2Sq10mn2FliuZY1XcHedF1TGXs3eJPZusuF9DvpLHQcxkDz+BqcL6VDBGkzJdRyYyB9HBc/W5FHt7vNbu4zpBb/Kpn929eI7Ws08m663jHnzBw8Bo6Za0tgeWgn/LglNlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008675; c=relaxed/simple;
	bh=t8amvUphjfoBADi3Y3tW5/PQ3yd6TEaKSO4cfCXEDmI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aPCpqXD4GLoz6KaiO0EjnZfLH1er8QBzlUSbDAAeODMi0hipBD14TXl/uXIhl1ocunpEBP/Nc0C1N0hNGUH6V5KGQU9GYDqI1XtDChZrHk0vHvmgs23L/R8KpDRBUqGHuXruOR9O+ynZgnXQgCnnQIJGrxAGYxfIFC/S2++xCFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RnFPnFoe; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RnFPnFoe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008674; x=1783544674;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t8amvUphjfoBADi3Y3tW5/PQ3yd6TEaKSO4cfCXEDmI=;
  b=RnFPnFoezM4l0fu+LpYe++9n10/uXCHgOt6yjwVuaLOYxAn2RbXV6tDr
   mxqpCgRHU+NfH1EPNx9ER91YTkAXOiRYktrUUJKElhIgbrTJ8ZQ5jSH/F
   6/gb4m0dnKG6G5hvyfzFVxLMXfP2nk60GsSCFh1GIFSZ5b+r1AIHRpT7y
   UF5BDaKgSFcr843wHsuJ3vL5down6Lb1TPY2vnVkk1OVcA12B5bPUxcDB
   Zeo21IJh3RnKKhIUjwY8OKbPhagDbTt0pyRZXpL+bHXAc2YfkYeeeOfpd
   +VcP7QHKk+BHG02HE96tEG9svQUdpMf7OMi2g+zSyjNZBpe0FbxmkEK7G
   g==;
X-CSE-ConnectionGUID: FnFI7o55REmnIkOszoBRyQ==
X-CSE-MsgGUID: iYIwzH4iRh2FvM/Kl6xQ2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54144171"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54144171"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:04:33 -0700
X-CSE-ConnectionGUID: obXMv/gOSQOycwPCy8Mv7g==
X-CSE-MsgGUID: t4VNQc3qTf6gDFvXIeSnnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159860904"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:04:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:04:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 14:04:31 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:04:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nHH3hMW3uubgA+bG8tO8qDu9mfnldX3lkPaY5q8pHmERP7LqnOT3H3cyw5ch+82p/g7XFoVumyOvnrLcqZoebojALTkIG5bOxBIu/ye0fAWZERIRXrhxIilUEXTlyxMBrqo5G11Sp+hpHNPBPEblEv4eh72EmmiWY/X+jSpaREjiDIIn+7+ZnR7vNd00BU2PXvNpFUaDRPDo/ynPUGmsewMWONQizCc6QTHhmXMEH96qk2+WpzbJL8Cx5E3uEImGJJCw8LbvAVVb0KvnjxUoMXvgMGTZvOO4ZFJk1e974qUUTGA/JYUIo+VL+tGXumpU7LveEOMvFbQ5f3exKx57EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoYpteNdY3Uao9sXGK7tgfDfW5h/V5wHzqckE13S7rE=;
 b=Z9eYBDsgdzhHqoumIN0TvkLmtd5EgTmFcNZ29Rj59Wfk9V2khWJ/kSk77tV2pMzRxjjcfxc+cOuCZH3LIBo6Oi9Y9qHfQ3S96PJguu21xRY2WqGnkZlKLeAnpwRGKQ8q6F7HWG7kyDar8Eq556cybr91HWQmBlibRa5TFVvCRKdDKv8ERTo1K2uodSzJLJ65B7VxzoEW2VWPfwHyhSeXPK4/NeCxnanMjp4EaRqkZRWPdqEgxtTdtLTBqG3+TNTL80Pd5753O1TfOE+Gux+2Xf58zn6tuyblRUrWYXWVMXmHIxHZKpxRWL/M57AfwRYPnX9YwD7TgbLJxDp9fpVoSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8786.namprd11.prod.outlook.com (2603:10b6:208:59b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Tue, 8 Jul
 2025 21:04:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 21:04:26 +0000
Message-ID: <7e16bd9c-0c09-492e-9465-67199ddc1516@intel.com>
Date: Tue, 8 Jul 2025 14:04:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/30] x86,fs/resctrl: Use struct rdt_domain_hdr
 instead of struct rdt_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0228.namprd04.prod.outlook.com
 (2603:10b6:303:87::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e7925fc-07b7-44bc-79e1-08ddbe6305a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TmxCSEtvYmZySHFMRWlsdXUyU200R2swSjlkYXNKS1Q5MEpCL25ZOUtiU1VZ?=
 =?utf-8?B?djFxYkY4V0U4Y01BODA3VjJmMlgreG82OXRzL09qbFZkMHQyKzRJOG5SZnZK?=
 =?utf-8?B?TVZUR0tUQitUS25zMVR1MnBEbEhidUh2TVZidlB2bmJ0R0wxWUhnRVhLQmFS?=
 =?utf-8?B?NFhiUldzWlRaM3dIa3IxdGxFb0lyaW5PZFVraXlsMC9QZ3U4SnNPMFZsTzg0?=
 =?utf-8?B?aDNtOGlqTWF1eXpVeXM3ODlaU1ljZXptaUU4QXBDVmhxdmxRa3k0K1BpVURN?=
 =?utf-8?B?dGNCa2hSVHAyeHh5dkJGZVAzOUFQdlV1R094b1I2RUQ2TkhqaG1MTGFlQkgz?=
 =?utf-8?B?OE1lSllyMzZZVVdCSDlSUnQrL1llcHBvVzYySEhlUVVGWlJabEt4OFQrdHlq?=
 =?utf-8?B?OWV5d04rT2YyZ2hONDcyNHJqR1lqdmZtdUtvKzRyNkxrRHpnVGwxeFZ4UUpa?=
 =?utf-8?B?b1VxUTA3NTQxcXdyNG5ZZGd3YWUzMFJMTWpBUE5pRUpYbnJmWGZvd1BWZytj?=
 =?utf-8?B?Qzg5akhWZnVDNGlEanF2STNhaytsaDdqYlplb0ZQWDNlSGFGZmJLK2pEcmt4?=
 =?utf-8?B?YTc1WXp5SThiTUQzM3g5dzBPUStRbGZiV1luQTU1UENQbmZ4Q01oUFZWMlBi?=
 =?utf-8?B?VGpQZzBWYlVzZVdQSVd0a2xFaGhKbjVGaFZMVkQ5U1ZJbDA3YkVMU3NXMzJP?=
 =?utf-8?B?MzdENXRodEVrQVJTUUdIMWZkMHlsNlNNSXA3ZlFjOWgrRHRxREEwWWFpeklP?=
 =?utf-8?B?c3NOdXhhV3ZlbDZGS1R6NmJEaytBYStRbkwxTUR5cmlxVG9RenBZRDcxZE96?=
 =?utf-8?B?Z1l1bVROT3hHOWc0dGo5aDl2VDdNK0dYY2xncmQyRGpiS1M3VFB1NlhtU0Vp?=
 =?utf-8?B?MWQxakplRzAxYTl0ZFJ3YWdJakxRbEhOL1VKM3E0U3FxTG1HOVN0T3VKcExz?=
 =?utf-8?B?M2hKMlNKRkoycnAzczlFYUJVY2VRR0tpOFdrSG1MbStkckVNdDdDbzNZSFMw?=
 =?utf-8?B?VE0zL2NUWm52RGYxS2hZVlVxUVFQbTNTOWpHNkVtSjc4NDZtb3Z4dXFYdEVs?=
 =?utf-8?B?bzFvVUY5dmtsQWFhZnNBMHFyYXQrL2xPdDBWdnFUR29ZWVdmVFdqQXArcVN0?=
 =?utf-8?B?Y3FyYzZHc0FweHZqRjJZeGNmUjRQdXVwZHg0b1hnV0E0c0dYb0h4djJRcVVJ?=
 =?utf-8?B?VnQ3NUQ4blZSS2lTcURNcm9Ualp0YnhIM2tPY3ZmUWRSMWgvVjNlQ01IakVo?=
 =?utf-8?B?UkxyWklEaFFwRjgrbHVsRE11eFkyMmo2QWc4VVNmbFkvUzNpYitzU3pYSWNZ?=
 =?utf-8?B?YW93OG9ZZlVzakErVThRZ1VvRXpVclhOdlNQbCtvWVJHVEk2alZCcStmRyto?=
 =?utf-8?B?R3FzOXd6dmZwSFF0L0dha3ROVXZ6ZW45b3RJbnNGVkEwT2treXF6djFodTZL?=
 =?utf-8?B?M24rMCsrbkl2UmJrUm1TL05jS0pTREkrcXZ5NW14aWkydTBJOEd0VVNxVFNp?=
 =?utf-8?B?clM3dE5ZS3kxTzZhZnI4Y3M4bk9qYUJFYm51ZVdRaENQODd1STdsK3Z0R3lR?=
 =?utf-8?B?TlowMjVFREVBeWxlRzNHQmhjZmFPdXhxN1VCUUE2aFRVMXUvT2RreFJwQ1M5?=
 =?utf-8?B?a0t0TDhNODZYQUNNblBIK1pRWU45SmJLcnc3WkhYWnZFYXE2cjRNYzhZMFN4?=
 =?utf-8?B?S1laYnlULzV4K0VTVk9zQkxEK290SFdPQ1kxMmZKRzdKbGNtM3hQcGRNUi9y?=
 =?utf-8?B?ZWs3WFdiR0lHKzVQdFg1VUtzdGtXUnNVRUg2UFU4UFRRdWhKMDA5OTJBSGpF?=
 =?utf-8?B?N1ZMT0RnZGtGT1lvWUdkQ3Zyend5dDRmSDlNTEhFTWlvK292dG1zRk45b3U4?=
 =?utf-8?B?M3Z2bVlLdFNOMGVrY05zUXgxTjZMbDFTdm5rOEpoQ1Zab3RmOGdZeHZ0a3Y0?=
 =?utf-8?B?dTM1QnF3dWU2Wk8wUVZ4NXBwOHNudXVQR0ZmemtUUDlGMEFaNWNUUXNKRW1x?=
 =?utf-8?B?RjdyUS9MSUh3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWQwR0RGK29zaDYvV24xMEQyQmFGbEJ3alMreTFqOGZUdDJqV3B6NXFOU1ps?=
 =?utf-8?B?MXI2YWxuM1FQc3lWL3dYeTc2cnJONWcwQ3BUYzBpZGdqZGtJb21oNzJyNklD?=
 =?utf-8?B?Uk9YeW5VSys2Znc2ODFvRGE5S3kxekp0cDduVGJDdFIwTXpLVzJvOWtSR3p6?=
 =?utf-8?B?SFJPU2J2QWJWTUJzVjdqdXMrS0NvUlVjY3VMdDFpbWlZVXFJalM5M2pvYW5R?=
 =?utf-8?B?WEd6cXpBTkdLZmdDME50Zkd0TzYwT0JtR3pDUmhaY21ISVd0aVJ6ZXMzTGF3?=
 =?utf-8?B?Q2FVRjE5U0xlTUxSNDg0TWtmOG96bU5ESzFkeXNqUjk0SFFiVTN0aVlHdjNT?=
 =?utf-8?B?MzFHM2JINndTUndidzU3VnJVRS9FbTd6RGZEZGcxTW9ibUJrSllCTjdRK1NX?=
 =?utf-8?B?Y0RhdFV6VFlkY0hmMnp5NjVoMnYrdS9SMk1JZ1c0S3FLZVhyc1RONXNRQm02?=
 =?utf-8?B?WTVQRGZRdS9tNzc3enhTWDdWV2FFYkVvOXpjNzkyVFVHTFQ4Y282bVdJUzZL?=
 =?utf-8?B?MDNCVE9pWENJMklSajZxemVySjFob2N1Y2xSU1QwOTlaNVMzcWVBN1pLMlc0?=
 =?utf-8?B?cjhZZkhlK3V0UXc2Wk9jRHRUSjhwdm1tMEtrcHEzN2xUdytWTW1UMG9YYjBO?=
 =?utf-8?B?TUpFVzdHcE51alZMQjAvL3RUcS95S3loMndTeUJVM0R3Qkw1WXdOUnZxY3g5?=
 =?utf-8?B?RTdnUjhBNGVwZXY2dnlET3VQNFhQeVIveXN1MWZhV25lT3Q1dFJSaXdJb0c4?=
 =?utf-8?B?L0MrQlJYZ0J2L3MwMVpkR1lzTjcvSmsyaWtiS29EaVQ2ekgwQk40YnRWRlpP?=
 =?utf-8?B?QUVDNUo0Ykx3WEpxeVM5ejF4ZDFGblp5N2ttUHhpUzc0bjNiZWF5RHdocUNt?=
 =?utf-8?B?Ym5sQUgvL1ZXR3d3MEI0TjM1dG5hamN6SGx5b1BvRUN6dE56eHlDZ082aEd1?=
 =?utf-8?B?MkIyZkJ4MSt6Si8waXVjUGRpakp4Sy95ZWt3TGZSNU5kOWE1QVNjUUJRYkFr?=
 =?utf-8?B?WGZobElwQU55WGxjalQ4bnRDNkZHM2c4eW1UdTlUWW85QjRtei9WQ1hDUVJ4?=
 =?utf-8?B?NGxsR1FKZXNMSFBYVVRWNjFoU1pUcmt6KzhZejZDZWU1WUptWE1TdUs4NXBY?=
 =?utf-8?B?dVE1NjFGK1BpRCtWQWs5aXhndkVFNU12R3M5azRIWlE2REdRTHFVdkFXREti?=
 =?utf-8?B?RTJmL05RUURyb2puLzJhcnhKU0RHUFU2eWs3dDkxZFVsS0dWL3BWSm50S1NW?=
 =?utf-8?B?OURBOW0zMmhlU1pCb0xLT0RzUTFDbUtjaFpCaTBGU201YzdVVStUOVdYd1lE?=
 =?utf-8?B?TERReDJ4ejNieitoUi90bXJjWnNNVlhKT2RUN0VjZ1d2SlZBQWsvaGt4bVZW?=
 =?utf-8?B?QjEyNmtFR3kxckVOaXU5dW9taGZCRHZJMlFkRDhiTnF5SE4vK3dWL1JLbk03?=
 =?utf-8?B?MXlSbERCSHR1TW9CYWN6V1UwQSs3N3NPcWRGaVR3dVROV2NTTlVHZ3FJZHV6?=
 =?utf-8?B?UFJhNS8zVTN0bklySEdwaE5Sa0ROU1RDSXkyaCtPb3dPSVozMFhnN1N3QndR?=
 =?utf-8?B?VGpQSTl2QWVwMzZoamlsSC9PZyt0UDhBS2JWSUdjRXhrYUtxN1BMZlgzTmdi?=
 =?utf-8?B?Z0hXbG9SR3IvcDJiSmFYNWlFMGdpUnJFSWJVZ3NZenZ3TC9EVGZFdTlMbk0x?=
 =?utf-8?B?b1Azb1hCTDZyaS9sMjhXckE4Zld2YW5IemhhdTVwaC9sd1lHWDRPZ1lGMlR4?=
 =?utf-8?B?K1lFSFZZb2VyZXp4OUEwZWF5dmFmNWRBZ1pIUE1ybEwrcWdYNVl4OXdTVkMy?=
 =?utf-8?B?Z0FJWTJESWFCazFDYW1LNjZ2OVRrbWpyczZtejVtNk5vRW9wQUJUKytjY05o?=
 =?utf-8?B?VnNBYVV4cTRpTGpHelVQaUtUYmZUb1o0ZHR1NExua0p1QlZMblorUWUxMVRs?=
 =?utf-8?B?RHhyR2l0akRnczdJWjRmSUxLZDc5d2RzVW4yZXJNSlo0ZmZVaTgwWDk5T3Rn?=
 =?utf-8?B?bjgxVnM1amtob1lQTWhxZElBbnlzSmc0NTRrYTcrR2ltSGhQTlB2VFJFVjRm?=
 =?utf-8?B?alhLczZFKzdvQ285OUFTUlBOajczZGQwUjk2T050NDJ2SWJKRGd6d3dNM09B?=
 =?utf-8?B?L0gzdmdCZWpIRVR3aThIRTIrMTNYeGdhRzlEWUZQK1p2NU5xSmJ6Y0kxNmgz?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7925fc-07b7-44bc-79e1-08ddbe6305a2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 21:04:26.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWflhJqIkg5p9lydb5VKdFJKz0HzHqs7KaMIuYGGrvey90rzebU6RZD8eUAy1AP1YXJiDmPAKLuSPg07m+KjlbGFPXH23I/9Gm9RpZtGelg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8786
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource and it made sense to use "struct rdt_mon_domain *" arguments

How about:
"it made sense to use" -> "it made sense to use the L3 specific"

> to functions manipulating domains. But the addition of monitor events
> tied to other resources changes this assumption.
> 
> Change calling sequence for domain addition and deletion. Also for
> reading events. This includes the smp_call*() IPI where the rmid_read
> now holds a pointer to struct rdt_domain_hdr.

Above notes which parts of code is changed, but lacks description of what
the change involves. Please describe what is changed and why.

> 
> The mon_data structure is unchanged, but documentation is updated
> to not that mon_data::sum is only used for RDT_RESOURCE_L3.

"to not" -> "to note"?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 05438e15e2ca..3828480e0426 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2887,7 +2887,8 @@ static void rmdir_all_sub(void)
>   * @rid:    The resource id for the event file being created.
>   * @domid:  The domain id for the event file being created.
>   * @mevt:   The type of event file being created.
> - * @do_sum: Whether SNC summing monitors are being created.
> + * @do_sum: Whether SNC summing monitors are being created. Only set
> + *          when @rid == RDT_RESOURCE_L3.
>   */
>  static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
>  					struct mon_evt *mevt,
> @@ -2897,6 +2898,9 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> +	if (WARN_ON_ONCE(do_sum && rid != RDT_RESOURCE_L3))
> +		return NULL;
> +
>  	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
>  		if (priv->rid == rid && priv->domid == domid &&
>  		    priv->sum == do_sum && priv->evtid == mevt->evtid)
> @@ -3024,17 +3028,27 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>   * when last domain being summed is removed.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> +	int domid = hdr->id;
>  	char subname[32];
> -	bool snc_mode;
>  	char name[32];
>  
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +	if (r->rid == RDT_RESOURCE_L3) {
> +		struct rdt_mon_domain *d;
> +
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +
> +		/* SNC mode? */
> +		if (r->mon_scope == RESCTRL_L3_NODE) {
> +			domid = d->ci_id;
> +			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);

nit: "d->hdr.id" -> "hdr->id"?

> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> @@ -3044,19 +3058,18 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  	}
>  }
>  
> -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  			     struct rdt_resource *r, struct rdtgroup *prgrp,
> -			     bool do_sum)
> +			     int domid, bool do_sum)
>  {
>  	struct rmid_read rr = {0};
>  	struct mon_data *priv;
>  	struct mon_evt *mevt;
> -	int ret, domid;
> +	int ret;
>  
>  	for_each_mon_event(mevt) {
>  		if (mevt->rid != r->rid || !mevt->enabled)
>  			continue;
> -		domid = do_sum ? d->ci_id : d->hdr.id;
>  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>  		if (WARN_ON_ONCE(!priv))
>  			return -EINVAL;
> @@ -3065,26 +3078,38 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  		if (ret)
>  			return ret;
>  
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> +			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>  	}
>  
>  	return 0;
>  }
>  
>  static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
> +	int domid = hdr->id;
> +	bool snc_mode = 0;

bool snc_mode = false;

>  	char name[32];
> -	bool snc_mode;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> +	if (r->rid == RDT_RESOURCE_L3) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return -EINVAL;
> +		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> +		if (snc_mode) {
> +			struct rdt_mon_domain *d;
> +
> +			d = container_of(hdr, struct rdt_mon_domain, hdr);
> +			domid = d->ci_id;
> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
> +
>  	kn = kernfs_find_and_get(parent_kn, name);
>  	if (kn) {
>  		/*
> @@ -3100,13 +3125,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		ret = rdtgroup_kn_set_ugid(kn);
>  		if (ret)
>  			goto out_destroy;
> -		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, domid, snc_mode);
>  		if (ret)
>  			goto out_destroy;
>  	}
>  
>  	if (snc_mode) {
> -		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>  		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>  		if (IS_ERR(ckn)) {
>  			ret = -EINVAL;
> @@ -3117,7 +3142,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		if (ret)
>  			goto out_destroy;
>  
> -		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
>  		if (ret)
>  			goto out_destroy;
>  	}
> @@ -3135,7 +3160,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   * and "monitor" groups with given domain id.
>   */
>  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct kernfs_node *parent_kn;
>  	struct rdtgroup *prgrp, *crgrp;
> @@ -3143,12 +3168,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		parent_kn = prgrp->mon.mon_data_kn;
> -		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
> +		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>  
>  		head = &prgrp->mon.crdtgrp_list;
>  		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
>  			parent_kn = crgrp->mon.mon_data_kn;
> -			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
> +			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
>  		}
>  	}
>  }
> @@ -3157,14 +3182,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
>  				       struct rdt_resource *r,
>  				       struct rdtgroup *prgrp)
>  {
> -	struct rdt_mon_domain *dom;
> +	struct rdt_domain_hdr *hdr;
>  	int ret;
>  
>  	/* Walking r->domains, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> -	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
> -		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
> +	list_for_each_entry(hdr, &r->mon_domains, list) {
> +		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>  		if (ret)
>  			return ret;
>  	}
> @@ -4036,8 +4061,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> +	struct rdt_mon_domain *d;
> +
>  	mutex_lock(&rdtgroup_mutex);
>  
>  	/*
> @@ -4045,11 +4072,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	 * per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d);
> +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
>  
>  	if (r->rid != RDT_RESOURCE_L3)
>  		goto out_unlock;
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		goto out_unlock;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	if (resctrl_is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> @@ -4132,12 +4163,20 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>  	return err;
>  }
>  
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> -	int err;
> +	struct rdt_mon_domain *d;
> +	int err = -EINVAL;
>  
>  	mutex_lock(&rdtgroup_mutex);
>  
> +	if (r->rid != RDT_RESOURCE_L3)
> +		goto mkdir;
> +
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))

"r->rid" -> "RDT_RESOURCE_L3"

I understand that the check right before this ensures this is the case
but the goal of this check is to keep it with the following
container_of(). Making this change also keeps the code consistent, compare
for example with resctrl_arch_rmid_read().

> +		goto out_unlock;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	err = domain_setup_mon_state(r, d);
>  	if (err)
>  		goto out_unlock;
> @@ -4151,6 +4190,8 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
>  		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
>  
> +mkdir:
> +	err = 0;
>  	/*
>  	 * If the filesystem is not mounted then only the default resource group
>  	 * exists. Creation of its directories is deferred until mount time


Reinette
