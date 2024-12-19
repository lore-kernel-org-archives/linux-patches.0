Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD0E1662E9
	for <patches@lists.linux.dev>; Thu, 19 Dec 2024 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734599496; cv=fail; b=nJjKcG0bX6l4GITAlbdd7o+qiPz7kJIs/6fph2h9LrraR1NYTPBzx+WVpRkkoQvZ5JUNNZ8gXZtt73MMrWMxVBFErPSzuXnLkZY+Avs+1LpYIZSRgZCoxzBpjC8kdaoU+bt1Rj/PKEtloT5o5Lr8ofzdVSBUN4IoYdia2wfhK2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734599496; c=relaxed/simple;
	bh=7nuhr2p0ULmbZHvCCZrgZCQPeeNr+Vqk5n+hiy5GGp4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C3vN0y9G/RGNHAj8qqM3rZ/9SFEld4RPzf8uMmuenNaD0VFEMylXyh89pGR0ZqEQBolAncYiWdZgmEN3l3aud+YA1mQ3FyzHAsjRCleC58v5xKOIERFqjK3J4v6PRsbtUJBXudYvhr7PQEmVZvVzzS7iY325mmhEjzSfharCp1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mAYpHKG0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WtcUWIcs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mAYpHKG0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WtcUWIcs"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ1fpDa030726;
	Thu, 19 Dec 2024 09:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bBU2Bospkxugmee4is0L2c1Ai5GtUU3ciqfZIDq6oEs=; b=
	mAYpHKG06fFM6mIX9Xtl+Y2A8tFgiGn1ePSLTP8VRe0RgeOfRMLpJwwHw4hfW895
	KP0GB0A8sMRopAKidAlyRKNm0xZ5oXlnjlThA5o8qSsHkuHB49vP4KUatFyjdNbY
	QsgYMRcfn972GE/hDRkIoUxXkmliy2iBa6eSyqB508CFsdoE7jouyiteh59Nq8VP
	RAyF5U6LC+ZkqtjdU+aGHxsM7JT7Vn17JY+RoizcDLnKrEJL4MkcUtytDt0fkhwn
	2iPptAUS/HaTUfd1l4hAXZgEwq1d8vC4FWjeWvPbOynK3qivURHD4vYu9XAdsxca
	BTEb6ZEQ/vf+MLa8ewFl3Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22ctk30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Dec 2024 09:11:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ93OtL010890;
	Thu, 19 Dec 2024 09:11:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fas88y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Dec 2024 09:11:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkm/e4uQ9zEjXXDrGJ9Qih4fPmN5zOKp7FWXpX2jIGZ0mpWs0+dDXlNFQQ0kl2UvPJRN2af26mfT+RfNkCc9FyVWmBKgVkGNHF0Uednekxezxf6LTbkYpsj/gYhcEcxP8qam+OO7yKeVO+VBl5/S8yJFsRAT2FXqI71XEgadrSY0uftUW3PLG/VngCKn361WcqIx935yi562Mgm+sqQAquDswul7g+rC5H/paWvN7BI2G/P9oSfGP6E+xZdHyzU5MyJvM+LCNTYjEoADDe5Rev3bhqQQvLEHOJUr+E/no7LJuoUGysOOYaIQ066pcPV0PaYsjR5s/yOJDhwPdMIkPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBU2Bospkxugmee4is0L2c1Ai5GtUU3ciqfZIDq6oEs=;
 b=JL05s+3wrhe0Yqe8xRCeYBzkKioKUyGjp3ea487pVIX3R+tpnzmQbS6Rv5fffxdEFWZIUl8ki1w9VkxASDHrO7P51r/RS/5LrHtPt69Bsl0uVkCwWgc85170A3T72/UoH0CVp7boKVnHrnykYDA855F3peqku+fsH3i7WUNuBanXaQ9GZXlzJ4bWDSLs8DoSAmSmmg5RzDuqibyeixnZPGO+C45E3SzYcRpcj4QL5ZXgqbYPQBggTvCGNuyMCuVIRmvs0tsioDJT8BJBJ7vYZeDIaZqr3Y2UubTxZX8cVMr05pQjyZuAKY62aMUnBCk0DPtyt6Bp3/2kFMz5BdO+Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBU2Bospkxugmee4is0L2c1Ai5GtUU3ciqfZIDq6oEs=;
 b=WtcUWIcs1+CHPM1XvcUTYaDc/pbs3Q4pr+cnXYfOrJXkByg0pedzEwj3BHKsH5hKkuru357TnmRMGKOCDGa13neSIls5cOO/hYDR8KvzYTPa8cmNWFR8xmQcLaa7630AoQKv+tME8karzmOiQoaQLaDtkZcbTzbUZILSVeQhc0M=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Thu, 19 Dec
 2024 09:11:19 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 09:11:19 +0000
Message-ID: <847aa706-2339-4a7d-8476-23a1e7bde8b1@oracle.com>
Date: Thu, 19 Dec 2024 14:41:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/24] 5.4.288-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241217170519.006786596@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA1PR10MB6050:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c448f03-df38-4d6d-329f-08dd200d1967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXhIZHhORGJLZHZrckxQTjVFWlQvYnV3N0ZscjdnU2JyeUVrd2NkTHBLbDBT?=
 =?utf-8?B?MUtyOUlVd1RQUWtYUmJrWGVVQzN4YUt0VUdtZHJmbTB3UVNTSy9WN1RaRGs3?=
 =?utf-8?B?T1lweVVwRzM3b3I1bjdIWUNUSU0wMUZQTjMyazVPdktNU2JxZ3VuNjc5aVdU?=
 =?utf-8?B?VXFOYmpXbmdpSWFobHpqOVdVUHNSeHJPQ01MUjRHMEx0WTVxQ2RVcktPbUpI?=
 =?utf-8?B?aEk3QlRNK3NxdFhBQTU0d2lQYkI2RkJUMWZVYVpBVkl4WGwzMmYwYVpmMmtr?=
 =?utf-8?B?Y0dSdmdldStPQVJuNno0djFHRVdYbDAra0pOUlZ2TlNqdWdvUVUzbWgyUCsr?=
 =?utf-8?B?ZmhsNTFmNTBha25kRkxXNHVqZWlxb1R4V2w0NFRYRDg4dWI2bWNQV1ltMGxl?=
 =?utf-8?B?Y0dYMmNEemhiKy9reU1yQnZ2TkZtZEIxdTN2MDFXLzRESDJFVWhzekpJZ3d6?=
 =?utf-8?B?K1djeFRBeEp5MStPWGJOcHhuUldHbXNOOTViZDJkYStEeUo5cnFqZ3UraGpR?=
 =?utf-8?B?MjkrM0o0RjhrOG5oWlI1VDNqU3Rya0hBT3FoVDl6VVFUUERsZjB2U3orZDR4?=
 =?utf-8?B?em1Wd0JQVTBhcW56bWhuWFNaQ1N3NzBvN1RVT2ZoZFhHeDhXL1c5enRmYUdn?=
 =?utf-8?B?U0lMSm9XYnhXbHY1S0lQZ1h5L25ram5pQXlpcENORjRGaC9LelZwU0NwaGhy?=
 =?utf-8?B?ODJmUTR4M3B5Q3dTSDRHL3h1cWdWRUw1SllPaDVJZ1I1UWloUXJNa09KcGRm?=
 =?utf-8?B?R2ZPZFF3ZnVtb2RzbGpucTNaY1JCUmlKVEhFUUhWWHlFT1kzOTQwL0g3OHZw?=
 =?utf-8?B?QmI1RHozQmRoRW1oWER3UUU0SGFUYjArUDZSY0owa2g3bFFKUVV0Q093RVVv?=
 =?utf-8?B?S04wbVlKejRtZko0Ry95a2QwSWpncGwrTkZXMkNVazdER1IvMUQ4MXdpNFdh?=
 =?utf-8?B?SnJTWW9ZQ3lUMTgzS0RFdi9KbWEzZ3NOdTNkUElJRjBDdS9DN1o3UDZ0VkhK?=
 =?utf-8?B?L0lmd1NYSCtSYlZ6SmVXVGdrRFR5SWltN2FXYzNBcHgremRYNUluc0hHZHFa?=
 =?utf-8?B?SVBkMHFzUnY5YXFLKzdHS2QrV3JzZ20wRWJjNzNrWlYydWhHZ2t5TWxhMVBq?=
 =?utf-8?B?WmxYekRVSWl5L0p3QmNJZThSQ1JCSm1hK2hEVnYzUmxEbUwrczZZalVSd3hU?=
 =?utf-8?B?WDN5MkFyQURTb1dnaUtOVHBCUENDdHpIdEdXSzR6a1JzN1JtUUwvcVVYUisw?=
 =?utf-8?B?U0hMOTZUWkF3YjNzRHdkNW5wMCtsTFU0VDVySk5LZ1Bhb1RSYzV5eEk0dVRp?=
 =?utf-8?B?YS9yRURBbko3bnJwKzVMVE50TUQrL0RnczdtRGNjeWorREVWeStLMHJwYTha?=
 =?utf-8?B?OTZSTTA0Wm1VNS84RzZvOXhrYTNWbU9HY2NMS3ZPSWhxc04rQjZRZURTemZX?=
 =?utf-8?B?d0hCSm5JZnNPdlV0cEhiR0xidHVRczRzQnp4N216bHRIN256bW95N29Ib0pa?=
 =?utf-8?B?YTJuRlNzaXR5cTl4anFvZE1hUVBWWGNnZ0x5ajl6WEJoR1ZGNU1heFU5a2E4?=
 =?utf-8?B?TFM0MVZZL2dmeU1mK1FZMHlQKzdZbE1SRDFVYU40NDQ4RW8vbHRHUVBjakFr?=
 =?utf-8?B?aDhKYXliSzJxaFRid1gyNWIxQ204bDVTMXFHN1lVYlBmMEd0TUJOZElCTVY3?=
 =?utf-8?B?REdod3V5QWJVOHNvTVRWUUgxdDhrNEtXTjZpV2kvVjZoaUd4ZTE2Z3FRT0VB?=
 =?utf-8?B?RjJSQUxtenJEYmtYZ3JwSU8zdy90ZUExSzJoSktmOHBxK2hIc0preVJ4bHpX?=
 =?utf-8?B?VkZMQkZzb3MxNzJ5bEYyVHRGN3FBQktWUTdnSlI1Yitwb2JNNzRuTWhEZElp?=
 =?utf-8?Q?0i9ggZxpCVfEU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmJwY2ZPTEhPVGRsSnNIYXpXR0RZSGZCeURVRGkyZ1VhL2c3WHZsVmlNOFYv?=
 =?utf-8?B?QW05UFFjSHFoSlFDMjJnQmw5QTgrdVc0YjhQVkZHUFJ3ZVVyck1vRUhqQjhz?=
 =?utf-8?B?MmF6dXR5eWlZeFI3OWF2aUFkRkxvbFdZM3VoK1I0THhUZnhOaTVNUXZGVStt?=
 =?utf-8?B?bklPdGZVODZKZ3ZVQ0Q2bE95VWtpYU5pbWZ4SnR4VXpMQXV5WGZWVXRaU0w5?=
 =?utf-8?B?UUcrNjVVWXVVamsybk84UTVHL0FXNzJTY3hZaVd4OHJSSm1XU0tNbGRwUFcw?=
 =?utf-8?B?djF0cXVYZVVYQmptWndBQWlsNWovZlZCVVFzYW1VOWxYOWtzVmF1dXV5aHFK?=
 =?utf-8?B?U3ZBTUtZeE5UbzVtajljSE1qZUJudjdLKzFPeHl1SzdtUU5aRUYyQ1FQaTB6?=
 =?utf-8?B?MTBkRlcwWUwvcmJkVWFIR0QxeHNYa3FpTFkxOUlUSUpFZVZQTFJGMitnUTlj?=
 =?utf-8?B?dTJOUzlGeVB6azhibjk0K3BRRWhiSnNYVUNUV2Z0TmJtakFRWUhNdEhITW1r?=
 =?utf-8?B?MXh1R1g5QVdlWnVFY1ovWkpNelIzK0ZNNnBoQVFOQ0tBRERXcGY3Q1lvN2VL?=
 =?utf-8?B?UW1EcDZKalN6S2UrQW9RZHZMTTJLV3dpamNXNzNOb2p1MkpyeVhUcStiWGlR?=
 =?utf-8?B?cWdTU2o2dXFFMWNqZDFDL1hnZkk3d3FGS0plNitPK2xTS0IwV2FXOWk4SXpu?=
 =?utf-8?B?WXlYL29YeUlIQU9UT0pxS2ZwRjN5VzZCQThNYkVsd3BuS3FqSmhmY044aXdh?=
 =?utf-8?B?VitCUzkxeTRuTHk1d3pBVFpielpSSkc1bEpIVUQrMG1veUtyMVlDM09GcHVZ?=
 =?utf-8?B?Z01KbEZ1MzgxbTZtRHBET0hYWml6cjBURERpa3JwdytjemNNTlgyVmR2cU84?=
 =?utf-8?B?Z3RmbVhBSzlxL1lZVk1QS1hmY1BIVEUrQUc1NCtUdy9pRkxSemVBa2MrcXY3?=
 =?utf-8?B?SFBMME9pNHkyYjRKRzdMUU4yT0RFazVuYWdleEw3NnozKzg5V0pzT1RHYTdy?=
 =?utf-8?B?QUVFblQrb2dkUmVrYldlbnJmTlZabHptMFZSZnZGakxrLy9MaEZhTTRtbnNr?=
 =?utf-8?B?UzUxNjA2RFdiM1lLcDV2ZzB2bjJaakVZREloRkE3SkZqMVN2VjdLVTJtUXZB?=
 =?utf-8?B?R3l0V256cmZqMEVYdFlUVXVXSnRMUTZLK0tiK05hZ2FycGw5RlVkUTlDN0hv?=
 =?utf-8?B?ckpIeGNnVU5XU3RCQnVHQURFaGJ4RlJ1TU5iL2ZqWjBVcmI5aUdmdUhWamxF?=
 =?utf-8?B?cFZiRWlKR2Q3Um5yNXhmT3RZUjlyZTQ2RzF1QjBncitTWjhaWVVwb3ZmVUh0?=
 =?utf-8?B?eEVzYjZrVU11c094ZFpRaUJ5SEl2UEloNHg4RDEzb1ZMVlpwNE5NK1Vldk1p?=
 =?utf-8?B?Vno0ZzY1TFhJWWNiMGd0bitDalI5TXQ3K3lWelVKK05kMEtsU3dLL1h3UENn?=
 =?utf-8?B?bmhpV2VCdC9sSkM3QTU5TjRZR25XOEVwMEdPMzNISlpPWWZXaUVxM00wQnRN?=
 =?utf-8?B?SFNMZnVzODZUdzJMR0RnQ2kyajV4S0FaZWg0Ri82SVZ3bjhzK29jd3ZVMHZS?=
 =?utf-8?B?MzJNNzFDOWhVVWJHRWNSRkkyR2d6OGlLclpDTXNoVkNDYTROZlAwTDRTeUZo?=
 =?utf-8?B?eXhTNEx5c1J6Ykh4eTBXaXc2cmg5N0hjbGwxTStxbVZGazNRZURWY1Q1NWtm?=
 =?utf-8?B?RnFkNFA3aFFIYWxwVnJuYm1leVhPdUlMT2tCT1UzUkdUcWQ4clV6T0VZT3Ay?=
 =?utf-8?B?dFJVSnEwMk01UjRrY2FpZlh6dVZudmlrMFhHQW96UmxsSEovbk9oZUpXMEdi?=
 =?utf-8?B?OWFKL1ZGQzIyZDN0NElzeWd4TDVmT0ZwWkw1MnR4dXJJSng1cndxempWMXZp?=
 =?utf-8?B?a0tGOHJpZytHSnFma3lHYTcwbVhCcmUvYjZiUjZpd202K0RpcVlPMGZUWVQx?=
 =?utf-8?B?c0dTRE9PNHJMSHJudURMNi8xeFBXUjNZSnN5Q3BoSmRaS201OS9tbklSVFlX?=
 =?utf-8?B?SXhYKzl1NDR2b29Pa2NxazBLcUkwWFdQRHhKUnlXRWJhNHovYmlCWE9tRUVs?=
 =?utf-8?B?c3BzV2cxL0U0Y3dlOFowSFJTeWV1UGU5TkRBREZ4RXdIeno1ZmVuNWpVSktX?=
 =?utf-8?B?RkhSazNpMlhPa1ZCd2RIcVJwZEo5cVJnMHh4WmVNelY3S0lJMThVRm9MRnlL?=
 =?utf-8?Q?SKK38opNFRJdBRBYwF41NYI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+B7s0PtYQ4WgHTyMhYcYiLd02xOulBR9O/uEW9tMPp4bTEpRObJIsn5QkU+WHlwnF7dw7lMw3ZqHtbZ/pfuCzrsvvGGnYlQGSUi20hd0QBXtZHmkX3NsMLVCMkFp9qYTyWoQgJjLcB3Vbmu3zKztCfC8Pm9QZRc+e0btUHTbRqI2U99yH2VwPv9qin9faBrTApExW7dNUOt4NUJaRWWUPqia2tnCdnTf16KNXhBfev6pscX3QsArWI72W/xJlXDR+2BH3x+rEJqYajwFjO24wmxNuucStxKu6XbJ5bspTsEmyfeMC+Xow51LG6Wv/ClE+pldaqcw92aX7+KxDwNvbnN+ExRPbnc3Pqp5xw1uBpaWvmKzZRDD+xh91XeLhNj+Gho/t3O0SPd/rjKYU6HLABTz2uXboFBzA/Mo4WpmCFWz3hNNbY2AWYMwH1NEeJ8EoIyyh93POhsjv+KbwK7N4T4d9sKgDy5WjpYd42xIsoXP+jyfVroYgByhu1mhyELw3ecoIk4p5dDvNs7DV3NAS0nfc/upIUTmDjSdk9vDMtZc76+q0lmAKTdCcHnfBv758VxpJyxGT0ldhMU6CITsFF5kmJhkft/kfIv+gt8ZNVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c448f03-df38-4d6d-329f-08dd200d1967
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 09:11:19.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5n6v+lIAX5DoYAX1b7qVIOYdS3LNy2M5tOFNebnsjUQ/jqmb9+BGO1lRrlGJG0I47lma7yFa6Gtmj+dXlADfXrixC9Z/ZjWBQcFJQyqpGMyfL2jC2ok9AHlvDjx08FRW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6050
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-19_03,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412190072
X-Proofpoint-GUID: I29ivhG2mhqVOEClEEAL4tjhQgkjomBX
X-Proofpoint-ORIG-GUID: I29ivhG2mhqVOEClEEAL4tjhQgkjomBX

Hi Greg,

On 17/12/24 22:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.288 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
