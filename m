Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D442F87B;
	Fri, 10 Apr 2026 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775848132; cv=fail; b=MtmjhQKSrow3SWSqk/eJQW5dHx8OiYwYuhL5xZyrH0BhQOwsxOFtltAl0M1Aj3L4BN9pFzMLf+21ab6feGJll1e3KvpHryJSODjFa8r9U4c+i9B9K2MTmnTi2GP8he/igstt6dMsfX+U4Xq1i2iMLZKFn8J3UVxnzW0q1aDOXbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775848132; c=relaxed/simple;
	bh=UnuZvjC8uppI80UfL/81yUgQyrTxQnis//ObXNTNVD8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OaFZ65F32S+Hmc47tRyVQyRF4BfsU7InN/lKuYO+uJaVWeTuFffMhQwPzkS9P1v9OAOipX7257rjljoUegMN3S5NW9+8TCBSmHvQiBMt1YDRkJSSAmJ1m29igtEJe0vK5reOqirBKwmSDmzz4m2xwfOi5bSRhj+QwMFiJVYhX5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=moFpzCfS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MojelTIt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="moFpzCfS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MojelTIt"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AIWrV3518523;
	Fri, 10 Apr 2026 19:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=299Smj8P9GJ0vUe2KN3cUWuMnRRiZQIaZxdmR5QKG1Y=; b=
	moFpzCfS2g9Rru7sj48MUUi/0i9Aqb51tYJuoiO9sbSXvgSBU1gt/JY/mRZS9dnm
	QUACIvDxVRM1gzySQyEbAG4gGKmqlKrzqd/amINtGM0bK6YdEQcjP1VpklnJz1CZ
	mHapYRgP+n1CtIa6uud4yp7GgkVc1c7IN+BWhaOfJplZTz1NfMI1YNGZEb7G4+X5
	4eXXr7gmtDniqyIN0WsK6IBjtv+Jx14DQFoQRceklblZflHRrYQj9ydo2piA+yxq
	3bd/BSAOULkR7maBZMSXnCdjbL4nPuBeZBltrN6r1AuGFYWKtgfj3YdwOUTSvn77
	0UXeDBfqb3ZjShLNdqUaBg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb2evf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 19:08:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AHLUsh007431;
	Fri, 10 Apr 2026 19:08:42 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010024.outbound.protection.outlook.com [52.101.85.24])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4deydp9n8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 19:08:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QONlF6bYSWgW1YTHwMe3yGLbErUJ1F+QtRvTVRDroJBkQ+ytnAP6vlwjn/IXvqTsgbn52Sz3iBeLLELLpfrgQNJBNOSDk7wWys4HkF2aWNkgcaUoSOU1fUYRie2Aoz0jSt8o6j3xCgQjPHBBCMJxnqhNSvg0vVaLQa0T4h+mWVieMs4PFoABGy6pxz3CZVlOa43Eu8MZzwDNLQGF2VTFFjgtZ4kyKV1CQuaI1oa9MOHTGQDOTj0/FIIjis4Ev38oGjj2+ZtYf/CCzenMKwDx8xL4aykRsVIKPvHowbrO6pfWnKlU53pXzUSc2d25a9uPEYuGbZiYX9r81sCVqrn/cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=299Smj8P9GJ0vUe2KN3cUWuMnRRiZQIaZxdmR5QKG1Y=;
 b=O0LH0HAppk1q5t19d+0CsPZgZQKI9MU8RqlOtiNsjA6ZNvbJNJSjWJxaJjSH178gnJIPugWTSCkdg6QbedcfyqlmOE6nQwLNGDMf0GTuh/9rlXxRFSuObdT+itSXoz9kxTdL1Cku4bqXraMMUNcw/pI+ccZrRxM909F5zYqV52F2WQPFrNbVVq3ToCzlGsAPWXR5J/6rHBbxqLOFtiGfS0p/T9j/F/vuFBq+Edh/apHLB/P32V3LFcaLML8ka7ejqjkkLkgio0nlC/9pRDl8on8urANYx0sCLVNp5PmUaFwnZ98P/3Y6MCJZgLXEaSyrm9OXzNYfsPekQx19pGOhqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=299Smj8P9GJ0vUe2KN3cUWuMnRRiZQIaZxdmR5QKG1Y=;
 b=MojelTItep2PS96zvzc4BoBx7pNiuK4drphC4xDl44JDBJ6u+nC/ie0Yu/OeqO6uPH0qchqlFVpGqzJH3M7rzVAbtHzBXyw3WAm0IqXpZ4njdVpNjwJjn54+525tXZIsuYjzAVWbirhhI7g+qbTTUSEVDdjzBWZsYxxWYDjf5f0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA2PR10MB4411.namprd10.prod.outlook.com (2603:10b6:806:116::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.44; Fri, 10 Apr
 2026 19:08:40 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 19:08:39 +0000
Message-ID: <eee63d31-f7a2-4737-b33b-cfea7f04e960@oracle.com>
Date: Sat, 11 Apr 2026 00:38:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 230/242] drm/amd/display: Reject modes with too high
 pixel clock on DCE6-10
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Rosen Penev
 <rosenp@gmail.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260408175927.064985309@linuxfoundation.org>
 <20260408175935.705507105@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260408175935.705507105@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::21)
 To DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA2PR10MB4411:EE_
X-MS-Office365-Filtering-Correlation-Id: f4881132-bd6a-4d0d-5068-08de97349345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OQoaA3sySJ/WBHvzncyjssF5Y1PmGMdPdof7lL+jKIJ3qO1k1+AXQ0+C69CGK+4Ax43V9QbCZvAYdDUkVYlupQHJKVrSCxxMSOph+se3DrlqEsTPhH+5fFReMBxevybN+QqioiVi9WzuzEfhOBeGSD+1m1ykwv2P+1vnK4UrqkTtg9ZsMtT00F4QM9NKQjzfWtRm7OJeIKjDJP7JSX+S9AckMUwQk5AodGNQu1U6GHYWSNEkUu96bucIAGk85tRHUYOZHSiE/UL2V8mGPpDe/pPsVw/b+thk0vy67fGnTN6onKHPvb7Fdjy1oTjGt1jS6qMgWOjgv2sar6+vYmf6NebW4jK4eG5HUI3RxrXLU/nbDlpU1PlKg0KzrouYDcKTloWwOO5vRwrMkNSyVdh2Ae8jjxMFBmcr/Id0Jb9QEhwuaNsb18BOxcGRbrQqT/KJczYBGEahgxLjAmm9GlZ1IAcOLR9WjtxDW5snVTdRQeJkRtJLoM/0FJ8b8h512jc9MtJpT6A+qqAcNZt2veWl2l7OYBiALy44T3ylYFMYWW+kr8HI9YqVLSrlDjGocFvf8AJ2xZZFLbKfEc4nNbtYXaab44N39qHJSx/kiAKKarU1e14al/O4R2Iz/GcDELcdeGqXtWHhHURdTdlXzleEWkRRQuzGN3DWPaHHqw7nxPa8VaES2LWTItHzS4BDCb83Dwpnt3mB+YLO7DWnicE7T+9eNkehWhC6lVLLpsT/lPo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0lHeTNzR0FpeVpWdEtTM3RSMTVscDJDKzI2NDROZjBwQnUvSFQwT1RzVzZp?=
 =?utf-8?B?YTRpODdNSFhYRFpFZk9GdzU5d3k1NHVQOS9Odm1TOTI5OTl2M2x1bHVpa3Ni?=
 =?utf-8?B?blJDQW1hRzNYWERQb3l1Nmt6b2JIVWs1Q3k3S0ZZZWY3Z0FUZTdKQWdudkdv?=
 =?utf-8?B?SG5razBnMExWa3RBcUtTOGN6c21oSUUxR1VzMGxpcFhDMzl0cDJQRjI0YkYv?=
 =?utf-8?B?UU91RjlENnR5SzNBbUgzcm9MRERiNXpsU2haanc4MytkcEd5QVlhVTBoa2tG?=
 =?utf-8?B?Mkl2OVdXWGZUeDAxbFFiZUptRUVHc3NSOEZ3bXBXSzU0R0xPVGJQWFc1UDJ3?=
 =?utf-8?B?OURwZk4rVUZPYzBiMmllbUxUYTgxVG5uQkdxaTRVWHl3LzBiVmRzMDRqMlkr?=
 =?utf-8?B?Q21EcndpRElUSUdrNU1kc2grZnpSRGRZOU00eldZdHZGUTZ6b1l1alVKMzZQ?=
 =?utf-8?B?R1F0eGUwYmFTYllCUnRoNFdNLzZLQTE0MHIyS3ZyVHoyWS9zZWs2eW0yUGRx?=
 =?utf-8?B?TGJHM3NlWjNLRTJzL2t4UHk2ZmxSdXNUSHAxMlo4RHlielNJa0pQTXJIblFO?=
 =?utf-8?B?MldNSGxHZjBVcDJ3R0xiTU9pZWRzZHlTaGFoNHV6Y3Q2bFdCODBiak1qdlJC?=
 =?utf-8?B?R0dObzlSRDFQa090RW5YbDk1bkE4enBrSGhseW5vQU1QbXB5QVVYL2NLMkFC?=
 =?utf-8?B?WmFOZ3FsY1RNcUlFWHhsalJERkdrMFR5UTV5S3lzeFk4SHpDZk5PQUVMSnlw?=
 =?utf-8?B?a2VGZnpkRytMOEVvK0xtYlBKeVJwYXNsd0dnSEw0eVRZaVhTRmtKZGFmakND?=
 =?utf-8?B?K082OWtLc0w3eWk5YTZlZCtZak5oaDNRN3RUWWxOMGJNdyt1bkprVDMxdWpq?=
 =?utf-8?B?MTlWMmdMMVJyazFpZkZCWXAxYm8wRmxTbW5mKzZSditRajVPcE56YndIR1ZQ?=
 =?utf-8?B?N3REQjdDRVhJWEdLU3JMSmVWRnp1WmVBN2d6VU0yYkwrNENNTkcyL2dPR0ZX?=
 =?utf-8?B?UWRuMTlYSTI0VW9pTzVYSHlCVkw0M0E5ZS9QWDl3b21NYmxmYVB5Z2JZSUZk?=
 =?utf-8?B?aUFYalgyZXFybFRyRHh4a0J3YzFvbTU2MVh1L3l6R3BUUEpaekhkTEZ5cFFs?=
 =?utf-8?B?OE9CV3JHS1NHOEQzWXArampmVnEwdGxsRzhPaTV0Ykw3djFIS2dTSGdOamJQ?=
 =?utf-8?B?Vk4vMUR5QUlvdVIwTzVhL21ESkRpT2M0VzUwWG5rTGFzcWhyZVZCVXVJZGM5?=
 =?utf-8?B?OCtsVjBOcDhxaUQyYlpDbU04czZqNEJpN0p5U08vK0cvbUhsU0ZmRVlYYVl2?=
 =?utf-8?B?V0ZodmFGckJxaDg3ZDlMVnVnaG9uRk5CSkU1bXovYnRoKytSZG8xL1h0ZUhZ?=
 =?utf-8?B?UWRHR3k1V2MwcmtFL2tHT0FnWTJrbDNuQUUyaDdwRDJGdS9qaCt6MVJwcTlh?=
 =?utf-8?B?RlNLc2g1eWlicnlJc3NhOEY2SkxMdFJNTTUxUFNHcVFRb2hLdlAraXR1Uk5T?=
 =?utf-8?B?SjVzOXFBWi9pQXU2SHZneTdmOU5GSldqYWtZV2JWRDhtaTBmTXU3ZWtFSXNU?=
 =?utf-8?B?cVQzVTNIS3o5a0lWZ05FSWYwT1JvRGNKbDd5ZzJpZkZxYW4xYkNVcjRYTzBt?=
 =?utf-8?B?QTRWR1IyR0VkZUpDcnNGSGdJVjVJT01WSEFMdjRPcXpNN1pxWnB1MTlSY1E3?=
 =?utf-8?B?R09NaDNpNEwyVDZyYUFKQUFqalhHaGNHY1ZzQWpzMXBJaE0rSnd5ZnIyNXRi?=
 =?utf-8?B?S3gzOXFXV2xoUHo2aDFvNWNvS2h3bHBvZFJaY05JT21yTXJJc0lBaVNZb2lu?=
 =?utf-8?B?a1NpQXh1YzBBNkt3WW56YnAvKzQrK1VsSVE5K0FUWlJlV3ZiTDhDaUNpbmVp?=
 =?utf-8?B?Wk52bElMenJvK0dXdFhjdGFZaU9BbTk0VzY1cHNSd04zKzViNlJMVUZ1cTNt?=
 =?utf-8?B?cFIzN3UvVG83V0dNZHVJMS9FOEJ4MlhCRzBBa0J1TEFhMHBzOW9xMGU1R3B4?=
 =?utf-8?B?MHMwVTMrdldJZ1VrUUUvMmkxekhOTUgxZm41eFVmUkdPaGp0REh6Y3Z5aEZM?=
 =?utf-8?B?VzdWcmhMTXhZTUhMNnY4TThqZlBpYU9rS0tEZ3ptbVBUc1NJRkw3d3h0Um9T?=
 =?utf-8?B?ZFlFaS9pVDM1TzZuWFpraDZhcWZ6Y1BqS1dFa0pmN2xFRWJ2K21Zek1wemls?=
 =?utf-8?B?RnZPWGtVYVZmbXhmTytiK1Q2czE4eXAva2FxUUczNm1JNnphOEcwWmJGUEtj?=
 =?utf-8?B?T3pBajlMV2dPZ0dLOU9tTmtHNXJPL0hBQ0gvQkQ0cWhGVGhWOXhhNW4vTWtr?=
 =?utf-8?B?UmN6bnkrUThKU09HNXNIdnNMM3NNZDMwK290SXJTU296REphdlVsd0JrYzZh?=
 =?utf-8?Q?wA1Q6DOyhn5fqnNN8rajUQ1WOhhsPu30LgNlB?=
X-Exchange-RoutingPolicyChecked:
	sAvjzCMyLIi1nKrCdCvqFJxGP2Zt0NA5PBmy5EwypWqMdKg/TfFsIudij/RdcM7S0TQYB/DcJS9TtdSQtQ7nN04fDVz7NOkUWxnTcPpXKEK69pl+yzLA/aZt1iLuA4gLJmcp/VGJQXsSyYrpIPDYvLrVYjgB6ekE4NoVwMJcVAT0BK5ZGaqDQZePhXzhxemRvdZ/6hp+BdRj7K8FRrfaEvLWnL28IR1JbolZweX2lUtWxbLI66c6d5Ghi1AWglBCOtq7Vs2OfihqglaSqgxcZrd5BDAZpxiCJ6pTIRvHcEkHhF8NfV8I3rlTvwz4XhQ7CJKhZIVcQf8vL0N5zmPdJQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QRGsXFeYM3BpXovoXVwUJ+vmnMbo45B8Ubr3z2v7/PMd63oWraYqldFTxx0+LXUQeURSZf5fWzTHeUe1pGSvqXKUfZNxRngkLAejmAstW/NfCPZmfIpiZPL23fojEBZObAQilF9RyAAbolyNDU7Db8F7ffFloJbqcdEu3tJOLI/6aWXNwDbMAS1yujfY6rnspV20ZpA7wk2+AOghlEC2F4xwbRCMPt5dyS7TKlHMpPMLAwKy6oKFV9TagXg01qT4Y5zJ1zP8KolPoBpItlh2jdlx+2bCoN4kOm+W+7z6z3iBLaKE3dWR+OPaDmrdypoEbE62B1qlqs4PEzcnSkIF0cK5pr9jYQhUgS3vr1aTkNiJkMApGXJ4MRBjMHt9IhouhwpgRjD62kw3La+NwU+MLcire+BXZMKi4Dc/kPMiLG6dMI13o5s5s0YjhpZZozJ6r6Kv5QkslSpEcfQNHyvfMew/0IfqvYCgc2bw8sAn85PenX6ZfGaRvg9iaX944oky244QkqvlCse+oQsDawhq9uATw4Wpad/CQhyqDruywYDTqs6V/0ZIjGoqId6UGGwRcZ7/WnnJd7tOpWEChvsoQZWT+CQF0R9DaDnb8eOTBy0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4881132-bd6a-4d0d-5068-08de97349345
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 19:08:39.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBQZ0PKecg2WACFf3zHz1B6jxEUXbcZVW6YXVml8Y2sG1gXJynJbcgTsGkqu4BIGPOKzI7BaD83dBIu/mkm4h1A4+3MG3cJox2GDNBpCWlGHlSyElsrvIuTC3pkAwbNA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4411
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_05,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604100179
X-Proofpoint-ORIG-GUID: zIqoSVZkB718bQEw5r97sIHZPEDzdQyz
X-Proofpoint-GUID: zIqoSVZkB718bQEw5r97sIHZPEDzdQyz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDE3OSBTYWx0ZWRfX39dAN0K5fizj
 RDfID59BNdG8HKzry2y54ZW0X/i3AFQEQJIfgpX0VdbOQiqwvgoRVF1hG9dJlC5VDDuL0cAQNVm
 rsdfamcbriw+jSQL914KK9D/SzPiLLj/0mvCmacTckxSCcNKkB+SSdWuoydSP0areDRS/Y6FTyo
 vm5R5SPWY73CWbnX62EuPvY0C3zzy8+7dVVQC6Y/Ox+BsZ6XDyBLcrSQm8HdnLZPT2R5o4kxdmp
 Rdoj+FKT648KQhBFR2iTR0I48kuvbOCvoibF2zGtQInTCkJ1kJxkIUbAL8pgvW1dm13xe5ZUHKk
 xhVfSFcI0zOhOHZtuQudj8kewGipQ97rrFFzdgpAu3Fvv8hepZsFMPLAzRPYH4vjzEbFq9Q633S
 dwYBGR1kLMHif7/f67YSntVDCl39YriTldHPfDjpfqrZtFAxB71oN7jm+ivKrTpLG/k/6eU7mWN
 ayhcwda6VEGi+Zcts3w==
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d94abb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=bilJ4RJGukIjJholIsQA:9
 a=QEXdDO2ut3YA:10

Hi,

On 08/04/26 23:34, Greg Kroah-Hartman wrote:
>   #include "resource.h"
> +#include "clk_mgr.h"
>   #include "include/irq_service_interface.h"
>   #include "virtual/virtual_stream_encoder.h"
>   #include "dce110/dce110_resource.h"
> @@ -843,10 +844,17 @@ static bool dce100_validate_bandwidth(
>   {
>   	int i;
>   	bool at_least_one_pipe = false;
> +	struct dc_stream_state *stream = NULL;
> +	const uint32_t max_pix_clk_khz = max(dc->clk_mgr->clks.max_supported_dispclk_khz, 400000);
>   
>   	for (i = 0; i < dc->res_pool->pipe_count; i++) {
> -		if (context->res_ctx.pipe_ctx[i].stream)
> +		stream = context->res_ctx.pipe_ctx[i].stream;
> +		if (stream) {
>   			at_least_one_pipe = true;
> +
> +			if (stream->timing.pix_clk_100hz >= max_pix_clk_khz * 10)
> +				return DC_FAIL_BANDWIDTH_VALIDATE;
> +		}
>   	}

This is a backport of commit: 118800b0797a ("drm/amd/display: Reject 
modes with too high pixel clock on DCE6-10").

The backport adds return DC_FAIL_BANDWIDTH_VALIDATE, in 
validate_bandwidth functions that return bool;

drivers/gpu/drm/amd/display/dc/inc/core_status.h: 
DC_FAIL_BANDWIDTH_VALIDATE = 13, /* BW and Watermark validation */

In this branch DC_FAIL_BANDWIDTH_VALIDATE is integer 13, which converts 
to true, so the reject path is inverted into success.

So I think we need to fix this. Thoughts ?

Maybe we need to revert this or backport commit: 4465dd0e41e8 
("drm/amd/display: Refactor SubVP cursor limiting logic") to stable branch.


Thanks,
Harshit


>   
>   	if (at_least_one_pipe) {
> --- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
> +++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
> @@ -32,6 +32,7 @@
>   #include "stream_encoder.h"
>   
>   #include "resource.h"
> +#include "clk_mgr.h"
>   #include "include/irq_service_interface.h"
>   #include "irq/dce80/irq_service_dce80.h"
>   #include "dce110/dce110_timing_generator.h"
> @@ -876,10 +877,17 @@ static bool dce80_validate_bandwidth(
>   {
>   	int i;
>   	bool at_least_one_pipe = false;
> +	struct dc_stream_state *stream = NULL;
> +	const uint32_t max_pix_clk_khz = max(dc->clk_mgr->clks.max_supported_dispclk_khz, 400000);
>   
>   	for (i = 0; i < dc->res_pool->pipe_count; i++) {
> -		if (context->res_ctx.pipe_ctx[i].stream)
> +		stream = context->res_ctx.pipe_ctx[i].stream;
> +		if (stream) {
>   			at_least_one_pipe = true;
> +
> +			if (stream->timing.pix_clk_100hz >= max_pix_clk_khz * 10)
> +				return DC_FAIL_BANDWIDTH_VALIDATE;
> +		}
>   	}
>   
>   	if (at_least_one_pipe) {

