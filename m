Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BC71750
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 19:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719345012; cv=fail; b=KYB79iCbd8tLyw5Tlrt96+4sxOiF9frveppkka7XLAEhYYcFaf2pvol0lfDvPXNiQy22++ovK+32EL8B6rZ/Twg7K7oDH9N6eiTFfqcKb5PRbgLCY30xYwuQtIvR3g40cui8a79SnFWfCaIMCnMuZEORJLjEiRHmuOC9sFx2oLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719345012; c=relaxed/simple;
	bh=O2EQ2yuQmv8Vla7THS0WeFFtltwO1AyH333g1ZEgN2Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iN9DkSrE7QWGAdPGFMqebbVzVu5nwvhPJRzzZ+mEWCEAtCluM9C96g72Pq4Ha7+m1aSZK+E+etJNlRUUcXPuqn7Fsy1F190KWafp8SjqcRx3xI13hEGBW/EtToBAHEjhEbwlgTZWSf9PtzVzGqav4mz80QfiAmoLCCZ1Zr+PULg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AlRGVga8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v8qpD0H4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AlRGVga8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v8qpD0H4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45PIfX5M018338;
	Tue, 25 Jun 2024 19:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=O2EQ2yuQmv8Vla7THS0WeFFtltwO1AyH333g1ZEgN
	2Y=; b=AlRGVga8ZKxWakdwcbHahFIZnVRTRUsFHCav/skcNyjQHRtfEKhRYXChb
	ZR2AQtw0eCqQcq3oIjvcNJoY0iKE7mjiHk3fnNU+S6L3VdALCf1nHSY87b+hGzpv
	jf1Qy+uSzmaHHMXF7chihBB7e/Id0OMi4mPTSS5fanjb/b85BFgCzuoQBu2NPrOA
	olsfd/rlCu6FQ6qgyT+ZtoxUAc3BI6sdcix2zZ0HD9/0zWz3oUzUjAjgtAnI16Kv
	5z7408a0bS3mOYSSMkc/9eGGAtgP/4Zd12RCn1arBORZsWian0HYtvmAOI34sLvX
	sWoboJilBBGkvXWzuBYkyJfHL/KcQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywnd2hpgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 19:50:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PIsvFQ037041;
	Tue, 25 Jun 2024 19:49:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn28h9c1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 19:49:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Md+K1oZeoX4jhTNdnLCqekJ3LuxqNwBdCLPas6PqC1m6bNRKx0kn0rCWGxfeXW5p2yAjc642A0NhIJVdtOo1eL4a8BGL6mwOvxiXoK3aU2IMaZILaF/5xFjC4aZiJHclqFK5QXzW9zeAdtjb8XETEzmOtcMVaO3BqQRv2OzvPj9rYk/88GzXgtiNzCYqc/mSleHJzNdBn9a7itp6pZAFMJKVmrFMADW8ADqqE6BRXNXs7hg8BR5Z/BznHBDhLZ6ZIpfVmwizCuaUJVgyFJ52vPYfyCrAua2ZoM6i8QAw0iv87+z7d/0xYdcI1wUL2txiQnkVIcQTW0Ge+hEtM1d1bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2EQ2yuQmv8Vla7THS0WeFFtltwO1AyH333g1ZEgN2Y=;
 b=fokWQq2UBexblkemvGReErJAwc8V6bUGZeEJwj1PnJyIFEDSZnr2uEyqqSjqWnJEWuHfrQYD46sydaepKEjcj3/JY4NrDZQgHA5nKOK0Z8lCctSAWC5e0MP8oHLtd6H+HwjWpN59RloufQzlTCzS1wircs6AlVk+ypOE612us3taP6fQ2ttvd5d9lI1iRgzwmjQ6vPKrfnJ5eR12nTL14RAwmxSK+KoVP2s4JmUsCjeUPgsvV+mmsJ62RGhAen27HudubDK1g7w2FLyQdD8+KVMo0AcrhW7I3hl5djaQ7zPu8HJEmGemEStZ4jMATXNefk07UuBvUb2t/fy3V2frdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2EQ2yuQmv8Vla7THS0WeFFtltwO1AyH333g1ZEgN2Y=;
 b=v8qpD0H447npsp0eVbrglT8flde8Wmdeu1UnkGdIK8zAuDqi/yz4bGekOTn7zs8l2SBxdofJie7ry5ckYoDhGR6W2DOvmn2mtvccpZG+UQsNBarBibw8rFSqaPyrhAKXss6RQW8sD2iebYoEDVpLvCWNFfv2tZ5fsmSRMBeELtg=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by LV3PR10MB7772.namprd10.prod.outlook.com (2603:10b6:408:1b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Tue, 25 Jun
 2024 19:49:57 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 19:49:57 +0000
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
Thread-Index: 
 AQHaxxD2v5qwy652GEusd9rXWc6iOrHYlkYAgAAVRQCAACyGgIAAB1YAgAABnYCAAAKEgA==
Date: Tue, 25 Jun 2024 19:49:57 +0000
Message-ID: <04BEF7A2-EB38-475D-BFD9-2E6B1C2C0972@oracle.com>
References: <20240618123407.280171066@linuxfoundation.org>
 <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>
 <2024062543-magnifier-licking-ab9e@gregkh>
 <EEE94730-C043-47D8-A50A-47332201B3BF@oracle.com>
 <cf232ba1-a3f3-4931-8775-254d42e261e5@roeck-us.net>
 <B5D1D979-253A-4339-AF15-5DB3B8503698@oracle.com>
 <88a0fdf5-ffc5-4398-88cd-220a3a996164@roeck-us.net>
 <7442B6FD-6EC6-4C4E-A5F7-CDA1174E6DE2@oracle.com>
In-Reply-To: <7442B6FD-6EC6-4C4E-A5F7-CDA1174E6DE2@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|LV3PR10MB7772:EE_
x-ms-office365-filtering-correlation-id: 3f55c297-23e1-4bc1-4034-08dc954ffdf2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230038|366014|376012|7416012|1800799022|38070700016;
x-microsoft-antispam-message-info: 
 =?utf-8?B?NEpuSCt4WDA2ekZRSEZCR2paK0xtSGVmTUZDUGdDS3RBcWVFYURIeTkxYzF4?=
 =?utf-8?B?VjJFaEljNDdXeWJ4N1NZdG42UnJ2b3hyaStNMTc2R0d6R2M4ZUk4SkMrcWlB?=
 =?utf-8?B?UGYwS1dUUnpmdGVzZGo2OHJlRGptamw3TjZPd0hSV0w1V3ZKQnpZWEZ3S1lW?=
 =?utf-8?B?ak1ta3NUM1hOMHQ0UFhBaXJZNmNmcHdvQ2RTYzArbjFWVFdETGUzRGgrODBM?=
 =?utf-8?B?aTdiMmFaS0tRajRrU0Y0MjA1OCtyeDRNZmtvWXBpRW50Ri9wODUwZUxlZFB5?=
 =?utf-8?B?NERQTWhFWWkwYlN4TXc0aDY5OUw1Q2JKRnJadllXRlJBdTU1anpNRkl5YmtK?=
 =?utf-8?B?SFd0ZnRWNi9vMEFFKzlnOUkxM1NYZkhhYmRVQklDQ2UrajZwd0J6d1FTQXQx?=
 =?utf-8?B?RmQ1K3VjSHdlamsrYk9JV2hyZjFzaWR3UmFnZmUvMG5OTkFPSXVNa3RFdnVV?=
 =?utf-8?B?ZXBISUVmaHhQTXY4aXJJQlJHTGZFaUpSQm50b3hxUkJYTGFMS0xRc05vd1RS?=
 =?utf-8?B?ejR1Sk41VCs2M0ZpUFBMRjk5UmZQSkRQVlhCRXB0Ui90REVaZkk4SXNpcjND?=
 =?utf-8?B?NWFRZk5Obkp4VmxGcW5nWWZLK083eXh6S3dSbEtuL0JxNlRRNjVFbzRRby8x?=
 =?utf-8?B?b2hyN09leVAzNjdVeTJwNTlxbytaTlJ1ZVdESGd1K1Y2ci9lZWp2bDRCOXhM?=
 =?utf-8?B?dFVPcjRrNXhncEprcnV5c2hCY01TL280eit3QUJLQUtmSUFCYkVyZ0lKMnFK?=
 =?utf-8?B?WDhha0VRLzIycFdQRk1lTnppaGg2VXRsbnBYZ2RlYXFuTy9lbm9lcEZwSWw4?=
 =?utf-8?B?OEJDME0xWWZPNEx3Z0NiUTB3YWc1MGMxQ09jcXRISGpKKytwNFBMWjFYWExw?=
 =?utf-8?B?ZmNkQThwemhKRldSZThsN282Nkp4bDN5SjNxNVV1TTJSQktjV3F2YmRNWDEz?=
 =?utf-8?B?b1hWVWJUU0JrUGhMWlcybVVpcmkrZU1ZbmsyV0dVYVZRRWo1QlJ3TktNSThh?=
 =?utf-8?B?U1hLS0lnejg5R0dFZTY5aWxta0RuR1ZtN3pvQXFrVGo0TGZ5OHRpMDhTa1Vr?=
 =?utf-8?B?aFFLRjl0L1NKT0Z2Skd1cWhCTGV4eGd4UGZqazJXY1BWaldveTJxUVRwTGxS?=
 =?utf-8?B?TEF0WmMrdXFva3pSTkNzQWxYOEJ4cVM1T3FDMkJabUtWMmY2RlhnZ0hOWkVU?=
 =?utf-8?B?T3RqbFo1cmdZcTdxTldTZ3pZYmxSY2NPR1FIZk5nNEpXbmd2bUNmN0Y1Q05k?=
 =?utf-8?B?bTVTOFhaL1o3bFpGYW1MY3NrK1FiWHhkaGYvVGlOODl0Q2VNN1hzZ3hZbmNx?=
 =?utf-8?B?M1FWRXg2OTR2aU5JWDJVbkJDclVUL1czTEk5ZU9qUm5Ddkl0TWJjcDZkZ09G?=
 =?utf-8?B?U1NmWm9qV2lpTmlKL2dYV3p2N2d3RjVBWU84dGFEZXliL0tsVmd5SUkzKzBl?=
 =?utf-8?B?NWhZWFdmeGJjdVlnbEFyY1g0bFlxenZzVlJiV1YxcmZ5NU4zTmRaWFMvd2RN?=
 =?utf-8?B?NytOdS9UaUhwVi9YQ2tXYXVJUm0vcVJCcjVWVTE4WEltdGJLbWRFZTkrdHVh?=
 =?utf-8?B?VGR6MjV5YXgyc1JtMXd0NnJ0QWcxdUNFK0l0LzJWY25zanR5dlRMelhvakVl?=
 =?utf-8?B?dkJKVzdvU25iR3J0UElWbkJCanhhdWxqOS90N1ZCbnROUUpqeEtSNm1PYlVt?=
 =?utf-8?B?d21vcVFXL3R0VVRqajU4eFZiQWxYdkVFREdoVldUcTJhYVJmekU5bE50R3pY?=
 =?utf-8?B?dmZpMERrL1pXVEFWRDZQcGpqMm12d1hTQ2RDSE90L2txNW9LcFJ0K2tqR3Zs?=
 =?utf-8?Q?zcmsckKwluKnB+X+otgM2X1PXLlzqaBEbe/Jg=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(7416012)(1800799022)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?R21XTGg4OFltaHBVZHpFNDc0THVuOEQ5Q0NVTDNveS9UZWN2a2hCMzUwbEFL?=
 =?utf-8?B?WEdLRVEvTWlKMTlDWURPNURwZVloSSthWkJ3VkZ4OFdScDdTbURwajdQMlNU?=
 =?utf-8?B?M2RLclFOazZkdTF4Rmp1dmNESVRkejNjaW5SMENuTnU5UmNXQ1JCdnVHZHpG?=
 =?utf-8?B?a0lLNTk4STdCdjlIZWUzZXFzNFNhQkxPN0RqcjczQ2RQZ1ZLSm8rSGRSYllQ?=
 =?utf-8?B?Q1lEendUdnQ4MGNoQWRya281U0FGbnhRYUJmQVdxSXVET05LWFJSTkxlbG5I?=
 =?utf-8?B?S2hkU1g1OGh1ZjhtNVEvYnZpTGZxOExGU0c3S09QbFFXclFKbklTcDFBeWl4?=
 =?utf-8?B?WSs1SmlidVRpSXNUSW1zQThPbFVPaTF0a2Yrd3ZSNHpHMHY5a05oc25OSVZD?=
 =?utf-8?B?WEtqWkNkdVBSNkloRFZNNjh6YnNBNlh3YjY1UUpmWnpCaEJhakdNNmgvaTBh?=
 =?utf-8?B?MjR5TC91Y3pYRVVqOFI5V0FRWjlPcDNxdlJKeFJuMHVSbWFPVmVGR0RuaVYx?=
 =?utf-8?B?LzN5WnljL0wyUW5xTThjYVNMbWNoZy9TM2lxU1NTMzFSb1d0My9YcEZrcGE2?=
 =?utf-8?B?WTk5dmFFa2hLNXBySWF2Zi9DOGdaUnBqdHFVOGdoRWRpaGFYVFVMNXFyMkIr?=
 =?utf-8?B?OFlES1lZbjJnQ2lCS3JDMUZXbTlYQyt4TWZaV1ZzMDRZRmFheHR0MEVNYms3?=
 =?utf-8?B?K3F2NklSSitYdDA1bDdYUjQ3NGhHTnV0SjZZUWRaUEVFb0NXQ0J1R3RLeEVQ?=
 =?utf-8?B?WitvKytTUXpEOWJJdStDWjEvTngybStsTlR5bDUrZmVSTlBqcDYzeTRmb2th?=
 =?utf-8?B?cTVZZDlJekFhU1lFYVdPWEZ2alF4eTBWbWpEZ3huWEVMTDhIaVlWNGF1YXJD?=
 =?utf-8?B?aWdJK1VXSHdxb1VtNXVBdGtnMGRQR29IdG1zOGJ0TmlKQkp6QmFRYTkrMVNC?=
 =?utf-8?B?S2l0SU5xZjczaTFRZjlDT21oK3cxaVNyUlU1bHpnYjdpQXU1azhsUGVUSk5u?=
 =?utf-8?B?V1hWRkJDZnZRaUo2VUZkOW1TMGdzVkdPUCt2a2laTThIbU42NExJTzRubkVT?=
 =?utf-8?B?R3RINGVSeGNYMndKRTh5YjFBWUp4YURLekNaNTlrVktJQmpkZEF3alV3MzBR?=
 =?utf-8?B?SUl6ZjNGcm01eGN0MlJocktrdTdiTkVXMlMrMWlMMlNVNHFaQ3hJd2NqNmhG?=
 =?utf-8?B?VEQ3YndEeGxGTjBYd1NnZ1loUVVmRHZQSjhUTVFyZVc5eEpjTlhHYU9YTndm?=
 =?utf-8?B?ZW5FVXM2WmVRcnptclZOTEkwb1BqZWxuZGtJeWpsblZ2bjVrU0RPSW42cXVS?=
 =?utf-8?B?bW16dmtranR2Nm9kenR1c0FNb09uczEzajhVdGJ1aDFXTjVJVHVGZEZTUHQ3?=
 =?utf-8?B?K2lEUG4zUnlscmx1dlBxZEc2b3RhSk15djJ3YkpIYkhhYWxGUU56Yi83bUxq?=
 =?utf-8?B?M3BpeW1EUWtCS0M1R0JuS05aL29ySVgyZEgzVXVtYjlYQ2RiTWFpam5Bam5o?=
 =?utf-8?B?VVBpN3FITU1RMlJPM0wyTk5LaFdNNGduR1JERGpiVElrRzM0MmxjcVhFaFZL?=
 =?utf-8?B?bVI5aGV2ZXl3R2duRGo2eHJkUkJFdllOb1Q0V21NdGt5UmJGRE05bGQzZEsr?=
 =?utf-8?B?c2pGK3ZBT24vU0ZoanduUGlVSks4RzVuYWVKUUpFSVd6TVdFbWxDcEgzWnRB?=
 =?utf-8?B?VFlJTlc5Rjc3T1VCRVdIdDNQQVBHVlVXR0VuQ04vZGtOUUI0WW5hcm1kc2kx?=
 =?utf-8?B?MzREcWFCOEkrakljemhnSG1BditQc3h0dGpSQnVjZklaTXVRR01mc1Q0Z20v?=
 =?utf-8?B?ZGgzN2hDUVEvTkNNM2lIR01kOEEyaUxBbjVlejcvRlFDQ3VoRW1hbWkwcGZu?=
 =?utf-8?B?YmNIZ1N3T0ozb29iQ3pmeUpJKzY0Sy9xMWtVYU44UGVhSm0zaE90Y25pWllo?=
 =?utf-8?B?STFaOUZQN1h2NGtZQTlZRWhHd2lDQjNNakc0b3lEY1BFdmEzejB4dFNFcllX?=
 =?utf-8?B?cEFpaGtpckRIYUxKV2crVUs5aW1kekpBbmgxK1laaStFOUUxaFBFMUFwSlJt?=
 =?utf-8?B?SGZyZzZoVldsNE8wR09RdzdRbzB4TmVWdm5TcG5wdzkvVEJYMHhMU1lnbjhS?=
 =?utf-8?B?OVNxZ1ZLK043czdDOS8wblVVdkorVVo2UkdQQXhMU3ZaNDJ5cUxUREtlQTJG?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F40BB6DB431D3B41AB613700351D33C3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	opte87q8p4H70eRLbrRqFT75uIf1paWdqswIwbiWORCVmViYOEqILml6o6EAGAn/ievhZ3VPP2lgoFI6jOTE90jhSOLYEOzpAuZH1Kpuw383HG1JT+kR6NhainGbU98XU0Lx1rz0JjzYR3ZmMerVigQE/T/OG3ZEn0g0rZvUzmtcSwa3dEpY1isR34cIVEV1U+jIAwiZKbkok3OLjWGLdt+znRl6ikUKWnja2IkqT1SfHpX4r4moHXNSYhjYXgN26G8EnrLyMNDQFVioNCuFBxBivcmFBlhIc0v09uOTlnaL7JzTfHZybCPzNZXqEOPaIK+B4y2lURcYcLstLdnHZDR7hBW90dqheofod5yIFis7ofU3Yvul0d7qqHz8fZRUyOMn4hZnUuA3ow+0zvz0054YfdfJFfFSCZbQ562hJGtgg+UDETu3m/YRXNx1nPUkmy6W9wuXDFsnaL4joQgVr7l+Vvr7Gtm3PgEUAkrTr78bFmQbfR9lg2oOQbjbbMpZ7ewvvNyAWXa8KLwALPoIu3w9/l+JMp89qDxethzhDWQB33YzXK9YTgtqkOmOytLvkOZmUp+nGNRt2joHyXMY1gvlXQv43A3ZjkVN1RdDcIk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f55c297-23e1-4bc1-4034-08dc954ffdf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 19:49:57.5018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6kK2sUvaEo68rPu1FPh6YOm3jYoCwUikIB0+loviRfiN1Lzndqj4ZCUeNHrKxnVmRVffJH08GxtH9NgUb4SQtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7772
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_15,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406250146
X-Proofpoint-ORIG-GUID: ZzbAsgtAmUWUa416BT3DxKBxAT6hzE85
X-Proofpoint-GUID: ZzbAsgtAmUWUa416BT3DxKBxAT6hzE85

DQoNCj4gT24gSnVuIDI1LCAyMDI0LCBhdCAzOjQw4oCvUE0sIENodWNrIExldmVyIElJSSA8Y2h1
Y2subGV2ZXJAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBKdW4gMjUsIDIw
MjQsIGF0IDM6MzXigK9QTSwgR3VlbnRlciBSb2VjayA8bGludXhAcm9lY2stdXMubmV0PiB3cm90
ZToNCj4+IA0KPj4gT24gNi8yNS8yNCAxMjowOCwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4+
PiBPbiBKdW4gMjUsIDIwMjQsIGF0IDEyOjI54oCvUE0sIEd1ZW50ZXIgUm9lY2sgPGxpbnV4QHJv
ZWNrLXVzLm5ldD4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBPbiA2LzI1LzI0IDA4OjEzLCBDaHVjayBM
ZXZlciBJSUkgd3JvdGU6DQo+Pj4+PiBIaSAtDQo+Pj4+Pj4gT24gSnVuIDI1LCAyMDI0LCBhdCAx
MTowNOKAr0FNLCBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3Jn
PiB3cm90ZToNCj4+Pj4+PiANCj4+Pj4+PiBPbiBUdWUsIEp1biAyNSwgMjAyNCBhdCAwNzo0ODow
MEFNIC0wNzAwLCBHdWVudGVyIFJvZWNrIHdyb3RlOg0KPj4+Pj4+PiBPbiA2LzE4LzI0IDA1OjI3
LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+Pj4+Pj4+PiBUaGlzIGlzIHRoZSBzdGFydCBv
ZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDUuMTAuMjIwIHJlbGVhc2UuDQo+Pj4+
Pj4+PiBUaGVyZSBhcmUgNzcwIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMsIGFsbCB3aWxsIGJlIHBv
c3RlZCBhcyBhIHJlc3BvbnNlDQo+Pj4+Pj4+PiB0byB0aGlzIG9uZS4gIElmIGFueW9uZSBoYXMg
YW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPj4+Pj4+Pj4gbGV0
IG1lIGtub3cuDQo+Pj4+Pj4+PiANCj4+Pj4+Pj4+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBi
eSBUaHUsIDIwIEp1biAyMDI0IDEyOjMyOjAwICswMDAwLg0KPj4+Pj4+Pj4gQW55dGhpbmcgcmVj
ZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPj4+Pj4+Pj4gDQo+Pj4+
Pj4+IA0KPj4+Pj4+PiBbIC4uLiBdDQo+Pj4+Pj4+PiBDaHVjayBMZXZlciA8Y2h1Y2subGV2ZXJA
b3JhY2xlLmNvbT4NCj4+Pj4+Pj4+ICAgIFNVTlJQQzogUHJlcGFyZSBmb3IgeGRyX3N0cmVhbS1z
dHlsZSBkZWNvZGluZyBvbiB0aGUgc2VydmVyLXNpZGUNCj4+Pj4+Pj4+IA0KPj4+Pj4+PiBUaGUg
Q2hyb21lT1MgcGF0Y2hlcyByb2JvdCByZXBvcnRzIGEgbnVtYmVyIG9mIGZpeGVzIGZvciB0aGUg
cGF0Y2hlcw0KPj4+Pj4+PiBhcHBsaWVkIGluIDUuNS4yMjAuIFRoaXMgaXMgb25lIGV4YW1wbGUs
IGxhdGVyIGZpeGVkIHdpdGggY29tbWl0DQo+Pj4+Pj4+IDkwYmZjMzdiNWFiOSAoIlNVTlJQQzog
Rml4IHN2Y3hkcl9pbml0X2RlY29kZSdzIGVuZC1vZi1idWZmZXINCj4+Pj4+Pj4gY2FsY3VsYXRp
b24iKSwgYnV0IHRoZXJlIGFyZSBtb3JlLiBBcmUgdGhvc2UgZml4ZXMgZ29pbmcgdG8gYmUNCj4+
Pj4+Pj4gYXBwbGllZCBpbiBhIHN1YnNlcXVlbnQgcmVsZWFzZSBvZiB2NS4xMC55LCB3YXMgdGhl
cmUgYSByZWFzb24gdG8NCj4+Pj4+Pj4gbm90IGluY2x1ZGUgdGhlbSwgb3IgZGlkIHRoZXkgZ2V0
IGxvc3QgPw0KPj4+Pj4+IA0KPj4+Pj4+IEkgc2F3IHRoaXMgYXMgd2VsbCwgYnV0IHdoZW4gSSB0
cmllZCB0byBhcHBseSBhIGZldywgdGhleSBkaWRuJ3QsIHNvIEkNCj4+Pj4+PiB3YXMgZ3Vlc3Np
bmcgdGhhdCBDaHVjayBoYWQgbWVyZ2VkIHRoZW0gdG9nZXRoZXIgaW50byB0aGUgc2VyaWVzLg0K
Pj4+Pj4+IA0KPj4+Pj4+IEknbGwgZGVmZXIgdG8gQ2h1Y2sgb24gdGhpcywgdGhpcyByZWxlYXNl
IHdhcyBhbGwgaGlzIDopDQo+Pj4+PiBJIGRpZCB0aGlzIHBvcnQgbW9udGhzIGFnbywgSSd2ZSBi
ZWVuIHdhaXRpbmcgZm9yIHRoZSBkdXN0IHRvDQo+Pj4+PiBzZXR0bGUgb24gdGhlIDYuMSBhbmQg
NS4xNSBORlNEIGJhY2twb3J0cywgc28gSSd2ZSBhbGwgYnV0DQo+Pj4+PiBmb3Jnb3R0ZW4gdGhl
IHN0YXR1cyBvZiBpbmRpdmlkdWFsIHBhdGNoZXMuDQo+Pj4+PiBJZiB5b3UgKEdyZWcgb3IgR3Vl
bnRlcikgc2VuZCBtZSBhIGxpc3Qgb2Ygd2hhdCB5b3UgYmVsaWV2ZSBpcw0KPj4+Pj4gbWlzc2lu
ZywgSSBjYW4gaGF2ZSBhIGxvb2sgYXQgdGhlIGluZGl2aWR1YWwgY2FzZXMgYW5kIHRoZW4NCj4+
Pj4+IHJ1biB0aGUgZmluaXNoZWQgcmVzdWx0IHRocm91Z2ggb3VyIE5GU0QgQ0kgZ2F1bnRsZXQu
DQo+Pj4+IA0KPj4+PiBUaGlzIGlzIHdoYXQgdGhlIHJvYm90IHJlcG9ydGVkIHNvIGZhcjoNCj4+
Pj4gDQo+Pj4+IDEyNDJhODdkYTBkOCBTVU5SUEM6IEZpeCBzdmN4ZHJfaW5pdF9lbmNvZGUncyBi
dWZsZW4gY2FsY3VsYXRpb24NCj4+Pj4gRml4ZXM6IGJkZGZkYmNkZGJlMiAoIk5GU0Q6IEV4dHJh
Y3QgdGhlIHN2Y3hkcl9pbml0X2VuY29kZSgpIGhlbHBlciIpDQo+Pj4+IDkwYmZjMzdiNWFiOSBT
VU5SUEM6IEZpeCBzdmN4ZHJfaW5pdF9kZWNvZGUncyBlbmQtb2YtYnVmZmVyIGNhbGN1bGF0aW9u
DQo+Pj4+IEZpeGVzOiA1MTkxOTU1ZDZmYzYgKCJTVU5SUEM6IFByZXBhcmUgZm9yIHhkcl9zdHJl
YW0tc3R5bGUgZGVjb2Rpbmcgb24gdGhlIHNlcnZlci1zaWRlIikNCj4+Pj4gMTAzOTZmNGRmOGI3
IG5mc2Q6IGhvbGQgYSBsaWdodGVyLXdlaWdodCBjbGllbnQgcmVmZXJlbmNlIG92ZXIgQ0JfUkVD
QUxMX0FOWQ0KPj4+PiBGaXhlczogNDRkZjZmNDM5YTE3ICgiTkZTRDogYWRkIGRlbGVnYXRpb24g
cmVhcGVyIHRvIHJlYWN0IHRvIGxvdyBtZW1vcnkgY29uZGl0aW9uIikNCj4+PiBNeSBuYWl2ZSBz
ZWFyY2ggZm91bmQ6DQo+Pj4gQ2hlY2tpbmcgY29tbWl0IDQ0ZGY2ZjQzOWExNyAuLi4NCj4+PiAg
dXBzdHJlYW0gZml4IDEwMzk2ZjRkZjhiNzVmZjZhYjBhYTJjZDc0Mjk2NTY1NDY2ZjJjOGQgbm90
IGZvdW5kDQo+Pj4gMTAzOTZmNGRmOGI3NWZmNmFiMGFhMmNkNzQyOTY1NjU0NjZmMmM4ZCBuZnNk
OiBob2xkIGEgbGlnaHRlci13ZWlnaHQgY2xpZW50IHJlZmVyZW5jZSBvdmVyIENCX1JFQ0FMTF9B
TlkNCj4+PiAgdXBzdHJlYW0gZml4IGYzODVmN2QyNDQxMzQyNDZmOTg0OTc1ZWQzNGNkNzVmNzdk
ZTQ3OWYgaXMgYWxyZWFkeSBhcHBsaWVkDQo+Pj4gQ2hlY2tpbmcgY29tbWl0IGEyMDcxNTczZDYz
NCAuLi4NCj4+PiAgdXBzdHJlYW0gZml4IGYxYWEyZWI1ZWEwNWNjZDFmZDkyZDIzNTM0NmU2MGU5
MGExZWQ5NDkgbm90IGZvdW5kDQo+Pj4gZjFhYTJlYjVlYTA1Y2NkMWZkOTJkMjM1MzQ2ZTYwZTkw
YTFlZDk0OSBzeXNjdGw6IGZpeCBwcm9jX2RvYm9vbCgpIHVzYWJpbGl0eQ0KPj4+IENoZWNraW5n
IGNvbW1pdCBiZGRmZGJjZGRiZTIgLi4uDQo+Pj4gIHVwc3RyZWFtIGZpeCAxMjQyYTg3ZGEwZDhj
ZDJhNDI4ZTk2Y2E2OGU3ZWE4OTliMGY0NjI0IG5vdCBmb3VuZA0KPj4+IDEyNDJhODdkYTBkOGNk
MmE0MjhlOTZjYTY4ZTdlYTg5OWIwZjQ2MjQgU1VOUlBDOiBGaXggc3ZjeGRyX2luaXRfZW5jb2Rl
J3MgYnVmbGVuIGNhbGN1bGF0aW9uDQo+Pj4gQ2hlY2tpbmcgY29tbWl0IDlmZTYxNDUwOTcyZCAu
Li4gICAgIHVwc3RyZWFtIGZpeCAyMTExYzNjMDEyNGY3NDMyZmU5MDhjMDM2YTUwYWJlODczM2Ri
ZjM4IG5vdCBmb3VuZA0KPj4+IDIxMTFjM2MwMTI0Zjc0MzJmZTkwOGMwMzZhNTBhYmU4NzMzZGJm
MzggbmFtZWk6IGZpeCBrZXJuZWwtZG9jIGZvciBzdHJ1Y3QgcmVuYW1lZGF0YSBhbmQgbW9yZQ0K
Pj4+IENoZWNraW5nIGNvbW1pdCAwMTNjMTY2N2NmNzggLi4uICAgICB1cHN0cmVhbSBmaXggMmMw
ZjBmMzYzOTU2MmQ2ZTM4ZWU5NzA1MzAzYzY0NTdjNDkzNmVhYyBub3QgZm91bmQNCj4+PiAyYzBm
MGYzNjM5NTYyZDZlMzhlZTk3MDUzMDNjNjQ1N2M0OTM2ZWFjIG1vZHVsZTogY29ycmVjdGx5IGV4
aXQgbW9kdWxlX2thbGxzeW1zX29uX2VhY2hfc3ltYm9sIHdoZW4gZm4oKSAhPSAwDQo+Pj4gIHVw
c3RyZWFtIGZpeCAxZTgwZDljYjU3OWVkN2VkZDEyMTc1M2VlY2NjZTgyZmY4MjUyMWI0IG5vdCBm
b3VuZA0KPj4+IDFlODBkOWNiNTc5ZWQ3ZWRkMTIxNzUzZWVjY2NlODJmZjgyNTIxYjQgbW9kdWxl
OiBwb3RlbnRpYWwgdW5pbml0aWFsaXplZCByZXR1cm4gaW4gbW9kdWxlX2thbGxzeW1zX29uX2Vh
Y2hfc3ltYm9sKCkNCj4+PiBDaGVja2luZyBjb21taXQgODlmZjg3NDk0YzZlIC4uLg0KPj4+ICB1
cHN0cmVhbSBmaXggNWMxMTcyMDc2N2Y3MGQzNDM1N2QwMGExNWJhNWEwYWQwNTJjNDBmZSBub3Qg
Zm91bmQNCj4+PiA1YzExNzIwNzY3ZjcwZDM0MzU3ZDAwYTE1YmE1YTBhZDA1MmM0MGZlIFNVTlJQ
QzogRml4IGEgTlVMTCBwb2ludGVyIGRlcmVmIGluIHRyYWNlX3N2Y19zdGF0c19sYXRlbmN5KCkN
Cj4+PiBDaGVja2luZyBjb21taXQgNTE5MTk1NWQ2ZmM2IC4uLg0KPj4+ICB1cHN0cmVhbSBmaXgg
OTBiZmMzN2I1YWI5MWMxYTYxNjVlM2U1Y2ZjNDliZjA0NTcxYjc2MiBub3QgZm91bmQNCj4+PiA5
MGJmYzM3YjVhYjkxYzFhNjE2NWUzZTVjZmM0OWJmMDQ1NzFiNzYyIFNVTlJQQzogRml4IHN2Y3hk
cl9pbml0X2RlY29kZSdzIGVuZC1vZi1idWZmZXIgY2FsY3VsYXRpb24NCj4+PiAgdXBzdHJlYW0g
Zml4IGI5ZjgzZmZhYTBjMDk2YjRjODMyYTQzOTY0ZmU2YmZmM2FjZmZlMTAgbm90IGZvdW5kDQo+
Pj4gYjlmODNmZmFhMGMwOTZiNGM4MzJhNDM5NjRmZTZiZmYzYWNmZmUxMCBTVU5SUEM6IEZpeCBu
dWxsIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4gc3ZjX3Jxc3RfZnJlZSgpDQo+Pj4gSSdsbCBsb29r
IGludG8gYmFja3BvcnRpbmcgdGhlIG1pc3NpbmcgTkZTRCBhbmQgU1VOUlBDIHBhdGNoZXMuDQo+
PiANCj4+IE15IGxpc3QgZGlkbid0IGluY2x1ZGUgcGF0Y2hlcyB3aXRoIGNvbmZsaWN0cy4gVGhl
cmUgYXJlIGEgbG90IG9mIHRoZW0uIE91ciByb2JvdA0KPj4gY29sbGVjdHMgdGhvc2UsIGJ1dCBk
b2Vzbid0IGZvY3VzIG9uIGl0LiBJdCBhbHNvIGRvZXNuJ3QgYW5hbHl6ZSBqdXN0IG5mZHMvU1VO
UlBDDQo+PiBwYXRjaGVzLCBidXQgYWxsIG9mIHRoZW0uIEkgc3RhcnRlZCBhbiBhbmFseXNpcyB0
byBsaXN0IGFsbCB0aGUgZml4ZXMgd2l0aA0KPj4gY29uZmxpY3RzOyBzbyBmYXIgSSBmb3VuZCBh
Ym91dCAxMDAgb2YgdGhlbS4gVGhyZWUgYXJlIHRhZ2dlZCBTVU5SUEMuDQo+PiANCj4+IFVwc3Ry
ZWFtIGNvbW1pdCA4ZTA4OGEyMGRiZTMgKCJTVU5SUEM6IGFkZCBhIG1pc3NpbmcgcnBjX3N0YXQg
Zm9yIFRDUCBUTFMiKQ0KPj4gdXBzdHJlYW06IHY2LjktcmM3DQo+PiAgIEZpeGVzOiAxNTQ4MDM2
ZWYxMjAgKCJuZnM6IG1ha2UgdGhlIHJwY19zdGF0IHBlciBuZXQgbmFtZXNwYWNlIikNCj4+ICAg
ICBpbiBsaW51eC01LjQueTogMTlmNTFhZGM3NzhmDQo+PiAgICAgaW4gbGludXgtNS4xMC55OiBh
ZmRiYzIxYTkyYTANCj4+ICAgICBpbiBsaW51eC01LjE1Lnk6IDdjZWI4OWY0MDE2ZQ0KPj4gICAg
IGluIGxpbnV4LTYuMS55OiAyYjdmMmQ2NjNhOTYNCj4+ICAgICBpbiBsaW51eC02LjYueTogMjYw
MzMzMjIxY2YwDQo+PiAgICAgdXBzdHJlYW06IHY2LjktcmMxDQo+PiAgIEFmZmVjdGVkIGJyYW5j
aGVzOg0KPj4gICAgIGxpbnV4LTUuNC55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+
PiAgICAgbGludXgtNS4xMC55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+PiAgICAg
bGludXgtNS4xNS55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+PiAgICAgbGludXgt
Ni4xLnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4+ICAgICBsaW51eC02LjYueSAo
YWxyZWFkeSBhcHBsaWVkKQ0KPj4gDQo+PiBVcHN0cmVhbSBjb21taXQgYWVkMjhiN2EyZDYyICgi
U1VOUlBDOiBEb24ndCBkZXJlZmVyZW5jZSB4cHJ0LT5zbmRfdGFzayBpZiBpdCdzIGEgY29va2ll
IikNCj4+IHVwc3RyZWFtOiB2NS4xNy1yYzINCj4+ICAgRml4ZXM6IGUyNmQ5OTcyNzIwZSAoIlNV
TlJQQzogQ2xlYW4gdXAgc2NoZWR1bGluZyBvZiBhdXRvY2xvc2UiKQ0KPj4gICAgIGluIGxpbnV4
LTUuNC55OiAyZDZmMDk2NDc2ZTYNCj4+ICAgICBpbiBsaW51eC01LjEwLnk6IDJhYjU2OWVkZDg4
Mw0KPj4gICAgIHVwc3RyZWFtOiB2NS4xNS1yYzENCj4+ICAgQWZmZWN0ZWQgYnJhbmNoZXM6DQo+
PiAgICAgbGludXgtNS40LnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4+ICAgICBs
aW51eC01LjEwLnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4+ICAgICBsaW51eC01
LjE1LnkgKGFscmVhZHkgYXBwbGllZCkNCj4+IA0KPj4gVXBzdHJlYW0gY29tbWl0IGFhZDQxYTdk
N2NmNiAoIlNVTlJQQzogRG9uJ3QgbGVhayBzb2NrZXRzIGluIHhzX2xvY2FsX2Nvbm5lY3QoKSIp
DQo+PiB1cHN0cmVhbTogdjUuMTgtcmM2DQo+PiAgIEZpeGVzOiBmMDA0MzIwNjNkYjEgKCJTVU5S
UEM6IEVuc3VyZSB3ZSBmbHVzaCBhbnkgY2xvc2VkIHNvY2tldHMgYmVmb3JlIHhzX3hwcnRfZnJl
ZSgpIikNCj4+ICAgICBpbiBsaW51eC01LjQueTogMmY4ZjZjMzkzYjExDQo+PiAgICAgaW4gbGlu
dXgtNS4xMC55OiBlNjhiNjBhZTI5ZGUNCj4+ICAgICBpbiBsaW51eC01LjE1Lnk6IDU0ZjY4MzRi
MjgzZA0KPj4gICAgIHVwc3RyZWFtOiB2NS4xOC1yYzINCj4+ICAgQWZmZWN0ZWQgYnJhbmNoZXM6
DQo+PiAgICAgbGludXgtNS40LnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4+ICAg
ICBsaW51eC01LjEwLnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4+ICAgICBsaW51
eC01LjE1LnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4+IA0KPj4gSSdsbCBzZW5k
IGEgY29tcGxldGUgbGlzdCBhZnRlciB0aGUgYW5hbHlzaXMgaXMgZG9uZS4NCj4gDQo+IFRoZSAi
TkZTRCBmaWxlIGNhY2hlIGZpeGVzIiBiYWNrcG9ydHMgZm9jdXNlZCBvbiBORlNELCBub3Qgb24N
Cj4gU1VOUlBDLCBhbmQgb25seSB0aGUgTkZTIHNlcnZlciBzaWRlIG9mIGFmZmFpcnMuIFRoZSBt
aXNzaW5nDQo+IGZpeGVzIHlvdSBmb3VuZCBhcmUgb3V0c2lkZSBvZiBvbmUgb3IgYm90aCBvZiB0
aG9zZSBhcmVhcywgc28NCj4gdGhleSBjYW4gZ28gdGhyb3VnaCB0aGUgdXN1YWwgc3RhYmxlIGJh
Y2twb3J0IHByb2Nlc3MgaWYgdGhlDQo+IE5GUyBjbGllbnQgZm9sa3MgY2FyZSB0byBkbyB0aGF0
Lg0KDQpPciwgdG8gY3V0IHRoaXMgYW5vdGhlciB3YXk6IEkgbG9va2VkIGF0IG9ubHkgdGhlIHBh
dGNoZXMgdGhhdA0KSSBzdWJtaXR0ZWQgZm9yIHY1LjEwLjIyMDsgSSB3aWxsIHRha2UgcmVzcG9u
c2liaWxpdHkgZm9yDQplbnN1cmluZyB0aG9zZSBhbGwgaGF2ZSB0aGUgbGF0ZXN0IHVwc3RyZWFt
IGZpeGVzIGFwcGxpZWQsDQp3aGVyZSB0aGF0IGlzIGZlYXNpYmxlLg0KDQpBbnl0aGluZyBlbHNl
IChvdGhlciBzdWJzeXN0ZW1zLCBvdGhlciBMVFMga2VybmVscykgZ2V0cyB0aGUNCm5vcm1hbCBz
dGFibGUgYmFja3BvcnQgdHJlYXRtZW50OiB0aG9zZSBzdWJzeXN0ZW0gbWFpbnRhaW5lcnMNCm9y
IHRoZWlyIGRlc2lnbmVlcyBoYXZlIHRvIHN0ZXAgdXAgdG8gaGFuZGxlIHRoZSBjb2RlIHdvcmsN
CmFuZCB0ZXN0aW5nIGlmIHRoZXkgdmlldyB0aGUgZml4IGFzIGEgcHJpb3JpdHkuDQoNCg0KLS0N
CkNodWNrIExldmVyDQoNCg0K
