Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0673A301460
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771432109; cv=fail; b=pvmJ58XZG60xxawDYIhW6v/zFcsT4fPE+7t5cna01fv2go5qQD2dTlyFf6JzcSQLx6WzRH8na7QqGZAML3ExigsjClEPOWEqANMP5FiUHYOG+6NWO5MukNfQGKo+xqrh0E5BKDwqPeRoE/9IuMJrn60X+H8aXGcKZAn51IdMxLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771432109; c=relaxed/simple;
	bh=cu9h39YwZsiTLKW6w5D3Iaflw64b8A8joKNwXL9Pf60=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rJUu/xyKQ8Yb7xf0ntwAyw8fOEJPxzlIkNT1BcxGfNmiOVv37tPgCrHPdoQJNF+0KfmeuC7eC4aKYJKxoy9ee+lrpxB+Uz3rqEx8ePVRBKfYDvFE77Qmej477g9RBVs6GG9BtWQ7QMnBGQAl7HGIjrT56iY9MUxYUH2JzyKxHcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CRc0eIuo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wsxKdKnn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CRc0eIuo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wsxKdKnn"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61I59d25250938;
	Wed, 18 Feb 2026 16:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZgP/+xoOgTSL/qRttJrAE3xm5QkrAoF3C+I6RBnW43Q=; b=
	CRc0eIuo5o/5xSammpHDSVlbKnASyGrWErKpyCpy45/SmAA9pV3fi/PEjcBIVFIb
	BQAzZNNGuY76aIhcNtQQYQx84FS7LG/venvKZHuOt0khc/xS1Vgbr1wP+296rtaD
	rMZCj8b5t+8TkJ86+LdIwSHEFv0AbRJUrNtgbaS/9DRlCA5LJ5zInHfKn39YqGHY
	temCJSwyZu+p3CGlaRYOvmORxixtLO3wENzUm/vtaSsIfo+jE3ah14qEw8UaJpk2
	qq2t6JAr5XW8RDPZPqKcuulhFQnsMHkL7bmDZNvgc8Sw/UC4lZks9344NH4qbTfZ
	folHqXK0cpr147Xfzafz9A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0wnt68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 16:28:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61IG3vUi014991;
	Wed, 18 Feb 2026 16:28:14 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb23h9ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 16:28:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDirt5W7JFkIQNrbfF7oP8/wC1bEIpkyLH0QVOLJ+Lk9RTtXtsSY+RXjz+oe2d8Ih/8mXn+nr5shj/SBaGiIYDK9qpuisKQBdMozxVpQUaNWmg53Lryw8zxbe+XYgcBvxdwjSXxwMIpdqtOaEHcrvyFyOkWtCHWu5k6tMpD4YcUwKtLAAFSot1UwE9EJnfmrqfiOLMNh/CLZP/criF+MpJDDTI+AmxRjyq6wWfdikOy0FIDdDjeAf4Zuk9NsKd/LL2OnXa/biIOEfutW6CqgQFlqOqWibH9aM5gOLj+pg6cgQeZGqrceT+RkTnWFXP7HHyAqFc4LQRRcA3GXtmjt8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgP/+xoOgTSL/qRttJrAE3xm5QkrAoF3C+I6RBnW43Q=;
 b=WLlBuRdU/zg/qdeE0sjUMraiiTNKCTFaaojFGaykns4w2aCymjbt0mbN5OUNkQiv4DdCQXMQxutEtqXpvjjB8osIEFh2T3UQssB/OLr2T+rWFkMsHNOxHOaERaVbBdHyy8WYUeQMtX2xL/Df6FaRh6IWiWhDDC6J5dZ3XQ/9ClZJ7aOmByFgUnLg4qOLslNpRL2Yz30Eu9KzuaBi/8qXOijUj6sonx7WME1KVtBlcUzLGFlFT/UrmvA7JGGqlVy15wF7QsKylJWpAgpd/0+Qay2PEALTl227FhsQtUT70LZ/c4N3nEkBK5lMPr8IVaPEQ+5W08onlWFTD9h9wJdLJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgP/+xoOgTSL/qRttJrAE3xm5QkrAoF3C+I6RBnW43Q=;
 b=wsxKdKnnptTVTxx/OU0uLWw24Gg27ckCJXnw2z4tD3T0EqH7UtFrVT+pzbZE2jB5NDAuNzshN83wKHoYuCteYp3KQbLfrQZlAsFR/6xi+MpwNvsAZ721pyccgPyr9q/EiUzOGu8mPJJurrZMDLhe1nqAYZnYLGFxtC1EU9NzM/g=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by DS4PPFA0AD88203.namprd10.prod.outlook.com (2603:10b6:f:fc00::d3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Wed, 18 Feb
 2026 16:27:56 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::9f4:ff68:a479:7cef%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 16:27:56 +0000
Message-ID: <1722d8ab-32b0-48c7-a810-dd93216b2ce6@oracle.com>
Date: Wed, 18 Feb 2026 21:57:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/39] 5.15.201-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260217200002.929083107@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0206.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::10) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|DS4PPFA0AD88203:EE_
X-MS-Office365-Filtering-Correlation-Id: 283e0756-8cc7-4963-59ce-08de6f0aabe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWxTNmxCN005N0JsQjU5U0NuRFJjaWY5SWNad0Z1QmJOMGVyczJkMlMwMGh6?=
 =?utf-8?B?a0dhczdtK0VZU2NGVzZERWlwbVlTSE50UzlHUFozazdFZDhtOGhIZ2cxeXYv?=
 =?utf-8?B?dFlMY2JxQkI2SHVuUnVQajMxWmgxVW44MW8xNlp5OUxzdXNFSEJrcVQwb2xt?=
 =?utf-8?B?SHdXRTc0SXM1TlFjK2xtaGxKY0JIUDVkNlhPUlBpbEwvbENJbGdzelhST3pu?=
 =?utf-8?B?K1ZnanppTXZGc3R4Yk5odmI5R0REeng2bi9aaDRYOHMzcEpwRWp6NFF6QVQ0?=
 =?utf-8?B?U29MdEd3NjZlRytNcTJHS0hRbkd6aEZKVVBmK3dSOG8vb2tYQ0hNelorMDRn?=
 =?utf-8?B?NjZwUkNkTk9abFpzMlZZeDdoQzM3djE3N2tsdTNkUHozTW9FSnJyQ3N3OW1i?=
 =?utf-8?B?a09RbmtDWmtnZWlWNkRObWFKZWt4VFJtSDMrWDh5SmdDWS8zWER2Y0V0MEpV?=
 =?utf-8?B?RXEvN24yeVRuTFhZdWZiUzBmUzdKc1FVNVR2Ykcza2lxeW5WMHl3djVxUTl6?=
 =?utf-8?B?UzhGbXlmR01FVmRRdFp1dTBDK1lsZWllNGtxTGZtMUhvVDZNMG1na3VvQ25J?=
 =?utf-8?B?SE5ISlFYU1NXWGo1QnB3YldzalFYdzZuWGJNMmZocXhoUlEyaTRhVjBqY3FN?=
 =?utf-8?B?MEZOQ2ZvZHJMZkY2My92bDJoUnRHOW55TU5hYTRJMTZyVkN3Nkt0TEh1MXNE?=
 =?utf-8?B?MnE5dUVaekVCR2NTVGREbDhKb2g5ejZxcVdIbzV5Z2d0cmp0TllVU2dMakpC?=
 =?utf-8?B?dWpldndkRFBEQ244amc3bytjYnUzYWtrRzVIeFhZYTFFRHNyTmVaUm83N0hn?=
 =?utf-8?B?OHhZYXRSTFVOSCtaTzRPQ1A2VjZwUm9ZUVAwakJhWk9jMFFjNEZoRlBQZWM4?=
 =?utf-8?B?cm1ZV1owV2FWWG9SUnB3YVJRaFgwQWoxalIzWk1iSnc2UUxGcitEYStJSnI0?=
 =?utf-8?B?cW1sclFFeGNRcGw0NzhuMnA4SEFvYWxPckh6SzBEZVFZam1ReWhoMEYyUXox?=
 =?utf-8?B?UFd1THNpbEI2TmE2eFljNTVkWjkwQThmOFhDZ29paDU3cVY2TmVDcFhwVlpv?=
 =?utf-8?B?VHpDYVVBN3ZJMVkrMldsN2RhMjV3Ti95OEZ2M3BmSVRIYjBrSWQ5OEtDbGlX?=
 =?utf-8?B?MDU1M0EyRXNuZEFDNVJyRjlmbUpmM1lkMVV3cllHYmhlOVdGRmViUWsrbTlH?=
 =?utf-8?B?UFBpa2VVcUtteThqU2ozNC9NNkZpZEVUUXUxYmNpSEVyNUhrUStVSk9haWk2?=
 =?utf-8?B?VWx0YytLTXA3SHNaVHc0L2RYSXN0M0JERHhvL21vUE9sTVh6ZmNlU2lCdnR5?=
 =?utf-8?B?YXNvWGxXY2ZvS3BncVBpS2NOM0kzVS9HdkR6UEdxQzdIUTJINWFTZWdUQXgz?=
 =?utf-8?B?SEdVZmVJQ3lzZ1lMcXhIZGlHVTlaRzd5ZjVwT2lHaWg3NnEvSnk1cUJFYmhO?=
 =?utf-8?B?RUdDcFNhdGZ3Z2hIR3BHdjdHbFdZNjdLWEh3YVd1YjZSZ2FCYm5JVXNxNlVk?=
 =?utf-8?B?WlRSMDIvbTJzOXRlYm43NVNLekNUdWRNMFdoSnZ3ZG5SL25wRWRVT0VsUnM5?=
 =?utf-8?B?dVFPa25uZWdHcFdiZCthSUs2VzlEQy9WckNmcGgrQUtpeUxldXhYK05QbmpY?=
 =?utf-8?B?a3oxeFVVd1pFUndNWnEzbGEyUXAvTWh0SnJPUjVUbmlFUENNYUxkZVNVQVJt?=
 =?utf-8?B?b0Z4RkcyR3FvMHhiNGFzRGhrc3dpU3ZzTjlNd2RtajJkUWo5dnpXTjFCeHNm?=
 =?utf-8?B?ZitwZy9SU2VjMzFFMnArWEExUXBMYWFubU9rV1R1Ukg3SnEvbFZZT2prTXZX?=
 =?utf-8?B?U3h3dXZRV2x6VEFTa3BpYnJQM3BGeHNncEVtNTMzY0djRzY0dUdoMm5udFVF?=
 =?utf-8?B?Vy9uVGVGT2VEZnVMRHpmM2creEx5azlQaWxxVVo0T0xWN1lRWTR1aHBKUVlz?=
 =?utf-8?B?MW51K21CN0FGaFFSVjh5T29Xd0tSQW5lckJlRHhQWTRBZE9NWmZ4ZzgxZUlq?=
 =?utf-8?B?WS9NZnlvOCs2cGlXbXE4UEV6SDlRblQ0Q21aa2lkWUsxTjdjS3gzMlFhT0kz?=
 =?utf-8?B?RGNMaXVTcTZNQ2h2U0xlb2w2bjRyVnVRYkhwMWhxV2JDaDhGRmdOSmJ0ZXZP?=
 =?utf-8?Q?HLs8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG1VcktMeUlVY0lYWFQyTGdPZEVQMCt5YWpzSWRVTUx1ZWdDNjlSelVQNnpN?=
 =?utf-8?B?MVlFblVJLzA1c2FlRkd3L3dsNGJJeEwxakxDRnFjUXAvcHZEUlg0TzF2MDJ1?=
 =?utf-8?B?UFF2NDRyOEZ0Z3NrU1A5eG9wRFMzZ1ZncC9yV0NUL25xNlIzRUxjWFRwSUMw?=
 =?utf-8?B?TGFWa1dVTTBSeUtkUzNCR3REblMzTEZtNzFXUUhpSmxKcHQ1U01vaE8vMWx0?=
 =?utf-8?B?bU0yL2N2RzJJOURlRFVVNVRIV2N4WGh5T0tIRWRnSGNBTWdkQmYvaVNwZXRt?=
 =?utf-8?B?STBtNm4rYkdvTU9VQWd5SCt2b2cvUklmZ0RpanI5SGt4ZEduY0pmUHBhdWVK?=
 =?utf-8?B?d0NWL2VWdWU4NHpmUjZCRmZET0FQQ043d0swZ0YzOURYaGNYejhpZ2dLaE5n?=
 =?utf-8?B?WkxWVE5peWdSQkg1R0s2c01veTllbkF4NUlLbU53N1ZWUjRaWG44OGx6UU5j?=
 =?utf-8?B?eHRMUnVRNWw1U1ZtczFpM0lDMWErNVg3Rmt3N0NNQkxUdmI2NDFqR09TVXBB?=
 =?utf-8?B?aVltcDBqdE1QTmNTcHg1Wk1RdjZ1Q1pMK3JITjdtMmQ5RVlQdksvR1VFdjZF?=
 =?utf-8?B?VHFJMld3OHlJSjZPUjhQa0hKVFgrdk05ZzBmT0FBdWNjQmlja1B1blg4VFAw?=
 =?utf-8?B?NmhpUjAwV05lRG5lUnRSSTd2NWFycmFZVlc5czJzb0lpVUZXVUlZUUFDN3JJ?=
 =?utf-8?B?QW9GVmU2dERiblVubjNuRmtxWU03VW9jd3NQRGxXWUEwMFNmaU8wTUhZV2VW?=
 =?utf-8?B?VWp6QlJNNCsxMEN6RGZIeWRLdndBOUJDWnpGcVkyMjIyanY3TFYxL29lN0Z1?=
 =?utf-8?B?TkpVcHd5Qnd4aldMZi8vVVRhM0xGeDRiRC9HWFNxSTI2SEFUeFdLbWl5KzJX?=
 =?utf-8?B?ZW5OZmdxQTI3T1ZkbzRzTkxJYlFacFFqRjZrYnNpYXJyYncxRzRQOG50Nkhr?=
 =?utf-8?B?cVdQZXNkeC9pVTJoaU05OGRTRDRmUlBWbExnY20reGdqRm1saGwycno3RW9s?=
 =?utf-8?B?UG5vNVpKQkRXVWt1ZWhqUGZ1MGl0U24vS3RubmRPeFNVZ1BzdjVPSHFzWnBS?=
 =?utf-8?B?RDBaZ2NXK0FMYVdOang5aEZsQmgxdEdVbDdpUnVtZVArYlJCbzhqVHlZMTY4?=
 =?utf-8?B?ZFdCS3EvZWZ0K2JaZTJOTGg1TzlVQkJKYVJxcHVERjN0S0VubFp6MWtJdGVq?=
 =?utf-8?B?ck9aNnNWVTNQaVQveis2aGFZZ0llaWRITnplZVNSNXgxb25rMlFsdTlnSTRa?=
 =?utf-8?B?SmRNRGwzK1VUaWN4Ry9rRTJubHZMRDRkZ2ozL2ppb0lIZmMydndLQlhYR3VQ?=
 =?utf-8?B?bUwwZVp1cVNNUlh5dGZqa2wyVEJKMGtybTBscVU0c0xtdFQ4YytNcFVqbGY3?=
 =?utf-8?B?V0l5RUZuM09WN2crU0s5dFRIaCtyQzlDN2IrNmpPbExyUVNWaS9jR3NCZUlh?=
 =?utf-8?B?ODBySThUZU5TNjdwOFJoNUs2Q0dxZFBiQ1pLR2p4eHJwUUNBMTluU0V1Y2tl?=
 =?utf-8?B?cExmS28vQkJRanBsWVl5bUk2bmRyQVd0WHgrbysxUzRQRWo5WVArZFpCOGVw?=
 =?utf-8?B?eFVTNndnek9iVHYzOC96RFA5a3A0Ky9vc1IxRnpLMy8wU2lxTTQrZ1NDVFAy?=
 =?utf-8?B?Q0lGT2Z3Vm5tajNQK3BwcVE3QlJ4TEtHeXd6THRxbFp2aEpQY2djT3JOMEFM?=
 =?utf-8?B?eWJmT0NqUE8wY3VZbEFBdnE5cG4rUVNPQ08wZjJpb3JwV1ZXUjc0ajZwMmYx?=
 =?utf-8?B?L25iK0dLUnVPeWhGUldyU1J3RExubFlKaWVmRzhOWHI1UjNEVTRET2tLWVJp?=
 =?utf-8?B?cHBNQlV0WlNFY0dBU0J2cUxHNlJmRGw1cWJQWk1qNE1BWlhmd1lKTm5rYi9K?=
 =?utf-8?B?VEZtZXUvN21YSWFXT1ZabXZpWU0rWVYvVUlHRjNJRnJ0VmJGZWJudWs3eEpO?=
 =?utf-8?B?R0duajRXYXFmYjlSa2kzczRMM083d05YaG9yVVpqNXN6VVg4Z0hSS3JCOEdW?=
 =?utf-8?B?ek02RTlNejRJaXNxbXJLTWpwaEpid3FNWEN3MDZsUE8yODVEMWJKWVVsbDJy?=
 =?utf-8?B?VEdzYnB3WWhZUzVwaWt3ZEEzVU5DbWFxNXhobllTazh5TmVraXhDcEZDRnR2?=
 =?utf-8?B?Y3ZrYkZhTHJGRW5aRFBlQ3U3dTJnTlVtZS9yekg0VDQxRWw2TkpjZ0RGR2xC?=
 =?utf-8?B?TUNRUUtHT2tMY2YrSjYxeVFBbnJROE5kS29VaXFwc1I5ekhEelZNbjNCNi9o?=
 =?utf-8?B?Y3R2aDhBU2hMcnNLSXhnbE1OdTFYMkRqWkp4cUw5bzg2MmhudjJnWk56TVls?=
 =?utf-8?B?UzRTNFl4SWdYMllud20rMzM2c3FGcHozRGdWdE5tRUluckhpWURGQm9CTVR0?=
 =?utf-8?Q?ZjQ5b//vatBmc1ms=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	clrBTu+CvQQDxYsvuIlECr/jVyWefnj6rL+yXC8iFnUsRyFNEPTfSDpAue0KaHiLt3OFOpbnR+ycQYvhQstsW33xE2hKhM+pmT3txj9OzPz0oqYhzYaQLpJzvrZBjJMewuHzVW2cX2IDpVBdguJXek908EA41v5YReQHCHQJq9O24+Uvt+t7D/o9wrCZwA+GSYz0hrYVF6WhfdLXfxCTVC4dxQpH7ELV8NnjyrpwYl3iD93XqKHcyYDldJP/KLLafzBlzWEpcau8ZkikbkX5mvV5VvicScRdUk/Uly39Su8QTsCbZZKdDTBuQzC4iHvVWoD4X9/Y03fzReQ+zDjxN9nceL0/tAK66uWDNI8oPzjpT2WKk1lYfAALn04gEbc9qSs5p8l3Tx3p6fkMcR1mLnuW5B+rfXvSxXsfKov6TO/FiTRg9fD7MTeSbinEYENrYA8DeYOogya6Ej8v4lHTzKwJB8UYzgYqysTB1uUbxBMkBQRobwIsChiPFrIKqJSzawnT0xXLTXXn/OXEO3ttsCoPRZzmwf1anar9APtTXdf45YIrStiS1v1Bj9wDHVy3BaVDav0rV89EzezPnWbgHNGovYHy81/zsJpObTIYrX8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283e0756-8cc7-4963-59ce-08de6f0aabe7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 16:27:56.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f59BLda5HkwXXyOBv4+2cZegthHIKeeKaiGMkVGhPZGIcHs5UIu3n8xCvIluAqA/sp3nYxdeWMkkrNFe10kCB80LmHQCdYBweTMHyMhbATI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA0AD88203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_03,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602180140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDE0MCBTYWx0ZWRfX0jmqNX9GxL9Z
 crTbwEOUFebQYOoDdktcfzB14TXJains0owAOUNzJWkXCD4XxoRzTb857y0qKxwI/UcsYkmctwQ
 vSIICyMT405yZPU9KCJWjYHcwI4+HBWRJzdMoX14QRodujTsBSz45zt+AvO1frn1FrDYde2IWOu
 PoErIL6WA7zBHMP6UTo/0Bsx1Q3Whs7R4YT1qbgUYQiLwT0lKFH7IdMCjS0hQtebGlxPyc6z/CG
 BmuBXLuUzT6M7VTdT3kmHLjPgdwFbPJY4Pela8/5DLe5v8GlHSz87b/kgvOEWYburB9Tad8rijg
 gtpdc2AEOr7BzLgTlwe9nhdIi3ucdUZdxVHNFq4D1QVoRLGP37yfJrPEktHHE0uSxeRJ0YlmIOE
 uqEywDDyKc2hAPdSR7aqvGfb3wL0Xp+nOviQtQG2uJ/BENe626OS9UDakvJDAFGGBuXniz6AWni
 p1srbd37GDUZ32h4rJA==
X-Authority-Analysis: v=2.4 cv=ZMfaWH7b c=1 sm=1 tr=0 ts=6995e89f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=x6Ducos6UYMGwXt6jLcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0-TSfVxmUCoCdwA2FDST47N3Yr-SBx5c
X-Proofpoint-GUID: 0-TSfVxmUCoCdwA2FDST47N3Yr-SBx5c



On 18/02/26 2:01 am, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.201 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

Hi Greg,

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

thanks,
Vijay
