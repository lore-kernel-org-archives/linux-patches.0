Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CFD1D5148
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731686438; cv=fail; b=HCKk2p2mBL5Pz4LR/YM8nbYOt3b+RcphFz4uwCvznW45iDqcUPOrqQfcMvC04EqmdzvZMINdFyyEZ1x83DEAuV7A0J6St255By30g/zNxwDE8IWJf4PTzHyMElJJ0TkvVdQcAGdzT+b1GK1BHncSGVCEzrgd2iWqr0FJZjbUc30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731686438; c=relaxed/simple;
	bh=ENYDS00g+dvclVnTZEIDhddSv3KvRLNaECFicrGHIok=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z8vDsAcgVrFJMDLGDhoLNTeocX6s8BkgAgsXArtiIveR3Ee5ut/an41n+LkccHc4wA1Ibzf5tcojLCe7J7pCgokf0IVXHlOAICl/T86Zk0m39DNQr7qYyESAbB84TrkjDU37FyKr6dKjFkfzVF7j2GOVTdMb3E57PAH4iOrTjdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n3Ro+b2i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kGbQHEXD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n3Ro+b2i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kGbQHEXD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFDCdXd005806;
	Fri, 15 Nov 2024 16:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=nK2r9K8XKGsbM7C0m+w7uu8unR+dBBaUmbBq2bqWzSQ=; b=
	n3Ro+b2iZiEF/srOkxF/yv0EE0pX4Us2IaMOPkYTKOAYFrphuy7/S/sxWvHm5Npw
	jNpby3kQ3fMgW2NRj6uM6fIMMXYW2F0sJ4wGqlAqFvivkL0iUvPBO77o0m3Q+G6z
	2ub92MqlX+n0zN8ia6XVzNcc2ntyHjSrnTjeGcq/PaqwgUE64haao3g2ClpA+c0A
	W66suE733bu+ezPKq0zDckAXDnlAPi0osuGwaDYoi/ZvyWDYoC+QOndITFuxhtsc
	Z7uHS+4cdQABI9jYr4O42tHVTmtV2QUz/eO3/8e4QdQr5aow8Esr3pMid7S5tIvt
	9FlhicbMb74LtOIT6uNNJg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbks9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 16:00:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFEfRaa000490;
	Fri, 15 Nov 2024 16:00:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42tbpbsdkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 16:00:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NkZ22XRxWrPiw1FhEIPPLhlevYQNZawGWbTp2BNneWQOAoe8Cg4NRYc4piOwIJRmye4u1i1rOnt4thv995JznG4jBCw00N+mpZspOZcukfdxsCuL67DRQ2oZF1KNPehL4m9MXZPEZVWJYVrud7o690Pe9TH4XKcduDcmQHCoDuUdYlTS6FfhpQAcqTL5PHfk+sFyvhKniLUynTf5k7lddx0FNdo4TIv+Mnh0KK3vtf8ccEPtdYnIHxKjyWyaXFYN7Ivp2imtDmHlvDE16tMiMcytbX+XRFQsLnJokO1mAs1K6e6krvpekHJ9rYFqrzNxv/9ZuCxD5NJueGOIVmB6NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nK2r9K8XKGsbM7C0m+w7uu8unR+dBBaUmbBq2bqWzSQ=;
 b=jPgohwp2zc64kXNDUnEwkWFvOegyueVfPVV9ETKkOyA+iKnRL7rScAVNvFUBB3n0iPQqDIpGS0VBJJL2/S09G8Qe0SoHlHdppOVdVcLwnj0hpF5VFw64A29Q19ALOoH1uPTrdcO3EMKLPOurpfT8xFsFAh55Jko5eyPOw3ClrpJ+GhdcTdj+pDHmtkEEAYFPMJAyD9canXrrnkU2XRQywB691238K+ZUNyrCLvEQ2OoSQ+KlLzvYbDnIfB6IUdrfiSY+C8BLclDlv7IR+VdaIV4N5KYBdNKYcSuKin5QcmCXXty4cc8Tq4LXJ5uYjUuuU1DaTwMQC4wQ5ZY9nY8pKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nK2r9K8XKGsbM7C0m+w7uu8unR+dBBaUmbBq2bqWzSQ=;
 b=kGbQHEXDfJlLbt2x+JvN7FvTyzeiCA5RBDqkiKMq2T7ONsVN8bCkkTXly7PbKmrOQpYwqGHiltVUMjh/yXzpgZF04Zx2ctIL8MWgEDAy/fDj8nmeGqELTp/6LLZlT52RrOGRlmVAI3+UW3FbgloSE5ReIpER2lIAM2HCrB26CKo=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DS0PR10MB6055.namprd10.prod.outlook.com (2603:10b6:8:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 16:00:20 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 16:00:20 +0000
Message-ID: <1be9c0f2-fa1e-4832-8f7a-bfd4377adf7e@oracle.com>
Date: Fri, 15 Nov 2024 21:30:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/52] 4.19.324-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241115063722.845867306@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DS0PR10MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 2066aae3-910a-4136-9259-08dd058e9b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUw0cnFnLzVENnF3QkduQzJ0eE9pTUFTcGw5RW9QK25yTldIUFZDSmJjcXFx?=
 =?utf-8?B?Sk5VdEIycXdVUnFIeVZYdE83cDN1Wm9ya09aSDRNSTlFVW0rVSt3VnE4cnFz?=
 =?utf-8?B?Yys2UjQ1cyt4UHJvNkg2b0ZtcjIwd21kV3ZuaGtmTERoQjBpakFuZGVzUXMz?=
 =?utf-8?B?QXp5SVBENDZ4eGdGeE84aTJGMFdISzVZRG1qVElyRGZxb3lRRTlCY01CUWQ5?=
 =?utf-8?B?aGdhZEF5d2FNTFBET1ZSNm9Pdi9RNDJyOEpHUFlUbHZFdTBQenE1RnlrRk1U?=
 =?utf-8?B?YWxCTEpUelhLK1lGWjdSSS82ZUx5UndMTW9IYVh1dEZ2RnlMWkJvc2l1am5T?=
 =?utf-8?B?MlRneHZ2VnFTSEZHWEREb2ZWa0htUE93YzNsaWRENU1lNkVyTVJjTHc2TlJL?=
 =?utf-8?B?L0ljRko5aElvNEFaMWJ0bHNmTmxJV3lDTW1WcGVSSlZPc0pyb2JuVG9NV3Np?=
 =?utf-8?B?RjNnd2NKWW8zbHZIWllNZE04a244TklINVVrdlBUMzVGVUFqUUVubGx0S1Qz?=
 =?utf-8?B?QXpPbjE0dWlNMU1XU1VLeXUyMFdnZU1CdHpPTFNlK0UxcGFGMUk4c3ZCR0dJ?=
 =?utf-8?B?ZWo3RUpHYWZtN21tcVFxRXJXWTlrL0pBT1liQTNpc3hnZHVHQUM5THFXK3E5?=
 =?utf-8?B?a2s5eVFleVBJdnJvK2svai91RUVCbmwxM2xkT1RuRnVXYjhIWHhDQTdZVjEx?=
 =?utf-8?B?MUtFMGNLanhSWmJVblFEZVFxZWo4QmpPWTlQU2IxSm0wS1ZPdzhVemZPUWgr?=
 =?utf-8?B?T0FZc3dYSEc3SEJBZG1Xb2t5WVBJNmJiY3ZDTUZtMmdJR050bDVLUGpDOGxY?=
 =?utf-8?B?TWZSOE5nQWNnUk1NUXpDb1VwYWJiWGRDVUpBRjN2QlQvb01EZ3RmUkp3TlU2?=
 =?utf-8?B?V2QzempON0hJTWhnQ3piSURrVkFNbytQTUk3N1UrQ1VCY1FQS2lNRnU3ako1?=
 =?utf-8?B?eE5YRVlsRzFjWTc4Z3hxOVkxVzEyeFRSNCtheWJabmFVTkpvRWpBZUswMVJ2?=
 =?utf-8?B?OUVCZFlqVUFTN1NCNUg3VEt2eHR2VTMrMVd1SlZoT2JJRmNVK1pTUTBRS2dJ?=
 =?utf-8?B?Sy9vOVFjUVhUM0lmZ3EvT0lKWTA0bnVHdUd5VmRYelJ0cCtxbHZVc1VWT0Ni?=
 =?utf-8?B?R0pKWnhKVmROSFJMSzl6UDRUb2FFTllHVUVYdkQxaHJFSVk0MDN1cDNOV2NL?=
 =?utf-8?B?T08zUVZBQUtud1RpWElSYWt1N2ExVUxFdDJSdVBvN1lFSWFDVEQ2d3Nsdk1k?=
 =?utf-8?B?TmJNY0J6WUlkamhuaWIvbkp6VStJZnBiRlZHQ0JKL3RaUXBzVWRJcmhOZFNT?=
 =?utf-8?B?MkJCNVA3ZkI1NjJBeG1hVVFHbnJJMmRvMzFrSDVTZjdyaVdzS2RIQUlRWC9l?=
 =?utf-8?B?WXlNczVXaEQxZE1xdVhEbVdGQWRSUTh2T3FwRVpSeC9sd1dmOGtaU29Lc2Ur?=
 =?utf-8?B?YTE5Tk5jS2hobjNQMnAzNXR3dHlBeVMyd2Z3ZlhGL2dkNXlIOWFvQ0VxY1cz?=
 =?utf-8?B?bVA3N3NSNnJGT2lwMVU5ZXgvQ254Z3JRNDR6Z1E0aWFZb2NPbVBSWElCRHRB?=
 =?utf-8?B?Mmk0U0tsU1hpZ3hELzE5UERBa0gza1E4UjdUZnJjK2ZyTjN6V2lZRUxTTVVO?=
 =?utf-8?B?bjNFa3YvUCtKN2FybmNwZ1JwcFA3cEZGLyt6OHdNbm9KSzRaZjJWYUNEM1dE?=
 =?utf-8?B?TmVqS2FuOTFZYmNNdUk3NUx3amphdFE5cWZObEVoU28xQmtQTlduUTNEUXE3?=
 =?utf-8?Q?iJQvKQHk1MnCD7LWoIi5TFNUQxcOC61FavuPCUh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2tlcCtTTENSZXIxT2UvRVU0WUIzYmJnNzB4ZUJwUFpodEh3My9aczAyM1Yr?=
 =?utf-8?B?WWdQRnlFZVg0bzZSaUZ4V1JidkkrOU5SRExrRDZxT3hQNloxK0dsQVlITHdP?=
 =?utf-8?B?OEFvVFJRWDlxaVFERC9DVElBcWl2VkFrU2c2M3UxRVBKeVZGL0ZvcnY0citX?=
 =?utf-8?B?OTBXZFJLVVhYbW9jUG1JSC9qbi9hbXVIRWZEbTF2ZEhMQmduZHlMNFBJR1dh?=
 =?utf-8?B?VHRJVnl5NVErR3A5QjZ1eHZWY29EUWxhRTNBVHQzMngvZGY4Ylg2QkowQlZy?=
 =?utf-8?B?RmozMndlRmVKS3JlQldRK1QvSGd4RVRldnh6Y20vYlNQOTI2aE1xNVpyMHI1?=
 =?utf-8?B?Rkxkd09KaWVFejZGRWVvUVpKS1prYzJ6bUR0M0RqV3lvUm5YOW9kQUsyTzUz?=
 =?utf-8?B?cC91RFJzK3dDbFNURVI2ZCtiUGJZVEJkVEY3US9JNGl0YVcwemxqb2xZNERj?=
 =?utf-8?B?MGVSeXdGVi9zQVJGcE5ibktRZ1RGOWgxNkllUlNsYmZFaXh1Y20xUjliZXBN?=
 =?utf-8?B?cmZpNy9yb2hrdWQ0TWdYcUQrcGpZK3Z5RkprM1ZwZmgyVjYrS0JpcDl4Q25H?=
 =?utf-8?B?WTRtc1d6UktLb0NXUHFQcC9RakU2M2J1NndoZ0lTcFdveVFjV0pqZkI0L2Vl?=
 =?utf-8?B?MStRcVlXMzc5QWtwMU9aRHJKcWNXY3lzWlFjY1NVZ09JNUptTFVjeStsMW1D?=
 =?utf-8?B?MTNXUnNlenBnc2hsQjJXN1VkYXFXeDdCTkx2eURMNXE5Y3R6YjVGVUdTUkNW?=
 =?utf-8?B?Rmg0bytJRGpzVmNsV3VSVkorMENyZ3ZGWTUwaFBCSUVwNTBHRFJnT004UXE0?=
 =?utf-8?B?d2djeDVqSkUwQ2REVlI1QnlPQ3hEenBmeE56SHVpVE4wTEl4bEVQQWZ6MEhF?=
 =?utf-8?B?TVF4OEUvWStiYXhBVzhrQ1B0UW8wUDBFQ2dSNERKNVhEOHNwcXk2Umpic1Ro?=
 =?utf-8?B?cER3REVoSnp4aGpseXNoa2FOQndhY05STzNNVDBQK25HNUU0Umh2eVlMb3V4?=
 =?utf-8?B?WVlaOUFOaXhkTUIreHR3ZUxFSlFzcjZIZFhpTFNSdzRvemRwTk1BQm40V2kx?=
 =?utf-8?B?V1FzS2RZbFNxMXg3c2E3MkFqNjFkWDBFTmFnaWdHT3NpUTZGWjVmSzkwcHVG?=
 =?utf-8?B?TlROcnVXdUxJMnhLQTZYQjNOa0FXazV1amRRRjZ5T2s1djl6cVl6KzcyWXE5?=
 =?utf-8?B?RU5Ua3VJOW9NUitma0VVcUYydzhDRDhkTkIvdUFpejhQdE10ZWZiUCtORDhl?=
 =?utf-8?B?Z3BPblBmNXJqWGdzUUIzL1lnSGpWNUUrREFrV0Q1TnY4N0srU0owUlFEV1RF?=
 =?utf-8?B?TWJiS0JPRW1hVWQvTGc4NE9ZU2tmeUZrS08wOTdISkpuTVRhV3h1SWZ4UlRj?=
 =?utf-8?B?Q0lhZWoySFRRNzZiRUtIUVE4V2cyckIwTkFSWVEwNGlqTkN6VXk4U21ZdHNN?=
 =?utf-8?B?VmxjLzBHcHhhWWFhQS9JaDNwT3U0OXZzbUFMRzNJZ09UVjljWitUMFNrT1B6?=
 =?utf-8?B?eDltbDdBSHdqeGRDWjJGRjZzRTJrVXYrVEIrRXdOSExIUk1lelJ6Z3dpWUh6?=
 =?utf-8?B?d21Ka0RlUERrajZQQ1REdVgrdVc5Z3FDc0YyK0RCaFBHemxOOEo0UXZlc1gw?=
 =?utf-8?B?Zjdyb2d1TjFSSzlLcURjYUpDK2xKM2tITi93RnBkQWNycWNVa0duV255UGNy?=
 =?utf-8?B?NHdHOFBmRW9zWDVTd2p1ZGJjSnd5ZW1kMGc1VWhJT0ZmWXUzcytlUjgwSk9s?=
 =?utf-8?B?SThzYkcwNE1LZGZxMmpOekdQTUxRNkE1WWRCSW00R2V3TVU3MzhYNkRCdnhq?=
 =?utf-8?B?Y3JZK3E3aUtuKzI4cy9DUjk0eWtIcXVLaG82TnNzWm9ZU2l1VWRsMWZEdVFP?=
 =?utf-8?B?TFpvZ0RlWnBwYUx5MlpxNlZtbmFueVpGclp2MmhweHcybmNIVzRoakZrSHVY?=
 =?utf-8?B?SjIzQWozR1pSb05tVmIzU3dLRW5nMEpNbUVyQ2g2TU05ckZKWHU4dEdiM24z?=
 =?utf-8?B?Y2hmOWN4Q1RnUUNhbVdWd0c3SktrTVNKYm5TRU14SEJ6cUNtazVsL3psT213?=
 =?utf-8?B?VklHT3RuSGtydVp0RkoyUGlVa3dZRHh6Rjk5byswUTRZRk9FUTdpWml2dG5T?=
 =?utf-8?B?NGpoa2tEbk5wR1JxdExOUVR1eFJEdHc1Uk55SnN4WW9hU0lFa3dYdHQ5ZjlV?=
 =?utf-8?Q?Ujoi48Aj07DAeCTj50VjEeg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EN6PGr9EA6YR2bMCqeOVspr+1NYNW3qNA7v+Tc3KtxUwUtFSOA7r7ezuvCnUSWH4DxnSN/zubShGfiAzcsdGkp+0W9A9NYQ+JPwLdtYm3TlzBmnQXcqOrS2WrL47R2Z0Yp3Yxk1T6KhV/Vc9cf+tzt4LWBbrdaEKRoDaoF1vMvXTh4EQdi9m0kYRVGp1Tlp1yTBreHEyXVBCAf5HuIsJOlwEpIflII4GcVCtwWv9VM80/t33LpyBOM5768nV+hJIlKGgQswBsbEUcFujsagtBI1JwEfSFQxk7FmM5tHp38LqP8CF14XqH2aNyLfVoHIxdeWwi4cQ2ComNcZi20JdIjRP7ChDGmRfxKAQ9wsMxWnO6fy6kiZUhkhu+cLGCUQSxMgp/qAP42c64EFYbdvwkV4Pji2uXFWndvIzF+ojxRxy980NiNq4q+oqMNP1qHXbzSoXqRgA87A43zObB9DFBwE/hTAieiIONFfxb+xGaH5zU2uEIEk5uTmNhVKQeHQLwJzNhG0zrAmoO1p5K10d7XYkQfLAL4M5DE/QoMU3bY25Mm1v2Z4gfqoF31S2rK+tCPxP47W6WaNiv4WroEPhYOqKav0VLFG8snky+oXoMaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2066aae3-910a-4136-9259-08dd058e9b0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:00:20.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpH+Elz9vkZV0MVszOE6ABBS1PBbX7x8sEZaO5ue6SNa/TbvOUux302tbDcTmBxwL09iLghGG9nF/Wd1qWhgLNwe1uvmN2YhS305lI77UdbXvXzZ+iw1Fj49pLfmzqFY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-15_01,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150134
X-Proofpoint-GUID: bcIk96pPiMAeWTUrrcHShmKuwzSp5GqO
X-Proofpoint-ORIG-GUID: bcIk96pPiMAeWTUrrcHShmKuwzSp5GqO

On 15/11/24 12:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.324 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
