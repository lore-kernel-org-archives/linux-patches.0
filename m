Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6E3FCC;
	Wed, 19 Aug 2026 07:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123530; cv=fail; b=RtOE04Kp21C9VGIINvCsiCPza3e4e1RxMTeDoKDrOsXDByr+u7PRbNGXOVihNlhbL5nO2c7kc25d7/k0bh096u9ah3fseU6AyP5RCi7ZRmOypLyIXiL2fGKPy2u582Jkufk0zrCX3fFaLEWxUfk3yUaCpy+/V3kGbFtYV1rY3Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123530; c=relaxed/simple;
	bh=bHZGkC+8eQBbkXeWn988JDIXDSCNvi3CWPCMqSPVttk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tdajq4/Kk14OOKC+nxEzeB/Pylzay4mwE5EVV5/hyxmYEMxuJRJE9skyhUUBCEA+ttVNkVMPjlpVlIrwqHjJrF/ls85FntyT6HPcVhedOgR+K9PrWoRapLJpeHuyqXG1b1msrWRirZlQgINzEvqoJc9h6/OuLNRnmGVGDhjc16A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bKZ117nj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U4rNt/yn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bKZ117nj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U4rNt/yn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ILXVqw405484;
	Wed, 19 Aug 2026 07:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tEa0+8HDR+mEALEyhagIpJt8Bek2jSx+g00j18ibwWM=; b=
	bKZ117njzxW27wE0iixWmpEMGJlFw+ZfY+G4FT3kJ/T2HAPyCIoso1JO5aLhj02H
	KhWErJtareQ8QT1BrKsznEj5Cr87hSqTspsUdcEU76GRwf+3yJm1gj9G2w+8IxXj
	XAPoPILOaBidgZhVTCD2Kw1cInz0WGBCQ2+b1iGX4rx2cKkIFz3s1x3dtmyh316r
	S6n+Px/K91gE7acrn9aIOE9X2MF+xiiLFALFOiXoMTJbbLkOlTq24EhSblG9NiSu
	c3hqrWVr5YHO6hJxvsReOkVPPpd4lY8wCKUvnd1zGIQWsDXb4EbY+RfCvUlTAPJR
	oEZ9mn8FaDVYCYmNBmHc5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g4ydb0jct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Aug 2026 07:11:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67J75BNE010518;
	Wed, 19 Aug 2026 07:11:58 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejdv6yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 07:11:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VkWn2z3tWhmlQU4fEVTeWIG+sofXxYuJQavDxNkWaTEXOB6ILei2C0O9Lp3vPfrGFmh15IIKR/jdZ8z8ql6dF/c8OKYj8gPUxC/FdfBYBvksGCHUvTXYxOOOYJUduUgiNFefm5tpK3XICl35KRZ8t7w1wRqW26W8Ryy0pA7p0++ffziXszKt1nv9ytBYg/MH+WGfc6hczqkD/6kV6CQgrCJXuKMAet/wLg3kEsg9cDhx+KbvFFlOfxnd5ocbmPdgcKWmPTde0Iqxc1qJFi/hEZtALcz2Bf/DPLHufEdpRrl2dHRLWKYpCofZZX/x21GCcZEDRiQwSJdHIpdtJkZhsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEa0+8HDR+mEALEyhagIpJt8Bek2jSx+g00j18ibwWM=;
 b=xcdhe21JwDTPWbEPIU4DcGOdw36NLXIPoiv1GvUnCWv5fhTXzCKK+zw4aQEoMKe6tM55rTWJMl67/IoGBYFevFmWiwS/ObeAN3MLQYkFvBlq0ujLER3pFW4cT0M1C4uhW2KbszF8Ms5p8h20TKbpM1eKi5flQmfYT1jvLioA12XZ706Je7ijEXHmN+sI0Q5AoHB6BjZF8pymUiQjHJ/jmvT/M2fcpcyz3BZNYUbBTSI4pHr2myQAC4HvREDn0tR2jsFNfrETKOzH7hPI/Ffma4AVfpy/KNNPRk2fZm2PElxhzxNIlXiRLipSvG175nkgg7DJvXvvdboYQ36csNC9gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEa0+8HDR+mEALEyhagIpJt8Bek2jSx+g00j18ibwWM=;
 b=U4rNt/yncE+Ac1OEtF+5EdTUoB5xqo0CWNWHcWsPC26AnLD209w73ZTqGg7mgOXyrZQTjXy+iYICVZPbd/2jJa1knkl5l4hkHmV3Xv5aw7ACWVekpS+VOCOvJcsDMrgBFptNIfBY+9Sx0xL4hmtCrE2cnNl2ONtQV8QjpBLVi1c=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 07:11:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 07:11:56 +0000
Message-ID: <521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com>
Date: Wed, 19 Aug 2026 12:41:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 111/181] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jack Wang <jinpu.wang@cloud.ionos.com>, liam.merwick@oracle.com,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260817132535.394764707@linuxfoundation.org>
 <20260817132539.879554007@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132539.879554007@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::16) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO1PR10MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b6a048-b2e5-42ea-bc30-08defdc12717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|5023799004|10067099003|4143699003|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8k4b5RimgURIGA/eb61dS2pmOtqsGt6s79T1bVKoo55nwwqqOJzNaEExZ+VwcNtWgu1GV009pG6W1k7JymnAcHQx0LvfaVyyQReGk/pIKzYAYQK54sjpPD5gUYLUy5HEBXAm7E5NC97vXtELYVErnFtMI0WuRB8adMF75ZuXfGBkFIiLO8KwVwBzaV/NcSmBvbZVoCWNuBISuhDn9kvx0k9b54fk0/tkoGBjN66UK7G8cE+6o69vG+f6lmxTscsG0iNmr9+NbD8tvOs2CmhYeS6Us4YPwd6v/aBLSYVV8Rmg14GWm9ZcvazpGKmQ4ajq4sb0aSBMCSTMVoYi9kn2It3uSAUeZRRcyHYACZG68TC1u+wpeTWIaZdo5zMTNeDOjgkghBPj3LPMyAafc2uzpl7Ow9UrXNJXu8RDLbF+TO68hND8k780Tx29KLEkAj8Wt300hCXa/xRyCSVgPQBYdWPkY/N7cxuucK+uJpkU0NE6I+i0XVLuIE2VTyFNeJrhD9dO+OYGy5TbumUuSU9meK5vYGx7D1/sJFFOT3sWep54dxf5tajLe3FTUlZGV0SPfuz0j4Pnd9SaSKhmhT9UDuRYLP5C4nAOzFXVG484yHj6HtXlhZbdEfvchHO2kPWQFAyBU04rxQTYtpjjg6GB+QgRUzxScdkaLJaVDavRmuE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(5023799004)(10067099003)(4143699003)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmdBbUlNaGMzQkVtblFxYSs1OXN4NHBKbjZKb1lNaXlxVFRMSVlpTllKNFhX?=
 =?utf-8?B?NUk3OUxsSkRHTmUrNlFQY1JKSy9xaktady90UW5uQmt5S0h1TzRVWWZyUkY5?=
 =?utf-8?B?eVl3Q3hSdEVmZStmSHM0ek5GQnBaKzM0RThDazVhN0VsWjNzL1NYTTR3U21W?=
 =?utf-8?B?QllZL0tTKzQ5dGNOdjZScS9wUjNTM0p2VGJuQStHQ1hIVVg5UVoxMS9OY1Zz?=
 =?utf-8?B?cG84K3E1b0NQVGd2OG9uTTRBTUVyWGcyNVQ2Nm9DZm5rbWkra1lNRUN2ZG9B?=
 =?utf-8?B?TjlGcSt0eXZQekswL3hKK05tUjk1UkJnVDV0aWpIK0Z1V2pOSGQwdktObXBN?=
 =?utf-8?B?TXdySmdTTEo0RkN4bVBrRi9Vck84THFjWXBPRFFLSkRrMnJSYk94MnZ2Y294?=
 =?utf-8?B?R216WHMxODcxa0JnSEZ3Q3RBa1FQUXBRZ1UzVWVSaTkvbkNXZ3M0QmVLalRX?=
 =?utf-8?B?Mm5TYjRVMEJZQS9HekgwbEkyd3FFVG82M2JqRjNqTGZaTWRRck8vZEsrRG1S?=
 =?utf-8?B?YU85aCtpdmZXMGhWTGs4cFI4TE41aTYram9oR1FPeWExWU5qQzN2dStxVVRJ?=
 =?utf-8?B?ZjVmdTRYanlsb3RBWHpvWmxvTWxrYWw1eHBXZktVMjhkQWxXOXdvTFFJeDg3?=
 =?utf-8?B?OVFxamtaRTE3OWNYS0JZOTNSZmEwdWQwck1BbjhoTWVRQlViblJEZ2VLV2ZM?=
 =?utf-8?B?aW40N21TOXBjSTdnV3ZWazFBeGxrU1lrc0IrQklMbVQwQkpseTQ3bnhuVjB2?=
 =?utf-8?B?Vi9sM0JLdzRWaThuUERNYjNOVDJFOWh1dEgzUFFNZ3RWQmJIcGZqeVZYMTN6?=
 =?utf-8?B?cVpNY3NCd29CMFc0U1VqRUUwYTRJc2FJQm9GdHNTRG93OExSTTJWYXRtN29H?=
 =?utf-8?B?OWNwMmlDRjIyS2RzaHV1YW9FU1FNOHFvOTZMUTNESU1SeVlJa2ZTUmxpNFlY?=
 =?utf-8?B?czV6V1JkdTYvY2I5TDYzK2FJKzJISzJyR2dNcmpsVzhpSXdScTNpdWpNMk5x?=
 =?utf-8?B?MHk5RGRTcmNxQTN1WW1DdStHTmtRT0doeEJ3aU5LQUxBK2xsQUhsdHRjN3pN?=
 =?utf-8?B?NDhTcWwrY1JlcmxWY3lHOHczMnIzK3ErcnQ5WmVDblJBdGY3Ynp5ZFhHV3pQ?=
 =?utf-8?B?WEFVVXBid0tnZlQ2MEtJazJYVDJMQStVMXExMnMwL3NGdC9TdGw0dTdGeE10?=
 =?utf-8?B?ejUwWFl6NnpnWXlld1pOY0krRjJPT1ppUXd4WWJtNWRnN3VqaUJQYWYyM2VW?=
 =?utf-8?B?d3BjdVhXNjVxN1V4K0M3cVltKzc3cG9uK0VNYXkrY1BhcVFUcFZxN0FRbTBH?=
 =?utf-8?B?dmRDcUhUWWthNnY5ZElCTWI4em8yaW8rcmdlUEVMbnV3UjRYMmlXeXFwT1Fy?=
 =?utf-8?B?M3h5OUg5Z2ZwQmNqY1BwL09FM0VnenQzT2RoUHQyQWJENElaQ0FWSVJXOVdr?=
 =?utf-8?B?aEE2WVJyMzhsN3NURUNOTkVrbmREbTRqejA3RTU0UU11U3I2QzFLN2NwbGlM?=
 =?utf-8?B?ZUFhcTN4bXdOT045SlpqQ0tSUEQ2Q0JiekVQY0twRktjL08xTHlZTERMekJw?=
 =?utf-8?B?Y0YvbktEWUZzZXFFRndMeWxURFdPVUExQ05NSHdjanZTeVdzcUhJV21UbmJY?=
 =?utf-8?B?VjZTZ1U2enBUWDJ6S2R5MXgyY0NYZDYwNFZNdTFZUy9KRWE1dURNTysrWVRa?=
 =?utf-8?B?QjcydjdvUlVrNWw3ZjdXV1dwZEh5U2ZQa2ZyelBDTXY4YlQ5U1hxaFhhZld4?=
 =?utf-8?B?THROVVFpbGhEdDJKbUdacFJtK2hPWGVmcDdWOHp4N3hObWtnKzZMdHozeVhK?=
 =?utf-8?B?NUpHSFhxTXVSejh4OC9jRUdZcFg4dXRLWXUvelNLWmtLNWI0bGVVNm5hUlhM?=
 =?utf-8?B?b3ZLMDRFWnFDcEh3eW9xOXNXTEVtMWQrSVJJTFJ3Qmkyam03THRpcjU2cmtJ?=
 =?utf-8?B?Yjk2Z2M3SWt5OEtYRUZnMXZaQk9TRjg0TmJ1cmJXWms2OTRvZGgxN2ljSDhX?=
 =?utf-8?B?NWpBNERUNTgzVzF6cXR6Q1hna01odFl1VDk3M2RHcURoWG9QUTRlNzZVWWFB?=
 =?utf-8?B?YmNvTUNlakVLa200ME94WFBQdWIyanRmT29pRzc2NkxGYWdsK2U3eHZSWGRD?=
 =?utf-8?B?RUR3Z0kyNzdXTzBUR05NQ0tuZkVKMlVqZWFscmdTd0dkNTVPMUM4NEszclZB?=
 =?utf-8?B?MnZOUWZKYTNRa05LalpqSDc3K1pULzIrNjVOL1E4WUFSUG1ra0dWWnI1cEtB?=
 =?utf-8?B?TUtUVXpjWGE4MnlRZ0hCS0U2Y09oUFg2SFo0UjFkcWdXQVA2RlVnTVBkS0Fn?=
 =?utf-8?B?aWp0bm9ZYlZWNFd5YjdXOUltL2xMVER4aEpxcktoczZkNDQ4UDdJM1FQRnFj?=
 =?utf-8?Q?UP4TqZ0XK1UtXl4Gp+23C+en6/GdwXwz96vaa?=
X-Exchange-RoutingPolicyChecked:
	OLG70+76TBmsTcJ31KljD4tUCQ5mezsbI1Q+a9KwyZ4Ddn+53Cm0wB8pDDexZicrFMmjpslsvDRWxB8mrnR9k/F1gDFfQXSN3kGbisNBTMJRRialttIh0crhz+SHbgLyTA3YrvN534vdaKBvSKMHKsfhwyXx6PW2qJb5FM2SMCnyO16U7fyPtFs62RhfmqoVY3vF6ABCHdRGheqcralQYXZU8esBFYdhxNRwzqxogfeyW6peafICHUbF8zKv2J37KVvFiVdy9cpGlHBeuQ2k2Ft/LCawh79j5ZZyZLffDWs8bx5IeCUk1OVBrR1ObPnbahsR7FCX1ySfAJ2IxU+OTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hKHyNeqJKKgkfExX88IIQZdNKwgT4vkenk/c/f1X8+PgY7azjmBqLVnKy3XJWRbvdfHfxmXkWjGHNGpVH39PGuhEgthSkPJPEgY56UnRpVo3L7VktbdFz8OV9KOgALSb8JStDAsGZO4Z34kg+hFg/v00CsVU4anH5O6hjCD8Ak8kv/1WwS5y4cnxajeztRfwyyESaFAMdiG7Ncoc72ONgiJPNgPKkfZW63D2xMMIRX/j1uLKAnfYvvVya+0czVoHfgo8bFGWF0CeGUKz/F7R9dSPtzYaIBjp59G2HwtreW5Pqxkmwpy1TKVmaGxchBaPZSmc8G2gievDsceKM2nU2dTqROgGEmwP2ShkSIksTZxOVb85DcBfqdfMN+zPTohjVAKUiQjfMHacaX+9oP6hmrWHa+RHXZPX0OfBpBNeyDhYnPGY6KtTIJVFlqwMKFpgh4rcJEumKAZ9z39WI0BirH4uKtutz8ki/jU+Vre8OL40qAm6pFobnkn0bsyBe0XgRD/sco7FaT4FKAxY52MQrArM5xPMoK5y8U54PBdbuF84dSzvL7SA+q/sWsLw496VQ2PDeYoHX3UoWlkXtmIsZqL5XwJD67j9ZVdT8Mz4wnk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b6a048-b2e5-42ea-bc30-08defdc12717
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 07:11:56.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyk5dskk9lkRwweR6Lskrly8c3ST8ezFPc4cmTfo+1bJyIxy3hZU8bexXcpd5KbtF6EfvNPfQBlTqKmx7zBzd1y42TMBe7u3Xu0xN069vRrfqUCWu2XY3sUjXZEr4unT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608190052
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MiBTYWx0ZWRfX6U8/1YzBFFZa
 bCAW2vKyGHkhnPr6RbP6cch/TP0D1WraXEKKzBHdTMM1bQW2vNHuHEeUYEMkSjBacM5s/uaX8Li
 DTKYeLiMQVqA5Szfd4s/lNw2NuU4OuKBZd97opgfes1hhtK7Fm/t
X-Authority-Analysis: v=2.4 cv=Rrz16imK c=1 sm=1 tr=0 ts=6a85573f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=zd2uoN0lAAAA:8 a=1XWaLZrsAAAA:8 a=FNyBlpCuAAAA:8 a=UgJECxHJAAAA:8
 a=Jtc_h6zNa199gYllpxoA:9 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22
 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-ORIG-GUID: ijQilF_5_xJXus715aFvzeaQNqlOLVCb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MiBTYWx0ZWRfX9ixwB1nIrUdv
 HNEMKPH9IiUCGLAdUheZuq4K7P6gVW9/LWADni2ttkt1TprydUVOtMYPZ5qO848t/bj5pAJYkus
 Omh2sKjVeR+jEQ3ujQ8uDoUdJd5gD6GKxOK3HpXj5Qa5clADMTGQrd7Rt0ewx/yUoebbXYNSYC3
 qpQkEyZgqPNdz4vFdUG89I/rKUQgNpTIYaeD66nBlNoVESEqb4ISGs3iA+0fDjAEKOhIPkZd3lM
 V2YljibbEuOgFoN4/COG2GuGd1+26Q9IOAhEtP5KWgPpGHfWMZTcu8EFCWaAj0CDmT75PVuQDVq
 P5uR3drfLfV1+Fa67jrbXO7Cf01wqnfHIhozROBbiMEmRkMqPCS9fh02nUivr2O5iI9WjD9FSiy
 SmGl0Da5mwrECUmxAjSKaawjeiRLZQqNnBHTnUaFhsFRFEnt/zN5isXfOaOxSZthqqyNRlQbc5z
 bN5XiP6wOx76eUnzfhA==
X-Proofpoint-GUID: ijQilF_5_xJXus715aFvzeaQNqlOLVCb

Hi Jack, Greg, Sasha,


On 17/08/26 7:03 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> commit 6f1d5a3513c2370bbd6115dd430906bc2f4bdc53 upstream.
> 
> Move platform initialization of SEV/SNP from CCP driver probe time to
> KVM module load time so that KVM can do SEV/SNP platform initialization
> explicitly if it actually wants to use SEV/SNP functionality.
> 
> Add support for KVM to explicitly call into the CCP driver at load time
> to initialize SEV/SNP. If required, this behavior can be altered with KVM
> module parameters to not do SEV/SNP platform initialization at module load
> time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
> during KVM module unload time.
> 
> Continue to support SEV deferred initialization as the user may have the
> file containing SEV persistent data for SEV INIT_EX available only later
> after module load/init.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/sev.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6cec696461da2..bd0344bacaf1e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2972,6 +2972,7 @@ void __init sev_set_cpu_caps(void)
>   void __init sev_hardware_setup(void)
>   {
>   	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	struct sev_platform_init_args init_args = {0};
>   	bool sev_snp_supported = false;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
> @@ -3088,6 +3089,15 @@ void __init sev_hardware_setup(void)
>   	sev_supported_vmsa_features = 0;
>   	if (sev_es_debug_swap_enabled)
>   		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (!sev_enabled)
> +		return;
> +
> +	/*
> +	 * Do both SNP and SEV initialization at KVM module load.
> +	 */
> +	init_args.probe = true;
> +	sev_platform_init(&init_args);
>   }
>   

I ran an AI-assisted backport review and checked the finding against
6.12.y. The backport appears to be missing the ordering used upstream
when kvm_amd is built-in.

Upstream ensures that the PSP driver is ready before KVM continues:

	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
		goto out;

It also initializes the SNP RMP table from AMD IOMMU initialization:

	if (snp_rmptable_init())
		goto disable_snp;

6.12.y has no sev_module_init() call and still initializes the RMP table
through a later initcall:

	device_initcall(snp_rmptable_init);

The backport can therefore reach:

	init_args.probe = true;
	sev_platform_init(&init_args);

before the PSP device exists. The call returns -ENODEV and its result is
ignored. KVM can then enable SVM before SNP/RMP setup has completed. 
Since bb1c84647025 removed probe-time platform initialization, this can 
leave encrypted guests unable to start.

The relevant upstream commits are:

435b344a7042 ("crypto: ccp: Add external API interface for PSP module 
initialization")
44e70718df4f ("KVM: SVM: Ensure PSP module is initialized if KVM module 
is built-in")
409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in")


https://lore.kernel.org/stable/cover.1739226950.git.ashish.kalra@amd.com/


Could the KVM maintainers confirm whether 6.12.y needs this full series 
? Probably could be done after this cycle, but still noting it here.

thanks,
Harshit
>   void sev_hardware_unsetup(void)
> @@ -3103,6 +3113,8 @@ void sev_hardware_unsetup(void)
>   
>   	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>   	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> +
> +	sev_platform_shutdown();
>   }
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)

