Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D99F17C7B5
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 19:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342555; cv=fail; b=AUbBkORdpOTCLKoIlBtoBx8G6gnV1CkFFIXRV/dQRxhmHoACmocG8NGDad3Me0jJ+mWgXpBymR/sMiSRxM46/b5dSd+j7x1LQ0Th5O6Y01t0Kcf0IAIsRvHB+lq5bgsq3q8p0oD0Cx/CDpn7x0Ubu6bBNiSUMzvGc1ZY4baxfnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342555; c=relaxed/simple;
	bh=3qlaU+58mxrufrAtelRWXplqZNRFhSJWcmQbl7YluSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mqhzNSThe0BSQR95Q68H47aHDe/wfEbL+GF+Cy8ywKEkG18qckOU98N+RlK8ESVUboL1SNPuAWr3O4bLBHRiecsw/MRapWNrPjpzmAgwxPMPg0gUzqj142FRb2rdXyf1N3tiMKdcA8enhcqsB3JFTXNmyZWBI2U8UWXDX6LBhTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GY+w95ei; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CTPucOkM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GY+w95ei";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CTPucOkM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45PIfTj0012799;
	Tue, 25 Jun 2024 19:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=3qlaU+58mxrufrAtelRWXplqZNRFhSJWcmQbl7Ylu
	SQ=; b=GY+w95eitzYxG+VCIQOKZrFC5Kkp9J/mYhmxXxve5BhKrEF/7NXpBtl65
	kMXcsXdxJp9scl+KDRHnsjEC3h7OsSIPi6EH+NbPpEvB6bAW7gs0ze7j2myB3mX3
	JhgybXz2m0Xs+gHl4aUeN4boMX0SiWsTK/evy2NcYkBszG7l0547oihWSkRGAA0m
	7V6IiWs0aw8gzdmBKGJWZH7woFTHf8rhPI9hu2RwLCRYa+FMvG6FMm43u2ulnL5x
	e5Y12hYnAuFKxffwQabcxX/L+R3u944Ju29WAyfRQ8DhCrAzQP2zsrn9M8bf/Slx
	4r5bVBQh8wu31B5S6W5kXF59cj0GQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywpnc9u5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 19:09:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PJ7qUg001392;
	Tue, 25 Jun 2024 19:08:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn28r7g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 19:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhYdvC4zSu216tK+ZDR8KVqS7Xx4ff8seEKFSd4eUPkjsglY8p72RMjqHlt2/O26JO8r0+vLYX8s9pmVGXp0uOE59G/T0zT/A8STpmnTvZaSsZ/+IuN9I6ugiMTNfDPraa6NsQC5AljM36aE5+pqlD87NslvVdR482wAgPoElr7Aw9sHCceAaOgxZ9ji2mQ0UAlRdSvEXLyU+aVIJXp+jSLeWscOtdtcU7Sq3VAolU4t9JL8aXy34Nn6Rw3tQ88dEizfEQ4/1SBscJhYAeAzarE6TXdNOE1mckglx8WXv3q2h9arw/RVMZ085CF30xQ9w2/gu3bgldVh6vPi4qcCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qlaU+58mxrufrAtelRWXplqZNRFhSJWcmQbl7YluSQ=;
 b=g4s92xRPs4iByZ5l1JCNGnGqmGtqtkiwnbfGsbgoV7I/hrJGeV4fFzjp9cECTLqbY0mDR4DSUCxzSYvxoq0QCLxo6LNTnQHfvZ2bykas6h1zz2TlPkAxJVcMaUAhmuIyBh0SAz5ZU5UZ8WwcAe8zG3srvNx9gvOsf8SEr7bonCCsS69EDMgtQdzLxcW77L0e6ifGA5XjzE58Ih3UTPXRuwKiJODCfIM1xfo+M2Ae+6AVYeKhpisLOTkFGaoxI7c0ynFfb3UngvJqEK5yqLmdfvq0mrlfjkfX52rN4DR3GrjwGrpOeYpSxW9PDEzdghjGmS6zl6DOoW5wp2g1cfro/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qlaU+58mxrufrAtelRWXplqZNRFhSJWcmQbl7YluSQ=;
 b=CTPucOkM7ypJlDxr7PHKfla19+sM0N1gn7AghpTL//sqcXQ+9Cp3BLKJDN/R0JmfgxGkueohfGbPDosILTkKSK8AVGNG670F7xuMh0Lol/7FKZSNrrY04dkcGJrBos6/4oubntKIHqfPbX+2fPLbJvKrQNuL7Y97CTEArGrzgL0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by LV8PR10MB7798.namprd10.prod.outlook.com (2603:10b6:408:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 19:08:56 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 19:08:56 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable
	<stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org"
	<patches@kernelci.org>,
        "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>,
        "conor@kernel.org" <conor@kernel.org>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "broonie@kernel.org"
	<broonie@kernel.org>
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
Thread-Topic: [PATCH 5.10 000/770] 5.10.220-rc1 review
Thread-Index: AQHaxxD2v5qwy652GEusd9rXWc6iOrHYlkYAgAAVRQCAACyGgA==
Date: Tue, 25 Jun 2024 19:08:56 +0000
Message-ID: <B5D1D979-253A-4339-AF15-5DB3B8503698@oracle.com>
References: <20240618123407.280171066@linuxfoundation.org>
 <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>
 <2024062543-magnifier-licking-ab9e@gregkh>
 <EEE94730-C043-47D8-A50A-47332201B3BF@oracle.com>
 <cf232ba1-a3f3-4931-8775-254d42e261e5@roeck-us.net>
In-Reply-To: <cf232ba1-a3f3-4931-8775-254d42e261e5@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|LV8PR10MB7798:EE_
x-ms-office365-filtering-correlation-id: 5518eee8-f5c2-458d-a2e3-08dc954a4312
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230038|366014|376012|7416012|1800799022|38070700016;
x-microsoft-antispam-message-info: 
 =?utf-8?B?QTJnNzI4VlJVbjM0QStXdVZ1QUJzMjhYRC84UFhvL1lkWXV6QTQzU1ZvYWg3?=
 =?utf-8?B?SXd3Z3RJQ2o0SFZkWS85RDRadnNWcmxaNWhMdEZ0RmExTjZibTd4Mm9TZU1O?=
 =?utf-8?B?VlYyNzRneGJaWFBFVkNJWlp5T0ZHbGE2dWptUG1RcjNwMFlIRFpLRy9FQTZH?=
 =?utf-8?B?eVlwbnhDMkFxZkNZVzFBdStCbkNmZktFYkFCVGoxNEpnS2cyV0tQWmM5amJU?=
 =?utf-8?B?SHdXYUw1bTM1Y0tXc2VVZVZHdlowckVCRUk0V2JRaDZDMEtoYlR4TkRidERL?=
 =?utf-8?B?Qm5uaVRRM1dRTW1Qc0tpbVNwRVU0ZWVWa0pHaTRnTGdzaXJFOUh5VWVSRnpr?=
 =?utf-8?B?Vk9zdkpHQjIvOVB1OWdKVjg0UWZxUW9oUW50Q1JVcDZQeEEzNXV1ekFwcUov?=
 =?utf-8?B?U1BiVUVVRVFZMXNiTjNjajNBYnh0bjlLaDN4OXQ3bzYzTXFIQjYybGZJTTFM?=
 =?utf-8?B?YkdVY0hyaW81NHJXdUR3aExsMW9kTGlQMkM0YVJWRWVJdGFLWGtnMFo4Mk5S?=
 =?utf-8?B?SDlMNXNrc0o2bS93bFpHaXRRNXpVcU9oZFlhVFk1ZFpiVDBhU1oyODFLWVhO?=
 =?utf-8?B?YkwyOXU5d2dsUGxrUjdROW1Xa0VEdFRUaTA2eVlVZlBNMVpKWDFRalRSN2ZJ?=
 =?utf-8?B?NXRES1Y4bFFrMVJGT1Ava1ZzN0hMSmo5MTV2L3lkQ1dTWFRFbStTdElxR3FN?=
 =?utf-8?B?OGJkQTFxSUhCbmFTZlJMVXJ0N3FtK1ZqTVpOa3pvNEw4YnVMVzVMR1ZGUkRq?=
 =?utf-8?B?Qm01dGtzdVFiSjR1VmVNNnBvRnFnNXV3OHJsWXozbWZNanBRMHc1VnVLVVhk?=
 =?utf-8?B?YWpycGh5dEp1bnRvS0ZYT0Q5WU1CTmExV2ZYeFdtS1JqcGxPYm1ITldiUTNI?=
 =?utf-8?B?bkhQV0VoMHVVaE43U2ZjNWRDbzNZdXpFSmx2Q2kveTc1ZWlkaGI0YXZ1Z1V4?=
 =?utf-8?B?aDIwN0NsQnVlRXVDTEFZU3hybmc0UDd0TXpIM0pQYmRGbmZ5eTlvdXVqc3JO?=
 =?utf-8?B?MG9jeWNsTTlKTXpkZWVPSkMxdXlxVXRXdUpPOFJuUUoxckNvaE15WURoWEVN?=
 =?utf-8?B?UUl3SjJvRTM0d0I3OWNMM2FsZmllMWJLYjhRTkV5R201UkViYmE0V2d4U1NQ?=
 =?utf-8?B?endJd2U0OUhYN3FjOFZrb1dQaStha2psd0F2emQzL3pjcjdsRWpiL1BaaTZC?=
 =?utf-8?B?bWNwUThKakoxTk1PVm5ac2pQclpydmRHSEM4T0t6dUJvWk90QnJyTVpKUEY1?=
 =?utf-8?B?ZXY3b1hCNG9DRHFweG5YRVZFVi9VUlJMdVlxUkhLMGt1Z3Ard0JpUGNRTzZU?=
 =?utf-8?B?OWNsUXRCQjNlT2E1WGQyNERuUTFjVzBOU0FMUWQyNDhGUFlXWVVQeUVaUGNV?=
 =?utf-8?B?YmZPMGJEWkVkQWVaL1hoK1M3TTNwakRVWnd3dFdBS2FjQWNMK2h2SkVOMlRH?=
 =?utf-8?B?eUg0bUptYWVEVlVyVjR2QWFnNVJhc01JVThKc3RKNHBkUHpCRjlBTFF5VC9m?=
 =?utf-8?B?SWEwamlqaDNDSEhiZWt5bEhxMXJZZGt2cmVQbEdzUy9BYU9oeU5qMVhhWmNZ?=
 =?utf-8?B?MU9USEwyd3pKclo1Wlk4QVo0M3ljVi9iL1k5V1Nydk4zdFgzNmQySm1zVThG?=
 =?utf-8?B?TE9tT294YWxxMzV3bytRa1RocFFWWmcwYTBiZm1QYWJIVGVMYWRjWiswdDBS?=
 =?utf-8?B?VE9XVEFRQ3Z1MXVkeGdsTitpTklMbUVxZzFKaHY1cXVkOG9GOW55Q215S1NL?=
 =?utf-8?B?QnN6ZUZOZXhGenAvYlBBQjBENnZBWFZTWGN0ME4zRC9ZM3hhNXVKSTF2ZXNz?=
 =?utf-8?Q?UhRngaH+DDiZZ4+mygPGQZeyL5Il4iufVYLQg=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(7416012)(1800799022)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Z2JTK2ZxWDRpQnVYKzRuVXBnTGtMYitaZFlyY25IUDBwYVFhbjlIYURzZUY4?=
 =?utf-8?B?anl2dExsVFQ0SmcvRlpZWENya0lsOUZBcmRGY0R3Y000QzRsNVdjcWFBLzhN?=
 =?utf-8?B?SG1wM21FaU00YzZWVXdBZUN4TDJVL3VGdEhMUUZycEpOMk42SnF4a1p5ZjNk?=
 =?utf-8?B?VG53SE9xUzU0SHR1b2k1ZWtZQUhocGoyMkp6UE1yelhZNUt0TVVROFNVamp0?=
 =?utf-8?B?NXBBTVgrSnh5MXZxc0JIWW50cWsxK2pLMVlkTXd4Rm1jL1hiRmJELzRKMTRo?=
 =?utf-8?B?QU42aGRTMHFqMDVzUjY2cDFVYnZqZXNMcDNUNWhmUytWZmhQQlcwcWhlQ2VW?=
 =?utf-8?B?UmhEOEFENGhjSHM2YnFNN1JhKzRyR3dQdTMzRks0Z0RvRUlpVDQzZ2hVdTgv?=
 =?utf-8?B?SnE2MXBuM1Baakg1R3pYY0xsL3pFQzlQRmRxdEdhaWxkNENkUmpJSzNGSngx?=
 =?utf-8?B?eklQL05KY2ROUi9ibStpWmFydzFvTW5xZythdmZienZadndHaFMrcmZsRjJu?=
 =?utf-8?B?U2gwcHhoeHJYNGhzYjZZUUQ4UHlqRjFXVGRUQ1FaOTJlYXJCUVZ0ZFYreThz?=
 =?utf-8?B?MGdtOVd2VVFkWmJaVVRBTTJHUFhZZUNoeGgva0RQN2lBbVQ5b3R3TStxVDNp?=
 =?utf-8?B?SDdiYW5obUxsaFdtcFN0cEEweE8zeEFmWDF0UHZEMFp2QjdZazJsSS9FS1E0?=
 =?utf-8?B?elNiT3VtMm9zb1ZlcFdvMUVFZlJ2ZUlEVUVsMDRVb1BTY0MzN0xhK3JoQmtF?=
 =?utf-8?B?ak1KalU1VDJXdEc4RkZPNlVIT3BYVEVBODUzYXRTeDN2Qkl5a2ZvblVVUTFS?=
 =?utf-8?B?c0daNnVPZUtuMmlGSVk0V3U2K3gzeHlYaEpocDRod2pEYmhnb2lMR0RHaWlW?=
 =?utf-8?B?T01SeWZ5aURBN1lNM1JmLzZkWWNWWXBud2FhMUpPUkVrTTd3b0lRZjkvSUJP?=
 =?utf-8?B?UjVWbWZjTzE5S1BDMUFTVEdpaFpSZnJVMStnSEhYYXBmM1poMzhzbUtlcXor?=
 =?utf-8?B?bDdYN0pGMFZyWGxFT0pYOUxaRzE5QjN3N2p0K1VJcWNacEF2MXRETkZvMjIw?=
 =?utf-8?B?Mk15RHhReDBlZlptQTBReElYa09zR1lQQm1yK1Irbi9BV0NUaVJKNElwTWdw?=
 =?utf-8?B?MXlDbG9aS1ZSbmNLWUxMYk5lY3Y3S0N6VzRSK09BdXl6UnRFbkI5ZjNTamx6?=
 =?utf-8?B?QisrN2xIcjhrT1VJZ1JYUEhiaGVYaGQ1MlF5bVlkeFAzSm5hLzREZHB2ZE1M?=
 =?utf-8?B?TE9lY0hxRitRRzZGbWRZczIxRXFpRmJodE4wOHhBVzYvaXFSNVZsM2lvMkFx?=
 =?utf-8?B?akhzWXVUcFZSUFVzRm9zWVVHcFFKcVlzU09ydHVsZzZoV0ZLcWorZGJmZGl2?=
 =?utf-8?B?dXphMWYvVmF1a1JrTHZ4QXl6TURjdkk4V28rTVhGZTg5UjZjVkkrVHVRRG9l?=
 =?utf-8?B?K3ZIenhGYnhYdldmK2FEcnUzTklOZG9rcS9OWDcrUVlzdHB4bzhLeDlLcG1z?=
 =?utf-8?B?Z3J3bU9nWXdIZkQrMFNVR2tLZEVudzhPaFVIa054Z2pTREUrbnpGMUJSK2tG?=
 =?utf-8?B?UEk0SkJIUXo2c05YNk9JM3V0bDQxYldobFEyclBZOHNzV3lrdHduWjh4Rnlo?=
 =?utf-8?B?VDEyNTFSU0ROZk5Sc1ppdDRrREc3TCtkOE92dFBnUWVLLzRlZnVteTJ0RThG?=
 =?utf-8?B?STFFRjB6eVNWS0s3MkZrWDhtclY2Zm9pazk1MDNwVW94em11L2Y3OXMrTHF1?=
 =?utf-8?B?VkR0RThTQk4xRFZOV2hyN2JvQ3pSSU9qVGhtanRXdFFqWUdqWWl0UlloVTFG?=
 =?utf-8?B?Vmc5UmF2M2E1TUpxazAzUDFjNkMxb21PbzZieHNNWUhOWWJILzVpMnp0NTF1?=
 =?utf-8?B?YnRlUDQyYkovR0xLRFlFZUtlcXBySDY2UThha1NiNEU3TGZ2QS9CUmVxY0g1?=
 =?utf-8?B?RFVVVUtnZ2N6ZmYzTy8xN3VGVlQrQ0lDR05UTG0rRmR5VXVybkw0K3hGZWFF?=
 =?utf-8?B?Z3d0d2p2MXA1Uk16VzlyT3VoNGcyMTBaMXhrVkFTZzZjVkMzcTgyQVBqZFVn?=
 =?utf-8?B?aGdWZitHeWYxYllCK2tWc1NrR2FONU1WWEk2a1BTVXFuY09sOGJQR2tkZVA5?=
 =?utf-8?B?a1U0a1hHcE5UamxycnB1K1lzeERIUlI4bXVJZnlqYnVscXFJL3NKYmZUZm1i?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77465B5602243E46B46936FC2032F16C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KmCUFQzwJVlFs3bPdYzrOpq0x0mu2O8DxX6LYQ5L9GLXhTy7d9UX0lvXuVfecDypsUCHaZ/0VmFF6+hZx6KpdOrO+z+LCLpR7FSiNWrJMup3dwrA3wGlxfeT7AFgyoD/9ckXwI3ujk3I1XgxGmEaTIb+X6BROWKDhWB/GzkZldGwSX0KwxQ5R1HKuhVC5caT69KGmKAm2qaAQDnvOY5nqvP4TGr03B9+AsVNEt20JCy0b9VP/slfjQGJ5bbtE1tFmvhVGmGwUAHeD5EWBHnyCZFnCl5DRBIb29afHuzJB825c7zo+caQO+QiTTgJiJGrHixoxFNolvyXvJEEsi9cVtne3IG9mtCF33M4wurUUtJYBeGEbQzB4vAei8tLNYW73vClCC2iBDIiymRdQPKCgAlgVa/zRGWgWPjMiuTx5Zy8MWlVCTZgEabayMIvxRVK2U1+OFok6BHouklCi79lnTbX3ZkTh2PJJQp6s9SfjHz8pxQD9P0460BXKWYO69L8Y6nz154dJvptEVVerGfEbQvei9c9xlw5231CXMfC/eQviNBK9g+MtHncV+50eWG9lolCKrZamlLCpQMDukDEfoOJLXMZ8/BwS38P9lMuU6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5518eee8-f5c2-458d-a2e3-08dc954a4312
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 19:08:56.4567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iaKU0TadeM8ZP3J98HSueL9h2TvahQ88oGQhm+2eOmp9f6WPvIofgGPwGkvhXkjH/RHnhb8IOwjJsTj4KM3EEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_14,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406250141
X-Proofpoint-GUID: nspBsqGKPlApwEIeRTM_F8OUw4oLSdh4
X-Proofpoint-ORIG-GUID: nspBsqGKPlApwEIeRTM_F8OUw4oLSdh4

DQoNCj4gT24gSnVuIDI1LCAyMDI0LCBhdCAxMjoyOeKAr1BNLCBHdWVudGVyIFJvZWNrIDxsaW51
eEByb2Vjay11cy5uZXQ+IHdyb3RlOg0KPiANCj4gT24gNi8yNS8yNCAwODoxMywgQ2h1Y2sgTGV2
ZXIgSUlJIHdyb3RlOg0KPj4gSGkgLQ0KPj4+IE9uIEp1biAyNSwgMjAyNCwgYXQgMTE6MDTigK9B
TSwgR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6
DQo+Pj4gDQo+Pj4gT24gVHVlLCBKdW4gMjUsIDIwMjQgYXQgMDc6NDg6MDBBTSAtMDcwMCwgR3Vl
bnRlciBSb2VjayB3cm90ZToNCj4+Pj4gT24gNi8xOC8yNCAwNToyNywgR3JlZyBLcm9haC1IYXJ0
bWFuIHdyb3RlOg0KPj4+Pj4gVGhpcyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcg
Y3ljbGUgZm9yIHRoZSA1LjEwLjIyMCByZWxlYXNlLg0KPj4+Pj4gVGhlcmUgYXJlIDc3MCBwYXRj
aGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPj4+
Pj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWlu
ZyBhcHBsaWVkLCBwbGVhc2UNCj4+Pj4+IGxldCBtZSBrbm93Lg0KPj4+Pj4gDQo+Pj4+PiBSZXNw
b25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgVGh1LCAyMCBKdW4gMjAyNCAxMjozMjowMCArMDAwMC4N
Cj4+Pj4+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBtaWdodCBiZSB0b28gbGF0
ZS4NCj4+Pj4+IA0KPj4+PiANCj4+Pj4gWyAuLi4gXQ0KPj4+Pj4gQ2h1Y2sgTGV2ZXIgPGNodWNr
LmxldmVyQG9yYWNsZS5jb20+DQo+Pj4+PiAgICAgU1VOUlBDOiBQcmVwYXJlIGZvciB4ZHJfc3Ry
ZWFtLXN0eWxlIGRlY29kaW5nIG9uIHRoZSBzZXJ2ZXItc2lkZQ0KPj4+Pj4gDQo+Pj4+IFRoZSBD
aHJvbWVPUyBwYXRjaGVzIHJvYm90IHJlcG9ydHMgYSBudW1iZXIgb2YgZml4ZXMgZm9yIHRoZSBw
YXRjaGVzDQo+Pj4+IGFwcGxpZWQgaW4gNS41LjIyMC4gVGhpcyBpcyBvbmUgZXhhbXBsZSwgbGF0
ZXIgZml4ZWQgd2l0aCBjb21taXQNCj4+Pj4gOTBiZmMzN2I1YWI5ICgiU1VOUlBDOiBGaXggc3Zj
eGRyX2luaXRfZGVjb2RlJ3MgZW5kLW9mLWJ1ZmZlcg0KPj4+PiBjYWxjdWxhdGlvbiIpLCBidXQg
dGhlcmUgYXJlIG1vcmUuIEFyZSB0aG9zZSBmaXhlcyBnb2luZyB0byBiZQ0KPj4+PiBhcHBsaWVk
IGluIGEgc3Vic2VxdWVudCByZWxlYXNlIG9mIHY1LjEwLnksIHdhcyB0aGVyZSBhIHJlYXNvbiB0
bw0KPj4+PiBub3QgaW5jbHVkZSB0aGVtLCBvciBkaWQgdGhleSBnZXQgbG9zdCA/DQo+Pj4gDQo+
Pj4gSSBzYXcgdGhpcyBhcyB3ZWxsLCBidXQgd2hlbiBJIHRyaWVkIHRvIGFwcGx5IGEgZmV3LCB0
aGV5IGRpZG4ndCwgc28gSQ0KPj4+IHdhcyBndWVzc2luZyB0aGF0IENodWNrIGhhZCBtZXJnZWQg
dGhlbSB0b2dldGhlciBpbnRvIHRoZSBzZXJpZXMuDQo+Pj4gDQo+Pj4gSSdsbCBkZWZlciB0byBD
aHVjayBvbiB0aGlzLCB0aGlzIHJlbGVhc2Ugd2FzIGFsbCBoaXMgOikNCj4+IEkgZGlkIHRoaXMg
cG9ydCBtb250aHMgYWdvLCBJJ3ZlIGJlZW4gd2FpdGluZyBmb3IgdGhlIGR1c3QgdG8NCj4+IHNl
dHRsZSBvbiB0aGUgNi4xIGFuZCA1LjE1IE5GU0QgYmFja3BvcnRzLCBzbyBJJ3ZlIGFsbCBidXQN
Cj4+IGZvcmdvdHRlbiB0aGUgc3RhdHVzIG9mIGluZGl2aWR1YWwgcGF0Y2hlcy4NCj4+IElmIHlv
dSAoR3JlZyBvciBHdWVudGVyKSBzZW5kIG1lIGEgbGlzdCBvZiB3aGF0IHlvdSBiZWxpZXZlIGlz
DQo+PiBtaXNzaW5nLCBJIGNhbiBoYXZlIGEgbG9vayBhdCB0aGUgaW5kaXZpZHVhbCBjYXNlcyBh
bmQgdGhlbg0KPj4gcnVuIHRoZSBmaW5pc2hlZCByZXN1bHQgdGhyb3VnaCBvdXIgTkZTRCBDSSBn
YXVudGxldC4NCj4gDQo+IFRoaXMgaXMgd2hhdCB0aGUgcm9ib3QgcmVwb3J0ZWQgc28gZmFyOg0K
PiANCj4gMTI0MmE4N2RhMGQ4IFNVTlJQQzogRml4IHN2Y3hkcl9pbml0X2VuY29kZSdzIGJ1Zmxl
biBjYWxjdWxhdGlvbg0KPiAgRml4ZXM6IGJkZGZkYmNkZGJlMiAoIk5GU0Q6IEV4dHJhY3QgdGhl
IHN2Y3hkcl9pbml0X2VuY29kZSgpIGhlbHBlciIpDQo+IDkwYmZjMzdiNWFiOSBTVU5SUEM6IEZp
eCBzdmN4ZHJfaW5pdF9kZWNvZGUncyBlbmQtb2YtYnVmZmVyIGNhbGN1bGF0aW9uDQo+ICBGaXhl
czogNTE5MTk1NWQ2ZmM2ICgiU1VOUlBDOiBQcmVwYXJlIGZvciB4ZHJfc3RyZWFtLXN0eWxlIGRl
Y29kaW5nIG9uIHRoZSBzZXJ2ZXItc2lkZSIpDQo+IDEwMzk2ZjRkZjhiNyBuZnNkOiBob2xkIGEg
bGlnaHRlci13ZWlnaHQgY2xpZW50IHJlZmVyZW5jZSBvdmVyIENCX1JFQ0FMTF9BTlkNCj4gIEZp
eGVzOiA0NGRmNmY0MzlhMTcgKCJORlNEOiBhZGQgZGVsZWdhdGlvbiByZWFwZXIgdG8gcmVhY3Qg
dG8gbG93IG1lbW9yeSBjb25kaXRpb24iKQ0KDQpNeSBuYWl2ZSBzZWFyY2ggZm91bmQ6DQoNCkNo
ZWNraW5nIGNvbW1pdCA0NGRmNmY0MzlhMTcgLi4uICANCiAgdXBzdHJlYW0gZml4IDEwMzk2ZjRk
ZjhiNzVmZjZhYjBhYTJjZDc0Mjk2NTY1NDY2ZjJjOGQgbm90IGZvdW5kDQoxMDM5NmY0ZGY4Yjc1
ZmY2YWIwYWEyY2Q3NDI5NjU2NTQ2NmYyYzhkIG5mc2Q6IGhvbGQgYSBsaWdodGVyLXdlaWdodCBj
bGllbnQgcmVmZXJlbmNlIG92ZXIgQ0JfUkVDQUxMX0FOWQ0KICB1cHN0cmVhbSBmaXggZjM4NWY3
ZDI0NDEzNDI0NmY5ODQ5NzVlZDM0Y2Q3NWY3N2RlNDc5ZiBpcyBhbHJlYWR5IGFwcGxpZWQNCkNo
ZWNraW5nIGNvbW1pdCBhMjA3MTU3M2Q2MzQgLi4uICANCiAgdXBzdHJlYW0gZml4IGYxYWEyZWI1
ZWEwNWNjZDFmZDkyZDIzNTM0NmU2MGU5MGExZWQ5NDkgbm90IGZvdW5kDQpmMWFhMmViNWVhMDVj
Y2QxZmQ5MmQyMzUzNDZlNjBlOTBhMWVkOTQ5IHN5c2N0bDogZml4IHByb2NfZG9ib29sKCkgdXNh
YmlsaXR5DQpDaGVja2luZyBjb21taXQgYmRkZmRiY2RkYmUyIC4uLiAgDQogIHVwc3RyZWFtIGZp
eCAxMjQyYTg3ZGEwZDhjZDJhNDI4ZTk2Y2E2OGU3ZWE4OTliMGY0NjI0IG5vdCBmb3VuZA0KMTI0
MmE4N2RhMGQ4Y2QyYTQyOGU5NmNhNjhlN2VhODk5YjBmNDYyNCBTVU5SUEM6IEZpeCBzdmN4ZHJf
aW5pdF9lbmNvZGUncyBidWZsZW4gY2FsY3VsYXRpb24NCkNoZWNraW5nIGNvbW1pdCA5ZmU2MTQ1
MDk3MmQgLi4uICAgICB1cHN0cmVhbSBmaXggMjExMWMzYzAxMjRmNzQzMmZlOTA4YzAzNmE1MGFi
ZTg3MzNkYmYzOCBub3QgZm91bmQNCjIxMTFjM2MwMTI0Zjc0MzJmZTkwOGMwMzZhNTBhYmU4NzMz
ZGJmMzggbmFtZWk6IGZpeCBrZXJuZWwtZG9jIGZvciBzdHJ1Y3QgcmVuYW1lZGF0YSBhbmQgbW9y
ZQ0KQ2hlY2tpbmcgY29tbWl0IDAxM2MxNjY3Y2Y3OCAuLi4gICAgIHVwc3RyZWFtIGZpeCAyYzBm
MGYzNjM5NTYyZDZlMzhlZTk3MDUzMDNjNjQ1N2M0OTM2ZWFjIG5vdCBmb3VuZA0KMmMwZjBmMzYz
OTU2MmQ2ZTM4ZWU5NzA1MzAzYzY0NTdjNDkzNmVhYyBtb2R1bGU6IGNvcnJlY3RseSBleGl0IG1v
ZHVsZV9rYWxsc3ltc19vbl9lYWNoX3N5bWJvbCB3aGVuIGZuKCkgIT0gMA0KICB1cHN0cmVhbSBm
aXggMWU4MGQ5Y2I1NzllZDdlZGQxMjE3NTNlZWNjY2U4MmZmODI1MjFiNCBub3QgZm91bmQNCjFl
ODBkOWNiNTc5ZWQ3ZWRkMTIxNzUzZWVjY2NlODJmZjgyNTIxYjQgbW9kdWxlOiBwb3RlbnRpYWwg
dW5pbml0aWFsaXplZCByZXR1cm4gaW4gbW9kdWxlX2thbGxzeW1zX29uX2VhY2hfc3ltYm9sKCkN
CkNoZWNraW5nIGNvbW1pdCA4OWZmODc0OTRjNmUgLi4uICANCiAgdXBzdHJlYW0gZml4IDVjMTE3
MjA3NjdmNzBkMzQzNTdkMDBhMTViYTVhMGFkMDUyYzQwZmUgbm90IGZvdW5kDQo1YzExNzIwNzY3
ZjcwZDM0MzU3ZDAwYTE1YmE1YTBhZDA1MmM0MGZlIFNVTlJQQzogRml4IGEgTlVMTCBwb2ludGVy
IGRlcmVmIGluIHRyYWNlX3N2Y19zdGF0c19sYXRlbmN5KCkNCkNoZWNraW5nIGNvbW1pdCA1MTkx
OTU1ZDZmYzYgLi4uICANCiAgdXBzdHJlYW0gZml4IDkwYmZjMzdiNWFiOTFjMWE2MTY1ZTNlNWNm
YzQ5YmYwNDU3MWI3NjIgbm90IGZvdW5kDQo5MGJmYzM3YjVhYjkxYzFhNjE2NWUzZTVjZmM0OWJm
MDQ1NzFiNzYyIFNVTlJQQzogRml4IHN2Y3hkcl9pbml0X2RlY29kZSdzIGVuZC1vZi1idWZmZXIg
Y2FsY3VsYXRpb24NCiAgdXBzdHJlYW0gZml4IGI5ZjgzZmZhYTBjMDk2YjRjODMyYTQzOTY0ZmU2
YmZmM2FjZmZlMTAgbm90IGZvdW5kDQpiOWY4M2ZmYWEwYzA5NmI0YzgzMmE0Mzk2NGZlNmJmZjNh
Y2ZmZTEwIFNVTlJQQzogRml4IG51bGwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbiBzdmNfcnFzdF9m
cmVlKCkNCg0KSSdsbCBsb29rIGludG8gYmFja3BvcnRpbmcgdGhlIG1pc3NpbmcgTkZTRCBhbmQg
U1VOUlBDIHBhdGNoZXMuDQoNCg0KLS0NCkNodWNrIExldmVyDQoNCg0K
