Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFF729617D
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 07:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753945851; cv=fail; b=uTzobvIBZ5E1tJN5yP1PF9hBtkOr/4/+sD8XKI564EHcoWkzWuvkXEDmzeueFsvaZ0hO34Qc/ombvxoesC/+sNi4Mc9tYQOkvCPKawUsYvRWSe+OnyzGiobC8ErJ2Up/COiGOg7pgxDWCl5uv0AfaCk6r50WG1nyrTy3C/oetf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753945851; c=relaxed/simple;
	bh=WJSeurkxEZ6Q6atLLnZ4wf3Q02eEnemWKrwTtevnw0k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZMTyRekLNT8W7fAIFYoGDFZA2VRwxrKwp+3oVvogIFSD7QN+9hX+HBdD2gOM1sNpW1cvZ/QeuQ4echCs9umZme+6GTpB8kTtBvFFO9JLvREKVSUx3q4AtW2JoJIOYY4vHrE4d3AF3gbettTqF4UGtWIdwBorYeRfREvwWa6y8ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eiEVdJVi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dz0NWlZ2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eiEVdJVi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dz0NWlZ2"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V79SGk028843;
	Thu, 31 Jul 2025 07:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wvVUuk4MasJR6ulqSP0HxIhmsmlKfaafWu4UhuZHUBc=; b=
	eiEVdJVi1mBNE99iCBsq6KTMpn2D4jfsqfUqG66o9P4QxXdFOPMlVFI96lWkbJkx
	WDZcXhmLLwRpnCGlAS++/grdb1Khq4FIeBOLqeZtIFDV6R1642m9/Gj7HE36hr+L
	hmGilX3M7WVb3gdI6uBbBtyZVeGhrZg/JnZW/KUnPl+Uw6gk/qAyi1LnWbQbgs24
	9FISyytdD6niGE5mZ8mVuMVcrfZ+7fXUv+wg8mQiQlis7pRvMqLX2JsOty50WS9D
	aHWWKS3xC0OGawp/5qnb+M4P0a5I/rhIjeLUBFqHK6J0/56na37ThEi1UX4eQg0h
	wAlKsQeHLm7fqWGQwVChKw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q733h75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 07:10:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V6jFUT020947;
	Thu, 31 Jul 2025 07:10:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjew7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 07:10:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BvSg0zbAqQ4SMnZZL9H6pr+zV/cBFcokgCnqA1/20ebvQ5SOqfpGjcUIRHzJ6jShZ4+dHzIjAHjIou+5TXLiA8xXUhhMvQZpuWSTvDE6Dt/F8hX0Ioxs9JLgXpF18kv1cLC8M7gtaBDI4wqHeRQY4NvFJUneP+RTWWBtLzN8J/y2f6P9wjQJz+LurT8AU1jV+7oGuGLin6z3fpTL0C+shP6ZFK30VGuG+HTWleFY03+Ho5tprOUQs3QAY/g+XmrMwcpDK7bclPxakgKozx/fSY8hlQWPm+kulVeMCdJwR3kLGeiOFxJO2jPZI9Pwa/V8Ho/F7lNlDoEj4zla72jHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvVUuk4MasJR6ulqSP0HxIhmsmlKfaafWu4UhuZHUBc=;
 b=KI9IqOXVWAj/8DUYMgBdWhpxjAJW6M0ybO+KmUmcYWv5byKsOQN5i2c7akuO49HwohYnxaiBVn4ldWLX2W/XH/RdyoheHltb6uWZoj3XVx4E2cs0z5F0gTyrEa3O/2ulChmZEwvgwNmWXkwQEabmSBPBaiR0qwbZ5zbg6YDMdGjTwDpzACLrTtyypQ6rnEq/ehzMzExnMppl4TmkfCPh+JD8Ed3QWCCefReepkGZKmuMILFHriJ/PLfVNYxGGpL5Z+AeOEmfgb7jvctIIzfneo7wr25YSAULBo4/gk5fJ4OyCi0PJc25v4bigNTbZjLo0tudgs9RtVD4vX2dmIdC6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvVUuk4MasJR6ulqSP0HxIhmsmlKfaafWu4UhuZHUBc=;
 b=dz0NWlZ2ceSa78575FnthXS+NGyDLqKcpzskHFKGoQ48EUVnwjiO1MZyfNzasGqCxsUo3c9lWYMb45VtVFoiuk1xkJxfb0JzIn7KNNx4AFsbXMHUwVaYnj2l9lFJGoIQOsewMfXeRlje5dY09AlVEYwjUn7prYKWrAB4NrlNUg4=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by SA2PR10MB4780.namprd10.prod.outlook.com (2603:10b6:806:118::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 07:10:32 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.8964.023; Thu, 31 Jul 2025
 07:10:32 +0000
Message-ID: <486e04b5-f197-49a2-bbc6-09187e8b1827@oracle.com>
Date: Thu, 31 Jul 2025 12:40:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250730093233.592541778@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0338.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::14) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|SA2PR10MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: c3037292-a2d0-4a48-fcd2-08ddd0015687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmwxTFVQUjRZUE90YTlOZnFiQjNZZDJ5MTdPQWR2T1M5cHFXY0Z0VFRDRy9T?=
 =?utf-8?B?Wm5VbEphZ2l5eGZiVlIyZENzTmhUZGxncDNCdysxZDI1SzVqVkJyMExMTS9q?=
 =?utf-8?B?YVh1YWltYk9LcUJreDlCQ1ExV3dLWU9xNzdmR3lKVkFiQ3hHSG92SzFTQ2ZL?=
 =?utf-8?B?NUlzNWVYc0NYZUl4NXFYaEZxdTVPTWNiWXRJRGRKdlpHdWZSaTFYeHlhblRE?=
 =?utf-8?B?OSt5KzZJT2w0TEV6WVBLcThHSlhrMkZYSGlvbWJ5NEhadW5FUVF3MTJXN3Rh?=
 =?utf-8?B?ZVAxS2hubW94VTY4MFA3djhNR3o0dVZxVGFXanNDaVdwNzVsWVNNZFJ3c3Iz?=
 =?utf-8?B?Qi9zSlFNR2tOUmFyb3RXSlROSTlja0ZPaDYrSloralpVT09oYXhSUVFoS1NR?=
 =?utf-8?B?Qm1zWFMzRzMvM1hnMjlTb0V4RTVVK3Iway8veks1dTczZFVibDhmK1JtYjJQ?=
 =?utf-8?B?eWZmSDRxYWdTSU1udmxSUE9UR1lhWmh4U1NtYklIZVVORjFpSFVHV0lTNWl0?=
 =?utf-8?B?NkhaWjBieFhhMUZOWHdNMkd4ZFF3UHhSMk1qQnVLTklkcGZMTXRBNE10OGM3?=
 =?utf-8?B?dkJnZmNMbWtweDR4WWEwT0F0VmdiVFpqNVJXVXdQNi9SNU96eGkzdHVmY3pi?=
 =?utf-8?B?Q3RtMjlsOGxaTFNQaXBxblZRcGd4MXgyaDZZNitsNTgvbEMrem9Ta0RFUDZT?=
 =?utf-8?B?MGlmT1ljemxmK3padTQ4U1pSNXVaWi8rUGEyRmYvdllsUWJrY0pVUVZqVTZq?=
 =?utf-8?B?UVZiTCt3QlhFL2NZMWFHK05LbW9tRFVwNHBHVzh2TmNUS1Z2aVJMT0xCR2kw?=
 =?utf-8?B?UVVPakhWMVdpM0ViZ0dUZ2FTMFJFZVl2cDZsQ0JtQzFMOGU3cTVZeS81ckpw?=
 =?utf-8?B?RFNMV2pScE9YajhGeDJmZE8vaXpWUXBmNGZKYjZrRmZvMXF2cTJYcGFYRnlC?=
 =?utf-8?B?UzFxNStSSWZXTkxXMnRzK1BkK1RaZUx2NFRvTlVpSGFJUHN5Mmp0emtiaHNK?=
 =?utf-8?B?bjVidHhjbytzSEs4WW9ZVlE0cFJoek1ZT1lCWkZFUE9leWhZTDdrM3RuVUg4?=
 =?utf-8?B?dXZ0ejlLMHRnaTRIbnJiaHBMMk8zcXVpMDVOeUFZR3RGSE84OStsUlE3TFJp?=
 =?utf-8?B?WUUyTGVwdEpnNnM2ckNjSVA2NFc2NHYvNzRKNmpndTVuWDF0eCtzTmNFQUdY?=
 =?utf-8?B?MVdKMHJIOWk2YUNXckJKdkJLdHRxNmIzaXE3dGxFU0VMUnBiRTBOUzlLMG5Q?=
 =?utf-8?B?citWSWFGVHA2SFdVeWNaclhlRDVhV1BYNzU5enMxZndSVWhpeWtmQnh1S3RJ?=
 =?utf-8?B?LzV6VVdrRmxFWHRTdTh0OTNiN3BIakhkQjV3OGZjV3kxOUJyN29mdGdTLzU4?=
 =?utf-8?B?a3A0L21xTWthaGx2NC83Q2ptMlg0dGtIcXpVM0VTZFVsNmxyZG5nT0t6MG53?=
 =?utf-8?B?MUg3OGN3MnZUcmRZd3BxTE0ramt5RTJYYXlteURCSlpGY3FVQ05pcmtJMm5k?=
 =?utf-8?B?R3lPM09oKzN5WDZzMTA5a0FPaXA1WWlzaHFNVGJOcmJZbCtoR2JKdWphaENh?=
 =?utf-8?B?V3QrVTAxNjlnZ0w3NUN6YUt3NTV3WURXaFcwa0xjcWpBbzBMWmNiaEhUSEZS?=
 =?utf-8?B?ZnBVWWRSNVNvc2piS0cyVE0vNmUwM1hUckFVNmlkN2RCekxFQ2lYUzlHWG40?=
 =?utf-8?B?WUUwcS8vNWZ0NW5Kd0pHamZrN0ZhSUlBTng2MmRERG5nVk12SVBZRVNmcWp0?=
 =?utf-8?B?bGQrNW50c1JGcTFRM015Y0Jza0ZCQS9Ic1p4Z2ljR3B5K0FmSURIM29aMUxF?=
 =?utf-8?B?QS9DRTlzNmVaVmUzVjM1ZTJjRWw3cnhQUmxxRGtjZlM0ZFExUytSOGpvVEU4?=
 =?utf-8?B?dHZaVURnallNMFpMYVk0Y0VQdy91R1FwTUsxTk4vaE5FcE5pbjZ5N1U5dnBm?=
 =?utf-8?Q?mKaPOxDkrPQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2NtQnpQWHFTSmJUSjd0Y0dwV3ZJM2wwWC9VT2ZkY0JHZ2Rxb1UrUS9aWFJF?=
 =?utf-8?B?b01jWFduQlptTE8wSTBPWTFuYXNvVUIwOTRUM3J5dGxoVWNwVWpDVThqZEtS?=
 =?utf-8?B?Y0xtVWJ0K3lzTXhCVzB2amVJMU1zb0Nja1VMeWRZUFltVWZLdHhlcnM0Z2o4?=
 =?utf-8?B?andoTVNIclFhUlhTUkI5T1dXY3IrdlRla3dCOXVXejhWTWluR1VFU3c1UkVZ?=
 =?utf-8?B?ZGtTcWpPaGk3d3NSYytEL1ZPUWNveTNqd3FiVGVWR0w3YnZkU3FMRTJBN3Rs?=
 =?utf-8?B?U0hLRDRsQXRyRERCZlU0MWY1SDltUmxFSzUyYnFwVTVYRXB3OW54cXp5MnVC?=
 =?utf-8?B?YituWE5QRU9rdy80eDBBSTkrelFROEhWNE5HTjljVlc1a0ZQTlV1eHh0L2Jo?=
 =?utf-8?B?VmJpU1U3YkVNQ3B0Q21xRUZGVHovSjZYZGJFOGk5NWx1alZhZXBHOHlUb1RK?=
 =?utf-8?B?MFFDUTljSjI0c3VDNnhvNWMwbnpzV2s2L0lOeHpoMzQvcldYWHhrelF2NXcv?=
 =?utf-8?B?MUduNjgrMW9mdmxZL05vc29Tbjg5VVRJcDY3UnVxSkJJeVFjWXBMV3BWRm5G?=
 =?utf-8?B?MURYb1JnTlR6QU5KUUtyUTFwa1VBMVo4Q2NMY0lxdERCT002VzdqZTJiZFp5?=
 =?utf-8?B?QVpNTHdLMk1KYVhPai9aU2NCYXdDNlZtUUt0L2tyRUs5ZTIwc1JwTUxDTlNp?=
 =?utf-8?B?VlQzd05kU3BkcFdwMElwelZweU1Fc04rSytDeWxBbkVyYzFwbVI2cFhBK01J?=
 =?utf-8?B?UmkxRS9IdlR3ZFFsRGFmWmhENUF4aVBaWUZmTTQ1eDYvNzlYVUVyTkhVbzFP?=
 =?utf-8?B?K1V4dzhyQUlEdEJIZlJ6Skt6YVBNNjkrS0I4c2NTWEg0NlpUSW51UHdSZTU1?=
 =?utf-8?B?NGpLTXM1ZmcxMXgzTUJoUWNqRHVWMUI1Rjg3WjFwem5jTTdXbTQ1cU5NaWsx?=
 =?utf-8?B?STF5RXVqOWNwZlBlaWUyMVdlS3p0Ykl1WHdZYmZRaVhpbG5kM3VWZGl5MXJh?=
 =?utf-8?B?S0hjTXZBOUFKSHAzWTh5bUpJSFNLNTNnQ2h2SDF4NmNqZEhBTVFmLzladC9E?=
 =?utf-8?B?MXVpNEQ0UXphekcwYS9LTEhWWVc3clFEM1Y2Y1AwSEdsMmR4b2lJNlVmRUNj?=
 =?utf-8?B?dDFBMzk5aVE0Q3BjVUpzbWx0NFcrbnM0czFrdVphN1pQSHVReFowSFRxOXNk?=
 =?utf-8?B?K21OV3FEN2prcjFLVjNpR0ZFNEllcG1OMmdmMzFONFVDKzdVeG9lVXRmSW9l?=
 =?utf-8?B?cEo3MGlrVTZPQ0QxNnZWbWNFYTBtTEdsdVlUQTd2bi85Z0twTThFemtjMEcz?=
 =?utf-8?B?eEVyWFlhTmpJYVpUNVAxQXdSOVJBWlZhTWRjaENWVlFLbnl4d1oyL21IV0hp?=
 =?utf-8?B?ZW5vWGlIaGFBcWxMWGQvVFZLRGlGYXV3WjF3dWl1WDNkRzBsUGlvQXM3dUYw?=
 =?utf-8?B?S01lYlJreEJrK3F5THdkMktteHJEcUQzRk5XYUZhRGsvUDI2Q1E0VldxUkhy?=
 =?utf-8?B?TzBwNzd5TWlrS1RwTkd5UUkrSEZLT2ppZjlGZ2U4UjRxVkV3RVBXTHpsdFl4?=
 =?utf-8?B?L3ZXS3FZcG1Zd1lqMXNIQVRMcGxNdHJCdXByWHMyUUNLU1A5cjRiZkVHL0t6?=
 =?utf-8?B?dnVsK0s5cGR0NmNPUDFvNkQ1dmJIYyt6bncva0dLTXR3L2VWdk8vbUFzTURj?=
 =?utf-8?B?dTU4T09FQlI3cUhUMEJ6eUNHM2EzYWlMQ0RTdTZRTlNIZVg5c3orcHFNZ1Nn?=
 =?utf-8?B?QnMwOTJCTDArY1IvZ0hQd1R4bFM0bEk1RGRYTnY1WWVYeW0zQ1hUT2pyZUMy?=
 =?utf-8?B?SFg0RXBHOE5LSXZMYmgrMkV2NkJDelpEU2oyMFVUYmNLZTdlVVlGRFZBcmtD?=
 =?utf-8?B?L0tyV0NCWFRiYWcyOVd6V0NWQ1kzK1JLMlNwRXNwVGYvcVJ4bkhGaDdHYS81?=
 =?utf-8?B?eVFCOTJSWFJmb2ZUSzBYUUhqTCtrYURGa0lBdGVSRDRJK21OVmFNMGdzY0xE?=
 =?utf-8?B?Z2tGTU9vQzdJUGRPUjJCR2dwRkVqcGxPTis3bjZxVWFFbVFodjFXSDl3c1gz?=
 =?utf-8?B?VGFFREMzNWluVllUV25pcHo1QnorYmVBWWZadFNTSVBJS0Z0L2tkUnJxYWt4?=
 =?utf-8?B?TWtOQzVCdzlxeG51N3ZMaFo4eDlCMDEyQjFhS1hhSE1MakJEcmN4K0NrUHdF?=
 =?utf-8?Q?B9xNBB6QdVIlV2TDTblx2eM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tv58dpDOnCX7WLTdscEEDO/c5/Z2jqFqsA9CxlgqVYEz1TEvj0H/DtLme8i1LsPD+T9UFp1fKStvd7avt9KwLtjAOglHCsiGfXBAXz9UYk2mDVztXdi3MDzt8AKPhHp4/JHSyAw/ok0FQVQqyJ9AdBA6yEKO7sVeU/lVyQxFKqkUuRt2G2QB3c+fqvJObbGHoJU7n8MYzX42IaLkKUMWAo6A3eq5i4SaAAEo+/xCPJaeSYeFiB/NiVEOUpa7ezmERJvDUWaSxeG+HO1snIXXmD0TN135kSR48RcPd9T1e7h4FK/Uj6cIdGLxaAV5GjQyzpWUhfp6TTZkWXvdP3unn9Q5PVIPur2joixrD4bIcUZrO3qgGlgzooTE2Q9XVyupc9suwj1xw9oqcqOErYO8go6eJcrB3lGq8ver3mEQqLbnV8YJyEgMbMvAPynwn1MXSZsyVsWQTTV4X9K2FWIW0jT6vVjUocfJurRVigdKTHGVTiFcUE32WoT+15zixIINJDPtCetQJYU03r1Ymzt1Rl5fHRci39zIp9b4s7fsda9JHKGd94sSgWsacjSIlVApr0eTPSsTESjewGrfHRXK/ENRvMzj9GqUyIA3FWD0Zy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3037292-a2d0-4a48-fcd2-08ddd0015687
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 07:10:32.3675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgkDnbZFi2eLIqiih0e5DFVML9+PWPZl2fT324fS3WTMu8pF9sOfGcjwpebJNx3NJHY/FTHePpN1NoDZELSqNkbIaFsfui22zjhxJetuN2MaePZYfdoB5qRJl6TzCQaJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-31_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA0OCBTYWx0ZWRfX6f5lrexvDxXd
 LEsgXfnVI0G7UamSbTuob1Utz50hvt8umIC3/Hb2dBREjwd5PQrv6/33AADNEIMhgJrEvH1ZlPC
 mezzeyeayihFyGKSlKIMwz4vyMbw4bUt167plGjgLRQabKmF2Tz1v0mF6Nqz/er+Ie4TaRdxd7u
 p6a+ucTkEr3Ed/Z3073hTL0QhKpu4/d4LJBDIiAthvz6Z9ZdVdgUpHtNC+E6rgxOHeP6+NXWW5b
 vgZ8lW2Y0v7llPXfmXBD4bROc2Lh5fqRxGuLDfEuRXXqO5NearN/tSNc3tXpkdDx+zTJQHZr027
 yvfY7SASoES/ZbNRmdR6eKbVya1mjdDM203nLoMQSsqYXMNOUUoJvpODKrnSy6UEYGsYwi7Uz8S
 e7rWjQpqs63A6e/g8/WoRYUq+HLL5ixBOnzUviNTxMchNyF+q4+qohIvPP4awvKeXXlxRIrb
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688b16eb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GqC_iLv50AGlSb7Y8ZQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12071
X-Proofpoint-GUID: 8mD4Xz4PkmS5tGA-KaQRDd4jxyXxW0ds
X-Proofpoint-ORIG-GUID: 8mD4Xz4PkmS5tGA-KaQRDd4jxyXxW0ds

Hi Greg,

On 30/07/25 15:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
