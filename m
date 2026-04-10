Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA13389E05;
	Fri, 10 Apr 2026 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823859; cv=fail; b=UA4vpsIpmsbMw7Yia7PM9xMIrSpocoMCUMK0GiCIHAJ0WflF0AZzzX2ROYo7BDlrq8/6mX24yU8GHgsvTIPNk9E45ERszAIiHP47q1NVRzYJrAliXIN4sQD5V8bjyv+KNM+6yoxYfrcEN7JcOfOalS+CmzGXaEooExNi7iugfZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823859; c=relaxed/simple;
	bh=Sk6GdHu0oU1OQSt5jy9Iu17KgsA0Sw0ZQhjAqEqFUAk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WEhxCI8ZZ189niO4eBe4BJOrGY2lUx03YWvQH2yEPLOyejBI1gMDUcn5f3g87/9ao7umqSiydrUnb4+Cz0Jnl5ZcP2FtV114R3SaNKWefFFzGPqBwoBf7Aq4O+NJ6y8G9TMwqPa+Oc8CN+uu2lmynb7aJrv+VLtSwK9H9rP07rQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PLRFhFag; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TQtgIudA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PLRFhFag";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TQtgIudA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A8u6RP519137;
	Fri, 10 Apr 2026 12:24:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ranfmrxiAOz/1Xzokw217fJNr5OiBaRFNJSe0X/FZ2c=; b=
	PLRFhFaguy6RSjeNy0mEN3oTJol+GdcCTi0NoYNvbp1fvM4CuifKQu9RYnXSTpH1
	HcEoMlfxvw64XmrxFYweZPOoVQMNOmTtmxmk/m5SXjXJvVa7co4BjnuG487U6yhV
	eXKRCweXs5XzYrehS19npSE0oNAq6BnCs+gqkDXy16NUJAuCz8h2qVIpfbXt3Eow
	/B8QviIH6pUQQgaVw0mG7h5V+H8Boom3KpO6D1N/dDnIGcfBNr0j7WXHIfbnrmUD
	Fx5qcMllgcEawXNkKpCGQ6camQ6IGR6iFHkKv58YCNNQXzQTDE9656lNS1sIimN/
	Mz3AKMCYbsMCaqoASwumLw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb1fp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 12:24:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AB6Alt026660;
	Fri, 10 Apr 2026 12:24:14 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011055.outbound.protection.outlook.com [52.101.52.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmedxyqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 12:24:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuCB/0ostbB4osfrfiKio8G6UaTdFqbJxKUoXAzxwADSa7MJxVMH+uyLyjtsYM20gzPWZl+xI/Iv3P1m75bV0Of/K+qTYv8KhRCewCiToy0JcEPJpkm0g7kmBuIUFe3B/EWMJwTY3epkhu6ETwCkIhYMnsIHY4U4JOCoTFuyMiBjMsFcLQbAjF2r+wZIMGx9uyDWtKBS/BtRBt0mcjXXy0vLKUKS++MxA181qiv4eWmI+kKul3rlZ3X+vRsCEDjJerX6b1SGzAwP7QNqoAr82mcPAbw15gQRa9BXa9w/AqNk5k1DZxwb3W+msz3njY/a5mld2KC9nfWSEREbiA32rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ranfmrxiAOz/1Xzokw217fJNr5OiBaRFNJSe0X/FZ2c=;
 b=RIPs+tL/7yabgqYpYsJsEFgiEJ4/lKpTeWlCVbPBGyexJXLFwTiS/Y4fhX53vfefDeVm4fwJYVqCVAT0RbDsXnTMMV9IDcPbQctm1rtGF2SokKwRYGvR2t47yAHKPbbeySddMLuZBs3oNuw6sO7EpS07mVemvuzORN2WjBd/cquP/DQhqyoHNrWqWqWxdbQWqVu/wqHc74gI4iAk/Clnz1cdMiIlIiA7AfxENe4ASJdp7fEebO1aduIn1ySXP+vfjQSudwknQPfF/7uENs2nnO7eu9hsKj8YKhXJiKIGuuwv58iul3jGWMeY5KP95VQLqvwmfXHiXtU+V1NS7UQ4ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ranfmrxiAOz/1Xzokw217fJNr5OiBaRFNJSe0X/FZ2c=;
 b=TQtgIudAKLRZxyryrGqxDCTxTvG70CvttMBXd5qQYhvENMxBMhXxESqDSVIAx7TZ7KvKcLGSfZTdE8bPEFpAWi8fVeZadMzBKHBhC6HeK7RR/W9F85PCCAaK8A52A58I/TAYnwIAB3DZGPnL1m2i9zQYRcoehSTEMH5P9t/nqZM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CYYPR10MB7565.namprd10.prod.outlook.com (2603:10b6:930:bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.24; Fri, 10 Apr
 2026 12:24:11 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 12:24:11 +0000
Message-ID: <331ba1b9-b487-400c-acfb-a3aafea0d808@oracle.com>
Date: Fri, 10 Apr 2026 17:54:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 007/242] io_uring/kbuf: uninline __io_put_kbufs
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Vegard Nossum <vegard.nossum@oracle.com>
References: <20260408175927.064985309@linuxfoundation.org>
 <20260408175927.347004376@linuxfoundation.org>
 <71b9df58-41fa-4b40-b3c9-c8820bc6ded2@oracle.com>
Content-Language: en-US
In-Reply-To: <71b9df58-41fa-4b40-b3c9-c8820bc6ded2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P302CA0015.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CYYPR10MB7565:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e4240f-cd54-495c-3253-08de96fc1252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	NrKAj3FxK29Qc9xs7FrKX8PLErIcmW2gS0hK9GGvAM8iUkmCPvW2mt3We1tQYdrb6nOERir6gKLq8rkbWYZ8/A+Zy0S3pISYjwxvFFeS7uO3gQnIKRajSSCXPgci36Jqsqkq9WOuvdqdNyNCiQ54GNGYhXT+R2Oy5uyigvIKL0ZZ92kLep4ivvYJfw2NUFndR2ZP6Hw7A3jq2740wRUOO7oNoW8tJA5TMVnX7AYWF7lPpF44x/TrE9VgonFVtXmVAyH0TTqLlV7drPcaOF5Fwebff2QMaTlzLNufw5F5v+DiKSgdmhSg5QQ5t3UYCJPUWIeuCSJGf6357KgiDXPk2argitoSwYa4+ydrdzmUsdrclA53z9Tv6dQY1juwr2e5vYG0wYmOt+VJeVIzD7Bvn7bSs6zoOfztq4R7YbAetTnxeEC/eKx7cj7DeX8MdSvXf29MnWyRY9Wn75h6ELmNCFd+pOP5ZK6192ev7WLoxr5EUGITMRWUm6/HzGgP11W5jkAp2uB014YcM9lMGuln/x3j31R31RuQIA7UBOeQfFvLCX1nvTXV0+0JmMbUuLxmYgHooywwpxt7dcHzz7f2UwjRo9yIYAMZ1usUzjAC5FzqzbeR3snuQopmVkedvu8B37anmfOibkQ9OZnGll2Lke4jWtMKQrS0qLmRpbCcEVg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVpkWU1EY2xzeitXcmJhT2s5QVBCWXJBa3NMZ2JWaFFrQnpIKy9SNGNYRjd3?=
 =?utf-8?B?bG56YW1DTFhrQVlndmNBOHlidFRZaFJqaDl5RXdpTGVJOW9zcGZqdE9sR0VQ?=
 =?utf-8?B?aFlFU0hyZ09rZGVZV0lGaUxrS1FRcVhWb1JmemswbjQ1UUg1SWhWUmJHdkls?=
 =?utf-8?B?TjQ4d1BlczFwTDczSDZOdEVxbjNDdW9FQVhreGZjNjRBdG5YVTIxT3NKeVg4?=
 =?utf-8?B?V0xGblZZWVNGbC93MHRxalRCSmtQT0RlZ2hKQXlaNUt5Mk5uSEQ0anZnZFZC?=
 =?utf-8?B?UVNZVVNhNGpoTXRIbEhhOVhqcXVLWURFYUxZS0crR1JnenhaNWVtZkxkd05q?=
 =?utf-8?B?OXlETnNYaVVJZWdQaU1oVGpTenVGQ2NBMnk3c0Y3ejdBRmlyVVRuYkxwR2F3?=
 =?utf-8?B?RjRvZUZPTDBlblNPRHJNN1k4RUR0UU9KS1dOTkJpSE5FMEJGZEU3THlHUDRq?=
 =?utf-8?B?ZENHOTBObDVyU21tbjNHNlJTVEtGMWMycmtZV1A4T1ZLY2NoSmR5Y2RiLzk3?=
 =?utf-8?B?NjdvaFZFQk5TbGVMS2pyLzZxc0ZBK0x2TkNNaGdaeFE5OXpTZWgvNmEreUVC?=
 =?utf-8?B?djBlOFdrVk1BbXl3bi8raytCWUVZNWo3ZTAzaVBGQW9PcjAxT1VqR0ZQa1NN?=
 =?utf-8?B?d2J4ZkJ1WlpxTTBjc2xhSE4vZXo3VXFIK0RvdG1GMHVjM3NNN3ZKSXZGTlhG?=
 =?utf-8?B?Rk1UUHlaZ3NLYlo4cmZpNmpZaER3bDhxRWkrcjU1R0E0cVhJd0p4dzVHMDR1?=
 =?utf-8?B?c25IcjBCcWxRV05Zd0Q4Z2tQQmFiQ245ODFKcDVZOXNReVZtR3BHMDh0ZTRY?=
 =?utf-8?B?SDhxRDJEL0VHTjM3TWJ3WmdRcnFDZ2pIR2VGOFIwSzBLN1RkRjYyWi9xdUVL?=
 =?utf-8?B?U1puMjh0YXRFWjN5d3FTcTlWUjdLLzl5ckFYZENOeTZOYUhMNVRweHV3aE1V?=
 =?utf-8?B?OWw1NWxDVVh6NkpCWHdXRytpOE5ZWk84dTU2dm4xL041djVsZDNuQ0d3RDVO?=
 =?utf-8?B?ek9oSVBZSWk1TSswTkZFbTV6RnpYWCtGZFJuemNncEw2QlBHd1BjcEZ6UExs?=
 =?utf-8?B?RlE3cmNEeWNDRTZ1TzBTSWlOQW81RGpoV0hGdHRRZWdVZThzbldqeVduVFNQ?=
 =?utf-8?B?WmYwNmdKSEJYVzc4R2pPMG83N3djMVpEWm81SE1RRVJUNk9zZHY2ZG16MzV2?=
 =?utf-8?B?ODVBLzlrMmV4NUtzcDhTMytENjdDOThJTTJKUi92OWRLcnN6M0VieEZscGpm?=
 =?utf-8?B?K1N2b3BwMGY1T1RpbENRKzY1dHltc1A2TjB4c0I0Q05ET3lLME5MbXVzNUUx?=
 =?utf-8?B?ZVpJbU9udHNIemo5VDBsUWcxQzJ1cnBFZGh6cm81S2d1Z1I5WDY5dFRmMHh4?=
 =?utf-8?B?bVRJbHlFVlVBbDFLendJTWg3Zjh5emh3ZmVMYTFxcnFhd1lIRmVMN2I0SE4v?=
 =?utf-8?B?aVdFRDhHeG5JVDZrbDNxaDhsTWhQRUlsRUNjNUJKanpSekwxYjVrQnZLMjdv?=
 =?utf-8?B?d01tbVczQkd5cWNYd0lCbGlnR0o5NVI1ZHlvamtyZWFUcHc0alJWYXhZMWY2?=
 =?utf-8?B?U0dzRU1TRUpBb3dBWURRYzJybFowWXVtUWVjcHRlMWdnVlZZTW0wY1J6TXZP?=
 =?utf-8?B?MFpBNTRKY3pVM1REeE4vREdzejlkb2hVWEZWTUVDSHp6aUdqZWlnRHNPa0Mz?=
 =?utf-8?B?U0pvMTAyejlMWFZTZ2Y5T2xZbFAyZGh0SFIwcGJNV3JnMy9meGJBVWNsMVNi?=
 =?utf-8?B?SXlrK29JRmpXdS9Ba2I2VnRuQlRuKzZCNnpHWmVBNGEwcUp3dy9QK1lKdUhT?=
 =?utf-8?B?cklMRVFnNkd2S1g1MHIwYzVDUE9KRkFkaUlVcW1XcDBqRXQ2TzUzbytXWUlu?=
 =?utf-8?B?ejE2bUFkUlRyRlA2ZlJjckdYOXJJdzRlZUFnaHJOU3k2eE1ua3hCUW5xVHB0?=
 =?utf-8?B?ckJmanQ0Q01yQ0c5Wit0S3ZaTTlQN3BmbmQ0QTlCTWVMUm9MS25iNmd4Ulc1?=
 =?utf-8?B?MndZNmxzbzkwU25BNHFwOE4weGxibkFDZmZrd0QrUG14cVNMZmNJU2V4MnZM?=
 =?utf-8?B?UEE3Yk5QanhSRm9MQ1hqR000NXVTU3N0c2lUVm5iQ1Evd0xvVklXNW12VG0z?=
 =?utf-8?B?WWZCSGltd3hTd0VSUXRORjRiOGRaRTZvN0ZJN05aUjNFOU9wTXFJZlMvOXdG?=
 =?utf-8?B?Tk11UlN3QXdQT1JtOTNJZTdjNWcxaVdDajVXbXFVb1NkYzNIMkkrdG5aUjNs?=
 =?utf-8?B?UzlNVU1WSlVuUlRwVVJrT3ZCMVR4QVZ0MU04N0NKbHpsTVNzMTQ4S3dtZkow?=
 =?utf-8?B?eGNjUzczdnkrUENmajRoWWtwMWt5empZTlRDUnZSMkhWRG9wWTUvL2hXQXUw?=
 =?utf-8?Q?u/3n/z01YD8zLQC/fsu3L6fxANJ4itrzz8sXt?=
X-Exchange-RoutingPolicyChecked:
	mGlBj+GTDptV5bLzVRFeozO2hQQQY109VBa/BZywiO+JuU+tqdpQ0EcLCcC2/B2D/5821Fjenu9W01iS6YPranvE1g707FfS+6I7aXwaAeemM/9zT4XVusQ9smcWNy/siliic3Bv5lOKcg9VpeB9M0k+iVtryHYRyu4wkeu+r70Kq9CiWdipJDRIMJSQtnOnC1Eosg7iEYS1ePY0A/Nerk35mx7UmViS99bgIEqQOuC5cvsRRkMofundWoYAAbF81HGd6eNAZIQWYpHLO/fvEavPb8MiqhI2YOTaPkHqDxkTfhInkTu58Y9ZFTYZrRDjIDvJ0srouKYQAxE/BZa1LQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	grDhKVmLpyKT4tDpefS64V6A5p2bIVAGorG9+LCo2/zRUF2C70Uw8I1uvOcnN5DtaH/rboFdM8OgwaPxPp2NgRuhyZoKUKV9r8MctIXBODGpOD46vQ9kh73BdhxBP/6eFjZwQT/WDeJ5RAGqICkyMscmqBS+r7VWt2SsE3cN2OqyD1zrqDfkHS8Kld9PKnCJrd2u/baGmxMsI1Sk9HaB8o+02LGsACTKMTVLctgPYh39tcJn3Qe19BHUj+sUzSycWBsUC8EdZ9uEnbRjRrFVhaxBl1BiCANI5K6QK8geXi00zNRoQct/yYQXds4GfJmK0cOj1J3/xAvvkiUt8GYQ+X9z8HXnAfGhkwHbTzP8ZOSPnVvu2AUe8OAfbbC2ddT5VNB8Y7Db1UDvyeT//GL3vnsSfxvScTJ8VTwbH6pGgLnNyldM4YZT8Of+jBKY/QjVgV90dJumhhj6jUg7vAtStJfCoUu0WZzbQx3lCFD/kJRQIBEEcD9VqRr4FdY6s6kz2c9YqtS9CZoqAo7gTThbSIgCvE5tbbqCDdAC6z8FtDzMWXN4sZ7cvlZsTR8kMURwfIfjjTXYQlRJkMAfnE8f0D/W0/Y8/1/tg5jQn7YKN2c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e4240f-cd54-495c-3253-08de96fc1252
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 12:24:11.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQO8QJDGM4Dm2cl5vU/1GU8RdiQj5ed14VFYCKfbSeyr3u7Xn4zexZ61xC+uYg5MOhbm1sDZvkn21F6PMPz8Gwds0I2iQNGygC5zLERCz3UeGauXtzP+WtgzitzQrTSY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7565
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxlogscore=496 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604100115
X-Proofpoint-ORIG-GUID: vps9HVL_8VW7-EjUsPOmQiXkb5dL21VT
X-Proofpoint-GUID: vps9HVL_8VW7-EjUsPOmQiXkb5dL21VT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExNiBTYWx0ZWRfX+J5k6pB+paC/
 1Rl6eO22CTII1VgtH2nFJAq1PfrVvhVi5JAjl4brbEjhclIwXRZL9sNRwMhznBBnLmjftNxH2K5
 muC0VCaoo25K0VFIUoiZWob7XTyGqaNAFIniLvY4IPCKvmOKcKptOjzQtbFsP9YjXO4fUkwvEMM
 nUX6BlG4QseX4XfhzvA7ZGM4l5jXNaBmiNUta/Dl9cb5vkhOcOaBVCXdZR/xsbe49FlUQyN6hs6
 CHbuPYTbmQZ3+gyUm1IAAAA41UqueAKztxRm6maAK6mjReQ9DOOmcM1GSCj95wky34NJipLbdLB
 g7nBdfXSxrQ+QA8No10G0y0YYo9P/b8ja+qAbQ7B7gaJ0y5jvYph5A/UqoJVmxkmdDgmhVOh/gc
 vx0Iiuw4Kz/gHp2xIoEGD3rg6BZPxFrwJAnGCR9Tvp6IzchkZUznVAZz6jiQE+DChxywXEUkVqi
 aYvY2x0zcJEfITETrMjCodJo5aVSiT48fLXT44W4=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d8ebef b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=z-U_xtq-xX8ol_mIiz4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 cc=ntf awl=host:12292

On 10/04/26 17:42, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> 
> On 08/04/26 23:30, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Commit 5d3e51240d89678b87b5dc6987ea572048a0f0eb upstream.
>>
>> __io_put_kbufs() and other helper functions are too large to be inlined,
>> compilers would normally refuse to do so. Uninline it and move together
>> with io_kbuf_commit into kbuf.c.
>>
>> io_kbuf_commitSigned-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Link: https://lore.kernel.org/ 
>> r/3dade7f55ad590e811aff83b1ec55c9c04e17b2b.1738724373.git.asml.silence@gmail.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
> ...
> 
>> +static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, 
>> int nr)
>> +{
>> +    struct io_buffer_list *bl = req->buf_list;
>> +    bool ret = true;
>> +
>> +    if (bl) {
>> +        ret = io_kbuf_commit(req, bl, len, nr);
>> +        req->buf_index = bl->bgid;
>> +    }
>> +    req->flags &= ~REQ_F_BUFFER_RING;
>> +    return ret;
>> +}
>> +...
> 
> 
> Looks like this backport is undoing the commit: 0866809dfe19 ("io_uring/ 
> kbuf: propagate BUF_MORE through early buffer commit path")
> 
> ^^ in additions above we don't have this:
> 
> @@ -165,7 +165,9 @@ static inline bool __io_put_kbuf_ring(struct 
> io_kiocb *req, int len, int nr)
>                  ret = io_kbuf_commit(req, bl, len, nr);
>                  req->buf_index = bl->bgid;
>          }
> -       req->flags &= ~REQ_F_BUFFER_RING;
> +       if (ret && (req->flags & REQ_F_BUF_MORE))
> +               ret = false;
> +       req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
>          return ret;
>   }
> 
> but this is being part of what is removed below. I think we should re- 
> backport commit: 418eab7a6f3c ("io_uring/kbuf: propagate BUF_MORE 
> through early buffer commit path") ?
> 

Never mind, I see this commit is taken again in Patch 25 of this series. 
So we are good.


Sorry for the noise.


Regards,
Harshit

> 
> 
>> -static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, 
>> int nr)
>> -{
>> -    struct io_buffer_list *bl = req->buf_list;
>> -    bool ret = true;
>> -
>> -    if (bl) {
>> -        ret = io_kbuf_commit(req, bl, len, nr);
>> -        req->buf_index = bl->bgid;
>> -    }
>> -    if (ret && (req->flags & REQ_F_BUF_MORE))
>> -        ret = false;
>> -    req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
>> -    return ret;
>> -}
>> -
> 
> 
> Thanks,
> Harshit
> 

