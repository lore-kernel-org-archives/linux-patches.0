Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AC53112AB
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633062; cv=fail; b=WvKrACcsVL1qvqzRj9dTcOd9NSwQZ9JKEsIfvFsaygwimuqvo1yI54dEvVGVdv8PJwnsunqcznlTNyw9Oc1aORK5I1G1S1dqats8RLLPOZ+IDbKqTIgnbmbKLd50MVNHSMi6J3GKCnsf5W2UijRb3D7o5/kIlsdL0WFwGZQvjxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633062; c=relaxed/simple;
	bh=ax5mjKLH3ys2tKeFoR4+CCBzQRIoLrXNxifEgvfWero=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PMP6yJW3M6adIiIp3gRlLm8E502PrBAdO0sFNI0Ji57JfJKxRoNL97v6QiXvukLV5uIYlasWzrHqlN3Vkzzw71H1tEq+QRRIbuWjBuF+nzs82WM8CT+nrMrLNXgrcS21+MPwlWBM46WdEuJZ5LUkNb4/BHSCs64IS8OUwtcoKr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=exbXE5f2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ITohJfzQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="exbXE5f2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ITohJfzQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685GMw3V1886049;
	Sat, 5 Sep 2026 18:30:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YeRFpfcVkQyPeF+wnjssN9LllobBLfJKnY4GEV94j4M=; b=
	exbXE5f2gpCJfWOj3vd7DjtS5umWVkMJDXE6bQBvvqLshWAl2dJsakPlfFEYzSB1
	vYEsyCwq/fU2RU8vPjrG7cTjAA2gJyyVqM6KMNdE0c9WZ6nvzcrv4lI/a86SUcsS
	BRp2PB4I2qJEzbtadcBMq3V7e1YWthrFKt45N9QKPMlLw+SN3Q4/Wocte589N4Qp
	iaHy9y96LxgPNi079FCwXgGv05v1ejutdErn17MpROMy5NyW9JAIVls0XpQNFxls
	TIBEOyR/yn3b1wpqR3Owr4RPhUd9X1T0yOIIk3c1JRYeSkir256sENm62a/oPrxv
	ArfmDNdbCM/brKufv8V4cA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbh08cqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 18:30:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685IPrCp026798;
	Sat, 5 Sep 2026 18:30:53 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012003.outbound.protection.outlook.com [52.101.43.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hmns19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 18:30:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ab0+H9LUAZkn8qsZneIdIPDwDyXqWb3QZtkR4POTAYKrdLBwYjBvlVkQ1kf196jP9iFP4i4YPstGor6QhnOceddQBNH73siqiEk4IGNw3F/qvK6DQocmfuMfIgQUiahPri2XXIkyQS/euXzGOja1Eaif0yGxqdBkbet07m4hnEVJORMoEV+3FoTFuMZ82A4wUaP7a/nf2ZgDlaj7z6S7V7fdSwRXuIuCkEy1/YDvFSUf4HBNpxMxl8WUmyBGCf8LjfbbrBPGQs50/daFVqkNRV2AFkliUFoFJPAJG6crwyW0TCKS1B5n49H9YzEpaeeBV2mMbHlglTGv8OaMKagcpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeRFpfcVkQyPeF+wnjssN9LllobBLfJKnY4GEV94j4M=;
 b=MHVB2sYq5U6p/UUtczx3r9p3YjwTF6mCh0euuqvSgFqPfTWThEN2nrmLCWN+PVLABNQuyYVkGSIVls3XdivxuzSVRjnQ803HBwh50BiF8q72JpEzUMZ7kqpdQB+kDxKz3d8iG6c6QP/ouEN9VEZ1G4LMID5yxWItPCDfezdruHLwZS5eaHHdkWxo7KyLJVneA9hP+6Cbf2eNBkPZ9YDenke/CTbI8LAFL/02eisf1fMjreA3GSvqOrWyEgje5QKX68s9+JKr5j888rYST84/Th+/xF6K6i8LtwGmbbO5JRrHkVBZY9fRYFQ2OY7pP2wmmG5G0XwD0SRf+NicKQUIdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeRFpfcVkQyPeF+wnjssN9LllobBLfJKnY4GEV94j4M=;
 b=ITohJfzQ9RBaJgvXxnaCDceAY2B/ZlcGyKmMqs+oRGiil8VU0l2fm1XGaZ9EkXAbOVcgncCF3FKZNmCDHwK18uMqziEUHgL6kKWX2ALpIlOB+LoHLiyyh+xjlvsx6imYpWcsfvAkcRXuRSGGRHnAmFbefpYc19uuk+CcYEkp5JQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB7521.namprd10.prod.outlook.com (2603:10b6:8:157::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Sat, 5 Sep 2026
 18:30:49 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 18:30:49 +0000
Message-ID: <7da02d81-ebfe-4448-b6d1-9209cb9282fc@oracle.com>
Date: Sun, 6 Sep 2026 00:00:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 348/403] NTB: ntb_transport: Fail TX enqueue when the
 QP link is down
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Koichiro Den <den@valinux.co.jp>,
        Dave Jiang <dave.jiang@intel.com>, Jakub Kicinski <kuba@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045742.729378177@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045742.729378177@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0618.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB7521:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bd98d9-0bba-4861-afea-08df0b7bcf15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|4143699003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	STO78rgw/5XytI+VocI/klkxbc0z0Hq50+I/Wwe/MH/axxNuIspbzScIqeIjV+4YKv7VGiq9kCMWwKzcGs8t687LhZ4a4X1XNl4s7yYr3f0TH7jjVqTOuqLS4dVrJuDG0yikYHQgA28OjLeTV1HLrHc8d9QspT536QDy4yUh43n3cX25U4g6qQIxX36nDbs+55LxU8TxPtJxxfFnuhqUuiCiRJymE7Pag5hpHhWPj7S3SOfXyiU7D5gXScD/ipqVCD3Qfo1Dl9NNcGLns0DhCyWIubZEHgZdICYDGQIP0IknIKgGsYmrMa9FgeQDlANPo0AHrqVVPhy/+d7Q/XpEmEsRYQc7yRCd0RWNOcnekrZhRmjb+xcR9xw6ahg1VQsJEFwRhugBEdbMQoFEOAGtPRhfqrvJqQ2nZWML52QnbjRGdUE4LrIhU/zql/LVKeLp/fU2wrB17mBwjXYm7hC+RrSg0HYucyAFpuicm3IVe9fxnYzs9yvhbGnQfJRcot318IeuKRuBCIl+UOor6Ji1uBkBraCBgn2BKFGwPpw8Iqy/C5DTLH9UjeAyyOw0mzD20aYPt2rFe90vWJ5s5cUaZqcSykKH8dv/nowoSU7KzTSgmuezJWoLEVSjFqTV9e0L
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(4143699003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUROeVhIbmZZWk5ZWlNKRWVqU1JjdlRCTWZVRW1UZzBKR0x5YjNPQmRkRlo0?=
 =?utf-8?B?blFGa1NodGl4eEo1L1Jxc3dhK0k4S3FiQTNOS3c2QUJzNFJGOXhhRXBIMlJ2?=
 =?utf-8?B?YXZrWG5qNVhIVWRUWExrdUJnSVZzNlVrM3FIN2ludDBQYkVucTJKaXg2TG9I?=
 =?utf-8?B?NW45L3YrcFZYeXR3OFJBY0tPSlQ0b1lVVlIzakRJbTdMVW13bjNmQXZZV2xy?=
 =?utf-8?B?VTNIaFdGTDZZUGlEaU9kVi9ncFk3Y3lmMms2VGs4eVpXalVqdURvSCswQ2Nl?=
 =?utf-8?B?UTFRL2hDWEhVZnFWNm1UNFpaMWhoL2xweWZPM2RhSWNZWlRabGZIVFZaYjl6?=
 =?utf-8?B?NG9QMisvaW10YjJhTVlpUzdnWXhSTmh4eHYzMlVpQnlvc3RyVEVEL2pQSko1?=
 =?utf-8?B?SGgvQzhmakx1THBYUGpJaFBhRTFQVkZxQmlPQ2x4L3lnR2pmVWc2cURSWStD?=
 =?utf-8?B?SUNydC9PRXM4UkgzcUVuK2ZBRURZVWkrWTIrYTZDeVJHcGpuZDVWMThGaFJX?=
 =?utf-8?B?SUNjanZiNVJYKzNWeWg1a2lMN3F3dUE3UXlUY3ZVanltTVMrQ2V4REY2dExI?=
 =?utf-8?B?YnVGTGFwaXE0OHEyOEpXTGptTjlxWDB1WFRNRThZZTVzTEZRcFlaUWNSWGp6?=
 =?utf-8?B?R0FQQVR5S3RFWFdDNnhKWDdkbG5EeUJJYlpVVmJhWHdJTVRmcXRVSnE1SUMv?=
 =?utf-8?B?RnNYaUJuZ3JaWDhyb0lreTF0MC9zTDAydzVwcEJwcjJhTEtYMHZTeXpHR3Bn?=
 =?utf-8?B?dnFwRmhyc2I3TkRreDNWdStuYVBxVXordGtUS3hldXE4NWd2V25rRldqQWJW?=
 =?utf-8?B?QnBPUUpHUGhMNlBlMzZVTVZmVXFGUHBITk5PSHFnZm1DYlVSOTdzYjN4TExM?=
 =?utf-8?B?OFAxYTZHZHM0UXFCMi9nUUZNU0NDdFpWamNPUkVocDN1YjdBNUdVcmlCTkdF?=
 =?utf-8?B?ZXAzMmE4ZWhGSTRMTS9wbzhzaG9GV2JZaGVHcDRQcjYvVFVtK3ZpbzNrdXZw?=
 =?utf-8?B?SlVHVDV5bm1HRVJNeHpyY3ZDZmlZeXZUZEpYa1NqdXg1a0lmc2IrZHl6OW1a?=
 =?utf-8?B?TmJxTy82TGRhWm9yQ1pPOThZdkY5d2tCYUdTRE1YYUFNVzRmZDh0L3FwVzlz?=
 =?utf-8?B?TXppTzNZZlJuc2RQQmVBT0NsU3VSU2ZkOWlLNk1CMjg4SzFHR2MzSWZpUnAv?=
 =?utf-8?B?WDIvWlRWQVlFRTlzekpQeXY4NnF6aUdUeHptb2RhOWJOY21wRFQvNjl0NmpX?=
 =?utf-8?B?K0V3OVpZdzAvNGh5QW5nZ29TRE9lVXp1c2t6citEOWZsbkROTFdFQ0Z1Nk55?=
 =?utf-8?B?ZUVXbjl0eklDcHJXNm9ZTDlNZWxaWkJDQUNUdHVOM2FUTG4wLzlrVlRmZ01h?=
 =?utf-8?B?U0ZDa1pTK1VUcGpxd01CUUJPM1NONU5KVWpLL2JXRzRFRGxZMU5Sdyt4c3Br?=
 =?utf-8?B?MGlKckdHZWhFWTFjbkI4UWRjMnJqcjc4VDNYZFNtYzZ3aTdqa1d0R203VEE2?=
 =?utf-8?B?cW5WTVJSV0wwOFZ5WnhudHVuVFlXanc2ZlJxcjFmM3RnRnl2ME55cTdXazh4?=
 =?utf-8?B?UHBwYVd5MytHQ2EvUi84UVVKWmNLcGJlNktSUkpuaDQwZTJNdWlzVjlETStt?=
 =?utf-8?B?dGtXQklFM1BxRjFjVERCYmZHV1hYTXVsNUpGSWpKbnlwTStRRUJEbUt4MUxS?=
 =?utf-8?B?Q1lqUTlSM1QwQlhrMDRVemgrdEZaNld6UERpZ05CUlMvZEkrei8vajY0YzZh?=
 =?utf-8?B?aDdmNmFTa1pwVU1PbEVacUpWdlR1anNCR0MzWlBObE83TktRTW8wTk9oNDZN?=
 =?utf-8?B?YjhWS2k2Umt5Q3dTZlk0MFFHc3NuUllXcWQzK1ZLZGdEMnFDV1JFWnlES2ll?=
 =?utf-8?B?d0g0QVpKNlRpZ3dNYmY1NWxuWGRWN3o3bGMzWkd0ZG0ranpobCtUNEdmdVFC?=
 =?utf-8?B?ZkJvWFZ2MU91RW9vZk91VnJvOUs0Y2RtemZZQWZZd0pDekF2L2pMVXVBV0dM?=
 =?utf-8?B?T0pYTTlUOEgyanRRK2VGa296NUM2VnZhQXdyZlhXckM3L1NIZjl5ZHc5cyts?=
 =?utf-8?B?SVdpalRWNTVQMWZWU25IZ3pSd2x0cDlCcXpvUkNKZVBPQ2hMRExib3YyNlBr?=
 =?utf-8?B?SlZSQzlzdTYrVDhCTTZaRXlwcTZXaCtmQXBWRUZVUVhOR2ltVFN5MjcrOTFo?=
 =?utf-8?B?R3JVaVBJZG5qL2lhUFJVUFBCL2Z0dnNvRm82RTh5bndQZEFvSzArM0xRMStN?=
 =?utf-8?B?UEd2N25qODUrVnl6ckk5N0RZV1krZWVJemRrS0RudDNpcjM5ZS80b0dzcU9u?=
 =?utf-8?B?VnVKVHBZdXVCSk0xY0RhOWYzYlN1V0VDR0VXUS83bjN0SExORzVtYnBBMEZP?=
 =?utf-8?Q?8A4YOzjRULRCIbNfkdzUkueFH1CcN4CzdbU0N?=
X-Exchange-RoutingPolicyChecked:
	UVlgQxxMyNQHeXrJjIXl8M7rXOYoCghHlzO/Uzrn9Me8g98rG0pBWRS57A9+PzAILEGXNQTqld8MNKxXSO6brPwn+qISmrpy6symWWVlK/DhZG14DK+MavF/VY0BhnypxKmd0ylTIEe/M8EWSvqJaZhPJCTiKPYwymzRU1jNT92GUvWpcm0KqlO0bC9rVTwem9NQpPzhpsBOReZMo4IbS0ZHzF3tjnidmkDHh+FvlqBEYLi8b+J4i9pnSwzCjH5+dnb1ROrW6ckPCOQOeFx/SKBlSeCzZzkJ59JeAG53swDkYhYHypYqjJUYL7jtUJJmC+h5CqODKX/nB5RFA5zl5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F6VbwIQ3a+EpogEhYdHFFcdajeSsEBt5TP3bOJ6RteGPSv3BApw/zLLYFHKT0vazkWAYzoAgQb1oDMG4m02sQUzb2sTI6haLNfKWZFyXwsFsA4VCWdgpvE9+HksuD7UlhwMVoMvawekfinR41qhNKoPxtCwIcHcKYfTf6HiypRVyhRleW+l54eOh5hHeH1E1iqlAxHO5NdVOCGV0ma7ArkERfDKWJsLFG5pxvwFQFAfRbbDR4FBZXZczpj8wrdJcCAjhh0S3uYCvobPy/DeB5uAra9oTlM4l3TrY8OVVqJ0+fPbfPHrcmNGrLDZObH3vu+ldH8+Nq4SCft1MJCHfFJM7yj3O/SwiK/MQ+v6ENTBcEpJMDGRZU+WA3i4d2gshnKOZB3dc3XD6Z+jEV47p35sBqSE/iwYBW2Dgl0rHcq7Ld0UAtOZ/g3nZdu0wK1OwPD59eFROpFzIt5fg0AESil8Tl360TwaOqvhM358cnjRUCI85FZHkb/777b9kQeXtfQRZ9Xb3thj0Nw+UqqW4TUyMrZzs+VH6utgd3SbnkDxZaWu2PimC8EfAQx85KyT2Qq4/rtWhnc/xRnnAwbp+KBnGhDJ6BZ0X7mpeT2yW0w0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bd98d9-0bba-4861-afea-08df0b7bcf15
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:30:49.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERRmXMxT33JVHSYU4Kj05h7EVOCV9Fzaiv3Ipy5W9KkJ7rk1yO3mipif6OPGjZw/J6hj0MAPPwKzprKxMbu5tSB20B34hUpQKjNKdzJzRot5t6Mnv+9XiAucfjdnoVD5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7521
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_06,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050205
X-Proofpoint-ORIG-GUID: TQVSKUz8qLEjTC4VKBBw9emyVaAbWfQK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIwNiBTYWx0ZWRfX9Vvo7iN5zZR+
 gfWXvHU8pcMvbFFT7mBb45xtCQwUjfUxv3Omg/C/dyZIoSPytryUipiNJab6eoNijQh9VtiQtCi
 qTPpmN/hMuwXxRUDIV8L9RiZ2E3QSu5Xac0rLIgX1KzGkdwS2c0EQfcK/sCLMkeGx3QQ3vjD4Y8
 N4ECLtsaS9MYJ6OuXe1mrQyA9OEDdM1uTkflC9RjhE39DkDjYho5YFuo2mHGvzKbdtpoAfOftQP
 K3Tu3UiaNLxl6GE0Sb/K7Xx46pLqR4CeIHJHuRyirDDRoxClCM7MRkHYL0h2/peW0TIVc/pauiu
 DIjvsMiedsFDQgxlrDn6z0dR2ch+H/jDVKeQoqaY0xsQhUPTR5tHV85PkcmEDw6BwdLoSq4nQXI
 iBVRZGhCy06TQCG4myChz+I1LAkYHilGPBYrp3pClGJKM24FXdrgj2AfKHQhg5nLm1y/zm8Hgco
 huFokuVavKiMbFvJMhGWq2LTqpY5Kk/tNR1i8I5U=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIwNiBTYWx0ZWRfX4VvEF7Rm+ixz
 wfvKpqOlfqem2SixsdEYR/o70yK9Szu+W+SXFjrgJsjgEkYF672ORt+OHB04RlSGWEqmQ5eSmQK
 cAFSB8kZXEPMLmmxUNC5fLcIb//TURXNPDZgjVAntvKz2TgD09as
X-Authority-Analysis: v=2.4 cv=GKE41ONK c=1 sm=1 tr=0 ts=6a9c5fdf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=xxdg8OVw_nsrRIkAgIcA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: TQVSKUz8qLEjTC4VKBBw9emyVaAbWfQK

HI Greg/Sasha,

On 04/09/26 10:32 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Koichiro Den <den@valinux.co.jp>
> 
> commit 873ce713fef5dde0939220f04f3484ec86a16fba upstream.
> 
> Commit f195a1a6fe41 ("ntb: Drop packets when qp link is down") meant to
> make ntb_transport_tx_enqueue() drop packets submitted while the QP link
> is down, but it only returns 0 without consuming the packet. Zero means
> success by this function's contract, so ntb_netdev reports NETDEV_TX_OK
> and forgets the skb: nothing queued it, nothing frees it, and it leaks,
> one skb for every transmit racing a link-down.
> 
> Return -ENOLINK instead, restoring the contract that a non-zero return
> leaves the buffer owned by the caller. With the preceding patch,
> ntb_netdev frees the skb on non-retryable enqueue failures and returns
> NETDEV_TX_OK, so a packet racing with link-down is dropped without leaking
> or entering a busy retry loop.
> 
> Fixes: f195a1a6fe41 ("ntb: Drop packets when qp link is down")
> Cc: stable@vger.kernel.org
> Signed-off-by: Koichiro Den <den@valinux.co.jp>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Link: https://patch.msgid.link/20260817053519.4135287-4-den@valinux.co.jp
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/ntb/ntb_transport.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -2307,9 +2307,8 @@ int ntb_transport_tx_enqueue(struct ntb_
>   	if (!qp || !len)
>   		return -EINVAL;
>   
> -	/* If the qp link is down already, just ignore. */
>   	if (!qp->link_is_up)
> -		return 0;
> +		return -ENOLINK;

I have run an AI-assisted backport review and it spotted an issue.

Upstream commit: 873ce713fef5 ("NTB: ntb_transport: Fail TX enqueue
when the QP link is down") returns -ENOLINK when the QP link is down.
commit: 8aaa47351db0 ("net: ntb_netdev: Fix TX busy and drop handling"), 
makes ntb_netdev treat only -EAGAIN and -EBUSY as retryable.  Permanent 
errors use:

     dev_kfree_skb_any(skb);
     ndev->stats.tx_dropped++;
     return NETDEV_TX_OK;

The 6.12.y caller instead sends every nonzero return to:

     ndev->stats.tx_dropped++;
     ndev->stats.tx_errors++;
     return NETDEV_TX_BUSY;

It neither frees the skb nor stops the queue. After commit: 6c34659c7712 
("NTB: ntb_transport: Fail TX enqueue when the QP link is down"), 
-ENOLINK therefore becomes a permanent busy/retry path instead of the 
intended one-time drop.

I think 6.12.y misses commit: 8aaa47351db0 ("net: ntb_netdev: Fix TX
busy and drop handling"). So we should either pull in the prerequisite 
or drop this.

Thoughts?

thanks,
Harshit
>   
>   	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
>   	if (!entry) {
> 
> 
> 

