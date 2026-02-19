Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D07A309EE6
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 09:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771492876; cv=fail; b=twzbHMc9HUgnEGKy+IMYY3X8wd70c0Z7x1vHpkv+i51Gm86dBGKbU9nLi82MG+ELfe5ndjGjpaBDAaOb4W/NTbsoerYmMrx3fgAw7TctQBE11XUauDHCUZcjGV2E9CC2IjHsKGOfvFvi7pm2IR0kAnwRuoff9zknMddlcImNljY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771492876; c=relaxed/simple;
	bh=jszs6gTJucHcAjyu9rGkSt2CIgeiFwSQ7/0aljb7WG8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DXNG6vwmyTV2KopWdfp0LHq6UnVhtNoV8l2XCUD/YhvklLLSmEt3+Vq8sjtgbDC0UQXBrQNWhhBcvAzHkIa9rOd4nUTHOF1/yRmezB3h+onpI/Zlu8Fk/pK4nFQueMf4VOwVscTLu1BwV72XcMif23V15dvW/EVEq3cg5BoB2ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aE+oE0RH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LEKvOcyo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aE+oE0RH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LEKvOcyo"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J89QPW3675464;
	Thu, 19 Feb 2026 09:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q5WDWs0i0f54ysiHsdazIPy8RYXMJ/kqh6ADzGiHIv4=; b=
	aE+oE0RHm6sHrrXIGANPBTMb0UlGc3cR2A2CW7To2JJjbJoHYJ5FWjawcxX3CHaS
	eoke77UNk3rzY8k8/x7m2yLbdEQSvX6+A0xvDE3lQteY5nocCWvNtjNdr5oyQK8F
	ayCD0HzI9J5UB8Kr/NGL1CSlu9M7LcrHR29dg4yEWQSQxO+5bURArgDM2N8hHfPX
	9rAWiaCMXyIHO7lB4Lwco9Am/f5sjuC/n7PJM7IzXiPa71y/fzqN7xXpaN4NWklH
	p+wG3Vgn88GnfXs0YXrEUy+ePWDw3IttpAULiiwboktRyvLeZSgZw30ExkbdBzM0
	xdMET+CGc4q6apWsgW6e8g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0ay2f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 09:21:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61J8G7L9038983;
	Thu, 19 Feb 2026 09:21:00 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb24yy01-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 09:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=es7qhNFN/wnZgjBkUbgNxfbmqjrZ/Fz593ZwL44ZrVqm9LnO62RU9H4xQ9x+nTOMpegitBfPQ6ueCxabDUvIqugPNoAL4DJ1nJLsxvFQa96XvFGdAdzqZZiMAXU5WPhw9j9uFCgWFknKci9aKjdjVcTT2HBGn1yhXpRXGgY2lVlslIyM4GMytWEgIdlyqnuoQy9OKCcjq4XxQaI4l8csQH1+Zok9HnBG8oLqprEJqfv0yh2e1lcnBB5J7pNHki4JzdilH0deY+tN/zj7rPcPgial+JVAC5XB+xMmQB1vLYv728VEz89jWIwwfJYrbdNLmmEKoxAlAbpak5qoCGhuhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5WDWs0i0f54ysiHsdazIPy8RYXMJ/kqh6ADzGiHIv4=;
 b=O5gzmUhtEp658HUghXrJ3WN7+NZ1LOVobvWpNJmr+UK+al0umzz+vMs9pKHDy/ipcPKQq7q2RFYMHypeZZoH9ggL1T1Io3roNSeMkGuLaUAXWNFG0QbuRthkGDgGOvo2VUWHZDDAWvfGHKLjknkCOLqCQLVc+nilT7TZ7msleoLxVX0bfeC80Yt4yFaWTZTveGywwrjS3VaGNmawTvEJAp6gHWHKx4bF+hHo/wYs/22yenvjo8Or1pfkPrryksC9VadlrQFvqJEkhTYFhQw+o0OIKV0JteCVy86SApc+7879HJ1+ujFWiwb24xKZaPBeMDWroEdbo7HJYB18ZBDDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5WDWs0i0f54ysiHsdazIPy8RYXMJ/kqh6ADzGiHIv4=;
 b=LEKvOcyoCbsD1LU8YoSxSKnb17GtqXHXMXnjGPp/KcDlMz/oBa1jVomE294fv7TugZa+b/aweg7vLt/kR/snqFB2ZiO1mkPCouo+XScISi7BPRwtobJ3LfQqJLLRkj4vfRfiUA6DDI8KcjitahNMee0Pqlcf0zCqdMuxBg8HTos=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH7PR10MB5723.namprd10.prod.outlook.com (2603:10b6:510:127::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 09:20:57 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 09:20:57 +0000
Message-ID: <ae06fa79-fa31-4193-a662-b3865abfe6df@oracle.com>
Date: Thu, 19 Feb 2026 14:50:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260217200005.998240758@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0046.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:271::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH7PR10MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: e130a649-5960-47c1-44d7-08de6f983025
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWZNbTFGL01lM0x5VlczdGRvdUNKaE9PdHV6Z09PSHBIMUVzMXFaZ0lWd2Fs?=
 =?utf-8?B?ajlvYW9JamFSckp3V3VheW10L3JWcmVHakFaUDNxZ1FsWFZoYzdsU1Q2eUdW?=
 =?utf-8?B?ayszK241Z0ZYTFNhSElDR0hiV3ViZkJtcWRaUVdWUUU1Y0tCM1Z6akhTbHV1?=
 =?utf-8?B?WjQzeEpqQnpWU3dKQU9LSzl5RkFFYkt2RTBkbm1iRmNKanovdEVFWmNKVm5N?=
 =?utf-8?B?RTNMeDZFb25mL2lOVlhVWm5EV3hXeDRJNXhRZk9xQzhpM2c4d3JpbkhmZUEz?=
 =?utf-8?B?M01KY2E2bTIwU0llSnM1Zm1IVmNmQWtoM3d0Zzdyd3VBUUs4VzRLQ21sYjdU?=
 =?utf-8?B?cCtCaHhNczMxMDZvaWxORTdueFZWVVRnT1h6OVBSUkdJVVJpYzM1NFNzQTVF?=
 =?utf-8?B?cHlPR3hBTUF4OW0xdW5YL0JSV2UwamRXNGdxQ3ZjRFRid21yd3IzaUV4ekFC?=
 =?utf-8?B?TEFWNGFzbEpDazhHWUhTOTV1dHFwNWxRNnlZaEJGZmQ5U1FaRS80Qkg4UU53?=
 =?utf-8?B?Y2RDbFJEYkRtU0pqYUFxcksvbVRNTTJ6SllzOFNERFQwOFpQTjd4ZmtzUWhY?=
 =?utf-8?B?T3NER2lxQ2VjWmtaS3BDbUFlbmRrNjBub0l1cXo2ZDRhVFJhZFhOZzk1YTFj?=
 =?utf-8?B?b0JpSDlHMkxHWnZ3NlFjVjNicyttVDlaOEM1NHduLzk5WUlaZWNVamhQWC9r?=
 =?utf-8?B?VlBxMmI4TEdFdWd6NzBuamlqUlhIc1RUL3M5eGp6QnNPNENSMUxuZjgwcHg1?=
 =?utf-8?B?U245QzQyN3ZEU0JkYUlabkdSUXlicjRZV0JYQW9yMG5RZ2dTeE9FMStaUTVF?=
 =?utf-8?B?eXM5bGVUMysrcEJvUTNhSHI5d2ZLQUlidDVKNzVKSStNazlnRWVNVUpST2JM?=
 =?utf-8?B?Y1RkRFlTR2FpTHRrRVBSRVA1QlFmcmNzV0F6OEhXYTNoSEtBUEdINjJmN2Fh?=
 =?utf-8?B?cnRiSUx3eXlOeW0wN3lWazFzTi9Ta0psSGxZK3N5eTlINkhNb084TEZ1bDVJ?=
 =?utf-8?B?VDdPenRkb3hFWDQzNENtanVSblRYQlVTWVlpUjRsZ2R3VE9JK2U4OHdnYUhO?=
 =?utf-8?B?ZFpxQWhtWk9rSzRZOGk1c3NsMk50Zlk0dzdOdU5Rdkx0YmVTMENDbGxoR1BU?=
 =?utf-8?B?NWNsMUNXS1pOenpvRFF2TnllemhCM0V2K0VERFJ1ejIyYkZka25VMitVYTVq?=
 =?utf-8?B?cldXbWJxam5xSDJ3SjVSZ2RNMXBuUDlmOE52RWJrZExLbU92cXVCRkMwRkVw?=
 =?utf-8?B?ZmJmTmxVcGFiampIRDFVN0FFZ3kzSzRWaFpBZjdKdmo4SksyRmxnb1ZtdXhh?=
 =?utf-8?B?V3NYaGd6R3JDWlNyalhMK3czTU12ZFNQc2F2Rm9YQ1MyQ3VzM0pHZWxDaDhX?=
 =?utf-8?B?bkloWEgrc2pXNXZ6VWZjb2tZSFJpNVYyNExmOUlvbDR5K1NWRDliS3g1WWpK?=
 =?utf-8?B?WEJCaHowWThOWEJzNmdidG5TbjRPeHR5bXNuUnlxTjBYWWFNa3dNRk83YWRV?=
 =?utf-8?B?RG03L1hSbG1DeE5HWlpXTS83b1h2Umd6Y29SZHFqK0NZUHh6bERkamdnWXBU?=
 =?utf-8?B?QWMrVTJ3elFBN1BrbkE2NEVVVzBjcnU4eU9LSlRKeE5lb0xXT0ZFUmFhYVdm?=
 =?utf-8?B?Tk1DWnJScDEvWG5ESUIySi96bFlWV0lxV3ZiWFdMUWxMNFZzczFPSnJVbk1O?=
 =?utf-8?B?TVVDdVhFYlhWUkFCTVBNYUFab2hObU9tbnlQcVY1S3IraHZUVVdkd05ZZmF4?=
 =?utf-8?B?dTJkTFJGVTRUTWJLeW5BNVdGeVdzZ0RwVGQzYmpTd1l3RUxWQzVIam9idUJU?=
 =?utf-8?B?VDBTeEYwa2U4QjZ2YnFOZ21YbEw5Nm0wcGdaeVNzOGcyd1VvWi9FNVd0NWVJ?=
 =?utf-8?B?UjVWRk94Tkg1ZlRrZEZEdTEzT1Z4WmQ3Q1lwWkxOY0dtK3podEtQUjRFNnNZ?=
 =?utf-8?B?bTltL2RiQ2lRT0ZSYkhNSU5Ua25WSldDV0loWlVGM2xGeUNVdGtpYmpsbzdK?=
 =?utf-8?B?N1NYTllCblNNS3ZUOGhBK0RnMFpyanh4bjZlbjZTWmpoektWNk1ObXoybC9r?=
 =?utf-8?B?ck84d1E5ZTRmWXZtcnNTVHEzeSsvRzBZQVk0TnRHbzluWHZHNys2N1B6VjI1?=
 =?utf-8?Q?YlM4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDJ1WHVDMURmYjY4Zm43OG0wTTVnTWlaZWh5RC9QT0VrZFRQVnM3OG16OU5L?=
 =?utf-8?B?WnVCM1IzeC95UmZrRmJ4ZS9tSTMrNXFZbnl4anlxRkd4ejBqL3dOeUJBcTZU?=
 =?utf-8?B?ZU1ZNXgrUVBqZXEyc000eXFYSkpUbGNFamJBM2NnbWVSREpsMDBmdTR0WGdo?=
 =?utf-8?B?bjI1R1hLVjRybFhxMnpKK1ZVTWpJbC85SmIrQ3Q2RlVkcmpZVXROZmZRdndy?=
 =?utf-8?B?TUUxOWNlSlAxMW9abjgwYUhOeGpkeGk3SWF2S0ZpeXVPSW1FMjZGVlJIaGg4?=
 =?utf-8?B?Vm0xcXY0d0FBWHdoaFB5TnpZL3hpejFtMHA2N3ZqM1lSRUdYRjgxQkZtQ0F5?=
 =?utf-8?B?UWhWWUhnREdMZzdiZG9lRG44Ly9VMFpCNDlXVTRTVlo3U25QTUdaOWhzc2o0?=
 =?utf-8?B?WSt2bzZ5R2pEZTVQY0V0OVpHbFhPSHlIT3ZNL1hWS2EyK2sraW1Bb3lRMGFr?=
 =?utf-8?B?NkhDMytCYTc0Z3hHOGY0TEFEOFBGK0lUWUlOUTA0RUM4L2MyUDBLVjNBMWhV?=
 =?utf-8?B?UzNtQndaeksxcHgxWWxnRy9qdGlaZU1XbXBnSUFnNEYwV0V5aVBHdkJlL3Z1?=
 =?utf-8?B?NGNTU3ZIRHRuV2pyd1RaZnBzOThkdjk5OFgwNjF5TVZNRldybW0rSFpWUVlo?=
 =?utf-8?B?SkZiSENja2V4eXJjTXAwQ0VKSHZ4ZmpBYjRxUlU1ZXM0ZDZRSGJTMndINjVU?=
 =?utf-8?B?NHlGVmgyM2FubzNmYzN3Q0p6MG5aSk1SZ2lDK2diK1JqQnAySHlxSGZpY2Z4?=
 =?utf-8?B?Z1l3M3d3eUthVVhxZTBUMUhpN25LMFh2K3R6UEFOQlovTks1dlZzaENoQVdO?=
 =?utf-8?B?TDA4QkFJSTNwL1JSR1FTZGtlOVZyWnhsa3ZjWGdwaDZ4bkRFY0NaU3V2SWor?=
 =?utf-8?B?eXJvMlNvbVZaMjVLTlFjelVKZjNIUGNtZTFlU1NLMzBmTEVjMlNDMU93RzlF?=
 =?utf-8?B?a3BYU2oreFNhZS9FbEhxdmRCR083RWR1a0gwbnZQbTNUWFpyYVhLZDdpaksx?=
 =?utf-8?B?QW90VEJBWGQ2VjZlWUZvbndneTVOWk0yTzIrT0xBRG52R01VY2Z0Z3o2Z2Nm?=
 =?utf-8?B?eUhyK0x4em9pOFowZmlSY0NablBvM0lIaG56QjBHUWpZaU9CeVlQMllYZEZo?=
 =?utf-8?B?dGZ2RGcxVXROYiswMEcxOFNwbE1pbWdPdEdoN3g5YTRDeUxuUW1idHZuQVVo?=
 =?utf-8?B?TWxURVFLUlE3Y3dWQThaNGZ2Q2xPbzFkakQ2WHBLTkFjOW9IUmdkUFV6NUtJ?=
 =?utf-8?B?SDduL3YwZUJiTXh6a0lNRnZJRFVFT29wVlFJdlJxZVJLeE4xc2NuWDB0aHQ2?=
 =?utf-8?B?bU5qME9aOFMwRUdXaWxyQlgyT0c2VU5taU02U3lTeDlTc2ZWUzJWTG82MkFs?=
 =?utf-8?B?UFZxVTFhS2JQTVM1bjkrZFJBWGljZ0o4aHJKKzV1MzFQSGJ5dDhOcm1lcDh6?=
 =?utf-8?B?RlNGQTF3NU1haGdsSDRaK3FMOHRVNDhoZVhtTlJaZDZMTUw4Q0daYm1LZzd4?=
 =?utf-8?B?aGIyeTdmVm55aENDek5teXZtQkhrRUtBZ25BTi9uVDhwLy95RHRsTHR1Ukkw?=
 =?utf-8?B?cDhZRHlJcmE1K0dVMW9MQlZ1Wk4ybURSTHljYUprd1cwNFVMb09vOFAwVG5l?=
 =?utf-8?B?Q2xmZUluQVdrUWJXbWgzM3NkUC92MmJwcU91Z2luelR0RHdTZlF0S3pHWTNk?=
 =?utf-8?B?VFNHd3VLMUVJSE1JYmhKNHM4T0VTWU1oelVRcFozdXVybERsbzc5c2w0MlVL?=
 =?utf-8?B?Skx4WEx6ZCtreC92OWUyZDA5V2tmdTlVRERxWjVKK3VodU5JRGVoTkZOZEgw?=
 =?utf-8?B?YU1BejV2YWprTmhTaGtqL3Frd3FHSGJGWmdhakFXaW81Nm45Y1BGL3c4MVlE?=
 =?utf-8?B?RWtlQ2pvNTNiYXJ2U3Zka1pNemM0eHpiRlFmSFI3d0lkdEc2YmJCNTk5d0ho?=
 =?utf-8?B?cnV4RmtaMnpoeE5PQ2orQnc0ZmZYTGx5Y29OaE5IV1ZTNzU5aE9tYi81RmVC?=
 =?utf-8?B?V21TWDEydTlIanp5bFIvaUI5V1hDZFdiY0hUTkt3NENtR0E5dXc5UXpGUDJs?=
 =?utf-8?B?Vy9XNzhkUHRFRElXUk9rSlIwbDNOWnJLQ3d3bG1Wa3ZURTZ6SUwzUlp4Tkpw?=
 =?utf-8?B?c0I2c2FIY0Z2Z1ppOEYwcWkyVXYxc3BtbmdBTHhRTUlQaVlqV1Y4QVNFWE1K?=
 =?utf-8?B?MzlwWmtSM1dhcjZFa0laakJaZFNmUDhWcHpiNldDRjJYcWp6c0VVUWlIa1hG?=
 =?utf-8?B?VytoVTVFK2VUWHdyY1pPQlozSEs1TmJBU1ZhcEl5NjBUaEdNUmJ4RXd6LzlV?=
 =?utf-8?B?RWFCZndlaXZudDBDWWhuSTUvSjZmOXRrY1A0TXgvakZZV0V6RU8veTJSdHV1?=
 =?utf-8?Q?nhfAm/axGKuVQ2nAT/gIbuHF/TRdOcDtrG3+X?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	985FoZkuAfRvfBWiyFh5rRfpQlA/WvBoEORAwbB+b/IDy40hZRAmIdtgm2UQMQSnqNkTPD3ocRqjG3nbcEb7U+24o/GHWYS7y8CiJb5bO8qYKagHI5yvUDSP+l4LX7z5hZJ8YugXg+sz4FRfC+YE9Ud1iTAgUT6wc2uKf+9yHFkDkb+p8udspcLAAsQE1y1tOYIrQO34Q+l/+IWUg4KSGbBPD0okMxjrADKs+AwVWH9MMQpnChchLIVXmHqpEmHyJFyn16dhZYviS87kDA2+7U+KZ65F7own6F7rlEIVXsrnmVK8V2QMyjgThzXAGD7dAI91yvlfub5Cwx8AmE/1/4/2hLXfz2ZVM5O9ycnykxlwINPArpFPLjUnZ3lmBgGLwP8vJwYRXtcLllmQHEqXoaRcM7Q28mLvFvGlnjxkvqp+QT9ZkZHZPUj23NM9cxZkyWN/Si86gLAra4ckFzR4Ij9UalFUM0/sZo+22nUzWiE0tqwIqdVFf/lV5N7+lURnIA+RsCwymzRswm/wYJIZ3txVp3Apkve1nmx8UvHg1EF9ig4xjjNPWYfkb5UvuDeySdIY6YnTpFDA8IgJc5tbUR3rmhy61pwBHOFhGT/z4mc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e130a649-5960-47c1-44d7-08de6f983025
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 09:20:57.0111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JXlTS1DKbAAprXz/pDIFJpb4lOkzXAwSymWcoTabiqoq3zoTom23L8URwkScNXpghU/Z/O9+/na6K0gHV+7lfpghYTv4y14NqGsRN3IlWTMitfh5kvntVezNdGccAX7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602190085
X-Proofpoint-GUID: MPwZ-HV6q6QQ43BF-bSF9vkuWRNAEDG6
X-Proofpoint-ORIG-GUID: MPwZ-HV6q6QQ43BF-bSF9vkuWRNAEDG6
X-Authority-Analysis: v=2.4 cv=UsVu9uwB c=1 sm=1 tr=0 ts=6996d5fc b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=x6Ducos6UYMGwXt6jLcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NSBTYWx0ZWRfX9yXp6o00+RoB
 dnAC1TybEtHrhPItfNyp2HHm6KiOEdmFKvCD/zk+23Idb8fO/HLurB4BaFVKhTgYiN/IuJwqQqf
 fbU8w6pDMvRyZH5H+ptQ+gYqAno+zo6C2wzdSFqsW+hxTXkOU0tP+zhI1lE/aSLNzLrAwmiLLSA
 ayDekDwCu9tuY9moPonoaMYGOGvnMy551xHbGjNyF3f8L8P7K5a79QuQgRg19rEL1QvSAuL06pu
 zl0UEI68V64e1GCdLNDfzjV1tYAkxiESRssYvX1oEeifJxa/OInXiwNYcFVKo09d3wI9QRWqZPx
 CRtYdmcZv5ld4LIQd8zWCTxKaoEql8vX2wXN8fV6jzSXXJbBJrdELUSxo0f6Mrgkf0ITxEnx6mW
 qUGC3T10TYlAtvxpZZs82fjhfdq8qcdXxuseyJBc1GPOU8vp/vxUuN3bRhp8Z7Mb2UDM5ONhP/E
 Mvbob5LqhXLZG6yLnTw==

Hi Greg,

On 18/02/26 02:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


