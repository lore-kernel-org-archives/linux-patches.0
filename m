Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF7B72617
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 07:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753945786; cv=fail; b=MuOcPwVEiasiYs/wKZTInVx4kVVVnLeSpuXwzefihLJpnzc2W/scMeHuklPduIMp4KV+/0Ep/doFRAmuc+oF1K7GANwM5X9zLDuFMJsJpIebEmR0TjM1LIcXlSN/IZeyY1F8HAqO11HalsLUsc7qtINMtF35uYWwGzP2gCyPAEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753945786; c=relaxed/simple;
	bh=jxX0CYeeY12/ovlp7BYhXjUNQzhs/rN+zxUQj/Rig6I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gIqvJCC5g4nAJlCyY6C89VrRQsTpxs5VQn2pvxTI5YNgrLSjNcntMsD85u8yQ5uazlxmVlAhTxUHTim0v+TB2dV3g0Cg+H0fMO7u7E7GrzFrli7OzICnSN8uQLq5p5P73RPTugLHMnW1HaW7+Dlwlk7FFokVJreJK36H25dOCJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H5sCQ8Zk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W4+m1A3R; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H5sCQ8Zk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W4+m1A3R"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V79QlJ029071;
	Thu, 31 Jul 2025 07:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pFFpj0d9nXa1+ua1fUrGEfQ6wlANsuxtuuydugSFIOY=; b=
	H5sCQ8Zkn8rHdMtyHZ+bMQuztPCWPuGtvXOOy3mr1wIpcEYYaBGa0NqBoA/yndME
	VPjMT7lST/3MnOn/Z5av2L2qK48k1c7hSrmL2m/qkNzQdngdlCqtoLjJBdGEtOWW
	1iqH4mIS7SWywDRIAYIx9T/JZX4RZMWOdJVygiMJ772GPYQ5rDGalFW7XhM8ZmmQ
	IfhPFxUf+RoCvAOSztx5Th0A2FLHM0hnXmZ0PE4Mq8wCuN4edO8la5yqMUe+81SH
	F0w3HzVmNuFHX1gDr8P/6ZLsVbbeo4/YIZUgUK2cd7bDSNxauAnAhJn2Kv9FcuMs
	N4KPluoPuy1cldwAWPm+1Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484qjwuhpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 07:09:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V6ehJP010498;
	Thu, 31 Jul 2025 07:09:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfbyj8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 07:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+X+gAn9FezdvBYsNBk0zAKftyarnokmUmvakUz5OEau/Vqh6XcQX1YaMiAQ1oaTsqMnFH3UKo9J3DOkB01YNOyonB6vm4yStmz82dJBXzUK6GVDCNMGIr1FgyXhyyUNjMN12xbHTf043nbjENj6h2G7lokbfSqKf58bYzcyJoT8RSAXn4IyAorN8lPt6+EEzjdeVatpXmpXGTrxX/Qz1HxfzsgVkB6sCE0OFdzDRKD7XH5QRWVon0+U8oBrbAvg+RE8hTF2xEPhgPImbYCeUraAYzRzntF8mR9vzTvm+Lud70iDk7J3zzQoWiEzbc4rr6sw+csTdlmOR18djISjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFFpj0d9nXa1+ua1fUrGEfQ6wlANsuxtuuydugSFIOY=;
 b=BbpGqPVxZ82cUEzIS9vYRV4dbxTwgUpDUQ07whaBcj6GheVA92KRJRIMyxTbAAYpGOvXMNfVhcjvGUxPNjh10fyXEI/K9C2i1WUioJJl2kt07sKUiNrLQxD6HiSO/H/HyDoZdXMAk8/Z5cx2dq94AEsGlQmgKRejydDJTv4/PCY3Qap65me4bWK+qKKogyRUlxFychksihiodH5hBNV0A7eSy8e19123EWCE8pyDjBVL6+RMBi3VfhHBHYXeNjWEK7g/Mqvl9/RR1qEV6Mffta5IGUsfvy1Nf+Mjnz5WPEPe6rB3PcPaQbHfjMCUn+oOCPZGQFYm6G7Gd5yaA1w9hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFFpj0d9nXa1+ua1fUrGEfQ6wlANsuxtuuydugSFIOY=;
 b=W4+m1A3Rx1MUX3sxAO6E64npx2M1hytj8NXtq1c/f3MuNIjE4xjpoTzbPtv3iA8OCxv7+IP/HpRCzl0zrdnrutMabzOM178nNyqxdwPo4mcO3CDnCnSk3Q07ac/8o7SKKhkx+49Cpy+r9dtBGguPUcwZU9hs1UC+GWCYtdF2qZo=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by SA2PR10MB4780.namprd10.prod.outlook.com (2603:10b6:806:118::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 07:09:16 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.8964.023; Thu, 31 Jul 2025
 07:09:16 +0000
Message-ID: <986658af-9b19-4ab3-a294-b24251120516@oracle.com>
Date: Thu, 31 Jul 2025 12:39:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250730093226.854413920@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0357.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::33) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|SA2PR10MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: dc71731a-e088-4490-5989-08ddd001296b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qi9RSVZSL2NrLzVlWkVvK0tJVUgxb1lXRWpUUnlqdkxxdERyTmJOV3h6dWJa?=
 =?utf-8?B?ZnJiTVhRWnFEWmN3K083SkN6d1pJdDB1ZUx1bGNRWHFaMmFOUk1kS2NlczJH?=
 =?utf-8?B?S2FMOWdGc2NldVI5SzJScU9KQWV0N3czUDMwTWdZQjFZbFM4bVhSZWlNK3RT?=
 =?utf-8?B?RWZFaC9ERHFMRThwLy9EZ2ZiNGZjMVJhMXNKSGprQjd1cEZLYXlwUkUvOHlV?=
 =?utf-8?B?T1VzRUNwb2tQOXpSOWY4OWhoRit5ZFVKbzZlbmVCYnRmNTg3OGdxY1VaZHlr?=
 =?utf-8?B?RWI5bi9seE9iQ0lyaUxuOC9TbmQyT3lNN0hhT1BLYTRsU21nak84VVk4YXo0?=
 =?utf-8?B?RWhjajBLVy9zaGxSTndxWmhaQ2s1MDQ5R0s3Mm9hNkRUeWJEMnUzUmVERUVr?=
 =?utf-8?B?TU1GZFdpNFdvZmhJSnduSCtHVlBiSXByRU13YlM2UHJIUHZmMHdDdTlXVCty?=
 =?utf-8?B?VEx5ZUNERXg3MXhCNFdnQmZ3a09JZUJpQXB4VmtERjM2MzFHbHNZQkwvNURX?=
 =?utf-8?B?QmlDNi9oTXpjbllsb2xmWG5PQ2xDRzZOanBUdmxzUllBM1N2Q0piaWZDYU5z?=
 =?utf-8?B?L1FKM0FxSjNCSHdOWWtmNERsSUV2cjNMWC9HMm5PVVJHTHRyVVJrb0RDWWNq?=
 =?utf-8?B?dlFaakFOUVVDYTM0Ky91YTlQUVc5RXZLM2dHRlBnSWFIbzJXc3lxbmRGaFF3?=
 =?utf-8?B?ODJmcm5pMTB3RFdQT240Vnl3dWhDUUNLZlkwbGJRUm11bFRaSGQvZFRRdC9i?=
 =?utf-8?B?UUwvb0VUaVlYS1I1dlFlNXZ0Z2NRUUR1N3JzdmxKTFpOeTNQTTVFM0dUYXlB?=
 =?utf-8?B?S2JjeU1GM3NnU0duWTlpOWpvVGxRTDNKZWxlWUZVYkdMT0FFTjU3ZTlIVi9r?=
 =?utf-8?B?UTlNTTM5SEhHZjVNbGlmYmZkSXh1Nmo2YlJVWkVLdnVoOVErTnI0VXJ1RFFL?=
 =?utf-8?B?TUhneS8yYXc4aStFNUJFOWg3UE1ZMzFoWEpNTWptd0VQQk05RXRRS3VUVVBW?=
 =?utf-8?B?SktnTUhDWVoxMG5ha3k0YWhlZGpuVGJBWVVkajJLZ0tjV3RQQXprN2tZYnhS?=
 =?utf-8?B?Q2ZDZXpRU3dGdUxrTmtqLzJWcm11YVZSYndGeGhIQTZDRDFGVWJ0ZDlQbUp5?=
 =?utf-8?B?akFYSXoxMXhISUFRQ3pEek9odHlHMGhWbDFqM3doUENKYzJMUHFNRXRUQmY5?=
 =?utf-8?B?eE1LM01SRC83Qmc1dTFyZ25ManNhU2thVS9EM0tQQ2JMZXZyZFNrYklUalV6?=
 =?utf-8?B?N1NFKzFEMjh5aVRlRHF0R09hVTZqbVRDQ3AxZVBvUWR5WnJHNUdQV2FSTm5X?=
 =?utf-8?B?UGVocEhOUExsODIxaldoeHJDc2RaYmVlcFM5clRwUEl6SEJ6cHVLUExKL2o2?=
 =?utf-8?B?R3crdDRVT2IyTmxmQVhlWGF3c3g4Qnd4b1I5ckhjL0REK1JMSmpiYTF5Q0RQ?=
 =?utf-8?B?TS9VRFRGSVg3K2dCbFhtcEVQazJtdHQzZy9jdWZVWHYrQjFwTUQrb3NlMEVw?=
 =?utf-8?B?VFNxZ3RBdm9UMjdBbEZIK1ByUngwZDZCeWU0NUZPQXlyek5JZnhVOGp2bnZU?=
 =?utf-8?B?bDZIWS9lZ1JxNEVoVnNYT25TbTlxVDA5Rk1DN3hkNm1OcjJ4S0FQRDZVZ3U0?=
 =?utf-8?B?K2YzUGtrTEs2cElZSzRwSVZ0ZEhUVldyd3hvZElIZmVpTUZxZlpFSWJ5TFF4?=
 =?utf-8?B?YS93RkoweGczMWRmek1TZWR2aU5rVjFNWVEyaVQ2aEo1bzJFRHc5WTAxZXA1?=
 =?utf-8?B?UXZLMG82b3l1WGdzV1V0ZnE5L09PK0p0bUN4OUNaNEVCaHhJTzVmS3dTczNE?=
 =?utf-8?B?QXRxeGNnSnl3OUJYekIzeGpOakpobUxtS253SUVzRS9PdCtaMUZhSnJ0NERU?=
 =?utf-8?B?dG1vR1UvYndJNnFoRkRsbE1QT3pnQllrWDBVdjNKWXBtOWJ3R3NKNEprS0RW?=
 =?utf-8?Q?rVe1ShxPuqs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0VoUkpKZWZBQkMvVWVYYW4rVFdQTklHM3dmY3BUaVFLQUJRWDFuZHd4M3dR?=
 =?utf-8?B?NXpSTGNGejA2QXdjalJrdkJ4SktOU0JBYkxrdE80akdBNDRGU1QrbEJRRkZK?=
 =?utf-8?B?VEdnaXNpZ3pCdFVENkxWS2V0QzRVdVo2YVhLWDZySlIzcCt0ZVRPa1cvQlFH?=
 =?utf-8?B?Uzc4LzFsaGVWdmZJMlFGbU5qYW1FeXR4UWhmR2NFSzVheHRFS0FCMHZCTVBQ?=
 =?utf-8?B?aDZLYkROYWdTeW4zWG9MdWhrbDZEVmJFSWN2aWF3VVhVU2h5UWVTWG5aRjJ0?=
 =?utf-8?B?Mnh0aHVpYlVXVmhndGQ2SHRMb29kNGczQ2JkdmlSNGd6QndDM0ErK0ZBZmlx?=
 =?utf-8?B?cjBuMzRVNjU5eHZoSUpVaktmRUlJZ3l1TzJ0eTM0VGtRNFo1eUJIMGxoSVhJ?=
 =?utf-8?B?MklJbnRVMHdyQWlXUy8wb3VjcVdidTZacVdNVlA2RG5sdFNOcHllaFM5d2pC?=
 =?utf-8?B?dFRBVlRPSWk4c2t4aERqdHVXeFdkUUFkcmpoeWFmMXdqWlVxcUJQRzZJczNG?=
 =?utf-8?B?RWRvY3N6dkpYRll0WVE4T0h5OG44eUZkbzZ1dkJZb3o3VnJ5TWhFQVNoNUFr?=
 =?utf-8?B?a3NpQmh3N0NGOGtVeDRFY284SlVmUUJzQzRmUnEzU0I0N0xKUE5pcjlEZW9s?=
 =?utf-8?B?SEljdG16OURKbjY3MCtrUnF2VTRhNnlOY3ZQN2ZqT3ZEQjliTVdPKzRIM05P?=
 =?utf-8?B?QVpBaUVsdEpYaWE2NlI2K29RUlNmTGV1Yy85MWpvSzYyN2lwTzdFdUdVOXp5?=
 =?utf-8?B?SzBUN05KM2VkOXA5dmk1L1NGTENiemx3aDViZjMxZ3I5bTVzQXd5UHhtRC9l?=
 =?utf-8?B?enJaOVJKK2dKR1FCVldOSEM3cGp1NStEWW9JeWRjUDlVbnVkMHpYWXZyNTJ2?=
 =?utf-8?B?eWxOdnBuclNpRllyNUpTRkliZnVFT2VmZGNWTUcwVHBOR2FsOXRVYXNGUWVv?=
 =?utf-8?B?ckVzVm0waFFhWUNmZGJwMkwxc2k4MEZBYWxOaDZybEJqcXYrVnZtWWE4TS9y?=
 =?utf-8?B?d2FrTVBHTDZ5R3U0SWFHRWhOVEJBVTJMTVBmU1JtMy9sTGdtblc5ZTQ5WjlV?=
 =?utf-8?B?NHZjWkhSek5MN2U5UUZ3eHJYbFdzRGtJWitrYWJqOW0wL2hzbVVPemVkcHBQ?=
 =?utf-8?B?TnVvK3ArNzNhMi9ZNmtlT25kbDBCR2hQbnZtQno3dlRuMXdlTlBoUkVmS2tO?=
 =?utf-8?B?TnFiNU0vRFk1ZUJjeWpoSmhYc1N3dE85bHMrM29IdGJuYmNJQk1PaVl5WFNQ?=
 =?utf-8?B?MjR6NWhNenhJWEJTZ1AvWEdzbEVaTVBjMllUbGt5WGVWL3F4V2VncGlwekts?=
 =?utf-8?B?MWYwak5Ic1ZVU2l6R2RVRlpGTlAyUkZydkt2aHQ5QWttbDdyUEJSYWdWRm9h?=
 =?utf-8?B?VGdvelZ4S3lOYmdOSXFEUmlzSlRMTXhpeVpMWVg0M2NqVUJ3TWRkRnQxN0ZC?=
 =?utf-8?B?anBWbFlPT2NzSnJVM3Jzb2NqNGVydVQrK2JxMlZVNFNlRVZRdXF2cHhZTHZP?=
 =?utf-8?B?UWkwNWp1L3Mvc0MyY21nRis0bm9TaUM1VFM2dkdkS0RESWk3YTBwelk4TGww?=
 =?utf-8?B?d1F4ajNxY0p6UjVLZWk0K0MzdnFqVGVmMWdJdlE4bzJIZjNmeml4bHFTY216?=
 =?utf-8?B?eFBQS3FmNXhRTXFzUFhNMy9vNjEzclFyNXlocFUyVUUyNDJJWmZRdU5KUXgv?=
 =?utf-8?B?Q2ZHamxMblVNU3VoVi9XUjVORnUzWjh1Y1lvc1pCMFI0SUNkM0ZCQzdtOVh0?=
 =?utf-8?B?elNSTWRxWW4vaDJXTWR4R0M1VzFweDczcm9EbWM0cS9IbU9HMTRRbXhNVlNC?=
 =?utf-8?B?M3hsd0paNHM3cEJlZnJqWXBITENGUkowbU5vcktCeDNINmdISi9LMzYwOEo2?=
 =?utf-8?B?V2lvTXZNdzJaVFl2Vjlud0FQdVhJOHY3MkZNek1BQkd6SmJzWE9XN0Q4WnBF?=
 =?utf-8?B?R1NFVXpRcXJwOHhhSDJwWGpLOThPaUZEbGNIUWd2am5wR0phd2o4MmdMWFNl?=
 =?utf-8?B?RnZXa2ZwNEVDNTZYN3JiQ1NQeTl0ZWZ0ZXliOEg0eDYvYlUvVGo3aFdZSDdI?=
 =?utf-8?B?Y204ZXpVUnl3Rldmc1FWK3VCWHRoUUZxeHR4ZUdTTUZJdm5kSWFlK3dnV0E1?=
 =?utf-8?B?Y21OeDdJZ1VTUGYrenFNbnYzMk92US9GemxnS3d1WnNzelBhRFhsNzMyajVh?=
 =?utf-8?Q?q/nOLl23QKUIaGBe00c+qEI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fmsWWB2MsEZmph333pssOa3+eNk4PcX/TVa/dbGT9/scCAYRdeLabW8j9oTSb/myQJ3xVxdOvh2OoeHgAd5MEaYLSVln9QTd73bnjxAVxVtyG6+KyD/MCrE5ItypWlrOAsr7vsDurkGwRAWoY0MS4Pil+yq5B0NZVvzGZpaylYQuh1iuzJLDBjOVFYSKzMES8OYmluSfNZszucOfMoXDFGhANP7cIjWIgxW469NnQYdJWjZy0d9D8pvRY4w4wws6lAbLW9Jbp0XteAn2Xbr44KijUwXHT/7YZZY6fbqjQDnFP68MM1tMUmN7dlHPUbYrAw4dU0zy3udu0Lx5R6Xr8MdeEySPggAHye1j392RyNCa3qPJ0Ja3JxsfRaXgFAWslHo4zRe55uWm8Y5X/QRmNa1Bsh7JNgEvxBekDoOLwzG9TzF+yBSynmYjO0YKbVXY/lZM0PdqiEu9X+MT1kjqcU9oSVhabyPFQq/oIh8sqIYTbCFVazw8/6xVGgQskpqxV0T4F2tzFgUV9LgKAJfIsZhKayCPF5bexxIrRe/Ti7Nl1rwRywUxSTXgIeGwU39OS5UImQDXERcLgKfzv9BizZgo1s2PKaWx+hkHp6GVdQI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc71731a-e088-4490-5989-08ddd001296b
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 07:09:16.6767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AOXnswHO+pL+b84DzdmnetxyMwJJNH838Dj2gRzraT0Q/1nXyj//7CGp3T3vRlUUtNkM2Yr0nBOtlbnSw5+yj1TXBJonGOBRV9nQ7cOoIiV7KDPFYMUTUNDGWMYudaJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-31_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507310048
X-Authority-Analysis: v=2.4 cv=OvdPyz/t c=1 sm=1 tr=0 ts=688b16a7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GqC_iLv50AGlSb7Y8ZQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13604
X-Proofpoint-GUID: n6TelGt5U3Lnrg2dvJPSUUxCC93YpG8V
X-Proofpoint-ORIG-GUID: n6TelGt5U3Lnrg2dvJPSUUxCC93YpG8V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA0OCBTYWx0ZWRfX9otCVlu3hluw
 bcZuTl/pWDFZrfYGcITeQARl4zi0jw4JhsUqBUctlK+gExbkbv/uuBeub0QCorapKfrRVO31k+9
 KdBD6MnDLhHsSb1kA1BXe723xiRuR6h6hbsRJFuFC7/GMLEENvFml2FA+/2S+siv+XoQJNyip7I
 5ias60gjXUrYLHBwfM6P+wFYV33dVDWNtX9PK06zzFybk04Ev0fFAQ5iTCUB2+gNzGjQIgENf1X
 8KRwLYPd7WBCoOrWGVOdY5nxbGneixM+90h8kYIFoRSYJGer8dk65krLYcA0xvA80ejqTWpHgJj
 w2ddYAYQtg77lHPq3Uigb5w6nbaRhu1STQgoCcQA4y4QPy2SX8mx4PmLAbsGkOsWHzpD6h9UobP
 81a84DEXYZ5aILlu4F17GJPm3J8HRSpYl6puXL5GLiK9CdIYBkX+QI59yM5srOGhvruMd8Lo

Hi Greg,

On 30/07/25 15:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
