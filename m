Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAC52036F0
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731427626; cv=fail; b=pZFvNu22UO4INxebJdUcTOoW/oFEdyc9MspS7bQmCvfxGv8KNaV5I4VpedLzSAxUCju1Hm7ytbWX+nyx4YIej7peaHoO0vByPJZNE84P7Xk9RROL6gegIAXFGAXwgKZmyfErdV2jqivQftVVUSQRHaX7ZjLp771TzHXRXLojFyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731427626; c=relaxed/simple;
	bh=3Eev/xt9+oEqTouSjLMoplxD87qGiCzgmLU/cymiGes=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Krhcz8/re+vp/28OiD8zU+Rp9eMynWqYbovMDsPmhaLXWGvA6sO07pO5N6KTcKF9qebuH/tVYX8KXqUcWhRo5lih1Ii/p60Co/7t5OgomeTuUlyHXFK+NnOPe5Ezfa+4gBpj15zXrYX9VW1V8VrDI/C6HdMz13VT2xeSOaHJv2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BOLs6yhY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u5S7Eqiv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BOLs6yhY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u5S7Eqiv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFNbAp014729;
	Tue, 12 Nov 2024 16:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1yoxeQ8QQQveKVyWXPS4vBKnkAn4VgmZNG88RjvJnQg=; b=
	BOLs6yhYO65HRZsBgpp9lf9GQx2oAI8dl13esuLSFRqM2UJL2/Va41XQLcPuZPUb
	Yg1nyxqXD6iPBWQ7IcO9fstTtvxFdnaSFkfOpLETjwy/0ZFbakXhLvdTh6+hwqDj
	T/yILyvi+lXUIUGWwYV9fRoiLmfyioonXlH+a4fVb4kS+8k1KXK71MmARfyT7nbb
	GPLqWVowung2mVlKnmOjJB22T+9iyan2kxODC4Xr7Z9rNreFGuC3oSIMIdM06NCd
	x5cACC6h1E7Sjczl62AeS6qZri33y90wh8XOv/MzrZ8Qdz91jb5YadHg6mFKBS1P
	PTzm6tuI5AHNrlJeCiMlaQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hncryn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:06:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFxcaR035901;
	Tue, 12 Nov 2024 16:06:53 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6836h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:06:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FoUf9lYpqiWSaUTzst1bK0GT43pGh94NyInjCnpm4hnQaDE1QTHzzZ4EwI6ixIqaSPm2VZ9oEwRG9XvuveP6trBgyR2kGkUAT1NanXLINXfP66AmeZJkg/eooT6xm/ozJZOQdJSV43Q4OEozRh4DigRG4pcaWDpyIXNB8H7otUZsf/o6TIPDnZ6ox/IhS2cidKoY9GZo7j/2DcB0cXlxtHiyw+yLU+n2R2wZSkZLmQJO1xmV6yIKPHEUrxt5bx3NGBUjyIbT6W4LWkv77k2rT9DGrOb2xwU3ggFVkXLLtlN/fzZxih5v1x0ooBS2cOzJbUUcPoE5g9ruvtUKfiwYug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yoxeQ8QQQveKVyWXPS4vBKnkAn4VgmZNG88RjvJnQg=;
 b=PukuY1pZSaCsPJaYinfVZ4CGyBmk7GPz/VaQVnC6IL7s1RuGEybb8pVGc+WJyqBMJIHwstpEOjn1yemHYG1R9Ur3xkUZRLeE0abXwOFay4OYuQFMMXaR2fFybQVOnR+NUSECzK9yex+xYWfJ4kU67+WOywE0tBb6DIhPg3bGo2QnblsfXVsc7Li5sMJIkXu1EmzIiXmcAmuMxsQ/gnj4+7xzuXXHPJDdH4x7XAPp+i1g2Y50PqxhsU6Z1pisjg+3ipBP0MYIYKLhq5Q4MQzOSzoKUd75tvMJpY7FErbn8DNC6kfHoFizFFZ9HLmDWdaEAiayNjpbxwJCBdj4M4UZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yoxeQ8QQQveKVyWXPS4vBKnkAn4VgmZNG88RjvJnQg=;
 b=u5S7Eqivy1KVriHTrBAIHnFaV4gjgk6TWB7PRWIHClInIVZp2RpmAfBUxruOrjGNWTOp6ZwC63BxeMUh3RLnvbGVpFvxZAI8KEkeWTJEIcofK74ayQJc4v4ZvPXRhoEKILhOQG47x655MsZeGpKTn9R1HdoXLZbDq8Ai/7Qyl6k=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 16:06:49 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 16:06:49 +0000
Message-ID: <e0fb766e-6cb7-4a42-b356-cc7b137a416a@oracle.com>
Date: Tue, 12 Nov 2024 21:36:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241112101848.708153352@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: b7cb7505-d0e5-4b67-4689-08dd03340353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlJacEU2dHJlTTd3NWx1YnJIUjhFcXBjRnI3LzhZNVNveXl4OHpvYjY5d0J1?=
 =?utf-8?B?Q0hKTUp6UFBiajZDVjd6ajY3MjFNSVF0MnpzYWtET2hSb2tjOE4zcmdvUW5V?=
 =?utf-8?B?T080VlB1ejBvMkY1UU9ad29aTjBOaGZFMlZNOEtjRUhjUUF4YmVFdjJ3RFpZ?=
 =?utf-8?B?bEsvTUtDMi9tMEFnaEVYNkVEckU3cUw1U0IvUXBiQU5zV1hPd3U5dmkvR2dt?=
 =?utf-8?B?MG5mNnk5OTZxNHY4Q0ZUNlpBdzJ1QXhsS0hWRGhBdHFSWGlHZkxJL2ZKSFRt?=
 =?utf-8?B?b2lEdnJNaE0rd0VkZU0wU09JK1Bid2w5TDBBV012UTFvSDIybWVrYWlQdTZC?=
 =?utf-8?B?NC9Kb25CT3RabExmY0s5TkhmbEgxWWYyRHhJVFN0S3dPZks1MlppcjhrZ1ov?=
 =?utf-8?B?cFJRb3BYMWw1d2kwaG1MU3ZWUXNtYVIxekkvMUhwWit6RWNjMDkybDVGWVo0?=
 =?utf-8?B?K0ViSFlrbHg1ZHRWVEJYeUQ4V0RpUmphdVFnanpvL1ZaOGxobVlQK0R2Qi8v?=
 =?utf-8?B?dmlBdjVZSkFGK1lxU1E2M1pwUmVPRmJaaDBRdERzdmZhM1dZcTZwUnYzUjJO?=
 =?utf-8?B?YVpyTG1tYWI2Y09mNnp6TEUxWnZaZFdEdHlRUFR0NnZ2UHVQc1F6RTN0bXND?=
 =?utf-8?B?RkR3TlZPT2cvTWtZL2NsM1FNVkorTmFmNERVSHBVUitUM2RCTTZUa3RzRnd3?=
 =?utf-8?B?VE5ORGhXWEVNd0xtL0doN1BaNytYdXJkR2NBd0gzdkNmeWFkOGFFUitTSDFE?=
 =?utf-8?B?NnA3eXl0aWlEK3JmT21lYnE4Z0l1K2lmNE1nSCs3ME1DM2tIaWR2MnBaeUta?=
 =?utf-8?B?NjYrdUdRVG1CcThJUEliUjBpYWRuQTBWd0ZGK29sSU5tMVZuVm5pRW9GalVk?=
 =?utf-8?B?ekU4d0FNMnhSZG1ZZmM2Q3dLY3RKazJjdHgwNHp2aGFqeVdqNkQ1UE5FVVM4?=
 =?utf-8?B?dWgxbDdZUUtjNW82NzFCZVNvM3AzYnV5UVQ1TmpKT0V0MjFkN0RKNVR5SjVK?=
 =?utf-8?B?QWt2dWlpaVdwOUMvWlYxU01ieGUxOHZsT3V0c2k4T0NYWDR1enhuN255NUh0?=
 =?utf-8?B?VkZvTWd1Q3crelpEenpmUXZadTA1cVJIdnRmKzg5RGhoWWdzQ3NQRzd3dEdY?=
 =?utf-8?B?d1QvZHZMZ1BRK3VxanJYdTFSdy9ZZXFQWm8zRnhhd25oR0NIbm9RNWsrdmlR?=
 =?utf-8?B?Z3A2OGJBeFdJT0lCL002QStFUk1lTXBUdFF1clhOUTROTHFkWFNqelJLeUFz?=
 =?utf-8?B?K1JvYjh2MG9GMU5Eemd5R2hmS1VMVk5KUkhQVi9ubEEzNlNMbFpzQ3FHS3VV?=
 =?utf-8?B?NWRDalBQNnc3b0REQSthZDRiVTk2K25YcExSNzRXbHNCdUxoSCtpUUZ3QmNu?=
 =?utf-8?B?QzZURGdrSUpxMmJGL1NxV3VLN3AwS0dUSGpiQnYvV2R1STFNcEdTY2VpVC9w?=
 =?utf-8?B?T3hNUGxvZzdtTUJPRzk3Z2xpbW1SaFVITnlSaS9USVhZdGc1a0VQSHZTbmZQ?=
 =?utf-8?B?cmpQZUpndDRCWVBOUjNHTkxVSDloWkxOSksyNmFhZG1XL1Z3eXgyeTVQZUd2?=
 =?utf-8?B?SmJPU2RiZTB5RUhobXZNUXlpOUxLSmxIRjdlWVRVekxOWDVvcFRjazFxaFVY?=
 =?utf-8?B?anlnT3FQTnJmVXQveDd1KzZxZWtmNG9GTGNIV3AvV215UUpVUTRxYXZFbm0v?=
 =?utf-8?B?SUNYYWw0dGtBUEJBNUN3RENWZFFSc0hSSW93V2g5RytDN0JhazZiQVYwM0Vu?=
 =?utf-8?Q?q+skoObKP+1ucJ0wielNmyxc3zPH8QpPBMuWQjl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0RGT0RNejNNVGpKRE14YVNPZXlqbjhBaXFmeEtrdjBWNjBZMjRiK2RmMDFn?=
 =?utf-8?B?SDgwZzdodnJJWnk3RkhsM2dDVVE2cXlsREJ3aFpKNHM4bGQvQlcwQTlvK2hF?=
 =?utf-8?B?Y25UZ2Q0RHpLdW56ZjBaZUFFNFRkWDhuOUVLSVpnZ1VSTXlQMFlSd0UvMXNZ?=
 =?utf-8?B?RnhMRkNrUEhoNHFwejVmV0Z2U0FnV2M3b0x4b3RuRW90WVU0WkpPcWt0VVN2?=
 =?utf-8?B?SWxMYTl5M2Z2VEEyVnRjYzN1bXVWbDZ5Q0NCZGU4MUVWQmtjaE81MzZadFpo?=
 =?utf-8?B?UmdLV0pQV0lHVUVpRlN2cm9MQVB5Uk9aZVNEWG5oNHRhWUJDRHNtaWxTMXo3?=
 =?utf-8?B?anVhOC9IRFNPamJpaWlhc0xQelZHVHMxQVZUUHZaNE5SUXlXbk9PZ3Y4c010?=
 =?utf-8?B?MjRtSUEyc0M4TVlWcCtnN3VzRWI3UEJVai91dG9ZK3MyaWpSR3FQUi9Ld2di?=
 =?utf-8?B?WHFoQ3hYQ1ZvTlVNa2RiQ3hnZ2V2Q2RmWlJjK2ltakFVWEsyaFdXZG5WQ0VW?=
 =?utf-8?B?NHp3U3ZtelRxUXAwU25ia081aitWSENhb3hQbUZWOHFSWE9ENGdseGl5ODdF?=
 =?utf-8?B?bG1aWXI2dyt1U1BSSVd3QkE2Q1N0YzdsQkxHTkFoQTZBVmtLRTU4dHpiVTJ6?=
 =?utf-8?B?UnQ1Ny9rbStCcWRUeWRGblJoSERZbURnVmg2ZElDUDg3T0RKeUs2Q2pGRXVJ?=
 =?utf-8?B?bFVWVzlTZXBYdTl6OWlpNEdMUVlvYm9zSW5jVEpjcG4yc3N3UDBMSE1ycWl0?=
 =?utf-8?B?cHhKZ2JpQkhNc2xZSUhWajZ3Rm4zbWFPbXlKaHNmeFFibDZrR3NnOHhtekd0?=
 =?utf-8?B?LzVwQ1RQaCtSaU5IdlIxNTh6ZnhLaTFRWXVnUUZyMTh5bnpCaFN0cmg5MHdG?=
 =?utf-8?B?YjZwcUtBdDdVNGZ6dCtmbERNcTZEajhhYlF1OFZ4SEpLUXRvV3ZNS081SzdX?=
 =?utf-8?B?MVhaczJLZkc2SWRDWlQxbUpDWHEzR29HUW44TnFta1NSb2xuSElOYUlEeUgx?=
 =?utf-8?B?cTBSSmFJaWsxd3ZLTkZmempua01sWkN1MVEvNlVZUUYvTlkydHpsaFJ6bUR2?=
 =?utf-8?B?ZXBVVWdPeXljTG15dmdsNnNkUmhXVW1kMWZsSEtzRmxEZEdVdTNiNUV3WXF2?=
 =?utf-8?B?cWN5NjE3Qy9adU83UTVJWnBBSnJhSHliQnJ6N0p6bUdyRFdhTnNUNFRRVjZw?=
 =?utf-8?B?dHBEZEJKbmxoZXJkZVdaZTlyMjd2K0NDeDhHQitnVzlvdjRQeG5nd0hpUE81?=
 =?utf-8?B?MjluYkF6QVFVUVByc3J0QkxJK2tUeWJXdnc5MlZWS1BlTWhBWmFPY1A5enZH?=
 =?utf-8?B?Wk56TXlqckRaZDM4RjFBcEc5bnU1YldVc1MvOFNRVGtuUHpseHgyN0h0Ym5r?=
 =?utf-8?B?Q2paRmxqT3k2TGFvRWtLb2xydjZEeW5xL0diVW9UNXB6SGVqbVc4Ui8zbDdn?=
 =?utf-8?B?LzQ1d2RMdGZRTlRid2ZJeEsxZmRGWlFxYnl3c0plcHlNUUw3OVpDbnBpMDU0?=
 =?utf-8?B?ZkFvRmZhSVNkWWRac3hEMkFZR2ZlYnIzZVE1VTlVVjBqcUY5YTJqa1dDdkdL?=
 =?utf-8?B?SDBsNmM3RWZoMUp3SlpzUkliWHlEWWsvSHExNWtHZTZ1dFYycGdSbmdrWW14?=
 =?utf-8?B?OGdldHR4UWtKelNhZkN6V0FkdG9MNU5leTBtalNCekl2T2dMK3grbjBlN2VX?=
 =?utf-8?B?MUhDSmpQd3lXWms1TjdwRGFLbTErSlluUjg3a0tkT1hIZmpYQ3VvS0FKZWlq?=
 =?utf-8?B?c2paR1psc2VXNWNhcSs2TFB4K1ZmTXFGUnVKYUI1S1ZETEliRFJGeU4rZnUy?=
 =?utf-8?B?YVJtRXlmS1hpcnZ6RGMrVklOR0xrbHlyTmwzMDUwdDltc2ZUREdkRXNXMVg3?=
 =?utf-8?B?WkRWNFJCUUFwTUtpdjNIb3ozY056UFZFZDQxbWhKd3g2WWlvVDNmRFZKTkR1?=
 =?utf-8?B?UFdWUTNiV0lPVFFTTVY5LzJUM0hHalhUVUpRdVpldkNJUW4yQ0JYRGVvTmlv?=
 =?utf-8?B?QXJNRFBvdytPWU5xdHY1TTBETitUZjRhR0JHdTRrZWlXblJYYllWSzZoME5H?=
 =?utf-8?B?VVJCaGpuQ3J6clVyK3VXQnp2bVA4R2I4a1dHZ0xiNm5Uek04dGJiV1NxQjYr?=
 =?utf-8?B?R0c3UzFFakhQSm9uRzlsUXlud3M1WTI5ZlZXSCtSSXBhS2xnV1pUcmpkenpL?=
 =?utf-8?Q?vGIWXVge03bD2lNc/3Ka07E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6iJNtelddmC4zL7YrDhv9hKxZ2Nu1E99PA9H79MQnfjjxKZLB5tgRlTHTDixGDc5Y1Ar4FA627vmMkZW4BzSadRz4hzzOAqZixzJnvIiKOhZrzHT6gk/ZVCA/W1uULcGo28E98bPiayHN1dmfO3u+/v2xCZxVR1B5d5yGqlx+saCcCzxYDrBwzWL/3o5N2D/K7pTX0R78Q7FQT46XwQnFjL3rIXHmjSnaRxAWX6BQLlSLP/DM0jPIQ4in+J1L8UMtxDMxxrQyhCYVjjfXoftTWsNnClJvKOrj7lh7s/ug47xnpVsCQ4bNimsBTyWAKSfDzwT/s9qzNA9hAQHOOPcj1/dZPAiRakPDGOLcX8sLZ4Ku8weY3GkeZg+kYZQ09UpyrfeHc6Mnc/ZKwYVm9hRBM7x900WcIiVsvTa6KXz4fhBWtY37P4Dn/EgiQVJ2smALOGfZCdGFPbQwKZ4ZToZ9tg56mT9y8QEX/LouM5ArFhrdOYd4mc42MImFXU0Wabmti4qaXJYKFZ4o0/NhLH7ApDkxp+5fJo+JsdqSOVrfgFfj3vENNSKrVPTRA+5ZA0S3f9aGAkeAhE9gIv7acEahkJb7genzVMNFHSa7K+aKjI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7cb7505-d0e5-4b67-4689-08dd03340353
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 16:06:48.9020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15h13QiPyNx66ZNeHJQfi5XZu9+QxJtOU78tpxuGqh+Exwq/b4fbb3kpc3ctVZmLK8XfGht7lw8jmuZD5sk2QylNEPzTb5LMIWPAG+Ch0bOU2WAfLZ19xw0OjDFf2E3c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_06,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411120128
X-Proofpoint-GUID: qcQeipYO_TKNHGyi6gjd4z2QYebn9Imo
X-Proofpoint-ORIG-GUID: qcQeipYO_TKNHGyi6gjd4z2QYebn9Imo

Hi Greg,

On 12/11/24 15:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
