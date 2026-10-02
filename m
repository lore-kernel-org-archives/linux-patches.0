Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA26E3E51CB
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 21:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790978138; cv=fail; b=H8dyN7IUA84PtjbylabNJy1qfiNS3l+VoCiHrrBlimSv5ARPiui0gvGutd393Of+Cqh5IzyX+1oFbR8OSd7cz53LStGJyLd2FHI04biTPFBd7IncglVRZggRfxSFrzuB9WeG3+BIc+K6BxVeBrbZ+D7hoflOgrSn2YP2Q8kTVHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790978138; c=relaxed/simple;
	bh=RkjuWrL+BSQtlbsyAG/Ez9XUWuusC6eu2FQoG+OJEAk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TX45cYy20ZMgf3RzFrRBhOkpoTHT3f98Q2XgRV9L97DyTqjBHwKEA7M277ZsOfigJu/HrjG3fulSXdVmOF44ePAj7Ese8I2y7in/AzW50okvKNKgS9pKx6X0zlBozhftD3qJb4aW4kX6f6egB1kJsPyn05tA4moF1TXOdQXDVLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lvsm8yqU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XgExEmiO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lvsm8yqU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XgExEmiO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ebdaq3156290;
	Fri, 2 Oct 2026 21:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LCP+JTR2lPF/XewRp4XuPSWEyNVeptKGNnGDebzANWw=; b=
	lvsm8yqUUegnOn8rSBjBXZZzqlNbfClzX+6F3tOgn2Pf0nt6KHDjbsLkoK6G60h+
	l8IC34mfU3Yj4RKI8tX5xmjMeydY0WV39GQeKMvrvyWB2Kw738/s8l57Yllzd5Bq
	LYBJKYxK0ushyrjtDg9MTmk+ycQ0YBUKVzn7hmbvgtXul9YsOHyGXTAbADRd8cWN
	nHjdFzLUU0QaN8b6nCPg+e40K+hF0eegZR8YCARBSvmaSi/fs0ujX7HSH0v1rMuI
	6/W6ekutnmU/jMUZ9qhhC0vOkChXsRJXRaPXfI8J3CZ270JoH7KbzTU/mWdVy160
	FFQnDpK/JnEBVoLARGtK4g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx6kscsqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:55:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LoPla035433;
	Fri, 2 Oct 2026 21:55:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012067.outbound.protection.outlook.com [52.101.48.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gu538q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:55:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4MpjfIH33/QJn3JyLD4WWxSMU+b9Yz0LGeZzDkdaps5rHwz7ekZpE/bdYnFKpZH39KHImnTReEHXb42twL08U5w36wTJSPL5+w/KdK/8NHTVTMZe+HPr5fJQwBUrUo5PTggSjSdS4ZkRU53hi1OsU8nAGrOjSqbJaTdZ+0cZzIBctDC0ivrebyJUoSNHwAS9aaXeovb+RPKtdgtdeXpX2Gp6XCELBfuXd3sWnIW7m3GwA2Fr2kzEYUELRxStZAZwmKNBQrp0s29AWXupoFUFR0bK8DKv0YoyL401s92M9W8FbdW5n2D16iD5R1LFM8dqz/N7vxIJUZOseDXMhZ6Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCP+JTR2lPF/XewRp4XuPSWEyNVeptKGNnGDebzANWw=;
 b=ZDGOyny6ls6r2zOU3J0mQJI9a7kBYzK41YDkGNcLZFlfe2O/13eQi291+wHeLNjovmmdTzxrSgWoNhoLaAaGbzQFxk3+xFJjroNO64gmxIT58gguEWLcHov8qOL9SYjBGqYHA4C6bABHF8CBwIX1Vjlm6BwQXIg50jCIg04cM5HAdaglaHoEQzkQCdvWy4vM6MXsz6KQdxCX3YMrnwTsDEinJNQFnVzqKS+MDb9ywx2M82gmQij9yxXENnzul2b+l8fNygbVHPPJLGF6JM1qOFTvhfGHL3zpUwsVcPOmtx5mOYbDckARqpvZfeImdPIxHfbPmR6M0JrwABSvs72JQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCP+JTR2lPF/XewRp4XuPSWEyNVeptKGNnGDebzANWw=;
 b=XgExEmiO5BSgxtG0XWw3E68nQKNuxdgkO+5oFZRfY3GnzIbbg9BksKwcomrkPOdpY7ssMVEfX/PFCoyA3U+nDRa8Cn/gJMMj0GpFB4xEI1Hzx/O9XsB3tpn/un+3gMwR97reYWB9jLQGtkUxpCcRoH3Auprr6J/hw8ctZQ0a05w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by MN2PR10MB4191.namprd10.prod.outlook.com (2603:10b6:208:1d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.13; Fri, 2 Oct
 2026 21:55:27 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:55:24 +0000
Message-ID: <e618db5b-53ed-45cf-babd-2b88227ca3c5@oracle.com>
Date: Sat, 3 Oct 2026 03:25:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 721/752] net: openvswitch: conntrack: avoid modifying
 shared unconfirmed ct entry
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Axel Mierczuk <axel.mierczuk@1password.com>,
        Ilya Maximets <i.maximets@ovn.org>, Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152413.824545792@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152413.824545792@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0411.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::10) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|MN2PR10MB4191:EE_
X-MS-Office365-Filtering-Correlation-Id: cd0a6a63-2a61-461c-0d3d-08df20cfdd02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|18002099003|22082099003|4143699003|56012099006|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info:
	QOwLY5QlvPBciPn9qwypDKY7mgMtpkz2wf+UnUrdOc8Ii0RL3lMzpz2EVsyLQQol2spxa+BGX2Ds8T7Sz4zibkNQ6wlf4uENOqv1s3MGqS5/JfP7oKd7RLH6rG7kY/qPLDeIQO0DyfU3NU/UbLndSUKWnUyvskz9pCFfRTrjeHASQ76Zt6xMa0xY71St7UJra9T9+rOwr+SjreTrxAr5R+c15UZejBZPhI4BJcPQAUWwhPTMCWIoZ7oFz+NtMPt4+l3GcIaP8lxVCZN4PABWc6AnQpCOn17DOg54ft/eq0B6fB1lM4jngHrfJtZyV6C0SFctziRHdgNIxPimNLXZ6h9QJTmzcA+QNeNSYhHXvLjODTsCPAtP8KN9uSG/vWkxdKtq2k5luSlUfKke4QbNjS+5sZH009vLZNE3mBOhOTgBK4eLE5pGJ7i8PpgFD5DPXLszupHu5OUGMwbvs8GjEF3GZjjDY0BL1G2r3PzoceaBzGOFFr3+JFRSnd84I4Px4llIY509RKKAalGA1CHcnRkUaZZnrr+b9Uzcs6mw2fWoEFWovBFxZZhVT37poK2yAJxsLlrKYI1xLBUp2SCoFn7+F4cldjdjmRUwhyQi354h1L53DsJcaT2TyLPsSnHK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(18002099003)(22082099003)(4143699003)(56012099006)(5023799004)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YitDRVRzazh1UFdGaTVod0dxZ1pvTi9WTjRLZHJKTUsxSkVqd1AraGMzRmpG?=
 =?utf-8?B?YWlRZUMvSGl6N3JQQXQ0Z2VLWGFwVDdhd0kyTHZXU0RPQVlFcFI3QzFhZzFE?=
 =?utf-8?B?a3VrYlRteEd3RHhQU1I4SmM4V2Z6dVRCcHlNMjRyNXhjeE1peXR1ZU9Ub1NF?=
 =?utf-8?B?MExSSDB4RjhEUTA2WCtvOVc5U2lVZzV0ZnVIaksvMy95K0diNzQxdEkrdVJr?=
 =?utf-8?B?MDNkUmRBOVJlMXJ1VFhmMk8xSklNU0VTbHUwd3BxZW1kMk9XdFM5K3o0eWt3?=
 =?utf-8?B?TUIybmpXL3VoWFhzb1JhRjVMUFk2WUJvTXc0QzJTZHdqdHEraFdXdnZHRGFB?=
 =?utf-8?B?Y0ZNeDJLem5GNmRxMlY1UFJDaHFIMllPVSsybjdBRjl2anFyOGFrd0Y1R1JR?=
 =?utf-8?B?QnJsaDdLVXZ1NElWQkNkZUFiV1M3L0pHTmh5a3Y2ZDc1RTVMYmZWeGxEUXo3?=
 =?utf-8?B?NnVmZ3h3RjFxY1k1WUNrblZDTWxBRFFpY3hETmwxMldnTGNEaFZpVStZR1li?=
 =?utf-8?B?T2QrM01SM1RsNzRXb1ZXTzF5dklhVDBZKzJGUHBTN0tsU090QlJ4QlcrYWhs?=
 =?utf-8?B?Q2M5c290SGNLL0VzRkxKc3FhdFdLaHU5NzZvWW9ZNXJoTG43QW9uM2RJelFn?=
 =?utf-8?B?YngzbjJLY1VnQmN6NWhUMDJJekxUZmpqc0ordmFhNThQL0JTWVh3aks1WVRp?=
 =?utf-8?B?ckpaU3piRVJKeWoyaThTbU5oSDlQOEdhMG1UT3d5Skg1TEtrVzlYaGtWS2FG?=
 =?utf-8?B?SWdaTFBmbytkZHhiN09OeE1YNU91R0N6L3dPSWNCYjJnU1dzUTZNMnh2Ujlj?=
 =?utf-8?B?bTRVOEwvYnZJajVUTjBob3V6RWc1djA2Y1VJMHY3MFNpWkpucTA5amlWc21r?=
 =?utf-8?B?YnR1Sld3U1U3SU1xLzdua0cwRmRwNGpGREc2eUhBUnRvRWw4T1V4clhiOVBr?=
 =?utf-8?B?RW1SdDVFdmJxTmJZVjJWVnYxMmRUS0JGUHNuRXN5SFpFZDVlSWNaaFN5RDcw?=
 =?utf-8?B?VlRTMjlGUHQ4ZDZEY2Znd0o3MmNMdEt0aFg0eHZLVlFDdWRZTVhyRnpYTU8v?=
 =?utf-8?B?OHZzdlRFVXd5c0NaK3BiZmhaZzdGd2ZXK0pYTDBUYUVmMWJRNzZacExlK1Ix?=
 =?utf-8?B?ZUhMaEZpOGZ4VGU1R0NUK1BXeFVUcy9hbzFCZnBjckhROTZkbDRTZmdmQ0FL?=
 =?utf-8?B?dGRZSUVjdDlpRlNITitWMGlOeVhaS3plVHpWQ0huT2REdFRRY1YwbTJyd3ZJ?=
 =?utf-8?B?aU14MktsaEFxcWZxQnlGYjRMdWtxVUZsMzFLRnhIcWdTWXNpemN0aERUME9M?=
 =?utf-8?B?VDNPU2owMWp6bC85SUZzd0FxbjA0TGNEeWpLSTl2QmJUd3FCaEdkL0dqTkNU?=
 =?utf-8?B?Lzd3SEgvN1FTSnJicG5OSHh4MHJqVGl6ZEdsajhuaDBxU3Q5dE1VUXA5M0d4?=
 =?utf-8?B?WkI3d0pta3Z4bWtGbnlBM1BVdktsNk1xTzZPNGdMMUg2RzBKZ0R4Rmg3bzd3?=
 =?utf-8?B?a1g5OHROUHJ6aUlmMVNyeWRzbmZwYVcwZHpjVnZvdFkxczBJTmNaNmE0eUMv?=
 =?utf-8?B?d1h6VkpPS1ZGNXdWbnFkL0pTcXdQU1pxbzJTV0RtcXNmRHY1WGRXanVOYVhy?=
 =?utf-8?B?VUcxN094ZmpVSW42T2ltSGllU0hDaUlOTmplQ3ZhNDR2L3N5OFcvbVBtbjdS?=
 =?utf-8?B?M2xSOHJCNUFQbko3QnF1dXBUL2Q4R01ITmZTeVVhbFI2bG5WVFhpVzdqUDdy?=
 =?utf-8?B?V1FtdlFhZEpJTHkzY1pLY0dnMmN4bkRBYlNsc1Y5RXhDcGYyMkY0S2Y1aUlF?=
 =?utf-8?B?NzZSQnAzYkZwbVdRVCtwVnp6akRwM3BGbENGSlpLQTJ5UXpmdmcxYWdmYzRB?=
 =?utf-8?B?djd1Y2gyNVBTZXJVNUNzVXFUOTZxM1VBenZHMlZtck1qZnlRb3dEdHJzY0dJ?=
 =?utf-8?B?ZE1uOXVIZkZCWFRieVFQbmIrRURmdTh2ZzFKK2pIT2F6T2xkR25pVUFmckJn?=
 =?utf-8?B?c0d4SW1wT0thQldzTW9mUi9RaC9odE5ENk90WTBOQ2MvTzRXT0UxZFpNRzFq?=
 =?utf-8?B?emQ4Wms0OTdiaTVtejZ6bE5EYUE0TzhZSkpaVlFWTkh1dW1VTW9YaUtPWHNB?=
 =?utf-8?B?ZmJvZUNwY3RGdGJ5NGtlTllFeVFCM0lWZVRVNGlhenhMVis0RVNuZjk5Qnk0?=
 =?utf-8?B?UzFLbkwvUyt1b3U3bUJGMDNmaXVTaE8xNWhCeUx6SkxYQXd4TDQxV2srS25X?=
 =?utf-8?B?WUJlQXM5VXNLb21mYkRLdTdFY25ZK1lIaVBOUXhuNTdVU2pMajR2eXFmakFV?=
 =?utf-8?B?N21ET3NCRFpQSDcwNVdleTdTQms1MjhFTU9vVmxldmpjd2VHRURCUGlWSGE1?=
 =?utf-8?Q?6PiS3gDx8F2BX2bldrAo8oKPnrF5Y3IijMS+d?=
X-Exchange-RoutingPolicyChecked:
	ExX2wkaumt60RpIr8tl8E2+lc+EvJe47PskSRev8ymQwprErSQ7KwxoMLd9Fs5K5PY0Y2qgWy8FM6bZmNOfj8ORFjzd/1ym2ahUGMnU4OVexg0N81/bWFV7DHa48cW38HDr5jAT9EFuXebqUzMc2fnFg0NemS21ePsYXLhKCwbNEfVGJED8KsP12NyG0RCdEhwIJOa1fcug1Wtveplnd7+J13JX8ImFm3ED79R0KdtmPLlLQrBKIw24AYtmq43VLZuryJZNMHi6NC241DfW5NNcfwDyse9qqgwxgqzDjiEQAPjGqmoUy7462stXk+Gj6wVqP670Jt693yB5mTd9KyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XCRGbzKOvii6B9XanKgdHgXTkG609ZWuFhNOJfKqaAgrB6A+T92TeS2xW64HW9hTWQTA0oBUrXgPQVUka7M2of1ZKxEGYyw0dRG/NFoD+MDJwL5cpr0JbjMrLqAIuUMaXa+21Q/Ius7JO0SHLg/onoA1U/QFhJvwrpvR6p08DtBp5npIw/3O7HqhVn5ACEkhwEgVJHdKgsoA5BjFj7HtixTWl+kdw1FEYi8a2cWC8JO7HI6pfA0oIZUegZJ5QI0PSMN+gqTUKW9zJUJC81w2lDBrsILdpnzWpwuNvugDy+AFDo6LvPzq7NSs+6aIsmLmtGsePAFP70HvEvkjG+r7/qQ/hDANQdOSbxHgQJ+0nqT+/xY0/92qc6Y6u4EJs9/KED7/Sa2k4PEeLArlT9OjmSljRuqfKrcpD33/YwZqXM+ktel3fEQszSGQ8OJXNFUIcGreaBDVV6wIZ2KHIE8zRHF8LFUQMciwqTzaddy3sKqWH3fHt1gw/Y5bolmu78ReuF+gihGggMlW2vD/3/2fljm+0KRvIhiytpF2/aqWAozRq3NaAEvZ5ieWymOgmtqhtusNNL35Xy41dj8155SMV/LPtgJAjYWN7mAuGWKisig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0a6a63-2a61-461c-0d3d-08df20cfdd02
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:55:24.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RerNvDTLTCI9gxB7e0NIl2KB8f9iMlBJFFOpxEv88R6T3ty9DiAaCPR1qLA3iELGw8RjwkuFZ6T58y74g30C2a8VW5bN27DKMiUpnj/Fn4KIWEb6uBocs10u9b7V2ibc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4191
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020087
X-Proofpoint-GUID: Nfg5zQzwjKOzWoaieKFl6-1hqTgfHBIz
X-Authority-Analysis: v=2.4 cv=U/gHnuru c=1 sm=1 tr=0 ts=6ac02853 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=P8mRVJMrAAAA:8 a=VwQbUJbxAAAA:8 a=hKNL0jXIAAAA:8 a=20KFwNOVAAAA:8
 a=ag1SF4gXAAAA:8 a=ez87B_vxZm68FqVDe2QA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=Vc1QvrjMcIoGonisw6Ob:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NyBTYWx0ZWRfX/ccw3sDfBoio
 LIciaAf+7u3KJqKzIxHJ8juWtSLF9lKnWs6AXgTtJ2jIycIl77QHGcU4DPFutbaYnGSkTYmnnFC
 3vHj9dk9sDRbnBg3061Ht6Quqx0ONNM5dqcV0pQJbpKUQr4cczIp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NyBTYWx0ZWRfX8YtB0Pf5ODUC
 a5gJ5FLmK8whXkXmiA+HKumEY6Qz1453njAo3QBys36d4O+ryaSCacPmENQeKEp4q06437EhbE+
 cO9fv0NcpnRJkuFgOTpwlON0Lgq+w0VUxAZNpxai6HsD4msQnnLctCKBOVFdSxMeSH356zCFyEF
 g06ep1RZ+/74vaNw8jHDILh1czSIo4+yw3m9HywcMi6yyazbIeifHkEVGtlz+eU6+S2b49WAazf
 peFn1lzKH9U7jN1twmLLasou37bqB6Lz0gAIDE3pAeWHkPeA4T4FeeLkzkeLuRu38gDqw3v8b3D
 ujrwvgtK/eCDNrU80rveRpmtfRjhtgAze+vot1ylGh8uTBLKKqZWmSc9rJLuaEOKD34nZVQMVBe
 EeM9O1bb51Qte2HjbgXSLSyUK1mXQcJr2IPT0V+ol2uAJ3iIZ/nmGZyuvXTKzjIxlIt+6l4au+h
 CVRoRQ0cO9qdA8XV9b45Z73uiMLhbSke5u2zhDWk=
X-Proofpoint-ORIG-GUID: Nfg5zQzwjKOzWoaieKFl6-1hqTgfHBIz

Hi Greg/Sasha,

On 30/09/26 8:59 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ilya Maximets <i.maximets@ovn.org>
> 
> commit 26b2bd70d22457556e2fa01cbf1192cb1a94d619 upstream.
> 
> In a case where skb with an unconfirmed ct entry gets cloned, we may
> end up committing both but with different sets of extensions.
> 
> The series of events:
> 
>   1. The first clone wants to commit and runs the helpers wiring up
>      the extension pointer into the expectation list.
>   2. Then it looses the confirmation keeping the entry unconfirmed.
>   3. Second clone now wants to commit labels and adds the new extension
>      for that breaking the pointer in the expectation list causing
>      UAF on the destruction path later.
> 
> While this is possible to trigger, there should be no practical
> network pipeline where committing both clones without modifications
> into the same zone is needed.  So, let's just reset the entry in case
> for some reason we got an skb with a shared one during commit.  This
> doesn't affect any known use cases, but avoids any potential problems
> with sharing and modification of the unconfirmed ct entry.
> 
> The fixes tag points to the introduction of helpers, since that's the
> main UAF trigger for the sharing.
> 
> Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
> Cc: stable@vger.kernel.org
> Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> Reviewed-by: Aaron Conole <aconole@redhat.com>
> Link: https://patch.msgid.link/20260921145655.3167436-2-i.maximets@ovn.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


An AI-assisted review flagged the shared-conntrack relookup change, and
I checked what the final 5.15.y helper-assignment path does with the
lookup result. The reset itself is exact, but its continuation lacks the
upstream confirmation guard.

Upstream helper-assignment continuation (26b2bd70d224,
net/openvswitch/conntrack.c:808):

     if (!nf_ct_is_confirmed(ct) && info->commit &&
         info->helper && !nfct_help(ct)) {
         int err = __nf_ct_try_assign_helper(ct, info->ct,
                             GFP_ATOMIC);
         if (err)

5.15.y helper-assignment continuation (d7aa8488b4a2,
net/openvswitch/conntrack.c:1040):

     if (info->commit && info->helper && !nfct_help(ct)) {
         int err = __nf_ct_try_assign_helper(ct, info->ct,
                             GFP_ATOMIC);
         if (err)
             return err;
         add_helper = true;

Relookup can return a confirmed connection published since the original
lookup. Without the guard, helper assignment can call nf_ct_ext_add() on
that connection, triggering a WARN and potentially reallocating
extensions still in use.

I think 5.15.y needs 3c1860543fccc1d0cfe3fd6b190e414a418fe60e
("openvswitch: add nf_ct_is_confirmed check before assigning the
helper") before the shared-object relookup fix, thoughts?

thanks,
harshit

> ---
>   include/net/netfilter/nf_conntrack.h |    5 +++++
>   net/openvswitch/conntrack.c          |   12 ++++++++++++
>   2 files changed, 17 insertions(+)
> 
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -192,6 +192,11 @@ static inline void nf_ct_put(struct nf_c
>   int nf_ct_l3proto_try_module_get(unsigned short l3proto);
>   void nf_ct_l3proto_module_put(unsigned short l3proto);
>   
> +static inline bool nf_ct_shared(const struct nf_conn *ct)
> +{
> +	return refcount_read(&ct->ct_general.use) > 1;
> +}
> +
>   /* load module; enable/disable conntrack in this namespace */
>   int nf_ct_netns_get(struct net *net, u8 nfproto);
>   void nf_ct_netns_put(struct net *net, u8 nfproto);
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -968,6 +968,18 @@ static int __ovs_ct_lookup(struct net *n
>   	enum ip_conntrack_info ctinfo;
>   	struct nf_conn *ct;
>   
> +	/* If the ct entry is not confirmed and shared with some other skb,
> +	 * e.g., a cloned one, we can't just modify it with the commit as we
> +	 * must not modify the extension set.  Reset.
> +	 */
> +	if (cached && info->commit) {
> +		ct = nf_ct_get(skb, &ctinfo);
> +		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
> +			nf_reset_ct(skb);
> +			cached = false;
> +		}
> +	}
> +
>   	if (!cached) {
>   		struct nf_hook_state state = {
>   			.hook = NF_INET_PRE_ROUTING,
> 
> 
> 

