Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2DA147C90
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391793; cv=fail; b=ZqI3NKzoUYDnQD174XXQxCVX29gwS862YxbQPELms8IEK6ChlovugcIosgw57Z040v6gGKycYyhb865abRSg1B17z8TIMrXUHxcEPIzF1688SV08BplNCSnFUG+Knzhk+5rSAZs4KC8chzmiCm0Kdu3AU7O5CfptuisChEKUbIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391793; c=relaxed/simple;
	bh=3qwwdScZJpTE3XHkd7s/5jEku8KYgSHB2E7JAS1Qrtw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DlJBHB69kvHCzhdTDJmiNt0SAP1mur2DI0QsvJWjNKEWSe5VZHkq4+Dc1G/rz4DAUZWcrP0+8flUALy/7qsytwZyNscntj4vKX7JAXiygYjhbNjEBhatMbo/4R9J/aOWKatvSMOnSyQRZ63X43u5dAjlfhSr+E3A5uz17FsVkFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PRJh5lPJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yg5SPtYD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PRJh5lPJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yg5SPtYD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45EDHAI7022685;
	Fri, 14 Jun 2024 19:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=vykq2Ip4KPtbylqZgsrdEzGwyCt1k1eTS/Unm44YdbA=; b=
	PRJh5lPJONfscagSL+WVXPahmr+7AAt0CUmsOrEGLW1sroYCpdVbzgUCkaRxFSv0
	jcIV5g4COdyeuMomduFPfmtrbqxkzNkveFfbkqa5K4TUe7A88wRs6kPl5TF13DJW
	VGQY2mLvfYuZ8lQtDsWVJBjNRcE+4u5aho75JBC1eSAFKiP05R0uYU4aC9NMDyPi
	rqFlwE3lrmQqFtX0doz7cWUocmoRx35ZLNh3cj61on5aclnHLFNASxE6faj9M1Qf
	I6ZiHZgVTapCUKJzqXMkb8hHJQkINZnUpwvsKC1ttkr42W++dpFKz175o56BMY1J
	DQLT5dWoo2rlpQS9loGdWw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7fv6d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 19:02:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45EI5x1h027051;
	Fri, 14 Jun 2024 19:02:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdy2rg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 19:02:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjyxTbALOFvUmEb6BlAyllrjC1temLDZ8GrO/CPLeZxOFBDiJDF6ggf/wP1W9hVfDRm9zocU0f5ghmpLdSVL2XbPsxLsckvZ7OX0YewfsYt8uxX28BfTzU5wfEQnBW5CmdVZq3S/WRSIIyLSk6Vd5YrGr1AN4iOdbid7+c22aGd3t+UaOkuuhsRzRnVBMHSincpiv63zpxs+gQ0qxemtc8yu2kztug1AydKt402QPUKGRMQz4iADYdXTULHZS/MrB5yFr+NnnsORfHWIOUfVA8wTsDBC27iovJpMUbn/OuRRFdBJWm90yunxcEurRtJsrnTcPKmPQwavGr+HyFdtEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vykq2Ip4KPtbylqZgsrdEzGwyCt1k1eTS/Unm44YdbA=;
 b=H2F3suHucI58/PPDuoiHk125u1CtPZKRMPCgclBY0BPvxcOjImv4YixQqpdJ0Qm0oKsYcHZ5M+0Gl3mLDB+VV86LT3lV/N5pxF4UYLTJ82dYPLAXlBJ00zwEp0s5T0EF1V6fnlEiJPE2HLJKwVj6hnXGpHstufT3cmPgB6IHRZhoNGIlogMtvvambDwH2N1mqvtA73QK//85Qi5rWvSWA2GOnUUaNvfIgrhFvK1DXkK+Nft4Of97NGcmV3pIz7nVcV/Ube2IC59REAI3KcSy/SD4n1MfSnDW2mgOuePCtZ2OgqHqQkDz+IuYcOfNT0GYytik0+w42kQYTCGfpg3DXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vykq2Ip4KPtbylqZgsrdEzGwyCt1k1eTS/Unm44YdbA=;
 b=yg5SPtYDK+BvASK5MuyjX1bePEgcCx5wOWEUIllIKGU7fgjx2kfU3hJncU0z9y1TzN2O2GKt9WY+HZc0A/t2ogq0qGUzbjEiZ/bU+EsXCHNJ8UsN95Gtok48e9j4xiQYqvYxMnKoqdXr7yatGUEuxl4Io+fzvbvclArnwSq52HQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB5174.namprd10.prod.outlook.com (2603:10b6:408:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.26; Fri, 14 Jun
 2024 19:02:55 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 19:02:54 +0000
Message-ID: <86aec636-fec1-44b0-8517-9e26240d90e6@oracle.com>
Date: Sat, 15 Jun 2024 00:32:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240613113227.969123070@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::22) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: 11080025-1fea-4ba1-b3ce-08dc8ca49865
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?M2dSQXNGRklNRnI4Q0tBNG1PNktJRjY3clV1Tll1NjYrOXpabHBsbmVHNndV?=
 =?utf-8?B?aTJRdTRIc012d1k0eEtiZ2dxZ0xESXdCZ3ZVTmxrOWQxTDhhMkhPK2J2MnVT?=
 =?utf-8?B?TkM0NTFkTXdmRWZDMjBNOG51dFlsbkVwNlRreFRabmJNMU90bVpRQ1hUQTJu?=
 =?utf-8?B?clovaGVLV2tWaXFCNUo3UDBTakNXK1RSOW9kZnh3MldKL1N0Y2FPSE8yVml5?=
 =?utf-8?B?NGJpOVM1V1I3QmR2OVN4WmZVYzEreEJRMkM0eVQvdUlYU1ZEZmE3UzZPd1Zx?=
 =?utf-8?B?dElPZGRXdm5pTVFJekVHeFo1aklBQnhkMVNHdjhSZ3JoVEN2Y3hVb3BRYm5w?=
 =?utf-8?B?UTZWd0lYTHRzR0ZXTTg2MmtzaFpPTGJqclBHQTVTckpwZndCeHlXUWsvU1VE?=
 =?utf-8?B?M3pvYnU3Z3l0SnNNcE9qOUVZOVUxNUtDS2RrZitLalBaRzBubXVXRHQrRno3?=
 =?utf-8?B?aE5CdzBQeVd4WUpuZEtkK3g3VGRJT2VTV1BCaUgzSEJCQkFMMHorK1pMdGRZ?=
 =?utf-8?B?K29ZRnZlMWEycm5kTW1aMWVjSlN6OE5MNlRUcXFSR0o1OEtVM1BtdHRsd2M1?=
 =?utf-8?B?ZnkxYWxQcnNxamJkRzRZQkc3U3ZJRXFDOG02ZVZtUnQwWFlKejd1OFFxTk5I?=
 =?utf-8?B?dWN4SjFGeTJBcGt3SVpRN09jSzQ1WVY3T3prdllkc2RXRG5VTTJaYUpCakFs?=
 =?utf-8?B?cFFMenFnd2ZHb2NNd20yNjR1QmJ3VXcrTXJIZkZmRGx1M3hzY2ZxanlEZUVQ?=
 =?utf-8?B?YXZYTERzaVpLaVRkZG0xYzY1UGdZOS9GcElrcHlmR2ZzZkFNYnpsb1pkZ0lI?=
 =?utf-8?B?aWFxNEFrMTFLQTlEUXJXaEgzT0FXM3dnNlRWNFJFNENIMGJVV2ZwMGU4K25x?=
 =?utf-8?B?ekRqZDRvZjB4Z1A5dEErZVM3TEpFNU15RFkwbnovRHRSU2w4VXBzZG5HM0RC?=
 =?utf-8?B?NnVvWXkwQ0NzTExCSk9wenFXR09sMlB3ZjVEWGxzVXhiR3Z1N1ZJK3l4bzJK?=
 =?utf-8?B?N3NoQml2K0V1aVVGZzNJZHhOR3kvenRCa0NFL3FvWUhIc3VaVFFDUTc1VENx?=
 =?utf-8?B?aWMrakhiQ0dXTmhubW5wNjFFaUM1K0x0OGQweW1nQzJpYXVOc01kWFJCNXVR?=
 =?utf-8?B?b0RPTXlac3RxcGpKdlhWM2pjTUUzb3hveVJtSE5DclByQnJIZmhvc2UzUFZk?=
 =?utf-8?B?QStsMWdzeHlwVC9EUnc4RGI0VEJZRnRHS0xJYkZ6OWRFLzhuUXBmbjdnLzMr?=
 =?utf-8?B?T043cTJWZ1J2Mk9FMU5zcEdOUXFZT2YxZmZrQ1hOSWRMLzAwZjJzZGVoSkZR?=
 =?utf-8?B?SmxCMVh2Mis3YkJEVjF1UU9xUFY2YlFENGFZbGxWcnVULzBkUE5QUkUzS0da?=
 =?utf-8?B?Q2l2Snk5RWtiQktvK3JmbDg2T0lRNmVwUXdpVW13MGh6cmpPV0JETjdhODd1?=
 =?utf-8?B?a2sveDZDeFRLSHVENHBFb2hVS1F2M1JYeFJKSHdueDlJZm1uS0JTL3QyZlZw?=
 =?utf-8?B?RFhVMWYwTm00Q0tjVzlYWnM5UEdzTHZQV2M3a0JoZ2RTSHlPSWsvYlppT29O?=
 =?utf-8?B?WjZJWnBZaFVVdUlSazhIUTh4MGdscHJsKzAvS0ozNXFHRWpTdVI3YmdoTytU?=
 =?utf-8?B?K0FtRkFXakZXWHRqQTNoSlpSRlRpRDV3WENhMmZhVzBqUDREV09ZTWx0M0ZH?=
 =?utf-8?Q?2GKyVUffu9SEn46vnxc4?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TVZnbkN5WTB5WUZCdFFYM1RyTU1EZVhNd1dOeTFLQ0FralZISWxyTjJBVWR4?=
 =?utf-8?B?K242SFNtMU4vWVl5bGg3ZHdZYWtZZklnMVkwRHQwaEh6bWwra3U1ZmJRNzFS?=
 =?utf-8?B?VjMzNHJ5c25IbHBoUlh1YzJmSFdtS1Ayek5nK2ZxSGwwNFFjT2EzTDI4ZWxN?=
 =?utf-8?B?Qkl5Ri9ZOEc2eVpWZzVqeHBvQ3pBWVErWjBFLzhtQmVYSXY5NWxBYUhvWFd0?=
 =?utf-8?B?L3JIVGM4dDNWb1FUNllXRjNrZkZQbFpXcHhzRFAzWVBPR2w3dHJhdW5ROVZu?=
 =?utf-8?B?ZW1vUUVxMU1sZFpWRHFjeklBS3BTNDMySXdvNmhBMzRmK2xMTzJWM3hmUFNs?=
 =?utf-8?B?dFZHUXl6MUZUc0t2czJTa1JCVU9XaEc4MUFFaVF1WW9jei9waGtBNXExb3gz?=
 =?utf-8?B?cU1sbXMxYUI2SHlyWGRvS1pGUEhYMEJlMjZmT1FidWJxRXpZU0VBb2Q0blNI?=
 =?utf-8?B?YjVuN2ZyWXNhYUtWQ1FzSnpHWEk2S1RwV0c3VFp5T3JXa1BEdzhxNGk1Z0dI?=
 =?utf-8?B?SFovWU9FNHhqQ0NldFgxMGlwRCtXelNNMzE3SVlPaERCWC9kMlhieVdNZEtq?=
 =?utf-8?B?aC9scW5nRzZSakNLT0JxMTRNeUpyNDFTOENUZERTb216SElKdnR5aG43UU9I?=
 =?utf-8?B?SnlqZEJlckJ3QWpIMy96T3cwVTVIRDNPalJxS09VUTFlSWp6dkpzS1d3SWNB?=
 =?utf-8?B?VE9wUTluMGhSTUhwNldrMTBDUUh0RlU3OU43ZGxacVNKRnRyUmNiZkJZMWUv?=
 =?utf-8?B?Um5IOS9FUTRYbHQzYTA2TEI1ald1a25Yb0ZuejZvSkxWTnZTS3MyVHpxc0RP?=
 =?utf-8?B?bEhaOC9pRW5mTGJHSlptd1ZsLzc3Njl1RG1vT1JQOCsrUGtlR0lRZUIwTFhp?=
 =?utf-8?B?QWlXd3kzSGZtSnBIS2N1WVg3Mi85Yi9mL0JTQllIeFlZdFJsdCtWSlhlVzd6?=
 =?utf-8?B?cVI4eS96MExHbWpvci9aNnJEV0prNUhQRTJ5aytaTjRIWDJNb3hTV2V6TytF?=
 =?utf-8?B?SVJKak1nK0w3K2UrUE94T2ZWNXlDdTVFR3h2VFducFhCY0drUnZVWjJJdUl3?=
 =?utf-8?B?VDZORFJRR05aV3R5ZjJjRlRoSGFzd0E0UWQrc1dFNHd1Z1VVNG1rSWwySmho?=
 =?utf-8?B?VnNEcUk0MTJDVjhqRC9OTVpBQjlZaXJwK041c2ZnR1U2MjdCZFJCRkEzQ2Ji?=
 =?utf-8?B?bWdFSmhuTHZIZ3Z1bXN1SmgrNy9pVjZiRFlTNDhxcnpVRUlYR1RxN3pONklM?=
 =?utf-8?B?QkgvbHJydGtzRS9GMnFZRWhsRTFnV045Tm1rOFNMbGFXT0NoSkdRaUhlaU1n?=
 =?utf-8?B?MDdmKzdXV1NMaGFYMVR2NUNDRDlIMzFwN1Y3bGtFUVRWYjZjbngvMklRcHhx?=
 =?utf-8?B?R0hRamlYYUF6dHl1dXVDUzd3SU9PTkNpeHg0ZUtobXphRkdWUzR2YlR5TEFR?=
 =?utf-8?B?N0FtbE5SemdiemEvSHR1SHhKTkJlaE9RbXYzQzZoVnFKT3lacEUxUUNBbUxm?=
 =?utf-8?B?M2hHalpxa09Rd3ErOGI2UEEzdVIzVUlPTmJqaENja0psRmVLWmpWcXMrVWdO?=
 =?utf-8?B?SENNSnVaN2liSXJsMFlvbjZKUFN3aTlibStGZUJ4M3R0V1M5Q1lDVm5jcGRB?=
 =?utf-8?B?QUtYZ1RDQzd5YjYwOFNYYlp2UnBYVlRCZGJFNFFOazJDYkREUDFIQXVoVkMx?=
 =?utf-8?B?Ukk0aUhleFZpMzhDQUIrV0xRU1QwTGVTRHVFVVQ4VU9xNmQveWYxeTJack1C?=
 =?utf-8?B?Yzg3MWZmZ204NmtnZnVPbXk3UkFRWjF6QVM2bnFhajkzbUZtaE54cGpCTmlB?=
 =?utf-8?B?QzM4VU1VL1AxSHRmUHpURDRTVm9rc1lTcXY0NnovQVp6QXZraU42RHNZQVRx?=
 =?utf-8?B?b3JkQUgwSXNRbEVjKzhMRFgwdzJLVXgvaEd0dWtWUVBtdlN3TTFsYUxjTkU3?=
 =?utf-8?B?enA3OVB0aUVNcVlHV1lMRTcvN1kxOFR3OHZIWmxVUk1MQTZkZDlHeTIyVUlW?=
 =?utf-8?B?MUhXNk1ad1EyZVJVclVoZmlSemprVDRDS2ZRbnBRM1hlYnhVR2dpQzBXQllK?=
 =?utf-8?B?ZWdra2xwdXNsY0E3V29HY0kzZmt2djkwaHl1dmplYk5WV0gvMUpvazNvMnpi?=
 =?utf-8?B?THlMZk1Mb1p5bnVwbWx5OEtrM1NLWVBhZ1AzdlhWMDZMSnhEOWUrenZIamRj?=
 =?utf-8?Q?OPV8CBrI7f35+oKylhQQXTM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	X4Oj6xH+IJOePJS7ztYoh43xHBI9uhKIGHifureIz4BWFd1+NJgxm+nODlXDxA6CtOo6kEQf9WcZyk0xquz0pJli0ZMZPjzn7ZGRZEUyejRxYD8/7Ef4WK7wpWx75NQ39pSaKbVTnXVAvIqwteu9juiW9QQD8GaTcdM75LErxs35IoZGtFLMk82m3Abu3z2pHvcbC8q73m5Eu4k1p1YY7ZoUSZs2w+dyNAGHWIf9dfCsQeuWztP4KcfUxCao3hpAGVN3Uk5wkc4iIJ+ZNnokZ9UwTtgL22BAX8pQAwfOFit1aABEhdlgtAkzGKz3UEy287JhhMkAxHvubjDp91HDmsqK57cBLKwlGh1rmBVxst3qtHgxCSDoImDy+DaQQPpTREkGuK9DoZLudzA5vp59zAnmtd3azq4yVdh3yd7N+MWSfuZEioBCHrfH3LEDhGIg8zrT8tTOPgkmoYHJoG0sZ5bEH5OmUbU95nhOEM9ct4qHI+lmkW8o6iKsEBqBe8aHOTtbRl2kbyDb0e5n62rZSMGl85JKgTdfiuHCawVkDC2xcCrCGSv0hGdNcO8z4qGNA3IMzl5w17ermppTRRGB3e50Zqxtx5eK3F93Ov2DNi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11080025-1fea-4ba1-b3ce-08dc8ca49865
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 19:02:54.2384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JUJwTu0tO+Sa3avZVMI4oz/qPJjgSgbZDOq8nw2DeY0YpjIij/l6Fag1l6i221dNuYNYlclZZfpvvOcYmmJh6EpCF8MbZIXhDdWeeE5IghzuNoPLnbJeqM0y8kks5AA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5174
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-14_15,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140131
X-Proofpoint-GUID: d_lSTVjPIEhY5dmQsDijH0oiseJnA_-9
X-Proofpoint-ORIG-GUID: d_lSTVjPIEhY5dmQsDijH0oiseJnA_-9

On 13/06/24 17:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.316 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Hi Greg,


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
