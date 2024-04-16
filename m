Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A83F6F06D
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713253526; cv=fail; b=E+umT+wb0TRS1FmrydVDWoCWzNrpt3OI6rPzgDUNLFT4A8GrOUlvGUQJBZfhQbFmCQE0EUbeCkmeVkZhLLkNtHTQtoM65kczYaWstmUsrR0PkskUwJX5q58dwmBfTFTQS8sfs1ezmDLiXa02pTfP9itPXgP5e4m8d5axuvOiuP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713253526; c=relaxed/simple;
	bh=+9o9Q6NV7jibmI/mxcyoYZs8ju4At64bRAoTUUAlhO8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SRTaMdOANSPIzPkZm7eth4+syn44SI/TJ9uL1wFM1KRFIvjEOrmaA0iAEUjYeZs18xwhgAQuwx8x4GIE//Jwfkktocwk/dcS1AbLiqpclOnFvZQ3Ui4d+1WFGORt0fuLAcOepjazkoV6txxxaTS+FqcbDPZ5AKFgQPGp5rhYvR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OkRj81Sl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UmGRT7hc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OkRj81Sl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UmGRT7hc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43G5Fve0028446;
	Tue, 16 Apr 2024 07:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=C1Ihwr5lYdKbq+sI9FDOjqXzYqRGeD/vfK6uSLrjqT8=;
 b=OkRj81SlLuXQsYJZVwaeNK4jQFchCed8TBtUh6s6qZHWfihjz3yVL2mdklvnnsiIiHxB
 6hD3zXnahEWQDVMElsz8+BcigMvb50zgfJyd0/7+7WJdvxv9cmNDvixawUlUAmHE/3ur
 W+ZG9pneYvUOBrmm2yW0MVCuf404FeA3e2vfVtOCPqImxtpNv2La4BUNXjbJvM2E23of
 x3I3f6Q3C2iOSVUXSInFZArJumW92EHwfg2kSyjWEvm7jl3iNKQWJWIVfUDKR60A9WiX
 3GSpyXfc1Hrxfrfp3lY/Z6IhSdaSIKWtxZkP38l9R76a3nKxLErRzyWC8gkiN3vRaG/2 Yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgycmkke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 07:45:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43G7OWPw004961;
	Tue, 16 Apr 2024 07:45:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggd4dxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 07:45:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkcNwCBCnLi2npFp5L2AFqz8kMBvowJIabjZuWO1Qf8mZQgM8tWiTDLcMM7OCa8S3aX8DxVzeByZ33OFcbKY9eu7OAr3UJt5fORMzi2Q6V4o35rW9qlJljRIsJcvzuWToIKyMmBhTUTB2+4V98CnLHM866Pczk9CV6ktKlXeHGkL/+GaDo0f0MaYPojT/gFMpCvQSxBxrqN1O0eAUzyFJtuKIg0wfUxAYXTwrVeMCo306ctkdfQjl6iiv9xp1YpnPhq4Ep7AIa2ahzG6l8mQnMin1bvEg4KUoWarkLx+Bj/kRV6PMG18itrEZhfqaBX/jIzYWVIF+D9CXcJUsPmBNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1Ihwr5lYdKbq+sI9FDOjqXzYqRGeD/vfK6uSLrjqT8=;
 b=eijrQKPXLWsqlFwtGY6wMlJfaEevHDSBCjrEpIlPRYSmhyZ2Q5CFtEg/BRdOW1bpapdqA5FxQM/W4otNoD2pJBqJ9QNzTKNMLTdrDz110UlAuwuxSQ5IahLU9tqU3a44LwurXWyd2ww4IPzQeh0vspOoLMyWmYh5WJP24LGXi3G5sXxFzsJHXtFM8qTVdGIsSvo+l67XVrEscuHeLlye8zWXr17ciAMsqnmZ1tXytUokIM6+hrffVjBcgYAdHtxOR/CGJ7L2v0QLZ66SKTjQncuE5iRRiSgKDBkBh/8c9mujKnASR6QjeqnxQn8hF6MlZ5oFA3G6fifCKed+nlVaUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1Ihwr5lYdKbq+sI9FDOjqXzYqRGeD/vfK6uSLrjqT8=;
 b=UmGRT7hcXMj0Q2CtfT17+tYCGZC4sZ8GsXU/gNWkFmn0myhdHbX0JKV7fwMZAWsuWgxKO8GwGfeCfj8PN7qGEI0NoWY7C/hpLH7g9ziKgQH5xNyjlLT1SyfjmwAG/8LwCocwmo5sjI8Nmt7TKnfJ8LQaoTqjJtXfSMvSCuyenqM=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS0PR10MB6974.namprd10.prod.outlook.com (2603:10b6:8:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 07:44:59 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 07:44:58 +0000
Message-ID: <f06c712c-d08e-4dd2-8b39-ae7ea3fe9109@oracle.com>
Date: Tue, 16 Apr 2024 13:14:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/122] 6.6.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240415141953.365222063@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0133.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS0PR10MB6974:EE_
X-MS-Office365-Filtering-Correlation-Id: 64443445-f817-429f-0c7e-08dc5de91d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	00b8hPyRsazS2T5HMkFn4ZlXDvhS8UyNTNEgvtytQCd5Y8b+rIJVinGORXNL47SO68TV26M7Kq6h0YO9otnGC9HTlNsj4LBGLkfyCMFaJTPNBGliHV7j9dwMoO1PGUKX8kBH8DYtBw40Ou6wd2h2nTL757DOJbOkGld+fhVi3uj6prVgvnOhlhltqvyGtb9xm4R6yzW67WF49gcIKpx2A/oxyju6L1cCPlHTnkremxX9jq1a4glltvjx1O+UZ53WK20M9IDo+aapj928hBSaXDm7q+eJ8myk+KWeWBSrCFlPKpbTpuiG4uTE8mAJXGdKH5tIlxe7p9TUd1RX9jZWgMH7htfwnNnFm1iU/0euOM84CH8BZENNw53h0BqXFLC9CRgUZsSHYP0VNGMl9dSsrXXeDh0FLYEpFWf+smHYD5M1PwioN4+m+wJ5o5QmKZU4OZThshuUX2fer+66zebgMzM4yf3z/FvYomCNtozGwvEZVN7m2KMn3GzmiynjjmFG++CBnTX5g+AmkV28wKMqbzRejoO3frIVvb6aXiFS2NZ8pDLmSobwsLAbt3Rc9IdzCYOMHmcrb9OSiIUmTVZM7zhAo1lj7Y9bSwaw5vJPXZVLHEAJD+BF22hIbQdwgFfGwdxNXoye7BBEsNMQSdh8UxbCy3HQFwTbSCQCFGZJmzM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aXRDSW0yK0t6OGZMcXg2aVFBYkhXcG4yNSs1YmYzMFhpY3RWdDZzeHh1dUZF?=
 =?utf-8?B?ME1DN3FHZXViZ1JUZjc4NCtJdEx6bkJGQjVMQTNTQ1BrMXByZUx2VTNhcU5i?=
 =?utf-8?B?RU9FQzFOdmRqaWEwb0FFMmc0YU1jRjd0Qm1Mb1JJdWp6bGI5dlJ4TGVZeG54?=
 =?utf-8?B?TnJlYnF0UitSek4wd3p3N0dqVmM3dVhhNW44UENIWkNsNjVrd04vQ0tOdGF3?=
 =?utf-8?B?em1VUHEvUlhlSTBSTFRxUjEzUm52a0oxRjFnRkFFYmdZaTR5cXI4M3lld3Vi?=
 =?utf-8?B?NUsxZEk0NnFXaFkvSG1XWW1rUkFnUlZKeTB4K0h0Y2RCZXhHSnl6QmhlUFBw?=
 =?utf-8?B?a1JkWHFyMmYxWnJ6Z29aeDZiTVUxaTlvckJCUnlOanpxaEtCV0dHajhSbEg3?=
 =?utf-8?B?ODgvMXN4Qlo3K3FIeFEvOEo4dEZJUlo1N25sUzZuODVONWlCMEI0bE1VY20z?=
 =?utf-8?B?ZHBCVGsrS3BMY1VXeTY2aG8rbFBkS0IwNkNNL1RrdVNMN1pteVB6OWZoenZE?=
 =?utf-8?B?SGhYS0h3ZUtQdlk3UjdNSTM2dTNoU1U2Z2VQTlhiUFJYNVV2TUphUEhMcDNj?=
 =?utf-8?B?R244dGp0eFNBTTFDKzU1L2JseUVKOW9oaFlpN2FOemVpL3FPenBoL2VSbktZ?=
 =?utf-8?B?elh0Sk1UQ1dtOC9iVnAxNkVOZTgxd25oZkZ0M2tuOUdkempFc1Y3MHVUN094?=
 =?utf-8?B?eUIvMUZxODZ6WGFNblF3R2p5VDRaaHEvREVjUXZKcjNjVGFxemhJMHhjRE5p?=
 =?utf-8?B?UDVZMTd0UzA5ZnlFTFNrM3kxa2gxQUJ4T1ZtUS82dWs1YWhCQUp0ZWM3eVFM?=
 =?utf-8?B?RllJL0JyT294OG1uWmFzYkwwam1ucXlpSGhPZTA2NnBoWTFrQTRmRHo0bExN?=
 =?utf-8?B?U0F4c1NOU3lYS1R5SS9Ra09INFJob3NUN3hxQ0lCY1ZjOThHdVIra0x6T1FS?=
 =?utf-8?B?VHF1QnFpdCtEYTR0Y20yZ2hCdkRZUkc1dk5lU0ZLamR1Zk9UcHBXSzBiVC9W?=
 =?utf-8?B?OWJWVERUV0pqREhOSUwrMFFINklLdWt0MTd0VlBSVE1wUDBBbWpyd3ovcmZz?=
 =?utf-8?B?L3ZHZ1pWVTJPZG4rbXFpbzF6ZlBXVmRiVkZ2Yk03MitJUnRJM2ljRFpQelhr?=
 =?utf-8?B?NTV1UFlmVDNVQk1lOThKR2k3OHJSVTVyT2NKMEdwdUVCYUVLdlF2SjBGYThZ?=
 =?utf-8?B?WU1lajZNdUc4YVl4SHBFK1NhN09YSW54VnZWbDllT1B4ZVVxSUYxaDlpbC80?=
 =?utf-8?B?cHljVEVGaDMxMDNKcHVKa0o4Z2FXanRkV3JvcWFPVnlBVysxLzlzSGczQ2dU?=
 =?utf-8?B?ZlBYaXhnc2o2RGNVL1BjVXkrYlZXcDNxRlRobFU0S29MVlFaT0RwVFRIQnlU?=
 =?utf-8?B?bmRDM0hVaGVwcGZmeWNyRnAvNThsaThzaFJ3UmJzQkszMFRBdmh6VEo0SFdQ?=
 =?utf-8?B?YXpHTDFvRXRCK3k4ZEsyZ0FRY2JaZ3hEQUZVNGt4VWgvZlg0a29QeVhCZS9o?=
 =?utf-8?B?bkE2dGxzUzFhNGE3cWJjL0Z4Mk82RDYzcG1YTklUWU9JbFF2eVNUd1pTczJO?=
 =?utf-8?B?aXlHcytOaVJYS2JGeDAyMWtTUjU2ZEcwcTMxS2FsemVOVGpzWVhCUnIxTnBS?=
 =?utf-8?B?cHJGY3JJY2cwOFN2K0RwM2w1c3dJc0ZmdXNQS0RxaEsyRmZ4Wk9IeE5BWDRY?=
 =?utf-8?B?SmIzbWFaNUpkUlJqOFk4Q1loeitFczRuNU93TzRXVjN0elViRUZwVVpMVTJB?=
 =?utf-8?B?LzR3NVBKNlpGOEJ0T1c2d1FSYzNLV2pscER2NmVzZzhyY0NtL3FjNEhIbWN2?=
 =?utf-8?B?cnovTlJDUDVLSDEySEhXSTQvM2d1MXd4UzBoNitQWEVUMUt2anlvSTFkV2M4?=
 =?utf-8?B?STYvYXpYQ0lmbGw5QmZZOGtGZTYvV2x2aDFlNHdmNElraDFuci90aUJ2bmhD?=
 =?utf-8?B?V0ZsVUZ4L0I1Qk5iRzhnK2hHU0VOMXc3UG1Qc0VBcTUxMTY1VXFqSzlRSmpU?=
 =?utf-8?B?eFJPNGIzUk4zZ01kcVhxNTEwdTc2N0F5QmNYVVMrNUtkeTRNTHRhckRUQ0N6?=
 =?utf-8?B?NEU5ZzZGRlJlM0NyL1lCU1FaemdCQWNDb2JwLzVDVitCNStXcHB3NlR4VWgy?=
 =?utf-8?B?NXlHaGlpVEFJcTZWeVVhYlg1YjFhakdzd1Q5ZmVZYlZtcXExc29pSFJtOWJi?=
 =?utf-8?Q?CTZ0yDAqA+DpnSCQDBaI5wE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ShHnmlltdB93Wc/QzbAcQILGETq52ReykNVo00uF2ztl8JttHNJH7zapfdh/1x+gFAe+aAAtFdrcfnPYc9cnSC/UQAX3uByQtDkJcehcuA+A64FO51Ay509kwImR9r0Q02J8wsmJtG2Wk5yPuNMVlma/euiWI3UnZ345DZwu8TO6dw2ydLrIq124cd06PAB/NhL+k2c3o5rh85MH3NWze9SS+q4mTe556nIKa2AKn1mlb23/2Pc95d658u8LeIlRQyFlpofWdtWeiOqKm/5kEqXaX3Ywf9hA5w7P0zLziU4MZGwU8kmljmo9KjsL5OoRWH+h/EhHhumTAurjY8R1gc1cv5jV4bfUuNFQW+PAYe/a6aYJNgdYH9mC/ET2iU0wLTONakxlXjAuJtCf/VF3oYbOfONoLQ2iAZNuVwvrjzO5JSjzTbKR7jz6mbwHLtx/I9wWXO8llsKc1uQ8qJHWHJ5rl4epO+Zy6cBFxNHi+6pd+NLHZ3Od3MFx4gYwfOnrq5MWFw6Avs1FTCLxhQsEXDTQFmJRnmnTmwc0ByQsC6nxMh/AARMGDvVSHRbbJWUHXo6sBPAmgy/b4FA/L+gRidk+v+FMOZb1e0EBuKJaZOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64443445-f817-429f-0c7e-08dc5de91d6e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 07:44:58.4381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIyKNMOUkcArUENmx1WaeYp2PBFU3lDhEpDGcoSRQpLMwH/hab0X+ogmXgDG4adWEHdYacR1ycUyE12/XyAOFB+mo9dBE2l8KnIloDJuHXnZe/QuYbsM5htXmCetaokL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_04,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160046
X-Proofpoint-ORIG-GUID: T3DnwwG4SaWukx6JYIsVjdl9gLkgDaFv
X-Proofpoint-GUID: T3DnwwG4SaWukx6JYIsVjdl9gLkgDaFv

Hi Greg,

On 15/04/24 19:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.28 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> ---------
