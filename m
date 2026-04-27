Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6903AEF54
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 09:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280558; cv=fail; b=spC5JmaAsN1BqROAis9Klu690sR5WsZSgHpAQO+ESIbm7ofY1UNbWgXKuwU3+8DypmpjbwMtJ96QwRgkxMcEMx67UwlX97yaBUPBAg6KGesJx16qY19elA4t0fJkDTwU2XJrOWwkqp4g+PtX5rrqbyijacIn6n9MoZCx2sruL08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280558; c=relaxed/simple;
	bh=Mja0oDX4+2phjeNSklDwUVFv84zcOKzC3+2X3aiHON0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AbUDPsQf3hyeFkhDCP+KKHb1Iwi4L198QbyMzUwaRraGdoUa5cOyVxJOes6yEuNaXMoFIh+GEW7fonuLcDLqXCo+G+aZfLvBzQfgd+BNpaavriKTHxnG/pK566PG2I1SOA1+rajWmjprNsuFlukjjyq10hV3kPxJ64qUB4Lgxo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZJK7t5G5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cOZgqmV9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZJK7t5G5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cOZgqmV9"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QN1g6B3976211;
	Mon, 27 Apr 2026 09:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ka8qN+KuhvEnuyormcz1+yLiAPfkgy6ilBuN2AYYMME=; b=
	ZJK7t5G5pCeEMMmBSD9p5Mc0AoIZfBSltQsVdQKas0dZTh02vKM6D1VHE7tE3q6z
	Dhi6KV50uvCCmi4dMgrCjzjKWpjz4dLmN7KcgsdJfyVwUpbIPLmiXNZkQmyg0/qy
	6TLwL9sAWrvtE2pwFh7PKwkfPFQtR07K0Kz1OI+4mwiBNW8C471ZCaUym7qKSpTO
	wdkW3YGeIgBUMbBJk9GzSmTG5mGO8hJORdLnf2luQTpGEuQqA6OUVAlAcni+RwYD
	V7IUQnaRhcPJhB8Z+bels0kIc1OF8Y0P9Uu21y8P60YK+1MrDBey+MT5E9DzWtWf
	0qJlfOmILVjpFSX2Zdfyvg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmha2t85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 09:02:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63R91Kha026709;
	Mon, 27 Apr 2026 09:02:20 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2a6d4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 09:02:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UFf5Bdu1M3lO7mtkdhGon/Q1AJ6OEqIYPjrjENByXCtfc62TiY5gNauqZWB7oYaBSPOa39D5eSl3IBQ/japjdb0vR1xBk+yM+04kUEK80sE6XRAcc+pwq/3qhDXkQ7LWhzZLBc9W0dQtict0qXHi9TZOECy2yCppejIVhIAJFharTaQOVtcBgMxA7LjzVip3hW5dI6rXuGNdoFYOj5O/J+GjiKHbadJzasgOSsBJsyPQMwL1md31LRBplfQmsRWe4sP417yHh8MjMWPKtP/qrj+78F9CulIHXjt0N3cI8FdvSHoLgNf1l23fAR/sZzxdRo/JEplsGWmqeDKlmmiWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ka8qN+KuhvEnuyormcz1+yLiAPfkgy6ilBuN2AYYMME=;
 b=IjGAWjWn9/+fDgc35x8t5xm0vwwFLe/3fX7f6nfn5mG4NNU+JIjQ4jQ/QU+cUmSlDL//hE2pgU2x6inHkpACr6gp5NjefxprbS4OVIYiU/bPOexmffEgY94HvWkm03jhRxMbfcox+DTLC1athVMKBCDIDrlMRxL2CXt+msZn1q2W9imZ9rk6OaEoEq5wtw45uScnuKZUls+d7xGEncRmNpJ9eFJ7CuOlYa3oLYO8Hk75VQEmUnRy69RBxgDkuq1EbtEMkxzvvHA2L05B2ck5hV4kVFI0lJ5ScWEhD/nI1j/5HyH8mmyo9QBTlvFCdc0XLN+rUUNvk6zd1Z/drDxImA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka8qN+KuhvEnuyormcz1+yLiAPfkgy6ilBuN2AYYMME=;
 b=cOZgqmV9eAu6wxydi/V9eQc0c0133YWtlFLElVerUdw6vc5YwOW3oMx6QA9l+xOls26zGf5DDQOtDNglUW/DBYLeBAnOg08do9v1NFbEVkYK/Amf5v8sqimvnlMJubmCx2Or6ssbMEKwtEt+NRvGtzYPK/YLD7Y6MPdpkTRRfUI=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB6414.namprd10.prod.outlook.com (2603:10b6:806:259::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 09:02:16 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 09:02:16 +0000
Message-ID: <4010c43d-9b6d-492d-b459-9448fa974809@oracle.com>
Date: Mon, 27 Apr 2026 14:32:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260424132411.427029259@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::19) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4e35f6-5ce0-4071-0138-08dea43badf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	NEPSG++OqWsrCqLXVEyf5drLT1An+/VSoMVYVK4DGdz1rZZZLfTBH3o8ve8hzHTbYQs6cLcLGoTzVLwA3JWBZ3eO1Lwb8rf6OUKC7EltuioCn6EkfT/7EjXTZ057J1iIYGB77kPmkXqSWKwDqBpT57/YOEmLWdShj+qLcTaY+onkoeyaWArZBjX5hQF0FsS2ngD3UsjdV/8/3aLCJ8irSXRX/QSUJUvrjU14HWS77IHAt4FBcVwtDyYxm0UUL/YjN9FyeJEwduH9yszqDJaUn88hxFuU4so+Yw/v44elpiLarGoZnlJZrAPqFitXbD7Iv+B+jloIaiwIW8gE8fJUOgUeIqqqr9uxj1FF05rFoTNX/FxxMkDNM7vv5t73ZjuFf79jkscrAwTQfkuUKIiF+kLthIRQCOS9tjdLDrZNvJPl04B4EsL/puKz1GX5FQE0VjtVrw0PHm7ZLN8tmOAWoFvjU3M+5qyHjPD4FrDqqwo1J2y21ubPhV64Gs3ngmunzZKa+huX8MP3tTmSyK0hyy3jNAc6D/7SH+4IsmgDnxK2V3ClC6NMgS9TNlO/MWsXUCuVA14klJjeA3eHRwYuAKCmTcDNajXPsQ7BydnjVNriAdBkkWjkJFglRMnjdR8HprxkBqXcTL7G7ZaFv+tsSPQ7wsYFeJdBERQwVv9NcVR1Xzhtunu0+oHIRHz71mMeHlvCvgVw6CRQR7ald+gIhUWoUPPxwfX3wi+/+ZN7aiM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHd6Q0hReGtDRlBhQmhIbWx6a2s2WnB0Yyt1blc2ZlczZDNlRTdEbnpqTHVO?=
 =?utf-8?B?bDVWOFNZd3JOcTZWSXA4VTAzbDNaR2xNWWVndHQvemdyTndpR0hGbGRURlhE?=
 =?utf-8?B?MlUzcHlVeUpSbTM2UUphVzVUS25QNTcvamdDZU0vb3gzUlFIb2tEd2pJZi9k?=
 =?utf-8?B?ZXhGa0x1Q0Zoc1Jka3Q5UWxhbXJab0NEcGc0VVJXQndkOEFNblpZTWhubFFX?=
 =?utf-8?B?S0QrV0ExUE5zSzVYd3h2NWVLcmRkazFpQ0tqWGMwMnpuaFZyRk91RnJvU1J2?=
 =?utf-8?B?Rnp6NjNoblBJT3o3OFFWUExPTEgydFFOVnhidGt2eGdjUGlxaWJKYklLbVV1?=
 =?utf-8?B?Zmc0cEZWKzh5QWQ1VEcvNHJIQm0zUkxiLzg1UGoyajhWRmhVZkVHaytKZS83?=
 =?utf-8?B?S2lFYzJzMGV6OVVnS09GV0gyTHZqVy82Y1BwNzhrbnBwWFhld3lmOU1paUpp?=
 =?utf-8?B?L1VuK3FlNFN1MU4xUEMwOU9NY285Mk5aeWZyRnMvLzdNMFJGYjQ3akJCeERF?=
 =?utf-8?B?UTNBYlhsb1AzTGFZbldtVVpmMHRNeHZubkhDSTY1L1J0S1FOSDhDUTBXYmFv?=
 =?utf-8?B?SUdNQzNCbGFSSDNTQlFXb1k4NzBCYzNPcjNFTVlIaFJ1djBsbVFOek1rYk81?=
 =?utf-8?B?c3puaThQWUswZDh2VHNWU25welpLV2Y0ZzZTYm84OTdDUWRwTGlnZUk3WUY2?=
 =?utf-8?B?WUNqTDg3akVldDdrMG1Yenk2Z1EwL1VhRXhQYUc4Vzl5YnN1M21HODVqM0tx?=
 =?utf-8?B?RXdZVE9ieE0yczB6RHVycitaTStrM0JpVFhvcWNqSmVMN29Db2I5cDhyWVV3?=
 =?utf-8?B?TVVsNU5xSmdPZ044MUoweDBmKzFYeWtoOC9ISUFJSkNYbTI2dUhWRWZxSmxo?=
 =?utf-8?B?K3JpWWxPbkJuYTBYa0pkTkppQm5ZellEWTFVOXhQNDg3VmsxeFJLbHhBbklS?=
 =?utf-8?B?amp6ZW1GQkhuZDRSa1hKMHZRTy9VVStGbHRFcDlHbHd2K3g3V2F0TzBVUTdt?=
 =?utf-8?B?eFE5ckFQOGwycThWZkZ0bkZMVUdwY1JDTS9pMEM4VmhCMGNZdXVqN3dDaG9u?=
 =?utf-8?B?Wi9XMjNOMFRuVlZ1RlF0UnJpWTg2NzRqbGFURDBUSmhsSnh6RW1hYTFFaHE0?=
 =?utf-8?B?S0o5Mi9OSXlDeERCb1FHZUttNGNGTDZDSDJ6dEFremdhbzFPNnpaS1N6U0lS?=
 =?utf-8?B?cC9XNWNrMDdpeHB0T0FQZXlkeWI5OHl5bDcyenUzL1hvQlZPcWpXc2FiU1do?=
 =?utf-8?B?a2NudDZDSXErRUlTcm9LSDB2NWc4bXhMYlBrZFVNL2I2NkJ1bnhpSzhReFhZ?=
 =?utf-8?B?VGg5MFpkYkdrMVV2Wnl0SXdzcTQveTJYQ1Z1Ryt3aFRBM2VxUjVPczNYSVlS?=
 =?utf-8?B?STU0RmFlUWF6b2JHeFlrN3ZlMEtIQ2Y2Z2xabVJKMnhRdXhYOTVHZzRacldV?=
 =?utf-8?B?Y3R5TkZrTStYakJpNzFUSjNHS05WeWlWNnJyYnJ5RENHMlRJQzg1RlBjUWJm?=
 =?utf-8?B?bEZvT250WDNsSENTRVkzQWl6ekpuMS84T1ZSdVMzT1hYS01KcUZ1V29ocm8r?=
 =?utf-8?B?TnJHZUJqTUVKeWNXWXRyc3N5OGNBUlBuSmVaT25jWFZjRXdoRzBsbkVHZVRN?=
 =?utf-8?B?K1FWZFFJS2g2blJJK1I5V1A3Z05zdDhnWk8rS1huc3lJeGVvNFRTOVhlK3dw?=
 =?utf-8?B?V2QzNFFQMHdiaVhlWUg0K3ptU0FRakxuYTV6NWNMaFRSaDIvMlRid3R4S3Y5?=
 =?utf-8?B?WmRXQmd2QUpyNm5FV1dhblN0emRWTDFuOUxweWtDNk1BRVR4S00zelF1Lyty?=
 =?utf-8?B?WWpFcUdUaWZyMkNjM3VIRWh2VkNoYlB6R2pmTGtXa2ZLbTE1VXMyOG0ycFZM?=
 =?utf-8?B?WWZlNlFPa3hlai9yai81ZFlHeENBeFhvb2xNYXFtR3BSdWJsQVhobVRKMEJ0?=
 =?utf-8?B?OU1CeFdmenJ0cUVrb2ZVdzlJYWJ6UHMwdmNWclBpVm16RE8yWExkVW1MbWNH?=
 =?utf-8?B?aURLdTREU2FQRVc2RkNOMHl3bGdGYWxtRng2OHcyNUROdEhoZWMva0hJd3hW?=
 =?utf-8?B?S0hXNzgyNFVxVENmandOdmZxK2F5UWk2dW1XNnppRGpWU1o3enNUMzBVMXJS?=
 =?utf-8?B?Y1VTT2xHbFRqVzllMkhrUUVtZ0hLYlljN0pDeXo4SGtRSFo5dVNISGFUaUJi?=
 =?utf-8?B?UlF1anJZYTBqT3RaZzBZamcrSkdoa3RMQUtvSlhCUUFNZkoxZW4ycXRuS1dR?=
 =?utf-8?B?cVgrU1E4cEoxT3JIekpqV1A1N3V1b3YxaGJicmRmQzlZa3dIWmxZNENjR1c3?=
 =?utf-8?B?WTdGcWJYeTVDL3lySGNHNUV3YnVCUDNJZ0NuNmtVcC9aNEpxWXhKVXhqcEdD?=
 =?utf-8?Q?LeX7gYbrzzTlnZpO2KH6YYOF1rD3XcTP5Cyid?=
X-Exchange-RoutingPolicyChecked:
	swPkYV7J0G8z0l4mZsQlwi7OTSeyDuiDeFe1F5Hih+udBveKUZfICPijp+iADEN6Rd8CGSAA791dyzOdXMT6sHJ6xyLtDVIduFhIwYndAogCKRNXDKIKoTSWu0JWFV8vRmWcA4ylOqAPTO+PO123JWww/IygvUY8AUpV0CImgesBXkv9+cJhr6sXPOKlkzvGjB8fAqOGfpdeo8gdzba3sXCYjIfmhOcuwkPvoGSM46DO/oF5cgY/F1H2iPNuYHXZywyMhW/hHm9T8BSOId2NGCUEXzFx0d2kBF/0bY01aZsxchCtAYg6saze6V/aRoLDuC5MtCq0P6O/EElJYJ/IBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cvxn4ryGklq0Wjr0C1QluOggk0sgZL7piciNGr/O4CJlc3/1JzownwXzbJrpnsrK8PpLVlgQ6h+5rZdlMzPDP/fR5Fuku0HiN7JEi4q0odTdeiGBLKa7yji26Izj5+g9n2wPl4lJ8bjIy7brKyBSloI2DUsJyWQDPKXeCHgWH4sdCha0fzQFL7e+0yqOIN8h2npvZ4le27INw0JFYoNl6p+8tdB6CN4y0WL3MXvll/o8UDVFGvuhpsjVlppJtm8VHhr41vXW7BLNb1ZPz5Tfqsc8WeBqcKDHN1T0LkQ6gkK7evgWtDHYxXukckymxPzBx4y11kkycexKBAlulHI/z+9jdi2bRlZmD1vU3zFmJZXFwNRcScnhrrNGEWfz/HYnQB6tWI18VwKr2Y+1w49drfTtOL6yoaWHCMoGv8yxEvg9rfnFqLGrU9xxPRHUYBFYEQlB0LcdqcN/aQriB1QlFWHTpHZAu/1xqWsRCp2rK8y2y0xGGAWjChTJUfpW+mm9WS2HK7FVySISEoAEMcYWHrcH3q90TNeWp5P6QNSAy8UZhu4HmGp/MKBxyH1oQ/4HGPiix4mDuC5UiH8MaJunLpb9fmvIXLwD2aEN/utbMIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4e35f6-5ce0-4071-0138-08dea43badf5
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 09:02:16.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrvEuqGwjGW6A3FM5rfLJXBapKFvpH89jmT4nbI1Bfdli4//mAjz39ERtAn4sjpChkEEexI4EcfWSAHWaw1AXeJ1eNx/NwNwg7LJcXcVWHwp1x63Dun+XBm+ytADp0lD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604270095
X-Proofpoint-GUID: FYG36otUqN1Kc8GoukeIPw-tliAV-XV1
X-Proofpoint-ORIG-GUID: FYG36otUqN1Kc8GoukeIPw-tliAV-XV1
X-Authority-Analysis: v=2.4 cv=CrOPtH4D c=1 sm=1 tr=0 ts=69ef261d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=L_-ODA6xV0cP-JQlw-YA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5NCBTYWx0ZWRfXwj6rzaZjNdvS
 qvVa2sVZ2eFo3jjo/UPmEvNn61qQBDMdKUs77P4rv7flEuu+5zdzhZ5NO1y5cd6zYcHvjV4twFm
 mHaJbVG4KRU8uq6bglVXvByOmbiEKR7rgJ9iwVx+12+iJq7pv63bKay6/7ZW3LSt6kRvKvPBp8K
 yzozmeeDiW4IxthPYPmVJNV+52XWBMSX3owXfxzgdBgxYbCJa96gP+MA5mChB0T2bQoIvnDlGrm
 Y2rVbjqM5QX0IkFoOEOGyjGZT3UJA6auE/kGqazm6b5W2ma78DNldme1dopSp3vPiLi+2GvItCy
 1sJMhPJqx6FuDnnzNvNrYCMVm1mdsYqHHalnDm3O5xcfzIsjRenYso9CbV6EBX5eQ9FlrkbkygG
 zV3PnspPbWRe0rp8sjetEVKUQVIrCcekOrrVCEQAueG1aMc8V+ChXujpI7B16CwZkt6dfjyfvE6
 mucXojeNy58YQ9jgaZ+ZiziBjRXLjaFc9IyniTDU=

Hi Greg,

On 24/04/26 19:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


