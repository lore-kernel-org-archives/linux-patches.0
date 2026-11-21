Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795269010;
	b=Lipdf1yUu0N2tZZAf3JZ/B36uBEznA0zF54foaGQ+/jrC9XVWlJeDebXdD0zbMRxQ12T
	 na0ySvYTqpvswHe46WwJVKGyPi8lIVvSpANR5YrF5/jepMmKYBJUCOzbypKvfDtSzEDs7
	 3b6SJc9S1j6cDDCU5YW4XH85Sgsk5jDX56aG+WAl2Yr2dOOm4vr5GjzLnDm0G5YfIXF76
	 DQLSxsrTgIXGI5elDRPu+N+brGBorobKB+R/MfGdR8pJ+D2Uqv88MfiUwurRdNUNArbw/
	 WM6rBAo+ekFgwu6ud/2Avyps0F0t7XeWVhgAAQG+GJ9kSG0Pi1AdCgJbuPsB15sr+gQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795269010;
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info;
	bh=/lF2Z3e9HLpAFE04mb5usQv/Tdum0idiU8OhtOTeoRA=;
	b=BoKjfzKiI8xFEcbj2k/hIglvaIuPsCv1SUtGbShyjC9LwYCtURmk/ld7b9n4C1FajEzc
	 bEdpAcJR4qTBU1ndx86NuVbK1DMaWBGzY9+FYiZEtZQalEEbx0gZ5t+nqFo7HAci5mWzW
	 aL5Tr0WayMc+H+zq/Zo83XlDx6XwGqVXrNj21ad+nFSHVOtT/FTD9/k0Rwod6jgWw+KDj
	 tZhJV8Y6jGBOJl814HRYfAjxoF9CKR/eJWWiymyyU1gs8O9NcEUi6SwRa+czw3ihUteyz
	 LnEwWCwJE/eUT6vjdUeBRmr+JRSXa7Kn0tPmXXD+aW/mCHvsuxLivlkNzZK4hEQeS/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Jf6gxOwp;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b="dDQKo/l8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFA2606A320
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 13:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BFA2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=Jf6gxOwp;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=dDQKo/l8
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALC09WT1987616;
	Sat, 21 Nov 2026 13:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/lF2Z3e9HLpAFE04mb5usQv/Tdum0idiU8OhtOTeoRA=; b=
	Jf6gxOwpXvjxzidrGXrVKUS3+PUFa3rL+Zv5GzoXNSrctAROepad8rnhlG4cG9En
	gCn/VCdFpZmTdPQoT0m0jSwVLxEKQHDUabTecqd9syAcFkQd3nruVP7dI0grknVZ
	KdANiH1MhgtcYia1/zJl5KUkC+UHCDIyXskoXBFD78eYDXFOhRov/h1CwB4/HfP3
	WjSuF9rzpLcOjtLtTz2G1miA3/EbzW7BEG03/gSwgVLTKjdYHLbEKLAkU+FmuVHH
	QCDpmX4wuIoo/I8DbiUzgrwavMYQaCXTp1uoH0ark3IJNVdd16CjGOXdxYMbuZrk
	NPmfU5jthxJss5sm5jxDyA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t50790-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 13:50:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCI0nq2582060;
	Sat, 21 Nov 2026 13:50:04 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012036.outbound.protection.outlook.com [40.107.200.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j38wf3k0y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 13:50:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KsCfwvVhCUtL2C9rO2hHi0ag19cLJ5ULRd1Izn3wgDybefhjdjudMxLGSJO4koAOlpgs84Hn3muNpuKanON1F715MIJvwc9pxcnkGn4N1tIV6eEHjeYuQL7+8oYGnp9K9uZoLqQzC7yB7+z0QdudmxZdn6xyjtc0VCM55Qu8z9dRT8XY/qSdu3BW7ioFFrJOfbW2UNIBSzOxxpc0lC6WLiaLbjXSKV61gSnk/eSTqaUQndePKSRaUf+aIc+1NSp0vDIWx10YMy8wY5KDPuvchZ/VF5sBBljWzLUwLYhY15DwYKt5+xzs8iS21+mCMVW+DaI1FPq8ySNgya/Yh98UOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lF2Z3e9HLpAFE04mb5usQv/Tdum0idiU8OhtOTeoRA=;
 b=Y7YZ0/JaJJZ9T0cHZPgWneJ/nslrS5yN84ysAX5I+M2NBlJH1fuf7M80u/MwrWegRMXQFD+gA83/2Fg5dhEqH2CvEFU0XxGNZzKODKP+H0nyS3INwWWJlhl/jea9tjp35TMWUeJ/M0WOvEEOzfspB+k+wh1tWk+mAioCNjxdYmIPgcwtTtrLnZ3uhHHPX6wKRHuf37eQErQhLDnPPBMJwICe7c3Q2cls9q/jQh1sR2HRZOUUucfEXA11Yft/2KJVFea/ITJ+Rz8oDjknAbudw6mPSDLKOTZyieHEw/MBpCK+80wEf/ujx3ECzThryDFYcPE7dWsquIkPvJAhEpbRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lF2Z3e9HLpAFE04mb5usQv/Tdum0idiU8OhtOTeoRA=;
 b=dDQKo/l8Qomc8mq/sVyC0hddbPj2mFIiKLK+1XdPmiJcBY2QWf3rJ15e+MpIj69QMsjM3/rh6YrCWuiBCLN/e+fXApekCH6xwuz5FBRB4qUSQQL2AE3+m9fDRWu6Sr4HqDPtDN7IbTFLfosXf208txvFGnzNtDtgLbSQDgGthYs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sat, 21 Nov
 2026 13:46:59 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 13:46:59 +0000
Message-ID: <49a59c88-3bce-4c31-8d7e-143f302fd508@oracle.com>
Date: Sat, 21 Nov 2026 19:16:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0855/2214] ALSA: us122l: Add missing NULL check in
 usb_stream_hwdep_mmap()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Bin Yu <byu@xidian.edu.cn>,
        Cheng Wen <wencheng@xidian.edu.cn>,
        YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
        Takashi Iwai <tiwai@suse.de>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150046.375887703@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150046.375887703@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0224.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 01423b5a-680e-4174-001b-08df47d5ea48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|261026121527099003|4143699003|5023799004|261022105027099003|261102123227099003|261009223027099003|261021121427099003|261028144727099003|261022075727099003|261026140227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WGW9yKUjdrdMCUBBPogkK+ZIdq2iN7Dhunb/VAmTb7ksiExeZxxR5GV+8Fz7uXN6II1lPt0zhScy25rn/UTfeswkeYfr5UnNYtcmA+e0hXHyuUfxxpOVVBGGt2T8pNctE8ATnChz4eNSlKc0/gNhNXtAVQDjTj7x5A84p2l+pbdavZmFgtuz3QLYtsBT2EOc7MBv13tnI0xjsVpL2RDMMmNH3bIKECDKABOHYcRSrWbp8IygWW0HFBjw3UC1JEWcpI6DhI3Klhxtqfa694GPExk3wYtk1v0pk2PfcXlYtfSq5Yw/Yyb9VNOmXFy8SGsypWbbnkIX1uvYQsuOJcQ735gz67NnR5roVtAC+0HyhoOuts1zz++A2cAoGphtPfjzqFFloS4YjdvADWyutj9otcEjw0QCfn+EWbLucy1+CrIzxSbGrtK7iEAIdwzPCYTblag+sO1FuYI3/NJRgyb6cQeVlqh4HbyONe6nkm+EQJEa12WlInvwYodHXExSMY3wwFogQ5QTWruggGJbA0EbvyW8+EN6SqdxJl2WflF1rBOz8G6QxsyuJGHigsgEOp0sEEbhky3tN+CkQS2OCkPFNoFo3HJr7ecJDFG2nWk9mRk5kwqk490UbIY5FkRqEoFZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(261026121527099003)(4143699003)(5023799004)(261022105027099003)(261102123227099003)(261009223027099003)(261021121427099003)(261028144727099003)(261022075727099003)(261026140227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0FjaGNYRGhtbFRndFFkTUJuMUdzQTZ1SisrMDR1c3pTcFIwaXhvM1NMS01k?=
 =?utf-8?B?aUVGZlQxK2UwbTMrS0F1blUrRFZYblNWbzgxdVNtMjJkYVppSGVRVWZBNksy?=
 =?utf-8?B?ZXlQK0FnRnpXNHRTczhjYzFndUtVb2hwamdtTi9BYlQxSTVER3NkcFdaN21a?=
 =?utf-8?B?TVA1VVV4OTRNblpVV2tRQUJ3S3AzcGdFSWtuUEozdnhHM2xLeCtERXI4VnRo?=
 =?utf-8?B?OWgzMjJ2UWRJTlNiS3BnaGJqemI4aHBUQ2tnZWtkckZuRXpHbCtyKzMzcmVE?=
 =?utf-8?B?VTRUUHV0dUljYWY1OHMxT3FLaWhNNG9pemY2VkRBWFV4dTNnK3d2dXZ1Q2pD?=
 =?utf-8?B?d1QzQytxRXRDa0luVlJJL3d2emtMS3IzVVJEZjgrR0p6aXRDVmFaV05OUE1S?=
 =?utf-8?B?QmFoak53TnhkUHJiVE5Gd0krdTQ0dDdoNGEzWGxCaVpwUmJrUUJHREY3WTRR?=
 =?utf-8?B?TGhDck9ROVkvbVdaMUNkbnc5OW9TZGp5TnA4N1RNb0VHRGptSlBUandzMHZm?=
 =?utf-8?B?a3Z0Y3BzclE0T3ppeENHVlZ1a2RRS1oxS2lZUkJoWXl2V2tCVU5aWjJSVG9M?=
 =?utf-8?B?Mnc4LzRpVzZSR2xaSWlUZkJ3d0dSYks4U3pacC9XU1Yrdlphc2hxTjRYMmpw?=
 =?utf-8?B?YTZPQkYyeVF5N29JNFllT3E5QWdSemFPUzhBdXVXQVB5OHZIWjVTOTZKQ2x5?=
 =?utf-8?B?ZUZ5QXR4a0NpZDhaSm1vN0tNckF6THd5dWJiZVlISGNCeEtHcTJOWm8xeDJ3?=
 =?utf-8?B?VFJzcTFIZ0lTM3RJbURLWVNJL0gvNXBlS2UybnU5NkJPb2FRQU15d25xUnY4?=
 =?utf-8?B?TU9xbUR0U050OGpHaDdaa2RNUTRtYUxQcTdVb25JTUFXTTRCWEpoWWQ0Zysv?=
 =?utf-8?B?TU0wZFZGQlZ4M3Mrd0xIRkkrd1RSRGhuUzQyYXQyS0o1eXpVcTNJWW0xV08v?=
 =?utf-8?B?WmR4M0J5Y01uYUhWU1dYZ2d3MHltaUpZOVFPaXhuNU9IV2VZZ1lMSUNnZDV0?=
 =?utf-8?B?d0daNjBHaVA1ZVp4NEJCS1ViNkIxR1FIK0xUT1FwQ2F5YmpaOTFiZTh1eHlF?=
 =?utf-8?B?cVhlL0VqZlA5QzF1ZFV0aFFySUhvSGQ4YWpKM3hwb0d1NVhKcjk5U2JpcGFF?=
 =?utf-8?B?ZmVWM3JJYk10R25GcG5wL3F0amJuWlF1b21tUnpNZlhHY0RnMUcyRkRVWlVK?=
 =?utf-8?B?MGx6ZUszZjh2L3NEdS8wcGp6OGJhNEhOdFBvbG9SUkVIUGZYVE1temg1d2tD?=
 =?utf-8?B?WnExTnVJcVJjMnM5a05yTWZrdm9NRzlmU05sc2ZxdmFVMWVnNkUyWFNtWDI2?=
 =?utf-8?B?eVZBdEhuWGFKN2FBekUvemhXWHJYREZOWHhHSjNZZ1l0bmtDUHB3a1BTNzhC?=
 =?utf-8?B?Q1FOVXZCVXZXMFZkWG1QUGhUbUFEYitFTEVDcVVydFJ1N2JvbGMyNW1DaUJq?=
 =?utf-8?B?U3NQeHJheXAwM2wvVFpXYVlpNGd0MXFvTk1EUEpNQytEbjMwdE5NTnZXUGl4?=
 =?utf-8?B?VDJZK1pCK1JYWmlKNTNIQzJSVEQ4b3A4Q0FKaVc3SklpczRrd2dzVXJYZzlV?=
 =?utf-8?B?QTNCVklkckoxdkpXSW01c0FvNTVrRHRKbWNpeFlxTjVaL0pGMGJLOFBLZFZD?=
 =?utf-8?B?dFIxdmlobEtQNzZOTkc0RDZETlV3VVZsYVN5bnZaSW1wZGY4WGplRXU4VEpz?=
 =?utf-8?B?elgraWdTV2NRQUpCVk5KNE5WUWZZampuRlkrWmdqaElaU0pNZUhiNGxkWGlF?=
 =?utf-8?B?MkFtUzROTXBvRW5TVGoyZXFrMzRlVEFoWEpZcit4aUJPeGxPbWZMMmpqd0VD?=
 =?utf-8?B?d2ZrbVRkWkx4VzE1eFdyTGtjdUtwNzAvcWtXYjFBSzRzOWlOckRRUGZleStV?=
 =?utf-8?B?MnRFT0lJMk1wZ0JSVWhGVFExY2tvOWgzV0RSZWs4Z3pmb2c4Wmh6cHphUTU5?=
 =?utf-8?B?MEw4bElXU0RGYmFyNzZ1cjh2NmNwY3U5OUtsbUhUTEV3UVJnYnV4STZrSTVy?=
 =?utf-8?B?SHVtenNYSzZScHdVVXNRcE1MNGI4NTJiYk8xUWJtVTBtQ0plcitsS0JtMUJW?=
 =?utf-8?B?bG8yalJTYSsvcHZYMEJObkFKVElKaEpSSGdPbUdVTWpwVmMxRWY4NDZWVDBB?=
 =?utf-8?B?VDdRTTRBcHRBV21NS0hCazNQWEVUdFdFdWtXdEwrbmtSNWgxc0IrNFRJNS9t?=
 =?utf-8?B?OGtwZE1CN0RGZ2YvU2ZjL1MxYTVRNWxVbHNBV0VLaC9EcUhNUThXWU1JVi9j?=
 =?utf-8?B?d0xrNFNNL3RCV3daVlIzeThyS2NHWXp3dktVdGFNN0ZWY0gwWXc0a1BFcnB0?=
 =?utf-8?B?VWZSbFBCVWh6bUc1dnJPRnVUSk1yeUpteXNMbkljbnIraTlOYzlqcU5nL2JY?=
 =?utf-8?Q?1xWJ8QS3cgT5DF6fyAhayhPOmBWOql0AMQ0DP?=
X-Exchange-RoutingPolicyChecked:
	Z5a7W/peoHZS0dkNU3JIK6wnSCgSFGaGf8McGUeiRfuTHQxFOh0ZN5gpFtrlI7NWyp2fSA+GZdNU0QVfwkhWJhD4NDCmTd7mB3iIiXSYZJpBUvloAeqrwWqjb6rAR4QYLKhvLeQVK97fi4RK6uYFQP4q8qB3j89HSzGcp6Ils7LTqonmIJUvRjCwTJBLi2XiwmBYZY9N8GgXrJp2IAv1fCksodghkonnWgHaTQyjSeVKzlptpm/+B7O7R327QekDOs2I2+vMwZqIQCp5AY6+6lOSePx8N+Wy9PZouK7JfVT05Xff6aYSqooGWpucOhxZGu5WP8yDVLLw0xS+Rb0DNQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hYLT1veQ0BwEmV4r2h9F4Fa8jnD0o13zSd688Un5MZhUYVlL3DOkrvYolibJVsel6/Qh0fk3075ybbf9ZSrOnrKtRYRriYVKtvtC/MUJlk4XhaPxJmuXgwa4e7aJ5IJTze20kxcvhpV5WmkVrdGIhF0/ZOTX6ycURkKDPOKm2B/hayERIttQ7xXad2kxlTiGgd50Nz2xTlhCKjfvpLdNr5PXM++7bbA5mrOyrBiWIxNucwDF7EsOnEBbQfqNgftQ5vu5XxQaC718bZCvfNmE5/2cV7awx0E6JOOtfywYBxP9qNxgePSbdLPOJiyxCnJFgzD9CwrTHrBfJOzyfjodoEdKeXiXyWrI+NoZwT1bqc8wexU4x8TiXEF82M9wi6aB78Kk2L+PqghpWuT/HPTgL1kTij0/Uj0nViwHLaVvMN+DS9qgN6HDjbCm5N36DvVOViKmlh1S7s7uSoPWYFThocjL+NS3OznjSVreVTVlngrbD0W0cP9+4qdQrI+nj4/utZnZvrZn1qdJ7GH+c+0LEqNxsSqp7EA15t3Ma0sI7Ak873p7U+b07Qxr2cEWJr6snOLCuXMCzTupiiPi2FbVSvgUf/nCGR64I4gt/K0QXd4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01423b5a-680e-4174-001b-08df47d5ea48
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 13:46:59.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQfSJpuv8NfoZKLwhXLLun6iFUihw1E1s06P0vbFFEpShvs1W/mzDmz3sLpK+Sx5w146aj2Du+YxRhK7A5CHMLnKbPjmQ/fzy3pEwtn5fuqjjh2W4xGnWxL5IN7TLPGX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210054
X-Authority-Analysis: v=2.4 cv=dJIzC+Zb c=1 sm=1 tr=0 ts=6b01a18d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=VbM_KZw6P5Q3Ri731l8A:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12101
X-Proofpoint-GUID: o6RYf850xhY1L3Wt3YcGEnRHWEPT_08w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1NSBTYWx0ZWRfX58q/3DfMuC3u
 yhCJIT5arKvE00gSlugyzA/efGZV4qcK/Pxy3BNO2oimj0NiKXso2OGoOhqhBaD58sa9GFOHRdI
 BZudjNR3ngKBxmDK1b335XcRoBzSBOcOEvbsuHiyrT2JsevQrSEgsZ0RGYIj/F4kobMNsgKINV8
 7TBag23q6dqSs0tT6B3G2DJ+WtGQW1/GbPYGhbaipT67nFJ2BNgzQmyP6ZEmgeJ3wfW0AI9fH2Q
 nJzpoHHjbgNdtZqr9O+sKpsBOkBaKuV2l0USQz9I1ayFYFheKw/9SP4/M5CRtmQUY7Hd7Fr58Zf
 VOCuE/d2m91XtRKgMNlz+lcXqU5NHh1Je2fig54/49I0Zax7Z7/R79CzGWAL9IVnfGRPa6XVp3b
 G30vfKAQpj7AsFVHCHYsHqAaJZdu2Et1ReFaQ80dgqmsvfH/Dt5n2rEMazeTWa94uHm8BwWgJuP
 u2wKlWsA/EV+/tqud6kiGL4tHThRKUh7VyqRanSU=
X-Proofpoint-ORIG-GUID: o6RYf850xhY1L3Wt3YcGEnRHWEPT_08w
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1NSBTYWx0ZWRfXzlSKQyjZSQNt
 jzT/K1sWNFkt7fOkfjLvfHCl6FzuOpuFt/sbyOHjMX5iafOIKAkbZxliXNA1NsCFtQjg7eDkHpz
 j7Y/2NRawFO5rBKm2EN74TqywHgAi1bdoM5HXJF2UUQhQo1nbuBf

Hi Greg/Sasha,

On 18/11/26 8:12 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
> 
> [ Upstream commit f5d3eb483fed59fc0f3b059b8b6a32cedc922360 ]
> 
> usb_stream_hwdep_mmap() reads us122l->sk.s and dereferences it without
> checking for NULL.  The stream object is released by usb_stream_free(),
> which is reached through us122l_stop() both when the device is
> disconnected and when us122l_start() fails, and it leaves us122l->sk.s
> set to NULL.  The hwdep file stays usable after that, so a later mmap()
> 
> 	KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> 	RIP: 0010:usb_stream_hwdep_mmap+0x107/0x890 sound/usb/usx2y/us122l.c:182
> 
> crashes while reading s->read_size, which sits at offset 0x10.
> 
> That NULL is an expected state for this field: usb_stream_hwdep_vm_fault(),
> usb_stream_hwdep_poll(), usb_stream_hwdep_ioctl(), usb_stream_stop() and
> usb_stream_free() all test it before use.  Only the mmap callback misses
> the check, so let it return -ENODEV, matching what the other hwdep mapping
> in usx2yhwdeppcm.c does when its shared buffer has not been allocated.
> 
> Fixes: 030a07e441296c372f946cd4065b5d831d8dc40c ("ALSA: Add USB US122L driver")
> Cc: stable@vger.kernel.org
> Co-developed-by: Bin Yu <byu@xidian.edu.cn>
> Signed-off-by: Bin Yu <byu@xidian.edu.cn>
> Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
> Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
> Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
> Link: https://patch.msgid.link/20261028042525.8737-1-25031212351@stu.xidian.edu.cn
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   sound/usb/usx2y/us122l.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
> index 21c5a7fcea768..1e90c183761d7 100644
> --- a/sound/usb/usx2y/us122l.c
> +++ b/sound/usb/usx2y/us122l.c
> @@ -208,6 +208,8 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
>   	offset = area->vm_pgoff << PAGE_SHIFT;
>   	mutex_lock(&us122l->mutex);
>   	s = us122l->sk.s;
> +	if (!s)
> +		return -ENODEV;


I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this adds a return from usb_stream_hwdep_mmap()
while us122l->mutex is held. A missing stream leaves the mutex locked,
blocking later operations.

sound/usb/usx2y/us122l.c, usb_stream_hwdep_mmap(): (Code spacing
adjusted.)

5.15:

     mutex_lock(&us122l->mutex);
     s = us122l->sk.s;
     if (!s)
         return -ENODEV;

Upstream (f5d3eb483fed):

     guard(mutex)(&us122l->mutex);
     s = us122l->sk.s;
     if (!s)
         return -ENODEV;

Upstream's guard(mutex) unlocks on return. In 5.15, the explicit unlock
is at the out label, which this return skips:

     out:
         mutex_unlock(&us122l->mutex);
         return err;

If sk.s is NULL, later mmap or stream operations can wait forever on the
leaked lock. The check fixes an older NULL dereference but adds this
lock leak.

I suggest we set err = -ENODEV and jump to out so the new failure uses 
the existing unlock.

Thanks,
Harshit

>   	read = offset < s->read_size;
>   	if (read) {
>   		if (area->vm_flags & VM_WRITE) {

