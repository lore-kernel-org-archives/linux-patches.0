Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368236A33F
	for <patches@lists.linux.dev>; Tue, 28 May 2024 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716929775; cv=fail; b=axim5VKmjAHagxQQupwk6l7eaybGJ0NG7NYGDFyvZw8scKvfH2F/KK7/mYy1aqdXeU+2dmHL4nDJSFVkSrUQoaNTmTY8fQBNjZJ4Wmod6xb242tjBRNgK3LRFhXHWpnT1qIWs8Hz0+SoYDQTEe6LxHRYl+mV4yt7dKgR4aNDghc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716929775; c=relaxed/simple;
	bh=aCwEcN2ngFQxD3PAbnOwESpZM40NoQfDeRJvL+r/E6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tKyuHZyUTLE13WvdHwtSbp8yTJvQJ+mqAA47gfHXbCMkxUMLCZYRy9BDZv1pjDcIdgxcbStRpPRMODzRBMAoqqR1+zHyaZr8jY7Fqe1S1PYj7OEg6PYpwVFEYayiaAuMToVCJyyh8GzgFTFO5RhwYISzB3i+RI+pEnKOA9IRoUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SILDs8012580;
	Tue, 28 May 2024 20:55:42 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DaCwEcN2ngFQxD3PAbnOwESpZM40NoQfDeRJvL+?=
 =?UTF-8?Q?r/E6g=3D;_b=3DTamos6xBs/QriNIhOH/dWxTTyPdfLCu905FuD6lEfsR3ui4ow?=
 =?UTF-8?Q?Zxg3abO5dbfRhyLnCUQ_bMVq9RghmTGPmt9uxSBajzkQdwvXY2x/wjKb1gZUJ2W?=
 =?UTF-8?Q?A1573uFC/xD5hAGmuJ6jR/tnx_LcY4zsAoUxTRJIUd4PPyEun3HlnpVyDECsSJe?=
 =?UTF-8?Q?0lL91RiOJTLtcqf5rIUbPF5ZYpn97dl_02ESx86kGgiHx4chbABbM755mI+a09q?=
 =?UTF-8?Q?M8ZgxFnT1VhqyxXalVpSo9c7tQmp0wDPFPnI6_6XrkdeSUPBoUEZxCI1Ml0dvrl?=
 =?UTF-8?Q?p7h4rF/Ii9wH+ajqeRj7/Dw2W/AoCEOJO1gaCPxXFCb_vg=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hu5d7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 20:55:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SKIUWm026580;
	Tue, 28 May 2024 20:55:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc506d77x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 20:55:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d458NYpCFFGa6en1T+9QVlOM3u0O6IYMVSV5kKmqsexbOF0yO4xQzlsYlPNWfv7d0/Eupk+yU9VmohZGaUB8DC4pVDUJ6dG6UvbvvqDGPh1gwFlvUJUe/rYCv7P0AG05nadxMugC84s0UCSg7IwP140wgjuNZKdgqJfhX4Wwe5W882vaHdeYMRldpvTwqbBvtOPXVRzzKNJyMNGLkoaE5Bo+6eLGnXI5T1++P53iV4UhtsAexn3i1Lfph+fHSG5btwjxMzC15BR80eozIDPk9uHYF+luj0SYcm15/X3ZKEWaySpXSbUtsps3/w5sRurgAlWoAoW8w610UFDP8w3RLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCwEcN2ngFQxD3PAbnOwESpZM40NoQfDeRJvL+r/E6g=;
 b=Tj+acleDbpifu7hnfXgkfe+jIfqLp1Um8IIbx4OarfNb1OzNQuhPJbHrAkyS0/w5L7dnIMpEevT+enciBBd+D275wie8TqQvNMu7C0lCtr/5bRHbVdmfYVhh/Z5iPgPrXwpSAwtf86Dvfh+mQoEhpYsbmYvZ4PVrt6b6VX/Zb63iEkBhuV0V2/yUTMTgRoqdkMYyKkf0x5hjr97OUPY+Cw+NG6heGa7jMfP0xwBleJrdoqevTMvEz32fzzCU8URBL2Jxxt7ShA2VfiHCIvI8ov/DNsm8wkwyKqk3xJ7eShMms4BSr9LKrPVu3U2KQY6zl6KHqdl1pm1WtwrtLyt6Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCwEcN2ngFQxD3PAbnOwESpZM40NoQfDeRJvL+r/E6g=;
 b=QPj59qRbyYFxU2SpiOQKabMxxV5u+tx+wdEM3PdgsAjsYQt7Pycd/Lt6bdqCp5UG+pJiC3n/kfRwNgCMJncrUZh9iEJYCaeemEiHm9cXwAX048OqTepDA2h+jGIDwuYLjabWdlAZyBIJ+Akr1DP1gp95iJUTdGYWWkzMMVOIeDQ=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB6688.namprd10.prod.outlook.com (2603:10b6:208:418::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 20:55:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.7611.025; Tue, 28 May 2024
 20:55:38 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Brown
	<neilb@suse.de>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHasN4Kp5m/MZVFZ0aHe0MmQeirFLGsoDYAgAARwgCAAG8IgA==
Date: Tue, 28 May 2024 20:55:38 +0000
Message-ID: <0377C58A-6E28-4007-9C90-273DE234BC44@oracle.com>
References: <20240523130327.956341021@linuxfoundation.org>
 <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
 <2024052541-likeness-banjo-e147@gregkh>
 <8ddb4da3-49e4-4d96-bec3-66a209bff71b@nvidia.com>
 <968E3378-1B38-4519-BB85-5B1C45E3A16A@oracle.com>
 <8b6fe99f-7fa9-493c-afe7-8e75b7f59852@nvidia.com>
In-Reply-To: <8b6fe99f-7fa9-493c-afe7-8e75b7f59852@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB6688:EE_
x-ms-office365-filtering-correlation-id: 05b36122-16f5-4b74-595f-08dc7f58874c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|1800799015|7416005|376005|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?ZHBKYkdQUHAyV3h0YUhGOGJQSk1zRXB5SjBHRFRCcnVRUGxIQk9WVUdLWnlY?=
 =?utf-8?B?YWZDalUwTE9Gb1M5SEtoOU0xdjJBeWJkbHhHaXE0MWNFYjQvcjRSUWhtL3pQ?=
 =?utf-8?B?Nk5ieWdkOTMvZ2NTTXNsaFcwTEg0RlNBK3Z4bi94aU90WWxQYnkrWWdkYVFl?=
 =?utf-8?B?cVgyRXZJd09ITGhJZzVpVHpSTFEydFZDOVZzVlllaE5ZZUZUR2VoSGYra1ZH?=
 =?utf-8?B?WlQxRXNsNjVESFlFYXdmcXRWZ3EraFFuOUhJMDl2blhtNitnc3pPRGI4b2Rw?=
 =?utf-8?B?Z01XeWt0c0pBSG9RTVhMWjJVM2svSTIzd1FKZ25lcHAyb1ZITUhHVEFFdDB6?=
 =?utf-8?B?Nm1WU1RxSWZYTHNUS2d0MjNpbVpJUnI3akNoNFo3Yi9oU2g2ZWVSbk8zYkVr?=
 =?utf-8?B?d1JDYVNwSDAwdkVzc3MyeEFwNSs4WS9IbVZQSWo4TXo2UVIva1ZrdTFlZnJy?=
 =?utf-8?B?Z21FN2NqalM5TVdoMzZHL3NhTWFBY2lGNlFlcWdaVUNNK0xOQm1ZRE5SSkhQ?=
 =?utf-8?B?TGJNMnFQdHl1amNwczNNbWkwQ0FBNWQrb3NJeEFhTjNlY3hoVUM3U3A3VlNZ?=
 =?utf-8?B?OS8xaEJneGFRUUJUWEU2dmk5NndQWXNia0xwU1RnSUNvTHQ3aUZ1OHQ4NVBQ?=
 =?utf-8?B?Nk83RGJ3UXlPTFMvakg1SGM4TUxYZTRiVEJOK0d5Y3FTRUpBVmNqQk1pcTJV?=
 =?utf-8?B?dXZBUTNrTnJ6bWg0UitIaXRQSkkwQmNrQVZLNHB6blJjV2VmdFllYmxUSkN1?=
 =?utf-8?B?VU5lUndwZ2dQR2kya3Y0S2MxUmlTRzFyWWYxUGZrSUVlMWdhYUl4NGVwdFhI?=
 =?utf-8?B?U29Bd2tEcyt3eGZlZ3EzWHVVaFZMOCtVUEdvaE1rSGVLbEtzYmtYZWliM3VW?=
 =?utf-8?B?MG9jZEhhdWw2T0NBYU9vNDlxb2RBMS8ydXlGSDk0R0NYVWMxMnprcFZrM25x?=
 =?utf-8?B?VVJqZGczaDZqUGRxYmVLRDVvMUFoTXVqTXcyU1FkU1BGd2hoV3BLRCtPYVIr?=
 =?utf-8?B?SDBTWTBhRjJzQjAxVFJpSk9qbnlMQVkxcEJaWGNFV2VISWFZZkV2aEVrRGFz?=
 =?utf-8?B?NmZ6Q3NlMmpjYWxjTTN1Z1kxTFlsWVozRmhudlFKdTRuMWdBZnFIOEpodU4z?=
 =?utf-8?B?b3JQUVVwZWMwNGQrTEVlTEZnS0s3VnFlWkYvTVVPN1ZrOUptdVl6MkRvWms3?=
 =?utf-8?B?bU52dzVXaTk1VWxVczM5L2RyU296NisyY2hlcm1xYWVIT3pFZ3kzWlRaeHh0?=
 =?utf-8?B?UUVaRklSdXdodnlXWVBGWGVWbTVkMktqNlBFRjZQb2p3eGpWWUVIUC9EY0JR?=
 =?utf-8?B?WDM2bnhlcFUyTkVTYjVrbzdoWnlPUVorcU9YMnY5cFlKaEczajJLUytGTVJQ?=
 =?utf-8?B?TVhOMXpQTjQzdXhTL1ZQb0lsVWlqa0ZsQ0FQbjZ4L3B6QzlRVjhhR0xsK0k2?=
 =?utf-8?B?YjI2OVhjem9RZmdYTXUrTWVjSmdtejUwUm1NWFJPRjRVMWpJZC83VWxFU2FP?=
 =?utf-8?B?T3lPSlBRUW96QkZraUh0VXhWd0g0UlVZODVJaCszVXZ5TEJhejUrWHFwYTBK?=
 =?utf-8?B?cmNFUEltNklySHBqUFFtZC9lK0tDdzFESUhjMjNyYU1ZTElSRmxFWWkzVE1S?=
 =?utf-8?B?dGVRSDJVb21uZ1lMR1lpdEdHL3hWWkRaOFVGSmp5bE5NRHJNOTVKbjBwRlg3?=
 =?utf-8?B?cXBEYlZtdWJMYUhpTXhBc0tyQ2I5cVRyUUF2WU1nZVlCOXlqUi9qQ1NBPT0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?MFVJbnB1TDNFNDZDNStLcUc1c2ozYnNHcC9DTCtmanhKdjZmZVAxWGVpak1i?=
 =?utf-8?B?TG1CVmZHLzdYRENJMWk4WDhzdnNnRmZ0MEZ3N2xKSzcwQlF3K3kwL21VbGRk?=
 =?utf-8?B?SmdMWnJrckRPVlI4OGsydUM4eHJjNFR1bG1xODBtdmptQ2NVdFdlQkVRc0NK?=
 =?utf-8?B?bnBXYU5KaDhwV3NEYXVqL3RXaVMrdlFIMEVIQXVnbEppcS84aXhxVXhNZkJS?=
 =?utf-8?B?Y2NTelhyL3Ixc0tLOVc1L2xTOHA5S1R1d3JTY2grQTU2MkV6Z1JuVXJoc3c0?=
 =?utf-8?B?QjhVNzhiYmNhdEl3OWdHZld5Y1VQVmRjbDdqdkpBTFU1bUcwVUpHOXNYZFIy?=
 =?utf-8?B?UXJEZ0VoNlFGRDlWRVFpSG8zTWd4aGJZWTlDMlFabUd1YkZCZzFpKy9neFFY?=
 =?utf-8?B?YW1PejZmWXo4MjExeU42dVRMVE9KOW9XT1dvdlRGMjUxWE8rczYyUFhBNkJF?=
 =?utf-8?B?N1ZXbklzdGhUcWFLUm9KSWdSNUMyUUdaMGxQTHZDZTB1MFZoaGNHVzNCQitM?=
 =?utf-8?B?MUd2V0Zqb05HU1dJZnZXc0xFb2dhZ0pabmFnR1l3NnQrckRuek9iWE1hNm1v?=
 =?utf-8?B?bnBHZTUvcGVMZUtmU29DYzJOVGs0dTdYTTZGUUZvUzYrRGJQY2hJclNDRGY1?=
 =?utf-8?B?NGpZbEVvbC9NenZCK0wzYWdvOEtBRDJkMjRDVlphVlZ6aW1VTUY0MzNlWkc1?=
 =?utf-8?B?cUxETWhjZEZhNUlJOUVQVTZEQVF1bnZIeTJWajFtTjZQMHZIc1Y3Wk1sT0Fx?=
 =?utf-8?B?R0t6RGlNYi9GbWhCZWVBd3ZzL1UvSUNFb050SHVLdWRJTHl5M1Q2NjMwZ3Jp?=
 =?utf-8?B?bzlPTFJRbFFZK1VFS1c4alhiZ2cyWFNDaElMbG5MN3BQcHhZRm5JWlBLclVE?=
 =?utf-8?B?VEgxWkRxTlV4b2UyNGdLemE1dmd6Tk1zQXZiUkVEQlpTam1Ta2xwTGMzbXo0?=
 =?utf-8?B?ZEpPSitjV2ZnRlJLOERta3VtU2hWMVRzbHhLbWlheHVqVGlCSFFqeEovK2x1?=
 =?utf-8?B?Tk85MzIvdXRTaForM1I5Ri9wbzc0RjgzU082QjRZNWw0NUZTQ1hUM2xWWjAz?=
 =?utf-8?B?WEFzR2Z5bmtRQnhCTnJMa1dramFXVnc3Mkg4VGphSGVwRWluVjNpejVmSjNp?=
 =?utf-8?B?bXYwN0hpN3U5bEEyUkFabEtGelBvSTBscy9zYWxMZHpvdC8wWmtROVdkQk5S?=
 =?utf-8?B?c05wTFpjS2d0TWIvMDZ0ZExkenBsb25nY0twK0lja25QQTNsa1RxcVVDNHJY?=
 =?utf-8?B?a2RMbmdwRk8raGN1V05ubFhjWVl1REVzMG9LN3BLQmFYSGZBdnJBREN2dHl3?=
 =?utf-8?B?cTc2VGxjQjlTLzQ5MjJnSE91RTlxTkxaNkZYeEVoUERmcmNUa2xCMFJHeWkw?=
 =?utf-8?B?ZFlxcmNOakFBVVd3OFdnaENnU0xhcWx3S1pIM1JZcStRTUk5MmpXWmQyZHh0?=
 =?utf-8?B?MHQ2Z3QxWWp0Sk5KVEtSYzQzMVU3Y2JrMFJ4WTZFclhiNm9MaFJEWG5wY1Bv?=
 =?utf-8?B?L0QyMFdncjkrVVNjRVJ1dkl2cTBkZFhmblhsbExzQ01peEFyYXoyZWV3TkZM?=
 =?utf-8?B?aTczTE91eXY2ZXVIajN4ZTFXb1BVbzVwWDVEUHU3N0RiSldhb3llOEplZzlP?=
 =?utf-8?B?Smk5TkpFVXZSUjcyRUsvb2Y2QlhqQTFFakk0Nmk4bU53YTVhZUlnOVo2b3l4?=
 =?utf-8?B?K25aYXFDVURjb0s1bGJadE8vMXJpYkw2RG5kV2xWQjhON0FWblpvWFZsZmMz?=
 =?utf-8?B?SXNzQ0lDZlZlc25PTTRxWmhLcGtKdzVXaVdBbFZtYis0M0NiVTFLdVV6OEhG?=
 =?utf-8?B?K2lpc25Za1pWVHZnQ040clFRR3pNcFJ1UkZVZFY0a1JNcHhHeG5STmt0bHlW?=
 =?utf-8?B?UFhwb0dVZEM0djZGRDlnVUFBYkNqZ1pzTUQyOXh5VTBpblRpbEZwRkZCSVVj?=
 =?utf-8?B?RGpCc3VhaG9JNXNpRHh5eXN5RDduMXUxOVlDbjhKTTdJdlJCb2U2azdsdndI?=
 =?utf-8?B?VDdmWnlGVTlONFpoOFYweWdkek5hb0J1VmRTQllTNlhoUlFJZDlHbHVyYlpO?=
 =?utf-8?B?Z1FjNU5PUEdoN0JlMVorYTJ1bWpSZ09qYm5RSHpPNXRSR2RlRlI1dzlmTlZW?=
 =?utf-8?B?ZTRCUEw1TVNEd3I0TXl0U21VTXE2YVJ1ZHZPckNvRW5yRXVRZGxpek9ORlBp?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E631BD6FB2500A49A2419381FB9F48D2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kstU76PpoXLgjRBygdY46d5i01XFkHLhyIIOI4X8ku21Flsu3t0ds2BhAcx9eP8R45BnWj1dgHv8iF3TW8sxd3CDkAGBNuEZLYLAaZPIcQaw0avJkdl0mbJobeJypoT4eS/kFFc8IL4lmjzp/HB02je1wgToU0YUlvzmrNzLhKb9DO6Ffldpy7tflreOSJsTyWZDHaxwSrZ0v8pKkS1EITuJXGwWI0HiLsASJyNVRrgRzUeqEMn+/q2UQfGFTaWyUXpM63y5yMR1ABpsnJHSLxVpSRIO001z92mKeTrBitqjpfzEslNghtc/rxz1Bg9zmQYop3QLqAU+BidpL2VVIKwIuvcstuL0oHgKEbTzy1G25nD3DS3kWxtmsBPSsHFL2XlOet7u1utJo64DM7AcO5/Mz6d42L8mrDo54Lr0Bv9mn8++ZP/tZ+l7X1iW2bqwHSvLjXJlfasTomADUxK+y5GYdh+w6IVbLfL50aF17DaKwD97mJ1K6L+aywUzBF8brb+3H4o3mV7qw32Xt4x5AdlQzqRPy07S1ITemRuJaCgv3kTAgIwOnkPGwSJRZF4RdGs2AMJb33E5dplsBbfqNY11j923BsMiKz35Q3hDpHE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b36122-16f5-4b74-595f-08dc7f58874c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 20:55:38.2984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +uYtQm1b43v/azso3IAFx5efGzqIaLhqZM+otIn7fuEMGK2gc04LQ5uicKXRtUtXmeUXT6NXGM4P0zV3ouecnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_14,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280156
X-Proofpoint-ORIG-GUID: k-rNVVhulpQFSbMwM8fVKyxOCSiDhFzm
X-Proofpoint-GUID: k-rNVVhulpQFSbMwM8fVKyxOCSiDhFzm

DQoNCj4gT24gTWF5IDI4LCAyMDI0LCBhdCAxMDoxOOKAr0FNLCBKb24gSHVudGVyIDxqb25hdGhh
bmhAbnZpZGlhLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gT24gMjgvMDUvMjAyNCAxNDoxNCwgQ2h1
Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4+IE9uIE1heSAyOCwgMjAyNCwgYXQgNTowNOKAr0FNLCBK
b24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gDQo+Pj4g
T24gMjUvMDUvMjAyNCAxNToyMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPj4+PiBPbiBT
YXQsIE1heSAyNSwgMjAyNCBhdCAxMjoxMzoyOEFNICswMTAwLCBKb24gSHVudGVyIHdyb3RlOg0K
Pj4+Pj4gSGkgR3JlZywNCj4+Pj4+IA0KPj4+Pj4gT24gMjMvMDUvMjAyNCAxNDoxMiwgR3JlZyBL
cm9haC1IYXJ0bWFuIHdyb3RlOg0KPj4+Pj4+IFRoaXMgaXMgdGhlIHN0YXJ0IG9mIHRoZSBzdGFi
bGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUgNS4xNS4xNjAgcmVsZWFzZS4NCj4+Pj4+PiBUaGVyZSBh
cmUgMjMgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywgYWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVz
cG9uc2UNCj4+Pj4+PiB0byB0aGlzIG9uZS4gIElmIGFueW9uZSBoYXMgYW55IGlzc3VlcyB3aXRo
IHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPj4+Pj4+IGxldCBtZSBrbm93Lg0KPj4+Pj4+
IA0KPj4+Pj4+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBieSBTYXQsIDI1IE1heSAyMDI0IDEz
OjAzOjE1ICswMDAwLg0KPj4+Pj4+IEFueXRoaW5nIHJlY2VpdmVkIGFmdGVyIHRoYXQgdGltZSBt
aWdodCBiZSB0b28gbGF0ZS4NCj4+Pj4+PiANCj4+Pj4+PiBUaGUgd2hvbGUgcGF0Y2ggc2VyaWVz
IGNhbiBiZSBmb3VuZCBpbiBvbmUgcGF0Y2ggYXQ6DQo+Pj4+Pj4gaHR0cHM6Ly93d3cua2VybmVs
Lm9yZy9wdWIvbGludXgva2VybmVsL3Y1Lngvc3RhYmxlLXJldmlldy9wYXRjaC01LjE1LjE2MC1y
YzEuZ3oNCj4+Pj4+PiBvciBpbiB0aGUgZ2l0IHRyZWUgYW5kIGJyYW5jaCBhdDoNCj4+Pj4+PiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RhYmxlL2xpbnV4
LXN0YWJsZS1yYy5naXQgbGludXgtNS4xNS55DQo+Pj4+Pj4gYW5kIHRoZSBkaWZmc3RhdCBjYW4g
YmUgZm91bmQgYmVsb3cuDQo+Pj4+Pj4gDQo+Pj4+Pj4gdGhhbmtzLA0KPj4+Pj4+IA0KPj4+Pj4+
IGdyZWcgay1oDQo+Pj4+Pj4gDQo+Pj4+Pj4gLS0tLS0tLS0tLS0tLQ0KPj4+Pj4+IFBzZXVkby1T
aG9ydGxvZyBvZiBjb21taXRzOg0KPj4+Pj4gDQo+Pj4+PiAuLi4NCj4+Pj4+IA0KPj4+Pj4+IE5l
aWxCcm93biA8bmVpbGJAc3VzZS5kZT4NCj4+Pj4+PiAgICAgIG5mc2Q6IGRvbid0IGFsbG93IG5m
c2QgdGhyZWFkcyB0byBiZSBzaWduYWxsZWQuDQo+Pj4+PiANCj4+Pj4+IA0KPj4+Pj4gSSBhbSBz
ZWVpbmcgYSBzdXNwZW5kIHJlZ3Jlc3Npb24gb24gYSBjb3VwbGUgYm9hcmRzIGFuZCBiaXNlY3Qg
aXMgcG9pbnRpbmcNCj4+Pj4+IHRvIHRoZSBhYm92ZSBjb21taXQuIFJldmVydGluZyB0aGlzIGNv
bW1pdCBkb2VzIGZpeCB0aGUgaXNzdWUuDQo+Pj4+IFVnaCwgdGhhdCBmaXhlcyB0aGUgcmVwb3J0
IGZyb20gb3RoZXJzLiAgQ2FuIHlvdSBjYzogZXZlcnlvbmUgb24gdGhhdA0KPj4+PiBhbmQgZmln
dXJlIG91dCB3aGF0IGlzIGdvaW5nIG9uLCBhcyB0aGlzIGtlZXBzIGdvaW5nIGJhY2sgYW5kIGZv
cnRoLi4uDQo+Pj4gDQo+Pj4gDQo+Pj4gQWRkaW5nIENodWNrLCBOZWlsIGFuZCBDaHJpcyBmcm9t
IHRoZSBidWcgcmVwb3J0IGhlcmUgWzBdLg0KPj4+IA0KPj4+IFdpdGggdGhlIGFib3ZlIGFwcGxp
ZWQgdG8gdjUuMTUueSwgSSBhbSBzZWVpbmcgc3VzcGVuZCBvbiAyIG9mIG91ciBib2FyZHMgZmFp
bC4gVGhlc2UgYm9hcmRzIGFyZSB1c2luZyBORlMgYW5kIG9uIGVudHJ5IHRvIHN1c3BlbmQgSSBh
bSBub3cgc2VlaW5nIC4uLg0KPj4+IA0KPj4+IEZyZWV6aW5nIG9mIHRhc2tzIGZhaWxlZCBhZnRl
ciAyMC4wMDIgc2Vjb25kcyAoMSB0YXNrcyByZWZ1c2luZyB0bw0KPj4+IGZyZWV6ZSwgd3FfYnVz
eT0wKToNCj4+PiANCj4+PiBUaGUgYm9hcmRzIGFwcGVhciB0byBoYW5nIGF0IHRoYXQgcG9pbnQu
IFNvIG1heSBiZSBzb21ldGhpbmcgZWxzZSBtaXNzaW5nPw0KPj4gTm90ZSB0aGF0IHdlIGRvbid0
IGhhdmUgYWNjZXNzIHRvIGhhcmR3YXJlIGxpa2UgdGhpcywgc28NCj4+IHdlIGhhdmVuJ3QgdGVz
dGVkIHRoYXQgcGF0Y2ggKGV2ZW4gdGhlIHVwc3RyZWFtIHZlcnNpb24pDQo+PiB3aXRoIHN1c3Bl
bmQgb24gdGhhdCBoYXJkd2FyZS4NCj4gDQo+IA0KPiBObyBwcm9ibGVtLCBJIHdvdWxkIG5vdCBl
eHBlY3QgeW91IHRvIGhhdmUgdGhpcyBwYXJ0aWN1bGFyIGhhcmR3YXJlIDotKQ0KPiANCj4+IFNv
LCBpdCBjb3VsZCBiZSBzb21ldGhpbmcgbWlzc2luZywgb3IgaXQgY291bGQgYmUgdGhhdA0KPj4g
cGF0Y2ggaGFzIGEgcHJvYmxlbS4NCj4+IEl0IHdvdWxkIGhlbHAgdXMgdG8ga25vdyBpZiB5b3Ug
b2JzZXJ2ZSB0aGUgc2FtZSBpc3N1ZQ0KPj4gd2l0aCBhbiB1cHN0cmVhbSBrZXJuZWwsIGlmIHRo
YXQgaXMgcG9zc2libGUuDQo+IA0KPiANCj4gSSBkb24ndCBvYnNlcnZlIHRoaXMgd2l0aCBlaXRo
ZXIgbWFpbmxpbmUsIC1uZXh0IG9yIGFueSBvdGhlciBzdGFibGUgYnJhbmNoLiBTbyB0aGF0IHdv
dWxkIHN1Z2dlc3QgdGhhdCBzb21ldGhpbmcgZWxzZSBpcyBtaXNzaW5nIGZyb20gbGludXgtNS4x
NS55Lg0KDQpUaGF0IGhlbHBzLiBJdCB3b3VsZCBiZSB2ZXJ5IGhlbHBmdWwgdG8gaGF2ZSBhIHJl
cHJvZHVjZXIgSSBjYW4NCnVzZSB0byBjb25maXJtIHdlIGhhdmUgYSBmaXguIEknbSBzdXJlIHRo
aXMgd2lsbCBiZSBhIHByb2Nlc3MNCnRoYXQgaW52b2x2ZXMgYSBub24tdHJpdmlhbCBudW1iZXIg
b2YgaXRlcmF0aW9ucy4NCg0KDQotLQ0KQ2h1Y2sgTGV2ZXINCg0KDQo=
