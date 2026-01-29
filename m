Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012036.outbound.protection.outlook.com [40.107.209.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2FE4D8CE;
	Thu, 29 Jan 2026 00:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646828; cv=fail; b=jpcWR8UrelAU+VMOC7IKX0b81obB5ipxOdjnoXMU9g6keePwXI6aM2l/UyX/4bQdNoj5+nSmATMOiqKlHuUNF3tORO4sByiNsQ/URdiuM0d+cA2EfhoHoD2shT24tCFGm7a34Ykqlc2TQZPuzZro+e/OWrGwGsSYZIdVArndM0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646828; c=relaxed/simple;
	bh=B0O0iwlnOZPtjvpbchtlaVU4IQR5SsLO65LwDASwa24=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NjN1IHk0r5NdXbN8+Xwyk8sqDvelERwmyCEI1FjTOlxeUBA89ea2fUVGoOrGv/AdEO+FnXsLMPH9pC2d0Ivg12yvkjzGsaMwXsPYpsVj4kRaBO1/IfrU5Ij/hDs2cuSHZdTIWLQXBxot+hB6k9HVxSe6cT2SbOZqI3FCD8UBW/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MlNWaZQS; arc=fail smtp.client-ip=40.107.209.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MlNWaZQS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPFRUtX93gf/IDqhhJKQJPLKAgjDyyU6Deiic+yTvLEszTs2oCYUWYa2HuE3RZ774xv9X6BlAEkvdxhEDV42YVJ/x09eanMUWsTHMjIWqCT2scm6/S/TUSjNFeaiMTbzTOiBoY9Z5GjwvQkgZDH3sy1GuPslF+n7I6zZh1IBMaaK+1Bkvy52i1pBrEnyLjgr5oxWqNKEeogNR2Pwf0DHrxgoUTrPNsLZVy5MezflRiwIBkNU1D839+tkwAqbyt6ewB/f0jkh6mhmvowPhffcEu/3eMemP3zvTcfJ4BHZO4WhxGqllnQb3eAVfefWv5WnCHMXjLehV4DV9JIOuOqdzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0lBnZ5TJ04usYq5Tk/eCaJDqBaUJcksyjGKrLJNX57Y=;
 b=iDKoqfaz86pxB6VsUeMOzCiwUUNNApDxus49WL81xVqI6lZpgJXacb1swNYGrk36dF6C4nH4HzCSkXnh71UH6KSVHhJS+uOwCF1Daf5jeQFuhlPYwRoo13zvG+chJabesW+XbMv/kRMw35OhisSwjebHI3pC0p6O5t6G71y24KsMP8PjIsk9z5Qq5it/+/chIzfBvxhH8OZtki8FFWpWpeYeR/Bb1cj4KoiLpn9QjWxAAXfXSSN56Mo+Yut2SLD9rqt9diMQLAGGG5jfcOF16OObTT26Nwg/LYqSocAY+0pHIbrqgcjQ60m7uL0gg2l2RNyvcBdP73rvzuEBbZqRKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lBnZ5TJ04usYq5Tk/eCaJDqBaUJcksyjGKrLJNX57Y=;
 b=MlNWaZQS1P1hSA88cXtPLQPfMgY/fx/gdSPOg0ZlFKkjjqM2xKrkeejpv+bwkKlLOT7auFIPeHmvMaKsKMSd8wzY/i8/bKp6yY8PqpCwkTcGCvPmCOyOJT/jWdfQatnlLW5sELHwYrHP6PvZxjufnZgX7a5WUMs6c1Tj6xupRrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS7PR12MB8372.namprd12.prod.outlook.com (2603:10b6:8:eb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Thu, 29 Jan 2026 00:33:41 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Thu, 29 Jan 2026
 00:33:41 +0000
Message-ID: <45f4f091-e1b4-4a04-941a-69ae522ffcd5@amd.com>
Date: Thu, 29 Jan 2026 11:33:06 +1100
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
References: <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
 <20260123141413.GY1134360@nvidia.com>
 <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
 <20260127142512.GD1134360@nvidia.com>
 <cd7a2d11-bf65-4445-8eec-df9ba7950128@amd.com>
 <20260128133258.GY1134360@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260128133258.GY1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB8372:EE_
X-MS-Office365-Filtering-Correlation-Id: 1093acd3-bead-4385-dfe8-08de5ece0ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VllUbUU0TGwwdnVRWTZmMmRyK3BaNFdITVdHR2VTTkRTQSs5VjRzWm1SN1Ux?=
 =?utf-8?B?WFBTaFI0R05jMmtzZzJlQ2VkcWpIblQ3TlZ5NW1rcm01eTMvOW11MG8yZXRB?=
 =?utf-8?B?Z2NqNFc3OGcxVjFvL2lSaUJNdERvTytBakg1dFhqVy9iZzB3UGRZdldBR2l0?=
 =?utf-8?B?N2Y0TnYxMy9tNGlvQ3FkQURjMHlKTEs0dmpmUXJCVlMzRVRtSjdvRGpqSjhk?=
 =?utf-8?B?UGtaT2YwSm5RbTEwbTQrc1VkenFmWXYxekNJWmxTaFVqZ2tqd0ZhS2JwT2tZ?=
 =?utf-8?B?Z0t0b3Mramo0VHZkTnNuNXp4eFE3RS9mVC92VjAxRCtyY1JQT1UrbFJaT1g2?=
 =?utf-8?B?TThjZG1XZDRJekY2dHdDSWFMRmx1RTF4T1ltaWQ4RnVvcG1jSm9uZzRZZkE5?=
 =?utf-8?B?S0g3bDVieUpXQmMzYTRDbVU3QWsrRUE3dnBGR3dVWThWQlZRbGcramRLM25s?=
 =?utf-8?B?QVNIWjdYcXorWjlobWJtNjF0bFdUWXFTRGZmaVM5R3R3YjV5eHQyMjQ4dnBi?=
 =?utf-8?B?Mm5IbXovTDJNdlQyYWkydU4zRlRnc1JFV1NGSzlMVlVGbWt4WEFFTmxOTzgx?=
 =?utf-8?B?SmVtb0ppRXZwU2JJTkUrbWlMdE0zdEd4dGl1enBtOHNOdUdZNWxsWlhqSGZ0?=
 =?utf-8?B?ZjlXOXVXa1FIM0dqRDI4TGdlTXk2Ly85UTNHNzd3a1lBK01SVHYyd1lwVDVt?=
 =?utf-8?B?d3p2NlVmamRNVXY4MS9wSnhhanNsSmFUVUdiNTVGK2xKYndjL1pmY05xbjBC?=
 =?utf-8?B?Y3ArL1VrZTVRYlJFR216L2NNL2VVN0d6ZEhyU1QvVTBZcjZTcE44Q0JKK3Rs?=
 =?utf-8?B?L1FpaUZWNitPekwrQ254M2FJMUo1R2N0RjU2SkZNWTB6VWtFVFFRK0RhUldj?=
 =?utf-8?B?TmpsWUhoelBzWGtGcHEwYjhhWnVUdmI3T3l3c2FFVVEwZ3NzMmlGc1VCdkdT?=
 =?utf-8?B?R1ZCNXUxcWdhOS9HbHF1azM5YXd5S1ZtcmxKbGFNMVNDdEhuMkV0ZkpzRTdk?=
 =?utf-8?B?VDNFcUorV2lXblVtaUFzcFNVK1NMdVB2RzlEUzkrZWl5MCtjV09lb3dIbHY2?=
 =?utf-8?B?YlNLOTkzd3pUSUJwSXRPZjJRREJ3UmZRU3k0TDVsTTN4WG56MkdBemU0dVlN?=
 =?utf-8?B?YjFOT3FjSzgyWjQ0bTBUeE9vYzd6WTVZSWJhWllWT2xLdHZQN2xjY0xQeW5j?=
 =?utf-8?B?Q1E3TC9YbllZZ0RCS2I1U1MrVXBDRi80S2RkSzZEdUlqVnUvQ1FyT3NIcnVQ?=
 =?utf-8?B?TjViaG9WZzRNcWJIZDhDb21BY3RsbGZGMnhhYi9xWUJ3MGVweXZkenpRc2ZT?=
 =?utf-8?B?dDF2NFhLdjBpdmdZVmIwTmh1TU5hQ2duWXlHVFR1L3YvN3BablAvaFZodGUx?=
 =?utf-8?B?R2FlMUVZbGxjbU5BU2hNT0dTdGw3YmlVT2NzbzYrZCt1Wjdic3dEUVIzTEJW?=
 =?utf-8?B?Tzc0d3prWWIxRVRSSzNHZlBiaGVvVG9MYlhvbWVmcmp4N0FKQ1BqaWFkczN0?=
 =?utf-8?B?UXg5VFQvYkJmTytDMEQ0WFJmcWQ5eG03dGx2MHV4TDczNEpkRTRMSXVZbEl6?=
 =?utf-8?B?bWY2d3A4SnpEbncrQkVkeHJ1K0pEWndJNElTMWVudzF5dFVCbnZJQU93dVk2?=
 =?utf-8?B?cUU2ajBxQWJMeVZlQ2sxaW9TRURiNkpzSVJ0Wno0KytwWWZQNGxNbFUwR1dV?=
 =?utf-8?B?MThscFI2Z1Z6dzZiNnJsU2haN2FwZDFsb1VsNlh6dU9rYXlpVGRybFIyamhn?=
 =?utf-8?B?c0gwT0g1bklZOWhqeDhieGp6cDBjUmh6b1lVcGVVNFFaRG5sYTVFVVc3UlVO?=
 =?utf-8?B?QmQ3b2t5ZUJLZFNDWjNBRS9WeStQRzVLNHlkQUowajd0eTVseXlNS3BBTFoy?=
 =?utf-8?B?V25qTHdhUU9TdEFGS3JwaGoyWGhja2pjVnNTZTlIMmtocml3QWpGUk0zejYz?=
 =?utf-8?B?bk1vWXpieFV2YUgzYk9pRHFHSUNRbWpCSjc5ZTd3a2xpSGhqVngvNFg0VFdL?=
 =?utf-8?B?andFNmNCUzZIUG5PZjVvRjZ6cWZieHRnUjdTVGMydjRnc1Uwem9Gd2dVWWJ6?=
 =?utf-8?B?czhBSFlZbkNOTklWajFTb3Z4bGkweFE5SVkrOW56WUF4ZjhqYmFocnV0VlVk?=
 =?utf-8?Q?UZ60=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1NOZGFGMWNrczU4R3ZuREVLSi9ScFhxY08wV0dFSlA3RHJ4Qm1hd0NPOWZw?=
 =?utf-8?B?MU5lelViZldZMG5RQXVkMS9lUFNrdmFZb1k5VVZTR0liQlErVmFObEI4NHgx?=
 =?utf-8?B?RDNGMnZjdnE5UFV6Sk5UN0Z0M08zS1hrQkJkZ1lSU0JWSERWV1ZxcDZZazJP?=
 =?utf-8?B?bGFzVENYakVyWlJFbWpjcEYxclY2amJwZ0dFcVk3U1ZTbmNiaGJ4V2xxVUt3?=
 =?utf-8?B?WThuN0RsTmRkQndIeGJnRmsrN2k4UzNDZnpaWVVLTi9kSmEybDZrenVCbWhp?=
 =?utf-8?B?dVlSN3JNYzR2R2NYYVQ5YzBVRVJNbFhTS01hdUFzLzJaR2V1bXl5RU5FVWFN?=
 =?utf-8?B?YlRsdHMzOWd6blpRVHFLdU5va2dUalpLb2E1L1o3QWpyMmc3QitPUVp5UzZp?=
 =?utf-8?B?aDVsVS9NVldxdVJYOXBJTHFYMUI1RTBzNjdsRVphTlpQUmxjNHdjcFMrMjZu?=
 =?utf-8?B?MVlQdnhPZlhkUG9aYTZERVR2R1dRL0doQlRaai9KTGdLbzZnQnl6YVptNk5j?=
 =?utf-8?B?SHB2d1MzQWZTTUpNbU1aSUhWY2t0U2duYzdFd0NaSVRYTzVRQzA0aUszRGsw?=
 =?utf-8?B?czVCVVJkY0pUeHRJSXp6VDRpeEhQRVhPZzZkVng3b01vVjNOM2ZMam45OS9v?=
 =?utf-8?B?S2xFMnJFOGtzVWROalBiZ3FGZmZsZjRCK1JSWGhWaUFJdSt6UWdhVWJpQ2Yv?=
 =?utf-8?B?UW4wWEY5aFNjRi9ST1p0TDY5Mm5WYlFwZUJmbWNESnhLckFjbDEzM1lQZHo5?=
 =?utf-8?B?a2VpUE1iY2NqQ3FTYUZ4UEQrQzVnMm5WN0tyRFhVN1hxdEdoS0tpMUJPZGhr?=
 =?utf-8?B?c2F5Z1NNaENteDM4eTRVUTRSbUx3ZFJoNnlCSE5yL1lRWkpxaGJBR2xmc2xW?=
 =?utf-8?B?WFMwdUNqdEgzS2gwQlFiaWdzQVZNQkNtS3UxR0RpRXc3Z1pEZXFjSTEyNGcx?=
 =?utf-8?B?ZVJCUVhZL3p3OE5tL1B5WGZSTUVrU1A0ZDJIUUQ4TnUrT0tDSnZFT3JJVUJ5?=
 =?utf-8?B?UW1Cak9EMHNIc0tSRHhHNHBIYVpkZkV2TjdWS1hPcTlCcEp5UGpJSE5PWWNZ?=
 =?utf-8?B?ajA2SXNXUXNpT1lGbjBPNFVBY21NTS9BUklsU1kvdUF2MjEvTnMxUTVhWlla?=
 =?utf-8?B?UUs3SU5sVURyVWxIT29UblpMaS9qTXYxK1dyb3NUTlRkTTlvZk40TFZWcGlE?=
 =?utf-8?B?M2dGNzllOWs1TDNVcEgvYmZLTjN1eVBtUVl4QS9haWFyOXE4TkVyTDJ0cWpn?=
 =?utf-8?B?eHE3Z2k1bDByMHJCa3Y3RlNBbEhJSEl3Q2d4ODU0UjQ5QlBmbVB2VDN5cXkz?=
 =?utf-8?B?blJXQ0dBa3IrMU9CRTYxRDNCSGZWWFM3bnhLdkhqeW5SaVFjdUE2T3Q2OEhY?=
 =?utf-8?B?SkRkNElCVXg5eVREMTlVOGpPMHZXUEtuNGI3N2lrL1hkMDgvNnc2SG5oeFNR?=
 =?utf-8?B?QVFHaTVPdFFuQ3d4OVUyM0FUOG9yYVNQbkNZeUNJSjdNWElSd2xiK2JwSlVr?=
 =?utf-8?B?Yi9mWkxad0lLRHhmdU5rVjlvVzNBUGpNRFZrWXBIWDBsS1FGeDBjTzBWVGl2?=
 =?utf-8?B?MEU2a2dwU2E0R1ZKR0hHdUo1T1E5RHZ3TUNGNWZ2WTJoN2xZMUlQSmp4NUM5?=
 =?utf-8?B?UWV6MVBhdzhoWWdod3phcEdQQ1E4R29yS3VvNmJzcnc4THk0Q1hOQnBSQnNm?=
 =?utf-8?B?SnRVYS96L0lsdlpLVHVkR2c1VUJuTVcyZi9Cb1Y0SjByd0JvOUdNL1JGMTI3?=
 =?utf-8?B?OVNyck56V3YyQll4emV3a0R5czZKUHE2bG1Rbkt1QkxJRXdiZERsQTMzZmtw?=
 =?utf-8?B?MVA3RGpkN1ROS3MvSjRwRHczY3gvNU0xVHp0dUk3OUV6RUg4R0xZZlIwSHF3?=
 =?utf-8?B?Z2NYaHpqMERaVkc3aS9IcW9naCtJMDZvQ3ZnUXFJam5rTjJuN3hvNFhUSDVz?=
 =?utf-8?B?YWNBaTQ0Qk1JcVp4MnNKWXREM0hyVDF0SFpucDN5N2xYUlFsaHYxVUJITytq?=
 =?utf-8?B?anJIQk9WbGRRdFZPNEQ3Y3RKZ3hsM1UxQnFzQ21jWW4zdzlqN0dwSTRMQzla?=
 =?utf-8?B?V2dNV3dEaDVLdHI1b1JkRjZ5S2tkU21JeEtBajQ0VmM2bFVKN1FLakRUUGFG?=
 =?utf-8?B?ZGNlTmVjZUVCQVM1NnRIRkZJekQ3YW45M3ZPRi9vUTZPc2pCZlkzWUZCM0pY?=
 =?utf-8?B?TlIwRFJyaWRpK0podU5NTWJhK216YjdUU3QwZlNaTC9wNFl2ZFBKRDlJaTFp?=
 =?utf-8?B?Uit6T0NSRjRSYi9NNncza2RsdE15SDk2TWREZWtKa3JTbldLdXVRZFpaL0Mv?=
 =?utf-8?Q?iD1EfqPfh1xfa4TiCA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1093acd3-bead-4385-dfe8-08de5ece0ce4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 00:33:40.9509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uqXovQ+9S6hZh2YDgpbO8jn8ClmjHRXiPhjlMLhtK9eR1uRjkTfxOkxSQN5zhvpk0w/D06yKh0VJGwTY/KkpEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8372



On 29/1/26 00:32, Jason Gunthorpe wrote:
> On Wed, Jan 28, 2026 at 12:42:08PM +1100, Alexey Kardashevskiy wrote:
>>>> Nah, it is quite easy to force 2MB on swiotlb (just do it once and
>>>> forget) but currently any guest page can be converted to shared and
>>>> DMA-mapped and this skips swiotlb.
>>>
>>> Upstream Linux doesn't support that, only SWIOTLB or special DMA
>>> coherent memory can be DMA mapped in CC systems. You can't take a
>>> random page, make it shared and then DMA map it.
>>
>> Well, my test device driver calls dma_alloc_coherent() which does that - alloc + convert 4K.
> 
> Yes, and there is no reason that can't come from the same allocator as
> SWIOTLB and use 2M aligned blocks.

I am rather surprised that even now, with SWIOTLB_FORCE, dma_alloc_coherent chooses not to use SWIOTLB in confidential VM.

>>> What happens if you don't have a VIOMMU, have a single translation
>>> stage and only use the S1 (AMDv2) page table in the hypervisor? Then
>>> does the HW fix it? Or does it only fix it with two stages enabled?
>>
>> The HW translates a DMA handle to a host pfn, and then RMP checks if
>> that [pfn..pfn+size] is assigned to the correct ASID and the page
>> size matches and the gfn matches.
>>
>> RMP does not check S1 translations inside the guest, only S2. RMP is
>> not fixing page sizes or anything, it says yes/no to the access.
> 
> Your explanation doesn't make alot of sense.
> 
> If we have a vIOMMU and the guest has a 4K IOPTE in S1 then it goes
> 
>   S1[4k] -> S2[2M] -- [4k] --> RMP[2M] ==> OK 4k IOTLB entry

Should be 2MB IOTLB.

> While if we have no vIOMMU, the same effective scenario:
> 
>   S2[4k] ------- [4k] -------> RMP[2M] ==> FAIL

The host should have made sure S2 and RMP use the same page size.

> It makes no sense at all. Why build something like that?
> 
> It is not a "firewall" it is a huge software obstacle.
> 
> Maybe your answer is the entity that is building the RMP also has to
> build a matching S2 IOTLB as one unit and

Yes, the host OS updates both RMP and S2, and the host uses the same page size. Because when the guest accepts memory/MMIO ("validates" in AMD words, it prevents the host from changing it quietly), it accepts a page of a specific size so then the guest can be sure that that S2 mapping won't be remapped by the (untrusted) host.

> we somehow just plumb the
> page table pointer and invalidations into the IOMMU driver.
> 
> Such a messy design.

Not sure about that, I dislike other designs more. At least with this one S2 tables (IOMMU, NPT) stay the same vs having firmwares dealing with them with KVM having to manage some of it. I also suspect I am explaining RMP rather poorly (which is a control mechanism, not for translation). May be Vasant could help :) Thanks,


>>>>> iommufd won't deal with memory maps for IO, the secure world will
>>>>> handle that through KVM.
>>>>
>>>> Is QEMU going to skip on IOMMU mapping entirely? So when the device
>>>> is transitioned from untrusted (when everything mapped via VFIO or
>>>> IOMMU) to trusted - QEMU will unmap everything and then the guest
>>>> will map everything but this time via KVM and bypassing QEMU
>>>> entirely? Thanks,
>>>
>>> On ARM there are different S2s for the IOMMU, one for T=1 and one for
>>> T=0 traffic. The T=1 is fully controlled by the secure world is equal
>>> to the CPU S2. The T=0 one is fully controlled by qemu and acts like a
>>> normal system. The T=0 can only access guest shared memory.
>>
>> Does the T=0 table still have all the guest memory mapped (with the
>> expectation that what is not allowed - won't be accessed using that
>> table)? Thanks,
> 
> I'm not sure what the plan is, I think ARM can do both ways - map all
> guest physical and rely on the GPT to prevent access or dynamically
> map only shared pages.
> 
> Jason

-- 
Alexey

