Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2DB2C1589
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 10:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029180; cv=fail; b=qgyKbgYWkpJ+RuroSzQIho0sSjN0096i3q3hM1iW03YZ39vR/M8M30h3DmfT0Y5PAmN9S5LSYAMcziB6ln8XCuzr8rG4VvkNta6J6NECXZ4qHHjMkgBiOFTn+LZYM3+jtFy28o+BD5ZmtXjH0P+6VVicYrjTx5UwkYMKxWAYKQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029180; c=relaxed/simple;
	bh=9zHif/ch9bdqnwhhilWcNWxfLX14ALegUZ+qFXMKmNI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YK2tyhsycYaaMh1Bjl7SrFHFAbVRodVqubTMqCS3+FaBHw8CYzXR1iF2avPqA3Ncbrv4Mi8MdybXPRyiot+NdS1GS574cCRq/pcK+z1fG8Wzl8sEux0vzmR6tflQ4tius8kMDaTxbJJDo4Df0Zd+hchcUBNCh3k2AsAeoox7TJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HyfrBA6A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tv53qYZR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HyfrBA6A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tv53qYZR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gr4p031441;
	Thu, 13 Nov 2025 10:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C59S+g4tlrswguopHfh/4MrJC9OTJRNdFNNmMh2TO6g=; b=
	HyfrBA6ABnfeBYhYLyf9O0N4gnTUXnuhWGmcg7mjOW9UehYJi6P91Rjb28WniYUx
	8XuLoGHO1DrklBgdklE+ZxOeBvevuMZzNfppc1F+Zbu5HO/DU/D5Q4mSSJmswrpO
	2nrLsED512/va/qAT47mS+q7aPXQ0rOSui9QOmx0eXiQ8kreOkcDWUtTP4j4ekLn
	cyXQJ9jneD8VvsGhrkqvJ2eDrv8Rox74rI659X8t5CEwCYzaAGe0iVN9aIwveFZD
	VyWcXnKxIZuaRTXY5yEPsn0qyjOHzDtr9u4sXjf8+sz00aS5uvhQ9g2sP/m5zYV+
	k+Hh03XUPK+ya+mdOXxQnQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyra9c7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 10:19:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD9hnAg000495;
	Thu, 13 Nov 2025 10:19:06 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaffth1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 10:19:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rKgYaAZEFcaC4vZcM1qdOzHQqlUD01alyT0MItRSZUzA6UzuvXp4XSX/vvf7/L9gPBE19XRVkDdz0DO39BOy2saKjP4iacOhLN7b53Ighlg9T55OebwNstdD7dv51u05ZQx9rzECcMMSM0opLdoCNzMv8cEif7YeKWptT2KLFCDUTjVbQ0KCeXpGJM8TkBrSSinNNSJ8PAzMIJS/QedjtyrFwwKI1risn8+XanOrs9aVRpTS8u5jRUPJTAtI8KOB6asQEEdxmAQCL5T2NSL9Lk/F20/e2Y7bIxsRX9JzkoxRndCwhMYYJVihfFeX3Or517+GMk7IHD3lHupr0lHmyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C59S+g4tlrswguopHfh/4MrJC9OTJRNdFNNmMh2TO6g=;
 b=y5MjitHVH3fjIsYASHVGFGQHU+dHK3ZoYlNSsMMNkEQkGJtqKZjkbQB+iP83W7j5gJin1/FZPhNU+az4ovnzu1LUzoNoczJJQydiWT37PW4p8TcHcdP0i7gkM7UhEeYd/p+361lcuNT0fn2ZYtsMVRhbkH0QituaIStXIZI3XBylk2AKClQ3KPlkHbxPtLwYCOpU2dKEQEUC8xmFSavGqQzAaxpprOy3p7nwnw3P1TCmclFVZ7kNpb6jzPoyNDl+M2uTDaEMRX8tFP7Vw1EBxoCw4d/oXNgqktKQWR9J9kjkvUydXBmSl6MmZp43pcBleFbH2e82iaIA/Z9tJIyOTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C59S+g4tlrswguopHfh/4MrJC9OTJRNdFNNmMh2TO6g=;
 b=tv53qYZR9tXATCjbsfXVbhnC2beiKZM2qyYlDOZdU66yDQXPtemwadbOc7xXN7QWToEyX2qp7q+08YwkjY+bGdb2J2ync40Sw0YyRoNihaDBBRUILWFlPaZBfErrahaFUwE0VHTMmKxwxT3BSJfoCJ0wlw8fQbSoxRJiSry176U=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by DS0PR10MB6031.namprd10.prod.outlook.com (2603:10b6:8:cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 10:19:03 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 10:19:03 +0000
Message-ID: <5b13fb12-66ac-4502-a93b-d79692cc7b81@oracle.com>
Date: Thu, 13 Nov 2025 15:48:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com,
        Alan Maguire <alan.maguire@oracle.com>
References: <20251111012348.571643096@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|DS0PR10MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3a5a69-edb4-4736-1242-08de229e11b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmdldmNUZUNSOE9NemNldTRiOFFWZDBjU283M3Nla2ZWNythNENIRklUMzFQ?=
 =?utf-8?B?bldyQzRBVUVwWkdxWlRnZW02UkNSYXQrZXJhOHNmdlliT2liZThFdXhJMWdv?=
 =?utf-8?B?dG0va3U3cUFhUDViOTRjU3Z1bUNsTjRvUnNRWjc4KzlZUEdIUmhuYWhELzMv?=
 =?utf-8?B?bFdXWWozRjJCemVFa0dscmhCWTVpQWdJOC9XUzJzK09PTDlVMGFVc2JEVUNG?=
 =?utf-8?B?eWo4b1Y1TzMyUUpoSVJrRjluZllWTi93TDY0b1pyN2Q3b3ZHZ3BqOUlOVVht?=
 =?utf-8?B?cDR6RjU4dldXcFZFemhRSW5tRzVNYVB1S2UrUWhiZGxVWjVkTUw0OGs5OVM3?=
 =?utf-8?B?VHpGeG5ISU1XOUNkazhPNElWYTZKZU1hbGtVNXdCdC9nbW9SM1hmNlZWTHRY?=
 =?utf-8?B?NTBpTHBNNXRCL2dscURLZi9EMzN6d3AybDZuekNlMTlUVlZiMnYwUTdzaHNH?=
 =?utf-8?B?RUIzUUZvN2dJNjI0cHBKVUs5dmpnNDRncE9ZSFA2Y0U4WmtTK3dUN1V6OEhI?=
 =?utf-8?B?RW5RZjFKVnJHbit6Ykp0bDgvTVdFUGJDMzV1MjNydGZGNlRtYVRZMEVHWWpx?=
 =?utf-8?B?OHk4OERMb24wa3ZqbDJ6RUVhMnpCdWhmd1BqQnVOK0M2cnNKMExkd1E2NWox?=
 =?utf-8?B?WjZhYnBpUWpBaEVHMU8xUTRDaWlWRzBVSVBnTGNIR2trL2puSEZlM2x4WTVn?=
 =?utf-8?B?dndFNUY0VGpzN3V1TDZ3REpxVU9WUlV1UkFTdmVZNjVQUEJhbDBleXVYWGwv?=
 =?utf-8?B?Z0JBam11VHpTSktSdkhCWFpVRlk4SFZsbzAzeWF6OTlHN2Fvdzl6NWE1M08x?=
 =?utf-8?B?V3JCejM4aFAwdzJBK3VkbWhGNml2NFY5UlRWVkNmNTM0bzF3U05paUxqRlFN?=
 =?utf-8?B?dzdtTXlkb29EbHJWSjZCam5sd29rVGJVUEFuUW5JVWZYNGlmeFE1SndlR3Z2?=
 =?utf-8?B?QTNIam5NcEd5Q3VwQTRIWHJhbEgyRmVwbStYTk9IczIrYXVDQml5OWk0U1hz?=
 =?utf-8?B?NFlBbUpjalUwSHEwb3FuVkRWZXdaUGxlL0pXZWtCcTVWVHA3QWRyaGNTdUxB?=
 =?utf-8?B?eTZpOEVMVktDU0xZK3FxUzJuK2F3Mk1FVFdJZ2VMbTRpNUk0QWkxMDN2aDFB?=
 =?utf-8?B?WkVPcjNGSzN1SlNHYk9iZjRPZ29Xa3ltMUtqR0Z6MDRIa0d2cVlGd0k2YWsx?=
 =?utf-8?B?NlQ3ZXZFc2pFaU5CTC9YZkpaTHJZWWZ5RjM2R1BsMW5wenphUEFoeU8ydUtO?=
 =?utf-8?B?Vk5uRnJlR2NXbnhLU0FHZTdpNy96aUF2Q2hmOVhKS3N3MFczbFArU3prZGU2?=
 =?utf-8?B?TXdQa2llc2ZkbFY2anl6Y0dTczJGNVJqdUdXNm5xUkZObitCWTJZd085dW1C?=
 =?utf-8?B?RkdWOXU1WXRyd3FNMmxKVWlaVWRuc0RlSTd3TmE4RGVYbGJPYTE1UGloSUF0?=
 =?utf-8?B?YWk0bXNQbFp3QmU2eVlrUmtjeTVKNFNVdVFncmlrNVFIQldiaWorRU5WaHRK?=
 =?utf-8?B?aWkvZytvSTljTks4VEJ2SFNtT0wxWXBVVVlzUFdWam9ycFlRV2lzYk5mall2?=
 =?utf-8?B?SmZDOWZDTW55bzdPVnAwNVIrT28wdkJ0ZlZMR25kaFRkZkJwQk56ZEZFTDdW?=
 =?utf-8?B?dHNlMWVWUjhyT1UzZHJFa2IwZkVWaTNaOGdZUDk4S3ZCV1dFdWJIdGFCdVJy?=
 =?utf-8?B?VDhwT1l1ekNvbldWSWNTZlo2MzJlZkpETDFXdWx4bTRRazVpTzRaM3BJVGU4?=
 =?utf-8?B?SFJWdjB2VjRTOTlOUGtvc2F0OW9kbGU2L0owYWk4VWtFZDVQcDd6VlRNaDZa?=
 =?utf-8?B?UFBQN3NwTVBNL09LRDltVjM0M2dlTGN1NEZ4QjBsVDNMaUR4TjZBa05XM2lL?=
 =?utf-8?B?bTJoSGs4Q1FGV1Q1VWRvVVFTbyszeGNhNWNYN1pyQ0xCT0dqNTByek9WT0l2?=
 =?utf-8?Q?Y2C77NXaMjZE4kdghMxSaqYwmQSDh5h7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wis1MzBNQTNZSzUzRG45QkJ0MVppOHFrZUI1RlRMd3FJNWZ2NjM3d1pvWDF5?=
 =?utf-8?B?ZnRXalVNTlBpS2F5NnBaeW5TelBXS0NXSksrbzIyY2ZxRUlNaVNtTERSb1F6?=
 =?utf-8?B?WXpscmQzOUFhSEY0Z3Z4VjdoVW45OEF6QVB3QzNNZDcyTGtscjJRZHdzOTk1?=
 =?utf-8?B?YXROUGhIckcwTkU1am5ZU0lSYkJVS0tnYVNhaVIxY3dHbUtSUUN0RUVIVitm?=
 =?utf-8?B?UEh3aGFNZVhIS0V0TFB5V0pnZSswUmg4ZmZ5UmNhVW1qTnJHTHlRRmh3NDd3?=
 =?utf-8?B?Unk4WW9qc1A5c0RqZE8ydEZ1YkZJK1VlYXZPcCtEUExaSk5iS1RhSU1pWDNR?=
 =?utf-8?B?a0diSTYxSEpZRVlVYWVTZmdabENJSE40K05mcDQ3QkwrWkpnU0RaTm5SSGcv?=
 =?utf-8?B?Ni9UUHY0OWVucldya3FHdVRIRTFwcTZiTE53RFN6aitDVEV3SC80R2VaMTgv?=
 =?utf-8?B?QmFOUUJFOVhqVG4wdHhQZmdLQm1yalJMV3owVk1jUUN3RDRqVWRyNmhDRWdC?=
 =?utf-8?B?RjBTNnRrWk9BSTV2MDJ2VUs2MXd5K05JcFFXUnZNZ0VoaWZQWXdFcmdHNVFq?=
 =?utf-8?B?cHV5Y0wzREJySUtTOWJPQ00wNnhrYUkxdFJxZmcxZnpyeElHbGt1dXJaeDdh?=
 =?utf-8?B?cVJpMWlSdjdvU2xIZGtlWGRKWHVYeXJhZnpFWC9mYlRueWJhdHZncUFVaGVr?=
 =?utf-8?B?UVBBamtmZUh5dFUveTJWT0lOd0dBNEV3dTdBMHlqOTdvNkhEOWlLWTR2eW9D?=
 =?utf-8?B?c0NncjBINURCS0VJWWY3Y0JkL1R6SmVHWHAzNGxJQ21nVGtZL0IxR1p5U0Vi?=
 =?utf-8?B?R3hySXVUbXJaTW41NmJNczNrSTMxUTFLYlNhQ1M4TUtHaWlDVnBlMzlaV0lK?=
 =?utf-8?B?bGlEK1VpdXNCYWVoRzY2Rmh4NlBDQkh3amhweHNUSEdQUWVkTGg5NzM3RTdH?=
 =?utf-8?B?eWREZHkxV000M0taT3ZVd3RvNyt1aWJ5b3IwUTJGak1ybTFVdElYK1d5Wm0r?=
 =?utf-8?B?YXJhSmdqRDBLbldSQTJHNURJT05oUnNvMDFuZzFyMXhoMVovZzA2Q25DK1lp?=
 =?utf-8?B?YWFuNjgzQ0VLblN3d1ZCdmhRKzB1dTBhZXNMamNOd24yck1yS1dvdkVselhS?=
 =?utf-8?B?YVk1b2ZBYmlOQjRxeVFZcWhUN3g5UXJSeDlwN3JKLzVQTHkzaFJ3VzhuSW03?=
 =?utf-8?B?SC9BYm00amduck1aeDF6NVVCaFlyakFaRm4vTHVWVUEzbGFtbXZROG92ZGcv?=
 =?utf-8?B?RW5JYVcvUXJxMk1uc3AzMlhNNnN0MlYvdE1KSGhjMm9nZnB4dFB4L0h2YndZ?=
 =?utf-8?B?VzNjZXN3aE5Tajl1dTBZR1dqYlB3UExWZ2UzZ3h1SUdxdGtiWk5tWFZxWjlq?=
 =?utf-8?B?RHhTdTk2UGtmVDlyNVBHRXJTeGUwbzFZdGw0M3VWWnJYV3VyOFpTeFZ3UUdM?=
 =?utf-8?B?a0VoY2ZYVi9Ebm9tOE9FeWhDS24rUi9VY1ZRN3lENmhQTVJFdGtJVFo3cWx5?=
 =?utf-8?B?TTdZVDFLVTVJR1QwK0JodVFhb1BGQmp3S1ptN1dkM054NEUzMXpOMGRmRkdl?=
 =?utf-8?B?UDV4QTR3S1cwT0xzc1ZnbDNqRDcxMEQ1SUN3WnRkVzl0VEFnejFCQXpNSDA5?=
 =?utf-8?B?SFc0K3UvL0o0dHIvbnRPdjk4Slo0RmQ2TWtYbDUvT2thS0g2eWJjVEFvT1ZQ?=
 =?utf-8?B?eGZnaWJ1VVNuTDJmeG1nT0wrdVpBbVAzN3RvZHdWZmM4SGNuVlk4NDRRdHhM?=
 =?utf-8?B?a1RES0IxQVozaSt4eFJDMjFmZkxlb0J5bS8wQ010bWRuUDJXTU5Vb2t3SFRD?=
 =?utf-8?B?OUVheVAwdUdla3BnOEphNEZLMTB1WHZCZTlMZHlDNWJyd0U2bmtPRWx0MG52?=
 =?utf-8?B?SXNGUkNhVnNub0RrVVV4c2NBcjlmUEtFdXNnZkVwSDB2TExPcjFFY25mVU45?=
 =?utf-8?B?Ykc0WUNsWTVWUk9zRHhPYVFLN1Vqb2RqZjZIUlVDa21USExuRVZiKzYzb3pn?=
 =?utf-8?B?WFErSXhMZmNWSU0vanpNNkRpQldQRFoxNkVqSzJkRlFDbE5wNXVqdEcwUW1E?=
 =?utf-8?B?Mm1sd3YvbldlSDVBUXRQVklqck5TKzlSd0pDSEJrb3pZVUw0L1NrWXNtWGZ3?=
 =?utf-8?B?cGJtMGNOK3R0RzM5SUxnRHhlMDM3UmU2RUh3TzMzbjd2d2N2WS9wSGdpd1ZK?=
 =?utf-8?Q?ZC34ysh6wCjDEz8IMbWznqU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oJ3obkpU3V1KYBVEZcWoDQFNoS9Py2yOXneawYROiHmcqgpVSOscpTCxw2wVFYmVwXvowfeTcSwZWEzTi9zxCpH3RBrCiOdsuGzOIyj2EVGYt7u00LS1tW5SJi2phAjTzgxiCpjKrE/37j8Und/ABD3aMe0xEunFXOWNahAncGMJ1utS/OYlTaFQ4M0MfwKTOepDElWPwDVbbIIqZ7RXi1zszxpW/hEqW2CHukgCR4cY5UMh+O+kVz7E9rvmfteD+WKvcDLv8nHSWRoyR68qKWcrvQj+XhucEDQy18q3HQ3imeKzGxHZgPzaM9K+8Di6+jAcJzsagLI9DhHV9smWf1zD0kvtRRe84GwOj3Rw3Mn9aOwjEPXobMqf8sDeN0NSSN2eqhi8jt6IEFuwSe832aWnr6aBBKOuoLR534q9+xONSrfiiuOih4cU+phStWLbwl25SEy7luANShBVCoT4wSmqUVG1zc3SNRzNxMVJ1d7WTKq6qvqgZ5gyTuM9nFfFQAFVj9KW8YIKN2oC6Nm5wnuqUe2CBf6zpG7kyQi6hyusGatI1r9LgzM30xu6QwEWAxbmd9zNK3vRK/F4p9cODfoRn9dq0ao2oFWTPJWK2NU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3a5a69-edb4-4736-1242-08de229e11b3
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 10:19:03.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: weGZ0VDiJm4VPABblb/HULlM1Xp7xU+oxOlEaDSyrf68G8NDg7Y0q4jW2fIQz3nFx55cGBX+JC7kph+NAC8X1Z54Xg967ORrzG6p5DKrxKNZW8phh/WsiM8SKBEjQRrX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_01,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130076
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE1MSBTYWx0ZWRfX0u+yCt5RJSyX
 1lDCHgRrnuZwvzWtKuwQ5bOa3rvdP5Wa9NQK69hpQTDWa17gVcFizRRkC3qdfGQqymTl75p+3cY
 Xes6uJRF4Mc95hFU/IzAdumCgfoDT2RGaaaNKpCLYYDH2JCnW2PO85bBJHBrTMnVDlclIqxTAHV
 3fwgLNPaMXSlgX6XY3xv2HF4hHveLJoEmY4Br8/F0u2vALPzKXDlMMu3Irc5bT2iDRpUkyhUDZQ
 gKpbuXkH2COo/CZxm/kJ1BHrkCj3uK2cSKcSuq/3WwiX6n5FJexpRcom4sZ8QgUr/GwQ70WgIks
 gE0ruhIsAQJmXgsOyBlEw2rLOySY0R2NUpk+06igOtJLnCVW7MghjqJwf1slp6Ny3FTCBzf3AX0
 hluFeepyjfJw4KS7M8rKSIsAIqPzMEaVtrqPui86fPdwI+9/gM0=
X-Proofpoint-GUID: n4KzcJyqSILqT-X1JSVMLZ0XyXKWpK29
X-Authority-Analysis: v=2.4 cv=ILgPywvG c=1 sm=1 tr=0 ts=6915b09b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Jz3y10b_B2rAnVD6WZgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12099
X-Proofpoint-ORIG-GUID: n4KzcJyqSILqT-X1JSVMLZ0XyXKWpK29

Hi Greg,

On 11/11/25 06:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.

link.c: In function ‘is_x86_ibt_enabled’:
link.c:288:37: error: array type has incomplete element type ‘struct 
kernel_config_option’
   288 |         struct kernel_config_option options[] = {
       |                                     ^~~~~~~
In file included from 
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:8,
                  from main.h:14,
                  from link.c:17:
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/build_bug.h:16:51: 
error: bit-field ‘<anonymous>’ width not an integer constant
    16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { 
int:(-!!(e)); })))
       |                                                   ^
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/compiler-gcc.h:26:33: 
note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
    26 | #define __must_be_array(a) 
BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
       |                                 ^~~~~~~~~~~~~~~~~
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:103:59: 
note: in expansion of macro ‘__must_be_array’
   103 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + 
__must_be_array(arr))
       | 
^~~~~~~~~~~~~~~
link.c:291:22: note: in expansion of macro ‘ARRAY_SIZE’
   291 |         char *values[ARRAY_SIZE(options)] = { };
       |                      ^~~~~~~~~~
link.c:294:13: warning: implicit declaration of function 
‘read_kernel_config’ [-Wimplicit-function-declaration]
   294 |         if (read_kernel_config(options, ARRAY_SIZE(options), 
values, NULL))
       |             ^~~~~~~~~~~~~~~~~~
In file included from 
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:8,
                  from main.h:14,
                  from link.c:17:
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/build_bug.h:16:51: 
error: bit-field ‘<anonymous>’ width not an integer constant
    16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { 
int:(-!!(e)); })))
       |                                                   ^
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/compiler-gcc.h:26:33: 
note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
    26 | #define __must_be_array(a) 
BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
       |                                 ^~~~~~~~~~~~~~~~~
/u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:103:59: 
note: in expansion of macro ‘__must_be_array’
   103 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + 
__must_be_array(arr))
       | 
^~~~~~~~~~~~~~~
link.c:294:41: note: in expansion of macro ‘ARRAY_SIZE’
   294 |         if (read_kernel_config(options, ARRAY_SIZE(options), 
values, NULL))
       |                                         ^~~~~~~~~~
link.c:291:15: warning: unused variable ‘values’ [-Wunused-variable]
   291 |         char *values[ARRAY_SIZE(options)] = { };
       |               ^~~~~~
link.c:288:37: warning: unused variable ‘options’ [-Wunused-variable]
   288 |         struct kernel_config_option options[] = {
       |                                     ^~~~~~~
make: *** [Makefile:249: link.o] Error 1
make: *** Waiting for unfinished jobs....


I see this with bpftool build.

let us drop this commit ?

commit: c8271196124a ("bpftool: Add CET-aware symbol matching for x86_64 
architectures")


Thanks,
Harshit
