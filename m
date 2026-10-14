Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26933A168E;
	Wed, 14 Oct 2026 21:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792013659; cv=fail; b=RXXFhaCDpvnERrCHAaD6un2QXDUxyakpxfyerdh61YnGPsk4gBuViEcAR8IXr5vw47LUuHCcf8h8VTkoYrBNcbCYybOfXVAPGDX1GXHKeY97Syhu2geNSsJY/D/1cnT0zBK51ps1Ml/NAnhhonZJ76YJbPqk+KA2vQrL/b4zRQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792013659; c=relaxed/simple;
	bh=7DCy1rVVziFQ7kj2qRazRtwA6A70t3cXY7tCAJ8p7XI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aIemqbuHBsZOoSm92I6bq5Y4k2ZHWUOHdwRT9FoyXhGixi7Ljtnt56e3hbkzroYtGE5KBB1ZyiTn2ZASU17nqpmCHOYEm21AtB6PNJY3v4fIN0SMbCY0InOuNpYygcUR6tquwEPOJ7wrWeyGHiI/130QHvJ7YpEhJTbqLnXpzww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hXrVkcPw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vZZ8lYp6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hXrVkcPw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vZZ8lYp6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EL0qkd065904;
	Wed, 14 Oct 2026 21:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vzDE+mlqIUwLDTKv0BKT0hKLs0OUTX6bLCZvB24NVrM=; b=
	hXrVkcPw3lg0aciRI5ucMM/YDJv/Eph467MRu0XFHKkD5Ah/85HEDXocUDNyt2Wu
	17jaL59MwnjAUCwovTDxOcTnUk11PRh2tM9KdalySBKlIWnpsITtI+boxmKoLx9I
	HP1WK/Q6gX88NkhM5CrBZBKvyZWXtG56sDOiVUuMkg2/Y2v7kp2p4fTeXq54YrNy
	hGcfyDNGV9pEJDZJrMbn0QjB8rlMNmrAzdG1k2rlEuu6eHoKO/SZyHRhAHwBDB7k
	rXIECLM1XQb+R3hrDeI55uQyzF6A2XwhcRzgsUwKoRru8flZnb/SwRAPHfshp24l
	1N1hFTgnbeHAl8Z4zh9T2Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkq3kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:34:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELLdhC002191;
	Wed, 14 Oct 2026 21:34:09 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btr4st8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:34:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BOH92Fjc/qQTcVyjkhTVlCDtQVggD9NV8hrb874JfM9hW7T4zBKidmrItxelyTCRls66OjQjR9+PidGfekbobCQ97DpDSbPaMKKKLoC4WQVw6ZDcwZeGxWggs92swGJO/pwB4Ap7GW1+YqcK1SAos6Y84knyo0hOIP6692ERKO15O/ZZuzZgZsl5Vtvf8vEPmsE38FJeFxRyjVcx7ZrAZalVL3yWNh2PuRN2XgQ8dqjsYHA2sTdj2V8AuUeRnQXD48E7GAp/hB5f2JZf4ekqsSrWOnRzWiM6U/yBDQRolboikqFe8iacF5vXcKfJzQ9YJvNq6kYIZE2CpD/vkcfqRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzDE+mlqIUwLDTKv0BKT0hKLs0OUTX6bLCZvB24NVrM=;
 b=GQrflVgk0a7lyzN1XWGblyxCFMZwPJKk8vMJpTGlBNLd2yS3FBJY3lQBtkXR+76tscvkq6HDx33/qPFM1nGvxiHE9vcLEz4E/tYmcN8xC2A9z8E12PtMPgURP2C24KOOVjPWiatuGTYH72r6oikL1WD1aqsc+2yZeDQjKGJkw4m2AprEUZs58L86/PcnQv2yJq3AdJm3cgkaH/M1pIUhRRckvsJaHdn2I6Cf3Qf8qRQ+dCJgpEmIaJzTChLtzAr7q5yYEyXs7e3AytNvcGEsBAKB7bc24h0gwS5pTROrZliLrEkYXdmRWubX4D+daotpQea7WPECiZgWT5YmXTP8cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzDE+mlqIUwLDTKv0BKT0hKLs0OUTX6bLCZvB24NVrM=;
 b=vZZ8lYp6QQdXem7WI2yHWriQGqlmjAo2GQynIA/rUz/+zBU/NspIYe/2cULfg2kkpx1gkMgdc+bXv9NGIdylq71uRzxYjd7jFq83G2I2qO+9eXeVKoAObPeEnSyRFE5X2XsuxEpr048nLtZi0qpzzZMvo1jiQi7B1YsXXXOsrYU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA4PR10MB8709.namprd10.prod.outlook.com (2603:10b6:208:56d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 21:34:07 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:34:07 +0000
Message-ID: <d21b3568-d14e-451f-a048-0655a4138d15@oracle.com>
Date: Thu, 15 Oct 2026 03:03:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 285/497] arm64/fpsimd: signal: Consistently read
 FPSIMD context
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112914.660106209@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112914.660106209@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0323.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA4PR10MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: e6a53bda-3860-4f33-5eea-08df2a3ae09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|5023799004|56012099006|4143699003|261009223027099003|22082099003|18002099003|10067099003|7136999003;
X-Microsoft-Antispam-Message-Info:
	KLo4+xFLE3djaws4y545XnjNjZTu4GKXMz8HniCpAo/L4nOigqdzE4ER+Xh+gpZHdY+L6bXF98qXvJjuS/DhxuSkLxaPzct6JY4MSXQUb6FgiB2tKPiydUhRDXxzTwJYSKHs2bB/h9Fc3LSQGW76R9z8CT6R57Zj2ys835kzQHxRrc2mOTIHqmIhWJ6c64EXheG7oHrII9Fc6ntQda/7jZ0gN7De3YE4D1azsnk8y4j0UVrTuMJUwJGdzyi2SoALrqdQl7svfKQx8Bi64D0erDjdRIf4J2qBj2Ngfv39/rNCr90OhIIXqpfIABibRECoByRVqsjCk8v+L7zg3QeqUYhP5lYIT6q/KBIZ8yyy9aDyDxJ53V3+3VtHv0QPtqqCHtmjPt3iklrYuu7jUaOIqREpBODvZtkJMQ239YC/Zd5EyM4ouJm//lfis4tpymA1nwXQOsp2rb4x3e9TPg8NCT3wmrGFOJS91/33DND8iOk2xkqBtwr9auCODGuwf3L+z6heEuXxzfTGYsN0usXss4CcC1/JIMDzFbC5A88p4tIZMjH46ER0Eia6ow2cRUM44DXKC64gJRr0rXd4y7k1FZvKE10FYJ4rtxsVCrSxi/qmlxpzUaeRqMAp4heJV3FR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(5023799004)(56012099006)(4143699003)(261009223027099003)(22082099003)(18002099003)(10067099003)(7136999003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDliMkM2M0lFNSt5K1lYNFdubzBVOWhKbllVWWxOV2pDMW5rdXUwaEkrdW4w?=
 =?utf-8?B?SUJsNVQvOUJxQ01rVnp6TlZaM1ZrSUlBV2d3TWJpS2NYN2xNczVCcDZqUzll?=
 =?utf-8?B?amFFZGI1K2c4NXBzR01OaG1XQ3Z6MVVyZWMvdm5PRENLcVJIVEcrWHlCSXZQ?=
 =?utf-8?B?VzdHamdOSlNtVGxOS05KMC96ZDFyZ0NLdkZVeDRrK1piYUlwWW0zWUFWUllh?=
 =?utf-8?B?UW92cXFEaU9QQlRoSElRN08reXFFTEpUVzE0NTBnK0pXYWs1ZnY5dVM4eVI0?=
 =?utf-8?B?cFZyeU5LZHNKK2hDbWFlRzJQQUIrTWJ4UmhHRFozNDhzNjFoTDhkc1B0bGIw?=
 =?utf-8?B?eW1YZzVkK3NHaWI5MllUdkZTVXgySHRvZmxiaTJMSHp3NER2S0hrR0JiT3M5?=
 =?utf-8?B?YUJ6dGl5TkxCbEhtUjRtd3pKdllZam41OEhqQk9vTlY0UUtnbVN3NVhQckQr?=
 =?utf-8?B?QURXSTZ3RHp5WWozcHk0b3AxVlphSTh2cXlZc1N5ajZOaFhpOGdrY3ovNDZ0?=
 =?utf-8?B?TWlyZktGUi83cGR5Y1NFS04zUmxzblZacmlRQVpiSkdISmJmQUVCakgreWxk?=
 =?utf-8?B?RDRZV0haQ1RKUFA5bHJ3azhmSW1JZy9yRGJpMk52Nys0ZlRoVXY4a0tkemhD?=
 =?utf-8?B?NkErSmdJeGdPa3ZkNFFvTHp5OWNyNHIrU2tVVHNZUWxGN2VhWGFsK0ZsbENQ?=
 =?utf-8?B?YmlaZmFodVhZS3pZQTlqY2UycUJOUlVqYWNiY1ZoWDB2TEpCbzR6UG90OFRD?=
 =?utf-8?B?Y2JxOElYSEJzWk90KzVZUVlSSFgyR1ZIT2tLS3FCUW5TU3QwSWtjckw4R01U?=
 =?utf-8?B?dmNlY3VHYjlqbFdMQWRXTHJMOGRSUWFwTTlvZHVjNWU5WnVWY3EwdEZLTVIz?=
 =?utf-8?B?N3NBM05OVnV6QUwwWTUyOFAreTY4bEhvcElqZHNFaG1YVm9wK0RPSlQxYXZO?=
 =?utf-8?B?UG1DRSsxUGV5STVnTDhacStjb09RaFd6aTZ4RTVLcVlkVHZpU2pMZlVFTXlh?=
 =?utf-8?B?cDNjdXAzTkdYNzQrQ0Z6R1Qya3RxbG0yRmhoUFIweHRzUmpsMTJWTmN4V29w?=
 =?utf-8?B?cDJxeFJZOE9pYXJPRjF0azBEQzRzL1ZwTmpKb2x5Z0x6c2w0T1l1ajBzNE1u?=
 =?utf-8?B?TFAreUhmWGl2UmVVcHdaL1lneHhRK2FlemlIcjc1T2FyWmhLRDA0Z0lEclhW?=
 =?utf-8?B?VE9aY2lFMTB2WkZnaXkvV3pQOG50ZDNrK2krTnVZNHpQaS9uc2NKbFE4Q001?=
 =?utf-8?B?alcwRXZwcDBPc2ZJaGdmZkVNd2xHelRoVU80Y3dMcEFxK2txQzl5MWZRanZh?=
 =?utf-8?B?N05KL3ZmeVoyNWtkVDlpSmJ0KzlqT0FtS0NQaGRRMkw1NFB5TGhmN2lHRGxn?=
 =?utf-8?B?bnV3Y2RrNVR4Y1JiZ2YzblNBSDlwQ29KRmZlT3FickZhNlBLMFExTTBDNFpL?=
 =?utf-8?B?MlBQNTBUYXFzMEFoWlFKb0tUNkM2YnNDWTlsVG5XaFdaTnBabVFyRXIxdHV6?=
 =?utf-8?B?dm0vK0xyTmQxMldtOHhOWFY1MkRzUHRoT211SE9ZS1k4S2wyWnp5RlhPK0RW?=
 =?utf-8?B?S2J0UkpCUkVGRml6REMrdFpqSnY0eGF0clE3OEJ4LzloQ0lOeVpsNlViODMw?=
 =?utf-8?B?ZTNKNW91V0p6YVlhUmF6dW82Y1RjanN5TGtUSE9Ya2R2MWd0UUNWTkpOci9l?=
 =?utf-8?B?QUk3NmRLSThsTk1Db0RjTUYzUGQzL2tBUlJqcG5JVWNWWC9EYjd2RVZCUzh6?=
 =?utf-8?B?V0k4ZnhvRGpESEFzRlpNMHNFNVhkQklhUGZ5RGlMWmJIVFhnUHRyVTI5SnZk?=
 =?utf-8?B?OVNvVzQ2enpmQmNNNHMxMjVIcForQzl1SWN2NXp1SzFEN2pHeW9CU01qc2I4?=
 =?utf-8?B?L1pYYzU3SWNLNnl2bklydnB3azR5V3VhWlpoa1lhdXpNMjV6RjZMdjNSYjFU?=
 =?utf-8?B?K0xZOW1jSVYzMTlvdEd2RTcxQndsa3BzbzhiQUVBeFJpMlQveFdsNlcwaWts?=
 =?utf-8?B?VXJvYzgzOFZwNDN3dWkrcS9rVVUvbjVjcHoxTythby95WXdnTXRYYkt0cHRP?=
 =?utf-8?B?d0tPTmRENDYwbjR3akpOWHJZd25RNWcyZUFONGtwNXZ5Z0lINHdHWjR2a1l1?=
 =?utf-8?B?MlJNZUJFTTdvd09YWHhqYlh2dGxlbnRYcEdCZVEyblhFS2VUMm1oQ3JsT0lx?=
 =?utf-8?B?QkV6aERTRkxFOURYeTNKU1dkOTRaYnJqUmNGcTgxb3hsdDVVZVBVTk1wbHEy?=
 =?utf-8?B?bDd3RTRFY1VrZjF1OU1remt3c05yejFsZXZSaWYrRjBML24yejFGWUREWTQy?=
 =?utf-8?B?QUdLeTdMS09GU1hhSmU3aW9RTVBOeHorOXRJeHZiY1pVYjVhb1B3VHJZZ3JM?=
 =?utf-8?Q?LdSq/iqe3FGXzhzYP/kBlIYnC12IWASpeFEPG?=
X-Exchange-RoutingPolicyChecked:
	dFn+wnlhiwL6+5bOWk/Ovq+JYHr1ZHDOWzHaHjcWCZWYAfbdERJHU4kJeY3T7+XS2b2G8xqtC/SbIjthjz1+N0gb8/BE9DLYYMk+dUkb43SkKcAkoV7y5fPievYS2xgxNbtawtdn5ABO03xufkoAfHZlSaiCEB/tTM+aUNo8Q5Xt9fp2KT/D4wrIqpPnOmXxfgYx+6xc5O4V89IXHAGJQq851CEZznaJyrTa1/evUqkRnPG8UaWlMXRF7nfgsHA1uvKb0Bv2VmJebXjL1s4YSH1Mwo9Fs8ENK12S5SWcnTwkWU1395AbjV+eupOPUTqJGGRMiWfKCWMK9fSgX/Hsbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hRG8k2PBXIXVquJbwRauhDbZnxyeDFk8X+jxQb6o9MUtpYFSoieUJozMC+PwjoLVoPFS3loTIV4p+pfXrE6QNxcaIYd0PyVaEp3WTTCBgrnG8z6vTeR7VVKh9BE0ZRhNqa75xd2IvZlEl8ejGBE53YU9YHAwyj7TtF7Y7MhewKbYWxLgdMQVClweAC7xbdTD2+NqMLRmWGEIJIMwEG9oYL8g9abYPIu8TkpJMw2u3H6pqF2zEhiklFhI101nGch+gyqW7iUNcw0Nu6sCP2GYbahtxD2TSwFyUEKeOxvu6R/ZcUw2Fz6BeiWijbQG5bEirgdeDWVt1XHYAd1JIXO/DJz5ZzV+sVMCtVwzOkl+clMHCSIzOOipa1+EeOWoZ7NoGZ+Y13LfjHKyzeKvRXCRLj2CsbCXicveTLlV31fis2ZeYnvzzNPj0bUULSha+m55H3RTdkzUCQ4DREShGoyg3S4v55FOJqX0bst4QCh95B5IVgXIMDpr1CWHEZjpSEygVhK5MW3JEKdNGNxFcMwytcpk9Ygz0s8W0iyXzHeGp44G5hqx8p2YdZWMRNN4EaL9iRo8o/ookpElqAMZXKDzvqAqRA/tBPQNx1cwudBdu18=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a53bda-3860-4f33-5eea-08df2a3ae09c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:34:07.6063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yB7ZC1LCc3/Su3Db3fNx9Q4bFyqsgqRS/kSNTKEttTv/zNXd6qXNV1AtNO/eQUMpXEcCOxAZKZyFnjErp4DZ+InzYnX/5wGhwRn2kY2WKS1d6yEEC+zSaw4KB54hypXQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=905
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140085
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acff553 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=WcNw_Br_awVMpKCm9uYA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-GUID: QYreo8cRGMkJMVx6sy_McuXeJ96npehv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NSBTYWx0ZWRfX07WGwDFee6RR
 KeabSv9u1z36sJrdcmnfjIBnM6d28jJhhI/Ls61b4uS8Ncwh2bwdx3k0/rodNy4a8xTjirTO/hm
 V92bKlrqYXBOet4XOWrJRiqEm1nOhkczFftvbHf+mJavdT9lxXbbiZwhwjPw8cXvvAO2UZafb2b
 36BvDZn4tnaXmbWe8SNhQ0iNKjDvESLXmFZPEZihdU2w+MXieY5XQS7kBj9vShnSjhbfm9A/UEE
 goQcR43KTO0QDG0R+ZfYp501HUtfIUHlI5OtJqEOTDAExPm0NfXJPKJ1xjK4OmjGsMPO2V6qn3c
 WrCbIttwTDxHG4DKedMAZ8eccsc60vEci0O2jncRH+5bBFgTTH05fITDO2z+Wt4/XSQzwq6sfdp
 enWJApn3lD7I8G/NZmd0itzBdomqpaqTaKl9xWydBuDQceT1bZv0nCjNBICRWSOXoC1lA8I4i4Z
 I8KuhXCf+VN7Hem769FrURa1W3fzSFu1Fl1EFKAo=
X-Proofpoint-ORIG-GUID: QYreo8cRGMkJMVx6sy_McuXeJ96npehv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NSBTYWx0ZWRfXxT7e9hXoPqq6
 bceBFq0yxhHB3/8Qfxb/U8j3fx39nRLLFE2GaojtwI+KcHJ+/txeZuZVCoOp3NvNvwI5RHng9pD
 NO0uTpxGWvIFIKtL3Tj4QAqzBfWJ1VZSXmymB3nUkX1ssrpGUNCa

Hi Greg/Sasha,


On 13/10/26 5:07 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mark Rutland <mark.rutland@arm.com>
> 
> [ Upstream commit be625d803c3bbfa9652697eb57589fe6f2f24b89 ]
> 
> For historical reasons, restore_sve_fpsimd_context() has an open-coded
> copy of the logic from read_fpsimd_context(), which is used to either
> restore an FPSIMD-only context, or to merge FPSIMD state into an
> SVE state when restoring an SVE+FPSIMD context. The logic is *almost*
> identical.
> 
> Refactor the logic to avoid duplication and make this clearer.
> 
> This comes with two functional changes that I do not believe will be
> problematic in practice:
> 
> * The user_fpsimd_state::size field will be checked in all restore paths
>    that consume it user_fpsimd_state. The kernel always populates this
>    field when delivering a signal, and so this should contain the
>    expected value unless it has been corrupted.
> 
> * If a read of user_fpsimd_state fails, we will return early without
>    modifying TIF_SVE, the saved SVCR, or the save fp_type. This will
>    leave the task in a consistent state, without potentially resurrecting
>    stale FPSIMD state. A read of user_fpsimd_state should never fail
>    unless the structure has been corrupted or the stack has been
>    unmapped.
> 
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/r/20250508132644.1395904-5-mark.rutland@arm.com
> [will: Ensure read_fpsimd_context() returns negative error code or zero]
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm64/kernel/signal.c | 57 +++++++++++++++++++-------------------
>   1 file changed, 29 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index fc817154e8990..02ec2aa171453 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -262,30 +262,40 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
>   	return err ? -EFAULT : 0;
>   }
>   
> -static int restore_fpsimd_context(struct user_ctxs *user)
> +static int read_fpsimd_context(struct user_fpsimd_state *fpsimd,
> +			       struct user_ctxs *user)
>   {
> -	struct user_fpsimd_state fpsimd;
> -	int err = 0;
> +	int err;
>   
>   	/* check the size information */
>   	if (user->fpsimd_size != sizeof(struct fpsimd_context))
>   		return -EINVAL;
>   
>   	/* copy the FP and status/control registers */
> -	err = __copy_from_user(fpsimd.vregs, &(user->fpsimd->vregs),
> -			       sizeof(fpsimd.vregs));
> -	__get_user_error(fpsimd.fpsr, &(user->fpsimd->fpsr), err);
> -	__get_user_error(fpsimd.fpcr, &(user->fpsimd->fpcr), err);
> +	err = __copy_from_user(fpsimd->vregs, &(user->fpsimd->vregs),
> +			       sizeof(fpsimd->vregs));
> +	__get_user_error(fpsimd->fpsr, &(user->fpsimd->fpsr), err);
> +	__get_user_error(fpsimd->fpcr, &(user->fpsimd->fpcr), err);
> +
> +	return err ? -EFAULT : 0;
> +}
> +
> +static int restore_fpsimd_context(struct user_ctxs *user)
> +{
> +	struct user_fpsimd_state fpsimd;
> +	int err;
> +
> +	err = read_fpsimd_context(&fpsimd, user);
> +	if (err)
> +		return err;
>   
>   	clear_thread_flag(TIF_SVE);
>   	current->thread.svcr &= ~SVCR_SM_MASK;
>   	current->thread.fp_type = FP_STATE_FPSIMD;
>   
>   	/* load the hardware registers from the fpsimd_state structure */
> -	if (!err)
> -		fpsimd_update_current_state(&fpsimd);
> -
> -	return err ? -EFAULT : 0;
> +	fpsimd_update_current_state(&fpsimd);
> +	return 0;
>   }
>   
>   static int preserve_fpmr_context(struct fpmr_context __user *ctx)
> @@ -432,12 +442,8 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
>   	 * consistency and robustness, reject restoring streaming SVE state
>   	 * without an SVE payload.
>   	 */
> -	if (!sm && user->sve_size == sizeof(*user->sve)) {
> -		clear_thread_flag(TIF_SVE);
> -		current->thread.svcr &= ~SVCR_SM_MASK;
> -		current->thread.fp_type = FP_STATE_FPSIMD;
> -		goto fpsimd_only;
> -	}
> +	if (!sm && user->sve_size == sizeof(*user->sve))
> +		return restore_fpsimd_context(user);
>   




An AI-assisted review of 6.12.113-rc1 patch 285, 98384a41d88c, flagged
that its new FPSIMD-size rejection can discard unsaved FPSR/FPCR during
SVE signal return.

Downstream arch/arm64/kernel/signal.c,
restore_sve_fpsimd_context()

     fpsimd_flush_task_state(current);
     /* ... */
     current->thread.fp_type = FP_STATE_SVE;

     err = read_fpsimd_context(&fpsimd, user);
     if (err)
         return err;

Upstream be625d803c3b first calls
fpsimd_save_and_flush_current_state() from restore_sigframe().
In arch/arm64/kernel/fpsimd.c that helper saves before invalidation:

     get_cpu_fpsimd_context();
     fpsimd_save_user_state();
     fpsimd_flush_task_state(current);
     put_cpu_fpsimd_context();

If live FPSR/FPCR changed since the last save, the new size error can
leave older same-task values for the SIGSEGV handler. this patch adds a 
size rejection route. The missing behavior comes from 929fa99b1215
("arm64/fpsimd: signal: Always save+flush state early"), using
d3a181588df9 ("arm64/fpsimd: Add 
fpsimd_save_and_flush_current_state()"). We might need these backports I 
guess.

thoughts ?

thanks,
Harshit


>   	vq = sve_vq_from_vl(vl);
>   
> @@ -473,19 +479,14 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
>   		set_thread_flag(TIF_SVE);
>   	current->thread.fp_type = FP_STATE_SVE;
>   
> -fpsimd_only:
> -	/* copy the FP and status/control registers */
> -	/* restore_sigframe() already checked that user->fpsimd != NULL. */
> -	err = __copy_from_user(fpsimd.vregs, user->fpsimd->vregs,
> -			       sizeof(fpsimd.vregs));
> -	__get_user_error(fpsimd.fpsr, &user->fpsimd->fpsr, err);
> -	__get_user_error(fpsimd.fpcr, &user->fpsimd->fpcr, err);
> +	err = read_fpsimd_context(&fpsimd, user);
> +	if (err)
> +		return err;
>   
> -	/* load the hardware registers from the fpsimd_state structure */
> -	if (!err)
> -		fpsimd_update_current_state(&fpsimd);
> +	/* Merge the FPSIMD registers into the SVE state */
> +	fpsimd_update_current_state(&fpsimd);
>   
> -	return err ? -EFAULT : 0;
> +	return 0;
>   }
>   
>   #else /* ! CONFIG_ARM64_SVE */

