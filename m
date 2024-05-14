Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9D517F37F
	for <patches@lists.linux.dev>; Tue, 14 May 2024 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715704202; cv=fail; b=U+uLzfQNkdMjWu9nTnn2dF+uD3t45H+VzcHElvUYm6PmPyOC3laQHccxHUD1mD7EZrziMIiduNUbKMlPaHRfNz0JGQJGBGymoJXRe92PK9bdVg0k+wU5KqEeiByRdplFqTJTYiXc0paJgXNff3sKs3kJ2aAEx98XrU391Bam0HY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715704202; c=relaxed/simple;
	bh=+T0vlpye/gZqLnjosZ7nl+89t1zVTK5Q4Z4AAf+V+T8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fyC44Z9LBBBd9oHLW1MFi9TqOU4TDq9dK41Q3LpVmBCSrtLR0Lt3DmdM8Yb0K6GZ6/6HZUYhTkHIzj1TU3va35abiiShycdFt82a5MBwBPzlNbIhM6hyrPE6gxTgC+yRwB7pb0M1/oUEFTfQoMH0Ff/cLG16U79CyMz5UOF+pc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EDLebmVz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MtG7VKOv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EDLebmVz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MtG7VKOv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44ECg8n5008652;
	Tue, 14 May 2024 16:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=DCcF9LGrtR/KAEBs4Yvlln+O1fs7+1kcI+AhGEDCBmA=;
 b=EDLebmVzsfkHb9ogpBWpNyDb6bWjATZn9rssGbTizg46OrTMpeDpIkGR9y3AOTwkfYcR
 ZwGFX3a+zJu5ySZYHqwPjLsfH6r9+tnoQ15/tf85bJFCIJky3PpPw/4Qm9uucJDKTAOS
 XbZFnLgYD15vTRx8WROikA62exIE0YzXew06caeo8GdykIGA+yMaBshZ0BDYMriA2tQf
 rT9WIPkicQ0EFm+NYtaoFpBPwXZAWdop1QcbpBsgAI/lDrwnzNLEGhCTy+Wz9FqdmCUl
 J21JKS3HcYc35+xnI2NzRoxPk+49hPOkPAi4rL0po/5yAR+pCTj1F1gdjVJ/7LCjAxig 4Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3tx8hrhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 16:29:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44EFovB5038472;
	Tue, 14 May 2024 16:29:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y24pwad30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 16:29:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKgSBaxyvDOqTk8EJV7LM+FlooOcvzSTvJFiHov3M0XTFZRC8s4+Ewkqumnsy6ECS7B/3p+qHwnB6wrUkC9aOQmmuHpf1LQQDMCXaj8OaXSbUwg9QQIBiA9+zv5YCC6DhpOhvqEQ81oSJOwNtZBJT6gAdSaiyFQCHCVaSnm6Ez/SNdsmHQ/iMfvbraEEkd5OrHpyuGb91BbUCbwg0tgpOH1C2KhrJV5KYN9AIugXHRYJ5GHAoIxfD/FLrOwI2M9CANIa5rRvbDHUxpfXThCv90cEppumyvx7zggCYunRM6WkP8CVcSbVFv1WAcdCrgNc+du2W/MZWzgPxs/ejoFu3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCcF9LGrtR/KAEBs4Yvlln+O1fs7+1kcI+AhGEDCBmA=;
 b=ar1fHCLIWBElM9H640ofV/bUUa0R0SXOc+aL2y/cIZAx8RxohXMwgp0hVuBHvi8xsPlcM543PSH0cR6xpMCmpEn8Ve10ifJUDZn052yWFAsKN+3KqzxiIWjlCyqes32cQ1ehIS4WTnZLvG9NoYGEZFGMx+6Pd/oG3i3lqbYMcNl2kBJnzlBjcQlPLquOPIW5ZCkmzBWI+uuHQUceC+aOe3tkE04nRvUe5Rzmhvx4kp+2wnpsnBMl9aNht6wuHDmVjpI0U8ZKwZooHsW6CULkkOkKJ367YHV2OOAwE1RuN2+b8EWPfOlTa3xzIMZCUl+35hYL7zJ5ytkzX3de9tSv3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCcF9LGrtR/KAEBs4Yvlln+O1fs7+1kcI+AhGEDCBmA=;
 b=MtG7VKOvnR1j2j5mVKtF0QcuzuqvygQfYUd8LUaGSP3BkFqkiTK7lOwd2T8JbANtzGj7CvEWHr3z5aDq1+NbuZMle6hRrlGCQ6ce0bkkNfI2x5IsIbGw5bTT5eUYNBtWL6wQcUuwSq9hRFNXEdsd+d9sgyaGQLZmW6ebsFBuwXY=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CO1PR10MB4594.namprd10.prod.outlook.com (2603:10b6:303:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 16:29:44 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 16:29:44 +0000
Message-ID: <a71fe70b-5a16-4c8a-b6c6-00a7fd72c7e3@oracle.com>
Date: Tue, 14 May 2024 21:59:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/84] 5.4.276-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20240514100951.686412426@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0062.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::26) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CO1PR10MB4594:EE_
X-MS-Office365-Filtering-Correlation-Id: c695c18b-b53d-4df7-5e26-08dc74330ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?T2x3NmNEVmdWcWRKRDdmakdrUTNpVnlJZlNCL1VleStLczN4bEhIbUwvL3F0?=
 =?utf-8?B?VGx2RGVPSXduNzJHbTFFRm1lZHVWUXU4SHNYL3RJWjF2S1owSmt4QitKcENi?=
 =?utf-8?B?Mk4xZWxSOUg2S1RhTSsvUnQ1NTg2MGJkL01WZzc5bE1SM1c5L3NiQ3JNTGpm?=
 =?utf-8?B?VEdVS29vMVlkaEQvdUZNR094OTF1eGFJc1dIV1Ard01hMTlMVDFlK3dUeVky?=
 =?utf-8?B?eHI3eElVS3BrczFEVCtQcVN1QnBLemdFZTFxeGQ1RFovM0MybmViZzUwa1JO?=
 =?utf-8?B?RHl6SUJ5dzhSUVJjaXlVRVFwUTdoRzJzN0VHalhKZXIrMVFCcy9HcnNOWm11?=
 =?utf-8?B?c1FYRnk0UC9FMkdtWmx0bjdsYWlybnh1OGFXUlNHTWFwZUFRK1BBSkpNWXNI?=
 =?utf-8?B?TXhUR2RkU216SEhNTDlHVnBEbjZKM3UwTklmVWE1Q0hIcjUxaGRQbi9ZOVht?=
 =?utf-8?B?NmoxcFNuRG8yRmlsSUlpcS9ZeDJ1UjU0NkoxYndLQXZSVmREK0UrblFzQUpi?=
 =?utf-8?B?N2hkT1pkZHgyeFdoWHBzM1FERENaRmtJU0xIb0tKNnZDYnc1ck1kUTFCWlU0?=
 =?utf-8?B?QXZhbjRKS1diSmNyd21FMTZKN1VsVWZtQ2kwNXk0QlJwUmY3bGcyL2tpYUZ6?=
 =?utf-8?B?R0RDNlo4bGxtWTBDRkZ0eDJkODdRRDJtdW53UUVaaUN4R0cwczJiVFdFVnRV?=
 =?utf-8?B?UlJlajY0aTUyOUJpTy9haEk1L2dPNzRlblJzSEJPalVLNU4weElRR1pveCtr?=
 =?utf-8?B?YVZqQTc5ZFpYeXgxaHdyT1plQUVuTXh3blhWR0h2ZldOQk9md0lTVjhNb2l1?=
 =?utf-8?B?MnhJdWIrMmlRT0dQemc2UUVyalF0NU1RTWlCWWtZOXhMSVlENXJOSFZDY2NJ?=
 =?utf-8?B?MENMZFNzUkdQQ1YxQVNaVXd4aXhsVWZPODZzdkpwczdoSnJhdEcvRllIUE1V?=
 =?utf-8?B?OHpsYVhBNmQxK0xQWno5cDlyQ01zSFZRN2x2NXlDT3ZjUWc1Nk5wcE4rUTl2?=
 =?utf-8?B?MHlJMWpKd3hidGdYRE9HSm8weGFqL1JFU0QyallsakdXUmtNVUF3UWxwSTFY?=
 =?utf-8?B?a0xRZ1pVdEN1bVBSOVNoNTFQeWh1cXpLRVdmL0ZWdTQ5S2tsQ0xZNUZMenpZ?=
 =?utf-8?B?dkhyS3JJRi9Pc28wTjExZjBZaUdtcGM2YUFQWUVVWXBJSk9ybWVlSDYrNXFC?=
 =?utf-8?B?ZGdOUVkxenJIbVFPRnVoL2x5REQvd29raE1la3J4MkROUEtUbG5JYVNDa1hl?=
 =?utf-8?B?dTZ4aFhLTkdOVFFuSjNmNExEampsVy9pZWZjNFJIQ3orcUMxTGIvY1JFMmlr?=
 =?utf-8?B?akxQTmpPNWFReUcyZWVYZkxqbi9tV0pVRnlndzVlclEyR2pzbDAvNENJOUNy?=
 =?utf-8?B?bk9kcHBqcjRWRitkZmFJUXBwWmM1UitXaWxtVGdRMFFjTDFOb3FlUnVuYlNl?=
 =?utf-8?B?ZzJiVy9QOUxHd2RGekIxU21CSm5Zd1hmRmtwemx3Sm5UNzZvbkpKSjNIb2NI?=
 =?utf-8?B?b25pb1FFZ1k5NjV2a0JjN2FHbHQzYUZrUVpySkVqNmZOSEpIMzIzNkk3MDhD?=
 =?utf-8?B?eVE5L0pkWEwrdXczbEZIQlFVODdWNDQ5bm1yMi9wUW0yYk93TmNKaWxQemNm?=
 =?utf-8?Q?ljO3Sx3E3BQnXYp8k4u/Q6ZiyJDWo5kB/oPIaoXPurp8=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QjNESkRTaUZha0k4L2g0VDIxaUs4TGRVYlZQZHMyWkF2dkdqVTQwaGlDY1U5?=
 =?utf-8?B?dVcxN21PMkpTMDdtNk91Y082cmdkLzhGcldWSDJwWEJrSXJ3ZjRpOVgreVo0?=
 =?utf-8?B?NHJoWTBiZXdDUVk5a3lTVStsaGpmMDYwMkhrUkxVNlZqM2thT29yM1lCN0Y2?=
 =?utf-8?B?ZWxLQmszNGQ4Um85SVNVaitoWXRnZlg3eDN3V2ZkOUc4bUY4OUxDeXdvYzNw?=
 =?utf-8?B?N2hDUkdaZC8vcUhZNGE1TEgxTzlSWTRhbklVR1gwM3dWandqWTlzRlVwemd6?=
 =?utf-8?B?MUhPUUpmSmRqQ1Y1MDd1dlV0ekpmRXhzdVh2eU9FMDJUN01QTkRxS3BoaFZS?=
 =?utf-8?B?cGNSeVFPOUxGL1FkVXB6SmZaYjJtNUNWQytjTlVtbUd2b1p2TndqZklicFhC?=
 =?utf-8?B?VGNMNld1dUxVT1ZuTDZKeWowZ2dSbk9JbkxTdU5Zektpanh4ZWZwWlNGaUhk?=
 =?utf-8?B?TTM5UnNPSVZMaWZTSHF3ZWlxWFo0M0dtZkd6eEc3Q09Ia1BJQ0N1RkNPdzYv?=
 =?utf-8?B?ZDNRTnpkU1lia2puZEhENkpEQVdEZFpnMVFXbDdnY1IzSkYxYzFiR3lYbnJu?=
 =?utf-8?B?c2lDQTFHYndHSmRJZS9Sbkk3bHpIc3U0SjU0UGt1WDZaeTRCZjV1SUtPZkp5?=
 =?utf-8?B?VDRFek1pQUtialVNSDlEQ1dnUzhDUFpWdXNSV2lramVLckx6RlZObDJrNEh5?=
 =?utf-8?B?aUsvY1lacGZtT21KalB4M3c4cDR6VGlpWndiMm4zaGptK2gwVU9VY0pjR1NB?=
 =?utf-8?B?UWFkSng4aHJlYWtseVNyZzlUTTFiRTdRb2FZVjNLSzNKUVRGMzVBcmdPQlJS?=
 =?utf-8?B?cDFHNmJyQ2tEeWFNYlMyQmhGOFFNcERFcCs5MHBidWtGK3ZMNkRhYmtHdmJ4?=
 =?utf-8?B?VXRUck9QUlRQNncxbEtwNjg2Y2tsZGpBVFRFUnhzdStQNHl0N2czemU4ZzBT?=
 =?utf-8?B?QzMwNXZLRHlHQzVPb1BPVmRNZnR4RG5mVnRXZVFvZmNqM3VHNEFYc1VGTmFy?=
 =?utf-8?B?NEZHWjkycU03aVBVd2FoQzYzUUJLSFJZdldQVWRha1hxRmgzQnlLTWs2NWZU?=
 =?utf-8?B?RFRkcHpvaUhOeFRlV2tMa3gyYzgwVWFrMDdxMS9FMlJvdmV6SmIybTJNNTVI?=
 =?utf-8?B?TVFib3AxSVRFMGhaY3JMVWI4dnVrZ05NTWUxQTI2RHRrK2syU3d6ZHlJRGNj?=
 =?utf-8?B?VGZHUVhYVHNRMEpwbXRFbURZYVdmUmdmUW50LzJDaEFPZXo2dHNkVXpGb0Fz?=
 =?utf-8?B?NEdJVVRXSjAvSi8yUWtUa2lrYkJpaWdXbkNMLzdNcWdiYURIMFVwNytHRTdt?=
 =?utf-8?B?Mm5JUXlOMVhQUHd5NCtRL0IrOXdETW9ZNXZNRHFkb0tGSk1SSkNKaGpSMlc0?=
 =?utf-8?B?VjlKdTJNOHRPdVVjUXZiQWgzeHkrM2pkbXhYWkNYMUcvelh1WFpIS04yUVZB?=
 =?utf-8?B?dW9Vci9SbmN0Qy95YzVKZDJoNXdjaUFsZm9SWGlqdUpEUHVSY3RqY1d4eW1v?=
 =?utf-8?B?SFkwOE5QMHhxZ3JLQ2JRbGR4TnZPWEtVQ1VJYm1VbmlqUWpIRmxtOGIwQXhB?=
 =?utf-8?B?c052MW5XcTFSVHlMMTlCOVcwb3daUmtiQVJCY0hrM2d2U3dKbEN1bmpBT0E0?=
 =?utf-8?B?SXZZU1pGZ2pYVUYzcDlwM2JFN3pIRlVIS2U1Wm11YTkwNlM2RG5DUWkvN1Vr?=
 =?utf-8?B?NmRJNXc2VXlNRXgyUnNSbnJCTjVxTEZhWkI0Ykd4enpQL0pGcVd1dnRHWUhI?=
 =?utf-8?B?Z2pXZC9QQzdFSWIyZ1Nybm9McS9FQlkyaWkrK1Vzb2JzNWF2WGFtSGNzVElj?=
 =?utf-8?B?ZWVLMC94dTJCR1pMcmFPU3dFb3BYeE5YL2ZlTHN0Z2hkZWpSRUdLT3Z0OE1M?=
 =?utf-8?B?WU1PcXUzRGdycjRuVDd4UVFlZ3dnbFVKUVBwQmNzWEMxMnp0ZEpRTUNBNlFW?=
 =?utf-8?B?K1FseVFsU3JzdXZGUVpCSEg1MGZ2Vmx6c01ydlJZVWpEenA0SXNxMzF1OUJC?=
 =?utf-8?B?dzczSUYvcDErOStJeVNIekE1WEEyZnF4THZBWTNBODAvZ0JYYXhFMDZYZFNO?=
 =?utf-8?B?RjB5di9TZnkxakxaNEN1Q3dQUUFjZm1zSVV2ZnZWeVNTOFBSRnRGSnZZNGk1?=
 =?utf-8?B?UDNvZkxsQkx2WG1WS28valY5NE4rWjg2aDFCZWNpNmwzUGRlQnJOMzFmc0Vk?=
 =?utf-8?Q?u+yyTQp+NrBX3e45gD6XBxw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XKnYpAghJcQIK5SNeHaFWzD756t6I8WUwFoi+YA5+VsUZSb959CYHF+r5Ok51K4Re3+N26K3k4PZfmp9RN69RxrQirzw2yvS355sYzJfkPkmrP9PaZ2AurbqrGRtH8JQN/AgDabHOlNtM3oU5/n62/cNagwv169NmOsQshPiIiWq/dkZwaBcmsucU5DFnuP/P99s00zbSn5vjckLt4Pv61hOScjgmNM2kXMqFH73yKb/YDelxe8IfiAIELiMkkF5Tnlvvki1XjibwSa8cXTiC2GsYZWH5n95BxE1Kd8wy6wYLf24Qm0p4YqspFW+MrDy2LdvXc/tGeF2hkv1sWcNHonePbY09V54RGUja8RcrfAtFOSitp/M9zEKAmSWcmLKLsxvhtdOqFKJtjFXsMzF0609umj840IY+XyGPGCsxgw7DUgAmHrUzlFosBM+cqQHxyiGgLc8ryEzoXYgFkDddLFHPfgDZNm5eQsrXMQAb7JSOvxQ+51oyk18L6ui8L/gMspOu+iS8BQZcBKbJUfP9/aU8OTdA6b9Pn9L1mMUdo/KWnXp9Tz5EN5qEStYbsqymJjCFjISAYvfIBbFI1twnWGW6nIQZXjmO1IznRQ+ZJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c695c18b-b53d-4df7-5e26-08dc74330ff0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 16:29:44.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FFAPMU9YBKq8IerB9D3gk+DEKjKNhBNTfo4ldPEgTGsx1jQRFXhAuGOXBX18NxKcFY7pQDR8NMFPLNCaY+evDVnaV8Y5npuA10dwBZa65euf0mgQ9Ce8WX1hpD6u3mIF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_09,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405140115
X-Proofpoint-GUID: 1or0sSZl5Sc84DkkzKDllNZFmEQn6PW4
X-Proofpoint-ORIG-GUID: 1or0sSZl5Sc84DkkzKDllNZFmEQn6PW4

Hi Greg,

On 14/05/24 15:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.276 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

