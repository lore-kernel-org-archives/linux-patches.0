Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AF417B516
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328424; cv=fail; b=ayohCL8qurpWAlFRNdVHRIXhSpGK7/P2FYtQrNhtJCxzotc6kXabKuRmfz+2R4aAA05pDfCvl3AOfmw3OOPMbCzEg4/5qjAnaxrVuk+JQsakDGEUxYl4LO1EAWQuV7TAXVqYCyr0Bao5wlIWZ2iIEwsG/hHZ6hUizEMV8nMJolU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328424; c=relaxed/simple;
	bh=+KTYWq8/vYSc4c51lXckshUrns1dOk8SQ+nk3IASuic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pQ3/tH7HnhaSQvA3ph625L1UZsI0M4COC6ZzJE+ACgwHDNMxG0qivCV2ZKELVJ5UVh9kLoCGVUjWCGkAUMvDaavwmiKQxGWp+H35rrRbX1S530V4CRPZxZ0oMEOoMs3eKJE5SclK/1wLVpu4SXk+mqOWunE/ZhJdoP3LRNPt9z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R+0gg2ia; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b4lF0ebo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R+0gg2ia";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b4lF0ebo"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45PD3X3A022210;
	Tue, 25 Jun 2024 15:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=+KTYWq8/vYSc4c51lXckshUrns1dOk8SQ+nk3IASu
	ic=; b=R+0gg2ia4l6Id+saYijziCt3/5ov4XHAWIGg6uSxxZ+SLDLrEpVXxszRU
	5/tdpCKTkAahUSdfJvmbEccWIcYWRZl8o0k5sEHPxNE6aXo/SUYUeBeYQDDFXhk8
	Z1cK5MUdh/5hV0WlJ/0ooIpvoee41lXROY4LVsBsIDj8mqwJZ67P4b83GxT0GDWd
	E/6gjKBtcFq6PV6UfSXCXW1UWK5mbr3wf8d5dQffEDYGjrG/7PS3H9D+XyFJ3bWy
	Sv7m4rZhUM6QbowzoR8gR601MtUV++G0lVzheRKSAHRTiXmsufoUABA10jjVc7/N
	5yMMiqclli7paJGQMuy5uPwDc0DUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn1d0vnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 15:13:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PEUeau010744;
	Tue, 25 Jun 2024 15:13:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2e71qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 15:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g86BtFE2A5zVerIDepSw8r+mePcR82b+MHzeH+G5oKBy9ewD1/NlHqO13bsAx/I12zsRspw/9bRVp+Dz81GKfIKlvzmlEoYudkBoIANAM6lRjIA20KKMAZB2UUtx+IjJmwsy/Uy1rvIW4w5o/LDpaOCdi5y3JkisTemcL/f8RzcHK9+szvWKRUwvBXIwDB4hcs6pxR2QEGDu3Jp9tj5py9R7m//uWSJLu0jKnEel4isEE+K/M5NIJ4tBwiniX3bn+NiNGetfsgTIHJLRimwaDKok5XEkq1BlHFTsEnEMgAMmMyM5OJP/4oA+iKisPIlWt9pbKE7Bgp2cn1We7YhRcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KTYWq8/vYSc4c51lXckshUrns1dOk8SQ+nk3IASuic=;
 b=ocWUN/jzBpMV0IkOpmjtfos465yxGuaixmc7Z4Drlh8psLYm6a05Ypq+ibeck1Up5rLs8XuR2V27hHe3QP+i50iaZFCIyrEdAKSK1fp8KXU7NZfqcLcueaaSZQuDF3/Uy+kQsuJ43c/nNATaSSLMzcrf4rTQ7fs4Ayxo3LVfakWcIjwQ1THnucFd6fHM664LtimYXKQfsWTdYK3sGf8XCCVVddnOIbNUrJj8duJ0J48sBcDAg4nRJ6ZW3PP4IBtvH3Gi4ulv/AKV/BIP4gxBlQcVQuDoqNBJpq10DB1ATRS+Fwkc4jFgDAZJEWbk2HjDbjtXKv0Y6dK1by47Xy8I2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KTYWq8/vYSc4c51lXckshUrns1dOk8SQ+nk3IASuic=;
 b=b4lF0ebokHeYWSMYrtPvAcjBL+Z5Csg5om+79rgjMBz7y51Et+4n+zaArDO9yjZCduBVfzmW1ARpOF/OjOxvVzzscUkWjAVTf5iJV/A9oAEEqchmvf/yR3dui8MYVLPbj+HGpHNAQpecRH4dgu023OujSnHuiznmqLbE4jmT2HQ=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB4822.namprd10.prod.outlook.com (2603:10b6:408:124::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Tue, 25 Jun
 2024 15:13:26 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 15:13:26 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Guenter Roeck <linux@roeck-us.net>, linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHaxxD2v5qwy652GEusd9rXWc6iOrHYlkYA
Date: Tue, 25 Jun 2024 15:13:26 +0000
Message-ID: <EEE94730-C043-47D8-A50A-47332201B3BF@oracle.com>
References: <20240618123407.280171066@linuxfoundation.org>
 <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>
 <2024062543-magnifier-licking-ab9e@gregkh>
In-Reply-To: <2024062543-magnifier-licking-ab9e@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BN0PR10MB4822:EE_
x-ms-office365-filtering-correlation-id: 0454c478-5c70-4753-14f9-08dc95295d1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230037|366013|1800799021|7416011|376011|38070700015;
x-microsoft-antispam-message-info: 
 =?utf-8?B?RDJqWjJyVWk5emxjQXRWZDU2OVFNcDJEWkxHcmd3bmJlR1RtVkVZOWlaUGRx?=
 =?utf-8?B?aFRLYmFtR3FsYVJ6UTl0ZGhRNlFNUmlyeWkxYVVLbmlKRXR4UXdoTW5vN2pJ?=
 =?utf-8?B?TlBwN0oyNjVMZTZ4N2c3ZG80VjRrUHh2ZHQwZW0zb29FMUE1YVJLQUZTWDBt?=
 =?utf-8?B?ZDFvV2pBbHpmbGtoUEoxNUVuWGtBc3RhWlRPYldoWEtpODlWMnNqejBjS3Vs?=
 =?utf-8?B?OVdVNGgxRUYrb1RBOGp3dVdOMkZzNjZ0SVIrNmdSNk5Oa2pLRlRyVnpERHB6?=
 =?utf-8?B?dEpZSlpWOXNxVXRsTUpWV2tFTFJMYVkwbWw0d0V3NFFXWGhDR3lNd0t6NzlS?=
 =?utf-8?B?ZXN4a1drcG1JalBnM1J1OVRUd0Z4djB1bU1sTENyajdoWmVoWXZVaS90UTl6?=
 =?utf-8?B?Zlg2bDhnZjIzeUlqN29Cb3NqT0RFSXR3ZDY0dk54eXRLeHB0SjBOdEErakUv?=
 =?utf-8?B?djZZRk1OMi9wU3A2U0JBN1NPYXVpOVQyVGplT2JhOVc1aEtLOHJSNTRRTVpO?=
 =?utf-8?B?aElwbkxQampmeTlXaVM4R1NqcWJ2b2hiREVvMmJMTjJveDNGRWI0Y043R1FH?=
 =?utf-8?B?QWswWnFEMU5PWlVFR2h5bEZiWkEyc3pLN1VYZXFDaW5EK3RtbE5pNnVBcDM1?=
 =?utf-8?B?NVUrdEZCKzNmVVREV3VTdk9LM2dZTkRhNXgzdURPRGltQlBOc2xCcEZQemhH?=
 =?utf-8?B?RXBwYmNKd21HaEZ2a2NnNHBHdGZ1VVl0UWdLd2lDa1dvZGVmeFZNWHFnVmI5?=
 =?utf-8?B?bktGTlBzL2pmUG80bFFDMkxxYjBZVi9zVkZSa1pDbWZuY2ZKQlNhODNFc1Jz?=
 =?utf-8?B?RVdyYnZDTHhsSGdpRGVFV2lOWmw2akI0RlVldU1OVld2cFJjZloyY2gyRnE1?=
 =?utf-8?B?Vm1DWGhkVkdHREpsZzAwb0krTnVXMCtWSUJwS0ZEbnJGWFlFNnVUdXlCRE9u?=
 =?utf-8?B?c3VMZndtRE8zS3NoWnVYdDhrWWhEb2ZJRG9NT3VZcml4cVRzVE1hQXlLb2sx?=
 =?utf-8?B?RjlxSmpPeUk3bGdkUmp2WlVpZy9PdVZzSkkwMHlLRUtlQTgyQVVHd1lHZU9L?=
 =?utf-8?B?VFVnZ1BaNUo4SnF0bkRMR1NIaUlpUjRGOGlRM2Jwc1dlc2NEMnZZMnNSTWE5?=
 =?utf-8?B?MnpYai93VGYybWlLdW1qWk9GenBDa3pXeE9DVGZiOHlBcGxCeTFTc0ZrcVRz?=
 =?utf-8?B?ckphWitJd3lyWEp1dXkvakxkMUNrTGdoL0J2QzVhaWV0T0EwQndNRjhMeDdq?=
 =?utf-8?B?blFqQ3ppN0M1QVlFN1NrLzlLUXZDTWZYRHFVcVB2bENPOVRDUHZkczlnT09B?=
 =?utf-8?B?M1E5R280YXNseWo3dzZ6aGUrWFpPSlRzTFRacEVydGdJVzY1bjhaa3R6TGpi?=
 =?utf-8?B?TGRYcWU0czRvbmJ2TmxKOWZyOVBLVUhVSldsUE5CdFlDWXRYS2NPck1WR0Za?=
 =?utf-8?B?QnBPQi9sYTA2eG1MRzcwNHNRSmxSOXBnY1M3aTBrSU9CWS9tVUlSVVJIM0pm?=
 =?utf-8?B?Zk1vbG9SZ1M3OXZNOWpGOVNyaS9BSnVNaUoyQjlTUEI5UHZKT1hTaDVFZTRx?=
 =?utf-8?B?VHoxUDN3dlZGZkxlZlNFcWIyM3J1SXZpeGJTbnVVbllFWWkvVitlV1R4VVU4?=
 =?utf-8?B?QlV2MnNiR0hQaEZDRkJ1ODl0NjZJVmtlTDBROEsyd1dlbzJOak4wblVlemha?=
 =?utf-8?B?R0NHMWVwa3B4ZjJyZDVxSk92Y3R1eGFvUjkzcVJyMmxFSUV5ZFFyWTJRUEgz?=
 =?utf-8?B?dlA2REFhZmE3Q1FOK2xPcDNZcXJPdlZjRksxTWJhaEk2SFd2RllWT0g4dXdE?=
 =?utf-8?Q?TULutd+Pgwx969jj87B4zB7D9BCTSWWtpzpTs=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(7416011)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TmpnQ1BydXdFZkJpN2oxakpvcHFURlROYStPQ0dhZFFLR3A4Nlk1a09OdmhU?=
 =?utf-8?B?QkVhRmFvZ1d1SStPK3g5MWFQQlhnMHFBb0pvWVZxKzJBenh6OXJ4K3VMempP?=
 =?utf-8?B?NFJldGRoeHhGTkV5eFMveUk2M0tPRHZGVUhYNi81bUZudDMrL3dtempkVmZH?=
 =?utf-8?B?MlBCZm84OG5JSWJIN295RHNuTnVtc3c3Rm82Mm41SkdCditEczQ5TGQ4Qi9a?=
 =?utf-8?B?RzZ2TDI4RGxWVExkYUQwZWxaZkxnbmRDS2NrT2ZIaGcxeXluaGVhLzRaUUJi?=
 =?utf-8?B?eDRndlBEQlVjcnJwazJRRnZmWkxrcWZaSTlrbzNHdkFmT01mR0hFelRCSEdj?=
 =?utf-8?B?TVdHZUdtS1NlRlU2bjNNYW9qQVVhVTBjKzhGLzlTUDZKUkdybVYzSnk4RU5u?=
 =?utf-8?B?YzJzN1JwOHdmV1B5cURVU2hiWEVMYTdFTnlHb0pwd1Z6SFltVzd6c0pZc2lF?=
 =?utf-8?B?Vk1XUy9QRGFyNTBrVkowWTBSbWZmSS91VDVRT29TSGEwZS9kVDViNk85N29t?=
 =?utf-8?B?NEVPUDJEVmgzdmF1cTZJWW84bGU1cVhvTmNBR2cwYW9vV2lnZEduUkZUTVRD?=
 =?utf-8?B?YVZ4SmRUdm9MRGwza24vV3B0YVlVeVVMWFFvWTRlblNWU1Q1eEZXR1hOUS8r?=
 =?utf-8?B?bFlpMUc2U3lLYzBORDFHM1A5aC9BZzBqZEFRaEhiQU1jbWFaUEx2dVdFMG5x?=
 =?utf-8?B?MGNUZmJCaTZlNHRudG1SLzBTY0t6QWVhMnI3a2Q2S2VVeWVFU0FRNCsyTUd4?=
 =?utf-8?B?K2owb3RsRDZEWHZxUUFMcFMrOWV3Rllpa2dpTTB2emxzeUpRa2Z2U1hDYkFT?=
 =?utf-8?B?UXd1alc5ZzcrZG5yMW5JNU9rYS9MTUlBVSsxeS9XQjhQMVU3V2xCV2l3WFZH?=
 =?utf-8?B?RG5LYkQ4bitjRnVsNUlOaGN6N3Z4TlcvSTVpOVV0NWFLUytaRjBNODBxb3pP?=
 =?utf-8?B?RUxUbzF4ejB0bkZnZkRZbldQaWFxcURHY2tCcVkxWTh4d2ZENk9BSC95WXJI?=
 =?utf-8?B?SGZlQ2wrMEsxek1zN3RVTVJqZ0UwN05pWUFvQXhRYy91dzl4MTNNVVM4Tzlt?=
 =?utf-8?B?RWlvUzdpZ1dUS3hnTVFkK3N1UHdXYVo4WnN2dWVTZDhtOHorMW5Ka3Eyd1pP?=
 =?utf-8?B?Z3NVL25Qd2k5M0hMamI1T1dHblRBbGtoNWZmNnJFbEpQS0lYNTN4MDFOcGNr?=
 =?utf-8?B?RmlYdUgzQzhVeFlUQnU0VnRoWmtRNysrWWRuQ3RKcG5oYUVMMjVQek4wMlpl?=
 =?utf-8?B?SS82K2tHd3NFZ0MxY3R6MHFMYVNzOUxaMDlIMCt2aVJacUdiVnFoV3M4VDBW?=
 =?utf-8?B?QUw4YzJYT2RpbTRjNDNDSkd0dit0VUVrekZGTVlWN09wbHhWK25kbEVYTlVy?=
 =?utf-8?B?U3NYWE9KUkVvZ2VFcWxlaHM2YVdpeE1KR1duaGF2Ri9mUWlGYWRhNFhtR0NO?=
 =?utf-8?B?dTFrVmZoNUg3bGJMNmZ5Wjd0UlFJTHFTQy85R2ZOSWtaQTl6UUY4NGZKUGtZ?=
 =?utf-8?B?NHVjU3JmWlk3amZ6Z0FZQkJsZGFEN3QvUjRkSlJzWmQyUHVvNExnNktNWkhU?=
 =?utf-8?B?U3hIMXIvVXdrMnJRNFI2eHBkTUY3MC9PZUdFN1hKL09TbWE3UXRTS2xLeEw3?=
 =?utf-8?B?b01GYXpoMUZBMjVvSVArWEZtSEZPMUExUTc5MEsrYjFCS2ZTSUV6QlM1VHFC?=
 =?utf-8?B?aGJsdHRpQUt5aVJlUjhVLy9PbEpJRGhzV21MQVU5dUlpVjMzSjlpTVRTcEhk?=
 =?utf-8?B?TG0rUThvc2JGd2lJdjl2Unc5M3NEbTZkczNEMWQ3dzZqbTdPakZva2QrTm5a?=
 =?utf-8?B?cmhONW1oaTFxTDdDeTZOTERuT2V1ejMwRmVWZkhLZ0ZXWm82YW9na3JQOUVT?=
 =?utf-8?B?WmVrNCtZOXBZZVhhQVViQWh1QW9rcE84VTNuM2EzOEVMUksxcWpmaFNMekly?=
 =?utf-8?B?eWV5MlNYdXkrQXdJbkh5TUNCcmk5dU9NTGVmaGJuRnZZRlpnZEpwc0xxNTNk?=
 =?utf-8?B?TE5nRkpDenFYRWFraFJsYnpaTFJIckJHOHlTSzg1UEJlSngzODM5M0FkUjVG?=
 =?utf-8?B?Nnk4SDJ6VzJmVFhUd3prQjNRQ3hzbGFkeDMza0FKNklESHJjenZaUEFkTW9u?=
 =?utf-8?B?ZjhpeW5OdmV2UkxCTHdjKzVLakxkckk5aTZjUzdJNGZRUXdWSzVyeG96SXRP?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CAD746A0C976A43835964A13F35FFDD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	k3mnnvYWdV7CnBVnqp9OufQVFFK2IuBve06JiOEIyzC1ncw5IzL9OGbwBoUsKoRf0O6uVCqwH1XS1mrWBfQyn5ctAvOgojgmLyWJznwFwLBzX9YnbIzrw9Ihci6gwGO2Ok7Q09WAUs55uwMjBaIAh/PjaGIti8KOuoiAj2rnfpY73fVwd9Neoo/pOG8ck7jOGFxEwGZvEqJBnl7MD4y2Vig02K1p6l/DNZGYvarxOQLkVWvv6ysTZvxgCDp7Z2s4Wg+ugMqTPnzLq55ljY3qBs6O1opMj6I8ItYOEbu+hP81N5pB8umUPsZVqZjdqz0KxVtX1qgQMV0g7ZGVGF1Pu8Q0OMRxYiI8tCeKKPQ6apQQEnlJsfn/yROFDOpzpWntA6tgfK0MCrEs10cHpEl4WsuLrsLr3LloQNyweAmxNT3vhS/14q3djdj2P6lEX1q2/ITdH3RoFC2bhuIjqLhZkAe/VSFTOpsbPLrQ3VP0rtQn+SCVIh2tSSL+njWeXkRNGQUAgbOwOyZ0Kfw1iL5VNtronle8oaDmh276BJZN0vKNHl8irFhpfS5tiZ9Z8J3JtITFmviLFgEkVMsEmY7Yh3Gal6hQ5si9dfQMwFsGS3U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0454c478-5c70-4753-14f9-08dc95295d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 15:13:26.7835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DL6CEi8X2pv9BXq2LWBbrTxYLP09fckmPcRlAoiyhO/Le1brtuD0oJgUnhpegtESdetPEg75o5+TXW/Cw6xFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4822
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_10,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406250113
X-Proofpoint-GUID: ysO_fr2drNcLGYEv5NJLhPkfhDXB5dSp
X-Proofpoint-ORIG-GUID: ysO_fr2drNcLGYEv5NJLhPkfhDXB5dSp

SGkgLQ0KDQo+IE9uIEp1biAyNSwgMjAyNCwgYXQgMTE6MDTigK9BTSwgR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1
biAyNSwgMjAyNCBhdCAwNzo0ODowMEFNIC0wNzAwLCBHdWVudGVyIFJvZWNrIHdyb3RlOg0KPj4g
T24gNi8xOC8yNCAwNToyNywgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPj4+IFRoaXMgaXMg
dGhlIHN0YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUgNS4xMC4yMjAgcmVs
ZWFzZS4NCj4+PiBUaGVyZSBhcmUgNzcwIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMsIGFsbCB3aWxs
IGJlIHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+Pj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFz
IGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4+PiBsZXQgbWUg
a25vdy4NCj4+PiANCj4+PiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgVGh1LCAyMCBKdW4g
MjAyNCAxMjozMjowMCArMDAwMC4NCj4+PiBBbnl0aGluZyByZWNlaXZlZCBhZnRlciB0aGF0IHRp
bWUgbWlnaHQgYmUgdG9vIGxhdGUuDQo+Pj4gDQo+PiANCj4+IFsgLi4uIF0NCj4+PiBDaHVjayBM
ZXZlciA8Y2h1Y2subGV2ZXJAb3JhY2xlLmNvbT4NCj4+PiAgICAgU1VOUlBDOiBQcmVwYXJlIGZv
ciB4ZHJfc3RyZWFtLXN0eWxlIGRlY29kaW5nIG9uIHRoZSBzZXJ2ZXItc2lkZQ0KPj4+IA0KPj4g
VGhlIENocm9tZU9TIHBhdGNoZXMgcm9ib3QgcmVwb3J0cyBhIG51bWJlciBvZiBmaXhlcyBmb3Ig
dGhlIHBhdGNoZXMNCj4+IGFwcGxpZWQgaW4gNS41LjIyMC4gVGhpcyBpcyBvbmUgZXhhbXBsZSwg
bGF0ZXIgZml4ZWQgd2l0aCBjb21taXQNCj4+IDkwYmZjMzdiNWFiOSAoIlNVTlJQQzogRml4IHN2
Y3hkcl9pbml0X2RlY29kZSdzIGVuZC1vZi1idWZmZXINCj4+IGNhbGN1bGF0aW9uIiksIGJ1dCB0
aGVyZSBhcmUgbW9yZS4gQXJlIHRob3NlIGZpeGVzIGdvaW5nIHRvIGJlDQo+PiBhcHBsaWVkIGlu
IGEgc3Vic2VxdWVudCByZWxlYXNlIG9mIHY1LjEwLnksIHdhcyB0aGVyZSBhIHJlYXNvbiB0bw0K
Pj4gbm90IGluY2x1ZGUgdGhlbSwgb3IgZGlkIHRoZXkgZ2V0IGxvc3QgPw0KPiANCj4gSSBzYXcg
dGhpcyBhcyB3ZWxsLCBidXQgd2hlbiBJIHRyaWVkIHRvIGFwcGx5IGEgZmV3LCB0aGV5IGRpZG4n
dCwgc28gSQ0KPiB3YXMgZ3Vlc3NpbmcgdGhhdCBDaHVjayBoYWQgbWVyZ2VkIHRoZW0gdG9nZXRo
ZXIgaW50byB0aGUgc2VyaWVzLg0KPiANCj4gSSdsbCBkZWZlciB0byBDaHVjayBvbiB0aGlzLCB0
aGlzIHJlbGVhc2Ugd2FzIGFsbCBoaXMgOikNCg0KSSBkaWQgdGhpcyBwb3J0IG1vbnRocyBhZ28s
IEkndmUgYmVlbiB3YWl0aW5nIGZvciB0aGUgZHVzdCB0bw0Kc2V0dGxlIG9uIHRoZSA2LjEgYW5k
IDUuMTUgTkZTRCBiYWNrcG9ydHMsIHNvIEkndmUgYWxsIGJ1dA0KZm9yZ290dGVuIHRoZSBzdGF0
dXMgb2YgaW5kaXZpZHVhbCBwYXRjaGVzLg0KDQpJZiB5b3UgKEdyZWcgb3IgR3VlbnRlcikgc2Vu
ZCBtZSBhIGxpc3Qgb2Ygd2hhdCB5b3UgYmVsaWV2ZSBpcw0KbWlzc2luZywgSSBjYW4gaGF2ZSBh
IGxvb2sgYXQgdGhlIGluZGl2aWR1YWwgY2FzZXMgYW5kIHRoZW4NCnJ1biB0aGUgZmluaXNoZWQg
cmVzdWx0IHRocm91Z2ggb3VyIE5GU0QgQ0kgZ2F1bnRsZXQuDQoNCg0KLS0NCkNodWNrIExldmVy
DQoNCg0K
