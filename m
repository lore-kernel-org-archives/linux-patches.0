Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C84C65
	for <patches@lists.linux.dev>; Wed, 29 May 2024 00:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716941638; cv=fail; b=oEI0tvGsQrBW2GIrXXM9bV77A+GTtIR/0v6ai5Z4FczFzv30HBEzUS14YKaUGYMb+bS7c/xI3EUw6tzAx52Tn8pbHIpFngGz2FMNQjWwYLTufo1z7gxMHkb16VPnbbSCsuRmHpYN94Ku2eqyN0uG8ZS0/KfaN0GqxwuxeGTIsvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716941638; c=relaxed/simple;
	bh=gWcC5DcB3OtmfFVADbClLZGDfkLMa419gJmOoTAf0kA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QEpf9sthAxkDmIPS0bMqV4XHxmvGaOThYkmfxAYvZkMZGuo8DhntqtlEtndIek+RUslPoj4lUZSjytXZNnCEEn23ifpYjOR7viVD0E39HJ6MtmUzyFLk5O1Xid234xTZ25aXLWVQiqjHI7M0TjHL4LxrgWiavkwOQRO/I8Ht33Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SI1tUi009107;
	Wed, 29 May 2024 00:13:24 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DgWcC5DcB3OtmfFVADbClLZGDfkLMa419gJmOoT?=
 =?UTF-8?Q?Af0kA=3D;_b=3DO18Gp0Wsf5aNnS/2VpQoDqzh21IY0YarAht1xoQBtLp4oyAkv?=
 =?UTF-8?Q?CuepqOoPkElWTbnw6ws_6npKnIrp5OSS7IQOFNpH3e2UU2CxUUnIlJobrEL99Ba?=
 =?UTF-8?Q?f0+4Xvse8icX9PyjNrB8vzm1L_cPMaakMgIoXUFpdvW2zEMKuaxSs5/kw98do0I?=
 =?UTF-8?Q?2xZ06jBwDsjXGNpf3mJehs96cO3+L9p_eTQfphE1QSoJjtZWczITQ9Jd0gJddY/?=
 =?UTF-8?Q?D3NbLJaHlta3zwZUdQF3o1mEe4HfaNBOExO1e_EScrtjl8aOf7a7wVP/dY1ktM6?=
 =?UTF-8?Q?b+86DiDSxj9IQ2168cklj7/wMw9+wNBCDQIm7eq/s1F_Rw=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8kb5kq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 00:13:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SMnLNa010653;
	Wed, 29 May 2024 00:13:23 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50xk04u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 00:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6JDwDO2WwrD5IY5oUtYoglo6pM77/CEk0hDX6uwDmdlTsvbMaioU6Go6fEbL/sfGV/e5Xptkwl7JqCsv3QAs4AK/jVFBCiIh6ronchiVdRNNxK+OjwbwlGDca1+o0SKq37nU+8a4YnOTC8bBMfEOJU/FmF2ELJlOR1Ukg0EnJt7wcxyrvgfkDTBfRB8gcqaua/xBvBYXn4AMwaQGnkQv4WbNhZCG8it6GwvZBB4G5bxhoxEFyBu0nbCvdDESffg+H5tNtbYN0LbHZuo+rtxKyGYCQuwambkKsSVgpvQFxanu4kF+Rodc4jaGM8PXTL1VqCYB8hlWoznlnDNVhKsfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWcC5DcB3OtmfFVADbClLZGDfkLMa419gJmOoTAf0kA=;
 b=EOvtUpl3/qaYS+twW358P1Pead5y+9ywXnFkxBCXOHuI5Cgg+IWkeF+gT/+4WWo6/ajZ0ncrSVcXuywBiDppsy4077EOPjCtYs8klC04D3EyV8kP1bzj0YFfXI/HfitarckSkQGKEm6VON4Q+GQXY2zwz3ZHxqL96K4GXRVcXmcaJildbHlITS2Xv+n5Xu28mwxxmsoQoM/ioin/+uOOaujHDOX5dvKRrBywyJWMqz39aEMZXT20eZBVuY4NXyyyNnQqvboV0MNqEZaZ5hlCrWNC5w1p8uooWMATDlzeNyMo2mHmGYJhHo6XNWvpjfeVH59deVbztRUerR1jDhHw3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWcC5DcB3OtmfFVADbClLZGDfkLMa419gJmOoTAf0kA=;
 b=sDsZg8ti0KEv2CyaEQT+L+brV7Z3sGaJyCmq7X5zFuIjArrAXtxFoi9dCpbtad9zhr5U5o9hcok91nl2v8qcbqWcbhdVyvCWelqMu8xLAdsjsrF2+AKftL6Dcwta6f3osecy/sjAGiLaQPKtDH35O9BVqcDL+HBaqACy6eGQ5n0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4650.namprd10.prod.outlook.com (2603:10b6:806:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 00:13:20 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.7611.025; Wed, 29 May 2024
 00:13:20 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Neil Brown <neilb@suse.de>
CC: Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        Chris Packham
	<Chris.Packham@alliedtelesis.co.nz>,
        linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>,
        "conor@kernel.org" <conor@kernel.org>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "broonie@kernel.org"
	<broonie@kernel.org>,
        "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Topic: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Index: 
 AQHasN4Kp5m/MZVFZ0aHe0MmQeirFLGsoDYAgAARwgCAAG8IgIAAElGAgAAZzICAAAMNAIAACBKA
Date: Wed, 29 May 2024 00:13:20 +0000
Message-ID: <0C544336-A28C-430D-AB15-A2262980FF2C@oracle.com>
References: <9C1A047C-C8C2-413F-98EA-F8C537535D92@oracle.com>
 <171693985607.27191.15010728056026409099@noble.neil.brown.name>
In-Reply-To: <171693985607.27191.15010728056026409099@noble.neil.brown.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA2PR10MB4650:EE_
x-ms-office365-filtering-correlation-id: 0dc14af9-1efb-4d20-548e-08dc7f7425bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?VGFDUk9XNEVpZnJUVDVrakdOZ090M1ZtZTB1dDJITDZQcXVMN3pEc0ZhZVhq?=
 =?utf-8?B?S2s1bXlGc3lHaGZWanA5TkRONnkwbTdnVk13OFZWTFVKZzNGVXhJWjY1c3hV?=
 =?utf-8?B?ZjRSMTMxMWVlQnN5UE9HbUtSN2tJMXBxS20rei9YVjZ4WGFBMWF5SGY2cUdM?=
 =?utf-8?B?VyswQVoyZDZ4T2NkWXhYU1EwTWFDNGFYb0dpTjhVQjFma2ttMmIwV2Q2cGF6?=
 =?utf-8?B?TmY4dE8rL09Qa0FYWkh1UUhCOHNSazVPU2diTlArYW5jVGlWbVVKK3kvRkRq?=
 =?utf-8?B?R2c1THhrQjFIV0h5TGF3S0toeTNja3RVaC9yZElVWkFYMzBnVVZ1UXZBREdN?=
 =?utf-8?B?VGJCRlhlMFdzajgrdGZUM0FOVFJTRWhESDdsNGJBZFE1N3h2T3hnTFZuNnNP?=
 =?utf-8?B?V0NYelhwcTlDa3oxNCtvZ05DRzNOVDJwNnlGbzFOVTF6aGEzNEJDSVhVTWRs?=
 =?utf-8?B?S2ExWlFOYnh1eVNwNGN6eTlwRHU5L0VuTllUT29nT215WS95QmI1b0dUL29j?=
 =?utf-8?B?VWxVVU5VMCtKcm5qZVpxK2ZhNUthK240UnllKzg4U3dTTkJHSTJMYi8rdWZv?=
 =?utf-8?B?b1RkOEZCRVNMdVVkL0FvbENsNFFYVjdvVHV5YWo3ZEovcUJBR2RGQTJCbTda?=
 =?utf-8?B?cjE2YnIwbGlQVEVZMDZWY2Q0QW9UT3YwWU1icSs5eTJjWnFXZlYwdGk2MW14?=
 =?utf-8?B?MFEwM1Q3Y1IyTUs3WWlldkt5YjhyVFh0dStLL3QrbVpNUE5ZQWVHTFVDRm9Y?=
 =?utf-8?B?NHF5N3ZEREJ6T1VpWkpkSW5qNzhPSjNReTRyWExLSDZKNlVkSG1yVW1OVVBU?=
 =?utf-8?B?NDhtellRSmtvQmxkMlZxa01ObkZGdG1wOEFEbEdtaGNzK0Exa1BGRkhra3NI?=
 =?utf-8?B?UmtUT2tmRGw2dG1EMk03N3l2TVl1c3NOSmRGc2JDTVRXUFAwS2VORUVLNFYw?=
 =?utf-8?B?VDAzUm8xck42VVFESkhHMlVUSjVqaFZpSTYyd2Q2b0ZYTFkyb2ZjY3diaGNM?=
 =?utf-8?B?UlR3VWl0cG9sZHNPUThNKzB0RW9vY3NhUWZWRTRYTXlhZ0o1UUJsdENZRHFB?=
 =?utf-8?B?ODI2K3N1UWRNZEd5aFFOeE5tTDhsSUhXbmZXUUpubVV0VlZ1MEQ4RVVwbFVO?=
 =?utf-8?B?aFZlMitYTXNiYkpjKzAvMGNGZ0hMclFiVHlZd2RBWGk2OW9RMHdZYWhoeHJV?=
 =?utf-8?B?UXpLeU5FeTRVSUNzcDZ6ZjJVOGJIRTZaUkRRS2hCeDhYVzFrRzhFTStjQ01Y?=
 =?utf-8?B?QnBtQjNvQmxoMStFRjZpR0V3MEc2VnJhTzlFazV1emdQZkJIVlRaTldRR2po?=
 =?utf-8?B?b0NBU3F2aExyUEF0dVdTNzQraEN1cW9ROTAwNlN1ZjNWM1c3ZFNrTDlqbzlQ?=
 =?utf-8?B?Wlc0d3N2Szk1R0Ziakh6TjNDa0xnOGxwaDVPdnhETGU1UEt6dFdMMWhXaEs4?=
 =?utf-8?B?R0dEQzB6Ymljb3FqWEdpSEpwRkMrTnNJaXRYV1NzT3pSSG5aOEl4QTIrQmtW?=
 =?utf-8?B?S2pRMkZUVTFaT3kvb3JGdS9VQkNmWkhYTDFsNEZsOG5mR2ZOd0VVSG9iUjcw?=
 =?utf-8?B?Nzl6QXordlRSeFo1S1I0b0o4L1pQU0Q0dnJacU5NK2ltMVBMc2NZREJ1ZXBy?=
 =?utf-8?B?Z1JRNXpPNFBMYTdwS0dnMi9xTGtHRzJKUkZCWVdVRFRka0NFTHVsWUN6a09i?=
 =?utf-8?B?Q3ViaytvbnhDeURHZlo1N2NUYTIwU0lVaTdTc0h4OTlabjhmbG5pNVdnPT0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?OVdSR3AxQmlmOEVUa3loUDRhcCtUTzYrVE5xbUdhem9RUm1HUHdhNE1lRjZS?=
 =?utf-8?B?ajlES1FXQzBKSFFpdlp2eUloUmRvME8vL1pVTTNPYUpDWTZlSEV3bWMyRC9H?=
 =?utf-8?B?eHlFN0MySThSMlhpUzNVUk5IUlUzcDVIVXhHcVFKQ3BzZVFjOXJ2MUI3aUVh?=
 =?utf-8?B?TittWjJqOVBhSHNDQzY0U09UVC81UmZRRmJDRzdROFA0R1l5OVA0cWhVY1Jy?=
 =?utf-8?B?RFNkc3NLTHdmQ3QwTXc2YWZ0Rms1a2RDWHd6RTYzZks1OTZRUVd3ZUdJQ0xh?=
 =?utf-8?B?ZXZEZGdpT2RKOGhuTlMvQWFxcWFDVGg3NjVzaGg2MWVFY3BTWnl1TjZVWVpz?=
 =?utf-8?B?NTZqYU5PL1JoSnEwb2lwVW5ERk4xcU9hRkFtUFdOSFhHRkp6MTBjbTRzZGdG?=
 =?utf-8?B?ZUhJZWVhR3I4V3JuSS9zOHZyamhTeGtvK2ZiMjdMM2JSQW5MNmxXWXFGekli?=
 =?utf-8?B?S0VZZjlqMGFDNzg1ZDZKOWFYTGpPNFU3a2lQSVFQbUVJdytVS2QzZnNTT3BS?=
 =?utf-8?B?d3hNdjJVNFpyc21qU0xMZ0JOZTdnSUZmT2V2bVpYR0gyL0RQMy82SzV2UXJa?=
 =?utf-8?B?TFpmY1k3d3lqZVRRWlplM2xHRUxGZGk0Si84Rnp1MVZHMWpNT052U2dKOUVY?=
 =?utf-8?B?Z0gxelpxeHBLRTZEMWFMVTV1TDR4ejFvN0t2MzhzVGVVY0x0eER3cFA1VlBO?=
 =?utf-8?B?WkIybmtpT2NSWnY1Njh3TENHUEU0STNVbXZjU2tONEdXSzhLMHVXcTl6UVRa?=
 =?utf-8?B?djU4S25pQWF2U25kS0ZacGc5dmZYakQ5bk13MmgvMWQ5MlVlcGZpeS90QVJx?=
 =?utf-8?B?cTgwdFpXUzJ5YXc4ZHZTZkFQREZqTlFjSDZza1gzZC9hR1ZwZWdtRDdjUzdt?=
 =?utf-8?B?dHVDZUhqTzEvWU1uNXpRR2YyQUFJbmZWUTRIREJXd2IrZ1RrSStDWXBielB4?=
 =?utf-8?B?aHJKcXJXMkcwdytudkdva1NYcnV4VURCR282MkpaRUJJdytaMzExV0VFeDZO?=
 =?utf-8?B?bFVaMG5nK1kxVkovbSt3b3hpbkFyMWhJOXhsazZxTnNJOFBTMFpBejB1ZGhi?=
 =?utf-8?B?Y0RkWVRKeGFudE5XRzNCSmdCQlZKWGxPQlBOQytuWmVMM2xlTE9xdWJrOWdy?=
 =?utf-8?B?ZWJtc1QvMXEwNWNHWWRYSVIxT25MdmI5UzV0ZXlnRUwyZ2YzVUhlenJST01M?=
 =?utf-8?B?cEpSa1BFM3Q4cE8yeE9Rb1pMNjkydXNMUW5YR3lpZ0l2YWRuRjlOc2xRQ3pO?=
 =?utf-8?B?bitUM04zRW91R2dUMkhEeENleWJNT3FaVmxRd2lVZ0tqOHExTE5rdUd6b25i?=
 =?utf-8?B?VGc1VE5ZdURzNkt6TytOWUZpQlVUN2tmK2lkWGR1MlBweFArVDdoYlVyV292?=
 =?utf-8?B?K3l1N093d0J2OWdhQ0hrNkdmZlcxa3I3N05vNmJkR2VvZGNNa2poWFJQZVM3?=
 =?utf-8?B?aGxEUkhBSWREakx5a2tVL0RWVHJaT1ZCYnFvV25jbVRjamhtK2xlYUtwN21N?=
 =?utf-8?B?aFYwL2kzYmxtSXN6Vm5tSDdFcTYzNEJWNk04RXdoaHVxRWV2eGRuTDdyd1pV?=
 =?utf-8?B?bHRIS1hlQm5iZVJ3Zlh3V2V4TUQwbithN3hJTlBWNXNKWmxWdzU2aW5vdldM?=
 =?utf-8?B?bXNWSHBGSVEvNDRaTmFTNlk5R3dlcmNOZzVBV0tqSjdkZzAwaHFKUkxxQlNX?=
 =?utf-8?B?TFNEOHdNL0ZZeVllVzI3SnI1N0tCYlhKd1laTGRsTVJBTnNWTmVUN0xIcE1q?=
 =?utf-8?B?RlVwcWhUZkVmYisycHFPOXFkcTAvRXY2ZVQxcWkzNlZFRU5SZVlmZVo2NS8r?=
 =?utf-8?B?M285K0JVT2VNRXJEUGhqVkFNK0ZIOUwyNkJucFBIYW05ZXpQcS9MZGo3QkNh?=
 =?utf-8?B?N3RaUHU1WktMaUZzS21qeDlrOEw2aDZ0UkZ1UjdCN0JkT0dLQm9JQUVhM24y?=
 =?utf-8?B?RWRxRmt6cFhqeHdvNy84Uk9SSEVZNFIySS9KT1pFL2lscUdrM3VKNzZmWmor?=
 =?utf-8?B?U2xuQ2NsZ1dEd2RGdGxZa1ZmcHBjTitHeEpFeUFLbjZyUnlwdmZQTWs1aXgx?=
 =?utf-8?B?WTNvWGdDa3N2MCtOMWI1dzNsTFA4R3RBNlhZRFhVVjJ6Z3ZHTlgzZHpFNzdi?=
 =?utf-8?B?RFBCalJ2VFBRWWlVK3hUT3FGTkdQU0pMeU8wMHNrWVhPRzlsVldFREF3WUxm?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7416A4CC82CC7A4E94C6324F8FD2A0A4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eArcP97U6UTBrehIIYWVxM9RWQRxeB0omHh6Zao92SP1oBS9NIlOrPnhTb3pX9ndg/hTUgisREnKfJJVOaVJvjt03DzcBSuMMjd4sLa828EkUH6PSGXcB1Uq+D6Q9b3irbOjSoAX1sajvna+upsnZ3D98HvXGnXnGuzUjXg4kUv4o1tIxl0SPPJ6gjserzDtkTJ8p8py3JWYvRYbTSzdNM5xNYhonfkM6Nm5yBho+LpdgA7J6Xty5Ft3eQFNK0sreRtkXFjrKn6S3RTwAuHgdpj2c3Tu2kTw5/6a6cbMd3JO/ajgq4v2w1jhTsEnI8Xtl/zEhL0zsjn8AfYoMpUCEP2C55vIT/25RtSZcgddCcemPICrwWbjiGDDmwO2ny7+/3nVAQVOk4R/ugHsofwQXbe3HobhFp+xXZLV1VeziygLiZs2lJFaIDJFQrRXpfeTBdPbyD9LtUj9flTizBoIPL+G6YsXFB4fiBwFzDfAlCNcZUf9QWUPCimRB3+qW8eHIQCHCzexfEZWjptDgEwE8iLODFsErI49UFTinVB+FbXUAC+EdxNI12jwgxfuYuQ2pbAuE4nOs2AJThUKI+aOK9258+hug9d64jqEF1h2qJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc14af9-1efb-4d20-548e-08dc7f7425bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 00:13:20.5377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AnOlUDQIBaoxZsALD8hnwC9y3ftKnmYeKjScCN99wceWbmwU3eMZX55w8O1QMWJcwQrrnWovZjR9s3VmgClMWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_14,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405280178
X-Proofpoint-GUID: TD6GtcCnzmFkodjez0R1R-Xgp4utvqZN
X-Proofpoint-ORIG-GUID: TD6GtcCnzmFkodjez0R1R-Xgp4utvqZN

DQoNCj4gT24gTWF5IDI4LCAyMDI0LCBhdCA3OjQ04oCvUE0sIE5laWxCcm93biA8bmVpbGJAc3Vz
ZS5kZT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDI5IE1heSAyMDI0LCBDaHVjayBMZXZlciBJSUkg
d3JvdGU6DQo+PiANCj4+IA0KPj4+IE9uIE1heSAyOCwgMjAyNCwgYXQgNjowMeKAr1BNLCBOZWls
QnJvd24gPG5laWxiQHN1c2UuZGU+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFdlZCwgMjkgTWF5IDIw
MjQsIENodWNrIExldmVyIElJSSB3cm90ZToNCj4+Pj4gDQo+Pj4+IA0KPj4+Pj4gT24gTWF5IDI4
LCAyMDI0LCBhdCAxMDoxOOKAr0FNLCBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4g
d3JvdGU6DQo+Pj4+PiANCj4+Pj4+IA0KPj4+Pj4gT24gMjgvMDUvMjAyNCAxNDoxNCwgQ2h1Y2sg
TGV2ZXIgSUlJIHdyb3RlOg0KPj4+Pj4+PiBPbiBNYXkgMjgsIDIwMjQsIGF0IDU6MDTigK9BTSwg
Sm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+IHdyb3RlOg0KPj4+Pj4+PiANCj4+Pj4+
Pj4gDQo+Pj4+Pj4+IE9uIDI1LzA1LzIwMjQgMTU6MjAsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90
ZToNCj4+Pj4+Pj4+IE9uIFNhdCwgTWF5IDI1LCAyMDI0IGF0IDEyOjEzOjI4QU0gKzAxMDAsIEpv
biBIdW50ZXIgd3JvdGU6DQo+Pj4+Pj4+Pj4gSGkgR3JlZywNCj4+Pj4+Pj4+PiANCj4+Pj4+Pj4+
PiBPbiAyMy8wNS8yMDI0IDE0OjEyLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+Pj4+Pj4+
Pj4+IFRoaXMgaXMgdGhlIHN0YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUg
NS4xNS4xNjAgcmVsZWFzZS4NCj4+Pj4+Pj4+Pj4gVGhlcmUgYXJlIDIzIHBhdGNoZXMgaW4gdGhp
cyBzZXJpZXMsIGFsbCB3aWxsIGJlIHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+Pj4+Pj4+Pj4+IHRv
IHRoaXMgb25lLiAgSWYgYW55b25lIGhhcyBhbnkgaXNzdWVzIHdpdGggdGhlc2UgYmVpbmcgYXBw
bGllZCwgcGxlYXNlDQo+Pj4+Pj4+Pj4+IGxldCBtZSBrbm93Lg0KPj4+Pj4+Pj4+PiANCj4+Pj4+
Pj4+Pj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFNhdCwgMjUgTWF5IDIwMjQgMTM6MDM6
MTUgKzAwMDAuDQo+Pj4+Pj4+Pj4+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBt
aWdodCBiZSB0b28gbGF0ZS4NCj4+Pj4+Pj4+Pj4gDQo+Pj4+Pj4+Pj4+IFRoZSB3aG9sZSBwYXRj
aCBzZXJpZXMgY2FuIGJlIGZvdW5kIGluIG9uZSBwYXRjaCBhdDoNCj4+Pj4+Pj4+Pj4gaHR0cHM6
Ly93d3cua2VybmVsLm9yZy9wdWIvbGludXgva2VybmVsL3Y1Lngvc3RhYmxlLXJldmlldy9wYXRj
aC01LjE1LjE2MC1yYzEuZ3oNCj4+Pj4+Pj4+Pj4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFu
Y2ggYXQ6DQo+Pj4+Pj4+Pj4+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9zdGFibGUvbGludXgtc3RhYmxlLXJjLmdpdCBsaW51eC01LjE1LnkNCj4+Pj4+Pj4+
Pj4gYW5kIHRoZSBkaWZmc3RhdCBjYW4gYmUgZm91bmQgYmVsb3cuDQo+Pj4+Pj4+Pj4+IA0KPj4+
Pj4+Pj4+PiB0aGFua3MsDQo+Pj4+Pj4+Pj4+IA0KPj4+Pj4+Pj4+PiBncmVnIGstaA0KPj4+Pj4+
Pj4+PiANCj4+Pj4+Pj4+Pj4gLS0tLS0tLS0tLS0tLQ0KPj4+Pj4+Pj4+PiBQc2V1ZG8tU2hvcnRs
b2cgb2YgY29tbWl0czoNCj4+Pj4+Pj4+PiANCj4+Pj4+Pj4+PiAuLi4NCj4+Pj4+Pj4+PiANCj4+
Pj4+Pj4+Pj4gTmVpbEJyb3duIDxuZWlsYkBzdXNlLmRlPg0KPj4+Pj4+Pj4+PiAgICBuZnNkOiBk
b24ndCBhbGxvdyBuZnNkIHRocmVhZHMgdG8gYmUgc2lnbmFsbGVkLg0KPj4+Pj4+Pj4+IA0KPj4+
Pj4+Pj4+IA0KPj4+Pj4+Pj4+IEkgYW0gc2VlaW5nIGEgc3VzcGVuZCByZWdyZXNzaW9uIG9uIGEg
Y291cGxlIGJvYXJkcyBhbmQgYmlzZWN0IGlzIHBvaW50aW5nDQo+Pj4+Pj4+Pj4gdG8gdGhlIGFi
b3ZlIGNvbW1pdC4gUmV2ZXJ0aW5nIHRoaXMgY29tbWl0IGRvZXMgZml4IHRoZSBpc3N1ZS4NCj4+
Pj4+Pj4+IFVnaCwgdGhhdCBmaXhlcyB0aGUgcmVwb3J0IGZyb20gb3RoZXJzLiAgQ2FuIHlvdSBj
YzogZXZlcnlvbmUgb24gdGhhdA0KPj4+Pj4+Pj4gYW5kIGZpZ3VyZSBvdXQgd2hhdCBpcyBnb2lu
ZyBvbiwgYXMgdGhpcyBrZWVwcyBnb2luZyBiYWNrIGFuZCBmb3J0aC4uLg0KPj4+Pj4+PiANCj4+
Pj4+Pj4gDQo+Pj4+Pj4+IEFkZGluZyBDaHVjaywgTmVpbCBhbmQgQ2hyaXMgZnJvbSB0aGUgYnVn
IHJlcG9ydCBoZXJlIFswXS4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFdpdGggdGhlIGFib3ZlIGFwcGxp
ZWQgdG8gdjUuMTUueSwgSSBhbSBzZWVpbmcgc3VzcGVuZCBvbiAyIG9mIG91ciBib2FyZHMgZmFp
bC4gVGhlc2UgYm9hcmRzIGFyZSB1c2luZyBORlMgYW5kIG9uIGVudHJ5IHRvIHN1c3BlbmQgSSBh
bSBub3cgc2VlaW5nIC4uLg0KPj4+Pj4+PiANCj4+Pj4+Pj4gRnJlZXppbmcgb2YgdGFza3MgZmFp
bGVkIGFmdGVyIDIwLjAwMiBzZWNvbmRzICgxIHRhc2tzIHJlZnVzaW5nIHRvDQo+Pj4+Pj4+IGZy
ZWV6ZSwgd3FfYnVzeT0wKToNCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFRoZSBib2FyZHMgYXBwZWFyIHRv
IGhhbmcgYXQgdGhhdCBwb2ludC4gU28gbWF5IGJlIHNvbWV0aGluZyBlbHNlIG1pc3Npbmc/DQo+
Pj4+Pj4gTm90ZSB0aGF0IHdlIGRvbid0IGhhdmUgYWNjZXNzIHRvIGhhcmR3YXJlIGxpa2UgdGhp
cywgc28NCj4+Pj4+PiB3ZSBoYXZlbid0IHRlc3RlZCB0aGF0IHBhdGNoIChldmVuIHRoZSB1cHN0
cmVhbSB2ZXJzaW9uKQ0KPj4+Pj4+IHdpdGggc3VzcGVuZCBvbiB0aGF0IGhhcmR3YXJlLg0KPj4+
Pj4gDQo+Pj4+PiANCj4+Pj4+IE5vIHByb2JsZW0sIEkgd291bGQgbm90IGV4cGVjdCB5b3UgdG8g
aGF2ZSB0aGlzIHBhcnRpY3VsYXIgaGFyZHdhcmUgOi0pDQo+Pj4+PiANCj4+Pj4+PiBTbywgaXQg
Y291bGQgYmUgc29tZXRoaW5nIG1pc3NpbmcsIG9yIGl0IGNvdWxkIGJlIHRoYXQNCj4+Pj4+PiBw
YXRjaCBoYXMgYSBwcm9ibGVtLg0KPj4+Pj4+IEl0IHdvdWxkIGhlbHAgdXMgdG8ga25vdyBpZiB5
b3Ugb2JzZXJ2ZSB0aGUgc2FtZSBpc3N1ZQ0KPj4+Pj4+IHdpdGggYW4gdXBzdHJlYW0ga2VybmVs
LCBpZiB0aGF0IGlzIHBvc3NpYmxlLg0KPj4+Pj4gDQo+Pj4+PiANCj4+Pj4+IEkgZG9uJ3Qgb2Jz
ZXJ2ZSB0aGlzIHdpdGggZWl0aGVyIG1haW5saW5lLCAtbmV4dCBvciBhbnkgb3RoZXIgc3RhYmxl
IGJyYW5jaC4gU28gdGhhdCB3b3VsZCBzdWdnZXN0IHRoYXQgc29tZXRoaW5nIGVsc2UgaXMgbWlz
c2luZyBmcm9tIGxpbnV4LTUuMTUueS4NCj4+Pj4gDQo+Pj4+IFRoYXQgaGVscHMuIEl0IHdvdWxk
IGJlIHZlcnkgaGVscGZ1bCB0byBoYXZlIGEgcmVwcm9kdWNlciBJIGNhbg0KPj4+PiB1c2UgdG8g
Y29uZmlybSB3ZSBoYXZlIGEgZml4LiBJJ20gc3VyZSB0aGlzIHdpbGwgYmUgYSBwcm9jZXNzDQo+
Pj4+IHRoYXQgaW52b2x2ZXMgYSBub24tdHJpdmlhbCBudW1iZXIgb2YgaXRlcmF0aW9ucy4NCj4+
PiANCj4+PiBNaXNzaW5nIHVwc3RyZWFtIHBhdGNoIGlzDQo+Pj4gDQo+Pj4gQ29tbWl0IDliZDQx
NjFjNTkxNyAoIlNVTlJQQzogY2hhbmdlIHNlcnZpY2UgaWRsZSBsaXN0IHRvIGJlIGFuIGxsaXN0
IikNCj4+PiANCj4+PiBUaGlzIGNvbnRhaW5zIHNvbWUgZnJlZXplci1yZWxhdGVkIGNoYW5nZXMg
d2hpY2ggcHJvYmFibHkgc2hvdWxkDQo+Pj4gaGF2ZSBiZWVuIGEgc2VwYXJhdGUgcGF0Y2guDQo+
PiANCj4+IFRoYW5rcyBmb3IgdHJhY2tpbmcgdGhhdCBkb3duLg0KPj4gDQo+PiANCj4+PiBXZSBw
cm9iYWJseSBqdXN0IG5lZWQgdG8gYWRkICJ8IFRBU0tfRlJFRVpBQkxFIiBpbiBvbmUgb3IgdHdv
IHBsYWNlcy4NCj4+PiBJJ2xsIHBvc3QgYSBwYXRjaCBmb3IgdGVzdGluZyBpbiBhIGxpdHRsZSB3
aGlsZS4NCj4+IA0KPj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoZSBzdGFibGUgbWFpbnRh
aW5lcnMgcHJlZmVyIGEgYmFja3BvcnQNCj4+IG9mIGEgcGF0Y2ggKG9yIHBhdGNoZXMpIHRoYXQg
YXJlIGFscmVhZHkgYXBwbGllZCB0byBMaW51cycgdHJlZS4NCj4gDQo+IFRoZXkgYWxzbyBwcmVm
ZXJyZWQgYSBmdWxsIGJhY2twb3J0IG9mIGZzL25mc2QvLi4gIFRoYXQgaGFzbid0IGdvbmUgc28N
Cj4gd2VsbCA6LSkNCg0KUmVhbGx5PyBJIGNvdW50IGFib3V0IDM1MCBwYXRjaGVzIGluIHRoZSBp
bml0aWFsIGJhY2twb3J0LiBUaG9zZSBwYXRjaGVzDQppbmNsdWRlIG5lYXJseSBldmVyeSBORlNE
IHBhdGNoIGZyb20gdjUuMTYgdXAgdG8gdGhlIGVuZCBvZiB2Ni4yLiBXZQ0KYWdyZWVkIHRvIHN0
b3Agb25jZSB0aGUgZmlsZWNhY2hlIGZpeGVzIGhhZCBiZWVuIGFwcGxpZWQ7IG5vLW9uZSBhc2tl
ZA0KZm9yIGEgImZ1bGwgYmFja3BvcnQiIGZyb20gdG9ydmFsZHMvSEVBRC4NCg0KT25seSB0d28g
bW9yZSBwYXRjaGVzIGhhdmUgYmVlbiBhcHBsaWVkIHNpbmNlIHRoZW4uIFRocmVlIGlmIHlvdSBj
b3VudA0KdGhpcyBvbmUuIEFsbCBvZiB0aGVzZSBpc3N1ZXMgaGF2ZSBiZWVuIHZlcnkgbmFycm93
IGNvcm5lciBjYXNlcyBvcg0Kb2JzY3VyZSB0ZXN0IGZhaWx1cmVzLg0KDQpUaGF0IGlzIHF1aXRl
IGdvb2QsIGlmIHlvdSBhc2sgbWUuIEkgZG9uJ3Qgc2VlIGEgcHJvYmxlbSwgZ2l2ZW4gdGhlDQpt
b251bWVudGFsIHRhc2sgYW5kIGxhY2sgb2YgTkZTRCBzdGFibGUgdGVzdGluZyBpbmZyYXN0cnVj
dHVyZSBiZWZvcmUNCkkgYmVnYW4uDQoNCg0KPiBJbiB0aGlzIGNhc2Ugd2Ugd291bGQgbmVlZCAN
Cj4gDQo+IENvbW1pdCBmNWQzOWIwMjA4MDkgKCJmcmVlemVyLHNjaGVkOiBSZXdyaXRlIGNvcmUg
ZnJlZXplciBsb2dpYyIpDQo+IA0KPiB0byBnZXQgVEFTS19GUkVFWkFCTEUuDQo+IEkgZG91YnQg
dGhhdCB3b3VsZCBiZSBhIGdvb2QgY2hvaWNlLg0KDQpJIHdpbGwgbGV0IEdyZWcgYW5kIFNhc2hh
IGRlY2lkZSBob3cgdGhleSB3YW50IHRvIHByb2NlZWQsIGJ1dCBpdA0Kd291bGQgYmUgd2lzZSB0
byBpbmNsdWRlIHRoaXMgZGV0YWlsIGluIHlvdXIgcGF0Y2ggZGVzY3JpcHRpb24uDQoNCg0KLS0N
CkNodWNrIExldmVyDQoNCg0K
