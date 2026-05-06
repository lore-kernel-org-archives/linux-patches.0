Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97C035F5FB
	for <patches@lists.linux.dev>; Wed,  6 May 2026 22:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778106499; cv=fail; b=qICOGaEdllnUM31Ek1oKpPWGKcZT7a1KKCbkpPeC1Gi00horrynjV5EDs4kjK9OxOtsIccadIXrQNRZCb74okOIGn0ZeRn7iFsnwQGDPLFKsu8fTzI7GUrWOnFqv2lHxv4xuIuzMOSlNZ0UvYuO5Glwqwbi4p6DGgEdX8TMqGRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778106499; c=relaxed/simple;
	bh=LaFpuS0ba/cQz9hRmQiKhTFDE70SV+H+jxGmYJuH5Xk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gw9+mh6FNmj+Bi30I+bm27m/GZlpltdDMC7S+AyBSqJ7oJOBUa242IwejTPZasxxa58qY0lUWV3fXR+tGyKBuWIzhS7g8UlO5e9sXjbZgyo59KHDhZWRo/AP8y1BZWa9EE8wV45Rkc5tRa6DZlNqQN43RTUDi99EAc/PrK2OH+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kIF2uasd; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kIF2uasd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778106497; x=1809642497;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LaFpuS0ba/cQz9hRmQiKhTFDE70SV+H+jxGmYJuH5Xk=;
  b=kIF2uasdwHL2TYEj2TJ2LBsQOwj4wHnvdF47YGyniuFXm7q8V9EzUGuE
   Lfi7WrKtXfGWize5iChoceHyL3IHUPeCv4sR+cgQguNmqTx6fxn+6K7D4
   sb3bjpE3hICsqm52QPIW3cWsKr83rzbFH7d6QS5wu2TURBbmeZEZjCN3n
   132pSbvABEn+i/R+8QqWuVPrUftofwFfmC7Jhy1kqXOIpRoAXs0xy/8aD
   zIDNABR1MMZD8P6fpwIe0FK73il8rJswCl2IRJ3K0VKiMLRHNTxjWOzEb
   CqwQvfgqbufdP69MZAzdCjvoNbX4Kk9wqOuIcIN+y4hwwt1VwVJXIC8qt
   A==;
X-CSE-ConnectionGUID: 7qtL7JOgQmqUd2IGuY+4Bw==
X-CSE-MsgGUID: GOYbNU38Qd6qh4gTFZF0ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="78201349"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="78201349"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 15:28:17 -0700
X-CSE-ConnectionGUID: oQ5A3C4NRaaqc+GOhBUkGQ==
X-CSE-MsgGUID: URDUtR5uQYeCccdYHsH21g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="240608732"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 15:28:17 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 15:28:16 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 15:28:16 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.1) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 15:28:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CHEVUttPv60m78W8ASUcxQIbYdsod/JJ7qb7d45/WYbvcYcd/mAuKjjaNcCkFu7hHcND/RCKwmkNx9T2fqa+qqdG/o10DIVMG2WxU+PzwD8ZE1mEajuY4GTfJE1Nb6nkMcTisucGPfNBVNg+rrjYpAuh7XqUHZhhs8KPd9ZmE26DWxLwokT0i1vPLyd/psfvhukVxmq4ABWH4JhP3p0Rf/t+YURwwHJaASjrRyhDwWR0gmraibS547zKY2yIprf84ASUVrHtUAmOlmqsCudpZFynKQtn9uKk2Hydo8lQxkyuTCYigcLENxn4S735ExB0epP2sxBFzTMuB07g1iw/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnV3MdbLd0vyfbMWf6H1VX/4+aphTkKxmDTuV86OMAw=;
 b=DZtbt6KIYB1FTOMtjqx3LI4mrn6PIgKQ/R3lo4q8JaPYgPViIQfFjAlotBALCQf1z350H2xci7Ys1RZjVx0gXaTZ/zsyzHXT2Y3dP1gykhYbPyxaSBf2Dk3SIgieC5z87RmSjdS/Q8Bp8oZUXodP3BjIEAwpfOsCgprtwGoX2k6Mwdrgcwpg3feA5dGzS3El/py/vrHSw9aKEHjW/Zp3VCWMfIZEV7nJRFGy+1iUxaO/vom/LmQq4wuqwTb0b7WgO9Vk9Y1zydZqhntAsrKP344rbSly2bz5VPYuP4+GuSbBnna5VdpFkGyYYT1ZoJiLmasK3hLvgffzICUq+PXHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Wed, 6 May
 2026 22:28:11 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%3]) with mapi id 15.20.9891.016; Wed, 6 May 2026
 22:28:11 +0000
Message-ID: <198e6dc2-b57e-4117-a71f-5c3983da3ed8@intel.com>
Date: Wed, 6 May 2026 15:28:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"Fenghua Yu" <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afubI4kYrdWUXGUR@agluck-desk3>
 <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
 <SJ1PR11MB608334A68F7E79E6AF3C324FFC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB608334A68F7E79E6AF3C324FFC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:303:8e::35) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|SA2PR11MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 33f09fe1-b83f-43d9-5fa8-08deabbec1b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: IyiIUGfaKFhMyDnhHt8OwJI+YVIg5iYEMThZW2CPpPWiBq4sE6FNk+/LqsIZ62YHatpDT4Af8dbGdV9rS4W2Q0HgjsmZAPL8LXwb/niJ/C6nAQxlZJPZdmXKb6QjmIm+l1Nz/HQ3TQOhmMws557Q5ZdMIsAqv1nDfLlHkoRKAGbolTlwcB2DlntcKpDYzUv9ve7qL8xAqNttksLY4iQzGwblgyS1sQ0PfE5KSdTACMglqpi74P5UhEnDzqz87nLdWVk2xokvLSw5i+6xjH9LGvSAHAmrF7hkZlcLfk7vQOkLz/0ygpoRGCgUSg0ILveF8LPcZU4W6cYHtrdnO9XwhDEM0+ItTDy4NsnIhaEGQ1UdVyhicf8b8hdtSBDIZRF8WqCK68MiOBnTy5x355WdMI6s0TLRn0e43HAvP69QkMLyY5rkdvBA/qwnp4CZJ/+RZJ5UC07vSNiKdGneLvYwkPskpfczhYyb+xQnMlpMQzTFS54Ma4HIz6qzYiKFhThUoJXmxXT+wEtpSN7cJJjKnaV/N2nfQFDU7aLOFs8vV/0cgrYJMLztKScZtLV/HG4v+4C5TamoTAH2vrerEeItM4djavf5v4Wwzd3hIxOdzqLugT92poILCwT4d9+rzP+ANtNE4M3VD1Yfy2EPK2o7csHs+8zab4mLzz9aJjZCI9DPVlJmQANYDy4VCK0GffUZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0dic1d2QktDRnFYeDZkc3pBVm5sbGUxREdocWdWd1d0bFkxNllRNXRsSTln?=
 =?utf-8?B?b25CR1hvZENNUnBheXp6V1Z5emJEdm4wdFJIaUZUaVkrQ0o3clMvZk5FaGNI?=
 =?utf-8?B?eG1uVjJ4T1o3d1NkQkExdGdxVTZZVS9HQkQ2WkMzcmNQYVB1UzZGdXZKV3dl?=
 =?utf-8?B?aGxaZHlSRHNxUGNRM3BZR0grQ09IOWVpdUI2ajRXY2M4cVplakpwMmc1NHgy?=
 =?utf-8?B?U0t6a21SdUdZMWhHQUxHQkwyajNVYTEza3JPMGQ0NXJ2Mm5PazRTaUZ6VXNV?=
 =?utf-8?B?UEJjWG1Na0lwL0c0aWUrVWlsamFlL0ZsTEN1SUhYU3pCa0xHaGhEVW1kV0xs?=
 =?utf-8?B?MStxOXl4MGVseU53WTdIZEpwc09JeEo4eUJBck04aFlOVDhjLzhxYjlmQ1Aw?=
 =?utf-8?B?UWxHN2VJZGhnWTZiclQzdDJlaXV3bTFDT2dyTnBWNDMyMWdlT20vTUZRR3ZO?=
 =?utf-8?B?a3hsVlVJTHRVT3U3NWxEcWpHdE1BU1BJRkJpVjQzdE1OYkJJMUFBZFpPZC9t?=
 =?utf-8?B?SnR2MmcyN0l4Q1JaZlhyWG5rYlp3YTRKUkYySnNQUVA1Zi9YaWpROWV1OGE5?=
 =?utf-8?B?WTlUL09oaTQ4OTgyNmtBWkVQTXE3SGdyalFMb3UvQmFQb2V1N1kvVWs1Vmxq?=
 =?utf-8?B?ODJScUl1OUU0QjBGVHdTMWFiSFc5MmVVZTNxdjg4TEh6cVRCYnptVklVbmZx?=
 =?utf-8?B?Vk5tRUJFelZvVUI2bTlIUXJTVXI5M1VvSVIxcHQ4ajZrNzlZblhDUkRuNW5r?=
 =?utf-8?B?aVE2QlgwMXR5Wm5VV0xQN0lyMFlXc0liZ21lK3hHNGpMTHNMdjM4eUUrTTU3?=
 =?utf-8?B?THpYQlVLSjh0VUxxOWthczVORlEzejMydEQvY0owNUh5Sjg5V2VLaXcreEFX?=
 =?utf-8?B?N292aUZrdVhacDEybkxoNzEwbXkwQ1Q1MDRRREV4bytaaXV6eUF1Yk5pblhH?=
 =?utf-8?B?eUZqUi8zekl6NVJ2Mm5PUk8rTGdNNER5ZVRlWENxWm5vc0czNzczS295Mktt?=
 =?utf-8?B?TDVNZVBtZXVvd1dVYWQvT2tZbi9jTUJrWm85cU9WM1FueStiUldEV1hNaGZR?=
 =?utf-8?B?cUU2cU1vRjU5UmloK1NxZVlTNXBXWXpzYURIS2MrQjRtU1p6NkpqUlExQ3d5?=
 =?utf-8?B?bW1YTlNwK0NjQUlHbUNyT05YVGlBZFlCMzByQVpPb1hsaklxd0I4NUl3eDNB?=
 =?utf-8?B?MmdlcTJNZUtEWkFkQWVENEt3RzJIbWxPY29PMUVPODlOZDcvZFhQS2FVdGxB?=
 =?utf-8?B?RHpsZlVVaTVNVG9MYUovckFEbENRTkRJVXQ1Yk1pVVBvZGU1QUZBZ1lxZVdT?=
 =?utf-8?B?Uy94WHRWRXFIb2JscjZNd21aV3pYWnV0d1BZQnpvbEorcDdYOW0rZmhsNk9M?=
 =?utf-8?B?bXhsdzlOdGNPeG1ocWJYNFA0YlRRdWVxbWN2LzkwTnh5RnV1clRaY1poSEdi?=
 =?utf-8?B?MGYvdktSTTRjS3MzSUlRVVd1Rkk4cFN0RWtaMUwyRHFtZlVJWDY4K1RUTGpY?=
 =?utf-8?B?aldjRXl6VWQ2NUpINEpaN2h0RWZSSFd6aVJXU3VTRzFrRmpQWFhsVUlyaEVF?=
 =?utf-8?B?cnpqcmdLb2pYSmIrZUFiRTZIUjljSGlRcW9GWTRoRk5wd1p2YVVVeU1lMVdy?=
 =?utf-8?B?d3hNTzFGaTRPTHZHZzZ2UHpXckZFSEVWSENOaWhncUROS2hoeGJkaWlzRzI2?=
 =?utf-8?B?dHdLa20wbWYybHExbXRKOWxFVEJ0d0RZQmJweUFnUjZyNk9FbmFzYzEyUHNJ?=
 =?utf-8?B?bjI2WVN2MXpuNGNqWjFidTcxam9jZXNnNklWMFJEVWl2Y2h0bjdHcjA1cEUx?=
 =?utf-8?B?ZU5NUEtBaDBBWVRtRXA0VURwd0VRQUROR3MvWllLdHhhQVpiMDh3R1hmUG1C?=
 =?utf-8?B?eFdjVjhzcURyUVR0eE5KRis0dHN0VklzU1Z1Z1ZhSXBHQ1Q5MzJWSFJRK0Vv?=
 =?utf-8?B?OFZRaHhudlAvNGV0RjdVM0JKdkQvbjRRYVBOM0t4eE1FL3NJcDRUV2poL3Rm?=
 =?utf-8?B?NllZTjR3WmFNS0JSSU95YTNvUGc4dkVFeHZJWjROVW5HRTVLWHlKTjhyaTB6?=
 =?utf-8?B?c3FuSERCOEpuKzM1aGpCUnJ0dG5YNkgyT2ZqUlBQbVMxYXVrOENkUGRWK2xG?=
 =?utf-8?B?YXZ6NEoydnBxWGh1bDVnWlRHeTErd0V3TDZubGZCYkhUYmFXVVlieUoyaFkw?=
 =?utf-8?B?dGxsZnJET3EyOXpHdzFjcWo5RWNMRDc2NWhSQmJ3Y1FWOTJPMEtFT0l0VTc1?=
 =?utf-8?B?ZEZCWWdQTnZucktKRWFXRnphZzRaY1hpOHRWZWdlWHdrQXdXZ3RYelVmb1lO?=
 =?utf-8?B?Szl3MG1tTDZWcHRPRG1RQVpMWFozZlZLUmV5UCtTdFlTVUNJbTkwWXZmTGxi?=
 =?utf-8?Q?v3j7hn7SCxL0uXKk=3D?=
X-Exchange-RoutingPolicyChecked: t7qJ+Fz6YwqEJqDsB01t+QLRbvSOmSe3CHVZDQMPd+qiLM1cWofPA2GCFG34Q7XaD+ChrzzOEqN9I89U2l+K5XPZlEFfGCpi/j2amFRT9E2EqlYiyn/VlW16vQtR+qNayy9pHhYyKhOQ/o+X4Vmtnzd50TpQpHVovi5x6iFb7AWL8zkU/Nk/zfbkh0QQCUegtTOdQOwyHIRBt17yL/HmfoSixeFqwu8EWSjhxWB+GCLgDDwbX4PEMGftByWF7+YiiJegdbtBwKuys+6RCHpY4MS0azDp02cYQGqLoHynv5NzYInWpMp4FCG0s0QMRyqdOV6+C3YW4NpQgYLt/TRJiA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f09fe1-b83f-43d9-5fa8-08deabbec1b7
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 22:28:11.6956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3Ef3bT+JrZvlOmruF3WtyP+SrTJRW4JQKOZgr7yjucTFmuCVvYmo/Iv4kI8k2l896a492QNuc884yTG3/nX7Uiio+HIARRpU5vzDttsIhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com

Hi Tony,

On 5/6/26 3:11 PM, Luck, Tony wrote:
>> Unrelated to this question but may be worth a mention in the fix is that this work focuses
>> and fixes resctrl to not access freed memory from the worker self. To complement this it may
>> be worthwhile to highlight that it is safe for the work_struct self to be deleted while the
>> work is running (but blocked on cpus_read_lock()) based on the following comment from
>> kernel/workqueue.c:process_one_work():
>> "It is permissible to free the struct work_struct from inside the function that is called
>> from it ..."
> 
> Scope increased from just the use-after-free when the domain was deleted. The case
> for taking the current worker CPU offline doesn't involve a use-after-free. It just results
> in running the workier on the wrong CPU for one iteration.
> 
> Deleting the work_struct inside the called function is different from some agent deleting
> the work_struct while the worker is running.

Right. I interpret this to mean that judging the safety of work_struct removal should consider not
only the workqueue API itself but also external agents that may access the work_struct after its
removal. The current fix addresses access to removed work_struct from within worker itself while I
interpret the workqueue API to guarantee that there will be no access to work_struct during or
after worker execution. The fix under development thus makes it possible to safely remove the
domain even if a worker belonging to it is executing and blocked on cpus_read_lock(). Do you
see any remaining issues here?

Reinette
