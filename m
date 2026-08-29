Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5120A5C4;
	Sat, 29 Aug 2026 21:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788039085; cv=fail; b=ba9EQpLjZcuuXTkzA7yJL+YxTNSBirNaPP6wCErA9mTUaP7XzNfVMzYNI4vEGs53dKtSBh6qCmBOaicFBfXpAC4HpFP7JyU+9DwApcIe/xIFZ/AT6+CeZo8zn7P8LwYABAQ8dReHxbAcmTAXt+H3bube3Xa/3+VWlrucm4rwX+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788039085; c=relaxed/simple;
	bh=sr3GXi0YLseqq5bbfASSS0iQJz2dGI2I6QipAuqO+DM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TBppZNNCU7VyAx2Bb0GRP1IlQrQmLkLYCnwL3+viIFbP1BHyVQuECax+aLLDiQzcLM48/l2eKnPsw0IvAAv7jE1DVL4lkswZFlmjTtpja8wunrAOSTTSYlLMdxOT65s7JVfs3eaijzcxtYQJjz68eTZszA0LCz0TB2SyxdZQtr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ci6PiFy7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YtUSGKkZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ci6PiFy7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YtUSGKkZ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TLMQS73051308;
	Sat, 29 Aug 2026 21:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NpsIZ9xiocKSnz0c+06zXz3kIJpz4qoeQkTvwYJZjSk=; b=
	ci6PiFy72p78y0fvydJea7lfygOB4NvGI2qbC1ptVBehEMk2T97ycQidh7Bc+lE0
	r1nfF6mrtFvZRbFToxlKRJ1SAKcmhA8f0OQmPC9ZHYCRji4h4WttN4HRGTVBngP6
	5XCQNSVU72IuzbwvP3hX5nY5nXMFQLfArwc07kgbilY8abqxOnXlWJWlAEmdP3nE
	9+hby2aYOJfYAYoJ7mNCxUbCT14MJLfHaBHje13DCZeE8HxBDinZeslX9lejI40O
	xLPZiaPY1tB9QnhzKMXtB3ZFXw4l/4VfSYyHw78jsOXep1xBo0WnGHOfaR8idZFN
	khFQzuhK0b6OvktMMhZ+yA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqfc0mg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 21:31:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TLKbRV008267;
	Sat, 29 Aug 2026 21:31:17 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011014.outbound.protection.outlook.com [52.101.52.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvmy1d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 21:31:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9pW4ZXSjuDQMwB+2AqhS1xTsBE1DtNzt7SM7roO5lli0lGrZHIHRVLbZ/NPXkHIcTFAia9uMkyV4WGnncp9MH8iIU43NU/+lDi/xWfX0PQ1UayNtarLzxniRB4mo3gdsoodsKfBFnXwL5VjcLcnqRl0vgqf/ZQwUoHsxSJyIuVjPcY0/MYo3PwYps8gIK7LKGWJkdsLmZwe7InJp3wCORpgW+qf9PktROFyOm2XANM8jX5vAZR+whDtqb9mkUdd3Elklt3nu5PJncYJLgmKKaExIx15kDdefK06iKUD33hBKB0FrsaS2H/S4Qf9x5+eRSKHF7R37GbyZb6jbSgG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpsIZ9xiocKSnz0c+06zXz3kIJpz4qoeQkTvwYJZjSk=;
 b=UPhdZh4/SwQGRc6Yano7KCVe60KfVXUB9rTbY9XKmjy+1jEeJxqZ3Homp/97WiqZCu7DZCcvefyiODIGZXO4R13bP9k1G0GcXciZL0uw9HQ/CWpbH0BoUhTHryRHgdljOQDkq0Qg/4iXP+lIB9wVifhGbzw3Fu5Myc4OBAuE0fE/SCNmYWygqM6tx0QujnHWGLcdha+19IuXFHKbvf1cbcnbn1qfFAdxUBwILUXmzN47WnFgK1W8FSQAf2mbWgYhM2hVHkzGQ18c+tRjTw030EWBZzgi7AA/rVw0tT7RO/qqOVSN+v4Fty/+U8bpbbknLI8VkEb6LCYQ0x3JQVlfOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpsIZ9xiocKSnz0c+06zXz3kIJpz4qoeQkTvwYJZjSk=;
 b=YtUSGKkZaMszFLkEUW21sL3oIagVDNjs69Ea1vEBlT5QFkh8QTEpavHeed4G0Q0b6leFcWq9n21ZHGZvJAEQf+VyT4RYZgNtBsjUVP7oJSvjiz4ZcfzZTPLlNbg8BFoKUU35sNflq32qC/WQcmSEhruGH1CDlRXOB+/9mGhcnhM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB7002.namprd10.prod.outlook.com (2603:10b6:806:344::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 21:31:14 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 21:31:14 +0000
Message-ID: <f3b734d9-d286-42d6-b332-e4889e7bcde3@oracle.com>
Date: Sun, 30 Aug 2026 03:01:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks
 and list corruption bugs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Cc: patches@lists.linux.dev, Tze Yee Ng <tze.yee.ng@altera.com>,
        Dinh Nguyen <dinguyen@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260817132539.792407575@linuxfoundation.org>
 <20260817132553.741510506@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132553.741510506@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::12) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: 0897c9d3-c319-4c7e-6a85-08df0614da54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|4143699003|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FeKoTr+silZ5eaInL/FvU0gJhmbtwoqfAjQzOsaifwnqhSXdOSMuRDcxjiVKUO59ijshIpJshBmB9cpNI872yZaoS+6ua+7t1P/jYHrb/6Y7fxHkF0T9IZ5VrszoZgp5vgwRThPoj1XFS1K44H1mxX1l++LYQhWvGhj6AclCe2ceiVdmdBQiVtSJPGv0aj5FI9eDJ2MmErVGIPeK3xfa0VvKOSH4iXRH6y9zDPHeR18GQF/pmzdUeeNoP3SgRGGNS4MHrvB8yxi74pMe5lxITK/+wxjckvkTzo6jQWtIAntGosEgH3L49iMCtr6Zit5HAXrFQ1u0uKdxIKb2AR2fTuxSjqOk4emthtiGHc2TD7+KuNzRkP3odimgDN7IraENFehNjMGX0dW6trpEUJh8ffWlrqVfKfcvBVh1TxWuAQS3dDswuQMp1Kq+srWx1IPdB2/GbFX4/VMy3H9SFfWT5MElPRZEn7PXx8/hIML9ET2OH1XU6Pnh/n6hTBRQJ3QmQJk8lyR85VsAqEGY8bgtlhQXPC7fKKgdG2ufLorlyRbBcB9MzwaHw6RBMLlYLsHxchJkhovO885Coop8+zLMNo/V7njWR4x6k/k1P6WgUBJo9iRoxWxVbnK8cRmPKzoxWTUWTsFistkx40o2F7koTW0X+ZIXlttzllAjBYNJbxU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(4143699003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWFKRFZ2WVJqVnhFRUdVZkxXdVBHcmQ3TFJFY0VBMHdyTU1OUUFURkRWaGJR?=
 =?utf-8?B?TTBwSHRtaW9BMEx3OG12NzFoRlVnZEg1dnRIUVkyWk1ndmt6SkhDYVVMWnR0?=
 =?utf-8?B?SVBoTGlubTZWczFsYnJFNGp4Y2lmb0N5SnpQOUpTOTR6aW1kQlFmQ2YzS1Vm?=
 =?utf-8?B?UisvMThmTlBTT2JwL1J0VkJvMGhpVEtKOGV1QXZMbkVUbUNBeUFRUU16UmU3?=
 =?utf-8?B?cytObmxpRmlUZ2lSU2Y0dkM2ajRVUHBmNzBjWG9pK0JweXZXQkhxM1BnTC8w?=
 =?utf-8?B?VkhZVDU3Y0Z6aTZrUXpVNkwraGZIdVJFOUdLL0RNZ0hZb3d4MDI0K0h3TllC?=
 =?utf-8?B?Y2dINWNwQ2hEc2c0MUszdUN6ZWNBaGdVVTVuT09uMGx1QWlieVF2YldERmty?=
 =?utf-8?B?bHQ5SUNnTkRmWi9kNTR4NWlZU25sWFF2ZzNmdlRiSDlTUnVDeVQ0SXVQNXlo?=
 =?utf-8?B?RSsxVzB1cm11OERqQ2hWejd4bWwyK2JzSS9HQXVmemJsSkFPaEZlaFo0NjZm?=
 =?utf-8?B?V2Z0TzVYcVhpdnl4Z3BQNC9HdStTenFGOGFyRG1KVFIxMXdpc0RWeFhNNUxP?=
 =?utf-8?B?L2l5M0dsZlJvM0xIYTYwQTBpL3RxcjdhV00wTzd4VjJEdkUyT0RxcHZ3WW1K?=
 =?utf-8?B?K2RwR3p5QUMvWWhlaHMzeHVUMzJiOFk1OUQxc0xCSHNBTGZWQW54Rmh0dkdp?=
 =?utf-8?B?MXhJbUtocXFYUjFnSXBPUkFHaW44UE94WHp2L0VuelcvSXVQS0d4ZEdnRllk?=
 =?utf-8?B?a0dNeHV5SzIzWGNvaDRvMk1RSHlwOFhjUmxmdFY1RndGOUNFNWxpZUFmbTJa?=
 =?utf-8?B?QmZYZ1d2eHhpUzgycFJjbVpDOTdnUHNTTTd0eHV5SldtR21adTBwRmJWMDg5?=
 =?utf-8?B?RENsd1J1NkdhSmN1aVVDQVkway9DOVpac055eUNSOWo3RlFjYXFrUUgwcU9B?=
 =?utf-8?B?Z2ZQUkVNd0JBa0g0bjhzbmo0SmJGOERJWWMzeWJIK2tpUGJsNzRscHZxM01i?=
 =?utf-8?B?bXNmcnNCWGxFVjQrWVFIUXc2T2poaUIwdG9icmlxQlIrcmZmQ24vY3dZTXMr?=
 =?utf-8?B?SEgvM2o1bXdIMjBmSlNaQUV5U0pIMTNtOFFzTjcrWFVMdEhkMmtCTnhrQnhp?=
 =?utf-8?B?U0hSZGgzZnIxcUkyK25sRGYyQmRLUVcxZUl3L3NFM3B0cGdhcC9wVExCa2Nu?=
 =?utf-8?B?VURERzRIUGlYSk9xR3dzNWhDT0o3NlFyejcyQXRnVU91Rk9VRWR1Slh5Rklt?=
 =?utf-8?B?WU9wVUVxdlNQS1hiZzhPdjZvanJJa2ZpaEp4ZFh4SEJSQWVDN1g3aWx4ZWZr?=
 =?utf-8?B?SkV6Q2dMY1ExSXl6a28ySjlzYjhlcDBpMFRYT2NRUGNWcFRoUkd2VVRReTlq?=
 =?utf-8?B?OU5KVldhYVlla2dqZ3NnSTBKMUYrQWEyTnhlbk5PMVliUEtRV2NaOGpFNlZz?=
 =?utf-8?B?cnNETGV2ekxOK0VhWkZBTUJBcUpqTVVsc05Vd3A2Wk9VYlQ2Y2lXd3l1alBz?=
 =?utf-8?B?aHNhbHVTd2xuWStiRzJXcnlUZkNraVJFaCszK0FvUHdJVmx2bzFyZnBGNjBZ?=
 =?utf-8?B?UE0zWGZXZ0VYOXcveUVwYlFMZHpDQWZEa2JsenhhTE5MNE5qaUVtMnVrRDNI?=
 =?utf-8?B?bTFlUEQxbE5RRWFXQmUydFlGYmx3SkI3aGUyK1p4Y2U5Q0EvVEUybjZEVEJy?=
 =?utf-8?B?TEp1T012VitrSlp3VCtCZGdPenVKTy9ZVXpyUjM3L1E1cUJldXF2eUdjV0V4?=
 =?utf-8?B?K2NrbXBCcVIxbDVGbVpFUmtRYlExcTRjc2lNRmg2Z1o0RVRMVEk2YjhrTm5H?=
 =?utf-8?B?eUdZY0xrenRPWWg5Z08xbnA2SUJPa3JjakErUGJBUkZnVU1CbkIxSS94bktk?=
 =?utf-8?B?UFlaVGlPNW1GOVV4emRvYW1nbzVTWkhvVDJQYVZCdkd5TXlDTDRsQm1MTThZ?=
 =?utf-8?B?dFhhS1hSTitnTjNnYSt0NDdWM08rN205WWtVWHVWTXBKNE1PSlhIdEtBWUNO?=
 =?utf-8?B?TnVlMGFqcHJvVlBhMGFtRGlRVFkvdWVBUkhGR0hXZlpCbnFabGtBTVAvdkZF?=
 =?utf-8?B?RzR2ZlIveGpFR1ZOWE9zRXpwZmQzS2ZiMWprWGtQTTk1SkRkSUNhTFJ6dE9n?=
 =?utf-8?B?MnZLbnVMenVydDFlNXlvOWxlYnp4dHZEVDQ3eHhpVWo4VkpudkcyMGV3ZHE1?=
 =?utf-8?B?VkdPa0o4ZXVVd2x5b0NCanBMb3RCRmdZYVl1Q2tiS0hiNkJUbGllQjNrdUhs?=
 =?utf-8?B?TXRITUx1NjBDdTMwQTFoOW9XRitxS2VvVHROYk1FRGZlMS94MURwWFhPN2x2?=
 =?utf-8?B?YTd0TGhrbXlyZk9ydVRaWTBWMVhPM2htK2tQWTZic0N6RDZFd2NCcnJwdnl2?=
 =?utf-8?Q?hBGfh3kmZlsLpNBVgiEgfLiCSpLDMspQwwblU?=
X-Exchange-RoutingPolicyChecked:
	SXJFLUbHATPQ97cX+nnrHE0mPNPujMGOnth+TXzH9RFo1I9HYfesOW7XucH+Mt45zTsmq1cz56e71GA8O64mqycR4Fi0Zguu0ciWEBTfwbLDOb3RajSx22QAwz4931h/jTlEiWVoFXvk5PWaiBCn6rZtDAmJrPoBJo3vICbkKrbTdCbe6YzZ6WnAAyyw5rYQH/xFNjLqp6/cNNbuF11ng6hXYeCCQr7JKlZ1ivbZ35CRpDcxsq1SNBH/TNq/u6NdG9vGZEMpYTdmksg3RwvtMgwiXulYVC1AEggbEeTUXdyLZq/xeKxq5i4q1HUGNcYX1vaRm0WCf18BvSbAdXNseQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BhLsaLxQ/cFPTrbdX3QI+URgNiG1XCxMW36pnFEyCBNDlAeuKj4g8NCXj3/yxGWNVTN5ldr7Plfw0XnHwelJjElGgrK1ea+qLKJXyDd4ZTH5jkifmyZAIQe3zNGIG3+6GmfM4cX+9cwDtVdm+V6Q+rsGdy23VWm/tnoj+uq2CQ3ukEiYi6hp36zrTDuxeulgeqm/vlo6Qgj2zYakQEIwthK05y0k4lRGN2ZG8uOjZMBFJEvxSMbPyxWLB/GnoaEWqzOTo3eFW9DD5M1SmxTzS3Ufax6COanJGo28KSvF9sdh1qcZV0X2ifa3cRLl9rolV3Nq2IkmuLjxXyHk869mTVlp+9L7a7j17yLzc5iGZ811xi1J4B0ZoJNNNv3oNiUR47UU1Uqn1xlanQB8uzkFAjNNt9AuQIiea5l8If2SQTxsaGDVxhLTepQE0V06C0Jba8K0Fen5BWezVdNy9S5PD2cqngwhnFurNXUK4pUsbg5bmI1F9Gbsevjuah3dwPwVfbnHipgcBjAU9xNR1yaMRpCq54EJdQj7bhEDbmw68WuhrYq/Rsi6amKj573Yc6EYG9rXdtwF3B5Nzqvb+JVvXUVBjmgZEWGOJLypr9hlCyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0897c9d3-c319-4c7e-6a85-08df0614da54
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 21:31:14.3061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/EupjzNa4Bjfm2DemLlxuDGOjFGRTOoxRji5lA+PjA6XjAL08YZMqqquFTgqBgz6rFHwuAeB+ZP2pbqbzXyYYkiFA3tOJhHyERQ9jo9ASqxL7Va6NO3tXNUt8FQWJbB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7002
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290185
X-Proofpoint-GUID: IA_XH63dpDlwLpVKTXTRcwrSSu_j5B4a
X-Proofpoint-ORIG-GUID: IA_XH63dpDlwLpVKTXTRcwrSSu_j5B4a
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4NiBTYWx0ZWRfX0nBuzFmTB6Vc
 0J2y+Epni5xFmJP5AAa1rALi8HljaN+4LFOLz8faHJmZkmrx8/osginbuFsAK9CSquoSdhMvY2Z
 ay7vmlXvIRJKWnxHFZpW63rcxrn2ly4jP/Zzvh7t1YX1WCvAHQR3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4NiBTYWx0ZWRfX4F9veqhp+ZD4
 VFS9QwxaGphflsEEtU0wEdz0oR3xOXZ+RHDe7ZOmTpD46NhkHAxBI2+pjSISglTjwEiSiSSZF5U
 jveZirMcT959rLoq0xUD7YxwwS1mdZ6AkODIWP1s4JyFbAGM83HP5rAS6SowYpRI1ZfzTVOxRVu
 zS5jfNobzX2NAerJocq8VSYRN+dABoaN78Fl5FSyJYfNxuckcvgaj3nl5pJFpvWt7WO+Kgv1Dt7
 FGEy2blBNy4gSS/5vyUg8/dYWau2dQeesJlSZIEZ4yLpJhWeu01btCs79onuOGJiohzwjEJb3le
 BDgroD2BE8vYMadcNPXg0hkx5wo7GYbTV9p0sh3sCEEA2cHqjqEJXvAuFBTH9GAWkZyWRkVZobf
 T8jWHo7Gs8guQUyeDUtGifQ6GCmk9iyND1kH0etIWgqXC4K2S7VgXfL0/Ie/npQAGm3Z/wh5qMN
 z73aQi+9tU9Dc2g2mgIV+uz/qlIZT0gyee2dvScE=
X-Authority-Analysis: v=2.4 cv=a9gAM0SF c=1 sm=1 tr=0 ts=6a934fa5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=yBYpec10AAAA:8
 a=VwQbUJbxAAAA:8 a=8vuiiswYjOG4ISHVQ9MA:9 a=QEXdDO2ut3YA:10
 a=zbxmTX4fiVD2UiCe4Dha:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12102



On 17/08/26 7:02 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tze Yee Ng <tze.yee.ng@altera.com>
> 
> [ Upstream commit 9119ceb76e987c2ec2b549ea100e3268ce3a1c7c ]
> 
> Fix a memory leak when gen_pool_alloc() fails by freeing pmem on the error
> path. Switch pmem allocation from devm_kzalloc() to kzalloc() with
> explicit kfree() in the free path to match its list-managed lifetime.
> Remove the erroneous list_del(&svc_data_mem) which corrupted the list head
> on failed lookups.
> 


Hi Greg/Sasha,

I ran an AI-assisted backport review of b9206568e084 and checked the
finding against the 5.15 Stratix10 service layer. The direct leak fixes
are present, but their required list serialization is missing.

Before upstream 9119ceb76e98, commit
85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ("firmware: stratix10-svc: Add
mutex in stratix10 memory management") added a shared mutex around all
four svc_data_mem access paths:

         static DEFINE_MUTEX(svc_mem_lock);
         ...
         guard(mutex)(&svc_mem_lock);
         list_for_each_entry(..., &svc_data_mem, node)

The 5.15 backport now removes and frees an entry with:

         list_del(&pmem->node);
         kfree(pmem);

but svc_pa_to_va() and stratix10_svc_send() still traverse svc_data_mem
without any common lock. A traversal can therefore race with removal
and kfree(pmem), producing list corruption or a use-after-free of the
list metadata.

I think 5.15.y should take an explicit mutex_lock()/mutex_unlock()
adaptation of 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b now that we 
already have this merged. THoughts ?

thanks,
Harshit



> Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
> Cc: stable@vger.kernel.org#5.0+
> Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> (cherry picked from commit 9119ceb76e987c2ec2b549ea100e3268ce3a1c7c)
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/firmware/stratix10-svc.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
> index 993ef210169c0..c5ddd20fe4b75 100644
> --- a/drivers/firmware/stratix10-svc.c
> +++ b/drivers/firmware/stratix10-svc.c
> @@ -911,13 +911,15 @@ void *stratix10_svc_allocate_memory(struct stratix10_svc_chan *chan,
>   	struct gen_pool *genpool = chan->ctrl->genpool;
>   	size_t s = roundup(size, 1 << genpool->min_alloc_order);
>   
> -	pmem = devm_kzalloc(chan->ctrl->dev, sizeof(*pmem), GFP_KERNEL);
> +	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
>   	if (!pmem)
>   		return ERR_PTR(-ENOMEM);
>   
>   	va = gen_pool_alloc(genpool, s);
> -	if (!va)
> +	if (!va) {
> +		kfree(pmem);
>   		return ERR_PTR(-ENOMEM);
> +	}
>   
>   	memset((void *)va, 0, s);
>   	pa = gen_pool_virt_to_phys(genpool, va);
> @@ -950,10 +952,9 @@ void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
>   				       (unsigned long)kaddr, pmem->size);
>   			pmem->vaddr = NULL;
>   			list_del(&pmem->node);
> +			kfree(pmem);
>   			return;
>   		}
> -
> -	list_del(&svc_data_mem);
>   }
>   EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
>   

