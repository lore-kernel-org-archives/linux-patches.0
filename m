Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795209250;
	b=qSNp0d+bUDn5eSC4ZZVRda4suK0Y+NR31XcUlhb/cXQyGbAtr5NkFrzT5a42NEAULfhz
	 N/EaYqDBEf4PhoNwLoDbNwntxtbhDssrYnCKzBKaf3Th4Kue5QdyOT6Tnslf3KFGmr0hw
	 6QyTzLmNY/FcQvhxSDNdJKdjJgpyJ4l4g7LSmHNp4KlxxUGBx9y+9oeRXoII6OrdkEVx8
	 k+9ucxcNYipB9drWJkieAvfejZ65aiBPp2VcNl6YAQz6CdTNiNjlGNss9XyLra7sgzuyq
	 V8r90xinxAFyLd2OkYbndDVnAL+eSOkMTmNAgl+8tGdF3AiwoyjL/JTZtE5ftoDdmqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209250;
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
	bh=1R/m8aVe0nwqP97aCQAcIqw0BEKz4ppAwnljb5vKMHw=;
	b=FzemRZhs8sVrhu4kzaju9vcCB7PrbZtYdiuEDPr6MjBDikPPbritpvlV6PT7nrribcsN
	 tsyE1gOSTJMt7cXrRh2zwH/xnkUVCC0nenaBqd1BfuoTFxiVU7sGMyfTBqxlRFlqYKe3i
	 G3J+QL8PMflmpbjW9IE/6udT4RyO7oAfwCo7BraevG4onA7Dpsdhzrj4Xe+096gelWc8b
	 Dyb2VZbOAqAnz2DSrM8WXVNWnOYBynHIQmHgST4B38PnO4OqQ4qIJeoxlQZtXMZWcBRaw
	 uFjbFbX0JmkcL2uVkqKX7RAy6WczV2JnSqusRGp2IK7SERVPdPJomU4By2FPN0brVUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=iUKrAYJj;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b="riVBtF/n";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33193606A692;
	Fri, 20 Nov 2026 21:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33193606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=iUKrAYJj;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=riVBtF/n
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKGkhKg037337;
	Fri, 20 Nov 2026 21:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1R/m8aVe0nwqP97aCQAcIqw0BEKz4ppAwnljb5vKMHw=; b=
	iUKrAYJjzP4k8i/pyehFpAYplD6xuqcj/+0wBn4fHQFF8UYL3YKVi91Ivog/8wLJ
	Xfz+mtRN2F/MLZjvSc5j31RmH+xeBEfLVg6mVxS8ZNeWanGfPTP8SMWR/qdoNsjW
	HfTGklT72wHzPmH4VdUsuf9qd30Z3oFoiNTygPjMYbLkvhAGAOmCgQAOvrt0MgA4
	JQMM4FVMGvV+WylddiD12FAFY5jJOMSDGBbvxwpfs5bF1dXOXxK9mBlqdVlQ98TT
	TrM3M3NmQwky860lSoFG2DCrsU0BOuouTvvAjw9fI+IQY98pDVguVwbcGJSxykqT
	7OUO7LvLoza0dk3us72ODw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j0ytq5b63-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 21:13:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKIb0Yk450918;
	Fri, 20 Nov 2026 21:13:52 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013061.outbound.protection.outlook.com [40.93.196.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j2un1cvty-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 20 Nov 2026 21:13:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6YAkxnfYoDPAEk2NB7qvnRrT7x21qf0ox9UXCl0apNT6UpDH4fwV2NwX+bwSIJSrzpT7xvXP1f8cAs8EGE7XxeVRiZRvdn2zk/OQrCqw79WL7gIyyie7G+eBC6YpCSRNeG0l0sJK/B5NxgHIvA3HWC5tc/qBMk9cx6PeNkerxRttY/m+0AinDcq0rIJJsdv+RJuthileIYlk/tX6iZK9nBU1zxHGlL3E7bFdr8qWtANkyKET9vJc+0Vi4emwdIWs8Fr5e1xIVxmHmQ8IGQNJimFxaPWBWMrh8f1jSRSohM6OOBcqr9wDySLnCMrIdm21BhiXa75xQWo4AEN38TGMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1R/m8aVe0nwqP97aCQAcIqw0BEKz4ppAwnljb5vKMHw=;
 b=jQZLBVNO7b9JPLlgfIjERN5yZWCaN5A4uc0bwhyCDAjX0b2DOguycmE4r7biNvikCN+rT53m7KhLExV+4BfdZ16pGS3NDGHoulhRMmDnFxeofXhwbUAYWKbBVKycSK+akIYhe/e5qnAnmkITUfhof9SqSqfyJQmcwt5CANsvq7L9ASoSkeXdncCyHKg5uc735FNy56wgAAOGMVo625dlfBf/8GRnVH0YQC9GFfm9/8pNtAySH3EwlAJOGu97md9gjjJIBjVEFvQ5Q8b9+FwYvV77MH7J5Wc4CZcuQlG18wcqITZHa7k+EpGEXm9aCpGlZszSiCI7/yzbr2w63UNoig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1R/m8aVe0nwqP97aCQAcIqw0BEKz4ppAwnljb5vKMHw=;
 b=riVBtF/ncDmvjC+FXHu+RgACIuLpoHmgZuh/m9syu7vsxmBDR/Z8SqXTIgRZpPmS5AaZL/JnrY7RVHtxjhsrTT0by9G58cRVW4vpVZwLGZ4IxoNAVBzt2Qd/t5MX0dhDKhSKrqvtVq7DYCCvi6GtUlUUChjTgLZyv8Rx4bzYBmI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV1PR10MB589353.namprd10.prod.outlook.com (2603:10b6:408:501::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 21:13:46 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Fri, 20 Nov 2026
 21:13:46 +0000
Message-ID: <ad2d0077-bfb7-4c43-8266-673b3bc92117@oracle.com>
Date: Sat, 21 Nov 2026 02:43:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0043/2214] drm/amd/pm: Validate Vega hwmgr PowerPlay
 table bounds
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Yang Wang <kevinyang.wang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150011.779944906@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150011.779944906@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV1PR10MB589353:EE_
X-MS-Office365-Filtering-Correlation-Id: f18b62f8-8d16-446b-89d5-08df474b2a05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|261102123227099003|261026140227099003|4143699003|5023799004|261022113327099003|261022105027099003|261021130227099003|261021121427099003|261021135927099003|261009223027099003|261026135527099003|261022075727099003|261021133027099003|261021123027099003|56012099006|261026121527099003|261026130827099003|261028144727099003|261022115727099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	MGZ2eFViZcb+HlBqHXQORB4/+V6UfTHFMUzSclorP8lXOI9a+WiTa0NLNpsQnfbM7ERI2B0muok7EC+Eep00VHPWZBNpBNnJ7XIPGwGxWkpDpvwQa1mTu+uSWz7PgbK+YiG1j9nFGXyfz5rWPb8tkhkd+/vKHZzDU1PZ3TbkRTmwR1eM/b/uBP3LX864Y2XWk3b476FXOgdCmDjqAD4TGA0wa8XMSi2Wj/OSdKgItz+U8L7uUZB2n33amNicbP2K8O3kxXms4ZUX2Co0zn3uzppVw8RejX4YYa//IR4EceZjsFUsdjgh6J7cyC0QNbMeTzdcYWNazgXhsVzFJ+PetH0Ug4+iUKrTi9yvi4qMvUpeplHnDRUj/1hxnZPOlslU9eDGwLqodedEXAnsDDMTox4cVwdWT/sHxz44e96NYDvRNLabsGDtyHSs3HmMdaDSZGQvsU8O6u8Mm+sxXzngKMRN3y6IoFucoGM7yECEkuTQxtLaFK24ZsgLqJofHJYKVDMqMRqMVfHoNjk3ip6/7SOEa1Hbdd2gDRHhsx9cQ7Se69WTKKA8KWTI0Nqt/KxwwkXzsg5hzFbcc+HqXBb8lBJgBgV4Rok8ZcKF2EnvsDgdwzymJqZltijgeCtu8h6yIt7MfFk4LXjVhxLPaHIoquKnu75acwsWqj02x+nyhwo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(261102123227099003)(261026140227099003)(4143699003)(5023799004)(261022113327099003)(261022105027099003)(261021130227099003)(261021121427099003)(261021135927099003)(261009223027099003)(261026135527099003)(261022075727099003)(261021133027099003)(261021123027099003)(56012099006)(261026121527099003)(261026130827099003)(261028144727099003)(261022115727099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nm8xaFMrYTg5QVdDRnc5eVV4eVVxZm1aazVDOEFZUnRpY3lNcFZ3NmhuR0NU?=
 =?utf-8?B?N0U4cFdJQy9lbGY1ZWVqY050M2xXNWxKajJiM1B3bmttaENpWUNXMTkxak9j?=
 =?utf-8?B?cGNCRlJJOTcwTDhuOVpkNWhXQ20yK2ZHZnRXZGpUVXhnclR3R1RtcEdrS2tm?=
 =?utf-8?B?dElsMWp5dUdjUzViV2JmdzI1RVNYZi9YNEZVcURGSUZKeDlZQmZBdVRXTnlY?=
 =?utf-8?B?VWVmcVJ0R0VJZndaMnEzdFE4WW1PSHIvMmRoUUM3NTF1aFlKY3Q4ODBySmVz?=
 =?utf-8?B?Y2plMjVEbXFjSWNGeWxnd3lnUklyVUJHRnFGaUdxYnI1WFpRdzRrZXEyd09C?=
 =?utf-8?B?WXRvbXlQVklnalNFSzBlQy9ld3FTZVdpMlRLZHBCdUYrNDY1RTJYbW5PMnFv?=
 =?utf-8?B?N2tNVG9SYWVMNnpMM20xRlBvakcrQWFEWUtWc09kL3puUFg1ZWRjKzNZbEVv?=
 =?utf-8?B?NW9XREFUOGR1RjRjbEhWWStiYTBpWC80VFg5Y1plSkhBbVRrSjZKUVh0WTY5?=
 =?utf-8?B?WEVtVUJSYWhyc1ZleTY5Z1pEMnZGUWwxM0Jwd3lDenA3ZDB1UnZ2aStlMFJY?=
 =?utf-8?B?SVV3c1VKSlZsL1dVc0R4b2IxcHhkZ0FINTlXYkRUaXFXakgxWnV4ZVM1bGhT?=
 =?utf-8?B?RzlXSXVjK2RiaDFLTWthamQxMGRJL1A3cVNQQlJjVHpOV2YyS1I1VW0yMndB?=
 =?utf-8?B?azVaTG9DdXBvejdhdEs4ZFJkaHY2dy9WdE5lcjFGRmNCdlc3V3lKeW4rSnlW?=
 =?utf-8?B?RFREajREVU5YdEF0RjV4a08xTFl6YW50ejVwQmJyUEVZblF3eEp5SkM2ai9u?=
 =?utf-8?B?aW9jTENqWEhqR3R6bXFTeVp3Z21TN1UwVjUwa1NSNkhiOVZJVndZNklqa1FZ?=
 =?utf-8?B?REVQbGtxNnBldlplaWxEbjZQQk4xbEN3T1ZTWDUxS1hPZEhsTkE5aEtGTURU?=
 =?utf-8?B?eWFPa1R5eTJIelVCOVdWWUdrbHNKYjc1TDk5eWx2b21IeFdTVVVRQUpjbldG?=
 =?utf-8?B?aU43Sms0Z1YvcDAwb2l5RUdkSGNaUGtuOFVKOWI2MVMzL25xQyt6YXo5anhV?=
 =?utf-8?B?Q3lWUmFtQTNWNUlUT3ZUNi9zWGZKSk1sTXBwYTNrNXA3MEZ3VERuUEtWVi9D?=
 =?utf-8?B?NXdmUVFkVW9sMmVUc0F0WUlZMk9FKzNzL0thOVBnNy91ZnFjdWN0cW15RXhu?=
 =?utf-8?B?Qmt6dWdZZFQzK3prS3Mvbys5NEdVQVJVMytvZ1dPcEFGOHgwdUhYdjZYWHdC?=
 =?utf-8?B?NGhFQnJoS0I5aXBBdXpGeFBYRGFSejdERjRQZytXUWdmelNCd2lQOTNyQU84?=
 =?utf-8?B?dkZlT0pXQWthOS9RZ1FZL3YxVUU2MjFvVDhhclZ6cXBTYXJnNitSK2RPR0RE?=
 =?utf-8?B?TlpjcEM2K1kvMXdjaDRyWUs2SEQ4YUEvazYwZGdJTXAra21taWR3VnU2OGYx?=
 =?utf-8?B?OWFqWlhBWXY2TmZJL1dtMFltcnJ2NGZGVkhTRTJjM3RrRmpFeEQwQzE3VjdO?=
 =?utf-8?B?SnF2M2tuSkNKK2wvMWhsUlBWcXhxdEs2emlKUVozcUZ3SnM2aldtZHJnRXo5?=
 =?utf-8?B?dWxjWjBCajRwSkNtMytsV1UxZ08wQjB1R3NlWUV4Umt4c0lRcnYzR1kxdDlq?=
 =?utf-8?B?bTRtclF6dlRBd21lTElSalNadXJPNFNmRlpSV2gzOTR3NG1meDdNalN2WHZY?=
 =?utf-8?B?eXRDQXlQV0VEZ3FuR0lpUW9FOHZWdWhtSS84RFRVRG1vZnFWZmRTMTVDOXpU?=
 =?utf-8?B?OUk3MGZ2S1UwVHNzcTk4NlM1anVtWG5jZG9nUi9Wa0gwbWlKd3gvbG9WUjRo?=
 =?utf-8?B?S3JFbkNYMUlFZ0VDY0RhMCtpeHh0OXFtTDRMMFRENUhIMWQ2NHI5N1Q0azdl?=
 =?utf-8?B?QzFtSzZ1YnFTK0tWZ3NGd05BYmNaNU9zRUh6RUQ0YzNkVlBGKzF4dU9YNk5z?=
 =?utf-8?B?ZUxEenVmM3l4aDhsaCtTV3M0bytZRW9hS1p2SEZvY0trQ3VZU1RKZm5NVmZt?=
 =?utf-8?B?S0U2M2d6ckJIYW1MaWZMaS9uUzdTVlZpQWhiVElIMURGU0xWRm52RWwzYXhK?=
 =?utf-8?B?bTNqbk5uck9zb1N0emFEdnM4bGduU1o2b0I3aUE3VTBMUlB3SnFMSHhpdkx5?=
 =?utf-8?B?ZFJvWkJ1NzZXUXdyanNIYnQwN3gvVmVaSWtiSmY4MDRWSVU0Wi8rKytGUjVG?=
 =?utf-8?B?UjNHRVZjK2tPaTJPVVBJQmZ6Sm15WnljUTJxY2ZOYmRtQ2YzQm52RHVmRThC?=
 =?utf-8?B?Z3ZPZmdxT0Job1k1VlB0anZYZ2FReDZvRnhhcXlLZ0ZDM2NDWHhkbUFIdVBH?=
 =?utf-8?B?azlrc0xVU1dHM0V6SDFyK3NOeHhOMUFVUy9mSklmditid1JJUVFsb2l3cVRs?=
 =?utf-8?Q?oJrvF+w2z42ySH6ZQbJPPIHcJZ6NWB2iY15e0?=
X-Exchange-RoutingPolicyChecked:
	A4EFxlfE0YIjfGMCdRHaa7qbsAjfj3GxYUUtZsBMIZBX7gFqg58Enkb1sy8vefxbPE90rVT481BxyLi4PzUxQAcWeYngPVK5ZQNEjL7j6sthvzOqZA9Vmt9HOwmwCLCFf3xvvzNpT2cEErLk/DW9uxEu5/tpQjZSxo8mXYEjAW4fHGhHcuJASLz9ZzDMgwbG3VA1IpoENc1/N2spptXZ8dNYXvndscRqralzR+SIsD3vzrPpVITM1pJgtDWogW0WYqQT8ImjiFHwbYMp6yDhlabxWJv30yTIrlNh/u2QQNJOq7HBWYp8Xq6JU1z3wChU2bdMIkr1jgJ8Wl8AqX1RPQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ugxIuyke5+tqEja0+Ug1aWhdDMgJAYGqA06RBJZnE/1gbGITF70eUFCCJ8tDeAleG1zfDBkyMzA4D3CUyIRUCbFm4uH4CavZzfiN/ZFoAv5/y3g5Nw/jL6Wd81HcT8n6+w7oL6ByXRDCdfiLGPADjsRkbB97Z9iCbbrnYfJgacaDa29szKF3VIdrtPG1Icd3U4F4M9aOm4dj2pSSbxbdJ+k3Acn96JQ6y3BkrNCcgIVRkwYRXGV76jg9NKeMKzKgbi+pJa0l+AqOTAUbnq3JiKvalM13YzbwpXqW/m1sm5Jdq0MUdAGoI8tMoBD89yiH9hDa64oIdLxjiONnkoWo0eZSFPNWgPP/J+4CsbhWEtXn+8yUZ6NEq3gE+ZrJuc7Wjzmkpm1qxDk7KWHM0Ph3CUNILoCT0Vsk2nt40td4aFu/8IkiDWK8HllgITBaWedtZZ4UYJFEvBybV5b78urnFQDJpdy8bxMir2e9hlspqedkYYhi24kp0/IavOzohEc0ncv4G9sG3d8Qb9s0p3Q4fqHiRaXLIx9daBlpGLPM3kYVg9TJ8grfzNinsb/tXyh8FwMb8jp1bPlMJqSDXsuJzjks2p3eONAAqNfhWIgmr+c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18b62f8-8d16-446b-89d5-08df474b2a05
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 21:13:46.3971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X2UQTl9h4EEJFq60LJVadrRRrIve9suemahQMV/aSQdr2wTJbyf9UoZ2veGHzjviMvwVwPLhQmhCNM+SHk+EG1TDc2uAmoml/+drMU3jroPNnPArg87QCyT5g/Mzp2xn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR10MB589353
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200084
X-Proofpoint-ORIG-GUID: 0cE6o-mjZP5h9nr5bUTJpjIhFxi8qbNg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA4NCBTYWx0ZWRfX9pOGh4oWTN+i
 fM6dJIXIkUQjpcgScB5GAuS8L7/8ecwVtq/OSsae25m9l3qi5LyKIs8fNp79GkbZLI0tKpvgkGG
 LWYDOL9fvjz4ObdJIoJYioFfIJGlK1Ba1HS8k86PWGtBoAShZHNU
X-Proofpoint-GUID: 0cE6o-mjZP5h9nr5bUTJpjIhFxi8qbNg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA4NCBTYWx0ZWRfX9LH6x612BdaF
 SIwysrmw/pChKRzc6BY2rHXLnkROBw/FL8Kt7caJNg8Oh7H9Makx2rf7V1yT2BLD1AiJR0afOwC
 jlSrKVVCRREFDhtBgm4dDA5Xyf/PEikGeO+Y3D98nq90t8vYYUlaZqFBB3YPQ5A1TVGRZJFbElM
 fnrA2UaBg79D4jYwnvhoGMXwqN0LxkXVSel6w0mkJcpaRME/DKCrz+hACNFI1QdXHYuAprvCQ2L
 mpQl0jW80t+5E+0Jp+UeE3uBPQ2c0fhsHAB/VS0LFmTDW+cyBlhG/YIw8bazakHrcYYBnZbpf5z
 88Ws7rreEr+SSm7Qny7qD3CDEGSyCVXWd2jomgnRjkSR797XQ61fZSeQUlaIh0O4oRE3cofAJzR
 wbVYTXB8F5JgvqGvWmaHcc9HC98qyKvQVUo8KZWqlwKTV3qWjyrWjd/Lpv+xoqZWW6MPICu/VOO
 rnzM15QmRwn+DeK3K58+xQfrFcoaGYm78O0ouCm8=
X-Authority-Analysis: v=2.4 cv=I+vw19gg c=1 sm=1 tr=0 ts=6b00b810 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=zd2uoN0lAAAA:8
 a=VwQbUJbxAAAA:8 a=y3HbpNODRrDt3eqRP8cA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100

Hi Greg/Sasha,

On 18/11/26 7:58 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yang Wang <kevinyang.wang@amd.com>
> 
> [ Upstream commit 3a8d8e0b7f61cd759d5d4870b6220161f8a5b114 ]
> 
> The Vega hwmgr PowerPlay table parsers read fixed table fields,
> state array entries, or SMC PPT fields before validating that the
> VBIOS table buffer covers those structures. A truncated table can
> therefore lead to out-of-bounds reads during hwmgr initialization.
> 
> Reject tables smaller than the fixed PowerPlay table. For Vega10, also
> validate the state array offset and entry range before dereferencing
> the state array.
> 
> Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
> Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../powerplay/hwmgr/vega10_processpptables.c  | 59 ++++++++++++-------
>   .../powerplay/hwmgr/vega12_processpptables.c  |  7 +++
>   .../powerplay/hwmgr/vega20_processpptables.c  |  7 +++
>   3 files changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
> index 95b988823f50f..bc75f09112cda 100644
> --- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
> +++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
> @@ -64,14 +64,17 @@ static const void *get_powerplay_table(struct pp_hwmgr *hwmgr)
>   	return table_address;
>   }
>   
> -static int check_powerplay_tables(
> -		struct pp_hwmgr *hwmgr,
> -		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
> +static int get_vega10_state_array(struct pp_hwmgr *hwmgr,
> +	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
> +	const ATOM_Vega10_State_Array **state_array)
>   {
>   	const ATOM_Vega10_State_Array *state_arrays;
> +	u16 state_array_offset;
> +	size_t state_array_size;
> +	size_t table_size = hwmgr->soft_pp_table_size;
>   
> -	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)powerplay_table) +
> -		le16_to_cpu(powerplay_table->usStateArrayOffset));
> +	PP_ASSERT_WITH_CODE((table_size >= sizeof(*powerplay_table)),
> +			    "Invalid PowerPlay Table!", return -1);
>   
>   	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
>   			ATOM_Vega10_TABLE_REVISION_VEGA10),
> @@ -80,12 +83,34 @@ static int check_powerplay_tables(
>   		"State table is not set!", return -1);
>   	PP_ASSERT_WITH_CODE(powerplay_table->sHeader.structuresize > 0,
>   		"Invalid PowerPlay Table!", return -1);
> +
> +	state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
> +	PP_ASSERT_WITH_CODE((state_array_offset <=
> +			     table_size - sizeof(*state_arrays)),
> +			    "Invalid PowerPlay Table!", return -1);
> +
> +	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)powerplay_table) +
> +		state_array_offset);
>   	PP_ASSERT_WITH_CODE(state_arrays->ucNumEntries > 0,
>   		"Invalid PowerPlay Table!", return -1);
>   
> +	state_array_size = struct_size(state_arrays, states, state_arrays->ucNumEntries);
> +	PP_ASSERT_WITH_CODE((state_array_size <= table_size - state_array_offset),
> +			    "Invalid PowerPlay Table!", return -1);
> +
> +	*state_array = state_arrays;


I ran an AI-assisted backport review and checked the finding against the 
code. It looks valid to me.

The new PowerPlay size check can reject a complete table because it
counts one state twice.

In vega10_processpptables.c, get_vega10_state_array() now checks:

     state_array_size = struct_size(state_arrays, states,
         state_arrays->ucNumEntries);
     PP_ASSERT_WITH_CODE((state_array_size <= table_size -
         state_array_offset),
                 "Invalid PowerPlay Table!", return -1);

But ATOM_Vega10_State_Array in vega10_pptable.h still includes one
state in its fixed size.

5.15:

     ATOM_Vega10_State states[1]; /* ... */

Upstream (3a8d8e0b7f61):

     ATOM_Vega10_State states[]; /* ... */

With states[1], struct_size() adds the requested entries on top of
that first state. The result is 14 bytes too large.

Let us drop this ?

thanks,
Harshit


> +
>   	return 0;
>   }
>   
> +static int check_powerplay_tables(struct pp_hwmgr *hwmgr,
> +	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
> +{
> +	const ATOM_Vega10_State_Array *state_arrays;
> +
> +	return get_vega10_state_array(hwmgr, powerplay_table, &state_arrays);
> +}
> +
>   static int set_platform_caps(struct pp_hwmgr *hwmgr, uint32_t powerplay_caps)
>   {
>   	set_hw_cap(
> @@ -1250,15 +1275,14 @@ int vega10_get_number_of_powerplay_table_entries(struct pp_hwmgr *hwmgr)
>   {
>   	const ATOM_Vega10_State_Array *state_arrays;
>   	const ATOM_Vega10_POWERPLAYTABLE *pp_table = get_powerplay_table(hwmgr);
> +	int result;
>   
>   	PP_ASSERT_WITH_CODE((pp_table != NULL),
>   			"Missing PowerPlay Table!", return -1);
> -	PP_ASSERT_WITH_CODE((pp_table->sHeader.format_revision >=
> -			ATOM_Vega10_TABLE_REVISION_VEGA10),
> -			"Incorrect PowerPlay table revision!", return -1);
>   
> -	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)pp_table) +
> -			le16_to_cpu(pp_table->usStateArrayOffset));
> +	result = get_vega10_state_array(hwmgr, pp_table, &state_arrays);
> +	PP_ASSERT_WITH_CODE((result == 0),
> +			    "Invalid PowerPlay Table State Array.", return result);
>   
>   	return (uint32_t)(state_arrays->ucNumEntries);
>   }
> @@ -1309,17 +1333,11 @@ int vega10_get_powerplay_table_entry(struct pp_hwmgr *hwmgr,
>   
>   	if (pp_table->sHeader.format_revision >=
>   			ATOM_Vega10_TABLE_REVISION_VEGA10) {
> -		state_arrays = (ATOM_Vega10_State_Array *)
> -				(((unsigned long)pp_table) +
> -				le16_to_cpu(pp_table->usStateArrayOffset));
> -
> -		PP_ASSERT_WITH_CODE(pp_table->usStateArrayOffset > 0,
> -				"Invalid PowerPlay Table State Array Offset.",
> -				return -1);
> -		PP_ASSERT_WITH_CODE(state_arrays->ucNumEntries > 0,
> +		result = get_vega10_state_array(hwmgr, pp_table, &state_arrays);
> +		PP_ASSERT_WITH_CODE((result == 0),
>   				"Invalid PowerPlay Table State Array.",
> -				return -1);
> -		PP_ASSERT_WITH_CODE((entry_index <= state_arrays->ucNumEntries),
> +				return result);
> +		PP_ASSERT_WITH_CODE((entry_index < state_arrays->ucNumEntries),
>   				"Invalid PowerPlay Table State Array Entry.",
>   				return -1);
>   
> @@ -1361,4 +1379,3 @@ int vega10_baco_set_cap(struct pp_hwmgr *hwmgr)
>   			PHM_PlatformCaps_BACO);
>   	return result;
>   }
> -
> diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
> index 1e79baab753ef..70a38bdaa43fb 100644
> --- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
> +++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
> @@ -65,6 +65,13 @@ static int check_powerplay_tables(
>   		struct pp_hwmgr *hwmgr,
>   		const ATOM_Vega12_POWERPLAYTABLE *powerplay_table)
>   {
> +	size_t smc_pptable_size =
> +		offsetofend(ATOM_Vega12_POWERPLAYTABLE, smcPPTable);
> +	size_t table_size = hwmgr->soft_pp_table_size;
> +
> +	PP_ASSERT_WITH_CODE((table_size >= smc_pptable_size),
> +			    "Invalid PowerPlay Table!", return -1);
> +
>   	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
>   		ATOM_VEGA12_TABLE_REVISION_VEGA12),
>   		"Unsupported PPTable format!", return -1);
> diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
> index 1f90825394575..20af10dda2e81 100644
> --- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
> +++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
> @@ -639,6 +639,13 @@ static int check_powerplay_tables(
>   		struct pp_hwmgr *hwmgr,
>   		const ATOM_Vega20_POWERPLAYTABLE *powerplay_table)
>   {
> +	size_t smc_pptable_size =
> +		offsetofend(ATOM_Vega20_POWERPLAYTABLE, smcPPTable);
> +	size_t table_size = hwmgr->soft_pp_table_size;
> +
> +	PP_ASSERT_WITH_CODE((table_size >= smc_pptable_size),
> +			    "Invalid PowerPlay Table!", return -1);
> +
>   	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
>   		ATOM_VEGA20_TABLE_REVISION_VEGA20),
>   		"Unsupported PPTable format!", return -1);

