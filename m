Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F56E22616
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 05:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721971426; cv=fail; b=Oyipw2rbyskGMqCmnatpXC6YlCCYgs9fDdLmU48k3+lRiNTtOWYQpHxZxjUuLIHSo8LRKC7hkUlWl1sNT5r7CosAqSroydaNFawZmR+0rRJKDw4P8z3RqSjF0jks3EwicNyvpIkVsr4qIo+Odw7+TMHlUSC5/tq1sO5uBDH7fKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721971426; c=relaxed/simple;
	bh=0DCQWg/MV4SUHfK9iLuNFT2/9K3GazF84pDqIDGInVg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aN6ltf7pSNgWkKCoJ6SGOWuWm8iSK+AIXd9L60eLyil6HDs8h1oPmotv87vaRZIN+snoVXq28yxdNxzC9/N/KYQQA/qBceCWvUTQK+mfgYWV79FAAL5hBEH7MOkoXPC/tF4p1Gijefj2hMcViy+So8oLAyARJ7IqSt7tgz7v1xI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PGpS3UkO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f//7w5Ns; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PGpS3UkO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f//7w5Ns"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PLhVJ6029209;
	Fri, 26 Jul 2024 05:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=x8LYJHp1WHjI1VOpxZFKFxXuZz11rINcdDp1IAzJDBE=; b=
	PGpS3UkO9yuDRjp+GdRKD79VqAVV4aNEr0rWXQH5zz8U1ct9869CbWB2o/eorKtj
	wv7bTmFpjy0xBkwCbH2Bl5fkmioXc3a12vOLsz++b9HIrkWc1Tnp2mPfszUiu0wY
	oKoNW5WEeW3xpNZLWyUs9LE+EUCVmU3nv21ddqP4SvjEAsk4seMsxymsUZtT31VN
	q3HxAN2DKaVwigqCpxvTKWz4pg68sg6jVNa4YGx9IJ/PpdVpBfZDQm9PtkxX9hlI
	TI73+l5rlnt29S3CgTeQA3feFjEkML718q6Nar+XfaU7dYgp34O7wIHub3eoPQew
	x8qYxQVla/1pFbEuV+FWIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgktcuat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:23:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46Q4Q0oc001103;
	Fri, 26 Jul 2024 05:23:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h26d4w6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:23:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gohr4MSVevMyYfLPIgGX8aQrcZd+RuN7ljKtdMQPh47gAEl0gwFdBhjm5MlNn9U1ARSY4Uunxw8PYXRnL2J4PTLStf9pwv8UHA4qIzvt8oMbcJDY9BQe1oiBMHOcf7zALmFMY1MDuyJH6yHyh4FfR2hC+CK6XUyNR4QyCMNCrreJU3xVRf8ceNBJt/e0pwoPG3TQbeQQxrxtYZQocqpdafGjEVrGt0SxbbpUr+LZGIkwbZA9PouVvD5mykRfOluQ3O9XzoWIoYCkHPLoWL8WDmlSf1aiDttpZ/a2VA1a1XIISqtnfR+03QZM6Cyz18bP8ECrZrznOJrgToTbcg2QVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8LYJHp1WHjI1VOpxZFKFxXuZz11rINcdDp1IAzJDBE=;
 b=rQECKAd+L4tApxDZFx+/bG8gTCW5mxsCqbFxNzzl1QLBaBtjk8WeUB+jwfhTm3mpnlyHmm5+Cs9EYgt809FsT0KGuXvd4O06zGINq+jvHk9829oQQdLoJwLUSFZy38pZE2o8xCWf/KTebqYfVrGMU1C3hoq+WabNvwbWAD+HicEZrNfR/VkfwxiAUs+mm1FjqqHHl2V29DCLyPuUNn6tUDeczYeX199cR29j9WoooDHmdlBvCKReoZ1kGK+ZWPthLXzSvsDSMqpKhLk6WWPrKq4o5IhmR6jk1YDO8M8CgohnJlfiyAqJB+B75DntOMZPJttJEvO2z1u57x096joeig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8LYJHp1WHjI1VOpxZFKFxXuZz11rINcdDp1IAzJDBE=;
 b=f//7w5Ns0zaaUW34wwhP3B72QdivFo1rH/EvxdcOts2TR2qpUCc4RAq0cKKmRQvij8ctUGA6O5OlMUQhuRMHsI1EbkFsr6oxAVzgSKY5Ex4vWmYfoXuoQmFc1B9lJ7hXSQ16XDfVnisJgVui05XW5vuaSKJmBkHchxQYoMTASb0=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 05:23:19 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7784.017; Fri, 26 Jul 2024
 05:23:19 +0000
Message-ID: <99fc2c1a-71bb-4f02-9e0e-6e69394374dd@oracle.com>
Date: Fri, 26 Jul 2024 10:53:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/87] 5.15.164-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>, joseph.salisbury@oracle.com
References: <20240725142738.422724252@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:820:c::9) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e3fa2c-5dd9-4030-286f-08dcad330f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXNSUWFkR0Q3Z3BFVXdWL3dObVltRlpTSElLODd2bGtobCtGQVJVOCtuTjBS?=
 =?utf-8?B?NjdTaWpERTV4RXZpSUx2dEV5b2d5K2NzMkUvSStoRk13SFVndFAxRi9za3Ns?=
 =?utf-8?B?ZlZkeVQ5Ujc2V2hac0lZSm9uY2I1Q0dDbmJLcXM2K3FpTi9CMVNXd1d5T3l5?=
 =?utf-8?B?bm1xK0gvT3VvK3VKak1PSHU0UHpFMENScXlGbXhUeVY5MW4zRjR6Szl2VXBo?=
 =?utf-8?B?bi90NG00TUdwRXVBM0U1clRJYUtLUDVTc0FVR2lsaUpRL0I2cUZOcWpROEhZ?=
 =?utf-8?B?MWZRY09SaW1Rbm5VbnRxcW9KVnBuYWN1YU5yUFFCUWNta3dnK3F1a2dFSnVY?=
 =?utf-8?B?U3BDWTQwNGVPRmx5MGNRcnQza2M1MFJIN0N1VnN0a0ZYRCs4VWNZc29OV2pv?=
 =?utf-8?B?OTVwWjNaeHB2YllMYmVkY1JpSkh2RCszc2srQkZ4UFFFTzJ0NWtDRzFwa0sr?=
 =?utf-8?B?MUs5R2NEVE9RYVl3NUdFSG85Ukx6RDkyR0U4SzlHemVZTFRDMTBWVzh0eU5V?=
 =?utf-8?B?TVNGeTZ1WlBjMzV2d25NNE5aWjAycmNPaHRlWjRudG5YQjArdDJQTVZNQkJa?=
 =?utf-8?B?VXdNWVhRVFFZTFc0ZDZZVUhRYnY4ZE9BMDRrdEx1bEMyMDhjR2k5a3VtRDkr?=
 =?utf-8?B?M0FldG1uem1UNksxallUUG5xbVp0Mm1Kd1hXaWxIdS9PWGxDcVF3ZFpyb0lw?=
 =?utf-8?B?a2dYUE5LYmdrQkNsd2tiaHN1d0JXYWEvS0NKZVJWRThWZU1NYnU4REs2WUcw?=
 =?utf-8?B?L2tiaFU5OXlYRjFrWUVpWUJlT0k4WTFrVEh5am1LTUpuWmsyMnF3Q0NKL0dm?=
 =?utf-8?B?ajhGSGE2MGZZVzFWLzRiQlpFNVowbjJsc3FOdkIxMjVkazAyM2grTE5XMUM5?=
 =?utf-8?B?TzlFRHUzTlE0aFoxRnpLdlN5aTc1QVBjd0hXeldUSktmN0hmc1hnNThVc25J?=
 =?utf-8?B?QUlpSVhkampzcGtGQUdFTzFHM3VEM3pmbjJzaDlMZ1UxdXAvK01ic0VrYXpF?=
 =?utf-8?B?VW44eDgvSjVBd2lPV0NXY1VYbzFJSkozYTU4K0VCeSsvYVdPUzJtdVZsWXc0?=
 =?utf-8?B?bkpGb1pWYy9XbWIxajhwZ3RJOTNhQnVGZEQ0TXdzalNBaFpId2xYVlNIVlBv?=
 =?utf-8?B?T2kxNlc3dWR3ZExKdXFSL0d6OUhjdzFuYnNQbWkzeVV1eWZyMXByTGplNHZr?=
 =?utf-8?B?KzIydG1HN1A3SXNwbVJPdEk2alFpQm93ZUxiL3FoK1N2Qm9NS3lVU0FVZTdl?=
 =?utf-8?B?MGlHTlJ1MENKNkJhV1IxZHFqaGVxZWpEbjdvWEQzcnl2eDJPUTJNTjlhSFg1?=
 =?utf-8?B?Z2NZcERoYmZEa0VNQW5SWm1WTlozNVZSaElFWDlkSWUwc0EwaTE3OHdrSG8v?=
 =?utf-8?B?bmw4dG51SWRMSlBXUXgvY05qY0orL1Y0Z3JUWks2MTREY3BBUGtWdThPTzBG?=
 =?utf-8?B?eDFYNVpReEh6NjBHUHNsd1pnb0JCcUY2UU0yVk5vdE41djczZlJaSmU0UENL?=
 =?utf-8?B?dGlHa2daTGZvMDVXR0ppZ1FyTGY4Z2VXN1NHSlJLNFoxdHdGWlQ4d0NObExV?=
 =?utf-8?B?SWdralhwV0gxckVFRHR1OHNJVVRyVnJTU0lMN2dPSVo5VERId05OMWg3UjRZ?=
 =?utf-8?B?RVlPaHhTRUZRdW43d3owclhMSHVQd1JXb1JVR293S05UOUg1YjhvbFBoV0da?=
 =?utf-8?B?QUZHNEpjN3RaQjhnSkNHbjVweUZlVmdGMU9OK09BNEw4aFAvR2JUVXVJblZZ?=
 =?utf-8?Q?2qYqcpr/C1ny4ntTkM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MC81NDgxZ2ZzUGZFcnY1NUU1UklLZ2ZCOHJWQjBzeGFDSlNtMjFaUE1pdHVz?=
 =?utf-8?B?UnUwemdxRnFCc3RhSnl5ZVlFeGNDRGVNd3V4NHR3NWJkYUR5ZlpLd203c1FW?=
 =?utf-8?B?QTlsZFAxSE9GSTdsazZWMHV3eDNZSWJFSnlkajE0cGVOSmxpckY2MFBEakls?=
 =?utf-8?B?RURlWENseURrSFM1ei9RSEMzRGJCL0ZhRzVpcklseVB2THlpTnZwbWhrR0hx?=
 =?utf-8?B?V2c5SEVLQlVJNThkbHZCVmI5TTQzVldFczJINm1CNkVXTkNCQUVxaWNNT1Uw?=
 =?utf-8?B?TkpHNExlR1EzRnBGbDdDOHZvUG8ySnhuM0RUSSsrY3QyaGpXdU4vVzByQVBi?=
 =?utf-8?B?MHJIdkU5QVVIa21tSjdxMkV3T1BhTFBCc3pZbTd0cS9XWGhFVHMxRHlxMVBB?=
 =?utf-8?B?dlpDV1RSWTVnZVdsWXc4SjRkaGdqL3hIMXVIWDZaME5JeksvSGw2UTdXZ2JE?=
 =?utf-8?B?b2VlNXVYRWNLcnoxVjlNRWZzcmNhS2ZZOTREYTFIUS9pK1lvQlVSYXU1eHhH?=
 =?utf-8?B?S3RWZU9KNEFQZi8yWE5iMXBoZktNdmd4TjBxcXRkUmphbUw4ZGR6Skd3Q2F0?=
 =?utf-8?B?T3JpZjRRUUFpdTluL2xBV1NQKzJSMVpCMFVPSkZkTnczaEVMbGtKZWM1R01Q?=
 =?utf-8?B?a1IySVRzZjRRMTRkbXVIRkQ0UkxRL3ZYTldGR282QzBpbHd3L3dDTDhSRzJR?=
 =?utf-8?B?VnNrS1o4dFJzZXY3RU95M3ZKV3J6cVZJd1lqL0Q2Nkw4Y05ubDNOS0hSVjNO?=
 =?utf-8?B?VkFDUndQNU9ZSmoydWUxUnBiZS9mb1NsR2d4azQrMmkvZ2pFbHZkd2Y3VVNZ?=
 =?utf-8?B?UHVlTTJ2eU4xSE5MUVJpQXFiMUNwVHBCQ0toUGE2RDJwVWdkOTB2WkdtdTZl?=
 =?utf-8?B?U3lKamFRNnhueUJuemh4cy9BVkNKU1I3bWllSGxDQ3VyT2F4Y2N1U0ZtaEM4?=
 =?utf-8?B?LzBSOEwzTUZhaExtMXc3b1cxeTdtUnJxL3dvZ3hOalBTdmFtNXEzTldpZXNO?=
 =?utf-8?B?TEhFRnQ3UnE1TXozSEFSTXZrVDFscktzOHNEUDErN3Y1SjFnZCtnZkRtbVIx?=
 =?utf-8?B?STdRTVdEM1Y5RldwOWc0dTRtaDFidmhNSGM1YkJoS05YVW5SQVdwMjBiWUFO?=
 =?utf-8?B?VzlnOHFRNTZQV1Q5dVdWSUp1SzdnbzBvWktSb1RvNytPSmV5dll2Q21HdXlD?=
 =?utf-8?B?Yk52QkFQRHQ0SkhWbU9Pd3ZmT2FVbm52RFFXU0NLVUpaMUJwMXZqSGpPM0JH?=
 =?utf-8?B?RnJBUldsVkFFa3RaeW0rWVdML1hYdTZTeXlocWllRzNKQzcwN21PZUplSTJ0?=
 =?utf-8?B?Y3A0cmJIRU9SWDdBbEZjTGlqMndVcHVNMndUbTIzZlFUY1B0dlV5eDhGMnQy?=
 =?utf-8?B?dTVYODV3UVlaMmVLbWRHb1Ywd0J0b0pZUVQ2QmhsMDFhUHhQNDlIbklNdTRY?=
 =?utf-8?B?QTR1VUNYTTlFSGVmalRWdm4yM0ZxR2oycFF0YWdkTFR0RU5XQTZnQjI2UHBH?=
 =?utf-8?B?TnR5L1hyL3JrS2k2dWFaZzRsbzB3aVZ4NWFPM0J2WlJPVFVKbjZyYlFia2Zu?=
 =?utf-8?B?Tk1kODlNcjRzWE4yT1JIcEY4M0ZkU21tVk9vOUNab0dYTHk1MUNRdnNtK3NG?=
 =?utf-8?B?b3RzNjVqbVFsVzVvNW1SRHdXcENlSlRvM0xBRlpGUFR1blVuMGVYTkQvUGVB?=
 =?utf-8?B?aVpiNC9nZVpPZ3pYcld1UG5GZVVZVGs5S3N3QkVjaW9TZUtiZ3BiZEJ5MVJW?=
 =?utf-8?B?eTNRSU4yNmJIUUdCRmhjL1VPM25Wbis3cHE0WEhYVWF6ZjByUW1WN2grTjJp?=
 =?utf-8?B?NXJlVDIzczJsM3pKdEZINGM1aHJ6TkJFd1hXMnVOdWEySDlkcDkwZnVCY3pu?=
 =?utf-8?B?UkVBa1BUWWNpeGRoNFZpeitoSG9nRG1mdU8yZG10YXhuc1dBRXVrQVhtZktl?=
 =?utf-8?B?c3dRaDBKR1Z2dXY3SzE5dlRxL1d3WjltTVVHN2hienQveXNiVnNKM0ZORERT?=
 =?utf-8?B?S29TQUh0K0ZaYUJ4YVlycHFISzhIdTRWV0djZEIvclhpZ0NvVnRuUS9Ea3F0?=
 =?utf-8?B?SVR1WnljdXhGS2dPL2lidlF5YkZHcXhqdFdmUG54NW5JSmVNRWNUM1NvQkts?=
 =?utf-8?B?aHBWeWhadExpVXZNVWdxbVh3aG4ybVFQbWRJWWlLZnFsbk5UR2x5dUk1OGpY?=
 =?utf-8?Q?ADSCpQCBkUJmQnwrTL8KtQ8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sf8czA4BOc8XPPzreXxUVRA6eXvYHzjC9NMEGIkVRHOftB7/98QIfb0ZuX5hVYOBPc51x/DOns938PBK82amGx6F6K1sIi6pdDnYDJwt7C8ASpOpuoA+7xEKbeBlQ07prIgQpmYPs4oJorfRrKg8srcplW3EFp5gcCcGjh+01WnDxhEIT0VNesrsPowjwH0yLtSvgzyf4xVyrph67FKGA00gkR2ZXXP+9ZyHSW+LDUcVKM5whxym0eNeCs2bxshbCUqeh8muIhrG6b7tuQdueeF6AdDZXKGkMm+765gxSPv+KTFbvK3PMADLCv+GTXuRkJO/w/uaWqEi7Dq2M6NFNn0p0LaGCFqfkvbkyhsZb+aJxwzaiTlP6WxF0T1ijoSvetM8mQ08lZq3dwZQA+pVwLhxujILAt2SWmGjSItchzWfFbtKTatHwFNZ4PhHJ6ZdT8TG9aZD5yaoaEpMTm/Q92DcSp8IvlW3kGsQE+hzyPXGUW4X11sRTatIkqzKWIs0qtXMXfjRNp995lBdwna/XyPCb1vMGPEUr9Z46lQ4veHafFFuM/NhuuTYhI2yMAAqMrjPb7ViYwhCU1dZDq/faFrvugGtuhQs72OEb+gPXGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e3fa2c-5dd9-4030-286f-08dcad330f67
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 05:23:19.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVaa/T5wXJfY545DR0RRknXRFHkHWW6mYwLcv0dbDhx0h+eVAeC8zCihfEa4j6JFiJ1IJeswqVyK8JBMhFFN2HMydtiHwusYOh8Vm9zHU9rvDdxEFGYH7zGaZjT9P8xP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_02,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260035
X-Proofpoint-GUID: e9DQY3HIOBhEic-mqfgrdqP-Eh2CeB5F
X-Proofpoint-ORIG-GUID: e9DQY3HIOBhEic-mqfgrdqP-Eh2CeB5F

Hi Greg,

On 25/07/24 20:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
