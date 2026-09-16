Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25AA34AB03
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 06:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541009; cv=fail; b=pMoM868v3/5mMKWgI5hR81doBkg0DwR9dRgRkXJWOHprB82L9oAQNjkq8TvMH7ne69oL/p7K1IoPLfAH6cADxTZQQJTxha5gfpHzRoJFwNx72RcYaC0ZIY6QMudlbE1OxgxMygyshEnDCzodyqukaIn7A/78h0Tv2B6H5QCB7OM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541009; c=relaxed/simple;
	bh=Kcw1symSsQjZv7zgz0kj1F1LikAHtDMu29uznuJ+rNc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D1E7qeZnop4bDIyN7N1DdEj5Tvg1/zI1XzYRAvsFFqA9wWzSzMhAUiiDV+JhoVxY61bmpbxzfVI+TT731wJZgFyHKVGsD8o+KcwQ4Af4mkto/5m6g2K3xj8aBnI4f7TeaFadl2QS/Ebv2ZGiVt3wxFpXyns+717Moh4lYXLTuUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dN/71E2p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aYEGcvBC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dN/71E2p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aYEGcvBC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWQYI641144;
	Wed, 16 Sep 2026 06:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OKeuDT+ol0z1UbDxPnJamBv506fLvLAbZ+l0uG17qk8=; b=
	dN/71E2p1gB1TqFnDKIRa2GI3OBGh4C2t9rZJy8D4PjtGXqnn9SulD/Q16CMd4hr
	ZjgRCi71eFsmxfddHFog5DYoxjaVV1kUmpZT5pzfQ4INChvWBM0YjDUfsKj905sJ
	42wNfnISKq23i82C38g4/zwpD+cvgt5gmMQ+YKbv/3/8YFa7VGIoXilpWe8n0lkO
	0K3+OTAvPrTWS9GNW0C69XAJJdM9ZgIR+g+0FjjcSM5rU7v4CBAGmRmyWUuYDK9R
	sgu3n36f4OjndYBPHK0lj3kl4psJcOXB+KMeNmbmF7f7+LEH4QdsITY30oiNHnkh
	YRSMQj6oBfUcchGhKi3W0w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs526y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 06:43:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G6eYY1031020;
	Wed, 16 Sep 2026 06:43:23 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011048.outbound.protection.outlook.com [52.101.57.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q07e9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 06:43:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uh4nmswHUzwbgkuBNLpFT2mkZnmTyaZj8A3PSSF2wRNE2iS1/w/wIfUEhRclvT8ye++ihCQ7QrhQCu3nCcyRdxYeFv8rApXsLDOi3nwDn6yz37lVjgJBLOLBOkx/9Oi+bhyyfO3kKe/55d2N1z54rVIz9QLWC4mi9h913mfau4qRlOr2uA+XOXC8/j2Kfi7DIt/nPKJS/J9ycH0jnLykTCzl6lQd1W7IFV+Q1UzMPCYNUIKH08hR0XzHKn4WVlPMSeMVVVEB3+36f9IQTacFoF44yGAih1aUwyWFGU6JiU/sApw4JE4Z5yMBRZUoofwaMYJXQ7EJH9i8jyRk5TPAcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKeuDT+ol0z1UbDxPnJamBv506fLvLAbZ+l0uG17qk8=;
 b=oMA807B8X6gLGteqZwMm9Npk3FM07XRhP4WJExLgQ3BdY0DsN+rwvk/RIWK5ZgUtXUnYepDesN8orU7zbR+ULSVSykUJkzA2JST1wWWf1+jmF5RwRs9X64hyg+kdEiM0tzwFjNmXI8n16WL2gpKB8e2sFkyl25cISkx3IF1rhjyipmBIXjruBR+5iy/FOVVFOygO145k6IGpbcP+r7GI+xKTiZJ6I+LSaVuFxIrgCAcMjEMaAKWRX1CmZ39KU8mC4ueVhjCq8xG5ixp0F5VVhmbcuLgBx+X7uUexScZASdrk8qlG+bdUnLboha74lBGRJNA7vqSakO9impkzPBwqLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKeuDT+ol0z1UbDxPnJamBv506fLvLAbZ+l0uG17qk8=;
 b=aYEGcvBCqaAS5Vj/k9e9mO99FeKIz5Fdf9XjKHWPCGOrNMKVR++9USow+0rTWk2ppgZn0DCH/hzsSMadi7WoV6Z2B1nfT5nIH7u/1ypzfvoEA5tj4bhYPpCNt7kBkMDI+dLVlJ+B9qOgT7glVEtfSrsLjqxwWSkH+DztKIMoY9M=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA4PR10MB8304.namprd10.prod.outlook.com (2603:10b6:208:566::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 06:43:19 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 06:43:18 +0000
Message-ID: <58d2f55d-4194-4e47-98fd-f61d4f4a66b0@oracle.com>
Date: Wed, 16 Sep 2026 12:13:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0191/1376] media: em28xx: fix use-after-free of
 dev_next->devlist on disconnect
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev,
        syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com,
        "Jiangong.Han" <jiangong.han@windriver.com>,
        Hans Verkuil <hverkuil+cisco@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065611.808278741@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065611.808278741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA4PR10MB8304:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ce110e-ae47-42f4-ef65-08df13bdca85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|3023799007|6133799003|56012099006|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/ZZ5/KWd88UVjsYihNLsiXqC71HS/RJ7Qu/fKHhKrKpjBlwHS95aHmyWwoay+Bk15E7tGMzQI1n0HJdnErAMEmZVjfmxINBJ3crqxwwgP7YCLohoRvSOpDCmgX8Y1RPmwsJojabiRkM1SuZduegHTxnqldboiv8hBcjwQZ61bkJjkby35Jj+QMGN0ih+3MUMz2RIOPeIOQkNo0Q2qjNeSdKGEYDfN/gWet4VMTtpi9YXTBBA/sWmTlHfJI47SjMC7QV9XXnUvbWKVjSDqNoJfpJT7qjt4rj3qtCWz7rSMG+rP2I6R54PtTEV4ACbQTDIyxc6usrMm8Hoq/iJwYyyt/6lLseAbtNECxBEcfwuyVykMXjVSQZs+xlNbtwWm0PeUmfDmRI1Gz9N6T7QiROGoj5v0R9/QAOu254ymuwvJPU46Lzr8gUhTHmZT/PSnO5jRuMxWlG7XJTYdZRS91wfN1SB0ZFRUNrOvVdy79BZkQ72kwCEHJxh6iulKzSRrvvPHmE5oAg0IALbGYgnmPyvZtAONW6GIIuElm0qRgFkj8wtP5YmBktixme6M+8sjNrpzej8ie245ksRZG1bZh1cO3bTXoenXjH8GqfM7NiO8qfgTMOlP0cLhlX6oU/lJ6Hk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(3023799007)(6133799003)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmpudGN2QzF5YlZIbzVBS1d2VldtOWxWOWFla1BhTFI2UEI5eENQQWtpczdw?=
 =?utf-8?B?TnhrMmpWZWVaL0wzV1FMOFJQd2VsT3lRaktnRU1ZS1lZK3phVVRadFZkT0FE?=
 =?utf-8?B?QXB3TnJKaVQxckh2VlQrdWw4ZlNiNGROS2prUnM2NmxpaUZMdW9tQ2lYWUJS?=
 =?utf-8?B?dU16V3FMU001c2NNSG5SeW5EOExwandYU0ZtMzE2RS9Fbkgxa2VkRHZIQUEz?=
 =?utf-8?B?M1FnUUU3YjBZdlpBVmQ0QVp3RkNiOEp4VUVKcDJFNkwwbXRGQ3gycXlicU8w?=
 =?utf-8?B?OTBRUGhHVzkyYWg2NVlYbFYzZGY4am9GWTloY2ZOVStSbjZoUmh0ZkdRYTMr?=
 =?utf-8?B?dk03M1psMnlJK053ckV3N2RpTkxQOTJ5Njl3MisrTk1KakZxdkxoVzRpa2pV?=
 =?utf-8?B?Ykd4Y214aXJKMllZZm9uVHl2ZG80SzJKWnhaanQybjl3WXhBVVNPNHhRb3U0?=
 =?utf-8?B?NndKcy9CL0JMYkRoeXVZekZyM0RLS1dCeW1HNEtOYzdKV29Xbkt4NG9mV0kz?=
 =?utf-8?B?bllvTFlsbmFmMWU0WG11ZFFwR2tMRXpJK3pQcUxIREkyU3cxaStYellJZzV3?=
 =?utf-8?B?MU5YUDRGWmN6UWVGNTVHUkJtVXRSNXEwbHN5b1hkN3NqQ3RReEVwS3VXZDBh?=
 =?utf-8?B?N2wxc3hYbU9ic0lSa284YlMrOE9wU0lGQ3IxU0c0MUZ0eVpuUEE0Sm9tNzlT?=
 =?utf-8?B?eHVQV3A2eVBEck4vN29pVFZ1dGR3Wk9oOXV4QzhpaEhIN2w5eDFoV0JxVnpL?=
 =?utf-8?B?aDF6bjNFSjBaeWoxNzhvZFhTQ1BLRkd0eUNFUHVKRjEzcGxxbEZQcGxEODN1?=
 =?utf-8?B?bXRHSGUveXBSWEdERWZWSDJwM1RYVk53M2RUREVCZ01pS201cnU2bHMrVVZD?=
 =?utf-8?B?VGxBbjQ4eWw2VTltM0IvNHM1Rk9EZUpSR0FjZGJhVXg2Sm9PdTArMnlzRWEy?=
 =?utf-8?B?aElsQmJNVEg1RWZibFRuVWZRK1lFOFQ0bmc1L243aWVaaVJBWUg4RG1QaGRH?=
 =?utf-8?B?eFVUVGJGSkx0WG5LY2tFaE01SWlpMFNMSWxnMGxUeU95YlhHbGtCL2pPelVo?=
 =?utf-8?B?MDI5blpyWVRwellyNTB5V3VsWGVwRHB5Q0hGNGRxdTlnSUlrblpVcWtiT0p5?=
 =?utf-8?B?RjFNUEpwTkdsMlZLTFRlNFlmYmNHZDVILzc2QXp2QzVxZUQ0dVdXMXI3TEVH?=
 =?utf-8?B?VklxRzNkZTJ4Q2pQNzhWaHlaWlZ0UFU2d2xmODFmWFI3VWY3aGlZZURKZ0Ir?=
 =?utf-8?B?VnFnSEV6SFZmR0dRaHg5anNtZjJWNVdhSmtJUnlialJsTE1OWGlnSVVBczNX?=
 =?utf-8?B?SDF1R1l2VTczeGhaVnhkTmcrQ3puR1dnSU5BSE52NytGRzJWemxmSncxYzln?=
 =?utf-8?B?SmFIUVdGNkJFVEpBcUZaUGk5LzdrRTJWM1paN3BOSjRtTHlDWVpEWEx1T3BM?=
 =?utf-8?B?Z3NseDk3NktGMWdycXBhYVFyMUlobHBLZ00yc0xFa3VuZW9Wcm1PTkVBTkpk?=
 =?utf-8?B?VC9CbTl1bHlKTEZBWjhHK1g4c0VDdkpEM1pjVXQzLzg4RHJOSWtTTyt0UHZB?=
 =?utf-8?B?ZWMxZm5yYVh2eVFQMmU4c2V5SUZON0hnMnZET2wrbjhIMFpXNm5IRVlQQTkx?=
 =?utf-8?B?dWJ5alJCeWdQQlFEa3A2REk5WTRyTXNaaGNGcE5zOWFpNmhnb3V1UUtib284?=
 =?utf-8?B?QzRRWUNSQnBkanp5ck5STnExYlpBS2tYSjRJQmtHNkJzck1uMjBQOUs3bEtH?=
 =?utf-8?B?cTNHdTZ3dFF1dnFLWU1zNEd4MTNreDV1WkFzRC9pYStjYnJuNGtsdkZyUVpT?=
 =?utf-8?B?MnVyZUVYSEVaeUtQTWJKR1ZPYm1VY29IOEQvckhGWlhCT3pkcUVVWVVOYnBn?=
 =?utf-8?B?RVNDMjlRZ2MvaWkveVZDMy9FcndicnY5OE1NMVZ4RmxYSmdvREwrY1BDSTRU?=
 =?utf-8?B?OXlPQXdlaklLdXNWNFhUVVF4QTZKMCtTWFBDdGswMDBiZjdoYlNKOHdhVjhP?=
 =?utf-8?B?NGgxSi8wVFQ2ZHFCZEZ6QnAxa0lCY2FDMFRMS0JGMXIwdDg4WkR3UFZvUmxo?=
 =?utf-8?B?bU5GRyt3eHhQd0YxdGFKS2J0VGZYRUtraHkyY3ZNQTU2dTVlcDFJZWtEYm5l?=
 =?utf-8?B?SUMyMVBNTHNoTDRob09DQkJGektHekJQYk56M3kxc0FqdStFb0ZvaForSUFF?=
 =?utf-8?B?c1ZlN2NYanE4UlkwUllNdEdiSG1EdDdDQkVlL1RKNkdBWW5TWnVsRWdIUUZI?=
 =?utf-8?B?UWRNZisvVVladWo5dlA0QklDbDlHMWlqQmNqYWc0Y0E4SE5tb0xmQnVVcCtF?=
 =?utf-8?B?SlhIMHE0bUgwcmxtVFhadnNtcWZQZE9Ud3NtM3RURXdOQlhITVduNHZyaVJD?=
 =?utf-8?Q?pMN+SXGCrX8osrFuvO+Kv0zJfec1896qtWnVE?=
X-Exchange-RoutingPolicyChecked:
	0yzHmpMn1uBu8Db+olSjy4G3PBQg2cmUY2875cegFAX8LnjMpZ+TZBEwQ3bCH48CzI/QSSvAzpbjdmEzUDe31S1CIxm+8cK0rqE3v3Oynt6+M2mseqmxMDB5jUXEdWUQiC3xowWQ5DQaxzItMWWCR6pJFK/f0PBPKJz1+shqStTONPm0MofVKMqXHURDT6CqNaHUOPkNqorOdU1l+7nPAs8Pg8qUtBwFI29y0RG80zVCwbTBPwot4jbGCUrDDwkYWjniXwTQ03//n6o51MV2l8FSNj33YXaeMdOGXMTwmDNrHs/c8nTwn6woFO2D3QOb+Ml+/1An4IuB2ELS7wtppA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Nyxqbe6q9Fe9ImPjc4udw77Sap4gfqUGkr+D8l1BEoaQQSutvHzzDOsQHZF/M83nx5j1/1YEEQkErWTNiA9FLkd6WVorTb2f4L7huWemwScX2e9neW6RAWzLddlolSw2irJLKnoV6AOUPXYWO7Ck2cKgNNwU7I4Ck/O49SwGkuLBZ70j2/TFYlKSHbm7P4Y6ShblUfoNfYsETuL9Ai4j3J34erKIEJlCdDV4DiI8iHJIVZgIfgcF8Mmh0nf9xkB9jJWX0r82HPcZj2Kn/BgU/wGmuGFBY90wRqpZTS58aMBrsql8X/UUKs5lM34bKMMheRNLVf9UjZQcdcKo06VYPUXBTQp1M7fdp5fm0PWA6amnp6zGDldpAiVNqKEUPUM/vNYru6PrE/PLjkMzgjE7RfrAbr+dhWsc65Y4Wbl7uvBvAdefoC+HUyA3Ibdh5/C8XaFH0lrkInvf0sMKh/+/JXLclg9gAS258ynr4Rvd1KuyOE/YM3akPs4xSmKjeODbvRcoN4vUed6CZziHgT4lEWA0QCEiGhKZIj5jeX12rBbigjMIfJrNas6MnZOUFpzYGEaeCBj9urFj/06f/09q/Mxxob1sw45Mro9tL8kLThE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ce110e-ae47-42f4-ef65-08df13bdca85
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 06:43:18.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fiq+6+iTCK0GUfspaI52ro99+LzfqOzx63lwVsTfplHhA8EvNtPwam7QkVDdMovr55nsO19CS27UjUAQEK5qS+HcSx+SpVjNqorLxKdizzcLn+uqABpthQKFmVDug6Vh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8304
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA4NSBTYWx0ZWRfX+3g9dAXN/DBy
 X9bqIFZzBW1kY4hoHEOKX4WYts5NRKoxFtW09MJBpW3QZzYTiErQgOzx0yGRbjZDUjdnsrMDv1X
 t7Xxz4q0Yjd1l8g9zlMti+PXqqJXjtjBT6vEyC8kKWAdvy51uegzyoJm3Fjh2QrXDh5ue21wOK7
 hcJfKmvt1JcXpim0sVqKfQ5z2j8C8XdwjFsaeQ9UGh+BVelqlSYJ9nHvrrClHGhcXw3FwRJaT4o
 /DwcveqUgCWRC8Jv4+6wwEb0/xAS5//6bhHrQPIUake88egM1bYY1sHZls4fZy/O5Ns0TWxiso7
 9o6nUaDGwtrAGElzmiZev/4Y9XysCaHVxxvOkC8MG8q/KdHhcijvQUIhOR7m9LMjb299UsAwQLW
 baR0gXNozxTL5mSzh7284Wt4w9/I+lvMkCzByKJwjGLt+Yz7OjaKKFpU0ZE4gTSeBvy7fMo9nRN
 sRFZc/gjfZvfl/8uVqgaF8LcTtSFO4IP21uiQYgk=
X-Proofpoint-ORIG-GUID: 5GNPym6al_PlOTMoA_ZnPySxEg2tD-35
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA4NSBTYWx0ZWRfX7kZJrvl5U6fr
 utsKWOkl3jnq2ZNQR6dmN1pmqE7I1EsenNQMqNvQQhtB+hhYAqpbMhw7ZpXKgD7g1HX9KOdzPqf
 6r+zaRflTmXYvWaKG6rDF2MSFfR0zx5t3T8jdE2669W02kGMQ7aH
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa3a8b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=edf1wS77AAAA:8
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=hSkVLCK3AAAA:8 a=ag1SF4gXAAAA:8
 a=DEMaEyTWBYHPUdd67NcA:9 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=FdTzh2GWekK77mhwV6Dw:22 a=cQPPKAXgyycSBL8etih5:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-GUID: 5GNPym6al_PlOTMoA_ZnPySxEg2tD-35

Hi Greg/Sasha,

On 12/09/26 12:13 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jiangong.Han <jiangong.han@windriver.com>
> 
> commit 826915b6b65e2d3251e7248ea54289a22d748c84 upstream.
> 
> When a device with has_dual_ts=1 is probed and the is_audio_only path
> is taken, both dev and dev->dev_next are added to the global
> em28xx_devlist via em28xx_init_extension(). However, during disconnect,
> em28xx_close_extension(dev) only calls list_del(&dev->devlist), leaving
> dev->dev_next->devlist still linked in the global list. When dev_next is
> subsequently freed via kref_put(), its devlist entry becomes a dangling
> pointer in em28xx_devlist. The next device probe that calls
> em28xx_init_extension() triggers a list corruption BUG when list_add_tail
> detects the freed node.
> 
> This bug was exposed by commit a368ecde8a50 ("USB: core: Fix duplicate
> endpoint bug by clearing reserved bits in the descriptor") which clears
> reserved bits in bEndpointAddress during endpoint parsing. This causes
> fuzzed endpoint addresses like 0xf3 to be normalized to 0x83, which
> em28xx interprets as a vendor audio endpoint, enabling the
> is_audio_only + has_dual_ts code path that was previously unreachable
> with such descriptors.
> 
> Fix this by removing dev->dev_next->devlist from the global list in
> em28xx_close_extension() before the device is freed.
> 
> Fixes: f410b4093fdd ("media: em28xx: split up em28xx_dvb_init to reduce stack size")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=99d6c66dbbc484f50e1c
> Signed-off-by: Jiangong.Han <jiangong.han@windriver.com>
> Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/media/usb/em28xx/em28xx-core.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -1134,6 +1134,8 @@ void em28xx_close_extension(struct em28x
>   			ops->fini(dev);
>   		}
>   	}
> +	if (dev->dev_next)
> +		list_del(&dev->dev_next->devlist);


I ran an AI-assisted backport review and have checked the report.

Upstream removes dev_next->devlist because that secondary node could be
on the global em28xx list. In 6.12, however, the immediately preceding
stable patch "[PATCH 6.12 0190/1376] media: em28xx: defer audio-only 
extension registration" already changed registration so only the
primary device is linked. The secondary is reached through dev_next, and
its list node is never initialized or added.

Upstream source code:

     if (dev->dev_next)
             list_del(&dev->dev_next->devlist);

Downstream 6.12.y registration code:

     list_add_tail(&dev->devlist, &em28xx_devlist);


The new unconditional list_del(&dev->dev_next->devlist) can consequently
operate on zero next and prev pointers during disconnect, causing a NULL 
deref ?

Let us revert this ?

thanks,
Harshit

>   	list_del(&dev->devlist);
>   	mutex_unlock(&em28xx_devlist_mutex);
>   }
> 
> 
> 

