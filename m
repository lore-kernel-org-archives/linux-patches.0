Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9912A195FF0
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993868; cv=fail; b=iZaxjwguxELEmXKUYqM5ux96tS44q2WkEXUAweOqxL0/YAKSsL6B+JKOmig5bSKhPTd8B57v3KJDTWQMdj7fvlOI6b1XkQtO4toh82EaiKwo3rAK8urT/5Q/yIqBLXYJhkRAkc0y/qKLadzCLOlJt98JLd0JLTOS/8mJ5tqw9I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993868; c=relaxed/simple;
	bh=DcSxBXDuHcvg9e4nIEI2MTVds2hFJMnyePlM1yZfriQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AaenG10OL63+OVV9wVgfuMAc0XBb5L7iNHCmGKPJOTjaXWUUj4WUpLd7Y9HRdYyS7+2dTv0Trgpbphmy+T9Nmdh7wrLli6lALAIFC/tet5FBrz2iP1C0SbgjIzJTuicEkW8JvP1pWq5WEtZtKs+tnfQinLAo5Jtu6b28Uu7NRvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SQehvOtR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pvT1zic9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQehvOtR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pvT1zic9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHNYMI007449;
	Tue, 10 Sep 2024 18:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=vxJxFT5iiQai7SQGTySPZUgV3KRoDO3GvI8BbP2vO8w=; b=
	SQehvOtR57yYX2II6UirabEMGTLRc57jW3cbQ0yzQb80vCxgvIePxEcNNsrvsfyN
	Bgp6F/Mh3uCPvatMhd98AZTxo71TPBOaxyDoyg8Zp4VZ8nOZ2J82K9BnUnDtYMaX
	aT3pYy3bnePIgbzLjECq7ZKO0QoLuaWp30xh4r0ndbsBFat4MTJFeVFR/jXAd6zG
	8cFVU6Vg1hxmVJw42m+70LBZaz5ROFuNfnQMntisppIcmbSKVVf2bzbFkE7OG0eD
	3VHmkkpzeRRl3ZZiU9q5M3WqlQ7zGayhuQXTKobXWla2UYV7xwYYYa7wwPhb+QuM
	N5lnIdkS4wCP+Fx3PJ5jnw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8cxaeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:44:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHDWkL040891;
	Tue, 10 Sep 2024 18:44:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9aew9q-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:44:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+AJbBRLDZq4kved4QXatGzZIl74hOBXfZnkBWhyUKD34yOwrNoYq2ZfLXxOtpYOovEOQdyPf3aWieLNLk3kmmLPriDns5ebNu+G0F0UOG03RJf5w1VX/hnjZAP61VcaBrm2NkWcxV5H6aeQXk+i2B2nNeDaeEoeAd48sdA7+L0SSuRDCwOSuSt3kYGODpeHOu0jasMdSRaiuR/kpLvXaNPiinYtsurhl43rP31B7nEdYSJWzf8gHqQcLj5BkQ3L9/pojftFFv+GrisJXqADvZsbpLp9kIfOnpNnkmnTm2CZDSwVrik9ZhIrtnk5DXRCZBXNUfTsefe0/sc5mbvHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vxJxFT5iiQai7SQGTySPZUgV3KRoDO3GvI8BbP2vO8w=;
 b=NUv9LlTU7aWcOHaK2BEdoh9h5T85IsKVsWJSbBh3oD6FY+OiUbkWf06QevDHocnKbotLKT+FkKJGGUp6rMnzf6/6ferN53ZrK402mLeg9/KNMzFRR0zqhRrtc4egeFuNsQYP3ekkD5B7j2aDSGRWy6semubf4dciai+YidxX5ZIljp5gW1jAAdnabh6qKteX64rUutIWx+PnZcT4YvJ85ZN2+5yFRUM0Ccy/sDzSCAn5jNaYi4gJbPIFstlw8cA4JiOwqkmgmBq5MIJy8Q8CuflTLGtbdzkYDrsarr6FclX9Tue7Qvxw5k3uQAVRo/LriP8i5CKD3/O0iVNDbpqTew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxJxFT5iiQai7SQGTySPZUgV3KRoDO3GvI8BbP2vO8w=;
 b=pvT1zic968uwxYAZ8Tdu+WnYbf0mDC0RtqSXKPMC4qXfUF/fD9OQGzRlNwvKRaMvHfeRMFBdMcLjksvG+hmVM+d5HwTQKlSJTCokzVdq42AAE1VLFsW6OlHzvcbJPVX1Po48kk1G9jLubwgkfriVKIenhwQTn/widZI7QQ8R/1w=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB6172.namprd10.prod.outlook.com (2603:10b6:208:3a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Tue, 10 Sep
 2024 18:44:12 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 18:44:12 +0000
Message-ID: <7761aef3-1708-4bd3-81af-6808396129cd@oracle.com>
Date: Wed, 11 Sep 2024 00:13:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240910092545.737864202@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: fe6274e7-1061-4c0a-ca89-08dcd1c8893f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTd0Mnc4UStDd0lwa3dORVNhRVMwK0hscjJHcjQyNGxodC9hS1R0TGlzeEZn?=
 =?utf-8?B?aThsS1ZvN24zcVBza0FwVmo5ZzR4WDdWL3BmRi80czFCSjJvRm5WWFVpRDJH?=
 =?utf-8?B?SGdnczYrZGhmaG56R01HdzhSTlhvZFBLc0NCTUxYYWtEa293RHlZLzVlSjQ0?=
 =?utf-8?B?RXJQNDhSZHRTSnBxbzloQmZ3VFJQMStkREdtMDRhWHF3bGxmcldDOVJhWEYz?=
 =?utf-8?B?OThobXBndTd1MGtEZGQ3UUZlbkJiNEN2eFNOS2lxVDVta1hFelNxbnptZTFa?=
 =?utf-8?B?dDh6WDR5RExqTXplanl0UXNQTjVzaU5TOWY1d0VHTDRWMmhDTlFSWE1qYjhK?=
 =?utf-8?B?U09NOXIyZVVxMW92QXBaaUtzRy9pN1ZKY0hFVCswNXZvcjNxTVJzT3R3MHQz?=
 =?utf-8?B?VUR3Vnl4c1orOThrRytMOEVWWmlLVWFJTk1zNEtIUVgyNzAxRVpDQUVUbHJk?=
 =?utf-8?B?bWwxVjVQVm41Mk1ZT1k5TGdwQUtoMlNHcW5SMk9oNUNUVE45eDh1TGhyd21Y?=
 =?utf-8?B?TE1UTUNjQ3hjQjRFNUdrKy9pbVZzZFFNa2ZUenRsT0lMenBlclBpRklRZ3Bm?=
 =?utf-8?B?ZXVUVW9ydUJzTTh6ZHB1Qmp3blVtdnlQM0ZtN2Q0b0ZLbDA1ZDhHdm4wWlQz?=
 =?utf-8?B?L3hYYWc4bmtPZExUMFhQMVVDNndGUDd5SWZTRUQxWEhVK3I3SXIvZ0hRU1Qz?=
 =?utf-8?B?SndzMnNYWTZZb1RxZzdKWHdUWldMdkk1QzkrWjVYTm5HN3MxZS81empiVk1o?=
 =?utf-8?B?b002WXlyL1BXaWJiSGpyUVdVakxuT3kxTWwvZGNPSVdOSkdWelIrUDVHejJm?=
 =?utf-8?B?bVRIN2JWOXJ5TkpLMVVrNTdienR3cXNJaWw4N3pjYjl4TXlRZy9uMkxudkVq?=
 =?utf-8?B?N29BTTk2WUQ0Qzh5RUpXRmpNSHI2Uk9GZGp4Vll3bXFjVlJrdWNiR1JXUER2?=
 =?utf-8?B?aldjb1dUQjV6a3hVVTNxVlg3bzM1QmNENVhibTNLR1JUTlorNWRzVEJDTUtB?=
 =?utf-8?B?YnJtLzZNNktTNUo2NWtvWmI1WkIrUkkwU3FRWEhvMmxOYy9TeTltbWFNMUov?=
 =?utf-8?B?Skl4MnBlcFJwZFM2Wk1hK3drRURvL2NyVWE5OE9TMU9acXk5aTl4M0RzanFT?=
 =?utf-8?B?VnpPV01TY0Y4Q1BMTFNScWVsSlE4SjJrblZ3QWo0S21EeDgvOHpOWWxNcjNG?=
 =?utf-8?B?TFo5S2JNMHRJeXRqMkFHSG04dG8yRW9ocm54YUlxenk3dVV6eEZlZ1FkT2NL?=
 =?utf-8?B?QlJyamd2SkcvSng2QzJ3andZYVFkclROK3BacGdVQmZIU3VOdWRPMTNPOVA2?=
 =?utf-8?B?YjJYWGZ5K3RkeUhlYXdZcXB4ckpVb0FVRFo5aUxnUWE4cFgvTWVtVEFXcFZu?=
 =?utf-8?B?WU9vaG9WeWdjMVhwKzloT3p1T2RIT3ZSZE5Dd0cwajkzWFIyaUZLaDUwcDJk?=
 =?utf-8?B?a043MWRrbkZTUlVWNWtzT2pWcFJhcURiNWY1YnNUY2wyOXR4RzQxRUN4RVBz?=
 =?utf-8?B?dkc0UFlGeEsxdE9XKzNpSXpRc3B2Qkpwd0VFKzhuY2hpOWJ6L3JzQWRGLzFh?=
 =?utf-8?B?OVNocG12MU8reCs2L0p2dzhQNE9jQy9SMW5BdHB4RmRkOWJBL1d1aUpVbFov?=
 =?utf-8?B?Q1ZpekhFajgveTZQYTlsUW0vSG9qeHcxU2tOMzhMb3FWb044a3FGU1ZLWmJn?=
 =?utf-8?B?T2dLZ1lJUTQyemZKbld5MWZEYjA1VEtDbFJRVVNvNXFtOHk3Q3FlZXpCTm96?=
 =?utf-8?B?WG5Td2IzVkFKcVhiZ1ZNaFhkcmlUaTRDZStVVis0dGVJYytxUnlxYjRxY01y?=
 =?utf-8?B?OEZKdGVLUlpVb3pGUmh0dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWNNMUQxUG9LT2VKTUVLd3o5bzdoSmZBMjVnZHVvdDlicWZreitLdjdUWW5Z?=
 =?utf-8?B?TlZCemdPMkJKTVQvcGhIOG5LcmpUWW0rczBRZ2dKUWxWL1VjektDS0xLLzNR?=
 =?utf-8?B?ZWVlQmp1QkJkUDlGQjdBUXJOR2ZOT0VvWDhHOUJWeGxKV2toUVE0cEpGbi9Z?=
 =?utf-8?B?STdnMzZTdGVLV1NudzlzWmswSjJ0emt1T3hCU0xNMHQ5SkJEd01xWGVhU0VZ?=
 =?utf-8?B?Y1B1TlN1Z2h6SEZzeEZZOEFsZUNVb3pDcndXVHQvekswcjA3NFJKQ2g1ajRT?=
 =?utf-8?B?WWoxQktwbDBqMXYwREU4RWV1T29kRUhmVy9lWFJWUDhDak8yTy96L0VNR1ZG?=
 =?utf-8?B?bmM0TlJWQzJNSzc5YXZNTzRjVDRrRDRqY2xsRkZGcCtzeks5ZVIwaTNsTE5E?=
 =?utf-8?B?aUJNL2NMMGt0dStlWXM3ZytzZHJnV1VVTTk3ZXdGcWdsY1pZbmNZRWJSV3hm?=
 =?utf-8?B?S1A2dHRjRnRLdWwwVCtiS0ZJdDkxS2lNUGFtWmlEdkJBZ2h5TFR2cVU2RkJI?=
 =?utf-8?B?UTZOa2phdk0yc3hnRFhGUXJyWjhJaXZZVGZUWUtnYlpucG9TQkRaRDlXd3hl?=
 =?utf-8?B?d2JSU1V5SUgwTllJNnRGVllyd3R0OFM3T05EQkUySFBrQ2lFRUI2YVhSUDNM?=
 =?utf-8?B?ams4bEdJYUhDa29IeExGS3M0b1drb3FFaGZtT1BiYU1jd01TWXBzekpkczgv?=
 =?utf-8?B?K0tDWVNkcEVYdGtzVGJGd2RScmkrU3B6bkV0Yi9kS1lUbjM2T09zRDVqUkhH?=
 =?utf-8?B?cHg4NWtUK1h0bGF1SXJ1N3U4dXBRd3R6ejg3eVZ6NFAyRmk0bnVpa2hSUkFs?=
 =?utf-8?B?ZnhCV1I1c0JraC9RcElXYytMRFVHN0tNWFV2dEpMazZFTVllM3VrWVlkY1lH?=
 =?utf-8?B?a3VKSEZ4aGcxVm5DaVlMSnF4MGZIL0x1Q3k2VW9IVnFkaEdROUNuVjQzMjkw?=
 =?utf-8?B?cHFjamRtQzRYcWVtaktocSt5Q216VnRvbWtudCttdnRsMklyK2tXTUNhdVhv?=
 =?utf-8?B?M3ZTQ21ZMG82a09BekU5cUFRRmQvN2c3eU1jWEpUcTJ4ektjQlB1d2QwVmF1?=
 =?utf-8?B?UUk3c1RrSDhYZnRZeFRHNmFBUGhUc0FmT1RPQ2JiTmNHRW9ZRXk0a2hkb0x5?=
 =?utf-8?B?TzRNRFpaWW5JaUZYcm11NnhrNTJMdDBqZFRSWGNNWFFZVllJVDVwS1FUQ3dO?=
 =?utf-8?B?dXk0YWx1S24xZjVYekQzMnVtR2F6NUR0MDBnZkVTY2s1RFJqdE5jUGNIMlZS?=
 =?utf-8?B?eStUR3UyZ20vWVFNZktYY0RFL3g3ZmZaS2VTc1NzOXFGMFhNVG12WEtEdUQ1?=
 =?utf-8?B?ZHpONzVaV0dKZnRvV2pCWkFoclB0NUlWdTFTQ0dTRjhiZ3lSajlFTDI0cU9X?=
 =?utf-8?B?cjNzT3pYYmpBTjY5RUdlV2s5eEFXVzgxYUxXMUhwOURMQjc5aEVPdlhBWVNG?=
 =?utf-8?B?eU5tNzBJTmNtZ216dXEySFZqcGRCRzNKMkZxcGFSdStyL3ZOOTFRcXdyNWVU?=
 =?utf-8?B?RkFEUTE5Y1pkUUIxQ2MyaDdJbk5rMzJoWXFlTTIzeTlBWk5IaGZPRzBmVUU3?=
 =?utf-8?B?Q2pOeDI5TTJrR3VOSC9iZzdvaUd0WjFUNWJvTFMrWVdmSGUzSGxCTjk3OUtp?=
 =?utf-8?B?MEhKd096Mm1yUjQ0aWJXWFRMREk5OU85NDlvVURsOVJCYWgwNjFBZjFvM2RS?=
 =?utf-8?B?T25vczduRlF3WUZzaW9pS1F3VnRyYUpSSGdPV1ByeVpPcklDTzhSNGVPWGgr?=
 =?utf-8?B?eUE4NU1COVc1aGkzWlk0a1VWWnFkekY3R0ZnTGNFY3k3UFUrRWp1VFd6dHhn?=
 =?utf-8?B?NUJxTXlWZFdMMmxoZnEyTnk3b1Z1NlVzS2VFU1FDdjYzelZZYkNnSXk3dlIy?=
 =?utf-8?B?c1h5S1pLcS85Ulo1TjV3eG9vSFN6SUdsb0M5cy9RSHZFdGdzVnE2QXVSTTZN?=
 =?utf-8?B?aEsyWDJQUGxSQ2RsdDBHSCtqb2o0THJaeGtDVGp1elBOUml1SWhwamR5cWtX?=
 =?utf-8?B?RVRUNlJ3NjljSGphdFczUEZ2c1ZzU2Nxa2VYaUFQNEl5ckRDb0Z3a0h3VVM1?=
 =?utf-8?B?RnFZMmg3ay94V1l4OGpaZkNJL0JIVTdYS09RbVhhVHgvSVVQWFgxdGdiOUE4?=
 =?utf-8?B?WnQzUDJJR0dYbkRxNWNQRnpGYXlVTFUvTTlTZVBqT1ROeVd6UDlES1FoOUZa?=
 =?utf-8?Q?omcOCzrhZ43fHSWomdga/8E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xXzF8UtH7JMQNgUxqoFWmIS9JCmbK4c9PUjrZuBhdsQKNuvqCwrOIcmbPYmCVBtj3aRkgtD8asR9P5fR5h0Ddignz5V3+f84vWAcmb7LQolcpaoDf2RPZSujhxzS9qunCQdQPTwfM0zsTP1JypZNiNMcsSlZIWqXSfKcU1xp3hKM399lKdpF9Y8udIk5Nvs6o+5lcwnuS8h8WdeEoE3dDS2TQijXHYbvYz67Bf50v71OZOWj/erP5XqbaCFdWbsDL0ozAvMhdKuAVx4L5EMIneoo++e4S46Zq1B2NyMKQUgfjx2h7nU6vfqu6VPun3ihueYteJcX5L5GksjH+4tH4H/A8fYQ2G6SLRqTKGGCjCfTBx9CNJA5pid84FQvkA3F0ThoRLUaScmqphEw7xI1zZJUVrq8vOaf67oP639CNosESWzFd0cED/IWI3KKnP0kQlAQDD+nbVupET5XULSnO7AneUhdP+KfXHShNWY3ptz9q+5cYFVKi8g6b7Mqq/RPH4tvN/fAuEOOeqc2So9IkBE2borUqo4DOAbLq8mBPFbP690t/Dh0SHHkfaj7nuLhMKR/n9jX/quAY9ncpsgOI3YkYW+KHD0O6jXy7S942z4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe6274e7-1061-4c0a-ca89-08dcd1c8893f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 18:44:00.9241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jy0S6Rsa9PmWyXjToZ24p9tv2nfyRwjVM4+wHNT1J/QtgaIg3gacEq1Gz7kgNxwnSmIat/8ZioBzlozU7Tck40P59IIINCla5dJIxZHRr3DueThfnHX29/olZ+dwyf+g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_06,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100139
X-Proofpoint-ORIG-GUID: fLEEjSXfZTpj8OIybKiAyJL5YNVlN3dW
X-Proofpoint-GUID: fLEEjSXfZTpj8OIybKiAyJL5YNVlN3dW

On 10/09/24 15:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.284 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
Hi Greg,

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

