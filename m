Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023075.outbound.protection.outlook.com [52.101.72.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68381E5B68
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761207391; cv=fail; b=L5ql2SPZ1oYVKk+LS35ScYblHHJ6o5W7OrWZhlVm2GvHBslsneqMhXeXFgNZN1C5NXNrol7oCYDx66b6XC/NZ58NL+DgylasiPzDiug7FixelyZ1Q0MhDo7yPRSpdKEq6x0ofDHYCXt5MJ7k/RM4K6NMKAXWTlbFd7UctDlZVN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761207391; c=relaxed/simple;
	bh=G15zwmsGjzzYfpFC6vs4XlsBxVN6euBG4WhPn/V32H8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m7apdzBqaB5rwMxiZOuMbhfzjMSzWWxsC430kPmBDVMCYz+LfognhusG2puKbcweL1gepchR7qFlV8g240TesuJ1u1mY6qN9GD8kRCkN7uvS745m63pYC513L3A8rq6i8mRyuue0e7NOvcNtETfIW3toKP92xG3pyfpytyEtTUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vaisala.com; spf=pass smtp.mailfrom=vaisala.com; dkim=pass (2048-bit key) header.d=vaisala.com header.i=@vaisala.com header.b=Ui7FJKRC; arc=fail smtp.client-ip=52.101.72.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vaisala.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vaisala.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vaisala.com header.i=@vaisala.com header.b="Ui7FJKRC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snMbLSwq3gJG/PsubRGT86uqOLFAinviJQ2EptWigdR2SqJfuL+5faO4AmWzbxQPPBcLwjNXtmWWeYX1kl1SJvGOTJpZaFP6MrcqQJ5LlXFMLUQGyieOb2IGTls7i1XwA0hOdbe2ds457W6VmiftapjSRgvEo8k/nMkvG6pcEAu+Klh5/+GaoZTTog6rEgivZ9cHzIYNk8XciGV/V4Sz+S4c7JDPja6ZMyj9YU/7cUfYNGJFfuR4o5VhGEHZWBcQ3LIjNh8G/GgZXSxaDtJTY3ZOy4q1KsF1e4jdA3hXGONLv7A0PB9ftpYOYzr0x9LkZn533oJrfnrrvr1o9rJw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8e72Cs9GLIsvo+X14iq+xaswSYSv2yPsDk9YHbrdcY=;
 b=eYAf5F6k4gjbjO5h9YJdGsdiZ2sWzHUdhVgXPTI4XVJDJzdyPJNt4pQVYmw1HVjp7XZyGuCpYzzsEvL5QyWZk0AWWGJUwRXlIu4aEg8d7wajOdqAUdgPRecbvIBGj6/qMgxY/ucHRV5Yi6vR15qthj1Mnn92pJbb27WHK5EgAxwjrxUssdS00Gwa6Euaz5DSkaqpRSykm5F2A3HQ1VM9JjrSf5unp7qKEyiA6V8jJkrhgKBdlJXrazjn2VyketOS0v/I15ZsSkssnqvY5kSYXtox2ZrEKdFT4IF9MPO+qJ8NbFaPh0M8ZZ7Y7BA6GGA+5n32arFCg/c17mV7mjJE4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8e72Cs9GLIsvo+X14iq+xaswSYSv2yPsDk9YHbrdcY=;
 b=Ui7FJKRCkjjhUpw+Hs4nBvLD2KRD2cIO7oqhQMKX+mJaMZJfbSg4wIADaHgnyiyY68L8jN5/tiaKzBzRatB7d8Gf7U5+cyBysMi1HByc31rtiHlK4qCKIGsZo/dm8dtCjeMF9L8XMJLQbQoTViavVz0AqbAKus1QcwHRvaKztvwDw4Fnek1SlemQRsTyEcTKX7bOceIMeUaYcGmYVm1QYxvFStfTSK0ZqXOODf3W7qTYqU4uE4LRHxVLVSCNxpNhVMZsr6Sx/RhbUFzhijGXTtxf+0jREDMenhk1jDlIPcxPLHkSwVTCNbCOITtEWtjg8zuMJ7MCtBAiWgRth1kw6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from AS4PR06MB8447.eurprd06.prod.outlook.com (2603:10a6:20b:4e2::11)
 by PR3PR06MB6923.eurprd06.prod.outlook.com (2603:10a6:102:86::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 08:16:22 +0000
Received: from AS4PR06MB8447.eurprd06.prod.outlook.com
 ([fe80::af93:b150:b886:b2bc]) by AS4PR06MB8447.eurprd06.prod.outlook.com
 ([fe80::af93:b150:b886:b2bc%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 08:16:22 +0000
Message-ID: <08d64b5d-80d6-4b82-8316-46517e210902@vaisala.com>
Date: Thu, 23 Oct 2025 11:16:20 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 136/276] perf test: Dont leak workload gopipe in
 PERF_RECORD_*
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ian Rogers <irogers@google.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Athira Rajeev <atrajeev@linux.ibm.com>, Chun-Tse Shao <ctshao@google.com>,
 Howard Chu <howardchu95@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 James Clark <james.clark@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
 Kan Liang <kan.liang@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>,
 Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Sasha Levin <sashal@kernel.org>
References: <20251017145142.382145055@linuxfoundation.org>
 <20251017145147.447011793@linuxfoundation.org>
 <8c1c66c4-62dc-416a-b52e-314ce98fe474@vaisala.com>
 <2025102206-mauve-wizard-d875@gregkh>
Content-Language: en-US
From: Niko Mauno <niko.mauno@vaisala.com>
In-Reply-To: <2025102206-mauve-wizard-d875@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVX0EPF00011B60.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:8:0:13) To AS4PR06MB8447.eurprd06.prod.outlook.com
 (2603:10a6:20b:4e2::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR06MB8447:EE_|PR3PR06MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e91a29-b667-445b-a168-08de120c7397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUhQenBuQVIvYUYvU0h3R3VFYXd2ajRkM3dzTmtveDFjdjVpRVprMExJOHd2?=
 =?utf-8?B?OG9kVDRFY1JBdXBrd0hnYXFZcEVYalJub2tIVTJYVmVVR3IrUVNGaU5RVUN1?=
 =?utf-8?B?OEgvWGJhelhKdDhUQjFURGpOOHJVdEVSZUtjU2szdXJTMnZPSmhEODVaV0VP?=
 =?utf-8?B?bnFGZktaYkl5T28yclgxSHZCWll2Q0FtdWh6L3BmczREalZtUzFVMHRHZVh4?=
 =?utf-8?B?VGhaYVdlU1U1Nm1JS3ROQ0U2R0RJOHNoTThnRmFiOHpDQ3NjczY4TXJjdU9E?=
 =?utf-8?B?WkptRFhTM0pMZUErUHByZ3Zvb2NTdVliUGhzQXZ0QUNva1kyWWxnL3d4UHVk?=
 =?utf-8?B?Z1FHS0p0ZjRaSTd4Ynh1Nm9MVERYT0FqbkxabjNjUzk2ZzNJT1hnWGhlRVZl?=
 =?utf-8?B?S1NDNnluOGZoNGh0K2kxOWRteWFlcmFTdmIyS2lOTEN5bDV3OC96d1pnZklm?=
 =?utf-8?B?ZEgxVmk5RnJwTGJFMUVsUWxZdGZCUU9oODhWYStyYlNTQlh3VWFOL2xmeDFw?=
 =?utf-8?B?STRPNHVNZWYzOUJSWWlrbUdZYUN1VHp6eXlNQktZM3NlUHdXWEsrdXhYZDN1?=
 =?utf-8?B?cDgxSGZaY09PU2dtbnpGMXdlM1FhcU8vS3VZYW5ESDBteGxSbm5aeSs4U1RQ?=
 =?utf-8?B?UHhpaFNreEIxMEp0TS81Tm43T2pUQ29IUU1aOXlkSXEzU0lzbGxVVkU5SWo2?=
 =?utf-8?B?d3dOQ0FHSGl4OG1XUXA1elYxQUxjbS9QWHdMYjZCSUJPWHg0b0lMK0VMcFUx?=
 =?utf-8?B?Y0NSVURoSmgrdENQL0dyWlVabDcyVE5jU0YvdDAxeG9JdXNoMzZoRmJ0OGFN?=
 =?utf-8?B?ZUVPMzJsanJPYmNLc1FxNFdjbWdHWExpUWpXci9HODRIKzYvOGFlWGhPZWI0?=
 =?utf-8?B?a0NwYXpoV25LeTZaWGgxWWZRQlRsc0E1TzFtY3diL3M5NUF5ZlZzdUh4MTI0?=
 =?utf-8?B?eHlRdHk5Zk5mMGhFQXFKUnRmTDFWbmp0S3ltczcwNVo0ZDJ5Q1hqbEM5MzBH?=
 =?utf-8?B?bytIelpMZzgyL0drelNmK2srZmFDckg0T1lNUFJCTWZPMC80SHFieHk4Uml1?=
 =?utf-8?B?cVlmYVNlb3VPSXdPbkFEUGlQRHJrSjhzZnp1TnRiTXFxSGh3N2NrYjZIZkdp?=
 =?utf-8?B?RVM4RlBDTDRhbnBVQWVhN0xFYzdNVXJYM29qTFpwQnZjSm9jVUQwMlhHc0t3?=
 =?utf-8?B?QWtQeEJvVlpGRnVWRWpPME1nVllaZFZjaDFjcmRWd3QzUGp2eFhqL1ZuTytm?=
 =?utf-8?B?Y3JlV3FMaXg0MWtGajRnNzZtN0k1V1JoOG1pZGJEckxvM20wcW9LL3Jtc1JP?=
 =?utf-8?B?K2t1S0RTdjI4ZG15aTZxeXBSSmMrNGxUQThQYTZyekRmOFUwSXRKVzkwdUlX?=
 =?utf-8?B?MytvNTQ4VEU5cVltamJrcjZsNGRxaFpUcHlHb2NtQ01xMTcwNHFicVZpelVo?=
 =?utf-8?B?OEw1bkJXQTNmaVZ6d2R0VCtVL0hYaFJJRVA2cjliZEk4c0IzMUZMTzVra3Zh?=
 =?utf-8?B?d0REdmExTndYcGJsWEczSzVERVRpQUhaNmFRdmhPV2tSd0dubVVJQThyNXFR?=
 =?utf-8?B?NGVOc3ZNYUFIWWdnb1NsTnJmdjZxMDBaZXdYaU81b3FyL1lTRG5yNVpEMkhm?=
 =?utf-8?B?OGtXdkplSDdENzBieEhJZE1wMk55NUkyOHorOVRDYmNUcWFVMnFvVlpQM0Vq?=
 =?utf-8?B?Zms4bE1xbGl6N1Uyd2ZrNDBlaytZbENzQkZEL2J4S1BFSllwU0FQcFVUbWgx?=
 =?utf-8?B?UXl5Y2hUVFZKeXZCRXU0ZDUzWlFkMTI1dG5OMVZaQk53aWtCVWw1aHcxU2tx?=
 =?utf-8?B?aXV3Q0QxRnJ1QzZYMjBoODRMT3A1OWVYOWY1My9KTmxqTkJ6QWpnV2I4Q3Ji?=
 =?utf-8?B?OFJuZ0VQWkNLV0VGR1RMaVdjbW81ekQyU1NsV3REMUtlNDdPR1F6cnN0UDVk?=
 =?utf-8?Q?KkYFIQQfjJUs5Wcjgk+WJOj96IykiXKR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR06MB8447.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWM2Y1FjR3JiYW1Eemg0RHZVLzlDVElYM0pqbmR1eW5zb1FFZHZ0ZVRUK3Ux?=
 =?utf-8?B?aWdCRjFab093TDA3U3Q2dEQ5NStOMW8wTW9oSkdIaktDWGZ3V0h6RVJrS1lX?=
 =?utf-8?B?WkJrSEFhbytSNHpPZk5sTWtzK0Nkb01DbjVHTlhSRnZyU0k5Wkc4ajVDelVR?=
 =?utf-8?B?TU1aK0o3V0JTWDd5Y3RlcDN6cndKL2pXNUw2UlEzRWFSbCttNmR6ZjA0NUxG?=
 =?utf-8?B?OFVIakloeGV2TUNsSWpPbEJiRkpSQjdJL09jUkhLV2k3NzI2bGFyMTlCalh3?=
 =?utf-8?B?T1pLRlltUENMNk83dGtobTVSUHc1K1dEbEtJUDA1T3lQZitnZGN2b0dzWE1P?=
 =?utf-8?B?NEE5dzFMMW1uVkx5emp6Mk5XVEgwdDd5b3cxdHhxOENRTDNEaTdsRzZOUFdn?=
 =?utf-8?B?NDNiTlVNRTk5UG12cldsKzh1U3lERHlST0FraTh4d1VBcFdzSndVV2pFRmc0?=
 =?utf-8?B?Q1VkaUxxWG5tbUwvbnJ6ZkcrZ3hqNmJKUGF5OXd4Q3lsQjlBd0N1bkpkd3gv?=
 =?utf-8?B?dXI2VzY4TXorZEpJNmRZTjYvbzErMFE3MEVUY2hoK0FRRG9GdEc4RkhyTVgy?=
 =?utf-8?B?ZncxMnFIRVJQWm80dlJvY1dsa2U5YURNM1gyUDdaNGNiQndHaVpKM3RVTUNv?=
 =?utf-8?B?QlUrNStLT3VvY1U5a2lWNDhYUTFwQ0NqYWhBSlFkWU9vUC8wS0Eyc3F0bUps?=
 =?utf-8?B?SEdpdGg5SklVQjdXTVluaUVvQWcwTWtHMjMxTXJXVFNIMFlHSkJPanU2bnhV?=
 =?utf-8?B?NDVsTGc5WURJOHZpQkpLaFR4Tjc1RFZnbGZ3Q1NMT0ljSTAxRVM0SmZjYVdV?=
 =?utf-8?B?c2F6a2I2QmhySVpBalFzQ3hvSktQcm1oSGtMRjJtZTQreXdkWkR0SUdmc0hz?=
 =?utf-8?B?MnRPVlpNd0RRcnRvejVOMnY3NzBpS1o2U1lMc3FlSVdNbmdiQ2hDVmtMNUFu?=
 =?utf-8?B?cG16bEpuZFppaEI3dWNvejdwTStCWWZBRTJFcDZFR3VzKzM3aENRZzBFQTcw?=
 =?utf-8?B?MG9WTmJydENPSU5hSmppRTdxdUd3THBwZ0ZveVNkTlR0UDBjL1c3ZFJKVSta?=
 =?utf-8?B?UkJPVnlxT3FUbTZLWDBGdkoxbUNrTjFwKzdYbVY0VlRhZEtiMDg5cFpyWDR5?=
 =?utf-8?B?UThzZld3Z1J3N2dBeDBlVWcwZTBQQ1VSZGEzdk1PdUt0S2tNcEtsMzErMy90?=
 =?utf-8?B?bVJuT1M4ajZnWmcyeVE3S0I5cVdCUldIREg2VEc0ajZCTHNSOFlINUp3L0dl?=
 =?utf-8?B?cnpVOGpKOVhWUXdkRExES1FKcVgwWEhuTVdiUXd2ajhqY1RLU3ZmQjR0WmQy?=
 =?utf-8?B?WlZ0a0tyWDdvV2lEaDRObkFiQ1pJblVNZkM1UHEycnNsWTNCRlB2RGdNRUpw?=
 =?utf-8?B?WFBIQkUxRlpzQm1UamxKOGN4WHRQNllYRjVNaWVhK0ZkNUJmbDJzUGJKdUpn?=
 =?utf-8?B?bWVSWnllTXU0QUROYmhhL0hvOTh5MVQ0WmZ5blUycEd3VFRHaXowZmhhK3RY?=
 =?utf-8?B?WmUwSXFFaVQyYTZYTGdndzNDWWhsUzdkeGJTU1dyS2g4dnFlb1QzbFU2NlhZ?=
 =?utf-8?B?dWh6Q2J0UUs5aWcwUW9JT2tUeVJnM0V4TWdaRERCdndLN3RSZ3hpUTZFQkkw?=
 =?utf-8?B?eHcrOUllbHpzQjlCaFBwWnQ1c3F2enlWd2k2Y29rdW1ibmF0VWdKYXlreEJz?=
 =?utf-8?B?UVFIZHBjbzZUaXB3U0tQYU91MXRzRXROWkljMmg1M1RBZ29KN0J0c1BuSVZj?=
 =?utf-8?B?ZkFFNmJSZ0V5RllIaDBScDFwS1Bab0lXVlZiVFpNUTArOEovenlZZFVKOEU0?=
 =?utf-8?B?M1JVSHFsaDRjNlpqcTFUazNVdXhJZWpkeWZSVW05R1lwN25rL0owUFdoQ2lX?=
 =?utf-8?B?SnM5amJMZkRIY3NGVFFyMjlkeWtUQnA0QWhGbndlUi9haDdzMUlGTlNuS3Vt?=
 =?utf-8?B?ZTlMUWhwQUFTZUpudjNXUDVGbWhDbkJ2SFlkOW1oNytEbllSNzNuSlcxd3Jz?=
 =?utf-8?B?YithQjBNNE9PaElKei9tRmF4L1pxYjd2MXl2RU04ZEkrOVErKzVwbk4vN2V2?=
 =?utf-8?B?aXJBbUxGOUs5bC95MWVyK3NuY0M3VndnUTZJWUV2QkhlTzBhaEFoLy85NWxH?=
 =?utf-8?B?VWdpSlMvUDh2TS92clpPd0lpTHNEYWtYaXBQODNpZElkMC9JK1BjaVpnK2s3?=
 =?utf-8?B?WEE9PQ==?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e91a29-b667-445b-a168-08de120c7397
X-MS-Exchange-CrossTenant-AuthSource: AS4PR06MB8447.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 08:16:22.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdPzUthx1RyWHR3twXojw05AY4oNJRVMS91izlAi1edtY3Pvi2/saCSfhiFcOjxe0gIpRd6mjcZglyChzXYW7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR06MB6923

On 10/22/25 15:29, Greg Kroah-Hartman wrote:
> On Wed, Oct 22, 2025 at 03:08:36PM +0300, Niko Mauno wrote:
>> On 10/17/25 17:53, Greg Kroah-Hartman wrote:
>>> 5.15-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Ian Rogers <irogers@google.com>
>>>
>>> [ Upstream commit 48918cacefd226af44373e914e63304927c0e7dc ]
>>>
>>> The test starts a workload and then opens events. If the events fail
>>> to open, for example because of perf_event_paranoid, the gopipe of the
>>> workload is leaked and the file descriptor leak check fails when the
>>> test exits. To avoid this cancel the workload when opening the events
>>> fails.
>>>
>>> Before:
>>> ```
>>> $ perf test -vv 7
>>>     7: PERF_RECORD_* events & perf_sample fields:
>>>    --- start ---
>>> test child forked, pid 1189568
>>> Using CPUID GenuineIntel-6-B7-1
>>>    ------------------------------------------------------------
>>> perf_event_attr:
>>>     type                    	   0 (PERF_TYPE_HARDWARE)
>>>     config                  	   0xa00000000 (cpu_atom/PERF_COUNT_HW_CPU_CYCLES/)
>>>     disabled                	   1
>>>    ------------------------------------------------------------
>>> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8
>>> sys_perf_event_open failed, error -13
>>>    ------------------------------------------------------------
>>> perf_event_attr:
>>>     type                             0 (PERF_TYPE_HARDWARE)
>>>     config                           0xa00000000 (cpu_atom/PERF_COUNT_HW_CPU_CYCLES/)
>>>     disabled                         1
>>>     exclude_kernel                   1
>>>    ------------------------------------------------------------
>>> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8 = 3
>>>    ------------------------------------------------------------
>>> perf_event_attr:
>>>     type                             0 (PERF_TYPE_HARDWARE)
>>>     config                           0x400000000 (cpu_core/PERF_COUNT_HW_CPU_CYCLES/)
>>>     disabled                         1
>>>    ------------------------------------------------------------
>>> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8
>>> sys_perf_event_open failed, error -13
>>>    ------------------------------------------------------------
>>> perf_event_attr:
>>>     type                             0 (PERF_TYPE_HARDWARE)
>>>     config                           0x400000000 (cpu_core/PERF_COUNT_HW_CPU_CYCLES/)
>>>     disabled                         1
>>>     exclude_kernel                   1
>>>    ------------------------------------------------------------
>>> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8 = 3
>>> Attempt to add: software/cpu-clock/
>>> ..after resolving event: software/config=0/
>>> cpu-clock -> software/cpu-clock/
>>>    ------------------------------------------------------------
>>> perf_event_attr:
>>>     type                             1 (PERF_TYPE_SOFTWARE)
>>>     size                             136
>>>     config                           0x9 (PERF_COUNT_SW_DUMMY)
>>>     sample_type                      IP|TID|TIME|CPU
>>>     read_format                      ID|LOST
>>>     disabled                         1
>>>     inherit                          1
>>>     mmap                             1
>>>     comm                             1
>>>     enable_on_exec                   1
>>>     task                             1
>>>     sample_id_all                    1
>>>     mmap2                            1
>>>     comm_exec                        1
>>>     ksymbol                          1
>>>     bpf_event                        1
>>>     { wakeup_events, wakeup_watermark } 1
>>>    ------------------------------------------------------------
>>> sys_perf_event_open: pid 1189569  cpu 0  group_fd -1  flags 0x8
>>> sys_perf_event_open failed, error -13
>>> perf_evlist__open: Permission denied
>>>    ---- end(-2) ----
>>> Leak of file descriptor 6 that opened: 'pipe:[14200347]'
>>>    ---- unexpected signal (6) ----
>>> iFailed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>> Failed to read build ID for //anon
>>>       #0 0x565358f6666e in child_test_sig_handler builtin-test.c:311
>>>       #1 0x7f29ce849df0 in __restore_rt libc_sigaction.c:0
>>>       #2 0x7f29ce89e95c in __pthread_kill_implementation pthread_kill.c:44
>>>       #3 0x7f29ce849cc2 in raise raise.c:27
>>>       #4 0x7f29ce8324ac in abort abort.c:81
>>>       #5 0x565358f662d4 in check_leaks builtin-test.c:226
>>>       #6 0x565358f6682e in run_test_child builtin-test.c:344
>>>       #7 0x565358ef7121 in start_command run-command.c:128
>>>       #8 0x565358f67273 in start_test builtin-test.c:545
>>>       #9 0x565358f6771d in __cmd_test builtin-test.c:647
>>>       #10 0x565358f682bd in cmd_test builtin-test.c:849
>>>       #11 0x565358ee5ded in run_builtin perf.c:349
>>>       #12 0x565358ee6085 in handle_internal_command perf.c:401
>>>       #13 0x565358ee61de in run_argv perf.c:448
>>>       #14 0x565358ee6527 in main perf.c:555
>>>       #15 0x7f29ce833ca8 in __libc_start_call_main libc_start_call_main.h:74
>>>       #16 0x7f29ce833d65 in __libc_start_main@@GLIBC_2.34 libc-start.c:128
>>>       #17 0x565358e391c1 in _start perf[851c1]
>>>     7: PERF_RECORD_* events & perf_sample fields                       : FAILED!
>>> ```
>>>
>>> After:
>>> ```
>>> $ perf test 7
>>>     7: PERF_RECORD_* events & perf_sample fields                       : Skip (permissions)
>>> ```
>>>
>>> Fixes: 16d00fee703866c6 ("perf tests: Move test__PERF_RECORD into separate object")
>>> Signed-off-by: Ian Rogers <irogers@google.com>
>>> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>>> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>>> Cc: Athira Rajeev <atrajeev@linux.ibm.com>
>>> Cc: Chun-Tse Shao <ctshao@google.com>
>>> Cc: Howard Chu <howardchu95@gmail.com>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: James Clark <james.clark@linaro.org>
>>> Cc: Jiri Olsa <jolsa@kernel.org>
>>> Cc: Kan Liang <kan.liang@linux.intel.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Namhyung Kim <namhyung@kernel.org>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>    tools/perf/tests/perf-record.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
>>> index 0df471bf1590e..b215e89b65f7d 100644
>>> --- a/tools/perf/tests/perf-record.c
>>> +++ b/tools/perf/tests/perf-record.c
>>> @@ -115,6 +115,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>>>    	if (err < 0) {
>>>    		pr_debug("sched__get_first_possible_cpu: %s\n",
>>>    			 str_error_r(errno, sbuf, sizeof(sbuf)));
>>> +		evlist__cancel_workload(evlist);
>>>    		goto out_delete_evlist;
>>>    	}
>>> @@ -126,6 +127,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>>>    	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
>>>    		pr_debug("sched_setaffinity: %s\n",
>>>    			 str_error_r(errno, sbuf, sizeof(sbuf)));
>>> +		evlist__cancel_workload(evlist);
>>>    		goto out_delete_evlist;
>>>    	}
>>> @@ -137,6 +139,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>>>    	if (err < 0) {
>>>    		pr_debug("perf_evlist__open: %s\n",
>>>    			 str_error_r(errno, sbuf, sizeof(sbuf)));
>>> +		evlist__cancel_workload(evlist);
>>>    		goto out_delete_evlist;
>>>    	}
>>> @@ -149,6 +152,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>>>    	if (err < 0) {
>>>    		pr_debug("evlist__mmap: %s\n",
>>>    			 str_error_r(errno, sbuf, sizeof(sbuf)));
>>> +		evlist__cancel_workload(evlist);
>>>    		goto out_delete_evlist;
>>>    	}
>>
>> it seems that this commit breaks building perf followingly with v5.15.195:
>>
>>    | /usr/bin/ld: perf-in.o: in function `test__PERF_RECORD':
>>    | /home/username/src/vaisala-linux-stable/tools/perf/tests/perf-record.c:142: undefined reference to `evlist__cancel_workload'
>>    | /usr/bin/ld: /home/username/src/vaisala-linux-stable/tools/perf/tests/perf-record.c:130: undefined reference to `evlist__cancel_workload'
>>
>> The 'evlist__cancel_workload' seems to be introduced in commit e880a70f8046 ("perf stat: Close cork_fd when create_perf_stat_counter() failed") which is currently not included in the 5.15.y stable series.
>>
>> BR, Niko Mauno
> 
> Can you send a revert for this?

Submitted https://lore.kernel.org/stable/20251023075101.25106-1-niko.mauno@vaisala.com/T/#u
-Niko

> 
> thanks,
> 
> greg k-h


