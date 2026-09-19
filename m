Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576019CD0A
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789830184; cv=fail; b=d2WbKZ7+oVq8N1l9ruVyVQ7o7j7xiZWW2SYzKYXuvWhmkIEsJBHyr85G8/R2YxwWN2XGf29g6EWe/XqzL9uHLarlurVj2K0zDIwVIITGE5MvEM3GNXBDnt4VE4JwtXHig6QJzisnhZeiuvhPhsuEpmu/6ZonjnhAWd87cz/r4f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789830184; c=relaxed/simple;
	bh=asdraDD5h725bAQkKK4ffgeMlMddIVfeGoOrrGjbDzY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VhNecjpTXq/7/r0sgl8RADR78txAVzx5ko51gqySIvXyAnqcIW9qagcLpywZKbUsTQbS8jbNNP0pxsPiNLbDy75TupPGk74CIPisNVFXXzG8KT8fEkiyl84e15XOROhutj9Lxj3FcifDcHiPzxlsRnZyL0M4PYsS54rkcyrHCEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oLI0KVyN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vxfXZP/b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oLI0KVyN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vxfXZP/b"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JEZXjB1225182;
	Sat, 19 Sep 2026 15:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l19irHOcr7HIIuxiyKZHTAEW6SLyn+VsBp6VWYxBQn0=; b=
	oLI0KVyNClZRdf93woRKPcWOlYmjBe8maVEnNxWdN0Bri5rsqkHewbLP1hk4T5Le
	KdnrXdJULVkY1hUmU2wzxU4NqPVgQdzAj9vRZqBK1IQ50K9MguCJRs9J6uK0yKyQ
	MYnb8RlJmb28MOFQYGM6P91oXeOYMuEjoQWQXK7EPeorzkjhWStA7O2z4HhugLcz
	SB782nYu4COk5wiHHN04XGHeqrMinGbDEsVp3Rq4Oj9eGfQZSbqKXdI7J3qK1kjC
	z5Ev5E95eOmdbyb9p1k3yLxCBnjTm1o0pD9ox+wemKgx8bs69kY6bHdy9K7Im8gQ
	kfCJ5SzaBsDf4G4oRTc6xQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk0xg7ym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 15:02:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JF015a000466;
	Sat, 19 Sep 2026 15:02:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgu96uum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 15:02:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1L9n5HarKWSOAk1P5CXMP9MBDK4gNiaIJ2VFYH20soUVZrgn+bireypFVubRUa9/XlCC8JzefJNo2B0NFLTI/SSQ8XIC0+U5NjSLDsAueGe7rpBOcYHUnurXr6TAj4TXDlbfUWwSyRrzgf+HoCPgQ3mXxkW40uW7TiVPRBiNivO0k+rdMxQ+WSHB8uf9FVtikYeYChqjzXZsZzbWyjL0kB+plQ78dGCER/Ieqp+5Yrckl4wBwaOUaUmVFjwnfskoPU47vEr1kNrkxfZVa9BjUpe2j4f4zRqx9n94ThsfxbPVAcg1yC1c4EhLcw1vgQ4SoWTSmB3tDG5/cwgqrY8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l19irHOcr7HIIuxiyKZHTAEW6SLyn+VsBp6VWYxBQn0=;
 b=SS3P89wFx5DBZnliCGECrIglcojYBHCElnq59sxBH25iOmoLW4NURoj6EU0bJbhKj90LCVTYihvRrRJoJT3fv8nTMUqloEX3FNUdtOkXWmDLn3nNRVXAHTTrwmNkwvdPFOakHUFHqfgt7rNN02IQJThU1LNaojseZMvQlXz1MTNGmAPR3GaICEblbxIn9NH1DK5a/P6VjEJ0Os59WGlW4H3OucjcsMeiqN7ffl7jOyw78iVUysm0iq8SrtHF29RmcL+3LH530OmLqrhsXwid6ZmQRZQol6SoQ+d/hrEuHo35go5/ocGbH0BJe4IbwS286NcEcnqw0fsKcxhRdDzCDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l19irHOcr7HIIuxiyKZHTAEW6SLyn+VsBp6VWYxBQn0=;
 b=vxfXZP/be4p3iZafRt6bemxogh5GZAKieBNskLhhPzF82ZgY2DKYvuNyD9yr0GdYbibvev2/fADcOq0/dQCmcXCDrKpSoQ37YCzfpdI3OGzrxv7qP45k/vW5gSTa/dWwZNoTfkrJDMNqYu1K9flIozrWVEAozalZH+vvL48dD+s=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DSVPR10MB997914.namprd10.prod.outlook.com (2603:10b6:8:3bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sat, 19 Sep
 2026 15:02:45 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 15:02:45 +0000
Message-ID: <cd0a550e-02c0-4cac-a769-3ca0ac0e008c@oracle.com>
Date: Sat, 19 Sep 2026 20:32:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0533/1102] raw: annotate disconnect-side IPv4 match
 writers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Runyu Xiao <runyu.xiao@seu.edu.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151553.184517314@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151553.184517314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0078.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DSVPR10MB997914:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e32693-cbf4-4bd6-f420-08df165f0fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|4143699003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GXjec1KopoWQVrWmNQogzwRnFfnpJB328U0/u5+B2xK031ALktFg50MB1p299SsQva7mEPoXfjsGr3Hv9sbjXsJoxxbe4f4jWgAnvKfetIRZVEt66cHv+jnLMDHjffYKC1t3RfLagBy6JoH/FRBjGeGrsfP0Av0yOE+an95Z6YFtvWbMGz885BYs401iAlzMg6aXmFhOkaqQmE+FK815APUdvtOfK9L4UR5lkgndVnaA0kSk7kdpiVJXRmFZCCoq6TrkFHFRwB/rPZtS1bd2jKvohY98U0FOjM6bgAKSBMhjMaK0LvfR4ZXzMCjuv9wJv6/He2P3az2NXHBWsqUftkBHR8LEKIYVTF+UCJpdeCiiC9loiXJW0s1pZINiJuJxcYNmfPqSbswRW8nvzJexGhz/JsBk6d/24P8aVhtZ+EiJWJy956GY/TuWcU0Y7vqVPbW4jWE5MUum4RXNnX25ePHysri1sb6V0VW3KaXRTlM4XHYpiCQAHIwt9BzsoFWS3sE8ylO3fS27Z90fJ/6qrDO1ZBXKrIjABQOD9jHNv0OBtux7cKvuaBqUshJoZzfU1KS/KSZ9Wr7YG6vhubMKd2k08jKzWiCO77ONqfv2l9LeoMspMtaQMnl4S8BqgSoY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(4143699003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXVHSU1kNGVEOTRsNXlhcktaaHVqVmlSVkhRdWdSR1psb1k4UnFkeVlqTUhW?=
 =?utf-8?B?bTVQMkcvbW5CcmpSc2dqUmpGOE9nRUJNWHJER0ovaFA0cG5xTUFPYU5kc2Jh?=
 =?utf-8?B?V0VqQWRlcXhTOEZlU3lvQ0tNanlmczRQVFJtMk55aGdseWdWSWFmeE1lWHBS?=
 =?utf-8?B?eXppUXVickhVM1lKaGEwazh6M3dYdXFtc1gzMzc0U1VHK3FiSmlPYURrS1Fy?=
 =?utf-8?B?N1kvM2pFbEtMZDE5ZG9vTCtCejBMNytBWVg1ZStDeWtPbTNoVHFLMU0vK3dB?=
 =?utf-8?B?dExSR3pYUlV5NlVkZ3RCK3NSMVdQTklkcWRMTFBtS2Z3NmFMQUozcVYyZ0cy?=
 =?utf-8?B?T25hTW4wM2xMT1hSdmRSYzdHRThFM09vemhmeWJVUis0YnZVTHpjNjBaTjNU?=
 =?utf-8?B?dU9Ea2pUb1JXY3JpbUJEbTJnakJiTGZGQkhZLytJTHhmUVVpVW82d2RBOEg2?=
 =?utf-8?B?WGF4TkFqRnVEY3hQUWJMdzJqOUpHTW1kVlVFTU9ZNkhycW51bEVOVnBSbFFa?=
 =?utf-8?B?WVhGa0R6NFgvSGp4U1Q0K2JxYmprcjErRGRHQ3dBb1ZwL1BtR0pIc2krazBk?=
 =?utf-8?B?dFhab2ROTVo4MVY2SFRtaitUcUJYK0FkczZFVkNpY0R6aU9taUp1NllRc2dZ?=
 =?utf-8?B?MkpvNk8xSFN1MEVERVU3KzR5SlI2a3g0bDdiVXdaQVhZcU1pK0xzbFdxMTV2?=
 =?utf-8?B?NDJmN2NZVU5pMGFKc0J1YUwwZkw0TEhwc2lBTGdNbnJPZlh0ZnJKVm5kdXEv?=
 =?utf-8?B?bEdHdXFORlZwL1F3Y1JGWFFtQlZYU2xIK0duMDRtVGVnaXlwbWhlRVZZV2Jk?=
 =?utf-8?B?Z2ZBZE00V01YYko3OXMzcmZWSVpheFBPRXRFRWNlWVdKeWdjN1hmRk12cmhO?=
 =?utf-8?B?YW9VSlFROWxzRHFNWnNCVkJmQTBhb2Y4K3F1aWgxSkxCaTZSWHcvU1VRRk56?=
 =?utf-8?B?a0xqQ3ZibjBwQmJ6MzZuMWdMQi9OUzVHdnRpcHhaNC90RzlJaVhpTGM0MWhU?=
 =?utf-8?B?T2I2c0pGaUw1dkh4TUY3NlhubnN4UUpHTEdVSEpvT0VQa3h3NXRwcyt5NE9Z?=
 =?utf-8?B?clkwVlNqZ1laVDgrOXdSMHNQRUcvRkFjQXN3Zk9GMkNoTmNJWkJFT2UydGgx?=
 =?utf-8?B?SFdKZEVnLzVzUjllYXBBUkJTbUlmekdKYytjbk53Z1RuTmtyZkgwbStWQzZW?=
 =?utf-8?B?WjVJdWZhWjhzR1FwZGF2cDlhUjc0SkQxMVZ3TEtTeHVZSE85SGZwZWhkemg3?=
 =?utf-8?B?ZmVnVU9KTTZaV0hzWGFsdjZDSHJLb1RWNms2bTk3Q3NRL3EwUjdOSXFLcWZ0?=
 =?utf-8?B?cmVMS3E1akU3TW9rYmJKVERIcW9VM25ra2lqbTl4b2QzTzhuOEdrTUV6UE84?=
 =?utf-8?B?WHlCQ05ybzM2Wk5uUTJYaHZzdkE2MUNGRVhGMVBDbklickNDMVpsS2JmUGtI?=
 =?utf-8?B?bWFpV2tTZWg2SERYRG5Iakx2enBvOE4wUnFDbC93UThaRmVrRE81eGxVVFgx?=
 =?utf-8?B?UjI5M3dzMXUvdUYxVmJ2aXpFNHpzZkV5YXMvSW95YkxvNkhjOWxIKzFXcnpn?=
 =?utf-8?B?WTVkM3p1TFBtN1pkTUlSUU1BSCtDY3FEV25zZVB0NHEzZndxQk9sYytRQzFO?=
 =?utf-8?B?Q1hPWHIyNkZ5VnYxbFhGYlA5QjZLd3pQaDJZZHVLdmh4R2ljNzRHWlF5Yjhs?=
 =?utf-8?B?Zjg0NzhRS1hnSUY0ZUpPS2dSTDRWN25LUEpiNXArOWlDUzloQ2FxMktoL0tM?=
 =?utf-8?B?RUtLcGRTNzhzZ1A2Y0Z6cEJUeG43UmQ3c3d4czJXV0JFVEJYcVFtOFpDWjR5?=
 =?utf-8?B?UmtQcWNXUU9tc1ZyNjJVdWRPQ0VtclF6WlIxR0xVYjloZi9Lci96NEh3cWxO?=
 =?utf-8?B?N3lDOWM4U2JjbmxJbXVnd29hM0w4NDk4TFhzNk5vNkx4czU4b3pXdk9MQjlj?=
 =?utf-8?B?QTFza3BPWmpKTEQ4c1RpbzY3VGVUaTEwK29mcjVwWEhDWmg3d0Z6NWdhenRO?=
 =?utf-8?B?WnFKRUE0ZFVBUWl0Ynh1bnh1NWZYZ0NCTzIrSzUvWCtLR2d2Mk9GdXY3TUta?=
 =?utf-8?B?NXlWeGpiazJmMFVpNDNiWGpKampaZmZlbGYya09tNU50cGtwRno4dUZhTEp2?=
 =?utf-8?B?Y1dTSkgwbE5zc1grd0ROc0h2RHNTd1Yzd0VKaEhVZldvVEhzL2tGbnpSclpM?=
 =?utf-8?B?cDNpZUpQQlBmM1BNaUkvbWt4a29hQ3BUblB3Vkp6UGZ4cDBuWWFVS3ZqeTZG?=
 =?utf-8?B?ZlZoYUJoQ2pMdGt6NVdDZTJNK3ZEbzZMWlorcDh4RjczbGxYck1wUXBBOEFQ?=
 =?utf-8?B?b00zeVY2VHJRUTYzeS9EeHJpZEtVbDBwVFRMQ3VnanlGQnhrdERvZkVJTnpI?=
 =?utf-8?Q?MTiUXGt5rZ6jFpypmnxO0p9i4jw7f55uP62Tu?=
X-Exchange-RoutingPolicyChecked:
	ncanfg9VgGna76fnDiwhcv5oDxfhMqtYuqXBtQVnb5K9R9TIrt2Mg97ukHP2wREuMEcUA3mNjjKgbkcLyphCLGsWBLutPvtPazI9opNYvmqIyHOtYTWnd6dYD0NJa4NbyBNZ9bDFZ9Fdy5VWTtlcep8mYm5ypVWMDpys61iNxp/o9exHnvKQMEvISwM8Ig/I6zOOOkkSDbIMyvmuQbAeBqxZeMSg/2tF75ohlYz/87SWKFj25rx0k8QB5C/66+AtO228FaUNaKEk3NpSZ3gnN+x+Pqj0opVelNnCxnnIxXDwuIHzcmVX+hbKTKFJY9lomglgboW6aJqZa6mvuLHhzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YrTxvQF1dr4ysdHhBhHcoEVAqL4TwXEftI9CfQQUkhSxh+LPaCELuUpUBJm+uIoT7B0YFgsDpbBPTR0AULtKJPFJ1Mm3oLv6OByzwwuT3ze8ZVBfxLP1yMQ99UK4LWpXz+ZTzOK4IPP4wHrlY8LCzOlubONcYuI07TkPemhL2AgzLVUT7s3WrA7/uBgNG+fyyX3TuOd8sWIICW3McOPuQQzbV3aqvgTDOXOxfexs1PRIu6p402B2WGWYaGwjL/1pkM8yiYeUsuK+pQWII79zs9JttuV05wm4N1YKM5XESHZTrSKDJN2ozfgb6nx4i2pz6zXRpD9cdO1Woc4xrAk9up+aMi1YGzCTxUT5WdxfAZ5p+HzJQH7cxlun/ib5YxQ7tIsXuiAPU1FMhjB0Xp6k/Y/2OkZeZ8FutzCq/pomM86Q5xPezUjvVLE6UnGoL411fK2RCEoDZXZJJWKF+RQFcZ2m8Bwr/GOIgoql2etanHaEKD8r032YzXb9o/eGdBYSvK0e3FlfwSSnKG1ZBYOxqvBwII7etiGb7SHho95Dx2/nB4QylM3HXkcOdtoTDVcstFpcp8Wlr3OEHpMis/ISwSAa4S7MBbOSPH9Wc6rIUCk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e32693-cbf4-4bd6-f420-08df165f0fa8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 15:02:45.2586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnfRu7cweBmBxjZPJPeljtF5u7qutoGGCeDwnqhr9/oBVHtknzASLbqF4XGEzvUshPMnAvTzbCzdqQSaUiCB17EtzrkF+jr0hnlI6yGOaRQ/9QNWG/LsNax7PywPlTjR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997914
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609190218
X-Authority-Analysis: v=2.4 cv=F/bC5ahN c=1 sm=1 tr=0 ts=6aaea419 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=bC-a23v3AAAA:8 a=1XWaLZrsAAAA:8 a=jxYLo7jvbfvcOtuME3sA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIxOSBTYWx0ZWRfX+dS3mcjzxqDY
 8bfsGiCxV1QyiUq3GRzr/geXAgeSA4Hl6dY7XOxYSC5257MfN+KIZwR2LzMbUAhgvc6HhL4C09N
 2HGnD7AVAbs5syREQlp+tc0Wsy9OyXTNS0l0NJ0mV3VgaHjFxwI+
X-Proofpoint-ORIG-GUID: z8n76ZPOwh8OyCe4C6P6r54GDVgYil6H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIxOSBTYWx0ZWRfXxiqGwGt6Ri/m
 fkd9/kxY6Vpvn36wdDws08mqcFFm5HDgsKhqVEbSd/Q1FKQOW7NHz/MYk7OmLQO+k+scjet0P4i
 rQL7Ta8fQHV9GFYOQm6VXmKIWhdg/AHYyzPJoUSQV2ZeYiUN8R3x7kdCFYNsKBJrSC5Zb8yDtbD
 8NHdMp0DYbuc3Qtj01CPBy140C7qXQn4uq5tVRn9kfIoAe9MrnExuUlqpghLmMwxJMLmrF+8hVA
 9IoT140DrPGX7aQzOrJj6ruGuD6yfA0yvlF6gTM5837G2mkD8uS6ATdJyTGapjkLH8EGyRXUTCf
 rr9eaksN27At3dIHMoKNsx0zIo37I+aaT9aNL+f8ZHRvIiwTUw1XBnHq4Ni4CWkchmiIrmQtT83
 LvX6eo4dt/kfrIT8bCDClIhEhITa/5nGjrz081pjbf60as5JB+NhT+cLBZVJl4Qoh/hCSZnrFsn
 UVqgVV1NmR8QY6IEm2g==
X-Proofpoint-GUID: z8n76ZPOwh8OyCe4C6P6r54GDVgYil6H



On 17/09/26 8:37 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> [ Upstream commit ac08d183dac0441e41f77bbad50798fe609d90f1 ]
> 
> raw_v4_match() reads inet_daddr, inet_rcv_saddr and
> sk_bound_dev_if locklessly under RCU. Bind and connect writers are
> annotated, but __udp_disconnect() still clears the same fields using
> plain stores.
> 
> Commit 18f116931f52e ("raw: annotate lockless match fields in
> raw_v4_match()") 

^^^

> added the lockless readers and annotated the raw bind
> and datagram connect writers. Its v4 revision intentionally left the
> shared disconnect-side IPv4 writers for follow-up cleanup.
> 
> Complete that follow-up by using WRITE_ONCE() for the disconnect-side
> stores, including the inet_rcv_saddr reset in inet_reset_saddr(), to
> pair with the lockless raw socket matcher.
> 
> Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
> Link: https://lore.kernel.org/netdev/20260716142958.3064224-1-runyu.xiao@seu.edu.cn/
> Suggested-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://patch.msgid.link/20260828012918.1461-1-xuanqiang.luo@linux.dev
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/net/ip.h | 3 ++-
>   net/ipv4/udp.c   | 4 ++--
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 39c6a4033aeda..1a2383c773146 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -689,7 +689,8 @@ static inline void ip_ipgre_mc_map(__be32 naddr, const unsigned char *broadcast,
>   
>   static __inline__ void inet_reset_saddr(struct sock *sk)
>   {
> -	inet_sk(sk)->inet_rcv_saddr = inet_sk(sk)->inet_saddr = 0;
> +	inet_sk(sk)->inet_saddr = 0;
> +	WRITE_ONCE(inet_sk(sk)->inet_rcv_saddr, 0);
>   #if IS_ENABLED(CONFIG_IPV6)
>   	if (sk->sk_family == PF_INET6) {
>   		struct ipv6_pinfo *np = inet6_sk(sk);
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index a891504a96524..69e6897337417 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2006,10 +2006,10 @@ int __udp_disconnect(struct sock *sk, int flags)
>   	 */
>   
>   	sk->sk_state = TCP_CLOSE;
> -	inet->inet_daddr = 0;
> +	WRITE_ONCE(inet->inet_daddr, 0);

^^^


Hi Greg/Sasha,

I ran an AI-assisted review for 843d6af89a11 against the 6.12.y
raw IPv4 paths.

Upstream ac08d183dac0 explicitly follows and completes:

18f116931f52e ("raw: annotate lockless match fields in raw_v4_match()")

With that predecessor, upstream raw_v4_match() uses:

         daddr = READ_ONCE(inet->inet_daddr);
         rcv_saddr = READ_ONCE(inet->inet_rcv_saddr);
         return raw_sk_bound_dev_eq(net,
                                    READ_ONCE(sk->sk_bound_dev_if),
                                    dif, sdif);

It also uses WRITE_ONCE() for the raw bind and IPv4 datagram connect
writers.  ac08d183dac0 adds the remaining disconnect-side stores:

         WRITE_ONCE(inet->inet_daddr, 0);
         WRITE_ONCE(sk->sk_bound_dev_if, 0);
         WRITE_ONCE(inet_sk(sk)->inet_rcv_saddr, 0);

However, 6.12.y still reads these fields with plain accesses:

         !(inet->inet_daddr && inet->inet_daddr != raddr) &&
         !(inet->inet_rcv_saddr &&
           inet->inet_rcv_saddr != laddr) &&
         raw_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif)

Its bind and connect paths also retain plain stores.  Therefore,
843d6af89a11 alone does not complete the intended lockless-access
contract, and the raw-socket matching race remains.  The partial
WRITE_ONCE() conversion does not appear to introduce a new regression.

Maybewe should take an adapted version of 18f116931f52 with 
843d6af89a11.  If that prerequisite is unsuitable for 6.12.y, dropping 
the standalone follow-up would avoid carrying an incomplete fix.


thanks,
Harshit>   	inet->inet_dport = 0;
>   	sock_rps_reset_rxhash(sk);
> -	sk->sk_bound_dev_if = 0;
> +	WRITE_ONCE(sk->sk_bound_dev_if, 0);
>   	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
>   		inet_reset_saddr(sk);
>   		if (sk->sk_prot->rehash &&

