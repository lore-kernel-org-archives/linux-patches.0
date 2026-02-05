Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA5B2E03EA
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770287445; cv=fail; b=ZmsAcXTRIyd+LwI0yvv9eB1AgEpgQxQWc2qAhdhJA0g9U22/+kDAtZzYWQyWPP0Pf31VnqD+ZqufanAZaSdBNE6O3ltlixEA1446foEaTFDzyoWNk639N1S7WdoG7bUsNtwDeXbIygbs0vIaGjF897Nhz79N9TvToGhTpl9WSQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770287445; c=relaxed/simple;
	bh=tXl7R5X2QAwmmZlfV03wcZhzd9XUqF11YgrT5a5FAkk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A6u0rCeN0wUhSFkZ6KLo0VcAg+Ye0sIzn1sseIzsZCna+xcgh51cKzbUzERlCZKdpoZEobaw+WmQNY4ClgcPvpxlxaErhG5ZMRm9VsSuPysih61z8jpjoKdSwYxpn5e7rzdNHGki+Gsa8fa/8uqBqztX8HV1KJ059cs2LiPZ97Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YEKKyXEU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RJ3zCjxc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YEKKyXEU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RJ3zCjxc"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614N0Exw2453214;
	Thu, 5 Feb 2026 10:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Y44EJSw+0hRuePZji/lCM3DGOAiaN2Q1Fm2g3F/3MDg=; b=
	YEKKyXEUdI8s4271PyfZx6gGwRghYMlPB5r1UYQmCujOKiSZ6XRjIpM0Y8ckBkH3
	0pyTbtDdddQyakB7ZmD2cu/24s+cyzb7MnmBWRexVatc9x0ee6EhA2uwDUR8opP1
	D+2PlprgXOilPk49taphzTrMn38ZTq7bg/+VcIkEJPFFSSw09HlzYlsroAebSurY
	VO55qHsQpX6cILpNls4jAPrw3HxFWY1zNWPGVn/JOXQsjo2TP2pMdvQbebP9B2h1
	Z3+r3Vir12OZWe3VUVpwmUm+/R5ggzkwvFX+HZ/5OPTwqfPBjmB8mGusPwaNftaN
	Aq4r7PiyEQTMMHHd9fiC3Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1au67ghk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 10:30:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6159Fg53034787;
	Thu, 5 Feb 2026 10:30:20 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186cxcf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 10:30:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fmjl5nMf0/c9U7MZ6SQXb6tluLb7bYQ96ft9lnArAaTolITTjOi0rPFnaKPoUk72iBkHjRRydlUYGxjbaEtykBoZxiYS2MFBU0BKRWArxzDqEHLSJ2i3WUyXziV9nBNqFkQaHc1psIlG5dJtC82diWO2HlGRw3+v/dlvjQlj0cOFqcb2B+5Q8FDLwkOc+6s2w3x0pim7GpUYIKyl5C/6wmA32TDnhVpRjns7toBo8QXv6m1lWwifNRUuh/a4nGrTytj5HVXk9qrX/mKTVuh32lLZ4E9pNlZF4cNdqwgTCvTkzCv4pya8cTEyy02ImiAvKXgJnNQDZFcrd2BEc/BuKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y44EJSw+0hRuePZji/lCM3DGOAiaN2Q1Fm2g3F/3MDg=;
 b=eyXHmKgVScmWUzEkLIk/u6UDRq/DKDnhjMH5MupIaHg2TdqnreDrgYxIb7Npv/UKWvCs5qTcQn945cpy7GXRVtEM1X/MpsSBKuevEWy+d+ZrcVHhBnto9naBeLmrgxzoHdgzUyXeapuRfVIEe0wxMhc8oz+ecj8V7EjpFpvkQQ61mMGtmVbK2LAK+3kXYLzmQ4B+g1ai5plEM361g4Aac5Oq28jltQ68ZEpV9C8ZpAwbS6EtxW9V8NqrBVN2AlAk+vKq8eHdUp6+NtbhrS61ANGbLaHzpH96ZEKpTcl1o49kjhHKASd7N8wfKGwU+UTgNDWFQZ80heEGmwZOvRQUsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y44EJSw+0hRuePZji/lCM3DGOAiaN2Q1Fm2g3F/3MDg=;
 b=RJ3zCjxcmu9XIzG1q7rU5P8OpfhDJqkNeN7P0dRBHey7d/3dHdfGUwpNvPzZizh+FnY0VthgmjRpDkrJooUJUwkxTP6XJK+oGwpt8THxWLk3m2rPx3Q2czlKdz/mgUZnhpO9HQhL13v9s0oA0GOuciH+0NhupFqbtjumBaxP9iM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH7PR10MB7801.namprd10.prod.outlook.com (2603:10b6:510:308::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Thu, 5 Feb
 2026 10:30:17 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 10:30:17 +0000
Message-ID: <5d49fe0e-730e-4b84-b0ea-e91e33c4c0b3@oracle.com>
Date: Thu, 5 Feb 2026 16:00:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260204143846.906385641@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0555.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::8) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH7PR10MB7801:EE_
X-MS-Office365-Filtering-Correlation-Id: 640ab6e8-99f3-49a9-2f74-08de64a18e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1hnTUI3RTdCUXNiQTZDd2tvQTF2OFgrSDhTM0xMa3AvaUxNZHAyQ3VJYjJu?=
 =?utf-8?B?NEVqRnlaUmN1UlZVTVhLY1Z4V1hTSG9QK0M0QlhWTUNSbUtRV0dKNm9FYWJT?=
 =?utf-8?B?SVY3K0VrTUFVd1VuMU5BM1Q4Y2srTGlxOWxWMlpsU3RCb1h2bTdUb1NNNXlW?=
 =?utf-8?B?dUsvUzIvV3NveVJJcjVPSTdzRnpSbUxyOTJBZnhVdGlqV0k0YUUzZ1ZHOE5o?=
 =?utf-8?B?UUlvdVZ5Z2ZQak93WVAzSXVkWnQ1TVluSTZ1VEhqemVVaEpsZk4wd3ROUGVl?=
 =?utf-8?B?aHFXQTIrdFlLOTNlc2NOT0VVNFAzUnQ2RHJiRTErUWdaL0VUV3g3SlI4TTV0?=
 =?utf-8?B?YjZHR2c1ajJiaU1HUHF5TjJHempoNkIxbFV1RDBhcUEwQzVETy9WVUFjcjRl?=
 =?utf-8?B?ejFWM2Y2KzFiNWplWVdJbldtY2JPRitxOTlYbTFmVXhBS3Y4VVQyVDU4a0po?=
 =?utf-8?B?dE9IY3owdERIcGZPOGtNREVmWHF5Y2FpaXlaemM4a1lLcGttcmcyNDJkKzdO?=
 =?utf-8?B?Ni9YT3ZZTmlDR3BPbWpwUmxSYk9oaDljazFRKzFFMU9adGphVFBPZStZWnVt?=
 =?utf-8?B?bUxGMnAwcXZ1TmtNbWUzK2k4eDNrV1RyeXA3RnNvYUhhTHdYR3VTYWVLL3BX?=
 =?utf-8?B?T3hXMUpnRDlFT1IzYzBQL2JqNEpQL2VuNXQ2OStZaU5pdGFwQmNMQk43VUZn?=
 =?utf-8?B?TEdaRFJYbE8xekdWNlI2TnpLbjlVOXphcWh2ZGQ2cnlhbnFDaDd5d2NUODhs?=
 =?utf-8?B?eGV0dGVkOUhoRDBvY3gwVHYwcUkvdnFzQmV5Tmh6KzJzaGR4WTZxeWlrMWlv?=
 =?utf-8?B?L0ZBbFVJRVBobzR4RUx1aHlqeDRxbjd3ZVdmWjNOMDZOWmZIRGNFMmNiSTMy?=
 =?utf-8?B?cXFOWDVOS2RXVHhhMGVtLzFPN29nd1l1NGdaelkvZHZEazMzR05XK2VxclZi?=
 =?utf-8?B?REJEWEJSTTQxMWpyQVZlRnlqUnJjS0x2NXR1aDNXdWNyKyt5aEZSQzFNTlgr?=
 =?utf-8?B?OTk3eWxYRW4vMWZmQjZoMzdzS0drOUtJbnBRV1cwbmc0eWpzWTBsbWFrelBD?=
 =?utf-8?B?YVZ4T0lmOXFwaWNMTjduTWdGUFVOdDBPcFA1bmJpTUY0Q2QxVWRYN0QwTnpW?=
 =?utf-8?B?OWJUQTNkSkRtVjljT0dlZ0N6Q3U2dTlwZTRLTTVWNkdvNk9veWpBbXBYK29m?=
 =?utf-8?B?T2xYYUY5UERBTllHTnRaMWdZcUV0QmhtMlNRTEUrMHFESmRMTDV3eFlLOGhm?=
 =?utf-8?B?ZWdYVWRsaTZUbW5mak9odWlGS1ZjdjYrSmUwOG9PcEc5cjZmZXNRWTQ1VFRn?=
 =?utf-8?B?WExmTjQrOHhUNFZFc21iUkQ5Q21NdURwR1RvdklUWEtXdEN0VU5ndkFFL0k1?=
 =?utf-8?B?NHN3c25kZjRtZTBSbVU2a0VxdlBYdEttYW5tK2RjL0lyM05Yc1l5M0NaOHVu?=
 =?utf-8?B?QytERFlRVk1qTWxXbDlmU1ZGNXRLU1FRZmFVMHpuLzQxK240SlFMVVZKUjRL?=
 =?utf-8?B?Q3dqNXBCaytKZkxIZjVYREFtSHdxMWtOMjMrMzczOEZyWHBnRXZ0b01jS2Qv?=
 =?utf-8?B?UWQrd2tWLzRJcy9DRHRLbUliOVZHdG1aT2dPTDZ5eStWbmdHQjdhbHBXYVJ2?=
 =?utf-8?B?emRwZlp1aTBOd05WY3p6aVRXSHNZTjNXKzRHTXZWWi9qRWJNaVZ6d2ZIMCsv?=
 =?utf-8?B?QXMvTHpRQTB5djBjM05ubXBRL2ZqNjIxb0U0bHdKeVoramY5OWUzMVkrcFk4?=
 =?utf-8?B?T25CbmZpQUpqdGRnOUMycnVNYkcvR2ZoZzRucXZKemJUMHNIY3Y1OHZuVE91?=
 =?utf-8?B?V3l1bDh4RlIvcE91S0pBTEdvRHYxWUxDVWMzc2l2UDFTdzRqY1BHczd0VzBm?=
 =?utf-8?B?Vk5nejRHaGgxemNFN1VMRWJFS0lKeDlIdUdFMG8rOEZCaGMya1FKWm1pS1RG?=
 =?utf-8?B?dWk2UGt5VG9PbXhSZCsvZExpaTlEQjZ0RDZORnhsYURDWU8rdURqS0t0c3ZN?=
 =?utf-8?B?bWMrTnpYczZveTR1T1lqRGVkRFV5ai9GUm5wRzVjZ1k3QzBwZDBtdFhNeEgr?=
 =?utf-8?B?NWN3VDhxTDZ3MVNpZXFqKzZXN0pONDE1a2xGU1ArcHByMU5nZmtTWHRaUkh2?=
 =?utf-8?Q?aoLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clQ5YXVWek83UkYra3IrSENpem1aNm5QeFNGdDBLVmpzUFZUbmo4Q09hTzFZ?=
 =?utf-8?B?MGl5YnhHSDJkNzQ0M3JkaU90dytOaGF5VFRCcVFTbWRmL0F5NkxiTlpyTDR6?=
 =?utf-8?B?R0JvMFJYc1llN1V2b3lQTkh5dHA0ZzVRSVZ0V0YvUjQyaExOUzFZQ3JrSk9D?=
 =?utf-8?B?ak5RL3d0bDdycFc0OURXZnRFeUJFdFRqVml0ajdDbG41UnpLWDhtc3JQd0Ri?=
 =?utf-8?B?bzB4Vm8vWnd5ck5GK0orK2VlVmgrMHdMV3I2azBBaXAvRDNyVWNYNG9DR3NY?=
 =?utf-8?B?b3dPb1JWN2VLL1hYYXRRVVZWb3crQkZOYkVXWDQ2aTVoRzVZT3lkUHdiOG5h?=
 =?utf-8?B?dC90NlhlUEFKdmxjNk1MaWNzWVREMUpNWDVtNE1VMGp2QTlMVHNheXpjSEZi?=
 =?utf-8?B?UnhXTUpWYTlxMGJUYUlXcmRwd1BISm9XelQ1RDZHME0rdmJ3NlZ4SXZSQ3dW?=
 =?utf-8?B?VkVIeUxTTlgyR29KWHpBNFNSdWx3MDBjbDBjTXdQQkxyNGJVaXMyc0w2M0oy?=
 =?utf-8?B?akFqWTlDeDIxbEdFdEVzV3pPZVNnMFQ2bzB5dzRONi9hNTZ2ejZXUitTUVJP?=
 =?utf-8?B?U1EvVnRaekhiQUFHYk1qc3kzTk9jb2lhejBObVdXQzZScmpLdnpzVE1WUEFv?=
 =?utf-8?B?SlBzVWw3RTB0ay9hTHYyeUd0U2orYk1ITlhjZ3llSTRtR2QxaXZmYTlWVXV6?=
 =?utf-8?B?MEJIMXUvUEZ2TG0vd2RRZUxQVjd1MFdHbU9RZHJJUnlMZ3ppZFZEWDNHeTdJ?=
 =?utf-8?B?VjJxM1ZJZzVJemxPVDNnRVI5SWh5UGQ2L3NSbTBMNk5vYjFHdnoyb1JLMlE4?=
 =?utf-8?B?ditSdDdFY1AxVlJibldiTXdQWE5iWVBkVXBFMWRaK0VUbWpkWkNFcmNmREYr?=
 =?utf-8?B?TDhwOTdBN2hnQy9PWEo5Yk10NURnVVRNR21IUndVL1BWY0NaS0VrWTgyYkxz?=
 =?utf-8?B?bHNmUHpHSEVnaUtPRjVLTXpraGhwMERSUUNwUXd4SFlmTnhiVG5nZVdMWGlV?=
 =?utf-8?B?UzJpN0JrdTNnM1hNSk9Zc2FoWW9RY3J6QVFib244M1FrM1pRdXo5Q3g2Sm92?=
 =?utf-8?B?UldNUW0vYU05OVExZ2NXTGFUcWF3UExQeml1d3hERHpGMWtLQlhNMUJsaFZB?=
 =?utf-8?B?b3NXNUhSVFM1N0tzYXpCbCtMV211M2JWRE85alN5LzAvdEZkRGtWNHhqeVZL?=
 =?utf-8?B?bnNGd3h0cW11eXJib1F2eVFBUllIOVljdG1zNWpTZ0xzcHhjZDJWYnZGdnhk?=
 =?utf-8?B?Nk1uL2pWYmtGOHpiU2N2WWZISVY1Q3NuSXNhUTg3OXZqNnA5UklreXBOU0Iz?=
 =?utf-8?B?aFJ4NnNoVDM2WVBEdGNRS0swb1J6ZVYrNzBhQnE2T0x2QUhBWFJKeW5ZUnZu?=
 =?utf-8?B?L1NBUUE5bkdzZUYvYWNoTkJBcVZDS2c5OGhVbXpBSGpkVXhuekxvVGFLb1Zw?=
 =?utf-8?B?SGNaYXU2RTZWUVl4VVZCNkdLbFBRSWdmdnNHT1p2RDJSdmtRdXdTK05IcExX?=
 =?utf-8?B?ZDdZMkdnWW0yUGtLSWNOZUZIdDVxdTFxSGtDbGFGMXJsTWJRSlZ0bDg1citl?=
 =?utf-8?B?dk93UTA5aEZoNGV0eWlFK2ZSNFdtN09TakV5dUVXKzl4SSswMytFMkVMVjJS?=
 =?utf-8?B?UC96ZDl3cWpaMWVmR2dRSzNlM3hhKzMybVhzL2ptUmZPYVJ6c1R0dWxxVHJw?=
 =?utf-8?B?M3MwUW1kZ0VuMVZHbkM1KzFhOE1RekFDQ3FPbFg5RkJkU1J3Ym1lWWw1dHY0?=
 =?utf-8?B?RnRFN2QzTFFwSjB1b2ZYY3l2YzZQVmM2Nm5CMGFiZ2lDY0doYTFEVjR4cFNh?=
 =?utf-8?B?emZvK3VCbHVoc0lsbVUzWng1S3c4L1BtR05DSGRyYkpOendvdmFKaTh0WUpz?=
 =?utf-8?B?eHdUeGNKSWU1UzhIUGNMZlVVNjhFQkRVbGduSUN6QWFlYVpuUm4rUXJ3RytU?=
 =?utf-8?B?dXdYR2JQVzRhQ1hrTjB3M1ZRcGl0VVlKR0xJQjNTaGFBWmp1cGEwL0EwY3pF?=
 =?utf-8?B?cm5xaGo1UmE4NzFwem85enN6czJqdXV6ZEt1YnlwK3JFZjNmclN4Zlg1dzdk?=
 =?utf-8?B?empVdWZPQW9LanlWd3l6ZDRFNE1sbmpsR2tqYVhzRm5EKzFrWTh6N1Y0c2ZE?=
 =?utf-8?B?dmdkTzlWOHpvWXVzNVg2ZmpteFhjN2xRTFFWTjEzSFAvMThnaGU5eTdvL0ZR?=
 =?utf-8?B?TmlyczhHZUxnQWp2K0NvVG0vUGpIbEZWdGJVUFdzOTUvRUYvUGRJMWJFQWh6?=
 =?utf-8?B?Wm1pRy9CR0pmQXhVT0daMk5LdVI3bVdPQUE1NlNsM1dFTno4NDh1Tld0RTJ3?=
 =?utf-8?B?d1pHUUpOcDBPQjZsMnZXWXpFOHcyWU54VGp3czNqQ2pYK0tJbmlWN0lYUmdZ?=
 =?utf-8?Q?CXjp6xvRppLIBYER7f2tjttI2UHMKg9wzfsde?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tbmlVlFOkBpE1FQKHZMgnNZnj7DHioz7sdhFXQcd7/n6e6kSlZqFRw2bHZdE2E0Kd6VQYMmrj5g6nB+ZKzrjI/Uq0d0rZ2QYc/4N+QDFRt+FSPw4CDSUDJkQ8jZ0VskwZcx4Sbs3p+AFYzgdU6d2+GwyZoWMg3KplTaP0fGh1MF4WkdPow8L0ImyDJCq9XG6WHaqbtBtbSH1eNJSq5HxxgEr9GALLfFl5ibcg2bLATOaQbNM6+LPJWGLVv0Q/j/ih3V9voadBJLvvokREUk8VhEnc0WybuyjoDnlNg5mY14zOVMQGUi3U/cjAT/ji7we0/OCrboSTdcxU41IdcJHEqSgXvih6VQbKVu7a9RITe/lSQe2m7zszUn7PiXc9hLcE0zSt1qUKWgH6K8FnIN2K21Fi5y+xFr+1Z59BUXCUxKauJ+1Inxws2oWRFEsCX9EsUcQQWARwmtoQCGaCl8DYh3dAxI5tNlXiSPnyJlAsA6Ku1ASxqHSb8TK7w3gOYg/aA8+PRUzUHmXnbMJT8gZVWqt4wVWH1cubAdtJM/jjw4i/YJhIxwrl5/x/kDTQ0K/NgMSVjpfgxqreNmpF+uOfk7dDdErttwv9/hUpV6o4d0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640ab6e8-99f3-49a9-2f74-08de64a18e26
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 10:30:17.2298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7YZ77oCfgi37WPx/lsg6Au2q5S350ReMcJj9+ZjSWROh3G4FoGZazHpf3cLLJ86HrJ+uGOL7sb0BAO9J3JP49h0oyjAEOrWwXxib/OPlfSeuYQgMNZhuYelLt5TkOdx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7801
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_02,2026-02-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050076
X-Proofpoint-GUID: wclknoj4E6PYOL-lpytdlXGZuuKBQrhf
X-Proofpoint-ORIG-GUID: wclknoj4E6PYOL-lpytdlXGZuuKBQrhf
X-Authority-Analysis: v=2.4 cv=Nf7rFmD4 c=1 sm=1 tr=0 ts=6984713d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA3NiBTYWx0ZWRfXz+NKRQ0xQWLw
 Is+O/MofEQtPS7epcKcyIjKvMw3BCZgIk8wH79eWXrJeMebUOMWs5papUy8EBWbPJTmx1tZMGPI
 0aoTxfeG2HwbrCzwWVqjSYIibXgGJZ6FaaX6yWHZ+J/W31LnbzQM1YQHGAHTzQfFJ5NHbeyVN6Z
 Pba04AZA2gL3b5ctJR+ix3iHkLMqgKnCJ+Lhk14MPZiB3hIkZ9Mu9MDnroWheBISpDhSYi9AhEU
 QrUgthcaaOk9Fw+hDuATC3La0kw7yEDsvzoCHGAwMxbm4rDEVhotptSpjzTZCc11OXkpRLRdP2H
 mgtjoO20oAPmeiP/mmkDSJrNH+2niSTRQL1H3QaZnlpNHirLt6NrvJSYZDQMkXbeqmIcrRiQ2fh
 sCAoDEUcDJ8hUVUnv9pJz75lrD9ovclpSZDwnfoT+Yt8jcnjn0B58cYJp1ZvJGNhakQGNFzr2H+
 7kOQbGiIaU120HtYkHQ==

Hi Greg,

On 04/02/26 20:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
