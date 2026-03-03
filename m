Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B113C6A52
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 16:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772557193; cv=fail; b=dapnhdF2FGl1OBBPBYVOES0BvLpgfcydmZHfU5ou67xKE/e3f6rQ9QW4izP9V4E/VlRZw73QqSeH2WAkRO7PRagDmauTW4TlQ00A8ukeAcuR6UUCPxUqYqDSoiLoK9lOd49e6apCI3g4FvliMKOWG+SnDJW9I8j20VBc/KR+9Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772557193; c=relaxed/simple;
	bh=ZxyvNxOR+6wyvyF5WBE134iR+4cNKC7vyH0fD5yDBvE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ImcSmaoeDF5VzBijRQyacLzS6ldXdZMM1beUIupMhS5Tplv3E6zGQ3O9FElNR5HbwWysCF8gd/PE0jwItoACkUgHDAwdon04yFJp14lzKJQvXoegF9se+Z9S+VNphHefjPbcDZJ+7Y73nR+4ldLCwswe5CFqUhL93ystvmEa4wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CaR6pc2B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iAyYzbL0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CaR6pc2B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iAyYzbL0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623GcPhC2047899;
	Tue, 3 Mar 2026 16:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iyOk5wU0xJuQuTpUjWHylpCx1FefMEZvEO56BNS/oZs=; b=
	CaR6pc2B+nSiLq/gMNgOuoxVU2AsRpqYEJyDWr+OiaQy1IvvxTR7CgO9qbWzJtkQ
	O5Ito/ZHTmCmsTet9RJ32BrPiZXu/DgvVQbI7jKnCaEos6HaYsF/YdKGRDQF1nQQ
	3x2TPZxvkzbbxeq0lmLTSPYgG6j2LZP/UE9rNB8FrppvqHmg/mDlKN6HwAQmtCLH
	3wMmhi2TSYg61FTZOJtaqId6PkyADErMNfPVIRXr9fv7v4ozwopq7hI0MzspDtkd
	3uMkTFUS6kVM813GAhFhV1QWWVKlkQcIekbor5a/4FTRqO5Q6OvJyolltp2UNKGj
	RWdYaoBeIjV2z9M7cX3itg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cp3b8g1a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 16:59:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623G0leR036951;
	Tue, 3 Mar 2026 16:59:38 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010047.outbound.protection.outlook.com [52.101.61.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptaaqnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 16:59:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xu/hX7WStiG01ILVAs5ffSNlM9eSnzGU48PIqsjo4oevpuR8kkCgBvD7KLt9hSqGtVY1p51DS2DERGZjUvbT/Lm60AkX5mKHoBBZDixfPemAITzXEmV6djWNevWtO1iCgYMQz0l2CWpHGO5tWB+ZJk/difa9fqkHuo2qxXfzXCyKgnCLQZSdGArIIHvDLaB+Oi0fJEU2lih1Kpyd6akUzdv+udiQOVj1VbY9/exXzou3q9A15vmCYVqD6icrHOpp3D1dTU/BqIbCl1DTFnI8TCFaUK57Bh6nL0T6/KCXJaqT771CE1oL9hu+JPSq/ZiNX8M0Fxn5koNa92X3G177iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyOk5wU0xJuQuTpUjWHylpCx1FefMEZvEO56BNS/oZs=;
 b=DEG2SvtJ0T10ktKlaipBNOTFxpq4YpfaP/VYLT355ggFoFRPvdMOwYPVT+Ni5fOdYkTkShSQV5vEwiZmQJdjTOCjF698vwz1VQRPUIBrRCB7ysFqCLwYJ4z/HtUFFU9kZa/UCpLvi+v6UVKu8ia20XMhBJEaKXGldrjiF6G0M2I2V9GhVfjPwNXEPtO4D5Q8aQBI2MzTOqtWmGRwRaohI3iIl2wcrEQ6jhFdIFmUWjyBM0XqL5Q8VCz3Yp9BVWsvg7fxYh6v64/Vw+Gvg7VuZJX2tWuXpE+4h4rfDB9U+zouxXU7j4npT5/P63RxnutxO/4Nmmox7SIpd84Z3XDoKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyOk5wU0xJuQuTpUjWHylpCx1FefMEZvEO56BNS/oZs=;
 b=iAyYzbL0rKlezQZAcFpOb2C9hMS7UD2OoxA8B9k65DURTFfSWT4T7JQc8k13MmZ9nqTc/yL6R6pBZfZnBDO1VywdZ9MVhs0QwLOJErKBYJe0/lyf3kgqWEgX62wu8GzIuw+R2LCmdYooddBp4uqz2DDtFyCmWoi4Z/uc0lrK75I=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SN7PR10MB6307.namprd10.prod.outlook.com (2603:10b6:806:271::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 16:59:35 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef%6]) with mapi id 15.20.9654.015; Tue, 3 Mar 2026
 16:59:34 +0000
Message-ID: <22ed9b3e-c634-4f08-b6bc-de3855bd58e0@oracle.com>
Date: Tue, 3 Mar 2026 22:29:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260302160955.2522727-1-sashal@kernel.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0285.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::19) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SN7PR10MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: 69d1050b-08d0-4cb5-d891-08de79463ed5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	ej+XahUZaVwKWB1JjO1tclSOoEeqoiL+JaQJQQAqd/z25kdGFEkzaK+QaMXQpT9pIqWxhZEItnvoY/TNoc0+V9JcszVc4EVzPofRwd0PynpjYHk6porlwyV2OF7aq1VY67xvXF01viUN2ZmfIHdviXdJeHXSGSP7eY8wM0LCY5HVyZF9XlGY5RPvOv+KNzMdgUEgym+dKYhefX44tjDelVmug+RjFyRAfLAqQVhjpVhIjklPvMNdwD8jojmSwB7V2XtvAiskVInAXq9GdnoGRlNaheDFDw8z1V6oXsbG+sP2zBVXPfjM9pRL+HN4e3Cj60++C9vYgHAb5ptkYrdmkZDg3fwO4XTortadapMKM6a+9ykcMvKQHpGP+OVag4+7muwnnVdsmsrQblowHQvbltG+VJw40sWLJn/rBJnA376yRSK3kJ0C0sglw81/AJdg+5Su/nrr7IGTS85u4qZRNmFYyh2ajT4IQQ8hGircJXHDE+GBAO5FvOwAH8wfrGhRyEJo6caOuq7XgP9Kt0tvCEQTV6RkmgFv63uTBrnJ2u4enJWFpxSoz3yElgE4Sev3avy5xEOXequcWMHlt1rnEk1uW9RTybt2UAfn3XwoMl6hbKfU83OtTy2CHhRmBePFMMtSp8R63Eq8nbEQW/ZkT63Zn5WOssBrgGRss4AANaPLi7FJjxKhWkDLk+9hu/9T
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0ZRYkpNUTZtNW44cDhQWUdQNG8xSDVmTFhIRUxWb2ltM1Z1Sm9LTzNSdDZ3?=
 =?utf-8?B?cEtJS3BOaS8wT3F6Y1ZPTFphSHRtMDFObVVJd0UzTzlRVmM4U1A0MUtBK3lo?=
 =?utf-8?B?WTFVa21qdG1SSG9GVjRvQmZCaUpuWWRzLzAzVE5LVDdnRjlUUDVjMHJ2SWMx?=
 =?utf-8?B?QURFS2VnelI1OEwwd01OYWhwcUFMU0V4ejV0WG43S05FbFBiV2I4TFZSelVp?=
 =?utf-8?B?N2NvWnZSbkY5NHlySFdSeVhFWnpVTy9uOTBSUVo0RmR5eDYyZ0xJUCtnZUJl?=
 =?utf-8?B?ei9VekNzbHZPeWdPWkdqMjBpQ29xajhobG4yN214WTFSWWlTb1RSc04xRVpv?=
 =?utf-8?B?RTBSdEQwUUxTbEJwZ00vdkl1R0dCaGlJNW9EWmdPYVh5Qi91WFlCSm5EakFR?=
 =?utf-8?B?MjNuNEZsRmZGYk04bnBOWmsvYTNtS0VtS3hlTWFhditiUldUeVlaUkIrS1o2?=
 =?utf-8?B?bEFuQzBWcmkyaXk3K2VjVkVsczdDWjh1ZU1nOXRjUG9RSXk5dllqZHEwWmJF?=
 =?utf-8?B?SmhOSmpaeU03L2Z6SkMvOHdTYXdVN0RBL2xFVG5xS1oySDNNd2Uwc3NZck5D?=
 =?utf-8?B?cjZITzdwVkxHTERiemhvdm1wb2hzY3U0c29zSUNEcElpOFpYUjd3OGFvdkxW?=
 =?utf-8?B?WEpmOXcvSEdPWEdLNDh3ZjdqSmFSUDVPWFJFVk80am1tOGordTBXRUhsTzZR?=
 =?utf-8?B?bWoyQTFhK1F1bFk3QVQxaVJGUFZqZFZKVjdiY3ptV09lRjYvejFjQ3E2SHJj?=
 =?utf-8?B?UjQwUzBoaXhVSE5VeHZiUnR5N0IwMDAxYmVoUXpVWVoxaEhObzE1ckE4ZEdX?=
 =?utf-8?B?akhzZnU5YlpyUkxNU2V5T3MrNnZjRjgvY2NRSm4xVXFRNUpNa0hTSnQrVmd0?=
 =?utf-8?B?N0pFQS9rT1NsYXp4ZkYzV1FJU3kxSGxEN0d3UHVJaWJFdWJTTHJhZzdJNFVo?=
 =?utf-8?B?M3o2Y1FOdElhVGs3cE5RT0dpZXlBcXR6aDkvSlFORWx0bnAvSURTa0VrQjZl?=
 =?utf-8?B?b2s1bUY2RFZZaWFmK0hoa3NXcCt6VmNhQ3hpZVB2a0FISW5UbElzZlA2ejRJ?=
 =?utf-8?B?bGNrcEwxRmZhMTIzTjVjVjVHYnNpOFYvQmJSQVFoMS9rMWNIK251TTFEUUty?=
 =?utf-8?B?dlNVZUlLMmV1QlQ3SXRYaThya1dTYU5paGc1Nis1L2pKQnVyb1Nudm1jbk9r?=
 =?utf-8?B?TWZ0UTBNWUtmY1F6d3ZKNEZ6TjVhMFZ0WXNFdWRXTEw5Y1NzVkFuR1g1M2ZY?=
 =?utf-8?B?cWptOC9pbzVLQnFqTU5tdGJlRE1JQVErWkFEWXlkek13eDZHZUJhdDBCeWZY?=
 =?utf-8?B?eURGYUlwazVZQ0REaDNhSjFlMFFDVnByVklxMWV4RHh2ejVQS1c0R2I4cDBJ?=
 =?utf-8?B?L2lnS2lhUEl4eHVWMlNjdTFmdVZVUlRKM0FLdWdwVmxwbWZSeVlhaTFEbHQw?=
 =?utf-8?B?d1l5OEtaYTJ4QzVBaTlUUVdPTGdpVFlZVTBBR3FuMjZPZG42c2NBSUhaWlRE?=
 =?utf-8?B?ZzJBbWhvZGVkSkJFelllT1F6Wm16S2xIT2NGNmVFTW1hRnRvR3R2NGwzOU1t?=
 =?utf-8?B?YlhnYkJSVU5hbFVoQWRUNDRTNHFFRnlIZnltdmJHcGZUM0NjTDlHd1F4QmNr?=
 =?utf-8?B?S0x0MVNrWVNjaWgwWUZEY3F1ZnU1aDcxUEdNWXNLMXpGdDhCMlpYd3ZlRHBB?=
 =?utf-8?B?OUFROVVFTXNiTDNiS3pXSG1xdmFBMlRzNEt0OVZzVkVxSGNTZnFYbm56ZVp0?=
 =?utf-8?B?UkQyaml4U3pQSEhQTG9keUhCK0M5TEEwdk9zNnFWcTlYVWNvcStZM2VkN2h6?=
 =?utf-8?B?UFZKY0p1bjUvaFBTSnpMc2drYzdBa2dlb1IyRmVkMFB5eTg4UVQ2NDZ3eHpN?=
 =?utf-8?B?TjVMRnpmYm1iSjZlaUdzN2I4VytJdTBMZ2d0cW0wUUcrTHhsRjVUa3Bqbndo?=
 =?utf-8?B?ZTRQMy9seS80R1BNWXlySU1PNjhzQmdWRXdCWUdTVzRpcCtMMUF5VEtUNGhi?=
 =?utf-8?B?UXhTazF1UWw3K2Y5VXFIOWQrTGN4Q1dFU3FjTXFXcm5hdm80bDRPanRhQU4y?=
 =?utf-8?B?VUxHUXdrZjFobUtHZGVCOU43UnNmUE1SQXJCRm5qajNBZ2RTSXp3N2VKQVYr?=
 =?utf-8?B?cVVWMERDeFFFSURSUER5SkcvaHdGVklKQjlLcVBKL05UQ2J5RWkwT2dDV1hB?=
 =?utf-8?B?alZhb2ZONUpVMmQyT3RHbkR4UUNjcWxWdUVlaCtMc0ZnNXM0czA5NHR0dWRz?=
 =?utf-8?B?NFNkckFUNEhmbEROdUxmbm56NUxKc1RGYS80SnRCbWFDd1NidzRhSndJY0Z6?=
 =?utf-8?B?VW0yeTVNaG1mTGlRVk9BVi9Fci9xWDRsMWhxOUM5MlNZS3hxUnlBTkdyZ0x0?=
 =?utf-8?Q?c0RY3sIq8BD+42Vo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qnxYasXg47Ij3/Q89N+OImwu6mvSaRj9wAy8siyRPloKwlc6pgcQfxyq1/QyLdGOhblUvQO1eX7OacVirFd3ODggEp+TZrIxbiiDHuHJ9dH3eFJOutMbyO+Fj91sfQZArKOFkv5Bfr7X39YhhcFveWgq+M8P+zT55Z9p4sgHh3ovcbE4pQi8Niuk7THNcmiSAATkWtZ1UHG+AkaCp0mGQwRfH0q0D2Bz5q7aWu3Jm9mBTPJlFRmhOIs4X1r1M2OHGxnqQ3EN+Ktcqy/ygBho8P3d6ecPpZKTDcmBhYExPCjt+BitBJSBygA4vaECiXeNmFXIR+03VXzkGwCUtZq+gt/SvlgHviJZbV/WMTiK2y+eFg83bIMYNn0ZRFynCA5Ih5oTivJPPZOTKf52PmW9c4rfVVyUB+QSw3F/wYU2coq6pYrxhV4ehm2XwryYn2/1xVvpkPdaW+zgo2/tw7lpiGvV9KC/UJh4jVRd1pLNHGRfTmTanKYhsehYCvWHDaP6txI8GJ0iWj128X71d0ElrNmjyxFzTJRBwnCI5vNpyxTND7Y1tr+3xeOL1RySMZwQzhNQ+1bXcvVyJ4QMZahkrkmKE/wMHwkRjzD7mSWhEsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d1050b-08d0-4cb5-d891-08de79463ed5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 16:59:34.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LQRkA5nBhMOJGwE2qXTw9VuY+rMpErCY8TYQDdIwRqQNSP0jTRvTfJ5xEkoH3m/f4TNzVsTFbmQiM6ed+wHV6j3qGKAajbEg52c1RuiMA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6307
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_02,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030136
X-Authority-Analysis: v=2.4 cv=W981lBWk c=1 sm=1 tr=0 ts=69a7137c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEzNiBTYWx0ZWRfX74hQ3xxmnnlu
 MA9EEzTk2uRwvmsn7+XVUK3KglubMzn94qnATbc53RgmlxWPHrfN0+9/406ugYZLa2PXkD0w35V
 SnMUUmxutdit8PIdklYyKv5y/rAmHLQK5ZC+rq4Zc1fwSjOrLakVAJlLck35u3ljdX3BtZGwM6E
 u5lkLF+y7APv/i6nX/6wv14QKsVvvnvu1JywR+hNw7yIu/aSGXHcZz2Vncjat2NJfa2d3gBLtJV
 KzYOSZaeyOBvoUJ2wOm6YODf5WHLWfRCYiaqNPyNzSEV1rPG5R2bxDDcmtrUQwo+ALQ5x156rz/
 I/CPqYoXBnOJ6UVYEXlTASlAsrd/7PH50bLuMAHB+XxCQ1s/VP5HKNP+VJG7g255l3SyWvsiDj1
 hNQi5DvzxfVCJu9wQm0n6KG8LCu12Ug1BoQS+5yGJG1c51nZcA7UDq5WpsDEEyw5lzQQ6QE5FlK
 8x7vfrybN9+LFSMRVaQ==
X-Proofpoint-ORIG-GUID: 0PAnVmmNUngMV9caSweuJxeEjhFfXm82
X-Proofpoint-GUID: 0PAnVmmNUngMV9caSweuJxeEjhFfXm82



On 02/03/26 9:39 pm, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:54 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable- 
> rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

Hi Sasha,

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> Thanks,
> Sasha

