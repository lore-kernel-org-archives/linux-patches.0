Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F4F2C0333
	for <patches@lists.linux.dev>; Tue, 13 May 2025 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161673; cv=fail; b=M/bz7ksNBoMEwNNUyJRGuecWxD52tPfauTqckLQ/JBDxUPtDbkdzxqu+88L2rr05EuSErfaBWn6y1mRpS1NEfjSnQiUrRXnfZcD+KkwUJyYksG3CCJKf8W9zMpFuwa3isTS1jtQOj4/GtmSEkMT2XzDLdwtR9ofSC1inXw9zpBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161673; c=relaxed/simple;
	bh=mAu7PnrTjTVuZoph3XxIR3hwUvjtkLn0p7YQsGslJDw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sCQLRlosToF0IHXAJz8mvTYCLJ/P1oG1kYXmoEubcGtQ3H5SXDmxZuRTlLOo6lnN//n9PKlwz04oG0jphibuRRXFFrAa/Z/A4zkogzhXon2uE9zjybiMMML9imxL52TJSjo2AoEYdcghNECAKOICoWKPIag9JgtvuILXanzhqi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k8bpC4HF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n3D6hbay; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k8bpC4HF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n3D6hbay"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DIRirv013104;
	Tue, 13 May 2025 18:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y+8yByNAYXca58zWD4ncNGIcpEqCkqiA0FQ/pLmDL8c=; b=
	k8bpC4HFJDgK8BJDBoTOPnR1vIdkDYPpfxTIZOvBATPw0HifasAUOdvo7qbU4Vik
	+uW5OzlgYErbpcTAJibqlZgFUWsu7eOHPBz9dUtSd7m9OyMzHBNcjz9q8Z6l1UP1
	lhefe3WOu3F67AABHiATOWtvS0sj8pkLv4W43dNz3QnchRNsUVMgP1+xTAv8f4sm
	bO+SUe9eX16nfxm/GDhVuEVOUXrGnvsu4UAHfZeUfveG8vog5F2pP1Gqd/LuxL+8
	/Q1T7q50jo0AkZm9Djw3U+r7OgtQ4jTYws44aC7XCzx+7ktj+4VxiFXKwWjmtzyC
	t55qfPpMOugqpPg3nfv+xQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcdr0pm-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 18:40:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54DHUN1m004345;
	Tue, 13 May 2025 18:30:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46m9d3x2aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 18:30:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXItnCzHK2O+rqZjXcE0F9osW9tJLPwRHDc0QlZB9YT8m4iPw6wvEJ152tvyzz+96UmlnnGRVVO2HheERi59kqY3hLirhNpp4HVK5LJw4T3XZnJm49WXUc7T7xJcMEXN0SPlBiEsHHAxzGQ+rWSWE3so1JPwqs6BCwFjUt4nBhKSOTlB3xr/jUmWawq50W/N7A9msG0X6kWADsO+jJBf5eIYpkPVxuyTGKnP73wxXVYidKhTCEKgtN7dINmS2bFZXF+rkH1KNNQMdgE/Ap8QqQYp4HhoG2MyzXxenDq0i+IljUn5bD1ILS6scJuKeHJ+U+S/nRJCKXQI+qvTRK7kyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+8yByNAYXca58zWD4ncNGIcpEqCkqiA0FQ/pLmDL8c=;
 b=LgWBCxaBvJQXmfsVY8C9S8Rni3rtrUxzOKJJEFT7cQhMl1apmbqkB0pOHNvopo0DkoWZwQeTN3VC3fkvECLwJSulvAeNJyGtlgndzgNC2Y3DrxZz0mOmCUDNgeNLgr5EYPjagmrpebKxs9trRbfE9i6t/tkFspKVY6jF6zCJquN2vI77b68n81tA/0dqOO9GVGdwyeVQ1L+0IItOWnVLkkYE803lOdX6riJ7XysubtRd2WpbVs3A1TL10740NXmXg2zP5V7awAFfLp9oHOkG5MSVL6sDiSeSnl2Ld76Rj6J2e9H4SIVxm1diNoskphr3jzboBWugyB7egQMTyKbj2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+8yByNAYXca58zWD4ncNGIcpEqCkqiA0FQ/pLmDL8c=;
 b=n3D6hbayCfOD+hkY50LzmSoedO0WwNdjtLqMux55d4+71e3+NF6m6CKGdlM4sj2IfiP7Ugxyk4fwe84Q+18hnzwxEpxlADKdObopqyOexTl5qrtrsMsaOgcQBU1d8/bZl1tVwK9ZAx31+LTWl5vnCAI47OHvtTOF8LxyGRCsXwQ=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by DM4PR10MB6230.namprd10.prod.outlook.com (2603:10b6:8:8d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.21; Tue, 13 May 2025 18:30:55 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 18:30:54 +0000
Message-ID: <88d537d6-57be-4fbc-9722-15997a022abb@oracle.com>
Date: Wed, 14 May 2025 00:00:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>
References: <20250512172027.691520737@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0034.apcprd06.prod.outlook.com
 (2603:1096:404:2e::22) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|DM4PR10MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: a0603215-3458-48d9-1c36-08dd924c4be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UElZZFNUZzdNTjhMTkh4LzFTZkR1L3BjQTVNN1lnVEttNkh3YkN4ZUxMR2VD?=
 =?utf-8?B?RDY5eVBPUmZUVDBtTVdBdlozUWdFckI1a0ZxWWJ1dW4zaEJCWGptV2ZHU3dD?=
 =?utf-8?B?VENaYjBwbVFoSDhqVWJYUkMyY0VIUWNNdENEdGhOVTlNTi8wWTNqRk1DdFoy?=
 =?utf-8?B?a0FDZU5Ta3g1eTlFRXkxRDh0czlRMVpPNENrNTl0eHZQRjZwb1B2UzFzQW1R?=
 =?utf-8?B?bTNWTnYwNWc3bmFNTFlzaFB4UmQ2Z2ZHYmFhRDNEV09zMkNTanI0a1lER3lD?=
 =?utf-8?B?T1puMjkyalVaVUVDRzB0WFk1YjhGV0c5aHhNSFlpQi9ySGtVTW9RMCthMFoy?=
 =?utf-8?B?Z2NIRXhEUHZ2WFo2TDVBWWZzYUNBZG9jY29DQXBGRHMwVGdmcW1QaTFyUDdD?=
 =?utf-8?B?Y3JYUEMya3ZZbStodXMwdjZSWTgzczU2L1BPKzBpVEcweHpzYm1VOGJnQUJO?=
 =?utf-8?B?RUZRdFZrOXd5cWJrYkZySTdCTXFnRUZnWVp3UXNNSW1ES2U0RnRscFRjSFZF?=
 =?utf-8?B?ZG1xd2N6WDY4aEdsejQ4WnFnMUV4M1pFb2NIOXc0Z1RXbUh1cXRHT00rUi9M?=
 =?utf-8?B?N1N3aS9wSXd2Q085OUx2REFJNThWSG1VYk1IU09TTk1wTEtVaW5LdG5iVkRW?=
 =?utf-8?B?SFRDZXlWZFZSd0hjYUlGSC9CV2c2L0g4VFZpZXF6aG9OVFYvNHVwTTEyR2x0?=
 =?utf-8?B?d0RjYVRNeUFpNllndkpvZSt6eVJnMTJnS09uM3pYOVdPVjR0Zmpvd3IrdmJP?=
 =?utf-8?B?bERZZENzbExaY3pGYnc4dGpoY2kxL2EzdlRmVUFNQUFKMENCaXdwSDhVdS8y?=
 =?utf-8?B?aDF1Tk1rSGV5QUt0Zm1tZjBzUWRrSVhycUl5bHI2YWFpM3YzenNhRTV3eTM5?=
 =?utf-8?B?Vm1qcUpSQS9nbzJTaFBVNkIzSDVDRG1mY040bDQzRnJHbXM3UUh5OHlBWVB5?=
 =?utf-8?B?R1lQTXdwcnBHeVJodVhkRHZLdXB2aktrOWxaNjNzRCtvNUpEQmtkdm5BWkdo?=
 =?utf-8?B?WDJWQnZFeDNxaXU5Q0p5YnZwMGJBZzFucld3T3RxcGNTTWJnTWJLZjVQT0Vu?=
 =?utf-8?B?T2NXOGwzeGdHeGdpeHR0RzVTSlY4YWdtRjdUSWlFbEU0eWhRdUtMRGwrOUlp?=
 =?utf-8?B?N09vQTdaMWI4cUx6YWJzWVpTKzFjdi9oTTlPSDZubnJkK2oyamZlWWREajRK?=
 =?utf-8?B?bWJkVTV0LzdEWXFjQ0REc1RCWWk3NlU2N1M2VzBiMFI4R25FYzVtRy9UNXI0?=
 =?utf-8?B?Qnc4RmpxOG04QzdoSWc2WDdOa3ZVdi8vd2tudzFmVUhEajFaK1dIR3pLS09Q?=
 =?utf-8?B?VlFienA0bS9ueTd6ck1GU3JBMWUyVWNFeVZ0TGYvbVExdE9OaXpjYUo5K0F0?=
 =?utf-8?B?aHVxZmQ0bHVKZVM3OVhCcERLUHhJNWs3My83TmlIZ1NSSXA2VUxiRmFxdkc3?=
 =?utf-8?B?ZjZteUhRUHNpd0JYWmN6Vlc3YUtaMGpvVC9HMGlPblIwU1grQzJEbUZ3d0NK?=
 =?utf-8?B?YmZLUHJ5NGJsWEwrZFpYYzl6UE4xZ1JLRmZWakRqSmtLR0JYRmlnNU9sRjZt?=
 =?utf-8?B?RExBQXBvNE11SW5sVWJOMWp4Y0dLd2RrYlA1aFAyNlhQUHJyWGVHNzU0b2Vq?=
 =?utf-8?B?L1VHUTBVL2tLK1FLa1pJZWhWaDhHM25FN1B4UmdxRGQwbE5pNEZWb1AzK0lG?=
 =?utf-8?B?aEhoRjdGRE5TaGdaOGVkdEgvcEhmRVU4K1ZHSXBBYVdaMUgzTlZ4UVdHMm1S?=
 =?utf-8?B?d2NHQ2FscWpySGxOSngwM0F5WUlRZUN2T3JBcmRYem1NYnFSTlNDZjN3MXVt?=
 =?utf-8?Q?0UZSnOLa3MaOggJIeRVQUPUPciWhwfGOxmAyU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUYyK1I1MzBxWndHY1Z3YTVwMnpwYWlkN0tPMWdFQndZNUdXc0oyOGYzYVRV?=
 =?utf-8?B?S3BNellnZy9MNnhpQnJQT3BhRHZFenpKNjc0a0RVUmR0bEl2MmJjSUFQZndV?=
 =?utf-8?B?UVdWVWNwVlVoWDI5cXQ2Y0dsclJZSWF5S0pvdUI0ZmZNcy9ESTgrZCtFUENT?=
 =?utf-8?B?SVN1Q1FPb0t3U2tKbGJ3NzBKcWVMNGgzQkdnUFR5NXExZERXU3pWWkJHUTBD?=
 =?utf-8?B?S2t1NEtrZFFubURqTmttaitUbGhqYi9POVhSUVhGdWpaUXM1TWtSWHk0Z1dV?=
 =?utf-8?B?ZC9QVGx6aGE2dEdQMThTREN4Vm5VUUx3TmcxbmJmREUwTzZDOVFKbXhhK2o4?=
 =?utf-8?B?eHhHTHFpaFhoMzZiblFuSisvb3IzWGtmOXYyNW9aUzZ5eVIrbm9BSHhSV2xY?=
 =?utf-8?B?YnRXemVLUTBiT1cxUFk3eVFMOEdVVCtrUDhRUlBHVkV3cWtGeHdnRWsvM3JH?=
 =?utf-8?B?b1M0MnNwcUptRVM2M1IvMUhkeHJ4Qkx3WEhpRHJLTzN3cXl5WDlLcHQyVVFZ?=
 =?utf-8?B?MDRKay9tUTRONUNUZ29VQ2VJRVhQK3p0Sm9PZnY0RWg2a2pLT3orekZHTW4x?=
 =?utf-8?B?MGhQOUY2cjBqUEQvZUh2U1hBd0o4UzBOb1JQQjJRT0ptYktjREVsdzQ2TXZq?=
 =?utf-8?B?S1Vac2tCQ0NDVzc3T1ZoTHFrbkc1cXJYSDBudTF5d2s2bzQzZGdNdzZoWW5K?=
 =?utf-8?B?VVI3eDIrZFpaSThFWXhtYU5DNFlTRVlHYXMxbjBVaDROeEpYMmkwb2JraExY?=
 =?utf-8?B?VmMrVHB6VVpwYUlKYjh2SjNnYVVCQmRvc2M3VGxBZms5cG1oMUVnM0xjdWpr?=
 =?utf-8?B?QzdMOHZrWDR4emgvbyt4OUlReXZLYWgrc2xvK3Fzbll1WmRuUmFsVkVkNzVP?=
 =?utf-8?B?YWRmditYcDJnSlQrajZpRkFYMEF2NGVJMnN4cGRLYzFCWFNPSGZKWUJ2WXp6?=
 =?utf-8?B?ZW9JWkdHRjhGUjA0NjB6WTlmQkl2YksyOXNmQzVMM0JyU0JwZys4MkUrUU1a?=
 =?utf-8?B?K1QwcXlJR3JUakphYlN3MkxiNGRUWUY1bFI3Tlp5UFVxSWlndlc5My8wY2dq?=
 =?utf-8?B?U3hobnNUL3BqdzJMNUpCc2dNKzNQekFoWjNLc29hNjArSnNvQlhmcnYxUjh4?=
 =?utf-8?B?bnhUZllUWXhGS2dQL2MwUnArWEtsOTNiRENyTWhnS3FmVC9yN0oyOGZOam4z?=
 =?utf-8?B?R2lCOGlaQ2RsQm4xNUkvR3puSnZSQ2k0UzduS1p3L2daUmlYWWRsN2dHMXg1?=
 =?utf-8?B?WEVTaS9jNUo3OHlva0JjbUs4WU5Rck1OT3N5NjRyY012T0F4ZWVoY3VKTXMy?=
 =?utf-8?B?enN1dTZrVVZXM1VoWlJOb1dJZjQ5azRoamY5ZGxzeWw3VFJsdUI5clNzK1Ro?=
 =?utf-8?B?YSttaVNOaFBEMjVXQTZrbVc3Z2k1MFdpTURzNGNidWRaMEs1clpJWlFrZk5U?=
 =?utf-8?B?WFRVWFZIMzdCYnJwTUlVUXZ1RVplb1RUS1dVaVNxelVzYmFZM05jbGI0OE1i?=
 =?utf-8?B?M2lnRU5xRkNoUHF1TytHZkFSRVJrd053ZUZPcmwwWGJmOElyVmt2cXJldENj?=
 =?utf-8?B?OE91SG43bHRTd2E0ekowanJMR2FhNmZpdndiaStnZHBsTHlaYUc4TjhDZVgz?=
 =?utf-8?B?blZxZ1NHZ3BoVVg3ZXg2c3N5bWdNdXZnbUNxVjZxUnkrNU9LZ09WeGY3S2t6?=
 =?utf-8?B?U3BwMXV5OFhEZjJhVjNxa2FIOWNCSldTOUpMNE9ONFRzdFlrdWV1eDQ1OEdG?=
 =?utf-8?B?Zlc1RGNHaXFmNmxVa0hQWU9mMVVhRzRQNGlWT3FWRXh5QkRBdDVmb1ArWkg5?=
 =?utf-8?B?Um5rQXJzZHpiTWhaZ2dyQmhJNzhvcmF0eFErVTRVekt2VFFyamJqeUp3dGJN?=
 =?utf-8?B?LzZxYlRkdmwvblU1dWhOWlFMV0RwU1Rsb2dZS2YrT2xRUnpxandvUUNNUTJv?=
 =?utf-8?B?MWI3eHREWm1SQkd4ZURkRFB2a3hmbUFlN2d1S29lYnpvYS9qK3luQVM4SjZo?=
 =?utf-8?B?Tkp2Qnh4ZDdHK0NSYnhLR3E0bm1jTHhvZzZlOGRpTVhGZ09mVklpL0p3ZnYr?=
 =?utf-8?B?ZHZmYlhPYkVFMWUyMFlXZkxYMFhnQlpWN1NlYWRxUEkxNHYzNXVMYlFXUW9V?=
 =?utf-8?B?VlZjbHJJeXFERW5HdTdYc2tJUzNBak1ZQzVlaXB3QUh2bzZxekxZN2xRZ3o5?=
 =?utf-8?Q?NIP3B9+DqSZGn7bPuXbfUec=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cBsr6caByorMLpxRjk+FkQOhTL4IbmvD64ppJocpWHfRPlJaZjXdMkp/8irHGcsBcaaND5fIEvqFUx0TYOO3PLsQFBYXUIBF6muRM+dS6l4VWD2cdIWxA7nJV91y3mwV5yZOzOWjGrVaH1fzIujyEokQLK+FzwRhuvLRUTIQRVFzcx2Bf9jIWE+hb7ToDkmtwrQf4lf6b1Gaiu4+KYt2W7mNtCUqI5FMO7abQcxiqG++h/ezrg7BGHSTODfelLSwgZ3jXEx+RaxX/ODyhs349504RNHT6bzrShQq0IdawqG9lwJ3m4cfhxuG6vYwLERN3bW7+tAK+cS3FQxYKn/ep0aW/6lpmWuG2uhr4BxnjVlNH02lKv88Cedwc4bPbsnL/vZLmZX9m2d1h5YpX5TT/gRdc13HIcurIHSCZdxemPzXQ08PzZhm2r29ooYl5pi9RjHsXiwownY0ABcOp42qv9qXEKZFkP5ihnyM62P6N4qgiGpFlaomjbJYdvmaK+oGoE3rzcrFnVYHCMW+A1PUo6lskS0SMaSWMgO7fgukcN6FwdZnw08eCy596oZD9pOHoj05oT5zdSP/z+btmu+jpDYk8pKMRRovYRnEOibbv+0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0603215-3458-48d9-1c36-08dd924c4be7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 18:30:54.8301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boS32NLdYMt0wR6Qzsfv64bauQpqD/zyPpC4P6hPYEZS5llSpv//06WOCWemTUfkexICnwcuTwTipaJwzAZSNZMLSm72ttrbKNaIS3JDgWRo8gY+XX+MAa8ceuuRdJ7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505130176
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDE3NyBTYWx0ZWRfX7NTzFVbKpoph EjtaXEGdNzFDAwIe2AU4Rhn2motWm9kvq3rSQZGJku9bMzufX2hnFGxi36omyQR2zrkingWqg4k NYIy/A+l78dgaKWToi6FLUtPJzeSeyP2IOE98RWCTryG1mN8FHesMedcIQ5xfQvxPdYcgS5RY6m
 rHR7id6qYDsiQYjsGGI/T52IeqOkpk2vq/CPkeZ3SuShCK8uwgRa26S36xQ7PMXXf2plc6XHf5J W95sTEuNfFYD8HAS1cQ9lOR3NQYqimgnp0F1MOlZHfm9sKagc+PnNuGieSyOMsX21mQ/7gsq02B Exf+Yi7/Q1b177HqiSi6zeLaef0kv8lzVL6Jdv78qcqexuDL06zzzg1N68u6kPLuRhrCP0Rvvon
 v+MMLkPc/owfWBTdTnrIcVwdNPVP7mKYtQQzBa0CHrUaiBBzQCspoXuEG7MNstCbUon6bgyQ
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=68239239 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=CVEbDeFSAKXBpkHMLywA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-GUID: CYnqxt7BMwc5PljAqEVA__Gykh3PdQX5
X-Proofpoint-ORIG-GUID: CYnqxt7BMwc5PljAqEVA__Gykh3PdQX5

Hi Greg,

On 12/05/25 23:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.

BUILDSTDERR: arch/x86/kernel/alternative.c: In function 'its_fini_mod':
BUILDSTDERR: arch/x86/kernel/alternative.c:174:32: error: invalid use of 
undefined type 'struct module'
BUILDSTDERR:   174 |         for (int i = 0; i < mod->its_num_pages; i++) {
BUILDSTDERR:       |                                ^~
BUILDSTDERR: arch/x86/kernel/alternative.c:175:33: error: invalid use of 
undefined type 'struct module'
BUILDSTDERR:   175 |                 void *page = mod->its_page_array[i];
BUILDSTDERR:       |                                 ^~


Also affecting 6.12.29-rc1 build.


Eric biggers sent a fix to this one: 
https://lore.kernel.org/stable/20250513141737.3ce95555@gandalf.local.home/T/#m80fb4711dceea0a0ba06ba21ce1dff3cc8e6f703

Thanks,
Harshit
