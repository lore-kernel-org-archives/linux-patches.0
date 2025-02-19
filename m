Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07571EFF85
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739973877; cv=fail; b=dejnQNN6iq40oDxWdLPMVdINYqq6aZam0XN3FQ5g0ArbN7tMfVAz5Osy0sNtfJqNHhvmVB1eKafIjXBrcnM7M4gcMR8mseTgPUu4SRT1Xqaj4gxFSAbCPNIfMpEcyjIgxiRt/A5mswMmjF7exVwzA5ofwBZRY2n3WJJGOcY2ixc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739973877; c=relaxed/simple;
	bh=62Am0izsmS9C2hPRXnDyGTgkNQiZ0jyQ71jnzYXD4uU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QKjkcCbysHIufkEgzd1AWApKnBupyE1z1h+wHl18AQCaMhrxhLwvkAgINjG42iv/A3p4C5Tr+OaCWAcwUcDdk7mIoPw8scHQ+gb7xN82XbvgHNj0tnbyTt7ic47Ine5nK0LW6s8fHkANGU/vmSaTdxBgbEo5dnRFsMer6ZR+cxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LVBJfZrs; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LVBJfZrs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SMleK+F2DGv/GbPw5pTysYJA9kYGlCmNldc6KRWlGHzFodGJNg7B0K1LYo4qcWkNWz/Wf4Yi7Q1hrd3iLPWQCa5hqwk3wVjwwvZWv991TVDTxf6lNLHUNZICee3b7SkbZhLT6fpIrJ8gckJ+3vnPdYv3W1ZMigA5a9Fm4IMHMh1iwMMgSkb+ONyCIjxEZl+uXrl48VEE5x/qcvoD7122a8sgqBz2LHdYkKJ+aNSOY4MIiMHTvatf12gPCGqmsppyj6WWxIpfZTEHAk5Q8PCcndXNLwIqXdPEwLE7fARjOWz7DwhAT7dsE+Lj0eGpzKaaIK28Gtv56hUW/G830/daxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9miJOb1scaC3INaqqnL+UGberW+FFLLUCxrwzdhijw=;
 b=HMpydMyPwmEsO1nPILe1kt6mG4xPD8pxVUS7ZW/zNq6X12jw+beFUHRgGeCBij8SDFAiq9ZBF6Ns5KJzJeaUDpVFkaBCc4ltHZuMxLVIyEUwxL2OQ0rBlVHg6JPgYCu+wqo9CZCu+p7/P4P5Ddw7Hg+Yh0jnvwyiE1oECHCXrjENa9RILbQ7Au4mmOu+8onS5U8taiSVhaXRjKQPc6LWB1WmFLfAx+ChrvWVuFFEw9FYJXu4vDyG+VzcBK+hD+JHuZmHbwFcstzSYzyqfaXMjo3ME30dFiRYKmA2bIQKck15Cdg55kDErbjmCsWOcBuv+GAbEqus20srngGpfNLfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9miJOb1scaC3INaqqnL+UGberW+FFLLUCxrwzdhijw=;
 b=LVBJfZrszyGz1z9Vj+P4SoyNdkTQf84bAbhzR1F/pWYikZ+4woGlptAH/oftR3E0vFqA/aZGxRQ0C9uwOjb2Swrm9+DX96CKrj0hm/PcyrH//2ttASWFz/295BSjCmYnpjnhCJ0s2RRQvLI3QgDW+9mNobprEyXMmz+y1BW1jXG0uwy5NkqJHnXPsgNi7De3QMraav7iaVRWXQqKF4THvOCfdCEbtoKZb33MDwxkh3s0OGWVc3OFEC8n+i5ZgUc6SN+BsuwbStZ74h2ZDqbBcXN3GojGng7onYEowcr5zT/sLy/34ZFsP/on4G9rTqVe6HCYvWgFyOkXsHGIUNhorg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA1PR12MB7344.namprd12.prod.outlook.com (2603:10b6:806:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.20; Wed, 19 Feb
 2025 14:04:32 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 14:04:32 +0000
Message-ID: <15f46da3-8744-4aac-bc2e-ecf06ea3367d@nvidia.com>
Date: Wed, 19 Feb 2025 14:04:23 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250219082601.683263930@linuxfoundation.org>
 <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
 <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>
 <2025021938-prowling-semisoft-0d2b@gregkh>
 <b686ddb5-aeff-47c2-ba94-b6be9dbafcc1@nvidia.com>
 <2bb3354c-7f77-b07f-55b2-ac3bf5159532@applied-asynchrony.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2bb3354c-7f77-b07f-55b2-ac3bf5159532@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0498.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::17) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA1PR12MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: dc44545b-f5f3-46a5-f2d5-08dd50ee5506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y24wSmd0U3JPQmxXR3phM0p5UGVWYjJLem5rUTcrREFVck5lLy9TSDU0ZHIx?=
 =?utf-8?B?VkpTTThCNHA5YjQ3d24zL2xyUk1RelBJNk5WSHFWMEFvWTF5eTAwY3IzdGNv?=
 =?utf-8?B?SWFtWEVtMHJncWp2cytFR3ZiYXdhOXdEV2FlQU9nSFMrWDlsUnBqd3p0d1lX?=
 =?utf-8?B?dlgwUnN4eFZKaUhZV1hrTmczNW54NytnWG9xbjU2ZHJEQk00WE9od3RPUTg3?=
 =?utf-8?B?UWV5azVHcTJ1ZVdhZFhtK0s0a3B0S3IvbVNVQndXcjlrZ1Mwenk1V3pKY3Zx?=
 =?utf-8?B?WDZzVmpCM040VVplNFZ4MUJlZTdEZWpndUNtaWVsTVFpM201TmFJMTM4NWRU?=
 =?utf-8?B?N2o1R1ZiVkFXeC8vMmFkMzZFUjVDYlhEQkxuSndqQ2dpUTBZSWFBaDJiT0VG?=
 =?utf-8?B?LzdlZ3doMDFsOHpTR1Z0TDNHc0VQb3FXQ293alM4UENMU3pJM2haY1VuL2JX?=
 =?utf-8?B?UVVNdEtjTU5nZmRQUVU1c0pTYm1HWEdydHd1MCs5bXZEQ01lS21NRkx0R0JC?=
 =?utf-8?B?SjBBNk5DaHc3SjlaZ3lKWk1idTdkaGdOVDI3R1BaMlZJKzlNSk45U1puVUJH?=
 =?utf-8?B?cTFrQU5yOVBnVkJvSFVkdnBJeVNMbDFrTzdhRmpzc0dSZmZvbGNCczg4Y0Y5?=
 =?utf-8?B?VE9mWDloTE9CTEVLWVBGQllLbTN4N3VUKzdFVUY1ZHZ1cWQ5YW5RdnRaOHZs?=
 =?utf-8?B?ODcrTmVndEZ0MWxwWUhFNHk4ek5wZFFjSEQ4WG1tYmJEZ09rNmhLY01VdHV1?=
 =?utf-8?B?dCtZb3phOVNwSzJKeXFMN25jZlNQK3JCZmdxdnp1ZUV3RFJYbzJ3TXRvTHc1?=
 =?utf-8?B?Z0dSQlEzVTlaZ1hHNGx1VFBUMWFDekZXV21vbUJ5RlpudU43d05uWm96MHRX?=
 =?utf-8?B?Q3FwanhGeWExYkFzRENscFhiNmJVZitEcTZIMWZzZ2VEYjVURHFpYTFEZEs5?=
 =?utf-8?B?dU5RRnJQY3pEekh6OTlpc2EwdzlBcG8zSUhRSVd2QjBON3lKYytJVHBlbnAv?=
 =?utf-8?B?d3JHd25tV1VndkkzVXRZcmdrbGxtdDNWK0Z4OGpWeE1MclRIWWZFWFZMVDIw?=
 =?utf-8?B?TFB4eEEyNFgyN0hLZFh6em9uYVZBYVkvMmV4cnBXclZHOWkwTmRhWGlhNENk?=
 =?utf-8?B?eHVDN0x2akNCQnhobkNTSDBDYUxJTXFIRGIvdWViaERQSkQ2VTVmVXBSZWhq?=
 =?utf-8?B?TjMyZUZEMVJFaGpnV1cxaDQvb0tOcVc1NTI4MDZkZHpWbThEZmFpbmkrODNy?=
 =?utf-8?B?N21oOXpSaWh6cHVPdUYyaDd3eUF2WDhBVHVpYVpieXNrNGEvNDNraFBnTFow?=
 =?utf-8?B?dGt0THVSQndwaUpTWTBJdXZWOVBuTzBDMEVjNUFjeHpmMnRCRVhZQ1JVL0FW?=
 =?utf-8?B?ejlOemhQbW40UlVLaDlSeFF5QUI3NXh2ZHBlL1VGZDNqOWU5Vk1Fbk9IWUli?=
 =?utf-8?B?bnBpRk52YWhIVm50R1dhYlB4NG1SQzFRU1pPaTlTaWRRM0dLQXFpYlFNYjY0?=
 =?utf-8?B?Y2hNS29GZ3JJdlI3UU1Mb0ZEYWsxZGNzY1VtOWF2aEV1Y3loUzRsKzJNZU5j?=
 =?utf-8?B?VWFFcWxDVFJVQzhyZnBLbmFtaDR5NVpad29uUnErNXgxSmgySzBWdEhISGNr?=
 =?utf-8?B?Ukk1Q01rTmlqM2ltTEtTNHIyVWYrR2VNeHVlSGduRkVtOExEdkdKSGsySk82?=
 =?utf-8?B?d1g3cktOTjRLMW5lNEc4VXdsSWdEckI0VGs3VU5YaVlvaVFXY0thTTlNTUht?=
 =?utf-8?B?ZUh0SGpRVWhvaDJaN0J2T2lHSUc5Q3l4UEVzZldZT2J5ZjV4TFhCUzBoKzVW?=
 =?utf-8?B?alNBNkN6b1pYQjQzeFBTMnRGWXNXL1hldUpMVXZXTFRPa0tMYm9NU1dBSWJt?=
 =?utf-8?Q?Ve85S/OX3bfgG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3lqOTQycGtiRndacXNHYWZkZ1ZxMTlIaXcxN2NSWXhEcXMxTFlXeGttK1ZB?=
 =?utf-8?B?TTZRSFBHVWN0cXBzQkM0T09wZ0pBTU1Kbjh3VHUrR0s0ZlczdXd1dVhNMnVH?=
 =?utf-8?B?cTQwa1FidkM1d21iVmRWM3czVTR6cTUxU1d4ZWdkeDJ2SnNMUndGR1hjenpz?=
 =?utf-8?B?V242R2tyWTFsVFRaUUp3SDIyVHBsVnVQQXVzektCQm4rRXhXamNQSmNVQXJL?=
 =?utf-8?B?Q0dkcWJrSW9jVmNRM0dnaUVvdEMxR2NTTUdHZUtJY3BwNlRCSS9pSDBaZjVC?=
 =?utf-8?B?a2pwWDh5SmtWRElYbWIvc2RWekVLcnE2Ni9RQ05IRGs5NUx0Tld6SDh5K2Rk?=
 =?utf-8?B?bWM3dVViRGNqbnhZc1ZBNmgwV24vbCtxVDJ4STVEd0pEdjR3Sk5Wb0NIYTgv?=
 =?utf-8?B?M0RRSzUweUZ4Q2FqOGk3TkYvcGVMZ084L3ZuZlRBR3NxNEZ6NDV5Nmg4dmJy?=
 =?utf-8?B?MWhYb0ZvTm56K0JCUjRyNGFua0JTODIxc1VVaUpjVUxFZnZ4ZmM4Zzc4STd5?=
 =?utf-8?B?d201OW1OVEF1T2pCdDlRQ1JRS2ZnOTM5R3RqQWs5V1cvakRpdys5Q0d0bTZs?=
 =?utf-8?B?a0hCVktrQno0cG1tWE5hUDZ5Z1VHdTRSMlp1eWVOOGhpdjhjbXVhcWpVOFlP?=
 =?utf-8?B?Qnhnb3JiNVNoQTQxbmlBTmpFQlFCanN4TVJZZ0JJYU1zOG5WTnNTU3R4Qzl1?=
 =?utf-8?B?VG9KeFZiOXBNQjk3U0JuOTY0dlprK3dFWkhnWFd3VHA5RkpKblBTUXNRLzNF?=
 =?utf-8?B?WWs2Sm42QmVnNEZuRThvTWhqYzJJdTVXNUpLR25JTEp3a09pNm5VaE9Vc05k?=
 =?utf-8?B?dTVSQXI1aDhaMlVrd08xVjIxNWNRZ2d1TjYweGlCYzQ5ZWE1eTlBbUhxYkZj?=
 =?utf-8?B?UnRhODJnRnN0dVF0OUFaQ3dzV21oeCtVUXNXQ0NLQ09jTWswOWV6Z2FEMTV2?=
 =?utf-8?B?b3I3Y01UTFBJVEc1ZWdrWHpMdTNzd29xcXFKc1VZb2RJcjVGU1pQMHZlRDFY?=
 =?utf-8?B?a1ZETHFhUkhKazNvcHorVWdoZERWZ2s1ZkgyWUNIeGw3RWYzbVlkajFOaXYx?=
 =?utf-8?B?ZG92Y0xmdkZhbE45Q0VZZXdhdW5BeVVqdHZERmpXL0lUeUtwY1BKbExWZXB6?=
 =?utf-8?B?UzBINXN0SHh4SmJuNDYxSS9LMEFjeVdRT0t0Wld0bEU0cHRleUU1OUlvL0pC?=
 =?utf-8?B?RC9qKzdUMTlWb3VaWHRaZk9EeGtyOS9XUkhzVmpHSm9FY1ZiYUlhU3hjd1Nn?=
 =?utf-8?B?c1BLbkNOYkZ2d1VpWDdTRFV2Zmsrc3hnT1dmd0U3ZGF5T21UZDJ2dFpmeGlW?=
 =?utf-8?B?N3pSMHJZMHhJcTgwVE1KRytKbFdqTThLVUFwUUVNdkhVcFViY2hjTkkveklX?=
 =?utf-8?B?QzZiNlFIajl1SmtUdWVYNGJHRGt5Y0lZZi81MlBHZjdONnlvbjV2RmxSL2Fm?=
 =?utf-8?B?S05OK0lsMEtjSUJVcGw4U3o0NDNWQ2ZoWVZKS0JRVnQ3L3hwL3drMnhMeXd4?=
 =?utf-8?B?L3VJQmVRRzk5eGVUMU5iazFiL25YSlhqNE52dktxdHRzTWlMWGV3NEFlamdo?=
 =?utf-8?B?YU9zRWxZckoyb0NYTmJ0Vm43V1BLRW9SL3NmaHh6a3BBdUorWGd6ejZFNjRD?=
 =?utf-8?B?T3crbHgraXpYSDJKL0FTRmp1amlENW9FUjlqcjhXSllUbDh5dmVVZk5RSXVW?=
 =?utf-8?B?bmwySWFSRmxwdG1GVDNXMnZTVU9SQmlhRExKVzNvdHdaNVFmbUd5Y0dUdUZQ?=
 =?utf-8?B?ZkRvWXdqSm1YOGNQd21FdW5rU2pweHZlU0NHSVp1M3p2Z1BXbzN5ZTdEK0xz?=
 =?utf-8?B?RjdOcG5OM0xNUGw1aFliTmVSR1p5Y3oyOWMvMnFJWFUwaTd4ZnBvS2lLVVVp?=
 =?utf-8?B?VllGVm5xYlRyOHJlcnlLeWIwM0wvNDc2VWhPQVhVL09qNVNSZjc2NFBuQW15?=
 =?utf-8?B?UlVVcDRwaFNtWHlWWmVRWVhLRG9iOEczcVFkWThOMHBDbGg4RHZnV21RQnU0?=
 =?utf-8?B?eUJVTnNqVVFONXkvcVdnRXlOaEZSaHdBTFdjeWh1aXAvOFZoQzZjbDVwV1h1?=
 =?utf-8?B?d2ExU3V6MVYwQmRNYkxKVzNMM2ZJS2pRbnBSbjRiUG5mWTNicFNVUmZDZUlo?=
 =?utf-8?Q?HP6dqPr0Q3xRIiKmiKcxge1dz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc44545b-f5f3-46a5-f2d5-08dd50ee5506
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 14:04:32.0032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6EIm7hq0qziDX8j2EhxJGu7ZcEtlHD4nL0ulZRw0ZpLQBT5Cwh04MeoQEpjcD4+QpsAcKdglmY9H9I2P5gWXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344


On 19/02/2025 13:55, Holger Hoffstätte wrote:
> On 2025-02-19 14:32, Jon Hunter wrote:
>>
>> On 19/02/2025 13:20, Greg Kroah-Hartman wrote:
>>> On Wed, Feb 19, 2025 at 01:12:41PM +0000, Jon Hunter wrote:
>>>> Hi Greg,
>>>>
>>>> On 19/02/2025 13:10, Jon Hunter wrote:
>>>>> On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 6.12.16 release.
>>>>>> There are 230 patches in this series, all will be posted as a 
>>>>>> response
>>>>>> to this one.  If anyone has any issues with these being applied, 
>>>>>> please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>> The whole patch series can be found in one patch at:
>>>>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
>>>>>> patch-6.12.16-rc1.gz
>>>>>> or in the git tree and branch at:
>>>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>>>>> stable-rc.git linux-6.12.y
>>>>>> and the diffstat can be found below.
>>>>>>
>>>>>> thanks,
>>>>>>
>>>>>> greg k-h
>>>>>
>>>>> Failures detected for Tegra ...
>>>>>
>>>>> Test results for stable-v6.12:
>>>>>       10 builds:    10 pass, 0 fail
>>>>>       26 boots:    26 pass, 0 fail
>>>>>       116 tests:    115 pass, 1 fail
>>>>>
>>>>> Linux version:    6.12.16-rc1-gcf505a9aecb7
>>>>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>>>>                   tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>>>>                   tegra20-ventana, tegra210-p2371-2180,
>>>>>                   tegra210-p3450-0000, tegra30-cardhu-a04
>>>>>
>>>>> Test failures:    tegra186-p2771-0000: pm-system-suspend.sh
>>>>
>>>>
>>>> The following appear to have crept in again ...
>>>>
>>>> Juri Lelli <juri.lelli@redhat.com>
>>>>      sched/deadline: Check bandwidth overflow earlier for hotplug
>>>>
>>>> Juri Lelli <juri.lelli@redhat.com>
>>>>      sched/deadline: Correctly account for allocated bandwidth 
>>>> during hotplug
>>>
>>> Yes, but all of them are there this time.  Are you saying none should be
>>> there?  Does 6.14-rc work for you with these targets?
> 
>> The 1st one definitely shouldn't. That one is still under debug for
>> v6.14 [0]. I can try reverting only that one and seeing if it now
>> passes with the 2nd.
> Most certainly not - you need all three or none:
> https://lore.kernel.org/stable/905eb8ab-2635-e030-b671- 
> ab045b55f24c@applied-asynchrony.com/
> 
>> [0] https://lore.kernel.org/linux-tegra/ba51a43f-796d-4b79-808a- 
>> b8185905638a@nvidia.com/
> 
> I was about to link to that.. please try 6.14-rc and see if it works for 
> you.

6.14-rc is still failing for this board. Like I said, and per the above 
thread, that issue is still being debugged.

Jon

-- 
nvpublic

