Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12AA49D5AF
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790884754; cv=fail; b=MXS77vV21YdTgEEwSqtDANjJUFE89g6RKA5xU5+/DJSwGGgzvUPh30xKZEaGlhJP5Y7lwGb1FzL+0rl3xERVI++E5UT5kuwWiiEEJ4eT2P7Ged0AkAR8IZteSFh93NVYFVIfsdO6ThOPLWcf6p2+3LvdRt9Mb8h2KXVnHufTzoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790884754; c=relaxed/simple;
	bh=nFEWiAz5kpGKZhHgl5K2n5HHT4KegVBkOY9csry2YIs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t2DHWdZ1BlC0WRWDykgms3TDMmC2qmggZju3QqiQzwLrUckfZMaWn9qa+Psq1hV1iX6zcUOu+nL3MtY9kCyZD3q3sOSMk2L2ALfRNxvm4BGJ0J52JJvD7fUrjJf5YI5DyxpYPib1682huomxUoLxhguJ2D3KEw7BOKomn1g0YN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qvrLdeJR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EaMWWir0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qvrLdeJR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EaMWWir0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691Ftjfa907922;
	Thu, 1 Oct 2026 19:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EU9RmAYE8GtvC5cmd5vKMm+iYrbCOGBofZ2H258oaaQ=; b=
	qvrLdeJRal2FTaQuyDIsa3SYdv7P/HEbWKOPiDsVirRGkEXGbkS25GDeSdKa+Mj+
	5lMTHGK/lBF2f2q+i7uGclH7xL4uomfM8jiM24dC6UC4yXDMQpnGQ8Zvm7JXatzD
	P6/KJF5IgP7GVI086DUMDEABKMcMbcK22PECyeyoPiOOvqGNzSJLEuRNyFF1X/nM
	B7kIc2vJz33hoTHxpPxRkNwoycKoHEpuKjwmlV4F5SSRL4yL3HYQucM74/aQZCsE
	tatn3GbRrsulOAfQjykqky4kunOsIUzyUyVMPrDTgMGo7WrVeEp9tQISLHsCFmF1
	K5rYYwAxpkbZha9RW+q1Hg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4u2j2bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 19:58:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691Jp0Ph025280;
	Thu, 1 Oct 2026 19:58:50 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gsr4wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 19:58:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVmtEy9LDTo2ctJjdLRauZm8U76Vv5j9lERoC1vs9kdyXZ565KprG3zH/CXiuVx7UA100ITeY+rcUPVJjpntgHE+ER7h2rSsH2Jcp0p8otRjEvpsmi5Au6+G/EKzpAM9unEix+b7JxXR7tGo9qVf9bNpiVGpxg+d1K8JnkpRpC9Ze5m7dhsdJVvyt82kYezZHd3m87ot4vFTP3SSaXVJWboDnMftYV2gAbqx7eF5iw+A2Yn9UtiAe9IA4iGBQmvyBNulNi4EoU0Iipr01fTZTHs01PR1lDZfnJf7bRY/yNL9s1p1A8Mh/VmukpgP12XrXG9w5iKEQ2nQ4rekCmBdHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EU9RmAYE8GtvC5cmd5vKMm+iYrbCOGBofZ2H258oaaQ=;
 b=V/7DqIdOfTwN3znU8OkiE+fvC0J92OHqYhE2VikfCeUDzSbFk90bRP8oU6N/BtHlm+whZiYH+EM4ESMkBCZ0a+xNY1zD+WcckoF3Z0glKL8+suyOMXfA0PrnM/TTKpIbvbwwUf+7HS5nCuztCnwe3yyaa3fMUOjgzTyxPVM8/or/nZ6lWefxfVPwWvbtdZ7CZjWhHiE4xyeaRfiwNPCRYztc3aKTESCvK4/p4/lkWOBdml0Zfe19IyXpFIhij92xBmFZEqbQXT4NM2rFa1saMe/cJz3BhgrJ2ReJu8ktjpHt7tJ26nMQkMbuJtxS6tnNJwrTEA56oFqAxMyR8Wxh4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EU9RmAYE8GtvC5cmd5vKMm+iYrbCOGBofZ2H258oaaQ=;
 b=EaMWWir0ODDGTujLqBBXbGnbiSveboaDzz6bqHlCvhWjrf08N7wmLhSq1Fnu+7dG9lmQeCDQ5+/4toiVEP5DA9bWs8SB+YT8yGi7Ux5e2feVzd6OvQdcFa6TPBisk6vGK7XAFTuBmz89F8R5OEF3bqx77ljPK2pM/xLQhPnTOjU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 19:58:46 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 19:58:45 +0000
Message-ID: <0fee0444-1e42-4b1f-b7ac-234b5e19bb43@oracle.com>
Date: Fri, 2 Oct 2026 01:28:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 341/877] fs: avoid repeated scans in evict_inodes()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Julian Sun <sunjunchao@bytedance.com>,
        Jan Kara <jack@suse.cz>,
        "Christian Brauner (Amutable)"
 <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152422.027976780@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152422.027976780@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0552.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA2PR10MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 819fe1b2-86fe-4836-61db-08df1ff666b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|4143699003|56012099006|5023799004|10067099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	iQyTimGGc7gL08NdrHKR6JSdMMHnk8bjhXeuR5ZFiXyFkvndKc+AmINoRrSG3X459x2yJ6Wjc3/i0p5ggZ0W91wIvL39NeszJjCnj9EPGAhezteOvHVhOC1AEfk4BAd5jfMWLJwNYREsghoYAMmrr+SURHY4R6cc6cFQMqQYqBul5BiGi2GzWOFTbQ2plyISJZ9gQu5NwkmaI2y3UDszy1mf6KD2RLyVlSC7U8nVjU4IrQZRNgGjigGrv1k1YPm89RaBoo7htOaaR/u4OAkfBv6Bxwxl18JXnYp9dnPWR1FHVINRKGcZ4Pau4JdHprDr9/Crrtg7wfdeGoJWJfE9tjAlWD5GwvKsAbNdqNM19X+mWV3e/0WVv36CDbHnCbRldGyjTSGpKeLHPbBunVwGuirWvWqtvgP7uff+WgMPv49FpjxrdhOXBvQBqrI2Pb5y66NjzfpCmfInkgSMzTXK1vPq8BpQeCAHJ/JVcsgqr7ltaiR/wJQStShejHBKltVlOOmfvcoek49eVGJWvMbl3MJsnWfCVdoJWM+W1pQj1vVr/P2+wyhW7XrMxz1gIP/fCfEk52Am3IzZ/3eEtqGHHiTEW32O2OMgaEoWoeVNv04wgA/LyldNoOWdTTTwzxFG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(5023799004)(10067099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1JLc2pSUTRtQVhvd2UrcmZQQkdxb0ZFTTNxNitLTzNSODRRRDV3NTZuaitn?=
 =?utf-8?B?WVJuSmRYaU9TRFFwbHVha01mR2U1S2hLVm1EMHFkMi94MjNWMDdaVmF5d0NR?=
 =?utf-8?B?TGU1RkxJejU5TFRLMW9GUllHbDNhTTZhOUtkc2tUQlhDT3FkbWY0QWNqa1Vn?=
 =?utf-8?B?VFFCM0EwZ3FkNFFWSWhyOWRQU1pFQWVBQzdyL2xINHNDelFYS2t1cFQ4c2ln?=
 =?utf-8?B?UjMvNGxidXVPVHkxeWQweFYzTHFUK082bDZCVzNUeUNVWXdMZ1FobFFRTmtY?=
 =?utf-8?B?ZWJMclRkdnNJMkhOWEIzUFYyRVdJUHEzRHo0TmhPQVJpa0hqM3Uvc2kvbFU4?=
 =?utf-8?B?R0Q0cWdtNFAzUzF6TC94Z3NwTkxvWmx2UVM5TS9nWGJTSVRHaS9mQmUxdm5B?=
 =?utf-8?B?RHFJclV5YmtNOUw3ZWlWV2x2Q2hvalkyQTluOFhIVWdkaGRaMlRvcjdkUXlU?=
 =?utf-8?B?azFTd3BLRjRFQXpVUG9ubWV4cmFReXFEL29oSVRXSjVpOXIxWEhZMzd0RVdR?=
 =?utf-8?B?dlVTM2JCS0xZRi9uSFA3d3Y4bU4rUDMxWjdxSjZxcTJrWFVIVmVzUGY3KzY4?=
 =?utf-8?B?a2w4ODc5a3c5T2g0WU5NOWdIS2pKdkJBNGxmYkJuZS9YUzJIVGJaRlM4S2dR?=
 =?utf-8?B?cS9BTitINTZVU253WE9ubHFiU0kxcnVsZkN6dXRZL09QWGppcG5Md3JGNjRq?=
 =?utf-8?B?d0h6ZDZobVdmSEkxTHdMbkkxU3FMNjNrVE5uWEFPWlBvZ2t5eStMVlNCUXVi?=
 =?utf-8?B?aE9jQjlZdzJUSjk1WWJCZndtSzByOHhqb2dNS29QbSt1Q1VTMFU0ZWhoZ1dK?=
 =?utf-8?B?eXFwdXhoTTJEc2JIanhzY2ZJR2l1bFVETzFzaUdQWXF1ZjVEMEEwTFFSbnpC?=
 =?utf-8?B?aWhoYmIxb2JNaEI2aDVkMFozWm82bU9zd01vSHpoYStsZEZDQ1NVUm1YVzNw?=
 =?utf-8?B?YlJjdW1abFRiZGhBclM5V1BIaUtCZWIvSHdKVnNYWHppbWdMMkxWNG5MUURX?=
 =?utf-8?B?WmljTHArQzVrdVl6SW9HVG83QVVtenRVOXM3V09naWF5T3A5RnI4eEZnMFd2?=
 =?utf-8?B?TWdVUmFTakdzZ1NLdStJMmVXS1F2RUQ1ZGtnU0hoZ3g2ZUtqbytaaGRhZnBZ?=
 =?utf-8?B?N29ybDU5MUE3TFZESnlwQmxJQk5OQXp2SkxUNjhqNTVhSWdIYWR5bERQVFZo?=
 =?utf-8?B?VFBMZ044dnJlMHg5WTVKZkEzclRHQVM4NnFGRUdOcHdCZDFGd3hwenR3Zzhu?=
 =?utf-8?B?bEpCcUREUTJCRGtBZ04rUEFvZ0tHR1hnMzFUaUxVVFRCL1RKUjFjL3k2WUo2?=
 =?utf-8?B?QmhiTnZnbTk5NGJhZzltbjY0RmZLeW0xZENDcXk5TFpSNm5haGtjMVJqRmJv?=
 =?utf-8?B?M2tIVTBmbUpqcmNrazdKTWFnZmVUcW1zLzhxZ0RkbFB0cjFxNVRJdUtSZ1VC?=
 =?utf-8?B?OEMrMnBCbVBwd2xxem93UWowT0owYUgrZ2hFdk5meHRHR2RLVFNaS2VnNndl?=
 =?utf-8?B?QWVhaWQ5KzlnOFdwUURLUEp6OTA1bFM4RUtlZUNVcEp6NG5pM0JHQmlZRDlB?=
 =?utf-8?B?anprZUFqT1hmQUdvcFdGTDVKQ3FkbnhlcGQwUEVnOHVGaGRoSGlOcXhWeW11?=
 =?utf-8?B?ZmtUYVVmbHViNGtENjNWS2FkcVFyNlp1OS9YWDhtQkcwZEpXM240bVZwb2M0?=
 =?utf-8?B?R3BFVGRmZkVTbW5rdTdUUm8rVDBIY3RHM1dZQlBwa0ZVcUd6dy9wbEhIY20v?=
 =?utf-8?B?Rzh0TVprWDYzcnlNRGg5MTk4UjdKT01FZlU1MHl1c01Fa1ozbFVxWkd2QzI5?=
 =?utf-8?B?ZmI3bnhoT3luRUg3SkdIV280alBrYjJFdDQrajN2aTltR3NVM1V0dkFzRWdI?=
 =?utf-8?B?M2FpdU1CQnlkdkhzT0tMelo4WCsyaHpqNzFCS25GU054KzFUVXFFMU5ZN08v?=
 =?utf-8?B?R0VoMGpxNjZCUituQWc4b2t2NS9tMFhkZ05qVHA4elZCb0RLeTNQVnJJcVhz?=
 =?utf-8?B?NzJ6cnFGUitaN2pvWE8yenE4QzE0VmRWbjZKR0t2ck5SK3BoZUF0clpPNFJI?=
 =?utf-8?B?Y0tuYS9ZVmhUYlFQdURTSlVTd0xsMVVmdU55aWNEdXluRXI5bEhFc1Q2ZVd4?=
 =?utf-8?B?b2JUMGhvMHg1KzF0bEhlKzlpTW85VlU2Vm9ENCtYd3JIOGdCMncweFA3cVFm?=
 =?utf-8?B?M1N1U2QvbWRpNEQ4QVRPUm5VVzVFVFBxYTBxckdGMXJab2poT3grOHdGN2RD?=
 =?utf-8?B?aDhJeXZXazNVT3orNnc3RHRTQ21LODN2MWduNnVOTnpQWHZjaGpWMnZwOVk0?=
 =?utf-8?B?N2E3YVVwUE5kQzZlUENBS09Va004eXVoT1FGcVQ4aE16RDRydWhQSndDV1Qr?=
 =?utf-8?Q?MsCRaMwEVjlzNgHvlL6WBcCIfirjgnEK36Yuc?=
X-Exchange-RoutingPolicyChecked:
	HXKGPhzaW/K5XaSPGcSTr7BjQOjUa7gKDLbB/DziVE0rF+QumAE5rbbpfN25Idp/xnl1z1B69OGY0LMGnFWXHb1CMYQ84F5wID0AxEtmBR4oUNUSef77hXmmdzCsNoe1NSm5KmKFt2S3UIlkCLdMw0C4NmJnqM71r52K7a6CvTQWF6Go1RQXOeXI13WSqX9Tux700lKJEaZpZLr2OovAJ8yJcu9x2/PLpj996A644M5bwXcyC+eTn+PX1uOnIJfLaG1urufYRgrUjsCw4pN0eShjd4DkHzjj517MvX4XA2fgINIi8crTUUw4sHRXOzL/BXNNw+P961ZwdH1aKrfMzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H1+OUsZLBVfQRTUQARJ6I4+uVImDQjeYwPqrJTQWUkp059wmcAvqcgllbi92RsUyDBZ/xg7yKTjon7vtGu3uI4yGamkDL2wRiyhQekRqWKRXl7dW5IVVNbTkFXpf0lYpRc5HbymddLT/uBZwPlpYJKcV1NUHjHomIDz4YpwHXb6Z9aDsTxmdT1Bcs/D6Qw20aGuYbi/EECQlCxHgNnPe0mMN1QCWauuGlw3EGMKZufVuuHymimtZ8HiLXcg8DbtCXwmhQFWFGBfnfQ9cxLnvyCTqeVWJnsjsWwjifbDbeTJo9vQvvMINqpQ1XAOREyN8UZLbZobO1ZJ89kt5oLA+b1H3oJEY7FFOkz+Dkpib968uGnv/IaXA4oyuTVD70hsu4dLPRyg7nlw1jb7wA+TTkDSHk+wlGXJn28+CzFoZQuEfufMoI2Y++fmwXbBn27z4ZfgqLYU4QY/9RfeDIN/JAF9OISLqhjD70tcaB0VBhWSfPL5GjGIrJmGW737uV2FNQpX3bb8F3QeY5C0LHVL6Drx1ysoSUC0fEbigY6MTosAbxWB8jsEq0ldYGESzi3OfjI0DJtuYH4m9kSkZN/KFysrrvpn2v8XdPwX5TJ/1W/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819fe1b2-86fe-4836-61db-08df1ff666b8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 19:58:45.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frK3xSsfC7YTkYN/sqiBcyNidHxDJRUC3sAgoX89+nllXBPqJkflbYoWmTW+tGul8Wd6hR6DYoviWMo13j1JdKV7CxYz2JHQVbPobWs2tDABYcm394qTTYzfPcxKywSu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610010079
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA3OSBTYWx0ZWRfX4EDQ+6FgO8bV
 QrwXXlWZiKxBvshc8/NjLM+Xmd5qX18uMaApFInerT0F2hh1/HgxJZRUPi3zTYRS4QJfwHm7Rmq
 liQbjZ0scx6UDTOVoGPpAz3VXxu0PlzcIsaZWTlSOc+gsiqUstZ2
X-Authority-Analysis: v=2.4 cv=W9itxhWk c=1 sm=1 tr=0 ts=6abebb7b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=bC-a23v3AAAA:8
 a=968KyxNXAAAA:8 a=VwQbUJbxAAAA:8 a=pAki7EUCH4AlyACQweQA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-GUID: eD8_FA62nPSSA755HcgkYj8D10gZmvsr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA3OSBTYWx0ZWRfX6yjMgCHVetpc
 cV1AYfKUefVgO/u9pf9MgP3U/TGN70uh2mZKAqTpD70IFHtzoueDVhUeUdOre59wEaYmIcQzuTy
 a7CJhhE987lpovVKP5MMDddrX7f+oYWUQIE2XAuta+yuI10Jfi7rs16uFG46ed8WO7zGABSvPCK
 3lpOHfoUciUjgCEfYy0POt2hEuKtfASNXULHkKRtkOclpm48k+4do2q/ulWWV6p02DhBJXkBDUD
 Ge7wAEYIzAbx1S0nOM2+zMmu1mU76qoIUEX8SUHX44y6cN0heknvhiQ5l8H1b0M5F5z5RoXVaAG
 nIGzdi+OIBexiNAuSmZD1oxkzjIe4DE1oAMuhbprG0Rm4VmCSKECTKoPVWav8V7u7nQC0lXHqLx
 vV91DJuGE0x+XRdsA5zX11x6b1f259RZ9qIOB1Xudb4NC3lI6adh/6/o9K6k8A5adBmRQA5xl6H
 WJUXkx1x/K6Qobp4PcH3suXyRzdHT9CjlKPTRzaQ=
X-Proofpoint-ORIG-GUID: eD8_FA62nPSSA755HcgkYj8D10gZmvsr



On 30/09/26 8:50 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Julian Sun <sunjunchao@bytedance.com>
> 
> [ Upstream commit 7459c021874246c196f397686e100702f059b9e7 ]
> 
> We observed hung tasks when users attempted to unmount a filesystem
> after its disk had been removed while still in use. During device
> removal, fs_bdev_mark_dead() calls evict_inodes() while holding s_umount.
> 
> Each time evict_inodes() drops s_inode_list_lock to reschedule, it
> restarts the walk from the head of s_inodes. With many referenced inodes
> at the head of the list, these restarts repeatedly scan the same inodes
> without reclaiming them. This can keep s_umount held for a long time,
> blocking concurrent umount attempts and triggering hung-task reports.
> 
> Keep the current inode, already marked I_FREEING, out of the disposal
> batch until s_inode_list_lock is reacquired. Resume the walk from this
> inode and dispose of it in a later batch or at the end of the walk.
> 
> The zero-refcount and state checks under i_lock allow this walker to
> claim the inode by setting I_FREEING and removing it from the LRU.
> Other reclaimers skip the inode, leaving this walker responsible for
> eviction. Only evict() removes it from s_inodes, so keeping it out of
> the disposal batch ensures that it remains on the list while the lock
> is dropped. After reacquiring the lock, reading its current next pointer
> accounts for concurrent removal of following inodes.
> 
> The existing inode lifetime rules prohibit acquiring a reference to an
> inode marked I_FREEING or I_WILL_FREE. __iget() requires its caller to
> hold i_lock and establish that taking a reference is valid. Inode lookup
> and igrab() check these flags under i_lock when acquiring a reference
> from zero. ihold() requires an existing reference, which would keep
> i_count nonzero and prevent this walker from claiming the inode. These
> rules already allow iput_final() and the inode shrinker to release
> i_lock after setting I_FREEING and before eviction completes.
> 
> A temporary __iget() reference would also keep the inode on the list,
> but its release must preserve last-reference handling. Another user can
> acquire a reference, update lazy timestamps and drop its reference while
> the pin is held. If the pin becomes the last reference, dropping it with
> atomic_dec_and_test() and evicting directly bypasses iput()'s lazytime
> handling and can lose those timestamp updates.
> 
> Releasing the pin with iput() preserves that handling, but does not
> guarantee eviction. fs_bdev_mark_dead() runs with SB_ACTIVE set, so iput()
> may retain the inode in cache, whereas evict_inodes() must evict eligible
> zero-reference inodes. The inode may also have been freed when iput()
> returns, so the walker cannot then use it to force eviction. Using
> I_FREEING preserves the existing eviction behavior without introducing
> an additional last-reference transition.
> 
> The xfstests auto group passed on ext4 and XFS with known unrelated
> failures excluded. No new issues were observed, and the previously
> reproducible hung task no longer occurs with this patch.
> 
> Fixes: ac05fbb40062 ("inode: don't softlockup when evicting inodes")
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> Link: https://patch.msgid.link/20260915044912.3183440-1-sunjunchao@bytedance.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg/Sasha,

An AI assisted backport review flagged this, and I checked the upstream
code against the 6.12.y tip f4ffa8dc360b.

Upstream 7459c0218742 uses the current inode's successor after
relocking:

     struct inode *inode;
     LIST_HEAD(dispose);

     spin_lock(&sb->s_inode_list_lock);
     list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
         /* ... intervening source omitted ... */
         if (need_resched()) {
             spin_unlock(&sb->s_inode_list_lock);
             cond_resched();
             dispose_list(&dispose);
             spin_lock(&sb->s_inode_list_lock);
         }
         list_add(&inode->i_lru, &dispose);

6.12.y retains the cached-successor iterator:

     struct inode *inode, *next;
     LIST_HEAD(dispose);

     spin_lock(&sb->s_inode_list_lock);
     list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
         /* ... intervening source omitted ... */
         if (need_resched()) {
             spin_unlock(&sb->s_inode_list_lock);
             cond_resched();
             dispose_list(&dispose);
             spin_lock(&sb->s_inode_list_lock);
         }
         list_add(&inode->i_lru, &dispose);

I_FREEING protects inode, but the safe iterator's cached next can be
detached or freed while the lock is dropped.  The 6.12's 
invalidate_inodes() differs from upstream's disk-removal trigger.

I think 6.12.y needs the two-line iterator change from
3bc4e4410830d556b0f40dfa6671bfcaeacc1599 ("vfs: Remove unnecessary
list_for_each_entry_safe() from evict_inodes()") before this backport,
thoughts?

thanks,
Harshit


> ---
>   fs/inode.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 8dabb224f941c..8592fd1a18526 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -790,7 +790,6 @@ void evict_inodes(struct super_block *sb)
>   	struct inode *inode, *next;
>   	LIST_HEAD(dispose);
>   
> -again:
>   	spin_lock(&sb->s_inode_list_lock);
>   	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
>   		if (atomic_read(&inode->i_count))
> @@ -809,19 +808,19 @@ void evict_inodes(struct super_block *sb)
>   		inode->i_state |= I_FREEING;
>   		inode_lru_list_del(inode);
>   		spin_unlock(&inode->i_lock);
> -		list_add(&inode->i_lru, &dispose);
>   
>   		/*
> -		 * We can have a ton of inodes to evict at unmount time given
> -		 * enough memory, check to see if we need to go to sleep for a
> -		 * bit so we don't livelock.
> +		 * Keep this inode out of dispose so it stays on s_inodes while
> +		 * the list lock is dropped. I_FREEING prevents new references
> +		 * and leaves eviction to us, so we can resume the walk from it.
>   		 */
>   		if (need_resched()) {
>   			spin_unlock(&sb->s_inode_list_lock);
>   			cond_resched();
>   			dispose_list(&dispose);
> -			goto again;
> +			spin_lock(&sb->s_inode_list_lock);
>   		}
> +		list_add(&inode->i_lru, &dispose);
>   	}
>   	spin_unlock(&sb->s_inode_list_lock);
>   

