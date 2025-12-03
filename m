Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C15C2877CB
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764748356; cv=fail; b=EplXgzlaOxdJ4ZPd+FWJFfcaSMXcxZiv4S3nE3z29FpYrttWCnX2WYbEGNFCqpF8a88Jvu5N1VWnCtSo4dleD1LwX20bc8SIVsevjCN/FoRspFplRkZHRGsZ2xOCfIMzePxJc0RVSu2En4tlrVSk1ogSzPMpPSMUv30Ld6S9q84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764748356; c=relaxed/simple;
	bh=AzeibDZyd5Bw7LW1EcvgXe8J/BvgvgIUqEK+bMXDPPM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hXX5GoHgKo+kQvdJ8m7/2q6zeJdNYcCXBXjmoQ2usKDPev83t4cLksm6R0GPGfH3Lz26yfeF98Iw5+ai+d4INg0+sq1qGoquAc2IkLuANjZ74382JTcJ6JgXfwoHK6OULpvVCBs/tCM4LiAbOguieiY8v3hUazumSeL0J8jMK6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HbkpONF+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hodrnaZv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HbkpONF+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hodrnaZv"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B32vTPd1708461;
	Wed, 3 Dec 2025 07:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NUQuQOZRjw+JucupAv+o7/kKQwCA8T7gD6gPbJCp4VQ=; b=
	HbkpONF+4+VAJ9dmCNfXJ6BIpaB4+njV397ynkMo1Sl5u+D7Fy196iY4jJyox9AC
	D2PwWXdlETSdqKdomI0N/6nia4Uf21sHlCFWS6hHWS7I8Zec/NoHa52LE+/wmTj+
	juWT0Ru3fWYC7ZllxlqgiznxRMtvlgVtT87xhyenLL02cXiEtmYE6jpQ9DxbYrnb
	zt/kUAFd79K4VuOZsal9/3/LBDoUdsgGqJ9QjHP48xO03cipq4LCcyW6Iyps2BZ0
	9A76AALtUJlC9fazrnfYifX1ea/RjgvEJWAJW94Udg/IAUvHuO11ixwrQHT3MucZ
	bNmpH0Yg4DCIkLFJjKmj3g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7cp4ret-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 07:52:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B36oB4M015111;
	Wed, 3 Dec 2025 07:52:12 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010024.outbound.protection.outlook.com [52.101.193.24])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9achnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 07:52:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChEc33MYKoCX80E5weCurpDZTvCMhcRxKOqrrbeDDSC5OMBjUaHRpVtiafA/ltf6GEzd5GceBzkCypoxeJIDPZkxbJbfOWugaXC/hqVHHCnoIhMWR4XTiKe1BDSO88pyGEY4y96gtzs3xhMmaFVedPAqgDmlEh1tPlZ9w5ifTiAbwnih6zuK/+Ib2KH6SV2qE+pI3IIjWhlst639DU7nyqn5px0ztIu2MP4EfmwdgmO7V2qV7phVjYK5FPhou481n0bU84zAQg14h+o/mH9rgSSetKyVbrOfjf+j6j0YpUC+DgWCJtpINXHBj6oJn6+qArcZ3Ut9NggE/CnjHBMyPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUQuQOZRjw+JucupAv+o7/kKQwCA8T7gD6gPbJCp4VQ=;
 b=r7tTtRICAZ8mP1A56/It57zq7o+um+NhsgujMbVzTHGhHshO1+JStMaKgbJL2JHQl1HF7ZeZbuJviGA5Yi0ruq0+dfJoxVDrcXcIMlfY27UWd8geKwgKLgWVHq0iOJ0N7RzOSNCu7u8fXRuylJG3czrz10IXj7UJZWfr/8bzLb6L2j/7nG2bH6UvzPpvEtyHW6CWICjLXMZ+QngL/OJieCyIRSnQxxcVYkEVN0iBIwMLNS6QLy2vQbCyBrbWL9bOyl1N+0ab7zHjA010U18OYFrhyN1tO2CUXh9bYnFbSAICQGzVRji+2TtQxNZUn8tz8KbJoy6wHrgN+PeloXdzig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUQuQOZRjw+JucupAv+o7/kKQwCA8T7gD6gPbJCp4VQ=;
 b=hodrnaZvQvuQEv3BgmC8GzmjKEXr6nq9joeyIjKHpM9Ktz6OGzexaqOflA+qB/jhY9nx8NKSTcoiLKI1m5jx51HD6Vkvz9SfH1kWUSaoQzFohXQ2tRiMWYnEDIHmZBXtH2YNkPQqzIxMJa8eE5gJzpHvIadVZVCWMkAXORUsa5o=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by DS0PR10MB6749.namprd10.prod.outlook.com (2603:10b6:8:11c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 07:52:06 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 07:52:06 +0000
Message-ID: <6e0c3308-5766-4fb4-8d4c-451189c66dd4@oracle.com>
Date: Wed, 3 Dec 2025 13:21:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/184] 5.4.302-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251202095448.089783651@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20251202095448.089783651@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0205.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::12) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|DS0PR10MB6749:EE_
X-MS-Office365-Filtering-Correlation-Id: f604ebed-acb9-4be0-2c02-08de3240daf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlB6cUpQMTIxSktGWlFWZ0R6MExOdldMeWZMSE9wdmlFaUpTa2UzS0d6ejlN?=
 =?utf-8?B?eGpnK0kvSHNxK3p6LzJtZ1BJLzFmN0hmdW5CYkNUY3g1Mzd4dWhwYXlRWStj?=
 =?utf-8?B?WXZKUGQ0bVJsYkJOaU84d2xzWExrT2N2ajlKSFAzQ3dmZy9HUEVQL1RtUVhF?=
 =?utf-8?B?VVc3M3k1ZEhWVlNraEE3WGtBc2xkbDJzSE04b1Y1NHk1YUMwYlRPSENXYVdJ?=
 =?utf-8?B?VUNsb3BtN2xaZ0I3a1hrMGtCQS9PWFgxZDBXbkpRUUlzWGRhZis0WWp1RmUr?=
 =?utf-8?B?bGdHSkJmQnVodG4rNHRZWklZVWVrbGZrVHJLSzlqcFdpL0lTbGpXOXJrNzNS?=
 =?utf-8?B?MXVyanVDVHJRZEtMMVhhOWJMb0wzSkkyQStXWjdvdlBENjhQckdxR2w5UUh3?=
 =?utf-8?B?MTdaTWJ5ajBBT3N4M1k5Wk40bEtVVk5SNGd3QllSWTk1WGtUdlNJaUFuRnBQ?=
 =?utf-8?B?MGk5TmxSbklvZ3BFZnJhaTJPc2lIakZXUEFlRWwweVlSTE9DWU84YTkrbUN1?=
 =?utf-8?B?bkZNV1Zzcm9UY044bXNzRzRzclR0bTZEQ1FkUU80REhjTHNTZXZLUUZRaCt3?=
 =?utf-8?B?cjhTZE5LZGtWZEhzU1RQR0IzYmtxeStsMkg2cFBrbUpyZHBSMWdlNldOTGpC?=
 =?utf-8?B?aEhBS0RqZ05JVUhQK2h1TUJlUC8vVEFLSW9lUDhBeC9nOE9xSUI5S0NlOHBQ?=
 =?utf-8?B?MGI3dHBvR3NoRkpmZWQ3MmZGdDQra2hWdkwzNUwxSzQ1V2ZybGcyNkF1Uksz?=
 =?utf-8?B?L2pjVXB5VlA4TGlhMTVvUzl5UDNmSkE2aXVxbzlLL29nckJTWFA4aDF0TEh0?=
 =?utf-8?B?Z1pscTdMY0FVZUFRaVlmSmYvbnFaUmNMeDM5bUVqSWxvOXJzNVVxT2ZaUnRJ?=
 =?utf-8?B?NFpkSGwyeWJscHBJQmEyZ080SUdQYlZ6VmVuZWgvQVEzWGJTZUkzd1RIM3gw?=
 =?utf-8?B?VU41ZThVN0xZT3JtTGNuMmVmblBvTkpPMldpQlJQNmRSTGVxVklIQjVtYjJm?=
 =?utf-8?B?T2RGZUk3UGxOWmZhdy9tRzJIYkJnNXBNYXJIcEYvRHF4RjJMUTFuOFVoM1U1?=
 =?utf-8?B?aVdqNUV4V0FPbVhrcFhhclFxUHh6dUV4K1B1eUtuMDkvaGYzV2lwc0VDK28z?=
 =?utf-8?B?aHB5ZXhWYm9PUVBlK2kwRnJObmlyMzFQMU5oNWdJYTRmZytjenJ2a0RXZTRF?=
 =?utf-8?B?TzBWZi9vcGRhZ2h0WlErc3RpUVFHNVdYcFRHOURheHltbzdpTGhRTFRjcXRG?=
 =?utf-8?B?WlZ5NnhjMmdBVGVRQ0ppSi9xNUlFaU5nVzJ1VTJCWERJYzkrQTRTTCtudTRZ?=
 =?utf-8?B?TmowUko4N0xTdk56RUlES1RPMGc0ODhVeFZ3ekRwMVB0UkZ2amVpWjYxcGdu?=
 =?utf-8?B?SFU4eGNTVlczaVNvMFlGNGNPTzdXTkpyNzF0SS9VeHhaN1p3YkJVemZqMzc2?=
 =?utf-8?B?WXhZZ0ppU3FxWWQwOCsxYmwzc2RhcDl1QlYxaCtYekVIU2pMMjBQZjBoYjBw?=
 =?utf-8?B?RjhUUTFjZmpxaFFIamFKbHN3T3V0M0Q5NDRiZXhzU3ZCZ2I0bUMyakUwb3RN?=
 =?utf-8?B?akVybUlWdWdIZXJuT2Zwc1FFdlZtVFljbGNtbmJSTTVIb1M1NzREekEvOW9u?=
 =?utf-8?B?UDdLOW1nZWdZZkxDSWlCckRCaXBMQ2ZvdHBLZG5DbEVnTUQyRVpIaDNoZnNS?=
 =?utf-8?B?eXI2N1c5TmJ0bzNrVC9KTnplcVBPTUlpNWsrVHpxUTdsSHliaEp4aCtaWklj?=
 =?utf-8?B?RTVjd1JteUhhUkNMNWNLTzhHbTlSZ01Jb0RMZWdLUFFTRk1tZk84cmlRS3c1?=
 =?utf-8?B?N3luRjYxM2tqWmRqRzB6Q29XYXJzdnE1ZXlWam5MdUY2Y0VvRFNpOFVTR0JY?=
 =?utf-8?B?UFhFQi93dDFCclNRWkw2OTRveUVvQ28rMXBsWjBQWVBVN2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVYrUTdmSEVLNXNCRXdRY1h6V0NNcXp1YkUxY1B4NjlObFVVOFJqeWFxVzFK?=
 =?utf-8?B?dktZQ25yWkkraTRKcnZBajFiYlRmK1B5TXJ2NUdVNnFnek1UcGZFMjJNK3kw?=
 =?utf-8?B?RHRycEJqdTFtbFVrU0plSFZnS0lkSnRZRFJDbHJVbFBUVWxVRGRnWDE3amkv?=
 =?utf-8?B?Mm51ZGttUisvU3VkRzQ4VkxjM1dEUnM1Qm9LeFhhMSsvaEwvUXVaaEJ1RDhh?=
 =?utf-8?B?RWQ2bS9TeHNtUlIyLzdudlU4c2pMaXVhSmpIYkI1bStSa09TS3hxMHhFS2Ju?=
 =?utf-8?B?SFRpNDhIWWxEWWRGUFVLdDJST2JPaHpzR2ZLMUt5WGQ0QVR0ZGVvQVBVRUZa?=
 =?utf-8?B?bHRNRVRMOHdlQXpSQnBmM0pWODFJTlArYTRRNmJBRWNCWmwwbUpqNmU5a1pS?=
 =?utf-8?B?QnhtVDk4cTN6cnU4TmswRTJVUmNGZW1wSDh0bE43elBHakhsczhNNHoxMEEv?=
 =?utf-8?B?aWxyZVMwYVBKZE5RekdJc1FhN1hQQzRNUSs0cGhXSmQvaW82bEt1dExORXdM?=
 =?utf-8?B?Z3RzalVvZFFDU1hXNmgvTldmandBdHpUZVNrSU5oZUpLOGZoMTYvSUlUbVlH?=
 =?utf-8?B?NlVBbTlYVEorL1F1MUM1ZCtNZngyR1NnUFNKSkpSczdlWGZJQS91RElEUGZL?=
 =?utf-8?B?aDhOS01POWd2Z1JkT1NjcVpLL3c2MTJuK20wKzgyNXFnWWFZc0NBaXlKZGFm?=
 =?utf-8?B?bis3aDAxbDJ4ancyODBwb0RXMi9zNkpNejF4a3R4QWNxZWR5UkY4cndrclJ4?=
 =?utf-8?B?cGtrd3pneXI3SzcvaFAvNUhwNkFjYVNrTVdsNUc0dEcybVNXekNaZm4vOWV0?=
 =?utf-8?B?dWZjZXVveGNOMmF4QUpWWlI0TTF2UHRONG43Q005dTdQcVJJRWJOOWNXYkRu?=
 =?utf-8?B?Vkh2SU9YSmw2OEpqbmVPdWlMZ1V5ZWU5NDhEdUNIMjZCYnVBTFRFTE96TjRu?=
 =?utf-8?B?SVVuZ2Q0WCs1WnZUdXhoSGptMWtmVWlLait5V2IwV2gvSytQSjd3eUVQWE9V?=
 =?utf-8?B?TVp6NmkybnBLaE1VY29lTTkzVm9MVkJHaFdCbHcrNUt3aTdlNHkzc09Gd3p0?=
 =?utf-8?B?U3JzRkZMbFlhaFdvQnNXV2pCalRERCtJRDFDOW14ZmtoZCswTUhZQkR2Rm5a?=
 =?utf-8?B?OUlGc3dnbVVYa0wzVGg0ZFVRQXI2em9XdndGNllNSTFyYzZIY3BIWVJmWjRO?=
 =?utf-8?B?Q0dQeUtjQ3dKTVptZGlkSDZoK1F2cExSUkRTY1Q0QXdScU5iTks3VHY3OTJx?=
 =?utf-8?B?QWJVYjRKVS9BMVEyNWs1VHNBZzdFRGpMNW42ckFBc1R5NXZVTnZmSEZqZXVp?=
 =?utf-8?B?OTVKMVlKZ2prbEpUQkxlM0VWRVdRTUxaVElvTDU1ZVdxYTFPWkRXeEVvQjRM?=
 =?utf-8?B?bkM1S3JGblJxdnFoYTJ0OVN0RHRDYmNuSjdNUDlISWpCYnVXMWJDSXNEZGtk?=
 =?utf-8?B?SzhXbmgzbWJ4M3ZvOWVuTStaNzI0ZDRtRUJWakk0UXBVY01oVUZxc1NQM2Ix?=
 =?utf-8?B?Qm5VNXowczU3Szl0b3pJZE1pcUI2T1RwVWg0ZWlJQnpYODIwQkt6d0lLZXJG?=
 =?utf-8?B?eHVDRGxaTm9kdi9qUVlVSUg3YXozRk16ZHc3U2Rrdllob0hzMDdPSGlvOXZF?=
 =?utf-8?B?Z0FwZVR1V3NiS01vWE1FRDZsNUc2QjV3VmFBbjVsY3puQjIrTERDZWM2dEl2?=
 =?utf-8?B?YlVKd2tyNStmeERKS2xicUdqUTJmV1JSUXk1ejJIcGNRdmdJd2dsV240RWlJ?=
 =?utf-8?B?WEEzZW9PenBKWWtpZUxadXVicFJJMnNqSm5PVFR3L0VpL1BqdktzbURXYzRF?=
 =?utf-8?B?M1hwTGs4RWJGSCsvTEJsRE85WkR3L2lndEV1VmxrK3BLM0xCU3BCS29mUld1?=
 =?utf-8?B?NVBNMUNuVXJ6bVY2U2lNdHgzOEtiam9xMVYxa2R2UXBEV0VNYkJkRjdDaWhI?=
 =?utf-8?B?RFE0Z0Vid1R0OWVsMU5UZ1hVOEFvc1oxc1IzQ1B3YTBxa1RUV2pDSXBNbHVN?=
 =?utf-8?B?NWk5TU9LcmtQdGtCU1JsZ011ZlN6blBHbFoySTI2aTl0YzVJekNTN2o3UXpT?=
 =?utf-8?B?Uzk1NEsxWGliRjZqbEM3ekdYbnJSYk5HMUFNZHRVeWdwYU5tSkJiem5EV0Ux?=
 =?utf-8?B?VzB2Z1NGeVlycjBJSk01NjBLbU5MUEFLS2VMMEF1WUtiSkNQVStVeUVCL0U5?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fvXr7USRmkUBU4HSoEZJvpLvO9iGs03z+sIyZ3aPe+YoxzD1L77BklUfJ4adVqsCn2syu2OKbdyYtju9FekDMLSqBIKsG763Dso3TYIB7ioekhXPVysiIUpfVYA+EY90orUN+ugD37mQkAKEBNUL33KdMWbG3xz0a8m54N38eKFtwhE1AUzZu1hWiJLVNpucStzusJqF9CvDsqzMpLQOItONHISFvFJFgvcM3BsDRDiJbhh3d9On7KbK3BBJGbn6s+3YP6lYHkqG+F1KyL5+LlIa0anbWkupP4M9xIoI6r3IdVRModLrZGwzBvyYCi5L1szJlS1qW1KFQPc8r523ClXyzq+HarOfbLWIAYm+QTF6i5Fxsvweh5uFJOnI57V6HUIbet7MuXwvpwSmtLEmXKyU6uhVu1IWmIVjz5UV1tqZAtMD4Hqf+gZsHYkOAptgRLX5QXA/x8UUFP30oIvx71nnBWi7gZYSy17l9kkyCvksx2nZkDovwIger5rAcaFsCggKyY2GKJmxDTziocqe/Ddi9F/Jft09i9f5yuEkBiNu0+yPtUMTQe3D9ReGRUJkNPBzy2K5rKzHtJpFe8Eo4FkGhOv+sI7akTkeu2Bvp6s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f604ebed-acb9-4be0-2c02-08de3240daf5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 07:52:06.8453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WGBgHw8h4FjGw6uLyPUl/GXESn1g9R8A02cagBgSjDPl2aMw82XRGvQFunWm8172HCcSpi6sN7JSvbmY8QeGbAkzPiACYiM6s4y9Nt2Brc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512030060
X-Authority-Analysis: v=2.4 cv=ZfgQ98VA c=1 sm=1 tr=0 ts=692fec2c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FxuSW8xbFHkWkhQ0UXoA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XUP7H1ofj-_XeGBo_5sCcrrlB3si-1By
X-Proofpoint-GUID: XUP7H1ofj-_XeGBo_5sCcrrlB3si-1By
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDA2MSBTYWx0ZWRfX174cuTJfJ2ar
 slqWECgxDHvsyV5M6Ll93Cb/fcKwJjCuwAQFtJE2mNhozBsWBL1K9wtv2TStHA4cWiDqyeCP87I
 AQw81q9dvFILq75qVs68EtIlgyfyPmLsepKoCUNzptbY6l5Gea5MqjSUMbkJktbpps19K2JguZR
 nO4EkU460i5PPzs7AMkkcwY7ywGu1219mjMneeYgXWnEt8b+oDTWkg3QWh8iQ2lUnkUjJLcmnq7
 L4zTCautxTrydbiyKh0Nn1IWagxbf9+yolUQTi9+yv0JV5F+Wdqv+AQNQ4RSVJYNbr6fJTdu6pV
 JN0f35VucCElvHFqccngbTXgfCftShKqEEwkxZ3Gy7gCWMa7+mIMHGNrEUkJr7uHzHQqfQiKTNG
 Edi0D2i7dHMEBBO0wK92zPejGq78XA==

Hi Greg,

On 12/2/2025 3:41 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Dec 2025 09:54:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.302-rc2.gz__;!!ACWV5N9M2RV99hQ!OduqY- 
> dHjZBxzhZobwAdA_8NvL0uvyx1_baqoHzYjjgBEbgnEKSD6Wpd2hiVJxwqB5QOmNWfH7w2vHLyl7ZPqZmfkQ$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok

