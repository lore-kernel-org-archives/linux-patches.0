Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E1147C90
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391757; cv=fail; b=TVttkYcMDr8RfEke1bbDkeMCoWR3gD6dxVWYEdEp/b1qTZhUlnQNB1akaephntX06/HnHi+BTtsXabRSU9uX6f15cc8sahZ3gVauSa6ot1eL5RbHUUvQYhcUr9B3bwhWYGz4qiOPGFhHqJuaJsW5LFhcU4WSiTv3MwZOLsu8u+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391757; c=relaxed/simple;
	bh=V4VRPsb+HXlQTCGcn+6GxlqfNJMXgikN6Rp/brLImXM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rBPnVxaOdpUpDmrKhxqTbNLMhUMvCMZz8eSbn1MEWRA8YqLVYYqLO9EYFikLEvKu7d93iyzwbGiHabyZc9ThwF22VbymACEegyN6/YEsaHdhA2rMdcRqhgTfdfk2MDdTYPNnP+RxLTc0qqzTryciqs/dMILdBxYOClz9Sy5YjJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c+BsBaKg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QWVsM7kY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c+BsBaKg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QWVsM7kY"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45EDH0ds028765;
	Fri, 14 Jun 2024 19:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=zb8hKFCvlqcCoU0w8ee+j564p/NWl5pQKXkCa+X9jDg=; b=
	c+BsBaKgs6AAIUpBKduFPJ5ixHO9iAd6iaR8jhY3pEDFCMr/fCxmrYTCLGdQQ9Ri
	fevoiM3kBKDIZ010eAxtkWkFzwDVyu92c+sObAppkMIKl0uLS+YkLV+4vbKuLhmJ
	3rC9YHdMU+eT2hYGC8oQ9z7rCWF5mjygf4NRsOKeFLd5nMm6iyI+MCsfb4uQa3iF
	NVaJd1f/H1/YW8kLE9KZ74uDtiPjpwFkrSdBkqucnXWoJL1w5pdwIWVb8hzUJQ7P
	q9Zl2PSVc7FrQ9lVXmgS++B2isFGJWQz+/ZnA69ys+EnY2f92+1Og3azjPFiP6sD
	IDaGJa2jqoEwuT4JWWzLIg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3pc7sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 19:02:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45EIeexW027078;
	Fri, 14 Jun 2024 19:02:24 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdy2qve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 19:02:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLvfPa2lM0QHen/xH9C8y2HsV+h7HrwExDKfoqY8PviQ0gDeOygpaH6IsHrNS6fs9J5m9ilM78M8uiufrwrjI0K+ZT2r4k2F+b/ZBo79bDMJOhivPFyCRjHaXsBO2hfCr/ILfSewvQRA/ZNFhSAQ31lKf3JgbnvAPnYwcOTHzDtWlFxmLjigWl8dvd6/lz18pQg43O9H/5T7+3S8/OMhrChp9bfL5yTZZupEMvEIp9FG7IEWGLUoJXT+jwmbyHO56q+TUiH3XJ1IwIN+EOFbIk2fMzZN5zCQSQOb+/g/ugonUFJdcMUMksO7fsda7nTRqum/Pbdc2fR8HzpO4eafwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zb8hKFCvlqcCoU0w8ee+j564p/NWl5pQKXkCa+X9jDg=;
 b=Y8sCzg3cjtJahNdYlwwIuN6O2RTmyO8JR3RjT4a3auUB11vyw8vxpJGdMYEayCnyqqOv4HgQ8kytSnaPj62diAz6smhY1hiEkMYaepsWaG8bO5h+R2diMUtRijBMK0/l7X+CLYpBF1fIncyMqcNyuPnYW2/QKidPLNOmuBzrlWEYBMIcGri3E+b3T6E4ZY7/GflXN0WusuTqLrGxzGj6f3u2+4hGIYd9TtcMVadQJDI7XXI+AEUkmVJkoGlSkUgyYkhUsGTLdjEAG6RbeQdu06vSXo3MJx8o5EreWKx9/S85aW/zXBgO6VdTkWEuQt880OouMCDNyjOODy8diCSR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zb8hKFCvlqcCoU0w8ee+j564p/NWl5pQKXkCa+X9jDg=;
 b=QWVsM7kYik5IeSHlibM3koYyBhMFgLdOUIxXBA7TaSUPhJzEm4Xdx/jw6i1BQErA5jy8u01cE/0UyIzAzyTB3FThNt7WdX1N9N97kBRxHoHpL23g5L+BncQb+vyDMOexpgihYaBG4oXTF3is3fLy8DyB3xYRBWZZJ8TikrDQkis=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH0PR10MB5707.namprd10.prod.outlook.com (2603:10b6:510:149::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.23; Fri, 14 Jun
 2024 19:02:20 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 19:02:20 +0000
Message-ID: <fc0a735c-7c56-4561-8f95-2590f5ad71bb@oracle.com>
Date: Sat, 15 Jun 2024 00:32:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org
References: <20240613113223.281378087@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0113.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::31) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH0PR10MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c7307f-9a17-47a6-101c-08dc8ca48472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011|7416011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?R3U2WGQ0R2FhTVNSa21MWUxZQm1pdFVsN2VxQ3hwL1IrVUJDdzNWY1E3UVhj?=
 =?utf-8?B?cnRGT1Zpb01PVndhMk8xY2N4bytKSXdTb0RIRXA4NlVBRG0zc0laMEVndzV0?=
 =?utf-8?B?a1hZQkMwN01hOS90RCtkaE5Pc3V2R0hjRkhxY1ZHdFd1UW1KS2hzYU1Ic05O?=
 =?utf-8?B?dmtXaDZyUEhrYWFtWHNkRUd1MkJuY2l2cTRvdzc0dkt0YmZkVHd3YmMxMHVH?=
 =?utf-8?B?RmNvTTJaNWNxYklacGtwZ2pvRDNWWlVDVVpBOU16V3RGN2IzWmF6TkcxMVNO?=
 =?utf-8?B?UkZ5b1FibVNOcndwR3lQaTROdFRHT05LcWR4QzVKRStONzh4SzBZaHFKSktn?=
 =?utf-8?B?c2NJS3dsNDl4Uit5NFFrcXlRcEhZNVVRYnptYkRzdDB0UGRybVFQY3pZb1Nn?=
 =?utf-8?B?dUJJTm9XMWkxSTVmYnRGVkRkZEI3bjlkOHh0R0dpd1JMVERmdGNXbkprVXIx?=
 =?utf-8?B?NE9WU3E5WFdNTktEN3phUU1WcUsvd09oaE9TaXdlbnA5eHVBS3UzL1crSWlq?=
 =?utf-8?B?bkZZeFpiY3VySmdhY1pjWkVFVEpoeWhsUk5PVUJicmwxa3JuUVdsOG9Kd1hr?=
 =?utf-8?B?RUJENjJsUVdadWg0MGFNdEp0ZTQreEg1b1UwdVJBcDkyZnNHazcvVHRLTG5X?=
 =?utf-8?B?cHhsZUN1ZFcrNmwvNWdBb2tiNW9BS2FXd2RFeGs2VjJFWnJZOFhHbHpKYWV6?=
 =?utf-8?B?WitlT210emVkQ0tGbDNOcHFvNzFGZHltS0wyTVplZTU1QVo0THk5YzVNSThZ?=
 =?utf-8?B?K2Y1YVVibVR3L0l3Z0hQMTFXbnh1WUJhU01rWUM4eGIyRmxaQVlDanB2SUNW?=
 =?utf-8?B?ME8yQmpYSStaUmYrTTk2WGNzcGJGRkwwZy92NUUrZTdzaUNBekpaQ0tPSCtx?=
 =?utf-8?B?WTR5TXNEVHRmeU9selV3cWNDVHRSeDZKQVRScEg1eFN4NjNrZ0U4RzlhcTFF?=
 =?utf-8?B?Uis1YXd1R0dQMUdZSW5tV044c1JrNmxXeDgyUnZDU3ExWEwvZTVKblh4S3Vx?=
 =?utf-8?B?eDljL3FtVW9UWSsvYlY1VVc3dDZDQWtENldrUVVMbFQ5cEUyYWoxZWxOZVll?=
 =?utf-8?B?QTNMd3JBWHNkVFBMZzF5bks0STlBUTlRZkNLQ3pETWVjRnhHVUdDL2tEekFV?=
 =?utf-8?B?SWN5cHVaLzYyWitWcE5ydWlLczV1UFVyNmQvUjVsb3V5VXhsUWI5dHN5MjRI?=
 =?utf-8?B?QjIranFnVHVtVm9WUkdJYWhkU29ud3FPN0h3N0lsOVAwNWxtV0dYZFdpOWRI?=
 =?utf-8?B?d0ZNNUF4eWZIY0hTNzJWK1MzTnBMRTZZSzAwTXliOE0yNDhtMzMvNWU2VlI2?=
 =?utf-8?B?aVg4eGdCcCs2NkxTbTVYamFYQzFaUmVjQ0RZallYT0w2T1pkVjMrV2tYUUZr?=
 =?utf-8?B?VGd0V3RWYUZIdWw5bkRtL1VPTm9RUnhQY1NLM21RMENpOFUwVEZoK2JzRVBO?=
 =?utf-8?B?c2FxaG9EOCtCVEprUjdMYlFFSVIyeXVuVGNxTExUekNiQzZjdjExUmtkRm5l?=
 =?utf-8?B?eVo4R0hnQXZKS3VYeVF6S0FvZlRCejV1Y1BDZGNDL0ZaQ1Rub2cxNDVSb0FV?=
 =?utf-8?B?Yk5ZcE0xQ1ZoWHh6eGdvQUY5OStINGx5aEVab3gvNWpERmFEU1B2alFUbHJE?=
 =?utf-8?B?ZWdtNnlidnJUc0pvZWJNN0owY3ZQeVhyeXlSR0dJTVdCVFd2MFA5VVFmb1hv?=
 =?utf-8?Q?+Z2+UdY1uUqAFtbMW8HF?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Vm9ob01IMmRYaTNTTTQ5dkpMREZjZVREUXQ3WFpJRUhPVWJ0YzBNVlF1Yi9E?=
 =?utf-8?B?aDVwbHVCYVdiZmwxdVR5bHF1WDFNRXhOOVpxTVBNMkRlT2tKc0wvQVNpaHh5?=
 =?utf-8?B?MGkrOHFRSWdTQXVPeWN0dEdTZmNrSGJGYUtaQUtGSE1vQmtIWml2VFpPcmhS?=
 =?utf-8?B?dDN5WnMwK3lWTGYwZGltVlJIZGRRbHpNbHFvbnEzRy9IVkYrYXFaZ2lxYWMv?=
 =?utf-8?B?dFVRdmpmck1EN0NOck9YekJVdDllUW5MUU9oQjVNanJPNnZ4YzUzZ2VyTGIz?=
 =?utf-8?B?eUVkSTF5SXhxOUhEVFFRb205OUVCR3ZvOVM3dWovcUI1bEh1bEw3SFM1N2pG?=
 =?utf-8?B?R1lNSmlhWW9ZTlBsZ1h4YkZEQ25JVzhjR0hDbkg5NXVtM0hZd0FkeTlOeXJ3?=
 =?utf-8?B?eDlWSENDZGd4aDhuNEZKZkxkVTZ2NXFPNzR0WmZqdkF0SjNIM0xsVmpJNys2?=
 =?utf-8?B?aC9oNkFIMHdMb3h6ZG15SlhmOWFya054TUFSemVzUEhHL2thZ3ZidHIreE5Z?=
 =?utf-8?B?Q2pxM2xmNUROcGxpRjgvM0ZaUHkrVVhnZU4vSWhOeTJpcWJXbWpnMkhOMHgy?=
 =?utf-8?B?dXFjOGcvRGVWMUhaWitzSVRGTGRxbCtOWG5IMkZxVkVJTnovdEVmMTVVaDla?=
 =?utf-8?B?dWQyMEw2TDhXR2Q0ekVXbFo2N1FsSWQrRmZUUy9mSjZCOFBzR1Nmd2pETm04?=
 =?utf-8?B?Tk5yUmRqd2JjdDJ1SktTcUd3MWZuSUt1T2psajFKMUFjaWFYc3RkeG9pVm4r?=
 =?utf-8?B?SXR3TTZBVlp0UUJ4MTBSYlZheWlUWlYzRCtxeFd6QkJuN09nclJ5aE12YmxX?=
 =?utf-8?B?OGZPOFFwVXpqdldoczljdmdvdEp0U0lweEs4L3FOaFQxSWFCYXRMZlhuOGpp?=
 =?utf-8?B?ZTZERGl4RFFwVjhqdi93TU94S2Z0UkpQZDFMVS9mc2VqdXdaWFJscTBVVFY3?=
 =?utf-8?B?c3V4R1EwR1A1bGV6NElTVjdnY2dwTGhhVUdIRzRPUkthL3pYbnQvVXBnTVIr?=
 =?utf-8?B?TTRINHM4LzJiZmRkQVRVd1RHOFhpb1hwNWMrZ2pPVjdvdEtwR1FTbCthOUx4?=
 =?utf-8?B?Z2tWWE8zYVdxM041M2hDdFRQZDNDRmR6Qldkc2FFZW5qa2ZFcVV0dG81UnVE?=
 =?utf-8?B?UERuWjBQY1gxT3FWN1AwcG45T1hpR2FMSnFOQy96UTlaMWY1VllTNE1rMnBH?=
 =?utf-8?B?MXlKdWxHeVVQK3h6WWVNZ2NaTXJEVE9oQ1RhN2FuSzlJRzlPaTFkYVVxUGlm?=
 =?utf-8?B?cHV4V2hqaENrN3I3TVYyd2t2TXhQaTNZUWwvcWFuSlBjV1NMaUY1anJ4cnpU?=
 =?utf-8?B?S0J3UUthMWdlL2p4Y0gvbkNFdjMxVEduVjhyeUhBaFgxOWlMR3l5TVVIOFZQ?=
 =?utf-8?B?UHZFWGxyUUtBQThuV2wyMjVpNThzZHJLL2ZZSnkrTms0YXEzREt5L0hqRjFU?=
 =?utf-8?B?Wlg1cGJWZ3JkVDlPakd4TFdMMW04N1grbnBEQ2p2VG5qcEl4dVRkZTJzeVNu?=
 =?utf-8?B?dXQzd21wWFFmeHdFajREZUVpcTExMkhlNTRwZVJ6Yi9IUVl5OHhEeGZ5bUVi?=
 =?utf-8?B?bWZoL2VlYU1oQ3FPZU1MQ1NzS05BbGJKcFAzZkU2N3BjclQ5WFNqTHRJSUFv?=
 =?utf-8?B?NW01Y05ZbkVmREloK0VJb0ZaL1NXQWFPYVRSSUM5TUErWHV6eDRQNnJtd1kx?=
 =?utf-8?B?QVhRV1UvOU11ck5GaWN3RU5ZNWRKRVlnQmsyZWJ6RWNwYWJEMDV4YmQ3UUQ2?=
 =?utf-8?B?VUFVRGVLTUNsSmRhbjBISjhBZ1AwdnU5eGczdEp4cDVZUTBQY2pjWDJFMDVr?=
 =?utf-8?B?K3RtQWRnRzRvNFFPUE44T09pbmpnbzFpZjhERnJoZnMyTDc4NENTTE50YlU2?=
 =?utf-8?B?b0g5byt4QXJYVFArRW1CYkdEUlgzNkxSdWlsWnFkMUY0ajNIOFd2bng1MFR1?=
 =?utf-8?B?Y05GRmtRaGtMcVNReHE0ejBkTnJ3ODZaa0ljSmNCOVM4UlJyV1dJM2tqSFFo?=
 =?utf-8?B?Y1JxdkQwT1dOeXYyQkZaTElJcjlwVnJOa1QvSzZDekt2czlvVHN4TU9RTnZ4?=
 =?utf-8?B?WG5XY294TVE0bXdqUmFlUU9HekVWbEsvUFpuUFBNcGxvcVIzY1lYblNGODIx?=
 =?utf-8?B?RkJ1d0hqREVCNDEzWXR1NmJyQkt4UzRHdW9KTERITEFrbEJBaTQ1VkRkejFK?=
 =?utf-8?Q?BjeVC/C5qMS3OdUR7jOxY6k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FYefZjbNnRFj5MUsYYH7d1Pvt/xQrIbhBKc5+aR0LNrxVp8ky2MV/bBjFxaYmiZMsRZWt+jvFFNg32CLYPhWqj8cAEZaYs+0CAgq16Ywly4DbrhGDCjxGuvRsFDZg/W1fYQYHiEfWQ/haTc0rqjJlLxp/uEMKw0gq4pk/1Fh7PtIf+n26/SyYniHlrHPCaMy6HtL+CQDTfYwkwRikUvFjUDZKoUuLkr1oYTslE5qwcBEYNbC4lSq+tnwURYMsAscCLk8oEPYkyZv88Z8LawoRELo1OYokswzKTJQqr268FzuCoCDWATqArUHkJYwQHsk79w6fT9E+SWcY3JodVSrHsmhnxIyEkfYc6pvB3mfKHgJFY6omvV8hnudResmntjrvjRbi7ByAtwBdAPfrsikIF5/k5at6tA1p5txmFtPJsEBf9G5667YAHwjbfmHePC+JQxgM565DlF8EE3wRPWz9bXxI06Hz929yrw9rxiooBjwBrRS4sfTGpWQJ+R9pJweYK7AJUQsd31mw2vbRfop1ZfZ61ej4//UXgDijmQzl9qGLMmTYE1ebVvvUKpHxGrZUUL0g/shFpFYYkaEAtHhQKi7mlm6FdVvx5ax1AMdduw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c7307f-9a17-47a6-101c-08dc8ca48472
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 19:02:20.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gnEMGrUAvYhVK8SYH5SdubRJMFhO4NBgV97gLyqpnpEVDvPbf6Rr2JQfXh56SkxF46/OkLU8gqvmQ9CR05/aAwmf9Pkr7OaZ1trSCYxfRvHeN7DmmkSYtswlAlM5IzXc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-14_15,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140131
X-Proofpoint-GUID: MQzT2i49kXBHPLMtyuFkrLQrJgN38ADs
X-Proofpoint-ORIG-GUID: MQzT2i49kXBHPLMtyuFkrLQrJgN38ADs

Hi Greg,

On 13/06/24 17:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
