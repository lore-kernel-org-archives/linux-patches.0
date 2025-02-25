Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA51267F77
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740483969; cv=fail; b=KTtaZTnfw0ohb7QX9nsKffmpbWBARLu8yjezn5oVPVFV9qlZzi8sx8CUJ3ASX6aCIsRJAi+cd973IlfUYxZA2fKmLRRNl8Ymcdp5WD1xwokTC7FD+e4kVosS84cn0fkxWGNmHHUlL8XDH8UC2Dj9t/MQ1pP/Zap7TJaCsRm6BXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740483969; c=relaxed/simple;
	bh=sL+YKROlHcmGuZr7Al5LC09h2TpeTgpaSPUNkEwwaRA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FASrVr9BP5VFeQDN44hBtmvAysVwpXeKRJ5mt8xGlG9Y/DdXEYVHjeZxbSthqJM7IyiNH6PMgc7jIIGToQwgjWAEiJM8j7C+cTWu4mmlwjrKAj3AqrHUTit0iywRqrx17AEBgOU6/X5ekU36LfaleLw7MwCZs5s4O6eRDUUJruY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nrKOG5Pw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gDxupd5G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nrKOG5Pw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gDxupd5G"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PABr5Z019134;
	Tue, 25 Feb 2025 11:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5n8e5jyMd+QizXwD65YXpDgeNrVy1/14bGS3WvZ5q2g=; b=
	nrKOG5PwqZWsjlk2jPzQBspvLvwfyW/23NXJ7ZN3GX2RhSQBLUMzznx6hTLBOr9b
	HNG9ADs2WFH3GZG7wi5488RLfsvAbbopMOrOrhRQxbfVDAr1Av/w8QK/Cp/VstJ7
	0OLa4OyniUKP+alBxILqaB+qm/FPdlxxTJwg69q1y6hdT5ELMrhp7NLt7DuAH6cg
	1dRhySLOcHWK/YBXGTLJUEirkz/GiTxOwHcZZtYUbXlTdHMLpkF5LPoLCKjcpVbV
	4OHf31HzfZRo62BotpiTejMKnv8A9YNIdUM78nDaQOS0Y0lPe7OqZ8gXLZ5JhsNA
	p8X6JpTXLjyLr0njuP5LWw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y66scusn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 11:37:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51PAFo5o007383;
	Tue, 25 Feb 2025 11:37:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51f1xuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 11:37:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IhCz2eV6XUWa/xT4K3Cq1khuk6TO3rP6uKarYKeyLys4ZAYoZX6PEDJyE5WMKxp6eGN/29/FBykI9858+QhrapuWm+2gnzGURYjRVfA0OkNrU47Guyynw7qSQ2QZKy/lPvvKtyssJkIgPZGnfu0cTii0ar529PX90mOhVHwf63UXn1uR6eV9I046/NnyNgUjjk/5uNaC1bhEFOXGal3QbWrFGjSIlKznwih9Y9UVG+01NyRykRVg7cuqb3T2z0asqUE4c5lo44IsMOLdEoTPW4I+TfagbMYnhD6I3yAAcLFm33k+Zu+/nSaSDH3dfFzycB60R61rTS2XZxmKL6zutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5n8e5jyMd+QizXwD65YXpDgeNrVy1/14bGS3WvZ5q2g=;
 b=yQeMXw6uXx6yEK5WncuRSH3+wclONQ/zJ5AIyNz525kOTlwD+vx4PFSAgSsbbldc/8f04kj7z2GYGmctOeseTjq3A2UP1bSLbf31yJNUErPsZB3lyANsG0MSDVPbjaQ4Xx8dBR2UbMaK0Fs6cu2LjgvXGRlpgkD9VxlsLEsFZOCGQ5853+51w6gQ7PNOZrqaubcmoN3LKKdF6ejYqznwmCcuzF0ehIMjkJGiBIwsxcusYgmBsqGe3MC4Vcgxy0MFecSrrUmCXI3Jb/5C7H0njinoPbpu0kvuOdtuW+Sdoj14QCVVzi20nut+mhoMDqfC4WnQn8/7fAutTAiJwn3P0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5n8e5jyMd+QizXwD65YXpDgeNrVy1/14bGS3WvZ5q2g=;
 b=gDxupd5GtyUTKOlEhKe1ofZDlFewlCjGepgrDQ4RyAmoV2163kN6bHFFQxb8zVZFj6AYvGrZu4PCWX5TEKHyOAZ/E1Udi09xQErH5ipwoWsEKDoZfSkJoZlEUGCdTFQ22C7b9P+rRmMHpPbdX3ctmHeMpqSc08zASjUz+ek45D0=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DM6PR10MB4331.namprd10.prod.outlook.com (2603:10b6:5:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 11:37:54 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 11:37:54 +0000
Message-ID: <05f802d3-f8a4-408e-93f7-cf4cbfff9eaf@oracle.com>
Date: Tue, 25 Feb 2025 17:07:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250225064751.133174920@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DM6PR10MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: d38719c9-346b-479d-56db-08dd5590d805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MS8yRmMxd0NsM1JLUkxSYzVramZMM05kV09ER2hFMExMWlJXSE1iUXROREdt?=
 =?utf-8?B?N2tuR0U4YkhYV3k0RlRCTTlEenVIMU1GUWlZUWpMcCtBSVNXRDgxZ2Q5M1hD?=
 =?utf-8?B?alpiSk0vWnhQTEFzbnJ0TnRwZnluOGR6aVFJSmVUbWpZbnNkMk8wRWp0V1Ra?=
 =?utf-8?B?V2w0VkhQNXVrK09sOEZOeFZsZ0dVS3JXYkE1OFRVdkRleUxhWEVYY2FjeWF2?=
 =?utf-8?B?RVVDaThKOGx0VEljYkxPdUZyZXUrU1dXQmZLRW9LRWNwUmJldTBRZElmZ1ZM?=
 =?utf-8?B?Q1lsZk5qZXdtSkNYaXpWSVh3WllNVHkwTDVPVGhCeFY0ZlZKZGVXbm9tZElr?=
 =?utf-8?B?T1N2ZEp1amt4bjZGZmRCdVNGSDdSUDZEQTlJUXJJdGNDZlBtbldyQ2VQZVNN?=
 =?utf-8?B?VTdlYXE4bHRDSGZaK0NOQXpKcXA1MnIxMXNEOTE4eDViZ25RbDB3Nkh4VWRm?=
 =?utf-8?B?Vkg0empIRzhmeVdYckc4YW5uSmhvUExkZU45UHhmMy9aMUxtR3RiRzJMRFJE?=
 =?utf-8?B?Y2J6d3ZCdW14U0FEZ09WNnNXRExZMjBDOHNpcjl3Rk1EZVVtWE1GcDNOQ0sv?=
 =?utf-8?B?RmVvNmVoU0NKU2s3cnNmZGxsaFpRSFdCaGdERFZIQksvN0d3citRUlNzYXk4?=
 =?utf-8?B?WU4xTVF1eGhrcThSYllwT0NCenFEdHl3aXUybXNiUGlyYk11YmQ5VCtmYWNy?=
 =?utf-8?B?aDZvUUptYzNncmt2emVpLzFqRWhLajg4Yk81QSt5TG1yM3VzSVNCQ01WbWl0?=
 =?utf-8?B?eUd2a3BtL0dWWTBPT1FlV1lHbndsRUJIa3BIMUlJczlSczNxbGhic1dBN1dY?=
 =?utf-8?B?Q0NNRmlSTEtrd3dsaUkzdHBtK25tbFk1eGtmY2N6ZGd3Z0tZK095QWZ5bE9i?=
 =?utf-8?B?NjhYdnBoZURwSFRCbXRKOE94TkQyR1YxQVZTK0Z2aFExeEEyVTZZSFBoOWc2?=
 =?utf-8?B?ZkdxQUFBUml4N0tHVjZLc255aE9ZRUM1TDZ2Z284MkJ3dUpBdkhzZHJoSkVG?=
 =?utf-8?B?Rk1yLzR2Y2dXcG5OY1FBUFV6elM0R2xLR0ZQMTZPclNuS2FOdVQyakEwZnU4?=
 =?utf-8?B?dmorNWg2MDcwLzJydjhsYTFsbndxTllocXpuOFd2SWtXRit6MjRwRFk4WVJ3?=
 =?utf-8?B?WU9Vd2VxY2hIcEVYU1F5cUJ5SC9NMzIrL3pWTkMrQy9DYWxyRmFLMnc5dmJQ?=
 =?utf-8?B?cHkwaWhHZ3EweGVIZGpGK0NSY2VCbmhIeWVBYWJYbVNxSGViUWx3d1ZIb1pW?=
 =?utf-8?B?Mzl4NTMwMWY3STJoUFc3emxCNTcwOWs3RGVrQ3dhTmtrNU81ZW5yOEYwWEg2?=
 =?utf-8?B?R2czbCtuS2pyK2Z5SkRCajQ0UDRDZm80UFFMMkpHSUJFeXovenV4dS9vNEJV?=
 =?utf-8?B?MEhyY3h2NktVOTVNM2l3UnJMOU5Mb0dvS2ZTaDZaU0U3eStuS05ZQkhhdjRR?=
 =?utf-8?B?ZDY3VVc0Q1J0NWRxdWFzdUROTVZBS1dOTmFXYXJTUThMWFBrUzYwQklvMjFq?=
 =?utf-8?B?VHM3ZVlQWS95MzRDODZWSXp1WVg3OVYxUHVBVzRTU3c3Q1k2WFhCMFVOQkc1?=
 =?utf-8?B?ak16N3QyTDljNWhleU0waDF1QUV3cU9TUDVQZnBHY2NTeXRDZmR6WUlpM2Rh?=
 =?utf-8?B?eGtESXF0NlVINk9OaGhMYWlCT2dzWHZIVzl1eXk3YmNEMzM0RzRLMEQ0amI1?=
 =?utf-8?B?bjFSNVRXS3ppNmJ0N0ErNUNlTDV0ZXpxcFloYUMzdEtFODhQWHlQTnFTQTR6?=
 =?utf-8?B?V0F1SzhiNUdsaWtBdUl4bmFCUFQwMlkwN1NaVzcvRnMxeDQ0eFhQVXpjQ09o?=
 =?utf-8?B?TUJqNXRlNm8xL3QxSUp0YXlCTElKZkhpVUE2LzBybVI4bkRteVQwNEFYUVcy?=
 =?utf-8?Q?/7U/R5EpGoRjn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHJULzg1TkpkbHI0VVpvNUNpdS92ZzJIUGVxN01wemVMNHVQWHZYY25BbGh0?=
 =?utf-8?B?cGsyNitUMlNsejdMKzg3RG45M1ZvSzh6TTk0WStQaGJkQ2hMZ0lCOC83QXhZ?=
 =?utf-8?B?MGFFSjdlNWh6ZWs1czZYek94TUU4M3N4SlRBVnBSNFBkWUpGU0hrSXI3MnIx?=
 =?utf-8?B?bVZtYm9hakF0VkhUU0JpcDZBSjZYaVREMXJJZzZJREwrUHlPeS9vWnMyUDJK?=
 =?utf-8?B?WG93cEhSaGkxbGNESzM2K1MzeFVKTDVVVElGZXJjR1hIWURJaCszM2tuRlda?=
 =?utf-8?B?M0J4VWJkNnNtY2pSamdrZVBYeGdyc2JHdEFWd3MwYldZMVpUT0FFblhUQ2tC?=
 =?utf-8?B?ZFl0Wis0UXR0YnhWVWcvQlF4SXFTZEhGVEFrN0hKazkrWlQ0cFRBYitpeHJY?=
 =?utf-8?B?NmY2R3E2T1E1bU1iTHA4bGRHSTRucWdLMEhPUXRuZWEvaEp0K0F4c0oyQUxF?=
 =?utf-8?B?RTZsYTNPU3VheXRxMjg5Q1BWY1ZFM1RVcHJFekxJMnhOMjFCTDhFKzJCS3gw?=
 =?utf-8?B?UmdmRW1PYXF0ZncvZThQRDlLdTJxblgwWVV2ZWRLRkZCQ2tnTHNSSWRhRnVB?=
 =?utf-8?B?Rmwwb0N6UVkvdnR2UzEwcGhxeUhsKy9WNC9tTkx0MDl2SldMbldhNk1uNnBp?=
 =?utf-8?B?aUtaQktoUk9jbTJXSWF4Umg2S3o1NXJ4Yk1LVzd2WXVCSVRMNDlLOWErZnBo?=
 =?utf-8?B?dDRpbXNvb01pZVMyM2lNbmluQ2FLV240MGJBVmNTVk84cTBKaVJaV3FJdExI?=
 =?utf-8?B?bmwwSndxM2graFJRYjFrSGxKZWFmaEl5azczYllESm54cVhwT0hPSHFoUFdv?=
 =?utf-8?B?TUNXWm9iRFJxTFVGRER4MUZucWtVQXJZWmhFemFTWlZaRUlRaklZdkVuN24w?=
 =?utf-8?B?WkxxR0kzRzVvZW9reGYzemxZQ01ORlAyb0F4R2VJMG5qRFRqZEt2akFUc0dI?=
 =?utf-8?B?YmpsS3pUWC8wNDdYNXhGUVlhMnFYcGlXc0treFE3SFMrV3owYzJiUytvdHNv?=
 =?utf-8?B?N1M4SlNNVisvRlVqd3d6OERuVFU1Y2wzUzkra0k5dERsUWNYNzdsTVBBdC8w?=
 =?utf-8?B?QjlZeGc0SGxEaVJEZW9heVRNVFlzYU5rY3o4MDdxaVZVbFhmUUVWNHpiU09W?=
 =?utf-8?B?TTh6U1F4SXdPMUk2UXhHRUtUdU91ckJnaVJKak5YdytaMCtsY2Ntdm5DR2Z6?=
 =?utf-8?B?V1B1WUsrSnVWRnErQU1uNEdKZEs4czlQYzZBZWFld2VlUzBiMm5OdEg0ejd3?=
 =?utf-8?B?SzEwSU9xM21JUTVtQzRWUGlRQ1lZNGs5clhHWHp3eWowcm9ER2hNVmpGenpD?=
 =?utf-8?B?TjBUSGJzZHNFUS9VYXJMdjdmQ25sZzBQWWxqMEdkNUF0bnltcGlmWStKSWl2?=
 =?utf-8?B?VzB1OElOT0F4OHk5R2wzOXNIUXcvQ0JWYjVGaFUxYTBhZTZlNEFwMitoZU1R?=
 =?utf-8?B?T1VoTjFNc3ZmNjdzUlptbG45RUl1Rlk0WUoya201RGpwelZCNHIwK0pWRkFU?=
 =?utf-8?B?SWJtZjNwMnRFdGRyWlhtU1FYeVcramxteWRCUVhBUlpSN2VwZUFjVnJlRU1n?=
 =?utf-8?B?N0x3NmJRSTBsRFJremwzbzFRSEd3RVhlbUFoVVNkRy9VeldqNGpuc242ditr?=
 =?utf-8?B?WnkrS2VUOVV5WHVuTzErRmRMOTFGWWNYb1k1blQ3MFdubW9Cc2c2K3hWUExr?=
 =?utf-8?B?QmR1Rk9kSzM4UzZwRU1ENzJiRFI0bDNLakw4NldLSWxXK05mSFVLbEFXWGdV?=
 =?utf-8?B?eDdPaldEbFpuNUMwL1QzdTdDSVI4R3ptaFp0aTRpd20zNUhmak9TdmNWTzZu?=
 =?utf-8?B?Z1kyalZaelZJRXEzd0JyaEdQM3ZLQno3ejd3R0xma0JORW9PRGFPOFdNRFBD?=
 =?utf-8?B?eEIyL1M2T04vY2pxeU1KTXpnT3dadDRZNFVuTmRtcTlibkdQVERzdzgwU1ll?=
 =?utf-8?B?aVBZTGxGbHk5Q0VJcFltajB1Ym9iUU9MREhBUlpzMnJ5WTVmdUZhSzhXVTJD?=
 =?utf-8?B?WGdzUnlmVXhxWmtCSzg2WWt5Q0JHREt4SDlmRE5WTlZGdllCQ2M4Um4wR2xZ?=
 =?utf-8?B?VW5GWEFlV0dLNkJENG9ZTDd5c1VVelUrLzBDYmZKbW1YM0lJOU1aeUQwcDdq?=
 =?utf-8?B?Kzd2SFd4amlQNlNBbE1uSDVqekwxRmYzVDMzU2VIcUZGS0FvK0p0Z09mbkgx?=
 =?utf-8?Q?S/srvEHYzzlaF43thph5rwc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/cjf/GTsK1J81Ch9wv+ARcBQRPv45rn77Y3ZCM0XMTLRQwwT5WyWIV9XpEDzmDNBupEv8Qh8FzSSKb+bGUbGclfoHXlszxo0KTlFpFnK+Drnq9vBUCGNMCZBgUnEY0aMtec+IAgFD5Y9E3e6Q9OflgkdpsdjH1iEDIG/8gmmmr/27EnXSBvyZPoqC2iXGYhlPOwdCjAImEcKetApdKhUMoLpz0yf/I5QC5WsvcBSjFrr67EFFIQR1yiNnNX6dWy74d4JBfhhXDet9bSAjj8GPR8zD6ztaWaAhE3oukpUw4k03WoQtqJH449PVlphHhS25wDhKZfRY0Hn5ZibtKYH0u8o4xrFhDLZVJlBEI6WbfEsZtXPsolVDxO73PqDh1uocMpD5389wjEJnhO1vel5ajeDz0LVePq5ThhIcvV2q8DnKJfn76YsBfXcoxrk1E2I3WIrmmK0sF2N1QOLlb1DLfgavEVh2tXBman3AogCDeNQPjT5UV+VblOZA69n66fQ77jjSC955iYmLfSYFOuYwFev5mk1vfRFTh25qDgWM6P9fJgBpV60G6IvJ/10nJh7FqEPcGTB1e7XYoRQ0C8p2sSDT8veAsqD9/pasZCVwvY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38719c9-346b-479d-56db-08dd5590d805
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 11:37:54.7524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DedTZETrHeCnpVb7pxOITH2v2x7CS3w+VkvxI5BHyR04Qy0ge183xHNr8nLgInChYbwQ5m3RLWJnXTG0EbPI2o4YxXGhj85XeZ1CeRMJushpzJYQmYvoVJO2BrAhA0FG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_03,2025-02-25_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250081
X-Proofpoint-GUID: SioW-8e715EbJhukr7JiSzIrnTyWLXYx
X-Proofpoint-ORIG-GUID: SioW-8e715EbJhukr7JiSzIrnTyWLXYx

Hi Greg,

On 25/02/25 12:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
