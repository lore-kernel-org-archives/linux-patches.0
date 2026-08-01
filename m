Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B0425B09C;
	Sat,  1 Aug 2026 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607519; cv=fail; b=cnD1Gnc6EHI8h16dYxngYfK6nxixuA+FEzxCIA93IWnx1hoNNGW5UNwHk20gzdnePm15hXdhBD0xIAoTG3a+GpOmsI80P4G+iVahjj6GhZ2tGktH1Hu5mAXVYqEQqTl9VtyCbVueRfY40wTFrhViUAM4S/vVSoOqzzKQQy9iD54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607519; c=relaxed/simple;
	bh=wzVREjcitU32E+PAqhpQ11SLC9I0Q+Da66qi7RTg3aY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dgtb2e4lIse5iZ1s8UpHhN6JsMEBdBX+429S6wvWv8r/cCZQlwhrDdaE63VhojZe0y2CHYP2e316ouxTkj/P1kwHOfXfybBrNit2NaZ3cEIAcyQPlwXAZIxs+bH2SibhMsAkB/2k5I1NUt2qGOV1ywdDF8FO3PFLI1x8tDH3tX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DkuRmTr3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qWh7jaH+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DkuRmTr3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qWh7jaH+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671HjYBC2902996;
	Sat, 1 Aug 2026 18:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AvseQ0znUTFXixqtQjAHXPzatTt7DIWc76RCzQxeA0E=; b=
	DkuRmTr3RHxY+RKcwE4UWrCbTTkrzRMX3kztIY4y0HtFvBkMrLrPzGShRgpY564i
	P6tnHZXaqaMzCJ48Gp2dRdO/Bd46KZ04SyeZ1eiM3ycBSxGVoL/S1qRa0uU/D3WT
	b2j1ByKv9oH9lewmKfP5BOfccK1d8rx4f76FKXAeCZI/nUPq3KxQMsPkVMcqs9NZ
	RonfWzDv7pzhWK1O/vAtpiSbGjAw/znGhKTvxLdAfcBz88Fp3EpWxGb7+fEXnBlU
	Ir2EupoCxioc2c7BFSYP9ye42U+U5wvsGpRfMoCQsP945a7TKG8daHzg58pYD/ER
	OXS4++bC5EaikSE3s2KL9A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p921yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Aug 2026 18:05:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 671I53Sg039590;
	Sat, 1 Aug 2026 18:05:06 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fs789tjpt-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 01 Aug 2026 18:05:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ETfhMlHb9S573f/0caBk04bHwuF9U3eak6UJ2eC/4IVkxPHr/etZngOecd/+V0G/XHW+LKpTifXZ5uOQ5EWFTqpdCaGBPjnfIVxCBNt0GF5iiA6GEpDHajQP7qVBwc0SN4bqr1X3g+Doz8IG3sia1v0dmtGltMk0KK//mjfSv+hYMrBEyIAG7LzRW5WYhSq+Rchca+ZwbhTb9t6tzpALQZlagTWQbOVlQmDVr4lBmOnYLb4kLoxj+V/ay1ZtBP2kmlA1gkCe5J2nDOYUR0qK/VXLZmoXNhbbLSwA1JEsSq2+AtoJH8zxS7zitag6BZkAkO5uFR7nrjQWbq+px2gBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvseQ0znUTFXixqtQjAHXPzatTt7DIWc76RCzQxeA0E=;
 b=iruOFwUy1lRxvN8BIpd9fE/cNhbcSIZ8q/py16Ai20HcLPsMCgXJTdDk6bhQV/uKnz5QWcMVBHTMw2Ig0HMi1VBql1G4JLjY0KtShDRoMMcGEdUjbDhE/P4g8Weway5W66AAigxRYNB2y7PMZaD3nbJFUUg1GsI5Cig9JNp61T0YI65+Trm2iQF7k+Mhj77aGe3PceLNHTsDKWoqMskfmGoQF4i3XZJS122j6wpwfjYY7CsjDbtziwrJenEmksQoOgmUW/c6eV5seRbFIUxqLpBeAuppJWCcoceRwwTpk9Rt2KCmC2THGjHEq0Zdzh4JCg4gBsNlXafpw/24DEGlIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvseQ0znUTFXixqtQjAHXPzatTt7DIWc76RCzQxeA0E=;
 b=qWh7jaH+BCVftQsbWZ0hgqc40UvbwKCpBVJ20Ue3umtMFSiz1w995nj7gurv4c2zFv+vW2M886NbgWJmxHfyzxlGqSxQWf9zAuhzUwR2AeEjJ7jay9z4oYFMBjV8DRFYdnh6JyMPw04vq7uE2jmbwBgf8mX8aaqhK9/1ZhaQDls=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS7PR10MB7279.namprd10.prod.outlook.com (2603:10b6:8:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sat, 1 Aug
 2026 18:05:00 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Sat, 1 Aug 2026
 18:05:00 +0000
Message-ID: <129ad991-e9fa-4f6b-bc1a-a1d78eff6145@oracle.com>
Date: Sat, 1 Aug 2026 23:34:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 541/602] bpf: Refactor
 {acquire,release}_reference_state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eduard Zingerman <eddyz87@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Sasha Levin <sashal@kernel.org>,
        vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141447.394161782@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141447.394161782@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS7PR10MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d63168-025c-401b-5599-08deeff7671c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|56012099006|5023799004|4143699003|10067099003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	C+rnJFlekwKsdZVlqosnsx05iA4HBwdWjvIPLL34L8rieittYC6J+rv6lJBEHgSzWYuRgj5lbyFxF5VpX9mog0yKcGYewK19sbONeXSnyK+PXHR0kH1OR4x2seI0oDtChh4+1b7Pe4nDW5FIqW3j5z0/qKtPEFLU3CP90CoPZ0TNTrJvCk+MQc9MvuEVi0Y/xTbgaNfoag7EHPCwNthR0DSqiuT8owkO2X7MemWHfycvH86r1XeB3VBThZAm8pZd9+AOqV6QWuAF0p7pqK6hR/F7DbOcidtjX7O2oXCFZkF4+OyHzwofEZ8HLTPR/wEOjGMdGj8toROR8kcrsHCcoDbsnfEG4SJhXB5gFeukvHk366b42ABorTK+VilB0PAQpUYF0v655Z6rna4AKAepN89QsdFcsXHeM1PtXmTzp4SsQNLbVofNlgcAQoIS/+ZsH6tsBJDeRDfQFH5f5+Dhtg6Ya2UFqDOv5GkVqe6MpXjlru4U+Km1bJGY75bPetgDf2h+K6sXLT3lmCPRp84VY/c4npyf3Xi+1NhzUFE8h6uRf4/QjCQdLyj5rb/XHmiVCFsLXPFyLc3CwWPqp6BmdXNZOCFC4kcvxmuev3NydDLdrKYQ4PdO7WmeRNcMC87jRQRxknf3rB3zi70N0lvAOnDNdKwGhWRa6HcHs/sZO7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(56012099006)(5023799004)(4143699003)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2kwdnpkcDFabDAra1pzWjd0VytYK0lkeGJRQ3BuNXdsalVyUHlQZ0xRaGVq?=
 =?utf-8?B?ZHJRU0VPM0xIeGZXb1FPTFNtY2ZMR3NxRTVydTkwdFlmU0czdjhNRHdIUFdG?=
 =?utf-8?B?R0dPRWpmdWNJNnovL0lWQ2w3dUZxYkVEUFZzby9Fcm5kR3oybXpRZ0h0bkR5?=
 =?utf-8?B?UFoxekJ4Q3N0ZitPT0FoSU16dG8yN0F1bnhVRnF6SEkrRi9ualNUWXJ3T0lv?=
 =?utf-8?B?ZmRMbVBoaklxajhrb0hLNUY3a2U5YUcxRmV3WTlnbVFHS1IzTEpIWHBnRXph?=
 =?utf-8?B?VUhCSTJ0NmRyR1N5Sm56c1lZYWVIMFJsMlVUbjFCZ3FoM25Da1ZBcUtQUGZX?=
 =?utf-8?B?YXpCTkVDdE1GeHcwamU2ZFFQRHF0aTlnNVp3UGxjSnJXODhldHVVWDIrZnlx?=
 =?utf-8?B?THhYTzdoeDl0SlF2a29YYStic2RQc2pWTnplSTZSVGcwaHNRME9BZ0owWG5E?=
 =?utf-8?B?T3NhQkJETlU3elM0NHB0azV3QW9hTS9UNHNlVVcvSkFNUVBvTGVLanhWZUJB?=
 =?utf-8?B?aDBNSkZvZk5IbkdSOU4rNHVhNzdLakZXai9lUWZJMXJiQXI2RlhKTGxFaEpX?=
 =?utf-8?B?TGZUOVE1TDhURmNtUmp5TGJhSWV4V2ZOaEdkWERpSHl5QWRvUUhlV3lQbGJ1?=
 =?utf-8?B?Tnk5ZTJZSURQYjE4NGNEd3JyODF0VGZRRm5wNXk3VElMTno1UEQ0S3paOVlO?=
 =?utf-8?B?RlE5YkJjMkpJemZsZm9wclRhejdIRzJqbEZ3ak9Ta2wyY3dIYlVkZ2RvNEEy?=
 =?utf-8?B?dXZiWnpGVGZMMndRUmozekxwTllLaWtvRWthRnlqQ1lMNjg5dEhzWFdLd09S?=
 =?utf-8?B?ZkttQ3hZQWw3ZXg3K2pGRE1KSGFzMVQxcTlOUjIycytRK3hadW9TRFdzSUF1?=
 =?utf-8?B?OUVkNlczWURCeGJxeXVjQVpjVkZwblFQVy9MY2drV0MwemtSMitZSjJDbWR5?=
 =?utf-8?B?VVVkdzJtamRyNExHdVF0bDZrTEFGZGRVNmtId01nRkZ3RGNXV0dvd2c3Z3Fi?=
 =?utf-8?B?aU1ncDZSU1JWc05RdWhXbXUwajZWbmt3eUo3cVRGTEhEMFpTNzlyVlVJbHNi?=
 =?utf-8?B?SGJrNWNld1lBN01xQ3htWlZ0REZPQXZFd0Z5dVlhbE1TUGZ5aWtPdXF1SDN6?=
 =?utf-8?B?UGVzcW5MT0hUcVQ2ZUNxU0ZKamtBSmdiM2xTNFRVZktGc3BQeEpHUkh3dkFq?=
 =?utf-8?B?WjBaWUhzRldQTlNIT0RYdlMxYnI5RzY0MDdKS1E2bmJzeU9IWmRxYUx5UDBv?=
 =?utf-8?B?M0hRTnhTcllaaTIzN2x2V1dYRStCb3FHTlZ4bnpsQ0ZIY0V3eWRadW5tZ25z?=
 =?utf-8?B?ZDNCbEJNc0Iva0oxekEyRDJWbFA2dHR4UnRlTGdsVXNmTWRaSjFjMUhKWlpy?=
 =?utf-8?B?SFBmcURqNVJwaS9VcTBqOW5JUlRBOCtjK1dSeCtjbytabldNcjVBRktiMkRB?=
 =?utf-8?B?WjdVUk1xQW00OUNBRG1QaWlWVWg4L3QrWng0QS84Yy9FMldycm1Bek5vd2N5?=
 =?utf-8?B?V1N3UUE0UTFNanF2Vi9OMWJUd0hTKzNOSXFlTi80QU1pSmpLcjY4SVBpTVUx?=
 =?utf-8?B?OXRFTC9ZNGM0VW1ZaUdWN1FZRGxMZ3hWeEdiYWJ6OTlRTkp0SkhDNExjbHFn?=
 =?utf-8?B?a09mckV4YTJVL1Z3Uy9sbGhWcHo3YTlJZ3pEVFhPMmtlYXo0b2pHQktnamlF?=
 =?utf-8?B?cEJSTW1iYXk3LzZEOFQ5dkhrVzVMT0laS01KMXErN1pVY2ZldzdkYjdsREE4?=
 =?utf-8?B?dFdEZG5OeWJZWnQvODd0Mm9sb214d3RHNlVJZ2o0RnRwSGdOQTdzeWtRNkxJ?=
 =?utf-8?B?VFVMV1d3YVhWVnpyN3h0VUJUd2dVSVZtVzlBaGI0Q21PUWM2M21TYnZnNlQ5?=
 =?utf-8?B?OVh4cjJ3S3ZJRW9WTjBvTjJpekh6MUJGalYycmxlTStjam13Ym1YS04yUEo3?=
 =?utf-8?B?M2Y5bENPWUlnQWQvbEFPcWxpTnZJRFAvbGVmdEtWTFdMeUs2Y3hJTXBVQUR3?=
 =?utf-8?B?aWwyczgySkF1c0N3MUl0cEhQN3g0M3cvVFVlWENBbUtrczBuM09hS0FzVW9o?=
 =?utf-8?B?TmkrWmVkM1N2L2dXdmJvT3NON0FtZENyenBQVHplQmFBbzU0YlVFQnFNK1ls?=
 =?utf-8?B?azhxNllMcTRTS2dyK2Jsb1Y3b3E4QlBhY2NjYVFWNFEyQmtJVGYzYkY0dGlB?=
 =?utf-8?B?QzNoMTV0ZjlXWHZ2ZndmdHQ1NzM2WmhQblp0TmNoSHo1L0p0ekVlTDZnS0h2?=
 =?utf-8?B?dE55cGFjQVBMcDh2R1p0Tkp5Y0pybEY2MCtQdVhtOU9hMmlNTnBnb0hicTVX?=
 =?utf-8?B?dHNMSHAvSjJMcFF4SVlja2wzN2NnbGt1ZVhjZHZDU1pxK1dndkV5UWJ1Mk5Y?=
 =?utf-8?Q?bvL7+wNnsKuu9SOJ6QYKBgv1dpXad/AlYZmq+?=
X-Exchange-RoutingPolicyChecked:
	fwswru3J1Dq1VdkRBPKWiTenuWGpMQ7bjpJ81WPTo5Zfxkw+M0UiB/Xw6QwmHH0GxbBEKZSdMeMrXRcADueCp15Lor0qHfQ7IVIxmCwCe6oC8jKRLPyyYpD4U9HciHZ4QyyJ/NFOLQZF/gQXbRP5XgdNviAJ5LZ+y7NKcAYUIKbddMxLuxtySOEenNmE67rRkBUXIr0gcN5yl4gvbENftVZSJCImpeIqIykev14KHXQhI8QEEoNnj5F8TefUNqp2n5pRam7T+wxl3HPHq6sSyWm2lR2ZBx53mnpaOdX0yUMLvQmKtjaDR4d9wMLMQHRhs47FuersUpwfnPSInHO/aA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jpGM9nedEtAjftWNbh09XpmeaKYwMPTAX6k+b+YTUgrkRDAOAN0ZE0iO8PLzrQ0fIJq7N3pkg7IaP/123VML43S6rJrzp4gqjWkUFxOKfRefqbOqXZ4hgjU0V/lzabI/lJddllj0Ap7WQJ636AVegkTS4eZuCfGhtFGTaLkOWsey1N2oak4tbpD5y1dFLhn0i8y2mEJsyOKhANxxLviChVMLAsbebZnVrRZvVY7sBNoAlX1q32BkrF3B3wm91z0dd2vnkg/ksv1UxWYoix9vWzJwguH5UX6gGyFOAudJBIt3ygyvHtvuiqVNI7U5KjjggiYjftPwspO4ph/4R2rtgY6vn45HFci8OIjJt9hYCAguY+bFGV73wbmcMvhIfs7JQ1t6oeifHqXHqI689XclC/5rUJJBwXsdRz11amSrjjf/Ql06iXAkV1g2jXtfz0u30yGvqGK9GftHHhIaMqEpxIephfUqSIPbEAIfXdXNuHQWmx7OyYrZ9Ij25j6Kj3KmuSZWhGOR4U3Iv0EjimKGSj1N+e4LLylW5Cml4bOTTPQUPmTwhV+a9DD5kK4CkDJt0Qs/6QfB4eUVKm5AR7IE11v3zTBXICtKIWvGsTSPOvQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d63168-025c-401b-5599-08deeff7671c
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 18:05:00.0150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPanrFq4QbXw5RHsUHENrd4w5h/EXmwLlztUWZbLtBPAooXkQRIo6inA2Ons1vtsZC8ClRTq3Gs1+E2CjJHIjH0KMPcbUg4+mLcfcNqjedkqQ41NEr/GdDyumznIN+Ya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608010146
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDE0NiBTYWx0ZWRfXykUkjdQ/79fA
 YJO05VeOYw2vwKS+sEkct5SHOG1nLTaQ7pq6jiLyOC/W8vAWOxOPCE7u0hk9gsEwRT0klxFgYyt
 p+UZl3uUAvCMbesHtPSAxBkrRyA81BsPy/qINeAjKnLKK7yojuYB
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a6e3552 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=TOpiHieGHApj95fPb5UA:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: x4kM2tLtMGqJfPO0UxDorgb3vyU7GPus
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDE0NiBTYWx0ZWRfXzENrThaHToZP
 DVaaS7u/PVb4oF9VDzTSq0Wx9vCqOA6LCYSPBhIq311Ccm8FKynVM2mGHFRggmdNxSh3belBEfV
 XqYLe5XTNZFb0QD04H8TDCM42MPiUf32neFLDrPyVHFP30m3L9FuGr0qicDg5ZzGFxrnVnOaSVz
 XUZ9kReWLyEwwnAjQJkKXjK/v9E3MF7AVukuIdCXohj7RXTwnV+P774ixnaB8ZIvwgU3i3HluIC
 Hst7oo/Ek3rAwo6RPtcq7FVAlX0oAOY+XojCn9MRsVGvmalLP6WxAfeme0nR4XS6arbDoq/AHnL
 FNMaF26dJ1egns5YTk2bPFfliLj1qJSK/OUgWe3SLKzrf6fNK+Kn0jJjVa93PfxA+V9YOBoPQej
 arSVunNi/Q/PvfMxtDXd0LrlvgO7wVofDKTxSje/LEJpbs7faYdXqJIAgjsmjWjqeYhttKvjccS
 eHIGfaYsS5QQwRVLJag==
X-Proofpoint-ORIG-GUID: x4kM2tLtMGqJfPO0UxDorgb3vyU7GPus

Hi Greg/Sasha,


On 30/07/26 7:45 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> [ Upstream commit 769b0f1c821455ab29baf42491e1ea1d726451fa ]
> 

^^ note this.

> In preparation for introducing support for more reference types which
> have to add and remove reference state, refactor the
> acquire_reference_state and release_reference_state functions to share
> common logic.
> 
> The acquire_reference_state function simply handles growing the acquired
> refs and returning the pointer to the new uninitialized element, which
> can be filled in by the caller.
> 
> The release_reference_state function simply erases a reference state
> entry in the acquired_refs array and shrinks it. The callers are
> responsible for finding the suitable element by matching on various
> fields of the reference state and requesting deletion through this
> function. It is not supposed to be called directly.
> 
> Existing callers of release_reference_state were using it to find and
> remove state for a given ref_obj_id without scrubbing the associated
> registers in the verifier state. Introduce release_reference_nomark to
> provide this functionality and convert callers. We now use this new
> release_reference_nomark function within release_reference as well.
> It needs to operate on a verifier state instead of taking verifier env
> as mark_ptr_or_null_regs requires operating on verifier state of the
> two branches of a NULL condition check, therefore env->cur_state cannot
> be used directly.
> 

None of that happens in the backport actually.

vimdiff <(git show 76344b7301ce) <(git show 769b0f1c821455) shows a 
bunch of differences.




> Acked-by: Eduard Zingerman <eddyz87@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Link: https://lore.kernel.org/r/20241204030400.208005-3-memxor@gmail.com
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Stable-dep-of: 5e0b273e0a62 ("bpf: Reset register bounds before narrowing retval range in check_mem_access()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/bpf/verifier.c |   28 +++++++++++++++-------------
>   1 file changed, 15 insertions(+), 13 deletions(-)
> 
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7207,11 +7207,12 @@ static int check_mem_access(struct bpf_v
>   		if (!err && value_regno >= 0 && (t == BPF_READ || rdonly_mem))
>   			mark_reg_unknown(env, regs, value_regno);
>   	} else if (reg->type == PTR_TO_CTX) {
> -		bool is_retval = false;
> +		struct bpf_insn_access_aux info = {
> +			.reg_type = SCALAR_VALUE,
> +			.is_ldsx = is_ldsx,
> +			.log = &env->log,
> +		};
>   		struct bpf_retval_range range;
> -		enum bpf_reg_type reg_type = SCALAR_VALUE;
> -		struct btf *btf = NULL;
> -		u32 btf_id = 0;

^^ this is actually done in commit: 201b62ccc831 ("bpf: Refactor 
check_ctx_access()") which is next commit.

I have run an AI assisted backport review and it spotted a commit 
mapping problem in the BPF prerequisite series.

76344b7301ce claims upstream 769b0f1c8214 ("bpf: Refactor 
{acquire,release}_reference_state"). Upstream adds acquire_reference(), 
release_reference_nomark(), and changes acquire_reference_state() to 
return a reference-state pointer.

The 6.12.y commit leaves the old int-returning acquire_reference_state() 
in place and has none of those new helpers.
Its diff is instead the first part of moving check_mem_access()
to struct bpf_insn_access_aux, which belongs to upstream
201b62ccc831 ("bpf: Refactor check_ctx_access()").

The next stable patch commit 4ee2d0ce3e82 claims 201b62ccc831 and 
completes that split before (patch 543) 6261a33d665b applies the actual 
bounds fix.

So 769b0f1c8214 is recorded as present although its semantics are
absent, while 201b62ccc831 is split across two differently attributed
commits.

Maybe we could be replacing 76344b7301ce plus 4ee2d0ce3e82 with one
correctly attributed adapted backport of 201b62ccc831 before
6261a33d665b.

Thoughts ?

thanks,
Harshit


>   
>   		if (t == BPF_WRITE && value_regno >= 0 &&
>   		    is_pointer_value(env, value_regno)) {
> @@ -7223,8 +7224,9 @@ static int check_mem_access(struct bpf_v
>   		if (err < 0)
>   			return err;
>   
> -		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf,
> -				       &btf_id, &is_retval, is_ldsx);
> +		err = check_ctx_access(env, insn_idx, off, size, t, &info.reg_type,
> +				       &info.btf, &info.btf_id, &info.is_retval,
> +				       info.is_ldsx);
>   		if (err)
>   			verbose_linfo(env, insn_idx, "; ");
>   		if (!err && t == BPF_READ && value_regno >= 0) {
> @@ -7232,8 +7234,8 @@ static int check_mem_access(struct bpf_v
>   			 * PTR_TO_PACKET[_META,_END]. In the latter
>   			 * case, we know the offset is zero.
>   			 */
> -			if (reg_type == SCALAR_VALUE) {
> -				if (is_retval && get_func_retval_range(env->prog, &range)) {
> +			if (info.reg_type == SCALAR_VALUE) {
> +				if (info.is_retval && get_func_retval_range(env->prog, &range)) {
>   					err = __mark_reg_s32_range(env, regs, value_regno,
>   								   range.minval, range.maxval);
>   					if (err)
> @@ -7244,7 +7246,7 @@ static int check_mem_access(struct bpf_v
>   			} else {
>   				mark_reg_known_zero(env, regs,
>   						    value_regno);
> -				if (type_may_be_null(reg_type))
> +				if (type_may_be_null(info.reg_type))
>   					regs[value_regno].id = ++env->id_gen;
>   				/* A load of ctx field could have different
>   				 * actual load size with the one encoded in the
> @@ -7252,12 +7254,12 @@ static int check_mem_access(struct bpf_v
>   				 * a sub-register.
>   				 */
>   				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
> -				if (base_type(reg_type) == PTR_TO_BTF_ID) {
> -					regs[value_regno].btf = btf;
> -					regs[value_regno].btf_id = btf_id;
> +				if (base_type(info.reg_type) == PTR_TO_BTF_ID) {
> +					regs[value_regno].btf = info.btf;
> +					regs[value_regno].btf_id = info.btf_id;
>   				}
>   			}
> -			regs[value_regno].type = reg_type;
> +			regs[value_regno].type = info.reg_type;
>   		}
>   
>   	} else if (reg->type == PTR_TO_STACK) {
> 
> 
> 

