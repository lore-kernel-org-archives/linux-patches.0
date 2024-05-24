Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCAF749C
	for <patches@lists.linux.dev>; Fri, 24 May 2024 06:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716533651; cv=fail; b=UDkiLHcFBHkjo3ylrrDT6t2eX8P4Sesl7as+nb1aFzdie4Q0acmHtV9wXZzpiw0R7lihNSwtc1+3A1ya0YZwfHZ0D7tyRhYcNIGazeWiDvUmGcxSaNyJ3tH/jz6ne0gZt0sB7P6ljDau6ZOXcFZaMW8XVzZuC6Bmhw1FzJYOyJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716533651; c=relaxed/simple;
	bh=SfGVEEn9uPaAAbRKBp6aVglr8u8xBK2bmKYaK4HbroI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RPnFI7fXu8eBCrm6DLWjjueZZUOrSfc69wS3lre/Ka83hzf61md4ytT6CW2ZUYWOD8u12qth8YMoTMgCSwyIDEvffbCGXV6WvyQJox95V6Van/fVdrU5ob2hpigGdygbDM5BVHJk4C2ny7WzXins23gB0nYPKzRWDTUb8S6ZVO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DtWdEHXx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xmLTavs+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DtWdEHXx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xmLTavs+"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O6c8PK020658;
	Fri, 24 May 2024 06:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=KaSHgs7mv8Df8IgBadTlfemE0wOS2u0+7tkBewI0ba4=;
 b=DtWdEHXxvAwwU/uZvfcnR1CB1nHh4YfcIbN/Ocvb1mUpJuB9kPTv+NEpupoNtBF2JOgz
 TW7RZAxiQoRb+3suYhKlOZAcp0C1/EGW5SSuQZi1TDpaoKV8HBO8Sq4IrJ38JCNG9FX4
 ey3lFGjlKtfxYVQbA+3+7nPyLMRVnucqTQLLzhbpByT72NBUkVWr1WVq2m3OxHE1u2c8
 5G6R84Lei7BDMZSr/40QTPcuPL7f+jVlpmJRORA18Sp9PoHesJH/s9KoYJSzzXm8YCWT
 jTyEoZFQ2ntN4BlkdGOrGfrB0PcLInT58wFrXYoE3O1W2UXiak1NgYCGdXraKCQxC2vr 3w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k8dbr2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:53:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O5tGS8005079;
	Fri, 24 May 2024 06:53:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsbxm4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNAIBTdvIxakWartuVcyknCgUrYuW5qGdExRFYrZibMl/YdMKwVQsyqkHzSs5+2RmCVnzhHUho1Yksz46a9y4frX1/RNi/+inQKNNLBuP8GCtcl2soCAXen1Vh6x9LukxJYRHlTI70wn3xvy9gpbItrDB3kjhz8xE0lwGOl/PoksyXhzLKe4CO1dZ6kzcqTXAQHu0htjuO+0/547Y1/fPgT9PU0E+AAIjv2ilHhwGOkwErXRzqpgAN+pbzsIveXCCjuoE9V88/S8gQinJG4yQNG9PYvKR87owckcP04C+CoJIyd55ZMGS/A/x6zuV0cDRTNb8Jt1LxhUPRvzWDu+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaSHgs7mv8Df8IgBadTlfemE0wOS2u0+7tkBewI0ba4=;
 b=Ueyx+ecPUU3YBD2Xi0Yx6SGH0Ih+XWSmSLSiPQHsuiXTTzo97/zLYrPnCIyojbdgG1uIrODuH+t55hD5WNuv6GMPNZHDVCR+tLXKYbNTibb1xquuAgnauywsoJZOkt/9s05kgvmwM785X8xyHSXpNSxGaElzTAfu4WwsokpEjydK7q1TmCMd5KQ6s9S2EvaOnT9OT4Y+zyhupPfN1+QZKJCeIEQp6larg2b/xAr/+38QkS8dWuQCiU3yUiF7Wal9yxTEej0gSPmt3RWNl9MHHrmr++v6EyQDO9qI75GVWgInBxPK7gd2dYvOgO+OgaNZR/2H186Ycart6XosaJtPKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaSHgs7mv8Df8IgBadTlfemE0wOS2u0+7tkBewI0ba4=;
 b=xmLTavs+RvCM8o5mLmF+KH+sD5sHAgl+Lw7+lVNbdqy5S0VXdLFzw4WNtYke9tfUDZ8peSOst9UWXQmV17o5/44rlfQIIeDnZGC1z5Z3ODHx5bjKDU07Tn6mR9khY/Ewz0kfW2AXL44yiv51kMKSz6syxl4DGDrXsoc4eLdMSHM=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB6201.namprd10.prod.outlook.com (2603:10b6:510:1f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 06:53:42 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 06:53:42 +0000
Message-ID: <42efe98e-2c69-48bd-9835-25ed219f43de@oracle.com>
Date: Fri, 24 May 2024 12:23:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240523130342.462912131@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::7)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: fd90b217-7772-4117-80dd-08dc7bbe3f59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VFJRdDVOd1pKSjFsSDE4bEhPM0I4N3hJOVhXY29oY0dLb3FqVFZpUWlTSVcx?=
 =?utf-8?B?bE83S2RGUktkY29NeStFWXhZZmNhSGNXeXQwUzZEYVBTT0VTU0sxRzI0QWtv?=
 =?utf-8?B?cGdabjQvZERGazR4WU5GR2JHUGlJNzhRbE5CM2dTY2I2WjFwS2ErN21icnBU?=
 =?utf-8?B?Qy80UUhTMXJlRWE0eUNrTG1ydnI0WkhnU0JPTzBzTG9aRENPMERMdUd4a3FY?=
 =?utf-8?B?Z056azg3ci9MTWZTOVRIRVQ0K0svaWZ3R3BOZ0crams3VHFrWSswcmhkaDRW?=
 =?utf-8?B?dUUxNjRxbjhrTkpydE9nNjczUmxsdjk3c2tnNjJZeUR2SlNoT2JIRUwzVDZ6?=
 =?utf-8?B?WXVCR2Rzc1VFYlVpaWtxa1UxOG84L0IzMFR4UFhuWFUya1NrUjVxWDl2OVhT?=
 =?utf-8?B?SURuaTVkT0ZHTFk3eDBPYndXdFVnaXh5aDg1OVFCMnZHUnoveWoxZ3hua09w?=
 =?utf-8?B?ZW5FbUVFMkRuRDFkL2ZaZnNaSDhaOXh1TVVtd0dVcUFhTFJJTlFrMkZwS0dh?=
 =?utf-8?B?MzZXaU5ZMlN4TDVwdnFxNmNuWDBzT2tMMld0WkVtN01aVURCU25IODBNWUlR?=
 =?utf-8?B?OXNnekhlRjc3UWJ3eFZkKzZhNTRtWnBITzlsZnViR3Uxa2lBSWR1dWI5T2dG?=
 =?utf-8?B?elltdkpNNThkR2FMdFVqelE4V0pvMjUwdTBJZ0RZMWtsQWVuQXZaZ2pZWEor?=
 =?utf-8?B?MU1DOHg4K0t1MCtiMTNWL0g3ZkQveXpoemhDZEJNa3VQVmg2bjUzUFcxdEM2?=
 =?utf-8?B?T1NjdmtGUmorVXBTNjZBT1FTdmZrbi8zaU5BUWNNUVhHRDVqaWNNcy9meEpY?=
 =?utf-8?B?UGZldzRGNU0vaVMvNnd6ODR1SFNEV2oySkdQcUxzU0ZiR0NDWC9HRE9JOHBn?=
 =?utf-8?B?ODVyUHlNV21CQlhOODl6dGYxZUdlZ251YVhCdTBqUklEWjZYVTQwajR1Z0dE?=
 =?utf-8?B?cW13YnM4R2NyTklWVkYxeVBENUphMjVoVitlOTE0eXc4cnpvQm55bHVURTd0?=
 =?utf-8?B?TGlHNXJkUXJ2WE5rVkZvTVhkTTUrL3Joc1MzRnRZOElTcVpCQWQwVWpZTkQ4?=
 =?utf-8?B?aXQvcTRURDhsSXRmcytxS2JiM2x0RXYyQllXL09jVDdCUzFxMXhlUjNySWxt?=
 =?utf-8?B?N3FTMVZLeGpaY1JGU2k2N05YTVdFcGNiVWJIajBqYVJMb2M4R2twemdlTkdq?=
 =?utf-8?B?cWVuWkVld1BabzNzelFQRDZHdkNudzR3d0l5aXJ0UnNUcExCWm9kREk0UEk5?=
 =?utf-8?B?YmFoZzFRMGZ1OHhOc01qRGNPV0QwdWJsaWpDcUlBTHhncEhXZW5icVNFMC94?=
 =?utf-8?B?NkJSa1ZCc21jbWQ3Z21kZmtsMlBZRjJNNi9UN1lUNWVkVHdQWTgvSFhuK1FS?=
 =?utf-8?B?cmsvNzhqeStmdlFlVjVtbi8xcE1XaENhSVM2QzNYcWR4Z0djUnlBMHo2TFNx?=
 =?utf-8?B?WFRzdm1xdU9SQjIvVW5HTUdxV2VzaW9QUEJJKzZGeU9Vb1V0Q2UwWkJ0UVEr?=
 =?utf-8?B?U2dYUkFrZzJpODRZN09wWEI5TXZYdDM1YmMzeFZGTDZTd1I2akpvYjhnRGU2?=
 =?utf-8?B?T3dGWTJuTzQwYUlxOCtBZHB2a1FVRGcvSVhuM0gzV2N0YzNSVjU5ZzliNU14?=
 =?utf-8?Q?UWcy9nWr+vPUzeVrBmi4ovIgsPUO65BG5lbHimMoYbcQ=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UWY1dG5PR2pWcDEzUWNnZGc1b3o3c0o0SUdCOUtZcEhIa2ttWGlDeFJDZXNL?=
 =?utf-8?B?VmF4UW1CZFZYeXhTeUs3NFBha25jeXNaK3RGWlM4KzdZTVhRemxyNTdyRnlQ?=
 =?utf-8?B?YXFnVkFLdGQyWGRGeFgwdElVMlFOcTEweXQ4U09KdTFMV2E0Z2FLMHczSE05?=
 =?utf-8?B?N0RzZWhhalp1UUZGbStKMFpReUtqcTMvSWlSYTdkTGthYXNJUEhDNVN5RHNp?=
 =?utf-8?B?cTYySXoydTRGYXpZb21FdnJHeUtHbDZWY0tjK3AyT1FOSlN1cUhNRnptbmNX?=
 =?utf-8?B?MmlJcmFOUHJvRjZscERUM2wvc1NNMEhjdk1EckVpU2MveDBVVlkrZzhIeGg2?=
 =?utf-8?B?RWxVWUFneE1EVVlPZmRKMXlKTk9zRWRVMVNqVE9TUmJBSkhZTmRVeS9IN0tZ?=
 =?utf-8?B?ZFpERjdjUTJKUkpCODhPblFVaFg1dEhXMzV2dlF2NlRhWHVRYTNqbEI4Q0pi?=
 =?utf-8?B?ZlVnT0hsYjRxdXdsM0Vhd3R4dmZHSGZGQzZKMVR2TnBnVnp1SVZ1R2Z1QkFi?=
 =?utf-8?B?blY4UmN5c3hJRlBsdXZpMG8xSmhnZi92V3p1UU40UzRCSkZJMkRmOGNZS0NH?=
 =?utf-8?B?cG54c0JOR2JmVkJQUVZGZ0ppUVlVVXF2eFROWW81cWczSVJTbDJ4aEVQWHZ5?=
 =?utf-8?B?bEVlejAxTk1tLzBKL0pIUTNzQm9NamhmYnJsSHdpZDFpVHoxdkRXZENQVEtO?=
 =?utf-8?B?ZjBqdStSZnN6TGtGUDcvMVg3SFBESlpMUWVzVGU4YjBGMzRnWmFsNFB2bzRp?=
 =?utf-8?B?U2FIc0NsMWlqYW50NDdRTDdyZ1NyRG15QWtrTDk1RWZsZTJWODFjamlJRnNT?=
 =?utf-8?B?UGdiQ0JNeU1mYUtLTUZka1lMaUdFVWNocDdMeVFkQU9XVDdNYlNNZStVN2hJ?=
 =?utf-8?B?cXp1UFZpR2w5SnAydVgxSTV2VDZqbWVQQXRrcVVQSU5RREtiNTJuTXVFd2lY?=
 =?utf-8?B?bndrK3JDUDRjNEZwcDBtaWtkNHR4NEtzWWRaZ3A5NjlCZjlndjI0Qm9QMVht?=
 =?utf-8?B?RVZIcXkwcW15M0J1U1FOOEtCQmdYTmkwcVNyMktxZ1FXeDZPcURWMWNTU0h4?=
 =?utf-8?B?MDBaaVhTSjkxY25yS0NyZXdjckt1NmwweEJyd2JkaU1vRlpaVkUwK1h6VGhz?=
 =?utf-8?B?UTVjUUhJbkZSY2lvb3JQb2VQaFJ4QlZINUdyc0U1VE9sNm04Zkk0RVpWN1ZZ?=
 =?utf-8?B?MGtOYlByVVZoS3kzdGhjWE5vcHNkb3VXQVVvbjdrSWlrUXVzV2dHbHE4b1dK?=
 =?utf-8?B?QXo0NGRiaTVpT3lFaDZoelQ3ZXNiUTZPWExUVkVkemxiWGtMQm0vNmYvY1c3?=
 =?utf-8?B?RE9PTTNSbDNTdHpiV1RTdVRZdHZCTmQ3OE45c0YveFFpOHFHMDVVdFZZM3BT?=
 =?utf-8?B?RGxJM0dJU3RvWDVkYXZ2V2QrWno3Q0UyZTVtZXJyU1BnSk1MTjgrQ2FlUHU3?=
 =?utf-8?B?VzdSSWx5V0p0Vk82RjRSNkkxM0RNTXdnQXhQYk5HN29Rak9CZEJqSC9tUHpN?=
 =?utf-8?B?WVh5QXVid2piRVB0NDlWQXh2MzdPWCtxRDgwMEdQSEtBSS9CaHlZRlBEY1lh?=
 =?utf-8?B?SExCSEdsZWFSOHZQcHJUWjVzNlNFSmhrTUpyVkRvUDRPUzcxWGRyZmd3RU1a?=
 =?utf-8?B?bEtsSnkvL0h4TkU2V0Z3eXJrekdKSEVteS8wUy83aUxWNzhjSnFtZU0ydGNy?=
 =?utf-8?B?OHh2citTNkpPSFhkNW42RHFKSmtQWms4Q3VNRll1ektzV09MV3MzMnYybzdG?=
 =?utf-8?B?QVZNUTliNzhhVDNkSzV6VlJVTmxHSHdYbWluUHpvN1hrdVRtdGx1NDlBZ1dQ?=
 =?utf-8?B?WlFZTnpNSk9uT1BrRHJodlRNeXJ5Y0Rxa3lZZHA5ZFRHTnE2UlVYZFI2NFQy?=
 =?utf-8?B?U1NueHlEZkhMVHhNdXNnVVVnRzhaelNuTWl3aTlNeVlhOWFZTS9VMGpveXcv?=
 =?utf-8?B?Y3RDNnc4enRlS0hmc1k5MW41bmtpL1pXYktwejFnN1Z2ck44eHAvbWEzdHlv?=
 =?utf-8?B?T2NVWG5OTkprR25iTFBIbjdkanV6REppS3NKeXNPeVZpdVBZVk9VUjZnQzBT?=
 =?utf-8?B?TmxYcGtrZmFZcCszK2Q0WUQydjVBdE5uNWdSb3ZZMHVFd0QyV3dHWmlWSjRQ?=
 =?utf-8?B?bldsS3R5RENObWVrQUt0SEZYNGwzbjJOaHowbVpGZkR5a2gvSWlHSW9KR1Nl?=
 =?utf-8?Q?cE+ZIal1a7h4zJ0GATTGQg0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cbWpVcAK7drKkHG7qvJQozadDMfe93btVyK7Pnaa8MF6Lw6q0Ye6wFud6tPYUavh2u/Uocn/FQeaJ4Bu629I8fHq7xj0GcTP4lj+i9FwBHtfURPXUXIkqgvC46i8TO38RpRGppZ/YmW9APOKW5LjBQTkiTbCl/pti4EZMM4l5Xpt/1t0SXhffc4k3058u6dOX4s3veHszrPrtiyrbG3xGTHrOIMjLejQmsT/kCbU0IOHnDuommwZBcrmGxQKyEmfuw2GGzwFZu5Av7O8f1YYDZSlPnp5U0R9wZr9yzT4DW5fKKduKhy2hhxu4iAPET09FZuq4YjzHKQbFn9GFEKLsU+YyucTx6XEXULMwIQ/XcYKgfaj4SQ43j8ZW3yM81GvV8s/n68QLguCHlPIebqfnmE6bBAa1/IU9TgmK2RAa/I3ce8ZkUxXvdRfz9OnLpXyoJUCOwW8mCF1TeD1N9UF5TPAhti9msKHBVPDf1K4Fv+xnFPEkfD+XU5iprqmwETIXVCqID3RpdjrGC+b0+Kd06hKHPmCZZ/S90HlU7PefXCAvIHXUo2HyQkEguqsVS0eN79zu07oiGBc1uDfdnuw7q6Qb3BckDw6NLhIt9s+DVA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd90b217-7772-4117-80dd-08dc7bbe3f59
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 06:53:41.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: la8/+IVaQBWRBrprh+155ha5oS+ueRhyDnX2eTRyBvWoNNGYmpmvWqAu1t/D3onx3n+wT4nj5ZuZ14mpqV15AsCLXIHe2qHbB3iYh1bBluttn9npVd0V/aiohCT3p529
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240047
X-Proofpoint-GUID: ITFTc8-2NWAV_o3hR9rh9aGQVSsqK7_J
X-Proofpoint-ORIG-GUID: ITFTc8-2NWAV_o3hR9rh9aGQVSsqK7_J

Hi Greg,

On 23/05/24 18:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
