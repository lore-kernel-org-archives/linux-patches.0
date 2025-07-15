Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF49253951
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596483; cv=fail; b=ZBJJIw3TE2TTE0a54/0UudAix34pafYcQ6eCcZCpf1mr44gHw2yOwJo3RSHQUJ1jHLm5BrFr1SdH6wVWvCxSdquVQPy+yuX3su/rVunwMT6fAdZn8hQOiLW+NUA5KD+/6QgCKxiYt3M77NYWQPqyFMMBcFZqrgfcU6itisVHPyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596483; c=relaxed/simple;
	bh=C6EU3fnR4aRRvJjKhm1YGHJkYx9MCDysHOSP0Hd6y2g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g1pcT45rsDAoRw7Mh5ywslRJZgZrBgTDTaR80WfjhD/q+Ahy4U3eizLGyZ4zhoyD4EP85GNEeOKiJj79/cJskE3aYuEmxToDirZN0g84Y6CFOiirj0P9wHgQgS1PnqJgJ38XwY/R8Rjg3giWkMbc6TXaccl1vbDX604rADVmo2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LRY+adAa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BOzc9DtE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LRY+adAa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BOzc9DtE"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56FDaANM026917;
	Tue, 15 Jul 2025 16:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JbkkRCI8TNOEBOm78tCKIB+XHzesDR6d6cL6LUDI4ME=; b=
	LRY+adAauCHTIP+Fs1MdfY4Fvrjy/aWcX6dOIyzPX6C+bJMGdA7nEhJSdrtu7eV5
	9yWhyW8f26Qxklm5WoBQChwypKwDeUHjz2DGFlyUraRb7MS1W9T2V8Wd4ArY9uNk
	FbZxJsMhutteRnHYj9IDX8WPF3gQ9/2xvBY2eDadtpLnuV0KsSdOPknDwVgJjkwJ
	B0OAMuNcoBHnbD23B8A2+VcuUyK0l2ZicwNbYFUnSqKnEqd1w6nzWq+0MpsNi6Yi
	PBBu5awz39EivttwnupbZuKkISBWNGJ9g2YVVtmH5n+ueUyiIqZsVLOU2xt5O1ys
	CP+0fwTyX9lyT5oerWA5+Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujr0y1ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 16:21:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56FFovJo030360;
	Tue, 15 Jul 2025 16:20:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5a69bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 16:20:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7hbySGuA0PDibrPC1gn/mmImU18UBH+K8AegRE/kAE4aU3y17dueopv57WAHb649CgBU3VLwqzbyzuqkiAtjjk+4bs0W7ijQtm6sdaFxj58Dp9pEu+fSSEzaOwC+B6jjidSTSkTab0fFbXJtzmQAUBWC2e3kqLOlceThlXMkO94nfsoziQsp3JJn0kZXk56E4yutl2mVM6ZZ2w6EwmNRYa14rvb8wdAhdxCRix2wDNJJOt2PBAqNYsSzrNVdPFWa1unmXO4dIBh+gka45ELFClPQz5kc5gKSN/KMT6z+c97gaoyppNwPd85Qubjh1NNJ8z5L1+2s0WbAn8bykJFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbkkRCI8TNOEBOm78tCKIB+XHzesDR6d6cL6LUDI4ME=;
 b=jdcQqbPAs0Ys2lCLl6cc7nXYJpiQ/SJNgimjOJjgUTDh7OlifZUopepQAkZNiA3QpaMuLbnLyTmZYZdPizgwONgwSGQIaWQZumbHicbXwSwAO33NFQIO1JTk70JjgLDsK3UFXYU3uicgRLmFRoSuWnqri2y7KH+bCKqifFgnXe7JWWsb1uwssUOZU0iV1rAyhf5yFrbxluR44xBq4tx4Mgn39/4ry1EHBf4K+2yyrMMIJKWApf0aBaEcmr0D7I/bEVZFgDk5A+Jpl9qn1NQhdWeWgzmR1skf5A3V88UZ7Pj1xG1I8kjSxA3UJ1xjZl2obYkj5KYQaDV1ewmlFzT+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbkkRCI8TNOEBOm78tCKIB+XHzesDR6d6cL6LUDI4ME=;
 b=BOzc9DtEqpP+IXBLsMN2a8CpILjKUuyFrJuTj8F5k2689YSkP1S5qi3x8oNsmzcsMUE2Ot0sqwo4OLtaSeVV3yw4sWYhC1E7ZEe71GUt+KcuyZjc+aoMAqs6/yr8sw4hTiTrN7oCxyecGjEcdMtU0L6kklnv3DDs7aHCJwkQyJk=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Tue, 15 Jul
 2025 16:20:51 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%6]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 16:20:50 +0000
Message-ID: <3c79f888-33b6-47c3-9e08-5e594a8e8cad@oracle.com>
Date: Tue, 15 Jul 2025 21:50:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/77] 5.15.189-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250715130751.668489382@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0109.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2ad::10) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: 1db33a10-cef1-4c42-2d1e-08ddc3bb902c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0N4RW9rdVQ1OHhldjVLQW1scnFBbzczY2h0bmdPQXpHMHhXUFRhTUJ6Zncw?=
 =?utf-8?B?d2IrQldPM1R4aUZrSytEUkVIVTZSbkdVUXE3QVlJdGFJUVpqRnd5YkVITS9Q?=
 =?utf-8?B?emJtRlozTmxqcy9aOTVJbE94Z0ZkSUdOV2tLb1RuaEFRdE5nbEJYbzROS0xP?=
 =?utf-8?B?SDNLSkxIVlJyVlhlczNBbUZSL1FaeW9xS3RCR1JTbHQ0WDNTUStYOEt4aWp0?=
 =?utf-8?B?QitiQ09UWE50cHFGQmxpKzQrMGw3RUg5Rjg1L25zdTBPall0dTVsSVhmWFp4?=
 =?utf-8?B?eVZzOStSUlZLV0pKMmh2MXZhM01ONmpMODhWdGJVREowcnNFNktQd2JHckw0?=
 =?utf-8?B?QUdndE9iYlYySmVzUkg3ZDBBQXgrWGV0ZmdBRFhLdWVxa3VzaUR0R09Xd3ds?=
 =?utf-8?B?azF2a1d3dnRibng5M3Fsdi80c2ZJUGtLY2k1aWhGSnpZbTJ2WlFqblFYS3dE?=
 =?utf-8?B?enNHN2ptMXZDUjFQZGtZSyt3VnF2R0xaQ3JvLzJnS0VJWjk3TU0yMCtWYVZz?=
 =?utf-8?B?dlV6RjF3WkRaUVdpYWFyZy9CUklMd3pranVpS0FSOGtSMDg5VEUvZFcrbGNj?=
 =?utf-8?B?NDA0WU1EZEZhZlpEckVUcE9nbUhBbmlIRXBUMkt6c0NCZGtOTVVKL2VCRVZD?=
 =?utf-8?B?K09GbHRSSTl5ODNWL3lIRFRFVGhxV3hxSXR2NGlMeVI0ajBLb0FwOVJVbFo1?=
 =?utf-8?B?N2NPbTAySDdRNzduTlBmdS9BTW85T3U3VWZXeGFGZ1VNN2lnYUhjTGZiWHAr?=
 =?utf-8?B?bHo3dGlJRHRzMnd5SHdnZ0c0UmFMNXFybWM2ODdWajBvWlJqdWsvdVV3Tmpq?=
 =?utf-8?B?RjYrMzRaQ1pPYVA1YVV6OHJlQitjQ2FieDJsRGlFVktWSWN1M3g3cnJvczVx?=
 =?utf-8?B?eFBFSXo3eEVya0pCQ09ZdlVFR2xiZ2xsZmdGWTVIMDEwbCtuK2VPa0FSdllK?=
 =?utf-8?B?bmxVOGRlUGZpNXkwVm95RGIzUVlyYUdMNmRRRE9GTWxPanlTRXlWMnIzMFZI?=
 =?utf-8?B?RzJMbzJwVGYwZDJrWkUrcDJIemp4cGpwQWI1Syt6dG5ScStNUGFGVG1hQ1ZF?=
 =?utf-8?B?dXp6WjZ3cFc3YWVObWY3NXg5TnJKWWNPV2hmQUV5ZlVjSmFrODdHMTJEQkFL?=
 =?utf-8?B?SndtMW85UGVOMVFLVkxib0NpZWwyL1NNWGVaZkhqN1pVSHhjTlIwUG9pS1Zx?=
 =?utf-8?B?MXp5MnVWc0pydVJHYjBGa0VWZ1FINWlNNGZuQUNQUzBReDRNUjAvVU9JMGZC?=
 =?utf-8?B?RllQS3RtUFhWVTJwR2FyNUpuN01uQm05U1pHRDVGYUNJdmptcFJYRkxqUUdp?=
 =?utf-8?B?ZkxoSjZPUDlTTURNeHk4WGpFUm5yb1VxUXhBdzRQcmZFR29aS1JVb1VVUXNz?=
 =?utf-8?B?bjR0U1RyMEIvRUNFR1RqK3JlUnlSd3hycFNPZGt3OHYyalRHdGI5UWpBeG1W?=
 =?utf-8?B?WHR0aVBBQkJDWE1Vd3F5bHF2NTBkWng4cDdEbWJzeHpaMUYxaWRsUjMxSDNa?=
 =?utf-8?B?Zm1yOWtNYTQwdTVVSUQ1aVRNSjNmRE5sMHhJQSs0STJZcllBUU9GdURPU01w?=
 =?utf-8?B?RlVuL0NFOXdVeFA0TTdCMW9KVHF0L0dJQ3ZDcENzbW5tbkRGMEM3Nnh1ajFo?=
 =?utf-8?B?ZUJqbHkyM3VYTHo3T3BLdG14RjNzeEI3WXE1N3NnL2FrV0U5NGZmWEhtZDVP?=
 =?utf-8?B?QnZ1czJKV0hUUDZ3dzcvWGM1bjkxdWZ3RU5RSjBwaHlVa0h5NHRiczcxV1RE?=
 =?utf-8?B?UEVQNWVGZWlUTnhTTWQ4NERvdE5xMmFCQUhzd3ExOVNGakxpaERKbjU1ank4?=
 =?utf-8?B?ZnN1MkU4RzVCOUd3OWd2MTVBb2V1d0NnblYrcWZ3SkJ5NGpPc1hIdFpocVJ2?=
 =?utf-8?B?OEM4elRab2J0eHFQQjAwWXNTaFBaWFczV3dOZ0QzMXJWU0t5YzRhcUQ2V1VM?=
 =?utf-8?Q?vM+P1eQFClM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnlkU1l1bGxnS2g1U255SzlMV1kzTGtHekV5ZzVONVpWVjFrOUhCdHYzaWh0?=
 =?utf-8?B?Q05kQ25NOXpLTUFyMXA4dC9zM05NcWhqdS9RdVVWTkduOGFmM0JkUXhqb25V?=
 =?utf-8?B?c0JCdXVSU1BFaTRWYTB2c1FhbHkzbnhRbVV3dnNxbFpmU1M5SGJlUll2VUhv?=
 =?utf-8?B?Ri9KWSt3K3ZIVlhoZHdZd3FqQzJMRWVOTnd2Si9JWHFkTFV2ZmVxdUFIR3Ry?=
 =?utf-8?B?SldUT0laS2pCM3YzQXhEN0p6TWp3WStGcUVXSEhDNVhzT3JwNERUK014ZlU5?=
 =?utf-8?B?eDRQRUFyby9hUy81Skp6enUrdHM4eHRRd24rZ2JmOWRvaWlwczJoWnRqMUh3?=
 =?utf-8?B?Y1l1R2svb1NUV2RUUXhZR1MwM0RScTJicCt5bGcwcm1CbjU3OEFaZlluUHRq?=
 =?utf-8?B?RXlpL3pJM0U1bkNSTE1wSVdxcytmTTZSd1I4UXVNdU9EQ1FlcHdBWkZkNFRB?=
 =?utf-8?B?ZFdncHNHWk1LZldjdXFYR2JncUZxOEo0MGROUWhjVVAvWnhuRjY0RmxEeDYv?=
 =?utf-8?B?U2NSWnpocVZIbzBrcm01TXlWY3I2WWEvYy8vU3NSUmpPN0hMYjdzM1YvSThY?=
 =?utf-8?B?OEhBbWlsbFI0MFJiVDA5dXV0N1NoL2Rjc29nMXR1QVFnT1pTbDUvNnh6K3FJ?=
 =?utf-8?B?TmxGc2ZWUWRKZmZ6MWRHcjl4QWx0OGNqTnI1cXI3Tm1mekxtZ1poTkhwOVh6?=
 =?utf-8?B?N2QrQ0ZsbmdoS1VRSUdteGxURm5ucnI5QXZia0s2RWdBYmMyZTVKTlUzMnRY?=
 =?utf-8?B?Yi9RVHpLbHpYcHVjamp2aDFJV2IxUk5XMS9MdEgwc0RhOEZnd3hmbit1Z2Yv?=
 =?utf-8?B?eHZZSytDVHRIVnNQN3cwbThCd0UwU1dXZE5vNTJudDJBK3pOZW1lMDAwNUtI?=
 =?utf-8?B?R2JzRDZxUlF6VUFCQ1dudUdCL0ZFOWdvcUhNQ29QamlaUzlZRW1qTVZseHpI?=
 =?utf-8?B?NFJQQURBSVNDWDAwZVgyTXgrS0Z1QXozbnBFK0h2TFYzcnY0dXZHQWZEVWtS?=
 =?utf-8?B?b1d3SXUvSEoza0UwR1I0aDBSWFVTd3gxWjgxMkpkUDVVem5RTzZ1dnhFaDRK?=
 =?utf-8?B?QzNwOVdGNTRuc0NsU0l6WUw1NnJwamV4MXkyUEozTEF5YXpRclZvNWphYWlF?=
 =?utf-8?B?Z3YwbVV1bkxPeDczcTMvc3kyOHJUNXBGWG1PdzJqaDhjN0FJV202K1pGUmxI?=
 =?utf-8?B?dEp6ZUIyYUpKY2pJTVlHT2l5L2M0VlZPMURqalRaYnZTWHpkNzhOaEF3T2Rl?=
 =?utf-8?B?VW5sam53dVFkeEI2YkVrNDNyYTAzOU5sbFM3TUFQREtZMDBCM3hSR1ZMRWY1?=
 =?utf-8?B?TWViMzFpbXBXSktqeVh0aFdCblVBcGdjandxak1yYUYxOGlJTzlFdmtoODRZ?=
 =?utf-8?B?ek5tTW9nc3JaaTZlQ0l5eGRaU0RQU0xBVk1NdG9hSkUwVlIxT29uZHp3QkNz?=
 =?utf-8?B?N3JIRUR3bHZ5NDB4ejFrQkdLcHhSQVdnSmtlK1NJMllTTUpHWkROWVI3ejBD?=
 =?utf-8?B?L09mb1hmT2hySTkyYXR1cWpKdEE0LzB0Nk02MkJzcUU1MXRDcE5HaGpRSHRV?=
 =?utf-8?B?YkM5WERlUFc2dlJlUE5QQzlGV3hadkFWY3FiZi9HN3BlbVBMTThvc2tUWmlJ?=
 =?utf-8?B?V0E0N1JjeU8wOGJFSzFiMlRTMTNBOUllSzl2SVBGTWx2NDBJaURDVDFyWkZK?=
 =?utf-8?B?aHFEQjVxblNHZjhMQmEzdlp1SE52cVNkZEwxTWg1SkNNU04rRkxFQWZBTC8z?=
 =?utf-8?B?K1FDazlHbHRoK3JUeE9BKytzd1YwaFNMSnI0bkVFakliR3V5d3dLK3Q3WlBq?=
 =?utf-8?B?OU5WRC82ZVZ3R1VNUjh1YmduN0lBbmx5UzlkVG9aYisvRDQvMmpYK2lQTDRM?=
 =?utf-8?B?RGRCZCtUMW14eFJZRFVLZHk1NlZKQ0dENThRU3RmdG0reGZNVmxqeTlYKzVB?=
 =?utf-8?B?RlZqWVM4a2FnMm9DbU9rR1NFRWcxTGwrVjcrd1NOMjRmSHVtZk5LdHdEWDQz?=
 =?utf-8?B?Z1AzelAwaDMxOFE0ZmNFc2kzMTRYNEZYdUc3VzMzR1pHb2phSThJTTdoZTNC?=
 =?utf-8?B?MmV5TXZ1V0xleXZOMHI0ZXROWVBQSWRDMUViMTR6QlZHRU5tR1NnV3dCVUgy?=
 =?utf-8?B?SnN3bmh2dlhLM1lkeGtBdWFOTzV6NTJlV1B4eHBENnlpR0E4ZlhFRHhYcnNh?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0s19Xnk2tBv7IpKC0d0kTUCqTIvW44ax9qijSE9PPCAS2Apjs/2usxx9oLyf0uWjxFci9feAIYtSbmx8MihHMabp8DIL/bLokVeqTOLtEtmZhYLZoY1SCFwQNpNJm4Kb0225yQ76UsaSPQWwsZRsTGBfr2LO2CEdxbdlrIKvyRNmdP762/x2xtBGEYLaJmBxMKFKBuH2iLkpTztoElXVfExrEX6FAGXUouK4vKiNhmE49MXd3AOU5meBoY1c18RxWz4S79CG6IkPNhnrcNl8jmthr88/qeP8TpICciU6pJV0/wlRTgyl2yKEoVM41u9+h0AJB9flIJ4ykPfTFMwwNKf4WtJXGW2cq/0XiTXLs0fnxMcN5M01ogPgf6nIcpuNNIAEzKreljL+owzCZIcAzcLJx4NoTpwS/ZasF4X2daDNpRWTEUqGHZ1kGD7m3yxUHOUsPsOI7xNwr3kC0VRQ/wgRUlBqrjk8X+JnDq1sKabMgP2Uuk2jf0ppeKaOAJfdM38Ug+dUDIJnqfeAhHJyLU/LBz+bYMSFMEKajDbRGYB1G4yNJJJUAAcJYzQjmtbTgP6K1VFmPGFUzIHMRopgIJAR/NTc6BftRyA//fbV/ac=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db33a10-cef1-4c42-2d1e-08ddc3bb902c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 16:20:50.8805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CyTatsMz3V5dC2JQ2XC04jcoK5TJWkBMtb5Y3DknwWIVOdjzBkU0Rx6vNCk2YTuUMFJtpkn5PtxFLIQ46Q9ZnCAQc/lMXqMe/2z4aI3bwFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-15_04,2025-07-15_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507150150
X-Authority-Analysis: v=2.4 cv=d9T1yQjE c=1 sm=1 tr=0 ts=68767ff5 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QHUtQvI2Ve2vEipCl2YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DTkmDo24lfDHMxT-d7t1boZk_iqRTTbS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDE1MCBTYWx0ZWRfXy8f4+C3FbSmP +1rfr7fhIWaVnS/PqxojJSGU0r5S19UB3vnfRYT3FRSe6aBscLAjXNrESjKQOqku0nm2eJaBH8S /d2NSf8v7EhJilM3J0sIGZwNUr9lhgTJr001g35t66uhiZqklYwr3Zuy6g8jiQ22QKnN9Rp0qZe
 Cm2Sbod3yi8nxVprcQHQ7rxfoayZab3vwjIRByuA+HxvVfS+oU0uFY+K7X6n34O7gcfebMLGcBJ PUqSTOaoLj9Qefv/cOK0vZYNdD16vNkCT4O5EywCfhMTMsAHboT4tETlSjV1YjWvSWbQrzuPOVE IgmXWGzKmdebfcbN0x+qMsaF0cy2S34bru7uoUzIvApmZ6zEjQD6OkMUQznUTov4TivaxWPvRoU
 KW0zq5tqN/OlbLD3tiUUO8snR0OLNjgkmfJbQiuCs+L9eUbyKvDyoDDnazbhmkUlvNXVRd5z
X-Proofpoint-GUID: DTkmDo24lfDHMxT-d7t1boZk_iqRTTbS



On 15/07/25 6:42 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.189 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.


No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

