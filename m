Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F8415B554;
	Fri,  4 Oct 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728065394; cv=fail; b=hE9iOlPV2gUXAM+l2TIzjx4KvGdXS8eTeQtXd8pI1N0pocu/UD902D6rdKJy4hbma7L+bz8ZXIRJyHd5+o7kmaZyLLE9Q22mUxX7L+B4XskGnQ6LxqxHgcVd3H1savEOH+7wM/LayTxC5oEPhDyKkjiW15Ic4RfjoW4yed1EX08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728065394; c=relaxed/simple;
	bh=5nB4k2UWZtE5ADIQHkJxmmwhl6gdbJf/Bs3loAYyTGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VH2yISsF0cJOyXxYv9Jx0tp0dBu0ZRovT8if4IHGacCIBuuz13wsgEDKguVNpfBanHN8qZFp0rNbllfnE79ljMvl2pUH4Av8OhR8n5AcoibMiU7X73Um2MdvbpCymfoSLoNyMG0tyLcOUSOuGQYeZ4sD121RxFlTY3CjAyYBOEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kstr0MKT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yZeT4Xeu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kstr0MKT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yZeT4Xeu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 494HfdUK027793;
	Fri, 4 Oct 2024 18:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=5nB4k2UWZtE5ADIQHkJxmmwhl6gdbJf/Bs3loAYyT
	Gg=; b=Kstr0MKTsJJijZbEaTD1AL/xSFa8/2f2KRi8s8Q05PkrNWLM8igBHlOEx
	Ukci4rFr6HE2JPYQG6SCJVG8tSilvgSSfGbMHpazR3Osx1ubIYWnnnmBqOUNulTI
	JZNIiJmmPqa5JrfYcyI+pgjhPj3tzuEZc/i0SN6jn2KWiwN+YAQGZw1lLI/Ye4IM
	IcFn4qVTfTSQcairtx8KpGLoJyFJCdSpatjyVLrTvk6wFEGpxJl2Nl6piP3VkceF
	+/HypzNp9sHM/AeVRhdNCsr5O63r1XdUBBQGhP6KGDcZlFOeyzc0NT0emi8QAa0n
	BmHpNMjjz8Lxnpj2Ziz8gwRC6HYLQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204926mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 18:09:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 494GUts3013294;
	Fri, 4 Oct 2024 18:09:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422057wkey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 18:09:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQM3RXYXkFbVn6suEGre/ZBfJZM513ZGMUGxrcj1oS3ZM6vCecJmDKPcpLVoLJa//uL7JQ0HCCFtLNTi3cV05ArRdPntPUP5oLMw2QexVuZGfvgRQLCrm1poBtqDfVGs8YEfXDsHVh/N+2OroPYRr7WQLsRzOAWS5vypU4r9Trc7MpefOcGt+1W/5qSUaG03Exknu/1Tk3XzUX9RvrQ62rHSjGvJAsijU114Lp9LcM7r1LpPFP0g/fhjNk22Bmrv13l1vjgusoik7lLvVoSX5cACvqTu3TPvOwXSGPB2+qh/buEHi3KUQW0d+3r+Pw7FmjK39VjvyDpM7Gb6fDLKSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nB4k2UWZtE5ADIQHkJxmmwhl6gdbJf/Bs3loAYyTGg=;
 b=OtFFiNKholQLWAOqDBojldfz9HYr4MRT1vCIvHkrvfN7QM0DA/rxS9XnVNRL6Micp7BAiuzOhYjjtleCPGb6YUoqYs10luXRUhCMy4kEz8Lf4vgBY/UpRlLwv1VpohczyFbPjUMuOh5Lixae1/ofd22HFAaclRJgG6xoDBa0ZiMI+yixINa/BATkiKyEW6fkwXTLdYkUt7aMQx7uP6FH+55WUh9fBaVcV/k8T7pAE0d76bLw3ZMQ1cc3HTL8nKlJzxXT80MlsxUuX3s2T3OAQyGO7kkkVzszFnFXODrv6Jv8ZkT8nnL4UXMCXTJWbV8+FN6426wBrUAOZOQRQHo8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nB4k2UWZtE5ADIQHkJxmmwhl6gdbJf/Bs3loAYyTGg=;
 b=yZeT4XeusuCkQ9UaKU57Qhwx43r4OJD5TwJI+YLla19j4goXc1zADidpI+17DYQP+G1si2tH9F54JlfARJfFFkAutt7U9p+kBPQMTw0dTPrHXNYN0lcD0GOZwx+Eq6dp0VJlScbR+11nz3CLhvRVzpnUC11vYfHz67DL7L2xnxE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB7334.namprd10.prod.outlook.com (2603:10b6:208:3fc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.18; Fri, 4 Oct
 2024 18:09:44 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.8026.019; Fri, 4 Oct 2024
 18:09:44 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Youzhong Yang <youzhong@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable
	<stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Jeff Layton <jlayton@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Thread-Topic: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Thread-Index:
 AQHbFNBh+el4ZjAI5UiZoizZfWmvE7JzgJ0AgAEe04CAAG5DAIABlJIAgAACgICAAAHqAIAAAomAgAAChQCAAC6xgIAACiWAgAAC7IA=
Date: Fri, 4 Oct 2024 18:09:44 +0000
Message-ID: <0CFAAF67-170F-4BA2-BC16-F9B40ADE7D35@oracle.com>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh>
 <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
 <2024100420-aflutter-setback-2482@gregkh>
 <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
 <2024100430-finalist-brutishly-a192@gregkh>
 <2024100416-dodgy-theme-ae43@gregkh>
 <8AC0ACC8-6A77-487E-B610-6A0777AFC08E@oracle.com>
 <CADpNCvZXyw25A3+DvMpECFoffWmcrFQ0Do5hhwbqftxTVr-+Mw@mail.gmail.com>
In-Reply-To:
 <CADpNCvZXyw25A3+DvMpECFoffWmcrFQ0Do5hhwbqftxTVr-+Mw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB7334:EE_
x-ms-office365-filtering-correlation-id: caf097f3-89f4-4831-01f4-08dce49fb96a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NFRxSEJIQ0VYY0ZCRTNOMVNDdlM0Ym9ETmxxalk3b01PNU1HZnBvU3U2dWZj?=
 =?utf-8?B?ZHNGUy9ZaURtZHh5aVdGRVAvdVBwUHJPTEo3Y2tSVG1rZnJmYTNxTnk2K0dr?=
 =?utf-8?B?WWV1UkpNM0xJUW9zYkFMRVZ6OWlIV0Q4Smc4dlpMYnpIOXNrMHExYmdaQnZM?=
 =?utf-8?B?RUlPcUM0OUlQSmV4UVJkSjh1YlJ1cm5ndE0vQ2R0T0ZWWDJLcWVZV3pEQ2FH?=
 =?utf-8?B?YjR0SWZPbFhQQnBEamJPZnhhY21xVEFwTWtvWVZzTE5tNnFzWTFvY3VISjNO?=
 =?utf-8?B?VnhWNGdRQnZXVGkyRDRXWTI1VFZaSDFhRHVBTzRZVERmNHlSaldXQi90U1JL?=
 =?utf-8?B?MFZlUmtMSWtveE5uSzNXTlNKR3lQbktnYjdMZW5MdS9uNmVldDRUQnZCZHNJ?=
 =?utf-8?B?ODNKMStQU0V2RGZJaGtrQjN1aloyUGgvSTlNa1l1VDM4ZlRtZ2owTXF6NmJU?=
 =?utf-8?B?TjZjT3JHYkdUMnFLNDN5Q0R1b0U5UGxsK1FJSzZDUG9TSHg2bExuNEZKNFky?=
 =?utf-8?B?OHlYTUtzbmNJdkdFdkJ3aGpORVRPZnZWMk5COE8rVHBjOG5DY0JYVDBxRHRt?=
 =?utf-8?B?b2R3bEh5QlZ5SDJiYjY5NGo1eEIzSWhoR0hxQlY5eElhU1FtZnBzUlRnNjhl?=
 =?utf-8?B?TktFejdYUlFTb3I3NDlmcENsU21US0w0OENydXdIQ1FVZXZ2blV4VWk1M2RD?=
 =?utf-8?B?WWtuNUZGY3JNaVlaRWlMYTJRZElqQWtER1VaZG5ZQ1E3MkJqWXVubUVTVTV4?=
 =?utf-8?B?MGVJOC9EWGNEaXczWFdJN2huV3ZUN25Ca1R3RXlCMXNGNHBOS2JWRk5ya2xI?=
 =?utf-8?B?eVNlVmRPNjNsbTNWeklpSzZiNEEzM1FLd3lKYlJlWGJtUTZqa29VRGJJTk4v?=
 =?utf-8?B?cjczRElQaTZ3Nk9aWk4wV0NxZ2xXcTU4dEVOM053bnNwRU5sNTVOdmNuMWJR?=
 =?utf-8?B?ak5wcnhLa3VydzhlN0ZRV2xaL241YmtTZnlFQUNvQnJYeFVRYlM3OUdpN3pY?=
 =?utf-8?B?QW5pRHB2ZlViUXoraXFuTWVCQTVkbmdrZzAwUWZIaDFQV2NCbnp1cURqZHVT?=
 =?utf-8?B?MWF1SGdxem9mTXRsQjlSSDVEVFhUczV5bTZMZnR4QzVTc3VoMHVxVXpFN1A4?=
 =?utf-8?B?VzQrN011ZWtTME1CYWliMVdKbmlLNURIdG9vbnlQOFJRSnJ5YnNRb0pBRnF4?=
 =?utf-8?B?QzVUNHVzNUtjSnhwb1dJQ05UK0NSb0dNdktScTd1U2pJNkppVTJHRGEvdUFm?=
 =?utf-8?B?RW0xRDJxOXpRbFQ2bytPc0NOTmN1aDdORHhUVU5JM3BRNVg1R2FXd251VmlV?=
 =?utf-8?B?a3Iwa0NQSXRDYW5JZldKZHZkTEtRNG01elRpZEEyMi9BOFl3SzhyUFdKSThF?=
 =?utf-8?B?MHNLM2hGcURRbWtHRkx2bWY5aHRhUWJGRXVSSmJVSk1tU1BGOEViTWV3SGc1?=
 =?utf-8?B?QmVRbk1jSHI3M3ZUTmh0MUg3ZUJEck1pUkpCTDc2cTRGWlQ1ZHIzWUY2L01k?=
 =?utf-8?B?UmxVQ2RtRWx2THRldy9RaVVnYVJJMUhxK0dpTmpJdWxFdm12WHpjRk9iY2Jw?=
 =?utf-8?B?Z0l5aVd3akxuVll4T21XaDE0eEtXaU40dDVDV3ZsU0pxZTZoMjZ6cElOS21i?=
 =?utf-8?B?MTFncEV4cDdVbjNXYkwvbjM1eDAvcldENkNZN1RNMzljM2YvOTlVWW4za2Zl?=
 =?utf-8?B?N1IxaWw1OFhsU1QrV1BTR2IydXJvTjlueGtCVVVQQ0pQcnRUWVFUbEFXYWQr?=
 =?utf-8?B?QzNmdFloaXQ5a3dkM0VqS0dWbXczS21HQnBtR0Q4WlN3Z0s0dWJjd3JqWVNh?=
 =?utf-8?B?citGNlh6a0FFdlp6ZnA3dz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZVREY2pyVVJyamlqSTNva1d4Z1E0bThqU3Ztb0gwU05TZHpsUE50T3A0VFlj?=
 =?utf-8?B?SG92V2Q2N3hKemVZV0t1NXFhUU8vUzZXbm9pdUxUM2QxN2F3aUk0dDNmbDQ0?=
 =?utf-8?B?L3hNNUxuRldNellqUExJYXp6TlhGODMwbGJySDdwdW05djJKOFRSa0pRVUtl?=
 =?utf-8?B?ZzYyU05VRkN4ckZ3NTE5VHJBcFNnamd5aEVqWXR5MHJxaUEvQ1dmSm5rN3VG?=
 =?utf-8?B?R0FhUnRxVE5pV09TUkN0ejRZK1JGVk5ScUd6cUtqNWNTYTFEaTdjZjJycGhY?=
 =?utf-8?B?enEydUYreFU5SXdueTd6eUx4Y1pMSGRnTzlGVWNyRnJVMCt5YTVnc0Rydy9G?=
 =?utf-8?B?U0JqUVhESjZRS1hrN21kYkNSWk9TZ1NURVRpSktSNW1BOFI0djZDK2dTUmZi?=
 =?utf-8?B?aC9CS2ZyOEp0TU15dnlXTGxXZ1h4WE9YMVdENE8rMXdaTG5jaUtFc29Xd2o0?=
 =?utf-8?B?dUdQOUNnV1c3cmVPQXA3eDgvaTc5T0FhSEhQTXJFZkRURHVGRUtrc3NQVVIw?=
 =?utf-8?B?dHJsWFdxSU53aFVQMEd0WE90WTVBUnhXaStNbWJkK0RVVTMzNTAxNXlodE5G?=
 =?utf-8?B?TVNHTjAzZVREcEJxdkxVRHh0KzlZWUpvb3lVT09Mcm4yaFk2eXZDS3M0UE5h?=
 =?utf-8?B?UGpPcEVLTkZaeXh1bkZaTUR2TGZLaFJMV1cxZ2ZYOGtubkRGK1JVUjN0NmdT?=
 =?utf-8?B?ZFl3SmdvTlBBbnJ4bWJ5OXFlSVlGZ1NnZGpyTm5ONzQ5Umx2eGJlNXhnN3A5?=
 =?utf-8?B?RTI0MG5xOTlmY0Uva1I0bUJzMTVvUnQ4ZExaWDlZOE9RU3ZURmdLQnh3Zkln?=
 =?utf-8?B?enVwQVNhL3NFdG4vQ1A1dDlGUFhac0lkaSs1NFZUUG8xMG8vS1JSQjVlWmtH?=
 =?utf-8?B?OW1meC82bE5zRGpOaEVwRU5yQUFhb3VyY3JVaDhudXR6RSt6Zk1YbDhkQXVv?=
 =?utf-8?B?Zm1tM1o3Z2JKK2xmeEQxQi9MQUhSRThwSndSYmc5bEFrWDFzcUNkN0VQQTJa?=
 =?utf-8?B?eGMyUU5tdWhOUjM4Y0ZzOFlabTFBbE5YV1YxSytqV1MxUVJjcGpqMncxQ1NX?=
 =?utf-8?B?dTVwZ3dkL0NDb0dvbnRkdE1ialdVUm5sQThhQXBHREZjcjNsYkEzZ3VzelJU?=
 =?utf-8?B?SmY0UTdXZ3lBZDZ6b2VZWjc1dzI5STU3ZGxSaG52OEgyVzZaVm5KUVBicTl4?=
 =?utf-8?B?WDZXczdLRk9nOXpsWVR4Z3R6UUVkYzFCS2JZRlZ2SFlldDB3bWtBS3NhbUtE?=
 =?utf-8?B?T20zZTVmNjZWZmZwRTBMS3VqQk9JejhFY2RBeTNUQ1libEdZaFFGUHplNUI4?=
 =?utf-8?B?VHlMWmlSNlh6YUVFbGNteWNKR0xWd3p4Sm5CYml1RFRzYUttb0g2MllvYUtK?=
 =?utf-8?B?QTVZdHJ5V3JTUWhRbkg3N0pxNzluRkxpSVRma1M4a2lzdkxrSnE0Y20zd2Vn?=
 =?utf-8?B?aVNMQXdPQjBQdjVHVzlFTzd6NFhkVTRZamp6Wlh3K09Rc2N6dVBqM3BaNGNS?=
 =?utf-8?B?c1ZwNG5mMEtqby9zaXA0bnBibTVzV1lMQkVaVWhyNzllclhaeEM5SFZLMkc3?=
 =?utf-8?B?QUFXV1NVYzZuRHhCcGZjd2xWazQrU0JrYkJUSU9QZEdqTjhMWWNNRTZzZ0RC?=
 =?utf-8?B?STBLVmVYaTRpZEwvb2t2dkVNbmk2ZkprRThuK01tcTNnTVNoWXJjVGxVcW94?=
 =?utf-8?B?b0dzdVU5SXEyaUwyMHdSdVRnVUE3V0FnZk5FanVBdk5ib1BMNFIxY0pxVklz?=
 =?utf-8?B?MjhTSHdRNmZPajBFUTFzbnVrNG5MdG81NFF3K2pUUU4yQ2lOdkMzdzJHUElw?=
 =?utf-8?B?QTNsY09TYWwrV1pHSi91WlNvMERsL3JkTUc4WFZ3RXhFMWFqT0oxQUtnMVFZ?=
 =?utf-8?B?VzRZVnloNjB4ejU1VXlyWXAxZm9mbWxKS2U1ajJlcDNQTzNKSzAxRDl3WXRC?=
 =?utf-8?B?OHJoZm9pbFNobWtaMUN3KysvYnZlQ3RTSGFKSU1ib1A3cWZDcHp5b1hoQVky?=
 =?utf-8?B?d3hmRVNkRExaUHdpOFRveUpDcE83aXJ3ME9UUkkxTmpXMDNhVE1RYk4vSGQ0?=
 =?utf-8?B?ZytETm9zeHJWdm5ReHZkVzRGYUhaTUdPZDAxcHIxdGNsT0RKbjhFZmJ3MCtp?=
 =?utf-8?B?aVF1UGtFZmVReEpmT2ttbUp3cllzYzhZV0c1N2R2UHFrZDhyRnN0eFc1aHVV?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B4D59F33BD2D8418FCF0F97ADE603CB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1R0W9wPDxMvnRDMi69Y5uqnLemsBKO1ZgOKwdlPxuLcDbk3x7BEt0bVhHbaEOf42OAWU5yAMGCBCOcy+6JNezn1EtJnazbnXyXnXdzAEEFbb9WZzr25ctNvrv83NPltz9tvoStHag2h0spNae3r7CglkECcbaNCxEbs2jcxN31zr5iM+CY2Ov4OsJhDnAvtEfaXWCpi7VmXIO4SzauGRdjUq4YUfB4JkG5e0AwDT6L4AnHPkXFw02ALerM4jeUyIQTbwddxY0dRSwbhzCCzO8izfjKo8HXq7L3z7RnMbP/QWWtzQWQ0ti80Kx+kEZ3kclDeLBVr0V1K0mjPKQlemUfh/nbIT4eb+2Xq7o0pAIodKtl49LM89tDzNEjThGawvAcWoxiC9NAYEXnf63t293HdO6KhMaarqYd6dMat6LnIjzmsnjfolhDqLiDZ2kZRgCan3uqm9TosV3Iv9Hhxp4iFp+9M/769cyA1LoL3KH4LAkIBMv6x3+F6gCK2L4YsmI8YYnOPjByuRW3ClDbuSDlxdQWCDoiOuvqjPJqKxYlSqQ8JIGnYdpEGYtnjoDfJxwM9Q8XJfZxkU/kOZRkzPrD7xJl1jff7TeFbcjre5WtQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf097f3-89f4-4831-01f4-08dce49fb96a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2024 18:09:44.1047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U4h4mTQXSvIShlkxhNXS8ovJnpfB6EUeAYaM0PZ7EwyLJXdLvw1Zxr4QXX5xkJdAKTz0Tk9jBz7PV8xaNfzN/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7334
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_15,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410040125
X-Proofpoint-GUID: py83H-Tc-hpwIFwXxVu43320Jq-8xb8d
X-Proofpoint-ORIG-GUID: py83H-Tc-hpwIFwXxVu43320Jq-8xb8d

DQoNCj4gT24gT2N0IDQsIDIwMjQsIGF0IDE6NTnigK9QTSwgWW91emhvbmcgWWFuZyA8eW91emhv
bmdAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IFRoZSBleHBsYW5hdGlvbiBvZiBob3cgaXQgY2Fu
IGhhcHBlbiBpcyBpbiB0aGUgY29tbWl0IG1lc3NhZ2UuIFVzaW5nDQo+IGxpc3RfaGVhZCAnbmZf
bHJ1JyBmb3IgdHdvIHB1cnBvc2VzICh0aGUgTFJVIGxpc3QgYW5kIGRpc3Bvc2UgbGlzdCkgaXMN
Cj4gcHJvYmxlbWF0aWMuDQoNCiJpcyBwcm9ibGVtYXRpYyIgaXMgbm90IGFuIGFkZXF1YXRlIG9y
IHByZWNpc2UgZXhwbGFuYXRpb24NCm9mIGhvdyB0aGUgY29kZSBpcyBmYWlsaW5nLiBCdXQgYXMg
SSBzYWlkLCBJJ20gbm90IG9iamVjdGluZywNCmp1c3Qgbm90aW5nIHRoYXQgd2UgZG9uJ3QgdW5k
ZXJzdGFuZCB3aHkgdGhpcyBjaGFuZ2UgYWRkcmVzc2VzDQp0aGUgcHJvYmxlbS4NCg0KSW4gb3Ro
ZXIgd29yZHMsIHdlIGhhdmUgdGVzdCBleHBlcmllbmNlIHRoYXQgc2hvd3MgdGhlIHBhdGNoDQpp
cyBzYWZlIHRvIGFwcGx5LCBidXQgbm8gZGVlcCBleHBsYW5hdGlvbiBvZiB3aHkgaXQgaXMNCmVm
ZmVjdGl2ZS4NCg0KDQo+IEkgYWxzbyBtZW50aW9uZWQgbXkgcmVwcm9kdWNlciBpbiBvbmUgb2Yg
dGhlIGUtbWFpbA0KPiB0aHJlYWRzLCBoZXJlIGl0IGlzIGlmIGl0IHN0aWxsIG1hdHRlcnM6DQo+
IA0KPiBodHRwczovL2dpdGh1Yi5jb20veW91emhvbmd5YW5nL25mc2QtZmlsZS1sZWFrcw0KDQpJ
J20gYXNraW5nIHRoYXQgeW91IHBsZWFzZSBhcHBseSBhbmQgdGVzdCB0aGVzZSBwYXRjaGVzIG9u
DQp2Ni4xMSBhbmQgdjYuMSwgYXQgdGhlIHZlcnkgbGVhc3QsIGJlZm9yZSByZXF1ZXN0aW5nIHRo
YXQNCkdyZWcgYXBwbHkgdGhlc2UgcGF0Y2hlcyB0byB0aGUgTFRTIGtlcm5lbHMuIEdyZWcgbmVl
ZHMNCnZlcnkgY2xlYXIgaW5zdHJ1Y3Rpb25zIGFib3V0IGhvdyBoZSBzaG91bGQgcHJvY2VlZCwg
YXMNCndlbGwgYXMgc29tZSBldmlkZW5jZSB0aGF0IHdlIGFyZSBub3QgYXNraW5nIGhpbSB0byBh
cHBseQ0KcGF0Y2hlcyB0aGF0IHdpbGwgYnJlYWsgdGhlIHRhcmdldCBrZXJuZWxzLg0KDQpBbmQs
IHBsZWFzZSBjb25maXJtIHRoYXQgNC80IGlzIG5lZWRlZC4gSSBjYW4ndCBzZWUgYW55DQpvYnZp
b3VzIHJlYXNvbiB3aHkgaXQgaXMgbmVjZXNzYXJ5IHRvIHByZXZlbnQgYSBsZWFrLg0KDQoNCi0t
DQpDaHVjayBMZXZlcg0KDQoNCg==
