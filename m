Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B5255F28
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 14:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760451534; cv=fail; b=Ns+UjGXkcywGVZ2G5Q7Wh9MYFfgn92hOmhj+37qcHJCJXIrPjR/7jPMF+wFZkzvN1dQMjqQj1TMIlHEThazwOjG9/bVJD2APsM0z3qdGHtMp+9uGF5okyQDe1Whu5TH4p7NzATsHC5a8pLpVRUtulGfFhepP1HKi7qsVn4ws7n4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760451534; c=relaxed/simple;
	bh=KCfOdZxQEojZRK/eDsdcMaQpiHWqm9iXDqS81FNGsFg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nxXHu1eeVSUpeEsx4uSc0hDt8SqERiohLqUHtoqC6EHo6FsDBLeQtwwQQEHU9doAsPTzxFAIMuMYUB5II+IAOkuNxsRHqs3wBuxSe2xeFuMj9KxLTytDHrDbr5gJd7UYlEaUCuqcHBlK149Cx7oHFGUr2IwSW2G1W84mjmMfJek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pmevRQh6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bXfL8t+/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pmevRQh6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bXfL8t+/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59ECu8vu031605;
	Tue, 14 Oct 2025 14:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s7+DcTuznBiKk6Mt4WKd8Ok9OlggZXIQfTpk1yGmMB0=; b=
	pmevRQh6J+QZ2KwBtWTKzVu4+AYKEMy0UDs0M7KcDGyWo6oTnWkIPre4TCnhIeYx
	MslqW/yxbZoGASWnLr9eIAjLHT3MflBE8mvwdbSwIRSPsGx/WAwBgBStXtKNZnFX
	S4fUF+FFfjNNsdjlIxoA/aLSgNlZoK5Dz8RGERirmnngcS0YcwzKXD90xKH6h/DI
	GyTU/oDGQavHUyUi7ezgQjfxTu5XPWFfv94xX0zV6Z40hv5QCn/vUbr9AGsyTe+B
	hbTMg8gBilVpow7RWK7pYXKua2lDkR8paho/shSUDjlGljz+OA3Zc3cFCeu1QTFI
	mn97dikYNYqSHPLAkiZYxQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtymfu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:18:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ECi9qB037189;
	Tue, 14 Oct 2025 14:18:31 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010036.outbound.protection.outlook.com [52.101.56.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp90p86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:18:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g4QJ/1PglILYf+NDoClxNWVoqrJbx8pcnfbgKuWNbitZu3J2eeVnv70h5ad0k1hqekYx34zjEeFSChVVZ0jm+gindh/ucA8wrKRyb1+GriHwm4r+LqykBjHQrREjpF2Q+ZLWvTkG7ymCSyrs7t6V9O7qc9dzLg0/A1czYCRcg7ExrJ1ANs8n4DmIHk6VTiNcJG39Al0KH47jbfXT9uzi0G+rEbI/nZNNPQng+PD3y/BgzofVAk1q30WCWoUqrS3AEKUP88wVQZcL1qaKEfuFqdgwNHoSxn+3jW87I3GYmYMrNV/of63bEMuY9cWK9+yuCqM5AHB8Glbnxw4ehVleEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7+DcTuznBiKk6Mt4WKd8Ok9OlggZXIQfTpk1yGmMB0=;
 b=dma1VaZoFTBVVj5O9C2UaxaIhU6uQRvittuaYriAq4DRxH05D9NXjNRiJ6dhXF41DAKEnQXgOgkuH5zmMTPI+DWD8cwW9Jhck/hx46BlnlaC7nW9FtCU4yVAnk+7EzaVq97MvP46Ml/rarwNkcnzh6HcaH9aAHbGtHOUwQ9yYs7ntId0+LPcUjYdoWLErtaKOinZDQuBOA/mJGnc2dbSTMaIT/QYvytWvYCcZt0OMaEwn/EB1EY8E+u9DrRFrCxhNk27wg7kHx7QnrNXrim34iN8fq3oUf9pM8tpDu/ZaN5Sk6RCtZVp3VyjK3T82rGpL/Gqb059PPnp7wZtzq+HCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7+DcTuznBiKk6Mt4WKd8Ok9OlggZXIQfTpk1yGmMB0=;
 b=bXfL8t+/ij8hc2GKB4uBuegDKPzU6bjEeJSG4/E9yx+YgIf0YNUsh//AXltwMxdHV6JNUmTNbEWv8fEXFuWXrzlMDGgY6+a6Qs1q1JG7raxxcRF4dj6JEC7JhL74NNzQnR8T1rqmRSGOH0t2ZqDSQ89HpmRk5r8Dxs8/HBU5hSU=
Received: from DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d20) by MN2PR10MB4368.namprd10.prod.outlook.com
 (2603:10b6:208:1d6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 14:18:08 +0000
Received: from DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 ([fe80::aa3d:bc4c:4114:cd4e]) by DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 ([fe80::aa3d:bc4c:4114:cd4e%4]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 14:18:08 +0000
Message-ID: <26934727-df4f-4adb-a2f4-9f775ff223f4@oracle.com>
Date: Tue, 14 Oct 2025 19:47:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org
References: <20251013144326.116493600@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13)
 To DS4PPF5E3A27BDE.namprd10.prod.outlook.com (2603:10b6:f:fc00::d20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF5E3A27BDE:EE_|MN2PR10MB4368:EE_
X-MS-Office365-Filtering-Correlation-Id: 558095af-4c16-4790-aeab-08de0b2c7f63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZE0zZkd6M3NwaDJVdUo0NjlWV204NWRvdzN3alJrS05xME9vZVdpNUw3RGRh?=
 =?utf-8?B?aGdER3V6NDlxQXl3aHQ5a005Mm9QT0w4UDV4SWR1SUNBZzVkZWtmajdDR2pU?=
 =?utf-8?B?ZUJtR0w2RnRXS0V4QkxXMzFlMmZUdUFPc2wvTjRZSXB4Vkx3elF5WHRReVZt?=
 =?utf-8?B?dTN5TWFyWjRjZ1ZaRDNHanZBYnlDUHQwRHNrYkhSd0VMWFNMRWo1YzI0cjYy?=
 =?utf-8?B?UEw1ZTZmQ3RpQjBHYk9veU9heEYwcXhoamN4a2Fldkhnc24zQ01LZmltS0NG?=
 =?utf-8?B?UVU1YjJ5QlZES1RhOG94TGpYT3JvdzdHU3liT3BDTUFtWmJaSmJjMDdwRmda?=
 =?utf-8?B?ckw1TUJpaVorM0VYdW52NlNSbUpXWnIrVW9vNUo0ejlyb2RGVVA2OXdpUzY0?=
 =?utf-8?B?ejdHM1NTWVFsY0luMFRJTlNkMGc3QlpiTEJwYURtYkRVTzA5bStYMk4xcjho?=
 =?utf-8?B?dlNsZ3FBdTFaZzBHaGZ5cVhQOUlkZEY5OHFCb1FhWTd4TUlRajA2L1pVdzZn?=
 =?utf-8?B?UTR6RWI5TkJCVXl4eUU0QWFwTjhraUhqVUNBYlJyNEd3ZjNEbjlmVUZnbkpy?=
 =?utf-8?B?aFBISVVwMmZiVEc4T3VQWDIrTTh1U3N6c0d3bEM0bm1IaGV1c0pHcUVXR2V3?=
 =?utf-8?B?aE5PWkh1dHhnN1BGb0VUVy9jekd2ZjJxOVNHR2prYjBFUm1sZHRsQzNLUW1y?=
 =?utf-8?B?bUowQVVEZkZNdVIzbXdFem9ucU0xdDdscHVXMm56Z0VaaXNQVFc2OGhhOUxx?=
 =?utf-8?B?Skpyc2tFY1VXdFNSOHpFQ2Ezd1FtTmZuSTdZQ00wVWVzNmRWY2RKMzNsVXps?=
 =?utf-8?B?OVFVT3ZUbVpUaXNkZ1pYUmVBd2RNMXR1cUxqNW9MNEo3QWVBUHo1V0RPVVlq?=
 =?utf-8?B?b2owdFZLc0pJNnZvMU54QmhWQU1pSkxEby9yN08vZUJ1S3ZweWRkRmF0dGRC?=
 =?utf-8?B?QlVHQUk1eEw1YUFhTm1sZVZoT1JidldFbm9IQ3JlVXdRblYzNkVmeW5OS2RX?=
 =?utf-8?B?b29vb0xuOE9uME13NHF1TzVSTlRaNm55WnZVM1lmQ3lrQk5Bb2dGRVJFWTdL?=
 =?utf-8?B?NTFEV0EvVE5NTVY0RVR3RGdadUZoc3kvaXFsdHZhSmRhL0tXTks5SHRxZUtR?=
 =?utf-8?B?MjN1dDgrbUxoOEtndVhsUlMra0kvWUZVOVQvVGlKQXQ4eWs0aDlWV3VKWlJU?=
 =?utf-8?B?NVEwQWoxRy9uNVdKcEFLQmNkUklXUVFtVi9qWnowdVByVjBCRWRvempJcmhR?=
 =?utf-8?B?Yk1Qa0U0bGNUcjhqd3BRUTB0b01MaXV6N0xZVGloNkNQbGlHSTBCeVNEQVBG?=
 =?utf-8?B?SndkQ0xIOFc2cXNCWUQzZVV3UGZtRXUxbS95azFKOS96dTRYY0ZuRFp2SkQ2?=
 =?utf-8?B?TVFJN2Z0eDRkaTJqRktTOUpOR2x6bGJGa2RVMnRRYXZhNDBCOVFhMU9SRGhF?=
 =?utf-8?B?dXFZMmsxcE45VCswNWFhaUFXalVYQVlQYkZZWDJLR05xdzZodjM1YUt1b2hY?=
 =?utf-8?B?MTdLYkhHa05pTmNEUEFEUlQwbkIvRkY1ZENzeWI1YzhSZStHMkhnTENyVk16?=
 =?utf-8?B?bU9BbUI0WFV2ekxoRGxrdVRlbUxFV0RNdGcxOURsWjJKY05BanNlYTlON1Ju?=
 =?utf-8?B?SFVwc29YMUhxTDBDdmJOSmNXZzYwTEhJSWJyVVFqaEs3Y1ZiNHN0OXlkcjhk?=
 =?utf-8?B?aEx6LzZtWkEwcWg4bG9sZlhrMVd1VUk0Sm1VdzZsd2RLOG94MmpieFlaYVlv?=
 =?utf-8?B?VkJDSW5oL1l1NHVobVlkQ3VYM3RFeGNpdW1sT3M3ZUFEMWtnQ1VsWHkraU9x?=
 =?utf-8?B?U3MvejRvQ1ZJMFk0VnpNblMxL0JRc3VKbkxJMzF0ZHpOUFZzLytKZVVzWTds?=
 =?utf-8?B?bzNiN2twUkc5cDM4bW9FZnlQb1A2S1RKcWpSTWF1WmZKQlJTSzNTU2pCc1VW?=
 =?utf-8?Q?BGqlfbcmDiH03QqOvrZ6SCQbzajjUwxt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF5E3A27BDE.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFU3Wmlyd05ud1ZZSXNkUFg1Zk1JR0RSTG0vWGVSbjY5UGtKLzFsLyttUytL?=
 =?utf-8?B?K1BqVEU2bmRVTzFiT0F1ZGc4SDlMSmRYdk82Q2ZIc3I4bkFKK0JMaW5iME1U?=
 =?utf-8?B?WFVWL25FRG9XVDdVZVVFTzBONzlvRTQ4V3Q1Um1TZXl6RXIrU2RBdEZyTVRY?=
 =?utf-8?B?RmpZelNkYTAwQzBDQzdGdlR5dFQzUHN1bGJndm5RaDVPRG9aaUIyUzVKQjBi?=
 =?utf-8?B?OUlSbExDdVFzMWwyM2VTSlZwMS9RMlZsUnB3Rk9acFN2cldySWNLRzliN1FF?=
 =?utf-8?B?Si9EVjFYcGJWcG9OeTF3Nm9yMzlpU1BIa3M4RTFrc3c5ZDZ0RkoxS2oxZEFs?=
 =?utf-8?B?cUdlV0NCZVppazhMTFJ4TjVxR2hQeWdiUVZXcEl3Z3U2RXk3QjVDcVo5dGxu?=
 =?utf-8?B?OUZHQlJMUGVLOUFKQ0tZMzlReFo4b3h1UkJPRDd3ZlNzRVpuQ1kzaGkrWFFF?=
 =?utf-8?B?VkJZNk1RTUpoSnJlUjk4VXlFaERERXUvSFNoYVprdEs5QWc1RlJwMDQ3NlRB?=
 =?utf-8?B?SGpaZ1NSRHRISTZZbm1zN0c0SFp2RTZndjhhM0o2Q09mVzJJNW1uYWZ0ZWRB?=
 =?utf-8?B?RDVlUXd2N3JZVmZ1VmFMRkUvOVJ4YVFsbmVrZ1dOQmRyVXU3bG9OZVI5UE11?=
 =?utf-8?B?SjBoYUxETzVBdnZHTzg0RE55OE9xbk9JRzBBcFRuYXRLUjN0Znl1azlzOGJR?=
 =?utf-8?B?ODh5MVJKVVUzaWd5QUJuRWxUOFVDOHhBbnNSNFVVRVBJYmxNQnBySFZPWEV5?=
 =?utf-8?B?S1ArSjRXRlNBUWlZNnhML3pjbVI4bFlwVUJ0K2J5MkN3TG5iMUtkSzdTVUhU?=
 =?utf-8?B?QWo5TzBoc3hoQmNxQXlUZS9mMzN5dEsrK3VieU9aOGdUdGxkQm1HNXB5VVM2?=
 =?utf-8?B?cVI3ekV3TlpCaCt2bUpQSE9lVXkrcmZBRk9Jd3JNZXBza3c4bFFOM2lzN3pP?=
 =?utf-8?B?TFRRR1cyQ3g0TVhkZ0swTHRJdjBvaXpqWjdEb3VQV1VBOWU1UGpTMnpDaEVv?=
 =?utf-8?B?VmxXN0FYQnE3VTRuV0lIT3ZwSUpzYVAxNjZ3MUlxMWRaTmJnalJiWTlHMjI4?=
 =?utf-8?B?RkNDSTUrR2VnWSs0b1FxcXg0SnR2MmtsR2NGZS9Mb3d5bDF0RmF1Q1c4Z1lJ?=
 =?utf-8?B?YnFXTTNwRy9CcEFBcFFteTVzdUhsRjNzeFVHcW1JaEV2SEpEa1JCTzVjV0k3?=
 =?utf-8?B?cFpodjlvYVo3dzJyMjJRSGdQYU0yTXZUSTFFdXNQV0pRYm9jTnhrUUozSmpO?=
 =?utf-8?B?ZWJuV3hIOUZLQnhmU2tVMXRGelBpdXBTV2M2WTkxU3dPRERpbVVsbW9Wa0VE?=
 =?utf-8?B?OHZkbmVrUnQ2MzJrdmtpUFp1V3BKQmZPNExrQVQ0K2FQNXBOZVNMWjBpTXQ1?=
 =?utf-8?B?K0MwWFc4eXNneDRVbExHUjNmc2xNWFlrYlZWRHNOUG0ydVFHUDVBbXIwVzdT?=
 =?utf-8?B?V01ibVNrMmlnVFU4c3hEUXg0eTJUR0xqQXVySXk0a0NpOTJhTzVsMUNmNlJ1?=
 =?utf-8?B?aGd3QjZnQ3Z0L2hheU12RnNMemdjZ3FvY0tYZndMU0RwSFJlczFDY2x4b0dx?=
 =?utf-8?B?cWpDSURyYjZNdi92aGxqcGtjR2Q1RHVVZ2N4aEFUVEpIc1pmTzB0Vis4QTBV?=
 =?utf-8?B?WkdWMzZIeFU2Nmx2ZDRzWVhuc1hnVGhtNVU5T0dtb200SkVBYm1OV2hBMFQ0?=
 =?utf-8?B?V2hSaXMvQUxadmpXUWdMc3U3OTM3VE1LK00xQXBIUFdpREhXNzROSWVPY1pp?=
 =?utf-8?B?WUZscjlucFgyK1FrOVMyM0xFWjQzQjdCNklUemNHbnRvVXlEWjk5djU5RFZQ?=
 =?utf-8?B?WEdkVUlCTmZ3czhPY3FnN3QwNkx2aWF4N2RIUHM3UGVmK3FPd01vazJiTmNv?=
 =?utf-8?B?VVk0WnZWM05DS3h0bkJwR2gzN1I1SDk5WWo2WEF6QzgyYWdWUGM3Q2N4TmIw?=
 =?utf-8?B?dWJEWEpDYVJJZENJTWNIcE4zeGk3UGZOa0hSUU5wSmVTbFVxdWlLUWVqcDVK?=
 =?utf-8?B?KzZHeFp1UFZoWi9aUUN1SG5VQ3RoOXlJTk1ScmpNQmxUYTFVb3YyTG94TmtY?=
 =?utf-8?B?ZzdISGVQcS9GS2wzeFFHQzkwNEtrTUhTRFc0bjhtSTNPK21DbWtjZXBHbzNk?=
 =?utf-8?B?YVZGaDRhZk5uM0phU2ZxK2xDVTlFT2RZTDkzcFhFelhsRytwVHNNUkJiM2hi?=
 =?utf-8?Q?M+ojyy6P0YIMcrxIF+JzZI4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7Cln2kr7dvqcmIRf+7aE8N1I7YQ/SbjOKY321sCS2zAQ22bGeYZNiegIYUa0gWejdx/OsJqJwuKcksd5Bx4GTKFw4aXK5J3XbSyp31BiyXzhZMm6JlmOcZDDTeXLjVZBXwpn5uNvXg2zlF69z0JUUfyKC7n7yi0mCePEOp8rwpoc59CUqvYvvE9ggKSz7Evv26VUOIWhAxeAtSIe056thDC3Qo77rTDYb7A5JPGhJI+UY41iK+1bEHv6n9+IavkVZ6007IKYDx2eMqHnhZCtumHLsAfhYgDE8wfjgOl5x4wRtOJ2pRXwJay9sqZL1hPxx1/713ZFSIgdpMrkKx6WMsG5c3bczc6inVnV/owhaq0Dox3hMQKKxr58u1H3fjLBtDVzOldHJOzogjrkHcnuua0AbEnIiVzj1MUpILlVT2z1jOTSPB0r8YQDbUFI61GL+fz/G+vmkLjUoMjGi6iJ9VXaleBiYZF+m0272pNvP+wEc76dwP9tMU3Uua4bE1UbszPnDVZEewPZOKujM9+i6FasBlZDstW03AvNilVQeXNxVRpREfk1yFcJBaC1+60KxgNMnvSGkwOZBKIE9+5gBdg7n7vCLY8VuOY88gL+fWI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558095af-4c16-4790-aeab-08de0b2c7f63
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF5E3A27BDE.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 14:18:07.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3dr/vvvjK7laKmsBBWwlzYWTDjM3lYSv7nq3xZrZojpLhFPjFZAFPMsC/ALwCoSYMq0Gd1l3S23p8owZkLG7vEmO2Zc8z2sK12iUtoERbz3XITiwIUoAmdnTNb3VmKh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140109
X-Proofpoint-GUID: 6Ahk9gj4200iBzcgs0xpZ_1SQqodebYA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfXyQgkLpSFOvg3
 tAUJ1PuK3Y4C7pkKu5jGrSuzN9qCoFwzLb8REXbH7X1Lw2Hth3G9eBeHzPbM52VuvlcL4X12C8N
 o2v0LKVmYcjmo2dZWhKIM/dVB+rW/SK4FW/28tKf/mXXE0g2Kgqzz7Kf2vyNLzqJHxdAkHSo5xy
 yDWr0kfM3bxOeN7mAW2HwjtmJPDj6ffCtgvJgIZZF0opLDgfRpFOnrBHXaqR8BrKTA/d7zFdb+R
 hYOriKn3OG1AR9OuL1RvlBzBB9tI8+m1oU1O7YeAoLxAn/l1Xx6jtUcM4xVBuMweqttYBhKFFMs
 xvJQH2KcXL9yZ8OgdLlhPxSOYRVVU6NvAqzNvhCxXWw5xdzqSbd0v6VxSlf9Vshv3ZbLCsSmYjG
 V8bTAKUdicU8Zyg3xzdbfa5GD946XQ==
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68ee5bb8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 6Ahk9gj4200iBzcgs0xpZ_1SQqodebYA

Hi Greg,

On 13/10/25 20:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.53 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
