Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EBB2E8B91
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756886460; cv=fail; b=CwgHVmL6217x7EWIeLootWgEcp5CHIjkeqSs/qqS5/JRoxoZI93ODhNlE/aU0IGH6Qtg3Fl/RDFMRfDrLvjmMCbNtDTN0Z9UseDJEbFXSXVQNGbrmpLZD1ih3m7pjmaxe6gaQaKP9Eykmka+6QJyylxVqvFlkwMv3iBcanop7G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756886460; c=relaxed/simple;
	bh=ERFoY/xapSj/Hrdy9P8K2huU5i5Cv+Ebu3k0G76Iw6M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h15faGiisD0PWZqLXQjYrjCOXeAlsgKlUPSbvQzIWnUqnmzAnjX3h51G1VVYcZHXsod4clHPYh1JDHYwk9lZVD/M/N6jRjI5v9+B9ZOMSRvmOHTWNoDXGqbyyBDpefY7HMIMrLKNYpC+NVBTnPX+Pa5EKOkfE4CQ/GEin8qYJXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a1v41t1U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x3ZbtNG8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a1v41t1U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x3ZbtNG8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5837g6T6031473;
	Wed, 3 Sep 2025 08:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TF1R9PoT6TKuTuffBcNBJF5iy3RVljJuAM6QgNJZJrQ=; b=
	a1v41t1UWbi+SnOLYUavecZuMLHDlid8EYawKX8XnwFPxs7kuwoXaE/a6+G3xcV2
	0AKxFrHsMaDxWbB2FcCPfwjRs44823rbeVHhK9+ksKB40MF6C2hTfHdS1gcBHNF6
	ihTXLQobkZxgRjp1Wc/80pWsI970B9u0qYze9QqA7Iduy+S1/Xv7f5+cksp5a/D3
	bHYllnzlBk4OQWHaBTrmDGUV+LQ52qAb/zZY/FXV4cFd+yP9tYyhI52/d7aAa9kp
	XzRWgCQqWcJMfCrOUf2waZ9H/gvDFxtDr7r1M7nZuTdxTjUdlnu5myeUj25tUZ5S
	oJ5bC+TBTZTmE6lJwPzHvg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4n6qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 08:00:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58377WcO036264;
	Wed, 3 Sep 2025 08:00:22 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqra25vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 08:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PmjFj4GRkNxuS5TdSbt3kb7q1buzDBFI2fcpmG0jFOmf80oIuguOA5Ply5kp/zZIlZporj9+kSWDP4GepwyHBC4aVTGZR0wjzAcSwWhbaf9j8q1EZNiR9ZGUmVW5cWGy7zHKpCZVc0w7UOUAx66s5IK6H8sbrPpghu6Fy7a3seHTArtcAcKxk4LelRHSzxYVJawKz/qDfEWgwzkTgyEX4LsobJkkNVUZrj/E3CEc8lhxueOLMRv9PJAsrmuXE8tEmXgx+iE05kVICfL7KJR+b8UyoW9ryBITCLt4HmS4WfmBBCGTYLvTsNtdOwEAC6+kBTry2QFf/0rJKHVmNZ+XLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TF1R9PoT6TKuTuffBcNBJF5iy3RVljJuAM6QgNJZJrQ=;
 b=gfdo9bwSBkLTqGMDQ7DzN77PmQYLcqfgQT3OCyWOCxmix1cq5EUxdU1EeLIM9v+Wgz2xwg2z6TvqBGEckjE+mfOG3blBrdCGilEj+X1guT/tc+Khjzreofxac4PHwCvpX/f/XSkbvFARk1UE3dXX6rrgeAKbaII0cQ43I14sASfzsjhW5Ed9fIvpf9U0Crt1lRL2Qo2cIvNIBUDO53zS2FfpUmVi4D5k3XBBQVFv7tWLUyun63WvUTkaVPE3CtYyfKsuaKFIdQ2W8XFS2vgqJDWTgvkXPlQ8gI0/tTh+/4CoOPUlDlr0/cPS3qvvoIIaggKk1wmpSVaUv4aGE3oiig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TF1R9PoT6TKuTuffBcNBJF5iy3RVljJuAM6QgNJZJrQ=;
 b=x3ZbtNG8p88SNe9h86fdpWwnA5u+6dIVIfGRmeiplWONebqd0u+TOvnNnoM/eDVS/wzp30pEpZHt6gEC/AD0d5vKCHw28zCqm18VognA0FdFO09/K0orSBfgoGTGLgWFf02jJHLTv+c2eZHHGdJBaC8xrvkYoSd6qGs40dma0Xc=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by CH3PR10MB7161.namprd10.prod.outlook.com (2603:10b6:610:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Wed, 3 Sep
 2025 08:00:18 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9052.019; Wed, 3 Sep 2025
 08:00:18 +0000
Message-ID: <bde0c1ef-ea04-4510-886e-0872f72cea07@oracle.com>
Date: Wed, 3 Sep 2025 13:30:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/33] 5.15.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250902131927.045875971@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0421.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::25) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|CH3PR10MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c0ed1d5-765e-4893-58e1-08ddeabfebd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTFpQlZOY1UwaWFUYktMbXNZVnJJMFZYdjZWTHJpQlEwazhzU2drNTB4bjFW?=
 =?utf-8?B?OU4xd1dsb3hnbkI3Vjk4V0lTWHU5WHZrUkEwUUdmTWhOdDZCNWpQZjFpZk9M?=
 =?utf-8?B?L0w4MGRTSzdKck1Oc3A1ckxtWkN3L3ZicVo3SzZKc1BPTjR1clNCcCtqckI2?=
 =?utf-8?B?emJTbHJZTVAySFlhWEY5MGUyemRzdnNWaEpmSkljWEtkYmhHMTdJK2lUREFm?=
 =?utf-8?B?aE5Oek82UnJ6NkJVWCtKUTJld1RFeUNqUkFyWldkUUxaSitjcVZER2ljN2xX?=
 =?utf-8?B?YUpnOXRYZDRKRWFkMlNOUnZ4ODQ5aHpZbG9CWC94VVZUMm1iYjNxbHZLcXNF?=
 =?utf-8?B?UTFlNDNKMGV5NzVyaVRyZERmckR1dXE5bGl1QjR1Q05KdTF0Q2VrOHJtUGls?=
 =?utf-8?B?dFIvK3Z2SVFSM1VoU1JtYWhXVGJlemNEVVZTMTdPZk55UFJZQk56ZWJPWm15?=
 =?utf-8?B?YkVMZmR4TXRVVlJacDBBaDFoS0hWOVk2bXBiVHFCYi9Cd0swSk5oRzdlRDBo?=
 =?utf-8?B?WWRnaG9VcnFjWG4yck5FYm1mSmF4TC9BRk12Qzh4bzYyeE42cldobVoydWNr?=
 =?utf-8?B?MXJNS3RuNm12Ui9XOEtUVFl6QVdYMkVMcCt1Z3E4M0xnMHJhdnA0MDhZbGhT?=
 =?utf-8?B?aGVRNWg4OUNCbXRHL0FEdi9qcFQ0K05Id3ZqdXh5LytubkVKckRBZjNoT1Za?=
 =?utf-8?B?a2ZaM2VtZnlrbXdrOFlGSVBKTXBiMXRYb1VaQmg3VWlublJrOUN2WDk4WlFL?=
 =?utf-8?B?RVRZWUJoM1JHbkVSTzd0MGNUYzFmREFMUzk5VlRkOGoxYTEzaXVTR2FhUHUy?=
 =?utf-8?B?Z2RJSkNOWW52R0I3UkhJaCtQNDkwaVdaQkF4ZUhOa0pCMDdvWmhuWnhIZEk5?=
 =?utf-8?B?eTRnSGhZc2oyV3lDMTBXM2tLYjBZekNFcWlnRGRTbzRvMkliYkJxOHA0YTE3?=
 =?utf-8?B?WFNWQUFBZHF6V0NUSzd6UEhqbThYU2tjNmNyL0hHWTVqZ0RGMU5YZHQ1Q3Rp?=
 =?utf-8?B?Tko3eTdJdVlsUk9xMGJIZ3F0R1lreXo3c3FseXhOTzNBc2JHZHpFSzYwL0Qr?=
 =?utf-8?B?N2Q5K2hrMUxKbXJkNlZHWWVuNVR6QnBTWnQzZTVya25SYXVIM0owVkVOSVdx?=
 =?utf-8?B?bmNMeUFDV3dZYm0rbTV6cW4ySmxrc2xDaStDa01sb2kvdndYSGhvV3h3TjJz?=
 =?utf-8?B?OHVmOFRIQ0RBMzB5WkkreE9OcnVjdm1KTXhvbVc5ZE9US3dDcFU5Z2ZqT1JL?=
 =?utf-8?B?ci9aWHFrM2dSb3lObmdWYmV4enR4WGZHaHl4S0VIT2tHSHRoRUh0RnQ5dkpK?=
 =?utf-8?B?S2VlZE5LeE5oWkorV2ZLMWd4eFRhbXorUk56MUQyTDlQV0NmOFk4bXZHYzNT?=
 =?utf-8?B?d25kUkZkWXM0NjJoaHJmVFFvR2JnVmwxOVFtSEZHMnlScDVad3RJNFdCZE9u?=
 =?utf-8?B?ZEltcnRpbVh2MmQxby9sZzkxUWkwcEVTdG93cklVQk1EWldMRmdQN2RiYkJL?=
 =?utf-8?B?Uk1xQUdKdlJxNzJOR3NOR21IMDZack5TMmVEVlY0ODlLV3l0OFB2c1BQcmtL?=
 =?utf-8?B?WEtSUGRJK0ExWXJNWjNyM2gxZS9KcjcyQ2NKR1NFUG1CbCsveXFxb1FybXpV?=
 =?utf-8?B?VnAvenJIVW1sNlBDNDFRdkdpdi9HaHphOWhDSzJTOGVzL3ZXeS9TK2FBeXpV?=
 =?utf-8?B?ZXNzL2YwR2ZKUk9HY0EyZDNMclhGMWo2SWtpSVo1RjFtNDRsZ3kxMFVnUnpL?=
 =?utf-8?B?VWpieTQra3FqWkQzR2RYRjlzNFczbWZiMFFQeWVJOGwyUHpNelF5aENUOGc5?=
 =?utf-8?Q?WD7kaJXGWmKo/puuZ1PTtn2d73hoMdquZ+0ZU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2VNVVV4M0xqWUxxa0x5OVIwZFUyaVZlSEM4ekp0OGR6eGJNVEhvOVAwcWJt?=
 =?utf-8?B?WWZEVU1CMHdzOVc3OVAwVnA0MFBwZk5UcS8rWWQ0dnRTeUxRYjZncVJUNFE1?=
 =?utf-8?B?enJKdFFOb1ZrSUwvTnZ6cGhQN2xnS21mTmZlL3RUZThJbDRyTml1d2hrbG5T?=
 =?utf-8?B?bUFYSUpDa054eTk5bzlkU0dwa202MEwza0M5akNycVlzai9rcWV3S3c5NGQ5?=
 =?utf-8?B?akF5dktGOGxpdlNJWnh5VlZxNUppa3FlcnY2MWVkWlAzTW9udjJUdGMzbDZr?=
 =?utf-8?B?NFZ3czlWNHpmKzJudUYzcFFPcjRwemFWdGFQUy9MREp4ajlvblRvU29sYkZI?=
 =?utf-8?B?R3UwU0V3UzRlWG9FNG1ycFYwY01jSG44TitxRHUyOHgrN204V1V6Y3Q1UGRt?=
 =?utf-8?B?ZWxyRHVNb3JQS3FGY25KZm0wSE54dHJ2VnY1VWt6akM0NFhYNWluejFaVGh6?=
 =?utf-8?B?QWlLbzBtdTdzaWltNmp4YVpKZVdBaVpSWGkzaklzeC9WVHdTREtOZmg3Y1NP?=
 =?utf-8?B?bHl0RW9MS0Q4Q0NXU3BSL2dnTWtRcFRHaXBSN3FRUE5TdVdXRFMwT3NwNkFh?=
 =?utf-8?B?elBCZS80K3hYU3N3SWQwcndZVFlVbm9DK25sODIxRTNjcVRNMW5JTGNkNWJG?=
 =?utf-8?B?QjhQU3c4bnBIdzJNYUtUR0JLR0ZoY0xjM2xObGR0Vk1yTjUxZGtQY3hJYTc2?=
 =?utf-8?B?cmlvSUxpNnpOWUFrNXBkcmd3S1VYN3dZSlpHalh0cDkvblMvL3dhOXYxaVRI?=
 =?utf-8?B?ZVllNXU3Q2txeFl2UGwwVnJvVU81Q0JPSmJKNjhJYjdqL29oZHdxYmVWYlQw?=
 =?utf-8?B?bXZnNHpLT2h3WExDTkt0UUFxdWVpVTdOOElyMjlFZjF2MTIrQzk1amF5UTha?=
 =?utf-8?B?aWpzckgvdS9ZNHZmbExtc0xNZ0hRdU9lRzBVMFl1bHpRZGVBOWJqMmQ4UTJS?=
 =?utf-8?B?UVBJdll1SUd1VnJIbGRjeTU5RjFsb1pHcXB4RlVtMGY1dUNZeVNueGk4bDVo?=
 =?utf-8?B?Tm5KRzlYTE54Skl5eXBMQUZkN0QvZUQrWjhMSGhFMDhRM2x3RTJ3QituTy9M?=
 =?utf-8?B?MTMwSHN5NkplbW9pQ2FSTXZCcEY5TnBvWEVncDEyMFBVelBNMkVrWHdVS3g1?=
 =?utf-8?B?ZS90OWV5OERFdTlGaHpTU3pEMXFPZkF2TGc5V0lhYnIvQWd4VWhRRUYzMWYv?=
 =?utf-8?B?dXFYc21oaVN3T296NVdhbXZuN2hFWnR3ZmhNMUZVQ0dpdDF5cERqRnVSSUtK?=
 =?utf-8?B?TVN2aGFlUDhQZlJ4cGJGSDhzNVdDUFpwWlY1QXEzVWs1dmJCY3RycG40bXNy?=
 =?utf-8?B?ZEo4d2l4Z2hQaGE5d0VTOGVTcXlIK3dNcXJFRFVxQlN6MjFCdDRDWUc1NGhT?=
 =?utf-8?B?WWdHQUdySHMyMEFIQ0QxcXZHVFV3aUJsSlBZZ2g5aHJwaTFiK2FwdWtydGNy?=
 =?utf-8?B?eEVVY3F6R3hwTUwzYlFhTlc3UVM3MVYzblI1eFpwSldaQk9EazYva096MDZL?=
 =?utf-8?B?RVo2cjlCbXp0VHIrMk5rajJGWHB5YkpqazJrbFRwb1poYU53QmtIZnhCZzNV?=
 =?utf-8?B?ZDZqMnhvZXRLMGtXTHBzNVNWY2VSL3dKcVdUZ1dvR3A4aTZDQmNudkJQcmFS?=
 =?utf-8?B?ZUJuV2s5cStHT1o4SkdQNVVjVGQ1aGtRMDZrUlYzOHI4Z1VHa2R0Ykk3c2c5?=
 =?utf-8?B?Sk5lUUMyZ2FCcE1PNWlJOExKRFRVcEp2T1RGdmlHeG9MTThPcm9aUzFMajVU?=
 =?utf-8?B?cGFNdk9ZVWRQODRWQ1hlUld3Q1BFRXBNWXl5azErSkJma3ZWMlFtR3NiWFpm?=
 =?utf-8?B?ZjB3bnBKVjh5Ujk2ZE1ZSnRoZ0FBWHBEU1JmeG9VMUhWOEttdGlpZzVmcmZ5?=
 =?utf-8?B?UEl3T0IzMDhWbWlWd3VnSk9SN2dybzNLQkhkMDN2N2JydjRqaWE5U1cyYkpR?=
 =?utf-8?B?NnhXSkNMR202c0paYkVSS1JKNUJVMXU3UmNhU3k2UVJsMVRKZ1BmNC9nNW92?=
 =?utf-8?B?TjdnQmJXbjE3OHRBd1U0U0Z2NGVKRExRNUtFZDBUR0hKb2NmaWVXQjZadkZU?=
 =?utf-8?B?bDVEQTUwQ2VpRThzaFNKRGdIaURUNm9leWZBYUpYaTBKU0Z1UEFpWUhOeGQ4?=
 =?utf-8?B?ZG0rcVpVUEFhVjdTZGR4K3VZUEhmbzBTbXo2QTdtdEZQQ1pjZDBwNFhhcUY4?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VG7PIs8MKPSiYTUitiUHJbX8QMTa1/gifcreRFygjyw1S+EvFKTDCbxBk+IPAyDuAR7ZQeaBzelhchA2lSHiu7jCA2oHTnEh7NibB+19vtOX+k/WXwQsU9FNxxKwS2bM3f7UChZ+9znlyDCGlhAJYtuqOdPC3/MjP1jYllemooqGl48s+dboS3Yta8Sx/QmsUHiUISnWvFo0aAHjdG/chEyPBeFSFxT0SIwKplgQ0gjKeF+dO9jXdFkK/JVn2dGokC7yT+/aPh1L75/Si2z+HkN8LbiDlCKr+hB7T5gPSomdH7t6ZSpIWmQN7Ug3CpMEVejS7ugEDW3jHVtkVCdXNCDbchpoONFHZwn7nSROXXHhOOiCqBK9oV2MO12oMdl184DoptVC+gs5ilR8SAwbSv8g6LzIXe8bL6+LO25kMXqA9j8cK7Y/weZQ3r0fLSLMIUQ92sG6522ktp//FufeqYbWHDHQZCMxYYVS/n+Oz7KcftsdWv+Aa4o5DB4JGGhW2H9mcN0lwUCI6m1gWlPnx4OvfqTtbqz9HgrN7uOGpdYtQKfC92FyL4Zxc/fC87NnCTi2b5HnnwJRPbZFuhJIxjr4+XIES1znealqrcPtO3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0ed1d5-765e-4893-58e1-08ddeabfebd6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 08:00:18.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 491fEV8V/zICzpb/6pVPGKZm48E/DMlDp3PmS78Q2wDduXOImz3rn7gpH3wsLHz/DEwqflRIdRS8da11JV7Zcz/qXzNbVDz0/UC6Q6/YicY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030079
X-Proofpoint-ORIG-GUID: CPk_5UQ2kNrLExXnO0xvpmOsuDFLHe27
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX7WAGSRI9C2sW
 6SBb4znB/sGi1yEJHpW5qpHUrtU3PSdiZxNvGDkJqpLMh4NGY//+XaAp3rKlCG0BN/rnRhkOnDl
 rlM9CaZsVuCzfDtxYdLEMtzuWMI8Q4b6Iym6l5abf3pLhPyc1sXLE9gU3qllQwvPukfUCM+a0Ld
 pm1+zYTRFi8W1ipbKa9M6Tzj0MOLsIPqxFZXtruNIU4vy+dKPacw0JGz/paCZjEt3welwR1zPEG
 n1JMNUavLUnwsorV24Sk95XKttjWuRlIfEoODujBgkEe2o44c0k1jZqAbV0sFQQl0u5GKHFW03J
 FCHMGI+dN8QecHQu4Y1ip7UMDYcrNHBGzj1hEt34tnuXA/rXgeTCzUhRQmKv0UdysonF5CY8fPb
 +p04l2Tv
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b7f597 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=wQHQzwf_Hs2TCVCgcZgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CPk_5UQ2kNrLExXnO0xvpmOsuDFLHe27



On 02/09/25 6:51 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.191 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>>
> thanks,
> 
> greg k-h

