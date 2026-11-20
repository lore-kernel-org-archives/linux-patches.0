Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795170444;
	b=kFb3BexDaA2A4gUptd++EUOe5Lfp/Oc77tJG72nVya++Lzj3+tnLJHAnPXNQ6aCOQRYd
	 IVOqAT/aEZpP64ER05OTlQwftKWaTtkKBrchhs3Pm50+3pUSALQeH9hDmegc1Ty3W0cMD
	 fc/zrc3bgSfCjcf8yyMuxgI+HJ4XJCBnB+xEGQrbyXEzXN0/Ej8EqUu5C8O3qCTxhDYTb
	 xd6S4kQ2edG9ZMExCfioMrx4nmDDLo6HWS8g9FNzqcIJHhpKeo/UXhgk0xIw2ExZZmWUy
	 pkAn2nGLLj8bAvMqkEwJtlBxPS5jAx+7pZSuBQqzJ+XyLSnfXsUnYNg/4RLQ38JMglA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170444;
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc;
	bh=OIKo8GEbHphKQhg0zu7KDrzQB9aXxV/w/UWaNwBJiOE=;
	b=1KQmRSyvqOvsFkGmeBWda113N1vaPW68kiJ6GrguDyadL6U7diipCirdWrlKZRDpgyqg
	 OgTDqpwvqfinVtKnM0VUkRsSzwTPdfGF8CgjpaLZfDy6TT04HZ8J4OGcO7OTujKY/PYee
	 plp6Np48WgrEtZ5yrT6vXmuFr8IqLegoOL5Q1DkiZ+/DNHWZaX/5od/JcoymKNcEWBRVH
	 DNyiI6FXGONC+sSo/PRimjmUaU26QoHPb3g7aUzqFn1ZvF4jwUeXM+BrKPIBQMV/v8055
	 DWkNCpASrKbXmMIHi7rP9Nf/G2hX6cDHlWfRv5hXulq09MaNL3waItld/XIMnUiwkFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=CMolPUSW;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b="Gf/STtCI";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB53606A330
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 10:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DB53606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=CMolPUSW;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=Gf/STtCI
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3LZbF1841380;
	Fri, 20 Nov 2026 10:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OIKo8GEbHphKQhg0zu7KDrzQB9aXxV/w/UWaNwBJiOE=; b=
	CMolPUSWgvbTrejLtaTC85KnSN/2rfnkSQk1XA5DJ4yjQe/ncttal7V00DroVa9d
	fKJylTGcSRwu3h+wTpeA6grmVpnjMQsqougnqbO97EfsW/l6QgFaANzrN2cealrn
	+qLXszbFa7j5txsWGOFDUR1nsUTPvR5jjY2DKQriMT2lo6QKIn5QRZaz3BRygE0x
	fcGpUq9R34c+xWpjFzWa82KA3RCPlmviliPanprnMnNnjMWqY+CxZquZYVei7YE6
	+Rs+uJlG2s+Llo8UbCdo4NEYattA7SKs7TeyS9VAkU5EBD+yfKNfTOyhsihooU/H
	nbEm7ltcENc2tKdM0NeFZg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytqce6w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 10:27:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKALVcH034751;
	Fri, 20 Nov 2026 10:27:02 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j2hvndr4a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 10:27:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TZd8bnrx89/4rJLyIDgCF3nlwd5miGporw+1V4XEE+yPwfEO4R3vGGFUnsIaFF7A8C8lO44bDUqdVIbq0qwj5h71+9VUvrdqFJOjgzDKP0lVxOtwEikSidBJ7YjqK6dBqjf7uIPETu/5RPgVkTO7uDqwPy97xMgXti2b5mZFxH0v+/b7/fPdY3kb5NrM2S4o/sKKopuJDloH99/37/qumZ2zgaa/5COwLnXB8/mRtPC+UaoT3t+Y/t49nfTuyfP1XBlg0QtjZeBJQsgM8BqDY6eDHqRVxj79zrY+qYDM7Q9fJp6fMocmPkN33wI6DNWoxNvoRf03BrIGMJE7MrxcBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIKo8GEbHphKQhg0zu7KDrzQB9aXxV/w/UWaNwBJiOE=;
 b=s1lM5J0Tk3TyZ3LNiybgclXjL9H3odzMesWIRJoWE0DXeVHSh7Ork8r75pqKJx6cnBDEvvp3AuznftMLPA73WaVZX59qHK4zYYtCBKvkklOhbIQHYNLVeXXNYOIp0MdWEjVjC0YjIG13HUfUpR/irFfu9T3I5xQIGM33CMATeF0SB/l+6Qllwyc+P67CDn/VS5nB5/t2cp0cgPx6x4pha82MLGA+ey6kdBbww7HYfElJ7YnZS4I1WgCkqNDXM12mhdrWkfcwoh1mahoKagBT56tlucDgOhGl2c4Efqo08Cuo634S4NJ19G0oBpuMXWiSD38yRmU0i4UDyZleE8dbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIKo8GEbHphKQhg0zu7KDrzQB9aXxV/w/UWaNwBJiOE=;
 b=Gf/STtCIHyHRBi0jyzwikZ+Y5p+Ij7zChRc+rvyCTn1bmyudjo2WZsbzEzyn4NjM1qyn2qW2xkRFaDhD8xgb2scjL9nzwzxRVSzrPmf7RxjH4F8tJo0WbIoi/6fsf6xs0T69LXOz3FbGwHbKE/rcVkdmLEP0lWn30Qf+1nyjwP0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MN6PR10MB8144.namprd10.prod.outlook.com (2603:10b6:208:4fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 10:26:54 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 10:26:52 +0000
Message-ID: <81413702-b0b1-4d7b-bb64-61f349c7732b@oracle.com>
Date: Fri, 20 Nov 2026 15:56:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0942/1756] ocfs2: allow xattr bucket entries to span
 multiple blocks
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>, Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>, Heming Zhao <heming.zhao@suse.com>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150047.520786104@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150047.520786104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::18) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MN6PR10MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 856d8751-f649-40b8-d8eb-08df46f0cae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|261026140227099003|56012099006|5023799004|4143699003|261009223027099003|261102123227099003|261021123027099003|261028144727099003|261022105027099003|261021121427099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HnHofwGRbE5h8YAtrOo8PmO3wUKSrgd9yFX3PILlp/m62cxRij5GNJPLYcIs2rhUxLXWIdoYC1DQg/beDWED14HBeSpc9rtve4PMul4g4nPkOrBazOmuwpGBAbO4UtlZrkoND0WfvYX6H2wmqroV/hBPj9LF5QjxDRypsWN6LdEfK6WKL72ZxQtyoZSkvGvOAD28Yaml0NMKy65QbjYpUlbHINmmxkcCML5Yorr/C+vzZ72uyboDbzdDPJmfs1ttRN3MaRWxaBR5NhrFmj5oLRFcegHK1CQ4szZqzl/FFSM6s0sUCl/8lz5d7VeFiEmPMJrt/Bn3WJs5uDne4ijL4Xnu+Medi3N25ous703SFXUVoITiQORlo/R1A5zql40wyb+39blPxSeWOevA764iwjX4yuzx9CVR2otXirBZPZfBCxvEunPYkB41MlpRTtcSqXOrCN+eKR8THbm2WebEKpiw5IrFiN+I/OTD18ueazvOxXgZ4JgwFfy1ZZTIu/+3dBpu+0O1+e4Nt/f1+curK9Rikl114DfN9sK483i/P61YZZSUqaJXiS9yLQHNLWL/MNvYaQ4T+7TZlcSTCWuZYRrQ3XnzOQHr4qJYOKO4GRg3L9C1iC2ctzJU5NlYb1OsaOt31lH++RHZ6+cSUlM1bNirPdEMsZwj/il5K41imkI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(261026140227099003)(56012099006)(5023799004)(4143699003)(261009223027099003)(261102123227099003)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHVlUUhqcXhmZDF3TzJJZzdRVlhhVmczdGFzN0t5clZjRGFMeU5ld0t2TlFj?=
 =?utf-8?B?cVBldENvTHJWOC9ZS00rVFdoQU01djVxd3J0ZnBxWkU1NE1pRGxjUDNaeGo0?=
 =?utf-8?B?cXNsWFltR2FyTStGZTR4WUVXdjI3elRXcEFBbWJ5VmErb1ZCc2hiRnphanRi?=
 =?utf-8?B?VVRmejdWM0RCT0tyblBTMUdmV0NiOEFvR0V0SUJRSkU1OXJ4RVVsVnpJM2pK?=
 =?utf-8?B?K3Blbk90MTRzZnRGUTJSWFBBUGowUVczaUFHbFYyWnpQV2hTZHpFSkkyL3Qv?=
 =?utf-8?B?SU5DRi9pT01UU0RRVVQydVZqQWkzTDJoNDBJdlYzRk95Z3BlV3dienkwK1JF?=
 =?utf-8?B?ZEJ4U2dhbHpKanczY3lhVlo1S3RuYjZFZ29DVWhMU08zV0oxcUdrdVpzT0ZV?=
 =?utf-8?B?bVBVWDdiemZ6alo2TVZGejU2Wi9lOXgwUlFNellLRkorTXNwWGVaMGVzcDlV?=
 =?utf-8?B?WjVSOHZEY1dTWm9veWYxcldsc0k0UnFWeDREaXBQL3kvcjZjZHdGK3JaczRk?=
 =?utf-8?B?K0NMTTQ2c1lSTXBycmM3bU4wRFhRUWRCSFAvanBZRGVSOU4wcVFKc2pRdGJy?=
 =?utf-8?B?KzR0U1grd3dIUC9Ybm5iLzRENHhIbVhwRlZmbUE0V01xMFluZXJRVW9QbHRT?=
 =?utf-8?B?Sy9NbnRPTVMyVUJsL0c5VFpOZmNHeVpzTkF2VFUrVnkvVGVEYkJTa0lBV1pp?=
 =?utf-8?B?NWFoRDF4L1U0aS9CZnFjU2JmcmdQQ0dQWlNNSlJWa0MrWG1KZUY2UTc5clVu?=
 =?utf-8?B?ZlJBM1ovM25VZjVhbk5sTHJiNHB3ZFRBMzBkRVQ4SVFPRUtyTS9RN0FLeGVJ?=
 =?utf-8?B?bjZyTU9JekpXWG54bitLTnZJdGpjd2lkeGlyM0FOS0pJejN3dXdhakVhaWtm?=
 =?utf-8?B?Q081ZWdpRzBxQ01RdUg1SEZVT0lUZEtsd21FNmpuV2hFanBQOFpKM09iSDJS?=
 =?utf-8?B?Rk5sN256d0Vlc0VqNXpMZ2lkdUpGQWNzZitxVmI1RGUvcFZiNHY2aDNkaVVi?=
 =?utf-8?B?OWJ1SXU3VnBySHc5ZWxFTzJsN3Rtd01XUGxONmMrTTRKRTJGMnJNRVZUMEEv?=
 =?utf-8?B?ajhwYW5Yc1lBclR0K2libHJKbEpLRDA3eFRnZi8xRHhQRnJ5TW5pUTV2bjBU?=
 =?utf-8?B?cmtMMzZUOFdrejU3TjZrNDQ4SEVMajZBS0p1WWFlUnlRRlJSY09nR29FU2Vq?=
 =?utf-8?B?VHREc2ZQaHRBZXhrbmdpODBqMnRDbEcrcE5mKzBHdnpBNEttWmQxeDkyQjQy?=
 =?utf-8?B?eWlSbjI4THhwNStaRk1VUVhzTTBkSXo0UDM0RW5kVFdKd3ZmQytNZG9VZHcz?=
 =?utf-8?B?N1B0N2Qxdm04QzlWeVMwUGZtZGdubGo4Y0pkUFhKTEMrMkh4TFhla0g3VFJD?=
 =?utf-8?B?ZEcrV0pLWjVpRHJsSHIxZDN3dkJZSmhsbTNCd2xhY0hReDM4SmFOK0Rwb0tW?=
 =?utf-8?B?ekk0clgyNFdBeS9ndlBmRFY4VnZ0bjZRbGtFMGZUc012MmN2UkpWeTdzUm9C?=
 =?utf-8?B?Q2NLZ3BYem40OGd5M1UwaTM5aDJyWnVEQlY2azJINHBlZ1MvNlgrQm9oeFdH?=
 =?utf-8?B?K282Q3FFMHFNWG9kdEo2N09zbEwreHNtMzR3YVdETmtTaWUxZytwbGRxYnpm?=
 =?utf-8?B?R0JPSlZ3cHNScHp6Qk9hSjMzM3BFUzVFNUx0NXoxL3FwWkZGN2VnaHlidUpF?=
 =?utf-8?B?TTg1ZWk0WGtVV1krRFd2cy9pNVo0SnlJRnFkSG1OR0hGTVlHTWFEeFJXSVBV?=
 =?utf-8?B?VkVwTGNRODF0Q1dMSFRKYUxsUWxiTjYyZ0R6U3FRMVQrMnczTFd4K2FNWnZp?=
 =?utf-8?B?RytsdFo1UGY5TTZrbk5MSHJ2MVppbWFQb2V0V3hpVXdhMzhJVEZrZ3hkRk9m?=
 =?utf-8?B?Rjd0aEsyUWVnSFlsZDk3MGxLa3RUVHZjc1VaaUljV0RCMDgrRmxkZEJiY1RQ?=
 =?utf-8?B?am5XVHhJdm9YZjRDNnlkTzlpYmYxL1cyKzVWbmU1MVFGTitJMk91QVlqSXgy?=
 =?utf-8?B?dGVjT2lBNFBFRi91TGJwcXVBS3hrYUZOWlh0SXVjc2l3STQvN29zbUVvZ2lR?=
 =?utf-8?B?UFdXdW1rRWdpaERSeWNicXVJRlZZWk5nWnNnS0k1dStGTGVkSXVKUmxKdmk3?=
 =?utf-8?B?eUI5YU1FNCtXRy9vUmhTRm53MklCRjZ4SElHU2p4bXI3Q210RjNHSEJFWjFY?=
 =?utf-8?B?YXNKclF1OVRzZjFaVkNBaTBLcmpaVk82TWRFQ1BwQkV5QVJ6SGhSa3RrYWNV?=
 =?utf-8?B?c05mcStGNTh4eGoxbVlnOVdqbFdkeG9TNWJLRmNKQXpOYzFtSTVDK0NOWGQy?=
 =?utf-8?B?c3I0SDd0UFpZUVRTQlhoa1NTQzFNa2FrSXdkbDlmSnFVYXRRYkFrMTZaOFdz?=
 =?utf-8?Q?26KruuECzCH5qe7htyqnaJiqKjhnfnmnjeKFb?=
X-Exchange-RoutingPolicyChecked:
	dcKWjDkAs5eGx19Dyfxyyw13RtADNNNa+R7hiI6uNdxxKb8OywQuNqQjDpVtqs4qqMC+bYKjJb66S47Gdoxp+IX4OHmIPFT6fX1XozVJIxv93fFh1q5g6H6Z71Qn1tt0Pv5ou8cbrPNVr4Y4jU0zD3umiafLzsKglixjfQZ6BRpYf/DYmHB37por3ffxUvjMuyu+Fr09O+ojr4YOOnEWQebLpQjY3V66OF7nJUnJuVVpAESbAopAn/FUAPBQpKW5JvUOhvT+zVkJG7tG6JeA/JOPG2WVoOgdKR2ZgwdkKlbdVgKkq7jdBUJUyn7jMQdszu4Zw6ta8K/M3eICHMyjbg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZCyvDXXM8KhkUQOnTT1le45Tu4FwmksrCb4Prr8uTH9ILeuqQItWR43LgKKeqlnQ2T2YlQCY9RXlO238lDDMO55PQ+zwqWjq30AarK7OAJe12BqMjEwp1oUWBRsxISzlrNYWRDiT+mRqA6EiPE/vRFbnO8VSVUiVvNB7RI9Kua/BA+mHwEXRvzTR4ins8UuNFSk6vhgzz9ymHY319k6SiFC07eihj3iKFTgOK8/vPTeKRgAJ+FUSYcRHr3uDufj+N17lvRKSXHjL3ZKPpycVX18GtE+/GAnYA8yNyTCt8Jhsd2zKKHfEN31ekRR49tiyeDv4MiSY9OElNZ3OvgMXGHNq2qLqnESscNW7nUwb5JDrHTKT21Q9WPrth5rC5WzmEJM7JOFHmHmy8W4zldvD8YQs3Z0is5GoQlmYdYtVDF3FSMoVLo0+yV9RZFmilwHQzIWEje+xE01qqH/4r42rLz8PVDLViLO4KuSlN6aq+iSe5pcm+lFv//7gZroqECO4hRUofnviarLtmco4b5kNP8JXaDfXcn9NRGo/k9ZkpGf5BrT8XQ36aPKuzFELm+I4KnnaGfdQ0Tlc5VeiTCYUG6+tjUQftV7kzTetLQxc+UE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856d8751-f649-40b8-d8eb-08df46f0cae6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 10:26:52.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/dy+Mj8stu3bewQPtERn5CIafCmFVAAwnWFu0qeGxz6o0JDUdrI2Z61pzKNT3mIJdYVIQjQC71D+5TZxjbirvzP4lmmvdpigekyJHaSlk+4SyiKWxaN86I4dbvu2id3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611200041
X-Proofpoint-ORIG-GUID: cetHP700JnPpDsRcaJzYLb5FfNna0v7F
X-Authority-Analysis: v=2.4 cv=RNkmjIi+ c=1 sm=1 tr=0 ts=6b002077 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=SRrdq9N9AAAA:8
 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8
 a=A5t-L09vW2m5A2G4IYQA:9 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0MSBTYWx0ZWRfX7E5KjSXFQsyN
 gStrkLTXl32Cr3wcyerDkGtT/pKrXbUy7tp3xrJ9dnhpE6VbiWxGPjPr4Nw78F8MVh4D/SkI1dJ
 SRBPvHwvhN5eTir+aJWLcralwBXDBqqb64mq7SQQ2ut9MLMN1PGq
X-Proofpoint-GUID: cetHP700JnPpDsRcaJzYLb5FfNna0v7F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0MSBTYWx0ZWRfXyiJiL/YJSrw8
 pLRRLg02VBj5MWAIhvh4Iixo8Q9c3EnHW+kVCXciN4LkdmKDg9eEzBtH6IHfNCRu1zZ3pGUt8eO
 QlKquoLKSSZcO9eoGRhnlzW81nSsfc5vDT1w8T2zO9JwbP9aLEcJiLIgOUYURsoTNtW+Ri4KX5k
 zQDykb+BDCqJyTPbDo6Hxd6z8Pdnll8NhMJR7l4wD4hy7f/vB6wpwn/f2mMqqfcWrJpbY9m5N9o
 Wzp/2ElIGgb+KwepU0wi6+Betfw3pA9HpVm72bpC7ODOQ/Z1/5gK2ifTJX5Z7vEK1j/SLZZ9zrD
 46YshuKUOGD0I5cx3whOqt4W1yZ4A9Y6TTKJRx/srzz/1xkk3Z/O71D4aXza7x3Hx2NqhnnNsaX
 nYkOFET3jgo/RND8KBeBXL3JObYLrb2IKM5HEJt4MYmzBIuX9YMlO26HB2l0CbgVySvhcotXXZU
 TuasKRT3KCbJhNKu2IQ==

Hi Sasha/Greg,

On 18/11/26 8:21 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> [ Upstream commit 78cce2082d22d3c56bd3a6146ef0dcf7cd661a33 ]
> 
> Patch series "ocfs2: xattr bucket validation fixes", v2.
...
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/ocfs2/xattr.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 58bc60babf4c4..391998626cf0b 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1121,11 +1121,30 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>   	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
>   	u16 xattr_count = le16_to_cpu(xh->xh_count);
>   	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
> -	size_t entries_limit = sb->s_blocksize;
> +	/*
> +	 * The entry array grows up from the header across the whole
> +	 * bucket region, so it may extend beyond the first bucket block
> +	 * when the blocksize is smaller than OCFS2_XATTR_BUCKET_SIZE.
> +	 * Name/value pairs, however, always live within a single block.
> +	 */
> +	size_t entries_limit = region_size;

I ran an AI-assisted backport review and I checked the finding
against the code, and it looks valid to me.

verdict: We might need a followup fix, nothing to drop for this now.

This patch allows xattr entry arrays to span multiple blocks.

In fs/ocfs2/xattr.c, ocfs2_defrag_xattr_bucket(), the difference
is (6.12.y -> upstream):

       for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
   +       ret = ocfs2_validate_xattr_entry(inode->i_sb, blkno, xe);
   +       if (ret)
   +           goto out;
           offset = le16_to_cpu(xe->xe_name_offset);
           len = namevalue_size_xe(xe);

The missing check rejects local xattr values larger than 80 bytes.
Without it, a corrupt value can pass the block-size bounds check
and reach this assertion in namevalue_size_xe():

       BUG_ON((value_len > OCFS2_XATTR_INLINE_SIZE) &&
              ocfs2_xattr_is_local(xe));

The bug already exists for smaller buckets; this backport allows
additional corrupt buckets to reach it.

Could we also include 415ad9147484 ("ocfs2: reject inconsistent
local xattr entries")? It adds the missing validation both when
reading buckets and before the size calculation.


thanks,
Harshit

>   	size_t nv_limit = sb->s_blocksize;
>   	size_t max_entries;
>   	int i;
>   
> +	/*
> +	 * The entry array is one contiguous region that may span the
> +	 * bucket's buffer_heads.  Buckets are allocated within clusters,
> +	 * so their first block is always aligned to
> +	 * OCFS2_XATTR_BUCKET_SIZE and the whole bucket fits in one page.
> +	 * A corrupted xattr tree can point a bucket at blocks straddling
> +	 * a page, so reject it before touching the entry array.
> +	 */
> +	if (blkno & (bucket->bu_blocks - 1))
> +		return ocfs2_error(sb,
> +				   "Invalid xattr bucket %llu: unaligned block number\n",
> +				   (unsigned long long)blkno);
> +
>   	if (region_size < sizeof(*xh))
>   		return ocfs2_error(sb,
>   				   "Invalid xattr bucket %llu: region size %zu is too small\n",

