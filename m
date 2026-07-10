Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532403112A5;
	Fri, 10 Jul 2026 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783685182; cv=fail; b=BaRukn1W0N4DcVSCCtG+5fSkCwH5tOq22je8JGBdMNEM2gBl12Vlofi3agA17BeJcvMb9JZXGeOHwAFpFXLf9IOGGon0BoQee2yxzdNO96Xt5tFFVUrsB6ekfu9aeQM4osktVPnKwheTDgJggQUdYZXa4GX3BW+92UOj7wqq6qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783685182; c=relaxed/simple;
	bh=YXKOYYSWMaIFx16Ll8sTuO9X2e0EHNWTwtAoDPWOyTM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mdU2WoeONcRjb831gW1f96np0FioSt9HxURQdDuCDQLKwbsHeCam3jBHe8toCHrVGy2HpI0LhkAvEdhvMdZhwA8bF4AYn4Gxt2huZ+bsquR6ufUcaydZnkEpQ4A9z7GUwizlhZdFYzJV2jdG9RRmfawnVPJi7aRVKhS2Qs8pIeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uz4DGNSH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=umOlA+6s; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uz4DGNSH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="umOlA+6s"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66A4UnTU1699869;
	Fri, 10 Jul 2026 12:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2AOOuIhScRWQTJCQRKdqkxs88rm0Lmo64v/ik6BmAqY=; b=
	Uz4DGNSH6qFhZfj6+ZI9wPLMFx1dKg8DGyMBzrGwWeugNzqaH0N/BxRhCiyeRJlF
	D2xgxW/1gslPQHYGT86TARhMdq3GCsJpKNH58IcPsaIxHL2WGSNrnAtr2r3w4VKP
	REt+bYorkgV/Pl06yS19xCU5MV3BqkMkrPz2fDveT05GaAVKo134niJwo2iMwdSu
	kRKxvh5xOAvbAyafNyBnt7dAkBgH8VpUBFsEI4M5sHGFEhZWVQ7O/aAfvY2A/Pp9
	MgfKZEDyKod46VCACLffU6C3HWselXRSdAp4A7yigo1dAdu7XOPk9HTthpZXBzBy
	9PtIQN4y10gdxpiDe+opuA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rs1k8rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jul 2026 12:06:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66AC3XRJ036019;
	Fri, 10 Jul 2026 12:06:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013061.outbound.protection.outlook.com [40.93.196.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmu0uxd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jul 2026 12:06:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBtI7JgojzOTFXpd63C8Bnk5o78L2Qom3MyH24wNgGy9uD0sO/ndboVwWYwY9VC5OT3zyH8O8kIn5zcANVJzHURvKMsrBLqfhDJqlBZeQU67h9ADurBORYCeEJdsal9Xy2YIm5o2EtSh/qCQ+lPpO4HJobHCf84pzki8cpnUqh60i6HQx1AiTLs1YyV5oyAcT9I1KCQzSdmRDd0QppPkWzufNjRg9xRw6Hx2dZsUc1LrbzJemgseerwiW0N9rHv5hEDKfbwZWG5FsRqn4rjVFizJ9q7ITaocjfuInc9s1Z1dFlbq8JmHPht+O9u3pP8pMq35nn/zXhzGy2j7Z2C5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AOOuIhScRWQTJCQRKdqkxs88rm0Lmo64v/ik6BmAqY=;
 b=b2SKQZfyVnx29qfhNhUuLCPm4pMZMXK3wDw8tsQX5EwkS7JsKNwkMCgfWJPHKm+RhSolcq0xr0XFPQWkrkNf3A33G5VS8eo8Zgf/3hQMcsoua0bqVVQCoVOkvAhmtNZlwdl6T+zlkz0Ua7B1dks1fCqYDDCgr0ZNrvpAo4RTDtSlkscsJk5csqwNRkB7/QPQm0YghIFK1pV0kOTUoxCGVZYjh/Tr+Kk4k9ddea8cOgDJu21dCYJUpkhJ5wSBChwjKp3j25Wf1iTpbAm6INs+ZtDmRNUPozQJt2ZFdi0n7qll+/ngPMBgwhtYoUCAGqdggQXgkt35fBhXVg2XQ7CVPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AOOuIhScRWQTJCQRKdqkxs88rm0Lmo64v/ik6BmAqY=;
 b=umOlA+6sQhO27pAw76v3a9J8aE8yOmiFqCgu1Q0nOwxhr+cgN9rWUhiDocVXoXt/ZkvEUQvfitimZeC+Vbuu1Jh8txAzZXa4KpHkJas72laAeLhlPNWYV9BFzsFJAhc2q1gUXd53nxptsXYBJfczCYeCjUB7xiWF4We35mXE4yc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LVWPR10MB997837.namprd10.prod.outlook.com (2603:10b6:408:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 10 Jul
 2026 12:06:14 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0159.018; Fri, 10 Jul 2026
 12:06:14 +0000
Message-ID: <3bbb428b-b137-4d21-885e-786ed5d76bc5@oracle.com>
Date: Fri, 10 Jul 2026 17:36:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 187/204] nfsd: check get_user() return when reading
 princhashlen
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        =?UTF-8?Q?Dominik_Wo=C5=BAniak?= <stalion@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
References: <20260702155118.667618796@linuxfoundation.org>
 <20260702155122.580017616@linuxfoundation.org>
 <17cce379-76ca-49fd-91e7-1a486de62d2a@oracle.com>
 <2026071043-dicing-arousal-ae51@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2026071043-dicing-arousal-ae51@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LVWPR10MB997837:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd41448-635b-4d1c-5615-08dede7ba37e
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|4143699003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
 wROukt1NCT1V8Hbsh9vSeSI6eTOn/FASfI6uEKwTM1TVElqjyJcaJ5ojaCnGUUQow+H2t2rrf1Qm9/08cnCJaLoO7lqnrvl/Gfq6j3SJvKKkt87CSjrOm0RQpwSk4arAe9xCZ+MoWQ80bYYFv69D5rDXIsWEWifYDLEqJBDUNdAh+/lKwVWprL4s8++j/muwYgvPh5UCLH788RgMd5PdYdZ2/GeTJs4B4jJwZeLildbzZK+puXHGlEJAys4YukFDEesYP2HI3pJuNAFEADyJDKlfLTdAMSuMqExwJW9GtOCFeilSaKtCziJ3qDQOQO3aQp9P1LSXv9vUxzlV30Y5dqamBkWL5MVd9MS+wFlLoXy7b5aOJb3tvhKkC0glO3g6zvujFPtMHPKSkZgN6CrsUHFB5RcM9negDuYCJvlCrwmsL3YKaSj5ZrXBw8YsZMQWC28Hayfe9CmMB95efO8WZvNHT+rBVyOjtinvoCXWaiGHhfoXScVrLBFdV02Z/RtmzrL2cqZiOLCiMFZSE3OzrsTkKXLeli35uUlfuWs4Isbw2fy1DjoAt5FqTHK2vsVGwuLGSj7nT2D4w1U3xuh90EPrwV+ngvSWBx07jFoRNgYzY73k7iePvuFFmjg2ab67rff4H7RVq4Bkq7Ff+OZEdImSINqOVzKR7Slte3OST5k=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(4143699003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dGJmYm9LeWZ6cjBXVkdVcWRJZ2YvUGxtUllaTzJmOWhsNXpGbHVLaVBXRkRu?=
 =?utf-8?B?dmhKOWkrb0RKRHBlanhVVTl6RWlDOW01YVo5RFR0aHBFT0J4OXdMMlVmbDFP?=
 =?utf-8?B?VGl4MkFSZzZLS0VkZWxhUVJuVXhsaVdFSjRINXRvYXBXcDZLVnQwWjlHY28y?=
 =?utf-8?B?SDFpY3UyakNLbDhUYVVKanlGQ1JPMW4zTTNLdEJ4Z2syY0k1V3k1RklMWFQ3?=
 =?utf-8?B?ZG84TmFHdTR3VDdJdjlrdlNVR3FRRnorNFZrSU1xVGplNkRsVklUdmJUODhr?=
 =?utf-8?B?bDZjTFlMMFJRNHhUeXBHejh1eWwzYVVHTG5BQWsvQjhvWUdCMjc5aDZkNlhC?=
 =?utf-8?B?azMxekhlMGVMU0JzZG0rYTdIbjdPcGE2NnZMcS93QUlnNytuWmFXRnFWUGMz?=
 =?utf-8?B?SEhYc2c5aExMS1JsQjlkQW83QkYyVmpIaXFzUzlOMDVTc2p5NE9TcUp2YVVk?=
 =?utf-8?B?QVNZNEFCbEcza0daem1ZLzU2a0d1WE9ZYkh4ei9Ra1JoOFg0WlJ0b0xqQ3V4?=
 =?utf-8?B?ZFlJQm16dXFCclpWa2hjYjdLY1FvWnVyWW1seGpjVm0wT1dmMk5CUkRMVjdo?=
 =?utf-8?B?R2JkdDVyQ2sxZGxRcFE3M05VYXZaRENCWno4YnNuVk9jQlBRTHQ3ZHRoeHBo?=
 =?utf-8?B?Y1RIK3ExODUrQmZvODMwKzBHZW42a21ucVQ2M3ZqZWFmSnY4RHRuOFBTbWIv?=
 =?utf-8?B?QWVLU2VxSlNsR0NaUnlHa0lBQTBicGUwRkZsSHN0L05lMlVWLzNITGlmV3Vp?=
 =?utf-8?B?VDQ1NUlBaThiSzcrdkl3QUsvaHNKNVZBdjRlOEwwZFU5czdoSWhDYnAxQVlO?=
 =?utf-8?B?NVNmVmFiMWtjdGlYdG9GTVhJZkVGVGR4Uk03SVNrNG1qQjh3eWhVaFhVMmRu?=
 =?utf-8?B?SE95VDRIN3lhNElidmJ1OHVuMEU3OG9rbkwvSkZ0bnFMWXNrR21mQm9rMU9a?=
 =?utf-8?B?NHp2ZXRkaDY0UTAvVGNzeGd6WDY1ZVY3WUxQTUtMcjJ6amI2NTFjcFlEeWN6?=
 =?utf-8?B?bzRNWjlXb2ZncTBtcnJoZUZ1aUtXeDVjTWRjU0FnWU02ZDRaK3lad0l6K0FK?=
 =?utf-8?B?cHk3ak9TUnVVdWlWZEZvUVJxOENTY1RXUlRBOHhCWGtDOTNOQVlxZVljRDFU?=
 =?utf-8?B?azdpYTRKZW5tODdHRHNxbWluRzNiaDYwMkhCMmltZ09wQk11VnVjaE50Nk1X?=
 =?utf-8?B?ay9VQjQyNm9jU1pWenJhc3YycHVvSGEwbSt3aS9xQ3gxQ2hPcjZaVGJ2TnYz?=
 =?utf-8?B?Mnp1K2NVK3Vta2JRQ2VLYm9vMHdGUHprUnVjMGFjUjhoTFZadDhTaFpySFli?=
 =?utf-8?B?RTdGZmhhSGFDUkVLT0gvNnVUS3lMRWRzcVFLVnFlVzdGaS9DZFNVV1JTWldC?=
 =?utf-8?B?UGZraE9xVC8zRWE0VEk1L1J3b3dVTklrR1paem1rUm1zZVVncFZvcE50RmZp?=
 =?utf-8?B?bUhTRTlOeFRmdTJMK3hxbndPdExTNm9SWWpXL2VaaEdoTGRzZlFHdVQvKzF1?=
 =?utf-8?B?Zjk3cC9mRFJjZnM2RnVlQXhHYlNDZnZXdXh6Y0VRRVpGTHRKRkNtWlBReXVH?=
 =?utf-8?B?b0tEQUdsb051WmF5em9DWFRUL0Fmb25HU3hMZ2pwQkM4UkpieUl1dXVXR2tr?=
 =?utf-8?B?UlRRMUdFc0FKTjJnZmZEQzNtd0lrdXVzb0pMN3JPTE5aeVlmTy9va0hFZWtm?=
 =?utf-8?B?dlZaRUROMEdubGVGRnhCYTJsUXlENUZLNGNrTmJ5aGdLSGJjZXVVdDVhcCsr?=
 =?utf-8?B?OWwrQ1ZlcFpZWkR2M1lBZW9yaTQyY04vdlJzaktVZnJQM0FTV0xHUXoxMlUr?=
 =?utf-8?B?WnV5Smk4NmpSMlc1MTRkVE0rempZanM0MjRRV1ZVY1M1UzZjZ1F4dW92ZFNZ?=
 =?utf-8?B?emRaUVhrNzhWNkc3SlFsOUNzZjdndlpnV3g1dlpLRTcvNGlEb1lOWEE3d0l0?=
 =?utf-8?B?SUx5cDV0UGIxZVhJM2Q0ZHY3bnZzWmN4djU1TGJzL0loNytsTzJuU0JKZkRo?=
 =?utf-8?B?c3I5K0hYZTFsR1pGUDNWcWJJVElveTJCU3RlWkRSN2RrL1lSdWNiY294VnpD?=
 =?utf-8?B?ZGNuOVJiaDd1SnBoZjhLWTZUejhVMmRZWm9EZFduMHR0d053aTNkTTlvak1Q?=
 =?utf-8?B?VkNaQmUzNjlVR3UwNGxRL3RpMWVsb2N0dm5DbVJWZURqQkgrK3YycE9lYnk4?=
 =?utf-8?B?djF0Y082VW5VcWZFcU5JYW1wOE1CdXhTTFo4UE5nMXNSV1NwUUxyUlYxRUVi?=
 =?utf-8?B?NTFVMWRUd2Q2N2RJR1J3NVJONEhCRmcwS2xFV3BmcVU0c0k5eHFHRmRuVUxB?=
 =?utf-8?B?SE1NKzlJeHRRR1VWeUJjUUFXZFUyWGlrYXNkY2FZdkc1YnUyZ0hHQ2t1RTZD?=
 =?utf-8?Q?eZnRbWim5XbyquAzzg7tNp8ee0+AA2USCNc3H?=
X-Exchange-RoutingPolicyChecked:
	qUZjYwcdKXFqpn+UuUG+VO3GLWl2QujcMNTUfYajFuCSs+UKvkhVMfusWenWE3RWCjxnAsJRYaDxDa6F1zu/smGawOSp1/vAwNvsMxLu7Z+I4VDIRQurAJxzQWvab+kRc0y0GRpstWbOEy5Xke4uNYYRicUDCYi+vXWUiuUu28R+b0aGlf7Bv9UDNPylioQsU2xG6XWnSAqWRcK8g481dFp9QohApHCeSPBuvZdUP6EdmBWEAW5BiwY5rBVvVJO3m4OroG1Y7SkcFTwHmpwk93SUs0HhL80akvvFmeBfMoe2pbghF9gkc/X0w0JwVVtDBO8pJolGNQG1fLpScFaYQA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JGKiPNTIj/pk2OJvJjCpg070+KrNgHdfBIjVHnWnbpIvRInO0mNhyRmFnc/7vZ0pU0Dm1w21aBhVyhJSzpdOmZH2vwfPa894DCr7BJAvXbfutgoURcAqhL57SftTu8Tsu13n5KFoiLHVoxDpiNFlKFLCxRcBcDIOboZZCjpms+wxRu/w7ebvS+UZeZHkCyDxJXmFdmdFzqfNiNFrp1Zsj1NQLVu75vOwnv+IJSimyFV3G3MA/4sV0s7gM8Kauv+xeqKL7OjVPKCStegc57enf8FKbU2ZXQa9g9S3EAWvm3jp9BrhGhxIntgpdb+hnVXMa/V+2P01n5Adqy3jBUdvgcVyGDiFHKz3mcrGKJNk7Bn4biAarXm/4xFSGKTiahKdmtlZas6P+qc7ROfriCBfkzVjBOOEBwoDmT5+BUtDh84xqvQHXYSQZXX1/0tFstrWMDZveXiTRe/BEchVIiSvbxfHHfU36Qj9FcY7UCr1hGks2n9LRXt8BauRg6sM+PUFtQB+bQFv1xILf2Dg9bjn0274sv/bn9mbsZWAu57SvMSIJDc2WBlj8sXsfGMoH1mpUexWeDF5OgXfktcTzEGdWumMtR777e/jaMRDLQV048M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd41448-635b-4d1c-5615-08dede7ba37e
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 12:06:13.9615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xcg4oc041NzK8D/qfwIrI70lp1Cp1pm7DRdA6/pq6jbtaBhWB02CSTOtlQzuwFgYGaUzwh8zaEwl+MTCd1uLokGpI4/5sCuA0LRQYB0CF/Ua7fvgeQzz62nO4gyEpj1M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR10MB997837
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-10_03,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxlogscore=933 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607100120
X-Proofpoint-ORIG-GUID: G_hraH9P9fVlQJW53TnDd56Fd6zkB4gf
X-Proofpoint-GUID: G_hraH9P9fVlQJW53TnDd56Fd6zkB4gf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDEyMCBTYWx0ZWRfX/6/2jPpegdDC
 K0ULuOEbgxv47imSxvu+xqrOk8bDIGuIadqv5+RorynogR3wqd7j8rJHY3Npy1db4azPWTiy85p
 wY1OpVykvvM8Hj3kcjvtz/5PmTx13386R0ut7Al6YDBoYT50THLDvqC2P6Qy/5XrFonyjA8018C
 K5C2mz/XGNsXw4SzfN1YXu9DEB91V+3le05YBxDf7hXJZsKOrJWeUZOhg6dIIjGtIyHqWLDVKSi
 7evyy1nYh1DTRXjf0BqsiSIuieuqvvdblWO3BWgOkZZ8nEFoE9iLhjbVnSmUwf2h8ekBLk/ZJ97
 x2v85WmX54+O0gLTNpjt/Q5+gjULFdVGnQaYD5ZwU3Hol5KW7huAzLQXTL0LH9HQ90HWOjOTVF1
 8QBTXW42JmuaBrIwzj0HhSdf1/w8M0y5mwxbJpKw7JPYRNYry5pSyDPYQ4LXUsbDlroZ6VFPXGc
 v1tPUdJrOAHhQsFOFEDEPa1GDGevCh04hNV8ltzI=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDEyMCBTYWx0ZWRfX03cqKGDLFS3o
 pXyF5A4UW/m7SxtOjpz4tdyMy9X4vco58rzJ24kvjQgDL7SP7029JCbdq5ClaI/R7RchnQla5NJ
 HBpvW9nuE1gB4cRlc2H8L3uptxsYR72uMFzs1bkeO/GJuY4U0l7p
X-Authority-Analysis: v=2.4 cv=Vu0Txe2n c=1 sm=1 tr=0 ts=6a50e03b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=jwSYmOFqAnUeuRxUDrUA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222

Hi Greg,

On 10/07/26 5:19 pm, Greg Kroah-Hartman wrote:
>> Maybe we should fix this up with a downstream backport ? That looks like a
>> simple approach to me.
> Yes, that would be good, can you send a fix for it?
> 

thanks for checking. Will do.


Regards,
Harshit

> thanks,
> 
> greg k-h

