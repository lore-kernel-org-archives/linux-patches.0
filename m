Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ABB38885C
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740811; cv=fail; b=g7hrNetRu2JF6KDU6TIlRY6A+Pns6ZVbVI3dUONXfMTJybCbzx3AcLUkv0Zit9d4LLw7tBjKJ1mN4mwbJ2OTxzyTlAEVcGLMXw+XJ4fmridXFmBs3w82KmpWz74xZaIpUC3ao1W+4xuehIQ8etLh8CnvRXLq7KdiqOMcYtUDP1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740811; c=relaxed/simple;
	bh=dJV8+UWUKcDr0WNa2vz5Lj8QIJbGhGrxLE278s/W7TU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KoA6yWF+4C1G6d+XbH8VQqqibc7HXxZ8c8TnTsEYOGjgfCIyP6nest9GOQyxdCZM36pJVXvFd8PEvDUY9Z1jP7hwekEuSPhHZholgQOWS3xSfuC5YIEf/R/X2Wg48u0dKEwIZ1+IA1xU+pcCz1wHWHNVzyqnydKMTurRSCIIPa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TD48Ds0m; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TD48Ds0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770740809; x=1802276809;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dJV8+UWUKcDr0WNa2vz5Lj8QIJbGhGrxLE278s/W7TU=;
  b=TD48Ds0mwjZebBhR4xAl2e39zSb/IKc9RkC3uWhMRtjjJqlYj+YWq4bF
   6v+Q6+JNHpvJ7pW0cgqvwc2/SfOT+H2jkr62oLLTRizb2IdCM5iIRU4LQ
   4f/TBvDSErcofqdzRy47mfBD/pKms0gquLgjSr3evMlTLT04U88Dcu67W
   uoIB+RULk9N7KncCWuZTySO7vfSzxlHMem95BwYzycu1MwhWqae8TgEOR
   MPvtD6FenAf+Cc6Jz9fsVEWyxGzrRYhYDa+HHDb5NkSDHk7etDcftXEDE
   yetHRfOOhJCTvcZqK6Nsg1fckR2HhiI4cfzTQTnxrRoKuyIlzineF+WHL
   g==;
X-CSE-ConnectionGUID: 05FkrwTkQiG+Rm4ymd6kIg==
X-CSE-MsgGUID: FmuGirNnRC6sF4P1TP8znw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="82603994"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82603994"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:26:49 -0800
X-CSE-ConnectionGUID: AzPAGmvIRRWN+4s3F/wqBg==
X-CSE-MsgGUID: TZ6NsF67T66p2jIC5pGm4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212047654"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:26:49 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 08:26:48 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 08:26:48 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 08:26:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcJMDpvCXHvh2fE2/hLkADYym/l2iPqyLjCaUykZWB1rtKzfd+21VBUsUPbr+acapA0ckIuKESNLHXsBK/iAmH/C2+BZxdJ5MfmuYlYEBAvALaWxD7fIsbTDRuMFHH31/whe7oWtuwSz1k36PUn/tybuqH9WD+HORGcwOMQfK51tdYiNgf4ua6zdlvy3+yCsiq8MBap3MOqkfJ+TgKWuzfR+md4FJFTj0obpEf9xLhQvhmTMBuww7mgzkDA3g76JO+XDtDbLkU4vHKOioDjuo4XPJWpsDGeMyOnQrYVVPXDL/NSLSKA596W5pwLe5xWp9Qz/n7/vra2anoEWonsjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/LENalR2gTlcbNygGtYKatmnWwadqHvhin2n56Jv9A=;
 b=EqypgCM2+haFBH76DU+Z8+UiygmEsA7IIesQqqtGZNF9fG06gzj8qK6T+pnebJjPDV5GZJfGR4pM7R6dwVL/7VeI10y3lLAkKA7ycg9u3IGmxKatppMgBUGy6Jv4u7CkYaSY0mand3fgIciqmTq+Dqse18VAhTso5JHUPbNNn+NLaURy02JglSBIUWiN3gFUnKWFUpgtl6UoxkUle0a5II3bkH0gsI9ht0zZ11oB4iHskBesUGyvtQRumvQheLbBniA0GAfny5v3XKlt2uPUHTgOyQCaSHTcsCXDKPkHRZNfaO31r5l4HuDgFyZgE74xk/7XwnDIZwYGVWBuPOHYQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PPF63A6024A9.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f27) by MN2PR11MB4631.namprd11.prod.outlook.com
 (2603:10b6:208:262::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Tue, 10 Feb
 2026 16:26:46 +0000
Received: from DM3PPF63A6024A9.namprd11.prod.outlook.com
 ([fe80::14c9:399c:8e7c:d8e5]) by DM3PPF63A6024A9.namprd11.prod.outlook.com
 ([fe80::14c9:399c:8e7c:d8e5%3]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 16:26:46 +0000
Message-ID: <7b1eb42d-65d2-4e60-961b-c6b474aa8205@intel.com>
Date: Tue, 10 Feb 2026 17:26:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 134/175] hwmon: (acpi_power_meter) Fix deadlocks
 related to acpi_power_meter_notify()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jaroslav Pulchart
	<jaroslav.pulchart@gooddata.com>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Guenter Roeck
	<linux@roeck-us.net>, Sasha Levin <sashal@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>
References: <20260209142320.474120190@linuxfoundation.org>
 <20260209142325.330634333@linuxfoundation.org>
 <CAK8fFZ5n-og8dxFrh4J7pWW9h+iTp+AbdGUF1cd_7jDZpKEj8w@mail.gmail.com>
 <2026021009-cavalry-spearman-1950@gregkh>
Content-Language: en-US
From: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
In-Reply-To: <2026021009-cavalry-spearman-1950@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:802:2::15) To DM3PPF63A6024A9.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f27)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF63A6024A9:EE_|MN2PR11MB4631:EE_
X-MS-Office365-Filtering-Correlation-Id: 049309b3-4091-434b-1da6-08de68c12f00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OTFaVmtPdnNEWGNYNVUvd1cvY2cxMWpPK0l1N3NnUm5CNlcwTTMza3hncm0r?=
 =?utf-8?B?VE9uQjN4N1JBMEpOUnRZSU03RVZtLzhaSkRHRVRNWjBMTXRac0ZoWGRHSjNm?=
 =?utf-8?B?SStTZkVMVFRRM0ZQWWpCYmJCaE93VFlDNkp1dEIyOTlXSk8vNi9nU1ZzODQ3?=
 =?utf-8?B?cEtyZ3A5TGRPeTYxT2t5NFpuaUVqeFFNUERvUmZtS2NrNGkzait2T2dXU0Nq?=
 =?utf-8?B?Vk40bklEcXVDTlZmQmlqTVN4K0ErUVpYZTNoc3JhbSt0MENUYXJzOUcrVysv?=
 =?utf-8?B?UkY1WGwxQUJpYURza2JhRTQ3M0l0VkU4QTNleDllK2VXQ3haVTdJL2J6bUtH?=
 =?utf-8?B?eVV0V0xOVXU5VUtIcEdUWDdxODAxT29VemtVWlhHSGhIeXdRREpFR2thTS9S?=
 =?utf-8?B?T212ZVM2a3JxTGoyOWtGb3JaeklwNGRVcjVHcEtHQXpkVWJYYkFROXNDVEJ0?=
 =?utf-8?B?RXI0VjBydVBPdHc0NEpuTi9BM3JJTjc2UG5BOXRoYktCbWcrWStuMEluSG1v?=
 =?utf-8?B?L2xzM0NobW1pMlVxcVRhOVhRVm9hMjVWTFRtWllyQWM4RVNKMG9BMW1ETERv?=
 =?utf-8?B?RHovWmJNTnBpS0pNR3d5OS8zWUhyTmdqbXBaWldIK21TQ3FhamZZVDAvNDRo?=
 =?utf-8?B?SklSSTYwbnE3RWRMTmFvR3hybEthZmZNVXhnelpIWmp6SXYxK09FSkNkbnNG?=
 =?utf-8?B?MGJGY0U1SVE0QTVBdFNXMEwrVGswWXlXNFNycWZGbVBnaC9rekRncEVkeG5N?=
 =?utf-8?B?bmdpa01VSjhUTjcxdCtNQ25nS2RVQTZDM0R0YzJjZElxblhGbmtZcHgxNTND?=
 =?utf-8?B?cEl4QjlVMm12N05qYkVLU1NtVjAwTVRaWlh6TmpIcWp3a0RhWTZvUE52N3Fr?=
 =?utf-8?B?NzVGczdFakZEakUyeDRrcjNEbzhYM3R2eFF4Um9Senl5VE1vMkl3VTdPYVI0?=
 =?utf-8?B?ZVJ1SmdYQ25VTytDejdrZlVJeERBVHIrOE1NUkY1eTRmRzcyVlVha0k5cmFC?=
 =?utf-8?B?Y20rcTQydVNMTGpXVUlSV0JKaHdnQVMxSE1pcmFQbHNFVkVDcDAwWUpid01s?=
 =?utf-8?B?VDJHVG1rTDZrNEZZalBndDcxd3JkbllvTVpPTFBLblAvZVIyUFhRZ2NqYjRo?=
 =?utf-8?B?c2k5dlpnc1VNeWRtRldJQzJEZW5IWUhGRWtpck5uQjlZTldSUXpiR1JSSXJZ?=
 =?utf-8?B?NjFqMHcyWGRqUUlNdDNMQTBvSFV6T0Y2UHB2bEZvY2J4a2dKVEFEdEd3ajZ4?=
 =?utf-8?B?c25mOTU4Y1lWeE95WXZoaHpPS0RmcU5OYkYzc3lpTGRPRnVlZVk3b3BlMVN3?=
 =?utf-8?B?UEVXL3d5eUFXamdMZDFxRm14azZwdzRyTmJZc3VMMStUQmdWK3BYUjB0d0Mv?=
 =?utf-8?B?TTZ5YjR6NndWK3YvenF5c3pweWdqblZ0OFBKc0VHOTFkUUdzbllNYjhJK3dW?=
 =?utf-8?B?SFV3ZW1nb1ZjdHBVZ09lQzliSVJjV1R1L2lpSmtUaTU2MHV0UHpSSGpGSStO?=
 =?utf-8?B?QmJLSENiSkl6MjVBTDZmYTVLcnM2RzFEaUZLK1VCV2NZblRsK01LNWJ4V055?=
 =?utf-8?B?VFJWMjBWQ3J1ZkhPRjVuTWJ6Qmt0cXZINFZEWUM2SkNyUnB2YTVZUG5nZENH?=
 =?utf-8?B?Zml4eXlXZk9qQjNmbmJRKzMweFlzamlld2dYb2V2ay96ODN6QU1TRVpLazBK?=
 =?utf-8?B?Y1lvVGwyZXFuUUFMOENXNU1ra2RJZStabTNMS2ZDSi9oZk11WTI3c0NwNm9R?=
 =?utf-8?B?WG1sSmpxRERmM2FaODkxSjdWRWlyMkRnOWQ5NzJBc3R5RDJrRXJoQ3lyYWRx?=
 =?utf-8?B?UE9ac1hRTURodGVIRWhRbm1xVGhTUE5xeW96QnlhcjNUUnluVk12QUkyb0ta?=
 =?utf-8?B?ZWxHYUZNQ1hGWW1pOVZkRHVYdXZ5UFpPdTNyWlRaaU5DbjNINlJ5cVRxaU1C?=
 =?utf-8?B?enprOUVsUGlySEVaamdsckhFcU1uT0RwRkRaeFdaMkk1eEp6NEtsOHpsNnFw?=
 =?utf-8?B?ZUx6N3Z2Nmh2MkpzOXFhYjFmZk9PWDdYdlF3U3I3dWNkVEU5cVB5L015NE9J?=
 =?utf-8?B?djlBd3Ztd0dZelU3a3doTTY0MkxIN21sVGpjalNlQ1Q3UTJwYmZkTjlKWG5t?=
 =?utf-8?Q?THUGq6sOAO7ZWLKpCbkCYyIed?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF63A6024A9.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlFIT0NQaFJ6TkdaamNQdmRydEI1WXdRbVEydXIrZjJzZGN5cno1MWVjRDNV?=
 =?utf-8?B?N3pyV2YxSkpqeXl0WWgxbVVsQm5uZE5xQXo3OWZVbTdib2lkWVlpZ0dTZ0wz?=
 =?utf-8?B?SzBOMEUxQ25jSjJtVEF2Y3FKWElVa2JYSVpuaGZXKzhKTHB4a3pCM2ExWTRz?=
 =?utf-8?B?cCs5Rk82bjVQQ3puRDk1TmpjQ2l1MjV1R2NqVWlLR1g4UEJNa2IrdGtLR003?=
 =?utf-8?B?K3FTWkRUUC8vbWJKKzJCZnlFbzlOaFp2OEJRaXBIdnV6R2ZuSFpIcEhHODVx?=
 =?utf-8?B?SFVOY3prei8rTlowUjlHK0tWbnFZRmhmVXdYaS8renBBL1g1eHNRL0pHVWJC?=
 =?utf-8?B?d21BQWFzVzY4ZUpCMnlZN2Y5cGVvS3ZBNkRyUUN4RDV5cnNTN01yeGRwanNs?=
 =?utf-8?B?cEpOOGR6VDh5NHFVZExzNThTVHhZSm9rTVRkeWc3ZUZvaFVjYkV5SHJFR29O?=
 =?utf-8?B?TWxSaHhKRzBNWGdjSzBtalBTWXFtTXkrQ2FzUHhlOFNldGNvOUlJblF0allM?=
 =?utf-8?B?SEFqdVBrM24rSWtudUw5SHlaZFVyZzlzdmh2LzNJbVorZUgrZXI5QUgzVlJI?=
 =?utf-8?B?VkhZOU1mTmVpN2Rnb0VCdHBNTWtReVROUFc5VHJFeFhGajcvZmovcUoySHNC?=
 =?utf-8?B?QUorY3VCSWtWL0hYZEhxYy9oL2QrbzZ6QTJ2ajREQ1JPbUZoc3NmWG50Rklk?=
 =?utf-8?B?YmkvbkZ0UGx0ZldvaWUyZmRlRFNSaFdhZE5PbmlUTU9Ock1xUDVXZFl5cDVm?=
 =?utf-8?B?ZXhpaWhUelBEcEtPcjMzUlYxR0dETlhIOGN1L283d1V3OS9xZHJUU2VlbGd0?=
 =?utf-8?B?U2FqV3d4UlZCNSt1R3hpczhVUERra3lUU0VFTmJpaU9HOHNESldObFhiMGRl?=
 =?utf-8?B?VDB6d2J3elgvaFJhbXZGMlNacVFXRjhXYXFmcmF3RFVnWk04eStLYi9rNVQ0?=
 =?utf-8?B?dDE4bjFoWEVHTVFMdEsxNFpTc2dIbUtsWGxaaUxPOGkvU0lYb1lhZFdXdDhq?=
 =?utf-8?B?S0VKZVRtZTVtWWlnZEpBV3lZT3Zsb0hKcDNGUG4xUDlTbFdweGw0bmZHVHRr?=
 =?utf-8?B?TEdMT0s2eUpJQjg5YjZJZ0lEbmxuZktVM01jQTk2bi9uREczWFhYczBCL3Va?=
 =?utf-8?B?QXY0dHYwZVpqUEpGSzV2ZHdOeDk3VTlLWWRqQ1M1QXRyd2FGM2lSK3FGeVdN?=
 =?utf-8?B?cWppT3VBcnVySVVZSmxkRzBreDBReXR5S2FvOU9hc2RLK09IZDBtVkVuZGow?=
 =?utf-8?B?RmtienkxNnVNa0ZpbjhqTzdtY3ZxSGo5RGRxZEREUkdTb0NGbFhwUGp6YUIv?=
 =?utf-8?B?ejVWeEJDSlVPZk1WRC9JeEtmUHJhaE02VVZVLzBzVjZJalFzZzFyTjVnZE8v?=
 =?utf-8?B?N2pWbERPeGovbXNhZjZFaklETDFUbHN2ZVVpb1J1NzRGRU54aHArTVlpbi9K?=
 =?utf-8?B?QUJLS25kcGlwRVNFOExIK3BGNStUemx6WVZGdVVyNWNLa0lQYThCU1hLVVo1?=
 =?utf-8?B?UTBXYytPM0wycjNDYTdGaHF3UGh6bVdSSVhRSGNROEtvTmJJQlQ1dCtqRDlo?=
 =?utf-8?B?aDBsNGlBVUlYSTR4bHQ5YUM3NHVmcmxaSUc4Z3VDOS80aVNxaHIrYnFvdEs1?=
 =?utf-8?B?YTdlRGlBclVzcHlzUEZJek9nWDQ2Yy9DYXpPMzZYTWtBYnhTbHR1amJjQU1y?=
 =?utf-8?B?Wlg4UkQrNkFmUDhaa21zSnJlNW9vbzFja0FteDFNbXFxaEN6YUg4eWhSdzlq?=
 =?utf-8?B?dTFTM0RIb0Z4OXJkV2dWMjZRajRTeGpGNkR0emZobTMvdTBHK3FuRkQrOUlp?=
 =?utf-8?B?UHBTYnF1SGtKR3FqUXNRMnErYkFlUE5uRGFqYUhrd3h0cnRCMGo4UkpTaHdH?=
 =?utf-8?B?UDZnS1NTSCtXVXF6TkhlT0tEMHdzMFZZdDExVjZnVjJ0TjlsMTdWMkNlM0Fm?=
 =?utf-8?B?cmlySCs4Q2lENzRJNkdSZS9YaURjVFFQYkJWWTljREhpM2RucmVMUERHMXVH?=
 =?utf-8?B?VU1kRFM2Rlc2T3VuaHVFYjhPSEFHdzllTjZ4T1VJbW8rQjBIT3ZVUFg2UDMv?=
 =?utf-8?B?alRWa3JBVnV1NGZXVlNnTzJ3VjVTMVoycWU4dXR1cE1ubzZNcC9nVDQ5OTBj?=
 =?utf-8?B?alVZWVBBQUhXd0ZuL2xlK1VCelN3cDVjK05CQ3NTN2N2ZEQxNlg5em5VZEY4?=
 =?utf-8?B?ZG5kdFFzRWdBRVg5WWNyRUkwbFRFc3Q0bVRsM0J4UmxZOTkzOWoxYzgzT080?=
 =?utf-8?B?R0hSR1BJbWF3Rm9hVktZN08xNFJlVzRMdnZ1Uy85SlVyVjJkbG1PUEJIbUdH?=
 =?utf-8?B?OEd0SkxFU3lyQ05HVmZvRXF4eW95QUZUY3V4ajl4TEdOa0JkeEEwZWx2czBt?=
 =?utf-8?Q?q9SdVL6n2yyc9ZOQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 049309b3-4091-434b-1da6-08de68c12f00
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF63A6024A9.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 16:26:46.1910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LPlx4auOGczxML9qtGDcBVq2j7FMlud02ypgL2n+Qp//9B9uM5R5ty07XAKtVAJPkhXPOqMuOh6aA7l+deEjTLXs9bW+gnt6HoRfhW4P5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4631
X-OriginatorOrg: intel.com

On 2/10/2026 12:19 PM, Greg Kroah-Hartman wrote:
> On Tue, Feb 10, 2026 at 11:19:12AM +0100, Jaroslav Pulchart wrote:
>>> 6.18-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> [ Upstream commit 615901b57b7ef8eb655f71358f7e956e42bcd16b ]
>>>
>>> The acpi_power_meter driver's .notify() callback function,
>>> acpi_power_meter_notify(), calls hwmon_device_unregister() under a lock
>>> that is also acquired by callbacks in sysfs attributes of the device
>>> being unregistered which is prone to deadlocks between sysfs access and
>>> device removal.
>>>
>>> Address this by moving the hwmon device removal in
>>> acpi_power_meter_notify() outside the lock in question, but notice
>>> that doing it alone is not sufficient because two concurrent
>>> METER_NOTIFY_CONFIG notifications may be attempting to remove the
>>> same device at the same time.  To prevent that from happening, add a
>>> new lock serializing the execution of the switch () statement in
>>> acpi_power_meter_notify().  For simplicity, it is a static mutex
>>> which should not be a problem from the performance perspective.
>>>
>>> The new lock also allows the hwmon_device_register_with_info()
>>> in acpi_power_meter_notify() to be called outside the inner lock
>>> because it prevents the other notifications handled by that function
>>> from manipulating the "resource" object while the hwmon device based
>>> on it is being registered.  The sending of ACPI netlink messages from
>>> acpi_power_meter_notify() is serialized by the new lock too which
>>> generally helps to ensure that the order of handling firmware
>>> notifications is the same as the order of sending netlink messages
>>> related to them.
>>>
>>> In addition, notice that hwmon_device_register_with_info() may fail
>>> in which case resource->hwmon_dev will become an error pointer,
>>> so add checks to avoid attempting to unregister the hwmon device
>>> pointer to by it in that case to acpi_power_meter_notify() and
>>> acpi_power_meter_remove().
>>>
>>> Fixes: 16746ce8adfe ("hwmon: (acpi_power_meter) Replace the deprecated hwmon_device_register")
>>> Closes: https://lore.kernel.org/linux-hwmon/CAK8fFZ58fidGUCHi5WFX0uoTPzveUUDzT=k=AAm4yWo3bAuCFg@mail.gmail.com/
>>> Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>   drivers/hwmon/acpi_power_meter.c | 17 ++++++++++++++---
>>>   1 file changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
>>> index 29ccdc2fb7ff8..de408df0c4d78 100644
>>> --- a/drivers/hwmon/acpi_power_meter.c
>>> +++ b/drivers/hwmon/acpi_power_meter.c
>>> @@ -47,6 +47,8 @@
>>>   static int cap_in_hardware;
>>>   static bool force_cap_on;
>>>
>>> +static DEFINE_MUTEX(acpi_notify_lock);
>>> +
>>>   static int can_cap_in_hardware(void)
>>>   {
>>>          return force_cap_on || cap_in_hardware;
>>> @@ -823,18 +825,26 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
>>>
>>>          resource = acpi_driver_data(device);
>>>
>>> +       guard(mutex)(&acpi_notify_lock);
>>> +
>>>          switch (event) {
>>>          case METER_NOTIFY_CONFIG:
>>> +               if (!IS_ERR(resource->hwmon_dev))
>>> +                       hwmon_device_unregister(resource->hwmon_dev);
>>> +
>>>                  mutex_lock(&resource->lock);
>>> +
>>>                  free_capabilities(resource);
>>>                  remove_domain_devices(resource);
>>> -               hwmon_device_unregister(resource->hwmon_dev);
>>>                  res = read_capabilities(resource);
>>>                  if (res)
>>>                          dev_err_once(&device->dev, "read capabilities failed.\n");
>>>                  res = read_domain_devices(resource);
>>>                  if (res && res != -ENODEV)
>>>                          dev_err_once(&device->dev, "read domain devices failed.\n");
>>> +
>>> +               mutex_unlock(&resource->lock);
>>> +
>>>                  resource->hwmon_dev =
>>>                          hwmon_device_register_with_info(&device->dev,
>>>                                                          ACPI_POWER_METER_NAME,
>>> @@ -843,7 +853,7 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
>>>                                                          power_extra_groups);
>>>                  if (IS_ERR(resource->hwmon_dev))
>>>                          dev_err_once(&device->dev, "register hwmon device failed.\n");
>>> -               mutex_unlock(&resource->lock);
>>> +
>>>                  break;
>>>          case METER_NOTIFY_TRIP:
>>>                  sysfs_notify(&device->dev.kobj, NULL, POWER_AVERAGE_NAME);
>>> @@ -953,7 +963,8 @@ static void acpi_power_meter_remove(struct acpi_device *device)
>>>                  return;
>>>
>>>          resource = acpi_driver_data(device);
>>> -       hwmon_device_unregister(resource->hwmon_dev);
>>> +       if (!IS_ERR(resource->hwmon_dev))
>>> +               hwmon_device_unregister(resource->hwmon_dev);
>>>
>>>          remove_domain_devices(resource);
>>>          free_capabilities(resource);
>>> --
>>> 2.51.0
>>>
>>>
>>>
>> Hello, I tested this patch, but unfortunately it does not resolve the
>> reported issue on our systems the deadlock is still reproducible with
>> the same iDRAC reset reproducer.
> Is 6.19 also a problem here, or does it work properly on that release?

To be precise, the patch does fix a problem, but it is not sufficient to 
make the reported observed symptoms go away, so the Closes: tag of it is 
inaccurate.

An IPMI fix is needed in addition to it to really close the bug report, 
please see:

https://lore.kernel.org/linux-acpi/aYYPnATz1JakV3m7@mail.minyard.net/

