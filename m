Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E1255E34;
	Wed, 28 Jan 2026 01:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564625; cv=fail; b=rmV+NDPX2yMwjaXy/N3Baya1uxBJmkIfLWVA9drtNqHqvAucPf1ILmzKx6sFQL/O9EsJfvMsNWg6VoiJQNNa5WOyEHAg379HBdy4YWFE9C40eDxibyhSXFI6ML0bgU8+0bGmBQNXSHIU/1pD6dT/ARN36KgCorNcCieRzMOMDSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564625; c=relaxed/simple;
	bh=9n/J9hnB7yVhs6dIYXR+2mbSeVwrvhsvNF5S+R+g328=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f2rEoTWSfQIyqQ5ij00ZOlRM57aFY0KPNYNFsh4UsjEyGAa8Sg3oAsHC8SN4NTj9NdjWCnDgcjQ19NFKgSjOhvi2ziSoqPXv2yArJT90uVckDQ6pNDWoJOkmdwQOsRb63ezuRyKqtAY8cuO2CbtzfRwyVjMv/uHuXtixPuZqJD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fsd8sE6w; arc=fail smtp.client-ip=52.101.53.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fsd8sE6w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBvM1cbjXnp1W7TAE/ZtXPsJbzl3ZDYFtWZ9H+/06QVlsb6NAWNpAdWIHYGVK6O9T/TbjNvXtEje2/EoOQv50q9G3eSQQ30s5UY15tb8AtWdDjpn+UG8i9/IGE5PNrEnMXEBbmGnwz4u+fbLUFTsbsp1zurN14jk3zVA0gMb56WEVaq5E6X0JzDS5bUAGLCOMRMGAwyrh41qGQmXnAtU0ibOdS5iNoVl0YDobH7Aa3ioLdqIIKn3y4yGcI6e5SHWuyUr1dF1PKy9mkFtwtt34tvbnkrcfs9aXGFZgxo81QvwIFk0D4pPn83EhIComn+o3yS0czBZK63vl15+AhKjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBdNms3tRhDmyjMiwyE/6xPyZlxwwqJGCjmAw0lJ3N4=;
 b=pbyN3zCjmsNONdkAdRHnuRertGQknRIiwlNqucUhmMbf3o9Lbtoo0WkqdEyvl78oEW1Ii4FAFlzL6VnYuSoQUSykweRrF6BBmVwTetLC7hpQb246zXhM0RpEvYGi6YVTgRG6tFPLM2cLsErzFUDATn+j/k6gAi8M1rG7ukacRFN8fRYHJE38DX5X6fZAuhEdsWuY1WkAdNtyJ/XuKfF1UmGEGGYVCub69wpeO9GJlcVSmXhs3bX4jnSAFaekKrsMb5rbTLxohsWhcZlk1WiZxtEpVY4wUyTxH3YbCkMOIK9iyknnZ5/cQh8rKcejuJis4ws4ckbhkVSmvzrh5XlstQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBdNms3tRhDmyjMiwyE/6xPyZlxwwqJGCjmAw0lJ3N4=;
 b=fsd8sE6w1no/zccysBdYMWhiDTFXw+7QtA864lDcfyXM3EhAece1/M10KOKxpfi6o6PI+VvFOmmycYsSt7OmHA4jd+oKQjhCnqi9UDDeysZV7CORLHmISX1vhNyYyFlCRMY1fTqZDeSP6uvn3U5+rW2ftv9wFg/1Vey0Xk5vZsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB6462.namprd12.prod.outlook.com (2603:10b6:8:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 01:43:38 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 01:43:37 +0000
Message-ID: <cd7a2d11-bf65-4445-8eec-df9ba7950128@amd.com>
Date: Wed, 28 Jan 2026 12:42:08 +1100
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
References: <20260117154347.GF1134360@nvidia.com>
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
 <20260123141413.GY1134360@nvidia.com>
 <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
 <20260127142512.GD1134360@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260127142512.GD1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0169.ausprd01.prod.outlook.com
 (2603:10c6:10:52::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: 95495762-1f3a-4dfb-3575-08de5e0ea7f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2Fibzlwa0NzVWF1ZE9RbU5TUExCK3I5Vk5jTGc1Vnd4dmMzVmYwSVV3ZER3?=
 =?utf-8?B?UGxXL0plbkhZbmNuaTZ4UTgrOXArREU3bjlYa0ZDQ3dxTVNsOENCT01yZStk?=
 =?utf-8?B?YkNnRnVNTldGVjVXWnVTY0NVRjlYZkNPMkhJQnZrLzEzbGxIRkVDdFk3aUF5?=
 =?utf-8?B?U080TERMbXcvQUxOMFd2N2hheWF6aUpucVRjM0dnQ3o4VXIxVHNJMVlDSERS?=
 =?utf-8?B?a3FKU3BuNXQ1K2Z6a0JHYUlmOHowbTJ0MGRvVnVMK3llb3M1K2NteEpPNzNE?=
 =?utf-8?B?TjZkU2hYWkFCSkZwZDJBcW9oaTArK3RnZzcvd1o3TGNNbHBoK1lmVjJzWk1I?=
 =?utf-8?B?Vkh5VzZiMzdxQmFEa01DTHNuUlh5QjQrenJqNlJ6Z2k1cExwVGd3OUJoQkky?=
 =?utf-8?B?VHVYVW8wMVo1L0traGFCMnlSQ3VST2tnL3A5K3VHSU5RNkRMeWJsakRITG5L?=
 =?utf-8?B?a2dwR3ZZK3lPNmZ4dFU4ejlUU1pMUFZtb0ZJM1hGSTJjNTdxZWpkRFU0c09i?=
 =?utf-8?B?Q21zZFVVZEJpRlZVYk9wTldPdlh1WEtZQkxMRmZhenh2OG90SEQ0ZWIvSDJu?=
 =?utf-8?B?ZWRyVnlJRWRqRFQxUkNpeWJ2TzBhNHpvOVVwSktiR3hsZ1J1ZTBVQ2swYkpR?=
 =?utf-8?B?aVFiUUtRbmRET2pzR3BHc1lpc3ozK1N4aE92aFg5eWdyMk5iYkVMSHBhakR2?=
 =?utf-8?B?MGZzLzMvaXV3MUxseDZXeXlYTlpKaFJ6ZFdxMEE2T3c3NTVNNCtsM2hKQ09O?=
 =?utf-8?B?OWhGckc3RXBubFJ1d1EyTUV0RjgrY2doMHc5YzBobjFUUWowdzNmM1Rod1lr?=
 =?utf-8?B?Mkkwc0w4ZWJqdnhBYTZnWjFEQnpDWkFJQ3U1OEVxRTQ4MDN5d3VJSkdvTy92?=
 =?utf-8?B?Qmp6NndJc20yK1lqZG9EMDIzaGs3MDJFRzlCZmIydmZCOExmSEFoRkJGUlU3?=
 =?utf-8?B?Y3QxTkV0N2g4bjQ4eVZ5Q3JiSVYvd01zRmNPWHFGdVVkVTNBc1ZJMWljdWZx?=
 =?utf-8?B?VFVseURERlJYc2lNSjhza0hJODVScThjSDh1YUN4Z3JBcG1TSmxDdFNJOTNi?=
 =?utf-8?B?bTVCbHNneGtYTWVwdmw4RXlqck01ZWpVVWdxYW5NZ1hyMHN0eWRJNTkrL3ll?=
 =?utf-8?B?TUljZG5waGxTUWxHYUlTR3p4cEdDemt0RWRpTTRaT0VrOE41aFM2bWhkMzd3?=
 =?utf-8?B?OUpKaHhXdWpNcFZFOVE0RS9mY3AxSmFqaE4rUzZxbUVWS3dRRFo5bTJHTjZn?=
 =?utf-8?B?ZWdFc0NLMFlIcEgvVThJTW01OWh0R2x4bzUvc2YrN1Y5RTM3ZTQwNklWSGxR?=
 =?utf-8?B?MGVZRGtRR3NEZ0FqUDRMZ2dNN0pVaDBSRGJza3dLeHg1cElLV1FHMWl3N3RV?=
 =?utf-8?B?VXVNZUJUWlQ0VGZUdkxVdWJ3OE9sTUtTSThGTGdsOUFKc0Y1N3pCVjkwT1pI?=
 =?utf-8?B?ZlF5ZTdjam55ajNRUFR4K2NyYjcxUEQ5OHA0bzhyM1N5UDZwWDlKT1ZYRktV?=
 =?utf-8?B?YTRNRzcvUmthdzhPS2UzcHVDNkViZVlXNFJoVzVsWWlzclBhdk03OHVybkxK?=
 =?utf-8?B?eWZBVWsrSzBoUVNtYUhsRk4wUFN4V082MXlQMFloNDEyMEZ4bTRjRDI5RjBZ?=
 =?utf-8?B?d1lsOG02V2pXdVliN3VNR1YzbHl5UzFtYjNmdXFiNlltYndsTE00QjZSdlM1?=
 =?utf-8?B?czhUdDJ3OGtmc0ZGNzZXVjd6WGVGTC81UU9JRFNXbDBzUmF4VzVMMFhWWkFo?=
 =?utf-8?B?UG5HSjBOYlNaSEVOTW1IZGZkVVBVV2FRY1FubFA3NGx6Q1ltWCszdTV2SUN6?=
 =?utf-8?B?WWlNOWFYN2pPMkhWVDFLTEFuMWMzQnRPVnpqNExXeHFJZlFWVEFPV2NkMzlM?=
 =?utf-8?B?Q25aUEpaaEU1Zms4L0l3anFXZEFRTE4ycmJlOThqZVhIcTFvQTBRckdEWHN4?=
 =?utf-8?B?ZENTTlNOemlSTXlXRkJLUzIwelNXYXk5WE1WT3dZOU1NQ1gzd2h5RnllZnRp?=
 =?utf-8?B?UGNwODNDWHIzOHdRMUNmV0p5TnhtWHJhWFF6ZmFLejRZTHpMR3pVaStmRmpU?=
 =?utf-8?B?WThhSlprTVFNdUdRU29HbW94VWE1LzVhR2RDL1NlMUp3S0VqZ3liWHpoNVdi?=
 =?utf-8?Q?qT7c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXNFa1Z5MG1rQ3oxZVVETlBJMURBWGwxaUloUEJBUHgrMVRXYkxhQjA0ZUNp?=
 =?utf-8?B?OHo4YnVlT2RFRGpjUFRqUWF0NEJuUlRlMFo1ZFJLUUhXWGVSak5QeHh5Y3pv?=
 =?utf-8?B?L1J6MnVONE16N05UcnA1K2R0UnF3NlIyTzNkaDV2c1JCam5NNVRTeng4eitB?=
 =?utf-8?B?ZUxDWGtHKytTZGxOQ2U5YlhMRytKUC9PWmd5UGlobGZzOWd2akdLSTFoQjh5?=
 =?utf-8?B?T1VFRjJTa1Q5bnU1THNCTWVoa0pYMHYvSDlDVDFGNUxnaGNkUlV4TStwSnhi?=
 =?utf-8?B?VGsxTG1NWW04elQ5eHphZ3VvNUwzYXpTOVViTjNYdngzN2wyZTZkT3ZPWGZM?=
 =?utf-8?B?R05DT3RwTGRseWgrNEdpMkZqL0piZk0wa0ZWelF6MmJTZW1EOVdmcGxTTk9H?=
 =?utf-8?B?ODNobWRzUmMvbmNMMUN5NC9CRkZObjd1ODBNaGx0eG9tZFJqK0lDQ3hzWnZJ?=
 =?utf-8?B?YjNJckc3aXRNMVFmaXJmdVlIK2J5UjdyMnoyamFHZ0xpR2VBazl3S0d5R1kx?=
 =?utf-8?B?L093bjBSUlZWaFdzbmRubFA3cEo0OWpSRGdOaTV0RHJ0SWlVQmYvZVhzZjVC?=
 =?utf-8?B?Y3ZrRXJEbVo5d2ZLN2U3REJMOUVtLzU0ZkJPZERjMWhLSDBXNVY3eERXanpL?=
 =?utf-8?B?eXlhSEFKenJKNm0waG8vNEsyZG5zSlFrSWxSSnJyVDlZRnZBMVo0Q2IvWnJR?=
 =?utf-8?B?OXk2RVpVay9JYWZFd1pKaXlLVnZ1aTBXb1dITm5zM0ZWMlpNSjE2Qml1bnVM?=
 =?utf-8?B?SDdVNlVNaTF2MEtEU2tWcmorQVRPWnNTQ09rM1NSQUZKZVlvNjk5ZzdVdWg2?=
 =?utf-8?B?RzhHU0VvVUFCdTVNd2RpY2szaTA2MXEzNEw2c1RqbExML0JJckpRajNUd0M3?=
 =?utf-8?B?RUdBN0k3MmFEYXhpR09rSW9OWkt2cDJ1SEdiZVd6UjFINk51c1I0bW1uQXpE?=
 =?utf-8?B?V1FRVnRDdnZGejc2OS9ZVVBxVFdyS3orMjRiTnJqbldNK3pIMzF3RlRhNmpC?=
 =?utf-8?B?RndTWGdnQkNQQndMb2dXdnpORjVZNFEzM3NaaTRZUGs2bWhGRzA0VTR0b3FR?=
 =?utf-8?B?VWRHS1lWdStvMStHZmlpRHhxZ2VYNDd5K1hDTlpWclc3WGtSeGdCTDljZW91?=
 =?utf-8?B?Mnk4YzR0ZUtPci9TU0k5NUF3bzRwdk1RaFdVVzgwc0pOQ1ZNZkFqdE9ZWHhh?=
 =?utf-8?B?QzZpa29XTCs5TzgxU3o0bVdhOVdQUU9wZXhhN01OMXhVRjNUR283TmlydHU0?=
 =?utf-8?B?YlVCMWpQZFY5RWRxVFFobXlqNjBJS1ovVWNwRllrdW9jbUpPWlE2dVk3T1A5?=
 =?utf-8?B?dkx2V2NYd1oxaVVCQVpWNFloR1p1TGs2SEFXMFBtaEpScFpPV2dWcEpkQ0dC?=
 =?utf-8?B?cGdLU3FOZTluMDRUd0VTSEROVFV1NGtzbmVWeDJQRGYzSmdSYVN6VmhaK2p6?=
 =?utf-8?B?VDRqQ0FSQlF3OXZ4N3hTQjRaVjEwZC93Mk5SZDBYa01wVVpSTGZoRTV5UHRi?=
 =?utf-8?B?VWJBdy9DNXJvUE1zU0ptYXpPM1o5NWw3VUs4V0ExelpSK1hpdnlWb2pORUg3?=
 =?utf-8?B?d1lQYy9CaDVPQWt2RUVFNitoNGZDcVNETFd2ZjNpem9EclpVVCtkTjNkQVVZ?=
 =?utf-8?B?RlE5anA2VTJ2M1ZOeUM1WlZpNzNCbHlMMXo4YjFLUytmU0FtODVrUytaa2tl?=
 =?utf-8?B?WG1ERkluQkF5b0V5ek9sbnBxbFRxQ3dUUmlYc0kwTlQxRGI4d3lncmk0ektF?=
 =?utf-8?B?cDJFQkNOV0xSMzhRRFZ0dEN1Misxd3BBb0FMWGR3YWVqdk1vbW8xT1FMMzVN?=
 =?utf-8?B?cHNtWWQ1R3N6UXFMVGpEZk5TVXZWSndtUnkwT1BCUDBpZVBodkRuN1F0MkJv?=
 =?utf-8?B?UnlUdnZNV0hWUW13dHVpRko2bnI5MkVkZlF0bWhEeitaMXNtdHVkSDNZN3h6?=
 =?utf-8?B?NllSTnkyOTdPRDlqcGdyS0NEV0VyVURmVDRSY1JvNmNMd3lyeDZrb253NWVF?=
 =?utf-8?B?VDB1a3NleGlzYk1TWDFKOGVNR2xwZ3dkNGJ6MFJZeTA1MFVldkhxYlk2VFlw?=
 =?utf-8?B?TWMrN1RXOUtxcVlUa05LK2p4dk96cHZOMEpGSVVqZ1hOaHNFUFVlNjlpMDBn?=
 =?utf-8?B?VGNGcTFzM25uclVPOUJDbjRCTTFCR2Q3eC9mN0I3ZndQL3JhdERzUk5XWERD?=
 =?utf-8?B?KzdvRWdnS01UUGErTmpBbVA1RHRtVTBlVzF4Q2tUU2NIbWRIbzRzQVZwR3Fk?=
 =?utf-8?B?clAxOFFBRWx4V3R0TVBzZ1ZhRFoxUGpaM1lzdGxjMTNOcmZiUkJCRzJSNFJI?=
 =?utf-8?Q?6Ao5ihDlzMC+FbkxW6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95495762-1f3a-4dfb-3575-08de5e0ea7f9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 01:43:37.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LN+WvBs+PTHqYHCay7PVEf/NokEAJFO3AlvcrFkl7xLN1N+v+UNelWNZSNBBTZcfH/ThKqVv0Twb4qIkD9OdVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6462



On 28/1/26 01:25, Jason Gunthorpe wrote:
> On Tue, Jan 27, 2026 at 07:08:39PM +1100, Alexey Kardashevskiy wrote:
>>> Oh so it doesn't actually check the RMP, it is just rounding down to
>>> two fixed sizes?
>>
>> No, it does check RMP.
>>
>> If the IOMMU page walk ends at a >=2MB page - it will round down to
>> 2MB (to the nearest supported RMP size) and check for 2MB RMP and if
>> that check fails because of the page size - it won't try 4K (even
>> though it could theoretically).
>>
>> The expectation is that the host OS makes sure the IOMMU uses page
>> sizes equal or bigger than closest smaller RMP page size so there is
>> no need in two RMP checks.
> 
> Seems dynfunctional to me.
>>>>>> ARM is pushing a thing where encrypt/decrypt has to work on certain aligned
>>>>> granual sizes > PAGE_SIZE, you could use that mechanism to select a 2M
>>>>> size for AMD too and avoid this.
>>>>
>>>> 2M minimum on every DMA map?
>>> On every swiotlb allocation pool chunk, yeah.
>>
>> Nah, it is quite easy to force 2MB on swiotlb (just do it once and
>> forget) but currently any guest page can be converted to shared and
>> DMA-mapped and this skips swiotlb.
> 
> Upstream Linux doesn't support that, only SWIOTLB or special DMA
> coherent memory can be DMA mapped in CC systems. You can't take a
> random page, make it shared and then DMA map it.

Well, my test device driver calls dma_alloc_coherent() which does that - alloc + convert 4K.

>>>>> What happens if the guest puts 4K pages into it's AMDv2 table and RMP
>>>>> is 2M?
>>>>
>>>> Is this AMDv2 - an NPT (then it is going to fail)? or nested IOMMU (never tried, in the works, I suspect failure)?
>>>
>>> Yes, some future nested vIOMMU
>>>
>>> If guest can't have a 4K page in it's vIOMMU while the host is using
>>> 2M RMP then the whole architecture is broken, sorry.
>>
>> I re-read what I wrote and I think I was wrong, the S2 table (guest
>> physical -> host physical) has to match RMP, not the S1.
> 
> Really? So the HW can fix the 4k/2M mismatch for the S1 but doesn't
> bother for the S2? Seems like a crazy design to me.

S2 is controlled by the HV and RMP protects against wrong mapping of the guest physical memory in that S2, RMP is a HW firewall.

> What happens if you don't have a VIOMMU, have a single translation
> stage and only use the S1 (AMDv2) page table in the hypervisor? Then
> does the HW fix it? Or does it only fix it with two stages enabled?

The HW translates a DMA handle to a host pfn, and then RMP checks if that [pfn..pfn+size] is assigned to the correct ASID and the page size matches and the gfn matches.

RMP does not check S1 translations inside the guest, only S2. RMP is not fixing page sizes or anything, it says yes/no to the access.


>>> iommufd won't deal with memory maps for IO, the secure world will
>>> handle that through KVM.
>>
>> Is QEMU going to skip on IOMMU mapping entirely? So when the device
>> is transitioned from untrusted (when everything mapped via VFIO or
>> IOMMU) to trusted - QEMU will unmap everything and then the guest
>> will map everything but this time via KVM and bypassing QEMU
>> entirely? Thanks,
> 
> On ARM there are different S2s for the IOMMU, one for T=1 and one for
> T=0 traffic. The T=1 is fully controlled by the secure world is equal
> to the CPU S2. The T=0 one is fully controlled by qemu and acts like a
> normal system. The T=0 can only access guest shared memory.

Does the T=0 table still have all the guest memory mapped (with the expectation that what is not allowed - won't be accessed using that table)? Thanks,


> 
> Jason

-- 
Alexey

