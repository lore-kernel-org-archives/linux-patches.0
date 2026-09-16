Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE644E05B
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547853; cv=fail; b=WHKkwTiSYO/ooCkTcAjZ6fGq7RaFln4IgHV7e6Zy634CfgAFCbXpdrQuVCYUre839T+ac37JRgC9koRWYDIHU4C5W+2iZNG1+os0if9TcOZfG6seQSmsNXlKa/AXFEqjUMPQsPfFWTV7/ZpnrMYPXwtHeozh4jj293OmKL7zcsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547853; c=relaxed/simple;
	bh=BVbU+oQaAP6dDP+kBH0pVCfKwrObljsjLxFYODpvf/Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hqcC857QP7h7bA8YPTIigtNmikFeh7isj0hkjFPxg6GEoIVkAwTI/5k1eALgmGUtAGTj2oYDGie9Vo5mfVa/Xam3EOaWieEzJwewaAQGHXIs5HsZO3ns7EFbabQq6v2how2F1XoygNwv4j61wZc/+RxXJB9fB7sP/mF1FqlLXbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mWG+XmIf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iLqFLCgS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mWG+XmIf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iLqFLCgS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLX0tD698974;
	Wed, 16 Sep 2026 08:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d0vvm4hPBy+lYPGOK4J77POLYf/q/onbnM/DymiBoHg=; b=
	mWG+XmIfSlOTeR5kZk/rJr8wAT5XiJQ21KbHXyRa4+m03ToJVEO9dgVE13X2v2f4
	EHbra7RCIgRHckibBoa92M4tc16I9hsJV+kOaVcQZajncDWybO5o/A9vqEugKD2k
	XjduPDcGqK7MhkpZJfppJKVA4Bmpz/BiCmgGNyjNpWO3CnSlpxka9VaXlnxAt48A
	oYt3j6CTYU4En7rGGQ8aJuWzcPOmRbfsMFjffjADxynuNGFZKi4rD8hTC+K4Zmao
	tuKGPKBUde+EyxyCtdrdESPoYsRtRiAHqJQuZWEOZKPL7rvSn55KCfs1bxv1OvKJ
	ha1Qc+lwFjsez6p/rCoedw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7d6qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:37:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8ZOXG036336;
	Wed, 16 Sep 2026 08:37:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q3h61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:37:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RtO47b85hEC0iSX97LFM6jXkqTh84Zv1oHx2oLapPSldNIDHq6b773u+28r8XOZ3Hc8+Eidf1IA1Sl4xDkSCaTm/LYn+owUkorn7Gg9FXvxOoirYYPhb5bMJGDHqGkcw93cGtMp15M/v0NzUR5AxRxeXmLNmDYiWinkGq9m14tfuTBLbVJnbcm+388qS+C2T07GQZgEpLfgwmFT48s2V4Wlo/3mv/67sDuSxb5mRlE42o5g/Op9JFtiSyjNxhIGHxoIrAJbV1/fS0HCKEz0UOR1dYk06ksKoaCm9i1MN96kBlDYMqYcaLoUthlDYE3qvGBudA6wO84S5IL/gT7O4RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0vvm4hPBy+lYPGOK4J77POLYf/q/onbnM/DymiBoHg=;
 b=mHGhcB1kpCHMLUCYuGZzObGq/+UQBYm5sG59nqGELRZYWJamRn5nOPyd05pu8mhauFmjYW7X5Ff8SGOUPTw6+HOxUPBPgAaSjsOBdAeBY1qJOzuAfDsDCi7yyd+j6EVZeC7nonMyZG2T0cgZJ1HoDZpyN16d4xBvb6Pb2Zr/waJMYH1BFSta+EuTc9zhf9lpPF3zl7HgO/VkUdaYv2fYgcBegfyONYbLKGefhYcawKE13USFLfMZi1G1s6seBSj1nozkcZucmgv010nOsxTM4nN+5Huf5CXiRawueG5aXvgQlnLjOhfbN5nauOZVrXfx5WorkXwSaym5wPMfXoLi/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0vvm4hPBy+lYPGOK4J77POLYf/q/onbnM/DymiBoHg=;
 b=iLqFLCgS+PrIaGAsv/rbqtJHjN9hlumRgWkUM9FbKBgDvymw3+ukqDjzxar7xs0P1s9eQL8HUZuQO1WP5xVmPesgVxnYtZeYzS4/1ycZOHaLbvjY8LsDTtYxLkxxP+bEd0dlXbUezN7+Ibo4X23XLWYgnUpdKY4vjedJheB4mCY=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS7PR10MB5055.namprd10.prod.outlook.com (2603:10b6:5:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 08:37:24 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:37:24 +0000
Message-ID: <c0d91f0b-f392-42d1-b96e-86b5bacced74@oracle.com>
Date: Wed, 16 Sep 2026 14:07:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1141/1376] perf dso: Use stored fd error instead of
 stale errno in file_read() and file_size()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, sashiko-bot <sashiko-bot@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065632.988034517@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065632.988034517@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0026.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS7PR10MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0d0cf8-a515-4bd0-2cc1-08df13cdbb08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|6133799003|10067099003|18002099003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	HS6n4egqM/jiCwwJQ6dvrPJtv3wrnj6zzBy/K1zYEUWg2Tbk2YfGgId8lqzR56zct+VLFsYnN/sh8gD8R+II4l/ghyoibcXnX+ZRyi1+3Wq9GG5iQpSoAgu01cgKM0FumE7Kqi6U/lVjgll+Fi/IBi/qwXHTfYmOw2IL14oS4y+YChW2nlKHl+n+qWsiH4B/ELU2lVXCRXJVMi7JGIMnMfgppXq/8vrGtlNLIzkBC279Ia7k3O1qZq2txYTF5xVjxygfYIQXHyIXvYO+P4WbbNCi0bbJm8udPY+qhm5h2yco3wF2m7IAlyELkoSjW9jNS4oKzIv2NfA2uuVIZKUUrdAiIOKTFatZaMDViEgVtbUsqkrddg9l0Fg0mEUS78Z0htj3Fji0akNGThID4XvLEnu/SvSLQXGMa3McOvoXdGXGw5E6WNWMcFDnTSk44iuDyZ/ZCzqnkNvMrhUcF1vWpFIwbhyrApPn7Nya+jdNFr9lMuYZWVq305+kS0TzZedw7qVAKZi9LiqO/XsI0ojI6ugj34qC7sBQwQC8at2PwRNV9D2VTBWfDrCKyJZoBA0hERW3/n2SYXGZ1KMVt0/5e0gviiyWGYjJiHzzSjfAACbjPadPI7oyXmJ4jD3pyaZewQN6KYXldnBldM6Xie1W1uTFq4kkZ9dor2xCr/NvJHA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXM1SWFQb2hwaDNxT1NxRGs3VTF6bzd3dmU2OUJXMUF1RjhwRzJrakRDalJi?=
 =?utf-8?B?WUZkeXFJR1pWQmNyWUFvdHdHT2Q5bmFNdFhUT21RSjJlVnZjSWx6NC9DeW5P?=
 =?utf-8?B?cTdTMFAxSGVUZ2dwQnlYRFViL1F4cXpzMDdDWnpQY2o3K2s1NGJTMENNYytp?=
 =?utf-8?B?bG5SeHpMRW5leFRuNGtIUmdVTjI3RGRlaHQ3TWJZRnh0UEwwY3RCK2xtRldj?=
 =?utf-8?B?RVdrcm8wMVNWQ2FTQUZVZSsxN3h0T0txWVNqTkRMWVZLSEloOHZ2Rm5zQmVn?=
 =?utf-8?B?UGFQUkJYQ042bEozU2huRlNEeVZqdThlRG5OaThqRUhhMkZmSCszZnh6UzYw?=
 =?utf-8?B?WTE3YndwN0NjY2FwdnIxSHlWQjJWbTBqT1RiL2Q5aUZYZm9Gc09kWHVVbjRU?=
 =?utf-8?B?eExqMWFnNVc3c2Vhc1NJMkVaQklIQ1VkcExVS0xWMDk0WFlsQU9URkFLNHUz?=
 =?utf-8?B?dWxhNldSUm9kV1lNR1RBa250OGxjQ0xNYTJSN3BKMTlRN3hjK2tXdEdiMHBL?=
 =?utf-8?B?bHg0YjFtQmtyclZ1cnUyeHVvK1ZRRDJqK2pUMHVGNmprWHFLLzdJWG0vQVFE?=
 =?utf-8?B?cElxYnZ3NlFFVWxPZ1R0Z3NRd3Rpek1kMEpUbG12bzFuaHAyNzVEaVlKQ01k?=
 =?utf-8?B?N0J5OXlvWUlrTTdqeGhZN1pCVTJ3RVJOTm9SK2t6U21INFN0bUxOeGJkUFhz?=
 =?utf-8?B?R3lwS1hWZWxKZW1waVl3aUVPRXJQcHg4ZjNlL3JVZWtHZ25KaWZtZXAva2hI?=
 =?utf-8?B?SmJWSDYyZEo2Q2pldEJ3ZlBuaG1FWjdZaXVWb3VWOGF1MkdFSjUwcHBJSkpZ?=
 =?utf-8?B?SWVVeWhjQUxudUpkV3VNR2xmQjEwZUdta0ZGQVZvTVpRTkFwVk8yOTIvcGFS?=
 =?utf-8?B?b0IzVVlMeE9ySWoveFdTa3FST3QyUTJkYnN6MzVnaEFidU5GV09sdGdkaDJl?=
 =?utf-8?B?RXQ3ZWlTSStHeC8zYW9mVE45YU11WkI3UXQ0Wnd1WjdWN1kxTllGOEFudnlU?=
 =?utf-8?B?NmEyUHRna3hLb1BZTVNnTFBVK1ZzQjRvVSt2eGhNVDFHZnhEWlFOV1JLNkc1?=
 =?utf-8?B?MXZvYUtpR1BkbTRINDYvUTBlTmtkM2dOMUozOEpiekFGaDdVc1o2TTJGRWlY?=
 =?utf-8?B?WDhZNTczVkx4VHdia2FYczVjVmduQ0Vna3VNbThHdEZSWW9RZVF4bUhzMmxV?=
 =?utf-8?B?L1A5RTUveWV3ZzdNUHdTOEhIQ0l6NjRTMzRYUmIxcHduaDN5NW1xRmtQRzhG?=
 =?utf-8?B?OVZNTENuRURUcm1FdHpBS1cwQ3pqTXg5RWUxN0VyTXZzOUN3bDBNVTVKYVo1?=
 =?utf-8?B?K2dLUFhzaW9GTjdFWkpHSm8vbW1XdGNKa3c0ZVo1RGNFL21ObnFnKzJCRklV?=
 =?utf-8?B?U1A2RFhXOVo4Q01YQ2pxWDJSZzZzMThpaG1LN1FKZEdlbWttYjlSdy8zbHZj?=
 =?utf-8?B?YS9LdDdYcFFGNHc0OWFJK0V1eVFLbWRqd3ltVzNYU081MFFxanFvZEFhdlRQ?=
 =?utf-8?B?UXVmVzBiSUpWZ2JFMlhZZDRRdDBlcU94dmZXZUgweVRzZERabTUrR1N1aFFr?=
 =?utf-8?B?R01HS2NrY2JWQ0NIaUJzdHBxU1VGL2JoQzd2K1FHL0d0Y0pBaGFSOFF6TzlI?=
 =?utf-8?B?eDVuU2hQWm9MeGhaUEhpeHBpV3lxcXNqTGRmaDdhTDhkQmZmK2hUUS9jTCsx?=
 =?utf-8?B?V2xQRG5xRGFtS1dDSWRKQnpDeXFkdXFqaTZGTWlvVE14d2dsK0Z2VVpTSmdJ?=
 =?utf-8?B?RkJaWkhrdVN6Q0tuc3ZDVk94czBOd0h0VW02OEM1WFpCV0cycjRYR0xGNDcr?=
 =?utf-8?B?REJBT0FENW4xcjZ6SmJhMnFBMlRaTEFGMENFaTgzU0NJdWhXeFFUbmw5NzJH?=
 =?utf-8?B?dmtIYVVLd3ltMldwV1F4QnUwQ3dicG5TOW5Sb1ptTG96YnlTalBTVTFoTnEx?=
 =?utf-8?B?RFAzUXNRcWdEbFM5ZDN2cDhlOS9aNm9iS3dVWXRaY0RxRG1GUWlkelNUK1Zp?=
 =?utf-8?B?WjdKUlJmNXBGdGZTRlYxVGE1Z0VlOEphUVZmb0RmSEM3eHN3YUtxVEtyWVJy?=
 =?utf-8?B?Z2J4WnJkMStLNm1oQjlBVFhBQkJNdzVIcmdqQWxUTGROU0dMRFAzc0NkYnVS?=
 =?utf-8?B?eGJlYnhkVWQwN1UydWxlL1lUOHliRGVpT3Y0QXRnUEhxbmdWYXdYeVNXOHZt?=
 =?utf-8?B?T2N1Lzl3dnplalVJU3dxOHRoUDBkUmZyUWV6d1RRMWNueWd6Mk5HUGpXb1lK?=
 =?utf-8?B?bzc2UVd3amZWbTFiamxTVGhBRzgzRmN1ZHNhN0NHOUtWZHhUT3p4anhZVWhN?=
 =?utf-8?B?V3Vod2o3c1ZLZk1ETTNQdEg3SUR1SUJldjV2Y25PbG83WW82YlJIbDEzSFY3?=
 =?utf-8?Q?lswnYDyhl1fxIaearY9N+6W4QgxSfdvZH3cqQ?=
X-Exchange-RoutingPolicyChecked:
	n3v/izVyCfS9zaIeRjvaqXQ9kEKShcPXzZQ5VaWZJZeYFw6QkOtCx87W+1DxvkxrQXjIw9lswZZrgJARB4i6CXGkmDXMFm8+qkeKSdoXjWtIHjy8tAkLksdadaQGtl8G3EZQBqyN9KtPKhfrGX3WlBUrBjSuBBpXBWlB4PssjXQWxxKz6uMOmGxG75KKUb+AAFRvivUyce3NUwEyN+delmp5vidwrDl/s//Bxl/Bd5VLdcqRIaymsq7HHhB5ZVsYF1oUTkv/lizOCiRcqoVykLTFF5uEljoJC1PlJjinl6lBbTz/u2Ea3mqX3CvNCV6J4MkNIDWWTay03SeNrGop6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EkdYphc4N0oDF6QkM7o+zekC6H72Typ5EJ1veyZzoxSPKS+iUJ8h0iLxYAihkY3DjOTePJV5cemeurUwtMSGQrpmRdycIvr2jfhI16PnPT4k5A6ULpCJexJS5cFdT9LEkDk8b8Jg1UEIj/dEcK2rirdK1nSK55BegSU1SmlPnCFPawOcLsUuX2KLJtvawJdHkGMmUN3OwAcPoeSl31oz0MklOOtiZj3jUkZ6x9N44X6zIUgxa/T0ax7jNpFUCWZW/S1t7sD8K3ZesHIT0tzWA66IPIoTFZEezkd4hAjod+LKA6XIVBqSHB4ZzJ5dIF7ODXpMC4LVKWapOfBSh30lwTIs5wKuvGbYFtOoymbtR6REPrx4SdySNnNsLJg+BhrNNKJEKnxlGUmaGcfYX7CqtY+j/PdUlSLzt1/r3YSg/HRMa0+TOAZe2HFXHAFNt5FVAyfRgTEfljiAOD5e8nOFxHeoGn0fNcFzYbxBY365mQmDgpKzEFHOFDH13Rr5HcqnhgLI+wMkPyKiNATtJ+zyEpG2iC3y5zbxNWgavKov3ok5IFASckNcK4o6bRsZmNIzb4iQdaRT/ktkcAd55DHpMEdelmY/cJ/p/elg7RG2YIw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0d0cf8-a515-4bd0-2cc1-08df13cdbb08
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:37:23.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GmGfVmS2bFqPE5cM3EolulDIacaZOYijhzEUluijiC9I43stRPmbgmBjMt11RBy8q4E2XqYaY8qBZrGO+B1oBMykYkNxMbzmfTRbRHWx091Xo/gn3SwM9AUEqzvpm2B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160111
X-Proofpoint-GUID: oW6POiDKnXlY8WgMwA6IpEXlNXzhlb1J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfXxkLdhW95hJET
 hTElbDKY1Oto8/lCRvcC1Om/5dhiaDgjSTqq0HFMKZBPj5Hz7VNypJjA2iVzjcy7kLbGzGg8EFB
 +r/t/j4a2K4RU0RUwIntPD9vs15oIbOpp40OjxgOMUd+UXZviBw0ruIvZG7KpRt6wB7bwcwQZxl
 i/LyDyc3STdwNMo9h9rXz11nr2LBvMDF5++qu0XWTTUgdG2h0dAWAP5j9UPXpuqj+cwuYV+7fIK
 3VKSnDRqrjCsB4LeA7cxwiJV+mWSdNz40XvqyE9MHm9+LD/0rzcjY6Bt9KLqugJImatUQZ+/0z7
 tnG+dIW4vILjKRJzC1ljHy3idMZOR4e+rhKWWa1uYGmJWBanHqkZRUFJbDBAkzXyN1prPt4aNeB
 SJpRNejPrLdpXLQCJIPjSse8I2hBc5HokBxSgzj1E5aaI3hlrd2GtwwuprLZI8VpwLHEb653pef
 rCkqR1UjCc5JSmVe2Qlbss/RDL+fNurSt/H74Cts=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX6pIemsMv0y1F
 FkYWlsk53cWTMgJRoAPmAbJwYV3RfIeFyBSRzJGX9huie55KyKPmjfPadjsZ4fG/1AnJ4Nd/d4i
 qUdYUDCI93t3GDyzgWhjKigJvlqZ2ef5EOTrwv3xbxu8h3n8LC9W
X-Proofpoint-ORIG-GUID: oW6POiDKnXlY8WgMwA6IpEXlNXzhlb1J
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaa5548 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=Gdvd-MtEmepGeTVYTdkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107



On 12/09/26 12:29 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> [ Upstream commit 075d2c32353ded0fe5f3b62f4aa4e98dccb3fb29 ]
> 
> file_read() and file_size() use ret = -errno when
> dso__data(dso)->fd is negative after try_to_open_dso() fails.  By this
> point errno has been through mutex_lock(), nsinfo__mountns_enter(), and
> multiple open() attempts inside try_to_open_dso() — it no longer
> reflects the actual open failure.  If errno happens to be 0, ret = 0
> looks like EOF rather than an error, and file_size() callers like
> dso__data_size() would then report a zero-sized file instead of
> failing.
> 
> dso__data(dso)->fd is always negative on failure — -errno from
> __open_dso() when no filename could be built (e.g. -EINVAL, -ENOENT),
> or -1 when do_open() itself failed — and never 0, so use it directly
> instead of reading the stale global errno.
> 
> No assert() or comment is needed after the assignment: the enclosing
> if (dso__data(dso)->fd < 0) already guarantees ret < 0
> [Namhyung Kim review].
> 
> Fixes: 33bdedcea2d7 ("perf tools: Protect dso cache fd with a mutex")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Reviewed-by: Ian Rogers <irogers@google.com>
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/util/dso.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index 654a233326848..266f3b0a3a54b 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -963,7 +963,7 @@ static ssize_t file_read(struct dso *dso, struct machine *machine,
>   
>   	if (dso__data(dso)->fd < 0) {
>   		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
> -		ret = -errno;
> +		ret = dso__data(dso)->fd;
>   		goto out;

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.


Upstream prerequisite code:

     if (dso__decompress_kmodule_path(dso, name,
                                      newpath, len) < 0) {
             errno = EIO;
             goto out;
     }

Downstream 6.12.y code:

     if (dso__decompress_kmodule_path(dso, name,
                                      newpath, len) < 0) {
             fd = -(*dso__load_errno(dso));
             goto out;
     }

Downstream negates the custom negative value into a positive pseudo-fd.


The new callers return dso_data->fd when it is negative, but a 6.12
compressed module decompression failure negates internal error -9996 and
stores positive fd 9996. The open path treats that value as success, so
neither corrected caller error arm runs and an invalid pseudo-descriptor
is retained.

Upstream prerequisite 1a5f9334a45a6b0c1cd7341cc72a3b87adad1d27
normalizes this failure to a standard negative errno. Maybe we should be 
  adding the 6.12-equivalent fd = -EIO adaptation before retaining this 
patch.

Thoughts? Also, should we skip patching perf completely on stable trees ?

thanks,
Harshit

>   	}
>   
> @@ -1086,8 +1086,8 @@ static int file_size(struct dso *dso, struct machine *machine)
>   	try_to_open_dso(dso, machine);
>   
>   	if (dso__data(dso)->fd < 0) {
> -		ret = -errno;
>   		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
> +		ret = dso__data(dso)->fd;
>   		goto out;
>   	}
>   

