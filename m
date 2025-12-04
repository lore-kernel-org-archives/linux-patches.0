Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A11E0DD8
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862279; cv=fail; b=f4LZyx1uajmluaJGK4YQ0HSPEKo9WSSRW5F310Cd6SSM0C9B8YdLDZa5bePJ9BbBk3aK62uuyC8mtiL80KzJBuW+eDltCGLPaE8WDbDi080tEfj9gKdEgh6pSKQKnBb8Ywwodds065/kvPlV8YvIR/ujAJ00uH3GSHizXdeocVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862279; c=relaxed/simple;
	bh=RizZ0z/yKmcnSsineq/7GYcYOnlYKLTyUS14qpdbECM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ruVKZzHVxECwtTYvZP7DHtAv3rM5ijd017ecvr9sDx5Cl0UYUkfI+nvbhliYTnqAZ2KoPYll8PoQUjd95Z0m/9+m3kExDW/ui9gyxjcNlqdig3KdH8GLOLaRU/1sDmBjmH7SGqZdUfbFkzcXtTKzjFrSx7bkFUM94a1hs0+qnmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d51i9jSP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xi3m3pP6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d51i9jSP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xi3m3pP6"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B4FE0PI1330173;
	Thu, 4 Dec 2025 15:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EWoxsoBFCEEhHnrKcdQ7wA+2cyJX3r/oyS0QW0J2VdM=; b=
	d51i9jSPN2tG3LAEZFnZ9HoTWaqliyGgmOszMVgcLwpkG7xyMjoyO36bAxBM3t/S
	B/56EKU7bb0uVnKD3CHtVn0zeQ26n0fPjhbfN9lw06GJoVMFQssgaFG5QPkzvhI2
	HDH13bWlHlnBn2dtEWgv84OF8hVOP6l737xvb+TrT2k1Mu7U1Tb8M986qcAqvv9X
	sRXXYVpU+jYwdkhhB0uTg8L3RNi5CWmhsP1UUwCMcYlw0AeRvbCN0GE6XrOeixVM
	ll9GWbFrDn/FlbrLtxKnwkKgMgFvcd/wPd1+23fEVJRljGSELWOCNo/7RBZK+ck4
	Vo3BG+yZzY0h/owkMjsiYQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrvc9v51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Dec 2025 15:30:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B4EUIhv011128;
	Thu, 4 Dec 2025 15:30:35 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010048.outbound.protection.outlook.com [52.101.61.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9p7h5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Dec 2025 15:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=krItnOr5XcQRz9i+XQ+SkQxATDuZnLNIyZRmYNKktkmU0f58NZ3JD1lKsZBmkahXC7AH+dnJoRPUFr3fozXA9U6Pw3HWBLhksU9yok/Cm+AucVsyy8YKdNLdCo0EpdOFuZx1mB4pNWV0Z1TPMNI5YkjMuTKXNaAhB1Xfawk4zVf1tqRYjm4nZvTkin3mpcU1tr+62FLPe65dxCgC/hRUcqO5Np+nEYy/B9ITt0eElZkvP0wiHAvGlSwyNVQ1tgPplURKk3CaOfomwhUpnzIlQyPihbedibqMkbjwoXMJ71RVq6fxkktFk0FmybwXfx4pMC+8xwYIGoofdtegqSMG7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWoxsoBFCEEhHnrKcdQ7wA+2cyJX3r/oyS0QW0J2VdM=;
 b=a9HI9SgUAAPJbLFpcqjbovked4o4fEyAOpE+GsarKspThn/TjgroAvBLk9AVSgLnAqNUPZEkF9tQiUPNswoEEjdKxGJomvg2Q4CpCSCrK2Zcu8MTKK9YTUDos1wFljYBc1ubwH/L/4ZKQqGbW9lGt7i9E5+3NvtdcAEkrAJ2mZGvZ9Ik96Ygo/ysabjgo5LmbPJ60oWArzqG3sY+mQj7odIz+nQGuh6UT2aWX72tTYn0CSflJHMLbFvt2cOA4sNMrYrHLn0YRztrJvg0rLj7DHxljz4g7BKWg74CVLwfupO5xFliAnPd6mkY614xBS41WoBIHbPXPdRkeN6Kb+XTFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWoxsoBFCEEhHnrKcdQ7wA+2cyJX3r/oyS0QW0J2VdM=;
 b=xi3m3pP6L+4jKtwGH5b+8SWrBE5nWjRupvkDvZ588Y5S2U91i1k7C+1xMBCDEAFLBGvcAePeofHy8PsNcDsDElW6tTp7ptZul+Zh5/XmdYfeNP3z7tXgTiZZ2WlnM/lxp3hay+gxbaKNYndtXx+yxCSiCXddXuY8WzHnqxMCNhA=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by CH3PR10MB7436.namprd10.prod.outlook.com (2603:10b6:610:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 15:30:27 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9366.012; Thu, 4 Dec 2025
 15:30:26 +0000
Message-ID: <9a47fa14-111c-4989-8e51-e784825af34f@oracle.com>
Date: Thu, 4 Dec 2025 21:00:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251203152343.285859633@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0542.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::7) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|CH3PR10MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 30483174-5eee-462a-c7a7-08de334a0c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGpQYTduTHdFSVFFWEVVYTlyRTVnRytheFI1amxCaldCUEoxdm9hU1h6ZVFl?=
 =?utf-8?B?MVZqQ3V4YlFuRlpwbGF1YVRHaUY4dDhmc3J4NWNNOUFXZlZzcENBOUlyMHp1?=
 =?utf-8?B?T1p3L1M0M2NUeVVTSzkxQllNSS94a01vZ0lWM0JSRjBZK2k4ZkRURWk0eHd3?=
 =?utf-8?B?cG5nRklCdnpyVVozMmI4ZE03VTQvSEk3TTJyRElXVG0rb1pOcGtXWEtwTEJn?=
 =?utf-8?B?MWt2bmtnL2VreGVhb1RLcElXTklRSFVISFJxVWtqTERtTnlZSk5Hb0lLbVdL?=
 =?utf-8?B?WGxnQjJlb1JhbHR4SFR2V2FHYWVBZkkyMXlacEhZV2lmWjN6Q3U5N1dPYlZY?=
 =?utf-8?B?UjNmZWZhUjYvNFhiRGt2aE1lTDRMZmtNa08yTkZNZWVkM2hKYUluN3RSZWxT?=
 =?utf-8?B?VGFyb0JpbHdxSXJ5L0Y2MjZjdE44ZE5jQ3g5bnlqT05WSDUxU1kvTFQraFNh?=
 =?utf-8?B?SjFYMm1zcm5zZjc5R09QWHJOR1VkbXpXbDYrWktqVGlJTnNoRlN1M1NLVXZo?=
 =?utf-8?B?QzV4cWNGNXpaRG5lNmlqaTM3cnlWR09WcTNYNDJveGlkcFRNZ3Q3Q2Z0L09k?=
 =?utf-8?B?czFoMFp0dlkwcVFaS2FFcW1PUFFPOTJnbmNjYTlZOGRVUlhoNjdEYVk0Q0h0?=
 =?utf-8?B?TkVJU2pZUU1IODdUUHlKTGVxcFc4a3lKa25hTmIrY1l4YnI5eEFkV3M4MWM1?=
 =?utf-8?B?SFBXbXdoaTdhN3ZuSktBaFFya3NobTI2MkRPbEtmQ0RaNUFJbmVBMk1LdlpW?=
 =?utf-8?B?dTM2OTdDN25hQVdsNkhzLzlCa3Y4T0hPWTdFQU9hempPNkxUeVFIR1RsMWI2?=
 =?utf-8?B?M1FSNElUd1FNYThBZ01wVHE3dmNFNHM1ckhEeVdvS3JheWlYTGxNUGlBYVJ2?=
 =?utf-8?B?dzd1UTMyd20ySTZ4TThaeDVXbTlINk5ZRlpyTmZmSHdqU05TUi9UTjNHNHBu?=
 =?utf-8?B?UzE5K3ltdFFENEtwNjI0NWxudVgyTFhnQUd5cVJkRjF1Szd2MnBxQk9jaUxR?=
 =?utf-8?B?bXkxTmsxTWEyTmFYeEJXcWc3c2NramtpZHAvZ2liR1NwVi9NMnBPSGkwckRN?=
 =?utf-8?B?WUZGQ1pjMVRqM3RRanFuaitvT3IybHZlU0d1NDAvL1VLV25wazVhNWNzbTB4?=
 =?utf-8?B?M1IzRjRRd1czYUwrK3h0ZHdOQXpJbEhFb1BQWWN4SDRlYm9sdm80RVVzZkE3?=
 =?utf-8?B?QVZjb1NCMkxZNWhzZFZhRGd1R1U5MlJtbU5wajJNb3I2ZC93UWE4UEtva29a?=
 =?utf-8?B?YUc0bUo5b0ZrbHpsQWdYYlpUT1JTSXJ2R0RrZjZyV2xINDloWXUrYzBTamdr?=
 =?utf-8?B?UWFrRE1mVEVFZVJoV2VhVFJiUGViTEUvSThsc3Y1SXJ5U2dsclM3b1F4bXU1?=
 =?utf-8?B?VVNuVmJZODk1UDhYUW1hSS85ZzZVeDFNbDZaT2RPK0hIcFA0VVVkeDhSU0hK?=
 =?utf-8?B?SWo3Nno5aTdDZStCSWI1ZldZbUZocytjM3RDOFVQYWkra3FRbmo3UmtObndJ?=
 =?utf-8?B?cDU0T094d3A5aE9MeHhLMmpZOVZXb0xxbE4ybXBOV0hBQVJSZ2o3NU93MTZQ?=
 =?utf-8?B?bFpPSElIZ3J0TlN2SEVscStDR1NCdXA0NlRxeHVIdjRMb1dqdDNYSnBEU2hL?=
 =?utf-8?B?RWlZY2NyTFprb1ZBRzZuZ081VEs3QWphVXRLazZMV1pMbVFSdFJrVkxoeG5h?=
 =?utf-8?B?NUl1eko0ZkY2S3E3L0JXR2V1dmFEa3AzZGJsNWNEMUE4TC9pRzBGTXdQd0JL?=
 =?utf-8?B?U2IzMlVHd0ptTUtTVkdKcyt0K2xLQlRleUpuTmwrb1ZVaDhhR0JaSUxUYUMy?=
 =?utf-8?B?dmZvUG1XRUszcUFINFN2aEZ3R1BlZyt3MGtCeEpXV2ZEc29lYnp3WldhOWkv?=
 =?utf-8?B?UnI5aUFta1lKVnpzdDI5d3Vwa0x4T1dvZldENkhmTTRHbTRwV1pocHRFT3I1?=
 =?utf-8?Q?pUIT4jaEFe/RilGR3R93wFYcoAzeiG4E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXdDd3U4UlY0SWV5dFB3Z2lIcGU0eW1za3NVVGowdXdNQVN1azU1RkdlVDJF?=
 =?utf-8?B?VTZuN3R2dWV2SnE0Ums0SlJBOCtZTFg1c1NIUmdDVTAyKzV4U0grREd6YmE1?=
 =?utf-8?B?YjhhWGlWTVAxZ1BsenRjZFBVU0ppZWQzOVNqUzNxS25CenpBRG03YVhtZlU0?=
 =?utf-8?B?NXdoaGowbks0ZXFOOHNsQ2FCMUdwaEZ0ck1mWWhsVUlVdm9GdWdjZFlId29E?=
 =?utf-8?B?K1RrTm10YldrUU5HYjdSeVdWRnhYR1NOTjVwSGYzbHF0R0s2c2xOSEphOTNr?=
 =?utf-8?B?Snl0U1FnRWp0RGF0emNQa1dVSktvTTZ3TU96OHRVWVBJUWdYM2xSeUMzUUl0?=
 =?utf-8?B?SktmTUgxUjQvQytPQ0tYQnNWc3ZPdTZ2R3FHNHhpTXZrSWNwb0o1TWo1M1Ix?=
 =?utf-8?B?a2dZSW9LOCthZ2xHcEl2TUpmYnJBRGFhS0pIOUFybzROR1NhSWVOZmNlL0p4?=
 =?utf-8?B?ZmZwYjdYelAybE9mb2RrYnZ2M1NzSVJnZmpRV2RLUGJvbmpjY3RlRFd2cHNt?=
 =?utf-8?B?dldFNmdjczdzSnhBTHo2OHBxYWRidkV4aitzdEJidDh6ZG1NeTBJV3hxbVJH?=
 =?utf-8?B?L29LRVAyZFhFY3dlV2N1Ry9LS0tER3JOVFltK01LMFF5RzlaeUU0Zzd1cERU?=
 =?utf-8?B?a3hBRW5kWndqM2lmQmpkMUFmcHZKM1BvaGtFeVBzZmpVblJ2Q3R6Z04rWWxC?=
 =?utf-8?B?TVM2aHB3b283YnJRbk5RZ01Xc1JwNUMrMmhWTEtET0doYjNkUk51TStwaW9n?=
 =?utf-8?B?Wm15U2xha1ZOeUxIZU1PVEpVOWdNLzVHRG9OczBVZXhXOHE5TzdGTjl1VzZE?=
 =?utf-8?B?N3BKR0RFUUE3cGhaaUZvZWV4SEpVWTh6S3ArVVI0NTV3dkM4UzUvb1hLUkI2?=
 =?utf-8?B?ZDVpc1c0QjNhSE1HMC9ETDFqQUNUenF4SE5LM0Z1dEJZRHA4d0NSU1U3SUlQ?=
 =?utf-8?B?WDQ3YmhTV2hxZGNvWmY1c1EyT3FJbVY5WDlveWdlY09nTlRzeHRhVHArYy82?=
 =?utf-8?B?UHBBMzMwUXZOVENnNkJvbVlCOENpYTFxTVJqZU5BM2hSOXhPWnNMVVJoamww?=
 =?utf-8?B?U0lWajhUZHJSZkNlVjJ1eDNkWHRneUpxaHN6eW10ejVSZU40YWlrbFdDOUFr?=
 =?utf-8?B?QSsvcitZUGhiMWJId2pyYXpHWk9OaVM5Z0p1TFpxb0h5eTErS3puWlRHKzh4?=
 =?utf-8?B?NVhyWS9ib2Zkd0gwWS9LS1ZYTnNod3gwZUlsVDh6ZUxCRGgwSU9YUGRKRVpG?=
 =?utf-8?B?TnhPSldpbFJZSVpMZWZUTjVMUDBKTHBNYnk0cDZYZVdMOVFaQ1FYNkRRRlZP?=
 =?utf-8?B?MEExWmN1b2F5aVkveHVVd2lEeTlnb0tIdEIzOHU0cThibEFVemVYT0RqRTMv?=
 =?utf-8?B?NGF6bGpXUGxvbVFDM2Nsd2ZDU3Urdk1IaTdMQzNlZGo2ZC80RnRuajNRNTJJ?=
 =?utf-8?B?VXJnQmdEckwvTVhYR0NkVThSMWlZSmtYenM2VFB4ck54TDFLQUxJZ0VLN0FT?=
 =?utf-8?B?clUrUjkwekVjR2V6S3BoZlZyeGgxbFp4KzYwajd2ZE5zTHFHZHc1UkFodktW?=
 =?utf-8?B?Rkw4aTFJZVJxeFhXVEtDYXJzckdpeEtzOGZhYnM1Tmt1K3BvRy93RnYvaFBq?=
 =?utf-8?B?S1JueW9YMzBjUlZETGtMaENXZVYrcXU2aHFsRzk0VWRZWVZTQ2FjV3NkU0po?=
 =?utf-8?B?UWhQbXlVQ3pXZzY0OURqOG85V2JHcG9EbmJBaEk1Z1pxTVpoY0N0R2pwekNq?=
 =?utf-8?B?VklnUnNHWkJmd3A2VGhIKzRzcEZJc3RJSXdsMW1jYVdmN1lVTWp6SVl5TXFW?=
 =?utf-8?B?Z2E5RmRvRU9BSlBXSDdwNitYdTRXUUZ1Szc3OGxEYVhZSHhHUGhNZGgyM2o2?=
 =?utf-8?B?aFZFNnl2NjFUWU9QbnhQVC8yeVhNVDBDMmczNGY3VFQrMzhqTEtSZnhDY0ps?=
 =?utf-8?B?VStRRHFoSjVmaEhTeU5LdkIyMkFlZTZPOHF5UExVMkVnOEREWkl3RTZSbkIx?=
 =?utf-8?B?d04wZXE0cWlsOTlFbEFtN2JzdFU1aFFaVm41aWFaUlVhK29lbWppUXl6YWpt?=
 =?utf-8?B?N0NwK2dPWklWRFVZeXRlajlCcGhqSHJRVDZ1dmdzRjcyUHZRWGFUVXc3MDZP?=
 =?utf-8?B?VGdSK3hRYWMvT2N0QWcrWjlUWWJ3NmVhZFZPZm50Ni8wY0JJemtEVVJwYjkv?=
 =?utf-8?Q?jsc/Jv/bs0URFnJQfDQUotY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7wixi4GFrxauq1GPI/Emp/9x7V4S7hyuFttnrht01ZPIiOBWis9ksHHuEdR1TJ2Fn3QfT8M1Z/sV4q9XZH23z/FHVIDCHb/NXjEWNjK7JXNbz2CAyuVb3Z+RBAGKe0xZ9oCJAIHpBRIRIizl6zkE8p0xawo7ZbKdpc8DbMgYByGylSyC7a6fBd+stq3kHJmUQNnNKsp663UjpVTfsMhL24i6NA+Hxr1IaNpoI2FIucopixkP8V+8ORI0Mw/zcVmHjXu8YhGA/q/2skXFfHgW55B8zxqjTYwA7Mvmbmhk/6r6FADYUkei8WWJEdJcr+SwC4H2Qbm1/EY+HGIiC7QZiHIoCAucCeGy+c2QUlzOtaYsAKI4QbS1e8FrzxJhoN0C8pgI687TVLY3fKnf6YvUrMpo6E7/yERCg3JtsRyY8BqNp128upSvFdyoe7a56Pe07qtkpxMmId0eC6C5/IHxR479ADzVfXKPJoS9mcSk9bE1wm/5BjAquFIBgKWhzD7qUaEL9/vI5b5ToKz9Esux/tH2y9I9GacSBUmGqcNC2Pd34yFN5bs4LqD+rwl6wIFRPj2TtoRH4B5YhFTqGPp3ayJ/1pY20aGpnEOMQ7Ee33o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30483174-5eee-462a-c7a7-08de334a0c3d
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 15:30:26.0724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/LGdD5OobjTi/dNIHhSFCuPgCBOOHVnR9/jPvf97GId08oc/QkrVtH5Fx9bA7fiv2ycI290ZIFDSbNP6RzihV35SkA2tElJcRYm3x9fVrtGJIBRdKE2t6P5gih3WuNn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512040125
X-Authority-Analysis: v=2.4 cv=ZeYQ98VA c=1 sm=1 tr=0 ts=6931a91b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=s35FHx8Tt2q5zFxga6sA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyNiBTYWx0ZWRfX3WX+F3hrjpBK
 qNHWQfw/whRhcnWAm/OqndG8O2bjBMGVHHBqL8EYwttfQzIIEUrgrEVlL3bRSuyRDW8gz8NXnOh
 UJUPGR5wZNmp+zf8QyQjgT7Y9lAAS6pqwn3Q83R7M5RRFbf7W5hKM2QpsLlTclWyzZ8+1aiF0pG
 v197IsJBf7OWwCNYkvv391MM/g9Q2XvP2l7zyRrRKTbTnH98XA3RZbcshTlVhFGMoQ3L6RM9k5X
 FlTnPvHxLW5sAUaJlP08L5rMpIC1X2OGS7rm4pvAPfTow21e9+QAx6jDIukSdgLcxrHd8aZeVOU
 nVDTjI91TQsqjupqVElkNoA4LDn0wrvmOunBVTPR+8NN/IYB+E3XVGqUYFh5lWe566pnrUeyyWj
 FNFwXF8FatHFpXe9hPEmJjFX/WImVh+mZSWFtjKZdWju97QKw8g=
X-Proofpoint-ORIG-GUID: -o_RyAGTf_4sQwiqo6KB_11era63rH-3
X-Proofpoint-GUID: -o_RyAGTf_4sQwiqo6KB_11era63rH-3

Hi Greg,


On 03/12/25 20:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

