Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A491863E
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 07:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743838270; cv=fail; b=BQCwmwyA4OzvGUveXW62d8myjm6KKHHpQ/atRrjCMsTRo4e4VpLBf2AE5o3MKXWh+UThoKpLnwMgZ1e2NhDX2Qqlbh6el73jOsAqVl29NUku8+P3r6Hgte3pUJFd5rJ1KIZ+euNnSOEzO8ZBET3yX5C4IIAiJnRlWwZyaAZA76o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743838270; c=relaxed/simple;
	bh=0umNrBlR8iVV+wFIxh9QwMReSyFtIehLUn+E3O/YveY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qCH2TBCdzQ34+qzy4NniDFkWxFsZNyMMaMC7RpIu57J73fz5KZ296VMxruQabRZNYzfvr4nqrDMFRciD0+TgakcA+3R4veisUk2zYvk8Y/MmoAc1PiZ/XFaCHeEvb7B+lwIudhtnD3espzUOjAXu0XXREBReYpT+j96QaIOkAlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BDKZuTlY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Iy0c0ysm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BDKZuTlY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Iy0c0ysm"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53541cCe000781;
	Sat, 5 Apr 2025 07:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=547wMq749tiNwS84qm12tFLAmwVdUjgOTWAAqsTjWS0=; b=
	BDKZuTlYHnT/0Xectc5hhfDN7qZGYtym0VcSmvV31SnGayQsXGwmfAR9HtoESKeY
	faBtjsyHQW5wUkNJYZCU10+7uFNTsGIBoagLNV28Rwfay1c6Q3r+DG4zj5PfeS9R
	ZIRT3hb75/5HizIz9mSQn/DItnqnr2IfC0xC2rLweIlh2e8ZmVl/4xfwo9v6YEtq
	l8ozyAof+3CQvKNZXwfhrtO7vZZuTYhO2PkRTovpbbggVjYO0JRF2KCR2vospOdS
	pYfM4k7gVz98i7vQsTJhNUq3XJyMh23BFM1y1k2waG/ountDGExmWFW/ZNxMl7/0
	X0d7NWjIxPrMN5UIs+Z/xg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tw2tg2yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Apr 2025 07:30:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5355AD2m016090;
	Sat, 5 Apr 2025 07:30:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty5y2b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Apr 2025 07:30:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YhhviL69ezLW7ZQ8177N19lg43P7zFB+eszWShU+D6kWrBxQOMtcb0/dPVsJvzvzuZIC1oXk7F5fvrgX3vACxjZJCtAvDfH4ZZOBIXqnTxmYJDxBHukEXCwviWPnfHx9/SpyEbDBisB89JXZeXE/sdwSw1AOdtOXylP4a2wtlEinDnhlq/6bA06sUA8fxWwSrors8/KTAvDtq1GrQq1TLn9bPIfibSdPUv3KFiP9sDICC+XarLywuaurohRnJIk6FUYpmXpDn3i/2dTfw3tlc5aVHXnbJSVceAeaWYeAZFderiqRoD0S8J4mZ0dPeBpElcxNiFlRL76Hb7oBiTKDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=547wMq749tiNwS84qm12tFLAmwVdUjgOTWAAqsTjWS0=;
 b=wHa/1O70jrvNicxv2qYKE1hNufYKcPUz687/mSzAGqbVE3uWlzOPGPZAqXi/pyvn2SqoG5ZEJJTfSc9o+pDFj/G1NX659ZTcKwLXFpfrOIudk+ia4FFC6sZE9WJwLXK8zFOBFLgUhcPG7JjYetMYGn1sVwH+2XMcsi5BS1E26wtIG26koQzWkdTTnYZOWhSTyqWFbF6ZVj4wR2P1PX/URCVLKJIT65wc47Jn4S1kmGr1BEC0RUHlawRWksbVdQgappsTv98G8jmY+8E6uA/wMBESo8LISNlwxjT1+UsBhme2hb5GeXqUcTBUpA4ypnd/TbW3GJ8KPsXzGuzkZF61Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=547wMq749tiNwS84qm12tFLAmwVdUjgOTWAAqsTjWS0=;
 b=Iy0c0ysm7iGjE2izegSFrHaDlNBVTXQx/09/entUoglCGFHNjlqdtvrbCPcwQP55WLei5qWoy7tJBr97MK0a1ZZ09XZRluA3iSAF8Og9Ff5vmKCc+RweF0ppJcLbsWZdxHIhcMJAzd5Uf8RdE/M9YI+rChY1dD02BpKph+RyYsE=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ2PR10MB7812.namprd10.prod.outlook.com (2603:10b6:a03:574::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.46; Sat, 5 Apr
 2025 07:30:47 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8583.043; Sat, 5 Apr 2025
 07:30:47 +0000
Message-ID: <e845e0f8-4049-4615-8e45-89f076ea70e2@oracle.com>
Date: Sat, 5 Apr 2025 13:00:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/26] 6.6.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250403151622.415201055@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0149.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::29) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ2PR10MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: e9c60cbd-3d85-484a-9844-08dd7413c826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0orOXRtR0Q1cVd4Vk92RW05bHZqVUhNTmVnWTFWWnRxVDlUQlNCYllUVlZI?=
 =?utf-8?B?MGw3bWdiVVI3bTkzbGVzRDRRWHM4VGxORTRPMG5XY1RaR1ZKbEhUVnB4OEpD?=
 =?utf-8?B?ZklrMmVrZll3UlROUE9iWG1qMGc5ajJyK25DV0RQZGowZEJPR0Jjb1ZnTlV6?=
 =?utf-8?B?d2I2bnNpWnE0ZXJ6enFIc1hjMFhQSW0rZ2VPdHRTNGtzdEJYUzZSM3ZLYm5o?=
 =?utf-8?B?eVlzUHRCRmZEa1R0MDlSWTJJUis4bktxbjlEbThCZG8rc21sbmZqV2V5UnR2?=
 =?utf-8?B?SzhuTUtFUHR0UVBzOGJlVzBpT1ZXbTBOZWlsaEQvZmRrUGpSZndkTVlncGx3?=
 =?utf-8?B?NWJYdnYwU3Z0ejJuQ3RHajhCcnE4dlk3QXRKK2w5UzFBMVl0aDV4YXY0MWdn?=
 =?utf-8?B?ekJ4dFBlMWZqZlFPQWF4NFdSUU0xMC9oNmRVVVU0M3JJS2VkSWthYVdXa1Mx?=
 =?utf-8?B?eWpnU3dIRi9KWkdYbmJIUEdYVnJ5N081L3Z5S0g4dnR4bWMrQTJNWGtrUThF?=
 =?utf-8?B?anlrbHlVV0ZzazhLWEpISTRtc2gvZW9DN3E3dm50WDlGb2JSY0V0djl6Q0pw?=
 =?utf-8?B?emh4R0hUSXhidjlVNWRXT1BWYitTWFl0M1BQK1c2ZXAxN095UzdNcXBQT0Vp?=
 =?utf-8?B?S0hpOUEva0w1VllKODFKYUNtdGRvSUZZam1tZCt5VW5VeFFVNTdnSUNMNWx1?=
 =?utf-8?B?b1orK08vS245eCtxVDgxWjl3TEJGZXBsNmRCK3NEL091UkMzT2hwRnhiRGRF?=
 =?utf-8?B?L21WSFJLRlVweUJ5OUkrSmdsY3FJMWJpeDV5eTdKZkhuYzNMN0ZvbCtUSlkz?=
 =?utf-8?B?azZtanYyQUtXa29ManIraXN6NGcwQlBYRlRRdFROb3A1N2doSnd5WGdTZ283?=
 =?utf-8?B?ZDh3aE50eWJVeTBxbkFhYUVsbDRHbHFRWGpNMk9DUWhFNnF0eGx3dHIrVFRS?=
 =?utf-8?B?OGRCam9JN0ZWRGZNVHJQc0ErTGJvZ1pEL0wrNGVjN0g2ajFEb0lXKzJjZzdU?=
 =?utf-8?B?VjQxbVo5UHhNWEdTNitLUWRTM3NXOXFzTnJtdkdWUlZvMDBuakUzVlZmaGF6?=
 =?utf-8?B?T1NWNnBSL3Y5ODVTc0gzK01UVzA3L0ZCYUIxTzBjREoyS0N6bWpuZ3FMYVhr?=
 =?utf-8?B?SFBPYjBtdlgwblRWdWkzMUc5blhwZTZNTG5qZ1Z3MUlzVHNEeE10LzNLS3Mz?=
 =?utf-8?B?ZVVQQXBEc0VjbkRSUy9DN0NtcVVaMW5SeXJBWTJ1NDRCbFZCMUJHTTcvbmo2?=
 =?utf-8?B?ckkyYkdmRnJ3emtsSEh4bkUrWU5DOXp5VWxZRURKanpOT3BGU1UydFdFV1pE?=
 =?utf-8?B?cTF1QXlSZVhYSEtUc2VoM216ZHlIUWdqK2JZN2kxVDFwSXF2c24wZ24vSHZO?=
 =?utf-8?B?Z0YwdExaZUFYTVlqYWhlRllJRERsSWpWZ0N0NEJjeVdOaitRNEFvTGRkdVdy?=
 =?utf-8?B?MlMxZEFmVlJockJtMVgxei9iUy9OYUIveFg1TVA5T2tvMlRXT2tydzBJUTNy?=
 =?utf-8?B?NFNDbkxkemllbE9tV1laL0FFS2xqS0VzNTNDRXhqdlkwc2xCUTltK0NERzhF?=
 =?utf-8?B?UXdUM1phNmdIOXdMaWhjRmMwTW8zY3FqY1RnSTRkUkpNaEJ4N2lCWDJ4MmJH?=
 =?utf-8?B?b1dSN3dMNzdtcDhSVjJvQ25GSXN3S1JyL0loRFpsaHFGS3I3T3hZY0hNL2RV?=
 =?utf-8?B?VUptaldOVTFCS0FaNWw5VWZOOGh4RWFoQlM3WGkxZ0xxRmVabERCTm9oNlls?=
 =?utf-8?B?Rk9SZTN5dVNtdkxuRytGc2F4LzJtOXl0OG9JUDRBUnYzTGttZkFwbldpaHBN?=
 =?utf-8?B?V2RSTmZleDlLdWJSTUZ1NVZGZnNTY09vYXh2YzBZLzlPRXlMU1ZWTlhzakI4?=
 =?utf-8?Q?BZ48DGjTq1Du4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmhZN3VHNWtkWEhOYnlsY1ltOVZNWUF2OVdmbnpRUVRTTFRKSUUyVEJldzNa?=
 =?utf-8?B?ZDhrbk84QTd2VXpLUFpqcmRZTFBqYWttdGNrb3pLc05ibUlvalVtRFNRWTc2?=
 =?utf-8?B?S2JYMWNvdEdNL2dMR1hONVpIRkhzQ0xYYTVLTHprUXArcjlmcS9ndlZIT3N4?=
 =?utf-8?B?eC9KSThCMGRTTTJPemhabS94UXI0V0h0eWdCRVNncnpyazM1TXZXWXVIV3Uz?=
 =?utf-8?B?d0hFenFkQ2JGOFlCYzFURWlyNFpudnpaVWJJOEVIY3FUVVJ5MGJMTHpDbHk3?=
 =?utf-8?B?RDdqKzdLSnU3L0U3OG1NN2dUTlBldEZVY21EVVdMeW5wSWtaTDBxcFBiZFhm?=
 =?utf-8?B?VU9hTXJ6YUNiREw1VTgzVlJaQjNhNXpHTXo1NXBWTjRwR3BnTjdZUW9IbTZs?=
 =?utf-8?B?QVNPdkxuVUVERytRUGxIa29QblhMK05UbHo3SVZTMjRtUllhRFJLUVVxM0hC?=
 =?utf-8?B?V1BjY210UGxZUExPWkE1dEZDMXpIcndlNlk3MXgydXNKNEptM1FHZWRwU3c3?=
 =?utf-8?B?ZEdWSzlkSmg2N3FHaU9CeDdlS3NqQVJ4QktwT0xEQVRjRlZBR204S3NEZlZM?=
 =?utf-8?B?b3pzTXdjRm42VWdrTmpwczZMZWJ0SFltWTNaN29zZjRaQ1RpY0lZblNiMVZO?=
 =?utf-8?B?MFU5TkdEMVQzeEM3MEpxbGl1WFlSOWxDVWltLytoNkNmL2JLcFNhUTFmRWJH?=
 =?utf-8?B?WVpTSU1uMDR5TjJSMU5CaFlsbVZ2Rmd0dk0yaUZvN0hFcmZJS1hFZTBiTUIr?=
 =?utf-8?B?WFFlcENFWDhGZ2tqYkhiTUptKzlQWFE2V1U2MTJyS0V6WGt6UnY0Zjlibi9V?=
 =?utf-8?B?TGFvQmxEUFNEUjhvbWpkc05YSmNhc2hVVkRJU3R2K1l2ejRtMERURnRaRkRD?=
 =?utf-8?B?QVlmWGZtT3dzTzVyUG4vRCtxZHJDQUJTOVRQSlVibkVIUHdoVngwL3lCK1F4?=
 =?utf-8?B?eWhXOHo1MmRMeHlNOEo3WlBGWlpzNFpwRHUwUFFBZDlTUk40ZHJXNVdHSVJl?=
 =?utf-8?B?UkRRMFpzR0U1b01GSmNoTStMNVZ4OE41eHVoSDd3TXpCM09HTEx3V3lqRVhx?=
 =?utf-8?B?SktUSThicEpheEpEYW1EZmluRlpoZEk5MEFnUjVtalNRWVRCY3B6Nk9pWEFF?=
 =?utf-8?B?akRLYzBaMHkrb05QQVJ1UTJ6UHAvTDY5MjRHZlRnYWVELzhyUWsrZ2hHRVk4?=
 =?utf-8?B?Z1BwUXpBY0lJdFpFOXJnMEVoeXNDSlpuQi9rYXkveGJCL2IzSVFTV0V3dVJB?=
 =?utf-8?B?dytNOVNEakxrZ1BzTitVRi9md01COFBMc3ZsbWFRWm5TS1lseUllZ2Z3bk9n?=
 =?utf-8?B?NGVITnp1czRDWklJWGFSNXhkbEZZWWZTM3Y2MWcya0pKUFhEMStaUXhwK0xo?=
 =?utf-8?B?QjhvZ1hoQjRiQVhiRFU4czVtdCtHUTA5c3FZUG9XS1p3eWxhY3IzeWtZYjVW?=
 =?utf-8?B?RmhmbXBrenpwblRTSWZMWWVSZGFxV1VYdjdxdERTZS9ZUWFydFdLVCtJVDNP?=
 =?utf-8?B?eHpHWFozWDF0ZkFwVUY1MEtPT1d3aEJJMnFUN1k5SFNVS3poYVlBNVpkdVJn?=
 =?utf-8?B?cHJtRGhwdFVGL3V5WHdxTkZzRm44Vjc5MzdNYnBWbXlERmxqNDJhRTdCRlBX?=
 =?utf-8?B?dnpyQWc3TEJBL2tweTgralJhQXhpU2tRbi9GU0tGM3NTRlJGTTF3ejhkVVNm?=
 =?utf-8?B?SWZ2NTdPcnE4d2VkV2Q2Tnpnd2ZneE5iclBub2NEUVJJVEdtT2FXOThJQm5k?=
 =?utf-8?B?bWJnWkxFeUNBemdlNWZDNjdCRkp4NFhncUsvR1psNTFWTE9wVzROT3RPY2d5?=
 =?utf-8?B?S3ludThVcmVjbWtBOWNUNUk5L0JqQzZaRTJyREpDV0lSN0d0RnFVd1k5bzI4?=
 =?utf-8?B?eEg3dnNyb3g2RG1jazdsTE9LSnRtdUlYNVgzVzRpS01ITkYwNy9FaDFHblBO?=
 =?utf-8?B?ZTBKMW1sWWJ0NGhkS0pnbTZBd1cwcnY4eWJucmxJczdGcGFQU1NBaXZSajUy?=
 =?utf-8?B?Q2xTNDlHQ1R5aGtVeXFwT29YeFlNWVAvZTNDYzlTVjkxYy80TEcrcTRKR0pz?=
 =?utf-8?B?ZnVBelQ0UGtOc0E2alNQUFRtSlh4TEo3UERqaEVKa3pYZzU5WnBiVW5Xb2I5?=
 =?utf-8?B?bVBoUnB3d0NKOW1ieEJ0OGhlaldqOEdHUmdVNXY5RU81ejhUdElKaHFGdzdr?=
 =?utf-8?Q?0VTewiZtkf7cF/9jqTIfHIg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IHAD47WUa3JJSCn9GZtwvMlfPhQXh7ABj9Bc155l5lC238LssURof4Lv4iHZ2w/ItTGAuY5B9jtwW6tYSsQUgdF8hjjcpXVPiKTR5+0jON2I6z9xYMtXLc6HfRRgOEljwB5po2D/pDvYWMEUhgGjjULEeP9DiQ9ugMmnLWJ60MuDKrX0GrBGzWGcmatvEVObkyJ9tv6t4uYlKvdRvEP1k+Ojpjg6/LD8zyv6yGYSy5FBIW/vIskHgZthUisnWJnzBEJW/z1Z3CVt6b6xExs6joBnKb7LsTmHXlkQAtJOrq8V9GWUJgQst/2GmPN6oc0zkAVXG3/sJ2ViCSFNHoq1DVVjSFI+uLhQZFVaID3qHn74h62mELLhghoi0rqkckFxhyvBWH1mDAJyxYLiXFK8bZ2eCCcbgEFukLSoW9kooC/77vpWJ8UzAWAvLtJH42GHq9zXWFJx2qypSuBtJv+52eJXUurt5DjkxeQ7lszVLswBM44VEs5H4nGUgbNu4qY3ZrT33SNn+F54HUb1xprUnEqkMXk+wVqKj4MSJCaZ1x7ycYQqMkHoyNo3a+++dBSJwCIwKeMNamrWgE/1bNMFIXCtDMKU22lqLldrZ5s4VCc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c60cbd-3d85-484a-9844-08dd7413c826
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2025 07:30:47.1165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqP8TCJwvwX1Yqvtd3HFpqnFcswczuAzOdhYkwKUZAVgs9ijPZjtfkFNBRk0NvTsrOCKQH4p5BYgSazJxBGaJVtRZSWU0h5nMHUKjdZRpUUk2rCkNmQC2bp7B+GJzQYm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-05_03,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504050040
X-Proofpoint-ORIG-GUID: zPwgjJV2YqE34mZVKbdWGHUXii7dJ7Tw
X-Proofpoint-GUID: zPwgjJV2YqE34mZVKbdWGHUXii7dJ7Tw

Hi Greg,


On 03/04/25 20:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.86 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
