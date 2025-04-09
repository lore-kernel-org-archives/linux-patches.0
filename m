Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167DF15A85E
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 06:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744180022; cv=fail; b=h9m6hfEJdbT4hfdmQMcxs+GZOUCBhZGYG3Dxvb+CsgnQv5vNsSVDLU5U2SuQGYhg7fe1hYEVRkWyuMHmXMWBokn+fd/2QRpcU/l1gFoLFUT6OXP/S9kdvZeXPmxTGmLPZJR/V3ldUS52DQKOE68VOOyp1ApWvxqQAz6d0YqXG5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744180022; c=relaxed/simple;
	bh=AKf66k0JzuaexUBsGJKMs6LV+YK5rGu2F4JWv2XL3nw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LjwRoYTPTa+msqvGCXEiZaANPZi+KXin61NQN8Drk8RuycXWY1yQWN4R3xZji6bZFOxrpQ6lpZP7x88WjV9nYowwZNOSLRS8yGcDRKflWuvlXuHR/2jkKagwd6ujDJ3Vcz3pNXQUSiuNVTH8day3LnnhFNOqg2yMe4bdMRTyvHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f+wcbsIa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lsRlBUOH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f+wcbsIa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lsRlBUOH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 538L9nw3020834;
	Wed, 9 Apr 2025 06:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=06VtDKdxllKA0tcF30jrHGkmTFPeimb1MXXFpReO3qk=; b=
	f+wcbsIa7MS3k+94CXDi+lWrtLD2StJ0oY1Y+5pfrf/EHfORQKr0iDnZIWshLiDA
	+i5O5Vi25vxNlYX+FkodqYFWu16Cd9PnaGM3XnL/NIYNZ0z2XoQ6pttpzQ24iQl1
	km7nxhEI2DL0CPL0IStWJPsLaoHfRaSe4wVag+AGo4pAlfR2NdlX+dSjRho1AGp1
	LDzDuAyWRcFbiMbVb2q2yquefArPHzQlyjys9eIXMRmBU36UixdjutVN0WrmsH8e
	UheqtsGboCc0uL6T0+YIKOfQQGai4xfaiO+rNkEYbxAgLieWZPp79qqkiSPjqOVu
	Ynk2JW1Poy3+M7svtK5QOg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tua2xbmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 06:26:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5394WhNW022599;
	Wed, 9 Apr 2025 06:26:38 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010001.outbound.protection.outlook.com [40.93.6.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyb3kr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 06:26:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1RquGOXcQdGNH6RaghY5GvfmHsA7VT3rgpN84l4NiriDQz19PCK4//YJAfyqVGFtiVg0x1QzXr2uwJI1zEfEwnhyShm6BYk7k9/66cQxXw2BH5FWM9uQanD0gfBXaqzelJJo+Vks3e4UbRq4PjefbTAGNJwV8SfSIGvr21foy0D9K0lYEmFV8XBVfO/C9bDgWZl7USja2vMv+ff2wJY5AH04gHodTnLtjqt5HqU8wh7gEzr9yaBTv0WYheBJloHjAoT3WWEe3Pw8rg0AbfIKZCzwXFjfJK2NF8jTwhUvWtcBTCZK3tbj+OLUkjs5E+cscfpBOuu0mE5k2Uy0sqJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06VtDKdxllKA0tcF30jrHGkmTFPeimb1MXXFpReO3qk=;
 b=iKtZ0LhABBCsFVo61QCwR26LXHMHUGYR4bt02MK2E5TEJ44Quy3QXj/6oXltrUZyvbzkOrOr0urHTe53z6h7RjHx8mzUathZLU1uRa+orI2xpiOmOG9spq9pR/VuY+0RuOX7J81ZJv3c6YHCgeUTlNNUj/aJycw8MYzypdajUbHWGqcofQWkKtDaEvpOheDcq+Xgi3WwJatNjWWMd+g87ZsumjdIMEKAHS9/kuBfcHNVKB3xKhlNNs2ewT5amto2lF46wsGRuWog/yT7xQQL7FLw4E5TkkIOtj+a92UpJuKMv/+bB5MpRyqY5b86umZLilOs+ia4Dsvw35sAncFx+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06VtDKdxllKA0tcF30jrHGkmTFPeimb1MXXFpReO3qk=;
 b=lsRlBUOHaG9iKWdtEg0TZ3pTi7s2jaQOEZZrfeU+7jPkhZYtOLDPGvorb/1K+py7h13tVEqb21SB7xJhZFK5A86d2nSde4pNBMhg6wGI06sQo1GA6hwzfKxZqaS9AkXT3+ACGbjuH4NVLw3EaVTgu4+mDRz3Muqfoef2yuaQdm4=
Received: from CO6PR10MB5426.namprd10.prod.outlook.com (2603:10b6:5:35e::22)
 by SA6PR10MB8183.namprd10.prod.outlook.com (2603:10b6:806:444::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 06:26:36 +0000
Received: from CO6PR10MB5426.namprd10.prod.outlook.com
 ([fe80::7845:9ba4:7ad2:374]) by CO6PR10MB5426.namprd10.prod.outlook.com
 ([fe80::7845:9ba4:7ad2:374%4]) with mapi id 15.20.8632.017; Wed, 9 Apr 2025
 06:26:36 +0000
Message-ID: <5106d943-ca8d-492a-80b4-16857d828962@oracle.com>
Date: Wed, 9 Apr 2025 11:56:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/279] 5.15.180-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250408104826.319283234@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0164.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::20) To CO6PR10MB5426.namprd10.prod.outlook.com
 (2603:10b6:5:35e::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5426:EE_|SA6PR10MB8183:EE_
X-MS-Office365-Filtering-Correlation-Id: 14c71c23-2542-461d-2ec3-08dd772f7a8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEw0Ty9HcTRabTNIVVpERWUwUVd2MVdBbitQa1UxOG5pbXIvby9Gd0wraUt1?=
 =?utf-8?B?bEFSZ0MzYlJCYWVDWGtGRHAzZkJobGg4MWl2a3U2V2lWREc0OUhIMy90MjI4?=
 =?utf-8?B?em1JRkVuS00yUlVFV1Q0Q3lpSzVqWjhuajdKMnRDd0NCVStCeWtiV3lYVDl5?=
 =?utf-8?B?cHpvb2swWVpjb1k3Rnc4M25ibDE0aTFHQ1RObzhNU05PTHowbkRHNGxJN2NQ?=
 =?utf-8?B?OUptOUFIVGUwTnRvdlZIdnlTQlpINVhuanB5MGkwMEFuOEVBZHBlajJLeVli?=
 =?utf-8?B?dm1XeE5CS3UvbHA5bkVjKzFtSm1iVFRCSWdFRUttVGZpK0EvdmxrVzZ2NXNP?=
 =?utf-8?B?c3ZPeHZ0ZVNIYnJCRTRPcnl1VVNpRXpzVzV5RFIrT1lPUXpsUjF1dkMzRVdH?=
 =?utf-8?B?K2N3U01DV2l2WDNsbllKU2dIS1Y1b2ZOeHBPbVBxeThxUEw1aWhYNG9nV0xM?=
 =?utf-8?B?ZHA4RWwxc0N2SWRBbWV5RVNobFR4dUdGMkRydXBlUTVoVG5yS3dUbkxMN0sr?=
 =?utf-8?B?cmtKK0FlS1NjU3BrZHFxbmQrMTNOdUd1cGpsWVkwSkxucjFIT0hLcUVWWnZR?=
 =?utf-8?B?OW5GWE0za3NiZGZpcnJXVElzUjJqL3Y5NGN4ZzNzaWhOQUFaNWhhNngvdWJ5?=
 =?utf-8?B?bjZqNTJIdVFuSHgzVWV1dUFxUjYvZXBaRUVjVlNMUGVYeEltdTA0elZmZzVK?=
 =?utf-8?B?MGFId2tmT3NUcVh3QmNzc3JCMXlqMGN0dVZFV0YyWUhDcE5UbmpXYStGNWpr?=
 =?utf-8?B?Um9SMG1WdkoyanVSdVM3UWh4cXZDMHFja3M4bUcyY3NiOEZSWDNKSFpVMnhC?=
 =?utf-8?B?OFc0bVVpYmpZOTJkTExSc0JLQUZpNHNVN1pSNithUWZ0UjFoVHFPQzFQWjli?=
 =?utf-8?B?SzhFWDU1cGlTck5DWDhVbm56NnN6NmVPK1VjVzRSREFRd0FJUDV0WlBaeWxK?=
 =?utf-8?B?NU5ock1UKzlkSjZuTEFXTUE1RVZ6QVcvZ3B2TUp3ZTQvaGp2dWVVTTNGMVdG?=
 =?utf-8?B?enM3V09KTWo2T3V1Q1ZNT2tzNnhzeWhNSkFneGFseVRZU0sxQUtmY2RxNFBU?=
 =?utf-8?B?enZWVFBNN3UzWUdrT3dXdkd4RUNmaStWVmxNZ2hJVkp0MzloU2tqTVdUSEln?=
 =?utf-8?B?QzNwRkV6VjR0cVFRMUk2SkdQdlF1QXdVaHZkNFpaMDYwZGVoU0dPMjR6aDRi?=
 =?utf-8?B?R1ZLUnpyMGc3YjN2Tk5Ddk54YVkvUXhwdHV2UU5uSXo2MDVsQXRpV0lQdW1S?=
 =?utf-8?B?SWtnRmwvMVFKanNYdXhNWmxPZnB1QWs1bllHVzIrTlFlN09MaXEvUGw5M1ZH?=
 =?utf-8?B?YmRQYWVZMG9rdXYrK2VseW96T1ViaE5pN0w3a1VQSWk1NTMvcE1YZGYzb21H?=
 =?utf-8?B?OTg4L3hUSVhqa0oySWJ4TkNCK2xyS3pXazZRcFFqS281V0s4allhcXhGK1ls?=
 =?utf-8?B?Wk1iY2ZtejBrY3l3ZnBod28yVHZSaUorRXhSaVl0dWtzalNHRitkcmI2NCs4?=
 =?utf-8?B?TGhFTEZRMncrVjZJWUNxdjVzcEVVNzh2MDF2UU1FREV1Y1lXY3F4UE5OOU1a?=
 =?utf-8?B?N25POGMzQi9VSEp2NTNZc3lHcXVXWnZzTFRoT20zM1JYWHZiT0RnU0xXMTlv?=
 =?utf-8?B?NDF3MkxaMFVyUUl6dis2eDc3cHBLRGhadDlIbWQxTkhDRHE0THU3NjFIYzNq?=
 =?utf-8?B?Rm5FZ08zMWJtL01vWGcwdmptUWtCRldSZ3ZIMmFKdDkxdUJoSEpRMXJ4aDkv?=
 =?utf-8?B?cDQ1SlpybEl2dFpPSitQNFNydGFlbE9JNm92YjBuSldRUzBTcGVkdmp4TWlB?=
 =?utf-8?B?OC9PaDlNVWg0WU5IZjU1QzVYczdnVzJJZHpsMHpZSzg4eC84azFqeU5pbTdJ?=
 =?utf-8?Q?NXyZTuzx1mkBa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5426.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTl0ZmlUNWF1cFUxY2p6TzNNMkNKOENxZzhDZSs2eWZJbjVvQ25RMEEwL0c5?=
 =?utf-8?B?RVc0c01GNDk2c21WK09wZUFNMXNWTHdNcEV4c3RFVUtSU0g1eWcyUnhGa0tS?=
 =?utf-8?B?SVZTNlpXbHdNUU1sM2JMblpId1NKempadHVLRnl6d2xRNXU5K2hTVnJXUG9x?=
 =?utf-8?B?S09pWDd4TmpkWUxpZG5RZkFNVS9OWFZrV2QzUWdwYm40YUZ3WUFOMEt4K2lW?=
 =?utf-8?B?OGY5ZFkrWG5HeXBlVFZNdk1zZTBraDloZG1rdTdKM1BDajI1eWFqdnJST2RT?=
 =?utf-8?B?cGJENTFuY3RwV05ocXd6MGFIZVliS2ZQcDYvNGZMSWQ1a3Rpd1FJYk1WUy9K?=
 =?utf-8?B?NThqVTlqU3I2K3RyYkE4a0R4ZjJiSjVLTUJHQ0psVkVTSG45by96ZllaUnZN?=
 =?utf-8?B?NHlxbUtOSjdzMURTNWtQekZEbHoweEZTTVZTT0RLRWNyM3I1aHljTmZJcXN5?=
 =?utf-8?B?ekpEdTlkMjRQbXVDVXNVaHFLV0hubHJ0M1BUWmUzZEVSUDdjV04wZ0luOVZu?=
 =?utf-8?B?U2lXZEdWWlRCNnN4S2ZzYnVPU0wwM3N6TFM1ZVhPaVFUL2JJem5FenE1NVI0?=
 =?utf-8?B?MENHK3ZmTzY3R0QyQnpSWlFiNWpIOUIwQzRrbCtkN2lNTmQwYTVDYWZsOTRp?=
 =?utf-8?B?VVhlalpLSEpiRFpxQVVnOEhpM2M3L0hLZ2xkejY4WjdKbE5rcVp0SDU1TzNE?=
 =?utf-8?B?aE5lT01tQi9RNWdPL3o3SFo3aTE3Zmh4TkJ2NTgrNU9QaDlIOGx6dVZSaGdj?=
 =?utf-8?B?STRvNUl6QnRwdWdlN3ZmOWxrSWZ6M2MyeDFTSGlOVXhBS2wyb2xRM0hzUFVX?=
 =?utf-8?B?dUNsWlU5V1E2RGU5VlhScCtqRlZoZFNId2QwejZiMWN6Z01aWWNNWEU3aVor?=
 =?utf-8?B?L3dTVkdSZU9VdFpkK3pZYUEwdEo0NkdnZVlYTTg5cVR2UTRKYit2MFRxa1ZJ?=
 =?utf-8?B?VWNwYkJ6c1dCNitScmlwWVZvTEhBeU14WUx4WitucHdkSTM4QnMzaVd1UjVh?=
 =?utf-8?B?Q0wralpSbTliM2xOQnI5MlRNK0c5VTFnTGxUR0xGVkZKMmlZVjJ5cVNxSDhr?=
 =?utf-8?B?bnNEQUpkOHZqeTBma0dOV256d05jRzdZbGpneld6Z0JUWkg1YUVnOGk1ZGcy?=
 =?utf-8?B?U0V0dk5FQStCZFR2UXNaWVRTUzZDZytIQ29RT2tQWGg4dHRXNktaNHNjbi9G?=
 =?utf-8?B?SnlsS01taTBPYUgwdDVOZ0oreUFteDEyMVlHUmNMSXV2TUIrNVV0K2puZ3Jk?=
 =?utf-8?B?SUpWOFlMd0R6OGxRUFZhWDIzN1BDMWxkbERBSzRGMnZOWEhybThxZEJrdkNw?=
 =?utf-8?B?eEd0VlBQTTNVWk1nUjY5QVY3R2NNeDZFaVI3dGZnQ0tuRnZoRnZjbDFQcUJ2?=
 =?utf-8?B?RlA4cWp1ZVBkNHJieXczdzFzY3hwbzFOb1F0dU1TUklCcUl2RE9FQzdZTzR0?=
 =?utf-8?B?ZERnRzhBdzFvSjBtek1nbHgxQ3ZjdEsyTHQ5bjJTL0VqVDhZL25tNElDN0Fo?=
 =?utf-8?B?SitqcE9nMW1laHdLNGROWlZLOCtOYXBIRWVpdW9tZ1RPYXEyN1lVS1cySGRM?=
 =?utf-8?B?VHdEbzIyaXUxaFBselJsdFBINUpZVXNJRjY3Y1E0WHhKbklHaTdmUGF4Tlpz?=
 =?utf-8?B?aUsvcjI1MmJmenlOcjgyWEdodHJVWC84UDN3Wk0wT2hrMEFuNjhCMXMrekFZ?=
 =?utf-8?B?WHpaaTFaNnk1K0lsTHl2YTR3ZDFmRVhUTUl6VmZ3SGtQekVrb0NpYVRIcDJt?=
 =?utf-8?B?aUhuejFaTk1WZHByWUY1YnNYdnJCOFZiWE11UjFyUHJrbCtydmVLbmdnNGtM?=
 =?utf-8?B?WjdsM3hHVG44NVUyV2h2cGRJMFF1RWVSL3ZHTlowTHBEWk9OZmZobnkvbjFs?=
 =?utf-8?B?cjQvNmlLcGJpZTNLTC9ocTU1NjdrZXBUdDNpR3JWOEUxNitacTJBbGJqbmNR?=
 =?utf-8?B?clRsU0N5YWhVUW9BTWIwREFyZno3RHZ4RGdqQUF0eGlyQ1lVVTFOY2lCNlpN?=
 =?utf-8?B?eUdkS2R4cElEU1VuRGRqeTdab2toVXlRMDl1YUtkRjdNMFpLOG8vSFJjMU1q?=
 =?utf-8?B?c0tMeDVHWUdVZC9FMkVCSGRXZnBzQk5KdUM2anJwb1dIYUxheXRPYjBqc1Za?=
 =?utf-8?B?T1E2eVEzU2ZDYVFmVkV0NGIwdU1TcklMMi9uNjZHbFFoR0tHNHZNL3M0MDRW?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	amz7W2XvGb+FoxKai8oQYGdA2Q0H1lptAPJj5UdH3UzZ0Cdr5hpG9VSotoAapUbBnPW6JTO7alEGWFbghF7A/3QiZX8i2J+DBU2fhffL2ZOQ5MVZlWUjAAwcx3SdmlpQrKZfgI9gVEU6Ej0fcVTEIUS5nDWt6hIM3OnkFirmgEVE0DUk8sRHP6IbLmhWyxL/i3uK99V7no/8VZTPYfgebLFMqj6TRr7aVtRENsPY36WyaUfgHYn7q158JDEPeTi/ddUTMCTpdvwCDWaGXAIoziECeZ6Z8u+0E/sJkwBKkhO9fQZxxGYGDILHIRgcGgiWaX7ftQi0zosBf9mavxvHbY/nvr/gGYHsi24ZNcM+upJaJ80PcK28LQKbA7LDY6XaPy6C4yS7u7YVRF4/BGUPmoWSGB/YRVy5KHzjsgb4JJpjh9C/9NHxabsCypDWTTHEIjpUBd5L7wQ9X85ZvzAxp2Yl3n5UAX9WSTPQTCa+WHL0rWIWN3ivavuVn6gYNJP6Li7miiZpA4GTyJoWhXIzjQG11ZqOT2yHnw3eobDdkmHYMvmaaXtgmCatIH6JdCl2Q9QZYtHkDKjCZu0q9oisDL3Qm37n7Vthsw73VMdcb10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c71c23-2542-461d-2ec3-08dd772f7a8a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5426.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 06:26:36.2984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0b8/tFLkZg1xfnaaZIKG0KXNlbMNkUo2K3eNcs26gvZDpW0MbU3bxQXvImm1pHh40uNCQaZNt2YODA3tfbWoF5kb3fgE7BIJFpOXcz+qKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-09_02,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504090024
X-Proofpoint-GUID: NP6qe6oFEPgKLmex_tXqS2anSkv73tVt
X-Proofpoint-ORIG-GUID: NP6qe6oFEPgKLmex_tXqS2anSkv73tVt



On 08/04/25 4:16 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.180-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> thanks,
> 
> greg k-h

thanks,
Vijay

