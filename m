Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE93A1682;
	Fri, 10 Apr 2026 12:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823143; cv=fail; b=smD6mXfupGZuiblHOmBAPHD6rN9E0mMIzpQhgWcTo5v8XZumJ8C7BS41obGDdi4zC1fHo7rNxxZOat3FM8dyiJ37UkekIwO+BSH+P+llIGPABvpQynntfUpvFOYoo+21JDr9N47SFUWg+cyP7I+AHM27E+Uoq9pI3rbSXZUUBWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823143; c=relaxed/simple;
	bh=9yGVmMhSb3Jp6hW0dXX2N9tcpaBYH/GqsGrzBduTH7Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OIq+mY7U0uPLX3rLqT5MsE6ss1r8s9rj6zTxttOCVjatjGuy0ddfrtdwLdxFHt+UDt4liwnEImsPrI8JrZ9al2nQIv1v2p61JE/y9Z/UL6bLWkZDS67c8bPkRikxTQ6uwVduJIUs4W6Flkm/XSnb5JoWiOhqSqRa5F1/fsvMskg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SQdTiCBL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nmuhF7D8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQdTiCBL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nmuhF7D8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A8tSBt682195;
	Fri, 10 Apr 2026 12:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=REssa50ZWev5ziUm9p7T5CiV5quPAFwNkSwnYfymf1M=; b=
	SQdTiCBLTA0Ax4EmB4Nm6cflEFIVKdGlRGwodvjU1J060wBykWdB5O9hLFEsFvse
	gD8wKL7FNyxAooW6/hItlV+5kEQ47gWw0IRWXb9NFdtGBE59ZhREBv4MlxSbyxiI
	o1+sQFFIczYXf4aPZD7OcTC0zCO4yjQOx67b4/wxLOHjy0Ll/AM8iPdykGI4rv7M
	j9kn1CbWzTqQ4RR2DifEhgYPIZfpVHKsjb1JV2c2SJCeXVdiwzdkokVtx17vhOGw
	vA1h2BNZLukE159bZx8ZYJC/zioc59OOBtMeTK3ToRzsIsyZS3I4p4HpPCyeGEMH
	m/os+OlT/ISPWmIW3tonGQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqb1k7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 12:12:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AAoPwq005113;
	Fri, 10 Apr 2026 12:12:18 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxt3x48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 12:12:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h++iCYv5U5ZC67AnSpzw85elXJyoefnl87SURUW54o4xMv8xp8uGBvvB7AUM725yOgD3ButYiwmq0HrsGRYDjXiM6TSLW5zN+0RkNxmpRs8mCzfOouNW5X0AQX9lvYoWsHtBsCgHDigdWTden2PeEA9JhBq+W1cNCSdU55Q9SM9U9LZWidIXaiXg97AI7Tp0bc8kYz10FtYl/3+1SeYoKbHZizFhD+nHtBHtJ+2PxurCzbpRz5q6e88gdnNRpFpZE1fQWzRml27g/TjmDlCDhFXWiuT3bMXvTyecZ8Cf09jcDFN2oE94Xw6mLcjNP9Oiu39Z6kEAWO5fj1gTGVzDkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REssa50ZWev5ziUm9p7T5CiV5quPAFwNkSwnYfymf1M=;
 b=tw8Rg/oJtkGe+9J0NFOKf8N/eGS0GoB677zz2b/N7VtnUvZjw/KEOkTnk5zrR9BW32LIF6yoQACWlu2p7hqsdMydFoArmC2rPH1e6l5hYx5dYfr0sfg51Wxq63NvWIxScuGLaSMJQTjYd5iW6Gg0xyWnUnLpwcQmErTLiRALh9DkB/A9OZFXCC5a4oUsrFOHQKi+SabBqFGs4HeMUFv3RK0R7C1i8uNIw0QtpdEBXG5y1sBq1zEqWn/M+uppUYmrOPvNQUQJysoaUxVVGgDIipJHPgZef3paLEi1xeGsupYE1gOlm2nn6QJJGwrfv3M4Kv6b8GQpSTa9clxJRTBvrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REssa50ZWev5ziUm9p7T5CiV5quPAFwNkSwnYfymf1M=;
 b=nmuhF7D8Y+fNrVIPd4pkE+rYLSCAzO22CIJp3hIAXLhh8dySKQFN1V9YqiRfLPjpEYH8kkOVgW1WSmfToCyHL5fUlyXpvldWBMBCVxBKhYKxpmsN4PkYFVthfEC80nWuAJ9B0UO+IKVqPqFXtfS7+5DG7LWG7HUvF3yx92OOLBg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BN0PR10MB5207.namprd10.prod.outlook.com (2603:10b6:408:12c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Fri, 10 Apr
 2026 12:12:09 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 12:12:09 +0000
Message-ID: <71b9df58-41fa-4b40-b3c9-c8820bc6ded2@oracle.com>
Date: Fri, 10 Apr 2026 17:42:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 007/242] io_uring/kbuf: uninline __io_put_kbufs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Vegard Nossum <vegard.nossum@oracle.com>
References: <20260408175927.064985309@linuxfoundation.org>
 <20260408175927.347004376@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260408175927.347004376@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0086.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BN0PR10MB5207:EE_
X-MS-Office365-Filtering-Correlation-Id: adc5ccb9-b769-4513-ca6a-08de96fa63be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZpC+jn7wDsmpFXpN9AmgFFvvR4MLRQCVdowOyOPHb3oP7RJkMRKNrdUn825REPB9KwxRmdIxlvspV/j42IZv1BwMUj6gOicX2/rCOT1cTNA1QuvHAURZQ/crkgvz/gO0r4enmSMK++Abw1Z6FasIQyGLjxQJkIjmX1WixgDy+f/PAm2pXSVMYhjpI/7urPKxpcoXDqM3qrQ96xdfwdVlrjrHlmbAF2Hav8Q0ldXS5dc2GIGjpx5VKGrtxMocXecYKqo+1upczt22Y2SwnZguJvC7UF7ruQzvelXwt0sScgXpCG8qSHsr4+LQWdTspV2PqDM8/z7iVp4QYWK1iLyKg7T+0vXBuBvHNvSeO/UUP+SopwKfpkVuVqmlNMX5wZChPBhSRfd5lsavEbj7aonPN5wAdTWa4hJ+W4fSgWZ392xUYsfRHtIG2KLs+ITRVHTBGaghf0xNfxbXdvFyrk0zojmxUuNib5VAbJRQundTgkTR825EhhCtPh7QKJCtSBpYAqLDMQzMaTTvdF3oWl3Wtn2iUrlvPzWaHOaIivBNrJelPIP9RyEGdF8XA3My4zAlw352nFkpVE7zWiWndlejtNRpve9U0fgbJIvJABpI7C/098lh/4EGASKNS4WXfzJ06kTTmXIoZuRFS+tIA+dT35xtwBzN23rK7IJgcZzQSpJJDCFvcnGvyx8LYeEjVPhXyFQR6bD9mobdQvw55qaZeWfavDWBCZ4DfBfAWjuHFJs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWZLdHQrT0NYeDJJazRMQ2JPVmx0QkU0eThVbk9heElQTW1XSmx1bDVJYzI5?=
 =?utf-8?B?amxLSzNYMktiQUtQTWtGVkFuRDNVSUM3M1pIYnFyL2NNK0Q4OE1MWnNCSnBz?=
 =?utf-8?B?ekwwKzRQS0F6ZXJTTHFyWE81WjR0VVpzb2F3R3UycGlKL1BLNmhMVkR1b09l?=
 =?utf-8?B?a3JEY2NIbHhIVEhIWmltRFNtZGJ3Sm9OOFZ3MjFIc0tBS1prSHFOY0NPK0l1?=
 =?utf-8?B?RGNKNzVzcFpkZU4xNFJQN0FDRGNkdys2OTNSVk1EeFN5NHA5TER6OTJsTG8y?=
 =?utf-8?B?OU1zWW83NUw5Vmlad2xPU3ZuUXpJTFI0M3F3azJ5TE93eDB5VTJoWmFiaHNH?=
 =?utf-8?B?VEM3RUY3SEhLTjJXU1RoRC9MZEh0aGJsbjArUUhGaitsRVJKcnBybEh1eUxW?=
 =?utf-8?B?U3lSdEU1ZzU2OWRoYmpIWjhEM0VUczBNaTg4cTU0Y2VldVY1NkJaakd2ZzVx?=
 =?utf-8?B?eTZYRDQ3V3JnY1FDeUJteXdHYnVFNEhpdFJuTWQ5QnRkZjRxc2dkajJtZkYv?=
 =?utf-8?B?N3pRekN2RW0zVFZtc1BLK2gzTWpMNll6aVNBTVJzQmVmT3FvNXZRVDR1c28v?=
 =?utf-8?B?MncwQnVIdEJaU0svMGMrL2xnbXdqNTB6YjB0K1Z0dXpRUVJkbU9VUjd6YXg1?=
 =?utf-8?B?WTJWSFlLa2Z1VlYwV3p1Q0dSWmF6bm1zTDNhaGkxSWNYam5LeFNSK0oxV0U5?=
 =?utf-8?B?dy95Z3hxa3Zjd2x6U0VsMGNscWxCN3ByOE41TFFmejlpOE4wVGRMb3lmZkVq?=
 =?utf-8?B?Z1JuQzFRVlIvOEd5SzNpZWdGMnRRR3RHd1JPNXB4Qm5YeXBXWHF1UzJmWmJV?=
 =?utf-8?B?VkFvdXZYd05DRG9MOFlQMm1BNU9oR1QwTDVQdzdzZzZuTWRHTWl4elZXbUZO?=
 =?utf-8?B?c2JyemV3UjgzSjVXN0dQbnlsOUZTZWlYTGZnTWJmeUdsTFc1STdSTlArT2xS?=
 =?utf-8?B?M2RIZnFSRGFPSGlqc09iTEV4MXN1bmphUlkwRDRCNG5sdkJYdGFDQktXbksx?=
 =?utf-8?B?QWRhWHEyaGRHVVdVTVRuN3Bmcnk3MkNYV1BYRUdaUEs1ZTU2MVNwTkdWcGZY?=
 =?utf-8?B?ZUdLQVJxWU5TTkVDRXF6d1h1M1NpL29uQ2ZjamVtSEpGVkMzMXF3NVVrVjlL?=
 =?utf-8?B?enRuUG1CRUx1aW5CVWg0d0d5bkdmSHN2L3VFSUJoRW85bDFISGhVenl4ZUYz?=
 =?utf-8?B?VlFmR1RkS2RNbERkTXlvQ2RhNlRJNWpjVFUzNitRM1VKWUJ6Nmo4Ly8rV2VL?=
 =?utf-8?B?U0hUZEJPRGJUZEVsaytJdFRyN2Y1MkhjbWVkMGFmaC9qcXc3NlJvdUJWWVVD?=
 =?utf-8?B?bEhmVVh5aC9HRmVEbXVZVWY4NitlWC8yb2t3RVA4ODVBMlBINWNKK0JMTURU?=
 =?utf-8?B?Tjg2VGdLd1VNenJKSWV1WnkrN1pBSnVTeFloNk9xc0xiVU43cWRSZU1KSGc3?=
 =?utf-8?B?bS9tbzdMSlBiOXJpTXhuKytjUXA2U0Mwcjdxcll1M2cwaGJ5MkNxb1Q4Z0Ux?=
 =?utf-8?B?REJpTzRaVW1LRHNla3h3MVk0SVlSTlpFZEVoQkRqQktQTktOQ1Zya1BLc0Ew?=
 =?utf-8?B?MStJNXFXa2UwNS9EUUd6ckFjNkJsTU83akRHa3JCMHJLUWxTN0lrd1g5V0Jp?=
 =?utf-8?B?RnV1bHhwQXVUa0ZzTGZDZDZlMldjNDFvR1lob1JIbGVzM0duUWxyTkgvSW5T?=
 =?utf-8?B?VlNONjdtallra0pTY0dNNjlXUEtYd2tUaDBOY2J0V2QxVGdMc0FPUkxYNmlO?=
 =?utf-8?B?ZFVqYmxSRHJsY2M0VDd0NmF4ejFRLytHRkkzdFptcDNjUURlTXFiSVMwa2Qz?=
 =?utf-8?B?d1ZoWVlWY0JNT2Z4OTR4UmpBSkxCQzZEOVVFYWhrS2xsQkhwcVdHUHh6c3FV?=
 =?utf-8?B?b3pEdGpaMy9YN1FyRGxISGpPQlcxd0tkZ21pRnp3QVpqOXJ3RzF0K0tPRzlI?=
 =?utf-8?B?R05Fb3BaRld4VzN0UUNGa1N3SHo2b1J2ZmNybEhaUmZ1R2NGMERyckhHb0NL?=
 =?utf-8?B?SmtIMm03NGgyeVcxeS9XQkcrMmtUcXMvUGEybmFrNlNFNGo3OUNHb0VMQ1Bw?=
 =?utf-8?B?aFl6bUlhNjRLOEhBT1pjL1NxN3RHUjFZL296WHJhWFY0dTNvOVhLRzNIR2tD?=
 =?utf-8?B?ME03cDE2UnJQSW8wdDBvLzJ1a2RZMDJmV2JLZGgxckFjWFpxeUxqc211VlZJ?=
 =?utf-8?B?cTVIQWt3UmV3T0prYm8rclZ5K3hKNDM4S3Y4QitiWEM1bHpFbS83QUFGbmh3?=
 =?utf-8?B?UlFuam13a2NzV0RqeG5WL1ducnVFUDkrelRJWDBIZkh1SzdtaS84ZWZyck9z?=
 =?utf-8?B?bkpNaDV6OWo2UFhwSWN4ZVRhZ24rWXlLZWptMGg3M1VIblVyUzV6ejZpRHZQ?=
 =?utf-8?Q?ooX5FXYHPC+2BjGdNalpsddZqZCqb0X8uL/Sk?=
X-Exchange-RoutingPolicyChecked:
	iA7gcihXKpeuFKvFYq1+JZ1jJoI7ouQ1BOKWeru8S0LunLidX13L5jYbeWWV8ZTIWL4ACXBy7loseMYi5ya7YE92r3zJkmJTWbQe4j1ffQaepRwXAU4Iz/sxjCT+NaI8t7Kv60tVa7+i+CBL/bvUj4kVyYdXgHDcpNDGqW+DmHnQooNVExmXvzojXp0ge6Sej524YvP1RlKXZYkXSq93f8pEDzhPt9Lvkphzx3uuZmtJjLU8LatrpdMEzd9myPrIkNMmwgIS9gt2SqHmDbkfjGoKjlcqfAAl0z+DKL0gUqMLWziD7oUmxxNfMZlxv/FkBy2xmexRDn1CVwDEao4psg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TPkZXtYBMp/ziDFsZ+FjezjNFgd8x9Jy50RgLHcDyxJ/Xq+LzWrm3URpohjuYDQ9mwNfs1TxceLrp2uCnnRa/Ypvj2iCgEVsJqUmw8cuMIuCS21i3v6+tRPGRsGCgjBjPpDOnGpatgaCRLfUHsbWDm9u2MxYnTH4HV/tc/+ZO4ifJt7yVijPPuKFjOup9HRd+tIl3USyK29qGBg79bXUUI8V6wVn8wx6hP6XEQhSANYkN61ZD4ofA7eCctG3Uv82/3o/pUZGYlKG5TYPrRfbIk5wHvQsf9fuzGAWReDkvENLDq5PI+AnCn5ckOtwwvzX+1xI8tniLyt/av+59z80DZGvEQ9GqrsK8LiDhKEZpqG5R31+lTKM5vhW5i56Mf6cesoGHWQv7Y52MFiMUf9LpoK8zkCUr2eaEM9uUMz9EWYH7nnnX1t4TznJVb5p95Ib63ci6g4QsWGjIi480z5RNtE1XSqrCuRyB/AUQuM9qsEdPx/JxBUYrFngu7zABm28o+NzyIshomdg6U7CW0YBkquC8STG9AjnUayyPU8MYI5lJWdr2hLmtCgO6v2wMjDeaDE8yJmVv6DiDLuun1XVS/m9mVXEic8yl0upBRhqrug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc5ccb9-b769-4513-ca6a-08de96fa63be
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 12:12:09.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwtAko9B021s+iXoSGb5hJQRrYcmzQDrVbwoWG3U2UjRtXZ+xFlzp5u/6opw81r1AQ6Vvhv+4sRbntaWOUeqZwqXIjeJAno4o7WO6fbKNR/vxyzDcVmXjHq2Rsjs1BL7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=547 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604100113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExMyBTYWx0ZWRfX3bjErFnw/HRr
 kLAOLZQ1Mi6HrhonqmKrx/7H4Ol20V50Hrx3hkowgEtq5sJv0m5iiM3dZXYrf4MT07IDE/Bfqnn
 56CFiGc0/7i937mx0UIerElT1szCHDM5IkCeCT2VXQ/V2e9/EdbdbRidFUlvLBMFbevvyBd+TPU
 PxrEcsJ7+gezpXx+ucUl5rz2QRXokKsh1PpTjkoEmihaoGJnoGTcCRQeUs/EBnYkeRvLagMY1V7
 vnFO2mEpKaPX1ELMmsFgzRsxQiSmeuTg0Xbq/oPd4IguCRDctruE0O6auzYFYR21R+wbavkolgM
 pj15UQYHLjdD3qaxERl8Zd4vm8gQ8u8br1cypDGSNtniG8X7FKpSbxs6mzuXbaZlA93fLIPYD31
 iQQ/fd3qWCSfjXQwp8LRaoyJqHaOS2UOc553HFXKuW33kd0ubP11q7x4vza/hjsqo06O3sXMrBR
 x8YPpO7e2rbaG2QYPQw==
X-Proofpoint-GUID: u2rvWax613pSWdcgzsD5-WIHzruXkWHV
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d8e923 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=e7rztebOFDt66QtvFqYA:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: u2rvWax613pSWdcgzsD5-WIHzruXkWHV

Hi Greg,


On 08/04/26 23:30, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Commit 5d3e51240d89678b87b5dc6987ea572048a0f0eb upstream.
> 
> __io_put_kbufs() and other helper functions are too large to be inlined,
> compilers would normally refuse to do so. Uninline it and move together
> with io_kbuf_commit into kbuf.c.
> 
> io_kbuf_commitSigned-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/3dade7f55ad590e811aff83b1ec55c9c04e17b2b.1738724373.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
...

>   
> +static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
> +{
> +	struct io_buffer_list *bl = req->buf_list;
> +	bool ret = true;
> +
> +	if (bl) {
> +		ret = io_kbuf_commit(req, bl, len, nr);
> +		req->buf_index = bl->bgid;
> +	}
> +	req->flags &= ~REQ_F_BUFFER_RING;
> +	return ret;
> +}
> +...


Looks like this backport is undoing the commit: 0866809dfe19 
("io_uring/kbuf: propagate BUF_MORE through early buffer commit path")

^^ in additions above we don't have this:

@@ -165,7 +165,9 @@ static inline bool __io_put_kbuf_ring(struct 
io_kiocb *req, int len, int nr)
                 ret = io_kbuf_commit(req, bl, len, nr);
                 req->buf_index = bl->bgid;
         }
-       req->flags &= ~REQ_F_BUFFER_RING;
+       if (ret && (req->flags & REQ_F_BUF_MORE))
+               ret = false;
+       req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
         return ret;
  }

but this is being part of what is removed below. I think we should 
re-backport commit: 418eab7a6f3c ("io_uring/kbuf: propagate BUF_MORE 
through early buffer commit path") ?



> -static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
> -{
> -	struct io_buffer_list *bl = req->buf_list;
> -	bool ret = true;
> -
> -	if (bl) {
> -		ret = io_kbuf_commit(req, bl, len, nr);
> -		req->buf_index = bl->bgid;
> -	}
> -	if (ret && (req->flags & REQ_F_BUF_MORE))
> -		ret = false;
> -	req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
> -	return ret;
> -}
> -


Thanks,
Harshit
