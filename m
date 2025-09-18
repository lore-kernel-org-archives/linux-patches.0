Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF6734BA43
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 05:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758171878; cv=fail; b=lqhnVl03BuvdIQPVmWM3LBU6KHgAZekHjg/ELCQXto44cMoSkpsr0ZaAJ0HMtUUw2GjcXABG1jDloSFMguWm31MHLIMDOVzghcAPgy6JbuSraBKMAaYK4DlbGS2VM/zPifNohaAkCBr8yJE8wmN0iZmyFdJ741TjfehCqD7QHjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758171878; c=relaxed/simple;
	bh=3iHp9b3CZn8SEygs2O4Zr2OLyAp6Nu/R2JR9BaducP4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fBFvUjp2R96OlP2KIFQWUwUpfHJpccHuhWBBZm5WqvLWSR/3jwC8gOJ6J75niAIvR/UBJziNmnsPLdMJGHFxrLT8ms6v0HdN9quSdtl6FLurtYkOoBEh9v4vozZ0nhaVoTe1hSgA6kCUh9iPhec94lRCU5Wcn9oD11pUq8DjzbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sNkQXpMI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PCbfNx1g; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sNkQXpMI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PCbfNx1g"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HN0Z2D031339;
	Thu, 18 Sep 2025 05:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WjM3RHDXlDcx/D4QQO8prFZmr4cneGkGTHrxcUl4M90=; b=
	sNkQXpMIHo/x1X5/3NoxdtXLletP+4vFCRvSw2KiaaFKggeWovvFhQZW+nRqE9Sr
	4c0uWhXbKCdhFJRkzDzVt7+Lko3RjcZdPxsOXJIfq1KC8YNiSQIaaGq17MFq4DrS
	1gzulJMHXoD4CI5bLy6GglHB4cbtVTHICHzDz7TEjZww2Q2aR2N54WkRcLvscvzD
	/VztNpzczAMZ/0sWVgNXD+P1IjBGXUge/Z7boQgTrsro3jTINuI2wp1RhZlO5d1+
	b5ZADhYwO8RAWqIlve6Z+VsJ8yWsVCIlPITlMVlgRXRehv3xcaPUMUlk/8ilkAq5
	RSdi/nZZVYeTZMwmZTW8rQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxb2ntb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 05:04:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I3e3kZ027290;
	Thu, 18 Sep 2025 05:04:09 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011021.outbound.protection.outlook.com [52.101.52.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2mw934-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 05:04:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ucM0G1Pg9NMfzDh37mDXB4GEcC+Z61o9Khs5Pb/tQZIw+eMfuueVKqfAjt8yAmhQ/WWsMc0obK+E+paDXOYWaaDUkM6R+XK6I+hEMepGxQyHn1kH2+9NjfQ4swIJDf/GwOmzIKQGDwaJWOqB5C8q0HdZ9xq60ezwy2jcts3qztGfsyatc5hcmam1hp9v2ZkQwTL+FA7Yh5gXRUTid1z4RlhouF1SMPsJbyEFAYNzR4Har2A4n3B8O3O9SSF7g7/ZaLLC2FGeiq0EC6URMDd4Rk+FilyTO98pJxGpX4EXkOjVGuG7RVjmhevk0MjtPNleLOgoDHfbQFDmptt/dSns7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjM3RHDXlDcx/D4QQO8prFZmr4cneGkGTHrxcUl4M90=;
 b=uv7fG/StvMtMeFIjSDOYMSoWOZlsF57JTbh3ikTho9+oNyBVRDs/COWQmQwVjFrkPArQxuZnlTQj0psstIbO5+aFy0uU8ye2Xp6OZ7SIPbKKLHOzsp3dL1BkXMeKjxd695lEVKVKb02dXtMfoYU9ntpUr4pN7cY7ChOaywxI2bk/iAAeG6X/b+jGjqYTx/jeYSYppXHw45+wmm3P+T30b7MC2DftxnmGu0nKjDI7O4u07zgrfMxlduIQ6jkSw9lbwS5Rvwe71bFZx0jEBkAhsSPPRRIRBKIR60BFmfFwMsXUXpQFS0kfvhO7v+X4NNnegxGEVwHw6kVXd71POivHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjM3RHDXlDcx/D4QQO8prFZmr4cneGkGTHrxcUl4M90=;
 b=PCbfNx1geE1oU5G/hcWdWZvfmxNLxCiN1gqs3onHuyXEEZ1GJ3JicOHpDgVbAIZ4VpEE55nCuO8kZOjvpWYj9c9g/tMOrQGRFMJ1aYYvPjzWBOf/SEUhAIxdoCOealARz3MtAVosoTONXgucX5sC/XeakbKUIIJVL9ZZMYvettk=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by CY8PR10MB6444.namprd10.prod.outlook.com (2603:10b6:930:60::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Thu, 18 Sep
 2025 05:04:06 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9094.021; Thu, 18 Sep 2025
 05:04:06 +0000
Message-ID: <2567f387-ae90-40c6-971c-901f39ed55a8@oracle.com>
Date: Thu, 18 Sep 2025 10:33:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250917123344.315037637@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::19) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|CY8PR10MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db98860-3aa5-4cc4-6833-08ddf670cb37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWhRNzdpSW03NTNUMzVhVHZ0enU2VlFhZWMvaWM1NG1vUXFYSGZuUDF3OTZH?=
 =?utf-8?B?OGRGNkVrREk5VDJ3bEx6OW9nRXd1TWYxbjlDQmxKUUQvVWlQQ29GbTEvMFdk?=
 =?utf-8?B?azN0MFpQd0lYNTdwK1pkSzN3SjVYa3MxVHovbndETm1sdlFFSVhVaEg2dGpT?=
 =?utf-8?B?cGdsS0hmblZJYW5ESDRIK2ZqTlowZEI4VXFuWXpWczFBRnBpWFJrV2NTZnpI?=
 =?utf-8?B?Vnh2SVlFUGtwY1hYQ2p1NUlwc3FRZXlBdkNDc1M1RkZUTjhaUzFkUVZuSGsy?=
 =?utf-8?B?YnU1aW9wWmh4NXk3ZzhscmhKQXh5MlJkVjVXa0xrMENoQmN3NFlTOE5uclN5?=
 =?utf-8?B?WXE5NTJLSmJZZGpqTUF5a3JuSnJodS82YlNJTnlRYVprczVud3VkQ216RkJi?=
 =?utf-8?B?OVBadnh4SHFhclFRcmxzaXd0TDZNWk8zcHkwNGVOYzhzUXBkZnRsSVJCa1ZS?=
 =?utf-8?B?WkxCemZaRFFTYnd2dFl0bS83cHJoMmdicDVYcklURmtFeEMwY1B1a01DWDhJ?=
 =?utf-8?B?SVlaMnQrRmRKaDVDMHdTclFocFBIZVpzRG05eUtaVkxGOVc4SXN2MGhGWEp2?=
 =?utf-8?B?WU5LN1J3VkdWTmI5TVVxZTdrdU1DSElLWk5FZEhtMzBXM0UxOTBLWC84bUtO?=
 =?utf-8?B?bkZkZjlIWktJeU5mblUyMGVlcXl3cFRndjhSYXBHTzdMdmtuMmdVdG9NbW9J?=
 =?utf-8?B?OU02bTN2Q3FTdUZKdW1MRmZabEgrOVdvaCs5S3MrQmp0R1B2YmdxYmxVZ3k0?=
 =?utf-8?B?Z2YwcXdTem5Va1hwcnlWMlc1am9kVVhoNldiMzRrOFVoM21TeVVJTko4TmhM?=
 =?utf-8?B?a2xuMEcvSzdZUVllczY1Q2RoTDZ0MlE2KzdFdXNzVVRVVkh5SUVnNzJtRTg4?=
 =?utf-8?B?NkV4MzNQdDhSdkszMUFRNnN2b1ZkbHcxaXRJeUZtSWp3RHB0ZWs0dTBIbFhB?=
 =?utf-8?B?bmdGMG9IbmJRdVlxWWYra1NFTlIxSzRNUzlGZTBxVUIzVkhTSWlLenJ6TGM2?=
 =?utf-8?B?Zy9wSzNPTGVTNEY5Q0FaZ0tlaUxPUG5KSEpWZ295ZGdxZzQ4MU1lUWZkWnFM?=
 =?utf-8?B?VFl1a0Q5bHlIYS9xWkJHUnoyL0g2eXY3bmtCay9FcU1xME5LdmFXWm1SR1A2?=
 =?utf-8?B?dDJsSjBSb2tHZ0xuV2RLd2c4d0NPbU1QS3FVVCsxa2xXMElKM2l6VXg3N2g2?=
 =?utf-8?B?aEsrNThHU2c3alJUcHllMWN2R2xSWkhVa3MzSXBWUEoxamtOTWxaOXc0UTl2?=
 =?utf-8?B?c2tjd0lES1QxVVFydHJpOEthK21hL24xTkVkMFJjOGIwdWFxd2MzMkR2eDZL?=
 =?utf-8?B?OURLSFEzczVBNmVRcGNvbFFZZnJaTW5NQnZMT29mYnc3NEo2MVdzWmhZeUZP?=
 =?utf-8?B?cEhFaVhKbDNJK1JUUUwvY1MvcWo5dzRkMUdOczhwOWdpSzJIT1lSWjVlb0pQ?=
 =?utf-8?B?c3V6bkU2ZkEzbGV0RElVZnNiVnlQcG5INENRems1bGRTT05MSnFYdmE1R1Zj?=
 =?utf-8?B?SmF4cU9yL2FUSE9TT1FVakFZczcrVUducnZNcWk5ZXBRV1FhT2NBRXF4eHd1?=
 =?utf-8?B?M04wZko4d05WRjlUVlp1RDJObmRPNlAwc09qNHNKUCt6YkwxYjNCZitLeXBk?=
 =?utf-8?B?UHoyNEJ1bG9Dek9hUTBQVTFaVGVidk9IV2kyRWVFcU5YcHhHRm03blFNcEt5?=
 =?utf-8?B?MzZZdE8zNUF3Z3FUdkVoTlJMd2FkWDBKdExudjVXVFZTTmtkWm9GMGFaOWxX?=
 =?utf-8?B?UzZHeUtwMCtOU1JsWmYzZ3Rhamg5Znc1TzVuUk9UVDUvRkNkbmpCZW5iV2h4?=
 =?utf-8?B?V0hLdGc2L3RVWkMvY2NudEovamhFZVBVODF3Kzl6bmhSNXVGb2k4dTNHZCtn?=
 =?utf-8?B?ZGQyK2hBWjhWVTBzeWtITFowN2JtNEFnNWRrL1VjdkN4enpsZDNqcmMzMTBv?=
 =?utf-8?Q?i6qbEIAaT4E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czhFRWl5MDlDUElJNDk5Z0RaL0pCWlFxVUk5VE0wYk9aaU9WK1YycllFSFZt?=
 =?utf-8?B?cndtajczREFQWlhNVTMzbWVxOUMyVzU1QzJBTHJSZHI0a2p4Kzh6TEdWd1hw?=
 =?utf-8?B?d1BYUVFEaEdVdzlZeDBBRTlLSE5Balg5TEFNMkgySnVLN1FpVVZ0bUJYbmI1?=
 =?utf-8?B?L3pIejlnZHUrODBKSEF0YnhqRlpHTXI2aTMxYUJBN1F0WG03VG9sTlg2ZDFE?=
 =?utf-8?B?b1dZK1d3VjBJd3h5VkEveVhGS3ZWSytiWEpKY3VBQVBjcmJicklZK1BBQTNq?=
 =?utf-8?B?N3ZoUnZOaGxaM0hKQmtvR3p6RVd4QnMvTXBXYXhWbE02ajVGWklOaS9NZTIz?=
 =?utf-8?B?SlFodUQ5Vm9qUVBKekl2T3F4VlNVRElRMzZyYlpRaXVFYkdSV2Y5SWx0OVI5?=
 =?utf-8?B?TVlNN0ZXNWR3Ym9ERlErck1rUzZRMGlTVmZZM2dpN1BpN0VueXRQaGUwVkFE?=
 =?utf-8?B?alN5RjNmbHpiN1g4S1BJYWFEMDgyN3ZyREt5aGYzVFBWMTBRRnBvek5meTQ2?=
 =?utf-8?B?WFZDZDVMaWR3eWF2ckh2SlRYVzBDRWRzQ2F6WmFtbGhHc3AzbWxNS2s0Z0FT?=
 =?utf-8?B?T3RVdDFMOFlTUU1RQXJZWGpSc0RkMFd1WkZYN29QemVDU3FKVGhOSXpSNDdn?=
 =?utf-8?B?TXF4YUZ4ODh2WG9jRHo4eTUxUzVCRmMvYlZRMFVROGFnTFp3d0RESS81YWxy?=
 =?utf-8?B?ZE9WMVNYT29yWTNmRE9QN01GcVVMc2p0Y0NwcWFUWEtKWFJYZldDT2p3c2JT?=
 =?utf-8?B?OXB5Q2lsR0pxcWRoTkxtWjFJT1V1azBSeFRrTVo3UlAvTHhyMkozZkt0cEFE?=
 =?utf-8?B?eE5rSW1Ld0pPMmtobytSVDNtY3JqVnNSNE5Sc1YrWTIxZWpsTDZiSktZVU4w?=
 =?utf-8?B?MVNjZWppMFZoSHpDamxhNjdiTG5OeXZqMUg4MkZoZUU4VEx1aXBkanhYSXJj?=
 =?utf-8?B?MEdWeHdibmpXT3k2ZUNGdDJoWGFaY213T2hLZS9Vc1A4anpNb3pLQitCSzJV?=
 =?utf-8?B?V2xmOFd6aFFaZjI4M2tOVU9nSEZMTkZqdXBmUnJZc1M2QTBjMXpoeSsxU0ZP?=
 =?utf-8?B?MFFYbzVHeGZkelE4am9xOUxLdVMyTllwaFRFbkUrYjJvM0lybk5MR0ZCaVBw?=
 =?utf-8?B?OWVzaWJONEE1OGVVc1FCWGdaRlFzS3lUeUIraE13Q3ZZZHpyRFV4bHJlV3JP?=
 =?utf-8?B?WWk4OWt3Ykl3SDJqeVFWdU44Sko2WHljRXNOZzRYRSswdDFxUDI1Qk1RTThi?=
 =?utf-8?B?WndXUCtiYVdZODNiK0RuYWhnWTdjNE1GOVJNQm15ZzNJZ3BNeXM4MzRuRCtV?=
 =?utf-8?B?ZVV6V0hiNTlFOEE3TUFYWlVWRjAzSk5EWVdGUUdFK3ZtR2FSMVN0T2sydlov?=
 =?utf-8?B?OXhkNDI3bm1LMS8wN1dGUGpoejM4WGFFaHJzbm1QVXNydVAvcGJ2bGU4d2JS?=
 =?utf-8?B?WVo2alRDMk9UNjQ0V0NOU2F1bEZ6L2crSjNZR2Nva28xZW4vZDBzN2xGYTd0?=
 =?utf-8?B?WkpUYXJuUGtVbmJmRVI1SC9ZZnN4U3diQjFqbENMZU5JSk4zam0xK1BhbTdy?=
 =?utf-8?B?N1NNcUMrL2dOejFuSzY4bzFSZ3libmJ4RWFicFhWMkFIQzdDbm12cFdxZXlp?=
 =?utf-8?B?c01jTUxsSUZXd1lZR3JPemdIVHpFNC8wS0NSK3pxUjRzdjhjM1gxc3o3S0lh?=
 =?utf-8?B?MWlSdktCUDJwdFVZQ1MzbEE3bUVOM29yRDkyRGtid2ZZL2Zuck5qZ0ZkRVJ6?=
 =?utf-8?B?eGxodzd5cEh1ak9aTU1QT1hpcHdXTmgxRjVHSTR4TlFIR0YrZjNWMXFTMDZS?=
 =?utf-8?B?QXdwT2JFby9pcnNwcnMxM0RJZGNaYTVIM0psQ3B4T3ZCZ3k1eGxBTW90czhC?=
 =?utf-8?B?VGNYcWJXV012cXJqYTl2K1Z0VnRqK1d0a0huT0w0Rm4wcUxpNzZxa2ErbXpk?=
 =?utf-8?B?UERzRkc0SEptNnZsSmxiSVdTYkl2V1RJeS94cFluZzRMRGxUNnRZTGEwdmxG?=
 =?utf-8?B?dm5HU0hIUTJSdTFTNGhLWjY1VWFVdkVyWHoxU0ZOKzQ0ZGYzRHNDU3k3Z3g0?=
 =?utf-8?B?Y3VINFlodXZ1cmlRcXFKeGFBYmY1U2NTTnVTVGdVNGQ2Uy9PZjkzQjJNbE5s?=
 =?utf-8?B?aFZ6TW9MMkN0aGpWS3BiUllVWkR1ZWRVZEFCUEV3UW4wTmZoOWFRLzRDSVQz?=
 =?utf-8?Q?pToEsyfEE4qLrOswfWgJ70Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xSYdbCeYPggY3Vyiz674euXh/HmU9gwYrazFqaEzhEJ/pcFuR2YLlSKG2CftGDMoCuZbzkuUXOJFGOEX9ny575sU9IR3zT/H2YjMXo+WyOUlLvEajXnIQShGuRbhqEpO0JgLi15YWaOpq4przpjB7dexFrlK5YKFAaODjeNCmYI/VOGZNkRZP9ca6H5cLTINCvWG5uUoxTgw1B/zBgZBOolhawEfMLBdFxGD8bB1NmfDzpD7ije662WsTAudFBdIQhWgj7T+Nt7f6J2ewRv87jKNQuWYJIOwgVVfJrA+w1brRHbvTgi5pgnlOdGUV7232GjxoDQVVtfIaqI/kCD99znpTzCvBQ678eY+OFtj8Q71EwsGNCzHH+wOqsgL4Itf2g7K53SWp8K4Xpr9F4AVQ0jIUdOWNWglh+zpWmO3+chuK4a6IGhpqoFhw80wBONsaDTyABTFLerEaRbUr469RnnAQ/PXd/lEGEO1TLCwHUGnrTV1JjwDn4gQCUaC1kBexGY+8y2YL34PFcQmd/G7FyskRZ50THVTGbep0k8rN5OTynk0iZb1tqC4TIrO7lWbRjcutpPlBKkHMdkWhoR0nsjC2PNsCKxpqtHSGT+Xi6o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db98860-3aa5-4cc4-6833-08ddf670cb37
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:04:06.4734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GF4xjTC3uxmLH/2fvFy6Zgt8z9Te91P+G75nvs00x0MlJ2/XN9dNjwsehlKtbgyMOUF/kRkAm9Hn81t/IP0+xbuVVvN6e6Vo4vClNlRFyS6NVIagqKze4YBsTvz/IV1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6444
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180043
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX0ASYsf2h73Yk
 6HapUxACvoyFNY6BOCfs1snY1jb27OPK0TuVmRwJK9PCaIV7pvxdmSFTnQODfpVp0BcrCVhNvyi
 9znEZLZIcJAkKEmFi++VaHRP8kwKouP8FehPOAU3OjW7JwMYTEw9Brz0CJk1MZTg4c44JLmX3aR
 4+5vNF66SF7cyr3tgEQHpZgdVl75Gxj0QzmakSeIFWjKA1IO/sL2xNOYRTL1yxjtL67MVa7g1uQ
 mXMhxLeIkYifhzEC7DTrLCSrvwvoXJ5Ja5cJFmWtr4jIsNGfmX9Jso3TmbEHBVP53ETW6Sy3/pk
 qDhcqV3HnKt9EyiZnCHXJsdXmeo2Ign7WNr1gWCOliHv8DDT/ucKnYO3KSsUlhie7aoxiq5br2h
 CRlEKGMz61H4/Gi+7G9GM4NEMJxULg==
X-Authority-Analysis: v=2.4 cv=KOJaDEFo c=1 sm=1 tr=0 ts=68cb92ca b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=XDS-kLxR2u40u3t6JfEA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-GUID: ZPjbGnVKry3NroysaK6K0YbIWTN3ctI7
X-Proofpoint-ORIG-GUID: ZPjbGnVKry3NroysaK6K0YbIWTN3ctI7

Hi Greg,

On 17/09/25 18:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
