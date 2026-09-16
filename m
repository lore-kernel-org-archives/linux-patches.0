Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A06446C01;
	Wed, 16 Sep 2026 07:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543260; cv=fail; b=HV++vu4OYW5vgpMHfcIsOadVCyybY2LxqgxyXW67a6iLpVRcUsBs470bo8IZ+gvbIFEI92sTGQ1o7GV3n3g93NChb4/ZKHCPdSt3ZsPwVBvhfrZDBT0DmCMOgyNg2in/KA/EJ55qgjfx6BNhVYit6sJ4NhqyYUKk4AxkD8sAB8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543260; c=relaxed/simple;
	bh=uefjvQA7BTMc1p7fs9DjCj93yupbegDlcuzOwQ7clzw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=faGeuElVa7kqFXeafuBkeuO63GmH2/n4/ccapTDdbG9PgGVGbHPTMB/5z+Lf0V1IpkpSqz04EC73h5JGdQFKxriLBUt9WF9JRvdPdkoistFi2ivft5BDbAgkqTnJHEg/eCvMx4X9yUv+4KZe/rUwumtWGhH0QHnYiI9PCVH0Uus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DGv36tzE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y+ayjbVU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGv36tzE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y+ayjbVU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWvZZ555211;
	Wed, 16 Sep 2026 07:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e3qsD1YQxAY+aaSwfXWwXYGW3Oc9CVklQVuBgbfoXgg=; b=
	DGv36tzEsTpyzJUiUPGVoVCvK8nPoteuPABya0Dp1i0l4YqxwIAKYpidKNHcSIzY
	wAB1ylBAtmv3Rb+jcWA1pxNt8D4rrPGCXXYZQHemuHc/0Gckv62cpGRvbX3KrHLq
	YB4q3eQaHcFs12juGu3xffNDGTOfkggtuxo73qQ4moYELQR4+VS+3+zgROXG4fd3
	Ao0cSFta7PbcanGg8VEzm8DZRqgJ8+fxCOJN1+l9YVjZ0oVzoDWXuNKQY4n5hxfO
	Bc2v5SzL2cs1DeBtcvlaKwOII3sK5iSKxvv/YLiqfBu0054OMs7+phl9M5UuT8me
	Hkp/yAaIOQAG/dxTneZnzA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmw5b5377-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:20:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7JqZO002089;
	Wed, 16 Sep 2026 07:20:30 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012062.outbound.protection.outlook.com [40.93.195.62])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d15y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:20:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIKUzAnmMTOn1H2s+VpZ5eTCLPp8NaAYMuERKNK7HFX7QmQ3V6M+/ohVD+Fz3skWEGF+m94hzukNwU8hLDd7Dv7scodNb4vqyh+JmRMotWJMZCHcStY+3yjxcwxwLl+bd9C0BkXYeNz69BK43GxUXpythjZ0shM94ffr/qiQgBZj4VU0quZuI6xoevOo07eMvB6t+tdQUulfIGm5DWNyztqYFOUOGWSfdGOdBE1vgdhW08pG8EcmUyzhejN3W3tPhNvGc1nlJ3x0nIo244/avAOzNifuuZD54Y2j4ltvU6COMpva7JUvqgjkPreOna8BqyjXBIFKhR8SKHXalpWyiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3qsD1YQxAY+aaSwfXWwXYGW3Oc9CVklQVuBgbfoXgg=;
 b=bHQxHVvuRro4pNeFvsTMqrAqzl78yQhezRJ9aG9LisA+o6cqJa8PRxqzRZEMSn2qdPMarhKbgtGwHvx/G/uALKyTBmHj4kwTx1DKtILTLrJqIMjbpkW6e9CINK3VzwSKvoaC61VxDF/31OLv4Mj7KVvuY+A/avrxVP5UrGdSFswVHmc02Rlt3iMCAKkSjUCJUM9+LKEQw6OxtAHfWDj+pmKoJO2TIqMDAsqfL226NvYdyAXOra9TcS1lc6ktDFk5WDrSWcJaUIvX+UwlT9ozsIEEc5YdoYwFCwiHORBU0bJ352QqNdS6Q8mgEERsasjdoLZyvBUgD0r0J8PgIMcp2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3qsD1YQxAY+aaSwfXWwXYGW3Oc9CVklQVuBgbfoXgg=;
 b=Y+ayjbVUq2ZDv1eSZk2PVR6Ex+mJc59UVmQchha7Mukl57hWXjrdfQnBi4ZfhkpZOp1eJ8E4vORW51W9yJ9admYzpKASg8LR1I4jzvXly2KiIDjbgRFnTY4PSSuicVa1uCbdKtAYQp+uVLngrPBMoFqed3lzaReF9TCM8Wh2ouM=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA6PR10MB997681.namprd10.prod.outlook.com (2603:10b6:208:5e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:20:28 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:20:28 +0000
Message-ID: <fbdd8514-3a55-4cd9-a999-0b0537c6aa46@oracle.com>
Date: Wed, 16 Sep 2026 12:50:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0490/1376] usb: fix UAF when probe runs concurrent to
 dyn ID removal
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Gary Guo <gary@garyguo.net>,
        Danilo Krummrich <dakr@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065618.458576452@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065618.458576452@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::18) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA6PR10MB997681:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0f4ae4-5ab5-48f0-7ef7-08df13c2fbdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|5023799004|4143699003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Xa/uZVMp1C9K8hg0IjBNrm2Kbv3Z/pvFIQlel/JWdeGYeBFV/coo3YyZxqzC9E2riaoAG5B8/6GclE8SjFnJBgLIe/yD07OJaaAngWAsfifh6bEnrKB3UotidGDDPu4BDF28BMdcskt7eYFbaE9jw29CfgbFBDmVUWm3JCkCaft/C+D9oTvIcQAHCsdzZ3kL9zmpfKDVEFgm75LkAgy5ujJ6g70vfxFyk3ZUoMsfGieZUPL9VhOqvsLcPIk7YnYvok4vxb885mPm4YcI/6yUs1VdVqy1iH22Ov1s1JrzRtI4Q6oh2MboZSIa31BDNEvDki77lxBj/jH7roFHfERP0L3YDH0lmDy1C/SgKecpY+sCUQ7U+Xv46axRLuMOWahJ42HJjnTlt5YjLoSkACs6s2JfMXN0Jz/RQkMgmzCNc1I/hKoQze/zmNMwQmuUdXwT+2j50agwy2VmEHwIRymlafegjjx6OUT2k55dENl5Sz9v9NiwZ7A2DfRe7sNYxpHlSpKm0sUej6LL9jj4bbx+2fb/l+MxDXDbVbn8IKcn4AtztrEG+f1PeekYIj7pIt0EskukOfkAsd+Pv8icNxJ0+Yn9OHJ/LnFE40VmFxuocPh0vLlwSzRWWg3jSqnYpnxd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(5023799004)(4143699003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXpNYU1KTzBMQUZmSUFNQzJ2d25GM2Y2VXUrQzBUdjRFcldCZE5CeWo5UVlk?=
 =?utf-8?B?VjlqbVFEdkhsY1QzMGZod0pBbHM2S0N5a21GY3g5WW92dFZkTXlHRHcwcmda?=
 =?utf-8?B?ZTM4dDVNQitzREsxRzZ6TWhYcW1WcmR1eGpIR2xVQlZpYUx6TWVtYWRLQjBZ?=
 =?utf-8?B?QytyMEwyRXBvdHErVEU5WTk5VXZka1FZU0hxTkc4alh4dUZYV1Y2cCtjL2gv?=
 =?utf-8?B?bW5kYUtlc2dEQTUyTWhhQzVwNEJRUlp6ZlpKZXBuYWtHOVB3VmcraDRUZlQ4?=
 =?utf-8?B?d2NOMTVzV0NJTnpKYnNnRnVsRXJtdmdCaktrWWlwN29EZU5ETnFHeDF3K0lU?=
 =?utf-8?B?bWZ0ZFdnWUpWcFV5TElXTUZQR1pzWE1GQ3NVM0NYVXZqb25WNDVLVktNREFD?=
 =?utf-8?B?THBPODN1c3lrR3Y5THZsR3F0dUVKVWlTMmdFVEJFM2VoWlFPbFNwRjRhSUo1?=
 =?utf-8?B?SzR2d3R4SzEwS2U3eHdEVHVSZnZJSHNIaytyczdoTUFPamlKWWgvU3habkpp?=
 =?utf-8?B?RjJWWHFWc0NNRnltVmlVWHg3dHhHNDdUdTYxZTNkOGpNMTBhdHZ2ZExVdy91?=
 =?utf-8?B?VGY4eG94TnV0SCtmVmtnZU83ekpXS3B2YmhBSkI5TnhBYXVwQUNUdEtCZlFU?=
 =?utf-8?B?WDZ6dTF5TDZmakhsTTBFdlJsd1gwTkppRFN4SWRIYWorUVAydTBpWngyeVIr?=
 =?utf-8?B?eWhZYlB3NWIySkd0Q2c2OGU1Tm1ORGxIRXBzSGJwNTcwb2dhWTgzS2Z4czVP?=
 =?utf-8?B?cUZTSEtGc3BwWEhVU3ZrYXNuVktyVUszRkVuZ0xyUHdZTVRVNlgvM0p4QVdU?=
 =?utf-8?B?MXBPTXZsQ2tRN3NXdHhJZ2RNUUE1V0lmRVpvQm9Hb2lwSzVpR2FOM1hzQ0wx?=
 =?utf-8?B?VStnZFFLRG1aMDBPL0tQdWdhMndodlpVT2djYzhCR0pURS9TaE9lMTAveThP?=
 =?utf-8?B?SFJMMHNDZXAwTzlVUWkzbDY2eTh0VWIxaWltbWlWWDlEQXlyUzdxSGRQR0pu?=
 =?utf-8?B?ODdvTzhBOElxdHZ2L3R6RWFlTTlCVDJ1Y2FsT1lXUm5raGJZQVlTTHpoMWJI?=
 =?utf-8?B?RTY2dHpYZ3ZDVkFKMHN6RVM2WjZBN1pLWGtyWDNyZ254bWNPTjFzSlFBdDAv?=
 =?utf-8?B?cWF1QldQUGQ1c2laWTNkMkllR0lsd0diQUxPcmdsYnlBRWZZb3ByL0tXWG1l?=
 =?utf-8?B?ZnVReU5rL3VOSCtGYkt4N1BUYnMxRERzdjhsMUM2R0ZuMkxLbEtkaTRNWUZL?=
 =?utf-8?B?L1FlTld0bUo3SlhnWW1FQjNKUzlsTTlTU2ZWQXJJeW8zSHY1TlFwemNYdFRx?=
 =?utf-8?B?bldmZ1Q1NG14dktJTVJ6Z1hjTldvbiswRGxtZnphRHhGb1BIUHorN0wxeUhO?=
 =?utf-8?B?Qm4rcWVSK3R1cHpBY2NOZllJTEhkdW05VEtidFlyeGN5bXkrUEJ3dWZTakxs?=
 =?utf-8?B?d0liSHBkR3kvNTVBUXpVcThOWndyTWphU1BqTmlXeUM3dWxhZFA3SXBseHlo?=
 =?utf-8?B?bGpVVllBcjNEZTV0WStzVDVlVFZEaE1HSmVRLzdBbGpjdGxIWFBCVXJUZ0V2?=
 =?utf-8?B?bEdHdFlZKzhyb2oraVE0eGo4S0RmTWpPT05UdzhhbzlKemEvWDFMbkJaSE5m?=
 =?utf-8?B?Q2hJZGlpYStZc0orSCswWXJYYjZYb2JLL1RHL2YreWljdzNac25ZcjlYdUFp?=
 =?utf-8?B?ZUdadjZ4K0pUWlc0MzNucFdqWjhzS3hNei8xc3M0NDI4M3pJRkhRRHRJb016?=
 =?utf-8?B?bURLamk1UHI5c2ZmLzB3VEZhQXFuU3p3TzdTejlLWEpFWTVTZGFoRnNMaVph?=
 =?utf-8?B?WTU2VUdBKzE0R1h3c3hUTEZBT2drWDcwQTVYV2d4MU5MUFA0RGxpWWN1VUx1?=
 =?utf-8?B?V09LVHc1TE8zeWdPZk1VajIvdE9SVVF2UFYrejNsS1N4Mm90ek1BUkV5OHMw?=
 =?utf-8?B?cTNLNFBZeW1ObDBpb3djRXFnSG1ZQTBpMW5KOWNlTm5RaEZHa3Q2ckFPT1FW?=
 =?utf-8?B?ZEw0VVl2dFdmM2k1MTZGdEp0MUxqY2tvMDlUaHZnNExhMFlVWjk0VlRub0pn?=
 =?utf-8?B?eTYzeDZYVjVUZDlGbFpSclRtMkpML2twWXNrcmdQWGQ3bWlncTA0elA2eU9T?=
 =?utf-8?B?R0RMbFdEV3lsVkIvMkJaV3VaSzlEb1VpMEVWYU1xVkJpYmpJcjcwMGQ2Q3o1?=
 =?utf-8?B?T2NyVStyOGRzaTVBQk9jSVUrZGZHMHVwMWdGRFNqRGtJR3g3T1d0eGMrcE1V?=
 =?utf-8?B?RFRMZXEyUkJFWVN2ck01QjU0aCtZTzV4MTc4M3VYc0lCekV4T3hYNVZqYlN1?=
 =?utf-8?B?SGhRbUhieEplNWlYUzk5TU85eDRQcDBLSWVTZDFjd0tTUUxxUjhXdmpERWwy?=
 =?utf-8?Q?4RADsThAY5lulPxxzYUw9jb3w8f7HvZUx+f7F?=
X-Exchange-RoutingPolicyChecked:
	saHTRM4oCODi6Yy7nkLYYZMQTjljD4jVJiBfJDRQG7QtPN2EGcyweuHccIgi04z8NxFDT6HgEP3fKDg6UGEVl/Y3j4rtE9ICuOCTKPTLVSohVDrBlQBYQrbqfUhmorOr1tGc3DkcFdU7X7t/RCoA4aAD4cGnfi1+6WCpX8BVnxmDAPHdZNK3H98Lo1V6wQTg95m46iUbuEQOLbFBrd883jOK5zScxMSCxA2KvOJbxI0CPMGmWtackA6J9hYk8C41ApzJPl2g79XSSHBiyiojRXcnBCuPaUm1QmkPHpg2iHAxnB7FXGGdIKHhOkMnDsC+HjGAgbN22tFBRPQnUMQmxQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HeyVWOsWMXDhVOrHrusnnCbGIBhYxnr5QcGX0L/EvkP4xkvJZJNwBpnPTwNjHeWhclCeZKfjRrLpqHFNLmudOc5EvjEJbQ2v4TqMPJ5Yko1oZWWWhMwvv0+UXp9GFJrv2cKTVV+Pk/azxOrNb6Bl7kvjYEgErQma8u7yv0mC8JWZOVwl40zSltCf4JJhBibnPZEZTotePXGV2Rm5M2ZiBScxwi+3Cus0FPI9aw65iLYOa3eIvlZGbooACE2Y/t4rnahWG246ZCxWGo7OwoLUgA9hGTHLfDsDCTKGnDeyCiFCzEOIL+Gl55Ska5iPYFpfeAS6n5I8gHLPHsn+yqvq0/v5tvkQvN/Rc/mJlMyUO7BaDsYqBhsY7FNCORYSf7/ss4JfTIaHbIqM5BPtUgYimMpLzHqxWIbjX6r0/RBAuADae5R3L/b7kaJAOEYOvT2yENusqqyv24LubsHr0QmRxfBz2jyk+T1MywezzUxeTupSDU2QzzTTgfVZzXp3lgwjeBuwgAXuuMjXYWhSO9srnr8RnQFEcbapbe/ERNT8pRKlmz7O31/alVA1cUeLRw6DNL2xx1yBXZMD0nWnOzVMLEvneYUgZFCN1k7YrgE6xCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0f4ae4-5ab5-48f0-7ef7-08df13c2fbdc
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:20:28.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QboQLEC1/M/gDx3gfCGjIrkL/aePXOF6Yw6goLj/bbOcUZx/OT9RFELrBtcBDnuGTCYULPAhHqvxbhuh9nUlrI4OZm+tFDvaLhHj0b/qVARhTvQCyt8kzMnN3kZvHqhH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160094
X-Proofpoint-ORIG-GUID: KS2h9Jm3RERRnh9WISXA0RgXp_q3vNxV
X-Authority-Analysis: v=2.4 cv=Ev9HPicA c=1 sm=1 tr=0 ts=6aaa433f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=bC-a23v3AAAA:8
 a=_2yia0w1AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=QvFGLvp-AQ0S_nQYlVMA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=4yAS8WwzZ1jAEY03B-5r:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5MyBTYWx0ZWRfX4WICHrfRZrRV
 FJyschqxTCfIB3piK/w319VaGBgHNMjCsyciI1Mon4lAr8l8i/Kls8tGc6U6cLLRxXJggDFjAtn
 /lwvmpySHnqTkUKFgH+Q3soz8swGWX0ARP00dZWGS8ZztBDK07ej
X-Proofpoint-GUID: KS2h9Jm3RERRnh9WISXA0RgXp_q3vNxV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5MyBTYWx0ZWRfX2vbChy+A2BAt
 O3fl6NNLpi9HVtlX5ckxC4c7vgAaMcdEx28mLZL7lEutp/h4vSgmNdS8JPdi8l3cg9fa+vMNHdi
 UdsAiwfgFJpkefcvxUoSqzcxwEmxQClmgCVcWH84CXr/tyhnDK92GGDq5KHPrEBWfeAcjtWofyS
 A8cTK6Js5Tpg71Gz3Uoij5i9bcbfY9tOe0A+9UZ0oqZLUh9GALy1Zs0q/dK6n1sI7FFzBvGPJ0p
 j4dfKjt2DabxCboai3NuGTrIcN1M6icSLbzAFpH3VmNoj0FsjamwVAe7rqqZdcaaAp4XCUn0aNr
 DuQW2LJVXv9ich1pLidZTvvrnOLuophrSoXRTJb2oN3fJgkFQUjK9LX/p+zgelPPR811vluJnxH
 x2PaxWqL8R10zTYBTlz/7y8Pfs74pC0RfSB655Ntcz5tniVtZBXdcCeVe33ACpLYzs2ArKbnfLO
 VfDwt0IQg2pdCIm2rtw==

Hi Greg/Sasha,

On 12/09/26 12:18 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Gary Guo <gary@garyguo.net>
> 
> [ Upstream commit ef8154d8b52d60338c1fd8d793cd8e891c604c14 ]
> 
> Dynamic IDs are only guaranteed to be valid when usb_dynids_lock is held,
> as remove_id_store can free the node. Thus, make a copy in
> usb_probe_interface. Clarify the documentation that the id parameter is
> only valid during the probe.
> 
> USB serial has the same pattern, but it does not need fixing as the IDs
> cannot be removed via sysfs.
> 
> Fixes: 0c7a2b72746a ("USB: add remove_id sysfs attr for usb drivers")
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-7-632dcf3adfba@garyguo.net
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/usb/core/driver.c | 12 ++++++++----
>   include/linux/usb.h       |  3 ++-
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> index f0f13554709e0..528274e3cd7ad 100644
> --- a/drivers/usb/core/driver.c
> +++ b/drivers/usb/core/driver.c
> @@ -227,14 +227,16 @@ static void usb_free_dynids(struct usb_driver *usb_drv)
>   }
>   
>   static const struct usb_device_id *usb_match_dynamic_id(struct usb_interface *intf,
> -							const struct usb_driver *drv)
> +							const struct usb_driver *drv,
> +							struct usb_device_id *id_copy)
>   {
>   	struct usb_dynid *dynid;
>   
>   	guard(mutex)(&usb_dynids_lock);
>   	list_for_each_entry(dynid, &drv->dynids.list, node) {
>   		if (usb_match_one_id(intf, &dynid->id)) {
> -			return &dynid->id;
> +			*id_copy = dynid->id;
> +			return id_copy;
>   		}


I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The core UAF fix is present, but it deliberately passes a local copy of
a dynamic USB ID to probe. The 6.12 xusbatm driver still computes id -
xusbatm_usb_ids and uses that as an array index. A copied dynamic ID is
not an element of that static array, so this driver violates the new
contract.

Upstream prerequisite code:

     int drv_ix = id->driver_info;
     .no_dynamic_id = 1,

Downstream 6.12.y code:

     int drv_ix = id - xusbatm_usb_ids;
     xusbatm_drivers + (id - xusbatm_usb_ids)

Upstream first applied eb6cd6d3d8ab, "usb: xusbatm: don't rely on id 
table pointer arithmetic".

Maybe we should queue that prerequisite as well. Thoughts?

thanks,
Harshit>   	}
>   	return NULL;
> @@ -320,6 +322,7 @@ static int usb_probe_interface(struct device *dev)
>   	struct usb_interface *intf = to_usb_interface(dev);
>   	struct usb_device *udev = interface_to_usbdev(intf);
>   	const struct usb_device_id *id;
> +	struct usb_device_id id_copy;
>   	int error = -ENODEV;
>   	int lpm_disable_error = -ENODEV;
>   
> @@ -339,7 +342,7 @@ static int usb_probe_interface(struct device *dev)
>   		return error;
>   	}
>   
> -	id = usb_match_dynamic_id(intf, driver);
> +	id = usb_match_dynamic_id(intf, driver, &id_copy);
>   	if (!id)
>   		id = usb_match_id(intf, driver->id_table);
>   	if (!id)
> @@ -891,6 +894,7 @@ static int usb_device_match(struct device *dev, const struct device_driver *drv)
>   		struct usb_interface *intf;
>   		const struct usb_driver *usb_drv;
>   		const struct usb_device_id *id;
> +		struct usb_device_id id_copy;
>   
>   		/* device drivers never match interfaces */
>   		if (is_usb_device_driver(drv))
> @@ -903,7 +907,7 @@ static int usb_device_match(struct device *dev, const struct device_driver *drv)
>   		if (id)
>   			return 1;
>   
> -		id = usb_match_dynamic_id(intf, usb_drv);
> +		id = usb_match_dynamic_id(intf, usb_drv, &id_copy);
>   		if (id)
>   			return 1;
>   	}
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 2004a2db81ced..0012259ac910c 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1159,7 +1159,8 @@ extern ssize_t usb_show_dynids(struct usb_dynids *dynids, char *buf);
>    *	interface.  It may also use usb_set_interface() to specify the
>    *	appropriate altsetting.  If unwilling to manage the interface,
>    *	return -ENODEV, if genuine IO errors occurred, an appropriate
> - *	negative errno value.
> + *	negative errno value.  The usb_device_id parameter is only valid during
> + *	probe.
>    * @disconnect: Called when the interface is no longer accessible, usually
>    *	because its device has been (or is being) disconnected or the
>    *	driver module is being unloaded.

