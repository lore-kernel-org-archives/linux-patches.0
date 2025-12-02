Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0267C244661
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 03:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764647862; cv=fail; b=lPd8xcusFIXsBYuj6du//Jnz83b+0kF2FONjINJ6OtrpKSovlvRHT2esKbT/MJpUvvaSpxlnxDFrXUMFaXDh5QXdMa5mYpl8QyaLNO0brpGjHt+SAqzDO/0i7PfuPuYZktavExltxPgyveKRFDYQi+0xSBovhYdTJsaAGri1dAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764647862; c=relaxed/simple;
	bh=QoMQ/CufyiV/SxMdIajktSjKxtvz+quzvmf3VIvWlSM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EYDCLOmFuJv9eQyEvhEUte2uPfkZZ12+iKJVEURUsDwLbP8NIf4Oqqlttp67agXvKm14tF7XTQDENPjTzj4/GU3CdLyVxo1YgAsqFQrsk8EE6FGTKKMvJWrxeVYcGtBSlvdsZQCMfJJhL6nuvqN1gJY9Jo1Qe8FmMvVw6btBobk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=laIHXasJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XXJkl84u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="laIHXasJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XXJkl84u"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B21Nu9U3259927;
	Tue, 2 Dec 2025 03:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d2ebUdnp2PfwnhojvfQ4Q/LRnWW+Ag5o0aoGsxmA6b8=; b=
	laIHXasJtgl0nl8NTerTmCc2OuUHRYdcknj0zFVJKbscx5RxTGHS+4js2zBfNKV/
	unkcWaDdG4L9xpTmS8KTRnKFisOsMAwv5SzrG99oTr1RXwSJ9B03AZYUKufiLNxY
	Ivl9832ivSzppBGj2lSeXnzjSAYJ+4T42fC00LoNrjxvdZSI0hFuNxcb3zWwl07d
	u56Qj7lpvQ/IHgNKyqFdIR8yESRwxWwU9vKD9IO6KxC7JTX1Qirg9hcCAg1pWRYe
	qEIKTFseb26B2DjdBiaK7+u8xzWELl8Ir5RcQCdkKFrIqKxZfxG+H6ylZIZKPHt3
	mg0lDFJhA1c3jXDJ5lWPFQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as86y9xtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 03:57:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B22k1tX015229;
	Tue, 2 Dec 2025 03:57:22 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq98u3n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 03:57:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOfp4nLAQXRpzZ/97utaTXLNgcSYjaA1RzaFyE7Ge18A0gVFL1HM/sCgp9HP7eURDWn6LWVEscfkTgDkjFkEOidw9u6EYzPmabl0l9L1C7XZquTrDtjM360Qs7qcfQPJWUZoFlz+jOTBZT4Mwmg5WAoj3xt+1uWhAinvZSMTAZDh+e1IUcEbUHumVsgoMp5pMQAIieiv8W7+ktnMf5Uqi47x3ft+BuZ6GK+AzKo0tepwzs1ai0mf3L06cQmDkgDmu+V16Rc789tnKCggIOtnjsG2ED+OR3HBuS9dtn95i1rfUvK2DdH/R4YAbUSEAgx5ytiwsHQrTENiKQXyR5dKvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2ebUdnp2PfwnhojvfQ4Q/LRnWW+Ag5o0aoGsxmA6b8=;
 b=r0Qx76xRFx9bxfAtRNkK3VcjbFGKKUo4TgdzBXIin/twR63r8k9UnOq5hofdbb0YYWmgYe1eTlbfvpz/gVd3Yo+kfrGS8hhNrkYLWvmJwAJe3ie2ugYp9+wnrimuh00k8s+z1KG1DgYmev0v6obD5t+2LHp91G/7MlwkUHAywkOs9Cw4u8DaiKBwZkpfoFWm9DRsgtz78SgxUYi+fZgH2PnLWbD6OQdZFCJtF9C0YNK6G0KlVRQxwGWyUFNOCeYjMDJ1T9u+mD1cdmwM0c9I+ngzGKS+JLPYqhpnVIjsUlxlTh+H008L+6EBpOjeJe8VgF52vweZm5bj/ItE9nGggw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2ebUdnp2PfwnhojvfQ4Q/LRnWW+Ag5o0aoGsxmA6b8=;
 b=XXJkl84uOcN7dySsrEkxvmR+sY5iJKYdpEsEStklsuDJuJutTcNKPqE0wJKbkVkjkQZb5OcGSG6oHznv/NNHxNeiHPM72Xw8mA5w5Y1K3HpvY8GfGKPBZHhAveXrvfP8rUhMJYbi3NgPSNX9S+bQnhWMeKG/IVFNzL2sz5Ay26I=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by MW4PR10MB5864.namprd10.prod.outlook.com (2603:10b6:303:18f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 03:57:19 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 03:57:18 +0000
Message-ID: <71053538-b880-45e8-9dd2-b2a533c1ebc0@oracle.com>
Date: Tue, 2 Dec 2025 09:27:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 5.4 000/187] 5.4.302-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251201112241.242614045@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0046.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::34)
 To DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|MW4PR10MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: d6cf6f79-79c7-448f-22da-08de3156e34b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEFLdUZSZ1BaR2lqSDQrNWlUOXlNdStNS2dQNzVFQ0VGeUhHUTEwN0lCa1dw?=
 =?utf-8?B?YkxYMk5ydXkzbWg4SkRKckFkSHVmd080bFY3UlFzQkFKQjdvRmdRVi91eVox?=
 =?utf-8?B?S3JjdDZkWTk1MXdBSUo4ZUVuUTVlNEdnQjVUMFVZOStmKzlaaEQ0WlJCM2R5?=
 =?utf-8?B?NVFRaG5SL3dTWi9ldHhNL20wVzhpaHE3OHRSamFYNDFaQk9BUlFGc0hiZCtO?=
 =?utf-8?B?SHVacjE2Z045Vzh2MWFRU3JocG85eVBCVmVMRE5CNjloZ214ckE3Tll5Z1VR?=
 =?utf-8?B?YnpPWkh6ejZUdDJDdktBSnBjRHpTZTVHbjFkbStQRzVHdk03M3BmNTUrelpw?=
 =?utf-8?B?VnBPVlVlTkoyUWpPamdtVjRhcHEyc3hJZklZOGsyY0FmSSt4Z1lCR0xUZ25z?=
 =?utf-8?B?K2M1NlFmNDZ4ZDE2SUFxOXl0MTlKdE5ZWjZlbWsrN0ZNaW0wQk9jbU8yYmJV?=
 =?utf-8?B?SzNqNVoyMWJjc3JZYXZHTXhGNGhOQmNiSk9idVFBWkRsN0l6RWFpQzVHNEcv?=
 =?utf-8?B?clhUZy84NFIwWUYxLzNSV1pHRUpKM1dLUXpBZW5MOHQvVkNuMFdWUmMvMVVR?=
 =?utf-8?B?MFdjaGo0QllJSkkraGpUSGgzWGNsMFErelpZMXhzajR6ZnhJQ3VET2h1a2dE?=
 =?utf-8?B?SVozV0hqbXBsMDJ5NDc0MkpTUjh3RDBFKzFUQzloVGsrQ3NkL016Njk3MFpD?=
 =?utf-8?B?ejNWL2VKY1dYRXZYT2tmWXRFN0NvZkZIMk5LZU9QSHlOdnU0dXYrMXFpWE1S?=
 =?utf-8?B?VXUvYm16bGsxZ254SW5RWkxlbzFQT2NsN0RKeGZwZmw3bEs1SHJqaG9aeFNj?=
 =?utf-8?B?UlRSVmRrSlJFVFFKRndza0F6VFd0V0pJakRnVGl3ZlVjRThGWEQ2MFRLY1JT?=
 =?utf-8?B?ZTFULzMxR0JWdDdsc052TEtWM2RJVk0yNTZaOGY3dk1DRCs4MDQzc2Z2c1Ft?=
 =?utf-8?B?emJrT0hNckdzQXcrZEtHMXl3b1JvREtuL3ZMTFZ0YXJmVXRoanlMNFNIeG1O?=
 =?utf-8?B?bXRVVUlKV2N6VVNqeWN0aExYMFMyM3h3WWZoSWM1TS9hUVhKeTlXQitIRUZu?=
 =?utf-8?B?S294Y2RRaHNPb0lJbnZKdEdGNll3SHFoQU5RWGVmbjBnZVAzMDRjYmR2cVo0?=
 =?utf-8?B?YzlGc0I4Z281TXNaTi9RVjhEZmZnaEdtcWZOcUQrTEhFT2tubjY0VGtFR2FX?=
 =?utf-8?B?dUpNUHVrazE4d3BpY1ptYUZ1WXRIcHNVc01PQmVwOHY3YXlrQ2VGNkdOS1dR?=
 =?utf-8?B?b2dJTUR0bEU3dmpVTjQvVXR1Yk1rQXAzcHpKWUNLYk5XUFl5aW42cnVTWVJy?=
 =?utf-8?B?YnZMb1VUUUdad1pwc3NqNUltcXdZcFFPamJSanV4cUFJejZ6bVZXK0FnMWZK?=
 =?utf-8?B?R2ZYa2pkT1lFbUc0ejIwRStxZXJQWXVabDlGTnc1WEUvQyttM1YwM3pZdHZ3?=
 =?utf-8?B?b3dYYStuUjR0d0U5WnhTRHl3K044K3hxUE4zRExhbmRYRHBkY2V5SXBMMCt3?=
 =?utf-8?B?UzJvbzk3ZzhpaWxHNEwvenhoQmJoT2FsVkJSMnh6NFVta1FHSGhqODBkRWlL?=
 =?utf-8?B?TnFhZ2swYis4OUZzRVRCbGE1bWZEeFhESGpLYlJ3d25EcDZjM3NkTlNHYjRj?=
 =?utf-8?B?YkVWREF1U1l4R0tIMTM2c3k5ZlZpYzhDY1RWY3hqTlVPUGdKbEFNSzFPNnNK?=
 =?utf-8?B?dFBHN2Q0VmQzR041QUJoUTFYQ0pnOWs4MnNUZUJ2NUdnYk5Ra3VQeVA3cUJi?=
 =?utf-8?B?M05RdnFyVGVnTVlCRUVGVTkyTlJpbFRFQ0lIZDBVRUVwYlRRbjhqRGZSYXBE?=
 =?utf-8?B?NXpZVEZzY0lIdEI0L1NzUXhXRnhma05TTEFLMGI1bi90bW55Uk0zUzRHR2R2?=
 =?utf-8?B?VjZ0ckRudS9MVXlkZkoxVmNqTHUySDRNSUFJdXRFa0FvVkEyTXU1OWFPUndN?=
 =?utf-8?Q?2Y5HJK/ndaO25QW0Q0KfEIlo9qOvwKDr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTBoK0pSak1GbUE3NnMyU0FTNnRaMW5KNFNKcHRVM2FGZkU3cHVPbnFhZEky?=
 =?utf-8?B?bUdtUWErbUNrWEZZTGNkSktaRkx2NmRNbTFaMmhraU14UlFhRVFIb0xYZ0p6?=
 =?utf-8?B?N3g0WHBFb2JlODExTTM5MElMMWQ1UVlKbXhRTnJHYTkwTTBzQlk1VWo5Y1Fs?=
 =?utf-8?B?V3pXV2dQNkY4Qnpaa05mSkgzWHRVS2NkQkd3bkMycEg2YzVVUlkwd1p1MGh3?=
 =?utf-8?B?VXZiWmcwcnQ2MUJjdU05cE1KaE1uckRld1BkNTJPM0JzT2hFRlh4MUZ6K0gr?=
 =?utf-8?B?WElMUERqNFIzaUdRdGlKdnVNcmJ0SVR1czVEd0dvb09WQmtHM0JJVVNSalFi?=
 =?utf-8?B?M204SWVNRjJkakk5eUFPbCtwNVpBZ1NZYWM2YTRxSnI4Y3lYbk8zSnIvbFh4?=
 =?utf-8?B?SHNrMkI0VGFuT2tuMTQ3L2NsVXhERjZTdzJKdjhNZFJzUzhvdVBLWnFFUU9o?=
 =?utf-8?B?MDA5Zk9Jd09RbmU1bmRrV21FN0RkcDdKWkREdUhPb3g0REVjUUR3Yy9mWVVX?=
 =?utf-8?B?bDE4cGFMdTdoY2JJN0EzSE1oVGNxdGhPWSsweHFtNlp4SFhWSTZGQ2FDVnlq?=
 =?utf-8?B?OGVpK3hDU0VNY09ySjBnYmZpY1BYL1daM3BZQWswcFlCdjhjVzZKRW5FZE9F?=
 =?utf-8?B?NjAwUVRnaDZYVUUrR2w2K1I4dzE0aVF4aGhNTWxJZVQ0S3J0Q3RTOEtWNlpy?=
 =?utf-8?B?Z2VXRFBTUkc5ZERWN1hqdTFBU0FVSmxrblZzRlFibUdSeEhIVDJFTjNRaG8w?=
 =?utf-8?B?RjNsV0k5cnBiaFliZzl4STJiaVFyQ3VVd00vdWNyWlNyZG5zbHFJdXphbmhq?=
 =?utf-8?B?dXFES2EvazQrVFNGUWxleU02VHZuNFdJY1RRb1hLSjlVdVBOaG0xL0J6ejdL?=
 =?utf-8?B?MzVJUGNzZzVFeTlQK2l5S09scE9TUFNlMUoxSkhDSUlCUmxJMXoxcEZyQkR2?=
 =?utf-8?B?Wjl4eFI3MVZsZHJjZnM2RXdVQ2NOb0dwVGJ1alpiMkZMNDk4SWswelV3em5u?=
 =?utf-8?B?Q3RRa3pRY2taL1c2Mms1MDdRVjJ4cmJWeVV6Q1htMHBLTzltVkJYWE1GSUdk?=
 =?utf-8?B?SnpUQytiNE1kd0EyVWxpWFRld3JkTnRxb0RZaXBCcGdKdk9MOFlRTy9EUXQx?=
 =?utf-8?B?TW9kdnNmY2ViN3BZMUtzTjMzSHk2c2U3cUpadk5lZkwrMkJ3cFFYY1ZOWGVl?=
 =?utf-8?B?aGs1UWRhWVlYRlZuVGRiWVMxM2VGUUdFQ3RUcFRmWGV6elNhcG5xam9DRkNR?=
 =?utf-8?B?Q2gyb0VwL2c5MTMyWDNvTzhFQ3lubDVNUGRJVGo0d0htQTk0R1ZsdXIwWGNE?=
 =?utf-8?B?MFZjTzRPNEFBblBLdk5kc0kwOW9COSttYjJzR09rQUNCbWRVWDJsejJybVcw?=
 =?utf-8?B?QnZOY2tqMG9iaHpYeEwxWTBtSTBTa1RvcWxHM20yZTh6QUg3dDBkVy91NVA2?=
 =?utf-8?B?eW1JQXViVUEvUVpRSlZwTm1xQ2JIM3NRRzNQS1Azb3I5WDZwK1BRaXhiWXFM?=
 =?utf-8?B?UmY5NnFoSWRXWEJ6V0xHV3NYeFU1ZzRNeGJOeGdWL1lKMDlGeEFPdEZPeXlV?=
 =?utf-8?B?QzVsNnU0dmhRejNxWWhPWW5VSS9lUWFGZTdxT3JPWmVtNExpbFFzaktwZVpF?=
 =?utf-8?B?cjloZlk1MTJZNUhQSUdETUhzQkt6NEdjRzFvVjlHOUpYQ2tVK2JRMno3YXNC?=
 =?utf-8?B?SnJoU3MyZVRTQzZ2VldQK05GU1Bzd0ZDMGtjSlBpV3hHMEVuaDUzQ1N3Q0VH?=
 =?utf-8?B?VzhyM3ZKMk9TVDRuODJheGQ4SlJoSHgzcTdGRXZ4cFlyYnFmZURDRFdxbWsr?=
 =?utf-8?B?OVpPN2lFOVhTRmxjRmZmWjdablIzUVNpTjc1anQzay9LU2xrRzQ2aWZTdTBw?=
 =?utf-8?B?ME9tS0ZoVThBOTFncWQyQXROMHN6RnNZZ1JrUTc3VWgwYzA2dDRqVDJVc3c0?=
 =?utf-8?B?Mk42MlZzeFAvem45ajFWY3dFdkxPb3IrVDR5WndkOFVHeGV2WVczRFdyZnV5?=
 =?utf-8?B?ajZGUU9ZVXNNZS9wa3JqZVlYNXBHb1NsNlVmeE4wVW5hcGdkSjR3TG01bkZ2?=
 =?utf-8?B?WkRZYnBDQnc0S1BPRDYwMWxibUNLOE9KSkVqMVg5SDg4RTd1NWZreFVINC91?=
 =?utf-8?B?b1ZzajhKNExSTVAxNE1QcU9LOHNQemNoUHdZcTVhVFNmaGdtMTVYNU5YZGJC?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/bP5Y1ETpCsESjifr0ugbGzDM4An+sX4oyC5PB1j3nMTwVrJfRYJYs+5GU+XJ7L8svpkscf4u40L+F/D3RpKqFg8d2sRRXEnCwhFsXyEMHM2/U1SetISXfI0roqyPsaS8qnzjONz0h16+S8lIHGoFaRTexbq1/N3kI/xAj3zkhv27eJJ1cO0CRdHR+903kKyeJQmkl8TCSiTeJL5JAXkIma2f9U+F8pHXeFKFgavDb4/cQnhREW1uMQIAnZqN6GXDGAyyGfkmbyLS7CC1d/eCrOi+MBLbEAmu+aI7IC67E9yjLtvw6z7ErKYGKolEAlzN5rz+0S/cCL32iZmtWO9nM3e2fUchfpc3Je/t6sk9AM53QFB/SrsWFTLW3RO4OGB0olVluSvMxyGkWbNVvp2QSKrMpNUV5FYS0vkAFU9YRpxTJzlFS+C5aBmxRS1JWxr/moIyZfN6fTEGMoiE7vH4K0IF8+nVefjsWjjc0pNRQg8F4ljoy9U4kY1/0UJ2MwAScLg1R/rf9d+GREjML+obfL6flsyxJ7kBO51X+3wn3Zqz4Ugjjn/epVNWrWyy7+ni5hqAsfvKxJa6unHftLq3m5pYGEFgMuZ+7KUXjFQzwE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cf6f79-79c7-448f-22da-08de3156e34b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 03:57:18.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1A8lIDFY5tkudGvFDOLZ+SGE2LE8nZekFMRfQ9oPwqA0eJnvlDxvXYiNF1ERbE3wlHXZ31Q6/K3KnNBu9FBVdlN7GKqVjYiISvXc/HITcyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512020028
X-Proofpoint-GUID: o88jY1X8OK1jLdmRG5DiJQhRjpvVSBFa
X-Authority-Analysis: v=2.4 cv=AaW83nXG c=1 sm=1 tr=0 ts=692e63a3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=ib12E31oIutP36Y_HPkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDAyOCBTYWx0ZWRfX8an14n5Bqw7Y
 mNaU2Q2oNQvX58lPk3MQfg545BMG/dCs/JyK3FwH1den3kEGsyJusnT3vPt0rWxzC8qMJiIVmHX
 wA6zpzHoESgZy0RzU2duP3wFq4gHtqckDRJoHg1dT7/SDoSj/tf34H/h2RDKGApCn1Cc+sUa+s8
 bdyWn9s42aZYVYr3kIo9V2+juIcP+wysSCdLTYHa5hbe3tNDabSjwxyfSkH+9f8zvAs0TADuv6+
 wr7hysk5nxfwxM01kkfAb+/ZQhUQKNUTFYVwYy80IdV0IzItHtsvh70q+Cxan7pVowSe2kI+6DW
 Jj9DiVnB1Cb0fkMso1W+SZHVgW69KyiebordVUZ2ARyX6Jrh9DmUbE1DNMQA4wY0onK5SF5ytRb
 zH1oYo81LmLPePFOLQK+BFX4Yxe9iA==
X-Proofpoint-ORIG-GUID: o88jY1X8OK1jLdmRG5DiJQhRjpvVSBFa



On 12/1/2025 4:51 PM, Greg Kroah-Hartman wrote:
> Ian Rogers<irogers@google.com>
>      tools bitmap: Add missing asm-generic/bitsperlong.h include

f38ce0209ab455 "tools bitmap: Add missing asm-generic/bitsperlong.h include"

We are getting a build failure due to this commit.

----
   CC       util/bitmap.o
   CC       util/hweight.o
BUILDSTDERR: In file included from 
/builddir/build/BUILD/kernel-5.4.302/linux-5.4.302-master.20251201.el8.v1/tools/include/linux/bitmap.h:6,
BUILDSTDERR:                  from ../lib/bitmap.c:6:
BUILDSTDERR: 
/builddir/build/BUILD/kernel-5.4.302/linux-5.4.302-master.20251201.el8.v1/tools/include/asm-generic/bitsperlong.h:14:2: 
error: #error Inconsistent word size. Check asm/bitsperlong.h
BUILDSTDERR:    14 | #error Inconsistent word size. Check asm/bitsperlong.h
BUILDSTDERR:       |  ^~~~~
   CC       util/smt.o
   CC       util/strbuf.o
   CC       util/string.o
   CC       util/strlist.o
   CC       util/strfilter.o
   CC       util/top.o
   CC       util/usage.o
   CC       util/dso.o
BUILDSTDERR: make[4]: *** [util/Build:227: util/bitmap.o] Error 1
BUILDSTDERR: make[4]: *** Waiting for unfinished jobs....
   LD       tests/perf-in.o
   LD       arch/x86/util/perf-in.o
   LD       arch/x86/perf-in.o
   LD       arch/perf-in.o
   LD       bench/perf-in.o
   LD       ui/perf-in.o
BUILDSTDERR: make[3]: *** 
[/builddir/build/BUILD/kernel-5.4.302/linux-5.4.302-master.20251201.el8.v1/tools/build/Makefile.build:143: 
util] Error 2
BUILDSTDERR: make[3]: *** Waiting for unfinished jobs....
BUILDSTDERR: make[2]: *** [Makefile.perf:593: perf-in.o] Error 2
BUILDSTDERR: make[1]: *** [Makefile.perf:217: sub-make] Error 2
BUILDSTDERR: make: *** [Makefile:70: all] Error 2
BUILDSTDERR: error: Bad exit status from /var/tmp/rpm-tmp.blrvNZ (%build)


Thanks,
Alok
