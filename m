Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6F1385D61;
	Fri,  2 Oct 2026 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975884; cv=fail; b=niXD+yYw25xWPdj4WjvXr8Ba1Rcmg/quIGsVD24RCG9PjSKMmEOVTLdjQ0ImSSG8/ettlV1RFdm56h98Tx/gjoDwp1fjhokVf4KNPAxrhihuPcK+SJvhGrDla5VgpebOnY+OWDrWXCnUT4kGhCx0aR1XfhfW7htKr0PekoIV+Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975884; c=relaxed/simple;
	bh=stDC5bUw521XBxc5s4GRz1zJwKTbysSNSCgUsL9L1bI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CLINvW7hjGomI4diDXLYz7LDPDqUPa0GW2rOO3fav7j89OuJvLJydRBHCK5oLBUYDS0+RHZx9kEcai35aCCt/M3M7+yESLnh1nAvr3kOp74Kj2yCmBDuwRsKMYJYmhAXm6Yfx0PxTZw5sVHPfhV8ZvA6oLbrETnnAzvOlFzK7sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cBoSrNPT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z1XINwJD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cBoSrNPT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z1XINwJD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EbdhJ3156301;
	Fri, 2 Oct 2026 21:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IPxiw5hVMEGT11ONPN+Ipcvv3WxKgCtyiINlgwC9aEA=; b=
	cBoSrNPTDhBTGBnMqBcm4ucD1qNmshkIqA8PCdJOYqc1F2wQT/CahLaO73Icci8b
	3GLUKbJEUw77DGZRV/y+GNLIuLjIaWd/ONjM3LGITT5HNdkYSAj2wWgRZ1ihd+uh
	dbMmH2YmVslkzpXLlLXiiAESi/4piZ2zqD1ncVJ/4TbL0QSwhAXAf0nWBKzFnfsP
	7Ps5SfmmV7c+seFsAMnLfrmncKrbVs2O7jN/QaKCHfGeq+eNZRYGTD5QLHR6GrRX
	VyryENYqpn/5U9V5WelzRgk8h262jvVqg4apPL5wlLKIMALVNktYGvs4IipwEekT
	c+RDmie5kcglbLkAfjTd0Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx6kscrsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:17:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692L510h004451;
	Fri, 2 Oct 2026 21:17:52 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010040.outbound.protection.outlook.com [40.93.198.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4ggfgx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:17:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBaPsHt8+7uxCacXp3plAxs8jQpJlg1+Bh/bdjqzTQWtGRs2+VSdRQ0ZC44gbN8oDTsKmDQ0dI30uLCFby2jQlNfie40t9+oenarQzobI0MxVQeSWWOpjnGevvZYzSs579KC6uficoP5ajyj3k5uJv0Qn35GDBAPAGz/GSsqc0zp35qjAtcz3RXMBdRtKod5GDpZpqDxsvPK2ZVnAP0ltmdbtKURGaVtEMU3nwUX8sXue8+eeMDry8o+WQcj/5XIPDULoI0Cx4nA4VGuFilqWv4iZRN+e6U1EpTeSISDx93PajLE2yGDJLUv+AIXf2qPFTBN8C/ZdaxRJKGeeFQM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPxiw5hVMEGT11ONPN+Ipcvv3WxKgCtyiINlgwC9aEA=;
 b=LYD8OhMuOpGnT+OqoTScWBvZT9c7mSIjJ9W7Gh6t1rvXL8belHLZVbtf6jREA2qLcsjf5B6Xg/5+reuEJI1uqbYv8cH/VDgPwRhV5oJ6JQB7FrrrNlznuo7j2hyNUvXkC0T2sRgw6LdSdsPvifaVcgW5nHGmub5FVo8P+gPRav6nbIbWcLLaHJuh+L7J5Z/C9cxjihCYF2zp0BYFphG1RD9c4FsR3OZ5DVyJl6FCvJk6sQfUh/rZe+30vWsKWG433xn9Hv+PmU6x4Gtx3Tx8ARqr3o50V+S6V9wfb+SsJqqXknLEMo6aEze/UMzid+jUA/PXRB4kufPpDqC9MFgr7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPxiw5hVMEGT11ONPN+Ipcvv3WxKgCtyiINlgwC9aEA=;
 b=Z1XINwJD2T3orJubdo3Rmmv50LoDZi7Jr3nLLviscsJVrDD6LMTR0btfMABaVbmv+LspNbW5XA3J+yBUl07/cc94quxZlTEnka4+Buo9XDOXzWmLYDSqMDmpmwLcExfSjyBlVpBsqRW/Ry4jxjJ5VBu8mUHkD48AoTjBWUYfQhI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS7PR10MB4991.namprd10.prod.outlook.com (2603:10b6:5:38e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 21:17:47 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:17:47 +0000
Message-ID: <af3d0cf7-831e-4bec-951c-dd6edfdbf011@oracle.com>
Date: Sat, 3 Oct 2026 02:47:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 746/877] ipv4: remove fib_devindex_hashfn()
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152430.793210817@linuxfoundation.org>
 <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com>
 <2026-10-02-1-daily-reply-0010-re-ipv4-fib-devindex-hashfn-6-12@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <2026-10-02-1-daily-reply-0010-re-ipv4-fib-devindex-hashfn-6-12@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0030.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1e::7) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS7PR10MB4991:EE_
X-MS-Office365-Filtering-Correlation-Id: 1395b9b7-b3ca-4c6a-135e-08df20ca9b93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|5023799004|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jALBd1BIVRP5Dnxqba0wg3wQkcDUGJkHLFcQhqT9aeKi79S90gZzvaSNu02b/TOwIqitLaksAoU1wIBH7DLsSAfwvkAVLeWhIDXGO+e3TkS2ldYQ77/IPXM1EgYpQHtP8PzbY3X0E22wJTXEOwWh/KqwqI7PhobZkopb4WMaSF/keD+TaYzjSvxEhqMrUBi4sHTuKZs0Dzl6FV6WgKNRjXpdSjlV8+jXw0HRCZc5Llm9uakgurQbKFPx6TNzk5s/BrernJJqOcEeggGWCKonFCp0npRcXr1vD36NqjeibMngUA8suYo604elOOe62ExHZtjjGp9kK6wCWZehPcty9Awq6T10bWpZdYHHj6n2frHU4ywQ9fZo8jN+7tofacXZtIx6KcHJkJlCRIfG1sRGf3aIESWb/HPGobsdTi6TzzQvkB9W5yqVwetBeYsEnxAjMPBKRwog6/Hm9qm4UWFaxyUcIQzqGmgV0JYTClo+vnGTHOgvShfoBNyHRAc54YiiuY10ULeRQHwl5btjFWXlLBcYYvt+ZhmUh2aCF4qVeK4SdSzBJdcrWAA5J1YvFQ94v8pwHrmGYdSvJ7w8qmFjV5hc0iNSIap4gU5xTX+7d9AUqiFgUG5lEg6qqCoAUp3AHsX6+SVjUJ8bCC6sMnDR/g5GC3K4PMLCN+hLHncMGes=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(5023799004)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDg0YVBwSFhWeURRM29CNkdrTVNVWEJIRGxjZkd5a2dKd3VyY1AwcENxcDJM?=
 =?utf-8?B?NDd4Y0MzR3ZkVUNORGE1RUpmdC9XdVpRdWZXWWxYRUVKNlFhM0JRK1ErZjlW?=
 =?utf-8?B?eWZkdzBvRGpxODJNcEJ1Mm9HZGZhZkd1azdnWVFCQURzV3Y2aGdVWnV4ZG1S?=
 =?utf-8?B?RzVkZWNGY3k1a1kvQWxoN1JvajlYeW9TZUZoQWVvYWhwM2tyVWlQd2hZWjhO?=
 =?utf-8?B?WTRhS1hZb0pFb1VYMU41TU44MThjc2dTeHdSOHpFNnljVHFCZld0cjJudUFB?=
 =?utf-8?B?amo5UGoxS3p1azJDeTNpU3dHcU5jWjNPNkZoZHVJYk8xcmhJbm15enhZZUt4?=
 =?utf-8?B?YmM3Z0xYeDljQzNBcCtZNDl6NzBaaEdGVC8wSnZmN3FHMjlYTFduTzBiMHFq?=
 =?utf-8?B?Q2lvbTFLeUJZRGNhVmpscXBPMnF3TkxVTWlVck5mMzVkWllObEUvNHA1bXF5?=
 =?utf-8?B?bmU3MFErV3psak1veHRDOGhmbmNTT1dtRURISE1PWWFtUUFubUtVR3RXV2NQ?=
 =?utf-8?B?WVlqaHRBbmVINEZlZitaTFg1bXBkZTFtemYxRlhXbDE4cUlUTUltcHJoNHlp?=
 =?utf-8?B?RlBJcCtZdGtaVjkvNXRQU0l1Tkg1Ulc5czE5L3MvamNPc2hQUk5PZnp3SmFw?=
 =?utf-8?B?eUplUWdLWmhZM1Q1MzQ2dUZINE5Rd2hJM2ltMFZ4bWFOR2l6dGQyVVBwRU9C?=
 =?utf-8?B?Y1ZtYmFhWGViSk5ZcFBuU2lnRnJvSXllOHhqeVFuWW1lVVBqWlBIMXZmOEpR?=
 =?utf-8?B?Z3hFK3Q2dU50cDNyclhpNzlxaFdsV3VIdDRscEc0WEFlRU9kRzFtaFRhKzhR?=
 =?utf-8?B?WUFEUEE3UWFaL1lPcnNGcjFPZktEYzVFd1hXOXQvZlE3Uksvd0Z4Z0dTalZC?=
 =?utf-8?B?ejBFcWlndkRxVG54SWNaV3hTTHFrN1hieWNIei93eXJSRVh0cmFWbktDdEpV?=
 =?utf-8?B?Qm5QQk52bVZIMSsrazMvV2tweEFYSTZQVm9CZFhkUXkyR2FpSWE5VEZGOGJj?=
 =?utf-8?B?NERTMU5Uc0YwN3FPT2lMMjVaL040STFnNERUVkpzTEIzV3FUaDZzWDdFUkdS?=
 =?utf-8?B?di9MWG1QT3ZybWF0M2c2ZWt4T0UybHM3dUE5SmM2YVZadC9IMWlvUU5uZkNI?=
 =?utf-8?B?VUdCREFWRUdnVnFSMERydDBSNHpRZDVtUWVPUWg5LzRhL1ZNTWorTXY5UWg5?=
 =?utf-8?B?em9MZ1JLcEVUdWdOTFEweERpWGVaK0RkUlZwU3l3MUxCdzZ2Y0lBWkJFNGdm?=
 =?utf-8?B?eW5GMTZCZmYxUllMdXF5SC9IcnFYM0lTNFdJbnZuTkZpZmVUM3pQbE9lc0ll?=
 =?utf-8?B?VmpTWUZ4d3lpS2JueWpFRjJrNmNYVkpKTFQ5ZTJ2cDJaSmJNOGduWXBpVC9Q?=
 =?utf-8?B?SXNnTjhGa2k5UW1OeUkvV0dORUVoY0p6ZW1XL0Z2djJLTzJhNGVsRUxsb1Jj?=
 =?utf-8?B?TjduSGVBZWtSTGJIdE92dVpDWjdpdEVZcGtwY2hpYTNYaThVM2dydk8yUzRL?=
 =?utf-8?B?Y1FvS3BQSnR6NkxBS1hVL0VFQUxYUHJ5N1lpQzRPQnJEenEzQk85Qi83Umc3?=
 =?utf-8?B?WmQ0RmFJK2JvWmlwUytlRmV6K2lTSkVoQWJuMENDM3YzeVJGM1RGV1hwTEZQ?=
 =?utf-8?B?SklPR3JMTEFzR1VicWtsSWszTGYzSllKTE13N2d5eG8yMU9HWDJ6RUNoU0xG?=
 =?utf-8?B?Tm9IZ1oxcUdwVStNWjhaeTU3R0tVRDNrTDgvRGZ1bUxYQ3BhaU53M25lR0RL?=
 =?utf-8?B?MFh1b3NvZVlYSlBxRk1sb2ErSkZjU3hKNEltQUgva29sZ1h3QTg3TTlVUy9Y?=
 =?utf-8?B?YXZKa1ViOHM2NGdGRkpRNm1qRzlkTUFiN2d4TnZKQVA0MG1jcHBId2F1Y253?=
 =?utf-8?B?Z2FMYVU1KzFsbGVhUFloczMyTnhZSnpZdVdZK1lEZjI1cDRJQ3pzcVJyd3Rv?=
 =?utf-8?B?c1g4MlBHRjY4ZG5zRkRwSVJKUytCVUkvQ0lHazZ1MzFFbU9MY1FEK05lcGxs?=
 =?utf-8?B?U0tTeHlpTTFWKzBWYmNLYitxcWNxRWUvaXdOVHlRMDZnS2dYVUxBOUNEQW5a?=
 =?utf-8?B?ZlNsWUhTY2dxdEtOMksyM1VtbzVyTHhscThUYm9sRGwvbXJjNEhNMk5qTTlR?=
 =?utf-8?B?S2gvWlAya1hpc0IxdGRtY2FFejZxa3dtRThld1MxeDFWR2hyeUxzNkdOUEp6?=
 =?utf-8?B?cjlXZzZMQVh1d05HN0M3ZmVQSGlWbTc4d3haUzJGZENYUlpSQmsxTlUzQWls?=
 =?utf-8?B?ZDhCQmFaL0xFdnFFMHJZTG5nSVpLUFQwdUFTdzYzRkJWblFMUXp6ODg1WjlD?=
 =?utf-8?B?eXk5OVJZRzc4VGd0YTJUNGU2bzZMS3UrYkRyMmY0V0hMaEFuZnlCK1pWSDZo?=
 =?utf-8?Q?SSzx4hgn+GYiZ3p6eEZeLUwpiY1RAiK6VfiB4?=
X-Exchange-RoutingPolicyChecked:
	xWDLDsVL2YHnQ0AGvy19yvK4qQ+3wuy24LC9+oeOci3T1cy22I/yU4lbPmY3YDCVNbPOlrvHjoqr3qAvmpwxSLD74TfaMTvt+nDDU2TRrvZjuSduXhgXAPtTzXGSsnLD833rR6tNjyjKm3kR55Fykf/PQCR6jp6nRc/Vtb+zCa5lESoX7JkUUvxb15ofzJ9XX6QzzLVPDreaqgB8WuVb9RZg1nz4HtwHOTBuvOLVlZ/5Fj84yNKBn3usIIna4wtT8OUKjWQDHAMzZH7C/WWxbCLsOHZT09738dqxa+3Qb9QZ4OzAt9RWrsnXt+n7+yepzfZmerTlM7q2a5DuIhq0jg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O36KIGsltpxq96gYWwLObHqIY+HwVduKx0CBZo5ttn28yvcr7ge9r1fms4513sJri5e4evZZgw9OdoHZafuEnVGSVPbROCPelKi5Us+EeACWwAVewNwVxFdV+0gKW9mkpr8dN+in66S2LrLW9klJLuwNYiWL7AdyZ6jyKvyBStEf7amrqhXrc4jsnHLHvrbwTJI3m9EOfKAfCVgYpUmhENeiS0Wo4ldN0gx4Rr1Dc9alDWU3wqT+7bjfBJpKqw/whsr43OsxL406C8QbAe2z/Wpec8CPUYmBM+ToUjQAoaneLTGMdG9ATcFipXfi815uQlDm3zqKQNqa30d/o/yQh8q3HTvT5emTSrz/CN+O4vXdu6AoY1N+1Y/9uwwTItzi3rqDc2AHH+b+krihiwvci9GTl0d7BAJUnoWrHdJDFNZRY3b1mdKwHxczZZA07m98XcTnWICVrY3Nb0lRrRTTEFl9QuPIaMjsXO8wqdmdZWlBSsfr/8FZYdxGZ5F9g5AIKEzgMgICb5M1a40aBe4j9uNSPB7gDGFifVk9Yo43cWOFVdipcokzXW5Zs+jut+Xi/1xef3c/lyDzravvqrLFaVImNyWoJ4WjIUf2axX0kG0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1395b9b7-b3ca-4c6a-135e-08df20ca9b93
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:17:47.6798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srpFhgbcgSLm0Y4mCbrlS+YMYsxx6NqkZ+cJ+MJdcQMOISc4C/6n7gfJsIGMsKU4+jtXYtG+nA8RTLf+3o2FXrp1XIV557qS1a8N/AnW6wk+fkl47jaTu0OySRKYDXZ3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020084
X-Proofpoint-GUID: THQMhmyOh3s8EzEfjYNCUdoU5Rondkn7
X-Authority-Analysis: v=2.4 cv=U/gHnuru c=1 sm=1 tr=0 ts=6ac01f80 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=UqFAeWPbZLKlxFHdd5EA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NCBTYWx0ZWRfX3MSCQMFhLeep
 rWS55U97YeqQDdpwPZyCYplrTva43lDPyNsmBw0dlXoJhvegftrCbF/9MxTMjGJwdGsSZ3VbEoJ
 jbiH0+FK8RhuK+3nt+M0w0aDbBSD/a5IRTI2xwFMWAxpwW5uLw1a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NCBTYWx0ZWRfX5e9TQHXItrig
 OGhEc+Nu+KF/DRs8mWhfDm8nGMuSZoPGWD+Cc3WcSXEYWFB4mk+jqrJPRqmk5gTnyEW6inNglwC
 +y2YEIE28TNKsG+8VYFagynQqC9fgXbGkuyckOW93njj/kfylXR9H4cNh/bnMVfOfswQLTt8AAw
 VdHbABS4cwDHek9A/U5LdEL/7tvg5BjL582yjjD4AOxF0rlJwmTyfJdw6PXfLgTmVIFnQRLGSPG
 C27qDLzoiyEkq2m5NMqGOR9kkNgwGVHn67wxd31exWQXOm2a78VitCpYWSbcJKh3ILojVZLaPMj
 vSikNS828D4cBs6xXjNkVNv4pfMV5BHoFq5BLlOy7bnoFzTdIEP6F25pXHcLaCtNSAL7BO6kVGh
 g0aRleirja/pKyE16ZzSWYwC8XC0hlGNtgsQ/6LBnT0rQ2CCRiKtOAbpqygAA5E2jhc9KvcFAeu
 DVPwlzlMTTpgM4rK3/w==
X-Proofpoint-ORIG-GUID: THQMhmyOh3s8EzEfjYNCUdoU5Rondkn7

Hi Sasha,

On 03/10/26 2:40 am, Sasha Levin wrote:
>> The old finalizer ignores upper bits of raw nexthop IDs/ifindices at
>> ordinary table sizes. In a 256-bucket check with equal route metadata,
>> 128 IDs differing only in their upper byte use 128 buckets before, one
>> after, and 128 upstream.
>>
>> I think 6.12 needs 9b8ca04854fd1253a58aeb1bd089c191cb5a074c ("ipv4:
>> avoid quadratic behavior in FIB insertion of common address") before
>> this change, including both finalizer callers, thoughts?
> 
> Right, 6.12 still has the old finalizer. The cost is longer fib_info
> hash chains when inserting routes; nothing becomes incorrect. I'm not
> going to pull that commit into 6.12 for now.

Sure, sounds good.

Regards,
Harshit>

