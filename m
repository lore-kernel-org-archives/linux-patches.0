Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6BE1C84C6
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 19:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739563178; cv=fail; b=MTM/TUua4nn7RYI3ecBfcm2lPtkPs8IToCCIXXkidm5W6Ii7hiGosUviHVuIf4kRfQAWhzXvTsoz+5SfDxyHsEq3qPI5DohcLhiDOk7IH4GY4GhphfUGtQ16//AXD+88qFnvx/PxvaCwquRWulqDPM3HwGQBVsWTFigEpkpsjlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739563178; c=relaxed/simple;
	bh=Uwx0UMnjKnZr9o7WHlLcdBmtN3fLWnI+sBt/xovxMXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hLpsbVXkjylFXLH3kslFUeGSc6hws/BfUyh+Uc3Lf4TWejb8Sud4Gas1UOTFhAw7VaeaNGakyADU/5E60xkbSYviWJMiv6hWc++CG2di4aXFKI3wTJrajLBUBBY+ulbKEi87PAcyCljKyR4mRZZSalFXy66YyaKHNHygHPtkR9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BtJzBknI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CNg1KgVn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BtJzBknI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CNg1KgVn"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51EGBXRU007099;
	Fri, 14 Feb 2025 19:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aLQw8ra2uRcGGq6GqQ1kyXHe5IOGh/AzwRrtzoJ1MvY=; b=
	BtJzBknI4BOGyXj9G5hVSVzPq6ljLZ2R8FSuLtb2UYmosK7yxNyAyWZ/DR+lca1h
	4AMzhEX5Upfk9v0/LTnhr0+jo87uzyuWzCsMEikHDVmk3UV0KfTR3ZUHTnRbboL0
	iyvpb01+CTw6RJP6lUUspmvG5MJomMziQWMegKPjgqaDuVRfXXIXrBsFeBnmdUt5
	P4wTWCY8qu7yPRibAOUcXXs8+frVd1BB7Lw+58GxwaQ8xrqwAJ1bdLzHxsnDY4tl
	G2we3uaHt+rr1u1l1PCjusTr0/3WxmSX8VcEby33e/UXlJXU9yVNN2gJyKJRCmEj
	eikdcJcbGyHiFjDXbSoscg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0tgch42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 19:59:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51EJRqSA014046;
	Fri, 14 Feb 2025 19:59:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqdp12c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 19:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SXidNVaOYkyXLKmju4IadAZ2I9HTchKAZ0kB5hsidkLgn9YT/XdtegzzuquveM7EUgPEadTssCWE7fkxzbi7cGPG/3iqC9BbGio5APq72Bf2vatHbRtvH5wEycMUZU4Ogr9OfhWfRqOSaXaAEylJ/o2NYFkM/TQd+E/yM6w2ZSRAC73bDSOjoc0iM2myBVC1sMr8xG+DDFEYUEW5rt9725aKwxzjqPZF0wDn1saUvO7DYF/rFUVR4+YmbepCyf1rWEy6RCl+/7MTJFWQe6/GLKZh61huaqK+5ljKpzcByrAtxv9CPrsY6Xsh+rgnUKvWt6cmsK7KulVPYvo0VyM0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLQw8ra2uRcGGq6GqQ1kyXHe5IOGh/AzwRrtzoJ1MvY=;
 b=XaWIWsAf/7S2FLr034gDvKDKG6ZlTA94Ya6Di4NF8YBhOtjb01+Z6eV+Pug0xHSMMsDU2UkFWcRFcv5dn1E/SjA/ZcY+GZqi2VCYK3xndUgotbQGjfw4qnRvW5/wuj6LqVuLCIFn5PMXbO+Ya19OV4SlP2GDjdOj6k/lf8Bc3jBgn0D0mIccADWO9jLeRBSsrZ3Wbm2tQE4K5V8hBdo9pNJmVhG88QixPdKYqHvvSHr880+cY4LaPM9/6GwN8xf9mrACW0rPZCSwqtJyOzB/9wbWubn5Tq2Wrmd3zJijZ+Jbq8floxnYetuYxvQ/RNtVxiQWXeo42m+8nkm73WFKXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLQw8ra2uRcGGq6GqQ1kyXHe5IOGh/AzwRrtzoJ1MvY=;
 b=CNg1KgVn0mYRBMAFKCf7DNp0NtRiHLBpatVSY6TkAIpQw40okRYsFgAgCNsgchc7726i3RhDOEiIgOGFru3mie6C7DzTmjN3503FlenyaErllaniK3DeIVdzr9EdBsGjX/T+Depu21YcgytMP33iZX6KOZZ5GMEYWHzMKkbsQn8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by MW5PR10MB5715.namprd10.prod.outlook.com (2603:10b6:303:19c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Fri, 14 Feb
 2025 19:59:13 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 19:59:13 +0000
Message-ID: <b1c2587f-cb80-4665-96bc-15e8137f87bb@oracle.com>
Date: Sat, 15 Feb 2025 01:29:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/419] 6.12.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250214133845.788244691@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250214133845.788244691@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::35)
 To DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|MW5PR10MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: 4da4ae7d-7bc0-4934-4c78-08dd4d320d7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VW0relNGa3YxV1VsWEwzRVdrL2RPUFNNVE1sLzYxMXVnUitQanU2S25sWWJt?=
 =?utf-8?B?cTVRc0VtQStNZXY5dzN6eUtSSEdDQVJpd0lRd2dmQ2VvUXZPcmJHRDRwWHNM?=
 =?utf-8?B?dHluemFDSEw5T3hQdXhFd1NSVEtCVU0yZkJpdUIzdnZ0NFF5b1FjNStuRkJw?=
 =?utf-8?B?dWVTcGRjcWJqeVNiZDZmOEZHTVZuM0F1c2R4RktEbkdXY1UxRkc3SkxvdXhU?=
 =?utf-8?B?K295My9IU3BTeENkRllMRGE3QjNUeG5iSzUrKzk0YXpkOFRvRU93S2RIekpv?=
 =?utf-8?B?UWl4aGtWSlE2SnlBa0kydnlHSVI0OFkzZmlxYXkzTElDWlVhTnRocmhYY3E4?=
 =?utf-8?B?LzZ1UFdFK3JqM1hEb3dFZEE2Y3ErSlNQRWdlQ2RRdTZyUFNnRGgyR3FVK29Z?=
 =?utf-8?B?S2VnM0REdEkxY0FPbmFCQ0srd2RZWEVBdCtlN0xJMENPUmRoeFFPOU5pU0lw?=
 =?utf-8?B?OFFzTlVvaU90RXZsOW5MV3NxaW9POWE3NFlTSHo4UzI1ZE5rdk9hVURFcUk5?=
 =?utf-8?B?UmNibHVVOHhUbDA4VkJiaGR5M2dUSGcxZHNLUmFJZ0FjUzdIb3lFOVZnbFNC?=
 =?utf-8?B?QXB4QXZOZ0h0R3psdk1pbEtHSzVPL0g2UUErVVRabU5iNUozSUNDTGZEK3Vo?=
 =?utf-8?B?MTlYb0czaktCUW5aWW5KRFdRa0pFZHdBa3RkY21rVVllNUUyVmUwaUJjTTJ1?=
 =?utf-8?B?TVRHbml1b2JKZkwxOHMrOWFOVkdMb2U5OS80dWJhVkQvODd6dGswWTd6UDVC?=
 =?utf-8?B?Y3JMMmFqbktWNTFBOXAxbEE4elJOSk5pdWVpaGkzOVpVdXhkS2w3dGF6UWJD?=
 =?utf-8?B?U2JibnlSQWd1SmFqQWlXblIrYXFsT2dWOVA4cmRKRlBOdVlWaTg0WjVsSXdx?=
 =?utf-8?B?U0lpV3hVVlBpTys2dEI4c2pZOUpxYk9STHBpbG9pZzBadklLUHVmUXNvK1p4?=
 =?utf-8?B?WmhJdmZ6ekM3U1RFUDBMUERhOGFoQWZwK3ZWTVFOVnlmK1JiYytUakY5ZUFp?=
 =?utf-8?B?cS9wREROVkdCREJrTEdTTFE4NEtYYjMyY0tGbkdidmF0cmEwb3g1RFMrZklL?=
 =?utf-8?B?ZUcwTTZUek1oTmVya2JtRndkTGYwVVE0clBENzNNMEl1Mmx6cWdmRktUQlN4?=
 =?utf-8?B?ZDJDdkhyVFM4MjRzT2l6WnRVQmM3QnQvemtFSUNVSHZzcDRWaUFsM3p6VGNB?=
 =?utf-8?B?R0Z4bUJnWVdDdHAvYStRMVF3QVlaRFBxZFVnZmVmOHFRdFFZVkwwRUFQYjYr?=
 =?utf-8?B?U3hwRzVjLzh5aVVjVUdyQ3BRNGJ1QU9MMTBFRUc5dzczY3JXK1NOWm00eUZ4?=
 =?utf-8?B?NEdEUmNkTmdzSjFLUTNnL0hUeGJMYm9oUkU1aVpCNWp2ekVRd3RpdS92d1FQ?=
 =?utf-8?B?NDZGdTI2SksySHloQmZnU0d2a2hFQ2psdzhXSzJ2dFY5MGM5TWt6Qm52M0pv?=
 =?utf-8?B?TDFrWFFTU0gvS3dzSFpBWUlqVVJlbnpPK1FaMFBuNUlHV1VDRS9nczQrTFB1?=
 =?utf-8?B?aWE0VUh0dUJaZHk0R3RhaUlpYUsxRzhkMVNWdjdPQzI1OEN0enprclR4cXBX?=
 =?utf-8?B?K3FCczNRWGtQRkhwWnpFMndVc2p6NkxTbEdHN0o4bW5xTWh4OVNENk5ybWtK?=
 =?utf-8?B?cFVCZ2FydlY5YzBEVGNuMk83T3E1NmN1bFRPa0U5cXdmWm5NbkJHZEhrUEc5?=
 =?utf-8?B?N0ozM1pTeitmUEhaMFFyVktMNmJlVzQ1aHNRdmhiS1VyZ1cvR0s1b0ZtNjlI?=
 =?utf-8?B?TDVXd01pb21YY1h2ZW5FMlZwbElmNGxGbzFMYmwyQnpTNkxOQVRUMFYwUzhj?=
 =?utf-8?B?NmxPWk1lbWJPUjk5VWI5M09aSzVhMUMycVRSYWJKTStrbmtMbmpEZkRyV1hJ?=
 =?utf-8?Q?e7a4wzqjwTuUx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXB0aHVoUFoyZE5PQUdMekYrMmJhUDN0Q210VkhJQW1acDFKeGNQRk9jWCsx?=
 =?utf-8?B?NnZ2TndXTHRZZCtYRUdwQ0NJNmNYdDgwZnkzZFlBOFFXMUt5d1JSNEN2dkpz?=
 =?utf-8?B?clpnSDZRdUZMTTVTRkpXMlF0Q0dNMG82aFlrMENhWU02TCszS1F6a0wzUXFq?=
 =?utf-8?B?dDhiaEFFL0dOdE9JK0NrSVMrK21sdUdiWjhSK1FKRDhCWW9RalRwYlRaNW9N?=
 =?utf-8?B?bldOS3B2NFd5VnZTRjFDUm1DRDRCQjM5cXBOaEo4Zm0zUzhad1YyOVBFVmty?=
 =?utf-8?B?RVVlcGtlbVRsUGM0dUlIRlFXRnpiM3NLOXNKaU4xUUd1ajVIQnA3ZzNnM2FM?=
 =?utf-8?B?d3RhK1ZBaHg1NEEvUDAwUERxUDI1UDRBcWFvcFFVWmRJajZaN0xDcUpVU0s5?=
 =?utf-8?B?K01SaS90c0ZGUmx4eU00WklyK0FnNGxBditLZlJlNnJEdGptNHdhUVVpdDh1?=
 =?utf-8?B?NnVUVFgvVlZobkVySEFEalpVUXZnekdDZWluY3ZScXlQQlZEWDdGRXZRdURu?=
 =?utf-8?B?UVF6c1R2RFkrNkR6TXU5ZlFHeExlR2swQXZ2cUVLdXRMaDllYmoyMlFpaUFY?=
 =?utf-8?B?b1dDMkNwS0kwcFQ5QmVycm1raUMrZDd3ZG5tOE9HUWdSTytrR0h1WkVEUERF?=
 =?utf-8?B?bGpucFpDN1lTcFhNZGJhcUZYZFNPcXFreXVtTzU5SGFCY1hTaDF2ODVlZVlk?=
 =?utf-8?B?QWhYdUVQYi9wZ0s2bHVWZzNVZ1RhY0tOZDZuVVBYV0tPSkFYamhMa1lyWEFl?=
 =?utf-8?B?dzdlZFI4dUFBUWYyaXBuaVRPYkhnd3dZczVrOHRjQUdwRzdlSS9PQmZZSmRu?=
 =?utf-8?B?QmZLUGZESmNUcmlHUDh2M1hUSXA5UkYxOGZuT25rek5MVm9KQjJ6M0hSRlJ6?=
 =?utf-8?B?cDV1ell2V3lzaktRMGtwWXR5bnFrWFlOWnNLK1cxU3RhSGZsNjJ2dFIrTmdj?=
 =?utf-8?B?enQ2QUQvMEh6V29DSWdodU1xU2hFdFB5KzJDd3pGa0FRU0xRemlHejk3VHNp?=
 =?utf-8?B?N0ExT1NGS09Pb2NDN1hNZHB4NjZHb2JiQ081dHFzUVhHSDViVDc0OXhneDhI?=
 =?utf-8?B?c1Q0QjV5ckJRa2dYVUMwSDVpM1UwSmRISlhCMjRSVzJuMmV6b2cyb0QydDc4?=
 =?utf-8?B?Zkd0REE1ZEgxRTJ5aEJBMkR6cW12czJ1MmFkYTViWlVpTCtwNU9LTEFsQlNW?=
 =?utf-8?B?WjBUNEFZbndRK2IzRDlOeWh2djRJMWxtRWZlekxxenVFT0k0Q0puM3dwd2lD?=
 =?utf-8?B?dWFTYXcxbVBuaWo4MG5TcUtUMmRKUlhOMGdCaXBHRjhmQVg5OHFqZnJkMHdQ?=
 =?utf-8?B?bEFUQlF1S1UxeDdFNCtub3dxc2kvTEQ1OGdvbDVzZjhDbGdtN1kxb204b05j?=
 =?utf-8?B?NmlmYTJPeUtxWmR0RWJ2dmZ4VnhKTnBmS0hTWXVId0p2UWUzQUtBU2ZYU2t3?=
 =?utf-8?B?ejllWXlLS3psUlZxMXBjNC9qUTBFdkR1RXdnV0h2VndwVEVaWjVvdFRHT1Rh?=
 =?utf-8?B?V3ZZTDcwdzRsdm0yOWpPQjFtY0tsUXA5QWNma2dvL1NKQXllLzBQdVBaQWVa?=
 =?utf-8?B?ZUNKVCtXR1gwOTdUR2NsUFR2OGJBTVhSS082Y1Y4Ty9hM2hheVQ4Z21vMlhy?=
 =?utf-8?B?Wk5JMDFWT1VpUFBYbDVBRk9FYWxVQ3JmSEtmM3VKa1NRdHh4cFYxVG8wS01M?=
 =?utf-8?B?eEpocVcrODVVTG11dmNEWk1LOGZlQmFEU1dPaTAvZGpPT2FiK3JhcHJ6clo3?=
 =?utf-8?B?UXdsbEdyZFNPUHNIZm44U0R6YmFxN2F2eFQ5Q0xpYkd3UEJsK3pVdldpSlJX?=
 =?utf-8?B?Nm52TGJaSEFwaWEzSW1OSzdEcUx1ZmZ2UTZrbURjKzNyMitvMmo5TWgwU243?=
 =?utf-8?B?eGViWDUrYUZPaW4wcXJUVnBNOXpnYjlQeHJyZ3hJV2huc3FtTnBBa2NpVjhr?=
 =?utf-8?B?aFpua1IrWGlIYzJJazd4dUpwYXcrV0RwOXlEWTJuNlczY0xSTytFM1hDRlZr?=
 =?utf-8?B?bUFNKytNb0tiZzVxN0ZEcjEyTjcwRUZRT1VyYm52OUJLdGtoaFp0eU9RYVdv?=
 =?utf-8?B?Wk9ZZDQrdWN4ekcydWwyS3hlWWxBcUxiUklHMWNyckJjQzdNWEJsZTJmRDY3?=
 =?utf-8?B?VGlhZTJ1dll6QS9Rcmg4NmdweUtzTFZ1S2VzM1ZPa3kvMEltMHBxUG4remt1?=
 =?utf-8?Q?U+Ik2ObQbBgdOFq1lGjasvA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yV4aHrgaLUzOxiYqNdNgMZqrL9cko7XUQLsq4Q3PBvO1iWsKFUUeXokq1OHUkSclRfbgRCgpMyHzR2MqaEZTc8Vute91A08AbGsJiQjOjAu2MciIItjUBZOBe5fBhnNT4wRi97GzAFczRKBPK8f2FGl3kLtmpiTcwux8uHDZ4JGjBdKTPuLJEyrOHWrKgO+WTyXEXbXOMBuJAKn1mkCOO9euu4X6r899grdApeBY/R1hzLs/OrI6gbU8j4WuZLXsdUt8OTdsx3ZgfrNCcH2Ne95UJMgfVAd00UKcGC9OLtUXSb34mW3tSv3n8kgoVz6QsiVcn0WjcbFB57zIIwDpP1aThELl0n5ZEq2chIierJrpAD9fhv5BySIqGs7plRq5ytCYvVnlwaqlsP0OESkiK2Kwb5/noMtXd/leH44KTHD6yYSZoCNEX35NVp7Ac8xiif51iAFVbdBLShAOrgFdPeXTIPe/y+9P/KrK0zRgo5qblyuWRLMe7ByNIZv8iOs64mW3HJvwaBilOD4iEOMGthLlPuPCP3+Cei8DQe8TPNfOoOJ1Ld8RjIF2OlaVmjcW0MGSGQ8qyE9uM1uxIzIf3Wh3g2POR4XAB9ENTWZC6J8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da4ae7d-7bc0-4934-4c78-08dd4d320d7f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 19:59:13.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +R/D45D2Lo71BaUj6B9BPuMwsuwPHoPooyNhYQd9xQfTADYD0pnUKpUgjbbD/tyIG99y0QTE35okz+ylaI1yAvyrFIrbKZxG7oH2M3YurZji7IJ6x9bnE0IVuNEdlyB4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_08,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502140137
X-Proofpoint-GUID: -6Idch20pUOBNOfFbnEESM0PrdbdeTqm
X-Proofpoint-ORIG-GUID: -6Idch20pUOBNOfFbnEESM0PrdbdeTqm

Hi Greg,

On 14/02/25 19:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 419 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
