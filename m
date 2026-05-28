Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245893B47D5;
	Thu, 28 May 2026 09:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962025; cv=fail; b=n5OBDgyNJgLfkiTT8ThnNFuBGSUlQr3a15TaFw9y5lSLeIyp/3yUDRCpZB5J+0OebpdF1nTl8CIjxDfR+uZ3OSI81NwKlqSWSbWgvS2ekMiWFzWfcj4sfxuTBe9CGcDiJCIm7uc394UfpwvyUvSovH1+Uxc9JHbZ0MCx61o60vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962025; c=relaxed/simple;
	bh=V2Ywb//PKt7DLKMb3T0eRg+uFk+TV/y81n3wPNZj0K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bE4GkbhgwHWVJtb1SjUwObvoMFyR3L/dkhgPK5i5WpEBxqWr47KZu83tpe7Zn64AR5r7zUjZ5VFlcaety7DP1+rNoDknoEFicVgUbfYBosHepUxaExsIz13+C70oUluYF3UwCwLOz8C2GdLLT2NkrIBz7xZgmDR8gR7T85R0tZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=HA1pqcJc; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HA1pqcJc"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S6at791243721;
	Thu, 28 May 2026 02:53:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=5e3um/8HVQnNkMhb+kx7XSUthgVRp6fr+nnMLY7IeKc=; b=
	HA1pqcJcoyVEFRalCj01mxx4U4A4Bql/Uznrk2EeI9XBQQKaR3L7LcQ30DUi0q/x
	emI9/a/YzhBGu1J2uyv1OIcykSB+RfgjWt/UoyEWRDqj+DGSQpqL+EwYoAvSy7Jc
	LeVM5PSaNLntnHypL6j1Zn7boVzc7r7jqjSh8fVrDtITLtpkspBhC4Q0+kc72dZn
	wLxey9eLuMPJijRSrpSb03zmPPI4gLvDpr6N3vjs6oYyeH3wXoFqxTevjFVywp4B
	V0khBVMwK4vS7Nb24rm5KkajKMA1i+XJ+q7GMQgQhsKjF4eufzR8sg8ZyN3QA/Ae
	ttVZWpId/9dYscKVG8u53A==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ee7x6rmsv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 02:53:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T9jJYuDjisChHza2k+xO8tU4OKRW+FpD+/QAkiL2rqCIfU//CCnqdcCYmxEeIdMmtLYG4Btu4pY3EPxPvM0TG2NNKFbFt8pat6YfuaGTAR7V9luz9d3HaS/Jqt63QuF9GnIgtTRNGbFLeUSaKyV4wqU9T3ZJaWiIBC1Y/vQDIa8DZ9fHZQNaUy+3z5RHFbxcSvPxVrbZE/VpajFuyfUT9+8J62J7yHvhKcGi1lnfte2GiOp7+maJEM91uqTmTa3DeZ0Fx2I5qU25qClQWCseUPTblRH/s1aPjx+yJThePEqkvgMtsv/p4BjXTnLQ+JD5VCXdJxSJ6I2FlXGJNi/ELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5e3um/8HVQnNkMhb+kx7XSUthgVRp6fr+nnMLY7IeKc=;
 b=pZgghomvdaQCXaPYTPq5N5Oaa3fHkAI0o9SRKLHOLi6D6J6r3FyJ2LNYy8Epksd54ll59lif527Yj6gD23DmM8AUp4F+yNfmAqvcgSsRyHjkLLP1RJGAkaQcAndxkWZHAGRuyd589hiu03ttZRXETmtEfUs2pc/JH4bUaH+3KoUxMdkzpukpFUrifJLpp97NNsqFIwRwwswF6jEfUYi3V8T24E3rtK1PwmY8/xXw3IErSOrazYe+gaPCIiIYNbzdcWR9DehZElKNw6Mmkze7o+mbmZ4qggFkFcmcH36+bUlbM31c53Lge7WthHATaxr4rxyV9nFaGgHvHHD7/Cfh6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH7PR11MB6498.namprd11.prod.outlook.com (2603:10b6:510:1f1::21)
 by SA1PR11MB6759.namprd11.prod.outlook.com (2603:10b6:806:25e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 09:53:08 +0000
Received: from PH7PR11MB6498.namprd11.prod.outlook.com
 ([fe80::492d:f133:b4c3:f94e]) by PH7PR11MB6498.namprd11.prod.outlook.com
 ([fe80::492d:f133:b4c3:f94e%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 09:53:08 +0000
From: Jiping Ma <jiping.ma2@windriver.com>
To: lixiasong1@huawei.com
Cc: gregkh@linuxfoundation.org, jiping.ma2@windriver.com, kuba@kernel.org,
        matttbe@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        zhangchangzhong@huawei.com
Subject: Re: [PATCH 6.12 28/70] mptcp: fix soft lockup in mptcp_recvmsg()
Date: Thu, 28 May 2026 09:52:58 +0000
Message-ID: <20260528095300.810798-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8f4eda80-bae9-4a68-b983-0acd53d2569f@huawei.com>
References: <8f4eda80-bae9-4a68-b983-0acd53d2569f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::8) To PH7PR11MB6498.namprd11.prod.outlook.com
 (2603:10b6:510:1f1::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6498:EE_|SA1PR11MB6759:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e4fcb3-5409-4c82-7996-08debc9eebf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014|6133799003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	4JCP25YtBSLi2ABKZFyBneu31yLu4jrgzKf+bV4Zu60JCgmXJ+aW5joC1FoM8keFmvbL20l35/3BNMzVKypn1fqJFRBdSyAr6/RSGiWtyixSwo+CT0+lJR4bUB5SRwB2AyPQ/cyeVBPgPomZwVIEUxLlgTp4lQ+/sAjJrPDjYz1EuTlHdbnhFJnYbCdU98nsyUk+nGL0Ck2mkDOuDmm+NWBjQGUCHzOUo1176xrMV/wuT/EHji8EaHpdKKB5GcmOivJpjksCgT1w8HCQGjaKyKspUzMWfMi2mH01d0ww76id+h/XKtTA5EIDir543BHaQyx8YLkrqcWsXHzLQ2ipNU/EkH0K8gaxn2qRxbJ2btxh0dYcg4ADzdkqqxWA27RbOuPmCqcteok2wpTeZuzsOOjELU+fAp3mKRx+u0kk36cx0FJqXmvWjEhLpmGjospWSQwPwWTMf6jkf0Nm13OKvvkLKCUEObhDBUidKjkv9kHPGG3EBds2FBewulw+0X6hOxuCyTS47QJ7lGXKf4D4KtzDXLPdCNfYu/rF8qg89N5vmtAKv1GMTps9eq5HqhlW5Iqsv/mgRjvO46cprGuSljCHNF7Ezknf6sFGhZFKtOpZsiu+6di7Q8DnWfz5tMY/gipSkxZPPDhtLPINN5Nr8Xqx2P2Vi37/NsbqyywR2LX+ba2Ga+AIIn/orNZPsmiZtv82SXL6tV4ooSqdaVk6gWfnNImHK6cjdDe7VqqvJPjG29pbfy3OP+r13aeTCdAU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6498.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1dkUFdxeXpHaThtVXZJaGxoT2FnYzgzQkQ5aE9semlDdm0vSlhCSGNqV0Iz?=
 =?utf-8?B?dC85Ky9LckdBNE1SV1h5ZDRsdjI4ejU2bGxZUXVWcDMyZGRueTdXM0t0cEZq?=
 =?utf-8?B?Z1JXQ3NJc1BtMGMraTZGWjQ1VGtlamxTV05NZ3FMU0N4c0xtUExZQmlDNVoz?=
 =?utf-8?B?Q0UyaVFIT3JLRmw2VUpjNDMxSGNQRURNTFZuM3RoZW1tUlovclpYVWxjRHVs?=
 =?utf-8?B?SmtnMWphSGxjaFdkQmY0M0huelQzdTlmL3U0QmR1aGJRK2R5Q0FkOHVTVVNJ?=
 =?utf-8?B?S01DWUp1eGI0VHRoN3NscVlPS1pqSDF3blI5TXdVelBCMFY5d0dvMVg5NVha?=
 =?utf-8?B?eTBUcnZYd3ZCZVI2ZEI4cG5ZQUJGVlNEMUhVdFVhM3o2NklYaVI3d0FZSXdW?=
 =?utf-8?B?TDI2YUNqQVFXRXUwUXhWMWVQT0xvMXV4MkdkRzFnMHBVa0VYV2xDMFFrUTlE?=
 =?utf-8?B?QWM5NGZQU0ZJcjVaaE45c2RGdlFmMjM2ZVZCZnBxRVdwV3d6L0dreW5oL0tt?=
 =?utf-8?B?ZjU2cENidHd1bnpLbUs0WEpRdnh6KzBhQmRHSEUxUFZ5UHBjcFpTVFFHdFAx?=
 =?utf-8?B?VWVaczBQOUcvRnhNSzU5dVh2ZmdBTE4zOXVRMUNVZzBWQmVpMFdUdVZlTDA3?=
 =?utf-8?B?c29yUWhBNkZ0VE9yY3Fva28xeXZVK0R0c3MzN3MzUlR3SXdTczBnaG92MEJC?=
 =?utf-8?B?dUZIcUFITmJTQTlvaXpiQVlvaExER2EvdUIyQXBxbzJ0cGFzcFpnY1VBcjdQ?=
 =?utf-8?B?NDdNODB4L1RjejhSMDl3cG51S2J4RDJHK3g5L3VQUjh5OEs0ZkhmaUhyUFJ2?=
 =?utf-8?B?SXRiTTN5VSsrWGZjQUIxRGkzL2dIOUZtYlpQaFZNaTMyTGdTYkE0L09BcnNY?=
 =?utf-8?B?NkU5Z1ZOc1JGWkxpOWJJbVFHbDdUMlJwRmduN013Kyt4cVJpVFdMVmR5MExZ?=
 =?utf-8?B?ZjN3ZUlLa2s5ZEFScENyNS8zU0JtY3NyZkUzR1B4MUdTOUpYMlRXc3VXZ2h3?=
 =?utf-8?B?UTZZNlRJWUZoejRzM2ZJZm9QS0d5QVI4czA3aWZMNmZQd3FTUThTamJxSE1u?=
 =?utf-8?B?ZHNSNEwzRndIUGhDaGpiVURYYU90VE5ZSGZCOWpjcGVrcW5oUzlteXRNNjdR?=
 =?utf-8?B?YnhnUjJ6ejA2azc2T21SRHZZd2VqQ21XbEFwQzdPTzVmK01PR1k0Y0NuV2Ro?=
 =?utf-8?B?MHo4SENQQ0RnVzNCNjNCZS8ycit2QU94NEZ6eEtCRG5MQytOanhiaDFLZjBR?=
 =?utf-8?B?WHBJNktCZEVHNGMwODQ2aEZRTnpRWlo3aTFrMzJBQUQxZm1OSEpnVWw3L1VT?=
 =?utf-8?B?S0N1UHVaR1BTcS83aW55SDZsV1kyaWx5ZVI2K2NRMFlmSXlNdWJzbFQ3enhN?=
 =?utf-8?B?alpmUlRrYlptVGdOTGU0Tk9SYW4xT1dsOVRrUUdsUUJjSmFUZUlHUXRHTndr?=
 =?utf-8?B?SmxsdUc0WlloNWtNRVpWVS9CVk5GdUZqb2RoTmNTd0tXdnZ0YndhRWdCQTNh?=
 =?utf-8?B?dFR5UWZEMmMxWEphM002MkdCMGEyRm56cmFIRVdjZ0lIbmE3aEpVOCtFMXFR?=
 =?utf-8?B?Q2RSMEFUazgxbVBYRTdNTjNuMlQwWnpOd3N2NWhVZ0pqNUdSK283eFZ0dWUr?=
 =?utf-8?B?K0xjLzEzSHhLalFxcmtGdjRnYkZUWDhqVlVuWFdXbWNodFVZbWpKUzRkYUQ0?=
 =?utf-8?B?SWxvbjNqL2pmNk5xOEJIU3YwN2c0UFkyY0E5cTBrSTFNNCtKbkc4dUdGNDVP?=
 =?utf-8?B?TzVyUVVJUnlSNndSYnRXS0tZdDJDMzlmd0JMTU9YMXJ2RDVjRW5NaHdQZ0hJ?=
 =?utf-8?B?aGhXUS9Md1hacHBCZGEzSTVlMmswTHhtM3YrenZkUkdIbGFPTy91Y3l4Zlpn?=
 =?utf-8?B?UGhLRi9tQU1tSVRObzYydS9PQ3R6cWJvVnBESTZzU0NMOWJGcUlSRkhyZWUr?=
 =?utf-8?B?c0o2OTNVTng1d0FNOEpKcmMwMk11K2FPdnRxbnQ0akx1dkV0MFR2Sks3clNU?=
 =?utf-8?B?UUc5cVR4QnFYRU5VcHY1d3pMK3RzeDJ4ZGdIV3FDK05iK2lGRUJTYkxicnBJ?=
 =?utf-8?B?U3g5TXB1V0EyclV6c0d0TENBUzJvbVI5eUxPckMrRURqWnhoTC9RM3ZTSTRD?=
 =?utf-8?B?aVFkdnpmdGlwQmVMNVBpejVxVDBkcEJTQU4yRHRVelRxdVRjSjNwNDVMMVps?=
 =?utf-8?B?KzM1amp1bGhidXJvdXJ6SjE0MWZGMVlQRzQ2QTB1bnVnYjc5c1JadmorUnNL?=
 =?utf-8?B?a0w4M3RQK2tpT0I3OW9seVA1RUxGVFBkR0ZjaTVsV25KMEF3VVROY0lUMVhm?=
 =?utf-8?B?T1dwVWJhWFY3Mk9CbW9CZS9CR0xlNUtFOEw2SUl1cGJJVmFGOWl4R1ZUbktY?=
 =?utf-8?Q?7RSm7S0aBFD8/k/U=3D?=
X-Exchange-RoutingPolicyChecked:
	E04HelTMv6ZpBF9DQDghd8Q5rBZbTYDesrXWfiS9xGIUa0uXqL5pXRNFY7bNtbx507o2SU9QB02teNKUSQVtM+ycUMyu/W7+ND2hWNY/LabA3+gnMzvWf+hjl8u3fzTjphk4pWhnyA7TpjH2jJ0WsFDFtsYD7nnwfk7skMrcWyuD9p0c3z5lSb8SvSTAvK+NSWF96GhdXYIhc3ay0N6mHLvfPUlSWFUE7PUTbH99D+1PB3LSRDgxbky6NtnCP/tTseJaU1ACQum/K+7kcEh+1nJZI8PqY134Lmu0FmutFAX4hYaOFjCOteI/zaSPfzC4Zo3HoQQgDLktV10D/i/wCw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e4fcb3-5409-4c82-7996-08debc9eebf8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6498.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 09:53:08.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uc3QhA6BkDyvzIRQSAWfgo7Dz9Q9BY7eksd/S2qJRN8WM6+rwIfmN2OQpot3FrYEq/7Ox8w8o46LgEj3/0FJWiRtox5MQKqCusyFqJlEo1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6759
X-Proofpoint-GUID: yafT5TbWRieuc-HhborJZuahGv-b7EBT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA5OSBTYWx0ZWRfXxXNiARK0r/Kv
 /alstKwF7HTBayyKakowMGJNBKoGZbd6ICVQAWPmZf8KJ12iuuuVlT9FrzyYF2/Ee77qi/84BGt
 sl7D0bwMbuBrvfKfCCkeb2FOhwhaS/yHv205A61sfvs8qCZ5tPxt3D1CvnbgVI5Hydn7MzbWhMw
 NgZBPyjpmLW2eiHhPhzu/v5TzO+rQ3s6WFjJ0ytdTplVtqU75RGengRS7P9FSNNZG8ZD/Bj58JR
 3ketEa/8rpssmp9xAGQSuK7idbLBvQ4tjOapIg/txe6M0tVi1jW9CDcPzz27LEnZPLw0jf0jrVf
 040gRp0unCPHNdsrOKfF0RH2GEz1JUYN2JzIpc7VE9ZiZeHgtsn7QP8yvJwdyBcfI1M3BiwJXwM
 woCPyYW0OW5lMuCq7j7+eNe9iOJi4ESuF0isxfENmNnI0P8Cr8yNfvG1pwkr6iGAP8rk4AwFbjB
 WwNZg2UNQC8+6kFmqyA==
X-Proofpoint-ORIG-GUID: yafT5TbWRieuc-HhborJZuahGv-b7EBT
X-Authority-Analysis: v=2.4 cv=FcEHAp+6 c=1 sm=1 tr=0 ts=6a181088 cx=c_pps
 a=d2CTHFLGvf7JoJ8RUfZBgg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=IegCw8cNgeJ_SUw-lR8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280099

Thanks for your share info.

After enabling mptcp_recvmsg with dynamic_debug, I observed an infinite stream of logs:
"MPTCP: block timeout 9223372036854775807" on kernel v6.18.32 (without the fix).

In contrast, on Linux 6.12 and 6.6, the same setup only produces two such log lines, not an infinite loop.
which matches the behavior seen on v6.18.32. This indicates that the issue does not exist in Linux 6.6 and 6.12,

Thanks,
Jiping
>Also, if you want to reproduce this on `6.6.y` or `6.12.y`, based on
>the previous analysis, have the sender transmit two packets with an
>interval between them.
>
>Hope this helps.
>
>[0] Relevant dmesg log:
>Linux ubuntu 6.18.32+ #15 SMP PREEMPT_DYNAMIC Wed May 27 15:25:52 CST 2026 x86_64 x86_64 x86_64 GNU/Linux
>root@ubuntu:~# [  960.743413] watchdog: BUG: soft lockup - CPU#5 stuck for 261s! [client:1260]
>[  960.743433] Modules linked in:
>[  960.743463] CPU: 5 UID: 0 PID: 1260 Comm: client Not tainted 6.18.32+ #15 PREEMPT(none)
>[  960.743469] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>[  960.743474] RIP: 0010:_raw_spin_lock_bh+0x1b/0x60
>[  960.743518] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 65 81 05 d0 a2 a1 01 01 02 00 00 31 c0 ba 01 00 00 00 f0 0f b1 17 <75> 1b 31 c0 31 d2 31 c9 31 f6 31 ff 45 31 c0 45 31 c9 45 31 d2 45
>[  960.743521] RSP: 0018:ffffc9000259fb08 EFLAGS: 00000246
>[  960.743524] RAX: 0000000000000000 RBX: ffff888106efc480 RCX: 0000000000000000
>[  960.743529] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888106efc5c0
>[  960.743531] RBP: ffffc9000259fb68 R08: 0000000000000000 R09: 0000000000000000
>[  960.743533] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>[  960.743535] R13: ffff888106efc5c0 R14: ffff888106efc528 R15: 0000000000000000
>[  960.743537] FS:  000079482a7b7740(0000) GS:ffff8881b70e7000(0000) knlGS:0000000000000000
>[  960.743540] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  960.743542] CR2: 00005a8d794c3008 CR3: 00000001033ea000 CR4: 00000000000006f0
>[  960.743547] Call Trace:
>[  960.743550]  <TASK>
>[  960.743552]  ? sk_wait_data+0xc2/0x1a0
>[  960.743564]  ? __pfx_woken_wake_function+0x10/0x10
>[  960.743571]  mptcp_recvmsg+0x623/0x9a0
>[  960.743578]  ? __wake_up+0x45/0x70
>[  960.743582]  inet_recvmsg+0x124/0x130
>[  960.743588]  ? apparmor_socket_recvmsg+0x25/0x40
>[  960.743595]  ? security_socket_recvmsg+0x1a9/0x1d0
>[  960.743602]  sock_recvmsg+0xb7/0xc0
>[  960.743608]  __sys_recvfrom+0xd2/0x170
>[  960.743612]  ? ksys_write+0x69/0xf0
>[  960.743618]  ? __x64_sys_write+0x19/0x30
>[  960.743622]  ? x64_sys_call+0x18fc/0x2760
>[  960.743628]  ? do_syscall_64+0xb8/0x1300
>[  960.743635]  ? do_syscall_64+0xb8/0x1300
>[  960.743640]  __x64_sys_recvfrom+0x24/0x40
>[  960.743642]  x64_sys_call+0x2694/0x2760
>[  960.743646]  do_syscall_64+0x80/0x1300
>[  960.743650]  ? count_memcg_events+0xed/0x1e0
>[  960.743655]  ? handle_mm_fault+0x210/0x2f0
>[  960.743661]  ? do_user_addr_fault+0x300/0x8d0
>[  960.743666]  ? irqentry_exit_to_user_mode+0x2e/0x330
>[  960.743670]  ? irqentry_exit+0x43/0x50
>[  960.743672]  ? exc_page_fault+0x93/0x1b0
>[  960.743675]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>[  960.743678] RIP: 0033:0x79482a49eba6
>[  960.743691] Code: 00 00 48 8b 15 53 12 17 00 64 89 02 48 c7 c2 ff ff ff ff 48 8b 5d f8 c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45 10 0f 05 <48> 63 d0 3d 00 f0 ff ff 77 10 48 8b 5d f8 48 89 d0 c9 c3 0f 1f 80
>[  960.743693] RSP: 002b:00007ffd26c7bdc0 EFLAGS: 00000202 ORIG_RAX: 000000000000002d
>[  960.743696] RAX: ffffffffffffffda RBX: 000079482a7b7740 RCX: 000079482a49eba6
>[  960.743698] RDX: 0000000000000400 RSI: 00007ffd26c7be20 RDI: 0000000000000003
>[  960.743699] RBP: 00007ffd26c7bdd0 R08: 0000000000000000 R09: 0000000000000000
>[  960.743701] R10: 0000000000000102 R11: 0000000000000202 R12: 0000000000000001
>[  960.743702] R13: 0000000000000000 R14: 00005a8d75ae6d78 R15: 000079482a806000
>[  960.743707]  </TASK>
>
>> client.c
>>
>> #include <stdio.h>
>> #include <string.h>
>> #include <unistd.h>
>> #include <sys/socket.h>
>> #include <netinet/in.h>
>>
>> #define IPPROTO_MPTCP 262
>> #define PORT 9999
>>
>> int main(void) {
>>     int fd;
>>     struct sockaddr_in addr = {
>>         .sin_family = AF_INET,
>>         .sin_port = htons(PORT),
>>         .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
>>     };
>>
>>     fd = socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
>>     if (fd < 0) {
>>         perror("socket");
>>         return 1;
>>     }
>>
>>     if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
>>         perror("connect");
>>         return 1;
>>     }
>>
>>     printf("Connected. Calling recv(MSG_PEEK | MSG_WAITALL)...\n");
>>     printf("On vulnerable 6.6 kernel, this will soft lockup a CPU.\n");
>>     printf("Monitor with: dmesg -w\n\n");
>>
>>     /*
>>      * BUG TRIGGER: MSG_PEEK | MSG_WAITALL
>>      *
>>      * - MSG_PEEK: don't remove skb from receive queue
>>      * - MSG_WAITALL: wait until buffer is full (1024 bytes)
>>      * - Server only sent 512 bytes
>>      *
>>      * Result on vulnerable kernel:
>>      *   sk_wait_data() sees data (512 bytes still in queue due to PEEK)
>>      *   → returns immediately → mptcp_recvmsg loops → never waits
>>      *   → infinite loop → soft lockup
>>      *
>>      * Fix: pass 'last' skb to sk_wait_data() so it knows
>>      *       no NEW data arrived and actually sleeps.
>>      */
>>     char buf[1024];
>>     int ret = recv(fd, buf, sizeof(buf), MSG_PEEK | MSG_WAITALL);
>>
>>     /* On patched kernel, this eventually returns or times out */
>>     printf("recv returned %d (kernel is patched or not vulnerable)\n", ret);
>>
>>     close(fd);
>>     return 0;
>> }
>>
>> server.c
>>
>> #include <stdio.h>
>> #include <string.h>
>> #include <unistd.h>
>> #include <sys/socket.h>
>> #include <netinet/in.h>
>>
>> #define IPPROTO_MPTCP 262
>> #define PORT 9999
>>
>> int main(void) {
>>     int sfd, cfd;
>>     struct sockaddr_in addr = {
>>         .sin_family = AF_INET,
>>         .sin_port = htons(PORT),
>>         .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
>>     };
>>
>>     sfd = socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
>>     if (sfd < 0) {
>>         perror("socket (try IPPROTO_TCP if MPTCP unavailable)");
>>         return 1;
>>     }
>>
>>     int opt = 1;
>>     setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
>>     bind(sfd, (struct sockaddr *)&addr, sizeof(addr));
>>     listen(sfd, 1);
>>
>>     printf("Server listening on port %d...\n", PORT);
>>     cfd = accept(sfd, NULL, NULL);
>>     printf("Client connected.\n");
>>
>>     /* Send data so client has something to peek */
>>     char buf[512];
>>     memset(buf, 'A', sizeof(buf));
>>     write(cfd, buf, sizeof(buf));
>>     printf("Sent %zu bytes. Keeping connection open...\n", sizeof(buf));
>>
>>     /* Keep alive */
>>     sleep(600);
>>     close(cfd);
>>     close(sfd);
>>     return 0;
>> }
>>
>> Thanks,
>> Jiping
>>
>
