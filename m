Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C8433B0
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727975724; cv=fail; b=en2gutnIiklitTjl0zh6Ajwp9BoJCVohuJpLzEt5PDAOmi+BBrk5PpIcAEdxGa/o0lPK7saFrbUh9vl2alIWvmyBJednoTgsvcuQcB6dB/DCHgu6L5Xy0tLd5He0QYBctfa09W+viW5E/8Q6lh82s2/6Jk6zKVA6oTxy/OWCje8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727975724; c=relaxed/simple;
	bh=8HD0bZ/dJ+7PhN9OmjZBQElEie2TS9S6+w97cMVIb+A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H3RFPJTQfAl75O3BKiacwSNhfAMnI+bfw59Qp4Fe5oMltQROzGf3CDeixiwvhpS0ZP6V5phIjpD6RSfhHEr88vgf5wPFL8PO3d3j278GiMVhrVXVUvXfTAvveBBa/dlmcsZIZFxQtlbQp0v6kAtPHmVq+NLU+v+MT2uGNGPRljw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bZZuXirL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q26fsWCM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bZZuXirL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q26fsWCM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 493FMd3k006333;
	Thu, 3 Oct 2024 16:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=2Pke98CitsYSwqV92ME/G3Mb+nvVHUDAys+MgsOQjLs=; b=
	bZZuXirLlylMCfsun13ON7/hiNy2MFJb23S427Agtv49GMVBe/wSggEoqvPyu2cU
	WB2acGZuJm5p+JcIddbB2uBy/pyl+bfAdMUmcHi9aAM8EA4sjZqM9TpU3QJu0bby
	tUJtemMirU5fCBYh0JA0WyRd3BdmHfFY92cdmqC44c+y9D+y97fvju42F38Edb2G
	tXDSOFx7VRC1/0FmyYEgikV1uo7oxLoiwQvXrR05cEsc3/Uuse8N44RQAHqTc8gp
	idn+h4Mv/JUID5tgHj+OhHIXPHln9uzHs3R13cWB1B96VCSBQ23zjk9CmjcGegUH
	uretXk0GqtubS0nILZatXw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x87dcgx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 16:21:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 493GBqVW028403;
	Thu, 3 Oct 2024 16:21:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x88an67g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 16:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ux/gTmDA0Zjbzyt+PI1boywd03W9qchnbVgfqAAklXTNe4sslseUs0MmyGQ14EdbK1EQaFsraqtZvJVAGJJgyORZEZzoEWQCJObiOEvysVs7vIGG93q0Mk2mNpmcgwyGgKMEPn15wu01kzzstLjwWj7zvNFeEYBdQCL5trgSAmywsLYQ9hh0KorrQx7nCfh/lgzc1UyoDcbyPPzSvSAHavRiy3LJ7upxp/KWQ2xtfmJ78apspibI8EMLgI0dgz2BKFmzkbQTwfFGb4eIz1/U9snidZB6Dgaa4RPr0BdBOY7UplzPrfAa03w0TS1kGU140fapjYLlXXny30/ehsv0Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Pke98CitsYSwqV92ME/G3Mb+nvVHUDAys+MgsOQjLs=;
 b=qHcr/nNQRE9EOF1Bryme9rXyVvGIA4q1cw0ZwZlZNbLvNaJV+q4StS9bkV/nDHVT3BgFwq5blSCQZXHrMm/hAjjszJ1IBGxjioTyBIaYcKIiPWpL8xLoyCm9L0S0bZSL9mTjp473lMDTHkbo0M3S1+er8D0UVaH9qp+5ojNZvaDzB2gwoUa/NZxx0ulcXcgjgG/AyOJYwwI12TC50TQPzm1ad9JmhcpgvKobilM3Py4/LYS/XKr/bb/k7gRDuzOiyRuHfIcBd/FCHUAJ0JDAXMjqQPfVXIiPp6gXY+NvaghIyB/9eu84Kk8ilRjNZAg34mKg7NRgzwBNf+wvV1sNGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Pke98CitsYSwqV92ME/G3Mb+nvVHUDAys+MgsOQjLs=;
 b=Q26fsWCMikD52uY139YAVXNMWyGdhr/PSm2RCgBkTwTMid20xJvxZCd6ymgoRgkuNEWmrgzo61jSOwGrl+rx2K0zgmgOXOkX0mM6rpwLZ71hKGK/LbaGzKEdBu3lp5/Nw7a54w8CQdkQG68/2sFxYgNMInujf7JXPPgUeKFUGkU=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH3PR10MB7808.namprd10.prod.outlook.com (2603:10b6:610:1ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 16:21:23 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8026.016; Thu, 3 Oct 2024
 16:21:23 +0000
Message-ID: <899d2baf-2233-4f1b-a8a9-43f4c6785443@oracle.com>
Date: Thu, 3 Oct 2024 21:51:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241003103209.857606770@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0075.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH3PR10MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 210eb57d-5faf-4ad4-5955-08dce3c76c47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTlzTXBTVVNuU2Vib0ltUkV2MW5UNHF0cTBGd0hKdDliUkYvY2lwYUI1Mk9j?=
 =?utf-8?B?MjZVUjVhTDFBYjJDSzQ4ajV3Z1NOdjN2enF0a2xWYUpZUkcweXVnUkpxU1ZI?=
 =?utf-8?B?Y2Ira0VBY2lNY1IybE9kK2VocDRxNXR2NUkzNGZsNTI2TkE1bkF3bE9ZdEJC?=
 =?utf-8?B?VytxZ0FYN0ZHZUUzTTdzSGFuME5JN3ppNGd0V1FnMGJNeFFBM0x0bEZ6MHFn?=
 =?utf-8?B?dHAyRFZFS2dtQnY3dFRrZmxEeHFudWpFcmFIU0JiUmhjY3NrakxJemg5RFdt?=
 =?utf-8?B?MmJFZjVjR1F4VUx6Q0Z1UmRpUEJiVzNjeC9HaHN6OVlUMERmdm91clJWMVdN?=
 =?utf-8?B?ZDBkVWVUMkJPRlMrb3RmUFJZdUFhdkNPUjRZNGxkZVF0dm5FeHRQcUhGMXFV?=
 =?utf-8?B?SFp4cGVIWmhKa1ViYXkvMnZFUlVKMzdkalhFeUZxMXpQV2t3bGdweWh1Rm45?=
 =?utf-8?B?cUFUd04ydURhZzNHYUFiZEd1UVFJeW9hcldCclhubCtBSC9QNDBXaUphNGVE?=
 =?utf-8?B?Qm9HQnF1NFlPT1d5aytpeXFqUVhEUUJXelAzYi9IbVQzV0g0U2xMM1hNcDZ5?=
 =?utf-8?B?WWd1czRKZGU5VHQveG1wa25IUERab0xnVTVjM3YrQ3BkTW1oa2NVYWUwdGxv?=
 =?utf-8?B?cUVVbkdDTHl0N1N1ODVid05KRG05SU5aMmlub3d6MkZValRhMzMrMWhXcFBa?=
 =?utf-8?B?OWFsNURjdGNFQS9GaWJEdnYxR2J1RVMxekVJU2FKYjNld091RzNhQ0dwdFdC?=
 =?utf-8?B?YkNQb1dmc2hSNHBEM0hCd3RmOEdQcG9Vak1RUVM0UEp3bzZjcVEycHNHUUtL?=
 =?utf-8?B?MGw1cU5RUWVYVUVzdm1JMEUxUDRJUE93MzhxcTI2R2hRWC9CeDE4VGpXaUxs?=
 =?utf-8?B?WEZzbEJ0TStQalE4LzBNT251OGhiSUl4OGtlVlRnVWhqblFJNzc0ZjR3REFG?=
 =?utf-8?B?UHJ1UUZPVzRuTEV4MU8reHFRR0o5MUV5bXp2bFBIUk05anlMTG9qbjNwVTFX?=
 =?utf-8?B?RlZraWdEY3FHQThlSURsenFRU2trQU5UcjUyT0tCUWtqM21aSUx0UmlmZmQ2?=
 =?utf-8?B?c3Yyc0FMUnBWZ0hkc0hrVEdldmhPSUdsaEFCTkw0dDNZOUFhMmREREVHVlFU?=
 =?utf-8?B?WkgrWVVzdzVjQjdjbFdzNEpSMDR0dGd3bVBiZVZyamtOYjlZR2I0cWtpaVhH?=
 =?utf-8?B?b3VkTWprV0E3cURMS0pqM2hSb01VL29kcXo2dHR1ZUhUTjdmWTVSTlc4MTZv?=
 =?utf-8?B?WVlEUER3dTl3bTNlYzJnV3pQSDRqNGZDbFNVNHplcnIxdUZvQXY5enptRjlR?=
 =?utf-8?B?QUNXODAvRWQ3MGxzSUhLcVhVMlRNaHAvSWlzdkkyd0lVWkZabXBST1FjK251?=
 =?utf-8?B?a1VoV2xrVytvRVZJeS9qYy9hSndnVE5tZXlBMFB0eC9RdWxJMkVvSWRVc3NB?=
 =?utf-8?B?NDR3a2VCQkZyckFZQjhTQzZ1ZVcyVzA1SGZwM1dvZGgvL1lHaDJaZzZ1NmF3?=
 =?utf-8?B?K2xMbERsZUxOU3poNVUwbW1vMUhxOHhuN09mY09MV29pNGJ2TGZUUlZFc2FI?=
 =?utf-8?B?bnAzQmQwK0pELzhIREhYOVM2TW11a2tjTnNaN1ZRdUZFSU5PeWc3OE1oNmFr?=
 =?utf-8?B?QUxiZnpUUHZNK2NCdnpCaEdiRUkxeUExeDRtb0VmWkF4djRGNnA2V2d4NFQy?=
 =?utf-8?B?SVF5VWtNak1zaktRVms4QjRqZlpBUkRHamFhNENWZTJLZXlwd1d1MEhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGxaN2QwcHFFZzhmMldJQ3FDbmVhQjVpYWZkVUNGOWIxYXdZOHB6NVhiTlR4?=
 =?utf-8?B?Ry9CS0ZPM1FncTNqUHdTV09zNWhrd2RkcXA2SGI1SloyRmNVMDhJSDdBSTZV?=
 =?utf-8?B?WkFFUXhZdU9OWW44dUdGZ3hIYUJTMmZhbU9kb0gyRXlVMFhpRmR0eUZSMWNY?=
 =?utf-8?B?em9GMWRSWldVRHYzWjZxamllTzJMc2JHQUZFVTJvNjBVRVdyTkI0N2prWjIy?=
 =?utf-8?B?MVU4VHhONGo5bXgyall5YUo5bzFpMW5DaVU2T25JbS9UQjUrNDNkSm0zSGVU?=
 =?utf-8?B?d3RkczFXQ1lNKzhrV3lWMGIvWksya3pUcVlSMW5aOWhMSXN6OWlTQWQvRFRE?=
 =?utf-8?B?TlJ4N3htQlhWZWlZZHRydXJ6eW04UStyaDIyeUVRNmpZa0NZVjlFcTVyWEky?=
 =?utf-8?B?L2xINE9wMEVWcjJHMGxlVDNYbjljTHFqV096MHFtMzk2SWhKaThtbURhMkU0?=
 =?utf-8?B?Yy9CNXJmd1RLenZMS3VrOUNyMDNwWk53dXpGd3kvRHlOcmN1VG9GQkZCMU9V?=
 =?utf-8?B?STVpUnUwYUdlRDBxaWlQSnJQNUNvVS8ybzBkaDRTM2pBaG5DemtIQzg1V0tB?=
 =?utf-8?B?SEJLSEdBTG13UEowckt0Q09keXp0S0wwWWFlZmRLcFBMNjM3RVMwMlQxR2g4?=
 =?utf-8?B?MTdNSURXZGZrTVRiVzZJQmUrRmNJaW5MdStGUVZnNEVOK2RxSGpBa2JuYjJx?=
 =?utf-8?B?bUU1SGROVUNDdkRvSWdyd2pERTkrWERZNDBMaXpCQUN0cnpoUXEzc3MxaFlJ?=
 =?utf-8?B?dFduOUIvMDFWVEZINE5PUUVKZGdaSVVqTU5yVXF3WVNJbExjeWxSdi9GbEpY?=
 =?utf-8?B?UTBJa1pjdVNCTk1qa2tJcnZBUU50QWxpbnJyRkpDeTVlN2UyQUlhbVBjZFNq?=
 =?utf-8?B?NEY3aGx3azE5VERIcU94VWd3blNxUEhWUDBHSnVMbDQvTlFVSzRtRDV6MzEx?=
 =?utf-8?B?NmFBL3BTaS9nZlU0aGY4VUlKcG4rQ1BEQW9sL2pDeC9Obk10NWw4NXVDUGJo?=
 =?utf-8?B?U2VvNSt6Y1pzMWNrWC80cjNBTE5LK2lWVnVyTmNkVFpsbnliVkxqSlNTTTZC?=
 =?utf-8?B?MVZrUXFQMmY4cDR3MmhmbW5DaHN4dUlhSUxVTmpESkZhSm1kSCtVb3JWYWg5?=
 =?utf-8?B?aHBjQTNQNCtQUDdsWEw1TW50dFcrUThtT21DcDVHSlZud2tmRVNoVVFuOEow?=
 =?utf-8?B?UHBZTWJsdmk1bkZ0cllBOUZVRlh3UVkzVVVFREkxZ21RdEN4Q2tDZmxCaFB6?=
 =?utf-8?B?aFM0Qk5HWWhhQStaVnZGbXBNOThXSkl3bGZrKzNBdnB3eGgvd0FTa2hGYVRi?=
 =?utf-8?B?ZGVNMG1BSk5WSEIvdGF4YlFCaFJOTUU1eS95ZnIwQ0F2ZjhWWmxwQUZudFNk?=
 =?utf-8?B?WWpRQzBMZUFqT1hVVW5hTHhacnE3NXBWT25MMnlZc0p6WUI2ZXVpd1k1azhV?=
 =?utf-8?B?RGFoR2pPVlBRRlRZMXNUbGlKREFwWkd6NlBGbG5mZ3BXZTE0T0p5MituRVFX?=
 =?utf-8?B?V1NBWC93UTBlSTFpdnF4Z0VtRitCVWNqN2JKbmNoSzlTT3ZJYTZwRGJrb0Ro?=
 =?utf-8?B?cG80N2prVGdCUWlOdjBFSXc1RnY5alhmWk5uQ2drM1pxZFFoU0pYNUxldUVD?=
 =?utf-8?B?UnZFamd1ekFTS1BKSU83V1VzVWlDak9zQW1jZjlaMFYxa0M4dFVXRlFDa0pn?=
 =?utf-8?B?L2doemRqSGQyUGQ1SlZwRXRrcFErMDBLaFVmZnFtbFAydHZpdUpJZHNLdDJC?=
 =?utf-8?B?SXl0RVZEdTcxU0hwSzQ5a0tNcStYVStObllNRmp6ZENvbXlScXYrTWRLZTND?=
 =?utf-8?B?ZitpNndoZGxJYW1yUGwrVUxUYU5qMXhsSEpUbnh4SnJjTWUwWWViVUdtUEg0?=
 =?utf-8?B?T0xyc2E5S0doVDI2Z1lmc2tsVXFoRmFBNWY4QUtsdTBubi9sbmRjNlhORFBV?=
 =?utf-8?B?VG5WN0JxcFl3WXVJeWN2SHdpTzk5d1U0Z1U1dk1rQzJueGRuZU5keCtRNzN4?=
 =?utf-8?B?VnBVc2l3U3Q2TlpkNHpidlRuMjdReDJudS9LMzdnZjRLQWdVZXl2V0tBV3NS?=
 =?utf-8?B?N1lRdVdJN1duVHpQYXdQQml5amtGNXpOUGFxMVc5ZEFhS1NyTmcyMWxxUHF0?=
 =?utf-8?B?ZzlnK0c3R1lRTjRHM1k2bnpTMmVjV2gxeGQrcU5RaEhLdEtDQ0FVSGVRa1Bp?=
 =?utf-8?Q?7wCQ4tgva4b5uR8fctFrqBY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RnJWup4T78aTjTL9981GefGdFSqkz0ciXkMp2EMWJWonYjELC87rf0bg75ltetpvN19Q1Rkt/tF0u1S5ZyHOkHsO8dW7PQFeWnHHfcUKQmNmreBphtsUrdLQw5vPedq5LGaFL92ORGZPec3GfEKwzzmQ5XInPYd52fKkoX7X86wOOzf+E7ZKNgjKa4n2iYSi7cfIDUdvUpZ/cX3NRNX3BGmWjV2NXgaR+daFImJwx3HcZzkJ0SOChTzmwUVyQrKxyollJsZn7tjRPGgEewNyORcpPlZiDVmhhdOpG73Ox7iiPzB8e97lgS5yMQlIzkhmpz1Eb3muWrOF47r48ACrsm4IeDYjdslBohc8lQ51GPeCpvzI6dhG4rkUsv8SGZ0ynYPF1WJgHicP9PFKoZvtVk+NP3Zo232sboakaE3B88hBrKFnQJnK4mePCQVdnpvR+mBNWXX6IlBUIYZR4seUoQKDsPMmc8OwgAouH4i0+jt1+Wp3Mbf2HfrWWWLYK9GJP68VHbylVXfb7OJUSq9w5a84S4qf/6cizL2SmoeGCqdQObfihN/9nMa/z0BsXBnlc3eW/VXEryfJ77NFI3sNzG47MQ5QCaNVxXi1Z0ptYyo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 210eb57d-5faf-4ad4-5955-08dce3c76c47
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 16:21:23.7493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMtemGINpHPZnxpLAM5PaU3r0UMVQvGo3S/3tTJrazsYXeTXv6J+FH9q2yePrQLMEWWxD0EcJEF8gLdeVVPzuozbLDnNpLUmcJpYBI3tR3a/drrk7z6cl8QX2p2sH1UI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_15,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410030118
X-Proofpoint-GUID: mE09OjuAKWwKebOum19SjIt8e0Fqw4rj
X-Proofpoint-ORIG-GUID: mE09OjuAKWwKebOum19SjIt8e0Fqw4rj

Hi Greg,

On 03/10/24 16:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.

rc2 is good and had passed all our tests!

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
