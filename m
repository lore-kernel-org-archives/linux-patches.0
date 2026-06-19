Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9844E40D579
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 05:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781846953; cv=fail; b=XfqDhOlCtuMpErobTEVhVn+aVpxjvF8zcCqQIHGH8y3E0c3yV32ZMYcE9pGBKKJmreVVOR3HJxu/UbAg4oyJcQTAFiEdzxBk/eBtKkfkVmFp2+YcoI9zrzW6ZqN8FAkIwUcbyA9b/JAznrKqp1sCnVs8Gk60R6eoEN78WGZHp10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781846953; c=relaxed/simple;
	bh=WTZ5DCKeE8cTZqy66DJgI1vBT9hMsMCGSUH1+qDUab0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hil9JXf4+eH+3nGArLPwcxSNkCpumLvB5aX977rrxruR1vbkT7MwuJnPGjjUmmorZSCEq7hudghL//gM4skC1uxgtUuTnsTTEkJfmjHMEw3pqPqhamDN3QoA4Cw5qvGzLAfZYTLFVIkC9p96ifYmfET7QAOlZGUGz6muJO/qSlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mgb03cH9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZSZCNNfw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mgb03cH9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZSZCNNfw"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ILVE9i1488179;
	Fri, 19 Jun 2026 05:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E0Itq81i/LHyWNSzb6OYIoWx0urKhRFA0PjasPensyo=; b=
	Mgb03cH9rz+238X4fO3LOVuuxkoey91AxwbZjaMrY8bd+rCQ3tt1V+p4qb7OdabE
	I4zfnFO02AbyDX/vfe1GR5A3J4pj6b2QN+mvSWxGIxNc4EPgOG/ZwHl47nxpRz/9
	1fGlWTaI6AAXs1YxfgvSYDOBJSHHjwjeRRCEAPAL0UxwRnyW9d0QImuCBxF+vOkY
	+vOopmhDDR8u5r273aih65KTZGooNDPJnx7W246+ar01UPqDd0DQgrFbzmkpjWdi
	TWCsdZiq2o4KcOZYE/ZTxRrHV1pFpMUJxDx+5fyj1xDoxQ2VyKslt8Zffzbap+K7
	xAQY1IstROKaUypKiVkLkQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euefuuq31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 05:29:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65J5SWpc017330;
	Fri, 19 Jun 2026 05:29:06 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14v0578-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 05:29:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ak4kwTounlnACQEubadH0c7ekpoofBkznz1azoJHqlxXWfV85ERP9JVuG8P6UucymL2pECofA/mv09qt2SvkgO6CYdEA7CXy1usMnLqXbliFlCyzULLDpKlibaQK8tFz5MeFuCmPiApSBH/00gObGFU4196puBjhppe32gcUUc4YZ9FyIezD5VlGUhe0Pcrk7BMFXRnTRml7UGQbt5lewyV+mmbC1zkUPvPrC7PxST86U3IUpJg6KS417Zr18w/ULF48pH22bJ5rClma+bHWRv0Owo0Yictcf7Tv/sPGmSlz3okeQOZHaIFPW3/cxX1SIOu2nCVEBVuTbkfrRAhsTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0Itq81i/LHyWNSzb6OYIoWx0urKhRFA0PjasPensyo=;
 b=umolQrQCqD+cCSuvBdI7sDoVUvCL1ku02Y0LBH/qsQLl2WT8OgN3J4zuhl4SW9S7eU7nFVUUSf2YmaVXL44KeATxHvDP2dOGVC4DWriTqXLxo5eeByMpij/0+akhnCyv4t+2UG1Hbo9Yw1hOoI3BfVTN+czrFVyXQEcV7zVVjnGnLT+thpIJf07aDNomeTzIvAC0KVDM+lol0w8burYTueTWiSO2HmuoTiLFeEguoSUDmzzj+jOHR3qn7St+kmU4lvnk2lJk2Sf7bMzdd5NCArhvlT/dpm6Is74+CFAjiKmIw4YrGVpJmDkNeMvh0jAt9HMM9xueJ61530BfmKoWVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0Itq81i/LHyWNSzb6OYIoWx0urKhRFA0PjasPensyo=;
 b=ZSZCNNfwp1VoWMmdd+SInIDCySVxXoho4i2Yy534u/D35g6vCYdSieZZ7FTAqly0cuEkb2vOhJuIso4ceKbLLh5C+SZHVA2GSgDFKSztL/xrfYU86vC+A6r/C71V+8iLLVZCms4laG1CDX39WAcMV91KHUQlJgXyYIs7USsQoDI=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 05:29:02 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 05:29:02 +0000
Message-ID: <167562b4-4472-4ead-a107-6eb83275825c@oracle.com>
Date: Fri, 19 Jun 2026 10:58:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 193/411] netfilter: nf_log: validate MAC header was
 set before dumping it
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Weiming Shi <bestswngs@gmail.com>,
        Xiang Mei <xmei5@asu.edu>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145110.984893387@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145110.984893387@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1PR07CA0021.namprd07.prod.outlook.com
 (2603:10b6:8:44d::8) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 97cf06da-bd0e-46c8-06af-08decdc3abd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|6133799003|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mP23aIV3wHR/NCt+pHBv2MawER/xVYa0Paj5WhOy+ZrfwFcOJQzgM3MR6NsPdHjw+e/iz9MzIa1iqDF/oKc9EozzL2LfQ3ymCYF7L71SX+AE+az3sr5IvN7gPNwekt20jS9TS6UAbOm73584HorxNbOGlZ4Z9mipfHhfa5kZFHPuwW49aqWCqQT63U66812dgVboDLNwODOOGsyyl6F9E+K4jVxBiIl7/cElvzH6Z6W2+U6XokT+dJKgarP70U0pehSNuria1Ekxnj3A+Nn40DBPCmcW/ZyXyjkN+mWR/BDcvw61SIaf+rko81ZyGmmDUjjX+UJ7rnsRUEwaT4o4plu4boLggivOJ6p+g+sZpDfdAb5Fm+wLsq6hEboGA/5Cf3CryFQSzlX4GUG9p4sI0auc1foXG/p46f+swq3evMHhwtcckkdx/ybbNKfkvXjU3ihrG+fnky5NTnz7+yC7BQU00jKWmIEcSxkwIHCoVs70rguq8REZAmapD2GulMj7HLyaWBsGXIoFH7TBfiKyWpIhtqZubQiUQ6edSpjJiCjUHm50EOXnNXFTUUGRsxC/nHzjNX7RHFnCBEXfOJ/79syDgRpBv4SKqHZ0/B70hT3HtkuobHbVggF926muynQYHpzTHN1GU9Y90G4ajY9OSkt9G02AC/TLYNuXFMDChfw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(6133799003)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFNiMTZUajlmTDZhSEk5QkN5TllVU1dmbWJzdGRyZHZYV2kvZVFVZkVlMXlJ?=
 =?utf-8?B?TCsxeVNCZFpiaGRGNEV6cXlTNG41UGZNeWZTd0FvNVlzNWFPOHdCMjhHYlgv?=
 =?utf-8?B?VFp5aDhOMTBxOUVBdEZYOG1UYW9NcWJuTFFWMGJWS01FaFl6Zk5wbTRvTlA1?=
 =?utf-8?B?eXdnT0YxQ05tRmgxWTRjS2g4bFVSY2ZMQ0NEZWVtVE5sUzBtWm1JeSt2aG9K?=
 =?utf-8?B?ZzNwZFhYUVJJU3RrRWFza2ZadDFWRHFxUE9RVEN2Ty9FYlZRMUhmVkFyUzFk?=
 =?utf-8?B?WWozbzlQWW5WekJyVUFPVFlLQkZieVVzUTBHYTh2M0ZyWFFHQVZKTGF2d2VI?=
 =?utf-8?B?Rng2REtUNy9IYnVLNWVmMGhaYTN1RmRQN09VM25HZjh6aURxcHIvdmZTRU5p?=
 =?utf-8?B?Y1NMK1ZzTjYzUzdkN1Ywdjl5UG5LcEFrMi82QkFsYzNZem8zMllmbUg5VU01?=
 =?utf-8?B?ZWVWbmNNWFZhZEFIY2J1MitJM0FqblNTeUt6bjk1NzdadmUrWnVBTWk4Uzl3?=
 =?utf-8?B?Q3JJU1p3KzBiK29Vd2VtSXBGZnJ1RmV2T3NPZFBNTzd2MUZSeWdMZnFoQ29z?=
 =?utf-8?B?NWVRRnNGcG1pdVdpM0Y1QUdqK0RCcUVmaXRrUFZ5c0tFZTVyYzBQenRLWjJF?=
 =?utf-8?B?T3dJWkhtV3NpeWVHeDNrdytGRjYrZTlMenZQOU9naTkybmtsNEwzd2FoNTNu?=
 =?utf-8?B?VFFRSVJkMWlqT3RFdXY4M1h3Rkp4T3lGTTNydTNBTFQvclljWU43VU9YZ1c5?=
 =?utf-8?B?ZUt4RDBxZGU3S3pNemptM0xjejZ5ck1taldYYys1Zlhqb1NHdzJHY2hydDN3?=
 =?utf-8?B?YjJQNDBvSkhjV1Rxd24xeTNVNFZlMnRLUFEwekJnN0s5MS9UZ2F0dzRKN3Qy?=
 =?utf-8?B?Rzk1MWhJQ0hZVjlMRWZ4Q0pjVU5sVHc1UzNTaHhEVlNzOG1aekwrdkdhVDQv?=
 =?utf-8?B?M2hiMEd1SFlGVFIxbEJmdUEwZUlEQitZQ2lGZnRkZ2dSd1E5MmN4ajFRdFh0?=
 =?utf-8?B?U2xwSWV6Rnc0bVc0QkJjNWx3anB4NElKam5CYTYyWTB5cGZEZm14SUNpL09M?=
 =?utf-8?B?eXhYbTArS09lVFdPV2ZsSEh5VVpPbUNBTkRlTXF1L24zQ3BGR2Z3cGFpTm1G?=
 =?utf-8?B?d1VKQjFPMWpHWW1GNDlSTDNvc0tnMkhpQWhSRXdDRGV6bnlRREQzOWFBblUr?=
 =?utf-8?B?ZnFDRWRhKysyZGhHUFduUE5jYTFMbTlLSWpjQWFpYit1dHVVWCtZQ1FIOHYy?=
 =?utf-8?B?Mi95UTd4MXdMY2RIK05XWmJVeS9RUllVaE5TTzVuNEg5OFRMeTlENEhKTDZz?=
 =?utf-8?B?OGc0Q2dUYWlyTXVnZ3hNVUlCVTZOZjFRUHVxQ2xrK052eWcvL3ZWQVltd2Mr?=
 =?utf-8?B?OGE3cmhEeE5FeGF6Q2lKOVI5T2FWZDV2VlY5N3M0L09SSlZWcXM1TW1oUXBU?=
 =?utf-8?B?S1JiNXRTUWROdHUrRjVGb3JzWTFXd3BrL3Y5WFZsa0tYOWtlY2xSM29SMXYx?=
 =?utf-8?B?VVhjNDRLUG9NOXZURW9wNHh0SFpIWGNVbHhQdExsOVZPR0dVcytxZGhvTWZi?=
 =?utf-8?B?bkhpR2grVmZUU29mYnMrRVlWWmRpbEhFWUV0NVRIUklnNURQcnN2SFRiSmg3?=
 =?utf-8?B?ZW0rYzZXeWNiSTNzWHBxV0JQbkRyL3hhdHhLeE1MWVROY3FZREMyVy9hOXF3?=
 =?utf-8?B?c1FyRXRtNUh4blA1ZFdBUDJ0U0JXdkxBY0psVFhLQ0lmcHRqWGpvWWVyUHBU?=
 =?utf-8?B?QW5CbU1FdUZ0ODE2YmZoUjA2ZyswRktmUFFiVGR1YnRnYUd1K25YeGhNbUx1?=
 =?utf-8?B?ak9Xejhxdi9DSG9ncE9jKzVhTWh0alZUU1pzY0tpaktDT1BEYW5ldEZSdEt3?=
 =?utf-8?B?bHR6VUpteTlmUkQzZHYzVU45QkJxOGVNMEpMbUdwSVFKMkQyd3ZNZlRYWHVF?=
 =?utf-8?B?ekdOZmtiYnFPbWR3a0hIQ1IzT3owSzBNd2JiQVdHMTRUVWFObEdQWTBMNFhw?=
 =?utf-8?B?bTBBUVR2LzZZSTBENVBnQjFraXVaSnhnUCtuRWR2cWx2UlhhYkp0bldRYm8v?=
 =?utf-8?B?bzZIS281WHhNUGhTK0w2YUFndTlxbC90N25HOWYxVkd2RnZJT09TaStYc01C?=
 =?utf-8?B?cXJLWU1zc2x5Mm12VlJUd0tIblZiVGM3TjJLRnd2cW8yUWIrYjhZYnNFMlor?=
 =?utf-8?B?ZE9yenN6WVZ2TUE1aW9uS1hTeG9TQUc1NTk4ckxzdjFpN25jTmRrN2xjU1Nu?=
 =?utf-8?B?Sm53WFBCcVdoZjV4QjU0am10engwSjBHT0RubktIM2pIbEFmaXBnN0dLUXBQ?=
 =?utf-8?B?WUIrTnhBeTJFNUZtVmtpTGhGZTU3a2s4V3J0T0tOMUpuaWVFeHFCdkxkYTlr?=
 =?utf-8?Q?9DHUCHT6ToQG2Q6ji3IQAYqSu620yDkqnqhOj?=
X-Exchange-RoutingPolicyChecked:
	sq+K+NSmMF0gYtwhE8MtnXUSDZeOZ2TNk6TgEMv+mFshQ51+YzL3+aLXyAXy1mb4k1YeqwnMBburlkiSP8T3KFloQNFrGtXRdaXpZ40lmFtAoZrM1erjhdmDTTqEJUGAX1u1MpU63eac03ed81nozLekqyK8Lm/m+LCUCyVpl56INjdLHoGOV9ZCwGIEL+YTPAE2/tYZ+AxEeL3Kydr9097zUZ/8DDCQIPzEEIrAqjgWnPdkQV60RWuE7hOos66izoaDQBxMpHv+eeQaA/ufk01lDsH9pYA6RMvKGvrfi3xSxm4Kw4bSgcD6Le4+1I1MJWvV8hRApC27v+bpCIo/Vg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	clHsc7vlqt+G7rIFXVJRaRI+8/EK1swgPC6olhVV4vwOSaeVq6BiZXqAQt7w7OeL04ppAEi/i5bXPVCasHdYtd4jEHZfIl87ALNuCUsGFYeWZOraPFf9LiAIs7XQL36fg3l+tYC2/AVREXpd3V6uJTjzMiEB0j5PA+1ngl3I5XTRaON8srFDqtGhDQIIpJOLC0PvG17eeqo/6oPGo7jnzcyLUp4UHecfocXAmjnYNvrjkAsQ6MgFFwH/V8svA4rRsd6bsgEUvxSEU5CSGKoErWt/fHznuYr3gFNW3+MmxtskaOn3cXmS5nw+2d1PQUuIfpfkkSGlwsVRUWPJ4ftMpMvn9zcbWgVHvLD+f80ksd6pInVet7LEwLsmoyyk2+63XGskOiOItKmJo32WtkKDNOQHNTvCBUgrveMXzxYFF8+XE9Bw5ln3Tgib8jJsK0A/A1IM/GfhoxZlVaK8tLZdlyQzqdVFDK4bjk5PzOiMBQlpB7CMmdvZWSWKHaR6BziBg5WtM6hFTGeWA+c6dgGV8lDOZpB2c4cz7HzoLp6qhBpnPvdQcd50B0KUST2LrxTGYg1EsyCZRjQ9FfH8ChMCENHsNlv/SwJv9v7jSl+8VCg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cf06da-bd0e-46c8-06af-08decdc3abd4
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 05:29:01.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKvlY8f1nJ899aSrJ5Y3zo3XxXH/+EDmWlVlraA8QgJ13pri43Bo7+AfVHqFB1kaoK6yyV2H5xtzBlGo4TlAHqzAvjHADdURlAtWR6PkzMh8sKaASAF4+1qBZ093xHz/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606190047
X-Authority-Analysis: v=2.4 cv=faedDUQF c=1 sm=1 tr=0 ts=6a34d3a2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=pGLkceISAAAA:8
 a=3HDBlxybAAAA:8 a=VwQbUJbxAAAA:8 a=Byp2yE1-I9CVAFmHnfwA:9 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10 a=laEoCiVfU_Unz3mSdgXN:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-GUID: IrV8CCKEAYvU8-q6BU9uR92UwGn9eM87
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDA0NyBTYWx0ZWRfXzfi2ZAbHQqZr
 +vB2ZKpHh/fregkCni5CMO3q05U46YWDLVE4sEgViamzlaM1o45DRNpD0w9T5tBinJfNe7SKX3j
 yeQd6De7NBwBpx3Pc7TTRhUQMXmv/l01BhbvWZCdgjOPDKTO+VWR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDA0NyBTYWx0ZWRfXyp9BPotX7/kq
 +dfv/HJ/o2XdLBQqpVt1Lo3BZ5uRy+RURe+didPnzkwWdfo4okGZx5Mjv3nPz5aVRZIgba9YnTC
 Pexk8FTAz9tTSQM9hl05dIfgib53Hsaz1vtOGYWpKD9Rqn09wSkknXJOqCPJVj8zN6hnn3jr+Yl
 W5O7k+hjqluQsTnxIavvK9FDOLdw41GjQ9QCPOLkb3eXa6rPCYgwwVa/PrXzFFVPpYjGMRLe3cn
 14UQRq/6wcSWJoL1gBTTH8JbFDQo+qIFfa5g+ynqkYwVCUCiXpw87TycK3m7QfqTp6mEwSER1gJ
 /ttqvvO8/q+se7YfEa/A1IoaWbH7lbGltIr6CBlo1zlQZ6tasF4FogkZw3jt3TN4BgRZWX7vi+i
 qkF/pVPiE4P9LcOZnzrcUzKBqtcA0i22n5gPj3M4DbkPEn1FXteyYK8Qg+QT+mN98wsEnjdX/oi
 jUm13fCeRwLkD/ZetpSMe81wJdw1lx34HNrtKc50=
X-Proofpoint-ORIG-GUID: IrV8CCKEAYvU8-q6BU9uR92UwGn9eM87

Hi Greg/Sasha,


On 16/06/26 20:27, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Xiang Mei <xmei5@asu.edu>
> 
> [ Upstream commit a84b6fedbc97078788be78dbdd7517d143ad1a77 ]
> 
> The fallback path of dump_mac_header() guards the MAC header access
> only with "skb->mac_header != skb->network_header", without checking
> skb_mac_header_was_set(). When the MAC header is unset, mac_header is
> 0xffff, so the test passes and skb_mac_header(skb) returns
> skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> dev->hard_header_len bytes out of bounds into the kernel log.
> 
> This is reachable via the netdev logger: nf_log_unknown_packet() calls
> dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> unset (__dev_queue_xmit(), which would reset it, is bypassed).
> 
> Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> uses, and replace the open-coded MAC header length test with
> skb_mac_header_len(). Only skbs with an unset MAC header are affected;
> valid ones are dumped as before.
> 
>   BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
>   Read of size 1 at addr ffff88800ea49d3f by task exploit/148
>   Call Trace:
>    kasan_report (mm/kasan/report.c:595)
>    dump_mac_header (net/netfilter/nf_log_syslog.c:831)
>    nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
>    nf_log_packet (net/netfilter/nf_log.c:260)
>    nft_log_eval (net/netfilter/nft_log.c:60)
>    nft_do_chain (net/netfilter/nf_tables_core.c:285)
>    nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
>    nf_hook_slow (net/netfilter/core.c:619)
>    nf_hook_direct_egress (net/packet/af_packet.c:257)
>    packet_xmit (net/packet/af_packet.c:280)
>    packet_sendmsg (net/packet/af_packet.c:3114)
>    __sys_sendto (net/socket.c:2265)
> 
> Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


I ran an AI assisted backport review over the 5.15.210 queue, and thr 
report looks valid to me:

this 5.15.y backport fixed the IPv4 split helper but missed the 
equivalent IPv6 helper.

So we would need a 5.15.y backport slightly deviate from upstream patch.

Upstream a84b6fedbc97 uses this guard before dumping fallback MAC bytes:

         if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
             skb_mac_header_len(skb) != 0) {
                 const unsigned char *p = skb_mac_header(skb);

The 5.15.y IPv4 helper has that guard, but final 5.15.y still has this 
in dump_ipv6_mac_header():

         if (dev->hard_header_len &&
             skb->mac_header != skb->network_header) {
                 const unsigned char *p = skb_mac_header(skb);

Upstream has one shared helper, so the new guard covers both IPv4 and 
IPv6. 5.15.y still has split helpers, and the backport mapped the fix 
only to the IPv4 side. The IPv6 netdev logging path can therefore still 
call skb_mac_header(skb) after the old unsafe fallback predicate.

I think 5.15.y needs the same skb_mac_header_was_set() /
skb_mac_header_len() guard added to dump_ipv6_mac_header(), thoughts?

And this is because 5.15.y doesn't have commit: 39ab798fc14d 
("netfilter: nf_log_syslog: Merge MAC header dumpers") so we need a 
similar adaption in 5.15.y

I am still thinking having a TODO for these sorts of things might be 
worth it, particularly because we will miss these easily where upstream 
commit is backported(so nothing to backport from a git perspective) but 
that doesn't fit downstream perfectly(so more work to do). Btw, its just 
a thought :)

Thanks,
Harshit

> ---
>   net/netfilter/nf_log_syslog.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 7000e069bc0760..2b0edb22ba511b 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -793,8 +793,8 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
>   
>   fallback:
>   	nf_log_buf_add(m, "MAC=");
> -	if (dev->hard_header_len &&
> -	    skb->mac_header != skb->network_header) {
> +	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
> +	    skb_mac_header_len(skb) != 0) {
>   		const unsigned char *p = skb_mac_header(skb);
>   		unsigned int i;
>   

