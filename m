Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6054E46A5E0;
	Wed, 16 Sep 2026 08:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545693; cv=fail; b=km8K3e3dVQXyuN/KnwL/6Qzf5lEZu7qxC5+FnXOTahAHqgZvJDzG4zFci90HshqBlpZtSyJR3nWADKc47p5yTwXEAYNgaa7HbYxRpVHoUZ4XLoeCFAFfceVoSA9M8aqhe94XBow/qbmNQEhoIf6pMySaQ8OMlgg1OZUxITGNhc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545693; c=relaxed/simple;
	bh=toK2NJ+wWZCg6l4ntDfGKcGbEiFOZBqsS2SKPJXkJPM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NBlcLmz5AfddMJjqbt9yT0HemGmRTPEz879vFlmo76xFO/vDOMPSrT9Ob28JVHPMa/Fd1O8p+CwYGgWipAkZhgCR76C15A+vSh7h2DnhNEtUSOeBE1zcSQTQtnTreP9D1tCJ5IvAINifJXarF4m/1p5st287sSLcXDRpTyBN6xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pbZDOiDv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=izD2Ihlq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pbZDOiDv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="izD2Ihlq"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWT96641177;
	Wed, 16 Sep 2026 08:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/sI5c+VIHZET6kmemJQj7LQIVHFbidPTk2PDJz74A24=; b=
	pbZDOiDvFrz172P9jhdYBzBDuAwtjAE58jx5AgQvJJ+LimMv3vYwUzMJYrSR3ZrS
	FhnFCY08wJWFVAJ1uVMMgAeKOgT+b1ta7rK9/0q4s4+BtQJLqjM4pTIuUQni1bbA
	ZGZ9e6MZNkMepCZGl2tj1mPnY4UbY4i5NV/2rocrMyQOlwmGGpgMMOyjpX+xRBNc
	dmZ6xXBBdBnHJx+xHXVVScMpTAqqDXktYcd9xFCoydBEJzhzwAbfhJUH+u68XgaJ
	Ip0n2At1Yz4UaeO2OyzeR1aiwpeS9W4P/G2pOzCVm716olfeEMkHwkf9luWj2UYI
	PUM+mTiVWqTHeT9t9iE2mw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs5524-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:01:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G802YM032609;
	Wed, 16 Sep 2026 08:01:10 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6aupdk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:01:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSdNz8JgLN3wnzypu1mzEG0ZraAUgK5SJjbon+vH2EfZfVBKMMEk0uVk3g2RAXlTVAH4aePWc1dfrkUpzeyXLgu/AilDXIKGQn6z2WBaMh9ATLKj306g1Sk/Ah3qWQjIFYW/dQ1yzmMSv6XlHmznYlO3csPPvgf2aMcWNatLuf3Moh+DyQZrxAgT1Uf8fXE+YUGQo+Z6zHbJVQrPNjkzMOvuL90sfIrbeO38qaT5mY7nQTDMzjoeq8yLUChQxG5zPbyaxAU4v/mLHeDv6Gl3Tip6LwdRz+Qw/rejUtvvxhRts+CwkudmXKO2v6B+ckoEeSiRW92X02Zr2sdrSRYncQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sI5c+VIHZET6kmemJQj7LQIVHFbidPTk2PDJz74A24=;
 b=M8N97M4mKBdZZff4W6wvWa6dMb0D06mCz3hbA4hqAfPSkBihr+BJEf/GcGZBK+hXZUXpu5sZD+y7bXlFlsmsRS/FO34ko/xLMBfAsL2ABClE+VQf63r/LUw/erm/OoGDQktcLlzVoiNh29RCi/Xsv4pw5se4uveWh/tGa2cjxr4XE+al8RQB3RhS1iUOHqaBbCQptMjGQ+rdvspOoUx0hzYLkM7g00bZAI5UaZWGR5fABzy/sScXfiqiUF5Voyhdmofi+kpH59IUqIqZ4WVwLN+1OMXy1/u4wdGaNlZy818ycr5APg8LkyC96Y7wJwGQbJ3USWwgK3Vdcrcqe3dmvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sI5c+VIHZET6kmemJQj7LQIVHFbidPTk2PDJz74A24=;
 b=izD2IhlqrBQai6HRkyBa3pRbsziM9Fl5qLZp4ZN4nMlv/+oTz9m1sEvohUXVoZotdXZLVxmQkoKoDs/7CxWUs0T8mq6NuvbprGvQbOq8dilC8kz4jKdYMPS//71LlKebCCRPY3h54bnHRpjCRfgPeyhVkptQVgamLpEz2t2BBEc=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS0PR10MB8101.namprd10.prod.outlook.com (2603:10b6:8:203::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 08:01:05 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:01:03 +0000
Message-ID: <812a006e-a7ad-4a66-ab8b-45865cbe47f4@oracle.com>
Date: Wed, 16 Sep 2026 13:30:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0889/1376] riscv: dts: sophgo: cv180x: Allow the DMA
 multiplexer to set channel number for DMA controller
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Anton D. Stavinskii" <stavinsky@gmail.com>,
        Inochi Amaoto <inochiama@gmail.com>, Chen Wang <chen.wang@linux.dev>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065627.376202771@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065627.376202771@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::23) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS0PR10MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 17908887-2420-4cc8-8e84-08df13c8a774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hL8QgDvzmAS7hgVPTAOadeaLhZAUj2fF5cpKrP350pdPpgWuLrhzrvHQfH3bdGrO8L0OpaGaG4G13v6IxFlB/nQ1A+Q3axk4r3Oa2al5Xu1UpdXHwo+naRCxg56UYJH3L2bryYIiiiCkQNXaSOe4A/2fL9VxnaxQVssiMFDOYpvsbdj0cbaGmyTsmJJHYI+v/14XUrAgBKgYsDbNwh8A/oLwHbG3lT1DLtG62T9n1Ci6FfOvzWCBo0+djHsqEF+qrS6v2VZLJU/q53byP//i+vXFTeHdv7+sCioj6wZ5wb0hqP7LQsWvwmaXUFUxgNVDgWYHEnTtxiYAwygACbliy6z2tBeP5xHWfrZ/B+/my771XOi7Rj4bRNFRiOAW1d4yyygTxsyei4VE6Hn5bh5DWyRc6lsiglEj9dDXh9NZveGb/jmT01Tg6MWmeO2+pZr4LpHL4KTyJOxS61tee+hVXbBdqjVj9OWFk5gBNbdviX2VCHPMBkpBE2HPlS5Gj5vwp600mHfHZJjMM8SEqJTo9tOW1V/FGpruofDE1SPEHeHlA5P3hWcaBEbTWN1iAekjx3CTnt6kpvp65O5nDlWN7LhfBik0sriFIls0WvTeqEQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnE4TzhKZWJHTWFXMitWUFZPaE1lNlhIb1ovcWFLRCtGdEFiZEEwd1NtUWJp?=
 =?utf-8?B?cFlhVVQxSW0xYUUvbVF2RUN5VEdQNEFUcUJEL01paVVnTmtmd3drbW1SYVM2?=
 =?utf-8?B?Si9xc0tiT20xQ2tEMGRHNzZCUC9PSzM2WmRCR0YzWVNaSVl4dDR1dFJYYVB4?=
 =?utf-8?B?ckd6RHg1Y0E1VHNVa2RXRlJyWmpTOFJQVmxZeUovbFJmZ1ZtanQxRWNPbkI5?=
 =?utf-8?B?MzhiN0Q4dEczZ0pMbHN3S1I3ZkVENlpXV1ZtZTlvUHk2a2VCVmR6TDdkWTdO?=
 =?utf-8?B?N2I3YVVCa1Q5RjBoaTdNV09Rbm8vek40QkdPdEJ3ZnV2Z2I5cjJyR1ZEVGc4?=
 =?utf-8?B?blJ5TlREVzV0d2dqcHVZL2l0WkhUOEFHeFhkNThiWVQ1WEcyR21VakhCeVpn?=
 =?utf-8?B?aDQ5YUdPOUNKamNoV2c4OG9pRkRCaXdFMm9VKy9UMlkrZ2V5NytqaGJ5dWx5?=
 =?utf-8?B?MWZxY1kxYkxSbk8wWEFhVDQwTndkZDQ2QlZheHZ3UlJVak9yc0RYNXZERlM0?=
 =?utf-8?B?Vmc2L2twcVJ4UGdhRkdQcVlwWTZVcWZROXFxNU90SzhrMWpBS21pTXE0U2Fz?=
 =?utf-8?B?NU1JUlNMSzJOVTdwQnhiQVQzbFNBb09aZzYzRFJtNjNjdDZnOENmdXAzMnpq?=
 =?utf-8?B?SzRxY09QS3VrdWRGcmtsKzNsSlpqRlY0Z2Nja3ltQ3l2TzdseGlLTVQxR0d3?=
 =?utf-8?B?eENpQW9YSUd0T2hEaDlmRDd1c0JnTzN1Y3dhNGhEZ1JUODQ5WXlza1FNOWth?=
 =?utf-8?B?MUt4VHlGZUYraUpNcnQ0clNjL3ZLbUNUK0RVMlZmMHVhbjNYQmpYZzlMNXNZ?=
 =?utf-8?B?WkQ4anVIenJUcnF3aFhDZGdheTE3bXFuVllKRGs3OGNkOWNjRFVNMzRvUWUv?=
 =?utf-8?B?UzdUcE9oUUlxcnpGTGlLeVNwWUJhQmEyUnNXRGtkYkFxdXpjYWlMT0luYTYz?=
 =?utf-8?B?OXY4K2JZSkROcGxPTDhOVEcrNXRiMTllbStIR2Jva3JpbGdmOWdwazF2QWcy?=
 =?utf-8?B?N0tadU41MllKR1lBUk9KMjFOVkYxOG02RUdsc3pDeU9yNnZOek5CYXQxb2E4?=
 =?utf-8?B?c21TWCtFSWd2L1hLL0syb0haa3RHRENjam9RV0tXVWFMS0RRclRLMDI1cG9G?=
 =?utf-8?B?U291MklHRVcyMGR2UEk0a1ovTHoxaHlWQWNTZ0srbU13TTNPQ0pNTzlMY2R2?=
 =?utf-8?B?RzQ4Qk9GU0R3ME9wMkpCMkZzc1hrQmdQWXREdzVIYmJHamJiNGJWeE1PajV5?=
 =?utf-8?B?UTEzR2dBeFd3V3BJSTR0SmhMRGlLNy96LzZxeGxLa2UySUlrQW1kSlBMRDJp?=
 =?utf-8?B?dGJpVkRQVFNpQUwvekVPNllqR0RnaTMxY0VCeHRnS212c1EydVd2UEk2UHNO?=
 =?utf-8?B?RHVMVEZoRllOQlRuQ01aeFJTS0xYRldpRnh6SnhDN05BRTJzOWhJaTI0R1R4?=
 =?utf-8?B?UllSUzBmUVZ0K0NrMExnVytpNktTbTN1L3B3Y0N3cHpzUHAvOXJsNStSYnI3?=
 =?utf-8?B?UDBPTUNDRjRhZXd6Z1dDb2twcWRrM2N0T3AzbWdpOEU4NzBLNXhtTi9oTlB1?=
 =?utf-8?B?VHFYUTNITzF3N1RQa05ya2xsVEM5MVVvU0h3alFPS3phYWRFUjhGUXJ4RTZ6?=
 =?utf-8?B?MDJuQWhyeldjZ2ZVclNiRjM5Rlg3cHFzdEpENHRHVlhEUDdWUk44MXQ4cEVI?=
 =?utf-8?B?YmU1cVNhcGViak5VL1VGYlorVVl3N1pqb0Nnb2hVNEhkY1JUWHluWHFOcll4?=
 =?utf-8?B?RHROM2Zqd1IzQnlyRTEwNjBnNUxhc1pTSTdFeEVMaExZbklQcUNyWVd1eGhC?=
 =?utf-8?B?b2VDdnBCS3gwbXR5RUtDOE5BUnZmN1UvQnd1aWtJR3drOERRa2IzMy8vdmQw?=
 =?utf-8?B?WE5zQmF0RGNGUklMcCtMZzZvczUwZEFCR1NlM0N5TGJiNzhwUlNFS3huSFhH?=
 =?utf-8?B?WmdrNlpZV0IyaHY5NVJIeXo0SVptUGxYaENLd04rRTMyN3FjL011YTZGRWRr?=
 =?utf-8?B?dHdqUmRmYXRqaHJmYzg4VmJmR0ZvSTJQeWtkTDRhQndOTjRHWWsxUVB3QkxX?=
 =?utf-8?B?a0craTZHNXhMYS9OYVZLZEcvMStBK1RDSDU4R0hYK3d6UEd4MElsaTE1YjFx?=
 =?utf-8?B?UnRRMEw0MS9aWjFvZkNKcEIzdEQyUHRURHdGSlZBbWRLZzRLZ3hkQ1ZjL1lj?=
 =?utf-8?B?aDZvSWNwMWg2Q05RZDBoaS9mSDFHQUhGREpUS1R4K3hNZDZhNGxHOENCc3Z1?=
 =?utf-8?B?VGt6UGwwS3I0Y3ZlZ3M2d1ZYOVhBcHpycENDSXoxTzZnNlozS0hYQy9lTEVw?=
 =?utf-8?B?Z1BSam5NT0lWeG5aWE95TUtCNm1LNDl2NEJhZjFDVFNzK3grcHNZUHJuRWF4?=
 =?utf-8?Q?4SJk0M+M0bLt1HgDle0lLXxExv5Ju/FLtB1/y?=
X-Exchange-RoutingPolicyChecked:
	OZi6OSwx+rcNu3PfjgWhiRE44BTm5Thv6bITsjcvUe9HlvEwlL3XV55bICqodbRJAYhxLk9xRSlSOish1glr33qQWnkn0f84LQv3ZSVPletH8gGBLHUIo1aY/2UPliqG4qDCNO3gwJ51f12/tFtLlW7XsjKinawUkxApfr8gScpfSnU/IgIyufa3eK5g9+JDExJVhYHqF6gsP8HRD2juY5ArVjVscxAfnK67zGNfia00nbK3s/vPm0t8PaAVjXek2q5Yf2/kafdQrkou53tlSiGTXL+wIzT2xCD1ilJL0fI6OYWDWhgWNXxowzyrpkNzWTyi9XLah8nGd58oOs8OMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4wlIjc+bngSYoLJAXVo/0QfMSCMGidAgrNRyLe5GrueqEM+E962Ag4ixuRdRPg9LNOEUq1owRTlkSM/jdPpDyIZNLZ1H1QXwKUid3Lcpk9iL7h/vxNr2T/eCfNIdjO0SppAxV/EXlcuLrY742feF2lGhjSFzpt6a0PRUoMacoS4rCDl5+xq6J2D4xQDIm/q8+VkYlDMZo91xnn8cxcqR9vcg5grLa3ZCjoZMd3GOWfYeK3p0vpIhV8dLw6IUcm7FHgFs4kJKYXfQYqUfS/rDujGUeLJkyPtetPJerYhSUhY2+NlSUzT9FtbYDrMFgomVjxgR7sX9AFMqduybUJxbYlnD2/6qcx2kh4Xs3UuAJX9SiopKYXTmuUJ9SWTiQoc4CKS0tJhagXNnmusXGn+cQV4qlQMGnfLYTgeTxuW89ngyp4k5rdm4Aoa7QPnjfpwihDgNe23ZTngz/lyQRqOWB148lLUcDA2XZdZv1JH8zBFhudZG/HUroGbODxvueDn8Ceej4u1PaTrXsB7EKDJNryD/kELc7lemB427h73tKt8z/5P3lsgcaPdQCVJdiXwAGlrxT+YOCtJjSjynVuR0kd0/+POfN5ELpq90W2qZNSM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17908887-2420-4cc8-8e84-08df13c8a774
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:01:03.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o4ezKFovVa6nFwKLAfWHOxawnLOxOVAz1+hvd/cFfpluRS1v5T8rht7LaxEBNwQdzbnxSSQv/4sJSa10cEaC04GCiWMq3tW3xCjVB+PbgulSiNv9VK9E15/L5smPieow
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwMyBTYWx0ZWRfX3copG5geEkWr
 p+e9sqA1milPC3jjrVjKsO1xpcGuudBtO1BFrts/3fQM2YWfvFp2gX98yZ1/gEsYov9E/gvxXKF
 TQ9lJa6CYWI7DlpzIepqIK1H7d1llllut2Bt0seGdZq8YH9rHhz8MyelNn7YbkOlW5pGt7JU9yj
 0lOCgdSR6hVZ1UdPW5CoC90NXuYI0z0DeGhM+9NWfe4zWBS7bhSko/xV3ltbwCHnGLylrc0YDZF
 H3qG1VafILRAsMj14rvqCi+VNUCRentwmI5cO8vedutRfeKNIDJYDBwnPDVSnwk4D24XKOz0JZT
 E5qChRhIblLtbzXIIo5uImVcjwuYeLvRi7U20UHho4orYVD9zbTUV7w9+Kv6rxJ5nKXYuwigDI+
 ajBibyb4RJft8o7jq+pTBhuVpXU+26Ah09Ct2OS3pNHp6Cn8LUC+EuP3IAqmT/B4u9v7sFxkWEl
 Nf3Z7w0WX7MBZGMRHBg==
X-Proofpoint-ORIG-GUID: XrxdGKNEQqY74iJGIkzVBNnthjIi8OIf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwMyBTYWx0ZWRfX+OZ+gVN/vrpH
 IVN//i5GzcyJ9FQStvZVboHTi2u2RMTffQt6anFPBe7rjn78i3tEHHuXhBEqlDz2NOjRvY1emnm
 yZj4dytKpmU8+R286Ri5SS9AVNC0hCnbY4SeN9qQfi3J0QqNubgn
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa4cc7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=NEAV23lmAAAA:8
 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=iPxbGVIIySoLG4BhCHIA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: XrxdGKNEQqY74iJGIkzVBNnthjIi8OIf

Hi Greg/Sasha,

On 12/09/26 12:25 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Inochi Amaoto <inochiama@gmail.com>
> 
> [ Upstream commit 5011466bade64483bb52bc4a926719d6794e6dab ]
> 
> Change the DMA controller compatible to the sophgo,cv1800b-axi-dma,
> which supports setting DMA channel number in DMA phandle args.
> 
> This dts change does not break backward compatibility as a fallback
> compatiable string is added.
> 
> Fixes: 514951a81a5e ("riscv: dts: sophgo: cv18xx: add DMA controller")
> Reported-by: Anton D. Stavinskii <stavinsky@gmail.com>
> Closes: https://github.com/sophgo/linux/issues/9
> Tested-by: Anton D. Stavinskii <stavinsky@gmail.com>
> Link: https://patch.msgid.link/20260511063818.463877-3-inochiama@gmail.com
> Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
> Signed-off-by: Chen Wang <chen.wang@linux.dev>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/riscv/boot/dts/sophgo/cv18xx.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
> index b8063ba6d6d7f..e519a72c093d1 100644
> --- a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
> +++ b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
> @@ -298,7 +298,7 @@ sdhci0: mmc@4310000 {
>   		};
>   
>   		dmac: dma-controller@4330000 {
> -			compatible = "snps,axi-dma-1.01a";
> +			compatible = "sophgo,cv1800b-axi-dma", "snps,axi-dma-1.01a";


I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The patch adds the Sophgo CV1800B DMA compatible, but 6.12 lacks the
matching driver support from b49c70273801. The generic fallback
therefore matches and still calls dma_get_any_slave_channel(), so the
phandle channel number is not honored. The branch also lacks the CV1800B
mux driver db7d07b5add4 and its syscon/mux DTS integration from
126a1b3c61cb.

Upstream driver code after b49c70273801:

     if (dw->hdata->use_handshake_as_channel_number)
             dchan = dma_get_slave_channel(&chan->vc.chan);
     else
             dchan = dma_get_any_slave_channel(&dw->dma);

Downstream 6.12.y code:

     compatible = "sophgo,cv1800b-axi-dma",
                  "snps,axi-dma-1.01a";
     dchan = dma_get_any_slave_channel(&dw->dma);

Downstream falls back to the generic match and ignores the channel ID.

Maybe we should be dropping this or reverting this.

thanks,
Harshit

>   			reg = <0x04330000 0x1000>;
>   			interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
>   			clocks = <&clk CLK_SDMA_AXI>, <&clk CLK_SDMA_AXI>;

