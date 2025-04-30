Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F0919F12D
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746036526; cv=fail; b=knVylHmOUJ7B0p0m7BU/ZnxyvY4PHfvZ9m2J7lNiop1Y0QkGBWEii7CYy2rsFfx18F7d6TFL7z+kkAdEsMQL7IwmAv9fdlCY2V3Hu3vFlA+8xCve9EcotoN6RxY09ySd721kvCtNJik+1aLQpw12bheyW2iDNIDq+N/5xKNlwDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746036526; c=relaxed/simple;
	bh=rt2vFYzkT2KJvBZ2xCzOO8ncorJkf3/6lIT+o9MgUIg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AXbWWocT4W5UdE3VCT5ldXJypaGi+2b47CR5TIE18/WeJxZT1CPZi9b+d3AZ8b0zOU/nJ85Zi/CUHTVL3H33sZpOJ/XkcgTLXAzpMIe021zortZBLQBHiRVouabP/uSmdmebY/L0RwHjORGrUvkNQ/OnO4rUasgEr+6O8trrFeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QMSDk7Yl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HHA88EeC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QMSDk7Yl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HHA88EeC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UHttcP008798;
	Wed, 30 Apr 2025 18:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1Ik2kNmb0M8aNEoPyjf6jGcqeFHPiBe/pEi8kZMyLBU=; b=
	QMSDk7YlGmPRM70CVGMeNIYAUPy0PLAuG0n+KEGfuTu3n+JWuPFEK8qj0xYzpPBt
	XxdP5oEcnUbuP9Di8pl7LRObtnALvj8RrvoQtfDinncBKW3Wi/XCRs4E7eKbz7s5
	XSfKKk4k9GeiVo8K9ePqrmD/kT+dhvPuO13m4JlZpZgTKDr0h07FAZBC4p8VN74S
	pW67z2g8CYVWaFujEds6yABU+ciEN9ivM4xN72EbHugY4I+mU2JKO7ZAEmpPhJs9
	8UBm6z7jLLKRvjyVGS/a0zSamG0qfgkyf4Y+EzgqVDdlygbd+qcu1IFGXzsy9thT
	ck9GRqdbYaajmAvLXHZu2A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6ut9t52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 18:08:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53UHmpQ5035257;
	Wed, 30 Apr 2025 18:08:29 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010002.outbound.protection.outlook.com [40.93.1.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxbebk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 18:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7jMyWMIWBJm6uCS0Y5UhwJr/OWGj51FLkuGnnT0zdp8lyj3E0hVQp2iYsyX6XL8nI9UzYOGNo7kIzCCXptkuw13mdqAVW13JbKk8nJuvoy6Kj1mOOtado5dslGbq48Dhy0KvCHer8xH6CYCNokwsKoCqHrTsdms+MvH2jzjKPWvWsV861lSECLeRUO/GR1cviAIbXixvBEfwNce9P21Z2j/NMZzouJRZQRF5b1ySNySmYe3DcRqAhGBUPXbVULB+YC3YC7Hb6dyeM16uh0ZjGCq6Q83mwLvO6bfDOlJHRtVBQjbXeVMzxiGI5+AI5bCi/6X/BsKLPqZ+wNaAI0XHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ik2kNmb0M8aNEoPyjf6jGcqeFHPiBe/pEi8kZMyLBU=;
 b=Z0CfLy+4gqj/hW+Yr0CqF7sP6R8W0jojYwyLumjYaMxM3sLaJET6V6mw11ED46vMQmB3WVPBRmssz7eyDQM9Nx5iWtfdaiUDiR/yadaYpUSeoz78xN6mBcKdBhu8ueTnf+dR1h0eD5VENMaLp/glCMoiQwlliH3GYxwfHkL8Rll9lC8mmFB+TmKChhVuI+F/kG2PhurBCan3lVe0gPRfWrCG13GBeVFl6yV36vezdbB8sJhLyyvX3I4aDyDhZXGddKIAIUGNI+f7NrmTzGYKiGiu1P5/+3k9naOCz9GINHmwIzTYMeNAHx7Cub++ppalfsLoCflhrsL+9M6EthMBuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ik2kNmb0M8aNEoPyjf6jGcqeFHPiBe/pEi8kZMyLBU=;
 b=HHA88EeCVWXvfTm3STIOcuo93MIQAxPF/7bOpolxFOTtlsnUOKQEtcsKPOzVcsg/yxSwc41lIHHcXDCkzQOeEE9Tx3kOEVuHfxuvfz4e9jdYN+DplBmXRxm5cDHLB6u4tu/IuKr7vY1/4dgFJsgeZSKREVsK3YMHLx3pZ0lHDqU=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 30 Apr
 2025 18:08:23 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 18:08:23 +0000
Message-ID: <017a0a58-7ed8-43cc-bffa-62c3666d58d8@oracle.com>
Date: Wed, 30 Apr 2025 23:38:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/179] 5.4.293-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250429161049.383278312@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0175.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::18) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SJ0PR10MB4510:EE_
X-MS-Office365-Filtering-Correlation-Id: 418ee6d6-50b5-44b4-d913-08dd8811ff07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUxzTVAwVStFSWZYZERBcGp0TVQ3K1hPR1l3YXdQalhqelhpcEF1Rzdscm1x?=
 =?utf-8?B?N3JwZFJQTmlkR25uNm1YTm02clY1Y1RkV0FVMjJJenpPRjZXQ3NJS3JwMm5Z?=
 =?utf-8?B?N3BSNFUvWkozbTZXZDZGUk4vd3MwUXd3aUVQcjlZKytQaWlIamo1eHFjM0Rj?=
 =?utf-8?B?ZGViOFFsbDV4STBEOHZVQkdvNTBWZXROaEZKWVlDWk5Wc253SjV3Zm5jdEIw?=
 =?utf-8?B?UjdBUWVWZU0xVmRSeTZMeUMxRU1JRHFmRW1EVkJhdXp3R3oxK21lOGozL0pH?=
 =?utf-8?B?NjhHRnE3TUxiSkNGZG9jQjloMWYxT1k0dTlDcHBpSFd0VTYrTEtXVVRya2xE?=
 =?utf-8?B?UGZ1ODg2WWI5dzhiZjJweExPL25Mby9DU0FWcTZiWloreTZycVVwMENLREJL?=
 =?utf-8?B?b3JGWDVvOWdTU25JU0xpVm5NQjFuTjJybWxMRVlhcUlZb1dKRnRidk1VWG8y?=
 =?utf-8?B?ZTl4cmNkdFZVbHd4Tk05Lzd6bEZDb3FsZmFUZW4xb2VNV2dxM2c1S1gzUVVS?=
 =?utf-8?B?RjJXeTFkV3VTa0YzenhaV1NVSFVYcVNZMmFBdWJKS3VVTWdvN05vekJ4NjFj?=
 =?utf-8?B?NFc4OC85MEtJWCtOSDc4bmN0ZGdPcjRuU1A4clBSZm9LTVlURm1qaWYrZ0tQ?=
 =?utf-8?B?Y1N2QUZ3MVdTa0llMGwwZk9weTduQzZiN0RuOEpnaFQyRzV4RzRvSjBzMkdI?=
 =?utf-8?B?K2dBOEgrNDMvN2FCNlFtaXl1TnY5NU1tN0g2QmpIL0FmTFpmcmRMWU9Ub1R6?=
 =?utf-8?B?RGdzZWF1OVJLOW1ualFTTzh3YnpjaWppeS9JUFJCUzVMaVJvODczWDhuWndl?=
 =?utf-8?B?UjdFbEl2OTRsZEZFVUlVbHJiYVpKUGVJRlNROUlCbjl0ckpoOWVNM2tQMkJC?=
 =?utf-8?B?cFdzYk8wWGIyalM0UkhRYmdtbGw1TDdCbXowU2pmNCsyRlFsenIzUXVlNDNP?=
 =?utf-8?B?RTI3MFlBWC9HRTM2T0ExWTB5Q1lGUnVnbkkwWXRBYnE3TFpBYnhwQThia2ZY?=
 =?utf-8?B?V0dmWHp5Q0lBSWI3ODNIUG1KdktIK2M3WFV0dnJYKzRMeDJZVWN6Z2hwR0tI?=
 =?utf-8?B?eUMydUd0Z00wMVA3Qjg4bkl5TjNxV3J3ME5sYmlpYjZrdW10UDgzcDFIQjhu?=
 =?utf-8?B?VHBJcGlzQVkrSGNYM1IwaU5WWEVVcWFkOXdBRkN2dzYyWVR6cmFpaE9MOU1y?=
 =?utf-8?B?RXdTQktZTnVXYm51eDUvampXUnc1Tm94SWNzRHNFTUpEdmpTcTI3UUZVOWlR?=
 =?utf-8?B?RC9aUzNDY2ZwTmhEcmZRK1NMOFFGWTVrRzRKcWI1QmJOWU1yUjRwN3MyN3Fs?=
 =?utf-8?B?Yy95NGg4VGh5M1RNUXdiazc4TUN5ZDAzZmovdkxXRHlZeHNuckI5dXA5Unhi?=
 =?utf-8?B?N09UdUNhL1h5am9PR0tkazFjN3JrMm51T2l2ZjYzMjJ4dHVxelB5ZWFlUEpK?=
 =?utf-8?B?NmxSQTNOdDhBY0t0Q09nN2hEdnpReldTdXh3OWxxZ2czT0M3eXphVTBPZis4?=
 =?utf-8?B?My9WbTdlbysvU1p0MEg5bGJIbGx6VWtHT1JPK2tOSWpySHN1WTliRkI0MDhn?=
 =?utf-8?B?bDBjN0F0QUdEOVJ3NmN5Sy9vN0p6aDdlcklsb1owR2d4RklaNHdENVprRFF3?=
 =?utf-8?B?R1NmbzBwTXlRT1R6TjJMUVFiaEdhMGs5VjYzVy9Dalh6d1h5dU9VNmJzSnVW?=
 =?utf-8?B?Vnovck5temx1ZWE3RVMyaFRLRkpWcTJjVjRhRU9HT2ZqMGxsWSt5UkZjUGNV?=
 =?utf-8?B?MnF6ZzA4cTE0Yk9ZUFJTZHBoTVQ5WDdQbE44Mm8vOTYzR01US2xiUFA4c014?=
 =?utf-8?Q?m+s+qD5mmqUuDWSjkwT8aVf8tZv96AVZqMkIw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDNtYlJESTdjUUQyRlpHSFhneGFSSERvZy83UWRNbk9GQmg2c3B4L1d5cHYw?=
 =?utf-8?B?NWJEOTYxRDJXa05yaU9NbTIrSkRnRFlzb3BsZERRUGVzaUtzWlM4ZzZPRFlZ?=
 =?utf-8?B?NXRCTHBBOVVObDExRVo1RGFpTW1iakkwMEd2M3lyaFV3Z3o0c1VsaHVNY0xr?=
 =?utf-8?B?ZkpNMmoxSGZMbFd3R1AyR294VEI0aHAyQkUyejVTV1RTNng3aWpFa2IwSWNT?=
 =?utf-8?B?SXlSTWZaK0hRODE3SENlOHVqQTNRbXgvbEJCUWppcEdVbFVRQXl3cmMwenVL?=
 =?utf-8?B?aXgyTlNaL0J3ZkJuZXAyTHE2T0xJUUVlZ0Y5RWFDWU9lQUhyWlM1dzd3aGtK?=
 =?utf-8?B?VUtOcXBBV1pXTnF3R0kydyttSWQ4THo4NEV0M0xiTXNHUURzdUtIY3JFdFdK?=
 =?utf-8?B?dHlHYmdnNE9zR0d0UVlrWjFpYVN3UXhhdytxeGJTclh2cEIydTFWU2x6ZTdT?=
 =?utf-8?B?SmxnZkFVRU8xQ21BR0hBSXg4YTNPa2p0S0M1dHBrc0pVdmo2QlFIbm5CV0l1?=
 =?utf-8?B?R2FuU252cXUxMStQR1R5NDBIb2I2RUR5T05aQWRRLzJTOXlCZjJrdzRiM2cr?=
 =?utf-8?B?YVlYeXRCeThRS09KWWlZanNQZEt0UkR6TjY2YUlBeWhtcUZoc2F3eDhqV1di?=
 =?utf-8?B?U1JaOFFzVmttYTg2QUFiM0U3cWVjVGZZV0haOE94VUpmbmNDa2l6VnFPMVhE?=
 =?utf-8?B?VmxGUkEwakZkZ3gxdmNrcWh0c1Z2dkxrd05Kb3B2UEVVRFJUVVNoajJiNDJv?=
 =?utf-8?B?cTRXY09nd1MwTFhWcThGY0FydFRwRDRqOG1sWkNRYlRnWHA4MGNWeGFnTFZS?=
 =?utf-8?B?YXFwYXQzUi9mWlIrSVhGYnZxZFRmZ3VCcjg5OWJ1VXFPQkJUNk90RTZJQkdr?=
 =?utf-8?B?TFBleE9qQllzaVBJSEhsbk9KbWJUa0p3MDE1S1ZoTVlRV0ptZHhpZDFzVXJU?=
 =?utf-8?B?aEJYQTZ6cnBIZVJsUjlSU1BlMUF2Qnc1cHlHTEk1TWwvV0M0T1BUcUl5Uk11?=
 =?utf-8?B?MlRxMFRZUVpkaUdnQmlhSHNjL2tuZDd5NXFyZmhZclBlR0VGZm5JZGVzZnpz?=
 =?utf-8?B?akF3OGQzamNwQmRGU2VhVlNQK0JaRXRteXRRVjh3VnV4NGRFUjA0UzVtNWhm?=
 =?utf-8?B?aE1rRkRlT1lzaUZnNEQ3Q1orUzRET21UVWExQ0lRRDZPQVVXSXF1SC9XWDg2?=
 =?utf-8?B?TGc4aTRVVTVSWjd6eTNWUENoUDZxQjZqV3hpY2N6Tjk1SlRPNlE5ZWJKREF6?=
 =?utf-8?B?OGFJSFIvNURCYzRYNVl3M0lKdXExTzFEUXBIQ3RzRmFDVlNUOFR4UjZPbjZU?=
 =?utf-8?B?NTlOcHFrWnJDZG1RYXByMTI5UzV3anNrNVRJUUJCQ2pKVFNkU3dSWWY3Z0Z4?=
 =?utf-8?B?QlIvZjNlMmpGZEl6cW5NdlMxMG5xSkhUMzNCQTI1ZERWalFneUZuTUprOFhs?=
 =?utf-8?B?dFBIOElVQ2kxaTZyZ2l6clBvR3RGVG9XMUV5Mkh4NDFXeHZha3VVcVAvR3dM?=
 =?utf-8?B?VFN5Nk0rMng4UE84R1RPbVlJN1BmS3ZQSlRPalFVTmwvRUYxdExoTzhQdnp4?=
 =?utf-8?B?N2ZrdzFISlBiNjJwekswdnZ0bU1PbngxZDA4Qk9NeDJ6Z1ptaWxha3VlWU56?=
 =?utf-8?B?V2J0N3lyRHc1Tms0TXlsM1p0bjJCK3lLYUU2QjBWaXM2dnc5enpsb0dEL1BG?=
 =?utf-8?B?WlJSakRnRnB2cSt5Vmx2MjBJcGhFbmhjY1dWaW05VXZ6NUpvNkJCbloxaktx?=
 =?utf-8?B?cVJxVjBmZEVIUUtPVUxTcmRnaWJUUW5BKzB6TndOVW9vcElWbUtINHRPalR5?=
 =?utf-8?B?YkRwcHVpRmZ5RXhGUUIyK2dLdEZPREh3UENNdmRzNnZib0g5bDlpdlBYM255?=
 =?utf-8?B?dWp6U21QWW9UTHJLanhxR0U4elRKT1RVemd1L09QZ0J4c2pnUm8zeEJjeVJl?=
 =?utf-8?B?bHZTZmVrUkNBUVVWWk85MkJBQ2J4L0Jud05uQlBpeGpQQS9hWForb0xyZEpN?=
 =?utf-8?B?ZzRtcVVZcHNXS3BaYTR3SWFkbTY2TU93eFdZVHRycnl2ZUdMOUNPZTVteUdV?=
 =?utf-8?B?Tk9nOWZxSXNWck9lY0pONG1odVczQ3lNQllXZmRjVG44ejBCbHF1Lzd4VjFy?=
 =?utf-8?Q?6YY+bcw/CUVEspRECCjMmDmaS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rjGNnpw3EtoI5ogUrmuwJBKNJnSZW9XTEmr58tYkt8ZHa8PLW4zpGQyllPOoL3TGfNHneUT30ZqKtkw2f2QNf5Z6y/xDLA5+hgCu0emOGP7cnEOOC6hqCHGbTpz6JeHcvNs0NcTbO2R2Sh5HXkTBRSVLJfnqAMxX6j+1uHWv03ao6qNXmX+Gtixd2+2E0XHOhe5aDYCiyi+3IgOFi7BiXq4xaqwqAa1pxvwTrNYh9HBLW/eesFBNet238J1T7BGXuCvh6g80/wbxnw3gnO8yaUmQlMR3PtewRoE/VwsKiVkCR3aaUBkAIRuBSCjyYCl4zQ8AdRh+f1CjUhsWF7Vsh2i5XTsBa6iKM2CSBkqIJqNPRYA5LacjlyB1izQwsDzWc0hLr3607dH2KSc7mbYNnNIPcXXswgNdGpdXaf1rf8fIOQuL34ndG6ZGOLW1TBOsnIFE7dgw9M5Te4xJTG2OGcLHhLhi8tAxtKcegnLIhvgnSNVnK9dhcHntZOLFezL1jJyv2FDPxi1yzi/Hw8Ao9fidlMKztmkrIM0zMe4Z3zPHXtobCu8qmmv2iU5VHlsbTyd6innOs57itcmUEPxCWKivFTfw7Ucnksw5sHLgErA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418ee6d6-50b5-44b4-d913-08dd8811ff07
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 18:08:23.7675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+ZPUB0x1VBSikGcVOzQICRlBl0v7OJrThDLgb940UWkBEA/jusT0YfXTCOVwhsMQd5ELdXoe1EGy1hbzwfVkzKB3Pqi52uZSpNfs/gFfNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_05,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504300132
X-Proofpoint-GUID: sB6NGyDKCleL2z4FwS9rDchBjukbiOEU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDEzMSBTYWx0ZWRfX+JaTIMEc69DJ mqZ/hGcSMbN+e/V1QQoY1KslHnxH5JUrdZFAEsC0jzcLHSCJBVqJ3HpTJ511AIRZ8vCatZt0Ojm tuFacZKPbkXAqXXV9zTggmf7QGhVsRhUHflG8fX8bVCdhTHePSWiSkBP+2OLgHdfvYYve740BxO
 HG5dVx/kj+uzHF13foopwvh/1u0NJeSpfpyRe2kyJI0pOOeESS9Df/mSToVWyFT0WwSXVeNEWXX 1ue1fBboNIShgs6CXVoAC4HottJEKxLjXoDPRLGUrOapuIFaJJi14DspESTQsEeFrawouWEH3KN Z7aNSDh8rWYIswjBlGX/zu0blA09wieUaq6bzVMbmxqrvRbeiIswNzkhGDoFco5Mzut06gvTSXC
 MhEqphosOb4jh+u7yZuf+T1Zk46ILrp1tF9lZJtqzRvgu6BD6FpMJ1INmUejcNcbtL23e+zv
X-Authority-Analysis: v=2.4 cv=ZuHtK87G c=1 sm=1 tr=0 ts=6812671f b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=jgJaHK7wliptf8JI8WEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14638
X-Proofpoint-ORIG-GUID: sB6NGyDKCleL2z4FwS9rDchBjukbiOEU

Hi Greg,

On 29-04-2025 22:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.293 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.293-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> IPShYYPRwQVyMGEUDkYPUDXfyHUAu3dkwdGW7hxX- 
> lLnruQITTZM_71HjH4inO90XxDAKXz07zaiTCHACPg6nnXnbw$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
