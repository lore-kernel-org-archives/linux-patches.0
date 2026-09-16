Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3A44781C;
	Wed, 16 Sep 2026 07:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543896; cv=fail; b=jFupJoD0mWJUdpP3QfLf/kCH1vWG5vrpcU+mLvz3wvVkimI9bmWiQqLq92DT6npHI5HWoPeZvoy0Rcj1JxK+OLGUvMQXfT8yeQc/myJlshu9v14VPRwfSiBeYUGhv79RSlYriN9EaghnHOljYsMYNvT41iyxI1mxbTcmp6Mrsqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543896; c=relaxed/simple;
	bh=neRfu9h4x2xnyIyIB9Ve2fIBJO41T4zC+Wh+x0i4gg0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nu5hxCHei6EivzmQooS5LnSniBewaaFIjhXqaWZpRn1Hmb7TiRp/sJqt4OoX3JnAMjMHpQZY/ry8d9mRDb4aCYcBXUjaT26Wgn8PYy0DDjiBuJfPXwyWu6iZihuVlhcMT2bFSiQkNI1F3yVDZ2TK95SLVzgF4u/ct8EnOnp0YNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kN2Wd0et; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=te9uC5f1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kN2Wd0et";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="te9uC5f1"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXswV1308091;
	Wed, 16 Sep 2026 07:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bL4gLZT75Fs29MeaXx2sKrIyrkGg8cCbl9ZCwGVMHJw=; b=
	kN2Wd0etaeAw7JuUGKc2NPSh92+qfPK9/ivPXGNW1SpJdfaurmcgmZVcE1oLMoKb
	TIK4novEwySZ/Wxj7aud8CF/xWMYvMZaiBv8mwBUUqqJnk34OANslmHo/rc/UwVy
	VBmffj58/qCa82r2TBHvv3tTb5tRQB+otbJMUOYms0NWljbbBxP01ob0pvCLAZ+S
	EmIc2XklhkDGShVQ9IN8P+MRYH65PtN91RqUD6q6KyRGvC29eoLQSZ3VNXWbiTeT
	pPmE+VCOBfuArWDZqVYQL0NGXI56aljVz6VFDWt46Ff+O6cHWiycTbKGr15EM0Xy
	4GDksA6GqnIQ60sEon0JgA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn954jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:31:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7Tp7J009948;
	Wed, 16 Sep 2026 07:31:06 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6b1dg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:31:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uu3VOYhhc7K2T/oxFNzzrGjKYwqbVuHGBoIe92KfsmH9kUZYxmHshqUef0Xf9ALfIOGLTD6o4c718K+KuV7qEDpQ38HCl+yK8ylA2R4URQuno8hpb5EUvCLgYBpb+l+W070wRtQirrz5+nnV+XTGJBchNSpZhYd1CU+BaORu8E9y4lznMMFWjqVs7XWiqKlB9pCSwNcuNPuU0lSZBQqoXQyBjFpqQ5E+R25Ih4OnaoNBspdlNGRGGStyKzRANwpjoZp71hDzdXUOtAumDkOsXqWqnEatPKnXYnQawjoLAsLhtttWg5SP3S9sTsQWR7JMJmurJhYJU0Czjqg2F2Pnfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bL4gLZT75Fs29MeaXx2sKrIyrkGg8cCbl9ZCwGVMHJw=;
 b=O8vQBNPgfQZzNjIW4wLpFm6QbTiGrfOXUUICmWHwZGk2LZB/QzQoMvBWF6ZodlvQv+TfJrZWbqMcyMhs0irBlFebxY94erlgn4oEK10Ur4wogCWLdQSLs4aTgpuk5c0k4/3bauwMhm8bux7e+/jqOYAwa34DB6yuvCWrONPTx4GQBaoWFZ9cwNA4QXvw3lMIF5eUENjgVEi3PLYxhNH8EVVN4atCNmpOdswqWL8dXUA/SKmR2DOtAk96GqTU0mR7Hf633v09KMM6o1qZd+d9pX3LL3U+RMr+Ay5qV76UnHixd/lorlvRPYC0gjOMHO78qCoHV6tehrrVW83Wi9F9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bL4gLZT75Fs29MeaXx2sKrIyrkGg8cCbl9ZCwGVMHJw=;
 b=te9uC5f1xlwMedBI9GBx7H/XCRqeNX6AJp2Jxp2umTgHvUTaZXIlfgUFdc9tXzOLRNORESwXL4swqrQxWiHMo2Yhq9EbpKDmEadMWpwYhdgnlsRZds87E1HEYlCf+iZ4jEqYVCsoBMsfESG02/HTd8HpL3wH5dyc82IuenX59vo=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV8PR10MB7991.namprd10.prod.outlook.com (2603:10b6:408:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:31:01 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:31:01 +0000
Message-ID: <966146ff-ac6f-480e-a2dc-79f83c5ffe01@oracle.com>
Date: Wed, 16 Sep 2026 13:00:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0572/1376] bpf: Sync tail_call_reachable with callee
 state on entry
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
        Pu Lehui <pulehui@huawei.com>, Eduard Zingerman <eddyz87@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065620.278405277@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065620.278405277@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0110.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV8PR10MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a85b134-6809-452d-8b73-08df13c4756e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YJcC15OBaP9+cH8ob9XKhu1QghEJZqdLVQyr850MeDxZu/gMNmsoOjfSV4SsLoXrlT6Flx2mtcsHFuVV1t9Iw+qmSQklKP9dF9gAIB/9KWXO1jYvGm7RORKVFLKHVHevS7yy1nJZeov/Pp7PGlCuTYuGwX+th/Hk4J0XoJxjsMxL7YKClx93dZIXv4mFW3V+7MfxT8ss0blTo7EQj0MPkWV3OK7im3VfoMs5rC5Ee4b9Bzsa4ZfWQ9atMlzHrVuiRnah6tlKMDC/G9iDnm0XNwyVA9G906126azoSssMn7s0urcojSwD/R/AmUqDsdjeimw2rfAdwzSiGVGtK1n9KlZ4CnCKCO/bF2vRCbgrMhcj+JgSEMjHKeCs6rfms8EEtTyEdHBgt8mYvRW03rGNvz0hMsfPXaqU4pI5BCfwni2gHknYoficSodwmIO6JsPnlqsus2F2WAV6RL6mqaGYK/ciBs9PZiT4O48HgsHppJNFHPg/PIhmuYyD3ryJFoiOVWZbS5NvaZUH+U2K7YWMBBjFipBHkVn40sU/6Pw6GTro73ZSKoxfi3COPRBIbZd8fS9Nlvs6xBl4FMGlzu2iLmLoSkXM/kWY+8ut2t1E5GfDlbyiLm04qKlMcmJ9iWIf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGMvbDZnSWpMV2h5aW9NTnNUalc3OG1NNmxVMktWRmo3NndmcVIrTlh1dDVo?=
 =?utf-8?B?L3grWTh3Nnl3Z3dlenpYOVpFR0RIeCtDREp3SGROdUZUekJWZDhXWE1DYlBC?=
 =?utf-8?B?YTZHbVBFaEN6Q2R5Vi9RWmNWdDg1QnVabFNBM0xXQkJ5UGo2MVJwQ1NPZjlj?=
 =?utf-8?B?dUZiQk1rN2NiTG10azFodjlQUmEwQkNCcE4rNE10OHVOd0JqbUtkNWtLek13?=
 =?utf-8?B?VWFVNUQvZElNSEo3a2FrRnBvNEtYUk9FdWlyY0JTUzdFc2hLM21xOXBiMFJH?=
 =?utf-8?B?NFJmWG03Rnkxb29rNTRaZDhUSkNjQ050Q3RRMDFxVG9BQ2w1cExTcXBWNGNC?=
 =?utf-8?B?QXN0SE1OUlNMVEUwZDZ5MXU2WHFpT3RDMk9OcU9hMWM1MFZsSndFallCSW9Q?=
 =?utf-8?B?czB5Unh1dGRvc1QxTUNDUEk3UmdSUWEwL2xQQlFqajk3bVNoaXo2RnhtQ1Fh?=
 =?utf-8?B?amxHdWo0OUpzYTZsR0tPU0htbGxyN3J0YU1YNzU1NHdqd0xsaVF5RkNMbWM3?=
 =?utf-8?B?SCtuWE1INzdEOHJhYTkvbDgvMlpmZDIwd1RWaTYxK2ZpVXYwYkpTTlJCTVZO?=
 =?utf-8?B?M2JTeXN3S2ZVVVZURUhlYkZ1Y1dRbUlrVzlzZ041MjVqTWdNYjNQZ2k2WnZk?=
 =?utf-8?B?ZEJQbzlhaGlwc2xzYndSVDE1cTlMS2k4K09DZEFVREtQc1VjaHJGUlRFNXhZ?=
 =?utf-8?B?SjZreEFsaTdSbzQvcWpDRU1IYzN6ZU9hUzdzbllHRnJJRzVtUkhRR1BuZUdh?=
 =?utf-8?B?TnVpUWRUZ1kxU3AxdURrWWFsZHg5WkFIT2tCNHJWV01MdmRDRnRMR3g1aEo3?=
 =?utf-8?B?U3ZBY1R5UDdoMzVCL2twNHQ2TWVkMlROWnJaYXhkUkhOVFh3SlVTczZGRVFL?=
 =?utf-8?B?VW82anY4WTJiVnpXYnVLNDFPZHhFNXQ3WVh3UlV4d1JhRlR4WGhyQjZSd09C?=
 =?utf-8?B?RlkzWSs0ZytHUHo4ejNGUFNGUjFHMWZMTEhUS1JTZE9vdHBZMVlWVkV4RjJL?=
 =?utf-8?B?L1VMd3pVTUNrQ01mN3lGZ2RWTzNSc0JjcDRHWTNoR21wMGdReldqWENlT3lo?=
 =?utf-8?B?Ky9TdHdneXVBd0xnWTRNV2VCKzgwMU9ESlc1NFYrUXNRaDFCZHdCYkFHeXJI?=
 =?utf-8?B?SDJYUkVvUlhEaDV1RVVQQ0tVaHZzejl5NE5JZlA5elFRRXJMdTMwQWdqNjM0?=
 =?utf-8?B?cWNrS2RZSTJsVFM5S1l1cEVUT0NwVUJLU2tZd0RnS0ZpME1wakVEdmxocUNV?=
 =?utf-8?B?UG1CSEJlaXlYaUIrU0piczd3ZldXck02RFFxQThhdlFiWTA3WnIrdkVkWGdi?=
 =?utf-8?B?ZEhkV2xYTWFzUmd0UlkvRWRGUnl6RjBkZnhyRWQ5dWlMM29xd0t0a2FmMjVp?=
 =?utf-8?B?alR0U1BkK0o1aWR6UWJzUERSKzFjTm1JTzMvNEtCV0IyaHVWQS9KbWdVbDdO?=
 =?utf-8?B?SXlYS2RoblVqcitGRVFuK3VTN2hnOGY4MDh2NndTd3RNdUlad0ljdGJsdStU?=
 =?utf-8?B?QUhxTVlyQ2pmNDZXVkZqM0QvV3VWbDgrY292NEN6Rmt4cmdJdk40RnhaUnJk?=
 =?utf-8?B?RktNVVZLblRhWmJyQ2lWa1FvUDd4TGRZZndDMWFrYk0zczkySzZsMWgwa0ln?=
 =?utf-8?B?UEQzNlpGRVhGS2thclFJb0VBSEtiNTRMNHNYSTZHZVlZL0Urb0x6cnAwam85?=
 =?utf-8?B?Zjhyalg5dWszWkdrcWJFVDdLZ2NiRXNtRDUzcFM3bU8wUDBBc2w4SkpjZFlr?=
 =?utf-8?B?NUFaaEhadmx3TzZmbUI4U3FTRytESHlxZjdoZkF0VTFsZkdpL0N2bnVFY1p2?=
 =?utf-8?B?SHFROTQ4aTNTbXF3dUl2UDRoMzEwYWEzYWZranYvZTNNNFRLNE0rNlJiYmg0?=
 =?utf-8?B?MFRCaXptM1djNjhtdGVadHQ3bStEQWFsbktzQU0yTi9rZUo5M0tzMlJ5RFht?=
 =?utf-8?B?UlVuYjVQY245Nmlvd2lVVlpLcXY1clRRUThHNWJhbFBHRXZTcUREU0dWcWRm?=
 =?utf-8?B?dTdPOVN3NmQyY09SaWJlcks0amFmL0hsMkxMZWhXM1FMK0ZiOWVkMWVPMjEr?=
 =?utf-8?B?eHo4UldrNWlPRkl5NjlPeGdBNU1qb3VIcE1aS1YraGpuaXZpZEJNR0VhYWJ6?=
 =?utf-8?B?MlJETTJFelV6TDVaSVRwOGhUYkYwUktPc1BiT3dvSFVPNHJLRUVWYVd4Rzln?=
 =?utf-8?B?WXZiRGdZYnFxWnlyYTZ0ZXdvODJqb2o2RHlXdld3Z0Q0UGUwVGxuQzRoazBv?=
 =?utf-8?B?L2xaNmJMNS9QVXF1WVZlQzhGUnVLemZKajRKdzdSWDNHVytSMVk3cnJGVEpp?=
 =?utf-8?B?TVZRSWV4ZXg4bUxkNlRtbU5wb0ZKNDU5YVNBMUhhcXlsTjdtaVh0T2xtZFFF?=
 =?utf-8?Q?QSEM2f/BocH29Hjpk39T07yz88Oscvtuo3BWG?=
X-Exchange-RoutingPolicyChecked:
	hOKsLS12NtvwxY86JTg8nCBntoZSvgWS5TuY2XvuOFs4x533ReZrkXLQTHeN2Tb6/p6Gp/odJGlHq2HOODRtMWjc9vG5IdeKvyFX0DFGRuUbMAkfuXtxdfs2bytihnEW8JakmZUwIcsc1I20rFTXgfxMdvngB2QzGLsQWg4jpLA9oo5qmXVyFmXQeidlHj80LLavdt6SZn2Stdhd2geN1TBQrc5/Yb4day6DaL85BEsKIiS2EiVBwHyztfPvRbdN3mzjS6BPGtkDIs2dqaquVJbr0uLhLiSXxdCN/avqRbG6z99P670FZ6qNOsSLDTbj24608B1+CbfjBpPCcj0YCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ptk8Lgba/BsIclsc2sZWlJkAdPVO/Z6y9I1RThUbsKDiBvxwj29FSGO26A97ts9ZbLdk1+q/RTw9qbaIqO2DQxrIzEBng1J+odJ4F6VWwAWqRgb6aaTu/YImQQlW/N4Gr71qas1XaWTupXV4/5fdtyZrMFBrNbE0RDpGmkgTaIwpDQUXtn9Cf94Yq25+TCeJtbc4GBNKHR9J0el11aCkHBMaPCFeKVSw/kZE/MaZFrmh5Em0V0lOnJQvIU5gLjzOyndEXZHKarTUt2ReTOXyrjIkLmcNKy/zUMU/LxGW4Xp/jSUasqWlxQpFMjEcKjhqLvYG/l5kofmhD/VaCKybeRhhbdPdF5s89UE1l6m4Sm/24EpenqTbQd5ZPRTVHqQa6vNj12KwWw/jXKHdm/SkzlC7gQDrHsIHVTVTXGo/2M1jDtj7/2xfGhs7JgsQq53PL3vBqhVFBQFXvqkdbWcG0MAJ3shqx4eLTOEYNnL1Wks218I8fIyEutkoRQK286dz+2dpxy/nmd+10UJXQLTV25KtI8cNmexHUb348Orge34DBmidQxzMWuux9nZaiEgj6C5D8W2/8T9KFhUByrV1knpMfPOqHj3ROA4URu8QWZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a85b134-6809-452d-8b73-08df13c4756e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:31:01.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOfzrwqTb+cthG7qorWHJm8whhStRInwFkw2ljbhaqg8IdPPkwNFvWaIkNf+oi9Hos3AwnUbCOfgZNv1ia3ONRGXrRM2GV5QPHegpYQgfb8xQzdoml3AaES+rQYMlQnC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609160096
X-Proofpoint-GUID: B29CFJwwnTYo9UacUdBzBM0eN0-1kdTj
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5NiBTYWx0ZWRfX1ltOC6M6RIa9
 h14lJk0MtWg8MKB8FeCOa8Cc+jICJkmZPLezUtQfPj4mKqhKVfhQYo4g1YHYpkH/TE7/cFwJ2Xf
 rYROcAwoNvHFNC/5i06pdNALP/mPHUX54O9AWliB8qMQM5wxhqdL
X-Proofpoint-ORIG-GUID: B29CFJwwnTYo9UacUdBzBM0eN0-1kdTj
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa45ba cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=bC-a23v3AAAA:8
 a=AiHppB-aAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=udn6hjKexpNf5BUsg9IA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5NiBTYWx0ZWRfX0+K6tt5FpRjK
 3dmT9pi3nnORzj5JJ/W4XbUlTTZjccTJnrsP8wqxBtjdcW8vt0BHsxB9EW5ZLVHiSGwpwBJ+9nu
 /x6oas0SV0cm96niFITTzn67vCe8lLKXQeQVinYrRFxY1YHEuVTTheya405GAT9hSdca2BzpX5B
 SRYgbFg9e6MEs/QYThVW3LKmZbfxOfAVYRAbU6ETlICUxT4NmwGgRgu4fKHOuiJXxq+YkHHr6nM
 HzhNTT9HB1Drwv3n2SFbE/6Qn7aZH4BzOVKUOZVI4UJX3s3fUPKjLQ+bVua3Ynb0BnsZpmUFgSE
 vtnqqNiinNs3nKgXnXFb+CVxVigFKQAUgLHqIVTXCuCANSrzBVsCxWNlfH087cg496bGpLI3Jwz
 THtYkJ6pF6bqr0sSIe7jt8a4aw+8sL4RNXWqcGeecgCjdWG8AssCLafaGW/1LPePJMxnPkrSYrZ
 ztZ0HtS2CTKE3zKsxmw==



On 12/09/26 12:19 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pu Lehui <pulehui@huawei.com>
> 
> [ Upstream commit 3513ea9dab6c1a3d2dc8e6160c41f690206948b6 ]
> 
> Currently in check_max_stack_depth_subprog, when the verifier enters a
> new callee branch, the local tail_call_reachable is not properly
> synchronized with the callee's state.
> 
> Consider a main prog branching into multiple subprogs:
> 
>         subprog0 -> tailcall
> main <
>         subprog1 -> subprog2
> 
> When the verifier finishes checking subprog0 and backtracks to main
> prog, the local tail_call_reachable state is left as true. As it
> proceeds to subprog1, this uncleared state leaks into the new branch,
> falsely marking subprog1 and subprog2 as tailcall reachable.
> 
> Fix this by explicitly syncing tail_call_reachable with the callee's
> has_tail_call state on entry. The caller's state is safely preserved and
> restored via the existing backtracking logic.
> 
> Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> Link: https://patch.msgid.link/20260716120157.835937-2-pulehui@huaweicloud.com
> Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/bpf/verifier.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f9f2095eab4a0..2318c4cf0231e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6294,8 +6294,8 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
>   		if (!priv_stack_supported)
>   			subprog[idx].priv_stack_mode = NO_PRIV_STACK;
>   
> -		if (subprog[idx].has_tail_call)
> -			tail_call_reachable = true;
> +		/* sync tail_call_reachable with callee state on entry */
> +		tail_call_reachable = subprog[idx].has_tail_call;

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The patch correctly replaces the traversal state with the entered
callee's has_tail_call value. Upstream also has 54c27ea6dadb, which 
restores tail_call_reachable when the traversal pops to the caller. That 
restoration is absent from 6.12.

Upstream unwind code after 54c27ea6dadb:

     tail_call_reachable = subprog[idx].tail_call_reachable;

Downstream 6.12.y unwind code:

     frame--;
     i = ret_insn[frame];
     idx = ret_prog[frame];
     goto continue_func;

The downstream unwind never restores the caller's recorded state.

A caller containing a tail call can enter a child without one, return
with the local state still false, and fail to mark its own callers. The
JIT then receives incorrect tail-call reachability metadata.

Maybe we should be adding the 6.12-equivalent restoration immediately 
after the ret_prog[] unwind before retaining this backport. Thoughts?

thanks,
Harshit>
>   		frame++;
>   		if (frame >= MAX_CALL_FRAMES) {

