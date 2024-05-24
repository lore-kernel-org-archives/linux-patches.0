Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49552749C
	for <patches@lists.linux.dev>; Fri, 24 May 2024 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716533688; cv=fail; b=tgtUM2GwSURYn9T0dd3y74KJtlVVrCCgg5g4uxvKhQQK4qzgnPYYP6AvJXDwHkf/6ix8b3PDLd20nwbaF+pz/mJMCquiKqhXN1qfjSyNtrD9f9QmRao6a2DjfRv4KIckufCUolYSosB70Z44htPpGr2XyP16U2Z4rZf7pxfDHgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716533688; c=relaxed/simple;
	bh=FXNEM+DUSa35FNMF3Aor+hzRjZkWClvaPa5mDNaCuv8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WJZr/RoGb+LH1CleLjwPQOVvLyYaDu6KDmIoLthVB59aH3zNTwTEF3LwFhGJT3krtHrXbcA6ZrmnqBPE4bdPWSe1cBgXoeVa2Ym44eKgrB15js89pLTgWagetYayuZ/Veg2HyUI0Uf7Hm+4kIs+UDkTVhed2AUF86k345y1E56E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WwZSPA8l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=noNy67gP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WwZSPA8l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="noNy67gP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O10w0l031893;
	Fri, 24 May 2024 06:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Ofdiw973afdfLM9IT2BPkltABYakVfiX/iqXIU2GWRU=;
 b=WwZSPA8lroHmvD3GZnSboLuZ+hJ1W9WqBWFE5xfmT3377HZbEcOCnbHYuRTky6TzZ5v6
 0IfDUwJMqYn15nh5JyKfbaecTC3OmF+KQCNQW4DppmqHz/elXCBJHhhXhIgVQAEhOHpb
 rhifrC5//8z0v3qiPNNMrG7RjNHdKISyg3cYkK9AwoakqyUhWvYsabQoIm/5nouamU0E
 FJ5txa9pUKxQeKge81k7AjDQsRjvFcGPotciD4ybodcCB2yH02CMMDQ/3QwP5FymE8Tg
 Qhms+FhwK7yTYRhS4P7bRKF8vFhlN8WPVRs5DHLeOCUvYepvgxbqBeKs7EyPRmrj1pbw 8w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2kput-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:54:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O5OPk1002559;
	Fri, 24 May 2024 06:54:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsbhh7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTEMBl+lEsnOInoN+AJJm0ie5m0GvTGlAWtQfRdp0USFxziK73CMWXO3XbnQQ42q8qm7rPv963yTmGyUbsEBJMk+zjSnzKrTHXsK+nGvZpfIKJsosC4vqoDA4gDruQ1C1oIQq9fJx8Z4GWRuFvGptFiShgTj3HXWBZ5VN5dRxOUxSkqO+XIb87LITQSXww+ebfZnInh/f1qLGxZp5bEyjSfwm4WaeEYjtY4izgVjGVVfAtwlcvCSMZ4k6EDPj6CgnaVJchzcCABLWSGKiRk3IKLMYhanvDwoSLYqITMroZSflNmfRqRwIHKf3pJWRx3/pYUii29HuxDSzIHh3PA6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ofdiw973afdfLM9IT2BPkltABYakVfiX/iqXIU2GWRU=;
 b=J8PxKqAvOciDmwkw2WLDNTWqfndKgzBKva8Wg1ESMuffjeOjRa0VcB1YfUrR1LPJoiT0aWF0QKbzDtYjf3vqEUiF0HkEs35Ehmo9HLfnIzcnTNBC9MT6T6E8d8n3kyD0N8veyFm0PgDlVtLKRV8wbTSD7lGNB0wGuaeHCf12fP6Q2iz27+PDZez9YwyIY81MTd25lcxsJtzYkfU4ykwPcKCr6h6RxAVQRqkIucSGGz8u95rSJk1RjI+XwiDGvo7XpxAHS9r56GVt/sx8PYNeXdRqXsKSnFcNDO7mGuL70jN4yufpI+G8tsV31OYe7pt7bt5v2RIdNCzOCnVmB63kRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ofdiw973afdfLM9IT2BPkltABYakVfiX/iqXIU2GWRU=;
 b=noNy67gPGq2Br+6xbS1GMkrzZci2xHYIvE1jZjmMsS/AA6XkmHVRkQXFoGUeGMh0DFmUYFsBLbl1vSqY8pOXMfACyi2JAsX46vGX7EPcdxzFLZYRxRqEAbMPZeT9ymgmvM8ubfAGD8Eyux2RgN4Vlihf8ZpJEAvSwNquuH7Kb9Q=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB6201.namprd10.prod.outlook.com (2603:10b6:510:1f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 06:54:32 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 06:54:31 +0000
Message-ID: <043e2c4c-c1d4-497e-ac2e-a11c937ef09c@oracle.com>
Date: Fri, 24 May 2024 12:24:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240523130327.956341021@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: 3428030b-0261-4893-4345-08dc7bbe5d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?Yis5LzNKbnFpbFM5L29TMXJJTXVHYXJwSlZLLzNEZlN6K3ZPOWcyY1NuTXVV?=
 =?utf-8?B?TGdYMC9iY1RHUDJMZS9iZWd6cnV6ZG5tY1dPUWZCWWFBS1ZqbVJxdGJuU2VG?=
 =?utf-8?B?b1hwbnlrNk1XVXRkcU5uTlhOSUpFQ2FrTDBaMFlrMDFQRzdpdlA1aUxUekVK?=
 =?utf-8?B?czNERlJQREFRNDJ6TzYwOEFVTmZzeUZjVk91NFRISU4yb2dYNGV6Tzc0VU1E?=
 =?utf-8?B?VFRjVDhVcGFld2M5SndIbGJPaGtxMVhIMkNjbzRRSTExQ2dQaHNobTI4WjY1?=
 =?utf-8?B?d0JRekE5dnYzSWphbDVtNFZpZ1FWUjd1UWh2OEVPZ2x4dnRjNk10aEJnWkx4?=
 =?utf-8?B?b2VqOEdub2ovYm9zaEE0bEgreFoyVGIvQjdmZXFkLytxY1BDaGFQcFN1c1BR?=
 =?utf-8?B?QnhmUkdjcGRKcEZNdnhtNE9TSkFCU0dqL3pWc0NNVS9KRnhSOGRkcGdFcy9N?=
 =?utf-8?B?VFp0dVk2Z3haZmpyZy95bG5icnhLQzQ1OHBsemhhcEN4VVlLUXF5WTNsbTVI?=
 =?utf-8?B?bGkwM1ZmL0VuS3VYcnpocmdTMDIxMGVMWjRaekdpUS9lc0o5R2Ira3BRT2Jz?=
 =?utf-8?B?Nkx6d1lReDluTUcyK01Felp1RjI0cE9BNVhVZ1prZE50ZmJIcGduV0RRdGNP?=
 =?utf-8?B?SlM3bzN3TlJlYlN0bUxtd0VybWtqS09xQ3EyUzRHeloweThZM3RTS2Nlc292?=
 =?utf-8?B?cGp3NnhRODlFYks1bS9vc0NhWVZOakhhc0R1WW93Zm9QVkJ2aU1jWkdsbzBz?=
 =?utf-8?B?anZYbnFFQmVhWkEySjMrdU5lcExVMjgwWGI4dkNleXNVakYxaVNac0k1TkFn?=
 =?utf-8?B?UkFDblBtc2s0eHh2WEtWTUpuR0dUTUxQN1UxZ1B3Nk4wY3ZWZzR5RFkydHVC?=
 =?utf-8?B?SWp4TXRjM0ZpSDFNRFp3Wnovb2NKdzgvVnJrYk50RjJVeHpOcmg4N2JBMUJJ?=
 =?utf-8?B?MFV1VXFibFA1SW1aVHVPN3dXZ0M3WE5aSkZhM2VsZTVGN0JqVjlLKzh3YVVZ?=
 =?utf-8?B?ZUdBZDBsMDJYN1Jwa1ZaSHU5Q1pFMmwvUHB4cVgvQnJ2NXgwbEYydStRN25W?=
 =?utf-8?B?Sk9KOEVNWUpCVU9QQXdKR0ZDOEFBdkNsa1JlSzFWQUVHbndJSUxWNFRPbSta?=
 =?utf-8?B?RTFnZ1VkQlNEV2VDYk5tNEh4RkFXZGQrZkEwV0tGQ2hPR0lPa1BPaWpiQUJ1?=
 =?utf-8?B?YkxBZVArUHJHdWJlbk14RHpWb2xiNWNIbXVBanVSZE9iY2MvUUNTQ1NFQ1U3?=
 =?utf-8?B?Tlc1VjRYZGdPOXc4bXEzNXBBckYxQVpxVVVYUkdUN3hBM2FYbDQ2K2RqeGNm?=
 =?utf-8?B?M0tQQXNjWTJPSTR5TFYwcXpsS1cwNndZZDdPL3RHc2hhbGQwRkwzYmJNVmgr?=
 =?utf-8?B?bm5ITm1tM0NpNkROenFwRE9MN1V2QjJGM1Z3NTZIRGh1Y2oya1IycHZEbENw?=
 =?utf-8?B?MGFsV1lhaGx3SEpRL0M1STFXV0kxeDBid1VJdEFKRUpRWE1Tckh6T2NiNWlN?=
 =?utf-8?B?VXlIb1hzZnU5bVdDdVF6dkt2ekdURnhBdWJLSDJoWVhkY1JvdlROdGN6QU0r?=
 =?utf-8?B?RnpIOEowWExsMjZZbDJzZkNidzlOZkZDbFpMZThMWmdyMWlLZGJFSTdaaEdn?=
 =?utf-8?Q?He28yZYqmjnubVTgSX2iZiPp9jDaH/5gGdh9nLG5rOYI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Mml3cHlKdjQrZDRsdUMzWUdMRXM2dTlsT3J4RHVJcW5ISUxQdUUzZVlaRk5n?=
 =?utf-8?B?ek1HYU5PeHFncm9ySWM4bXZMZE5VNzZ2TFNnbVFQUURvaExKV2Zyc2J4NC9H?=
 =?utf-8?B?QWxlNFpudWFsMkp3d1pDcWdMRGo2RmtGbUhXSENqeDZZVWdMaDNybXhoOU80?=
 =?utf-8?B?QlVzbTd4YU9acy9TakdPOGtwT0VObS9pOUY1QmJVenhjdFFRUGU1V2I5NlJq?=
 =?utf-8?B?Q0VTYmM2N2ZsdDVSSmdIa1c1MDNJWWJLdWxERWJmanhTQzBJVVdDTGdycHkz?=
 =?utf-8?B?TnlDQmlMUkhZQkUwMXQyRlEzandzUjJVMmJPS1JncTVNWmk2b1dBd3Z1ci9s?=
 =?utf-8?B?SWMxcVNOM1BZUGZRelpyMVdkMUc5MUZkQkp5QjdBRVlNYU9QQWpESlhINDEr?=
 =?utf-8?B?U0J6T2tDcnBLSDBqVmg5Skw0b2p4aUlGd1k2dTZTYkd4S1RpdklPWld4ZVM3?=
 =?utf-8?B?bU9YN3pweHRTZFpaZ0g1c2Q5MG1Udk1SNk12SUpGUzZuUWduVWRJQkZOOWJn?=
 =?utf-8?B?M1diejJxRitEWXJGa2YzRVAvRkFKU3dvdUZhTEhFU0JNVnphOVFFU3BTYlN2?=
 =?utf-8?B?d09kblNNYXZybklwWWt4emhIUkdGbFlpUWlyUDFjRWVISS80QmdZckJvWjcr?=
 =?utf-8?B?dm5GaXlxaXdKd0JHaE9FTU1GMHhWWFB4S2ZsaCt6cXZIY2JOMWhKRUxYeHpx?=
 =?utf-8?B?RGs5c2ZFeFVHakRRT05tYW5Gd0FGckZUTUhUWXBhb1J1c2t5b0NlRTJCNU1k?=
 =?utf-8?B?bVE2alZ6RzBxSCtqcDZ5eStjVDZndnJEZlZiYmRkbG5UUTFCWk9aaU1CZ09t?=
 =?utf-8?B?L0hXTUx3UXFpZU1zMnJOMFlzSW9aOEVLK29sZUtTRDl5VnE2NmlZTWxtUnkv?=
 =?utf-8?B?OXB0ck5nWHZjQWpGOExmN1I0MTh4MXJpRDFCWTFRR3hYb0o5cWFPNGNUL3Br?=
 =?utf-8?B?QXc3VlZlK0t4MmNPZktDb2FGL2F6aVlVMGRFdGd0RnlBYzVHMFNWSkhFQVdH?=
 =?utf-8?B?czl4bVNUUGNLdnhtMTAyMEdQZXE1Mm1FRHMvckhqQWw4VFBIOVVGR1hnczNs?=
 =?utf-8?B?eExPZFpleEpZRnk4TmsrREZDbmlLYWtaaUpGQjVIYVpEWUNkVDZmdFluU0cr?=
 =?utf-8?B?RVErSHQ1US9jelFTVVRsU2QxOUZkL0QrcmgvRlJzZnZHanhicE4zU1c4NlBp?=
 =?utf-8?B?emtzbi9EdDJadVB3WUhnb0I4aVQwZk1QQW1UcUVVOHFqZDVGS01TOUxzQUV2?=
 =?utf-8?B?ZHoyc2p2Vm00anRWSi9GTk5qamJCYUtmMEJPWW9BcWdBNC9DU2E5cmg5eHFk?=
 =?utf-8?B?cHNNZHlnWmU4ZVdyZXN5dCthWFYrUUttV3dEOVlSZXg2a2dMUVJ2d3UrRDhD?=
 =?utf-8?B?VHhrZWtrbi9TS3VEeVZFc1RRUndMb1Bac3ZtRTY0ZTNqYk0zc044R1IwcmQr?=
 =?utf-8?B?YlYweUpXaHFldEhTR2VCMGNseHlyakNpVlpnZ3pYQjMrbUNTVTFCU0FRTG05?=
 =?utf-8?B?aVlyK1RFcFZ6M3Q3anVtemZLOTRRVXJEeG1jSndmSTQxVU1DeGdyVEY4WVll?=
 =?utf-8?B?SE05SlBXSTE1WnFzWHUwSEFKWTRNdkl1Nk53clRyeWNwb1o3aHZXdkdVeDNp?=
 =?utf-8?B?bnRXdXZpY2I3SkpIaGY0VUdybHVaempoV1NQeUJ3c295WmE2VjhTYWprcGhk?=
 =?utf-8?B?ZzBDekJEbVRncHQza2lucU1sM2x3N2RPZ1M0OVNKVFp3STV2Y2N0b2JCQVk2?=
 =?utf-8?B?WGlMWEtEbGMvdmFBSldTSytDM0F5eXVDMnFCRWZsczBHbmZnV1kyZ0JtbVVO?=
 =?utf-8?B?cjNuNzJEUzVzM2dtQ3BVMU5ldkV1Wnh3MzV0akRhM1lFT0lUcElPZVpKWlEw?=
 =?utf-8?B?eHpxWEhWOTcyMmxSR0NGa3ZSaGhGeVMvTHdDQlREMDB4c0h5aVA3MmJHNjRR?=
 =?utf-8?B?Q1VJQS9PZzZTUENLa3pHM2F1N3hpbGh5bGJpb0xWOXRZNDJLQWkwUDN0VkZt?=
 =?utf-8?B?OUFVSHpWMkE4eTlLRjR1THRJdFE2bFZSWHJ5bGpzV1YyQytQNzZHZVo5Q0tD?=
 =?utf-8?B?dm8yZnRiRytadkY4OXJPdVhyRW45L2xEaUV5QW9UdmNVR2FQeEFjVDJpeUVz?=
 =?utf-8?B?NWJWMlJFT3h2M1VZT25OVWJqQ2ExejdlQUhCb2VDeUp2MHJpYTZ2T1BVWGZs?=
 =?utf-8?Q?wv613OQfnon/W0dONY83X/g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VdGwUTfOVDq8GKCYQnmkKaASgynBDhV+LbYbScC6gDWtioYYS/XYaNi+8eV7G5MvfLCyA4LA3ygseCnIBIco4E0O3aCcaH3zotgpPjfGyyULFpZv55BdfNAfR2lEnFdVovUgRf0rNJ+hoeHoF0r+2UU2m+CE7Q0e1vIfq1zNxxxmwZmjl6yhvxX4WPX0l5E33tHdmc8zp1SvGit15V+b6sGefqgN/TnsHzaYzaDnBENLH2I3G7b/gUp/4ldn9OtdjLcNI5+wNwwhizofzaJlOBZG90k286Hx8VdmRDaJUoUIbZa2NgqNx3kYRsN1CH9x2YM+o97j9b+FzNVIc9rh63o8LHWusaz8aZo56Epyum9VvbHGnJmrrr45qkBYYIil+K4z7GHrupHb0JsPEe++O+UvSvIbS4sqbklRSkJ1tHGXkLPkqTqrikAjJhvYoV3uRueeD9liAXYFsJN4bdCprUkVmZDrXSNP99jz3/+TrsLg1VVsfxTH6vhtaCr0rkDDSAGT5c9/fr5LyuqQH+TsAZoJXB/LWEUdLbI+Vy/Gy6ANO5tswJq1khcUeJt7BpSd7bA3tjxGlSyZIDs39aMX7ou2vx3TEPCsm0ieYS8tRwY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3428030b-0261-4893-4345-08dc7bbe5d1a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 06:54:31.8401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eILnasUbxlSIWSsHgAx8MutUM0GQiOhBB0V1rAiLWJUiSo3EQneWDBQJR67QkB2TZNGJQYjAUQs1++lQYascHsL/Al1GRjvcbUW8cWSFsyOMxNS6jkV8PSEq2HZiXqcc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240047
X-Proofpoint-GUID: KJ_s9-c9_rL4jZ0Zq4iFR9dx1IEUzR_d
X-Proofpoint-ORIG-GUID: KJ_s9-c9_rL4jZ0Zq4iFR9dx1IEUzR_d

Hi Greg,

On 23/05/24 18:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
