Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F6F2E6CD3
	for <patches@lists.linux.dev>; Fri, 30 Jan 2026 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769783760; cv=fail; b=rgYN8od/lbzQtU08uaFOmQVOeqDdE2KGzy1N1dY7O7dqjDSk4TCYkrovBsciDAL4TxlrstNAyDxXyX1W9MbNq/JWKGF1ny/+GtC5pC4LWYFNTwl1uaKKzvqxyGWPxELvjAyjMON8CrcY+lw1Q4GmBCKgD6xnCZX59iR2G3QerBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769783760; c=relaxed/simple;
	bh=5XltZB824Wb75aZXTDDwvINc5+Qq1GeWAZgh97hAerg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LWlika78278DDHVFTzyCXJYnUGhFmfDrsVPsFRz4o8uMsabKevDBVsZLTSl5aYmPymmGJkbpzDjzPDcFJ35jvTrTrnsmrkXD7pkcYO2VLXr8bjnHs+CDWv2PJSAh9WOrJco6piHhY6ITMbxMGC6oWMOuC6VAnU1U6VJ/eFABnUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OkAkuNzd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hyGPnDk2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OkAkuNzd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hyGPnDk2"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UChHEB3324682;
	Fri, 30 Jan 2026 14:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PFkcPxphKqj3O/Ud6t/tkNhuMNQPsqRZPD18yJmaMA4=; b=
	OkAkuNzdNrTP2tPn+fRupgH/OBns5pL4Ki3XQyaWfQjfb8XWYsVGcXEWiygB570S
	7PlV/p1Lj5XTB3lyLw0+lKs7cGzU0rZYKlLou3ujR3Nc5RDuMSM5vr0EtHocYOjQ
	xW6fB7Xncbw2XQ2eqiCh4tJDzB1Viwu8Swkei09OCeE98Oi8bBAsEt4lZTUInL33
	lA9dl5beHF4aWN7mAVt3g+UKoAF9OW1Kr4tXUEuwoytjWQ/N6sDoOYeLdV4cow8A
	OUUTi4y7aY4Su0u5sDrQTHtJrXp99sUQ3/bk7W9Nc9nY8DGxvGhTndx3DlZS4HeF
	YQcUNGquh7ZGloIv8FNSTw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgnc2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 14:35:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UDl4PK032883;
	Fri, 30 Jan 2026 14:35:39 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdpwe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 14:35:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTwe1ePh8HB06wr/CotQ1unauKmkjyzmzFNRD+wu9GhGeh32fh8dfmP3iQ+V75o8t/0h3ujdaiwVM+SBFe+BHp5F544Uc7Wh9NiK2IGk03hQcN+x9uDOmdcovSCyzUGVctiG+6MRUoAktlJZxEC9rV/OuSQ80m4L7ByWFd3UFaR+u043fg22Zlz9TBekNzxaRzLEergDOiLsDCr9AuXTWNzWllFzVpTEwy4lJ4f2WhSdRTdjs5NekCKj9pjG8UIbnLrKGi4uSrULMC0+nvrMX9hD3fw31yMNbJFxtd9UbA2I7wO2wtBwTSwsuv/FvPnR570lJF33dniReLqz2x0uGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFkcPxphKqj3O/Ud6t/tkNhuMNQPsqRZPD18yJmaMA4=;
 b=v2Q9Jf8v0KSLiVa1Spylu3rtRIe5EN66Y1+oRn86W8OJ4Rml9Ge5kt3OG4tTYrVnXEqdn2LC7Dcv2oZJA5ie4lXacul8MReeW1RrtKQUwQT4EbCLLvFARHD1N6P5LdODGpiG+1d7PJry1xXSfFfColkJzuwzO2hwnHidzl9MbEotPesY6mxm58+ZJNF+0g+zHHOJHuNy+jeqaJ41wcdA3YqtzKP7GdE29bwh/rXmHTUr9R5++IyKmcZDQanKUEwbryNUVChljxQGAl8AzvY/dro4uWp7NCaMjJTzD2clFEF1rBpCHknLgk13MHk8JAY445zLZiXXwmbLaOVD5znSiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFkcPxphKqj3O/Ud6t/tkNhuMNQPsqRZPD18yJmaMA4=;
 b=hyGPnDk27lpA9SjYi8o3JZOm17ww1inSj/z4n6Ik62ABUrdW2Dl/ezCYqtmuCIDu3oDNoubxj17CQC4/dbKrn8Vv1WVIWI9CQ1kzaSvd3+CN2s6NWB1xaA6YvMr7zt4/DFJik7FizNF44ovHeunEEDcCFl9gauQFgI0mxPZaNxY=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CY8PR10MB7368.namprd10.prod.outlook.com (2603:10b6:930:7f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 14:35:28 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 14:35:28 +0000
Message-ID: <4503aa1b-f728-47dd-b675-55b4b2e40172@oracle.com>
Date: Fri, 30 Jan 2026 20:05:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260128145334.006287341@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::10) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CY8PR10MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 126a3c70-aa5b-4240-a060-08de600cd01d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TStzU0pUOGVOZnRqblMxWk95M3ZkS0xnN2Q5aXd5QWw5a3N3R2RWMUhvdUk2?=
 =?utf-8?B?OC9kWmJPNmpHV24yZjFKWHlpRTNSazVHdXlkR2YzOCtSdzZJWHViTWd4U3Uv?=
 =?utf-8?B?MUhnN0h5Y0hiaE1IczJJVVdTWmVEMW9FUG4zcTBpcUoySjRoczBnUEFrVUpx?=
 =?utf-8?B?UkxBd25OdUlyQjNaQ3FkUGRXaGZrUjYvZ0Z5RTJndnBsT2ZyM3g2eUdNWUJQ?=
 =?utf-8?B?dDh4SjRzWHU2WHRWUHJCaXJwR0d1VWxCaEtudWk5cXpDb2h4eE1qYUVCbThY?=
 =?utf-8?B?MStmeHZXdFZHcHlOMzViOGlMelZteUp2Q1hVWEF5TzFGKzQ1SlM2RnFuLzNy?=
 =?utf-8?B?Wnc3MThIMlNiK1Y5eTAyVHBjM29qVWczQ1k1TWh5K1hSNjVxQmduanpiVTJL?=
 =?utf-8?B?RXlvajBVYWxjeTRCNFczTHpVMmFYOVpQdVBzVGsrdU9xNVR4ZHhQOUlKNm1R?=
 =?utf-8?B?NE5WQnlYZFh1NVNjQ0tDN2liNW5aTDFuODBSSFVBVnJkdWVVM1dMRngvK2lK?=
 =?utf-8?B?SDBYZHdoUkpETW10U2tZUkw3a2tnZE5ZWFEzV1pobU5ySEtvL1V1UWI1Q3NE?=
 =?utf-8?B?b0VGSGJ6Y1NBUGs2cDZza3M3MjZMSE1lWUZsNm53eTJYbHJhYnVaMGd0S3Zp?=
 =?utf-8?B?akpYcmYxYW5RQ3NjYkROVVBUV0pHY3R1UDRnNDV2Ujd1YXJQS3ZQTnAvV0sy?=
 =?utf-8?B?T3NOVmJWMVZMVFlMZmM5cmpLOEQvTGt3VEs0NENITXFjOUNKd0tiVVZ5RFk3?=
 =?utf-8?B?cmJVNnhCRitjSkVPSDdUTzg0OGt4N3dmajh1cDZWa0JFYklzcHV5M1FhU2ZS?=
 =?utf-8?B?U1FBc0xiS1czZVZSMzE0RjhqWmNpSU5EV0R0NGtxNlJabEV2cUdXcXdyemlI?=
 =?utf-8?B?bmVLWVBuMWQwOW5EVWw5VmlyOCt4OEpOQy9BcjBqMlJyYVFkeE1QMGpUd2Ir?=
 =?utf-8?B?OGFRS1V3WVZQRjcrenZJN1l6VVhQczJzVlZtTm5zUmV2OVpYbHFpRy80MkdH?=
 =?utf-8?B?eVlJZ3liOUpKYklCMktLMTZpcmZ5M09ycHVkYTQzM3d2bnNyTlltNGFaUzFT?=
 =?utf-8?B?aGJ1OW1NZHBPcTRtVlZTVVFRZFZxcFlLQ3crWUtUNjZlL2J0NFc5WWdoVXJt?=
 =?utf-8?B?SkhEaGlNbUJEOUpkUEllT1BGQ09oOXFIWmxWeWlDU2FuTkgxNDloRWhCaUYw?=
 =?utf-8?B?bTNFUW5FNjBmem9nYXFPNEJjcVk5TEExWkduVHd6akFxTlFySFNQUzJRcTQ4?=
 =?utf-8?B?UjVVWitqNGxRT0swZzFNMDB6aWwvOWZLRS9xREtLaFFQOE8vQW5hREZtL0o4?=
 =?utf-8?B?NFJZenpqR1BCYStqMUdIS0J0TkFZVFNsVTNvRkdaN2NETVZZNzVPOWMwbi9M?=
 =?utf-8?B?KzJ5NGVCZWs2RE1TUW9qWUZ4RlVVRC9PaXg3dXZNT1FVdEQ4cnpTZTZWNGho?=
 =?utf-8?B?cjZ6ZndhMVdJbitBNnFSSFlSazdhK0ZiSVNoNk5CdTZjUGhHdHNYd3A3MGxs?=
 =?utf-8?B?Rnh2b3pLM2FRUU44dVE5aFRYYWZkbWZTenIwVFhzT2U2VXFwVS9IbzJxdU41?=
 =?utf-8?B?TXAzQlkzYkR2NE1NbjBjdEdzZ1QwNllSbGQvYzUwNGxVMUR6bE5vRlhVQ1Ar?=
 =?utf-8?B?Q0ZTcVhVRWpMWWt3VDMvSWpOZUloUlBoUU9HNW5TMzhZODZ5MExLSnJoSzdm?=
 =?utf-8?B?WFZSVVJ3ZDRrY0tJYnA0WlNQeE9vQ1Z1WHpMSUVnWitkZkk5eEh3dWtJbGdZ?=
 =?utf-8?B?aVh4QUNTUWdISy9lZHNVNkRZaWcrRCtXT0UrSVhlSFBJQVQ2Ni8wY09TNm00?=
 =?utf-8?B?U2hpMS9XNDFiYmg4UFRjblBEbzQ1aDFFaVRGa29aclFzSEJwbFRTTyt5SGM2?=
 =?utf-8?B?S3duZWJoQ1RMQzFrcnd5Snd5ZnVaK3NabmNINDArME9wakV0d3gwT0Zpb3lQ?=
 =?utf-8?B?M0pHa3diUytJdTVXTjVQaStnNnJxamdlMENzZ3BXQ3BKTGlkQS93MjByeEM5?=
 =?utf-8?B?RWlxZ2xMRG04am9JTHVBZStlU2dxWm9FZHBWOWg1QmxkZnNRSk4yVkVQbVIr?=
 =?utf-8?B?VHJERVlDVUFCWnJyL1BaTFg5c1FhVVFSVERFM3crWm9RaTBkUEJkUHY4d0VM?=
 =?utf-8?Q?b//K+Hd2tO/udRKZ3Rawizz7/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVFUemFhYStwZVBycGRiVFRCRUd0WWk3ZEt4SnVhQjFRK2RMeDlNMWxsSkxy?=
 =?utf-8?B?dW00aEJyTFpOak02UkpmandydStNQVI3R09mYmhXbWQ1QkRxOG55dSticEpz?=
 =?utf-8?B?dGxyYWlra1hCUE4wKzFHR1NIZlNFY2lkZ01ReWROMWFGdkNCQUhrMUkwbmdq?=
 =?utf-8?B?VzdBcm0rYkJjRzBhQ1NxVS94OVhMSlU2dGxROW53eVkrdGVOdE55Y01EQlNh?=
 =?utf-8?B?WTlUN3lqQkpzd1BiOHIza3ZPcllaNW5QRVluR0NEbDJDRFk0MXh3NURnNS9R?=
 =?utf-8?B?NzVxM0tib1cwRFZYVGc4TlNBY0U4VFdzRmxuZlh3bjJhUnNHd1pUMmJMb2Fm?=
 =?utf-8?B?c3hkQzI5NzJIejFCRHNKQ05UNTE2NlJnSmhPOUxYWDNOU2V6TDRUUTBLNjVT?=
 =?utf-8?B?TWRxUzZBNDdvZ3Z6d1NVN1hGditBSmJ2WTc3RDkwK0VPeS9UTXdJRVlsUDVh?=
 =?utf-8?B?ZTMvWWU5VkhmczFpcUxZaTJPM3dnaFM5TDYzY0tIVXMwUjVnenRZTlArT1Fj?=
 =?utf-8?B?eUpZcjJuSmwrUTk4anMwUkxDUCtiTEZnbW5YZytNMVZFZmlBZHVPb0lOV1g2?=
 =?utf-8?B?TDBQZUdkbTE2c1hiL1VQSFBLb3QxOE9pY050U1VOMkpIV0FMN1RvOVB2R0xZ?=
 =?utf-8?B?WEgyU3k0c3Q1aTBtMWRkdHZYS2FIM0crb3ZBRHltbmxFZlFIaDdGbzRRMFJk?=
 =?utf-8?B?NkJVeUJ6NnhMald4M0lEQnc4Z2wveWcrZ1RVMEFkTTNoTjJLaUxRR3Zxbkdn?=
 =?utf-8?B?RWczTUVzTURUOFhrOGh2R3Q5azFCamY1dXYvUlQrQTVrVDdORDNuU2RZMHYy?=
 =?utf-8?B?NlVpQVZERllkVWRUblk2K2cxem9UcTdEbERQb3ozaGd3M0k5QVZxeTNHcVZV?=
 =?utf-8?B?VmFGQzNrL2g4WUtqNTh6ekE2c3lmMnNkZUx5QURtTndCaW1JMzhBUG5CaGFO?=
 =?utf-8?B?RDlQNEVGV1J3cDNSaDE3b2hCcVl4WWJpTk1VTjRlYlExWXp1dVVOVk42VXRw?=
 =?utf-8?B?YmxqTmlyMUZ4Z1J1Yk1XaXZxNWx6VitSbkpnc2taKytKbnk1eTcyaEFWVkhW?=
 =?utf-8?B?R28wb3hYWi9JV3VTcC9HaVhUSTh5UkREdHROTlh4M1lDcW5YZ3p4NUJGb2NB?=
 =?utf-8?B?QXdxRW1YUTVYWkpWc0dqcGNFSjk5UWtTdndveGllelFXU1FXOHZRcDZFeVhM?=
 =?utf-8?B?S3dDaWNORHJNWWR6SDFIVzcyY0F4bnFGY00vdnY1WHp4cWRkMnUvQkV2VjRY?=
 =?utf-8?B?QUdYOGE3U1kxVnIwcXVKWVg5Z1NYaGMycnZJM05FWnlyMnBtRUJsMWxkWllI?=
 =?utf-8?B?N0lGUXRWeUQ1NC9VWTNsSmcvc3o4SFFGSkQ5VEY1T2hvd3prZ1VYYzFkR2pu?=
 =?utf-8?B?WlAyY3ppTTJvV1F2a1pvUjlaRDIwc2JGeCtURVFGbU4xYjhmRTJiNi96SEdy?=
 =?utf-8?B?VkFSaDJ5UndIK01OdXVBb0Exc1lYOWwvWDFhVzZkN2xpKzVObWxVZkR0VVlF?=
 =?utf-8?B?UlVOeDhhMlhsWWlZMXN2akdJWDliakR5cTA1N1A3NXJIV0VTM1R3TVF3UDR2?=
 =?utf-8?B?WkVhSHBWNHpyUnMzTWZaL1pPWUw4VEE2bXVlMFMyZUZmL1UxOEZaNFF5T0g5?=
 =?utf-8?B?WkZIVmhWbnFFVXJ2cCtEcFZwQTNJdnJLRmxyVW1uSzJLQnptdXdCNU1UQ2tn?=
 =?utf-8?B?dkIyZThpbmV0RkJCbmlwNyt5bFFuMFVFdWNlK0NPNDhtaUcrVFF3SXJlRXkz?=
 =?utf-8?B?Qy90Ymt6VVRtZlB5azdIM2tXU2t2T2xhc01nTW03VEdLNThiV0NsUTZUOEZu?=
 =?utf-8?B?anhXbDBtVVowY0twa3dkeUJsVktjOXVXdTNXMWxQTXpkRkY1Z2JET29IUHkv?=
 =?utf-8?B?RTJIaE9Od05iTE1JUWJGUUpCRVIvbWNHckRjcis5eHpGVGg5RmZPQzVPd0xM?=
 =?utf-8?B?bk40TkpqaUpvVXV2QUViL3dtVlN0WVgyYVBYQlczRGFpSzFkZTh2aTNjZU1x?=
 =?utf-8?B?N1BSSzR4aUo3WlNMMmV0UWo5MjdmSS93ZTArZmNKQnlQN0Zqc3h1ME1QeThj?=
 =?utf-8?B?Um8wOVF1Mys3dGZnemxyOG5vYitvazc1dEo5U0RIS04zYW9HWVUyTk1GRTV0?=
 =?utf-8?B?NXJEWk9yam4zSkdyTW04Znp6SlJYWmMwZ1JRMGQ1dGp1ZHZBcGJ6ZTNOa3Nz?=
 =?utf-8?B?cm9KOWRJL09RaGJXMmVHdTRTK3l6bndtdGdYcFJnb2pDaStjZW5CaHZYUHlL?=
 =?utf-8?B?Zms5WEpCak0wR1dlNzV4TVl4UnE2S2RMZTMvUHJBYklCaGhSSWptaDQ1TWhL?=
 =?utf-8?B?bHB1M2ZvVHoyQUJQUTU2bFkrYTduVW1UZmlIRlpxSW8wbUlnRVBjdFk1LzI1?=
 =?utf-8?Q?lNJqEKOI1KwZdGVgu3ktqVWVGVVj3iCiHDwNl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9qBBVrGoWaUQD1dSnQ9epEUS5Ow7RzLRf8QDJQNpXlsXTWBbuYRhDcLcXTeOluRZuHn3xVgny+N3/abXSj9nKS+5dybaY/5F9qcoK8yCAHmmuyKL4hM8AKyu656cRmomRt76hNR8+U5ZY2I4tDVNbpbXT3QOouCaHtwDtnQwdLmy3ebqp6nlfWEEd/CQJzXHApCUyAtgSHcsuJyU5nPo/lLijE3szVSG3F+CbMsCOVtLswM6piA2dgq9WBc1V/WOvbKWTOiqKNB5PjZG9eZsGoMyHCYSKcEkzLGUQHAJT8jzo9MVrm3stNr090w4c+p84QudHdhsZ77Do2VMho1A+RfMDYqm67InIpyjV0IVDSg4W8vgEICWeP4Py9aeDTi60lbL2FV36r73Js7AwImE1am+0tDYJZ+g5jcOlHaeyykqMS2tbAVC36v78UAM5DYxgr79pvz1Y8Zu/G8LhxP0KD52YaOzLyRKHDfWQDQHHsFeN5rMTMNh0UnK5U3cs6YFwhLeZvxqIeYWK7MygcmrxyvEd7yUdf4RfOhJJ/0noHfnjIkN/d3mT2EA4UvNd35PrMGSItA//v8tDmeKONLtaTnFDcF6JfRB1DkKivgpocM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126a3c70-aa5b-4240-a060-08de600cd01d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 14:35:28.2631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmINMTMweN0a22w0OjteJZz+H7SVSVlGWAHt5itp1VF19Ll34ajotfSP+gA1x8Ce96MQbbiXbpYp6M09w/gLMT5SAb8Flht17ghZE6NlXsQpS87mGlvLa/Xh7XRv1pPa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_02,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300119
X-Proofpoint-GUID: W18yE-svY_LxUvv5pWcmmR4fsYRx7wxM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDExOSBTYWx0ZWRfX8yg4qf6U5u7S
 7o+ygO6pIonmCSAoH4O3e1gjRcQkZA5qq5GUr0lvTITN60GYtrfBjIaFO5Yy6wjQ/wl80FnP/f9
 C8vGLkEN8NeTPzPoiRmIlqJt7Hzvm50RRk6BxBSrAbJr/XvkECLXZVyZBYfLkjOSlKT8ZaWIMrp
 LUM4P6/7PD0YdtxFmJTlUNXu9n2fCv4LiyCUkkZXwDCRhkVj++C2LJDNCt4W6CxiSYZRk/OeNTS
 cWdltdOrNaTbPEvCvWQ6yO4pM7SQ0yftYkLOkFhDHAXO07fbM3jnxiQamiqOG3SoiH2uhSCzyW7
 yvpm65Nu7HsDt8KGUQ8fleoLvvxwHRZ/NGQKJUrqXLHMJ1VheP54C5x+ITrcfg1mjyzko0KmJbg
 ultlfegCeEM7Mpgv/22Fp4XZko/N5gPtQHLLMTiHwKIZ/SMqOPiry8rP4ZkGGoyGZFZ5FIF+JLH
 Sk99lnDtzLNJXc7ChUA==
X-Proofpoint-ORIG-GUID: W18yE-svY_LxUvv5pWcmmR4fsYRx7wxM
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697cc1bd b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=SvamILqpV5Fuj3Hew5YA:9 a=QEXdDO2ut3YA:10

Hi Greg,

On 28/01/26 20:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 

Yeah, I delayed sending the results. But:

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
> patch-6.12.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,

