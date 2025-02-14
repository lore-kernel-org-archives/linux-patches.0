Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667A91940A1
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 21:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567576; cv=fail; b=VDQGPJEMO/UqnjQC8s/DjhCvGROIFfNBK++T7If20x0X5FjklrmUjIDWpY+BvNVhiF6J0Y2Ucg+xZ580kL5QBgAB36s0Zt8aqTlc1Cu2YJr7ApiYa/t5q4gIG8dtFajdU6qKkgz9tSd4mduS6ehLf9WE+2gxnohUWoj2l2atOkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567576; c=relaxed/simple;
	bh=HhdQjkDJt4SNYTm3uO9PlZg2VUP4o8NmTBPcLDtG9O8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tp+UzoG1uTq+suvJY9EgInlI/p7oF8BhWHVwbUagT2RDodzwLR3yIjIV/CE8nf16vBzIJPT2jiqCPSWbgxasXxqIEw5+PmG7G3jgM3rLkIF7FoUiFJFVFI9jdBv/6XwIzegmlAb/2mlT0/CSEwgzI/aRQHGSdKb0T4X3zmDQf9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KuHfDG9I; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KuHfDG9I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9IsLikHE8rmKNjddAXT4v6uIS8equ7Aa67Vr3hHS6jJenyAh5I518r1ecHi9iOJxiP4gBkIY6ZmpMQjgOKGTE1/jJhVT2NyhWH2NIiOomZv0VJEe2v9bHk9011lmPDql88yXmmYj0A52Y9bXsqqwMAN+kSlne5Z3Ylmo8ZFKMExefMspkSM1YM7DwbZTkZH3Z0uCIX6GW3Z2U6n3YKUXgX7jHDINaUr/BhhMfX8ipAiTlLuK6N7h3JchV4AbHXHkyUnKKERPbzXwKK/Of3VcO5A1jL795UpJTrxfrtuUffPhWExicgEU1iuGtVFdKVTahLrEvgpm5rxFTM0UggIFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0pHQwt7HsMIC2MD7LNiZUyTZJDj3Rk03YIl2mwSkrw=;
 b=kdL/Fh9ou8FUokafqSSLsUrZr8dFP3JhwYQ2l58eGWMOZGrQd0DWfYxmU+vJg7fpKUqP2CFC4ohjAES2q+priF1e+aCaPJHJ6T/jPhCUo8zR3+pEzkG7cRaPs1BjN4d7B4+HLoma2jA5zBdrdYORCn+T1wBBWVWSMZVveIEBqCEa/JPYDZjBN6nU1A+wHoYv+31X4wNCjqxlYVSPCk0sldpvJ1JQEW2QrkkWkXvofW8W8tcKqLdGRlEdPQi8BN2JJ72iuODJ/b0evUvs49fquHAMZ1XwNI6WV0zKDXHPSCRtxULtF9jahuy0oCECL6GHpFCmyKVU5bDPxnw54IZFHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0pHQwt7HsMIC2MD7LNiZUyTZJDj3Rk03YIl2mwSkrw=;
 b=KuHfDG9I/2YM9IbKnCSwOVMZOSjqW0hzsPPCOd+W+x0AH7iLppR8IxaoTqi32UF/7s/wwuwDaWaUTAIaG/pjdUxH1K7bkVakiFjrX6hEFwRHDEq5+6f8sTY2rSp1lWW0JVCJnTu88lkeBS9vD6xl/MiWQeENhPttX8FZgTs5BIYNJ/9WTA62MhUSIaXyVle6S8ks/36XnCVjLa7IGcYZWNqi9yozvmfRk5aLc661RaK3atmdkqwGsKNm2pfVKP0OnuSLzo9ON1JPNSfY4Z+nPirI/7pWIYuuEQKcickcF0gOHmFqAREQ9Rbe+X06FrM3tWbZk2IzELgLKQ8BFSuCLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH3PR12MB8533.namprd12.prod.outlook.com (2603:10b6:610:159::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Fri, 14 Feb
 2025 21:12:47 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 21:12:46 +0000
Message-ID: <bcf76664-e77c-44b3-b78f-bcefc7aa3fc1@nvidia.com>
Date: Fri, 14 Feb 2025 21:12:39 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/419] 6.12.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250214133845.788244691@linuxfoundation.org>
 <57e42fbb-9372-4618-bbed-71da01326ffe@rnnvmail203.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <57e42fbb-9372-4618-bbed-71da01326ffe@rnnvmail203.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0254.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::7) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH3PR12MB8533:EE_
X-MS-Office365-Filtering-Correlation-Id: dc3563f9-5aa5-4f3c-c759-08dd4d3c5430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SlFmMWNUTm1sNEw0UkdPbTZRemNENVdkRGVNTkpadW9vRnd5Q1ZRRURwZFIr?=
 =?utf-8?B?UXNPVDhZZ2xubVZRbitRM1ZjYUNaelZZNDBFaTY3VUQ0bVhDTE16dlFCVytq?=
 =?utf-8?B?SlJKc3EyTm0yYXJISUxjUFoxMDZObHR3TU55VU1uVzI2eDNBWXZqWkJ3UHlI?=
 =?utf-8?B?TWJqSjBCSlE1NUlBNVJCSEpoT3VjYS8zL2xhTS9RWHdGQm84OUU0V2hmSHJC?=
 =?utf-8?B?R08zZWFsZGh5NVR3OHJXNUVNb01lTTRRLzhTRzFCRkQrcHFFL0grNUp1TTJt?=
 =?utf-8?B?Mk1uQ2duMTE4QnVWZUJsMlV4WjFjNGdaVnUxNExuMlFJU3ZpZW5IWHN5Y1NX?=
 =?utf-8?B?VU8zVjhEU0NLQm9qUnMwT1didnExanNGcllMS2VBQnVodnBDYVpWTFNrVWJw?=
 =?utf-8?B?amxac3U1UDhQNnpTNUgydnZIVFFKQytpeEVueUxWM1Jka09ZK01GUUVDR00w?=
 =?utf-8?B?ajBiSmhrVlhiSDM4RHdqRldvSnlCUUlNOEk2L056enBEOWIwU0hjWGlBTXo2?=
 =?utf-8?B?d202ZUFUUEpheVE1bk1zeWNKMDA3dEIyeHl0bHRwS2tEM09IOVdHMlFvOGdm?=
 =?utf-8?B?VUo5NWc0ZXY4ZlFkVmhzdWcwQ21PSkYvWnBWaWhNTGFlbnRvSy9oWk92cWN5?=
 =?utf-8?B?aVRMMnRPeG4xOTJJT3l1T1VpcUtBNGdFZGx4b0NOSFFGZ2RmYWpwLzUxaDlz?=
 =?utf-8?B?c0NUcUNJV1RyQWVLM0RMY2F6RVVwR21VckkreW9vcUxDcXBPdW5YVzM2NXkz?=
 =?utf-8?B?aDN4bitpN1J6aGtmRktSVGdpUTZjWElRNjJQS2tOeERnYWpqS1RLNzBTVTdz?=
 =?utf-8?B?U0dTalZrWlVaeHNCNytTeXJCUmFWNitVV2pVVXJBYlhyL0IrazczQ0l0QzV5?=
 =?utf-8?B?QnUxRnhXNWc2YWJCck9pc3JVYkJhSTltdnA0U2pad0h4S3dKM2czbGZBSU9V?=
 =?utf-8?B?Q2o3QnRraGpvK1dyU1dTSVkvVDJKZ1dLa2k3T0UvTnlOaWlhNWVVUXl1WVo0?=
 =?utf-8?B?Z1NYZjZIci9ONTRGanF1bHh6ckZWNFdXdTk5MEFIR1IzcjczcEZRVXhWVGls?=
 =?utf-8?B?akJjd0RzbE1rVG05SFRBY2FLMk1PK210aVh3MDZRZWNjemZ1aGFGQVo1ZEFm?=
 =?utf-8?B?eUZyV3JlOEFLUkFoVm1zNk1QRlJKcUNlYTJwK3lPTmFac1M1YVNnVURHWUlI?=
 =?utf-8?B?S1ZSTm9JVWQwQy9ibTgzaVVMTmxLTjRpcndud1NnUUNQMEdqTzh4RzU3RkNM?=
 =?utf-8?B?c3Zyd0lHYytVTmpac1kwVjZENDJ5SDNSNjBKYmFnYm9YUEVTb0tqYVFDL2Rt?=
 =?utf-8?B?bm5GcFg1Y1pwRXVaT0plZVdpbExBaXl4QnBBVkFGdWpsYjBiSjNxYmJFMkR6?=
 =?utf-8?B?SEN4RGlBeWJUNlp0WlU4bkdJK1FSb0xhTmFWQVZLa08xUy9iMHFycS9vczdF?=
 =?utf-8?B?Sk5yL3RpUVRFQmRKSXJsNTEzZDRMa1dEMzNpUW9hYjh0OWUxcWQxa2twd2Va?=
 =?utf-8?B?NDlML2x5cFJ2cVBKbjBVVHNubzNISllzUCtvUXNOVWxBWE1GQmhsVWRacmhX?=
 =?utf-8?B?Qm1QSmpTZGhxM2hCZUkrWU9KTmN5anZuWDVhVVk5RHNrTDVDRFhBcC9MNEdl?=
 =?utf-8?B?dDBsZjJUaUdyd3ozckQ0YWlyM3Z1YUxRbWdxdDJGV0UxMnhnUlVKNHYxMVZL?=
 =?utf-8?B?N2hmQVI3MURLNCtZcmdrN0c3cEExMTFFby9DZCtkRkJZUzRpNy9tbWdFYkV2?=
 =?utf-8?B?M3BPNWZ2Z25NQ3BJSnF1ZWdkMTNaaHZzNmxvVEMwT2lraGtzZ0ZjQ1gyb09Z?=
 =?utf-8?B?TlZPQ2dkR09aUTJCMDVqSTBmYVl1QzlHWFNtOU5MY2cxSnVqTHBLdFlwWnJx?=
 =?utf-8?Q?GVD8RyD/8deKG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXJWa0VIbEo3WmVQczhrNk5KVTZpR2RxeVE4Z2p1SDh4V1N0NXBXaVpGbDEx?=
 =?utf-8?B?Rmc0d1pEUkNqTHlOQVlRWC9taUpJWXR0OUJhV1JTdzZBMFJQQ0VMNVFRRGVG?=
 =?utf-8?B?U2d5dTg0eW9GdzJ2VHlpTU84eEU0SHpRR2hvQUtGOGtrY3ZuSStRY3dVdTht?=
 =?utf-8?B?OWg4aEMzY3BvTjdyQ2t2QXdJZjE1T1RQaC9XckxzNDJnS054WjVSdDRoQXhu?=
 =?utf-8?B?a1lwRnFSeW16NkdJYUhsSG5xbGRhaThsWDR5WjhnUU9oeFJFcUhKNEExdjNr?=
 =?utf-8?B?Smh3ci9VcTFycDZ2T3RZTDBSbjRqbG9MS0gxQUczV253T1Y5bzI1S0k0MXI4?=
 =?utf-8?B?a0tpQlJ2QnVkbENJckp2bnRncUxJcWIvVUtVaml3VUtVYm0yZlRrQSs3eDR5?=
 =?utf-8?B?TTM3czRlNnF3ZkRsWmNhcnhUZlpobUlvSGRxZ2hzMVNNQlVGNHpmQnBHbkNX?=
 =?utf-8?B?MXZKNmQ1aEt0TFgvb0E3UXU1Z0tzT1AvWkd2TTNqMXVvUWZUdTZtY3pCR0Qv?=
 =?utf-8?B?MjUzTGd6TVRsRDFybUhXaVJTN0RXNGJRMGdUWGlSMHZoU1BpL2psOG8vd002?=
 =?utf-8?B?aGNpRFhCSklaK2pjNG9tOU4xQnlDeUlnajNLY0FZWlJnVlJkT2I3LzkrOVVY?=
 =?utf-8?B?V1VsME5uRWE5eDJMLzdXRlprdWRBS0ZjTG9kc1lzVUtkTlhBWDd3QzhUZnZQ?=
 =?utf-8?B?UERQSWdGWlk5V0FtY2oyQUsreEVETlVsdnBsT09FRGRLRnFXUkJna0xTaDlv?=
 =?utf-8?B?WDlSbW5RZW9BdGE3ZVFOZ08wVWRvUzkxcVEzeWJLZVdmOXY3aWI4MFllM3Mx?=
 =?utf-8?B?aHlySFVreW93UnNRS3NnT0VpR1Zwem1nbUhHUlh3a2t2V3hseXNsR05YWlB5?=
 =?utf-8?B?L0poUENDWUJ5SXJvUXVrSXFlbmh5WHV6MXI5dDBHTWNZMFhiZWttOERXOVEr?=
 =?utf-8?B?L05sN2g4SVMyKzZocGJYRWNGeWo3M3J3QTVKSWs2aTdFakhmM00ySFFDam9l?=
 =?utf-8?B?c3hCWHMvRlQ4OE9EN0MxZXcybjJydXBhWUxPTUJTNEJWNzRsbCtYaFZldmpU?=
 =?utf-8?B?azFMRjd1TjNlS1ZPQWNoRTU5TzRJUG1mUjhadkE5OHEzbkVPT1pmTWJ5MnRK?=
 =?utf-8?B?eXYrMlV5a0I2SUZ0anVpUkoyeDFGalpXTzI0dTJQMU9OVTVQVHIyYmpMazZY?=
 =?utf-8?B?OGVCakswMVBGcDNBdjZuSGx0UjdCZElpWU1TcmFsdjZuVkdXWXROZVVRY2Jo?=
 =?utf-8?B?NG5tUVF0ZEZyRSs2QmNPb1JZQUJJUTFRc1VNWHNLdEdFNGQyUUYzTmxHZ0Nw?=
 =?utf-8?B?dHJXMk9OUHlJSS9VdTdNcjhFR1pNUFhPb29hVGpabkl0NlV4dmFPSy8rVEZ6?=
 =?utf-8?B?elBVc3pNQlNRd2xiMkxiOERGaTFhaHhmTU15SUJCTEtxb0dkdjVrSEhGaWda?=
 =?utf-8?B?TVhYT01RUjBrMTFxeGh0K3Z6Ym1Gc1ZoOTJnQ3FxVHNOK1hEMVpkVkxVd2R0?=
 =?utf-8?B?M1hmbXh2ZFZmVVZDdnF6dVdkUnZxbjBTaUd2U1NRS3N1azBwd3plbXhLcVFK?=
 =?utf-8?B?S3lEek9Bd0VKZ1F3cHNrZkkyRWF6RzhIZmVCbzN1czFyS3pibndJQkJ5QklU?=
 =?utf-8?B?QmN0YUgvR3o2ekRqa00rb2lMa3pYSWVPS29lc0Y2amUzS1VHL0hSQkxGVU11?=
 =?utf-8?B?WnBBbXhTaE1wM0w2VXE1MXl5ZVRGNnBpKzl4bEpWWW1YUzZqaWlQcDVZZE9C?=
 =?utf-8?B?cTJIdlFnLzVFdEhrMGFkb1hUaGJTeVhmUVk3WndRVDYrUWJRSXJVUm5YMEND?=
 =?utf-8?B?d3FLc3p4RmxUMzU3a3E4Y2pxanBjUkdXL2tXTXE2bGhYSXFXWTVaZHpjRkdV?=
 =?utf-8?B?WVdnWXFTbVU5emRQZzFpamo2b0tVVVg2VXZJVzMvSEhMK1pvOFFKQjlBOFlv?=
 =?utf-8?B?aGtxckpPUnA0bDhCUURnWjJ0dWY1Q0swblFSSk8vZ2RISlR2aFVkL3l1MHo4?=
 =?utf-8?B?aXhDSTNXMjN5TVpidGhoMDNMK3RJdVlhdHEwMmxhUW1SR0pnZGRwSnZSemtN?=
 =?utf-8?B?NU5rQkMzaXZzOVhWcXN1dURjaXJ5YzRhY3NWYnA4TzJQbE93OCs1YzNlRUdt?=
 =?utf-8?B?dHRPa0Yxa21QZCtrNy96S2hHZ0gvOGs3YWgzMStFL1RqR2hjcGdqckNqYm51?=
 =?utf-8?B?WVRQSVRqcjZkb3FzTHcrcGFwbWFxYzVGM3hxV3RUdk0vV3BzT3VZRzUxdmV2?=
 =?utf-8?B?RjZaQ1k0L0tJWmJEYTByNm83dE5BPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3563f9-5aa5-4f3c-c759-08dd4d3c5430
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 21:12:46.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewYdtn2aoioj9gK6ybkHawpz/q2jhy2eZmontPxynrkkHZ7/k471Yq1lJeHJigr+P0SMn9i/W/ppWK0LiAf5PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8533

Hi Greg,

On 14/02/2025 21:11, Jon Hunter wrote:
> On Fri, 14 Feb 2025 14:58:41 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.14 release.
>> There are 419 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 16 Feb 2025 13:37:21 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.12:
>      10 builds:	10 pass, 0 fail
>      26 boots:	26 pass, 0 fail
>      116 tests:	107 pass, 9 fail
> 
> Linux version:	6.12.14-rc2-ga58d06766300
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra124-jetson-tk1: cpu-hotplug
>                  tegra124-jetson-tk1: pm-system-suspend.sh
>                  tegra186-p2771-0000: cpu-hotplug
>                  tegra20-ventana: cpu-hotplug
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p3450-0000: cpu-hotplug
> 


Bisect is pointing to this commit ...

# first bad commit: [3efd1a4cc13eccc1ae02b0511aec5bc74a168b74] sched/deadline: Correctly account for allocated bandwidth during hotplug

Thanks
Jon

-- 
nvpublic

