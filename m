Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6681C3F1055;
	Sat, 29 Aug 2026 20:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788036108; cv=fail; b=mSWV7ZOeDpkI98vtIO9OeFTOBwLt71NLamY+/oXCQMO8LnD2izIxQPur5zVJea7DLL2yLYslminThwETB9xAwlXANdmV4Rq049qXTa/x2NsH3699FMCR0+9ZI+eFKG7Dh0e+K4qlL4qKqEgaqFYm1/mUsfkThvGIm6fXNZow5MU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788036108; c=relaxed/simple;
	bh=rB3Z4AJLqsWS+0CQK5BmhxDxS3ELjYJJ8JEQIuyUiJI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eWZkE1ZHWCdX8FVblbjvZWRtW7YSkGfTv5RbSocmsqcIhbWi/dP1cGi1WZDAxrC1B3CtI9h/2uc/Re/DO6PGnJmzklEiqfewXksL6hIy8IuuwyYoK1p/aCRGzrra1t4UtQgNOUpmW/06dYF7lu9ii0PZR4urz+T0y7f5zkqk/N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hN4Ti9mN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zz6AQUs+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hN4Ti9mN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zz6AQUs+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TKYN9c1580691;
	Sat, 29 Aug 2026 20:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=b2Ekk8EnnIYB2mWxFGSeokhE+WfPFrC4gh1GP00x218=; b=
	hN4Ti9mNCxrBxiav8upWrBudDKCdR2gweIpvh8SdH8XTDZU3Lb6Dp4yLqOwMp4gs
	2gmolobnKK8GLU/bM+O835OzNPBAcYxxEVMspRVuG1x0NzXK/qDVx+m5cSswiDVC
	pikJaCSNQ1EqkkTl1tA23mwvng88MpdQRw6ba4UFrqek0vpB5ktoATwrFFZJlR8q
	1Gocn8LaGFigUtqhBr7CmHEw3uwKorrUv9tlsWZyR/igtqw2nO5KJexox+WAzXfP
	T1fU6qzjrXM2rUXKQp5Tgyiog6KecvhRfl0erIAdC7Fk1fb+bDaKZbsJ2xTnqCSF
	uI9TA4Cr7zcpdcgNEEkjzg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbnub8mkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:41:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKeT00009512;
	Sat, 29 Aug 2026 20:41:35 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011026.outbound.protection.outlook.com [40.93.194.26])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvmymp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:41:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPnbKv48ycVB88oyztdpBE/yE3k7XQwwwWldEDsnsP0e3EFnmYcEtUNSkw3k/qTR+xrIMmrf+pORsTo0aTW2iGueCCfZPPJudYr4lQ1qGk68gDHlY71FspN7ZOgXs7GNwNJU5VZTCT1Lia3le/NFLzf94L9LLDjB6+snzOIQ1Tqt1QJzxxW4iFl5c1vlWU6SC4o37YMbwdqzzT/7iR/DB2hRP6f8Mueb5PdSA5XwhD6KS4l3mBCpGOwZi5SUQ/Rug767KdXn2mDh+4PXUE21gnh5AFikmeeX/1YdQzPklWgxDrlQ2CPWuq32je+ScLlyBQoZPhsOxUNaGYrlLfXEoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2Ekk8EnnIYB2mWxFGSeokhE+WfPFrC4gh1GP00x218=;
 b=XjmZ8KsvxOzk+h5oypWhhVTrkJ7TgtoDcwCvXdoQvI4cYQjr5nE4ViGv6BQKrWhjYeXX1MxZXKVfcSzNQlQgmKOFBSdnf5lTqNpYAGNtI1UIVXmjfBxa9vrJRM3c3wHbqXa/vgkXB4uHXixK2A/o15etW+98fagJe6WManc6HrgTS2VvrvXDFnUjc9xnuaSkrH+f8+kJk8Lcre33KIAg9nf4quWSJUqACJXGuVxBnI7hT1wyE4mtia6KwntHxI0QYYAX9aDi1j5PFh6GyDntBKBS6NKjadz1FivIXKiTMVvuRtGG/xV2BcNq73dRrY9EqCLtx8xnUQs342y/68ht/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2Ekk8EnnIYB2mWxFGSeokhE+WfPFrC4gh1GP00x218=;
 b=Zz6AQUs+uF5LGusbPvLPGHZEhXTEmFLn7bOC1wey90JPk73hX4Ks3wj+RCizKdxZTjIzwuDhOQdwRZxvIgrWCQK32ZOZMvi7SGSshAjTT/YE65dVlwXgSMGrM8D63pXEO1fxbMkfBitJ24XJVcMvYUq4ldcr42nWEaY3koUeix0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DM3PPF51A640DE3.namprd10.prod.outlook.com (2603:10b6:f:fc00::c26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:41:28 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:41:28 +0000
Message-ID: <fdca250a-8965-41a9-8995-af8cdc28b5a3@oracle.com>
Date: Sun, 30 Aug 2026 02:11:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 111/272] mtd: maps: vmu-flash: fix fault in unaligned
 fixup
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Florian Fuchs <fuchsfl@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145231.229664293@linuxfoundation.org>
 <20260820145234.598655383@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145234.598655383@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::19) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DM3PPF51A640DE3:EE_
X-MS-Office365-Filtering-Correlation-Id: 895c8f08-19e3-4140-63dd-08df060de6c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|6133799003|56012099006|4143699003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	w5eyIxvgZSdBiaXSVP9DTcfJ8XJ9EW3qwYsVsnDrS5UtjaVeVKLJ2H/AF26ZpXSafjPAgjmre5osZ8jphm207TNkdOWtSy6maP0P3wxhatb+6N6SJW4KlHScC+R0GVjE6fRu1qS4UDqxpcNxcTYWnVOXMXOu8tdl1PUDZ0AvlP4iuIWa25tefBZ49F4SEIc0qUJOl74+fwsoVjHTxAJOv15ZhqSnot25vbKH5Av2rKeecJ+UjrQODRVd099SaeTkpDFfjdqeifO/S4czwlmKZ3OTV5aH8HZFZ6d6VooGyey1yEbmMUsKr2UOTxyfdxMXCQS6bGqQYuG6keu4f1AfNCMk9l5270QCBiDS4/qXRI9Au+JVHpGb458A91LSU1xe+Kc/49+V633dY4od9TXgN1ZpUJe7YlD3VlgB7Hvt9Ej35U2wiLZmDHLF710yH4ZIGX0QCkFatzT6hWVx6yp05bwR53k++gUwr/L2yt/Jqekq4+hBj2DsiWoMBDUaGvqNuaJLW2ZqyTMS53ZTK+iOK0RsUkhmSwfk4tz0NTfoCBEuPGHcgw7/2MpHtTvDyG/Hc0CiCK7DECSpmgcQJddGU59J10rlBj147ybDyzhsler7WnZuXT0UklmbwLID9TaTEMbbyxys3r6GEL7IS1xaRMbMgBKJfyiKVTdkHky69D8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(6133799003)(56012099006)(4143699003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEREOGdxaXZUNlA2UVRWLzI3TVJMR3pGRGF0MTVyYkRLL0NWdDlBWGNNNGQ1?=
 =?utf-8?B?T1NidC9wSXo1NnRhNm5zYzFlSk9iWWFwVENZQndjci9RTWdyVHZLR2JkYks2?=
 =?utf-8?B?dkdNRmVTaitvNGpSZkZyWmdUbW53b0p4ZjBwWUorekM5aTQvNmRHa2ZZUW1a?=
 =?utf-8?B?Z3NWTWRGV2hyc0Q4R3J1WGRZSFVKZFdCZWhHcUExMkdYbXJ6OG1EbWxWNVh3?=
 =?utf-8?B?ZVh6QTV6dEM1d1d1aGpla3N6T3JCZGdabGRxdlRPb0NFaFhUMnBrV2F0aG1D?=
 =?utf-8?B?UUxjbUhReEY3Vm1tdWNSUG9VU0JpMnp6ZWk3eGJrV2IzVmpZSFlDckhDd1Zt?=
 =?utf-8?B?TWduRjBGb2ZUM2paUGJoMlV3aUthZW96bHI1Wk03WTFtN2hINmtuN0oxbG1u?=
 =?utf-8?B?MEJ3YjYyWGdKZ0lKUjZoaVZsQThGMDZMREZob1lMcktTVFkrVnlaSzJET012?=
 =?utf-8?B?c2ExOXU5N2dxcXZtK2N5RGdtVmFnME9qVDgrUWl3Q1NyZGpyS1JCblVqa01w?=
 =?utf-8?B?Y05uVkh0ZTlRNkI1OUwzZStidmNyZmVaWGRyZjhRUlkrSVNkOXJGTld1dlNZ?=
 =?utf-8?B?VThEZG5LbHR5SHNpdXRUNDlKd1NLcG5Bd2dlWXFMT0JjN241S2lmeGVxK21y?=
 =?utf-8?B?YmlsY3FVUUwwRGJOdUtkUzIvdU1jK1k4UUJDeUNZWk1lcGhXNHF0Z2lLRVpK?=
 =?utf-8?B?dVdxWlkrNzZSZ3N0T0w3eENENHU4cXhRRE5RNXNHdkd4NmMwTTVraHVxWDVx?=
 =?utf-8?B?eWFqRHFBaU9EVGpFTDFpRkhsdFFUWEluVG9xakx2K2tQdExaaG9JNWN2dXdh?=
 =?utf-8?B?eDc3bzhYcWpjblpvZEljUkI2SjR0Q1lHRldTZXBQRzlpSmZwUy9WenNXODZ4?=
 =?utf-8?B?b3JKdGZJWHpOWFliQ2JKZGtsWmhkd3h0aW5Vdjdtd0Z0R0prOU5FeDhwbVEw?=
 =?utf-8?B?eHMvWEhwclZBRUZYcno4bFNWNkRnZSt5Ujdxa2JFMXVvc1hWNFV5UU15VkRU?=
 =?utf-8?B?cVhtMXYxL2U1bGtGNmlndEFEbzJYdjlpazNySE13VndLQnFHdjVXeHJZZHRm?=
 =?utf-8?B?OHhaSVhrQ1VCYXdtUW9YcGpNS09Jck8yd3FXZG9Vd0tTaHhBYysvYVNIZEVh?=
 =?utf-8?B?UzYwM0lsRitqL2RPWWJoS2dMZURpM1JndDQ0bmFOWGhpTTNLWGRTWEhrcW8r?=
 =?utf-8?B?ZVFMeVZmYm1sbTdOV0lDTXBybkhwd3dDNS9Rd1VFd1M2MENwZWMvTzNHdFRj?=
 =?utf-8?B?QlV5bFNVcWNycGpGcnppN3hQWjMyQ2g1MVpLM2VUNjdnOHk0bHNIeUl6ZDRJ?=
 =?utf-8?B?ZVBvK2xBNHpzSGwwZjNZMzZBNHJXVUs1dnJveG9EeTUzeXNiVU9FVFhMUlp2?=
 =?utf-8?B?elliNFJUV1dhVUgvM0tYOWJlQ3FsbHkra3o1anlobXp6TnIxUnFjTzNGYTc5?=
 =?utf-8?B?Z1V3dHVJd2V6R09CWkFMRlVqUTd1RjV3aXowZkp6UlMzWWtQcEx5SEJKWnc4?=
 =?utf-8?B?ZmNQK1ZsSHZNUkVLOXlJeTM2aE4zTmFNd3g2YlhQbTNZenBSTnV5ZGloY2lX?=
 =?utf-8?B?UWdxWU1CWmVhTDU0eUtGUU1MVTVHK1RaT2p0R2VpYXpISmNhT01qTHJlaDZH?=
 =?utf-8?B?VDIxdTZuMVByMFlJVldnaVJHS202SlVpRTltYWZTTVNYSktmM3B6Z2NBMUEx?=
 =?utf-8?B?NHhENEljTTUrdFZOOGRVNjdjbGdqZlVhZmVIZVluSGFHckFKN2FVL3JZOUwz?=
 =?utf-8?B?Vmw0bTZFSy9TQXFpWTNVcTlSem1qZHNob1F0VHNsa1EvSG5uODdKdE0xNFor?=
 =?utf-8?B?K3NkaXYzR0F1UU50dVZRZVlEL1F0QThrOGYwK1FqTVhNNnVIYklxa0tRVUhq?=
 =?utf-8?B?YllxQlNhSG54dW1PVlRUb0duc3ZLaGlGS0RZS1B1S3NZN05IcDdLTjB2VSty?=
 =?utf-8?B?ei80T0l4eGY5MUswV0ducDNhakJWWUVpZ1VVaXI5MlBEU0dFV2R2R0hPREwx?=
 =?utf-8?B?OU1ZdnRHRzNIamJSY0VWdU1TT3JhVEtTUjRmdFAyTUprUHJtYTl1VVBlOTlu?=
 =?utf-8?B?anc0dzhkU20xTDh3OGRHS3UrTlRKVGJPYTBndmdjVG5nQlFRV0pIak1MS2VS?=
 =?utf-8?B?N2kwQkNwblkyQ0xiVWNibFRDZU5VKzlGZnVDajN2dVZDZ2VkTmVTT1ZDM1Qz?=
 =?utf-8?B?L3JISVIzTWRsd2pzV281bkJoR0hLLzFTMU9BbjlJSzJlVGc3NFd0OVNRbzNv?=
 =?utf-8?B?eGRhQ2pjcGU3UklTSFNQRlYzcS95NjFDSTB3QkdGUzl3MXZweU4vdTRSVUtj?=
 =?utf-8?B?SmpBMzRYTG5HUmRCdFNhNS9xL0toMVIzQ2M0emVLcnlTdWovMlNzeU51WXlo?=
 =?utf-8?Q?oFI2T4dwVns3qkkMjPJg5qOT0cu9mmhUAVsLr?=
X-Exchange-RoutingPolicyChecked:
	o9Wdx/2P3Nav92OoGUttQBy5p1FgKAWwBvx0DcItHl5tE7hAIblxMCL4RnagTXoui5SC41BN7EJmVRK1So2285AFBIw4trBvLVdlORy/8zjYtBF4ouJ9/MlZM2Ahh57wBA07UYC9+Bhl+UPUUYJheVprj8dtCS+G1SF/pihMPsBlXhgmnZyt0+eS4oorK+Dsna4wKtlcjSN357lkGJ4OUva3MOiW+7ioLzJbBqHwDD3LV1AbKv9M6fffEG0NjRut6nVgQVQg1P6hXM8MxSxNmCob97LeJgXf+4kuxVglbuadH97342le7GtOeLo7NNIumJnTbtNT4p+My9Fkr/AF/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lUrN3EozIx82gsETwMhXJS3LxWIHLyAfCccnHC+y+I7F7wtRJre73GpfJemA+/e8/lRRZQmPgT2H1zzE5eNehVxRg67p/L0zf4TKpc2NA4tDKnrUtY8/mFTnnDTPDrSBDsGVgdBCelKx341LAfTSMJlKslQc+H79QYhQyVmPOqVk+8RoiavF+FRC6doAdCBiKXBAd5xrzsOUYsTX95n7InNqTJ7W3nFrZ/+vBu6lyoWNcTcY85zRJMK2BuK25rHJFKHi7G0u4cGQ1mBUI1+0Tzupz773pZcdyaWuZvINbFk6heSWFB1ztSF71+i1FRpmdwfmvasPb+wHOdEnezpj+0ldMFVgwLWUmJG8+gCMd8E1H3KhgcsAKvrPZMJiuBvH7pSmMRBnIhxVpnr2bntFn0UI2oqw8WmeTmE3MwlJtWRW1/9anRfc2EMfobBYFL8CExtxXy7j6oPsou+VqFszDKJKUT5dhFBKmQZs3E3v9HFbHet8mWE1tTNHGqY0DrY7Qi78PswvZ9KfJuEgupCQGOo4AKk8V3RyC9x3cFXBAuefRtGOgtoZh6lE8g5atgok2zb7mwumE1OZa35SgrbfgTh/rpQ3TXWXNo4erqWRsEU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895c8f08-19e3-4140-63dd-08df060de6c9
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:41:28.8096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tci3ntmMnCVC0KAMTAgrGCRQQkU38FCUIcMmciOVyVACFZbkirq3zUBdK/rh/kzIdEl548atu03NckQNAlctOLXzj5y1a00F4J8A0ygwDVc91r6Io+CqTG3WnOyWIYfr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF51A640DE3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290179
X-Authority-Analysis: v=2.4 cv=QoJuG1yd c=1 sm=1 tr=0 ts=6a9343ff b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=P-IC7800AAAA:8 a=ag1SF4gXAAAA:8 a=Oz-wGW3J3C8TzBbajEUA:9
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: jG_PU8qXw9eehyc8hzPJeB4l92HiIvbx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3OSBTYWx0ZWRfX2IGbgaUzPNx+
 2fQkxUCPMk9B5HULyNwYZq4TwBluXg6yZPKYaPgmNk6FtKB856z3fAXuIXbFVS2d7i+kinS8HGh
 zJx6cB7wkmxI3aamzH6end6RrYs7c6zAN+CQwMVB03ustszKRDz2LRy+tHSn3oWByM3LHoUsxBD
 Dge5+EHesWMsUBv3xW1dyJgD0iF7Cn0C9PK0dfyIq3nDwZ/8ex3o8OkQsYETAp1yR2hMBwAMv9X
 yKAT28aVtOcYizX1T0KXor/CffY6EALAEayk4jEN+3FJVrSNHTjK5Ix/kCtPg2vSmXi8maYO/B8
 ZevggGQFuX8NvSPVgNhpcuY8nzpHzaxZ8gzL0eeXkVZetRG+elFzuHd9tlGsHYjQrnEq39iQ7uH
 aGMiNKdB+LS6AWSBOemgTCWh4fy3fYfQCcBkgyap3A7Kj64uaCxVHvJpibmSAuDPD+xEPFhnf/H
 jG+38N1Zot9XbhG/ka/AOjTMTuVJMv88Gljex9mE=
X-Proofpoint-ORIG-GUID: jG_PU8qXw9eehyc8hzPJeB4l92HiIvbx
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3OSBTYWx0ZWRfX7Q7mQqySLIyS
 DzU7dnLTb02kTqLmz8Lhv9fo1+I/0kv1iI4dcv2RP5Je+qa9jHzAQp5Ow5vLshAr2aNomOz0GYs
 lrBlOi0oqxkkhj8Tg6a3TdpJOnEWc1iypFR/WwX96zC0ZZrLUJKv

Hi Greg/Sasha,


On 20/08/26 8:24 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Florian Fuchs <fuchsfl@gmail.com>
> 
> [ Upstream commit 79d1661502c6e4b6f626185cef72cf2fa78116e1 ]
> 
> Use kzalloc_obj() / kzalloc_objs() to allocate the memcard structs,
> instead of kmalloc_obj() / kmalloc_objs() to prevent access to
> uninitialized data.
> 
> Fixes runtime error: Fault in unaligned fixup: 0000 [#1] at
> mtd_get_fact_prot_info.
> 
> Fixes: 47a72688fae7 ("mtd: flash mapping support for Dreamcast VMU.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/mtd/maps/vmu-flash.c |    8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> --- a/drivers/mtd/maps/vmu-flash.c
> +++ b/drivers/mtd/maps/vmu-flash.c
> @@ -610,7 +610,7 @@ static int vmu_connect(struct maple_devi
>   
>   	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
>   
> -	card = kmalloc(sizeof(struct memcard), GFP_KERNEL);
> +	card = kzalloc_obj(struct memcard);
>   	if (!card) {
>   		error = -ENOMEM;
>   		goto fail_nomem;
> @@ -628,15 +628,13 @@ static int vmu_connect(struct maple_devi
>   	* Not sure there are actually any multi-partition devices in the
>   	* real world, but the hardware supports them, so, so will we
>   	*/
> -	card->parts = kmalloc_array(card->partitions, sizeof(struct vmupart),
> -				    GFP_KERNEL);
> +	card->parts = kzalloc_objs(struct vmupart, card->partitions);
>   	if (!card->parts) {
>   		error = -ENOMEM;
>   		goto fail_partitions;
>   	}
>   
> -	card->mtd = kmalloc_array(card->partitions, sizeof(struct mtd_info),
> -				  GFP_KERNEL);
> +	card->mtd = kzalloc_objs(struct mtd_info, card->partitions);


Hi Greg/Sasha,

I ran an AI-assisted backport review of 631edc934e47 and checked the
finding against the 5.15.217 endpoint. It spotted a 5.15 allocator API
mismatch.

Upstream has:

         card = kzalloc_obj(struct memcard);
         card->parts = kzalloc_objs(struct vmupart, card->partitions);
         card->mtd = kzalloc_objs(struct mtd_info, card->partitions);

5.15 has only the legacy zeroing interfaces:

         kzalloc(size, flags)
         kcalloc(count, size, flags)

kzalloc_obj() and kzalloc_objs() are not defined there. They came from
2932ba8d9c99875b98c951d9d3fd6d651d35df3a ("slab: Introduce kmalloc_obj()
and family"), and the argument-less form additionally relies on
e19e1b480ac73c3e62ffebbca1174f0f511f43e7 ("add default_gfp() helper 
macro and use it in the new *alloc_obj() helpers").
Every CONFIG_MTD_VMU build would likely fail, so the zero-initialization 
fix cannot be used.

Maybe we could work by adapting this for 5.15 with 
kzalloc(sizeof(*card), GFP_KERNEL) and kcalloc(..., sizeof(*ptr), 
GFP_KERNEL) at the two array allocations.

Or maybe we should revert this path, interesting that we probably don't 
build test this config :), so do we care ?

thanks,
Harshit


>   	if (!card->mtd) {
>   		error = -ENOMEM;
>   		goto fail_mtd_info;
> 
> 
> 

