Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5B270805
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745011712; cv=fail; b=eRru+t692F/zmV9/RwuBHp2MWyLnOUEecJ4tH9NC8GmPmZcoy5yzs0SUm8IBZhs0mAWeRhTEqW81K2dBFDMFX3K245vXcy2ynlIeD1DSwJTr6vrdYDiT1z7NkP0NWq9kSw2OS5M5taDjF2EXtXS5ec6SFTDNUctJHKaHTipCr/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745011712; c=relaxed/simple;
	bh=hXfG91kIF+LlfDZAQKcTFlSgiJRMU2jYuX14tWkz7WI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BlaApa+Q4PhGMGErw5AwWJS5MQvmltYBb8uQaTbpai7+mOJTFZ6r1HAHaG5YXQ251r2BqXjaGVbdHw1hMDJ71pr2v82Wcc/mVzxbnfbAiRX8rZb+h7XuiWFPQIf1oWAktOX3I+3paJzYJ0jlGjyHHDr5nX/oKAlYZqx6qW+0xpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UTA/iDGD; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UTA/iDGD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745011711; x=1776547711;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hXfG91kIF+LlfDZAQKcTFlSgiJRMU2jYuX14tWkz7WI=;
  b=UTA/iDGDBpWhRx/N9e6VTvTwVzrc75XxzniEojymU+yZyXLCqBwRdA8F
   7jODiBLzFi2k3iV2JulvbQQktRHqVHMz90WuXViLjvDGp9CXN/KPn9bd6
   1rYbO5Ei2zV5G227KngPQ3NSmbXmZ8h+vnhwX1YMC44tpuF6U85ZG0tea
   QVvj17Ff0I31fgshVQQHQPZAToB0FuKidwuaR8pMxWlphNrwrCTyCy/Mx
   +oG7QlsNtQx0eMUaMRUVc57szmNnYwb26o52sXFYpm+cv+PzlRiU7Fh+G
   i1v3C/H2GgfX4mkujezCqyrzvFj4eZEeNvpoybzzNkKKcaItmgqb9wZkm
   A==;
X-CSE-ConnectionGUID: xS1JplwIRp28z/JBLSVBDw==
X-CSE-MsgGUID: PVcaGM2YR1uB3vON1Lj1Cw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="57634380"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="57634380"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:28:27 -0700
X-CSE-ConnectionGUID: ZEKoH+adQEWKw8FLuHX2SQ==
X-CSE-MsgGUID: nXBn0KzlRjaXcb0hoTF4gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131509776"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:28:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:28:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:28:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:28:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfFT49yOL+nAXo99sEf2AVRvXHyNQIh8MLuVu1eVMiuzA0JXYFpunBU1MLbZT3BZzshx30qKJr19t1GyzPNhGHK3AvGlaOhz/m92AqE2gwR+IRUlc2IjVkXKtRcroLgqXKY2CBKecq+A1ouDjDYgDR+W27sfZYYaIag6xyax8EQHh0NKXdgnbzgeQM3/yipS2MeIAX7tiXwsVPk62xIu7UsrnvCIc2zurMJe+h0j3bXM9n3cysaEHLKP+YT2iqlBRUHz+61lRvANB6tLEmcqQP9buYLg8y3LHBVbesnuCEWh+mjJh9UMEBJ7+Q73r7AffqesngScGfF00LThspe9eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8KcMq3tuHRk0XGYaCS5k7KpTQsmL6Y+4NV4g00c+cY=;
 b=MXrvOoZ5gmIMmbFg32aDYeQHPzVyuyzyQaS+HQTClU402UzKUB+Bb7llRVvYH9eEaMBl+CyXpExAlsETGYnCUf9wmPdZN3owmxfuiDWFKFagMiA3H3olD3fbwUpER3bYByFwHLzJBcy3ZSY2tak48ngXgo382LTiENxj+1gbtywskSk7YM06X+s9iezEbyA+FFD3fCqjEzCc4tYUVj//G5rLe8q+MGm/bYQboCH227/L6OyKOa0RMoGekmPqCIT79AO3mOiXY9WQXvOjdDgfLZNPLA2U0p79ZD6HykMIJgxsgqDIQGe565M/60sVpMmnK7VtvSLgqtYl5PI9Pe6yIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB8963.namprd11.prod.outlook.com (2603:10b6:208:55c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Fri, 18 Apr
 2025 21:27:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:27:53 +0000
Message-ID: <2897fc2a-8977-4415-ae6d-bd0002874b3a@intel.com>
Date: Fri, 18 Apr 2025 14:27:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/26] x86/rectrl: Fake OOBMSM interface
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0187.namprd04.prod.outlook.com
 (2603:10b6:303:86::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB8963:EE_
X-MS-Office365-Filtering-Correlation-Id: 455a00d0-518b-4e89-2668-08dd7ebfe0a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y2JoVHd4aFZMaXRYMTExZG5rcjEvdXBpM3UrdllWenI4dnFaVU9PV2IrdFRi?=
 =?utf-8?B?SHdMUWNqUGtuVWQ5bVJBbitpcTJWcStGNGpPcFI2WDY5cjRnRytFc3lSVTZD?=
 =?utf-8?B?aGQzQjhtc1c3MFJVdFFNcmNTNEJndSs3S0ZzWFFMNlRZTVVocFMxeVE2MGh2?=
 =?utf-8?B?bVk4VkU5VkM2WWN2ZzlBMXlubjhsZ0wxcG1RTXBuVmpVUGVVT25iQmcza1Jt?=
 =?utf-8?B?dUhFWkNHQVVmcC9Rb3VFSjR4Q2puRytaS0hpclBSdjdtdmRDZC9zekNyMmVr?=
 =?utf-8?B?RHVHNThWOVM5K0N6VUNpR2ZObTdldmRxRGx1ZlQwdGN4WEVTYStnK2tyZ25E?=
 =?utf-8?B?cko2OGsrQUthZkFMU0xOVHhhZTd4TmV5RDZLMFQ0WkNKbW9uNUllSzFuRXZ5?=
 =?utf-8?B?S2xBZ1B1K0NSVTNKVC9kYWwxMHNrcndZM2N6NzZoaDZESjE4b0Nkc3ovaWpF?=
 =?utf-8?B?WjIzeVBVVWVYRFZZK204MXFFQStYWndya1p3NEJrL3lydWVSc2ZDcEY1WUph?=
 =?utf-8?B?dElmNm40QlVxOHgrOGgxNkczRmlVM3NrTS91UFpkRmwxRDVjbjdDVVBsZGJs?=
 =?utf-8?B?TzlsVGxtYXBTczgxSFdDOWttdzM4d3c5ZmVrVWNaS0JtcWI0TVVaMGNkaEdE?=
 =?utf-8?B?R1dLcUIvRkpTYUhXOWh6RGpPUE8yQ3hlUk9yVkVycDc5TnhGTWdoOTlrL05B?=
 =?utf-8?B?OThNb2hLUWFRc0l3a0RvbTdoTDg2dFVqeTBGckk0QjkwdmRsdjV3Zk5FMitD?=
 =?utf-8?B?NXBKRGtRQkZTcDdMZ2QvZ1FDOHNuNzk0RWk4VStCY0FwYVdlNmxaOXQzbVFn?=
 =?utf-8?B?Z1NlYjB5dGV0bWpqS2diL0QycmoxNVZFeGxoRDFSY0xOZEdSOFhnN0VYenNS?=
 =?utf-8?B?QmNabHRjSHE2V1ZCN3NsWlVMb3ZZeGN1b2lNS0tsUElPaVNxdzhYZzdUbnVP?=
 =?utf-8?B?VFdIQW5mS1VScUNFQjBhYWRFdzZ5MTFXb0x1OFhWbnJwNTZNR2d5NHh2T2tp?=
 =?utf-8?B?WHc1VWkvdWgrbGtmTjJiR002QmlJdGNSRmpyd0xNaXBtRGc4YVUvSFBSdnpu?=
 =?utf-8?B?VlFqTDRDSGVLajdhU3huL01mUEZkbmF0bHdYUVkvQm14ZWtGc3B4c3U1dVZC?=
 =?utf-8?B?TDVWQlV2bkY1eWlIODdYd1l5UmNURXdGMlhtR0tORTVBOWxUNW1jeGY2YVQz?=
 =?utf-8?B?OXArWkZ0SXR2S25HdWZEN1BxVWZYZ3RzRzBDNlZxT2FyUjZwRGlmSkF6ekFL?=
 =?utf-8?B?c1ViODdKMkxZQ2liSS9iWjZEMzRPZVNhakR6MW9HdW42K2pZZ0VYT0FBNDlO?=
 =?utf-8?B?RjFIOG9zWUlvWGcvRG5jLzh6Qnd3dmlUV1hBdVNDNC94Vm1oQ1dpVWJaMys2?=
 =?utf-8?B?UHNNUU9vdEJXOURVbnoxNTViSHZqU3krRkdweE0zU25DRDE4U2c2elVsNktT?=
 =?utf-8?B?Y3RBblYxVGZKV2k2NWtUWTJOcHdKN01MQUlKQ2xtWFFYYTVwc0N4SjQvMTJl?=
 =?utf-8?B?R2hoSHNmd1dqNlV0V0o4a2dxcWw4alVycmJmdU9OdUxKWmFPdE9HbnI0aitt?=
 =?utf-8?B?L0UyMXFLZVRHMTdMMGdkaGFjMytnNk9zdW9MZlVIdWZ2dTYyQnE1aG9xSG9Y?=
 =?utf-8?B?OTd0STk4bC9FWXZYUnhrZm4xZ09STXFUaFQ2ZS9NQ1JOckJpZVhtZkQ0K3JI?=
 =?utf-8?B?K0Q0eW1FTDh4MEdxN05YVzBYZ2hhUXZkdE9ISk9CYW81dmNNRXAzNWVZcHAy?=
 =?utf-8?B?bmo5ajBNWUp1NzNmSVlaa0JJN0VnZEkra3I1VHhOM0Z3YzU0Mmk5RWE3Uldq?=
 =?utf-8?B?dFVlZFh0Y1FPM2hHTENFQU9NS0pKY2NxN2JwTGpsNGVpWGRVc09Yb29mUXh0?=
 =?utf-8?B?bVB4ZzY2NFVpdERwbTFSd05pM2hGTnBDbkNEalRzNlZsZ2tQb3c5clhlUnc5?=
 =?utf-8?Q?r5snrTAQghA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzAzdndoWXJwdTVyMnVQOUhQeW5hU1QyQzJ6RExPblB3cUltZ0p4d1dWVER6?=
 =?utf-8?B?eWRSS0VLdDN5VWl6SkRPY0NQWmZLOVJGalZCOTFtNlJ3WHkrT2trOTJyWE9i?=
 =?utf-8?B?SE5XWFZzRGJFak0yNEdFZ3lsQmQvU2lZSEs1RWZRd0ZwZ3M1em1CY1dRT2Vn?=
 =?utf-8?B?VFdJaDB5bDducG5GTFVZRUVyeFpoT0lSL21mWDA2SVFPK3hFTHBnTUhPRWp3?=
 =?utf-8?B?Nlc5OVI1S3dtUzZXbjV2a0tBbzl3eHlCT3FaRkN3WU9UNE5qVEt5N3RDVUhi?=
 =?utf-8?B?RW5PeEVqdG5kMTV6NVVkODNIckwvNTJ0SEZiYzBsUHN4MVhXUXJkOFNiKzRa?=
 =?utf-8?B?Ukt4QW5xeVk5cTZTbkFxUktyYTZIVXhydHVnRjh1RFBLTFYvZ2Z3aWVZdFNJ?=
 =?utf-8?B?bW1vSnJiQm13SnUxOFJaWnA0YmdjVmlBWWZjcjJ5L05Zb3UveTZEUmRDZUNU?=
 =?utf-8?B?NmQ5R2FlSTdwUU9GZmx5Vk1SVzRXZTZKV2syT1lPekFscnFiNHBwNUx1ZkZU?=
 =?utf-8?B?OThuRzIvSFFlaTZMY3E4c1lEQlo1ajlMdmpYMDlaMmI1aHBxd3d5MEVXeXgv?=
 =?utf-8?B?TldsN1MxRDExbmhjSS9PT0hqNitjQllYRS9tdFJtMnI0clA5VmgxcDErdmV1?=
 =?utf-8?B?QjVhSEg4SVdUOHdDYitYQ0pVOG5ROWNVT285NkxaUGQ0OTIydDhzSEg1SCtL?=
 =?utf-8?B?ZVRUbm03UGtWb1dBdFhTK3NsZVNqZlYxeFViY0s0SWZXenVuM0RqdVdOVHRP?=
 =?utf-8?B?aTQ4M2p6RHVKcjF2ZzlQbkxDNkNwbE5QM0cySy9qV1Jrdldxb3VBMmFxNGUx?=
 =?utf-8?B?dWVYQXVEVVQvWnFoK1RyZmZkNGFyNXNjYUNYaHJwYnRNNmhKbFdkdzVOYmNM?=
 =?utf-8?B?eWo2TjM5dGFkcWtZaFJMR255eEVkS0U2Tkc2V2hXRkdCN093NnFwWXlGRUxV?=
 =?utf-8?B?cHJKL1dobXNzZkZVSkhPRWtVc3lxKzFlTGxJNVdKZXRtWXhzL0FHQUY5SkZy?=
 =?utf-8?B?T3F0WHovRkl1Um9sQ2NRSFlBSGIreFJBQVhuUnBtcUVqYmU4c2ZSYW1tNDht?=
 =?utf-8?B?R0JLcytuRmJ3Z1F0ajU4SjF6SnRmVmYwcE90Q1ZCaUkwRW5NcDVITEZaNDNF?=
 =?utf-8?B?ajJ0bmpWUjhsN2FKeFZHblRRdzhpdUhLSTIrTkZHQVFJNng4WFVxMGNUWFAx?=
 =?utf-8?B?blRPWndhUTAvcWptcnVSUHpmUi9GL0dDZlU4NEtIN0RsOWlBZXJDNFNjOE9q?=
 =?utf-8?B?SUcxQ0pIaVNmQXFrb3RRYmdVRmV0bHd5aUVzWFUwdFpnSGsvNlhzaXpxRnBu?=
 =?utf-8?B?UkFmS3huc2xwTk1Td0xKSVYrRkMwWUEwSjZDQVhJL3pDM1ptUzFhNUlMak1q?=
 =?utf-8?B?SXhBK3VHZlN0eGY2cUxoZUt6TnhvVjlRU2d4YzVISzRxMVpEVFZLdDdNbko3?=
 =?utf-8?B?ZlA3Wlp6d2dGcmdiVURPQVJJOXFRQUQ3bWY2dkU3UCtiN2ZjaEpQS2lISk9N?=
 =?utf-8?B?WXBHWENiSVhtcmNPK2phREdXYmF3VmtrQXZORE9Kb1Y1NXN1aUVldUdYcFFa?=
 =?utf-8?B?MWVHUnZXdVA3SEVUOGQwYjh5eVo5bkhtT244alV1YUxiVkNkK2lvenh6dllM?=
 =?utf-8?B?QVJ4U2t0cHBaREpVR2ZHRTIyNTRSaDVjbDFPVzNMdGFGS3dHQ1hYM3BDNUN1?=
 =?utf-8?B?VUlNQ0Q0cmVTTVNjOEZvcnNpL2dnQkRadU9yWHpCRlpkUEdCN2h2NjFIT09B?=
 =?utf-8?B?MS9oVW1seWxOZk5ReXlyeDRqYUdaOVdwZ3VhS1ZOaThDamloNXppbjJGNHZ5?=
 =?utf-8?B?ZjJ0S0txc3hLN1pUbDhJUGhyVUVYTGZpcXcwRkFGdGtmeWRFakZvczlhazBZ?=
 =?utf-8?B?RHoySTVxVzhxZzBpN2tTYXpnb2FnUkN6QXU1aGppdmZwUmxpaVNTaEhENG40?=
 =?utf-8?B?bTVrUzQ0aEUyR010NzFMcFc1QUg2REY5K1Q5TGNTYjZiVVBzbGQ4eEJid3l6?=
 =?utf-8?B?bTZCTDFyN3VPVlhxbVNuZ0JHREZSMmdiL0dNSGtzMmJ3ODVlaThzYkVwSThC?=
 =?utf-8?B?STZ6TzhWbDVjakNERnlNTStxcVhZWjRlaHBtK2JkeEZadnNoK1VkUS94M2pq?=
 =?utf-8?B?K3NtUFMwYkNiMDN4QkM5QmgxaUtHb2VqT3ExQnVkRXNsYXhWMk9oeHRIaVI2?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 455a00d0-518b-4e89-2668-08dd7ebfe0a7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:27:53.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxW0mL57mTKxVuamjw3cgEmH1h3g7BPHSGa1uvhjWyOR6gM+l8JPLeXVh03vlP+eqdRNbHLvOi7oYg7LqUpwnY/8hJPg7sdbR8I42+dVTB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8963
X-OriginatorOrg: intel.com

Hi Tony:

(deja vu ... lets try this comment again  ... x86/rectrl -> x86/resctrl)

On 4/7/25 4:40 PM, Tony Luck wrote:

...

> diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> new file mode 100644
> index 000000000000..5a16db67c7b8
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/cleanup.h>
> +#include <linux/minmax.h>
> +#include <linux/slab.h>
> +#include "fake_intel_aet_features.h"
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +/* Amount of memory for each fake MMIO space */
> +#define ENERGY_QWORDS	((576 * 2) + 3)
> +#define ENERGY_SIZE	(ENERGY_QWORDS * 8)
> +#define PERF_QWORDS	((576 * 7) + 3)
> +#define PERF_SIZE	(PERF_QWORDS * 8)

Could you please add explanations for the magic numbers?
For example, why are both energy and perf using 576?

> +
> +static long pg[4 * ENERGY_QWORDS + 2 * PERF_QWORDS];
> +
> +/*
> + * Fill the fake MMIO space with all different values,
> + * all with BIT(63) set to indicate valid entries.
> + */
> +static int __init fill(void)
> +{
> +	u64 val = 0;
> +
> +	for (int i = 0; i < sizeof(pg); i += sizeof(val)) {
> +		pg[i / sizeof(val)] = BIT_ULL(63) + val;
> +		val++;
> +	}
> +	return 0;
> +}
> +device_initcall(fill);
> +
> +#define PKG_REGION(_entry, _guid, _addr, _size, _pkg, _num_rmids)	\
> +	[_entry] = { .guid = _guid, .addr = (void __iomem *)_addr, \
> +		     .num_rmids = _num_rmids, \
> +		     .size = _size, .plat_info = { .package_id = _pkg }}
> +
> +/*
> + * Set up a fake return for call to:
> + *   intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> + * Pretend there are two aggregators on each of the sockets to test
> + * the code that sums over multiple aggregators.
> + */
> +static struct pmt_feature_group fake_energy = {
> +	.count = 4,
> +	.regions = {
> +		PKG_REGION(0, 0x26696143, &pg[0 * ENERGY_QWORDS], ENERGY_SIZE, 0, 64),
> +		PKG_REGION(1, 0x26696143, &pg[1 * ENERGY_QWORDS], ENERGY_SIZE, 0, 64),
> +		PKG_REGION(2, 0x26696143, &pg[2 * ENERGY_QWORDS], ENERGY_SIZE, 1, 64),
> +		PKG_REGION(3, 0x26696143, &pg[3 * ENERGY_QWORDS], ENERGY_SIZE, 1, 64)
> +	}
> +};
> +
> +/*
> + * Fake return for:
> + *   intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
> + */
> +static struct pmt_feature_group fake_perf = {
> +	.count = 2,
> +	.regions = {
> +		PKG_REGION(0, 0x26557651, &pg[4 * ENERGY_QWORDS + 0 * PERF_QWORDS], PERF_SIZE, 0, 576),
> +		PKG_REGION(1, 0x26557651, &pg[4 * ENERGY_QWORDS + 1 * PERF_QWORDS], PERF_SIZE, 1, 576)
> +	}
> +};
> +
> +struct pmt_feature_group *
> +intel_pmt_get_regions_by_feature(enum pmt_feature_id id)
> +{
> +	switch (id) {
> +	case FEATURE_PER_RMID_ENERGY_TELEM:
> +		return &fake_energy;
> +	case FEATURE_PER_RMID_PERF_TELEM:
> +		return &fake_perf;
> +	default:
> +		return ERR_PTR(-ENOENT);
> +	}
> +	return ERR_PTR(-ENOENT);

Not reachable.

> +}
> +
> +/*
> + * Nothing needed for the "put" function.
> + */
> +void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
> +{
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index 909be78ec6da..c56d3acf8ac7 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  
>  # To allow define_trace.h's recursive include:

Reinette
