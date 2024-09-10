Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0934190698
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 18:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993919; cv=fail; b=WoaLmQVQD8oe0fHmb4qPOZaj+TzX4ceTlYNYkCM1k0g+br91mhavkHaO5/ID3piKWKjC1sPl0KsBYjp7BX/sl8mszrTSrbwMuka30ko86uqn0JEmnR98yqhFYtB1fYRZHlzx3u1cY51Gx+BBaxOLcUcuSwjG5RjOuRtL6rURWZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993919; c=relaxed/simple;
	bh=ZICR/w2GEBGooO6oCiSid1vmyWfYuA0nOP+dCPbKK5A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eC+byPVEDxN4itToamcuDS7zDG1NPGoxUZoNdWhNCQyaARzLRwBhXe5Vfz4NRPmX03r9xWJc2EPEJ8XgCRcEPO9G2AfFfDbvpbOVKAFI6gp1Bg/2tCFrshYU4vrfmngu1o0P7X+EnLmfTVVha2/jc/L6DbH4THIPvFMmX9FcTrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Izlv1LaL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mh1jpdU+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Izlv1LaL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mh1jpdU+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHNYDU007443;
	Tue, 10 Sep 2024 18:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=2BiGluxv2pJDyyQKPNsjaIe4pHQbW5HNy7d0WPE0eao=; b=
	Izlv1LaLFkGYkFrTjz+xVwLy/q7AJpcZYspwsWGBLAzoHTMSk8QEZS44OTq8LB+C
	9DG59j/GLM6woV9g3YjbwHQ73lSo8y+ox60DKo+fCCCq/mPpxXk6sXVKzidLvuYs
	ZuMa9K6dkcqKAHMLUmJJ/hf5i6WP9Kc6OzyNOT6sFV2yDrA+GJkGeJsiv1nbCiYz
	bjRPa9JtPA4WDTMPrxP6EuvjiK2ChSvGPTKrIB3qMRczgE+X0dcRbM5LkxfiDOdn
	EFQQFjYadrufcJ8r9b9z+gQ7pBZxIcZYSBZ3MEDL+oL4ye69jmJLRBcbWSJMCL5t
	9wxNmB4/FlTxER2JG/mzGw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8cxag5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:45:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHaxAT031622;
	Tue, 10 Sep 2024 18:45:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd99fxke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:45:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQERTQD6Vau0D51nyEf3Zg90smXSrUI6f+8pHljUhfdgPBGlK/s3hiUVy+uS8NFtnEZHlvWKGoVOGctUS4DSiCtjG7pBve4LTe3c1syPIkYprew+Th2PncN33I/5DZuRppHR8wY48xN4GqOMweGKggaiLhMSvDaeluk51k/ly44S2fs3FjVhXlMfVowMrrQ7OhUa3QfIwRGAzDfUJq0qvbwZ7eHK3AQVT/L2g95SX5KjxlUgGwlHBwer+muKEpCm1XBZoo+TcZkbaQujcfKWRmNshYC4rZKPO6dbYjTIpX7fz9NXFzC+XvCHmhd5kMT+LY7rykr+x/6J+cGn4JS8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BiGluxv2pJDyyQKPNsjaIe4pHQbW5HNy7d0WPE0eao=;
 b=bbirWmkReM7TA02c2E1a4j9vZKXXjg3poddPgkqKD9jn69jdU9jS5AeAs9Gz8Mkp/snEKyGdHiFcMEZAK/ZQa660rBFOiGKZP/09jKI98f1UWgp4lV2PLmnPKKuwPUKcl8iAXrqr0FYk/KioLT6cM/gG/ZFCRUmNH18HTnpVu8I4RTDbytiwFBcxGohs+0DhQN+ciMrxH4KEtCv2nsjOKfcc2OQrKh7wn3slySbZSmP93AkpzXgw5hbprAiiVYdZexIWyo+W+IjJFVQyc1pvQ/pmpTaCbA4cwkUSfltJxhQ31ZvTqjRKQeI2+SOx8ZxsCv5Yy3jfKmnFdT1cJg8FfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BiGluxv2pJDyyQKPNsjaIe4pHQbW5HNy7d0WPE0eao=;
 b=mh1jpdU+7EeIUhVoul0HWa9H3NxuX7QhddBawylwxvffbi42ouov/J404fss1fy+px0mHHsvKQGpqW6DgxqC2HmZNl+9syHrHrP1wqsE67ka3xIkY9e+3maoKvYRwG/N0e05andDBFSyMuT4nu3FlI5gbwsJgrU6o3C/nWOQVWo=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB6172.namprd10.prod.outlook.com (2603:10b6:208:3a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Tue, 10 Sep
 2024 18:45:02 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 18:45:02 +0000
Message-ID: <0ba9f298-6ae8-46d1-810c-5f07261e7113@oracle.com>
Date: Wed, 11 Sep 2024 00:14:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/95] 4.19.322-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240910094253.246228054@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240910094253.246228054@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: 15fe78c5-e85a-4140-262c-08dcd1c8adfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUlFVDRocVkxaTZEcXl0TVZEQTBSNm94MEZFZGJXczJkQm5GVHd6THBlS2tR?=
 =?utf-8?B?WnJ1SlpJK0x6d29WeG5yOXljK2h1NXUrdmdIS0dmc01JTDA0UEhKSFo1TllT?=
 =?utf-8?B?QVdoRjVvT3BaRXpVaGhQSlhpeXArT1cwWWY2UzFLTEN0R0ZzNnB0T0hnYS9k?=
 =?utf-8?B?WTBCVjM1Sm5aK0cvNE9MNmgzRW5RTTNyS08ram1SRGZXWDFqdDExTnA0Q0du?=
 =?utf-8?B?czRXemNxWkpubW9GU3ZZTEJUQWVUa2I2Q1Z5aHNIZWdGN29wU1dkZkc3dlNm?=
 =?utf-8?B?ZXJEczFVWGFKdmUrM3RLeHR0dGp3U1BwRXJJR1UzVVJTVU9SK1JoK0FleXpB?=
 =?utf-8?B?M2Y2WGsxSzh2YSs3M3JsUWFvakZxVFl0SEdzWG9NUUJsTXozaVZ2eDRLYnZq?=
 =?utf-8?B?TlRiN3Rlb0o5OHZGYVBZNzFpbVliUEl3cHUzdVMwZ1Y0TFVkVXM0bkZmQmMz?=
 =?utf-8?B?TTYrZGt1cmlzQ0UrbGR0dVJHQnpkNzlmKytQVGxTR2kvTklBN0wyRHhDcXZQ?=
 =?utf-8?B?Z3dBbFdReDVFWVFGZVNmSi9vNHNlTUtKbmlxN2ZnNThXZXo3bGt4NFp1eTNB?=
 =?utf-8?B?Nk8zSXhxazhIWlY5VitSNkR2V2pkSys1blM4ZktsU2lGNnRHK3FRbXlWWnd2?=
 =?utf-8?B?VXNZc2NJTHFVN283M0pJcTB0bGJpTGZ2eTdxblRUdnZPbGVjcEJ0QXpVSnBi?=
 =?utf-8?B?bWVNWk1EMjhIakJvbzFaRkF2L2RWSFRDanVwdVNYVC9Lb1Z0QzVTbXFqUFFi?=
 =?utf-8?B?TkYwUHp4TGl3Y3ovSm9lR25pcEU1dDZObVNDWFJJT0UydEtBOVg1Vzl5c0c2?=
 =?utf-8?B?L25HdmJnYlpyY1U4SVFCdWF2MlZVY2tsT3k0YmxMR0VVam83eHJ1SWZlNGhv?=
 =?utf-8?B?ejdnNnJhQnBjQ29ud0MyV2NtWnp5aXEyRjZ0cmROM3lDWGVPdGl6NSt0MmFq?=
 =?utf-8?B?UXBrci9WQndJSEpNbHlKa0J2SW5LV0FwdThrcFFGRmpuaTIzajNiNXZEKzF1?=
 =?utf-8?B?ZDl3QXJXUkpOK3puSFFoa29xWXhaSitLeitFaTZSUTkrTlRUMGd3cWFBVnlh?=
 =?utf-8?B?TjNaQzF4Ri9WZGI3SjhNd2VKOCtwVEN0aktNQ1k1TkM1dGRBNDZ0NEZ2M08y?=
 =?utf-8?B?KzRiQzZxNHZqWStlcnJ5cHYzWnlmRDBCQlZMeFAxK1dRNHpwa2crNUMrc3BX?=
 =?utf-8?B?WEFvb2xMZ0RvSGExeWdSanZqckVud1FNSEdqcXNqRDRvQnhmSXdpN01HTWpY?=
 =?utf-8?B?TWM3RVhqMktFaVpJV3RIVnY3SUNDQTJ4RWZETlp0dXFNL0JnUVI5dDZibmNa?=
 =?utf-8?B?MC9pZnA2VEFCeThaejR6NjEvb3I1VXNxWEFNbDQwVUNXTG5jeVVKL01vWEhX?=
 =?utf-8?B?MUNoTVMvYzNlL25CYWlXMFZUZ3NmVkxUQTJrdGVOYVF2QmpwYmlWZWNyOW04?=
 =?utf-8?B?NGVLRmRZUU1HaVptQ2lKQ1FHVFo5ajNSZkg2Z0pjMTdyVFJVS1J5UEVyM3J0?=
 =?utf-8?B?djlqcllhNEZGUkRSaHcwakMzMkdVQ3RpdEg2REZNK1NCVDlMSXJLQ3BsVkhQ?=
 =?utf-8?B?azM2QXlSNG5Ya2Fwc0s5aDhQVThOVGJIZHltckFvZFVNdDFZamc1eEJ3T2JN?=
 =?utf-8?B?c0pSVkcxYS9WSE1Tc2ZoUVY3b2FCZDFUVUMxbERPUlZvb1RPMEl1NEMwcm5o?=
 =?utf-8?B?eWNpMGRwNkdmaTlnUFl3aWsraEI1bzNJSEpIUFhNSVl1bDFyeCs0YytRcENn?=
 =?utf-8?B?TlVaajIrVGQ3REhlMC9jY2dXeFRwZ0loWGZhWVFEYXlmU091emxROHU2ejZR?=
 =?utf-8?B?WU5ZNkJRUng5d3hneHRldz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFlzelhVN21GTmdJdjROMCt6ZEtPN1BianVCSmNoYklISWVGdDdIYTdmNnpS?=
 =?utf-8?B?M2JzMEFIUEV4VFdVKy9YSjQ5aXdhanMxQVRPMFpZU3FxdTRXKzFHeHk4ME9j?=
 =?utf-8?B?YVg5T21QMFQ5MGUzSnJuNzBpOTFjdWJSeVowZWlhRHRIU25lcUFVUXFndzQ1?=
 =?utf-8?B?VElHZi9QdWRZcUpON0R1b2t6cEhZZDR4ZjVPeThOS1d6Q0RDaFdqM1c1ekhv?=
 =?utf-8?B?MVVONkFJMDNsa0hTMVZzZkFzTEx3QUdSdXpYaHl3VU13UFVyNy90MFFNTC9t?=
 =?utf-8?B?Nld4N3paZjVQRFVFY2s4TUdZeHcwUXcrNm5GKy83MEZNdzU4cUJCa1NteXBM?=
 =?utf-8?B?czlmdGhSUU4wMHp6dkk4Y09GWjZJQ3U4OWtkVlErMXBlNGx0VnU3Rnl3M2t0?=
 =?utf-8?B?cU12aURsWWMzWmcxRkZuUFltWjFaU0VWdG96WVhiVWV6TGVvTEJJRitmNU1p?=
 =?utf-8?B?UStlbmtEVnNVL1I4VmhKUWpoMWVnNmdCdVpEV3NmRlhQWHRsakc5OGVSV3Ey?=
 =?utf-8?B?Ky84ejhUdC9ERDk2dVdpdmRZRXBZd1JMTjlCTHU4QndNQVRhQWRIS3FSMW92?=
 =?utf-8?B?SXZIRy95d1ZnWXRXWXdLZXBGd0YxRlJISjF0Lzgwanp6RTRiQXVtbnlXZGNW?=
 =?utf-8?B?cVhxSTJ3dXpmQkl1Y0VBcFlUTmpudFh5WjhvZU50eThTTy9IcTZDbklBWjVi?=
 =?utf-8?B?VFdXUGdWeXlEQlViMi9MQ3cyQTRVZ1R6Qjg5SzVRbFFZQXY5aEcwUGhBZnZT?=
 =?utf-8?B?TUtsZnNiR3d6b3FZUWIvVHZBUmFvN041VFcxOHcyNVV4M2RCSnVPRVhBQzZy?=
 =?utf-8?B?SU1uaHhmUGV4OWw1MTR1TE5TRkVZbmJYNWM1Q0RNQkFzdzJndUUzbzRsQkFD?=
 =?utf-8?B?VFhzSWswb0V0QStLQ1FwRUEvWDZMUmVCQVp0QTAzSEhEdmd5M3ZDeFNSOVdT?=
 =?utf-8?B?UlNJejYvdHRzaGgvWUpwSjB4VkU2WUFjdldXN2VlT1FvS1I5VVN0b2V1RG5z?=
 =?utf-8?B?N2QrejhlS3NTTXVIVzhZQW0wK2ZKZVAvY2dDOXVpRVVITDBodTQ1YmwydkJS?=
 =?utf-8?B?S3NpT295ZHFNVXBxY3NrOXVDTTB1cDkwbWhrd1M5TkVHamFqQVNDM1BMUEtL?=
 =?utf-8?B?U1kraTgvT2s1R2pWOEZ2V2dkUXZhcjZrenhGK2IrT1h3R2phZEJqalZTMENR?=
 =?utf-8?B?Q3VLRGoxeS9RU09hclBjaTc3cFNaRXFMeVJmVENXSm1aeWJDZWsrTG1zV3hX?=
 =?utf-8?B?bUdReTlPdi9WZkdIMjVFWjJKMDBVbWZaWURZVXJ5Vmp3aVk4bG1WNFJVa29D?=
 =?utf-8?B?SHJLTjkwblZHb0JhbEh6MldIeW51QzFhcjdOTVVMVmdPa0NMcmdjdGJHQWk0?=
 =?utf-8?B?T1E1R3JIaWZUQkw0OFlCUFNvMEFiVno4Rm1kSGhhcVZBUTh2QnMyblNTZTNr?=
 =?utf-8?B?Zy9lb2oxNk1kVElidVNNK3Nwc1JZQVBwL3RaWHNEaGdYOEp0M0ZCOThENW0w?=
 =?utf-8?B?WWlKNStVS1NBUlJaRTJOZHBPWUNKemVSakVjU3hXZ2VNeWhmSysyaEQ0NHJT?=
 =?utf-8?B?RjlqWFNpdlhWRVUvbnZnMnhUQmZic1VGVlRONWRtekV0eGtZOGNtMTV4RUY1?=
 =?utf-8?B?eDZBTXdoc3N1aHFsM0ttR1NRL1pmMzlmbzdHSzZIcDA4RG5YajJnTXhMQ3JC?=
 =?utf-8?B?WlpNUHlsN0U3WlUxSm9RMGR2dDYrdWVGY0VyazlEVk1oMEx4VUhqdmJUUUs2?=
 =?utf-8?B?cjVMby9uVy9UU0tkTEhkcm4ycE01L09WTmFVRDJaOGNmV2VVeG1ZVTZtYmM1?=
 =?utf-8?B?Q3MxajhZb2pvNzJLbWNvTGx4OWtDV2xVUXNGdC9UNW56U3ZiN1ZWYkpTaDNE?=
 =?utf-8?B?YVFleGpiSFM5QURQcHhRM0dFYmhHcmt6Y3dlVno0RmRhTU9aUHMwbzRsYXox?=
 =?utf-8?B?NU5mUW5FVEttbVNJbXVHTVUzQlJTWFQ1TTNTdzRnaFJiNVdKd1ZjSHZwNktr?=
 =?utf-8?B?Tm8yS1pnb01DV3R5N1hhUTlxZkdjSEVZLytSWVhzMk1pRU12dGN5MEhYWEd3?=
 =?utf-8?B?bEhBWkNHWHNBQk9vbkZET3JGTFNEVWs4Q3ExbDRmb2I0dC9FRkdmc2pYZWxR?=
 =?utf-8?B?ZFhvS3dHcDdCYUtTU3FhU25VZGJtTndRSXNBNEoreFpEQnNIOFVHS05PRmFO?=
 =?utf-8?Q?ee0C05Njxqr/Gy/KJ7LOPrQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d/eHWWcA+RcOMNJrmFz7nKaHOemrFXE7VYoWCuGRpxRRQihkYRVdl5/5iPg0FwTeEWblxs7CrVOl6Lg69uJJuXOHH+JlsUnklZ6o+5gdyUsUhpb5Fp9coCtH13IzGHGg60lKDR1k0cJaYUi7AxaF4s5QcgeTs0QyYk1ycP40FClc5f3uipWw9FWIMW2UtGSqAO3NlRpVu9gamU9UcS7C1jnqOwSbeL8gN6ty9JY4mH26xacyhFo+EZ41MjnFZd6nDapY/c0OoUwkFweRXY9YBXTrD/0d18N6b5mR2sBPAXfhoB92WWFJB0toLUjgzO0S/8oXiRLIWgetPfawJVismaJlD3ir1t/aZFXivsvIi6rUgWLcuvhAaSdxryx35XcTPjqgCjXmBi3yJTCt4VIMR19nTDJbcdL40pWvnHpz2NSo22O89iwPp75FJGwexgggi39uMhX3k37Qb70XO08wDUxDvpb1QEroUhBogl/C7EJuDEVnRRkFT3GK8eFZv2NiMPTYYgCAQ1frO+4ToiiLrZ4Si/ad/oOFuKBHN3PVR0f37yDKJdac5Vi0JvA26rHl36opEpFjacBvZPGWwnCZf2ySzcxSiyf1pfIB9CZIOi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fe78c5-e85a-4140-262c-08dcd1c8adfa
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 18:45:02.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mod8uqe99uSVFsMCbMVjIEUUGwLWW045p/bxRA4VeWUuqoQBFe9pTDuDAGkBVOssZ3tbkAbILEHM30uEVh6lnso0bBO3zRTgkTh16GcfSdA+eBzXirGSilsXQ58XNROo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_06,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409100139
X-Proofpoint-ORIG-GUID: 4f5imj78rwvlhkJO8YWQuJoYdKrHYDZe
X-Proofpoint-GUID: 4f5imj78rwvlhkJO8YWQuJoYdKrHYDZe

On 10/09/24 15:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.322 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:42:36 +0000.
> Anything received after that time might be too late.

Hi Greg,

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

