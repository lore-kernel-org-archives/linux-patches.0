Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FF85636
	for <patches@lists.linux.dev>; Fri, 24 May 2024 06:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716533727; cv=fail; b=Zo55V363g6tstIbgzVxtwinBsS9PiXclf38G10/GtQiIBTqIncizME8PjS1t3RiBJmTb5YPh5/glDLfuwTHzztll7/OIQggPKR0zKGWWBzs7kPOV9PjK8iYGtPsrxYXkmPEjZMYwYfxwNMCQ2m3vcMYSd0fbbUkqQ+W162SRiP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716533727; c=relaxed/simple;
	bh=Dc0XpfTgIg/VKxnBbua3fYI7uVCdcjECJWt9UQimka0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jw8w5/H2PPs3mvHIbmuHPVJSnI7dWVzmXF8bS4ahx1HHe73GpT46COFDOCtJ7BgXzd3GlZdUAl9g4L4Fok14dcmj9nMqciHcFhARoea+UdIvNz1qapzWuRk0IBZE5BVKVHvVKbSrZpDStZ4U45iXx8x8/F0fDHBv7/ajk5/WmiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N3JJEhDq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kuy5LEs2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N3JJEhDq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kuy5LEs2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O11k7U032567;
	Fri, 24 May 2024 06:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=qX38yITX5DyHdPDE6E/ECUAbrUqjrraF+3qghSICfFI=;
 b=N3JJEhDqc6EsmbQvOm5oKgkn/+5JnD7/qqxV2gZlWDvXa6XmPFWlz09QVx8pjJ3SD7FS
 yxWSrbt/eaJjLAuzMGXiwt1Yo7MMmHjTnjHBGThM2hJtchC/UdTjUxB3B0AVfMfgG9dn
 JVdfIyjNbv8zY1DVkbPXfCWInKD0VFPM7hvikTgcwkVZzJ9ueyXIMhogQOfB9fsCcG2/
 S1xyvgsj+gaK5UzVF9b0P6/hIAHf6MOMTmYf9d3xI4H6sfO4JRZfqTzDH80n4HzJmJEx
 3AVlDqYVQYpyoTB91NATVfoEcZ6a+KHxt7NAN5K5ZvRov70yxyH6CGFLqH02MmOUS97h PA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2kpvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:55:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O6SSIG013757;
	Fri, 24 May 2024 06:55:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsaydhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3uI7UHUP3QkZ1+hRz3axjQMMUOw+e4xMAWdXxkXAnPWOXxmxW6mtEgiChoT3knxpNdA+XH0huVKF4fRUfZLaNbxC5bOFGgkXyQdujOufSM19JFBs495MFd7OFR/CJLf8WCKN4sOmaaWhfv31VyB6RTwho7LsQFAMHtm2n9F5pHGVfBdrVea4zogCI3OnmO6ZB70EkKSuxjkXfCWxbhaVeRMME05XnsKe8RStR/eREkEsegjkWLtYvqtjSTjqt+nTGIiNEp7ZkvGKxAKhoHpHhYTEsSj/zZZGW6clHInzLVG6MCvU3Dotl35TBPChieZvJ/9eXQ7jWMCao6/VxSO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX38yITX5DyHdPDE6E/ECUAbrUqjrraF+3qghSICfFI=;
 b=TQ2gwMDZdmKOmxvbCkZnSCxSszyC2xOQJaY7wf4TX07Y0izb5WaZmsLCgx4XoGpuQ+Mnslr/W9cS63Feo/QCvrFRlVIQU1IpXQ8p0DyzZWGfiXNINSmnG3iJp6SAseYz+7ieYDuTE9yMc7cPhu6jCyfPvkto9Bd8D19gus5EnGpTsF/ZTumFGVaS3cJSc0v7J5r8cu4qwsS6Jm3R5cEJyy1MX8o3DBS3zligvtfYYieQRofOgeRafvkgZp8CnLzr1BDk1rVcc/Fv5id9PEcTF04a8fmU9CwoaY5CPjCDWF/SJ1aBOMRzMp5dSo7v4L7eM9Bne5ZggbUA8k4XUR46tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qX38yITX5DyHdPDE6E/ECUAbrUqjrraF+3qghSICfFI=;
 b=Kuy5LEs2SdcJNTRkXikUnIz0/WrAnv9KG/PBZvt6hver/tZ9Cry9rIEMIR6E/xCgKSayPhoJ/Lu5Fl3T+0LkYvAuyc5xxw68d0+PAclwWeiY7JMzM66NBsYTdmJMFGTjRLDNyrRvt7z6x0BpMWE4YnGkZnfhXCxVuRphhvNHqu4=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB6201.namprd10.prod.outlook.com (2603:10b6:510:1f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 06:55:11 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 06:55:11 +0000
Message-ID: <611ff164-4133-4a3b-8f57-3dd1430c6a06@oracle.com>
Date: Fri, 24 May 2024 12:24:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/16] 5.4.277-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240523130325.743454852@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0030.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: 1761c31d-ee84-4393-5f55-08dc7bbe74da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VVU2azBpR0FhbzZtUmxnTXMxQnRPL2ZtcEh1R1BWbmtFWVlWTXpkc2UyVzlk?=
 =?utf-8?B?d1pJL2ZCVWNWbk43eFdUSUNqVjQxcG11UFlXQ3pwb2hVOEZ2MG1qdEMxV0xl?=
 =?utf-8?B?ZUN5WGhZRXg5VUQzaGRreUxXWkczaHBUcXlTOGI0UFI2NmpudDRlWE45OXhw?=
 =?utf-8?B?eWpBNkZTK3NHY3dNaUo2K1RlS2t1Vm90QUoyZjJzb0I5QkNFTnZmc1FXN3J0?=
 =?utf-8?B?UDY0L2FNQ0ZMaUZnNEx3VzQxZUJSNWtndHoxNHp0QkJrYnlVRUhlYTlZMkJK?=
 =?utf-8?B?Rmc3RzJ0Z0ZpYzJUR2dPS0Z2RkNqaERIWHFHb0YzQ3ZNSlVRc0NpZDJvS1V3?=
 =?utf-8?B?eng0R0U4L05ENHppZ3Vhejd6Qm9URzRWUDZ1L2wyOEhBUzlXSGRyRC9GYUwz?=
 =?utf-8?B?akRjUXhBbU1ueVpERjJCOTcyQTREUWU2eUZ3OUtMczNqeXNiNGJFdWIyWDVp?=
 =?utf-8?B?Z3gydWtXODcrMHc2Z1N5WmEzalVHU3YxWnhCNU5LS1V6Sk1iZi8renp2ek9C?=
 =?utf-8?B?aE1FdHIzekhWNUJhbTJsQVBiZTdWaW1lbnQ0YWJ0Q1lLMlhpZFNHenBTTmF2?=
 =?utf-8?B?WDRxTDh1MzBpZUgwOEFpR2lKUE5PbEkrVS9OeEJWK1VRRVNXWHNBRkptRlNp?=
 =?utf-8?B?a29tRkowemVlcTUrYUp6STkvcmwvOWNUcm8ycTg1UFJuYTBXaGlwdm9PR0Zi?=
 =?utf-8?B?dEJndlFkdG9hYnMzUkdPcnA2TzRSRlE1WFVhREhsRnlWelhCa3VXOU5hZi9U?=
 =?utf-8?B?S3NHRmVOMFowODFaSVU0SnBFVGlkUHgvUGZaK3lFQzZsNTFERCs4SnUxc0th?=
 =?utf-8?B?aTcwMVVVYWlOQmdIbmFUNzdVSVpoTHpCMC96ZzluSmNNVDBsNjBEMG5IWDF3?=
 =?utf-8?B?U1lEekdPcDMwTWVnWEovY3d6WHJKVjd0NkdqeHVZbVJnejVvYWF5SHVDL1Bx?=
 =?utf-8?B?WVNDZnliUTNRWnB1VGE1eG1nV3A0U3ZrM3YvaVA5V2thbkh0U0xFSHpJMi95?=
 =?utf-8?B?bjYyYmMwak9Tc2NEYVIxYktZcjVFMXRDNVFXK2lRQitrek5qRmFqSm4zSkJ5?=
 =?utf-8?B?TytPVklwQzdhMDBGYjI0WFN6WWdiM0cyZXVHUVJOQ0FkUFMyU1ZkdU5zV0hj?=
 =?utf-8?B?bUpCSjBtS1k3WkJYVDlLdTBGcEY5WDBVMllWZlp1VEsvdW5RSWJGeWswY0tz?=
 =?utf-8?B?Z0dNeU9RR0I4bkd6OGV0N2Q2VUx2c0VDUDc1a0I5MkxlNGp3NDh1dGZGZ2xO?=
 =?utf-8?B?ckRCekwrTGpkdS92NXRJdEhPU2EvRkFvNDV6OEFDcWcySm50aVBDdDZ5dUk4?=
 =?utf-8?B?eGZrYXBOaUpDUURKd0pnL2J4STExQmY3WGM3L1ovOVZuWDAxUHpjZUNNTDhT?=
 =?utf-8?B?bVBZZEFnK0pmOEplYWt2MEVzWHdCV0E3Slk0QktNeFpVYWhiVllMYjZDZ0Nu?=
 =?utf-8?B?VSt3NGpwSmdwbnVtcjdXWVEzOXhIRy9EbDZrZ2UwVDhhUHZIS0pzVDFaUGdU?=
 =?utf-8?B?eURtc0w5RU9UT0Z6T3hza3pOTG02Z0ZqOUM4WDFKT013QzF3ejJkVEplNkNx?=
 =?utf-8?B?bFhubWNJWDFaam5NRUYxTDU4VTFCTTlRc3NHVlF0SlR1OVNGbDF4TmQzSzZt?=
 =?utf-8?Q?vLUzYs3lEi7XsTBsu6GndZ296blfUtZs0XFi5bnY8iV4=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bmtOR0ZSYzRsSGw5V09KbEhUVlFzem5mTnZ3bjhHZ1VsVTJERUhuL2crRWFo?=
 =?utf-8?B?K3UyWFlkajJvL3pPbm9Dd204Z2NRS0lGRHVrU1IwQ0JNK2E1c0RucjBiZkxC?=
 =?utf-8?B?RXZWVDlyZ01FcHNod1RnUEFQQXNDUk96eGNJSWgzZFB6ZVN6Q0grdlRLa1Bk?=
 =?utf-8?B?MEdVQ3Z6TnhwWHBVK3FGNXhTaUpFMFRiN0tHNE5CcDJZM1BqTitLMGZ3c2NP?=
 =?utf-8?B?ak5SejgxeXNqT05rV2l5bTVkWUJUczhZQVhPQU90OHZlYnhlalcxYmN3ZjNy?=
 =?utf-8?B?VWZwYjE1TVlWU0ZhSW96T3JyOXBvZHppMnppWmtKaW5wa2NLTHRvMFlVMTdk?=
 =?utf-8?B?eHRXb0xBTjljdkNMM0pwODFwK1NvVEdNZGdIc0Y4L013c0ZzcFg1V01BTVZH?=
 =?utf-8?B?NjFLL3FyYWFZK0xnR1g1aDNKWStGSi9HNDlvaWsxVUNPTzVzUlBja0p6d3k2?=
 =?utf-8?B?cUVtaGJlNnBpelRFejlUUHYzMUVUQWVidGZjM05SalphRTdVaUpjbWpYRXN6?=
 =?utf-8?B?KzNhNFVZWW5Xb0tLUmNHdnZOQVZSaDdqeUJXMENaOXkrbEpvTkpHUExvTEJG?=
 =?utf-8?B?UFh6eWZxZU5qelZJN0dQdHEyZ2FwVnVxMkpXVXBBemtTWkNmeCszenhMR1ds?=
 =?utf-8?B?cE9oKzd4OG55RGVXV1I0cUt5WWxYZTFJVTVIWTc2WDlob0owYmE5dTFyMUhi?=
 =?utf-8?B?RzVXc1RwcXBZdzhmMHJZVnlFRldlZFFON0FDZW1BYmliMXNxYWQrWUJiOEFN?=
 =?utf-8?B?UHljcU1GYTJmV2dZM0JOMEc2dWtYTnFUMkZrdit6allWQVRCbHBlUUtDTk4y?=
 =?utf-8?B?Z1gzcXFqS3JOUmdMMDhhcnFGdDczZ0hrVzFiR1piaWRFbTBDRFZpWkYydnBS?=
 =?utf-8?B?WVlCL2FEZDZZQnpzbnlRK0ZMZG1WVWhUS0k1NEJmb09ScmxEZzRpdElxU3Fz?=
 =?utf-8?B?L0FQTVFITEtDeWVoY3NHaldqc1M2OHRpcVdJanB2R2h6NjVqcE9laFBDNUZH?=
 =?utf-8?B?VGNZWDhCa0g5OGRKUUpSNDNnNUZ5TmhPdGRqYnJ3UXhQMEorT1J5ZHVScXlQ?=
 =?utf-8?B?YW4vUGMxL2V2OEVadDdGc2dWNy9XNU9NRlluZU5lVVJlWS9YRHlYYk5sRHQy?=
 =?utf-8?B?N3I5YmlVZnFZNHI4U0lGT1NvY3ZkNE16aGpiOS9Ja3FPUi90WnhDY1I0SlYx?=
 =?utf-8?B?NytGemZCdlNjaWxGTkhQNTQ1SG1YaHNZSC9PMGdJbmNxNFdHS21YeGh6RjVn?=
 =?utf-8?B?dFZyOHBUTFBBUVRmMUJQcXU4KzdJRWNHMnl2TG9QSEU0OXQ1ZWJJY3BBbkFn?=
 =?utf-8?B?M1RvNzJwRzI5VWtqdHl5OHlpOWJSRWw5alRadFg0cE1uQWRTQTFkWkw0SnFu?=
 =?utf-8?B?cCtHR3g3aUhlZEJlSFN6WXc3WmFLL2xiQmNjUERROUdFaUxuUGtzMVRPOUd2?=
 =?utf-8?B?dU9NSFNDdUJucEpEK0UrZ0Fta0ZGeGJMU0JhamxsQ2JkbkRoeVIzVzhoZmkr?=
 =?utf-8?B?RTdyQXp4M3FaeExOZGtPUnVMZmNaUkVIU01sVFFVWDhiRmw3NHJQRm00eGky?=
 =?utf-8?B?dkhLVEg5THdwQVFrM2FDRnNqTmNEanRqOGdZV3BiV28yUlhJN1plYXVULy9J?=
 =?utf-8?B?SU9jSGVhNHFQNEU3QnZBcFdoZWllYmxyVE5RMTFudWRXT3NoOVB2THVOdkdw?=
 =?utf-8?B?L1h4cUZCclFEbnJ1QXZKQm5tQm1aUDFkWlE4c0NiRFZNaW8yRzAyaFkrSmVJ?=
 =?utf-8?B?VDR3K2dKTjBIOVhKd2dLM25DMVVCOWVFcFZZZ25VVXdFWlhZOFJzbndjU1o0?=
 =?utf-8?B?MG94TnAvWURyMHpteEM3a0R4d3pzTUNwQnBjUElvTjJ3YkNyVW5qNTlkU1FQ?=
 =?utf-8?B?VkZzTDlsZmc3WlhWWS9QUnZ2a1A4dzBTYnhiUWgycHl2aUJTRmVnN01QVnVm?=
 =?utf-8?B?eW54TjJYenVkRDREY1NFS1B2UUxRTG91NmlkY1BJRGZVQzEvYnhldmE0RXBF?=
 =?utf-8?B?KzhCa1E3bWhtNEM0ZG1SM1FMcU8rUjlUNElsbm0zZ0VBd09DaE1UbzBYeXR4?=
 =?utf-8?B?T3B5ZkVUV1lTTUpLenE2ZUx2Y056REFmRVdtRHBYMmZ0WGpHUWRDT1AzNXl5?=
 =?utf-8?B?L296cGZYRW9HZDZIZHR6RFY4dkg2WU94SU5PaFIrWU1PaDlNNFhtQ0x2NUFU?=
 =?utf-8?Q?1jyp0H5TkLHik17brMNi9BU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wSQvedYlatEMUaVV2OyGo28W3AchUucWqEZZELggYUBzbhc9yBqmkAjuAcFmLjEVwGO1b3qDq1X2HuDLKES0egu+6tgq0Za6xBbwPFqrHGx8P54/AJFFPfKIb8m5U0FWRPM77tn5O9LgMb09jRui5/UQMYemWHV5z2uUcc5at60M7e9WHqepgTRQ7EYuLzo5iK3Evbon/9nSBB5YwLDxTTET28wzFRRrFRPh2awtRMANV8zvW2n2UUfFC0LN3xpMtNdNEHInWOuZJ7/ChQjqhB3cH63lhLiGzFR6g1JyjFc+ExvClGlt8DnRFE+LxlVxeRLBxtOQcyFcrzZAnC6MSkHcwMB+T/ORC9q34bpKgOyUUy4GTS53GrsguXjW4K4u563Mfu/50iRgZuxdn/PA9nuhauU38HhyMeKsPu2kAasXr/oOTlFCwKtDjawKi0lGdkyMycvq5fBpAvLgrNonUqPmCKX0ClDro5g2ym4lTJLCJCKDP3y45IiKpnhw5F/P3n8EWCxF1xW9fEGWMXU3SodZ27vHJhEF/ttHP5Jblp2NdM4L+uUlFqsMfxGmRhVL+d1NgdSKdeZVQte7SWGguI/+BCCeEmOq5uaZqpb09mc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1761c31d-ee84-4393-5f55-08dc7bbe74da
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 06:55:11.6855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfTOCBNDRElDFrZgH3BmqBW2EvwcNdmhBFfwoab6fFipsJFfEfoA98Ptm3SV12mWrpZ3gp/77OWiLTtNQQSa1xLfkrf6D8aw2YcpYeZbTiSrjIT61UtYdM9BqwDGV7Ng
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405240047
X-Proofpoint-GUID: 9okHw0Gnucbyv1EinR7rznO7Jdfcrtz6
X-Proofpoint-ORIG-GUID: 9okHw0Gnucbyv1EinR7rznO7Jdfcrtz6

Hi Greg,

On 23/05/24 18:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.277 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.277-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
