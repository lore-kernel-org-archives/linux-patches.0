Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3451938236D
	for <patches@lists.linux.dev>; Thu,  2 Apr 2026 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775126982; cv=fail; b=riViEAdBm3wiwTsAGsDwXo39thQ3zitQw5d6Aed84tKyHZQRNVu+ElxKRos8/vpIacYDJ93HzOJTWoZI3Oyzj5O/tJVD91KrvWcLjBLlxtkcSsuyYtDWmGJgAbSsMYgj0yM9XnwSbnyUCjY+vw7bq3JvzQKBvTrCc+dcRrFV/Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775126982; c=relaxed/simple;
	bh=p0vtO/m0oI9XWX6sePYyAiSm9FXf2ipLZlgZstk9tS0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sx/XK+OUEanGZ05w2FKKrTQth8waEYG2ly+WO5uqNKX61VjZXNtQDgqvqOcIUMvTY6stYDB15i7QyxcxpbkMDXyz4n0xtp5rBDk8aFjIdQ2UsIh1B+xkDVP7P6ndALZjVizVT7+AMyE7DdFK7plWjBesQ338v6tGsKXIc0mBGi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T9qzJtVy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hx5TSy7p; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T9qzJtVy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hx5TSy7p"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6329fxHh942168;
	Thu, 2 Apr 2026 10:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4cKQFnZVXO18VKMmHzP6rinO6baDg2F7zGDfNwSh4Bo=; b=
	T9qzJtVyinUMHbUEt14YhkI8dmWUnO5uapmT6zWrne5Pkcu45JxYZ687Xn/v5CtN
	LiTFe0SZaCKGltytxksihIlJQkSApguI2k3VHB3KNVbwwTdVFRoQ18dreuDFXP6Q
	lmrI4/DRR0fDYHWHBVAD6Gpm59K6RxHJy86YfHBBCnTK6LX4HO2R9BoYaYHZ7rpr
	1xcdgDO7AVGZuL77NfXTyZ+sD9FreVeIezXADLSCxvkAWuMD9ijIXIBFnUJ2CtgQ
	Gp1Bvi7kn7d/eZLj1hyyRnnCObpP5a0l4fH//6btDy6LcJeH7v2vE+j+fpyOEzjF
	EIMlB1mErGwgh6Dw4qMBuA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65jwg7um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 10:49:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6328oHX6013963;
	Thu, 2 Apr 2026 10:49:21 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ect818-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 10:49:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTtGv4avKy4OW8VpDlkhCtUuUBNy3Jwu9FSpAU/cojzTQjxWrQXyXrR9KPAhww3szKWAu3RzvGH9hyjEJrxmLeSMCEi16NabJIq1kLTXSFM6M8AokUAuTzZjt8/eucz9BE7OZF8Xka+gyv11Dtm1UU2lt6nalgzbBaM8LuievsQ64ylFBWc0ufn/29Rb1CX4//6qucDoDg8vc5Jlv0ELd3PQR6BsB+BWH97v6O0MLU3QXl9lAhzJB4MqoqQlggUaA/txi0PeJJdaQFI70TkDCi2YdVv2mocDzjkw6uMqtwBF0zwvQnqItA5n9z21l9gq9z6d8gzZ0hWy+5Bxw3wo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cKQFnZVXO18VKMmHzP6rinO6baDg2F7zGDfNwSh4Bo=;
 b=ZdWBDXoPRn2xf0SpyXlxZGI2ofSTrI878rLFQYABEIHzT0+SVnWuDeaKrQ+Lc/ZiyITXZ7ijRHvtn/Di6VFPrgeFvLm3a7VHXFPCJgmzMMNppNMPZ2zZg2Fi38XeWHfyzfr3or8qmDMndscswXkiOXgBPIl9Q8X94Z3K3v6Gyz8ckbSVVuFeRp5/FUdGyVX29KA2SRM5mT8D4tuUG3GReMlnPM8Z1lkrwMZHGUnsLQ1GoWYmhlZLCHiEseszzpeyzvw0I1YAnu1opT5qMj3Lsc2RxLbsrgBc/stjX4ZgI5j8QBjXBZ77VWymNyponM3Iydcevk/IYRXtWuSh6SiRdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cKQFnZVXO18VKMmHzP6rinO6baDg2F7zGDfNwSh4Bo=;
 b=hx5TSy7p9J0dJZATNSjvH+pn2qqRgfa8KI8AKwdscZeOqgpzb2laQ/TAiHFjZnolDKq/F1GUWsU/N1YVHj2dYai+Z0hBGhUmwhyohdW5uUxsapzVc0NrGnHlwtNGBJJB6tYFBMr3B4f+YmApihRv9oPmnfZVbG+sAIKtKZAPoy0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MN2PR10MB4398.namprd10.prod.outlook.com (2603:10b6:208:1dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Thu, 2 Apr
 2026 10:49:18 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Thu, 2 Apr 2026
 10:49:17 +0000
Message-ID: <429dca01-138a-4052-8376-08ad4b8c75b9@oracle.com>
Date: Thu, 2 Apr 2026 16:19:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260331161741.651718120@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::23) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MN2PR10MB4398:EE_
X-MS-Office365-Filtering-Correlation-Id: db2cd595-68f7-42d3-69ba-08de90a57d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	41svbR3OaTVzmVRU9YsyTIzy7R+WUxMT7vpCSjq5++T0uQ+9BoLpLLVd8yg5CcO9WVzjrOrcxnjbb4V/V3s4wK9y7hfTohMBelc9EO9EYLVx1r1JIKa0D1ABjz5Am1TBBKpvGcP81hpYLoYIFbe8W2gbxQutRzg7h01FUgrXMxrlQSPrOcfKDYzHBfHR7gzjiWb5AvVuPCJVq8JoZZwfELXk/27eRVBacxQyIE0eZmfLIlOvnFVkI6HbmVKa9CwgXsZAd+RyIX3mLckcdBEWwFDa01tFu5vY0FRKdi2PsbXrF0PMbVFa3osuY7R3I8KzEaGKVWfmQIl41ZIYpGnq4LjtiyMpOSYwk4duQAk9b6T4A1hDUYSUXIp2j7ekHieuX7c9xaTmB+ZWtWn2laDxCZoWghVYezy8jdNZsCfPtb0Q8Q557D5farQHjrynfukA458nU5WriZJSZueJe+jJnBJFhKv6LBjhE0oMjaanwOhscpdZ2OVhigBjZuWvTuUSL2ynAapjWRU+E6K8QcgYjhi79bBijBMqbOBQFI3wSCrNYbXEL0dBRen/WPoef7k/ZX0Fa/fGVMcSpbEtFKgVZ64uhNzXszsoAF9YjMQtU2cMRrpR0P0fzK09n+5tPuwiydYgbJSURThgNoo31ONLYkRlXeI1LUKXLhR4NPe0crc65xVfFu7fg/Vl2YK7JTkpmAztnAWN2TnX60FFeAF1ZJh8mXiFDVSXRS0cvDGJhZY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWkxZEU5Qm1mZU5sSUhNZHF0ZUdyNmg4cytIK0JGdWswSFBFNE9ZQVBiSjR2?=
 =?utf-8?B?S0grUEROdjByVEVmYmpMWWxid1EyUnJJeTliMU1XZWxhSUd3VTFIY09EdEwx?=
 =?utf-8?B?QjExbi9CWTFSeFRhbmNPK1cwd1A5Q1VXTVRENERqUGlYNkZ6WDhyUkpvSU9O?=
 =?utf-8?B?T1BpMVZ0dGZYT2tDT2ZXRHF6TERtRnRjeHBWYnhxcGt5ZjZNUUIxcStscXJl?=
 =?utf-8?B?dDdiM0hHQ3l6TlhaaTltR3BqeEdraSttd0pCNFFtdy9YRXpkWjBCZFp4QW0r?=
 =?utf-8?B?cjJsL1UzY3hrbThFTkFWMTA0akVOZ2JkbExOck1KblJWa2lvd0VZcHYzbW1a?=
 =?utf-8?B?ZmtmbGdQVEQwVjg2Mm5YdTVXSm5NOW0xcDJiTzVJM1F5SWlGSmRac0h5NU1W?=
 =?utf-8?B?QnJtZi9VaUhwMy8rUTJoY0drVnFEK0lUY2s3czZzS1dPSlBodWI1cktDOTUv?=
 =?utf-8?B?ejF6WWpCMWxiTFpCMmhHSEdVenExSmhLaDRtWFdWQlBCU3pSd2EzNmdtRUJx?=
 =?utf-8?B?a2tKdmFacnBtOFcvejMxWEs4azZadTU1RGFJMzhsTGYwR2xxemZXdkJrenQr?=
 =?utf-8?B?ZDlyaHpMS2JUaE9DVkt3RzNtRmU4THhzNHZmWVVBTEptTkdselAzQlpVWXU2?=
 =?utf-8?B?ZnkxYkZHZ0RBejlwampLRjNEb0JOdjVmanlGNUFMQ3NwNGUrQk5CQ1lCbU04?=
 =?utf-8?B?am9TT1IwU0ZIL3RSNHNDQ0pUNldnMkJWU0tiZDhoVnVJdkU5L0VPSWUwL1pY?=
 =?utf-8?B?eUk4U0J3Zzg0WGhXTlB2KzBzWmRDL3VjamxZQ2VCSkdzbGlIbnZiRE1iODUz?=
 =?utf-8?B?K0M5UE84c2pvRDN2a2lpTmQrUjlzMTZORmF3eUFRdUxEeS9adE16R3l1NzJw?=
 =?utf-8?B?d08xZ2hqNWNDTEFUeEpOMVlEbjhKNUpNK0k0NHJaK0VCZCtBZTZyMFowUXF3?=
 =?utf-8?B?M2xMVFZTaUV4N0ZHQUpUcW02NzdJUXhnOEk1TUFPY29jMjF3OFJpbS84T2RG?=
 =?utf-8?B?a0FpRVJCR2w5MjVVUlFaOUVUZ0toMWlZNUZPUGJNazM4RStpM1pyV29oanFQ?=
 =?utf-8?B?aHZMZFIySUxjNXJCOGdkZlJpcTVIcHVKNFhueVpxZmhveHpkc2tYaHlqV1FH?=
 =?utf-8?B?TzZCZWQzVzg5eWNqQjF6T0hUZkdudVNFVXZzZmgyeGYva0xaOGNxc0w0Q0ZT?=
 =?utf-8?B?M1pUanIxSTRDZEQvLzFwNzFVMnJNWjFYcytyTk5aSlBYYms4R0J3V0daeThG?=
 =?utf-8?B?bkNCT1RxdDRYYURscml3NG84ckh5bDlTRUV6cUNtS0s2WmhyQWZYNHlMRm1t?=
 =?utf-8?B?TjNkZ25HVjFSc2pEeWIybTc5cTVCdmhNR1Fma2M3b2xrTm1OV2ZtMURQUEZ3?=
 =?utf-8?B?WDF4QkhaVFpxYmxscXd0T080L2tZUlZxd2lQTkpMQTNob1Y3UFVRNmp3TkJh?=
 =?utf-8?B?enRjRWtERlB4VDJoK1dVQTUxREJqb3RkdkpBanRKeENGTE1Na3ROU2hWdE1L?=
 =?utf-8?B?ejlqWTFJbWwrWWZ3cE1XQ3dCWTFweUNIQnUwU2R2ak1rWmprbHRMd1VTeHJC?=
 =?utf-8?B?ZmNWNSswamt1MG84M0NBYUhxWGlqR0NxU1M5b1FQUmJzVHFiR3pzWldMUWYx?=
 =?utf-8?B?SFVJQ1FMQTQxbWxXN2psQ2x5Q1pKVncybUovMGJwOE8vbWRPWEdaTFdLdjFR?=
 =?utf-8?B?YlR2ZGtmYjRUekNEZE1tRzZnbTNtRnJ6Q09pWGZQMWx0V2pnTURCTFptNmFT?=
 =?utf-8?B?TmNKa3JvSWFjclVETWh4WHhqZUxpNzEycUtRS2RucUtWTW1ZWTFrMklQeXB4?=
 =?utf-8?B?UERiaGl5VXRIVTA2L1ZtdGtGd01NQWtjVzFZc0owbEZ5ZGN6UnZ6V1U1dUQ0?=
 =?utf-8?B?bFY2d3ZCTGg1N05oaHJRNCtKRElYQTFZT1ZsL1A4RFdTSm9ZUTRLVEQ1Tjh2?=
 =?utf-8?B?ZGR3UytkTkxwdjZUK0JJdWVKR3lFZ3dRV3FET3JsNk12Q2VxQ2pia2ZLRnEw?=
 =?utf-8?B?QllqbVdGemszY3lSQ2tWYlA2NmZORXl0ZGUzZ2U0Si8wb2JIWGJWbVRrdkpL?=
 =?utf-8?B?Tm9GVzUweFZmYVV6ODlVbDNrU0FSTUo2aHNoUVNOL0h3RXZ0bDY5UTJ2VEEy?=
 =?utf-8?B?K2pvWS9UdDBSRlAvNm5EVlhFeExOMjk5OEZva1loMTRYeWM1R1prSXZ5Vjk1?=
 =?utf-8?B?TElIelFBcSt0NFhqMzg3UUR1N2YwSXlMUXB1bW1oVG5WT2hZZ3hpL0U0NnJN?=
 =?utf-8?B?QlpOMzFwUGU3Wmc1TENYZUxlbWNNZmZtWUJEaTR4ckNrVDBmdlJEaGEyTEhO?=
 =?utf-8?B?ZE5ZUzRmekVaSG53U3hYYjVOMHhURDRxSHhmZmRLUzJlUU9BWWpMVUE4TVF5?=
 =?utf-8?Q?R4phoRIV8dtJ4PiyShW0TEGqbgnkVMdZ910Qp?=
X-Exchange-RoutingPolicyChecked:
	uvd85Vv1R0SHd7BrcHvU2lsHj9+dEqDeooxwKyUkTx0Cv7Od3+4IuagvP7aPCiWut3TOwXPg6psdKoGm+uKuSyv8mx/Jcvyqh4TAJvWilGVpvJSMOcG8Z1nPnk8593JJ3DmKbbCLD4uaHCdAZxJJhT8uLcquzTXOyWAKc7KGTKQYqPEjKU2d4mpWNLDp58RJX0XdrTzo45S1M3MTywFteHxODzt8Q/K8Zu7m/5kO2CuHrgEf0iWc4btvEnSQPptiGKzLrDCcBUjRo4Cno+wUZCPExURXqHtgHdkoR/8moYD6kOXsoUrGIvTEfCfK2+zCpiHNd9vADYyojBugirp6Zg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6UMFqFJFmDmRf1vcik4/ZpfZnin0a6gC+emHryhgn9I48jWMhP6WLTJX2PtgnjWEizEGOz8U+EybdfBeHTSIanRkly7OCOXMKiWTr+rVvPzixg282hQh3tG5WoQ96oGj/9/nkhFImtsiSudPYSTBDUayaUVfXXrQnp5C9RPCYEypH0vnfagXgoAjvAK71BFVuLg5Kkvzt45I6lPbIoewggmG6r61t5JXwnpOn+lkkrJYKQCbZZCfba9KPKTmT3kPZkUNv7MdSjKKayr/fNMrIbPobWCGtFLFrZbDUPwL8zcP1RJXiFddqV3qsXuUggVogMolwewZXDJTYlxo3taDBQYk9fSxJzYO3jqKSyC+uh9Xs96/dDzi+4MKouX/SuG+ZlegO4U4YUn4bPDsz8tpxhfKsEJ8rlSkyr55EszA9T7nvezsgBkZp7QgizrWbsoxepafLDuJXgX0KJPxQwhXsdtMp/spuiUGf80i86RMapfZIbCUlZZfLJPxM4VDe4BJwAVISBOl+JiC22E4bQjGu3K0ANh5kcCMgOqpBNVTapgUKl3epAxutK4ezUXxIJWgIdKnEqwRtf3loZG1cPsVDIbU199lihP+I/Jnq3uQ5yE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db2cd595-68f7-42d3-69ba-08de90a57d17
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 10:49:17.7944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqMjIlwZEG0NJMIoohusvzekwLSOl5bGE3/wfqBdXu/SHtuIHs86GocXDO9cw8W+AWjs9AMMKJrQcn3omaUM7KzYWVCiP60Lj9PAmPTP1nj1U7MoyyZyoU3VNYvxtXqy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604020097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDA5NyBTYWx0ZWRfX2JLdnYj1EBKL
 +HFZkl7PFBOWNbCZQUnqk0D4CwQGcW/gvxf1PJyO7m8qi4zeq41Wf0zwLqegfVLE8hI2co6gdAs
 tJj46JaqrsGEww0ljwD65xtjowvNvk+W/RvaP0iK7+6wdyqnyKOfTZvLuqz5tJMjs/kfD60woFc
 On2eGfTCShjx/xE2Ackt/oZOY0mj8Xo3nEzDRCzzw7pcJyvYclzMmMFD5Mi4bcB13fKwPAb9U7Q
 uVVu9zNVyaVBkAVFIa7cseLZYWGjjfD8QwzhwT+yqYOA5YT08mOEl9zQ3A8LcHir7AejSiV1B7e
 FPKNc4UZQjjfuJqpzM6ZoJ9gygfPVb/WqMXEzNx2rNOyQ/aMpfTw7G2raZ3mfQjG/4M9vLg3Fq1
 Hdw+GFccOZDAHP0OcirLfJFtd8xwQsO9aCy7dUwz4pE97snaLQBTnrmMv9wy50mz1G6ZgYH4ElW
 j2UcFClzgiI3gBUM18g==
X-Authority-Analysis: v=2.4 cv=CJEnnBrD c=1 sm=1 tr=0 ts=69ce49b1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=UPNCC5eNj_IfLgcwMscA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: WonEs0vXgZSnuX9DwxMYn0-hbeTkaEoK
X-Proofpoint-GUID: WonEs0vXgZSnuX9DwxMYn0-hbeTkaEoK

Hi Greg,

On 31/03/26 21:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
