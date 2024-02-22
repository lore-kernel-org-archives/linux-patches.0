Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD81426D;
	Thu, 22 Feb 2024 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608837; cv=fail; b=abTHF2zNyPJRydlTH+J8bFmD3AwYjWXSsrIosfWpgU1+vY3VZNJSCXKs+Dv5q9KFQOIzHT77pjF4m8FuuSdDVUhG+YHO6KpMHckRZo9DX+Yns4Re8fSzirekZ5AmJOt0ww6/UoGcaof+ETvSXIoyFioPodeejNh6zfXg4JHn/As=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608837; c=relaxed/simple;
	bh=qLM9yRqBXUZqMUWYNxgeNFaFZWsPlJ5uyq5WMXVAAyU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pQnWtFunGKDbJonI2QvSmu5e4syhXDyJFeP91L1/0xNCcXXvL4+VEC8TETELDNhX0G+nC7WpDYidbeOELtsF3rn2sIH9+hO7VWDowjy6YKwwCHN3/kPwWtmCnEhAGfq1ak4KxdiFvucGKB8UpRI/5nO3WCR1Iaw0knB1bX6DLjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P2e7IGYL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vDD3PSRU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P2e7IGYL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vDD3PSRU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41MBHW8C012746;
	Thu, 22 Feb 2024 13:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=qLM9yRqBXUZqMUWYNxgeNFaFZWsPlJ5uyq5WMXVAAyU=;
 b=P2e7IGYLlc5XR2LNQ3mJi/kVuaHgl0/Xtq/aI1erCqkSesC1tSMQvZ4IV2VudBgreWYP
 5k44vHdL9v6S4rfJqLAepW8TgOpHFur1sLLccy9QhHiEMoSMcyDzGeNXJr/1BFGTo0hQ
 niii/xes3IUWNIN8xuiAmedJabGKsYaqr3Pj4YI/qbuoRSpepEsYSGjSHCSxHMGfNH75
 x1v7K70OhMQDtxiJWUzMY1VWqfRIWHD+JuIyamVUiF0tzquIxcRbFRG7XOZX+VrdpCjS
 4GaE8zd62cuv6NjYH2gkOe8hqtZQqYH9pcBKqut7CtRcqNgTIlJrayc1UnM9zf0w/pL2 4A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakd2cs5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 13:33:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41MD4MZi035656;
	Thu, 22 Feb 2024 13:33:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak8akr6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 13:33:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrXBRNNTdS+HxGrFAWgKvIupWyhsUaeeW+lccSRWiT/Suqrj4kr9N0LL68FyinWZteJCjjz//W//EEsgccSshMZ7P8YztLk0OZ7Iqp/DvdaWAuXFCLMkO704TAAgHjEWZQ31R7PVY+yCGpIgwjWHfs0qn9FuawBp3d69G9ewjzubjrmlzE1seAkQHXscFLdzEbT7IV/oUdIbXXMFeRjeLNoUwtnXLH0K9DCn57ByJ5SsTuiO5qemkEVFkN3UhhR11NpXwdSqYplCoRbTRLWY1qWpluceDG81zAdbkfsBEvLCQlMa2cQEcNTchtQesXMGBzTDycpWkSceOIYU4mSWTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLM9yRqBXUZqMUWYNxgeNFaFZWsPlJ5uyq5WMXVAAyU=;
 b=gE/d2agb56OAs1OdKoV+D678dBZucsBIjCMxunW89Z5u5U4VeFWQAo+W/vHj4BbiE+IapIqHoSaGnayc2N69Puk0voNm4MfSrCotdCywNW9y+d9tS7hFlDJVJo8vT7a6wCAuwF+JtusiTivWz9SsbrgrajqsGUaTZ8R1unXUgpphneMyE9AUbk8Vv4cII5rxgDYSpcHCoSVTIAGNduXQqS78VMLT8SD1Re2iOJ3lafjDK4a+Ublv57Ru40sQkNPD5TtPDPz0peMAr7Ss83Tic992XOvHYTO5jEc+qkS1zpChXIw4XkcMJrD8/HXNl86OSQ/Ulfved9K3JtH/TKAAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLM9yRqBXUZqMUWYNxgeNFaFZWsPlJ5uyq5WMXVAAyU=;
 b=vDD3PSRUZQwrMFYNKhWgRW3A6+iu//XAmFgjomP3QSFmnszYmZYfqx6CGYAa7CIhZQH7g7E+j5e7YNbl5gFH7aYFUtzT62oTIS2K58NyfL+suVhjO6yqnqR0uThVn/sEz9DveJdmXtTfGbuGUVeopGzEquOr7P5/WQBL/Fn0Ixk=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by LV3PR10MB7981.namprd10.prod.outlook.com (2603:10b6:408:21e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Thu, 22 Feb
 2024 13:33:37 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ad12:a809:d789:a25b]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ad12:a809:d789:a25b%4]) with mapi id 15.20.7316.018; Thu, 22 Feb 2024
 13:33:37 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Wang Yugui <wangyugui@e16-tech.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable
	<stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Thread-Topic: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Thread-Index: AQHaZMosErCrmVQv8Ea35daH6PkOiLEVXmkAgACEUoCAAHJbgIAACMSA
Date: Thu, 22 Feb 2024 13:33:37 +0000
Message-ID: <860C9F04-068B-4D29-A6D2-D6F4773CEC3C@oracle.com>
References: <20240222061911.6F1A.409509F4@e16-tech.com>
 <2024022213-salami-earflap-aec9@gregkh>
 <20240222210204.4F83.409509F4@e16-tech.com>
In-Reply-To: <20240222210204.4F83.409509F4@e16-tech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.400.31)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|LV3PR10MB7981:EE_
x-ms-office365-filtering-correlation-id: 94d5818e-27c9-401b-4c46-08dc33aae010
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Dss8YIFjtlXrIwcpDfJgQHUjsZ5mwldDFf2uxNxqvw76v5x9wArLtxxwF4o1SKMc94f+8N9mzz5wJfqhBPxifK7fW4dcZrf0mlU4OHmjxxc9otPAj6sc4j5t5pfDAmWIsqJhvS/PlfBG9Y6WNo0AKxa1LeXWLYRsNpbxuk/ihbyCDRg5G7xnFIkAj0y7V5qf1LkjTZ3IMVqEa0p8QMXKUmfFuvIjMCaIJieME6tcMBQ6OdeUCflbu7nKYdYhXI0MmCvbr1KXMaE0aLOc/W5QIAucToeX0OwKxyh7NzoKwkUgp39qIPZ0cyHH3IUwti54D0gc+SpJUy6dbGQCBenYaX1zDubIc8oqbtl/rh/kpk0mpbVA+zdzPFpjhdBCf/t8hxY40CyyMfHQUqTqI7ploX9N3wD/tl6GbWmSKFCoFMWyy4KCnHHfeltSlztLaNYU8LvFdh57vnO1a9BjpQjRAUtrm99JvBbtH+3MKH5gI/XwojUL/d/0q4MFWaEVSodlbAqZNDKcniAwsfCjzL/JCmbrCwK8JWsNAWg2JESjJIctJDw5YB3ckKyAzJ2KkCKHFtx0GeJ4Fqn8AucRrvVhOxWI+Y050QF6tBNjH609YwgKbB5QA6B8G952j526Qy+U
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NmFsc0pwTVRoL0IxWWRNYlJxVHFadjAvTjdJN1JGNEd2VDIvR2Jpa2dNd1VC?=
 =?utf-8?B?UGovNGJzV1ZaTnJvczJnTjgyMDdBeWdUd0NTajBiMHdDYThNbFBQbjEyUzF4?=
 =?utf-8?B?dUYzYytNUHlJWmoveXBJSzQyUyt6S1lWWDBwS3dSanZSMi8zY2RwN21DTktW?=
 =?utf-8?B?TmdHTUZSbzlzNEJoYzlqaEFldEJVQ1AxMFlNbkViOWlqR0VCaTgrRnVLL3ZW?=
 =?utf-8?B?Ky96eDZqb1Fmd0ZqbWVNWmJoWUp2Qm44L1BzaFU0RC9xRlNTMnhVR1FicWxU?=
 =?utf-8?B?bmU1QlE1b0JXL3NEdjhuL2FqZkdrWHBHYzg0K0hVMWpsZVNSQ3NNS2hEQ01s?=
 =?utf-8?B?cldBMTI5UC9kTlFwRFgwYTdSOVkweWZBaWdSRlFkTTYrSDdJY2c2Z21Qdm9M?=
 =?utf-8?B?anJ3QUtUc1VPRGxLNGkzTEkwdkV2NDFmZkcraTQxVkIyRlNySHc2NGlNOEh2?=
 =?utf-8?B?bTkwQksrRmtJekJpc1pOMCthamlCdXRaQ0FudU9LN1ZMYzNuZjNFYlhSOGdq?=
 =?utf-8?B?aVYyRE5QUS9BM1lobTdPZXduVEc1MmtCUHRxNFNVdm9kMlRRTTNnYnArK3p4?=
 =?utf-8?B?QmNheVkxRzE5NFQ0Y1hTUDJPQm9rVG0waEtZVkRwUHFuWi9wVXU0YWRSM01U?=
 =?utf-8?B?ZmtjeXl1S3RKRzkrSVNRWVl5YkJDL3d4dlRJSWU5Q2xjek8rc1dxY0Z1Tkto?=
 =?utf-8?B?RzJWSWR0MFNwc1hVQm14V0V6Z0xpRk02ck9SSmNGK0Ywa2FJZU9wcjQ3dW00?=
 =?utf-8?B?Yll3Tmpoa1BhaWZydVF1VGZTNllSQTV5TGNjeWZ5cDhPVS9Zd3loMHFRYnNk?=
 =?utf-8?B?S3I3bjRDL3BsT3B5L2VOYmt0MmdxUFkyUmpnMUc2aENkN0c0UjhteHVQVE4z?=
 =?utf-8?B?d2o4ci92alhmYjNZNWowVHV1YlNzQzBLZlNyZlYyTUg5YTlYTWRqdEVvUGxD?=
 =?utf-8?B?c2hKODZzNEtUOTNiS3kvbXdiVXROVCtCMlBoUTNsN0MrMCtNNERXUWRrdC95?=
 =?utf-8?B?bTRzM3Vya0hha3R4OGkvK3JRalhTWmwrek9kMWlnVjc0YUsxU2VqQ1NkNVpI?=
 =?utf-8?B?NTVJVms3b0IzNFg4dTdSWXI3UThsTUlUUHFOaXgxTDBDSTdnYVpINVgyZmVM?=
 =?utf-8?B?STkwekpBTTFDZUNIMjhmTTFZTGUyZmxCa1NXeUJyRjdaSW9yTUVEb0dtWDVi?=
 =?utf-8?B?UnA0bVBMTWd5UU5KdFdTa2NxczJqRk5TYXVJLzcrVUF4TEhWNEl2WjBQbG05?=
 =?utf-8?B?Ni9samlwblIzVjlyUm1kWHRqOE5WM0IxN01OU3hnOTl6U2lmZG8wZGc1WWp5?=
 =?utf-8?B?QkJSa2pzLys2cmxMelU5cmMxNytRak1aQ0hLU1ZyTnRqYTRKYkFyQ204NUdY?=
 =?utf-8?B?MlMvM3JJN2hISDV0Vyt3VjZXT3VKaFFvaGp6SzVBWTdmdGJXWFYybWladEFW?=
 =?utf-8?B?elN0U1BvODZiQ3RwVzlBUHRlRHdnOHNKMzgvbDVRSlRCMzlva0ZsTm4vR0cw?=
 =?utf-8?B?bzJmUDFOVjRCL2dKTSt4dTZLZ2xlTUh0NFgwR1puVVRjWmV6ckVhYWszZ2p2?=
 =?utf-8?B?WnJ2WWRxSkxBTG5hQWx1NGxpMGtIL3pQb2lMRS9Lb2NzdXhvcEF5SWd2SXgw?=
 =?utf-8?B?WVB6emFwNkhTQndoOTh0YXFIeVN3bmhEK09oKzREdStoMHhWVHZJbzVjSXEx?=
 =?utf-8?B?R0lPdUNhaEZ1TnVMVzZxdDRmOC9BclB5dEMxZm1oK2p4WTd4NnlCZFFvaTdn?=
 =?utf-8?B?d1NWNlRrTnZLUEFodlhNOTVNZEJaQUNkSXlkRXh5Y1JPTXBzYzJzbnNnVXBx?=
 =?utf-8?B?VzI5akFNUFdtd2ZZSHkzaWRhZmw4aElBSU1IaHBPbHJRK0JBMmVRSjBnQ3B1?=
 =?utf-8?B?MWhQT0UrVDZ2MHFUR3QxZXhaU253WWdjR0RaLy9ONWVjUVM0UnIwZmVxQzBm?=
 =?utf-8?B?RjMrNFdtNitBbFQ3R1hVWmdUY3I5bngvd2I0bmZqTGVtMTBBZkNkalhFekxI?=
 =?utf-8?B?b1E4RXV3eDI4djdTdm9zakE5cS9KTkNVMXdxeFRwL25EMmlFUEhKK3BJVXhS?=
 =?utf-8?B?UDIzNWVNdmxBSXdnblRTUitVd0tOQlFyWnY4WWE2WlRycXJGd01UZUorWCtv?=
 =?utf-8?B?VERUdjQzWCtnQXgvSzZpc2FRcEcxQVpucy9NSHhFYjBlZWVseUwyci9FLy96?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00CA665C36543E4A877BD0C83EAFC974@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	hDa1u30oof0kGgT6mwmCeIxnD35II7gdDrs7rELJmpm0w0Yl8hZTn7msffOfMS4ixRUgWwo/a7d1pyk0NdShPnpGzjR1bQA782gwC0csaHdinvFSaQQKIDhCjaeFPsXbFMHK/3XwY17wu6hSynPdmZgGvooghg4mYj39qrEaKWpIe5lz4drKqg1llvI3zzboS1KkZt8D0vALTaEhQTdFf8gdVX0HzD3RfT4B5QzRO1Zu090gZ9Nkq1kirPVXblnn28Ltg37FuI4IX/RQjwJi9sf9EtQ9GUp0vaGSug+wCae+zfV0p9awoYJ6pSqwhTAwIJq7vXKaMV0z0XZr+Xk+wenWJpeSIf/snZdWRjg4ltaUcGVk0oJbbDVxVYHuobPVsNUpKh1EbTqHQGPKnnOGs+coUD07tCx4zlqiv98ZoyGuPj3lTIXOySnPMNNn1xso/JjYi44xFD52orypT/yVLqzuhO6iCRwuQqi9Sp7o7gtZZLFPVCsj4I3r71Um6ir4YLkSFnkdw1Ijhqn2HTDed5JF4CsRI01u43RjHpkrL+n07zoPJAj+MNCRQsvXLVCYzxPgOJ+e/4tIZQPH5TcOeV3F1uofDa5LIxe+4zsI84I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d5818e-27c9-401b-4c46-08dc33aae010
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2024 13:33:37.5973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9akEGlo93BjkT6JZYln648VNPf9MFkgtEMZzPbiQ97Fa3BWoeiirQA/pZBpR922O/BHivlo1/CFhuGpuFFG2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_10,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402220108
X-Proofpoint-GUID: 21P1BZbD3hMKnRMYECVucMtbiBLhiwWg
X-Proofpoint-ORIG-GUID: 21P1BZbD3hMKnRMYECVucMtbiBLhiwWg

DQoNCj4gT24gRmViIDIyLCAyMDI0LCBhdCA4OjAy4oCvQU0sIFdhbmcgWXVndWkgPHdhbmd5dWd1
aUBlMTYtdGVjaC5jb20+IHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPj4gT24gVGh1LCBGZWIgMjIs
IDIwMjQgYXQgMDY6MTk6MTJBTSArMDgwMCwgV2FuZyBZdWd1aSB3cm90ZToNCj4+PiBIaSwNCj4+
PiANCj4+PiANCj4+Pj4gNS4xNS1zdGFibGUgcmV2aWV3IHBhdGNoLiAgSWYgYW55b25lIGhhcyBh
bnkgb2JqZWN0aW9ucywgcGxlYXNlIGxldCBtZSBrbm93Lg0KPj4+PiANCj4+Pj4gLS0tLS0tLS0t
LS0tLS0tLS0tDQo+Pj4+IA0KPj4+PiBGcm9tOiBDaHVjayBMZXZlciA8Y2h1Y2subGV2ZXJAb3Jh
Y2xlLmNvbT4NCj4+Pj4gDQo+Pj4+IFsgVXBzdHJlYW0gY29tbWl0IGJkOGZkYjZlNTQ1Zjk1MGY0
NjU0YTlhMTBkN2U4MTlhZDQ4MTQ2ZTUgXQ0KPj4+PiANCj4+Pj4gUmVmYWN0b3I6IFVzZSBleGlz
dGluZyBoZWxwZXJzIHRoYXQgb3RoZXIgbG9jayBvcGVyYXRpb25zIHVzZS4gVGhpcw0KPj4+PiBj
aGFuZ2UgcmVtb3ZlcyBzZXZlcmFsIGF1dG9tYXRpYyB2YXJpYWJsZXMsIHNvIHJlLW9yZ2FuaXpl
IHRoZQ0KPj4+PiB2YXJpYWJsZSBkZWNsYXJhdGlvbnMgZm9yIHJlYWRhYmlsaXR5Lg0KPj4+PiAN
Cj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+
DQo+Pj4+IFN0YWJsZS1kZXAtb2Y6IGVkY2Y5NzI1MTUwZSAoIm5mc2Q6IGZpeCBSRUxFQVNFX0xP
Q0tPV05FUiIpDQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVs
Lm9yZz4NCj4+PiANCj4+PiANCj4+PiAibmZzZDogZml4IFJFTEVBU0VfTE9DS09XTkVSIiBpcyB5
ZXQgbm90IGluIDUuMTUuMTQ5LXJjMT8NCj4+PiBvciBJIG1pc3NlZCBzb21ldGhpbmc/DQo+PiAN
Cj4+IEdvb2QgY2F0Y2gsIHlvdSBhcmUgY29ycmVjdCEgIEknbGwgZ28gZHJvcCB0aGlzLCBhbmQg
dGhlIG90aGVyIG5mc2QNCj4+ICJkZXAtb2YiIGNvbW1pdCBpbiB0aGlzIHF1ZXVlLCBhbmQgaW4g
dGhlIDUuMTAgYW5kIDUuNCBxdWV1ZXMuDQo+IA0KPiBXaWxsIHdlIGFkZCAibmZzZDogZml4IFJF
TEVBU0VfTE9DS09XTkVSIiB0byA1LjE1LnkgbGF0ZXI/DQo+IA0KPiBJdCBzZWVtcyB0aGF0IGF0
IGxlYXN0IDUuMTUueSBuZWVkICJuZnNkOiBmaXggUkVMRUFTRV9MT0NLT1dORVIiLg0KDQpIaSBX
YW5nLQ0KDQpJIGFza2VkIEdyZWcgYW5kIFNhc2hhIHRvIGhvbGQgb2ZmIG9uIHRoYXQgb25lIChh
bmQgaXRzIGZvbGxvdy1vbg0KZml4KSB1bnRpbCBJIGNhbiBnZXQgdGhlbSBwcm9wZXJseSB0ZXN0
ZWQgd2l0aCA1LjE1LnkgKGFuZCA1LjEwLnkpLg0KDQoNCi0tDQpDaHVjayBMZXZlcg0KDQoNCg==
