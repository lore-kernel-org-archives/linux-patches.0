Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB544F558
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 08:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980564; cv=fail; b=uXgkoWubfAITbLNQpN+nn2mvX7Y5+WHdg2DJWCqBGHwK3e/PRylK4d0DVjcPQt12MA5k7iY7y/duR56FLESCkFXZ0Z1VhbnIJhGvoF7l/T0Pv3FaApnSSbsaEj6yceR862Gtjt6X9T5my5PsFYGKDgpsKi9fQhPeFWeMn7NhM/4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980564; c=relaxed/simple;
	bh=nrbc1RyIELdAPP3GImiMDBkINENaWMKBHh/R6n7+JYE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ue1P2uP2VWECIBfPRSXZu6+/jP6ZUxQUFR5kXVJKFPANzaTVW+Kn58wxl6/NB1MDwbRtJaCtER6o6IvqI2x0Gd6qqlJa7s1T7RG4cWGPD9Sh6Y8eHOFOSDNYa4RCjWoMqSzOHYhSUis+3oF27GyOoBSpAhYLMRnDaYsuz2NUjvw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bbm0g2Fk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bbm0g2Fk; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bbm0g2Fk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bbm0g2Fk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=w+3XMPa12JIrTbuNOTkx0TF+KDFguDam7naFuWnwAineO4STCRiZFYJ5kDLFKqtoD7S7RfmNSb5r5OlUDRxb7RldwE610yDHX82ATdm4Iicwcl20wy3hnH5l8Us2/VV/pVI1GvLy/g41yvGOW9gHm3WVbxHMcEbm83x6vrPscnDdm7S4/yEQbExMcqpWnCeAjzSNB11S/D5z6UMAoNQxjOOHwc3LMUMq/r3tx7GSe8x9pzj83aMT5QomTtbTx506gu23ctzrai4uuOlPao1szWutd8ipOMHabbzM5YTGs9FsI6QHgPKmUYMabGLrrYIbEZcsgl8fyTHkBSu5gH4dng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwDwjOXnjd0nOQAOdjNOQ7qlhnsPeu6wZeavDNKEeyk=;
 b=NBrkE7e58SgK72ctVfrPiKzxv5zRbNA1SxRZSE0xq6MCYHCNSCC8G19AEOY06FEob9/I9DQ4SiofL+11KrvhyX8JwIn2d74kHPPIJoC29crAoeDwPbcRLrkho6I+gs82Cge9uklxSvW9iECg5hUT786rZ9bnKcmHhxAZne6Czdn34RCUX3OZpHuOvLauXgfdXIuhUnH934eSkhyX3Mr/Qm/3zNnLmZhUlN254UAj5gLqyE4mqEDjqkQH8NFVCCkGeHvOxuVxHYr9FE8kcwr0XM+Cy0NAQHO+jINqcKJvDe0euBPr8aUa1g9AlTTZO88iTP5keSd9SXzCGTL2NHTH1A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwDwjOXnjd0nOQAOdjNOQ7qlhnsPeu6wZeavDNKEeyk=;
 b=bbm0g2Fk5qY5TmVWQ+Igl1LlTYQXc/lYMWDKZXEwXNukz+6Bq+ldK8Fe605Kd021fpDR0sJll+V9/J7f/di3oHpzc4bCo6AUo61iKTozntSFsvLdRSWal3W0HOhnXYv5nMhttHdR8jqWgJsfcg6zzQ2f1RzXF/wmJjqjG+pkcLw=
Received: from DUZPR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::6) by DU0PR08MB10359.eurprd08.prod.outlook.com
 (2603:10a6:10:416::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Mon, 21 Sep
 2026 08:49:18 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::a4) by DUZPR01CA0081.outlook.office365.com
 (2603:10a6:10:46a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Mon,
 21 Sep 2026 08:49:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Mon, 21 Sep 2026 08:49:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K17/b0QluxoAN0SnvCoNgMpjgYUlVEHOiAyVavoUBzdlURedKGAJ++BiG9W3FFciN4M+ffX4mdpWoeCTPtquCmvTvuiIBBVF4u+7bUUJhzv0+jyE5uTKkvSVjVrEkSiFOdDQNb5KIsjiPksSaXKKAcqUteXryy/v/zXnzqeCFiFkqTcJH9mMZ40Z9rZSh76I6fu9vsmIHdqqpoHmqkR3Mnt2UGsSxmK0MF/Yz5jeIcQ9yCYhpvLfR541oUqcSfPWt8AUaD/i6LqKcb6DKM3d788lL32WzuAeX/+15n0HrICEG+E/t/FH7dUF9eiTh4yXnRFpXgEIsXw7k7Q6GUQvRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwDwjOXnjd0nOQAOdjNOQ7qlhnsPeu6wZeavDNKEeyk=;
 b=rDySaf7vgDG9FSopVE4wR03sh7u1cmNX7iZwuHI63rZ1pbdYU+4t4J6TuZwx/VFFrdIZ0vITtG5Stj1sjpkF34uEc1ddIyGA56XWNCyWn9njTAvlC4QVw62WoUjWM7zD+G0Hm772QtjmMtLvMcS0KjXMRNbdrAf8kOQJ5sbfY18U9TnwdXFXAoAY+/N2pSKRt3zCOPbjiIHOMY1kVPV4gCX9f3XcBzhqyKi7CCwm9FjcbB//qzkV7GbCsklkKFGmUN0e830xlrUbqu83oOefl8cw0TTwRxpq3iWzd/yBQD6MBu9uiXGcna+a5+l6xMdHbu4nPlREwn8LPZ6f65bGSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwDwjOXnjd0nOQAOdjNOQ7qlhnsPeu6wZeavDNKEeyk=;
 b=bbm0g2Fk5qY5TmVWQ+Igl1LlTYQXc/lYMWDKZXEwXNukz+6Bq+ldK8Fe605Kd021fpDR0sJll+V9/J7f/di3oHpzc4bCo6AUo61iKTozntSFsvLdRSWal3W0HOhnXYv5nMhttHdR8jqWgJsfcg6zzQ2f1RzXF/wmJjqjG+pkcLw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM8PR08MB5697.eurprd08.prod.outlook.com (2603:10a6:20b:1d7::24)
 by DB5PR08MB10137.eurprd08.prod.outlook.com (2603:10a6:10:4a8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.9; Mon, 21 Sep
 2026 08:48:45 +0000
Received: from AM8PR08MB5697.eurprd08.prod.outlook.com
 ([fe80::1578:61f0:5e16:68af]) by AM8PR08MB5697.eurprd08.prod.outlook.com
 ([fe80::1578:61f0:5e16:68af%7]) with mapi id 15.21.0451.004; Mon, 21 Sep 2026
 08:48:45 +0000
Message-ID: <2c193adb-5c84-469b-9499-1e9b54066e87@arm.com>
Date: Mon, 21 Sep 2026 09:48:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0705/1191] perf cs-etm: Flush thread stacks after
 decoder reset
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 James Clark <james.clark@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
 Ben Hutchings <benh@debian.org>, Salvatore Bonaccorso <carnil@debian.org>
References: <aq-D15YcGtltATrG@eldamar.lan>
 <2026-09-20-daily-reply-0007-re-perf-cs-etm-build-break@kernel.org>
Content-Language: en-US
From: Leo Yan <leo.yan@arm.com>
In-Reply-To: <2026-09-20-daily-reply-0007-re-perf-cs-etm-build-break@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0148.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::9) To AM8PR08MB5697.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d7::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM8PR08MB5697:EE_|DB5PR08MB10137:EE_|DB5PEPF00014B9B:EE_|DU0PR08MB10359:EE_
X-MS-Office365-Filtering-Correlation-Id: a2377389-f097-48fd-d882-08df17bd3903
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|10067099003|56012099006|6133799003|11063799006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 65XWKv3tEbe8tiK95Yj/A3HDCS85QgxRk1y9RNPIgmRrBo7nuWyhG13JItEcqZrbIXl9bBNROryhIT74kfHOGrtRhiQvLLDveF6oJA/AD7IWQKzBle8AM9jc5gLDUrBfIkMH5vFLTMydT2r4Ezw6U+V77bv9l8f5IWAeztJUGNJAPOTM49rKIj1WA3D2jb8TXDoxq+NMAvjW4FLMxkgGcx3a1A2rav9GxSu/EyRfudXZuzSbIOBkN6KnkEyNxv5Dw6/VW2iZtuRU9u7O7rQrlf12ghMZ//qKdUzRc380rF8pDutCbPkFAUW3f+3EpovIMSj+YcN7d8jj1rexViB2v1ybZukrSYjfr7EPgkpKnDCSxp1VVPJOftSFm8pJi/7Wsx7WA0mA0e9glfYU76ufbabD3IRUiYyGaodY2ZrJN6qeorSNdLAue41AugG1lEn+JDNVuurmULS7+n8aKceYTDdG/nHD2bxSsT5sBAqRTZpm+mmn6KJuly+MS7UlUUcZybFCUXC0aPpAsuLHgaRTDitlOALlnWdTqAQNC97K0G7isUvjdisxmaddkyZHVteOF5BKvTk8E5VxiAaIoEurdTC3dGwCwbrtmuxPFB2hrM18StIovXfZTp1wSiIyPyGcSfDwKhip5JUCh2dYNfDi9+w6gtVTKJwc1BgifZU9M+4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5697.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(10067099003)(56012099006)(6133799003)(11063799006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dAngDlqPGSgj9BeuYJkZPLxmrEU/uhURA4cW+1OBd7L/WRuXA5c5itFEjWx88LXVJ0P1k7TgKTGJpzzXJvwFEAROZqrqzd2gHk6seItxbCuoHKxGsTNDeg2x6Da975FIpG0vWfsFp8KYmBg4L5bgVNgakRrR1+FiGkKlgU/4u8fMEDKXK4bfjvxeSFVGAV/ymP91CY+Zg4Qh8XiArhWhv+94l80qLkMa8wQ/goBmiZwQpedMlJHAjhyKftDjC9EoIvExRixRRvdg5S2vSLut4J1UuRX+1BriP3oWNiMKtZzk1XHEyWbhtnq1cxwlwOXDpQ0jseaucjxOc2OtptIWjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10137
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ae555ba7-ef5e-4c82-6b1c-08df17bd257b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|35042699022|23010399003|14060799003|36860700016|6133799003|11063799006|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6h03joYSd/UbWTPGa9q9FQLi0fVbmhaZaZ8e/t9ChMF08uZrbTRNiM74vsH8+Asgpd5tIFlkb6Z30YgSnwUTuGJikdF2vtF8xYkK4XDB8ugd/zFT1xlAAcWlZ8l80zK5fIvCYhcKEjnWheJrSlFYTXKke83nVW4Pv52X6ELBfxg4Uo+sThKtBik/kXRa2AG0vVOKKK4KiDT8IWIvWPPzy4QE52qopjlr9PooDlbML9c46QioyU2YbImcITdz821nSWV2SYKqVIKEzNphPqkgAYURcwOCyQ5KsSwCF0GVixnTIvVjkfBZ/1kNuXlmfxzmVIMw9EobPZxFfahLQo71wJITwQxsDTMu7X/UBQHT64n2SlZQsNQAcabM5S6duRe6P+ucWa1jRrkpCigeUyDbfxOjMOlSqLievUFRYt8O9LA3ENKECi29RAU/lYZCQSuyecGOf1F6Fg+mngBgxQ8QsflkYbio37WwF2OnZTIp1U8YRSyb0897ZRu8XqA6xg6O64wyzvL8K8V7MbeQ+Rjjj55jSPTMi2m8ikKFhPzS19y8Ec+n5p9Pdn/hoV5eGCu4Eu1JaJt1wAglk/vQr/XRhpUCKV7hy8yk0wWfs7KkGIwBodOgb11D883PiEivpuW1gf12HfCU5UutIGObaZMWhWPWy6JBbXLW7ibAHKGGvAm+ensMSAldzABKga5hT33wevpI+I2fH3WTD4nxgfRE9g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(35042699022)(23010399003)(14060799003)(36860700016)(6133799003)(11063799006)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EzYHwH3Au5yr92jGAhS9Qb48ciH9LweJ2KRKjdRWw0H2oWD8yufBZ6QDagKGFr1qhrB8k9KMcQk/BmtdOC6FJcwZDoeS+avcabi/OytCFVRJQFqOi4u0Kdarvuu0ST9Ac6CdTPwXw2+B3CXWMtkTW2qTliPYHVv9c7559V2URtEme9o7bSQMy85v70c0fWwslq4pZf3WHc2gOM9W7ZoKA8hu25RS8lIuvY7P/6PzcEu3g6uazF+mJA2wHZR8QuTx2N0cEjcMhTtuj+egHIRTjIwJ0whB8os5JdpPkiyErlxYrHT+IGPIfLILdREtKKcPhMB7+MipQV9fP+K6/mFSp6eOdSVed3J8W8EfMwQSQLZkuWxAvH3DL1a+St3Jr9cz+8JsHg4ZvNewUVS+0e7nY1a/lgST45DNcv3YYdDBdDE9Kxlxe75MilCOhByLoXq5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:49:18.1748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2377389-f097-48fd-d882-08df17bd3903
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB10359

On 9/20/26 18:50, Sasha Levin wrote:
>> util/cs-etm.c: In function 'cs_etm__flush_all_stack':
>> util/cs-etm.c:1656:14: error: variable 'pid_fmt' has initializer but inc=
omplete type
>>  1656 |         enum cs_etm_pid_fmt pid_fmt =3D cs_etm__get_pid_fmt(etmq=
);
>>
>> Not sure if 5414b532611b ("perf cs-etm: Make PID format accessible
>> from struct cs_etm_auxtrace") would be suitable for backporting.
>
> It is not. That is where the enum and the one-argument cs_etm__get_pid_fm=
t()
> come from, and it conflicts on 6.1 and 5.15. 5.10 has no cs_etm__get_pid_=
fmt()
> at all.

There is a dependency commit:

  5414b532611b ("perf cs-etm: Make PID format accessible from struct cs_etm=
_auxtrace")

which changed cs_etm__get_pid_fmt() to take a single argument and
introduced CS_ETM_PIDFMT_{CTXTID,CTXTID2}. It landed in v6.5:

$ git describe --contains 5414b532611b19671cb10813e5d56e011574d698
v6.5-rc1~18^2~123
 > So both cs-etm commits come back out of 6.1, 5.15 and 5.10 instead.  Rev=
erting
> the dependency alone conflicts; taking it out together with ec99be8a31db =
("perf
> cs-etm: Avoid truncating AUX buffer sizes to int") restores the pre-serie=
s
> cs-etm.c exactly. 6.6 and newer keep both.

Makes sense to me. Sorry for any incontinence.

Leo
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
