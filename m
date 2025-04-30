Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F8923BD0C
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030221; cv=fail; b=tdcTYU2jlomGEOkJ4W5cRQuKmJvfmf2Vl94IwJ9OjP80EGHiUo5WCxd26KhNlOYmMDTWjoixNSPhUmj2Zj86kl4oWdDH50ZyRyIElN6p4Gsxul1Vm0HCumjfpQ5LqjqEO+UWa7AqIpLCpjq5FZEObAAXqJK1MdUYQrmEEL+BQJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030221; c=relaxed/simple;
	bh=ab+9E3BTUlxgisNkLT2KxUiMOOtYkLs0p/3v1IBtyBQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rf7uci46dtUtqr4NK64mmPw5iSjAihTOfv/yJsqlstcbZJkvTE4nn7Ly5WWmOHry7/fbhmijqlxQKko/q3lAqVZj+g38QEAATGwedX831B/gSkUfna39H08fotYJqoZDfh0RGTXo3YYtcu1pUnIKrvVPqiOFUSQt7APRN+8GEqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AeBSmARL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P3eHMMYU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AeBSmARL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P3eHMMYU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UFMwgZ017727;
	Wed, 30 Apr 2025 16:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2Ur0kWLjV6IEUYeIGqVKSlMbbDeoBTGIPH5G+utVUDs=; b=
	AeBSmARLBA0/i1K1/HdshqRXwAIOrQz/C4Q3bwLvTiGxTx3VR3X3NiwZWaBONXYz
	YCHSTroRtCehazPttil40P+hncSha4doIST1rPPgMkdJoA2Tz80KbvL7VMrvBO6V
	DZiy/fia1FQuVXfEJeXEXHIEjBRPynyVJLbbWDE+jAmp4ytWllRZMKWMC5G8KhKg
	jBwmvcrU8odcVs0De9Q0XSBq/wsZ0FuJo/PvgtIxmoNbqDBmv291S69tzjnfkQ1o
	T37DXPUzINgA9bsyjZafdV4mbKVzZYVPt4ZiQXfPIDt4Z9PmU+6ZjGHE9ps1hlmP
	qzLFcTLDoQLU/1H1j3a9qw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6ushkn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 16:23:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53UFdlFK033376;
	Wed, 30 Apr 2025 16:23:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nxbhqet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 16:23:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yi9eYPxP+hBy2AIuycM4B5B3BBQUg487DXx0T0kORJ6m9a5hCbmFPJtY/3O+AyCM6A1ko8wSfTygrH59ciVJxSgNLrPjflFWPSq3QzBmxQLR2H1qgy9cZgOLlKQI0+0RNKgOiia47WVIYaYRpTxwwAFkp3tUqztM+JLBEvugU4GElFz3smZYjAmc11t5F/Dm+l2ULbcW3ZBU0/w3hrAgMpE5nJhcxqa2xWJCt/hPPmDc9OAnU2ZwqWM4bI+4oRDwynmXOlHNJFcPUvg4CWzrbKgIOvs67HqLdCMPOW4dS7s+uVYbIwHHuB2S7x/PAVUheZCXMJlhEsMz8e+rgxtqLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ur0kWLjV6IEUYeIGqVKSlMbbDeoBTGIPH5G+utVUDs=;
 b=FU8hmf19Vb/qnS+Ni3vUiWNTToPtHEOHwpkqZm6XYPpUl7dsOY0Whx47JJnXk13F1uXjQ+bm2vlnVJohna3bXGFq9fGa5FGe9Hk9/MPTJDkmCdhJ3zyrHdpjAM9cctscNbJR4+kBb5jIfCf6S1iWQR2E3l04tdw/PY95/IgyuHR+7S8qp5z4n276z3AZv4SMsPTqzamWihxXiJDwhst+14nhY8ifDXQ23FaZqUDdTgYHF2zc6xeP7D5beGKcTPkE3h3Vnly+y939y1ec9PlVDO7PJKHkzc3CrCpbdKIox/PI8Wl+p1Zm2x8BPQYj6pIxS40kjDbyhDPdi2sduPQ6VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ur0kWLjV6IEUYeIGqVKSlMbbDeoBTGIPH5G+utVUDs=;
 b=P3eHMMYUekaeswieJ1V8kINlLnXEfIRSj4W/NfFn8JFDOvBXAYW6glO2PqEtxVMwTCiRamvAFhSuO91BiKMk+v1b92oI9DLKk2eXYBlpJ723J0UyN5BRd8LNr4tMpD8evqsY+4fOWSDXT/C0UPsEOkOTfiPlrZyLAvbQIuKmsDo=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ0PR10MB5615.namprd10.prod.outlook.com (2603:10b6:a03:3d8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Wed, 30 Apr
 2025 16:23:19 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8699.012; Wed, 30 Apr 2025
 16:23:19 +0000
Message-ID: <b8c4d960-cc66-437b-81fd-aeaafc64a38d@oracle.com>
Date: Wed, 30 Apr 2025 21:53:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250429161115.008747050@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ0PR10MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7ad013-e338-47cb-20c1-08dd8803518e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGxOdVd0ZjBORmFxeHdYZGRPQzRKdVB5ejJMYXNIaysvTm44aWkraktmanBW?=
 =?utf-8?B?QUM1ajUrOHpiWlRzcnA5dkEwUkxUMTZQaTA2OS83QlBYV1Q4NDhHWUp1WjBr?=
 =?utf-8?B?QTIvQjhYcUQwUHg3SGltZWo4RWg0VkxlODF0ZndEWWVLM1l2WllrSnpRUmQr?=
 =?utf-8?B?YitXVDFSYlZ6eVdEUWRXM3ltR2U4YzRsdDV3SjZCbndTTzNlMWowODZQdmdL?=
 =?utf-8?B?cUxZQkE3VDJ5cStrdFJwQU5iN2c1MlkzWlJudGUycVowLzhCRjBuS0Fzaitm?=
 =?utf-8?B?QXFlSWN2S2ZEeFZvMEc5Z3FnK2UrRVNVUFMxdHFSb1B1RFdnU1FLa1hpQ3dN?=
 =?utf-8?B?U3NTVHdPaStPN0cyblFxVk9MVC8va3JQYU9YajRGNHE1YzRJMms5OWpKaWNC?=
 =?utf-8?B?R1ZuazRxTGMrK2liaVRZS2tuUm9YVUd5TjlLVnYrbE5NYXBzWWF2bWQ5VEZG?=
 =?utf-8?B?cTExR1dBVlZvcUlsdHNvMXFXMGF4ZnJBRnFLN1BGM0Y5ZnFYQmRjb2R4dS8z?=
 =?utf-8?B?Yjl0eFMxTExGSktMSmFCSDdWNDdEUWcvc2JHZ3B1SDB3UFl4WlVGaUEwbjVS?=
 =?utf-8?B?eThQNXY4U2lObTNxYm1hbzFvT0V2THAzWjkxdk1EMDRHT1J4T0NyYU9rTkti?=
 =?utf-8?B?aDk1RjhUT0VlOU9qdDF4bmRVVVJYdWJFOHBHU3Q4clArVFI4Q0ZiT216bWRG?=
 =?utf-8?B?amhIUEJCVzd4eGNPTWNMdnRtYXZNejNDVi9pTUxUVmROMmw1MFZYZ0lNa0pV?=
 =?utf-8?B?Y2tOaGw3cHV4WDFwbSt5a08zeExDM2wvNFZjQXZCMlVLdy9yVmR1NVZERlBV?=
 =?utf-8?B?UDJDZlRPZjZOOTdkT0dUR1ZvcW5tSlR2ODdLc3doaDBpdkF4TzJPUzN0ajFr?=
 =?utf-8?B?L1lPL2lCa2g5a3pvaVhrand1SWswdzUxb0Znazc3b2ZXY21oc1lHMDdQejZI?=
 =?utf-8?B?c1BRT0pQQVJBSnYvSTlqdlhManBmTk40bDFBZ0RxbkRpK3F0Z3VMYk5vM3R6?=
 =?utf-8?B?a25yQWNvVkUrTUNLMksvbUdKNHhycXlzeUxleVJIU0hxdXQremgyaCtiZVR2?=
 =?utf-8?B?VmVQbHZ0dUFVSG5HbWlyVHpDWk5abEN0RVdyc2dLQzhFMnhUeVh3M2tubGds?=
 =?utf-8?B?RnRIVzlLWk95YXF4MTFSZGNsK3pjZHpwcFE4Z0NHTWJiMExaWDVGWWtZZnBj?=
 =?utf-8?B?bldxZjlHRk91UDAvcFBpOUtnV2grckJvY1d1RDJKaEdsYmtWYXN6TlpZUHc2?=
 =?utf-8?B?ZkladGp1YTFxcFUyVTZBY2ZuZU9Ndk43QUN1UUlRKy9BZnJmQ29iMW5tQXpl?=
 =?utf-8?B?aWZ0dWVOSjV6ODl6aDFQcUdQZmFRVUk3NllFa00zM2pSWGFMbGRnVUN3cGZv?=
 =?utf-8?B?WVZFYjVoNVEwWFgwN0RHYVBKejlKUXZDNXBVZ2VtODlxRktoTDJ1aitESmx4?=
 =?utf-8?B?eHB4a05sSlZhbWZMQU9IdVpFWEgycGdsQ2tDUWcvWUpIYURXdUd4ZVJrT2VN?=
 =?utf-8?B?dVhvRUc2SXc2cWQyampWVy9ha1FpaG9ibHdiNUJuNitHcWRmL1JuNk83Qmdt?=
 =?utf-8?B?eFpoUEdxdHhEdXppV3c3clRKcDlFTXd0dXJCOG9XM2RsRFJ0YURyWWJ1OUt4?=
 =?utf-8?B?VFhQRTFVNzNIUUdiYzVnT0o4QmJ6eDZwWS9EVnJFU1gxNjBvWVdTcExzVWlI?=
 =?utf-8?B?a3gyYk9wUmZVdjVoYVRUYnEyNG5ISlBkM2l3UnRDSFBJcE1GbytmM09SOURr?=
 =?utf-8?B?Ukh0Qk41T09sNG41SU5zNU42cTlVd2F2Qzh1R0V5SHRzTzJWMGdIVHZGckw1?=
 =?utf-8?B?Q1I1TVhvSTJTcmJMdnUyRkd3ZHIra3NYZzRwcUlHeEdwYlJsVGZDYjY0TUZs?=
 =?utf-8?B?NS94YXlZdHZhUEt4cmdFd1dFZm11c3lKTlc0UVRjVHpPdVJHa1NtOVdzVnp5?=
 =?utf-8?Q?GCXVg7gfDwU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WExzWnJUTnFTM2JoSFRvUlA5VVFOYXFpZk1xcHJMcE1BQVhRTkFWbDNqQlA4?=
 =?utf-8?B?dlp2RnNULzlzckxMVnVNZ1lZMXNHcytiMHN2REpsbWZlVWhBR3VBZmsyR2NV?=
 =?utf-8?B?YzVOcmZLUmxVT1BKbzJBNWlpRTdHOUNTZTUzd29TUTh0ZmRxSzFINmpWdVJO?=
 =?utf-8?B?ZHBQekRLcjN5czNHdDdSMklPVG0wOExhYXdteURhTGJPRzhNN0l1NnJIdEls?=
 =?utf-8?B?TFM1NDhUQ1ZNd0xmbzQ2NDZ3MCtGVUJOUGp6NHI4OGVJTCtFU3FjZ2FFbUFX?=
 =?utf-8?B?Y3EvMWtnWUpvRE92c0pKRHVNOWVSbHpLSS9PUDNzcjRValJ5YmtkSVZEOHF6?=
 =?utf-8?B?dW9tbWRRQ2llVUs4Yk5RMkdaeGtISzFVNjJHaXJzQk1PczZ6MkZVcDdsYnF3?=
 =?utf-8?B?dGY2eDhHajJ4UW0yZ25ZaTNHWkJtMUYvRC9Nc1pPajY2aXFJTTFabjJjeUJ1?=
 =?utf-8?B?NTJFeWg1ZWxTaFNZc2hKdzQyT3FxbDV5ZXpMMlI2VTcvVlVKa0FvejNrNWU0?=
 =?utf-8?B?SEhmNFN4YlJ0TmM0azUwYm00WnlyRXViZlJ4NDNnUHFJVXA3Z1JoblRldnZE?=
 =?utf-8?B?djluMHB0UHR3cWNrUnBESjFWWGE0YTYvTWRCNlFVMkozOFIybml1R3ZvSjVE?=
 =?utf-8?B?RnNNbFMyZzlQREoybXQxSllPSlhxRlY1QnZvT01PV0dhU29ieGhlM0FsdnpK?=
 =?utf-8?B?aGYveGRzRzFLcWF1eGJmQTVMMTREQUlXenpnTjFkQmtEeEFFdlNXZlYxL0E0?=
 =?utf-8?B?eHBDL0EzMWQ3akFpMk5CUjREdFdtcGNBZEdYQTRtUThXaGJhb3pCcndzNE05?=
 =?utf-8?B?KzQ2OEU4d01KajdWK2tuWDRZZzI4SWFnN1JkR1Y4UUhkckRWTkk4dURHYitk?=
 =?utf-8?B?OUZwN3RNVVJORXBPS1ZLYmxxeGFhQUk2QVM4RXJjRGY0dzBDc2NuME9GVUdi?=
 =?utf-8?B?aVVsd2NJN01QZUUxOEs4czVJNWo1NjBGbGR5cHphMHQyTXB2Yk81N0NjNUN0?=
 =?utf-8?B?NmJCLytpK0hnRWh6RVByOHZUOE92cHNsWEZaaitVQ3Blc1kydVFsakRkN1pt?=
 =?utf-8?B?QW84TEtkRWZWT0hUQlM5NkF3cndFMTJtOUkrMlI1dE13VzhsU3FLUG1zMHMv?=
 =?utf-8?B?QmpXWlUzNlVtdUc0bHBQY0UyWklUWDBzWmVrMFZZS250T0YzdDNVaGVydGxv?=
 =?utf-8?B?T3RpbTBsUkQ2RHlQbXF2YnRVQmFZZ3UwZFM3ZjRJMWxMcGRqNjExV0JzYzl5?=
 =?utf-8?B?S0JRQWt5OVd4NDI3QmFXNEhrTUlyck5OK0ZOQVNMTWRSK09NckVKaFg3RWgy?=
 =?utf-8?B?OUg3Z2o1THFrdTNPSnlRZDFsSzFFVkwzRFRYMWxEdnovTkJGSy9XR1d4N3dn?=
 =?utf-8?B?TG1BSS9CV2hVY0ExcHVPMk1OVm92OGRZcS9qck1WVUZSYmV1bnJ4RENrQVNY?=
 =?utf-8?B?NjNIcFhJdnEwV2pQdkhMQzdCYUVjclFWWFlld3ZLYytNRkdCd0dNaGx5WXJj?=
 =?utf-8?B?Y25UU01IbzhFNXE5RDFTU21YMSsycFFjZ1R6RjdaVnhudzJzVWtNNERRaDl0?=
 =?utf-8?B?dVNXc1ZybnFxWmt2VldRSVBnZVAva2ZUTzNRa09YTHVlay9hbmhsekFTRk1z?=
 =?utf-8?B?OHc2TU9qV1NmRVRmS0dUWkQ4UkpFUEZJR29sekswaE40aUN4dUVLaE5sV1Zk?=
 =?utf-8?B?aXNsb3NHbWhRSGkvS1Nrd1BybHFHUGtpL2w2c1FUeEVraHB2SUdQUE16ZUQ1?=
 =?utf-8?B?aEdiKzVsdytSUjBvVHRaTGxHSll4RXgzS3BqQXlFenFaaS9XN2hoMGNxZFdv?=
 =?utf-8?B?VVg0eXp2d1hTWitDUUg3VHlSL0cxSkhmZENtUVJpeHBtR2ZNYkJxdE1zNzYz?=
 =?utf-8?B?SjBVVzhkc0FucUVVVG02N3QyNncyeUhvbGpSelMyTHFIQ1NJOHJUYlhPaG5y?=
 =?utf-8?B?RDJSUFlrZjJ0bHJhbHNCQnVid1c1dU1aUVljcUVOcmRSNlYvS3BjcmJZb0Q0?=
 =?utf-8?B?TGtiOUdrQkkxZFlCM3ptaUhVWVo2c2tCSGZXbWRURDFXaC96b2NWZ2hzVFd1?=
 =?utf-8?B?NENySVRSaXY4YmtFTmFZN2p2NWwvRmJIRlJTQnRVWmJVSnlLUzdYa0txcmZG?=
 =?utf-8?B?WUlDVjcyeW90bHZWcnQ2VWdkelZsaS9oOExHMTVJbHBMOFdKSHlqZ1QvdlI2?=
 =?utf-8?Q?fS824q/8TnsF+Ty2XdnSdSg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D3NGiqJirwnZm831On0BxnhyQXtdOpFj90iMERuZ3w6N+14wR/2LU3kBmUA0zkv6UD1bhXWOjwDa+LTh3XqtthZxAlVpzq8AGIwipcISGNrgE0K5lcPa7MpvmI1k4UQbrVuPYKtKtNAL068Nyfe9UMR8g8IvfA+edDBOnGHtjLS8nJ1F3R5LSqUKJFWz48R/WZ5IPvCbwQTEiL/E0XHUpPyS0fr5KOuZSJl0Pl884wSm5oyO9p25MU5OXsYbRc+uD/FTKclBMaKqeEyL3jP5bqXykR/2XCOyEjNCgs8CkG9NbKCcWH99+zYW+GYoXBetoaGDhyfPrxunDJfqPXfzgoU3gMohP132ny5frvQOZv19+G4V1YJM2+YMJ0OLhfKRYIrmIuJUp1sZce3WFlIKsRssaePI/SvzE4kbWgyrG+GgpeSRv3BD4GDYFl8Y4WSrDJlh+QqmUwJeaU7yiMknCvu03RzPwchoMYsn2W9aCirZ/dTQ2ur0PqcTI/4zKzAoyd5nPis7P3wBQmxO0RFQJudGKO+dFog8XRNhx9Lc1uGKmwkcT0Bnvk6G7IDWcM82AGM/wsBMS8WzGzyOovwCgsv8uVGjcj0Z8yH0ggnDeKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7ad013-e338-47cb-20c1-08dd8803518e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 16:23:19.4623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Ys5Q16hVGvgTfDUdnEKDLWdK0Kj2UUSaSC79UoGOz07oywaVuGgCTTfQECn4botQic3Rfa+pH6+O6BpZjavN/uc4DpZ/o5J9dOe/4IYaM1z5l+PH6LwycpPa/ebQbue
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504300117
X-Proofpoint-ORIG-GUID: XoNW3fUl9_N37mitOldqYUGlC7F-V73b
X-Proofpoint-GUID: XoNW3fUl9_N37mitOldqYUGlC7F-V73b
X-Authority-Analysis: v=2.4 cv=Hd0UTjE8 c=1 sm=1 tr=0 ts=68124e7b cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=X_drXzbwcQU-ujxrCA4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDExNyBTYWx0ZWRfX5bczE2IksVeq 92jzhTz3jUue98xY0L5bIgDKndcrxf7t9Ln15KzdAycM4cGy/3Ub50DZfC6tiRbqg8xCvS8mmsN APJHoQvhqosWzKE06XOHEbxqizIWEkmb9V4vCjdjshkUP7n2IOjuRPp2SckMb2Z//0rSCbmL1L/
 VenalJQ1Mo1isR/LYtckt15wGedglwWOdOI7/d5ZDnJBNOZPi5U+x5EcIjj05r3HUdhZmv7KMfC SiLm8iK5nglgM3X9jPl/SA3S0ZrqPyAm+UnXHLQJZLU02RTKv5LmDY19TGKNrtfCFHJH85vcyL4 ORVDwHonK78zIZff8clpNSk4wVVLlXbw8hE4yb4Elr5PdSxZfn65BAcT/t+Qhy8wtH25tX2N/9o
 aluZqX/acNuZGV87XqE0HJnMlJL9RMPl6AkTvWGvRQdzIN0DxDoXR1j4cD7HjcYN8lpc1XsP

Hi Greg,

On 29/04/25 22:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
