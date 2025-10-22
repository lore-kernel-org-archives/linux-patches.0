Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022092.outbound.protection.outlook.com [52.101.66.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9406D33FE1F
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761134930; cv=fail; b=EL31v4gr8dd1etPfnw3Vw5amFe9neXPp/ucIz6RZJo3CZ+Zkv2rhvL8qIhgGPCBN5dPomKdiC4Z9jL7VCxqmdrdtsLR80dAK6XBWXslJikal6WJmvJVAYh1dF8P2+cwVBWGRMhl2vInrRyiMo4b+2orzSr4xFsvAQZLZ+r7zNy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761134930; c=relaxed/simple;
	bh=lVGi5VEbQO7D+F5ibatFCibTKAExT3QsFefERHRepbE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R81tKzGJgAr8/p+ASKprVkCi/99MFVbBzyAP/rylhW6uQug60ss+0noZzmpyo39+sg7PfCnvxCIPqWTiWevS5wuv5GvfPrf1eiJ4zaY4wcd8r31jrmuHJysHLCACzhxAFfANeXlL9rXZuYroxSX5I+PD75qYeDcRX/oxOwJ4zQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vaisala.com; spf=pass smtp.mailfrom=vaisala.com; dkim=pass (2048-bit key) header.d=vaisala.com header.i=@vaisala.com header.b=rc9ayEGD; arc=fail smtp.client-ip=52.101.66.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vaisala.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vaisala.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vaisala.com header.i=@vaisala.com header.b="rc9ayEGD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGfO1irBeBRUfoUn4F6noTvwunxVvTsWLSRa6n/4qqloQhi2Bcsy2UIyfQw2kRkJvabXcy6gVX94Jge2QE5GnE8HrhvweDw6xSAnTooKRYeSPkxOTj48Vu1E0tibE1EsJXoZRV5zYH1MBuRrk2QbuTHpM0AePSOj1nwPnYMkc+/6ylC0j/ynvBeWK/f8xBZukkwS8I5qDHYsmhTvop5DQm0/Q6XyfMNn2C0zsl1ZC4gZStb89hoOthMpnfH4JLvYizn6Y92AKlWsz1xT92hFzMWQVi2fpBgbb7qAQo5WV2cUsmdccNCefjFF0AvoubnhWd51JHbB9o5g/tj92BntGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBzGeyJkQB6eM068vc0oLinXj5T3T0f8bI6O37RaVyg=;
 b=kvNysihbQe8QKwY7LgJiSG/KwqWyJf/xRi9vU2q5bO7Ba5pUb+aacVpPGlwbVtLsWRAfNt5clbMBJN2A6F+yZqyayy8Qz24HMYkf2MYfgr4pfUPVM8h3lU0Nz1VFABYZ4y8wnI/9mwPm3DOdYns7JgJe3gOuQvkCInDr5qw7WQUFKNnw+U6ah0tWroj6wsLxCF16pYX619qJ1g1Vx1J2jsTynipa7dpzEBp2v/IiWHHhgvbTQNv1w4nS3irm0EukzQLcwyzH261d/UWAj5VyHXnMj3DgBLEOHl4HUG70MaRVQ8iBVpAJbYAflXcwcRcRyiEeYSsgrIgtwUQOnMNplA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBzGeyJkQB6eM068vc0oLinXj5T3T0f8bI6O37RaVyg=;
 b=rc9ayEGDAxcI7wqbQoNkvcVtkNmHoR7jq7sdQzR8JiEHIhE5pN4khP4kxyggr94wsOgzBBQf6NMSGQynk+mLpKsNk2CcyuQAoW9pWkj9y6cii+x4NWwSD5q6W2ied3YYd0TO3O61taRC4zUEZi5OoOk9CKu4gcgx21VE1HngKB+B3gTTjNkpncOFcO+2Q6zIVC+eEpxSR8acFmeRJWFaiF2SY0NqgwHj3uIVaNjFvDzpg0hy/yZ0QUIhjjW8LFQqIHWe01B9CrccKt3Y1Ktly+A9f/TsN2mL4SBl3gXZNrc8RhvCeg/iMOS3G5bxq/muTUwEOzMcDdBXzYYu0j4v+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from AS4PR06MB8447.eurprd06.prod.outlook.com (2603:10a6:20b:4e2::11)
 by GV4PR06MB10015.eurprd06.prod.outlook.com (2603:10a6:150:29b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 12:08:39 +0000
Received: from AS4PR06MB8447.eurprd06.prod.outlook.com
 ([fe80::af93:b150:b886:b2bc]) by AS4PR06MB8447.eurprd06.prod.outlook.com
 ([fe80::af93:b150:b886:b2bc%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 12:08:39 +0000
Message-ID: <8c1c66c4-62dc-416a-b52e-314ce98fe474@vaisala.com>
Date: Wed, 22 Oct 2025 15:08:36 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 136/276] perf test: Dont leak workload gopipe in
 PERF_RECORD_*
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
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
Content-Language: en-US
From: Niko Mauno <niko.mauno@vaisala.com>
In-Reply-To: <20251017145147.447011793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0120.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::26) To AS4PR06MB8447.eurprd06.prod.outlook.com
 (2603:10a6:20b:4e2::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR06MB8447:EE_|GV4PR06MB10015:EE_
X-MS-Office365-Filtering-Correlation-Id: d746d316-9f3c-4d05-e05a-08de1163bc87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDhyS3VSZXhObGNHMEdsUlE1QldZYmFONTJrbUhuTy8xcHpiejZ5V0FIb1N3?=
 =?utf-8?B?OWxJRm42R3M2NlVNTzBaRHJZYzRlcGdwZmZVQUhIb1BSWmJCT3VwUVBhV2FJ?=
 =?utf-8?B?Q2gycTRQcmt2MTFPSWM5MWRpZGVhNEViUHgzMWtuK2hucHY1bzJRRnh5NnV3?=
 =?utf-8?B?MGxTaU1ZTDFHdGxHUHFJWTVIei8zYjJNTEJnS1dnSGpPKzlzTFgwUW5qZ0I0?=
 =?utf-8?B?STBJRnI5QjRndTZlQnh4dXoyK3RneU1ZUXByaXJ5M1JmZ3VlWWdFWEsvcno1?=
 =?utf-8?B?dDMzanBFY0lxQVR2TU5BR0R5TTJzRVRHV29xSnVlR3hhWWZwL1RDUG0yWkZZ?=
 =?utf-8?B?VDlmWDFyS1dSdml5QmxRNUY2WnlEUEtVY3dONnphaHQxVUNNZllEenY0eVZJ?=
 =?utf-8?B?SHdjUXI1S2hvaExqK0xqalB0dlloSDUrc2dldlQvb2ZxVTJ4Rk1oOGxEOEt5?=
 =?utf-8?B?OTFQTC9GOW1NNjh3VEFPZFh6ajhKU044Vnk1ZWtNTTlydTFlM0VHWmtjNnp5?=
 =?utf-8?B?clBOTlE1VEt5TVk2V25xem9VczVFRmdJcE5sdTR6VitRVVZ1TGZMOUNuZ2Uw?=
 =?utf-8?B?QS9YWWttWWovUVJlRVErWERId3pGeW81bW5hY0ZnSnZDWTN2STRialI4ankx?=
 =?utf-8?B?UnN6REY2a2poNkh0ckhDU0Nqc05CYUxGNFR4dy8yR3dLRHowNGtnNVBsZkVK?=
 =?utf-8?B?Z1hVK1dNeG1vTWcza2kzREdMVDE2QlpJSEhOL250dTlyOGVNY1ZneGZ3UmVy?=
 =?utf-8?B?ejg2ejV4V0hXV3lrVmFvWGZMWEl4VHZ2elUvdXUyakZpanBRSS9sajJLdlpY?=
 =?utf-8?B?c1FwVWczTFcyd3ZXNFhRQko4ZFhHMSs4MTdKMXZhREtQY0NVYnJwZkcxVWRz?=
 =?utf-8?B?TnRaSkVJdGNHb29BUDNxV0hJa3hocnhQeTFXdFI4UWU4Mlk2L2FPbmJwSHRZ?=
 =?utf-8?B?Mkl1OVdJNXhoL2pNam9Wb2hZYzltT0tmTlhZcEFKSUh6dGFiYURFaGNPNndM?=
 =?utf-8?B?V3VUTG1ZbzZMN1pKaXFaaHdzYVB0SGZYTU01cW01UTFsYWJmSHFUL1hIdE9j?=
 =?utf-8?B?Rk1TZ1hvSGxEZTlEZmZEVnhXYzJ5Y3VhcW8vUkVteW81djg3cFlsbXhMMlRs?=
 =?utf-8?B?NXJ4c1lPZkg1U3pyMW83ZDNLZUxCV2hSdi9xZXJpdmhnM0d1RlJpL0Y2cUx1?=
 =?utf-8?B?VHQ0blVuR3pqWEtSRW5tZXNkWEhHeGE0Ym9LV2dURlFHNzJwZkZzRDU5aTRW?=
 =?utf-8?B?d0ZhaDl3c3M0eXJiZGNrL0JLMmNRczNWazV0UEpGM2h6Q1ZYbmVHckE3MTFu?=
 =?utf-8?B?bWh5Um4zSXVBY04yck5FU2dDL2o2Ynk5czFTOVgwVjdpT1B1VytJNVJjNit5?=
 =?utf-8?B?YlJUSUNjem03cHl2VXpyMnN2VFlkVTRwQUZzenpTWWl0Q2hNVHJPTHFyYUpQ?=
 =?utf-8?B?VUZ2eHAxeW5QcUJDdUY2NEJQUldsLytGS25BUXdZVlpkVGpFbGJHWmpNeERq?=
 =?utf-8?B?UjRqTVg4TEEzeVdkdkxodE9sUXB5VlpuV2NZdmZ4UTdieGhxM1A3Z28zMnYz?=
 =?utf-8?B?WHEreTJzN0paOHc3Rm5CTCthRUxDVlpTN2RvYWVzemZzWERhVERaYkNtUXIr?=
 =?utf-8?B?OWQvV0xObHJKNHdLV0lRclF6UEszV0l1cUJDVHN6NWNoekoxZldnWWUwTG01?=
 =?utf-8?B?ZW5yV3BaSjVkZS9OWU9kLzQ4bXhRWUNlbUZkdHRVTThoNzZEOHhudDA2WFVC?=
 =?utf-8?B?WVFTUit1YWFQL0p2amRjSHJXQURlaTd0QkxreGlsaGZsSlF2WlVkVHU1dytM?=
 =?utf-8?B?OVk0SGhLMUtMNjJjdlV4ZGdGR2xhVXN4T2lyNGRTb2ZSUHZjWkF6RGVpcUJS?=
 =?utf-8?B?QmpzRnN5c0pFR09KTE1KMlRWNFFpWFY5VWpPNFBoaXhuU29HVzVpbzArclF3?=
 =?utf-8?Q?z5x0eAYxHFsAnslLT8BAMo+kd1+/gL0c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR06MB8447.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVNLejJlajBydlp6Y0ZGcjRSYlVIQkk4eDRGMTVmN21HMnBjRE8rVklzaXVl?=
 =?utf-8?B?TGFoU3hXd3FjQmRQbFJ4YzlTa0hBSGxnOFcvSEVhZm9sYW1nZXh5bmpLZk5R?=
 =?utf-8?B?VFZpMWVRdnUwc0EzRU5oc1BmVTR0UUZ6cXVSckwyV0FKVmJRMjVGWHZRRDZN?=
 =?utf-8?B?ZGs2d3R5WVNvRXM5WUhNK3FEY1NxUll5V3Q5MkdMTjdBVGFpYnpjaUQzZ0dp?=
 =?utf-8?B?dHNEYWRMZGhobTRRendkeUdHc1QwM3NSWnNRY0ladXRYdnEvRzU5Q1B1Wm5x?=
 =?utf-8?B?d2U5TENsQTBaaFZEalhia3FHNUErcm15aXBPOUx1bDg0UzdiMm5TUzlLaTFE?=
 =?utf-8?B?clF0VUNSWlBtTG5yNVg0bXlYMCsxS2krNmJRbVp3US9IcEhjejNObzhydU5K?=
 =?utf-8?B?djZrNWlBT084T2xIT2xrMC9DdHB4aEF4dXdGeDFIM3NzQjRtbS96ZmxOZkNG?=
 =?utf-8?B?eE1IMXBhMFpZMnZ5Qm1mb0o2QVpkUjhIbUdKUkE3bW9PSE95aTFjNFZia1Fv?=
 =?utf-8?B?K3doU2cxUE9kQUZVdERjSHV2MXkweHd5NnM2YVNnOFZML0ptUXovN1dFcnVX?=
 =?utf-8?B?NFhPZkJtem0zNkhNd0lvQUlacUh5NHArc1ZtaGlMcFBpelBRMUpUNU5jaXBI?=
 =?utf-8?B?VmhjT245SjcxaE9NamZMYUlaM3ZOM20yeTZuK1pCUXJaemd1cXM2dVMycVRB?=
 =?utf-8?B?aVQ4dUwxQS9nUUsyMExHNkFCSHh5dGphL1pwVzloUVhHZ1B1cWpINDhDKzBl?=
 =?utf-8?B?dFpLMkZIWVl3NXh4S2JjaW5jUWgwbmNiRFAxSEpFekZIZTZZdmFBWmc1eUlr?=
 =?utf-8?B?TEtydkJ1eE1KS05SeGJNZkZ5Uk95aVNiaDE1b3p2Qy9WQXlZbHdyNmxGaVZX?=
 =?utf-8?B?eE5oUU5VQWt5bVVtdkVVZXplNHRzNVdhc2lrWnRnVE9UU3BVaCtCS29ta3Ji?=
 =?utf-8?B?c1Y0ZDQ0VHhCMFRrcUQ0bHgrL3R2UUVSNzAyMXNmL0NhN1V3WncvMEpZSEhi?=
 =?utf-8?B?Mklqbm1YamhPZitnb1hLakMrdlBxNldTY0w2M1hrOGhsWWVITW5FMDg4SXpu?=
 =?utf-8?B?YjhpeHhoRXZRZDA0aGQ1WFEyRTU0S2o3WExsWGt1Q1k4aThzNktNdzJJOU9p?=
 =?utf-8?B?Qng3TmN0VHp3c01Uc3Q0bzRWajczOWVnVzNRZmZWOHZvSkFSem5lWU12QjNB?=
 =?utf-8?B?RjhFeFJKN2pwb0t0aWxudTBlU3p1UGw0UFZoa3QxUkxJWncyOUd0WGxZcWFr?=
 =?utf-8?B?UDU5N1RzbEJMSkRkM3F5ZU1mL2tGL0VzekZMZk9SU3drcVEza21KMDhFeW5j?=
 =?utf-8?B?eEFkQVlkbmsrME1WYmwyZmluRkR5bmQ5cEljMFlPdE5KNk5wTVZ4VVpIMkpa?=
 =?utf-8?B?OXB0UFBxZW9rQVFLZVdkV0xGMzhLcVFUTG92OXBONWQ3UFdDWGRGRHQxQ0xG?=
 =?utf-8?B?enZ3KzVsV0JRUFVIV3NINmpIbW95KzFDNTBtRitZeUpQS0tiTExqMFNaSHVN?=
 =?utf-8?B?WHNDenhLdXIvUFVTNVVqcXlsd0F2bmgrWERJMXdnbEc3b0hGOC83SElRVDRj?=
 =?utf-8?B?YVhWTTc2bVF3aGlkQzZhcDZOdEhKbkpqcjhzSG0rQlRKOHRyYWtnOHlXREE1?=
 =?utf-8?B?c1NuQUdqTU9MU2t4NGpMZnl6Q0NyWFFSZytycXNoTmtjOWt0b2NJRnQrRGNN?=
 =?utf-8?B?b1VLQlFFak9IenJOWS9WTWp4SFF3QmJoTVJYcWhwTHBlMElCOE05QWRzeElE?=
 =?utf-8?B?eGh2T2pQUmpGRFVBWGlibFU4REVSL3dVbDFRN1FmREowNGZmYS94b3VjekhR?=
 =?utf-8?B?NkFvRmdqUzlnR21Pd3RML25id3V1NHV4MjN4b2RpR2hJcWovTnR1KzBFb2l4?=
 =?utf-8?B?ZzVMNGw4MHUzblk5c0xWQW9ETk54WGV0UWpNRW5nZHBvUzlrYTFBQzRucU9N?=
 =?utf-8?B?eWoxSUdoMzBWdURMMzNGVGN3Q2lHRXdVZVpQa1doaVN1U0VGTlpyNzJaTTFP?=
 =?utf-8?B?R3VQaEhJYjVwRmthbEVnQjhhbFM0aFRYaFphUmJscGgwVUJSSW9oamR6eEx1?=
 =?utf-8?B?SW9RaWVwVzVIdVZSUFg2TTBxYVZVeDZzWVl5MldKSmdaTEpIVlBzbTg2UXBr?=
 =?utf-8?B?TXk0ekZJbWRiN28vYXdzYjRCMmluUXJIM292bVNSOVlSejlFb2VnTkdkWmdm?=
 =?utf-8?B?MlE9PQ==?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d746d316-9f3c-4d05-e05a-08de1163bc87
X-MS-Exchange-CrossTenant-AuthSource: AS4PR06MB8447.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 12:08:39.7563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1w2NP6JbkhN1kzM71bwzbQ855VDev1+2pTvyHTVGuZG16fB9DxxNbJmOw/VC6paGY32ZovZOH+MksprhOsTTOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR06MB10015

On 10/17/25 17:53, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 48918cacefd226af44373e914e63304927c0e7dc ]
> 
> The test starts a workload and then opens events. If the events fail
> to open, for example because of perf_event_paranoid, the gopipe of the
> workload is leaked and the file descriptor leak check fails when the
> test exits. To avoid this cancel the workload when opening the events
> fails.
> 
> Before:
> ```
> $ perf test -vv 7
>    7: PERF_RECORD_* events & perf_sample fields:
>   --- start ---
> test child forked, pid 1189568
> Using CPUID GenuineIntel-6-B7-1
>   ------------------------------------------------------------
> perf_event_attr:
>    type                    	   0 (PERF_TYPE_HARDWARE)
>    config                  	   0xa00000000 (cpu_atom/PERF_COUNT_HW_CPU_CYCLES/)
>    disabled                	   1
>   ------------------------------------------------------------
> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8
> sys_perf_event_open failed, error -13
>   ------------------------------------------------------------
> perf_event_attr:
>    type                             0 (PERF_TYPE_HARDWARE)
>    config                           0xa00000000 (cpu_atom/PERF_COUNT_HW_CPU_CYCLES/)
>    disabled                         1
>    exclude_kernel                   1
>   ------------------------------------------------------------
> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8 = 3
>   ------------------------------------------------------------
> perf_event_attr:
>    type                             0 (PERF_TYPE_HARDWARE)
>    config                           0x400000000 (cpu_core/PERF_COUNT_HW_CPU_CYCLES/)
>    disabled                         1
>   ------------------------------------------------------------
> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8
> sys_perf_event_open failed, error -13
>   ------------------------------------------------------------
> perf_event_attr:
>    type                             0 (PERF_TYPE_HARDWARE)
>    config                           0x400000000 (cpu_core/PERF_COUNT_HW_CPU_CYCLES/)
>    disabled                         1
>    exclude_kernel                   1
>   ------------------------------------------------------------
> sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8 = 3
> Attempt to add: software/cpu-clock/
> ..after resolving event: software/config=0/
> cpu-clock -> software/cpu-clock/
>   ------------------------------------------------------------
> perf_event_attr:
>    type                             1 (PERF_TYPE_SOFTWARE)
>    size                             136
>    config                           0x9 (PERF_COUNT_SW_DUMMY)
>    sample_type                      IP|TID|TIME|CPU
>    read_format                      ID|LOST
>    disabled                         1
>    inherit                          1
>    mmap                             1
>    comm                             1
>    enable_on_exec                   1
>    task                             1
>    sample_id_all                    1
>    mmap2                            1
>    comm_exec                        1
>    ksymbol                          1
>    bpf_event                        1
>    { wakeup_events, wakeup_watermark } 1
>   ------------------------------------------------------------
> sys_perf_event_open: pid 1189569  cpu 0  group_fd -1  flags 0x8
> sys_perf_event_open failed, error -13
> perf_evlist__open: Permission denied
>   ---- end(-2) ----
> Leak of file descriptor 6 that opened: 'pipe:[14200347]'
>   ---- unexpected signal (6) ----
> iFailed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
> Failed to read build ID for //anon
>      #0 0x565358f6666e in child_test_sig_handler builtin-test.c:311
>      #1 0x7f29ce849df0 in __restore_rt libc_sigaction.c:0
>      #2 0x7f29ce89e95c in __pthread_kill_implementation pthread_kill.c:44
>      #3 0x7f29ce849cc2 in raise raise.c:27
>      #4 0x7f29ce8324ac in abort abort.c:81
>      #5 0x565358f662d4 in check_leaks builtin-test.c:226
>      #6 0x565358f6682e in run_test_child builtin-test.c:344
>      #7 0x565358ef7121 in start_command run-command.c:128
>      #8 0x565358f67273 in start_test builtin-test.c:545
>      #9 0x565358f6771d in __cmd_test builtin-test.c:647
>      #10 0x565358f682bd in cmd_test builtin-test.c:849
>      #11 0x565358ee5ded in run_builtin perf.c:349
>      #12 0x565358ee6085 in handle_internal_command perf.c:401
>      #13 0x565358ee61de in run_argv perf.c:448
>      #14 0x565358ee6527 in main perf.c:555
>      #15 0x7f29ce833ca8 in __libc_start_call_main libc_start_call_main.h:74
>      #16 0x7f29ce833d65 in __libc_start_main@@GLIBC_2.34 libc-start.c:128
>      #17 0x565358e391c1 in _start perf[851c1]
>    7: PERF_RECORD_* events & perf_sample fields                       : FAILED!
> ```
> 
> After:
> ```
> $ perf test 7
>    7: PERF_RECORD_* events & perf_sample fields                       : Skip (permissions)
> ```
> 
> Fixes: 16d00fee703866c6 ("perf tests: Move test__PERF_RECORD into separate object")
> Signed-off-by: Ian Rogers <irogers@google.com>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Athira Rajeev <atrajeev@linux.ibm.com>
> Cc: Chun-Tse Shao <ctshao@google.com>
> Cc: Howard Chu <howardchu95@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/tests/perf-record.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
> index 0df471bf1590e..b215e89b65f7d 100644
> --- a/tools/perf/tests/perf-record.c
> +++ b/tools/perf/tests/perf-record.c
> @@ -115,6 +115,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>   	if (err < 0) {
>   		pr_debug("sched__get_first_possible_cpu: %s\n",
>   			 str_error_r(errno, sbuf, sizeof(sbuf)));
> +		evlist__cancel_workload(evlist);
>   		goto out_delete_evlist;
>   	}
>   
> @@ -126,6 +127,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>   	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
>   		pr_debug("sched_setaffinity: %s\n",
>   			 str_error_r(errno, sbuf, sizeof(sbuf)));
> +		evlist__cancel_workload(evlist);
>   		goto out_delete_evlist;
>   	}
>   
> @@ -137,6 +139,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>   	if (err < 0) {
>   		pr_debug("perf_evlist__open: %s\n",
>   			 str_error_r(errno, sbuf, sizeof(sbuf)));
> +		evlist__cancel_workload(evlist);
>   		goto out_delete_evlist;
>   	}
>   
> @@ -149,6 +152,7 @@ int test__PERF_RECORD(struct test *test __maybe_unused, int subtest __maybe_unus
>   	if (err < 0) {
>   		pr_debug("evlist__mmap: %s\n",
>   			 str_error_r(errno, sbuf, sizeof(sbuf)));
> +		evlist__cancel_workload(evlist);
>   		goto out_delete_evlist;
>   	}
>   

it seems that this commit breaks building perf followingly with v5.15.195:

   | /usr/bin/ld: perf-in.o: in function `test__PERF_RECORD':
   | /home/username/src/vaisala-linux-stable/tools/perf/tests/perf-record.c:142: undefined reference to `evlist__cancel_workload'
   | /usr/bin/ld: /home/username/src/vaisala-linux-stable/tools/perf/tests/perf-record.c:130: undefined reference to `evlist__cancel_workload'

The 'evlist__cancel_workload' seems to be introduced in commit e880a70f8046 ("perf stat: Close cork_fd when create_perf_stat_counter() failed") which is currently not included in the 5.15.y stable series.

BR, Niko Mauno
