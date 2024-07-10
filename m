Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1936019049A
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720610940; cv=fail; b=ZH44/6AD4kYhROBdtfNR97sIiHz/HMIW5V+QPesN/4lwl/9sCUWj+25K1WdNJ4zMjVqAUQTiZoe7z9pZxNaEgn5QAu0KguATAusSRWZPkjdBbTo/O0XfH6LK6WAYvu+YByX0dpEpCJJZAScH9WmE3FZuGLeDZwGo8cqIp7KKho4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720610940; c=relaxed/simple;
	bh=n5HddXwpqEDhkzrasyDqMZadj+zGE2gIeqH76f4Qq+E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Re707sZzo8u+p3hwQEtRYPTBYETL4CFq+S244LcAcFEYPRRVcfDPYy3RvUR45Xy2dvrGDuDx1pjaNN1vxj1bdq+xHg6ewxn/6kpN5xMWTR7/wyAoF+kgSxIEVAMmKfo4acrLMWFZWP/wgA+i7/YORS/gy8i2nD50tDETEfXQy0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=njB5wO8R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pxm4hdd/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="njB5wO8R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pxm4hdd/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A7fTvu017510;
	Wed, 10 Jul 2024 11:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=oiLZokLGBn6vEqdFjHfk7CCTuXoBuiQHv0KOhTWAoJs=; b=
	njB5wO8R9SZgujTojm1lR+WsAP76Ntko+2TpXyEWv3Q2e8VfnDJ21Ax4tU5Xy/no
	B7BHX+eDcVqcSFWEI/Wro96U5yllJc8rguNb63XUeZ/kgguDk95nFlqqWjFu4My4
	nDr7A0F+CB+DYwqRmm4U+HTxFBbjeuFFz8forrQaaSsUjK6Bn96zbZemdc90WyP5
	EXukggCTIa+gJlYBNDL2ZByx3DVLNdX9bQSetGtG7bsX4eY9ULLNVdirIOTDWI8X
	GZ/HFJsG5EBTBhnVBSfSH1gOPhU+354IxRBdOS6xG0b2bcWXwReSa5Aa5TWfVJ6q
	+dQ+d4/bVGV2tz1YveKeXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wybq4m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 11:28:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AAdKJ6037162;
	Wed, 10 Jul 2024 11:28:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 407tv2t79a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 11:28:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vp0KBwFwvpzEfunmWwFksojjIHYiW67jPK7dJ8xjXevCeYPcxUkdp0b/+f6tLxWBQAhIg74opz5SoSvV9H3zls+URD0cSRnbwgKBK43rnLNMq6aQyGVqF42DnpnUTq/JbCEA6UbnJ649zrDs3rfF5sg975kVDjXNm+/SCdR7+M1ddyY5yTUM2uhJ7YfWJqw8ysjiuRxad/Jl/tFAQMl96eSYDQy+soe4UtMThg8//ShsCX5aM/fcuu/iJ+EJkqnF4KjUnUXG7bUbKZFH2AZcYQDX//m0YuMwt3lRy9j8fF4lCstgei8xqXwbIOrvQXj/dpHbxo14SJowkpEimMeoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiLZokLGBn6vEqdFjHfk7CCTuXoBuiQHv0KOhTWAoJs=;
 b=gLGjy5Era2OlCR7blyYlTBqJt19/sk5q//7E+s1MYlOQM7tAD8308vUUxeW9EHG3hooJ37gdW++ahke+K43vts5Rnl1AaATWzor0j0mwzIq08ymOjTb3yDFcH0A+bWX3JsqIsNhsOyvG2vjbWaL8gB3VIjWoOeAYEGMg5uk2XMIuNn4RdQlVsFcl2Idya3RyWrMwfpbKDp27UGLL4+kf3yhCoqJE0gyZKtAAIAny/oiXV00wBGZ5hYNbkdhsBkFJkJgc1ShmrhdjdO+fIXZietv1d//C5dTuKkxTxwAppRgp/PO67F4VouvXuafhjbvXkWOoYOwA1bW5t8xFBi4qgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiLZokLGBn6vEqdFjHfk7CCTuXoBuiQHv0KOhTWAoJs=;
 b=pxm4hdd/73sHsJ6S+/oUEqNjkiHOS83nDY9JS6CtxJOYxzoYiEmTrFP3NRQjls6mXhteqhsVYOXXVQOz9LCx9RSl/rjKuq3YRmx0KdW3CsCsx8VV/L8kcwtLpEwRXy7XXwt+DsmryrGp94Cvp3yny8E0xXYl6MTPar8LdsjYnBM=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 11:28:24 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 11:28:24 +0000
Message-ID: <4debc9fd-32d4-42d7-bede-ecbb030695b3@oracle.com>
Date: Wed, 10 Jul 2024 16:58:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240709110658.146853929@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MN2PR10MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3b5b9d-1709-4822-fb7e-08dca0d36915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ZUVhMDJKeHlDVmNTMm9iVFlFc21idVA4Vy9qTzkvR3hVWDZ6Y0Q4eW5nTkVC?=
 =?utf-8?B?K1F5RGZ3VXU0ZFRWUzZnL2pOYUZrcUQwZFNHNjFNeGxSOTNnU3g2WFV3Wnh3?=
 =?utf-8?B?QVJ2cDdXUzE4bUlVRlZEY0ZOWW9jM1pkcEk4bUU2K2E3ZzMyV2JWS3VMNmVR?=
 =?utf-8?B?Mll2S2tIN3RQazIrb2hPU0xwWFpxK0kvSkRvTzdORmdwei8xcnh1SVgzc1B4?=
 =?utf-8?B?NmZLQ1VBaXFVQTVTVUpNZnRhTG0wQVpZUkViQit2T1F2MjhuY2huUU5hRlNu?=
 =?utf-8?B?TXY1RWtRblFTK3FpZmNpUm1jckxpRGM2a2YxbjNndkFYN2ZIa3FjeHJTZWt4?=
 =?utf-8?B?UWwxa1RQSTVBVURLK050TGthajdhVk5nREJXMjcvWHUxdEhkdnpoT3UvS0s2?=
 =?utf-8?B?bE5kbHhNQ3JibjVkdDBsMGMzdHBSTC9rMVdGZDFnZTYzQTRvR3RRVFk3VVFN?=
 =?utf-8?B?VnlHV2lSdzlxeVdGSlltSTRsZEQwVjJLWnNTL3lsbERNOUpWajBwaUtwWEc5?=
 =?utf-8?B?RGRNYnlKdUpocFdPRmlYSmtmWU5LTStZYldMamkxUmY5M2IzUThmNWVlZ1hv?=
 =?utf-8?B?R3dSOUI0ck51ZjFzV0p0VWVaYW5XRXpJd0RrOEl6aEpTMVdWM3NUQ1lzSThj?=
 =?utf-8?B?NTBmdzlvVmU5dDRuSkdzZlltNDgySGI5NUd4K1dYYks2QW11L1p1UDJnbVV0?=
 =?utf-8?B?blpISFJ2cEl0S2o2QWVXNUFtTlY3Zm42UzJQd29yc2FiS1Bjb3NCckRoRTYv?=
 =?utf-8?B?eWhIZUxucWNnakg4aGZ3THFhVW1pcHUreklLbHJGdHBBdzVsaVgrRGJ3WHAv?=
 =?utf-8?B?QjZieFErNzZhMVRZalhsdzdmN01CcnpyTE5tSjYvdlViSGtoM3ZxM0JTVmhN?=
 =?utf-8?B?cmZ6V3VvUzFGVnVEaXM4bXRkN2x1S2lRb1lRK205aC9VR3QyeDdHbzgyWEhD?=
 =?utf-8?B?NW0vMVAyK01KQUJYa2VBS1o1V2s2ZnRDSWpxdjJNeG5DUE5RRmxJYXplWlBW?=
 =?utf-8?B?ZHBwbVlaUSs3WVFvN2lrZ2dCT2FBTkIwbGJPNmg1SnpDNVZ2YnlaTzllSjN1?=
 =?utf-8?B?bzYzb0YxbG5zQzcwV1c2K0M4THB4SXJPWi9wNGEwdXJuT3U0QU5VQ1F1aXdJ?=
 =?utf-8?B?WW1OYzlUL01GTmlXQWNRNlcxWUYwVytRZWY3WndicVhuV0owQmNNbmowN3RT?=
 =?utf-8?B?b2wzK0EyRk0rNm1zQWZLcHp2dzBEVDc4V0V1RXJ5enZBTU9FVmRzUGxzajhm?=
 =?utf-8?B?Y0tZMnlxb0hHNElHVVpwbjBQNzdkU3NoNTZVNDNaVkFiUkQwQW5tRXpoRVp5?=
 =?utf-8?B?dUhCSXZ5amR3U0NVUE5GM1pER09sK0h6eFUwbVJCenV3MGhkQ0U1RU1hUnlZ?=
 =?utf-8?B?Tjg4RkdlR21UZDY3RWpsYmpGeGNQVmNkNnJtMk1mc2hTOVNIWDlSQnZVdHVl?=
 =?utf-8?B?V29ySm44c2ltdXZkUVlNRzJ2NWtFalhEclUxQ05rYTY2ZHA3MDlrdlZZc2FY?=
 =?utf-8?B?WHlSMzBBR0w2ZEF2Z21BakpINHRGcWt0NTlFK0FidUNVbUVEZTdad0xwaEpO?=
 =?utf-8?B?YXJYSDRMeVJHWGdsYkJXcThhM0w2SjVsQVF5dDNCdnpVTzBwTytYejFzNFZr?=
 =?utf-8?B?YlNGWlo1VDliamhmbXR2NGlBZEdVSWljTGZEb3hISTN6SEdWZThNSTR6QmE3?=
 =?utf-8?B?NVlPNXF1a25qZm9RYld5L3c2R2c1RkV3QkNiUUN0UHFPVFl6d0hFWmZqK1hy?=
 =?utf-8?Q?Q5GXSkyWdokf0b6doQ=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cGgvVUptMXU2SzRYY1F2MnRtYUJPeXhjOFlZRjdocHZ4VGtQb2JrU3Z3cU9o?=
 =?utf-8?B?eGdtdDA3a21RZVlKTEU0OEpBM1E1UEpCQXBjZkdhUHFUQzZGbVd1VHJHRUZN?=
 =?utf-8?B?ZVJnaFBIK2tCUmV3WWpmbzg0UGx2bEhmYk44K2NkUElRbG8yRDNDZ0Zod1NP?=
 =?utf-8?B?ZlZKREZob3drcHpNdWlHSFpyS29aaUVsblZ6MEpGc0VueWtZSnBMQjJWOXJi?=
 =?utf-8?B?bU5NWlM1MTFHdWtwSnNXeFNGWnJmWlkxYXA0ZTJHUXdFejJYU1pia2t3dVVD?=
 =?utf-8?B?R2JWYmFZMlFiTWJrZUlFbXpPLzNDbHl1TURoeU9JZHFNREtaNkVBMzVPTHhi?=
 =?utf-8?B?OFVkaFJ0SE5YTlpJMjNEUHpKZ3FlUk9tbHBmZFNUY3g4S3Zoc3Z5NUtxR3Zq?=
 =?utf-8?B?amlXTXNjWHc3U3ZacXBaUHlPQ1NIaWpNcDFmZmJ3RzZlN3E5aXFWZUcva3Bq?=
 =?utf-8?B?LzF6MWd2RmUxb1UzMHduaFZQYk5zbGpKU2RxVEQwSjd1djc5UmNZQlhYOUp6?=
 =?utf-8?B?UEsvTEdoUExNdVRkclAyZzRPbHFNbFNNL0lpTXd2UDVQSStzc2VCYVJSMTBD?=
 =?utf-8?B?UXh5RzFvbkhxZVJmSFducFluYkNEZ3F6emc5eFNkYm1xc0pkeUp0cy9aM0wv?=
 =?utf-8?B?OVRaTzU0OEpaeklWbmhVcmZpSlVJM1BQYUlXalA4SmlraUtkNDlDTEpFd29z?=
 =?utf-8?B?STZLRW52S0RxUnpGYmRmY050WVI3RlJ4Wi9nbTNLVk8zK1BjbC9nR2FUanhN?=
 =?utf-8?B?N0Z1YnFsd3dqUDd2T2owdUJVVmtBbGpuNlNrSFZvdHRWSUQ1ZnhWcGVoYjdp?=
 =?utf-8?B?Y2x1OGhRUFBlaE5OYzJDeVRxTFUzbS9HUUQ4MkxRV09XWmxXTVlTdHhLQ1hy?=
 =?utf-8?B?WHlZcVZkWE52ZStmS2NtbTVDYjVLVC9xYmpUSmp3Q0p3MHF3UGNoOGkzR1FB?=
 =?utf-8?B?V3cwaWlia25MYjV2cUtObzlUcG44Wi9OWDd3bloxZU84WE52WUtuWjM2dE9o?=
 =?utf-8?B?YTZMUEZMNEdSY3RMa3hQdVJzV3dtVHRUNnlKSTVPV3Q0MWg0OXpNOUVpcS9w?=
 =?utf-8?B?Q1pxVlNTd2dyV0s2ditibVZLZEUzM2NpcW5RVkFFVGJjVnhKbnBkMzRkVXBr?=
 =?utf-8?B?bktTUDRWWlpreXpnZGZBZjdlcG5NaGo0N0N4dEFXT3Fhc2pmSldlV2xQQm8w?=
 =?utf-8?B?bnVHNXU5MGZtZ1VldkhwZGFMdGVmMERFZWlaem1hdk1CNUdMRkZBTEhlUXp3?=
 =?utf-8?B?N00rZGRkbWhYRUhucmtySEFrdjE5ajVEMzhnOFdhSUxwN2l6Q0IwV0ZycnNk?=
 =?utf-8?B?ZXNlMUxpNjVkRVYwVGJWcndiZGRINFF0bXhVODhEMmJqK3h2cUxobk4yemtH?=
 =?utf-8?B?SzN6djhleHh5RU1LYVFCMVEyRFBIVHhqVVo1dWFkQ2NXNG9xdC9QZ1NTV21U?=
 =?utf-8?B?Z0RvM3hzOGwvRVI4bmtnM0NOL2hjVDVON3FIVVpiMlpMQTV5QWU4clRjdjR2?=
 =?utf-8?B?elJ5VHZoR1pDY01GeG9MdWRhcTEvOW1adW9nanlmcHk1KzY5cFFMWlc0YUdQ?=
 =?utf-8?B?NUk3VnpQbkdsN1FOSW82YUtjN1ZkakxoTVpZMjBNQlJtZzZZZGpicFFCVzY4?=
 =?utf-8?B?di9ZSEdDTkI5NThENmZOb3YvcGZsajJacmRPeWlHV0lJWUpFTWtEaERMb1gy?=
 =?utf-8?B?a2owaENsZStIcTNUQkNGV1FMN2hXVjF2U3lMaVRXSFVsZlExbmJXUnhKTThB?=
 =?utf-8?B?blpORHNsOTZhYnJtaGhsMllIdmFDamdCRWZtNHZtVXpZTlg0amlUVW5FcC81?=
 =?utf-8?B?Wkw5dWozdVFqL1VzVmRsN01ISEE2R3crRnhFSTgxa1JLTmtOQWdLOUxrWjdY?=
 =?utf-8?B?eWFkZXpOVlRsVXFUaVNYamxlSVBQb0dabG5haHFhMVIxUjA1UXVqNWJxU0pM?=
 =?utf-8?B?ME1OcGJHdTVoTmNMNjZJWkdsL2Z0NFRkYW5EL0JZQm9WakxRMG9pR1hGclhr?=
 =?utf-8?B?MHQyQXpBL1dTNTRWdVZJWXkxZ1Nidm5yVTF3bWJ4bk9mbFY4MEIrd1FGdFRw?=
 =?utf-8?B?U0FKdUtualFSdDViMnoyb2JQUXgrOHhWY1NFR3NPVUQ3TlZwUHZQdjMwVXho?=
 =?utf-8?B?NjFFNVJaUDFySWhoMEoxR09MQll1M1RnVFhJKzZVYk54TXQ3cGtrRDIrUytv?=
 =?utf-8?Q?nKwQG5pHoujuCr93mc690EY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Bfs2NkkheBF3V1rkZ2c/9ZZR20FnymfFL8RTHGjxib69pXtMgcgMiYFhbb9FJwx7VuulGgt9WTszrIWW+kySnbtISyHZtNv/u8Cf/U8FH/hgj+eTbsTWdPJvwcGyIMMd2Veb6q/YbQwAJ6hEJnO8D6zSzoC+gKbRM7UEkuil/SzO8eWoiJhS1ebL+L8XlH1ZaK8ELJE/385x0OpbdEqMrPWMSVj6mOneuGMXxoeMEhwKTflaq/djuD0EeeMDhA0jySBTZZ8eLZRCNQ2/Z5C3vijVUJKOIjuKYOeJ7Qt5LNja3odtdi18t/7cCJLyU2ILBORwwcgu8+i6zntpTNknVQGhWxpIUuzO/+DFV4ccGKjtnwe2ZJhcI7Im6iKE6Iokwp5JCdDPC10hDGt0fuuAPV2fh2tkVI1CWVJwKzWJuu/cNslaSxrkF53wc/ff2dF4XaALBxpVB4FzsLhfcrhqcCCyFV3sdfve2EygEjlYKOHjAz+rs4WirAqGJgK/D+DgOSeg1b0KgSeslptj2/eeChLXG9/2aQcz/u0xmMZkVABgzrUs6jU4487JgsUsdnQ0QffiPuyVHorwx53DXrhewZsJiiiikXIsE7nZ3NUAvyM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3b5b9d-1709-4822-fb7e-08dca0d36915
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 11:28:24.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okRHeYs8JAUDTiBYnGNwkpCjpQahzAT79C/E3r/q5J7ivpyJ+tWEOovvYoK5z/qIYXa6IvaW+dtv65f6iYvnP7+dwJZLDonXyFRxRqoU/npYzX6hLmqYrRDrBaXJjIIR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_06,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100079
X-Proofpoint-GUID: WdkHgQnugT_sjwSk1A1CdjzZAFz7uzIx
X-Proofpoint-ORIG-GUID: WdkHgQnugT_sjwSk1A1CdjzZAFz7uzIx

Hi Greg,

On 09/07/24 16:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
