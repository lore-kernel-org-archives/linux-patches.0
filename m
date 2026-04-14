Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34602C3255;
	Tue, 14 Apr 2026 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776182865; cv=fail; b=iApbzDeK9IJauqqcS9QJc/zaRzLFgqqkZxr59bFlyQNsWPYCpr3FCBcxjDXU3r4eG6Mj91msNzpnpKXwRZDe0VXfEq6uVd1TxjN3liE3yBFQ9gs+Vv/wnif4Vu+9ZACvybr+4qg2i7Yb8XrbvNjwifBqjUfy32RL0n4zf1NDQrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776182865; c=relaxed/simple;
	bh=M/Npr6YBPN7PrAmuzg+1g3vvNh0MyvyB3/4vBvzkDV4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BB4goOi0/OAezGkDi4w9c5DJV/uHR389jd2RtE57nFFO8oBwoB8xu2P57rFm2ROQH6maTLUd3fRq1DTm9yEB2xAFuhf7gNeD9ofrV4RTK239v6cdjeWFb20J99QGpoFU2nLMOERBofMh0ccbidrTiUtmGuW8TOwCXpVeA+sdI60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ga1RVJlS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H0KBZJ2k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ga1RVJlS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H0KBZJ2k"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63ED24hI4056463;
	Tue, 14 Apr 2026 16:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nkULEokzJBhn/qSndviiWtsbYF8c+FFp2NDHkoJS47I=; b=
	ga1RVJlSfHydwiRo6mjUcapBcpGi+NpKt+F2V2nYGLnDTnfCzhmFvslZeDo1gx5V
	JkPTycglDrR8Jr83NTPbEemq4wKB+aMJGEMQBRU1+jTvddGuxjf/lh+1LPJvEZCP
	e5UbFLlKFt3gDrBed8H/trLKZFijCAZNIvNg3TkD2On2NrHwD6GC7PGihHt88YYB
	PnR6/frubOSGG1ehNtYtkdj5A8RgA+RMjWC3U3uzYU1Vsosb/J+c0l+z2Xfk3u/q
	bpRx0SGnF2awNd3cdh+hy4cTe6rxJ4+Gu/IISLqQQtM6UJcNuDJBIp/Rxwksccnm
	YpWeCobWkgbgz3UYB9g2zg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qb4bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 16:07:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63EG4SOJ038846;
	Tue, 14 Apr 2026 16:07:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh9jpf8t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 16:07:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XlG5ceO0dOBllrIh/01tq3FokWvGXaWfsbXRWo303kWJzHoO3gKBDCeaQNn324uFVM6k7JUEG4YZwp5yCDQmtFQ9wlcprmUHje4nkJVp9PPTMnNgydN5vgbxh/3lyhidZAV3eCwGvSEfV9RWr1rC8vPWc359nEjqwF8O8kvCjbt9qRZZgYYfUOQUcCe+1i8niyizwr/AAfeDcXQH+CjsX+Wrmgh/2rh3rnTDsjEvY7EpRrXBDOAwh/gffQROFTsnvkxFvVcG+SSv1F7Z2QHrb1x2UpzzsCG5gwjsGqopcesMSL7wvk7byAig+a3cHAOqWTc5TE3FtvteRyDjjVNSAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkULEokzJBhn/qSndviiWtsbYF8c+FFp2NDHkoJS47I=;
 b=ag0x9vgzysqipJ79vaK9A7ZTbDoBberCoV4hNqL79kgXoL+enIlA0lvZ4KShcm8aGAFQ53do9xqikBChRZr7LzzPZGEnRTKR8zs9lbDdaT1UpRCyVE2hfM3LqG3wzq7+V2ZxEaJxOnnVzbXkfHkpavjVnskGOfb9fYXWZi/mbL8clUH00HJji1bR0A+1lw5sjD1XQJqrvF8+Z+Y4xumggdinV3gehN2W989Eg6/QlweE/Z2H9x3edcKCE7Qw/uMPLLYlCRlaX9oeonyy2kiQj5nJJr41dMc+tHaGHpuc0VvK0zZXFdipGaI2xnYEnU2+3HJTjVdyRv3kKe+AI31EEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkULEokzJBhn/qSndviiWtsbYF8c+FFp2NDHkoJS47I=;
 b=H0KBZJ2kr/nG7BOrWWKhV87+l/wzRR5ScaDtcUFw5qWqenfWneR80lY0ln4yTvl5bIR5IVlO6oKKvk8pXFYVdlhDKErfIE2rT/DKPMf9GV3XbxlD8XmtN3Cm1Veohrir5ePWo9Cq4grTxVVJxHcqxiW31x1x7dA+Bb3cXVXYplk=
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6) by DS7PR10MB4878.namprd10.prod.outlook.com
 (2603:10b6:5:3a8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 16:07:33 +0000
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83]) by CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 16:07:33 +0000
Message-ID: <ed7ab018-9a77-4e8f-8480-cdd92c4758c5@oracle.com>
Date: Tue, 14 Apr 2026 21:37:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 177/570] scsi: core: Fix error handling for
 scsi_alloc_sdev()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Junxiao Bi <junxiao.bi@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155837.087422683@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155837.087422683@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0444.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::17) To CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH5PR10MB997695:EE_|DS7PR10MB4878:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b42f9b-d861-4e20-424e-08de9a3ff016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PceEfM/Peos04vIvQ7NzQQKHprB49X8AK8uBQ2lwRDqCHWmK2gpBgDCex5EM0XtJFuVkMwWRnCUN2Gt5Tpa8+Y+EgoyHhrz3y258nZZj4Y7796OPt9KXWPm6tIOV3veryS4CJ4naCntVV9VKsJpjYZgCrr0fzEoQPs1Yve9PkPguUI2dhU744nk3yfJau5rzAeRPjkQb2WgAabFKiFbOld56tgO6uVxdN0pAZp4GG/UXjmsQ1ocOGqF70Vwzh67qd4tlqiygF445f11hQMApLptEd6pG8T2vTy1ntCU5MsZqqkFwST8kydL18mj25ztxlGMSer5Cx9Be8wWt/A2aBt/rZxLeuVjrSz3jdY2oBglGXyamPaQC7sJgt47m2d0MiKliJHKES1FFgKltqbm691yBBqONft254nbO0FrbWkQHz36c9MewOF/YsBJ4ujT0UGWd6H42yJMDB95WNIY9a+5ewExe1bT22io1DAANB8x25BA102nSmPT5NKVbomBMGhYizzqHojP9WenyNUaOlBb3HnzQFLVPgJQ8JZr+kzLBBaNMIp97sBXIfLMfas0GJNpaFn535UctoX6IhySda4CVqzY3NqSGvqSIOeQgubRrgjSj6jzqGeQolaiIwv7rvyVDL7CqX5Es3Dy8Qu1FQ4kzyhd68vXRvkBYNrJ/AwJoJfWYgySUXv/klDW49+wO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH5PR10MB997695.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmovUS9Ec3AveGx4RE1tTk1ZaGhwOUVBRm9oRHhHeWViY3M0ak5TbCtTTzI5?=
 =?utf-8?B?M1crcHBoVVpIMW9zM2FnWmhYSm1RNGNLb2NQcWgvS0Z2QmVzNGhLbVlvWnFE?=
 =?utf-8?B?SjBWMEN6QWtCTlE2OEk2M0ZXeWp6Mkt6dGx3ZnF6K005VVY0SHdxNk5Mc3pV?=
 =?utf-8?B?NFRZdmlnNG1JeDQ0Vm4yYUJQYlp2c2hDWjFYMkVMNXd0dFBWY0hKaXBlaWVQ?=
 =?utf-8?B?bjJGM0F4cWp6dGtiUTlMbE8rekVRVDlBUjE2OVI0cVpkVkhlc3ZxZjUwTTBj?=
 =?utf-8?B?MGVSaFVKRDhDOVpHeGtWV29GcmxEQmdHSkNaYlZrS0RtMXNTVkplSXZZVHBW?=
 =?utf-8?B?bVI4ZWRrOGNSbGZhRnQxR1k0ZWc4VTgrN3VTRUFVU2hnd1pvMzJNeHJxZytY?=
 =?utf-8?B?RFNDaUJNQXpLVHZia21OSEpTWEdBNzZYTzU2NW92VHM1d2ZaZndxemYxZCsy?=
 =?utf-8?B?S3VhcXYvanFyZFFHa2xWR2RYcFl1WWZxUEUwYy84U1BIam1YUjQ0enRuOTNM?=
 =?utf-8?B?am42U25GR2tRVHdJalNVMnc4cXF2aGN1REI1SVJwRDcvVU9XRytvWEk5R3Zz?=
 =?utf-8?B?Q3J2YXVHMTFEa2RhVXJGbHJzN1haWXFzVHRMRk9nNHBOVDB6QjVNSzBIL2lo?=
 =?utf-8?B?dlVwV2FJUmxoR2ZPQXpzNnlaK0RqdnUrQUhYRnpBcWNhMEc1SHZhSEVvRklQ?=
 =?utf-8?B?WExybEVrY2E3MnlIa2hZRkEyanJmaTlrN2kzU0NIdzVaNUk3bWpQU0twMEM1?=
 =?utf-8?B?U3B6V2hXVE5NaWd4emtKN3NlYnQ0dUl2T0tWTXhibmhkZGtLQ3l2a09hUUhK?=
 =?utf-8?B?SEtyaFpqeUdVcGVYL29ZdzJPN29vWDNXNE9jVGRRTEgwWTZUMkNXQ0VteFFt?=
 =?utf-8?B?NzhnRDdUajM0NWVHWlhSMzFjSGhPNnVWcGhCSjVrS1hsNjE2M25HTVpZeE01?=
 =?utf-8?B?RGtoUU5ONEU5eStQdUdtSU9xcStDamxtbFdGU2RVOHBORm1vbkYrOVhycStM?=
 =?utf-8?B?Y0xjZFoxbDhCN0dNa2tlVXpBbmthcm10R24ramJTM1dDZjFvYXJIYis4bTR3?=
 =?utf-8?B?WTBGMDlVS0JQaE1tZUVyaCtHZ2pjRWFBbzhxU3g4TDdXMTRyY1ZZN0ZCZ3Bj?=
 =?utf-8?B?STdqTlJmVGxmOVJFaXM3b2tsZHp0Z3dwSEg3dHROdzQxSDBzQ2xSVTB0WWky?=
 =?utf-8?B?TXVtMTBBYjB1NzVtRW1qclNtKzMwa1NwTmJwVzV5cWRRbzJhcGdsTDRzZmNM?=
 =?utf-8?B?WUVKajdBcGxWT1pid3R6Z05Id29mTVFMNzltSUo0aE44YXlIUGVZOVdKcU50?=
 =?utf-8?B?QUZHeDJ2SzNwVm9objZaZEFTMXU2c3NSMmVoSlU3YzZZNUk3MDRkdlQrVjhj?=
 =?utf-8?B?QXJianF4anhnbzJ5aFdCOWRZMFBPTVNJVVZDRFJxeHdJZkpCTGVzMU5tb2h6?=
 =?utf-8?B?TmkzTE12TUlBZ3lZMWJqMlVndTlWc3B5TUQxRVVMYU55RnZnekM1aGcvTTNU?=
 =?utf-8?B?cUFRVW9iK1IwajUrM3MwTi95ejk3bUtGazVtUDFaR3UvTXlPQ1VRdGxxdGdp?=
 =?utf-8?B?TXlONlNiWE42WDJiaVJyRkdhQ282RG5XWHdzb1pnSG5SNUhxSGRaQzY4UHlK?=
 =?utf-8?B?KzhRNm5tRElrcGZLZDB1WWNkcVR2SXQ2eGNPRmkvWkJrN1BGYUpML2V1NlpG?=
 =?utf-8?B?blBxUGZUWUVRWW0ySURqQUJXckszK3dkUFdJYXJQTWx4dUFPV1hTNWY2eXFU?=
 =?utf-8?B?eUV0c25xVHBJK2g4MDRZeGQ4RmJvUmgxMktqc3Q3YzFPVzVaazZLOTJFUUsr?=
 =?utf-8?B?c1F0aVRESWVUajgzYXgzbVZ3TzFJZ3VpVEN1ekxOTU9BU0MwNzg3OUhmRGhs?=
 =?utf-8?B?RUd6N3o5ME05aHhPVCtyN1doKzJzaWEzTmNYMWZMNXE2R3lkNGpQLzVjSFI2?=
 =?utf-8?B?bTJDUkVua1ZsQmJRbU9NMWRtN2d1RWlRRm1KSFYwOFNjeTM0OVNTdnpPZVVR?=
 =?utf-8?B?eDhlYkdhano5TnBpemlTY1hEd21UZnlWZ1VPaHBlMUZpSk1GMXdnanhqS3hz?=
 =?utf-8?B?TVM5cnVvcnVOYjhRWjk0K01YZVBoSW43N3J4TXJrbzEvNEc5UmVNcWpQMjdV?=
 =?utf-8?B?WnQ2d2Z2cVVrdFN5TUcwY2F3a2hGTFJpTDMwcXZmcXJKZDRkWVhoSjRMZEk2?=
 =?utf-8?B?YXp0Y0JMYmxPc3VMTjFiYytGbmp6elBjK09iajRvMVJvRmN3VjJ4L0g4ZEQ4?=
 =?utf-8?B?MlFUalkyQ2w2c09hR2VETlc1cnEyMXB3S0pYZEM0ZDU4YjJpRGVvT1hVT09O?=
 =?utf-8?B?QXRGdU5vdFVGdmE0OUJDOEtwSlNZZzBDS3ZqK3YwOGhIVng1RGhSK2xqMjVi?=
 =?utf-8?Q?CPGjINURqfE8v8X9LrdELeOsmYLsy7aCC+xv4?=
X-Exchange-RoutingPolicyChecked:
	Eit+zMfl2t6AKyRUhqW9SbZw81Rrn54LYKcJq1/ZswxF93bqz8F9Qh81xd9KGU+FBZ8P4grzeJMHLvjLCFXgoeBKJRVjBt8FPrAe2Iz6xshROn2CDptVvwrWNtw3D0W7Wp5/tALzcdn0eauS3NPvnuH0odLyvszZ6BGXTM1KcZ1fTeWOlTAIbY8AkMvpEBHoNS1RRllM1Y62/oxR8e0bmM6BUdJEpNMjk4o3OEnkAgkU2ZH3c1khFbRiDmuVFyJ7a6qFWDDcDBneYuKayygnbgw0dbEwMc+lboVewAG2WDdOYUydMSaOzawHQSKnOnEN3uX1p2Y1wHTGXstKIPTa4w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f7kaDTI73ULrGafU53/QRuCZn1RPFb5iZw76mGYTqYN/uRIgwdxAkdp1/VpE1/9v+tJDUb53APzUjf/lY6dwCOg/zHjaSJ/RMNkWYAt+N27DnPFLUVLFS6uavcIqW0fiPKudcaf0fVZw368O4MHtgMO408A8F5Qx7vTA4AzgIRTBL6YR5nbsTizzCRS/x71rpInYBkiiUwgKln1Y/xxHKC/GXAoBcUPMfoTJLhJPeBzq0tAN3CQO4992S35Sv/adZBW4yV7e+tbRAG+TY8jfWd9H5vE5Xv5AxEWYs9zgd3stI+KlXue6WH/DGfU50H7RVMVQrUBnYmk5M1VrKMTh9mFH4/2a/kA5vLM5PR8GnSHMrtDQGbRd+VTMkoqbmNRrjCdBqnukt0Rlfz+di1dVevHtLYor9Jdh2qC4cODs3pM+cy3ALBbNepcjVzj6F62C1jpVu3hy7+eHA1pacAP9yyE+0+xWhC/bOTMSYOPrMYwdDV91EfQxuQlg2maJx6mXHQ7JDfT0Xw0SJHR0qj9yIfmR7GWXP2BB3WRrAubyOmTlpBHgOTCTQrKquACUp/bRkhLBWUU0dgez8uTMIhH9Gqi7Yo6lK5j2WqA9O6eZ+xA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b42f9b-d861-4e20-424e-08de9a3ff016
X-MS-Exchange-CrossTenant-AuthSource: CH5PR10MB997695.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 16:07:33.5958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFRZcB0hW/sYbzYLC9FRee2E648NvKLtujWbuxr1ShG0WErlHUUz1ssNwZZSzG0d9H1K1bIceV3IJOU5j1u+jNSV2XsLoNfy+VjVEFisoq8R4NoF2dZRrawvFLpN4KPT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4878
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE1MSBTYWx0ZWRfX5JFSu9FvhBPA
 aevJIEgSZAf3ffoU1SvXJODV/g6Fr1zzzTWTbSzmIaqFn1tYxxzH06qLDrXkNRQlYdUP5y7NRyy
 BK12CQHc0sw+sl8EsY9ONB+GmAryu5WTaTYqOCSnNu06vOMzOX44GJhCFPc4kofNX8Y4KcIy5VN
 3q84j6brY88MJiO/m+C0Vs3I95am6WMt7xqmwcfVtbb3bzh6LLrkgn3wBNYcO7X0ykpU8FM6Q4+
 dT5kgcPjHO64Iw7FkAzgIvkBgMRJjjRWMotwMBLhbiLTILEAghMKQ+jgcPk43bXq2K0rILR+Bzh
 mc/NGNtxb8B5UOzVqX1CtyH/JTitpfRVFZVuhgPAifcpeGaSUVIaI8es/OAdnOLQ7k7yeVMnAiG
 pbFbmpAXFhyG+tvcOeTc/CE6tcarh3CztqI/p6gkUcSdMxXk9sOjw7FCvImw7fGGcea406e6+BZ
 B32SyVFus6Oucg6ivxQ==
X-Proofpoint-GUID: k_Oyh_3KCs-BG4m44dDCNd_MqNRHQk1m
X-Authority-Analysis: v=2.4 cv=V49NF+ni c=1 sm=1 tr=0 ts=69de664a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8 a=ag1SF4gXAAAA:8
 a=U1mkKabSaDXrJzRWatsA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: k_Oyh_3KCs-BG4m44dDCNd_MqNRHQk1m

Hi,

On 13/04/26 21:25, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Junxiao Bi <junxiao.bi@oracle.com>
> 
> commit 4ce7ada40c008fa21b7e52ab9d04e8746e2e9325 upstream.
> 
> After scsi_sysfs_device_initialize() was called, error paths must call
> __scsi_remove_device().
> 
> Fixes: 1ac22c8eae81 ("scsi: core: Fix refcount leak for tagset_refcnt")
> Cc: stable@vger.kernel.org
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Link: https://patch.msgid.link/20260304164603.51528-1-junxiao.bi@oracle.com
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/scsi/scsi_scan.c |    8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -339,12 +339,8 @@ static struct scsi_device *scsi_alloc_sd
>   	 * default device queue depth to figure out sbitmap shift
>   	 * since we use this queue depth most of times.
>   	 */
> -	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
> -		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
> -		put_device(&starget->dev);
> -		kfree(sdev);
> -		goto out;
> -	}
> +	if (scsi_realloc_sdev_budget_map(sdev, depth))
> +		goto out_device_destroy;
>   

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issue is:


5.15.y doesn't have commit: 21008cabc5d9 ("scsi: core: Move two 
statements") - v6.19-rc1 based so backporting this patch introduces 
something like:

   if (scsi_realloc_sdev_budget_map(sdev, depth))
           goto out_device_destroy;

   scsi_change_queue_depth(sdev, depth);
   scsi_sysfs_device_initialize(sdev);

   ...
   out_device_destroy:
           __scsi_remove_device(sdev);


calling put_device() before  device_initialize(), so I think we should 
drop this patch in stable branches which don't have commit: 21008cabc5d9 
("scsi: core: Move two statements") in them. Upstream moved 
scsi_sysfs_device_initialize() above the budget_map() call.

Thoughts ?

I see the same problem in other stable branches as well.

Thanks,
Harshit


>   	scsi_change_queue_depth(sdev, depth);
>   
> 
> 
> 

