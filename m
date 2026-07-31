Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4062BE05A
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517877; cv=fail; b=nJGMPxTTZwjr7WYOqgpGmmpYZdN2ySA7vTfpNhDGud3+AV77yeT7y51dzwt0iSpR+Xumd+rwWU6Ife624bzFsUAhJVhEX+iqswXoBnc15fbMm9vu1LinRum0MVKrtVdlfE3kagImdm0W3ncVNiYJuug30AMy5VgcAM9mTETvt2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517877; c=relaxed/simple;
	bh=as06/bciNIOMdXZO5uxH4r69fUm24ghOFaX/o/fu6fs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gmsO0QNJ80Xhg9Y5RhB4DHbzKkN4AN+zTD686/Ua+3D2+XLPmjx8e/8PWmsOGgj0xGc7AQgFFVZ6FBbyQOY8NYRb84BU7IqpusDgVZAXHS+TAbT74Z2AyNsSJWNkh1yfeSlPqVro1YgPu4sLnLKoZ2Ycyu45DYPQNIjxQUGps40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A4/W//3J; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v6gBKdts; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A4/W//3J";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v6gBKdts"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VGbFSB641190;
	Fri, 31 Jul 2026 17:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NkSH9Xnkwrsgdxn5ihCg8GHSofQhonvu57mUcxtOVVA=; b=
	A4/W//3Jf7i9Mvm135tjINz/QKc2OeaPS8Lr2GoiJLt7I25Dvp3UGjUVWqESJshk
	X+WkPjREGe66NwzkUtVXHAlHnI5USsxnFzVzhCF7+MPfXFasyLLTLtzDpMMTuGvr
	+/NRhMGKDLP266gv9kNsZGCaTLwz29Pc2Qpyl+xrmz6QRlsobC4byodGfMbpj32S
	Ro41RmViubmp3B77dgtU+AXyHt49+dJh05NyxLhK4pa3Bw4m5HntaAvGvsSZaVyW
	3R2rsCbLPld1qfxrI/xofcd1123Z2vbg64MAjzqOw9k1eFhzPqkMbWmj/t7KZKQ7
	zBLxcpPDZfGJC4Chu32HRA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyykej9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 17:11:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66VH5iad017120;
	Fri, 31 Jul 2026 17:11:03 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012006.outbound.protection.outlook.com [40.93.195.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6tt7wm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 17:11:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QuKRzPxz8PiI4INlq6FTxwxXh8XXYnoqEyf/xZqt1tTGdYWwS5NTgQ3pSNGikDOBr9bWVZtIXwiZzRM5imjt8Lrg7g7e4VfT6QE8Cdlgw4OXJUDulH27NIaQZRMJ1vEbiIifkqyScTRslw3+HegbJotLlwadNrJBKvamp+1ZrRQFTruJsHjf1+vMAdj1uT4/MqtGOmIqAFzqz6ywjInU2zbgezJ0Vqx/nVREkbrrvpuD4rRdlJx2hEHY5/v2H9fFSjAGsCR0RdO5NZtz/dhESeQRgXCMbGn0WcLohvbi7ym9qOSbTXu/txIGcXPf7SQVvlW2xSuooImxCvdcVcAGVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkSH9Xnkwrsgdxn5ihCg8GHSofQhonvu57mUcxtOVVA=;
 b=jmGVqM140T5hSAjDvYEFX4UULi2hAESo6Wqa7EFtVZNYImcD/T97utob5il9pJjFW7WYfI02t6I6HgDmoYkS9fC7jcln7sJHLFpYFg+QhIn04IHPtoI//P/I1GLcZMi2Ya/36nRmd9eS/INc//oHbJINiDhEFphfsR+WiHUhJPO1a7fstmvkoGjeb2wYrdzPlpzHezlKOuEVqhcvQsQy9ZlNhn5iJoEeZ0jel2wDh3nO97gh/yTd3iMt93JWIZBmRevRXZB7WOKJY2zmVBqFBBBZiDh+MYV51pEgiqmaQQ1eTsOlEmx20QPkEyGQCSPE3jyCXuCA0FEiCiS1Zm4UoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkSH9Xnkwrsgdxn5ihCg8GHSofQhonvu57mUcxtOVVA=;
 b=v6gBKdts0cuD59wGNDv7BpIUBAeYrAY2YyKpa4cZnQOFYQtS72upG6M6HyduCq24vxKldW68UhJwqaWEyNGEcAbMLieoCJCbX+x+A5Oz9CDOqUWA1/sCc/SDLftGoN+X5D4UB1zn/GzwCCCFYEHmRgqmG7hRLpJ132Ni0UbB2FA=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH7PR10MB6225.namprd10.prod.outlook.com (2603:10b6:510:1f2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 17:10:59 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 17:10:59 +0000
Message-ID: <88a84d94-8c1a-4ec5-b985-f5a7b2e29b26@oracle.com>
Date: Fri, 31 Jul 2026 22:40:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 469/602] i2c: davinci: Unregister cpufreq notifier on
 probe failure
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Haoxiang Li <haoxiang_li2024@163.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Andi Shyti <andi.shyti@kernel.org>, Sasha Levin <sashal@kernel.org>,
        vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141445.818442273@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141445.818442273@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0052.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::33) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH7PR10MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: 96995858-72c9-4ccd-7c47-08deef26b0fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|5023799004|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cMXE/Ap5ThLwnVbYa685gQmIiQQP3kXE5vbqUC8HE/83k9L2HZ8h6VoYnDkz8HfwgiAYvtTNyzFaeihM40F02cZwmXXP/dMNC6TSdPBKz5FN4JdPaEQ8DNRiDxXvnt0HLWDxRmxUgyINFYzU3QlG25P7r2XcBE6gNORAmTgvo+C/VyyW5LD78POoVBBRrOsLY0ZoVg2wxbpBchWPhpxhN1S2LTu9poH9JuavRbEttH/wEcVDF29ByhHV73t0jqaDijetcWJ4kl9YTRu3yl6hxJ/eqYxOCIDiW66Mr/RFa7ganBHW9iZJySDdqRnkGLXmWIDzeArOU25By6mFovN20N9F2G5/Ys9XClY9Z1gQQK9iPYMpbLYRxBpDORybptBJkmcyROh6d7jvieYhoqBAxMo+YLE5fQXjI9njxYrWmcKDjvGligfdaCIK7U0bSV9IwDjVXaB70wyjM1fN1wqaKkRpUuoWgrdG16M2lsYRdC+9qKHqX9WOFWVV5hjUTrsCaNilBmFh/IzwSyg5MjEkhDfxGke1TzImdL8mUcAyhlqbZU1tgeu6MkcT9yNKDKTNVOYEDtkmsNcNRmepVvrsaxnFwm9IrSrzefP66owZMGjLrZGQq0M5oIL9+hI/2ZlO6ITpFqNYbagEuDwW6ql6ndZ5P6CRqaBrgK4K+OS5fSM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(5023799004)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVBNSVYyT1ZuYVZhZUNUeFNwMDlHUjAxWUVUWkRGMFVGYUdGd1ZvdUFWa0VW?=
 =?utf-8?B?S0syZEF2Z1BGcDZSdnc5aHplNDNJLy9YQ3IwMlEzd0EwbmZDWm5DbEFOM3BL?=
 =?utf-8?B?aldZR1gzOGQ2K0o2aWZEdElOS0JNbjBOdWd5UEhrYXF1L3JuM205c0srV1FI?=
 =?utf-8?B?VjVrdW5vQUhleUVJeTVIeVNiVnp5TlFCNEl2MzhPeDhQZ0RtakhrZnl6cldZ?=
 =?utf-8?B?NHM3T21HQ09PTHhIV3VCeGFYQXVhMm01VElyeEhCeTdrTzdOTWVJK0FtZVln?=
 =?utf-8?B?L1FBK01IcHZSWGVHQ1dEc0d5NlR3aEkrUTR2YXd3bmJsT0NGb0ZVZVN3NVg3?=
 =?utf-8?B?R29FWkZGczI0Tkt6c1A0T205OUtiVVVnZ1BTNGsrLzVQYzRBdXp5K3V4Mm5j?=
 =?utf-8?B?UlRkeE1nekdmUXFHM0dJWkRJSXdwR2VCNjNpdWp4Ry9NcEM0d1d0bHY5VmJF?=
 =?utf-8?B?ZkJnUWJtbldLL1hsZkM4Vmp4a09DdGx5TnZObWpTZjJuTDhEanI0VVUxVnlM?=
 =?utf-8?B?Z3FTNVoyMXBrT1dZSjFPa1JxV29pZWpGS21TeDVtcFRyYk91QTZlZGJDVm10?=
 =?utf-8?B?ZTUrSVBxYjdHUE4yU0JKWWk2RmY5cWRQVHBEQnN2RXhZK1lwaXFNeDB2L1Ew?=
 =?utf-8?B?Z3BpZldKQzB2ejRvVnpwOWJIUldMWXVZQ1QydVhPYzlpMVl6SGYrM1NIcFFJ?=
 =?utf-8?B?dm1ZZTJqL0hpN3RzTGxSOFowK3haZGxnYzhYa29NVm9kemN6aXk0cmlUNUJN?=
 =?utf-8?B?cXZTbWRtbnBrdlEveEZ4UWRrK25zMjUvQkFnOUxCVGJsdGtqVmxDYTdmZEtM?=
 =?utf-8?B?MW5CWGFiS3ZIejVLQVhTeXRRSm54cG1NNlpwNVJTQjcvbzVrbjF1OTdSNDNs?=
 =?utf-8?B?SDlDOS9nc1FWSnRnSXJPeGMzbEl5QWRpUy95OXorOTZrRDFNUGx0eXBKSHhl?=
 =?utf-8?B?ZVBjOTFYd2FNUVFrdDNCYkExOVREN3dWdFd3UWpBais4RWJDTDZzbEVlSjNY?=
 =?utf-8?B?TW5Yb211NFJ5T3V0K0d0bjVBZGY5Mm92ZGx2ODhYbXZmbFdubkd4dzEyVUpF?=
 =?utf-8?B?cTh4L09HM2dRMWtJY0FPMTZ1V1U0UUV6am02Rkpnc0h6QnR0WXdoNTRSM1lQ?=
 =?utf-8?B?ci9VTElQeEp3Q29tT1IrWDJEQ2Y0S1NXSVlLS210cytvOUIvc3JhQ3hyQ2xO?=
 =?utf-8?B?c3JZeHZ2WDd0WnZDQkIyeVROMThvRE5leWNnWXZiRzRoSXZLQmxja1BDck5s?=
 =?utf-8?B?Z3k3YzRiTkRZcHV0b2U3ODJFcWtDYXIxbzZmNUlHM0VlVjU1c1RQdnZuVi9q?=
 =?utf-8?B?YXE0OEo5MVVKaTMyWnNMUlhxVG10UXJ0RWpsQzhtMFB4ZTA5TFY5VTA3TFM3?=
 =?utf-8?B?SUsxZXY2RFV4ZFhSREFxTE1aWGJDbUZHMDlCYWZ4eG1PN1A4ZW4zdmZ5OE90?=
 =?utf-8?B?bEJtQ3daUERrVnYwMjFGNElMTythSjhSK2t0YUc1U2V1N2lmaHVzSWQzaERr?=
 =?utf-8?B?ay9MSVZodmZTU2hjaWdDQTF5dTU4Nkd6a3I2a3d4Ry9objBRUDBzQ2Q1bjRt?=
 =?utf-8?B?Y3dCWTI2dnJoY29VUHRGWjlOTjNtdzliRWhnaWlFOWFHZDJGaU5lY01rN0Q2?=
 =?utf-8?B?Y2JGdHEzVkJDYWdwQUVyWU5MdFNkUDJEMzNjQm85QXB5UzlDcmNoNDZCS3NH?=
 =?utf-8?B?NWI0UmkrZGUzZkV4UzhvZE1sYWxCRE1mcDRrNXk5b2dua0tFaklCTER0Tlpn?=
 =?utf-8?B?dFVuWDlZVktTS0VZL3lKdmR5YzlpOFg2L1d0RUV2V0M1TWw1c3FXZWtXeHRH?=
 =?utf-8?B?ZCtpQmV5Q3NPNFdDb2JiMzJiZUlvZVUrWFNacWtWb3grRlpyam15OGl5OUhX?=
 =?utf-8?B?UXhMTW9OblJEeWIwWWNsVHpTZnVsbGV6bkREcnFSWUpEQ2g0V2tKWGhCOFk3?=
 =?utf-8?B?WkVSSHh1dDVvOXBJZ0YvVGl6MkpIMzVhMEN2UU5RRXZCRTBwMGt3Y3dHUWQv?=
 =?utf-8?B?anZOUmpGSlhmcmhqcU40SzBacWd1OW5mUVV6YTk4eTA1dmE1WUNWQkJDSjd6?=
 =?utf-8?B?VW5aWkhOeXRHN1ZDWlZxM1lZTlZSNW1jM3k3YXhkWkptYWR2VWRDWHozcHZp?=
 =?utf-8?B?V0loLzA3T3lhaFdaRWRPbVo1SzA4dGpjYWlKcmhkZW5mbzRSSVVPQTVyMWdE?=
 =?utf-8?B?Q0dOVGdaaDFiMGttRUpkNktYdUFqZjBON1YyS3VpcmFwaXoyZmE4TDF1Qisy?=
 =?utf-8?B?TzlRVHZjaW9YS1ZKOWRIOTZ6NVY0VktHR2hoOXBIb2xiZ0R5NTErbUxhWFpU?=
 =?utf-8?B?MUlOdjhGaEUwL3M0Z2xEYy9MMm9FaWlUK0R2RGV5QVVMUjVRRHljUzY5WWMv?=
 =?utf-8?Q?fR7A2mNY75+CbaslGpRGLn7GbZV0oxcy1iaas?=
X-Exchange-RoutingPolicyChecked:
	clU+MAV7/UVaZp12jLh3ifZod1HDC+t6iq0ujPOIlgHaaW8nf1LZEGKNLYc5jBi/k8966OiHZ4mEgInn/gSumCjdZXq4bK+84t/0sQriMJ6WvldKG4dch6zF1VnI7JhfyRq11923WWZ7OoA4a2R6TSLT2JOu+ppU66/4wphtZjSRLHDmuvpvSNi2UDRmxylgNoUgVC/57r3SQ6/rHssYh0iRSjJU8dqrNDLB4CfkGvOqmtV+LdPrDplXqrMwVIq/ovPQujuRLMH/Zc6PqYQWdb6W+/l0M9aACUEMpgZD8u3ZbMdGVa55P1OAnjYJdqZ35JzkIgwflP2pLHujHYPnYw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xvY2e4xx1fiy6GsJynEPIfFDkRNy2EnKlgzPAbNscGOM8pOBgt019e8CLCbUPhubAtRF+RbC3MC7Dc1fTz6+PbL1ZK2yuY24ZSnyfYWKp9S5n2iobbTnXzkobFk0eLYuRP1Ifrm79ErmeLi/P4VLkyO4zq8fEVyMP27mGd/uh4HbfMflJWmQUGnrr4k7NJWWsmavvtJkoBn6SLa+/ZQHWYYcb5o6/VhA0KMWtRWJHFckE3N923GncTxz+mIJhFkTWPi2qlZQcY2fgFY7ta1DL6qywRek0sty337byR/IkmVFKJeCZg/pJ6q47ICDjxGlti2JqHXrO1FnlCyIN7ucTpzz6vnhFLes5iadIsp3Rz0UT1BuQK37yJDBQurH7kzRFcAl9aCnkZ5+3/9n/umhZeD5kvZKCSz0kCcI2C8ae5mLpkhWCx3vIMZngnQS+IpJCbuYmBCzHGAnBeFVn1Drybg0gPgBqPm9pCrQSjRJzOE+htZrj+08ZOz23uMCrFf5ABrC99pKHTgbss6/xT7DDtGErVwRqAn2u9Hsjz5InPCPR7uNOCP2e3UwjHesDjBnCs3YT8ylSZ0YFBGtwI3TB6lkwh7kP1P+7K7CoKWTCKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96995858-72c9-4ccd-7c47-08deef26b0fe
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 17:10:59.1402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VngtnlOcGD9VqUdanLCoR+a4jZ3uLRNkwslXVn7rpofp3TQwyZIgwLmXaduZ1yFuChcDAlqibd8FgDVhMv35VwdA1bwX5epIabVP5NviS5WHmoe4OHatzDBwH6F2mW+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310131
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzMSBTYWx0ZWRfX6ZkJeasMdhRd
 geheF04qXqfVyuEZWkQ/FK9hyDz4yqtV9+uQ2rZ8A8yJWOWopskQ9v/xNxydBVHeJ3ncEf+4Nvo
 7yUHp8IOA3Tw29ePZw2S8zprA42QG45RaxyEV2EcM1Gs3N2wm/ft
X-Proofpoint-GUID: MPIic6AKt8rS8D16d6ffeacNaB-TO4b-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzMSBTYWx0ZWRfX4jYS8QMjHR5U
 gEeTsUL0Kjd+PlcYA9Ku9ogAhKy+NBZHIlfqSIute4b68uhb18hlWPSo7izf8UTm4atLLBTMODK
 6Wq+DEjIgae+jY/TtFEeeleJ5hsY5DERU82titedmXV1v33RmHRSZtxpwijesff9AY7RnPEzvuz
 SCFUD0x7FxSKpddi5cE8Ti0NTTv9AbZgXBhuFOXwwJ5YI8wDLPCQhTpvIyxyka98Y61QmDBYyd/
 y7SBoFjb8T/iwoFjue8BQs/rjhWH7A18L1Nv7UcqiScipJPoemUMFsQ3D8TEhHWO7l7hkoHVTEq
 AyZGiZJ5d54SI5ytKc7C1wJhYYuXc0XQub+l/jykWD1nDL5OalqpF2LnCBOr6ug2Cxj/qJ5VsNS
 453ltv8CMv2nC+yfdajo8AoHHhE2CergqshhQ6TBUE/4tuZ9Tj81JJ8AnaWbG5EbySvVf3kDm4u
 0anq3K1zCPXverpMESxLa55DgcFSc7Zgg7Dd9Jso=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6cd728 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=ag1SF4gXAAAA:8 a=tqn3buZd9R1Hvn5fY8oA:9
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12106
X-Proofpoint-ORIG-GUID: MPIic6AKt8rS8D16d6ffeacNaB-TO4b-



On 30/07/26 7:44 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Haoxiang Li <haoxiang_li2024@163.com>
> 
> [ Upstream commit e43f32816a1b1fe5a86279411626fe3a9be56d45 ]
> 
> davinci_i2c_probe() registers a cpufreq transition notifier before adding
> the I2C adapter.  If i2c_add_numbered_adapter() fails, the probe error path
> releases the device resources without unregistering the notifier.
> 
> Add a dedicated error path to unregister the cpufreq notifier after
> i2c_add_numbered_adapter() fails.
> 
> Fixes: 82c0de11b734 ("i2c: davinci: Add cpufreq support")
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
> Cc: <stable@vger.kernel.org> # v2.6.36+
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
> Link: https://lore.kernel.org/r/20260610030513.2651018-1-haoxiang_li2024@163.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/i2c/busses/i2c-davinci.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -864,13 +864,15 @@ static int davinci_i2c_probe(struct plat
>   	adap->nr = pdev->id;
>   	r = i2c_add_numbered_adapter(adap);
>   	if (r)
> -		goto err_unuse_clocks;
> +		goto err_cpufreq;
>   
>   	pm_runtime_mark_last_busy(dev->dev);
>   	pm_runtime_put_autosuspend(dev->dev);
>   
>   	return 0;
>   
> +err_cpufreq:
> +	i2c_davinci_cpufreq_deregister(dev);
>   err_unuse_clocks:
>   	pm_runtime_dont_use_autosuspend(dev->dev);
>   	pm_runtime_put_sync(dev->dev);

Hi Greg/Sasha,

I ran an AI-assisted backport review and checked this manually. The
backport handles the i2c_add_numbered_adapter() failure, but 6.12.y has
two additional failure paths after the cpufreq notifier is registered:

   	if (IS_ERR(rinfo->scl_gpiod)) {
   		r = PTR_ERR(rinfo->scl_gpiod);
   		goto err_unuse_clocks;
   	}

   	if (IS_ERR(rinfo->sda_gpiod)) {
   		r = PTR_ERR(rinfo->sda_gpiod);
   		goto err_unuse_clocks;
   	}
Both bypass:

err_cpufreq:
   	i2c_davinci_cpufreq_deregister(dev);

The GPIO recovery code is absent upstream because
b04ce6385979 ("i2c: davinci: kill platform data") removed it, but it
still exists in 6.12.y. If either lookup fails, probe cleanup frees the
device containing the registered notifier while the cpufreq chain 
retains its address.

I think this backport is incomplete; I think route both GPIO failure
branches through err_cpufreq:



Thanks,
harshit
> 
> 
> 

