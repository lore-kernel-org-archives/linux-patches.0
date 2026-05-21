Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9917F3C415C
	for <patches@lists.linux.dev>; Thu, 21 May 2026 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779365314; cv=fail; b=O1g8g+w+zObi2FYpUCHI+CFEnOco3CKEaLAJk406FCd1JdKmq8okeqgd5A2+y4DYu/u9QWtH0CRaRSETOdlrJeDgKxbjSLLXcwRJivxV/FQt0DfOSDJwvAT4RHjP3/gpCSBRoFZDfAZuWZp07UPGoWxIzltRXEaiuOYUHPyvvas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779365314; c=relaxed/simple;
	bh=h3vKtXW5uPn1iwmSrAG8qqYVZwbpsD/VNQ6CvsulAcw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MQMMZL9IE4/IXFPnbpklZUULSy4hlB6c7OKrqRdAVjyeGkpF1DkhfTzMYW4FFFiY+4KuNFGjIiO57eMNTqi2tdAkyrnFpi+97k/CHDCFcmbXv+eHV+KF9bf/pm2UCfv76MmuphGPHags15+qoqAewt0T2Ib9oFdBnQjUX+4bEXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UpDa3JF1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ng/8rkby; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UpDa3JF1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ng/8rkby"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1MvSX1057444;
	Thu, 21 May 2026 12:08:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4ecE6KGp9rRPKR8l2hpRnaGZXPzEptoxsc+MTWSIPMQ=; b=
	UpDa3JF17AoNAuD30az6piydftYPSeMI9rhrnT27m7imKvuSTMc+o/gG2+WthZcu
	s8QH1puv2wjvrGXtC1KizuyMdYUtcfF6Atv1JRA8hPlnWKpTJFdhbplcv4bdVLEw
	jXvmsha2U9hyOSTWIAyFckGgAlVU3QII4VbvHiHICgBt0ghCCHvE53diYWfcwPO0
	DWVGrhf5C0vbtfskMgXPNfJxuh5GvnAjrqFGjVOUUk41kM0aVjXliWvqYROcCqFX
	Zq2Nmzy6kijd+BNqTgXXy8HC07QFp1jueZeUgz18Ml+bnvuouv0PjGcPXvs+ZYF2
	TQd8nNkll8w2zZTRxt0E0Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h2cs20e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 12:08:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64LC4tKL012617;
	Thu, 21 May 2026 12:08:09 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010040.outbound.protection.outlook.com [40.93.198.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1jbw8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 12:08:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jIjITvQV9DEewksoEyOHvcpMMeytAi77NiPcFPnL0EXcxa5Wtww+dDSwWbbAYwQkcz6Y1kOQyAi6M3wihjrfA65RRICIdt25bmhiprVaFcoLeNFiuMz1/onRAzYzG3a2sC4n2oHAcxmkh0tq/KR7jbuwnhxv9wbEHwI3RBxXrTEiTMdFdTSIbFyT5p5nuedFBfMQfgZc45oxXbmTQ0IvWBuINrhxAby9hwT5KgCN24ifgxVj9eh+WqLX/MyLCXVMAF9l51pjtfpvfP3JOjfqi4mq3UN8A4oME9mXQ05/rH+YPEYO76eE6yNkgRndY3AzFRsJQCZAvCU88qGZZ3Fhpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ecE6KGp9rRPKR8l2hpRnaGZXPzEptoxsc+MTWSIPMQ=;
 b=GbeGccPtPZzKohrxX3sbL82Uy3+ZkKxIqvGXRJ3v0rLHq5d2YFUGK7WObRvlYy5e/W4J2HuYkf0bM0RnFaU7FeiF4USHi1FCV5pLyhcnaa2+thkpuXFnGUfYiyxYtobcMCz8hxLYvnU0MCWl9AQj3rTby9LeY7hs6ORpjTnTndWkTDI+JY6nyp3ooJWjRmzP4FBYQBCnbY5NFt2i+kN738VU6AprcARfa/wTXwFwEneEH/ZGH8EZA8ntu97XyfCabBIx9TNugCkuwz/dnDgHRfKZI7r5JMcVsuL+LuYYGNtF6f9pk7KG6aQ0SI357CbXu90NSBPYfveJqp8BE31VuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ecE6KGp9rRPKR8l2hpRnaGZXPzEptoxsc+MTWSIPMQ=;
 b=ng/8rkbyWZW83HckT2aCTAkWmRSpoXTQaGYHCg3SCRm7HbKpbsV49Xw/6mFmBDrR/QgTI2/BwoSh/PtKtAUAIfpFMIKRCwo6JtKHYlWrP9Hi3DGuc61pDN7mIO/DmUvkgrVHbdicyaa6UOf/pCrNcu8J23V0whjU2efvzj+A490=
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6) by PH7PR10MB6676.namprd10.prod.outlook.com
 (2603:10b6:510:20e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 12:08:05 +0000
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83]) by CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83%4]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 12:08:04 +0000
Message-ID: <b89ee075-8a08-465c-820a-dbe0b4e7217d@oracle.com>
Date: Thu, 21 May 2026 17:37:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 354/666] libbpf: Stringify errno in log messages in
 libbpf.c
To: Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Mykyta Yatsenko <yatsenko@meta.com>,
        Andrii Nakryiko <andrii@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162118.906982302@linuxfoundation.org> <ag4vSWzIUCsRlpKv@eldamar.lan>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <ag4vSWzIUCsRlpKv@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0191.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::16) To CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH5PR10MB997695:EE_|PH7PR10MB6676:EE_
X-MS-Office365-Filtering-Correlation-Id: 347738e7-962b-4c00-6edc-08deb7319cca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|6133799003|22082099003|18002099003|56012099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	JRBsIoJ0X8NJk5+gAVFsm7jBvCXP26u9pzem/5Kjnj7jpPwJHAi1c+8i7oxfkgveyzp1rIfYjGsnlQrGp2oSgST6g+SEEnm6ev0VHRSHdYVXYlWYYSXKqgj0GJ5HcQ1KA1Aqc1JH9oT/49JdmanJ6kokkvGGTmZ+DanYNyRHnpJepS3b2dbQkpM4N2++iTkRnfQgfQnYxT4+W2njs7hXdmDMnz21VVoS/dbTBXvWrOtY0A5NKiHyI45cM7LQ3c+aQCg1HjvLNlHUVuuJCQBISJXZ/TGCtRQqo+HESEkIRYJFxJ65v0LUotmpSzHdhyCmZk9tMXo1wWV9jpTvV1rgWUMaXF2DA/rYfomp7CL3K/Cu5lrODxrdBLdBk2TyLvvLRfyjoYv4I/Zg56XCgMkuSbPfon6puHQJFW+fMz8pd8P9knIOUqXa9X1Zkuy3kWpg6toksWKDIoDWpD7xb+af5rCz/uZQ+tq7vV9WfA87k5umDkh4y/4xxH/DGZcUtlA3mRJbUMewg1h09iVOxOR8yLiUvVETXfO6PjU+XwD+OQHOdebsv6Pny46lm+tz2xgU9Th5wu82XhyRpJ+z1pxqBX7XAsHZg0IfNDi0PgBmMSyY63YdzX/mKPp2JAEPugkaNtoqYxMqB0hv4wwJ+vuxMVaPbFxWLisa0eZB9reIWZ99ek7Tdvqhk5IBdG7El7D+CQmyQ5+g0L0gIL3GwPUdMQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH5PR10MB997695.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(6133799003)(22082099003)(18002099003)(56012099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dldxcDI5c3pjRm40Z3U3VHRYQXYyUUNtQVpEUVBCZGhpR1F0cGdnN3N6UGk3?=
 =?utf-8?B?anlJbkJOMjZCRnRQejhxMDNLZ0xMdXEwVzdNSHc3b2pOaGRSOEwvayt3cXBC?=
 =?utf-8?B?SVhGV3FKejNUYlloUnR1WHZFakhFK0R2Q2lqOExlYkVUQmVjYWkwa2hxZ0hv?=
 =?utf-8?B?SmhnRjhOZ2FoajVhTDBKRlNZODlYcXdneGNLNFFTL2pJcHVWbDkxSmwvQUVS?=
 =?utf-8?B?anZDRUN1M2U1VUNRQTJYRTh6WFI3c2FnNGNvTDlVZFlvUzV3UmhUakcrUkIr?=
 =?utf-8?B?ZFNzZVVFK1JINVBZbjJwL0FxbzFwckw0Zlo5Wk9EZVkvQlFmTi96dk5hWVFz?=
 =?utf-8?B?cnBjbWVLMGZNaU9JYU9vck5lMXhsTGhFYmoya2ZnUFRScEh5WFZlYlFiemkw?=
 =?utf-8?B?RDI4dzdMT2xSbFg4RzhjNVVwQ2U4NVNMbnF5T2pEWUJkL3hHQXpScjBZNGlt?=
 =?utf-8?B?TllFTkVjOEI0K0FqbU90TkZqTTE5Z0VFVUVOcG1adTdkVmhXMGlDdXpxdFo2?=
 =?utf-8?B?VGlRNTZmQ0dEWUIyTVpVQkRSNWtvZXF0dERPazR3MVYwc3lUNFhIVWpXbk1h?=
 =?utf-8?B?WHpDRTlKU2pyeTJ1Sk5CMkQwY1hhMXJSNzgvUjd3UFRJRkU1UWhQcjg2SUdE?=
 =?utf-8?B?M05TdVc4MjJKS0h2UzI0VlpJM3VKVkNuYmRncEk5NmhKamRDK2VkWjhUOC9n?=
 =?utf-8?B?QnBTVlRzQUxhNkdRNk5IUE9OaVZRNlZzdFRiSnppbWpWVUVYQXVQUmdlV3Vm?=
 =?utf-8?B?TTFwSGNjK3c5akN3RGFXNVVpL1ZlUzhHS2VhdXFCUUkrTDJrSUdYN2swR29X?=
 =?utf-8?B?ODlQZVVMTzF6eUl5SjByZGh6TitzZTBadnJSSkEzSHVaejJmWEdJK0l4eFB0?=
 =?utf-8?B?eDRUbm9QMnlRMjlZZkEyT2tTd3o1aUZqZnFpSFRnWCtiK0dWLy9VRFdKbk5p?=
 =?utf-8?B?WUJMbFE4cXZWSEhiNlN2NHBGTVNjdllDQWlkc3VQZmhtbThHSEZsazZXOHZa?=
 =?utf-8?B?ZzFOVld5N1hRZWpYcW1FWVVLMW9FRTRaK2h4VnluWlViVWxCZG1rVnEyeGoz?=
 =?utf-8?B?eWpCV3o3WDh5dTlaWG4wZ1M1NlAvL3h5U2diZ1RXTXFKRzBMd0tQcDFsQmk1?=
 =?utf-8?B?UWVSb0V1TEZpSGNIWTh1d05tck5Bb3JxdDFKNjJxdDJEdmJZak16dVRuTjlI?=
 =?utf-8?B?djNocTgrRlkxdVlEdDVkL1VZYkY4Y0twRHhHMFBFbEhCUmcrY0hHWWx6Mkxo?=
 =?utf-8?B?M2pKM01tNmFQOGhqb2FpMW56Nms3SEV1T3VIc253NnBucmNBbGtkWGNQdE5V?=
 =?utf-8?B?dmxHZmhKZE9RQVRIM2lCcXhFWDVBUmdDQVJmUmxRUXFTTENnYk5KN0d3ZDVt?=
 =?utf-8?B?OWx2Q0FKV1loQkRPTUV4bUpUcEpXR0g3bEFBbUQxUUlQcTZMRXQ1MS9wNXV3?=
 =?utf-8?B?QzZEeVhSanNselNNcGFINzkrbHErMGZ0UEZkclo4THI5cWU1WFd2Ym5sZ3Vx?=
 =?utf-8?B?dkpObXU1VUN0YzBBcS9xQ1IxeUx3bGtjNU1XbEduSURxNUhvY29nOUFiZmdJ?=
 =?utf-8?B?UG80dnRGSjhEcUhpZGRHNjNST085WnZZMENvQWxOOW96YUhYakRUOXhwV0xF?=
 =?utf-8?B?L05YZlg0d0xRS1R5ZklLais4RHFkNmsrOFYyYmFGWVM4SHlkdlg5TE9mZHEy?=
 =?utf-8?B?SjRndUpISkova1crTHFFNURMZUd1NXp0c2pOeEpHUHpVRHZWVXJFWGxQc2Jr?=
 =?utf-8?B?YWVwV2htanlqK0tpbUlNVWZOSDFia2ZHenF0SVdhU2ZvN2dJa3FEY3BsTkZm?=
 =?utf-8?B?cmo5R1haZ01PNlFENkJZNjg3MTNHVzE0bnhHOGxSNWIxcmoySldINWhvTHdJ?=
 =?utf-8?B?S1ZsaDFTNk9nc0p1N20xMGl4TXZSVXhQV1VhQjUwMVBLK2ltUHVjZVU2cjFq?=
 =?utf-8?B?bnNBTnVEL0lQUlo2d3RVd0taMUYzYnJKdEtweE1PbkNaTWsxL0pOQlNPUWVV?=
 =?utf-8?B?S3FRNEtKRnFndDc0NkhiSldZUnlqQ1dwblpnR2Rqa2c0TEMvU0NrR0RWK09H?=
 =?utf-8?B?VXZPZ1dybnRWNWY4MnljNkRsWHVUTzhhemtyWW9nZ0U4Sy9mMkdjMEJodmYy?=
 =?utf-8?B?S3lKTUx2a2RMRDNUYktGUUNlbFIyUGN3Sm16MjNMVlJwUHZHbnF4OWZPVDNS?=
 =?utf-8?B?QXFySStOT0lLTmsybHlyUWVtZzhGVmZob1hLWXRjbk5FbXY3QUlQbWdTR3Ur?=
 =?utf-8?B?bmtKK3Z6ZVNhMHFNdmZadEgxZTJwZlArUkhCS3phY0RZbmJONVNDQms0U0dn?=
 =?utf-8?B?UEowcnFBQzVZcy8zUHpaKzhPNFdYcTZvMEpDOEhBZkw3VTFVSTBaZEdRS2U1?=
 =?utf-8?Q?uiQkhOalyMGdvuQIHEiYJzWJ02pLxkNl2VTb2?=
X-Exchange-RoutingPolicyChecked:
	RYPSR1xbDRwjxWOVryNcQeBoa4nGeaOzeqhwJusTK82yHvIabyRcaFSftw4YrA4B6P+glJ3odoNiTZD32WFGU2/IsRwgw3i+YuTXCf3EHZjlUXcJs4B2y4DXCIxZwp6lkPA34TiWL54aVgt1xVsbvNtDvv+HEoS1ZaaBNxBBpHRtPHfrL9pfH0wyZxvb9OyOzL4jIY1l+ybl15xnUKiPYn6+XVv/356cj/g2nyAKP2hZk5dYnA/NRYP5o/KvaSXf4Nhfp6ce8BGQFtcxIzEFq9/tnDEvj2CullN1xZ3GIZ9z+blkVIV19/nyXjZgjZiXbfG6hssqh/x1PFj7ryxa6w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CNru6FJuVdrjPj+CazYmXQwRXmFr8BV+Z1Ds+mO1etQ3dL2sOAmOWKKBTh0b8nlqAywdqRvbDV2HDPHSmjvgI+h/+E6dua3P63137LrHNcN0AIojN7ORcGF03FI62bvSR90USp7EIwBzJdasxQhq0BeFds1555mwz7WSvgHDLb0RYJcbBvA+YNWAN5HZQRC4YtQ+ERlFTHQZLDTP5AUe5vURRKCNlgp1Qsdi1E85gCXLy2YLfhvuaxLRV6DoQQSuclJc/WpKUN7/1PDp4w4Q+kBrgK3tqjK+WpfdiPmtAnhcm7PEqPSKtEApkcAqrxkdnkWVPOS10/vDRW1K22ehmWlaSqXWJjPQfnw1aj7DN/xhFqP2ZGBAfBRExAJ07dO+OmDsxr8GyZaTpa+EtWm7L2c2mNpDJXLaDtBLcbn7laplc+/WMbqDyO5zqzFpguIkDnhtTo++rXtgwmVKEzOsCADQHlQ/JwDiTYBsKPy+jFtGWz407l38FjAcUR1w8fjLqxeMsimzLLifh/dPTnbotPZoyoVWTDE+st+JREuzhau/xRZzWB0bz0AAT4WMzDZwGAUyP5J/Kw0Reee+f/urcXAgiApcnFeuG/9fschq8EQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347738e7-962b-4c00-6edc-08deb7319cca
X-MS-Exchange-CrossTenant-AuthSource: CH5PR10MB997695.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 12:08:04.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwBFzSOb3SHHVJ+wyi+VgKtaAexqbffkKAG3ivUiA6Fg93GJ7eKAPnB8FIamNqd7aWfaPsBhv2FuU8mJ1w/1IfQOaDq6N6gfdRZUxJLuPuGHaAxKqo3tSMGB+KMSqlBW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605210121
X-Proofpoint-ORIG-GUID: s5TOEZ5PltzhvdWkJrIg1mLwHZGqDZA4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEyMSBTYWx0ZWRfX1OFZ1saRAB9W
 G0/lxQZPGy/ik61SWPyEhDXmJpw/XzKWff+ISm5uI7HyMJTA1pQFF0n19TWUQzqtxDUsBqA4gU4
 9fuc6b/WWU2kWNOcLg8PH/bJs+OOcF90Za2TdPDcWTPGFn/cgfQhqSLRlsy/Oe72dQr5S20u067
 nYPY0cWv1YU9OUv5PgXvysu0GgB49CAHxp0JjG5hqm/9aXitkQeRfqoTSzm6JIFaUmMtfKljC3i
 Rl4XgvBYT3xwfOmJyDIwvr56kW02Qd2E+R+9ENYvIjSuTNrZ1dof61ZnMN//pURqvYbt8KyghqA
 lQanJs2+xKGZuDEzkFge3N8HzB4DSq1+H5ah9ZzpjIPSIGFJy2JilMrSzHuZ7CTte/PVc670MCu
 MjCGNyDSQrL/QtMRhfHxGJd7I5fd9s2G56dxdpRvT1AoqHIZMzfOQz8TwcJAWeyFuAruY2Ea4vP
 uYqie97t8vquA+AnOJlMqgMLtHUmHOak9H9Sgyi8=
X-Authority-Analysis: v=2.4 cv=Ws4b99fv c=1 sm=1 tr=0 ts=6a0ef5aa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8 a=Ad1K0cAt0o2RRey575EA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=gKebqoRLp9LExxC7YDUY:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12298
X-Proofpoint-GUID: s5TOEZ5PltzhvdWkJrIg1mLwHZGqDZA4

Hi Greg,

>> From: Mykyta Yatsenko <yatsenko@meta.com>
>>
>> [ Upstream commit 271abf041cb354ce99df33ce1f99db79faf90477 ]
>>
>> Convert numeric error codes into the string representations in log
>> messages in libbpf.c.
>>
>> Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>> Link: https://lore.kernel.org/bpf/20241111212919.368971-3-mykyta.yatsenko5@gmail.com
>> Stable-dep-of: 380044c40b16 ("libbpf: Prevent double close and leak of btf objects")
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
> 
> This commit caused a build failure while testing 6.12.91-rc1 to
> prepare it for Debian:
> 

+ 1 for Oracle Linux.

I cherry-picked this commit: 1633a83bf993 ("libbpf: Introduce errstr() 
for stringifying errno") and it seems to work, so Greg, can you please 
queue this up as a prerequisite for this commit ?


> make -f /home/build/linux-stable-rc/tools/build/Makefile.build dir=./arch/x86 obj=objtool
> In file included from libbpf.c:54:
> libbpf.c: In function ‘bpf_object__elf_init’:
> libbpf.c:1538:76: error: implicit declaration of function ‘errstr’; did you mean ‘strstr’? [-Werror=implicit-function-declaration]
>   1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
>        |                                                                            ^~~~~~
> libbpf_internal.h:167:47: note: in definition of macro ‘__pr’
>    167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
>        |                                               ^~~~~~~~~~~
> libbpf.c:1538:25: note: in expansion of macro ‘pr_warn’
>   1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
>        |                         ^~~~~~~
> libbpf.c:1538:76: error: nested extern declaration of ‘errstr’ [-Werror=nested-externs]
>   1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
>        |                                                                            ^~~~~~
> libbpf_internal.h:167:47: note: in definition of macro ‘__pr’
>    167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
>        |        
thanks,
Harshit



