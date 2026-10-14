Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79BA3CAA53
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014295; cv=fail; b=W1Sic3IY2rIVsXOuU8J9a0yb3h6vMbkGhpm73NOY+KvoppSOhOuFO3cMlB2yxXyhuUKywSK68i7DZsJ0H6UnDlcjwNU5k2bfKAk9WUhGQ0dA/HWxmOuV4UHLvnOyqVeAYZiuGAA6mKR9oOk8Qdb2a+rWl0KZ+fxPbML15uJVZzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014295; c=relaxed/simple;
	bh=uugJtpYhm0t1v/o9TKduDXAPIs7vhlITxAs7cFcfrHs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mSn5d3+AOrveb9x5M5zawXF/KyBAHmWXOFPFfdu+JY+F6+lKpyod2SQFmDLimLvauFNX/mWY7MFPcBaWFs4IFm64TfvbZSIDTCV6lgyycB9RGkY6H8QMXgVu67+N2pFdNXQiA3UmyTXw1bNGRXfaVr2D6Piz32VivYibw5AQe/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rvcj1uzf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f/LZJUqh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rvcj1uzf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f/LZJUqh"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELg1f03438070;
	Wed, 14 Oct 2026 21:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MxJjXnWqSHiUvTYCoDpZSZPIYIjMh4Ay1wSFSWbWSX0=; b=
	Rvcj1uzf93XXISg2JE2O4wF/QJF4tIjxO4IC2u/aCfCpzeFBD9SeZH8jYuOV6HVK
	jh0IGG3LhlGIzvwX3Kg5E4mo/mr2Qsen6UQ574adeI73zDTiKtEDrXJAHe6aXffh
	VKyBFpuVxuQg8jyGNnYHBq7T5uP0xZGSfzMJv3LnvfUa/oiAi3aw4NlE8UIhO0IL
	8GgkDfDixLTaSI9IVpKYFD5B41jHuULpIWq5uO33JezC3E8Oe/l2If6hLLjpTCGC
	/bzIl9Yg8ZL+damtvF/W+6q/ybkrk4gLb0NCiRvXAPyx3cWIlU9o5jBwRwCzj5hw
	zSibMmWb1kKvCO1EqnOa2w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demq2k7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:44:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELahYY022793;
	Wed, 14 Oct 2026 21:44:47 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btb6g3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:44:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W3SA7YHOoQyz8/Di0Evhe/VGofYuF7f3oImcUkr3NOaBxM8x0vXYQ9DlXO1SLtcnSLqNQLO8eMG/jC63B9x51UhAlB7uW3Bkw5KkbCf/TnJ53sFsjs5j5B/nAvoW342mVqMNAndrAkcH3RCIYo22HQDDcpTmxLK9PbrTCRs2WhQfD5wI3/OfjJNccxD1DqcAMi/WQLYXivsUXzZHzAdkzSMqKX+z0hwTdh6Ms2XgBholN0/5V5OrsA0Z2H1PbsOkgWX2VVnxq394EcqPg13ck0t+1vMQUgI/he6IER3H5OIY0zUWp9UKEDTXknGQDoExScuMMz2B9dFCFSaKtUDzpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxJjXnWqSHiUvTYCoDpZSZPIYIjMh4Ay1wSFSWbWSX0=;
 b=F8ZHmm5BGf2GppGK5HRDcsGGLEh9RCEbl2colhH1HjsTfH1y6s91jOCVtplCu39/ONapD9Q2V7JZxCHhUjFRviZGUoyBJTFoijhNh7srVIYe6m96Z5whHybH5VH5AxdVBCPRxenDfb9EBrjfaWX46NgIKuKJDa+yo2ngZeT5esbngIjUyDwXyHldEDQUDl2+OJeP1Xmf3M8qknDS5BQMpeRuVID9YwDTzYhKDMXoPA0ofFYiVb1Rb9Urg9clwGzX50r1Z89Dm+xYDYd2igs4pTrUUrY4MyLyxtLYr/ki1pOw8sL2oBWVzvxwgn861187/lTIJQp/PL59qG6wAUnj0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxJjXnWqSHiUvTYCoDpZSZPIYIjMh4Ay1wSFSWbWSX0=;
 b=f/LZJUqhtdo8hcOWGOwpXomZDfFptBvPgKKEv+HbFKUguM7qB0u23k9trCbHhN2Xor67tFHNCMbXGJA6e148GKcPZ5YE2tcktghouSDvvGTOEgTswaVL1H4Wx+b/jZQFYPqp9vzJzeOL+8KKVdp12cYUIX9IuxKJq7b27Z4CfHA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MN0PR10MB5933.namprd10.prod.outlook.com (2603:10b6:208:3cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 14 Oct
 2026 21:44:43 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:44:43 +0000
Message-ID: <fafcf450-8f11-4898-bc36-23233831d4f1@oracle.com>
Date: Thu, 15 Oct 2026 03:14:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 459/497] tee: optee: fix kernel-doc warnings
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Rodrigo Zaiden <rodrigoffzz@gmail.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112918.776447090@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112918.776447090@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0001.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MN0PR10MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ca57a2-cee2-4140-3c57-08df2a3c5b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|56012099006|5023799004|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	L3GvMKvOZyQqORxik+w/aE/CT+ONBbW50Ixi5jebhuVtqn5zW+PpFtySrFNrLEF1a+9ZfBuHhOWFm62oaqgx4OnhlsqxwPelih+P4Is1XRArf+vn4dxS73ue8dSPMnBGhCYhmYrfCawC0AyK5ZYuwZQOHU4M+ParVqhjOuwPYJCPHYbqd/BT1xNTv5XaBHLiil8QFesb+MUeb366AbwIW4R7ljRdChPCHMsILsIRl9/qWHaHf091FkCy1UrRuZiXVx6sDjiOhdiqFKIDa+In5xjiTRfvcO7S0p3VV5K1N3RB1RsmfjqG33TseQW5qLhZW4XW3AR4Z5Gw5rCY4j0LsnWoaUobXg0JPKe0Ne1bh9LFnJIAhqguceIDLoxsj5GQMCTBkdvMBkGaXPtkdtHkwrM62RMsOC+VLO4ieJ13tfO7w8KsrTzetx5aW89AEDNVVDkqcfPQ+0v8BRzrbT/VFSYiP21X6dJq97hbCl0A3IEYeGe02ENwU2ms8/l4LK+Tegpo88DK2p3brVJXSlGxmwAW68j7RcxaxD3dryazaObdXBQxMVmeAVnIBACLlh+EPswxCcjPk4M4hs59GGMcF9Ir73vH/wQhUT660DzoaP5JRndCfy5+0q+Rlgh+fKZfF65+TLoz5OMfd+pVyVnPczberVazqOEfkDKB/mzPa5U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFFza1dudnVGK0w4aGNMOTM4bmdYdWFjU0NGQlVkTThqRFg0MzdxZGhjMzBI?=
 =?utf-8?B?RDRsRm9hYlZNVVFYQUpwcm85VkNpQTdxRi9RdVZWWGQ1Yks5dU51VzRyRVpD?=
 =?utf-8?B?dS9FK24rWW1VY3JXY1Zwc2JpUS9ZNE00azNBaW9veVhEcWkza2FMNEVtMWtk?=
 =?utf-8?B?SksraHliZHRpVUVSdmcxMWw3blNGRVl6OHg2cE9paTg1L2hsLzlhcE5PVUhq?=
 =?utf-8?B?aFVTcCszTm1xamtSeWV3SHRoZEh3TkFRRDA5cUZiV1pWUU82QTY5ZHlqYmpZ?=
 =?utf-8?B?aURYNzhnTkt4LzlLczE5elUxS1h4bHJES2FNTFcrUldwZjIvUlRyM1RqaUFO?=
 =?utf-8?B?V3ptamVubVk2c0VnYzNaa2Y4RjZrY01tZGdrNjgrTEVZZGZBd0VaUzl5VWdI?=
 =?utf-8?B?eGloK3RIc2FXakxGRHp4a2RLZWJTWDl2WjEvZVhTQjJTR21hRFQraG16VGNI?=
 =?utf-8?B?c2R2Y3NCUjhuMFNwQTF0Z2tiRXFxbGRlMVh2eE9WK3pKVUJJRmUzTzNGTStI?=
 =?utf-8?B?NEY2OVZnY2NiQzc2R1lPeEZBeS9vdWs3QzhjYTBDZGtxeXUxMVZzSXZVbjU4?=
 =?utf-8?B?R3VsTFZmdjVydlBQWW11REZQbWgxMEVrNTNVNGVTV1NRVU81WnBKNVVMaUFp?=
 =?utf-8?B?ZVhaaGtPcmVKSGFPMmR5dndWRDR3YWoxbzVsSWN0Mms1bndtSllPbC91Qy90?=
 =?utf-8?B?eXVoclF4dlo1Um5rN01pSW5lRTdldmpjK0l3ckd1cDd1OTNWVy9iNG5CSEpO?=
 =?utf-8?B?M1YvMlZMOUUyYTBKNDYzd2hITkU2MFZ2d3FaT20zMytyVCswYmZaeHZNZWds?=
 =?utf-8?B?bjdmdnV0T0d2V0lxWjN0YXVBZkdzUUEzS2Y4L1ZoaHVzR0k3dW1NZGF2SkNR?=
 =?utf-8?B?bUhicU5DTGFzNmZmMlpkd2ZQUWhPV0JLVzVWS1ZSTHY4WEZhVkFxUWhEMC9P?=
 =?utf-8?B?ZTJYdlJWdEFIR2cwd056QlUvUVBlZTJJWXpYMXlIOHVicUpzTEpERHpmYUx0?=
 =?utf-8?B?bFdhRXJ3alNTRDZKNXlBRXFOd3c2aGErSDIzYTRoUG9KV1greE9lQnNlL1NR?=
 =?utf-8?B?YTFHRmhUdm9pZHA3SDNteVZ0M3dWdEEveHhkeWpqU3lYREliZEhROFdEelZW?=
 =?utf-8?B?RnNtbnRlNCtxWUdvVitmNjNlQUJwRjdFM1M4cE9kMWRRVzE0Vk1kOWM1ZFdI?=
 =?utf-8?B?T29xMy96ZXJRMld4aVRCNHE1a2tPWWZsNFhOYVFXU1JXRVZZR1dhSlV0S2pL?=
 =?utf-8?B?ZDZRUXhLdWZzTndaQkJ6RjV2TDZKcmVKcEh1eStraktoOWkwbU1zSUM5VDFj?=
 =?utf-8?B?SlFGdTRzN2JkejI1TGpZZWVQZGdhcWI1aGIwVXQxOHdGTkQvWjJXV2lUUFhQ?=
 =?utf-8?B?bDBYWFlIaFZPeUVXZjhIYTJsV3VjYkd0bjVBQXRzL2l3c3Y1UVRQVWhrSko5?=
 =?utf-8?B?dHRGZEtnVVJObndsa244YzM0STZ1UGpkSHhLZng2QWlrREpZYkNjM1A3SHo2?=
 =?utf-8?B?cndPUERtd2N6NHJkR0l3Q1Z2ZkhaaFlFdlQxdlhUakVLVVp2RkRqWTBRVFVy?=
 =?utf-8?B?S1ZVY0RNTVV5UzFKdTZuSUFrNTF4V2NrRXBJOWNQUjVkY3lXZlBVTFdMRGZW?=
 =?utf-8?B?Y0VMYzZmZTE5MEM2QkFaYmJ0NVVCcmlOMURFUXg4T0lHZnY1RytqLzBMQzNT?=
 =?utf-8?B?RDljd29wN1RQdkpFTFhiVnRGZXVmUUdzSWtaSURydHJXM0YxNHpTMVluQmo3?=
 =?utf-8?B?NEdyZlIvME9tNFBzUlFGR3NyemhxY0ZtbGJPTmp5dXFDRUE4NmdNWExSQWd2?=
 =?utf-8?B?bnFPQVg3RkREb0ZYZjdmTzdkeTl6am5VTkpIQUlmck5QRnc2V0d3K2JoZm5F?=
 =?utf-8?B?UEZnZ0xEaWpjWEYrS3J6R1hDdFBlOGR4SjduM3U3dHV0QWNqdG1MaHJkQTRv?=
 =?utf-8?B?RzRVa0V2NGNDWnBZSWx6NVlRU3FMMmROMXRTdll0MjFVSFIyKzVHWEV2b0dj?=
 =?utf-8?B?b2g5K2ZXbjBmeGV2WHBoSzRJclhGbERxOGJHdDZlYW5zUlEwaXlwNi90TXJs?=
 =?utf-8?B?Z3Y5b1NzMWp6RExySzZlTWNkUWY3S0NTUklzdWZsMlVJcE1QbmZ4ZW5wZVFj?=
 =?utf-8?B?WnYyS2FhYmYwYlNCeGdVbTV1MmtoVHllNDNmNm1sT2d1ZEpZWnFVZ0JKZGJo?=
 =?utf-8?B?VDdlSUhJdS9hZktnYk92amhqTjJEMnBkSXpUWitIRDBRQWEzNmVLT1J2WDhS?=
 =?utf-8?B?cE1wRUU5L1ZDaE16THdyWWptTVdWN1RwRjYrZmZSRVBGWUZOQmlzOHRTZ2c4?=
 =?utf-8?B?MjZtQ2JNWUE1TTBjWWNQZ2JyamgzSWdYZUk3MEZzbmNuK0xlWWhxbUlzc0FM?=
 =?utf-8?Q?OF2qgXKptHClWcEnrXKNZx99MYivHJ/frX1U5?=
X-Exchange-RoutingPolicyChecked:
	M9Swd3pbr0NSigOc9BDDS9h6Pk6bDcfYdSyow2zXDZY92FzJ/2zOSmJR6AGh2WEOG+jcQPW80p1CakaEfEfwe7MoqH2r5LufKPqeKMai2E+uUTC0mX9pidK2tngsAxZU+eSbjgw1rBKjvEfGyAXsSPgIMI3cgdB+g8amy+0lBPzkVTru/WWJKwXxaMUJn+NsDMhSsN0TEXg0idk5B8dghzGuaqDZHu70m3Dic028m7IrGpM5GEFC4zeIBpF1MhmXrcopyS0IzvapezRNQ3YSd85P1P71HU4v5pFQHuXUtWezcxsQNssJo80RlFGb5y567a6Y2lzChx/5NDCp+VCBRg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jFqMHLuHb5S8fkSCBous3ScWj5DEZqkZ5EJrWqIa8WARz7lUcV60Kz4sHETkTmlVD3uq16loGtzz1kp4piu9QioL42a//es9SaI+DXSrIjv/ZpfHhDs3bgjlvMb105HVdArSkxfmjQREGu/uH6o1ZpS9c+BImDjNugFFxKv40cSivzZVx5gOwq2uRt7otK2YRZ1ZcYY82isWmaUb/6JljfG4EvMhR0/3QqXnklb2971ThUfb+NlGxRyVE07A+9xU2bhtY0E1UV4LSL+9j6rUmDmB7XMEeIIpn2FsAPx/OJn7KvfNoh5Lo2/BENQxz5h2lkv+57YwIdpisEUarBVrjrspQ6Gq/8duhQ+HLYDVawbv1KdcYv2C/9DNu3dS57xiZ2UZ5RmXZmpFZq0pM0PJED7eJyEUyNi2v3A+Sob5N4LpQabkhX7Me9K+jDkhNQ9CAWuyf7lwj/tRxvJZJMD4QL9AtbxfZiJ/SVtOhCA6ST8Xp0+eI9BQj5o8G3/p/GpNxRSqcnjfmqHKcLebmyNqvXxLT3wKWhkUtYiMgeg2oUMyvj1l7BGCubte89CDXsmlVtnOxnSkBdiVpqTFGkGLVEg/MYLclaCaTfH0lxHjkUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ca57a2-cee2-4140-3c57-08df2a3c5b98
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:44:43.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JNw7EXukQfwSi8Q5GGec24ZDYD1bhQ6w+PXPSB4QTB+bUbN2eAUoDMt/Fsqp9Q9Q/4/zqTBsWPMJ6Msje/SIy+bWYbYTAUrmagi7x6Vej47kJHA9TG0o3ycDY5TxMOa4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140086
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acff7d0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=pGLkceISAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=S91f5UK_8NVTBnn3CtgA:9
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: J173yhDWgOytYGAnCgSnzd9Ik8uMG8e8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfX2qmPu85i0Sdf
 uQwKR4NMcwSKnvfg9oZC8+xs4NvYfPY6CDJFfLBfERdew9sTelQxwz+bEgNCeCv0GRo7+HJ3sZI
 LnrYzGpW/Xe0sA8cG/H7XlkB3aADws9gkuzVWHLGPI27SejV6HUg
X-Proofpoint-ORIG-GUID: J173yhDWgOytYGAnCgSnzd9Ik8uMG8e8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfX4SocLOVJiw+Y
 HbHcwSU5bgl0gudrLe33iLab2qpW7k6yXW0Howhpm+OKsjX01KDkgzJuKzIJ1cv4c0oVJaiP06c
 lJtD3hcgSaI86glXvOIriYWk92xSmdvWJYltNTgFXjhPTWkmfNRoeTqcmnQ7EPlOA8IEQfOu1rK
 Iy2mAsiE5Gl6NeF/Fzyl5cxyHWFVuevd9tnbeDKb1nKWs2uVAdEkNhBukzzx7dBkPC2E51fITcw
 0r+ivdcTeaP3c2fk1G8KalD2m491iNxTEfXhTloG/fM5ds5EYwTDIRwGagyABkwYtIp0wAz3RIa
 U53kOggDaIJK48mL05KRALNX8clf1O9WVS0QWL6Gl3DoUzV+dZME6k2vfXHAAH3+gSwoo6q10QL
 l/MnYhIc7MsGYxXwBzkhUgZb+L9nHDHlUAFteQ2a+wst7uYT/dVdTWFa34/eUIyqkw8gAFnGsZd
 o1VZ5uYwGwH8Ksd6BKA==

Hi Greg/Sasha,

On 13/10/26 5:10 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rodrigo Zaiden <rodrigoffzz@gmail.com>
> 
> [ Upstream commit 3faa6774ffc5973af39ac9c4f1fe93aa92ec9407 ]
> 
> Fix kernel-doc issues in optee_private.h and optee_msg.h:
> 
> - Add missing documentation for struct members: optee_msg_param_value,
>    optee_msg_param, optee_msg_arg, optee, and optee_ffa;
> - Ensure member descriptions follow the order of declaration;
> - Use consistent formatting (lowercase descriptions and ':' after
>    member names);
> - Adjust indentation for better alignment;
> 
> This resolves kernel-doc warnings such as missing member descriptions
> and incorrect prototype documentation.
> No functional changes.
> 
> Signed-off-by: Rodrigo Zaiden <rodrigoffzz@gmail.com>
> Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> Stable-dep-of: 3c0d2f1f431c ("tee: optee: ffa: support shared memory offsets on large-page kernels")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/tee/optee/optee_msg.h     |  50 +++++++------
>   drivers/tee/optee/optee_private.h | 120 ++++++++++++++++--------------
>   2 files changed, 92 insertions(+), 78 deletions(-)
> 



An AI-assisted review of rc1 patch 459, 4ae9550850d4, flagged a
kernel-doc mismatch. I checked the 6.12.y and reproduced the warning.

drivers/tee/optee/optee_private.h, struct optee:

Downstream 4a8beb0f1e36 documents a member absent from the struct:

      * @revision: OP-TEE OS revision
      */
     struct optee {
         /* ... */
         struct work_struct rpmb_scan_bus_work;
     };

Upstream 3faa6774ffc5 has the corresponding member:

         struct work_struct rpmb_scan_bus_work;
         struct optee_revision revision;
     };

The added description produces "Excess struct member 'revision'
description in 'optee'"; -Werror makes the check fail. The parent
has other warnings but not this one, and the upstream header passes
the same parser. Maybe we should not worry about this but FYI. One 
option is to get this fixed inplace in the patch.

thanks,
Harshit> diff --git a/drivers/tee/optee/optee_msg.h 
b/drivers/tee/optee/optee_msg.h
> index 838e1d4a22f04..7d9b12e71c035 100644
> --- a/drivers/tee/optee/optee_msg.h
> +++ b/drivers/tee/optee/optee_msg.h
> @@ -103,9 +103,9 @@
>   
>   /**
>    * struct optee_msg_param_tmem - temporary memory reference parameter
> - * @buf_ptr:	Address of the buffer
> - * @size:	Size of the buffer
> - * @shm_ref:	Temporary shared memory reference, pointer to a struct tee_shm
> + * @buf_ptr:	address of the buffer
> + * @size:	size of the buffer
> + * @shm_ref:	temporary shared memory reference, pointer to a struct tee_shm
>    *
>    * Secure and normal world communicates pointers as physical address
>    * instead of the virtual address. This is because secure and normal world
> @@ -122,9 +122,9 @@ struct optee_msg_param_tmem {
>   
>   /**
>    * struct optee_msg_param_rmem - registered memory reference parameter
> - * @offs:	Offset into shared memory reference
> - * @size:	Size of the buffer
> - * @shm_ref:	Shared memory reference, pointer to a struct tee_shm
> + * @offs:	offset into shared memory reference
> + * @size:	size of the buffer
> + * @shm_ref:	shared memory reference, pointer to a struct tee_shm
>    */
>   struct optee_msg_param_rmem {
>   	u64 offs;
> @@ -134,12 +134,12 @@ struct optee_msg_param_rmem {
>   
>   /**
>    * struct optee_msg_param_fmem - FF-A memory reference parameter
> - * @offs_lower:	   Lower bits of offset into shared memory reference
> - * @offs_upper:	   Upper bits of offset into shared memory reference
> - * @internal_offs: Internal offset into the first page of shared memory
> - *		   reference
> - * @size:	   Size of the buffer
> - * @global_id:	   Global identifier of the shared memory
> + * @offs_low:		lower bits of offset into shared memory reference
> + * @offs_high:		higher bits of offset into shared memory reference
> + * @internal_offs:	internal offset into the first page of shared memory
> + *			reference
> + * @size:		size of the buffer
> + * @global_id:		global identifier of the shared memory
>    */
>   struct optee_msg_param_fmem {
>   	u32 offs_low;
> @@ -151,6 +151,9 @@ struct optee_msg_param_fmem {
>   
>   /**
>    * struct optee_msg_param_value - opaque value parameter
> + * @a: first opaque value
> + * @b: second opaque value
> + * @c: third opaque value
>    *
>    * Value parameters are passed unchecked between normal and secure world.
>    */
> @@ -168,6 +171,7 @@ struct optee_msg_param_value {
>    * @fmem:	parameter by FF-A registered memory reference
>    * @value:	parameter by opaque value
>    * @octets:	parameter by octet string
> + * @u:		union holding OP-TEE msg parameter
>    *
>    * @attr & OPTEE_MSG_ATTR_TYPE_MASK indicates if tmem, rmem or value is used in
>    * the union. OPTEE_MSG_ATTR_TYPE_VALUE_* indicates value or octets,
> @@ -189,16 +193,18 @@ struct optee_msg_param {
>   
>   /**
>    * struct optee_msg_arg - call argument
> - * @cmd: Command, one of OPTEE_MSG_CMD_* or OPTEE_MSG_RPC_CMD_*
> - * @func: Trusted Application function, specific to the Trusted Application,
> - *	     used if cmd == OPTEE_MSG_CMD_INVOKE_COMMAND
> - * @session: In parameter for all OPTEE_MSG_CMD_* except
> - *	     OPTEE_MSG_CMD_OPEN_SESSION where it's an output parameter instead
> - * @cancel_id: Cancellation id, a unique value to identify this request
> - * @ret: return value
> - * @ret_origin: origin of the return value
> - * @num_params: number of parameters supplied to the OS Command
> - * @params: the parameters supplied to the OS Command
> + * @cmd:	command, one of OPTEE_MSG_CMD_* or OPTEE_MSG_RPC_CMD_*
> + * @func:	Trusted Application function, specific to the Trusted
> + *		Application, used if cmd == OPTEE_MSG_CMD_INVOKE_COMMAND
> + * @session:	in parameter for all OPTEE_MSG_CMD_* except
> + *		OPTEE_MSG_CMD_OPEN_SESSION where it's an output parameter
> + *		instead
> + * @cancel_id:	cancellation id, a unique value to identify this request
> + * @pad:	padding for alignment
> + * @ret:	return value
> + * @ret_origin:	origin of the return value
> + * @num_params:	number of parameters supplied to the OS Command
> + * @params:	the parameters supplied to the OS Command
>    *
>    * All normal calls to Trusted OS uses this struct. If cmd requires further
>    * information than what these fields hold it can be passed as a parameter
> diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
> index 9526087f0e680..cea5deab6155d 100644
> --- a/drivers/tee/optee/optee_private.h
> +++ b/drivers/tee/optee/optee_private.h
> @@ -47,11 +47,11 @@ typedef void (optee_invoke_fn)(unsigned long, unsigned long, unsigned long,
>   				unsigned long, unsigned long,
>   				struct arm_smccc_res *);
>   
> -/*
> +/**
>    * struct optee_call_waiter - TEE entry may need to wait for a free TEE thread
> - * @list_node		Reference in waiters list
> - * @c			Waiting completion reference
> - * @sys_thread		True if waiter belongs to a system thread
> + * @list_node:	reference in waiters list
> + * @c:		waiting completion reference
> + * @sys_thread:	true if waiter belongs to a system thread
>    */
>   struct optee_call_waiter {
>   	struct list_head list_node;
> @@ -59,13 +59,13 @@ struct optee_call_waiter {
>   	bool sys_thread;
>   };
>   
> -/*
> +/**
>    * struct optee_call_queue - OP-TEE call queue management
> - * @mutex			Serializes access to this struct
> - * @waiters			List of threads waiting to enter OP-TEE
> - * @total_thread_count		Overall number of thread context in OP-TEE or 0
> - * @free_thread_count		Number of threads context free in OP-TEE
> - * @sys_thread_req_count	Number of registered system thread sessions
> + * @mutex:			serializes access to this struct
> + * @waiters:			list of threads waiting to enter OP-TEE
> + * @total_thread_count:		overall number of thread context in OP-TEE or 0
> + * @free_thread_count:		number of threads context free in OP-TEE
> + * @sys_thread_req_count:	number of registered system thread sessions
>    */
>   struct optee_call_queue {
>   	/* Serializes access to this struct */
> @@ -96,17 +96,17 @@ struct optee_shm_arg_cache {
>   
>   /**
>    * struct optee_supp - supplicant synchronization struct
> - * @ctx			the context of current connected supplicant.
> - *			if !NULL the supplicant device is available for use,
> - *			else busy
> - * @mutex:		held while accessing content of this struct
> - * @req_id:		current request id if supplicant is doing synchronous
> - *			communication, else -1
> - * @reqs:		queued request not yet retrieved by supplicant
> - * @idr:		IDR holding all requests currently being processed
> - *			by supplicant
> - * @reqs_c:		completion used by supplicant when waiting for a
> - *			request to be queued.
> + * @mutex:	held while accessing content of this struct
> + * @ctx:	the context of current connected supplicant.
> + *		if !NULL the supplicant device is available for use,
> + *		else busy
> + * @req_id:	current request id if supplicant is doing synchronous
> + *		communication, else -1
> + * @reqs:	queued request not yet retrieved by supplicant
> + * @idr:	IDR holding all requests currently being processed
> + *		by supplicant
> + * @reqs_c:	completion used by supplicant when waiting for a
> + *		request to be queued.
>    */
>   struct optee_supp {
>   	/* Serializes access to this struct */
> @@ -119,25 +119,25 @@ struct optee_supp {
>   	struct completion reqs_c;
>   };
>   
> -/*
> +/**
>    * struct optee_pcpu - per cpu notif private struct passed to work functions
> - * @optee		optee device reference
> + * @optee:	optee device reference
>    */
>   struct optee_pcpu {
>   	struct optee *optee;
>   };
>   
> -/*
> +/**
>    * struct optee_smc - optee smc communication struct
> - * @invoke_fn		handler function to invoke secure monitor
> - * @memremaped_shm	virtual address of memory in shared memory pool
> + * @invoke_fn:		handler function to invoke secure monitor
> + * @memremaped_shm:	virtual address of memory in shared memory pool
>    * @sec_caps:		secure world capabilities defined by
>    *			OPTEE_SMC_SEC_CAP_* in optee_smc.h
> - * @notif_irq		interrupt used as async notification by OP-TEE or 0
> - * @optee_pcpu		per_cpu optee instance for per cpu work or NULL
> - * @notif_pcpu_wq	workqueue for per cpu asynchronous notification or NULL
> - * @notif_pcpu_work	work for per cpu asynchronous notification
> - * @notif_cpuhp_state   CPU hotplug state assigned for pcpu interrupt management
> + * @notif_irq:		interrupt used as async notification by OP-TEE or 0
> + * @optee_pcpu:		per_cpu optee instance for per cpu work or NULL
> + * @notif_pcpu_wq:	workqueue for per cpu asynchronous notification or NULL
> + * @notif_pcpu_work:	work for per cpu asynchronous notification
> + * @notif_cpuhp_state:	CPU hotplug state assigned for pcpu interrupt management
>    */
>   struct optee_smc {
>   	optee_invoke_fn *invoke_fn;
> @@ -151,13 +151,15 @@ struct optee_smc {
>   };
>   
>   /**
> - * struct optee_ffa_data -  FFA communication struct
> - * @ffa_dev		FFA device, contains the destination id, the id of
> + * struct optee_ffa -  FFA communication struct
> + * @ffa_dev:		FFA device, contains the destination id, the id of
>    *			OP-TEE in secure world
> - * @bottom_half_value	Notification ID used for bottom half signalling or
> + * @bottom_half_value:	notification ID used for bottom half signalling or
>    *			U32_MAX if unused
> - * @mutex		Serializes access to @global_ids
> - * @global_ids		FF-A shared memory global handle translation
> + * @mutex:		serializes access to @global_ids
> + * @global_ids:		FF-A shared memory global handle translation
> + * @notif_wq:		workqueue for FF-A asynchronous notification
> + * @notif_work:		work for FF-A asynchronous notification
>    */
>   struct optee_ffa {
>   	struct ffa_device *ffa_dev;
> @@ -195,26 +197,32 @@ struct optee_ops {
>   
>   /**
>    * struct optee - main service struct
> - * @supp_teedev:	supplicant device
> - * @teedev:		client device
> - * @ops:		internal callbacks for different ways to reach secure
> - *			world
> - * @ctx:		driver internal TEE context
> - * @smc:		specific to SMC ABI
> - * @ffa:		specific to FF-A ABI
> - * @call_queue:		queue of threads waiting to call @invoke_fn
> - * @notif:		notification synchronization struct
> - * @supp:		supplicant synchronization struct for RPC to supplicant
> - * @pool:		shared memory pool
> - * @mutex:		mutex protecting @rpmb_dev
> - * @rpmb_dev:		current RPMB device or NULL
> - * @rpmb_scan_bus_done	flag if device registation of RPMB dependent devices
> - *			was already done
> - * @rpmb_scan_bus_work	workq to for an RPMB device and to scan optee bus
> - *			and register RPMB dependent optee drivers
> - * @rpc_param_count:	If > 0 number of RPC parameters to make room for
> - * @scan_bus_done	flag if device registation was already done.
> - * @scan_bus_work	workq to scan optee bus and register optee drivers
> + * @supp_teedev:		supplicant device
> + * @teedev:			client device
> + * @ops:			internal callbacks for different ways to reach
> + *				secure world
> + * @ctx:			driver internal TEE context
> + * @smc:			specific to SMC ABI
> + * @ffa:			specific to FF-A ABI
> + * @shm_arg_cache:		shared memory cache argument
> + * @call_queue:			queue of threads waiting to call @invoke_fn
> + * @notif:			notification synchronization struct
> + * @supp:			supplicant synchronization struct for RPC to
> + *				supplicant
> + * @pool:			shared memory pool
> + * @rpmb_dev_mutex:		mutex protecting @rpmb_dev
> + * @rpmb_dev:			current RPMB device or NULL
> + * @rpmb_intf:			RPMB notifier block
> + * @rpc_param_count:		if > 0 number of RPC parameters to make room for
> + * @scan_bus_done:		flag if device registation was already done
> + * @rpmb_scan_bus_done:		flag if device registation of RPMB dependent
> + *				devices was already done
> + * @in_kernel_rpmb_routing:	flag if OP-TEE supports in-kernel RPMB routing
> + * @scan_bus_work:		workq to scan optee bus and register optee
> + *				drivers
> + * @rpmb_scan_bus_work:		workq to for an RPMB device and to scan optee
> + *				bus and register RPMB dependent optee drivers
> + * @revision:			OP-TEE OS revision
>    */
>   struct optee {
>   	struct tee_device *supp_teedev;

