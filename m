Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4602B9BB
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741784220; cv=fail; b=Cziuw9CWSJF2/9lSBUo/81zNLOaWOreDgGMD5oVtyMuxyFaKspSf/wNJ8Ia7kddZDGEO6lCGGZxGTHNQzEAQOneYjtQwacEA+FlJgI+iMaCLqgyLv8dy2LRfqax1/GHfnSKmAsjH0Kys21i0Q1VmJegOFD5f2fZKyrKl72wPF14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741784220; c=relaxed/simple;
	bh=qJgNCenmoGjGwC5LosJGT+Ipj7ITc4sFkDa7CXSBMq0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CT7paPOS0/Nk5vdGWUVBSWzcS0E4F7qm+fwYsn6uK4xKhLe8nCF7uOz5oNJjmnpWZwa7KArsOgLYqaN7+ww0ZempBfCNrpAyaX44E7XX51AYVDlnfjOYO6uRygIWOEZ0/eU1M3q+h00iK1smDkidAigJetooTb+iSldCt/6m4iQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xijr72++; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ADojIoL9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xijr72++";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ADojIoL9"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52CCCOvu016201;
	Wed, 12 Mar 2025 12:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=W/0K+l1y8XHchULoo5jEjNTPhlWuol89Ce0s6s3tZgg=; b=
	Xijr72++n6WBpEIXGSSROBF0KIrpOOQ8tSxyN7afLZAfcIpE2uxyeIPAj4KyWqEn
	dRguBw96T3xIBRI13iWQwb+TzsBcAea8y5B30MafFbJBtoBqHyVmnreqXuuY+oB7
	uNaNEUsxNpMvnQBFopMjJasOXD9qN4vTLXpc3igFTj2lPD2Ilu0sMDEnpHKXU31Z
	FkonE0X1LPo4FeqgnM5llJyu3cPSTvbJhZSkdx1+zAd5xcrb21mjpWXZayDdHSU9
	LirnM2QuzxdVoTwiYUujzCeXOc5/vyBoxvp4oN75/wOTdT7L1VYwclYSUComWnVP
	hnnPY62bJfrzG1dmW46ucQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dsp50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 12:56:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52CB2u84002121;
	Wed, 12 Mar 2025 12:56:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn78dfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 12:56:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHYDul/I+CSXUyczBl7ET9t/kbTlUGuwu/0GQbInX6aL91RciiFesC4ssSLx0nTOM++nrNLhu3VOvHlyVDK/v66CfmzR6luF7fP0vvxMVLIgirCINZthAa8qcuOu3SiIdivQzRDIcRxv7d/bfz+983mOgVKr3jQvAL34bLUQ0PM0k2bmb0PqheyEmCc3txUsako3O9rZLEqtQs/GHjaavF0TW0oF25YSLIHJ7o+U99ZagC8gIuI4FIDN8Wh8Zb65atmZ1DpDVvRQSndyJzqHR9BI1bKMNq2kHSv9eaw08dQrfdqPWPaUUyg7+MMEZJ2rJS1ya/UB1nqNZ94qsOU9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/0K+l1y8XHchULoo5jEjNTPhlWuol89Ce0s6s3tZgg=;
 b=Xj+P2khtyGb4mxi5Upd8/TPVpLXv017wTx3AWY15am0BjiffYxMLyMTqbQXuuvrTucoejNakLE+AWwlfT8tQJ+HqDjObF+CN2TFnoSLS1kGE1BN14de9n3TTX15sAQTc9eTXNdZPfOYOw/aqNmUI9FdjXKNGZPCp2vb6EWYJa1cf8RnCt3wvarrPX3n/FlZdaiCfHXka4BLvPSekWGtF3qrAZqmjy9ddYNgz86Cu4akkdooXS+2d69FtaQsAeEMbcsI2TDPcszELDjJNR3odb3bFhc4Z/S/X2MLSTxb+LE6LecfvTorl8LkxmCI0uXORJkZlPqwxpHgFcDLQYdaEgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/0K+l1y8XHchULoo5jEjNTPhlWuol89Ce0s6s3tZgg=;
 b=ADojIoL9vjB+mD11HiPCBuZIYXBIsaugHm1n6PdXJjaLMYUQ6urXQHoI3cRZBLdjvEsz/wisBfsu3uUpC/vFJoicakI9G9tjFGacFjHIShpv3s0GHAj9nqLsDcmLmINt3xf9fwawuK7pJvs0a9Zp8mBhlXdiHvrOxbwWXJxx6a8=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SN7PR10MB6361.namprd10.prod.outlook.com (2603:10b6:806:26f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 12:56:32 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 12:56:32 +0000
Message-ID: <889ee6ef-55ba-475f-b7f2-a63898bda566@oracle.com>
Date: Wed, 12 Mar 2025 18:26:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH 5.4 000/328] 5.4.291-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250311145714.865727435@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SN7PR10MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: 66b84953-6bf7-4348-9bbf-08dd6165501e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFAxak4yWTZSaUp3WEFLWG9XdWpqUFVtRHh3RDNWU3Y0NGhwd29jQzV6MGFy?=
 =?utf-8?B?bU1oaWJzOENKekpsTXdQT1VwSW9YRE9xUnk0TC9yQ0JYUGd5TGRmUVhZeWpR?=
 =?utf-8?B?dENjVVV3RzVVeSsyTm5IM2Z4RTMzdnlyUGdLd1JkaFpseUVaQnk1dytxYWZJ?=
 =?utf-8?B?dklGcmJtNkRnektQZEhyU2l0bmVzYWMyN1lOUFR4Nm83NnhlVm9veFcxWGxU?=
 =?utf-8?B?ZGRVZ251WlhQcjZvZXBGNmUwQ0NwS3hFbkFRaE4rSjNsVVRvY3VnNkNGR0Rx?=
 =?utf-8?B?ZmVMZnpyb3VaMVdOYmNCczl3eUQvZkdqMlJvUjBpcDVUNHJhVDkzVzd6T3FW?=
 =?utf-8?B?NHBnRlZsNXRRbDN0clByeWhOZEl6dDkvem5mSTVxZ3k2WUlwSDQ4SDhzTE0y?=
 =?utf-8?B?ZXJ4Mm5Sd3BDU0UwSVlsK1FCNitEclY2dEJDd05nYkYwUFArRzRMdUltaFE2?=
 =?utf-8?B?WW90cG12V3hQeHlBQVUyVmR2OGpkalFSSEpwWDIvd1BoTjdXM0Vzb2RGQ01u?=
 =?utf-8?B?OWJVSkpNVFBLM3AvTlBiV2dpSXdjSlJtcU1kMHg0MVFJVDNNK0dhU3dycG90?=
 =?utf-8?B?SmNpeXpLTVNxNk9XdElBQ0VYclpLYUJycm5WMUFqamlQbHdJa1pPSWxxMWJT?=
 =?utf-8?B?b08wN3VaRVhNTTh6Y1BZRnU0bktkMUtjdGVVbGVidHVSRUlIbnpaWXMzYTRO?=
 =?utf-8?B?M1JlQ2sySmFNWnVFdy9wOFV1T3U4TkRrYlRHTno4NlVKaWMyOEp3cXhVZGFV?=
 =?utf-8?B?cmwyclMrLzlnU0ZMSk5yVURLN2gxQno5aWxkR0ZCQ2k2OVhOUlp3UTZRNWxo?=
 =?utf-8?B?eVVtMm12NlhSek9CcVg0WEY4SkxUYzRNTWhjclBlODRSb1VnM3Y2QlBtM3Av?=
 =?utf-8?B?KytORFVqVHowSEJwU0h6d0kwaC96bStJRVFHRWp5dStCUER6d1RUbFVUdDFw?=
 =?utf-8?B?UGlZL2loeS8zQWxuTDgyem9kVFlPV3dWTUNlTlpUaFVFOWpiaCtRQnh5cUdN?=
 =?utf-8?B?Vzg3VHh2Z2hjK3pIWmlZaytnclZNV2FWRTlwUktUQVl5RnUzbU1HTmRTUWp3?=
 =?utf-8?B?WG9jdjU3SWNwT2I1S2RNL3loRmtNWENLVWZkT3Fqa1RyOFhkSTRIMUFNaDNv?=
 =?utf-8?B?UWdvYjFJTXZLd0FlREtuWU5CTGs0dXR0b0d6ZlRTQVRoZHJ3aWN6UVYwSGhs?=
 =?utf-8?B?MTQ5MHVJQjdCNll2N1N4QTdMeUI1OXI4ek1CRUpVVi9valo2SUQrL0QzQ0Z0?=
 =?utf-8?B?WC9XUi9xOEJaNGoyS24wNTBZcnJwOXF6My8wU04zOEtDVUphRHRPd2JSTDh0?=
 =?utf-8?B?QlV1b1gyUUdCUXpLNFpReWsrNWl3SHhxZVR2SllXM0g1UVNhSXdGWENxQ1RC?=
 =?utf-8?B?dkJGRThPYXdKMVFIOVRETjlCRGNNS3JzbkxWS0dSeG1ZYlVqTVFucTFuQTlo?=
 =?utf-8?B?SEwvQlJMTFNPTlZzeEhISTMvM3h5Y2FKVlFOZDBtUTVzUHF6cFB6Zmw3RWpz?=
 =?utf-8?B?Vi9KdDNZYnhhVnphaEFMNmlpaExlaXRMaHh2L2FReHc5SFQ5NDM5anE0UkJY?=
 =?utf-8?B?Q3R6MWcyRTVINmtJMncwdUVwZUQwMWgwTzdsbU9WUkdTVEtYTGdERklWSkl5?=
 =?utf-8?B?U3A2TUpiZUF6ajBvV05uQ1NWZ2U3d0ZRbCs5T1pSdjd0VDF6b2ZLQ0U2djlI?=
 =?utf-8?B?YUg1VUpVUlV2RUZsVENMa1hpbTVMc0YzVnVRZHNIcVB6VHlwSFdheVJhayt6?=
 =?utf-8?B?UTR1VE9rK1kzaGRTK1dXbERsa2FqWXFzNTJCNHlUQkpVVTJVQXFtQWNXOFFo?=
 =?utf-8?B?aExLU3loR1Z5UGJPdkErYkpCQVQ0L1dPcmVFQnNuTFhtZ3ZEaW8xUUR1bWdB?=
 =?utf-8?Q?a407/Pgdw7Odt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2s1bzRRZEI3MjBJckNjeXVDb3pvR2RoOFIzdHZ4Q2JEVnB0QUNVcUtIV2NH?=
 =?utf-8?B?c29IL0pXc0ZMb2h2YXZkUHB2QXg5ZGYyTVNlV3VwZVNqcGtjSDZjSFBWZ1Jp?=
 =?utf-8?B?ZDhZRjYzQUNJS2RtcWlBRDdXTzF3RFFPRmNlTDRuMmE5bjJBMG5NTmxXTWtM?=
 =?utf-8?B?MVR2WGZvVHprRkhYUUZUSjZVWVprN2tGN0hsaGxkUm5BWHpFL2dHcEtuSTZr?=
 =?utf-8?B?RFZHSTkyS1dXK3JkcWxyNzJiK05KRXdmNTN6SDRXWDN1Q3lvUVp6ZUloK1RJ?=
 =?utf-8?B?a2ZIT0UvMUJ4NlkvNVA0dFBaN1R6MVl1ZXZjSjEwajBFUXBOU1ExSFRiZnp6?=
 =?utf-8?B?TERPMUhCU0ZOR1R4TVJnWFhnQ0plMWN3VHdjeXNPMmZNVHNJdGNubUJDVUEw?=
 =?utf-8?B?dUFDVzlGeStuRXVaU0NXQ096dTY4VDZ6dG1qamR1Um5lakVFTGNsSVN1Nzdj?=
 =?utf-8?B?LzI2K2p3YnMrOGxzT0tPQitIb09ISTRwV3pSeUxFZzhXUll0cGh1UjkvUWFX?=
 =?utf-8?B?NHNrbkgzL1dhQkNKTjlMOGFSY0ZYbzBaSWRobEtIL1dLY3F4MzVRazFVT1VV?=
 =?utf-8?B?VkxDZTczc05xY1ZqNHE1YmhNbXFFZlZjbm8yQkJaYytBaVAxbHEwUW9pcUJh?=
 =?utf-8?B?Rm5CekQ5bm4wTzlyMmVxNy81cHpndUIrZE90S2IwNWhwcmplSm5pSVRJSHN5?=
 =?utf-8?B?RGRncUdqd0dNTVBoYmxacTVyZkVnOVc2YTUxd01ML3l1c2JHN1dRV2tKQ2d5?=
 =?utf-8?B?R0dVQkVLcWt1Q3hlWVdrMTNSMGQwSmJhNjFHRS96aEFBd3ltVlpaTElBd0dt?=
 =?utf-8?B?VTlZUTQ0SUtnL01aWW9yclFxbnF2SEV1a1FnQmxhQkJsYmRHSExrMTkzUTVo?=
 =?utf-8?B?NnVyRlBKOG5vTnVCdWcrendISGdlRmVzMXRici92WmdNV2pmWFdxVnRVWW52?=
 =?utf-8?B?c0ZIdC90WmhCY2lraFJGMmROOGY4TjVDL01wUjFscTgwNlBydUVWKy9JNm9V?=
 =?utf-8?B?ZlpWL0wrenkxcFpYWEtCOFZaRnRLNmZSMmxidWpkS2ptU2xBb2Fjdkw2SVhX?=
 =?utf-8?B?OEM3UTBHQmpXVkdEbmY2WVlEVmFrbVdvc21FRTV1TzhQVFYrdjlHbzlCNTJz?=
 =?utf-8?B?cXIxa2kzZytENmxZYmVvdVo4RWpNRHZzSmNKMGp6Vzh0MTAvK3RhMzZUWWVX?=
 =?utf-8?B?NTduZ1YvZ2Zac0YvbjNlSHpZOTdTa291Vk1ZdXNSMlQ5cVluTGhOV0NhTjRl?=
 =?utf-8?B?c0tvU1JpK1FHdEdTOVZxMWN2YUp5d3FpcWY0R2lyVzZmcVVXSzBwQ1NCNHJE?=
 =?utf-8?B?aEN0Z3I1ODN2VWhnRHdkK1RBOGM1c0VpbS9rTHc4bUVhWTBicUxKYy8rb3k3?=
 =?utf-8?B?ekFSTnJHbTVZUi9UTDVIZTNpb3oxQzF4MFZRdnBPUXphdDAxQnVwaVhFNzZu?=
 =?utf-8?B?WEgxR3BWYUc2TUhSQzRCWEZWQVVpVHRTbkg5S0pINFZrcitoUWZKd0ZOOXVu?=
 =?utf-8?B?YnBMeEcvaWFQU0tlWjEzd1J3c0JOdlRWU3IzQWdBcHBsOEpMdXpoTFZ1U0xu?=
 =?utf-8?B?UXBNdjlDdUFDQlltTkc5d3VVMktFZ0xNa2QxK3ZqbEo5ZGJ4bzFJcmVVSE81?=
 =?utf-8?B?bGxra1VySWxhakE5QXJKTUQ3K3U0eFplR0xGbDhPcDlSclM2c2tEYk1CWi8r?=
 =?utf-8?B?eDVrNU9zbVowZlVYZ3Zuc0phR2Zlb1NzNlpPTmVwd3dBc1ZqVDJCQ0Y3elpZ?=
 =?utf-8?B?eDJlbmNwMkZyaGlBOU1MYnFPdU82YjludlNKcVVhQXlCS2YvSVUydDdBL0ow?=
 =?utf-8?B?UE9JeDlHOGVXc2REQjdFR0JOQnJLWnFycFBJbzMwc2c0S3dMOHRQN3Era1ZS?=
 =?utf-8?B?L291QzhBS2xKd050bWJoVllRd0xvTkhrVWQzZEJuWGFMbkFtZWo3ai8wdlc3?=
 =?utf-8?B?WklGcCtyN3RycXZMSWpWK2RnQU5wYWYxWUp3eVExU0tLSlFiQk04Wm5wdko0?=
 =?utf-8?B?TFYzSXBPMWpqSVRIcXFiOWg5T0F4M0RVdTJPcytCTk9lUVVGejhHZDl4UVpF?=
 =?utf-8?B?cVdZdlNlQ1JEVyttb3FtQTNQbEo2L3MrRnRVYStRVTFBcW1qM2NGTWFRZE1q?=
 =?utf-8?B?dDRYUnZwazQ5VGs1UXB0VHRpY2U3d05uSXNsaXVxaGlKN2Y5b2NpL09NekY0?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FeBc8RRGr1ocuMXevy9Shmcsf+x0qMyxluDTUq9Qs13auEC51XtSj53fikMMbAQ7oOlDzf9EkSvmw/b3eZk6A7AR8yTfn817/JQNp64N6plldDCHNxI7Nyf4U6uyJF3A1Fg3et8gsQJ5MtHHTerCYdJU6adIJC0l+99yXZ/Jw+oiYnHfTs+axUJM1ovhcpsEo1S/hipd5VB3f+AJtkw/158VFRUprNlhdX9sEiGGB620ABCiu/Ea+hDVyJ4mpwXMJfv2uefSMvNckcf/g1CAmNqw/MtuuBqliw5FOzjidUzRbCWk8NEHMX+2mtl8dhUo6GT/S4a8ovMw0se5/+0fXXbKFMZcNBriJMr0TajqrxyxzuGUvGOXAZtf3H8AFuj+vcunSpjqDfYBx9EM0An0qfOsvnw2q+0kmjymicjCvmRHKTARHa+qWVtJ5cOUDRnhzWherg0v8n21aTiwHZij7M/aF690x4BJ+D0Pyo51WAb5R1vUO5V2ZiTiet8BEBOk5YjjBW08Ya4Bs87RxoaCP0I63i+8wqZPYiUSmWW2td6+yulr8vndEwUESdTitGFkt6H2rlzaDeu5ZS5mORxqkPP0HraiWVLADq+UdEHh0YM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b84953-6bf7-4348-9bbf-08dd6165501e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 12:56:32.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydmO5mcnDDwGWhm2Z2StwK+5rXPAy+2wN66IBs4wB9LXe90ymLzdCMMDlHVkzhhH5I8FbWFbQOReZHT2wQFFQNib7r3anb1kGiAI+OUIuLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-12_05,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503120090
X-Proofpoint-ORIG-GUID: gTB1yBPXTJjM5x91Ea6Mdh_yBC2TzDxw
X-Proofpoint-GUID: gTB1yBPXTJjM5x91Ea6Mdh_yBC2TzDxw

Hi Greg,

On 11-03-2025 20:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.291 release.
> There are 328 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok
