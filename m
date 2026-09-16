Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C9345EC6
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544852; cv=fail; b=cp2KTWayjYNj6KgE2mityoMMYlh4m/fzBNqLwHh/iySKqa2eLKpWTif2GkN5kLyG9Z+i7mnXE7j1IjWIbCL8vu2vx4sYWVQE3xt0yexCyGWgEG6618A3Ks3X0oKo2IBl8REzQUazCXqCfENRkP8/EjwBVzuZyQT08PeoXmU3ILM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544852; c=relaxed/simple;
	bh=UCEcvtNNGevdGo2FdnVC5//qVyhiS/+vXT0r1VDAehU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sR5DdXPw6GA4sp0W9YLRb8LyZP8YmupSXmylC3a+rzp1qIbu4Tub3YNF78+7d8Pnx+5pFH07V2VBoWYbhtL9kYLkJBjUtIqO0C5AB2t9iN55jnGWwwBOgBQdMIAn3yVBVaeczbhI4Al/dXRNgW7F0LZsyey0tjCK7rm9EoDI0K4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g/ohVXtg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IqzQlC6H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g/ohVXtg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IqzQlC6H"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXlQd525741;
	Wed, 16 Sep 2026 07:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VqqQ70d65WT0l5mXAjcE3lW7YHiyuCb0dc4TwH9Qmu8=; b=
	g/ohVXtglz5kmE5mXFPaYTLY12WA1XF55tu8u3YHbBcNkz8KRstSrXJaa8FP/+cE
	RlDT0+hLqWNDkMcrHn0HOlkEYp96GlsW9ca6ZdOB2Hr9UzHPA5n2SaJ9KFdRaB8S
	pMeSVs6Tu26IIvXhzJbzlcnx8s0Po0m7G92IaIFX2aeW9how/Z2ukh/AI07+0glS
	iLM2XxRGzZWFZTBliGNYp32JlE40QZqPlCFtEg93wqlAVhg5KM1cimQdh4dBnvCI
	AqMBKdQVcmB0RFVKw9Y2/CYhQ3rt3JPXuAHO8MTLscfofVGGbmpGAHvBEE7DFmFr
	S4cuouz/Pkov1fCMS/7xHQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmy9rw2g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:47:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7iviK029652;
	Wed, 16 Sep 2026 07:47:15 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6au8r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:47:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkMDJBMcJk7uutVJxB6Pe96IoFULTifhADwJj1qKh4NShEOHc1hVFdCKfnBFtx+ITVQJIsL3S+DA/tjBM2jyy2xWXxUST6mbbiY8Ab03ax9pCz/cgfWsSHTSEIWYkWyqBtOu2ujDJl9vtNFBFHthcVj0Owh7YP9EKyENld9Y88EZXahZA89wOo4ljs63wPovmu2jRAm/FbLYnqkc2xmC+QCHCF/9tn1zIRYR0/ZsJXPB/jc8f3ZHMY+qUhWkuKclAteFMEPseF+6puJlh9Qcw5aUnE+c34I/EmtySZ3jY1hQ7BuP0ROxBCMEpOQ40cEpiIHCLv1Gd4hTE6+iAz/aVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqqQ70d65WT0l5mXAjcE3lW7YHiyuCb0dc4TwH9Qmu8=;
 b=eO3NPNd++p3lnwis2dawc0K58j+JL83952F0rp6d9PZBXGaNlSGenO6soQjZVfUIzkjE25COrvf6fpMPcwMLIWwZtSuW/FFcx6UItRvWdzCwV9/rvsqpUkMmz3oSgRO2jAlSQiX3nuyTqGjrXAWdKM8PseoZoMSFtZ2azVLVwdPCLO1Wkyr0SRiZ9HYF4VryJeZQ9fHnLqb5pxUrXG9YTNZRpW/09gvq8GlkDc0V2TRpsaay3HQDNV1uy2wOuFdR4XXT/1OKnx/XjR5meDYOxnqk86RDzg0AmKLmisbSVPCtUi11TcUgpG4GHghU/isUU8OLTK9D/DSgwN+Xqwy34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqqQ70d65WT0l5mXAjcE3lW7YHiyuCb0dc4TwH9Qmu8=;
 b=IqzQlC6Hdxwp+B6j5ptfX1nsjMAbfW1dxqoUjJSeYJE7EpdBe9hsXNZR0ZtcBu7oK9TfRs9FRM1ot7BUJvgNNsOZhPzivGrNoFYikDhaQ11L0/mOARwuJmBER6CsKvaje/dwJVyWpebDuXx/AePnGyxOGpzwDk39b1LmM4RZ9/Q=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:47:13 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:47:12 +0000
Message-ID: <50c77fd4-da9b-49cd-9ccf-b079087ef8dd@oracle.com>
Date: Wed, 16 Sep 2026 13:17:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0770/1376] arm64: dts: qcom: sm8350: Fix the PCIe
 iommu-map entries
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065624.700471886@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065624.700471886@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0003.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH0PR10MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: c990ee47-5b8f-43a3-5d29-08df13c6b82d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|3023799007|4143699003|10067099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	ox2fDoQxLMjAiCJWtO5R97fHnuyPy6NayQkQfgUFhrm0bL0Erzxd8kuprqQndV22fd+RKYkulq+Z5VOkapIyZ2snJqCqxP4D4HuyYW8S9OUA5Z+SNCtZ6GU6vJiHoewk2gTTXhSUp32RJdU2ZDKPqg+jZFS3gY4sV15OUuSJ3MyRCMAYgR+xhGxA21YBQ206W9ATxNXgMmFzgRAkbWiy6JIQHjr7efWKNgLnvQpDWkmxKMAEKyx5dI0T7gRaZjHKLtgqH5Z1QbEc6Z0aSkr4/bTegfXYSruW3nr3jTDm4Dds0gWfejxV0I4zQROwW0pmf/bRGEqLW8ZpWj3v0XZxDEtpn4wv2RVsfyHyeqRUhTIBjv01G5tmDKFrxt96A7Zt0Hv/pYNOAcxCesKwBXzpK70MaFPg62Pl7NKdkQkSZCeHl6476UbMDoBtwcdFbQi02ZYMt+nCapDxBOgcBHJ6NcX+GIflkdaawmbCyK6TUpJCwY2HU4Ex1SD6kZJE+XoIKGi96tpmDRX+XMpnP6ipSlfDHnCROwCdCZOCW+R4Vq48JgjFUrXtdHfKJ/UhqMzS3YWo650QRf8TrU80/pTuYGDmObxH9wTP6ie6vROLXEIvANrO6GjZuTxOXfnZzLVoGIQfyZIFoFB634a693grNwUAlOF3Y9t97mwbv/2d4/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(4143699003)(10067099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rm5aT25BVStURkY5TSs2QU92aGJLMTFzd2Y2VnlmR1dkK1VXcHFyWm5nVGlr?=
 =?utf-8?B?UmhFZVhhbjZpK0diU2w0U0ZaWnZFcS8xNzNnRDJTZklJYzJieXIrL3J5MUNB?=
 =?utf-8?B?dndlRW1EdWNzT21yWGFJUVlhTElyVms5Q2hGUDdwR0pKQ0k0TzFLZ3c5Uis1?=
 =?utf-8?B?WFpPc1JtSjV0WXRTdkVLVTIyYmRJUzUxVmtNdy96VFR2YmJ1bnhxL1FxdHh4?=
 =?utf-8?B?RWRIbndPcHp1SzdjWWdkTDBEajZPWHorOXByekY0U2VBeVBKSkRKSDllRDJt?=
 =?utf-8?B?MU91bDViVjh2U1BKUHo3WmZ4VS9NNXd3aGZZZXBieXNhcXpnQ2VNRnBHR29h?=
 =?utf-8?B?VWJzaWdQMmFCVlhEY0Qyc2J3ZlY4V1puUVQwVzBGQzdVeDUvY2tiMzlWWm9O?=
 =?utf-8?B?ZTljbTNsQ0VTSzgwbXR1b3prK2Mzb052Z2hpUG1jMGl3Mys2TEMyeStnclNx?=
 =?utf-8?B?NTZoUVhrQXFBaFphbUxoOXZVREVCNnBIVlNOOTVDSmMzdDZHM1pYNEJHNTQ0?=
 =?utf-8?B?MTJIMFBweG1FRFEwenFwcVpYd3d5UVlDcjFMNi9YUTlaakt1QWEzRE9uaVRa?=
 =?utf-8?B?cTc5eXBtU3FlbGR2WDgvRlBwQWJNVGRvRGEySGRWM1BVRzBKWFdtdDZvclpW?=
 =?utf-8?B?YlEvbytUelRPczVpMll1VUhUWm16aWVOY0Fyb0h3S014T0FIY3VFN003bWRR?=
 =?utf-8?B?L3FTWVZTYnFxc3FzUVhNUmtheTJTbEVHaGYvMEZOMDVsa0FPU1FNYjZsRTRQ?=
 =?utf-8?B?MFFZcGFjWGFLK1VuL2tZdHlXdmlwQVNjSVRmYnozdjI4SXJudTdXSzYrTk84?=
 =?utf-8?B?UExzVEx2U1gzZExjaXhaelV6MlAzSmpnbkR2RFBUaW12eWJ5bHpjS0VQanJv?=
 =?utf-8?B?UmVxcFlXWUxwUUptU2gyK1dYcDhjMEVvSEE2bUdEdndaVU5GRDBZREhZWW9F?=
 =?utf-8?B?QTZZMkdRZmJBY2RrMGtiL3NJeVp3ZENncjlHVmhrTEQ2TmZ4S3NtRGx4aFJm?=
 =?utf-8?B?VkFnYTNsL21vVWtjL1g2WXZ3b0g0KzUvUlhqcG5FOEhOTkNaYmFUZWpEbS9u?=
 =?utf-8?B?N1d4VUJvNTR2ZXJXL2lTd0ovRnFORzR6b2xXWDhDcTZocHVmdGdrMEhlMTlm?=
 =?utf-8?B?eTV0VHZQZ3BVeithMkNSU29ORTk1WVVSeHUwRk1hMmh3RGd6dTRFb25ueXNu?=
 =?utf-8?B?a1hzWjlwTnFuNTNMakg4amp2MDJsaDRZR3BmVkVUemhIYzJRMmYvNzE2TFJh?=
 =?utf-8?B?c1ZWTFZMdkoxUFl0SGdsUlZ3ZTlpdnZFSzllb2UybERNbHFhZkIvZlArQTRH?=
 =?utf-8?B?QlM0SGhSVVlINE9LWkxvUUwvam5RMHB3dDYvcEwzYVJBTHpSQmgzRW85djlt?=
 =?utf-8?B?R1paY3g0UnRYenY2QkUzbmRJdVFHTDF6Y29sRHhFYTdoNXlhSlkwd2Z6eFVQ?=
 =?utf-8?B?cHc3RHY0SkEvZmt4SFlhS1UwVzJyZksrVi9lbitpT1RiWDFGR1FmcVpvQ2hW?=
 =?utf-8?B?eTdWV2QyQUlpQUFaa2h2a3hmM3RxcEcybjdhMUF6czEwQTJsT0QvQ0hGd2ZN?=
 =?utf-8?B?cVYzcjg3SWl3OVVtSlMzWjdUenRwZUdVTkpnWW5XdTNtNldpeGR4YXZkZnN6?=
 =?utf-8?B?MTNNOVI0UklSZWx2RkE3T05pd25Ybi9DbGlUWnBGOE9XUFNUZ1p1bEErdURa?=
 =?utf-8?B?Qjk2bC85ak9lOXUvY0NkMzkvSURTUHVreEVJcmc5QkdMTHA3d1BkM0dZMlk4?=
 =?utf-8?B?US9zZVhjTVo2ZTZsRVF3Z2h0Y0J3SVdGSm10cEZEQUtTVGhMRThqcTJoMy9L?=
 =?utf-8?B?K253dVRhYVRGRjJkTHNVaGxsazVheTR5MFZHdW1oR2lROUZDNlBtZUU2WmNY?=
 =?utf-8?B?ckMyZjRqZ0VIbnJ6RFFYQVRWbGw5dk5CdWRheDVGYk9VZGo5YzFsVHpkdnlH?=
 =?utf-8?B?d3Bzd09YRUM1VHovdmQzc2xXaVJLNzlrcWxvVWhhYnF3Sy9Va2FpSFBJeXl2?=
 =?utf-8?B?ZmNXSDcrcmlhV1hXcGJkUnlGTDR3VEhCNnZqZndmb1dCaWhGVVBvTVIrNHNm?=
 =?utf-8?B?YlZmOFdMM2pGNFpvc09sV0VUWnN1c1YwTjZGbHB3Nkc4NkcvcDhvdnJmbWtI?=
 =?utf-8?B?b0hSeHJWN1dXNDBXY1EwNXlNQXlXbGJOWTljTVNhSHlGYjYzbUhadi9ma2pk?=
 =?utf-8?B?TzNHS3lVeW1aQW9YVFRRdWZWMi90Q2ZTYUtTMWMxSHdGTEh3THArZ2ZlbU1p?=
 =?utf-8?B?SE1TV3h1QXRMeXpRZkxMc0xwYkhUZnZxOFFTUHhsTitDcis5Z0VNU0ZNMDZV?=
 =?utf-8?B?emRUZmlJTkw3NUd0TnJNaVkwTWVvYUlKT1pmajB3NkQwQ1VMQ1VON0szQ0Vz?=
 =?utf-8?Q?h96L/Gn3Ga9nZ1uX/Z+JgcHtGhgMbllzhiXL+?=
X-Exchange-RoutingPolicyChecked:
	p27sxCVgqM6Fr2RTywh7F784qj8g9UuhOHn2SuP/Mn2m4xndW45K/NHSlTcMDKnnvfWnnkRcrWsOiVyeMFBq5F1rJ6+tiDdnZgOwQ2NgqwXBsB9OZh7QOe7TLaZnjeCDHtdFhG4nAWSTHiyLwC4hR8LbxPmE8/2bH6rb74Gsb4dcHaauFmgfnIVfl3beF733vT7T0o5i7ElAl5go0cVlXO00FL7iygDz6ZT+l5VvQg3y6B6b0ZPBUTumYFoXJMWHRgIwWxAhucb0cf8zUYAcVLjyKj8CmffpCKxp6827asstNvDq5a7inwuSTOQuiPU5nfRuD2EbImgtLGjHY6ybHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GplqU3Op+XimaXnnqADluPqhLIHnksIcbba0VaTbFIAdMImvNSbVt/n7sXb3bhrWFGGotDRLRsqgLOgEGGu0jmDcVgpuq8qePKDVbHt4dH4jzjpJYjSlNM6021tPdnUuiCsADDMWYC04KKxyEpWwTQ+4ouHp1CPju2FPGg+UzdhAZPA3LJmbinbcryCeiAH1NXlR6bVUksf8LYG7QHlhTVHgcxXxjPrXQsN7sI6sNN3jrYPGbCUB5P3ZjngUroWcbwFCfM50dif6B3juGu5VP5lM3EL1cHme62iKdTIqWrDNnvxtic8NmmLBv1NIQRl6RmxRp90uDNwFLSqxh5fgVagoZMfygCT/oxqPP/950T071bnna1ZlG0tQJJNlL7JDji4yLYUNbwcJBDztarfmQdfMo1WD9w2HUAqF/Is7XGrK2IhXD7niAsIXnsaaAxpOR1JMcx323+WNMZ2641JDT/EQ1zzRu51yt/YzAaSfnbhuC6+AJmlVXGUbl31W9Nqvk+gsKjDWFjvxQldRFdbXLhiiBJr8tETPWZJIoavYaNBaVo37eMaZpBTQXqjY5L5kv2uoqfHAb9iR90KE8bWDXztaqyA1HkLHPagAlCcYUns=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c990ee47-5b8f-43a3-5d29-08df13c6b82d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:47:12.7364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BH/37VZ6rvug2qXKz2QwdT+D6qmIIlBDsSNm+WJFMipQ2RqpY69lHer9+6Jv0NQANhH/TB4ecLyxbMFsivPifKTmQBJ8IS6X2iuSKC0jX9EDxDcGeLX9bMeTaNL3yJ+0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160100
X-Proofpoint-ORIG-GUID: hPBvo51x7holI8WYlhaAzIr3BabJi683
X-Authority-Analysis: v=2.4 cv=MuvHeGae c=1 sm=1 tr=0 ts=6aaa4984 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=f9xKEXB5QgJ7SJK1MQQA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwMSBTYWx0ZWRfX7ihZeDwHdG3x
 gvMllpQDxdbZ9f0dwTGzSgpD9q5Qy8dxDMkuSKhhXVdmXrrDLVTa2JFm/Nortcu5ljHDi/eX/m2
 8aA35DyXURBLd4sNaoDWkHoyfCWPvGSeNjn4xU5OzRTy8YvyMHXj
X-Proofpoint-GUID: hPBvo51x7holI8WYlhaAzIr3BabJi683
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwMSBTYWx0ZWRfXws5u6rTZEWm2
 H8wU5tmDFY62F+lAfnfG0E+vjvTpE61Jf+dxUMVbBJxaPHH7ru5jIxS6e5kMPmmA+12a5EcCYQq
 vM1oQaXgvE8ohb5W7hsJXcTqxU/xsTNEepV/X8VNXSPPsy5x2GDatpg9x/uHuLlLfHq7RorqKON
 6YanUlGrAHoOQfcio+7O/s7wF05LBtuIz+Q+vpYdHe8vv0K4V6RxAOwTp8h9ibFWcHqlYh+Jw8c
 d1h9RmPJGmKzJPLt6oopdR0KV1YRWXRjvlSi0HzTTWwNC36Pji3gFU7KUfZEe5G0738FEZWAchn
 5OSys6Co3PGQPCtgDLTOeFw3yf/7n4renlTuCtubzP0pwqaqO0Qk6OKLOX5CIwqNRzeXN8kByjL
 IU8EmYkmKL9JC080XpcTlDuigEL73NNriSE7EED9u+S/zbL2hRRXWeBpcuSlB0JAjyVrNTnPjIG
 Dxfxa8Gkv1JKHVl32OQ==



On 12/09/26 12:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> [ Upstream commit 80337ea3a154230621c0b4e3c831f5d81712ba18 ]
> 
> The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
> iommu-map entries specify only one cell for the SID, omitting the SID
> mask. This went unnoticed until the OF core started warning with commit
> ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):
> 
>    iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output
> 
> So fix the entries to match the provider's '#iommu-cells' property.
> 
> Fixes: 6daee40678a0 ("arm64: dts: qcom: sm8350: add PCIe devices")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-8-83405d37ba41@oss.qualcomm.com
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The SM8350 change creates two five-cell iommu-map records per
controller. The 6.12 OF parser still accepts only fixed four-cell
records, so each 40-byte property fails its 16-byte record-length check
before translation. PCI setup can then proceed without the expected
IOMMU attachment.

Upstream relies on ccb2fd725d411265df8f7ce12a66c226b16014e6 and its OF
API preparation. Since that broader parser series is absent, Maybe we 
should revert this isolated DTS backport and retaining the working 
legacy form.

Thoughts?


thnaks,
Harshit>   arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
> index 1870ec4176daa..6f175791de90d 100644
> --- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
> @@ -1571,8 +1571,8 @@ pcie0: pcie@1c00000 {
>   				      "aggre1",
>   				      "aggre0";
>   
> -			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
> -				    <0x100 &apps_smmu 0x1c01 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_0_BCR>;
>   			reset-names = "pci";
> @@ -1678,8 +1678,8 @@ pcie1: pcie@1c08000 {
>   				      "ddrss_sf_tbu",
>   				      "aggre1";
>   
> -			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
> -				    <0x100 &apps_smmu 0x1c81 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_1_BCR>;
>   			reset-names = "pci";

