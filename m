Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56865318ED2
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 21:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754551; cv=fail; b=jZ75tLvNFKoCESXtGAO40/i/ped6pgXMQenc2OJtlplw5YOPZdI+GxRQygch2MXCAfkDrUWQ2MnyBUFBeVDON0lDGGF+HgzYogE+16HQfB24UWa2EMxE8WYBTNBEnmftO0M00DF2UMtx8yMJX9wqmk2I95qCDVN9XxFx3+MdAOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754551; c=relaxed/simple;
	bh=1nZA06HyFQmzGMibSjNPQOj8YccigY0P7GztGndBIrE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l6YLYX3T8NkX0FY1ehzWMbHbHZgXnxFjnQNDRQJjEvppXDgc2iaGVpaoY89URYjD3WSf6sjt8nlJVXIVLyqpUUwGpHymJF8Udc2ODW4CgI8fV29/viWaFX/sUV7h/kznhkW2A86J5kyb23OMq2q/0FbwqomGUIP98ZuLvQE8UdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L4OMFb3G; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L4OMFb3G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784754550; x=1816290550;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1nZA06HyFQmzGMibSjNPQOj8YccigY0P7GztGndBIrE=;
  b=L4OMFb3GrkNn9pWyt50hdhDv/oy8yJTqjCCD7nSlAwD27/oF+6qMMSVv
   Ten9cvEZYKmgKJPK5fcAhKrBbja4woBIy0qThlFBBHO20v2lfylLwrMuj
   lo3RKqXzeMABkG3hXrZffjOoGAipUC9tWFZCWv9XOzZZCk5EDLw1cuK9S
   25Fqp7rWRSlsCphDIEP5zdgU/YsNOptFJPt05doG/skVBy33Dgd8QPQhn
   OpF2pks5lGk1iBQVd3Dh/KT9FfftWcAA0cytgGZ0Q3EFqL5t92kpqhclM
   bUGpCpQdT8FWE+budrhbd7PuwCDYSPYGXpddZaK66wnkRcJbGjJO354dR
   g==;
X-CSE-ConnectionGUID: /D4qtJx5Ts20Uh0jhTPMGQ==
X-CSE-MsgGUID: xQufyQ/hQSq/XSA+V8R8LA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="96775668"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="96775668"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 14:09:09 -0700
X-CSE-ConnectionGUID: 7HOxBE0rRW+slQEinfcLYg==
X-CSE-MsgGUID: sH5lEVLKQSOKE4jWfjJ6EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="253840463"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 14:07:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 14:07:32 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 22 Jul 2026 14:07:32 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.17)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 14:07:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hk2mmmPMgM+OMcVUsDDR812hjPAwZudVoLJaZrWtcydhx4DycvyFk/Dym0iF878uM9j9JnTukSZ5H15P6St0OrFZ04FAIfPgTiCzHISyUlSMNzlgRTSbrV1SI0+EGPDsn8TDCFbZlLRp/GHV/oiFEjH+r/10LvIHh6c0AjFuHvC5t6kdSQG/0ovLAbluCzvyFXAzHq1V9X8vxHN+8YeAyfyjBjr0Q3LURbWDvDwnb+OUCPxRlaKr5T486OsHHtKAjedOxzXTtU5TGJWmRvn8XvdvAnzj/ORlqzZ5WLktJwAVMxE4Epu1BW5XSFo2QMt2kbrtbM6zy9oItQJQ1wlc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asiOm9ogiQIOx6YKbXZYhE7Mz+orEiVsfvqsarb+TXo=;
 b=skGt3EBesU3PmIOVUSlPLv49EhcCDZbRu6p3yd6M6+f4Ct1aAlElBVR2Xp35gpmfU9TDk+CcYkaXG369hD2TiQ9mJi6uQZdihBGjFw3lSZidZI+YDLlmCyprJFNxT587U1Tzd7z/XMXiCNrbbNVJSx+0LDx4VYjoaFVqzDVmuL44gJviel9e4RQ4jWeR5Q06DliirOEn/N1eKn9giAH7SL78gVsNzb6LhWAFGirXd6EBrjaUx7ba9YJnRZK0OEz3N+S3IljxijrIGDQlCh5PMko374c01W2//FjibVcYPg0587NhMvDK3o0w/RHZyb5hUKdXmJBTL6X7Wp0MOAX+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CY8PR11MB6867.namprd11.prod.outlook.com (2603:10b6:930:5d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 21:07:28 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 21:07:28 +0000
Message-ID: <cb189d5f-b852-4e46-851e-62b5c75224d0@intel.com>
Date: Wed, 22 Jul 2026 14:07:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
 <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
 <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
 <86f26d3c-92a7-4365-b6b9-2b31da15ce1b@intel.com>
 <20260722005015.GKamATx-zEYGcRs2X4@fat_crate.local>
 <ae04714b-566e-4b21-ba6c-2f42c6400e87@intel.com>
 <20260722200311.GFamEh_2Z6p3MrXpVr@fat_crate.local>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260722200311.GFamEh_2Z6p3MrXpVr@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:303:b8::23) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CY8PR11MB6867:EE_
X-MS-Office365-Filtering-Correlation-Id: 79efcc2e-6044-4819-9a35-08dee8353ca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|22082099003|56012099006|11063799006|4143699003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info: YZX3aWbjckYAUMWjVRSiLDoWTLsfqC8zLI/baq6coaQNSaEXLxsi/APp+dxDNLPrAgQVyBo4upAB9RuRNcCwazG0Jhkz94DHpiw/EDMwQD0dPG31eQDV96+NWRxFqLuNhPUJugMmQl+EJR9D+6wdvz2SKqX1YsG1v5Q1Yu8nnuRWxZ8Yy977/YFkC1gLqt41pLPkqPmKUndlZd9vLT/YEKnKNaxnQ9RTiJY8nr1RCY7u90JQ0xlscqSaoxZP0UqfCqncpWZ9uGpsLw0/FYT6LcAzPdUsW7HyM51APUeQMeYUPUSgvEq7hpaXlcRm30Y0Hz8hhMpxtD8476ZhOYJi666p8p0RQmjbB5zOW9UW60aRUnVRRJAiY8kjVlyx2eQphbS5WeV5xyLVljKDVxT1TpHs00f6SkNyIPUgC7QXw2PlRBYKOT5ISZ4cNcBhveosAFsteOX+HFeqvVOKDrCTmunS3sQmEbw3huIkKDhqqFqCrwR/VGdiL0qaORYiUBAmHmnJu54K3txPqvrC2UZO/8iPZUMq74HQT3z3sMfs+6bHtH4CRvB0XZu7JmCES8HM0V8yoVeVGHgNV5z7b0GwJ3LLqUAurv371YOG8B9ADd2B4morWkv9g2+JOgu8g4aDuQ4aZOAmfypZ90MR4xWELNutuiTuN7Odsj7UchGmpWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjdWWlNXV0kxMEl3WjFKN2puUWpVOWtRVlFQNzNuOTFESWhLT0RPUDk4aTJl?=
 =?utf-8?B?b3gyR1ZpNkM4RG5nZFNDU1NnbFFkSEkyc096bjM4dXg4TzRxZWF2blpJWHVj?=
 =?utf-8?B?K0hZb3VRbVB1RU5EWEJnY0dMaFBCV2s0RDlqTUVJTGVDVkZGV09SclZkQlpK?=
 =?utf-8?B?Q00wbVlDNzlFMTUvd0NhcjRaTGtRdUd1V1ZXQXg5eDJsMStTU3hrQVI2VlF2?=
 =?utf-8?B?R0VGajFsTWorZS9HaWlRdEp4UFM4MzZ2NXVISVFzU1l0VDdULzJEdGVEUW9P?=
 =?utf-8?B?aU1ueis1UURWSEtOR3FvSGlFbURyZmlsMUJXci9QVG5mQVZYZmRMNUl2Q1dJ?=
 =?utf-8?B?cCt5ZERZUXhGUGFxMlRTa2hXWFFVMFJRZ2FFOVpycjducWNrdGtaMURod1dK?=
 =?utf-8?B?K0I4Q0VWazRqSllNK0ZmYkJKcmk4bVptUkxFY1MzdUdXeW4rbElPQXlDN3Fu?=
 =?utf-8?B?M2RsSmlyY1lhTjN0R0xaOGV3VGZCT0NabGhmMEVNZmpaZDlKbkpNN3lNdVRC?=
 =?utf-8?B?YXJleTJVZnNWTG9rdjZQeTFsWDVqallKQ0ZGL2FhZEY2ZSs5azEvS0dkSFVu?=
 =?utf-8?B?YVFQc0h4TitVRXN2bDhhUDdvUFVCUHZMbFpuemQrRGxyYXNFSENpS3UyeC95?=
 =?utf-8?B?Q2lSZ3ZDalo1S25jRitkVjZkd0FsZDZQbjZZaTVPV3laODFQSWM1S25KQVJK?=
 =?utf-8?B?ZEE3R3BqQjRmQURPYTFTR1d4Z0ozdnJ0a3BJaDhMTjE3eWxxdmxrd3JWSEUx?=
 =?utf-8?B?U0lLN2FSTjVwMzBadGxFR0hSaDcwajdxbkJSSVNuVHNET2NnZlNFcGF3SURN?=
 =?utf-8?B?OFh4c2pGRDVWUkJpd2k0czJHeGFZck9LVDh2Vld2YUtnL3hzVkhTV2wwRUpG?=
 =?utf-8?B?STNTSGp2WWhSSkRDVGR3NnNPNDNWNFFWdXFFUDMzeGdZOVFKS2FjYTg2T3ZF?=
 =?utf-8?B?TzFlOGZzZ25hMEI0UzdLTXB4R1R4ZmZuMTBsQ3VHbDduSlFOV3NlZkM5NzQ4?=
 =?utf-8?B?UXJrQXo5UGlNbm5qUEo0eTFRNlFIM0VCS2d3Q21DL0lJbVlIWGViUXpFUkhQ?=
 =?utf-8?B?TC9pNVFneFNDL1hYVzVsTHlPamFoUk1kNnlBZzZrbDVwMzJERkJKSm9aMGVW?=
 =?utf-8?B?S0RMMEliZ0xsTGorLzdwY2RMRDNrbWN2N0VXSVQrdnpIcGhjL2xraldidk5S?=
 =?utf-8?B?RnhuSTVENUIwVU1yOHY1ejdEMndLMHJLWXpsZUZHdThaSHUxY1V4OXlkUkFw?=
 =?utf-8?B?Q1FRREZHY1J2WlRrT2JZOWpybWhndGdkaUQ3eWplZFFoSit0TXlRWWZ1NUNa?=
 =?utf-8?B?Unh6MGZnZ2dzNzUwem1USU1mdmNKQ3JtLzNUWjZKTHAvYmxRbHFobU11clJn?=
 =?utf-8?B?WkhMSWdmL0duRnlxS3NuYjY3aE0xajhYc09FU1VNak9vTENkWmJGUndMTlhT?=
 =?utf-8?B?RXRvUmYxREN4S3M0bkZTNkhLU21pSE54bSt3cG05RzVKZlJkMExlbGRFTVpH?=
 =?utf-8?B?a3hWSzNwRDlKMjduanVJYVNUZjBrVVJzOGE1QktraVRjcUhxZmRKaFZaZFN2?=
 =?utf-8?B?VVpvRHNoMHFRQ3d2VFZkcWN0UU42bjlOUDVxMy8zVWY2dnVhZEt6SHhkaDJx?=
 =?utf-8?B?WjNZTzVzbTBaUC9tbVFpWUJacEtHQmpxbDV5cmtJT0NmWU9mSkZabVVHczhr?=
 =?utf-8?B?YWpDUXVFVjdBdU1oR2dYcnJaemhTdCtEZkJjeXZmUEEwYUZuNlk2bXlFSzht?=
 =?utf-8?B?bXVaa08rR2dycnRrM2NVRi9NKzRLNk0yOE9PZVRRK0NHb3hJcEJDODM1UlZq?=
 =?utf-8?B?R0FoSEVEeXNSZm5SNXdxYit1MVgyOThjQ2t3MDVwTEovZFV5NXZGQkpzcm5I?=
 =?utf-8?B?dzN3K0h3VFo2V3lDQjFCWGM1RE5CMWtnQzRVVmR3c3A0YzNlVUIvQ2tPR1VT?=
 =?utf-8?B?NlA3VU84NEVxOTZ4Qy9LcEFmYkx0MmJ6QnBvMWtpMXNiUnBlMFkxNFZDZmhZ?=
 =?utf-8?B?R3R2WS9zdUNiUHpsOFlaakk4VVhSTWFWVEV4bUJVQTQveVNDQWtpWVV6ZW5o?=
 =?utf-8?B?eERkdGxFdGRHSWo1SUs0S053ajE5NjJBbGRzWS9CRGhSa2l4OUZKY25BQWY4?=
 =?utf-8?B?clkvalROeWxmTVhQZXlLQXpnRUY5QmFPc29Tei9DNjFvYTR2Y0tIWThQc2ZG?=
 =?utf-8?B?UjdaMnVtUEZiVkc4Ri95dzZWWWh4ZDdKSkJBYWEwbC93eFdSait6OWYwVlho?=
 =?utf-8?B?ckhVZmliZ29vL2dURTRlMERnbExicW5BWkE3UktmMmlKUWJSVzVVWmJpMEln?=
 =?utf-8?B?OVNINXFUUGVjT3ZxSURyK0VuN0xWamJhYzBiRHRzd1p1OVJxbVlDc0dOTzk3?=
 =?utf-8?Q?yGcW56TPw1L2o5AY=3D?=
X-Exchange-RoutingPolicyChecked: rxgbA/ykAzTTFtJ44cefPWHv+99y2IGo71SQZ0PdhJQTE8sAZ89ZJ/pev9AaLN73AEulhv/yY+Rgf1wKVCgz5HO0UYv6wdYm5KPiiAc5d87UGgHsirrRkSty+DncRsYqUWUuPVcKwM1uw5vEsxUFp1BpEdbQO0r+zuOEmVv7CCaEZeQYV9u/ZJEJyGI1Jm5XPk/DfwcA7SpfT5E47vRMyT5ggsAo6yQwYwCnBqDTSJ9Sh6nSuZKgCXKXz7BxbW8Q3obvERmkT8kzh45lA8mGW7/0KXtVG5NUMqXPb+cVlEHIfHDn/Ixy6xuFPj4Rkufs1ccIH+MRlE26JcNXEKIfqg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 79efcc2e-6044-4819-9a35-08dee8353ca7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 21:07:28.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hBXL1IVGmQ9liB/Blx4oXbeev9lmkkEAuPRg7eFRaYMTm1/tRr0gfx5db/bElrZ1lhh7Geqq/uohpMOM3ApVpuhaagwuLoU2uQH2xbnYeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6867
X-OriginatorOrg: intel.com



On 7/22/26 1:03 PM, Borislav Petkov wrote:
 
> You can send me an updated patch now and I can integrate it into the pile.
Thank you very much Boris. I'll do so shortly.

Reinette
