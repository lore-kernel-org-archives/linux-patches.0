Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC217BA1
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735650232; cv=fail; b=eCir9Iec/132f9+Ysz/nZoah7p7vk30+VgL70wyl5U8svpzhQiTIldxwQj7aMWaRaXL/SdrZXXjJpklsJ8ggqg3JseqgHX2w1v9veV/RR3M8ATZNoI9TT1vqUTPnS85H6GDtcIfCNrQDoq9cETluW+tR/sE/Rwxdd4dRXb1lHww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735650232; c=relaxed/simple;
	bh=Pti7kcatq1IZioCoIEjcz7/hXBylKLZM2Qza5j8UEMY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qUl4++CNS3X3b4vsBbPJngWlo+ZMjyWhpCgsWKc9ohvXHdxidjIZHqg2Wc19NP40xDp/zueAGwnipg03iHGaX8brDYMvqZ/cOItvhnELddNvj44vZe3VSdY5bbT8hHbM5Pa8bf8i0yLkb08QlLwf5O1dElsng+eAuWwgB7DJfuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XGe4FWTk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KdsT8oc1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XGe4FWTk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KdsT8oc1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BVAN8gP018006;
	Tue, 31 Dec 2024 13:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=nCZaKNucWpltzsgl/NQGV6B6Lqnt3us2aEtT8koBQmU=; b=
	XGe4FWTkprkhQcjWaM6ZWlyUG4X24v2hFiEOJWbOfpjUBuHOfmpneFAPmnJJCMuz
	sK4Zwytgypb5KWwgmX2Sa4eFDshEIz4ibn1u9RiLAHDX3uk17FSb1i7Poy0HEv9T
	87qRq+HwBCMWvDBhtgNS4np2m/xfzYs1uCtzJ4xCD3ao6+6Ex3OTy+ip0Z7eL6MR
	7xlEe97/rJNrlpxoQmh3L5Td50b0PqV+q2HPfFEHiKvTI/0ZTUuhMxoTTZaqaNMa
	spIqPSSLaQdaVHEjvnUWY3kw+fqIgbutd04H8bjhMZDwIgyeHyIkPOPw8rAB6bmd
	e7g+gQdzg47usPb84+9SIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9vt39s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Dec 2024 13:03:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BVCBxE7012282;
	Tue, 31 Dec 2024 13:03:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s7633s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Dec 2024 13:03:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=By71Kl6Kco5BvjG3F2GqtFWaOSs0isODz1CgjLkN7NzzBB2YGMRfleLi65TQ9crsPDggui7/JH1PnVbd3ICd9xPG9jWOZLvMGQ2Ywj9dIS14at7LI9uYT1dnNX9qWv+16GAVG0CSp2yUhyB/+9AGSMf9DoBXPtND349FjY8tn5SXWC/m9hbCJfYNHIinQs6PE9UYH/5ozWNfah6oQ5JpvdHjx3UpZejtJiWvRVkkFdXfxwoK01RtnyXVp8CPMskZZIzMayY0dx3rOYYRXLBiNgr8AFok4/TqM/FZ76SRvVPdsTWxeZTzs6nIvioEBuNLGLMSd8mxLyOYVmdKCv00ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCZaKNucWpltzsgl/NQGV6B6Lqnt3us2aEtT8koBQmU=;
 b=HcvM8dcod+DET61OiS3WilZl+9einn+jVE+5rKJ6b0ttoVRFtprJO34n5EC0UaZEaoQuH95KsE9Gse8W4BoUEQquOoAE35bHXcIVrenSuSx8V2X7uyZkOGJMJ6MsPNZcRCUkVOAq2cPhk/VQPhVvsqwrmuyzrVkzQJVqBH4G+1HnYpsa8jDiJSvNqVPQ74htd64F6dp6rL4+JhPmbGu4S/WYvUD+Nxk0iXbbIyigFnikdNrklZZt8xj2tAv4nX7HuY94zfMj+xUj+t2rC+sGB9A/NH82QJ16JSFH0aTvbiN/8GyZZBuR/s5NxuNj+OJu34DMriblMmreKmxaI+4gxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCZaKNucWpltzsgl/NQGV6B6Lqnt3us2aEtT8koBQmU=;
 b=KdsT8oc1NA9vMKYa9nLUSG8IVNqUewECUhNinp+SaHhYX6RkyXy6z3b7Mg8ktaLUWV3LfTgR6gA+AIgI+rMYm7oX2ypmnQSXCLOKG4zgAvuhmVayyoC+UbiQNqttkF6iO2Pus3vyXYtTTR+EiIP7ZsW5GPc2eXqV3TnvRoRoCss=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by CH3PR10MB7460.namprd10.prod.outlook.com (2603:10b6:610:15e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Tue, 31 Dec
 2024 13:03:05 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8293.000; Tue, 31 Dec 2024
 13:03:05 +0000
Message-ID: <00b7e482-9340-4dac-9b8a-39e328cf0678@oracle.com>
Date: Tue, 31 Dec 2024 18:32:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20241230154218.044787220@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|CH3PR10MB7460:EE_
X-MS-Office365-Filtering-Correlation-Id: d67554ac-3315-4a5e-f4f3-08dd299b76de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXBhMXdCNEczcjcvcnQxemF1cGErWFU5RENsZlg4WW5jQ2xYcVVTWCtOZXFM?=
 =?utf-8?B?ZjFGNzZNbk50QVA4cFV1b01ZQnZJNjhFOHEyKzdXYmN5WUJ6eFJ1bjFVMnk0?=
 =?utf-8?B?ZytVdG83aXhZeDlJNUgyNGxUZk9mK1NCZll3eVpWTmYzNlRoVG9TZ294R0Fk?=
 =?utf-8?B?cUQ1b2pRclhpZk1KZitGNXArbUZLeUxBSFUyZmRUUjdUWjhBbnBuWE11ekhZ?=
 =?utf-8?B?OWpZRUxpdkVmUzFUZURZL1RYc3NyeVBMUzI4a29tVS9rNnZqeUt6VGRPeHNT?=
 =?utf-8?B?ZWtMVzBKc1o1cFcyQnIxTHFYT3dLVVlYb2VSbU9zK1JWOGMreUxmRGlQRW9C?=
 =?utf-8?B?cFN1S0cwZS83NHlFcnV6c0pOTXRjdmw0VDQ4N201NVhnL0ZBS1k0TFM0alJV?=
 =?utf-8?B?WTE3UjhoV3JPV09odVVZVUF0ckRDZWlKbTdFdHFkOFNaNmdVNTdnWC9obmxM?=
 =?utf-8?B?N2xUMEFoelFKQUdFdW9jVkIxZmpZdFFOZnlmY1l3QVdnZ2hhNDMrVDlWcEpW?=
 =?utf-8?B?WFl3SGJ2UlRRcCsxQzJrYUQ3UFNrUmFxb2UzMkg5bFdnck94MTJZTU4xMkNR?=
 =?utf-8?B?NmxBUzBZRnltU1NpUzlpeGM1ekpJek9ybkNXVmY3cXR2RmVsRmRydStpcXhE?=
 =?utf-8?B?dGFpUnQrWjYrSmhOc0pCL0VuNTRxUmZrSFNYMHZ4OERjOEtabngzUHZsUExQ?=
 =?utf-8?B?dDF6Y2VpZ0F2SkMwZEFzUmljQ1RqRndYdU9PaWhsUWp3ZFRvSlU4aWROR3o4?=
 =?utf-8?B?Q2M3UnpkVzJaNzN0MkhnVEQ1bExyS0Nmd0NaMlROY2R5RGlRYkpGTHVab1lC?=
 =?utf-8?B?d0p0NzN3TmhRejVxRDhlakoyWUxva28vMUFuQjVyWi9hUDVnTTN4bDJNTlow?=
 =?utf-8?B?YkdDcThnTDdTT0NaenBYSkdRc3FjdTc0RllzNGxHZXdTYUZHN2dLR1RoeXJ0?=
 =?utf-8?B?Q2o4SEZHdDlmNitZdDVDQTkxSzFkVVZVN0pERDF6VEg2dlY3d0ZFRWtjcWFB?=
 =?utf-8?B?Q012SlEwaGJrdkRPR1B3M2FnVEdpSUl4ZEM5WTk4czRBSHJDTmNLRWc0Y3pu?=
 =?utf-8?B?R2t4VytJcHdDcVk1RzA4TElvSk9KdVhxTHRlVUpaTmkxTGxoUC9JcHcyK2tj?=
 =?utf-8?B?WGZhOVVGMlFPTTE4cFExZjF6ZFlCMXFEN0hsdEJVZEJvVnpVRk1HMGRvNU0y?=
 =?utf-8?B?MUhmZkJtaXNFWmdjMk40cGlzcmhXVTlxVEF1Qk5kRDE0ZDc4U1NDSTg3dm5D?=
 =?utf-8?B?aHI1aE5lWEJtZTVaTStVZlZDN3p6NHhWMDFkY0JlY0pINXRwT2orcCtPQmtV?=
 =?utf-8?B?UG9zcGliV0JNbjM5YnM5WHRyWFRtN1hOVHJNdVZtTUpsTEwreUdZa1hmVEs3?=
 =?utf-8?B?UjhxbGR1bzdRUUNnZWlETHFWRWhadkE1Yk1iajluVDRyRHpHRUdZRk1tWk4w?=
 =?utf-8?B?UmtyaWxxbEFZdHhsN2J6N1NjZit6TWo0V3R5NHg0QXBTaFBMT2ZBUVhnV1FP?=
 =?utf-8?B?bHVGeGVGMmVXRUJZVTlwbHJzTkcwMldDS1c2WGk0Y2JKSldoRmVscGFGTGly?=
 =?utf-8?B?SDN3M2FpUUVqYUw5OE9YTHNwYzh5OXluRVgxNE1NV0hvS3lHc3c0SVBoemNi?=
 =?utf-8?B?TWsyNmo5VWEyMWdQNTk2eHRBc0dleFN6N1l6NEljS1FGTHFMRjNnNzgvUk5B?=
 =?utf-8?B?bm1oQ1I0dTBTWGV1dEFyMkNIamtXdmI3THpxRGpUempmcTRXSkdWNUpiUlRU?=
 =?utf-8?B?TkF3dmVzQnFwRHQ0a2dNdGt2eDlYZjR1VCtzc3FjZDhJcWMrZFdBWnMzeEpB?=
 =?utf-8?B?YnhTUDk0RVBaMTN2M0kyWkE2YkNHMnpzTWMyVjFHMFIwV0dOV2lCblBrNTY1?=
 =?utf-8?Q?L77xsyHPaWw70?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXBHTjVPY2sxeWRjL1RadVVQd0ZiVzhuTEFjWXdNVksraXY4SHZvcHJGY2dn?=
 =?utf-8?B?MlpFSzdwTStaKy9YMzRpK2JDWTdNMUVjZVgyMVZRbzlsNVRpVjY4aG53QWJS?=
 =?utf-8?B?cVRSMGRiQWxPZGh0Vkp6cU9hei9IeFFOWnYvYUZHazJJcGw3SFEybnZQTTg3?=
 =?utf-8?B?TWh4QzdDUTRaK0dWcHBxYVNSWC95ZTUwRlFtVFFYNVhyMFYwamVBVnpwZnVs?=
 =?utf-8?B?Z0V4K292UnlxL25mcTFRZUwwOTJkejFFcEt6blBVSHkyTFVWV3RKOXFzRTcr?=
 =?utf-8?B?dU53cmFsSkRrVERDcnNwd1R6TmdQUE5Bc3c4V1M2WmN5bk5mVzl4bnIrOE5U?=
 =?utf-8?B?dldNQTlGK0ZxbEVYUFdsMTNaQW1aWEFHMFpwd2tRL3BIVkhUTTl5YVUwVFFS?=
 =?utf-8?B?U0p3Mko3NThDc2ZnblZBSm9ZdHl3cUpmMzJXUlRTdXZHck9tV2pOQU5hY2NB?=
 =?utf-8?B?NWk1ekMraG1ZZUlCOEMyak93YUdQTzVzWksyU1B3ZmNGd3MrMGg0KzZHdmZz?=
 =?utf-8?B?elpJKzBUSUt3WmdLY3ZHRHpGcnFqc0hjTTRjckFqek1KT0V3QURta0FRTG9l?=
 =?utf-8?B?Tlo0UStwdkhzeUpmN1JSbGRaSzFiSnBYaG5pVVBuRWgrUnRKaXIwaDZsMmVi?=
 =?utf-8?B?bi9MSW92dVFqbzFwWWhhTUhQeGdMSHQ3ZzFublRLZloyT2tkT1hodThCQkYw?=
 =?utf-8?B?OUJWODQ2SFNZbXZyTHBBVm13MmM3QlNFdE5RdEFUYkppK3FKdUxyY01hVXh4?=
 =?utf-8?B?UlNsN3lLVnR6WFB0dUVjdUtab2tMZnduYUQvZDJrVXJxaWtWUEh1NlBzcjQz?=
 =?utf-8?B?bFZkaWFRN2xmcUtRTGdEMUtOVVIwaHVZTEQvekZLUzdCaTlxR3BlM1dBYmpT?=
 =?utf-8?B?YmxPY0VBRHhYQUN3RjdVcllxUHA1WDZSeDhnQ2VxMFQ2Z0p5VGVTWHlLS00r?=
 =?utf-8?B?SGFMbXRpTmpHTTRtWTB3TWVVVGRRa21SNk9wNjYxYzE0cTliN3JHRlZUZ25o?=
 =?utf-8?B?VVZUU0ljVFdNR1c4cFd0K1lURm83RHo3OWtKdEcvZ0ZSQitGTHhYcW5EWlJR?=
 =?utf-8?B?U0tCTGo2b1VMbDhyeWsrL1Nnc2VWcENZcXpUUmsybzJWK1dTdTlNMU52RUpl?=
 =?utf-8?B?S2I3RjBBR0lXQzh2SmwwcU9WTzhwUlI1ek1tejBrN3U1cVBieVMreGxUMEJC?=
 =?utf-8?B?dGN0VVorOVF3K3ZPMXRNRmlaRUNYU1E1ZlpFcmRaZExFSDJhM3JNY3phdFps?=
 =?utf-8?B?Wmx5T3dsYisrdEZlMHYzaWFyVXdlTnJUeDh2MmNTNEpRaHZsUGFqZEFENFFa?=
 =?utf-8?B?Z0lXSXhzaEo2M3I4dTNhOExzNGJBMWdqQ3JjQVFNVE0xQXdSNmFQdzZ1TlB0?=
 =?utf-8?B?ZXM5SlJ3QS9PWnh6UHNMN3hqbTl5bnhmSmZoT1Z4cVN0dVIycGhhbVdxUm5U?=
 =?utf-8?B?Y0l4clcwYWpqSEJKanNudWVuUmlYbkVHU2s5WjFSM0pEWlAvbEJmbktZTWM0?=
 =?utf-8?B?cUpSVkl3NzJYYXZ5d3gzejdUWE81Q3N6TW53TjF4QndTamlwbmlzckhnbGd2?=
 =?utf-8?B?aHZ3QVRGcmM0L0YxYXFzd0RoaTloTHBWenVWOTRhWjduRFZmNUZBbzFGR0ps?=
 =?utf-8?B?djM4WXJ2MEtpb2tLTWVzZ2NJMFV1VGtVeGlTRGN0MmZMSUE2RFc2MDJKeFNj?=
 =?utf-8?B?SThZTDVaWllkUnp2Y1JlWDRwcHVSZ3dZQkZGaHlrVCtwZ1VxSWJmc2tyMUNp?=
 =?utf-8?B?ekdjMHFDSml6bElBZkxhTVgwUWtxRnZSUzdKc1FvcUNRajdkaGp0S1Ywczg4?=
 =?utf-8?B?Z2pjNW9FTEpJUzdYUWxLcUJiVUdVUzhBbGVVb1VTZ25DRngvbVRDdUUyN1hF?=
 =?utf-8?B?R1FHcnBJdkYreTdkOFJiMUVZc2szR21lcGQyQXRMOWhyQVFXZGhzblVza3pm?=
 =?utf-8?B?VVBOOXAwWEpOZjNZUHlXSXBkUzNaeEErNDlHMlhwYmN6N0szdS9sYVR5dEo3?=
 =?utf-8?B?OWg5QlRCOENMUnVDMmRIUlhWb3FDc0NLQWxoWmZWalF6bkc5eTRCL1FOdUN5?=
 =?utf-8?B?bFlsaWRFcnNpbWlya1BZekNNMVcvUTVMTmU3Ym9UU0N5MjlsRXlydmp4ZVc0?=
 =?utf-8?B?bGdyekJ1dGpCMndIY0IxbUUxUEQ4VnJLYjhxOW5ha2cxT3BaTE0yYmE5a2Fi?=
 =?utf-8?Q?lS428+SzeC4SpPI5gQXYrEI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EwbENQ0GaC6rqKg3ltTcOe3cyCORrXKgC49SQsjkJ+Si6V0AtQV/xJZS6N6XrpjLAmIbV2GFBOagnqj0vVZRj8+qshizPqLGsZs0bU8yb015rFpWxxWxWuEWUo+2EkfVoZCkcZB0zUE8UrOjwTfxR9/S6+cwj00eWhOZAejIycV0bIkouBaIsUAatt51sc4GRxPbBWjMO+f+VVeKnjzWpOyUq17iOv+FMEuD3UwgL1EyTxc/SiRy0QY+9O2lSnn5aQT0MGWMvGEKbvHuUtrUoORRef8yqatLp1zDhbRHempKbUIij+XIDxGT8sOI57gmPynrRHD8/s7IpwysdpXBnaPD4I5ExJTNlEhoSAQIIrXe259/8AJAKBXEgyMc+2hfsCAIrbaosSJr4NjxBopYzGgAHyq0tc2/I89BDRzbEZGZ/IuxcSAVimZvHYzfz3r9q3z3RCV0g0f1tfKbrevojZVW6kHppqayk2M3nzdkVrHuZ66o+TUN5jPCzIvT5IPC2BB4qwCltjpO2LG3nDfz+gk0/byIkbcPT5l9D/LyjaCQ595PgV/7+h7qW04g1ExmuD0XZJi+oLCmjtuGuZWK1bb9O79lGA4opfxcZRD83ZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67554ac-3315-4a5e-f4f3-08dd299b76de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2024 13:03:05.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EpV460A8RMT9rjWVaLAkIeo39Izq7jrwv9IZoefD5gpPheYRNrzOFAhFaJHP2+GVVVdzjfGDXO8fGSTrb36iuQie+IFukmzRLuuNxw3JmYdzBd3x36eqCm25c+TAJLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7460
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-31_05,2024-12-24_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412310111
X-Proofpoint-GUID: v1rnxNLptKvXJ7Vf0AwYYNBqZ6GtG8aD
X-Proofpoint-ORIG-GUID: v1rnxNLptKvXJ7Vf0AwYYNBqZ6GtG8aD

Hi Greg,

On 30/12/24 21:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
