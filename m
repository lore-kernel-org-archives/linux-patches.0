Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD83E883F;
	Wed, 21 Jan 2026 01:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768957745; cv=fail; b=g6CWjnfk4r5Bc80XRoumkHHfq4xGxaeomA7xBuZ0N7KYi7p+wRWEIx+SvyA1/ZHWN65YtqxO9jHZorb31DvjmJ8Vt4aD3HvH9NHUnXUPX3fr9KU6BAaasZz3FnWu2HwtKbehoZhvzb32FIqtOZZJpM9WTfTtOBaGfec2YG1Cf0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768957745; c=relaxed/simple;
	bh=0NWD4n+xQLqMPWi+50/Gji46VjkdwVWYDYHtnOygcsw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J/OYCzA9Lqy3yPugln1tMMnUuYgJWwCsCJow6Pve2nb5RSkDYGm/ip0/1dDN9S8nkQH4sJQCMYUzni36mmbh8uH9SSoCzQge6TTvX+1SgnxW4DNw4gvEOPc2qWhCIU+tFz/pCV+M75Bv8YdTdCyRsbGos3dao9FfroGqjuhLuMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HrgR/o2Q; arc=fail smtp.client-ip=52.101.193.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HrgR/o2Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wN9ZCgo2frxqnI/DBNIHVb90Ac933fo56U5HjNpuVyBYL189BTSdbO7vEAr0sx1Iz9Rhnp215+I9s2zbDvEzHPPoI+7CqCqKxFfK4dlBRpMxqBEnltMg/zCV8yVESPaqwJFJF6UfWP28MFkEKeYT2knhiDOdp/K78UnIRSRBy9aQaBwPoEl5GdfB28peFr5lMyzpdiSzhdc42H6YOalVrlmNP0hWHI5EYsDFv95d+fAR9HjWWJL1oUtXavkGUc29XAgI7taTB4ubr9PHByK+Tx1K2ndwt5S3vkJy8SNPwCnO0E+r6kcjEs7yOzLKB8NSQrkN5VO+7MMhZBQvTmFH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+M+opapEdawm6NAlmIMxSknJfZKj/76LxWnOIUx3i4=;
 b=mAEey2bNGW/A6iXzJsqWqIlHBfYqrGmBaxGrI3VunqnL5ljT7/ku04Y3do5rB/Den/AJ+E1sb5mvHLA6cU51vwbsKCIvsWUKPdNhDf8NYgWDCKIOab0kJgy8vaCQanQfMmNa7co6xNQ2KOGuOWvXt+BnkY0yeOA/RF7CFQGEuvZYwarINx+13RS9p2iavP/GGe4W1nSkcTP+uEPF6VoKk3bVoEKuZZDh/jC/DVCvi19OA2kDHPdFBb1E+vXU4ZTOdypB4WqLelQea4qXo4yGcf9wInyZ9X1XrUoCkbiwFzXVQGzpfReeoJVI4kHyOinI4Yvu63zuYtApc5aqDr2AzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+M+opapEdawm6NAlmIMxSknJfZKj/76LxWnOIUx3i4=;
 b=HrgR/o2Q+Mm6r9TuoFdDoC3zBQ6fWxE0Y46rNyX5OTd5hH/70uv8JJ40CYQ98NHLcfs9rLSKAk2X6peybcb8K+ALZdRpbrZJ3X9GF754r7ytUGqpVxKOrh4XGUuOkBq306mCVLXz7n9ONTS+X2mU66GfvbwEd/IY3LceQTXd5BY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM4PR12MB6230.namprd12.prod.outlook.com (2603:10b6:8:a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 01:08:58 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 01:08:57 +0000
Message-ID: <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
Date: Wed, 21 Jan 2026 12:08:19 +1100
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
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260119173734.GL1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYYP282CA0005.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::15) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM4PR12MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e25e3c7-ebd4-4edd-894e-08de5889a732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cCtGMTlzSlA1dDZUaEZ2dzI3N3MybVNYSzlRckxIUzVTQ2VXM20yc1A0Uitu?=
 =?utf-8?B?dFRLY3ZieHViOUhHS1Nublp1VkNkdm1YRGJZenZZSGx5dEd5dFQ5aFpiWHly?=
 =?utf-8?B?ZVZLd2d3U1VXZUMvUmJOMTVESWlVaEJMR3Y1dUt3Y2U2WGt3dXh0ZHRLSnFs?=
 =?utf-8?B?aWl3U1pmQWNlMUZVYVhYSi9vTGJYNWZWbUNzSUg3WjhVYzNNQ2NyTXFBZmQr?=
 =?utf-8?B?QnFjcUFXOVJOWFd5K1dSNjRpUEF1akI5ZjNPN01jcVZuKzM2OGFoYWZOamJQ?=
 =?utf-8?B?b05iQ3dITWpSeHRJcmZIQ2lhSExnd2FsR04yQ3FyMVMrNklrN0lIekVvbkxG?=
 =?utf-8?B?RWdOSGlLLzRNckVCMjE4cnhuaUd2VElLd3JobDROTEZ1M2F6SHY1Y1pVeDJ6?=
 =?utf-8?B?S0YzMEx0MllDMW1JSWcydWNlUTU5NmhFeUFEeXJadko2eHpscXFHclBvOEpw?=
 =?utf-8?B?d1N6QVBEMnh2Ym5FU09adXdMU2NJNW1vbzNjaG56SS8xL2ErdjhHMjdIYXNJ?=
 =?utf-8?B?Ky9QL2x3VTF6dWVFOHdOZUx4SWtQTkV4VDhFVEpyNTltcnhSVW9jaWMrNXJV?=
 =?utf-8?B?emJPcXErc2E0TFMzMVhoWmdnQzdPa2VLM0RmUkhLWjZYL3dSWUQ5ZjlEZ3Zu?=
 =?utf-8?B?anAxZGxXdVZZQkJleU8yTGlxVndtR3JVeVlsVGdpaTBmWVdLWWhJNjlSYUxi?=
 =?utf-8?B?dVVHVjZsQnhCZHl4eTNMUEh6OGV5ZHJoS0p2T0hGVER6YkRFayszVlRoV2ds?=
 =?utf-8?B?WFROT3JKRTNOeHJWZVIxZjBzN2JSVHRrTFlXTk83bzdLdWN2YlcyQ3hQVVRP?=
 =?utf-8?B?QTJxUUZOZU04MFcrVUVPejU4RHRvcm16RG04NlppZ3dsamF5MWIzZnNoZXRJ?=
 =?utf-8?B?b1dYdndPNnh3V3pZOWhtZ3cwaTJJSklwS095eTVGU0RET3dSVjZvOTh1U3BP?=
 =?utf-8?B?WlR2ZzB1NnpIaW5zOWN5b0JiL1R2cmNZVVdFMGk2eDhzQkFVSk1yQlN5TlJX?=
 =?utf-8?B?RHkrdDVJemNLcUQ1L0hzSEhLNTdKejdpdENTWnZRUmhpTVFMVVpmSHNoRFoz?=
 =?utf-8?B?dGh1NkhvNWNibjcwVTFySE93S1o0b3BKWkZEMldnVDB0VzI3UjhnU05VMmJF?=
 =?utf-8?B?RTR2UENFdDVsbnZ5NkFSR1ZwcUtGK2JXbXJzaHo1M1M3cGFiOVlsSGRncnoz?=
 =?utf-8?B?emhQYnByMVhBNDNFT252SXdjT1lOcXNUbDRIWDhsK0QxZ3d1Yi9CSWJLQjE3?=
 =?utf-8?B?bnk4QlhraXlrQTVyKzJ0YWh2V3pWV0R6ZXJaSlNWcUpRUldTOHBOQ3JVUmhS?=
 =?utf-8?B?R2NvQitqNGhWSUdVYlRsNjdBV0FVc1c2Q3hidVlPK0RMbmloajAvak9iTHR2?=
 =?utf-8?B?dGRKQXBkRmhDSnlpSVo3Z0c5RERUTE9CakJtdXJ0Y09xM3RtZmtzQW9WZkJI?=
 =?utf-8?B?ZXJTbTliUEpHWHRVT0Q4VDY2RTlhbnFMb2VDUVNQTnlpZnc1dmRzci9MLzgw?=
 =?utf-8?B?bklITUhVU2hQa3F2VGV5Y0tkaldaeUFFbVJWVCtEYThSaGZHVitqV3pFZkZq?=
 =?utf-8?B?SllwWldjY3pFSURMMC9Mb2RvTENoUjduSWQ2OTBBVGVHUVlxa3R5UjNRMXAy?=
 =?utf-8?B?N3VvV1dMWHUwclkyQ2lPclpYSnFxTVJBR0JCZ3JIQWJvbDZvVlY3VG9UV01D?=
 =?utf-8?B?SGpTRUtSNzBMTjgybThwWHZPUDNUSEtGRlpwWXByeVVucGV5T0duczJZdi9z?=
 =?utf-8?B?Z1FJOEd6amFqVldYcHpJaG5Wc2NCdW1DSjZIUkJOd1ROakhyR2dVU1ZaVXM0?=
 =?utf-8?B?TjErSGdTRmlkYUlKVzNaZEV5L3R4WjNjZ0Y2a2J0M2Q5OXRjclpER0hQV2NF?=
 =?utf-8?B?ZXc1K0RJa1k1MFFHazdKYVoyRG54SUhVR0NIL3o2TDJQSmtJaUUxV1VHeVU5?=
 =?utf-8?B?bWRrWHZsOCtnUDROLzdBem56MWl4b1J3WUtMV2V0V2pTOHAwdVJwV3JUZXF5?=
 =?utf-8?B?VlJPZ29FaHh2aFhLVDV5UW81ckhHSTQySnE0eXdVNkhiLzZTTlV6Uk9yeVFH?=
 =?utf-8?B?Y1BvZHhJUWJrdmNlTW1vOXV3bkZSVk1nUGlCSHNINFZ1c0xSSHpzRG00dTFD?=
 =?utf-8?Q?LfSI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmF4akZhT2hyTTlsR2xJUE9mNmlRL3Viem9tb2JVRHlxaFRaMXAxVXJua3Rs?=
 =?utf-8?B?Vld4WjZ3OG5oTkxkNUt3eEdzUkdJek5DSTI1RHJWS1lYdUhVa0FKMVRwS0Ri?=
 =?utf-8?B?anlUdHlpWU83ZXFBNnd1b0hHRU5uajBVUHFrZE1EdmxQSWl3STB3RWVmcHVH?=
 =?utf-8?B?N1VtbjhHK3VOYWNTWmo0MFBONXlibk51RVFKM1I3ZGxiUkp0VkFKajhyZlRx?=
 =?utf-8?B?WVZMVWRia0NWaGJGTDZoVHJZRHB3OWNaMit5czBaaDdhOSt5WmZ1bWRyK1Rr?=
 =?utf-8?B?RzRmdTltTzRhSzQwNEhMVUtwUE9VcEdTZFdQZWN2ZTdwanBwMzlFSXZoZlZD?=
 =?utf-8?B?VWN4aEU0ekU5aW9mQXNneDcwQXNxaDQwcjIvbVN1VTlQOGRKWHRBSUFOWjNj?=
 =?utf-8?B?YWx1enJCUkdwS3pkN3dXYWZiQjJCRzZ0QVJEbTU3ekdZNFRpSk12WllBTHFQ?=
 =?utf-8?B?N0dtUEcrTUtQYmFtaGIxdTllSHZZNWFEL25MQjRNK3lVTFB1dDJXek12V2J1?=
 =?utf-8?B?Uno5SzdURk53RVlyc24wOEgyNUxjeHNrTGpFZThnUjErVVdXZ0MvUytxam9U?=
 =?utf-8?B?cXZrTllsZDUxR3JCa1Z1YVBVRU5razVTaW5sT0YxZ2NaZjFCcG55R0wrTk5y?=
 =?utf-8?B?MFBZclFEZHZaSW8yRnowOEFQcHI1TEo3ek54QWhLV1RVWng5d1RGK2cyelBG?=
 =?utf-8?B?ZktRMnFQMmU2NlhBZzBQYkREVmo1V1k3aEJDLzNJTWdUYmVGOTRSU0VIR2JJ?=
 =?utf-8?B?S1dvVkhkYUNlcFZKaDFVc0dhNGh3citWVUU3VXlCNG1Id3dxYUh2a1hrbXJL?=
 =?utf-8?B?L2RJbHNrdDFCSGlTQ1NGeHdQZjdXeDUyOFNhQzVweVdDZkJIcjF3eUg1TDZy?=
 =?utf-8?B?aUJuUlBZMzhmR3JYTWlBR21wWkhYbTkxc0crTmFGR1FVcWt5RS91QUZvWU1T?=
 =?utf-8?B?VlF1ZDU4OHViZkpRSENJaWM1dlJwYlQ5Rm93UHdPZkdjOVRkRCtVdzV4bkdl?=
 =?utf-8?B?UjA2U0NwemNnRnhoK0h3UHBsRmlZUmFIOTkvQVZzSHdudGJZelJGNEJyYXNa?=
 =?utf-8?B?YklOYkthbWZGZ2ZMaGhwcFBtb1JBTHdXMkgrVXdTV3FoWTVaK0xQNlpMV2Zk?=
 =?utf-8?B?ZE1BT09MMVBmbU5Eb09NWi8xWWhIa0JpSkdLYUxiQWcwM1FObm1TdGgrcFlJ?=
 =?utf-8?B?ZHhYdmhIUjFydHFIOFowTjZKdzEydWg3c0dlb3JSOU9KWnJORnlzN203Ujlk?=
 =?utf-8?B?aXBNcUtqcU16clRhVmRtLzlzc1Z5UW4xRFQwRXVYOVJtekRlRXJjaHpNNUJr?=
 =?utf-8?B?Y0JzZTRGdGxkS3BDWlo5T2VmaU5LSjlXL0wwUExFcm5JUnhkZlJ3WnF2Vmtu?=
 =?utf-8?B?L0MrWUhSM2ZXd3lVREVLemFHZEw3em85OU9nZFJuakRXUzhxRGJ1dExnK3RN?=
 =?utf-8?B?RWlDdEUxS3kwOW1UOTR4Y1ZGNEpTQzE4UHdzcWN5elFjZWpWQVBLemhPS1JQ?=
 =?utf-8?B?R2kybTI4ZkJNd2l3em1PeFZSMFBLWFZ0NVVIU1B3dFNubXd3LytXa2tmbUJW?=
 =?utf-8?B?M2hnWFRtei8wWjNJa1prT0JlNVpvL0FlcTAwSk1BUExQVzNCVDdjMXlmWDVy?=
 =?utf-8?B?dWRrK2lNcStPZTk5M2pvVVQrejhqc2FCeWIvcE4zOWNReExzVDVTb1BKWmVa?=
 =?utf-8?B?T2kvbXpSQlpXd2toelQ3V3BPdDNLdTJUTmp3VzNnelNxaG43T2gwbUwwandV?=
 =?utf-8?B?N01keFRmVCtTRU9xUVFtWExrR3FmdXZ6bGNENFd3UW5mbTMxU0I4eHpRVVlZ?=
 =?utf-8?B?WWFjR3ZTVDlXNko5NnJvMjJEU21YZi95VnNVb2RncnNRWmViRkdYL3ExeFpi?=
 =?utf-8?B?L3F2cDc0L1djRW1Kekt2WFNvbjNrS000aGEvS0twL0NCTXEzQzIwS1g0Q1pS?=
 =?utf-8?B?R3pEOTFEOUxldHFZU25XUWhONSt4MFR4TzlrRkVHdlhtZzk5bU14VENQayts?=
 =?utf-8?B?c1ZhZCsrYmFqTm90NmsyOXpVSWlnRUNVaE1YMDZrd0owMjhNaGMydi9NeUxU?=
 =?utf-8?B?TFpldmMzQ3NzUDJkVFYreDFEMW5kUGNlMnJDbGl0Sk4rVUtxRGRKZit2Visz?=
 =?utf-8?B?M1ZVcGloZnEzVXBWdUhEWEhYTmpoZWtaWi9iWHROYUp6L084WVErRU9rajMz?=
 =?utf-8?B?dWVKbXRKZGdqZnZldldoaHF0L1Fuc21wa0UyNzFGTWhFSnlMNStrblJ2eGZk?=
 =?utf-8?B?WGZycWR3NnozSEpLNUdDYzFTYzBoMExQZUIySG1Cby9XSG9aYjBibHNFcmRH?=
 =?utf-8?Q?ARqDNErvNzBxQ1iSv5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e25e3c7-ebd4-4edd-894e-08de5889a732
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 01:08:57.4099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEFrfVLtA5FHwG7QB74Z1kYfpcQiZgY5hoIMJc4H7Qky8p1CBDv5mRmsopyJIAs7kr5lDKwmN/8+da2GZlySEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6230



On 20/1/26 04:37, Jason Gunthorpe wrote:
> On Mon, Jan 19, 2026 at 12:00:47PM +1100, Alexey Kardashevskiy wrote:
>> On 18/1/26 02:43, Jason Gunthorpe wrote:
>>> On Sat, Jan 17, 2026 at 03:54:52PM +1100, Alexey Kardashevskiy wrote:
>>>
>>>> I am trying this with TEE-IO on AMD SEV and hitting problems.
>>>
>>> My understanding is that if you want to use SEV today you also have to
>>> use the kernel command line parameter to force 4k IOMMU pages?
>>
>> No, not only 4K. I do not enforce any page size by default so it is
>> "everything but 512G", only when the device is "accepted" - I unmap
>> everything in QEMU, "accept" the device, then map everything again
>> but this time IOMMU uses the (4K|2M) pagemask and takes RMP entry
>> sizes into account.
> 
> I mean, I'm telling you how things work in upstream right now. If you
> want this to work you set the 4k only cmdline option and it
> works. None of what you are describing is upstream. Upstream does not
> support > 4K IOPTEs if RMP is used.

ah, that. Well, even now if you force swiotlb, then IOMMU should be able to use huge pages. But ok, point taken.

>>>> Now, from time to time the guest will share 4K pages which makes the
>>>> host OS smash NPT's 2MB PDEs to 4K PTEs, and 2M RMP entries to 4K
>>>> RMP entries, and since the IOMMU performs RMP checks - IOMMU PDEs
>>>> have to use the same granularity as NPT and RMP.
>>>
>>> IMHO this is a bad hardware choice, it is going to make some very
>>> troublesome software, so sigh.
>>
>> afaik the Other OS is still not using 2MB pages (or does but not much?) and runs on the same hw :)
>>
>> Sure we can force some rules in Linux to make the sw simpler though.
> 
> I mean that the HW requires multiple SW controlled tables to all be
> sizes must be matched. Instead the HW should read all the tables and
> compute the appropriate smallest size automatically.

Not sure I follow. IOMMU table matches the QEMU page table, it is two tables already and IOMMU cannot just blindly use 2M PTEs if the guest is backed with 4K pages.

>>> Doing it at mapping time doesn't seem right to me, AFAICT the RMP can
>>> change dynamically whenever the guest decides to change the
>>> private/shared status of memory?
>>
>> The guest requests page state conversion which makes KVM change RMPs
>> and potentially smash huge pages, the guest only (in)validates the
>> RMP entry but does not change ASID+GPA+otherbits, the host does. But
>> yeah a race is possible here.
> 
> It is not even a "race", it is just something the VMM has to deal with
> whenever the RMP changes.
> 
>>> My expectation for AMD was that the VMM would be monitoring the RMP
>>> granularity and use cut or "increase/decrease page size" through
>>> iommupt to adjust the S2 mapping so it works with these RMP
>>> limitations.
>>>
>>> Those don't fully exist yet, but they are in the plans.
>>
>> I remember the talks about hitless smashing but in case of RMPs atomic xchg is not enough (we have a HW engine for that).
> 
> I don't think you need hitless here, if the guest is doing
> encrpyed/decrypted conversions then it can be expected to not do DMA
> at the same time, or at least it is OK if DMA during this period
> fails.

The guest converts only a handful of 4Ks (say, the guest userspace wants to read certificates from guest-os->host-os->fw) and only that converted part is not expected for DMA but the rest of 2MB page is DMA-able.


> So long as the VMM gets a chance to fix the iommu before the guest
> understands the RMP change is completed it would be OK.

The IOMMU HW needs to understand the change too. After I smash IO PDE, there is a small window before smashing an RMP entry when incoming trafic may hit not-converted part of a 2MB page and RMP check in the IOMMU will fail. That mentioned above HW+FW engine can stall DMA for a few ms while it is smashing things.

> I'm assuming there is a VMM call involved here?

Yes.

>>> It assumes that the VMM is continually aware of what all the RMP PTEs
>>> look like and when they are changing so it can make the required
>>> adjustments.
>>>
>>> The flow would be some thing like..
>>>    1) Create an IOAS
>>>    2) Create a HWPT. If there is some known upper bound on RMP/etc page
>>>       size then limit the HWPT page size to the upper bound
>>>    3) Map stuff into the ioas
>>>    4) Build the RMP/etc and map ranges of page granularity
>>>    5) Call iommufd to adjust the page size within ranges
>>
>> Say, I hotplug a device into a VM with a mix of 4K and 2M RMPs. QEMU
>> will ask iommufd to map everything (and that would be 2M/1G), should
>> then QEMU ask KVM to walk through ranges and call iommufd directly
>> to make IO PDEs/PTEs match RMPs?
> 
> Yes, assuming it isn't already tracking it on its own.
> 
>> I mean, I have to do the KVM->iommufd part anyway when 2M->4K
>> smashing happens in runtime but the initial mapping could be simpler
>> if iommufd could check RMP.
> 
> Yeah, but then we have to implement two completely different
> flows. You can't do without the above since you have to deal with
> dynamic changes to the RMP by the guest.
> 
> Making it so map can happen right the first time is an
> optimization. Lets get the basics and then think about optimising. I
> think optimizing hot plug is not important, nor do I know how good an
> optimization this would even be.

Got it.

>> For the time being I do bypass IOMMU and make KVM call another FW+HW DMA engine to smash IOPDEs.
> 
> I don't even want to know what that means :\ You can't change the
> IOMMU page tables owned by linux from FW or you are creating bugs.

oh but I can :) It is a FW call which takes a pointer to an 2MB IOPDE, a new table of 4K PTEs filled with the old PDE's pfn plus offsets and then the FW exchanges the old IOPDE with a new table and smashes the corresponding RMP, and it suspends the DMA while doing so.

If I get it right, for other platforms, the entire IOMMU table is going to live in a secure space so there will be similar FW calls so it is not that different.

>> ps. I am still curious about:
>>
>>> btw just realized - does the code check that the folio_size
>>> matches IO pagesize? Or batch_to_domain() is expected to start a
>>> new batch if the next page size is not the same as previous? With
>>> THP, we can have a mix of page sizes"
> 
> The batch has a linear chunk of consecutive physical addreses. It has
> nothing to do with folios. The batch can start and end on any physical
> address so long as all addresses within the range are contiguously
> mapped.
> 
> The iommu mapping logic accept contiguous physical ranges and breaks
> them back down into IOPTEs. There is no direct relationship between
> folio size and IOPTE construction.

Ah right, pfn_reader_first/next take care of that constructiveness. Never mind. Thanks,

> For example the iommufd selftest often has a scenario where it lucks
> into maybe 16k of consecutive PFNs because that is just what the MM
> does on a fresh boot. Even though they are actually 4k folios they
> will be mapped into AMDv1's 16k IOPTE encoding.
> 
> Jason

-- 
Alexey

