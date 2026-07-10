Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858AF41B362;
	Fri, 10 Jul 2026 11:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682944; cv=fail; b=NJV1ZOKrLkeZBoKa7jTp2Rwrfykii1KsLDu0b6aMvC1cjka7zfAwie6pmxDfJ1Xy+YGJsLTcnq4Gu3PedIO07KrSOr2cLoMB3N88hW64XDQF8bfCUCMB/WpyKufwQEKSQ7Zw2Jo/tcfGzAQuo1XUSTz0Rptcqp1mHHc0tlRr8y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682944; c=relaxed/simple;
	bh=xgEJR+h4SvOPzMaWEDpbkubWLJueB2zYElRrA3IJVeg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t7aAW8e2F9DwV4EyyiTdycHz9SxONZx7tIhBaJRFDGVAkZ3PtBjXkslygDcXfG2GcVOIxfuq0FPEtoruFi4lzAz/ku5cDRtwXQvJs4MiQdpev/dwNVnwwuaZIo2VSOPisub4QFE4JxhYUSmp2wKdLcB7ygr0sT7vYmzC1SH9toE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FeULkwPJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gole469v; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FeULkwPJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gole469v"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66A61Wje1585813;
	Fri, 10 Jul 2026 11:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n6TztLjnFlxaDFOwGUtqwDTBTjDsbc8WJw6tjinOZqM=; b=
	FeULkwPJp2GGYsNVPaRbz2K776CJuFm0QeIYvfNAFWmqzGCy6+0VSfcVdPI07GLi
	bWreqLfk7+RSsOLVWAjvc4xcSTJZ9HIrLz0kA5ayFEoblDKfFaVHoEm9Bicf0ZkY
	eb6QBS5KJ/Uhr0zgCLJ5F2Q5PDaCLVZgVvoGFt53knS9XcpO19qNj1EfaktOwcGz
	IpWmRIiZtecJxNT5vZpBlP4ztWlWMO5enICLG6M43fCxkrGVFIz3B6DuOx7ZyorF
	iETX1xoGEP4Ug16j6jQ/4EQq9sJ6M6Upc6qWk0voqfTSSS2BYvFJ0LHd5u2a72UV
	y8Me5XUbFvB+3HccxmbMhQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6tqsb0h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jul 2026 11:28:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66ABNI58016807;
	Fri, 10 Jul 2026 11:28:51 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f8wv1sefr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jul 2026 11:28:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8tV4DishLV3YH2jvboWIGxA5l/41N5oowOnD7ii0/lTWTG+pBtchBlguah9pNC0Ksbg8dOSte/p6mKqSrU5mY314mqjPNcgiDWLEvgtDOeG89Gob6b5HqPqL+1D0aZyfhzDGI6Zywd8QTNQyCTy3JG6THoCeubI9MpZ3mt7ba/DutoH5rgSKSd+yMeg1Fw5LkVTs4gnOaYisWfSiqBsOYhQWDM8YbwXrcOAm9fT/Mkxu0G3DBPs7d1UV/QVd9MbDpRn3M1v4WvCQid20OdV/tk5CP1EhK1iEZLmbK8JTeAG99QGb1vTVhJ905W1CSpBuXfB2jrHS+DQ+v4n0lwkIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6TztLjnFlxaDFOwGUtqwDTBTjDsbc8WJw6tjinOZqM=;
 b=zVWdkHhpEaMmXfdrVWRLcn3FitF9aoBv2gg6AQU6KkiP4+qpVQbvoTMvI1jrujWkVAsJEIMAZc82LTmstiIcdVtKRZNzC2iWxNLHKI76jKuE3jXxuyBD+8tQIhBBgDyKQgDXPN0niW5dhzx1DPkoKgOaIeZP7M+FpAa6dqlcYjNwCw5O6QQ26PzZLSWOJ8lXsXO2SKYwO8es7Mo/gxD2UaK2/8JVvkgt66s93t6dL8aulxO5OBzwnK+cH+MFaId27EkzUDmxCReEeZHjY1hPvkYm3zUNmGpGSwHTSbbl7/RkvqOIoOHLNKkrDUneXuJDHzPMVeZ2pjvynsIFcSDSeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6TztLjnFlxaDFOwGUtqwDTBTjDsbc8WJw6tjinOZqM=;
 b=gole469vM5lFpAUKpsdp+jBynLOF/g2Qora9fphaaxENCLwQ3P1xJAwZ8l2P9GD88cSyZxlOerxeHeHZxYPDeFtgcQPZISKQcFuD0KyLjN33mr3Zo5v1xSvhFFhYYknlmrab725KjP9/MV3iSWgT/65YlHujb7dLXsOrnK2UCUo=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MW5PR10MB5876.namprd10.prod.outlook.com (2603:10b6:303:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Fri, 10 Jul
 2026 11:28:48 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0159.018; Fri, 10 Jul 2026
 11:28:48 +0000
Message-ID: <17cce379-76ca-49fd-91e7-1a486de62d2a@oracle.com>
Date: Fri, 10 Jul 2026 16:58:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 187/204] nfsd: check get_user() return when reading
 princhashlen
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        =?UTF-8?Q?Dominik_Wo=C5=BAniak?=
 <stalion@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
References: <20260702155118.667618796@linuxfoundation.org>
 <20260702155122.580017616@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260702155122.580017616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0649.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MW5PR10MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 135dd650-ccb4-4788-1ad0-08dede7668ab
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|56012099006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
 6I0PIxiwAaVZeZcbcUTnkdEwV5NHPMB57nPoMb8Tzc9hVkilhYM4oakmFEH4HJ3pfQd5QGGMgdknbNynR13laFW/Es2ISaYD4/huZDn0kdy93dRgp0qFDR81L61+zzIjdjIdWiXn9EuBtpOPVXKU5q9imQ/IwdiGoDCZtYqtCYdcluKXsMpUvNPsYbUUQaK+hdKX+zFLNitP51R9DUz7ww+T4Z5Y0PiJejGsCvHMBHrSZqWMlteODiuhPBzFGJ5C2zp+UVKvl1DGh4UfaoHJEI7BgqoB8z5RNGYKgh/tniWDCHPGN1Xg7Z8It2GbOhda5JRXrHu4lFM6xRmAUL08Jd1bvQtyz6CvTXHfp/kWk8gkmFbdZSQjoj/mMOCJiwl5FyYT2hgNGHNJ33GX6UMXO8XLB2D3pNhnUAGJvcEOXwZMeACRpPgU4E/+duVrNiQDKcH0hCFEJ2l2mWmL+FEdr1yaKmUVDy3DuDrX5hadNof3htvkluqQ+3GVeWmfBa5hgO1MO6/g3cgOmTG/OoVG3k26dVIB7SgXTAw7KpztLh4bJ32+1FxfRCYsAwJVvfoehAk/x6c7RQ5oWFmRMFgQTozYwEMdVDMWTmLvV+D/Ji1n7oGqHmUOGmZbnA0EB/t/J9ea947LfBbdqByq27KAGL4ClECZj/OmSqDLOfCQ7UA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SXFTWEF3djh4VWNKYjl5cXhMaVZoSUh0TGg2SEFqSGVFTzlsMnNjNGNzSDRn?=
 =?utf-8?B?ODdMeTdIdzhzZmRZU2hKODk5V1BNQnRGOXJaUlJaaWZKNkVKV3dOTnB4Y3Bn?=
 =?utf-8?B?TVBQRUM2T2hhZ0tPMzVoMUZ3OW1MU2dPL0ZGUVl0ZVd4bk9aNXcyalRzZjhC?=
 =?utf-8?B?YXQ2ek0zd1NJTktEdG1NeTRVZXRTdEs4K09yRkVyVTAxVzQrbUJlamJFNEJl?=
 =?utf-8?B?K0VQOTNwUU9SME9YRHJOOUMwVmx5TFd2Y0l2aEZLSHBXSll1V0ZrM29RVC9n?=
 =?utf-8?B?MXFsci9nMjRKTW1pOWx5ZFU1aE0rSXk5MHBsK0JmNUxxY2NpMUVFQm8ydXJX?=
 =?utf-8?B?ZEVHQnh0YmNmdkVFL24vS1hsZXM2bytmd28zVjYvRVN0UTN4R01WWXd2Wlhu?=
 =?utf-8?B?ZTBRaWZLaFhNRzhNZmtYbGlKN3dWNFlFUmYyTUlVWkp2UVFIMzU3bjRHRUkz?=
 =?utf-8?B?ekYvY1ZrMjgwQ2xzYTZOeit4QWcvQ3hLYzJPKzh3UFVUMkNUa0M4a0M2VkM1?=
 =?utf-8?B?OE9zTSs3VkRodDZvelpnaDhKL2x5bTQ5M2VjamlGaHYzbkQ0S2pLdEN6WDJl?=
 =?utf-8?B?UDZ6Z0t0U28xQUlBb0V6UFlUZ1ZTQ0pKRUNONlJGbjVxMWtWQXRGTmJneHdW?=
 =?utf-8?B?VFZacjI3aTJoQlV5dlp1VzdSUThkTVg1R0N6TEpRdk5rNFRxdnlUeXgxUk5P?=
 =?utf-8?B?Qk1aTDZ1QUozOXk4S3BZcnkxNzc5V3BhOFB5NUxQRmRWUVhyaW1QS3NYYTZk?=
 =?utf-8?B?dzZpdFpzVVhORHRkZnB0aE1EOVlLWUUvRXBTU3cxVUJ4eHVwVDk4elRQUVFI?=
 =?utf-8?B?Z3pBcnhham43WDg5LzlvUW1kWHJTTlZZS1g5NkZHaCtQTXV0RGZUcTBtSHp6?=
 =?utf-8?B?bk5UQ3B5d2Z6bHQ0SUdNRzRmY255S3VmTDcwUGdSaEdGcjVyVmF4alZDbUtZ?=
 =?utf-8?B?VkpTMmM4aE1ONGc1Y09DdCs5ZUhkVHZ1YUFNZ1Q3VURJSmJhMHoxMytzV2dJ?=
 =?utf-8?B?SHlQakhsUUVhTzdmbmZETE9CTk43L1BRUFR2aDZuMFBYR2F1NmFxZnpNYjAw?=
 =?utf-8?B?NUgvWGtwR3V1ZlFxVTk4bnU4dWlGL0pya0pSVlBVOVhSaGFjZE9PLzhOVkdo?=
 =?utf-8?B?aWlLYkFORHZDVzNsZUlvKy8wNUxlOUd2VkZzRlczNWhudS8xMUdJbkcxZytL?=
 =?utf-8?B?dk9OS3BMMkdsTzNUU25UdWl3SFNYRC9yM3pkMkxVSk02ODcycjNtb0ZDZkg3?=
 =?utf-8?B?b3FpQ0dvdlJ6RGhJSHFaVGE5NlIvZ0F5QlpJZDFDdkt0a1NCdit4bUJaRlo0?=
 =?utf-8?B?WDk0UFdIempkWEVOT2lSL2NhL0t0L200cUhzMTNYdVVCU3UrWnluZ092dy9W?=
 =?utf-8?B?cll5cHN1a2haLzR1RzY4K2ttN3BZSFhNZFF3NkpuVlJQSFRSVGd0Z0MrUG52?=
 =?utf-8?B?T1JYaTZ2RUl2QjFhQXRoSWdMZ2o0R1FjcENOVDB0SHBmbmc3NEZTTnRXVVpZ?=
 =?utf-8?B?RkVkZzR2a0tVbERwK29DQXUvdFdPOGNyK0JIVk56UE5UVllyQ25hdlg3Z1ZJ?=
 =?utf-8?B?Wk1NekFkdDk4OWdQQ0MzZC9RQ1BIdWViSDNHUGNnL0hVYmxPTTBxYUtNbnRm?=
 =?utf-8?B?OXB4eDdCNFl4NUpsa2FadWo3dGxKcGJrWDd4MFBXV2xyZlEwaU1qbklCekha?=
 =?utf-8?B?VDQwVE5ody82WC9DQ0ZjaDZmT1hqUVVqU3gvSnlRSEhLZHJZZlIzVmw4c0FB?=
 =?utf-8?B?c0xCdHdRNDZlcy9DMldtY1FBTTlGeHFGWEI2eUVwME1rUk8rN2s3K3J4Wjhz?=
 =?utf-8?B?MDFuMS9UQzd1NTg1TmpVdEM3M2xLRGs5OWIwOFhEcFNTUzNOcUdNc0FZUXlk?=
 =?utf-8?B?U016WEdLWmt6Y3VtZGlNZUxXdVFLdUp4UkdabExuQTRmc241bkovbzhxRmhH?=
 =?utf-8?B?akRIVXZGNVBVV0lJNlE3TUVHMVNNQUN6VFNNc1FmVnZKVGNsNWIvYktFV293?=
 =?utf-8?B?S2wwSXM4SHp5MWxuS1BsSmZ2NUN0MDJTbGhyR0kzODdTY0pTV1dsdjk0aTJL?=
 =?utf-8?B?aU9MQ0FGL1JsK0VZbStUckY1ZUhIaVAwM0tYZmIvUHQ0YXpWaHoxVWlHeENK?=
 =?utf-8?B?Wnh4Mis3WkNkbnp4ZjlwVERNOTR3SUp5aVNNUlNGUVZ3K0l0N0s4ZTVkalN0?=
 =?utf-8?B?c3JuVmlFNGZ2UUhOSlRxOTk0OWNUMmhKUUJyRVFWcnFaQ3pYdi9RK0xoM0pa?=
 =?utf-8?B?V0FDMkVrK2hwTHFrQ1ZCeDhOd1MrZ084YitaNENPOWYvQXNPdTlraTNDN0ZY?=
 =?utf-8?B?bUdNNVJlbTNWR1pHR0FuSkJkU25DZlMrWkhPbit3OTAzUUgzVk1DT0hJREUy?=
 =?utf-8?Q?4hulfsMPVXTG8wfWvMtLGURkw7QEwtPTTqqNL?=
X-Exchange-RoutingPolicyChecked:
	VMF3WwUEkgvQqqOhH7yBE2XcJGr2yXoq3Eaxt6OKRVXYt9bjtOnvf14g92OGWcLwzDkf4yqsu6SQsMGwR4Fa4hGoiFetFPA2nsrCE+ZpG4ayrcljOgygsNx3dw9qa038Sh8Q9FmCtTULcgdUd/hxbWKSxtnQasBWZzQlLbVCKhLO3FEZeiRLGFvge5ta2UDO2pcQ1d8cHEpcR3+PZziG9xyGljU7uKI/7jOXfcawYdnc6hUd0kD8P0V8jVVTniFBPeMRB9Cng+lKvNPdlDa1Qut9/VmZEbcRNsKd6IGGUCM83kt95DIoB++iMJrhFZfzz6VrCyyaGZCQV3e4TFofww==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BfyalqiJe5Z2QGBWqo6+PgawDgmMx0BpiMRJYBFUJm6WQdfld0wFcI6/A9Bq0bVJCg47bg5opxFnVoz5DRkMWkJzjJ1moXGaCFg3WEceocPQ0M3ZOLbduVUoH2r37MjqlWEYykZOmlODIKZp6Tw6Beqhxk5M1BjpdkFF81YOVMtkeEiV6pRBg9YhKuYCOi8lefDXmtd4HUCVRuWbTUoaObDDb4eIkliJDuL4NFJrqYBlxp9ngGy7uNPEhwgu1zY/vm3xxa8FXsv3LFrawvrcDTkan1k4j8f4EIk5plMsUP3bp/mXu+qfOteW9WBmHWM6ga9lcxZfyWZFwGC5ATw6h0/GnOHBD3ANs/9wfDXYSC5t/QA0FiPvTXpTCVjPbZcTpiI8lu0EUrV0iV/EuyEzYeTPeA71+dRbZrwG31epUwp1gkoBMbx/4qOnRVqmwD6SG+ZUE4/Bnb58FPM0uboSbOhe2h88BQW+LgOsf9qxpEbMwvmPlgG5zdlRJyno9l0c9WfBhhxXRKqVzO52A5L5UP2xaw13xYfhJSg+j9A2JKOSPFpEJ1ZUgRvKzojI297hB4ce2kVIEvhnvUDvrelUxKJ3X61BImFV7EOpI37WD4I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135dd650-ccb4-4788-1ad0-08dede7668ab
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 11:28:47.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oITw27T6AsLnkZvsw8cdIiARZrQKAwQWS7RFpr/7+EdvTDVsq3MF239Amm7cMiPme6Pnx8C1grAeocW014KFknnUoBkE8T8ViE0nC6Pm1fMIX2+KZIWqmois3mZdvcV3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-10_03,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607100113
X-Authority-Analysis: v=2.4 cv=BMaDalQG c=1 sm=1 tr=0 ts=6a50d774 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ag1SF4gXAAAA:8 a=vOQQM0ksm6Mw-PTof5MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: TCEMdFD7jdxfzuAJGwocT3xs_Ep7NnpH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDExMiBTYWx0ZWRfX7/OxqiciC2Ff
 KLJFNUprsc83iJgDeH+QQ0vPrq14jffxyfGwujbIBJ9EhKPPQ3ie+z9JVw72jgJJFb+3r6N33r8
 CUY5b5MRJYsmpCQhcwfIZ31u2ogwYWZ2+vpI9sYtBfUG1LmvaA25
X-Proofpoint-ORIG-GUID: TCEMdFD7jdxfzuAJGwocT3xs_Ep7NnpH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDExMiBTYWx0ZWRfX8hz6EnMUphz9
 Jv49RZiSlUpeFQfgbVuxg1rSh/T/EtXM79mB6BEVRLrrlJ5rIeiYBYksPVEvNT1mC9Gs3aAMDws
 e5rP2/tEW0ROC5jXg1DbxUmSmNckjkRPbWw/ABGkCT1nIkWlLOlSVZiE8/AT1qUsdZARoDqNO1w
 nST0YJdvme+K0ugolQQRQG/8J0nfE31AERgTGTyRlkqI+91CGoDS5D3yo7xxc/NlLs6DPJ7DFp/
 RHD5O3pNQGglhA1ntj3jaz3MRyg6ANaOI3nRnJvgqHMoFG93HwkPD42U0IPw7GqUBMxZJN9bZsn
 l83p0tE0x17wgDUvsEeXuPDh7nGRtZEx1e1XQDLYUjNmwrrIWiChaYNvNB4OdseFGP2nKAV5QV2
 6kadZufo4krJZv8oakqzz8ZAOWKkD0mmofRhR1oB+a12ZOAai4pnIFokIAB0pH0eV54QZBmMcBD
 jSfqZwpDoDUQRb/rJiw==

Hi Greg,


Sorry, I couldn't send this in 48 hrs of testing timeline.

On 02/07/26 9:50 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dominik Woźniak <stalion@gmail.com>
> 
> commit e186fa1c057f5eccb22afb1e83e34c0627085868 upstream.
> 
> In __cld_pipe_inprogress_downcall(), the get_user() that reads
> princhashlen from the userspace cld_msg_v2 buffer does not check its
> return value. A failing copy leaves princhashlen with uninitialised
> stack contents, which are then used to drive memdup_user() and stored
> as princhash.len on the resulting reclaim record. The other get_user()
> calls in this function all check the return; only this one is missed,
> which is most likely a copy-paste oversight from when v2 upcalls were
> introduced.
> 

I ran an AI-assisted backport review and verified a leak in the released
6.12.95 equivalent of this patch, 0ec4aaa488ff (“nfsd: check get_user() 
return when reading princhashlen”), this is only in 6.19-rc1+

Upstream e186fa1c057f uses an automatically cleaned-up temporary:

   	char *namecopy __free(kfree) = NULL;
   	...
   	namecopy = memdup_user(...);
   	...
   	if (get_user(princhashlen, ...))
   		return -EFAULT;

   But 6.12 retains the older manual ownership model:

   	name.data = memdup_user(...);
   	...
   	if (get_user(princhashlen, ...))
   		return -EFAULT;

Thus a fault while reading cp_len after the name copy succeeds leaks
name.data. The upstream early return relies on 4552f4e3f2c9 ("nfsd:
change nfs4_client_to_reclaim() to allocate data"), which introduced the
scoped cleanup, but that commit is not present in 6.12.y.

Maybe we should fix this up with a downstream backport ? That looks like 
a simple approach to me.

thanks,
Harshit

> Mirror the existing pattern used a few lines above for namelen.
> namecopy is declared with __free(kfree) so the early return cleans up
> the already-allocated buffer automatically.
> 


> Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dominik Woźniak <stalion@gmail.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/nfsd/nfs4recover.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@ -818,7 +818,8 @@ __cld_pipe_inprogress_downcall(const str
>   			if (IS_ERR(name.data))
>   				return PTR_ERR(name.data);
>   			name.len = namelen;
> -			get_user(princhashlen, &ci->cc_princhash.cp_len);
> +			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
> +				return -EFAULT;
>   			if (princhashlen > 0) {
>   				princhash.data = memdup_user(
>   						&ci->cc_princhash.cp_data,
> 
> 
> 

