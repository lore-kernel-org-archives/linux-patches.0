Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489F01FEFCB
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 19:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731439493; cv=fail; b=DpxM3469ufP4PUCdvG/hCqBWqR//MkuOV/YVgmZcEW/vR1QNu/1NqRkpNHN7yzpKS68z31DiXOU1B8ptnx/iS5dC3uLvVag8sh+QR3/VbTeOG14mMMETZ0H60Aie5hc4OZEvLi5rsTGgZJWU3rNOssAmDs/e/0bmPqv9XM82fHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731439493; c=relaxed/simple;
	bh=84PCVK5jEwYPcRBJ++HGWd+AbmQhpc4VFnWorPtk2KU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FMveexObTYlzCG78RcGXQTWEqC8aQK4rmTSTVjDNL7l8oBnocyAHG4va61cgtYubcfj1qunvxN7XT01ES6Rn0P8hANsVmwg0TA3gxkV4Mogb7SkNyO3sEoYE3Zg0XZ8dmxNTY5RFLSRfrZzEy1V/tHQGdxyX2deaAM6K6c0jivY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bRGwvrC/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bRGwvrC/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731439492; x=1762975492;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=84PCVK5jEwYPcRBJ++HGWd+AbmQhpc4VFnWorPtk2KU=;
  b=bRGwvrC/lUL4kaaZ7guTFDTK6WjsLu+g8A1m1ZrlbYfWBQjO+iDmfeBo
   zwE+/Jfd1IdnTnRzMuBEeIebEJUj4E6epcdaeKrTFlgPsIMTDPRAqG1F/
   /li3BFRxrRAdQo6dXmLrHXLnrICT1IrHr1RfWF6qKzftCL/DieGRjZq0y
   D5IjwsYQ9GBrwm57ZFJB697hEeEyhcEzqh9/yXOOytkdhoi0icaojRe5E
   K9WP4aE+akdtjr0rvf80t3ZlO7FjX6V/+k8A6wlNAN2Our+0XoBe9Vm1O
   sIIOt3qu4m9XRLACP2hYGcBCpynw173Drx0yzPvKkzKStQxo82q646+qh
   Q==;
X-CSE-ConnectionGUID: uHeumO3GRLmbUENgS8SSJA==
X-CSE-MsgGUID: ziYJNhhwQRiS0ox6O7dXgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48754553"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48754553"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 11:24:37 -0800
X-CSE-ConnectionGUID: BMvTWA4ER+q60g4klHaA9Q==
X-CSE-MsgGUID: POogZ6ChQ7uA192hAHxmNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,148,1728975600"; 
   d="scan'208";a="88019496"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 11:24:37 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 11:24:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 11:24:36 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 11:24:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QoE7hG0jn7s0S7ZaIno4gm8qy5n8sEeeEtVe8o25fN91FI/rkyKGAa/+dgQ0mjfNiluvItd+da6sHpc41aU+aWJ9u3kB5kwuefnS8nOwXeygX9eijcrXecvh6iK7vALJRQLGYrFzIrdbC1f884Vm/u38WD+kFLAD0s2DdpDLhh2iIHIMKAADzn1tGfdXAOkSJO2/HM2po+b1WoaLEcc1wyP1Yi1bknqVL35TPxw70dhYvAVwnghRnoC+UBaISJ0K6qalcop+h/81JnG/FUnBAX9oEfDJ8yLINdbkAdyKMj5AT5VppnVL0I/zp0oDPpXG7BWf3w/KD+MkvVYRBU4oUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ev/YAxs67yzZBN07RA7nUKGnEmGBwl6x/Fjwkr6suak=;
 b=keiJsyxFQgjQEBWR4RFteJW2F7Mh1M8tdGJx7M+RXjo1wkBp3s05UY36UPIJfcYsw09e83464tqdluR0z6rQMeDaiqbaeIvMBQSzfb6aDeZeQR5xNQPDS9LxKp9S6J/Vgq/XPxrpuF/L8ySYwcZpKX7Qej5psVCLgSE1y21922rBTKTItBhTci3Dq61u39+PoEUQWEcMM1NHXw2Meyzg0mVn35OB8otQ+ngAJCM0VCqdt+y7kDHNQq2UN2eCW4KG5wWtPaepgCJqln6swTU+73WRVnvbbihy7Ydnt2kMpMaZVwoq0lg4JYAjJhXCNJA6IxrklSIKPDxK+kvoI+drtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Tue, 12 Nov
 2024 19:24:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 19:24:33 +0000
Message-ID: <884d8020-8057-4748-a981-2a6f8f127c45@intel.com>
Date: Tue, 12 Nov 2024 11:24:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/7] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241029172832.93963-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: ab5d463a-6053-4648-2898-08dd034fa308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q2dtYmVKQXZZZ1lta1FMQ1ZIRVYwZkU3ZFlQY0lmRHNnMlE1Tjg4UG9ZWDdK?=
 =?utf-8?B?N0M3di9teDRBSWVvSFVIOGZTekxFM2xUSXVGa00rbkJQdnJkQzdvcmtEeFBZ?=
 =?utf-8?B?cWgydUQ2RXNzaTRLU3FrVkU0dXZOaFlremNTaGE0SFRPUnZrOWZMZVBuOTNQ?=
 =?utf-8?B?cXNSUjJ1TFR5ajhTNTB3WFhXK0NFQkJ2bkV3VEtUOGpubkJGUVg4VFhPTUZB?=
 =?utf-8?B?cWUxWXY3d1BwWStwOHlyRDIxOGo1RjBZZmpoR0dvbkF6dzBOR0FGR3EvZ2hY?=
 =?utf-8?B?ZFh2YU5IQXJYQ1piQmpFdmpwY0RxZ3hleElsdHhkZG9TQklwYitJOFdqRFB2?=
 =?utf-8?B?ejNQM3VXRHBZYTJHa3lVaUliNXBqNWhnbUYxcnNHRzJJQ1o3V2lHUFVLMzln?=
 =?utf-8?B?S05UakJRYUpyYnBqd3FYU1pNRkc0d1FhbzJuc1ZKWHRyWjdNdlNzYVRhVXc2?=
 =?utf-8?B?MXkzSENmTWVxeThzcEhoakJBNS9mN1ZmVmR3MWNNOXVOeDgwZUcwWm13VlhR?=
 =?utf-8?B?dDhYRW1udUZGa2ZWSGt2aVRhV2Z6MFJkMXc4TThWUVByZjhQRTk1QmhWMjRi?=
 =?utf-8?B?clozQldhdVBnSkwrVDlWaE8xOXk0dm9sMmtialVPLzBYZDloc1NVQ1RtdnpT?=
 =?utf-8?B?bXQ3bDV5dDJPU3NFelk1RGk4TCtodWZhT1F3TlpKT1FxZWVlQ09IRGtObC9U?=
 =?utf-8?B?VjdYcEQrUkRSVkI5UXVLZDQrRE1qT1FQcFpEUVh2TUx0NTVBWjlhK0duT2dP?=
 =?utf-8?B?S1FMOEdCaWNyMWh4bVMwcW5RNnZ1cGRkN3hhRUlJTWJMSGp1RVQrWm9JbmU2?=
 =?utf-8?B?b3RLdy9oenRzQ0E3YVR4VEN3MEVUYlROdVMzbUR0cm1hVC9PV1JTclRoZk01?=
 =?utf-8?B?SkpVRjhSM3N3UVlxd1J2ZHg4QUNpdXBhNGt5dndyT2kxdmNqN0F0QVl6dTdX?=
 =?utf-8?B?b2gzWFVLSmN6cGUwenhicGo3TEtnSllyYlg2MzhSQlNxZnhnZDVQdDYrVDdz?=
 =?utf-8?B?RVBZQk1TQjJJYUtwSWk5Q0I3SmxCU0ZKMEVpNk9EcTdLS2ZOU3ExNHZWSUdR?=
 =?utf-8?B?MkNPYW1WZTRTN2o0VjZybmpUMkRNdEJTTCtoOXh0Q0dSUmpxRTY4ODQxUitB?=
 =?utf-8?B?QjRsVmUzNGpFMG10dnRoTG1TTC8wV2kwTC91Yk43c2h1enNkS1pQVmNpUkd1?=
 =?utf-8?B?cXNqUjdBNkV3QWpTaEhqNm1iWGd4Q29YTTh0eG9HcHQ5dVc4SWMwYWMvZEJI?=
 =?utf-8?B?ZVZLMXhORkRMWlJ5V01tOGdLNW9vNEJRWEIxaGNQdm1BY2JkSUNXVHpyb2tO?=
 =?utf-8?B?N3M0dzQ1RWdEOFI4djl2R3FkYWdhUnFsc1ZLTndselN3eWV1eWVhMmJDdG5J?=
 =?utf-8?B?RDJQNk9iS2pqc0M4Qm5NTHlzRU1sRjVBb2Yxc2JTTHpWTW50ZkFjRVNDWW1L?=
 =?utf-8?B?Qnh4bGw2dmZ5aGNobnRYckZGeFlTUEo3d1BnN1hpUHN6QndjSnZES0J4MWkr?=
 =?utf-8?B?MEl3cGVCLzRleGxWNGJZUERvd1lSS2NxajFKTmVXQ0E0SjJkVHI4WmQ4TVJJ?=
 =?utf-8?B?dWNBV0RXdDY2OFFUOW0zbGZvZmFWRmFVbm9RR0NCY3RqWUU4UTBTRjVSNUpR?=
 =?utf-8?B?dVBpZlFHQyt1bncxRnpodG9GR0JHdzhCNmovbjByU1JjcWhqYkNIdmtWNHVm?=
 =?utf-8?B?T2lERXN3aElHTEk4UTZ6WnBzbTl2ZmR4NDVnVVpyRW9tS1hPb2RnMTk4eG9I?=
 =?utf-8?Q?siL48L9voTOYxvqZoJb3aI+1o+mdMz0Q23qixLG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0srcmxXRVBNc1A5bU9qajNEOUptVllHbEllZlhhUjQ0TEVnVWl0TTRMVzV6?=
 =?utf-8?B?d3VTSUFmazdCak05cHdDMHI5aTk1bUR6SC9ZWWdDUDYwdlUyL2FCYjJidHR2?=
 =?utf-8?B?amYxWmxnSDZBVGNrdU03MGJ5UGtkbWpsSFJ1aVhlM25NUmtIV09qMlpON1Q0?=
 =?utf-8?B?QW03bTliR2ZWUWdMbVJHNHR5RUFCam5FVjVQVUtza1BGUGFpZVA0QTNOVk5o?=
 =?utf-8?B?dDV0SVNQeXRxakZHcVZJQ3hQdFAvbmRnV05ieWhDNlJRQjJwNDBaaHJYUEEx?=
 =?utf-8?B?OFd6ZWlLcmJIU0lhYkFWQmF2VVJ5aW9GbU1zQkV5bXVraGZLODAzSGRhUmtM?=
 =?utf-8?B?cU5uaEE3VXF0SkRHMVQ3VTVsdFJ1aDFTb3NYcVNtUkIycTVGcnZCc0FpRTll?=
 =?utf-8?B?TVNhdEduTjhPdXNiaVFaUmJjOTBuSmEwVVZIb0hBcENieDJSQ0V4RGQrMGhp?=
 =?utf-8?B?bCtFVzFlbElFNGVReE9xNG9nWTZFMm9tUUNCQmVVYWFqWjdCRWdDdlNyd0t3?=
 =?utf-8?B?N0s1YVQ1bHRWRHhVUEEwSTJlWWprZkJ0YWVaejhWdDFvVlhKZ1ZRQVUzRkR3?=
 =?utf-8?B?WVcxdmJybDdDK2tvV1ZWeSs3MWxTNUZUVW9GRHNRVS9CQjVjY0Q4eEs2NkY1?=
 =?utf-8?B?Z0xaeWRTWXhqQjlVTFd2anhIRm1UdnBpQS9wZDd0RzhoVEFjcEdwVXk4TFpJ?=
 =?utf-8?B?bEtHOGl3alg2RnJwYTVacDFKVk9zVFI5YktiaWlETzkrd3BMWUxRYXNRT2lM?=
 =?utf-8?B?ak1TS0NGbzBMRVRMTmtFUFl6L0N1VVY3QnBqczhrd1NzY015TGU0ZzV0L1dF?=
 =?utf-8?B?enYwaFlUa08xNWNPWkRlY0lQNHo3V3ljNGQ2UmwyTC9LNmN5MkZBS3JadjB6?=
 =?utf-8?B?SjFzVkVkUDJ1cTEwSHJvTE1MRk5RcWhaVlpOYVpGTEdmc0VCbE9aQnhkd05F?=
 =?utf-8?B?aVB5cWRqMjVLdXdZZURDZzlvMEVkM3RsNFUyRWV0Z01VNUJERVhqbCsxY3dH?=
 =?utf-8?B?dGRoc1dXb2hSeTJ1dUl2WFpXNzRJZVRjNzdKT2hBVWdrMTE5TllJc0k1NDBU?=
 =?utf-8?B?MjRGd01XdkFRSG5KVmVzRmtCYjcxc2Fod2JjaWhCQ0lteU40QXFXR0VJQ3NP?=
 =?utf-8?B?TkYzOUpBazd6V3FxdkMrMmJpcksyU2c5VGJ3MHdMV2xZVkRlYXJOTEJ0MzlG?=
 =?utf-8?B?dTdZaThmL1V3WTRIZUpoTjl6K3FLRk9xazJkcHVmbHkzVXZvSjFJOGVocS8r?=
 =?utf-8?B?Q01uWFFvS2swaUxiUGFmN3FTSVFpYnFxQzJicnliYitReW1ueVVXKy9tcFc2?=
 =?utf-8?B?cW1oKzF1cWRDdytuTDZZMUMvaCtpQXlxU0pyNy9yZXA0Sm9rMTFMRS9jS2tl?=
 =?utf-8?B?eFhoTzFlN0V3THNiczhTWW44K29FbDJkOE5Gbnd1OEt1NG5tdU5sL1JpVDNB?=
 =?utf-8?B?TEYxSFJiYXZLbFo0dEJvQStZQlZmQW9lMkNiMDdwWHZtN2M1d1NYZUI4c3M0?=
 =?utf-8?B?S3U3VmVjRzlCR2xSaGJHOWk1ZHFCOXJKTDE4dVNBekVNMXhZV1hQeHo0QjdP?=
 =?utf-8?B?VkVSa1JhdEVzRXhCd3BRWXhGOTFMcmJWSS9PekxuSFNsUk9FTXIxSGNxTnhG?=
 =?utf-8?B?dGR5S2VlaEZIdmtERjdzMW9OZFBwRUhhQ0tRR3BydlBPYWVlWjBpT25TWHM3?=
 =?utf-8?B?eHdPUERRZXdKamxTWkpNR1dDeEg1UGowellUZVU3NW1mREdDK0o0Q2tLS1Jh?=
 =?utf-8?B?UGZlVll3VmhXT2ozTWxjdWkrTHZQTFVWdE82WGVXdmhlcitrNHg2MTF1THBL?=
 =?utf-8?B?V0tCWHJYcGU0U0E1dEQ3ZDBZdGhOdTE2MncvMngrcU16c25BMncyWmdjVlMx?=
 =?utf-8?B?T3BVSHZoSGExSDIraDNwU1FMMWM1WTY4N1ViR1BFRnQ1emIrcTM0QjBPYzRh?=
 =?utf-8?B?Zy96UUFueFQzdkJpa0M0L1RVRHhBVmt1ZTlDRXIyS3hQeDZ0T3dVZ3UwMnlt?=
 =?utf-8?B?YWdaVXRka2JiNkkxTlJsYXlCRHVvSFNXVFBVMzRiOG5HSFJITlc2MElhLzlL?=
 =?utf-8?B?N0pGY0VaNDBnWm1kYkY5elFKMTZtSGs5RThURGMzQ0dDa1hXYWIzVUk1T0pH?=
 =?utf-8?B?WEhMVmdMb1V6dWxaWVp0M2ZkZHlJR2RWRkR6a2xMZEhDaU0zUXB2bFRrZXN2?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5d463a-6053-4648-2898-08dd034fa308
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 19:24:33.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LFO80DUQIJXhPGOpO9uuEgq7yDzfm2UhGj7/Kd60I+phyITcgc7cLcWlekfmbDCKI/mOTBwbIiZVtj4X21hKMJDtoL7WUZt830Ho9a9MxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/24 10:28 AM, Tony Luck wrote:
> Resctrl uses local memory bandwidth event as input to the feedback
> loop when the mba_MBps mount option is used. This means that this
> mount option cannot be used on systems that only support monitoring
> of total bandwidth.
> 
> Prepare to allow users to choose the input event independently for
> each ctrl_mon group.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 2 ++
>  arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
>  arch/x86/kernel/cpu/resctrl/core.c     | 5 +++++
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 6 ++++++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d94abba1c716..fd05b937e2f4 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -49,6 +49,8 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  };
>  
> +extern enum resctrl_event_id mba_mbps_default_event;
> +
>  /**
>   * struct resctrl_staged_config - parsed configuration to be applied
>   * @new_ctrl:		new ctrl value to be loaded
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 955999aecfca..a6f051fb2e69 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -283,6 +283,7 @@ struct pseudo_lock_region {
>   *				monitor only or ctrl_mon group
>   * @mon:			mongroup related data
>   * @mode:			mode of resource group
> + * @mba_mbps_event:		input event id when mba_sc mode is active

Referring to mba_sc as a "mode" is potentially confusing when considering the
line right above it (specifically, mba_sc is not a possible value of @mode).
How about "input monitoring event id when MBA software controller (mba_sc) is enabled"
or "input monitoring event id when mba_sc is enabled"?


>   * @plr:			pseudo-locked region
>   */
>  struct rdtgroup {
> @@ -295,6 +296,7 @@ struct rdtgroup {
>  	enum rdt_group_type		type;
>  	struct mongroup			mon;
>  	enum rdtgrp_mode		mode;
> +	enum resctrl_event_id		mba_mbps_event;
>  	struct pseudo_lock_region	*plr;
>  };
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b681c2e07dbf..5b55a7ac7013 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -958,6 +958,11 @@ static __init bool get_rdt_mon_resources(void)
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
>  		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
>  
> +	if (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID))
> +		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> +	else if (rdt_mon_features & (1 << QOS_L3_MBM_TOTAL_EVENT_ID))
> +		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
> +
>  	if (!rdt_mon_features)
>  		return false;

Shouldn't checking of individual monitoring features be at this point? That is,
after confirming that there are indeed monitoring features?

fyi ... since these checks are not architectural I expect that they will
move to resctrl_mon_resource_init() as part of the resctrl fs/arch split.
https://lore.kernel.org/all/20241004180347.19985-17-james.morse@arm.com/
This move will be supported when using the helpers as Fenghua suggested.


>  
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index d7163b764c62..dbfb9d11f3f8 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -65,6 +65,8 @@ static void rdtgroup_destroy_root(void);
>  
>  struct dentry *debugfs_resctrl;
>  
> +enum resctrl_event_id mba_mbps_default_event;
> +
>  static bool resctrl_debug;
>  
>  void rdt_last_cmd_clear(void)
> @@ -2665,6 +2667,8 @@ static int rdt_get_tree(struct fs_context *fc)
>  	if (ret)
>  		goto out_schemata_free;
>  
> +	rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
> +

The pattern of the default group properties are to initialize them once
in rdtgroup_setup_default() and then do any needed reset in rdt_kill_sb().
You can compare with how rdtgroup_default.mode is handled.
If existing pattern is not acceptable then it could be reworked to have one pattern
support all scenarios instead of fragmenting the default group's initialization and
reset.

I do notice that the current MPAM proposal I linked above calls 
rdtgroup_setup_default() before resctrl_mon_resource_init() so I think that
needs to be swapped to support this feature.


>  	kernfs_activate(rdtgroup_default.kn);
>  
>  	ret = rdtgroup_create_info_dir(rdtgroup_default.kn);
> @@ -3624,6 +3628,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>  		}
>  	}
>  
> +	rdtgrp->mba_mbps_event = mba_mbps_default_event;
> +

Should this be in the "if (resctrl_arch_mon_capable())" section? Looking at rdtgroup_default
I also do not see any check for whether monitoring is supported. Is this intended? 
mba_mbps_default_event is only initialized if monitoring is supported so it *seems* as though
the value of 0, which is not a valid value of enum resctrl_event_id is intended as an
"uninitialized"? Unclear how to interpret this implementation at this point. Reading
the changelog again there are no details about these subtleties.

>  	goto out_unlock;
>  
>  out_del_list:

Reinette
