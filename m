Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64429390992
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790973857; cv=fail; b=GqN+iGXn/uaPio2CEQk0x6VgsysAhaOpNoJpexidf1SNBDah5b/44HKoi3mipI2gGxOsCWNvRfRcdFwX0p6A21RLf5LgJIiYJJ3+tvLoNdJf8DXyBWx2Lg5IbxkpDG2h3sHm3SLIEFh5iS1Bh3HuV7hsjXMjEU9fptjPduL2J+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790973857; c=relaxed/simple;
	bh=RM8wWzUvNL/zm8J8QosdEBTdwC6A3GunJX+MKAy8eIA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NKLpgUU1O+bUNlR0zScxafldxPxbe5uUklQlVxcwnCFZ0Xvc9tqtFnJ58tWij0TKxY333k1svlCMVUfFPPml3ga5wxI/mS6kfSJgLRDKDOg2ss1i49ZJc0jUzBayblizrENcZkgApTQ76hX4D/U8fINLc38D12Puo9YkpSMqCkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JAIvTf0G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YcLGhceu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JAIvTf0G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YcLGhceu"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EbgkJ1541698;
	Fri, 2 Oct 2026 20:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Pz47dzocADPvmpBqAJ0HK9CQNHHHpUPxvZNjogPVD1w=; b=
	JAIvTf0Gv1axKS2UovIV/R+eJjKV96H7Uoh682hf6+A584qwWiBl3istKuHZ0oqu
	Tfow2DsrgD1pY3/n0jhLIP3jeimnX3fFzPflC/YGovNJBvvHHaJA//BZ9MkJrlNQ
	zh7QZ1X6Kbe7gZtiGBeACFVN1GRGWZtu1BhZ2Ht0+jGAZAplHPi3rLkeLObJ8ecH
	5KWbRLiah9itM434nX86QbQXvGt3l6ddQLcR/yvl4cd+PQDNDCG/5vEnn2B9A25U
	0ERk2eubboTsAdpT3OzMMfRiB/EV7CZym4PKRCYSHaUhm+QlGk84rALiHAWQQVk4
	09QzuL8/RGYRJDFHDxkTCA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4mymuu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 20:44:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692KZ1IV030333;
	Fri, 2 Oct 2026 20:44:05 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012016.outbound.protection.outlook.com [52.101.53.16])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h2f6frdf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 20:44:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ipj1+kGya0boaK6xKN+YjWAxnyq9Zo5sTYi1MV8dN9TeKEAhC7wY012LGegAlkZmvsmdGp+QQz1HttxT02gZPpcZMEgBJlWza2Qj1SQlPlbJIHuvGUYEJL1iSWxQiIp3EyF/BjmyF7X6ibbYs05/y+l1PdsXdCsIZjSzJjxJPJelVMnQxxLmIIVBZSw/1Nl6tG+1QQ+toOiDDv7a62HMrbET0BxA21Apeil4U7lY/bMr8SttsA7yKUSyOxlAF52Iz1IZszzwmp3uQnRkhkpSXO0yyXwFtr3DDXX8q8UFro8JwLuQxlCdSjlfNLXMcRlTtXpVR5yNj4vogmqFx1dSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pz47dzocADPvmpBqAJ0HK9CQNHHHpUPxvZNjogPVD1w=;
 b=gtxUWGapljbJ5448XJrEZI36PGLIHbO3jVdUSCWa1Fh5GWn/xAQTqMZeEfsWcshoo4fY1bA2LxpK0x2LrRY2uUsbL9KLLwAlxfpydQl6pl1cpL15dvYd7En9dGS0r6/pyG5dp5x6xG3h1dYwlVx4U9755b8SCvBwrnfdxuzkD8gvafBX6HqsAwvG47urADKIaCKR5h9MJlf5WpqoDJvMftvBZ+UZRTsdvIPVMpKGNWjou6jzvqjb0HKPkEIDW6YjTD3B0yDcS7igZCgGW1evbzNu62uD9vcCq9zcvmvCsMAHLUqlvEHep5dBabK1XU7s1ynalQMwwh/h2ZdhpwBQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz47dzocADPvmpBqAJ0HK9CQNHHHpUPxvZNjogPVD1w=;
 b=YcLGhceuxVj2eAlij3Lx3dZsl1W2bsmJN2tnoucV6hS92ilCZUwJv3c4Nf5GnZ8X3EW8eHl4abS6/nFNzunEi20f3IUVl3GXFpGpRbhKlH/YeE/9Pkazl0DG6sUHYLBg42wNCeQRoZdui8cpsiV1pbjWRy8xtsc5iLyKTml5fjE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ0PR10MB4608.namprd10.prod.outlook.com (2603:10b6:a03:2d4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Fri, 2 Oct
 2026 20:44:02 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 20:44:01 +0000
Message-ID: <53c5c2ec-4360-44d8-9be8-32419f06a4e2@oracle.com>
Date: Sat, 3 Oct 2026 02:13:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 436/877] macsec: inherit lower devices TSO limits
 when offloading
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Sabrina Dubroca <sd@queasysnail.net>, Simon Horman <horms@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152424.092713670@linuxfoundation.org>
 <230a7cd7-386c-4d64-a896-09dc32720c24@oracle.com>
 <2026100223-sprang-quake-e329@gregkh>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <2026100223-sprang-quake-e329@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0009.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ0PR10MB4608:EE_
X-MS-Office365-Filtering-Correlation-Id: bf791c8b-b5bb-4a8e-5b4a-08df20c5e3d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wgz/o8TzWdvnZF+E2H4yh9y/ZkAhmcxzU02zFcq467ROsnFpQ3hP+UQdOyk9BoQKeSthcbiVIzcD3sAu20vl7xNWBUPGDm9cQW73C8DkpmN5FT400DakjXBIv3V9L1bYakLK1GXfRm0BfDdpbPPaAKQrnqPvjZDHKnPDiudY+mg5zaWzxNNQaJ3wiJuPsSGI0c0wSneAxh5uO2Mn6YS0Ld2eCLogquNoJazjo1Ew2+IXl1xN/QncKbVtynSGIQsawc9S1rSk3753QIt4et1/p3OqtnqmgCN6UWwy5npEgyxSB5i1vjZCb5m84VYTXj5hm6kips2CEyXRUNv87LhkQx4yISW92B9Qu9q+dMWkJMUu29CBZi1ZT7klUpkeaX296JJdD4ohdg8PhpKGehrA1O1JCWsGrxqFUy1iFT0nl15j/B2TbkdUYXpiTZJQi/4yq2Z0DZbKf1KAQ3f7GpKWfMPNuTSrcB7KO3GddrwB8GuOcS9EBiuE+OjjUD+O+Hmr+Ak3hOciVudPPAvtpclbr8/hx3EiPjNJP+W6DoExZ15pcRJJVD7unnexYnyntEJszevroF16r5I/b/XkYueV1gD4oy9mGB49DLomaWrsqTUUeSSxkxdUDFYJsJSZlJ7I9rjVx2O86meGLG5/8YLmmmBGkxwMj7YwDe/00IQyXpU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3NzU2djRFc0TVUrcVlIOGlsbHpZWnVPdGhlSmtlK0M0SEllcHRjTlc4cWhK?=
 =?utf-8?B?OFBhSElHanJiTnhMRUZvVk96L0Y4WGJVVGVlTnZuZCtwN2crU1ZPaHpHc1NL?=
 =?utf-8?B?MnAyeGxkN3hQWDdsQnFSeTIya1NmKzVTMGV2b3hLUktUSzRQVXN2RllaYVAr?=
 =?utf-8?B?MjBFR0N1ekoySnBjZlJ3SitWays3Z2owVWlWcnE0YWF3ZW5FczJlOVQwQUlv?=
 =?utf-8?B?UmhwelJaQVFyM0JjQmtRZHlpMEphbWJna09JS0Q5TEVRdWtpZC8vd3lSUU1I?=
 =?utf-8?B?cU0zYXdDRzVXcU1pRjBBbUlDWDBLUjgzUUM0OUVsWThVajRFQWZYUjdKd0Nl?=
 =?utf-8?B?L0lVaG5QZ25idEs5dXNMczJrVmlXb2tHWFJKSHdsK0xkU3F1SEx5QWphRTBl?=
 =?utf-8?B?RWhyYzV5bWoyUktJaWRvdWU3WldqZk45OUdKUWp4VlFGNSs5c0FlYlpMdEs3?=
 =?utf-8?B?RlNEekFWQWdxakNhQWNyY3hqdlJ1cFBPTjdrcmxsVGtkM0R4RTlKWDRESzNp?=
 =?utf-8?B?M1dNdktjRTJXN09OQzhlODF0RFQ2WU5rclFmZzZUY0c2c0dWaU5RRzFpZUhv?=
 =?utf-8?B?S1hNOU5sWHVxb0pES0JJNXJrT2k5MzJFSlFRMUpJZ3RENHBKQ2lCRWxXUStP?=
 =?utf-8?B?NzlickVoNG83akIxRXhpQUV3N2E2cEFDbHpTK0hGZi9Kdll5cVJZaDl6TkFR?=
 =?utf-8?B?YmdQUyt2WGpoVGZ2N0NYa29MVEdLVnozaHY5WWFmK3B4T2J2eHBleDlMUmkv?=
 =?utf-8?B?cTYxb0xtQ1J2QWRERmxkU2taTXdwOWxVMzNTMXBicDQyY1FDUGJFeFEvMkIy?=
 =?utf-8?B?YkVaNHRub2p0bi9FUExJYUNaRjMrbXFNaGJzMWYrVmc2RHBzOWRXaHFjTUNP?=
 =?utf-8?B?T0dOVnRFTDNEVWdLa2w2Slpab0loa2VqOEhGNUlyV1o0WWlGeUtmNlFMTE5B?=
 =?utf-8?B?VGZTSmNFNGtvTHR0RVhVQ0RWR2hMRWlIV2FST3lFQzZhNFJSKzFoYi91cUd2?=
 =?utf-8?B?UUdGUzkvRWZUcElOZmtQalNpaWRwWUdFU0RxRkNsTVhWNTAwZ28wYkRJekZk?=
 =?utf-8?B?cUlpOTZ0blQwNVZvMHV2SGhBZWlManVmS2RzN3JRWXg0NWJsWXVxbFUrSHRW?=
 =?utf-8?B?elpyZ1NncjVZS0UxcGZPVzRCVjJ3ZXFGS3MrMGdlZUpLSDN5N3NkRG1vWlV2?=
 =?utf-8?B?NjM4SGs3TWV5TGZUNytjakdzK3p1TTVia2ppZG45cHVZY0ZNWlpXNTlDQ05T?=
 =?utf-8?B?RllySlh0RVYrSU9POWZEWjlyZEdQUkIvK0V4K2VMQ3FpVUxLMEpwd3VOQlA4?=
 =?utf-8?B?aGdMbTFqaEp6b1AwY2NVOEw1bG80b1QrbFU4WXo5QzZVeEpVODFMcHVmOUtR?=
 =?utf-8?B?WnZ1bjRyTjdTU3ZXUy9ORDJKK0d0VXVlZ2U4dUEycVJLYm5qWjREdWptdk9r?=
 =?utf-8?B?eXZTNzlQS3YxN2RpWFpKZExhVHR0bC83N0loRUlJYjZ5M1gvTjlXOXluSmsy?=
 =?utf-8?B?Wm9sM3BoTDNwT2tNcnVtOGVRWWlFM05weFIyL2NuRnpPdVFFNmdkSXhKTnpi?=
 =?utf-8?B?WjZUb1FISGpjcjYzNEsxckNPc0haN3hpVTQ1aHh1WmpPazh2eXV1Y3IvR1ox?=
 =?utf-8?B?cHRRZFU2VEpFblA2UnMyVTFpNHBTdUVxc2JIYU9rcUdna3BIemxDMjFsTUFT?=
 =?utf-8?B?bU1GbWlFUWpIZDZCNE84MS9rNm5oelFaN1BHYXFwTHNMWmJLMWpNSUZ0bm5N?=
 =?utf-8?B?SkJubUhPR0k2TkUxSm1nWit2S3dQbW5IK2h6emxvcVZnWURiYmlKbEJuZHlF?=
 =?utf-8?B?ZTdOTHc5QlFKNWxTUmRJd3J0d2d0OW90SHpJNzhaZ0tpTndUemVyZS9uYVpL?=
 =?utf-8?B?UmhZU1lkME1yZGgxeUdkWWJpbm03bmY0UDVLZlpGVnFXWlBYb1lyeERvaEFw?=
 =?utf-8?B?dGdPTlk3T3BudHBtTlJJdUJCWVQ1bk1ldXhUc1lzd0U2K2ZRdHNIWDdFVmI0?=
 =?utf-8?B?MG9SZzIvU2ZVeUFETlBYM1Fybnd6R3NjOTZrUW04a0wzUXMyS1UyUjZaZDBt?=
 =?utf-8?B?R3k1Y2ljNWZ4TW9TNVpRcDN3WkJGeUtLb3d0cmdDQ3grTHdZK1Irc0JkYmM0?=
 =?utf-8?B?YjgvVHFDcnRFdk1NMlEyUWdLRlF0b0tSOXRrTnpReHhJaHQxeHIzUjF6ZGpM?=
 =?utf-8?B?NjJCaUJFYk45b1F4WlZpU0lQTWowODdMUTVHaDNWVlZkdWVsMytUTmlCWGRK?=
 =?utf-8?B?K0l6MU9KUmxjbytwenNvNFJuR05tK1UwcHVHSHNvSDd3NzEvenZ5UTU0bGdF?=
 =?utf-8?B?cWdCQ0IrajJzSTVaRjRDUDhNQlBMbmtlTEU2bnVyWktpcGVCVVBENGVPUFF4?=
 =?utf-8?Q?JlkzRQduuw7bBM0EICl7JAtWVflxXypIS8WbG?=
X-Exchange-RoutingPolicyChecked:
	zNaJF86KpkW5wtPK5dHdQlNvNTRQ2L4m+R9jiwq8zhuCxlF7VrocWfiU9/6kH4dXEAy2A4JEdDHrrdH+EbeYIaoUUYlC19e5dmsL76hSa3ZXcHMpi7TYmV87y86NWPaM8LCFwRzDMbK5yeKOpQVfqZOd1KPQiAZQWu0K0Td4tdz3W97vX3x5NIgPHzKIkI5hlj51ESxF/erqJmPb3zQs+07aaArizpRTfAmCRcIW3lVnJDJRU2sYewfHPuagbu6tzI6JL9GGuMUj3NXwBSzHkIKIl7hTrlhNIEJ6TZe0xD1mU5/1YfQsHh5qrruqo+arJARvhfEPWcnbdGAgQkqQSg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j3PGxs7hY9C+tLjaKSrOCnP/RzZe/02DB2WnKbTUIuMQw8gpFjuAvipyiRevpQiYKqTz1EuhZ4x1Dpzf8R0Y6T5g4hCH6oAJQFhlCwCK/EBsJjQ5CCrz11eVtQEwVS5m2FhtCBLy+CSolDfBMGazPTE3MHw1nf7woYW/yKG1WqoTfrbiyCphNHOD2y79WTEPtD5CL4QD8NXApwJXysKL+uJnRk8IKOlCtvCwhc/B5DKX/a3zA/HUZO1wF21rAgUM79CZFHnLaelbqKZVk3UVTr+pewx68C6mfpn1XS+NwfG8ar+ocm5AwIfYZsXrLoZAg1YT74OFYsHJHFwgjm2KYjEV3tnDBDcdcmDLCw8+IpxxPlmShlaR+x3c3w2X3xt50XXt99Zz4PzuHtIEvStmGgeS1ycz3yrOV8sxBaZzBL1fxsj34Gac/A8odPUAPYDtQjmedpx9mz59ovzIuvNhZlA7bxyy1rqgSq5khQQCB+82NkslstyJZuZFG+IyOvUf+2zBR9obIRG3yzOARcxGNDQLvgkXLQQRHdRCHL8JsNqUxagiCq6at42h9ul0oYUu61vzw6Lwn1y4BdlKX53r35cG4nKsfKnsJw3hNRwZiBg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf791c8b-b5bb-4a8e-5b4a-08df20c5e3d0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 20:44:01.6250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmY0b8OCuDN1pinXI5t4SqXSTmvBOEOqFOLi9QuDevXrclypZOwXKW6RmiEk1TR25b/xMgP7YyQ+oIT21yIOtb0qeivALZ7HOZ3DUGd10bT6L9TbZiqyb//YCnqVSrUg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4608
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=660
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020082
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4MiBTYWx0ZWRfX8i25shfTPshG
 or4sucuE40B1/3J352PaHRU5S4veeLRUQTPCBelAe8lKUQl3XR25uIfrPBqTNfZr93uPHDyF4Cm
 r105yla+RlvoRasJjjOd6ge6ertmxQ4hvIW9X4i9yIsH48Nsvrca
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4MiBTYWx0ZWRfX/cWH4c5WcesE
 cug3vGPWMtn8GAkqa/XIU8nClBRB7QkWPLphOxi6N2ya2zImTmzEbS12fZF7Ufc7u3BHq8E1oLt
 OJRksEyjTlU2cyhfgJuVBbaglHbY9aPP7tqn7yVf1PCWEsuiFrvEMAXW/JLz1r8OewVC5OZzvOE
 soCZAJO0gfHLW6XgnWel2iLvGG/Cxu5rQQSwhjPVuSGzMT47sZ6dOQ/7NX/z6cs1zP8GVKSq8XG
 afEjea/6hdlfI6p05hQfsELeH30oIyAm43aXumeXBbl2lh7jfLGcVFfhsIRBpn4QW49G4LRfZV2
 dpdj1GLUy2IgmF5PkY+OP8m1mlB3n0QtWeW1LJnkDKlSfj9bY9ZPUoEhGHSBpt4v8QZp0dWBc9f
 K5uHbXIBqt6Gd2Uwt8ly2sva1TH0n1T1SLuecJ/fJLKFrt/JmoyCBT9pOqTdLvBQdoTXZSZha0h
 12D2tV+ZWsZKjQ7UTaw==
X-Proofpoint-GUID: zGjO8zijlXG-Muh5xzhy1pE-WDlsbCeQ
X-Authority-Analysis: v=2.4 cv=DZmCOftW c=1 sm=1 tr=0 ts=6ac01795 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=ZNEGDu-Kzpn9XkiSx0wA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: zGjO8zijlXG-Muh5xzhy1pE-WDlsbCeQ

Hi Greg,

>> 6.12.y inserts the new label inside the older MTU case's block:
>> 
>>     case NETDEV_CHANGEMTU: {
>>         struct macsec_dev *m;
>>         struct macsec_rxh_data *rxd;
>> 
>>         rxd = macsec_data_rtnl(real_dev);
>>         /* ... intervening source omitted ... */
>>         break;
>>     case NETDEV_FEAT_CHANGE:
>>         list_for_each_entry(m, &rxd->secys, secys) {
>>             macsec_inherit_tso_max(m->secy.netdev);
>>             netdev_update_features(m->secy.netdev);
>>         }
>>         break;
>>     }
>> 
>> NETDEV_FEAT_CHANGE skips the rxd assignment and dereferences an
>> uninitialized pointer. Software MACsec reaches it too, before the
>> offload check.
>> 
>> I think 6.12.y needs f29d24a2106ae28a9b257503a615ee438efa3f95 ("macsec:
>> clean up local variables in macsec_notify") before this backport,
>> thoughts?
> 
> This patch is now dropped, thanks.
> 

thanks for dealing with this and other report Greg!


Harshit

> greg k-h
> 
