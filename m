Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D17217734
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836755; cv=fail; b=Z6WGyA33wOySYoowu5o4ZA7CEe1tT/FjywNHPMLYHxfmNo2RAovkNOE/tRPzFL2QjKp6d3GQ8w0lh/dKEyvNs4mYSLy3ZfQ0mQWsZ439zz9htDtAR6AiKJobj4Uh7ufpUNOeHZrvXnuvu0tnlxJZn6phAEBfSK/73UP1mOA9leE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836755; c=relaxed/simple;
	bh=CnScZlmIwx/F831I0eezhEy+bu7sLXX7l1VcD5wTCQU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iriEEqSPhqubSKkHv4PEUj+g9fgGTgkZB0oFZAVYDiKDDMtLUKCELNaeIDtuIFmshbfcqCkFYVSBpo9MJS6cCjHYYNT00mksAHDyIGwgCJj1pp+lrngWMZiqZdM2wDzpN7uaItMprS9tsNvOctcWX3BhYSAMOqR5pyZf7cKFRCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MY8lv5Fs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WlroihGF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MY8lv5Fs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WlroihGF"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55P7QbBd022020;
	Wed, 25 Jun 2025 07:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5YlEu+0kEiLLcwNEBL62lyJfB/Jj93uUTNZTF2xtt34=; b=
	MY8lv5FsK1UQ9bbkOFJ2te5TGSOl4VxnNx7f/Lz/1hRsK2PSEkSb5D/cmpy4AlYw
	GycNoFkA+vgCsz8i0xXO/KdvNyBM2Lhp3HEZbuHtrFXigcefTYnz1JlypGYVJOAv
	9Y4Qqs6SjXkqOg7hHOxua5vFqCCxySpN9+uWksmfJrBVGFDEtqF6dc4gi3T53g03
	B74fWTIP8w5Iwwc1yqzvQ5xgF3TH8KmM/Cg2Wpo0052gqGSdscYkCpfo0TtRp8m5
	uwOj8dWBXUCIPtGguyyOBSkQC/2+wOTqL+55kRn07/vUlQsu0UlZo5p7pMo8each
	kAUgSY9rHaHE8KvpzXeNxQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt5npu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 07:32:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55P79uI0038973;
	Wed, 25 Jun 2025 07:32:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehr5px16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 07:32:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bFDPUa/Qu2dSbtD8NcH5azBKMi6pcJVSZDYEYuPDRxpbbjSK2ztrKgcNrVxSHOCNlmw1ctccUHjrmtwt6fmMU2u2lzX3naXTK22L7ayGTOkQC5O3+SJfY5NfgsQN7LilQ6lgee1oNU9r2YW8Vy5t0vReoS3k0tU3R5ij244lZV2QbPBXONeuZvs5eeTajpKkeueJAZjPRBWN1GREY49ezDXjcCbRtadQb/ES4SknHID5d6SXRUgjzlETvYcIvO5/jjpOSYEAx3iyv10k/g8yGlqnMlu+DRtyWwz+Kr4q6i8YT38me976PKeXFyytsyPBu+t3cpn6uE+qu0sQCPBVVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YlEu+0kEiLLcwNEBL62lyJfB/Jj93uUTNZTF2xtt34=;
 b=LCzMUjuEu4ZrPvrk4VVHg03OcCI0qzrtzyaMDeYjRoliHGVAH2HFIrMCLX4RBcNojbfHo32fYU2EppPDlJi150qtZdm6+Xcvlds6+P/qGIEfZNjR33BrFle5ztEq2PzxTO3JydGVeLen50utG4MGyjeB/jwGAEPSMt21P8y0JVLIFXRgAyYWnBreu6Ex06dagXgsMZCKucG6VirFkcJgJvurVYQNV0t6fO7louslOUnGFa//+Y5IVpMHlyHXgtlgZRjz0L1KfD24KS97b95JSQjgKs2WpW4a9snktSYaXWOfrATtPujl9uwHptaKfWO5EKWLu2mItu+u9F1jTJWKoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YlEu+0kEiLLcwNEBL62lyJfB/Jj93uUTNZTF2xtt34=;
 b=WlroihGFdGgw48S8LKVZqrD9BTy9y3fT0903+we8YZKhaut4plnzJw/lvugL74+9a+0kVUZnDzd7oBVY2B+x9UMIID87y3dqqp/vKyHsnw2RsJJUedEGP/jIuC8zVvOrOLqB6A0N8ZNqtDdEjsgkOgEFdef6JDG5vy6zhoa8JhA=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SJ2PR10MB7581.namprd10.prod.outlook.com (2603:10b6:a03:546::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 07:32:17 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%6]) with mapi id 15.20.8857.020; Wed, 25 Jun 2025
 07:32:17 +0000
Message-ID: <bd299b1a-006f-448a-94de-8119921c688e@oracle.com>
Date: Wed, 25 Jun 2025 13:02:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250623130632.993849527@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::12) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SJ2PR10MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: 3344dae9-d131-4562-0524-08ddb3ba6908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUN2akpkQU5QRGp5bkE3bWNlc0E4SXFEcUZsTEtTSW12ZnZHcWtRbU5uVzNs?=
 =?utf-8?B?M3M3ZGZybDFpZnJOdlNXV3MyeU1PY29TME00cUM2RnVvbThCQUxoR1FEUHN1?=
 =?utf-8?B?R3lMQjNlcXFWT1hYNHFnQ1BkSGh3Q2dtOE84Q0NtUzh5bFlsc3NSVTdnb210?=
 =?utf-8?B?ay9qWms3Y0J2VUllTWpFTERGaWw3dU1IdmwzS01admViSWh3YloyNmJYZWNT?=
 =?utf-8?B?eE9PR3VSeVN1SDZGak5SYnJick1IdWtKOFI4MGh0TnlnL0lpVEFtTUt6dmlL?=
 =?utf-8?B?Nkl6YkRlTW9oTGxlZ25EdDNnd1hCRkRUdlpObytubU00ZVJ3cW5qV1A4VE02?=
 =?utf-8?B?S0V4djlOOHE1RDlnVzkyYm1Pa2NWY2Y4ZEJOL1RRR0FUQUVzZE5GNjdXdGFV?=
 =?utf-8?B?WUpGUW1RbHNzaGMzS2RiOVp3YzNNbGpBMjR2MzJyZTllS0c0WGxFWnRZdXZP?=
 =?utf-8?B?cG9tWGxDa2hrS2Z6MjZyajRCZnphOW1YQjVtNSt4eEJ2T1BUT3Q2MkhjaUl6?=
 =?utf-8?B?UHhuL2hPZnZ5ckFSQTVYa0JtbWxLRC9BR2JpR2hOdXBYUFlFcFlneitxQWdK?=
 =?utf-8?B?ellrRDRuMW53UEloOFNBWHFDb1UxRHJyMGdaMEoyMUNhMncxQ2lTSnBMZVRa?=
 =?utf-8?B?ZmhUbHRWOUdYSFRWK092WHZBc0dmVUZ3UHUzNHRiNTY4dGVGcjlQNkVZeHBF?=
 =?utf-8?B?SUpZb1FsNDJJclJLcjhTR2JOa0NBN29FRGZuY1lHSU9zVzh6T0hHSUlCYWZO?=
 =?utf-8?B?RitkT1Q1Qkg0ZDVhb0ZSdkxaUVZOME4xZGlWUGwxMGdUTk9xT0dhOW15TTNy?=
 =?utf-8?B?cUhRQnB2TVZ0WWF4Yk1SUFV3ZGhDeXJtcGkrUWZENTVIWWxJcVRwTVFZWktk?=
 =?utf-8?B?a2lyVWwvbXlpVVBSMExXYm9DZHhEVE9pQ0JtbTFkYlZMVE5SeW45NUdCa0VR?=
 =?utf-8?B?S3VhaXBuZkR1UUVFTzlsNzRUNU5SSXpOdHB0bUNxcHdkSkZWSlpiUXMxaTlE?=
 =?utf-8?B?Z0NHZ1JoNmUzdlplekQwa0p1ZGhOdTNSOHd6bUE2V29VbUtpdUE2ak9lMzZp?=
 =?utf-8?B?WHlWeHpwSjk5NUdmNDhWQnYyQTFXS1pEZFVZWkM0U0ZySit4Um1RM1haNGdR?=
 =?utf-8?B?eW9EVWppdGVoTXZFbkJTcFVNZ2RxbnZzdUNVcWRhaWo1bzRKaHBHenZhMFBk?=
 =?utf-8?B?eG5CdHBMWlVXaHI1N2xyMitzVDVzSURHUFhUQ0F2YURQdCtTRmFDelgxK1Ez?=
 =?utf-8?B?WGNERjgyKzdtUVFMV1FBakNLUkMxMHo0UDFoWUZzblNWSUtROFRkcDZOZU50?=
 =?utf-8?B?dXhSeGZEdmJjRzM0QzE4TDlvS041Ry9PMkt6d003OE1Yd0x2RUxtTEFUUW10?=
 =?utf-8?B?Wm52RXM0aGFDcitjaUhYaDJkWTcrL0duSVRwZE1DbE5SNDYrekFzays2MGNm?=
 =?utf-8?B?OXZjb2RLeVRZS01OcTlOR2xKWXFoQzVTWVUvdlByTVBYMVNJS1ZQZnZHRjNs?=
 =?utf-8?B?Q0tuUTFDTDBpeExjdEJORjdOamJlNkNwaVk4SVlDaTc3dDh2dkFLb0t1Um5F?=
 =?utf-8?B?Ni9JemdPTVVOdGFEVDc0YWtDSzY5a2k4MW41V1pQaHpyT3RDTWtIYWQ4NTR1?=
 =?utf-8?B?QVJsNjN5NzFlTGdvQ1lWVzl6YXdwcUZUdEJmN3BieVA3am9RQUhNMHRhdTdl?=
 =?utf-8?B?NDNPbmVrM3VPSXVyZ3JPanNlU2ltUG1HaFUrREhCeE93c0VBUVdEdE81Z2xq?=
 =?utf-8?B?T243M2Z6eW0yVUd2YWxUSHovdzN0eWZpQmZjR3ltU3IzZjU2VFFaQWsxa0V4?=
 =?utf-8?B?M1RMU1JNb29uSkU2VjVGWkxMWUQ5VmlNUEhiNUdoYzRZVTEvMzU2bGJJTUVr?=
 =?utf-8?B?ZmV0MzMvRlE0ZEtxU1JsS2xxMnJBQzFXZ0QzbDdrUVN4a0dvSE1YaENTRkhR?=
 =?utf-8?Q?c2pSevoA0H4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDN3WDNSa3NpalVJeUVjVlJiZExYeHJRTGo3YUVldHlScU1VQVVONklmQTN6?=
 =?utf-8?B?UE5LdVMzVnFaeWdsYjZEMUhGaGxWS0JTcVZMeWRJMGY2TjlHQmZmYlZ6Lytp?=
 =?utf-8?B?dDl0Nnd6REx5cUVjUlNCbUMra2NsMDhRWTRjdm55SGFWZlVyek52Tm93NER3?=
 =?utf-8?B?cXUxc0NiUUpZZlJkSVNxU3RpNnp3YmhmTUJyVnRNUjhGL09yRDN3L216ZGVJ?=
 =?utf-8?B?VVhKaEYyakNiQmp4UktGV3Y0WUlJZzA5TkZlbnJwNW1DZkE0L3gvalFYV0t6?=
 =?utf-8?B?TG43eXBhSFg2SVJkZUZkcVBvUStZQitaR3FkVEZ1NjV3bGE4N2RsaU5qcThj?=
 =?utf-8?B?bmxDZ3BwQ3FEOEF0Nk1FYU5WUHp2UGxPVzlPQzZrd2M2RmRxcXVqcytOQStv?=
 =?utf-8?B?dFhHczRkQ0JISUptd281ekZNdlhtMERLZ2Z2aVZ3ZlppS1EybnBSTXRMWTlw?=
 =?utf-8?B?dFpUbDN1TXpRYmQyVE1kMzNGdFhQTmozY01sOVlWVVkrZytta0x5TkU0TlFB?=
 =?utf-8?B?WnFadmhWRGlvQXd5eUJadjlsM21Ba3BEZHJmZHFudWpjbmpyMWh2Q3RtcHhP?=
 =?utf-8?B?T1J4S2Z4QzVHZ2tOOXlqdzBIc1h5ZERON0F1L1lUZGFkTzUyTzkxbnN3N1BN?=
 =?utf-8?B?RVpJOUgzKy9mTGExSTh1K3lNRGNhbmhpYVJZZGxxYk9SOERpQStOdXhaeWZO?=
 =?utf-8?B?cW03dU1NNDhZOE9tTm9CUGE4bVVOT0UxcGVMTXp4U3BGd1Jvb0tvWHNNZUhZ?=
 =?utf-8?B?WWUrODB2QmNHZjhjQSt4ZXAraDMzWHppL2hOVEcvY0ZsbmpkRE5sVU9VYkp6?=
 =?utf-8?B?eVU5aC9EYTZPVTJLQUVzZTFMR1Q0WEUxSFRBNmdCblpHUWpKbWpkNWszSEw4?=
 =?utf-8?B?NUhUNUgrVzlWSWF6SjJYMlZjWDVDa0Y3b09qdE9lTnc5cGNxSE1YVHE3Znd3?=
 =?utf-8?B?dEo2YnJlWVE3YTIxN3pwcUNLdEtEem9kekYzNHRMQ2F4bnZDM3FGaEJxNS8x?=
 =?utf-8?B?WDUwMXdxVmFnblAzaWhBYXJCVUtScld2ZVlDcW53Q0RtQlNPWHJlQWJnOWVh?=
 =?utf-8?B?allsandsZ2ZVWllLdUJ6MHdsR2FaNVdQQXNGTDFOUVNIUE16dFJmc1RIQU5t?=
 =?utf-8?B?VTUzZk90SkMzd1VJd0c5aDM0RVZ6Z1FTbTVlQUZ5SUJiQ2E0S2tlUDBBdlNj?=
 =?utf-8?B?MXkyb0dFTWRSK3U1b0prQWN1bGg4b0JLYlRZc2hHVG1IdXhnL1dERUpQRG9X?=
 =?utf-8?B?TEFXMWQyNzlBREpOMFV5dzVBaS9rdkZxZ3pxUUp1RU4yU2xtVEF0dS96c0lp?=
 =?utf-8?B?S0lmUDBjeHQ5Ujl4S1U3Y09wdDFKbWNQOFFyc3VpYmNEcEpLKzR1akNWY1RS?=
 =?utf-8?B?M1BVZzFPU1UzMEV0WFBQWUxneGdCVWF3Y3c5anVjWW0rSFk4MUduaEh6WG11?=
 =?utf-8?B?dk9qM3pEaG1vK3MrOE9ITnBTMHZYOGJpOXJuYUh3UHhCN1hxeTdHSDFSL05J?=
 =?utf-8?B?ZE83QTdyMml4aWplZFBTWkJhVHZBcXVxRGcvOXRTejk5RkZEdXBVTHVSN01l?=
 =?utf-8?B?UUJ6bHNxODJ3eFhiYWNoVlRBTUVUZ0REclRCdy82b1N1eXVDek9lZ1RwaW5a?=
 =?utf-8?B?aExrNkZ0QlJ0UElQVitaU0FaNEs3R29IUUpqdzJhY0kvUGlNT21rQW02WmNl?=
 =?utf-8?B?N0pyQ0I3OHlSTmk3VTZxMXZtZExzY0JUU2NNS2pTVHB6cmhabEFFUUxUNG5V?=
 =?utf-8?B?c21leXVycitXRWdRSVhDTDRhdEVuczc4TjErVTdra0RkTUdjRmJsdFpqalRQ?=
 =?utf-8?B?WldWMnlROWlYMC9YcS9jOEpzRHN4b0JHNGMxcGlmMTZTeWtMZ25pUkw2MHhi?=
 =?utf-8?B?TVdyd2lGa3lZZGxqRk1tVzA4SDA2TldKVlBoVDRFdVdJcFowL0JYS2luZkh0?=
 =?utf-8?B?c1BTWWp2RUo0Z0JESzUwNWMvcXJzbThJckFYTUhpV1ZuMGFjSDdOQ0tuMHVq?=
 =?utf-8?B?Slh1YStxbmpoS3MveE1MUXNWV0t1ZDJDSVVXSXhZenNMUjM2clUxY0RReGIr?=
 =?utf-8?B?bmZsTlJTK3pLTTRNMi9HUVh0SzZKSVQrM2NSRTNLV0JoMnpVOFBiL3RwNHlR?=
 =?utf-8?B?bHdEY2p5OE0zNUZ5UWR5cUV1TUZpQnJRVDBzbVBUUkhlUlc0aEZabERFSE4y?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kv9UyqE6lXkKsnORXjnA0G5z1lUyiFL56KeEswgKZv3AbmNUKD9E34GO2GUrGYqRypZGIPyPKmQDm6w5wJDHuRk5GokWWqgHLB5++AWgifpGVvp7UTno8+m5AXTjaWgysBryWMDZLZgB3zF6cEa629Kt6aS/CEt/Df+dHX9lNxTm2GZgXCDHEaRDmvsMP7sVL2xuoZbAsXoUBJpyQ3vWYw/fPeeO9mZTN8B9mZ8ut1UnRtQqDpI2GRKmlbriAMzMVURkzxW95svvJQNHhLGqPCKYPLtx6ozgib3sXvzM1txPrP9Cj9wcHfHyrrNBAaJ+DK1vc3FgNhPSxdrkeurSzk9YgdOmXj+joeF8rFSk8z7uLsjNWPMihh0lgTQDJ5esqE8eIy7jO1n+hgIL39GClbTrIhDGm6DHabTEjqX40LWbwra4xao9HCLbQ2UpbQYedP+Ypx1eQeIjXmaBEvOHWOiUZAzxk2xZwGJtvj6KdHiSJJN3Gqo6bl5VRcNfwYxw7XvqbmfnUxF7NxzOG7ivDsPwA3o/9dUu8ZGDq7IvoSup5JIL0mWM5TbQcuqPzi8SAFQyWLc88TCu5DZ2MyYnxCvI7X+UXJdlFyfiXhwtvK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3344dae9-d131-4562-0524-08ddb3ba6908
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:32:17.0287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Y/P3nl3xZhfy0X2qEXQ2Kqz7+pydH6NcneFc2ywUCx++nm1/hir4nYT5AdeQLUz0s/7EWIuQRTHA3DMneltG5b5mb15DZtph1wi/6uXnfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7581
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_01,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506250054
X-Proofpoint-GUID: fXglbYpK-beJjdFg6M1bjCFXrgKWRFef
X-Authority-Analysis: v=2.4 cv=PMYP+eqC c=1 sm=1 tr=0 ts=685ba603 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDA1NSBTYWx0ZWRfXyRbP0fBCnk/d FQcK/eKkrDyQNoNgd8QOnaPU2ZPLqIY+0dCHiO3g6AF1HdmZm9g/Wk421bEAa9it3/+fhTU4tSV qYpu2cZ+TajoOly+BA/7J9ukd/DLsrX8xwYjxMN7k8iPrH8jOkLY3R1etG1LuCv1JkOxtB8Hm/x
 gBWitlX96pfoxDn6v7M5c72OIJJNwYhbFY0H0cnzOUquiuvg4VJyXh1RJNtJhHFfSokse7CfdTJ qaLdC+UvGfcRfrXUnXsB065XgebanxXHcuIGSQy4UO3JDQWj4iPpu3rne6hgp1mOeXwjeJ7tbyA xoZy+rEimBGbrBShv7WA/tCYymmXiakOfoXzOlPhSAVmULIA1cZ5jflDn1GFmlc9AowgcJyWREl
 fP37wUixYpaJDmdViJyUJbkayghjOr+5DzHEbd/ULb7dIMlieSydzVeaa5IzoE1hTr2rDcip
X-Proofpoint-ORIG-GUID: fXglbYpK-beJjdFg6M1bjCFXrgKWRFef



On 23/06/25 6:32 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.186 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

