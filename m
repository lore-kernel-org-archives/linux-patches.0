Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278A150994
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718813907; cv=fail; b=EevchqYqnTwPtpG6scuB+XMt5NjBe8Jt1NxAVzYsZlR4mh5I9FEnVC1FD2Y1oyt117++cga8sorVZ0v15Io3L++48Hwbj4cK41OJ0VgTjGf9XBrt2om4h+oR3JpztdIFMSWlXiYwh78rZT6RB4xOulU9UrEJxzPr63QQaAT6xTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718813907; c=relaxed/simple;
	bh=Mgx7Rr9tU5q+dEcXxVJfimMipOJ22zeOe+DpBGaXQUc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KPCGz6kX8x++tQwwIv12wpM2vHt93C16937bBspI9p8kWnaH96VwhhLG/IFJc1fnG8vjmtbbr5DYd+GT/dSVMAPZPYpyHZW1bPe7pU9YGfEKbGq4ppn9bwEL0yIZt/9fa7kiZVcuIQlua0CtvVz3DBbIpERBQPt+3SFqDaigcpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KQHTZOtZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GQKAxnTD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KQHTZOtZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GQKAxnTD"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JFBR5N009000;
	Wed, 19 Jun 2024 16:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ItgJXpnqaw3kvcrbwzQPBNmPppJ6O8pmiuE17EbhiJ8=; b=
	KQHTZOtZvO3tYBY6iRX6we6ZpjlwX7DdcLAO+xiQEA9BZzLSy/JfN+z41CvZ4g5k
	PfZm976RxKHKSdp+//ZnRUKTjnBH2whkCws2upzONceGrs8CKQcmFfAB8VbgMy1D
	g0MZSxkE5BFED+0XC0Vq+8wRtbaiMa8lUONBdpyZGgXhf2hfol/aNu/k2+feaX7Q
	c9ka338tDhhcZZA7k22ul9FeMQifFiMoVbhPRYLn7cgoJVPO4nAV6LAVxNqVdRNl
	gS/1zDdPirdEFtzt6NPT8UCKWSR5BlJzAylD49+XWHeEoLHuUtrbfAFG626EAcZp
	TppJiaaP+3VQL8n5glWHRQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9ghmx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 16:18:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45JFUmDo029099;
	Wed, 19 Jun 2024 16:18:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d9srmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 16:18:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3MyTAa4v16M9kgCUqYuIoKrD7bWiHmroL6CSXRrvwss2K117HBInS611Kzm1gIBZkw5h2+KFEMyTI505zu0OA7itx01k17V9XCQqCsT7xH4WVksi8/gfh+IrnFMu5QBParwGviM89DLkAogf7FjEgVACBHFBe5fEcpuyFtKL/HgTN9pNDVarKlzMlG9f7/IaSJ0cjLr3OKnWebm1Rs43wTUhkJY9yv09x6bwjZVMTJ/jmlMVOO+FQFwN5qp5Cz4knQg+y9s/38Q8NbR537ideMngzSDCVWR/HY/jcSQxGO1PS6avQTyDkf8ZhrXDugJxhczUl8JJ8DTxfwyAq3x+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItgJXpnqaw3kvcrbwzQPBNmPppJ6O8pmiuE17EbhiJ8=;
 b=RALV02JgJajM+rDo476vGgZNi1XQgYWL81DvX0bC7yWS+FpM2Mr95G4lJlv+UIUDXHCGveqV8g7V5n3VWADmv2iAhBSKsNE196Td8IjdZg+GUn+OlUD6wUTqbTnSfRDlWEvdHplH38Fy80PymYIJRM/LRh0BWRqxERXgkOdb7d3iuQwD8zgDZjNQpV2sp1PwhcKMRXSL2NvAMNRwZEwrq+Kcr7EN2phrRCFTo3pt1j72yfDM90yEYYh6QSqUIzWGZnrkzFlUND5/oksdVYbD97sFSVsutXoeusmhkEW4uQtzWNhteeZc+sC58Xl0xg4oTTI/mwsHjahhmATDLIjK9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItgJXpnqaw3kvcrbwzQPBNmPppJ6O8pmiuE17EbhiJ8=;
 b=GQKAxnTD3RpMIJdh2GiV+z/d2oi5t+Nd4TRe5wFz8ucOFk4AVqjOBQhN2gPJLUyWo43xTJ/BdxDU/BxBUL+BFR12QmltwTsOLdrPAneA0o/3vhQakY1gqMV0bQfOPT75VSTVmydtAYdvhi0kcqmhgvML0n6j3VdWSrdB1TzH6rY=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS0PR10MB6030.namprd10.prod.outlook.com (2603:10b6:8:ce::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.31; Wed, 19 Jun 2024 16:18:09 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 16:18:09 +0000
Message-ID: <059a33c8-ce50-40eb-b7c6-daf4601c22ff@oracle.com>
Date: Wed, 19 Jun 2024 21:47:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20240619125606.345939659@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS0PR10MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: 356c26b3-ac1d-4206-e0db-08dc907b68b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|7416011|376011|366013;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dkFtZktBZ3Q4ZlNJWVhHV1BodjIyNVNPbnFQeEhRS2lLdzMra1hiSzRxYzlY?=
 =?utf-8?B?bGFYZUVCWFdSakhTWTRUcHVkOGNnbVk2Q21kNnBVWDh6WE9xRk9Xd2k5dDNP?=
 =?utf-8?B?bWhhU0dzTmZTQk92MkhYeUVzL0dldzhTYXZqZnMvSmdTQmV5WndhZW1iaXJp?=
 =?utf-8?B?L3EzdmVOR24zcWZvQ2dJc2tEZE80cVFGdllFS3pVQkdTY0h4VWRpcFdrdWN4?=
 =?utf-8?B?Mm0wTm9PTlZ4cjRZLzQvc1BJUk1iVFNzRDRJNlBJSGd6Nmc3OXN2RU41ZmNT?=
 =?utf-8?B?ZlNXTTZFdnkreEFrVFZWMWFxZHowL3k2bCtScTRKME5mVXY4NzM0ZHh4WG9G?=
 =?utf-8?B?TG42UTRMWDN5YWd2V0ZtdVRRSlpkTkhvUGd1Q09HWk9TSVJidHRjZW1XaFhu?=
 =?utf-8?B?ZFBkaWE4MEV5Wi8yL1dRTHI1dTZIQytXT1EvaFpvNHpzdXN3QWJCdTg2U2FS?=
 =?utf-8?B?YVFCOTlud3F0bk1xT05CZmlVVnVvZlhOZm1uMG1ZcW1VMTRhdjE4THUxYXBu?=
 =?utf-8?B?dXFFeUxsa2VPT2NweWNNL1FxUGxrQWVUTitiOVBSNHBqWk91K0p6U2FveGtt?=
 =?utf-8?B?eWFrR0FVMFhRMnlyZFZNNHlXZzM0WHF3MWV0dTZ0ZHc0T1hrOGV0RlVaU055?=
 =?utf-8?B?N2ZjNlhZWk5mbmJZQXZQalR5bk5WUEtCWU5IdHhxWDJSdno2bmhmblY2MHRo?=
 =?utf-8?B?RDhqdFZQbXNDbjJTM0dVeFNjbTZRbGFKQ2h4NGh3RzQrMGFFYW1UNmZPdEVa?=
 =?utf-8?B?UC9lbHg3RG5UVHZ0WXlGMGltY2gxak5kbmlNWk00NUt6WVI4MDlmQUtlWGkr?=
 =?utf-8?B?cDFCd3U1QlY1b3lJZ3FwYzlCV1R5VWdxWElXbFRWdklYMjNtcGN3eXAxNTZw?=
 =?utf-8?B?ck1zRDRIN2xGSWoxRTZsUXpYY2N4Vnd0YlArNzJ0ZWlWcHh5aVErVmZjUGdR?=
 =?utf-8?B?TENUdTl0MVgwRVZTRWZseDQrU1NTYWxaNm1penI0ajE3U1JlY3NSTXd5Q1FH?=
 =?utf-8?B?UFgzajNqZ21DSWxFSmZlNzZieVRxWWdETVJyVTZKeTFkcGFtc1BwcVFLRnRv?=
 =?utf-8?B?UFNRUTBtSFl0ekdsMU1TQWh5anhQdWJRUGQ3N1pBcGpXN3BycUpabTlHUngv?=
 =?utf-8?B?NHZvSkgrbUg0anh6OWxKN2xnTk1NWElRaHBFWXJ5VW91VW82d1dOTFpGVG11?=
 =?utf-8?B?QkNmSWtrcnBLTEJLL3dvZEFSMUY1NDM5eU1Lb2pVSSs1dlpmZ3Y3a3h2VG93?=
 =?utf-8?B?SE5QeUxtbHFKNHNKQkplY3ZyZGFZd3hadVZXNzhtVHJiSEZ0M3BGYmpwMmMz?=
 =?utf-8?B?ZGtVQVBodS9meVZTNmtUeUdOQ0JvaEo0UXYveDFVUk9UTnhaZU1WdkNxWU4r?=
 =?utf-8?B?MHBTcFBhaFNHY0tzRGQ3MjRaMmxIZnd5dUJGTmVmUlViM05yOFhmblpmQ2p4?=
 =?utf-8?B?ZEZOcnNlaFJkVHc4QjJFOTg3NmZsMDdaeTdtd2Y0dHhCa1ZrWFZWbFVsSVNo?=
 =?utf-8?B?YVVuNUcybTAvdzZBZ1U2Q2tZZFZ5VDIybzM1KzUvWE1FZG01b2d4YWNsTFVW?=
 =?utf-8?B?TVZMVmNZSldvZEVYWWxoTDV6L25aaCtKdFByalRRQ3ZXUURYZ21PaFA4Skhv?=
 =?utf-8?B?N09qOVhCSm5lMS9HaS9SVjJGa0ZPbUd6SjBVQ1lyVW5zZW1jTUJuTm9tUE9t?=
 =?utf-8?Q?XTeBoXMWilEmn6t1wJvv?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(7416011)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MytZNWZmekVrWmhyanhxS0t6TmVxWWpZSElnSk1KVVp0dms0eUZyUzF1MG5p?=
 =?utf-8?B?UUVkRmhaRHh5b2hSRkdCbmZRelNrVUxzcW1PVTFtQzdqZGNiaDdIYXQ0dS8x?=
 =?utf-8?B?aDc4WDZmZHV4MlVIaWFHN1JrdFNkbXhSSFhOemZ6b2tyOXB3ZzVzMnRtTTdF?=
 =?utf-8?B?VTRwT0d2SUJzQk9idXBCSFB3aUdkOURiKzk4RW9jazBFK25JSmZHTTB1OXQ0?=
 =?utf-8?B?TUxocS9uUEtzZ2NicEdtYXVSMFdOdEJjNG9sMVpQUW8rcXdSS1NTZEFzanFx?=
 =?utf-8?B?UzRYSWlMeGNZTHZTVDZWWFFjWWZJWDlncS9yNVVBVUdUTVlJcFIwQlFQWjlo?=
 =?utf-8?B?Qm9mNHlQVWRXTGRialVaMnNPdTJsbGR5VGI3UEtYZmpCNDFPVGpLSGpZeXJB?=
 =?utf-8?B?aVBTenBYQjdiV3JsVUpic0FRbm5HSTJlNGorMHBzUHplUzhVMTl2Y2ptMFU2?=
 =?utf-8?B?dGJTRzE1YXNBZ29MdndzTExuYVFXTWE0KzN2ZWY0NEdYY3pvTnJkdFlPL1Bk?=
 =?utf-8?B?Ryt6QkFZeGNEclo1bldkdWF6U2J5d2RRYlB1V0JMY3BYM2EzVy8yOStzcjI2?=
 =?utf-8?B?eGhtRloxcUs3ZDYxbDVmUnBGN3VmYXR5cnZyaXB0elBjMmxKbWJmZGlsS1k2?=
 =?utf-8?B?bHVzaGFNOVVwTmFPK09zdmNXZTBWelhTengrV3Z4YUtkV0hvWDc5REJuMDhy?=
 =?utf-8?B?UEZUcXJEL2dIZXZTdDdYeW5KeDJwV2xpUG0ydDdrcjZFZkJHOWlWTXFiSkhl?=
 =?utf-8?B?ZXI3Ny9EL29DWFk3TVBhOUVZSmxWalRwSitMbXR5RTJtRGVCVFdtME92Z1dW?=
 =?utf-8?B?ZDF5MzQ2d05QSjFSWW5CWERjL1gra3pXUFZoYjBUcGpSOEUvUmJ2bVRGeUVU?=
 =?utf-8?B?ZEd4MVNpdDJaNTRZSG9DeVI3dVVHbG85YWFETjFUdnA5eExzNWJSdTUxRUVt?=
 =?utf-8?B?VXJUVmZINDR0SE5iZ2dBQkdLbGU4T1VBcjNqWGU5OUhOMmhnaloyaW1oanNK?=
 =?utf-8?B?WnNLSWc0QkdFTEt6L3h4eklHN0ZDcS9IWEh2cTZJV1hMc2FZVnlrUUE4ZWdn?=
 =?utf-8?B?MDFFQ3JpOEpCRVNrbHdrTFdadGthdkZRL3pxQ0hDUkE3UkR0djYxMFJzUzZi?=
 =?utf-8?B?UW83Y2VRY0VLOFVjLzdRK0JVYkp1bEprSmZyRkYrSlFFZVZabFMrSkViV2pm?=
 =?utf-8?B?T21mNXFYRk1sZE1RWDRlVmNZOHFyem8yajA1aDNSS0ZyQXlsSDhKMzkzbmZD?=
 =?utf-8?B?N0Vpd2RPVmZkYWMyQk4xcUp6RVFLbytpZXB1OU10Tk93OWV0NTh0ckpwTDhw?=
 =?utf-8?B?K3JtSExBaU1QV0l1Q1lsbGpxRXVYcmplK3QxT2dGcFJ5M1VObXdoUlYrUDFM?=
 =?utf-8?B?Z0tjcXFjSTNkVFJJVHhTYkJvVUJrbnp2V0RFVlQrSFNiRytDbCt1UXVpYVhq?=
 =?utf-8?B?WVF0d1V4U3E5Yk53amthenV6c2Nac011ZjkyN1lpVWhzbkZCMXl5WThuU29x?=
 =?utf-8?B?d1BjVm9waExGUnpYcm9EeWZGUWplNWgyVDNWb05aanpOZGROcFJNWGJBNlcx?=
 =?utf-8?B?bFZEdjYxbGtIWHdCODYrcndncnJia1Z2cnhtek40MnQyQnRXUERwdERWanZW?=
 =?utf-8?B?djJ0dXltV0hTUXdXZU9lVlVmVHhzVHFReVA3b0dnQWYvWFBlQi8rd05laXpM?=
 =?utf-8?B?dTJONjNKZXF6SjZlR2FXOXpDOUU5Y2plbkFQaEpSWEE2WFMwUWx1UVprRms2?=
 =?utf-8?B?ZGd1RTEwQzRHdWdnVWVSQ2hFWXYranBvVEw0M0NLaThuZUY0ejIyOFI2MDNW?=
 =?utf-8?B?NFpKZXdBUjYvUEloRFNxeGFvelMraUE0aUVEaEUzbEZPWjZKU3owNUQrQU1K?=
 =?utf-8?B?amxSUU14Qnl4RzFtMk5zRUErVmdIN3pKbVJ6UlJ4ajZweFg2dlZjT0dvZDc3?=
 =?utf-8?B?eFJTZHNqdkJ3OEhIMEhjOEI4VXp3K0JPVTFHeHdrQlJkNzArZmRSRVpYZFFm?=
 =?utf-8?B?YnNvN3ppWkVDbUxxa3B0NVJqeXNwbW40SVpKQ0lYMWluMlhUM05hZ3llL282?=
 =?utf-8?B?ekdPZ0I3Q3FhVnhNOUFiUzFXclMwa2lOejZ1cSsrYkhqSVBaMlpOM0JVZENJ?=
 =?utf-8?B?RHNoNmRpNXRwaDY0UlN0VTZMY3dVZ2pMcVp0b0JyVFdCbTlwcnZhbTk5VlJV?=
 =?utf-8?Q?lW+G/7r6bXucvg1jvIsIfp0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tiq2mQfCGIyIz4kF+Ca2UjBvvrVMsc6O0UmOPiWO29C9nk5qldSzRtKAHh6Ec0Nphr7uXX+GWFtDQeN97+35DnOAN0JGmjPB/JVBFFl0ou73dsY5VwPDd2y3wY6T17R6sLthdLIbZZp3JsT+sTcnjqurOMccldJuQfRsdnjiNu2ZE3tNaUYJBSPwhg6H1uYc/g2cIYjuXpN9xKe+fBdF5yU6RMzTlmTPd1QkfsWj+0dIxvtMYH3fLU0+V7P/Lm+FnpJRuYA+jHlGYTxl6oRp23TrqJOKdoDljRC4t9Gs19IWU41sYOaGFXqrFjlkre0BTeCIEZXO9gUD+LyT1riKLVkP7ND5IPXf5vPKFQo4JeYLltGt9O874GiCg0y0zPEwjI14r8fNU29nzCLJCJfQyqnoZHGLWN9XQL8bWXdL06MCHkyNQ12cPAiKSaP3msLkVoWUuniwdW6NEezGqsoF+dbENwW+C2v6vUBYVCamSySveu7vg5otuN8qMIcq4F54JJvL7klZ4EHzQ7MZxkzaEFEWcfKlFLEc8HZpuxJ99IVDSxkejQNNsjpBiNnMsDzmLijPhsXdI67CBokWfeCQShFT2V0eWk9PyK3xgfvOtc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356c26b3-ac1d-4206-e0db-08dc907b68b5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 16:18:09.5096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndv6CgIgAIFpYDQXS+omk2fq6OPkTt/4Uk4n1g6VFFzs9eUCuKsPZTedtKqNLfzix7FftcwVbdHCaE7ZTXwm/g6DF5oJgT7iqLG2g43/wiSy9AXWYIZiVclD+KcbAit8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406190122
X-Proofpoint-GUID: WdpesvuZeMvmrJTOgJNBSoLtC2eG3vbI
X-Proofpoint-ORIG-GUID: WdpesvuZeMvmrJTOgJNBSoLtC2eG3vbI

Hi Greg,

On 19/06/24 18:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
