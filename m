Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28CA3DB627
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780328370; cv=fail; b=Fta2QD0jGP/27IpjBmADbyuFYwV7ZCO3+d6dTRpZAGQepPeWp01OW7nSRg5qSh5sU8XondWhH4jPGoLxofmopBgD0MnBIxCKOlsJTnfwmX9xpYwgm2mQAFiIdTlhSCpD8/XcjVTzWvDrD6xRg6l2nqG9Q057aR/AI5hXgeDxVtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780328370; c=relaxed/simple;
	bh=bj5/lUvFBJAwoEr+pRuZqjCwc5At2MfgAaCarCP02qs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i54zdHRigVhBhBaB4PJaMHefjghMYyGecvKA/0PvZlBqzWo9LnMbzt7mmaWauNayxUwkE/SRtIFst5XVLF6IVJT6q7OoH51xRF6pPqLgxkrsjBGlYOWetprffmiBE19t8tjannu72Ujg50+pQsko7fHm5DuiMer/4qKyTIsx5+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HVr5kbON; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BwA6Ro3o; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HVr5kbON";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BwA6Ro3o"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651EtkZj732067;
	Mon, 1 Jun 2026 15:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W6u0z8kXoJduSYRoLqa1NX1RsmiP17VkPHq79Zvj7VQ=; b=
	HVr5kbONp3OvJlyKNJGPtg0cJjRg0V99Mx4PPGbCDC2cwpeCQob6Od/SkFpP3Oya
	jx+LpDGIjRg18SU5mNKaaCeMgpvp95WE/RXe6G3fCvjRvZzAF7nOjYiAqdJWT/ZR
	vjjSRlEh2lGEe8izfc5sn/v9sXChTXlZxBRL6hhq00ZSffxG6tGgb9rZzh44gG3L
	WaW4EJPiJMU79Fa0LhNTThQpQ93wX2to1aMRR9sBsmOsMgDfCFTB221uMN/WQHJM
	VfS6rMUKQUz06vWkft48zX8TKCLdw2if1mEJkJRu3FgOHSGGpu31kqhjzCZIQYw3
	xiE7j8cA4EAAyaYKQM46jg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqgrtegf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 15:39:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 651FYwGm033882;
	Mon, 1 Jun 2026 15:39:19 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012030.outbound.protection.outlook.com [40.107.209.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc0scr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 15:39:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O+Gm+uS8+hTNd6HaOXPdIIMKLBi9huSagDNrOnyICilmElNac9WVV6f/Ir1kNM72lxlo4ge89VGYuYa6Z9NvDufcXQudBHu8MjMgM4s6tBDEWalgdIftYQfDpHvQRTDkV2dAODu4edVxiif91HDXYc52K0qOZujMgHK1Fxu1T1pcw1zJ4iITOVSLYzfu/JI8QlYj/8dGyOzkxtNGGAgh8EY0fNxqb2UNHTe3zA5BB3B849LpaJd1OCp8zfdTazrR1dIpf4duwgzkzHh0BR5wuQAVW4+nuvVC2/WUGK3xznY9K6SGqtb8rXF7b8CnjPczMkyOc9W9J6/KWshA9Z5vZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6u0z8kXoJduSYRoLqa1NX1RsmiP17VkPHq79Zvj7VQ=;
 b=sgHGp7BzbAQolZgCSK6aapx1FifHPwESGix2FI9jTndo/QplqT4/4VIFRT3yzkxoCJMz5GwceeDkh9678bwymmDXATEDlG0U3id6M2fMKMSow4PwkLCjV+coekCpN5a7t7KcQ4kqkWTpk9bvDPxuBI8Ri8RQPVnOUECVxwT/9nwuWEKnXTM74a66r8tyTDogBlUH9m3urKLyZqj5RAa1RSWA1iJxY3Pc4qQNvfw7eglyEcSPe092KTOkFXb+guyLg9MElLWBRO0sQsC686n3bUm7ybTvvxj7/RblIUXxVNJG1nuLEtybSSpO9CQDmOqqqJ33wbMJEL0lspM0GAh5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6u0z8kXoJduSYRoLqa1NX1RsmiP17VkPHq79Zvj7VQ=;
 b=BwA6Ro3oA1Ct8wL9SKtH0hOdk0oRwmb2NxzpbqWTbHUvYfiArT2f59dqrfswL4aKhroWLjujCVqqWc01osLCDDtEEw+2oGzUS8JQM3fbX+59bNuRCDh2QdwfzaWG00jj2fNrMLuRNKFN9WlDU2lEVLF03Zz8uqSustLzIvRJiXQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BL3PR10MB6066.namprd10.prod.outlook.com (2603:10b6:208:3b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 15:39:16 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 15:39:16 +0000
Message-ID: <1da626d0-1335-4306-a0fa-a26a0a36248b@oracle.com>
Date: Mon, 1 Jun 2026 21:09:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 170/272] netfilter: x_tables: add and use
 xtables_unregister_table_exit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tristan Madani <tristan@talencesecurity.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194634.080823144@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260528194634.080823144@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0004.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:26::8) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BL3PR10MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: 69dd86c9-47e3-4100-35e4-08debff3f03d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|4143699003|5023799004|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	nkyRPTa9H3gzCSqN3bziAsjCowWi4YG+T2WLKmaEAdDkO/8Kf79zdoeETMkwLDv56COOGStgwQQkYVDdg2MW14e+P6OIFGQE0bJrueHOi+YgyGQLLUTm84smpc5thsKW5qDyLQCdzKZK1cbT5m4bTthurcMPK8Lz1jdImug2LD8YrpRhTctWVlph4i8He0rwrPUZNmT+lBm2rvcxnIRMxBDWU9z4SqPRD7JsNZ13L9PlwhxImCBvltA4UOZS9CsFZoqejHFmQoyF+su93LVD+/ssYSagCw2zs2qVNiixxbXhZPH/sAZmcYf6H9+3dqwWAdzJxd4fO03j6NaAJBmRocAYiyhOm6+GgH/G/aPZ2Of24Pap8jSuNOf53wmaNrjypYRW1rxK06pBrA4vAiGubpWBmAX6e5Igicujlkz0X0uXl5TBjffSZhktVvjRmK+Rwu97/MNo2lFpRG1ofd97rH7PhBhGZ2oSK8/amkpmAU/QxTPmzMS4HLQPKW5NGDTOhmTnJ+P5smR+0CVS7v6YUfUMZYQZu/9bc3+UAmmJ2ACdV8y3cFEZgRQ85cnAUQ4kaSCj/wOMhd2iEBGqyQ2m3FsTv0VGd93iRzYSSWByUMG2WDshfoW+/55cGvt6dDBvj0fjvSvBQfvs8fUpT+n+FLIIo+G7+X8Eh+6Dmm4eV8QuQqJvNf0hkmrY0dXRuhu8atpEoKKsGYzy2kCOGSFv7Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4143699003)(5023799004)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0dDMVQzNDc4ZEttUjVYc05qYXp5S2d0U3crZ0lXb2tkQzBacTgzVk1xdFNU?=
 =?utf-8?B?TVlBZ0luZkE4Y3dDREptOEJQMmFRdjZiaGlxS1ZlOUhBSmtIYk5kT2tHVnF5?=
 =?utf-8?B?Z2VxVTBNRVlQNy9VNHVZWWJKcmdwcTQ1NHNTdTlBQUFrVU44eS9ZSGNncTJ2?=
 =?utf-8?B?TGEzclhQZVdDTnJhWFM1cDl0NHNDUEtGSlBDM3BIQVZpamMwK2V3dHgxeFN1?=
 =?utf-8?B?QVNFWjlDTHpQTDV5alJHODFwNy9yakUxSnBTWDl3S21sRFlWNUJ3UHNiaHVv?=
 =?utf-8?B?UitUeXFROEtDSFJRMi9GUWI0akxuY0lSbjR3aDBEelYycXBRUU5nZUFSbW41?=
 =?utf-8?B?ZjQzWXdXSittS203SW9DNGxsTUpoZ0xIakdhWExYK0VLdEorTUdzMUlPL0dD?=
 =?utf-8?B?WW1DemJCNEtIUWVQdkkzcDVwTk10dzA2NnA2VVN4SmlzL2cvQnF5aTNnMnFs?=
 =?utf-8?B?WnFLL3VobFFsQkpqQ0kyMGZTSkNaR3FaMHpHRk1IQWtrRW5HZ01hYnFiWjJD?=
 =?utf-8?B?Z1htSlNQcE9wSy9jaHMzK0wwM1crY1J4S1lTRTZmTDNZaE42Y2RwWTNHTzA3?=
 =?utf-8?B?RlRiTGtWZzlENURuTWhxSm9OS3VBY2hvdVkzMWMxZ0E2b0Z4OXUranRuNzZ2?=
 =?utf-8?B?RzNzUlFudWhTUlJaZGlhaDYyOG0vMHRmZTAvN2VLNlBBTzRROTlaQ3REZWNv?=
 =?utf-8?B?Yk4rdjBaMVVJbStXMlB0end3RlpFUWR1dlZ2WDJUN2V2QXowWTc2SFY1bEdr?=
 =?utf-8?B?ZDB3ZURaL2g2b2tqbUFpNHVQQmdBUHI3OEFpeGlhN3oyNnVkWnB1VEFZUTZX?=
 =?utf-8?B?Sk44SFA5UDlxVjZ2dDFWVkxlWVF6dDZJUGFCTHdMWVJiald0dHkrcENyUmFi?=
 =?utf-8?B?L0dlL25JWUg0c1F6MUFwMkZGZkhkKzRHdEVraDkrMzAybTBXcWFmMVRWa0Y1?=
 =?utf-8?B?WjFGVlBjL09uR1pRT2JHYVBOTFlOa3JibXR1QytDckJod2pBN3JKNnJUdkhn?=
 =?utf-8?B?QmF5SFBFMC9TUnN0ZGRsU3VyNEd0YXhxZWlaMWtZUkdtV1h2VG1QdFNreFo5?=
 =?utf-8?B?aEF5OWN4RW01eUIyTUlsbVdBN09UZUVyUG82Q1h4VEQ0NnAzQWVRcklhZ1VM?=
 =?utf-8?B?djBQeXNEWWU3eUtyeDlicllNTnJYa1Rvb201alNyWVBCZlFENUttS3NjaVhS?=
 =?utf-8?B?RW5uNXdEVkgwUFdkUXFtQm5GeUd4UnR6b290cUhwTWNzWlduaCtCQ2ZRWllW?=
 =?utf-8?B?U2dQY0g0YkZ4MkVGclFkZkNHMGhJWE9KdXkwMTRqek43TGJGZGpWcDE4SjNp?=
 =?utf-8?B?NEZqTFAzRHFwU05XN3JQajRRWGZVZkQvRXpuN3pSaUNZY0NMTTNldnRpcGd0?=
 =?utf-8?B?N05xZFIyenBka3QvOVJndkJkdzdRWTRERmEzeEhRUDNoL0FYaW9HYnBVNlhh?=
 =?utf-8?B?Q2pKdE9iMThXQkR5ZmlCSWpTTUFTNDFTekU2SWV3UTBJRWlYdGNzSFRzbFZY?=
 =?utf-8?B?aVhzQ2VpYVF0YjZPb2ovRE5BTm9jaFdrNW13QndJZjdxTHZIWmVKVkxlYkpQ?=
 =?utf-8?B?MHNmWDFqN1k4eVk3TktnK2FVeVRTYVdlRjdHWFpySXJoY3lRd1lBRjV6Vm5i?=
 =?utf-8?B?Tm9kZ2VZdDhXR0lLc0RoSERWbkM4TkxrMzJzWGJRS0hRS2RudlU3dFY0NVM5?=
 =?utf-8?B?QjB0VlpqMGVWMnpxUFducE1GY2xKSnRIK1dSK1pSdjlVL2M2S3VzR25veFh5?=
 =?utf-8?B?Q1FKN3pOVmcwRE13c09zSTY1YVBzRVVpTEE4SlpmeTdLRXJUYXNVQWk5MG5G?=
 =?utf-8?B?NElOa3BhaW1xalNxOGtHSWI2bXI0UThiYmhDOXZIMFhUTmppaUVMdlF2QS9H?=
 =?utf-8?B?WUNqTktRanE5WlNKd1Mvb3JnQTB3VVk0SlFYNGpwWHR6eHFzNW4xVHlkaHZz?=
 =?utf-8?B?b3pyRzZvcmVXTFNwM2lqbEo5R2owZ0M3Rng5UDBFWnBtZTJreVJ4MTd1aTJZ?=
 =?utf-8?B?Q0J1MjR0Zkg5WTUxTDIyYnJIOXkyVTRzdkI5VEIrZmVnUkhuaFErc05RVkVj?=
 =?utf-8?B?dGFZRTY2N0JNZWxNUGVKZWlseDdKSldYSjAvRzA3WUNPTDkyNTdvWE9Oc3Vq?=
 =?utf-8?B?ZVdBcVgwSGh6WCt1QmZnRytNZmo2RFhWK1h3RlhrUmVPdjRpYUdtZWFBSk1L?=
 =?utf-8?B?ZWxhMnlidWI3SzVSSVc1QThwQjY1T2lNRVgvbWhSZzkrUXJoUFlHSUY0WXdX?=
 =?utf-8?B?RHpBN1Jtb2VrZWYrL2xtZjY3Wld2Q2pKRkdDWmRPYzJIM2RJbGRmWENqQ2N6?=
 =?utf-8?B?RFFZajdDclQ2cjV5TGQzRzllaE1qVFZzVmNqZEJ3ZWMyNVoydHBWY0N0TUta?=
 =?utf-8?Q?5zmbE1uY7g4TOZ5y7APnlDIAjKvR6LK7GLrSW?=
X-Exchange-RoutingPolicyChecked:
	Sfzgx2oHcqZxau4R/KodEgsMpguLjsDix08MdDY+NK7QERFI0oMxFg+dGfCqWh8th/BM+t3Idll3PwGzfiEdRZAtWP78Vr74wkM2Hq+C8hz+VZLddOkTyggvaMz8XSTnh41J3kpi6imE3mHguCF32XwFx/h4ECND77QXm3AXplG2r1qqCn9Ju0pPzlDgq+LuGKP/95Qm4ExFAF5ERzeyzet0sa44ZCrV+SnfVCxcYOy9xeZG9B4ClOJE335/mvkfLnVnGap2OpC+A4ZeTGdTHPJwSozO9BI6TXcb3h0leOVR7XvWyqRFOGDJlPDYKrVjarcjlYQOFf6LRVPPlzUqkA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+w3MDGot1+YyEgHolXQryFurwCgwDlL4ypiaVUC9AOGW+5Npcbznpfqq6GQVH4Q6gMq3aDXvCwaareK0Y12KDIoR+w2sm2hRy8a78kSgT9yumixNf6SwdTVfWYHcbQSaQbv2JpWPrwEEaQ9SEo+ysBNy0tILD8Y3fOXTQWV8M1X7EcQUBR2WZmwGv9D8JG4/R3HDpBS0eukXIj8YE3dTHZ2E+V3LQ6pU0Q7z2gxp/Pn+ykzcVqtebK4Ds/ahX4Z6ZbQHyMcjF6YEKbjkpPv6nA5MbenIcfwlu5yR9U1SX7XjFvgMJzv3/hBNkoEmQoW6s4BmkRVKRC2g1r97/LZoM/W/yiZaC6Y7vJ2TRBdbrKdj/gZx/y7vLs5/bgsLkkkPxON+D3hgo50ChRo87A6L5wNO1fnmQKDViJ/PAB15dIqjTExw3x5UiuKCuxqxuU6Cl14QjoUV860jCpcXqk/RWr9mAe3GKa0bTPYqgQEnrwc8T7XptADArjmtHhEXyZtfHw+4NHLI400xRSz4UC1apfvOFYfAuSr3/WirJIcCencyeQrGtWlG1Q4x4MZE0HrI7cjY7ixe/oky4olPBkpfigYWSxYD9PGQRg9LtFJRPk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dd86c9-47e3-4100-35e4-08debff3f03d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 15:39:16.4977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcHC/pmtzI1SBxLx6/eOxYefn4y4yOmLPB8a5oMCF/BEE1w0ypDwGypmjtV1RNINT1sApzzM6D9s5Ou8jTJUoM1mVmnaxhq3bpLalM4sTzu10WSS37BUbWPoCpW2+Il/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606010156
X-Authority-Analysis: v=2.4 cv=NLnlPU6g c=1 sm=1 tr=0 ts=6a1da7a8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=J_-Nd1mkAAAA:8 a=3HDBlxybAAAA:8
 a=urHxGH3jmiCKOw7aGAEA:9 a=QEXdDO2ut3YA:10 a=n8ForQn92ZFaZtFqRdMw:22
 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-GUID: UraemBeBqAySjw_s7DWojwWX5YM57b8S
X-Proofpoint-ORIG-GUID: UraemBeBqAySjw_s7DWojwWX5YM57b8S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE1NiBTYWx0ZWRfX+rL5hgSAOLcq
 BCi5MaHd4c77tmjCwaRPfFdI8iBPW7bNwisAi3s+5A/gLgcjvpfyrEwiBKIiXiu3QJb0MlIbR2d
 8pDi+KZVoOUjXDUpfOUn0fFhhvgmYCdNHQwrBeOY1EYD97BivmtS1EqpEarzISDl2SnFm6YMnDp
 Ke3Zp5f/35iFYPuyag3HA+AXvgo7IG920+QF0bs+96mPtaxEI2EQXA8pk69aAYeC+JIt70w4hpk
 dir/E07ZPU1x5XgOgsqTUQtILbdPR9DxT+aAvWbTPN9uq9rg9u2Qqin/Hl19u+fGwCYw2w2NVA8
 3NI9b9gN+q6y2mfHiUEvA3tGDCqadbifbbgI45wB+vqQfzApmy7D/9oty8/Vfsx+eHjYP+UQUzb
 LVZ7/IUVO3ySgh7wKYF3OsbhTzNJcafeFuWO2MUv+BDqtPGaoMFQqQ65MI1KJpxOC66/tTdxSIk
 e3lDUN9eNJCllSILrSQ==

Hi Greg/Sasha

On 29/05/26 01:19, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Florian Westphal <fw@strlen.de>
> 
> [ Upstream commit b4597d5fd7d2f8cebfffd40dffb5e003cc78964c ]
> 
> Previous change added xtables_unregister_table_pre_exit to detach the
> table from the packetpath and to unlink it from the active table list.
> In case of rmmod, userspace that is doing set/getsockopt for this table
> will not be able to re-instantiate the table:
>   1. The larval table has been removed already
>   2. existing instantiated table is no longer on the xt pernet table list.
> 
> This adds the second stage helper:
> 
> unlink the table from the dying list, free the hook ops (if any) and do
> the audit notification.  It replaces xt_unregister_table().
> 
> Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
> Reported-by: Tristan Madani <tristan@talencesecurity.com>
> Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
> Closes: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
....


>   
>   struct compat_delta {
> @@ -1522,23 +1525,6 @@ struct xt_table *xt_register_table(struct net *net,
>   }
>   EXPORT_SYMBOL_GPL(xt_register_table);
>   
> -void *xt_unregister_table(struct xt_table *table)
> -{
> -	struct xt_table_info *private;
> -
> -	mutex_lock(&xt[table->af].mutex);
> -	private = table->private;
> -	list_del(&table->list);
> -	mutex_unlock(&xt[table->af].mutex);
> -	audit_log_nfcfg(table->name, table->af, private->number,
> -			AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
> -	kfree(table->ops);
> -	kfree(table);
> -
> -	return private;
> -}
> -EXPORT_SYMBOL_GPL(xt_unregister_table);
> -
>   /**
>    * xt_unregister_table_pre_exit - pre-shutdown unregister of a table
>    * @net: network namespace
> @@ -1548,6 +1534,14 @@ EXPORT_SYMBOL_GPL(xt_unregister_table);
>    * Unregisters the specified netfilter table from the given network namespace
>    * and also unregisters the hooks from netfilter core: no new packets will be
>    * processed.
> + *
> + * This must be called prior to xt_unregister_table_exit() from the pernet
> + * .pre_exit callback.  After this call, the table is no longer visible to
> + * the get/setsockopt path.  In case of rmmod, module exit path must have
> + * called xt_unregister_template() prior to unregistering pernet ops to
> + * prevent re-instantiation of the table.
> + *
> + * See also: xt_unregister_table_exit()
>    */
>   void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
>   {
> @@ -1557,6 +1551,7 @@ void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
>   	mutex_lock(&xt[af].mutex);
>   	list_for_each_entry(t, &xt_net->tables[af], list) {
>   		if (strcmp(t->name, name) == 0) {
> +			list_move(&t->list, &xt_net->dead_tables[af]);
>   			mutex_unlock(&xt[af].mutex);
>   
>   			if (t->ops) /* nat table registers with nat core, t->ops is NULL. */
> @@ -1567,6 +1562,50 @@ void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
>   	mutex_unlock(&xt[af].mutex);
>   }
>   EXPORT_SYMBOL(xt_unregister_table_pre_exit);
> +
> +/**
> + * xt_unregister_table_exit - remove a table during namespace teardown
> + * @net: the network namespace from which to unregister the table
> + * @af: address family (e.g., NFPROTO_IPV4, NFPROTO_IPV6)
> + * @name: name of the table to unregister
> + *
> + * Completes the unregister process for a table. This must be called from
> + * the pernet ops .exit callback. This is the second stage after
> + * xt_unregister_table_pre_exit().
> + *
> + * pair with xt_unregister_table_pre_exit() during namespace shutdown.
> + *
> + * Return: the unregistered table or NULL if the table was never
> + *         instantiated. The caller needs to kfree() the table after it
> + *         has removed the family specific matches/targets.
> + */
> +struct xt_table *xt_unregister_table_exit(struct net *net, u8 af, const char *name)
> +{
> +	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
> +	struct xt_table *table;
> +
> +	mutex_lock(&xt[af].mutex);
> +	list_for_each_entry(table, &xt_net->dead_tables[af], list) {
> +		struct nf_hook_ops *ops = NULL;
> +
> +		if (strcmp(table->name, name) != 0)
> +			continue;
> +
> +		list_del(&table->list);
> +
> +		audit_log_nfcfg(table->name, table->af, table->private->number,
> +				AUDIT_XT_OP_UNREGISTER, GFP_KERNEL);
> +		swap(table->ops, ops);
> +		mutex_unlock(&xt[af].mutex);
> +
> +		kfree(ops);
> +		return table;
> +	}
> +	mutex_unlock(&xt[af].mutex);
> +
> +	return NULL;

Apart from a different concern I raised here:


https://lore.kernel.org/all/a8cd18fa-18da-4286-a704-e7045d8d9531@oracle.com/

I ran an AI-assisted backport review and checked the x_tables state in 
6.12.y: and the analysis goes like this:

This backports the upstream unregister-side split from b4597d5fd7d2f8 
without the upstream registration-side prerequisite commit: b62eb8dcf2c4 
("netfilter: x_tables: allocate hook ops while under mutex")


Upstream builds this patch on top of b62eb8dcf2c4 ("netfilter: x_tables: 
allocate hook ops while under mutex"). With that prerequisite, hook 
allocation and nf_register_net_hooks() happen inside 
xt_register_table(), before the table is linked on the active list, and 
the failure path includes the needed RCU handling.

Current 6.12.y still has the older model: 
ip_tables/ip6_tables/arp_tables call xt_register_table() first, then 
allocate/register hooks in family code. If nf_register_net_hooks() 
fails, the path goes to __ipt_unregister_table() or the equivalent 
helper, which now only frees the table object which also means the 
backport can free a table that was already linked on xt_net->tables[]

So i think we should drop this whole netfiler / x_tables series and 
think through w a better way to backport the race fixes.

Thanks,
Harshit







> +}
> +EXPORT_SYMBOL_GPL(xt_unregister_table_exit);
>   #endif
>   
>   #ifdef CONFIG_PROC_FS
> @@ -2013,8 +2052,10 @@ static int __net_init xt_net_init(struct net *net)
>   	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
>   	int i;
>   
> -	for (i = 0; i < NFPROTO_NUMPROTO; i++)
> +	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>   		INIT_LIST_HEAD(&xt_net->tables[i]);
> +		INIT_LIST_HEAD(&xt_net->dead_tables[i]);
> +	}
>   	return 0;
>   }
>   
> @@ -2023,8 +2064,10 @@ static void __net_exit xt_net_exit(struct net *net)
>   	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
>   	int i;
>   
> -	for (i = 0; i < NFPROTO_NUMPROTO; i++)
> +	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>   		WARN_ON_ONCE(!list_empty(&xt_net->tables[i]));
> +		WARN_ON_ONCE(!list_empty(&xt_net->dead_tables[i]));
> +	}
>   }
>   
>   static struct pernet_operations xt_net_ops = {

