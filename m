Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD964274FD1
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 09:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752053185; cv=fail; b=cCozXMnyRY+6WZ7Sma5IOzLWyWRYRVulWxtnyuZucFgV3K8K2CXMsLhE3muDjdg04XD7la28GzS3Kk6xagGATBpPfzl5cUMR5Qook2pjuQ7dDEARijwQx4vjiswqbLf/83LfuqCuM08123qM2iCZzeYKGGfg1bTcr7hRM0Pv/Pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752053185; c=relaxed/simple;
	bh=H1JGWqrNn9I5VdU5XWqcK2PNLDxOtJNoLbNXn5qS1jo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uC21J4U7Z3lOnaKt4hh26TsApSK/fiMAVk+mNB0u6R2OuOAD+frUtT6OhofB0AVASQd1ue1Acomyp22vKE3n40qOiXOU3wvWeEact32Vmnn87H+wc91ziETfSpXBrgVQa/u8t5nm86F4qPDS/1rhGFOKuMw0c+kuUsC/sqOP68E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aDoTZEYu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ScyyarxT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aDoTZEYu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ScyyarxT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699LxTw011412;
	Wed, 9 Jul 2025 09:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=COlh4BqBG01IPLsaTCJFKyQ2yt2wLtmj363ET2eKuBU=; b=
	aDoTZEYuSecCkuYYh5mabI+BkpDymZWRwWsg4ZWuCn1U5zPRCGjMe5RKG/wk7shj
	EBMOxdTdWZMJFmRsx/9Eryv932eC1lqirarrCNj3NDPbg8Lsr8mfxinB487oVquC
	RmA8/SQXTuSr4SVHZcMcyJPVQGtbLPw2dWLNGsoW/lwTqmMurmCe7kPzprcJ6rU9
	Mr9z5MEt3WWsu0k+e9FvB732iXEz8dbpjeYiRdnnZVAvZkbdV0v/pc7c9X69p/Mj
	/nDiF1dpLt6Pyp1gEueHM1dT6c/xOoA/iBQGYoKN+Ih/CuRc0Yi0SFiOHm8Dkwbq
	47VmkOfmTndVqQCFqfWrWA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47snqm0077-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 09:26:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5699AMli040544;
	Wed, 9 Jul 2025 09:26:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgayv42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 09:26:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8blkOk6A4r/+8+HjbDVO5nbBbthzaXDBn61XCDtxYtKCU13v+TMd17QDtyz/QAu0W8cm2r0ir50rm2ZkLe6jrc+Vn/Y2385As2XTGEzpoiTQS21QX2hUad/TfSNSQZhX2+NTjm1Qn2CtidrJIAUojNDDchXFUncGa8FlBa7urQJ8arpU09cLNxMrdmFzechIFiMlcxCOGfi6dDHypAb30bp01cP6zUnHZCeb3BG7ufzD2nEm0lzLIpQAnBu6s6mzdkqBfJwSRI30PzO9H6K1qdNCzS8X1x8dtN6T0J/lk0mJn9xvrz09b7UDpQEq+dOSQwdYblmPx7DI/wKZco72g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COlh4BqBG01IPLsaTCJFKyQ2yt2wLtmj363ET2eKuBU=;
 b=v6q9XewDckkhz7XPEwFBy/gMTrc76u+vWJ78XSAO/GLY09um3qI/4OgFlkZI+Di6lia9rg0fJ/h/mD2O/fin6vxxoJFkr6X4mU7BhNBLnb4Cgd3x6x8ekLnxsnEDNnXZEkIeq8kw4WGoAriNN7uB6exXrDtDsiFfqnyBBRZV3mRVPemgilkjHmkWCDyEj7AZlZBGjS97XLr2wtjj5P4qPEGn9OMldaMa6p0viCL5Z7XBXHjhv9gCA3vU1g7V3Tdp/wECRnc1f0ieIhkHVA27xEiYm5pKr8rpWcPfa/gYEabuFDxeSYmaAz8fIkzdmlMZKoFXoI6WcbN3xfT1/+6PxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COlh4BqBG01IPLsaTCJFKyQ2yt2wLtmj363ET2eKuBU=;
 b=ScyyarxTRvgHmX8rW6kg1okowzlNnMVovaJPYNgNoLNm9FGl3VbXILcvJPDPJD3SnvBmoaIELyxxnjqbcLIRs7as45QuhCLfNFbrrkCQwUreG+spBWWoc9uyyeFe4fiU0+BaxAZZtu2KESqxtLTxAMLEHurS5/jByDRJ+EqGDCc=
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17) by SJ0PR10MB5661.namprd10.prod.outlook.com
 (2603:10b6:a03:3da::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 09:26:00 +0000
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428]) by CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428%6]) with mapi id 15.20.8901.021; Wed, 9 Jul 2025
 09:25:59 +0000
Message-ID: <48a1d669-0389-494f-9b6d-2984c929ff94@oracle.com>
Date: Wed, 9 Jul 2025 14:55:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250708183253.753837521@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2af::8) To CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2310:EE_|SJ0PR10MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: ceada300-ffc5-487f-d542-08ddbeca9d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWdEOHZDQjh1MUNCalRmK0h3ZVdZU1cwZENJUlQ4WURrY25tZ1dZUnBrNzFB?=
 =?utf-8?B?WlZNY05HRjFRaFpKREJCckx6MDFWdGlDMVBEVzA4SnBCdldiMVhkT1Y3WTZi?=
 =?utf-8?B?RHVKdjNPYXl0OGhDdzROYUJDYTlSYlZ2QnhqY3JhL0lKd3Z5UTFYalZEQWk0?=
 =?utf-8?B?Q3J0VjJDa0xhYXJNT1RSK1FqNUt2WGVQNUM3WHJmRkZwY2JTdkpRTGw5bFRE?=
 =?utf-8?B?MllvSVdVQkt5b2F3ck9QY3ljMGZYQTQyM0h1c2IrRWFUWk1PVnk1VjBtR0RC?=
 =?utf-8?B?WlVwV0tuVkw3M1pVbGVILzlCOGxMTDBaMG5kN3l3R1M2dVUzSjlranY2ZHF3?=
 =?utf-8?B?OGR1cE9KVXFJU1V0WERveTJFS2JhdEZDVGVXTTF5WHROUVd3eHBmRmprbnRF?=
 =?utf-8?B?d0hWaHdjUjljZk5DbVVic2IzWDArVEtnRVdraFFYSzVsWEcxcVNFaktTM2xl?=
 =?utf-8?B?WUFRY0hHRDNtQTl5RUsyQjNaM1hqYk1qNzZYOCtoRjdVMFNOTUVYZkltdjNS?=
 =?utf-8?B?K24vVEhFMWlqSXl0RVB6VHZHajdKbFl4NlhYUmhRTldBNVpCd254dkF0emly?=
 =?utf-8?B?UWQrK0ZEUG5ZOGdRK1k5akpXSm5md0pWUW50Y2lpdXRyQUtxUFcrSVl1dEhR?=
 =?utf-8?B?N0dIUFJTUnNBQXJ6VnZUclBZZUdFcmNScSt3bmUrb0dRVzg0djZTVHduS1BL?=
 =?utf-8?B?eUlKZjlzODdJN0tCdWtjeFIzTTJMTXp2M3E3TjNrZGRLQ1QzQ2lFMXlvN21i?=
 =?utf-8?B?azNoQkZYZVd2aHp6R0RaSTlUMlViWm5MaC8vQVFiUi9Hamp1RkNEdy9YM2tQ?=
 =?utf-8?B?K0ovMjlBSHdFOEJGeFEzcDk2QTBrTDFNb1JCN2VBbllWSndIcks4dzEyNHhm?=
 =?utf-8?B?dkJIOFVid0VESmJwRVVuZzAyTG16N3R3YThkcklDZlBROHBqT2JnbUYzVnN4?=
 =?utf-8?B?N0FJdy90STc1Vkx5K3JyK3c0R1QxZ1hwRXhGbFNRNmw0dm1zSitTZGRSaU5R?=
 =?utf-8?B?emVkeFFMNzJhb21qNDBnMUlMTmM2RlEzbnJEQ2ZlSEJLNk1xM1kyOHhpbCs1?=
 =?utf-8?B?cGtPTU5ldUxTQ2hLYlRsNFB2UlZ5cExWc0pTYmVFUzExMURLU0QxTXkzbE1L?=
 =?utf-8?B?MWJ2YTQrdnh0aXNyT1ZiVFYvSFU0WHZSUFN5NElKRVFZNFlRdjRPNWZGbm9t?=
 =?utf-8?B?NWRHQTY0NDFXc3FnSUxuNCtzazk5NW1heXFqaDR3L3gxV016RGc2RXdnNTg2?=
 =?utf-8?B?V2ZuRFVXYkxZQXdHdXhTYnEyUWorTkF1c2UwWmpFK3VGT2VVNFl3R1JKS2k0?=
 =?utf-8?B?bTBzYXRHNHcwUHZEOVVJK0NROVJrZFVvMVkrSXpTcEFmVDRTaWlwOGZmekg5?=
 =?utf-8?B?bTA5aTllc2pXZVNUTlovUXNSaFR4UzQzSHVOSnNkU0UrbCtKQ1BmSnM1aWhn?=
 =?utf-8?B?STlFVkdsVWJ2ZFJyQWlPbGZxS0VHQ2VyV1A4UlpMRUVOVEg2UVJsUHFYeURX?=
 =?utf-8?B?Unc2eDU1REdIcmE3U3Q2RzdRSnY5UCt3a2tQL2ZKUkRxT3lZUnJyazB2RW53?=
 =?utf-8?B?QklLdXFZN1M1SGh6UWozMzh3UWc4Zmd0SEdzRW5ZZXQxZGd6SEdpTHV2MkZ6?=
 =?utf-8?B?REhKOVFjMkpHNkxFcmZFTE9OUjlYdmo2dEdyVHJWMU1HbDA0WkE4cEVVRVNj?=
 =?utf-8?B?VjRmZm10c1BERjNZSGxnSm9JTW85a1BJUGJwak5EUUU3S1dvMW1EcW00OEFG?=
 =?utf-8?B?bE1ndkE4SlRvT2RPaytPUklNSnFKeWp3b1dhcTNGS3JOQ284cG1jZ2FiWWY3?=
 =?utf-8?B?aTM2Yk5BR3Axd1RpVkh4VzB4ck1Mc0oxRkRSWFYwN2h3L29LcEFTZ1hPeXNV?=
 =?utf-8?B?ckxnTXBuTHlpcUpLTEJSdmVNUU9rK3ZVakJ2VThJalVnTjlpWENvUVNRNzB1?=
 =?utf-8?Q?ZaqEplUQrEE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2310.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3VmWEQ2a2pCd1JkRjlXYXdzWmNPbEVaR0RsbWtCc3ppOENPRHpCMUdVK1hy?=
 =?utf-8?B?bDZ4ZkxCRVFQZlhUQXJkbWxIYjFIT2g1S2xNWUl0ZlZLR3NPV1p1Wk1MTndL?=
 =?utf-8?B?LzFiZ2toWUs0L1B0WjBzM0lyUTBMeG5iaHNZRk50ZVVQaFE5cmh2Vk4wMXhv?=
 =?utf-8?B?ekcwdWE5bm9aaU5nRmVhTTZvMDlsN2FjYUREaEJMaUMxVHpDUW5oRWxnUXR5?=
 =?utf-8?B?UGN6T0NJMy9HWHJTWGNZRkFNR0F6OFJ6US9ZRzNiMkpDUUt0NTA2ZTNvWVI3?=
 =?utf-8?B?TVltbGJLMWRsUGJEelhEZzhWNFRDaDhwd2tEY3l4YWFOZG9jQ1dnUmpMejBB?=
 =?utf-8?B?blRpSU9pMkNkVDBvVCtycVJESWMxbWtRdS8xR0dEWVJvUEgzc1E5Yk15VzI5?=
 =?utf-8?B?cTZnVmlnNlBmSktFT200Y21TK0ZhZkI2bUtSc0d5ZUV3aHlzcWlUdG5EK0p2?=
 =?utf-8?B?ZDJFc3g1Qkl1Qk1zZGlwa01valFNd2Q4RkRWL1QxdUp5T2lnSEpJcHZiMmNt?=
 =?utf-8?B?UkpWc0JuNFBFTkY1RHgwcHdvNTZ4c1hoRmJwbktYTGFXNEhGL1BvTHZiTWRG?=
 =?utf-8?B?ZUVPUWdTeHEyWEhtVEZNbVJObkY0Uzc4Z2Z0bG9MZUx6TjI5T3BXMGdjNW1l?=
 =?utf-8?B?MStCZzl1VXRyQ2hlak5uRzlKM0dlUFViRjJ6SGpFUTdTNUkvVkVJeFVJSHBO?=
 =?utf-8?B?MnVhcGc5R20ySG9Sc1hseGhFVmhKanVIY1JubWFwMFRpeGQ0QmFSWVJlTm9k?=
 =?utf-8?B?NFJ2aUxNUFYrRjNHOG5sYmVMcTlObHdRSzFMM0NuNE01R2syL0RoclV0UUJP?=
 =?utf-8?B?azZJZklRUHBUc1ZxZ3VQcWRHa3haN2J0aWRnOWpKSHJJemVpNHovQkg1bklZ?=
 =?utf-8?B?d1pOVDJoMXliekxhSVYwSkh0VWdUaWJDTTMrcWxOd3hpYkZaY0ZCdTg4SmxR?=
 =?utf-8?B?cDZvVEhxNHdHZm1JMDRlYXMrNm45OVg3WGJwVmVMbmlQaUdwQjlOa3NaYWNP?=
 =?utf-8?B?cGs3SmpqM1VocVhySW8zVXFPUmxSK1RnaEE3WXVLVHR0MERGaFc2SmFsblFs?=
 =?utf-8?B?Q2VtYnlvMWw4QjZhK1Mrc3o2RStrLzF2d1BoYzk2dy9VcmxSNlUrTk9HTTNo?=
 =?utf-8?B?VGQ5Z1c1aW50TXFPZTZzVlExejd0Mnp4WjIvaThZME9wUC82RmxDSWZoYlZF?=
 =?utf-8?B?R0dMZFBEbGRzajA5ckRTK0ppRjZrR1d6VjgrVnl6MUgrZHl6NkErdnpiOU9x?=
 =?utf-8?B?dHlNWU1rMlFPL1dQdTJqNEhHelpKdFo4aUpLSGp3S2hJbnVqS21CNVU0a01K?=
 =?utf-8?B?RW00SGQwZ3AzVm1tNTcxMno3d2t6dXdVU29kQjhuMGhubkt1UFpYRERxcE5H?=
 =?utf-8?B?N2g2bHZWM2dIOWtRVzZPRWxQSTl5MjJVY2g1UFRKOGZqOGxCRGdOenJ5UjQ4?=
 =?utf-8?B?NEtVRW9TRUlZQk5PRElDeXE1UHR3Nll6cmxNaEN5SDE3OUpqanIyS3BaQXQ5?=
 =?utf-8?B?Qk9jdlVYWGNZSVJRblFmMGtlTFF1RWwreXI5VGhTTjFTUlZZQnkyZnVDZXpm?=
 =?utf-8?B?UFVIeGxsS3VNdWFWVkRsdTFwK1NlL1pZYUhMV3FzTEpjODR2U1F5YU1VRUI1?=
 =?utf-8?B?VnJzS1NDa0pjWXpmSXV6R3lJZFBMQkM5Rmpxbll3MDNDZy9kSHkxTXdYZGRR?=
 =?utf-8?B?TndORkhOMUhaQVlXampZSjdUaFpZcTQvVHRKN091RHlBUGIwaUUwME40YUdO?=
 =?utf-8?B?QTRpTXkyTEFaeUZNK3VLcnk4QVRyam0xTlhLOVpuUXBrQ3kzRGc3akJTUGhp?=
 =?utf-8?B?TktJK2sxWjA3L0N1cjVDQm9YSktJV2s3MmFYcVg4Unh5d0dQM043a000N0V4?=
 =?utf-8?B?Skd1MHBlZ1FnZlQyelkxUXkrTzZrSVlnMGtwQ3JxVk1NLzRYZG5PcUl4REtT?=
 =?utf-8?B?aXNtKy90bGdWb0Exb0V3SnJ0Q0hjV1RPZE5RaWpScDBkdjYrd3BIZFdXY3pN?=
 =?utf-8?B?dHAvZm5DRzVLTHdTeFV0WmFVKzlGMlIzcnQxYVhmcGRyTU4vN1JyWU83Z3dO?=
 =?utf-8?B?Y2YyOHlQQVpvYk9KVGtBVWhuRmxKSllSWkdyR2NKUk8yYkdkTWVmcG5CRzZq?=
 =?utf-8?B?Ly9LckxtYzRMSFJLeHNDWnZmTlB2eXZxRWswemsrMnB5MDlrRVRFTUFFVHJZ?=
 =?utf-8?Q?XUa3ICB36hbQw3WTT5mOHm8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aN8QcjP7Yi54SdWARBzj7qIbs27VnySvY+AqB+kCIUUkjUPQkEfSwTemE6CIi0BXBu6nucfUIFSC2mshN+MApe8IScBlAc+we7AoUjznkMZ1RybR+GFgCAihMcJVD2uJSVpP1n3OJEb2IbkytZbyG7L26LCoNUGQFwcbaxJERaeumYubjsMJSC2Co91N0jvN/JGWz/PqLPiGboe5Iv+7xlVxk+E6hXB061Vb6Wa08B8QljuZ9ySo6NQwd3a2QHS7VWIsPoXplawQ8eLu5lVRobq7oPazC8rQn1z5PL2VFa8Psuw0gmLhAHxlxDQFODk5MdKIIzSNCJ36Dgm1iS9yL/s8apDdCuEfdFeTl5BTelPbizeoq2DlJgVuAHBomVaklEFHzadqFGhIFxNrRQdTEgBWCamcZy/J7Jc4hOM70BM9mXtm2ofFsolhXjt6XnTI6ZLL6pbtI7+X0RGwLRBvIneqr+kBvzRVImgj4IoYalo1Zk4bsAAIvxxqXsdFjYLZSrS9Gx6J7NyT9hczc0zi5tKxQEX9wefh/pUnIOZATaLzoZy8dJIzBMMbtpty1AadjdVP2QLUMyBFFsZ5Qq6ctU2RQm67eWXrRuQnQy7Nga0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceada300-ffc5-487f-d542-08ddbeca9d1a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2310.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 09:25:59.0343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icUPLPN4Cgh4UXlFm7zOY2pJ3G+HpTAPZd02ClZ0F3jPllJ/xm4sZo5OK3m9NUcsDogs0JEyLxdVWpJxyGIm+zYpjhjcn3umi2xQqNlKSOECNkRiUgKDjB9wbSz6OKe3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090084
X-Proofpoint-ORIG-GUID: QDq_Cx9zL4A_RcjIT01HIfpyEp3eSoVp
X-Proofpoint-GUID: QDq_Cx9zL4A_RcjIT01HIfpyEp3eSoVp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA4NCBTYWx0ZWRfXywLgKA+6hP1w AdpAg8Rt5PFhDsObdisuOaBYPPrVRbTH4pi41kkztUtKnTk3k+hymcR+oynV+5XRlvwtdmzRlts QibHa6cKOWZxbwmdSQTQWhnc5/QyzK312nIJy4Xkzw9R7m7ucZqoNB8nmwPH1vy/J2ko6O+iZTH
 WtHLIgeRs81F+zNo2eI+JvLD6hTa7TNN1uq1bHZcnybULhdZOX0XqZSWk8jiiy0+VUHTNnlR0Br N6hldwBuRQDCS39mb0ToFLnIhQgfd0uDJeFeY7u3wW7QvPln5J1CDpfPJ9eUb1gW81ILUDoGs5X V0n7JwNiN588Rmtlmw/84vu8VjJ3Xo966g9zqr+NcmCTCF1ympthTtfmIFdvgyuZ0ptAHmw9Gr3
 v1a/gz9QJ9NW4XsD2SQ7B2MwTGqtXOzODCe0AF7aigwLOiztBw/2Et79GEMbGEIxWf89TH4k
X-Authority-Analysis: v=2.4 cv=OYOYDgTY c=1 sm=1 tr=0 ts=686e35ad cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=uO3dX0lWwlVaJZn2298A:9 a=QEXdDO2ut3YA:10

Hi Greg,

On 09/07/25 00:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
