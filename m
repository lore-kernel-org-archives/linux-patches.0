Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142B514A4F0
	for <patches@lists.linux.dev>; Sun,  8 Dec 2024 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733676866; cv=fail; b=fkjMH0YWsjHzR7z/mAq9Wf5oRrPvaotGPEIzESUfDZeoVLRo+hT5wJ5No0WwlJQJppOmffoXnvqe6Z5JHrKbTZpo7WppZ7H6dHzAgDbD0+rHy2CZ3OG2yPU4WxuaF3baEOUbVYkLEKWn06aeFn6+T5Q5SWSa/OOHkJ6abDKalL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733676866; c=relaxed/simple;
	bh=cFDpnOrOAk4TVotdcOhI5uiz0bjWW7/7fRwOsm5jw3A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o8RFgKqy4JAF6r87V+yQ2/LvaxVw+I/odp/xcGvZFc0C1z2wxyR4uepEkapMNFrly/+8RL8DKKUjyTghDhR05TROWBEwqF6KrON/PutklkzaNe4wDgtxPyj5Z+QYFGDd/lkIBieZ1bddEsz7M35KMtZpkHTvEHrchItSV3X3PL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G2JU6I0q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dBNGKKj8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G2JU6I0q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dBNGKKj8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8GGTUJ022156;
	Sun, 8 Dec 2024 16:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VLHnMIYCKgV5ps24OjuwU96w7Siwwe2F+TiLRX7yqI0=; b=
	G2JU6I0qY8qWbxz4QYAxq3tB0SXZhQl9Apj21rik9oIQezIWtSgCTQUmmVmg9Dwv
	TIffB1os6jJFBAJsKO/VWdKa1PBRjRWT88NieRsUghqXBY4Jian5gsBc2ogRH/F0
	npauEuiEtvPUk00mZTlUPnXhdjJhYbUNmzPqAGpZcg6tB9FQSDvfMdealMDSq/Oy
	WWyQ4k0BgXx2e/HYg36nYoS54v6wmQBriCCL/MBjJC/Lzj1Rl6On+CTT91FA9LJu
	0pa0y3Uu4L/+aYvYfnwSI85M4cjONCQFDhEFyf3kGsmN9y9ouNlrTQmugQYZxz65
	S+Fy+QraVgQ6FNhEaCOZAw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43ddr601wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Dec 2024 16:54:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8Dq5Y5008663;
	Sun, 8 Dec 2024 16:54:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct68qkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Dec 2024 16:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8h7YmXVBxF4DMh4DoaDuX8SQv1ezqgYZOOKYVK5y72DcxnvyBQM+pRFh4iVkDqbbcfd+JmubFvkxBjxoEZ+G3pVNwXEpBlH+do54124WCQpiHcETSIO82HdbeCqyRuN8Qdnxzs3rSKr0mc4UxRNDSQ2utsahp06FPdw0HD0RCv7xuNZ6oHLPL7nQK7suZa7sK1552h6KhKPJAHtpvOWKfMKuGSntU3tB5cYVgK7L5RbpRm6greiWHCw735iVDySboYK7wYyRlqjwz5l8KODknCYU0B8LfDwFSzrx0Nw8LE5MdHpy7ApgQnX2B0hODNEWyecflgQdENsfcmi/rrJcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLHnMIYCKgV5ps24OjuwU96w7Siwwe2F+TiLRX7yqI0=;
 b=da2VDf/Bw8cbriuOLpvyHfEICfmbN+InOHyOjwlXBr0/unWwgKAkN9NfAO+w2nrvVDuux+6hFOKDDsRj3vJUJjLNlUX0rkwhetboWfc7PDU0N+ge6euHMCNF0dmFzbS1o7Y9wwuXez2V/AsELSEaZO/3Zoh5hG6hzfP6rugknQce+lNA3IxodcYru7uLBK8Qr95JGVUnC1tzwxFw993ZtVrrzkUW4zQlX+eII+0zfGhyVGuECUwQvExyDmLLaj1s3ocIu7XYhwzZpxekNJnX0ot8LkY9FswZVocM34hHdqgofwljI4hLSMzI2PN9cb6JQdBUYSNO/BUS672M6e9aUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLHnMIYCKgV5ps24OjuwU96w7Siwwe2F+TiLRX7yqI0=;
 b=dBNGKKj8kbBcDwEcSSUKj/V0qAmpq9OEDWZIpl6U7fbzJxXWynkTc4rsHqXKE7AxQWdU1PKk+Jf0vA1Yf6CNlwa6tCa+sGb5ZwGcO6YQXNTxQur8Obl5/VZGfkleQXqrValU8aXyP86J5rUXDMPHj0PwaFQyhDFUqSM8A4DZd7w=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by CY8PR10MB6732.namprd10.prod.outlook.com (2603:10b6:930:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.24; Sun, 8 Dec
 2024 16:54:04 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8207.017; Sun, 8 Dec 2024
 16:54:04 +0000
Message-ID: <523f19a9-ba05-4d62-9286-636ef6384afb@oracle.com>
Date: Sun, 8 Dec 2024 22:23:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241206143653.344873888@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0163.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::19) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|CY8PR10MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: fd9665f1-8f49-4a69-1b23-08dd17a8ec8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czRPOE1kd3RxZDV0NkdOWEpYZXlxZ0lQTzErdHdkUTZEeHE2SmtXY0krUFhN?=
 =?utf-8?B?WnYxT1ZRVHdocFl6SktpSHZVOVIvQjkyNURnR3RzdHl5MlEvZE5lMjZ4WFlw?=
 =?utf-8?B?bkk3NVc4bHkwODkvWk5ZcDJZSkQyZVBtdEszY2ZmOWhkYVJ0OUdKNG5QdTM0?=
 =?utf-8?B?V2NmVFFobmhhNWU5U0pXbWlDMERxTXV0YVU1WVUzZndUZWVuZWpieHFaWVgv?=
 =?utf-8?B?RnZEZGN0ZU9mMXVTamhsTy82L1VxYXRUVUpOVkcxK2E2Z2tEUzNLeCtiN1M0?=
 =?utf-8?B?eUpjSDlzNTJEUmhGMmljZS9zemFOOFdpTTJUMllKYmRheC80S05zRHlvSTFt?=
 =?utf-8?B?T3ZwVi9wamdsRllTQWhEQnV3OTJkMFdIVWIveHlJQlRJVlhDVHoyZi9YVFhU?=
 =?utf-8?B?YU1YbHNRNVRibWJQdWI4aXk1ekQyVlFJUDgwRVVIYk4yS2RiK1BOWlpnSnE5?=
 =?utf-8?B?VU0xYkNzYXl0cEx1bXMrQktzOG8rYlRFNnBZMGNtV3lVSG9xTGVEWDJ6MXFh?=
 =?utf-8?B?UmpBb2ExVWZzVmpZUk5SNklBQ1VGYTNFMHVpWE5MVDg0K2JOQlJ4TkVaUU5m?=
 =?utf-8?B?NCtISFRYL0x1TGV6OHhweEg3dTFXN3VwTE41bDlXcTVEUjJNamg2K0taTFBL?=
 =?utf-8?B?VElsV3A3d0x0L0F0WUQ1ckExUlVzcTdJYmlqUFdwYjRYM2JJdmhFamg4SnN5?=
 =?utf-8?B?cUV0ejVacDVIR1hoK2EvMzFybUlRN3pBODV3ai9MSDFDbnhuMmN0UU5hRjUv?=
 =?utf-8?B?TXp3ZTFMSlhMREpSNFB6VHZqTUV6YjV0aFA1cEd1bG94SlBZamZUSEQzZW9R?=
 =?utf-8?B?N3RQcVRRelcxZjRhSWg5S1V4Z1BJdm0zSENDZGp4eVQ5NEFJM3haR1VhZHU5?=
 =?utf-8?B?ekRJbnNjS1NnNytpNC9ITzJ5b0JDcTdoK2ZkQWo0OXU0RElEOFBjRnpVQkZa?=
 =?utf-8?B?YjFnY1hWdGdQY04yRTJ3aVMwd0Y4TG9xc1VseHZ0cmEyRDZNVHlkV2NXWS9R?=
 =?utf-8?B?M0V6U2tqUkhrRUh6OGU2S1pnZWxUem50M21NME1ZU1dtRUxRMm53NlpGazVH?=
 =?utf-8?B?YzVxbHBKSzVCeXN3MW5IU2xJZXlGUFRXV2RZTEFaRkxqRk05dEtXU09lOTdM?=
 =?utf-8?B?UjFaWkJheTZ6NjdzVExLcUJDSkdld1J0ZVo4UDA4L0dTTjVWc1FtcXBuckpr?=
 =?utf-8?B?b2JMbXl2dHdXVzRpOFpITnVVMDJqK0gxTXFkT28xMmwwMEplY0l2bWpGdmY1?=
 =?utf-8?B?bkxuOHRaZXptQU9qQWtTRVZkVjhVdXk3SGhYb0s5RmRsVVEzeU9RNVZNbVdh?=
 =?utf-8?B?VnNRbFQ4OFRkVzg1UlExa0hGRnR6UE1GZXJXVUdmZEpPV29MR3Y4eU5adnhw?=
 =?utf-8?B?bTFKYklOSHpRa2RLSm82dmlFWDYvNDRVdWs0ejZROWxaMW14VTlzeUJ4eFpU?=
 =?utf-8?B?S0hWekV4Q0x1SVlqbGN1UGdNZytLT1RHdThQT0ZyTGxaRXVjNE9NSUlNM0lB?=
 =?utf-8?B?bGtaYVFBSk5DY09pRG9NcTZmTW4xeFJFZThEbXZiaDE1MVVaWVErZkJWaSs2?=
 =?utf-8?B?eFFUMllRcWlUdFpDUFF6djhqWmdJU2NmTVI3TkZaQlBFN3NpV0N1VGFaRloz?=
 =?utf-8?B?UHkwVFZ3YWNUK1RaOWlpRGk0MmpuOXFCbXFhanRCNTBGVmw1dTAzVERGaWFB?=
 =?utf-8?B?K2tac1BNS1RUc2dqeWtqRndyTUZCdXZqN3JGWDFwSEN1dGhhK0RKM1dKdGFQ?=
 =?utf-8?B?R2RLeVFCamlkTG84V2h4WFpob2pPSXVJL2J5Vis5M2hnTjA2UFBXamVvZlVN?=
 =?utf-8?B?WkMva3BtVjEwK1VvcVplUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3hlS0dHMGhJT2JUWmNEUHhPMzN4bml5MmEzb0dWbVgrNjMvWGJ5MlozZ1pC?=
 =?utf-8?B?Z3dCSk5NVzlWcVlKOVM5b3BRVTdaVHIyT1hCZENabHRESUNtSHdIbU1iVVR1?=
 =?utf-8?B?RDdTNmMwNFA2ODRwUHJpQWlkTVIxMG5PUktOOEcxYWNyN3ppWjdTSkRxVVVq?=
 =?utf-8?B?WmlmWnN2cmo5RTdwQ2ZGZWxhUUozUEtvbW15N3lCTGI2LytoZ3J2VzNoMmMv?=
 =?utf-8?B?dXljTmx4VHQyVU40TmJSMWRrZ0VpY2lTK3pIbE5jTnV4ZDh1R256aHJvMGNX?=
 =?utf-8?B?SU9TOFQzTVpjM1dGWWlQczQ3RnpSUy9KSGwyUnVTcjdzczFtNk9CazY5SU5m?=
 =?utf-8?B?WUxTTDl3eUltaWZNVlZFNVBDTDNRTDdMdi9teTZxMzVSdXIwZE5WeFF1bklP?=
 =?utf-8?B?TVFRMVF2azJNc3RsQldYNnpia3JGcCtIRVp2elFhbGNmdjFjRXVHWmo2VEhR?=
 =?utf-8?B?MWZHUFR0VWI1TlZ3VDAyMW9rQnJoKzIwUTM2RWRoa2RQNlN6OWJhUTdGZk50?=
 =?utf-8?B?OWhHN1BJTHFFUldpYzVHUkJuRERPSEwyM3Q5SHBIMzRIaXRKTjNseHFBYWMw?=
 =?utf-8?B?Q1lPQUVPYWFZSlYvTElXdjJPVmRlMjBTTDFkRkZSdGJPcUwxN21Ta2Z2djFj?=
 =?utf-8?B?TmIzL1Q4cE0yL0NMZU1yWnRjbThiUy9YLzFWdGZ1cGp0bXo2VVNjTUdrNUxL?=
 =?utf-8?B?Ynk2L2ZsTmRENFhZckNPek1JbmFCNmRmeEYzV0dwSmNDR05rQTNua2I0T2VV?=
 =?utf-8?B?NzJlYmtuTFNmdi9pVWRjU2VsTUliS20yODJOV25MRkdSZjZGVkVGd2VHRUpV?=
 =?utf-8?B?aEZVanBQU3ljajl3L3pUdGZVWU5BWVlOWWhWc29QbDFWdy9GOHU0M0dqVWFE?=
 =?utf-8?B?WnNZWHR4MWFSN21EamRlYVFaMTQ0SjhQdkFQbFhraWdGNDJPdzluOFNxeDQ2?=
 =?utf-8?B?a2JFSGlIbTNLcGEzSEpkMGFEQ2ZLeVdYQ3dwazFKVUQyZ0o0V1YxMzJHdTJs?=
 =?utf-8?B?aG5oa0VkTE9WVDlyRTFhVGhoY1hTZ0FxemdKOE5qbU9CNjVPT0gxcklRNy9R?=
 =?utf-8?B?S2JBRmUwams3RCtVeEpycUQ2SFMvMFdRaGdJbFg4UE9MNlpXWjdZa0JBMXp5?=
 =?utf-8?B?OEpFZWRqNVgvMXdBTjJEcGFORVNjbS95WUUrN0JpMFhXSUpCWmtpd3lXbnh0?=
 =?utf-8?B?UUpkL3RJN0VGYnNGVm9rcmFpUmtEem0rM3RWYVdkeks0V244YXBTMnc0SXZ6?=
 =?utf-8?B?QnFxejNlVW9laUorNzNmVjlTVlhqL0dmUjNNODBJdUI0ZmErTW85Skh0TEx3?=
 =?utf-8?B?YUVwMnBDVWpOM3hoT3orYjAzR2gvcDVPOS9HenhqWFo0WVZ2bzNySGM0bDAr?=
 =?utf-8?B?M3BjaFhXU2VLUkhBc0prT1RjU3I4LzlVZTlOWkVxVVA0cFFjZUc3QjR1UmVp?=
 =?utf-8?B?eG4zbWlublJqZG8xTWZGT3Z3bkwzOGVaalY1WXR5TVg2aVBrMjZ1bExIVE41?=
 =?utf-8?B?d2JMUVd5QktBVGlzUjFrSkIvTEMwVjFWL3pLTFJTSURFL0NjUmVWQzV3M1gx?=
 =?utf-8?B?aWc2UGNUalR4djFsSWhwSjRqUjJla1FNZlhqY0ZWVGJLWVR4dndlWW5YY2NO?=
 =?utf-8?B?czkrY0hRaFdNV0JLQU5VSlBvbVdQRHpJNjgzYnQvRkppV0tGVjI2dnlkZGFL?=
 =?utf-8?B?WkNuR05mcUZrbi9qY0JubVZjSXA2cDkyTnVFbm5wcFRWU1QrVWpheWh1U0N6?=
 =?utf-8?B?Z1E5TnJiVjB1R1QwSnREZWcrLzN1WWFKSzhvanZ3NGJPTnlRcTEvU3FzTUxr?=
 =?utf-8?B?azE5ZmhicEtDNXZDVGR3ZEVOUmFBZjdhbGFuNDlBSitteFN1bmpwMk1pM3Yz?=
 =?utf-8?B?VStUczBBSStFbkpFcmtNa1Ywc0p5UEYzY2EwVFFkS3BDWkhJMW55TUlxWHJQ?=
 =?utf-8?B?SHcxbWpKVlQ2SkIyay8xeTVKdTJTR0dHWDI2TWhmVFZKdGZpanV3QXNHM0Jv?=
 =?utf-8?B?MVV3aWJFYXNoODBkaGVxb0s1eDdKY3lTSkVEcERocmxhWU9HbDJDQW5mV2RF?=
 =?utf-8?B?UTBYdDI5M0Nrb3pES1loNm1CUjhQZ0tleHptVEM3enkzMm4vYks4d2ZqWGRB?=
 =?utf-8?B?R1BQNm8zZkw0RzAyUVJHeXJPUnVHSVBEWEVOL1N6R1VFM1ZQMWhhbU1WRXJL?=
 =?utf-8?Q?guKitgfphngK8KZxzF52CMU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y/UW3+2lApc/VxQFosZ/IfIE0UkolXVIxwJ1lVsLB0xWUX2vpfXN3p50YwihcOtEiYy5snNXVH041PtCy1RETb+PHJBK/BXq6CoEx0PkEuZ3G9PHoVTDdxUDmvyVi+ip5i1RJVTAAeBa1CcKWrzw8QZxDdCLrCFBSLk9HZuNydob9AcoiwNus7V5/WhIBYCddMD7SlNgoAx9YZ/MmMZwdRagxZfmayoLf98QFANYfsVPXgrougn2O9zeUI5o3YVQmN3xFyYgNBCcEEc0DajEtpaW/UnPG+0qB8Sf0qOMiPzfQtptREgRCJYjtno1QNVXE3MWO53D+pJQFJAcrdlfi/35V3/67cPtVzr1HkkU1IUphYIVIj8FzdxBAu/yIgK7NXOOeumC5HPYXq2PjVigdB+bWmNPmj4Pek9Ogbl/unC95KJW7jpalmYttJZrDBEPtKBude6pPWwAVrtHYVt0VsFOO+YEfNQY+RStA8JRSyZsE4npl7r8x3OPUnVtOM/3t+pWMJ7KDyTz+k+NhZzfVodQOsya9Gudpp7tBmPTawmO7G/5mLvG2kMTM5td3FaV6pvU/zKFUXhNCP2Da47VbNtCLmQr8T1Dir+FGZTzubI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9665f1-8f49-4a69-1b23-08dd17a8ec8a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2024 16:54:04.7982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vesfP3N+bdI1Ug0IQBV821fuSdbbD1xI+JXIQ9kN/UBLqYvhCJG8+xKldAt98rFs0yL16OcVMv/m2s4UIonMB1s6sf9uAln8BUYejPysBFdwyuvzmg55BXjjdwcxrhka
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-08_07,2024-12-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412080140
X-Proofpoint-GUID: nvSr8R7M-Umya9IPVteLb10f8VPB8WF-
X-Proofpoint-ORIG-GUID: nvSr8R7M-Umya9IPVteLb10f8VPB8WF-

Hi Greg,

On 06/12/24 19:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
