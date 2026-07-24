Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FA643E9FC
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784904235; cv=fail; b=NvBRMouOmyO+DwoAi3pDtHozda3huZy6C35FYGrjOfbTEJj6//06i8M3abWq61fuAr/i32/vBLZ8fwlbsYBIL+lBYCMhPgCNczsW93H1d5HtQmBC1UNVS7T8md/H1qndnutry03gCOli3x4d1ulkHA4HmRaDIBTtNAkkhAPgJQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784904235; c=relaxed/simple;
	bh=kFJZ1jym3gf91iX3Mqz3vj86nT3tSrkLxVN+ZSvy1X4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P7y1oLhzKRgHuI85mPQ8gofaBFA8vdAVA9RGJp7UvT3pJEYdiQqnhmGArOfzF7jjBVohIQ27ePb2I8prEN9pcSvmw0LP7dy4XqQOgB2mRN8tICq/wpxBTNQFc/CC7nLbOWJsU98gkqA0X6vdb+pFFmBg4r6Cm6xHeOTZoKuQEtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ijVwga+5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wDLpkThi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ijVwga+5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wDLpkThi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCtpWM3347050;
	Fri, 24 Jul 2026 14:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/11ON1NN//soKsqt6gulgri/Z5bhxHHLYOMif7tbaXI=; b=
	ijVwga+5/IKrUMRkt7efImWwl4480GTi6C04CguGnMH9c3f/J+4JPM1MFVi3ti5f
	260QTJ5RMJxdpLTwhNdcVms4VjSXtH41REXfdn/EG+ioIqI2ffsSyiz9m8lUlZZD
	xxfuEkRCqiP2MJPLlx4Y87yoW1ZGoAQ7WsYQTtUTU2tp75bG+cbz2uTlaDt3Jo8o
	Z2Rhqf0lxsSym3mIh+AxfsjYAitgNxU9eJO79ZWFuUdvbod9KrlPkYxk6WP88zjJ
	SII44ivMQgRXlqd2YlHmShAmis+qeBxgyf+srUfWd7qYNnr8HwvvwNoW1Kuwwpze
	jKfrK1q72I5maO3ksMJHtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv8kqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 14:43:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OEhQAV037961;
	Fri, 24 Jul 2026 14:43:35 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts2c0uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 14:43:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mup/YzzJDgig5Tan38YG7CcypPivFPqgyGym1aUXy2+R6h+k7h8Pvlfqw3o9Hl/SHSSfY5ppiUER7Wvw2IvtJ0YycQYd9tcNVJBfklNVj4PuuQLQVxK5+6qWl8FcsLB4Hq0fxMmmIRgsNfAyAfChdTulJLv3obMIOr3xL5arl0X0ERpjouF/rDwuhUvZ4siGi3/33ROZAJZL34fNE3Qdk0OD63o8RrhsRwsR0j5vl2oW/JKL50qqYzlJjROMnopP9qwbx0vDNx8WzCtQU8t1i3dxvI+H43oJEu6DebqBYkzleRAmj9Qr6C+8YS7F2RbRl3AccQdIELR5wFbNCRPfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/11ON1NN//soKsqt6gulgri/Z5bhxHHLYOMif7tbaXI=;
 b=ETm0pa2wpt5uaHRHmWQt5wIplbKEEc+CX/LgJ0OLuNFzndZAn7mHo1u9x48QlCWkS2KI2eJqCFmLkJYunUxLaUC+eaWQzLT6Gy9BELR3lhPxo42AY8TJw3hJf1r51TmDWBpJzXtlWJuEaOLXQS6P60l343OS/p6waQ1h9rD1sFWdhsZz9W+W7a+KYLrhDlxKZarfV1vuvLTwPt2rWJtWQFEI4mvKCkz2AtbnlAc48M5RA3OvsRtBhmwIthKJW2TDd3CTjdFWOoK0yf8XD4wDfktAj3N88EtGUX2q/wKtiKn94WunxLrcJLgO+M9JsNP/smiCmMk0pW7yI5ToEM17kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/11ON1NN//soKsqt6gulgri/Z5bhxHHLYOMif7tbaXI=;
 b=wDLpkThijuH+yf91jSuqNb++ljLivP06mAmkHhb9U/P+6qZ+P3Gfji09QVtJX3EmXk5afOPOA5cosVWx4gNnI7frQZ6gkWntgqiDX/KeaxFsOoFIsx/f+b9Xn1jqgysJaSMykCgXBto11RNRL8q7qojDYyifcIVRJWgRTOhdJuw=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by EAYPR10MB997805.namprd10.prod.outlook.com (2603:10b6:303:2c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 14:43:19 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 14:43:19 +0000
Message-ID: <fe4c6d82-b1d8-4421-b581-3ce231798165@oracle.com>
Date: Fri, 24 Jul 2026 20:13:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0588/1276] ieee802154: Remove WARN_ON() in
 cfg802154_pernet_exit()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>,
        Ivan Abramov <i.abramov@mt-integration.ru>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152459.274067910@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152459.274067910@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|EAYPR10MB997805:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6273e9-334a-4c30-f7fd-08dee991e739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|4143699003|5023799004|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	v7ZrivD9RIWkXomX3ERwtUJAFF/pmoouVSBPilySDqSe4KxZIm9x15vW/tbliZpQgFl5MZ8GT86PvZ0mC5Bu+LXGX2qEQmvdSXoykQuNn07MinXlCNacQeOqzfit9F/pj0HKtw+0qWhtlIZIypxJUTU0kOH/y0avcphyomprDQjTRHHl10dMzi0V4lZg/Ya78HYL4jaa6/mR1EkVucAjAXYePMEvOnycDJLsLLqkc9XKpBXIR5A0r/gWe4fS1kcpHdgLY0LCEu7JimGmZPt4JcKuKfbKYTtIq93u/6quk+/Ay+lsYTJaMQgvVkyz+qmJYVrofdHZTSwe14XoMigkUNGt+GhRkArBDZcgQZMoCbqQWaWc6FgwmPFOpc34KS2Qr5BTtH/cyfi6rDsLRM7fsuIu1aY/LqszqRHG4NOfmtlZOCLeXvHXevFokg9ykSibxvkoru5kKDjdv2FX2CrIV19Xwq7j7MnsYy4e1mTCEiCdRarAeu2eoIyz+YGgjRZaLW/fmcKxflo5jxuqjryGKjz7nf4vP/dTnq8IxMtwGeBQUKKs61zgzvzYZNq15fPHykHtXq2lO0WXRpd2fUNptUdquDrOw5YawZ1h3E3QLz5DKTM8cqnDOiOhOwKZpmDf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(4143699003)(5023799004)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlJYZkFFWVRVMVVKcXFhdFdTMWc1U1RGWmNmUkl3VXlYWERJOFF4aHk2bTls?=
 =?utf-8?B?c201Y3FGTEgrWkduZ0hIZmxyakdYdnNWZjQ0V083QmlIS0ZXeG9PanFqbFJL?=
 =?utf-8?B?VEZGaHRBUVBLalpXRHJzaW1vMmUyMWttTS9EWjFmOTFmQ3hvb2pxK2VhWWZI?=
 =?utf-8?B?VCtUWHBuWmpLNHpxUVdRZmN3N2JhYml6NGk2YzZaZlVLa2dGa3llcEFrR2Zl?=
 =?utf-8?B?OHNwTHkzc2NKNGtTSTBDclhvNkVhL0JwZ0tzRlo5NndQdnRHaVBHNzZoSE1B?=
 =?utf-8?B?YnBvZk1qZGMwNktOT2FtQWwwVTdCOGQvaWtyL0pCOElxRzBGRVJhTW5ZbDZq?=
 =?utf-8?B?amJ3cVFhM1h4cHVKL04vdDd0ZzJGQkFMeUtXVTY5RHpmMGZscnFuYzkzRHMy?=
 =?utf-8?B?UzU0VnI5MTFSNUdKYmdnT0Q2S1ZoME04bmFCU1dPS3dTM3BaUzRnYVZmTURq?=
 =?utf-8?B?UzRGUGhCdkpSYlNZdGlBbHNKb003T2YyR29Ga3J3ZE5kd0dQMlYrVTkyWUZV?=
 =?utf-8?B?ZE8xRWJOOFpvMDZzSWZLUEk4WUR3bWpXcllvNHhWcnYxY3RjazZrSzBzN0ls?=
 =?utf-8?B?Rm1IdTJVM09Ib2QvbksydDhJM0tQdGc4SVh5Q0lqRDlYUkNGYmNZWmY2bmZ1?=
 =?utf-8?B?aVAxS3BYN1VoTDh5TjQ3VnVUdXhSd25IYlhVTDQ3OUxNSnpDejZsSWl5Yk1Q?=
 =?utf-8?B?bW5xcVRiZ3B5NzIzcXNLZytJMlZCekU3ZVZhODZMM0JmRzhqU2Qzc2JWU0Zy?=
 =?utf-8?B?aTlVZXhyZUFOMUo0WW9yb09WMXpXZFk3UGpOS1lIVUtxRW1yaTJxRlk1N2ZI?=
 =?utf-8?B?UXBDSzhvWXRlZ3ZrS1psM2NZSkFGUTBTNndnTUxWcWlXM3lOdVVvL0NNSzA0?=
 =?utf-8?B?NHI0MmhubjBzRys2MGxjOGpKbGZHQzFidkVWcVU4ZVRZdmxxL01zY0FhNHB2?=
 =?utf-8?B?Qk51K29zamN1aWhjV04ySFNzSGlHUURuYnR3dGNnSXFPRDU1VWpHd01hM2oz?=
 =?utf-8?B?czA1MS9CTS9ZSzh6RVlOUEQrMkRZMWVIRWFuY0J2RG9qMFhMR0F2K3IxTk1K?=
 =?utf-8?B?enVmd1NhRTFFQnpsMDlNRlQ3MlZVbllya0lLbkVmTVJVdk5WS2Q1VXFwZ24y?=
 =?utf-8?B?MTNRTFpUZFBQZE5rQyt4OURxY1NFZXVUVVVVL0FtRFNRK0pRRGRISms4SXZ6?=
 =?utf-8?B?bzFLbzV6TkVnNzdHUEh4UUswQVAzWmJRdmkzNHNhTUo5anB5ZmRoczFQQTFp?=
 =?utf-8?B?THhEQWRYVDBSY1pTRXNXWVd3SzVqUGU4blUyYUdIMEQ2aStHMERjUGVicDZs?=
 =?utf-8?B?bXF5N3cxcWFwR0JNRmJZV0h4QkRTbnJmZk1odkNRSjFlOWsySnB6MWdaRmVJ?=
 =?utf-8?B?TTZiNExyU0ZRSGF0K1ZFSFhPV1hzMjhhdEJxVi9DdjhxWFk0cFE0YnA5L0t4?=
 =?utf-8?B?U1N5WmNCQWRPRXFyOE1wMmtZWm00UVFTQU9IUEk4dEgwaVNkRnJ1Y1IzSjg2?=
 =?utf-8?B?Z29kdnBUQzhXLzlOSGdlVzZwODE5N2RZUjhaR1E2dTl6dmR1TXY2RzhOMmlQ?=
 =?utf-8?B?S09PcEtzeTVlQXIxTmZHZUZSUXJpYWY3cXUxSVh3K2hxNVRMQUdXRXlDYmRs?=
 =?utf-8?B?TG1hSmZqUlZETitsbld1VnNpNm1ENVF3WWZTQktsWEt0dThOUjJXSXZtSXkz?=
 =?utf-8?B?aDk0eWxXRUJsQmVLaUNvTGZTSEpLdTlzU1FkbkJVR0kxaE5oYjFLdUxOcGV1?=
 =?utf-8?B?ZlJ5YnlrT0pGT1FqR1VuRWw0SlB1elJ4T2RGOTcyeXdFcjVXV0Y0ZG1LaktM?=
 =?utf-8?B?VlRvMENNZFBqU1BJbjdmM1dpM0dsRDdCbElXV1o4a09RUGZnNzFNYVFvNkdp?=
 =?utf-8?B?SVFUczVZV3lUVVpJWU5SSnJCUC9mcjBZOUpiYy9zSUVYeW85NHJ1MUFpTGVS?=
 =?utf-8?B?Y216K25MQWd2NVdSZjZVY24vZ0RyVnBjajkzNmxaUTNVaUdGQ0lFbTZaczZr?=
 =?utf-8?B?M0lRRnp5T3A3MnQ2YnFJUXhrSDlGeWl3RVhyNm94RS9YT2E1TitmNEs4Snp3?=
 =?utf-8?B?L2VEQ1FtMjVaRW5NR0RpLzlpZEttLzFtWTh5SHB4QXdMeDFRTGMyWnBYVklW?=
 =?utf-8?B?NmdTS2I1UTFpaXZFWkp6V0RtdXBXdGJzTHRtMnpJcFdhOU1YMDJpMUdFQXdT?=
 =?utf-8?B?cXBxZFg2SldpeTFRK2doWmdBcnV5cWFxMjZ6RG8zbUUrQ21qeEFyR1gySFZ5?=
 =?utf-8?B?ZVV5ZmYrTVdKRjh0a3Q5WFA2VWxCVVRXZ3NEMTc0dTRZN0RSaDFQd1F3M3p0?=
 =?utf-8?B?bkZjQ2JhVkdiVHFXUGs5MXVTL3g4QzB2UW5BVUZVTG9PQ0tMdFhjQ3hDdzJG?=
 =?utf-8?Q?IUEr7yXZh+kzVv64SuhH7GCWqu5SnJaNLO6Lg?=
X-Exchange-RoutingPolicyChecked:
	sv73VcJB6EydVZfdBDrald0H8UXcc7p7xuG3g5ytgoqHDeVG2bzMbzn91yyfXCd2TRH9Xj1dfNLSBfSVPvysoNs5eU412k+5b/P5ZWyIbVIBMW91ndQ2e/+zX/IGcKO6Yr3zO37yl9zlApvEu37AnNQAb1xAHsHC4FcX0p8VtkdDZuJCIC23VpLcvZxHxSUxnQ3nJn6PY6J+lNgcKz1or/CDk9x3sGeSKnlKSW7TEUsYZfFWD9ncUhaAMgCnL8gX8RXtLKf7isb4t0mHTMrs5M3ICLzAKky2TgYH4RxHyj+kGqX7slE2MKuLOy9szlgWXMfBIdaUXz7D82x7rznkNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jhKPy/PTP0GSZwYQFecR8pSpl3fG8I8ZS6cVNidkCCVkO3i1HDfxHEQA+t4SCgio7tQGCmOwtg+oveRk1MTnoTQQHMgRalX31QN+nmE/FLfqcvlyG2/D0ss+MUb0Xbz1uDzbG/9mO8cV4gagdpzOKHg0PegWKuAlAGh4szZlFtqq5EJM+VZpms0Q6vvkzTojzTE4N+mfIpURTVemaZEA81t6uP2sNasHP3ZepHd3SBp7X10p60OYh2oByg48xEF++oyP6pB+xBmdsE4J8eHJx8JzcQoWTVUykW2a9FJLg5CaK3nbcBdqhnOOhVtvX1skHyE2YA2fIFB+0Fc7K4H3fYTrQaVzn4qIfLoC8bnPSrgjveuQZBbwMgX/zDPb9B0es8ooRwG7IHMRzRarAKUc2qH0JPEWpE6gV+KJXfz1vUlquKg/EWijjUisUbvpm3uive3S4mzVNDxSlX4OwC3K0MC7OtRvN7+U+ogtxshMtMWBdqUWQhS1Kjm5cu50rdnfCKpdIPdntnmN5XERVZYQNgAX4qBJeoxK/bQNPAqEE8mnbx6/Yn2u/rnXZ8IbzW6waxvbQyYnPc9hV07MsyOYUuJg0MktBEGb1Zz0koA7yC8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6273e9-334a-4c30-f7fd-08dee991e739
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 14:43:19.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAR32HHcZwSx78+38NknmRuBv/OrhvRTMII3nmiKZ3f4Yi39XFcCYOGjRM9Ju6EYYcxPUyio0FcgQb2Tm+WczWA90Jp010z1ilM3CFNAil+BAgAiYRXlITP8JS4qnoqc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR10MB997805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607240133
X-Proofpoint-GUID: ZJ9t__mHt51z-_ydPU74oglKLGv7slJC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEzMyBTYWx0ZWRfX0+GInvvKWFjz
 atKTveQ/kbikM8oSNMN0lrHU1i2+G8bCd/V0qmqNljpZUUY4U+7bzgNSOe2bQ8kQ5/QK1zpY/Wt
 Cy3Eaibk250q0C34uzyOz7oWo3V6xe826+rngufZjzmXxEBVsqzX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEzMyBTYWx0ZWRfX4oiZ/JlKbl6N
 st9S3y+jf2rPOBJuFUvNCuzdxVBmoudnBYpOzpXo7Tlanw0zsz9/vSPcNmUG2khABsJOVg5l6yu
 kfCbBhoLLSsPY7AArkkLTmR3C+68VT615u5AaUk04qhfCsMpLg0j/Ng5I+m43eRBQiZehteb0b4
 MG0J3sheixM8wHx18J2sWUy8mI/z5a3ujQ16+ztaLT+7KKyPUxvFnWU6UOnpfd8cdwvCae/5CSb
 uTKTuJnt7E4U7qciFE8Ues2Umh23z5naQ/HBJ+EOtb5DdCsDCi6jLZCpX9GMO5Mm0c178Nw2Sms
 q6J0tPz1N6hALrccocE2q16d6CzqaNVYWBWyT2vYC0S/74eBMRZVBAdvK15VuuW6cTGSe83t3tM
 61gJrk+lukupO2FuoPQeaxIKrIc/ygAjt4bm6f3vJ7nq1HbJZ2DNiYWDjadv2438nvYEVWmmDXx
 9Bgo1dtCZv+tZpPKTQQ==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a637a18 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=uITPnen8AAAA:8 a=HH5vDtPzAAAA:8 a=P-IC7800AAAA:8 a=sEkq5x4IAAAA:8
 a=VZk21wkyCYamWst-YiUA:9 a=QEXdDO2ut3YA:10 a=_LYzjdIMAFgGI_5-19D1:22
 a=QM_-zKB-Ew0MsOlNKMB5:22 a=d3PnA9EDa4IxuAV0gXij:22 a=llby-PD1hR8gYtG5ERSV:22
X-Proofpoint-ORIG-GUID: ZJ9t__mHt51z-_ydPU74oglKLGv7slJC

Hi Greg/Sasha,

On 21/07/26 8:47 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ivan Abramov <i.abramov@mt-integration.ru>
> 
> [ Upstream commit e69ed6fc9fb3b386b5fcdb9f51623f122cee2ebd ]
> 
> There's no need to call WARN_ON() in cfg802154_pernet_exit(), since
> every point of failure in cfg802154_switch_netns() is covered with
> WARN_ON(), so remove it.
> 

that's not true for 6.12.y

I have run an AI-assisted backport review and verified one issue with
6822cd462aed ("ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()").

Upstream e69ed6fc9fb3 removes the caller WARN_ON() only after
0569f67ed6a7 ("ieee802154: Avoid calling WARN_ON() on -ENOMEM in
cfg802154_switch_netns()") adds warning coverage to the initial
dev_change_net_namespace() failure.

In 6.12.y, cfg802154_switch_netns() still just breaks on that error, 
while the backport removes the caller WARN_ON(), so a non--ENOMEM 
failure on this path becomes silent.

So I think we should drop this patch for now until 0569f67ed6a7 
("ieee802154: Avoid calling WARN_ON() on -ENOMEM in
cfg802154_switch_netns()") is backported. Thats not a clean cherry-pick 
and needs adaption which I think we could do later ?

Thanks,
harshit

> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 66e5c2672cd1 ("ieee802154: add netns support")
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
> Link: https://lore.kernel.org/20250403101935.991385-4-i.abramov@mt-integration.ru
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/ieee802154/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index 88adb04e407220..4a4379c828b90e 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -351,7 +351,7 @@ static void __net_exit cfg802154_pernet_exit(struct net *net)
>   	rtnl_lock();
>   	list_for_each_entry(rdev, &cfg802154_rdev_list, list) {
>   		if (net_eq(wpan_phy_net(&rdev->wpan_phy), net))
> -			WARN_ON(cfg802154_switch_netns(rdev, &init_net));
> +			cfg802154_switch_netns(rdev, &init_net);
>   	}



>   	rtnl_unlock();
>   }

