Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A212139DA
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743082351; cv=fail; b=u/c4bTim+g04J0tWKlZxPGfcysxjPi3+Qw2nmk67xzb3k9LFBP19JW0jqSuCZ+akKb/STcHxm041UNsIM5XCT/nlPnabPiGPVtydqgAQTBXF3D2O5kYPrpOmBjnE02YtXyEFCKkKHMZh3fYHyQnEt+FurXN15fxupYtePg/ZB/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743082351; c=relaxed/simple;
	bh=ullb04T3D8e/6lkPgVdBZaA2WMDGBAGpXF6+e/oykB4=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h1fjPlgq9qiLGRIy0GyhrYQbBXAANO1NiLZh6U18LCwfdC3UsOepQMt+/iYIeFGSUWtGH7FE+YNwq0xpaA07TEhEUxNwZaWLxG56mQIxu5MuO437zHSe4LqG23IgAxkX/JAurZzXL2I7vlUbCJfTjZsEOXUzMYms7GyPQm98L4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q8yFXzoX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cGPHgRWA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q8yFXzoX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cGPHgRWA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52RCT7bi026888;
	Thu, 27 Mar 2025 13:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ullb04T3D8e/6lkPgVdBZaA2WMDGBAGpXF6+e/oykB4=; b=
	Q8yFXzoXOKsZICo9v4J1kVwCYRi6ddtwrrsBHyKm54aS6MY4uTVUmbX14rH/gOk/
	ylvpz7Fh83BEjIGbasfDwU57xSuFc4yqvGIeyryirJ/oLu3Ex2TC0VwEpEb/IKbD
	eG3fQPTOXMRjAp5mOGidWxLozbJwPjJOC4wY3VmQWsQPltre8Dq/QTkHV7lVo59l
	l559cACey/aGPpGQpusZyyjgkCypUEzr6ESYChr0DvWKTSf/k87n3hg9WyVaN/GH
	2mIdxb4kH6sZdtXMMVLAWNg3Y9zMckgWqwnTJWp56N15JGNmRBbPCXbfmxuvArF7
	Rk4KAyDeh8wGPUGUh5sEQw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn874dfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 13:32:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52RBotpB028719;
	Thu, 27 Mar 2025 13:32:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6vc9qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 13:32:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QHi9XVxwz7AsGfyx5qU4kTb5Dsihmg3WzGQt10PfjkTzhfbtFCjtAolz09OvbZkr0Ksdk8I9WeX0XAr0NOUQQUi2gco7MHG1DBqyvtyjV9uAQHXPbZCc6j6wh3XhWY0lOITNPr28CC6rwgot9XF54CM63prWkWBdQ4rjlMZOk2WKS//2IXoxENp6NvrVw/x5RYGh8UtLteaCchVkFe11vK8vMr3uFZJ51TN3g/jmXhXswj4c8W5jYhWNMdwxIfY9yzAP4IvmTvrVVCGCdFx08UaItF+c9QsHIQ2BwmfooSdcjOERdPRnMlIENpA3bXcIhWf4YO/otdRxDGB7xBgMZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ullb04T3D8e/6lkPgVdBZaA2WMDGBAGpXF6+e/oykB4=;
 b=gR1V/XQK4qm0YdSDpfIxqHZEMwNhVHkAQcmk5MgxQan3l2YzRVA6+t1mQaX6PdUXTDAjmiZSB+zqLTW7z4TTy2E14Rf51Lck9d4hOYAwBnaIdeT3mLEtDcUM5+JTci0BEbgQVXAyasigIIV/s+0qUxbBOwOMukCa6TqjDqK3qmaUlf46BHqBDDGzGsrJQIiVTmuEhogxBkaPjpBfGw+LWbZypYjpdAZSChJdlj/peVQfNVyG6VeZPAXXvmvXLczV7OCgXz5uh0pJ+k3DDnAvCjXFLOUAQfO3Ej4Ib6/spUlU/OohP2SGxWa37+uD51AQa3QQJfAm/pBC3x9DgAD+ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ullb04T3D8e/6lkPgVdBZaA2WMDGBAGpXF6+e/oykB4=;
 b=cGPHgRWAsNZLzsp+Bu6pmFhF/Uh/6UHrCk0nFVWq9raG1SDQMEkm6keg6KDAbHtkyYRxg29+a9bxAQhq2gx43jcBlP5c4cK40dUWLLbZcJXqEdlDgGgZcjg8vUd6Qf4uTrbyvjHPoWhuNiZW0zggUrNvo8OaL1IPQQWSVwOM4/Y=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by CH3PR10MB7162.namprd10.prod.outlook.com (2603:10b6:610:122::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 13:32:04 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 13:32:04 +0000
Message-ID: <b1bc86ed-323a-40e3-b87f-497961393477@oracle.com>
Date: Thu, 27 Mar 2025 19:01:53 +0530
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
        f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
        linux-kernel@vger.kernel.org, linux@roeck-us.net,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
        shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
        sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250326154346.820929475@linuxfoundation.org>
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250326154346.820929475@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0033.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::23) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|CH3PR10MB7162:EE_
X-MS-Office365-Filtering-Correlation-Id: f0e7f360-53fe-4c7a-8dc3-08dd6d33c347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDVJcG1TR0NZN1cxRFdUeGFCTk01T0MzYWZmc0IrWmkwOGpMSkdTb29EMVd4?=
 =?utf-8?B?eXFZUUllVmgvUE9xbE1nV09mQjltcXJueHdwSmdQNkN1WHowMncvaVI0ZDZP?=
 =?utf-8?B?UU0zSHkrd3ZkbG5JVVdtdmJNKzJmR0pDdEh6c2hmVVJMMDJPQW5kZGxZam9L?=
 =?utf-8?B?TE9RR0dZOUtiVktTOUFOL2VhMGthMy9VZ05rblBCaGt3UHNubXV1aTQ2Q05B?=
 =?utf-8?B?cjBWRHRBSGxoR0hQcDI3UlVNMWdaTjY0SEswSHUwZmFsMitvZGF3MVBIZXN5?=
 =?utf-8?B?TDcwYWNvTTBCMTRwSG5CMUErdkRkd1BFMExsSXFYQXRXNUFqWThKRHB6dHYz?=
 =?utf-8?B?aDBlRi9PdC8yQm8rMkloeFdKTmlDMXoxbDlJRGNVVmttM3JHTHVKd0Q0YWhZ?=
 =?utf-8?B?NkgvTnR1d3VUSnNiWGRVMGxpMEhDSnc4M0F2d1R4dURkUllSRDVQQk5za012?=
 =?utf-8?B?blZBL3d3cVFsRm1CNTA3U3lLdDZ2M0FSeUdBUXZFU1lrTFlWMU9aMzFucHBm?=
 =?utf-8?B?RU1PbzdFSjdOTm13R0VQenNGd2VLOExVTEttcHY3R1hHWE9DWURZSXNHV0hz?=
 =?utf-8?B?Nkx0UnptWXY1STdOSEd6aVpVWEE5RWZNQnFRT21CRFEwZ3FRWlR6a0NQa3VR?=
 =?utf-8?B?Ujh1VE1Lc3B1dkhpaGtNb2lMRVZrV3p0RVB3ZWlzeXJaZDZnMlltNDBueEIz?=
 =?utf-8?B?RzJ3MVhyMlU1eDB6SXR6YWZLM041aUdUcVo5RUkwSWttUEVOVkZBcDdVckRJ?=
 =?utf-8?B?bkladlM4cFFJVlRTRkxIVjFDRVBOR3FBRlg5MjhpaHc1WmQzcjRQV2NUNGE1?=
 =?utf-8?B?aEREU3hEa3N4Q1pLZ2JDMXpZQW9rWTVOU21qcVdXTUhabitmaE95a2t6Q2x2?=
 =?utf-8?B?NkJHcGtuVEhxeUV4R0QyaEhBck0xUytXY1NZOWxRdkEwU2pvN1BvT3ZHTStS?=
 =?utf-8?B?T3AwWWpLdEZwWlZJRllBRGxTdDJtR3EzRlBkM2Y2TTYrZlNGTVpGMEZ3KzF3?=
 =?utf-8?B?Z01pSWVpMHZQNTg4cXUrdDhnSmRDa0RITWlPQi92SDBPVlVhT3Q3SUVzV0ow?=
 =?utf-8?B?TWxEV1F1TTFiSTFnb3hZMGtNQjVxU2ViMy90K1dyL0ZHc3N2QytySnROQldL?=
 =?utf-8?B?U2lMV2lBOFhzVytpRGdzc1ZCVjliQVhCLytVaU5vLzYwUHljZ1BlKzN3b0V1?=
 =?utf-8?B?dWticHNTWWRBYVRKejNCMWY5ZDRNazhjTWliTVk1OVBTSC9GUHczbjYxejV3?=
 =?utf-8?B?eG10aGIydUEzdFJlRnBCWXBWYWg3bjFYR3VNcWxyakVaMEo2MkpBeFpDM1lD?=
 =?utf-8?B?YXFLd3JKVzNSbXpHQ0QrUndwVXVhRVVSNWNGcnJYdE05bDRibno2bjRIZk9L?=
 =?utf-8?B?dDhyOElRY0FoMXcyY1RlUzJKc2ZNTkwyMmR4NXJzcFpKVFo4SW1RaEcyN2JL?=
 =?utf-8?B?RUloZ2ZFVmR1SjFBa3FtMjRUYW84M1MyaXM4V1pSRHFTbjBKUnhVcU9EUGxY?=
 =?utf-8?B?WllhdkczcTAzbjhGWEdEaWYyc1dTenhCSlBPdVZkdXpOZmFneklnaTJkK000?=
 =?utf-8?B?cHVvbGVrV1kyTmplVllRbEpIa21XQUltcm9TeVczSmhYSjlSbGlwcW5hV1ZL?=
 =?utf-8?B?MFRqUUlENnUxSlRQZ01MV1BSYzJVQzc0WUpVOUhXMFgxUE11Rm9QZ3ZYTzdj?=
 =?utf-8?B?VFdPS0J6RlVpMDl1ZWl0djdxdTJaclRva1RYZTFtMC9EMFBWU09hK1psbitV?=
 =?utf-8?B?Rm96VHJLbFJNalFocHp1WlpmSlE0b3FmZ3ZUM29ZUnRLUGRlZHlRbDNwY2NC?=
 =?utf-8?B?cUtQTXVWb1JoUjZtbmJ1dTdjM3c5UFpTSkVsbUVQajZ4OWdGOWtxc2habkt3?=
 =?utf-8?Q?MK/AhGhqHkgFZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEFwVmpNcFFvQUNYQlYwbGtjeVRyZllqWE43OFNuWm9Ocm1NbmU5WDFsUW52?=
 =?utf-8?B?c2EzS3ZnZXNUdlp3VzV2NTlUNXN6TzhKNGdsa0FDME5Sc1ZqS3Z1T280Kzhz?=
 =?utf-8?B?TjRzbVdwZnNqZTRSUE5OWTlJZkpTYzRJcElCZ2dIYUhmTkh6OUVoTXRZKzBB?=
 =?utf-8?B?NWhKc0tpaGlIekhQdXZDMzZRdmtUT1dQVmRUeTlVRXA4SXlzVzBjcnF1ZnFi?=
 =?utf-8?B?dHVwR3AwQkR0VEFFa2l1WkV1aVFHaWp0OXRSNTNKN3B6T0FoU21hd1pYdzZs?=
 =?utf-8?B?Mnd3QVVyWGVrODhaSEkvN1hIZXpjb1NscXdnS3loM00yUFkxRm91NE9mME1N?=
 =?utf-8?B?aGQ3SnJCcG9rY1grM3FIUzhtT2pMZkovaGlGZU5CZDFWdXU5QnNtN09NaEtT?=
 =?utf-8?B?L2RwVDN5UjBPaWhtbGVwWDJZWDdnR2hGOGFIRzFVZmpMYktManR6NnY5cE80?=
 =?utf-8?B?QXpMN1JsaWIxcEs1dU5zVWwrNkVNSDA5aXJETWh1S2lQNGtLYWYwZ0FoNW4v?=
 =?utf-8?B?V3ByMjF6eG9zdTJHSUYwTUdVc1lqL2FSN2MwVmNIa2t2aUlPeThVUGNoK05O?=
 =?utf-8?B?bkxmd2dONS9TYkhmRjMzem93YUt0ZkJINHgxTmVkM1V2dEdQY1NUK0RsdnJV?=
 =?utf-8?B?bmZaVFZWREF2b3E4YkdqQTQ3U0tmRjRNTEplWnA5TkdXYXdodnQ3MEgxN2V6?=
 =?utf-8?B?T3U1THRVek5WV0FxRnVVT0NCc0dDaU5Xb0NPUVJ0UDJvTWFCU3pFNys5ZkJQ?=
 =?utf-8?B?L0oxSmV5ZDRvT3lhM0todFZtZVZFbUZvNmxNQUNpK1dUcytkR0FMeXdsa0t6?=
 =?utf-8?B?U3dxOHV3cmUzcmQvWlI2eDZnRy9zUlh5NUR0aU9Zb0p3QmNuUng1MEtDRjZ4?=
 =?utf-8?B?akhubGlaTHZ1UkdMcG1UR1hhSnE5NlRqR21EN2E4M2FqWTYybGtpRm50WVRG?=
 =?utf-8?B?M0k1VjBNNGd1L2hBTW1Nd2FraE03a3dyRzVBaVRTZGpvdmhyT09KVE01d3J3?=
 =?utf-8?B?Wjd4OEIvUmxraElDVSswY2pwYmNDRjlCamozOXgvSWRGVVZNYWIvRExIN0ts?=
 =?utf-8?B?NkppQ2pnSloyZTN1YjVPSzQ1ZnF2RU9VRURheEkySVpvN21oWW80YnNIeklw?=
 =?utf-8?B?cStSYXc1SEM0UXMrenhKVkdTbjkyVDVqUGxJRHNFQVJBaTFnQlVLVk41c2gr?=
 =?utf-8?B?UTdvREJhbFhDenJqZTY5OWJzbzhwdDB1aFhzNzVDWk51bjZqNm1SVVA2Q0Iy?=
 =?utf-8?B?d29mNW53aXFaR1VPTHdUMFhXSElHWTZRQ0VNNzFIMkR2TTluK3dNQ1VLcUJC?=
 =?utf-8?B?N1cwc2xxM21wak43c29mYU16eTc1STdTVkpZdmpid3gzNlZlYlpVc1NVdFo2?=
 =?utf-8?B?ZUl1Rnh1SlY4WS9rc1dpTG8vdDdBakEwazh5WWV2dElFbC9hU1U5cGxZbzdW?=
 =?utf-8?B?OTBUYW91dUkyUVlXMXBqWlVjWjg4OUNSSXVOTC9aalpxcjAvSDVNdzFoWTF5?=
 =?utf-8?B?QWtHR3pLWTJxaUZ2bDNva1B2UkgzZ0NaUzBkU0x0K1BUTVZ4amxPTklrVmNH?=
 =?utf-8?B?MkVyenhVTU50dG9JSFVGSFdvd3NQUXN0RjFlQU9MZHA4MllFcEgrWmFHWDJD?=
 =?utf-8?B?U0tPNmtIWlNrWmJWWWZ6VGhONzJTTjRhZlNlenA0Q1FZbStOcDdDSDVKTWFx?=
 =?utf-8?B?TEc0ZlpScjJGYVliU1NoVXVRck1xSkxQVllBNForODVRb1BZeEJsMzBsRGd4?=
 =?utf-8?B?NjJ5OE1mcHU0S1Vaa0xWaFN2T3Z1Ty96cTF3TFpsWUNBVjN4dkNZb04xMllK?=
 =?utf-8?B?S3huVk5jN2didGJkdTlZNjQwMFMyMjVaNmE2ci9TR2NWY2lRQlNITWFwbFhr?=
 =?utf-8?B?SFRyaWVkMTV1T0F3ZEI2c09kUk5aVFdJRnhRcFRGVlFEUXdKWGVMOXhoZFRr?=
 =?utf-8?B?ZzhSZTJMZWhhOURVS1N3QlNpSXRNTU9YMEw4cWovU1l6SnNIbjVWMlc1eXJo?=
 =?utf-8?B?V25OUnJUN3YySXVCZWlpand2Z1QyZXlRSG56cTQzVWtpYkpVb2h2VmN3LytL?=
 =?utf-8?B?UmREZWtvRVhURHZLbERGd2orTjVXZzRZMzJ1dTdyT3B0UTV5Y2lrcmNQMktk?=
 =?utf-8?B?OTVPdTN5MTJZRXA4by83SHRRRVI4QzlqWmN5UmJ0RG5TSm00T3BmRllCZFJx?=
 =?utf-8?Q?ejYhI0hkxrgeKM61nVjjlY8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ba1BVUvm+YYDbwsg0f4LMEjcXuaB/NfLTdcE75rgoacy0W3597C+oXjNmJy6t2/Ce3f03YCIYGiNLC4q+zRVwRo3st83ivy7X2LcDLihKOHUUXM4Cf2gtQyo6VnB5Vj9o95TTESHhPr8dGkqlof2YNKlrTiaFAZB+FtxkOMnBqKtABLzReUhWBP5QRnGo4XpUXjNK/CtNNidp3Dd6QfGBDRkckyUyfjUo2hRCK+1xRC1gey895D50A9edmoobc5r/MwVNeQ+NEFpy1vg9NPaV6dAx7sg+APEGbE6M2sBDQUbSSvHjD/Q2Qe6/PgzZsozKg3iUF/KAvoTZ7xnqcXa8zD/HDDeud6vJ4MQgQ4pRJsdbFSz2CzMyaioB1tBvr0Xb8eaR/ulgZjelIGnqNGmA4r0wMfj/Zzk32dax7IMMyb021Z/W/9hqOXNnM5tJRKfLdWX8LipyP1gp838jDUzPSN/OVNM5cHl/eIpneRCCnRu1AksgFYIor7Cs94Ih8VhDit9a9YggVAvUvm5sk2g8+XO5fCijeebQx8DC+Ywbn6Yg837anh6dFwJ6kC2AaBiREWV/tMW0AuT7HzVFM6TFkKW/My4IWPp5gW8X/IANEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e7f360-53fe-4c7a-8dc3-08dd6d33c347
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 13:32:04.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmmMaJq9E1gtsuXywV3G5r0FIOyDG21fFNRHudUBx767xZ/u+Ys2zJ6zSLZEw++OfZxnURawKjcoqSvLqMS+WEjhWnwpnhDNdnAMgXsV4QHJSrk39Dv4+mzbhsLqgtax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-27_01,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503270093
X-Proofpoint-GUID: ZfnHkjkd-T3TkLI_yT8uw7vaZ4uxpOPl
X-Proofpoint-ORIG-GUID: ZfnHkjkd-T3TkLI_yT8uw7vaZ4uxpOPl

Hi Greg,

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
