Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3468F415F08
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542854; cv=fail; b=mDvrt/JO8lB07fcHX/ykOZ8ExiRvfkvyZMFcDlZnFXwS8c9V/ndLGFVY18nNDcwWf85oK3gajIbJxrcp0o72yf8WJcW4qIWCSQpKqAfAMuBJh7JZjEjoLN/2R4rOrMub+nOGqgZvNuWmURRNuer8TJdkGXyWd0SJYfYlxAEZuic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542854; c=relaxed/simple;
	bh=4Y1sGQXpEnGHWc0bo9zZ/8c9nnr19sWOlvI1UzCNj54=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n62JtOxZqlcCP16SrUlFYGhW2dzrEUu+4QB4YLjYQwFryJM6YSow2h+x9M/9Z86d7knffQ8C0biLRnV/o820vt/QrOXQ7viIFvAg8BhMLUSCFSZkLZqntYGB3FoCalcyMbzA4la0T5yq00couDWUlJFDKVBJd3lDjW+VQIrbhGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TU8bMHN/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eqqow2AA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TU8bMHN/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eqqow2AA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLX82n699506;
	Wed, 16 Sep 2026 07:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OQ26CWc3XO0VywNFwX7XqyMr71nYsAfVSzktgONqTTY=; b=
	TU8bMHN/HAi4yrfbjtJLmQ+gfHIRbqniJY6wePDgNW+6LGQ30HAOd+tZes5jpxtj
	sA0lm1YMeVAZhYVPUJ3X5bFCRjbO4CmcXhb3u0kIKiNNufPTehkVvr+RTxL579kv
	OfBSLDtXGKYbPmoJJi/3a8Lqo388vCxgLnaRTA2tHHqQMVslgEleI4N4GV73wUID
	klXo/hR4VV5Dt4pjg+R/ITRPTmgdj2ZfGpZ/eT7864u0CpDfynL3Ul+OVdttjJS/
	LNmxH9dtKKMrp0s2m23VHUxBG12niaRcddFI+a1gTvporCBiHOtRAI5Kp6pejPXC
	1b4FM0BjXqfEmfn0xuvAIA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7d22h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:13:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7AOr5024352;
	Wed, 16 Sep 2026 07:13:51 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q7wre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:13:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIuQhNc1j73obqFKswU9cyNzTb/gRFSWMuVue8r7QKQL0W1DotOIci0p7U8Vv9W+HboeYdcc4NFtXrB3cbRDOwrP7cUeAcLqEbUR33hKHgLgZFwAFkVTpfpwKZvjmbM+zhnzeAFpzhaTkGKpnhEWTsLaKvmUx6r4euwXxjM/eusy8aZti1CDNMvGdvPfjSoK+UVXOCkPv7H7N8H/FVAG6x1BDEexmppNMBym6vZOHa2kp4rEMjoIm/SfnmI0L9X2F+tl4mcb0WybVUx7uKH7ml1AmG+qdVkNnHLFQ+4DLGloSQW/oSGuRhODsoYOF77jZ+q1d4gG3e14bRAMkEwYJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ26CWc3XO0VywNFwX7XqyMr71nYsAfVSzktgONqTTY=;
 b=phcQ6mQ565RiWkhWNS08lzakWT1Md92HvD/42CNk0j96JmueiaYt7fN/ofLq3GPsQc+3zR6LPBDk3O4vyBvJfJ2M4X6GU3TBw2lH81DIzSdtRXntdnOnDRtXxLoXICRWH4QsqxaPU6TlW/tv0/ZbP0rjN+l0Cb1fJCZLyyDWQ2waX2sJLgsse8hWf7MdzPPshBMJORFFt2gucCT9lG/6wfNOz73vyhHo5m+IH6tdhWyUBxV1zcTMO40bieYw/EQl1sgcES7sms63VeJx5vLMpUtDt+l5Y8ZgC5m0sOeLrlVsPPNuxrxWpAeBzUhtznRFsidB/QAOmQmWtsU780LA5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ26CWc3XO0VywNFwX7XqyMr71nYsAfVSzktgONqTTY=;
 b=eqqow2AApE5fG31+97AEgApNiIvS59xuNJM3zuXWNot/vQxtOgNL8iVgHLiDHRsg+fRs70o+hqdTU0wA3jcnaUIElL7Ia6Al7yFcUBY4vBO3yMgqmLRVOIXNzko2/oNdGrRxit6lXeeMeXnC3ObR5cJy611PNxLU3H2SX+6Ktd8=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BY5PR10MB4132.namprd10.prod.outlook.com (2603:10b6:a03:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:13:46 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:13:46 +0000
Message-ID: <b0e3573a-1a02-4f21-bbd3-775f78a90c75@oracle.com>
Date: Wed, 16 Sep 2026 12:43:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0353/1376] perf tests metrics: Permission related
 fixes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Clark <james.clark@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Weilin Wang <weilin.wang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065615.418482584@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065615.418482584@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0242.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BY5PR10MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: b8dd3690-c2a6-48b6-8af7-08df13c20c4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|18002099003|22082099003|4143699003|10067099003|5023799004|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	nCFk/ypOMYH5wpf2BMdOrczbJ07xj2jv+8ySzYI+m8UwopA59prWFkNN7yi4ZAaAhX5cnaW52M0y0EqbMdFYQiDbJ/ViJQeD/PlW5eBs9UdUYyeEzQFGwVStS2ipLxLe8tyc2qQcwJZvOrjff6X12yaGlts+wpfYQ2MqW+Heydo8/whFq2ECaMAc3WrgBmGctH8whrujoxfTFJdwAziqTtWgILt45Mbn3CNzRK6h/FJS96+wV629X2tEsJxK4UgOQi+PvKECAsP7wrUOqZks34ySTQil8nmNfo4iHSOmLTr6xOPAnvYixvfu1auYeBkRdfqh2TOwvFNNuql/hBblYkN0v0l++H9MgRDc0p84+ZZX5546AIjoV8yumfL3FU7w0d4e9cWEuE90mSdq/UjARFVIt0OJSdyBvVt8yTFpp1RYcbRsiPAlLYrWyHq5jVdlCvHrpvss7f4/bhZO9w9g11a9nSCGZb+PFgZVVABOJOCTl42Z9t2B46WC+bh3/pwGu02nC5prPWFYjWBslescV7xVAJ3dM+uMcWcmMOQaXLhre5Z1pjfKn3OYQwadfPB+j2ib1cOGEcsls5PY94TcXfde08C9/T4PnuvM9hLOl5o/ctUCGLYYJTvQ6c2juePB4qklAq7NItGgay3E3V3uXv8XcrwiDlRrk58AFcE6P8Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(4143699003)(10067099003)(5023799004)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVlrWUpMVFdjZ2hKRTVlZGQxcmdwbnQrVlNlbjJORDhVRUl6R0hiNmd3Ykhw?=
 =?utf-8?B?dmVoWDMydloxdkVxVzNCOW1ZVGY0b0hZZVdBelUvdDZRc1lxZGt4VVRkZFYw?=
 =?utf-8?B?WjhiREg1T2tDY2lUREEwbHJoa1paeldPM3A3MlpkK3J6WnhOL3hLeUdOcjM0?=
 =?utf-8?B?U2xDTm8xVU81cHN0dnB4WWhMNEo0T0c3dlZoSXRIVDFPbWZnYUVFckNSYkc3?=
 =?utf-8?B?U2ZjUkVyYU04bmZDYjY1V2UvSVRYZmZTeEFRb2h1a3l4bGEvalNPNGVna1h6?=
 =?utf-8?B?Q3ZPMGwrd0s0cTZDTFNCbHZPaVRJd1dGdXR6dnAyK0R4dTNldzYxR1lhUlBR?=
 =?utf-8?B?Vm1EK0psU1JWZzU0OXAyWmxpQmo5T2lLS3RpQnY0dTZoUjVxWjBPckhPbit3?=
 =?utf-8?B?U3VoUCswYkNjT1d1dFhWMWdHcnhrMUxaWTE2Q0FoendNOFlwa1BQUzk2RW9x?=
 =?utf-8?B?V0VaK2V2ek9UNjZIOHlQaThvZURiTEdpdE9MWFlablpHTm9jZ01jM1EreXlh?=
 =?utf-8?B?Wk9NV2plQlhxMEZZa0IxVWM1RjB3em8yT20wY3MxTzVRRnlCZ3pPWnBPTTNu?=
 =?utf-8?B?dHBTWDhCSGtSbDdyejFnQTNzZmQvRDJ6djhFM0NCbEwzNmlpSFBZU0k3cStt?=
 =?utf-8?B?YUoyMG9WSkUvMjJYQ05tY2FSK3JZbldSTVE1OXBJSFpPdUxNMWxBTTNMLzFZ?=
 =?utf-8?B?UGVXcGQxVm1LaGhqNFc1aGZVbHR0VjFCNzNCOWlvRTdISks1VFVRa0J6Y3k3?=
 =?utf-8?B?bkdqMGU1YlBKMVRGdUIzYlo0OUl6UlZFV0MwSjVGQmVwUWJlU1RxdWJsbjVD?=
 =?utf-8?B?RzY3Rkx6bmM4WVNzRE5IT2Rxd1RjRkRmZU5EMDZabEtsMW9EenhmRUVYcGZS?=
 =?utf-8?B?V2VJc3pWcHJSOWpHcnc1SkN6ZmhkNngrNldtbzdURDl3ams4QnhrU1orRnZ6?=
 =?utf-8?B?R0pXV054S092WHlRck5FblZQdnhUQVN1OCtxSkcwM3pGTEl6Nkcwb3ZCVlRv?=
 =?utf-8?B?Y0FQeStTRGJiQ01Idmt1NVBaNnF0WHZoMGhoeUFvbFNwM1JRSnV2bEJxb3Rr?=
 =?utf-8?B?NEZZT3JTOUFxbmNoQWFhK0VCSVlvZlh5b2N0WjMwb1hLSEJ4RFVwN1VvWjBq?=
 =?utf-8?B?Z1ZaKzlzYU5iT2FHR2R0Uk1JMllPZWREVVA1TVFmZHU3R2M1ZlduSUJhUWl5?=
 =?utf-8?B?NjdDMURuOGQ3QmxrUVRSYjdyTWEwdy9Xc3BFQkdZaWEvbTdUQUtqQ2x4UGhh?=
 =?utf-8?B?bUJ6N1FmNDU4VWZXV0t5RmhqN1ZMeUdFMTVoam1SUGpDVnIrUnM0OHptMzZN?=
 =?utf-8?B?aGFHNkJjdTlwWUhJOXNJNFQ3d0d1R1p4NlY4NUdSazY3MVhWL3c3UFlqY011?=
 =?utf-8?B?dS90UXMrUXBzZWRSSWFYeDViNWxvVmhjOUoySERuRjd5SDRXS3RLT2VrUlZW?=
 =?utf-8?B?VEV0SndPMytiaDBqSVJvanRXaGJidFJWNmNNRlZobE9raFZHUWV0Z25kdFlX?=
 =?utf-8?B?T05iWW42NSs5cnNyejlSY09WNTVweFczUlFZcHZLZ2tyZFB5ZHJEWXkrSlI3?=
 =?utf-8?B?MnBrZHNPa3ZlSEVpZExwNmZRN3lNbWlHdDFTK1dHdTRPSS9YZHozUU14MWZh?=
 =?utf-8?B?WGNDZUp3dFRzRlEzRTJZdkRDYlFPMG4rVzhKb2xiZGF1MmZVWVFHTHlMaUkv?=
 =?utf-8?B?bGNyZzhZa3dKUzhkZzFzbTFqUUtTVmZJRVFuZWVMOG5laWxwU1VSY0d6Nlcz?=
 =?utf-8?B?SjAwVzF4RjhpVjlweVZvVWU3amFYdXNjd3E2aytqeFQzMTRKQkE4K2Q4NW5Q?=
 =?utf-8?B?ajRGYjFWT1dTWnZuNHBWMEFYRzVRTXo3SllUdEZONXRrbENNcVJpWXZ1NWls?=
 =?utf-8?B?ZjArcVJVRUJLWVFzUGZYdXRPMHptY3JYUEc0aCtxOU0yS0JrTWdleHRSOW1O?=
 =?utf-8?B?dTk0Skw2M3RaS1lHd2s4RWZRUDdSTWhEVGRoQlBhV2J5RW4wYVJLdWlUVitU?=
 =?utf-8?B?bUJtbW83RWFxWjJ3VkVTVkpRSEtXSW5aSkVweTdVVUNqOG9qMDVGZlFVUG1o?=
 =?utf-8?B?N09HbFY3Um9tK0JacndoR0JUYjcrUUZOQVB2MnhEclhnMENLMnNJYUQrcHhX?=
 =?utf-8?B?bDI4ODBvYTlpVWJyWFJ1N2NqakZRUWQxYWh1eGd2VVdKUXczcklIZmxCNjda?=
 =?utf-8?B?OGRmY2NVUVBoUUluMHdqLzJZR0dLclRPYWg2K0twWEtyTk5vSGlBM256RDd5?=
 =?utf-8?B?b25FMS96aG9YVTVJcWhIbVkwL3gwUkRpK2VGTTdsSnRGWGJUcmZ5QTFES0ln?=
 =?utf-8?B?ZnBnUUtON2JxRmovNXdlQ1hJQkEvQVBRREx6SWpuS0RGdU9FRnFtY2lueGVq?=
 =?utf-8?Q?4ltiYLOb7kqNLHHO4VNMKwpbPJz5DTJkYaIcz?=
X-Exchange-RoutingPolicyChecked:
	YL+YGRQVmnr2YMMBXJ64iOCVv005SjYe5ztPEALDeh/+/1FZM2Ew6O9VuGnRiocmkMvjV7aGM9H7I3if3Rth71Gm8SjcmpSM3pstle1Vq5E9CcMx5wTfHj3wmtatcRTLbYJYo3/elSzBsM1VL/S40NSYGFRbl/q2TYI6wdCPdV8GpVoidwp0rAouYTp8vbXz4Ukk4yb1cTbFBU/lHNe9u5ij5rTTCQH/YBHspicxsxdbB0mvbUoeNLj3CzhGhLbNFuCThf8hkcBvEuiVYNxyvabI4qslU1KZic9UuRoCG9mJH3i3ABTOWLPFji0xu0DrXaN1/bmmkfzI7fKAKTTL3Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GvRBcornWNPc0pjODFxTQixaV/BnUQYbX6evs2748gwcDUkNOphNTKKCSbmUvQgQmmw3CcCPprr63ufkAYqs0WUGTqXh6GFJV2xdhZWshPNwAbhIH9bBO3HGMReDekJ1j0u7phCGsNx5T8kYXAQ1dR3w/s1lWtxzUnP8xYzgo0n7gsbEShNGa5GeYzlOMCK09+fKGz7OQisstaTyopEKbYzouUWkr9Cqf4Jo5eRPEkE+DdaDUFNIkpCqRaNkBJeR8DV9yi1Tlc6BuPhEymaXKbUF3oO7ZcnOltOv2noeRwQI3dLzzFPSyHTZ5pEKfKDrHBCmpjF2QlVGMG/Aqjc+fP1cdwC2M7dC7eNdJHCbzQUhHeYWM37Ea5IZD+9F1+FOZDzFJclRpV3G1gj2Sofp+jPva24a/vCAcFit3Gu9tgeYAzL08e9iDNG41v2Er3s6SJxewnbsMBWt/LCdIQysSPHKv+cAir9UzzOiaAuP0ni9jAU0PxYzkZDXxUUWMm64rmefW2N1PpkRq8kzUJmGNH/2NeBdXKW1moE3LjSU9Ku2gJ5Z8a9TwfOl8/XIIlBlGZUSnMuT+RQ6a14xUapK4A8qKjpKUWLHID9KYf0OyCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dd3690-c2a6-48b6-8af7-08df13c20c4f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:13:46.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQF/e3R11QhvLUHmxaAEjHCPEerR++iPt7s2iynJDEdKB5KmrbKOpSDgKfvgwQgPlrg+WADmPp8E9/wiPpQ0F00M4TSW6wzT4JHeuk7B0YYZR3VyrWpMxQqO6El0HPQ7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160091
X-Proofpoint-GUID: 0cHXbpM7IpWZbac38oF1NBiakvSv_ja0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5MiBTYWx0ZWRfX1bw3vzi7UKEV
 LJtN+9s7QMKVyTZYeSVyScBwE0GI/IjhtYscjNw6pXRn4FF92uEsbkB98KTNDTwX+lXeG9JVhB2
 GeAES5g62xDAfJCp6+taVn891dGZ+0slnm8s6rJZ0s/rdkkps4wyAuG1CI9Ja+vFR/IAXmCTBPe
 imkXUq9txdbES6H4p0twnMrUQQnZ1IkQyM8yYQx66GeMg+M6/bgDUTvD4Tx3ryaqUDThXWEtj/r
 nQEXEbk+DRxNoW7Aq7l6ma+cZsKlXR1gY1/b41ax/Epg+p9kk+Idemz6OLLfay9ybyUedJKH2q1
 4HsT8xVVTSKeEZ4omI+OTUlNLJJ7nq5HYS088CU78qdgPV43SVlZGtiizm1w/BpQ+iQg4WkiXib
 KIPQ2cKMxP3xEFI6eHKR3wy0ma6vHQ3DLkApoGsdZJ1xaqE405v3oc4L5jUp5BQL5UxqsePfCBD
 0lDKzj41gf27x1UU7aK4IaJ6ZRoJJ+aml2L0GwZ8=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5MiBTYWx0ZWRfX60xXkkdCpb1v
 pTjx2jJgRPcHdbV4kc0y4MQcQXrR312oSn87/T5qktPGVmAYBZuGVgvNBqUgjH4LIRRC58wWRDa
 W+fE7Jv1nEgkHbgHnwRILl/h4U4DQx2nuPPNwLR/JmuKLBY2RVD2
X-Proofpoint-ORIG-GUID: 0cHXbpM7IpWZbac38oF1NBiakvSv_ja0
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaa41b0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=KKAkSRfTAAAA:8
 a=7CQSdrXTAAAA:8 a=JfrnYn6hAAAA:8 a=i6NvTWX5diBxkr5FOWoA:9 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532

Hi Greg/Sasha,

On 12/09/26 12:16 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 365e02ddb65d443f1ba16af5a4ddcd638f1e7823 ]
> 
> When permissions are limited running sleep without system wide isn't a
> good benchmark to run to achieve samples, switch to running noploop.
> 
> Remove indent for non-success cases.
> 
> Allow skip for the not counted case.
> 
> Minor debug changes.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Weilin Wang <weilin.wang@intel.com>
> Link: https://lore.kernel.org/r/20250412004704.2297939-2-irogers@google.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Stable-dep-of: 8953bfd8820b ("perf tests: Skip metrics validation if system-wide recording lacks permission")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/tests/shell/stat_all_metrics.sh | 118 +++++++++++----------
>   1 file changed, 64 insertions(+), 54 deletions(-)
> 
Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The test now uses a per-thread workload when system-wide perf access is
restricted. Its skip logic relies on the EOPNOTSUPP per-thread
diagnostic added immediately beforehand upstream. The 6.12
evsel__open_strerror() falls through to the generic error instead, so an
unsupported per-thread PMU can be reported as a test failure.

Upstream prerequisite code:

     if (!target__has_cpu(target))
             return scnprintf(msg, size,
               "Unsupported event (%s) in per-thread mode,"
               " enable system wide with '-a'.",
               evsel__name(evsel));

Downstream 6.12.y test code:

     elif [[ "$result" =~
             "in per-thread mode, enable system wide" ]]

I think 6.12.y misses f0869f31562bde, "perf evsel: Add per-thread 
warning for EOPNOTSUPP open failues". Thoughts ?


thanks,
Harshit
