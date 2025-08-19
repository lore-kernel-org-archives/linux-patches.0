Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E5F2550CA
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755620952; cv=fail; b=t1ulTwhDyU91cFZSZad9goFPmW7wD9LTbjm/Xad2HH8ZW/1bCATJBKimtVCGlXsLgMOAkL6za93Fcmz20nthRjB9rp7e7bab8DyQAAMexHAM1FdKefDiofIwfxoPZ0hypzGLp76/eOakLHUAjH5OnQbOJjGuuPfQctBveqK1l/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755620952; c=relaxed/simple;
	bh=d0HKSWgwAcNgVyFp0OUGlyspgB7W+MQqueL0THZC1wU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YXKAAaHq5rLdmmXKPVWQFsqzs5IJ6Gx5Ik5Taq8hFxmaQaQuioNTdPjd6BFGCRiEIdTnQWNf+EAkfFbLzrzEFlIQP66iydR1mp3ZyesxFQliKRFU05GLp/qcp6SQQuxOY0Ok1OBcpIY4Umas8ET1Hi9i4HYzX4aHD+qoVD6v5Tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q1+COypC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jEuNeFRG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1+COypC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jEuNeFRG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDiuOp021696;
	Tue, 19 Aug 2025 16:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ptbH8lpuU+HG1ZFOS6CNkzrSa/xAlvAh/uQZjNmeY+M=; b=
	Q1+COypCKLD4wROmMcYfr3Fu2tgpOWGuj6Z2yl9Yhq4CF81tUFY7A/eIOM7SDWfK
	Qf2vfIRieNh/+oqQ3na72dqIJklGo2Y5rwmo7EzF5rRYlHMg88fZ8WX0xB4WBV3C
	MXpuK7eX6xY2Ex5K5LbYYJI3hNXkHQXyEmbAP9nzEDFHMcKFpEME3S0UygTl5kpw
	zr74wey1VoC8wXxFvC1+aunsRi7YJ1n48EZ8Be+SKbiX8m9DXPNNKVA7CwlK03Kq
	Zpm4iQWwJ41kjiEICCWNU2dn6IU7UnSPBHKAxwMmfc1vEzykOI9rovUJA4ptsP1x
	Qj3jzfdhomMvBdnNGx1kTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgs5nsnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 16:28:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JFRFpi014533;
	Tue, 19 Aug 2025 16:28:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jgeapwb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 16:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBVnBEVA+5P1Tg0b9kAa6a++TgnhlKBtYXC6wcw9kGSBn+ivkq97QA5Sif77e9eaIyWG/cH+xjO5pTkMjbaULN0g9oqEMTH8t7X5SkipB0pF/wZgMvV0UlKE2rdPqImIii2RM7s8Ynqsl8Qon4/2C3YWQ7wtzBntQpgjbUVXTI4v7UgKB1/05wUxd8Cjs3nYJFQIQi3Y7M5LtpvNOFjV7Y+BpNmrbXLhlbpVaOrPoBDkBvz3cUDdKa2dSmfpBUQR8T5oQYVx1KBY2y0O6PyJcHwfKromV/rEzdcxVX0rNCqeDka5Oj9KJXTYa65Uq7wRgO0PLiDJ3AxZGi9uS/0HXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptbH8lpuU+HG1ZFOS6CNkzrSa/xAlvAh/uQZjNmeY+M=;
 b=F/RmkNycaVuUikW8pJ7lhwC07EymEm+2J3LxX1B5bC+xsk3sRxBDT8wvHxrQIZFa03LjngO0Cc2xGNGpWO1OBIJhQq94+G2mRsj8f/occgdm2VpBQs9sDHrw0SMODEJabAlPNCxSYprxW7X3ut3QC5UleiC7mjtgukOvWG41mlftC/vD+XSV9xkc+8DypnSEq6PmqFsjKtTEGj1yBhvRYN7zRUU9b7m629EOSQ4Cnl10IhHn9yRUSj26VAIoGnOq07ReDbjXABWywnbQbFUHUIJ7Us1bs1EBVkV5ddun8SMVZpdKCPJMB/aFWBtgeRzhFFttwFVK59HctWpzRRw1YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptbH8lpuU+HG1ZFOS6CNkzrSa/xAlvAh/uQZjNmeY+M=;
 b=jEuNeFRGKvZbevAQPgpysnLnAqi0VfS3i+vq2EBnA47dAvUim3eeRKJgcaZ7fKuUGhYcG6c1Nv1WhXqZvKHtpvmr/ModNYqtWHyuSXzXsEIZ6/M5skEbiSvJTdTGY5lu6ybUaqZzGEe4G63szqme+8U7ryQc9ceLGMWMzMFRq6M=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by SJ5PPFA634C6E92.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7be) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 16:28:02 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 16:28:02 +0000
Message-ID: <67d5bfd6-ec01-40b7-a3bc-37034e6db2af@oracle.com>
Date: Tue, 19 Aug 2025 21:57:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250819122820.553053307@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0205.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::19) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|SJ5PPFA634C6E92:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0506fe-ca37-4c4d-47af-08dddf3d5dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWdkRk9LdmsrdW1wRHZsU0oxNWY0UDE1RUkva3Q4dzBuMEhFYzBKd3BIWWJW?=
 =?utf-8?B?dHZzWHM2QnNJR0kveTdZaVE5b1ptcWJ5aGNhSG9RNmpOdjdGUEdSZHh5QTJD?=
 =?utf-8?B?dnZRV0hwcWJNeklyNkNRNWljcGxkeGpZb1E0Q1pVcWpaMmdOZ3ZpZE03V09U?=
 =?utf-8?B?L3dua1AxY3N3ZGNWOUlYT3ZCNWhVL09pcWJmdnc1YVR4L3FNR2FDdWpjTzJP?=
 =?utf-8?B?dkZwUThWZzJvWkQ2bFp6NVpGaUtxRlkvdG5ZMC83NXdrNll3SVJEcnpxa0RG?=
 =?utf-8?B?YW9VdU9QVVdvdHBUb2VsUzNHWUZ3cHNycXRndzNKMnpBaEZ3eWtEcnpCbDFi?=
 =?utf-8?B?OUxFRTlSblNjUmtBUFN5cHlkVU5rbjVHakJ6eDVwcmNnNlRJTkNiZUlhY0JO?=
 =?utf-8?B?dllmMjB0Q3dDUCtUMU5vQnRBcm9KVXdHVzk2czhrTEpQNXB5YWtwaXBqRmsw?=
 =?utf-8?B?emJlZk5tNTRJR1k1U1Q5dHN4bk1lZ1lqek5VSXAvZ3RlallTWXRjc1BnVzhv?=
 =?utf-8?B?ZzVQMTdDckVadXpOWUxLbC9qdUw2czJuVzJsMmlLOHJOU045YTc1WTl1OVpF?=
 =?utf-8?B?b3gzZ24rdG0raGRIdmQyTFhuVlJsUUdSK1V3emVWM3JxTVpnOVBHU0V6ckZD?=
 =?utf-8?B?KzlWMTI5TlEyNFozV0lDc2hlZ1lncjVtVWxpL1FTam1JaG5neUtXaGQwMHZH?=
 =?utf-8?B?bWk4VlozcnRIMEE2b29HakVqZGdpLzNUS0g1UmRHcHQrdVpwQVdlUlRSKzc2?=
 =?utf-8?B?dWV3R2taRG5oR0JaRjJaMS9NeUFrL1NqT0F2YlV3TWh1Z2JnWEprM01Qc0lH?=
 =?utf-8?B?ZURjUEVaKzZuRlZYeThCRlJCejRzU0lvbVNReTN1VDlyZXB5bks3WVI2Y3Rl?=
 =?utf-8?B?bjljN3B3aTh1eHhMdmM3bmFFVW50cURGNHBSUCtBQnVSbUNJeWdpU0dnaWEy?=
 =?utf-8?B?OUxSMnBVcEJJOTh0NElzMFRDblBlRVNSU0lyUVNuZW9KWmpoQVpwMkFIZ3hY?=
 =?utf-8?B?UU5qaGhtd0wvMHlCbk1zNVhOZENaMmZnVVlQTVUzQjVvR3FNSmlLSlB5MmxV?=
 =?utf-8?B?ZFNrY3h2eUVjbjNjOHlmaHJCVDBIRmgybXZRK3QzcXY4dkJtWUN1cG52Y2Ir?=
 =?utf-8?B?SDlHbTNhOWd1eWt0NjVrY2NwR0JEVHZFMjJVdlJOUFJhczh2ZmxOcUo2Zkh3?=
 =?utf-8?B?LzdudDJKendQd3NKd3ZTNFJRc2RjUWc2Q0VNblVCM0tnNkQybFBUeUdkVEQy?=
 =?utf-8?B?TU5GSUlLd1R6K0V1aTd0RlBXcFoyVUhjNFkzZzE0WDF3WEZ5N0NUYUJ6WjVI?=
 =?utf-8?B?eVdHYmlkWC9rN3h3NHlYblhxUkpUbWJTR2RDbjFMS0Z5VkROUlBhK1BvNVhO?=
 =?utf-8?B?V2tzRW0zMGo0bnJQRFVxbk4vM3lhd2dsMmRsZ256KzNqR1F6ekRNa2Z0OVVD?=
 =?utf-8?B?U1RabzVsQkFzaFJIOTYyRWQxNWI3dk1LUGRINDl5Wm9xeGl2cU9pcldLSGk2?=
 =?utf-8?B?eWYrSy9wazFGT0lIU1poUmtMK0RRYnMxMS96LzlkSU84YkJ2ZjNDN3VqL2py?=
 =?utf-8?B?OEI0dFJ6SVFoYU4zU3NPQWlHYjc3d3F4eGQwekpER21Qc1BuWGZrcnZteXNS?=
 =?utf-8?B?aVBKQU1BVmt3c2ZqZHUwcVNKMk4raVRBb3FIeTVZdSt2ZWlaMlBUSVBoS2Yx?=
 =?utf-8?B?ekNDT2o0OTFsY1BPSmd6a1pyQUpvTjRub0Ywa2xIZWE0MmFqRzhocWdrYnV1?=
 =?utf-8?B?d3pXZysvdnhjbDBCSHBvTUJFaVlSdUlKVzBLKzcwNFl6SHV6L3NXSGtqVkV6?=
 =?utf-8?B?OFpUOWJsRThTUllwVTRtckhMbzVvWmNYSmp5b2poWFN4V0pmK0k3R3RZQlV5?=
 =?utf-8?B?Tm1wb1J5eGdFNXhEby9TZGJONlV3dWhiOUVGTTVpR084VDJSMEtKS2lPK28y?=
 =?utf-8?Q?BY5zlsQVkjU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUIwcHZUM3hra2Ira0dLWlZFRGxuTmRacGhTWDlhaFV0Q1pkdGJXd3VPdXpx?=
 =?utf-8?B?anlmeHIrMGh3TXpWaEZUYWVKbmxVMHN5eVFwalFLbXBZQzd1b1VIcDlIVVdq?=
 =?utf-8?B?SDh6cjl0czN6REVkZ0FKZE1jd1BOUGE5bDV1b1RCRWw4M0oxNjhvRFZ4cllF?=
 =?utf-8?B?RmhjZlg5MWtMQWtXS1d1MFJUb1ZMNktDQy9UYWV2Y0N2L0NSenBWOG1LbXFl?=
 =?utf-8?B?VVRQbmEwVWhoTlRLV0VZdWQzdDZxaEpJSGNGZmgvZFZkWUhQbDJMNVI0WjM3?=
 =?utf-8?B?ZnVFVFBlZUhnSmI1MW1pemozeTRJZ01uZkwvSDN5T0dHZVJ4K0F6ckx3eWJp?=
 =?utf-8?B?Vk9BaXV0Sm0waW16SzBUSUQ4N3diekdTaGxvUnBjZ3BDN2VmREVKaE1FME5a?=
 =?utf-8?B?ZUxUcC8zMkM1T1EyS2FGbUQvMkhFR2dsWjc3dm5aQVh2SjY0QUp0SDRIWkty?=
 =?utf-8?B?K1d5Uk80VjUzb2ZIakRSRVhOcW90VHljN2F6OWF1ZHJZL0dFSUk1R3ltSnNB?=
 =?utf-8?B?b3pBWTJzVjQxZ0NWNWFpbXVZTHN0U0RDdS9FSGxHc2Y4YmNCeisyeWd2ak53?=
 =?utf-8?B?bTNzQzFOMm9DVVlvUnZBVHdYS1pHdkRCdkVkSnpWeVFoTWc1T0k2V2tSbzJu?=
 =?utf-8?B?VWF1ZWRJc0E5bklLUHpIQkszUVA3Umo4dW82ZTc4ajJncHFIcFcrVjJPY2h4?=
 =?utf-8?B?UWgyRlpacXdVTTBTLzRjWHJmcmxWQlFuOFZQSHE1a2hqN2NLZ09KYUxLYmV2?=
 =?utf-8?B?ZS8yNVRZcXFnK000VlNBc3E2Sll3ajFIRWVhWUxOTFMveHZqa254dHpPSHJ6?=
 =?utf-8?B?NTExY2wzOWdrTjNqdnF2L2UrcTdwSWVHekpjRWREVzF5d2NHbXdMV21ldnpU?=
 =?utf-8?B?bHp3VzZJSmUwT2V2WXRBMVRPbzhqZzBHeitQM29rcVEwbGUxYU91a0dJZG05?=
 =?utf-8?B?K2xGZHJ3UlY0aTI4S3RWdUtvTjRDYnQ4TWxWQ3krVlNvNStIaVY3NWJUSml3?=
 =?utf-8?B?RUlvS21jaXp0QVkxSEhNZnE4c2ZrQllWdUFYUUZKVEFsQXhYTHM2SlJoWmhG?=
 =?utf-8?B?RmZVRUErMlphZjNER1IrUG5EVWt4clJqRDlZSUw5d0pSdWU0SGRJTWt4dnBG?=
 =?utf-8?B?TG8vR2xka2FLUlJ0bS95ZVdmZEh2YUdVV0w0VlgrVlhvZjIycm5VTHFUNyt3?=
 =?utf-8?B?VU90cE5iSkZnL245NThWYnRjRk5iMnJZQit3TEI0ZFdGaU54SkF6a3I3WUs5?=
 =?utf-8?B?dTh4Tnc5VE9kQkZYUHR4MjRnWFRFOWV1TGhJWnh5M2NQUEtzcWlCWHdHZkJM?=
 =?utf-8?B?VllsenU0aFZadFdNdGdUWUQzTUlWSCtxK0dBOURJbkZ2VGJ2WkREOHJWc2pG?=
 =?utf-8?B?WVhOUWxPbVduUUtZSUpKaFRpc3BvYjVXRWNDczZ5UlBIQktTdlZpNlN0TGo2?=
 =?utf-8?B?WXNGbHpoWDkvOFNYckZ0RERzYjFhbE5pSWY5K0Rndm1LNSsvV0krWDhBdWw1?=
 =?utf-8?B?R0xOSlQ0OHNMS3NFYUJkbkdMdW8vK2RRYlkzYzRNWHEyVnJTbzlQTHdXSm1C?=
 =?utf-8?B?N0Q4STI3eWFHVU9VclpqQ21mdUc5Q1hYbTRHZ3FCdTIvZzkrUTM3aUs0bzRt?=
 =?utf-8?B?VHYrK1h4MytJZjFMYVdOZ01PNndSUEsvTjdUaXFkMzFpWXF3S0NPSGhIbWc0?=
 =?utf-8?B?eXYrT0h3R3l3c0R5N3pnNlhLb1JlQWc0R0hzUmhEMFgwUHEvUmJ4ckMyV09Z?=
 =?utf-8?B?ZnAxVUF2dklsRUNUamJrY1luVDR6MUhSQUxxeUZrVEVpWDRsVmpXZFZvMGRh?=
 =?utf-8?B?d2h0a05LSDFkald1b1dIU1VENXhIQ3JmV1Z0R1VsdGJVempPVThxc0k3V1Bu?=
 =?utf-8?B?NmZ2dTY5Tkl3a0hvWmRhaEdyMHZTRUZaclk2RXYrK0VRN0g5YkJsYVltYXpO?=
 =?utf-8?B?ZFFlUGluZE9sTmlya0JrYVRIYU1HbUhXZ00yNHcvdWtuNzVDTi9UbmdQb3VB?=
 =?utf-8?B?eG5GM2xmazBCOUZrZ3BTTy9HU1RPV0pFQXJrZC93bUF0elhDWDFiKzlnY0lQ?=
 =?utf-8?B?RGY5T0ZoTW1ZcmlFMGd1V1B2WUtNa3J2UUY1T1oxK0JRcThJOUQyRzVJODg4?=
 =?utf-8?B?MFhjbjNjSXJQbEp6cm0zcHl0SWVaSzgrMm9LeGVUTE0rVm52Z2oxWEIrcVZX?=
 =?utf-8?Q?12YYjuhMNt3qjWAJui2VkcA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ewieqOcP7gO47ZpZ761xcOW8ohDAWsVu9BMpOh7upExegbvyr/FNXtj/R28I+gpW24NTJy1CNKmHXagQlg77+IdaFB3O2RBZX4YxaYobzObAbGSCG9ZqPlE8obn1mQ4Uq7YCNKSCUPStTO2LcGs+BQSqGbGBvB+TZbyLEntb4NJLwYNLIPNrIk3Tb4hNRRTCrL/gzi1dj9kkPOE39E2YHjXjGaxpDc46IBoKY6Vno9x1xOR0oJ+MD0LiiorsNAx8CGTG0uHb6lfGUUWREpFRLmTQW6U7Tlql71+1oveXt8tBnziRg0v7Y1obBAcfERzYc0oqnEaGXCFgsDEWAy93wDofSljTYqyDoBfD5ZzepZBRVXfKdme/tKAgQmZTCMs1XerMzZ7aBMx/74vLd2/P4dXljE1NLWZ775Mw9/R0Xhe3pARFcOmIhBA/ClmWnsPysAAAQzE7UnLj/8D5EY61JMHy0PNPhFyJMPyqdZ/vF1cblcIcJbSn2g5nG+hRDAHXroPZy7KbU1TKqDpehsu9I2KjeJcC0oedyJZZ1x8SCPEIUhc/aCfpe70EBjgwZDQl0hPrj17MSdvWM37d8SljzaOfVrVgCeKusdITMo+6kB8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0506fe-ca37-4c4d-47af-08dddf3d5dd9
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 16:28:01.9156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQ6aDeP5mdFZt/H6EGTjRr9LuRFjAoB9lZik4D7Kyy32SaXmw7HHaHrOaGk0pOXy5AeQZiW5ie89Ij9y65BuZiILcfu8IO3QSNsVfkNdWtweWcsa7kueZxf5Ae1Rvwe2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA634C6E92
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190153
X-Authority-Analysis: v=2.4 cv=DLiP4zNb c=1 sm=1 tr=0 ts=68a4a632 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=U9ep_0Zv_crtLGRZFvwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13600
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE1MyBTYWx0ZWRfX6LIkMT/T2wBB
 sdhYDyAGae8s0GGmV3MRA9X9SWcKZizQfvmgEO1fRidD/rl9Rf/n6/Vle5l7h+nNEirppCf/vkc
 jzvTRuZbXStFf5T3W5HWWeX/qI4/HVP54rsG50neoJAIMIeb4aA0lrZafheohAeyfl9BQwuPbiS
 X62mvDeVgEBpO5JbSTGuwzunrNNPkw88D+6H+5ppq3p+Lk//eAXF5cyQbYYYzhm1zvG5x0jUa8c
 JTwlemrdf2+lqOiv/hnKMPKzoLi2Tb+rXel5FZ+yDSaFiQ3L0clqNPKKD96no0zleotGDq6Kgc5
 50c2lu8TPtzpneGoLMYgCTwCpSEZxp9DoG9hPr4F5hH1hKhKtzN3hvOCN95FJKpMQvQJe90TtIj
 9Ha8SbzSHVkxRD/OIRHFXj1iVDyyioobj6YjpSGoxK/JnnNh9EH1zCL7MpDRomURL/jiM53p
X-Proofpoint-ORIG-GUID: wIZyR7tY3k_u6ufmPNsgnEkTXYb2Jb6X
X-Proofpoint-GUID: wIZyR7tY3k_u6ufmPNsgnEkTXYb2Jb6X

Hi Greg,

On 19/08/25 18:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
> patch-6.12.43-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

