Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598F5463B63
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544478; cv=fail; b=TizTqLg+2fRkRARq6eC+fh3uxK4135AFqdSfNaSLig8AuKnEdHF6tTw5+HDwRVwq4IeSdonwltGpSfeWEzRYA6ZDnLAXNpktrWZozd3q9ycN/9bwu3fhtHkxWbbLLmVpQ/ifEouYXWqs5nlh3K5vg3BdVCoOL+RtP4ifxp7PoAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544478; c=relaxed/simple;
	bh=sDfgCp/Jml+I5n3WUOVzXDMxtLUatY1axIYDKZkgB8o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iF4/4X8Y9JuHcL9ojVenyj46soLo9cUj+HflI3gcOIRxS6yj/zIZqeQDaYqxGFl0mbHvrRbOs+tY56BrpWRqxDKKF2CZ0qAYFWO19mzD8HL3fzNPcTr1luYTLqEqqyoFmCIagww3n8fjJy4a2vs4g0FPhHBTeGON79uDgrATyv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b2br4vlh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I/92lynO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b2br4vlh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I/92lynO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLX0m7698974;
	Wed, 16 Sep 2026 07:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+cAHQHAETxnL+9f0gS67wLlcS4SjNbBcEqxlbpnr2XM=; b=
	b2br4vlhWC/Ydyyo7P8IbDgI2yb0usPiDbsE+QIWWbdJDFznyOClLtR0S7k8Bmon
	cObXj9IrLCGOa2JjIhgTNrCaSs973BM4xw5tgh+q+6jhy0xkVcMZ5yJWRa37whL0
	ZBWOHoWvo9C0BJAJX8u6Z/TAz1bXsG2WZDq3BeWDQhFY0BZBUcKp3ody+beAp2E0
	s8k0J/8etHMUwUH8nX+JR/IUgdQWQbZ81HXpXNYgWPtDRgckVgTLbzrMIlaSd79K
	hfQKk/tbTpyO7tVXF2ogHhm6SjiSxoLFHywqNDcBZ6N8PrptF8FC0Kd7aLMB6tlV
	xV6w1jxK/7aHUmJ8n66uBg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7d35g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:41:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7eMAV030895;
	Wed, 16 Sep 2026 07:41:06 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q1vgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:41:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=atg47IenvZ6C6Bf4+wAUfKHsTyXYd6gYkfeMQh8+Sbwb1ud87K++3/uNhQ+qacV+YgpED9lDUFnBriBx15bAGHyFDANmT8R1oCsQ4XNmoXyElbTxT+l7lcwo5RAyAxscvBGXD78f9FBBs4UCik7kVPxCwJLEMPEYOVE/VGR26EZ8HW6nbjP9mu+5Ienfl3j1bXUoZYd1WDnTJSJ4kP1CyBxTQdthYid2ipGPwe0ax9vY73y1ErS8nakjmtvHfvcUveGun+YERZtzYYBQ+obAZ+rwsnvgXJKq2TT9VtP/5m9+0LbdkDu7YuiwhCzl+FrpCP/mWcae5/6XxV5CSHppiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cAHQHAETxnL+9f0gS67wLlcS4SjNbBcEqxlbpnr2XM=;
 b=y6wxqZ6X1pWS2kcLR4Pq46t593mFhRD4taRm91VJ/ACsQ9zjb/rm8KnfDdqynI41qAlLRPqeMcDUEdqrykVsGObPAb6kMMujE5v68nmR1jzi91meoaaCCfKmO65Bq3DqESAy66nKiTX4QZkO46Be4R32oj3jtAxQvxgJ/fBNtYvtGZgMcX64/c+lEOJx4J0mnLD1C9jq9rYqDVs1OT3iZzrslDtZJXnwswDuIxTuifvoK9wtZ05LKNqiI5a9YZ3EFY7FQb9bRYiNCSgc0JmNtzhiS0Vjz9I/++n2cZWvr+GLNgl4kwHFhnQbGG32jpdtPm19xLM117pmmKEPBr+RPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cAHQHAETxnL+9f0gS67wLlcS4SjNbBcEqxlbpnr2XM=;
 b=I/92lynO3K2+lcmldKDouabgoD8Q9j7NsrEKRpm5s/2aIMvKMbjV4Hkw5AT7YXU+nVg5OJf8Syo2mI5b4y9ENEDGPoQKxRf9dZeH1kS6ZgEsz6ZsHpScqqGA103M9CmMtd/5i7tY8Ol/onvsZag8uXDqBCXmA+UyTzzQ0xP9ScY=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB6148.namprd10.prod.outlook.com (2603:10b6:208:3a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 07:41:01 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:41:01 +0000
Message-ID: <03fc4a7e-1cfd-47cd-8a79-7b6386d8eae6@oracle.com>
Date: Wed, 16 Sep 2026 13:10:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0709/1376] iommu/tegra241-cmdqv: Dont run the error
 ISR before probe sets up vintfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nicolin Chen <nicolinc@nvidia.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065623.346623736@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065623.346623736@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: 43741939-44e4-4b4a-f73f-08df13c5db31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|4143699003|6133799003|3023799007|18002099003|22082099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	zJsRvqpL7hWATbY7efst6hTdP3cUw9DX/rbjFaFeTdsvEpncMSRXC/OMGuDxj/kyPFFAAd7zZKZZ/TNEv+sW2xaqct7qEhIX2qBzRSc5nQT4r0QKKTXowyl56ZBVY/bvvXwnDm+QBcTCmr3N6B3+9ZANgoNpRDMSxihtdff7si+Q2yMHQUf9it6muPmgxfhz8u+OE5+D5ZI14pA8AbP/qs03SJvqGhGGivFzllzefHBmeTaTikMFTKrF0486oiH+DoBl0xoznrpp4VZR6K0pEoqWedYr+WS9ic/6Kcueo/4KR7q6yTqr8gp1tMxcu9GN0LpUxWLXOyim11wYEfHPAZ7Qh8r2nivQgIDklWMGrObKLgQbfqXlsg0wJoJRV/FYZODk/1AmcBFwFDA1h87qhnc6JnLYHZhEsuHz4D6N1WOW9s8yS55ZGUXJhFh1L4wLSvtNfo4ChGFfTI0Kh/P6QJc+bMVzc4gh8JoZ1zHGydWLSRQan87nPGepw1IbkpDa9GXlr1tQsIwUYKMHTXaIeGB7dks6VwhWZjVd18Da+IigB9X2W3TshsvtSO2viQP5sFzlqABUjMrszQev9r9F/svoE8EHuKgwX7+sLIfApRkOX8/sCHdwN6KI1pmIfL+9cu9hDWVJ933eVAnxgOUlA+7mMsdKreiV1P6y0czbCzA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(4143699003)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1c2OUIyNjE5SW04UGFYUGMxT1BSQjdQaWNzYW11QzdLY1RTcjRQVXYrTTM4?=
 =?utf-8?B?Y0JEckJGaUZldWJWWUN0ekI4TEJVZnc4Qkl3WGRXNm9NS1NSKzI4RUV4dk9l?=
 =?utf-8?B?dkc3dWQxQ0srZ21SRVBJaEtqK1lTZUVVY0VQSVFTQjQzdlZlRDN6ckd2V1RJ?=
 =?utf-8?B?ZkcwYjhpYjdPTkRWSkFQYnYreXcwV21FdTYrcGIrRG5pS09sWEN0MVdrR0Q3?=
 =?utf-8?B?MjlhUUhOWFhOZkQ3aE5UOC9kUmxSb0w1Qmh4bzNzT3p6dFhNbnFEVndBUWpl?=
 =?utf-8?B?ZHFEWTAvK2FKZVdCZFJ6Vnlvd3U0b0VtTmdxU2N1VG5HQlVDTzR0ckw5c2lZ?=
 =?utf-8?B?cWUybnBaMFBON0V0Vmk2MURLRWFEcFpiNGVMbFI4Z3AzKzVPRlZCRG9oMHdv?=
 =?utf-8?B?cnQyQzdjMUtRdVJBZjNseUNJMStkZXN6UFJSUkJMejlaWjZZdUZXbGFuTW4z?=
 =?utf-8?B?aEdxcVRDTEhQaHJVRVNtRVBTaXdTTWZHVmF5bjBNMUJBTlozZEh1cnB3TEFX?=
 =?utf-8?B?Y2JnaUdvaVZwUUtDMFpHQzI3Q2tWRUFQZm53bWtCbGRrdklFdHBoZnBhb3BP?=
 =?utf-8?B?cHM5Uk1nQmZZVGxFVnlteEtFNlBJRkgwQ2xJeTZDN3lSQkNSQThXdFJxS0h2?=
 =?utf-8?B?M2lBWTNvNk5Bd2pNV0lxeG1ZNlZkNU9YODU1QkpkYkVpU3MvWlI1a2RBM2pC?=
 =?utf-8?B?SUZieFFXUWkraWRidm4wMElPZHpSUXZWVmt0eUFRWXp1aWVEMitrOUh1ODRh?=
 =?utf-8?B?aGdmOWFnSWxYNTB5ZUR2RlR3bHRmT3E2VjUra05OQmJaamcycU1mdHVURlF4?=
 =?utf-8?B?Y3VVUks1ajFxQlE5QTNrZ0xISHlIQWs0ZUw1eUt3K0NzTC9kS1JPbHJMbXJY?=
 =?utf-8?B?M2I4cmoycmxkeGlMNFBpak5NTmd5RFFucTNydU9ZRzVDQVJrZG9PTFQxME55?=
 =?utf-8?B?bjFueWlvc2MrZjdGcUk3QXVXUzBzNlEwVldYU2tZdUVnQXdIUUhTeFI5MVBh?=
 =?utf-8?B?UVJGVERSY1BRUnNka0Z2aGswbUZnS2d6NU9ObjhGTlY1cy9SNUZ2NXQ3TGlZ?=
 =?utf-8?B?NVkxdnVQTE55enM0UWVYOHdRSGVIczFwZEh3Nnpvd0kxM0k4MFB0ak84dzhK?=
 =?utf-8?B?UlVkanlEQVVMUUU3bTFHczAzWHFaSjdjd0JjVi9JdWZ4WERtc3BmRjlUbzg5?=
 =?utf-8?B?SVorT3BwMENNK0Nsanhsei9KcHVmZXVpTkxnRTJmaW0xZWRqSkJCT2hocUxT?=
 =?utf-8?B?eXFwTzM2N3A0amNEL0tQTWxzMG9HK3ZiRGZxV3ROeXpkeUlVcHY0TTFiRFd1?=
 =?utf-8?B?UzBTMWY0TzRHVkVGRW9nbm01THRuYTNSUS9ua1BOcjdDSHpaRHJ6aHBXOWZG?=
 =?utf-8?B?L1lBVThUbytXc2VuSE5jM0tXMGM3anFlUHhjeGdJdlpvWWhOWkpWSVRSb3k0?=
 =?utf-8?B?bEFNZldiSHdRbk9PcHZ6NG9LMGg5RHNEUFVvOGVzOGwvcTQ4aFNvWCtxUlBP?=
 =?utf-8?B?MVdia08wUk1kVEdKVFN0bURlRlJka0NEckFKZnZmWk1DMStlSWxxVjJPckhj?=
 =?utf-8?B?MjNWVUY3TXpEb1c5WkV2LzFUSWZSb1Z5TDZKdk5ISm50K3VrVXNUdzVuZzRS?=
 =?utf-8?B?cnJaL2xHMUlPbndSVTVpZExkOWRUajdOdVYrb1UzamI2dS9uL2U3UmJuTisr?=
 =?utf-8?B?TDdKUk5PNzlnZGxJRWZ4bFM4alpjSDF4Q2Z1NWZvUDFYaXg4Y1VpYVY2UlpD?=
 =?utf-8?B?NU1DUmRmME9NU3I1ZnVSTXBmZFpiZzNwM29PZGFUOFByVmRKNWFPbWM2Wm56?=
 =?utf-8?B?NWhMSm9DSzhwNDU5TUVZdVUyelY5U2NsbVo4MkVtL0I1QytjbkdxUHEveHZ3?=
 =?utf-8?B?UTVRNVJldlk5ellNSGRwT2R0bmRrSGUyMlBobXExczdXRFB4Q3FBQ3ZJNlBY?=
 =?utf-8?B?WmtnbWZQTmZJM2NZZ0ZzWllMbWdUY01EMHg0WXNkTExmcGdDejIvY1QxZENr?=
 =?utf-8?B?T04zdVBKcnVBMGhEdHVMdlo0NlVER2x3cVJDRFBveDhQMEdKYUVWZ0c3R3lL?=
 =?utf-8?B?b0h0RlhHd3IraE8rVXFSdG1lZnRBVEpYY1gxY1dweU84NExLaElYa002NU9z?=
 =?utf-8?B?WWx5OEoyUXByY3dQTi8xRThkTWhWeDJUN2JTNVd3d3JQOTcwVHJnSWVzUWVh?=
 =?utf-8?B?N2ltdFRmc1pDdDhJSHBlRk5hSk5OS3hWMmhDcFpNTzlOUGhTYUp2S2RSMHBi?=
 =?utf-8?B?R0NEdHEySFFwMU13eTR2cFRHdTR2UEtwU0FNM3dSenhJYlpnQjNrVmlEOUEr?=
 =?utf-8?B?R1NFTE9KenRqQXZFa21wRi81UWdFRFlvMWlSd3hHTUQ2WmlUb2k5bUFNTUov?=
 =?utf-8?Q?iu4Pih23JV5NBvp69j5NuAHFY96RHrhlOxS+e?=
X-Exchange-RoutingPolicyChecked:
	aEaccEJGnzIYKZtXi+rW2K2BCSPlU5frNrOhDip3lLPXoCLU6iVMEZbUughMAZ0P8o0G9WHaoFtnEjmCiZsqBtCxCnLUuY8qIeuFuG1hewpdaoEN5TYG+vjD/Byb08RGD21gDToi83JtlKWzq+sMp8FJ5o80LuwChg5PWht8CZGmFjAzOTzf6SdOgzrgT54zrkdC4A8OHC+AzU/jqFhGDPbHc6WCX4keiP2AN3OU63+TBahbvmn6rdoPmZpYplBa2iEPmSTlqTgLFEzLYx83zTr/UUQihnXu+BNO4/aVTRmu3R4gRG8OvBkArkbO9bFBPTDNbLwChCTuUdf0u7yW/g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cbpncPHhg59O22hUL2HdQkzUNtgXjaTyr1oRZvzlqyC0Bi2MtTr09PnR2KdfAd+3VO7ZRBbKVnIvSSyukJPEbIftguKfML6xyvni0WS/fBIG4OAmmw+hBWKwT2xd7RwPfJ0nFNbjepkx6urLjouBDTatteUqYA5UIxmycz0Ls0lUXcSPfsGQ+z1mGJ2qgP2F92WSfT+CPNlnQ92YXvY0RkN0g7xyEiceEasuyqYoZbL9r45lYvuyRB5yPKTc/G+fQ5TSzhqaHQt3evYq/zoZzYjDvhrD92KRZI+TRKqJTTXGFBtTooR0mbQtJoWCX5g8mUN6T6zgZqOJVoK9u0NlqvAt5/TfpD4tnW8Xk3Sb/DVGpkPG9j96jXWsA6XXZ0Jug+2i8ei2x7V2b4WX3VZktmwXt5NVhaI0iFkn2GyLGFHoFXSZAXwFH5cYp6Qe5H/aZt1aaWz8W7zIAzG6PhlUe1is0DyQP5ttdHXTuUsoZSfcWp7y5n+ACbbmBaD0uXUlm5IEpuxPgEox6Ky79mCJmCIVhiEtplhmlA3cPRRwwd5+zg6TqU4TEQztuYI324ZnmmCm5RIm36yqnU6stT0tHPOhC6sL9KKGRFlYOU/Jz+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43741939-44e4-4b4a-f73f-08df13c5db31
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:41:01.8012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1CVb5u2T0xgkrfeq4czFkCHQswG2GeedNh2BFwXx/h96vy00qSe6chdiAEt/jiLoD0Fp9MI9FXUw/EhVuT7aObrcTE4uCzi84XW1FfoghIMklCaa/bOrul533CwX4ua
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160099
X-Proofpoint-GUID: 7kdY72H4lpTLIDGY16-SRG5Kz5FQgDRU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5OCBTYWx0ZWRfXwpHo/lluqI49
 ngd1zzmcRwy7zQsxNhQyXBLIhtROJmQ1hDLZiDQyxlVgT5jNsVx2L/pVIuKnDOV0oVCx8nHQ8ig
 yWY7tPl9QxG3LhEv366LKjfU4yvq9Laz+RE/eF0eoQ/n3OxA06rFSJ1Pg3NmW3l4LWjiuzWRQFP
 FPupQ3X9f+hdPqn/NXFFfLhOJtbVeHbaEphTe/PzO97NmKtVmIcXGbQ1GNowqU76lymvz5KA+xn
 +TfwgaP9e9w3E/UQSxDxRCYwS9SX6kJyPynRXPfis1bnObb9nclInKqdpoQCMSTL60Vg+QFHrw1
 l0hwcH8s+dqB5QeHSSDOq3Xu1HK+iSLTKQK5g0j+QXkDIfpOzvZex419W+azEamOrjcJ/FW1mgd
 qGuOuFeMRWt3bPLRP8TBujdGFXwgwYwasLe+YivLbkk0yqdQC3o0goJhvdeTDff8os3fxJ4qGJm
 L33+l8r80ZRaKBubJm6cCnL4Jy3H/Xc0KRCez5DE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5OCBTYWx0ZWRfX8znYZ9rxEu4E
 vN5h6kvHPUoIQPEUkvrW1scev/a7C+GWJLzJ9UNDflESKtXh84Pq9IFR+6Nu9qbKKCy3bjlln7I
 RN+Ux2Fy2huWmm6U4Rqbu0HEK2ONLZnZQ2LlLW6zJAcG8Ix2mSO/
X-Proofpoint-ORIG-GUID: 7kdY72H4lpTLIDGY16-SRG5Kz5FQgDRU
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaa4813 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=FxWwBE0Suvd28DGm:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22
 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=Djuq_3Q1hmsfaIX_9t0A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107



On 12/09/26 12:22 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> [ Upstream commit 5acd67ceb38debe2fbf70ea35e2dec9f7ab01bbd ]
> 
> __tegra241_cmdqv_probe() requests the error IRQ before it has allocated the
> cmdqv->vintfs array and set cmdqv->num_vintfs. A CMDQV left enabled with a
> latched error across a kexec fires the IRQ as soon as it is requested, and
> tegra241_cmdqv_isr() then walks the uninitialized cmdqv->vintfs array.
> 
> Request the IRQ only after cmdqv->vintfs is allocated and zeroed, so that
> a latched interrupt firing early runs the ISR against a valid array of NULL
> slots that it safely skips.
> 
> Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 34 +++++++++++--------
>   1 file changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> index 85f851ce8ff1b..51aca5269de9b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> @@ -824,17 +824,6 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
>   	cmdqv->base = base;
>   	cmdqv->dev = smmu->impl_dev;
>   
> -	if (cmdqv->irq > 0) {
> -		ret = request_threaded_irq(irq, NULL, tegra241_cmdqv_isr,
> -					   IRQF_ONESHOT, "tegra241-cmdqv",
> -					   cmdqv);
> -		if (ret) {
> -			dev_err(cmdqv->dev, "failed to request irq (%d): %d\n",
> -				cmdqv->irq, ret);
> -			goto iounmap;
> -		}
> -	}
> -
>   	regval = readl_relaxed(REG_CMDQV(cmdqv, PARAM));
>   	cmdqv->num_vintfs = 1 << FIELD_GET(CMDQV_NUM_VINTF_LOG2, regval);
>   	cmdqv->num_vcmdqs = 1 << FIELD_GET(CMDQV_NUM_VCMDQ_LOG2, regval);
> @@ -843,10 +832,25 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
>   	cmdqv->vintfs =
>   		kcalloc(cmdqv->num_vintfs, sizeof(*cmdqv->vintfs), GFP_KERNEL);
>   	if (!cmdqv->vintfs)
> -		goto free_irq;
> +		goto iounmap;
>   
>   	ida_init(&cmdqv->vintf_ids);
>   
> +	/*
> +	 * Request the IRQ only after cmdqv->vintfs is allocated and zeroed, so
> +	 * the ISR would not walk an uninitialized array.
> +	 */
> +	if (cmdqv->irq > 0) {
> +		ret = request_threaded_irq(irq, NULL, tegra241_cmdqv_isr,
> +					   IRQF_ONESHOT, "tegra241-cmdqv",
> +					   cmdqv);
> +		if (ret) {
> +			dev_err(cmdqv->dev, "failed to request irq (%d): %d\n",
> +				cmdqv->irq, ret);
> +			goto free_vintfs;
> +		}
> +	}
> +

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The patch allocates a zeroed vintfs array before registering the IRQ,
but VINTF0 is created only later. A pending bit-zero error therefore
calls the destination handler with vintfs[0] still NULL, and the handler
dereferences it immediately.

Upstream safely skips that state only after the acquired NULL-safe ISR 
load and publication changes in cbc41aacd49e and a491be376abd.

Upstream code after a491be376abd:

     vintf0 = smp_load_acquire(&cmdqv->vintfs[0]);
     if (vintf0)
             tegra241_vintf0_handle_error(vintf0);

Downstream 6.12.y code:

     if (vintf_map & BIT_ULL(0))
             tegra241_vintf0_handle_error(cmdqv->vintfs[0]);

The downstream ISR has neither an acquired load nor a NULL check.


This is a multi-commit initialization and lifetime model, not a safe
reorder alone. Maybe we should be reverting or queueing more commits. 
Thoughts?

thanks,
Harshit


>   #ifdef CONFIG_IOMMU_DEBUGFS
>   	if (!cmdqv_debugfs_dir) {
>   		cmdqv_debugfs_dir =
> @@ -861,9 +865,9 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
>   
>   	return new_smmu;
>   
> -free_irq:
> -	if (cmdqv->irq > 0)
> -		free_irq(cmdqv->irq, cmdqv);
> +free_vintfs:
> +	ida_destroy(&cmdqv->vintf_ids);
> +	kfree(cmdqv->vintfs);
>   iounmap:
>   	iounmap(base);
>   	return NULL;

