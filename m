Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22796CDB1
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 08:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721810113; cv=fail; b=FJwQrYxSFo24XK51l4xq8FCBhPTJMApAb1s4hSEomEfUzrnoHLo3O4NEUFfKuKWRfMRvdil35waWLAEC9pbaPW7ARNf4NfsN+pU8ohPxmbx062mMHvGgsg6sS90vjgEXcu4lt042iczWisI1B/WKYxmjnO+wt68r0+2mhZNnUJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721810113; c=relaxed/simple;
	bh=TjlCXoDSvpuGkg9/B4PD4Yxld2+nc87EN1zjp0+bRhg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FhXKs05x+nk2q3sZ1xuL2vTyRDQvq430EVZ43BZyPHKfG+vGv/yCCzoILx0J42pswHmmbKFwvNsFmWUlQPtGeikTDaNd2cRXunDBnZvFkyUF71QFLcKSQOmYodcKDcG5om8798TdkrWIoOLTDTkWQ1gjyhfi8qMoKJReqMtDelw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XyYuhWfz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o4h9yVbX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XyYuhWfz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o4h9yVbX"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46O5odXO004312;
	Wed, 24 Jul 2024 08:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=v4meGYr4G0gfeOaZOnM9kqWhcIKYctRhQBo9Icbrqn8=; b=
	XyYuhWfzcNZwu1Mz7I/nVsdWxvRM2pfacBMBhX168CglgKIdDCJskrCNNFsdEVrn
	GcIphA9SOtuA0PX/pUIlmopBDRgoaBLwReM/QZNQWNwAyLXicIn+I5N7HoYC9Bv5
	Xny2lt2ibxXoEAkOe2H7FTV+Tp3pGXLTx+CI6I6barRdV60pMha6pB64aV5k7geb
	lsai3GYW6F13rMpmfj+B8hviA9BaH4VZGHRFERp5Nnk/R1xhpD1F+Kr5drl9UUVT
	GrAWusJa1/7i7jl28h0sCDS2aIDV0yaZBcLx+LRDSrybzF+vf43rrT/BAKUGtlBo
	zXWLwjFI6trZxuQWBHQSmQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgcrgf2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jul 2024 08:34:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46O70m9A010968;
	Wed, 24 Jul 2024 08:34:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h29s9scx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jul 2024 08:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujp8k0NwUGaTkgq3zsXmQKbBNNXur9m/8nynXuVCzD5J7C+nWM2JTtBEiA5Mbuq3TDSaPYB9lzByawdrvNPEhEyGV7JHhBCKZUrgdLLfWhhnqNULjqpEfUrq8lXKFL/gJAhYJ8E6k3DfuGX4eYYztwM0qVlmjaEMeTZ8rcF9RHvll1tLMslDIJicoZgiGkbKftfhefW0xn8CBwn4B+uv3GWDuKqk9SJAEhdFXhDhmDLtaLnqE0AZAXXAw0dUfig/FibJJedf18sGfj+GZxG0gaHDiMa2/mVV15ol29c0yPvrUozvXWrA5Bp13eMZJpKfJkkQXnIYnN8bf+QXECwliQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4meGYr4G0gfeOaZOnM9kqWhcIKYctRhQBo9Icbrqn8=;
 b=qNdLGeq6uy/+10Y2EVY9fcLjlWCtLc0Gt/6EZjX1IMako4E3JLmn88XQfgDsAZgvHiSROccRIFWooTZcwx5rVaVlXJyfKtN7hbAhUODFjdThypZjkdfPxKsVB2Wg65DNCQFO10eA4lGWu6Q/Z03j/di2pW/nIQ60sXUqMeGv5igo22XTUpEC8sdjiqZl1Dn2NdyVhlZgx47tfv/NL9aChzgJvwD2+xLwamlXV4gXXN31uqZxEpNkVL6Qg/J9qxVSofoaR8F3rchM5KVIoNyxIkm1TCQDgatlZLyDVktRyVm2W1qe1RVHyL2ZyaU+ybKuVa3XsX1kLyvrKL2fzkbeDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4meGYr4G0gfeOaZOnM9kqWhcIKYctRhQBo9Icbrqn8=;
 b=o4h9yVbX6S1nLlRjefEUyWl0F1tes9/ef/wSFICJmlMA6jLk8R6NUVs0AKVBKb990rjnGZ5hZfc00IzdIhk3JdEJb3sTyb5kimGmhvb2m0NZgnibFYn2+NgGgZrkjFWsmjwCSILvzqg3fEE3+cBvj8TQP3y9CthKepNYZP0F534=
Received: from SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14)
 by BLAPR10MB4851.namprd10.prod.outlook.com (2603:10b6:208:332::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Wed, 24 Jul
 2024 08:34:51 +0000
Received: from SN7PR10MB6287.namprd10.prod.outlook.com
 ([fe80::5a47:2d75:eef9:1d29]) by SN7PR10MB6287.namprd10.prod.outlook.com
 ([fe80::5a47:2d75:eef9:1d29%3]) with mapi id 15.20.7762.027; Wed, 24 Jul 2024
 08:34:51 +0000
Message-ID: <1ebc827c-c629-496b-ab04-d8673ada287b@oracle.com>
Date: Wed, 24 Jul 2024 14:04:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20240723180404.759900207@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0104.apcprd02.prod.outlook.com
 (2603:1096:4:92::20) To SN7PR10MB6287.namprd10.prod.outlook.com
 (2603:10b6:806:26d::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR10MB6287:EE_|BLAPR10MB4851:EE_
X-MS-Office365-Filtering-Correlation-Id: b6472ad2-3508-4929-14cd-08dcabbb7c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M1ZRK0UxZjB4Mk9hSktNTlpLQkxOY1dDcmcvSitlcmMwTEExRnByRDdvRnl1?=
 =?utf-8?B?Y3EwbnBkazN1UUZ3cll5SjhHQTBjVGJQMWpiNzlzb1lsb3Z1SnJoZnlYeFBW?=
 =?utf-8?B?RXcxQVl2TGNKOFoyMzFIWHRqeVI1NGI1ZnZOamd3MmVBNVh4N1FaaXJJejhs?=
 =?utf-8?B?WVQ5R2JLV3pNckxmc3BHYjRydWxlTDYxaUJ1djZwRWNUblF3TmZ2SGxTLzdp?=
 =?utf-8?B?MlhzODFaMytjMStaeWJ1bHVaZDQxeURZeklvODlJL2pPTnNaekVWSE5NMU92?=
 =?utf-8?B?NnIzVWtCbjR0Y2dHd3VjbS9LQUFEa1lFRmpkUmNXamxtZ0FCVGFmdTJBL1pX?=
 =?utf-8?B?YWNiQWcxdGdWc1RJOFFybXN1a05XNmU5c0NCYVgyaVdzdm9HRTlhRldoRE1C?=
 =?utf-8?B?UnZobHZPUkdoREd6a2V5akZncE8xa1Fveklyb0dFT3g3Q3F4RU5rQWc2Yi82?=
 =?utf-8?B?c014Mm40V3B5djVtaUJDcXhjd3NuMENycU9LMmhqcHRQVnZ1N2tvdFFHUkRU?=
 =?utf-8?B?ZCsweVIvc0swK0dZS0N0c3RIYldhK3NIZUlrbVpZcGdVZFJEWGc1QytuY3F1?=
 =?utf-8?B?cDlkNGlGdVhqNHFJUzBVeVpIa29uTFFna09CbVRNYkg0NGZjK1RKZ20xMlFz?=
 =?utf-8?B?QzdHR0JJc2R3N0JkdjdOUDgwSjEyOW5haU1NWEViKzR5OTJhKzJxNksxYXFU?=
 =?utf-8?B?eWxkZmV0cW5sQnJpSWd3clNWL21wV2VRTVNQWWhPNnVicktiYklGZ2Iya0Uz?=
 =?utf-8?B?S0Fya2FlWXFVQlRTUkk3OU96VWQ4NkhSZTBBb2NOam1MUXZBVld5c2JlN0tC?=
 =?utf-8?B?ZW1FeWhPSGtBeDVaaGlkWmJkQ2xpdUJtbzRoOVI5ejMrOHhpbm1NcWI0UFZv?=
 =?utf-8?B?OWlVd240MXZQa0JyQzdvbzN5WDJxVTY0MFdqc1FRUzZoM0gySE5xZXFGUk96?=
 =?utf-8?B?RThWQXV1VTJ0bTFCV1MvdU1vTFVFOTRzNiswTlZiV1I1ZVBzY3FjR0Zody9U?=
 =?utf-8?B?MndSeEVnUFhtbTJKVWpNbjBkNVZHNVF3M3RTNmR5NGZmWUdsM25VN1dhaU9q?=
 =?utf-8?B?OXZKM2E1UVYzYXMwL2ZNeUpLcXlWRGxTUXVxQ1lUTkliaGpCV1dNeWFBQkkw?=
 =?utf-8?B?aDZRSXNOeXJWayt3NTdIMklMQWpWY2hQYXhQQ0FBZjlneVJvYm40L2ZaajhB?=
 =?utf-8?B?YkF3YWhxZ1NPVm9NMDBicm5uSllOSkRIQ00xTEl4WTFFZjdjUkcwVXZpbmpD?=
 =?utf-8?B?N0VuaG1kTkJCQ1hXRzRCOVhpQ3I2TENYQU9ST2lmOHNWS0lDZEJGeVFnS05X?=
 =?utf-8?B?czVONlVmd2JaS3pXVldGU2I1L3FpZ2NNVFQwa1daSW1DQWFJUWhsN3NaOHhX?=
 =?utf-8?B?a3N3Wm1YT252U2JGenkwazUyampaUmRXZ3E3UzMxT3ZVK3BNaEREcEJwWXZC?=
 =?utf-8?B?eVR5ck9IWGo0bnVPd3RWOWNpVG5hYnR1NnZyaFVUWTRERndmMlo1b2c4d2dS?=
 =?utf-8?B?TVNvYnVzV1lUZVFOamJKSWxkNFpBS2RRZ2gwak0vamlVUXNzRERlSkh4M0Fh?=
 =?utf-8?B?VnJTMzNQSE43YS9yYnpCeEJKTXBjMVdxQXRJN1FuUmlqRHZ3TW0zSmhrSFNL?=
 =?utf-8?B?YzRvRStpSkxEQWpOdzgwOSt6QVNuVUtqN3Irc1BDVi8xTng0cnowT1JJNVNi?=
 =?utf-8?B?RlJ0R2NGRkVidDBSbjA3UWNTViszRCs1eHdyZ2VZSklzdDdKTUVHcUdKOFBm?=
 =?utf-8?Q?3pQv6Pe4ZDfyeXMnt0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR10MB6287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akdsdmNONUZkSnJvRDdIMFo0MlI2RFoyZDZCc05EeXdvNTBGQTRVUVZKTTZs?=
 =?utf-8?B?Y01uamp6c0ZBU0RuSENQOE9kejFmQ05NaGVDWEt1TWZtTTltWVF0ZlFhZ0Mv?=
 =?utf-8?B?MmZTelE1QndpampkZEFSMVVTNkJRaGMvY1NhZmROOTdpSDRBZ1J2amt2S0Fi?=
 =?utf-8?B?bnRQcFUxQnY0QlByY05zcUZoSGFTYlZrckloSUltZk1jT1RiZXJROXhHRGox?=
 =?utf-8?B?dVdJaG5SV2lXdCt3NDg4enc2eUNocG9ZeVAycWF6U0Uxb2xPNFh1a2Z5SWxj?=
 =?utf-8?B?M3NQUDNNL1NOejJNbEk0ZVZNSUxxZ2xabk9CUHlpSys1NkxzQnZRdUlPL3FW?=
 =?utf-8?B?UkJ5NWJXU2FQS1hRcmQ2bWdXL21qeUE3bGlDTzNCYmRvSUU1bVg3aWpYNzE3?=
 =?utf-8?B?Q0JEZFhMcHQ1TVZQOVR2MXViZFhVTzMwSmJLQytEL3FzQnlEazQxS3dHQWh4?=
 =?utf-8?B?MFUvMVBZd2Z4V2JjNjh4UHd3d01UOWE2R0VQOGpVcnV2RVBXMm1HMlV0ekNT?=
 =?utf-8?B?M2lJUHZrL2hhZndUc29zN3pKZ3hIT3pVcDFINFdhdmF6ZjVPNjkwY3JENVlu?=
 =?utf-8?B?VzRESVY2WVRsUk10d2JOSGJzQlZMM1NpRXErN2wwb1k1dHZlb1QzdFpJR3kz?=
 =?utf-8?B?ZGt6ZlV2Y3FBcFhJR1dVaEVpZ2ZOTHRmai9zcTlJMkNleXo2dis4ODlxdlpz?=
 =?utf-8?B?NGRHdHZzZHVXMkZmdThSQkUyeGtWanhDZzRLWmhXUmlLbDByZ0huNEszS1h2?=
 =?utf-8?B?WGJpK0o1ak11YVVNaWhwZTBHWFRWYkFKaE9NdFFrYU1vMUtNKzltYXd4THVl?=
 =?utf-8?B?ZTFKYWRWM3RtYkVqY0lVQmd1ZWxmcXRyQ294SGV1V3habWN3aldxcHlNZW5o?=
 =?utf-8?B?SzV5RkxMUVllR2ZDa2hoRmM3bXk5TWJaVDIvWlV1VTNTUzhEdFZnU3NWYmYy?=
 =?utf-8?B?SnFkak9wUXRBeG9uWjN3K0dsbDRkanZ5cklvNG8yS2FjeGtPV0IvK2M5VWVl?=
 =?utf-8?B?a2ZjUC9ZSjZuMlFXQi92U1VjSXZXQ2VXZUFRVG9LVnAwTnRwR09maHMxSCt6?=
 =?utf-8?B?bmQ5cmt6cGRMYjhQZEpWcWErRVRNeXVBSVczUm94S3hDZ3pNTjg1OGdFcnpo?=
 =?utf-8?B?K2l5Y3IxL21MMFNQVGVnK3R1clBmaEowYStMRmtZajNXU2xxNUNnSnRZQUkv?=
 =?utf-8?B?ZHBUZjNSNkZNbXdnQnp1U2d5NDBtSFhXd1NaUERHL1BoR3BkOHNvNUFWTmxW?=
 =?utf-8?B?MTAvK2l5bUZaR3AwdnF4UkcvemxnK1BsK29QQ2JKMHZwU284dmtVVE9aYWFS?=
 =?utf-8?B?bVZyT0s0YVhGWUh2Vzc5MTgwRXBBY2MzcDdwV2hpOUtNTW40L0pzc2FjcEFS?=
 =?utf-8?B?OUhvN2N3OXRqSVJ2clFhaitXWDBGaURWTmdkU3hVc0liVUtXSUphMTFYYjhj?=
 =?utf-8?B?M00yYlN1UHVwRWI4SkFaUlNFaVIyeVVveHUxOEdnRjJnZk5zeFpLVXY0WTI4?=
 =?utf-8?B?dGJOdGZoRktzdmFZVmcyVDFHSlFlUmNRL29IRnRYZFFwUVVBU1hmQmxLZTRy?=
 =?utf-8?B?YnRzbTVBSDNwWEgyUUhRaEl5SVhyVmxnRUNHdmhhbVAvT0F0WUR4aGFhWi91?=
 =?utf-8?B?NEF5UVFRbkhiWnp4ZXo2Wjk4akRJeTVIRFhoRFhDNHFlQUlRbVJCWDF6dDdK?=
 =?utf-8?B?U3pEd01qOEpCVm1WTGRmYm1PKzFSeHN0b2E1RjdpMWlUeHV1MWVHaGVJY1NX?=
 =?utf-8?B?N3JJdThCUXdOaTBUaWJ1M0ZZUW5sUGdvcHJlNGwyMGdIMEN4eXBKdDkvZ0s1?=
 =?utf-8?B?S1BGTlhUdTloSS80NnlxMUhwNUZEeXdEenk5Vkt2NjBoRTV2RlY5YS9WQVlQ?=
 =?utf-8?B?Vk5GNTlIdzQwa1lMZ3FpVGdOMnArU2taMjlwdUlONWNZdkxDTWRRNjBRQjR3?=
 =?utf-8?B?WE01M2xmVTQvNXlpT1l3VUx4WHlmSFZMak5MVnRyU29PYXZmWmNtbmEzTkdl?=
 =?utf-8?B?bCs0N0ZZNFpocjlXQ01uZ2EyN3I1QWgzUmY2L0JkdXVGTzN0TjQ3Qk9XQzFh?=
 =?utf-8?B?a29sbHVCUEpGTDBnL24wRUJoWDl6Y29uN3JKclJQMWEvQUc2TFpucWo4VktU?=
 =?utf-8?B?d1NMTko1dWdOL0lhNElJbUZETHhsMlNzN2VDbjgyTVZvNklEUmhVdGFBclJn?=
 =?utf-8?Q?LzUhtEkmYWAORb9fGncl46g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gvgRo2Gi+u8iPZyyRwHvIjw3J8gpfRlPP/31mxlNfr9vG+gtjaJ984WYm8XAtyIJkeCBsfh5rJUmSENORCfTK4lYsTTXKQLqA6vQYcTECTTZqIYvy42MALbIHzagNNimLVcoLh073IhVUyvYOWctvJg1NPNnBHAeKFYKgyOKqyovebvPNY/GWqiFGQIiLIVrLzw3ug3maK9mIGtAswcp+9EpUVHOwpiCnnHmSsO4RI+zS9MItjhRpdoNsXaJQuMH/MTUqbqDdyJ1urDi+2TCa9ChU2vW1ZPLtUuBM96J8YyKssd5EDcFrITZItDSkAQ5RTX//mfZnq3qblhd0XvB3bDI8TAGY0mtDy07DFeIno+iJey//hgyWbcbDu3wK5RD4VDNI/4af9LxQO2wQ7NgkULYHTMmmXzGTgI3+UKsqcl0FPIdtgX5cxy3/2VdrWAkyUODH3n3rPJ523byqrVzVSHUlyTcuyHcg/mjyHyrHo4OEpF4+ILytEt5fUWt6Mklym8g53XH8GkUnAzK7MkuBt9bLO9BQ5SbsHQ7IAMdqzOYl5AzHCa6EqPYls9hI2qBZKrLjTx/1X6XxuyM5ibB3g8TXzLJtujNY0IcbChIruc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6472ad2-3508-4929-14cd-08dcabbb7c04
X-MS-Exchange-CrossTenant-AuthSource: SN7PR10MB6287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 08:34:51.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bu6DTq0Z9uBBBS9M55MJwn/Mpn5pxx7VtMabPZGDjPcG7G4Uk2OJUbrXTbzaHycranFqPeOS7FYfQrjI0KT8xPbLtjdfhdt5J4lkXijXp0VPQ1rmATBZzuqTPeis5sQO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-24_06,2024-07-23_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407240062
X-Proofpoint-GUID: _7F-C1tI5hz2T91FqTqX1MJcK9JkCvdR
X-Proofpoint-ORIG-GUID: _7F-C1tI5hz2T91FqTqX1MJcK9JkCvdR

Hi Greg,

On 23/07/24 23:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
