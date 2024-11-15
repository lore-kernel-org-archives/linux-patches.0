Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FD5189F39;
	Fri, 15 Nov 2024 09:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731663379; cv=fail; b=oGv1KWkk+93vSkXSWh7S2NBk6+0AbSKEl81ZH8DZ3qc3CC15/lanR6tHszrWBufG8fYqgTKcUfcBaD1X8t2KX762d52PNTpwRwX1pv5zFImeT4zih/mxO7uxslzpqCShYLTN9LIr8bUrv/RV49+OJzr/k+j268h2qNqfQ7WfLT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731663379; c=relaxed/simple;
	bh=j/ujkg+naiKGnwUh2oXzPMlSNxeiMzPYenxuxVmV8FA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HfZfhMLUCT7//Wdm2p3XxJygm8/uQUYtGAiPhNUH/ux0sdgXdDsfS5e5P+kw/iW/dqKoIm3mBNbdeclBPqZ6IE0tVpsvNgKNr/XB/b3BEGhmPVXjnV/PqzxshZxt3i51wMEJBQkpmAZq4t5l1MSaezZIYzbc5jES3FOpDaM1DZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FCrqYmap; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gO6DW7Xw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FCrqYmap";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gO6DW7Xw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF8tYo9024058;
	Fri, 15 Nov 2024 09:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qWzagdG50opZ2oAZmbfm7THOeRuHBndxzbbqG+52Q5E=; b=
	FCrqYmapRfRskuGOAJjV1vib0zcgaT3yUpmfIE9DLpboVFNOWXB/BjplbBQzqr/s
	VkEDSsGjTIfHTsTWoxpdP+UHF3oAVKeVnvTwVXkST+cFivn9wPVYVoXgQ54bTiLx
	LZOhfiOKSev4zsYYGQ9lPNRkYMUKkWAbfU3FR0dnwBwAceIKofjscHfMI3YHJBi2
	+Lbx4IBbiF9O099EM32fzqHsUwRVmPb/2401EtmsIL+uiPwG4cEYCrknJ2dCXWsw
	8hmKza0yDzffWEWO0dBeyuk1JQcAeci+/8NLpVmIukNYqExz7C0kBEytHZtQedSQ
	IWTzVuGy44vR5je2uVHJCg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42vsp4mr6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 09:36:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF8Xevp001225;
	Fri, 15 Nov 2024 09:36:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx6cbnvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 09:36:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fk+pVPqKE7PDXZ4kNGK0zZys6b7UT7UbLo8LOOO/aWFt0UJRrD5VRzL71aL8itbzNyI0mwjRN1BIEGNfso/kTmWVIIwEJwby5wouyA2/A4EnFu7rNd7PWD6QZcXt3elgi9x5cwz6j77bA7/weAPDuy1fgwj4TNsI+HJEQVxQdLxkKA/pWWgt6wuSKTajksYyzwzv7VUJQVznu2CngA5MQxM9SQlvx6wu+vPzueFxrRfcUjJNPQICmu/hrB4JsixujmZLHqASgz+dDeXbF0GS0zH8CJLK2Reie6tEVE+HuyAPqOi2ZTS1Z36m3Yy5iPSRWeR7tRt1Nh5m5tQK5ncFdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWzagdG50opZ2oAZmbfm7THOeRuHBndxzbbqG+52Q5E=;
 b=eMza+OUruzyWIvt9CLvz5UPS2S9LYqHnhOq/b91NVHYXb0eS+d5yV3DwaRegdp8mV7tL5Vs35SixgtnIYfDQ7+rDhzbP4X5PygI32B/ptRANfNDhXXml+RifwLF6jBdvzh1Oxb8A/dwVmIZHXp/zy5dPrEj7jsR0CPnuvlwoMKXInybw0miGr4Hyb4GVsUktCZckz8cV/RZmWWrkSFDIrGCSTBNJmyGmJEZyiFiglHXhCHADJEP5vrtJQrhdLMci9P/h86/OHzUifhU21xvroIG4FBQj79rSBoTmoM2QBuBgIasTPLd4G279FmQDEPjz8ToUG32Ed5YtC2bA1CZD9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWzagdG50opZ2oAZmbfm7THOeRuHBndxzbbqG+52Q5E=;
 b=gO6DW7Xwgxa08vDADhI2TsiKkSDW3pS54az8+OSvOHLNk11ubrjGogZ9k0MeCabLxVWNL0fWnDqVtQnTGI3ya0c5PJlMnjNDVYlF3BOiHhPo3ispAvsQDhbrxvf1sgnJJhImiNZG4HYGNEYfsqBo9Lg0XgYwBUVYIT88DVphTkw=
Received: from PH7PR10MB6505.namprd10.prod.outlook.com (2603:10b6:510:200::11)
 by DS7PR10MB5974.namprd10.prod.outlook.com (2603:10b6:8:9e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 09:36:11 +0000
Received: from PH7PR10MB6505.namprd10.prod.outlook.com
 ([fe80::83d9:1bf1:52cf:df54]) by PH7PR10MB6505.namprd10.prod.outlook.com
 ([fe80::83d9:1bf1:52cf:df54%3]) with mapi id 15.20.8137.027; Fri, 15 Nov 2024
 09:36:10 +0000
Message-ID: <9a6e2af5-73a5-4d5e-bf67-20857faa9e43@oracle.com>
Date: Fri, 15 Nov 2024 15:06:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 62/66] mm: clarify a confusing comment for
 remap_pfn_range()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        WANG Wenhu <wenhu.wang@vivo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063725.079065062@linuxfoundation.org>
 <4537b145-3026-4203-8cc4-6a4a063f4d96@oracle.com>
 <2024111556-exterior-catapult-9306@gregkh>
 <003c7218-ba88-4457-9175-b6901318bc1c@oracle.com>
 <2024111515-follow-falcon-ba9b@gregkh>
Content-Language: en-US
From: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
In-Reply-To: <2024111515-follow-falcon-ba9b@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To PH7PR10MB6505.namprd10.prod.outlook.com
 (2603:10b6:510:200::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6505:EE_|DS7PR10MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e316abe-4b20-4993-f85a-08dd0558f05e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2UrcXRJN05HM3JTNlNQUDhsZkFuWU9RMW9YVm5PWExyN3E2YmE5RkJNd1p6?=
 =?utf-8?B?dm9BekgzZWJkenNIL0dlUUFIM1N4dVBZUkN5OHgxaDVsZzBER1pnTHR0T0hS?=
 =?utf-8?B?TDVpZHlBRlVxUXdaMytmTTIwL0pCNDVXeXJDcmZUTytZelFWdXltY3QxZ2RI?=
 =?utf-8?B?SUtrOUU4c1hYK3FMSHAyTmIwUWNBelp1c2NBYU85WXZ0RFB5SnVNUDA4bW9u?=
 =?utf-8?B?M0tnYmNwS0YwN0hTS043RG1IUFVSajh5SnZINzFqYytuSGhIYWNSZFZLZ0VF?=
 =?utf-8?B?dmhRdW1aSXhXSWpSYUVEVlYvTE9LV3pPa3FsNjlpZzh5dnd5R1BHekJNcjR3?=
 =?utf-8?B?NEZkYmNMZnpuMWxEQ1NtdDcwZU9qUTBlRzJPWkc0dVViNFIzeW1QTHArSlU5?=
 =?utf-8?B?YzNxZ1hGczF0NUFKUTcvV08wdExHWGVnNC9INmVmQjJScUhWbjRueERUMmsv?=
 =?utf-8?B?ZFkxVGltalZPdWdUbzQxbUVnaHVjbmVjU24yNUJJNWdWdFNYeXlOYWNIdDA5?=
 =?utf-8?B?Smh3dzRhbEZiN25vcGZpbWwyOWVSd1lTZGV4Yi9uTWZ4d3dnVVhqVlhadDFM?=
 =?utf-8?B?TTRYbFcxUDBqK1ROTGIxcXo0cHI3dEZWMU9Lalkycm5yc0hmbnMvTDhEZTJ0?=
 =?utf-8?B?THlpN0JqRjNZc3VhNU96VDQwRDMzY1RabXRadmNVUUVqbGZQblpzQ21CdlIx?=
 =?utf-8?B?L3FDVVFaMTBYaE4vaWhHUWdveEtmRUJ3ZVpUNVFHNUExK1VBN3M5NFRzOW9q?=
 =?utf-8?B?Z3pkNEpBWjV3Nmp3TldGQnN5ei9FaVh6c3p5cm1OcUZkVnQ3SUlHMjFjU0to?=
 =?utf-8?B?bkZJZzRpSFk4NWg2SDBxQmRHUCszRmhRMnlqdDZ2MWtnZVU1MEtIY0txRG44?=
 =?utf-8?B?WlRFZmNndU5XVS9tWTAxcFY2SmEwYVIzSy90c3JBVXRTWCs5QUsvaEVOdkdl?=
 =?utf-8?B?UCtSUVQ1T0RCUFJTWlN0dDRudFpVa004VmtVVVM1Ylg1UElKdFNyb1VUQjZi?=
 =?utf-8?B?N3ZyNDZWakUvNVVHNEVkZHZ3ejA0eXY0TXRxQWdZWXdxUnp0bldLeEtLd21u?=
 =?utf-8?B?VEx0a2dhQ0psU3ZIOEpvNXI4d3R1eno4Tk93KzJNUzJaZXFVeDhKOEo2NnhJ?=
 =?utf-8?B?a3pjakF0Q01PYVVYZjF0a3ZLbHowNjR4aHp2ZFZXMGhBVGJQSmtZbjRsa0g1?=
 =?utf-8?B?bTMxb0Voek1ZVnd2OHFYcVd3VnV3engydjByaVhIdTNhN1BHK2ZlZnBWVUhw?=
 =?utf-8?B?NDVMUjI4d0h6djF3dzZKUStubWlhSjl1U2d5YVkrWDJHRStLOFFGMm9YOTBu?=
 =?utf-8?B?R3JIT0V5eHZwbzlZMXZpOUd0QVlGaE1iQnNzNEY5WXpTeVp6UjlPNCtxVUhN?=
 =?utf-8?B?N1FXL0xaRWtqMDNvQjM5R2dZcnd5MFg4Q2xSZU53bS93Q0M3bHUvUEZxVDh3?=
 =?utf-8?B?VUZtb2JWSTBQeHU2K1daRW9ySW5RVEJRdFV5NDFlTnY5cHoyTUV5c3NzcHl3?=
 =?utf-8?B?S092T1dhYVVmTVg5V29wU2FCV25nNmJHT0JHTnc1Tm44U1RRK2IrYzNaV1Jk?=
 =?utf-8?B?VUVOTHN1Q1RscFIvVEFBV2RiOEZZM1o2ZVVHUXhhWXVwMEI4ZWwyQlg5ZmN5?=
 =?utf-8?B?b1FVeWE1TEJQUEVTREs3OVllRHl5bVRYeEpENHVlbUVxTE1JRENvOVpRNjVV?=
 =?utf-8?B?YXdJcVJkK0ExUkUvNEN5aUdiL1BGUWFqS0pKYkhHcTNDVTJLOFRjaE1XRGhv?=
 =?utf-8?Q?yI2Sc51tE/kp4jqF8hto/Qg/Fgr260DEtmXs1XC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elFkU2s4MWRXMFpESDZoWFp6ZGVTM25mKzlYQjF1enhaMnRFN2RkMFd5Y1Zr?=
 =?utf-8?B?d0Jvc1BUc1lrd2lHMmhoNkMvV054M1J1WGpueE56eGxkMGQ4MXR2MTg0Y29y?=
 =?utf-8?B?UGN1SldWenhUS2Z5MVJoR0RFTGUxbGdVZERWbk1qVm1obDVsRGZiL04wKys5?=
 =?utf-8?B?YWVyTXZIRTJob05nNjQ3Y1dEdzc4VWRkZ0hUek1ua1VXZGZZZ0gwUXJqZy91?=
 =?utf-8?B?M2JaRG5iajJiTXpmVDV3Y1dLS09VTVRacDI0NW9hTDVzNFZBWDdEbzZKbnpw?=
 =?utf-8?B?cEVaNGlwV3EzRW9zZ3kzQURuTVVsZkUvYmpCYm9uY1ZZSTZMdkJYMDIzVTB3?=
 =?utf-8?B?Ym1JQzhJMURUb21tSFRVUWFpMUVoV0RBZmtaSWUxYzVkS21wT0lVODB5YVFI?=
 =?utf-8?B?MnNsMGVyS0pBbGNxT2NiVGhreGtSSlRoR3RMeWhjOXZnaHdVdlNiK1dDbWh1?=
 =?utf-8?B?VkRyRklBQ0ZoMzd4UXhhelpyc3BYSWQ0aUd2M3hHelNuZUZ4TXRCMnJpU3Nu?=
 =?utf-8?B?bklrSVpmd1c0SlFZUzhFb0hUakRyQ3U2TjR5aExCeGt1WklZWmp5TGhKUVpy?=
 =?utf-8?B?cjNUTnNmRUZQWStHbk96cVRLR2YxSXRua1Q3MEhKRkpteFpWZUF3eERyWWd2?=
 =?utf-8?B?Y01NUjNOcy9EOUZRWmZjeG5iRDUyM2lmTGZCZHRodEljR3A3S0VvQjAzN3gy?=
 =?utf-8?B?TUFrVVgwYnU3T245OEx1M0REeGNKMC9lVkdoYlZvOW1xZStFYWp5MFJRV2lm?=
 =?utf-8?B?akJ1WHpjV1hqNXp1eDFFMVI0M3RIbWRlcDNIMS9Pb01sU3RTOUNjeFdPUEFj?=
 =?utf-8?B?Y1Nsendpc0c1YnhaTlNOMFpWNzNpTW1sK3BZMVB2U0FsNWVvT2N3QytsTEpm?=
 =?utf-8?B?QVl2ZDdVaVR2UTlxUSsrZ1VJa2gxdGFSU1RXZFErRVBieTd6TW1INVc4MGY4?=
 =?utf-8?B?WEVuOGU5V2tMRkxYVWY1ajJ2dSs0RlprQXI0ZVlCRERlakk2ODhuWGxpdXdx?=
 =?utf-8?B?VmVhZGtLM0QwdGxBL0FtZmpKS0hEY3FmeTIwOEkyYkozQXdWdDRKaVVxdGls?=
 =?utf-8?B?dkx2dFJHWE5JelZLVE9hNnhBclRaL3VLOUZUdHYrTTRIeXVwRnp3ZXZTUXlM?=
 =?utf-8?B?M25zY1FkSHNrNUMzaHNXQkdwWVN5WXAzdkFzUEM4U2FQWUh0Z3dtRm41WGxl?=
 =?utf-8?B?SW5rNWNpV013R2x0NXgxZHY2Sjd2ZkxydVhNQjBLeE91ZXovSnFjWkVIN2pN?=
 =?utf-8?B?Q3BpUTZ3T3pmQ3dvNi9KbEhZU0s1RGg1MTdTM0ZJSG4vMzZDQUxBK1NrTkRj?=
 =?utf-8?B?dEREMDFNYjR3RHZLL0haWVZOeFM4QzlNZjlKKzROUmlvYjFqdkl2Y0tqbjdV?=
 =?utf-8?B?ejl2dlZROTZoc2tWRjJRUlRwTXo1Y0ZoU2ZiOHR1cEZ1MWcrZ1VrTnFYWCtL?=
 =?utf-8?B?MHlkdWkrVURrWEpnZG5xSFBzVm56eUZMa1dDVWxFSWx3TGM1eFQ2NmdnTld6?=
 =?utf-8?B?eUtscEJjbWhyQnp2MDVmZVBwcW50YlZHL21sdEEvR1l3YTRVYmphT3hIWGJN?=
 =?utf-8?B?cnV0alIrVUIxK1M5Q0x5bjVEYk9yb0RKVmJaNDRqSW95c1dZM1dZd21pUWZP?=
 =?utf-8?B?ekFINklQL2FuaTB6RXNQQVpWUllRY1RNK0ttTFNXeDhkWnJ0SVhrVEcxK2d3?=
 =?utf-8?B?Qiticm5FWXdNazFHT2lLU2sraUtlZU5Vd0hPY2FnMitiR1EwTllrakJ2cXFX?=
 =?utf-8?B?U1JCeFdLd1pGU3V2Snd4OE5MSnlzaUY3ZVJ4ZkxmR3pXVjJHMzFtM1NseXNC?=
 =?utf-8?B?Ull3NExKVWNzV293Nm9zUlhrcE8wMFVldjlnd2dKMkJzaUdNTmZkbS9aaUR2?=
 =?utf-8?B?MmtnZVViSVRGT2N3WVlKTEN4YngyNU9YTDF5WCtzUUZTTU9PTTFrV3FkZXRh?=
 =?utf-8?B?SGZyTDBXcXdxc0xtSWlldmh5YUdPZzRCNFoxTUdZOUZNSm4yVVVBM2FCMmtV?=
 =?utf-8?B?eEZINVQybjc5Q21QM1JyZVAxSXkvdEo1UE9QejdmWUJXTUZSVFVpZGUweW5q?=
 =?utf-8?B?RFduaVd1U1VJMDJ6V0UvUDhMNWE2MDVhRklGWGJHYVhBdFVkTmdiUGxCNHBl?=
 =?utf-8?B?UEZ6bGNTeVpwaTBXODhWaDlXYml0Z0JDNjMzZmJvWFBCeDVUU0VFUmo2am5C?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xqXPfyS/X9BGLCZ6nTXF/1qIr7IbUeTF3BShpbTSTk9QNavw46kl0Ktm/+FmjRw9KY74DxozL9hybpEh2dKQxYrLFhyVhSs7NzC6xViAkTuwhHiOO12L71WWlg+3cGsv6/ownkUTqJ8r+q1u5JREof07fLKPACeGNpFvROvZ3GlRzvMyXisDGodvbh3cEieEXbdwdVq42kHWtj/qhlJJNr7N+G/kGZ+jHU0tGA8ZMHUlYAsKRrn9Y9Beghd1d89Wpg1dFnWmj9AF9vLwGVKpn7WtWThNmRlero0kTTAsu5FPNeez49DE3d/Qa0VHlNEq1wiXMDMqEO3bSLyJs3cyxsPZVcGkMIxxNwXHY3hHfSOUKWrMDu2dCzPjr1afhSnToXIwjBk51fCcjGOYpTkWBngAduA6NdmWP8haHDDsCFZ9A3b4Pq7cMZyLiMEQQJDkXYqSigUNyICsDR85A/lAnLLIvu0r6YKk2WYkPUYklGerQz51OsI0JHqMkN5YsLpQOUAY8TRzT/64JqUKZl39Zmu4xIIRSSWu0Jb2dTPcxJBteseWkaATLrr2ViYb39XoOPVRYB20NfAOYko5pGKiLUeKqVHHq/4uQvIyt5wya84=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e316abe-4b20-4993-f85a-08dd0558f05e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 09:36:10.7828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +EI9Gk+Q0qAg4iyZQLiYs2wyUw3oE/aYX/WszLnOuDnFjVZIw3MpNycLUwwA3xpMVDGVIVRlPhULAUwFuMrewr0hhqSkW3VrgLQKEURTwJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_05,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=691 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411150080
X-Proofpoint-ORIG-GUID: Oaa85OmMJbfDYyrCg-MMzmYeb0XQv6u8
X-Proofpoint-GUID: Oaa85OmMJbfDYyrCg-MMzmYeb0XQv6u8


On 15/11/24 2:51 PM, Greg Kroah-Hartman wrote:
> On Fri, Nov 15, 2024 at 02:03:36PM +0530, Harshvardhan Jha wrote:
>> On 15/11/24 1:58 PM, Greg Kroah-Hartman wrote:
>>> On Fri, Nov 15, 2024 at 12:30:47PM +0530, Harshvardhan Jha wrote:
>>>> Hi Greg,
>>>>
>>>> The patch series is fine but I missed one final patch of the patch
>>>> series. I'd like to send a v2 if it's possible. The series is missing
>>>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=35770ca6180caa24a2b258c99a87bd437a1ee10f__;!!ACWV5N9M2RV99hQ!Jjv9Q-SraAFRWb-CchHiy6wbnrShMziEurtSW12w68rZFsd5FNRhQcNyXIoCxB3oCw2J7dFCD3VnmB-poyn9n9xKb-xjvg$ 
>>>> unfortunately which is the fix itself. These patches were required to
>>>> get a clean pick when backporting this patch but I forgot to send the
>>>> final patch itself. Sorry for the inconvenience caused.
>>> So can I just cherry-pick that one commit now?  Or just send it on and I
>>> can add it to the end of this series and do a -rc2 with it, which ever
>>> works.
>> Whatever you feel should be the easiest way forward. I have a v2 for the
>> entire series ready. I could send the entire series or simply just the
>> patch to you and you can add to the end of the series. Please let me
>> know whatever is fine by you.
> I just grabbed it, no need to resend anything.
>
> thanks,
>
> greg k-h

Awesome, thanks a lot.

Harshvardhan

