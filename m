Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C937160
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 08:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735029784; cv=fail; b=ps4t0kceA9ut0MPbtPF9dIgOvJbGgxt0Ja6eArXdLoM/bydKzMs0RTRnHzu+NKsGYUN5rnJ5hxlo1kFvaajEuz264e4bP8AsDE23mG9Yp3hOyiv5aP7pNxNjbw9Qsn3sr0doUG7HIZ+lhfQjdPJ9v9Lfz9LUhnMa4h3lvA5BbQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735029784; c=relaxed/simple;
	bh=0/b8J7/nd3/A1ag/Vm3R6Wz1H1vfc8EFqFM91yCxYNo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XqUHTTGp+WgZ1vbUZg+Wr0+x8OLicWqTTznwD/8qVsrcA61D8C1MBf7PKPocyuJZkmEOYTH3lrhUkCSLj5/Q0P037p4C5eYGmVoALcZc9W8lKwZLVqlMPE2Psj8jcwZzIGpUxCbPnuGWs6Motw09NVon8+cFiGVSHnTw3UEzIQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ddqs2/LK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N8xfgNvX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ddqs2/LK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N8xfgNvX"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BO1vKCW017940;
	Tue, 24 Dec 2024 08:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=83v8kUreE6Mnxdl74vC7fvqbAbYnctLWE9Gf08skOmI=; b=
	Ddqs2/LKDjk8Lk8qkorJVRWaEf2dcc2sqrTHOazf1oLYrqwD4tKOnVQVwic6y4Ay
	A3m0SPe3HLDr+rN7Pw02GIZrKLS5pUjJ60ICQW3hKppQLanGCDHELgiYqobGqBZd
	5aIT46OJ3e3A/WGdIM7kXlZyso9P1ihRpEaRi+PZz0ZjfZ8T6cRO/dNsevZ10+rH
	Ryzf8aPya+ld1MaD/V4ww8QYMvOXZFISJVcvfsbF3ajOwSFBY05G/zMnc1HiB0pn
	r4BL78UHjPM0LIpqiNHSAWIIPYonkI5+TnSltMIRE8TO03M7gGk4G1ytVsFXN+XF
	33XxNFJYrlLzkBoIvApwOw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43nq9ybx89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Dec 2024 08:42:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BO6EKxC001748;
	Tue, 24 Dec 2024 08:42:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43pk8tmyfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Dec 2024 08:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvbmvERovvPDFF8G43Zzk2be3k7ZOK0Tq8nDIoKqIEzbuEDuIIpTdxh2VmomndjkyWfsisLpgFhNpUbDlTjWQO3yVDkMjmR9cxRqJlYiyK0Fr6zIy7s5t6/topAX+DxPijf02zhz6jV9WeLyfEH6wUW9dkZUABmBD4w9xKbJpMFTwJcOCHo9rDv5R9PAtwOY2jU/spYKpHC0HpCKyPKqKK0buVQdLp6eLSm7bXygD/C5VxlDjE9ri3WI4FQwUTb4X7xhnWh/4QLf/HpnYzvtRV+WS/KfxQqAqhBEqfuDFh0ptaeqizhB5MSshTLdgSzN9sqzaOzTyHK4rc/zbhydqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83v8kUreE6Mnxdl74vC7fvqbAbYnctLWE9Gf08skOmI=;
 b=IG+jhMAUGdE6U3DTbM7sZm9l3qblAA6u4xYb0wKEqnH00HU+/ltXwvr9R74m1NbS8mK7fuZ70w9pJC8pm0bemTWoS2ivfVtEydPkykmUv6X4/lOaOCvg+DJGFJNjUP/hrOThyLC2MO1rpshIH/r92iW8tpteumoww8SDYX3MbPj6e9iXuUUVykaQ3aS3G6s1kDPtANeqwyJYAz9n8PIyvat4cbkWpw/XzHuB8j72dqMjy6kNkM40vJ9qcTNrNSf5LG7uWF2bF7KYBeWQmAgLSAsLcy3GNPmOKj5/aD+lZM9BzNvrPvYGhnX9wYbsfMxhQjE0A0OWNaGj+qgzyheKXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83v8kUreE6Mnxdl74vC7fvqbAbYnctLWE9Gf08skOmI=;
 b=N8xfgNvXTQ/KgRa9a/DIFbPhdCe2o17+BKfi6ZLmuAeKkKi61hsQGi2TuiYberspa0PpOFsasxFXfgXix15xXqsflxcFtu8PflxtCuYXktir4auSlep47dF/oqmA0tCFbTT+yqBerPGrK6uzH4RsfhYwG7+XJAtPNQnfIt+3Ius=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SN7PR10MB6617.namprd10.prod.outlook.com (2603:10b6:806:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Tue, 24 Dec
 2024 08:42:42 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8272.013; Tue, 24 Dec 2024
 08:42:41 +0000
Message-ID: <b885ffb5-cb11-47c6-8ac7-e0ead509e37f@oracle.com>
Date: Tue, 24 Dec 2024 14:12:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20241223155408.598780301@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SN7PR10MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ae4e27e-a002-4863-f60f-08dd23f6edcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWRGUXIyS2h5SDBweWg5aTBOVEt1S2R2Sm9uamZkQi9GeG82c3QwcEN4Undo?=
 =?utf-8?B?YmtNTGd6aGlUdHladFdIZDdMZGpMVEhTY1pGc0xkVXlqNWxNVGI2WnBiKzBK?=
 =?utf-8?B?VGpwOXBNTm41azlHMytqaVpPR2xBK3FUQzhmM3BEVHNJdnBuM1htUEpiUXBI?=
 =?utf-8?B?ajNYRjdRVWd1WXdrU2NZQWlCekpuSUhVZVpsUzZleVJFVUN0M25lSS9pSUFU?=
 =?utf-8?B?NnoweWZ5TTYwa0RnNVRTSEZqcnBrQnQ3L2NFRmN5YW8zNVFrMmp1RGs4eDdv?=
 =?utf-8?B?cXp3Tlp5dDRzbC84YitvaTlhSTdmaEZsRnVxMUFkVlFZREdXN2dQNHZWQjZC?=
 =?utf-8?B?d0V3MHFRUDlma0srRVAzVGhsbTV0L1F1eVluQkw4M0hOOHNoRWZ4UGM2SVBh?=
 =?utf-8?B?SnprMkJPTEhsYXd6T2JZRHUrUmRHWlNhNXVGNlllcS9XcmxVTVlibENxNGVW?=
 =?utf-8?B?Z0xwak8zSlVkYnYzSnJqYjYxVXZDUDd6NjlFSUNDM0QvUmN1YkxWbWFNeXBt?=
 =?utf-8?B?TmRVb25jaXQ4MHU4S0swdVlWaENTNDVrcUJIeDEvOTZ2UmtXL2NNa3JuY1pC?=
 =?utf-8?B?RVdSK3Npc1lacUZ5UjJIZSt0cGpFbFlOMDhOZDExTkJnUUwydCtqL0F2cW5q?=
 =?utf-8?B?NDJRYW9kQWdtaWh4YW5mMDJYSlNRanlJMXpmd3lZU1p6WGg0ak9aMmZycHdC?=
 =?utf-8?B?NEVQNldjdnBWdGd3RnJZb3JCcWV6b1c4VjJaazJyR253cG12VnE4WFcwQ1U5?=
 =?utf-8?B?NittTnBxUE1nSHd0cmlucGlVazdhaVkzdHpXbXJ2cjl5aE1qc0xwK1dWSEFY?=
 =?utf-8?B?Y096NWlHbC95ZVZ5b3ZjMTRURW1wUUZxK0dFZnRyVVFpeGJUa0lRZitTNmNj?=
 =?utf-8?B?Y3kzT2NVaWI5NU5xTnI5Ry8wZnVldTZCbVdsckNnekhRdE1mbitQRDdBZDJG?=
 =?utf-8?B?dHV0akdDWkxiVGJsTG9nZVd4SjVSb1I4YUZSeit6d0VLTjIvUmkvZHQ4ckFT?=
 =?utf-8?B?SVpZWklHQTVpS1d3eEc1U3pacW00L2tpNjlCLzZlbUJBRG5aRVRyaWF0OTF1?=
 =?utf-8?B?SlorRFdKSVZkTTRhTnh0bDdTK3kzNzBQb3FpdmJ5NDYwOGswVm1wZDBYUk5x?=
 =?utf-8?B?Q01NTGVyR2R3aW5OMmdjaGU1KzF1eDY3M2JpaU5tSmo1cHlhSVBrSFJtNGtB?=
 =?utf-8?B?WEFCaXBJVzFVYlRjSm4wRWNlMnMwQkYzcVlMRHY5b05ldXVhbVI5c0NORlNE?=
 =?utf-8?B?Sm9JN2EwNlFkQk5TMkVwc3pGYzRsZ05nblY2dWNVZVRmUzQvc1R4SEhYVW9M?=
 =?utf-8?B?RVVIbUdrMk5PVUFGWktZN04xQ1hkSmZZSlBjZW9RSzd3NENVUmtxNlpVS3J0?=
 =?utf-8?B?MVJYRDJBRHdUMzdjZzV1ZStDcTNqcUFUcGFDU2NnY0VCTXZ4WllNaVRGV0dO?=
 =?utf-8?B?UnFIQ3d0aHlrQkxPVytubTBBVitiT1pzaDFPb040Sjd4TElQckFyMllaUndY?=
 =?utf-8?B?NGcxOWVIMUJPejhoYnhic0JJa1grYkl2Y2RWMjJBRC9OYVlxVlowa3g1NU9M?=
 =?utf-8?B?T20rTHE3blZXcEtsekhPdHhrUjlOWExqVWQvY2VtL0RDMTl1Y1lNTmhWM25w?=
 =?utf-8?B?bjhVOElNRXNZNWNXaUt5dVdERlQ3MEQyejA4YnBLRXoxWDVrVktveG13WUYr?=
 =?utf-8?B?NURiSmZUM3VuTG9xWXR6WnpWMlpHQ2o0bWdBSmRRZ3duWDdMUXBpdGd1eUR5?=
 =?utf-8?B?c0dXanVkYUh6YzN6a1U4ZExUcnB4a3NUTjloWDYvbmRCTWc0WERKTDVJcFNs?=
 =?utf-8?B?MGZUdWVDcUR2S3F5dlpFRGxzRkJMVjJzdndIaWcwZmpRRUZtanl4T3JJYng4?=
 =?utf-8?Q?BPDpMWtxaX09b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rk5ZZjczaEtzK2lwVDBiVCtTRlNWUjJZNWlCL3M1OTF5c3FGTWRSYTNkRzk3?=
 =?utf-8?B?azlkcWVXQ0RUOFJaOXRuYmd4VXBxVmtkcTQyUjNzS2tCMFMzdW9PTkJySGha?=
 =?utf-8?B?ZE5EdUtuZTZEeXBwNEdqR3VJOUFVcHVkQWx4aXM4cWlYUGt3NGYyckdsSHFy?=
 =?utf-8?B?MThvcVlEUkQzckdaN2lveEg4c3dEU01WNzZ3VThLWFRrQmFuTXc2YUJ4aGYw?=
 =?utf-8?B?V3MzOENRcXM1aHhILzJnZitjYkZOeGd3QzlNM3VzbllzRGNIcis2bWJVSWh4?=
 =?utf-8?B?d2VEK3hMT3JOOWxseVZmbDR1eGhtenVFNEJwMEVZbmVRZ0daZjA0Q0lpVnZs?=
 =?utf-8?B?N3F1dlI1QnUyVTRYeER5aEJrRkwyV3dGK3YvaWYxa2ZuRGo5L2d3Q0dJMWtP?=
 =?utf-8?B?bmJhYkQ4WEZ4RFYrNjBpZlk0Nm1ia1NDekkrbWloNnd3UTVxS0ZiNUoxWExn?=
 =?utf-8?B?cGxibnE3QVF4UllyTjFlNk5ucldJTHE1UnNxRHFtWE9zcEovbU1sWEFFQm0w?=
 =?utf-8?B?Q3NMeDF2TENoQk9yeWNkZmhUR0RNUS9HZlpZaGZjd2E5YVJxbm5rZENWOU9q?=
 =?utf-8?B?ZG1PczdkUmRNWjZWU3QweDVYM3BCNmRnYktCRXhUenpHYWk0ekNxSStkNW0x?=
 =?utf-8?B?aUU2dnRiQnBIaFFRU3RRUWNQZFV3bkp2eDRTME4yckkxZXdmVERHU1ZOQVFU?=
 =?utf-8?B?aVhJQzJrc2lNcUw1dUdLVmFYTzdYVG5wQmh1c28wRnJFbndIQkR4eVRlNThE?=
 =?utf-8?B?QnhsRDFndm1EWU54TTZsQVZqNjR0L3dQMXpwUVI5ek81VFlJK29ib1VBVEtw?=
 =?utf-8?B?WldHcG1lRnZSclhEQjZwdU40SDkvakw0WnFtOGUzVW5pMEE4VGNJTWUydGlO?=
 =?utf-8?B?REMxYzNKYkprc0VvajlwWk9WZDhtUHZQT3hqdDhRQXhzSTc4c2ZQV3hOVjMr?=
 =?utf-8?B?ZDV3S28wQjhDTkQ3b2VSN0xoa0F0OFIwc00rUVlnNm9NamovVy82RkRMQVd0?=
 =?utf-8?B?T2pyZDdMb1JET1pQWnF5REViL2RSaU5kSW9PbkpDalBoTXRTVVhpV2hZSklS?=
 =?utf-8?B?WVNIQVQ2dUcwTTkybEJOdWhNeXl2d1MzOG84LzhEeG51YlgzKzA1TElWWXdk?=
 =?utf-8?B?SE0vL2xDQ1JERkdUbEhGZ3V5anY4ZmZwc09OeWNHanVHN1RNT1V3ZG0rZGpG?=
 =?utf-8?B?dHpEaDdyNVhCMy9YK1JsaTduWVB3WHErV0ltRldVVnBqSEkxRC9ka3lWUVAr?=
 =?utf-8?B?TXQyL0N5UWVwUFZQUWZjc20wY2p5ZkZkYWFocm1FUkIrNUpTMkNrQ0g1eEpZ?=
 =?utf-8?B?MGh5cUQ2MTMxU1Q3YlV4S2ZVREJjaS9aUnlxVi8yUUdnS296M2h0ODRQblhT?=
 =?utf-8?B?NzlJbG5Eai9nR3A4enJ1Y2plbXIrdFJORUpxVFQyRVZCTEV0Mnh6MmhxTU80?=
 =?utf-8?B?Rzc1eVlkeUFYZkl1Sm56V3JNUTVjWjcwUEIzZmxTdkRxdWZ4TG9QaGpocTJF?=
 =?utf-8?B?QzdJVmF2S1VUZGdjTlBMcGw5TkNEK3VCZldUbGY2dmk0WllMTFJrUG9mbzhn?=
 =?utf-8?B?VHhUMExZL0ZOZm1ncWJlcmtqNkVwU3hhNEtnNU5ZYU1FRzUwajNNLzdnR3Zi?=
 =?utf-8?B?TUtnOVNGbmpCSFZmMmdqZ1VQRmdDSFFkQ2ZNQ2Rac0JOQWpLL2tpRWtUbnNW?=
 =?utf-8?B?bERkMlE1Y2JLRGRsQjBkYk0xS3VxS1RqMHlNYWY4TTNhWk9QV2RGbUFhdnVx?=
 =?utf-8?B?OXBUQTJsMzZ6WXcwbUJoaFZsWktaKzJIa1F1ZEtNbmE4b3l6U3ZsQnRjTC9O?=
 =?utf-8?B?eGg4bVpLdHJKYmVoRlRoRlBnMmlUaFhyN2dXREM4WDB3NDhOcEdkdFdnL0kw?=
 =?utf-8?B?M3gwRmNZM2ZTSzk4TmtBYzZ5elNUOFhucUVDUDNwMVQ4ejBJSjBHOEtoNnpz?=
 =?utf-8?B?b1JCMUR0eXpSd0htVk5HZHV0UXJoeFBVUkFITE55WHJUbi91MDIrTWJCbjNP?=
 =?utf-8?B?dUczMy85VzVxeHZvU2hqRmNaMVNoM3lycW5YUjVxVzdDSjVPZ2JqZXBENHd3?=
 =?utf-8?B?Zzc2ZktOU1ZTdkc5dUNKN1p1Q1VKWndHUDVqTGpSUU9oODQ1THF3bU9kTER3?=
 =?utf-8?B?ZU1xOEpKcXZrc2tBL2pLak5URzl4MXYrM0ZZbC9jTGlvMDN4Y2FXWXpSbWpo?=
 =?utf-8?Q?uiHhvl2CXNzYZJMWDzQu0jM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B7rKQjlYNkxHbdBrQ6SsQ6GfRfMoGbKsP1iBKQg4SdgwycPlKMCcBRPOogkxrrzCt6yPyiwt92xBYI5RZ/k06Nr9ILbf+jBkCJMluzfmMgaTQS5ivimjCda23cKahTszecam5Wnz7vTpuXcmaJRPF2REwuR7Wu8SwhWhfc6o0mYt/4uVicDpaJwWyCIlAn8xvLuA+AwTwFPMgKDehcm/YczOPNRJE0G4BrxLbwaBQNKns7wEj8bjMHFRwRluxTJVCJfbfGKI/xAUK56pQQ8Ik5wzvwkfTyKCNQ/84fxhmGkGw1NOfaeURdwlNAb7I2lG9ZwpUC7e6CWwRAX11VyqC3pc8DdcNwhOz2TAjDo09shwDzKAx9RDYP6cODNtXhRrh88B9vp8pKtBbgRd8RASvGBoUwOXkzrI8C8revocjotTPVZ1NdiVz1UKN167qTz7W90bcoL45d4Jd7WGREASPJUOe7wIpg0i58Mxfr6WpVZz1lRlEFZziPGBUzkqzo0/JxjlPibkMKwl6ByrSeJXRik7Vj+vQW6VGULM40iglL2cSp6oB7KgNN2k55/1Uo31+2P8UEFjKrMn+BfsjGr3pC3dW0ewSHbw0gvkGyjIbSA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae4e27e-a002-4863-f60f-08dd23f6edcf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2024 08:42:41.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PeeW/SDaq22RkRIqbkWDF3+0lshOkV3iLD4640Vak9MwBFyUJOR6DZ3P+DiX4KITA1ANQ7twWHEf8aAqKUc7RUC7JnIFrWvZtCarUXKOJ46QBM0wUiDljwFNurcapTY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6617
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-24_03,2024-12-24_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412240072
X-Proofpoint-GUID: 2xXn8Q7X78frTEdNw-PNyYCoIp_KKd7-
X-Proofpoint-ORIG-GUID: 2xXn8Q7X78frTEdNw-PNyYCoIp_KKd7-

Hi Greg,

On 23/12/24 21:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
