Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795164649;
	b=5avbNKj8EVg5tk1o+4LwJhxS/lEAOLIcqWCUrFg6yuJ+nSJs9gQN8YuZcvPg5YDLx2Q7
	 ueOv6mY1zZhOkobP4SechdFNfVf1EzRT1NfCoC3yKVaDHef5PfB/AnYe/8ILIvO72oFjA
	 SqrTASHHjwJ2/h4WHRRoHI+lNloxYBz1k+ekKhxdegatXY4WHO4TykWPI6lA+qSah9MVv
	 Q9NqUp3I1bsBxBuqH+Q2Gb5cdhs+zadRN1iJNlfiwCp8L3hn1t0eLvKL1sNcqjuSRujiU
	 /6A2zHkhO3eMBE4er2+ad8qxuGXkwNHrLj3efboCwLEwoWt6vSnnWZTqODpyAyTGVzQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164649;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis;
	bh=h0tXL1xe7wlwYJ8i8bvRr2f9aVKsuZ3nwC+MunLSJuo=;
	b=5T30KqS+Km9u9ojvBytUICAwaE78m7YiM+7i7zGWU4Ay+olViNOD2GIvh4es5+9kNxBK
	 6JvvEHDNr4n2SPn+LIHZ+QoXZx78vckxhC8kGBwOsokvjPZgvI+nmBtCcJhxkYOaHxuGg
	 ucQeUQrJL06H35KyIdnhrnxucTXhY3si/7IFbCiIwMXq/P1oHIFGUFayZc7AiQZUm7tsb
	 cIVRM7pp/n01akYiLV9BZqWlajE94q8rH2kWS1zId2AS/UFIB82J3bYZ70bCTSqv6hLtt
	 Rv6sZeJoAHMKgeOmyJWpE9diOb/TnA1FCFVxl1IOHMGbSVzGWSlpYj+v1m2KpNZepVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=MaNtShaK;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=gcOx6xZi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96451606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 08:50:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96451606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=MaNtShaK;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=gcOx6xZi
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3UV8S1658152;
	Fri, 20 Nov 2026 08:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=h0tXL1xe7wlwYJ8i8bvRr2f9aVKsuZ3nwC+MunLSJuo=; b=
	MaNtShaKW69JkB/6WXrKa97MGF7oviNTiv34fog8xd+dxn1vWMUs5JWNqyYJGQO0
	mgSQJDcimAg9EALR0GjKybq5XWfBGpP4S9AkEE98lob3YHfVYb+ljm7NniiVPvB/
	nClzIo5OHFYucFey2zxr5SOLWJfc2p277GSlbNdGfNddkuEDDsM9yLQEp5bkOI+g
	599BmMwAUkGiElac+NUZvYlzfL+Ylgu5XRQkBk6pUQ8vvhul3Pawaw+0F04ZUzKw
	edRnBngr24e7Bc7IRJQeUGFsELtvZLNSDX64NhPUEFxscawAwEqoHe4q89hkxdlG
	d6fgnsSw7MCwQQEQcaKidg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytq4bfv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 08:50:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7eG2Z3686040;
	Fri, 20 Nov 2026 08:50:44 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012056.outbound.protection.outlook.com [52.101.43.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2gd3655a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 08:50:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cz6tq/EbH6CUqdrEsZRf4jjdto8RCH6/qokrqsvn9q5CLvcPIYEAlGWBhtWHLVw9GYm6K8WwNaRFr+gumT2oP88KfMjOkEaZ8aOfdFFTMxhEGOgDM5BHnRrMUz+qXCUCzU52MH20D8XjjFd34easC0SoGSFniofepEdkzhgCjK/R2NOHQn3uDU/sdF1FCc0pQtDPL1s6tZssFUShv5zFrZNfvyhI1+JuUrcUn2BLc5b9DBKhGlA5A94X5PtjNJwoC7bmsz/N0WIzknK76B9Mnar9M0VolMSIbHPTeB2cckr0Kfah/+lkZFCn/m9zIssYssVBpSNXwrrCMeobGeAO1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0tXL1xe7wlwYJ8i8bvRr2f9aVKsuZ3nwC+MunLSJuo=;
 b=Adfyyx2btcg/YH+H4hTv3I4Xo4JYE/uIxBUlj4c3x8XQUVt24VSoJcdoac6j8wOvfV8trCrky8IEslib3J9ErYkscobXV3CHMVvt5AkDtBpQgFSFr00ERymIrVLutVOPNp7/T9DE5WNB+92a/ztxILGSellFXX/TWA3B1TLFbCdNgf8wZHeDgyGzX0zP4b48YH23ElDGlEyN0JM1HVNumyX9ba0nTyFyCNj+1frp1zWC76JsTk9JI4mmfKRArVCCD4FXLETRqVhq0lY3uN7Qk4WmqwqjntbYQ8Aaisskbq4g4Hnr40cKOeY7JNE6udK/shQhvJwARwVmDbC6M6ECCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0tXL1xe7wlwYJ8i8bvRr2f9aVKsuZ3nwC+MunLSJuo=;
 b=gcOx6xZiMK9Vi46dwRUQtoQtv9H6YRzYTHalMX3TQrm7VZFAbUTjFGzbELENVAq05F9f9eaBktKshtkdH1JwqR6z0W9jDpEuW/FiGxjGY3nquf+1+NG2b5LAVEO4BJC4tRgRZbTMCntbtm4eOe0bRxKKtwdXtPvFAC/YNzm44Ow=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MW5PR10MB5849.namprd10.prod.outlook.com (2603:10b6:303:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:50:42 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 08:50:42 +0000
Message-ID: <a66ae595-37bd-405a-8ce4-d29da68a70f9@oracle.com>
Date: Fri, 20 Nov 2026 14:20:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0609/1756] scsi: ufs: core: Serialize AHIT register
 access between sysfs and host driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Peter Wang <peter.wang@mediatek.com>,
        Chun-Hung Wu <chun-hung.wu@mediatek.com>,
        "Martin K. Petersen (Oracle)" <mkp@kernel.org>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150033.201167822@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150033.201167822@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0653.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::23) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MW5PR10MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: 39dec5e5-ae62-4797-81bc-08df46e35b8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|4143699003|5023799004|56012099006|261021121427099003|261022105027099003|261028144727099003|261026121527099003|261026140227099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9SOWYSiDEoGGQVja68idst2R+7wJXNCGcbqDFTwcN1noGeT0oItzi8FQFykNC8ZbYTw+HbWiOl6uBGIe1bjBWjOF0890tE/VYc8J1Pd0va8dShs97fxotlRekWho4XmnRySsFDpUUBHZzYeGaHRLt8uikrSWO7vCl9i8S7ZclJtlF+vbIo2cdaCgTTQcR2/CGnywIdHhMyJUDAlljbzht05tMhW5dOsRacIXTMuO5OUkAd84q+jNpCauZ06SRaxRzhKvziCAGBhBuTql1OrJhYFM02H74NOQoH087a8wdUgU/IfQTg5rix3OCLZmtGJM2z+j14D2dqF2tEXF6JHj6FAzRA8bK9hVKLQpfLeMzgx4WcCOh1PQYoyQsKF836dG0V3xSWqd+lvPccHuM/9kTppu0DGRcJiIizAYkhmKDSDVCrPi5uLtOTJQ83HfKWX8ToKVwFYrrDOxutqieXKxwvnHkR/eg5udxkw7KScoKkQXGhWa9lQqNxQz9QaXx9R9SKN/igAfUu0SBe3Wq7GMlufkfCA5iFcIZCLo9Ue2FQuYrM0cdQIePFx7mLC7ER4xamNVqkMmTwsuJE4jm+LL0OSzTnJPWlFhwmMOJE8PyNdBhCFvwxQdQVuOIOCEBXGT+/gv8thB9o5KULU2HF8fFxYN4lwUoPpYyKtr928LUxU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(4143699003)(5023799004)(56012099006)(261021121427099003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1JFRXFLOWc3WG8yMUNhUStmbGNUR0VMNDRPSEtlSU1CUDdaNXFtbC84cmJu?=
 =?utf-8?B?VFpFYnV5OGFZOVZsbG5rNXY0NVdvVWFpRC94MGJKczhzWmdUV0p3bzlIbWlw?=
 =?utf-8?B?dDNxZ2dsRmZRSms2NCtPMVU0dXdPd1BTNDhaMURsWDdROHprVXZMNmJ5ckZF?=
 =?utf-8?B?SnVsUFpCcXNOSnpYdCtZZDFmWlgxcUdteFhOY0VvcGNhdng3eVBXemMrOHYx?=
 =?utf-8?B?bW5CNGlYaDA5Unl4Mm1aRnNDNFRCamRSeE9ML2lXbExHMzVJbFExbmRaYitY?=
 =?utf-8?B?MnVjc0h0OHlZL3hmYWhDMEN3eEZ4S2xvY0IzczdBUUE0bmJ4VlBNOUNHOUtz?=
 =?utf-8?B?SzNmVGgxNG1WNDkyZitBdTRvLzhYa2FNTzdET2J1TFVRQ0RFSE1wRVRYZkhZ?=
 =?utf-8?B?UlI4NEplMlJzZ3FaMlBmalUrYVpGNDJWaGZmUkI5TmxuOEhQWXRzeHdudmZ4?=
 =?utf-8?B?SXg4ajBOd3pHM1FTcTBZbVdkVjRnWUVUV3dEdkpCd3pCYTkvSlVqZlpuK2xW?=
 =?utf-8?B?QTg2SHZXMDJYbGZoNVAxSjhla2xOMWVGb1ozWC9xSzlZT1FuMjQzeHVsaEVz?=
 =?utf-8?B?dzlIb21jcDJ1RFhkTVE2enV0RTFmZlJVM2NhcWU5eUl3TjhXSnBXUGdRQlcv?=
 =?utf-8?B?M0gyNnJZWi9pS3RlK3Ixa0RaUlVpQVpuUEJvNmFrSTlHclFDOG1rUWIrTlNL?=
 =?utf-8?B?QUh6d3ZJUVZIbFluZ3VucXdCTmJMTEZSSHk0TGc2RUk5M3o2N0J6aVJyZUZI?=
 =?utf-8?B?a3gxNlRHdllLYnRIWFhJMzljN3JzaDRiSUlEbFY1N01qZkRSdTRkL3ZOd3dN?=
 =?utf-8?B?R0crNGwwVkxvOTQ5WHpoOGVES0R3ZndQdlJHSDR5cVlaM24rdytqSzZkMjIw?=
 =?utf-8?B?MHFMczk4dUNDWWFSMmNkL1FqTTRONGQxaTdDQTR6L0Nwakpjd0Z6QnhvOVNB?=
 =?utf-8?B?MnNxekd4VzY0NWdDU3EwWXJKNTNId1lzY2NtY0FGQmxGUEtXM085OVFjdHM4?=
 =?utf-8?B?VTN0QnpaUWxYZXYwWURPaXA4ZFNXM1B3WkpQeWFuWU9NVld3ek9VWmE1ZTls?=
 =?utf-8?B?dU84QTNOMzRVb1RQMDVvN3NuTXlCUzZvNER5YWZ1QVQzUFhFcTIrNW85V0dQ?=
 =?utf-8?B?TXovOCtVNEZseWRQaTBmcTU1aFo0YWthZVpZQSszVzNsZEs2akwrdmRSbmxh?=
 =?utf-8?B?djhNSng3TFRZbndjclJIeUIwOGorT1dKbjg0ekp4bHNJbldlMXlhRFBDKzdw?=
 =?utf-8?B?OGNjN1J3eUNCZ1c3ckd2N2dGbzZHZjRLUWsxMW1uTHRvZ3BpZC9zcG9Zb0FO?=
 =?utf-8?B?cCt2MU1RS1lTWHZTNkVQU3ZXV2ZmdGEycmo4NytVR2N6d2k1UEFOdUlvTndY?=
 =?utf-8?B?UVB2Y0Zva1czQm1NUDlMamRBL3pzK1JEMVloSVQvdytCWmc1SkVqN2REL1RH?=
 =?utf-8?B?Ykg2Z2h3VlZKYUhxemRCeFA1MVVWTElpbjI1ZCtKR0tZaW9EWWlIQUwvUmdz?=
 =?utf-8?B?TWlDc0FBOUtMSGF1aVVxNnlJbzd1cHJZN3ZEb20wMSt0eTZQd2FhdzZmWm9O?=
 =?utf-8?B?dmpVVXUyaTNOSVpsYm93UXUyVUViVWhtbjNQQmNZWXE3MGhuVmx0WUQ0bFZ3?=
 =?utf-8?B?MWlMYUpiSG1MR3lFOC9KT1Fic1ZZVHErUndSYUkxeDhrR1RWN2VOQVhXcWF1?=
 =?utf-8?B?R0FqVnU5cER3WW84QXpSTWl3QTdzNlF0dDF6eHB2eTR2OWk5bldWYmZWdTBI?=
 =?utf-8?B?WFQ0UXBiVkVOaXI0Y1BnMGsxY0VKL1hhaVZqcENUZjZIYVBiR1lxU0wvT3h2?=
 =?utf-8?B?RmxTWkVnZ2dYYndLTDhRTFlrSnMxemkrZXRwM0dWM2FIOU5wNTJ3NmhYOE9h?=
 =?utf-8?B?djNJMnlZSHZLWjZkbXorVzZxOXVwa0hHS05pdDAzaitlaWs3bG1icGdGM21B?=
 =?utf-8?B?YzhiR2E1Vkt3VXpLQXlxb3k5YmpYSzVRVThlallMYjEzRjBOQW9XMlJCbExH?=
 =?utf-8?B?UUJqMjVYb25DTUswa2FQZWcyRmM2SXgzMmk5SDN1K3V1V1E1VDcySlFhZzds?=
 =?utf-8?B?S0Z2Vk5jcXR3eW44M3NlN2FKVlVOU2JHeC83VlV1VE5qSnhxRkVZd3R6UjdR?=
 =?utf-8?B?L3VEeWNHV0wrb1gwMVhSbkU4ZEFzbE9RbGgxNEFrZDQ4dDNQdVZMT3lMRUx3?=
 =?utf-8?B?RXVsOGcwVHUrZFZkMkU1a0ViclRKaGJEbmtwNENUWkVVZmxzR2ZSMDNXOTl2?=
 =?utf-8?B?MVVwc0QxTmFOaFc0Rm9ZVlU4dmdKK2pRVlMxL05aRVRpckp1b1ZyTE9RTnFn?=
 =?utf-8?B?UEF3bTBmY3Z1enluT1Q4aXAzQnhiVzVLWTZQVHJOeVgvcUk1Nm9IY3BGZGZv?=
 =?utf-8?Q?/lmMpCvmddbtOcGU=3D?=
X-Exchange-RoutingPolicyChecked:
	J1kASyBdh4Sq0ELt8kcq3sF/BgUOp8eeEaV3mvyoEXn/JlKPmvmsnciNeSF2MdJbHfMQLdkLlIW4aC84JC7zx4aYCnlNrGtULgwNVaIjDZj8RcJOCJxICc0/TZQGukX6T/i+6Q60k6IJyJhLMIWY8cDtxdy+3oPfMGU0cSEZpW0Hb+HCW7O9PIv8XQk4MECan4d2k+ThegqUPBiXs407xho5ohRlhVnMLJIHHyF9pnM+xLKQKJ9BWCpZxuR/PwLRfAbjLTmA9Bb+tOVEdvRTI1XerbQGZ0cxrQPt6ZuiUlom8empp98ChKBWrg9TlhP7w2I+W5/nmusEJ8TCxneiqQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6vXLEIK1cjcFMcpQs/eMXgZlR+obccbjZkPzqQc+OR/uzmIx9FgKMPki8DH3rYP1h2FzKlneEJxLwVX5cLp6WZtTRLvTMClrOywph4J9fQIvbUjYMpqafV2OR+A1t6q8CZRQWR3ePv/giiV9Udz4dpnqGEbRzgd7ECGssigfiiKZMWRqGdhuOeRnIeGDFKgz9yjpHb1LdfJsl5bF7TV7kxalyWTSW1sWSatpgaF+YyHCyPA9oqVN1dCRIOudnMhWyxFS9JKj7cVuHGYvXV6+uhnJ4H9Y5mcO63pQMT9nEJQvGKmCGlmBVbaKf//vOkjxSKY5HkeeX5peMl1mh15CmpRusMTzuVgXwylUSVIUIyyhGaNbzf7bMl2aYD+p8atNiLhImhl+Y5dHvq+VzkG+IciN+smfbdJIIoMZG0cZHhnqNfg+OYFZJuFpU0eb/ImkOY5G/xuvs4EUYzoFxOQKXMt1bbvUGatQNzfkirzNgNL2+bKtrmSfgf3kFfJ4ZTAIP2b8YSsHhZyQUq9uWlA3sZGrQUf6GJl4H1l3r4Ot4Mur1Cfu2Jxi+lVGdZApnf9Q1v8ERZ6QQbiRioYrdTOeNIeB5A+qHSymd+A7dWUWO7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39dec5e5-ae62-4797-81bc-08df46e35b8b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:50:42.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9Hmq1nQ0Cfgx7X/JoULGIN0dr83bYvT9N6kBZOtHmITUYyZ8/o2+NwMMIznhXE+0IqZd8OFeTHLWP4y+qlLNstbiJhzliOY4WwdUydWFwDXyfakEdRh7D7B3y88DFpE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200034
X-Proofpoint-ORIG-GUID: itjuTxWz9PKhK6YP3LoSY2XGQd6sHDqG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAzNCBTYWx0ZWRfX+qW513+IiDj+
 m75cZ6hD8CdZ5I8v5TWV2T6W1Qp/4t4g5mWxX9Vz7qpY7qb/QcoLVcNTYRKC4pR9jv1CV3ToeGS
 wPCnbXVnXST+Xtr5Gxi4QP/fMykCH6eOZTQBhj5lX9RDkVB2WtKV
X-Proofpoint-GUID: itjuTxWz9PKhK6YP3LoSY2XGQd6sHDqG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAzNCBTYWx0ZWRfX97sdMsRmjilW
 NzfIzZm8/nFT7vQnG3frPuG0OCeimJmHPUyq8YyjqsgT5kyExdoeW5PKMEg92oZOqxW12/DKB2P
 36vWb7WYUySBbzcAFAVgAMyTbDKyIGOfdX97cXgjMjYphJSxlcLpPdK6xpOID0TEyHScYnfc5pC
 fcSIUrZChBbJPQCwG71gvZk0gwqFLbXQxyZZYyh5p+UbJle5SiOaeg3pS3fh91pU4HqvdfwSLYr
 Oz3l782yNQ+78duXehZUn2/LdGmrb+r98lIszmvuT1zYeMaE0j4NUXM8YJUoqSk/+qC6HhgLMuR
 pfx7KjoM/U2kMKv1TU716wCrv9YOEMyqGRIHdjLEyuCujhtdbk5M0uxR2beeHtP+URSisAf8uAS
 ZlDyc//fDpSO7fTsc09pRBMaZVejXJyGu3x9Jq++3n8DgbjxxMCc/Y2Krk6mYc7jTEK95PRYxGA
 wdMPNGEyG7fL13YN993SU0TBVykKRLanWHrzDrFs=
X-Authority-Analysis: v=2.4 cv=I+vw19gg c=1 sm=1 tr=0 ts=6b0009e4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=Jvct_USU1sKFWdjlR-sA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13532

Hi Greg/Sasha

On 18/11/26 8:15 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
...
>   	switch (stage) {
>   	case PRE_CHANGE:
>   		if (ufshcd_is_auto_hibern8_supported(hba)) {
> -			reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +			/* Block sysfs AHIT writes while we force AHIT off */
> +			mutex_lock(&hba->ahit_mutex);
> +			hba->ahit_disable_depth++;
> +			mutex_unlock(&hba->ahit_mutex);
>   			ufs_mtk_auto_hibern8_disable(hba);
>   		}
>   		ret = ufs_mtk_pre_pwr_change(hba, dev_max_params,
>   					     dev_req_params);
>   		break;
>   	case POST_CHANGE:
> -		if (ufshcd_is_auto_hibern8_supported(hba))
> -			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +		if (ufshcd_is_auto_hibern8_supported(hba)) {
> +			mutex_lock(&hba->ahit_mutex);
> +			/* re-enable only when the last disabler drops off */
> +			if (!--hba->ahit_disable_depth)
> +				ufshcd_writel(hba, hba->ahit,
> +					      REG_AUTO_HIBERNATE_IDLE_TIMER);
> +			mutex_unlock(&hba->ahit_mutex);
> +		}

I ran an AI-assisted source review of 7ec96d05d7a0 in
6.12.119-rc2 and the report looks correct to me.

Verdict: Take the prerequsite before queueing this patch.

The new AHIT counter needs POST_CHANGE on failure, but 6.12.y
only calls it on success:

       ret = ufshcd_change_power_mode(hba, &final_params);

       if (!ret)
           ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
                                        &final_params);

Upstream calls it regardless of the result:

       ret = ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);

       ufshcd_vops_pwr_change_notify(hba, POST_CHANGE,
                                    ret ? NULL : pwr_mode);

This matters because ufs_mtk_pwr_change_notify() now does:

       PRE_CHANGE:
           hba->ahit_disable_depth++;

       POST_CHANGE:
           if (!--hba->ahit_disable_depth)
               ufshcd_writel(hba, hba->ahit,
                            REG_AUTO_HIBERNATE_IDLE_TIMER);

One failed switch leaves the counter at one. Later successful
switches take it to two and back to one, skipping AHIT restoration.
The new depth check also suppresses later sysfs register updates.

Upstream supplies the failure notification through 6efee14ca0ae
("scsi: ufs: core: Always notify POST_CHANGE even on gear switch failure").

I think we need this prerequisite before queueing this patch.

thanks,
Harshit

>   		break;
>   	default:
>   		ret = -EINVAL;
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 70dcc13d136d6..cca831cc800f3 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1001,6 +1001,14 @@ struct ufs_hba {
>   
>   	/* Auto-Hibernate Idle Timer register value */
>   	u32 ahit;
> +	/* Serializes AHIT register access between sysfs and the host driver */
> +	struct mutex ahit_mutex;
> +	/*
> +	 * Nesting count of host-driver paths that have AHIT forced off.
> +	 * Non-zero blocks sysfs AHIT writes; AHIT is reprogrammed only when
> +	 * the last disabler drops it back to zero. Guarded by ahit_mutex.
> +	 */
> +	int ahit_disable_depth;
>   
>   	struct ufshcd_lrb *lrb;
>   

