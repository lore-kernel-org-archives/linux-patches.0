Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B44222596
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 05:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738819287; cv=fail; b=bFZ/G73N2zEy1feZm5nK0Zf6sL+ZZlfvoD8qMQQY6f3im+WBpM+Ui+nWCDEqQ0RWx68XmqFfmUmMpmE5ggooZYNj1NtOO3J0tJDNDCFKYgTPjQbwWEkDdiAcbUFSeGeVFn78P+BfElsfsHk+7C8IsC/v8i+eRp92rnFb+sdITN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738819287; c=relaxed/simple;
	bh=RgG8BaPJLOhjX2Pb6jRzrbmJS35GDH+LhxgOSZHAEyc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ST2HxHyZMZDfNnqZENFJPXZ/zlIphl1BWiC3Kw9x5pFJnCPcmd76y0Jku2DSucITLD7k2OABH1OHeyg9nfPvmsUvzQOV5OBrYJEmcUKJ9md97qCAUZPAOVgEIHioeH7AOXCXCkL+AdLdtHi+6gRzvHShlUMn1z5qvpV6KrhxO30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fJ62Uygy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BjQxvBQS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fJ62Uygy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BjQxvBQS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5161frC6003933;
	Thu, 6 Feb 2025 05:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=NuWB3nr9aFUelh6RlTyd/wPTqab6XLOokiJLiXSppNk=; b=
	fJ62Uygy0uEzs4D8jD/LJO2Qi5gi5Zkv/ephrBCF0IEox2TdcJrahBiaUpcsgg1K
	FWhCJzzOAImQh5ZIDIjtR6ZJxDtKs/5JMpoPMBFOKea+gdcWvoF6ScFQ2VRASiRU
	V+ZAlOcqK1pjZ2zWgar9VMbzRHSVqRIPrn9a6UR6sB8AhtlgrpUwliRNGDxxiTev
	FVfXCNhQcwwLKjQzPoNZfsUAXH715cF0/2Fvephp1RfKeylJ/SirAQyADqxm9czo
	5JDLxkJ3fr1k8XnmeT+xuhfJDlFWa4FsJepBQmY0459/DhLzLN2T4MeSfoh7ioYS
	oaEUgWR5KwTtQi2ZVJZ73Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhju0j00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 05:21:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5163inqw022622;
	Thu, 6 Feb 2025 05:21:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ea15t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 05:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOR7ryOt6NNIPWCO1go6Bidzyz9tK0Xvq382tyGkYDLyp+F2QaaRDCGDlbhv+9CU4sQDUW44ScUO9JK8V2kD3salWpkzEC+WA50Hkye6Jiw6pdUZPwlvo9bmdFMT/xJkPjaYXJ+qK5D8sOxGRERk/gwikrfqhVgnREkyH9QhTQxbTPOb9ELuAiepK5mJPiZRAYlj0Ghmg/6yky5g09xyvX5GMwnGOYGMLG4PyrdSC/7YTMi9sNsVXjHf2kTjVGytloNobxFgy3JhIc+7+7OEy7k+rJEoFVJigl4b5fHR1B3mgX/iv3qIywhXeSPnbsgUsVbgFy92CL0bRMpbUgRMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuWB3nr9aFUelh6RlTyd/wPTqab6XLOokiJLiXSppNk=;
 b=J5fk03MIaTH2a80ZMt8Z7+GnbfK/wh0bieHdYlkt7rrXD9bD5OGCh9ej4EykZ5kDNAWEBJVROCGJHPtVbfyE/wkIZgOLjrO400qOre48G9qXA3Sp/PMfgExIrGu9g86QeHSjZ8FfNk6XNzDSANMLYT7+M8if/XpXUb/ogeU/gLKqHke54gRNsogorJytYudVRvmydPu4Bs61gJ5t+MnOlapgLoqTUq0OK5fDBYFVDQEgSDuxhm57cW87nKABc44glif6sXc2J+Z1YDYo/OlaIcW//qbUBMB4QqurTw3x4/EbgPyDi3aiTWyAu0X8BV9dznDCa2SspjlsCiRvmKbMXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuWB3nr9aFUelh6RlTyd/wPTqab6XLOokiJLiXSppNk=;
 b=BjQxvBQSxi0ZsOZ7jTf06unMPsvYhQJt3g6vo1w5noUfZXe5HP2K4/aC5TV+1Phv//etcwv5vtAYPAQKwqyXzR1GL/XIajky0vb8/TL+Gq4YbWY/5kLy0X0M537UKoooaNh2mJDH7Wt9DwND3tlIP4gL1jnKVqdq8ZgpIhVol6M=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Thu, 6 Feb
 2025 05:21:11 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8422.009; Thu, 6 Feb 2025
 05:21:11 +0000
Message-ID: <2beb334b-ffb0-4dea-a12a-3843f72e9dba@oracle.com>
Date: Thu, 6 Feb 2025 10:51:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/393] 6.6.76-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250205134420.279368572@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 83494f81-61d5-476a-87e4-08dd466e116b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFFjQ1BIRjJ5VUV4VEpJdDhwTnEzcWtEM0NvMEE1ZTdDYVdhdnA0akRpVm1u?=
 =?utf-8?B?ZFhNSXdPOHNQckdNWTg4ZU00UGVKV0ltcUNBSGJiMXo3VStWZXFMemJmZS90?=
 =?utf-8?B?Um00SWVvelUyQlFhZnhlNE9xT0Znc2tkQk9JbnVHUG05ZXVTV0Y3SWhrczVC?=
 =?utf-8?B?V0RGcTJZVjhqL0FkZmkydTJBSlFrUzRMTkY3OWQxb3BZWWhYNGFyeUFCUUR6?=
 =?utf-8?B?NFhCZytEdnRzOUQ2MGJkZmhDQTZUdDVoa2p0alU3VFhORlgrRVFmemNvYVRi?=
 =?utf-8?B?aytEZzBwanMwZTd2bDZOdTVtVnd2OWtpTVZRbG9tSitMNUVSRXU3cFNFVHkw?=
 =?utf-8?B?V1hOeVUrQlJwQlN1Y0ZrakFjUU1YTDFjM1RSMlBOL2o5OGhEMTJZSlV2djhZ?=
 =?utf-8?B?N21DTkN0WURFS0dwQ2s0bHd2a3MvTUkrblNDcVRiMU5KdEJ4ZUZyNW0wcjNl?=
 =?utf-8?B?YlhLcm5JZkxSWWx1cS84VFE4WnBnVmgxZWNzM0pjQXF0d3F5RWZiTTNXY1lP?=
 =?utf-8?B?Zm82aEtEUWYweFJIL2JSK0RYMDN0QTRVWkwvUE9NYSsyRlhCRUdRejRUL3R0?=
 =?utf-8?B?Z2JtdlBwR0psdTFEb2JtakpQOCtoVkV1SE8wMFJ4cmZpam1yVkUyNG9TYXpp?=
 =?utf-8?B?eisxVkVUd2JGYkFWbk1sQlB4azdBY3VZRXJlVUJFTUJRUUJzREZKR1FHT3R0?=
 =?utf-8?B?dmtFcmxleW4wRzJ5UjJaOG52MVZKVE5YVy9uZUxRbmJrRmFLUGFGbnYxQVpp?=
 =?utf-8?B?alBjdEdCU05NNDNJazZhc01vNGlRKzZwakV6RkVtMThsQVJkM2lkTVE2blRF?=
 =?utf-8?B?SFhXVnpDVTU0c1JyYnlYWExOWXNxWkVyRlJnKys3WitMeFBUaTY2MFl0VmVE?=
 =?utf-8?B?dE9qclJBNFZ4R0x0SG0rb3ZUNDZkT3JkN0V2VTVtSFpvSnIyQmRwRkVZODVp?=
 =?utf-8?B?R0FkaEZVaGQ5YVpvYmRSb0FyUjlpQldacG5vdUJUb0ZVbUg2UU5MblB1M2w1?=
 =?utf-8?B?NEhOaWhLMDROWmJmSVpUd1BFV3k5ZnIxaWdnUEVlci9lSDFLTHU1NkFnWVdu?=
 =?utf-8?B?N0J0SXBGV2Z6WmY5L25QckJ2cWZJKzJrUzhJdHE4LzdMWXhtTlFsUU51azhY?=
 =?utf-8?B?bUVMVFBnNmR4VHJITzZGazMrbXN3OGtSN2doSVRhUzhuTzY0MlVYd0laZnU5?=
 =?utf-8?B?cVpOMkhRcVlZK1d1SkFCU21VeDRnS25IWExmUjEwVUJ1NW1kRnl1TGprK1E5?=
 =?utf-8?B?T3B0M0pZTk1GRktxTVlUTUZXQmZIS0lSRkQxZjRxczBkTG9Ld2FyOXRaV1pQ?=
 =?utf-8?B?cDhHdVgxWW1DVGpJUXlWcWkxM21KNG43Q0lVQ2dtY2haS25HYkFTMDl5VHZT?=
 =?utf-8?B?RjNRY001SU96MVBobXVDeDliNGJMdysxOHdTaXBqV0NhVXgrY0t3YmNaeGg3?=
 =?utf-8?B?anc3WVNwVFBxc1RaWkZ4cnpkekxqMjFLeVRhUlVXSmlmamFoTGdpclVUTHZr?=
 =?utf-8?B?ajI4SjF4WlZ5RjN0T1dwTE9POXlFTVdMK0hnQjRicVBuSVRHeThQalhzRmlQ?=
 =?utf-8?B?aUZBOGNDZVRtV2w1Sms4bExpdkN0TW5aSFR3YThTc21LaThIdFRyMmpjWUl6?=
 =?utf-8?B?enFCbHhoM3RTajFveDVBNFZPTmljdkxMWkgySFEveW1UWWY3OUFnUEV0VEZR?=
 =?utf-8?B?bmo0c2xTdDk2SnBKSld0MS9mT2tJaldVQ29KQVFReitGUC9IL0MxRDMyci9R?=
 =?utf-8?B?SXRvU1JpejhuMzZmbkhVWjA4MFNUZ3R5L1p2VUNMNG1SaDF2NTZpdDFKdkw1?=
 =?utf-8?B?eksvTlo5ZitoVmxLTWsyY05hZGZvemU1WklDdVIrNThhRDVrZjlUK2hISURv?=
 =?utf-8?Q?KfOE2ApcNwabP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXdtczlMcUx5Y24yOTBadW54RTd5d2JOWFk3YVpBTml1R09CaEc5aE5qQkJu?=
 =?utf-8?B?cjJQbFBXN1FlNmZNdUlCNCs1WXIrZU9sdDBsSlQrdmV4V3hRY1VVMFU4U1FU?=
 =?utf-8?B?cEwyYkVERk5GWkQyTVRtakl6Y0IwSUZCa3ZTdE45YWxBRjNzRFBmSlp5bEt6?=
 =?utf-8?B?eW5qenhvSG43UTJ2Y1hiTTVza1Z1Z1dYNGpwZFJISXluOXRLMFhpTjFjbE5W?=
 =?utf-8?B?RWlpNDJMelBOdzRMSE9aVXBBdXFzT2NzajFyc1NCTWJ3MFVweG44Ny9NZGU5?=
 =?utf-8?B?UGVQUWpiSXdHNUJIaWhWTjhEL0dFU1hFWFRYeFByaU5PdlBydHhpRksrTUFH?=
 =?utf-8?B?cHpBQ2xnbXg5OVEvTTNSZkZxdEVOdnQ2RnFoZkdzQkxja3RFVWRoYjVKWEJh?=
 =?utf-8?B?bVZPeFQ5Mk1yaWs3ZkQ2aDZuVTlBYnorNnQ3eW5GSFU1WU9ZOUJIdVQzbE0w?=
 =?utf-8?B?RzI5OWNGUlpMczJ3TmJFZ2JlUU5zOEdwKy9tdDA0WHJhelRxM3dGNjY5K2xS?=
 =?utf-8?B?N0w5QkZrYkRJRnJGVTMxRHFGRXZEbTlValphQzFhMlJaaFdLUC9kM0NoZGp6?=
 =?utf-8?B?bEhyMEZxY2tGOWY2UTVOMzZCU0Y5dHpzaTExT3pmdWUrQ2w4MWJuRkY0bmNJ?=
 =?utf-8?B?UTBBWDZnZFVoVUxGaFNCc0xPb0VFTjJzemxZK3dubm16S2pVMmtWNks1ekhF?=
 =?utf-8?B?dXBhdXIyWmNueExRS3FUQkptK1RxOGFhaUtTQ3VkVGdGd0NiMnBKWW0reGhu?=
 =?utf-8?B?bUNtT2ZaUjUyYzZSNFRzcVJlMWxvQ08rMzFrS0l1SXY4eW82a1pnWUx0Wi9H?=
 =?utf-8?B?eTBmWGtUdk1XeERBQ3FiUHZ2TzkrUDYyVzBTT3RraXZJQitJVHZGcTVlQWZF?=
 =?utf-8?B?TWNjemdWOU1HSDl3blVyenBnVmppMW9YeU9NdDMzcEFKUHN4SUxBTkJ3OGlI?=
 =?utf-8?B?TWJVeEZKVXBpdXRrVGw1MW5NeURlemZQQWxXRkhiOHpsdlkwTHkrZDY5WDhI?=
 =?utf-8?B?bFFsamlmQ2tEQktSdHpWTytYUlpYZlpYVjN5dW9hRlR3U0dpcUUyc0FIRDRm?=
 =?utf-8?B?U1FKdzlmcS9Ba0U1UldwTlArclNicXhWQ041aERMSisyNmMyL01mZ3lnQUE1?=
 =?utf-8?B?TG9GdkF0d3ZoU1MyaGVzd005YXlhSFBYMWxtaHNOTDFkOWo5Yzk2ODV0a1Q0?=
 =?utf-8?B?eDdIZGN4akVXZXNJSHV3QkZkZ1FkOGtkV3BHOERheFRFWWJKQ2tIa0lnR2oy?=
 =?utf-8?B?NzIzUHlqNUtmck12djBpWnFPMk9sTHZQa3VnR1h5cUdwekJ5RkdUcDdWdktG?=
 =?utf-8?B?cForak1vRWRIR1BsZzVxODJDQUl6T1E4RkdhNldQeUp4Vld3MGw3S0UwSmRv?=
 =?utf-8?B?NkJyWkkwM3JUZi9oMmJxdTZKTVJpWE81WFdFbWVZaW1oVTc5VHhhbnI5Q0xu?=
 =?utf-8?B?Kzc2d3BkUVk4S21ZYkhSeHBqaFhQNVdKMmZTRGVicWV5THdYZXZOUVI2Z2Fs?=
 =?utf-8?B?OUxiZHcxSzFRZ2IvVTVqUXp2aVRIcTExR3VrWXJHWE94NG9ZMGhrYk1GMlRx?=
 =?utf-8?B?cnRYdC9ESVJNbW5XQy9CTmI4NDIzM0pFK2dZZTlUVklKbm4wcUVhSkgzaTZN?=
 =?utf-8?B?MW84NkxoZUlrRVFiLzB4dHBEUnMvcTNWM1FPdk4vbVBvK1U0RWcvbktlaVFv?=
 =?utf-8?B?WkZrTVc5ZllrKzgrb2JaYTFuQytpVlRlZXo1WUR4ZGE0OFdZUUc1K2YrSFha?=
 =?utf-8?B?WXd4YkRpcWx0Ti9WMGhEKzIwL3dZZENVYXJydS9iVnl6MVBSS3I2VmtQUEN2?=
 =?utf-8?B?Z1dHb3dUcFVSZ211eVR6QTc0bmxvTFFPZjdZUDU0WHFXYk9oN0Iyd2RJS3gw?=
 =?utf-8?B?MUsvMmZ4T2NyTTRxbDIrTG5LYWF4WVB6MGVEemdEU29Nait6YVNQcW9Dbm5M?=
 =?utf-8?B?SEFpTFJucDZxQ09xZDJVV2I1N0daZVRIMVAyVDVWMDVRd3Y2R3ExVDFPUkcy?=
 =?utf-8?B?V2o4V25CNGFEWXZ6ckpnNDlydWtnTWdaRTFnR2FpT0YvT3hteTdyMnUvWFIw?=
 =?utf-8?B?WFM4M0NKSHFwc05XMEtGRDh2ZnFPc1BEVmxCUHBkd0VXdnd3Z0ZLUXRla1p4?=
 =?utf-8?B?d1NIWjE4SHBzc010LzRKMkQxb3Bxc0Z0aWhTMjMxWU5aVGZxRlRkaGRML0RX?=
 =?utf-8?Q?F522/v/9mJR5lfb6g3tesdg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rgEG3BOAVf0R/ETY/vBZZE5x6JY3+ewAh54+aS9mpu2RSYjkAswvdrUsAynQOQsg5ycJ1cI0GLqd5CJHEjSFopkL9uicn5Yiz5Cup/voqk36XkAQq0OrG2oAcLrhdiHU3yrEVWO/hBz3lv3Qv0ReHSGMVnDc7A2ll+rZlMWo1jurwkCnPMjMS5U0W98DGBB8nAKLflokX9LrGg3B1LwIS9z/fKd0Y8u7lbLgbrabzlzPxOm6vZd/3+AFpAeTippJGY/ujO2jQHwqjltAZMnFeat1IrD58VIyCi6PabcxiVBzU/bgd/5jIMdYoAB0IwcywpX3KvMWjefuFY2/vm3AOkz/08+W1d2a5XKdwLQjXUz3FqbYHYJn2ARuhiiSKJHulHmPAOBK7lbfiW1O4V6/+anjj6RwA83HbIGYCXxEob4HV5baqu0uNo4GKgP2bn0X4ckv1bZXy3PS9yGpdbR1FOKCxmmUWS1XNA5wDBkvb7ej/R/26joBZVFbm3KN7L/+F0Xhu/LvSjCuMtQPxzpJor57JSPkh9FTczAnBuk9pRDquDFY0ckWQnRmRWvVKp2FWxM9+aLfS5sdSMRWxUgjLrfNe5xVqtSOENZV6V/Xd10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83494f81-61d5-476a-87e4-08dd466e116b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 05:21:11.2232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJ6sFQBN7X5xBXyZ0Ak6Rx0tiE14ZIDcs2o7RLZ4opdtYJfzagd2tei0huytBJOcr0K7gTkwfVju7x5lMNZ55qE9A9oIvs10yoy4xhidocjEGIW91fXwr7h6Kyrf1amJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_01,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502060042
X-Proofpoint-GUID: 85VzhaU8ZrbyUXzvJhFxBG_YIz36zJ_x
X-Proofpoint-ORIG-GUID: 85VzhaU8ZrbyUXzvJhFxBG_YIz36zJ_x

Hi Greg,

On 05/02/25 19:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
