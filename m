Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D9233E36A
	for <patches@lists.linux.dev>; Sat, 30 May 2026 18:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166442; cv=fail; b=Oxd4jpFCR9iQpRWEOlrpSpO6ygU4WBf3Cu0bzyEpYFBtn30B/oKWZgZUfR1WIvFFbWfMg8QD8gxuOuVoQXrsSkJq3pTeAFRlQD56MX8tabXI1BXgDU7LZGRTIpx2SqNsDo4RGlYo8L9Bb/GJLcbKJhEjJnSKQlJH5rjsl76vlfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166442; c=relaxed/simple;
	bh=jKrrWehoJVu68GuHnRKtvLPJnGC1JCfhNXbMlGQigxc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eOfJ3w8xS5ZUo+0qRP0lm7vQcqeYjCAaV8Y6nq6+13ttEBzUmodMRxkpGQuy5T5T3FlTNO8OnNWL5zcSZNJ4NUTMJWDShzZ9UrIrqloNmyPcAWXue1FPhCkszBW5tFopPEmzCi2pZMlYiCSpgbXhYKxH9uCT3C5SQsNFNR5NwAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HfrLKOS2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qXlLUGNO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HfrLKOS2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qXlLUGNO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64UICcq5733654;
	Sat, 30 May 2026 18:40:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IjvEk0VcZ5B++74CZYymuJfV2MKjwmcEYRAnMVZMDwY=; b=
	HfrLKOS2hJ5QhgO4tXego0A1MTolwcnaiiqFr1ofnyJxhbjPd+qRe2pzMFecXfXQ
	KGZAUeT43i494zhUqAduhlFhb+U7SAyY7RgrZwuV3tLQFf5RkUEMtQ47q0OtHrKa
	9VSHrLzangg8S/kfmgsz7+NRQINX1HBCq9XqB52MXGXY7V7/eyDyoVnhCqUCLgp/
	VeAO4+CV1zq/LPkfsr0W8qQ/aneMty2ixZXNkL6SZVSJ/LHu5SO/FxSe4AFqcT+C
	2sAVNRXLMfYd7+8B06CNAbBZ6X9bVVweJSJBc7tBfnDYHffypKeO/GMuktk6e5Xz
	3gKojhzYgOOKvjYGrzSu3g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpp1rjva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 30 May 2026 18:40:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64UIe5th019103;
	Sat, 30 May 2026 18:40:06 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpba1gw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 30 May 2026 18:40:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnYAxE74rmO0OcWZCDfpV0b24uyE/1OzhJsSqJabF7exPERreka9carvKvuzExrAUmj36LoNmWN/keEklLa38XaqmOZ8GTaW0nDxLmGIMgtKX0s2f2TTsOz0aA7WJWy7M6shUNugilSqv1UiMFBNAd5uZF9BoZgfah7kiHvWP0go4WnZXkozr6DVHi3htCQdYptvDfpRHbJ7PXN+pJWVQRuStbb0BGoMaGBMNhbstCdinQgTKecVADMG5KFdyh/j9h6u/ECNiUUMQSQ+DUAoKx47Q3bwj/t8+STjsTZmMYA8AvMuCU21AEgePsz9HgJJNcVA3z7IjSY6X0AwHpI0Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjvEk0VcZ5B++74CZYymuJfV2MKjwmcEYRAnMVZMDwY=;
 b=xdAnLvGAB+iBYZZwAOkOaCapc27t1i9btasxt20qncWqguQ12EE79yBf5E3WEp1KuZo0m9zyU6AuriW4ycZz5JCCzBxri8AsnwsZ+xu6VYy133pQsSK7s4DqRkkn+LXPuC8hYwAPsWp3622L+wjXnSnP5ncpPx+y3rjXMCWlham2RvNg45UmHCiyXn4rDw7GksAJJL1bOVYygzSn6wJPrbfyxudNNeVvfvaj665/uEDlT66J1YRIXkrowJwKK1tbCVkIsDw5kGNPlrYnVKVxu4g1o4UnmYgZ9/XaGsQX1jrqg5mffMk622eAWnoUjCI7e1GFU33QiHmu4k8pJAzUnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjvEk0VcZ5B++74CZYymuJfV2MKjwmcEYRAnMVZMDwY=;
 b=qXlLUGNO684fyaM/TJxpQ1O0LHIRnYaTxZ9zjKch/OlA8i9qkM08W56Hs//gIer9o+Xgsh5JyRnghgzebgyLgT6btsMoHvPjE9sQmhPA2E56AoeDquhBG/IpPHUtb3MM028r4XzYng578Zz3mUmXC9oiTFWGPJ+ZYoWbXZuOByo=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Sat, 30 May
 2026 18:40:01 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Sat, 30 May 2026
 18:40:01 +0000
Message-ID: <a8cd18fa-18da-4286-a704-e7045d8d9531@oracle.com>
Date: Sun, 31 May 2026 00:09:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 168/272] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, Florian Westphal <fw@strlen.de>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194634.029618376@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260528194634.029618376@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0344.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: c8413235-40d3-4f78-0d02-08debe7adb5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099006|4143699003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	DNC+YB4pfKlyVYRNm6b8hNOvBWwaxdoToG0g4OMXRFblWsUsb1PPyH8SHfvgO/bG3uw1Mx1Ia5ySmIJoWyq4ETNQEHQmBXrHdOZ6gUk7Y8/nFdHASBb+yxoa/bq00WdkZdessHFlTLRLalawnYetFTCr5ZnoN+jO6IpJAHJ8+P2OnUcam0GFrPOz+LXsDS+XZqMgpWiYkcmja3AdvkQ32OqWWGfv7b2vs5XHxBfosR7pAqRp6DyUszVvseNNwyYCuu6vZLZj2wyDNoTOhEwGdNn0Aph94ExEVteyTQ6nCiePHpiMrztlSGk7P0eKd5dvNFnzAdAtCgAKzoige98arsPer6mJRby3UMNzIPWsouy0w+m6QCBZsrw+s9Ru0jmFS8FrRWz3znMSW3R/EfV1NEvjOyncRybacJdPcTBvM5vEw3v/au0ocomXGBjJRTFFfJaqr+JOHglRNhq8IZdIlM2zHq5bqPCXH+LvP5kzJZxQuE7c4t4reJuC18BbXoX9bDw7DsaRHBgsv2ln8sqMM4Nq4b+Peywl0qcaEVLu97Wa80vgWVbbTRiIlEyBIj37rGKsSM6dhdoFrqyMxVM5KPFzg78HR0a5AAj8oTewrzO6TaGyOEcPSeQ7Gn18ACqThNZwBCHrK4YC8x7qPayJjmWiySFCcFy4McVDa8r4Z2UD2FltR0VsjvUeT9hJJTcmiEkUNSphxgXxVEyDXqD3Pw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099006)(4143699003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTR4T1FOTjNtQXJLQnVMNmdod3d0ZkQ2VkxNWDNtTWQ4RVM0TnZvb3YrUUxy?=
 =?utf-8?B?a0drbG9JM0FpSkU2bDFlVTc2aGg0RHZtR2VhVXFrWEIxZW14M0ZoSDBxRldQ?=
 =?utf-8?B?bTJXM2pnMC9FWWpleUg1Q2dCbGJ5elhTQ2NEb3hUYUl4OGJ5SzFmRndNT2Nm?=
 =?utf-8?B?RmVQMVdtVXh1b0twY1A4UEVldnlaZVFLUC9mbVJRTmpIZ1Y1b1hpcU9GRFFD?=
 =?utf-8?B?V24vaGZ0QnpUQlh6YWNkdlY2ZlRFdGUrVzFWb0pvYnAySmdDKzRjcWFnNm5r?=
 =?utf-8?B?N2lvU1UxM1BSK1J1MUhaNmp0NVQxVE5EaHhCNm9FRFJnU2xFVWx0cTVNR09P?=
 =?utf-8?B?QkQzS1NNNmVibUtLRW4wNEV5RGM0czg4WEpGMTNJNFFMU1Q0b2x0ZzFXNSs4?=
 =?utf-8?B?UUw0aitRUVlOS1BtdEdNYkJzd0hvWFB5Y1dZUmhIVG0rQ1VJOHdXYnlLNGVM?=
 =?utf-8?B?TDRvKzRXeVBxWmFnc2ljU0g4alFoYlBUcEZmV1BUcXhmbGYvYmlISlJlUmJw?=
 =?utf-8?B?dHd3Wld6MEkxQW1qbmNvNGV1UGlqSHQ3bE1obGZmTkphRkdZbC94ODFZVGd0?=
 =?utf-8?B?VjV1eUhlUm8yWnpvRjNnYzlMenE1bWhHR0xIUEJlaGxWY3RQenhTNWlpQkZ6?=
 =?utf-8?B?Qlhma2RXdXNibkVFK1pNY2RGRnlzRTQ5M0VsbEVLZDlKVlZqUFV1bHZsampB?=
 =?utf-8?B?K2RTdmpzMXNndmdOTFE4d1BnUVh6dmJjbS94eHZadGhuVEREM0VHTzlud1FR?=
 =?utf-8?B?eDNUTFA5dEpwbE1zQjE1T0xVOGkvZ2dScE5vT3F4cDFaTy9VSGdpSmlBbXJa?=
 =?utf-8?B?aFFuTnRrdVZnclRYOFFncVMvTWFFSWFsY2w1blFMUXVoQi9xOFlvbmYvSFpT?=
 =?utf-8?B?T0FSQ20wNlg5d3VqWG5KeGpyL0ZYbmIyNkN3cHFRU1I2cjFlQkJ3UXZTOVZI?=
 =?utf-8?B?OWJWNDBhWit5YkZFc3pBaW9HZHBPMG9udG5qTGN5RnU4dk1FOW1reVAwWFdI?=
 =?utf-8?B?T2o2ZVhZZktDMUNZelVUem5RYzU0Rm5lOTFzTERhMXViRXRJUVFNN2NrRmZV?=
 =?utf-8?B?bGFpN2tSWUlFWjE4ZXUxNUk3RXA3R2p6eGFJc1RtZU5LNk8rUVFTa0lsRnVU?=
 =?utf-8?B?MFBLdUYvTUZwcXBTa0NvYm43bEM3RmU2clR5NUxPYUd0S2VQeFplb0l3V25t?=
 =?utf-8?B?NmVyaHZYeUsrYWZmdGpWbURCSWlUcCtsUWpsNE9VLzU5NlR1SlVJeWUwaHNt?=
 =?utf-8?B?d28xcm5URXMyb3p6dzlBaUk2TVJVbFpHRDI0ZmI0cnNESDg4VlZ3aC9oalRm?=
 =?utf-8?B?UldaNGtmU0c0MXpSS1NjWWZXR3Q2QmJWR01MQ1l3cUxKTkEyK0k0MXM5dW5N?=
 =?utf-8?B?Q256NWhYdUtTVzlxR3d0NEFKa1EwbVpiMUhWMExGWE9PQXVxUHRwRm11bFVS?=
 =?utf-8?B?L3NUTVhnWHUxY3YyK0VoZFNENms5K0dXS0hkRm1wd2JrNTRNVVNMdGxkSFRI?=
 =?utf-8?B?NS9wYUFmWk50anl3QjJ0NEhLVDc3ZWViWTdwYTJOam03ckVGMWJaQXJjbCtI?=
 =?utf-8?B?b3YzaksrNEhFUEt6eWw2dDRRcmRPNWI2WFZacUQwTUJmbXUxM2JrS0cycUxn?=
 =?utf-8?B?d0piRlpRQkJSYmI5MnBteXUvWC9maUViNDc5a0tKTjU2cTJvVTN5UmMzVjZL?=
 =?utf-8?B?cFBuTVA1WVUyNkR6VG1xVExnQXczQ09rSmpsWlh6bUljU1VNWmpYMlpsMktx?=
 =?utf-8?B?a1V0dU5mamxsNWMwR0ZoNndJek4rc2Z1YkNYbzkyWC9lQnA0a2hxWXZtYTlT?=
 =?utf-8?B?QnNDcm5ycmptcnBWTlV2V0ZBa2RDTlZGZ3l4QVZTdUpzbUJleVRwWmoyNGVP?=
 =?utf-8?B?MzVFZ0ZGL3Mrd0p0cklyWmwvN1JYM1Z3c1JIRFZTcUhPMk5yMHUySVF1b09t?=
 =?utf-8?B?U3hYRzFtazRTV1MrSFBodG9TVnV4RHVVSFVJK3JqRjNrd1E1N0Z2SXh5eUpM?=
 =?utf-8?B?RWRmK09xTlk3ZUFYV1lFQitPUFdKWkk1Y1JkNGNLWVoxMGdLSS9wd2NzLzNn?=
 =?utf-8?B?YTNDVk11UFZOSHZ4clZZYUkzOTZZd2RsTFdlK2gzQWRCcVUvWXBIUUxLdDVu?=
 =?utf-8?B?MHRuTjBZL0hqWlFPcTM1UWVsZWt0K1RQVUtVb1VoNXV2YXgyK3lsSEZuTkVL?=
 =?utf-8?B?TkpTbTRPdWJBQU5mOHdVOWRmZkt3Y3B5Q0pySVlubHYySVpVWWRNZ2V6Unlz?=
 =?utf-8?B?R3RkcHJrWEZPc3Njc0h2U2d3THpCK1YyRXg2Zytoa3hvVnhSUGxtYXc1bWcx?=
 =?utf-8?B?WGIyaXlvTEJ0emJKVVlnTFZhK05WY1dSQkRLT0lYeGV1Z04yRFZabVpOaHQ2?=
 =?utf-8?Q?2UXwFRwBBF3E/aRBTsQGfgN14vSco/jPWytrE?=
X-Exchange-RoutingPolicyChecked:
	jF2+U1GCRRxv1OnG9wvOP72hRw3bPAJKmOV3GPvzIdMZg4Xea4n0R/VFxr7yFPizPvup/ASlpIcaXjER5hQ0gQs5k3Sopld+Jm7UXHzEEXVgKlPQOvbXLLS15aQu/XryS8qIl8+2g2KOqYVv/V4LZA6MjxJ31VgrpS4OK2tCJtJ6ZRJawPWWrpejmYSazi/aRF1DBlRgKxnTEyp/QoLRGUbjEAqzclarEZTYy6oVDoB2DswRc7m7SxyDxE8iT1zu1oLC+pVAO2bBTzfDTSGC5AUCPFQqAvy+SAptIIkUqDbGAgBLyJhJmEp6bFk4DjCWX9rkKlvkUOW2g9UYfL9PqQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ORVsM95Ik3ezqUOS4SGJnjbJECaHXn7l/3QcYafM8s3v0XwQVkF8iCrjr5eT+iD2eTMXDYYeuLYixGH3cuVPSWrU/+WARKKBZar01CSWJixKAKBUcsVIBlGNRaDxxUhyBRw/p53ADYa1R5+iER6FaWvJsJolC+47liV1ceGlUYD0ej2PCkY0x8HxbQ2IbkZ5cfGJYHV0OsaHLX0BlJu5P03vZD3rUy2RikqKWGti0LYvUjsB4/B2odW8HMa6z3OQX2w6cH31T6YgUq9nrMMMiPVQduc8jWZezJ78hq1HyslXcWi5eKqZQY7PCZJBAswcUm31bFFQJx2XUBfP04l8TwE8RKnSFQR1HZPMdm3Iu/lz2aA7Lc7AbIkIAE2IbkpPxrWef1LPSGFlAHWsBLqiKhiM5It7+LmUx1NYCwhmt2hvDCIWOLGm1h2U974umxZynF6/4ZAGMFutj0E755EVYK9bcqpSAvc9wdXyvk6UD/GMzHmOu0opDZTOSCWmlb9DOjtVk7cmnMjs0ptVeye/pLwclUyBRQYpjzzUsrQgHb+j0u3HfGF3FkKMyxw1utDQZcvSoj897ZbWQhLxMU8RwG1YDBb5vvkQS9II/Q1XhH4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8413235-40d3-4f78-0d02-08debe7adb5a
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2026 18:40:01.0774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJyMfoIJBTRdXX+/Pn04Z/RZXqO3gwB816b5nHEcD5mj7nPDwEHf0sBqj9PGsB6RT7tmdS+wyheE18z0yaAz8eDZR6xM851zb47NzDi1x2zh71/g79jOqwZjD63akX0d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-30_06,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605300202
X-Proofpoint-GUID: d3I6_yhkm_ND4upYt87fKriDPH5eTd5r
X-Authority-Analysis: v=2.4 cv=BMWDalQG c=1 sm=1 tr=0 ts=6a1b2f07 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=3HDBlxybAAAA:8
 a=VwQbUJbxAAAA:8 a=CHlfTKWsFbB7oTwgYfcA:9 a=QEXdDO2ut3YA:10
 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-ORIG-GUID: d3I6_yhkm_ND4upYt87fKriDPH5eTd5r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMwMDIwMiBTYWx0ZWRfX3zWsRU3NbUK0
 hKeKCRA9fgD/KxYZHtevpiTAk24qoZwL2Gjk/IW2TDRlWnU1QtNJrTPZUpS4M3r2xCI+vHh3ssa
 juGSDXqUdixjm+L220zZmEerifstnA8+OifRey/tuuL55tZ8TWxv93arP1pplx8jc2U1ws0dNh5
 9sS8kv34oIlkMbhYJXrBwDL6Tdyyyn82RENy8UPHWCgzJPVTL1Nr1Pcsmela67vNPiKQqGXbHUw
 tAsdOlEq2hc3IUF8L+84k3pna/npO5VsYB1ZRfWiZjoDYtGl0UvEbwFkt52hi9rl0nW5STlMojI
 XJNBQEIhqh+jvafza2blFVxbkxy+tgHekXEJho6Ar8pnuub/zHJVQ3tl8kw2ddyVQM3ZP2HjQNP
 AbpHbZkIC8/pdDi4J6u8YBAU6AK9kAQYsYvqJX0k9HSjDd6rPPHmIAVrzMczcXg5ihb0+slBMcN
 1pX80oYKSp8TE917R4g==

Hi,

On 29/05/26 01:19, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 9fce66583f06c212e95e4b76dd61d8432ffa56b6 ]
> 
> The seqcount xt_recseq is used to synchronize the replacement of
> xt_table::private in xt_replace_table() against all readers such as
> ipt_do_table()
> 
> To ensure that there is only one writer, the writing side disables
> bottom halves. The sequence counter can be acquired recursively. Only the
> first invocation modifies the sequence counter (signaling that a writer
> is in progress) while the following (recursive) writer does not modify
> the counter.
> The lack of a proper locking mechanism for the sequence counter can lead
> to live lock on PREEMPT_RT if the high prior reader preempts the
> writer. Additionally if the per-CPU lock on PREEMPT_RT is removed from
> local_bh_disable() then there is no synchronisation for the per-CPU
> sequence counter.
> 
> The affected code is "just" the legacy netfilter code which is replaced
> by "netfilter tables". That code can be disabled without sacrificing
> functionality because everything is provided by the newer
> implementation. This will only requires the usage of the "-nft" tools
> instead of the "-legacy" ones.
> The long term plan is to remove the legacy code so lets accelerate the
> progress.
> 
> Relax dependencies on iptables legacy, replace select with depends on,
> this should cause no harm to existing kernel configs and users can still
> toggle IP{6}_NF_IPTABLES_LEGACY in any case.
> Make EBTABLES_LEGACY, IPTABLES_LEGACY and ARPTABLES depend on
> NETFILTER_XTABLES_LEGACY. Hide xt_recseq and its users,
> xt_register_table() and xt_percpu_counter_alloc() behind
> NETFILTER_XTABLES_LEGACY. Let NETFILTER_XTABLES_LEGACY depend on
> !PREEMPT_RT.
> 
> This will break selftest expecing the legacy options enabled and will be
> addressed in a following patch.
> 
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/bridge/netfilter/Kconfig | 10 +++++-----
>   net/ipv4/netfilter/Kconfig   | 24 ++++++++++++------------
>   net/ipv6/netfilter/Kconfig   | 19 +++++++++----------
>   net/netfilter/Kconfig        | 10 ++++++++++
>   net/netfilter/x_tables.c     | 16 +++++++++++-----
>   5 files changed, 47 insertions(+), 32 deletions(-)
> 
>...

> @@ -269,8 +268,8 @@ config IP6_NF_NAT
>   	tristate "ip6tables NAT support"
>   	depends on NF_CONNTRACK
>   	depends on NETFILTER_ADVANCED
> +	depends on IP6_NF_IPTABLES_LEGACY
>   	select NF_NAT
> -	select IP6_NF_IPTABLES_LEGACY
>   	select NETFILTER_XT_NAT
>   	help
>   	  This enables the `nat' table in ip6tables. This allows masquerading,
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index df2dc21304efb..0d1d997abe191 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -762,6 +762,16 @@ config NETFILTER_XTABLES_COMPAT
>   
>   	   If unsure, say N.
>   
> +config NETFILTER_XTABLES_LEGACY
> +	bool "Netfilter legacy tables support"
> +	depends on !PREEMPT_RT
> +	help
> +	  Say Y here if you still require support for legacy tables. This is
> +	  required by the legacy tools (iptables-legacy) and is not needed if
> +	  you use iptables over nftables (iptables-nft).
> +	  Legacy support is not limited to IP, it also includes EBTABLES and
> +	  ARPTABLES.
> +
>   comment "Xtables combined modules"

That changes quite a bit of configs if we don't set this to y, also a 
note for other distros.

Also there is a missing fix for this that I see:

v6.17-rc2 - 25a8b88f000c [fix] netfilter: add back NETFILTER_XTABLES 
dependencies

I am wondering if we could backport race fixes by resolving conflicts 
instead.


Thanks,
Harshit

>   
>   config NETFILTER_XT_MARK
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index efe7b7d71e7f7..1ca4fa9d249b8 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1340,12 +1340,13 @@ void xt_compat_unlock(u_int8_t af)
>   EXPORT_SYMBOL_GPL(xt_compat_unlock);
>   #endif
>   
> -DEFINE_PER_CPU(seqcount_t, xt_recseq);
> -EXPORT_PER_CPU_SYMBOL_GPL(xt_recseq);
> -
>   struct static_key xt_tee_enabled __read_mostly;
>   EXPORT_SYMBOL_GPL(xt_tee_enabled);
>   
> +#ifdef CONFIG_NETFILTER_XTABLES_LEGACY
> +DEFINE_PER_CPU(seqcount_t, xt_recseq);
> +EXPORT_PER_CPU_SYMBOL_GPL(xt_recseq);
> +
>   static int xt_jumpstack_alloc(struct xt_table_info *i)
>   {
>   	unsigned int size;
> @@ -1537,6 +1538,7 @@ void *xt_unregister_table(struct xt_table *table)
>   	return private;
>   }
>   EXPORT_SYMBOL_GPL(xt_unregister_table);
> +#endif
>   
>   #ifdef CONFIG_PROC_FS
>   static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
> @@ -1920,6 +1922,7 @@ void xt_proto_fini(struct net *net, u_int8_t af)
>   }
>   EXPORT_SYMBOL_GPL(xt_proto_fini);
>   
> +#ifdef CONFIG_NETFILTER_XTABLES_LEGACY
>   /**
>    * xt_percpu_counter_alloc - allocate x_tables rule counter
>    *
> @@ -1974,6 +1977,7 @@ void xt_percpu_counter_free(struct xt_counters *counters)
>   		free_percpu((void __percpu *)pcnt);
>   }
>   EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
> +#endif
>   
>   static int __net_init xt_net_init(struct net *net)
>   {
> @@ -2006,8 +2010,10 @@ static int __init xt_init(void)
>   	unsigned int i;
>   	int rv;
>   
> -	for_each_possible_cpu(i) {
> -		seqcount_init(&per_cpu(xt_recseq, i));
> +	if (IS_ENABLED(CONFIG_NETFILTER_XTABLES_LEGACY)) {
> +		for_each_possible_cpu(i) {
> +			seqcount_init(&per_cpu(xt_recseq, i));
> +		}
>   	}
>   
>   	xt = kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);

