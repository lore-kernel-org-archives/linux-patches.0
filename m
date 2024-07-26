Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF561282E5
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 05:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721971541; cv=fail; b=ilUPm1vn5pejlC3dJb9LH+JVcmegBnw/jtckhVUiqMoGTymb8cN0mdjx2ojAD0Rk+qkNav+jlCpmi+tbnBfjxXRX4HMBGOypUpTw+GSpYctY8mVmniXMyg7YHsvD31sW5c5MAPBbxvhlYXc/utuY4YBsY2aN21aq2YfdLytrTN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721971541; c=relaxed/simple;
	bh=vXpaDh88ozNVGUG0Z9OrqK+g6K7rFBiA46zN0lri71Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ITnV6Tv0y1L9S+nO1BeYEyHLIvnTg6EItQ5vhxb47Qz7nV9vl/mBHFmkLH87ff+YAF9B59TXMNaWPTz2ITodrYK9gDpoMWfTihX7sLHmfnZdRHEXeVVJUUvZRwo0pRJFOJH07ypRpOtcKCTIQ5sOJRlVMzjcYhtBI9bggWM3Hqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=naLKNqJQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c1o/UMMJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="naLKNqJQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c1o/UMMJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PLhW8E013558;
	Fri, 26 Jul 2024 05:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=VnEcxv+bBhDo3pUBnd0wpogNJFf+iFn/HnUXaVoYRuA=; b=
	naLKNqJQPPgIj4kSIInvEDIIg2rQv7UjM3wwRK4JXaRuwUryFOMfEj9yCIyep1VF
	BMUZ0LIvUXhODO6fnVmVG09rISyL3H2iDjN77LMaTRbLe8cTnNfZfnqeZXtqdzRu
	B4ZHKdKSm2WOv5YzJXVYLZsehXw20TDMwW/9IQD2ZsQKWFNWbubugpAvnJtdBVXZ
	pym6FA9wJTHxL8fZgg/10EcYx67AbCpFM7jKLEmbJdhVKdFIGet8BTPQXk/C+vYo
	X+PBIwLZdHwsbPgT8iONK9InDqpVE/Ep03xFvU/jVIcaG5Db/eX5mGgN7lAg0jXq
	UEs20/oZ2wKyuDawDYyiYQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgkr4r7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:25:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46Q4DOlP013462;
	Fri, 26 Jul 2024 05:25:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a57w32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:25:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XbaHkLj/hWfijeNYCCx5818YgVYsHLRd+nuYQRLhuuZc9L7dhBaJf80gTJr7cjNVcrXhZ4JFeO1HVj19JB0/3GbuvHTLXMArTcaQj6pkgHze7xGVm8d9RoWoEJ6vQLaF4b6hHcQSJ2yoBMxXYSg0Q+SIdRyRImzY4KhkmbTFa5493tlnEXpaQPXqykXoDc8wMH4qgTGCbvRxb4xS1HygNkZ4m6HsNsJjeeRKWwrCZjbQPTrHXJ1jTw2jLpYjLTCEoBt4ub+ktLGTlIe/oMUR7yyChe7N9LfYKhXC/Iqzn/snpSDNP/rdHHmQvHdU9eOhfQBvlxq/ykWqlPcF5Hx8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnEcxv+bBhDo3pUBnd0wpogNJFf+iFn/HnUXaVoYRuA=;
 b=jhNO2wBHxlvRTSIuTxVvQY295wXbe50TjzyepYiiuRPWeUFsRnOwauE88ENigD12JETMkiQCKZyxaU+wrwUQjVbJiaQMaMdPVDg4OpA+n1ZkyET1gH7cMO+M1O6xpGJzh3GSL7QKXzr4FgcxyiVMW1pqPtMZqoH91vvedgDnC4BID0vWh7jpjV7WV7PVfgch+sWq9/O2ei7PiEr5bN7zIS2DqttGx76vRPFk4b1khcAAS3MNmxDb+AXi/t714EzOwa/+Gee45hAtAGQpAZz+lc0qsXcS4xGNPCnszJ/s3eD5VGbpyJTI7kDTPOzv/LrWAf3SfkQuCATIafR5b5eeQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnEcxv+bBhDo3pUBnd0wpogNJFf+iFn/HnUXaVoYRuA=;
 b=c1o/UMMJdpEshH2DO+UDGuZdhfEYt99+UVHhOZj9A2ujob3v8w9Y1JdLI6s8JAYOoGMprUaT6VYjLGboI7j8Wr+uk5DMMOl4hMfVkIaK3VZEflCIQIjDKJxbD93KTLwKZN25Kzzp59Ux2NkZTnWIcywlKVPIwAp7ltcAJxumXZ4=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 05:25:26 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7784.017; Fri, 26 Jul 2024
 05:25:26 +0000
Message-ID: <2e3b952e-0cb3-4891-9a5c-3ffb23753cb8@oracle.com>
Date: Fri, 26 Jul 2024 10:55:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/33] 4.19.319-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240725142728.511303502@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0040.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::9)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: 0118cca8-26e4-4331-22f9-08dcad335b1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1B2cE1YZ3N2eTlyd212Zkc3MTRMTGF6a3Q0eFN3S2o0TWtaeHdnVURsNUJo?=
 =?utf-8?B?Sm0rQ09NeHVTTHpTaTRXV0R3cjE0SG9RUnNLL1UyRGZ2Z2dTTUVUUFAvY0N4?=
 =?utf-8?B?T2lCWmVVSGRTeFhLS0h2cVlDK3dvVXFNNk9HUTBZb0oxQmpUVFpJZlkzOW0x?=
 =?utf-8?B?NlJadzlXU01saG1LSnMwcjRMc2lTemYzcUd4RjFmWEZzcDBBSHMxdHhFN21S?=
 =?utf-8?B?aFFXQnBiYnJEa0YzQktZNmt3NitVUnZrRVZlWFBNL3BJTlZ1YU1zamxaa1pu?=
 =?utf-8?B?S0dLZ0pkaFNhK29XRnhPWWZTbGRWOTRSOGRqSU8ySjFtVVdDbkdEbmFZN3FP?=
 =?utf-8?B?Z1ppTk4xSTV2azBsdG1HaG1WSWR4cVYzOTZ0VHc0VlFUakY3aFB3UlJ4bDA1?=
 =?utf-8?B?RjFmd2NpM1ZHZDN1WWVjbklSdU5HVFkxM1VHNnBCUXBGQVZkTnJBY2NLWTQv?=
 =?utf-8?B?czBWTjRrSEtSTCtqUU0wK0hJamQ2NHlFSmRYelFVZTQ2c0xYTndwOEJ1dlhR?=
 =?utf-8?B?c0JNRkIwNUtQQ3BENTdXcjVHZWM2UEZ6NzRScnE3T0pkR3FXMmJCVkdrS0pm?=
 =?utf-8?B?SDFYR04rbFgrdHY5MU52WGNTdGVWaUVuc1FqcXBRZ01GKytnUUJvQUJKSjlu?=
 =?utf-8?B?bnZMZTladWxOUkJTRDBrdlZ2ZDdZM2I0eTJKRVFrMFBhMDduRk0vV0pGeUJG?=
 =?utf-8?B?V1lYaHl0ekwzUEEyNlBpVXRHMnVOTGwzOUlEWWdUczd0U2VGUVdkZHFBNmtw?=
 =?utf-8?B?Smt6dEdkMmRWenVNWUc3anV6NlJSdkxiVnBPeHp0bk1vUGdCVGRqajBBbm9n?=
 =?utf-8?B?TUNTQzdSelNNcGFpUmtXL1hXTXN6eHQyVm9pTmV6Mk5aSk43SWZtNXVScFd6?=
 =?utf-8?B?MU55MWhOTzdSVFg5bXhmVXJPdXhvUlFGTzVneDYzZXNqM0dUVGdKRVlWcVcy?=
 =?utf-8?B?OGhXUnA3NVFVaXJZRkI2UXlPMEUvdjJkSENOcXNpdWxOVVVMU2xkS25qQVU1?=
 =?utf-8?B?VjQ0N0FHQnFZeFdJckZkNFlaaEt5YWZLUEF1Z0RuZTIwQ3J0SkZsUVRaNGtn?=
 =?utf-8?B?ZnF6a1hCVVoxR25EVzNUaTh6Y21vMTJYVFFyTC9LUTZUdDhEbStFWWNESWt0?=
 =?utf-8?B?cU95OHFuRHNyQTZidDdtMEVrWXdVZ0dveGZEM290UzJZc1hzR082RjVSWmtl?=
 =?utf-8?B?dzZGbGFtU1BMaGg2SzgzdGM0NEk4d281TnF6L0NpWXRSd1dIY08xdEVTaWxa?=
 =?utf-8?B?aGI0SkRGQ1RuWG4zeEQ1Q2lhdlpQQ2xtc1NhT1A5b3BnVG9kcFZ4STZVZzFK?=
 =?utf-8?B?WXNVZ1VrWFc0VWhsM1BSS3o1YjZvUmxjSlJtdWlGRnZ2SzZ0RUphRUZ5TjBl?=
 =?utf-8?B?WnRXWVRaVFgveEVWMVVDNXVpNkFGeWpIVnAxeHZPbDlMOEIzdS9HOEdQdHFo?=
 =?utf-8?B?eGlSczUyZ0JmZVE3dm1yam85ZXV1KzdkeGJKdTJOTFhpKzRyUlZxbmJIb0hi?=
 =?utf-8?B?aXU5YmVEdjRsK2U5WHlYMWEvbzlRbGh1VmVidXhsR3hPeWtudjNtVG1HMzRx?=
 =?utf-8?B?MWw0ZnlUZzVRRDl6OGdkeEpvR0ticnlJU0FOQUZyZTBCM0xzRkJjVkVRR0RN?=
 =?utf-8?B?YVN0dTljZ3U1Q1lybVN1dHdtdXRVNUtZeTR2UkF5d3JsMG9FZlNUQUxEZTFG?=
 =?utf-8?B?Wm9pUmREeURZN1lOUFVsUnJTM0YvRlkxL0pCWGdJcFF2enYzeG1mVUE3WTQx?=
 =?utf-8?Q?cfPIWxjDzmsdOzPLzA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmtnV01RNUQ1eXBVcVVFTWJuQXNOS2Z5VmtQblFSMGFMeU15UmZjTWFkWXFZ?=
 =?utf-8?B?SkpWY2x2VHR3dE4wTWVVMmNMV29WWHd3SFYwb3JGN2dHVDJNK3N2Q3RmM1Ry?=
 =?utf-8?B?NmFhMTROSGNPc3oyZEg4MllyWjdGNFJsbnp1aHFJSWN2NnhzeEFxWTl4cTln?=
 =?utf-8?B?SXZVRnVWUkI2a2taSjhTR01iWE1yeS8zNXZFaDRQNWFlYTBzaCtLdE83Z1Ew?=
 =?utf-8?B?VDZUaDJIYzlURm13UzBkWlgrVmdVTW5sQzlsVER2TmJNMzF1dVY1QlNuOVhC?=
 =?utf-8?B?RW1CZDdVREdycmFWSndCTThPdnNOaWRqRXg4dUNwbTRjRWVmOXlrODdIeDVM?=
 =?utf-8?B?TStwNVZKb1BUbVdQL2ZLMWpBSlNSZHpwU2tyeFRwZXNIcDlOOEFnL3F2clNM?=
 =?utf-8?B?UHBnNDIzTWJEcU1zVFdDUGQwZk1ON3lRU0ZYMnBzZWNMOFpmTXJFMmw3Q0Z2?=
 =?utf-8?B?Y3Fzd1pGdUFzWmhmaXBVVU45UER2UFhNSlVrYUNlTlU0aHp2NTZ1ZW9RYU1L?=
 =?utf-8?B?a3I0d083b1hlbWJVL29qQUk5UkUyQmkyUlAxSjgyTW5YbldyZzBrd1B0ejNk?=
 =?utf-8?B?ankvR2dOVUhFNUU0RlVRZ0ZGR2ZUYWF4anBlR3hwbDFhdU85WDBpMnQrOUQ5?=
 =?utf-8?B?ZWVkTEtTbUNHYUFvc2JHam5BSm96SCtaT0Y2anl6UU9PMlZYL2hUckhrQWd1?=
 =?utf-8?B?VGZQWEduREYyUXFwMFdvRS9tY3NLSG9PVFFiOFJ6amgrMWQwL1NYNDE3UkJo?=
 =?utf-8?B?Tk9QOWpaNWlBTCsvNDJkTHBCSXBzcGVvMVZPVmY3cUk4Wk1Qay9ML0NjbXFw?=
 =?utf-8?B?YzlLRGdwdEhxK0NFUFp0YTZnSUZQeTJ3aXhCVjMzRGgrUXlrbnpWYjhPVUhl?=
 =?utf-8?B?c1lDS2xsMzRiTk4vVHkweDV5N0hhQ0lGNmFZSGdzVDhLTGJPQWI2VHozbVh5?=
 =?utf-8?B?RSsyWjUxNUdhcnN4cGljOGJWMjJkZGtBaVpFdHVOREN3SlE1OVUvTTlNeHFX?=
 =?utf-8?B?MSt3NG9rRXl4Tnd6ODFmaVFEZ0tmN3RqUmFQQTNEektRQXJPWHdoY29lUXNH?=
 =?utf-8?B?eHZ6VG9qSjVVQ01MRmo2Z2xZVWgxQjIyZDVYUEdjZEJhK2NwcmtRaGFNWitG?=
 =?utf-8?B?eUFyaXlkbGc2MGttb1llRWFyVFBIVEptTXVpaXdWa2h2ajVudk9VbVQ2Ry9p?=
 =?utf-8?B?V0tyb0JmT0NYbTlZQVJPNWl1RERiR0xwKzJMKy9TZ3VrS1dBYmw1WjhnbTVO?=
 =?utf-8?B?RTVibVBBRS9hVUp4ekVlMFZGOFVwZmRkdWZ5WG9NbG5hMUo1aTQyNHJ2ZmZr?=
 =?utf-8?B?ZW1teTV4Z2V0MlRDQ3VjZ1VVZVFxOGtvdzFYZW1hMldtU05NSVdOODIrVXFx?=
 =?utf-8?B?aFBVR3pCay9tTGF0Z1V2YkR3VGFaQkREck56Y2M0VzBIT1hsVGNVeTliT3lu?=
 =?utf-8?B?SGhqL29zay9Ob0p5NEMzbmNkV09HZHJPNzAydmJtWmlPRWN3YlRkekJqK1Mz?=
 =?utf-8?B?dUU2ZVJtd3NCQkIvMWxSUXc2SnkvRDFRYW9CNVlTTjUwSXpKcXlCZ3cvQWcy?=
 =?utf-8?B?ZWxUMTV3bkxJRTRnamMzWEhXZXRpeWJKYk9GQ0MrNzRkN3VZZ2tkYjNZellr?=
 =?utf-8?B?Q2V6b0thZHBXS0NIZThFVktDcisxV2VpZUhFZ3FIVXRsa3pjZWlzWkUxeWFR?=
 =?utf-8?B?N1pyTEVPY3hKYXZla3dZZ2toaTRwNGdCT0pUVkJTVUJwcnZwWlFCTXJ1NDkw?=
 =?utf-8?B?dmRnOU1UMHd3SVVNd2tMY1FpSG9iS3JRWDEzb1NYVmlIclNEWGZOQllyOXVl?=
 =?utf-8?B?T2JJUnpVaFZVM2NwSHNhcVNTK0dSM0lRTVMyR1dOR0hUV0k4TlpLbStEb2JY?=
 =?utf-8?B?QVpwQzQrYXI4VXpXaG9BVjYrSkE5VzJEdnpoNWJHTnByNFh4RGRBUVNocmxQ?=
 =?utf-8?B?VWF5UEdrdkZTRnZkTmIzWjd5eGlJbGY5eDRzdDhDRVpkSFdUTHZPaWNMYzhU?=
 =?utf-8?B?U280V04yYlBiV2tGUzZNVzlhUVU2OTBMMWtrNkI3bm8wa0lqT3d2VVRnYm9V?=
 =?utf-8?B?KzZRcFJYMWl0T1Q5T0cwcGtjelFXYW5wRHAvV3gvTWxXd3gwc2E4T1EvRktF?=
 =?utf-8?B?T3I2K0c2dzBWV0tyUkhqdHVidml4bjhTK0IrMW1BMVBjUUpyU25XUjN4VGlm?=
 =?utf-8?Q?lcXKjVLmrZgef1fnrhQfS7k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PfTcQGfxzs4LPneCPuOdBNNUorw1BUEEpUStiQBK7056ePjVuFjnEbItJYcSTOvJ4ThQAFi2ofqpyG9bDqRmKTsa2+jh3lhnT35itw2hdtqxsWm0IDYgplX/3+YsLUf8CiSialJlkCTP/Y+DN6fKdX8AP4KscRFslopAIewBYyRQyH5x1jhMRBkZCHOeUchyfh6LaUoKK6WKp37V+1RnfhewT9WBwQSgmeOOVkXAibcU/xYu7fkMBpBp4UiGGriQR1UzumigVaegVmCgSGEcn/xfgQsZpdycZnfknF/wTkQU3ifX0qgTr77fwArT3UMD6zQE/AwA00yGrtz+/cjlTqVep8tOoWvN9vOo28FlH2y67EoIxZPVdilixXDpuAyQFIhVlnXFMu3eRW/5wcii8jGKwD/I3Nn2FN+SwcvwM+OtDBgBq8PNPaaXzqp2jmbLY8KsySZMvBwmPFXMp2U6yNiQy6xx7Hf/GLVZf4eJyqXVr1HRbO9OVL3036owJjMLmaTF0Qsaa+RFY+cfwJ3O5spGtfqposq05xqat+thnel63rqy0CdUcYLkBSd5dBlvH9TaeNpB8PhkqXxcxJRqPI7mkoSn1B89nXV/3c/Kzjg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0118cca8-26e4-4331-22f9-08dcad335b1c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 05:25:26.5875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EqIk/lDOuuXJP2l1RqVJhk96tGXIYcIbE6YJ3wsxz4zL6hnhO5fm0S+z7pSb1pLQH+9lpgfX+CXFouto+xrijQYXdIOyfutyQIj3okFdeZoLSZcTQOff0gkpCZm72tiI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_02,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260036
X-Proofpoint-ORIG-GUID: l6SOHgv8pQ9S3it2_x7qXf5BN6irX6qA
X-Proofpoint-GUID: l6SOHgv8pQ9S3it2_x7qXf5BN6irX6qA

Hi Greg,

On 25/07/24 20:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.319 release.
> There are 33 patches in this series, all will be posted as a response
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
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.319-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
