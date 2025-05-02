Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31D1632F2
	for <patches@lists.linux.dev>; Fri,  2 May 2025 13:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192489; cv=fail; b=qcrSSzUC5u5XjmaQjGQB+r2HFLvLAlE7WuZfZ9L1Z79WjesyImlOvTsE/ls7zbzRhMgiUNibIGWW0Dvx/LCIHN66hQh2dUMsfjCxZZm28Mr0m1mdOP5aLdJqoAvx3q6Ri9Oy40rQ6Usdk17v5tYuwB1OPT/dCl8F1pR0C9oRgP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192489; c=relaxed/simple;
	bh=GEiJEinZLkIOvayYW+IdE72TF866YHHogCsz8MEGVKI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QO2bMIoEssaprZDJoGMoqGtbL09nDUdxJnke6VqQlYwzsPxyfD5GZ2EfQ6r/lGa/na41x/UAzdY465yZQwWlQ8XJVSFiRrWqxvEwDoyzdqA8e8Mhj9lOUv9kzfqpMw35ILMKT5Ksj43oyeYFubDOWIF/Gb77ULcVLykQQPO9T/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AaO8LJ5b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZItIMoGS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AaO8LJ5b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZItIMoGS"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5425WeXF023779;
	Fri, 2 May 2025 13:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p5+S3jcjLXeZ7ADIa58vA71r0pv2dzVjr2qcCqefZbk=; b=
	AaO8LJ5bq0k98sQ02ahYxthrRj9J9QAIulFX+uPyLMh8klNoWY7j5hllFDv2ZT1R
	5Q9BPKF7APaMnPOQLgAJWntgdigiG0cMzIS1sBiM0TFhaZIravBEFIl/vgF85O3j
	RFVXr4UrSB/VmNggK5JJ/xe48M83aLuyydgSuiP/xWuR4fOt3rTKV+d9sMXT/CF8
	U+FI3IZzcCQvBcCJT5EugHlE0fPouRPrTQTMalp/vEwQPjF2JEDUwx39aJ+dKBe+
	d0IrGUce0cm/FR+zyCQKAnM6QjscEcURGUYCtDBEvNjcqZHHMzQbA8cocklbrmfY
	lRnEQf/af6Cb5VCcTfN1pA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6umd9sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 May 2025 13:27:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 542BKVwF035252;
	Fri, 2 May 2025 13:27:46 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxdj4a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 May 2025 13:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOxoJmZJ25vY4li1xq4D9EE8aGmqfTcRzKSaMGASDZ1XwqDftJUru75FKGU8qCoNC7f5T5L/TYj6CE5QCt9DILajMSz6iPMSM60RZRhtm4KU4bRelsI5UcKN3iItWAjpB58rFvMoQ7iWtutBVYuMLK1M+n20x6+JYvboafEEclG/eXFjNg9i1ElTvObuSTmmZFYjKPbsMm2WoFZ0zX9/F/xXh1SxRQ1QH7THnMYJkBwmdEzGKQkbzen7W6GzeWO7XmLqo0Av7kef3NOt3PtLVd+l7kX8i7z0RucQNS+TuxRECI04XG2yM2Q+X3+X5VkmAUX8sZjhGEVqN9YmoDpvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5+S3jcjLXeZ7ADIa58vA71r0pv2dzVjr2qcCqefZbk=;
 b=tHqEO2Wk0A8Xi78bLWl2eiIXmjiidPBBgkvn+pHBO4wXY1P7YwRRUOYsyaubvOrZCJGYFigK7bYhFhlor6u6w4I3x94wvFRFKzi0nphTgJGv1DX8B6wCon2LNc7yOtisX83302uglUTtAc/+U/zzlE/aFDATTySp5HuiM8mXyKxeelmSrkdgbIfeWtvkZVEUZwKQX9u+yAiipsapExa5AtpMAy2MV3lMX0mCByNe3pXfAi9CXG+FlmE7PBJWCS4eYOPLs1etc8dT1xBDXS8QuOVk2Y1sR9O+Ab1cBKa7E9pgfcYGhP0S+e6o6EkYeix2YNrG5NsWO3qKN31MQfBF/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5+S3jcjLXeZ7ADIa58vA71r0pv2dzVjr2qcCqefZbk=;
 b=ZItIMoGSYRBMb3bpP3J6NpF+zemDt5/UeAsvr38tREccr8q6xHZdmcBW/bFDJOXoL5AR7sa8PC2SElygABFrQRcU+21L3g32K5Qbv/ovPOqt44epMserg5c787k7da41q9JSVekS/olX9x7Q4jInMoS7nqd9JIpQ0agVDrGK4XY=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by MW5PR10MB5762.namprd10.prod.outlook.com (2603:10b6:303:19b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Fri, 2 May
 2025 13:27:42 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%4]) with mapi id 15.20.8699.019; Fri, 2 May 2025
 13:27:41 +0000
Message-ID: <aa73d045-c803-49f8-aefc-53b74543185a@oracle.com>
Date: Fri, 2 May 2025 18:57:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250501081459.064070563@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250501081459.064070563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::19) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|MW5PR10MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b208b94-2b2d-4fc6-dd6f-08dd897d1d49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekJwbUdXdk1VSWM0U0t5aStoV3htTFdQeUgxcHNKUGtEUmFtVG5STFE2eDBB?=
 =?utf-8?B?MitXKzZvRFMyUE0ra3FMNE1PUC9JL3NiSkxtWWdKNzZGODBjS3RjNjdBeS9R?=
 =?utf-8?B?VGJhazl6MHcwYng3SEJESzVpZ0E4bnpDNFB4aG9YZStqR3Jxa2VCd3NPV3Jr?=
 =?utf-8?B?cnZvZXZZdEMvay9UMEFzVHIya3RNT0ZTdGk1bHByZFBoQnlKTSt2U2FxQm02?=
 =?utf-8?B?MVR3UUpIZU1WQXpRSEdWSUFmSmQxejIyenhocHVOeldpbldUV0xuWUcrbFBN?=
 =?utf-8?B?eER4S29Za3UwcmZEbUc4NDNBSzdObEI0RDRocjVzbTBQTnBETFRueDJwS1ZU?=
 =?utf-8?B?VmoveUNjNzZrRVBDRFZ1MEpKV2Zua3laUk00cVR6ZTByNGQvcFpkZDdGSHpQ?=
 =?utf-8?B?ZnJWc1ZQUGJvNDkreE84VGRqRWs0UGt3cGtJK1NydkJLOWhRSk5HM0t1NDly?=
 =?utf-8?B?ZEErRTlxbFA3L20wQURUMHEvWW5mblNUZ2xZTzNNajdLeGgvU0YrOVkweG16?=
 =?utf-8?B?dFNxazk3MjcyQkY4QUtmWEhzMHl3K2hXMG8yeXMvSXU0UGhOaTlVUFNSOXhU?=
 =?utf-8?B?LzdrSmQrUzRIWTRHbE1wSUhkWlFoUFpWNCtwSHdVSGFlNXVyNjRpZnFHYmwx?=
 =?utf-8?B?M3Q3T3dKL3RnaFg2aTE0SGFrQWVsS0U1SnVwU0M5Y3dUOHdsdllWZmJaMVpT?=
 =?utf-8?B?Z0l0MzhwZW5XZUVhR2pMT1pOZGQyelROVzFyQkxLcE5Rc1J1UVRkaGNlLzFJ?=
 =?utf-8?B?WUtXQnFlUXk2bDdjNFk4MHNsUUNTeDZuTzAzMCs0V29Cam91STJrTjJ2OUl4?=
 =?utf-8?B?TUlOTzcreE1VS1pmUFZRbStHYVV5SFg4L0s0Z1orYzBSZHNKemk3VTRtbWFv?=
 =?utf-8?B?SFBUTXpPTVJsM24zd0Y3MHBPeUViR3pyZ3c1YnZjb3BrQk1QMjEySlNITnd0?=
 =?utf-8?B?eW5MYnZDYnV0ODhNTThaRTVUMEYzU2tDYXVaTnB0MHBxNkZVRjJuRFplQ3hj?=
 =?utf-8?B?SS9TcWNlSGZUZ2JpdzRFTllEa3F5NmdTZ3JtUHF2V3FsTGJDV0xQUHJkZkgy?=
 =?utf-8?B?VVJRdzBMVklsUHd0aTN5NlQwNXN6bHRTa1dWMy9QWU9qQWpzTVV4emxNY2Ni?=
 =?utf-8?B?QnFMQ2MzalA4MnJjK2tpQ1lSNVU4SjFjUFpORDI5Z3ZQN2loUU1QSlNLOWZl?=
 =?utf-8?B?S2h0L1BZdllidDRESk93c1p1UUhpM0pQcUdXUHNvbWJWV1J5d3YzbXBuTjdL?=
 =?utf-8?B?VkxtR2JOczRWVkNtaTI3T2hHTzAwTWc5QnBVZGdhM3ltRkZQVFYxYnpRZTRp?=
 =?utf-8?B?ODFqYVNqRlplVEV0YXFPZ3A2bXRPL2RoZDJzdGU5YmVXem5tQ3d6RWdVM3NG?=
 =?utf-8?B?WmIyNDU3V2FiOUdYLzE4WWpYRCtJUTI3TGVmZW5YK1Q4YXZqVVNwRVp6SFRk?=
 =?utf-8?B?Q1pDelZIalg3Rk0rVFJZbzgzU3lPWkEyT0FLbUYzWG1HZFEwM3hESUhVamFq?=
 =?utf-8?B?TmlMMVJFWWtVVXBnREVrRUpjUDRVL2JmSU1ydU9rZVhGZXVXUU13OFZrRkpn?=
 =?utf-8?B?MzJXUFJRaUVEKzE2R2hEYjVBS3N2Q2VXZGR5U3pFV0JnbVFEZkoyUHB2RHFa?=
 =?utf-8?B?K01XaTVSMHZLQmlQZ25UQWMrY0ZOVXp2emcwNHRCNnRaK0Q4aGlUbjJqc0Y3?=
 =?utf-8?B?OEx4WmY5dHhrakRPL1FyM3pobXBpWUxqbWZtbUtjMmdaYmV6dExDcXpjUUpn?=
 =?utf-8?B?d1FraCtTb3lydmZCbFBYZHBRaHpMeUR6Z3NwVmtUaDZzNEFTeXNQdk1CQ2NO?=
 =?utf-8?B?QkFrZXNDYU00RFZOUWhIN3Z0VXlJQVdBQU1YL2RUellUS2dIbzRCdC8vZE1l?=
 =?utf-8?B?SWxMdGQxcHpvVjQ5T0pJZngzY2grUkxMenJrN0FkYkgzdUwrbUlRUUU2VXRE?=
 =?utf-8?Q?bsCj7G98yW8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDQzYmZvdUppSzFLcUMrTm95c0tIbVZJODN2ODFIRldoVFk5a1BVNkdFMUtS?=
 =?utf-8?B?ck1sNTVlZzJmbWd1b016dHFKcTVjL0JlNnZFckEycTd1bVhQdnVPQUlkL2t1?=
 =?utf-8?B?MldRVlhIQ3R3bjhMRmM5Q05BUTZlTlR2cGRhMFlnb3FwQUplS0RXNm9jNUJ0?=
 =?utf-8?B?YlVKVzRkRUZVV1ZLMnB4bGUzVEthMTEwS0FNRHZWTXBRWFJKUEN2T3FyTVBG?=
 =?utf-8?B?clloMTgvQml0UVJFZnpJSk5sNVBTNEhNc05WYTk3MVpkd2ZKZUN0SWUraWVQ?=
 =?utf-8?B?TkcvMWgxZHRTU0ZrcUloTlgrVE94UkxwWTlweTk3R0cvYng1R2ltODk0YkVB?=
 =?utf-8?B?Vll3NXJwR0FnZDVPeW1VQ2drUXV4b2crcFpvemFsN3B2ZjlpWUhtL0R4UjNk?=
 =?utf-8?B?SW1JM3VMVExMTjJkczBaNHdZMDF5cXo0MXBJdWROSm0rdTI0bEhPbWlkYTN5?=
 =?utf-8?B?VDZWbGdiUzU5eVFDR0ErTFNGYTYzNkJZMnZLTWhvbEFpdHplalhjdytUZ3lr?=
 =?utf-8?B?WlFXTWdXYm9YdUxFOG1lYzN1QXMweWRGbUhGT0FOOEYwMzFZTnEzNWRqTWFB?=
 =?utf-8?B?SThLMzc4aEhYRlJHcmZBMUFxK2hJZlkvYWpSbUpTWUh1eUNrbnZNRUV4YVYx?=
 =?utf-8?B?cXN5dlpSb0p1OWpYNFFTckg2OTl3UkdIWHQvelloWjhxTDhGckkvMFIybmtH?=
 =?utf-8?B?SUlheXlZWEI3bjJya1hWUStjQU8zbW1iNE5EWDJyaDRnL2t1Z0NCQjE4eDg5?=
 =?utf-8?B?ODlJNkJsZGNaWEZ1cVFGV3FxQWk4a2VKYk9zY2pYcTBhOG5nMWFZUnlOLzRv?=
 =?utf-8?B?UFRnRVR5VHZrazNWTWVhWlkvdGpyaDdDbERIbUU2S1BwbFRidDVkS1dZWjBj?=
 =?utf-8?B?alBVQkd6YjdwRFpGRUtMVWZzYUloOVhpTkE5S0Q5eXZXUElxTVp2L2lsdXBS?=
 =?utf-8?B?blJsaHFvUVNFeVNwOVEvYnFxMU1vVjlYeDVlaFBXeVRwMXZnVGdZMFk2ako5?=
 =?utf-8?B?MnF5MVQ3dnNDSk56OXZNSlUxTVcrNFdOV1dyblNzYm5kL1BkcFlLMmhOakJH?=
 =?utf-8?B?eDZIQnQwcGl1RHk1TDRpbTZ2OTRhR0JLWS9FdXpXUDdXQXJvemxwcVN6dHl5?=
 =?utf-8?B?VUMzWGltTGg4YzJTTENwdW1Cc3N1SXlhUHBFUUJFTEVRaUpYQStNMjk0L3l4?=
 =?utf-8?B?WVozWjFLQmFxMnAwRE9MRmRNenhoWEM1cWM3ZlF4QnlpWHRWaUhLZHR5SVJR?=
 =?utf-8?B?QW1QbjMxL1ZScGxUQURIYzFkZnlEOFptM2YwUENFYTJVRWl1dVdnSXNFWlhH?=
 =?utf-8?B?SWZaN1VXWmJ1c1dsSHRkQTZoZEVPaC9zaVZTMWs5MlhHdWZLVmFBcDlnMVdC?=
 =?utf-8?B?L2NWWmFkWWFVWXlwV3Rjc3hZdDlGT005UHk2SFJaTlhkcGhKTXRKUjVFak5K?=
 =?utf-8?B?ME9qa3lxaW1QVDQ1bnZNcW5lZzI4RTBhL2g3QVhwOURoaUxaNDh5OXg4SGVw?=
 =?utf-8?B?eThDM1Vna1ViSXZpVGtSUHM0SEd1WUhoZ0M0YXFPVmI5c2xqTzluODVtbUxZ?=
 =?utf-8?B?M3JzN2RRcFFvQXBtWUdZQzhrSlNCN24zR0E2bFhoc0xMY3RxeEhyQkV4QXRM?=
 =?utf-8?B?a1ExclhVTVNiR1JsMmJvMFZqZm9uL0o3eDZiRG9aUUtRdXY4Y0Rtd2Y0eDlv?=
 =?utf-8?B?RjExaCt1Yit4bTlMYVlYTlNES0tHYS9WTldYZ0RpbEFlRFpsb2RJRXdncTBZ?=
 =?utf-8?B?aTEvWmNsTlVBS3NHTEZXN0ZHTDN6OW54bHpPN0kweXh3eWh5MVRpdUZhRFJN?=
 =?utf-8?B?dzZRLzZxQTFDd1hCTmNDWXBQcCt2a2JNMkEvOERsanpIcTBIQ1V0dE5GMSti?=
 =?utf-8?B?NUJMVjdPQmd4OEFYN0t3aWVDK0xhYkp3MWVVeURFNW1vTlY1SjFIUVprcGxY?=
 =?utf-8?B?YlRsOE1FOHRHZW9IZ0U3cWlTNEJYMm5ZNGtINGs5S054YmRTamJURmxQZ3M2?=
 =?utf-8?B?dWVWRzhEZTlqU1pGR0hyOWhKblJyWCtZM2p1eEp6RWFIUXZ3QkszRVU2UWJK?=
 =?utf-8?B?bGEyRnpzY2NBMmlONExFMjFObWVyVDNvVllaSm5WWWh6b0hqM0xsa0wrNzRB?=
 =?utf-8?B?U21GNm5Xamc0TUxFT3cxZzRXYTUwYVhmbUtZUTdxc2I0Y29rS2krMVNyTHRP?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vHzLBdl6IAgoPfWpHsBpA8leqwVrfpu//dBJYtnR896mLgzJdMHHRmOUc+mCQx8nJVMoJ09hi96RVR0aFCXGEFqt+rm5uwMRJpS/Ue5FEyd/S6kBqt31BAlhQA/oTcD5cI6Tv9bWMTGbI7o5yPZv3maq++Nfi0BnTkIKHObl3esE21adukfhvxio5X14jhY8dIMKT7baby/+ytWpfq4sHzUTvlCJsBwapIIh7kw+5Tvgj66MBzg8ab+GUKm6DNl8WOHtvdZGjy0YQZd5AIduxRAR5RBuS2TnXVl9H5r6JRFXD6XFZ+OUdxKjX7ncTYVcCrUGP6Mzr3ZVWL0G0COY9aY1xuq8uz+cO3eii4Ilr3N2gs09cyrHnvvkgfnnOnETuepaFXHnJAugN7fkNWTeCsZqqiOhDYuAfaMCR3b72ImXtilpY44V+SKsM4X+ZWYkXHGNx61cg/S9MP/nYYedS/QBeaGJHeLIf4HtE0jf5/rGKQhMGCfYXlXnTzE5fhIheQbly+4vwZz4wyIqudNz9vJE8S8tZQwZvbhmdsQAC8bjDTs14ggD3dVZBSNXN3PtqV3oMVit/zKg426gBvM7NQkuMKkL9xhoAq5j3cjMnSA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b208b94-2b2d-4fc6-dd6f-08dd897d1d49
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2025 13:27:41.8252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2s+7Ryhr1Hbcq0H5wAso/LwwC1rze0zJauuyC8z2YejdBVyOoiw473ikJGzL5X1PeCHRdRQAZlW/4X/oucy1/75a5Hnu0xvyRbiIrLRP/mM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5762
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505020106
X-Authority-Analysis: v=2.4 cv=dfSA3WXe c=1 sm=1 tr=0 ts=6814c853 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=l5Z3sCsuGtR49M5VgQgA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14638
X-Proofpoint-GUID: 2Lliz20tzxG87LBXEMdzQTK4DOlO3u8z
X-Proofpoint-ORIG-GUID: 2Lliz20tzxG87LBXEMdzQTK4DOlO3u8z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDEwNyBTYWx0ZWRfX6AcVA/74lutU jVvACmtX4YKoUUFJXSjva7ZSHJ03eOeps3NuenuDDDdx+VxgR5+EDmkugfCvO1fBZmnTIDZADlI LKh7x2tlB3t/546BGO+73ND0qhaXw5/gMxMrvLhLge8YJ72zjJbUdTxoF9Vit7fnzJ8/j9bAqrg
 uyzCjVtA0joXCB7iJ1AE84P737tcxx9IBJch/gZM6T27ctEsCP/H/rXe2Cb1BOjt40JHRaeC5/r r8T0o2+jcADGHYhTgCZOX7qU8bGuw3uOBGbG1LirrCBzlgtNRErN03alSuMeb9FnLATMDVciKp5 DNnFJBke5us7jMzWtk3ItI1OopR3IXyK4QJh7r7eR1UPPpkKNG4FZPUGyl+MbqxbLF5J+a/wnxV
 oB8LsNW+6cRVhDBWim4gyRploIhhs7gCs2Vlo8hDjjaOA2i7cEMSuWQrIDOsQu18Cnwx3Hu6



On 01/05/25 1:48 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:13:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.181-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

