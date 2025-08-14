Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95942798EF
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207486; cv=fail; b=cqd5PNUG6H9LoQr8W5PhEzVLQfL7P/uPBJFOU37MKUg/EKD/QM3dcI0w8yEHo5Juiy6g06VoaMB9q/W4qvDV1Gm2albMOhLCaIPu+nKbyPeYbnoiDKbzOSdiZE/6yp7pXv1Nz0EjWU9all26dMKwiwOEvfvOX5Zn+EIyCnHbIBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207486; c=relaxed/simple;
	bh=OZEJyAKomswaz+veX6yKPt9LtWu96mWL44r4AUwzF18=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jf48sdeAgXgZkFp0QeQRy/2/wLAZgX/66xTAYYGU5cAscOAbOgHQd0069Wdphoqn1q7J1yFzojNWWd4Gmr3vo7X58ONsHr5S+aOEJ0M0iPnTjm67Emk60y1sowS9s75C5x5VvD1f/iKiNWCwLSM1tjIWYnUvKylkEcCiADqEgmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RVmfQU24; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RVmfQU24"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207485; x=1786743485;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OZEJyAKomswaz+veX6yKPt9LtWu96mWL44r4AUwzF18=;
  b=RVmfQU24/Qxug23BwK9VxeFdTJxFNOeGN7HA4SWNO3XG5d4nwHkr0hYK
   Da5fAL8x7Q3Io2MNppvGfSXabbtXjonxumNWoYEWotwpXykdNomLORqbG
   htyGldnuQdop0H97QTEftMqau+9xvPJA3LfQGw695SSjcfvd2WgAG3+EA
   bxeocyLpi1ZS6slvQQZ3Tg7lDOL+uvGspTcQKfboF1W2xB7HqOfxdRR/2
   9U9eU2N6D4mXxhzhVlE8uPvTgS0TepfriCuahEj6GlLc3zQMMC6Lx365l
   k1kEioyXkgNS7WgEyI/RIvf4kvjvgaW1iBxGkwAisEYTSsDqL9Km4a1Br
   g==;
X-CSE-ConnectionGUID: Nhk3tlUYQXafI4CPuKsJaw==
X-CSE-MsgGUID: 2WpEVB4HQLGwMz9N8J5N/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57463025"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57463025"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:38:04 -0700
X-CSE-ConnectionGUID: dFEdn2XmSr6617BJF4ga5w==
X-CSE-MsgGUID: wjrmYxGJTJKmr2u6JhHpxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166768238"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:38:04 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:38:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:38:03 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.87) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aUs2TBOby4MAJKC9K43Q93dztgzuY1n1nLLUb6g2YwA/hFl6Lkz2g6h7C+oAQtvUDNEOq1zXY4EPbPnBT4GaPCu0gE2wn17zTHdYC5u9a8I8LskHb/tQueVAu2+MqF/Vr0psjXB9KClTzdjN/fTixgfMxpIH40WPIPNT9LMTtnno/VHY1iBl1yKnsnQx1T/IG9p5RQxhYMhT38Hw3IvGuRnZRmQh9pUvoiLC9jt0ESnylXa4YmzsbtJQSbBfqSJurXJdAQ+D/L5tKllhz4lThKkWUUndwDtn7F++Cr8N6F6RyX20/7EQ2Mf2El67mmUASSMO0QwVU64h1dHiEV10iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMeiFLLy/w5wR0ohfRfwoL/6MPCi5tAMROpr/DoLfak=;
 b=LwkHw9qNQ74dyT00VIDIi1eGHMxsoO2wf9fSoRU0KNqX4h72N1XZamOkRxRfATEY0PKMemsdaAFalzvBzqgp90fqjNf8Fmx3I8cFCiT3w6krs1GOQj15D4gv7AV6KWHHHtyj7f/dzo35eSj/DVuUTvX796c86Vd1DsmXT/1hzh4vOnRIUBDmiPaoE/uIhFNAMohA2rSB6cH8E/NF08DrKPLykGu80s9D1cqRgP6rcZPdWB4umxZeZ06VAjH1fafW0B21VlmhBUYCGryIGpSqTG2H0/8bxo3jb9DWTM8E4rB6v8+FF96bxUlSt+TKTUV0vDcDGt2o2PT8Sj/KmZX8KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6552.namprd11.prod.outlook.com (2603:10b6:8:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Thu, 14 Aug 2025 21:38:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:38:01 +0000
Message-ID: <2f8850ff-884f-406b-8971-c108df5a5be7@intel.com>
Date: Thu, 14 Aug 2025 14:38:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/32] x86,fs/resctrl: Add and initialize rdt_resource
 for package scope monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:303:86::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb9f579-cfce-4ba6-fe14-08dddb7ad82e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cDFNUzV1enR4dlp1TFlVT3ZyV3B4SW04WExSTXFtbVlKVkFoSityczk1ZExs?=
 =?utf-8?B?SXdsQWtXb3Z0S212ekpsZ3pEWEZ6eGRtVXVBbllLTUpsQmRWMEpvNC9UU1NJ?=
 =?utf-8?B?WHg3bEwyOVQrcThMeHVFNnhkR3p2MFJSSDFrTGtwemQwYlREUTVSMDNWcHZT?=
 =?utf-8?B?UGpPSnNFdEh6K0RpdEl4N2MvWWI3dUd1VERieWJKUGkzbHpEblBaTjd3WERa?=
 =?utf-8?B?NDVIQ3Q0c2xqR0pYYTlqc1c1VjFlWmJiV3hMVlpwZjdWNTNnL2d5c3JkRmgx?=
 =?utf-8?B?MnZVZlZZaGRNZ0Yzd2xuVU1meHN4eGZuVlpCSVlCdGpJRjBRekJ6bUt0NnpD?=
 =?utf-8?B?c2ZpZFZONUQrTnNocGdNcktzTmxvSTVrcllFUTl4YVZ4ZmVHV1VEcDZyTk1B?=
 =?utf-8?B?S04zRW16K3JtWXhsc0Q2bmFQRU9HQjMrYnVQTTJjV0dIandsQjhiN3lqaytN?=
 =?utf-8?B?eVpTcUJQczZBTjJTNmlTd0NSd0JxQTQ3eUZRVDFyZkphMjZiSmp3ajJ4SXBk?=
 =?utf-8?B?dFJsaWFBQlpvaVBleStnUXFUVWpaQlVRYW1QZVBoVnB6aUxVY1ByZC91K0t2?=
 =?utf-8?B?eTdWTm44bWw2OUpKYzNiQ3V0VHQ3ZWJsMnVXWUVPcXFDNGhiNTdUMm9qNldD?=
 =?utf-8?B?WjhlMGJPQmptTFRleUNxSDBTVkFKbzlJL3pCOEZVTmwyMHE4NS8vVm9nREha?=
 =?utf-8?B?Qi80UTZRc1g0V3NrYkdDTFZXYjJnRzcweHRwRlN6QlQzUU1nQXRyOENvMDBx?=
 =?utf-8?B?bDd0L2dUYXJjYkRUUW9ZL1Q0K1ZibUJnSE1iRjcwQS9iRy90dlYxNnNwMlg3?=
 =?utf-8?B?QktXZTVFNGhxMi9yNkFpOHFPcnhkdzlQVHkyNWNpSkJ1Z05iODFnWXNxQnox?=
 =?utf-8?B?WHJRWCtYelgraUhvdVpBQlBzQW5pRG1rbDUxZFFUaGpYRk15Vi85WnJHZUtF?=
 =?utf-8?B?MURpU0l6M1hpUmtvVklzMFVhSjEzUmJncDFDNVFobnVQbDRnWGpPZFdxT1Vk?=
 =?utf-8?B?Rlp0RW52K2tHdWpNQjZCRzBoUkF2L3VtVjZVYkgxZStiNGRQQ3RJeHJoVDJG?=
 =?utf-8?B?dU1jbHB1ZytXaG44a0lvOHB0Zk9CcVJCcm1NdjNsczBkazFpTVB0dmNjTlpU?=
 =?utf-8?B?aVZnTk03bjFiQWV5clhKZDV0NHNRTHlzVkZlOTdLb21HNDRRVU8xVlBQK2Q5?=
 =?utf-8?B?MmNLVnF5QldUMS9UWENTYjNCYjY1M0hpNkFPcUR5blBjMFZPVTJDODZmQkNn?=
 =?utf-8?B?NkRQWGdqeWpBa2luam8vK1Fwb2RVZnYyT0dvZ21aUWh0eDJSM1ZBZGMvc053?=
 =?utf-8?B?dllpZEVkMGkwRm95UDE0bGZLbURiNkJWUjRYTmRBa1JwcHRuTWd0dkI5Q3Z5?=
 =?utf-8?B?ZzZZVElWZlR1NXNUbmxMT2hxeDRhclE2bXAvU1lXYzFZRldlck5SOGRlTUo0?=
 =?utf-8?B?T0JxWTVuUWQxclNrMkZVNDZCa3E1VkhvdXhvRHB1K29DWU4rK3BYcmEwM24r?=
 =?utf-8?B?TE1rWVpPOEliVytXWGdCOUlwRWZUY294Z0IwM0UvWlU4WmlSZzV4U3Z1L1pH?=
 =?utf-8?B?eWpUc0Q1TngzcGEwVEkwNWV2NzBDYkJ4UENFWFZmZ1ZoWGMyY293K29VV283?=
 =?utf-8?B?QXcrTE1Ic2JjaThkeHd4YkhaWk9nUjVKMmVSaFUwSlFGb3RzZlJXZlhidUU0?=
 =?utf-8?B?N05TQzJ5U0Nvc29KNFlyQWx2MklVYzF2bmliM2FKNVNtcXRDS0JMRkYvb3F4?=
 =?utf-8?B?NzdiQXhTUUdrU2x2TXVWVTIyVW1oNURidXdzMVBRSS9vRUFqOHhTRHFEc0Jt?=
 =?utf-8?B?TTNwK0w2R0NFdG0wcWtQbkhxS2hyYWNxUkJDbDN0WXBqYmg1MGxvRE1GYnVj?=
 =?utf-8?B?SjkwalJwaFpkNER2QUx0RVloaThkNkxFT1dTVVU4cE9hVnNLTUdlS1l6ajJk?=
 =?utf-8?Q?QPxpaOw8YFc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3h3YUNUNnhyUWpFSE1vTlorM3k4VW1rSTdlSUJtd2JROFhYSjFzL29lZWE5?=
 =?utf-8?B?enlpMXk0eEo2SzNpTmxSYUI1VEt6TmtQdTZHNkRMa0FIcmVKTWdYNGhWLzBT?=
 =?utf-8?B?NUYxV1h2RnBmcEV2YTl2dFJYb3JLcnVudjExc0ZxV2JDK2VzMmZxZHMrN3dM?=
 =?utf-8?B?aTd0TGxyMGpwbVhNUDAxOU5TcnNyajFuWFRNbzhPTkoxUE8zWmF5Q2plT2xp?=
 =?utf-8?B?MkhwUThzMEdxYS9sUWpMQkF1NFFEMXJ2N2J4QW9HazBFaXkySUtYV3A0K2Ja?=
 =?utf-8?B?aUtXNTNGd3ZPenpEV3h6L1lxNHhOM0hyTTlZaTlsMzdTZldVY2dkdE5xVXFn?=
 =?utf-8?B?Zm1GeFU2SW40RmgxK0kwY0xXZE0zR2tHV0dBR0RTVEdtN3M5eWVhV0IrYnhK?=
 =?utf-8?B?b0Z5ODRQQ2VnRlRFRlRvWmc3ZEQ1RHlQbS9sUGhKT1hmWGJhak8xc1hOQmFM?=
 =?utf-8?B?eERRMzVkUFZPemFkK0RQZ0VpbW1PdXVWQlZybnIzRkd5OGpLNGlSTGtiaVIx?=
 =?utf-8?B?SlVYNVVMUmFaOGF1WE9GTVZuTWVoQ3BHNlB0RVhPZW9TMDNTeVl5NjZHUi85?=
 =?utf-8?B?YlFSdCtVbHk2YUM2YmI3L1A4WE8xaHdWVkYvTnhkVzJ3RUdMRk9TdVBpNWcr?=
 =?utf-8?B?MXNCbjNoaSt0VEladWFnalBpMnU5akdydkZPbDQrVFVtZVFrUUgydnAybjJL?=
 =?utf-8?B?cjVEeFdMc0g1ZCtRNWd5TGoyVStLQU93VXN6Q013YWdYZkEzazhaQlVpYXpW?=
 =?utf-8?B?YnprK2laczZyOWtxa2IrS3hNRVZsNUF6RW82eitDY3RGWFpvSVVMYXI5M1ZT?=
 =?utf-8?B?TG9aRjMwK2V1dEtYUzRlUkZML25uS1FZbXV3RlNzdTAvbVIzMGpaVENMcERr?=
 =?utf-8?B?MjhQMkJjOVQ1eUlqODd1WnIyZ2FzSzNhd3VXU292Wk90cGZqNzlLMFk2R3dn?=
 =?utf-8?B?WU1rZ0c3L05RSGRreTFSTkFJa1d5OWRiZFZ0RVVSU1A4ZVpvY0ZVYXRJb3Q0?=
 =?utf-8?B?Z2FGOGtyMDZtSGxsZm9aT05ueFFlWFJyNWc0Y1g0cVNEbGNlNUR1b3JjQlRO?=
 =?utf-8?B?VURBYWRIM2ZzaFJQYlp4cG9yS1BsRERxcFhOcS8xdFl3REJCNGwwRlBnVU9x?=
 =?utf-8?B?anpwVE52bWN3VjFYeWpML0FTVGgxNllrTXNKZFMrc1R6MGdocmFJaFIyRkh1?=
 =?utf-8?B?SmpSMEk2ZUVkVTZYaDl6Vzl4TldjQ3JpSGRXbmI5T2JLays4eFl5aEJJbm4z?=
 =?utf-8?B?R2ZkUlZ4UlR1QjlZaWFQS0JVUWFEU05VTTJaVXBlN0NGUlFMbVRVN1NHclQv?=
 =?utf-8?B?ajZLRXJxcnlQZkpDYmMzYjc5aXdEanFhdXkyU3llbmJjdVd2VnZuNEJ4UEY2?=
 =?utf-8?B?VVRVUjJmYUs0TC83TnV5eUpuWndhS1VJRkhxNWd2VnAxM2VRVlh1dSt3Qysw?=
 =?utf-8?B?Y2lmZlVHSktjNVJ6RUN6YjB3eTJrTExUczkzVmZ5Um4xaGpSV1dzVE5YbGZI?=
 =?utf-8?B?bXlRZEE5Y3NRSUlLeEN4WEV4TXB3ZkdGcEdvREpycXlUNFhtV05vaE8rMkNs?=
 =?utf-8?B?YXg3aTJucDdjL1JNdXY4d2VzbERBY3Q1Y2hUV3lzT2dtNjZpWm1sWFZROEdI?=
 =?utf-8?B?UnNraXU1THV0b2tjOWx5OGpDSWhLQjZqc2lDM1QzL2EvTTRaQ3FMSWYwR1BD?=
 =?utf-8?B?dTZXOG5STlRiTFNEQjhrRWFZeXM1S2JCaGhJbURlZllEU3Z5S2dPaUx2RnJB?=
 =?utf-8?B?YWRWZUR3b0k3MXJaYW5yT0UxNjhLS3F3cGF5NVB1WmF1Y0RzV0dCVW9nYUdo?=
 =?utf-8?B?QnhDMWhzUkl2RnRkZmtZdTcrVG1UODNhR2h4QStuMXZ5b25TQjRSSkNYUHhT?=
 =?utf-8?B?ZzhFUlFLTzk3WVhLZ0JTZkFiQXhxNm8reGpQYk4vQTdLdHRXM2o4UDJYSlkv?=
 =?utf-8?B?Q2tsa2FEOEU2TGxQVlBJRzJ2T1pBYWxDVmpjN1lIZ3psWlQ4Z3JGVHRObndt?=
 =?utf-8?B?Nmk1WCthK3JWSE5TNy8vL3p1THNiWG95L1NVaUxwaDZKTEIvTjd6RmwyQk9F?=
 =?utf-8?B?N0ZiWCtzRE8zVmFFbmR6RDhzYkVHUVZSWk1ZRFNMdVNxWExlOG5nZ3Y3RnFD?=
 =?utf-8?B?NGhLMWFFS3ZIMG0yT0ZFN1N6MUErQ0N1WG82QXI4ckN5d0UyOEJid1orNVlD?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb9f579-cfce-4ba6-fe14-08dddb7ad82e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:38:01.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INzLpyOx74a53FI1l51/hurY93LuK3E6YTXzx3E3EhxFAKmPjMcLiKgzHp18P87Xwy+nf9XbjmkGMQpe+8U8/vIf2oiYEN0ngqWdKoNrOQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6552
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> Add a new PERF_PKG resource and introduce package level scope for
> monitoring telemetry events so that CPU hotplug notifiers can build domains
> at the package granularity.
> 
> Use the physical package ID available via topology_physical_package_id()
> to identify the monitoring domains with package level scope. This enables
> user space to use:
>  /sys/devices/system/cpu/cpuX/topology/physical_package_id
> to identify the monitoring domain a CPU is associated with.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
