Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D26C1DDA34
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751561129; cv=fail; b=AniOwgp8UCmiVMDrCKUApVU47AjGDZNw9SUlkTMIep71vE58Ntu7xXEbOlIguqpOfjHcsbE2aFqQkmHgecy9f7FiTZvoYmh6gzBXRmaPkH0sQsZnxCSlO4xtSfMBrYnogQW173Tc5ubahynTkjwlAqMszNXqXsksaClEcYe7f9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751561129; c=relaxed/simple;
	bh=/fRQHqqDj+TweZiT76WqMMR7iLwKnzTCVlQtJD8kicM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MHVnaTtuGQqhz8eFm/Q+Ec8UULrPf5lwMTcawQ71wPV227DDUaCY4wLhruufLlrrKuxpukO1rCFxkifysbGrP0vhFsClvApVpfuhTl9rAN3RGp+I25h4LqivLBeIMK8IVVpI6lyKRjZIB6ZonKEWIWylLQca0xFDOCMCjKrWV2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i2FoAMOF; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i2FoAMOF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751561127; x=1783097127;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/fRQHqqDj+TweZiT76WqMMR7iLwKnzTCVlQtJD8kicM=;
  b=i2FoAMOF2pTVfnrFtUUTBYraAvpjqJRtvFnQgbSVrF7BvAsy9zf9Vewd
   8KzUxrFkPS26mDMZ+cmQa1+Q4CDHEU+iSeEI339cBiXR70sJYmb99+sN0
   NafLdOnIVvFhpB8yMWhI6mh5mjO/GG5beB9X6wr9lbwdx2t/EiFw19PVj
   5ywHzDx6TL0ph3MsN1mfFqKkCUZXE+4HwopDmwyZyyNMBPbF7xS5elFXc
   kuz6EPjtSl30gnO8auo6n4ZFDHfQtGQ86IJa1eOyEA+ojCNoyvT8zVoHI
   zOkgHFcXv8g24W5POiH2C9QKcnOqRQUMqU0yl0THLLBucdTzh9IgJ9Z86
   g==;
X-CSE-ConnectionGUID: Tx6gsGlYSPuyT4j8/1X1ag==
X-CSE-MsgGUID: Hw2UG632SF6blZlc7P7nXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="56516211"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="56516211"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 09:45:25 -0700
X-CSE-ConnectionGUID: P2fUP2gsT8K5xW/5cPVwQA==
X-CSE-MsgGUID: 6+TZxFG5Smu+B3znrQ2z+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="153850122"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 09:45:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 09:45:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 09:45:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.80)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 09:45:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zs1B2Tj848Yrug+OAI4qIAzeR3mfYYTk2IVKbkSEBf63um+6yNXWyulbe6Tq7xst5SsZH9KSiNcmkxmwLtxp1uGsQvD7sCuNMUTpnly/kAfy+xSZnqKH/21J1xsUFqiWcmOoLI6IXdHjsjUJdNQa72RPNjIdp7/iUXTSBM1ShghBpTtIKAVMJQvHjDOHn+TzFn6mfVpn/3zjKvvKXwxaw5W6VuQKhcK2oLh1azUGOBejGbDBMTet+NTerELSxVDkf6PFkWPPyDTaa8wKJvOOqhr4xvVfiUNf3n95Qqse4f5/COegOh4SbJRcG5eSAMjIOfLvMSRiPbVc8io3Ia9Arw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdU8WC7sCUIjcT7yC0HYTfHVgpDdLVCoSi7HUBx/D2o=;
 b=jQ7yubG9ubcxHwHqCgVItCOg5zL+R4CuuNLHvceZjZ6aHOuai8bOsCuC3gwMl8T+5OrCGY8Bp9/zQnwG439XtWIj1OUEmI8apY8dO8o5x1PcdVPBEDPjDt8gG6j8wBGfFmgFeQD6EJqnqlsHX972ZT3xA7duGQNGo/wTWR0EYSLJDqhg+KUvqhtq5ILKgBloejs2hj/4rS01gn0kvQl5lauCJqVpR2ar8oeJUcCNC0Jvwhx3M5qKRoT8HQlMtqjhZqphlQWq+IE+48jhgbp5x9m0o2i6oiBPfFgcRPslHhcx0Jp40UjUBKghZ2FabFozUJjBMg6pVRbB5CMfroXlcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6914.namprd11.prod.outlook.com (2603:10b6:930:5a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Thu, 3 Jul
 2025 16:45:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 16:45:18 +0000
Message-ID: <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>
Date: Thu, 3 Jul 2025 09:45:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0216.namprd04.prod.outlook.com
 (2603:10b6:303:87::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5701ef-c868-420f-ebf1-08ddba50fdf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NkZHOThIdnBCU2oybUo5N0xXakpYQTVPNEVudU02ZHlaTjlLazJtUzA3aEg4?=
 =?utf-8?B?RFBmRlR0SVhLT2lFS1hFZ1dMR1JqUUplcDdWVXl1bmJKMFFUVm1HV3VPSGtQ?=
 =?utf-8?B?dmw4YVhFaUN2N0hUVzVBSUZSYWdzZWVXclFJZ3lHYStXMlFxQWlYUzhHc1Ax?=
 =?utf-8?B?alJKdTB0bzFwSlF1MjVwaTJ6WUZ4VlhyZU9kbC9SYm1GY3A4VDc3WXBOVVp5?=
 =?utf-8?B?bnZHVnJuM2lzNUtrVEF3ZFFKT0hDeGpOYjJ3K2lKNXNhZHUwMFBOQk55T1BN?=
 =?utf-8?B?NXNzNFJQaEZnV3RCeVlobldvTGdBUFNMSjJ1ampiS1VwUVJWaU1MVDR3bXR2?=
 =?utf-8?B?UkM3b1hmOUZLUFNtY2ppM0ZQQUdPYlUzNWRkQnYzUVROcUs0OERiMlhxRE9I?=
 =?utf-8?B?YVZaSnVjQVdxV0lJQ1p1dmJ2NERxWGJ4ZndUNDRpNjRQV0k5djBRNkR6OWdX?=
 =?utf-8?B?Ri8rdnQwcW56NzNwZm5XZTFOUFlwaUppTU9GRURoOE9yRVBmR2MrTXJ1MSsw?=
 =?utf-8?B?MjdzVWJ4YTNIaVNnMXVnN2t0WVphbjR4c3l4RWUyMUxuZnViOEU2SGRQUjBm?=
 =?utf-8?B?SkJXR3RIOXJuZnNyYmNuYkZnR2dKZXF6OVhsS0MzR2UvbmNZbWJSNG1Ybnh3?=
 =?utf-8?B?am9rUmpwanBMa3NSWllUcTEvQTh3WjBMODVGT3g0c2t0dUdKTzlmTnFMUWVG?=
 =?utf-8?B?OTcya3JnYXJmK0NaSTNPemgybndTK1k1WW9iVDMyZlZ1TEZneGdsWGRUMVRW?=
 =?utf-8?B?YXh0OHAxNzJ3YkxKMjJSRk1NU3Z4Z3M3MG02ZjJvMnRXQ2k4WFI1a3hTNXdQ?=
 =?utf-8?B?a0UrZWQvejFCYVlJamhRZnNtM0pIWTJaVlVURysyeE9hU1ZmYnhYZmhHaURk?=
 =?utf-8?B?TU5DWFRNbElHL1k2NWZIQUVoWm43enlSaGdTbkkvaEROd0tXTU5JYVpnTjZC?=
 =?utf-8?B?NXpVcWZYWkM4NkVpSC9ya0hPZiswZzZIdGhhZmw1aE1ubGZZK0lmZVVWcnhV?=
 =?utf-8?B?ait3ZVJGbTcrcjh5SUgyZVQ0OTBhUXNESXNERnVXSGlHeUVacU1MODU0aWt0?=
 =?utf-8?B?dXF6SlVrNGVaa1hOVGVKK2NWa2hRb0U2Mk1XcUZPRHlpYzBXSTRVZTNodzRD?=
 =?utf-8?B?K3RKbWxyUDRGQUZLVkhhYUZqUTl0ZFh4ci9YOUhJaFlGS2M0SkFUdFJPclN5?=
 =?utf-8?B?UFozODhtSXR5ako2Y3g4Ni9xT1JqL095OUtLQ3Y0bXVlaXBRNTZtRFh2VmRk?=
 =?utf-8?B?cWMvM2s2VWNTQjk1djdDeVY4aGl4MEl5ckttZWMzTENMc0M0eEhIMFFQQU5O?=
 =?utf-8?B?QVpESHF1Q0FXbkdLTmJyNEd2R1RyTVljb3dBa2lzelJiTjFGQVBlQ3NiY3Fi?=
 =?utf-8?B?NG1uc0NhMWUrZkNuSk1DT2RyRnJDWisydE4wRGZTY3J5YkFVMm5kSFdPTG03?=
 =?utf-8?B?bU14QkZZZFdvOVhXYm9Tc0t3UXNlZzV5NG1EMFBZTnFyTzlZT0hzVHdFaU5n?=
 =?utf-8?B?TW9WdGFSM1ZWL3dlTGJuNDRGbkp5QVlxSzg4YXg1bkY3YzlraEltdzJwM0Zs?=
 =?utf-8?B?SGp5U3JmUWNENUZiMi9SOCtyZnFuZ3NnOG1obHozM014YXVSYVc0ZG8xQXQ4?=
 =?utf-8?B?WEN0QVNOa1NwYnlZbVM4b041dW1MTkdWaUd4ejlsRGtBdGJPaW8wdUc0aUVS?=
 =?utf-8?B?V0lzOW56ZjdJY0hzenpFdWdxUVVUMVhIS08xa2tNMDNkbkdpS1YybmkxTXFG?=
 =?utf-8?B?ejNVb2NqZ3FvQjdUMmEzcjBySGtTYktRRi9QQnJ3SUl5Z2dtQWU0WXNqZnV1?=
 =?utf-8?B?M0Q3L3VJUmkwYTFjTzRpc1M5SG9JK1RmRHJpQVN5OFVCdnkya20wbk9IREly?=
 =?utf-8?B?SHR2VkYyU2dLR1prcHdxVUVwV0x3VVhJSHZscldUQytVSnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXB1cklOY1lhQm5SakJwOXRwTTZkd2x1L1Eva3JMSTE1Q2RaTlNENXZtWlB2?=
 =?utf-8?B?M0hCaFhHMjFrLzlUbGJjMnNCY3pUc0I5dHNnWERLWjJRR0JrVmRaSUJIdldV?=
 =?utf-8?B?OXdOMUh4NUpnK3dKOU5JSm5Vb3Nvc2xhN3FqZ2RtQmZZYjlXQUR2eEhiNGVN?=
 =?utf-8?B?bVZkMlRxU1BEWHdyMTROR0dzbWlBVlkwaFVuRmpMaVY0OFErMHJIOTNmZEtE?=
 =?utf-8?B?dzBldm5JaUw1c2RoVXJVQi9vZG9TU2F0LzJhTWJTNjlDM2lRZlVwNkNhMTZM?=
 =?utf-8?B?bVlXeFJDRTNMbklHTGhaNjhSLzBCbXA4RkZoUVF6YzZiY2d0eGxhay9qK0F3?=
 =?utf-8?B?dTJBMk1QQlY5RUFkMXRNNVlxT1JsaDdIRjlNREVBbGg4elZmcmhSOEpDQzVE?=
 =?utf-8?B?S3lxQlNvakJJWW5FUStMNWF3MWwzWi9vOFBuUU5sOWc3WHZNRHlrRUZHd01Y?=
 =?utf-8?B?S050UFJMSERIZGNTRFJDSUdRb3JVaUtoalQ1N0Zza3F5QS9lVjJ4Q3BlbWds?=
 =?utf-8?B?R1hsTDMrQVFkQ1VtcUJJS2tvSXlnSldMejdOQVRVSzRFTDZtTVpld0dFNjZr?=
 =?utf-8?B?bW9WK2o0WG9BUzVKNElHaVpYOXNJNXNUaG5mU0M1eHU5TTRNWE5CMDBwdThD?=
 =?utf-8?B?WUJMTWJ3YkRLcVByMjVHYURzcEpFQmZPWlZ5MzRkaGlVQjFpOWxKVjBxcmg2?=
 =?utf-8?B?UnR1NHNINVVVajMyOUJSRU5lTDlrZ1IzWFM1T1NLNXg0SzNza254MTZmZVEv?=
 =?utf-8?B?cmdxY3dBVzBKNjl4YXRHa1Z1NkdieVIxbjg1QlFMSmZaeHR6ZTZJd2tva2tW?=
 =?utf-8?B?bnN6d0Z4N08rbFdFZ2lLQXlWL2U5N2orKzJZbEx2Nk14bVVzVXBXQlUvQ3Ra?=
 =?utf-8?B?U2QxRmlyWXlKVWNYU2NDdzl0cjkrSFB2YTdocStiQ0k2Z1dlNkhHUkNYZnRl?=
 =?utf-8?B?Vm1kKzlQOFRVUkhqSjBvaEpRN040TVlnOGRsUWx2VlBTalNvenFVQ3VIYkxX?=
 =?utf-8?B?bmF1Z2kyckRjcnJmc1oyRTAyT3lXa2xzeEx1ekRkS2JuaWV5eHNyYmlDNGY2?=
 =?utf-8?B?N2pJa1E3ZmNCbUYwSEM0dFlJUStaSm5Qc1JhQXNCMzlma01ud2tVVXVGZ1Fi?=
 =?utf-8?B?Qmh5d2I3ek9QU2pjL1RENzNwSW5IdUlHMFQ2Znh1eEdGdkx6WjBnVnRFQ3Y4?=
 =?utf-8?B?WktzUUJoS0xpOTRZdGM4YXUrekJxUHhVQ0pkWGZmQ0QvWC9xVWRKRFhBaTZG?=
 =?utf-8?B?Z2o2anZNV1kwVk96dDlaT2VrdEF3bnFOZVdDMEg4MDJGU0pHc0wrL2RPeFVm?=
 =?utf-8?B?RkIvOW9XWlBlMlc4SmtoR01ONDdYSFhvL09XOVdKUFFhZzNtV015bzhjWXZv?=
 =?utf-8?B?bURvaWZnNXBjQ2hkQUdyNG9vZXlkd3V3dzlMV2R6MnlRR1hzVVBBMUkxSW9D?=
 =?utf-8?B?eXVYcUlSdVlyVGJ2U1VDeXltTFd6TXhHQk1aSkZUU1FtMm1PTzhRYndyV0dP?=
 =?utf-8?B?TDl1MTNmVWUrRzhJaWtZa2ZiN2RXRFlZQjA3U01lSmV5Sy9WWGpSZXJVSG53?=
 =?utf-8?B?VGQrWWRkZ1RZUWVORHk2K25wOWk5Y2tBRXhWTE1HVS9pTGo1M2dyL2U1Z1pG?=
 =?utf-8?B?THZPRkpZYTgyNWkxVk9HdXZTcnM0d2R6VHVYZmgyZU1aUnRlM1JwUjZ1UXln?=
 =?utf-8?B?YUpGR1BRc2lBbFp4Z040bVBoOERpQ25qYW5TNzZ4V09SK2psaWJuamR6ZFow?=
 =?utf-8?B?NWozbS85Qk1FcVdEbGZGNlljMWxJSVBiLzFtSmE0RGhBTnNWd0w0QnV3Szhl?=
 =?utf-8?B?Y1VaSFZWdzNzV0FzZnRmRFdIV25SUW5iRmlaVFJEZnhqN0o2NHdITkhvS3oz?=
 =?utf-8?B?Wk5XRW0zbWgwMXVPQlhuYkhZSUxYV2tXUmlvK3FLVFc0Y0V3V0tZS3FNZ1NL?=
 =?utf-8?B?UHdGU1c4em52ckFJR0lIakwxUFhMTDJaS1AxalpQaVNQYWh0YjVxMGZLV043?=
 =?utf-8?B?bkxOdXdhMktrM2hKQ0IrNWcxSzRNTThtVkpYM3JkQlF5ZHBHdkUwWmdHQXB3?=
 =?utf-8?B?RlBmRGVScEF1RnpXT3ZZNkMwMzZuMHdqOTB1UXNET2xCY3Y4Y3I5c3pURkFE?=
 =?utf-8?B?RjhZMXA1alJsa2pkMytsN0Zuczk5ODZyOWh4VWh3TXJUUVFEWmxKeFlsOGQr?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5701ef-c868-420f-ebf1-08ddba50fdf4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 16:45:18.0367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMwV+Tq2ynDBWd8sriLSsxNuRdMI7y/L8BSxKdVDW057TV98FCVyj2M1CrgjDgtF3MT7eJ1VYm0RzqF7VNcVrx1J103i6v9X4FEsU8C7MaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6914
X-OriginatorOrg: intel.com

Hi Tony and Dave,

On 6/26/25 9:49 AM, Tony Luck wrote:
>  --- 14 ---
> Add mon_evt::is_floating_point set by resctrl file system code to limit
> which events architecture code can request be displayed in floating point.
> 
> Simplified the fixed-point to floating point algorithm. Reinette is
> correct that the additional "lshift" and "rshift" operations are not
> required. All that is needed is to multiply the fixed point fractional
> part by 10**decimal_places, add a rounding amount equivalent to a "1"
> in the binary place after those supplied. Finally divide by 2**binary_places
> (with a right shift).
> 
> Explained in commit comment how I chose the number of decimal places to
> use for each binary places value.
> 
> N.B. Dave Martin expressed an opinion that the kernel should not do
> this conversion. Instead it should enumerate the scaling factor for
> each event where hardware reported a fixed point value. This patch
> could be dropped and replaced with one to enumerate scaling factors
> per event if others agree with Dave.

Could resctrl accommodate both usages? For example, it does not
look too invasive to add a second file <mon_evt::name>.raw for the
mon_evt::is_floating_point events that can output something like Dave
suggested in [1]:

.raw file format could be:
	#format:<output that depends on format>
	#fixed-point:<value>/<scaling factor>

Example output:
	fixed-point:0x60000/0x40000

Reinette

[1] https://lore.kernel.org/lkml/aEhMWBemtev%2Ff3yf@e133380.arm.com/

