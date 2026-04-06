Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E933BBB9;
	Mon,  6 Apr 2026 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775491160; cv=fail; b=BkbRjVeoBtTUCTH93yMOuZ3C/1NZw8kLEXWq8WjwBiv750gym2DKByQxgLlhj9m57WGiftr6F6/Z1KGHXH/REwr4M85Raw/d4s4p9ilOnDbcjj0xWnRQj+11VIgMlts6RH4OMcjBguk3hQfjoH22e+sMefFYyATBPoxYCycEoew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775491160; c=relaxed/simple;
	bh=4R7op7AxvkE0CaaDfqAUsv1wQlRDkDNKY+XnFHmaVNM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oJ24tI7EzdpNn8fThYm1bC+dQ4qxLJ4N/oMQkstEBgcn7baZfGjpwF2KZQSupHxqhbB9IkZwzeSzpIcrOIuNt8D/iOiRMGh6ggrP02mYo0Pjym2kkTMT/jGyQYi+TH4Fvd0gXf1KFQR45MZf1UXmWPD5gEE3m5M3V1lpNhLk0TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AAF9Db6k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ner3QT6a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AAF9Db6k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ner3QT6a"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 636CgBVE4131118;
	Mon, 6 Apr 2026 15:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+FSmr95HRin4NGNZn1VKPv7k5puZYCltdeKBk5Y4vzY=; b=
	AAF9Db6kpG2xJpzPFloObdp6jHTTulfg32e2g9US6u5YvZcN69AiG77h2dXWVUNB
	5xDHHP+Z88Whwhl3/BxfD5KGjbC6M0c1tgmNfOOQy06eUFWt0WeMbK/srb0eoTsi
	/3UAVFUXs+8Noz3zUWdg2sVdFJ/yg0NCbA1cYc10y4QDuOAFPKVmRb3lE+/5XqNb
	+QPnPXLJs4M78ozNJ5RwlxcWV47l4N+oAUe4cMQ0N4jrzSeJQa8QwH3+FlvJy+t3
	0EhB51MI4Nmr85wIx5TxFvWgT5JMB0+0JztuMFhhzfiLCgrAxMNfJOO/XVG8Cj1Y
	9pkXtoyIqQgnZoIJTIhLvA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dase131rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Apr 2026 15:59:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 636EhGtX002162;
	Mon, 6 Apr 2026 15:59:09 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010049.outbound.protection.outlook.com [52.101.61.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4das3865w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Apr 2026 15:59:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lq6ydOF1h1CNhcNjGQ5cj1Ks4BL/pj14hKedYZ7x742z7Qv0VSRaqgY1SMUBmRtSePTKF+lbcljx2hXsXfq1oF0p21go+tjjrbtbwN1q7/ZpEtRtWmVl569QYCOrsFm2prf2CtjxDme1r9HUh+NTrO1awUYENIuIpvMs7zVB0yzf2OV9Dlc+m5AW6rjNku3Ebi7wqbf25bEWaE+3Gta4ZVmB0/yxqQB2cJM6iJmQtEs4MH0De9JSY2CF2z1BV4Bgb8bs+RdhvCz7PQ2H1/OwIYbxOx1CN/kDbWmIJGyVrj0OHlKTPZ9efmLEMzAitrj+HeUiUt48YTgRzuv3QJJY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FSmr95HRin4NGNZn1VKPv7k5puZYCltdeKBk5Y4vzY=;
 b=kTE1TW9e4RANLZh6UARGQYxFrnzdUBQ9McHJlcvkncIe/DbOMst0cjkh0DNUTwPJ+yICiqagP9j1kAnRMCR2xD+jruHoCZEQbyX3khXVJ8jHw1ASHGXaGHO8Erx0yVCRNaejeq4Mj9Xq2mXd76628fI2uzs6iWQByN2ZZ7DFu+qmTo52SjQQTxZ8ghiLkgCWNmNLjyQQqDODDTo8hJTdn7Yo6gfrKSWrqy/E94cusO8ODelcB7AT4WYLWCMVsDygSZxQW3fQxv2md4cBRBspzdhxykpS5h4kB3CUcO8WLXyWetluIvTuxomgB5pinuptxdPK3ru15PUY2OtsSkZjgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FSmr95HRin4NGNZn1VKPv7k5puZYCltdeKBk5Y4vzY=;
 b=Ner3QT6arT1CHM1tNNpDCRON9FcEXNhmxnCTdlZUzhQ+3Su96dJ6ckWyLdIhZ8o/jpzO0ChGmCN12pwmDuh9Z0/aFsa/xwPnzk8QKsFCsk+0GCqkD8kuIaZvdsnOGEiVOsBQh/Z67JSenVdovN7wWhal+J8h7JQx8BqwE7fNisU=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Mon, 6 Apr
 2026 15:59:00 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Mon, 6 Apr 2026
 15:59:00 +0000
Message-ID: <f1c33cef-b20e-42f2-be2b-7c435796e2de@oracle.com>
Date: Mon, 6 Apr 2026 21:28:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 044/265] PCI: dw-rockchip: Dont wait for link since
 we can detect Link Up
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, Niklas Cassel <cassel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201019.793655649@linuxfoundation.org>
 <ffb3f43f-ffd0-4e60-9966-a77e8ed611cf@oracle.com> <adPUtsthYnKHekY3@laps>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <adPUtsthYnKHekY3@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::27) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f7fe771-9cb8-4e5b-9d2d-08de93f56b18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YHgxfEUWXsk7gQ2oYOoySSfBfLFxIb1C3lPmgl7JjarwLV+2vU5eYMpWWtViE9z2/w4Jvy3/sYcz+7RNgh+mYDB+RaEKly2VgXc7rr3hU5t5sgmqZrnd6iWYKsbzdRSzYBQ7zISHokWRPRX4Ejsl3Q1uYsA7tfhGqGpUSlG8r5O7tgn/QU52yTWmbYOhF0wElGnL52Bij6VCxxiQnjK+tdbIBPupZlR9DIUh3lFUz9s/qno+By1ensPzD0dDfJqkDsLGoJlbvQ+Oi27cT1AOZVZXzgyluSnPJIOuk+PbpzOSo67gcOxALsFYLdmAU9hSrT5SfloG/tFKsnTivh2QfIm8D/3NnhKO5tXRGlXpm5sYGNQ1/dival7Em+6RuYASxz1GsruTbKekQFhrKjToKWZz1QKjLkHukuWjEI6gC5NqOJW7LJX2JaM0ah4QNQFzi9NU64xA4Nfuf9ehkRH2ad+Sk8hvN4ytSp4AYtOpN8wuewx4sC/jjh2HTlDmN9m+OiLaZ3exk2KH/Oyw1JxGOTnLZHWlp1o9VH48PFi52HQVXRizkklW+jZCr+dZreWWAMk1/9C6pZJCWBQrX4ogPOCaX4Az6XhkM6VWnSCz8B9V6BFhXPBWwZ8RlVKpp4YSOGWBO4hDqPVtT0zxgC2LA9dCeQm3nDmceoXT6J/gznrZjoiNJ75q8bEXFFd7KxrRCiG72ZhB/IVI8PZ03SV7djem9sj8yx1ERDjbZX9QxMA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUlOc2hNRUo2bXorTDJwbHV4cHpxd1NFc25xbDFTTnVyYTNLcm81N0dUaWZJ?=
 =?utf-8?B?alFjVmVlN1llL1BZekJSb0IrRlBvYW1JK2wyU01NOXhVVjg3WjJ4UWxZcTZM?=
 =?utf-8?B?cXBaU0FML1pNeS8yY3NBV1NkK1doaElDQXpMR0FKWVhZK2dqcWlIVHFScTlH?=
 =?utf-8?B?dmtBT3RYQ2o1NHpFeWZkQXBkN3k0NUwybHZOZG1JSFV5NnNRSjFZVHdMbnA3?=
 =?utf-8?B?WEltY3grYTBGSjV0eUdZUG5SejJweThObGRsWG1tMnBiWjN1TGRZUERoZjBZ?=
 =?utf-8?B?Z2ZHRTFVTU1PZGNrcVJ0TUtoSmprRTlaK1ZZZlY0QVgxTVVrek13QS9qeUtx?=
 =?utf-8?B?akZLYU5zZlQvTEc1djVrSzZSdmUxMmp1aHJsR0VEeWhic0NncS9XWUVSOXpx?=
 =?utf-8?B?RjlPRndXS0JMdHU3ZWNpV3FNSkJmZ3A5ZHFRckZQUXptQUVHOEsycEhPOWpj?=
 =?utf-8?B?OTU1QjFUeGJaRmwwZlpXR05Td0QrZDR6K2gxcnRpUXl1SmJ6ZFNHM1lJMWQ4?=
 =?utf-8?B?TUNZYXlreFBVYWw5Umw3SGJxeCttT1BERWVDbVBPVnI3dlhuNnhlS0lVOXlh?=
 =?utf-8?B?TlB5aEtJdTljcmYzYkoyb3JwSG5KNTgyTVJqOUpRbXpIR2JXZGd0a3lzOGtH?=
 =?utf-8?B?ZjhGUXVYcUp3QldOVGpsc3VuTUZFeUFOdzBqL1ZaVk5TT05IK0kzVExtS1FT?=
 =?utf-8?B?Q1Q3T1hJV3VCcjNFUmdHSXAyTkRBK1hVVUEybHhkaXI2T0FrV3JGRVhQUWo1?=
 =?utf-8?B?R2I3SkFSVExCYk1MamFxaXYxcHgyS3BBZ29VUWlJVndsTDBLdWVBdDdFOWR4?=
 =?utf-8?B?SENWSk43Vno5eWY0Wm41cjlFRENaVzR0aU1YZmdtZmZZeFFnc3paN1RuMUlH?=
 =?utf-8?B?SG1DQ1ozUjZ1RFVIWWRFUXBRL2NERkJ3VUVlN0xRcEVEQVd4SWl6emV0STJh?=
 =?utf-8?B?Q3lTWUQ1MjRqSElySXlIY01rV3NYM0U0eVgrYW8wbVBsSGtqR0JaMGxSTnN5?=
 =?utf-8?B?WG1KSml3N0lvNmJCazJBLzVES3JXSnBaRHRsWVhFYnJ3NE9wY0dMVVd5RFhB?=
 =?utf-8?B?Q1BYTlZZM2wrM3FlL254MjRMSncwRzJUaE5zakhGZFlkQlRodTlGL1Z4aVhs?=
 =?utf-8?B?aCtYQVFvK0plcm5OWHp6M1ZISXZlR0RxNi9qQ29iZFRQSFl0anp5TnR0TlF1?=
 =?utf-8?B?cXRxdWRibW9EYU83UU5rU05QemtoblBPZWpvdFdad09CYXczL1BMNVdkRHBv?=
 =?utf-8?B?TTBjM0tmZ3VlSWFUbTd2dVZodzRkSWZuUVZjcE1JWlo3d2o2SEVaVFpVZkJE?=
 =?utf-8?B?UHR5Q29LSXAxNWx4SU83dzdjcXVGVSsyM3pQTlpZWVdEZTNtbGJjblBMdE1V?=
 =?utf-8?B?eVZGU3E4S1FndXNCYkp3MEFvS2JITlZBR0h5dC9ISXB4SHdqVXlhMUk3c0Jq?=
 =?utf-8?B?ZFI3V2pxNkVqT003bm5rQUNWbit6VVRVSFpQTTE0ZGZOT3FUT3Q3ZEU3Mmdj?=
 =?utf-8?B?WVZOdnBUaGtsZE9vejRYVmN2OWE2TVFnS0tSREJxNE9Ha3F6NFc4UEhJb254?=
 =?utf-8?B?NE14ZjlBb2tFYmdibW5kbFd6Qnk2aHY0RElZbnpCVWJjUVZSVDk4eGZaSmRD?=
 =?utf-8?B?bmk1UU5vV2pERW40V2FtNzh6M003RkM2M1JFWVF0dW1IUXRteTJKZWR4NGo5?=
 =?utf-8?B?K2xEVWZEU3FNdUdvZjVJMlN1TG0zakF1aTE5RU4vYitkUWI5NThHME1GMzFD?=
 =?utf-8?B?MVh1MzM1N0xnTjRHWHY4ZENjdEV5SEkyMGwwc2oxbFU4Q0R0L0FZY1lrdWZL?=
 =?utf-8?B?MjBSSjJhOFZHWGkrVHNGQWdWMmdUbW9pUVdmSXlHSWZqaGphamEzMTlodjRI?=
 =?utf-8?B?WUxKTGdpSFhwVmxUMkJPc1d3QkdnU2tFNk1nRitkQ0xKVFNpSkZtV24zODBD?=
 =?utf-8?B?MjRSWVZZN3BqU2VENjJNUlFEMjJPdnNDeU9wdXNHeVJzWlNsaUYzd3cyUHNK?=
 =?utf-8?B?SU5pL1BxVnFYdjV5SHFYYmhsaVFORU02a0h5bS9FT0pyQWYvcjhLWktFRmpk?=
 =?utf-8?B?OWE3aGpyKzNtRFlvMGtNbCtjUHFrTkJJM3p6clpBRjdMOWxDU21FbVZvSWF4?=
 =?utf-8?B?L2N6Q0FXVHVpRnk5Z0tuYlJub2JkN2FvWWM5T2RyYmJLT0tidlBrZjJCblZo?=
 =?utf-8?B?WDBXWXJBcmdiVnBTeEViZUw1YVFLRHFzZ1B4cGZuNndQOFpWRlVFanRrMytY?=
 =?utf-8?B?bGZQLzdrbnpncWRKQ2kySzNTd2w5eVNYL3pPQWtMd0FBSU1DUFR3MXduaGYy?=
 =?utf-8?B?Q2JxV1N2a285ZE15ZVRtRTlvWWVmSTVKRWRraDg5eEI4WEc2eHBCejN4RklR?=
 =?utf-8?Q?65yEcuc4rUqhkE5ILqBuuBVkiLj7MBi8/A844?=
X-Exchange-RoutingPolicyChecked:
	U7CVniLTlPFSl5eU/14lEZo/24GejaZcEsReNpapUpjdF1QTsclJhakR+AXwoDeA2YbajE7bWSJDherGvDCLnsIpPpwkXMqthBqqOjWcWNkW2KVJ1Go30lM6YZwn7pJ7PNbXkpCoFohp+yyuCQixLAMrf14KiyDv4zbfOuNClo6ZkB0J/+rGLVFJ5UrjIdj8Y9fz/AOD58zxrx+xwarzeyZPo9+mpfB3SseBHQyHjW89/QbOC26l1WXld4YLK3Y9sZhtx5BJNmMFbXoEWalLBLSth+9zJOfIyZuRkIm/UHHMXEO0nwNoC3y/5lHPGxBM0zis4awc0UgInzySMHPyzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UDncifD66ZmizWrqCdxqhJzwvumMi0a+qrMXwWCLG9IODqxALKSqR9i5QvDtTIKCtTR3xyX4uBGghjBpADJNNcaB2Yr/2Z6Z8IDqbUqsEbzwIyql5FV43zqlgcCc2L9o23nmXlJDF3FqXjnVWKVfcBBUOxhTndzz/PIC1J+TxmV+0j0Hms/zZvypQIhmLX0D1vH/SxmhKJ/2lVFo9Oc4Y8Y7BoZOLpy8aYD/hp5exE/QyHlevAb9j97kawnmobjnrcJ8DTzsMO4mX+UBbWj5oaKhfUXROqUqlSlGy2WO4yGPVlN1v6hF7fjtiknZEPTn/SXAwf3H9tOPfPY1sBYd3T7KQCS91UYUQBIe1BgQsEG2gRP62A3id9B66LHl8nn8Z2bA+kLdNSIAvCHMpJmCFCpoqj9ub//07Rg3um71OJJ1KPnYKVW4T9lN6IPsBfoYvr5pxozZ/EiLLEgE01q8iqt1ozXj1uOVbh1fcKb1vkqRSNt08MMEZQ9DxRGuSqVS/SHHfHr9MZNljzwKAfNUfg2ofVklN2zYIHfo3cE55zkL0WedomrnnJXenwgyF5rcPlyClJeIC+xWm8QytLCBX+ShlvKoaqGF4UN+ekn3EMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7fe771-9cb8-4e5b-9d2d-08de93f56b18
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 15:59:00.7279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSSRk6bJP9nAh8vv5D/akr/RL9NGfOinewxhabaLMog+urrPwV+gToD8q42Dkkbica/zn5tAbBQzHrsULcuWCSYBS7Bk5DYnBfyXfBlC8cH0Nj28V43KznWgYYjgvjv5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_03,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=815 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604060157
X-Authority-Analysis: v=2.4 cv=d4r4CBjE c=1 sm=1 tr=0 ts=69d3d84e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=8Rfz5VzYHl_3Z-EQ8jMA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDE1NyBTYWx0ZWRfX/KSBU19iSE6V
 hz+/r9uGNKmJyIkCVzzU9o3IF2Fwkog3oGZU6L9JW+/dhYAYOZsoFu6P1l2VPSW5zNSyBoWD3at
 uTLx7dgV3guUFaNe+Id42noJb7wbBnt8XkzhNxXlp9jPw1BMjomN57MT/rXWr4FGaeg9FdTidyM
 EHHzHhemMHkvD9kT0a2l4ENu/E+VGjhtuMgQVdGdpo+8aHsilraYeqr55vjtG9cchwgcSO68GIF
 XxIA3DXVDBv0j0OHj0EEKb2DdR2WGDbDCsfcnXg9NGFZbC1xYp3rDKXwKHAF4nTJEvYFfke2sCa
 rz/6vL76ngNbteGZg3L3BnV5xjBrV2eVE/GmhCfBh+rQtGaX9nCIjRKjF9IHFgTC5BsEZryma/p
 bx/fRrKYcUCpOjBCs9NJWrDVPeY0YaemQ29krvnCv0JcpHO8JDYiQ94CIY23BcmmGHipkn4GxEB
 ZjaxkiCSth1rn4pCSqQ==
X-Proofpoint-ORIG-GUID: ptekdA9aHaFxQhMn19LctlFtlkPa0bub
X-Proofpoint-GUID: ptekdA9aHaFxQhMn19LctlFtlkPa0bub

Hi Sasha,


On 06/04/26 21:13, Sasha Levin wrote:
>>
>> We need a process improvement here.
>>
>> We are pulling in a broken commit as a stable-dep, so we can revert it.
>>
>> Patch 45 is the revert, same logic for pair (46 and 47)
>>
>> [PATCH 6.12 046/265] PCI: qcom: Dont wait for link if we can detect 
>> Link Up
>> [PATCH 6.12 047/265] Revert "PCI: qcom: Dont wait for link if we can 
>> detect Link Up"
> 
> This works in our favor: it helps us answer the future question of "why 
> wasn't
> this commit backported", and has absolutely no effect on the actual 
> codebase.

I agree this has no effect, but couldn't we just say, the reason we 
never backported it because we never have the broken commit(vulnerable 
commit) backported ?

> 
> What's wrong with this?

Overall, nothing wrong in code, but from a process point of view I felt 
this is a bit odd to backport a commit so we can revert it immediately.

Thanks for checking.

Regards,
Harshit

