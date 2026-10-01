Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3753361DA8
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 20:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790885566; cv=fail; b=WvSNTjMwlBNNcP6aRiBVQOCV8mJJlZTLfa3fZDwbu2v/i3FdxM5Qd7vANhDGycIQlpKmHGyFuStg31UFqGDCtFtRPURk4rH1k4uSqazwXWW/TIX6jgu7fx1VlMBLBcGkXD5nlec5qfvNNYLN0F3Oi/03aCM7uT7YYNcUqWePknQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790885566; c=relaxed/simple;
	bh=JE5cozZvZU31EIM+GF2ZWZxn9olSMdLYPjNt08YOiEQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TCALdHIscPee42RCn6OaoB/7W7BaDJVE54FvkY4hyoEOMRcFZ5ptQGo7aAy+9UHB3ybSIiiPfIBc1BIkkUywOa+m8V3o2/+rtG+gJvd7qB8Nu0kR6V3F7g797uEl/1u95SmEAkc8cZJe3DbiaMSnRPkP+3KLDPq2WgCWVOZfepo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N2tG/L8v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zb9TKDyd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N2tG/L8v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zb9TKDyd"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691FtiDJ907919;
	Thu, 1 Oct 2026 20:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kg3hxEGKX2AtNZ91CoFHZjEzt6B9d0wfdFg1vmhWUM8=; b=
	N2tG/L8v61pudC8KF9APrR35Z7b3y2XslkqBw9Je12ke9UpKGboLgfphqc2yVRdN
	77CTvqukdDcufHTbs48XBdjEsR5jzIUd0dKuIu9Fo/KKZXXf9G5KPD7WaMKnF1/b
	ZnCFvW0BGEhYXUD0OSaqF+u1VJwULYTnpvoH3lsAe6w2gxGqnLt+4IwcgqNlCqgq
	wkgecAQ7seFBuv64Mu5hvpIKk/xybg7k+yVS4ukqFq7a6Vrs1xB5e+qWisf/Rm1E
	mKLwjooaQTbl0ePM5eRxLbySFT0rXJyUy/xLyxerPsjmWLCN6MQu7x4iuDIyqh2k
	qrFb09Z6JAomUqjK4/og7w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4u2j3fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 20:12:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691K5NV5031157;
	Thu, 1 Oct 2026 20:12:40 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gsrmau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 20:12:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lnehdKyOq8SFFZssdOabjPo7OcQWpMDOLpAp7dDiySQpbIWMgi9meAlJNquIv0rHOVopejeT0O5/MY7eJ3TSx9lajokB+h5zyf7zEyZR4z2p/7wd8JDg6HFGmOygyFo4s7zPI2fLAnrcIKwRuuZo2qPin8/pBETnkMyaGGSOW7mAzK3rtUf7avXHJ7wAwj+SvGEQKZHhfefQ2PPfTrUd6pW4DsJdsp/dY4WBoPnUGOSYYI7ip/uc2O5gvSrX+VuqFGRWgu4BplZBIr+VOWHowmL0lUuXbtixvyAX8x19/8uFWCo6rRQmP9o0IkNY+wbWEFnPDUq0vpwwkh3LmLTlDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kg3hxEGKX2AtNZ91CoFHZjEzt6B9d0wfdFg1vmhWUM8=;
 b=fZLSmmLah60SnbrnD8QgHCeFCH5ycN5p2VuvOj9sRHu0dJxdsKb056OYsQ3OtsvP4lup+dT1DNFRf2m5nvCfHApkcwYcynDfpRRSIOrsAlceVVp7/pXMSSzrRjAUIWSHqK9Ws62TNAqzSl00c5a4fQzbrp2zvq4NyArki3DkhCedR73xVJn7IeKTrFk0K3Cuqzuze3ZTMpup7Z5eFWMYqJpHdROSg2ruXit/WN+S2HPphQmyd/l6Ja+q6YtYiazK8/Ctcrd8tDojuZHt4iiqJe/x88u4hUNv3+yBLusP0zuWSvrB6YEJLkdGSCwBENmvL54Gkufi+D9r0azVSJ0OoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg3hxEGKX2AtNZ91CoFHZjEzt6B9d0wfdFg1vmhWUM8=;
 b=zb9TKDydoPJdgaut5ofCIK1ysiGfaUho2rqg3wk4lcKmrtiMh+Ig/xPZRkSRkPMs5/emR7RuJp4GH2O/JLMB6xtpbtiXhJyMrC5EyfI4/4OGIDLeV/bM0ilVxO5lwyuU5gMCivk/jIoE9sD4bzpsI3uC6yVr1/Rk1e/AtHjCrIY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 20:12:34 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 20:12:34 +0000
Message-ID: <230a7cd7-386c-4d64-a896-09dc32720c24@oracle.com>
Date: Fri, 2 Oct 2026 01:42:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 436/877] macsec: inherit lower devices TSO limits
 when offloading
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
        Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152424.092713670@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152424.092713670@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0273.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::10) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: abaaf128-27a1-47a9-2dfb-08df1ff854bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|4143699003|18002099003|22082099003|6133799003|260925021911599003|10067099003|260925021311599003|260925022911599003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	GlULUrXSGVdY4cKbVgCosjDr+Z0E8MfK4+Jz9rlSR/ELKO2LHtBJHPvz0o00EgZ+cP8yh1UzVBJDeOwKEKPHFSZ+lkhY89idbae2Yn3JHd1PRhg6EOuqFai9j43zIaUsWtWC+dmO6xgOkVKbdAkVmpeZRHBmOc9KKeJrA6ee3CxnZBfrfm1v3iDQuuQMqAWjgJw4mGeliOzmXATZEfqtebGFK6NZXu4XzNUGMr7A9UNB9NNKPvMZ6Qh8OoM1cOxXPhyiUGSpwWslsBSMFNMecsVtAOlHoz/6c97CD+Mdd3NVCMjySL29U7eBbqgiImkbK4W+nXcPY98vVDtcb5JFsCupuNGZdqhcuIRLsKKWEg3UtaL/Ms+ad1gAJJAchHU++x6U/vWAG44uRkWQAytEpinAQNw2R2gps8It5iWUaHIbOniTkSGdEPf3sw0XbxmvPvbz2pLWG2eUiKOegBNLlhvI7zKuRtGok+PS2zFfye8tNSlMEFqPVz45SF1CaPy6n9XIZ7xbyXDpEQL5i4TvwCN53JEbwl5AyYpj8csS7Rl2eVbrzWA5LKco8l4lUnd66GwOUB0DeK22HjlMgBot8GKKBeSdC6bF2RGDzL0aZNY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(4143699003)(18002099003)(22082099003)(6133799003)(260925021911599003)(10067099003)(260925021311599003)(260925022911599003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0FLM24waHZHSlhCdGt2RmExT20rTEt6cXhRNjFLSXNmZzkwYlh2TzhvV1cx?=
 =?utf-8?B?S3dmS0k4V3ZPMVc4RXlyeVN2R1VmME1MbUZnRWdYUmhyZk5QTWFRNFU4MXlG?=
 =?utf-8?B?MjF0VTVPY1VIUWRneXNyTU5HMGRiZWVCbGV0bEpwWGJWUWJjMi9xM1BkbHFI?=
 =?utf-8?B?b1FGMWF2YWoxMGh0WHZFZGh5SXNDNVBnbENjMEdaemNNd0VrUG9OL3JiL1NN?=
 =?utf-8?B?Z1RGUXdYZTJuWU9sNXZRL2wxZ2VUR1FuSjgzWWp1dlFkSHdBVWxuNDcyM0gy?=
 =?utf-8?B?aGZNdzlCdzJ2a3ZGakM5S1R0bTJDTlFxOHJSOGVRSitlNUZzdThUeWxBQlFJ?=
 =?utf-8?B?VS9VUmJ6ZC81RTQvRVZ6VnpzSk1NdXhXcFZCc2F0Zm5QajM3dDBYaGNOU3B0?=
 =?utf-8?B?VlpzSVlId1JSaXd6VlJKcXF3S01BTWlhdjgzT1czbmFlNGJsZXM4NTR3WlFE?=
 =?utf-8?B?djRtR0p1NE1DZG9jd1pkSkYwR0pXVHVaV0hnaVpYMC9zdGF4U0wzb3g2dWpx?=
 =?utf-8?B?WFphYUVpalAzU1pwaG1YdVRFSytOY2dCZm5hOHZkY01zMU5EK1ZVRytYa3lX?=
 =?utf-8?B?eHFQVkNicTJnVlYyU2UxQllmL091eUdIa3A1RGRQWm1USldrNmJ3M2lPajdw?=
 =?utf-8?B?OUVLSnV2QnlEZ0RxN0txczY4bVU0WU5FdzNKWFpqRzhEci8za3dscUthaWor?=
 =?utf-8?B?MmRjUE5HcDRZV1lnWkFZSUo1d1hJUUFQQzRYblpVemlWcm0rTGNINnJPUU83?=
 =?utf-8?B?bjBxTllOdDZvc25SQTErTWFsOGRTbG1CdG9kQ3N4ZlFQM3FVSHc4aEduSmI5?=
 =?utf-8?B?V0ZWekJGcGZVWDNpb0N4N1B5bHg3VmF4Umk4M0NzR3owbWFzNnNQY2xmVWEx?=
 =?utf-8?B?MFB0V0dvdnFteFBkUzBqRXFMdTkycnFvWTJGVXllUWtHVG5jSmNjclB4ekUy?=
 =?utf-8?B?Z0hLa3BiYmw2aERtVXdQYnhXZ3hGUGMvZkNpa1B3ZlJxTUhTMkpiTmcyeGdW?=
 =?utf-8?B?RzExcGlYeE9Nc1Z6Zk5nR2ZIQXgxOTlNNUdwa2l4cGEvS2ZjOEIzVGtzSUo2?=
 =?utf-8?B?ZTJWUk1DQmFhWmtTSGg2cW4zd0IyREZGVEVNYlRPL05PaC8vSThjWDV1TXB2?=
 =?utf-8?B?aFF4OWZ0M2IxV0MxZHIwNnJNdkZBaFhXMFJldjR4RzNVeHpOTkpiMWF6dzRM?=
 =?utf-8?B?bURYYUZBby93N25SaEgwN3E1Ty9XYk9ueHRlVWNMRU52eDBkSEVOVFljMFZN?=
 =?utf-8?B?SWJkUWdBWnBoY29jNnJHazYvcFV1cjhrMGdZcmpoQlF6Mm94bDBHeDVKbGpY?=
 =?utf-8?B?OWdwNzMxMGNGaWg5a2VBTXFZNGZSYjhpQlEyYm01QzZpbzY0MUdyS2VSbCtt?=
 =?utf-8?B?bXRpcWdPTjhzMFVaOFU1TldZRjNEVW5mL0JhTDJCb1FUUitONEp0ekI3MHRs?=
 =?utf-8?B?MnFxcnNtajNpQzNqSGR3QnhnRkJtTDJQR003SkVtV3VQTlZXSUNnWTJ0SXhr?=
 =?utf-8?B?Q1dPbjB0TGNDeDNaQlo5M0g5akNxN1I3MGtvT2VROEpGOHVRbkcvblAzMGJS?=
 =?utf-8?B?UHZid1hUYVY0ZjI3cW84ZC95ZFZkcXNmL0lQcFliT2w0NUxhQVpWUDROcExT?=
 =?utf-8?B?OVBBZDJjMUFEY21JV0lwR3VZMmc0ZDhxRzNvb2lXR09HMWRKNXZlenh0TE51?=
 =?utf-8?B?MDJNNUtsMGcxTCtGWFd2OWVUTk5WYlZxaGhON3p4NW5JV2Y3ZlFpTXhaUTlV?=
 =?utf-8?B?aGt0RFYwU1BpY3FGdmpST0JPbEt4SXBuZXJMVlZYUjRYc1dib0FhcElKTDhS?=
 =?utf-8?B?ekFtc1NQQnc1dHh6ejd3ajB1NmxNeFhJNkYvelBIMFczS3NCc0lDbFVWMGsv?=
 =?utf-8?B?NUV5VVFxU1hkUW5aSFNkR2FMVzZKRUdxRUJvTDYzMHFseW9kTVBBRFFHL1pN?=
 =?utf-8?B?YllrVUdPMmZOUUdoTGM0ODYyUmlzUXFOeVVMOHhqek1tcDJkWkJ2aDVQUWZ4?=
 =?utf-8?B?d3llanBHRTlrQWhpWXBxaEJtSjAySGJ3QVcwSFROcm9JZVNGVUwyaU0yQjBT?=
 =?utf-8?B?T0tCU3JTRXR4YW9ETFlGVUlYc0hreVJzNXVKNzlIMCtvL0ZxUEkzdmxFWmt2?=
 =?utf-8?B?ZXNIUzJrTTJTckVkOHlSdEVQS1J4OWNBVWZLekx6ZHEwNzVXSlg1WW9URkpJ?=
 =?utf-8?B?WHJSRVc0RkRVTURDVW9lemN4RFoyKzNNdi9Wc2lDdElWTWR0aG1Ud0xtZzJQ?=
 =?utf-8?B?bnlETGtRQjZvZHh1L1Y3NWhrZm1PaXNLMWozRTV4WWRSWFAzaEcxbTJYU3FY?=
 =?utf-8?B?cE40VXpZTVhybTJqa1pYYUltejZEVFp5WDFobTkvSjJTM1hrRkpNRDJobVRW?=
 =?utf-8?Q?+b8o13aHBVN+YFRgtPSJ7Z+/QvzblwVG7A6Ym?=
X-Exchange-RoutingPolicyChecked:
	iAB1WxtmYZ4B4jP/4xxY7iuwKlKZzIq6Sun5PnKdhn/ZF0tZtEE8tNsfxeWKYvsAiYj5Kit8ZaJ4LgtcHmSIh3FB4Xy9894t17gvg5v1bNMzBTB5RM3KFKnHj5VVzVRq3PKhdFI7xi1RfVXHldtuqFZaVMl7MOJeDKUgpRwruxwNJkX4ROEMymNhZzcJM8JMoM3noIP8X+Ug/TOMxFXE9wnVi8r461C0DDAGU69l+bdnMZ6HyTkXFPQ9QKST90gh9ioANWQAqq/sCTSjNGcejbhrBkvUza/L80sM+M/+IF9sF+gdL9KJ2P2YFkXY7AwqAreAE8jwbbDCwXO57RXVjg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xh5CzeFO0PLgPsJA6c4FtbvCOrmM1RmGfEGewX+5tkP5lK4MPS4+1sp7NJriUM/gevX+XKRyAHaOJjj+QzO8Sic2keb++gvoxndB8m4+rgf9qS2P3rDomGLV12mFKOqMuKE4D2xgXfnQbE9rITX8lqrYD3J3GO7oz7nMwGSu4aTEmzbTnrLTB+1wV6unWzAR8ff/99x1q8yqgZRUsGGYcy7DG8D4fHvZdU0Hiqn1n25ZIkrEKlZ6fSysFsNZgivOsI9yb97A+my/K3Y1woPB5Af/Q3Lua0UPpW1sS6QUiVNzl1+lZ8Df1TGgoqNWV9u4avkl318+ltn5aCYhGy79revq9DEnWwcDJ4S+6AlS1Mh4gQaoO95aeYDhMqUEOFjng/vfuz/9BiqXllJjmU/X0wK7w3PI3Pf+1qqzw7iYDza1KQ3AxVUgF9a94YbzoPohWVpHtjScU6X2S6lUUvYyJSwIu7GhGahRCocZL3E8wn+843XpWPh9f/Vw5RuouvrS5ZMurkZDMQgOQCCQyPZafHmmPHOcavr+u2u1Gv7NC+tc2lgDF+zoRYd1cTeDtoGlsqZ0+eyWGz0Y0sFyJL8x6rahHsM5z0OItzP8wYPvXxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abaaf128-27a1-47a9-2dfb-08df1ff854bd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 20:12:34.6190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9j2ptlyDuZAZRdHjLUi9tAYM3YiQOXMWXkTnL0xYHJeERqYzH6PaJWm4sf/+iwD9kM25Xm9zbcpnWjvpGZuJbc+esa93480877PsbFJUdOnmP/k59AjTQ0aGGxAWAlr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610010080
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA4MCBTYWx0ZWRfX/e9jFMBPR5XR
 OF/xPFnq4785+s7rQwGL6/j7dkrpAUCTZLZvKzP9FZhploK5karq2hxckEOTCBR2uDpqpaZi+mX
 DTd9JtGYSsAmwgWDjO+/KIToj1nyRWmrGkdvPRtk/FdDrjXzVSWl
X-Authority-Analysis: v=2.4 cv=W9itxhWk c=1 sm=1 tr=0 ts=6abebeb9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=bC-a23v3AAAA:8
 a=AeCkNC4mAAAA:8 a=VwQbUJbxAAAA:8 a=VzWePGuD10H8WWrbg4oA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=3H0rhiSm_XezoJcgKFaR:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537
X-Proofpoint-GUID: pmxDzCfb42tKczOenI1xMHvma9IEVbZx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA4MCBTYWx0ZWRfX53MPWCEOOhwH
 0hu+cfMDV6iDiE2l5CmqaP85/9ofy22rw0tDdR/cfnIqKFVYRqxBJvXmQumM13VZFRvdAPR5mQq
 jH50HxgPCJEE0z5dh6CNI+KRueoKl+Md74VhzNkFB/HyZaRHWSD/M15wf5SRrgf53cGK1UsjfQW
 cq7a0lvYrP7KQSz9r6fZ1n6eVU4fYpv165Z9HPMCM8grt5lDRGWy3sEQWNLsP2/nF7ZCW0Y4jsk
 6ritIFpb1fN+AwCb8EPWiUFUGyIt8h3YaGOYG5S3Ts7HFXPBFd3PMna1v87EAv4toLPYPb8xZE2
 nFLc3A8RT+cei9klwtaEQfvjAaM5g3Vmy34M8TfkTWd34/6hSvnffs8cjz7gIQ/Rj6hqo0TqsOR
 UboA9ivMr6N5Fub/lt94MMNfFxDENXEdH/JGAs1R3pWDi704iUpQeGvRm6im9HgAJwOmM8he1HM
 mXRpOnTyMZ0UWu2eM9W05JhqU2kbdtZ3pPzx4AdU=
X-Proofpoint-ORIG-GUID: pmxDzCfb42tKczOenI1xMHvma9IEVbZx



On 30/09/26 8:52 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sabrina Dubroca <sd@queasysnail.net>
> 
> [ Upstream commit de187a390838c0b3dfd00ae5399aa406d0a79f13 ]
> 
> If macsec is offloaded, we need to follow the lower device's
> capabilities, like VLAN devices do.
> 
> Leave the limits unchanged when the offload is disabled.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://patch.msgid.link/8240c0181e851f169d815f59658a01fb9dfc5073.1730929545.git.sd@queasysnail.net
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: c2de369c5c5b ("macsec: initialize SecY before registering the netdevice")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/macsec.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index b1eb6b5dde0fe..ce4a08f77724f 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -2650,6 +2650,17 @@ static void macsec_set_head_tail_room(struct net_device *dev)
>   	dev->needed_tailroom = real_dev->needed_tailroom + needed_tailroom;
>   }
>   
> +static void macsec_inherit_tso_max(struct net_device *dev)
> +{
> +	struct macsec_dev *macsec = macsec_priv(dev);
> +
> +	/* if macsec is offloaded, we need to follow the lower
> +	 * device's capabilities. otherwise, we can ignore them.
> +	 */
> +	if (macsec_is_offloaded(macsec))
> +		netif_inherit_tso_max(dev, macsec->real_dev);
> +}
> +
>   static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
>   {
>   	enum macsec_offload prev_offload;
> @@ -2695,6 +2706,8 @@ static int macsec_update_offload(struct net_device *dev, enum macsec_offload off
>   	macsec_set_head_tail_room(dev);
>   	macsec->insert_tx_tag = macsec_needs_tx_tag(macsec, ops);
>   
> +	macsec_inherit_tso_max(dev);
> +
>   	netdev_update_features(dev);
>   
>   	return ret;
> @@ -3566,6 +3579,8 @@ static int macsec_dev_init(struct net_device *dev)
>   	if (err)
>   		return err;
>   
> +	macsec_inherit_tso_max(dev);
> +
>   	dev->hw_features = real_dev->hw_features & MACSEC_OFFLOAD_FEATURES;
>   	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
>   
> @@ -4521,6 +4536,13 @@ static int macsec_notify(struct notifier_block *this, unsigned long event,
>   			if (dev->mtu > mtu)
>   				dev_set_mtu(dev, mtu);
>   		}
> +		break;
> +	case NETDEV_FEAT_CHANGE:
> +		list_for_each_entry(m, &rxd->secys, secys) {
> +			macsec_inherit_tso_max(m->secy.netdev);
> +			netdev_update_features(m->secy.netdev);
> +		}
> +		break;

Hi Greg/Sasha,

An AI assisted backport review flagged this, and I checked the upstream
code against the 6.12.y tip f4ffa8dc360b.

Upstream de187a390838 initializes rxd before macsec_notify() dispatches:

     struct macsec_rxh_data *rxd;
     struct macsec_dev *m, *n;
     LIST_HEAD(head);

     if (!is_macsec_master(real_dev))
         return NOTIFY_DONE;

     rxd = macsec_data_rtnl(real_dev);

     switch (event) {

6.12.y inserts the new label inside the older MTU case's block:

     case NETDEV_CHANGEMTU: {
         struct macsec_dev *m;
         struct macsec_rxh_data *rxd;

         rxd = macsec_data_rtnl(real_dev);
         /* ... intervening source omitted ... */
         break;
     case NETDEV_FEAT_CHANGE:
         list_for_each_entry(m, &rxd->secys, secys) {
             macsec_inherit_tso_max(m->secy.netdev);
             netdev_update_features(m->secy.netdev);
         }
         break;
     }

NETDEV_FEAT_CHANGE skips the rxd assignment and dereferences an
uninitialized pointer. Software MACsec reaches it too, before the
offload check.

I think 6.12.y needs f29d24a2106ae28a9b257503a615ee438efa3f95 ("macsec:
clean up local variables in macsec_notify") before this backport,
thoughts?

thanks,
harshit

>   	}
>   	}
>   

