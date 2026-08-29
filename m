Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393EA29D291
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788033696; cv=fail; b=imGjpbB4IBvNtW2IdaBgpjuH5kvRPT1EmjByA1A2LxmYq1S8zOi26gw/pUJa2c5SRWnoiuNSHLCEjRAJ+6esoX6+2yAJuv9fTsw6mQScak6v61zb7ssk4baiERns9joJSAiOsgeQbdeRXG9LJyFbk9baV5tayTBkx1vl59RfRAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788033696; c=relaxed/simple;
	bh=6h50UUB2bFDFX0cogueZwBWYlg8pjRPGKm7DnHQWNp8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k7VE4+ty/Wf/2afe43qA+exoJTTdRIPXciPh8Krmj85dzVtC5ttAKMA0sKbsWPdXJdHu5N6Z/6ri6zGLQuy53EX3KLCgabVEqtFoa5eIFWjDRjmjIVeey7Cz283ml/zFU3i1sGmr8D7Af8Wn9tvk+z6MdP4xLWFzdikcgcFzvq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r5T0jhQA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kdnrll9d; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r5T0jhQA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kdnrll9d"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67THZmEs1280580;
	Sat, 29 Aug 2026 20:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=crv0m2pj9O66QbVYfvG3bGsG0Bivn7sbD8WO2PC2u0A=; b=
	r5T0jhQA9qj5WTSGsdsiHdVX5+LqjvS0S5ey3ySqGQVzRqX5nhdGj6OqBoK3lSa1
	Lz+oQ0V6cQq95DDB5URmwwlC2FdpIItV1bbioK/Fn3EDaINkz5tyfQT4LvsT0rQ9
	QD19nSaSh2+fKwrAeB3r+J929um8tp9Bm2IPaDJ+LPEeiVR+uBiEauBtHJXhLs0n
	bqesuyWYwkimy8HH3qpbd4S7HxVSoj/sDQY4HiicDKwKJA+PzrHKpixMq43Yusxy
	qXGVVNh9j640IrHGYZLqLe8Y8GdbVZPh8KC2jzzEkfXMurVfGc9wJacpHXO6D73X
	pwCqcUBXPbQxptmuV3haJQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqyrrhsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:01:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TJt5sp005625;
	Sat, 29 Aug 2026 20:01:30 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbfeqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:01:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UH9Q/1pHNqLcGXLoZH6M1BCsUpRnEKtNFbKcED/vmAUUYdQA/phx7VBfFcl2HOh9iWjTUo128xNsQa99uDpD09FJxEbjdmQ/YNanHHzmgbmhd0ZK7IMR5ONHjoU5MM7k894T85klYIu7ZR/m4qzlk+WLsRZ66J+5ZzD9poLUWUpMEyCCk3BAVWwuM4I+VxIdYRIrOnV56AFMnYFYEiF6m1v434VmVCBsSvRdVTjLhQXMaFKQF6+Ef95gZ9YzjBhD1fSREklfWSI4ehmEKXAtIep/6SlLBEZ7tCGy7e3H0d+BGCq1cmifDePLBJQTDasUCcBxqUdlYHRVrynd+0ux8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crv0m2pj9O66QbVYfvG3bGsG0Bivn7sbD8WO2PC2u0A=;
 b=JgGJsHD+0uxOlCf/0lFjhzuR/19R/sUJiiQ6+GGmnffIPGKAJnOJuZo2UdEok0O9PlBWAPBttGbhuXQioKbFExV3GQpuO/kpXRaoQx5BKIgp9qoi60KJwhPzV0dND2+Xs5zGUr0Ik+nVzQXpdP43ByQl6k3Cq4UmAvt7SCi74hRHgyHrrmBbUpt1tqj8wywvbxihRzgN72djfJLqSZLGmovScZ72puUZ/cQBCr6GvkFgWXIPGeTXnr5h5RZUhcp8L31/1+Gjb4bdNXaEr9XuSk8GrlJvVojW2TZd7/qnbh4o6aVyHtnUUGaTKxPg3+zsJsSAjxF06dz0N1E7mJP0Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crv0m2pj9O66QbVYfvG3bGsG0Bivn7sbD8WO2PC2u0A=;
 b=Kdnrll9dpgJs3TCNILAcrei/SRE07t93Gr45EAy6UBFYd4XtdkJBqmykSNnOKZfZB9XNVIq8hnT8Yyt8SnS/GJOns2cwjX7Z5oi3giF963hGl4GDdzrvfu3IcIrpv75NDUXIV53l6/GEiYtSTkIg11buqsScab980VoCHCrqfzw=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Sat, 29 Aug
 2026 20:01:28 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:01:28 +0000
Message-ID: <d3b0885f-30f2-4022-8790-321092db16fe@oracle.com>
Date: Sun, 30 Aug 2026 01:31:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 016/220] selinux: require every boolean value to be
 defined
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bryam Vargas <hexlabsecurity@proton.me>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Sasha Levin <sashal@kernel.org>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145223.983704802@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145223.983704802@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0550.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f62463-1cff-4394-a31a-08df06084fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|5023799004|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	n38te2MaGhh+r+dnpiQcJIMUl0Rh4jNRN8jG+GON6NYRYG+r1me7p6cuS8IcMyETZVlclZ21fF9+SP2JneVAbtdBSMAjJjFX4abY7/01RJv4P/inSXT42y9/jtDnlFcyIsHPO393d3c6xjBe8pw7MmXiGlOzmXYEKLsUF6gCDdqUsfpybCtUSCZlpWSQrzwWnooWk6PA4gqhfp3VVnu2WRO/K6f7faTLFtMjOfmlIKf9yjwpcq76vOiAOBZXXNfvk1jPGvM3DelTZVq4WGU/CUYqcAnIYRFc2ejNumi1QBlYNHCTU+6hFNO3c+aKwdmeh7yCYhVBNf/+NbGAIGaVsHyTs3Tmscvj++PpGY+Mg4hIpr19xz9IcaSG1qVDGuqIoOl2kK9yZPJ4sL0dsSagP9JY4Bc6LgkCnWgidCkCh33SkkPNjaB4JgProZUYclVHfg7X42CEHjzJq+38ZydgdHrbF/kydKlma2GM83iUG6GrXYoej+a4fvSEFLCYZV45+gyVH+rUgaRdo2ngwGkLzdepgFBmx6zdmng7QMwD6WBPMqqxXrWZDQwau7b+OEW5+8/rMXh9x3WOwA0Zu5wgbQqRf3UDlCwNE7ExqPjq05ADdPQFVJlM30V222rPFP39QvignkkALH87cmctiiBoeahLP+fQVn6Hz1CAsyIgwoY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(5023799004)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NWTWE0NEVVMk82TjF5QW9WWlhqUDRpNk5ZOGQxZkRrWmUwbVlIVjJFZnlK?=
 =?utf-8?B?bms2Q01mSXpvTFVNOTZHQVhtOTFyNUdxb2l0QytnSFd5NnpaTzRlYjRGWU5F?=
 =?utf-8?B?TThxdXZEakoybWFDVlJkckQ4eVVjTFV6ajRHZjlwSWtQNzB0R2NTR084aEp2?=
 =?utf-8?B?djgvT3d0clJia2t4OVZVVlhhTklIWlRKa21hUWtNT1NjM2lSd1FLbDkwcE1T?=
 =?utf-8?B?WXladTVWQ1dINGVvQWttQWFnakprdFRaMWIxc25JRkZQNmZhNWNUSzVERk0y?=
 =?utf-8?B?MXFnNVNBUHZqdEJQWHhUNEZjSWJmYjhrTkcrV1VhTzhYYU8yRTVzN2FkVUQ3?=
 =?utf-8?B?MThubmFPeEVpelVhdDlzNlBPZUFYeTFOQ0lRdTJaSTVsYkExOXcrZmZnYU9r?=
 =?utf-8?B?bnRYajhab2RUUkZYbmNSQS91RW04UWs2Um1nRzF1aGlucUJoOFdYMm5pbnQ5?=
 =?utf-8?B?Nklhd2VKZnNwWHNYV1c1OCtObzVnQldvY3NIWS8wTUlEWWJ3a3g1Wm1UK1VH?=
 =?utf-8?B?ZC9UVVJMSVcvTUJTQlBJVkxhN2lLNExNalg4TkFzWmpTbXlWU2phQjljdHVG?=
 =?utf-8?B?QjllbFpJZXdEUTBZaWloMDRHUnVtamg4cEY1aUFUY01wZUxsb0twWERSNHVR?=
 =?utf-8?B?anNra1QxUDRoK0QyRTJyaXI5VE1vZHdQREN0ZU9FdnMxTm11aHZvRjkvQlht?=
 =?utf-8?B?RGVzTWg1alhvbExKeEZSTVo0bENVS2xmQUhaVVRIRkJvV1hHRUJMN1pTd3l5?=
 =?utf-8?B?Sm1nSjhZSlVEc2wzYm1EQTQ2NkZwUVRVQ25XejF2S2NURVpnTUF3bnQ0MU53?=
 =?utf-8?B?b3FYOVlvNmFZWE1ZT3U5WExzM3YveEVXZkZDU01pemdKQU0vN2VQcFV4eWRa?=
 =?utf-8?B?VXBpenY2aXhFd2hvYzg0Z2xYTk41NTd3WDJrMVRqVnZEUmRwSEJaYThkazBh?=
 =?utf-8?B?WjJHTUdxT2thdUN3dUhZUXFwTWRiOENzU0RYdVRDZ21vQ0FpeWNSblpqbVpN?=
 =?utf-8?B?UHR4bmExSGFDMmM0K1JZVk9Ebk4xV0lEcDhYMi9pS1JxZjRrT2xORjBjZW9N?=
 =?utf-8?B?TzBCSmNtVkc4c0gwbktGcndDUjI5emhsa0tDcnpoZWp6MEJDQk1ZRk5pYytt?=
 =?utf-8?B?ZkJEQ2xtQUpoNUkvS3JDTVNjcTBsRVBnUjdUODZDcHI0UVF1YVdKV0UzT0lF?=
 =?utf-8?B?MlZzT25xRnIzUmQ5OHpZcm5Wa20yVUxrVnRlYVNQckVXTTFxS0N5V1g0SHpD?=
 =?utf-8?B?aHkxR3NkOTVIVUN3U1BRTU9NYnI0MkwybDNDam9PV2NuYW1ZZE04c2pLb1E5?=
 =?utf-8?B?MmJnNUpyLytVVkRaWjZWeVJZbWhaelI1d0FtMGxibGRmTU5SWWZDWUNYRWR2?=
 =?utf-8?B?NDJQTjh2ZUlodGZ5QTliZjdLUVFJTVRhZEhZS1lGRWsyM3paNXV2andlYWdw?=
 =?utf-8?B?VmdTRkg3bFhIQWhlVWp4MThtdFl4UWMvV3pGVGRqOVo2VUhZUVhZS1ZycTZv?=
 =?utf-8?B?bUlzL1RYVklrdjRHRVdQbmNFMXZ2dU1oMUJTRnZ5N24xOHoyckJqOHFNV3RH?=
 =?utf-8?B?SHlwK1lJMDdMYVBRSituRWxieHIzQU8vVUF4UGJoODhKTWdsaGVTaVEzbktv?=
 =?utf-8?B?R1lYNUtYaE1LWUpPNlRiSE1ZaHZ6ZUNKb2JPSnNSVTNzSmVRY0o5RTNSR0dk?=
 =?utf-8?B?L1ptMytQRGlUajJQT21LSi9jbnduWTdHSHNQR0JmY3lhL2tUV3NuWDBxRUpZ?=
 =?utf-8?B?NHNXK0Frc1hqUDU5NitmMXZvdjZ6SjBDMDNwT1BGa0xEdW9JZ3l0NzJNdE9L?=
 =?utf-8?B?ZEQ1cjJKbU5vcnlzQkFnajFTMXBsSGRjaGtFUnpLQVcwelh2cjEyd2tvSS9G?=
 =?utf-8?B?TTlTMU8xelRVV0Q3UWIva3d6REdFMWpuMmJLK0xZRlBGbjdRaU1lQlBMNENK?=
 =?utf-8?B?RjlqVkVsU3RUbUVCSGJRcm8rTjJ0bFVhUlQ3WjcxSjc4VFNISVRBNkM2Q3ND?=
 =?utf-8?B?ZGkxM0RCcjdvdGN2TjFLeWZnZ21oeVpNU0xYc2F0WEhtQUNmTVhTaUx1L3NM?=
 =?utf-8?B?b2J3WjBRZVJrWC8zeWh1OThWSjZSeTdkemE2N3poWkRwYS9YaE1FcGh3VHVw?=
 =?utf-8?B?a25ZMW01UGxmcXdnUUh5MWMrZDMrTTJ3Y0tyYU0xYjNxT3N4cTRheDduYlEr?=
 =?utf-8?B?ejAwamcwTTUwd0IzZURxMndPVE42VXFTWHVVMkZuazBTTEN2bXUxOHc2aXhR?=
 =?utf-8?B?STg1ZkxBTmxuV0ZQd0RpSnJRRHhWTWhRTHQzSDhOK005VFVqNCt6QUozMHJ6?=
 =?utf-8?B?cWJwcUVNTXZaQU1idmQrMTV5eHhVaE9JS3NzRFFYMTRYWW1mRGI4dGVYbllR?=
 =?utf-8?Q?OYV5/FRUwxZwIkvbxZ3uC42N94XYAphm0s9J9?=
X-Exchange-RoutingPolicyChecked:
	Bu5hrphUBUaivlmC7x4RWaDXJOO47RfPmQNhnkDGq4EsClM1+r6PHX1fyKSHfa0nZWtOiC3WOjj2PXXxlKAjUZNdjoUANllpVgKLPgs7Ll3ANB3HZHWxMTrsfzXoVFx2zyiyU+HKJYgWGSdcLxDwba+jhaJypgkL5uCLae0U3XRvOp6oc5FK5yHQENt75KnxkUbTRyOR49KZ0wX6NQwRRCVEoD8SW2VC+CZbqEzIHg/iYtUtiCft2YPEABo7SCZKhtEpe0nZhLN1ftH3i4MVD3BBaLJAXPZGbMZ54Mkx8bmd4yYj+UqTK+ZVrKWaw4aNrDHQbDdEnWKryhX+AJh7qA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8HeuiFXY8HBZba1aIeDpUn2IP3fPLarVEZYIIBNj25knOWEjdyNgmbxdDNo125wcsaZZribj8gKEEFnQM+8lxn0JQZqtwfsS2cyge/MsgB6G1Ib/Rv3B/SNLsqwJH1BumbpLogQ954axhlz3rPJeQdDbmtRlWEXwi/Cr2Rn89aiDrFn9gXHT0mcGIry888tlFFxvOXe3Ch/81NgUS7klG2j0nM9omjMkWKRZuRi6pBQFRpmtgnLnJaYIpDAMDbfMEph6wmbwxBQ+Ux0AiFLpgXoXrEZbJIJCpCoF6TkuING+M3/ic48WqdCuk35XDkzsjDEWndlSLIHH3fv9E36bdOc91bQPs3jW1t2exisBHPpI1mJxeQimZl8kHQIJyh8rbvc5lGg9erHdnR9U9xdr0UHtaRQRm5HCjKCoLSWnXxM5oRTtQ06wylElxB206xkjQkc3/uxBSy041zGUkAOH+rJuYbN6vevxvENiGikOUj+ULvmgcph91Yh/2eZqURS3WIxe9l2yr0zQ+Yth1eE4X+O56d7VJQLbnneEm+GLb9Z7kr2uU8mWNNCWFsGeB6Z6J7b+xWLJktnoTInE9CvQ3ADdYDVpR/qosqmxVN8cQRM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f62463-1cff-4394-a31a-08df06084fe1
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:01:28.0327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b52FYFScdoLdGSOtXyzt8Xd6GNNJdfANOxBamWM4dqj0il1FwNYRx2/RIa+eNb8df4AKh6T3fbtH14CMZsFIGVZ8d7gdoSUqoRhQ3TfLkJVtWS6PpbQ4otLenEgPTqda
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290173
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3MyBTYWx0ZWRfXzQp1YtfEzyHH
 qPooeOOX/AsRkI33p5rNEmPu/kz2FwO4zMA4oOq9lAW4aJ+FmJYXYKQNS2/z3Sa9VD345mUBiSw
 p1Y4SNWwFqifrIQ8YZO5Q/Ubs49XqbmYKyvvsMfiVD+KrZT7qUsvgPLpZEgk1bm06n79dsbCn77
 Ti/+DhQHp3eMpCFTBJ95dKVyTF9+kk5j6hQO1YAjaXRmcRmIcssB14CNEGcjYYKcXQi3+9xpObI
 kQRd8B7eLpSrT8DD9kBcdv/CiklvIRKDXtczcDgjLHRVzhOvbzJ6HvBmS12gHxajA9BC9Cn7gZp
 8dz5++dx2lFyiduFEnzyQJ+tEtJ8YEdgGlKNEDI9Q0MeBRZMaY78VU9BYDEBtwRdOro5ap65BdE
 nn4zknWyzSbF3OCqqVR+fWQyS9boBH67Vg0bONN+lsIIh4HDSdZE+2nV6gtizypXdW/xD5fz3Cv
 qtWmkbC4NX74u98Rphg==
X-Proofpoint-ORIG-GUID: Wrhw_rlYEO35_0ltD7i5XjiG7udcKeO4
X-Authority-Analysis: v=2.4 cv=fbCdDUQF c=1 sm=1 tr=0 ts=6a933a9b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=xVhDTqbCAAAA:8 a=ag1SF4gXAAAA:8 a=Wp1ZUwTzx6LKGvzL5w4A:9
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10 a=GrmWmAYt4dzCMttCBZOh:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: Wrhw_rlYEO35_0ltD7i5XjiG7udcKeO4
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3MyBTYWx0ZWRfXz5HQeWHp/E0+
 rcM9AUgiX/DNRtCYmgo1HjehQuaKAmKty+OMosqwwlKJr14spe70qE2hNxjeC+vuTHu2Ez0CrxM
 1y5iuQJhZsfi6ypj5ggwF+K5MrMpExhwqjURywkU2/QwKZh+pMBE

Hi Greg/Sasha,

On 20/08/26 8:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> commit a93d37a09b863810653f93d371fb197457d59deb upstream.
> 
> p_bools.nprim comes from the policy image independently of how many
> booleans follow it, and cond_index_bool() fills bool_val_to_struct[] at
> value - 1, so a count larger than the values present leaves NULL entries.
> Every user of that array then walks it by index and dereferences each
> entry: cond_evaluate_expr() on the access-vector path,
> security_get_bools() and security_get_bool_value() behind selinuxfs, and
> security_set_bools(). A sparse class value is absorbed by
> policydb_class_isvalid() and its siblings; booleans have no such
> predicate, and no consumer that could use one.
> 
> Reject a boolean value that no boolean defines, once, where the array is
> built. Conforming policies define every boolean they declare and are
> unaffected.



I ran an AI-assisted backport review and then checked 740012aebdb8 
against upstream commit a93d37a09b86 ("selinux: require every boolean 
value to be defined"). I think it is missing a required predecessor.

Upstream already had cf6a513f1937 ("selinux: switch two allocations to 
use kzalloc_objs()") and therefore has:

         p->bool_val_to_struct = kzalloc_objs(...);

6.12.y instead has:

         p->bool_val_to_struct = kmalloc_array(..., GFP_KERNEL);

cond_index_bool() writes only the slots for boolean records that are 
present. The new loop in 740012aebdb8 assumes every omitted slot remains 
NULL, but kmalloc_array() leaves those slots uninitialized. A non-NULL 
stale value can therefore evade the rejection and later be dereferenced 
by existing boolean consumers, so the fix is incomplete.

I think we should apply cf6a513f1937 maybe.

thanks,
Harshit

> 
> Cc: stable@vger.kernel.org
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   security/selinux/ss/policydb.c |   19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> --- a/security/selinux/ss/policydb.c
> +++ b/security/selinux/ss/policydb.c
> @@ -712,6 +712,7 @@ static inline void symtab_hash_eval(stru
>   static int policydb_index(struct policydb *p)
>   {
>   	int i, rc;
> +	u32 v;
>   
>   	if (p->mls_enabled)
>   		pr_debug(
> @@ -764,6 +765,24 @@ static int policydb_index(struct policyd
>   		if (rc)
>   			goto out;
>   	}
> +
> +	/*
> +	 * A sparse class value is absorbed by policydb_class_isvalid() and
> +	 * its siblings, but no such predicate exists for booleans: every
> +	 * user of bool_val_to_struct[] walks it by index and dereferences
> +	 * each entry -- cond_evaluate_expr(), the two getters and
> +	 * security_set_bools() -- so an unclaimed one has no consumer that
> +	 * can tolerate it.
> +	 */
> +	for (v = 0; v < p->p_bools.nprim; v++) {
> +		if (!p->bool_val_to_struct[v]) {
> +			pr_err("SELinux:  boolean %u is declared but not defined\n",
> +			       v + 1);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
>   	rc = 0;
>   out:
>   	return rc;
> 
> 
> 

