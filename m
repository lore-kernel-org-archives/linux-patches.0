Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564B747F78B
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014452; cv=fail; b=dDKRdWchNjCuUP9NtsfK1ET8BM/sxvl3kznYoCsir+4i+H4AeVDcMUy61TiDiTu65IAdRzDTcE1EqsdYQbSDcWcHSM5zVS4sefV7Wvv63vJonUff7yLgbryxThBw9f8XJyPcpuA6aRsNSfwCJemjRjPlyBjenNPatbr2pIvnCws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014452; c=relaxed/simple;
	bh=H5RDU7pMHHcSt0VUOZ3WqYPeyX/E19m4zu8lRR+LpNA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SZZvg0vVCcksCLJCIzANU2MqvfSJVDPPTpf+VWP8RUbaQK17AafJ+5kDTviXy/JYjOgdhdjFSsNcF5ySf89nwYLTlHOw0Q8B39yICneamdlWByeiXEnQeuSHmuFNqPhNOrbbGgFmQ3HaLuPDTWqLi+yAuNCDLcz2MrgPM++aiXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KXi+7prU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PDtezQPi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KXi+7prU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PDtezQPi"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELftJ01678357;
	Wed, 14 Oct 2026 21:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uBLPv2EzbjvfTXHb94j6B4YJ5/DnLwHWq9yaqZinqHk=; b=
	KXi+7prUw8/mmPu0ywPtZppTJ8nHJnVcSr7cjrVwmKpawZsT1VMR4QQ3yuHAUmjy
	toX94HbJgl6ld2WSC1k55j0C9mBevl66TSpNcsRkFN+ZxFQ/6Yyfzh3VjvJaaGHy
	tLMgGaP4fNKhU0eaHPg3+gSDR0BJWmnhVfxyfZv5zF6BCZqaqNVm2mbNsm5E4TKy
	tcQXfckDcvAOoKUoo+jVq69tT0wYE2txaIhigzxMp7Si5a01TcQQ4A6+NoMEXGPC
	EPpli/VOvXik0X2TImGECD2hnCZcoqQPfl0Rqg9I5wJShux2R12ItmAobGBu4Pl4
	ny4rrvUrpDjaQTeIgqwLWQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7y3jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:47:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELLLXY012333;
	Wed, 14 Oct 2026 21:47:26 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btc7160-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:47:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVIMob2rmB6uOZoYHfG6bMBZ0eSCf5RvqnS46OWCZtXTPyf4jdF7tjScSvmsMv1J53M9jtrL7Exv047imYr67qo8Jhwvj19cHjKPtBQ6UcGoPiG1HMMmIh9zT7NDR7PyeunrsjVPtiLaK1oKGtttKjYwhgz4D0jXbRYETnQ3Pokt5tEHIsjOa21wgqo8pTpcJualKpnnb7mK42F8EjyfFoJKtWi2UfKEvABJO4wsjpjYtqiwvHGQQCAEANyK9MBKO2XwjcWeYxABBCDI9tk3LcOZUGuJxWoGSMGZHrPYP4mU4wx3Jnh38syqCI8hXVfyU3+ES16aMNVwtENOYh55BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBLPv2EzbjvfTXHb94j6B4YJ5/DnLwHWq9yaqZinqHk=;
 b=iGT4slwDwtXxiqbcG1qgeZRqC3hCmlvqGglA7ysG+JCtSA0qTuVMvUf3vQ6WIBLb6dT506KKHKYebUyfCLweO0MZjLf64Xvn9iqPk7ynYqLl5JZEmmAt+b/sAfFxlcM1bMwad9cGCnKrqvBBGxtAFBNY72THLgWcDCKK/DdRrtKTk/HBxp+A4ODEGEKgadXruESHle0QdC0WTrB0mcmtAAW4JLNhMON7cV+xpReZzynVGOQLe5NBTmi6pEzkfwzZ4Ed1BjJWkAgiWoPshbkBEsM5HcVNkDOrGDSgxnBTqxm04gCL9D/M9TJ9LN/ujML3gSjmog0sVgJKJo1Y9mloDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBLPv2EzbjvfTXHb94j6B4YJ5/DnLwHWq9yaqZinqHk=;
 b=PDtezQPi/gwjJwrNVkBjWeecnM1sI75FPXjM9CtjDgoh6OoysEaRI3gVILuvzabw5mmdVvabA8Bw9HbQ/Th4GX8UPGI/cXJ4B63jeWyjA4cAQb/agquonZKanUygSMc4STJ1polrwYSdLHr21Y2vyXwoaNpmyUaYh4TsQxqO9Vk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:47:22 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:47:22 +0000
Message-ID: <3bca6bdf-2620-4f4c-878e-6a3cf0ac673c@oracle.com>
Date: Thu, 15 Oct 2026 03:17:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 464/497] btrfs: fix lost error return value in
 btrfs_listxattr()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112918.894044198@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112918.894044198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0010.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e76375-17db-44eb-8780-08df2a3cb9d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|5023799004|4143699003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Gv5/kEUtTHOP1vAKaeiOUyZwYL8l/hZgpxr28QKP3YoF/Z3PXQD4QxSF5jIH8NOZYpXAxshAfTQjwmywCgApk8bESmKGsWt7liTFE96j8/DfyEaAWRLldoV9hdB5fhYVBeGIr6ZpRZ9/VD9PetmDo9/HPrfORUFlBt4mptXVUO7tVCNnVkRNitGtMC5/akSEG11ZG0wQI+a7z0s3lSjogFrPliWgMR+HtEHETNwUp8QqtQaB9q3eZnVA/pBtKTlJOA5kQpXVBNoxF7EudmrChMPpXyTwvbKMGkGMFA5ybxMXAInGaE2KCwrRwyVC9hZ95I7CT1sc/8Y/jW1KOwUO5hz4x4vy+eBmQt8QnTX4bnnss4CPYougf8f8c6mVIkTnuZl15sPXMZAWQGdiVrWWeVCtteNpOBgYUhsNlYZKQvtlJ7dtrjHgRAJmeSCunCVyA9wwpqI3tACT8jeRRvs9e7CuI3FvrNQUZGFM5jvIZBaNOX/8L6mNneasDIwOdo21zthyIkca7pUobfeV/5ArZcmr4sQiWYRuEiaNnu47ydXP7//7EQW75K43wmVQ0UE739N8u638xj7YwRElX4tufW7ERiC7lh92O1a3fc/trHYEFBE0MFITnV36Dw93s0nxsF0yDELsvnDQBTWfoDCiHwmrowHDvVuN8GVh8kB6xhs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnlMUVhZSlc4VWdqNFcyZXR0aEl6dm5HNnpYZmw4ZFdHaDdRVlZhdlNGU1pW?=
 =?utf-8?B?NE51VmhTZFdtZlNzS1NFWVZDNU1mK1BQQ3NEb2lRSndTaDFoeUlaQTRWb0lX?=
 =?utf-8?B?RnVydmJVVVg1ZVJIRHVQTGxaLy9MNkx3dnNqYmp5c3RqSW5PY095WVVzNCsv?=
 =?utf-8?B?VS9JOHljRXZYc3pOTUErdjBDbk50d2V5d0h3a01xeGJSYzVIbW9heWs1QVhU?=
 =?utf-8?B?emlCYzljSW1JQ0J0UTZaRno5WWlxNDBEYUg1TFk4dXZiekVBR0tvdmpVdmlZ?=
 =?utf-8?B?MS9UWHFLcjdsS1VHWElmMTRiSk9YVWpWczFya3RXaTBDM2RIbGxNY29IMzVh?=
 =?utf-8?B?WXBQaGVMUnU5bDBRV294N2NnZ2IwU2d4NnZzZmR0ZzdsRVlab1NUbTBqZjBW?=
 =?utf-8?B?c3plWTV0T3Bxa2RwMFJONHJoN1lubXMvN00xRkMvTkVoeE94akhGUnVURnh6?=
 =?utf-8?B?UEQ3U0J2Q1ZNejhjOUM0K1JLOWZZRlNaNnZnRHVaZDR4RDZlK1lMZXZYcjZN?=
 =?utf-8?B?M0JIMmdzNVprWmI0enc2UGdxSWg0RlBKQUVURDhqd09ocmJYUnU4UlZPcGsw?=
 =?utf-8?B?aG5kbXRBakExaHpPSXlaUmRxYy9TdUVWZFhFVkVnQWE1OVdxUGRSd1NiZ1Qv?=
 =?utf-8?B?ZDh1Q1UvY3pneXpFZjd5ODBEVjMzcUd3c3B3ZGVlVkVFcWZsVlRBUzhtcVJ3?=
 =?utf-8?B?eVY3RWhDREdVWWRXYU10a3NXSXIyMHo3UVpOblBXdFpqcjVrdWtrbHNMbkxE?=
 =?utf-8?B?cG54cVhoVUwrN1luR0F2WGFhR0xVNUlqcVliV24xTmkwYWIrei9Ja2Rxdy9k?=
 =?utf-8?B?d2hNSnpnWFBtK21sKzNHczNIWlVBb1RQKzMzMFZhUHIxT3RBaFgzZFJlYmtj?=
 =?utf-8?B?ekE0TVd6UGlSc3J0T0FSRjZyYTVmZldoeVh4TlIvQ1kyWk4ybTZCY09EdW1M?=
 =?utf-8?B?K2xlTHNJdGhtUzNCYTRpNjBwN21tTjd1RlVKc09sQkdiQzd6ZzV6TkpMaDR6?=
 =?utf-8?B?SktwV3RPYjk2c09PK2NWejduZ3VWM2RUOTNrTmtsc2NtSVcwRlVIZUpxV3FY?=
 =?utf-8?B?bE1TM3FKR1IwazFZRWJQSzc3THlTV1E5S3RRNnc0bUpVREo0YndidnU3RGx4?=
 =?utf-8?B?bE1IZmRsQzUxTStmaGg1cEY3VlpTTWhaMUplcGpCaHh1aXAxck9RSGcvY1FP?=
 =?utf-8?B?bUd4TW12eHVxWCtFYzBibDVEbEhmUFNCakNXNkdIZlNQTi9WSmRROXNhODBP?=
 =?utf-8?B?WVY5c1FrVUhmczJVYkZ4eDBySzJxQ3IvOTY3RFgra1JUWjhsbVVsR2lCdjJz?=
 =?utf-8?B?SVRGYUwvN1gzQ2VUTDY5dFU1bGJONWNRY2U4Q0dxU3RVWHFYOWtuRFdnbnVJ?=
 =?utf-8?B?UVBuMHJkakdtemZDUzFOWHQvS2dyV1dOYkdqdTNxenVYcEJGdVhPbjUyOEMz?=
 =?utf-8?B?bHhhbDMrc0N4bFBvcWsvanBEQmpFUmtHbm92eUEycVl1QXFuMnFOR2dRVWxp?=
 =?utf-8?B?SEQ3VmhrYTJ5UHUrSnBlcnRvK0NYUjY5bDZqYWNLV3pwZDQvUkxXVHZsMVlh?=
 =?utf-8?B?NjhFYkFTYUtKN3p0R3I3VGFNMWY5cWNleEFuYjlwS3EyWFJZUE9pakNxLyta?=
 =?utf-8?B?WUNJcFZKeDlOUGdocVpjQWxPNnJGbjJ1TGZGdkpMckNtWE9XY3B3Rm9UdGI1?=
 =?utf-8?B?aWJjUmtZSzlBU0JVdUN4c01Ray84cG00VlFtcXFuc3ExNTlDUktGV3RGK1Zp?=
 =?utf-8?B?cFdCZGVJK0ZXaHpXaTVKRTBTejJkeTEwSTV0b29MYmlBbUM0TXFkV1VSb1RV?=
 =?utf-8?B?N2lBMFlpTzN6MzU0Y2VMdFQxK3lUWW9NTC9uVG9FU0dEZ2NFUDBEYXp6YTF4?=
 =?utf-8?B?aTBoNHlPOHNMY2VhV2hPVU5oVGZPajNsdW9QalkwaHdOZGUyM2hoREwweFpC?=
 =?utf-8?B?bSsydWJmQ3BuaHJxN0x4UlVZek9lZEY5eXoyNjhiaisrKzNKU21MSlpxTHYx?=
 =?utf-8?B?UFJFRmZkNmxnZENrVVVIcDhtbUErY1Q0UWRvYWMxVTM3amdvZ01aNzcxdHEz?=
 =?utf-8?B?K3dOVHpRNStJR09yd2hwN1N5SWJtTFA3WS9aWFBHbnRVcjdpZE5rZFdMb3R4?=
 =?utf-8?B?bkdUZXlkU29lL0J1US81UEhha1l1YjJsY3dPVjlzQ0xYV2N3djdwb3FucmdW?=
 =?utf-8?B?OFB2VG5LdUlpdk4rM2VoUCtaRk9lUXcxdjliTktZeFhVdEJwSWtNY0UvREoz?=
 =?utf-8?B?ZTdkbDZ5cmo3enRrbStMNVIyejRLWG02dHdNc1lQTExnRnpjRVJwaHErQlpE?=
 =?utf-8?B?ZjQ3eEQvbGhWZisra29PV2Q0aXE4QVBzSDFQUkVoVFB1NUNBMjJmdXVjKzlU?=
 =?utf-8?Q?gEj+xEffeOm/H9nPciPHKCJRcQVUk5xl71kZO?=
X-Exchange-RoutingPolicyChecked:
	l2YoXhOfxalp6Kc4MSt7S7NoTtAiL/lafuYDzsm2q+4pS+/9O2cMfHL0z9rVuRm111//PeTk1IOiL+u02BCXijJA931DPHPSj+xpb4MYUFyHJSimM5taAFFsaIfkUFLzPm2JszswW9NVYL7+is66Mu15dDr1fN77Ufqn03/IbC6VMs6qo/Ri5aR7q3g9PmijkJBUgZeqrkBbtgSkqJXQfd8503wqPHwEy7wdMvSi0dDbJbIZv9h/YrktpsVqtm01rM+M+GaJ3GB65eK+u5Nmg57NcvLy6gZ3OxoUA/KhGgfABvP86tBhUx9mK2noH64xOjwFEuokqVDwtak0xSkACQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pz4kqSvxfyH7ZG6wU5EfsPGMHwAvAqCugWoc7rODWLnPANquaAFIVNolM4662+QukACUHmVCYQe2ieB+CMVISVKurCqDeQz+WHzLuY0r/rZSQUOi1GF1osIwf1tvHyxylA9cHwSd+/ScvBR277ITHviQeO8AFH3cZnANDfyx5WCffSprsX6S8R8x9y8mZ6eoJlFJHPzaSN+PTdKr6B+sp1/2tts2CQ86YDVN9J02S60+oeVmOrgZUQul2YacT7xWVA9qP3+BrUuF4Ut4cdJb7KUzk8+2l8Oh+AnYB8fkziVf+Ty+IiXrkKTQjjcm2Ia5ojW7MiLbI03wy8KBrN5IV4/nMtiHldmown3PAK7v1fd8AWvU5Fz2icc+NhzhsGyWaaCumk9ugdKGSTZEUTfI8mjsj5PwzeJLU8ge89WNqo2QXqW+OUSKUX9lhgMgRubJdzJLlx5YxL7mqYEbG4ZlyRW9cvawco2cHw5dCvbTLW2owl5AHhgLnFA9yea75Q2BpIot5qrPjvzUD8LB+r/IfdTWb0HyYpUIBk6+7kG51bruLuzJQzVuzhc5PRA/mOt/fQwWPahMV/PmtjPebOKe1Imup+gTcg7DoSihaa5PO7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e76375-17db-44eb-8780-08df2a3cb9d1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:47:21.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zl7ALDtbUJcEkAQzpa/xnX8nUFUtdE5LT5PQzTMvm+wQeNoHdGbxla6woqpbHgEZt7P/qEmN7ptwfs6LVNNLurPrBTNcgYVYgT46OOK7qcelR1t75jMXwVXyR27688Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610140085
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acff86f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=iox4zFpeAAAA:8
 a=VwQbUJbxAAAA:8 a=EwYY8IP0Y71ONo3OzC8A:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfXyXQRKjS0SRRB
 jZ3ttVmcg3m5P446t0ugFoGEntHnFjg/FF2/1eWxpV+tsidNt9vSM/+3q/Ou1glS4f7q5SO9OkX
 u9mVwEjmH8Qbd7bKAD7CVWLIBTpOsLi1XUviLXDtyrhYCTZDl9YRnnOB+q36S7xgUEqDi5pYYDU
 A2Z2F9uUKa2s/4lOTMNvMtdiARBndLcEp8DlatGVS2yZLnp70yrvh2dwW/vPWXOHggQ84Kcf212
 BuGKRbzy9iAoz22NDrorKKk5rgg9r29FSizAAFlAnUo5CzR58JAAucWZ8A+73BDNdZE+EANsTsS
 ATgssOIbp2bxlpybTkVgm7lESdgZWMAjgWIjx9rxmzqvuaktY6DYdh+z+8zE3ztXy6t9svkaLoM
 xJ/lIojpfXBmwWqwkVPWUJbJbll0whCIVT/yVqxd+auK1BsxSuNRJhZOfZc8e0hr0yLRVRh99vT
 lrbTJ+iKQTSvqFsUxUw==
X-Proofpoint-ORIG-GUID: dQheKoJzlKGVSV4Kc-STa9vVuk1UUD5C
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfXzy5FyflISO+k
 j8YsAs+NxhrqeltMI8Odl4+glZaCXIGB+Hke563bIzP9HuWy6jmxaGvzW30ngdeCnSpmOEwyqmQ
 NgpJ4O6FlWLnR67JETidjk1eu8hy3KByRgbMpSyczCR2vputx3Ee
X-Proofpoint-GUID: dQheKoJzlKGVSV4Kc-STa9vVuk1UUD5C

Hi Greg/Sasha,

On 13/10/26 5:10 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Filipe Manana <fdmanana@suse.com>
> 
> [ Upstream commit 41c8899d59898f6fa51ceebd2b6e55257191a8ee ]
> 
> If the input buffer does not have enough space to store the current xattr,
> we set 'iter_ret' to -ERANGE and then do "break", but that only exits the
> while loop over the xattrs in the current btrfs_dir_item, and then we
> continue the btrfs_for_each_slot() iteration, which overwrites the value
> of 'iter_ret' causing us to lose the error return value and proceed as if
> the buffer has enough space.
> 
> Fix this by returning -ERANGE directly (the path is automatically freed)
> instead of breaking from the while loop.
> 
> Fixes: 184b3d190087 ("btrfs: use btrfs_for_each_slot in btrfs_listxattr")
> Assisted-by: LLM (found the bug)
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/btrfs/xattr.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index a7700083bdbd3..ff218e8ec0ca4 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -344,10 +344,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
>   			if (!size)
>   				goto next;
>   
> -			if (!buffer || (name_len + 1) > size_left) {
> -			        iter_ret = -ERANGE;
> -				break;
> -			}
> +			if (!buffer || (name_len + 1) > size_left)
> +				return -ERANGE;
>   
Hi Greg/Sasha,

An AI-assisted backport review identified an unreleased Btrfs path in
6.12.113-rc1 patch 464.

fs/btrfs/xattr.c:btrfs_listxattr()
Downstream:

     struct btrfs_path *path;
     /* ... */
     if (!buffer || (name_len + 1) > size_left)
         return -ERANGE;

Upstream 41c8899d5989:

     BTRFS_PATH_AUTO_FREE(path);
     /* ... */
     if (!buffer || (name_len + 1) > size_left)
         return -ERANGE;

A nonzero buffer too small for an xattr reaches this return with the
current leaf still read-locked. Downstream skips btrfs_free_path(),
leaking the allocation, extent-buffer references and lock; a writer
needing that leaf can then block. The parent reached explicit cleanup.
Upstream already had automatic cleanup through 7fc35cc559cb
("btrfs: more trivial BTRFS_PATH_AUTO_FREE conversions");

Should we fix this inplace or drop this for now?

thanks,
Harhsit

>   			read_extent_buffer(leaf, buffer, name_ptr, name_len);
>   			buffer[name_len] = '\0';

