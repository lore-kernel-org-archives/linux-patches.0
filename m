Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C713BAF1
	for <patches@lists.linux.dev>; Thu, 19 Dec 2024 06:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734590188; cv=fail; b=rrI9dlf/3XuUGvpPMb0ZIQgYgqLBu4xo7yMg7V5LrYy6KDS+HYR+KmbVCaf5hA3BgMA3GquaOxGtttyr9r3Zr3bENWu8/OAOviFn0zfZCzP3C9us/mVAlnJIl9A7yZTQae63uELM/dTLKJYdhNPRZ1QxONYjNKmTLAuja0mQLW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734590188; c=relaxed/simple;
	bh=FzV0rtSqJhMrG3z6YwY7SeDnhgfs6DbH+TOPmOqso8M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V0sNnTQz/rknCDxhumzG/wxmtF6LgBhJ5QKHWaR5pGR2MPzfQrZKprd/CTdxTvWGcoKLJ8Hu76NqkFK2kFCSqm4p/3+4yYEmxy3YnAhJQMg3BhfN7AuuEAyc54kj17Ugr0pbr8VNWwD/7/AJWVcbpQYzHmPV+OJpOHgoKDxqMMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dJj9706z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hcpEKp/U; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dJj9706z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hcpEKp/U"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ1gefS014246;
	Thu, 19 Dec 2024 06:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=GZrXFuXehjg948p90D1LKABG0yaC/CXUe+Zpt6A6hZQ=; b=
	dJj9706zk6Fd11JSIo79ZpgrZf056RBmxA7RaQkn7S7cpQQYhFHaZgSLZqJSNiwe
	ZgtDwoFKwRhLlOsZlDmM65wvFUzOcIYyCH2NMxTM7VaO/clo6ZXStNft26+kPjgY
	sc+r3APM7/j/y4kLBmgNStauysUaxA3dBJHPW4GMP6ntToxeVUt4wuEYwgZbrKUL
	vXt8kq5RHgI5qKL6g+VPF4tu7oAaIWLM5tiGSJdgpTf75PA4/g7yphSJ89ir81w3
	oQRlThPJyt40YemWKIGgGOz7P9x4oeIx1M4Iq+CA/iEQ7c/WOhg6G9zrld6M6RBE
	y9pkplCq+i8xFHIvNygV+Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43jaj5g3f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Dec 2024 06:36:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ4tFlT000562;
	Thu, 19 Dec 2024 06:36:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0faxgv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Dec 2024 06:36:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyRd3bTHawEL/qvousykRqrhrBMnY+WUxsTfj2Ga+Lab7bh0iknyVh/KZp3ti/vhBEkeeIRvY5FmxqnXmK1vlHHgXwNRxuOfhKhknf8EJXWWaYLHN7RqSSCxoCI0b/B0Zlxz3Ry2xGoqxM/Q9bxMVh0aNJ//69ROuO6QDiNSUshci/CQQUt2uVTjHpDKBBy4Cu5W0YO+7WoaNmSJfGo8AxIVhJkq3IKPGYjp/E5lUDK8ogCV8dfTg0MS4P+/+Frr2K2ZpeuehQKYAhYRRqlc7qqj/2HYI0391tSBUvNBrNadurJe1HBkwHvSkzvVB3zZJsPhpjo0r4YSwbeMzycqrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZrXFuXehjg948p90D1LKABG0yaC/CXUe+Zpt6A6hZQ=;
 b=wZtiA0xxyiSVhDhQT6KGP+mEq2HQA9KgAFcAhs+6KDf1seWilS2TWosjts38OMJau26GeKGtI5Wgwz+j5X57GcvjetxsLEK0hFUZaPwa3LDS0UsaqdQwdTBUCjQpgTv1Ontfsgbn9A8wZgJlOvJ1spVB8XzIkKUqJpInqi8esSuWX8RBj7U+GCGhvdJfwJjp78i8gET/r2O5sjked8Px4EeTnjz8SyvXbGAYJHRF6h9WZUovRtCBXjr46nkAqSWNAQOOXq3HXRdRZeJu/OepxxH4g3fptO/8GoMB1OyiRXqHgYBvi6M9MW1a2x4Tka5ZBYzdtBm8eGjv2dVEOwwhJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZrXFuXehjg948p90D1LKABG0yaC/CXUe+Zpt6A6hZQ=;
 b=hcpEKp/ULP00V/ahbCRqic2makoGCuju4dPngINf59jGfSPnN/ws78NoyJ9NNJ6q/AVz5nBIQXm9BVSAAtVmSpKhSTvtp5JHvWMtLFlvbu6lMfucNAjjM/I9aEbh9paPtZDfUaWGMMJcFKg+vzwEN97M73T+z6qFWTTsE5+GaJ8=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by PH7PR10MB6579.namprd10.prod.outlook.com (2603:10b6:510:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.14; Thu, 19 Dec
 2024 06:36:06 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 06:36:06 +0000
Message-ID: <f8083d59-7f38-4f12-9b53-1ad0d2826a4a@oracle.com>
Date: Thu, 19 Dec 2024 12:05:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241217170546.209657098@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0021.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::8)
 To DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|PH7PR10MB6579:EE_
X-MS-Office365-Filtering-Correlation-Id: e48f2935-831e-4b85-e8d6-08dd1ff76a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3J0NGVOMXg2MUZoeHgxaWwydzVLMzdmWlJSQlNjTXlmUytlUnhWUXhuT251?=
 =?utf-8?B?N3VKaEczbkw1S1h1WnFkcnFxYkhvZkdENnVWMWJYeVdVYTdsSUc4cyt5Ym0w?=
 =?utf-8?B?Z1Z3Qnl6cGtSY0RBdVJOZzNhMGVPTjZWVXRkVGVGZ1JIcW1tdlRENEVrbFFn?=
 =?utf-8?B?SmxXRk93ZjNIRjNGUVZ0dk1XcldUSnViakgydXpRZmU1K2graXE2NklTeEdU?=
 =?utf-8?B?WGw3TkYvek9PTWtIY3ZHajFLR2FtdG9HZlFueE1pZmFMRFpYcXVOOVRhdTEx?=
 =?utf-8?B?cDJwV3JQSEIvZ1QrSnB4ZEFOQXY5Z1FIRkdML0F6V3g3c05kMlpsNldaYmcv?=
 =?utf-8?B?M1RpM3FIOE04WUpCRGUrV0N2ejlHUTQ1SWl2SVlwMHpFcG9heEluUEFSb3Bp?=
 =?utf-8?B?Q09TeFNUaHIzSkxZei9xZHRoNUtVREFTZGFySk1kNEZPbEc1bnowUWRUcTJ4?=
 =?utf-8?B?cDBkSXpXMGRQMjRibzZSRzJwaStTNW1FelAvWGRyV0xTQ0prME1CbG9vRUQy?=
 =?utf-8?B?a2wydnVWNXpBTDlWNGhoQ1l2R1VpL0hPUERZMVVXR0lvTkV5TW54SWsrZlBk?=
 =?utf-8?B?akYvTnM3cUFLQ0VaODlBKzhWbmJOZm9EWXF4TFBmMGpZcFNZQjIxVzRNZVdj?=
 =?utf-8?B?OHJrekdSTnE3V0hpRTdUcWM5UGFCd0taM2RWMkszSU9qVElUbkJhM3Rha3A2?=
 =?utf-8?B?T2w4d0ZTelRsV3p5K3dYYkxYUEhTRldUblFLcStVbEFwQkZaS3hMSytOMmdL?=
 =?utf-8?B?aytFaDhBSWlYOGNBc25ncDUxUzQxa0NKRFJaUUFub1Fvei9ra01JeDdlY3JX?=
 =?utf-8?B?STBOTmZqS05xc0JkbHdUTWk0by9SMHg0Q1U5ajBnUGhXZ2NhTGloWXVxR2xT?=
 =?utf-8?B?dW1uWlhrWG5yMWdscnBySW1XWEdJa3JBOG9RL09VR0hLSzhrSkFSNDVjQ1NH?=
 =?utf-8?B?U0ZpSmtlUkh2OVU1bVBIN25wU2VYYzh2NnZxOWFiR3N6WlZldTlUWVh1MUpC?=
 =?utf-8?B?dHZvQkNvWThWQzNudkRBaWFHdVhoV256VERmbDBid1M4aEZhVUZsaDV5RzNl?=
 =?utf-8?B?V0hyNURxRHNCRXMwUGtTcWI2aWRZR1FWbzVhN00rS0JmT3l6ZWVNYXdNajJG?=
 =?utf-8?B?SUFseVgreWtFd2tKbWV6RzFmeCtJRnVvL0dwZjNQdnpLaFNWc2pjSVZGN2lv?=
 =?utf-8?B?RSsxVGQySk0vT1BCRkZFUHlTalNibjhneUxlVXJHR0ZwTmxYRVVZWE1PSm04?=
 =?utf-8?B?OHQ0eHYwRHMwM1VSU215N2pzVWNoN2lhNUg2UjNjUTcvZUJyNFhKalZyb3dh?=
 =?utf-8?B?d010eVNVRnBwY005YXNvSHNWMmh6MGV2bitPaTU1WnEzelQ4NXZLMEN5SkVD?=
 =?utf-8?B?VFNPdXNhL21XcDlBV0VWVll4dk9GdWh1VXVkekNNMDFJVGF0Z29rN1oyc2dR?=
 =?utf-8?B?N2dPVWtueUI5UXk5ejA3MlM5QlZxZFE2WVdseks0dmdXRC83Q281bWdCNVA4?=
 =?utf-8?B?NVZHYlQ4VUxOTWRjeHRncmNzTTUvRDY5dCs3cXFoN0d0UzVBWFN4T3kwTnFJ?=
 =?utf-8?B?WnZKSHA5Z1ZMVmdNOGpITDJTSjh0MU9vSjVKRDBLcTBuMWl6Z0ovVXQwcHNL?=
 =?utf-8?B?U2Izd0lBM09mckFSeWZVWUp1ZlRzd0lvOTM5WEpxM3RKT05XSUF1aW40NW5l?=
 =?utf-8?B?SjU2NGY5M2JFTVByaC9hemNQM3NCYUxkRzYvV3R5WVY3YlBicmc0OVZoL2hF?=
 =?utf-8?B?RjE0TmZLVGlNTEpYQmZackFOdHhzU243NHFiaDhUQjFlOHhLdEVoZklibjNs?=
 =?utf-8?B?TWpQNmlMQk1SWFpTR2hhOXBhT1JsSFpMZmhOb0ZJSUU3bW5sV1JmelN6dldH?=
 =?utf-8?Q?3o5zO2kYkFlZ7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NU9WN3pJbWRDQ1BGNnFDajgwNW5SOEptOE5aWGp0Nmh0SjBHdEZLZlhoRkJy?=
 =?utf-8?B?b3ZlWkpIWW1iZTkzdVNndm0rMzRudzJsbjlmZ1J5clpFUENtRkFrR21rMjN6?=
 =?utf-8?B?TkZKTHNKUnIyU1dxMDhkS09tL1lmMlEvSzlQQXcwblIwbElXSVhtcUlDVkty?=
 =?utf-8?B?THlRV3pydmF6WE9qemlHL2dWdlpFU1doYzRpZHV6SHFWakVleWlCTEpYc0FX?=
 =?utf-8?B?aEdnV0lJN2dDQ2FFRmIvUEZkbkptTXlIMUNscEJzVEtIdUNORnJET0Nuajk5?=
 =?utf-8?B?eHlza2wzNXh4N3RGbzVmZklhWkdyT3ZkZmh6SzI0Tm5jdVIwaExnRGN2NHdX?=
 =?utf-8?B?VmdicEo4UitJekpOaHVsdXFXU1pKd0hFbXZtNll4dzlNY1dJWTJYaXJ1MTR3?=
 =?utf-8?B?YXlOZGZiVCtHbDdxeUN3WkhJSWhuY25CMm9nZGQxTllMOStSUkNhT2VuR29p?=
 =?utf-8?B?UHBORityUTdMdDJFTjBidjY4RTRtT0FmMnIrZ1BIaXVtL0syV2oyVGE2cDZL?=
 =?utf-8?B?WXplWEFkUTdHODVFU0IvcVNVcWkvczRFemRyRjRCSnZzMUgrUDF5R1BSbXJB?=
 =?utf-8?B?anpQOTlTWjlRcXN0RVozN3RWZnhPQVFsanZSbFEzWkdPY0FkRGRMemFsQWJj?=
 =?utf-8?B?ZDQrcGhmb1crVU9FN2wyNm1ISTZPTmdVQUxmM3BWbTY5TVU3OHc1RE4xTEhM?=
 =?utf-8?B?L3JmdUxMcEtLUXdGcXN5WkJuNHhqbTd0MkZROGdtcUp2SStkM3VZS3VqVkI4?=
 =?utf-8?B?RjdkVW1CNzR4eHBIOWtuT3JPWlBEZ3ZSZ0Ntb2QwNkUrMUhIYm96R2VGOE95?=
 =?utf-8?B?K2huSitRTVdidGQzWHJxUWRIZm5JQTRiekRmRWVQVVlvWDZvVWY2Y3pVeWcv?=
 =?utf-8?B?azdFUXFLb2hZVERSazdpYm1XN2ZhVzV4dzBJOHh3Q2x3WE9DdC9tTmgyWi9r?=
 =?utf-8?B?cjUzbE5BU1BhZkt5bzFwdkVaNFZQWTFVdFZodUNnMFltdkRTalhRVXprN1FL?=
 =?utf-8?B?L2NvOWpySjc3NW9BbE00Y25rR1pLdWF5UjU4Wko5K1hyQWxxd25OY1NFN1Vw?=
 =?utf-8?B?RFh5U2krSWtpUTZpWGxDQ29qaUZ0T3YzZnh5S2VUeFJsNk9SYTZHLzVCMFNY?=
 =?utf-8?B?VkI3Nm55ODBObkxyMUUvMTRraG1rMmkrNUp0NWh2RXRZSGlodTlXNDR6Y2ZO?=
 =?utf-8?B?NTZacUhYeE5rY2tPUzE4dEo5enIwR3d1OC9wRlVyQ1lWQkE0NDFBbnhTNGNN?=
 =?utf-8?B?dk9XK1RmUWpvSllyNkViN0R3UGtzM0EyNFBSM3FDZXdVUVY5Si9PT0JOcHVB?=
 =?utf-8?B?QUFpZnVQZkE4MkI4Ymtla1lrc2ZmYnpxZVliWUdQcjNkNlFGSkg0Y0hBV09M?=
 =?utf-8?B?WmczTUk3SVdXSFFucnJYRmx6UmtBWllRMWF2TnpQME5mM0Z6RDhidGR6Rnhn?=
 =?utf-8?B?bThZeitRUDdUMVpmbG81b2xPZVh0bkFoN0hsT29pUkNmYy9zWVMxbWljYU9Q?=
 =?utf-8?B?R2QyeFJWMnZ3U2xxVlF3bDBrMUVLZWtUVVd4UlJXZkkxMVhheFlkNDRxRDZ2?=
 =?utf-8?B?cklpbk4xZkRhUzMveVM0cGxaaW00Q0VMbTVhZHAvZ25IdmI1MytRRjRPN1JF?=
 =?utf-8?B?ZkRCd3F2SlllT0g5enBNSTNlanpLUTBocVJoRVp5RXV4NmdNeHlFTVFJamNn?=
 =?utf-8?B?QmVKNjhzeUY3U014YXloOThPY3RmNExEWUJUN0xWWXZHeld2N1pCZGNFRm5l?=
 =?utf-8?B?SG1rUWptUjFVM0ZyQlRERzdKVFpZZVFIcmNFSnduczM3KzJjYllUU0c2Y0FX?=
 =?utf-8?B?MS9MenlLU1ROdURwSllLdnU3VjRuYmtTdHp4bDNzWHd3Sitia1RJK0NIaDFF?=
 =?utf-8?B?Z1V5RlJaaTF3ZXpIOFUvWmdpckRsNnVYMUNmZUdRamMyMVZwSXZrUzkxWDk4?=
 =?utf-8?B?VGlJL0FLR3R6dnBGdHhlUDMwWnUwZDdkeWdKZDBKN0szOFhuWG9XOU5SUThU?=
 =?utf-8?B?bnYwV3JLQlBjcldQOFc0VG1PaTNnaXNmVTloZDZSNUoyZStuTzFyM1Q2VmlC?=
 =?utf-8?B?K25NN0ZjakVqQlYrbFplbmRUbmdjQWEvMGRIeWczRGlpdDB6ZjY3bjdFVXBI?=
 =?utf-8?B?aHJ2OWtwVGx6SjlIZkx1YUtTUCtYL1A5MU5FdWRMaW1uNzljK3hQdVpBNGZT?=
 =?utf-8?Q?gDFjhElCVFgIj57T685fLPU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+E+EImu+GOThQqEQ1J/0ktLnEnrhcjPmxHJBEE1pdYDwCn+FfoBkNdITW7H33VcyhLsCAJMKl2LTSJ7zdH6h15SCFL8Wd6K0H2vqn1jijPMVZH7vl07t4NDZzgrJkZ8f7LRr4i6me5PVD+IWPMFNevkckB+liS6c/W31K6a1/mlp0dMiDInWOdZ01Ake9IZXJ1JcJXz+BUiWHt/V8NarudEBdw3T8al1oZfCOrVkjhfiAuvO/dtqBT++llA2l4rdDpCmChf+OMbzMIuLnaI3LFmvB2CtFub2R5+PZ1E13g1XR/SV/f1RQaWdyUbzPhcp+l1oqdRGtCYboskGgFfqI4CfR0wBNAhjzQcGo0L4ItGZWlTMyCTO7AT/zESuCciGpWhK1whe3/LC1BBLD2aIZygyFVrP5jBFJmAHcyZp9MYKKhoSiu/wz4DPaarJpDfJnyRn1VfxOW/75N9h+hZPd3lzSTKTKXjqfjn2vAdk8U1hYGLqnNiK8cWXqMNKFNmM9WRp5xhnNSzC/OwvEmIE81aZnI5MCEB5el+akMbxB4jF5ZAU0WJ2XyEMioywdTYoUoYOj3zTEIvf65iSQlqMTmjPBuPHSnnR0dMjuJ/xHaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48f2935-831e-4b85-e8d6-08dd1ff76a8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 06:36:06.4662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNkVBGM+Lg8V1YqaRkDaaIJbT1StllqJlxMTVx9GL/p8SJxVmrt/dPopibDOOVBqt9KapGc3hFJEFBEALTN8nsVagnEe/bre9ea+vkdbugE33T5Cw2gwvSNt/G9nwJ9u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-19_02,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412190050
X-Proofpoint-GUID: dAfpAIOZ8ZjsS1gVblH34ikXKlZbu36z
X-Proofpoint-ORIG-GUID: dAfpAIOZ8ZjsS1gVblH34ikXKlZbu36z

Hi Greg,

On 17/12/24 22:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.

We now made tests for 6.12.y stable rc testing ready.

No problems seen on x86_64 and aarch64 with our testing.
(Boot/ Install/ LTP so far)

We do see some problems with failing kselftests, will investigate them 
and report them here. They are not specific to 6.12.6, most of them were 
reproducible on 6.12.5, but we will have to look at all of the failing 
kselftests before reporting.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
