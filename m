Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43936947A
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723989615; cv=fail; b=cncU8s9zt4cinMbrav8Snq9K+mrJf33An0aXeqDASUh7dpRnEQr7DxVDsLZF1WPkSDF3YslYk4EMzcfO8TmRqbF70M9e0WjCtdC0JPF9QqqvQOpWyQtwVqwkbbHRqBmKrOJyJLP6W1PMx0cWORnrBV0T5Jhc/ns49SK5jVmd4vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723989615; c=relaxed/simple;
	bh=1TA1gRo8Takq5eBV5Wyi5T+PPjGPXaTKUNO9btnbbAA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pb+CsMLpYT+1OyeJQVZNioMIVXwJL4D7TTaol0e3+GxYGexwugflPuuew27e8plAWjF12AarI93YW2E8WZb1C299UyrVGzAaMhJDuEDP36ao6f47hLpA5DVU7gXt9rhG83k4DCkHGL//adVQxhfbX0DYUQVkNCl1TaOD2WNuXF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dIIYhyLo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cfYUuj1E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dIIYhyLo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cfYUuj1E"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47I5MX8Y001692;
	Sun, 18 Aug 2024 13:59:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=m8aFCScSdzO8U3uvvIZ4SheQ31+prIcYcTegeaGbGL4=; b=
	dIIYhyLoTsBec5EKufolDbTWv5a2KNloNMz5Ix2WxBsOTNAuGYMyrKMEGfsEVxdE
	5dv7+FwyID7KznlyiR55FtBZL25XML9En4HmQyBeMXlL0TPtZtfE0CalRK/dwOfJ
	fnSUerK4Kg5m6uFc0dEf4vm4i1ZB0vduHXdf3gFbpUyNCMqAmjrwT7pWecOHc57X
	s5QI5+XU84gMiF7Mino9xSyiteAxHtY+0Iqh9/D3x4JjFyTuvVTNcD5hc6Y0fm16
	3Hjd0VjnaRZ/rbVVQWqKgXSueB9m3ZvexkN6i4EyPQR4I/rZpz8STLEkQ3sHb8Y4
	sGOPFX9ERDOIVEkyhPJf2Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m2d9985-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Aug 2024 13:59:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47IClk39001218;
	Sun, 18 Aug 2024 13:59:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 413h9agw6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Aug 2024 13:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bciz9Prvubc9JkdFWXrgzHW13j4YhAGJxTLcTBbsH+B7ziuCT4dQ0kVj9JGNDOQzIYv1cLo+R9RHVNZJptGcFJKXJb7VTXrgpHSFO04FRQOditse1+G1mzgk6iny3F2ifEi+J0LCv5nBXwis4VAuoRJ60M7RPt8vhb+bCae6q22ogwLEhE7f8rS6cugu/mVWiyDoRULrkDWoWJTJp+7GiWjtpaLVt2l8lVet8bVNXEH4JzBA6dYbbz+R9mxe7jB8nsswYlmoexOTeCKAND3W122Rsp5xrV6gulD0PEV3/YzZeW4FSHi7Jd4i/6VYQjDoFPlk5e4LkgpM2qJYJsMtxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8aFCScSdzO8U3uvvIZ4SheQ31+prIcYcTegeaGbGL4=;
 b=nrw+xPcIpLwT83ST/hw7ftWiQaCf5pVmb9qnCNsa6PRWEqSW3LXp4R06O/WkVTVep//7ogWFkyVtXqR+ms6XxLxNgWdrBLh4y1XrssCt9MCXF3y2ktCdWgoDig0bUcf+EXMewJmH/TT6ZfnRzr6DP7O9IqqmJWKdsXTTZR6kwyJIZqazRB5jQYw+t7pThTK5Sw44zxyk3FEDOpuCidLohIl06w+DlGyo9/Sb8IHFFcdKHNGfaQ2L0Y6BPh5qvlkhR8TzUdBrDSBIxZB1daVBmRlxX0Y0letp/4ghsAJhhu2v2JVEuEh9MXbAed9Z/pxldNEnajo7CYaIDRvrAwADBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8aFCScSdzO8U3uvvIZ4SheQ31+prIcYcTegeaGbGL4=;
 b=cfYUuj1ElXapfXwycQtvKNReVmxJyIhtG62Fkrk3R+7k4Q24SRyBOAqz3+siHCkdtDDuROqzLYV05LHpfSex07vWG+WMHwgIG5oEoGPOWo4ZuFuV8BUD0IBWbtjsRz0/D2iF/jpITzj6SYYEe9X28AyVSpmuIqzA9jtlKQEUjyk=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by MW4PR10MB6323.namprd10.prod.outlook.com (2603:10b6:303:1e2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Sun, 18 Aug
 2024 13:59:45 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%5]) with mapi id 15.20.7897.010; Sun, 18 Aug 2024
 13:59:45 +0000
Message-ID: <35aeaae4-415c-4c3c-a223-cb622933d8e9@oracle.com>
Date: Sun, 18 Aug 2024 19:29:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240817075228.220424500@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240817075228.220424500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:4:186::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|MW4PR10MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: dcbe9bc6-ed54-4549-9478-08dcbf8e03c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVVtMjdhS2RkbWk4azZhQTZFR0Yzc25GYy9CZkNBZFI3S1JGNXZORThoN21O?=
 =?utf-8?B?M1FQM0lJa0ZBSExBNS9mNWFsRWJ1T1ZoWnBoeWRqSjlubWZSamZjN2ppMWY5?=
 =?utf-8?B?TEtET2h0S1l6UWF6ajIrRFFUK3Q5bGl6RHczak9VM0xId3Z5RUZ5Y2Fjdklm?=
 =?utf-8?B?dFdJcEtKYTRYeHgwSXhQSUtNZjFrb21XNHVsMmlsOTZIU21vV1E4T2NPdHZQ?=
 =?utf-8?B?am9rblllVnJDdG5BOFFuUzUzcVREeFV4bWFWRHNrVnRQaEI5eDh6NUdpM3Vv?=
 =?utf-8?B?UDJReitCWnEwVlg5VDJXNzNwd3JBUjNmWldQYkdtS1dnaCtKb2kvNHlXUjlr?=
 =?utf-8?B?Q0k2K1NXSERnRFRpVDhWbUVDbGpXenJNRG1IWXBoeWdqd1B1Q3daY3c0aTRF?=
 =?utf-8?B?OU5iZjVPdmZuSGx5alpQVU9iNkhaVE5oblNnVG04WktIY0hzTDNiNTZyNXgr?=
 =?utf-8?B?S0hHZnhaVUFnQ0oxYnZmYTIvQ29kSElLRnFuTzdEM3N2WElJcCtodXJIZUxY?=
 =?utf-8?B?VVlRQm56OGtIeHltYkgxaXBUQVROSGlUQStZRmRZa1pkTWpLQWthWnhnSkEr?=
 =?utf-8?B?OWRoamxUbktNVDUxMnNhSWZ2K3NMRTJCNW5tYkllbmxuanV3NWJFcHZ2SVo1?=
 =?utf-8?B?ZlJBb1A1TDZQLzZ4cWF0SXM3Y1IvWm00OTYrbWh3WnFhT0lWYmxuakFEQVhG?=
 =?utf-8?B?Yk5NZjhpQ21vRXRGakVOUEVRYTBrMkkxQ3dhSGlwYjZ4VVM3ZVZPbGVibHRN?=
 =?utf-8?B?NzlReDhvRmNIeTJ5VGlIaDhqcmJiYXdTWGhGY3AraW5mb0RhM3ZWVGJSeTJo?=
 =?utf-8?B?VDI4MTgxU09aTmhJaXczbDFDbGgrc1lSbnVlSjlvV2FpN3g4MjI5ajV0cEM4?=
 =?utf-8?B?UWZkb0t3ZFFydkJIS0c3VGRRbW9OWnVueWRPQmFQeXlVVllhaFg2M1B3dHlJ?=
 =?utf-8?B?NGs1OGF4bGFlRDhobWhNQW9FQVM3MVdMdmVMUjlRUnh1dGkraEpIWmpOUndZ?=
 =?utf-8?B?TFRGVnRDTUQxSEIrc2tBejVIV3ZpY2lLNXZZNnY3NEc2anhIRzdRaGZOTUZF?=
 =?utf-8?B?dGlCa3lMZWdxTWpDMWs4bHFlNDJGeHIvSnkrNGlRNy9pY0YzMStFdVNMSzZY?=
 =?utf-8?B?MXdkeHdUWHI3ZFVyRGNGY0ZUQ2YzQlh6Vk5QUC9RSk43N2VQZE1MQllFMks2?=
 =?utf-8?B?UHRlZ0lNN2hjUU5ad1ZVTGpHdnpPS1JOOEYzMk9zdTYzYTFmYTY1VkpJa3Zv?=
 =?utf-8?B?MFZYRis0OFVDcnBzbGR3dmk1Wk9jenFsWWtPbS91UmlPd2FJNzI0ek83YWtr?=
 =?utf-8?B?Z2MwSUU0bTZ5NmNQMDk0L0JiWmh2cUoyS2M1K0xjV1dOMTFpK0pqcE03TWJF?=
 =?utf-8?B?YUZUT1oycEgyeG1yUU05RkEwYXR6ODRQblV3RlRET0xlbWFFTTZWMDVDdVhz?=
 =?utf-8?B?eEZBN0toZEk3V3lmVVVZL3Z3STBsQ3FEd2xlM0tlVjUreEpSK3VheE9KTXZB?=
 =?utf-8?B?eXZka0ltcjNFSUxTemVpYTNDTjF0LzRvQmsvN0tCN3BYMEw2L3B6UmVjSk1N?=
 =?utf-8?B?bHgycVZzQ09wTEFPQ3Y0NkdsR3VZTWN5VkZGZW4vaFk5UkhJdlVta0xEMzJw?=
 =?utf-8?B?MUkyNmMxTTZ3N0tRY2dmaWNaa3J0MHBub3g3VGtHN01lOE84Q3lPbjlzeFI4?=
 =?utf-8?B?U0tYWjkwWU9jcVExWklBOG5TaGU3NzhELzFGWGk3ZjBoeEVia1NzZlJEK0dR?=
 =?utf-8?B?VWhrSEFoaGZFR3NpM0NzZDNwSVRJZHV0WUpnb1MwbVZXeTl4clBzWHhXL05R?=
 =?utf-8?B?aWh5b3k1d05iZlpnSHNmZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHg5Y3Fla1RFQUtGaFBPOUxjWStROFM2aWtQbWhHKzdFZHJzaDJ1Z2pRd2xH?=
 =?utf-8?B?VHNFRDVBOXB3dkVjbThaL3BlL1hlOFB5ZW5RM1VHZTBDOTZNdWdDTk5rYXFa?=
 =?utf-8?B?SnoxeXI5V0p3NGFZYTZ4Wmx5WXNuaStlb1lIUEkwZDYzVUJ6NDJPa2RUd0hO?=
 =?utf-8?B?Qk1zdGJiL1FxY1dhZWczTjhDU2JQM0g0WXFZYTR1V3ptdStoeEFHdWdXekNL?=
 =?utf-8?B?K2NZbkthaDEvaWhzNUIwbU1ud3cxK2NUdGlZbjNaVGJEa0x6MUFIcHIvNVdq?=
 =?utf-8?B?Y3hzeFpVNnNzYWh3Ukx2VzY2RG5yM2gwRFB1cS9xS2o3a1d1S0NPVzhLc0p6?=
 =?utf-8?B?ZjJLaklrQUdvTEd5UUZXWHZoL1BMSHhPWGM5RlZzdngvRjczbHIvdDgzbHJJ?=
 =?utf-8?B?K280VVNiVS9mQkIxVzRWYWZWeFJhSk9XR3U1SXVESURMM1YyRUltT2tZTk1V?=
 =?utf-8?B?cW9WdEdZdTB6WENweHFETk5TSXFHa0c5V3gxQmQ2R3BlN0g5cVVIdE5QQXJQ?=
 =?utf-8?B?OW55Tmc0eDFKNTEvelYydDZMN25TK0kyNXZ6NW12b25yNkJ1NFROMzNpZVB0?=
 =?utf-8?B?SXlrajBobXpuTGQ2WGg3OHVCN09rUnBNZGZRTCtYU0YyZ1I1cjlxYUpzTjN4?=
 =?utf-8?B?c3NyRnlKbkt6V3p0VDBjK1dEa2x3YXRRdXlNWmtQdkNIS0tTTWkzZExVUGVY?=
 =?utf-8?B?ZEMzdlkrUGJXMEhreEJrbFlZYnRwZytuWjZNdGVZYnVUZXBYZWJoam1HQnBB?=
 =?utf-8?B?djR0Yjg1SWVJMWFCL2g0bTR3VWhQVCtSdFRkSzlqcXFoTlA1Q00rY3VnS0pv?=
 =?utf-8?B?SkFaRWdCWlJzdXpZM09WUUwvN242bmg3aTZFbUxlL3BhdzM1ZVFiTjFEd2xD?=
 =?utf-8?B?R3F1TWtOWktZZTNrSU0rbUNXVWJDK3NKNzA4NFFIK0lFa1hkeXlzZi9SQ0p5?=
 =?utf-8?B?b25FMjBWOWxwR3RXQ3NXMi9nZVE5M3RDRHlxSzNBSzN1UGJVMVJ1M2FrLzJr?=
 =?utf-8?B?ZjkwWVgrZTNIbDFaTmxEL1NnMHp6TzcvdUozS2VQbnJ4R1hpU2piVjVEVGZU?=
 =?utf-8?B?cG11NG5zNUMxd05iZXRSelV4N28rcldiQ1lrbUpLVmZPVG9mTk5zRHRkdWVN?=
 =?utf-8?B?eDFqZ2NySmdlRC8vaWlDbXYwZTc1U0ZTTHVIZ1JCdXlzaUZqSjdMK21aY05o?=
 =?utf-8?B?bG9yYUxzeXRqenF4NVBtaGNibEh6cG9EcndnV3A2YUI3TEh4dnVWVWt5dEhW?=
 =?utf-8?B?ZGRGUkJ1UnJCTHk4L0YxdFBZUzRmOG9CK2YyaktLaEFDRjhmd1o0elE4WkVN?=
 =?utf-8?B?c3hSeCtBdmdmR1k3czYwT0hpSzBFcUVSaFF6M08xazE4dld4NVY0YUgrYm14?=
 =?utf-8?B?WFF3NDZBV0xNVjFTTHFreC8xVGk3VjlWdWN4TDhIamxBNElRaU51ZC9lN0tD?=
 =?utf-8?B?N0k4dC80YzRPWU5ZdzBNY2wrdVVhTndiaUVzcm9yMFcxK0orUnYrMFp2TVJp?=
 =?utf-8?B?OEo1eVNUb2NTWFNscEJjS2tJZzFnWitjRE1yK0sxY0JkTHpSVHY2QUNuRTQw?=
 =?utf-8?B?UVJzQ3JGUGp0cDdrNHdOcG44WjhjVFVnbUhER2V3KzBDUjZmZ3o1R3JpOFFa?=
 =?utf-8?B?ZFkxOHZpTVovZk5tNGxWb0x5WjFOK2hwZmFaZThhdDZpUk92dVFDK0Raa29h?=
 =?utf-8?B?dnBRYkduSzExeHY0VG0zejhKdmhlZWdrRXJpMWFhWlN5SXNycmVMOWRGN1Ez?=
 =?utf-8?B?VjR3Vk1PZlBqRWpLb2MwNktGQ0RRQWVNa3lFNCs3OTBuUUN2eDM0T2VIMk5p?=
 =?utf-8?B?b0g1aExhMTNYcSt1ZGhtWEJLQlhSMHFjQXJsT2R5Tkh3NlAzRHh2RlRwV3NI?=
 =?utf-8?B?N0kwVmNydkpteFZYN3poTEhqVkFZaTVERmNJUkhkNG50NDd2L2lZMktic05j?=
 =?utf-8?B?cnJxekFmRmpJbWx6MWJhaTVMYzdZMzF6N09kYXVseUROWGZuZ1VXOTF6b3hP?=
 =?utf-8?B?R3BvL2kyeEdkRTR4ZkNFb2JnUUhXU1JvSUUwV3lFcnNzYW9CWHNKKzR2WWtj?=
 =?utf-8?B?eWltS3NnMjl3S2d1UHBady9WSHBsV2xhTEljOVBURVBBT2tTd001WnlVSy92?=
 =?utf-8?B?a1FYeVZIUDk1NGQvaVRnekp3cHpIVi9YY28vR3B4aGI0VmhMZXY3RkhteGJr?=
 =?utf-8?Q?Asvvi866DVn65wCH7oySBSA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cjLWek1CIAEVzDjPn/NxCYZGQUvce7pkAwh/9/dxMXngKXi02TFcNV/QtJz8eQ9t/9vVkoibaVFimgsMcjFCswg2/jU9Bzba9+k1HmHUaURZtU6E6Dwzp1/MesOdWef6aMnrkyJjSFOD4tuquvG2FcXfyjh1wVyC0IdDOxrJSatQHIVnDjctWQogTLKMUBVTIJsHJ6ds0rDJJNkrrQvgS0dJ+QG9Xpljd0xntNQ8UC4cOGASJFkiISzvlhS8QEmUFTlb5C+x+/14U6NlQd/JrSQ+trNniyWImX7xIGOBtRhh6GhlcaAirTP/az8sdig13T6xISJxhZj+yqdKVBH+4wwqbhtBUzYHK/kVoKcK8TorpdTLFV7kkW51oQXBjGXBRYkYsw8DjZsQOPOLeLUWhvffCw17tIQIBxqTOG8Bz5O6GoR0DxYSx24LIxFJQ5mfncpNEBVb72HiTPmQozd9AnqUhc54wjZ8FuMyOVamUbjvoQe1TKOU60UWM9bOBVEu8G0HCsY9z/XTVoX+JMQ81b+jmbYgM39qjQZ4smQbENIQQN56ybQGH+WhLpIC7EUb0Ewmv3QdoQtbfdDAHDpkI7hEXj70h8zavfNNT1FTRPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcbe9bc6-ed54-4549-9478-08dcbf8e03c8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2024 13:59:45.2374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbN1XX+zVk+AlGwNGp/QKNagsYsg1EZGcXCpDar9/oYH5ZI25fjmSgRKU3zZNpIO/gIB06F6aTxJXqZOFJa4R+vI6U8KM2gT8ZqcurNiM3Czm2SNVBzXAVHs5ziJnqb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-18_13,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408180102
X-Proofpoint-GUID: M24vjsX1Uv1UpsIGmHJO0p5Qqz62jLEf
X-Proofpoint-ORIG-GUID: M24vjsX1Uv1UpsIGmHJO0p5Qqz62jLEf

Hi Greg,

On 17/08/24 13:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 479 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Aug 2024 07:51:05 +0000.
> Anything received after that time might be too late.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

