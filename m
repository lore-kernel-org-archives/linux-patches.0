Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE593E6DE7
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012432; cv=fail; b=Hop3t4F2JBoabX5UuzB96MKCKo/SesZursD4nArQhpbpr7c7qIhVe5PGP9I7/SA0ruqIzrlJ+dNTjOsOl5WdA2abC0B8LkYufIq5eYUNuIQkrjWohhgLdWqoeaQjh/W0Bemqf1vXz8GDf413ylDKcUjcU7Kz8fxaVZoHJXO38us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012432; c=relaxed/simple;
	bh=Y0mIUN/bczsZ6y0oIom2b1i9puHPefZttvxeksAWf6k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jZ/VW2wnkWKOpkUYjNgKfBVIYP0KOiQ+BbV/MmJgxISXWuG/3Pe7XenWZxzvxZ+cGh03T5Z9FJ/qQ/PbdKb1rBxc/7Cvixvc6OWldPkqz2qlHvrZQGM7c1+GBApTq7a/gQQvLeyJBJRijlQDMkxOxJHBp5kdNjpRaupJvyRdt+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qrv8Ys3I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h6+aY6n6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qrv8Ys3I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h6+aY6n6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EL0xJp3369046;
	Wed, 14 Oct 2026 21:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=birMLgmH9CXRV4PDo6Cx9t4nW70L5vs48AALGi6Ew7M=; b=
	qrv8Ys3I1IqIddt+GXdUwcOe5r1yzRhRd8c0dTpfzEE1WQMffXOnETG3vzeAlG3K
	29V2MIMyYTo2twP+2UxvdqaJJ7ZFg40txabdG9cqzwEsf/3QiEXOekvzbmxQDrWW
	WT/a+ZjdBlk5HURU9mGJjZp/S9rYrShm/gy1ETiynNZr+39ZSLBzRs1KZ/K0laR4
	xvKZA+qUYOvBpb5KqDh4voA6vVIdkGKPIc9f2f592HxDjFVuL7ATeMrXhS9UT6mz
	maO8EUEVD0JbKiy46V1+sr2e8yYXb1ougjVUk1ufsqNUPwkQsuedXQoW2WvC8gun
	7LRKOSuwx947PUgllWVIZA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demq1cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:13:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69EL6mnd019183;
	Wed, 14 Oct 2026 21:13:46 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010063.outbound.protection.outlook.com [52.101.201.63])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btrcxc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:13:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nHE0/9Zv0B9nU1rS4s3PhT8axcevjlLt7CirR6ZXnmAbClyWTkNCMzteLGa0kVdS3rb3+DHPe0zwJYNw66xyRXKt6Pv6TQGpbZx7jN3huw322xcojwYLyTdJ8FreyuF84MDcCYFTDEUAtOEcDeON0+xQienYNlgxmdohnjRWihgxwAcL+VeWdHNk0vZjv9NPMkOcDIQss5XZyoVf5iDozmu4q19vFdT2qpcXh8iFDGtarFSrRD9EeMYaxrzqF25pmtUZgfX6fOI3wKEywmDJ5oMN9cCDcaoAs6LJr+e+CsmfieGKleguLMgZExYYDtABKElDofamG9fo8yBG/dJLSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=birMLgmH9CXRV4PDo6Cx9t4nW70L5vs48AALGi6Ew7M=;
 b=WIvTTuQxPzJk+yTsiv9BaoPVnJsJGid/getbpIuIjqLAIqOzZD58oZ5WcZxbeQm7KhdBPtcEMrG96fdu6XjM+yq5bfyYHmwxdRgcipfJgelwi40gmx2vQxUQWgKUfX2uFFVMxPks9AKrxmmb+9PpxxwlSfbSPudl/q/jzCspW2yeZMoHlF6aT0FShqxQknx62n9/VKv97VpSPhKAt2kRt3Ge7feQW89/BeYr0vz1/t8nDGLBynj7QU1uyksVKxx/PTzfn6/XMyfW2dZG7ki5y/9dBibe8Jeb1iDuTxGgVLmVYZbJjbrbxY8eBhufNPkJSR58M5h3bJJHia3Je0jVpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=birMLgmH9CXRV4PDo6Cx9t4nW70L5vs48AALGi6Ew7M=;
 b=h6+aY6n6UofNJAWTHo5Q78y1cmHB00740+jgf+Ui8sVvh/vag4Q7WtH5RRabkiX96cRCcBx9lBGgXQvo8ou9NmvDn9jL7CWk7I6VBzC/Uu3RKfyrdBieGymaVNC0UkRjpNBBq0hN6sbgvpI7akdjylRCz2wla7rkDQYoXGDKBiw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CC6PR10MB824513.namprd10.prod.outlook.com (2603:10b6:170:206::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:13:43 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:13:43 +0000
Message-ID: <bb8ea4fa-7edc-4eaa-9ca6-e0b3eb729295@oracle.com>
Date: Thu, 15 Oct 2026 02:43:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 264/497] net: phy: aquantia: fix system interface
 type not updated in forced mode
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112914.157376699@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112914.157376699@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0015.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::10) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CC6PR10MB824513:EE_
X-MS-Office365-Filtering-Correlation-Id: 564d6e7f-2b51-4880-2c2c-08df2a380716
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|4143699003|56012099006|5023799004|261009223027099003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	r/OcwK9MAe+DFP170GMpPAlJj2PNUElGcy0FLylQDNXyU2srZdp5YSvu539X3Vn97fYm00BkLpm4k8Wt4fYfnHKgibR0T6mW+yKZBKutbOInuRnZwPOC2H3epR/RlE8vueW/19y7dRRGuJPXuJbhYqnQt6lHuWhPvNTHo7/6CXT8sYVtFiylbGeVANluoBjT+embsa32rD1dx1Pa5t3Aq7BUyY9oVrp636Q/DqeGy4yr9iE1MeIe5OfoFEnhLmY1lomLteHqBa1ORGeT+7aHFR+QXcvTKs5Z05WckSNDhkvjkG5VrbybUmA2xVphzvNzSsRHoLlI8mQVUPHvAq6CaVt1/DF4sQtGitUkcP2Df3py0HtpVRId8GtOGxntryhCXXEeGChq4vHPaZgudmkYDdsrgPOJTITOL1W2R9nbSDYJZspwGiW6D9koMDPdGV4SYpvz46DVk1txnmEUCx4VSiuSNXaSqykzRuM+Bii9wgxsSP0nwirUSi2XkshOkhe6mbkEZQPNVLg1RJNLBf/8odr2UC1O17DgehNFWOoAmbM0KdeOOihbGceWeSy1Gl3fdg56fhQrUyfV/MGoKEeBSfps0pJGFx8qEw3/++luJFCU3s9WBbmpdnSkHE0orEcv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(4143699003)(56012099006)(5023799004)(261009223027099003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUxYanFsb0IvUXFnYlpkU0dkMXN3UW9vdjRFQ0poMFNqc2M1NXJYdUZZM2Qx?=
 =?utf-8?B?NjdCczBuSzN3YTlSaUZGbFd4Y1N5SHpMZUh4eVRGdisrcFJVZW9sTU1TZVFK?=
 =?utf-8?B?Q1ZDUlRtRGt6S1I4UEdRZ2FnZWIyNWRLWEVHTit2cExMaHZHaDNucTFmS2Z4?=
 =?utf-8?B?S0JYbWVkL281VCtEQWpXOHZIcFAvbnNsM2xxY1FUeW9IK3FQTmg4ejh4WURE?=
 =?utf-8?B?d1hKZUdzUzMyK3lWZjFWbzdKQmpkQVVXb1Z1YkpHSzhFZmdDZm8vbjY5bnZz?=
 =?utf-8?B?a3M2Qm1KTTlobytRT21SOVBCQzVLSmJ4bXFDNHZOV2NaYVFISC9LYTFlZjF4?=
 =?utf-8?B?eS83d0FZemFCYnNRTjcxOGR6MzB5dDRTZnVkajZBeis1UkVjYWtnZHhGV2Yz?=
 =?utf-8?B?VDRVWEhZZUY5amR5dmowZE13MWQ5MVRFWUpZdURCbThnanU5L0s5QUFVMUw5?=
 =?utf-8?B?VVJ5cXRDRmJETXY5NXh1cFpSR2RDNC9Hd1FaWWdmbHBnZkhMT2NQMWpaZzk3?=
 =?utf-8?B?aWJsZTNvRklHcE5jbGhTSE5NVDVxTStHUjYraVlRdUxwVTREbnZZYTFXNmFX?=
 =?utf-8?B?cDZDMFV3R084MEhadHFNNjhJeE1OaWwvaW5LL0FGL0RaREowYkFvMkZrTWli?=
 =?utf-8?B?VEZTYWNqVElCL1RkNTZWaXBuUSt3Ynl1RkliR0MxMGh2bUhUaHRlRjJoak9m?=
 =?utf-8?B?YnY2MGJDWWlhZnAvKzc1a1psOUxXeThSSzdVK1FNTzZvaWNPTmwvUFY5Zzg5?=
 =?utf-8?B?K0hQUHBtclVMRWNxUDNrMWJDUm9reVdzWG5FdXhMQUhjOHYxZitQMC9vTHU1?=
 =?utf-8?B?WllIbGI4aGlVVW42ZC9PZEptQnlyczJRcDk2eUdYQ0QrczBDY0h1NEZyTWMw?=
 =?utf-8?B?cnlqcnlVanMrMDhyK2ZzM2xMbGdoSGJkY0kyNGhFZGZFOHZLMkE1bDNRVDJi?=
 =?utf-8?B?SHJ0RUMyakRuY0t1SHJ1N1VhcG1MSHl2ZnpzUmo4Uk5sMHJYVHFFSUNDbEcx?=
 =?utf-8?B?alQ5MEd1UjJKWUVmeU1oOUN5L25VQU44YWFQMnVWeXd0RGphQ28zUzVxdGdD?=
 =?utf-8?B?Qlh4R2QrWFprbjJZNEVMZWZnalREOXlFNmN0emF0MXNlSTZ5T3VlWmZ6Zld1?=
 =?utf-8?B?R3VwaEJDY2xjS0NJT2pNcUxTeVdoQms3MTUySE45NStjdWxNNW1SQjdVRU45?=
 =?utf-8?B?TmV6NXo2ZUptcGRSeUJGYjNYLytvUEErRDREOG9EaEN6eGxLNTRBYzBVTHRC?=
 =?utf-8?B?akk2cjJsYWd2REcvRC9FNTdLd1QzaUlvZ0lodE11OURaUUVYNGVBTEpuSlpp?=
 =?utf-8?B?QWxWeFVyeEdqWEJIZ2ZtUXUySENkS1J6N1lmYUJTc2UwR2ZmVXU2M0FWcTli?=
 =?utf-8?B?Ny9ZRDRoQmhBN0s0VGxBWmh2TXU3UTJ5VDB2VGg5TlJSTjJVU3BkMS9oWlFI?=
 =?utf-8?B?OFZBU3hxTFRabmJ1N2ptN3Z5KzN2OGdBcVpGV1k1MWJBYisvQzdMdXhXN0Vq?=
 =?utf-8?B?R3FHQlliblVGYjB4WlkzU3FvTVRWTEJLUERaTGZYRlU0QWpNSjEwTTBxNUlu?=
 =?utf-8?B?MUdia0M0VHhNZVdES0JwOFZ3YWxiNzJQcStDMkdwSzJRVVpIQnhXdE9YOVhz?=
 =?utf-8?B?N3NKQTdJS0oyeTlMbWUycUdSTVlJNVhTSHcyWndTL1pJbFhrWDRpQUdlRHRP?=
 =?utf-8?B?QXB6cjRwV3NFRDcrVERFRDBXaGRBaWhlL1AvN3EzelY4MGlOZUxmSXQvNktD?=
 =?utf-8?B?RnA5M1pjRDhJNjBLRzFqSm4veUVMZS9tVkFrcUhVUWdTREpvNHF5YWNacFkv?=
 =?utf-8?B?NWhvK2cvaGY5YjYvZHcyQzd2TVhmbjBCMDNiNmFLakJrNFJJdnVIeGR3NlV5?=
 =?utf-8?B?UjFONkVNb2FrZWY4L0U0UmlRVUk5NmFYS05mWldHSDVRT05wNFFEeS83M2VQ?=
 =?utf-8?B?aksxNkc3MWlwYjJXd25uTGZkdWtQT1N3bkp6QThGMUg0c0ozOUpLaUZJYlNt?=
 =?utf-8?B?b2ZyQUVUSmpVV1UzYVE2aExRN1BrQXNiT0pnV21NWmRuV0pucE1ibkhITWkr?=
 =?utf-8?B?SGxoeFhyWnBiV2dzZTZwQW50RldPNnlxbHN5eG4wU3J4QjdFR0libUJYZzdS?=
 =?utf-8?B?bzFRWlNwMWFxSVRFMCsvWXBXaVFUMitpanZXUy9qRVVXL1ZESDE2TTUwQ3lq?=
 =?utf-8?B?aTNPZDdXcVhXRUFNRUg1bXlWWW50UUNOWE8xMmlxMnNYT1REbSt0WlNNODJF?=
 =?utf-8?B?OSs5aUFFVXlGWTJjeU0zc1B4V0VWRlQ0WU0vbmQzb1VmRUpXY3VEVUFhMEh3?=
 =?utf-8?B?ZkdZamxVQ1doZWRwMXRPdVN3RmV0TnRMam9ROTB4bTc4ZlRIeEgwdjZrNTdi?=
 =?utf-8?Q?BouBjuIFb3j9HiDyDQXCEQKgvRyUOufjTrgh/?=
X-Exchange-RoutingPolicyChecked:
	JH0hTTkfufArD0zplXM0My5ZHoCF6EMrNHzkTQjPQ76PtdO8RrLGAEW/CNtiNz8UI1gtSyv4oSEOS5hBlROKzMuruDFcRxHKv0WS0b07uNn98X2mO1JnYrhNdsp/1j9eS72sG/YlcXIhuQ0ZIDebot751cEYm+mTCD/H+w+cYYR0ZLAtXXlWIjnieUQYEJw5ZuQrOo1ToFvJNgEZThypFvRT7GUPoVvozacQby7Bz0xdbOVuvUyUUkmKtXulIaA9xtPghItgGU4pkhoQ35UePObmIm9JAw/Ns1e/nzp5YP+1es2nrMj2n57WjJh/AdZBHwLt540vEb6JNP3s7nZ9Lg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dgtaVR9ygt4EN/1GiwuLZvHA2DL009QTGTo4LrqVDwwB2zwUnCXdsT4d0khR4N+7g9lDlyYllJcUG3KUn5qJ07aQTThOKZyvKTHHB//4O9mLBhS4nbOQY/w2I7LkT+HwpoMk/2ciVaujENEExBCBhJjGl3P08GK75nHS5yj79DkZM9NjAGJ1JU9uBE9MYAmKgT5rq+hKh7FbHeOfwZfimrCVZuRDjhdxNI+dqRNcxcjI26TEVRC++M0GZrxguybj6vc+LxyLiEil2WNLkIwwW3MUmLWdZEqsWDObGCb9vrXWxZR//cqoTw7YLtP7CN7xfS4Qg6whie/h+u49w2rdIncGEONISXWY5Mo39Pg9GuV2TA9LNQvioOXKfCzv2bCX5dcIKMGz1ErT3HLCskyRpmVRRbAUfKQ8L+XmKJiu2iTBciPITZWx4c1T8KBae3UqWx1P0mBegpkyoIY3gtKyCISjJjliyrgWRGmxyorwHvcsHeRrDY7mCMLlx1siZYG9OkUizzqO5zig4rjtUJ/Lq+tQ6EBookqwH7sQm9H/UASXZQZkpdpal8CJw71bw08SgJ41iIDr2lNw1SA0uR+cmQ3HbNpgK0CUdPUFd8nQXhw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564d6e7f-2b51-4880-2c2c-08df2a380716
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:13:43.8209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VGf4qP30olKLtZM7M67nkQEzu4PevYLa0nJmi7Y0xRHcyZe/axSKJsjo6xhsAVXToU7Zv9WPonacgkLtNt9VhdTZsYX2TRZ+rj2KHPjNQc2H2KvRA0v6rpLe4lmz5jX+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CC6PR10MB824513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610140084
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acff08b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=q3caOUXEKN-v0knla4YA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-GUID: tNMjJ1o-s6RTGfaLPcT1JAX4a-nqOBQH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NCBTYWx0ZWRfX6t9iCyv96VgI
 YFclZwipIBerUgUVmYiL3omKAOKjnCwrdAZQcQVi2JLulLnw+rJZAfy/3ih+o8IRg1oV5T0S7wz
 3txTurozVQQQp43XudjrjxHzDDL29yczUmrv3cNL9UEoVE8rPwro
X-Proofpoint-ORIG-GUID: tNMjJ1o-s6RTGfaLPcT1JAX4a-nqOBQH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NCBTYWx0ZWRfX4fYuHu10C4EV
 x4r97hhMjGH1xEnxEk8lXTkfe11N++xpitRBv/08DEZ3GQ89D01nN56WZlt/qIBHAEiPrarfX1/
 aDS+bCo/KLh6fT/inNWl3z47WOIwrjla7cY7LUsOuHwljFaK/rLH7z/70k8Qto8Ny+E3D8/xJ/Y
 GCGbGXC0r2wVWlYIm2kppE28ELqh/N/B5QbleOhqKrboHvjXvI9m2u/4p5Wcx0wAa+BoCLiq1K2
 d+aneZepPdf8LZquH+yniZ7/v6O3j0D75vsKKt048bdvp63fdBMwkN/5Q6wzLA9KTv7XEHPWWW5
 MRnPRgeCvEBIBeK1YSqoVP8S+FWjX/IYktb57PqDlV+VVw37luKJIPVsrgHZpgYOAAAPh+AhOEF
 qCrIjB8G8s3ADltNX1WEnpPTLDRzWLo94xvtAaJVVVKE3LFh6XItH54CPsPlN+HO/6aoSlCsSBT
 EpS3PIL8o6Mm0HbkQygEnxEKXVxriRZPP+l12ShE=

Hi Greg/Sasha,

On 13/10/26 5:07 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> 
> [ Upstream commit 6e0022b5ae3dc5b833af0fcc1578dc20a1d6bc71 ]
> 
> aqr_gen1_read_status() decodes the MDIO_PHYXS_VEND_IF_STATUS register
> to determine which SerDes interface the PHY is currently using on its
> system side and stores the result in phydev->interface. phylink relies
> on this value to configure the MAC.
> 
> The autoneg == AUTONEG_DISABLE check is not correct:
> MDIO_PHYXS_VEND_IF_STATUS is set by the PHY firmware based on the
> negotiated link speed, not based on whether autoneg was used to reach
> it. When the link comes up at 1G in forced mode, the register correctly
> reads SGMII, but the early return prevents phydev->interface from being
> updated. It stays at whatever value it held before (typically 2500BASE-X
> from the initial autoneg run), so phylink configures the MAC for the
> wrong interface and the link cannot come up.
> 
> Remove the autoneg guard so that the system interface type is always
> decoded when the link is up.
> 
> Cc: stable@vger.kernel.org
> Fixes: 110a2432c520 ("net: phy: aquantia: add downshift support")
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Link: https://patch.msgid.link/20260923-qcom-sa8255p-emac-v15-1-e82f33720737@oss.qualcomm.com
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> [ sashal: Adapted aqr_gen1_read_status() changes to aqr107_read_status() and its direct interface-assignment switch. ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/phy/aquantia/aquantia_main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/aquantia/aquantia_main.c b/drivers/net/phy/aquantia/aquantia_main.c
> index c33a5ef34ba03..0bf54723e3a1d 100644
> --- a/drivers/net/phy/aquantia/aquantia_main.c
> +++ b/drivers/net/phy/aquantia/aquantia_main.c
> @@ -339,7 +339,7 @@ static int aqr107_read_status(struct phy_device *phydev)
>   	if (ret)
>   		return ret;
>   
> -	if (!phydev->link || phydev->autoneg == AUTONEG_DISABLE)
> +	if (!phydev->link)
>   		return 0;
>   
>   	val = phy_read_mmd(phydev, MDIO_MMD_PHYXS, MDIO_PHYXS_VEND_IF_STATUS);
> @@ -376,6 +376,9 @@ static int aqr107_read_status(struct phy_device *phydev)
>   		break;
>   	}
>   
> +	if (phydev->autoneg == AUTONEG_DISABLE)
> +		return 0;
> +

An AI-assisted review flagged missing interface-status protection in
original 6.12.113-rc1 patch 264, 916768c55093. I verified the difference
against upstream and the 6.12.y tip f4ffa8dc360b.

Downstream aqr107_read_status() reads once, then handles OFF as default:

     default:
         phydev->interface = PHY_INTERFACE_MODE_NA;
         break;
     }

     if (phydev->autoneg == AUTONEG_DISABLE)
         return 0;

Upstream aqr_gen1_read_status() polls before decoding; at 6e0022b5ae3d
and current 0fcb05b72344 it also clears link:

     case MDIO_PHYXS_VEND_IF_STATUS_TYPE_OFF:
     default:
         phydev->link = false;
         interface = PHY_INTERFACE_MODE_NA;
         break;

When line-side link is up while the system interface still reads OFF, 
downstream publishes link-up with NA; phylink can configure MAC/PCS from 
that state. The patch newly exposes forced mode to this pre-existing 
autonegotiated-mode timing defect.

7e5b547cac7a ("net: phy: aquantia: poll status register") supplies the
upstream protection. Should we backport that first ?

thanks,
Harshit>   	/* Read possibly downshifted rate from vendor register */
>   	return aqr107_read_rate(phydev);
>   }

