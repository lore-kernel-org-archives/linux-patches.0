Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE32EBB89
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 05:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757395592; cv=fail; b=St/jpNUs/9V2naVFSkhKTbrBWCoSlGgtmIGCDiBj8yXLmk/iKbWMl6VWtfbcDsE/e0OLuGD0OoYx+ctG17zXLTqNbZX1Zipp1PCZ2aybhXZWPiGS2wnyod4ikNp0u+uVq5krY0HPjTtYXnq81EEgVs6IiOzhu/6NSRpeT6x88A0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757395592; c=relaxed/simple;
	bh=0kBLaQ0f9Cz2lWGKs7XMIT141HLqu/1nJNFPy9Z30Q8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AzOJ3oamHXLqcMpVME/fED3lRSt1+Yw5RItbg7kJ0b8H2htgm+z9pwU8dvCAI+R7FNxvsHJaRIcYj7uFgOkeG1cLY+XwvwG7eaSzRuDDyriFRWn7N3ILkbN+Z6crHwRJyH+R9Ww52rHoDuGNKPs9kZjZxXWZZhkb+6BJuRMXgec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n0ulOBgR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WTwTHJku; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n0ulOBgR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WTwTHJku"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LCRlx011154;
	Tue, 9 Sep 2025 05:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zrLjfC+ljy7/vvCodXdvBlmMSitRa4MjjUT5qzXRd7A=; b=
	n0ulOBgRTGVT61GMsMnsowcY6EmG69C8ojQ06m5Cr2FCTJqq0//1JMEgfspfb91G
	k3CiknCbijKf/1rIvRpzqJmwUdHPDmvs1DPR+Gz/g5bnOZkYOiEnf4o6jvuWr/WU
	x0mdnng8I8CtxljlPTEn5Kz9coKZQpBJeS1qTmu0x0fbgQPKRN5SfdralCsEh8sR
	6TiX3VRswvf09qL7Zz5kBHv1Fp/tfyqwIu4B4MirCj5USxBhOZdB/ObrGtmbUm8B
	tJc167cSR7CoTpYugqRkV36CqI7EBuxOK5v7AYsHw9vsyNmKyHwp0VIxhYGgH7Y7
	mVn6sW6ci3PhW0SRgsFlog==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49229611pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 05:26:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58957KJ2026002;
	Tue, 9 Sep 2025 05:26:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9440y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 05:26:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TqWx2PcemlJ0pvEuFLl6NQXtpf5ZpKEvVO63fo+fphQt2foa5ec1hsRGW6+T+UKNkMXA1Z4MGx0uGhhXaL7UcIZve3qNxiVOvRiuDcz0SaheZd+5SQPO420Zboh6a6NcEvepEPMIe/8WwCLUiWsaVbl4rDHKJFn3cxol+j6FKgvgTw6Ahz43mwLI8keTTocdDSy067YJ5aXjuzUy4LnlrtCrk9KQjpDEXIT1jD00a6HfFjTbaDDFYvJwVDVIIgO6CCnU0zkKZIMo0WUGp3Xf/00uyn567j3o6YpkH8bXsmb1Af0msU3xJ70F/Pkgr1nP+eXYeDBbJ4hueMDzym8YTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrLjfC+ljy7/vvCodXdvBlmMSitRa4MjjUT5qzXRd7A=;
 b=TVQmAExC7cJL5UqovZlFoIo9wXTjO+orKZdMRW3mmfIFTICGBVj0Xdl5kaH3lW5z/6ngNHFk0AhGbZUwzBLLj85K6cJCM40N/Zm/Dceif8Ho9f9R4lvNh2nmwuiDQaCVtXQLCeLVmcczet8d8ItoDSOQ812fGb9xzwOwUcVWk7g0PblHH0CjBFQI15rHRuQLlx0haWcltzXv6bGv1XLpgUAKglDPt9eVl/vNCeMWN/HBmon6o2+cK9G6IBUmXYPZRJrddheJeA78riq5amyHsBn90c2+f/jtonRjz/UrPONuLMLy4dChpKVJuriKsWQoEsBWJmtGOiDiteDc9lEtEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrLjfC+ljy7/vvCodXdvBlmMSitRa4MjjUT5qzXRd7A=;
 b=WTwTHJkuJpH2hFN1vqWEY/dJxwd0L27sXRsPdpHgdfFUCIzCWcCOm9Ym5pcCZNep+a9ip0yI5QhBfnnJu25F5KEX3caBm+TPuVvXpuXmETcr8MiWSX8hT0xcsilP7uX7P0SYR24FiAT4rNadMy5XLmfmbiTNPwXGnPOttSLLv1U=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by MW4PR10MB6464.namprd10.prod.outlook.com (2603:10b6:303:222::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Tue, 9 Sep
 2025 05:25:58 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9094.018; Tue, 9 Sep 2025
 05:25:58 +0000
Message-ID: <7d7f0d58-c563-4464-aff3-05584b98ab1e@oracle.com>
Date: Tue, 9 Sep 2025 10:55:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250907195614.892725141@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0372.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::24) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|MW4PR10MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b983d54-2f33-419b-427a-08ddef615b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWtlYmhnakk5dzlkbHR6T0ZQMlRQbm9HNkpmeUF2MU9PdldlT3JKOVVxNUhx?=
 =?utf-8?B?c0FXaVlLcGYwUEpwRmlZWUM0R2ZqRXFkVlFsR3AxRDFHMGNIL0xkSDBhQno3?=
 =?utf-8?B?d2I4dDFqMmRKbE1xeEFDbW5vS1VFbEx4c1c2dm14a0ZiWk1OYmIwTE44T3dB?=
 =?utf-8?B?N2RFajVOQlN4NmVXYmc1R1JudlNWTFI4TlBPTk5Uck9WVGVTYThYV0krQWI1?=
 =?utf-8?B?OC9neURJTmt0RDZ3MkI0TmR5d3ZDM20va2RmWjlsLzhnV3lOQVp2YzBzUmFT?=
 =?utf-8?B?My9QKy9nTkQ3L2REdkdrTjZxcXJRaHduREFiZ2tyZTNmZWJEYXVTdExrc24y?=
 =?utf-8?B?aC9Ya25TKzV4LzVBMERqbVlwNDQzTHhwR0UyUEFYZm81dlNEY0RxczdOTzh2?=
 =?utf-8?B?YnlYaWZBVUJPdHlkb3pGTjZZcE9lbWJCb1J5STdmS0xmbmVIUC84dThsOUNk?=
 =?utf-8?B?cVpaOXo5VkppNUdZWDU2dTJVZ0ZTb1V3dDR4NDk1NlorRDFiVjBvampOTG5n?=
 =?utf-8?B?cm1BdFhZbWZveWEwcUc0a2NDME4xb296cENTcmluVDRDbng2RUJaQ0lZVW5C?=
 =?utf-8?B?NFQveCtjVzNMWDZyMGJqeTBSUWtWcTNaK0NhcDcrWUNMUjRRazZsZThEZ2cr?=
 =?utf-8?B?UFpqZHJkY1d1LzV6ZXA5bXVCNkdneGN4bm1jSTIwUjdsZ0Y5ZDZoU2dCVHFV?=
 =?utf-8?B?Zm1mUkRPTDk2NnhMUVBDSm5DaUljOHF3bDBBclozM1hYR0RiSVd3Wm9ZcTIr?=
 =?utf-8?B?UVpGUjVXWEpDR2lkZE5zZjVqbXBTMzlnUjBSNzVHNGI3ZHdTSTNnZVpRTUt4?=
 =?utf-8?B?MGVsbGVHZWxheFNya2xRaXJ0NmNwT3NqWkU3SFh0Sk9zbFVidVpNUWNOUUI3?=
 =?utf-8?B?bXFZZ0ZqOEVEUkZ6dFNqdk5vVkl2blNFT00zaGpmNGRaQ2VxcEVyNnJDNW1S?=
 =?utf-8?B?RkhtMVNtdWNzNEJNTXZ5RXc4UWNEY1V1OHZ5c0M4em5xTVgwL0NSL1lpbTJU?=
 =?utf-8?B?Yk5BaDYzeWdJZEJBMjZMSzN4THE0aStKaXNTK3lPRk83UFQrUXVnUWJsUjVw?=
 =?utf-8?B?RUR0SEM1K0RQcUhEWUVCMDVqUENiM0M5Nm52RGJYWngzTVJESlVDSWJyTzJD?=
 =?utf-8?B?NlNiaXZ2VUhXMEg1SnVOM0J2Y0dZT25JOEE3bFF1SlNBdVUyRGlMMWc5UktW?=
 =?utf-8?B?ZUFkWTliQ0NqRU0vWmZlRHJNbDcxWHhDZ1pGQ3piTGJaeDh1bXdmRHIyeHhF?=
 =?utf-8?B?MkJwQ0loUHlIVklCSXpvbmpEVk1rd01Qam5QVUFwOEFOL2t1R2F4aENsWTA3?=
 =?utf-8?B?Z0ZtK1N6UFpUNWw0RnYvUGpqQ0FpMEJISGRLREI2NVpZV1FkNjFUOVFSMnFO?=
 =?utf-8?B?cTM0RUZ3MXFGN0FWVmN0NjUwTythYnNXN3UraTFINldCU3E0OHRyTUU0bnpr?=
 =?utf-8?B?bmQ0Y2VRalNTUnRwaXVGS3A1NnVrS2xwNnREa1BaUHpHWGFDTlNZd3pVSVNT?=
 =?utf-8?B?SFhiR2VkQ1FRU1YyR3RDM21xRGZzaC9TelBvZmtRZE9ndExoMkcraTJHdlEx?=
 =?utf-8?B?UExJVjlVVUxxdno3VDY0T2NkMlc4Y3dtUVA3Smp2M2hPSzRoNjFOV0tseFJi?=
 =?utf-8?B?WDBLWWJ2OHpUTFo5eTQvLzd5aGM1TDZGek15VmtZNnhhcERVVjJiVTN2QTM4?=
 =?utf-8?B?TDhwU3E0Wk43dDZjaWU5V3J3RHlWTFJwWkxrUnVBUm5kdG96eVhXekllcHV2?=
 =?utf-8?B?d1FEdnYvQlJ5dGNZd2tqeFdoZUxsWnFWbnp1cEk1S2pZVTFpTUJTVGtEdGVR?=
 =?utf-8?B?bFBPMFFBVCtNSFdKc1A5N09NZnNVVlMrWmlINnNVcGsvY1F6eXJwanp2MWcw?=
 =?utf-8?B?R0tFNEZUNkd0NG9jdEVJTk1va0ZHWHpQQmNxNmJ6VE1yRGtIMG1lQVRGcmR2?=
 =?utf-8?Q?X4X/XxJ4pVM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHBDbGwzU080TlpEOWlWbDZLdWFsbTFZc1VhdDJnbnV4VXFKT1ZUT1piaDBX?=
 =?utf-8?B?WnUvTWJrMTR6OG51Y1M3T0VwaVdveXlVVTBTQnE3K2lpaXBaL0JreW01dU53?=
 =?utf-8?B?cmtLeDk3R2R4MFB2ZE0rUE1tNFhDZTZKYzZGaFVDa2RoYXRmUWg5OFRINHFu?=
 =?utf-8?B?OFBFakhTOWlrVEMvdldEczFHdUlZRjdzY3JSZ0NLWUl5T09EK3ZZOFovTXRH?=
 =?utf-8?B?di81bEcxNDBtSGxIY0RhaGUyL2JaWFhvSUdFRHJQWVcvS0VmcVdURk9YMmJV?=
 =?utf-8?B?YVN4T2Z3S1M5NWsxb2VoZ3BLTERBWC93V1JtVTJBSjRYZU1NVzlhWWhZYlBp?=
 =?utf-8?B?T3ZkRzh1QmtabG9PTkdzWjkvMmdrVEFWc3ExcTRGQk5tcG0waVNVTUV6a1pI?=
 =?utf-8?B?SWh5bkZqTDZtTFoyRGNDUS9kMHhGL0ZHclJkMm5rT3RqSzVKYUl0QTRmeThT?=
 =?utf-8?B?VUFWMlRGdTlmUjFFR0VjcVFpbnhYTUljNEFJcmQ5QlFNNmM3ZFpSVzFGRVdJ?=
 =?utf-8?B?d3I0dHNSMTVoUU9RcmJyUkhFUjJkTk1qUCtpMW80bDBRWDBPb1p6WTlGZUZ0?=
 =?utf-8?B?amNpY3cvWldBb3dJQU1oRk5TRFlzcHlxWVFZV29kdFNFSVR3eVpZQnJZR08v?=
 =?utf-8?B?MXRqdlllamNrSk9JNWpmV1RxY21QelRGRk1IVDU4bW02c0d1K2F0Z0F5WVRv?=
 =?utf-8?B?bG9qZjhJaXo5UjY5T3BocGVTSHNhTEwvL20vMFVVVTNuUGl4cklZY1dmOG0x?=
 =?utf-8?B?TWtnd3NpVXRjQmo2eHpUMEdWZHFzRWZYQWprL0dGaVJpSitPeTNQTHZPekdv?=
 =?utf-8?B?SHBxaWNBd3BzOU80cFJmbWJkRUZDWElIWERNNEErZTU0dmVYZG4weldWK3hB?=
 =?utf-8?B?TEw2ckNXZkpKUXdrM1d4OU1HSE5oc3FPMjI3LzJmaUNmbmJoYWx0dTgrdmRU?=
 =?utf-8?B?R1NBd2dGTDJWM1puQkVvcytSZjVyNDV2RGVwcm5LZ3pHQ2FZUkdldk04eG95?=
 =?utf-8?B?bmxBNjBSb0wzNGp6VE1meDJMMll2Tm5SQWZ3aGdKcHdac3VVSjB4a25ncmZM?=
 =?utf-8?B?eWI2OVlMZlM0N3RlS0I0c3dSR0wwbmVXUkpHMHlCSHFMVnlKVjZqWTE1NTh1?=
 =?utf-8?B?V3Q0aU1YTTk2WlF5Nm1GSExYaHFadFhEbUdENEcvZmo4OTA1eGlwN081M3BR?=
 =?utf-8?B?RDJkRWR1ekJRd2krUU5EcGJVZVdQbDkyczcvYlZSNkVmSlFjYjkvc1E4ck9u?=
 =?utf-8?B?ZUZ6dmRseStoK2ZpV0FSdGpuUFFaV01nT3NtQUkvd0Vjazg2VEhCTS9XOVBV?=
 =?utf-8?B?RHVpUm9xZ2RCaDJqTzlUcDE2S3MrU1U2UVdjNzJnYU1STzlkcWN0Z3poczVC?=
 =?utf-8?B?bkxYd2hTZFhXRkE0ZFd6UW0rU0k5cEIyNG9SaGdvM04xTk9OQVFDVFd3WHJm?=
 =?utf-8?B?b1R0a25nbmwyWjVZMUo0bExMZG5EdzNESUUvSUFIeGZYRldaei9JMUlzSFJQ?=
 =?utf-8?B?Ung3WHhmbEFZOURtQUpvNWU3U0ZocjMzdWR5L2F2c0xvbTdrM2RuNmVRUG96?=
 =?utf-8?B?b0FUTGQyY2JxQnFINVBYOVBPeWxyeWdSc3B3Mzh1QW4vbUdXMjU5M3QwUHI1?=
 =?utf-8?B?MFlhSXdwVUZKWDV4Q3JONVBYcnpFODd1TVFhWEMvN0NaUVVsSk5DaDNwREpv?=
 =?utf-8?B?cVpWeFVPbEVpNitWdWFKSlg2ZmJHVi8wNWppVDcvdXlpN2s0K1ZmT3ZZUWNi?=
 =?utf-8?B?NjIyUEFlZHpmVGU4ZTA5d01ZdjQ5Q3VYaklvT1BvTTcwdXZTYjVxSUlpQUd2?=
 =?utf-8?B?YVNRK1Z6dFZQcUxsVzNGK2RXUVFwRTdheExncUMrUVNDWitZNHY0NWVkak5r?=
 =?utf-8?B?dnZEUGtWVmFjZG4xdDAvZlZLY1Y4d09VYm9EQWllbnQ1TEl4clQ2RllrMk1n?=
 =?utf-8?B?anAyMi9oRDQzN2pUQ2pqSTU2MnhGMEhaOXJ0RU54cHFNcTBJbHk2bVRFMzFi?=
 =?utf-8?B?cnFoazEzVEpSaGNIek9ZOGIwa1p6Y29TTHE0ZE9rNGx4WC9YNUdlTHloUDF5?=
 =?utf-8?B?SGUzaG5vZXZyN1Z1cEdTUm0rYVo0UmUwdnNrWkdzdHk0eFZSWVFmRTA5Qzhu?=
 =?utf-8?B?RWI1dFpYbGprMEtOeEowWmpBMk05OFBqZ3J1ZjBNb201LzJVc1B4VjN4NWJZ?=
 =?utf-8?Q?Uh3E7iHEeYsuIhKmdHXFvYQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FqF4IAre4f4Ar8MSBToUNpJ+6Yik6RKLUFaV4CMxHCN6cdy23v9e3Y32zJ3bmbeIVrpCjIfsXTbMMTcX5rw3w1Dib4FVRFlgEWDXDRTTYrn3aue5YGsrzp7+8fNbGs/aCbI72lKXG+KgUKs3G/sIdEfKL86hg/+QRUAyJJf8QcyUCta2jr29lKOef93MgmNkQOaavr46ynE5Q65qCO/wAeXTKZCbJg3fnnKyppCMb+yv7oq9f/s3orlxz10OrtvoFncw7RzI7IDLjdVqlvo9YM5eInZIrHaDs4f5LJoNyk67vCZPbrFF1nDNv32ZIA9JFKPu+Dchg9GwLdg7O35Q5z5BugcJg2d5ZRULirC5/8oausSFwR6homT7YS2JKaM3mQsLzAzGnBdFOyUroQ9FjTRDbS5QrGBp5oA2J04nIxyTzR9FHNRGWyRjQMBun+ekAe3CQWAY0NsE6vew8HafryljCcFdzx4HpcmBYR70yDW6PF/i+hoX94Ow0aH8vOGd3C+5PpcsN9L0ks7ImvLziidJpIEXtqJZn9S1BmL/nfabjQs45C6nRUGCAtv7qjoxL/7v7UseUr4+4d9iUrrByjgTvdv3K+tOCK4TIlHe1pU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b983d54-2f33-419b-427a-08ddef615b46
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 05:25:58.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gab2GwhKyEpMz6krynEphTNqKKP2c8vvVS9ZuoMVOYetpGt8xnflcZoVTJBowooIjatfCa/eAPVdXdRZ0+U13SIMkr683mrGOQkRvf0OTn1KfcFvhLgduMQnGLfIPH5R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090051
X-Proofpoint-GUID: bo2l1NPS_CbZr9XNeRoWsteFALMsR6rF
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68bfba6a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=UlE0iww382u4jLCPTdwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX4Rd1+EQwkL/A
 Tnj2qzXAmDmq3wrKXvpJQlXGALXfTMYPG+Ohlfv+WyBIhbFKvN8DQUxkpwT8sS3+2243BbBrNY8
 IfG9Q9ohCj1RiY3Wzplm0CeL2GRzff6w9214ozJsgIEDjoqJziATBTeITLQnWl7YsT2T/qfJEFI
 rtCeYu9Ky+i+RUM+I/84mf3YcZFzofHKuwBCs0KJbGJ3TRSDumhzBlVxlvKDx50QyN6H4BUmNH9
 49XCN6HlwugGwzBsuXi4m+Hq0bLFu4Va/9RXlfABy2SLMZcVjsxIWYeZRRVCccCGriBh1zy4kZs
 oyihUbPsQKDggnw9Yj7P1Kqr8Dt08GMVcUoIWZF16tte+nLSH1odCIxsAJq0RiuF2wQ1alGCPFa
 D1Qct2an/lfwe5e3g88vN91dpnNLpQ==
X-Proofpoint-ORIG-GUID: bo2l1NPS_CbZr9XNeRoWsteFALMsR6rF

Hi Greg,

On 08/09/25 01:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
