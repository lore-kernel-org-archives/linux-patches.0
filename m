Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD56B20B7F8
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 08:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737619780; cv=fail; b=JTbA9QtaqT8PybmIGlzYFxIZEOewMA08Z0t38bjDEbIHrWk/Cm2a50NZQ3rvnbQ0GxMkLnZuyKq6WmMabLuX1zptss9/5b39WzeG2FGXPVXBQInWv3TZRPLhGDT6qw9IPFWjl9BFAd4BRQSC/rXGvRGO6E2OGQZsibERC0oYYhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737619780; c=relaxed/simple;
	bh=KQLIZZ+TKYdWEI23rw8xDAYVe++ImfBVfqlugKpRCbY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qa0znGIgubuSbJc/FyY8YBiNBbGh3tFdT3uXhz3ul6jitiC/9uyF4L03zLLAcg51gdMtxPzinwH96oxKrBgE+7C9A0OCLaDckPv+CrcJcT+tuHRRv9Z6tyxqtwV960H/UPerttTTqGTiceQQOmIibF2tEDOA6X3/ziBVB+m0CmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h5v2dvKm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lOVIXySc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h5v2dvKm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lOVIXySc"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N5Mwrt015887;
	Thu, 23 Jan 2025 08:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Gwqd6MsugUDhjrvQotFuSzrk10ZTlN4h+17AgSzGFtg=; b=
	h5v2dvKmt78Xa2P02g9yYvFmnDHv9OjtjFtypXcT83eUdRbZCs4hmyepxSNRMaLe
	6y3POc7fRHZp/1SpGOSWiMaXGNpu5TqnPP9OkH6G8KTkNSPTT3CZuV5qGEV3GwdY
	TKMWFxkwYI915G7RXTddJsIY+ztfIrKEWc2kEezBFrcAV+sRDHZnucHAhSdefP+z
	0o6jvMYwHdR7/t7c/QMUMMryrGo8ntf3bUa+rt1OBYoD0/Rf7aUPnUtgKy947UtL
	gH0MKazRj0KikfNBCGdab21po0IhxqFw6s5crm1a1kaLQuiQYkXL3z1w4n+mHl7m
	nCRBDSuzX8c22e+h5KJgTA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44awyh22uw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 08:09:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50N6AxXx029744;
	Thu, 23 Jan 2025 08:09:22 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4491fm734x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 08:09:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CL7IzgXXgO4UDkkpV0MFbdL6K03oal6tGcgIaEnq1Fucub4bWr3QG9QtWi0/mTAYcjGmVj/Fs/tu/qE9UM5YObZXaCS4HeUdXnGTZWMFShZWaNbrvz8MO0mxDOHr0RIsI4E22uUqoabXktu2My1QqDkBw0xBE/IOQElIekNBDC1VF7E7mxYGkJVoBmuAL4r034jwcCNBZ3FwZMPMNv+wq8QpJHZ1y1URGpdS/JPPJ9o2CCN7hIv4POF4cc97zV+lwJ+ShzFgAmT6FGCzmfADODwNYsmUomJxFqx6uS3cdYt/yLkgN9lU++FYd2UKPpfnhyQ/+T3pBAwT1FbdXnBV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gwqd6MsugUDhjrvQotFuSzrk10ZTlN4h+17AgSzGFtg=;
 b=QNAJ1XuyZItjWP4Fg2fotDSO1mcmooiKIfkOuGeGNSTyRbWdhhdl6m60Q4wOw/K7eAzhqPcpkkdHDNh6bED3cR4w4HSCRAqwzcRAujZ8YieigG+v8mKvIajDzMvQ9Twdl1WZftKKWPHqHBxC2fnn0c3zT/yxFbGughYh3gQDuSoN1yNxIuleV/hhmEfCwKcMQRwZJQJUr4Jf0ZFIsSvPRkZZT6fGE2s4cXFX7jznP2HwvmYV7MH3NcDYJDa7FSrqOaYzeCwCnS3Zt20HVXnZh3u6dM/UjGMYiigZRpxWZGs7rR5ZrbKUieFfZXMTal1Yna3vkRBvyJphqEkvG+900g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gwqd6MsugUDhjrvQotFuSzrk10ZTlN4h+17AgSzGFtg=;
 b=lOVIXySc5BON9qom42+VDDVwyqEH2Sg6mjJsaoMygUXWBvUDTX9eEpO5HkjUd3ARJzIVY/FiS1sYzpARjvC3VTPAPZskYqg1kG5Sau+22UZNAhyeNtmZDY0rojh8Yi9k3x8Ch67FCnuxFSCI+ie3CHTdwcYWNbvVf8rd2vKhhKs=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SA1PR10MB7594.namprd10.prod.outlook.com (2603:10b6:806:38b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 08:09:20 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8377.009; Thu, 23 Jan 2025
 08:09:20 +0000
Message-ID: <1bcce59c-cdb5-40f7-80b6-6aab68a4703d@oracle.com>
Date: Thu, 23 Jan 2025 13:39:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250121174532.991109301@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:196::22) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SA1PR10MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 70508f13-4727-497f-dd84-08dd3b853d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1pOdTJ1Y2VZM1ZLSzhCMFB3Z1RQSC9rcU9DcDlkcTJTQm5xdmJpajVpMXRm?=
 =?utf-8?B?S3ZhWE5MWG9OVVhZME51QUFiWnpocFJXeHhWVzU1S0poaVU4RXg5UHpkYytK?=
 =?utf-8?B?NHkwSjgvYlRCeHpsaU1UYW5vT3Vyby9hK1dYSDV5eVQvOHNHVVMvNVcySDEy?=
 =?utf-8?B?SHNtV0Q2d3J5b2FHaEJXN3VEK2VOZnBHV0s1RDNWblA5S05qSWYvcTBhN2Fm?=
 =?utf-8?B?UnBFeVprcUhzWlZnNy9nUWhqSFpqdi9zalNaUFFKZTBDSVRKTVZkcEtMNkFV?=
 =?utf-8?B?ZWxzTldOcXUyYmxqaldYVXpycWFGRnJlQVplZ2JGNENlSkhHUnBkRTdxUjZl?=
 =?utf-8?B?K09SeFFnaHVRQUxLNjlDbGRBRVJ5QWJMWWVwbXAxK28wY1p2OVg4OGh0MXBF?=
 =?utf-8?B?Z0lZb3U2dldjaEQ2SXlsYzdYdC9Kd2hJczZLQndqM29maUQrUFJqMUhGQUty?=
 =?utf-8?B?bnFrNm85ZHI2RXpEdWZoeCtDa2JSZy91VUZPdHNuVW1zYlhlT29pWTJ3Uk9Q?=
 =?utf-8?B?Q2Y2dmtyUHpqa2trOXpGd0crc1ZxMVp5WFZHL1QvUDhocHpKRFhWNk5HamRQ?=
 =?utf-8?B?aVQyWjh1aXhUd3RobDRvdzN1dXF0clc2QlpuUHdpRHE5VlJnZ3VZTFVLV1JI?=
 =?utf-8?B?NW1ETkp5dnE4QnVMc2RGY2RleVdiZGQ4eEtrckFMTkFJazUvTzZUYlQrYzBY?=
 =?utf-8?B?T1Zjbk1qQWVBdEZaWHJLMWxobkV2b1hFaFZXRmpNekpnWmszZEpQUUNTZ3pQ?=
 =?utf-8?B?U0VNSlpkUXhBRHNCbWEwTVZpUXhvWHhzRG9TSG1rWVkvQm5nV3oyc2ljQzEv?=
 =?utf-8?B?OXB0dTFUQ1JzZytMQ1hEYWF0TU1aVDY2MTBXMERqZzhwcWRuL1FDSGQ3VWRQ?=
 =?utf-8?B?YncxZ0VRNTJ2TXlvaWdob2VKTU9saXpORkJ6SURsOWFaQnFVV0ZBaVhYQ0R6?=
 =?utf-8?B?Q1hyc0JkbzNpYklrTFYySFM4VGlIcmdDdXZUY3VIMUJjSVZ4VmxYT0FoZ2ln?=
 =?utf-8?B?QWRId2ZDRWwzTitoaGRYMStodmdkbVhEN1ZhVHl4eVJWTSszLzFzYnRoa1Qy?=
 =?utf-8?B?aU9XbThnbFJlNUFlZTJXbm16VDBIU2loVjBqWW93aStic1VTMlpoRnE1S1pK?=
 =?utf-8?B?QmF4SU5pNzA5ZFNPZUl1VE0yUnVPczZNcDk5cGNGTmsyTXdIb2c0RnV2RHJJ?=
 =?utf-8?B?VFpjL3F5S3h3Qi9aS1JmVXk2ckJIRUlsMWRac0xnY2dVcGpOVy82OGFxK1VL?=
 =?utf-8?B?RnVhRm92cCtrQTRDUVVMblE4ZFptMGVWVnM0bW45cjRvY0JraHVLdjRjN1JN?=
 =?utf-8?B?Y3JRNW1oZytkMWpzSWlWc0NyTENhRStPeDRDNk1lZHZETU5YUmppaDA1TWFn?=
 =?utf-8?B?V2hNejY3S3JpQ3VDemlmdHBnbzVEM2pma0drR0FHcDN4QU00czZHZmRLakZ1?=
 =?utf-8?B?S0pianN1ZHdkSDZkU3Vsc3VFbXFhV1ByWVBFaGxoUFg3cUQ3bEVQd2p1Lzhw?=
 =?utf-8?B?Tnl3S0dpa09ZMkFUeVlEN3BSWmoyaE16SnJ0SHRUdE5PemI3eVVxUTVtNkxK?=
 =?utf-8?B?TjBJbFo0ZXR1YnZWYkVFUFo2b1JqeCtONG5zQ0ZBcTVoZmtrYlZJdTMvNnRt?=
 =?utf-8?B?aGhPNzA5K01talcxNFN5QTZxSzZKN0V6SFZ6SmV6bVZ3eUtHN1lDbFZKbnU0?=
 =?utf-8?B?aGFvZHpqL0VuTkk2QnVKYnU1ZllJcFA2L0t0Tm5WMUJKRUk5QTdQU2E5YkZy?=
 =?utf-8?B?RENtMUxkdXpJVmhVT29WeXRzektEZHBUWldoYkJzdnN0ZFUwRWhudmc5THQ4?=
 =?utf-8?B?WXlIVHZQZUcyc3BBMEUvQSt2UGRsK3ZtaWgvKzNzUFFHNkptWGQxbURZOUtB?=
 =?utf-8?Q?i3nvIm8q+mN8T?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFdpYVREdE1mL2VJaW83U2tpbk0ybEdWZFhXdEYwOGRidnZsVm9lUFMzSWZo?=
 =?utf-8?B?NW1HQndoWE1WbkNQRGJvak9qajlPeHc5QmlCVStjWlI1T2F0eURPZ1B2MFBN?=
 =?utf-8?B?RWVtdjJTd3hGdHhJSUlhWGo4dkpPTnhVNGRjUEM1dWtvcjkrSkhHV2RlcEwr?=
 =?utf-8?B?ODN4ZVh3WkUyTTRKQ01WM2ZkMElXMGwzRFgxOWZJbUdxL0lYQnpXTElPbU55?=
 =?utf-8?B?VXU4L0JsOVF6Y05zeXIzN0RvbWRnWWpmTk0vQmQ2VEFQTUpCeElKYUkxY29H?=
 =?utf-8?B?d2ZNUldpVmpCNjRoTWI4ZGpGLzRFbitqYVdGajZPanYzN004QVJhcHViWG4y?=
 =?utf-8?B?ODQ1bjBOM2phalJGNFRpSEltR0xtVDZ0a3hyMVdVb09pQXQ0Vm9yQ2N1blJN?=
 =?utf-8?B?S1FOazg4UGZhQm5rRWJtRzRSd2lzK0RoSEFJR2ZsbzloVHZZODdCcnJIY3RY?=
 =?utf-8?B?NWZibmdLM28zRk41cDJXT1V4UStkVkw4Vm1PWktmZ1lHdFliRXUvb3JxTzR5?=
 =?utf-8?B?a01pOFNxOEFQYXBqdzZkc3lsSGRIOUV3Mmx3dG1LNmhlaXUybXN4eVNUVkFF?=
 =?utf-8?B?ZG1MNENNa29mT3A0STc1N2lmNGEyOG1yanFTK3VUNWtiS3ZxV0IvZHZ0YUlO?=
 =?utf-8?B?VzZIdS91bWd2cFpHVDJSd2FYcXZNVzFpVjN0a1g3R0Q2TW5wSzY5RERrVC9Y?=
 =?utf-8?B?N3F2dVBUcWt3WWRndmV0eENKMDdNZXVQNmV6Y3BjNUZlQ3ZneW02eHFpc09U?=
 =?utf-8?B?NXZrUVNqVlV1Z2J3dDZZUis4bHArc1Z4L1hDbzZJa0RFdlRmSGY3azNoWlBh?=
 =?utf-8?B?dWFwcFI1bVBGNzMzNFp6VnE0UXhLK3lmMHp1YXBnTXJIVGpIMW50N3hsTlUz?=
 =?utf-8?B?RnpqVXZ2VGlMVHJYSUMyM2VHK0FYZldKY0ZvbXVwYmdTRWl3UGpHWEpJZW1z?=
 =?utf-8?B?Vm85SGUvT3RGOFI0UFA0YXZhSVN3ZHJIaHRMMURqVjIyMDdKamt3UUZQc2lQ?=
 =?utf-8?B?djlXZ0dnN1VPampBU0JtL21Ta0tveWZ6cDlVY1VDdjZicUZacGJxNFJFcFJE?=
 =?utf-8?B?RWM3T2pUQkw1WUMxYzk2WThRMDdISkpQSkZWdzZUd2hwUU5VMlEvU1RXMzhs?=
 =?utf-8?B?Z1dmTDZpSTYxL3R0YWs3N1crVDMvUTlzSmhmRVVOTUkvQ1hnQ0NPTFFNa0hN?=
 =?utf-8?B?ejFKY1I5RXcrWjJtcWVBQktoZkxlOG1pMVRxeGV3MWJocWljY2o4N0hJdWhN?=
 =?utf-8?B?Y3NKOG1Td0pPbHdJZFpYdkhFWnNpU3FackR4aG1aV0VxM3FOczhYK0U5THNs?=
 =?utf-8?B?R3BSWjI5WjlnTnVrZWlXYVE3RFRpbGlnRHNOTzQzNGxVWWk2NFFQOFpvbTVD?=
 =?utf-8?B?cG8wSm9NSTJQQWZWMlo5ZS8wbTh3WXpjNzE1VVlzWGZoK3hyWWl4UEpscGc5?=
 =?utf-8?B?Mll4d0hLR0dEenJESHZGK05FaWlJSGNIRFY1ak5DaW9SUElyTFRWRFBkN1NJ?=
 =?utf-8?B?end1NHNWNjNURk5UMHQ2djBUOWFIdWRhcDIvKzl5T3FKR1BUYnZFK0g0SldQ?=
 =?utf-8?B?NkI1THIyaFIzUTZFSXhpV2tWSXlsWXNDckp3NTZMSUhTOXMvMEx1M1VaZUJu?=
 =?utf-8?B?a1cybmtTczY2dmdRSUt5VzBIczJoTVlBelZ0MzdpNi9aVUZORG9wd2YzeGlM?=
 =?utf-8?B?OFVQdmRWTnh4MG5jK2prWk9tQ05NaGpFeHZ1MG9iZUlRUUVWRjJ0bkE4NVhq?=
 =?utf-8?B?YktiRHFlVm9sSnJiclBDUkpJNlpzSWtKcWRqNmVyQ0E0MUhqRXl3a3Y2UWVN?=
 =?utf-8?B?Y04yamNnU2w2dFU2T0RGM0dTSGoyYmdKR3doS1BXcHFwMEJhS0llVVVsSGFh?=
 =?utf-8?B?MTNhWnA4ZFRuOHRZemZyYzhvQjhGWnNlK2IwVCtrVkc5R21MQktibmJFS1Zj?=
 =?utf-8?B?M1Z2cDh4ditLUFZseWkydGMwQmlRQ2FoRVU5amVTNnIyVTV1V25mbFpxZ0dO?=
 =?utf-8?B?NjkyOFdvOXBiN2tZYldOZU9ZcmVUdkxUTUV6cW9WRVQxT2dMYVk5eGdpaG9I?=
 =?utf-8?B?TEpLZExkbXVIZnY2VGRMVmx6byt4dFNhT3hjRFhXTkZlTjR5Mm9NcEJWUVNw?=
 =?utf-8?B?L3YvWEIxTjBRUVo0VnZWZWFLeVhnRkdyUVFEZVRBRjIxeFZYN3J1a25UNlY1?=
 =?utf-8?Q?UD48gxTnmymp3CV5sKEzrrw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q5ZO5DjorrJeeWtkeHQTT7zPZVLaz4Mwaqxkw8nJI7BKr0mq+iT23fQnvvKrciAx2MFT4gpqlOnm+FfPlUtCMYWNVaM0Wy4cR6ZXdkR+PtJayBATla7K4cL44GXeIEDEIim1COTkRYulPBRDNmVU2DNPHNfe5fg4rQLij8inrWFAUWKEr8774FP7x/8WcAZPZsKLvJh3CVAyDLvnlF30LwWaYMHs1uFF2MNDTeXw1DUS+BlUpliWuMnQ1O/4NN/WGlvChaRLLxGvNdk0b6LfhlZVG1JsHf+Bz5jSxDqAbLsOK808k2S5KFubL4uvNeF4E1bpnW2d/RD2Sn4uGXL7e88n/dEsIXa6qJnW7QwzL3i+2zXdYtIbkU8GzdAnfWBWPKWc1WBzWAew8jARDugVwW48eXlj5N1pLr1uZByPXQfpSwb+nt3myHeIMTQmTTCTu8hCXLm77QILa4Y9Tohv4Kz80WRPw45pqW0U2XI0F2VB+mDu0fht5t5G9PNpEw+NXP2h1stSaeYQkjnjnchGi31RXwgkdxMl1u2hY4tbsEE4Mt1/2e6wUkBRN+AGQJfeGl+AsX93DYZ8ORudicbF52hJj8A+IC/SYsC2mjqRHKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70508f13-4727-497f-dd84-08dd3b853d1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 08:09:20.1687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZFTeivzW9Ut3jlLC8ALJFbnQNdHMKUxTRQX0ungpKJYsZlIcsTB0xkz7HU0EqmvlycRhmor9K1yp+IPZkYO+XXv71WMVCGG5J122RG6XFFDBWEwd0RSvQF2goH6A4/1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7594
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_03,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501230061
X-Proofpoint-ORIG-GUID: WbV6josuGGoH0ZjLg538l2M-sAsDf6BD
X-Proofpoint-GUID: WbV6josuGGoH0ZjLg538l2M-sAsDf6BD

Hi Greg,

On 21/01/25 23:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit



> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
