Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22B61A4F16
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993966; cv=fail; b=GI+T8dB8QvCiYGNV80kJiLLoeZO5acROsT6WfVGnPGtlapn2XFO3Xiev7gDoSkAhrsu3CK2VhQ9bosu4WTN06ZHgaGx97R96+o/0stt7ff5jnwovPNt8KNsHSh52pIujRZZi3ac9Kdwuewi0+cXzSzVkWQolHnntWuj/cJCsMGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993966; c=relaxed/simple;
	bh=h/xp9z7JTA2MbMEePNcRKnfvbRDEr+PBymwwxuML3qQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Iai+xahe069e7CuBlwnU6YTO0CRDZ6fJUb1FPDYJEMJkSTIPQSKqsDhJdZOXoZw/kXuKgle0jPyFrV+7SdJfvQlHr6wKKn/4nK8WJG0jBH9Nro16dkDFIjVM93Fi9Ce4IPvapiecESmWdfA8Dmvy5g4QbdJMdIkCb3fEdLkT2Ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ktpM49Ac; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FxHWvRZs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ktpM49Ac";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FxHWvRZs"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHNXWm023211;
	Tue, 10 Sep 2024 18:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=JNpe6/3X1w4xdc0M5X1Isb+YUWpUWlT5ky3+sGLB0wQ=; b=
	ktpM49AcUsqSzh9yMSgYtgF3XdpRXDRzPFzdqoGXsW555hkggyX4qupyj4efY24f
	ra7V+LCSfWG/LS4gUOQqDv+6xhWtAxjEQrkIAiAlgPe+Y9xKvJ+eeIYLotTaYyyS
	6NicJNjanAeI7vWcN09w8Vx+R3HwvQ++LRV/KqIySxKlHTd+/QHjPa+P3vAWUjA+
	Ep+XGTs87eR4yAPluiE/j4+G9K2SniI7pdK0wFB4L1Fgm3FiMh6yygLAwodU9x22
	kwpSW/roCcGSMrydvSUCy9xWD6okFxAFwRyvL2EMVr9Ekhg+PGG7mRttdwsqht2p
	rZRqpWwjQInq9s9PJtftJA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gevcpdgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:45:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHoKkP032388;
	Tue, 10 Sep 2024 18:45:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9f9bdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:45:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PfkTB6sd3LPqPB5RrDf5SX4JZyVsedRbsZKS2IFKSeG/bzeTyhxHU3PpCdf+Pr/qsFr35GhGTl5C2IyAjsZT+Dr5KDBt8CvZiTjOCyu8ImQfzpIckDCWuq5Gt6maZ6MQ2XeLqiJk68PbpXqf74dO22ANd/m5h8lfKZ5aOeWCmV6uiohAUhYaL036qns2t0HDYNkVdYSULVmAuYl6IGoMhMGRwwoykUn6mj4/zdkJdTZnvKPNXaBLDb554gpr8HNs/1x8ZvPb8afC71o2X4elNkuVBIpdRdYY/VOF8hbHNXCG0k0p/uM/6WoUT1Wtr3yNvJhv3z/uqGOzBcHC0HdzEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNpe6/3X1w4xdc0M5X1Isb+YUWpUWlT5ky3+sGLB0wQ=;
 b=VVO+Xtt0uH7vQyXxpxvjefvc8agTwksggKzxV87ecQpjw1ecp6ssWCEycqKro4Z6siQX8PpY3+pYYPbsXAdUjyBDgeMBG3sJEdAZ5NjMMhJa3LIX8Z+0HffN4sRDUceVkH66JcW6gVxM9KJF+nTltbn2U/b+8NNMgWlh72TuN3BDU7dxHEelyEEtlQUI1dtcsHdzBspN0FzWKxSRkk+jJORw5HuVf4k91VpgJNxFZ++sHJAd0ZIiJgphcar0iWM/HRg12Px+Jz1v0BUP1yGakTKgzGe5KrF7f2QAxP/yHhZTcIWpFzRE4pubASg0tI3hNNK5Qm7XNKAWTymvF2908g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNpe6/3X1w4xdc0M5X1Isb+YUWpUWlT5ky3+sGLB0wQ=;
 b=FxHWvRZsEPFsT2R9PSw7+7Lekizpuf3DDQfInYGpIlbASqgA5Glv9gbV4VRjOXfw/XY3CpmN6KsIIscqI6o0i7iA3knxg9eSJ7cFUeJ8UfCinM6xbx2vD01Axp8DSQVUGRxbUV5n0x7zaa3jL2m8nAYK9gZ0oMT8nKaUlqGShPU=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB6172.namprd10.prod.outlook.com (2603:10b6:208:3a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Tue, 10 Sep
 2024 18:45:50 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 18:45:49 +0000
Message-ID: <62d9e9e3-04e1-4126-be09-e2b9e22f2dd1@oracle.com>
Date: Wed, 11 Sep 2024 00:15:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20240910092608.225137854@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::20)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: cad2dcc2-1fe5-4d08-a3c0-08dcd1c8bec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SW1uak5ZWXZkcXYxWDJXaTBQWHB5NGFadDJkL3BRZ1krelIxQTYvbjNpcHlt?=
 =?utf-8?B?R1gvc0RjYmtxR1pPWW8xU2JhZXEyMCsxMERJek9PZmR0bWFtNUFrT08yZjFI?=
 =?utf-8?B?YWMzcjd6Q2NDc0t0QXhZdnd4MkkzaGdMZkdKVmVQWHExeDhZV3RvQnpMd2pW?=
 =?utf-8?B?TUhOSWF0MXNsUFdHS1FvbDFKSk13T3o5S1RpdmdPV1dOcmRHRjBMb0NWZ1pm?=
 =?utf-8?B?aXBFeHp1TksrcnIwNmEzTW1oSFhuWW45c1B0aDVTd1I2RGhVTllndFNUNmpl?=
 =?utf-8?B?YUJ4SDV0ZWlwOVFXdDRJM3JndXphSGxTSUtzaUs5bmh0TElQS1JSZUUvR2Ft?=
 =?utf-8?B?SGxhSE1ISVYraW45ejVnUUZ5YnpjdHJhQmNQOGZZMkdxQnlSNGtGbVNnaW5N?=
 =?utf-8?B?Y1pNL012T3lDRlVwakVOQU5OU2xrcGc0SlV6bHUxRTE2Y3BzaktQRnRnUnYw?=
 =?utf-8?B?cXVnVmM3S1RsVTJVTHNvVGtHRFlQM1pUSm9zVjVLWUxiZWxVazIvTXYwQVIz?=
 =?utf-8?B?SzVhRlp0QlBUbUJnMWJrWGtncldsdHlWTVY2TzYvNjJRUktkZGNvTWRoRTBL?=
 =?utf-8?B?ZGNwV0RERmZXdVV0bUl1K0hGTC8xcDY0S29iU29EcUZMNGNCdC9Zd1dLYWF4?=
 =?utf-8?B?djhaTlAwR01TZlNGaGc3ZTlWK1QxdlhQUzFpK3Z0bllzcHQzcm4vTzgxeGhN?=
 =?utf-8?B?OTdUa3c0U0ZsNVp3N1p4dHg4UmFXYkp4bmY1K29LTXR2dzJ2WDZHRWNDUUFS?=
 =?utf-8?B?T3NFNzFiTHhpNFNkM0hkeERKbVBxL3UyeGlJWmpVTnJqMU00SExHc1ZwYnd3?=
 =?utf-8?B?eFV0aGl1MXFXempvOFhXT2htRXJFa2U1Ky9xTlBmZWpzYU9zVnNMVUFXWVE5?=
 =?utf-8?B?Qi8xWk9GSktmM05reTgySlpMNTZxQ0szYyswUUwwS2I1UFhLODhVM0pneFpz?=
 =?utf-8?B?YlJGQjZGbm5wUE5id2YrV253aTd4K052eHhHQWdydjB4ZWJiUjdvT0czVHdn?=
 =?utf-8?B?U1FVNUUxNHhLdjgxajFTVG01dWozV0tTem9DWkVzaVlPOTIxS3JGT0lzL0JN?=
 =?utf-8?B?WE52aE9SazFnUGluUU04QThqMU42bk5EUUt3alJURmdueldyUmF0bzk5UERD?=
 =?utf-8?B?VUtVTlk0V1d6TmRuSFl1eWpSd3NEVmx5YVdKSWQ2NmdjbFhmSG1id1Q1OTdC?=
 =?utf-8?B?THRzbzF5SzFxb0xjZmNOeDh2cVQ1dk5taS83WURleDVJQzZlNk52WVdjWnNa?=
 =?utf-8?B?ZXE5RzZ4Vjl0dnNObnhVekxEa3hGY0lFV3JpVHI2NWpkQUxVb3RZRzJFRjRo?=
 =?utf-8?B?MnJ5TVNQbWVZeGt6bWI0ZnVsbjNlRWErWUhXM1ZhZEIvNEdTVWY5NHJMQ0I4?=
 =?utf-8?B?dk4xOFptTEJGOGRPZ2x4K0g0RGNJS2pVRGZyZGZER01kYjNEQlFlbEp3TWoy?=
 =?utf-8?B?eGZrMCtTYTZXN0RFNWtlcVZxU3lpbFVYL0xiNmJKZG5jTGRqRlh6WmRqSUFS?=
 =?utf-8?B?azl2MVNpcXRhVVYrSEwrKzZrKzVzZjRBOTVQWS9qMVRWNFlSYUc5blUzbTVH?=
 =?utf-8?B?alBIc0FvcnZBcmpMajQxWkdxblR2R3lQZFNyZzhiUklJYTJiY0QrNFF0WEJy?=
 =?utf-8?B?QjAxV3dqRE9JTXRBNkdoeXhLdTNLMG1oVFVScUJFWXFPNTRFMU42ajdzek91?=
 =?utf-8?B?aVBWa2N4ejVrTGpUazZXV1RpcENjQ1RuRzE0Q1pEa2ZFQ0oxZ3pHMlcwWk9X?=
 =?utf-8?B?dFFZbnlLN0FIUWd4cmtYYzc3ZFJ3VEVDMlhkelZ2amxWc2ZDTnRBY3MwdEd2?=
 =?utf-8?B?cHFyL09LVUFWV0V6M2xDUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkF2TGdpTXFsZHRxaE1sYWtOQ3Q4dnIyZGgvNHozbVE1QUROOTFYbURmSEZG?=
 =?utf-8?B?L2R5dWZmM2tSNU5zOXpNR0lpU1B5cmwwakdraGlyalZFZVZlWkhRd1pPd2hJ?=
 =?utf-8?B?alFNR05XTmp3UjFSbk5veEZDQkVoalpqMGtVZGJFZ1FBZUd2N2xDWnducjdk?=
 =?utf-8?B?TXB4QlBuemkzbnVBZ0dQTmNKQjAyWlAxNXFSWDZYdXkyb3dIRE0wU0llakxv?=
 =?utf-8?B?TVdUZlYraEFQV3RpNlNZMmE1V3IvSTFkeTMxVTBaZjZXMDdDZTZhNlZROEE0?=
 =?utf-8?B?eWFadlFReGQ4b2tVNWowSUN3bWhsS3I3L0tlVXdqVXVyLzQwMVJsZjNYWkx2?=
 =?utf-8?B?TWplRmJZbW5sVHhBM1gzaHowd3ZaeVorS3NocXQrdTAvSFZnRnp2bWxSWnE4?=
 =?utf-8?B?WEtNOWdSYmtFUGg5MEgrUlZUOXd6dUU0cDJtNFdCK2I4NVk5VDNqcGhXNEw1?=
 =?utf-8?B?TkZEdDVGakxzaDZQcjBJTVF1eWZ5ZmdPbHRQMk9VaktvbnRvNzFqQUtWRUlW?=
 =?utf-8?B?MmpBTHgyU2U3NklyeGkzK2xlYUlrUzQ0dTlrS25RNWVuV3VrQkJ0OFIxeTZI?=
 =?utf-8?B?V3NUNE9hTk9DVHJpNGphc05MZGEwaFFBZ2Z5bW04MEpkblVNOGlqOFMyc3ha?=
 =?utf-8?B?R3lFUlBPaFR5c0RBU251WnVMUkI5WjZyK2E3QVhyVWMxWVJrZnltYTJkdmZV?=
 =?utf-8?B?NWpWTkFNTFFhS2duTVcyN3ZDbU9nVmJPZnAzOE52SXdhN2pYaHh3NnVmd2lr?=
 =?utf-8?B?cFVjejlFRTczTEZPM3dqcytiMXQ4bkt6VFhISUxhdWZzSldERGk2RjVTMWF2?=
 =?utf-8?B?Q3NjWkVTQ1owVllRMEhaL3haU2QvaG5uTEhjM1RWMDN3cnRaRFJRSjJFRDBV?=
 =?utf-8?B?cUxYckpoUERUWGppMDk5Y1VTK2dLb3FndnlRYnFUK2Frd0lkc2Z1UDdiRWpr?=
 =?utf-8?B?Q3dPN0RKd3ZyOFp5U2JpR3RsWkhOTy9Gak1EYkZZUytBWjRlZG1VN1ZUN3Bs?=
 =?utf-8?B?aTVnMjhnTlphMEpucE1YekFiQXlsLzUzaG5QSWJFdm1OWHVHdnpVckZLeHpH?=
 =?utf-8?B?NVhIeFIzbHFvdzZuL1RCOGZGUkpnUHd0NDBhMmVmV3pucWFoTWFXWks1NlF0?=
 =?utf-8?B?U05uYmFUVlVuT1pQdTRxOUtzS0dTQUx0SkdpVFZzYjFPZUFXUHVaRmRrMVBL?=
 =?utf-8?B?SWNWNUhYTDhoaDN4aWtlOXRRT3RySXExNFR5N2VLVDRCQjM1RllhSHZNOTBJ?=
 =?utf-8?B?RTlYQmhnU3ZreDJGY3JzQzY2azVTOEhPcmcrUzEyeE1ZNTJsaGxFc0VIaFhG?=
 =?utf-8?B?a05LWkMwZCsyQUJZY01IWlkvSkpjQTFRMDg4OEFvYWlSTS90UnduTnFqdjI4?=
 =?utf-8?B?bGN2R1FLekx5Qitvb3JMaUo4Uy9JSnFYUVlpQ0RuN1BWbTI1UWl6REJDbkV5?=
 =?utf-8?B?dlRUVEZteEtGRkVvaEZFMVFJWDFDWFFWTjVyMXNMRXZNU0tiOCtDUDhCV1FW?=
 =?utf-8?B?MWdpZ2V6UHNnRDc2bkZZNUwzREZhcWtZY08zVW5TZmpORGdPYkxSSHZTcWJs?=
 =?utf-8?B?aXN1K0p4QTRuMWRTT3pwWFhXdjdocDdPL241N0wzdnljZ2ppbXdqM2lQekNo?=
 =?utf-8?B?RmtHYlpKRXdmdmpQZG90TGg3Lzd6OXhRNVNuRXVLN0lXQ3FWS0FGNERmNU41?=
 =?utf-8?B?Z0Q2NW96TjFuMWF4NEpuVXBVSFdCQ0NGSmNBUTJseXp2UC9uanRURW5sV3RE?=
 =?utf-8?B?L0dFWklBWXNEUDhzWHEya3JxYmI3NEVvZnJrdzNCZ1FPRnNOWUdGbXVKNGdq?=
 =?utf-8?B?M2FyWlRqVW11YSt3Y1h0eURWenFGUlN5K0p1RlQzZGo1eWh2Y3NPcktkZTBh?=
 =?utf-8?B?ci9QcFFXUXhJMUl4ckg0VHNnTWQwdjJzemZ3ZXFtUXVkellqU2NWbjU3N0tm?=
 =?utf-8?B?S1gxVlI0VGlzS3RtV0cyak53TDZSSzgwL2FxQ3BqNzZVRzVEODl6aVBTamxp?=
 =?utf-8?B?T1c1dXNrOHBKVVBtWWpKOFF4L2VhUkRIdThTeTVtQWtMYUNNWGt4TFBlZGh3?=
 =?utf-8?B?MWtsaFhYeGxGUE45TkUxMWlUVHJhempYOXRBZXUvT0puY3BYOCs4dFg2Y3ZU?=
 =?utf-8?B?ZGFjdTF1a0dFQ3N2T2pCcUcvTVNjcDZReVRHMDcyc21TTFFIdDIwelg3K2NN?=
 =?utf-8?Q?J7Qf4MOKs+rV8sMuh1YE87k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eM3gYNiJdt2Xt9UGVi0B+fKBlHcjRZgW08qZlc+KuKMvgjPLgi2sYuARiUCgEkG3CNcrbtpyLwG1SCklaHXFXkUcv0U2jSUPPpcIZs8fcqz4oXcHawJUhWAGHtgKXHB5oBQFkeJSGK3/4CRwaiviCbEj4ch7L+kh4d+Fi/44BP7XgjpJwrtkorrE1xQEO4x6EX03pJhdSSLdAx7R4QZZbwQ9WpTRKqBjluB2wsqVEZDi+8Y4+RJikURiJuhrZ3wEVZcALwcWIYlYWXEmz5vD9oMVr2huBXqnNZbgmo5FBRkgAebrgtPbXG30KWfOZXRZWqZSIun5pJjFxeAuIS4HkgeOM7hfx+Nv98C6jmRa36IDEErtbo47aYDgbYop1zX1t/dnwLX46FUlEW0lwFnsyW+5C4C92YDQhw3J0j1DFvKM7XkpnJi5/uBByvsZNrGzXgO8XNDzB4a4ow+WwXIMWomuzOlhHCdsYlZfrGZpr5Fml57iVujTpAeVBG5kBO/oq3hYVC5R5egetocb07udoo6YyRNXNmeLO/uReBlWBmGjxT/xGrOZEkoFQhjJ83U6i2MnL4lBxLYkC7JLkNmJmeab4pJbIHLT3gMuyw5Rl4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad2dcc2-1fe5-4d08-a3c0-08dcd1c8bec2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 18:45:30.6787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrWL8gT54CLTa29kB3KIdafC2csfBdlAT9EqPIp1M5zdQVQrKQj/OAHkMuchCEpb8UqrUgDvOLbHGXHkQ9rvh/DvWqy7nVbrUuuECzvZ67vig1+rKcaDSunDrI65RzRX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_06,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100139
X-Proofpoint-ORIG-GUID: fKtbX6ft4ANqfbbz3e-FD6nXYUjSmnrR
X-Proofpoint-GUID: fKtbX6ft4ANqfbbz3e-FD6nXYUjSmnrR

On 10/09/24 14:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.51 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.

Hi Greg,

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

