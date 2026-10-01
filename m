Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C3489FDE
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 20:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790886152; cv=fail; b=pD7ZCwLdD4HFsYh1u39LrH4Vk7W9jbNv6L7wfW3Aivree454n8bzUKIK8euAObz0IPmBguM9YrWB2i/NZTIyCSBbs/hIwWs0HMLPvJiWcG4tSbq2YO4PvnIusrE0/Nl/HoktV/qdq/nKaNdPyhdSr/BjcXjwa7vy6T/9hH3977E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790886152; c=relaxed/simple;
	bh=Hv64YGY1zTqCXXGH0ewlWc+EZcB45ReaRZTO9DJ13e8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VSbL+6Urwt73fq8sHp7AioTo4s7SH24MuynykCVMDYzm7vbwdc2dzpXxRQRNAEb8AEJNEZE2wA3gK5K8h1VKqKIEFkVLXWOLqpF+JwI/S/9T8/+0AP4DyvLPwo3Q9s9/48zBgux4+T6fmfYhmwKAs3y4C1bocz7VfMcEpSkdJww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cW7fqMzq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oKzqTQHN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cW7fqMzq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oKzqTQHN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691KGI7A3360004;
	Thu, 1 Oct 2026 20:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aTwkum1exG9kmMfMYRX4qim6O1mUNWurlSH2A7F7ZIE=; b=
	cW7fqMzqorrnos+O+n/Ko/jwQvvA4UmFB/Q8S3ib/nJJuU3JhlmJJkfXHIh/+ZzY
	IVZ12obmVAwrZDwfYsxviKHlPvGNrTT3xNbG9zCrcAYdpzY4NxktRgh3ySj4k5q1
	a9vkbUkuw5OVCxBpjxwnPWkMAKPPgGR9GPKgCkofDG70pvPpDbBvchk0pysoPhXc
	Z5s4pkJurbOQThQ1J7DqMSzVpCx5+nb3a1WOejc8TNYaQUeOw8a0GUhR6+sv4n5M
	LmbLNWpPwVJORfOL+atMsUw/c+AuayEbbbhR3qV1cR+WNzjAKLo5dqNubNOAz7cU
	JFRLu67waZApFgG7+JIzuQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4myjd81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 20:22:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691KK6Ke021741;
	Thu, 1 Oct 2026 20:22:12 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4geac0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 20:22:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=keFP9zaWniSRKFMwH2vHAtLsyvHmJVgXCGi2PMwlRdQmBsxchJgB19CyPgflclgvGsIxlwU6wVxmgo1FgjjW7LX0QNeCWsEeYI6mFcLB67WpofyOAyeb/Sq9pBsMMw7X93xaOTkeppvEttzobU6bx+auXbtuXxTxQIo8PrMHH8VyWV1dLE4MpskHYgbENft8t96OCpHwtU0Go4BXEYnIfgIRUeEhcp2v+XZb4l1T+oXBf+IV6Z2iySW8hxzySCr198mQ5S2KJ1hxwUIsXcPZ+uUl6h12m+BG/UmTkfpeWT0JkEcPXQDNrkbUNdO5ciRW4t0GjCkFyMg3Ux/XHpT/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTwkum1exG9kmMfMYRX4qim6O1mUNWurlSH2A7F7ZIE=;
 b=nFAwVQXk4meOQahvAqmcR+4djKrnOhfMbIwjgWfkEY9/yBpC9bYPugFw6oS+0YMaGlxPQl5VZ9BtK9swI2qG9HEf/qpcBot8GXBk7EBfxGTw1ClCGhjMR0VClmD8d/1ew3dTBmO4ngjfpabTh+2UzVuNC9dgnnY+wdvyrFQw5jy83rQdHu9+jIi+Z3NRSlSUKmk6nHC17CjLn+54SwSnf98OyiIqLy0JqxyStiTBs5FO7tiRLf9kq1EkAqLacAu0PFiXUM8sOHeudcEyJDajYFLujh9PMMAj6pRx2KAJBntnMvU2+aH8ye1ragjZbgJ1Usbta6aTy2M4NRbhzSoviQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTwkum1exG9kmMfMYRX4qim6O1mUNWurlSH2A7F7ZIE=;
 b=oKzqTQHNfIpAo2eKwHeJV1Yr6nILBg3T8Ao7BAp/2rEf+qyalafrxElElv7eDeJBfNDXkLLbrFGfCJO0ddNxpu7JdwncyBOwHHoChRT5b9ON0gMJF6ExKZED0ac48rhKmwdEmVEuOUCeSYtXZvxBMrCuGgK9l8wqiC9gcMcxhtM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ0PR10MB5804.namprd10.prod.outlook.com (2603:10b6:a03:428::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Thu, 1 Oct 2026
 20:22:04 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 20:22:04 +0000
Message-ID: <4463bbc7-ee0e-4f92-a075-e2dd331adf30@oracle.com>
Date: Fri, 2 Oct 2026 01:51:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 554/877] xfs: drop dquot flush lock when we cant find
 a buffer to flush
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152426.598291693@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152426.598291693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0112.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b3::7) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ0PR10MB5804:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ce9556e-d1ba-434a-428f-08df1ff9a839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|56012099006|18002099003|4143699003|22082099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	piEgA2sW3Q9EiefbbPiFqswyIB/QTZaLhItRs5GhqW5tYX3hnah6S3p8MuGZkHFaVbuuScVziGD8pZ5aRNkNKQpI1MP0q9p/XMYS8Kx+tpMuCSKwP0i87z1uECXAldBZ6XSIFsCDsymB5kbWlhBxISXq/7ZNnuYNK/r/NZ2hlIkKZAw4kYxQc9LfMLfWJIdRJkc2N0ZL/KrnBOWH+sPN9ZnrjX0CCuJTfkz7F8K1uLk6F/joUAtLg3ZWvHxLrnWRjyxkpVsS0VVbBxhWhUYGDrBItwD5Hxail96PlnRttFAovT5c/RElsHDWGUyylt2ACbAqs73eKJenhFmYbHMml/l4TzA8qLIZW+Su1bjDLnTj37nJvweqXIQSVU1rqpOX+E8ZSFawYrV2W0ML+XNekZEUOTF4zaGyN7+Wie/inamZaorTHnPBMNd64R8K8VXVTp2mupvu7xmMK5z/uqYhWBzeqcKZCyUh5KNm+r/95gyvyXREpgxty4l2O9qlqxNBXNk9vBFZBKbbP2aIQpFodwlZB+WjVpDQE32FL3TJg+B6kt7VvE8G+F7N4LolJfSdP3j8y8rhoN+BnmgaB0bJ2lrO6yPJzu/B8JoKX5lnHAmMy4xyR1deqk1BYPT00EJVtKHad0EcbJEBags0gbAQvOvXKBfVFDT1UoW6YEFkHlc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(18002099003)(4143699003)(22082099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkdQRVByQmwwUFpVVVE3by9seXF6UVZDQStDMWZmVERJS2RwR1lGbXhPTWNC?=
 =?utf-8?B?WU9oSE03TS9NY3JKTjFvc253bUNmeGhqQ2hDYzdZRUNmVjdBNkdMNzVJZksv?=
 =?utf-8?B?dkpxcFF6MFJTOUFHYUE2aUU3cUQ4Nm96ZG9JU0JTMjRWZEVjOEY1NmVldWpV?=
 =?utf-8?B?aVlxVlpoV0hwNi9zdFRPQUhFdldlK04vTzRKMG1SUXpJTEh5VTBZb1JoZ0ZY?=
 =?utf-8?B?R0xQSXRwYnV1dndtTlp2NmRDVE5abVg4SkJDQ1E2RmwyUTRlZ0pjL25pV21F?=
 =?utf-8?B?TkVQUWQrR1gwSDdVZEJFaTY0UExqbGcyTTJBRmozVkNFWFZ1bkRrcjNtTkps?=
 =?utf-8?B?UGRyTU9TTU1Tai9FclhibVBtRDRDQStzYWc2ejhpWnl6dDcweU1LMW5SaURF?=
 =?utf-8?B?UkFQK2xBK3BiV0FtelA5YUVqNDJlQ1JHTVBNdFhsb1kzWHVHeXBRbHIzOS9v?=
 =?utf-8?B?dzFNNXZXTnlVaStLakVGNTJITkdUYmRPZEZ4UTd2M1I5QzRoLzBTbU5zTDBE?=
 =?utf-8?B?d1BOQUFwclRtTmlrWlcyNmV2M0JwTkNHNitraktzSWlCeTBvVjlDTzRaMDRO?=
 =?utf-8?B?V25NWVI0K01qR2ZKRWhocUdueVNid2hxbTFyaUVrakZPY21pVHY5eXRzWU9s?=
 =?utf-8?B?SS9GbEVSc2gvZmt0YngyWkI0emMwS2g4TExOeDMyZkVnc0xMR0c3WXZMeG9H?=
 =?utf-8?B?MjIvcEc3UVNPM01FMFd0QzVFOU1YTElmY1B5SzNMWFhxM1RtRTEvZDFGazd5?=
 =?utf-8?B?WTI0WVFQdmpNTnp6MFJwa25HTTE3NHY0THhuRVUvRzFERWRwM1pCQmlxN1I0?=
 =?utf-8?B?aEVkQ2dNKzNUUlVqQVp2VDlZT1FqREtkMDR3UDJWM3B3YmxYcjVveGl3dmVH?=
 =?utf-8?B?eHZ0ZDFOeFBCcUZ2K2gvU2c3NldpMjRobE8rZXordENhTHNET2hrWEN0VjF3?=
 =?utf-8?B?L2pEUFlyc0NhdlByTS9wWVVBWmZjeWdXZDJVd2FMTGxQZHdQRVNTQ1E5VFhk?=
 =?utf-8?B?RFBhNVJtTjJIM2xEazh4eWlmcU5LbnQ4aVJ5Qm1QNnNncHVsTGlBWVp6RGhu?=
 =?utf-8?B?TVcyY0lFNDUyT3VBNkRRb0llUzJPVTRJVTIwQVNFNEJTSDNhVVJyYUlOdEVN?=
 =?utf-8?B?SWVCMTZ2L3RqMXl2MXFZYWM4VkJIVktRUjlCblNpMGsxbi84WHAvVG10bm02?=
 =?utf-8?B?Y0JFTUxzZVZxQWx0eDNDWW9tNnNvRU80Qk9XU3lRalEwd1lJd3QvNE1XeG1z?=
 =?utf-8?B?Tk0yZmFkY2J6RGFoemo5cVRUZXAycHR0Z3A4d0svL3htdDNJWXNZY0dSb21l?=
 =?utf-8?B?SWZzejhaSkZQMEFSL1hMaXkzdC92VkpPcWtxUlFOeTRxbHVmbks1TTdQb0xv?=
 =?utf-8?B?L1A2K0RKcVFYcmx5dWF2ZGFuVHRYOVMwVUVFOGNhWG1aTWNMakhwOHIxbXVN?=
 =?utf-8?B?ck04QXlRM05xeXdIdXNNcHpwMWErc0J6TXYrVVViVVoyaVFtUlNQKzZuWStM?=
 =?utf-8?B?TERCenR2UUhhS1VuTTU5OWpzQzFocm5RM1dmM0Z5NjJXNXQyNGs3OWxTUGV1?=
 =?utf-8?B?cUNsaEdlZy9yRTk3dmhFUTVnMkR1NzlxaC9yTFV3VVRVMjBLbnp1K3dqQ1Jt?=
 =?utf-8?B?a2lncHJLTmdId09mWUtHVXNZdFpPeFYyZU8wYlZzNWh6STRaT0hRVjBHVmJr?=
 =?utf-8?B?Qm5xeFpGRUIyZTVlVkViWCtxdEI5NVpuVGY5WTJGeGovUVk3QzdManNlbi8y?=
 =?utf-8?B?cGtNR1JBNXU3RGlFWWg3WXlOeCtodXY2V0pkaFZQdkNITXkzSWhJeGdvTG1W?=
 =?utf-8?B?Qm5HS2FGTEphQ2RIR0l5SHhjQXpVd2JTUDdXSm13UHRJOGkyS2dIaWpUSnZG?=
 =?utf-8?B?YVNYNkw1RmE5cnJHdnVNbjF3Zm9IamNUM09PYXhqdk5BbHh2VDR1WDMvNkhS?=
 =?utf-8?B?SE5DaVFhRTRUWnl6eVd3RFNEU24vdlRxMDBUbVVzNy9oS0t0TnpOZ28wTURy?=
 =?utf-8?B?enFwY1lYb3ZNUWljZThGbFVzdkZhbHNOQ3lRdnVFbW83dHNZb25qL0QwLy9z?=
 =?utf-8?B?RVlmbnc2eitmM2tCWGhadGNOOE01UGw2a0xPQ0NIOE5EZGRtV0FmbXBQak9V?=
 =?utf-8?B?aWYyUG4xUlp6VTQ5eDBaclNFZ3JXVi9tck1GYS9IdTJKNlExZ0F4a0JHRndW?=
 =?utf-8?B?OHVNcXdCVi9sMWVaVzZYYlIyVEZYSnkxWVUxeHdWeWhwb0JjdkVCMWlNNTdM?=
 =?utf-8?B?ZVJaVFBDR1BGbnRScEJKZzkrUGY1Y001OWY2MXN5TnlmcTdLbjdmdlNlMCtr?=
 =?utf-8?B?Q0NNUkQrZXkzRkI2aUJSSTN2Ykg4SHFmREtBWUhkY2hxdEdZUmpqTXBIRysx?=
 =?utf-8?Q?3HpKhhYu+ZmeAL67Jvy4gIytzIfOoLservIYh?=
X-Exchange-RoutingPolicyChecked:
	1IyrBqikzRzeVUzxU4QDswUoqmlHcC5SHNONE+p0RzBGd66T5MnBGcpl2iJEHSkOXN0wlyaz7NdYMylmKNFvP0O4Qti9ZpUOA3CPtO6FMJjYaZCplH9XXe1Mb55pz9oN0bHL8WcH3zhYsmEzL+yeU4mX9b6q+0LUxx0BRz8SOVRNlZSq0EfyzIs7ZkTZGsXymuYMjvD5Bvv9yxV1UhPcPylFgls2x+ZYA+SwbiadwlOuf2Yr83zcej27YGRSboJvZ4ilwWuudM2qeiH1V7H604diQ8CtHZre9h9MiPsrBXqGqIagA+xG3YQOB3dWfX6zO4A8uCT/DIjRTO0wnbFRAw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jwLpmCZRM8FV7p0US8fYLkN+juWU88Ci4jfTpFP4Vn3eEJkBe5RAJOS8ttkSWNhkla9KJGDc3l+ucELjN0sAmx2/Uj2GrOBjS7IlF0PBfClBvm8jQc0EhbuYQ5VSFsQo+KQyhRLNvyUVxppVnH1FAmfwX7bunSlYJqMrTv7D7TDN/eyP7AQP1NbaWk73H4dXS+G3HDcP3kshrOjncfHTamsUbg2qU4zK+AJrmBErEYwlC01Qq4CQMI3FIaJ97qHcRWtIHoayBWaShtLRQRL9638Ge30yh/PAwO0DyBdwBIejvmP60SbMf4wufrQ3EdNKyXholDROxy5cMve/J4xr4wmH61Ay4IqGr70Vh57lJOM2LI7LYJyM2cDqCfSVfkLQV9L2+O6Z9zqFKClCX9W+cg6TZCxh13EcqdWfOfSESstLPrl0FGMOE4gy1E6XVTPvr58pN90CzFcr5lHudV/8kI7CHomc+u4kbPFdUwZNbvPrbYek5hRhL7QwRZ+6EjCSbK/czQ+9T6z5jswrrvM+y/T2AsBqfopjzVs4Lfv1c06qho7rymoo+oQqsTfgftWeFr928keg4hRoCUTnQE5m9N1z4migTBjWcDVrsKRN4TQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce9556e-d1ba-434a-428f-08df1ff9a839
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 20:22:04.1177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNgM5RWnNlt5ulOyGi6dFtopPQeQFz9wwWeBxlOefx1hntbXNUR5kdMjM3pKEnISgBkWTbIU8ASi2BeK6m9WGCPJrU4rpA25Ly9fdZ9M8Z5q6bRnIxgLUUc5+ZYkHpMN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5804
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=646 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010081
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA4MSBTYWx0ZWRfX92yyQt2+Um+F
 TZBNo+40yBZA/D2ZDL0dDfMHkxvsK5c0pafA5brLdoaRuCWBzBs4+OobBJYMxcLk7nPFubGhunn
 15/lQkkffT9LISoohZxiaiigA5Jpktq1ETsKQUAVGT2uUFCgHxgf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA4MSBTYWx0ZWRfXxM6Ndw+PaF/C
 WY9DvKE9ZFi5xcaZNf1kcQ5qhaOV47znsWk/xW0N4NH/xVhDPZlF8Jac/oufvtNSJ/QTBjKwTXS
 pjphW8AEwmczq2+BPeQZJqbNvksRFPZO3MPJN0ofGamvn2iHasG7y8kA3E6nxPmgDj96z2mxB0p
 fmyuXw9iVFeub5g8Ch767XFG2YXyxMGjAdcUzhovuN12BtoTPCh7sWlwPVn34qCjF0NOPttHvy3
 /4084ZFrHQL/zXeEEx9afb/WwmIpCZkkBoNBkfTGX43k850X4kz+53D+WMP4+inGWsGy2BiqIV0
 xNik7C5Dr8xuWYf8AGZRZd1m+yv5s82Z4vsF8VXjhkMNvR4fkfcJLXFrjd0StzHFB8/6Dc9S2dz
 hptnWyURiRjavLrGiQLUQJFRePou+nKeEabLLcqELCiIgtP5uEAE9mJX3CgerOZMj7TnJd6B2ru
 0/sgNTS1X3Q/nmCxNrw==
X-Proofpoint-GUID: Usdsl31zxj__0rNEZWH-iOTssgsGQWfv
X-Authority-Analysis: v=2.4 cv=DZmCOftW c=1 sm=1 tr=0 ts=6abec0f4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=ag1SF4gXAAAA:8 a=swPTbqNdEWaCXBsSusIA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: Usdsl31zxj__0rNEZWH-iOTssgsGQWfv



On 30/09/26 8:54 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Darrick J. Wong <djwong@kernel.org>
> 
> commit ffb48dccce1960a9ea24463a2f3c21d124d6b672 upstream.
> 
> LOLLM noticed that xfs_qm_flush_one fails to drop the dquot flush lock
> if it can't grab the buffer associated with the dquot.  Since there's no
> buffer, nobody else is going to drop the dqflock, so we need to do it
> ourselves.
> 
> Cc: stable@vger.kernel.org # v6.13
> Fixes: ca378189fdfa89 ("xfs: convert quotacheck to attach dquot buffers")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/xfs/xfs_qm.c |   10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1317,16 +1317,22 @@ xfs_qm_flush_one(
>   
>   	error = xfs_dquot_use_attached_buf(dqp, &bp);
>   	if (error)
> -		goto out_unlock;
> +		goto out_dqflock;
>   	if (!bp) {
>   		error = -EFSCORRUPTED;
> -		goto out_unlock;
> +		goto out_dqflock;
>   	}
>   
>   	error = xfs_qm_dqflush(dqp, bp);
>   	if (!error)
>   		xfs_buf_delwri_queue(bp, buffer_list);
>   	xfs_buf_relse(bp);
> +	mutex_unlock(&dqp->q_qlock);
> +	xfs_qm_dqrele(dqp);


^^

Hi Greg,

An AI assisted backport review flagged this, and I checked the upstream
code against the 6.12.y tip f4ffa8dc360b.

Upstream ffb48dccce19 acquires a temporary dquot reference and balances
it on the buffer-bearing return path:

     if (!lockref_get_not_dead(&dqp->q_lockref))
         return 0;

     mutex_lock(&dqp->q_qlock);
     /* ... intervening source omitted ... */
     xfs_buf_relse(bp);
     mutex_unlock(&dqp->q_qlock);
     xfs_qm_dqrele(dqp);
     return error;

6.12.y starts with a mutex-only xfs_dqlock(), but copies the release:

     xfs_dqlock(dqp);
     if (dqp->q_flags & XFS_DQFLAG_FREEING)
         goto out_unlock;
     if (!XFS_DQ_IS_DIRTY(dqp))
         goto out_unlock;
     /* ... intervening source omitted ... */
     xfs_buf_relse(bp);
     mutex_unlock(&dqp->q_qlock);
     xfs_qm_dqrele(dqp);
     return error;

Neither xfs_dqlock() nor the walker takes a reference. The new
xfs_qm_dqrele() releases an unowned reference and can assert/underflow
q_nrefs on dirty zero-reference dquots after quotacheck, potentially
blocking purge/teardown.

Could we replace the new mutex_unlock()/xfs_qm_dqrele() pair with
xfs_dqunlock(dqp), keeping the early return and out_dqflock cleanup?

or drop this fix for 6.12.y ?

thanks,
Harshit> +	return error;
> +
> +out_dqflock:
> +	xfs_dqfunlock(dqp);
>   out_unlock:
>   	xfs_dqunlock(dqp);
>   	return error;
> 
> 
> 

