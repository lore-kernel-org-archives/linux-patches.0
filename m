Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33B285050;
	Tue, 27 Jan 2026 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769501336; cv=fail; b=dj3CL0y8s0fqa3HAsN9YKX63YxOc7fvMYL7w5LRGLky58fsF5LK7E2ZkFTrjuDA4JKzhNcnsZ7+W32YVllUPvTvAivZppZSGi+sb16zoRn6717g7wU2puKctgXpCxjQ51qWfGKGOgK3z6/0g2CxmgtVXmk4eYupIqm31+4U9pj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769501336; c=relaxed/simple;
	bh=KUkDcyOFTup4d0uBWzXcdEJ8ptEy8xR0ipZcYaK8WUg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a0KT0xx4+5fDpyyvVobEeVYupl0lmkW8HgCnQ1xVrnXP42vqsEUd+74MXnGt9WO/AQRYmGzFpSBPFvmjOmHjHVKHmjplgi5yhTXWq26kD58Yg7vW3xJP0+POaY1F2KD6ezg/exGH+LqhFO49RmOVasOBfaaXURa41LOQ8n9De1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CfevPdQ6; arc=fail smtp.client-ip=40.93.196.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CfevPdQ6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sm8RsoyI0loy4aTUzjFDiUI+LM+QbVCBeFH/rWSYuMaKe5sp+eEG4orbBu7U4ycRqbHh32tH9tiK12n5VLJQoPT1t1hOM1dH05fDGFkM/CpsvIEA5B0jHf3idCcT8aeWM2Xl3vP2rGPFPy7H87xdLQjeOi2uU6wKL6sWrfEqeqf9u24KY9ui8VT95U7erIMvTrwpp4RrO1Ty//arXhwf96OmGPIiK3McKNiVLPLnUbhgw1DfryT5lec3aRhsjjgVSJJYI6PVVAPD6mfNcVubCdf8wP9G0MgQLxZnW88Y0GwsoMQiSAr3dK2UITWo5CrjAr8Rp35e9++3+vsW+IY/rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgqyAeNEF0Ca6gusaIYSA0MyKHxTGT1BgXV2xdoS+mQ=;
 b=xdjC1cXtROtJkH5jyeCEI4Xx51zU8yxg/7i7ov5XvGaBkNPg5IPYRMeJK9/3X1P+u5+xyxhcVCrWfR9/IDvYdkLoxgMUoyZOZGC3ol3bzzP2gNma7ZM4fz7l+4QuHEoDVYeZT8fQswV2VQDP4TRNydxBb82kuyTUFYQuyd8+c1oe4vuz5YnyaQQyPfbYUfsIjCJiGKQbHC8ORC4VlVY+Ltwriw494PnkBOfVSnIV9C6AC/He5wOI5wiBuw9E4TGuVmdaeXs6V/c6s1LtDH66dVXiEcb3d+ISAzU9PEVD0fSfCrwfl6/xnZ/1JdEoOWEUfHLBMpwn4rzhmwxWnsv0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgqyAeNEF0Ca6gusaIYSA0MyKHxTGT1BgXV2xdoS+mQ=;
 b=CfevPdQ6RY9RELxRUVA6othaIfYbPDfVbpkQZM0VAqGtQUlmFBXwXXbqWV+kvAZCsD7TlNy5KFRkBm8MmLy7wrau3VTQj85YOXdQ3zFYC0yN3QErSHel/gak0yLPBCDsR9T8YnprF8zsZ+Jh9lYPeYKPPfxOBEgcy4cEVSJvFBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS7PR12MB8417.namprd12.prod.outlook.com (2603:10b6:8:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 08:08:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 08:08:51 +0000
Message-ID: <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
Date: Tue, 27 Jan 2026 19:08:39 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
 Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>,
 Michael Roth <michael.roth@amd.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
 <20260123141413.GY1134360@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260123141413.GY1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0034.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:206::14) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: 691eae08-4154-4012-8ea4-08de5d7b4e32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFVVRUt5eFRTcXB2djBSUGNpQjRBSStRMVF0dmFiVDlkb01iWDliNitkTWlU?=
 =?utf-8?B?eWZPYjNqOFlQcC9NYjMvQ0tPN0tWK2RxdEpFWEdZNWJzS2wycEt4UXFMZXdh?=
 =?utf-8?B?UFNiWEw3Sng0aFVFZmtyb3FEMFI1Uk1SY1oybHhGVHZMRVhQaTN3Wjk0c0Y4?=
 =?utf-8?B?VE8zMWtNd3VUVnVyYlpTNWRQeW9hN28rV3pZNk5XTEpRcW96LytJV0t5blJ4?=
 =?utf-8?B?Qm9LK2dHb2tTT29VaFhXL0V2YWJ6a1RNMWYweisyUDFUYTZUcXM1eHRJWE91?=
 =?utf-8?B?eVVyQUZrZUJ0cC9ZZDg2aFVVUjVWdjNCYklOMmpJQlVKOXBNb1JBZW5PZFlD?=
 =?utf-8?B?S1ZWeE1QbDZscnhDUy9CQ25rZUpmQzdKR0Y1N05pWm5UaS9rVEFCYW9QSTJF?=
 =?utf-8?B?d3hnQkZIaUlKM0dDTjNkSEZhUXdZcC9DWTA3Nlo2ZkJJcW84MlpDVzVpcGh5?=
 =?utf-8?B?d2R5UVhnTTNGZHlIM1JLaGFDZTZGL2hzTUJYaUR3UTRaUmVyRHJOL2gwMGpx?=
 =?utf-8?B?NWttLzNGcGVhTmZmdDh0OC9DVjlCMkNDK21ESWFkZVdwbHVPemx1c2sydU9u?=
 =?utf-8?B?b1hOY0I1cnJBS0pKRWoyaWV3Z1p1WEF5S2o2eEo0emRZSFNkZGZyaFU4V3lS?=
 =?utf-8?B?bVR2eG1EeG5uT1pLYmJTczhieWZPdTVmbUM2TUpNUFNlTzhBL1pSRS9IQis4?=
 =?utf-8?B?Vi9tNitFRXUxblFYY2s2OGpILzhTdm1GazNRb0ZZWjI4V094Z0NkK3JDb1gy?=
 =?utf-8?B?SEZybXQwYVNPb1cydVZvTHowazFrWGk2MUVaNThDeHBGaXFDTng1MDh2RXIx?=
 =?utf-8?B?SFMwcWVXT2Q1RXJGOUZocUpaT0Z6REJraC85a1VYR1l0SzgxU3FYT1NZUXBq?=
 =?utf-8?B?dExwQW04ak9ZdGp1dUJscHQzMGNPbHZacHhML2JQNFpOV3ViV1BQRXRBems0?=
 =?utf-8?B?T3VpTjVUOU9yS1FicUlRSTFieW9SRmFpMVMzWk55T0FUVUxiZDFxbFR6djcx?=
 =?utf-8?B?OHE2R0tkMzR2Z05zRk5OZlJHQWtRMnJXY2RnRVBIWGFhekZrbmFNVXpaelhY?=
 =?utf-8?B?WTZpT1FpWlRGK3pnTXkyRnBsZUZ0ZXhqL2IyUFYrNEM3eURJRnpxL2R4WXFq?=
 =?utf-8?B?ZmJtbHdLSGhBMGhoaEs1UlQ3L2s3S2VNekFUL09Ec3o0UmJ1WnlrbUxkYzhz?=
 =?utf-8?B?VmVwUitXS3JwZXJkS3ZIbUluNHFPemV5OUJmQ1MvSm1oOHgrWlQxWDRhdEZl?=
 =?utf-8?B?VWM3Q0ZmVXdnZ24vcS9YeWZlVUVnMTlyK2xENUJVOGMvQ1hNNEswWDA5cjNW?=
 =?utf-8?B?OFZFRjR2OHdtc2pWdUQwcGp1aTcvaS9vT2p4MTRBcERkYlgybitzTjhMQ3lm?=
 =?utf-8?B?cGt6dWVRajJER1RmL3hDQWxJcFpUa2hGako0NVV3MzFwbFp2ZVIwVWlybVpi?=
 =?utf-8?B?MHRoeWN6RWpyUTVYQTVWc0lYRTNQV1JYenBWY3IwdVFlTlhTZk9oMkhZUzlG?=
 =?utf-8?B?WVUrSVFHczJkRWVvQ3ZmLzIvd1ExMXo4a0RWeWhQbXdsNnNJQTY3Vzk1Yzhh?=
 =?utf-8?B?SUdBaXZ4RXpKOWZuTWx1OUFOWWY2ZWdqU243K0ViQnZidHRJaW5HSklCWFcv?=
 =?utf-8?B?R2Urc3JaaFpEd2g0RHk5MExqQjE5bC9TZkIweHEzQWx2c3VvOS85aTVLQ0FB?=
 =?utf-8?B?WkROR3lXRUNmUFY2ZFcrWEw3OHZNQnU5a3krTWZYQmxmcTJBeGsvcXFheGcy?=
 =?utf-8?B?SUppQmFicjFBczdmZWlGZ3lBaEYyWFBEN0hrYWcrYmlsQXJCNWM0azVxdlZE?=
 =?utf-8?B?UEVXa0J6b3hRL0xCbGV3M1ZsMDErSURxZ3pYYkZuVFIySUpwTHhZSXNScnlX?=
 =?utf-8?B?NTd1OFJkRXRYQ0lDK2ovM2o3SFJVaURhTTJySERZN1dDenlPVWFHYnBBUjhZ?=
 =?utf-8?B?ZUQ4VG82ZVVkamFPc0tLS0pQcFJibys4UmlsRHFyZDJNL0s5TnRPWFhkRjVy?=
 =?utf-8?B?Q1FObnhuU0txQlZIWWpmUFY2Y2tTZVhKUmZHcXBrakUvZTlvRVFTZGNudHpX?=
 =?utf-8?B?WUxtQWlGYm9uMGlDbVlWYXRxWUs1M0hKaHZ0QTJ3Y1VVOUhaampQTUpBR05n?=
 =?utf-8?Q?SndI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkpMRXYrL3lsMmRWUFRlUzF3L0NyN0liYk1lZDRDMmhWa3M1L0FIQ2VmeGdD?=
 =?utf-8?B?YmVYNjhnSnQ4ZVVJMjZoS0Y0UnZBUG9zR25Ia3ZuL2YxS2ErM2JKWlhlc1ha?=
 =?utf-8?B?d09aMXZFeVJDSEV5OE5EVXVwTWFiK3J3bFFPcG9YOTdZbyt2Tno3RHJ5WExV?=
 =?utf-8?B?Z0N4NHFIN0wraTJYOC94STVYRndIbUJFVmFUdVA5OHkzck5KTnVPVk13YkM1?=
 =?utf-8?B?OWRrcENBczRMRGJYT2l0Yk5UYVpodjN6enpOQXZhN0VZV3RGOUZpK0ZuZ2h0?=
 =?utf-8?B?aERoQ2U0aFpWdHhtR0w3Nk52bjdYUGZzY0lKVFIxRjYxWGdkcVJlTUdKREli?=
 =?utf-8?B?NjR3MDdLZXBZRWlvTmQxYVBpMzJoaDNyRVVGeXJHRnhOZU16aHMrTHZaZTBu?=
 =?utf-8?B?MlI1OVRNcUsxMzBiVlY2dFd3aW9uTm93MVR6MkVUNGhBMkpFZXFqUmpLUm53?=
 =?utf-8?B?TjVpYXpNd1JGa1hmOU5TQ1kyUkxldE5ZR1dqR1N6TmNITkdpcStCUTYvU1VK?=
 =?utf-8?B?SVZTM1VoTGlrNldBaXhmek5GeEVjWUxKWThkS0NiWk00RmF3MWJxWEppQkRl?=
 =?utf-8?B?THJGMlpFc0VON1ZhVWU0OVduUzZpTWg5NmNERlc5eVYva2hTY0Y2Q2grZURx?=
 =?utf-8?B?SnYwNTFBclZKd3Y4WjNRaHMyKzQ3ZDN3OHdDSDAwbEZyS293Sm9JODhtWUtq?=
 =?utf-8?B?RzNMYUlieUI0OWFCNGZySHJqZFdjUUd5U3R6QXdrU1dxYmFtekVESnNzcmtZ?=
 =?utf-8?B?V1VnZDBJNEhBRzBtUzQveDl6SU03NnN1cHVSSTEzWUR6RzA4SHlQUWtxa3Fh?=
 =?utf-8?B?aHRESUI0blpOR1dJYXd2cjlBMjJyK2gvelhkTlRyTloxbnUzb21BZENmSHQ4?=
 =?utf-8?B?WnJBNnptL0RzZmhjOStYNlpYTCs0cEFLS1dBQ1dPbGdDd1VzTk00YW9uVW9R?=
 =?utf-8?B?VW9UTFErZEJBQVZldmMxUEVOdURIVW1HdkVWUW5zV3hGTWMwaFdJR0FkMTYy?=
 =?utf-8?B?T2lnMHJZRWNndjAxZkdsSzN2YWFqU1BRNFBWSXVvYjJjKyt4T3VTM0hpSlJP?=
 =?utf-8?B?dDRsbUlLWDVHcis4UXdsVTQ5VEs2SFpqSEREdWw1RHN4TVBBR2RGZ3A5NTdx?=
 =?utf-8?B?OG5VZGFYUGp3QlZTeDYwWmV2K3M0MXhpd3JUS29yOTZBazlmNVA4TElXVWFB?=
 =?utf-8?B?Y3d6NWJEWDladGluS281WE9acEhyT2NtRUFuU3NxUk5CV2h4bi8yUmI3NHJw?=
 =?utf-8?B?UjNNcVMwT0ZkK3k3UUxSdWR2cUF6YmNXT3kvVmo1Umw2c29jWU1yK1I3aXBM?=
 =?utf-8?B?elQvNnVqa1ZXSmVEbjZ5NC9DV1ZwTjlUdjZJNklKdjFNYUk5N0NSRmFad1kx?=
 =?utf-8?B?aGtScUJITUJLQ0tabXRqNzVLT0RHT2hzY0hOYzBJUWpvakxGcDVzSytSMldp?=
 =?utf-8?B?emdGaUxPYmtJb2VXYmFFekcxTFFEODUzVHdDYm1nMkNNT0hic1pPUHlqODBR?=
 =?utf-8?B?VlExMHArUnZOZHNGZmFOWnh2STRpTkNLRThyeWgwbFRiWjlvTHc5dTRSS2R6?=
 =?utf-8?B?RCtWZGFDb2J5MDJSb1ZlK0h6WmE3Z2wzUDRNNERsS3hXYnJsNDd4L3JDb0pP?=
 =?utf-8?B?S3RKZTdIZlJEZEUrdkZSSk04U3gybCt0eklPcmFiUWU4bzJjZXIyT2JFL2xx?=
 =?utf-8?B?Yno4anVSTzJXcUFQUjErV1pIY2VBaTVDVzdLZWxIQzdQU1UvNU9NQTgzZEtX?=
 =?utf-8?B?NTBlaGx0eFp6aHNGeFEzWnAvYmJTUDQ2bHB5QWgyLzd2b1dYeTlXSmx4Mk9y?=
 =?utf-8?B?ZTZJcG9tRzNFeVQxalpxNVNYREE0Z0xWdzRqdS9pOGFYZlBNLzI4UWlCK0VF?=
 =?utf-8?B?VGpUeEtnMzJzWGllZWRFd1VHZkF1ekhPTnRRWE5PcFJCSzN4dEpKU1QvbjU0?=
 =?utf-8?B?S1lZN0IrSlVHNlYyMmkrVjd3MzNwVGF3ZGM4SjdJZWcyUHdFMFJPYlprWTJ1?=
 =?utf-8?B?YVg0TmRHUnQyWlBRbVF4MmFuc3Z0ZytMVVg4bXptaGI0UXVGbXFvS3d3bCtk?=
 =?utf-8?B?ZTJqMURIaTRETnZ0MFprdDU5Rm52WFI4RFRMSVVmcUxmemRZaGZWaUFLRktB?=
 =?utf-8?B?OUVQaWl0TVdtWnp6dnZGdFRSQmhYMGRxSVhaUTFZUGZDZU41NnRzNnNJUGQr?=
 =?utf-8?B?RlVwTlRKajZNd1h6WHpRbU5xSVhiY1h6bmMvTTlwZ05KWnF3YzkzVHlxNEd4?=
 =?utf-8?B?WEFib0swYTdtZlF6NWlBVzVHL2k5Rk9xZDRrTDhLQVlPVjB5b3ZhYkFScUxH?=
 =?utf-8?Q?R/W7MUVa4tU33Catxt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691eae08-4154-4012-8ea4-08de5d7b4e32
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 08:08:51.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kSXPcbz33N8qkhCQP9DIIxSOLlUzChKXjpNAO+A2fCIYTUbvW4kLlrpDKaNaiKv0QvteAE8Cq5Mt7YMkx9kZ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8417



On 24/1/26 01:14, Jason Gunthorpe wrote:
> On Fri, Jan 23, 2026 at 12:07:26PM +1100, Alexey Kardashevskiy wrote:
>>>> Got it. Interestingly the HW actually does that, almost. Say, for
>>>>> =2MB IO pages it checks if RMP==2MB and puts a 2MB IO TLB entry if
>>>> RMP==2MB, and for 4KB..1MB IO pages - a 4K IO TLB entry and RMP==4K
>>>> check. But it does not cross the 2MB boundary in RMP. Uff :-/
>>>
>>> Not sure I understand this limitation, how does any aligned size cross
>>> a 2MB boundary?
>>
>> Sorry, probably wrong wording. SNP allows a guest page to be backed
>> by only a 4K or 2M host page, IOMMU always rounds page size down to
>> the nearest 4K or 2M boundary. 4M IO pages can work with 2M RMP but
>> not 4K RMP.
> 
> Oh so it doesn't actually check the RMP, it is just rounding down to
> two fixed sizes?

No, it does check RMP.

If the IOMMU page walk ends at a >=2MB page - it will round down to 2MB (to the nearest supported RMP size) and check for 2MB RMP and if that check fails because of the page size - it won't try 4K (even though it could theoretically).

The expectation is that the host OS makes sure the IOMMU uses page sizes equal or bigger than closest smaller RMP page size so there is no need in two RMP checks.

> 
>>> ARM is pushing a thing where encrypt/decrypt has to work on certain aligned
>>> granual sizes > PAGE_SIZE, you could use that mechanism to select a 2M
>>> size for AMD too and avoid this.
>>
>> 2M minimum on every DMA map?
> On every swiotlb allocation pool chunk, yeah.

Nah, it is quite easy to force 2MB on swiotlb (just do it once and forget) but currently any guest page can be converted to shared and DMA-mapped and this skips swiotlb.


>>> Then why was I told the 4k page size kernel parameter fixes
>>> everything?
>>
>> Because IOMMU becomes 4K only and there is no huge page support in
>> the confidential KVM yet (well, in the upstream linux) so page size
>> mismatch cannot occur.
> 
> Ok, but you say when RMP has 2M pages then this doesn't work?

IOMMU pages size forced to 4K + 2M RMPs? Yup, does not work.

>>> What happens if the guest puts 4K pages into it's AMDv2 table and RMP
>>> is 2M?
>>
>> Is this AMDv2 - an NPT (then it is going to fail)? or nested IOMMU (never tried, in the works, I suspect failure)?
> 
> Yes, some future nested vIOMMU
> 
> If guest can't have a 4K page in it's vIOMMU while the host is using
> 2M RMP then the whole architecture is broken, sorry.

I re-read what I wrote and I think I was wrong, the S2 table (guest physical -> host physical) has to match RMP, not the S1.


>>>>>> If I get it right, for other platforms, the entire IOMMU table is
>>>>>> going to live in a secure space so there will be similar FW calls so
>>>>>> it is not that different.
>>>>>
>>>>> At least ARM the iommu S2 table is in secure memory and the secure FW
>>>>> keeps it 1:1 with the KVM S2 table. So edits to the KVM automatically
>>>>> make matching edits to the IOMMU. Only one software layer is
>>>>> responsible for things.
>>> ?
>>>> Does KVM talk to the host IOMMU code for that (and then the IOMMU code calls the secure world)?
>>>> Or KVM goes straight to that secure world?
>>>
>>> Straight to the secure world, there is no host IOMMU driver for the
>>> secure IOMMU.
>>
>> QEMU will try mapping all guest memory and will call the host for
>> this, or it won't, on ARM? No IOMMUFD in this case? Always
>> guest-visible IOMMU? Thanks,
> 
> iommufd won't deal with memory maps for IO, the secure world will
> handle that through KVM.

Is QEMU going to skip on IOMMU mapping entirely? So when the device is transitioned from untrusted (when everything mapped via VFIO or IOMMU) to trusted - QEMU will unmap everything and then the guest will map everything but this time via KVM and bypassing QEMU entirely? Thanks,


> The viommu and stuff is still optional and> would be controlled through iommufd.


-- 
Alexey

