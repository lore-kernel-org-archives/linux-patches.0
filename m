Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4602798F8;
	Sat,  5 Sep 2026 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788632139; cv=fail; b=Ay5JpC9N5RY61d+sGMTGnr6ZAgvcdWirETWaILIKQxK09BH/QJ4h393LTOl+3Lv6flDKnYiMxUVVs1v/XufQeGgj4n7aJKG26VS71OJxzJYKsIh3S+5GwrmvGcnnNdYYBM/OPrPMds8T0iFjYqMnk6TCQhm7EwF0ID/DuAhu9MM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788632139; c=relaxed/simple;
	bh=cd8eXQd57noLLUhDDlzlV3+nRAct2MZCu3XyGfPeTt4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NU5KXTa9MQEzheQgO1PeMbT61ALulMfADkt2Y9w8sIsqopA6tyLoWe7EWW3wLvImAcxBvVbKJIHpX2JPMajAcNnlZspUeE0yzHOF0UeXcfMJEHgn2TGkq3C4C27kt8P0FNgtaVwW/R81xU7jDoOmrHpCnGJ9ki+1adl/smAruYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lKxvNcah; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WbAPVfZf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lKxvNcah";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WbAPVfZf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685I0UqP1404798;
	Sat, 5 Sep 2026 18:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FNMQkWL6Tkh+FVE8qrx6+JHvUflLsa1eWJGlpd6PkHA=; b=
	lKxvNcah0Z41zKgRahx8EqBMUgvGI/2an3aN0gm/55ULE5wBuTf5RAyXF9TkALP6
	hoJcFh7INYtgm2UZE4YT6Y94a1ytbws0SE7mGmn6mve1Hrt50IVQxQVdbjE/tovS
	yXYlzu+8QY4YQ0h5IEi73AGlac9YMnZydaC866ys41CM+OSYhO4hwzFvTE9MDOT4
	Uf9XJMYMAxQF3LYBQbaOfaiBni66ZVJyl7kMdkafaTH4WPA/D21zF8RdnCS2Nule
	9/MENVYBjXADrBDGqLjB5FWHZsZMpwUMcvjSoaYku6UpK/PzF+bM+RRXSaCmi4Uf
	YtCpjmsNWUIwQK5QRV0p2Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq8c6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 18:15:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685IFSme027641;
	Sat, 5 Sep 2026 18:15:33 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013025.outbound.protection.outlook.com [40.107.201.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hmvfqb-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 18:15:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQWx0purcYK0CN5A5EeLiTyX009l2E2elxp7LcZdUkn1iPsriWbCuVITXdNI+FdFrrK0JwTKQUDAMKk3CQ5hdlB2r2Vi2XsR3hm2N9LRx0aK5rZ2FACMU2O2ZTqGRg76iq5z5Kjgypb92WNbggnO4zjGelKbrymQz20MEQHxtQaLzPdH5doXXKMSTDxc4iTbqRM+uGnnHvz5D/Dx1Vh/HEfhz0+FHM5zO5rm07xvz4IW77VaEiOfEEdQMrvtQFyZorDnbEhFibSIKS70Uh67GcljLP0qvuA/4bCqr9lU4mulFSEqBZd3XgNNDycJ5JhRekHO9VSP7qV3QAmP6G/0MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNMQkWL6Tkh+FVE8qrx6+JHvUflLsa1eWJGlpd6PkHA=;
 b=Fvi00zUfrwvM91e30xKaTRAdNnDZAjz9J+wZjg+9JEPLiilhisJm7Lvj0ZXUEnlhP+4wvXc1jUGRes3Wqk/BS3K0clOm7zCyy3NGGBbdHlvYyW+AYuLzoymdRIXCakYGEaCXm8009W2NG0nUwzyXjrmidQTiK1VT0/TK+ubsn9zB9Lnl61JfWY/NTfIJJjqif9dVyuCGLcewbLgdli474vXlL6NohVzR4tW7ilAAxYhFfdkCf9pt7HTJVANa8TQx02EVjRiENx0Rc2v0vG1X+neWFNsP90j+qcJsfCy9aadgrqZoPjXXZ3vwIbIsfUQVjgoDRlTbW5nrUwnG4/d7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNMQkWL6Tkh+FVE8qrx6+JHvUflLsa1eWJGlpd6PkHA=;
 b=WbAPVfZf7+ufdJJd4WahCJSWJS5AKEXGzMPY2vsguJoW1ljCq5jRC6+z5/mVORNt+J9hCavgImT7g31p2E+FqA3WRI4aauUK44xtLwQYdqhO5Brhc2abtDQK0anLHZ+qvFVoPk/OePcbX92qTRHSxWzo4E+jFiV4wVRz+MZwN90=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH3PPFCA9331432.namprd10.prod.outlook.com (2603:10b6:518:1::7c6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Sat, 5 Sep 2026
 18:15:01 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 18:15:01 +0000
Message-ID: <c811e534-e196-4bef-b4c9-aa2bf80f204c@oracle.com>
Date: Sat, 5 Sep 2026 23:44:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 211/403] SUNRPC: reject duplicate CREDS_VALUE options
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Chris Mason <clm@meta.com>,
        Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045739.654582047@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045739.654582047@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0096.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b8::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH3PPFCA9331432:EE_
X-MS-Office365-Filtering-Correlation-Id: 49dd120c-aa20-463d-5934-08df0b7999e7
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Cc7tw0w9oGiGykcCoQfZkU3xSz0DBw92jALVzk2wdZdgt79nk3JfmbNJ0WUHA2YfhPL4agGPpc422mYVsPihng9pIR1TLfhNK1fDW3vZfyv7/WRwvk3DNcki+OUdePKiZ/8iX8OnBMm+SAmjH5b2Erqdu06qznMe/vBwhzea961i+HEUcCGdDh58VyvT4+a3TPfoBOfsKHIbu1i9KCIXQ3uGxriLTu5/OITp7c9oCJX6ysiFFGlvehVoudGAgSuVtlOZ8Wa6V7Xs3nSVc4TIG1ilYHHYLw3A4vA8ZYuV6EBwjHymLggdEBuVAsOiT3x2ttjxJcHTJazmGZDVFW4w3mN6BkUtSN5QgvEe+0us+tklvtmgHC0fjfgVA63I7/sygpOHhZBAPN1Vxf/Viyu+HSDqv6DkDe1Rkpp3b/VTiTIYiB54/J8fkCp7W7kQjdJZi9+ujjRYWILzZwwUdrTsp3uoBRkv/jHtA/a/jhM55okiw7BBqxyd71CxziiZ60UHusuvQMpVmGmRs0Z5APS8LWZbqLDJXpzvrc+UARtecQfa3MaddkxVkhmbNJhQ84Xm+Wk6NUa1EUKFQgZg3e3gCOV6omQsRh46Ef4PD+2AUw/s037T46dl0SDVnd1of7DN
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZFh1dGlMcFo5TkRyVnpuMkhFZGovYlBDWW5jbStXNnU2WHozdFlsZnhwZ2Fh?=
 =?utf-8?B?VFFLOGRMc3A0Rldla2pRaVpSVjdxWndxb2RpMWFqRVRLQndsMzY5bWhlcTRw?=
 =?utf-8?B?TWduMTRSakpqcTNxdlplTVNiUWhVeHR0YitiUTA0R1lNeW5abzdaWExHMHJw?=
 =?utf-8?B?OVlRMFEvTEdNbjliWGs0Wnp2Y0ZlL0F6Z21pZ0p0ZXRDYlpaaG5oYk5zUnk5?=
 =?utf-8?B?dVFuTE5FUTUzN0ljcHB3ckViWE1IWEVGNkpBMHBXM0ZUaDhCeFlxbExUdnZ3?=
 =?utf-8?B?dVgvbVVwbnpNdUN4VmJKYjdxOTh6WE0wOUN2TzB4L2tPQWxrcjcxN3RqY1B4?=
 =?utf-8?B?blhWS0FlajFyNEx1clNYeklXRWlXR01SRTFMd29iZml2SDZESEt1b1JKbzc1?=
 =?utf-8?B?T3B6bVlBdnVqRUtBVmRwcjlNTWtCNHl2ZEEzZHNVWlFUcGtNcFJTa0ZWbnJj?=
 =?utf-8?B?ZERILzBDZzdDRDM4aU5ML3l4K3dGT016VlNCaVRoclQ1NTYzV0ozVGdzRnNs?=
 =?utf-8?B?dnlzMUI0QkJJN1FHWGRHVFk0RFhWcklvSys2TzNrbWw2cjlCb0pNczBlVlFp?=
 =?utf-8?B?SUNMLzhxRjRrK1FzNEVlazE5TFhvK2F2Wng3SlFsYWxUU0lzdVEydzVLOEhR?=
 =?utf-8?B?Q0gxS2pYQklzNXBpa2pmTWVCNHVSWUZULzczenZKZXJSdFdLZ0l6OGpObTFl?=
 =?utf-8?B?RGhyRGZ1c0p3bXB6OVAzb2VyNzlyU293aDZ2RDBQQ0REcVpQaWFTUUNjZVds?=
 =?utf-8?B?OGttcVZnL3oxY1N6WUJrZ0pNVVdSZURwdkRtcU83YzRYNzM0M0ZHNVZJNkFS?=
 =?utf-8?B?TTgxMTVRd2lWVWUrRFdUdmpyL1NtZ2JiMjZPRVNnT1dtaGUwOEdZRlEvdUV6?=
 =?utf-8?B?NUpxVTcvOGpEcXdpMkVWY1FFRFhDak83WkN0dml3OGxSZHZIZjlwYWVsdld4?=
 =?utf-8?B?YzEvYkZqbVdhTjJCU3F3bWdPZGRRbWNCT1lBMGhpNTNnMXIxemlKT1pzazRq?=
 =?utf-8?B?UmYyUHVQc3hUa1JZTktWc0dzdTFXOWpJL1lQZzBjUmlNTGdXNGcyek9oTlVW?=
 =?utf-8?B?bnFkcXpRZlU3TnZ5MjQ1UEozRE5mNDZqUVZibXlzb3NKRXdwSmlVV2djbnFJ?=
 =?utf-8?B?eEU1Y3haWFdRd2prN3UyM1cvVFdmTUgyR0J3Z2lCeVVQY3g2YjR0a1ZNaVd6?=
 =?utf-8?B?enh2bUtPcHh5ZEdxVnVUd3Qvb2ZlMGxlSFdaYnh4SlhrOWdDODZvVEVZeDNa?=
 =?utf-8?B?VStQenRXT1FLclEva3ZSRFR5R2pxWUVoRFVUNTRGdHdlT3A0NWU2Vmt1U0VV?=
 =?utf-8?B?eFhJTklKcTRsWUsxcnF5TDZGZ3E1NTNsUFh2RXZxRTFNNjhCQmRPTFN4MFEy?=
 =?utf-8?B?R0l6U0ZBOU1WWXlFK0tDVVFzNWFxN2dwVU40dklucHpLSW5vaE55R3A3b1pY?=
 =?utf-8?B?Z0FNVUVHWTB5aG1CZnV3Yk83K085T3hrTFZZOFpleGQ2NVFmYzR2M0twdnlo?=
 =?utf-8?B?RVpWaW0vOWRHVmRWaDJVbjJHZFEzci93QUIzaXN3cUxmOGRobXQzMVZ4VHl3?=
 =?utf-8?B?bHRMVWcwY2VJRk8zVWhIMTFiMmp1NmY3eFVYMTQ3VlFvTkZSWmFlcHI1QmNE?=
 =?utf-8?B?NUhWY0xnaFpZcEVEd1NFdGFnMldQNmVRTUl3TTZoL05NNDNJZDJxbUFsUDB4?=
 =?utf-8?B?WGdVUHRWc1crbjg2N21GcnhiOUQ0ek5HZERlbEJkRjVQTUNOL2hVTUxlTWZa?=
 =?utf-8?B?ekowS1ZwU1Fkdkk2ME1VT3oyOW0vT3lKSjNLMk9laVN6ZlhtTWlTN05IK3B1?=
 =?utf-8?B?SlNZZFJ6K0d5ZkdRUXRpenJDYjAybDd5UDA3UCtQTndlaWFhdHd1dW83Zm4r?=
 =?utf-8?B?TVZlVU55OUxjb2JVMGJWc2U0R29renZrclA1WnVHUk55Z3c2Yng5Nld2YWtr?=
 =?utf-8?B?SXNtcmtmNEo4eGZScU1qR3h3Q3dKV1lvRExhdUllNk5mSlI0WkFsWVQ3aEho?=
 =?utf-8?B?WE8vOCtxdzJvZUlQYW5Jb1VDVUg5Sjg1bnFzV0dMTzhOb0xsNkNNNFlENTJu?=
 =?utf-8?B?RVVsK2d3djJ1b0JXREtqcUFubitFNUNGd0tzdktyQSt6Nzk5aFliV1BIUGl5?=
 =?utf-8?B?Tmw1Vm0zNFNWRTVBRHZCNWtEYmNOeEFzMENUdTRGU3RhY1dBb2cyemltckNn?=
 =?utf-8?B?N2pQODZpTUlrYWREY0tvbm1ZUUtabU1URjd2d3J6TEFsY3c3V2cyaXVCcHV2?=
 =?utf-8?B?QU5rQXVtMkJUNTVSejZGS1NIWGpYYlkzSFdZSXhlQUErVFp0U0pEL3FqMFVZ?=
 =?utf-8?B?THdBaEczR3lFRWQ4ZXRDblMyT3lCWWxmYXdVbGIzdWRsMUZldXpOVUxZdWRQ?=
 =?utf-8?Q?h8zXAk4R5McUMhUyo+FjFSgnYQgvaJq/fh4aj?=
X-Exchange-RoutingPolicyChecked:
	IquMyoE+SsmdtgAcB1E3un40+9gslChBmWTmUdtn6Qc6KFJfjBBMvXnDA+H2KICAr8xLcUh5mPCGk6FEe9fVPVEbVu595BNZgVaCj2j68jrfn7CXp/T4TDYV7EJDXUNO9SXXYhu7Wk911T1n11p+WO9dKpWfLSheGzquFxF57BPqEDOq9k5ABAW1Q9Z1Q+ghu8dj8e/CyyTQ6EO6N5hiIp87Q8SdRHDSQOPlEgzfoPXciNX5fAL1j3uqlFGeMtYIk6GBCLkvqlxFUcd3TAiNfi08zzINCozCOPF467cKGDbbfuwxoG7jtvg5A8zIRtvxE2YLs2z3NVZEEDv9QSdTOw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XIxcqZF0IG0qTP4+tqaHCGPWMM3Ud864Ko3WKqNGRHHnY/ZjwjD6t8y+NpeRp5xy40QWSH/jiki4qv0omKvIeS2KtsIRO93eHjPE/YxW4DZKwXq2nEjsVmg8pa5SnW9zsMbQOJv0/aH0rvpILa9ptmpu9Fqj7YPXBpB3zlcRV6aL6dG8ieNXIrBWqLf/yHAtu582VwK6wKyUHaEbKplsQ106bhUyBosLEz3yZcucEZKHLi7jt4Jyj3fgHrmDXqCAcGgeV/E/Mc1iImck7L9a1x5BukSKdewbxYYKGcYWDl8//FsZZrCnPiOlpCOOyEVxZGgSpWigchRIR6SLXjYOuz5ONcUZrZpq0ehX07lGt8j7DoMUVkHpx18Af3bSxEgCL/SZYBlyintKUd5SkMgyS86oc22dKyGOkdaEBEQQwhXy29M7xRrfYkEpB8DuzJISQwm6Dj6TOxs0yXS0HFaOsqBwb28cGn+yNm6ROZsMJBuf9A7tXCOhja4apo2IM9mryig9rHbUicvr5xuB6TTppUpQOG7trt0PMkTpHZjGZz3mOtJB5AOAhEWrWZUglbx0z1LK/2mSH8SdTbT1N34/ROyYbnfaI2FYYu1yRuiDhVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49dd120c-aa20-463d-5934-08df0b7999e7
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:15:01.2139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMdRnNHgEpI+AdpBBqoh671HUFDNwk+Ai12ORaoHACKBox5KCIGQ+bMEgJUsIFmHhbjQFgg7kLhgsELlaAvb9Vpy5oPJamrFbli75Ns4PCljWTwHw8CS/VqvL8a0/i2m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFCA9331432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_06,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050203
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9c5c46 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=yPCof4ZbAAAA:8 a=VabnemYjAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=8M-iTF1BEVQ7W2x7RE0A:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=gKebqoRLp9LExxC7YDUY:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIwMyBTYWx0ZWRfXzGTvb3ScqX7/
 RJUYEyyFyX4n7n3tsyBP/GYZ50N3THUVcAfRdsv6qij6MqbAL7Ix7GWUJHzsnJ4K+FvssOSzfM3
 TI0fJuCZYHKp5jm2mCZhIPy8bmj85FTTcIMMcsYxFUU4P7pthj1eoBl3Z9H6b71EMe2IdYZ+xpz
 SXMm+zzdS+XEDfNImQjZnBXjKR559fZT48dQuSTjoxcq1LLIGesW+sDeaA2qJ+dy0PajDqg6nrC
 xJ76jMJPzO1g9JyJHpd8GNnrZWanDE5IcbMxtGA7uTC/7pN41spxOkOEgzKkJwPvF7zxMWVwTx3
 hvmPXxpOoU0sj0eAwlecGLyz6QSeQrt6Xt5fq+oeyqVKTNvbHNzBppvFt987HFMN2d9G3Z/2uzu
 DSOLUChfpkU8bC7nzwXhlViYHI3v0Vv43FIS+t7KC7TffcUJwl1xJJ6PJM/iwb3heZTZMytfL/+
 E3Nm17dlWQT5vnc3QDRyvuRx7Pg58uokm0dK9JKI=
X-Proofpoint-ORIG-GUID: tEOJq_MZWEO6HfOWfgOAf9_r_b4V9Dn9
X-Proofpoint-GUID: tEOJq_MZWEO6HfOWfgOAf9_r_b4V9Dn9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIwMyBTYWx0ZWRfXzq1MW/O65Lw1
 qyIVtSATFkvstxenpa6qRyoPI76sE9ASkdxofr7G4ZcT1pVP9N5d2Gn2TLEu4gpxa8mKKWzialv
 Sm3chCeKVN/0YqF48J0EKDdK3JJusRgvxUHex3BRiyquaSkb1rr8

Hi Greg/Sasha and NFS maintainers,

On 04/09/26 10:30 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chris Mason <clm@meta.com>
> 
> commit 2e4ce62385c1b8a887c5370af058ac7b52a8eaf9 upstream.
> 
> gssx_dec_option_array() walks the wire-supplied option array and, for
> every entry whose name matches CREDS_VALUE, calls
> gssx_dec_linux_creds() on the same struct svc_cred. That helper
> unconditionally installs a fresh groups_alloc() result into
> creds->cr_group_info without releasing whatever pointer was already
> there:
> 
>      for (i = 0; i < count; i++) {
>          ... decode name ...
>          if (length == sizeof(CREDS_VALUE) &&
>              memcmp(p, CREDS_VALUE, sizeof(CREDS_VALUE)) == 0) {
>              err = gssx_dec_linux_creds(xdr, creds);
>              ...
>          }
>      }
> 
> A reply that carries two CREDS_VALUE entries therefore overwrites
> cr_group_info on the second iteration and orphans the group_info
> allocated by the first call. The earlier free_creds path only
> releases the last cr_group_info via free_svc_cred(), so the first
> allocation's refcount stays at one and its kvmalloc-backed storage
> is leaked. No in-tree caller of gssp_accept_sec_context_upcall()
> expects more than one CREDS_VALUE per reply.
> 
> Fix by tracking whether a CREDS_VALUE option has already been
> decoded and returning -EINVAL on any subsequent match, so the
> free_creds path releases the single group_info that was installed.
> 
> Fixes: 1d658336b05f ("SUNRPC: Add RPC based upcall mechanism for RPCGSS auth")
> Cc: stable@vger.kernel.org
> Assisted-by: kres (claude-opus-4-7)
> Signed-off-by: Chris Mason <clm@meta.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Link: https://patch.msgid.link/20260528-tier2-v1-3-d026a1415e0b@oracle.com
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/sunrpc/auth_gss/gss_rpc_xdr.c |    6 ++++++
>   1 file changed, 6 insertions(+)
> 
> --- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
> +++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
> @@ -230,6 +230,7 @@ static int gssx_dec_option_array(struct
>   				 struct gssx_option_array *oa)
>   {
>   	struct svc_cred *creds;
> +	bool creds_decoded = false;
>   	u32 count, i;
>   	__be32 *p;
>   	int err;
> @@ -280,9 +281,14 @@ static int gssx_dec_option_array(struct
>   		if (length == sizeof(CREDS_VALUE) &&
>   		    memcmp(p, CREDS_VALUE, sizeof(CREDS_VALUE)) == 0) {
>   			/* We have creds here. parse them */
> +			if (creds_decoded) {
> +				err = -EINVAL;
> +				goto free_creds;
> +			}

^^^


I have run an AI-assisted backport review and it spotted an issue.
I checked the finding against linux-6.12.y.

The duplicate guard in commit: a2efc80d0fb2 ("SUNRPC: reject duplicate
CREDS_VALUE options") jumps to free_creds.  In 6.12.y the following
free_oa path frees and clears oa->data but leaves oa->count at one.
gssp_accept_sec_context_upcall() then does:

     if (res.options.count == 1)
             value = &res.options.data[0].value;

This dereferences NULL after the new duplicate-error path.  The old
free_creds path also does not release a partially decoded group_info.

Upstream's direct predecessor commit: 5e9a94539b1 ("SUNRPC: fix
gssx_dec_option_array error path bugs") resets oa->count, calls
free_svc_cred(), and fixes the coupled group-info error exit.
Those cleanup changes are absent from 6.12.y.

I think 6.12.y misses commit: 5e9a94539b1 ("SUNRPC: fix
gssx_dec_option_array error path bugs").  Thoughts?

I think we should pull in a prerequisite or drop this.

Thanks,
Harshit
>   			err = gssx_dec_linux_creds(xdr, creds);
>   			if (err)
>   				goto free_creds;
> +			creds_decoded = true;
>   			oa->data[0].value.len = 1; /* presence */
>   		} else {
>   			/* consume uninteresting buffer */
> 
> 
> 

