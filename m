Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB22307AE6
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756909111; cv=fail; b=kkJfOk3BlcqlUFepZgYB4QxZNSHHMR5ZvElpB8tsWNce2LKai10lYSwJY3N40NLeITkeTaO6vDA6Y56QXHEAK7XXy6sVhFy5gO1km38P8eZe1TdGpoeeXOxEaPaureHmyoOOTLVfEjCvaUkmr/dStMxpJR6/rBSY7LIqPs0r+00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756909111; c=relaxed/simple;
	bh=eDaRJE3LAaDmPW8OEMws4idFYNfgUdG64HN1l0iikQU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=am1ErpNqpegCpbmS0+J406MWGdlzZnnGBxfqJUjMj9U21ehucMYGRnPoq2Tns1WrzmdBcBkd1UujwGoV2Fnslknjg1PuiKgUCPOfwg53IWcCd9fLnclF91FELjmTJXFDxlWTQfviaZWo6+sM+gnLeLAdxF2SYv1xAZqAcVWYk0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TZjeGO/X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ucNt9UQL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TZjeGO/X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ucNt9UQL"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5839NBlC016008;
	Wed, 3 Sep 2025 14:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WM6828uApG6nC/k94IAIfEiydF9PC1hNZXSeU59rlDQ=; b=
	TZjeGO/XXlxNHgLY3247gbcivPvhQkuuue/2t3PAJCJXwSA6Yun4qLn/xZz7C9rl
	/PaDRFJSB/opCT+CYjvJptiQQEUZl8X63HVBYRCwBMUD3i0utlNrPXABSPVbO8qA
	55JmSjumfu7Bdjbm8JnWogcizIq5SacYW7KlNEgew/07rwWLXFCdZrizZbRD1cVf
	feb1XQMq5TM1IPtdekmTvP9hDEkTx8NK/6f6iQPeVZQSzLVzE2UpJEMANouhuwQt
	oNoHGsocT7OA+ane3pTx9KNBFX/Z/PksVUS/BM4ueayPfSMh9f2DXyhKTxXtkb5c
	oZob1CZISX9mtWsmeLtosw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ussypasj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 14:18:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583DTno3036213;
	Wed, 3 Sep 2025 14:18:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqracyb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 14:18:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNOutXMC3s156KqsiZP+TrPAlmeHs49DYaqi2B539ghYIpD0RohCpl0cVNQu3ETdZF0SSVv9v8r0YX4bcf2IStULU70WXLawOzN2AOwbVH4wAeeu/9TiJmuyL/ZGnP+Dr76YJa52PLVDpf0KCcK0TGlDjke6M5rOE+M/GdgWeliqV5qVqeJcdmR5DNLHW/9N4JzgXbawiaFgA+1PhLYdTQA95GSBT18+zbscTa54ftJTIqdMZbl2kiqTPSDXSKfvGNAnTGHhcE2K4Qi9SZJyURa1yuUH0q+H6bfdgrujXhtnTxMlHAhGGXG1CDNUilmGCdLv74S7LQ1UMGgQkTXllw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM6828uApG6nC/k94IAIfEiydF9PC1hNZXSeU59rlDQ=;
 b=ggONxKg3MZ8bkIahMSmkG0TK8opLlzQoVGGhKb2PDGIgdpS02pOK6Kftz6du+qhznq1PCH2gqA3Qh0JhDwsjebgmySSAtJZAI2439Xr05ad1JRd2fjV7q+MmAVzAcH/YTlEEvdOEgUCRjPfg1FA6pRsw9bfCDGTa13/Dvb7xo8V//kFxlyoT6Ipvb79we4jGWQzq5pUCrGwcHDekemBPInmhbOUYT4yrYuOVIf3cFH8pQnlUUI0dNWVZeef+EloVyaxpcG5PuyhjJWViPIbvPNW2LEmYx0aQMYya1t+4Y2XE7EGgDwQV/WGMlFMXPRb0U1p4LxZ3icMCPbfbacbKmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WM6828uApG6nC/k94IAIfEiydF9PC1hNZXSeU59rlDQ=;
 b=ucNt9UQL6ffIMnTdrW8h7+saSRxAz4eoN7/L7CDv1WLgcJYywDIh1tcuY4hfCJDHSldJ63zuzWZvpyXBfHYizkiJTPn7cd4XP/C7u8Yd8LvHsTP6O/AG7Zz7S6+W0fkXx8gN7/GFSKbw9HcKUGuSB1uXcY1B+AnNiYUPsZzwfgc=
Received: from DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d20) by PH0PR10MB6959.namprd10.prod.outlook.com
 (2603:10b6:510:28f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 14:17:39 +0000
Received: from DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 ([fe80::5e2b:7bd7:5247:ccf]) by DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 ([fe80::5e2b:7bd7:5247:ccf%6]) with mapi id 15.20.9052.027; Wed, 3 Sep 2025
 14:17:38 +0000
Message-ID: <066215c2-342f-49b8-95f0-d7b02deeff15@oracle.com>
Date: Wed, 3 Sep 2025 19:47:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250902131939.601201881@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::30) To DS4PPF5E3A27BDE.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF5E3A27BDE:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 8846e73d-2e56-4262-69fc-08ddeaf4a2c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzQ1QVNNV1NKV052M2RQRlVGbWM4aGJPSmpISlgzcEN2YW45RGsvOWJBM0lV?=
 =?utf-8?B?SlJxTjBWL1ZGS2ZMQXlhZXo3YktGSUxCcEI3MW1jam5RbjdReFpJYTA3S3My?=
 =?utf-8?B?L3pCaVpnZmtFbmkwNDN4NlFQLzdaOGtVYnRod0ZqVGZlRU93WkdBdlorcHlq?=
 =?utf-8?B?eTVqeVBKUDdRWjBCTlJHR0dMT0ltYlRvdzJwdzRLU20vZ2xDWCtJVklGZkZh?=
 =?utf-8?B?Y2VLRHROd1FQMWsrdFVKY3JGQlh4SDRNUUxyYW1RMTlBNHpBUWpiM284azVm?=
 =?utf-8?B?akk5bGhWbFNKOEtsVVNtNHdsZEtPVW5SVXl2Y2NWdWRKZThSck1HdnRPcm1I?=
 =?utf-8?B?SHlUVEV3YmMzay9qSmZMK2NMMUV2dE8vODRUcGR1R0JocHNybFV3THlsbnZr?=
 =?utf-8?B?cEFuRXk3R2pySFlMTGxXSW43eE9HZVI3clozU2ExZCtJcDB2QTV3elZjTlFa?=
 =?utf-8?B?UEFzTUg0U2tqZkZSOHZEOHhkVHdoYlZmVGcwZHhLYzBvNzdyb1AvK1ZnYXZ4?=
 =?utf-8?B?SG1POU9rUzFlajdZdjdwZXdXdzhuOFNCSzJPOGRPNGlWVWMyZk5aMTNkZEtr?=
 =?utf-8?B?d0h6MjFJQms2L3JtRiswM2ExOXNmVGJxU05aQmZYRnBwVFVhV2NTU1dRZXU2?=
 =?utf-8?B?QWxXMmFBeGJ0aHV1OHVTZTZEWXc2ajgzQURzKzdkWjJrek85SjZjTlhhMWdV?=
 =?utf-8?B?cE0yOE1KRU94dk9zTjl3SEFXVzlyaXBWM0pDUEFaOGRaUVBsTHJpc3RpbG14?=
 =?utf-8?B?UllSUDFCdUsydGZ2QjlHcGR2NDZubXJnOFUyV1RBdDBVUWpWVFo0RDBoRXJM?=
 =?utf-8?B?cjNTRmdtOG1VdlZFOEU3ejlGTnpqbGpsN1NURFBEMjF6K2diYkpzNzlGQVVr?=
 =?utf-8?B?bTBiNmVkeFdDL1llRTV6TXZLbzdVWWdYMlQ3d0hBSmVEc2s1dzVpWDRoOFBY?=
 =?utf-8?B?U0xPZDZIY3VQMWRXVy9kNmN0Qklzd0kzMTVjQk1BVG55aFg2bG4weGVpOFZN?=
 =?utf-8?B?TEJWaUVQUVFub3dLWEFCaGhoUFlmYlQ1LzNLQzBaVDNqNThhVFc1VWdaOEtO?=
 =?utf-8?B?YnEzVjFjV2MwamNlblAySHNHbm4wb3BYQjN1eEJwSGl3TkU4bDE1djZFNzM1?=
 =?utf-8?B?MFlhSHhhbm5MVXRrRlZTTld1azU5eUY1S1lTWld0bm9NeVhDanBNbnYzL3BI?=
 =?utf-8?B?KzRUZkJxT2JDL3Nad3p0VWdHYk0zbEVGT1VwT0dlcVM2M1JSN3hGbURYRTF0?=
 =?utf-8?B?MzNxNlI5dm51cG54QXVOOHM2Y3VvLzY3ek01UUp3ZE5LSkhOMlphRVREZGhE?=
 =?utf-8?B?ajhhaFNpMHBZTWhMaWluYlJpSHlhUFZCR29EV2gzN1VTNlBicms2SU5sYU1L?=
 =?utf-8?B?QXllL3RjQUNKNEVmZ05oekpaRGhLeklWdjkrZUdZdGpuemIwai9Qa3Zyb1dS?=
 =?utf-8?B?NG0vVVVuSEVNbmZVYXhlRVR2T2MwMThQQ3Zwb0FvTVhIaVk3Rkh6aldXMUhE?=
 =?utf-8?B?VHpmbExXSWZPMFJnV1orbnIxNTVxSTV2clU0TWRmbUk4cGo1STh6NEhJaDRq?=
 =?utf-8?B?QmI3SWNZT2syVEUrZlV2bnpRVXVMVS9YajJuSzJoanNpcmJDVUM0eWpzQldH?=
 =?utf-8?B?WHUydE1iZ0d6ZEN0c3UrRGsvUnZvYlZQZ2F4SU8zSzJVSkpGSE5FQTBNYkJJ?=
 =?utf-8?B?M3BzbVpjR1BZTXNNVUhBUlFaNkNkR3ZMb2hSQUdJQ2VWN3dCem5YQWxMblJ5?=
 =?utf-8?B?K202K2p1d3JHR00vN1hhODZQUUtxSm9ua2R5T2pxRmFCTDU2eTdEUThEenZX?=
 =?utf-8?B?ck5ic05MR2V3ZTlOTFpBZTM3V1BMb1Zqdnc1Q1FtbkFvd0RLeWkrUlc1cVhn?=
 =?utf-8?B?Snc0SE1Ua0VkN1JkUCtIM0tpcGgzUzJSekx6QkZBMVVhWko5Q3NzTElnNjFQ?=
 =?utf-8?Q?T+o7l/LNcus=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF5E3A27BDE.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0oxZ2R2STRydDJoNy8wWW8rVy9XRUZJZWdYWHZjd3MwdHhVRm10TDNkVE96?=
 =?utf-8?B?ZVQ3eGlDM3cvaEdXMkZFWWNheDhVZVE2aExTblFUUjZoN0NVSXp3YStpTFdQ?=
 =?utf-8?B?dlhURm51NUQ3cnRkeC90SDZwUXVkbHBST0ROTUtuaElUWWVYaHBPa21Jelk3?=
 =?utf-8?B?cWRkZ3EzTkZQV0VVNWtYdkhlaGdpd1loSi9DYURDTFR1QjRXUzhvbUM3WEt5?=
 =?utf-8?B?ZXh5cjRnd2xEdzZMYzhHTE1vZ2sxZUJEOThUTVR5bGhISXlta0ZJMTY5RzVX?=
 =?utf-8?B?WG8vaDBRcHl0VGtKd2pmTkhVaXhwd05WS2RTY1R0bE53RkRrelpQR3l1NmRH?=
 =?utf-8?B?UHlKcERkR1hjMUlGd2J6UHZ2TlJaaDAvUHFPclhuYVZpL2tvN2pHcllTM0ZT?=
 =?utf-8?B?cjRSRVhKNzZYWnVqbG9PRnU4TXdHWWZWMDFUZlcxODFHd3YzVHZXRzVpa2Fx?=
 =?utf-8?B?blo0SlJJUVEzbGgzSTUwY1NmSS9BNEViblVEcHVFR0NLUWJ5SXdvM1BTNFN5?=
 =?utf-8?B?TXRVU2VSa2pZZFVFVU5GTCtRbzk4bzFGeW5iMkJxZXFpTXdxNk9HOHJPTXdP?=
 =?utf-8?B?Wk1BdDJMOXVSSnlaTnh6RStUUUtXZkdrSldrV0o0TmlRMTV0TWw2MGEvdGtS?=
 =?utf-8?B?SHRob3pDcEtQSVcxam01TktVNnlUUmhpakJ3bHpYWU1FQjlFU1FXRkZlVGdE?=
 =?utf-8?B?TFBkNkVwOFRwd1M1VHhndnJKcTlqeFVFTjl6Z3d0NXhCZE14YWYyQTRhQlZB?=
 =?utf-8?B?OTBEUTBUMGd6TnhQbVdGYmxQQWp6OXRYeTBoMnc0OUoyU1RmQUQ5V1hJN2la?=
 =?utf-8?B?eTVxc3dVMWJVN0pCY0R5Z0t3b2VRVGxPaDlJUUFrakVWN1RCOWt3NG1IUU9j?=
 =?utf-8?B?amxBa0hDQjU4bFpkc2VOQUppdmVUTnZrbCsyL1JuVGlMRlA4Z2dMU3hNTTRJ?=
 =?utf-8?B?d2VVQWJZalZ6Z1lzbmhLeS8waGJpZ0RrZVpBYnlRUmN2NjRNeDkwRUxFY0d3?=
 =?utf-8?B?TlZmYTNKVG1VWUtveVBNVGxGcm02ZTc2cm9vYzAxbWpVcC9hQnVGODFhaC94?=
 =?utf-8?B?SEtlbXdETWJ3cnN4d2hqRStLRDJkY0VnRi91ZnoyNklkdWVkbTFLaStsa3Vl?=
 =?utf-8?B?WFpraWR5bzJpS0ZGa3lpbWNwLysreXR0Q1pqdHlMSVdJbG5HVXZhcW1YZEx4?=
 =?utf-8?B?VUM0QjY2bTlTcUtUSmgvVW9CNVpYWWh3QTdXb3BMbHd4VzdLMzhoZVJkOHlX?=
 =?utf-8?B?SEhRYVZISG1IRXNPRStYUkRidzB4U1ErMm1zNHZFZnJDNStNMHQweGhmZnlk?=
 =?utf-8?B?RWFFbFBIcFg0UThpNmpSOGh3ZzZFRGkxTktNNU9uNWJoQUZSUTRJUWgrc3VZ?=
 =?utf-8?B?SGg4a2RTdy9VRG1hamRHTXVhajhQL3ByTEZuU2lhK3lDRXdhMHhnWHEya2dF?=
 =?utf-8?B?YXNyMHhDU1c0ZFNBWVF6b0RBeE9NRzVicSt3UThQVU03d1g2cEplUmROeXNH?=
 =?utf-8?B?NzhzQ0phNXlNd3p4ZjU5SzdLeGNlY3AwZW5oUnNHN21TWjJyZ01aSkZlZ0N0?=
 =?utf-8?B?MFhOV2NjcWdaZm9kaFgwTWVmc1l0NWJRcTNyOGU0Z1poME1NT1AvZ3lVbjA2?=
 =?utf-8?B?ak43WVNPUGRBQkovRVBLR3F3YiswMUV5NmpoMS9kcTdDb2l3djBzTVk5cDV6?=
 =?utf-8?B?TCtQMVUweXBYM2NsVnpPOVlWUUFhM1Z2ckZoblJZZTBLRkh2dFZ4V0ZOdGxn?=
 =?utf-8?B?OVhnUjdNUTRKZ1l5ZDdBL1FraEIxQzJXT2VzRlRNLzhJZktEYkk0c2c0cklH?=
 =?utf-8?B?ZU9rcXk1WW1CK1owbnVFNWZjeEdUTHRDS1lHeWJJY1lFaGR5K2ZPTUJkSmxV?=
 =?utf-8?B?ZHgrd2MwNzkySGhpNU0zRHFDazZtNzhha25nU3U0c0ZMVWh3MUJWUHl2dkE1?=
 =?utf-8?B?WGlIdktsRlBTbGtiKzdSOWZIbXF6VlVuY2dycXlWQjVxZHhMT2o0NVJuNFNj?=
 =?utf-8?B?T0ZDOUpveXcxMTN4RlhnVGM1dUVGaGZXV2d2UkptQ3lDR2Uvb0hwb3pRSU01?=
 =?utf-8?B?NTJyUU9SYXZMWUpDRGppSjNvSnlwOFI5S0NDOUJtei9HZzNOZ01TZFNLcGd0?=
 =?utf-8?B?WWc1MWN6WExIbkpUcEtBMU1PUUFia1EvTzJMdU92a2xDOXZycEI1UjlDZEZ3?=
 =?utf-8?Q?sPa2wTzrQWw7r2e7Eji5upM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zc2IX676eyaD6lPVQAWsYbnEZMKF06Won9a3H0ZNlW4+fHNuthAfSkSQpn8A3rsYFftCX/Pl/JELkuZNF+wCTa4nTH71wkAmC5g/8Gg3fsZ8RfWIj2g/yUZMCHjgfk8PeTn94sgExobfxgVpVoUz3mxlHBDzw9Rxd5urXJoYLcJ/YLWfNHReBw6AXCJLNwSmSAfw8XH/9vv9xxtx3YHe5j/G2ZgNYWF9bYi9cwl396cYLP4o4XBFzb1rCVukNKEGH9bZNIyLCWgby1tb94omgGCIzGB+XUOEA8m5BttTrsjpQmbB6rkHZJxDdLZVRFNy8tWXzRtOg7xrRbKeDIT1tGeUUBUi8/rFjeY/PMmEj9SVxXQn1hCYMPjFKRygqduXVEad9hKAvab8VtjC1LoH4HUM+NJUtGpbSN0FJ5m9ssJ6ro9mBLceloZKsVGX1ntwy9rSogTqh7/A0Lksj55z7sGBP8pz3gtGZsISs8jr1TC+rPkRp7rWfwLGgx9gHdwt7/TVDeLaa3VJGrqCbRiPfvsn9pDk0V17C8e2NwCN5Nkux30eWcxjkK3jxJzJKEIuU8N+uoMl5YSuhCrUrgQtaqle1+XR3MM3A/F/yQWEdkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8846e73d-2e56-4262-69fc-08ddeaf4a2c3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF5E3A27BDE.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 14:17:38.4683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJ9AUvcXx84kXzkVnFAEEBkGLcNqUZ9w8VZLyIt7cAa/uW2PgiP5ef48eivR+FVuvZ4Cvfzi/81LQDToRgOBO/wMRRPwNk9XLA1T4u7cYloB6cNqvSegIiBQ+zw4D5tx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_07,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX7CMGwZ+roxP7
 DHMrIwZsCtlU6jke9JH9HBjn48iNXRiDxHju1OpY+iKJukHyC1xr39FQZ5H7Nnd1Gmbs7sSX8XO
 ekRTO6kspbetlOsz+CNqX6UIOhN5hMMvm+h9PZsMp4VbWKpGhWbb5jd/uAotKQdHfc9HvofJgp3
 jkSMLu7HZ8T+XJYcyn55OMrr/gnaR99ig03BN98qHgJm+UBLUvMRCy4Kz+p7OebxX0hM7TepyXm
 3qbqWs5v45XFzNI9LQ8xHKSAgt9kRrz4xGoRfeHOZ/o6mzaVZrQS9GCf6rxhDIV24z8U3tu5yOD
 QRJSjsVHRtiUKxvKy3CXyWOyM6vWYpLJHM9LEg00f5jNpuejZjtQBRFbZUzN4s0fNu++oVSclPB
 gMjpEyy8
X-Authority-Analysis: v=2.4 cv=X/9SKHTe c=1 sm=1 tr=0 ts=68b84e1d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=wQHQzwf_Hs2TCVCgcZgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MT5qXyvj7OXTxLwSYE7drLftyIuGYRgE
X-Proofpoint-GUID: MT5qXyvj7OXTxLwSYE7drLftyIuGYRgE

Hi Greg,

On 02/09/25 18:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


