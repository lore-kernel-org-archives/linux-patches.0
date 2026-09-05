Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C233876B7
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633374; cv=fail; b=lx/tYUIRhxPAHXDz+9t35C1XJvI9Pz840EaOhychh32DKUvDlyN/83+8KRnY8jWhav3E5yMtbG8uLGwxdYzLHU1K297kOCLhzVROPPM3RZa5JpNH6coAPL08dJOrYAQTzkk6ko8Akf/Od78sMX+9fOD4Lxg5IR+18ks383BP+M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633374; c=relaxed/simple;
	bh=Uesz+21+NGRtHpgw4ozaAUMkjby1YuTDFMa1D+fzVgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mNdEz0cvK7AjQ/6qul+Ne24UZSje8txSZzIBVYsLT95xOYWXdo11MFaO1V7NJz4gY4cDOBnNECGhk35JszXE2uc4ko18nFZapk0Zo0hiJkD8mZ4NxTJsxu6l7SGcZGIhrXxMl7tn+TmnXt4I2mu/goPTvSIgN5DMKZ5Ae4nFeY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gInZtGxi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OL4+XRwj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gInZtGxi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OL4+XRwj"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685Ia0xp1962263;
	Sat, 5 Sep 2026 18:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1X6hhAJpWztiqd+UqyqwhIcyihl0EkI6nwo0cyznmM8=; b=
	gInZtGxiNiGzpAbw1h3tXnqQUKUKTMlFwQpNJhyT3jzpdC+H5Odl3eMztlnVGcGH
	AeZmIRd0WRYBHwWW9eUOCeQb47vtM8uBvTqfHbgXnOLLK4R8McTEotDYguxropjA
	S4AJONbRUwekh2vyvSnrYSgd9tDUkit2nYK3L7BYI+8WHdxPQ4E1ejRJIn2nBSRJ
	sY7nxYsdQqU0wAGLKXHyIxyl32f9fMZ6hrP7YMBid1tEpnnMVB5trj6cFZlc41A6
	G2fDwl4Sov7IIO9PBGLx/hmC69Vt2hxDnL/U1t3/19sZXp13XCunf/BRLqPtqTpz
	2JT0+OwY6tob6IoHN6KEmQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbd3rcma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 18:35:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685IU3EP005779;
	Sat, 5 Sep 2026 18:35:59 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hbe021-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 18:35:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jPjjKh2ih/aQfU7/8khu8krCLt4WKSz8zo+09IZhW2GLXqGNFkoKAVtcnMpIWkuAWBebx7edEmuFjZsxBWikqIsKDXzBFEdZVKLSKRZ2OcmsLQBi/jza5UWPw35tT2niBzZydbTOWvIW1hj0itbtRbS6XwGqJ4ezNvAx7kjkvolr71ZyFb4PY4lgp5wbpfvZ6foWJ6ZGlbs+WIZ+vno0Ru0qNWHu3Bkorxre9C8S2nnaQYvvKtzdycEkh1vUduSjkMQK4rsdgtwzk5Od2bgLZRniq4aYNUJ+eZ9YP/Alk9U4CMtw7Za/87y9x3gaYEb5jH/vASs9TiZba8DTCmEY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1X6hhAJpWztiqd+UqyqwhIcyihl0EkI6nwo0cyznmM8=;
 b=VXhC7EyZxcJ0Fls7P5uiROZa0IQVNSZ8p5bVHXwtjddvY1dCw/SzQO9zP0wq1G+43ZDeWTx/2jc448YdCORxhjQB3loaQ4EDe/h19ChUlLaJg6ev/86LPaXn49Kweg/47d32Oc1eP5B3erCXRkVrdyMFMNoDWBnN3kXKQJdC0jezYy4RVO3oF9208zp56aEb8vM0NBF3QU17GVkIzopbvl8TdfQCFWoZND3m+cfRU4NX9ckZyPZA19yxnWXvHKzoHyqjMYJtjImJZUIWlGu0xy/yqNns6AxE7HIVTfBQ60jFIOe8Qv+f+uRosCTAUJ4MnBRoi2dhr0MdxyFc6xbGhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1X6hhAJpWztiqd+UqyqwhIcyihl0EkI6nwo0cyznmM8=;
 b=OL4+XRwjl4TbNj0Kph7zplkZnyatw2HfLxn2iWiWTBz9Vmsgv3wCG1NlyfispuzjknUBFm1ayjnGW4tObcV12JbsrBwaFOlv4RZ+u5cubTkSn0bm1Sk78hsyZQv1gnjEt+mWPcRIDP3O2Moc7N6mtdCk71Ua84FKlDoC2B75L/c=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB6871.namprd10.prod.outlook.com (2603:10b6:8:134::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sat, 5 Sep
 2026 18:35:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 18:35:56 +0000
Message-ID: <1a4a92b4-b87a-4654-8d73-05344415069f@oracle.com>
Date: Sun, 6 Sep 2026 00:05:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 381/403] i3c: master: Fix potential UAF in
 i3c_device_uevent()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
        Frank Li <Frank.Li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045743.458413377@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045743.458413377@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::19) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: 336d4789-535f-48bc-b388-08df0b7c8624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|56012099006|5023799004|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9Ma3Ve5Nwmd+BkmNxcJ7JMlAiregY7hjNfR+JdAsBPPdwFHAjEF05m/Or/NcxX3pV1xijEHkZ4vh5snTPl8hUPkXlpvvp+4R2TKRs7otJHa91dWD3wpZy6o4HBuUqip5QQV9lTZCF0qsdvyij+UiYOJdXGZaQBKDDac5P4RdozSIYDcg0mY0bDUCuUFHs/0eLfvg+BdfeVdydAXUIWQmF/bDP6EgcyPUUcp5N6pOFE0coxPcLwGTUO+bSmCSv72xC0aM2+7XGXfcDyoAItqMjEO8aLMOEJiLE8WU5xLkBtdXotgo/GectWB+rNhYVWg5DoPV/sBoUzuGyduVxulMM/b1FC2shsYRH/v0YJ0+y8oZRowJ93359c1VessQy6xvoWFYEscVTgqr+qWtFdVW7/A/CYTAXSrqB12LuNb9Spo0JvA1FmgGXtXTIBoPA563XlrGa2E0YaCd8Lk78FKL0vkGgJ9CqqpI8HUMvH4tVo41t3CaddqHy97hkm+p1tKYZQLBSsGavHhthspU1fkhM8J4P5Z+hfbHWQ/8NukM3e3nRaFUBRWwMeHvR4XXn5jizH0qqtepFeaMtD9mtW8Yex33/9Uxc8vik629rkle65YTWo2T1dYspQQIv6MvjaAL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(56012099006)(5023799004)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTJGbHNZTzMvK1hSaWcxYyt4ZmJzWk03RngzYyt0ekJtVm1CLzJDMmsxQWsw?=
 =?utf-8?B?VmxwVGNBMXY4MlJLcjl5cHI3dWt1Qm1MQkIxYm5KQWxKWHZWVkNUOTRiSVUv?=
 =?utf-8?B?cmFFVVA0ZE5SK1F3TGNzeGlJdmpRVzhCM3VlZGpFVjAzWnJyekhLeG5DeEJG?=
 =?utf-8?B?aktKUkNKbkh1czdVQnA1UDI5SzFQR0FBTC9kTVFtVEovdE5mZWlFNmhleHN2?=
 =?utf-8?B?c21ZdUZBSGFqazVhL0RnZkJTUUJ2WEV1VUJHYSt3SnM5eG9CTEJ2dWZQU3Q0?=
 =?utf-8?B?UjZ2Z3FZVUt6c3UzN0hwbGlEWjR2RHZnMm5sYmlQbE1wZjdhVFM4SmtONzZI?=
 =?utf-8?B?N1FWN0taYlN2N0pkaEdnSkpUN0xRL2tQWDF0dTlBZWFDSXYvU25OSHZIMU9N?=
 =?utf-8?B?UmxEV1BxL2d4dC9CRUFGc0lqckJZZHRHekdSRU9XYjZEdE55YzdoQjdnYzlF?=
 =?utf-8?B?am1nLzNqYlVpN29tRnFtRDBjSy9TM0k1dGw2QWJFMlB3RGNWbEZBUnZhUzRh?=
 =?utf-8?B?cE8xV2FNTmk0a1c3NGxtS3NhNHN0ZTZSdWVIWVdxR2FIME05UHlFRUE5emY4?=
 =?utf-8?B?bXZDWVNKOFo4aVZLczlQYlNlS0ZvRXJVUTJIb1J6YitnVnQ3RU5vWEV6NkpG?=
 =?utf-8?B?ZGZ0NnRLd0FCUExJcmgvSHNhZk5USkd3N3V1TStMSzdHbjFsc3FnR0RwYVBN?=
 =?utf-8?B?M2VkNmxZeFVENE1RYmNZei9WYWltWTBoUVNjcW14SmlIYmZYbnhuWDJsSkgy?=
 =?utf-8?B?THJHRE4zc0tORThkcHN0UUZwbkUxVFRuNldqVGxpZzNlcTFHZDhwZWhlTEdn?=
 =?utf-8?B?b2hJNm5XcmpySU92dlNXSFVYWitBZWhBR1F6NnkxdUFMM2Z4UXJoc0l4MHFC?=
 =?utf-8?B?ZHV0Z3ArWVRGQkE1NWtGNUxmRDdPV2I3eDZpVGg1MGdRN0Z0R0tqSDJjSkRv?=
 =?utf-8?B?NjV3ZWZZc0dsdnlnRENROHdyL3JRV29EQjRhYlpydzREdnRrZ01ORkV2aUtU?=
 =?utf-8?B?V3dsQ0o1dy8vaEh4NGFoRHpZdGY1NllRUGdIVml1VWx0bG5IcWRlN1hLSGI5?=
 =?utf-8?B?cXlEem5kcmRrMEYxR0N2SW5JUURHcDFiUG15bWxxSWVIbWhaRFptQ3RPRk4z?=
 =?utf-8?B?Z2hCMjl0ZWlmV0xEaFRVdHJZYkRJd1pyS0xiUTlsTks3L3F3V3d1VmRnRGt6?=
 =?utf-8?B?RXVIQ0dYdFFXaVp6ZS9qalpHa0ZEMkgzUy9jNWx2VDZLaUVGejlxNmNvV1hQ?=
 =?utf-8?B?dXdKb0xOZUo2cFhRbGxjbE5Nd2tmdksydWlOa0dxQ2JxdGRDSGl3VXdGZlp3?=
 =?utf-8?B?MGpWcTU5eHRtQ0x2UFAzSlA1R3I1UGFXUlBTNmdOVEh6Qi9CVURXNU5zQlBZ?=
 =?utf-8?B?eUR1N0wyMkFhWStiQlljdDY4ajZMY0c4eUNvdTlUTFl0bG84K1Q0NUJ6cFk3?=
 =?utf-8?B?SlVuTWJMcHlqNWpyeGdwSTVDOHdmR0lrWmNQRThhOGROMWQyamlLOFJHT0lt?=
 =?utf-8?B?U2VHdHZaZkRORlVkWlgrcHZpcG9jMFFyZjlMbWU2Z0x4MUwzVnBvS01xekVY?=
 =?utf-8?B?cEF6UFkxVmhwU1hMNTF6bjlDV2xsK1M1ZFF6aFlFWUVmRUg0aXU1ek9jalFC?=
 =?utf-8?B?OUFBcnNzdTNEZkZ0OStUWS9mZlVFMjhkeHJUaE5PRHZMMS9UaGpjZG05aXJL?=
 =?utf-8?B?eUtLRlZuRUpCZW1oTFlOQWRPUndCZFFSeVo3QzUwL1ZtMytZQ3pBTE1nL3dP?=
 =?utf-8?B?MHFMTUZIWjRKQWgwVzFIa25MUHRKaWlscy9xM0FLWDdaem92L0tnNjhHay9L?=
 =?utf-8?B?cWNpYVhMZW8zK2x4RHJXeVJNUXE2NU52Wm1DVWZUM2p4dGZCMldHTnZwc25x?=
 =?utf-8?B?bHVlSXUraE05MmEzK0ZMQmpNY0UyU0dZQTN5M0lSd0pRVmlRWU03akZBRFA1?=
 =?utf-8?B?QVMwY3EyNzc0a2hsSFl0NzVIM3NlRXVsQjA1TDUrQ2c5Y2NMMFQ0L3N2b2Q2?=
 =?utf-8?B?UHpoSlVyZWFPdEtEdWVpV2FXQXNPZUxJOWc2ekxRdjExSDdxaVlDWjdjaldn?=
 =?utf-8?B?LzZ1dHdhbVRGak1DSGFLTTNxQ2ZueHVMcXZpM2JQRjhBd25BMUtjZDNXYlJ6?=
 =?utf-8?B?Y3BHWEVQVUh4UWxkSDlIQzZDdXRSL2FIc2pYcEVQTWpoUUtYeGFkTXFubWpY?=
 =?utf-8?B?VktSWFk1bFl3cThUcklsSG1KSnVMVHBJL0JPTXVBeDVqYk04dmswRmxncm8r?=
 =?utf-8?B?S2dLd1Z2VDhkWHVDM2t0cmdHYzBZNGhVTWdUZFRuU3V2UEEwdXhsbG1kV1d2?=
 =?utf-8?B?d3BGU2d4c3lCY3J1eGJ2aUZacEdWOUhhczVhWHVQVndSbzBjSjI1bFhqczcw?=
 =?utf-8?Q?tJM10TLMmf34OmpIBq14ab879ugtYYN1iYWwu?=
X-Exchange-RoutingPolicyChecked:
	SdpHdgDUFico88lDlpfjz0dEnGvcjDDtgZVJXAbjX8rGwqgvDdibwgadQr6jEy2SHuVKAKtIkqDobpcX887kBeHKLYTx8ZpZazrCUbFblYoPfJmhBABod1nWIfR+mqKxAAF2qkZmGlm5w2+/PA6iNay/UMDKvG6gp3MNfU+gQXSf8quXktMxTRgHCvFLcyRk/dNQf929UwdnfQ6jT3Qu/qXspxlphjYYc3ij3LnjMK3j/QxEXEMb0P9KdntcEW4qNv8oaZ1yqmBgdbHKQWZGBnauk9R6FM/Y9c0+qSw7c/QMxOyBxH0MtE0i1tNY/6vsEDRpqxJTXBiRI5OIqvEyXg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ne7U03xINgRL1QxPOeAp3rnAsTcnhE2ypKnwSUyZWf6wG1DDJhgLA4jk2eGdGEQYPPOc+nv9NsKhM6yc6/pY7Ea7zcEKquJGM0q806nUgCwxG0/244NrK9FuDefAWUkkLNqO56b0D0MAlLYi6bJnC9l/tYbk73TnTrT7nzGtUdWBolZ35ZXQMRrXcoo337SBoQjX42cnfSCv3ubGQDTt5U6QRhE4Vw218w0inHqIQgFg/nsH2VhcNN9dYkhA7ufUbW74lQm2BDTDE17np/UWmPhSEoi91/FytTfvlJD4fRoAAe3SV+1GNO/9cyAbReGsIvK3pyiDqCMHUvAaqVZFc/8eWcKWWvbdmSxBK11F8lM4UC9OsA/wsWvJm8rlzL0XWgzCqoGewNGe5JypAbA/Wp110CQ6w1DBFnF8eSwLTAbJE1HAcAUsV8X1C46QaWcCINXcw5P2mhLOXoy31Dxx4yA1AJVdnV/zYSUKk5iy6iITrE6F10ehZeu6dKRolXOe7Gb4tfeRnkmzXQ3OhUfjyT7TEBuwxS6rw09qJzJLlpYuN5gYYBCIoB0u0yFRjEshKfb422hqz5gfBo3owOJ7Qddmn3kjU/ec+PrxHwZJE1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336d4789-535f-48bc-b388-08df0b7c8624
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:35:56.5063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GByMRJ2UMULn4YzAT59OHgCeMJZQd/a/IgPZlxzmF9pGV3/To6RBzZ+m8Vi/IXxWx1O0l2kloO9kjnAJUtoPzpiRcM74lhLpluXSj3f/0skwHbvauYUsTqxYZJ+LsWxU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_06,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2609050206
X-Authority-Analysis: v=2.4 cv=EuDiaycA c=1 sm=1 tr=0 ts=6a9c610f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=8AirrxEcAAAA:8
 a=P-IC7800AAAA:8 a=ag1SF4gXAAAA:8 a=ZDAMZPJEG6A87nm7sboA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=ST-jHhOKWsTCqRlWije3:22 a=d3PnA9EDa4IxuAV0gXij:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIwNyBTYWx0ZWRfX3hrPw/e+JLBA
 zipqRu/fqJseC/8KsgjpmF7Aq8e71Bt3Afllvh979PXnLqbO/3VJAhK2CvyPscEM8I0+QlrecP4
 kQ0EpIYBImp0pO/hiArKXDVq39rLvWsAuvkyLR1N8DeDLWHSPDS+
X-Proofpoint-GUID: jJKyIq5FgXMAZlhgYuEMJBdlmyBdkDyy
X-Proofpoint-ORIG-GUID: jJKyIq5FgXMAZlhgYuEMJBdlmyBdkDyy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIwNyBTYWx0ZWRfXxQnakqfDbDGh
 v3ONB5SZy4sIFiK6cgGyxzmrVDgAN18iEgMn2VWPte7OE6GItdEsxJNg9cRkwLihlqjNnu4UTOy
 6CKHhsfCp0PqBneDQXCjVRDGfXxpzrQVvNXopk2QmgaRnTsyozHZOrNsJ2YLEYBqkrrjCSWOOn5
 V0arRCP7vtBSCq58fH3oSbfZiYScFF8hnTKaAvQMCUf5s2Z8nNG9YRTnmt83aKzl0zTdCbgJ38z
 v37/ACRman0YOgQz14w8OWhuKXUbsj2J+t/ZDJWjtD0Zb4raud1U8v412NNhER7pY4v7+qYRYii
 SuMJtESW4ws/7OhI/AgQLF7WCwqpkPH/j5dK0+NUdYFuX8LiBf8SloQGUxawiNubMkP3J74JqMS
 c9MAmQ+ET3A/D10ThPmHBEWiSlkHQ19aS53P2kDl8zZObKCN0PCRcMoCYh+Dv3WsnfTf92zXQEy
 F++o0zYferiWwmog6yQ==

Hi Greg/Sasha,

On 04/09/26 10:33 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> commit e5e8dd2e959f470524c16ca444d001c90d6bb3ad upstream.
> 
> i3c_device_uevent() dereferences i3cdev->desc without holding the bus
> normal-use lock.  Since the descriptor pointer can be replaced
> concurrently, including when a uevent is generated from sysfs, this can
> result in dereferencing a stale descriptor and lead to a use-after-free.
> 
> Use i3c_device_get_info() instead, which protects access to the
> descriptor with the normal-use lock.
> 
> Commit 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling
> i3c_device_get_info() to avoid deadlock") replaced the accessor with a
> direct descriptor dereference because i3c_device_get_info() would
> recursively acquire bus->lock during device registration.
> 
> This change depends on "i3c: master: Fix recursive locking during device
> registration", which moves device registration out from under bus->lock
> and removes the possibility of that deadlock.  Without that change,
> restoring the i3c_device_get_info() call would reintroduce the deadlock.
> 
> Fixes: 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock")
> Cc: stable@vger.kernel.org # requires "i3c: master: Fix recursive locking during device registration"
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Link: https://patch.msgid.link/20260807145638.168865-7-adrian.hunter@intel.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/i3c/master.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/drivers/i3c/master.c
> +++ b/drivers/i3c/master.c
> @@ -282,8 +282,7 @@ static int i3c_device_uevent(const struc
>   	struct i3c_device_info devinfo;
>   	u16 manuf, part, ext;
>   
> -	if (i3cdev->desc)
> -		devinfo = i3cdev->desc->info;
> +	i3c_device_get_info(i3cdev, &devinfo);


I have run an AI-assisted backport review and spotted an issue.

this commit restores:
       i3c_device_get_info(i3cdev, &devinfo);

This function takes the I3C bus lock. However, 6.12.y still registers
devices while holding the same lock:

       i3c_bus_normaluse_lock(&master->bus);
       i3c_master_register_new_i3c_devs(master);
       i3c_bus_normaluse_unlock(&master->bus);

The uevent can therefore acquire the lock recursively and deadlock.

Upstream avoids this with prerequisite commit: 456f832e5fc2. Maybe we 
should drop this patch without prerequisites.

Thoughts?


thanks,
Harshit
>   	manuf = I3C_PID_MANUF_ID(devinfo.pid);
>   	part = I3C_PID_PART_ID(devinfo.pid);
>   	ext = I3C_PID_EXTRA_INFO(devinfo.pid);
> 
> 
> 

