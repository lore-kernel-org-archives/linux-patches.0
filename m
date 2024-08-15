Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522B37703
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 16:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739103; cv=fail; b=oKtwp0oPha5wT803wqMstKW1XiDy9SOYhbv5DZYOSpp7DnsOKpwOVxulTb1o+k1deDXECqoraoH9ieqO3VNytrOycmscuVVqxlEyVjGlpJRy8glxnOMGQASDpiD3Dia7b1NncxzXPJIZ0ZNqMIM/z23Y7fsFVYCr21IrWHoNU30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739103; c=relaxed/simple;
	bh=0iE9As2Bl/0oW0FD/PkfjogS3gavQRlyEN3gAAmTWCg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GZH02Ya0jNcFBBJ7yYwaDQs/R7PG/nSLscB0283TWRa9SVDdKRhLGarY/NKyovluhMyQmGpVLO0pg3xFGwOwnm2Hck/BrW+viVBVVek1dYPP9tksuoonGUj73vUAxRXjAFV93peinSCZfWD45tcKEsE3B9+LDHeonvKNUQB8qY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O2d+yPr0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RCorKHD9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O2d+yPr0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RCorKHD9"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FEtTnQ014149;
	Thu, 15 Aug 2024 16:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=6fUUQbRGxPWkzsuErAp/WzvBZ8fX6TdUkTUoA4E+0rI=; b=
	O2d+yPr0KRfWGQNtkYIxwZklqAIj3x0KR5Fw3JkzfDL/ZjWJXzJ+03MHm54A0K9d
	KwXbFT7u+L3Or2dFplSUry8WM3Pohfoh2fupiASy3I2i1XV3xJoWfol4xS17U0Aa
	oedP2h8dNc7+pvMXwZ6MPZRSdp1qITWtD0IP9BT9X6O0iy+0C1usNTOi6yjemC1T
	j/ai0fAbyX1wBF7DpHrM90LUaTfmi72nVbc2uimnvO3QXDVCeGwVcsT3aZIGo5G0
	ynEhyTJ9e5+A6SZJE06P2gsVVxEz+gpODzE3j/X+gM6Qe/3Mlth+6YD8E7KhPSt1
	v27itWJO5N5DUKGHMMFVLA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4104ganjqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 16:24:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47FFEAJD001358;
	Thu, 15 Aug 2024 16:24:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnb8ay4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 16:24:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQBf+zSUsdO7ANhNXoTIJ0PLUDLDcJfk2I8iov19H0dbNL509ePL93ZblP5OJsZ2N2jv1SO91SUcyoHgmeszJ3NfuWEg+0lSaQdSv61Pm27h54O2K6AMDBom7tjdkCtYOauJhWulm3tCctai82eN2vBteC5gAxyC5P0YQk8m6C+BWwQKa/EoU9kfcSDq8eRiSN1dvkgC5yC8VBSM/ZcwggYCAAkJcdOU+ey8WcilGm/t0UBxswSsJVqHyJd26vrnYt6vBHnl80QULI7zPaCEP6Y8lSy7BE8zGqBKiaSTPyyE5N3MM9wS3NhdiK/hW3p6nMXTdP/+/UyacbhBsljlSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fUUQbRGxPWkzsuErAp/WzvBZ8fX6TdUkTUoA4E+0rI=;
 b=Dfikd1GfCnbB831Ud7i4F8tLxWRGxXa2JVUAK+vEfaB5jXwI0YlKHqfUGAaWkX8huBnBhI+R83vxmzn+ABmP71XRiyyvcQTIEYMGs4D12rkyDzesyuOGGqypMVagW47VUMWEy3bcAl/WVilgdLTcP2lVlbK2NAp4plnNtVPhp18i5mRVUGaBN978QsIwD1Mu9du4gfD5iyq4224ZEzCcksm3UyHww5kFRovvszgzR88QFYVLB1lhqIznJcfbhz7eF239QL1anVef2BmVTf4jwC+kOL80UQYpXzruy2ABvddbEXqsULNCHItRgnX4O7ZnDHGYD1rgWEU1m3+3AacfZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fUUQbRGxPWkzsuErAp/WzvBZ8fX6TdUkTUoA4E+0rI=;
 b=RCorKHD971LIHJCGkqoIjBpJk+Y6Yks3Mfv6NogFCcp06rJcnZ0MGqWLijO1tOqPn3l+xYYYw+46HrrDfdB3inNFNrNLtyL0smj6AIcZ2Dx2EIh//7HzVamkR4e81uYsWemm8nAn9u7CPH8YdexynfWGrRC5p27/5DQwpC6ZmmQ=
Received: from MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14)
 by CY8PR10MB7172.namprd10.prod.outlook.com (2603:10b6:930:71::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Thu, 15 Aug
 2024 16:24:53 +0000
Received: from MW5PR10MB5738.namprd10.prod.outlook.com
 ([fe80::187b:b241:398b:50eb]) by MW5PR10MB5738.namprd10.prod.outlook.com
 ([fe80::187b:b241:398b:50eb%4]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 16:24:53 +0000
Message-ID: <583b6fed-5233-43d7-b106-f78674660b0a@oracle.com>
Date: Thu, 15 Aug 2024 11:24:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 29/67] jfs: fix shift-out-of-bounds in dbJoin
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        syzbot+411debe54d318eaed386@syzkaller.appspotmail.com,
        Manas Ghandat <ghandatmanas@gmail.com>,
        Sasha Levin <sashal@kernel.org>
References: <20240815131838.311442229@linuxfoundation.org>
 <20240815131839.446390501@linuxfoundation.org>
 <36b8c214-3039-4fce-b27e-3558a78cfda2@oracle.com>
 <2024081547-defrost-basin-8be3@gregkh>
Content-Language: en-US
From: Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <2024081547-defrost-basin-8be3@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::7) To MW5PR10MB5738.namprd10.prod.outlook.com
 (2603:10b6:303:19b::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5738:EE_|CY8PR10MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 75250f90-521e-4009-0ecc-08dcbd46cb49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHdFZzVIOHVOT1dsb25uOUdCZi8wRmVaekI0Y2VHbHowdXlubG5SRlFOU3Nx?=
 =?utf-8?B?QldTejJLLzZxTnMvSDIwd1YrTE56czY4YmtGaFpnQ0tEYkVaZzJFcTBZd1dS?=
 =?utf-8?B?ZEdMR0JuamhGdmdvQ1hZRlFlajJGeHVIWDBwWE43YnBJbkY2ZHdqL2xOTjZv?=
 =?utf-8?B?Mmk1cnNYaEJ3cFE0UzF6bld1Z1RldVF1Qyt5VWZpeitLSUNkYXBhZFUwMU9o?=
 =?utf-8?B?Q25MRXM0KzlzaUY3ME1GNWVScnVMandoOUNjK3Vub2tUY2h4UnBENUFzWjZo?=
 =?utf-8?B?bEpCbGRsMnV3L29ybVRJOERmRTFwR3k5QVB6S1h3S1VFTThLT1hma3Q0WFNs?=
 =?utf-8?B?dGp3WGxoQytYQ1NkVmFmY09lV2dCc2VyRjdKOWlWNmFSL3EyVW5VNUlZN3BV?=
 =?utf-8?B?T2F6RzBOVkt4bmxWVmVhZld4UGRyTk5RRXZRQVMzcnVpUm8remRCZVdRR203?=
 =?utf-8?B?bDEzZy9UK3RvS3BFdGJJVUcxYnhXODRWa1g3dlBUKzBOY2NVM1hJaW1lVnVD?=
 =?utf-8?B?QnlqZDhGbDh4WG12RkR6VGVaQVU4NUdkbktJaTZEMmNjeEQ4SGNFUnRmMzYr?=
 =?utf-8?B?eElBMkdoWEMwR1ZNdUlhWC9ZTVViQTFHK1ZKTHR1NEw2U3FLT1pOVzl2aVVo?=
 =?utf-8?B?d0tCVGxNNkFBdUkyenlhdmRrVCtTSjRvRmlkRUZWU3JhVDVUOGx5eU5iTHVt?=
 =?utf-8?B?TUJLNWNMSnExSU13aDlKTHF1NHdnUTNLY0tOWUhQMjRiWjRuVkgwQnZrZWtY?=
 =?utf-8?B?VU40ZkZYRE4zSGxRMW5DWnlITzNsZTdrNkJpa1Fya3lranJmQm8rNFR1bStG?=
 =?utf-8?B?USt6Vi9GemZ0T2gzVGxJUXpOc3ZuVms2c0ZlOTgrZjlITWxCdnpvT1U2Mm9G?=
 =?utf-8?B?VTIrMnA4d1hrS3lydmQ3bkpXTm5PUUo5MTluZm91RUJubkRiaDloV0NzUWox?=
 =?utf-8?B?VFViNk5ydVMzYnZCdVFEUVMxWXlnZXgyNTlVSEIvM1ZyQkgyWVd0ZDM3TFM1?=
 =?utf-8?B?WTlWSGNhYWsxSEdHZUdmaGRZWGFwK2NXRjlQaGVyNjdTQWdmQks5cGdZWmYz?=
 =?utf-8?B?ZHYwaUJnckhwdkJWNlRBeTllVWtVZnFuVlBHZlplR05ycDNaMDBFZkM2R2FV?=
 =?utf-8?B?UDZPZnZKTXE1dFJGSUtWd1F6M1o2UTdEcTJSTzlXRXkzazMwMU8weUtXa281?=
 =?utf-8?B?RkVQYmVoWEFtTW5ldStZN3ZqTFhXZmFIbW9VWDk2VjZ3blJ2MElQdGQ4TnZw?=
 =?utf-8?B?bUtWN21wK2lHQlZDekNLL0dhK1pnYzhUY1d6UkVrZTVsaUtlS095aklWOHBV?=
 =?utf-8?B?NGVYdFV0Tkx5V0RxTFRBU0Y1bVByWi9CcCttUnVpMEt1cDVPN1FrRExMdTFF?=
 =?utf-8?B?V2FIMG1VWFJjOGpSYWJLV0YrSkNBTGZhMEtRWS9vS09QYThZVU5QNGs3WHJm?=
 =?utf-8?B?TkF1b1NETjh3eHlVdnNvOUNpeXhWSjk0NUlOdEF2NVpOdFpSYUpPcldLRlcw?=
 =?utf-8?B?bVcyM0NBWHI3MmloZ20vZUxueGFQNCtMd1pETHh3QjFwSWdIS3pIS1pwaXgw?=
 =?utf-8?B?KzFQNW54RVpYZU9DV0RNMVQ1OVpuQkE4V1J2UmhmdWRLREw3TTBjeEh3OEFp?=
 =?utf-8?B?bWdvR1E3YVoyZ3M0ZTZQRytvVURaVHBPbENhZWNyWU5CcjFXQzFaTUhSUVFa?=
 =?utf-8?B?SXF6TUEvaThaZmp3Ymw1eGhQWWhuWXFkdEJNWkxvM0hjWEs1dlM3VitnNCtZ?=
 =?utf-8?B?THdwWktVTThwSldUcVRVeHYwdERmSkJrOHZhcGxwSEVxS253OGlOVnM5Nzl3?=
 =?utf-8?B?VVIveTMvVFY4dFV1b2lTQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR10MB5738.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkgvTjl5WFpMcFFiczljcEhCWkNodkZMWjJ6L0FkaHJkSWV0Y25WTFR0MnNu?=
 =?utf-8?B?czI5eEh0ODVkTFV3ZVRQbjBBNFhSeCtoMHN4bDdyejBaR3c4RWtpUnhqV2F3?=
 =?utf-8?B?WXU3VW1mcGZOdnAxaDFuMFpXOENNKzN3SGszenpkZ2VRRXk0aW9oQThBc05V?=
 =?utf-8?B?bVJKWVc3YVlNV2wzY3lIT0h5YWlKSnRwdnJhTjZTcS9EMHdObXh2TmR6NnlI?=
 =?utf-8?B?MDVsbkljYk1PR3JrTDhVQWhDV3locFNZalZLZlNVMmp1aWo3bG5VWnJKSGR2?=
 =?utf-8?B?aXV0dkVZeWl6dDNLL1M4YTNXRXNVMzhWdE9xMDFIWUxlVFVsRXVGVGlEUGla?=
 =?utf-8?B?SFp4MnRMR0wzRDQxTG9qVnc4U0l1RnU0Szhva1JsUDZaNXJoS2ZOcUZoVWJE?=
 =?utf-8?B?M1pDWlZOSUxUa1dGSUNTT3R0bnM5TXRERmNYMlR1bHJHaVJ5RjVQV0x4ellj?=
 =?utf-8?B?T2FMcSt6V3JMZk43Q0JYZzI4K29YSFd4bTM1UFFYak40N1hIdEJxemF2Vkxo?=
 =?utf-8?B?elRRSXBzKzdmUjUweHcrOUdYaFBDSEdnMGtZQnB6T3dsNmNkSzU5c2l0bE5B?=
 =?utf-8?B?Z3dCcFd2QzF0YVYzT0FYU0s1c2FNOC91L3o3YVNVT2R3S2F1RnpvS1ltZFE2?=
 =?utf-8?B?dElEVFViU1cwcVZuVjJuMkxweldJbjZRamQ1RTlBTXJ0RUpmZ21VcFh2VHlx?=
 =?utf-8?B?MGo2VE94Q25ZMDIzNG1zd3RGQmlJZS80ZjdQQncrZEdDS0x0Zk9qNVpFdUJN?=
 =?utf-8?B?WUEzSjJ0WUFpVlRmbndQL29VbTB4ejdqaElzaXZ5dUFpRGk0aDAzbkNJZ1VW?=
 =?utf-8?B?bUVJSGJIWmluaUtYUUo4V0d3ZFFqdDFjOWRPTlhkWWk1Q3UwV04xQmFzT1N3?=
 =?utf-8?B?bjRmVkNjTml3THFMOUtYVUF2RnFFYURsaDNjSjlYemFzNVVKNzR5N05NaUs3?=
 =?utf-8?B?dEN4QVh1NDEvSlNweHltZ1lpSTE1QVMzUlFONEszV0ZIYWc1VGZqdFNGalE5?=
 =?utf-8?B?NGF1eFJwd21wcFNmMVM5MVRheVJ2a2VyT1huTnQyS21lT3c4eDY4YTk2OUhB?=
 =?utf-8?B?TzJJSUc4WUdQb3FpMWkxanBHKzNJaDEwblBvM0o5czAyVFJNQlR0WkpKNTAr?=
 =?utf-8?B?ZEp3VFFycHJyS0hESW1SRXNaVitCV0NaQkhKQld4OTZkOU8rQm5QRUo2WWRt?=
 =?utf-8?B?S1d0bE9NUG1KZ2ROT1JmeWRvUDRWUXRUSXdUZ3o3aGxZOGhhS0xVRjRtVVdl?=
 =?utf-8?B?bjBwYmpGckhaMUZEeHF3THBOMTZuL1dsbEcrZXR6R1FnVjZsU1d1VFI1WGJJ?=
 =?utf-8?B?aDRnTUkyL3d1QTc4eTNjNERJQlVKS0V3cUVRUDlvN1FzU2pCeFkvMWdybWNL?=
 =?utf-8?B?enkvWTYwVzREckt6cFFyUG8xSnFFNTJtc003bkFuRTVDK3pxV1BWdTA2NWVv?=
 =?utf-8?B?ZTlvdEo1NDZtTWgyVlFKSTUyZGdWZ08vZlRmRGE4ckYxR0Uwa0VIZ2sxMVdp?=
 =?utf-8?B?K3poTEdDWjBxRzdyRE00YUxjVUc3UEFjc2d1U2VOdVBaRGZyMy9idmZFWFlZ?=
 =?utf-8?B?V09FMDkzWUVhaXJ2cTJ4UmxxQzZ4YWt4NktRRXRrQWo2K21oZWxwVTV3UHR5?=
 =?utf-8?B?ZGxlTzM2c2ZhdHgyZGcwKzdFSHY0N3ZabTAxUDZNMVVYY3Y0WW5veVRicFF5?=
 =?utf-8?B?VjFMeEk4aExVb1l2NWdxajJudkRheEI0aDRWRkxZNEV2RlJJaUdHTkNWY3hE?=
 =?utf-8?B?QVZYZ21GSG56ejVJUlQ5RHRtS21mME13cjNoUUFZV1BtSzRTOElpVjYzTHpP?=
 =?utf-8?B?WXl4KzFRdTRrQXY1Y2VJd0F6RHpEWmQvTldPZVdUbTJ6Zy9IT01QNUlEVXhK?=
 =?utf-8?B?dUVQL0htMzFNMUN3YTlqcjNYUG9lSFk3TXlaOEVUZ2l1S202em4wRFZaaG1L?=
 =?utf-8?B?NkczS0xxK3JqaFROaDN5TWQ4eUZNUExYSG94NXRYRnR6S04xaE0xcERMVHI0?=
 =?utf-8?B?MC90Y203T3BQVHE5U3o2NzNaQjM5eUthOW9CTjNaVVlsU0dZVC9xMGVqNTNu?=
 =?utf-8?B?OURkb01LcEVhS243L3lpa3N1a2M0RXlTRVVmVVVvb2ZZSERMKzVHUlZoUmV1?=
 =?utf-8?B?bDNQY3RIMzVLTkdnUkpvR3lCVmMraHhMck85MWVEWkZVNW9GNkg2SzdTeXhm?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jvjIQ8LoOdACMmAdsWojLkrsWGWDOHW/+YTBO2Zcphb863s76Rd3XWXLLttV4A6L9HG0v2YRXrhcQfk3Vn9p3/TR+pWZVDsVhP6VYPUipE6HF9FV5RllVr/2mQ4VgZu23fEvAuXCwHE2+0KPBE+0F79qynSdTTOkW+JgBpPFymSDNPGseGXTpqPF49FIgFMsofeK2QUCtx7gX++xIUlcT8kCcTO97LEyfzH7WF2uAFmXY/BfvozpZ/DrEQYj9uVKKDRZ0+Ge3ZvrBqO7GRcZNLQB11TMYsvN0YeJh1oAqIWgnc9yw/rqDUoJfyk8+fOy9raIFjevsihlwC6oWuJdLXxnVca6ugMtEYsAm95RD4ba6+he6S+BjE+uQGjEOqshAvD52RCue9Uesoz4f1hcPfUcO9f5AXl/DjN/eznJ1cTgGXn9qrA24Eh1cBFYvaMWu7bJA+xIbSZSlqtGlKlOagK9GmpaVe5SjSm1EpnqQvOB69u0m+j+vL8tds+CPlbsvNAxf7DeEzfOie+wsiGp2QmQvEb7IqSEC0BnxkfPWDDrV9e1AtvWbdaxsxjD33h0IOEQPXhrqBowJqljnk4KJHLH25+2wogy48+updoFb60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75250f90-521e-4009-0ecc-08dcbd46cb49
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5738.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 16:24:53.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qheqhMeeBbQIT8+hKAThlqHqhfKlmya4lL+tGauFr2nolqxxvALbTZ5di8bKMg5KphcqfcLRgeUq6+Xs6vnu1knuaY+9KtOdwprlbZ1Mbfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_09,2024-08-15_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=791 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408150119
X-Proofpoint-GUID: wGHuDyaRWmQEgOCq-DWBNdiuiK4h6go5
X-Proofpoint-ORIG-GUID: wGHuDyaRWmQEgOCq-DWBNdiuiK4h6go5

On 8/15/24 9:19AM, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2024 at 09:13:42AM -0500, Dave Kleikamp wrote:
>> On 8/15/24 8:25AM, Greg Kroah-Hartman wrote:
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> Please do not include this patch and its revert (62/67). This was not a good
>> fix.
> 
> I added both as our scripts keep picking this up and it's best to have a
> "patch and then revert" in the stable tree so that people don't keep
> trying to apply it over time.

If it makes your job easier, then I'm okay with that.

> 
> thanks,
> 
> greg k-h
