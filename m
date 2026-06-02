Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8666036A03A;
	Tue,  2 Jun 2026 11:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399267; cv=fail; b=ghWcD4KfDvLGyeLphztAjO7DcNwDic2x60u51op0+nClEeYJJrI1Lw4B1hNDFsqEtf6CL4zbXI1fzn0GefPWjLfAvrndYWc+is15/cJa3DIBiB6hj1ZZqizPqAPhknUS7VafIYacU5mhGVhu5Nj8+XSkprFjydp0XMCi9X/Qil4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399267; c=relaxed/simple;
	bh=Z8DTJF8cjIT8dZM+6macoPRNZ4jkWuqjjtciVbYKOqI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ohn3I0unRzsHOKISLTSFzaDdl2yIfTuq/2FHA5ALngLcv3yaJIhZ0R+EHaWRhrEIfCxys5TtV4dEoV6oq/yhYaO8cgJkQsaqRpETghJrM4GsdKuqEyzLl9Jx6KLeFAZ/32+9y56oLCvM+HUmnGzZYIPGKE+XTRNbTNYnEX7nJhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GMFwJwA9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qUYFzuzp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GMFwJwA9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qUYFzuzp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6525tPPK580752;
	Tue, 2 Jun 2026 11:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rMw9m1zcdlq49wc7BetT7XxOdZ0Uq+2X3sEuQaLLQro=; b=
	GMFwJwA91G/E2aVcPjlYmi1RaISVqsyfbsgTGDfKgfXAlllQhK7d0Da8e8MA7TgY
	15nKruaxGSVuXfGXWIpN8IeYhFUFacrEIhoEQJ7gd+g6QLfjjss2/FrYex1WPxf6
	hfmc41RQZLtmwDTt0EZW5hM3EV6gmPUhQRRl78TihUljg5Nqrt94/+nYVofITUMK
	QCzbLwXz5+TvYRdlOYTpTDZepXgVat7euP3BsLszifDPnmbqT32S70JlOCyGqfzK
	575bYUSUzRyeq/lYfsTCeJIUcWaF4SvOWy6BJ28O6LI9WTUO0pr9dp5smJ/7/Bl/
	DIzMSyV2ecIwXMvPMB2mtw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqxdbwnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 11:20:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 652BKKsL027520;
	Tue, 2 Jun 2026 11:20:46 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqhmdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 11:20:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQwz9sBHN4iHl/A6Yqv2guM1iooxfqUt0rrSSfR5ZcSRVJpuZ6nKR3FP1g61uJ6+zqbx3q+pVD9lTxOtEmKwgg85tcZL+Me9nobdReDYjdrw0tsc1BjGCkoEqFqAhEgcD2YfQh5AgNreFS2GuoFF7hAEbUvBsvWNsIg1G+y6j8Wkt4g0eCqXmZAu0JTs/zTwtMJyX4nVDh1QgcHS84wc92x/0lTmH7y7cfmgVVw4CyAZOEnKx7pUkpZcgQMjIBXZcmgxddUCWMBWfpG4Jl4o6LdiPA0ucWXVsEgVbwWWTpjzPBzJO3dDHXWTgQKmVLlAYte/AXwimlcOwrmCetA6FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMw9m1zcdlq49wc7BetT7XxOdZ0Uq+2X3sEuQaLLQro=;
 b=Ra0DsxCyrgM3MHceeptuuiMvrcrtVPvr+XxZdHrwcZeAu+nFxYwGDuwFuIEolL/oPzOVnF5IcouDVvrwYDfzatN4CBOgV8uIBf8OUIYurlv7Fo8KbRQMy/CdA4+rXSCo58vIqvwcL/hLOJaIYp5A3L2GtCz+LHeKwBkS5m6omKHIq4TJ6FZK/RwM7XoOuNJzh8uZcP4N3OZy/jXqJ52j1Z9IU588+0mYSg2O7xLgKri2LxPntYOoQrhYIKRjBJ2zf4OKiExfE5+t6bzRNgCO86y6tzTg7h9uQ6dnJGZniszbwotg7Ysz+oi6Wg2960ZUZaLjCRI1/Aj7LJdhqEqjsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMw9m1zcdlq49wc7BetT7XxOdZ0Uq+2X3sEuQaLLQro=;
 b=qUYFzuzpYjZlMQrumM0oYvS5bWjvvxnPCaUQN331A7Jx7n8t3doWFrKZw9JgtbWbqN3Z7GIKvD2apOQHerzmmevU9HhM67hSO/IYCJTD2ybQ03asDwTyNR9UYHoLjqMDrVDyK0OLSrO9+czfE7CwPdJU5SJRYSrU0tdJk8OYVvk=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MN6PR10MB8143.namprd10.prod.outlook.com (2603:10b6:208:4f5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Tue, 2 Jun 2026
 11:20:42 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 11:20:42 +0000
Message-ID: <68ad88bb-958d-4009-8631-284853ffe1b0@oracle.com>
Date: Tue, 2 Jun 2026 16:50:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 002/570] ip6_tunnel: Fix usage of
 skb_vlan_inet_prepare()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ben Hutchings <benh@debian.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexandr Alexandrov <alexandr.alexandrov@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155830.485087556@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155830.485087556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0441.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::10) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MN6PR10MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: f77021a0-ee8c-45ed-0a4d-08dec098fbdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	eszJQUlOEMypYvw03U6ozBL7ZB9VDURnuYF9qiIhfgeTFDGLRKmmrXGW2eQWFyddotWnMLwbBHOnUKl+hKMHl4GT/YW3mFlcyXmGOb2cqKI1r0a8SZPR00EqaD+7SpZ69LeOYlNLd3WnNHSjPkGOXeBa3CuG0lZedFONDQfMY5hM9S38L7GBltAfkL6ed5bOeDSWulVl9w47BribveUcagVq8LRyMg/1AMg/FMPhk71aHWxdGRXGluqS0ujkLEZ2Ba7K8hfSc5gEsQ0mpZSEWAqpPIJTt/a38Sd/8XrOwSeOuWelGCdE5cPhDtj31pwLyOO+jxfkYEO52xUeGJrEjDRUp2E3uQTxqv2n5WFAAIdNKMww17twlj/xcgbZiNQSHG1Rv/nMdunbL4Pmgh/OWaWSOwB6O5eXvGPXga8+nRhAaFV/QTGIRHWjpvlonJKN4kanOKkF2xxU7QIn+qpO7y4a3uzkpo1cRrKK1YXa3MUtrnQZhGBvJX9x6yk3zOhqU0e4UWWj5NW8otmyOrJR0Y1ojfnG+JKt0kXW0PrEQkQ7jdlCQTMgbdtHPO8tRkRtCT0qMBlaJBiCwbriItnEYNUzVCargsINZYiAyRGsnwnMHmau0wf8zFYShIurKOWs8MQdjJEcuKYBrX75JhGNJT75DH3CO0EE4yXg5WMkm0QGJgRpU3apjK5sM0oMwnJg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2U3TkRLZmRkN1dIN0k0MlJiVjBFZTUxZW9uVUg4NCs3d3ZkdFhSYzh4Rlp2?=
 =?utf-8?B?VU01a0hDQ01qZnVtbEkwQWxiQ1VWYUE5L2R0M2dnRVRlSFEydzJBbVZ0RTZY?=
 =?utf-8?B?dTltT3dlRmNGQi9YaXBKdncvekxqd2dhdXRISDJRaEVKR0ZRUERwZ0VCZldS?=
 =?utf-8?B?RTV0TU1xdXR6U3dvckhBRFViejhNS3hSYW9rb3VtaEh5d2RHajdBWkdFR0lE?=
 =?utf-8?B?TXk2RWIzcjZ6elNJb3pZemJjWEIrQTBPRldaKzJyYjBEckdqOXQ5VHllSk5D?=
 =?utf-8?B?OG1nOU9aa21COFBweXQ4MGpNSStzMFR2aGlCVm53cmRPa01yQzJ2bDFoL3ht?=
 =?utf-8?B?VTRMa2NLMlhMZjc3V0pUMkd2RU5zVTQ2MlpMTG1kRDZKZVZNcU9EVURKTUsw?=
 =?utf-8?B?MDRuQ0NPNG1TUENEYkRmN3pwMVhUQkV5R09LYXhWOW5kSFBpQVZqMXFrMG5G?=
 =?utf-8?B?NGFJVzdVVmkzQ05WQTd3MWFteFl4OU5Hc3pRMGRxbExheTdIOUQ1TlFPZ2Q0?=
 =?utf-8?B?QW92U0RFZ2tBZE1wTDhxUlVYdUpoV3hXZWJ6VWxNa1FMVmovUm1TRDBPUFdV?=
 =?utf-8?B?bGF4eWF4Ujdmd1BPYUFhd05wc2ptUUFLbVM4UkdyRExqdmJud2hMa21mamUz?=
 =?utf-8?B?V3lqN0FhTHArTi9BRDVyVlBmYWkwZ1JxS2tseGJLQ0ZUeWZZTnF1MDJhOW90?=
 =?utf-8?B?RnpyTXl4NUpxdmxVWjJGZXVvVEM2QVFJMGIxU1ZLbitQbzJRVkxwOEJHTVlm?=
 =?utf-8?B?azNDMEtnV29MODR4eGtUcTZiTGRFMW1RakpVcWZwRUZjUVdqd1B6R0hocG0w?=
 =?utf-8?B?UW43ekR6c3lDYUM4UG9oS0Q1bTF0L1BHS3FaQlo2MHNpcDNnOTFXUG9kWmxF?=
 =?utf-8?B?UU0yMTkranN6Q1dFV3BpblYxS3B2bktuZVdFVGQ4dFBNczd4SDQ5MWo2Njdj?=
 =?utf-8?B?blg3bW5Ydk8yR0NsV1FtT2tGUmpYL3ROTU1iK1lqMnAzZFJXS3kvSXd5eHhY?=
 =?utf-8?B?cVJZNTFtTnppZUNJYmZXRVd5SGljTEpFNFhyTUxsRGVnc1o5SmFlaDUyalFj?=
 =?utf-8?B?RVVFT1gzYWtITXZPczczM2xwZUNhQWxTMTkrcElnVGFwQW9BeThWRlpnZFhM?=
 =?utf-8?B?M2hlSG5keDRtZFlkWFJyQjFZQ0cvWk9OYXBnanYzRFBCaHRGN3piY3AzWTBE?=
 =?utf-8?B?Z1p0OXRPb0o2eGJLRkxXdUpobENST3dndGRJN01zVktwdXYyU0xwaTd1M1k3?=
 =?utf-8?B?V3N4cmVFZEVOSUh3YWY2YWxoYmxZZEdQTzU2OVl1Uk5QN1U5R3lOQ01FV0My?=
 =?utf-8?B?dVNZaFE3ckJ4cUtNNjdXREZ0YU9Mb3dJNGdnbkIyVHlhZHE0M3R4QjlkNFV0?=
 =?utf-8?B?cER6NFRxUlF6VENvc2REVjdXb0xKaVlZc0VpVzlxZHVDYXJxTzVFeVAyYW1q?=
 =?utf-8?B?YWxHZnd1YjZUS0JzUmI4K04zbEhrMklmcDRZZ2s4SzgrNThKS0VCeTJ1YnpV?=
 =?utf-8?B?bllLL3paT3h5dWM4NlBqYzlDRWg1eE5DTnd0LzkyUGpRM2RKZ2V5ck9WNGNk?=
 =?utf-8?B?SCttMXNXbmQ2aHQwYmhDdHVmWjUyNlo2TldjTlNadG1WVmVKR2p5TEJqWEFO?=
 =?utf-8?B?MlQydjR3UDc0TWxIcFdWNGM3U2xtZWlNYVo2WkpkazFHTTFRK0I2NXp2cXd0?=
 =?utf-8?B?eS9paWVKakR3NVpnSDhpZ0tpdVF1SFhBS0JIbk82WE9ncmVXS3pLeW5DMkF4?=
 =?utf-8?B?UTVUbnpra3QwNnVENllHZzhCOThsWmZHTDdyVktDT0FGdDdCUFJrL01LY1NO?=
 =?utf-8?B?Qmh3OUdZUUpwMUpWUVRiMUZsODJ4YXZua09xOUdia3k4YmRjeXlLc3FrNE1R?=
 =?utf-8?B?TjlSQUJjMXBFMzVsRThWTS9IMExRWnh1ZWozMmFodSt6TE5uVEZzVFJXUXBu?=
 =?utf-8?B?TDJqUFIxajV4RmJ0TDVPakl5Sm0xd2ljZG1CMURYb1FPVnFpVGZkeVJ6TVF3?=
 =?utf-8?B?bDdhQVk0ZW5Ua2E0R1ErS3RZVERJS1RKVmtrSkpyRzQ4c3YreEJHb1BVL1p1?=
 =?utf-8?B?Y0w1NkFIcXJoK1d6bytTYjNWVDFoTTFYQ29UMzZ0WUZBcWorM0s5b0ZDMFJI?=
 =?utf-8?B?ZUtjQ2R3ay9Hc09lakowcTNIeTdBQmk5ODBvY3pGV0FoWitjTmJtdzJJMmYy?=
 =?utf-8?B?ZElsdjAzOG0yb0UyMzhPaDFDa2UveTUvQ2ovWmhDK04rVkpudGZmU1BCNE96?=
 =?utf-8?B?S1R5RzUyRkpuK2lkSG5jSmxlUkNNVjI5dHEzclJzTVVMUkRmRkErSGwwWnJL?=
 =?utf-8?B?aEZ4ZnFlTGxVQUFINzhibU1vWGpzZ3hFeGdtMHI3ejAraEFKMnNyZ2loQTdI?=
 =?utf-8?Q?Yb77gKACNQH7NzFu0g15YkVkGy5R1zUuAQFpi?=
X-Exchange-RoutingPolicyChecked:
	GhbB7lpSuiINscpJZSPpw318cxn63dDksnSEzxZAMHKeAylaK5zc9y1r8xkAtEpxVNAT9yx/8TTtMrVCB2giW6rcW2xe8RcPawSXrzlMhn7rrS4fcwmpDwdWfEzLIkQWYbMgwSf4WYHrm/0/r0YUgSaSbVRjm3Zu6x69GnZWOmYQeBHxGBF19l/EB3fCmhTAkesDlYvWVQazJaxjCGaFQ3HF96poOt5qUleAPtURc0wAe7rrZ5sIxRM5zNk3N95gaMLG7Cj7PMf4YDYLp9jiZoNJetlpj8tVC8yyzX6mJblc5ishmpACOOluUG8P9AWZHIb+oY2zXA092juJ28j31g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SOynXigIekdx6p5uUASVh2oWWgYv7nHiZ+MyaDnSccYW5G8paAqhijC3u0PkSIJ2WF5QuEs3Q0lk/l80/jv/mGzbc3aCa2cQQdG+zlk6khsoIeT4i8vd/kucrGW9vlqKW5W9Zb7y27WnmGvE5UNNZvjH66QR/UpIxtWB9FksFPgQSPgnZ4t5Z+Mbg9JL1H2RJVdcngapI+t/6JV2vHlhFrM5D1RV82Vnj4h++PfKO/FreC/45YMi+1qpMyVsA/q7p0wbMRaTEvjuYRE1YdQKkxOmVdmQOsOJLK75Pwd29/xvCTe4szFaH0MZ3kvqS0bvoosDVJCpFZhasks5gcD10Ff0gjEtx/NUGgL0tg9ioGN25+b3A1XzXwHsNq7773w13LUR9ERbzCf0HgbsBHRZHyFFBc0JTG1V752B3wx8WAJbia6c9EoU0P4BN23jtAPaVdQ6dallaDm+V9fUdV+2vz/Mj2T08ZjQfPLui934TZw1JECl+/kcogmww0NFu8rUwbLlBqFTTPQN++YmxqIaBuVS61FaqcRLYCsA009ncuZkqAgn76DO6EihgEK33d9OyzrACy2F4TUwnBQLX0YBEww3QQIt6ARR6u0t7vefSCM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77021a0-ee8c-45ed-0a4d-08dec098fbdd
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 11:20:42.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUspWCwlwQ3nELTqT9wTO+33XrU9KlRDxsulIgefQf5gV6iJgWJzK/OTGbyPHWLh3K0omtQOTHG++IUNgcnuA7FClbWdK8MLZKgH9HiiI8xSUnuwCYiMSgw2ueeWbqXg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020108
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDEwOCBTYWx0ZWRfX0Ns8yNHEtG80
 qmYz6ya3I5R57cO5zuQX486mmLMOt6h45cc80jDgvbLTYWDg5zSfVp7qHofVppYHuP/q1A6z9fb
 IGjjFuHMtLxdJUXiRnIKNxl5yKOwFbjfVEir1tvvVm1pHBCi0nVK2cIiSmo/lQwOqK6prKpi+Ml
 oJZJtH088g3KlCfVsEShsUWKIB1S6LLfgo41m3Cc6HlM38vLO9FoAIMTd0SMjDQngpM/p6EX9DS
 4NShVqhyN77V61YjBpOfyAAxD7ylqm1yNLFTFetZr9N63hnkh1fA1RcCyxfBDN8amZjE9cUCtsO
 y+gsPsn/C9GLHQf6E97/GW56OjwIzExuOziFU1kdNo7Af4DAgy384XkSvZorySaAVCPlzMxO0WI
 aanyhd+GWT7NZJS+hUKKlObmy7y+juYfzeJk+XfBRNOFq2aI/GeW5z7cS8nYjjnqS/t10WMYZfr
 sgysDgKmdU6Zd3ktRwPZrSkHgFVWeRFYbEgjUAGA=
X-Proofpoint-GUID: eXczlL3x7l8s-UUQLrmZybbAEYo5XG2g
X-Proofpoint-ORIG-GUID: eXczlL3x7l8s-UUQLrmZybbAEYo5XG2g
X-Authority-Analysis: v=2.4 cv=Po+jqQM3 c=1 sm=1 tr=0 ts=6a1ebc8e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=8T59DR07AAAA:8
 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=4MB4QiJ97WKzfMVxc6wA:9 a=QEXdDO2ut3YA:10
 a=nH4QB3FtVBqZfhiODIJV:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12302

Hi Ben, Greg, Sasha,

On 13/04/26 21:22, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> Backports of commit 81c734dae203 "ip6_tunnel: use
> skb_vlan_inet_prepare() in __ip6_tnl_rcv()" broke IPv6 tunnelling in
> stable branches 5.10-6.12 inclusive.  This is because the return value
> of skb_vlan_inet_prepare() had the opposite sense (0 for error rather
> than for success) before commit 9990ddf47d416 "net: tunnel: make
> skb_vlan_inet_prepare() return drop reasons".
> 
> For branches including commit c504e5c2f964 "net: skb: introduce
> kfree_skb_reason()" etc. (i.e. 6.1 and newer) it was simple to
> backport commit 9990ddf47d416, but for 5.10 and 5.15 that doesn't seem
> to be practical.

We have seen ltp-net failing after this LTS update on downstream kernel(UEK)

   mainline            : v5.17-rc1        - c504e5c2f964 net: skb: 
introduce kfree_skb_reason()
   stable-5.15         : v5.15.58         - 5158e18225c0 net: skb: 
introduce kfree_skb_reason()

So this is not needed for 5.15.y. This needs to be reverted for 5.15.y, 
looks good for 5.10.y

Thanks to Alex for reporting this.

Ben, thoughts ?

Regards,
Harshit


> 
> So just reverse the sense of the return value test here.
> 
> Fixes: f9c5c5b791d3 ("ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()")
> Fixes: 64c71d60a21a ("ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()")
> Signed-off-by: Ben Hutchings <benh@debian.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/ipv6/ip6_tunnel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 553851e3aca14..7c1b5d01f8203 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -846,7 +846,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
>   
>   	skb_reset_network_header(skb);
>   
> -	if (skb_vlan_inet_prepare(skb, true)) {
> +	if (!skb_vlan_inet_prepare(skb, true)) {
>   		DEV_STATS_INC(tunnel->dev, rx_length_errors);
>   		DEV_STATS_INC(tunnel->dev, rx_errors);
>   		goto drop;

