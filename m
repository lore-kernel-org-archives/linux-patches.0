Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F8F25A334
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744188024; cv=fail; b=hHiZVXxobkx3XIWROB4VZbbq42+rRMPw74iXqS3fzD9A+p85UrTxdGqbsVSGdoxhX9ye9LW1aF6CUPebbe9+Wops7Jqoa3JgItEk4t6pP0s8R0BcFaswPYX2A9U05Y255BuSXvE7xnkkSqck1rWpAMjpEUc+hqnJor4fb7Jti1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744188024; c=relaxed/simple;
	bh=FWVZy24uSPYUb+DH+L5GPkChb+0looUQjNFY/Lw9EBg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hb8scJcSYAg9xBNGALWHP3RCCQ5lee4UZPcb9wmn6gpUd/+SZbjOTqi6rnB1D8LDnp3o0kpYii4AQl56BgvK4b6XmobSVwJcbrDbi+AG5QXjqw9FvB6pUdOtaqM11Ex/1r3zH337dQEgDGgzr5sZF23Vwazzvj++FWscarf80NQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QunhYPMB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SORPyUg2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QunhYPMB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SORPyUg2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5397tv5E025292;
	Wed, 9 Apr 2025 08:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=58QMGDaMbMzBsABAqYkNpns2445HEiZy65e4rlqT4sM=; b=
	QunhYPMBbXHWdkinNHPIVSt1VwSxa0BPo4PiY478ZC1QnzstZfH5p9lL6gq5miBT
	MaD0qdE31IowX7muvgn1/yZQ1n+AQL5ttPFzoBXF0zY/LztNEr+rbipVmE/giRoE
	ZEXzQXP6s5TDKLP2Tc6vUN51Sk/oBjLj9ZkaPpa3LmDdUIWNqIsNadwVQotub6b6
	B/2Som+4r3yHkfjWFLiBmfG7IhK3RKoGXEtmCQK/7HtsM3hxE21Hb+jzCCeKb/qf
	SlHD0bXTZIiv4lbtY5uLk/nRkR0KcRn5Dt0xzCEN2R9bhXfEiwCm2rvXhXDIs+nv
	NTzbe0jwubVhuFZmx8Nh6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvjcxmxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 08:40:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5397xFTs022370;
	Wed, 9 Apr 2025 08:40:11 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010005.outbound.protection.outlook.com [40.93.11.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyb8fp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 08:40:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc67Ena+XcDN3l3oaNfs7Dst72gmjJZeQOJBKRL+zWiamXWd4EVVU9aMC8Wer9HliSG0HBlt9D85vetY7GPK4SdICXSVoINX8WXiEzsOUoZ1M/aobElRlqhxjGtaSQBQ/qNwvNzCP1Uc3U4ZTZ2r4dqWxCYQ9K9efsHHUsWRTRbijV5scEmXcY5oNFjjs4F58mak2dF2nV23Zd9pQas2vun50vG1qEahZdsKhQY0MM4nmcEnq8tkyPXsEy4cAQH5Ajh9SjABJQwIqsIyriXhr0cZrh4S7r5f+Q7B12jRhS34Ja1fUx9duZueHfeIyhN/vVf9cY+hPt0AZmPge5JJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58QMGDaMbMzBsABAqYkNpns2445HEiZy65e4rlqT4sM=;
 b=YweNWQcJWIOwuNFtFcT9mPF/u3idfj49/w1esLTuIFAY8cUhvBChBdXMjaUYva1Cm8U2waBYagEreE8XnFzs0mnT8Anz9zsBNgKuvmuJ5N+Lh2ODCfRcjGSRUv8XwYeXJs2gdbmYwPRPnH4a+aNELyd8zC4kCHKITRpxWcLJXQqgxd6i5nWPDMUVWniMD5YVxno7RlayYWu6NyPrjO5y/qkK9MBKIASjjuyb4ce8cqlvW9vaK658+DjRrYI0P51Zg8P+n3dJweVgC0yqqFXEm9JP9zb3lnsItfLOGBCVQeAX0kzrWS98I/63aMHSuUs9f/Xd7/6J5kdsbc6+VevfuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58QMGDaMbMzBsABAqYkNpns2445HEiZy65e4rlqT4sM=;
 b=SORPyUg2kZrH2tUjujJaRyquDZIFWg/p0+/tQM4YZwhB1A33Q+oIzUDfaWHlab33cB5O7G+GigTHJBeFSLJ46aCo8DqLnFHm9d+tYho112xQqsSRwq/s2vfYnCJzj4VqlWoDZLc/bbvf0P6s2d3LZgt8sF4OGrcIC53msTgDrMg=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ5PPF97E574FF7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7bb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Wed, 9 Apr
 2025 08:40:08 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%7]) with mapi id 15.20.8583.043; Wed, 9 Apr 2025
 08:40:07 +0000
Message-ID: <75348196-f07f-49dc-b84c-63b0099e46cc@oracle.com>
Date: Wed, 9 Apr 2025 14:09:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250408104828.499967190@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ5PPF97E574FF7:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a5f637-99bb-4d46-fc1d-08dd774221da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0o3SnFUc0hpdmY0RWNoUlNRQzJkZURVU3FaeW1xbXk0VmFuYVZxWUZWZWw0?=
 =?utf-8?B?cHUrYkxiVUE5eEJxc0hsOHI5UTNseFBXUTV3OFNScmlBS0ZLRzFtUkFJUVVW?=
 =?utf-8?B?T0JVS3BZRXdKQ1d2dHZ1Y0U2UTVkWE0rNmRZNERYNlNPMC9NckFpQmMrMXlP?=
 =?utf-8?B?TmIvcmxOKzRKNmdub2taMUU3a3JJMU01U0pNVGJ4S3c5ZDcvd2VHcVBHVzdp?=
 =?utf-8?B?Z093ZitrZ1JaTllwQTBnaDJVRG45QnU2c1hBa2RGclVxeUhTRHYzb1loWTN5?=
 =?utf-8?B?cVFCZW1QTFJFdzRPYXhxUWVEZk1TMkZYazlBSjhVZ080WWQ3WUFUZXNRejZ3?=
 =?utf-8?B?dVRDc0tHMVhwdXlyVkJQVENldVVXOWVKa0VPRGNJTFpmTkJBUVhnZVNqb3dW?=
 =?utf-8?B?UkU4UHhUNEc5WmZCbWlFUC9mN3hiUndldEFza21mR1ZCcjkyd04xYjNqUWNY?=
 =?utf-8?B?ajdxRFdHZUhSVTV2elk4SFNVUGxTckRvWEVCMlh1OENvSWxoUzM1a2hSUE9n?=
 =?utf-8?B?d0RSKzN4aXgzSENHTHJUTE8vWFNBejdUOG9QVXJ2MWlWZEpXWnRMbHZjT2JF?=
 =?utf-8?B?V0pJZFFBZWNweG9Wc2tOeFlhS3BNNWFqbG5jTzlBVS82REZQbVlVVS8zTjJV?=
 =?utf-8?B?dDZaUzVpdVF1OTJOcE1peGxFMTl6b1NkZU40MEZxZmJIRGNHR1dPdVRYT2gv?=
 =?utf-8?B?Vjdyck1lZmJPQ29jeWcreVdmTVJFRmxubTBsNzNqYlNmWU5QVDkvZzNDRFBo?=
 =?utf-8?B?ZjhvU0pqNTg3ZVVTMXdPTSsxalI0TkJZMXBJTndhUlBTOFZtNTFVWHkxRUZ1?=
 =?utf-8?B?ZGhJQUFaMkR4bW9RblZmb1ZJWkpyejIwcHBQaUxERkRndVhtZ1NmREZsSU5N?=
 =?utf-8?B?aGhxNFBwdysvUHE3SHhHWmtDdWJXYU82UXdNRSt0dTNCRFhGaDFuYWwvODlW?=
 =?utf-8?B?NHFyRUcrZlRtMXBuMHEraU9wNXpPTG9RVktRZzdPWG43NnRiMTNuM1ZFN2xD?=
 =?utf-8?B?NGQ4QlhQTms1QTlLSjZ5cUNmTGhBQkhzcUZWeTI5MU9uNUhtc2c3cWRqRndQ?=
 =?utf-8?B?RU4vWFA1c3JQempoZjVGTWhWL1gzS0VUOHE1Mk1LZGprTU9hOURBZjdaV3gy?=
 =?utf-8?B?bmRicFp2WHRMQXdXMXd0SEVGV3lkbTMvMXJ0dGp1Tjk4VW1TMm9CK3ZFbDVn?=
 =?utf-8?B?cktrenVZZVYwUzkxN2hMSjQySjNaUmhvTk1iSFVhUzZtTWZrNmgzcDk4bTJl?=
 =?utf-8?B?aHNNMVk0djdoMkJmV3U4eXE5QU9vS0J4YUNtVTNVMWQ0TjU2RzNGM0c5QjB4?=
 =?utf-8?B?QmROWEJ3RHJpNlIxVGN0RUNHQ21Ya3VYT2dHOHArN0Y2YjRQRmZxUWp5SHdq?=
 =?utf-8?B?SDUrdkpYTldZWFlUSDBSdmIvMmdNWHdwSWFub0d2NmpVai9MQWNaV0JaTHBy?=
 =?utf-8?B?cEVnTTVka0RUTFFKR21jeEgyT25hMDg3S0VCbEdZOVgwWERzdVJjZzNmdklD?=
 =?utf-8?B?UzN1QUFNakROSzBGQlluRHlyVzU0Y2dIcE5zWFdMOE51R0FYV21JRWQ4aHIv?=
 =?utf-8?B?dlNJWHAvYysxbHRhQ0VIMjZtNmNoenMrUXY3MnBHajJXOFBUYzNqWmVJUXRF?=
 =?utf-8?B?TUNyUTBwTHVzdVpTOTdhc2xjc2JYd0tLMlRnVWxaOGJOVjR4cUJrSjI4b3dy?=
 =?utf-8?B?WUxWN2w3VzkybVlDWjZUWmVscTR6cG9rQUJkK3RnY2JDWjFZS0hWY0I5VitZ?=
 =?utf-8?B?V1RONW84c0lXM0JwQUdFS3FRdzV1N2dhYzcveVMxZG44T1l0L2dGbDlwckl3?=
 =?utf-8?B?MFROZ1ZIdXNXT1Y3MGJYcTNNNDVmUkg5bDFxcUVtaEZhVk1CQ2taSTFSQkRP?=
 =?utf-8?Q?umEzbZp1LWfJU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0o3YUVFZ3FiWlZxd2ZPQjN2SVBnMStLUWFEZEJ1MGt4cUE2SkFPU3N5TWFF?=
 =?utf-8?B?VE5HelVYZjhFNDZlT3QxN3l5Mk9NNHVZZXpDd2RUS2h2Mmt2SnRIU3JzS05j?=
 =?utf-8?B?RnlTbDRBd2xxQW53emxYWTRjY0JqSGUwN1RZZUlqRFpNMFdkdHZ0Tk1jS0w2?=
 =?utf-8?B?Y0hjZGJ6bmJKVUFhcEJmakZhQTEvQUVic2lCL002dzhobHRYRER5RXQ4WGsy?=
 =?utf-8?B?VTMvNWlKREFVTmdOd2ZLZnBKbUxFOWczMjB0c3hoTWN5MmFJa3dSK0tIejhm?=
 =?utf-8?B?NWFpamhpSlNvWG1YTHpaNzVLN1JLOVBGVEI2YnF3aWhETytySmlOeHJTbDN1?=
 =?utf-8?B?SlBKYS9Mbjlia3dxKzE5R2I0TEthejNzMlE1WlZPMndvZU9nNm12cW1mU3ZI?=
 =?utf-8?B?WEQ5L09hWWdOUElGdTBibjhmbC8xYVJEeGNSejR3b2U2LzdCbkFFMkVmeW5I?=
 =?utf-8?B?S3Y5bmhnZE1DWUZYR05wT1crTXo0d1BGa3p6bURtTExuQnJvVzhiYUZwa0xr?=
 =?utf-8?B?dmZYYk92aXVuQWtpSk54Vjh0VjhVM1RBRVJSclZUQmNMWWJkRVZsV1IxUTRJ?=
 =?utf-8?B?dkxmWGpycHhCdnlvWDhKVG5KK1JaRmNMbjVjenVaVk15aFc2UUVseFRjTUtu?=
 =?utf-8?B?VVZ0UjFCRzV1bHV2Y2EvTmFoOUpTa3krR0laMzl6djY5NWtEK3lLSUhIT3li?=
 =?utf-8?B?ZlBBSWNFQm1NMWVxMll0emM5aWFxN0xONGltMERZRE5QZkpVbkY4YnRyb0I2?=
 =?utf-8?B?QnRabkNXOFU1QzNlMDljcmFQSWFJcktnZ0U2bkxHQWdRV0RWR2JmMkFJU1lu?=
 =?utf-8?B?Q0Zlc0I1c21YZUFNTGxIZ29IZmY5YmtsOHo5aWVlNzNQQll5T2hBcTYwb3FM?=
 =?utf-8?B?RDlSazRGVjZSdjdvb1J5bE1vSFI2QzVmQ3BDa2JpYnVOSWU3RDR1SzZjWDdy?=
 =?utf-8?B?RmRyMEd0UHNRVnZpamU4bzBub2ZENmVPR3lkajVQTTROekRwK1ZZWkRYdHpr?=
 =?utf-8?B?enlRZFczdllXZk5nc2tYakpmV0lLZWpieVg1WGM1SE5Na0haS1ErVGs1L2Vx?=
 =?utf-8?B?SFZ5YWx4SDliZ2VJWHBGckpqazZ5UFhmQ3dIRDFmb2poRUN5QmhIdjMxOGJ5?=
 =?utf-8?B?azlFOUhCcmNEWXRFZ1d5WHVxNDZiQjZtTHMxL0dxbFBneFlVVHEwYVo0OGNZ?=
 =?utf-8?B?LzBkWVY5ck9qdDJtSm9YSko3b1o5eXJUbUZUM0RKa05HOE5LMmZiTjNnQmVt?=
 =?utf-8?B?WVVGL1RvUzlKaDVKN045RVZydkFMSUM1a1dVUWpId3RzdytrRW9xMWwvUzNu?=
 =?utf-8?B?cU9TRHlWNHVHZVVwWkh3NkZCUThiWUFnR3JyWlB5bFNCSzdYQTBUS3Z0T0Vh?=
 =?utf-8?B?OE5wNUtVd24zc2xmSWIrRnpQY2xoNng0YzU4M21vU0tVYkhFN0RJc0VyRGhU?=
 =?utf-8?B?UUx5YTIvUVhVK0FSNGFzcHZCcHpYcFdTdHE3R2JPL1FQejZPNXZvNGg3RElM?=
 =?utf-8?B?RTF1b0J2YjlUSnQxRXhvSk10a1A5MUFMc2FveXlCckNiTVJGNmJFaGpoUGRC?=
 =?utf-8?B?S2xRUCtHVU5TNktva2FqbS9iUVAzS2IrdDk0ZVpLczJ4em8xVjMwNmtVZm1V?=
 =?utf-8?B?Y3RlNTk2SnRrcUFXYzQ5ajBzblZFRFVabWFLajNRMTBXc1BVUzhpcGlPMDg0?=
 =?utf-8?B?RC9OWmZsWTRaeThZZ1lnZHBIQkg3Y2tXN0g0SlJpcUdXNzI3UlhQeFpiZzAz?=
 =?utf-8?B?YktpQmxLRzJKTUFzVGo3ZWVZTFJFeDRLSWlMdHI4WGxjaG1lbUk4emdRWEpk?=
 =?utf-8?B?b3hIZ3lEUWdpY0Vsd0pCYUlLcmV5NllyMzUyc21rK0V5M3NNWUo0OWlhMHFS?=
 =?utf-8?B?MDI1QzdvaURuSzJnK0lZMFM5RWkzTkZrL0dyRnJhYnpUanExMm9sZEpOTjF4?=
 =?utf-8?B?TlJUZWFwRTExSHhBcS9PUTEraDlvbVpVT3JlNWxqQmFnTWpDRk5FOVdIYk1u?=
 =?utf-8?B?TVVtUnR6bVE3OUVhcmlqeEo0YTZ3YVgxbEdJdnpoeEd1TUNsU0xLcFJhMTlv?=
 =?utf-8?B?U0F3RmtTNDBqeld3ejhhcTZDMFlLNlRyNU5jQ2RZR25Ha3J0cmk5Q0MyYUw2?=
 =?utf-8?B?VVB5TnFUSVVXVDMwZWtCT1FLd0RwKzFsQ3JkWHo4VFpqeWxJS1dQc3Zpd2Fa?=
 =?utf-8?Q?9c8kiI5sN6apC6MQub81LN0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FRmzredOi9ze9HB5gVU4Pxj0MGyp4pGbZ8pxyd+lVdGOhHkiMqeuz97muX6lq3nTbEVrN24bNv0u0laAW/0Cnb7f+qTVVmCM39Qc5Tg4xROQ76QF+wtMgBm0KlsjobQtbbvW8TYYogJV1bS8Cp+ygysfmIqe03Cl5KHXXJXFzP52kfe6NR6KtG8QovfFoup+IPZAKmB03RxCF9qMt7Z5FUZKL+Vv4nOwSht4hBCJYTkfIIigfeq0tqThw8pIr8RE8DOIakiCVdwULhEe+oelkmdD+v7aJkJpZpGmD9JD3mkOynhp6OwdRYeJw5/PXIl9s1OIqHdxMB8WZZ2OTN73q+V9RFJDalxnDFyrUkSTY4oqJeaUcisUz/TrmUiY9ZoXfk4jPzhSjCyWYXOnr04A6TAau9L9c64fOwGSbZeW5lxUkojbDwq3DaBQBKq7UhNMEDBtO+5znFG33y1fWQ7sukKtdwuz5FHU71oirEXTA3oX2XfHgaoRPIumg5ndIwBsCEmAdLg0YhmrNAHTP5FLwc4zFAfvPayFcj6EEPVUV/NwFpTQIrDU3GVd3oHozFXyd6S+56ziK1mCndfRuSW/YpYJcVSeMgxPRuntuvSgHZw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a5f637-99bb-4d46-fc1d-08dd774221da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:40:07.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oj+OhAgK7jwlQgj4ouHItpiy/uekdc1+85qplBt660vA6qxPJhl4JGqzAlcrap9rkbCCOHcIuVHJ5qWJUgmdRPKKeRpkkDeNi5tIEGeHNVuJ23uWDbeAM6c2qDV3FXvd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF97E574FF7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-09_03,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504090043
X-Proofpoint-ORIG-GUID: KUmNttMZEYSFaPw7UMsPcNsqoJqC3qME
X-Proofpoint-GUID: KUmNttMZEYSFaPw7UMsPcNsqoJqC3qME

Hi Greg,

On 08/04/25 16:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
