Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC75258CD4
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486063; cv=fail; b=qbi315QZ5E0RdXao7SKe4onfMHAhV6O4GQmpd3/hWF93FHrKRaWog6HIeEvDipL4TFhT7W6EEipZ2kRLU6uRgOQuactSc2xsiHvCgnG79kP0q6cNJ3C14yPTsRXi1v0wsyV0n0+Pua3PaTzk98BQdUL8syz5jh9VBYiS3O/nKVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486063; c=relaxed/simple;
	bh=E0MRDLgIfEgU2FDZuJKdkYe+y35efGhGUY/YBlXfNd4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=paQ0Dg0v3Av6n/QVmBhr9l2kZTO4EeJufTnqWcWXnbo8KmUyNJiaWyDHJXCcZ153pn8+XbOez0hbhfN25thX8PaGFaSt1oo8Ps1hjNjB0VzPkLmcq5NW5gnvUIfn8FvAByTQqyULQdGsUphYTmRXdjZDYf4FOQFoybhPii/x/LU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dWrdZMRu; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dWrdZMRu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486062; x=1785022062;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E0MRDLgIfEgU2FDZuJKdkYe+y35efGhGUY/YBlXfNd4=;
  b=dWrdZMRuBzWORv8CKXoti34gMYNc+bo57J4dRbqchUMB+lVDIzaQJsD+
   IByjvPBkgsW7pkhHP2LCfanyfX0DPurRMXI24tkM7EUN1FueS+/m1jdl6
   UtTBcWBdLjdaUgCCUeR6zvECNAUwxJsmeWXvRdQPNmAoBC67nVk0slPUV
   5ubm1+fzGuEcXBTVTjh3VFPGmSYDpsapR7+21e57QPw/m2JvYReIprhnx
   oR0h7X88XJx3p8BjoeZOlkY2sLOGtIzMYpk9fqnIp+hVikzF4+Wgv2S2N
   dXLrrPMZAAimfPE4ukq0mLzrYYWI5SuTGbudBxXhlx2OexiTtkL6TTKfc
   A==;
X-CSE-ConnectionGUID: VFNwOOBVQ7WVtc6wrGLfww==
X-CSE-MsgGUID: dMzNRcetTpiVPdqpNk+Vgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="43439794"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="43439794"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:27:41 -0700
X-CSE-ConnectionGUID: ibU5xH3fSZOytZiIrm3NGA==
X-CSE-MsgGUID: IPEN7Z1EQdWJrtVA6pnYBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161423518"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:27:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:27:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:27:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:27:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UluJpR4YjswIQX8S/OMTORobY8zj0f0YDRX5Aqtg2grKjzRoVfAGslVyOqbtFAC+cupMgIsXTMbXC6X58alF+XIhxTEEs+NrPccSNcqYiSRAhSasfc42osxgSgufxrpxhkU9n0BLF+/WGbtRB1RTdHsXlfLhhee2IcmM3effyqwgZ4e1zV00xob/yKHDVdx9S5MevP9GD4XUuGZKWfoFHxc92mchgCxgiKW/fGaqd1GsWWhT+CZVvhEZsDnP95s9lD2bxtuTzAraHkAI3z9SgjoGcSEVsLJzn3Ral3gdgGfELIy+sNoLOtza0J3kjUgTGy+biBo8ykgPuIe/F2ghdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xKoC8xON7Q7dmVGrf/2X/mH2gy79pkhvmhShKgFSWg=;
 b=p7wEvxhy4NszAJrb+PGmKg7dqUOkuaIfsR9VcCwCkRlI44snRMhmoz/5sFAiuMY+wk3ebEkExF/Dup0741ir9gsi0zPPh+3HxOB1Vr07e95mjPHP+JAseKCrr5AnVSjoyqpCeDldStLYKa90lddEqy/8x3ietfB0rg3qv7GQoCAHcu7XdM4chYGFsZ3gSG77fJTta8z0cRxUK5JhbdoKv25dVmbpkkd/voD9ufxp90RcQO7/9T8yH4dlbgoVIqnn8ldJckKemomTOj+GBhPGi4rPcSRAOQ+65b4cSVyhyPo28QEwlG33R3Z01nVnfM2ZmuOBiaT+AioE1YKTMyx1Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:27:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:27:38 +0000
Message-ID: <6a69ff53-5c3a-45d5-904e-dfd3f58b6472@intel.com>
Date: Fri, 25 Jul 2025 16:27:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/31] fs/resctrl: Make event details accessible to
 functions when reading events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:303:2b::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9c0392-8670-4817-3774-08ddcbd2d7e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Vk8vUHMwRUhuZ2I2MlU0eWpWQ0tYYkNlbHJaaWI5WkI2eDdlZDVnYTJFMFBQ?=
 =?utf-8?B?TmZEZS85RUJOK1J6SzBoTkRkYjB1c2pRQktTZXFRaUxmM3JVbDJpLzBzNkRy?=
 =?utf-8?B?VlNhOHJMNGhZYlNUKzEyS3dQcXBXRkhJY0xnTTdlOWc0U1hJb254RTh6VHNj?=
 =?utf-8?B?Q1BvUHdSZDg0UE1LL1FQQVQ1Qi9oY3VpV1Z4YVBaMzFINXY2eGtrTy82M0p2?=
 =?utf-8?B?ckRDeUlIcmQrdDUwUnhxbHVWVmtlTk9wVlhCQ3pZZkJYVUQybURpSTQ5WVl0?=
 =?utf-8?B?NzMya0dGTkorNnVkYWdSUXJuSjhadmRuQWFjWTZCYStkSXVabmFjZm90NkdJ?=
 =?utf-8?B?cUZlejU1SXRUb0dud0cvSlJ3QVNDMXBBbjJaSzFtUUxaMFN1SVZZUGNTdWNy?=
 =?utf-8?B?K3dQYXhMbVN0cFNLU0ZEazcxMXllOFNhWGdzODV4N0tKOXV2WUpadWt3cE8r?=
 =?utf-8?B?b3RqMWFMTE85a0xxZVlZNko2T242NjdjaSt6aUZrbENRbG5iS2ZudGZXb2s2?=
 =?utf-8?B?QnVWU2J5aWRZVzJFQnpPcHpYRTdjR3RudUIyUVlMQTh6RWd6TStpbjlrUTF5?=
 =?utf-8?B?VCtoRTNkdFludWFwU1U0VWhNSWU3WUROR3k5S3BnMXNQMG4rNndkWndWWERx?=
 =?utf-8?B?Ui9OZlp4OWU0OTU3bkJYZURVcU8yMjNCY1dVRW5PcHRLaGgwaUtuQ0lZd3kr?=
 =?utf-8?B?d0huUTg3V0p6U3VhTlNsdERoWURmeHlDdnF5U3FsOTRXQzRobTN2RmhvOXM3?=
 =?utf-8?B?QU5lcnVEYjRoZjRnUFFzRmNWdzFZRTFIV2M2REo3cHZRM0E2eHpLd3RmSFAw?=
 =?utf-8?B?d3BWWmJwYlI3SW5HREdhRDltaVpXaENYWENWbWNQaSt6VTB6ekJtTDhrTWFV?=
 =?utf-8?B?N0Q3OVZNdWdoZDlQa2xJWkU0STNOQ3ZpODN3UXZKY1VtUzZ3MkxVTFNkMTFv?=
 =?utf-8?B?WmdsYlNxNEswNFV1MENLT0gxeVVZZTB1SDd1QzMveDhmcnd0bTRUS0FSYkhv?=
 =?utf-8?B?anJLMDFWODJvNUFBWVpIYVBvV0FGOHhZWnJrQXJYSXg0V3h2NFVvZ3RCVkFW?=
 =?utf-8?B?NVV0VWxNRE9tNHhpd25GR0xzT0NLNGRNZkdBUWY4T0U4SVNUS2lBZ3F5aXVa?=
 =?utf-8?B?RzY1TENRZnA3Smc4NU9nMWx2N0Z2dDJOVzRjSmVCK05qbU81eUkxS0lhcHpo?=
 =?utf-8?B?Y094YnYrZTNLaDVBZkgwN2p0dEh2cnJPS0paRkptNERNLzB3TENPL1IyYkdT?=
 =?utf-8?B?dk51WEZoOFRTMElVK0VvcU9ZQVJ6bmthV0xBU3NHTnJlK1pBQ21xaVZmSXpv?=
 =?utf-8?B?VW1vdUNSMVBXQnRmQmlKZmtzWVZSQlo4c254NWdjZDBvYXY1NWJrZngvdUhj?=
 =?utf-8?B?MHk3cG1kOGJCeDNHZlVBN2o3am9sZ21sWnJGTGtUMCtqQVRlVGFrNW1qOWs5?=
 =?utf-8?B?MU1pVDBSRGVXWVE5N2pjM0NkNXBVYXFjVmsrZFlZWkhoUU9YS2FleW94eHU4?=
 =?utf-8?B?WGRtck8ySGYyWElla202OXhLT2lVaUp3SUltb3dlTTJMdEFUSldFcUltcmh0?=
 =?utf-8?B?RXB1Wmw0OENYUURvMmRYc2pwQmU2S0tBTjRUMlVleWsrYVZSYWZpOUljS1Fy?=
 =?utf-8?B?MlNtUGdrQnlNZVJ4S1lURTFZNFlkZ2hvOVFpRSswUkFrcnNkd1I1RHZUSGVn?=
 =?utf-8?B?dnNLRjlNbmxSL0FjYmdDZEE0ek5kL0ZZNS96Q3NsdmJCUTBybE1HbGYzcThw?=
 =?utf-8?B?WmlJOWFiNHdiUVg2MUMxZnhaRndMQ1g4QjJBdTJwdWVBc2g0UWQzSTMwL3NV?=
 =?utf-8?B?K1RZRm1KWk1LcUpmaGVnUWd0RWo0WGJkSWJ3cE0zaFpIN1VPYTdKTStTcmtB?=
 =?utf-8?B?MkRpdDE1Z1Vuc1pmdFJpYm1iRGxSclQvZ3BmYzhQNVJtSzNsOVE1Ky9PTkIy?=
 =?utf-8?B?TEd4aFc1Y0ZDRHJsdTZvTDNrK3d4bmowWGtnNzJFWDNmb09sc2hxODJDVGVM?=
 =?utf-8?B?M2xtZW5uaHZ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTBUSURZK01rSzRzVzkxMDdKdjhNc3lnNzBLcTB5LytmNVlqOU9IcmNMaFM2?=
 =?utf-8?B?SHA0V0s0S0V0SmkrRG5ScHRDNjJEYjRjalQrU0U5aHBaN1RiVExMM3pJZG50?=
 =?utf-8?B?SVhSZzB2M2EybndwNG4rTll6RG1PdmU0YWE2YkEwYWhRVkJ1dWQxbTI1ZWVl?=
 =?utf-8?B?OXBuZHFiSk5aWXB1dmV5emF0OHFNQWpRWEFSazU5T2tla2NpUjZsTHYwTWhN?=
 =?utf-8?B?UHhENzVSSVQ0M2x1R0twaU5Oc2JGclJGa3IrTG9EL0xtR0dUWHZodG5DT3Fu?=
 =?utf-8?B?cGdXOFJ4Nm5LMjYySUlhNjhRSHlERm1hUVpHS1JoYk96S2QzMFhkWFh2ZC9R?=
 =?utf-8?B?dndzVG5LZ3NVelVUN0tFOXBDUXd4a2QxdExYbU91OGFnUVBEWUNRbEY4L0xp?=
 =?utf-8?B?UlZUdVdhS1NWYVRZWVYreVgzdEwyYlAvL0tNYSthOW9zbm5QUkVHcW9ucmcv?=
 =?utf-8?B?S1JWYUlaL0FpQnk3dnplTHZleFVFUXNpMkE3L2NSMCt6L0VLbVlaNCtuQ25t?=
 =?utf-8?B?cEY5UmZCMGh0dUZCTGdTQTZuNTlzNFVOSWgvSUlEa1JOSGpReXlieFdyZitI?=
 =?utf-8?B?K2RrTng3SXJ2aldoZjUwNC9ZMEl0QVRNNTdoNHZkazhMNFpuOUtET2s0RkE0?=
 =?utf-8?B?K3VNYlhWMFhKYTZJM3hDa2ZaVlg3dFZMNVF2cjdsMzhhSjU5c0dyUXcyRXd0?=
 =?utf-8?B?Wm45cTRMNkxDWTVqTSt6aUU1RDNyM2p3VmtSc3hzekM4cDZPT0FCUmM0NVZk?=
 =?utf-8?B?dnREa25GSXpsOGFzWXNQT2ROdnFhaFk1MjNibk1YbE5oVlRBUmNNS3ZUSEFT?=
 =?utf-8?B?YVNGRDBZSklxeVBOWDlFRCs1YUtWNnA5ZDB4NUlkWi9yQkhJNzdZSS9QZW1U?=
 =?utf-8?B?dFVkSFBIblJYSnZYa3RSUWRVRlJKdW5oVlFCYWZZb3NKc3kwTldsM2RNYTRz?=
 =?utf-8?B?Ykl6MERSa0Q2YjlBbysxYTkrTmZTdzN1WDZjbWRLOWdKZGpvdmF3T3ZDdVMy?=
 =?utf-8?B?ck1JbEdZMzE1NDlyOXVIc0lWdVpyckZ2TStwWnJqc3J2Y0MzRGRuREpENmFD?=
 =?utf-8?B?NEJuR2l0cGZ0NWNXVS82aHo2NU9CazRFTElwdzdJVVF0N1Fla3dTdWdEWlpJ?=
 =?utf-8?B?WDFXR0JTdjhrRVowN1c3cGtHeGFlRzNDVW8vaTVqRkNURVJkUzBtTnpXeFdZ?=
 =?utf-8?B?MkY3QjhncmtBUXljazVSdzJNV0luZWlMdytyeGVLMDJ0dEpXcTViakkxTG1Y?=
 =?utf-8?B?M2J5Tm1rSkF3d2VjZmY5ZDhVZk45RklSa3N0NDNBU0tPWmhiQlpUbFhiQi9X?=
 =?utf-8?B?VUZnMFZPTGhxa2xwU3JJNHQ5NkNGMm9ZRFQxaFZGbkJLcWFEVmg4cXVjOUFv?=
 =?utf-8?B?c1FnRjVtRHJ4aUdsU2c1emxIbEloaW9uVjQ0SER3clNPU2FOSHNJS3dST2Rw?=
 =?utf-8?B?dXBnWXdjTUhiTWNneG1BUHZ0RjRBU1JTL2NrMUdvNUxGREZqcjF5UnJxVEhO?=
 =?utf-8?B?VVBZczdXRi9iNForY2tudytWQndLYWlSM1J0MTZuK3JMYU9ibGZCOHlrRERR?=
 =?utf-8?B?Q0N4ekhtejQzektFUTE5RjVLRHV2cUozeWZmenlOcEhya3Q0QTRIK3Z1WXho?=
 =?utf-8?B?OFBrNW9rRjhyVTBOd1V4a1BNajBhclBUamt5cjlheTQwbkF1UUhnOC9hM0xW?=
 =?utf-8?B?L1NRTVpNeTlNbnVZSHVSdjF1YjBoY0tXZzRPc0d3eWx6UWtVcG9TazNsaTBV?=
 =?utf-8?B?MmpqK3d4cGYyUnh0TjdzK0hrYkphb0NJN1kvODlDanIvd0ZHbUZnNjNzUzNO?=
 =?utf-8?B?TTgxa2xxdGNMR1Z4TGJiTUIvOTNuQnIvUkRVUEJXMHNUYlNaQVVXRjFPdUt2?=
 =?utf-8?B?QXN3bWp5MlpKQXNhYUxacFNickpEU0Z3Skp0N09SMWpOQmtkNll1WkxqN3dt?=
 =?utf-8?B?Wms3ZW1lYlRTcURyVUZMdGh1cXIzYU8yOU0xRjVrdjFJN0VHR0dnVUhGRG9j?=
 =?utf-8?B?QU5lSEZZckZaWUZLcGwvUGR0d3JhTDNXb0FsTHc4dFBlL0MrY09XaytIemxN?=
 =?utf-8?B?aXV1NmFyM2ZrY2p0RUVJbG5lbUViL2pTbmlSSnVMaitncHdiKzZDNVpEVlF3?=
 =?utf-8?B?b0I1VlNpblBjMnVDZWpib3l2aHZUWjJzd2JsWGcxanV4Wmd1UW1SeTNTNERO?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9c0392-8670-4817-3774-08ddcbd2d7e9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:27:38.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/LkgBOMwMOL+o4MbTLnAQSk38qZpqnGMCLOLYS/rS5FM+xoEyWTtQBxv6zCe0Y5yBw2XylYYD1CpJlOb2XiqbgON2Km6ZnwpojAuMhTh5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> All details about a monitor event are kept in the mon_evt structure.
> Upper levels of code only provide the event id to lower levels.

<newline to separate context from problem> 

> This will become a problem when new attributes are added to the
> mon_evt structure.

Please be specific what is meant with "This" (is it that all details are
kept in the mon_evt structure or that upper levels only provide event id?)
as well as what "a problem" refers to.

> 
> Change the mon_data and rmid_read structures to hold a pointer
> to the mon_evt structure instead of just taking a copy of the
> event id.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h    | 10 +++++-----
>  fs/resctrl/ctrlmondata.c | 16 ++++++++--------
>  fs/resctrl/monitor.c     | 17 +++++++++--------
>  fs/resctrl/rdtgroup.c    |  6 +++---
>  4 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index e4f06f700063..ef3ec2a4860f 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -76,7 +76,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>   * struct mon_data - Monitoring details for each event file.
>   * @list:            Member of the global @mon_data_kn_priv_list list.
>   * @rid:             Resource id associated with the event file.
> - * @evtid:           Event id associated with the event file.
> + * @evt:             Event structure associated with the event file.
>   * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
>   *                   across multiple domains.
>   * @domid:           When @sum is zero this is the domain to which
> @@ -90,7 +90,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>  struct mon_data {
>  	struct list_head	list;
>  	enum resctrl_res_level	rid;
> -	enum resctrl_event_id	evtid;
> +	struct mon_evt		*evt;
>  	int			domid;
>  	bool			sum;
>  };
> @@ -103,7 +103,7 @@ struct mon_data {
>   * @r:	   Resource describing the properties of the event being read.
>   * @hdr:   Header of domain that the counter should be read from. If NULL then sum all
>   *	   domains in @r sharing L3 @ci.id
> - * @evtid: Which monitor event to read.
> + * @evt:   Event associated with the event file.

There is not always an event file involved when struct rmid_read is used to
read a counter. I believe that the original description is sufficient.

>   * @first: Initialize MBM counter when true.
>   * @ci_id: Cacheinfo id for L3. Only set when @hdr is NULL. Used when summing domains.
>   * @err:   Error encountered when reading counter.
> @@ -117,7 +117,7 @@ struct rmid_read {
>  	struct rdtgroup		*rgrp;
>  	struct rdt_resource	*r;
>  	struct rdt_domain_hdr	*hdr;
> -	enum resctrl_event_id	evtid;
> +	struct mon_evt		*evt;
>  	bool			first;
>  	unsigned int		ci_id;
>  	int			err;

Reinette

