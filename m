Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A5C40B6FE;
	Thu, 22 Jan 2026 10:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769079503; cv=fail; b=lfNrOTnZl2wpFqxScGjVod+aWXte/4c/lX6OxmsHN3+ahgx9dvniLFIBrAGhGUTex8YLBRrE+w6htYAdr3ElHF0SnubUb3KSxoY9d6yA/J1p78JgUzlhHJZMVZs9LzjfxnNJBdxu/MENl6zr+xGacDASLZ6V+0jng1vk5/Umt3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769079503; c=relaxed/simple;
	bh=pkkY83Isrw18f4meYmUswhYVf/bINkxZMaMqiM9+9XA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BXGqfstsC8B3LHCs2Qkvw2aMFZL+g6Ad2TRsIg9KgOnu+y/n/1h7VpFLccpSMvu+LUlPhEnaZuMoZNN1St4hJVtnh29DZJRdhelB1nFgSdkq+wpr6lgDNwVvZGI0nRlvWAHQgWpfnqwl4pXd2sqdSpwGuMCdH4NR9bFnncjDhXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U56+2fpy; arc=fail smtp.client-ip=40.93.196.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U56+2fpy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3sT0e+jVrmlB3gQYtmOXnfFBCRjTulezeruAT1Mstf4TzbZd3Qs8vm1TdJ47tq0G5/k+oHiIjv0NIKIVfX/nh9EmX0sOH6gpvLSHVhWc/NYIb9DMDBFq2i/nyiq6Iwa+jLimdydgZlFoHCqTZPZ+2xY9eDuvMqzLLNW/F2ylvA+q1hNnjRc9tGDogkV/9w+p5kkqyTdMRmosk9J0GpdpvGmhlyxp5zdwOB/BOTpF0PJz6Jc9BzTrxZzpLPVV6shZbvJUEXBuitna/jMsT/u+akOX1u0urm45ygAMfNQB0YOSdqaHbhDva6lPaH5JyVYDONJRj90t+IbyT/CRRETFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqjitsw9qB0UNCzjMtJDOKoSMiPNjU248/USY7fQQ0U=;
 b=AUE8yzRnccsBX8bZSPILqUYKdgRqL0yBcxGKU73Ca1TPHrbEY8EyUSopudiEwZHZIe8lH3w6tKz8NJHynmXkuM5qWb16CwBk/Uj9f0pvFWZM4DQXjPMJ7avbTk3hsqqdx2tEyCyKz+a77uQO9TvXe8E3AclCi8x6Fiu8uR5d2rS8JVC1KPlCiw8nvciXum8Xu3Gfbi14d9zqmYQ20WwC7S/vmEvlicotpc9EvNMU5VDyDzcWru74TDCQzx4WhUwaGTg/Y3jWzK2mL36DYN9+r7PpxEf8hNO3s29VqC1O0oECsB5RImuKWoKZUbHpF5Dua7msFqqKSL2KSLI8IWv4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqjitsw9qB0UNCzjMtJDOKoSMiPNjU248/USY7fQQ0U=;
 b=U56+2fpyGWBLtPMqRpqOOojal194Q2owXF6O2c9bOsdkQtNuKz6s0A/qCDT+Hw3pslrJdQlYzAs54cwEH5rnvqwCjdA4RCwXFfQtpNEvePNA0QR9bR9j7ui6teWEnXoww/82UeyfTRmXakSgeX6xdxeMny3yqLXj923LRd1a+8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 10:58:15 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 10:58:15 +0000
Message-ID: <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
Date: Thu, 22 Jan 2026 21:58:04 +1100
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
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260121170931.GG1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0104.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:204::19) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: d832d20a-c1ae-4300-7372-08de59a5248b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHlFS29aVm5VbzVpUlZzeUlBVVFCeVFoQ0JhL2tXb1J2VHVnM3JsUDRTWU5i?=
 =?utf-8?B?cUpGK0N2ZzY0WU53aHJXMnBLK000MFhqS1VFaDZvR1kvSUw1dUxhTmI5YjFi?=
 =?utf-8?B?a3ZWTW5UdVFhaDNibGliOFlLbm1aeHR6RVNsUkZlSTJBaGdPdEk0dDYrMXU4?=
 =?utf-8?B?TUV5RDNmbnZseXpWTnZzSUhQYm12bUpZaEpiUnFCL0NlMVZxL0NYSkZoY05w?=
 =?utf-8?B?cTUrYmFkNjNZa2QvbUx3R1FXcHRoRTBtd2xUaTlQc0puSzcvU2daM0h1TFJJ?=
 =?utf-8?B?UUZKenFyREtjU05TTjlwY2w3dUhWdHo2NmthQVFhUlJYank4MWluUTNHb21E?=
 =?utf-8?B?a2E5L3FoMmdzb1ZhV21RSVZkUFVBSjdoeDRCQlBFdTlCYnNuR3J1dXpFS0JU?=
 =?utf-8?B?bm5YZnI2akM4MWVyUzJjR2pNSENrZWoxUTN6NytrekNTQXVEMGhENmF4L09F?=
 =?utf-8?B?cCtHY0drU1lNcHJDZkFnK28yK3pOd1NJWmp1Y2d4QkxCdEdkSUppWVBzaTRk?=
 =?utf-8?B?S01GQWpHeWhSL1ZOMVRoVzN0VUQ0emYyWVFTanBGNHN3TjBGNU5jVUpkUzZ6?=
 =?utf-8?B?cktVNVRDcERaK1daZHpUVFBnYXEyeXV2bWRuMEYwdWlNbmRNd1VrWnpFY0pO?=
 =?utf-8?B?UFlGcVFXMFgwUTJxZ09BV2FDTGZpTVRVN3JpdktpVmV3cjB6TFdLcHZSS1c3?=
 =?utf-8?B?VTh5TUxFb1dDMitBbG1IWW5meDFLRWNwcHNYU1poRitlcmY0YVdUcWdueCtZ?=
 =?utf-8?B?QUNjSmNHQmczU2lyNitoOXJUbHVjUTdTd1VjbDlDUUsrUGFGTlBXQXhLWm9p?=
 =?utf-8?B?VFhHdjV3bjFwa1BLcy9qdGFJSVhSdEhxNFkybkV1VFFEVXNKWnFIZ05qSWlm?=
 =?utf-8?B?TTRZN05LNTBYMjVjOTgrSSsrcVlVR0I1N3dGaXFCKzVucFczOEZ5bTR5YUNn?=
 =?utf-8?B?RW9FVk53Zm9kcjBERkFab0orRC93Y3ZUbVBCVW8zZmNkeStOUGI4blU0d3M1?=
 =?utf-8?B?bmxlTUdNbXFVUEE2MnZQY056TG1DQkdnRWVsNURZWGRhSFBWNzNkMUlySVBD?=
 =?utf-8?B?UDhaNUNXTmxRNmZQbm1aQ1NuSDRMU0p3UFgxS211UmhxeTBNMXNqdThZenBm?=
 =?utf-8?B?MmxsOTRjTURhZWt1cXVSUVJ4bEV4WVNsRkFkNVNGdmpLK2J5Q2E0U0gzRE1i?=
 =?utf-8?B?MnpGSU1CL2RtUE8vLzdpMm9HYUVnRGltYlBGTXZnVFpSRERPSDcvNHFicERR?=
 =?utf-8?B?cGlnd2NpcnIvS3JRTURDVkZaWStiY09ZOTVTd0VTOUpuS0hRSitERTB6YUw0?=
 =?utf-8?B?V0YwWDlVYy81UEo3bHJTQlZoMnFqVGV6RXZWcW1hQ2FrbFVROU9CNjErS3RW?=
 =?utf-8?B?OHZFbVBUUm5qNDFZdGI0eGJ2MS9idlZ3ZGZ5K2pUd0diM1JaTnV5MWJOdnJC?=
 =?utf-8?B?cHNubU0vbEZsMFBYN1BPZHY1Zm05b2QxMXM5ZFUyMkVWRjVHb2podTN3Q0pq?=
 =?utf-8?B?WmZCY2dBQWRTYlRNMUIwa2ZNRlA2Z1lkY212UmpsMHU2RVhqbUVaZFBFdXBp?=
 =?utf-8?B?cFk2czlnVk1GKzlZNUdmWC9aRkZkQngvSXVicFlUODhGbmU3dkM5c0RUbmlU?=
 =?utf-8?B?V1JDMjV6K1lRaWl3MjFXT1ErOFdnY3IyclhMaGdaS2I3TFRCaWtYV0t0RTNS?=
 =?utf-8?B?bEw3ejlFNk5aWjk3aHlYTXIyay9Fb1NDaHRnUEVyYklFTTNtN1hEYUlzeDds?=
 =?utf-8?B?OGQ4ekF3RmJjUnJhazR2V3dHbHRXR1U1dWd2WFdHZlVwSGtGZVBxcWRjUGFQ?=
 =?utf-8?B?UjZJZzI5QUZPNEJYanJmc0dSRWVFWU90WFY1blB4SUJEUEN1QVIwMDJjNVdh?=
 =?utf-8?B?aVpBNTh1SWFWLzRXNkpsRnpXdit3V3Z5cmxNM1dualExaForenQvQUFVRElX?=
 =?utf-8?B?ays3ZXFvVThLanUvblorUnFMdzl3anJBUlVZVm1nV1ViUktqbzl4MlBoakp1?=
 =?utf-8?B?OHJwYThCdWJPWHEwVW5jQTlHd0NxczAxTkVxOVlQUDRibGFzeWNvM2oyZ0xh?=
 =?utf-8?B?d0lIYmF1QndKejNDekFsN0xSZjVOYUVIVEJETDVNREZ0aVRxNS9wLzE4Zy9B?=
 =?utf-8?Q?gahA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ellmZWFmLzgycnJBTGh6Uy8rVGRDUHBJVDRPamZIYkRPMlFNNDhkanA5ZHEv?=
 =?utf-8?B?WlR6MDJ1YkJ2OWZBWFlhMmRvSU5YS29EKy9XaGRuMFhPbjdiQk81WnZ2TjRs?=
 =?utf-8?B?RlJqQVMvYTFHNDArRThra1NuUW0rWE81ZkNETVFwK05sNTlwVVpZVlVTbjlt?=
 =?utf-8?B?NzJZdldtSkNQV0lIRGZzMERvaWRGSEQ2NGxIczRoOUZPSjl5eEFWcEEyeHdn?=
 =?utf-8?B?blNYMjlMcS9SRGYwQUdRSTJmQVVJU1IrdDRZOFJ1K2dJakZDN09XYzA2aVln?=
 =?utf-8?B?bllwb3FTVDZqaENlZjU4WThpQkJWcEJXdmFlbG1zMjNpZ05Dc2hyeVd5M0sz?=
 =?utf-8?B?ZHcrNDRTSitLRWdhTFROL014TkU3SEhseUNwdTVOOS9QK3VMZkxBNE0wUVU0?=
 =?utf-8?B?ek5LTE5IaiszRFRlNWdQVkNDb2JjRFVzNUdXdytjcTNNSUY3dVFjR0xFb010?=
 =?utf-8?B?QkNEaDhoOVdaWE1HN1dEdUMzZDZoSFRSNVVUUlpRTURWY3UwaVk3M0I0dGQ3?=
 =?utf-8?B?V1RhNjdtNGNFOC9CSHFpNU11R0psOG9Xc0NUQXhlTEFtcnFndFJWRFlWV2Zv?=
 =?utf-8?B?VkpVaHlIUmJPa1IydEs3UXB3M2duY0NDbTBGQmhvRXBxV0hCaWhuc0RMVG8w?=
 =?utf-8?B?ZE9TQTN1cmc4V09XQkNwN2ZzNDI4Qk1HbXJ5c1ZTUVpvWlM2aVNwbjU2SXhB?=
 =?utf-8?B?N1pCd044T2pEb3NvK2EyTEYzUm1VZzFoaE5QMjZyVktqeHY5RG9qRmlpN1ZV?=
 =?utf-8?B?SXo4dko3RWFHVjJNb3YweVdRK2FmejVncE80NXRkMGY4UEpPaTZQbUgzNUtr?=
 =?utf-8?B?aGsxb3ZGUmZ1QlN6ZVhOYTRaK3d1bk41RUoxQU1aSU1kdk5iTXkvTjRnQW1N?=
 =?utf-8?B?MWNIOFVWSTdCdVZzNFIyU2ZQYVZoS0d3YStjY3d1aGxtRVFkeDA2cnVIT2dG?=
 =?utf-8?B?c05CUzFZRjRZRHIzUm1nOTlkWG5QbEJYZUdBRWttZU9KbHlZZW5OUjVuMVBn?=
 =?utf-8?B?NWgyaG5pQ29ENVVyeFM2cXRDNEE0cFZRdHRBRFBrNGRJWDU5SGV4SXp1WEl4?=
 =?utf-8?B?S0dybWV3QTdwQy9VNHJvZjFxMmRDVkVsbEZqVGR6eFRqa2IwdWsxekpEU29m?=
 =?utf-8?B?b1RQZVNOY0tjUUJxSmxNVWZxMWFGb3dSS3BqTCtSaXpQL21HYk9zblQyMklL?=
 =?utf-8?B?cXFFWi9FUzUrQmM4a04xUmRyaUI5eEF2Vk5XS1N1L3R0QmhpZG91YlB4ME04?=
 =?utf-8?B?cCszNjg3ajdMUERaVElzMWNqV3UzNmdzNVJOSWJUZjlycjJXWHVwNnJMLzN1?=
 =?utf-8?B?YzRFay9DdWxFdWFXcWlkZ1M2RHYvNU1zaVhBWEt1alBwb1lXTlZVZEIzS01M?=
 =?utf-8?B?UU5lSUxTSFJnVXp4ckhlYzFaMHAzS2R0UnY3YU5GTWpEM2hudU9KcVR4YXhX?=
 =?utf-8?B?SWFnTEo0TERzbFlISFVoR0ZJajhKcGNBb0ladFNPZWtHWG53bWJ5OTZacFVv?=
 =?utf-8?B?VlVwc1FRdFV3dkdYeWI0VzhmNStlQkRoME9Ed2xrRWdWSTFGTXY0SEpsaHk5?=
 =?utf-8?B?SUpBUk4ybmZLMnRCb3NPY0FRbUE5bnN0dksvRzVvbnhWMGg3dDBkcStVT2RD?=
 =?utf-8?B?UktoMkd3SVh6RXQranhmazBVUE1nbzVXSzZaWktUeHh6emkvL1JTd1Q1MzhP?=
 =?utf-8?B?MXJrUlpmbkFaK0ZCOEpNWXBxUnVRV1g1b3Z3S1RiZGkwanlsaGl5SkhqUDZo?=
 =?utf-8?B?N1BJNWZVM3J3UHhYNk92aFRsT3FncWM1bUlVQkxZS2k3c0FKQ3VlMlRCeklo?=
 =?utf-8?B?TlhNeUtEQXNuVGd2djZZYldjYzZPb3JUdUsyWitCVkFyVTdaZ2hsUGVwYjdx?=
 =?utf-8?B?Y09MbmxlelNZNXA5dW95Tjc1UUhrZmFMOVVmdm9nRnI4UjhUOXJKT2hvK0p3?=
 =?utf-8?B?ZjlIM3hQTlpFaEhsNGg4dTA0Z1JSSFhScGgraW50OExHTnY2TWNpQ3U5U2M2?=
 =?utf-8?B?Y0NEcmYycUJIV3ZLMGxvY050cGlHNGZ1VXJwNXpWWHYraURCSGNYSElhUnNt?=
 =?utf-8?B?Q2FVM0YzTE80cmVDaGRWc3g4Sk9vQVFNQXY4SU1MM0FGWlVkNlpLU2NsVVBS?=
 =?utf-8?B?TVJ3OWUvanQwbmF0akhVaUNoL0pyMDIxMHU5RnJUSWh3d011U0xpWERNSjRY?=
 =?utf-8?B?MmVIVDlwSzlGMzBkSEtHaUpTR2RyTk14d0tWNmFnRTVjbFhqL2crQjR5UlJ6?=
 =?utf-8?B?TzZTREpvcFdkajBiS0RxY2MrTkJQbTB2L3I5ODR1ZkcyaUZMT2tXbWFjUytq?=
 =?utf-8?Q?wbwf1iLgoyEAbtEENQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d832d20a-c1ae-4300-7372-08de59a5248b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 10:58:15.5364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNTdy3xn/S9FSpao+FCAsnVzsEte8w3M6wvgOHDPcpI/MVikFd5Tv9yc7nTOd+1Mmf/ojDbzcvupn5xpx4v1YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308



On 22/1/26 04:09, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 12:08:19PM +1100, Alexey Kardashevskiy wrote:
>>> I mean that the HW requires multiple SW controlled tables to all be
>>> sizes must be matched. Instead the HW should read all the tables and
>>> compute the appropriate smallest size automatically.
>>
>> Not sure I follow. IOMMU table matches the QEMU page table, it is
>> two tables already and IOMMU cannot just blindly use 2M PTEs if the
>> guest is backed with 4K pages.
> 
> That is just because AMD HW can't handle it.
> 
> For example if you look at the CPU when the guest S1 page table has a
> 1G PTE and the KVM S2 has a 2M PTE the CPU doesn't explode, it walks
> the S1, walks the S2 and loads a 2M PTE into the TLB.
> 
> This issue with the RMP is no different, if you get a 2M IOPTE then
> the HW should check the RMP and load in a 4K IOPTE to the IOTLB if
> that is what the RMP requires.
> That the HW doesn't do that means you have all these difficult
> problems.

Got it. Interestingly the HW actually does that, almost. Say, for >=2MB IO pages it checks if RMP==2MB and puts a 2MB IO TLB entry if RMP==2MB, and for 4KB..1MB IO pages - a 4K IO TLB entry and RMP==4K check. But it does not cross the 2MB boundary in RMP. Uff :-/

>>> I don't think you need hitless here, if the guest is doing
>>> encrpyed/decrypted conversions then it can be expected to not do DMA
>>> at the same time, or at least it is OK if DMA during this period
>>> fails.
>>
>> The guest converts only a handful of 4Ks (say, the guest userspace
>> wants to read certificates from guest-os->host-os->fw) and only that
>> converted part is not expected for DMA but the rest of 2MB page is
>> DMA-able.
> 
> Yes, that's very true!


on the other hand, without swiotlb, dma_map() in the guest for untrusted device is likely to be lot less than 2MB and going to share another handful of pages but this activity is not that rare compared to my certificates example. If only there was a way to somehow bundle such allocations/mappings... :-/


>>> So long as the VMM gets a chance to fix the iommu before the guest
>>> understands the RMP change is completed it would be OK.
>>
>> The IOMMU HW needs to understand the change too. After I smash IO
>> PDE, there is a small window before smashing an RMP entry when
>> incoming trafic may hit not-converted part of a 2MB page and RMP
>> check in the IOMMU will fail. That mentioned above HW+FW engine can
>> stall DMA for a few ms while it is smashing things.
> 
>> oh but I can :) It is a FW call which takes a pointer to an 2MB
>> IOPDE, a new table of 4K PTEs filled with the old PDE's pfn plus
>> offsets and then the FW exchanges the old IOPDE with a new table and
>> smashes the corresponding RMP, and it suspends the DMA while doing
>> so.
> 
> That's a completely grotesque solution!
> 
> It violates all of our software layers. The IOMMU and RMP are not
> controled by the same software entity and you propose to have a FW
> call that edits *both* together somehow? How is that even going to
> work safely?
> 
> Can't you do things in a sequence?
> 
> Change the iommu from 2M to 4K, flush, then change the RMP from 2M to
> 4K?

Sure we could unless there is ongoing DMA between "flush" and "then change" and then DMA will fail because of mismatching page sizes (that 2MB crossing thing above).

>> If I get it right, for other platforms, the entire IOMMU table is
>> going to live in a secure space so there will be similar FW calls so
>> it is not that different.
> 
> At least ARM the iommu S2 table is in secure memory and the secure FW
> keeps it 1:1 with the KVM S2 table. So edits to the KVM automatically
> make matching edits to the IOMMU. Only one software layer is
> responsible for things.
Does KVM talk to the host IOMMU code for that (and then the IOMMU code calls the secure world)?
Or KVM goes straight to that secure world?

Is the host IOMMU code aware of the content of the secure IOMMU table?

Does 2MB->4K smashing exist on ARM at all?

(I'll ask these on the IOMMUFD community call tomorrow too).

> That is *very* different from saying that kvm or iommu has to go and
> reach into the other subsystem and edit their in-memory structures.
> 
> Currently kvm has no idea about the iommu.
> 
> So if you want to make use of that you have to solve this fundamental
> issue that we can't issue the FW call without some security
> synchronization and locking between KVM and iommu.

This is true. Thanks,


> 
> Jason

-- 
Alexey

