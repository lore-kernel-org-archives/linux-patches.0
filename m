Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2047930F816
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756386942; cv=fail; b=YczACuyhk0OCzGf3+Wf9mtjneHj2u8/a7UfzCn95x6fxWuUw5emzqpmixRKmP8Vi7lbv8e1EjTGgIUGjajym+NWxref/GUVkdH/fI6675dI7Cm91PV9pxytCVnH51zzvGmZ89gClQ09+lv2LsbE+7lHNP+k9Y7p/fNOabuj5F/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756386942; c=relaxed/simple;
	bh=1ABnLyQV2lTZ7ICCmXBkpN4R7s5T9hLYzjp2ns1RUaw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WFlr/5CIpTdUa099FSjzgnZHAwLjozic+1fshC/z7zRLxfrAHqUp2RdPAt2UV0wfHiDSEjrizRBbOIOLdRD48Cu5lw5Gs0TxGbX9jSE25YJ1FKZutmmn7CrArKiaDqLmlZVgpDhi5uZapzKXlq0n94ANBaZYM7rcjcNnEct6WO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CD7PSlQO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tnJTR0KL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CD7PSlQO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tnJTR0KL"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCiq0Q008992;
	Thu, 28 Aug 2025 13:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ngUPUBYe5QPlI/9T5oMCVgus/q/jlv+h9DcOePmmlWg=; b=
	CD7PSlQOXT19rsXfLjRrPxhCTTeg5NsJv4a3VrWI2BJomzgqMZW03pfk5DqdTa79
	n3I8IS9kL234rORhiKwOGwR0i19qTgHk1Jn+uyzWGgOzE3WD5Oo0j6NNGZetwIgY
	uyCLXNSqgQ1Y0E+vp1lmN8DCYKI/vu0/W3rGFU3080E67FK9TVcWV9ymW3xacqZZ
	49epig/j18LvpH49V+Vk0pJDPPezaQRy5MGMfx6CvuqAbWGDMUU6Hr8NeEZP4CvY
	TrBU8IHNWLdU/AK+RhR/SAjvqxJvkX7ioXta82ezdKneaA/0KW445fBbwTsn/7Zi
	cDW8XU8eS3ZawKxdh58I8g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twf74r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 13:15:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SD0RMS012231;
	Thu, 28 Aug 2025 13:15:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bus1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 13:15:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BlEbh0mrz6W+jDA3ONfJwdQeI+WKG22hvmlxT1B7w0HVze62l+g6kEV/tADdlkh6+WPhkMJL80+DcjkzZvhxeadAZFl+tCQRjvbhLDx0bD9jUpws4Tlf7lg5OB9lrk01FB/fd079PaSCGLM2x5Uc8i1IlrB4cK/fx5aQItR64+aXhud5f2UnBojzXOTq2v9MsKxE8SxIdqQ6IiCCFK9CIhprxVIKENc2r7Gev+znQDUdlCx5xZ09TX/C2AJKx2SNeXn554Zs3tX0GX7faOz4UpQxXNCRExK9Io3nh/ImnonIV/dkx3KIIoAsdzI+WhQwPIzZzrB0+Eej/CUSVTBzYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngUPUBYe5QPlI/9T5oMCVgus/q/jlv+h9DcOePmmlWg=;
 b=k/sHF67ZsaYZ44Oe+pXLcuANua3/UR00QvmtP3P1FV7s2fkgHo75ZuNt4Vs89AkU5FrVfOBdjb4FB9DCLAsqKn8pZE57prgN3AqkbdBgI6e2iF9+i7tu9oUXh3I9NSy79Oo4jHzxlaDV59sc3QrcbzB9xeUDVIk6/eJOQ3jaTtzYt5cOc+UGTEBZEW9SFHkXpePz6afIXp0UuwjRcvCwsumyEMEaDy1CzhoeLeuIgvoH9Akgnkbnpgtg0iri1OoN2CHG0OUFLoYOtwCrp3cQjrYJh3oDKnkjVedJSUQkPvCfrOFIXuencbjd0YkwBWYOJwk9uJrcUxxCRrkqtN95QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngUPUBYe5QPlI/9T5oMCVgus/q/jlv+h9DcOePmmlWg=;
 b=tnJTR0KLVjvTXYECQ76dsA/mR+AdsFG6sc4+d8z5OwNzWli1sieosi+P+mHjA7FGiZQN5BrdrdZNcqEZFTu2NK7bHfxzXuhPDa+hmcuJt9oIfb7pmDmGLZtxyRG0Cyf+Cx+lcORqYjWzdKh0U4LxJHXvfq8C7f/MaEgNtmuN9ZE=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by IA1PR10MB7487.namprd10.prod.outlook.com (2603:10b6:208:450::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 13:15:05 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%5]) with mapi id 15.20.9073.017; Thu, 28 Aug 2025
 13:15:04 +0000
Message-ID: <8fbc45bb-b105-4a7a-b7cc-79ad8a6ae1c0@oracle.com>
Date: Thu, 28 Aug 2025 18:44:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/403] 5.4.297-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250827073826.377382421@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250827073826.377382421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0545.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::13) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|IA1PR10MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1b77a5-441d-4d62-6022-08dde634e6f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a21ESHJLdlpnTFdwWVltUytoNmxhL0pZRVFVOGd0Q1FZVjRUbDk0bWR2eERM?=
 =?utf-8?B?Qk1SMXBQLzVqVHdSWmxxUlgzSm5tejhBcTFVOVNXRE00OWh1MEErMjNpc0VH?=
 =?utf-8?B?WlZFeVZxWjdJMnVMNG1lb3FFa2hIakhKRU1SQ3NrMUU2djFKeWd1YStjMC9R?=
 =?utf-8?B?WWpDTjNPSWFJYnNKNzNuVGI5b004ajRjdTAycndRTTBUTUpBYWxPSFhVOVox?=
 =?utf-8?B?NnJ3WlJVSndZRE9VUDEvaklxa1R3VjYzeHlrUEtkWHFVS1FlRUZUVkNFa2Zi?=
 =?utf-8?B?YTFXYmg0Y1ZNQkE0RmlyRCszVXBXN3ZyUHhSYWxPQjNqdk5rbTV2OER6Q1NV?=
 =?utf-8?B?L245aEFQcFozcFREOVRtM21BcXVTVjFHVlZmNDZPNWFHRzdiTGpBN0Q1MXZy?=
 =?utf-8?B?cTZJc1BxNlRabXpwSTg1TnN2VG5HeUt3QUtJa2JubCs2WnFZb0U2SXVwR0pS?=
 =?utf-8?B?Z2RLZ2lKSk55NU1PZUZRWlBVTkttNnhyN2Y4OFZqbllWTXQzVU10dSs0OVNC?=
 =?utf-8?B?NkVzUC9hMHRPRFhHYkNVNjM4RjB3a1BlYVMxd3kxZVU1TFIrRzJ6azVlcGl6?=
 =?utf-8?B?UHlDRlh4ekl3dGlDbkF3ck1MTlVraWpzSVVGcXk3cFVPcWlDSHpEYTRhNnpC?=
 =?utf-8?B?emJSTW83Um5jT0haWEVsMFpadHcvek5tT0p5QzN1SzRuTDdGODJXMU93dG9W?=
 =?utf-8?B?RTNvR0lPREc0T3AzZ252elh1Z1l3eWNFOGhqZ1ZVRGxYdGc0L0kvUjlvWk9m?=
 =?utf-8?B?dy92NnpnSHNzT2c4dURYc3NRbzVvTEpjaEJvblhML0d1bXVpOWwyeitEelBI?=
 =?utf-8?B?WGhYTWZQVG52SXdNT0tCb3NGM3pIa0txR3drdm14ZlAzSTRqNkpSUHNnMS9v?=
 =?utf-8?B?Y0g1dEV0WDVBaWdudTIwRFo0VFYvUjE1MGs4UlNhSmRDUDB3UzVOckxNK3Rh?=
 =?utf-8?B?RzZBQ2RsSktvYmswYzI2REdEcDF2T3lZVUhqNE4xNnFxbjBPakRmMVZJVnRw?=
 =?utf-8?B?S3lwanZXVENaY05jQ21sNkVvODFPRTdhc2M4M1J2OS9McFRUT1c4MEVMMDZ3?=
 =?utf-8?B?UDZCV0tZUVd4MExvK2hHRmJPNXJlRzhtTXZ2MmVzQ3dObVZWOHV5ekVYblpa?=
 =?utf-8?B?MkEvbGtWQmE4cis4bHlZR0dkb05RQWgvb1Z3dW5Td1dNSWlTemFVenpLTHp0?=
 =?utf-8?B?MVZ4MkRSbGFqaWd4ZWhhUjg1dG5oV3RKRVRBYzU3UEE5VDVZbnhQYWdUVFRy?=
 =?utf-8?B?cG1jMXY0cHppTmdDa1pxOFdHcUsvODVHekdFQXVJYVRDNzF6em9oK3ZIMk8w?=
 =?utf-8?B?S0JHUkJqMUliNTRWTjN0SU1mYTV0MDJmWTBVWXR6bXo1MUpCcnZ6dlhlbUdk?=
 =?utf-8?B?aXRBczhEK1JaR3F0M05YelhpYUpJQUdGUHhncm5uMFV5UDdZTWFrb21yK3Fm?=
 =?utf-8?B?WE9VWEtVeHNFZ1EzM1JIL2p5QjlydzhQaUFNcVhHbGprSnlYcnptSkxFbkpZ?=
 =?utf-8?B?dElnZUkrNmdEaXJPMnBFWnhLN1ZTN3ZLRjhyZmpOYUpsaXU0QmlNR21JbmtL?=
 =?utf-8?B?bGpNVjlqUTRDQkVSNlQ4bCtqYytJaHpLY1plQjdwOExoRi9GLzJzQ3AzeUlw?=
 =?utf-8?B?a1BrVm5MWjUvSmVocngzTmViNGk5dDBCQ1Q2YkEwNk1IU3ZxOWsxQkFrTjVr?=
 =?utf-8?B?Zm5DNytFNTFUQ3YwV2Z4dXZTbmxDUEM2TXlld2VUSXVrT29hcDFhUWdTeFlD?=
 =?utf-8?B?QzhFUjFSckFFbGsvZ0ZHZ3hRZytnVThTTGZKbzdYMGw1K3ZJM0RId1VZbGg4?=
 =?utf-8?Q?S5LUQ3MhJOACOHu43EpqO09xTwSu6yL1oYxbE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGpTOVhLSUxsUDFlNEczTkhQcTVIWmwyNU5qZjJMN3ZYOGNtSEF2TGtLTGZG?=
 =?utf-8?B?SFBBbm5wdkw2aWdsRDhWZ0crWWRPRy8rMnFMZFdOemJEWEJjc0pSMkl2VmQv?=
 =?utf-8?B?dFk0VXVoMEdCOElPZ1Q2Y09VMWptelN6YXlCci9xZjRTckRaRXpQYldXYThN?=
 =?utf-8?B?a1gyb1RoOS9ualVEekY2d1NrZmh4dTMrOEdGZFJxNDB6eXltaWh6U1RxQk5u?=
 =?utf-8?B?b2VEVHhZNnhjank4SHVnMWRZM24xTlFsc29OKy93NUdwRmp3ZENTK210TUxx?=
 =?utf-8?B?NjJwV2hYeXFoWDhweGFtd1RwM295UDIyTUFjRWNzS2tVWEk4VE1FbjhKLzE4?=
 =?utf-8?B?TThhRVJGMGVxZDlOVm4xSXpwSmhhQnMzbVhSbk5hRWtjcDJSS3ZyeXgyTXRY?=
 =?utf-8?B?dCtScFRZSldWd1o0dDZBdnQycnNWYVFaK0I3N1JtUm80S0pucmFKeWtLV2Jn?=
 =?utf-8?B?Zmc3c0IrYmtZbXZuS2ZhK0o0a3lwQUR4VGl0aFRWYWc0aUs0R1MrQTR4aDVp?=
 =?utf-8?B?RG9SRmFUb0Z5anFRb1pyNEpZYW1hUm5kZ3hEVTRqK3doUE1iUlU4alJQdEI2?=
 =?utf-8?B?QkY0RzRTVDVyY0UvODNZNTJRSzlYTVg0R3IxUkJkNlFXNVhvcmVRUU1XLzlK?=
 =?utf-8?B?MHlnRzVBZE52WDBEd1dTWmpkNEdjY0JJcXh4MEwvdjg1UWhwa0MwekRPNm5p?=
 =?utf-8?B?YjNrSzdCY2F1REp6Qmc4ZmpvZW1jbXJvQ0JPK2g2WElEY0o4QVhRNTF5ZDlr?=
 =?utf-8?B?R0ZFY3dyTk1nRGNhb1dmOTBkQnFINyt5VHRjVFFZcWQraHJEZWNULzZFRWo1?=
 =?utf-8?B?VDFkcE84Q25ocEh6dzdQU0RUSGJSUkZaR20yaU5wdjkyd3NITEdoT0Y5dENF?=
 =?utf-8?B?dTlDVDJ1bWM5VitiQ0d6TWxjcElsQ2MzNDNkTlJCSTA1cDZvT3V2VHVEUFZq?=
 =?utf-8?B?cUMrS2lxbERicy9oM1dqcE5ZaXRrTUFLTzU1MVhjTTBtdTNyWXVDQUMwL3FC?=
 =?utf-8?B?TUI1OThNZUY0S0Z2L1N1YlZXejFoaXloZ3NlZDZUYXFHb1NXY2hjK1YzYWp4?=
 =?utf-8?B?dTFsZ0lZSmNSYnQ1WUlsTVlxbzB5Z0xiRzlmT1B4UkRhVGQyTDY1ZmVFZEg0?=
 =?utf-8?B?ekhlNFJKS1NVUFY2NTJsWUtZSWpDS2tHU1NOSVUwTXlrdVJZSFA4SEJTOTFi?=
 =?utf-8?B?TE11MGlxUXNlOFVyN0lKMzlLc3F0TzYrVUVLZU5pWUZyMEoza1hZT0lwWC8y?=
 =?utf-8?B?OTgvZHdZekdQRDVCVWFJZ0YwR1NmQzNNNEgzckZhS3BZcEF6aUloWXZLaG1X?=
 =?utf-8?B?aUs4bE9YUkRkRlB5RmlkK094eVNnMkdlMXY1NDN5Z25XVHdEei9CbU9RejZn?=
 =?utf-8?B?RTZjZ1Nyd3hkTEFEc2tUSUZ2cXpkWm8xZXdCZWUveXUvYmFZUHk3NjQ3MVBk?=
 =?utf-8?B?T0szd0hNN2FZd3IyZEJCR2wwVlNSWVlLTElnU2JiS29ROTZ5ZXo3VFRBRVpr?=
 =?utf-8?B?SE1FK2Rzc2RxdldsS1puK2RTQStuNE5HLzlHS3FTWXphU0d1bUhSMTE0UXNp?=
 =?utf-8?B?T3gxNTdxYm5qSmJVVnVwenNadUtWallnWkVaVFZVRTFoeTlUdVpYUmdCNmsx?=
 =?utf-8?B?dkdGakZURVBtQWRPNlUvcElDVWx1amF2Mm1OdXo0b0IrdmFEREVQaSs4TlRR?=
 =?utf-8?B?V205Vm1udTU2MFB1WWpXN1BSbDhLTE1qcXBIQjh0d1N6VjAvSS82U2pySlhq?=
 =?utf-8?B?d2I0Qzd2NXM4MUU2Z1A2S2xkbXY4VjZhdVc2dWR1amJVdnNJeUR1VTFUeGRF?=
 =?utf-8?B?UUoycEVZaDVCQmtENk9QVllObHc2bDZ5RGI1MDN5Ymt3dW9kY216TlZ0VXRo?=
 =?utf-8?B?MGhrRGFQMXoyTjBxRXNMR01IQmxnUFpBakRCenMwM0RWRGFSaWU3SHRPV2N6?=
 =?utf-8?B?WWRWWkh0d0JMNUNYaC95SE81Y1Q5UWJEM3I1M3BtcHJFc2pmR0V0NE5TeHds?=
 =?utf-8?B?d0VSYWxqdDN4ejh0aUcwZlhXLzd6ZTJMeGZ5S1MrckNUM2VuRWtVUjN6NEcx?=
 =?utf-8?B?bHVJZyt6LzBEKzdQaFZ5alBCSVZqalFDbHlGYi82cHpIWHJGQUh1WkhpeC9z?=
 =?utf-8?B?QnRId3pSVjNYcFdkSEoyS0F2Mm5MOXNEdzNKYzF1ZFVnTmpXQk1wd0xkQ2VO?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CdJYu6MJagvjEEtDcMkPw5BMYkzYC5PMBVyVcXwJFLGfMguOIoOqYoTK66P720fqQvjlYduLGmvTIqWCr4shHx7tibhsdzwWGj+Jj3lFnrhWfcqbP57071OMfpkzCb5kBrx7IfM+cRzILbdaswk6u8QZqKs9hCDFXjjgPuM6ZuFT0gNjqRq7uOfXkxnvOzqR612ECG3UCv4QzM9UA2R46y7RQugYfDVZVTwQvseifFX6vIyVnXOSnRHh+xbXrldaEbH8by/xcPhvChyRN0ZrNZQdJ/bUyhk7fg1DySB914h/Fy9jBAiwQesWcIepvcseT3wevVf6HQKsgxDMyadOu3vM7NOCr1rEuv1TThcHNxzmMhK7Ma9HsAMzztFk5V4f2dWG2xX6goowtcXaofcpiJLB0l9YL+tpcxW3rnneajIzFXcmroUijBs3e+f5esoxxNiYxLHYCpzZD9Sw6FZmIh1WT5fCmYVArfJxbxQ7fjh0mVMUUeAesWqauPam3v9XZwxx/Wo3x8hIliiS7EIPjBcvzgOH2FZzoLkJx6653HDz2YcDRChV/jF1Xymy2D/1aRSqDlgopM2zYxc5GVcdWJ0phqE1xDx75xmOHWrm/jE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1b77a5-441d-4d62-6022-08dde634e6f3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 13:15:04.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlgIWKplp91lnXrpVrXUWzKXNlUNN8fuUeClIYB6i2AKs2DuRUeJ0+h6TG+gqFZtPJfaSnTx6c02NrkBKWfm8Dufm9VTZfffzby397flX/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280111
X-Proofpoint-ORIG-GUID: WndHlHMwVYVtUiJu1h05ZJHDePqMppf3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfXxcwXlCgNatcl
 /+DrXJpTRrs/tkTxFQQQNkUqSCINI3clZHZjMxsKhIY1R8LA4oWzS2h57sUAfh0F09WIDJwii3K
 gjefiQmOjtvHPZjg20S6b01QQdlqqK+NuWFTNNUVz9TEiFmtXPPXl3tKszk7JT9IffCtdPER5so
 hSv7C8UDkHRGlTRX05S57i41dY35i/Lw+aWI6+qSoveEZjwDkZbt0t4fwQSAcCSkueVirUN5qAi
 8LyNmbP8GiZugTSoAtBAID4m8r2gDKLqBoOenc1gDuTZdFONVgqF2DBGpu809kNS26uZzjJKu67
 D1BAdtdJFxII2C6OTZSBzZfaeOzpDutTtL8qX5ZRBK14eVD8V7AQr6gCTELVDQwfGNuRNhzHKNg
 +51cdl3ZWZA2KIOIpdNV79wsOPcPCg==
X-Proofpoint-GUID: WndHlHMwVYVtUiJu1h05ZJHDePqMppf3
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b05662 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=JCbkYDn2s9hrs8J9IaYA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12069

Hi Greg,

On 8/27/2025 1:14 PM, Greg Kroah-Hartman wrote:
> his is the start of the stable review cycle for the 5.4.297 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Aug 2025 07:37:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.297-rc2.gz__;!!ACWV5N9M2RV99hQ!Kr- 
> qfdJyoDZOM4khT_P51G_GljjSL-xVKWhEWNObb1BrT5Z_RbP- 
> mYQ0bblCCdkBAbgZQV95KjEgPAXHKu_DVkpJAg$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems were observed on x86_64 and aarch64 during our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
