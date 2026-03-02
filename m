Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E0D2DC334
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772474341; cv=fail; b=ckZ78/H8Rq4jrE1jAK+tVfGAgb1oPAdOT2BZABvEPiwQ6AgSLAhJzPF4nD29NSs6VEZVxxs8xoZtrSC96VuzzNCwDzaVRPK6kWYvFZtesDZys8hefSSbZFCEpXDZ8C/Srs5kdi8CRW1jYeqGKFRKOLshTVJu1sQy4DjEVea+wJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772474341; c=relaxed/simple;
	bh=+QRLiFCOTFqmZdOjKh5kRA8eUwJwOWasfeUhS2UXyv0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=erCRvWbMjDa6di2NQyPYEP/H6UFTk1niK2LzEkDKJ2tfsQY9XVLtfar/4dN9ZCyxpsJr90XKfeAKQ7QwWuVG0wxoYbXWMma7MTvidZJfSNj+mxKzTK8MJ3zLBm/Ane2bPXzwdAdoVAv0SdWdF3IIdux0tetbAeYMwk1/z7fQG5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UKRFj2er; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DnNT9NVL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UKRFj2er";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DnNT9NVL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622GH22D3803376;
	Mon, 2 Mar 2026 17:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+isTyXF6IDQMzU2NKNpw8tY8fI1qdfqY3j34aOmSmO4=; b=
	UKRFj2ercDcJ1grGfXl8trNhaXyyqoJC7BuGY830iz0C6a11hCB3iTuP3qOnEvQX
	+ndOZAabGvefba4n3prN0akfh1yYylG2D8RzMxa5+Io4Sed2WnxbyAXUSOS31eRQ
	SOQL0bDt+wJVJftf4LH5ESgrxsNr7ZuE5XPQBAsFRIQ4EdzSGhgomJ+Ba4cTlhDH
	KwL+VzBdiBMUQNqz8bWXXtOqswjvQikMgQgHjZL8ftEG83hufcWOsK0BTw/JJbpm
	bLUSh3W4Z+5J1mMKPQjlqpj6pc+F9Xd96xONE7Hwd83LeBKJgNw62JudBJb51qph
	2NLKOAv5LoycRzIgWUWZag==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cndxer60h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:58:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622HSNiC036916;
	Mon, 2 Mar 2026 17:58:47 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013002.outbound.protection.outlook.com [40.93.196.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt90bhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:58:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCkc8l2OHhURAbC6emmWUnAIXFhlxqEKlQoA2HEa8mKXaf4kjCkZtX5RYMOzNlf7EqUQ9s7MvFZE9huTFRsxkCp43HMBzfvJqhzzP+Q/wKVLteciPZhFiO+qUpkRLT8m83oDXstgbVIf0TDkmio9A8RcKmSFJnotlDrUdrsNnshOKolpPR1sujD4BFXe4On67MreYIkZmek3AYIThOUwORmpP0TAsGzMqzwqDk6wzXIIMwNb96SDa2JSHj6qQ27ZG58NeusGzg4LBbZ1RxO6PviNti9RlEwjj35ZgEuCyAlbWo8eR+OpWWBACFJc1XTTIl4f/dd/z+UkxYFsFy+pWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+isTyXF6IDQMzU2NKNpw8tY8fI1qdfqY3j34aOmSmO4=;
 b=i+dQGztALa4dGKBSF4VMvu2e9r4Bw7zybswdeeLHk+2DCW4i+wTkMgeRMKfyHFKNYJmbvBncglc1Kosdnl6Nn+ixvIHW40kQ0N0ku6Gg95EwgbMKsLPkCwXeAsQH5eZsQktJPGWWFdDV7cu7rM2EiKKFLoRBkJKKLjTWetGXJgwYnRwkHkU9jDx4/GJ9KwDTbDSHbMmhty54P5kDFk6wQg717VVGds9pUZWIOfHJxsQqo/ihvbJtbH6s0hwKGShND9NrEEPOhS65iWTcXnDHuacTWfexheT25zpsLrSlSCaJgLVH9uyum74KM54kaMMaNdmnYvAO6GfTuXNeMxblMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+isTyXF6IDQMzU2NKNpw8tY8fI1qdfqY3j34aOmSmO4=;
 b=DnNT9NVLD6oEzYk8UeQpO2E3mgY5WSRxiF/Q68LBis0YXrxq3zxSmy9rvaaO7+Yq26/pgVZ4XVU5T3+LtWXv9S440vs3p5QfkrzlRYz4npJLN7h1E1fWam/JvivmGhNF6GMb6NVZAqY9cxVROFuufYiSHbaiyhmblJ1vrSFlEvQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV3PR10MB7939.namprd10.prod.outlook.com (2603:10b6:408:219::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 17:58:40 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 17:58:40 +0000
Message-ID: <06e95a5d-70c7-430a-8caf-7af0da26bcf1@oracle.com>
Date: Mon, 2 Mar 2026 23:28:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
To: Sasha Levin <sashal@kernel.org>
Cc: Peter Schneider <pschneider1968@googlemail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, patches@lists.linux.dev,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com>
 <7cfc1cde-a8e1-4802-831c-3e082b22fa73@oracle.com> <aaXNvoIGNjR86bKY@laps>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <aaXNvoIGNjR86bKY@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0049.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::16) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV3PR10MB7939:EE_
X-MS-Office365-Filtering-Correlation-Id: e088fbfa-db13-4c50-af39-08de788555d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	PWf5jPYqrkeUxtYinpOWe7K1xOxzKS/yEFxLWhhsZvXUgGMnopekersHV6zrDyd7gQKVlhQlIOQwQEBtgdHmfywoNJTn/16/1+f+r0UIJ8HxqtRtZQ/yfTFcjKwhEWUKi3hhxqPx0lpSLtH6nwaa6AGpMEGm3al8eHtRu2INGc1rXFY7MN4F41WPunkR81KzAt80A7sv03Ww4wDeKgT0601Q3kW42ipexI2lmGLdggg67XxhkvuegrRwAK+800NOwutw1hIjkRRF0qjN0ufn4E90ZRUoToEzgz1awaMla8ryGplsQqcnUORkmXNwERfK9oP9KbFv+b2OfBKHPZwe2ZSwIGBl5PHD/zox6kdhSblD9/6ErvnaQkwkSgbrj1QPm5Seqc6RRtNmoczhw+pHE4XFliSYJ4CSnaLIhBAIb3i1es9eI90u9W2mkE1/XzUT4sVpyNhTW3BOcJt2zeHKDy1n8eLOKUHq/pOyqd8JSP59OVDTkKMGcMEvIkpixanUY2qO24v9zFp4dD77FrnwD4CasSDeA3yMbQSt/04ZZuzMqxHYj2nn8UhjvCtubZGowDAn364PWJHtuTYELGim7NvOkej6AwJQl+LfyHOzhJCfphFtv93VDjy0XmHA3xZtXgivkhMNTf7XAnh7gwg1BTLhUcaYUXua9VRoCGvXOStveQ6V2ZgSL87xbxhaiFB9wabQuZYfBv9zQaMjyjWPPLFFKPZ8NG3bmfp8yKAzlu4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWlTR21GcUFJV2ZFRGh3VW1lSkhSdXlJV2xUMkErVXhRNzlrWHRWTDBaU3l0?=
 =?utf-8?B?Yk9sNnA4SHBzRFdiTWhyS3V4UVZIUFZZTlA5eHBzcElpUUlORXhKanhkNU1v?=
 =?utf-8?B?Zi9xUWM0bjFsSGt6VFdIYWN2ZHMxdHBsOVlKVVVxQmxOQWRnOW9hcTRVT1JH?=
 =?utf-8?B?UmZ0TlpiVG1uZnQyTUxBOFRWUjdzS2ZYTGRvdUJia3NIRVF3UGR2VTVsWVBx?=
 =?utf-8?B?WWFvWFhnQ3lscFl3WlpsbHl6K2paOWRQV1FuazY1eHRUbGZLQklaR1ZWYndy?=
 =?utf-8?B?ZzJwcCtZN2wxVUZySTlER2RobGpUMzU3ZlJISmJxc0NReWpEcDJyNDU2Q09E?=
 =?utf-8?B?TjBVU1prY3REckhWcnFSV2hHYWFxb2YxLzZUOHB1bW91OXRkd2c4dXdsNWhv?=
 =?utf-8?B?bWZrRWNYUDN0OC9oNFpuRWZOSm1YUjRzc29leHF1SkdXMm44bVVQUVY0L3h6?=
 =?utf-8?B?V3hYQ2h1M0R1VGhUN2JpWENMZnlsNXVKOGxGUmxOYWgyeDk2cFhNNys3SDRh?=
 =?utf-8?B?ME5hYVJSNkt2T2poaHNLeUhWR0U2OXgrc3N5OEJNOTYrY080N0x0VVRHVitw?=
 =?utf-8?B?dzFUMUpWUWw3MVZaRnhod0R6TlltNDU3TUFpcTJrU1lYNmtGL1VlS29JdjBW?=
 =?utf-8?B?UVM4S21NK2xtR25UR1Q0M29vZlJYM0FTakdZdW5DVXllc3Z5YnE4amEwbnlO?=
 =?utf-8?B?YTRTcHNOUlRKSTRxMjJ1ZmZVSVBwTUJSbVQ5RzFmRFFaeWd3MmdBT0c4d0lz?=
 =?utf-8?B?dC9xRFdpL2FzSWJLaFZWT2RuNFdlb2N6Qys3R3c5d2tLT2kxZlZ5VjZTYWYv?=
 =?utf-8?B?bnA0RjQyOVZNd3RGYWxJdFRXbi94cGcwOTFmSFN3Q0FXWk5oSjcvT0hSK3Iw?=
 =?utf-8?B?S3BhWVlsQ0JpRnFORCtRUHBEbTZ6TUJYSWVFWUlDaHFmZCtPY0wwM0NVcE55?=
 =?utf-8?B?a1JML3VqUGFHblVlYURJMW95K0VHNzNCUERXbWM0bno1ZVVQZHZvTGR2UnBW?=
 =?utf-8?B?b0RvcDJscHZ6VllmcDEvWDBJSXVybm5jZVloTExtVVpCK0JjQWVoT0g3TThF?=
 =?utf-8?B?RmRCcnlYUW51b3ZVbzVkOUV3TVg1c2o0bEU1TG5xZnRSNkhUS0RCTGZ3UFhl?=
 =?utf-8?B?c1M3dngzNDduVzRpcFFteEt1U1gweDJYTnZTOW9sTmkvVHFqaURWMlB2eW5C?=
 =?utf-8?B?aTZqL2RPQzYzMzh4Mis2QUZaK0lGM1pBbW16WEJGSGtHS2VqSU55Wm1OOW1k?=
 =?utf-8?B?NGZmR1ZJazd5QzFrd3dQc3lxQ1FjKzJvMXdqemRKM0ZMZHM3aVNNUXB6N2Qv?=
 =?utf-8?B?clpYRnI2OW96ZnJIVElRaWhaL1RmSUpUWkRoYUxDWHY4S0xmYWYwd2lCSjRo?=
 =?utf-8?B?aHRJL0x2R29waDU2K2ZsamtqZkxOelhlYUxORFBqMzZ3VmhDSGJEV1oxSHIv?=
 =?utf-8?B?aXJqa0FFcmF6dUxxajJnVzJvOSs5aDVDeGZEcjJra3crR1dBaDdzRVQ4MnA1?=
 =?utf-8?B?Q2FqOFlKeEM5bW51VCtDRVAzSEdLcVpsT0RGYk1rYTZnMGFvR2o3OGNWWXJG?=
 =?utf-8?B?WWtZbTAreThhRnZJcCs2NzAyZDNLa0tjQmszT0gyb2N0ank3R294S1I5eVRa?=
 =?utf-8?B?VVBqQ2NzeUE0NmNvRVNNdkxBWFN2bmI1eVVxb1FMR3BJendPRVlKbjdLdGZl?=
 =?utf-8?B?YVlTNEV4NS9pMTdGUXc0NGVSaENyajRBTnR4b3RsNXU4WURaRHkzV0x4SHNU?=
 =?utf-8?B?NFowSDhuS284TU4rbU9yYlJ5d2FSUm9BaVU0blNRY1U2SllhU1FZZE5raEF1?=
 =?utf-8?B?ejFIbDBMNjVacVFJRUtUVkNhU2tlUStTQXRyaS92cnJ2b1hRU1JZOExqaWlC?=
 =?utf-8?B?Q1k4b3B1L1JsK3d6R202RktuSTBZVW5EdDRxb0orcHRveW4vSEJVaUR5UG9K?=
 =?utf-8?B?ZnByWTFmc29CMVJLL2g1M2JTazZHcHk4S2l6dHZPOGovamxGb0x2d052QUhS?=
 =?utf-8?B?ZlZ1eU9RdjFSQytPM2V1c2xTd3RtTkVaNzJDbEZGN1l6eFo2ZHJrRkhRUldJ?=
 =?utf-8?B?bnhiRTh2LzBaYWpQRTdDTXhMTFBXZ2hTTzVsN1ViOVRLeE52VmFiZ2wyYlNF?=
 =?utf-8?B?VUtsc01JVXdEMEFYbWVQeW9nd0IxOFM4RmJ5bGcwaEN4Z3loZ1lIc20wZjNk?=
 =?utf-8?B?bDFOSHBMUkJ6N2IwMWFyTmpFbjYwOFdnVjhIdTNtWWNON2RHbWh6a2owb2ww?=
 =?utf-8?B?MXNJVWF3Y3kzQ1BkTUhjTWk4WnFWd0J4b2xmZzVITHFhME5QaDJJZEhJMFFp?=
 =?utf-8?B?N3RMYXA2SmdBU2lJVTdKVXJWa08vQnRra2t3TWY2KzlPdkdreHhCUTY3bzM2?=
 =?utf-8?Q?m1DtGNxkIH+IDkJQG+FZBgT4kDPvPwa11TceY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	no3oEw8GYR6ujcCzV9efUc+w6xH/iNIKEEmLwv+TjFCRMjVXUZASdexkZ3hd/LOTbzW+kGA480h43lZe75Pzj0slnI1eVL5K8kZ51ztNsprlldvrVwSKS/OXr94yjzs1klnh9eibs3DR9Xb3wQiae1e72oOnzWd7ltKjtVd5Ie9Ha6cdfLxr6lNcDeBKQSKdLrqgpHIntAN1ZF066vDyHPRbTBbam7DDW8rE0zxgfJNx0UTe0ap75uvm9sbqb8ckoy7Ao/GVkY6320GV5PQ8rRuX9t4uqekOJbIO08fIKQUpm/0cCj5Uw81vTI3CbvT9CrDJrLjZoQvSsnp6scF6UZnaEocp2wbBr+mQkPGfbLV3onE2SQA9cZdAV5hdsr9dvx0b+qt7+GwqEXi+cojWUCqsHnD5BDW7QZ6Ogvipb4KRxQCJHQSGtGvD/RO9a7NqQ4WHqJHYZwRlsZo5wwZAGdRDfvueexd/JHoP+uys/ip1rXiyxVr50e4yhbO4iZV/x75hqYkiXpGgKPdfkjLAFqXarEg0os587Xwm5vSjXDnChwG2IWgTefhnrYJzzHFdAPyoPo612i0uIIW8ncufE1zYotEsUuziRUENLXql8l4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e088fbfa-db13-4c50-af39-08de788555d0
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:58:39.9752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42i9t1/KwX6WJ5pULPPMF8jtBFBfNPK3V9Kxw3sO6LP2VW8Rnn3iSW5UBIE6hdrqz2qpG6UvNjtSglwzuIgeqtm6bon4gBxhHl5BlrW0GdWFlw9ZJnaCarRV1nt6ZUiB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7939
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=949 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020144
X-Authority-Analysis: v=2.4 cv=JrP8bc4C c=1 sm=1 tr=0 ts=69a5cfd8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=b6Fw3YNAEbV7FKKWyPYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MyBTYWx0ZWRfX6AH3QcO/kxw7
 gcZM7Z1giQ5rqO2HyRWzefC8mV0jXpI6mMuNO7KgLWNWNwh6s8jEgfUCo44+mPvZRMgWWU2nwm6
 VYfQ4ux5t96qEEOibZBtZH2sSRhB2i5P4UscS92sHWZaopnRU1IMVJW36tOdN1qUhRB9T7CUE8d
 Vw2NW0kt8fA0xnDUqvVfp4mNaz4Y7UsakA3usUglAYuuh+giRFqWflpof5OFa2AC7IsYaF8fKzc
 LLMSgcsNhR6TbzNkr7kzld8LvIiWbVAQkyYgV/WsrN5UAK/wuO6Lr+z7C/3Ve0EDyN2nIcc3VJ9
 XwU2OBhyhYmkyEBmPq1rAWQPeFrn5hsKGQ0KbzHnKc8Xa3NXt4lAS6nXqMZzPVobgWzff4EBMyI
 x71Ei/tvc5OFJWxugR0ebHAAiXT3pAvSl48GYar0D2Xfc31HGkRG+Qu9OPkE9MxIOfHCWecuPXe
 yqCMeRDhkUokijFd04A==
X-Proofpoint-ORIG-GUID: W2OFDMW1_PmB5CvGB1OqDBnrb7rpg5r7
X-Proofpoint-GUID: W2OFDMW1_PmB5CvGB1OqDBnrb7rpg5r7

Hi Sasha,

>> Also I see something unusual -->
>>
>> 6.1.165-rc1 --> 232 patches.
>>
>> 6.1.165-rc2 --> 533 patches.
>>
>> Can you please check ?
> 
> That's the reason for -rc2 :) See:
> 
> https://lore.kernel.org/all/aaWWE5uQqz_eG69i@laps/

Thanks, but shouldn't the 533 - 232 = 301 patches be sent to stable 
mailing list ?

Also not speaking about 6.1.y, but when rc1 passes tests, I don't 
trigger tests for rc2. Should I always retrigger tests for 6.12.X-rc2 ?

Usually rc1 --> rc2 --> its mostly 2-5 patches in general.


Thanks,
Harshit
