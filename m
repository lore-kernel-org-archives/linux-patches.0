Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF99238171
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 03:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757475808; cv=fail; b=inBY39Ix/CAjranw7BJPqlTr/OpA9kXQtA0ps3iVJoX47HQ696WpvnaBP2lX9ryD0VUAgNeVKHBV7JdH4iTO1eprbNd8k3G+KtxLuMGMrLtRdPkYODxIJQPe9yRKEii1E7oxcKmEBomypX7FFwIxok7jejkBObry3vb6GWFGz/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757475808; c=relaxed/simple;
	bh=4frlPi8kzTvANc0CZmIpyRrBFhMfQPfzuLpJKYKq1D8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R9aRdyXkkdAE+eq2LaGW0Mqkqc930aAK+E/BVXfG/yjsDt0Lvsp52K/indmSCS6QEQJRk0eqaN3iur3mhuxZeb9rNDJhZ3sRauERZuPV78VMsKJQ/YMiqeCsWk7gKkHY/Wr1bPU8Cip47G90pF/7P+DkPvMPP47bDyK/wnXzTY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nctmD3Eu; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nctmD3Eu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757475807; x=1789011807;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4frlPi8kzTvANc0CZmIpyRrBFhMfQPfzuLpJKYKq1D8=;
  b=nctmD3EuD075daug1iVo+kMW+iWVacMPgd4RiGoX2pYRuMP1INGjq105
   vWbl2fbjzXMK/KA5J0D4JjIMEmSi6GB4jB3xGhd0bQ8Hdr+3ggBPiuFRx
   CZtGIiGFZzsDHQvZocF67pJBC2iI4m116W7Gb3PiCHqOCRntekGsBvn9E
   43HierMgB6vflqY9g3dDMt0RkBEKY5zMVv36SWSpzrXaz9JrA4RDwhlL1
   pzzc3RtW3jgEBa+fCzPqPYpld8OdAse7mD35iG01I0HLO+/Bk7uvmLC0c
   +WNbE0dMKqUBzoOH3o55tmYcjjWlKdXLQVhEpRpzUhOfkrC4zYPESz4vu
   A==;
X-CSE-ConnectionGUID: xgDlok1QRuKVrolUWZq+Dw==
X-CSE-MsgGUID: fXjOhH4cRSWpjtXskwi3Kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="70392456"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="70392456"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:43:26 -0700
X-CSE-ConnectionGUID: galmNsv6QQ69lDX2P6Q0vQ==
X-CSE-MsgGUID: oG2TbBmnSxGv/A4tUAnrtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="173658874"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:43:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:43:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 20:43:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.77) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:43:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVl0kyArgJ6ehnhivUS4wBTdNRm2l+VKVLmd6STL2YJzWygLz5xbz+w6lLteMQRDcEMql+ZknndGjCuVhLWZXeDZE4sP5XwEI1SqIiz+6B2aQtqw2rsMblmPFGxCXQUjU1D4s82aVWykbfwfotsUOrhIVgp561QRpX6SvTW/VYOcRVSDDjHzqLLyVfJGSbtaKvwdhyHZJPgzZexM5002wPNa4Zw7tCDiX4i6UIj0inNQsqYwPNbLK7lQVYBGl2wewUyByPIjWLb7UdMMhX8GqB2iY665bjU8oDJz6+rcafD5eewCe6Fda25cVTVd8nJWzB5wvd82Bi6XGt5COP2UJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVQoyZQzJHXhHixb6H/3PuA8ZnINnLfVJPV9rM3ozik=;
 b=XBuX15oDWRxmNkQr7QNY7qibW+2MJATZ0Uft5Cmpzt+9fFad94C7apur5sG5spGEWsqf7lYuY0fBNT2oBFReLILFXcYTZ3w6z1CiWx+xNwfQsC8xR+pxvnhSReUOmgV+SCaZfOnVqlXmMXJVRK9TcvCSmS70bCboMTxeRINvIOtNEkKkAvVnllXzgX5U5MmomMVX1G+D+8xZKbS4dd8ok3rozMB6m1Q8aUSfgljnxuGL53NLvg6o+b53Z06oahdPPLoZAieOmPFzGKlPe5TD7wWySTap5A449ayoRgEE1hWGtGUgTyLIPtqlsK0MIDpf1Xv2eeUyQknXl3dNbZKWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL4PR11MB8846.namprd11.prod.outlook.com (2603:10b6:208:5aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Wed, 10 Sep
 2025 03:43:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 03:43:22 +0000
Message-ID: <919e104e-aeec-48d7-89bf-8d96ebce7e35@intel.com>
Date: Tue, 9 Sep 2025 20:43:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 21/31] x86/resctrl: Read telemetry events
To: "Luck, Tony" <tony.luck@intel.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?=
	<ilpo.jarvinen@linux.intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-22-tony.luck@intel.com>
 <3b0546d4-d0bc-f76e-e1c2-eef2b4abf0f1@linux.intel.com>
 <aLiH0QxFCP9EpmWn@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aLiH0QxFCP9EpmWn@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0211.namprd04.prod.outlook.com
 (2603:10b6:303:87::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL4PR11MB8846:EE_
X-MS-Office365-Filtering-Correlation-Id: c3724d15-adea-4d51-dae2-08ddf01c3093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R3dFclFsTGF2SFVoeVBjbGVZWGk1b0tlZXdtbSthRHlBcVNVL2toWjM5c0Rn?=
 =?utf-8?B?anNwZmlia1VFNVFzS0hOTTUwVi9yNWVrZWFiMkN0K2UzMWRaYlEzMVVDd0gx?=
 =?utf-8?B?T1ZIanQ0bzNYNGdKWGJOcitHOW92TFIwOURjcXFGTS91V3RZYlhOeTFCQlFB?=
 =?utf-8?B?bUdqMjI1eXpuVDZoYW91SUdWZlM1bStrUE1UMUIwQWhQYkU3R04vNjlMalZT?=
 =?utf-8?B?bnRITXdnTllySmhRK3EvTytMMXlPdi95UjE1OHhUQ2QvQkFYa01oc2h1bEpH?=
 =?utf-8?B?aGpqdVZFZWhWYzJ0cW9MZWV4VWNwN2xibDBLLzF3M3g2SmtCanBHTHVDRU1M?=
 =?utf-8?B?OEJBY0NIREYza3FTTUhmQUJNanBGelVCajQ2TWxMWHdvZlR2ZVJKa24yZDRI?=
 =?utf-8?B?K3lBWEhFd1ZIR0FDdkNLNWw2cVdJZlVyR0huS2hBeWwxWGY0eGtRWGRNWVMw?=
 =?utf-8?B?eEc2MDdjRi80YWU0QlYrUDNSWE92SVRTRzZ5YXp4VVJzQlpGVzVSNTFxTFZP?=
 =?utf-8?B?Um1yakw3MFV3enV6OE5YSlpaVmJscktWdmdnNk9nYTIvZ0MxeFQ2Mzg2VTAz?=
 =?utf-8?B?bjNqd3JNd3dPTFYyN1E0V2FXeWZFVjdJc0pldWo2OTdMVlE1eDcydEpIVUk2?=
 =?utf-8?B?ZzdTM3pLcUpoWFVFOHJ0T1VncDMxdHhWd1VTN3BCZTVsdWc5WnJnb1FmbS9L?=
 =?utf-8?B?WHg4M3JmcGd0Tnk4YjczY3c3cDFubjNsbUJtSTIzU3ZaRytvVWM3ZjlROE1H?=
 =?utf-8?B?a3h2WVFLUXRDMHJxcXpSZHd1dzFDL1pWeXl4YW55SjBhY3FXa1ZXalpWcVRK?=
 =?utf-8?B?R0pCYUxWVVdWblVkOXpLZkR6Sy9sY2JuUk0zRE02TUhVaGF1eFdHNXE0dVFV?=
 =?utf-8?B?aUpiRnNYU2FrbEdDdCtvNWRrS25PbStvS3FRQlU1Mm93cjJrT0Zzc2FCMjhu?=
 =?utf-8?B?a1dtRDRmQ3VINXIzNXlkblBZaWFWYmxXaVV1aXBxNk90YzFteEtUM3ZMdm1G?=
 =?utf-8?B?SENScEJzUkVPaWNKY1RuN0tBZElVc3FkTVhQek5YQytHTUFYbDA3Y0dVUzhq?=
 =?utf-8?B?U1N5NUR0Tzk3dnRsR01HbHdwZUpTTHIrN3NRSjhMY1I3cmEzNmFoeDkvS0ZT?=
 =?utf-8?B?Mlk3V2o0OUdPMDVIcWdVbi9CU0pMK1oreVR4blIzS1o2dU5GSXI4UVc5c29h?=
 =?utf-8?B?TVpoZEU3VFhSSzdINnFVei9iUXZQSytXNWtOaFhlekJPYVRYN3Z2bmY0RjlF?=
 =?utf-8?B?RTErNGVONkRDRmE0SzRROEFjdEtzUllITWxaWU55aU1xQWRkbE1OZkkrbFlR?=
 =?utf-8?B?d2VqdlRDd2NZZGM3WkNkNlVzWC9vVVh1Q1JkWkdwdVBweWxMd1pCZUJqWkRp?=
 =?utf-8?B?V0lPMnBwMHdQU3Q4Nm84R2lxTHh0VExYaERmei90ZkxIRzlpNCtDTGdrd24r?=
 =?utf-8?B?NEZLM00wUm9TMktXWWNUK2pzcXhYbmx2ZmIvYnM4N3FEbDBZSDdObnd2Zytp?=
 =?utf-8?B?S2s3N0Zpa284RWhzaFlFOS9Fc2JEV3hNdHByVHB1V1JrbktobTNiNG5JZDJy?=
 =?utf-8?B?c3R2elRnQWdLV01iQXZBWU1YV0VmTEVMdWVOQmNYeEdYOWRJNmhMQnVVS3pI?=
 =?utf-8?B?d1AwaVJBQ2swcWg1a2ErNnJoQzRHYjhnZzYwUzZKSWdtUjIxNG9ORXNucThl?=
 =?utf-8?B?M2NHb2JpTGRxWUZBTTViTTdEQzNjSUVqWVJ0bEZ0b01YT3NvYmx5ejFkYW8x?=
 =?utf-8?B?ZDR0OTMrRFJSMGhJSys3OWZ5QzBSVHBXMk9PUVFpM3JRdTB6czBMeE9RckpG?=
 =?utf-8?B?MVVMRDMvaWpnNzhjQVZMWHh2ckZMZmVkUTFQN0RTSWpSOEdBRkNsRk95UzB5?=
 =?utf-8?B?eFh0TStPZTg3dXV1TGxINXdVcU8wYmlxWk9SdkozMVBXUUJtd09nSVg4Z0RO?=
 =?utf-8?Q?jHat1FfTZX8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zm94UmRIYXo2KzUzSTlCUXNDeG5Sa09KQ0NoZlNlNThPdzR5YzBnUDY0VG9t?=
 =?utf-8?B?eUhJQnhwQ05yL09xNFpqQVJZcTRPaU01Q29pUnFPV0VrSjFMRmE4Q2pwM2F6?=
 =?utf-8?B?MHlCWGpmem9xVzYrM3QyZXE1cDAzclZpenJRVkdPbHRkbEhkaFROZjZxdngz?=
 =?utf-8?B?VzduSUpMNUpyRVNIYTd4eXdaVDdxMTY2MGExKzFBbGxyVEkreEQwYzBkUnBh?=
 =?utf-8?B?b29GTnJlaGFBMWVzRTVydUxqcVQ4ekdxM1JkWkZPSEtkZVNJWG45MlRKcHk5?=
 =?utf-8?B?Y0R5ZlBuYTJhNGJpazRXV3dvWTk4cGxsSk9maXdPNzdDNGpaQURZNzBob090?=
 =?utf-8?B?Z0R3VHBqZGZKaHZkRmszYzVZY0dlZnFtSG1Ra2pWVm1lMHVUQWJpQi8yeFdr?=
 =?utf-8?B?VzAvVGxzUC8wVzNydUMrdTdMRDlzMTR2QWNyRlUyVFZGaW8rSmo3Q1pidjZv?=
 =?utf-8?B?THY2ZTRTbUxsc0tpbk1OZ01aQS9Dd3JsRW45Zk9NejVXWjNnLzJWeDV3SlZ6?=
 =?utf-8?B?MHFidGRXVGVyaVNTejFPYzJxbllxSnk4eXRJbTlpd2pLckRKaUVWWjM3L0tr?=
 =?utf-8?B?RDVaMnZVQjFocklsdjljWjNFanNXQnhXUmxpYStvOGdtUVRsZnloYnZkWjNs?=
 =?utf-8?B?T09TamkxUHhKblF0dGdDcEdvTUxXZUVKLytIUStwV1lHaDJsVThmdno4UStP?=
 =?utf-8?B?ZTM1MEtMamRrY1g4cENNTzM2aHdOUUo1eDZ4c0h5T0VoemFXejlIdkhiYVV2?=
 =?utf-8?B?RWl0YU1JQlg4YzNhTm0vUk1vYnYyN3FScDVCZVlaVi9QWXFYQkZLNXhhWTJK?=
 =?utf-8?B?aGdCVGVMbVZ3TWFvOGZjYnVWS3lRQmo0a2xXM01ROHM4OHVHOTRGOUlhb3dy?=
 =?utf-8?B?UWRickFncDVmM1lJQWQ5eDRHd3FYaVpabGxBRVF3T2FpMSt0MGN1eFliL3cw?=
 =?utf-8?B?Ri9MMXpXV0hsa09WWHdERnBZa1BzYXY4N3lsSXp3TnlxQ2s0a0wwUmVPcW45?=
 =?utf-8?B?eWwvWlJIMnU2Szg2RmZtbnN1c1ZMVGRqNHFST3h1ODk0MWFLS0I0aThrQjdj?=
 =?utf-8?B?TE5yQ21ROUNGZFBVV3QxTUZOT0xHbXFPYVZORlVHTWtzakEvcFZsUWExS1B0?=
 =?utf-8?B?UlJzU0NQTm5SOGxhZVc0SWR3MCtueVduVkV2Nks3R0ZNZjA0TjBGRk5DbmM0?=
 =?utf-8?B?dnFBQk93M1IwWjd1NXdjaHArNlR3ZlNybnkzZ2cyT2VPZmJVdWZFN0lNdTl0?=
 =?utf-8?B?SHJrbDlpL1RyY0d1MkNwQ0Z5SDNwOTZtOG5MbGVkSUgrVXFoblF3ei9EU2xv?=
 =?utf-8?B?Y1ludE15ajBkUi9vU3FPMUhPb2xpdXBybDhkdTluSVZMTkMrcWJaWEY1Kzl4?=
 =?utf-8?B?Vi9aMHRIY1RZbXgxb3B2eG5Ic0JrTU1QTjd5cmpKN054ZWVaWUdJYmhYaDhF?=
 =?utf-8?B?M3I4aFUvUzdPbGplelZjODYvaHd2ME0vTE85M3lqZzJSK1pHcGRmb3c4d2pQ?=
 =?utf-8?B?Vks1a3hGYkdTMXZaSUhEN2JCV1YwOVFrT3lIT0tFczM1MTJHaWY3MENDbkZU?=
 =?utf-8?B?Sjd2MnVYdFR5d3R3bHVoaUNyT25aWUx4VUkrZTVGVUp0RzBSays3MDd3bGZ6?=
 =?utf-8?B?MHVUaTBNNmZIRzUwT0RuQlI2MFdpZENReExVcVgrY2g0SHhTU3JQaFk1cS9G?=
 =?utf-8?B?U3RnSlZWRVJwaXZMM3ZjRXJJa00xK2pyWmdHWC91cFZQd2FNUTdzQTNMM3RB?=
 =?utf-8?B?OUZ0SlNQR3pESGRsWHFPMWtKRVpXMTExY20wdTJIb0IzYUdNUTJGSWtjUDFr?=
 =?utf-8?B?a29rU21tRi93bWcrRmUwTEZFWXA0MCtoY1VQcUNwNkoyZFpGcUNQS2hqOW9i?=
 =?utf-8?B?RlZoZjRCVWJ2bGQ4SExuYnRQalhlUWpuanRpRjl0QzNSV0dvbDRFdkFTbHFu?=
 =?utf-8?B?cGNBM2RyQTE1Q3gvUTYvSjJHREpRV210TlBjdTRrQmNHR0o1Z3BIajF1eFRX?=
 =?utf-8?B?RDQxSCttVWVnMlpMWW04SStGZEVLRXQ4UXZnKzE0eGl3T0JRSlJsMXd5WEJ6?=
 =?utf-8?B?cGdjNXVzZnliTElxQlJXTUFrVjNUQ1dTRGJJL1pJQmc3NFArWHM5OVVNcHJL?=
 =?utf-8?B?Y0dvTzk1MjlZSEIyQUcyM2puT1pzUXpSZ1NuNS9kMStjN1BzWlk2L015SWFm?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3724d15-adea-4d51-dae2-08ddf01c3093
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 03:43:22.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJvE1KMaGlLJEqWbmcSGa1G0d3iuTWyXZ3Dk81Ghdkt9CTheTQDiVsbfrNj6km4yyLIvwII223x2q5kE28pbFfsQ1fbAEKQ9dwp6TGDj39k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8846
X-OriginatorOrg: intel.com

Hi Tony,

On 9/3/25 11:24 AM, Luck, Tony wrote:

> Agreed. See new mark_telem_region_unusable() in updated patch below.
> Also pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip
> 
> -Tony
> 
> P.S. In addition to all the extra #include files you suggested, I found
> a few others missing. So those are added as needed in the series.
> 
> From 163824a2e10de9f63e20f0bc9f86b8c14f58bfcb Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Mon, 25 Aug 2025 10:47:06 -0700
> Subject: [PATCH 21/31] x86/resctrl: Read telemetry events
> 
> Telemetry events are enumerated by the INTEL_PMT_TELEMETRY subsystem.
> resctrl enables events with resctrl_enable_mon_event() passing a pointer
> to the pmt_event structure for the event within the struct event_group.
> The file system stores it in mon_evt::arch_priv.

This is getting to be very detailed description of code as opposed to
what the code does ... hmmm ... looks like I already made an attempt
with a proposal in v8 that was just ignored without any reason. <sigh>

> 
> Mark regions that did not pass the checks in skip_telemetry_region()
> so they will not be used by intel_aet_read_event().

Apart from skip_telemetry_region() -> skip_telem_region() I think this
should lighten up on the code details. Compare with, for example:

	Mark telemetry regions that did not pass the sanity checks by
	clearing their MMIO address fields so that they will not be
	used when reading events.  

(i.e, more about what the code does instead of actual code)

> 
> Add a check to resctrl_arch_rmid_read() for resource id
> RDT_RESOURCE_PERF_PKG and directly call intel_aet_read_event()
> passing the enum resctrl_event_id for the event and the arch_priv
> pointer that was supplied when the event was enabled.

Also heavy on code details while written as though reader is familiar
with function (intel_aet_read_event()) introduced in this patch. Compare
with, for example:
	Introduce intel_aet_read_event() to read telemetry events for
	resource RDT_RESOURCE_PERF_PKG. There may be multiple aggregators ...
	
> 
> There may be multiple aggregators tracking each package, so scan all of
> them and add up all counters. Aggregators may return an invalid data
> indication if they have received no records for a given RMID. Return
> success to the user if one or more aggregators provide valid data.
> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  7 +++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 65 ++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
>  arch/x86/Kconfig                        |  2 +-
>  4 files changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 9ddfbbe5c3cf..8986071dd72a 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -172,9 +172,16 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,

Patch 24 goes through effort of making RMID unsigned while intel_aet_read_event()
casts an unsigned RMID to signed?

> +			 void *arch_priv, u64 *val);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> +static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> +				       void *arch_priv, u64 *val)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index e36b3790733b..170158d40e27 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -12,13 +12,17 @@
>  #define pr_fmt(fmt)   "resctrl: " fmt
>  
>  #include <linux/array_size.h>
> +#include <linux/bits.h>
>  #include <linux/cleanup.h>
>  #include <linux/compiler_types.h>
> +#include <linux/container_of.h>
>  #include <linux/cpu.h>
>  #include <linux/err.h>
> +#include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
> +#include <linux/io.h>
>  #include <linux/overflow.h>
>  #include <linux/printk.h>
>  #include <linux/resctrl.h>
> @@ -131,13 +135,28 @@ static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e
>  	return false;
>  }
>  
> +/*
> + * Clear the address field of regions that did not pass the checks in
> + * skip_telem_region() so they will not be used by intel_aet_read_event().
> + * This is safe to do because intel_pmt_get_regions_by_feature() allocates
> + * a new pmt_feature_group structure to return to each caller and only makes
> + * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
> + * returns the structure.
> + */
> +static void mark_telem_region_unusable(struct telemetry_region *tr)
> +{
> +	tr->addr = NULL;
> +}
> +
>  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
>  	bool usable_events = false;
>  
>  	for (int i = 0; i < p->count; i++) {
> -		if (skip_telem_region(&p->regions[i], e))
> +		if (skip_telem_region(&p->regions[i], e)) {
> +			mark_telem_region_unusable(&p->regions[i]);
>  			continue;
> +		}
>  		usable_events = true;
>  	}
>  
> @@ -215,3 +234,47 @@ void __exit intel_aet_exit(void)
>  		(*peg)->pfg = NULL;
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain). If an aggregator hasn't received any data for a
> + * specific RMID, the MMIO read indicates that data is not valid.
> + * Return success if at least one aggregator has valid data.
> + */
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
> +			 void *arch_priv, u64 *val)
> +{
> +	struct pmt_event *pevt = arch_priv;
> +	struct event_group *e;
> +	bool valid = false;
> +	u64 evtcount;
> +	void *pevt0;
> +	int idx;
> +
> +	pevt0 = pevt - pevt->idx;
> +	e = container_of(pevt0, struct event_group, evts);
> +	idx = rmid * e->num_events;

Looks like idx can also be unsigned (since rmid and num_events are unsigned) and
should be printed with %u?

> +	idx += pevt->idx;
> +
> +	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
> +		pr_warn_once("MMIO index %d out of range\n", idx);
> +		return -EIO;
> +	}
> +
> +	for (int i = 0; i < e->pfg->count; i++) {
> +		if (!e->pfg->regions[i].addr)
> +			continue;
> +		if (e->pfg->regions[i].plat_info.package_id != domid)
> +			continue;
> +		evtcount = readq(e->pfg->regions[i].addr + idx * sizeof(u64));
> +		if (!(evtcount & DATA_VALID))
> +			continue;
> +		*val += evtcount & DATA_BITS;
> +		valid = true;
> +	}
> +
> +	return valid ? 0 : -EINVAL;
> +}

Reinette
