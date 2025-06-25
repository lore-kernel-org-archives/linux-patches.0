Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79EC263F41
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750859465; cv=fail; b=FL+3vh4eIdm+S1MG3dUi9ASkzOuxccMxHXeCLXCAKiMof6kjpWwbHQYfi1F7TrVCvrdsauXm1sL+zBk4T6Wb0fkTXzPPiHPkrglSLhhK9QKLHnfRTf7KrfhIV167jnvX0+soYlCFict7FtH93z1YDMdxqMWXhQyqiYOdSFM9SAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750859465; c=relaxed/simple;
	bh=X67pjyu5wx6JhzNSst8yoHKIhJlUVqhl7cxLZj6VBIc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pU40SEBfnz59F2POLf7ZNXicBePa4cF4mtS6s1HrmR+BYaPBkcFg6VvLgbpbF8IWS1GL2/XQxf88gIH2sCvSHRaJpm1O5BjXvJ8TovHlvj9g6GYtEXByfyhB9Ez0nK/kFWuS9b9EiUI3U8FAu8DRty8R3m/ddS+ObTI5fU9JSM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mDQYlivJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v+x1x0D+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mDQYlivJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v+x1x0D+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PAqAq4015260;
	Wed, 25 Jun 2025 13:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=f9qmCaoN1DLz2PtkO/PbxrNL+hnO6eaWsvp6Fk0C7ak=; b=
	mDQYlivJJ1rgok8VwT0+NC1jWQtc7/vh4OEExgvAO5JbuPM1CWWM4ovQBp1ofdL1
	WajY1iWqraM6sbOGTl1CS9tPUuk5aAU2pSnOI8L30MGKurABbfykNlEP9wOTq4E9
	fAnqK7put6j4YsjUwIKTVDTlkTdT661IFFjfwzsrv7GD/7YJtAykFCzu4/DdBiB3
	1f4Q6Ifi8kjzFw/cK3a9MNNkOXSoaYdtIe7E9zPivaAndSCWZfdunOD1YrBdk6cq
	lBB+TNFr+XxS2ymhEviQRKSg5tgbIAzsl8TWPrND7YIbyo1Enwslfi8Z0/vdrmQp
	DVJ9y8fENohcEhbNWye5Og==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8myg3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 13:50:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PCuJck013408;
	Wed, 25 Jun 2025 13:50:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehvxkvaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 13:50:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t84OVkQRyNi/gVVw3afAwjAjEyAgf6NEAlSbRn5Z26dZ3tEzO0o6D2viKEgClg997oyvRPWQvIeLr872rW1HRhR+VOAb0kPJzyxQI12Ygdmkr/UC11SlYMbzvwUOpdVVCSYSpE61TvgH9a8J39fu6DbniDlrS0MGawiqn8DpFGbpWP9bvrmQyUVY4YN3u++6BMC/+M4WFxdiDPAO1TWvgrB6dLDLTxFwM083a10PerD21qf7REdLWRW5aSdhMR00QssJ/HR5tObY6OWyzVVr0XxfmY3/eirFuGqXp+5KYj9BEhwPFk9sscNEJqV2+K/cEIYMK35NnX6RPYUwmfRlAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9qmCaoN1DLz2PtkO/PbxrNL+hnO6eaWsvp6Fk0C7ak=;
 b=jq+WH99u7epk969A1p1q6ZyrPfHOBnruhp3Qo5xkq4XtnbRP8pTmDfcXQHYSjQkr6FIi981vdXmCXlbKmlEmjBv62xwZQaOmtKbZSyEsKL08cKPOUPqcFeV8Aez7L1CSblAZ9ds06e2LCV60YjWZhwCAE1A0JpzseTBmKqNEkfhWyftpSFvI1xJ3hntLpDJp+XLgGssHnu/AB2bfrh9kCOm8efWf71ynyPseCTzDnrN1C7rKaHLJV7SmDhI/lclRrvyvgoSR0qjSyX2+XxDlkpXOJY+9uOn0aAdgQCp/hsFxc3C6IF59bTO23KvczAg4uirKJltMieqE/Q8RMXkkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9qmCaoN1DLz2PtkO/PbxrNL+hnO6eaWsvp6Fk0C7ak=;
 b=v+x1x0D+L9vSsRsnA7j8pc6FROOzLVMkj2bExCV2OVfI7gFtpUqMJ1MJAGlESZnFoX1AJy20jKU1WyfKLNaxBhD0Yhgstubwk41gmd99Mfb2CK87o3zsPST2RZ9YfdJsLThDt/kab+zG/5KndPJUW8tppJPQ2prDbuTiLqcFlbA=
Received: from BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
 by PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 25 Jun
 2025 13:50:43 +0000
Received: from BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c]) by BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c%4]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 13:50:42 +0000
Message-ID: <18d75354-8c82-47a3-bdf9-0981306c041f@oracle.com>
Date: Wed, 25 Jun 2025 19:20:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/288] 6.6.95-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250624121409.093630364@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250624121409.093630364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0086.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ae::9) To BY5PR10MB3828.namprd10.prod.outlook.com
 (2603:10b6:a03:1f8::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b3a5360-44f4-46a2-b8b7-08ddb3ef46b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TU9BM1U1MFRyNW9Rb2VkRG5XT21KM0RmRy9qUkZ1SHZPeklRYktZNFFJc0Fp?=
 =?utf-8?B?Sml2c1pXSE00ZWdleS9MeVZPSDNGSkwvdll1UzEwYzMzQXd5Qzk2M202amVV?=
 =?utf-8?B?ck5EMzVXei9HclVsWUZ6emltYURNakVKU3ZwUFZIenBPTWx2WEYxSlFQa3c1?=
 =?utf-8?B?MnN2TnFtaVVKdGtBZUhsbUQvSVNJdEZ2ckFKQTZHc3htUisrRmdyRUpzY0Ey?=
 =?utf-8?B?TTlvaHk1VjY1RzlJWVlIVnRpWklmY3I0b1V2L0hac3ZqbG9vYWFMdlVGbklm?=
 =?utf-8?B?QlhudVY5M2pHSHgzdUhHYU42eTUrWjh6YUZ3MzdwK2hZOWtibHFxZHIwV2Fl?=
 =?utf-8?B?YnZsTzIxRllyV1FwVDVXSDcwMU1RYWc1SVptUC8rT2xMNUZiVVkwWlFlVmUw?=
 =?utf-8?B?amxaUVUrWTh5L0k5OEc1M1EydW5QdzhtWHFHNHVvam5HL2I0MEM5c3VtelQ0?=
 =?utf-8?B?SHM2WWlhd0hOek9EdXFYQm40NGo2VFo5cFNVa1VlK2pxbSszQlZKQ3MvVlNX?=
 =?utf-8?B?ZXFGcXlVTWg5VGl3S09yU0w0bUk5ZEQ3RytsZm1IOGRodDBFb1NUMFFkTWI0?=
 =?utf-8?B?cXZaR2crTmEyQjB0b0hZblFXaU5ibVJwZDA4U3hWRzhRMTl2UGdsL2x0N2E5?=
 =?utf-8?B?RUlrcnpRTWswSFQ2UktYeWpqL0Y4aDVQZ2NKRFpKSURwdCtyVFE2RWlRbSt6?=
 =?utf-8?B?OW5HT0JSam05U3h5SUF3L1h6Ty9OWWRQSEZ5SlE3eG9GRFBCK0w3NmRLWTBy?=
 =?utf-8?B?M0Vid2tVZXVDRjkxSzB2RWR5UFkxQkpPOHJVZWhJTWVBVmdKOHg0eXorU3F2?=
 =?utf-8?B?SStPWks4WDRON01VTEh2TTN1MzB1cDBZcHlnV2JtZ2NpTjFBSmtQVFhBYWVi?=
 =?utf-8?B?M1VpajZnSWVGSmpYZDFKWTkvZTQyczZFWDZkb1dab1VYRVNZQXNVRklwMlA0?=
 =?utf-8?B?U05iV2dsZGFySHFPa1E1UndZMTlLbmN2OFBtOFVGdzMyZnNUb2RZZGkxeHp0?=
 =?utf-8?B?a2NKZG15c0pwMHdWZXF4ZlNwSG1pTzdvTWNySmZRY2I4Z25mK3hBdDFka2dO?=
 =?utf-8?B?ZS9MbFJvZ3VCbm9OaEdoSDY1OE4wUjYwODZMOGdjWEF2Snl3N211MlUxZERQ?=
 =?utf-8?B?UU5nNGJsUjNsN01rZHVJOTgwTUprUHNVMy9IRWNGVEdEVTloUDJCRWNkTGhR?=
 =?utf-8?B?SUVOTFJDUS8vOERQWW9UWGVEU3daSEhkVktSZmhNWmJvUVQ0YjBPdUlnUEVJ?=
 =?utf-8?B?aXcwamlYNnZFSkhJSUZnZDhTdG0yVWJaWWdjQmNibHY5aVBEcElabGgzYksx?=
 =?utf-8?B?M0pmQUl6MnZSaGpqL2FEN2dNVlNhTEhjekYzc05UYmFrNVNtZzV4ancrUldH?=
 =?utf-8?B?S2lmZXhlK3BUeTQ5NmhRblhMQ2tReVdIMUVva094L3JWd1luVjlyUGlxT1l6?=
 =?utf-8?B?VTBnalBsMUgzSzFlRGtDWEhKazFRRnh1VCtJdTZqaysvd0lYNzFoSm45NzJI?=
 =?utf-8?B?YVpTOENaRXhhRzVJYlk5b092RmtTRHZZcDZkRnZkemZWL3pEVk5NMFp0L0dw?=
 =?utf-8?B?dFlWa0RiUlJtNlJ2Z2MwSVU1bEZnY3RCTWpGVGZqYzVZSVpZNXBheUwrcW9S?=
 =?utf-8?B?clZ4REVIb3h5YWxJa1lTcVlHWndJMEx1MzJmbWp2S0dJcGVvbW5ab09JQnRE?=
 =?utf-8?B?TjRWaGs2bks4SDdYOU1qSVN1OW55OHVaU0wrZHo5OFZ3c1lMZjllQ05lV2Jk?=
 =?utf-8?B?RnN3SWhYcmJCWFpINm5VNmpHbXJMaTlqakhVSW1WM1lwQXhyOHNseFpiTUpZ?=
 =?utf-8?B?RW1RUWQwWGkxU1hyV3VWOUxTc3d6N3oxeDdLeFJUQzdqSkdDOUJJVXI4WXNv?=
 =?utf-8?B?aXlBak0yWVpYc1VwZFVKRTljMkpTWUxhRmtKRTlZYU95cjB2am4yblVBeXB6?=
 =?utf-8?Q?LRrJdzpQL04=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3828.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MG50cjc1RzBvelF3eVFCMXJBa01nRjFOOGhCT2piL05CQUNEN1QrVk8wZGhF?=
 =?utf-8?B?NGJOaUJRRTExMkdSNjFNdHpERkM3NlBOb3dDb1lZOWdBMkhzblRhRzJoR3lr?=
 =?utf-8?B?Wm1jcFhzRGdZSXRGdklHWEREb3BZd25DT0V2cUs1a3RsRUQrWUNyQjRRZTdZ?=
 =?utf-8?B?Nm5vTXNTbEZhNDc1K0RWRUxzRkYzYzhhaW1SS0NJZzlTWFpjWVFHZjBKakJp?=
 =?utf-8?B?bUNaOEtYaXdkcTE2WVAvV01nZVFkSDlFWUdHaXd5Z29XVTZLV0JhNm5LVG1r?=
 =?utf-8?B?SzkyLzN2YU1KMVVQdjV3VldGUE90R1FTbk9sOWpNUnF1ZXlWc09lSEt2MmhU?=
 =?utf-8?B?eDFvL2k1bzFLTmFTelk3Nm9xeFBtRHVTWGdlRURxTVdmZjZjRithTUc5VCs2?=
 =?utf-8?B?emNaMWJOZ1pkQnRvMUt5YUN0bVpaVjY4ajJacG9ta01JOTArMG1mSXRJVW1J?=
 =?utf-8?B?QlZxYWpYM3VMcW9lWEEvQU1hNG04QnJHT3dhQmdHbWI1TkdwcG9uRjcxU3Y4?=
 =?utf-8?B?NFdjd0F5YmJFKzF6eVJONXlRdUZOQ3lzR0lrL1RVeElxS0VDWVo4MnEwV2FV?=
 =?utf-8?B?aVVvQmhKbGNhdDVtY1lBSTNKVWhCWWdaTHBtRlBjMUl0Q1BLUUNyakpzN2Qv?=
 =?utf-8?B?K0ZmK0dXY3FqMHFuY2xXVXpXY21sZllUTHZZdW00QXFQTFd5VFRFR0pHT3Bu?=
 =?utf-8?B?N01jY01QeXdBV1pTVTJ6SzdKZkNUZWo4ZHlKUkRpZFVLRjFmbmZxMDFZNDFU?=
 =?utf-8?B?UEpJdE01YXFxeTdvSjZ3YlBIZmY0bzYxVzlSNU5WK0Fsb1VxeUZOQnc5UEpX?=
 =?utf-8?B?a0pneGt4Q3hFRkNnMHU1Snh4MFhMckxiMEtqeHlvUVZYMFFMZGdmVWgrVXQ4?=
 =?utf-8?B?T3NuR3p4OHNZT0VabHhqLzhnbEFMNkw1NG1zNUZqVWljSVZIZldDRlF4YXVL?=
 =?utf-8?B?TUl3cGUwVnFQN1dXZGJRLzY0MWhTVnEzU1U2aEQyWGN0azE0R2RRRWxWQ0ZD?=
 =?utf-8?B?STJGUlordnF6M0FDNjIwdm1YVmtUMWk5SVpCb2hJSXVKNG1zYnZHYnlucGNB?=
 =?utf-8?B?K2dmVW1VeFY0U25mWXlUWHMxL2V6cVVoc2sra0VDVUxXaTVhMEdCcUZKWENk?=
 =?utf-8?B?SDJZMU83QjdqM2w4N1JCU2M5KzQwTlBaWUhPdktDRTRITUtMMVZBbXNaUWUr?=
 =?utf-8?B?OWJvVm9zT25ET0Y2UXhyNmFhU1VyOUpNTjc0bWVCOFBXRkh0V3JNUkNWVjVs?=
 =?utf-8?B?aFFRd1puSXFVU2dpL1A5SmlTcDBscTFMT0Z1M2d5MWNJZVJjWHZoSDZTNWxR?=
 =?utf-8?B?bGVpemVJMjErMUJLaHVGUHVnbkllOUVoUXBEbGovTTF1ZVpNbWtuODI5SnRV?=
 =?utf-8?B?WEVuRHhpQ2pqUVVLbFgrTFVTeWhSaEY4TEQ5dnk5QVpxUlRucHpreG56RVdo?=
 =?utf-8?B?YVIyQ2tSRTV4REFWaEV6SzFXc1k3WG1qWnJXUUJwZnlpN0NoMG52dGNCZ2NO?=
 =?utf-8?B?amtXM05ZRm1WVTNGZWxKRFZnRDM5b3AxTkw1YU5TZGtpSFpzK3lKVWo3RVRv?=
 =?utf-8?B?TDJNUmQ2b2tYendVQmNLdHdIeUxnM29PZlgwVDg3THNPdm9Ed2I2dVdxMkF0?=
 =?utf-8?B?K3VQbEREQUF2UXNiTmRhSlBybGsvdEJ4R29aM3hXekpteGlpcVZLcmoxZVlk?=
 =?utf-8?B?TDUweU5uOEU4VTdDYmpSdVV1d2daV0xoc3FSUGQwL2ozbzMzYmlheDBvMzk5?=
 =?utf-8?B?dTBWTFZZbVJwQTIvQWR6QmNjWUFWNlZIZ1hQY1lySkdJSE10T3BiM1JlOUhu?=
 =?utf-8?B?cTBhOGZNOTU4MkZZT0ovNU5Gam9pK3d2SDNPQWlIUm8wSzVWZGNXRjZBc21p?=
 =?utf-8?B?Q2NnSE94ODBOZ3NiaGQ1a0NJTFdISTB6NG1GT3hZdHc2UHcyTU9BT3FleTBV?=
 =?utf-8?B?OGZZalNCZUM2bWE5WEtZaTJUbW4vQklqWkYzLzZkODZvK3VTUnFYUi90eVFk?=
 =?utf-8?B?eGJQdWtZMjVkTVpRS1FlQm93WmNESHJqN0kvNTdRVHg5V01xYTlHWkRWNFAv?=
 =?utf-8?B?QTJzQ2lDL0hPYmFKMUhqaUNrQWlBRHBySVhuK21VY0dGRjJRRytqRldhZGk5?=
 =?utf-8?B?NG5uUDlZMnRIWmZDN2pmNkMyeDUyRUt6bk5rYnE2cy84M3hEUUZld0hIL2Za?=
 =?utf-8?Q?5sN6rZvIuPp7LBDdtO6ZA4M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mNnnHpBr4DzUnAUOc15M+z3/ZPasBLJXd7vjyGfN6vMgmGMOH1QWggwkchO+9a4/21YZKAl8mIjVK8GTI+Aarc1/Jie0uEXSiYw2TARxTYETWoI1NFvzUoPCWGuxFCyrt5nJJuYrDcsSix9/QK5F+EaTRtFp5WLiBMsV3QGCj0PkLpT/BFsOUFbAk+XsPuTB2BYpl0GTjYf9Q/KC8+6q0lz5JLq/xvd6dNIb/k6N61cWzQIZ093MPRQBxrSYMTHRJmOze8aRU1VYexv123l5UyQYyg5ULlL6XzbsqIpH2JXMFBd8B7c9Q904YlTVWvvbEQDzOZ2l6UFPiediW/QA3rY8V+UIYE4gnPx5ti/Ia7hLpOSl8jPrzGm/1hGyyywcgRtvT8hQOcN3Iib6J6G+Z6lBisLsmXhIbuaCMmUbltIoLMWF+nL1AnJoJ+zlTXq+IdUfYWpUdE9bcUcK6dZOzTMuWFcEmByq2lDbaAT7EC77fsH+x2Ix6XS2pILCq2Fdjnq7kFbpsVXAui0p6ULDDiedMHCYq1rKqdIfPxZOkTWIPEmT+wDEyNpSLbp+pBobeIB5yfCGGzUnD8ykUQSs0X+5fW5I4G3SBrdk+/2wJO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3a5360-44f4-46a2-b8b7-08ddb3ef46b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3828.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 13:50:42.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vrr9P5zYYobktP/7Ts8LYMipTBPzukNSAu7Khgh+CnK/ffJLqlIyckQRbMOWiQRnxTJhS/jW4jnhCu5bfVEuVx6GpHzLD1b2ZTkP01s+cm9aCRIA65cjxdqMdYrnj8B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_03,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506250100
X-Authority-Analysis: v=2.4 cv=IcWHWXqa c=1 sm=1 tr=0 ts=685bfeb7 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=wTk4tKas6ecv21DVzCYA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14723
X-Proofpoint-ORIG-GUID: TgE8kKeu6Dsiaz2ddez47RXVVlbeI3gi
X-Proofpoint-GUID: TgE8kKeu6Dsiaz2ddez47RXVVlbeI3gi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDEwMCBTYWx0ZWRfX1AeoBE9DnDqE +IlSbJM8RqIsNiEJrYDWjnwB73aBjjwbKKLQb+Ti/xRfwKBV/q686ec79v0Wjon4TFhO0+4fqxV icdglN8eetJhJ9z3IqArCF+v7amxvBeIiKH/wlfgvSK8jmVgQIHXxFC2TZsFgOAu6IniNh3zkiU
 misrqcSZRi7FXpx1CiaakNixbmx876Jid36lu4iqEOwV5VNCgcasDol9gTyxXJCg7cqrPIv2asC 83QI9FqRfeEHBEB2Vaiiir6uzCl6hKMhZEstDITqNtn9efr3T07eZe1onSQ0lh/5uMuUiKL22HW xMWDEDTG7wOxbUqHyuLlSkguNT0zEjN7nHpppCxrDxOh9z8OgteZ1W5xRu2ENViqUj5xHuOhuMY
 bplXHJ0zqJ6Uqjq47REkDW9w6Xq2ZyF+9hzrglpRzs9w699wY5jX77UbmQEaCxpgxpzcU292

Hi Greg,

On 24/06/25 17:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 288 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.
(Problem reported on rc1 is now fixed)

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
