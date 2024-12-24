Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91468632
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 06:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735022842; cv=fail; b=oqydEKdygnSSuPG1LS6H685GtIZjPryw2fYRjfzhMtSlPzd+6X1mOlWEvdqqfgMefBRxtnjAUzNJH6NKo8ymOm2TBBZXJ+P1cqOwZN9IGBaTFUXgi2lYAEoBuYYFPyp7G3NFRYoJPYBP4uPm6cMy/k7MzRyn+EOTWpJ/2Hderrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735022842; c=relaxed/simple;
	bh=PFLsGNnMfpTSnms2q2+ndbh+muQM4wxE7u+o2HgDTWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aMmgIl45pkrhOG5p+XrfAm2Bj7xT98ngRzwk/JiYqq5viOyjMv3g+VV6rL+MpssLEeusb1U0LJjekSxQss31SEkkigsTxNGjsDXGKvVtTv35/CBmnsoDHDd2CXsMnhpxsO2km53HPjRJdsCfpge4zhJmI0nQjomWoYuGUF+L97g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bUHawXj1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dkR28z98; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bUHawXj1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dkR28z98"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BO1urFZ017603;
	Tue, 24 Dec 2024 06:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8sgZhkSLp762Q3J5L0r4Gwfyt/Hv8xl8gsqRhS/0NAI=; b=
	bUHawXj1qCLb+pwjP7sAocXs7YtQq1YKYI1UBylm4XdyYwUi5SW65iEfjBTgIcj8
	yk4qf5dm9HDXGPkH+PantvKzbJWM96vE1UwNx5nIwchGwl12IqPF5SZBhYrUi2Kc
	whdCrk7V0q+kxxLY1r163Wbye+5efcZWBm3oiBSZ3sAx1w/WlA3lPUfkI6B4jo01
	MTBfQaemiKdRGOp5IN/6iYqvnUQTOQc5j++YlpC+vsK3A29Likv4uZ27Xz9bNU3z
	mDmOItP6BBMIHv6pT2qhhfDHC4jTybBWcm+Vi3fhecQKNvJTrOvDokV2QhRnUmMH
	FRxosVDLjIItEMxUl/855Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43nq9ybtde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Dec 2024 06:46:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BO4SNBB001005;
	Tue, 24 Dec 2024 06:46:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43pk8tjf1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Dec 2024 06:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4yop+AadhjvED6wOGN3K7CM7cQTQWQ/6slygrV2qecMdI+pbO6Xuf6uSRowuWNnsC2bkzDBSTPKDuT8zTSK5G+XrnNllsArV8tPfryVKnNrk0GXtmnKR4LZBGUxDqd3Hn7fBM3OiI6lLGi6ZBa+y7idxBaKeK2zEttUXJqlNU6aeeYrJImxi6L6VDBY7+ICBJxb/V+8j9rEhnbXApwYLKuM99+yuTE4OO+t0x+t34TdLzm/BDoRWrtL+WTgozkAPxv3NM6vvdbx0L205/wuRnjATzFh4y3sdrorB9u35AUNXE5XbvWlekWCOZQl0EdHOUefKD3ktBknf09HCf/OPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sgZhkSLp762Q3J5L0r4Gwfyt/Hv8xl8gsqRhS/0NAI=;
 b=XfrseEHEwLt3NQ4ZvDeoEk8Ox+gpqHAZIVi6YIqpMCBnzX03kjHV9k2Ky1X2xrp9suA/QPbxUCpSlY9vD5cmk4JVnRLti74P6xYaX0rI/jw/MDtsHNJ07LR02SLIe6lGV2yRlxuj6eUVGAVQe7iXH5HXYQJ9lwidLjIZVa/QAzXdEQvUPMkvaNKm//hxG9NaUGGphXzEtwsnKOXDnr11kaMuyydtf9n7W/Jv5h1UV44afmjgzwIHu5/tEY+kTshoQlWKmSM6P35hRyCaIl2RjCbMF1LHAKfdFpbuSj+frq7hNEjMKjEG9rIRaiKBilf5yta//6wyWZ8jhiwi6+srTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sgZhkSLp762Q3J5L0r4Gwfyt/Hv8xl8gsqRhS/0NAI=;
 b=dkR28z98a0mNAGzuBJJCH9lofJUn5C9ubHK9pbqyawn7ZYL6Hb2ZDvRdTiNU1woGTtv0IMOC7NA298SyFM4O3zCW6ixb98ltmksua1egr/a/+XCR2TdNaBlMjm7PbxWeygExwNb1UDK+KLRWKbd1/mb+KUdZao98pdJTyHLVFCs=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA0PR10MB7303.namprd10.prod.outlook.com (2603:10b6:208:40d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.19; Tue, 24 Dec
 2024 06:46:48 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8272.013; Tue, 24 Dec 2024
 06:46:47 +0000
Message-ID: <6150d63d-1ef2-4257-bd03-4d447c1ac0da@oracle.com>
Date: Tue, 24 Dec 2024 12:16:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20241223155359.534468176@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA0PR10MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e522adc-342c-40ab-6d1b-08dd23e6bcb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZStzVy9rZWhoUi9OZGZnL3FEYXFMR2J4QUszdU4rNXI2TzI0amRBc0lkeDRx?=
 =?utf-8?B?MFliN2lDTnl1Vi9aTHVHbWVCeEpKTUpsRUVKdUhycGlFclI0Vk9lK0JlNXUv?=
 =?utf-8?B?NHB5V091NUxvSzBkaFFXNkVpMU0zYnhNNTdjem9QaFJtQXo1bE5WT0VLWHNo?=
 =?utf-8?B?RkJnaU1yanNvakJoNnNIUXZBZzBCYkttMnNpTW9kc0RaTzdjeFVZWGlkUStm?=
 =?utf-8?B?ekpYLzdNRG5YeXFPZEU5SlJaS3VLMDlla1dzNVRCTHJrREEwcUhDU3RYcWJV?=
 =?utf-8?B?SUx1MWVNcG4wOWQveUc3aEtnT3h5Nm04aEZVVVoxMGkvblg4WXArV0ZhVHVL?=
 =?utf-8?B?RmkrL0hqdUZIamNRM1VjekhNZ3lRTStTZWk5Nkd1WW8yVDF3dFQ0YXJ3MzRo?=
 =?utf-8?B?anc2OTc5a3JJVkRpMWZOOFZ5ci9lRVlEUlBxMEZmWEdUOW83SE9uUndYdjNh?=
 =?utf-8?B?b0F0dHZzVHlVODRmTlMyOE9lZ0RzdENJVVBnVmlWdDM4YlZ6OFYzbnhoR1dw?=
 =?utf-8?B?K0RnL3pUcHV6WkVERVBZOEpNUHg3cTZhYkZUbHRiZ0gwUnJDQnMzWXl5V3Y0?=
 =?utf-8?B?QjdGRnZkS0YyRFdwVHR0QkNlYlEyZlpGRTkzNExjMFU3dXVFSHgreW9nSmV3?=
 =?utf-8?B?K0krLzVjOUpvSXNNSzJxdFVWZm52WkVOaEF0czJ1OWVHc1llRm9Wc1N2NjUy?=
 =?utf-8?B?NmpUSnQwUFUrQ2ZMcEJ3c0IrRmdGeDNlaXM3SFkvcW1mME9IZjdrb243c21T?=
 =?utf-8?B?anBFeENMZHdDUnkvUjg0MU1BSGtJRTBuL1BnNnVKK3drZlNQdlBwMzdFZXhj?=
 =?utf-8?B?M2lSUHJTS3lIY0Z2SUlXRW85NXRITnJ2UjVvSUdSMmN3R0NMMkswYVF1aTQ2?=
 =?utf-8?B?R2ZsdDdPNEhPd3liSDNBSUIzYnRQQ0xNYzhmTmVLWXlIdmhBb1NEQmtqeVlX?=
 =?utf-8?B?T1dOdXVlMHdVS202VGJoTUlqZWdMOEFFQWRlb2g2ek5HZ25jcXNSVnU2c0Ez?=
 =?utf-8?B?U3JMSHpBODYxNytJVFpPQ25LZy9yeDQ5by9EUGk0V1VUZnFhR2NFYUR0ZUJj?=
 =?utf-8?B?bkxxWlduaGhhb0xlNldnTjlVZTZmbnVmYnd1OHp4RmVOYzJBOGhSandvNlA0?=
 =?utf-8?B?NUUvbnU2a1kwVW1Pd3h5OGVMNDFRNmg3c2l0MzREVzE0U0VpVGthaHNYcHlL?=
 =?utf-8?B?a0RnSVZjZmFTdFJNMGFQR3JSaXhRY0lQMkVjQ2YwOGNOY1pidXpSTEVUM2k3?=
 =?utf-8?B?VEhNbW1neGJ6VlArWFZoTFBTTk1aNXU1SHZxUUhtU1lNdTVVTGZLc1FXTkth?=
 =?utf-8?B?ekt1TDlydFl4K05DWkNWdnU2dFF3cTZqakk4ajhVdVZZQzBibXFCL0dmcEVH?=
 =?utf-8?B?U3FEU1hZQ2JDQVJxeUJ4N0N1bElaSHVhNU1ZU25ZZzZnUFlhMGdmaHd0Z1ZC?=
 =?utf-8?B?bU41NXIyWTh4UWZiUTBNZ0FtaWZZbm9ER3FwUFAwd3VCdmQ3VTA1TzByQUo3?=
 =?utf-8?B?aXZzL1JBVlRHS2t1YjljU01sbHhMRU5kRk5XaG1XN0ZOcDd5Qk54YWdwQzA4?=
 =?utf-8?B?cm5PWUIrUjJnZTJxMGJuSzBtTDFnMjBESjgvUGZBWWNCWlZVWC9PWndlV0No?=
 =?utf-8?B?TnYzdW9yQnlXZW91VTVodnd3Y0hUOGhaR1NEVmptZDIzaE94L0J6aTd5Rnlv?=
 =?utf-8?B?SktkMVBEWjc1K1FaQ0ZiUytMYjVudFE4SlZVemNlRnVhRitxWG9MWkxMMUZ2?=
 =?utf-8?B?eUFBejVRRmIvSU9qaStvR3ErTmRrR1Mza0RiVXd1VVRUSS8wRXEyU2RRQ2VL?=
 =?utf-8?B?blRYbWRRbElidXlDem56SzFIYlllUXpWZ2FQbWZjNjU2TEJFVHJsYWV2R0t1?=
 =?utf-8?Q?dRvzgL9potKg0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGVhNkhlZkJmcWN5a2MwYUJXMmdkTWhvZC91S1F5QnRYVGIzc1FkVENKSy9o?=
 =?utf-8?B?bjFLUTR1ZzNhR2pvUFV3L3pQMXo2ay92YmhkTkpaV2V1SGVSWXZTcHJmZGpL?=
 =?utf-8?B?M3BYYm1TaElGZXNpVWl3VlY1K0VTZUJTeHo2cnNMNm11VWVHQlhOZHh4UG5O?=
 =?utf-8?B?djY1T1I3Q0M0MXVYS1ZETkFHb0RJUGRoR3h3U09ySlh6Njg3ckNDelJ6ZUVT?=
 =?utf-8?B?KzdERDhOVUJ5eEMwcDJwNGwrSzk5Qnl6SndxcEFYa1JuMEl2RDkrV21qSU5I?=
 =?utf-8?B?NitMS2Z3RExuMi8yZjhnbEdGdmpxS29TSmtybGdFcFNJVWpkSXNIZFNBYTh3?=
 =?utf-8?B?NEY4eUU1VTVSRFdvdWtndE1QL3FjM3hsd3FsYzIzQkh0YnA2V3Q2aFFUeS9w?=
 =?utf-8?B?QVM1RUNHM3Vqbm1nVFZlVzF4bjlySHpITzFyMnJRNGlBRDc3ellzaitsc3lk?=
 =?utf-8?B?Z3pPSTZJeEpoZmE1YVBad2VqNmJuMnlzSyt1V0VWSUg1SnM2VnZWdk1TYUlk?=
 =?utf-8?B?SDZIUSs2bjdQOCtoYTRDWFQzRzM0bll6dUFienI5bDg5a0szVDZ5SjZSWTgr?=
 =?utf-8?B?QUNBZnhVcGE1Q3dHOThZSVZ0NHk4WTN3cTJqVUdabzNsaCtZcDlqRjRidTBS?=
 =?utf-8?B?K0grMzY1VUpSTi9Ca2NwVVJINHJDVzBqcHI3RVNLcCs2T2Ryd1pzRFRoMUM4?=
 =?utf-8?B?emdaVS9xSVBrWGlRU0ozUStPRSs3b05rNTFpOU9oNEoxK2p4YnIzTzI0NFVV?=
 =?utf-8?B?ZVBHNkp6dXd5eXhxQVpTbmdKSHQ5bFM3TnVzQk8wY0pnaFZYUE1ibERKTjNz?=
 =?utf-8?B?ZWw4ZUlTMm4zKytUdVZVdXNXUVI4WGNBbWdHcnVTd2VGNHVZVU45ZVhxYnB1?=
 =?utf-8?B?cDdMWDNpWDdOcXBaK0N1SCsrYkpnSmp4UmRwL05ZSkFwYXI4RHRlTHZDbFRF?=
 =?utf-8?B?cWxqNndiN0cxRStJL1ViYXFhOHFja29tK2xEYXdZaFYySHhmZ0hNWkxYQUR1?=
 =?utf-8?B?cmNVa3VRRzhKSExxcGVmeTA0MGQ0dkRDZEZqbTg3RnBWVDEzelp6L0dwV25J?=
 =?utf-8?B?MXRwNVBvN2NJMklPU2RraS81WFdlLzJrb3h0aHdrbEFIcEhXcjlmSFdPNHZ1?=
 =?utf-8?B?T3ViOW05SnZLQndmT0E2VmhKQzZGYW9iZjFyamdiWnQzMkd4ZjZGZUE1S0lY?=
 =?utf-8?B?SWw0SmdxVnNGcHF2WndEWEoxQ0pDV2E4WnUyRWRrR0hVNUkxUXdGSlg4MGtv?=
 =?utf-8?B?Vk5jTFd5UXRRVWkwZmZqTUtab0dqalE5QWY5alMxVERKMlF6WmZjYUptaCtO?=
 =?utf-8?B?VnhrdzBJOXl6NmppTW9VZnFOUm1JdXBUbW1QR2dvRFh6eHpudW5TVi9CMnZC?=
 =?utf-8?B?dVN1a01jOHdsa05wdklpWFdvNnJjeFB6NmVLZ28xVXBsbXlRM052cnU3MWRB?=
 =?utf-8?B?U2RzMkR6Qk15dzNPdkdiYUJUaERZMjljY1oxQXd4cktUUk95aXZic2RCN04x?=
 =?utf-8?B?dm5QL1hYSGVDeE80cEFFY0NiblBnUXFvWEpFYTNaRk9sbmFYQlJVNEU5QVgv?=
 =?utf-8?B?Q0ozU3BtaTFrMTVXdGJDaVhLaWR3Lzd0eFNhbFY2WlJDM3NKS0c4a0FicXE4?=
 =?utf-8?B?TmNIYVZWV1Q1K1RoZUplUTFENVZvRVNRaytnWXlLRUFkTW9WcFAzVm1LV20x?=
 =?utf-8?B?bkhtaEtaU3EyYVUxZkZETk90dEFIdUFiZy9ab2FhRWVjTlJCeXdHSG96Yy9B?=
 =?utf-8?B?V091a3BSMWVGS3lhOFVuT09CUTFwWFFUeDFmME1jVlY3aWlKQkdTU0JBdStR?=
 =?utf-8?B?Mkw1WmtkbVgya0drYmQ5aEg1bVhMTTduWEtNd1RWUHlLODRqMFVZdzkwMTNL?=
 =?utf-8?B?NmNXMDRXakNjUFQxVENLRkt1ZVVycVQxQjFZaU16Y2lTVDJBS0xIMjlrbUFZ?=
 =?utf-8?B?TzZIOXlmdVhPMDFqdmpCU1BaZ0FnQ296UFBuM0FTR2VRYktDRU9iRU9DZ2Ey?=
 =?utf-8?B?RlVwekN3MElJU1doNFVXd0EraEhDYjZBSVg2Qy8wZElBTG9PSW9YRFBudTZh?=
 =?utf-8?B?S1AyTHRIWnYzNHdXN1pvWUJsUXhDUFFwd3pTZHdJQ3V2SzFILzhnZ3ZTdHVZ?=
 =?utf-8?B?T2dLenlPQUgwaHhDN3NVMUM5d1YweXFMVTl1OXVZL0d1bWYxcmNYYm5LNU5y?=
 =?utf-8?Q?aMtQAE/W+0s+bh9gMXBmzEk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+/Zq3b5YcHCcQJZhfNipWBP2MiPNxWeXkvzoUUmG9KE9aJ8pLHXaho2Lf9m2bEg1YVtQehO17AlmqsH8fYCU+i6ZajisrW4vyv822NreXQk4y9PQ9YYKyaJAlziMgZutqDa9gdz+jeVDFpxeFMyEuq/SGYK+rvgiUx+GPYO8dgduH23m6nwiFhol8ZkFlp4K/6J1fL0yQSXvAOogPP2CyxkSJAWT0oLfc84W4xsXL9OdNuiM1vTmFRE7DTTqKGr2kuw4pja5hH4VOJ0RSM6M8kEYZZVrPigw7JlrBOay0XRFXBPSixQrRABgDlmETMsLuFxqNcFeXt3T4Z1rxSABj7bEVnMMNPUwbHiB9cHdEcLpGph0TvwCNj66RGVDALpL8kYCf6OVU4t0oJVrz/jDSlImwwHiudtVfvM8NayoTz7Nu20LAYfbCDPPt0MBsRurguTHCUY6kG/zyFaAN4Vy2SPdznHvuof8LXRl0E7+ig+3mHjeNcarWxAxciIjuBJ0OgLiqRZRF+f8mMYgi6ZEgteN8huZtXNmVKU1PegjhVFnyN7Zehtmp1XFxY77WQNW2e1T6G5KTLK8veOfKPcS4vVsv9lXW7z58Cdd/4411to=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e522adc-342c-40ab-6d1b-08dd23e6bcb4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2024 06:46:47.5539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aH9Ax7LZDL1pcze0odY3XDTYgMmh2OszXa1fu6/g4ApnBCIAwEsi8+7DLR1nAwAwF2SbDK9xzm84M0szxHkgpfDXP7XyfaHKyu7dphfVrO1M3rVG3igPvQJvNtokDkNx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-24_02,2024-12-24_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412240054
X-Proofpoint-GUID: nmm5DCEvy2nQKIiHOI2-v0-yfO5IxH8f
X-Proofpoint-ORIG-GUID: nmm5DCEvy2nQKIiHOI2-v0-yfO5IxH8f

Hi Greg,

On 23/12/24 21:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
