Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E704169ACA
	for <patches@lists.linux.dev>; Wed, 29 May 2024 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716973191; cv=fail; b=gt1K/vNBhng6dEaZ2YXI8orN3qcpetAI4RcJD51e5Y5ammnqIVS8plUedFJk7kRHl9C9k96B4Y1d3M7pcAGyo276D5e9E8EsQ7L2Y2lhwULfxy6dhNpfov53d8qoI8EduSb7azqPIk64/egIhaQ2Y0VBuq2wnsFnYoD2D+9cRgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716973191; c=relaxed/simple;
	bh=m933WuFvot2rizLIc8GNS/E0ASCQDO468lNvnzMmqfc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UFscfnO/ULq7NgDkt2jphhsUcILHqxpllPiUfycfGIE9zpNxPg9/KxE89YKAjV35SIYVIoTO1pZc8A3lG/hJCoFjaVTlYu3m7jmVGbsWH7U5mKU15XqFdwjbmLFLOTXn+6eZdkKj/JuRXUHaUNqVLlMWaGXLk2fWL0nGKRA6W3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jt7oy3UW; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jt7oy3UW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7dx16jmiCbTB9csQYsc/VsJLzOQxwHM9AdCgvTtxRtte2U7HalwB57IxiD4l0muy9tXrNL/KEPNdvIUyjq0fI+G6ZShm2jj10FqFS4/vhwYVoV7fta2TnzLHdEJEvBgVJITbDFu7VryF1bRf6FakG9qeHZDhHt/7HH2uN5A7TBs4LFb0/0OwW1FgOC745G0LNXe0ER1HBF10zbGAkbPgDAuVkcWY7GCVEl1vwZ6kAq7VknZ4TMwGaZ7qVBIIdp/ImRb9rW+bKJEOH5ssdtKTcTbhaV90aSeYL1z0EJ8OFlFCR/ojKxCqlbNR/pBqSowiL1zXLuPj67HC9MrOfIpzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLM2ML56ZPkZS0JIkv9IvZiO8UljuL+GHQQ4S4Pn5bk=;
 b=hxv2A+beLJbe1Y6fu4ShK3KRPUm8qEy19zwJmk5ps1DKxbrSzg8XVZOVppoahQN+fsiZToYNtv1yzj/JuWKXgSf66cpLryj94YNiec4F6FBjCC8yA0tb03m3nndedcBhjFKQB1JLdUDObTzLYdgRPEz24ZmlGXukevxEe+nxBG+QzMlVnnSKMSmlW6kmA4zF6bk5ZFxnbMYFJsypyWIEeYxQrQ3nW+h29aNYbdmVdAsnlcO0zLVmnzDnwAcZ9qsj3hmIu3K/OfhQXSXKCuyukheqoXttTqGujQcR1M9oYUDYQ0kMIci/naDMx3xD59c6s61OMb4XKDNNHtKjx2aKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLM2ML56ZPkZS0JIkv9IvZiO8UljuL+GHQQ4S4Pn5bk=;
 b=jt7oy3UWiFPV8IxIkohPoxKpnKb3izIKymp2tgeV2jkVtFECG8sbID+ZhyKgQ/Tvx+krRRp3Rsjkz3Jf2JsfDX9VYV1PigBlof1Vjc2mZ0tXgQ4GWJb9N/dFfBcVU/wvInsg8+OJdVAgK6AykewJ5POpdh2KzEWUQnrz7VchrrZcSJNTWYaGDtED8XuTJqd2CmnROnzCv0fTu+K87ln3iy7DTZ18qIbIyKe2YBXsJY9WjSNJPnBuqGcfXYg9XjlK7xyS1EDY4k3o0r9UiERSqtC8PNx17lLDwyFbk1ioZWj5cfXUMHZxec147qHTTP2puefPRViEFr6Q2F8BIXT/0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SN7PR12MB8769.namprd12.prod.outlook.com (2603:10b6:806:34b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 29 May
 2024 08:59:43 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7587.035; Wed, 29 May 2024
 08:59:43 +0000
Message-ID: <58fa929b-1713-472e-953f-7944be428049@nvidia.com>
Date: Wed, 29 May 2024 09:59:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: NeilBrown <neilb@suse.de>, Chuck Lever III <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
 linux-stable <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck
 <linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
 "patches@kernelci.org" <patches@kernelci.org>,
 "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
 "pavel@denx.de" <pavel@denx.de>, "f.fainelli@gmail.com"
 <f.fainelli@gmail.com>,
 "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
 "srw@sladewatkins.net" <srw@sladewatkins.net>,
 "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
 "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <> <0377C58A-6E28-4007-9C90-273DE234BC44@oracle.com>
 <171693366194.27191.14418409153038406865@noble.neil.brown.name>
 <171693973585.27191.10038342787850677423@noble.neil.brown.name>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <171693973585.27191.10038342787850677423@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0533.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|SN7PR12MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: e5c2728e-688b-4820-b37b-08dc7fbdae35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elA1UURyd0d4V0c0alA5NStraGNjeGFGMnhqd1h3RDl4Y25qWHh1aG5MS3Z0?=
 =?utf-8?B?b3Bmdjd2anZIWmpUcldZeDBOQThTbnZYOHQ1RmFiNlM4L09yeWtsQ0VyZGl5?=
 =?utf-8?B?R2xzSkJUWXp0dzVaY0xMVzFMVy9GODRKYXQyUmpJaHc0RW4zYUpuUWpPMjlu?=
 =?utf-8?B?enlGNVdUNE1QcWcyTU5KaFh3eHlVSmRoYnZEek5nTzFVdHhGTi9rNWVJN29O?=
 =?utf-8?B?Nm5hZEFmREJqMnc3cms2b1lwSlMwNVZlQy85YmJEWktjMVcreXg2OTBtc3Zp?=
 =?utf-8?B?dlFZeGw4Ky9Venl4NnJRYVJJSGphZmNIbE5KYzdtNEoyeURUKzJ2NW1TZnpJ?=
 =?utf-8?B?TUNFYWRmWEU5NnB6ZVE1OXQreTNPOCtDZE9aMG5tZVQ5Sko5Y0xPdnJvTGVS?=
 =?utf-8?B?dXRVQ2ZiekVkNEVsMG9kQ3QwaEVXOCs3MjFRZWxPajZIL29nKzJhZHFLUWZW?=
 =?utf-8?B?Rk8vek0xMUFXcVI4cGFuaC93YnU2aW5oTkROaXo4SEZmTU82UjZoVnhFUWdB?=
 =?utf-8?B?WlM2c1NvVmhnc0NQeTR5TjB4d1J3QTFIeEhpUW9SNVpBNFVVTk1wWXZERHNw?=
 =?utf-8?B?M1NiSjI1TW83a09iNndCVm5lamtRbXo3SnBGRmJPazRVNHI4UHowL3BkZWk1?=
 =?utf-8?B?cE8weDQzNWhObW5NMjI3SGpqTGIvRXNxTVJSWWNQNHIvdng1blBBQzZhbmpT?=
 =?utf-8?B?aTF1Q1ZsUDNzZzhyQ2NZY2tTSnR4UEtPRGRzbGE5Nk1VTEQ5bkFtTHNDMnJL?=
 =?utf-8?B?YVV2N0t2OXRyZElEOFp2bVo5Z1dRVWhJd1B4WlIycThadTBzNlBmNWF5UXI2?=
 =?utf-8?B?aEkxR3E3SURUTEsvbHN3SnpreHc5T3NNNmtpSk95aGYyV0ViMGRiSEZ6eFVT?=
 =?utf-8?B?RVlxV3AzVkJJZHVqdGVoSXNISkRPR2twWkI4cEtkWXA2M3JIMiswaDZMaUh5?=
 =?utf-8?B?TWtOZ0dUaWVnblpHK0hGRlZXa1h6TkwybllrNis2dVBOU0ZEZWpQMXRMQnMr?=
 =?utf-8?B?QXhrRHl6TmdFWEhKSHA0MFM2RzJiNTZnS1MyZ2xQZ3NrRmIvOVk3Y3J1bzBJ?=
 =?utf-8?B?ajQzMXRhTTh3NXczS242Z1REQ1NqZXR4U3lHUW82alE3MmZ5L3BBdEJuTWp1?=
 =?utf-8?B?Q1grUTkvTGM3dHpVdDEybDlaN0xMeGdSeUhhdlVoZVlheFFhWlowOVlSMGVZ?=
 =?utf-8?B?bW1pT25vMGRUZ2pKK2tTRW9ISmVhV0NYUXBGdit4NzZrT085bkdxNWRoTjAv?=
 =?utf-8?B?M01hV3FISTlxTTZncDF5bHZCQVRTNjFHRFBmeWhWaWFhVXViRGhSek1UU05W?=
 =?utf-8?B?MjVXQWgyb1FCSW9qbmhybGppWk5OS2NHczFNdlpKR2lueEhmZHBaSW9tYlp4?=
 =?utf-8?B?RGhQNFg1K3hualA3SFhya1R0MnBPUWpWN3UzVHlsem1kdGFoTlpGKzVTNEtS?=
 =?utf-8?B?V0FtdjNYbGY0Yk10cUIzOW81YzZEUG01L3dKWTM0Mmk2SnVrM3FXRVRyQTBU?=
 =?utf-8?B?NXpJMmZkMFZFU2xNdXpQZ1piQmQzN1c4L1VEWU1BWXZpS0ZsL2xTZ0VwWGFM?=
 =?utf-8?B?Um5PRlJQMmc5ckZiWG1EQXFVdG1QZ0dUMUlCVVpRRXMzQlVMaUs5dDRMUmJm?=
 =?utf-8?B?Z3Bsam9XMGluUmsxd3ZJSXZ5SGdzTFpRUFM0TDZsb0NQdUVDZlJTb0dZc0xy?=
 =?utf-8?B?d1NhOHVXdkVNcVgzbUxpNFJiN1ZLcmxBRXNrVWcyZEJKc3pBQVprdnB3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUN3ZFRWRDlNMWRzK1YyMG5KbWk4ektnRjRKZVloVXpyN1o0VW84TEdJQXpH?=
 =?utf-8?B?RDhEY0YwNHMvWDNUMmpiakNCKzlwcFJWZFdxbzhMdmtJWW1zOHR2SWZ3eGNm?=
 =?utf-8?B?N2FGWnBzT1pkQTl4ell5d2dZVDlnenY0dnJrZFBHdStJUm55b29KS0tkclBO?=
 =?utf-8?B?L3F2TVVBS2ZBZ2RTbno3MHg2WkhtcXVIeUQyaVY5ZGh1Sm52ckdmVXNCQ1Bl?=
 =?utf-8?B?c0JValNuVGMyL0VOcm1TRStKcGxwbHVVeE0rRDFVTVZybFZEOFJGYmF1MVoy?=
 =?utf-8?B?ZkZmQVNmTiszbXRCV0M2K2ticlZLVlVIQWxOWFJlTXZYRXlqQnVKckc1M1hs?=
 =?utf-8?B?OUlSYkozQVdtMUR6N2tKODFPdkphNjlEaGthL0hkSkNRL050VU1kSHdHZnk0?=
 =?utf-8?B?clM3b0pCTXFrdW4zeTBjSmcvQ0k3dlpENjNiQXo4WEVGN0l0MkRiQkUybG9Y?=
 =?utf-8?B?eFhyL2ZFU1pYdlI5RG9RL0g5eTZTeFRRRE94MWNQVGc3SVMwYWRsT1BZdXBY?=
 =?utf-8?B?ZkRBTTB6dS9CcWpiYk9uQ3l3QVo3TW54VmZWbVk2RWlsVTYvZXJ6SjRvVEhP?=
 =?utf-8?B?MDBlNDVkcS9EMnhSdVRYWUZ5KzZZd3lzdVVUTWRUaVN6Z3BEU3UrdGFsODNU?=
 =?utf-8?B?SElUSEhoaHVabGtDbDA0L0pFb1hyVk5wTEk2bHZRZ0lNOGlubzFualp6LzM3?=
 =?utf-8?B?WGYvT0ZsRnVHS3YvWmx5K01wQ1AwSEpCbjZ4cFNENmVKNkYvZkFOamdjTUhm?=
 =?utf-8?B?MkJvbElNRUxOR0RXM1V1cS9lT20xampvVmNEdnhvUm54bUZkbnhESHFsaHg4?=
 =?utf-8?B?bnF6a21xNC9uN1pkSUgwRWRxSm80MTlkUmR1VXJxbUN6eHB1SnRnZFZUbnRj?=
 =?utf-8?B?T2NDT1lIL1FFZVQ2ZFhMR1V1QnRjLzNFb29PM0E2RVMyVUVkOHNDSmx0ZEJa?=
 =?utf-8?B?UTF2Zzc5MUtaSGR6OWNOOXdDTGUwMzFOaXRHQzZPM3E3dUFObDYxczB5WnRK?=
 =?utf-8?B?NlNLcG41ZnBvRGpPY2ltb0xDbXVwS0lWR0o2RG1ZYjFPRFZvR1ZPMlRLdWw2?=
 =?utf-8?B?QjB6SEl3K2xRUUEwTWhVQU1aNkVmL3RTNDJkU1hhMUhqTXJnSnNhdStBVjVy?=
 =?utf-8?B?Y3luK1lwOGpJa3piNTY1ajRVekUreUUzZnVKcWlaN0xiWWhaMTlUQnRIcEk3?=
 =?utf-8?B?UTU4NFBkZU4zVEdLMWhWMHorMmlob1pWZFY5RUgwdmtWQ204Wkx1Qm5GQzVm?=
 =?utf-8?B?QjZhNk9wVVViNk0wOTZlQU4wazYvYXpaYUx2RTl6SnFYaXVJZGRFdjRackNW?=
 =?utf-8?B?UnkrUlpWeVEzbEdraFhXSDVkZk1kVmovQ3o1UzJUUVJDZG4vUEN1V1dFYkJI?=
 =?utf-8?B?MngwNTZYWjFOUXJTL3UvNjRtSENFMUYyQ0tFN2IxbGxVQnhHQTV0MGlRWk9S?=
 =?utf-8?B?ZDVnS2NDaDczWTMxb2ExZDIyMjhWUVVEYlFiVWZsMTBFaVE5NXErVFBmSkFK?=
 =?utf-8?B?bDFQOFp6aG5UOUMwUmlpTmE4UmZQbWNvN29xWXUwOFhXcXBvREJRRE52ZU9W?=
 =?utf-8?B?bzhLZ3VrSmFtTXJ0WVk3YjFNMk56Qmo0VUc2V3ROQzJTVEIxMTdPeHRFQ1Na?=
 =?utf-8?B?amdlY0x3RnQ5aHNSS1RseHVrdS9NM2hwamtlLzIyZWd3bllRKzBiV1NTenlK?=
 =?utf-8?B?NFhCb1Qrd1pRSEkrcnVXUWRSb0JhN00vSHY4QWRkUDYva1Bnd09sV01POGd1?=
 =?utf-8?B?MW9CclJaU0xiSmtyRHpybHhqZlNCMFNuQ0J0UVY2bFpPcHE1MWNJNDFySG5i?=
 =?utf-8?B?WE80Q1J1NjZ6MlJmTGJ3TXFXcmU4b2N1Y0xOKzBxdTV0R2JkOTB4dnNrZ3A0?=
 =?utf-8?B?ak5ybi9jYXRQTnJuSEVLclBmZnVta1ZVQ3NxaU1tSktHU2ExZjBUcXBqdEVZ?=
 =?utf-8?B?NXhLWEdIUFBOaVp4VFhmREJJY1d2VGJFUWpSV0pJMVI0aWZFZENLWXNITjYz?=
 =?utf-8?B?c2NaL05Sb3I3ZlVYbHhWYjlqZGdQMWQxM1l3MHplTWlndzhobmpMQ294OGdh?=
 =?utf-8?B?bDZFZVhuS2lKTWRSaTVBYmNZNTMvcXgxV2FaVzhMNitNckZyRDM2VlZ0T2ox?=
 =?utf-8?B?Y2t2SzNJWHptbXVYNW91cWtNYkVCNnVLbjFLSTh2V1gxWDZJQXJEbmZvQW8r?=
 =?utf-8?B?VmdUdURFM2Jtb3czem5yWjlWMUl5elIrR2EwVXZiZk9YdW40dHdYQ2lyQmhj?=
 =?utf-8?B?SllxdEw2ejBCVlEzdEpWMGltNzNnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c2728e-688b-4820-b37b-08dc7fbdae35
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 08:59:43.0603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/KiCuF70CkCZz/BS8MbxgJECqdcMxrZZkuRCNEWMXY5y7gPgEol2BpBqZnGDr/sJiH1iJAvBfttodA3rkY+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8769


On 29/05/2024 00:42, NeilBrown wrote:
> On Wed, 29 May 2024, NeilBrown wrote:
>>
>> We probably just need to add "| TASK_FREEZABLE" in one or two places.
>> I'll post a patch for testing in a little while.
> 
> There is no TASK_FREEZABLE before v6.1.
> This isn't due to a missed backport. It is simply because of differences
> in the freezer in older kernels.
> 
> Please test this patch.
> 
> Thanks,
> NeilBrown
> 
>  From 416bd6ae9a598e64931d34b76aa58f39b11841cd Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 29 May 2024 09:38:22 +1000
> Subject: [PATCH] sunrpc: exclude from freezer when waiting for requests:
> 
> Prior to v6.1, the freezer will only wake a kernel thread from an
> uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
> IDLE sleep the freezer cannot wake it.  we need to tell the freezer to
> ignore it instead.
> 
> Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>   net/sunrpc/svc_xprt.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index b19592673eef..12e9293bd12b 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -764,10 +764,12 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rqst *rqstp, long timeout)
>   	clear_bit(RQ_BUSY, &rqstp->rq_flags);
>   	smp_mb__after_atomic();
>   
> +	freezer_do_not_count();
>   	if (likely(rqst_should_sleep(rqstp)))
>   		time_left = schedule_timeout(timeout);
>   	else
>   		__set_current_state(TASK_RUNNING);
> +	freezer_count();
>   
>   	try_to_freeze();
>   


Thanks. I gave this a try on top of v5.15.160-rc1, but I am still seeing
the following and the board hangs ...

Freezing of tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):

So unfortunately this does not fix it :-(

Jon

-- 
nvpublic
