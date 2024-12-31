Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD69117BA1
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735650249; cv=fail; b=ASjOZKHB9lNPk3jWl320ofQXOsUsBicpVTENYu92CBGUUtTbFATzhETgp7GXT/hr1EgtffikUR8GreZv+gh8WJ+Z6bu+5RWIvZwpM43k4iZrTpQjnHh4X/ZOLw12yUbW01b92cyj8ScYPHCCR+UQgho9wz2PtaLtzPSjfqksoW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735650249; c=relaxed/simple;
	bh=shREUPKkPkIitBe5ofPRxXc1/03sj9krcphDxgAHBoc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BKOT41B3+0hR1YGlJSpjlH5nC/do3/GTKcaVgtWSLp2mMOdj925Fv9Ebp13wP9wRpPxtgrPF1bq/+UVRNvOFtyHrSisU51JwzIE5yV+KA0m1LO8k3QqVnqrRkdJGsj42INXhlNyFyHchDCw+9c0tyKdNsQIZ3sba8byskSlqOAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AMyNUrhC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h99DHrzN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AMyNUrhC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h99DHrzN"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BVAMmmk005098;
	Tue, 31 Dec 2024 13:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hApGYANIAM5mxLM8zM6M/v+kZ8jOakaoUVNOjQcmPu4=; b=
	AMyNUrhCCkzF31ByOfpJejowgwBDfcMHlX2YS//87eADNIh64VcNcGiAm4roIU9K
	tn7oyvx6TUBwVxKVXGRQmFBIBmtpp9hUicZcbj6ilRQ75fsZIgX3vBf4A9MEb13a
	AqBRpj7xjs1McSJxnHcR3pB3LM/1ZwSYyO4Qn5ROh591TQkbKgv4lq0lxaqz0jpL
	yC00JqIHSNVEIyp0tWUUslckZEdnGV7h6A6DMvRc03joGIVD37PlqQvH1O2BTL3I
	sbrx5dQKRZoRMWel3uDZ1AucxIZXGlXxqQI2qywjBJI+/aSgid7EVrltB1Yx4zDs
	E47nanBr9DHLyOKi0e0bbQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t841ub3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Dec 2024 13:03:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BV9f1UQ008518;
	Tue, 31 Dec 2024 13:03:41 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s7e885-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Dec 2024 13:03:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAS0NUdeI5a/+iwUyOfLaRcepkXa9kohQmC2qYVqzLm8GfkBVxTKoUwxpFkyt6ndiCQMdscmO0pPmMIRv3TWQRtER6D37HdxG8XjpzW1bG5ps0MCOURrD4II90w/59YPfIoj7snuF6f2CVTrzwI8U4pK/WoFZzxbzMHZAC7J/KNRXCAV6dTT3JCOTOVQu5acGCd7p1eukQH/UUya3AWJlHuDjNJm5V7lYIgngsJusjVTzTzgzPA/EW/vR2PkrNCWYTR+2FtIbEBsJDsGfLDz6+4CyotgQTHRiPBMdGvAC7Ej9jeLD8OiJgZqYE27LCUdf5nPhO44wv4OeN6Ml9d1VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hApGYANIAM5mxLM8zM6M/v+kZ8jOakaoUVNOjQcmPu4=;
 b=rK2HDPT+fqWGgJ0GhcVYtW9ioJ6AlTRZqRVWKnk8RXtjOvGpdfInL5LJjk0N7/iHeYdHjddqaut6CSr/TdFVSysUEDeHBW6oKERVGjAOZ8NKPV518QyxjLaiNFAUF2GBGYESztWnSXEAUY0HAnDv6TkDqxdung/e4ksWJ8gE+Hto8lsa/UiAzD1CK8+m22shbpvoIuGIWgP/Ry5T3Iz2KsITmvoiBj6pumbHqCJXFG7qnCIFL9aRnn1o2UPHBqzZj+BXxa1+vC6wnqzbUm/Uj8PIgR7ozqb/pX2ObXZuCh6OcRK/EUoNCYGAdskHWqPKpeVj1nF1+VTEidFjsyv4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hApGYANIAM5mxLM8zM6M/v+kZ8jOakaoUVNOjQcmPu4=;
 b=h99DHrzNCzieycRWV9dwYHf3oIC2M0c7vaYy/cMqknbN2waRWhGhZS6+LbjvrQ4bhIgARkG/GwkRI0QLaTVC4Z1mXO3lEjN5lDJWtwGefpVv4syt9PwIpYS8jI2MoroPRz/RJAt++Y/Z7mBvQL1bhT9ZcXBbwjRfjQbUYINOA0o=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DS7PR10MB5135.namprd10.prod.outlook.com (2603:10b6:5:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Tue, 31 Dec
 2024 13:03:35 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8293.000; Tue, 31 Dec 2024
 13:03:34 +0000
Message-ID: <e865aef7-81b7-42d8-8670-88e09ca5eb2e@oracle.com>
Date: Tue, 31 Dec 2024 18:33:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/86] 6.6.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20241230154211.711515682@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DS7PR10MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: d7fe309f-1590-4824-cd8b-08dd299b88a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0prQTRCZXA1Snpxaml6QVNQY1dYb0g0YmNqdUluMmdoQk5FekdlQlU0NE9v?=
 =?utf-8?B?MCtNWktyVE9xeTFpQStpSGNoWmkzZHo2Q2FnT21pMCs3ckxFaDQrY2czY20r?=
 =?utf-8?B?ODFkb1VzcEt5VE5VV0k0TUlna0Rpd1J1V0lYQkpZdXppZll4Q1JNRllKUU1k?=
 =?utf-8?B?VXhnSG4rRkNTT0JGYU9zZFpTNmhNT3MvRmtLOUJJS095bmlKTzhwbHIwejR4?=
 =?utf-8?B?bEs4V1FwbGEvTzgwYnM3NklEazBDeHpiUWtXWi9WWXdneGREK3RIVEFtcEtS?=
 =?utf-8?B?VGloNU53Ym9yVDluemE3MjNaSFRqV0xrazF1UU9FZUxOcFB2ZHNKejhucVFX?=
 =?utf-8?B?TzNZWVY5eUU5ZU9zRW1xM2ZBQ2VJWldvUWtzMFY0RjNyWU1TWnhzc1F3UC9o?=
 =?utf-8?B?L3RsTW1Wd0xHVzVQNExuVUlOczlOdVIzbkxoVEh1SStBZ3MxUWNxS0JtYXdB?=
 =?utf-8?B?WTduZ0tPRTQwT0JlWEl6S3VFY2tmYmx5R0o2bHlBNE9FalhpeGJDRldISmVZ?=
 =?utf-8?B?VmtjT2NwNEJkbDhuSjBONkJEQ0M0N0w1c0Q4TEVuRFR4ejFabEszZXQ2UGZB?=
 =?utf-8?B?WGYvRVE1aTJyNDdRdDhyaEdudkhKUGFYL1R4L1dWNzljdjk3enlsV2l4WnQ0?=
 =?utf-8?B?RTVyUnRyZHkyMExJc2pQMGJQcWM4OGpjeHVDbDlIRlZxUWRnQW1waktkSVhZ?=
 =?utf-8?B?SitsR0wzbU5sY1NRVFl4VEJtMjBjS2FPSnVlQml2eTh5WjZ1bml2OERUQVp1?=
 =?utf-8?B?ZnY1cUtpdjRxZXlRalZRckNGczVvdjNHeXJDQVRoeTRIN3laMFZOaFd3ZEE1?=
 =?utf-8?B?aDdiM1MxUm1hTklxcE1VaVp0aDQ0aEVwQVI0dlhCL2pNL3lQUW9mV2VSVk1Y?=
 =?utf-8?B?dmxGWmh2U0lBRnBEbXhFaDFBZ2xPbXpadjYrc1NaTnEwVXpRVjFYT3prVnVM?=
 =?utf-8?B?bW9KaW1CZWQ3WjdZL2FkMkZuK2VubFN2Nk1iZzJPSFNZRE13dFB0ZVp6MDd3?=
 =?utf-8?B?TnU3aTVBcWx1YVNWMHNpVDVDeXJwbTJ1OHZqaHB1M0ZzSll0ekJ2aldmUTZ2?=
 =?utf-8?B?TVlUN0FFQm5rUDVXT01UQTJOcHduT0FaZU4rT3B2ajZWTjdnWkZDREVNOUh0?=
 =?utf-8?B?dEVRdmptUmQ1VThnY0k5SHJuU21wNUhYdWZrcjJGL2tZSlJYYW85cGNlUVFu?=
 =?utf-8?B?SytBSGRxVEFNbXFhaDJIWlR2dWRiM3E2dWs5UXpXVlFKMStsS3BxR2huUUJI?=
 =?utf-8?B?SWk0dW5VQndWOElsSGdORU9xbUNHelpQVXgwUFFTZWlFdExWVjdaNDdVZGUv?=
 =?utf-8?B?SStrYkJueU1LdmVVWlVKTUE4UXV1NVd4Ti9qRVd1bU9ycjdLUnhQU3hyZUpk?=
 =?utf-8?B?aVBuOFZrRkVYcnlSbFFRa2l6WXZwSCt3dklUektSV3BFSUxiVGRqRVo5OXZu?=
 =?utf-8?B?T0E5Wk1rRHdxZ0ovN0lLRWNxa2tqcFhLYkpaS0ZuVnB4NXFxazc3aFVzNWlq?=
 =?utf-8?B?czY1N3dZbEFScTg4VVlCVXEvempOcTBZQS9TbkpHdVVGaDE3Z0VBOGk1UWZN?=
 =?utf-8?B?a0hXeFliWnUrZ3p1VG5jREY0UlZ6S0RSK3NNRUkxNFo5RDFEUUw4aUwxVFZO?=
 =?utf-8?B?ZzlxTkg1T3lNVmpEaG9hRXQ0WkMwaVRPbzNwd0RlbFE4QmlVKzVuWnhIMUF4?=
 =?utf-8?B?cnFLZmJpR1lVN1pSWEo5TkJaMHhsVSsrM1g5bUtFWElRT29pSmUwUVUrcStI?=
 =?utf-8?B?amhYMUVPSWt1YjB0RWpYUnlvVjhNTk9JempDREgrdHdBam93T2p5OHRCeGdP?=
 =?utf-8?B?RFhObEFKN1UwYUtaYlVqS1poQWFTMjZaWUlVWkdwUHJ1anpjdG1zcEI3NlRZ?=
 =?utf-8?Q?b7gbpKna0ykTB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ukh6Z3QxUG8zTHBicEVRb3p5SjNjSmNrS09EMlltUlBHRXlNTGsrSlo0SUkv?=
 =?utf-8?B?YWRMS3QyeHpYNjdBNFNTNUpDbFMrY2MzaW0vamsyeTYxMTJQRXdGc0ZzSWdU?=
 =?utf-8?B?VnpzWHBWSEF1cTIyQnMrSzJmSkRmdXhSSmU3M0xkTnNTNkZucmNhVkRTU2or?=
 =?utf-8?B?TWl1Um1ma056QWttR1NqbUtKQnk1dUd4K3hJajRTNUhsTnZGYVNWZDR3NWRX?=
 =?utf-8?B?M3htbEZLemF5MUlXaEdhczVyWUVNNWFJNlNBK0RPOEVsWHRrcUx5VFFTaE1a?=
 =?utf-8?B?U0JaaExuQ0ZDMk5RNjVUNU56THVQNFZXaUZmYUNQRUJZVEt3UGE1QTB0RGdj?=
 =?utf-8?B?dDB3WXc3VnNkSHc5VXByOE85d2hmaCtxSVdGL081bGxXMjJCUUlIYXpEV0dm?=
 =?utf-8?B?YkFGU0tPeDZTNGVKdWNkOUpvSmRjN1F6c1ZiTnZFNEtKSVVBcTcwbUVZWXI1?=
 =?utf-8?B?THlZL0pIS0x3YWUrazdUQTJRbFJZa2kxaklPTVN1R3VDcXo0NkJxanN6eTZG?=
 =?utf-8?B?NGFSelptY1FtZjRmN0Y5WGZtSldZVlUvK3h2MmxHRTJCTTFtWDFtcFh5TXZh?=
 =?utf-8?B?MnVBNkQwNFlhby91c0h1SW9aVDV4Y3N6ZTlDV0ZMdXhsMXQ4bjg1RDh5SmhM?=
 =?utf-8?B?TWQxQ0hSRjlRcnBXSDhsV0VDRFd6WWhwM2pNa3N3Y3d5SWo1MWJxWUZiSFZF?=
 =?utf-8?B?Q2luWXphczFrc1JkQ0hHcFhEcXdDV3BwcGRCNWlTV3pwSFBWdGl5VExPT1Ny?=
 =?utf-8?B?YXNRVkg4akNGNTV5MnJGbUR5eTNzdkdFNWdQZllxNXNtd0tadGtTakxIdy90?=
 =?utf-8?B?Q3ZORHQrNm5MRHhKUUsySTk1Rjh6VmRtVTFrc0JXVElSaHJVTEQ0MFNtNDFl?=
 =?utf-8?B?RzZSaURGYlNqVE50eXM1SThDOWVmWnZRZXdTalN1elM2b2IwbWtlSjZiTGlI?=
 =?utf-8?B?ZS9CeXBqY01NemxDaEl4Qjc1eW5ENTBBNi9BVUVwdGloQnpqSWgvOWdtUDNF?=
 =?utf-8?B?U1hOVFVGY0sxR1RQNCtMQk96Q29naDljdkQzV3JsYzdqdGg3WGVGaDYvanl0?=
 =?utf-8?B?ZEl3dDBZK1VycnBFZm9DMFRDSmtJQ0IvUnFWMzU2aHd4U3FpMEIwUFgya1FD?=
 =?utf-8?B?ZnN2OW1aWWZZbUhiQ0hiR3dvSWxWWm5pM2FiNU1CUUJYUG5HdkVaR01udVVw?=
 =?utf-8?B?VWY2QkdaT0RFMGZuR054dXVlbkxLd2VoQldWL2NFd0FqUUZOd1BBYUVzRUhW?=
 =?utf-8?B?aFhaUGhYK0toWFFOQVlCdEhGdzRxM0NlRmxndWNLUllzcXlxMTM4WFNIZG82?=
 =?utf-8?B?ay9UUS8rTUI5cDNOMzRmbFFKY01rR00rNjJwRHpJZWlWUUVUQTRKRGxscUJt?=
 =?utf-8?B?TENWQ1oxMm1yakFQY0tzYm5VM1VWYTBrMGt6YlZoZzVIT1Z5WDlXN2Fzd2ow?=
 =?utf-8?B?Qzg5OENNYWJTRysrSDR1a29vZnY0bEU3UWg1Q1hxd2pVVWxJT0Q4T09TOHhS?=
 =?utf-8?B?dlNmSFA1OEZNZDFHMlB3Z2c1dnlJbkZWU3B2dVdOVVpWektPV2dHVWluVlNu?=
 =?utf-8?B?eHk2T0tpZXp1SlJldXBuK1E5K1JGSmtwcHgrUnlTV0VwYktGeHNPenByclpJ?=
 =?utf-8?B?UEErMDREK2VuSnpXbnhEQWpZN3lPREJYY2U3b3JKUVVua2dwTGJkUnBWZHVp?=
 =?utf-8?B?bGtOUVR6aHZYYnZlZ25wMWsvR2tsZmhHa3Vsb2xlRDVQNVcwZWNlS2gxbi81?=
 =?utf-8?B?SnJKRVZQcC9HNTJmdzlHNXkxNFFBZ2lTRy9mTUpURTNmbkNiNjRoWklxRTJZ?=
 =?utf-8?B?dGxEZGRSZm5CcFlOTDBtOU1PKzNuTjdzbjZNZEg1RVlGYlAvYnhXUElNYm1a?=
 =?utf-8?B?MmFuLzI2SWV6RDBtS05CVldLZ1JvZW5vanJsSXdFN3F5VkV1eFRaZ3A2VjRq?=
 =?utf-8?B?M0dCZ3p4OVErbkhzVHgvZlV6ZE5OYkNyU0lsMm1YTzBKTXFoWmpXZVQybFVz?=
 =?utf-8?B?OWRURzVMTjlxZnJMQ2sxSkNJeitvSnAySVZBMkhsMHk3cG5JY0h1dlFsTjNo?=
 =?utf-8?B?NFZpNjdKTklZZmg1RnVwMU5HN2xQc1ZzcHBRMlIrSUVUazY3Z0EvdkZKcnUy?=
 =?utf-8?B?K3ZuSlR4N3pDaWo3SUdINmlMdklSMEZyVHYrOTFuM3I1UnJ6YnliTUE4ck5I?=
 =?utf-8?Q?H2os9TIiQ1lBr+3ytcYKhIU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nvcfmbfwuI3ZHPiScgAWla7uyKiThFgYbOnrZYPREoOQipmfnY26J+AWWbUpEi6yuLk8rSj1n7MLuux9r57Rtfd+dSPefFH4vGK7byStjimO2hs9Xy5PtVNqOaGK/8SiapX2JH8xhth1r1/bi3/cT7VZ9UTc9GnzdJedXdQOQBrU9lsfh86wf4fwPjAm25Gm3Ku/WL95I4E+93kDCqYYeNXXg8syHBTVOgUWT4ZPo/BS2NCQAJ7qs8BOR48nVIJq0MJO3XB8VOHRnrqBU2d9RnfNFZ2FZrIe/IpLzMbZ0cBviI0FkXI4sGmlKLNL0RVh9srw3V/UvFQYyIKHrAhPXxGrFis1kZSQy1sDziPALV2ccBjczlJh23xRjK/muK+4pNFDvsMttLy/0l5pkBGKG43p4OUEp9IwQwIgHxj8RQGqmvgiGUbHuYXybiunLksSGDtKzR7cgwT49uPHbCkGzVUsfQJfXO2Z0qYKuasISEwc8rKReMDX0arVDXFlPonKGPvIJIUeFyauAshwgW+UsgHLCua6+K0cj6yhS3rSfq/Sh3I+TwEI4nbtIPsGZ9AgroqPLlByOihO69Kz8X6QZaXuNiR9hb6Z9jTlFfnJvPA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fe309f-1590-4824-cd8b-08dd299b88a0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2024 13:03:34.8516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EVCVR3o4KrxInPl5TB55RokMNPkN3R9SHSOcmMTkCv3OIutr+5wZiTWglSTvxy2uRh/mE5u6C/8CG2MPLHzBKl+g0bDYBIjIbagSKIIt4C2q/Z+kcswc5m4TcPkUWuX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-31_05,2024-12-24_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412310111
X-Proofpoint-ORIG-GUID: cpYtyxW8es6_S6uTbXsIfMX1Yot1S6GL
X-Proofpoint-GUID: cpYtyxW8es6_S6uTbXsIfMX1Yot1S6GL

Hi Greg,

On 30/12/24 21:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.69 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
