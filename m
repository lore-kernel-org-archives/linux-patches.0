Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D7C4A261B
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014612; cv=fail; b=jmJy3VFNIDsBrWHXy3XWWfJZjaW/yvMvhwNOf2tsoVJ+q1ZPFYrAVp03iXrygaqOpdT4J9afaMjOLR/I3bNWG1x2yLyyrlIPSBT2/8zjSMAQxYZrXauuaimYfSnDbzj/9n+cjR6NLCbaClZ6GYE7/YG8CMBbDGIl8Ad4DiKgpy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014612; c=relaxed/simple;
	bh=2cB73Bj4934WsZYecLPr9RJ92mYKjOJyEMFxFcbKs0M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MirQhxTyV/awpny1hQFN1hqqAGifTE3+rgSDVXz0iH/0XlHHAEI5u6RFFQ/32elGhfeVY2+fvL/VnxiEfEQcJ6JEsp6Ve4RQupCQR5nOhn2Kdq9loLZhjWdu+KgLAdHqTq0L3yGzNmYiKHD7BjqJ6RZfGeWacnO8RnKspjm/eP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G+QRh6xi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bPuOEhU1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G+QRh6xi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bPuOEhU1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELiQqm1423915;
	Wed, 14 Oct 2026 21:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=04pueysSSJX567r3Tav/6o2b00BbYMT+PniakVPR+bs=; b=
	G+QRh6xi+FqWOBL11L5XYn6xs9DuMH3d4kG8NlRpqGA/TM2RjZVSbj7HzUO+yguX
	+iSNlmN1whQPzvuqiTATdKbNcWgvssW55Yhnp48hyIcp5H1JpFRJKNev4XLSmA3/
	cjrrS8gb+jYu3d2a738FFA3cdNiITtglrc68Ib56wZRvPwmWBnZ9rWQMEjOwx37K
	vp7qHTU0QZmgZYgFN50wOGgvNERpRTb0VnPXvC5LINDZdURHJhCti3wR11VGyszZ
	eHwPlDX1HukV0RTgd2SLtxSht24apa9qUPkkbAKRl2hXanuY5Gqy8qIIw+cRJH0o
	kzuD8sVVsEpvr2lQvhSDUg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ha5vghfkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:50:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELafBm004101;
	Wed, 14 Oct 2026 21:50:04 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btr58hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:50:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUT6JKha7LXtvT2Fy+YKU3Zy6ylE/wTaEzF89U6awWRRLBgbz/IQUFyCuXVal32PpXmVIIvyf81vCyqNTlim00CM6QrwrlGYtZ7NHOSBgyal3NWMg6C+rltmTCEpYHon8dItHipNJ10CF8H7BvVgPUAM3nrY9OKwGWexb78qwMMIr8A/wWMFyQQVJbyvQOptiMF54Zz8jtnfJH3o3+7MNOfuvspyb3gRPyi9abqJthBHYCMQr9ydo71WINV6IWlQGyI4VLMKKBnmj6Xfj2/mKEZEtOUjU96iqzIKk6aNTSWnIyI0V4teipZuFHput1m/XPNLxuQWSoKubS2QxPZ3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04pueysSSJX567r3Tav/6o2b00BbYMT+PniakVPR+bs=;
 b=Ol8P+m5zn61auUWJ8ilROlqSmxcCK9fitOD7PkjmtIiH8+lg6gOeQPqL6AzGnbWBuGX5SDg5kIId/0ch4g3XKJpYOJwI98CxMFbPEUvgYbV8W83xvP9cslwSlOR+xlboWOvlheZ7KOjFzq6dX/1yPyKk0pMdkEO7euzUqVzRpWb1jhavwVfwNy4SunXSVEtI8t6g5YvxdITrpS+1DGq0AOCnxEc6rOTOilGYssso3IFVqJORmJXpdrhVSX35ZZolOqiWwd64MACK+MMt+3No7o67eG3VDGGX2Q6Y7nFH2gj8W64fE62SxjgiehdMnsAACp5cMFupm8LX2e++R3OTQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04pueysSSJX567r3Tav/6o2b00BbYMT+PniakVPR+bs=;
 b=bPuOEhU18jt9tpAdmIH7jv+LURgCfcFa5LAe/YQGplF/zmVlU9pxy11C4P7NwkAfSPiUxKnp7HWIznv28ecaRK+xmutfNYRR//hfrtpEnv+ZPzHP1vAP819HL8PiHDhF6z4ECNbm/7ZmsbSDRC9CH+RVuxxs/KYnRmsaVaIVWkQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:50:01 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:50:00 +0000
Message-ID: <cb60573d-858e-4a86-ab7e-05bbce6227d2@oracle.com>
Date: Thu, 15 Oct 2026 03:19:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 465/497] wifi: mt76: mt7925: restore the legacy BSS
 after MLO teardown
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Aaron Ma <aaron.ma@canonical.com>,
        Felix Fietkau <nbd@nbd.name>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112918.916875676@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112918.916875676@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0159.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::20) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 21d91d50-e860-4b00-a3c4-08df2a3d18ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|5023799004|4143699003|261009223027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	USMIKkpsZ/GTCBayEnS4gcsI+LJbNGZxKv6Py8WH7fHXIu30cqFdYPD7sfgeM66NkgSgRjpDTiDT35L6GjA1dVZQTLFEYBbtMQDceOjM4dOkyU2wNV3jtTsPYzLoSF3m+sDq8u5FvfiX8mQMQXEgQ205GLvPL+1UAw+vIJ+OO2ltgfzbZaVj2FFRkKPpQkMkh96UvUa3C+aw1ayDJ5PVe7D4Ac8cDE49kuPAXS0i5bpHnLZ+6DLLpxKPn+fz/P5A0GQH2lKs9qlfzQ/9AGzy+0QdUK/gvYNWsl+h+h99YltV32WCnt8kwsLd7PD+31AKvbYKUXRN/B0LC0v4joaBV5RXlp7+IUFPLTp1SYX7qcMHkBFD8cq0/Vf7Du0kXUiUjYWhnH3cEDjlGGQ6mS4aFHw+HzFCez8CeOlIurKr6kib8HEtCWkftrNgPG9MjmDaigEQOe2q6aHXEbcX4T22wPM8x9PkXPyTKRBHdQOgO/Xz+MbP0p94LSqwy8gKvQSSQtWhzOyh6EUkgSZ9dKkv8xTSdn2utRj/5zL/Jv2GtoRb3G/hXcDeOkROZlaGFdhQ9cY6dCZKxbovgSub21dhoowSslv1odZnnBpDmeJLDzrTIKpyMaB7zYVRqV9Ol5EV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3FlY2lZN1B3UHUxNHJZcThaaVlPem04M0VQTDJhV1dFUEErS20wSHU0aHZ1?=
 =?utf-8?B?VHdrVU1LRFFCNHhNNk9jY1FKK3lWS0gyV09rS3cycHhyVDZsN1B4MUZXaDZT?=
 =?utf-8?B?OTUrU1pjSjc5OWZDWStna05OaDBoa3lpcEZzUUNyQ1VzU3hRNkhBVHg1SkU2?=
 =?utf-8?B?a2xKQVZ4QWwyU2NvK0xLMlhCZFhwYmRZakNpaThucDFEZmNxQWl5REtlT1lY?=
 =?utf-8?B?d2pyT3BtOUlqejNkWkNZVkdTRzZmdmRVL1BFQUl4SlNDNk9EeUE3bkFXSWJs?=
 =?utf-8?B?ZXBxd0dYaFREVndRUGhldWxaMXE1NTlnVUlYMXNOOEtCcDlYaGdzcGV1Yngv?=
 =?utf-8?B?aUMxTjdMMHdKS21DRTNiYXlIaG5NTXFObzB2QkVkeHZVSU1OZ2ZZRFlmalRo?=
 =?utf-8?B?RFBGZlYwcXVXamFiQmNrdmpYSHoxVTJHMFY2ZldEdTVKMTBPR1I1cmd3N3ll?=
 =?utf-8?B?c2dPL2dMWitwV09EdnlsZVEvM0NHMWM4M3JENzFCTnNvY1FZMk0rN1JZZWl1?=
 =?utf-8?B?dWNBQmR1bzc5dm4xMmYycTVlcFdFZWN3Qit0bkVlemFzQ1ZsYWlEQzMwU1Z0?=
 =?utf-8?B?ZmRhNnhlNUJnWjQ2R2JSekhQUUZqbi9lTXp6WDdGR3M5THV2RjM0TTlVTSsr?=
 =?utf-8?B?YXpxQ2lEd3daaUpwMmRuVDlSY1BCNDVndnZpUE4zL2p1VWFDWGMrK2t6Skp6?=
 =?utf-8?B?RE44R1VrakpCbS9YSkN1SXdXdGVEaTJ1L2lsY29MbnEyQ3h5bWhRdjE3a0pY?=
 =?utf-8?B?aGhGNGNDRmFjalUwNjJFN3pEMlVselMydGxoc3pod1NraVlrNDR2UWxMZ0RV?=
 =?utf-8?B?K2NxenpXdDBQSjQ3MVhwdlJWWWdOaGYrS0ZaMWVDam5kcXlOQUhMTG90U0JQ?=
 =?utf-8?B?cnBXclJBZjhHSDViWnRoWDRNM0N0QTdyMTRrdnlwU0orYlpzYUl3UkR3RHBI?=
 =?utf-8?B?dDFpeFpJT0tuNGZPL0NETWo1eWh2Qzc0RVgwOGxoZjlINGJRMDd4WDduTEl4?=
 =?utf-8?B?cU1OVmlRRlNDMXZodDRFRHRwUitzTmlHZFFHVHdMV0FaTW1zWHlzZStQaVg5?=
 =?utf-8?B?S3MrMjh2SENyejg1Y09CVVhtL3VsbEFYRnNlM1RyNHpldEJRaExwOURqRFdy?=
 =?utf-8?B?Q2VRak81Q2dwckRFd0h2SUJZSWo1NE1rYVNqczc4bGpVYXVpRmZUa0p1VXZI?=
 =?utf-8?B?OVoyYWpYbnZVNm9lNE8rbjhtd3QrbGM0amF4RXhlQmhjV0czSHB4cDQxWXFX?=
 =?utf-8?B?OVo3WnVzVlpmM004WUlJZmNWV09USzNUUkNhM1pIcjJ0aEdkcFhQSU1uQ1d6?=
 =?utf-8?B?WEdLOWlpYm1TZUxWVi9lQUFrdzM5RU15YWI0TW13YTM4ZGRuR2FFTVVweFhS?=
 =?utf-8?B?TXUvVEpndkJISTdSMzRwRXRBWWF0RjVNcGZIQzY2VzhkVFBsTjdmQUZOdUVO?=
 =?utf-8?B?L1Jkd014TDg3MTlmMWpYMkRCZ1BxWUhaUmZ2SlU3VTlSV2ZDMndPMGFCNGdS?=
 =?utf-8?B?OWM0Zm9HRGpiNHJ2elkvTE5YM2tkVlZrQ3lSODYzOThvL3cwc3lRZnpuSXpK?=
 =?utf-8?B?TE81VTEzZjhYTXI3dzVTcmZ5emdSSEdQK3lTdGlTOGYvbVRRS3V3b0lMbkwy?=
 =?utf-8?B?R20vMFhFWUVSOTV6U2dmdHRISG9IcmpNUERMNFRRaTdmODJJV3pVWlFOcWFh?=
 =?utf-8?B?SXRwMGlQdTBxR2FQaDNrQ1lKUVNyNEZacjU0b0poUVk0RitGa2xGaXNFTTdk?=
 =?utf-8?B?eGlFeWxudnN6S1ZOM3JvVytJRndWYWt3R2hIU29nM2tvd3dNeUF4T2FuOHRH?=
 =?utf-8?B?dTRDT204b3QweFE1Y1FRTUhzTThkV3ZpVHZkWVBNSmx4UVZwOEh4TzZjL2M2?=
 =?utf-8?B?WDhvMGNweVhjWVJpUnhQUnNuRkR3aVZXRFh6TThZODJMQ3U4SDk5QnhtWWFD?=
 =?utf-8?B?SlowWmx0OEpCdXp6OHpEMWFsaG5GWmVZQk9KbWg3K1lkVFo3czFQRGUyeVNs?=
 =?utf-8?B?YzkxOVp2UFREWkIya3dGcVdkc2ZrUTNqdE5xSDRVd1Y4TDdNZ2JWckpsUVJR?=
 =?utf-8?B?Vyt4UEZ1YjArQ3JaZWlESi96OERiUklpK0s2bk8yQnMrMXNKOC9SR0NZWHM0?=
 =?utf-8?B?OGNrbm1NQlFiK2Qvb3gyazVGcGlVYzlNQWpFZU1YZ1gzRDBUZHJxNllOTFVT?=
 =?utf-8?B?SnhZSUFBNlJUSkw0K0cwZ093RlFSQkE0a1VGSWRQUHVzKzYzMk9nQzdNMi9L?=
 =?utf-8?B?bEVXS0o5N2RueTMrcEcyUGc5OUJFWlkwTFljRGlhYkdhWEo0V041ZnhDaXZS?=
 =?utf-8?B?aXN6Y2s3STZQWHZsK3I5ck5JT21tQy82bVVQK1pyaHFaWXAzWEh5SlhuQmVO?=
 =?utf-8?Q?aC7rrbd+df+Bj2RA1sdOt4cOlBvdHJ73JX8Ms?=
X-Exchange-RoutingPolicyChecked:
	XI+78bQzv/mUpD3SkhJMqCKjy3NgeXwTH3U+HUeuRBOaq03IaNwcXzPwOvqqn2TobhaeL4rvn5pjvVCKB+t0i4iqWHaCGBy4e0q3+O2u9XZXovQ842X9Z3Z1link75/FULQWmZP1gjmq+QmPal1zQstno5KGP2X/n3mwdwv4BmMGuu/AGzMziXsz62hVfS5PT0Ahhio4Ifxqx9QYof+++GUFHC0lOMHeK01+rqjTQFyUW0P6D56q0U07O2IdUDmZgyOqiYHv9PfjvC6C30iYthQC4Zr8OkuPavOI9UodRiELhsWKzB0jtSDG5nY4NER84bwXXO5pF+k9QcwwyXduEQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iKZ96Zsum8vcIpSBINvD3xwvIFY7RDDAOGg+AKICm4Z4JeUZcR3OJsmUP0Od++LoFWR/pzhPQoQ1Fk8s56CgOQHep9FldXNF9kWT9NfP2bQ+x1qENW99p/lZ+l6UIAXRUkCXAwttUoWx2/cywKInApgDsW1Ii/Sgh830c/ZIsfAQZfBkku+GI/Hghtl2yj9jlYOZgTlajFS6LhKHv7BhyRqn7xYefbwNQ4XhaZ+eU87qFg/W4z1rIndgVHIw0V/aPT2bIkVotS23Z4vbIzcmNBl8phDizDAzJsZu0VZ2rhhVsCfI5yKf3ISrDA9A8/OOz9Fdg52Cf3jCrrvfIStq7QX45TEJjtFaW4nv5o0AGXo2EGdhpjvkC4fTalRAld8C9UImqVXo5vvNxJawkIjDgW5QMcuhXsLZJdohpLfj03ZWPE8iYrOnmSfI+en6i66lKcRQjwqdGn86dS2WG3fa3/Fz/i6ApeDh+Bdt7dQTNuAHcTB8JSDw+6X8AJk8ZtaxgyOO1kBnvqhPKaDqdjVe40HfzQks47S1eTOPRtGIMID4zZRYYRq58prR71+72eaRpq17Mr4yvyLLQr449/7FSVX+fD1a9//iZaBt1agAPGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d91d50-e860-4b00-a3c4-08df2a3d18ae
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:50:00.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIT3Bav0OZS4COCcdAO/90nuwPqq16Tu8xDkt4oCigrgOq2jxmZBQgWrvddsRfZoDnUxdyLIPxmdDZxdJAmbSeyuxEqgVDW97uj4iH4dJuJwudvPW8vDJhAo1HhYR5VV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfX+awdmSnFvdPv
 q6dfcuQMMP0MTVsg/LQnCMn1T4lH6QO48Gbb/2RQJItZGlQRHCjEF26RvQPX7qHPGZTSA1oCbTZ
 LhmEWuWhKEDI8Cssk2YQvotEAkr3mHAAKNOEN9a6paLOP+OZLyrC2HX+gwHNpRsXoaK68vOVVoc
 sjJVLQT8Ng/NH/z6XDZgIiAqLRscnKNjZ182p1JGwS4tuibSmQm6/Nt3Ml/h/oN6QrJdTcAle89
 yRLeFXiWIcPXlQp5REH2jc+nqp2hageaOh/3+FJ8qJ+ea42haXUBJke/rhyrQqm4OBYHQkAoU8M
 NV/Un9qVC98PpyaqSTHzWEIxLQE32tLtR8YonxtNm9s9kY2av7o6+S656fvi1Ub7WeA29bEVeb6
 lq96FSxbf3kI2t9lt/zwlVqE9jgSM9+DdZxZMw9DH8W2xHdQF4dIyTQwlZhKzbh4XauUPRpTniH
 jAPv79V6isSexacHH1gPJV9CB+9IPbFC6uW8N4sQ=
X-Authority-Analysis: v=2.4 cv=OtvaWC/t c=1 sm=1 tr=0 ts=6acff90d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=aFtKqXUbm5dSz7Zz0DMA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=rjTVMONInIDnV1a_A2c_:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: -3YuDEoi52UXIFkDTNfSx1qkuftFe2Wq
X-Proofpoint-GUID: -3YuDEoi52UXIFkDTNfSx1qkuftFe2Wq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfX/LaooIDv8lvm
 /UGEcQGiyOCfXbN+Pdwf/TEUCZI0+/CL3kTa6zJ+csFJWi/SfxxpOYVB4QpP7my841zFe8hzlw4
 HE7W7VRWoaR5dbtqZ6ek3RCiwsJ8wFr1UUimEqrIb5+HKZcUan3G

Hi Greg/Sasha,

On 13/10/26 5:10 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Aaron Ma <aaron.ma@canonical.com>
> 
> [ Upstream commit 8f9e5807671ee97cacf1957f4a09e43f4f1017a9 ]
> 
> Removing the last link of an MLD interface leaves the firmware with the
> MLD BSS and DEV entry: the removal loop skips the deflink, and the
> hweight16(mvif->valid_links) fallback reads the stale pre-update
> valid_links, which is still non-zero. The entry keeps the per-link MAC
> address, so every subsequent legacy association fails authentication
> until the interface is removed or the module is reloaded.
> 
> Remove the deflink BSS and add it back as a legacy BSS on the transition
> to zero links.
> 
> Fixes: 69acd6d910b0 ("wifi: mt76: mt7925: add mt7925_change_vif_links")
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> Link: https://patch.msgid.link/20260826043658.2255553-1-aaron.ma@canonical.com
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/mediatek/mt76/mt7925/main.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> index bcc5ce829169f..deb226cf5413b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
> @@ -2079,6 +2079,18 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>   
>   	mvif->valid_links = new_links;
>   
> +	/* Restore the legacy BSS after disabling MLO */
> +	if (old_links && !new_links) {
> +		mt792x_mac_link_bss_remove(dev, &mvif->bss_conf,
> +					   &mvif->sta.deflink);
> +		err = mt7925_mac_link_bss_add(dev, &vif->bss_conf,
> +					      &mvif->sta.deflink);
> +		if (err < 0) {
> +			mt792x_mutex_release(dev);
> +			return err;
> +		}
> +	}



An AI-assisted review flagged incomplete firmware teardown in rc1 patch
465, 355bd6fda826. I compared the upstream error handling with the
6.12.y tip and confirmed the difference.

mt76_connac_mcu.c, mt76_connac_mcu_uni_add_dev():


Downstream 4a8beb0f1e36 returns on any negative BSS response:

     err = mt76_mcu_send_msg(dev, cmd, data, len, true);
     if (err < 0)
         return err;

Upstream 8f9e5807671e handles inactive-BSS teardown first:

     err = mt76_mcu_send_msg(dev, cmd, data, len, true);
     if (err && cmd == MCU_UNI_CMD(BSS_INFO_UPDATE))
         err = mt76_connac_mcu_bss_deact_err(dev, err, enable);
     if (err < 0)
         return err;

Channel unassignment can deactivate the BSS before the new
zero-link restoration removes it again. Firmware's wlan_failure
response then skips DEV deactivation, while host cleanup and legacy
recreation proceed.  04222f980301 ("wifi: mt76: connac: tolerate 
inactive BSS deactivation") supplies the required tolerance.

I think we need to queue this prereq first before this patch. Thoughts ?

thanks,
Harshit

> +
>   	mt792x_mutex_release(dev);
>   
>   	return 0;

