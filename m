Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CECF143882
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719344487; cv=fail; b=ZzrxUkpbDnHjaqTjroaq5MOJT8lbgju0J8BCJaZoG3K2sZyfTrfwm45Bazn+8B4gwDoFU+KFZp1wHPb7+xxugSdWfoWiI7jK1vYtS84sW2daNNFGKturRURkGQAvo1wImImVe4AUSojY2zscqA5aGDAUYrLi4Kun0Sceen02hBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719344487; c=relaxed/simple;
	bh=KOMUT7BTzbo9HusP1xM9XHezjHjqCtcx7Lq0uKqiocs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FMT0vIkhg/2ztCM/sHLPUKDKlKD38yNq2wk2qxfJqtxl7Z0xNnCEs8jI3cmsBdFimoYco0LiErE26qjCr8q8NmpKKzvqpWmxCTo8hKo9txuUCElS0vZZPt5AhaNc5hO6ZBRVQNdq7yFYh+ZvQTCjYpaGMxaDvNgPaAoAtt5y1Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m7Wlg3jP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e9if+Db2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m7Wlg3jP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e9if+Db2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45PIfSmC012768;
	Tue, 25 Jun 2024 19:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=KOMUT7BTzbo9HusP1xM9XHezjHjqCtcx7Lq0uKqio
	cs=; b=m7Wlg3jPQc/Px6QoEowm+BTwddIdlHZ2x/T3OiZKjZUdRp8A/TgWSHaBh
	eP/ojYiiYZYA6IymBBIN27a67NVLDF0NFKhzYtGtJYIapeM0mQlIN/6NxGCrieCh
	k3ylMlQd8XrP5pRq417Vb0jrw87TgE86tJKO5NA/furgtqMf0TYJL/RX/2t/da1x
	nJdo79Pq3yFlM2EkUhc9Y2rEKiqYAlUOXX8BoYijWxohuIdIQ3ixhDtIamiuI8i8
	4vfItXICFknz8T88DFWAKHqFyzdOgzTB9O9lnJRt7zLKU+j1uUPbZK5k2yCZUtGl
	HQ8Rs1vb19LTVSvmDeI8xwL7IJ3cw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywpnc9w0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 19:41:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45PIGE29001314;
	Tue, 25 Jun 2024 19:41:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn28sp5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 19:41:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enAMK3t0X+HuktIS3WmVwmBh1XuHleX11quPDBhCcPBvY+GiBQWHIAC8xDy4N24BIq+4DlmtrPbP1kC3WSFwqH1N/OeYXIOU+gU+VOZjM9aWp9sdQwycxpfsSUcomf16Q2RcgXGm/pGjaSJei4TdC9k3UfP7A00O4VE91py4cRvaA2WFCunG824maJWMd5iNIP5mNEPz7i6IyimLohScEbHjNjRd4DuTTj/O/bBsa6LG7I7i6VueaR9s6rzjEdZiPae6NSVfmtJZT6Jk3IDZS8j3Eov7UaQd8oYvOgxSYR5OdL9gXcrGcifrFPNrBLUpb5+HxeOVxCXmc5kyv4MzqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOMUT7BTzbo9HusP1xM9XHezjHjqCtcx7Lq0uKqiocs=;
 b=nhMRg0FB+TTSlS3lhCFQs9vN3Fgg5lcoQyI/StkgnR0FtS/UNOzd9sCJWUnkQSMrnot16rY36KJi56YLfVYGfjx67d4ePpYc+PzAle7BbQc1VwUvXDeDSOV7OIaCvCQJY1XimvaMTuNCUslfqHKUCuS136eQwGsJZBCAdn3yhAPf40rqNPln5EIorrOEBMBgd7s/1UgfniYmM94LYM59Ig/KFEDCmnE8/upCWzagxk5wSdAq+owHYW/owBwxPin45fJcyEdELTTNH+v5ZpO7HI7LmRdauyUwMtyk57ci73gSvZww0UwH2Fz9fNzH60kba+unXuvi7oy2+qVmdV0dUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOMUT7BTzbo9HusP1xM9XHezjHjqCtcx7Lq0uKqiocs=;
 b=e9if+Db2FnH2KISTAl5wu9EUnWEKuyXcd6RvPE4gZG7PWUkrUDeZMMs9tyZUPfoONQHl67SV8PpN4Nz3sTns7x8lhqK5TZSllhlGOgqXPxeswFitF7MGeN+ikQY76E52v8sVtN+DwieIw3693V0zQDvf24ozyr1OWKkK/n2mF2c=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SN7PR10MB6288.namprd10.prod.outlook.com (2603:10b6:806:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 19:40:58 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 19:40:58 +0000
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
Thread-Index: AQHaxxD2v5qwy652GEusd9rXWc6iOrHYlkYAgAAVRQCAACyGgIAAB1YAgAABnYA=
Date: Tue, 25 Jun 2024 19:40:57 +0000
Message-ID: <7442B6FD-6EC6-4C4E-A5F7-CDA1174E6DE2@oracle.com>
References: <20240618123407.280171066@linuxfoundation.org>
 <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>
 <2024062543-magnifier-licking-ab9e@gregkh>
 <EEE94730-C043-47D8-A50A-47332201B3BF@oracle.com>
 <cf232ba1-a3f3-4931-8775-254d42e261e5@roeck-us.net>
 <B5D1D979-253A-4339-AF15-5DB3B8503698@oracle.com>
 <88a0fdf5-ffc5-4398-88cd-220a3a996164@roeck-us.net>
In-Reply-To: <88a0fdf5-ffc5-4398-88cd-220a3a996164@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SN7PR10MB6288:EE_
x-ms-office365-filtering-correlation-id: 72672d9e-7a69-416e-49ca-08dc954ebc5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230038|366014|376012|7416012|1800799022|38070700016;
x-microsoft-antispam-message-info: 
 =?utf-8?B?UzRUd3kzSzczL25EYndLTEhnOEdnNW5jM3R0UWpKMkhwNitlaTl3ZGcwUkFI?=
 =?utf-8?B?Q1pzbHlCMkxEM0JxSUQ0UDJGSDdTWTY5N3l1TXloOFhyYzhiL1oxb0JKNU1v?=
 =?utf-8?B?V2tLc2pJelRkd1VrMU1FS2tWTHdwOU5tdzEyM0FIT0dkK01OaCtYeWZ4QWha?=
 =?utf-8?B?ZjEwNzE4TTVFSFo2ajRITnRtVHZDd25BbVRHbmlnU0dyMzJqSWFBc2RsbnRH?=
 =?utf-8?B?V1FDckdMZE9KZEdPUWhGM1E3K2dCN2hhekxVMzVpbzZMdVI4RUl3RURhczR5?=
 =?utf-8?B?THlBa2x2TmwrQWprenFCTnNmdUhtSUhCSmR4VEt5enIrS2FUMEQwQkE4Y1Jv?=
 =?utf-8?B?Q2kvV0NZMGZoeHE3OXdmOHJNYVVQMkxYNHhKdUN2M3YwSlN5dW8zZzZ0N045?=
 =?utf-8?B?aTBxU0xYZzJMRkZ3QjlNTXhNMWcwSzl0Y0hNZXp3K0MrTUs1cm15K0lsSjNj?=
 =?utf-8?B?Q200UmJCemEycTJCZzBWRW9jRnIyOTdHRFVRZFEzSDdQU1NIb2pvZFNJVTIx?=
 =?utf-8?B?cFNEOFVWeVdaOE4zeW5OdHROMXY2dUpwZ1U2aGpmSlBoSG80ai9sRDhXbmZ4?=
 =?utf-8?B?SHE4SmQyQzYxdFRYNTJabzRlSE00b0xFSFByb2RnTzlmaXgxcVVjSExHeEs5?=
 =?utf-8?B?cXpKam1QR3UvQ2RUbnQ4NWlITFV4YndVdEtEV3RoSnVoN0NEazcwcEgwMExj?=
 =?utf-8?B?VXY1Q2hkeU9uZCtLNm1JbGtVaUY0amcyeXJDblE2Szc3MVZFZU5RZXpLZkhy?=
 =?utf-8?B?VG9aM2g1OWxUblAzamlDaHZrWFlVOFowR1BsUlNsd1drZmdaZUMzdG0wVHl3?=
 =?utf-8?B?dDNWVThnRXU2a0g1WmRXOTlNZ0tjRFZpVmZnUmJjckpCS0NVbkJGQm5BaVJ6?=
 =?utf-8?B?SXh4eGNjTGVhRVEvMWx4aUU4V1NFd1RsZXR4c3E0c1B5VmU0cGFJZTJJZGxD?=
 =?utf-8?B?b0RLS2JKbXVxME8rYnE0YlFRQTQvUFFlWkliUnUvbWpaVVdCblVEcGtXTzVi?=
 =?utf-8?B?alZPMUp0bzVmRUtOMHVxZXovaS9LQ0JIdS9tNUl6MWE1VTlpalZzdCt2dEhh?=
 =?utf-8?B?cm43Ymw0RmpuV1Zodmp5UTlRNk9LelhIdVFNSGdyZkt6cHVvMWV5KzdPMTJX?=
 =?utf-8?B?ODMzN0wwN3crR2xUVEhYUm90YkZyaVBhWDgycWN6RzRIL2QrSmxBNWMycFFC?=
 =?utf-8?B?aUZGQ0U4TFJOaENUa01sYXIyV3VxT1BKczQxai82ZWF1RjVBd1J5RStrS2Vq?=
 =?utf-8?B?cEhTNXpDZVZtUG5nbFp0a0h3U1JWT24vN2JHVWR2eDRhTFBBbFRkbmVHVmRv?=
 =?utf-8?B?QkFaaUlxSkR5WDVwYy9GWGQ0OUJQZlNBcW5nWElhYXhEUnVibnRwWUcvMHl3?=
 =?utf-8?B?akpDYmJnSENXTS94NXBlNHBhMFR1WEhBcGVsbkh4bGxxVlRpTHFLTkZiYXBH?=
 =?utf-8?B?c2hoVTl4RFNyaElBNDNDWjN5aFZvT3Uwdlo0Vkp2NHdQYVl0WTBoTVpXZWZm?=
 =?utf-8?B?ZTdpK1ZJL0tlSkdBK0p6bDlOc0NnRllRdWM0YVd2eitlUEVabkNxemZoQTBV?=
 =?utf-8?B?Slg4NzlzeGN4U0Y3LytKa3Z6ZWFhZFF5eGpRb2FMOVFnQllLaklVeVZQM0J4?=
 =?utf-8?B?SWcxS2FYd2FFTk5xZXQ3dGJwUm56eE5EQlBnM0wzcGZSQ0VMVXlRUXBHSTJI?=
 =?utf-8?B?emlzeUw0WE9mSk56VlBneEVlS1FzV1dsY29xdzRYRytzYUN5NHN0K1RxdExG?=
 =?utf-8?B?L1RlWGtuS0xRTnRuOUo2TG4rblZaa0JMUWZqUkRKWmVPTEJlNk1CdDhOcC8x?=
 =?utf-8?Q?HXlkUe97TxLne+KZaf8nG31s37QWRwdIpyyqs=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(7416012)(1800799022)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TGhzTEhpZTAyNWVlSUlvZHAyZGJNS1p4YUZvOWsrK1RLSFIvZy9qZ0dFZVRs?=
 =?utf-8?B?V2d4RitIcEtpS2ZHK0pCaUk4WkRsRzRFRWRPRFlKdm1tRW1xYWtDQTEvaTBP?=
 =?utf-8?B?TFBZNXAxN203OUN4T1FwZVFXdXQ4WElKaVcyZ2lReVlPSkZBT3ZVeHI1TjZs?=
 =?utf-8?B?ZDUvUDFPSjdTa1FkYVFFeVE2YlJZZzZaOWkzblhHL1QvT2hIdzdzVVc4R2kz?=
 =?utf-8?B?VzJ5K2hFMWIzVXhMNFlhQTgrdWlNUWJQam9wVXkzeFRGTUgwdG5tM05Vc3ZP?=
 =?utf-8?B?TG5iaUpqUzNJZGs2Zk8rRkNkVlZ0Y0RoT3MzT3FXQUdMc1J0NEJrSzRlQ2o3?=
 =?utf-8?B?S0ZXcVhTaVRtLzl4TkNvNnhNTDRCdEV4U2hhK1RaNHVjbjBqNkgxMzB5K01G?=
 =?utf-8?B?VXB6VThCZGlXNzhPYW80MFFibE1VT3AvRWVpaVZtWXlNZS9YYnNmQVJYbjhH?=
 =?utf-8?B?L1QvZjVVVi9yQUc2WTVGQWdpa0txNkxRRjRnN3BQZkc2MjZmckc5QnNvR01k?=
 =?utf-8?B?MzZ2aHZta3BtSE9nVU01eldUSU5lbGw0aHMvOXFlMUNreTNuYm90dmFaYTNS?=
 =?utf-8?B?Qm51c0FacnF3S2pSUERXbm1Zam1XdTliWTJaSzZTRFJ0ZXRvbjlwVFl0bU9M?=
 =?utf-8?B?YlhHZTh6NW95eFVFZWtOU3luZFN1cmVNcWRJSDJYcjRxUGVHOXZHZHUvdEpI?=
 =?utf-8?B?ZU05QlAwd2xjckhtUC8rVGZKcGxNUUZIWEg2RjVLN0VZeW5pWGhRTkdrUnlT?=
 =?utf-8?B?MHZ2UlVVTXFIaTRGSU0rdFFMQVB0TS92MWxZSVQwSnFuNFV6Q3Z0ZjZPRTVG?=
 =?utf-8?B?c2YreUZHM3RiT0I2RDhxRkxsWnVJWHZMTWZDbmRpWVE5Y1lJUHdvQWdEYkVk?=
 =?utf-8?B?VlFsb20rK1llNEpwd0s5ZnJ4WlpEcUc4S0E4NnRxNTBBdm1kQ0VZWnphWm5R?=
 =?utf-8?B?Y1VnV0MrUGZieHIwQ2JWV1VpZUtmMTNUYkp0c0s0UFdhSE9GUFg4ZHVrUGk3?=
 =?utf-8?B?YS9lbkdNeDBwRXIwSUFLci9Cc2lwWmZPeHV0bHNvSEJrUk4xMTh2dWgvSWky?=
 =?utf-8?B?RkIwMkVCMGppbFhSZDdWd2Z4NCt1Vk5FMFNXMElDNWdLUlNUQUZacmpvUmFC?=
 =?utf-8?B?SlUxRkdOODJnS0kzdENNanJuVkhhUm1qQ2M0ZDFaYW5HVzlqNkRsL0REdkN1?=
 =?utf-8?B?NWt0TWs5czU2Rk9lVGJtWWc1Tnl2YVRUUkZ5VUFuRVVtWlI1cHJsZFZSS0pa?=
 =?utf-8?B?UDYyWGZ2bkRFUHBwRkNLRGJGUUZWSEI0dkpMd3JnWGduanMzTHRaRzQzODda?=
 =?utf-8?B?NEJCblZjQTluZmp3MFFWTE5oMEJ1emtVTUt2UWdORzlsZVJGTXpEWm5yaXFu?=
 =?utf-8?B?YjFhWllDL2JhcE9WYndHREc4K1JqMGxybVBYdkhlZVNqbWhzcXVPRDVKVVpz?=
 =?utf-8?B?UTBTcVRSeXJzWWtrVmM2L2VvTWM4ZkNaeCt3cHI1ZGFWNFV1cG9ja3R6VzMw?=
 =?utf-8?B?Y0dPb0RLbDQ4VkkyTVBWdkk4RlNpcnBXQ3h1d1VMQmpLUWJmdkRod3JGNlBi?=
 =?utf-8?B?TnM5dXRQN0xpRVM4UjR2aXNFM0JyV3REUnRMVTJwNGR4RkNDYndVSTJjYWhm?=
 =?utf-8?B?d1F1QmtCV3J6NzVwbnRieHd4dkM0eU5jZkxVV21QTU4zSW9OUzNpZnlRTnRh?=
 =?utf-8?B?Zld2SlJtUVh4SXp0Mi9zMmQwaThIeHNYazdkZE5hdHlhUkRuQ1pTdVhMUGYv?=
 =?utf-8?B?YmtNcmM3NUdXK25pblZXaE5RK1g4Wm04bStITHlmYTBpak5NM0J1MVB2TmRa?=
 =?utf-8?B?bXA4Q0orSm9qcHVEUllpQWtKbFhHRUJQNHMxNmtCelRQU0FmYXpnNjFjdE50?=
 =?utf-8?B?TmhzUkFsdk1aT2VhUi81RTM5WVAxZVoySkhPekVGalhFald4OGpZbnplczhv?=
 =?utf-8?B?ZzZlOFMvak92M2ZBNkt5N2ZBblZxRUlkUG96WjYrQlpzbUxTWDdZSUtjWGI3?=
 =?utf-8?B?R3k1ZC9NZW51dnJ1VmxhY2xBVEo5Njd5UHBnTlZiUW5YK3ZTa1dLeEFLcUU0?=
 =?utf-8?B?NWREcjMzMjNHOCthdzdseHl0TzNBeU05bGxBVFBsT2NlVWlBMHhNMURUT0dY?=
 =?utf-8?B?dVNRZFNKRkR2VURwU1p5TjZiZGUyS1lMY3hxQlcxc3lLUFVWRGkrenNFNlQz?=
 =?utf-8?B?eXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE03E669F2C473419D24DC4C0DEA2888@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LdeULQd0oaLisJWVqFudchdjMdBB/Utr3tBg3LFGss5G8ABtmWT1eJpPJVaccAxj8PuRiSjRpEZ6NW0tJdxwTXxIKeDB9FXlwso7D2w08tCJslK5PT0U+5YVYVeYgbyh5n5ISKol6jRHw4e0B80k8k5wgqekiSLP+o3hehlee29XNo1zJxlvv7YoXlfZHlGs4Dwq6ZdoLzAhDAVWPFukiaK7oREti1SVts8WOFmNrhCJMM7O1YDldSFaz8W37gbH6sJ7FHBi9xA6OUalCqPbgqwFRtYWNqOoXDV48vveUn2YQ3Jfq3fJIaab46o9Bzz1u9mNEEgcBgvlJVebXgFnRAYe4m5oTdij89v0Oews1sFUQr6yMhqb3u/LDoGPR7PYw+avmH55aytyWQ2uKs3zcclkG9ltwSaqNUUk7+gxDoAKvZ3o2NMfl2QuVsnUGnlVkQvTHi423cfbyKIvTztZKU7WuJ6WIWO+up10O/z26au1mTAaTr2gUjTVQIpjOElloFys9aoKzZbpVmcHAHskXaHqabuXiSHo9I+pFoGhGlVpcuem2dYtSEenJ7tBa00TT0NrRIbZMS6Bt8W1++ULSgVNKYdQYYOWeKDYzw/zSwc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72672d9e-7a69-416e-49ca-08dc954ebc5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 19:40:57.9731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N7BLIvzE1aSprLzB3q7DnCAPYyzyBIg5Mp+5lEGpBN41T0lE6K1rfErV9qE7Y72VeNrEhF+yHYR9cPmjK6WRtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_15,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406250145
X-Proofpoint-GUID: JNu5IGWaGaY8GrOwbMtqRn9xVw5e8pWc
X-Proofpoint-ORIG-GUID: JNu5IGWaGaY8GrOwbMtqRn9xVw5e8pWc

DQoNCj4gT24gSnVuIDI1LCAyMDI0LCBhdCAzOjM14oCvUE0sIEd1ZW50ZXIgUm9lY2sgPGxpbnV4
QHJvZWNrLXVzLm5ldD4gd3JvdGU6DQo+IA0KPiBPbiA2LzI1LzI0IDEyOjA4LCBDaHVjayBMZXZl
ciBJSUkgd3JvdGU6DQo+Pj4gT24gSnVuIDI1LCAyMDI0LCBhdCAxMjoyOeKAr1BNLCBHdWVudGVy
IFJvZWNrIDxsaW51eEByb2Vjay11cy5uZXQ+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIDYvMjUvMjQg
MDg6MTMsIENodWNrIExldmVyIElJSSB3cm90ZToNCj4+Pj4gSGkgLQ0KPj4+Pj4gT24gSnVuIDI1
LCAyMDI0LCBhdCAxMTowNOKAr0FNLCBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPiB3cm90ZToNCj4+Pj4+IA0KPj4+Pj4gT24gVHVlLCBKdW4gMjUsIDIwMjQg
YXQgMDc6NDg6MDBBTSAtMDcwMCwgR3VlbnRlciBSb2VjayB3cm90ZToNCj4+Pj4+PiBPbiA2LzE4
LzI0IDA1OjI3LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+Pj4+Pj4+IFRoaXMgaXMgdGhl
IHN0YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUgNS4xMC4yMjAgcmVsZWFz
ZS4NCj4+Pj4+Pj4gVGhlcmUgYXJlIDc3MCBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2ls
bCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPj4+Pj4+PiB0byB0aGlzIG9uZS4gIElmIGFueW9u
ZSBoYXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPj4+Pj4+
PiBsZXQgbWUga25vdy4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFk
ZSBieSBUaHUsIDIwIEp1biAyMDI0IDEyOjMyOjAwICswMDAwLg0KPj4+Pj4+PiBBbnl0aGluZyBy
ZWNlaXZlZCBhZnRlciB0aGF0IHRpbWUgbWlnaHQgYmUgdG9vIGxhdGUuDQo+Pj4+Pj4+IA0KPj4+
Pj4+IA0KPj4+Pj4+IFsgLi4uIF0NCj4+Pj4+Pj4gQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9y
YWNsZS5jb20+DQo+Pj4+Pj4+ICAgICBTVU5SUEM6IFByZXBhcmUgZm9yIHhkcl9zdHJlYW0tc3R5
bGUgZGVjb2Rpbmcgb24gdGhlIHNlcnZlci1zaWRlDQo+Pj4+Pj4+IA0KPj4+Pj4+IFRoZSBDaHJv
bWVPUyBwYXRjaGVzIHJvYm90IHJlcG9ydHMgYSBudW1iZXIgb2YgZml4ZXMgZm9yIHRoZSBwYXRj
aGVzDQo+Pj4+Pj4gYXBwbGllZCBpbiA1LjUuMjIwLiBUaGlzIGlzIG9uZSBleGFtcGxlLCBsYXRl
ciBmaXhlZCB3aXRoIGNvbW1pdA0KPj4+Pj4+IDkwYmZjMzdiNWFiOSAoIlNVTlJQQzogRml4IHN2
Y3hkcl9pbml0X2RlY29kZSdzIGVuZC1vZi1idWZmZXINCj4+Pj4+PiBjYWxjdWxhdGlvbiIpLCBi
dXQgdGhlcmUgYXJlIG1vcmUuIEFyZSB0aG9zZSBmaXhlcyBnb2luZyB0byBiZQ0KPj4+Pj4+IGFw
cGxpZWQgaW4gYSBzdWJzZXF1ZW50IHJlbGVhc2Ugb2YgdjUuMTAueSwgd2FzIHRoZXJlIGEgcmVh
c29uIHRvDQo+Pj4+Pj4gbm90IGluY2x1ZGUgdGhlbSwgb3IgZGlkIHRoZXkgZ2V0IGxvc3QgPw0K
Pj4+Pj4gDQo+Pj4+PiBJIHNhdyB0aGlzIGFzIHdlbGwsIGJ1dCB3aGVuIEkgdHJpZWQgdG8gYXBw
bHkgYSBmZXcsIHRoZXkgZGlkbid0LCBzbyBJDQo+Pj4+PiB3YXMgZ3Vlc3NpbmcgdGhhdCBDaHVj
ayBoYWQgbWVyZ2VkIHRoZW0gdG9nZXRoZXIgaW50byB0aGUgc2VyaWVzLg0KPj4+Pj4gDQo+Pj4+
PiBJJ2xsIGRlZmVyIHRvIENodWNrIG9uIHRoaXMsIHRoaXMgcmVsZWFzZSB3YXMgYWxsIGhpcyA6
KQ0KPj4+PiBJIGRpZCB0aGlzIHBvcnQgbW9udGhzIGFnbywgSSd2ZSBiZWVuIHdhaXRpbmcgZm9y
IHRoZSBkdXN0IHRvDQo+Pj4+IHNldHRsZSBvbiB0aGUgNi4xIGFuZCA1LjE1IE5GU0QgYmFja3Bv
cnRzLCBzbyBJJ3ZlIGFsbCBidXQNCj4+Pj4gZm9yZ290dGVuIHRoZSBzdGF0dXMgb2YgaW5kaXZp
ZHVhbCBwYXRjaGVzLg0KPj4+PiBJZiB5b3UgKEdyZWcgb3IgR3VlbnRlcikgc2VuZCBtZSBhIGxp
c3Qgb2Ygd2hhdCB5b3UgYmVsaWV2ZSBpcw0KPj4+PiBtaXNzaW5nLCBJIGNhbiBoYXZlIGEgbG9v
ayBhdCB0aGUgaW5kaXZpZHVhbCBjYXNlcyBhbmQgdGhlbg0KPj4+PiBydW4gdGhlIGZpbmlzaGVk
IHJlc3VsdCB0aHJvdWdoIG91ciBORlNEIENJIGdhdW50bGV0Lg0KPj4+IA0KPj4+IFRoaXMgaXMg
d2hhdCB0aGUgcm9ib3QgcmVwb3J0ZWQgc28gZmFyOg0KPj4+IA0KPj4+IDEyNDJhODdkYTBkOCBT
VU5SUEM6IEZpeCBzdmN4ZHJfaW5pdF9lbmNvZGUncyBidWZsZW4gY2FsY3VsYXRpb24NCj4+PiAg
Rml4ZXM6IGJkZGZkYmNkZGJlMiAoIk5GU0Q6IEV4dHJhY3QgdGhlIHN2Y3hkcl9pbml0X2VuY29k
ZSgpIGhlbHBlciIpDQo+Pj4gOTBiZmMzN2I1YWI5IFNVTlJQQzogRml4IHN2Y3hkcl9pbml0X2Rl
Y29kZSdzIGVuZC1vZi1idWZmZXIgY2FsY3VsYXRpb24NCj4+PiAgRml4ZXM6IDUxOTE5NTVkNmZj
NiAoIlNVTlJQQzogUHJlcGFyZSBmb3IgeGRyX3N0cmVhbS1zdHlsZSBkZWNvZGluZyBvbiB0aGUg
c2VydmVyLXNpZGUiKQ0KPj4+IDEwMzk2ZjRkZjhiNyBuZnNkOiBob2xkIGEgbGlnaHRlci13ZWln
aHQgY2xpZW50IHJlZmVyZW5jZSBvdmVyIENCX1JFQ0FMTF9BTlkNCj4+PiAgRml4ZXM6IDQ0ZGY2
ZjQzOWExNyAoIk5GU0Q6IGFkZCBkZWxlZ2F0aW9uIHJlYXBlciB0byByZWFjdCB0byBsb3cgbWVt
b3J5IGNvbmRpdGlvbiIpDQo+PiBNeSBuYWl2ZSBzZWFyY2ggZm91bmQ6DQo+PiBDaGVja2luZyBj
b21taXQgNDRkZjZmNDM5YTE3IC4uLg0KPj4gICB1cHN0cmVhbSBmaXggMTAzOTZmNGRmOGI3NWZm
NmFiMGFhMmNkNzQyOTY1NjU0NjZmMmM4ZCBub3QgZm91bmQNCj4+IDEwMzk2ZjRkZjhiNzVmZjZh
YjBhYTJjZDc0Mjk2NTY1NDY2ZjJjOGQgbmZzZDogaG9sZCBhIGxpZ2h0ZXItd2VpZ2h0IGNsaWVu
dCByZWZlcmVuY2Ugb3ZlciBDQl9SRUNBTExfQU5ZDQo+PiAgIHVwc3RyZWFtIGZpeCBmMzg1Zjdk
MjQ0MTM0MjQ2Zjk4NDk3NWVkMzRjZDc1Zjc3ZGU0NzlmIGlzIGFscmVhZHkgYXBwbGllZA0KPj4g
Q2hlY2tpbmcgY29tbWl0IGEyMDcxNTczZDYzNCAuLi4NCj4+ICAgdXBzdHJlYW0gZml4IGYxYWEy
ZWI1ZWEwNWNjZDFmZDkyZDIzNTM0NmU2MGU5MGExZWQ5NDkgbm90IGZvdW5kDQo+PiBmMWFhMmVi
NWVhMDVjY2QxZmQ5MmQyMzUzNDZlNjBlOTBhMWVkOTQ5IHN5c2N0bDogZml4IHByb2NfZG9ib29s
KCkgdXNhYmlsaXR5DQo+PiBDaGVja2luZyBjb21taXQgYmRkZmRiY2RkYmUyIC4uLg0KPj4gICB1
cHN0cmVhbSBmaXggMTI0MmE4N2RhMGQ4Y2QyYTQyOGU5NmNhNjhlN2VhODk5YjBmNDYyNCBub3Qg
Zm91bmQNCj4+IDEyNDJhODdkYTBkOGNkMmE0MjhlOTZjYTY4ZTdlYTg5OWIwZjQ2MjQgU1VOUlBD
OiBGaXggc3ZjeGRyX2luaXRfZW5jb2RlJ3MgYnVmbGVuIGNhbGN1bGF0aW9uDQo+PiBDaGVja2lu
ZyBjb21taXQgOWZlNjE0NTA5NzJkIC4uLiAgICAgdXBzdHJlYW0gZml4IDIxMTFjM2MwMTI0Zjc0
MzJmZTkwOGMwMzZhNTBhYmU4NzMzZGJmMzggbm90IGZvdW5kDQo+PiAyMTExYzNjMDEyNGY3NDMy
ZmU5MDhjMDM2YTUwYWJlODczM2RiZjM4IG5hbWVpOiBmaXgga2VybmVsLWRvYyBmb3Igc3RydWN0
IHJlbmFtZWRhdGEgYW5kIG1vcmUNCj4+IENoZWNraW5nIGNvbW1pdCAwMTNjMTY2N2NmNzggLi4u
ICAgICB1cHN0cmVhbSBmaXggMmMwZjBmMzYzOTU2MmQ2ZTM4ZWU5NzA1MzAzYzY0NTdjNDkzNmVh
YyBub3QgZm91bmQNCj4+IDJjMGYwZjM2Mzk1NjJkNmUzOGVlOTcwNTMwM2M2NDU3YzQ5MzZlYWMg
bW9kdWxlOiBjb3JyZWN0bHkgZXhpdCBtb2R1bGVfa2FsbHN5bXNfb25fZWFjaF9zeW1ib2wgd2hl
biBmbigpICE9IDANCj4+ICAgdXBzdHJlYW0gZml4IDFlODBkOWNiNTc5ZWQ3ZWRkMTIxNzUzZWVj
Y2NlODJmZjgyNTIxYjQgbm90IGZvdW5kDQo+PiAxZTgwZDljYjU3OWVkN2VkZDEyMTc1M2VlY2Nj
ZTgyZmY4MjUyMWI0IG1vZHVsZTogcG90ZW50aWFsIHVuaW5pdGlhbGl6ZWQgcmV0dXJuIGluIG1v
ZHVsZV9rYWxsc3ltc19vbl9lYWNoX3N5bWJvbCgpDQo+PiBDaGVja2luZyBjb21taXQgODlmZjg3
NDk0YzZlIC4uLg0KPj4gICB1cHN0cmVhbSBmaXggNWMxMTcyMDc2N2Y3MGQzNDM1N2QwMGExNWJh
NWEwYWQwNTJjNDBmZSBub3QgZm91bmQNCj4+IDVjMTE3MjA3NjdmNzBkMzQzNTdkMDBhMTViYTVh
MGFkMDUyYzQwZmUgU1VOUlBDOiBGaXggYSBOVUxMIHBvaW50ZXIgZGVyZWYgaW4gdHJhY2Vfc3Zj
X3N0YXRzX2xhdGVuY3koKQ0KPj4gQ2hlY2tpbmcgY29tbWl0IDUxOTE5NTVkNmZjNiAuLi4NCj4+
ICAgdXBzdHJlYW0gZml4IDkwYmZjMzdiNWFiOTFjMWE2MTY1ZTNlNWNmYzQ5YmYwNDU3MWI3NjIg
bm90IGZvdW5kDQo+PiA5MGJmYzM3YjVhYjkxYzFhNjE2NWUzZTVjZmM0OWJmMDQ1NzFiNzYyIFNV
TlJQQzogRml4IHN2Y3hkcl9pbml0X2RlY29kZSdzIGVuZC1vZi1idWZmZXIgY2FsY3VsYXRpb24N
Cj4+ICAgdXBzdHJlYW0gZml4IGI5ZjgzZmZhYTBjMDk2YjRjODMyYTQzOTY0ZmU2YmZmM2FjZmZl
MTAgbm90IGZvdW5kDQo+PiBiOWY4M2ZmYWEwYzA5NmI0YzgzMmE0Mzk2NGZlNmJmZjNhY2ZmZTEw
IFNVTlJQQzogRml4IG51bGwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbiBzdmNfcnFzdF9mcmVlKCkN
Cj4+IEknbGwgbG9vayBpbnRvIGJhY2twb3J0aW5nIHRoZSBtaXNzaW5nIE5GU0QgYW5kIFNVTlJQ
QyBwYXRjaGVzLg0KPiANCj4gTXkgbGlzdCBkaWRuJ3QgaW5jbHVkZSBwYXRjaGVzIHdpdGggY29u
ZmxpY3RzLiBUaGVyZSBhcmUgYSBsb3Qgb2YgdGhlbS4gT3VyIHJvYm90DQo+IGNvbGxlY3RzIHRo
b3NlLCBidXQgZG9lc24ndCBmb2N1cyBvbiBpdC4gSXQgYWxzbyBkb2Vzbid0IGFuYWx5emUganVz
dCBuZmRzL1NVTlJQQw0KPiBwYXRjaGVzLCBidXQgYWxsIG9mIHRoZW0uIEkgc3RhcnRlZCBhbiBh
bmFseXNpcyB0byBsaXN0IGFsbCB0aGUgZml4ZXMgd2l0aA0KPiBjb25mbGljdHM7IHNvIGZhciBJ
IGZvdW5kIGFib3V0IDEwMCBvZiB0aGVtLiBUaHJlZSBhcmUgdGFnZ2VkIFNVTlJQQy4NCj4gDQo+
IFVwc3RyZWFtIGNvbW1pdCA4ZTA4OGEyMGRiZTMgKCJTVU5SUEM6IGFkZCBhIG1pc3NpbmcgcnBj
X3N0YXQgZm9yIFRDUCBUTFMiKQ0KPiAgdXBzdHJlYW06IHY2LjktcmM3DQo+ICAgIEZpeGVzOiAx
NTQ4MDM2ZWYxMjAgKCJuZnM6IG1ha2UgdGhlIHJwY19zdGF0IHBlciBuZXQgbmFtZXNwYWNlIikN
Cj4gICAgICBpbiBsaW51eC01LjQueTogMTlmNTFhZGM3NzhmDQo+ICAgICAgaW4gbGludXgtNS4x
MC55OiBhZmRiYzIxYTkyYTANCj4gICAgICBpbiBsaW51eC01LjE1Lnk6IDdjZWI4OWY0MDE2ZQ0K
PiAgICAgIGluIGxpbnV4LTYuMS55OiAyYjdmMmQ2NjNhOTYNCj4gICAgICBpbiBsaW51eC02LjYu
eTogMjYwMzMzMjIxY2YwDQo+ICAgICAgdXBzdHJlYW06IHY2LjktcmMxDQo+ICAgIEFmZmVjdGVk
IGJyYW5jaGVzOg0KPiAgICAgIGxpbnV4LTUuNC55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVk
ZWQpDQo+ICAgICAgbGludXgtNS4xMC55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+
ICAgICAgbGludXgtNS4xNS55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+ICAgICAg
bGludXgtNi4xLnkgKGNvbmZsaWN0cyAtIGJhY2twb3J0IG5lZWRlZCkNCj4gICAgICBsaW51eC02
LjYueSAoYWxyZWFkeSBhcHBsaWVkKQ0KPiANCj4gVXBzdHJlYW0gY29tbWl0IGFlZDI4YjdhMmQ2
MiAoIlNVTlJQQzogRG9uJ3QgZGVyZWZlcmVuY2UgeHBydC0+c25kX3Rhc2sgaWYgaXQncyBhIGNv
b2tpZSIpDQo+ICB1cHN0cmVhbTogdjUuMTctcmMyDQo+ICAgIEZpeGVzOiBlMjZkOTk3MjcyMGUg
KCJTVU5SUEM6IENsZWFuIHVwIHNjaGVkdWxpbmcgb2YgYXV0b2Nsb3NlIikNCj4gICAgICBpbiBs
aW51eC01LjQueTogMmQ2ZjA5NjQ3NmU2DQo+ICAgICAgaW4gbGludXgtNS4xMC55OiAyYWI1Njll
ZGQ4ODMNCj4gICAgICB1cHN0cmVhbTogdjUuMTUtcmMxDQo+ICAgIEFmZmVjdGVkIGJyYW5jaGVz
Og0KPiAgICAgIGxpbnV4LTUuNC55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+ICAg
ICAgbGludXgtNS4xMC55IChjb25mbGljdHMgLSBiYWNrcG9ydCBuZWVkZWQpDQo+ICAgICAgbGlu
dXgtNS4xNS55IChhbHJlYWR5IGFwcGxpZWQpDQo+IA0KPiBVcHN0cmVhbSBjb21taXQgYWFkNDFh
N2Q3Y2Y2ICgiU1VOUlBDOiBEb24ndCBsZWFrIHNvY2tldHMgaW4geHNfbG9jYWxfY29ubmVjdCgp
IikNCj4gIHVwc3RyZWFtOiB2NS4xOC1yYzYNCj4gICAgRml4ZXM6IGYwMDQzMjA2M2RiMSAoIlNV
TlJQQzogRW5zdXJlIHdlIGZsdXNoIGFueSBjbG9zZWQgc29ja2V0cyBiZWZvcmUgeHNfeHBydF9m
cmVlKCkiKQ0KPiAgICAgIGluIGxpbnV4LTUuNC55OiAyZjhmNmMzOTNiMTENCj4gICAgICBpbiBs
aW51eC01LjEwLnk6IGU2OGI2MGFlMjlkZQ0KPiAgICAgIGluIGxpbnV4LTUuMTUueTogNTRmNjgz
NGIyODNkDQo+ICAgICAgdXBzdHJlYW06IHY1LjE4LXJjMg0KPiAgICBBZmZlY3RlZCBicmFuY2hl
czoNCj4gICAgICBsaW51eC01LjQueSAoY29uZmxpY3RzIC0gYmFja3BvcnQgbmVlZGVkKQ0KPiAg
ICAgIGxpbnV4LTUuMTAueSAoY29uZmxpY3RzIC0gYmFja3BvcnQgbmVlZGVkKQ0KPiAgICAgIGxp
bnV4LTUuMTUueSAoY29uZmxpY3RzIC0gYmFja3BvcnQgbmVlZGVkKQ0KPiANCj4gSSdsbCBzZW5k
IGEgY29tcGxldGUgbGlzdCBhZnRlciB0aGUgYW5hbHlzaXMgaXMgZG9uZS4NCg0KVGhlICJORlNE
IGZpbGUgY2FjaGUgZml4ZXMiIGJhY2twb3J0cyBmb2N1c2VkIG9uIE5GU0QsIG5vdCBvbg0KU1VO
UlBDLCBhbmQgb25seSB0aGUgTkZTIHNlcnZlciBzaWRlIG9mIGFmZmFpcnMuIFRoZSBtaXNzaW5n
DQpmaXhlcyB5b3UgZm91bmQgYXJlIG91dHNpZGUgb2Ygb25lIG9yIGJvdGggb2YgdGhvc2UgYXJl
YXMsIHNvDQp0aGV5IGNhbiBnbyB0aHJvdWdoIHRoZSB1c3VhbCBzdGFibGUgYmFja3BvcnQgcHJv
Y2VzcyBpZiB0aGUNCk5GUyBjbGllbnQgZm9sa3MgY2FyZSB0byBkbyB0aGF0Lg0KDQoNCi0tDQpD
aHVjayBMZXZlcg0KDQoNCg==
