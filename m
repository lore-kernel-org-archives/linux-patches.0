Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A503A1B978
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723989645; cv=fail; b=u35a71fHsHku6m2N3AjLxJ78kKxbScP/pFnKu9hvnTOJjUU/xqIaEUmK1e1bkI0XNaTohUhjyuQOUs1afYXXYTousZkdY5Ug57fra98tdR5FBxmK+/542aPSkzS1MThJAMjrTXIoK++g7V42sJ4MKUrNvKy7zoIo5L7jR0yQpWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723989645; c=relaxed/simple;
	bh=sqCRdXnqgfBfUhuI+zNWxo9syx/GbJHuW3aZY2XPpMI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sT2awVITzN1smWNbp6i5vwBGxpmCSb961rP7r9KGzPhAM2PtM0NpQpKw6Pac2U/BqVuNKa2HDNggMDXz5+Csyw2hxQeUrlyakqqkfPQrEWL5zo9701kbLLHZz/MbsJps8bv502+c/VL5HFsn4pN3ZlHnQIiHTnxdKEvVLMI0E8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AL1/pKoO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f84X8Ee4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AL1/pKoO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f84X8Ee4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47IBhr44000908;
	Sun, 18 Aug 2024 14:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=q61jxnKjfTnpGk1tSiSxW5zumoisj+g7k/3JvuLav9w=; b=
	AL1/pKoO27z1O2MMj7SRYWbcqiQsn+SaK4ViKj3XQ6RlwAhk+o2xTPSmhbn+7yrq
	ehXP2x3Us/d/xdAbSMQbMod/BQpYOz8SKk9yKPmAtprNpXnpGnPi0vcbmhbjuqXU
	K243uq4UAJHi0PNb9Xlzlt5cr5mvibHDQ8ZpAB/12M4DLpXsTAKVNtautnrQXbYQ
	wZBl8NFqATgXmAzo0sMPsPOKtrHRXMyfDTtiuyubCddPkF9vKWNxbqIshBPuyQdA
	xeirKxqwWeKa7qL8STryGD5dRjZDyFl5BMZPuPECx7NZzbk/0seKQCV8AvCe0kKJ
	9UHWrESkah6WDipg6JPzBQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m2d998r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Aug 2024 14:00:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47IClsRh001777;
	Sun, 18 Aug 2024 14:00:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 413h9agx21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Aug 2024 14:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cuGLrI5bEBIY8fXCSx6jmePkxRR6TnF4NYE5oewpc7EI+6rCxZugClMWfpZM6+RZIhlHfWIdbqgyMYlwtsYlsIktVnDIyzp2EgOTXEaGCcW0o4LQERUs9S4yC6ZILnsaUo4UE8iQ3bBuwksDBwf5zSKlxdE3PnvuB46ejG6LUdgMktuPbdzS5elXcYxLbuO0jQo+KTE9WPlO1Hmhm2jln5eQmrQabrnOxrMlUsIk2IHY4KCyTOJyLZkrBQGO5niZPYaJSBDB2OVqluCTVPt6868I48B6bUcGgn3BIjEY9tjytMhFKqXSu0gh1HDYr/hz71KQ+xVzFkVPneLkInu2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q61jxnKjfTnpGk1tSiSxW5zumoisj+g7k/3JvuLav9w=;
 b=e2sDQFIsTjQGdPTROXyjE0vV4uiYMNJ/dnh6JPBvI3TED+QjyIcUKWldkr186aHtXtEleQJP1XJuW5OorVM77KoA+14dIMpwHOrJLa74+vjMqBRG8/bgXGwTcwtaQuJUz7TehIweq6vOFEXZBRcH9cugXNqgEk95c/KN4NC3jLNP9t25cQrTEFsKC9XB7sTCe3ljsDe0yu+h9F+/ZsMQ0UGrkMTyv559OXQI/YrzbdtESGY5EwILK6JkJDQioO46F48x35TZGzftrKkX+ERsXGoufl5BLRDAAPYsYjQf4/aDbVxsfWCdq2jkYPETXA/nX/97o6w+ze+b00WO+Agfew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q61jxnKjfTnpGk1tSiSxW5zumoisj+g7k/3JvuLav9w=;
 b=f84X8Ee4D3ZBwFnEaMO8yAtjYOoC9MrB4te0HuQhvaxAEKJXHhqWqrFo9LCBMWVzV2l6gf9u76Pl27Labnb4h8iqRmo3kPoNx2L0ctTgDOhxy6YPrHuLcAgL3uCESE9Met6zVxAgdcJFoD3OtSi40g5uHbnr5Vvm9IpA2s2If/4=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MW4PR10MB6323.namprd10.prod.outlook.com (2603:10b6:303:1e2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Sun, 18 Aug
 2024 14:00:29 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%5]) with mapi id 15.20.7897.010; Sun, 18 Aug 2024
 14:00:29 +0000
Message-ID: <0bbd0d7d-bc8a-490e-9763-5842e59e5cae@oracle.com>
Date: Sun, 18 Aug 2024 19:30:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/255] 5.4.282-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20240816095317.548866608@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240816095317.548866608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MW4PR10MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: b03b3954-6266-4ec7-ec4d-08dcbf8e1ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnU5U1N1VHBXbGg1b2xtcGdTcnpRZEJxek5STUNUZUN3TUh3Yndkak9ZMHN1?=
 =?utf-8?B?cnE5WjNZd25BcnUrQklGY29vTysxcGJiMmhxV3krclF3WFRhL0hLSENZNVBi?=
 =?utf-8?B?clVweFRZYUEwOG0vWEltU2c2dWhFcWgvYXZ6Qk5UUGtBbGdRaHVXd3dJV05E?=
 =?utf-8?B?eWZTSHpTVk8zMk5mQVAxUENBcWZUL0FORUYrZmJCNkZ1S1JUMWYrLytVV3N2?=
 =?utf-8?B?cnN5ek9RMk5VWVdWV0VUUzNGdGpmRWxPWk5wbXg5QVZjSGRPSHNWVWRDUjFm?=
 =?utf-8?B?VzZKLzc0K09LRGRqLzNSbWdJMHNEaEErcHYyRXlLMzRPTnF2c2hrV2tTWjR2?=
 =?utf-8?B?ODZnbGhRNVBuYlVoOTkzMnNiQS9uWXlFWTFkMlp6bUxCSGRKTDRDU2V5ZXRq?=
 =?utf-8?B?czJYTDBjTHM1REdaM3AzNDduK1UxR2xEeDBJcGdiVUJQcklFV3NiMjdWcnpu?=
 =?utf-8?B?L0dkMytOQVlyQ2E5SFczSU54UkZxQWprRUdVeFBCQUpraTRCeVZpd0Z4RmdN?=
 =?utf-8?B?OWpwLy95UUdGZXh6YW9QaHV3UHBLbnhjWFRRN1JCdVBRR0JMYk1WaEZ6UmR2?=
 =?utf-8?B?b0xaZFUvUDJQL0xyRmlmbXFnUllOZUJGelMxYVNXdG4vVzZXai9wbUU4a1VH?=
 =?utf-8?B?R0wrMlhVNXJjb08wSEdVMUdhRnVjT1ZscTNnOTExcUNGT3BYL0NtV1BuT0Q3?=
 =?utf-8?B?SGt4S1RlbC91Yjk5Q1pyKzlFZ0liYmV3U21sbm1pREttQkZHWTUrN3F5SCt4?=
 =?utf-8?B?S0lITE0xdXhWUkZZZ2xNdThPZ0hCU2xXUWdvVHd1ck9kaFJuekFvbjBqS3ln?=
 =?utf-8?B?RHdxdTU4QWpPRUlNWkJxKzEvWTBtdXhNRmdJM3hmVlRsOExUbDNJV2VJY0V5?=
 =?utf-8?B?aDhOaWtKN1JrdjJCRnFRSUVFKzR2dkt4eXVmbzFrQWxxQ05GSVVDalNMRWx4?=
 =?utf-8?B?RFJqc3dxU01yeHJWYS93SHFUZjR5S1MxbnFxMFBiRHFQN2JKZ1pnU0IrRHJ2?=
 =?utf-8?B?TmE1K1k1TzV3ZGpZK1hPdmx0djc3S3NsbFh5T0xuQVRlMVU3TlZCa2ZETUZy?=
 =?utf-8?B?MGU0cWRmNnRrMHcyTlBtaHlaeFFxQnZiZTlCWkdSYVA4SS9PVFI2WjkvT2VK?=
 =?utf-8?B?cnZSZW5wc3hsdE83V1hWcERtSFp4aVRPV0p3KzBvajNjMXFKR1NVM2pqRXdm?=
 =?utf-8?B?SDJrNmRaNzl0eTVSWnRHeXUwbFRBSHNHeHlRdHdRQlVYWUR5WTVNQ1pEVDBy?=
 =?utf-8?B?TC9HbEdhQ0tjVG5qa1RVSGZpRWxWNzZOQTZxZjlIYnN2blZFR3lsR2JNcEY3?=
 =?utf-8?B?Q0tJZll1aXVTdUw3WnJHV09Zb092TFQ1YmlXSHJlR20yTnVUK2FBUEVLcGZv?=
 =?utf-8?B?OU1YOXNlSGJpbW9PUndacjNXTTRhV0lGUE4vV0lYbnRqUFNXS0pBUFQvN3FU?=
 =?utf-8?B?bjJ3WldjV3JKcGVkWkFuQzRiQUpmdHhlWXEvSUhGUFpiZW93K1gycG91YnE0?=
 =?utf-8?B?eUJWeGY0QUR6Mlc2V0IxRWorQ3VHQzlndDFGZ3ZvcnY2RDBnNFZXdzgvWkpF?=
 =?utf-8?B?d3VhSFA5NlBVenlhRTZSbVhwNFI5YkZhaGE5Y1BBSkZ4emxPSjlicmlNdExF?=
 =?utf-8?B?TTRsYk95R3RtK25iQTZ6K0FXbWlZR1NWNzlkMVQ1YVJYZDVVRm1aQUVDOVJO?=
 =?utf-8?B?L1czUVd0VUdJN29aSXBJbjNYRXRKK3NHK0hZZGFkaVpybjlHQzlEMGo2dnoz?=
 =?utf-8?B?cTlQaWZMVWh0Z0U3dUZ4bW9ZWWZTSFc2OEhRNzVmOUdGQTBxbWh0TWJMNHBO?=
 =?utf-8?B?Zi81SThJRDNwR1h6TnBKUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3VHT1hKWVNRSVY4UmEvbENsMUlHdGZGRTMxK0l4NnREUEtIS01IQVk3d2Q0?=
 =?utf-8?B?RTREMWppRXczWnlYcHZ6d2xmR3RFUk50UlB2K04vQ2RINWJrdEdZU1BTbFNu?=
 =?utf-8?B?cmFoQTVmQ3hqNmxsU0lkaEVKY0ppMWUralZ2NlJySjVyU3VOZUtoeG91MjY1?=
 =?utf-8?B?SVZGa0tCNnlZVkpGZE00SjZZenVBTG5nd1VPOUQ0bmI0NTliaDhDQWZkSTNz?=
 =?utf-8?B?QmgxeGtMelFXemIyUVBRR2NyUUFSV0hnZWdqN2kxUVZNSWNrRjVtY2NEN3B4?=
 =?utf-8?B?MmlQSU9ua3pERFNPZUpZWkpqWGJNaExqK0c2NHZJK1BDZVpXOXZrMkdxOTkr?=
 =?utf-8?B?NUNoRU5VUU82cWlvUHZ3dXI1R0VUMHhoMWNLcjhyOXhnS09Pei8wejhtcW5u?=
 =?utf-8?B?RVRuaE5SdTEyWHg1V3lMOXB4UGdodDF5MXZySnk1cXZlRThnL2pSRXVBZWRs?=
 =?utf-8?B?N29KeHR0UmFHaGE4bWNlelZ0Vyszdit4TEZ1aStocXZSZzVNVEJFaklWQkRP?=
 =?utf-8?B?dGUreUFhVld4VVJ1b1hJVnRsWmJnKzBUY0JaUWhnZk42WVRwMVpOcUZnaDg0?=
 =?utf-8?B?QUhabFVRN3FGUkZ4WmlmT1hXWWM1V0Uva0xFcVNScHhJL1U4V0RGTUdOQTlP?=
 =?utf-8?B?enpNRHRYNnR6SkUvWVVxbkVFOTZwU0s2SEtITDVobGV4SDdSNGM3aEV6N0xY?=
 =?utf-8?B?WWlOczI1ajIyYXcyNnVzZ2hqVkV0bHdCZkEzaW9DVnE3YUorUHVGaWhta1gz?=
 =?utf-8?B?WVQvVERwYnRkUTk0eElCRTlBQldLcWx1ZGlac2JwYjFySy9jOXVIUlJWaUpv?=
 =?utf-8?B?VTNSV2dldUpJYWdPclRMN0hUZGErd0orMjBRcmV6WWxvTmtzd0hkUjFHTGN5?=
 =?utf-8?B?VEh1R2hBdUtqK3dWU0p1WFUxUUVqajc1KytxV2VTNEd1Ui90SitjUFA5SjZV?=
 =?utf-8?B?ZXd0cExaYndZU21WTU4xOVJnWUwzUWNXbFJuRnRQMW90N2prRk1UbGJMdDhz?=
 =?utf-8?B?a0svUXRXc01ZNmJ6ZTBneVNOdVA4U1NOR3ZjQk1SVTIyVEp5a0pIUWpJRmdv?=
 =?utf-8?B?TjhxeGYzK2wyT2czalcrRko1b05mc083UDVPMnVsSER0T3RyR0NCSVl1ZW45?=
 =?utf-8?B?YW15UjRrMWptc1JVSm5ad0lXRHc4L1gxUlk0cnlmTzZzdGJwQSt4SVU1UEFZ?=
 =?utf-8?B?ZG5iaHJSNTdycGE0MnpObk1QUHExNDBwaitpOElINGlLSGtPc3R6TlU3U3Yz?=
 =?utf-8?B?NGVWeWpiMVF3MGhrY2t2Uk1aVm1PRVRkRm9ESk9XM3ppWlZ3V0x2b2xNdit3?=
 =?utf-8?B?bTUvaDBDc1hqeGhYNUlTWGhvZDJCUDJnQVBiNmhOZlNCemVDVTVDKzNwdEM3?=
 =?utf-8?B?VW53REhvOTRVazBvOC9NTU5qd1ZHbUU2eDlQRjdlbTZNL1dWTk9jV1U5R3N2?=
 =?utf-8?B?ZVZFY0k1bUMyWm5YZDM5Qyt1MmJnaS92NmE3Z3k3RzN3MUtsYVJrd1RML2Nh?=
 =?utf-8?B?QklhK0J2WFRJMXVFaWkyVmlEYWg1UWtFcUh3NnQ1TnNGcGZQeWdCVGRXdkc1?=
 =?utf-8?B?RzJKUWt5WmxLb3RoWXoyQXh6WFhFVEM5OWQ5aXo3UFEwcUdTeUpvRVZMSVov?=
 =?utf-8?B?M3V1aXMvK0doRk5mS2Y5bkQ3OXlOMnAzTnEvbmdFWFZ2TEw4M0FZcFVhenBn?=
 =?utf-8?B?Y1oxN3ZxTEtWR1ZkR3hpb1U0ZkNLV0dBYzFvNUkvSThqLy9vMCtqM0E4eE5Z?=
 =?utf-8?B?T0RxeWFqNzcxRDFwbDVPU3cvUjF1Wmt0UVR1UDkvU204OHJ3dzJTZURyZjZs?=
 =?utf-8?B?SVp2NFpRVHlTNWkzMXJzeXNjSjdCL0k2My9paGIrMm5vV1d2bCs5UEpYd2sz?=
 =?utf-8?B?SnVnREhhSzJ6WG82TVNCcEhlcTVTTzY0QTVjZURETmpDQTlxZm00Q2dPazU5?=
 =?utf-8?B?VHIrVWJTSFlyaytNRHdoKzhBd0hZaXFvYjhKakpTcnRvNzlTYjlTNVNWWUwx?=
 =?utf-8?B?NlppRWlaa3UrTVFyazJORC9xRlNCOHZlV3VlZW1HMTlJblJXTVJoL2d1c2JZ?=
 =?utf-8?B?SnJhbWg1MlJMUVNKdzBNTEowOFZodUFkeVdtQkxYU1dJc04zVlhxSXlSQysv?=
 =?utf-8?B?bGlsdlFxWHdValR6akFKN3Nnc25xdTdwcUg3L0pZM1ZNYlNnRGVtNmdaYVMv?=
 =?utf-8?Q?wadBXa9FF1ybZak20OOdFzk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ygyloA9RLF8mzBrc4WUjT4VJ8pS2IW/6akxYpFunECv8xiygY6lkp4pAVfXM/mES7SNRhFPUPQLhPkBUjZzp2AjcQs+86mwqBsnsTxHv8ADEgWDZoANy/PlnYcv1CFodk7ELfya5hDwFeQU/kBsdlmgWb60shVA9tiOh5HGFjmMO/XWJl0feXqroipIg8fyfjhXT1iA0WhWXQj48JH7ZMfGXWAQTmV24GVMVe5PcZ2qDGISVQik7UuFwU/iWrTPw80kbB5FZ3zwU+QcVBNnATFqUKfWjQEtcpPgZGwNgRUk5r9v4/rUrwtJbJdjBSR1mZBuTfKupTLhc9HvGtFKKcABYHq31qCIboUCQSXQCIgiaWB4maUcuUaHa5hxFkM/JGbhbciXvfmIVPzG7xpzbGxdfg18C/5TaqIpN9pZ5U2HPzb9Sg5/3LeJjQ9NKUCgLKQuVjYtshNzWcEiCkKRlvtPF3dUUTfWqQIWP6R63GwYer5SP5Zs1QcI3ksvIKigTGP64/fcpdtkT08WJotdg2Nvwa46gpwRoAk8xPTXdLMaTgEzRbodm+UzqN9TPfIasTAIB+cxqh56soKjbvRH7r8HYJlRIV6QOCZadXu49CLU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03b3954-6266-4ec7-ec4d-08dcbf8e1ded
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2024 14:00:28.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUfiY5YP+btPcrTrE99aXKEJ2iZngpA+YEJ+NyJw9N3KYGjQOCkajRMmM+nOPmneb7Ro4YOzWZS2L2acETMyHpc1Qee/jvcybw+njgpNEkZwPh65kvWprQssdTY1cLo8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-18_13,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408180102
X-Proofpoint-GUID: Q1PAKyU8Kyms6KtSd7ZYWUrg9FFv9Aqg
X-Proofpoint-ORIG-GUID: Q1PAKyU8Kyms6KtSd7ZYWUrg9FFv9Aqg

Hi Greg,

On 16/08/24 15:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.282 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 09:52:32 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
