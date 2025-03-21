Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DB41E98E7
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 07:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541321; cv=fail; b=lmb4Askbul1KmnuJhUKQuBzuDhj9NnTKK2mHwR+iRpmgYvDqsXppQGSUOV9B+pQMp0hKSZKJw7MMgLD8Es0Sn6RYnL+v6ntruY0o6+QDujJMbKumzfn536nmPMMBMS+mapExeyyBt8CRUIpoFQdal6Na+qhdbhtxfkMKdgxXu3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541321; c=relaxed/simple;
	bh=addZ5a6HJ4liS8aPnuhbYPKKP0J3xqtwLz2iaMDaFp8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dKYUDOo9TvlyZoFgi2dH/TkprUNpEfmACaPJr+4Os7rzyic6CDJWukQq6HXJ7/xf6YhOFtxAQgPNAkRH+G2vzXdD6ytupHF3pVQLIm4pn0ynJziGkQ3OAVUN1ab8ZpeYVF5lZ4BEJJOJCCgfuEsh+sAD19aob1CZaSuKhB/8BDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IJwSqAEK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dtoFfkz9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IJwSqAEK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dtoFfkz9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52L4uvhj022124;
	Fri, 21 Mar 2025 07:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qznWfwY0dlhJCCDzF7jwFUvwZ1GiEJBc+ZUI+Eepr40=; b=
	IJwSqAEK65lR553QLnTfkYiE2/JXLuUWTmwREYjh/vz82TneZ4gCpSmPdyBU9Fzp
	QYBZh50z23/1PsvC6pSoYOsix8OErGUTQXL2fy45as0xaDXfIh62vBTReMGJZwbB
	ke0gZhvE2ZO/kXT1DSAIqkJGJFZza5rgQLshXk0ixzBXsTctnrBfUTfFMU4G7X8p
	9CyV9z5lfX+KhVZKfcEs8D8+85yHggUzLQKV4DSuzTrSV/QA3kAbUkvXMJlAHLIR
	wO41Th9mOGgEXy4jEOxegzqErgvsXn74DikkwgbCDAmI73Q0Aea4Tl7CbQ0HM6EW
	Qv1wYtjh3uHfUckXUh4TvQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1m17tsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 07:15:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52L772Cc022465;
	Fri, 21 Mar 2025 07:15:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxc9m6ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 07:15:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCwt/KIi0Y/aZRlcwouN2ZipOlnQvBnAsWo+lV3GrZLceeDhLunBdka834y5Ue35KihMYd/G5Z+TOJNc5DpNl4V2dYYITnHq3qI1wpLqRW9ntolgIMOtBjD3MEHH4Bre6NaOOSwNwQPwVvB6AxaCQlobk9yShrKXRWUMLQG8tXnP6bQ1mXQCugloQsJTZ5uBlqPIdMpruQgSHDR30Q0/YB6e+yXiz60cKt5klo8KDHUU6G0i9DX04sRlPBx9TEfvU5fQDQKSPIlwyqtfNIhWvVSVDVIz8EGMZGykj6nyZH9sBX7Z5GN5Wy/G72akyo1P8eg8UQAboYQrtRURd8SfKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qznWfwY0dlhJCCDzF7jwFUvwZ1GiEJBc+ZUI+Eepr40=;
 b=U83jaBR8tXO8B5bGOEkQdnUzxLES+Z8uHD9CPEMB031LVgej05PMxTCFvfXTHB4haPfhWrEKEP8lZ/URU6LswHIaY6GjSp6t+XyQegg+LAgsLRRmQCsvscirCgNbbgR9MOGz80MvZ6jrgqQSf3Y2zWA5NgB7buLcFY4/qFb0KtgSh3iMKltr+kaa4WuBDujICu4jsb3XmtqQJo1dNXN9I28sGA+Unnwx/YAAXy50YtlNHvlRnCf8JkOdWacTVVzKpSpNdqZe26xFWhzzs5J60uSlG4a9mlMvtHNsQ1MsXIxxKe+ScpALPoEddolNsBVFjdoeTj05aB7w38+6yaJpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qznWfwY0dlhJCCDzF7jwFUvwZ1GiEJBc+ZUI+Eepr40=;
 b=dtoFfkz98J4/7A+DNnSYM1VWZh6mx2M4FH9+zf8i1bQtiTODSDxmjgQF3IOZ6qTKka+Dv1YyslVI+q6azPamd+qt27p7snoWgq4wF71229GOOcDRlllxgN23d7G5QIJ+qwH1VDO3LFDoaCKIh2WBGidYP+I1PwSTtRc3Ju7eBk8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MW5PR10MB5807.namprd10.prod.outlook.com (2603:10b6:303:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 07:14:53 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 07:14:53 +0000
Message-ID: <29e734d9-b9de-45c7-a21c-72a76238fa2a@oracle.com>
Date: Fri, 21 Mar 2025 12:44:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250319143026.865956961@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MW5PR10MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc58668-2825-4bc0-8340-08dd68481385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3NMTytqY3cyQ0xUQnZCODBCVmp1Z1l4bGtmeldhUTFRNFk3TlV4MERZQWZL?=
 =?utf-8?B?Qkh4MGx3VWlhVlYrWUF6Uit3Y0czUTVMaklpQm84ZzlxRG1sYTNxemR2V2k1?=
 =?utf-8?B?bUNXWUVNWXh4WjVrNCs1RE9ESmpFeERzQnRxSVFUajFUUGlHSzZoOUFyMEwr?=
 =?utf-8?B?YTRYSy81OTduN01Rc2pvWElkZFBIVHVEVzJuZmhsaVU0bUtIbEJpZUpWN21N?=
 =?utf-8?B?a082NnhHQ3pUaDExWjlleDhCUHlybGxYenpYK3lid00vKy9LOTdEQXZKUkZp?=
 =?utf-8?B?OStxYktEcSt3M0pUVkRZTVlCMmRyOFJIL2NManZsL3UwNGpRUmhHb2Zpdmx0?=
 =?utf-8?B?UEJjUjFPN2NJRVBZSHRkOE5XK3B5ampYbno4TTlWWGk1ZGpCQURXWUhHTzl6?=
 =?utf-8?B?VU5HVGJOd3BJMFZWOFM3MStyRnZ2Znc1d3g0VnhlejJXcXVzdEgxd0ZjSGgy?=
 =?utf-8?B?VUVnL3hSZTJpODJ2L1FPaVBUMlQ0M09CMkdCL0UzemprZkV5Y3VyTzhNU1N3?=
 =?utf-8?B?enZnektVK25yNnVjV1NsZGpWbS9hcjQ1T0U1UmtxTVAyTlNGZEV3OEZMRmxu?=
 =?utf-8?B?Q3pBRDg0dUxWcGs0dndmMjdRRzM0K2dONGZESnNKZ3NEaW5sNDN1ZTVKRTRj?=
 =?utf-8?B?YjI2bENSOTAzaVByRktVSzNwRUVEWE0xYk5IV3dSV0cvTDZ1d3RpZTV5ZjRD?=
 =?utf-8?B?dUVidWpHUER1K2svaVZjVFJ6MkVJb2JZUEVQU1YyQVpUY1lXcjhUK3IzVlNP?=
 =?utf-8?B?YitORkR5NzJGcENNZTBkc1JvSFU5Ui9tVXhZYmMvcVE1SVBpUUk3bTZsWEp3?=
 =?utf-8?B?N2ZJcSs2V0xBVjdpMXJGNllvOVZMZEN4TXlPUmx2QU14UkZwZ2xJbTRJUDQ1?=
 =?utf-8?B?NGI0bDNvamoyK1JNVlpiWWNxRWgvRXlwTFl5ZEM2U2l5QVZTdWdkSzBobFdF?=
 =?utf-8?B?Umg1dEVaajhHMHY2OUxEMHdhOFcxYzg0Tlp4K1ljMzAyZTNiSkdwNEJ3eTNv?=
 =?utf-8?B?Vmh6aXBtSEt0SnI0NDJxUDh0UmlTcDEzb2tCc1JEZ3c3NjlML1E5K0J5VVBS?=
 =?utf-8?B?WW94cElOd0RleDZreHFLcUhNcWxxbHhpaTNodzJuZGZneHdWb2Frby9MQkxG?=
 =?utf-8?B?eUZOZGt0Vnoyb1ZXZUthUEl1d0NFTFZrUmVLcmV0bDlsVWtjeDdKY3FCc0kz?=
 =?utf-8?B?WElGMXNRWHBVMDMxZGg5L1F3OFFwaGo4TW0zaVJ1Q3VrVFNrVVRQYnpJR3M5?=
 =?utf-8?B?dE55dmg3b0UyR2l0SEl4Y2RrTSt0MFU5Q3F3MTVDUEFOZklEZjIvN2lySGVa?=
 =?utf-8?B?bmFlOWl0ZHZwK0pDRmE0R0M0ckE1R0JzeTV2UWRLMXM0alNmRWJobE1EUnlW?=
 =?utf-8?B?WjMzcHV4TnhWQVUycUNVRktaVzNYaVhLVnF5YXBhMC9IdS93WWNKdVdsYjg5?=
 =?utf-8?B?VHM0NDd4TkxlMFVudlpRYVRxcGdkUkNHb2I0VWtlcU51cDVLa1dJcXIwOUtD?=
 =?utf-8?B?ZU9CSndUb2s4MGVkRU9XZWFsRW9DWEUrTk1IWFluL2xEWXZpYllTMExtSHdh?=
 =?utf-8?B?cko0R25sU2pEUnRrZldXVEFPN3dDNk1oMmNocEgxY2VkN3hlT1IvaUNQem1M?=
 =?utf-8?B?eFk5MFJoMUY4L1FicVdVRm9LaUhkMHBjZzlCRU9icTNqLzFlZGxEaW1rdk45?=
 =?utf-8?B?UmNZK0JZZEJxYnZEeWVMOUU1ZjN3L2JVM1BJK0ZEbVhUSWIzWkFjQXFaRjBt?=
 =?utf-8?B?Ty8xWjZjQzF6NXRPWTgzTnlqck5yeitYN2trRTRWaG5UdndkSWEyMEJtMDFE?=
 =?utf-8?B?TFpFRjlQNXhGWS9jeUIyQ2RDaUNITjFCVHJzcFZ4K1A0S0xVeUloL3pGZ3c4?=
 =?utf-8?Q?qSXg56LROxNfV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkJDdEF6TGJPaEZUcTBTbGZPVlBTNGM5cHRUM2h1VENLY3ZmWkNucWN2SFpB?=
 =?utf-8?B?MVFaMW9zSUUrYkVyRTIvWmR6TTZ4c0NkUXdYSjJnZHFmQllJQW5iL1g5bnFY?=
 =?utf-8?B?ZG1weXNVRVBpUkRsZDJ3SUUrVE1EQThpUmxjcDUyMzk1U2ZYdDh2Z1ZXMW5N?=
 =?utf-8?B?aklXS2xKc3dKZkZSQldta0IxbUdxaVBja1dRWVJHVXJnY3AzT3RPYU85ZmpC?=
 =?utf-8?B?SzNYRHlZc3Q4MDJ3WVRZWjk4K2U5VVFQQW81Z0ZxcnFFY2FtaGxMeEJUNGNS?=
 =?utf-8?B?UjUveEFienJjQUJkZW80ME1nZndFbGNiWnJMTnZFQkxIUGF4QmRMMFhOVUgv?=
 =?utf-8?B?elRNU0paVkxMSHdvU0J2SXB6VFJMM0JWd1oxM0Y5OWI1akd5ZFFxNU5sd1ZO?=
 =?utf-8?B?YVF2Qk1idldINEs0enozRlJxUUhmTTdLcy8zQUNOWnBkejgyZERxbU1yeEhD?=
 =?utf-8?B?N1FGVFpEbEVmSm9tQWJVeWlsTUJ0NFFiVVNmN3htZlBEM08rZXRrZEx5NWN1?=
 =?utf-8?B?K3FjbDRIcktYSjJrSVhuaTVrUUlDQ0wvVFVOVGxMZzZ1aWFFcEloMEhJUFUv?=
 =?utf-8?B?U2xpS2NKQVZtdVJaNEdFaE1MV3BBWk1jWHR3UXh4dW5mMTFPaTlDS3VmMVVH?=
 =?utf-8?B?ZHNRSEZSaU5YNllWUlBSaUdXcEhoalF5TlZSMHdLMkhYMW9rM2pTdkNCZ2ZN?=
 =?utf-8?B?dk13bStHSGkvQjZTSHJmQnN1KzczTUJpRGQ1d09nNzl3ZzFRazJRQ2xsZHcx?=
 =?utf-8?B?bXlPWDYwZEp0QU5SbjlmSnFwbkdOWUJ3QWxYQ1QwWWVKV0dybXJTbkdLTUYy?=
 =?utf-8?B?aFV3MXZrVWRHVThyTjJVTzdZbGpDcURwTThBQXU0Mk9Ia3lnYlo3cFFnTzBD?=
 =?utf-8?B?MVJsalJiVFRTdDBjYlpUdUNqMGR1RnF0Y2d5dmhTVzd4emdmOFJRS0lDSHBs?=
 =?utf-8?B?cllOaVBKVjFZZFdrZDhyOGNVbWxzU1E3ZTk4V3htMU00YjFJRml1eTcxYXhz?=
 =?utf-8?B?Ty9MSlNRSXh1YjlDbys0eVJZSElaNVpNSzgydE45S3daL20xTDBkeG1BaWJ1?=
 =?utf-8?B?TGk2SEswU1I0ak1EMFZkQ0p5VVloSjNuMCtKUWpOdmJDakRPcy9kSmJYaDFT?=
 =?utf-8?B?L01sSFBqSnZ3S25INlRacGdkWDZhRzhUN21jdnd2SjhnU1BWQlFHcXRKUkVQ?=
 =?utf-8?B?NGw4Z05KSmZpM253UXU3a2JScExUOEFGRzFaWUNwUHFFNGJ5ZkpkdTdlcmN6?=
 =?utf-8?B?Q0Y3emFJUHFiTkxoN1owajJOYW81K0Vwak1zN3o2ME5NSUJoKzZrYTZlQlZv?=
 =?utf-8?B?RTVRVUNSak41Q0dMSnc0bEY4dm91Y1dYbUhENEIxTVFacHZvTnk3SlJ3SVln?=
 =?utf-8?B?ZlRxUENGRHNDcmF3d2V6SSsyUndxK3ZHUUIvQkJnVXROZVZZNE45ZXFuWmx0?=
 =?utf-8?B?NXJQQ3IwMnVyNjRvaEIvczNLaVozb1l5ZkRBTTBhV1NzSkVGWmo0dk1JN2hQ?=
 =?utf-8?B?bmNYOStIVUQyRDluLzVsNHd2eGl6bnNCRy9jYkQvbEV1ZW1yQThJcjA0VW9N?=
 =?utf-8?B?SXJqaVludVFGSmdRZlRGU2R5WGp6N3ZROUNHWmtlQWNtY3lYaUlBNVJxZzN0?=
 =?utf-8?B?Znk0NmEyTVdYemhkWWtEQi85SWJGT1A0bkZBZjRzeU1sNUJLN1RuZE5jczVJ?=
 =?utf-8?B?Y0RnRUdIcUNHSXNrbURTbGlOemRnODZmUTlCZllvNGRNUHFxZUlFWi94YWpa?=
 =?utf-8?B?bWNSQXE1T3VtNzJ0R0FLOGNCdm5NNUk1SWtZN29CTHJLTTBHMndMWDRPMmJ5?=
 =?utf-8?B?VW1iVndNc245UHJZWkNNTEdncDhBRkZQNlk4N2pPZ2NZZkZ6QWRWTGhGVXVL?=
 =?utf-8?B?ZjVvT3RNT3lQTW0zVUYvRXloNGVkVGlFMzAxc3ZQZ0JpVWxPblpDN3NyY3gy?=
 =?utf-8?B?bFllWEdNaGREbmoyZVA5UE5kbHdxTyt1TDhFaTdhYkFjYmlSTTNVVStMeHE3?=
 =?utf-8?B?dTZyMHp2eGRhaXBaeTdxcE96anRPcmtrYkhXczJRWjYzTmlpSG9JZ2I5VlR6?=
 =?utf-8?B?aVd5bTdkdVlDdnYzeDc2eExxaDJmaXdYb3lqSTh4TG5oWmMzZ3JZeWdIUTZs?=
 =?utf-8?B?U3JXczNVeFYzL2IwdjNPZVNkWEUxNEpSaU1VRnBnYmg3eFFYeXdNSmNuM1FY?=
 =?utf-8?Q?jdl0fq9lXfxySaQeAINQftM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	59E4LFmZNmCwELbN7Jo5rmxckRxF/wrdlqbDV5E5g4RoQAfRMlUofw4LMtIgtpR3r1NuuycoNMyaTMhz1fPJD8MmCFttAxtjkTstGVVFE5omHE+Cx3taCbGAXQmJyTCGjAx/ITjy+yx/LQ78r3tPfLkZ6TCm/3uOn4satILTF2ZnvSS/ttA2e61FSnuGanpfkgfic5/9vj4/lNKCTQcqZcZXG9yAI4cV26Bar+qGLaNTPdB9WEj5UhQGawUItJXEqSEnpeb3qHqmYQRveDhDIQklkqp+P09MkHPqaNq1A0EB7ntX7yYu0JxJAEvbtz5t/8CQ6wP46MMkQ8rnzCLP1TtFeFfECPJIAvIZ5l6cD3qo0qvu+12XQblNhOtpoSCbPCIFMxZvv70SSIvyonZPnIurl5BLWagT+8DPqqs/7Q25/xChXTdo/6UwATQ+nXLK1g7hW3fICi+MEqAfRNSj7F8X3EVo1qUGZlQZm07gCuzm5q9E3pvpXukoIf4V58+ZK4ZAKT1FT1I0AMCNGWXRmJfXrXg02hpzlObLBJhxMV8gjFmeMo+LiFHQ/Ih73ZRIPUaa7UKVQp7JV7vmi+7/gRiEiHp5q1f2ZEWi5ZYasuU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc58668-2825-4bc0-8340-08dd68481385
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 07:14:53.4418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAd969eKHM7rgQ8owlxbyr/hNflTjznOYmStlmZ9rOMkrd2fyMcOKRfA51EhO5P8k3DnMKkgJsb5QjaXn3ivcCLxVZ4GuI4fDwnP8+YHejQjChNxUQFrYcIPxflapiGh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-21_02,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503210052
X-Proofpoint-GUID: BT8BAhv4K1iX4FQpl5wGcrMGjJaMQzp1
X-Proofpoint-ORIG-GUID: BT8BAhv4K1iX4FQpl5wGcrMGjJaMQzp1

Hi Greg,

On 19/03/25 19:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
