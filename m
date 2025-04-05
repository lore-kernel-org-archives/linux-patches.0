Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C74430
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 07:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743838167; cv=fail; b=Dp63IXls417O3knRfBJ9tGq8xvQjmkAv2W81Ur0mBojE44/LkmdKBNlbhob79fiPO5ySS0L+3njKCFIzGB6NwVxWLq60m8yUpiK+Mku5Mfwr/uRA+WxiA9OlaLzjE13B+s4IDEaPRNR7CODr29eNFq4AL+Qx9ayor+xArYgH4eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743838167; c=relaxed/simple;
	bh=A0h/buHr+OTrJv3MlDU08PQ/oltrmMOmhs3WDYtBsis=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tTbujQQlV3AO+yEWftLC8uRUX3Iiwc2slSlKVz9CjpHZLHi05i51Y9aY6cKk5p4AkdTTF0ZwwwVLzXpS1aAghmrCE35MSM2S5/g5VuqOMBxMVnuDQEwfNMQZRUQERlJaCGPF/eu2MyVjVNF5scQvljyQWhDspSmA2DAGLHg4xLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fieQHxUZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cPHhjfiv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fieQHxUZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cPHhjfiv"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5354DhC3019476;
	Sat, 5 Apr 2025 07:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+LTmU6933cdBOjgi851JJpBy9Ps0WIGALG3IdnKMR2Y=; b=
	fieQHxUZnDQoNhNuZ6uWHSokWE1ZFjdSY61epjYaoNMfZwwlaGl1r8370SHxuKRO
	05XZz1bSLLnGIrhRgpdUK7k8b8LkHO390g/gdoIJ3PLNDy3pnniPFty2uAPMVoU4
	3Lr4QvAKaebXhaYKJ9mLUXtXKk5kxFltaae9hX14KN4+N4O/BvD/lcftwbJ5JcJ7
	vUlHQ6f/y/yCIreKlX/PHf5oFynVVs6LaboU7MLYEsUC5Y/YG9WxIScp0+Ijw0ay
	wq+mxRUSAXvvbGIwT6YjZrfTK/WPPShGCFOTqu+2Js7okUKtby/4hqagBrwNOyUP
	Tn9LvRerXbZx1KnwVZdrNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tua2r4rd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Apr 2025 07:29:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5355KSmN016144;
	Sat, 5 Apr 2025 07:29:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty5y0x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Apr 2025 07:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HkPqEFv1dv/L+aJeTfEESeQJp4WUVYnfV4Ofc5k6yG7xggDdy5We9YHpsSGfh2OC6TrZWPnujMwb8uKPJjsJ45W3QRuJbr47+2x+uNq7MB5KgIBPpt71TYCrG56HjxVG+DIJfSCeetAdVcxHPVvH7RWn1X87v+YKuAISml9Pu9JfuR4Da2gwwchOCTvi3ZE/Fj9wt0BjywcYdRZ0MlfoxxlZQ8m9u/YlOAZsIofJoDg6UrwJtB8eTaNkC2Gvku2AH2czrdir87rrwWDqDs4yDH4bcOrH+a0ESHOkqpdADqyNDzG83Irm1HxwqVYn/2nV1RblfRsUq+CRSpVIRd7usA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LTmU6933cdBOjgi851JJpBy9Ps0WIGALG3IdnKMR2Y=;
 b=vCj5BZ4IWWwr//UkYmXyMrGV/QrAc0wQhXulXWguQ4uJz8pNnat05XR4FDRlRTj0SkfPyh/fZMK7GDK9gPzZ3ZfWDm4CPTzeaOXHP0jxscNfSQ0nxDRz/KFogE+16PPXTa82BerSD2xyYXgpZ+W3xtiFg9XQ4YCqMrsU22L7VJh4ukXfLJidyO9S+R+ecKL0VCiL8EbcGddeCr+cS6Jy3VxKjofduX3aLOMwi9PxIoaJiKxQ2q9l5k+uIWZnLbmg3y75IZnp94inVPB7k06yd6ZhFX0CgRpDNHV59DY+2hRPEGgHQORZg9v58FblseWGFK+ZkJcFf0aJSHg9mS73Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LTmU6933cdBOjgi851JJpBy9Ps0WIGALG3IdnKMR2Y=;
 b=cPHhjfivibzDeyw5IOAS1tccpMEfAkHtpKUsN0MNU4cdJrFA9iCaunBc9XJVUBXBPds87pADmX2yNHYySe3VCru9r5jafIR4vt1ao5cUnw7Eea0RBmQg8fc/3bip3krtQl+cFb8Kq/OSxEzhcNv9i0Cpyk1rBg3pcBzbWBpOtR8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ2PR10MB7812.namprd10.prod.outlook.com (2603:10b6:a03:574::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.46; Sat, 5 Apr
 2025 07:29:05 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8583.043; Sat, 5 Apr 2025
 07:29:05 +0000
Message-ID: <7780f606-3a9b-47da-b973-fddcad23c877@oracle.com>
Date: Sat, 5 Apr 2025 12:58:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250403151622.055059925@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0136.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::16) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ2PR10MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ef7e37-0189-4a92-74a2-08dd74138b45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek15dVdLeGpXaVBrWmp0U05laThieURGcUkrSDFWUzMvUWxvNEloWjNyWGVP?=
 =?utf-8?B?WmpHQVh0WTFqckRoMDVXdjhKNDJSZ2liVUxqVm5pcFUwOWlOWDMxT0VpNkZG?=
 =?utf-8?B?ZndNaUx4V2M4SjdmbnhxZlBkYk9jb2hLRmJCYzhOWEpMMFB5L3FKdHpjVytJ?=
 =?utf-8?B?KzI5am9rLzhqLzZZRXBvM2xnL0lXVFFEM3ZzVmtPd2RzcXZZSm9nQlExSTFs?=
 =?utf-8?B?SkUwazMrcGNyNVdLaFFGZEI3UHZTQ0wraUo4UVZXalZCNmg3ekNsSlR4Q1hn?=
 =?utf-8?B?c01kdUkzU1k3VWR0Y2RzZWs0KzE2NkQwbzR6SjFRSmI1UzNUVzIxZ0hJeHR0?=
 =?utf-8?B?U05PcUtnbEVNOU03Tk9CMTJsV2t4T0dZOHZiM3R5ZkljMU5CWnVQa0F0Vm10?=
 =?utf-8?B?aDE4eEQwSTMrMmZyeWoxTS9CMDhFYmxKOFlQOSsvekpnR0VNS041VnhXeWZx?=
 =?utf-8?B?WXdqODB1NmxBMldmZDB6d1VkaG1aenh2cFYrYlZkNFdJdWxpc3R3TWpXUDYv?=
 =?utf-8?B?UThjUFVuWVQ5Q1lWYUZBVGxaWG9Yd2ZsZVdiSjJqQm1PMnJ0WTgyUlMrKzNx?=
 =?utf-8?B?M29aZmVZWFdaWlJ1bHhWckNTZzlpRHdWN3BCS296UmdNRTFOdjdXWGZGWndQ?=
 =?utf-8?B?dHdaWW9uZC9ablpyL0RVVUlGQlVPTXdTTEdrNTlMcmpzU00wM3N6azVqYU1F?=
 =?utf-8?B?a1R5U05IRWVwQmMxVEpSeXlxV1VxOFN4TzF2SDBnTGhJSy9GSDdDQmdmcVQy?=
 =?utf-8?B?aERLanVSbVNzVDJ5bFdpeXdYUDFOZjRkWUE1WmYyVDJmN3hwK2U4M1l6am5z?=
 =?utf-8?B?bHFQK0JPUGF6WE5KQjZLMkpDeWpTRFhsZ3p3QUZkNlpGaDEzWkFTZlpHMUly?=
 =?utf-8?B?MFBNZHdPZGV2cjdUcXVvNk1Hbk84YlF3ZWg1Sm1Ub0ROaUdtWldJb2lRZTlH?=
 =?utf-8?B?TDZHaTNMVGRKTnJUbWdlVS8rWktvRUFrZTdmcXd3aVRFM2hLMjVmQnVUSjZr?=
 =?utf-8?B?Skt3azlCM210SGc3TTFocmJ1R3krRzJ6Vml3VVlNODh5OGZwcmFVeE5QTUN0?=
 =?utf-8?B?aU8yZkl5bEEyb3pwRUV5OGNJWXQxaGdkZGh3YVdYM2tBVGJ5TnBobGQ0Y3JJ?=
 =?utf-8?B?RitON0s5NWtQUkFWYzVEdGpSbHFIRTJnZ2xBR3FRYmhxSXl1RXZydEJsclB0?=
 =?utf-8?B?ZzhWVGpzRnE2eERvem5tSEhQTW9HWmY4M1NKNzJiaFVvcHVTNEt2eGtFN3BN?=
 =?utf-8?B?Q1VoZzllQm12Qk51cWJJMGVGT1dzN1dPRjNrRnlSRVRsZzFWVHdFV2Z0VzlE?=
 =?utf-8?B?Qk4wdHJjRVF5c2R5bWlMcERDeWFhZnVKcFViRmp4UWhnYVpPV2QxbWxOWEtD?=
 =?utf-8?B?TXNBTmJKWVNEMW9sL1FSK1lBeXBqVDVJRFE3Y2dQaFY0MXJJWGM2VFNpWDNZ?=
 =?utf-8?B?RGRvUXdzNS9ycE1QOW4rbUEwbHVYWmZWQjdtYmtwU1drcmhFYXBsWWxtVVhy?=
 =?utf-8?B?TENRZDJ4SWhrTFFya2xNOFlFd2k5QVVHZ09VT2pzMnBiWjc2U21MQkpvNk1n?=
 =?utf-8?B?UkhPUytkSUpMck81dnJydFBLRGxZc1V4L3IyS2NPNXJ3ZUdOcDR1RmsxUFBo?=
 =?utf-8?B?MUVjSTFIenZjOVU1WnJPVUEwSkQ3VWlkZENYektHY2xONW9aVitFMFlwbWY3?=
 =?utf-8?B?aUpIVWhRZzFLcnhnSmZnQzRwbCsyYy9KTmdhMUJqQnFmbFRNTEw1K0U4cmE5?=
 =?utf-8?B?dDlYOUdXQ3AveGdsNnNNMnQwYVNJbUFVVEN3TGsxeThDNGdqTXMwL2ErNU1B?=
 =?utf-8?B?NmJPZS83VUlCT1JKMmMyUHYrUDA5NnBvcmVyODJpTTYyVkVIN2ZLMzdHdnhN?=
 =?utf-8?Q?92K+LR2FpzHXI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE05N2hmTEZTcUpXa1FPdDVGVGxXRXBjM2sydXBYczQweWFzdy9DYkJJazJk?=
 =?utf-8?B?SE93dW9xbVRseUtGeE4vS2dyN2hxMzE5dVV4MVdmZDR0OTd0dHRuYzlXQnh6?=
 =?utf-8?B?cmNINEo4bm53SUJFeWViQUllbG5uVzN4aWRIQ0pLazAzR2g1VnJBYTE4Q1RP?=
 =?utf-8?B?aTR6T09pVXEzNmtXV2hpWUtKYVFkNXVXQXllT0crS2gzT1JEdWxjR0oycHV3?=
 =?utf-8?B?RG11M3dyNnkzRWJielBvWXdNQko0YWEvVlZqR0EwZ1ZBTVFCRlpsUzJTLzFo?=
 =?utf-8?B?TUs4NUl3WkdwMnJoSUR2bG9BZjRDbXl4QlNFdnhCbjBPYnJyblUwbzd1b3dk?=
 =?utf-8?B?WldZQmFvZituL2RqWTV5QWJIbWZaRThjVXJIUTZ5Kyt1NHlEdWNwdmhxblB2?=
 =?utf-8?B?V2EvbDBTV2haSWRVK0JqYW52TkZhM3BXbG1Ba0c3SHQvc0g5akp2amlNSVZV?=
 =?utf-8?B?UkpvRUs1QlFKQUEydk14T1loeDFmQSttNDRQZitXZnpTejFSWWF0eHVqcGpa?=
 =?utf-8?B?dTNWQWJoRjNGYitYMHJxMnpCNGpoMkFjbDNDMnJaaEtJbW1lVWVoVGZSRldY?=
 =?utf-8?B?K1VHTlZIK1MwTEExclFRMFJCQzl6K3VZejEzbUNKTWRJa2lMRjF1SkhHMlMr?=
 =?utf-8?B?Si9FZVBZUzBzOWswejZCNER0RnIvMmlmWksyODFlUG94U1pLWklScW9tbFBE?=
 =?utf-8?B?SFVVWExWcDFMZXBvMjl1dU85dXBVdmZZNmJINzNyWWtzRllOUFpMS1ppeG5j?=
 =?utf-8?B?UzJ3VGY3K2lNSnZ3alcyaGw1cnRWSGpNZlB1WU56YWxDRk5pNW9wMXRzenR1?=
 =?utf-8?B?SUVWYlZTVmlLQ3FVTjlBVkRhbnUzVHZJL3gzSDdRTkFGTGRIbnBOVjRmLzBw?=
 =?utf-8?B?ZVZRb0NIK1FWV0JHUXdsNnQvVDA0L1FKZFFhVW1OTUc4UzJZTCtMVW9NQkJi?=
 =?utf-8?B?SHlPRW85OU90b3kyWkdPKzVjZUhvVXUvOFBCN2VTSEdzTHZubHV2V0RLR1Zv?=
 =?utf-8?B?M2pMZTNOQ1l4dUx5Vm1sbUNZbjdDem9BaHlra2VGMjMwVStLaFdQemdERkcx?=
 =?utf-8?B?NVQxYUVRNnF1U3F5Z0pQdE9keXYrd0pXTWFTVUpYak96TlppS1JsR0pWOXpj?=
 =?utf-8?B?bUVSOVNneStyUkJaYmhwcXgraDZva1JmWWJzcG9Xb0V1L1htZEM0SHoyL09H?=
 =?utf-8?B?ZXFHck04enlWTG92bFlGcnc5cmgxcXNrWnpmSFluRWJHZE1ETzBGWVY4Mzl5?=
 =?utf-8?B?dktNVzhQNWZCS3EzUjVkZ1RQQXRzcnVBbnNLZVQwbGZDY3phanNtaVNCQ3Aw?=
 =?utf-8?B?V3piQlZLYm9ONWFZNnIxK2V3aEs5OWwzRWNtRi9rQmx5TVhmZ3BaaXdLcWgx?=
 =?utf-8?B?dUs4V3RoQmZWRWpCQjg0cGV0S1RSOWtjbGtON0NVOEkxdkxNZlpFWmR5UlVM?=
 =?utf-8?B?bHRTZUJEc3V2NVNDU3RHN1dsV2tpME5VUUVBdGs4R1FIVndxSCtuczN2MUJn?=
 =?utf-8?B?bXFYMXNQY3NQM3RTVmhnSXJJVmVBUnBVb3VZWDdyWHU5Z3lyL2dpWmhOTVNZ?=
 =?utf-8?B?aG15RkpTVGJybk9jMlRzYkdkUEVHeEZmNDNudTVJODNRM042TWV1N2dNZTlr?=
 =?utf-8?B?S0xZU2lLbDNlVnVrU1o3OGNRZjFmUTJKdUhjZXJLQkZuMWxnOENNWit6WW51?=
 =?utf-8?B?dlh3TmNrUWtyQkNoaHFxSnJXYlJXUUVpWFErb21ZUXhHRHUvYUR5VEFmWUhV?=
 =?utf-8?B?a1dJa3d2cG1saGNPUUxqMFUyczdyTWM2SDRpSTJGQzQ4STI3Ri9FeVdUYStU?=
 =?utf-8?B?WHBEZ2lTUnJ5YlVGVUlpZWRPODBXR2xFUUJzZmFMWGIxYUVlRSthSzVlOGNK?=
 =?utf-8?B?K1N3V3JrM1VJSXl1Ny9CMVZlY244Z3pvZmJIT1ppVUZGN2k2TjBOL0huWjMx?=
 =?utf-8?B?aTM2d0N0dXdTTEN1TXYyZ1o0U3N0NzRVM2xVQkEwTWJVaGYxLy9TRjFLaC9T?=
 =?utf-8?B?bnpuM3FTZ29oNUMxRmk1N2lYQkZGRFQzT29uSllYcCt0amxLWnh5K3RxUjdx?=
 =?utf-8?B?YXZSbzA5ZFpHK1o2SW1jbFd5VlhRNXZHZG9VSFZ5Tm5tbHZZM2lqVE04d0kz?=
 =?utf-8?B?NkcrRURXWE5nL2ZJY3dSMzUrdDdIelh1dGRrelBEQ3Z3SktTSW0yV0x5b2wv?=
 =?utf-8?Q?Y4uCV2LYZaTVTLG35phabwA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RsS/fnqpIvEPh7OZeaN1u8MXhlLSPk2aHgFBgq/pN6+B7pCJKp+BGvxnCxiOTwVyT8ezciMAT+5kmZAwCijEKvO3ULI5Nm0mNcC6y5fcfJ8Rw74xPfeXBB53gYeH7MpEQS2ynE8k/9K2jObZMGhhoh49QkCU6/ZXAdJKHvvySD9M7VbLwl/r6tnNSTAtKPkXqM+8LFXNwJYulzKM6BpJYAgNY2eiJu6cceazbOxprJWUhITVV3jtMbzCGoWlJU9uWVqGgtzHVn0n6L+xf9cKiLIiPZ/HyvqXAFZsS8BVpxTZaaxfN1qDCqDc0VWFV7HsKBrdBo9EEv/9c7g5V3rLN6Hg8EiZUjlaiFZY2dMH2aW/8YhbTkDcpe7xURk4HD22kPFpFRDi6ddZ3uYMuvDLeBE0pxnd8HErqdg6XyvdncwcRON6H7WGoI9XEfFunLoA8I/DybA+ip3bhcuhpyFmsJp431NWq9pSff4gQazj6ACL/udWVULY7ahInDpjj2qZmnOxL/hyERMzKGL4geZ0+acTrz0kERosj0a3xiFO6WiBQI2i/7iz8SMWOtE6LfmQHBoHqMZX/+leaCY4eIJUrtztrigUPKIXcLMOU48TsFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ef7e37-0189-4a92-74a2-08dd74138b45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2025 07:29:05.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RU0ph9AbKAq1gLe65757vCx/D4qFKZVOPQNojz5X9X5K5wqMVPicqY5WwuZcY3JPP5Gi06U6z6io7PtRq+VSkRxcqMkTG1DnH3OKs6Kd9nSLeQRMvs0gp1xXC3fvgteo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-05_03,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504050040
X-Proofpoint-GUID: XYDqkB8ffjydTqtetGHqTPuCmui-hl6K
X-Proofpoint-ORIG-GUID: XYDqkB8ffjydTqtetGHqTPuCmui-hl6K

Hi Greg,

On 03/04/25 20:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
