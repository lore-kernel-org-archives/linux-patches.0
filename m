Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795275595;
	b=N/HLOtCcnTKXq8OiL/k09vFD/pJR0Qt7IU1acTwNt/TmATSMeIAhhlELU0AAFTS+rUl8
	 1DGsQpL79F3oLN5/SjNq96TTHHcY0XI3EeXcuYmejOcp8gejdEYRColWQdD4z9sNItjI9
	 zTpZ8NU/JyFT8KpMs+Ts0a0JoSrHNyN1fdMJur1opO+VllghO08gtrFb56FcRe5nQRIzc
	 aszfGam7vht5x5k6ct0vDT+ti/x6Fudnzb4I9kcbeyhSE1FLDR6bPfj3T3faULVXCFdnP
	 6pgbTnseGE9Q/RXz5bldSnPZ44FPJGo0W9t8r7+r2grZwVdp8gaeKJqj/1vG8Oorlug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795275595;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info;
	bh=pK+F+Di80U38EINhQhfIk+4C5l4ljfHmrbDVBR4AQoM=;
	b=MGYgcNaBtcJ60Ebd24c8gDzANlGQfRnUTU6XyuRTNQ2K80vyvn1uGkS/muCOJXnCCrQv
	 J+9df5k8/Uo6nhwSQQyOqWbOx1g324FNHWR2W4LTtqKolNWI6h5JoTlNVbLSdiX2xp8pt
	 EOkySxjVqmxQ2KeaMvlNp7v9mBJ9443jcSrCkTNcK+SatBRkYiZBYp3wOnelltLfhfOiD
	 NPKERCWlbyGrnqfUVv5mlijZWIQo4zthN2TI04PCaANKkYJ6KAmiCR+cgYwInyZptRwr2
	 I//BFnYhdr+04tw9kxcjSx9yu4razQRAQ4WrI6RwW3ui6PV1Urj+NMnJ4u5IUhhf0lA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=mBGLRR1v;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=TsIemhLN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324C4606A32A;
	Sat, 21 Nov 2026 15:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 324C4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=mBGLRR1v;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=TsIemhLN
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFDT0O2300311;
	Sat, 21 Nov 2026 15:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pK+F+Di80U38EINhQhfIk+4C5l4ljfHmrbDVBR4AQoM=; b=
	mBGLRR1v8tUjPxlfahvTTZZBbnIfQ8lkcCW7nmEpF8Wl/+Az05A+l0doKOSTgAu+
	ARf+4g9Jr4/msEKV1cnIhruwWrSk4vuENsnjY49NESMGD+PWk1onsUZDee+jd9/J
	LuIhvOjp4mpXjAtsspNjr8IcP5EnM7nWlpAhLkzF7/59yBQS4ri33MNcqXM7VRl1
	JXzb6uA5x4Bu52cupkJBLve0IEXQijg7Q3uvGU2dTmj2oaqwV0pn3kGKcThw8rls
	KbscXvzLilI0xpZU3x4UVICJYV2Ng8gDlIQw6LQSyCBNh2RVX2lpXHDHox+tUJdj
	au2/BUIQYCu5Z5bCAfn88w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t508hw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 15:39:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFXkm12828981;
	Sat, 21 Nov 2026 15:39:47 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j39pbm4eu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 15:39:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTnT488yNOnf303TvsWcgM5fcWYl1Yg7RZrtlN6RJVoA1352A177TLN1zkBvzMqRXSC8WE84DrWTuoOD5ikCW3aNy1XKs+ABOmkWwBaLg+D2we+Z0ai9zIWl6beZ6AdhK4H+4Di/RnB3wMz2q4mzKDwZSY/cHTlBzSI5rebuYSIoN14o7tPJ9Ic3cCWIVhsyzQkdnEvhKguKYclNIDLuxPeOfNXy+bxziZvfDLK6CCYBU9TNpeYWJo4pwWiqySr2Szfw7ZaP3GLKzYL9ncehw0q6IPiibj1mFmKoQiyJ3WX6jebFO+/ME5pGiuKXpxweAjWHsxmgUSFP7JCsnH1yog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pK+F+Di80U38EINhQhfIk+4C5l4ljfHmrbDVBR4AQoM=;
 b=e/DGOqai8ChyTHfz7Kl7QmyRiRoV5fw90dyGTZrPylaAC6duV+wPjjxHRylRk8MHOfdYJDNKxSp8ubqITX0tdBqulb859k2K4rnYwOOh5Ep76aejnyqAaOAoCVltCEldypFFxfstyqrLfe2694DX5SJFGSUtaH/cWeYjAW87eI0XJsppXLruETy8pT+XNKmJav1Vg2s3e5w0gwz7dbls/cr3Bf1aF620RCvXOo01w+sYsBMsEoIbb0ddbnSrm6eQRGCAJrhmCAnObYpJFKZkxdmI2DgZcXWoA5yslOZWovyAJDrAMLW0WVKqITcsK4l/GMx6tAXC2KUWeq2Y8oJ77w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK+F+Di80U38EINhQhfIk+4C5l4ljfHmrbDVBR4AQoM=;
 b=TsIemhLNtZGHtGwCmW80RetzSB1GzZJl2Z2FsMh6Ra8c9cxk1Hxw1spXmT+sopXah3baRI4CvZgCtGePRdd+jk0PUofxZKZ3lXxU2tVkh+1r99DG5UAcB/5pz0YbA5qjNEMO+LknGYVOfUPB815ChKcKU8pI7xlPaiwt3/LBENs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SN4PR10MB5559.namprd10.prod.outlook.com (2603:10b6:806:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 15:39:41 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 15:39:41 +0000
Message-ID: <b1a1493e-7a68-4de0-8949-3734e1278084@oracle.com>
Date: Sat, 21 Nov 2026 21:09:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1280/2214] mm/userfaultfd: compare exact registration
 modes before skipping
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, "Gregory Price (Meta)" <gourry@gourry.net>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150102.778121595@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150102.778121595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SN4PR10MB5559:EE_
X-MS-Office365-Filtering-Correlation-Id: bdbfb64b-58b9-427a-6642-08df47e5a8dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261028144727099003|261021123027099003|261026140227099003|261022105027099003|261021121427099003|261102123227099003|5023799004|56012099006|4143699003|10067099003|18002099003|22082099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	FDV76nWKMDalrCqpXjZzMTjESGGpgF1BSsiQsWaekuthy3UnpSR1jRi8qSeAjl72Wjs2R+n3WG5D7waYEGaxLf0zDY5rgjOewDhhWVQIyv2jKAdOwtLsf4tPilzq3cXcDaZe+XpageV1AKrlS1LSbQVzG5bXaywYZ0fiGirr9q0XcMS6fgC2CH5GYHCdocxKHWTrj/23GmRSWw3Ju2P8m+6tMmmvxF6Oi0Bb+DG2YZaK70rG5GE/n8ngrvDlC0cU3Qz1Kmboyl4nMEQqY2J1cazgw1WyQpOmPi1x7tOxFIRICuGBIczGvpBI4LmySWbH1Xh4EOzLx7mCix6O/N2Rfveut/fvErV4jler9nQO5ZuvuL+85YnZ1SGjm1JRtTdnEAu98iyUmjn3Os25lhKk7fBSjMiE/B22Lt5DMe2qZZ75Mznfj+fTv/790GYSR6Oy+JmTsv/gZe4mAKV6x9U9zoh1e/VJk7htwkC7Un/GKRybxzGGFALMCcwFYjLnokfsOpEEYTmBfxQxtPKMYJUjSREAVf/h15lAAPkixXcrs/a5ZjW9mclzYCptTX1UYBrxbnoNtbjZS5oLpClm1VSlUZ2Gyd9QXVWepMoMpONn7QoMU+g3agXx2xJo1WWltpen
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261028144727099003)(261021123027099003)(261026140227099003)(261022105027099003)(261021121427099003)(261102123227099003)(5023799004)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dW1OQkRIOFY4bzZBcUtuRHQ1OVEyRWovSkNwTTNhZ0NrN0YvNHdqVkpvZW1Q?=
 =?utf-8?B?MXJGNGJrZDZNa1lhdWRUN3dLUVJ1bXVVOS9VRnY1WHJhS2ZDandGa1paOUdP?=
 =?utf-8?B?cVJHT2ttYWFNTzNkMUdVTGVremFjRTE5TXJrdElkdDZrQkhYbUtIb294OHhl?=
 =?utf-8?B?OWRXMEhNY0VDMUJESDI4MkhiZXVDUjh5Ny90eHBQV2RiREFnN1J6dG9Ec2pt?=
 =?utf-8?B?WFhBY0JXYUpORTBSUmlDSWp1cVdxM1pPcDg3eFJoQWh5eWdVUVNZQStsRFhj?=
 =?utf-8?B?WDg1cW5qMDR3VGtGZ0toMDNnSGJ6Nlk5YzdxTGVsWDNTdGV1aWYrTmVQUldR?=
 =?utf-8?B?ZGh3dUJtcWw2L2ZRQlpxVWdnOHg5MU4wVno2L2VmNlpBRnlCMWhSTkRPNFk5?=
 =?utf-8?B?c2RVa0t0UithWU5FUmpzNW9hQW5iWlltdWRMVVVqV0wwL2V5Rysrc1d1UjVp?=
 =?utf-8?B?SUFGWUUwazVNb3FlOFZ6Ylh4clZpNHltUkkzeWxoRVlxL0FsZkRIZUJDZi9a?=
 =?utf-8?B?MDRSUVpWTHJ1Z0NFVDJFVC8wZGhycHlqYjJIR0lKOVN1R0V2cW5PVlExVFJh?=
 =?utf-8?B?RVBJY2YwdDRDMk5GZFM1Z2xDbW1WWDhCMlVlZWNzVmFvS1daemh5VE5rbTlX?=
 =?utf-8?B?YzF5ZStqbUhhVUZmTTNPNTZENmdDRGw1L2NpbmtHTXZxUjVXWnNwOGYxNGlS?=
 =?utf-8?B?eUtSUnI3THJkVjF3YVJZMDROSGs3K0J3RG9HekNkd1FMLzJDazRJM0VteVFL?=
 =?utf-8?B?OGQ1TytDTE9nYzliRG9SRitudTQxR2tpT2NJUzc4TWxUbTUyWlo1SzlINmk2?=
 =?utf-8?B?RXI2a1EvQzZWeWxpL01DS3lkdkJkSm45VmVDejlXOGZXUWRFbjFxZSsxclZO?=
 =?utf-8?B?a0RRM0RRcUtvdzF2bnRsTFZGSUl0U3MxRko0cnZRdFpIRFFaMEhIMzZaeXRs?=
 =?utf-8?B?dUIzVU9wTU1aYWF6NFhyODRrYzJGV2ExOE5wREdxS3plSXZIajl2dHUwU2xV?=
 =?utf-8?B?MDFIcVJYd3d1bTZxMGJhNGdGTlMvaEIxMWducStOWVd6RnZrOHF5bTZqTEJr?=
 =?utf-8?B?cytPWjc1dE5sRVFCd3FqMHRqMVhEdlEva3luRHVnNzQ2MGJvTENJdlIzV1Vq?=
 =?utf-8?B?MmRURHBDWDRKRUpmcVhueW1jenZXZ2ZuRGNXVVVyRXBBaDlLL0NLV2hBQ3lv?=
 =?utf-8?B?UGppQlo3MkF1NHJxQVI4K3BpOWJQVmVsMzJTNkpLSTZLbmpZVGIzU1Zkc3B0?=
 =?utf-8?B?ZG9aRzR1VVdlRW5ZaDk1TlZkTkJ0NmV3K0Q0L1FSRXdyN1dxQS84RmtrQ0hh?=
 =?utf-8?B?eXNqUTlYRXM2ZjZaYWpoNmhZZnN4NVBxQ1M5MHgyNHVPT08wLzllL1F5aXAy?=
 =?utf-8?B?NmZ3ckJYa3Ewd2dXYU9HTW5xQjV6VXpSeUQ2cjY4S0ROUmFuZ3dhVHFtYmxB?=
 =?utf-8?B?cjNhaWR2THROUGlJOUlaODk3bTV3cVRDM2w0WnB6OWU2K0NOaytocHhvWElt?=
 =?utf-8?B?ZUIyTFd2cnB2TldoaWppUWJaNzh2TEE1akNKVzYydU02WnA4RUZmR2JveVZS?=
 =?utf-8?B?L0xrbTlVZFRIeHBuQ3Vud1I5ekJ2cTdtb1lHWWU4QUFPOXRzeUs4VWVvb0ZM?=
 =?utf-8?B?VEdIMzlhL2hmQlVVaS9hTVJTdlZ6UGxyeVJBYi9RandjMGFhakVWaHpGdEEy?=
 =?utf-8?B?U2JPU3Z2V0g0djZWdXZWK2pVbmJ1Z1JFVS9NcnMzdllBYWdkSmFHa0pDTnRZ?=
 =?utf-8?B?SFpQVEdtOHdMRXZGaWxIU2JjK3Z0MU1nRmkzdnJVdFBJSTBVWU4zRmR5QmZp?=
 =?utf-8?B?bDBQbXZWdjNyQ0hJQ1JrTTQ5UFZxQTRGalRKV1M1bHlOV014c0taWFBZbVEv?=
 =?utf-8?B?N1htNE1TcmhrTWdGaUpMaGRMeHQ3NXA1cHdLb0xDdVRkQ0FGUy84NnQ2S2Zs?=
 =?utf-8?B?NWZSZWNFT2JvY1YvajNOYU50d2dNemNSTmUxcmEyZzMrd2JzY3g5ai9yb21a?=
 =?utf-8?B?MjdmSzlUMVU5UGpianNNVWIwTWwzQ3I4N1RrZ3BiTEpuYUhnWTRpSEJWR2JY?=
 =?utf-8?B?N3VxVTVQKzgzakN0OUdQQ25hVEd5bVBVOUU3S0FLaDk2RWpuRTVsMzJVdi9U?=
 =?utf-8?B?b2xnRnprOFFlL0Y4enEzSkJjQlBuMnFTdGJyZnlTcWQzU2txS2tmVUc4cHlq?=
 =?utf-8?B?WXdEY3p6MFkzNXdjc014Q25FcWRJMk5RK2FkaVd3Mk9ZRlF6YTMzaWhnNCsw?=
 =?utf-8?B?VC9VYjF5dkdHSGkzU1dCOXF0cjY0SVFBK2dTK2ZQRzFQNGFCYWgyN1U5ZWxF?=
 =?utf-8?B?T090RWRDMXA0M0RWSEhWanZDSGJ6cEVNanpYN1Fhb2JBY0RaVThKVmZqUC9J?=
 =?utf-8?Q?ATvgRute5QtnrNEUSUKbJbOn78uEnYC+0cmXC?=
X-Exchange-RoutingPolicyChecked:
	ksHr5RTQLNP8kQ0yZKcCMh69ZvQEsBuFpT4fUV+NeJTWltwlkxA3qs77YoPri2q7d6Jw8vQeLXavdyboHORTZFFZ3/3Bq94g9PnAAAz86CBkEu/64/RvHKe9LSws6iK8bFLRT3137F9w9wvBuiyzZr49NlDbB2OVJvCfeZzt/Wd49kXVdC3C1pYukB9B7p1gglhC3p7Teos6dS5mL1BaD1SoZfWfWB2RajNgIaQgcoAbESlJT8X9OZ3v7rDKksEZWuLBsWezsu9r6+xCRg1PxKWVsdmdxcAdQjf/6OCgxDBZpYngrZKvTC9UDhFpfrFvrw0FQGWMIWg9pn1/kEMV3Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E7TBSFnL0n607gxy/CxZZ/aPbU+iqM8mDNzFFa1S/QRCk3heznyj561ycikudnDF8Xu6dWAkK/L1uYePjstvCMTKy+BXUKysPBdXxmZymbqI+xdICD2A2A2/8G4KxuqJH0oowcrYrwIRbC1G30ZOT9FZUyh5Sb7B7IaxDflD23EWsslRCM4kvU51S8gR1FS2u8hMD238YnLjL0IeES8OgdvBAd2LxWg5n4r1QhOsy6EtaUKnbxPIipF3LhfOaLXlO0YHe1YhwHVMwEHd1uJ5QO2vOFITyxyOmX5iV5hiyppN9E+zFTeewVKHzpXvVTdx9+qTRIhTNSjQpM+6FpfLG0pZTqiDxNaAv7/COf2jQslt7gx+Vc7EQrh4n9O/nkYmkLL8i7FdaXkdEXK9TbN1oyhQv8/PI2U34p4AWpSwv0JSe4pTQjPqNvAZ71uZCuRanZJRVyhn1bg+04zbc3qEVe76A/OnqOIsaFG9dRFXY9F70m5u+RnfVAIsGX4KZzsyQAS49mTcnbkiZMQ8e8ZWMWlwLIhCidmN4GyXkWCFdVZuzHIos+j36fweK8+TMIr/fGvPZipJeRjWhxPTd3PvtralyimpEJZ0wQVNPI+/iKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbfb64b-58b9-427a-6642-08df47e5a8dd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 15:39:41.7210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 316GC8S0hFhe0AOgXo0yxoH6CAOGJkzzxo4Wug0zjtcXYfZqwnDqGBy7WhOOnQFjPI9LOTH5P0PFVNWlRBahRl4oGURhcesE3coAX/x5EFWJkO9QYbC0qjoyo0zokL2e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210061
X-Authority-Analysis: v=2.4 cv=dJIzC+Zb c=1 sm=1 tr=0 ts=6b01bb44 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=7CQSdrXTAAAA:8 a=BZPQbKC1Snu3wu-IZQ0A:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=ufIsyHvWW7FwcMbVRpPq:22
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12100
X-Proofpoint-GUID: eCyRyhegSOEq291xrRiAP5qQHizk0MU9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA2MiBTYWx0ZWRfXwXEaykD592vo
 xI8MO8uXXV+lKmu7dAQs8U7XceteC0J2GT9YZxnK+4BT7ZffYwdvGPcT4/YNYGMukU8zaS9Ur0y
 lvCUPyqhCWlb5/WhUqOw0jwX58m3BLQLmqXPyX6Xw86+TxjfyR9RcR5EmcCAXGJqQ7MVrOu8Y5F
 mGZzHYYdT1HDn0j3ukfQiqnod1rzUlCJgqCMTlX5IdSrNg7Xy1GksNRe90eN59kjuxHT1RQaVQU
 i+fP1T+/Csp+iSCg9W3gIDJd0NJlgmOwUgpo8m53k8uJjijy5vOclFvsU1UvaabkpuB1hoh1p5Z
 Wnv7Zsal48Y+sMaoJKEyo1hDjd+VlTQace7n5/IJZgdoU5FEgGmmXa2zKnrQ/tDPRx283coLSUU
 lGKtbaHxEV2Z1IADZGGpph1apT0+VsmsCqUEZaNHEpcmRcWZjZEIJtuqCaf76dytQn07tbB/NFQ
 hE+CCAdboPa7kIzhv/WDJQ0Y6iwI3U//kh+SlrPQ=
X-Proofpoint-ORIG-GUID: eCyRyhegSOEq291xrRiAP5qQHizk0MU9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA2MiBTYWx0ZWRfX1vD0qUeGQ1Nx
 vIbcUxWTCca2rklO0BTGI6J8BcM9odvsflyg/5hVZ0yn2JYN+/xloFjFoxQyEeg02pyrS3+lMJY
 5R5ES9uI19iOuQWGvLGABMEonFPn4QyAcdM6qm0oO3J6xN0CnkqX

Hi Greg/Sasha,

On 18/11/26 8:19 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Gregory Price <gourry@gourry.net>
> 
> [ Upstream commit 05f64f211a25f7d9771d4fde109aad97174a1cf3 ]
> 
> Changing registration from MISSING|WP to WP returns success but leaves
> MISSING enabled. The no-op check sees that WP is already set and skips
> the update, so later accesses to missing pages still wait for userspace.
> 
> Skip the update only when the current and requested UFFD modes match
> exactly.
> 
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> [ david: apply fixup from Lorenzo ]
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Link: https://patch.msgid.link/20261031-fixes_core-v3-26-d6437171ecc3@kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> [ sashal: replaced vma_flags_t helpers with a direct vm_flags bitmask comparison ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/userfaultfd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index ea7e9db135eb4..1c4b0cb54d878 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1435,7 +1435,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>   		 * userfaultfd and with the right tracking mode too.
>   		 */
>   		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
> -		    (vma->vm_flags & vm_flags) == vm_flags)
> +		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)



I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, dbae3f96c87e allows MISSING|WP to be re-registered as
MISSING without clearing protected PTEs. Re-registering WP later can
reactivate that stale protection.

In fs/userfaultfd.c, userfaultfd_register() now skips only an exact
match, then replaces the registration flags:

     if (vma->vm_userfaultfd_ctx.ctx == ctx &&
         (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
         goto skip;
     /* ... */
     new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;

Upstream (05f64f211a25) rejects removal of a write-protection mode
before changing those flags:

     if (cur->vm_userfaultfd_ctx.ctx == ctx &&
         cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
         goto out_unlock;

The 5.15 parent skipped this transition. The backport now clears the
VMA's WP mode while leaving protected PTEs behind.

Maybe we should this prerequisite commit. Upstream
added that guard in 6eab8f2cc646 ("userfaultfd: add
UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing") or drop this ?

Thanks,
Harshit

>   			goto skip;
>   
>   		if (vma->vm_start > start)

