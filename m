Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726C1DD543
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750703031; cv=fail; b=riBcY5u0Ne5ZBG0+w6PaNq4YC4PBQF1elczqYwEc1+JiXGESXn48v8yvKYTPFtAjaMYLDKAiHnl+i/z1UzJG2MCUcTIID+NIs68+PQ+NwgBv52Npt8G4W1du0TLW3ar+MXAqzBmDMB+Re92gi5bP7JxaYFwgKR1TPRHzA1+55HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750703031; c=relaxed/simple;
	bh=2BtB4ghnbV2IQIFkmUgUiR1Oh4BwD70kBXxz9r9GCOk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aHY4j23pazJOts81lRw24lfJKThVhJbRlQ3LtbqdA/HjsiH01UEfp1u7KRxmKYuOaBIBI2+mo4iUoQI4cG1RBkckor3JlsquGE4gVVoH1MSDNxJ6M/f8PB0tVNk50f3BQOmAsUsZ+Y7FFOKOTXq0F5e8o7nBLrbVJiUkS2TKDLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VUTl9r+V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w/myuSGu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VUTl9r+V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w/myuSGu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NGY9CU017670;
	Mon, 23 Jun 2025 18:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pWZzYysdWPpYSA+oew+PMHeg1Z6O80m6rMPYxzA6Hfc=; b=
	VUTl9r+VmnA6/kpx3qqqqON5XTekhwlx4f0988RdPm8UFLoB3xl+IkoBvpgxhnQw
	p7uX8fe+Qq6xoVKkkmZoOM4csnCXiIrlm/xo1TPm4nMmxHVF6xDDQPBqOewjhilY
	/LU4izR1BZxBKsdNDEmXt3DpBDMgUPl+AZIGTObOIqVFFdPVVNlXZnY6rpcO5nBT
	YiYvgiVBQUqlCHjzJtw19tchopQWEu5XScwVbcJr2/AU1Trq1QNRf60eRy8uvtnl
	P2G2gF5VmTzjjD29e1hMdPOsYMvFMkLQI7PtGDd1iNtFOVbe0K3AiV6kdItbKPYz
	vOTmhgAjGp7Vkhmq3S4lZA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8y3bqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 18:23:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55NINMAZ038912;
	Mon, 23 Jun 2025 18:23:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehr3p84y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 18:23:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uCzYwqjy2x88oBEg8hfDtqFvPqi4BP3/pY6+iv/3fii5RD2+mAfNiqUoprNz1rC5RVkSHFh6a8mo2a6wrr8qJenUT/PjeL+JJ6OXiynQr8zGFBGbhU7VHlgBa5JsS7pMDmWGyIMb1vjPoAH084jWUbSsRdmKlhsBuxRNhprH9CjeelVsqKKN/owBlw3qctzwMOKVAMEPGBFmM527b5pC83G9FhTFsXkzGdaecSQFp8c6OvHrhBs8G4SDOPerHnSx6dVIHVwPKSTOH0mo0Q7F1/yMTdzxD1v2Erv4JvL761n1hks1dSa24DD/iOKCm4t2m3v7bdOdBigql0TNnzQzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWZzYysdWPpYSA+oew+PMHeg1Z6O80m6rMPYxzA6Hfc=;
 b=wecfRem3GNmxu90PAKuUdMHraZFt01gGzfvIFDqE610TITItrjpCHYrG8+wifHKwlICRJVMzHEuzt6pcTBqVOz3Uq9b8ihaPdmXvUJvVZympCLOruIjpWjg+7OVmuRbJ+MW3yVZ/wyv2DWeMXKpRDA1h0TtQFiFPfWv1cjq+k8kZEBsllou8JYIphrGHoX+SaBoAr+ebnt/+7+NMW6YIewuSHLCiDl3m15gDXlzwc2WRhYodkDKvErwx8zPrbzIUFaoVi0hHnTLk4S69uSs3gWQLjh5VLUsTwI3kfpeZj0FRPlDJeRdfKrNy/HnbohVO0D2JfP6PMWzNYNI5J/rT6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWZzYysdWPpYSA+oew+PMHeg1Z6O80m6rMPYxzA6Hfc=;
 b=w/myuSGu2tcJFpm1vXUTqASoqZ+KrpHdEXKbrYW5lh7hvrtEiOtjJtz3DZeR356TUxUynKyuAPdUCNSJ8ALTdMPB5eBQO8Ok23GVnv/WBTicjOWcIAoeX9PnJbn+A3KtUbvZTuznNelqDD/1zUN929xHePzCS7izShXATlLdNQs=
Received: from BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
 by SJ5PPF4561E4FCB.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Mon, 23 Jun
 2025 18:23:23 +0000
Received: from BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c]) by BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c%4]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 18:23:23 +0000
Message-ID: <69518153-590f-428f-b713-fd1fc06e8c33@oracle.com>
Date: Mon, 23 Jun 2025 23:53:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/414] 6.12.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250623130642.015559452@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::14) To BY5PR10MB3828.namprd10.prod.outlook.com
 (2603:10b6:a03:1f8::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:EE_|SJ5PPF4561E4FCB:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb118e3-66a1-433c-9f3b-08ddb28308fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wmx0T0FlbEl0bnh1S2pObTRQRnVuUWZkTzhnY092eW4xR3NtV2tZZHFkNEZl?=
 =?utf-8?B?MVpiOFlFMkFSL1dxdUlCcFlCZFU3d0N5VUszY2hkV0l4bEMwYjFtbS9rcEha?=
 =?utf-8?B?enlYMmFmT2JKWUhLMFJwQVA3bm5XTXFTZS9oMlNydTVHYUNQdjJwaG10bFlO?=
 =?utf-8?B?dmJ6M0pHTXlkUU1GdU1haE5XaUZBOWlpZXphdyt3QTByUkQwRElwZFhiS09r?=
 =?utf-8?B?dE5obisxbk50cUlzR0dHWWFPcFN6RnJtOGlxMXpPb1BYbHVsRWpqTk5lMlY0?=
 =?utf-8?B?dFNDNTNXR3k2UXI1VXhGUEppYmFEbGRvQ3ZpUVdXaTZjaFh0RGYwRW92dkw2?=
 =?utf-8?B?dFBpQ1BRRXBaYnQ1SFZGQ3E2MHo2UTVTZWNWNEtiWW5aUXd5TmdRU0ZDQXZR?=
 =?utf-8?B?UUYrZjRwd2RmWENtbjFSVDlYakNNaEQycnNBck5laWp3WnUrcmZtRHMyMEM2?=
 =?utf-8?B?Z216em5XVE9lL1BENCtqRmlXNElWaFNXS0FaV0oxdXpjTE55VzNPZVA2S1dO?=
 =?utf-8?B?dCtnMHdtTTFTWFAycWRDVWorczhVM1JVMTNBU0dQblZ0TEFTQTR1QnRVclBy?=
 =?utf-8?B?Mzkwbm9mZ1BvdmFGVVhnb2RhWHBSOXhyeFd0Q1pFSzUxcXVwVkpIKzAyRng3?=
 =?utf-8?B?cjc4d2I2bUN3dkFoZDNqWFludGI2ZTRxdGZnMHRTWWVmUDF3Qm56NWRidy96?=
 =?utf-8?B?WTVrRklhVFNkT0UwMzZIN0VFcUZTZnpySSt3cEJtbUQ3OTlKVW8xWmgxUUpk?=
 =?utf-8?B?aDZIZnpaN0xnUVI5OWlhUGZPQk5pTDNPK1NsWjM1aHJEZXlxeEY2VVdjbkF0?=
 =?utf-8?B?bWJSQ2pjOUVENTVUSTVxZTlqdFZ5aW5WcXRwV1luYklhdDRRazIrLzJ5Sk1l?=
 =?utf-8?B?MTVFd0pKUzBWM283akRsMTJUYzRLZmNpY2oxUWpna2xEbzMzVGR6UUlpMGFl?=
 =?utf-8?B?M0lxQytqbVpzSklSd0p3bFdOQWh1N01xeEJYcHN0YVFBQ3R5SjRoc2dyMTlj?=
 =?utf-8?B?aFNsZFNpRnhqc3R3SGRWYTVTViszWXhwS3M4Vk56c0xtL24rTEdyOEhxei9T?=
 =?utf-8?B?RGs5a2NxNHJkYzZlMFJFMG1wT3FWZmNySE5CdFdaRk4xb1ArSS82V2k0NE9I?=
 =?utf-8?B?U05WRHdyVTZNbCtZRi9qcFNhZWh0Y0hVVGRVSGRKR2VkSklrek5QeEVNMnEz?=
 =?utf-8?B?SzJtbFdmK3cvcmhkV3JiKzEwZmpyK3RRdy93Uy8wb21zRFVnVTN0ekk3RE53?=
 =?utf-8?B?QXY5UEZnalRPRUNtQnNVS04xNi9SUnpCN0R2OE9sQ0h0MmVWQ0JiQk53ZlBS?=
 =?utf-8?B?MTFGaU5FeTFvT051eWt6V3FwUmZHK3V6UytldkhsRGhkcFdiUWNBejZ2d0Zr?=
 =?utf-8?B?Z3RudGk5R3Q1MzMvSUJ4cFB4bDE5STg1aHY0ZTcvVWpLaTFaMXRyQ0ExTG5u?=
 =?utf-8?B?V0UwZUV0SFoxQnFFdEV0ZTBteDF0U3JhTE9GeUxERzFOQlZGTFRHVFV5aTUz?=
 =?utf-8?B?MkNjYWhENTQvdSs0Q3VraytHZUNpcTVGNFVHZUhWY2dISlJaekdIVG10cjg1?=
 =?utf-8?B?U01KVmtJYWxPRTU4NHhyRldnSmd5ZXp1N1M3TzZZNjJHRlVYa1Uxd1AwWkNB?=
 =?utf-8?B?TGVLQktCS3U0YUludzNmTjVmWVUrMCtKTWR4T2xYMll2NE9vMnFqZ20yV1gx?=
 =?utf-8?B?UW45eVI2ZnBLYTcrNnNzM2x3MFV4K2J3MVYzVmVYaU5oTE9lYjJEdnJka1M2?=
 =?utf-8?B?S3dKQXNUS25vNmdyOFlDZTlHMi9MNm5SWElJUDUyV2JLM2d6djhFRHFlZVFh?=
 =?utf-8?B?RHVsQ0NqemNYbFRNSTdiOGNRdXNEeU9LaDdzL1Z3WUpLVzFxYU9QNUZxa3Z0?=
 =?utf-8?B?bzd5SXVVcGszalhocjdJVE0rcDBLaDFYeHNFSThRZE9zR2NRQ0M2a2hmZFQr?=
 =?utf-8?Q?5FIjwtmK9UU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3828.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzB6YS8ramFtU2htazY1TVFBU3ByMlBZL2Q3NnJPSU9HVWtqd21qYW1KTnFx?=
 =?utf-8?B?aHFlaFU4aDdxNithTDNScm8zTlljdE5COEMrUjFwczg3Y2l0N0dXYjNVcGhu?=
 =?utf-8?B?Rk43Qmp0N3duM1BWeVlLUWliV3dIM2FZdnhRb2QvZVp2azZ3UDF3TEJodU12?=
 =?utf-8?B?Y0w3QnNHVXVwVDRYSEduOXFFNVBwUHlnTDhuRmdOVk1ib3hFaUVQYlFQbEw1?=
 =?utf-8?B?aUoxcTJWdmpkN2lPblIyS0RyY3JiUDVRenJoNnBONDFyaWpUZEZydkpzaDV2?=
 =?utf-8?B?ZnBOL3lHZ0R6Z2ZPWE1LeE1zYUJUUUt3WHVKWTgydEhIbFFQV3NidUwzK05L?=
 =?utf-8?B?THM2eVhab3VQeGMrSWxyQmF2VGxlTVVVM25KL1ZFL2NtOGgzdFV0RnBabUdL?=
 =?utf-8?B?Vk5XNDROM2FuT0RiZ2R6TmM2THpzb1VyTHdCVXhMbUtLVHViU2JDR0h0SXg0?=
 =?utf-8?B?REVDZjRBd2c4TWpTekI2SHFQVU1sR2x6d2U1YnRFc1ZPOGJsbUdsRVNGYm5o?=
 =?utf-8?B?dFZ4ZzNuQVhmaXhtcHl6TUZ0YWl1RDF6KzlvWDhpRDFJYzJINTVQbkI4Z1BS?=
 =?utf-8?B?bGpvZHJaNE5JbVJqOTJadWZyU2s2NWc2RDg0bTRCWXFuY2cxVmh3ZUV6enF2?=
 =?utf-8?B?NXZrQ0hYK3BGMC9idlRUMWJ1QXFJRkVsZnFOcm42TXY4Q1NoVkNwcnd2Tk1t?=
 =?utf-8?B?UXgyVG9TQkZwWUlIckEweVFIL1lmK01kQ0VaQklGR2s3dzdKYkJkTENnc2c0?=
 =?utf-8?B?a256Z2Z3bXhFRmEzSHZkdzJJQUhNQXNDSit4dTllODVwcUljRUZtUWlHV1JG?=
 =?utf-8?B?b0hKRzBIM3NReFhMY2huUzE2OVpaanJZTW9mUWlnS2VxS1Y4T2Zqd2tlWTJv?=
 =?utf-8?B?RjNWaTNUdUJJOWs1TWt4Z2VTdUYzZnEzSzBLa3NFT1FhWFVoSnZWWWFJOXNQ?=
 =?utf-8?B?ZUF2eHkxT25pcTBQdXUrV3BFR3NaM3U2RDdmYitQcHk5ZDlVYzV3dVNPQmdo?=
 =?utf-8?B?QVZXZTZvcFFsVHpGdDFzMHpiOHFwMFEzZHBPVEZNVTJnTjlCRHRWbUZ0dkFN?=
 =?utf-8?B?a05OUmxPQ2x0L0FBR3UwVW9WMGg1L0NIMTJudGJ4MTNhbWl0Qjhucm8ySWd0?=
 =?utf-8?B?SlBLT2l4Nm5ZdFQ5eEUzWWJZU3BkQVpUbHdRTm1IUVg3UExySjE5em84VEFs?=
 =?utf-8?B?akhIL3g3RExXRzNHLzRyZWZLR3hOVWdyVW5VdDhxR251a0V5YlRvL0xlZUhw?=
 =?utf-8?B?dGZGdzZRWC9MZ3Q4RjY1UXl6cXl5T0lGVjhEWWVNNVJWeFFadmlSWkd4MGl5?=
 =?utf-8?B?SGg3QlNVaGdjMkZhOE5YVlhXMTdZcWtBRnRnV1ZrNzEvVUlHVkhxbCtuemVD?=
 =?utf-8?B?bk8zUVlteWxHdThlMFZObTdjYTVpWndMeXN3RFVydTdpcUQ2NVc2T3BUQWJp?=
 =?utf-8?B?VXdZZW9FdDZPb0J6WEM4TnlzTmEvQlJKaWRmOWg0VXZscTZ1VU1CQnVieHdh?=
 =?utf-8?B?MU5YVTVYMXg3SEZoRTU1S0hORFJNQ2RDbnh4SlZFaWFzcTRMR3krc1hrdFlq?=
 =?utf-8?B?dnNPRjNoaEZlM2JSYXVtUjB4N1RnT3A2b1NXZnlGT2hUbTB2MStZRXJUSEEz?=
 =?utf-8?B?a3dSY2xnamlIbWdnejVSSGhkK1dVWW5GdGQzd3c4dEE0VDNXcVBxcE5tWEto?=
 =?utf-8?B?WFMrWnpWZWszbit6UE13ZHFxY1Q1cndTQ1lZUmt2R05Za1RvbkhvVU42NnVM?=
 =?utf-8?B?WEdiL3NWOUNONXFqdnJBVTFrTklvY0hjOWtyeW9MS2ZhbkJxMjV2N3lmSW9Z?=
 =?utf-8?B?ZnkyT0xtL0xyejFoSkJ6RGFaajRScEM3eGpxOE0zM0RLbGtWVWNlSXlhaTVW?=
 =?utf-8?B?N3NMQ1NGSDBNakdOT0xDQ1Y1d2JDTWFGTDluYXJBN3Q4dzRJT2I4aUNYOXBQ?=
 =?utf-8?B?SUlwN0hEb0VTL2JYa2tsWHBncXN2VmVLYW44UktvTTVzaFJnbjMvRjJMVE52?=
 =?utf-8?B?RXhzWXhBb1NxRnJuMEY0SGg0ek1lVTFXb2pDTlpkVDBNbk9QZUp3QTBMeDJQ?=
 =?utf-8?B?WnF3cSs5SXZ4bW5VQUI3RWVCbyswZFdHck9mNGlRbEZnQWxYcWN1SVM1WnNt?=
 =?utf-8?B?bnFFd1FVL2dtdEN6WkJ1b3ZtT0xJVnZNQ1d1akhWN1BUbnB5Y0ZDSnVNQmhh?=
 =?utf-8?Q?y7a2WB6w3r4WTl4c2n1nnqM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EjVyP06PgnAUMcXZ5b7DBvYK8ieUYbiEFVv/238xEsDLkwPTgFEhqBLXP/56JRKOEV0ojBo4fodfRtRvVO6I8+AGwN6yNol/c4QDykdkFvsEjEE5DhwQSbyEkq1TqYigW5/6s5XW/APB1OmnKphgWsA/Rl/6nAD5BW0cmeZT1KvbXILqP2EjbDbt/8xrRrMpvZmlA7kqDrdU6b70HTZwwJZJTrLRxeyBZb97zaOjqja4bkeUSxq6TmoAdeV8Sm4DMA8Hq3WnYISvFtAfE/UtTVPP3TZ2ia/G93PX9crx/f0h40B4ZrBdvzbYFHpf0XRtz2UbsUc/UsTcv9Q5w3piZq1SZwNI8D0LMHMHRw0wQmaAywrZFDuTFVRNkNXSg3eCHke0NDnRgDVaAHwJdXMmcMIUTminCUSlOBC7jllq7FUhfPpoON2yxT4/xuNz1JDfrxw3dMPjcGoy635QO143ClPYRqViR99RAuxCHPCMIxfs0CcdkzK4jiZT4DqqmWRAB2hlzixR52LUlMb1ob/uxiSgro/0bRQ1+aMm8QD2JkCou1NMMbVGSihuBU1GjjX5+KLz2U+zXpFWVKXzq2WODJvlFNGWm2ChrhziFqSbw+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb118e3-66a1-433c-9f3b-08ddb28308fa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3828.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 18:23:23.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqiFp8eK5iwe2JHq4kaip5uBWd0QWkSKyO7Epo3Qf6I6Tdu3Sr2/GPG2P69xAfAX5+pCFBmXB+Gmkt/qtuDnh+CpmhUBeu23jjlaYkAzEVPZ+C1FgaPrOnK+w1x1N6eu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4561E4FCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-23_05,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506230116
X-Proofpoint-ORIG-GUID: gOAsuvlK03lIBpF8O9SU5IwldHfy2ERl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDExNSBTYWx0ZWRfXxl1wnDD2xint 9d4WwBKj5RXQQSDE9GGMfv5btE6iQW1TYcMyKLakckYYJi+ZCiwhm854eCTiXCnNBPSU8rw2Y+v ILbDpLvY7Foafu2bxu/8z4fxgGCu0s1TusOKhQMv9I/2OyTzySAQ1gPxh9nLrFSAWveyzUbMZQg
 aVTAWlHzemhHuAxNO3vviWrmkm27a+8Bp7TyIPJm3TXsYCBCVi45ATRCmouslHLrgIzG/GQIcEP gt2WzCvKOFl7m29Yt0gNNRhWzZ/wmo/OopF2tiYAM/xfxKpC/XUqTkGz1TD5nlP1l1WSJtLUba7 ZVEmAJt2h9ckosu3w3lciVfWuD6XnHC3rrNlq3O/Emm+8ITy70fofgPyXOv2/eh7PZCAwt7l3/R
 ZHja331GnJFAUKG5gzTp0QH4BXhXsTYt6r3Ewc6TqgHJhligHd+XW4ZxMO4CqkEuyAbCfhnF
X-Proofpoint-GUID: gOAsuvlK03lIBpF8O9SU5IwldHfy2ERl
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=68599ba0 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206

Hi Greg,

On 23/06/25 18:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
