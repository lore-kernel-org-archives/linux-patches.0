Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA32A933
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751872; cv=fail; b=KXmHw2mLCiGlHFZ0pyUki8Io4LqVTvwGt3pQVjnZn+SsourMQk/u0Knrgi/fWT13PbWIZhgSb1LuPVK/G2+7TmIxmCZlINZbqo4uHuHF4aA8CZWel6dI5LDP44g0ofPRb4CnHkZGxFhMMA2koMfa3ECoFDCnQIxqgjOWNQ7YTe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751872; c=relaxed/simple;
	bh=LDRXiDwK0AdfqdKRI02hrJVYv50MSksZfQGZMgyiuU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jw+oJGkCuqOPqGv4hMH/lABQPX64aSXawYuP8+zH0NWYNNe5XJqrr3WmhV66UoS8R9pmCOaliYy9+iBNZlcKyZtYrCiCTjSqQ9y864yS47zIS/WK1rm8rjhirjlxSLSIhAP07ls/4SCkgyVfLXSpVASKjUUqh3nYnhaQ8T+GemY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cw2bOb4p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qKEwFUJd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cw2bOb4p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qKEwFUJd"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579EstlM020115;
	Sat, 9 Aug 2025 15:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pAn/eNo3XYu2Cn2lPTL51MWyjGTTVvQJL5SxN94dcn8=; b=
	cw2bOb4p2ipPXQi8SqiO5S9DZU57aD70qBsE7LYKfbjsSIS8NCfK41xCFQLO0I0m
	yS1vzGDq6ULSDEXt8F6Ghb1e3aYoXlFqmCeClvYzr4HrqU2e7pNngo/WzbJYiQMS
	iMBZ65vt1Bu6DssCqmWhabztDxBYjSDC3kRi1Qmvt9R/42yyTosE8zPo3LXa6XDq
	Lv5HBN1GcIyBAQvRAP2IZlJCoiB91nT46+Lej7BPt1ZWeiIAlg6w8kqYqZd7I8Zi
	ZyCjVlcxBIryEVdAJdfD7xvrDe60svsfI58Zwrfx7GEHIpk0EScQA7OZsAZp3d07
	V9c73yxYuhfioYaHc4oJKQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv0ak5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579DVFi2006366;
	Sat, 9 Aug 2025 15:04:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs6vtaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDTHLLV8tozgVdCUihoWhVZF3OP7oZp+a4a/uUTx5VMshDoxuvO41x+4mtiLdMwRM5XhsRouyP3Ki6a/YZl5bk7W0ila9dvKaCuhkg/W2Kac2Xd4xkreY02O7Pp24oKuLpU/Hx/bw2gJPZew6ECQD82RDkUqDFKPmFB4XvHj0+bQa/YF1/SEk16RElXLMkeDMEXYQ8j8wKeMEaxN5mLASc5cSKSbeCn4QPe3A+bw59+Z4EBHXtoEnWg9KGAfZ6QUBQkCT8CMdZexlteoS3PHKiCK82uJcfp11ZI3lZiVzqL7FRVJah6OsG7OVqRmgtuDsDMGoD2285pENopDBtztXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAn/eNo3XYu2Cn2lPTL51MWyjGTTVvQJL5SxN94dcn8=;
 b=q9ERx8z0VEcIXwyDwR6ntCG/dvi7O4pYK+9PW7Vz9rMVqpywrkz9RsIWlG2ewEH7mXX/H89COYJZwyfnTuMrSyDcXoWqXh+WyCzXny6FDI4ldtof+elncMzhOvvIEbX0PyTnSjj+LWeJ0n21GvBn88ApuQhT+eJwsHN6aKj8Sou+ZYhXi4UYIyfQCWhTE0BhjLa6RHiwOWBVO6nSiAvi0afS1B9GpMihjO/PjMRzZ9+LKfq4Jhvxgzbz8wI1pPVWjDSDRGVEsDoxss5Z6M+1Y/1bG2w4A+Yf1rbhyGXMrJyMaBoMKABEl/UgMQjOCp+igef8K5QVnyAT2b36xF+a4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAn/eNo3XYu2Cn2lPTL51MWyjGTTVvQJL5SxN94dcn8=;
 b=qKEwFUJd4KfVEwefWfSdOGJT9wKhibnMPOVUdrgCY8TAAIj2R9tMfRFwmOMhMyiQ0LBGdkX3bNnE7I/RddElP6wAV5ZdN7H0WDJVDLe3RthsQTxuAQvs6ANic6CJ03zuMhAgpcaBqoHHKcfkyDPDYjaIak7TNDvx6zbc77/FSm0=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:23 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:23 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH 5.15, 5.10 2/6] sch_drr: make drr_qlen_notify() idempotent
Date: Sat,  9 Aug 2025 20:33:57 +0530
Message-ID: <bcf9c70e9cf750363782816c21c69792f6c81cd9.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754751592.git.siddh.raman.pant@oracle.com>
References: <cover.1754751592.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0P287CA0012.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: f6079ccd-8b53-4eef-c2c7-08ddd75606ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?onzcyKwO2k+q+01NMC6/tTEzAFTwLuW4+yxE7iaUrBaib5ymBSuqc5RQQNUQ?=
 =?us-ascii?Q?9TVWODG1e1S5jlND5E609t0b8APycSzWCbnL56j1fb1mnrBPYw/5pDis5OWR?=
 =?us-ascii?Q?8+PJGTizaVaBcgtu3RWtpTj0qIxOWIvVGrrpbXJkfwRlPyGL2J7/zC5AGdww?=
 =?us-ascii?Q?/NTEgU+5SWrvOwxurEBP7/GpgL2RU1Pn1bvvQRl0DsKeYRNC/ap324x+Sphf?=
 =?us-ascii?Q?oHOw9tPBadUIhhqcLyg/K06Q5/mySkK8guOodyCp3jwKS0dQGErujIpNLp+J?=
 =?us-ascii?Q?kokbIIGx+u7R/+nQ0nZd5RZXFyrBTgguCithVcjn3S7GSlAp4N3nEsSqv8P4?=
 =?us-ascii?Q?36bpBtI4jAqBFSgxWM5eVOzHa1uauCgOHNBl1yMhGaLyaS14CSd+Icp6El4S?=
 =?us-ascii?Q?hXkRWx7+BjabsNRlByLHxa5M4/n0QjLNV6N46hdOvyMb3xCNHMNyXeoKpU0w?=
 =?us-ascii?Q?Wpgb8BF9qPqobi2bS9pIptlZc3/T09eZnOgl1kH6sqZaZbP1kzmWbucMX/zO?=
 =?us-ascii?Q?7KrFY7mZBiXAjwo5VevWcGRk6wnTYjIjIglhPWfBMfLVpQgP6DeBHiJGzAKK?=
 =?us-ascii?Q?ENhcTezKZcLbOBaI0RogDdjcF0J6A8bTOPD3IBLp55eTl8V3I6jlX/PxCcoE?=
 =?us-ascii?Q?AXNUZpF7pHAmkBhrLJd0R/M/nci96sSjgp36dyVklRSSEAPGFu+IaiTOqkOD?=
 =?us-ascii?Q?bcygi7FeDSm0Yj/QVer/ncGu85dpaHuuLPknlxyOqphQK3/ONgEjCfhKcgeH?=
 =?us-ascii?Q?MH5gNXTDqUDDD4d+RP19XEToU76AuIiU7wT+MSFnaMcMqocAKnNRx2/V+D0Q?=
 =?us-ascii?Q?JISBkZHC2gv3DksyGX4xJiQaFIPZXokOEPmHp7+P6cUnqphJnZ2iZIT/bhFI?=
 =?us-ascii?Q?2zJ1XDRhFUeTqe+4zRugyLDdoQzVyhZaOjdzTfb5WXEo+5b9VSwrVFvBOkjs?=
 =?us-ascii?Q?iPWGfy1BEdifkrWA8/5ATSckKbZn6HciJ09pisGLmKc4rU2T5k6kwHBnmVxy?=
 =?us-ascii?Q?htBo8Yv1uLhjRrUKpTrNA5NEE9GBWMAPXBhmJpffQIDHiJ2MZp52bdPVKwmK?=
 =?us-ascii?Q?pDqAKaWqbGvG35reCJZGuqnsB7phymbS2iIw09THeZV3xWCxskOHltllHE/v?=
 =?us-ascii?Q?qSow4lXfn+ubA8kQKJ5vTP69UwHdIVueQA1C5akiJx0IgQPj7wB50czxTET1?=
 =?us-ascii?Q?RzGdvCxNl1duxFF2V3sgiPGvCSoGZr+S6akdMf7iZE5GYYD/kUloWPMeRf41?=
 =?us-ascii?Q?aABn5YoR4LZXRT6qebrskQ3UNhgPajvg4G8F2BR9Xi8XS9fU9GHhrTcakif0?=
 =?us-ascii?Q?Pg7O/bIexJhYmiJoU8UsFVHzT68Ek0Kky23FDryR5MqMVBpXO/L1xS0MESHU?=
 =?us-ascii?Q?zFiR6qE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jpmKpPqRT9Sx0ST78FuZ4+VZmgsisGB0MKx4xxWl6mHn6E3tzczJygupZPFa?=
 =?us-ascii?Q?EOu/8W9zbD+Uz0sr+5/ZC6ZPAFMF3o1OsK1P+WOGKQUJ4f+kcWWK5+PJdins?=
 =?us-ascii?Q?UUidWeSuYQm5GpIEpBjMQjdXBEF35ceybj03CRe1r4JzRREi/QS0yea/xiBS?=
 =?us-ascii?Q?CAtu/H5UtCQT/sckDI5bRjWP8MvS143il15J5RnT/VD/DX8NYwr0Dn6yM4FE?=
 =?us-ascii?Q?v8Sd3Q+l27cOBfFwBw6mKuddJbK12/TRBQGkzP0zf2GzNXz+YAPwATiT1zhj?=
 =?us-ascii?Q?zCQ/1YCissn6AP4BQYe1xjkPoieo4GRS/jvG+z7UqrOjDmg/4xByhtlyjYBn?=
 =?us-ascii?Q?9moQ42PWdRwRmYVTb1qLConGTygxz8NFGbJl79dfNkQ8EhL9v7UGAnM6psSC?=
 =?us-ascii?Q?B98WVyIyVsRm+sOmnKgBz4FVx2Du2izhMaaSX9KSo5+O7YKL7Wg0//SN8a6D?=
 =?us-ascii?Q?/4PQvVbnHARWPWpdcXOkguq/PNoe+QHC5wX0naE4V0BpRe6bfQfjOOw1TIbe?=
 =?us-ascii?Q?ptRZy+0QOB/NN1cwmGVk52FJf2RWf6jOsRHZJPyZr3ajAp7a1/tbYMa+Fgs0?=
 =?us-ascii?Q?N3U8+/bvTRFFYoop0rVzsnUyzyyETbV6cg27CObA0IVayyMyPLrw5sytZjYb?=
 =?us-ascii?Q?ZdrQHzSNLm+q8CW78+G5N0LIeFEArtj4mbI0mk2Vh0HrpjcXOtQdnyhnPjMF?=
 =?us-ascii?Q?t0wKbARp7L9VXp2xjjM4PIBmKonwAcOe6RYJ2s2Ot36/INB0xTgumHKUs4BJ?=
 =?us-ascii?Q?vX2JE5AgYTERkDdmZWeMn/iyvFkZpA+U3LCrN3hg+9m0/ttdiXHDUyvaiRo1?=
 =?us-ascii?Q?yPrH4JD9ccULhsK/4cZ6NoRhoMUdJmbdmRPzBsq+Jt3On6G0nAb2wdLPIL6J?=
 =?us-ascii?Q?ZsEA/1CpHu3fctPK9/lAR1/fp3oC+zK1OJiim8jYp0M3Atf4XyiQYuKGfwn5?=
 =?us-ascii?Q?pTFkh8AeD5RLWV41TocXhPNMwUxiodueh2n5FjmRmjG3QAstgZqlqWp1WJgO?=
 =?us-ascii?Q?c2ockVYuffpXmxdLr4sGlIuSqj4X2ebzPnBvzGSfdsnrgboOOgQSaksFlqXg?=
 =?us-ascii?Q?YJx1/s7YHNMgoxg6M/QIo3yL9TxP7cGk6hSsZlWrcJ38VaIJx60FqGb9SPei?=
 =?us-ascii?Q?s+xZiIZCIqzOoaMvKbOkOYFPqo4kuNdh+RP3brtSqVKf40JJOfrpK+/gYjXc?=
 =?us-ascii?Q?CFO490p1YPzpQ3mjgNpNkz6MAZ5FXxS1SIFCCqG4NMGUdCxbzMQZL8caxqj2?=
 =?us-ascii?Q?/Mzm5iktE1x/0/hiIfsJwn9xz+O0vABShYMrQD8zjPcJxk01psipd69YNyD0?=
 =?us-ascii?Q?tZcxuORSReIZEqFq2ePGyWlJ/qiTtiH57uJRHtpisRsQAsVuegLP7Ao6gHop?=
 =?us-ascii?Q?adMzOcaXLZqV8NaNHjCPJGRG37YtaLEgQ7wxNkfdevCmWU7MyZm/oZVWkrrL?=
 =?us-ascii?Q?kcl7MO9yRKr69u8FFnKFfbd6sj5+apCjv8CURSDhsn95K3gBzZ3Vq9U/N0si?=
 =?us-ascii?Q?JPZnFp7B/0T7KkpE5ixrlrQtQEUblZeT0crMPXg4gBk/YaQJM2swIE3VMmDo?=
 =?us-ascii?Q?qnjbtTiOAjH3IXeepGzzc3usqKM2pFikC2ogzsnEk8ciS4VF+CfW7QXNExGc?=
 =?us-ascii?Q?4QvtxQrk93YcKcAQw50DolbpJXXUBDz97Y8yl/SIDC6Ry9Hqs0f2N2L/NgX8?=
 =?us-ascii?Q?xltq/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g+Vhu1cSPQEIsnq3twyF4tT3F/9M4K1gaPmwJCstVLDpvnACqtMj5xgrrb1ndPV5u95zCRKFTbaoiOrWhB4vzRPOhAqi2D2bJAN0FYYZh/RrjIuhm8UD0+6LDWdj1Qk2csZBwhA+J5ssFftJ3FvByfr5wpAMfYn8lk42QfYOO+OkK1WjoI2JV0HxkjJyGxKT4h/Hrp0Y4sV3hLlRB5jiEE3+5P4aaz+cLG1wy5m5oHZnVRQPeM4p5CUfa5OD2a73nW7CcVWr6HmAqIzwQVVUcLcenrEHnp9HW9wt5GvRGo4geqlFzondeBnWNI1tnxQf2XQgnbboQsw2feoRSUfuEgx7tHy0ZIqLeGVXuvuqzLFhs921Kx7FY4y4rnQ/C3EdoLTE4AZofp8As0kNy8uMF/CXHyRVp+3aZlPF8DsZBTuW9myaMv30lc1qBGTaZiTPjr16/ZM+uCw15/cvFrrXRrMvq5Dk+b8xignH4dVvSsUN5A0ekeXPyL9y0PSYt6HXps1EzJCCifoZu0a/GqZmvR25iVFqXg8ps136t5YNH3P6Q5wHLGWjZZGP2ArKvHh5m3JuMiA/HZyGVlkHu9eSQd/Ij+oWjVvZob/U58DuLaU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6079ccd-8b53-4eef-c2c7-08ddd75606ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:23.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tx/fWOmyU1vEHgwfkhDnqekrccPZrOK8ugE3CTYQhPuSW7xvrRajkQStsrTsYYj2ZDh29zHC9COnYJKA24ppUbPGapT8qKId4LAY4xzSgW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508090122
X-Proofpoint-GUID: 3XhM44A9ciZyO50DH7B9PbE4CuuaaYSN
X-Proofpoint-ORIG-GUID: 3XhM44A9ciZyO50DH7B9PbE4CuuaaYSN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX8UDKToPOuI1S
 UJgYcdH6pa5Jdkm7w1+1CDQ0X8jZowV37h63gK47tSs6RjbQ6vwtph+c5pU6dHPFq48w/DTW5/r
 JrKX8eClJ/ErRGN4jHS/KyPvK/VVyGC4v9fTzdb8NFDXeghCLabRA8W9ngmb9y59pp/qQ95z988
 tI3kHjG2B/hKpHV/YyYxpjIqg0b43n6vX3IB0i5HDekUALIGM1+IEDykxNHe+7HNwSj6NMUevhl
 yvo/cULHao2AC5xyM/ytVGng2y1jaEE0642XQUCbVCxaNqQ4O8JF6jSuxvYyBFdTMx0HQpouncX
 uJDLh80UBJZ3Bfm2aXE0RLNv5t9vJ4cL0FLQIHKzL2E7QfxcSyhR8AzUF8/qbVq59N3guWFUtQ0
 vsbU2KQ23gkWel+Y0AVU3Bq1s9vG+3B6qmkRK7D5fXbh5hOssUwr7MnFlhTcoLfr/x9QL5bn
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=6897637a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=hcMAcP5njn971MHogS0A:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22 cc=ntf awl=host:13600

From: Cong Wang <xiyou.wangcong@gmail.com>

drr_qlen_notify() always deletes the DRR class from its active list
with list_del(), therefore, it is not idempotent and not friendly
to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life. Also change other list_del()'s to list_del_init() just to be
extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-3-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit df008598b3a00be02a8051fde89ca0fbc416bd55)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_drr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index e33a72c356c8..5a543d35d53b 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -111,6 +111,7 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (cl == NULL)
 		return -ENOBUFS;
 
+	INIT_LIST_HEAD(&cl->alist);
 	cl->common.classid = classid;
 	cl->quantum	   = quantum;
 	cl->qdisc	   = qdisc_create_dflt(sch->dev_queue,
@@ -235,7 +236,7 @@ static void drr_qlen_notify(struct Qdisc *csh, unsigned long arg)
 {
 	struct drr_class *cl = (struct drr_class *)arg;
 
-	list_del(&cl->alist);
+	list_del_init(&cl->alist);
 }
 
 static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
@@ -402,7 +403,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			if (unlikely(skb == NULL))
 				goto out;
 			if (cl->qdisc->q.qlen == 0)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 
 			bstats_update(&cl->bstats, skb);
 			qdisc_bstats_update(sch, skb);
@@ -443,7 +444,7 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->qdisc->q.qlen)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 			qdisc_reset(cl->qdisc);
 		}
 	}
-- 
2.47.2

