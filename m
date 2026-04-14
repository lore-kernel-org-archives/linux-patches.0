Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F25B3EC2F7
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180986; cv=fail; b=n2siBITvkMx+Q7J4RBZPOofCvVTSPHBdtfa4wWEEeaKMwy98W/O4HuVnte7eqH0QNDdByuaUlm6zDMa5x/e4G2Y2u/7xWV4LV9UYBohmmr5vZMo7AXBFU0FN2qQHPSocvev5dsrSHUBXk8tAeIvYTcixwvHJOco1mh/LJGIQLC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180986; c=relaxed/simple;
	bh=esHBm7LCL7IPGdHZjHHO7rHqQwsRwGSDNCpvabC4xMM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gAT+uT26gRdhJRjdu/BhKJuTOMA5xcDx/BfJsjiQO+c4XPtqljkg4wUsh0QedI9v9+Vkb7GNRzck4cNkAcnHN8Qs/Qk5FQ49pnYPRaG8+2fPyM+3LxzOeMWZCtUmrLv0W6acLTs9CzjMXuJDuQn+AaLGaymjPZ5lnCD00b7IRQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HAtNlfyl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wa4C+bDg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HAtNlfyl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wa4C+bDg"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EDYdki1735496;
	Tue, 14 Apr 2026 15:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J650BtyBj/SVd2TT8wLoKpgIl0EOMxDcUpx/As4JRUA=; b=
	HAtNlfyl2GZYKjpMDSFryLm7jXZtv9aqSIY00NohFGvTVBzhCLOJ2Bh5hnV37X0Y
	lrpHnHCDORHzTNGsVnb88Wy/L3448/j9sezy1jdVhJgfsXFgIcu755jazivIAmBZ
	AVZb/erIrEnTcl6aJy9+WI8gLiiFCiYc+oO4Ud3huR9ZWT54Dmyp8F4nJRI3h+Vx
	aV9DG+4sj6jEiqHGPGWRanl2Jsnl3v4Csml3JyiAVN8RFCuC8k/4+hfJGM/UfTi4
	6TbU5jqHbWuErUqzkNwBJyVk7lzP60jJr4/m2KJ8cYx+twyD4NDTJO4DRLyonpkC
	EDj5GHRX5eim1KnbzPDFwg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qb5p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 15:36:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63EFYhr2020886;
	Tue, 14 Apr 2026 15:36:16 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013010.outbound.protection.outlook.com [40.93.196.10])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nmn8k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 15:36:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6UV7Ce5YLI94UWfmPkQ3zAFZchQa2C+uWuMUmAitSI6+XtFIhf4DnKVjL+ST7B6o1ST0eS6QwpR/dL2uRApoUN77y+Ib6zKSJrvrKKB2vb08Ao9y2DHqzHR+wZlS3GPRpf5HJuBrCZCNrEamOtnq/98bz1URwew1EJBqdjntF4SNWd2hJu8N5jfP/4Admpo1oWIyXkhv1rq35+mvE0nkSmWvaOBv3iEdcZDLgebrWXqStdCX6udWm0wS81OswAsOA63SmFNGnViKdaFje6tUImOT1oSCjaf2V48xU2KokZT43UbTum1Aha9yPSbVWVHlYIoQYbWSp6MfszG6MQHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J650BtyBj/SVd2TT8wLoKpgIl0EOMxDcUpx/As4JRUA=;
 b=cSTzIkc6fYb2YV2aw4VBDiU2JpcgFZHtHQ85XerM/nAiCA7VLj37UCpGKIprHKHtv14IZugAQq1N8GfAmutlplKX1ryE4ohJ5JEwWoOSDt+6URbtjAIRitj9pQLHDfB5uo1xgcP6EhIRo4oi4x+LxnkhqMUz3ZRSHBveKg1geF/Od9rxPEyhiQiaKIdKcex88HQcRN0XBJrrn2CNG/d0YD0918zvS3dUJQ5+pRAYcuyqMB7ytKIzZWHFnJgHEwiOF1VrzGrSj5a95CBlv6xyJN8txfrb398rBWcwJDA18u7V9YIDjM2wobfSO7w4vzfQdtqlyy/g4mKZMBoK5pP6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J650BtyBj/SVd2TT8wLoKpgIl0EOMxDcUpx/As4JRUA=;
 b=wa4C+bDgMzG20+pxXjMIIKn8ZXWa0uzSjeg4AcVkyAT1VcJoXhBJcLBzfun24zQTSM8fwkGq0qfGqLiuvc5M7hn1LZwyJvF7rQ8p73e+ZCYurbyzpTvvoeePBQM2KvW3gUrzMYZAQUINHrKnVElvqB4v4yI7ChKO+a7IB4S66Ko=
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6) by MW4PR10MB6440.namprd10.prod.outlook.com
 (2603:10b6:303:218::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 15:36:13 +0000
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83]) by CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 15:36:13 +0000
Message-ID: <d4d9973d-ef50-4b4c-9c70-44d7f30f1201@oracle.com>
Date: Tue, 14 Apr 2026 21:06:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 128/570] octeontx2-af: devlink health: use retained
 error fmsg API
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Przemek Kitszel
 <przemyslaw.kitszel@intel.com>,
        Simon Horman <horms@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155835.237370769@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155835.237370769@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::15) To CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH5PR10MB997695:EE_|MW4PR10MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 330ed9e5-529a-4c51-ca89-08de9a3b8f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2RJsEoD6y4O/76lu3w3PF7rISnEK8g42dGX9Lly7JZb4jjsSQG9fmuQqeDntDYl5gy0H/iXbCnjPTnIgmZWa3NN0iKHKuj0ohHDcw0RoA0+RCKnfLeJXlEsdBp3L/IK4nTbkP2fOY32hrqYNIhdK1oBYqtOIUdo0TovFgEI7M1YVjg8kTfVTxHDpUcAUU1UmVOLYDWlzEX/RafRVAk3k/3Eky+BcbsFXJZP95Mb2pA/2gKCbF6nX4Hl71XoKLdKEADvolxX1TK4bWapmDooAMZslZGG0gp8Hsc+kSw4QJQRANeyOb157PTmt7p7zUGKujaS/jO9Pn4LKghnbtu4XPEkxVgjVrYrVL79uFHpCVQweKlgb91DsCC7Wk/WXooZ+zyY5xtB0hnkm7U+eahlG1uNVnv0UUen6A4RY9b30KHdbgdQ0uHoBxHU8mxgQIr0TZwivU0algtaK2wATpLIY914kDzaoOGJMg8bTOszrF6V9MVtD3sdwke9UaTuCSMnKWwwMxj/HWjbFATkX46x81Ie3VXtK8Jkkxw8c2cEHk78A9CfNubIhVreKtB3Un4g+fdI5NHtU0aFKzCgs0r9VzA0GAJcm8JM4+uq13oQZnRNdRITunf1RtKJD4tpow4nHMBfd/EdMv2r4e54jJJ3GqzLouusofSr7+gki5k0AUNHy20agHyw7hjz8VFalPJ3JaVM67ztSsdHExh1eWTbPyH/fNvUJX0PmUShKDKYTEhA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH5PR10MB997695.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlV3bHhNcFgxRFlGdXc1MFZuSjh5Q0NDSldNbkI3amdXaDhGL0twUGVuS2Zn?=
 =?utf-8?B?R2lTdytGYnF3TDVLRGhuSVhDTk5ncTVPTnFSUGt2dGtwa3A0enpCWURiMHNt?=
 =?utf-8?B?NVh1V2Vnc1dtUlVCK0oyUEtYTHRCOFlKckFSZDlBTWgyUTlVS3M1K3lVUjJ2?=
 =?utf-8?B?MGt5aTI1ZzljLzZERk02UDBpMWRPekR2MlBha1hEendUaEpqd3Ezckh0SzNT?=
 =?utf-8?B?L2JJL2pXZktFVVFJd2pxNnZQb3UwUUREOCtEblJDNUQvOEJjbFJuQUFGQnRP?=
 =?utf-8?B?bGg0MnB1cGlYaTZHZy9rb0hoQjNyaXArRmVvY1Z1Um1BZkxldG1YY2xoMEU3?=
 =?utf-8?B?UWxNYTkwdVduVEtrdElaK0htZmtDSmxtT0xWV0xqcUxFY2dFcUIvd1dyZWdD?=
 =?utf-8?B?ZFBkdUlYU2pJU2IydTk3SnZJYzM4SzN3ckNWalRMeHRQRnpTbmIxTTRBdTRR?=
 =?utf-8?B?UmxDVmJnN255cHNiTHVwZHNydmx2eCtrV3ZuR0pMVEFWSWVaVC95MThrT0Z0?=
 =?utf-8?B?OHRJcW5IS0wvOXdvWE1iUHNBQzJvdndhbXhSVmc1Q085V0FFM2RyV1U1ckpi?=
 =?utf-8?B?T3phRjE3TWZGQ1A3R1hqUklFSkV6TGhhM0xMWFByU0xabGpqRURpSUo1R1FP?=
 =?utf-8?B?bUhBZDlPNzJmbmkwdnlFdUExMFBpSzdMeFd1SitEYUtQeU5oTkQ3L2dBamJn?=
 =?utf-8?B?clhmd2RheWpMNFlnV1BFcStBVGczMUt3WTZoWG9NUEtkbHpPc2FKbW53WTlG?=
 =?utf-8?B?RDRidHN1aHVMK29YY3BQcEMzNStycXprSGJ0M09ycG50KzJkaUxtTENKelZ0?=
 =?utf-8?B?bUtoZzJuUFc1eGhOMHJwYzFQLzc4dHFzdGsrWEhEK052OUR5ODliS3JlMEo5?=
 =?utf-8?B?dndRRHM2K2wrSUFWTklFU2JoemYxK0d5b1NRYkdjNTc5S3hDQm8vcDhWQU5Q?=
 =?utf-8?B?aEhkanJFQ0psUzZOMW40b3E2N3gyekR5YUVubjhyQUpwZzJqRlF6Yjh4djc5?=
 =?utf-8?B?aTRPMFM3QW5NTjB2bzBodDhrd3B1QjhqZmt2RjZvaWl1QkFIT2ZTd25oSFp5?=
 =?utf-8?B?WCtHQzk3Z2ZSTkw0RjU5U2pwcmFBdVFndDQvV2t5d2lsU3Boa2twcjkxS1By?=
 =?utf-8?B?V0ZxMS9EeGxkZVQwdjZZeHplZC9hNTB6dFMrNlpNQzR6S0xMUTJSQzlpckRM?=
 =?utf-8?B?WnQzcDBKL3UwMUNhTGZWRUQrME9sTUtZUW5iejhjNkFFZXNIOHdBWkVZWmJM?=
 =?utf-8?B?RzBWaTNCTW5zZzFMeXJLdGVzZ3VmenJPNk8xY252QjIvZmRzT0U1Qkp2TUdM?=
 =?utf-8?B?eG4vRkJ5c2RqTUJUNW1qMVAzNENJRFkvQk95YjMwdkd3WUdvSUlYR3Eva1VE?=
 =?utf-8?B?Y2FBMm9BZzVIUzZwZnFRQnFTb0QrZkR0RUYxOFBRcFpycFk2Q29CUmJMb0x3?=
 =?utf-8?B?TGNhUTB0MytHaUF0eG5WZWdxK0dENzRMMzhyRm12QkJKTGE0VWxvb1Z6YW0v?=
 =?utf-8?B?MnpiN3lIa1ZoTjFRYjJBMHRzUkhxNlpaUjdOay93S0cvQ3pNcHJiUFY2cS95?=
 =?utf-8?B?cXJ2cEtpV1ZiNG10VXJGdnI1RktIWC9mYVFNSGhUWkYwMUR6V0lzMlRiZzBa?=
 =?utf-8?B?eVBHek5TY2J2Smk2ZFRaQkVpZk5VcUlsbytzTWtGZlphNUxjZ0FrWDBrb2Zt?=
 =?utf-8?B?NHlPVDA2bGFjdzZPVzRpSUFQTW5LdHJEWlpRTmRyOENRbWVoNmhtMm82ZjA0?=
 =?utf-8?B?azl2Y29ScnhINkRSZy9TYkp0MlJWaFVPc2tjU2svZ2lvckg2TFJlOUlzZWxG?=
 =?utf-8?B?YU1yb1FZTEhaaWhBSVpUTUpOYjdDdzQ4d3ZvM25UOE5RV3dYUU5BSDNmSG1B?=
 =?utf-8?B?aGxTclRlbGpmNnpjU3ladGJwT2VrR2xUemtLV3FPU2xSTmJjMWJpZlhLR1Fm?=
 =?utf-8?B?V3JidzVDYkZZRzdOWjJtUThGOW5kRnpUbGZ1dGw4ZHE4MWZwUzJxTUJ0UElr?=
 =?utf-8?B?VUx5dCt0Q2x6cDhnbmNuWXlIQVFLNE4zRitydURwQWNDR3FaMk9FTHlvNndh?=
 =?utf-8?B?V2hFd3k0c09UL2R6VDFXYmN4SUVrZjFpL0R3Rkw1V0dDSTROR3pUMkdSdTlU?=
 =?utf-8?B?V0lPMi9YcFVId2dJVDBVYkEvd1BEcEJheE5JczFpdnltaFR6RWpvWDh5K1Zx?=
 =?utf-8?B?Sy9BbnFoL3hpeXExSnF0NXVDaFZuTmlJcE54cmJ2RkRqSmlTKzN0bUkzZFUy?=
 =?utf-8?B?VUpxeGR2V3Z3R0VpYUZ2eml1TUlMNXRZQkMwa2I4RnNWZXc4SlJxWmh1cXgr?=
 =?utf-8?B?ZE1xd2lwWVo4YXl2SWo2bFppZTN6MVhYMktaVlRjbTZ5bGxSYlYveStlSnQr?=
 =?utf-8?Q?lXMMHTaPoPVWVlv8TmiRybHwAQvdRwhu1P9C2?=
X-Exchange-RoutingPolicyChecked:
	QCaXjBKcMGdrGCxvL95vArTahQpJbrX05oM92UZwy3+s1AAunCa8GplA2kfdB1hHF6dvHeOeSzCwojRDiIMwtdyVKesC31HbvnEqRz6Rwe4AoWkATi9hFl/1q2X3DvUmP4LxKpZKCUHfsSo2p5+oN7iCLQCNMC5VYqwQaLBZ2PklQxBEq0DeKo8oCp1algK0JACe2VuT6PTB7cyvgZCbbAR0XttcX0Stj/Q/CEpfZg/+H/XOSnMk/MIe0NaPnJGnWMdeaurgu3xTjBM8LCQSgCkF5CdaDA+OeimkhMyNV1WgWxSZ3xtT9EBxF37UuOXoDyQ5+zPwtyJi6hmRGhZZKA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bwCkNpgl/83sAe65YTKit3F/ICCnMsPR8znHZFiXZ5cZVPsnDj2B9/q/O50+9ulG9LgeXYPeeuCzMXzhoJO6H1A6uVxQtwonu7wmIm9FzFwiZS6J/sEyWXchHDLQlHWCQR3GS4sYidiEoqrxYe7+rLglxxx4kzPxyKro8SAKsOxHIwjJ9wt5qtx5pe4ZXWQ8PnhOYSrY2A5pSETvaFnwVeUY9in6eUk4mXnuvCOIQAuUpezL9LdWpkIRaa3dK+rxSoHkYVcKXgwHUE5B408nb4RgvQw1GNVmGRDbsw7cJ7r5IPX6jzQ1RLSxIL0nWl2sB7chcoqYnicVRPxFnOKq3zMHI/4x7k0UkbuTbhrlzOrqu5KMSOXDEo/MaJQwPZhce8DL1xoJ0nSAqoPwcKo/GjSGi2VFpmtRYPqNU0w9iQb2wP7oqHHWNZeR+a4Y3bPBSdgGows/xXHV/Eg6MqsrH1Y4lnVcmzd6g7XFAClXbV2OZkkAW3/ds1NKKn/StTEHmTEbW4ZDCKPE1Se/1MnfMlu4ae9YqY1OuOepubOuGhkmvveT8TV6m4zfER7RsoQubWCLL4Sj7Z3jrjASC/0BsiWT/eIV2ll8MxB/nG7sEpc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330ed9e5-529a-4c51-ca89-08de9a3b8f27
X-MS-Exchange-CrossTenant-AuthSource: CH5PR10MB997695.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 15:36:12.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpqOb/1pzcVd16DqMlo77vtNXG8mF63T9un2GHRycQ2GYSuByQ5dd0FNa21YJGhvX1Lq5fSdah+JVuGRvNn/N7/GQKKoKUlIR1+LHXCPYO08Qqvbt0wOcDxyMrNnBlea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6440
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140146
X-Authority-Analysis: v=2.4 cv=d77FDxjE c=1 sm=1 tr=0 ts=69de5ef1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=QyXUC8HyAAAA:8
 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=mC7z7pk25Lr3GkS95fgA:9
 a=QEXdDO2ut3YA:10 a=y1Q9-5lHfBjTkpIzbSAN:22 cc=ntf awl=host:12291
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE0NiBTYWx0ZWRfXz9rHlWHWeCdH
 jYCuzLhvY9SgfLy7qR7reB6qiSH51DJTgxIM9SsBDnJ1gdmFeQftviD5FVjBJgB0k7iszbhwyAt
 TlXwaRD+ACTP/LoNH9Tebqh4vrCCh7IFGKbbTMqh3mUDRwruYDSpLUdQJHFVfE88RHGfmno7hT0
 wx8QS/uiBQgviT7gnYOOehxo65A1JM4EpWzOXvI7n/nrxaPReJk+DtqK+f8DShP5tNfOeuiRDth
 8DoemZG2yzibIj3j+kdtpfGjzQrPqxMo64mRULIIKpJz7zB/6OpZ5WTZVYETrUJ5Ulgu1HqN4k9
 CfSS1HWImfD5wPV2derkCueR93J9rw1u8d1SmReRkjuXg1cR7yrsAp0/i0/xO3AaKdc9FR4KpNN
 SlBLQeFtmTCuwEXHkxMgczKN4E0sP5k2UeIWRRb3rFpSOqz9Db/CQsZuVRZcoJzMgv0UGg4Q+im
 GADsXBf+6N0q6st7bSIYCURQ16YIpwjJYEmCAoH8=
X-Proofpoint-ORIG-GUID: 1kAttnatRfN5spBTAKqkyA0ZlpLc038L
X-Proofpoint-GUID: 1kAttnatRfN5spBTAKqkyA0ZlpLc038L

Hi,

On 13/04/26 21:24, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 
> [ Upstream commit d8cf03fca3411de8a493dae5e9fcf815a4f0977e ]
> 
> Drop unneeded error checking.
> 
> devlink_fmsg_*() family of functions is now retaining errors,
> so there is no need to check for them after each call.
> 

I have run an AI assisted backport review and it spotted an issue: I 
have taken a look and the issues goes like:

commit: db80d3b2558f ("devlink: retain error in struct devlink_fmsg") is 
not present in 5.15.y, so backporting this patch which assumes the 
presence of the commit referenced looks wrong.

Upstream(v6.7+) has something like:

   struct devlink_fmsg {
   	struct list_head item_list;
   	int err; /* first error encountered on some devlink_fmsg_XXX() call */
   	bool putting_binary;
   };

   if (fmsg->err)
   	return fmsg->err;
   ...
   fmsg->err = -ENOMEM;
   return fmsg->err;


5.15.y has something like:

   struct devlink_fmsg {
   	struct list_head item_list;
   	bool putting_binary;
   };

   err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START);
   if (err)
   	return err;
   ...
   return 0;

So it looks like we shouldn't be backporting this without the commit: 
db80d3b2558f ("devlink: retain error in struct devlink_fmsg") in 5.15.y


Thanks,
Harshit




> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Stable-dep-of: 87f7dff3ec75 ("octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../marvell/octeontx2/af/rvu_devlink.c        | 464 +++++-------------
>   1 file changed, 133 insertions(+), 331 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> index c3da400e87eba..8a63277aab1af 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> @@ -13,26 +13,16 @@
>   
>   #define DRV_NAME "octeontx2-af"
>   
> -static int rvu_report_pair_start(struct devlink_fmsg *fmsg, const char *name)
> +static void rvu_report_pair_start(struct devlink_fmsg *fmsg, const char *name)
>   {
> -	int err;
> -
> -	err = devlink_fmsg_pair_nest_start(fmsg, name);
> -	if (err)
> -		return err;
> -
> -	return  devlink_fmsg_obj_nest_start(fmsg);
> +	devlink_fmsg_pair_nest_start(fmsg, name);
> +	devlink_fmsg_obj_nest_start(fmsg);
>   }
>   
> -static int rvu_report_pair_end(struct devlink_fmsg *fmsg)
> +static void rvu_report_pair_end(struct devlink_fmsg *fmsg)
>   {
> -	int err;
> -
> -	err = devlink_fmsg_obj_nest_end(fmsg);
> -	if (err)
> -		return err;
> -
> -	return devlink_fmsg_pair_nest_end(fmsg);
> +	devlink_fmsg_obj_nest_end(fmsg);
> +	devlink_fmsg_pair_nest_end(fmsg);
>   }
>   
>   stati
