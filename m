Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763691DFD1
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728399577; cv=fail; b=jKrNM5maL9zuPgpFSV/GlXkTDpun5qqUHlZ9v+/AIi6+DJdv7JRyYBnkS336aiZFQr4TWjeztrb9PA/1uwiTvY5NIRmOwMdtm5tZyLmRyhq2bU37/qU0SmHBcE0Px0qIIC8u6PjlqVViZVJfj/QHFs4/EbkPuPpm9f9BOnpFmfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728399577; c=relaxed/simple;
	bh=Nr7ihXaMKyg9N9U+azM76jHmiRUqNJGNpvFAcScV02w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hXNe0hOQjfcj9huEvm6jhYFpAlrQ5mOAarlGgnLm+4BV5boL8+BV4XaSR0NqoMY1nE5xzhxeMWM76NGjFndLKf7Fx9PTRtvd4M5MsX6WaIxzw7TPxXniILURgRPkiLt7qMHzCkvRYtA/TTFsMKtZ+40em2FCxt63C7lBrrxiOns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IPkEwJeg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V7tRJt8t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IPkEwJeg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V7tRJt8t"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 498Dtbvc007534;
	Tue, 8 Oct 2024 14:59:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0+I9EQaC0p/Y34/CNQNe/AjA/RCHsqxuC+NdgQRG6qc=; b=
	IPkEwJeg0L1I4Lp2DknXwPZ2a50RoKGupSc8xLCn1ixqZBeF/azqMmWQiq7H68+M
	0ri/D4z7ZsjF3JxS2jXODhXlheNF6txF9aeMkkRI5ejbr+4JK3qGZTWE7MNYj9Ad
	uMODSjDqdOJNPkWtr2QrB1fMoWuLp0M8l/eQQ1nRHm5AdcjNpOI6SYdYrgZyh6qv
	RxLXTM+38PgNdMW+aD0e+DginLG14Myx1YXCiE+Uv4O+SlIAY4+pUJroEy/Q/CAp
	07e1zfeRkmIr6j7+xl2gp41AHNxfO++abefnPgB4abqxfQT6uudpGFlNO0RlSpAJ
	nwS2iSCkPamhwgGH8TxVuQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42306ee1hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 14:59:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 498Dao4l001306;
	Tue, 8 Oct 2024 14:59:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422uw7ae39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 14:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WitI/G1SFMbSdFedpz73hYgoit4m483NhoEmncWcUYgLNfOZXbEKz/W0ncVD50hTfOFYD5OBQtfhopXs8WsWdqbCyzcDHyaNpFJ/+QOiYGBX0yyqsHKWQgEhuo/LRAnveZYnlXGWtx9VLlidRLjKzvMgsZ0mH3y9PCXDX/FILLQj/Nky1qUnKSi8j1Bid4Vfwv+m356IA7kxy22re5z4bAC+/fP7NVTock7yYnM9yil7pGgDMvU1No0Kq9SNiu4XYzZvFAO9++F/UrUg1aBjDvCTcTJMj0hGOiCuG51JF6X0ILaU/VIzhpL/B3hXL2r5+s0ShfTf4J9aZVsj5E0Pzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+I9EQaC0p/Y34/CNQNe/AjA/RCHsqxuC+NdgQRG6qc=;
 b=SfZppHMvnh0lo5+2Qx1WLh/9PkGUIOS7dL4KYFqluRHRhgfDeaFrInzckvLfEOwUIjYbiI/kFZC2mP9abf4tHgKJo+DXlK7b1oKz2N+81VDqMNPBospGmjzdFm1A2HnjHTB/q/TRY2ZIvyVkoHoF/u0AhB9n4o8VAqnC31MPoJ7OQEtcLxEYRtOULjEsXu0RSh1a6ZTWieZgE+6ewtwr6RtExZnd8Iuvn5SskAm6zzBLe1Xtuc+X8sGrCXgNQ8goyuLzQ4bq56Ap704oHHTEzQLQLXfjHw66uNwRNiFxVZEecAc4O7GfCUo79l4n7pXF8ggVkMaeOIMyMYZj+pN8fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+I9EQaC0p/Y34/CNQNe/AjA/RCHsqxuC+NdgQRG6qc=;
 b=V7tRJt8tge0Ls4QQCiXYzSenmRXFUn9086KOSnFd/nTP2mNKRRj41yFVZmyxnCF3LNSTur0xssbRl39Bf35nGbohC29Y40Rg40kjfLQYXMNTWuMKx5enMHbW+gir2sWW9QRYVDAN/rSHb+YegZO0u1YB/WIlKdK1vQpaDvs+TQg=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS0PR10MB7431.namprd10.prod.outlook.com (2603:10b6:8:15a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 14:59:10 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 14:59:10 +0000
Message-ID: <894e27c0-c1e8-476d-ae16-11ab65853d1f@oracle.com>
Date: Tue, 8 Oct 2024 20:28:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241008115629.309157387@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS0PR10MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: dffed176-d41b-4055-66b1-08dce7a9c3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGxKb1N0ckFaOHppeUJTR1kxNVBmVWozMWdkWHBJOXNVNENrQUhKYVhQLzMx?=
 =?utf-8?B?eTZ2ZnRUb0thRGlkZU9GazF2V0ZtSnVkdHltd1FPUElMNlFDQkR5TmNzU2oy?=
 =?utf-8?B?QWQwZUo0OXQ4TjlxZ013ZExQTCtZelcyZ3RFYTk4QWkzWUtjTGRjOC95SUI4?=
 =?utf-8?B?dmlkeFBnWDVOVkYrYTJMYjc0dVlNalQ0N3d2S2JXL1h5UTFHVnJlZUQxR2dn?=
 =?utf-8?B?bTFBR1k1b1pCTWdEZ05qSzNSMXloejZqT094VGpqMnpRNkc1dHpmb0xweEUw?=
 =?utf-8?B?NnZZY1lsOFNOWkRESGV5VmVTVE9hSmhUQVZQUFcyY2VWOUl6V0lZTmw3aEJw?=
 =?utf-8?B?QnlVWWhiSnVnZUZnd1ZnR3AxOHBLZEJJbklVM1JQWTd1cEFhb0NWREFtQng0?=
 =?utf-8?B?K1paSWl2Q1N1WTRYVk5aT3puZStYbHpxeldPVnI0K2pJNEtwSmN0aGd1bzZy?=
 =?utf-8?B?S2pid3ZwbmZUZ0Ywd0lZYzZ0amFWSDJYMUF5VFBDMWZjcyticjFtSXVtbzVl?=
 =?utf-8?B?empBSmt3NytldnV6VVNqT0NzOXJvRUE2SlFjaEZrb29TczV6WDJsdWF3cFFS?=
 =?utf-8?B?dWJvYlJROERjYjJTZ0JoZVV5Tno1ZXAwNjhTSHFNUWFWcXErU3k0T0ZLL2NH?=
 =?utf-8?B?dVVHQjVVTitmNFlSNmlaRTV2Njk2cWRmck93ZTZoVkdxSmJLalJUZitSeTJZ?=
 =?utf-8?B?NnFJOU1vQlZDczJQVVRmVGp0TVJET1l5bkNydVhVaHZSQ3ZJY2pkZVZrRkdZ?=
 =?utf-8?B?V1pUckJJWkF5L1AySUsrd3BYRzJ0TjNqQlhxdHllZlFRblNJaG9lV3UvbE5R?=
 =?utf-8?B?bWR4Z0hOaHByNXpYMWN1aWYxdFEvTGxPUzdncEpMaFo1TWJQbXRNdUIwS3Vq?=
 =?utf-8?B?NUg2cEEvQ0lZMnJHT0RIU0RLb3c5cVpvc1NRME02S05ZeFFhNThXbjNySE1M?=
 =?utf-8?B?R1ZJT1F0TEFhajI3azlobVBLU0V5TmJhY2dVK0NTbDlqOUdna0h2V3hLVDNm?=
 =?utf-8?B?enBvVWh2Z3ZybU5USHAzWDVUU0YzTFluSEZISFViZ0ptaEtOVWVkbEdMZkFq?=
 =?utf-8?B?NVdxenkxMGIyNnNhVUV4UmRLZDhuMHVJUU1nLzFtd29OWnc0dTgzL3R5TEZI?=
 =?utf-8?B?Yk9CbDNqWG01UE9tWUMreTR6MkkyTDFpcHJzbTNTL3RaWmVwUnFkaUtjRjBO?=
 =?utf-8?B?UGh2QmE5Zi96TlZGZU0xNGZNa2F4ci9kdlovNUhGeTZUL25zSjFIMi84TjFq?=
 =?utf-8?B?bG9tc0ttYU45ejVGWlV0ajdseVA5RGt6R2dEOVBJRnBGcTRDS0FQekJiSzZt?=
 =?utf-8?B?QTBNb3BXTVJJa3BCeWJzVlZlUnRoRlE2TGRRTFNkcnhvRGtkalR5dStnKzBr?=
 =?utf-8?B?WnpRdHVGRUVBeUpyUExPQ2xNOUFqY2JxN1A1N2hobTZJUkMrK2hnbXRDdWM5?=
 =?utf-8?B?YTRpWlJEKytyNWZPZG1ET1pFdDlOUGI5NWtaMFhEb1ZpTmZHeitxRlNoZUdB?=
 =?utf-8?B?K21BTngyd3pwdUJYL0NqaTFjdnNmYi9RNjQxdU93d01TUUlGN2h6U1ZGNHlF?=
 =?utf-8?B?cm5SY3pUeGh0OHlBbEV2L0NvS1MwaG8xRUNsbWpPTTIwV1orSis3ZTlqdTZD?=
 =?utf-8?B?V1dOOElPWWYrTmxaYit0am1YK2dHY0kwZHB2UXZWMnBuS3JNcnE4QWUwSHZu?=
 =?utf-8?B?RDVsS01vb1F3KzdBWGxRZEZSRytSYXg4M1dNdGU1OVZndDNBa1F1ODl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTBuL0pxQXFOTjE3bEgyaGV0ZER1SmVla3ZCSUQrZkpUZ0ltNmV2QjdWT1Rx?=
 =?utf-8?B?YW9YSDU5Ui95dWpNUHNPSTd6TkM3OVpUc080R0JPUUZxTXZobkJlQlZDdTBx?=
 =?utf-8?B?Nm0zcjRsZ3luVitscHhnWFlNemlGM2hoTEhEVDgvMEx0bFVpaXVnV0RldWor?=
 =?utf-8?B?Zk1GR2pKbVozMjBObDh1Rm9IcUVqck5WK2dqS3l3RERBbncwY3ZMeXJwb1hq?=
 =?utf-8?B?UU5DWUR6ak1ReW5vdUJmMmFGNWtjWGRYL2loQU1QS0hwTXFLZUxOL0tJSmFX?=
 =?utf-8?B?YzNFNjJBLzlGYkZIR09IdExmTXBRMmhvYzUza2hHbHBNc21ma2ZuOE81dHNR?=
 =?utf-8?B?K3N5V3ZDQkppTW9GeFF6Y3VGZEtWR1pRcG1kSTVwMmh0aFh2UnFoRGNnczdD?=
 =?utf-8?B?d2lhYXZxUXVheVc1SzUveXl6Q05WNFFnSlQva09IYWRnZUoyRmNoRm91eUl1?=
 =?utf-8?B?MjJvVGtTZWdNRlpBV2lwbGN0U0tpZFd1SDJXTitnOHBzZy8xSVl2ZC8wc2dj?=
 =?utf-8?B?VVJzVVkra2ZockMrMUh0a1dGUDNXeXM0N0Q0Vjl4WG9rVHlsY21zOWR5NS9H?=
 =?utf-8?B?MW9yYWJ3VTBuRjN1MDdVRUNIcjN4emswTUFSak8xM2hNYzFDSEdkbnJFZlJF?=
 =?utf-8?B?Nld3L0o3Z2JwNlFhTC81b215QThxMTE3dEdENDRlNmZRV1h3QXFBRUZmbVIz?=
 =?utf-8?B?YlRPQ2QyaHFWWi9xdDlWRTdQMDhQWU1XUjQxdXZvUFRQQzAwejVHZ0swUkJM?=
 =?utf-8?B?YWZ0djFpakRLSmk1MTVMcmZHdlAyOFo4WmZKV1JvNEpYQ04wY2xLUnYxdEMx?=
 =?utf-8?B?OTQ4SXF1Q2hjY3VyWXg2MW90TjNFbW1ZdjlQVTRPZlY4ckt6anVEV0JpeVJK?=
 =?utf-8?B?SWROUHl3aGdiTUpEUTRsWGxySmRCbnExaXFwYVRtcHl4VUVzakRHMkZGblpR?=
 =?utf-8?B?NVpod2VBSUhXZi9yRXYxMEw3dGNkVGc3enprTkM2QTJDeTZOK1NHZFNyZUlx?=
 =?utf-8?B?NGdhM1N1dzhFQ1JnQUxRcWdEc0hUNnhwWUloL2ZvMUlOUzMxRXFVZXAwOFh0?=
 =?utf-8?B?c2M0b2VDemZGOFowTThnbGVtd1JkdStja2FsUlRpSVhadFNaYVVycm15TU5Q?=
 =?utf-8?B?d1BodWI2aW96RHVWOHlFVGh2RnRpcytGTzJUNXN4WlZ6dGptamxPZXUydHRo?=
 =?utf-8?B?QnpGRGtkZ3lsZGd4L2hHOS9mY1cwTEt0eTBLdnVpTHdFV2grd0NlemxoaWhk?=
 =?utf-8?B?SFBWZlhueHZSNHArUHRmVzhBUUQvVFR1UFU0dHZabVdnNjZ3ald4OGdxLzBw?=
 =?utf-8?B?QmFlY3VZUHI0YUNwRTRaWHM3WHJEbXpYSHBHbTRIanVVMUl1Q3RLRTE2WUxM?=
 =?utf-8?B?d2dvT0dIWmIzUVlsVzJPemo1SkZSc1R2VWdVSkNYQzRzUHFMUXgxVlNmZ2d0?=
 =?utf-8?B?M1JPdDEzei8rUzRqSVVrSWFqdkNjUFFLbGdoUlFnMWNZbkNQWGh3YlcwUWRC?=
 =?utf-8?B?UDh4QThzcjczeG5QaHBUTkttTTFyN0hQYThjdDNsa29uTGxvWmNCNzBLa2gz?=
 =?utf-8?B?WHVTRDh5cUF6Qk5GWVRHWmpYUk8xTFBnNytPMmtXa3l0OUlSMlRRWnNBQ2pI?=
 =?utf-8?B?WmRMT1JYT0RSbVRjS2UzcDFpaUkxYUVJaEloYTJ1R1Fzc1RRS0lxazk5ZXN1?=
 =?utf-8?B?Zzl1ZzhjZDh5NVBNWDFKazFMS203QW9MYkpYelkrZ3RzczBod3pncjkybUph?=
 =?utf-8?B?R042azV6Z3FkaHBEOUFFUzhKKzhvY3VLZ0N1NDJvdVhoVTNFZzVkbHFNeTh2?=
 =?utf-8?B?S0t6dE5GMjUySXVaeWFESm1DVCs0MEVmRGNaREU0OUVrekpOeEpDUjBUUzBL?=
 =?utf-8?B?VENoc2pCOStJTUlkd2w3WDFwZWdRdnpwdHdJazE4THlNbzRQRWc0WHZHTkJP?=
 =?utf-8?B?N2dkSVgydkJ1N3Y5cnpSenpJV0pkWjUrKzE5dkYrVlBUQkdYWDU2cEJDZlgz?=
 =?utf-8?B?ZGhpOUpEcDhsV1BXbmNWQmtMODE4Z05ma3BWUmlGRVgwTzBBVGgrV0ltM3gr?=
 =?utf-8?B?MEIxUkdKYkpyaU1FVFlwQzd3Y3diOUZ6cG8rdnRES1pxc2wwak5FdGYrTm55?=
 =?utf-8?B?MTBvZld1MUxWOWYwUTA4WHY2ZnVtSnFoVFpXbVJEQW40dTc0VDFqOTkxK2tO?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kJvqCI2+5ko61n/iHu7mF/FXQ0WWOlS6Bi/IloyTvm6/1MfsdPGyLMY6vZWCnanjHkB7vc3xaVQ/+vkVo8gtrJU8Hw950LUxU2P0CnTx2O931lVRqX6tVITTWdwJCPKr3rkNYfAGn5Vj/RdTysw7vrFmdvHLJ3kyrIlukDPdXzdXnM5reGzDByB8a6bqiRhAQZ8Re+PXWh89XXuE03fAmTgr+MtijRDhyLpcSmz4Q+JYSRlpr6MXDWZ+xDRv1x46pQjsxJPfmCrA5sYVxjMrhsBuFcBKRkFoAIIV1JhtLFmMJEvDi34RIZgJj+gNJqmHQdeTyEZPXY3BXlFwCBGTcAyfbVrZHZOzj82s8NDbiESR79+vGxS3T30RhqSkkFa3UOmTEA3Rnalrk78HjnbMi0zZuqOZxU6WAbsPkPB9TBeQ+xuSu0g/z8RTXYwNu3zwP172q/ev6NGz+g5y1BSTbbXrCRg2xDSGEcKcN1BYSleGWmiVqUrp24C+hnIPEsRypNxnD4bATrML6hx7W0TdsIGjSa37AnQbgVezmosZUnOekiFg6d53pko/8RuqJWHrsPD7nir2C9rNr4Ko3jsEDLE10kxhS0T+ObE6ftCHdDs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffed176-d41b-4055-66b1-08dce7a9c3e9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 14:59:10.5395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9Vr5YAUwLo42FlgNwWkqwcvg6kbnu3szh8Csf55+XCGATBgRjAlG3K0cAZU6HFsDilp5zOFENQ3GHWFT2fPgBYbbdMo1L2w7wqBPUb3UaKN3rhumtfcjJWQwkj9Sqy+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7431
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_13,2024-10-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=858 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410080096
X-Proofpoint-GUID: fjdTrvk58ICxa2ovPhXGAP6oZQq3p50Z
X-Proofpoint-ORIG-GUID: fjdTrvk58ICxa2ovPhXGAP6oZQq3p50Z

Hi Greg,

On 08/10/24 17:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
...


> Ian Rogers <irogers@google.com>
>      perf callchain: Fix stitch LBR memory leaks
> 

This patch is causing build failures for tools/perf/

util/machine.c: In function 'save_lbr_cursor_node':
util/machine.c:2540:9: error: implicit declaration of function 
'map_symbol__exit'; did you mean 'symbol__exit'? 
[-Werror=implicit-function-declaration]
  2540 |         map_symbol__exit(&lbr_stitch->prev_lbr_cursor[idx].ms);
       |         ^~~~~~~~~~~~~~~~
       |         symbol__exit
...

util/thread.c: In function 'thread__free_stitch_list':
util/thread.c:481:17: error: implicit declaration of function 
'map_symbol__exit'; did you mean 'symbol__exit'? 
[-Werror=implicit-function-declaration]
   481 |                 map_symbol__exit(&pos->cursor.ms);
       |                 ^~~~~~~~~~~~~~~~
       |                 symbol__exit



Thanks,
Harshit
