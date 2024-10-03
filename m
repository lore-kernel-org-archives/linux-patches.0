Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300AB3D68
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 04:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727931573; cv=fail; b=AF7sUtBVM1ey1xImCTYTuDU0d06Qz7EcX4ykuc969zVEMt0TcN2AKVAuJx4tyvX0U28XbqX6S9z8Mh7VZNTtkll9QU2tM0b1Ujv8sdeP51583eTkKQZR++i2eN+QwMOBAbS39PRNBz8kqr3tIZQJfu+bqd8ykDnAN6MY4kIkPWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727931573; c=relaxed/simple;
	bh=Hy+Kvjt7bpWTjrtHtdFHIpArCtj2MPTWrvppaNWz6F8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eawi+wE/MFqBRo3mlS9lXG5kv3Mr/6LDoLZYUnfz/v4gorhUmKCyKI0aQwf6RMclbKXYAfPIc6iEV6AFtBMbz/+A1eoopke2J0SHj9Cog8vwvcssHI5h3TtTUPe9Cz55LBwl4mPDNmrmdqoSV7kvc3an2Lc3x5/FEZcMa9t+OTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hx+hfAOh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rBhw4qSx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hx+hfAOh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rBhw4qSx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4934tb0t003458;
	Thu, 3 Oct 2024 04:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=0YgoheydQYn1bgCtHx/4VjH6M98HIrDD+ZVRbaVTGuI=; b=
	Hx+hfAOhJvp9jtpvlCOivJHWEnsfa/LfvscdM22TqQkTsGG/lyK+5qdEKmEMUw6C
	3tQ3Z+/kCJh0bB/afw6RfKwrEbCgLrUpIwrY72jgMXauvQWrLz/zDWWEiTqimEba
	n1J9jIKCghYDGOYsIQTYv1RHEnalDz1It6042CbONCJv1swx0FlE9cnNnW0Sq8s0
	/GmtjqCV3EZmMuI3dFa3y3v3Spuz5LFq1N7OpEIAuV8ZbQqnoXJXuwpiOpJE7+5O
	WQ31L556Qnx5ZHjFQBvwgbCgiN8Zi57MtoHuDV2mRc8+WTmqur6Sd0afGnuoPKpl
	KFdbvIFeFLyW2R9ZQBoDNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9dt36s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 04:59:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4933eEMa028402;
	Thu, 3 Oct 2024 04:59:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x889xeef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 04:59:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=noi1/H45Zm3YGnDvRnRN6SHsMmbPltJUnjEJ4GEjp4Hyx6uYtbXWR+DfVt5K80HMUd4h2PoLM9UuPb7p0jhzUgHSghv94UpxyIGKYbWKrbUMNmD2DKaI/alsEM6vgCek1dNaqnEUqi8lb128i4N/KvyzNnJTCH/RsLY6SonpgszyyMWNBm99UHQz405xUNiGqeaNVZynJ7Ahl0LHKTI2FR4YlILEIXHeKk1RPHzcbaib7n9j7iiqOljEXF1gMFZRYgRUatxhH/Anllpv3cWB/iz0S2+0UcpsPz+qX2raDg7/6f07dtDmyrybb16R8ukK9e9Dki/rV3kLA2Rl4+fXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YgoheydQYn1bgCtHx/4VjH6M98HIrDD+ZVRbaVTGuI=;
 b=ykiqt14V4UdIrr4hLwLWA1nq38W79O+10u+ts3kjCiB8vIwLJLkGhPSnITb4kud4mfWGGSjUIeGNCuh4aoXbYZNu7R+lkCGtwNKfuvNxn9RFgWJOxz2V9bTdwJOUU9tVAV6jw65zSdhIybdXhmr8R47HlPn0q39lwa/f0VnrDEDjGbg4FUZIgcRgs0RkrRbLfuTSoiEK8u3MkPduwGPMBg69i7xTg8QW5hVWfQ+jdEkipTJ62792a+6AjkoX3cOD1al/Z1tZfSUG7vhT1zDEwmDbfLKYserhG4fkjhtEMEebNMG7TAiHfpZRpZxqribDDDLyHWdu+/fE8qrQQStEgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YgoheydQYn1bgCtHx/4VjH6M98HIrDD+ZVRbaVTGuI=;
 b=rBhw4qSxnk/zuDvyBcyceeBmghSEsNwzM/OfYQHg2YuZyTUf0It3VYLb8VIAjY1rLwhxd5VBBeepAFpKNVBE40su1TR08xkq2BjU0dLIgmmLOL8kOhDnE1uYaEklYZ5pcr6syC/jv032wH/92+UzzvEhXfrGS7kZkREQSchzOGQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 04:59:13 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8026.016; Thu, 3 Oct 2024
 04:59:12 +0000
Message-ID: <9f379411-0007-4980-8e22-6c5caa4429a4@oracle.com>
Date: Thu, 3 Oct 2024 10:28:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/538] 6.6.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241002125751.964700919@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MW4PR10MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: a1de3caa-c28c-4555-aa36-08dce3681f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODJnQ0tCOGE4aVJ6OEVYeFZCVE03V1NBQWF2MUYwc2hVSkJlaDdFTmFqTnZD?=
 =?utf-8?B?U2pQTFFOcW0zUjRBdUlwQi9CeTRjS3pPa0VYSTZHQmtadzk0YllhR1BZRXFC?=
 =?utf-8?B?QU1VZTVxWlVlQVo1V09pQzc0SENodFgxcXJOV1p2OVJEOVlkeG0xVkRzbzBG?=
 =?utf-8?B?ak8zTUxwNkd6N20zL21TbWw1NjQzSU56TkxmaldqS21jYWVkMVJLeDFteE93?=
 =?utf-8?B?Sit0dEJvTEdEc2lFR1RSUHhSZzNBZ3MzVDlHTjdYdzRpVmdtbVRIb2c0QUJ6?=
 =?utf-8?B?S21qbkhIb2VHYVF1YStxdWhIRmt2c29TNndFMjJoeGQ5RkxRbkFVb1JiVjV5?=
 =?utf-8?B?KytUc0tFMDZ5bXVac0NwUGVkMzQvNzRMQm5FV0JiNlVxam55VExDWU83azht?=
 =?utf-8?B?VDJ0MXJ3bHdPVmtnaWJ5L3puQUNGZGNiL2RDSk9VTEprZTFSVUtXRGVaRjZo?=
 =?utf-8?B?SHBXTFg0c1gxa0czaC9HNXNoaHVubjdGYU9TRHVtdEV1TFJ1dWQ5eUlIU0w5?=
 =?utf-8?B?NDh3NUFmM3hFenpPTVpWWlQ2VER0bGtsOG9jV1RNQlR0Ty80d1htQjlvMllt?=
 =?utf-8?B?KzA4Yy9CdlNJTzBXRUluU2RQOURZTkR4cHFkNlc4QVdZeCtqYU80K3E3UWFi?=
 =?utf-8?B?TGFNb2ZwLzFMS1BKN2MwalBMWmd0dWZ0YmtkSkVKMFZqaEo4S0hGUGt0RzlS?=
 =?utf-8?B?eHR0Vm9zc2piTFNWb0VOWnBhZC9UWkk4cHdieHNOSEovSC9WWDhyRU56SVY5?=
 =?utf-8?B?azZvNzhDYlpweTRDcTdxQW9KNm02RmhWeU5TRFNaWXJPYnJBUXZpUkU0cm5H?=
 =?utf-8?B?UXVXZEJWTGZxamlndUpHeGx5SGJiRHlNVHlmSXA5N0dFOGNrdEI2enA2c3Ni?=
 =?utf-8?B?S3lUTW9Sa2oxbmRLZkN0RjdVa0FydXZqRllUL2JGQzJtbmw1aE4rcVZtRVg2?=
 =?utf-8?B?V0NiR1RmSnZmTkRRMTJKamJLdC9rS04wQUdTQ1Jmb1JLK0dQODNCeEF2R21I?=
 =?utf-8?B?ZzV3TjBkaE1rK0xCZ2xiOHl1d0dFVXZLMUsycnJUTnBXZmxzQ3RxTzVvNWlZ?=
 =?utf-8?B?UDVmOEhDOHcwNW9sdndzVFFkamlKT3g0dk45WEd0ZitlUm1qYUNOVk9lVko0?=
 =?utf-8?B?WC9Jd0RjWWUrblVMcy9KOXp4NjZoeENKVzk5TSs3K2Vmbm5qTDdOZ2YwSWhn?=
 =?utf-8?B?b1dKUmtqSGhSRWRTa0lsak5QVWg1UDFOUHp1OW5uekdpVG45VityeTI3UjVX?=
 =?utf-8?B?UlYrdnY5MThCQkRBdURZdzJlZk9veTB4TUlTQnRVbGptOHdIZUllRlNQMW9W?=
 =?utf-8?B?aksxTGVpVGVtem1qdHdoNUdpUC9ydlpuL2JFOTZrU1dKOWpENXVNM1czWVpx?=
 =?utf-8?B?NlhMcSs4VmlWZExRRHFLbThxSkJkQmlucGdTK3NhSnNpVFltbWJEd2IvMk83?=
 =?utf-8?B?cGU5dUtJTU92ejF6OFR3cEhWNWI5RHVGMVBPMm9Jb0llMzJnalFqVVZzdkdI?=
 =?utf-8?B?QlR0VXU3SlVodUxMb0J4N0hFQnhvdFFYUk1tUFUyNGhYaENZYWZwS0xDK015?=
 =?utf-8?B?NHA2K0RZdS9SVGF6M2VxaSs0N1MyY2YzSmJBMVBmUEhlYlN5NXl6MFVPYWdy?=
 =?utf-8?B?VFY3TVNwUFpVZzYxaUQzV2dtVGVIcUljNmdORHZGODFPdWhEYzBPMk1IOXhU?=
 =?utf-8?B?aENYVW5Pa1pJZWJFbzBoZm1pa05rMk9sR3QwcDg4TmVvM0Q3TVQyV3J3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vmc1ME1KMkE2TytHMnF5S0pBaGRaSjZoUytHVW1uTTFsUXk0Um00eTc5K0RU?=
 =?utf-8?B?bkhSelhYS1dTY1k3TEJ5ZER0N0JnYmsyS05RU2kyR3UwZ0ZaUi9IVUE2Ulo2?=
 =?utf-8?B?NkNILzUzcFBUSWhXeTJLdkpDbEEvUHpJVWRMQlFKRmVsN1pydStmV2Q4OVUw?=
 =?utf-8?B?M0E1dzB4a2g5cDBDNEZIM3dFMktETmhpTkwzZWY3UVczWG1YTjB1Q3plcFlz?=
 =?utf-8?B?SkdlY25QQlFsUGc0bm9wbDgzNm1WV0V4K2ZLVWdUY2lMTEN6TWw1cXgyRE50?=
 =?utf-8?B?V1Q2SlpETW5wekU3NkNsNkJjNXZTelNYNFFNNVpWYXIvdExhVkRLZGtyY1hP?=
 =?utf-8?B?TEFrMldOUVdSRHFOSUY5eTMyVlowOXJCZU9MUk5iKy9ncGc1elJiYUdlMFdO?=
 =?utf-8?B?TCthQ2U5YjFmRmN4N2NPVEdYdG5rYnplRjhIc1d0bUpDbTE1ZnZlUjkycXgx?=
 =?utf-8?B?ZzlSUVNKRXlEUnFSV1BlQ3JsZDhueUYwTjlRNU9DdnZqSXp1NEFYZ2ZRMy9W?=
 =?utf-8?B?RERSUSsyNC96T3hlbTVSaFB2aThRcmg4cGJwZUJ3emVDQ0NHV2hnMEhId2ZP?=
 =?utf-8?B?MGo2ZFoyVnkwUStmUWVyR1czK3VCekFLRlZmU0FCT2JTa2VQNnhXdy9uckJL?=
 =?utf-8?B?c0xwRTVlcVFsN1pOMjZjbzI5L3BpZVhTTS91bFl5Y2hVQzNtRFdoMWI1MDNy?=
 =?utf-8?B?TU0ybmNuWWJiaitKODdKR2tFMXk5UEFkVVFpbVdlUFl6Z0JFYVdrM0xiSFVx?=
 =?utf-8?B?VkYwQzdkaXdBck16dlRBVk5xcnEraUFGUVVGbktlMGZWMkZnZlpwaTN4NURh?=
 =?utf-8?B?VWVPaEozVkUrRk5JOVlwc014bEQ1enhWSDVUVThMQzlIeC9MQXVVY1R1OHlW?=
 =?utf-8?B?LzhFTGowNitKSnhaVzdnZmMrUVI0QytaY1gvbnJERjlmV0xjd1lHUXRoUEhE?=
 =?utf-8?B?WkdPSTRiVFpFTTNRemVwQVUwaFpWMEtXeVF2dmh4M2I3U2owQTRoSWVQV2Ri?=
 =?utf-8?B?dDhqVWxNS3JLREsrUUZYMUJEc1dZVm90WkVRNnVmL09PMFhVTCtZcTMwR3lx?=
 =?utf-8?B?bzhaYTlmNEJRbDN5ZzJiTU5HR1BNWTB3TXRzY3BpNElqeTBNZzArUnprNWlj?=
 =?utf-8?B?bTN1Q01MNVhob243WjJBaTJKbldibGdnVTZ4Y3BTV2Vvc2xybFdLUTFCSkhJ?=
 =?utf-8?B?RHczV281N0I1Nlo2V0M3aE5TZ0pKc3FGSDU4TkJydkJmR3NSaU12RDJ3c0Rq?=
 =?utf-8?B?VXZYMDVlazI3THN6VlFDUnhja3h6dVZWT2ZyVFBoNGlJaTRkVVJRS25zN1l1?=
 =?utf-8?B?R1Y5Wmprb2ZHSnRSZVdMZDk4dlJxL0tnMG51clZGZ1BVblRDcmRnZThVVUN5?=
 =?utf-8?B?dW9LeS8wOFB2MTQycHlpd01MVmViOCsyMHNsbkxjcXBDQ3h2L2N6alllOGtv?=
 =?utf-8?B?SkUycitJMTJzMGMzZWlISGl6WXFxNjF6N0ZuQmVMMlRiY3RLaDYrWE91RnVx?=
 =?utf-8?B?NXgyYXlVSDNodUNTUEUwZlRMeForNTNJVTkxT2dFbVcvSG5OVlJsVTMvQkcx?=
 =?utf-8?B?anNOeVRodTFwQUw5eUJSWDFmbk9PZ01lcy9ramNrTStuQ2JraC9tU2pYL3lF?=
 =?utf-8?B?Q0ZXT0xBNkZoTjZzWDVyM04xaDd3UDY1UmdTajZjSUtROXJEOXljUEVGOGth?=
 =?utf-8?B?ek4valBRVUdrR05NMW4xT1NpZlhjdGMvMmhhMVNWdlRoTnFRaUJqMmkxNnll?=
 =?utf-8?B?cUdqQ3dadDFKNkRjTStwVUE4bVY3MWhwMWRwUDNaUjVwdUtXdUlSVHhyOTJT?=
 =?utf-8?B?NVJ3OVlSdzBMck9ZNm9wd21uTkVWZTM2TlJ1U2F6TUV3dUp2K2I3enF1RjZ0?=
 =?utf-8?B?MjBKOG9nS0NNQ0hJUlAvVngvZHZNdG1oSWZCL3pKTmU1MkJUUHpHcnY4Z29p?=
 =?utf-8?B?SUJYZDYrME9wLzhQZEtUSjM5Qis0aUgzZlJ2MW1yTDRmQXg4aHVpRE1UbnJR?=
 =?utf-8?B?b0JCWEZPU1NDZXZCeEpxYTJiTUJMSE5xeFpybEZaaDZtRHUwRGNqNllNMkJP?=
 =?utf-8?B?OUNPcUpoMFNlUVRzN3h3ZkdMVkhxMis4cmsyRVdXQmgxY0dQNlpmVHNMOWd2?=
 =?utf-8?B?YlRQTDdCT1N1d1grcHBBWG43aEw0dWd6VThqNDYvQmIxek1wS0dGMEFyK21p?=
 =?utf-8?Q?57L/GGMBtVVoAjLI9DROEWU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xq2+XryOD7FZjy3Aby1RQazs0grKwt7dNv6DkeXS6pxq+YwJOA0bFOgmKslPNxwDCWaE0wfJ0No5Hw3kyAxeczcf9rwrCJEF/J/yI/gPJzR7tQHFrPKPZlLq6npwCiI+NeFsOiYo3TAiX5VVJN5Ud8lv8m4Rv97U7krMTYKUKR22G7GKTZDOjH1BzohKC4mjnkeA6G/7k6fOIB32gWW1mohiglayiMESibvFdjb8Fe6HSThZhs1N+fubvyevb2cBFg+dGjy4c4bBJQ+us2f4SEEEwDBhx5094HhmnSjuKv2Vi+WoJzeoEWVBdlMFl+ppPY2Tc3PFHWcm42jpmFENndNWQmYbk3qnj8x+CADix8wbUtWYBXbPYuWR5YA2XlPpn/bHMDs0hoonCtPHIGB0Y2CWtDg1gm4DLHq9PL6bNmYdrhAWqH+KXouXcwy92H70xAotrbe6vdiQXMG1qCDcUbFs8FU1dwnPMfeMv26gFWUrnpraz9nVDCTdl2ICpZcv/zvVazmG6yhUROaNkDer5RHNiMOLqg9ypSW+Iyezguj5eQnKe0saNO3TOiXY8CS6uj0FD9c7Yd7AZ5019y/tHsBThZixreJv0xCIsMLblLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1de3caa-c28c-4555-aa36-08dce3681f8b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 04:59:12.8349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOtdvQXkrxMuwuzK3iJTMq9vwiPlHc1jYFOzvaIg0YELyPtS7PQW3sBh/K9kmny0UOt2bCnCeBaq3HHN5MIKILFs5VHydMxynzlgJlzHfmS8tGDs6Ec2WTiDOrCYzThW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_03,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=764 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410030032
X-Proofpoint-GUID: eah7KkC1hh_vjR34DjnGicut7F7-BJkR
X-Proofpoint-ORIG-GUID: eah7KkC1hh_vjR34DjnGicut7F7-BJkR


Hi Greg,

Below are few build errors in libbpf code:

Here are few libbpf commits:
> David Vernet <void@manifault.com>
>      libbpf: Don't take direct pointers into BTF data from st_ops
> 
> Eduard Zingerman <eddyz87@gmail.com>
>      libbpf: Sync progs autoload with maps autocreate for struct_ops maps
> 
> Kui-Feng Lee <thinker.li@gmail.com>
>      libbpf: Convert st_ops->data to shadow type.
> 
> Kui-Feng Lee <thinker.li@gmail.com>
>      libbpf: Find correct module BTFs for struct_ops maps and progs.
> 
> Andrii Nakryiko <andrii@kernel.org>
>      libbpf: use stable map placeholder FDs
> 


+ make -s ARCH=x86 KBUILD_SYMTYPES=y -j32 bzImage modules
In file included from /usr/include/stdio.h:33,
                  from 
/builddir/build/BUILD/kernel-6.6.54/linux-6.6.54-master.20241002.el9.dev/tools/include/linux/panic.h:6,
                  from 
/builddir/build/BUILD/kernel-6.6.54/linux-6.6.54-master.20241002.el9.dev/tools/include/linux/kernel.h:11,
                  from bpf.c:32:
bpf.c: In function 'bpf_map_create':
libbpf_internal.h:107:10: error: 'union bpf_attr' has no member named 
'value_type_btf_obj_fd'
   107 |         (offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
       |          ^~~~~~~~
bpf.c:172:32: note: in expansion of macro 'offsetofend'
   172 |         const size_t attr_sz = offsetofend(union bpf_attr,
       |                                ^~~~~~~~~~~
In file included from bpf.c:37:
libbpf_internal.h:107:52: error: 'union bpf_attr' has no member named 
'value_type_btf_obj_fd'
   107 |         (offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
       |                                                    ^~
bpf.c:172:32: note: in expansion of macro 'offsetofend'
   172 |         const size_t attr_sz = offsetofend(union bpf_attr,
       |                                ^~~~~~~~~~~
bpf.c:195:13: error: 'union bpf_attr' has no member named 
'value_type_btf_obj_fd'
   195 |         attr.value_type_btf_obj_fd = OPTS_GET(opts, 
value_type_btf_obj_fd, 0);
       |             ^
make[5]: *** 
[/builddir/build/BUILD/kernel-6.6.54/linux-6.6.54-master.20241002.el9.dev/tools/build/Makefile.build:97: 
/builddir/build/BUILD/kernel-6.6.54/linux-6.6.54-master.20241002.el9.dev/tools/bpf/resolve_btfids/libbpf/staticobjs/bpf.o] 
Error 1
make[5]: *** Waiting for unfinished jobs....
libbpf.c: In function 'bpf_object__create_map':
libbpf.c:5215:50: error: 'BPF_F_VTYPE_BTF_OBJ_FD' undeclared (first use 
in this function)
  5215 |                         create_attr.map_flags |= 
BPF_F_VTYPE_BTF_OBJ_FD;
       | 
^~~~~~~~~~~~~~~~~~~~~~
libbpf.c:5215:50: note: each undeclared identifier is reported only once 
for each function it appears in

Looks like we have more than one compilation error in libbpf code.




Thanks,
Harshit


