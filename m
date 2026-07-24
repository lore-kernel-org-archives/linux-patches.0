Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09672F1FED
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898196; cv=fail; b=FkyTfluW33dplpAmt827G77VbtLfNVna6QWxIBGdXxuV/g7J9j0i0FJ/3qKoq5rM6KYdpR+KYIU+b4SI5cUjipXknJz4nGSDwI0+RmTffIi8Lq/LKr5rAOSpiSXtsjAGghXwHumO5gPFQZi9ob8kEnhdJq1n1k+uyrzBUFOr6gE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898196; c=relaxed/simple;
	bh=sV0K8+SQwdnYW+bn/uLgweteK8wgIh243c0GwNFqHvQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NTu13lEnmNZDyZZnACC9c8dNWVEVdt0NxaCH+Whwqx38jHojkFYfMKbOc38lw3oUmsiJzBiHsaTfZH029tdxddUHbXJYKY+lNoCu1Fag8yCkw9idSF+GHKzuKNc1mpH+zgzVc6UIFbUR0EGys0ttZf/PDqiqHieB7VH+KFoVuP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rcEHW3in; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NLpPGRQ0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rcEHW3in";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NLpPGRQ0"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCv0T53505331;
	Fri, 24 Jul 2026 13:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BwhOnCd/y94wBoqhsK/c9Zv9g/i4uxdgBNoGJHZLN00=; b=
	rcEHW3inhLj+qeE9VfLKcTvlXMA08XwmTMHBaq7f+Ya0WvNDNqZKKDtrHHE8q6qm
	Qfr8Wg9Qb3ptx0hra8PFVfEG85b7Jd3OvmDVDSkrJDAXr/TXKFx1gGvy8na2kJaG
	+ZYncNFiDEMYig5r5io8dryrP7FPQV5wu/lZdw6DQD40gOgJXOTBYYnCvG1BIVg6
	0JW1iavPfyvGkfUMwrhG0QcXi1Wl8Z3M31cwaZHz5du1S9zqEHVzI0EP3Ku5CplB
	GDB0Vck09bIaUC56s1gGOUfcx5Q69LXflEaOGrRKBErnDFn8yeGywx0wD1O3/V6n
	6YYdm9piYWvFKsUXPEE5qA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kq0huj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 13:03:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OCrC4K012329;
	Fri, 24 Jul 2026 13:03:07 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts28xug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 13:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7YZGl5Ja6OaAtAHx29Yo2nDeXhe++hG0W+blwx9FCBneJgghhNW7GODNbrf9+uvCbUw2tc61aMwUWxakoS+SwvZn+ZooTWjrnN2HRQw3q/LWT2ycwCuN0cJ3g8Yhz88pFBg2LRTQU7lQNC303MQm68uQCHFUUFV2/CTN1pVC2k3cdQjh8SdBb8RIUEINP6chYloQr1QUAcd5nqsW8167H/7RYpz3mOvft6ui81MXgZpWxDJLjOxRc8/p3znlRD2qvTSgoSMbh6UkKN1JfzpLyWsPhqM0Q+Q+fY3IWaBLYez4CQEtkhlS6JvOXugNpyG3hxiQLjzLGJrVqKdkqrYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwhOnCd/y94wBoqhsK/c9Zv9g/i4uxdgBNoGJHZLN00=;
 b=B+FX8mPtXi+U0C/Dns1Vag/PC90Q0yuVqk0SZ4NCtaIUBxilzn1BK42GFt4dV+VwwSXKttJvfAzxa/olm9/t084cSNaiw3J+1cIxnQtUOiExZer3rUEXLDBtJHJ5/tTmbRARdmDus+821bRNZ/CgLd+X1c0XiCjgpTMqfFtFmTEZkCjxSpALyKHhH03uxXBIXauUyyZaqxDq6EvWOcHCWIzX67eKdzTQm7pfsh4JYZCuHa5LBSA0/F+6teHzp6RBR/SF3Y4dRIoaDkKH1Y7yTrPgqjL8zFpZd6ZSQZMu0uRvWaIvENcEek42XfmJlfNv9fz0tKKp8m2h4zM8k4WgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwhOnCd/y94wBoqhsK/c9Zv9g/i4uxdgBNoGJHZLN00=;
 b=NLpPGRQ0BsfQDq5A7Dmeo/mtNBfupZJgkOXLu3Tz41UxN2LOHiB/ZYLQ5z0PNDLUZThM8RlCiAtTX5JQ+neh3ESjg8tcB20g2RHOStOR2ULD08K5C10awh1aZoz06gXQ4ofWFEUP4f5N0ubdaRPTWHxiNs+9twZLZPAqhUliQzg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA7PR10MB997775.namprd10.prod.outlook.com (2603:10b6:806:4cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 13:03:04 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 13:03:04 +0000
Message-ID: <79f8b3b5-bbdb-415c-9211-ae1858cb5dd5@oracle.com>
Date: Fri, 24 Jul 2026 18:32:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0309/1276] ext4: validate donor file superblock early
 in EXT4_IOC_MOVE_EXT
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
        Yun Zhou <yun.zhou@windriver.com>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152453.007613078@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152453.007613078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA7PR10MB997775:EE_
X-MS-Office365-Filtering-Correlation-Id: 459a6099-949d-4b98-6f74-08dee983e5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|10067099003|5023799004|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Vr0mnue1XvMKJuQtVJfYvvWMfElkuQekFjLwasaZDxv9q/MQfRgqZmNetzKYLxNcn/cyUMiCrx/xo4uIEveRpRHGzrjtrxqgZecTCeLCV4x5P/iPXZjVjBZOlFvNK82KypEaA4+oLy0a5fJwypS+jsBsl8Oo3PGSfCQuTz033UOSXBRq+9xgEVoDkwrNU/2Igt+LGaxxGDr3bWSt+AULQ7EkCw+5nfnUPeN9TIpiphd9sALgw9kCoqAvT1G6IUJQfTIeyprdEaDIIdKup3wsCxYOtFUQCvOZEv7vYN9cfwoN9UkSN5hgYEW5E9cgs3krEJXA+c5aWMAKtLIS2/JgpldMEqnCsiz1yq0Vh1ijvxwE660m6QWSGV388ntdZvLM5GypEtcUfpiLnQ8rJt/SRgyFmixSFJgf5a/V51RjXiQSiBVig9sJ3DlA9jhGwfTyIcdKI0GK2kyBGQNpolW3jd27sug/RAShB5u2EV97nAlGDhD6CHpOlwoxFEYGMLxvbqVdSdKuln9FNk0sU9y2tJOoPplSNcmm586s9dDWDi/bq5if6vie4XhijjKrCLF+rkGjoXIrJa64GDipWiTaX+UPqFx1aZhEb2blT7BnXQ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(10067099003)(5023799004)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkhYd2tCU05QN3lxejNhcEFzdDgyK1QxaU8yK2hrMWxyY09SU3dlRVcvckF5?=
 =?utf-8?B?WEhrckN5b2lmSmdQSmZ3VjJ6ZWdSWVhUWFdRcGg0WHRFVXo4bUFqRU16WGRF?=
 =?utf-8?B?Y3MzbzNuNldKOU1XMVo2OHhyZ0pockxmTlR2M2dMak5xdC8vc1p1UzJ5MXR6?=
 =?utf-8?B?NkRiV29ZS29vYVlDUzIrRUFKcHI2K2FPT0drRlhMeVI4ajI0ZFN5ZG9ob1NO?=
 =?utf-8?B?YnhLK3YrRjRmeCtqWXhnTThUTmdDRUo3ZzZJZklmWjliZTcvcnRJbjNjMjVn?=
 =?utf-8?B?SUQ0T2dFeThyUm1qdHR4cXVtT0FGSCs1VmV1UWZSU2Y2ZlVQU0kzZmhKcDMv?=
 =?utf-8?B?aXZZV05OUGprdG41TWd0WjJ2cGEwK2VGbFJMZWN5bnhZV2EzSm5waWdWeXha?=
 =?utf-8?B?S0JIekpZQ0lmSU84T0lpb3J3bnBaV1U5NmF4MU91RHdTaG9jWWE0VUpLbGtW?=
 =?utf-8?B?MEw5eFJibmJmU1VKWkMvSHIycUE2UmNncWM1ZjlIUFNPcXlISHRvdVR6SnZa?=
 =?utf-8?B?TGNwVVM2aW8xVzlxVkhTeEN3VCtnWkhuMnlGQStBRjR0WXZSWGtKQWNiS29r?=
 =?utf-8?B?M1NPd1FNRkFuY0FHczBJMzBnM1FkN0l1MWVYL2hXVVY1aXFDZk9jdkdpT080?=
 =?utf-8?B?KzdhRGVWekQyRy9aVHcxYit0RWpVQnNMeGtMUWxadWVTNkxrd2ZwVitOSXQy?=
 =?utf-8?B?b1ZtZXV5U01PWDZNYngxcHFnNXJNSER3cnZNU0ZPbW9GZGNiWEJwWEFIaXh5?=
 =?utf-8?B?NkE2SUNOOEVBUVRzeGNPY0EzTkh5OWRaRyttMTZiRmdSU0N4d2hXOUpLdTY4?=
 =?utf-8?B?SUpsOHM2dUhtZFc3UlpBRUVNWHJ3TmF6UG1HV2QzTmpOVzRTMmM2SXg1M3dw?=
 =?utf-8?B?VjRyZkhUWnhrNDloWDZ0U0NZZ3N2MHdqUW9Qcm41dVptd2VGMTJNTE44SUJR?=
 =?utf-8?B?Mng4eVlvZU1RSjdheHFVblpaUmszeE81MzZUY0RYS3Q3ekp6K3U2WnNnTGJm?=
 =?utf-8?B?U2R0T3hYbVdGbXkyNDFQYUZJaDBjbXJTOWdyM0U3U2F4S3F6dlFwdm1jbXJk?=
 =?utf-8?B?QnpJeUJuOTg1SlV3Z0xFM0ZlYWFRbFZOWDhZVTVIUTV6V0RDeXZxRVduN1do?=
 =?utf-8?B?OERKVjVjb3dRYm9CVDFvczl3Q1BOREg0VlIya1lDRVBlQWpKdlBLSUtqM011?=
 =?utf-8?B?WDZFeklWcndKZTlNNnUzV0JuRS9QOGdsb3NaMmx5THkvVTlUUXVwNitzME00?=
 =?utf-8?B?TkRCaXlmeEV6RkpLZWltT1hSZm1QVkwwb2F2ZUhUaWlobVRPckNYNTc2TjVY?=
 =?utf-8?B?bTBhVE12OWRYSkdYTnFuVCtubFRUZ2QwWEdIUDdocGgwYUsrR09XZHlkbVdP?=
 =?utf-8?B?a3lvUXNBMlJPQlBqdWZJam80UEdwNkkvUnRNT0tmNllab3J1V3MwUXM5RHpY?=
 =?utf-8?B?b2kxa3BGOER6NUVycVFtYjBVNU5ZRWQ3RFNsZjJGQ1N6cDJLalpKUlhqZG9Q?=
 =?utf-8?B?bnM0eS9YdVJTcmplQ2ZzMVkyK3lTd25rZmMvMnE4RnFZTUlPZmdNcll6dTFs?=
 =?utf-8?B?MlR4VWdBYisrOERLVDkzYXRPMXJielZLOEZkQlNqK1pwNTVUekxESXlpMVh0?=
 =?utf-8?B?UlhSWWl0ckZzK25DK0FkalB5aWhUSzFXZGxlNHg4Q3JVR0lqK0xvdHJwUEpj?=
 =?utf-8?B?dm03L3pQM2RpQVcvdlZVdUlwV3NHMCtGckovdVVvRU9zdHpWMUlKc3YwdFpv?=
 =?utf-8?B?N2FmV1Erc3dPTkloMk95NEZZa2EzckxzOE1kQk1IRGI3RVoyM2FzeWs2ZnVS?=
 =?utf-8?B?c1JQdUZOK29iT0xmcGViUzdnY2I1ZWo4aTFUek5UQjg3ZmVJSmp4dDlCblVG?=
 =?utf-8?B?OGxqTGxEc204YytVNEZBS3hXU2FHL2hsV3NVUWRRVFpKODJ4K2hrSFU5elM4?=
 =?utf-8?B?cmxOLy8vcFlzemllWTg2YXhzUTRFUVlZUk5uMGl5WFFPYVIzMjRzK0ZhcFVJ?=
 =?utf-8?B?djgwK0xYK2xOSlRSZ0ZGTktBQlhqcTJ4d043Z3dmQkdBbGpsVStKaTZFV3Ay?=
 =?utf-8?B?a0p1b3NDTEhMUmdWM3RsMjdBaUx6MkpJeUg4UHk5K1NMY0FnZWxKVGV0YUtP?=
 =?utf-8?B?SzNDaEFlTkZ2WGpLVXBwWEJ2Mk1TdytaVkkzeEhJN2dFK09iN3lXS0RwQXZ0?=
 =?utf-8?B?clpZV3lvcHlFUS9WM29Bb012NVl6TXJFd1dwZ1lFVWdJUnFEYVd2dmtDQUJG?=
 =?utf-8?B?ZCs0aHYydGlrc3N1d2IzbC9qdXNwS2t2OTYwWFUwd2J2WXk5cVNJaXI1WG04?=
 =?utf-8?B?MGF4VUVaVWlqZktBbVVqRWZMNENLUFVRQ3FhUzlIR0lMR016clNxaWw5VjdZ?=
 =?utf-8?Q?bAe4H7wbHQt6icMTiZRGvVgiZiSGQrOWcDQik?=
X-Exchange-RoutingPolicyChecked:
	ImlEw+icHrgDKMG2LGwTPqnn3B5xfAtCkzFCZCER42CQ413JcRLKplb9EnQupJsvhnCql/L9LvgQsmc27UHzi2FnSqxd5xBbqeDZi/uzvGb1ZAGWIWPw2OaHVu8fsEv4SvCD39pLw7+0Enl1ykbhV09AnFM6awvrTwDO6VfTeNes4LtWGgGJbaviHZXNE7q6sTCk7MiLAns6Agypb2485EiW7jsKBBlJwSOobEvNcJU/06sJhovPH/CRCh57ca7cDlunzMnHHR5QYBlEgrcS6Kcsf8m3T01pLwxFvscWUaQEQLfNaYb5Obem1PXKzWAUexGQTzY5uaA8pzLZ7ovTLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wulBBR5Gav3/8YzfOod/3y5ApvJdQyDItgBKlH27Om/UiNEQH8wU73ngmfXA1XmGg8RIFCTNJCQOXTxuzgVUuiG8te0f4cRFaSyseIrhf/x+2n/Ytqp7Dh62fohICN1ROcWtSkXzyjSTd0OEfQPzLOzUKVNw1LhMiJjQpBFiU/OC4AIJ6isAQBZpr8mX1ZKHF9yKoOtwpRdUJzPpeMDv0IISG6zzSMgo7k/J1XUWQonNkeMeEjw57obNjZV4KOErURajw54VDTBGik+oJH5NoTWlEw4OS9KyqPn4HoGlBkggJYCZghlRIwUSwikVINm1Oc0bcFvuRe31EukLgYmouUrPu7KwyP337QiMWCN1ymf+Dx82svlfcusFkp5mkwsN6dcoKgujYLmpd0QtghGYI3Y0/8wFOrMw5UeKmjrbxCWnf8mnGsjNAT/klccTZ/yE0VqrhPYdrwGfPromKOuSuqj49saFVPOtPQkOuRgltWk17Tr13BuKP2cCV13QGZc7x8d6ql4GNzZobXMuU2BbpYvsUHnJ6KjZB3c4Px1da6YvYVggkxcDki+5hLlnQMJ/Td7hHIihDZh+QVc9uOzeEuGTSnrhQj+xwJ1CrR+FAMY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459a6099-949d-4b98-6f74-08dee983e5e1
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 13:03:04.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ydjpe5Rewjjlq0ahMZMzGN8b3/wMd+FQWeHW/Z9epclOohLFAHAI2iMHa21lql0KcUD0DGceGQUepylxf7LLkYAzeSeYurU0VfITZJA6fKDPPWo7sQscDBJ/IIKMiUop
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR10MB997775
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607240117
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDExOCBTYWx0ZWRfX2poEW0txB69Z
 KQu9L+SJw96IrhfyxkWL/mQzzdhvRiUk+uoJxOM4JfQMUs8DZPeWwp6w11/ICXIoCA4xX/soy73
 GmCWqAms8EUhqmOUCv7L+mCLkEq6zslhcow2rY87womxV/Xe9ItX
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a63628c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=edf1wS77AAAA:8
 a=bC-a23v3AAAA:8 a=t7CeM3EgAAAA:8 a=hSkVLCK3AAAA:8 a=RPJ6JBhKAAAA:8
 a=VwQbUJbxAAAA:8 a=qhpmRbwBnEAKzKZlrIYA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FO4_E8m0qiDe52t0p3_H:22 a=FdTzh2GWekK77mhwV6Dw:22
 a=cQPPKAXgyycSBL8etih5:22 a=fa_un-3J20JGBB2Tu-mn:22
X-Proofpoint-ORIG-GUID: YKIHtjj2WEe5j17Wox0AqJ0IkHbLzd8h
X-Proofpoint-GUID: YKIHtjj2WEe5j17Wox0AqJ0IkHbLzd8h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDExOCBTYWx0ZWRfXx5YuMeI1Z1hO
 5kkbDMNtXkl1yCiElyYCyywQg8TDJGzObeqXMM6qRLRgi1GG6IbCXxP3EsV2t+hfFnCzfnID3r7
 sahg10zT5fHck4MmHceEA9TU87tZLRo4zGQ7+2mYs9LGoAommmGmch4TkrgdYW0G3EqK33qgmAB
 so19NUEJIMabChaWGvV3ACCNts1FnQAM20Z04qOFS+7e+nn1kK85/CDuyVc3HRrTf8sseQgIzyf
 XJMUS/UGPe1IMdWBhqWl/dMhKHjrr7hivT0obAUSliyoznbngNYymbm8STo7+1PvWtZcxNBN0Z9
 hfxxYw8ZiPfL1Qoon22kqquTG6G6ctUy3pHmRaFqiQnObjsp5S7V31vUyuA2PDZXnqn9D7m4my/
 4jmoTi6LgyZD1mdoHh2/56D43A/afCLzjqytLmX+60A8vQgIHU8dKkTf2FRgAcIvJuOvLs6i6oc
 fhYHv8VazR1AWRW46+w==

Hi Greg/Sasha,

On 21/07/26 8:42 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yun Zhou <yun.zhou@windriver.com>
> 
> [ Upstream commit c143957520c6c9b5cd72e0de8b52b814f0c576fe ]
> 
> Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
> belong to the same superblock as the original file.  Currently, this
> validation is performed inside ext4_move_extents() by
> mext_check_validity(), but only after lock_two_nondirectories() has
> already acquired the inode locks.  When the donor fd refers to a file
> on a different filesystem (e.g., overlayfs), this late validation
> creates a circular lock dependency:
> 
>    CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
>    ----                              ----
>    inode_lock(ovl_inode)
>                                      mnt_want_write_file(filp)
>                                        sb_start_write(ext4_sb)   [sb_writers]
>      backing_file_write_iter()
>        vfs_iter_write(real_file)
>          file_start_write(real_file)
>            sb_start_write(ext4_sb)   [blocked by freeze]
>                                      lock_two_nondirectories()
>                                        inode_lock(ovl_inode)     [blocked]
> 
> With a concurrent freeze operation holding sb_writers write side, this
> forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
> for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.
> 
> Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
> it fundamentally requires both files to reside on the same ext4
> filesystem.  Moving the superblock check before any lock acquisition
> is both semantically correct and eliminates the circular dependency
> by ensuring that cross-filesystem donor fds are rejected before
> sb_writers or inode locks are taken.
> 
> Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
> Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Link: https://patch.msgid.link/20260608152521.1292656-1-yun.zhou@windriver.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/ext4/ioctl.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c3758c64fc4e03..a8a024bb62b4f7 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1372,6 +1372,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   			goto mext_out;
>   		}
>   
> +		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
> +			return -EXDEV;
> +
>   		err = mnt_want_write_file(filp);
>   		if (err)
>   			goto mext_out;

I have run an AI-assisted backport review and took a look at
d9db3e516000 ("ext4: validate donor file superblock early in
EXT4_IOC_MOVE_EXT").

Upstream c143957520c6 uses CLASS(fd, donor), so its new direct
return -EXDEV is safe: leaving the scope performs fdput(). The 6.12
backport instead uses an explicit fdget() and releases the donor only
via mext_out:

        + if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
        +        return -EXDEV; <---
	
          err = mnt_want_write_file(filp);
          if (err)
                 goto mext_out;

...
mext_out:
         fdput(donor);

Thus the new cross-superblock return bypasses fdput(). In particular,
when the caller has a shared files_struct, fdget() obtains a counted
file reference, which is then leaked on this path.

I think the stable patch needs a small branch-specific adjustment:
set err = -EXDEV and goto mext_out instead of returning directly.
Thoughts? or we need to drop this and redo this again. I think impact is 
mostly a leak/DoS risk but I still think we need to get this fixed.

thanks,
Harshit



