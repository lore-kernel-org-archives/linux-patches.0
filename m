Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53243FE651;
	Wed, 13 May 2026 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673009; cv=fail; b=u0GIDKc1pIt8v6eFOfeSA32+xcf8DS1UJ/2tpo4HqcUD0ZDkYUL1XcjlqqgQIm6Lme5L4nH9I8riqugD5XJC9DgymKa0BfR2HOfBMtc86EPukURLFUe17nGRtXR9TNeGD7gXgXB/HRFNiexsuCaPYQ2EK1XGOXrPanxQygTvCbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673009; c=relaxed/simple;
	bh=TaAOE7s+WY52hNREP+r0K/HXp5QfmKl7YwqWhGhDBZQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hAZznwLrJBoU5XvOceHnSSSY+KIteB2DJ6u2yotLoL2qJqV9KZ+AKU6f7g8fcUFYpYMAjQENrh1ZrARewNcsmCYsnABX1WScY6iIFDyyQZxklbbXXyTs33zvxipbqkr6mpgOoIO7AKk2XryEro2T0+OshenVjwDthl69bA3z8uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZHy75Ed5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kENR/zNv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZHy75Ed5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kENR/zNv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D7MifZ3195574;
	Wed, 13 May 2026 11:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ncLpN2ewedq/WUGUIdb1Paz8h9Hybf2rAyLmiq64Bm0=; b=
	ZHy75Ed5dcSCZTv+malFWiQG2IBddw1Zb5ZHSDaLSGddhugiZmulpHm6snv2wvhN
	ZsgRuPVFMj7afkRhaS9Do5Xw54po1M6+j5GEPRhoH9zLu63Pa5IyFEWuKN0Bx+PC
	5G6N10GfHx0L1H7RnYa40dbci72616t5hXChfc95hjNM6yUTuo31myYAjECvnfjQ
	JrDJyw/wGH7GG4lJbC/jIuO9r0xzD9HnGJTibgwWII+/VKTplfYUi12c1SvbU/5F
	6KJ//Ze57Fx7aAS/lh8O+CTAfS6zXD2TCtixu2aqwqUqGXwbEYvAaDJeDTQF0fpJ
	/l29HqB0ASDYIP/DsyzZxw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c9712v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 11:50:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64DBnptS005929;
	Wed, 13 May 2026 11:50:03 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e3nebj8ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 11:50:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mqungP8B4+g8EGgnVOTRMegQE6RXjLrhiOpxVzSS8L/Pn4qLyGz5TkEK0POUW6up5TUn+WR3ykFdnOLqUk+no0huK1ELpdyWcHRTD/6CWPcgCadqUAjEQj5AT3GZvcKoGOpfNyyH+NDXIMF3dSpnUohAYALT8n4qciWjD/JRHiQDf9qQz4pTweHQzaduBbbQMy4Z33efc9MVSZgq+5TO8wOxQ/Of9yVZJU5BHgdNCN9khAV4CVXpRY0RnOjDMpa3b732H0eqkVFix8z4PpD+SGiVuVniXy236O3xXZ/kX7VH4sLogzKCl2Dm6fHEEZMc9EElDaZdSeqShi4dEugy7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncLpN2ewedq/WUGUIdb1Paz8h9Hybf2rAyLmiq64Bm0=;
 b=KoS42SuKYDHHt+tFN6ie+CpB4kxniQ1rma/3VbLRFFFXLA6o+XG9PpyZKCfIpsO2k3w2BR2F+ehkkfa1D7rIzro4H3kCFzMH0mZcxCMPkSk9cFT99YUJ4ECxGUb6XEafaXsjmPhWtdJaWJ/8DTX6qmS1PGM8RMS1ygnA1jFxMr+Mf0hsKg6i/rPqaKrdri/SPK4j3kc6uS0dUTqwG0kp3MW1ExIibGo6JapaiN/NeUQYGkwbubxk2fFJx7WJ42RWQxUFNCdHoiBfNPUi5csRr1+dGwxFZbtvJcFNDUgGFqDy3feotgYCBXZym3UEjQ8qMECDPmf7nVH63f6cKpuEZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncLpN2ewedq/WUGUIdb1Paz8h9Hybf2rAyLmiq64Bm0=;
 b=kENR/zNv6An1mcABkMSUyth01jYRTwyeRfXHMOaPw38JXpYjyjPVSCQcvtESfrPXzcGSxRO4Ymuz3f5InHKjrzxk9Ehom1GM+TjTIaH/Rf9LyB4EA5ab5H0hniWhTBvQiu8YjnSBVx1f8VF1QHYQcrPJNAyHJCQWBdilrALqU1o=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV3PR10MB7820.namprd10.prod.outlook.com (2603:10b6:408:1b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 11:49:59 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 11:49:59 +0000
Message-ID: <cbda86eb-4896-4f35-bf76-3387ce14ca6b@oracle.com>
Date: Wed, 13 May 2026 17:19:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 135/206] riscv: kvm: fix vector context allocation
 leak
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Osama Abdelkader <osama.abdelkader@gmail.com>,
        Andy Chiu <andybnac@gmail.com>, Anup Patel <anup@brainfault.org>,
        Sherry Yang <sherry.yang@oracle.com>,
        Vijayendra Suman <vijayendra.suman@oracle.com>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173935.718950582@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260512173935.718950582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5PR01CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:261::10) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV3PR10MB7820:EE_
X-MS-Office365-Filtering-Correlation-Id: a300a671-753c-4a6e-0f20-08deb0e5c268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	A7IjvPQXmWm5cde9xFycPkBU7doRGUEWR8Yx8Jo9uJVyyJMrJrZLUtcGlfQX9xctxYSd5/G/90Ivx0Gal3I7kwoc3OPQ7O0wIfINuROoACaN8OpGgsP1JwS+gdOLXIhOb5Qr0ivOz3ddjAF1EytK7hu8P+7qIDauB7cN1VwAieO7DvPPtLBN1w8ffsqP77VVMopxqwjArkqF8/DJb4W6Gvs6GcCdzXJzsU5YP+7UGu52FUIHjw/I+mRGFLsLKVSIyfswjG3rfw1HZ8yPJ3JP0ZZvz7v+fEZScMJlRU5cOJ8kTZ9bBGd5EHD3RqsiCQpphkQ7iZ+YuNnbVeLXreGT3kqlWbByEKN7TWV5v3Nxt9uraNH5JOHcZYGa0Y77XXh+VRicOXaz3e1VTGUoHjitzFxGBFK2YnyQdKgixVnQyPL8r+5E/1DOI9av+o2HLtesTs2Vh4XYsuRZ4jvpTXKa44wB8rWQUmy0NrgwbPBL8qRTl+33IELi/DljuXPWap987qQoa9rxl4k9q0f4tQlrQwq1FyvPL0GISuU2Mak50X5mJ2y3+HVy/cSW3OS8dfu9hQOI2wXisKsJorSkWKYCxG9j50kfORJo69g9wd3Yk95gfj6rUFUC5Z1sZFFMFVIwDij+schburOLFtpQnwFtnZ6Y8LrIeDZFMSjzdF3mC01YROQweW31nMiHeKg306yAD2nG3GA0gdriFVMKFKV1dA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmZwOEhRWTE5ZVpXcEkwNXdrSzErU2V4UUNkUjNWa2M5WkV0RXVNckZzcDVS?=
 =?utf-8?B?TVh6N0xvU0RvaDc0emM5TUFUV0xEM1FPbkdPZ1IzNlVDdlF2UGJjYTlWRnBk?=
 =?utf-8?B?cDExN2MyVlh4MEVoVng5Vnd2ZWlkMDdUM284Yi9COEhXbGpTeEtJR0FXN3pi?=
 =?utf-8?B?dmpyTDhaRWI3WDBtWmxhZXYwT3dtOGp4VmpscDlJVVJKMG5MRzJVcHBWclRu?=
 =?utf-8?B?cUhnbVdFN0tGdWE4d1NRNFU1K0Y4RXdtVGFSM015blNaZjhBRDk5L2cyVEND?=
 =?utf-8?B?LzRxNDBEV0gwMm9xcHRweVhIR1crSTVBaUlEQURyczQ3UmhMbVV2K3FhTGVR?=
 =?utf-8?B?N3NMNjUzWEIyRjJjNzF4UTlnbmpqL1VxdmVxYU5PdjRUNHVabFhNcWlWSmtW?=
 =?utf-8?B?TlVSMndxdCtVQmdSVWVqTnBnNFA0YXVQVE1nOHhLT01RcXFKeTZFU3ExM3ZR?=
 =?utf-8?B?Y0lXdnRMZGtFY2ZpVFFaazBLQ3RzL1FzNVIzUVh1ejhLSlBZYXk5d28yL29Q?=
 =?utf-8?B?djJsMm85NFNWUnM2MGU2MEd3S1BVQXVjTW5BempSMXhBQVRoYXFnNVFiZG1a?=
 =?utf-8?B?QlpzY0lsN3JaWXVpWjVFazJIQ0ppYThNUWF2NCtRTGtiTHZ6dklIRzA2UU9j?=
 =?utf-8?B?TkdrVU5FYmRIVVB3a0p3Y2szOExvWlpnb0V5a2sxZzVlbDZnTUk4UjZtOW42?=
 =?utf-8?B?NVU1dS9CNUlzSUhYcmFtbDZ4K3BDVEtTeE5MU0VUZVpFMzk3KzE0ZDZ2OGMw?=
 =?utf-8?B?bFJ2RjYxVy9GNWgvcXVUOUpEZzBJVmtVMndCUSt1WDNvUzBWV2hNemVCZkx0?=
 =?utf-8?B?WXQzZWRXeEUxODJnWXVGOVlpYmQwYnBTQlJKRURzTDYrQVo0R25FcW83c0tE?=
 =?utf-8?B?NXpUUlhQd2RSMFF3V1hXN0FWWDFXVCt4eHA0OW9CWjBUUG1aM09sRDJNTFEy?=
 =?utf-8?B?S2FORVRMd0xxdDBxS3BnM0hyNnRMYWQ4VllsZnRWUDhSRnFucENBbU9NMU1p?=
 =?utf-8?B?MVlxVTl3RC9halFFZjFWWXlWOXR6d3pDZ1YzZnBQMjZYVWt5MFRmSjlHZHFO?=
 =?utf-8?B?b1VKRlhqckUwVUlwSnFOUUtaMGplM25tdWNBY0xrdDRDemwzdzNVN2ZlN1BY?=
 =?utf-8?B?UUJOOENPVnl2dExLUzdsR0E1WTM0b3c0K0xxcmVZWU92ZmhWY01vUk5iQlRs?=
 =?utf-8?B?V2hMak9VK0xNOXZ0Y2xORkNSRnpZU0g5aEZmUHo3U3JRVnVKT0RjNFRVQUlj?=
 =?utf-8?B?OUVPTWt0ZDNqV2x0eTZFeWJvMXdPNnBNQ21JamdVYm50YkZDajhnK1FXK3ph?=
 =?utf-8?B?bHV6QVpxRkNHaGM5cmM0bUFVcENGdVdvRzJPMVBZWjZxL2QxZHlkSThpMEZO?=
 =?utf-8?B?UDdaak9wYVdxRWsxdGxZL1lkQUVRSEJDRVo4bkh4N2hDSGNyR3dMU1NGdGVt?=
 =?utf-8?B?MXdJd3REa21tTlVvV25udGFjOGRCc0JVSW54TlVFYitGZDFJZWVvRzhjNDgw?=
 =?utf-8?B?cEREZDNYdFF1ZC9OMlpmRnI4R1drOWJGOG00dUkyaXl6Vjl2T1lHd3JhUDJL?=
 =?utf-8?B?V2JuQTJ0Rm12WEV2NXhzRExhQyt3Y2wwbXYzZmtxaUVRYVRPaVZoaFJPeG95?=
 =?utf-8?B?RUorMnhvdWMwTWYwT1VOWkdpMFpJMFdMd2tjWE9SSmJwemQzN1llS2hRL0dM?=
 =?utf-8?B?d1djRUFHMXNhUGM2a3ZWdnJxWTFxVUFIblFKM2IvUXVPL0lVL21RRm1sRzR1?=
 =?utf-8?B?SmRmK0FueHlVdzVTQ2J1S3RLcCtYdWU3cDdGNW92VzhnaFB5ZXFmd252UVpR?=
 =?utf-8?B?KzlTVzNwM29FU1h3cGhubDkrUkdKYmhaV3ZybjJzalVaNzQwZzFqRHZnWFEy?=
 =?utf-8?B?YXlGdmRyd3dtOGRlZUNUQjFDUElqV3lNcEJGSmQ4Q0tVdGV3RmI3N2V1b0s1?=
 =?utf-8?B?T050ck43azdkOVRIWlJzVXhPSEc5Ri9YbUJ5UkZRWWtLcC9aRVV5T3NVWUd1?=
 =?utf-8?B?RU5tYWJ4MzErenM0V0RlM1FYVHFEaUpzWk9YK0NWNDlnbUF1MVlpNUhHbDRJ?=
 =?utf-8?B?amppWktIajFRQkVxYnhHbFRIYmtobFZlb2w2RDdsdWJyZ3owQnk4dkgyQThM?=
 =?utf-8?B?LzlqbmFlMjFyTU02ZUpSTHgrT2xoS3YzSmVGTUhLbGNXam9mM2lMWXMyd1J5?=
 =?utf-8?B?ekt4MUtjT1ZuQjJ2eVhUdWhjVldwcWwzV2JtTDBaSkpXNGV2eTZhdzhrUEhX?=
 =?utf-8?B?djVtdHMxMDEwYU5iU1lTWk9BYmh2cVpnQmsxMlNDWUlqWklsN2Q5QTRteE94?=
 =?utf-8?B?SzRHbFB5amoyOStCUDlMT1FTOHJBbDNBYUhhK1dULy9rMUJvRHNKSjNQUEls?=
 =?utf-8?Q?KfR9yyK7rm3JUo8v3/W7cLGgWV8czkIioCYzh?=
X-Exchange-RoutingPolicyChecked:
	jtR5MmfDOfdW3fy9Vv+mfl2ve1a3Hvvqr+RVvAigRCZg4V7V6ougndDO/YXurptTTc5pgFnaHnScjKFOoFTbjIssn5M7GD9mesUSRHhJPnFljciUcd/NIJOzR8wCoEnDOJ+qi2LrQXbfAN9muSiP478pcg/hcnlG++mNKtwXOg/1xTkiXviXBRMHS72Khvpz38Nwq885w+W2OVILwCnWHmXwlov0Td3bH47rrpOuzwat3zNgFaKmR6uXzbB7ia8ADeW2iH+qpntdFbKVsBskGcPnAsaBxRON+V6Y36RsBe4JnLO182Wokn42I1Z7H8vU9ETQVun/0eoa6GnUvA7nUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wDUzY8+wepoYTU9MugAUCl7pFqBknALrq8dH//Y9Xe8snhNSUlwJ/8ciEckQWmQDpfqrT0/IpUkFv5ODizNQ4VRNFfdeLsBgc8Wqzf5U6IXuCMD1Sqtkq5lCISBRijaaqYgPOnqqv3l+ENvyJJq0Ni0XphORjt1KYQIbsMW4kpKv/89ljbEMRaY7/PgbDHo2V7J9hvSxj+JycPttFlkR066O9jztv2HKlyOjJgbH89Y3Bldg/uVD/59JnIKqCDICQysbQN5kAoM0GXolJXMj+irPV4q6V37bN/Ns4PpF8UN5yS73/a4AAYLUCKCY3kFtNPRnkJnTP6GriRhlcaSYJq0DXg7YuwHU7KZ4pDNukPQ38sIKdglZT1LHKiKuujQ2eZADU40dbUX3SH2sc2AWpLOXRu0UOcYl2ZMoY8rYKp4R4XZjvyXnPw65rkjmezKR76EnNUninH4FbSmTejEnukFQFZ2wX5V86+VEqJGXPiCDrrR5HlGLrrQg0F0d2J+0NONSkc1x1yXRKAR06NP7/37zJlfYTYvaHjZEEhg8KDs5JpvZV3SgzvCrGAGuRvq3pN8Q+7JBD7yC+BjsV/jVq+CrkQLpcIR+vUAZ+mbFWo8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a300a671-753c-4a6e-0f20-08deb0e5c268
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 11:49:58.9603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ccVDFszTvN/AgEIy6CJGcr3fhRpfQHMXfqxcu8s40j8m5mPnIELlt8t9a0RmNS3g1Cuc5S7DJeK3buqWkKef+S/FNAeZ0zBr3ESimoqJ4XRqV44cevzlVchtDDIJ99Tz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605130124
X-Proofpoint-GUID: UmoeGJF6fj5plOY0aZ2U--R5f7aCXMH7
X-Authority-Analysis: v=2.4 cv=V+VNF+ni c=1 sm=1 tr=0 ts=6a04656c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=W-_n0kkjAAAA:8 a=ag1SF4gXAAAA:8 a=RHKfw0J1o_kT-zKX0ucA:9
 a=QEXdDO2ut3YA:10 a=qeNa2pbTr82C0GpJEZFS:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: UmoeGJF6fj5plOY0aZ2U--R5f7aCXMH7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDEyMyBTYWx0ZWRfX9K6stC5Xhu0L
 H/Ua1pbMlITUA9sj+Mnri0oweFVVDXI2n91XE3blejVHwLzaHWE7Ycr+rdMnamolsSR7aL9bYM5
 tgC5tPrxQ8CD/85JGGxuUEY9Tq2f014FWLEujZVpq0DqpJlY1cgi/f5smLk+KJA/2j8YVAjY5tJ
 xLZXipHpZ1aY4Y/+Q/d0vQ0UYXLlg1a/8Rk+avhuLv1SMKwfd9F9icfHQMmMNK8u75vzMoxhmwk
 sFzRdncg+O9H4O9Uo3V1Z1enGSpWLErCOrq0ZsWCa5CRlOhE9FFgK1xBltm08sfFIbQMp7kGRSY
 C/rozp2GEowmtil/DjB9QCYKBB5lFyHkvQmVVh5gHyxViX3/JiJ4B/MZqyQ7NiZMwiKL+xCprIl
 473dZ59oTvZCDZKuiS8f/54ihZPRRzIIWdL52Ugv2Kc0+EmYlV69qolXX/+AerwruqHkwoBwOHr
 9I2nJeLi2c1CnNKX5vw==

Hi  Greg,

On 12/05/26 23:09, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Osama Abdelkader <osama.abdelkader@gmail.com>
> 
> commit b7c958d7c1eb1cb9b2be7b5ee4129fcd66cec978 upstream.
> 
> When the second kzalloc (host_context.vector.datap) fails in
> kvm_riscv_vcpu_alloc_vector_context, the first allocation
> (guest_context.vector.datap) is leaked. Free it before returning.
> 
> Fixes: 0f4b82579716 ("riscv: KVM: Add vector lazy save/restore support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
> Reviewed-by: Andy Chiu <andybnac@gmail.com>
> Link: https://lore.kernel.org/r/20260316151612.13305-1-osama.abdelkader@gmail.com
> Signed-off-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/riscv/kvm/vcpu_vector.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/arch/riscv/kvm/vcpu_vector.c
> +++ b/arch/riscv/kvm/vcpu_vector.c
> @@ -79,8 +79,11 @@ int kvm_riscv_vcpu_alloc_vector_context(
>   	cntx->vector.vlenb = riscv_v_vsize / 32;
>   
>   	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
> -	if (!vcpu->arch.host_context.vector.datap)
> +	if (!vcpu->arch.host_context.vector.datap) {
> +		kfree(vcpu->arch.guest_context.vector.datap);
> +		vcpu->arch.guest_context.vector.datap = NULL;
>   		return -ENOMEM;
> +	}

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:


Upstream does:

index 05f3cc2d8e31..5b6ad82d47be 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -76,12 +76,15 @@ void kvm_riscv_vcpu_host_vector_restore(struct 
kvm_cpu_context *cntx)
  int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu)
  {
         vcpu->arch.guest_context.vector.datap = kzalloc(riscv_v_vsize, 
GFP_KERNEL);
         if (!vcpu->arch.guest_context.vector.datap)
                 return -ENOMEM;

         vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, 
GFP_KERNEL);
-       if (!vcpu->arch.host_context.vector.datap)
+       if (!vcpu->arch.host_context.vector.datap) {
+               kfree(vcpu->arch.guest_context.vector.datap);
+               vcpu->arch.guest_context.vector.datap = NULL;
                 return -ENOMEM;
+       }

         return 0;

So when second allocation fails in the error path, its frees the right 
object "vcpu->arch.guest_context.vector.datap"

but in the backport:

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index 8454c1c3655a..eaf88c20508a 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -73,14 +73,17 @@ void kvm_riscv_vcpu_host_vector_restore(struct 
kvm_cpu_context *cntx)
  int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
                                         struct kvm_cpu_context *cntx)
  {
         cntx->vector.datap = kmalloc(riscv_v_vsize, GFP_KERNEL);
         if (!cntx->vector.datap)
                 return -ENOMEM;
         cntx->vector.vlenb = riscv_v_vsize / 32;

         vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, 
GFP_KERNEL);
-       if (!vcpu->arch.host_context.vector.datap)
+       if (!vcpu->arch.host_context.vector.datap) {
+               kfree(vcpu->arch.guest_context.vector.datap);
+               vcpu->arch.guest_context.vector.datap = NULL;
                 return -ENOMEM;
+       }

         return 0;
  }


we should have freed "cntx->vector.datap" but frees the same object like 
upstream.

So there is a cleanup target mismatch (cntx->vector.datap allocated, 
guest_context.vector.datap freed)

I think we need to drop this backport.

thanks,
Harshit

>   
>   	return 0;
>   }
> 
> 
> 

