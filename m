Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080201F1922
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736269053; cv=fail; b=ilveb9DfZLkjVqSyYPGfMrWZFxit9kWDcA0zC/QTLw7+KI3HVXlHe6Bu8IZp9wi2g0wUczbhf/YR/dJuiNVrJFdk3V+T4tyRv8DU0QhVBHa+daNtDXVwNru2C7btZtBIiVIWtbuWYtvAXKg87YE+nF4tNDvXvDBFIco5rtp3o7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736269053; c=relaxed/simple;
	bh=VBnCR/KssPFlkkWxpyOcUHCPgiwJA50WFC5iNZpwdaA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z9gbHy+vY/CYKy3yhyv7qKJ8sVNncHeSYybzhteDow0n/1t3qtx/vVqPI2J62RIeLiD/VRvaN+7zYrat3ly7CME55ampIMnyjBawwGurehPDUQ+2JLRia/j6g6G5WV0KQoK9/0kYJA4KF6vgJCMVVHCkSvTk7MEzXTMcA52zbS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NoD0kRMy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V2b5FIe7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NoD0kRMy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V2b5FIe7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507Gtn8a028002;
	Tue, 7 Jan 2025 16:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pXPXad55qUETxN0yyOjkJeXx6GL/jiGLanDte5rUfog=; b=
	NoD0kRMy4OH9UnXW+q2szrCGBsjRDheruXeK2D+5mfYE/zRW4C2WV/aJEbt8Gdzg
	cjjbJWQZfnrTu8VYyh2qHikB4cxipEJd1KmgFl0+pqbaM5YpZOIbKPNoR7gLWr3W
	AalS0yTtStKY1oxUDQ/NyxKcpKZQA/7Lj7YCfcD0R+a33UjNLZa1Wk2yCV8u5OJz
	yRynhMgY3pAT5gqU29c6X8r0gtFW2o1iOkNsfW+vRf7WCj58C6LqYMxaFE5Q3blL
	lF/G3JcEZO+UbDQflWcNnjDtZ/+gSAkhmO4ktIFb8Pn4r4C/f9Ga5cNGguDpGjrG
	OPKU4/ldVK0tax4VkROuCA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk05f23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 16:57:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 507GiKMF010924;
	Tue, 7 Jan 2025 16:57:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue8hbue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 16:57:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i4CA73A5a6B7ExioLGUfAixGbqHq+y3ZVDb+0ZBD0fOvLCe5hBK5R8cYE5+o1Iguerg4L4JyJB9QOK2E4K4oZQ1xQBD6+rbmy+TES1m29Qo3KEogcMg21LIE9C3XvxxrzOiGa9qfA96u9EUo16gXwK8Xa/Hunj6EqPZ/ItTn/f8OlJ2LbfHM0an6HXicylJEaHsOA/8l6a/eFBXGGynvFmzp1z56H5RPEewrNfo9MPuvyw7YFkn7UI8W8MqGw5+76hcb9LKoOX/W1qqwEt5EPR9uwwPax73TXnUJ5omPWg4m1pTTKqDZfxf6bIE26lXvdBnD1oMvf3H00gFAKhRQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXPXad55qUETxN0yyOjkJeXx6GL/jiGLanDte5rUfog=;
 b=c5sECWI0AjtyprmtNqzDXJl8U0rVMl799FMV78HFmg0qs9jYhmX1ZQHL4u959fY8zv2cMsC1JhokE0jrP33XXIG1xyoS/nMNImA46CpY6XbyWOIdUfmpwKNwXv6/0whgYV/oyaa18okCFw9xLNI5l8R5RRdsXSi6eojfngn300GXza3LGyhf1cFH3fcssQR9FgHX7ENkPI5uaV/om+Mo9oYODJ+5jXa6zvKQJ9tSJMlEWjkpwsmvLw+nAP8/uRKezeFGyvfPBnPPdLWrIiWUfpWQ/gztKPOg1TvhyetdkMKbOUMHbfoiyUKBrbPr2SxCyBtzYhAsCBKonbUsCYzraQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXPXad55qUETxN0yyOjkJeXx6GL/jiGLanDte5rUfog=;
 b=V2b5FIe7HKw4NKzUiTkzNHtPioLyMk9H9kuXVRHP4B6JI2YNKsgahCpsKbAdk9vhk1iqlBjkuGPiTxomxS+SyuFESD824vEw49LefRgbs5I6sGeWeMN1G37vLDtU9eUl9MjnPlxJGhn7hu2UMd9YkGPtwOXuSg+48Xj787x4i6U=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by CY8PR10MB7339.namprd10.prod.outlook.com (2603:10b6:930:7a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 16:56:59 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 16:56:59 +0000
Message-ID: <9d341fe3-cd1e-4d56-a6c7-ad4a9cccb5d2@oracle.com>
Date: Tue, 7 Jan 2025 22:26:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250106151141.738050441@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|CY8PR10MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: a7109376-1697-4680-7c50-08dd2f3c4ce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlkxR29jelRtYzQ1TVd3YkpKa2wzdW1WK3hUcko3TlRyRC91YlR1ZlNxckxM?=
 =?utf-8?B?NTl3aTBxRlBPMG5KYlcxendRZEo1TE5KTGZCRThjdWdIZHFKQ1NVUzBLemJE?=
 =?utf-8?B?VVQzOVVVQm9kbjB2RXIyZUFCK1hNbjlBV2p6Y0k2SXVXMk82MVhHUHlmU2ZF?=
 =?utf-8?B?VnEvR2pTd3llaUJscytZemlKZVUxaVc5V0xhc29MaE1USmhQNDZoK3pGekI1?=
 =?utf-8?B?WVlZdThwbkp4azgzdEdMRHNWbFBlcThHK25NbWdjSUZ1NFdyclFRd1BMQVFX?=
 =?utf-8?B?SGxtWGZZTjRnS3ByY3NDMzBMOE9rdkhnWUtSS0pSY3lwUXlSMUNkbEs2Rm1M?=
 =?utf-8?B?OHhjYU91Q3RIY29PSWVhK2hEaXhFUWs4c0E3Q1Bacms4YU9ONWhtQkxSZ3VT?=
 =?utf-8?B?MWo3Y214ODVRd1oxVmwwUEFadEV1aFJRTXF3NmNUck9kaEJwRkxvc3dCd2xB?=
 =?utf-8?B?Ky9nc2k4UFA4K1hsZTN4b0hDeGx1L0VUR3FTRzZNN3Vsb3NtQW1qWXBqY0Jt?=
 =?utf-8?B?eXFDNnlCcytXZUVrSjZWZXkwRUZQMlRoRktTcTMrRmZWVmRRZ2FlV1NaZERP?=
 =?utf-8?B?V1NlZWc0OEl3UW02TkdnOFQvUko3NTFWY2RuZ1VWM0IwVlpnRnRJTnF1Y3Q4?=
 =?utf-8?B?ckxhS0JUbzY0Y0w0WGRCK1JaOGFZbFdONmU4OTJIVlh1WktkVE5iell1RGcv?=
 =?utf-8?B?MjhwbHVkeUlWaEtZTEMwQi8zY2EybkZRNXk4Q2l3SEx6emVCbi9JcTVjcGEr?=
 =?utf-8?B?MllnOExLMnVrL2dnbnVhTmxXSEErM1JMZjNpblRJUkdaR000SUJWNmJQd2dD?=
 =?utf-8?B?MmNRNk42cFF0UVQ2NWwyUG5uZGNrU1dQQWtua0ZWQ2lENGpXZWR4Q3FXTHhF?=
 =?utf-8?B?dW11YzJ1ZnRJY2FaUFNLUDIweG1uWHFrWHpKU2VaRWcvaERwU2k3cWRvYmw2?=
 =?utf-8?B?SEc2Q1FwUi81Mzg0M0hqYUxRa1cxUjF1VkRSdEd1c0NObXBSblpwa3BZUklp?=
 =?utf-8?B?d2EvWDlmQ3NpYnR6azBSYkhlOG9GWit5Z044S2xLaWlERDl2NGlKc2loMzZL?=
 =?utf-8?B?d241REw0clpzQ1hFTHdHTHduSS9BQkxEQ0k1Lzl1Zk1kSHU0a3NjUzJNMk1H?=
 =?utf-8?B?YUU3TlZ4RjFBSXZPMEFIc2ZZdjJKV2ZJMVp3U1RFSzRqM2w0UlRiNzNreFVF?=
 =?utf-8?B?UHFGOTljVlM0MjJMVFNWWEZaeEMwMHNzb1Y3UWt2NVk5Q1B2UjZMTjZON2VJ?=
 =?utf-8?B?RzNkR2xHYnp2NXZlMUZuTVpmS1lMK1NuNWpXY1hEWVdzUWx5b3N6bmZ5ZjV1?=
 =?utf-8?B?SUd1T0tua09icVl3MGRXTExnbi9TNUt4Y0Q1ZG55cW5aUEFpYzh2QlNURWNM?=
 =?utf-8?B?bnBCTk42RUhLWlNxMks1TC9aMngwN2g0QjNxdVREQitja1JOMDFwQzgraVFJ?=
 =?utf-8?B?UWNwdFZkbCtyMnpYYzd0UnJGVDArMk1ZV2RsK0w2SUVXWkdqajlxZkh0RndI?=
 =?utf-8?B?My9QUVdpMG8wbTdWYWVvcU9IVXFTRmdaWVVpOEExdzcxSzN4SmpkYzNSc3BK?=
 =?utf-8?B?bU9adGxtQXAxSSsrZFdmWWNGeUowL3BhYjBLdmpuamZFVWhMNUhxUTFOMlMx?=
 =?utf-8?B?QUtPeUViUVFqZTNwaVpGcWJKdFVCUWkycXM2V2RxM0VWVGFrNXU1a3QyWEtr?=
 =?utf-8?B?ZHg4SHVwT1FFbUZCUmV3SEZ0enRGWWxIR1FqS1hVajVjOVVJcHo3ZFBnc0ph?=
 =?utf-8?B?ZnU1Vm53MjJsZXdPbWtuYWtQQnpqOUx3aHk2Skp4eDIyV0g3dWZCZndvNUd1?=
 =?utf-8?B?YlhxSTFwOUorTDVJYUhFei9NUkU5ZUJqT0hzeVlHN2prOG11YlhFNXcwa3BQ?=
 =?utf-8?Q?Sbx9GYHv3hvg+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG0ySFM0bWZycTZuRkVIRW1pOW1KdUQySTdsT0VyTGt0bEl6eTdiQk9sR3Ev?=
 =?utf-8?B?UVRiZEpNQ2ZvNWdrK0NkL0R6NHUxQm5WVnp0Mm94dnp5WDVJYnh2TkgvVEZB?=
 =?utf-8?B?dVptUWRUeGNSM3BsYW5nc2xUQlBqOUlzM1JjRTdlRmozUTBVNUplMjJ6bE1X?=
 =?utf-8?B?TVBuZkVkSXRJcGw5bTc5emFWd1dzS2VDSjFpZUsrR3gvdVFTL0cvQm00Q1lF?=
 =?utf-8?B?VlNBdzMvKzFJTlpFWC9ERmV5SGFrKzNLMWdkY09FTkhZbnNtQ0MrR1l6U0Nh?=
 =?utf-8?B?clA2cjdpRmlBZTh3NTZuc1dMRUxMQ3gzblg5N2EyY0t2MnZ4UDlsUWJOay93?=
 =?utf-8?B?VmtJMWVvV0JFcG9EVkFSc056Y3JRMmlQajN2VmFRM1hITll5UG0zc0V0QVlx?=
 =?utf-8?B?djBFR2lHQlphR0tTTlM2SjExRkd0WnZ5RkZab3NoTmd0RDhhV1I0dDdEdHhQ?=
 =?utf-8?B?ZmJrZjJFWHpHNkNTejUzWXM1TTFlQnNSNTl3SUhmUlNQeDl3Si8zaGhOUFZt?=
 =?utf-8?B?YWRZZmFYMWNxMFA0Y1EzUU5HdElMV1EvaFVjbXZhbEpiL0s4d2dweWR0TXNl?=
 =?utf-8?B?OXgxQjYyc1FjWjhDeEhYbTFiN2twd1BpRUE5WkZnSkw1YVpYbXk5d1FnSTJi?=
 =?utf-8?B?VHhzOWNxdmYyaG5HOEdxVU0wTHcwelVJUDdvZ1NTSXFKY04yR2ZOZkdzNXBS?=
 =?utf-8?B?eDRhaitPdXdoYU9HRXpnalJ2S0JXZ1A3QjBzNjFmblN6cExITEY2eERET0NS?=
 =?utf-8?B?ckp6NjE5bkNVSC9WWmRZUGgwdTZ1RjRPRGRhemEvcmFqbkMvbmoycFdPUUdN?=
 =?utf-8?B?QlR2RlgrMVkzYjNDZTB3ODRoOTlDTXdGbkdDQWVDZVRnVVNKOFY2YWs4WXZM?=
 =?utf-8?B?RkVDb3VSZ3U1ZHFOamFUOEQ2dDJYaC9kRlhpYlAwc3NGbGhqK0lGSmg0R1ZM?=
 =?utf-8?B?U0xCc0Q5N0wzYXdQYm42dVVvSExaYlVTSEZtVk1LMi9KWkpYeXNzaVdVVzlv?=
 =?utf-8?B?eThjUTVvT1Z2VzFDcUlLT2RYWHNQeTY2R0hoTyt0MU5qbmdlajJQclZHMGlV?=
 =?utf-8?B?ZkQvYjdTQ0NPRzB1T1lQVFdVM1R6V0Q4N0JTYnJaVXlBeHpubkVlcFRKclpo?=
 =?utf-8?B?eW52NWIxd2VFTnYrdWQ1S0ZQeTU2WnZyZy9GY2RiUGZZVXJEVno3Yll0QytF?=
 =?utf-8?B?TmkvdDNNcWVCL1pNVHJpK0RSSzVJKzg4ZzRQeHdqZjB6akdPMXpOYnVuTXBZ?=
 =?utf-8?B?elcwWUVwMXdSamlmSlBUTS80ZjNjdFhRTkJpWVdiWVF3cnZtMlh5UDQ5VFYy?=
 =?utf-8?B?VWJsd3JuWWliUzBZYThFMVliZEM4S1FVWUN1NGZJRVYwVmREeDAwVTA5dkJY?=
 =?utf-8?B?WlZsWlU4eWNKVEJGTC94b0JWNHExa2lyTkFVY29wT3ZTVWNMUUptY005M2VM?=
 =?utf-8?B?YjhqSjlSdzZYZ1lOcklwNjBJTGgzb0ZiQlYwenJ6WElXajhRZ053YVh2VjlR?=
 =?utf-8?B?d3E2MTZENDlaZ3Vtb2wxSHRmZzNHV21UQk9sdmkxbW9DVW0veS85NFhGNWNn?=
 =?utf-8?B?WE5LV2NZRm94d0NSZTlvaTNqbWZKUlp4Qi96WE1ZWmo2aUZZY3BOMlhmWGVo?=
 =?utf-8?B?UFNSM1dJMlJzUnJUQ0lQRVZIb0RRank4aktCblVNYjBBK1V4VmFMZ2JReEZI?=
 =?utf-8?B?Z2xhSkVjSzFpNVd4VDg5RVV2SUNraGJ0MENsLzZoaURLMmV4ZnE4VlN0dEFK?=
 =?utf-8?B?dFJ2OHg0VFpyZDdvNS8vem1YN3MxbnhOVDBHUjJDL09uNEhnYlN2QVRmdUVm?=
 =?utf-8?B?VWwxeUxLREREdzZDdHFlNEN4WmNFMmVpTG55ZlFvaVJNMzZHME1Yc1ZGQ1A2?=
 =?utf-8?B?RXM1UEpjNGVTMGlBTDlYdWZ1SFJBUzA0SGtwNElDd0dMOUhnS002UTVyRnln?=
 =?utf-8?B?TDg2OXFRZnQwTi9tMU5UbmkrMUpWUWQ4NWJLY24wSnExdmxLd2puQnBQaHVi?=
 =?utf-8?B?T0k3S0VGTlRzSVI0Z1hBQVIzajFLTThxRWprWGltT0NTMWlCeVdTQkZ6ZjNa?=
 =?utf-8?B?Q21QdVFUcWFKWXdVVEM3K2t6NXVQS1JBQkc1N3Q1TlZDeElKQ3BHSG5NOEp4?=
 =?utf-8?B?ZWVOaDBqSWEzbWNUdDdLaEEvcHZJZWVrdmdFUzVvS3pMbjIyQStoK2xHT09v?=
 =?utf-8?Q?E+ZFk8Eb0z92LeSilqABn1I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X4YNXeTFBe6YPSkYvP8UORlhDcbb+QuAclAKYPQ73Sj2liH+lNIX9HndOPQgF/pambl2btG1tbDiUBfbKtJADvUTfKPIm5qYNG/IvYWu3aSrtAXfJl+C2DDi9YMgZKt1vHFs6oJvQb3YKiRxze6686ipr7JIrYOB7Sf4NxIU27YMlb6jVK4I90k3XBZDKIn2eELa+BKbyAIJOVApmckvF6vyRpQTVUTaAAmvWiIAoXAUtH3+oCpn7FDCXWlSBziybKXVj+//ByQ+L+lgsL30eZSSBgaWNm+EjWzTDM43d5dAygQ0UZsM3Uko84A2KyRWoOGVZc9O41gBG/+7AWEaoGlKoVV35NHsQNTyxDAWnhms5FIK43qBu79de0C/6WjSgBdXjhOoWoQhP8C8lgDHobWEAwgVkRFnqH10LRhkvggNWI3xLU188BrhzN3gALTiGxugkx6NJaud/+B3TEfeVn/C3n0I7TbbjKHOpHhP2cINoCGILCowzJ/E/QKCokuqMuJg9V9yM6tZxSNv/NT3zsrn57G2C6e9SCC6UpSi4H8gx4Lh2goHSvg6wmE2irBpitg86DAMeAVznMT/9zP4nv1pmIRNBzWoozBcPTz2HIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7109376-1697-4680-7c50-08dd2f3c4ce0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 16:56:59.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eq9iC7K3Bsk21/Ry3RmfJ6xE63tgXsr33v4kILwH6But6YLze/R2t7Vrx2SHeduBTzrHtnHg+NnG9OSfQ32vYuO0z/kfjEmC6LIjcYD8ANO39D+IuGh6Ip/GdHyN46wY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7339
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-07_04,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501070141
X-Proofpoint-ORIG-GUID: R6NQ_o6s7YxUoLVBehA6oQD_NznN-w9d
X-Proofpoint-GUID: R6NQ_o6s7YxUoLVBehA6oQD_NznN-w9d

Hi Greg,

On 06/01/25 20:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
