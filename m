Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C645345CC9
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543750; cv=fail; b=f6D/J7HRYHJSI4RVDJKOlk5Tno80xaHMEX2C6AbM5pzIOP+unj63ynaEf5kOqzgq99bvPY5QBQyCB2y7fFMxrtH9cOFgeVxmpLmIyF+UgjCrLfPQZbnALVh/mUWENmK4lBkRL7byRl6FZ+J9ui+yFZsTZS9eWKxWNoOZpcHJz4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543750; c=relaxed/simple;
	bh=KABz1qj7Qj0PLSqcCk1FvnqMy4jW5CNuLibxLKa0gwo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=js9FaWRlEGhc5ShXRoJWJFySwJftGtBQVGAvMwnSNB/pcSyHUDZJBMsoYGj5amuJ+1p76VUcMeMBBo0Dc6/SpBkx4RNNhjP/GQJWGBQWk80i1jNxu38sJHH1nQloUaDQFs8s3gj9jO+llEU1pg5FORVDFRP+9e8bzGC3V6ej9qI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UrM7NnaF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GMhivr5+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UrM7NnaF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GMhivr5+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXFuI525169;
	Wed, 16 Sep 2026 07:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ho/IFE1IsvifUbsxptiij5iBNUFg4XyTXkTUdcWVfv4=; b=
	UrM7NnaF4hKcLD7t/FDidFD2rtG63PzrsiG1iR6QSu3lly9YyW0M9hnkyn2JiMMI
	OadKMG+VlRTJwJzkFZH5z4s2sschEHU2akXRsLHJo8NH6m+kbDdll8aX6kVZenmc
	6Xgqpt6tXmsa51Qx60/BM2uguWYQVoBQ+3V4u0xyJxuMkpXzojtez1QZX1ndzs75
	+Y9Dhyyj68lDyYdG9BpYKV3SBLJ3kz/0jOpfUTPh0wyIulGHGt8W2XRj2duT+fvH
	2iXpcCiOIROlQ++1NUunCQI5JWUnOO1cO5fVbIx5rvFKYixTrOmS3q44dUM7zaMz
	qUsxnWDn6L132KmUvSPzbA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmy9rw1rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:28:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7OqFW006031;
	Wed, 16 Sep 2026 07:28:44 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011033.outbound.protection.outlook.com [52.101.57.33])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6atrjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:28:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPyvhZyx5qN6khob3ShPLAHTOYPsg7suozpQ6ZM0f8p6VbMnfw7gUf6aqW/7huRN2K8ruIu8ve9TksST5UaNmuIwft6nyNfHg3ujHwZ1IJt/Vfp8MWRNvwUvFmcHJ0ssV5GZGQrxcm6AmbFifEV5nlv7THkHrKOGQXXMHftb4lPoFBLVU8832y1W8h7EkdJNbWoLNsL9iHAKVyNiVm8Q4vori1SP67n8aI+wfimRQoUuOKHaE5PC7Jry7I0ndIEjhVa0yuLFimJuzZjEy2TYZOj/oFIsWhAgPQsguCqDOumKmVuKddBON9HGIywR0EecrOtjXbhUdzg8+K4DiGE7lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ho/IFE1IsvifUbsxptiij5iBNUFg4XyTXkTUdcWVfv4=;
 b=QQtVIiAVXX8BrnkP5jMKagnSkRMFcKFXNwSixzIvlkzcrtVS2wCAfQyPZo87YiwOTsHr7QR5uUjKL7XqBrN0/gPKiel3W1NHzHMytKLRR1Gq/wQwqKtTUui1Jfemcg5uv8iWnNJZfuuJ/tUhyVgHTtmV7sb3hquW0hYLV22pCtVKEY5AS7JhK50D8YcvCoQvdzlI6X4CdJJ5CCwSxjg1/v0mRIk95us8jEYmIujRjiOiotzScEBAFbnqlJr7XufPL7hO2a77gpFP+vRamhnqDzedghSoMMGya6TaO9C0Ljx0tTwUhG9Na1z2JBzhg9pmE1FCyer+2Z4UzCjKkGTPFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ho/IFE1IsvifUbsxptiij5iBNUFg4XyTXkTUdcWVfv4=;
 b=GMhivr5+oqXzVL6f5yPFODsiqG2Uf0SneWCdsdRumq/sTs1lQEp/OVh517NBtoqZCe1FYeBvIVsTjbI1A+kBLUsXdjiI0k2BlqCtvRobs8wGHr02WA5Dw/zITjYwbjxW3AjErK3pTtWr+k8uN6ig3Y8fgeCaRZlPOF6o6zPJgic=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV8PR10MB7991.namprd10.prod.outlook.com (2603:10b6:408:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:28:41 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:28:41 +0000
Message-ID: <8552fcb3-e14a-4485-9f86-52a0c5f6119d@oracle.com>
Date: Wed, 16 Sep 2026 12:58:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0505/1376] crypto: ccp - Fix memory leak in SEV
 INIT_EX path
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, Atish Patra <atishp@meta.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065618.794261152@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065618.794261152@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0112.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV8PR10MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: a8218aee-9c80-4b6c-d1c1-08df13c42198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ej/D5TSNC37Zdzx6w4P+PkEmH2CL7QklcV5sO08JYX0xvpjhEURF8wilEXN6/nWa5KEfI4LKGYdwU/Qfz8L8Z+gBGtqBTM7z9cajw8ycIBVyDuTt/YrpgIJi//C/WtsiIgZJXyUxyHngG+9lMjkDizi7q8nvcFYLgrTo3GFsACFN6QUmskjBal2Tcsz/I3lRmQV7btzGqIfK+N9cBMFKy+e2ULmeHjR0YsYVIX/814ExpJDBYpn+Q+xiv7+2Kh9CTy3L9890uRutN1kqjKsGDwZ/y3dfioM1Zm8SG3Jxn4YlmFRHnrZoQF4oTbakO4IRLgqTb7mES6kMChgONwX/PIUJDIUsG4XBXBNOVI4rFldvEo/0xjr20123dPtwCBaumvLKWDCGFRFjq6avVw3npSD8KvzH48QrghLnZJDK7HathjGOPOD4FDZYm35BiW1gUE//oQXB8ksgHUzz9IcLheUCAaoQfNjReGe6Av+wsuhfQBlCRm/De6CkcwA/IFWd+YZ5GIjKEYSGm5riO2RlIp0yUuPvXWWqBorjQfi2AU0iGZpABE6qJydmW+yXVNe9EErGao1j5K3sPl64df0i1MNkOZXpwL0opOw2ac1ccYI7ZBH2mR4HvhIJZIJ3t4iOF6XRuWZ/ioIDD+4bHrTlXhIXjfznl8miMgEv1A/4o60=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWIvMGlMd3BoY2ZGSWJjMllld3ZHUncvcXJDekFzZlFpRjVCcWxjcWVRVTJo?=
 =?utf-8?B?REYvRHBFYW5VdjZ4NkdBWVlDQUFzejdWRFNKd2dnaTJGWTQ1MHMrcmpGUzNM?=
 =?utf-8?B?N3Evc0NJMHBLc2tWN0RZeDROTXhDNEZTL3VHTEVQaGg3UHplNFVFbE9wRk1n?=
 =?utf-8?B?VlhzampqNWJsSkE2a3cvNThMVU9aS0pjZ3QwOTRpMVNIeDY0bTF1SVBPc3Nj?=
 =?utf-8?B?a29mdzRtcUJVZlJVNUNLaEllaVNWdWIwd2lXOWRDaHBJVFJRYU9sTmdjSFNR?=
 =?utf-8?B?TG80SS9HZitLRGZyS0dkZVcxMmx6RkVXQ0VPY2pDbWxrTytrTjdCODI3bDJX?=
 =?utf-8?B?T1NzbVgrN1lIYXp1K0owdlF0aDZDOUF3Z0dvUWg2ZndFamg1VCtLcVYxYlRh?=
 =?utf-8?B?TlQzYXZ1cnJEWEliOTJIMmZzbEFlQkpCY3d2K0FaN1IydnZFbzFaZWtoWlQ5?=
 =?utf-8?B?bm1tQUV4VDk4UkUvbk4zaHk2Mkl5ZzV0WjIvMVVRaHk1VDA1N1E4dGwrVElk?=
 =?utf-8?B?V1JVT2p1WHZGNWFheW1sMUs4VEkxUHo4V3poWjhLQVlONjdEZTVza0N3dW52?=
 =?utf-8?B?TnBoUUovMU1wV0YyMjliU2RTYTc5N1lMTGhWejNHd3ZUZDQySURmKzBFMnpS?=
 =?utf-8?B?dTJBSVBaa2IvcUF4UWFlVEdnYmJNNU56WW1OVDcwMkNtcTlMdFdYOU56WXFH?=
 =?utf-8?B?MDZkR2ZLMm9OYlBrN29YUCs1RU9GWG5wTXpoeHVuVjNReDRYdGJ0b3VmYkJo?=
 =?utf-8?B?OG1UQ0Q4c1dVQjZ6UGZsbTVVYS9mZytxZVE3QVZQbDZaamR0TW10SzZra0FW?=
 =?utf-8?B?dHp4UWkvZEJJQnlBNGIrVy9IbStZK0orZTIwbjVtZmpLME16dEcyU056eTll?=
 =?utf-8?B?TVhIbVViMEFEcTVBaS9OSzBGaUxjUTVIaGUrZDViS29ZRThTR0g3c2p1Z1Vn?=
 =?utf-8?B?eXV6dkdrdDlqUFNScTg2SDhYd3lWZ2lQSTNWdjYwMmcxV05vb1lUSlpOKzlp?=
 =?utf-8?B?Q3h2Y1VpTzhiRU9kQXpmZ0dzVnN1SWlJMU5LTVNnV0VUYmpWWkVnZmNNT1Iy?=
 =?utf-8?B?dWNxb2ZMZko2THhjbUJzSmZIc2VJK0d0bE5IajkvOHFDNVBJZElDN3hmeHMv?=
 =?utf-8?B?ZFNnT0w0MUVpVEFRMzQ0UUhuZUU0N2ladVhZMUN6RXJmb0ljVDBtSzE0ZDVN?=
 =?utf-8?B?a0pXSVoraW1kT3BweDZXYlUwWFA2VU5wOHdEcUd0R0E2ellxY0JqSnlaY0l2?=
 =?utf-8?B?MktYazM0SVUyaENBVXRITEZZbmpEajVFOE0ybDBDU29QalpCQ1paK2loQ3Zy?=
 =?utf-8?B?b04rOXViQi9zTkpLdXowRG12bmNSNGs2eGRBMlBsdWJMTzJBM1BlZXFQNW1j?=
 =?utf-8?B?WWdhcC9mcDdyYW01dW1wclFaZmM1RWxCNWNVQVI0U3RlNVdpWVVkWEpUOU1w?=
 =?utf-8?B?cjh3RXdTd1hiaGI2Tk5GSnN6am9HU01hYVZzUTBicGxIMCtRdk9uTlRyMUNq?=
 =?utf-8?B?YTdVdTlWc1hNQStuRmZoWGMyTnljMkpiaTBROXFhWG13cXI3SmtsWEdXRjhT?=
 =?utf-8?B?a3h1VFp4MU11K0NZdzVHRHI0ZkFqREZMR1E4U1N6cld5bXlFaFBXSjNTYVNI?=
 =?utf-8?B?UlEwNVJOd0RURDREWUx0R0NBWkNNVXhFdnpqYUR4RWF2bHVvaXpycjhNb1Rn?=
 =?utf-8?B?Vmp6enRRTEF0amcyZnVKQ0xyNnAwaThBc2UwNzQ0UGtkc1RuS09XR1QzeWNF?=
 =?utf-8?B?RWE4UGdmRmgvUFM5aG4zZHdYWFY5c1R6T1JKdG5XVGVXQUd5eTZiQzBxS0My?=
 =?utf-8?B?NWJQY1FEVVR4SHJBOStFNGV3WjRNRklCKy9vaGlHS3EySkc4Z1BSdWIxcXNo?=
 =?utf-8?B?VU1aZ1l6WWxDSWkzSjAvU0FsQzJiODVpQU9yNFpZanlVbVZLL2xJbms0Zjhp?=
 =?utf-8?B?MGFKa01YQzJ5NEFHWEtkcStHUFZPbXdZRzZZSmtkTnZlZEJra3MrM1JISk1q?=
 =?utf-8?B?NWlsVStJSGU4OEl1K0RhZHhJNHVhWkJGRmwybXIyaDVzcjVuek5TRXdLYkhP?=
 =?utf-8?B?bUU0SWZvMGhpRjVBV0V3VmtJNGV0RVVRY2c1ZGxJVUZIYTQ0K21IeStFbnVq?=
 =?utf-8?B?UVJPbURyV2dlU0hwSjVxcURSOUN0U2JtWThDeDJRUzJLemVLY3pLWENwTVdr?=
 =?utf-8?B?bHJRT0dsa2pMM0RUL0FZVmdPTVV6M1BaM3llZTZKK05JK25QS3dTT093bUJG?=
 =?utf-8?B?YVhZdE1pRGhNNXpaUjFhVGRDVFNkTml2dFdhY2I2UW42aUhIV2JzTjBFaXUz?=
 =?utf-8?B?cmxMcnM0WlFubTNTZmdOS0VZNU1HY2VTblNOVEZ3bjlZOUFmeGR6QU9pK244?=
 =?utf-8?Q?AOFzr5Ya87GDtyspJGFw9UNsXBnkDUHVP4Hht?=
X-Exchange-RoutingPolicyChecked:
	ZfvgCwi7h5ewCLMyJF3r1pIttFHWD0Cu6p7m4KzQnuON40mFuL0dFoLCiYmBGddV4+AuAcoc2YLt8/yx42ZXbMEtmc3M2JrXsfNsudWyyEuqBPpM6HrnSpOuPW+8NQAwGQsykPlpRAmrUSnHSTOmefmfUIalfQ50PrVZz5XyaypZhtWFAVW7Diw4+rkHfQNK/KScy4JvO2HLID4M5lw4tSBcncZ9zSEAzq00XPaK5wteQgCvjaZLBJun1qn1sQmAF8JdMzIGBIcemsG8I0pgK+WFK4YcH9UCK+xadGN+A9Pflspl4uxywwiIzMRcHrsw86n7b8z1RqrmQDWgL9nS1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OQX5JxUIj40MEjSA9C1xfCdTZ//DRtSVNhY/14NH0ET5NCwoNPFHPgI3A4GZh6+QPsu2Ya1tUtjV+LYn1W4BQu72gJOqeNBzcyBEgIBh7Ey+XIdv/+vzu3a4ffihUURk5hUOotdu/dbR37XC23eioJbNcyAfkzt0oHFM9FoSd6aC+64PLsKqsDydKyMVSi40+19VlCzOu5YcyWZe4PRTGzw6Cp+LqjHQra8kx5q0FrN/Woo543c3e52+n0fRYMmgCRsbBHClewGsw29rRs/RmuOX4BzD9dukGOL7t7FaRiza1e+F0lvgKz8nsVfL60/QjFLcW7p+rS5mEqCUYXCidLCzfhSBgGxzcBOmIyl1H70kpO5akDr/x2cNLwuNCCesfOTPXhew16LJHOwfGINFt8GjmQQuKvOrU/A512fxGa4cSyn9T2z2yR+oGolu8vU2q7+q+yVxIdyT8bB4LIvpHsJQdV6hCAKVFeehOuS9oXHSesOjaCeujikwmn4he9FgmFAdF8C9jgO7iEkfGEnhksHiDO9RyUVAxylK5OlVAvmyYUO4Zf7W+f/kBDfENfFmMieQ01Z+fP/k7dvGxxg32dGbJlog5FcWy5q9BmcCybY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8218aee-9c80-4b6c-d1c1-08df13c42198
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:28:41.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahezh4uHUbwgBOR4wnzv9hf5tovagFVVq8AaALCT7ATVEyf0WMDN36K6ykxqk7SMLeKFemh47ulZUF1E+aqfx0ziRV+5RR/9CLsY0okY9X3ogyO8+xxbonXbtgqgk803
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160095
X-Proofpoint-ORIG-GUID: xzg7zG6f-h_W47iCI0MrIMGZO5dytLsc
X-Authority-Analysis: v=2.4 cv=MuvHeGae c=1 sm=1 tr=0 ts=6aaa452e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VabnemYjAAAA:8
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=FNyBlpCuAAAA:8 a=IMvV0PBc5zEJpIp0jAMA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=gKebqoRLp9LExxC7YDUY:22
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5NiBTYWx0ZWRfX1C7xaCg2UFbV
 3KDN23u0/2YS4Xm27pkaADRCVRhrZz1m+s3t6lEdy70ApIKdxngtvTCwEezQ+S3VPEIhdFOuVgd
 lzPWOipYhqyqExjrWp6A7UsVfHj2csYpdGI5s2XfUpbulPnP0HAT
X-Proofpoint-GUID: xzg7zG6f-h_W47iCI0MrIMGZO5dytLsc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5NiBTYWx0ZWRfX+hnuO+UhkbiN
 NN8yUTSZMZHSuoH93zPzKnmviFRM/pIVUwHt0RvEOOmEh7dWW+a2KcRDpCOFmLX62dscKp+LVrL
 JKJzU54s2tEgpnm8vvMx/dATpKvukRIM5XCXB0tiiz2c7EJ0nTNFgWWGLU76kO6tjdOzUzmmcWz
 z/jSkOa+0Iq3RBrM3RXmWCNwv1MlEC08suh0bc7Apf7xGEzE7Ob/F1h2Ul1kL1lsd/EAIXu0HPn
 KtTTG1GbtLwhuAhiIh/ejBaJdiku2Ns+463PK1e4g1dwTxpG9QB/WxAWzKHXp6vH65t87IQiDVs
 o60KqRrx+J/LSfSfwRK1ad2qToi4f7FwNSU1HiOnmBaG1N2tdDRiT+Z4jA7SbDKbIF7g+qu8ujH
 AdpS4f8iv3mDQOMOS+0nqbbD2yjJ8PXxtHITmyqZIOPvQeRyJq94y2soHYDk6ejbjsoH5s3DobB
 PmJLMwMnjKP8R/sOKXQ==

Hi Greg/Sasha,

On 12/09/26 12:18 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Atish Patra <atishp@meta.com>
> 
> [ Upstream commit c8e53ada20d352b0f1bdc3e58405a9edab897a2e ]
> 
> allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
> is left pointing at the leaked memory in case of any failures during the
> function..
> 
> Fix by adding an error path that frees the pages and clears
> sev_init_ex_buffer. Make sure we only free the memory if the failure
> happens before the conversion. Otherwise, we may end up trying to free
> up converted pages in case of reclaim failure. rmp_mark_pages_firmware
> failures should be rare enough to avoid more code complexity to track
> down which pages were reclaimed/leaked vs which are not.
> 
> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Atish Patra <atishp@meta.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d6a0773d6da8f..6dc380537ece9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1244,7 +1244,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>   	if (sev_init_ex_buffer)
>   		return 0;
>   
> -	page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(NV_LENGTH));
>   	if (!page) {
>   		dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
>   		return -ENOMEM;
> @@ -1254,7 +1254,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>   
>   	rc = sev_read_init_ex_file();
>   	if (rc)
> -		return rc;
> +		goto err_free;
>   
>   	/* If SEV-SNP is initialized, transition to firmware page. */
>   	if (sev->snp_initialized) {
> @@ -1263,11 +1263,22 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>   		npages = 1UL << get_order(NV_LENGTH);
>   		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
>   			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
> -			return -ENOMEM;
> +			rc = -ENOMEM;
> +			/*
> +			 * Pages can be in an inconsistent state, don't release them back to the
> +			 * system.

I ran an AI-assisted backport review and manually verified the finding.


Upstream c8e53ada20d3 follows b0e7ec0dab242c5e480121ba12400d0513e37ca2,
"crypto: ccp - Fix possible deadlock in SEV init failure path", but 6.12
has only the former. The backport retains locked=false in
rmp_mark_pages_firmware() while sev_cmd_mutex is already held.

Upstream code after b0e7ec0dab24:

     rmp_mark_pages_firmware(__pa(sev_init_ex_buffer),
                             npages, true)

Downstream 6.12.y code:

     rmp_mark_pages_firmware(__pa(sev_init_ex_buffer),
                             npages, false)

The downstream false argument can reacquire sev_cmd_mutex in rollback.

If a later page conversion fails, rollback enters snp_reclaim_pages().
The false argument selects sev_do_cmd(), which tries to take the same
mutex again, so the cleanup added by this patch cannot finish.

Maybe we should beapplying b0e7ec0dab242c5e480121ba12400d0513e37ca2 to 
the queue now that this backport is merged.

Thanks,
Harshit> +			 */
> +			goto err_reset;
>   		}
>   	}
>   
>   	return 0;
> +
> +err_free:
> +	__free_pages(page, get_order(NV_LENGTH));
> +err_reset:
> +	sev_init_ex_buffer = NULL;
> +	return rc;
>   }
>   
>   static int __sev_platform_init_locked(int *error)

