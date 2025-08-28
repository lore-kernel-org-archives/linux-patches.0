Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7784A326D6E
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399554; cv=fail; b=RPC3gjGOnms78d0L+FYBthPgpfdGUt3gygasZuyrUarfT39dyrHtKSz5V/APgo/OrWvcPJeooQFdsMIJ6xFAVFyEX+3ezZmUiJzjwc5GfKjE5FN9dzfAowgjO2stPZkOqu1NqxYy5Ow3ZPHrQw9AfL1U4OVpbOluFYi7/dXTUII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399554; c=relaxed/simple;
	bh=xcdJBbOX9T1VQ262wj2opMYB9oclMC1oIM38OJf80zk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NCRpN3prw8sks/43rPF9NS1AGfzgoHwXnvJEQhEaT5bEDOnK5IOjokPt1+D4jvSkpVfu2v3OsXPmjtdI1HU14skH5NmtMqjdHVvG2j5giKuReAr4Jr3l1MIXX8+lIx7W/ZglmLquSQ/VqpXE+nj67E26RUsUQqK7VYOiGgFyoJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gXE9fy34; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gXE9fy34"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756399553; x=1787935553;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xcdJBbOX9T1VQ262wj2opMYB9oclMC1oIM38OJf80zk=;
  b=gXE9fy3496IvWoJ4UYW7QerEDlAF4g11QWOGzqgHhG1kNjsPv9QRii++
   25CdAe9XOb5/ltoVsDdBD7IUMe+ziPYyMm5BQ6OyNqn+hFHmrbjZ2Je5j
   FyuZn1vQG6+m6+1HNmSXXLhKptrNqDrFUJBR4WFF3homFYGT42gWnWCiO
   woCflmpr60MnmTJ+VDeSTNWFjHUngaBrrG1hTgLm8gISpDSJlFFyhfixV
   ZDpVS72CY/OsU5Hao+UeVaIgRO368x2oDoY4tl+vMuDIOyBU64t0ytNA5
   Uhuf/rvoc/j6eiyfkHLvhi7S4Qaz8nethmL0X79qNXRdaEiRsm9ndQeYP
   A==;
X-CSE-ConnectionGUID: 9aJrW3w2TQOQKsPW4khltQ==
X-CSE-MsgGUID: /41mfk8zTaiGlTlwlUazwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="84078287"
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="84078287"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:45:52 -0700
X-CSE-ConnectionGUID: IMVUL4mISb673uzeycPYPw==
X-CSE-MsgGUID: oqTgApAHS5GwYQScqUbMGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="201077721"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:45:52 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 09:45:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 09:45:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.47)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 09:45:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ctSzEFjfN0vnEkgdUtNNYeh7plcbSfSFykAl72fjaJJ/rno79sRm5yLSEix9FJcPZkBQB6zO1//X4sVhp68HnlEfuCaE+zhfTOOjNrn0ZaNch9vaerCtapcPw4X5eje2Qyb0BtZCFQOPa/+PdAjntENteoP8j96p/PfNLSj7pZOfsZKpSSJ5Jw3J8oGHBnvRaPGsPHxJhNL9MPJWYFCwoJzY7BAN7l4XbL/S5Qm4YRCjhY5LrK7XxU+qosfhpaefRiLhnhSuy3pQ0ofRXMOUDrjeyQzhoNnOmyP2GBpErfieBz3OszIiFCMrQG3SGPRlwsLrg/XNHS6yFy2dKABCDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bO2qNHEj7NJlK/9bkqy9cAojkOtaBsF1lpytO/zdtUY=;
 b=gxXSZ277npo0QC6VLxm+70RM4pKeJkYOpHZd28AbAT3Tha1mXkjtFp/lBGw3ZOK35C2wMi4EGncGAPYSBmBvj8B2a7SZesUYvfH95uPVfL1KqH3iVhlcjLL4ydq3WVoly2gOaI51msQbxkCPjtg8dX2qUDK/RCeoyu7UTT3ihvdaTgcFv8C3A6Sp/bWeEIhCR6AA/B9awIDIJpZ4K2w90OJs+/za1lRGHNUkjZHl/3SBzLmqgzawNArLZKhER2OivsDMTxsLAvGjxJoLqXsZxstgHv/lQsNx/iiO5xp7R48//GKTjk0XjVVo8lNH73lisNJ8Q7kd0z0DVDtCiML4yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB7886.namprd11.prod.outlook.com (2603:10b6:8:d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 16:45:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 16:45:44 +0000
Message-ID: <d06e81db-1669-4a6c-ba75-67fe15c53303@intel.com>
Date: Thu, 28 Aug 2025 09:45:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
 <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aKzhsOWp2TlFF5mK@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aKzhsOWp2TlFF5mK@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0337.namprd04.prod.outlook.com
 (2603:10b6:303:8a::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c9cf87-4301-4aec-5297-08dde65254bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cDlPM1hwS3RZdDFtSWxMVlpjYnhPaFY4Y0Z5RHpWWEFqbUtpV0NjUFdsWG0y?=
 =?utf-8?B?VUJEWGZkamw5VEs5LzlZSERwSW9CL1RCNjBKS1JsUnZEVGliN2xzaVR3REht?=
 =?utf-8?B?Y2p2MDhCQmRqZkZDN0lNalcwL2lNNU5XSVkyY3V0QTNGQWR0dFJ5RllXU3BQ?=
 =?utf-8?B?WWNMUkhoakwyeXdDMEY5SjVKLzhrWjNaNGw0TEFxMTlHYXUxcjZoOXVZc3Q2?=
 =?utf-8?B?aHJnV0Fuc0QvbW5jSTd2Qkd0WjZzYlE0dnZFTnpFdlNJei9wWVFINHBSUGs3?=
 =?utf-8?B?SmxQc0ZGQllBZEVIUGVkRFBXSU1nbDdVZ2MrUUgyODg4OXRiRnN6anYvWlcz?=
 =?utf-8?B?enhvWStlRm91cGJyVVQ3OUpFMG9pdWp1NHV1c1JCYXpqRUw2NkI2M2FIN1pT?=
 =?utf-8?B?eUVsS0xDNE42d1hPWHM1ZnRoU3puWk1qZ251eEVIcENINkVKeE9DMHlPRTMw?=
 =?utf-8?B?VjNQWStObllxTG10Q1B3c1dnaVF2R0Y0bU5JZkkrNU9MNG1BRWkvMk5UdHli?=
 =?utf-8?B?K2pScEJmSGg4VHkxWDhUMFEzOWh1aUk5MWsrZGJROC81Mm5jeVJsRUdNTjlr?=
 =?utf-8?B?aGJRbXVXamdNTWlPWC9ZQ0k1UUc1aFNSQmNHTVZmcjN0ZjM0VEJyYzRCYTlt?=
 =?utf-8?B?ZW9mVW1yd3J6RTVCRHZReTcyNmsxQi9DaVMrWHU0WkY5ZTNpN2dCdVh0VDlD?=
 =?utf-8?B?NE1scjZWa3BCM2hybGlWanNBTXoxQ0V5NUhVcC9tSmJacmdESENJckl1dm1J?=
 =?utf-8?B?VzFhb3l0RjdoakVtUUYzVWRvdEpkczdXd2trSWtNSWRqKzRSWk1hTkovWWZZ?=
 =?utf-8?B?dmFacUR3R1Z5RHZaR0tqeExSQXpjUkJvL216alRNNVphRGhmdXdvMjNqSFFY?=
 =?utf-8?B?NCtTVmE1ZlJsY1VvRTdmRHdKSi9aWmgzbTBPMkhOLzlZU3FOOHdUWXNoSEdo?=
 =?utf-8?B?VVdKRU1xTkhOMnJPNHB1OGI3dUxlUlo4eTRraGFSSDBhd1hKUGtHa0o0Mkwy?=
 =?utf-8?B?OUtUUnZ6QzV4NVUzTUpnR3h3dHdodWo4cTY5OEhxNmUrSU1rZDBpRC8wLzJz?=
 =?utf-8?B?U21SaFBUdjZKRnRxZ3JWeHFTSWRnMG9FUkNQK3pyT0dCYTd3RWNEdUQ0c0gv?=
 =?utf-8?B?b1NWaktOVEZmRUFYMmtrMGFpbmpEYU1uekF2Q3V4b0RWK2NZMTJNcmE1TVdp?=
 =?utf-8?B?OVJ4ZUNCTEw0ejdHeUdvTklveWJJSVZPNHYxSWhOOEt0bUF2dTZaMWNDSnNv?=
 =?utf-8?B?cDZ0QkNHelI1T25rakZOMXVRRFdlQmxIdTdLOGI1UEV3aUVPTmJxWUtYWFhp?=
 =?utf-8?B?WUVNbitiaUpxajlReHFNLzFta3doQ2U0V2FZcE1wY1FYUm14ZGdndlJhaWdn?=
 =?utf-8?B?azlhNnk2MEZKY1NUelI1VGw2L0FyNEUxejZQTjFwVTQ1WmJpKzAvZTlJblBp?=
 =?utf-8?B?ZFBNOEpVNDVIOXVTVEM2NXRBbTdqTGUyd2JvMTVFODUwalVLYWViLzBNb1Qw?=
 =?utf-8?B?TEVxU3dSY3o3VFdqcDBvdWpqZVlGK3BuKzhESXhYWEo5eFowT00rQ0oxSTZC?=
 =?utf-8?B?MlQxc3g4NERicm5JZTF3ZVp5blM5VHpZc2U5Ym14VUpmV2gxcnB0clAyT1Ey?=
 =?utf-8?B?TEN0WmN0d25TOEdNeDJYSXpacWVQS2VlN2JBanRqSlJFck13QnV3LzFkb05u?=
 =?utf-8?B?RVlsSzhCcXllZkhBa1lYZGo2MVVXQ1A1c3AwUUIwWHYrZmp3UVFPcVNQUGZM?=
 =?utf-8?B?MnlLYjdDV1BUZitEMGRzOXR6eEpBMVBZRWF0a1JqaDVtRmRScnk0YUp5QzM5?=
 =?utf-8?B?Q3FuTldkMmM0SDNadjQ0bnl6MjRpakhvakhNWHFteXc1TEVLNUFMK0pWMVRo?=
 =?utf-8?B?REtHalVaeERZRldxeWZNT3hwdmd1aXpRZnJ4WTl4Yi9nUkk3SkVXQ2tsSU1P?=
 =?utf-8?B?UTZOUndjcUxqYVRCdUpRM25NSVFhRTA3TEFYSWhOdC9yUEVSTmhPZGltbGpz?=
 =?utf-8?B?SHJFbG9oamtRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1VxL0ZUYkt6bU5vblE0bHdURFVrYkdKMFl5dVNFaHRza2UwVlE0WG5UVkFQ?=
 =?utf-8?B?YVFzMUdkeFgzMUhnZnByRlJuWHFkTHYzTDFnMnJwelB0c3ROeWo2YWxYV0FC?=
 =?utf-8?B?NkRUMjNmc1VHWjBUU0Juak8zMEFJWElrNWY4U2lUUm1vYXdPS0grSXkrYk1l?=
 =?utf-8?B?TjFBZTFheno0eG9vMDd3V0pLUE5mdlVqK3NMS3A2QitET1hmNE5EYmZOQ3Bv?=
 =?utf-8?B?V0V0TVNPMGJtL2ZoMXFhUnZoT0Q0UHhoM2dCc2FzSE9vRkc0aDZuMWhuMWF4?=
 =?utf-8?B?TG95dnhlV0ZyQ1pheWFJWUx5NVpvRm1NVkdqS3c0ZWpxTHFJMitCOTZDdHRK?=
 =?utf-8?B?S0RQbUFWZFdGbTQzY3RjM01YOHIvNVRjMnZjRFVKV2NPM2YyTi9Ia08xNW5z?=
 =?utf-8?B?VWk1azNSZkJRWERmamNmRHVuRHFVbmpRT1ZlcXJzdTJBVUdIL3FhMkhtVmNz?=
 =?utf-8?B?amgvR2dUdE9BWTdjeUswSllCU1M0WFYrYWs3ZE9FVlE2aGhicVRSZHlEYTR4?=
 =?utf-8?B?WkkxMUlpbzcyMys4UzBicGxqUnd1MVJleVBtM3luOHcrdGcrK1cxc3p1YlZZ?=
 =?utf-8?B?WS90N2FtTlNwekNqbzhvNDkvRk5oNHJkMngreDdlanVTRStCTUZJQ1lId0Ru?=
 =?utf-8?B?QlhPa1BtZTkzc0FvQjNIL1lHbExnSnpWaFE5eXBxMnZTUUJvaXdhZDlmUnVm?=
 =?utf-8?B?WWZtTitkUnJMbXVhZDQxVGt6eWo2dnFBT3krbzl2ekxEMUZvMjQvWldYNlRj?=
 =?utf-8?B?NENYZkRSOUtybG1JaVUwbkl1VHBJZTNCelVnUHRtQkREcTZJcjhad211dWl0?=
 =?utf-8?B?akFLNFREQTB1aE5td2pKVFNYYjQydytZOGtSUzBsa1Y4QzdibWQycDgrREIw?=
 =?utf-8?B?Y1NyR0tJOGpzYndmUldqOVZURThCZWJCZ1J0MndMcE1SZGR3S2xZM0FQSkxs?=
 =?utf-8?B?UjlOb2lyZGd2bUtUbERFV0VNaDdYc2RraSt4NFlzNzY4ZzhrVElSTTFnVzhD?=
 =?utf-8?B?VjRHT3FyVURyeHRMS3pnall1NTFWdjhEZHFISzhRUTJ3LzFCbDlTazRDQlZ3?=
 =?utf-8?B?TC9kWU4xV2lDc3doc2NEZmloaGNjblJnOFRucXg4Wnd1amkvMHBiSUliVGV0?=
 =?utf-8?B?dEE2MndSVFpwYnZURnlrbVV5YVBUcWRVTEZtVk55NVpVcFFrT3A4TzFHMWlW?=
 =?utf-8?B?K3J3SlVSWGtKMml1TnFpTzlCcWZKNzhjSTRNSWlZekpXWFNrUW0vTUxLL3NN?=
 =?utf-8?B?MFZRN3RHV0p2UmxJSFd0MTZ5UHc0V0hIZmFXTlpSWHBRbUs1ZkNacGRrMW5I?=
 =?utf-8?B?UFBRaUkyZzR4Wk9JTWRYdnZ6TklCQnFjL0d3WHJBbFllTVZpSGd3endiWkxv?=
 =?utf-8?B?cGNaNDZtcnJVM3M0cGhwTVBBdlNCVHFwbHptUWhBL1dnU2ZRb3ovNnA5NElW?=
 =?utf-8?B?eWJUSk9GMWdjejY2VGgvNkl3SHJiUWFBTHRJMmdWUDc4aUJWVDBlYkR6cysw?=
 =?utf-8?B?blcyS0hTUmRQREhXZ2xsRFZnaFl4NmczV3RoeGJLUitOOG1aK09sTFg3M2Rp?=
 =?utf-8?B?c0xFOGN5TVpKYTdpckVkK3RiSnZ6RXFtRnNzN0FycUFxZjY2Q2hZdkphTnlS?=
 =?utf-8?B?QXRkcWh6MFdkOEl6VWxHcU1LazMxSE03N2RBUGUrN2N4OVJJUzQ4czBvZWh5?=
 =?utf-8?B?SFVJZ1c1MnhrQ3J6d0lwZitFUWtISTN4dzZlYWVOWGhuTEhTaXBOM0NBVndJ?=
 =?utf-8?B?dG9LQ09oYUlrNDdiUlgzTzlqaUwwcStyMmwxVlBXbHo2QzBDOWZTWXVBV1p6?=
 =?utf-8?B?TmNlcnNlQTdxK0dZa0h2OGYrR2JsdGk0aHBaeHRhNXMza20zRnZyS01ob2ZC?=
 =?utf-8?B?OVBVZGJORHpsTS9iM2lScmxDSHF4eG5HcG90Q2N5N1ZOckIvUXd2MEpRSzh1?=
 =?utf-8?B?UG5CRjFySjJNNlc2OHhMYzU5RHh0Z1R1TElEcHFDbytUQ0tWV3VzVUtZTTdJ?=
 =?utf-8?B?R3RTY2lPdzVzb0s1TngxdUVBUzQwS3RmNyt3R1FGc0NnTFZwVFg4QnljNG9j?=
 =?utf-8?B?cS9ld2RWaE5oN3MrcnlqOEhPQVhaWE1yeiswWFEwc25CcWY3d3plcm9wdEpO?=
 =?utf-8?B?Rm1GUVNYdTRWNk9mMzJHbWRoMHdoVFJ0M3VSYkIxZ3V1TmNqM2VIblNhVlM1?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c9cf87-4301-4aec-5297-08dde65254bc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:45:44.1406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zm2rywxW4M8jgbeQ5vmlj8dzWY/kg9YhmU+QmMwqzXGN6v0pCKM7fhpcgigjwUxyA4oZ/V6ReSPkiwJnrHoVhPnWnpBAav5+u63toRAkhAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7886
X-OriginatorOrg: intel.com

Hi Tony,

On 8/25/25 3:20 PM, Luck, Tony wrote:
> On Fri, Aug 15, 2025 at 03:47:17PM +0000, Luck, Tony wrote:
>>> I think this series is close to being ready to pass to the x86 maintainers.
>>> To that end I focused a lot on the changelogs with the goal to meet the
>>> tip requirements that mostly involved switching to imperative tone. I do not
>>> expect that I found all the cases though (and I may also have made some mistakes
>>> in my suggested text!) so please ensure the changelogs are in imperative tone
>>> and uses consistent terms throughout the series.
>>>
>>> If you disagree with any feedback or if any of the feedback is unclear please
>>> let us discuss before you spin a new version. Of course it is not required
>>> that you follow all feedback but if you don't I would like to learn why.
>>>
>>> Please note that I will be offline next week.
>>
>> Reinette,
>>
>> I took one fast pass through all your comments. I think they all
>> look good (and I believe I understand each one). Thanks for all
>> the suggestions.
>>
>> I'll try to keep (better) notes on what I change as I work through
>> each patch so I'll have a summary of any areas that I'm unsure
>> about for you to read when you get back before I post v9.
>>
>> Enjoy your time away.
> 
> Reinette,
> 
> I've completed a longer, slower, pass through making changes to prepare
> for v9.  Summary of changes per patch below. I didn't disagree with any
> of your suggestions.

For me the item that I expected may need discussion is the use of
active_event_groups that no longer exists in v9.

> 
> The bulk of the changes are small, and localized to each patch. The
> exception being removal of pkg_mmio_info[] which dropped patch 18 (which
> just counted regions prior to allocation of pkg_mmio_info[]) and patch
> 19 (which finished filling out the details.
> 
> discover_events() is now named enable_events(), since there are almost
> no "steps" involved, it doesn't have a header comment. The name now
> describes what it does.
> 
> Theoretically skip_this_region() might find some regions unusable, while
> others in the same pmt_feature_group are OK. To handle this I zero the
> telemetry_region::addr so that intel_aet_read_event() can easily skip
> "bad" regions.

This is a significant change that simplifies the implementation a lot. 
Even so, it is concerning that resctrl takes liberty to reach in and modify
INTEL_PMT_TELEMETRY's data structure for its convenience though. Could the
changelog motivate why it is ok and safe to do so? Should something like
this not rather be done with a helper exposed by subsystem (INTEL_PMT_TELEMETRY)
to be able to track such changes?

Reinette
