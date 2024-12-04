Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4001FF5EF
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 14:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733322518; cv=fail; b=KyBdMP5SxunvYJejb3SROutaqffosOswn10xVheFgWu8XvZ2+yt3RhW5qTvCsKEhdlko17ohsOAZzFanGdJirUx0Ht29/zLbPC//nCgejqwqm+3rl3HaDZDAgbe+gnDGYIc6rveyJ1t9wYOFkqwQjm+h6cS2r/yJeBFEzxl/yJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733322518; c=relaxed/simple;
	bh=zGNDBVIHPHLIQm3X/Il7FpoCpcF0MuIri0UU3F7yKNs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A8XgxuYVHtiCscj/yNaEhY25baSS7haLds8Tu5ny8iLtpntaKWhcygSWW3N5kY+i8HVdBpuJH1HnnVILoPVQjm+FibOWeyqln97mKFYZyiWMDxq7PjryRd6md0kaVAZkNfiukWMeulZX+FLfRaxR5FK6wabwoi/D/aXIq0XBOyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SF8jh31F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aPSHHxIl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SF8jh31F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aPSHHxIl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4D0ltA026789;
	Wed, 4 Dec 2024 14:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=om4XGBvqP5g0eZFn/4ziU4kJ7qef75FnH3/ZbcbdAgQ=; b=
	SF8jh31FgPxyIjyb0fKL2p5WtEtHa6dkD0QIEY6bQKiQYr+lhTn2/qpn88+svLUH
	FRBuQjRFncQOfjhyBhDrEpVqhwwOIjIYB8WPBwQePR6pBBIe+uEQNgrd+0a4d8wz
	t8HcNzt4zNxMJ6eIQiEOcE8HXNWpw78Ax1Hzw81Z8FtsSNC/xGzcaQ4j97Xl9RsL
	+TRblrF6riwKEzLEAKxJYlpWbIvTVv8gaVOr/r9SSrrKKTfjpWZkBSSAfTsnM1li
	vaiAEvzzrlnDciJNV5M/rtNboLkeDdcJkwjreujeqsRyMV41B29V0FM30HedNV+Z
	dzYPwzdeSKHjqI/Qg4qYlA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tas8hhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 14:28:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4DKjnL032787;
	Wed, 4 Dec 2024 14:28:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s59jbuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 14:28:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hf5t5cs7zNZvTAB0di3Zg4JYoYYTXlbP9vX2H39tjevdnXd0BTqA5bLHwdDZHhiMOOzWN3E5z+tGPHxTjU7tLKqR2xr1USXoI1KCMKI6GXA47LDEWFy3XIdE325fE1RSU8+L3F++SOO66Cx0gnWKVFSZt8GVrGvCVPoM5zJAzMynEVfcYXAvCYE2UidgDA2NGGQ57gFwjFvv0Fcg3DTFviGmiIFQuu6nPaDBVNpSmE7HMP/EKMVLoW07AmGRd/lpT2N9wwURX22EmiytL6TJqFJ8n3LacQNTh2tMhBNdqd3FvNniF33NTheztsK22WIKJ0ch0B8LDevWJwJJRwvptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om4XGBvqP5g0eZFn/4ziU4kJ7qef75FnH3/ZbcbdAgQ=;
 b=U2pX2NJnMpFwX6zN3Subc1hO9a64+02ggXylcQ9HW6gxqsMXbENkqoOmUH8idDoFDEwOzUnL94wA4bnRkSoX3nhNFY/Gy+BTees1fO021lcYfrvg7jPvlS8iot6qwJ+nR0C7YscsOBq0B20H8jN4fixm+r3sBJkYr17rq3WKiDQq2p/1xkYvnugwO1h/I2PJGADlkRXj6m9Xq0aG/7OFWuQV9RZ4Igs8IvasgVZyIcCEH3wh+ZpHTQ1oYkBbZ2QY5opzGa1v+SeRGJKOx6oP01TvQmxkm3hA9lmXrsNP6kwACN9gZS8Ywp3w0V22BUQ8WGWVbibfXMKBGW8xk3fL2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=om4XGBvqP5g0eZFn/4ziU4kJ7qef75FnH3/ZbcbdAgQ=;
 b=aPSHHxIl1ELac4uPJ7JjOEQLVxuze5owrzGLaos/avzeZZUPoUZAj/v96OhvzCziBzw+YHs/9xwECjUdYDYztA1lXJ6qabRkS4+60FMp34XzhVX2NHS39DobFNQOZSmf1uRJeqvGoX7pKh7iYBL0WzQGOjNx6CijysJCRiQXRYs=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by CY5PR10MB5986.namprd10.prod.outlook.com (2603:10b6:930:2a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 14:28:21 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 14:28:21 +0000
Message-ID: <abb95879-eeac-4d29-8a9e-b7973052db77@oracle.com>
Date: Wed, 4 Dec 2024 19:58:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241203141923.524658091@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|CY5PR10MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 35e87d6d-dda0-4007-ecb5-08dd146fe739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVA0NHFLa2hIOFJOQjRyaHVmOThwTThKdjhNY1E3M3BWclM2YlZSVFVJNWVI?=
 =?utf-8?B?Mnk5eCt5UnAvRG1JNHl6MDZTOWtlb1NNMk5PcFJ4UElWSnA4Ulc3MC9UbXBt?=
 =?utf-8?B?ME9xcnNiRWMrMDVJVm9MR3JxU0VkQnQ5NmRpT1Q5aW1kd2RSWE8wKzVrbkxI?=
 =?utf-8?B?aUhHekNhcWVOL2RQRE5JbWhOandyYWhDb21LdzNEQTJab2tMVXBQOWp6emJP?=
 =?utf-8?B?MTRkWmZiYUVFYzhFZFNwZ2c0Mkh1aFlZTWl1bWhMUWNBaEFRMks5LzgzWlJv?=
 =?utf-8?B?Y2JtMDJEUUVNdS9QTjAvN052WXFta0tVWmhxSXdiYkhIbjJIVTZSVEQ0NjAw?=
 =?utf-8?B?RzBwYnNqdllVeVVDS1JPWHpxcVpDVUE2QTZ6VHNJc3pndnJUd2xqeGtnQjJ6?=
 =?utf-8?B?Q1pFSlFqY0xSSDdCVDY4SjdCWmFwdmZjTDE5WnowSzlNajMrQys0bkVyQUtu?=
 =?utf-8?B?QTk5UnZ5NVozbmMwWFkrY0RJOUJocVlRNEtlTmFxdG9YaEZMeVBDVzZVNytt?=
 =?utf-8?B?VXhaR015VktrLzVQQkIyczI5c1ltWU9zblhLeGlsN3paNElLakNsMnFGL0dn?=
 =?utf-8?B?eG5wdm5XNUFFdW1yNUdieExSZUs3RDNwc1ZYTTEwMTFtUDRzbEN4cTVGWWY1?=
 =?utf-8?B?RjZRK0JjZVdYbFllNkdYY29ELzdZSlc0S29zZ2ZJRkp4d0NPZ2NJaFFXNHZT?=
 =?utf-8?B?dCt1bFZYSDRkclJOSkw0UXpWSUZ5VW94emlYTDNZTHdyNWMzbFZCUnordGMy?=
 =?utf-8?B?Sk1HZGdGVlRMa3gzUkVvN2I1aURJSkdYSVJ0bXAwM1dHTXVOMUpScDN4czdt?=
 =?utf-8?B?VXNyY0tHdWRGTW95Z0Q3TVhMWkdwbm0wR3lhMDAvZDFhVWVJRkw5ZSsza2NW?=
 =?utf-8?B?dncvTE5DRGlrOW0rMkpNUzdmcklNU0oxZlEzaDgveWFlWWNidW1tV1R1eUsw?=
 =?utf-8?B?TFZBSlFpQlhIdENrL1ViSTFEUXora2V1UGJkM0VwVlY4dHhIalYzWmxkdklZ?=
 =?utf-8?B?K1YxUzdRTytabGdxMkZDTFV0Ynh2MUpTMjNOV1UwK3llNy82QmZ3emttMFh3?=
 =?utf-8?B?Yk5oTjVwTXAzK1Q0aklVYXd6WWQrOXJzdm1zR0hqakY3YlBIM05MZmdTM25L?=
 =?utf-8?B?eisvQzZ4L3lpbTZxak00Y24razBFMVlDYStTTW03ZXBQaEJmMStuUzRsZHR0?=
 =?utf-8?B?eGFGYkc0WitYYm9RTzNDR1lNcnpRM3IxeWtUMGtEbEpDWXJWaUp2d2E2enJB?=
 =?utf-8?B?NmlUeXVqNUJrUXpJVTJBMml4QXhQckp4T1FsWUpKZjBTekhKZlNTOWZ4VXJi?=
 =?utf-8?B?Z0dxM1F5UncwSWhNQVBPb3I4bXk5TytRYWYvYUFqYmRhcGxsblpPUXFyOGpT?=
 =?utf-8?B?MmtKSE04MUY3WW5VRVI1YTVoTmFOOUw5ditRc1lLZmJkSmFuWlAvOGRDN2xI?=
 =?utf-8?B?N0FqQkx6Y2ZKb0VvdFJySjBZNDZpSm1rdmFxYnpvanppZXNlMjNtVE5oVU42?=
 =?utf-8?B?UDAyanhPdkk5MFI1K1AzZTgveitlaHFmMXhld1p5M0k3UEhCcXJOd0VOUmxn?=
 =?utf-8?B?YndJZGs2TExmbE01aU15VVVhb0ovRzI5SWk0TDBLQ252K0hGQXJUbzN3MDNu?=
 =?utf-8?B?Z0xEV1RNV2xsZHZQV2Y2dGpFRVdZOWJxeXZUK2Z0c25IZVo3clVZc1VmRytE?=
 =?utf-8?B?V1NFNGdoSEtxNXllZXM5VUVyYTRoOW5JTk04b3pLTVd1dDVnQVNDV3dwUjRD?=
 =?utf-8?B?UEVBbFIxQXEycWFUT0NRM0oyRnBCak9oblgwcWo4a1BlcTkweWcwL0JtaUNw?=
 =?utf-8?B?dUdOWVVISitEdFRnRTFVUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjZaam84ejV6bFVtUHJLUUFmVGJPcnRWcENQRXdjNC9KZlpPK3hFdU5EeS81?=
 =?utf-8?B?ZTF4M2QrWnNhNFNETWtkZGc0WnNCNXVRZzVzYm5MeHpFU2lBcFFuaU10am43?=
 =?utf-8?B?bFBLSTczczVVQzlLdk1GR0xNMVR4WEM5VzlNUWZmYVFLNld3NEFzYU5nakJv?=
 =?utf-8?B?YXUvN1VrTCtUYkpjSzhrRUgwV0tiK2NtNVJCdXZtaTF3TTJyZmt2WW9iZk1p?=
 =?utf-8?B?bytaNklPZkhJOTRQY0xDUHoxK1pMYy9wd3pZT2YvMnN6WkJ0ZGVZd1ltcjRv?=
 =?utf-8?B?ZFB2Q0JhcXhCYkZWUnlBcStQK21xNndkZ2l1L2NmMjFmUHlvaXUrS2tpR1dh?=
 =?utf-8?B?anJpM0hBN1RVWHk1UG9BVncyZ01FQjJSL04zY3hSc3o0VGhGMkNRTUlOVkF4?=
 =?utf-8?B?alNzaHNxTnF5NSttSm10cFFieXhkUVl2Vjc5QnZjMFNBc294TXl4eGlsOU9n?=
 =?utf-8?B?M2NSVjNLeUxabU1KV0lUYlJxbGF6emVnZ1EvM29NNkwyL2ZJcHVNL1VYVzdo?=
 =?utf-8?B?UEFteklkSWtYdjdkcjBUWHFxN21yWW51ck92MC9KUms4K3d4UE9aMW5KWG5W?=
 =?utf-8?B?eUJJVGYyeDZ6OUVyRG9pbFI2RWdYbzNXdHZOUitDaFA3V2cwUUgxZnJEb1Na?=
 =?utf-8?B?Z3JtSUZLUGZpcHVRUkU1UUtVcGNZbFBoZTJnTC9pLzVPa3V3WHFlVlhncVFr?=
 =?utf-8?B?SXhvcjhxNVVuY3hycDhNRFJrTzlJNXlKTFVJWjR3WGl6OExXdElLWWlLV2x0?=
 =?utf-8?B?dnVlTkFyYUg1dXBLVzlDZHErTFBFbjB3aFdxd1V0d1RkY3JXRnVVc2hhVGV5?=
 =?utf-8?B?WFBxUXV0WmVXR0RvZkpvVUQvMThUU1MwZVBhS2JER2NEdldvdEZkbGJzbVg1?=
 =?utf-8?B?aW1NMUJDSjdTOXlGMFE4QlorVWlObjV0a0VkQnNiOUtMbEtPNEhEQ3JFMU9G?=
 =?utf-8?B?bUk5YUNCYTJQVmJCTXlsd3laZmNQMFY0ZkJOVHR2VzFGdzczZzhoNXBJM1Y0?=
 =?utf-8?B?YXl5S3gxeU5wU2dTV2trcTNzUVFNRU5IbXhQVmZvclVwT05sRm92Uk5MQ2Zq?=
 =?utf-8?B?M01iUmhUVFpFZ1pmTGhxWWNiaGJtbTdmRS8rZU1MVzZOZ1JIZnY2bVFZNThT?=
 =?utf-8?B?ME9yeVdTaW10NEZLcytQRmU5MTdnUmFaaFJDTFI1d0ZsYU5BSDlRbU5sa0Vx?=
 =?utf-8?B?SHppRVVpMFBTK1pYUnlxWjlaTm9JVUpGRERkL0Vrd3k0VkJjZStPdUk0aEpR?=
 =?utf-8?B?N3Z3eTViaWJaWlRnaFBSZVBMeUNyTStzblJkcCtkNkRMcE5pU3laNm1ycG96?=
 =?utf-8?B?SHZNakxHYWVpY3NneCt6ZmczVm9taC9BbDRGeDBERlVkVDNVQlpFdnNNb29K?=
 =?utf-8?B?N0xwcTJjaXlCNWlVeU90RWhzMlpCRzBjZ1o4Rk0wMjQxVmg1RUwvNTNOQjhR?=
 =?utf-8?B?cmRqVW8xTnhMZVh5YXNoYytNeGlTOWhQMmxDSXhzTEtweEkxZjhiMkFCWFNv?=
 =?utf-8?B?bnYvdUoybVNiRVBqT3VnRVVpUnEybjViMi9vNDAxdlJJVmd1VTdkRWFLNm9n?=
 =?utf-8?B?dVpkbE81QnVrRVVOM2xBYkVLTE1DaDgwM0pXNGU3MjlCSG1KSGg2YTRQcEVC?=
 =?utf-8?B?cmR6KzlWNlltbGhwZnJveGU1T2xDbkYyajVvT0xGM09OZkREVjQxTW1TSFo5?=
 =?utf-8?B?eGozaTcxQXZHbGoydFhZV3hPT05URFVUNEVxRFdNbU9xRVJpUVhleDU1WXI1?=
 =?utf-8?B?TXlITjlRdzNOMTZqY1RHeTVDNUhJL3dHMDlKNEtkSXE1N0lsMFhEWEFQdUFZ?=
 =?utf-8?B?bVdNTVV6WU4rNmZjcGFZUzhhQmdjdzlHRDNXTXBtTkJrbm0xZVpLOU9XNk1X?=
 =?utf-8?B?N2I5VFNvZmJacGNPZm0xK1BabU1idWhCU1lQVzNXUFpNdWt3dnNKY1I2a1F3?=
 =?utf-8?B?clA5TE9uVlp4eitBdHB1Z1pSVGpZa0RuVU1pRGt0TS9SS1dwZEtkR0xuNmhz?=
 =?utf-8?B?Nk5JZm1zd3FBckxUZHJPS1VYTVNma1pRODRuWVh4UGh3YWJrbUZUNWFyREZQ?=
 =?utf-8?B?L0c1dndaTGRTNWVLQUlqcjgvVnVTQmErd2h5cEpKVU1ZZHJTWlJ2VGhrUFpO?=
 =?utf-8?B?bE1aNExyZWplWlV1WFpIN2NyUUdzSFNTUFJxRzZpSFJ4R0NaczV5VTVOQjk2?=
 =?utf-8?Q?rwMbwqNG2qY3/sH7PZ8mRDc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	351avWmXo0B442zTOdAOqrZexXl5JaZlM/lKk5GBreLy3LJ3J26L6dRIMzY24rR9bwo51j7VCBCMaEfRS/qiSs0NkMLI92dN2aIljDTKSOw037lMJDotNDeQZWo2tcv7rNUlstvMbDF5BfX6q3sAES4Iz43QTxKYQq7zICnRnGvJV5xfYFPstpfqckgDQe8od7m6R+z2Xt2RqBlYfmBu5NK86RO/Pyxar5UybBUeO9D9NoHd+3U9XUUw2WBLbLP1egJ3bu9SfNTNaXoFrjbWTEfE0CsHxiwsIYi1ueY6myFVT/TszeEtBzKU/R7o4HFXeJ4/EZqAnllNtPgaMQarlBP2b/1n3mPiYOvpxAmPpgZuEa/Pvmt+E8mSIhRS1HWIFWPgIZAxjT/PbszKF25XZ9GlpFNtJO3fI3KKGNHy2pVw1dWPvlOh7XT4+/V984RytOE3REfaKG33wfZz0TdxpQyKhQrO7Z0Tu9E4bTl5sJZA8DUG1UyRaKRYb8kXRP8EmVtDmM5DEGFYLz6N2vwTvYuwU721n10i9e9hzFAeURHXcfh+55LRA03sP2sZbmkeb6/X8GbzlBNg5+bVR+3pwHKP0Uh38FDUsR7GS3c7kWo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e87d6d-dda0-4007-ecb5-08dd146fe739
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 14:28:21.5618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PiZuxPTfK+jK1BFIYGgwIQkoGqouYZbKXU20yRJ/xPFbRkN0dC1NXqbCqt4EzkrDV9vjYdfq9R5XLCbycSmXtQNDUsXVzcDbm9UDdO965BHrM+4y6rBrHS3mCX2DWbp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_11,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040110
X-Proofpoint-GUID: kyV8KcQjKby8MTQYCN5ZlxLPXnOBZjM8
X-Proofpoint-ORIG-GUID: kyV8KcQjKby8MTQYCN5ZlxLPXnOBZjM8

Hi Greg,

On 03/12/24 20:00, Greg Kroah-Hartman wrote:
> ------------------
> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> is end-of-life.  It's been 6 years, everyone should have moved off of it
> by now.
> ------------------
> 
> This is the start of the stable review cycle for the 4.19.325 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
