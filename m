Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E99839023D;
	Wed, 13 May 2026 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778674346; cv=fail; b=RyxfEM3oubyAdQL1W793V4AMIQmyyyPdFW9QhEyric6b7MzcW/kM8QtkgVUK8Y/MDFQbLA3uV9NIj5ZHEJHQ8//5mwF2p8Q+l4gZMUUeOYsGDZefiAwrW2Z1JPfFKFN56tl4Tc9YotZ304AHWPRuMQvOH6XQ0rjC/raxsTmrbek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778674346; c=relaxed/simple;
	bh=6+qFgbsq3ZFmIaZQO9QjggsQMCe1E9EXE1cGuGSw9ro=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U3xtjJeG3ynZWrRznQphkAQVIRpNsR8cTWKYI7LmWMsBBH87KBeTDTePcewJADIfAbM7N/t8XM1t65U6WijnrCNaScXPgqVk32XWIXkjXqsagfrlMO3RBPFS5jlqZBA1MBdEr6mj9A3f7Ic7fErLkDtClF8dhd2mpFWyVO+OgKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hB7RGBI5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=laQfrc8G; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hB7RGBI5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="laQfrc8G"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D7OngX1161239;
	Wed, 13 May 2026 12:12:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+wTSqvuO5wc8qt+bj3L15ZJxIvBGyjYN7xD+OAjuLU8=; b=
	hB7RGBI5rLLJx1w6NJD5XUZwqkcYffDxV/UZ9G2Vhv7xb7sUDLKhLOSSSMI3FLoV
	wV2Gk0351MwMNqktFrk7BYKohjpRsZGyqryorfHPCwNBNC+Fuk8CAvtq0KRyhpn2
	0hoLAYTW3DeKRYRP74ee20FoSi77avPmPX0GzaWYrGXwnMx9qj3Ho9yBJIficmc9
	kMmhcTPNooHbQw7yh2XKn9dBkY7sgstQf3rH8KjVKkP/HvuTeAQq4hjrP/cM2t6G
	tlXUBHbjhhbZ1iJgy5beslu+ayRcnHcz2n94/GGaH71WsEy8iuv0DC7sn5kus0Rn
	1AUwjx0LbuL0B8MGr6662A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c96s2je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 12:12:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64DC9viF012307;
	Wed, 13 May 2026 12:12:15 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011001.outbound.protection.outlook.com [52.101.62.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e3necm09s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 12:12:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wKsS9EUiml++gJn3Kz/2FcWIBQjCuxK+r+fVn2ggzORkABOVkVaZ1KzPpi2Ow8m3Db7prKwcdCnM33aQy12rCZwejGjDyjKeXN7Acc38nW9Z7X2Yr5b57aDhcboaAQ0vIo3+QUKKx2+qk/VLuUfGMBaYm372sHJa009WvdW/qbQNpuvBwc716LtuzuDERLgd0jJsO4fdVHvhpsDafgorEwHIV0zj+dpvxkLMtk3nppz9hfrj7noc2qATjpS1l9APhZO3NyTilCZDR34RpyTpBL5ZaZoN9/Q8nIsPuvVLYHIUJk2izA7Tqlv1vpGrfJEB8a3X9Mrb378C/Ai7MHR6Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wTSqvuO5wc8qt+bj3L15ZJxIvBGyjYN7xD+OAjuLU8=;
 b=HEPwpfgdj4JTmesxcegikT5zTo50itL7v5iw+sYAvnh04MLFSC0mTJ2WBzJNGpBCeaSsFj6+FV7lHqExmSmy3qrTfbfpE7l46nZAVt6fm3COp4RcQZwCLv6JVyLw3jJX33RMFfb21cu3+hfLyRuO0X0PT2Xkh8ClfIPYSrS+EzyEUhBRoQxZKnyka5DznXOJ86a2B/+HhfNgYbiwFPefPeRJLcLkqgTwUz+j+RU7qFBNB3M6l40ZoH/TNPlIZx/1LZL+iuQxbWkYNBovBIjE+keF/UtKnNQM8AX6mTzQo3T1TUcXu7+jz/RyCFljlGD32XaGL/RK9xHlj29ip6iI5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wTSqvuO5wc8qt+bj3L15ZJxIvBGyjYN7xD+OAjuLU8=;
 b=laQfrc8GcBydTR/MILvHnOk1TADrWHxS88ZYNWuLYA9vmjulXllyO/rabntiZFnYwdlbc879cH42REklJ/X+N0lVSsekULs65Cjgm3nJ4gxrMRMXpDA8g3A5YwB3trWjZzFCKGiEKVSILvJlUBRWIE2WsMvDInDAvfd2bO7yWUA=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA0PR10MB7547.namprd10.prod.outlook.com (2603:10b6:208:493::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 12:12:09 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 12:12:08 +0000
Message-ID: <1577a01a-f3de-4ab5-b4ad-b653cf4e3fa2@oracle.com>
Date: Wed, 13 May 2026 17:42:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 190/206] crypto: nx - Migrate to scomp API
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        Vijayendra Suman <vijayendra.suman@oracle.com>,
        Sherry Yang <sherry.yang@oracle.com>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173936.892132003@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260512173936.892132003@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0009.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26a::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA0PR10MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: c826ce21-543d-4810-9ac8-08deb0e8db12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	c0a9a2XYwSX+Tt6hSy82hqvAVZqfUSOl9Uz7BpLJKvEyFZrJSus57i0e6tThaNW+P7TnSfH8vKH7qBfRzbghtL57MeSoeWkG+TfABGCKiZyxglwd/pWd5HxQCOhPhbPDWbhtpxMwVm1ePhrgtxfsX/acbR66alwKgDjTagkPT0LkkILgmPQFzSJ++arcNWI+mH8Erzj1hHJJBDkP4Wd0fyQlL17wzNmeumhtdwzd6i8JyuTzUzei6/fsTymMZDHRuo9hwEVOwsrAI57RKQgVtSzf0FXbcfAwhNsYtoNn77LYIvpOLD4FrEWQgY6WKW0MwLAx6gSXLql31v9Fi3uv2rkFjxsMVRwIzohlIaSRjC+seueZG01ubKzamMYMk4deCKqx0Er1kE4VmswBtofPq6YinF2xkplN2CTi3AZ8UjiNeeJxppE8l4G0kdJYFAnINh+2dZq4RJz0twQ300XzT4R5nCVGE09dJX2uEW99mmeueMnuTLhmIZEd/dT9Pin633O+xV8F/c1MwiTnjHDsAlAbj3WtJkcdP9k0oQa7uL3rhwWEeLPS6TOVR0wu+9sCh0r+Qyi5cU87iYDCucbV9eZtaOGfK5QjePoWesMa4QB1FAmoskv+GVa5oGNtUC3swDooTyEB6Mr1JHdQmZ2U3PrtIiGhbTpMjAwgEhfIoRlWFJsvYi9qT492Kj4kQaN4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3orN2JMU1VqeDJmSGJHcVRGVWkyazZEQU1xSnZVOUpBd0RVcGlkUEpTcGdD?=
 =?utf-8?B?dWRFaE1sNUlMS0dnby9HcU9yRWJQSzNUU2hKdTNEUUQ0NXgxUWl2OGlkVkk2?=
 =?utf-8?B?VlhlZTBaT09pdUxUWnVPMTVFaFVBVlc2TFhHWDJNK0EwUW5KOXdxYjg0VFZo?=
 =?utf-8?B?M1JTeUsxSHBwcEw0RUNIUis5UkFYU2RaVTV4TlJDbmdINC9lQ2tvV0Fmai9S?=
 =?utf-8?B?MU1MZnVlbnI2alVZTzNRekJvYlFUTjF1dzJyWWN6MzJ0STFJOEdGZXpLaVZl?=
 =?utf-8?B?U0VxUk1pdXJ3THlhNHdDbjkxM21xVjdzSWRCOTBPOGFETUpEdkdRN2xXZlRz?=
 =?utf-8?B?Ujhaa3ZoRFgvSGtrZklTVEp6TnRMdUFpMjl4VjY0SFZ3ZG1XSHkyU2RHS21n?=
 =?utf-8?B?ZWVxRXRreGZOeVB2T1pLZlZZTG9vUjBkdVhneUkvUjlxNldPTmR0NUkybkVl?=
 =?utf-8?B?eE1pckQ3U2Fxb0k1MUJtOGQzbFVSWHZtSWVrUWszbjlqcDBYdFR5bThScEVj?=
 =?utf-8?B?WlczZndkZFpTUktCWjYzWXFMQlhLdlhSRCszWWRnUENLb01CblQ1cEpTN0U5?=
 =?utf-8?B?MllnYUFMNlpCM0NWN2lUNHFMM3M4VkZWOUNTdVBSak9jYnlHN0pjNVI5dklq?=
 =?utf-8?B?ampCNGt0a0UvOHdZbTMycXlJc3VJMnh0Y2w3dVowbGdTRXkxWEVOUXRtTEpl?=
 =?utf-8?B?WGpWUnFsUHkxczZUQkxtWUxEU1RxRW13YmNXeStEUFBKZmpoTndmT3RGYzlm?=
 =?utf-8?B?RkRZVjBvVG83RkpWK25DcU0zMmlKeUZkUWVQcEVhdVQ1ZUVvQ083cmpJKzlp?=
 =?utf-8?B?NzJyZEJITmVzS3J1SEhrWHI2VGZkSnczeGxaWEd3VklCZ3dKems1cGdibXZQ?=
 =?utf-8?B?eGpyN1dOa3g5NjMyWFFNS3k2b1FGUi82d2d2a05JSUJ0bUpCc2FOd3FrRXkw?=
 =?utf-8?B?WjFtNGlWUW1rS2pQUWtkUWVyd3hHZTZnQytxNHhUQ0FZYmNoeG00L2k0dkFp?=
 =?utf-8?B?Nyt1L2hPemVQdVBaK3owcCsrMTFaa0RYcmlhaktEZ0RYVTdZL09TQ0RZTWlE?=
 =?utf-8?B?TFBEcHJ3d3I0b1JvaDAwdm9nanVHdmI4anNIZElHSm10eGhXMmFCejlyeWhN?=
 =?utf-8?B?S1AzVDJiUU5TR1htK1BnVUpJNEZzblkvMjY2UTB4UUZJY25YS2luTWExZ2tC?=
 =?utf-8?B?TDBBTHBJVFhnSlVpWDlzWStnQ1ZyMEU4ZVFzZkJBSldoOWRrSnZ1MC9FYURH?=
 =?utf-8?B?dW5NVW5RMkZIMkdnV0d5OFFZcEMzc1RSaHJXQXR0azUzVVVVY29KNk55cGYy?=
 =?utf-8?B?UzBiNVlqeWZES3dZU3hKcGdsUDJXdGdzOTBqSFRLa1FZU1RTbGNNajZPM0s3?=
 =?utf-8?B?UW14bkRpOXQ3USt5VWJlU2Z0RHF0L2VXNElNWmRvOXdiRWl3QXdkS2pHY3Zi?=
 =?utf-8?B?cUtmRmhpQzZrYzdDWFhFQytIZnJvaC9YckpBNklEc3ozVkZGenR4d1lNWUxz?=
 =?utf-8?B?ZFp2ZEwydVR3YS9wNVFkcmNxdEF3Z1hKdDVmdXQ2RGgrbEkwck5KMWc1Umdj?=
 =?utf-8?B?R0JEQk9HQVgydlFOVjJ4MkVWR3pITnRMWUdUNjBzbzR5d2pqWTIweWZib21l?=
 =?utf-8?B?eUVsb3VmZWF1NU5FQlVabit5eXhoU0RTQThPK1NROThZNVB0d3VpZ0xLaUlv?=
 =?utf-8?B?SUxtblFrbGU0OWFRR2pTalIwQzZpQW42akQvRUNPZUNJVkdqN3AwVEdXeEJR?=
 =?utf-8?B?YW5MSnFWU0FCbmVnWVd4eENOSEhWeHA2c1dyaFZna0w1a24wcjExakErUUpR?=
 =?utf-8?B?SHljMkhHaXFjSi93SGkvdlk1YncrbDVoT1pIUlJNOWw0SkN6OGJrcDRZM3NM?=
 =?utf-8?B?TnV2bUVQVjNseWdwZy9tSExobjNjb21ScE5wK3l5a3l4YjdkY2IrUGxYWUhO?=
 =?utf-8?B?YkJKSHZSR2haUEdnMWNVbFhkV2tqbXBTaWIyR0l3RFIxeXVEUW9JTW80K3o3?=
 =?utf-8?B?eDRvc1ZrVFF6YjJPMzNQUDcxaVhwaHRSSFBpb2RGVnlvOHVmaElRZ3JVNmJI?=
 =?utf-8?B?M0tXYUt1Qms4Sk9SWHFwS3pYVm9tcXNkc1lIdUxPZWg1Z3crUkFhVFFZeTB2?=
 =?utf-8?B?VVpYT052WEFnWitIdU9xTVVEYmRZd0kvTElWOXhPUEJrUVROa2thdGJ3QTBC?=
 =?utf-8?B?Q2VUUS9VL3BzSmQ0NkplZmxLNFVNaHdyV1NuMzVZSG1YZ0ZnK2xGUW9tL200?=
 =?utf-8?B?UjByZjJFTjVJcFk1T0tQT2hMU21ySW1BMFFSYlo0TkFueXpnWHoyS0hrS2h4?=
 =?utf-8?B?cGNnd0lvMHUybjgxNG1YaW83Q1dyYWJ3c3hvM29UUWlyMWlMbnJGMU1sVE9h?=
 =?utf-8?Q?B5i8mcY7s0KzmqAq8RjMi2yK+B67Frq12KGlw?=
X-Exchange-RoutingPolicyChecked:
	fkZ1kvpWrVhWClbUOp1Hxnhk1NQFuclwJl/wkQEnU07m3k+G79TqFMDb07bCJ0+EN82GeDg86dQthCO7zXvpLFLT1x2/mcgMby3Ih2jSaIredHiLAI3Kh17jOvdCYSgZoCu4IHN9BGxXlRjNla/0COJVp4quhNJOWCyokXjdMbtbdleCZErzQS8k8Z+ch8BIMWHJ0Mg+wrcyms0cbN1x8p1xIhR2YObalinYT1eiT0FmuLO0LOrRqc0a+8Jg1U9wVyEei+ftxMZ9+RWL6TGJWJVxxTixZKabkgz2bPuFo0tdzja7H8FYnnTVL8JOLnzLdR7pZWLFuJtVDGgM3gcP+A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rBZlBfKGqqwzzU+mUPsW907J8qfwz+WrZ0MyMUwQuMsu5AdKeexXEhW2C8hUSHUDqkRSNMCSBaqQBEPS3arAuMWrkY8iHhkjCupdRDKkgAd1zgYcGXqtFgy/FRmNHF3MeKDZIWYZhYmp7Ui6r/o1TTE7k9hVBUOja7HH8Qa2MWHJQ3VDYI0GOG4U5IgWASjTJeJVtbQfVAhAdLNGz5S28UGwMPKn6It9yJ/RhF3OJ3XCbp4mP4iYt9y5thrF46nGPJDtwft7+YrS2qI6nL17/s+Llf6PPwwOtTDx/qRgRgYH9m9uODZXRKETTV619GBto2864jWsIe6C67vlZhUT1Wy1XToVXVWH07dVUWDmHCViR4pPrZsH8RSYhq129bJHzQ4Zjge7iIzXaUNtRAZXTCA7fCTqa87cJWZPLFUSajiXJ8qeYrn02Y7RNCVzuX1T/0gYCZu3ZGY/M4yqla+Gw3aGQnEgVGOKwlUIlw/2xrxGOqog2Yo96kDrWyIYw/6E6Ux0VuCE2VdFLqaiUexlBISvcQLBrdS6Ddroct38Vn7hPxSb6EY0TD9XQtt5Qw7sNJt46FJJ4qqN4FrgYRBEX2Rs9U/GHKlDcrSXKFk7+Ig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c826ce21-543d-4810-9ac8-08deb0e8db12
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 12:12:08.8566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szVNIFs7CAKamhsFg/VhfETqBnU+Li/nnBn+0dzordq6TbTbRqcWWdpwWbMSf0EBYybLxVrPVlT/poar2Kior7+ll/liCvWQxjYkxYXzRQcPdM0XkWGIv9UQWuuN+gYN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605130127
X-Authority-Analysis: v=2.4 cv=bbRbluPB c=1 sm=1 tr=0 ts=6a046aa0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=FNyBlpCuAAAA:8 a=ag1SF4gXAAAA:8 a=VVRGZuIK0JgvZ6yi4y0A:9 a=QEXdDO2ut3YA:10
 a=RlW-AWeGUCXs_Nkyno-6:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13839
X-Proofpoint-GUID: JqiALsDHZRxidf3cjcEZnqpvwCKyX_YM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDEyNyBTYWx0ZWRfX9bvsEThHlmCS
 ojR4UKs5MOM+aqcN4NwHORCNztL+4JMxE1QnvICweKeOCNQTmV577CTL97KV1nFdZfq7Gfm9md6
 5wGu3PCW2pqOGziD4l94vEaunVrJVp+BgQx2mrUW4bNT/rcCGGw/ODLSoMVJW49clEF5JULKbkk
 WeZBomc8fF0G5qIXwG6+2oZUrGY8crn/IVpqonpB01o9f+cqWNAZxOekhecEdtmTM4WWUPprMGH
 Yw6B3iAcrr4X/cVgJl+RoAXTXfjtlCAC6tO6KKxOrm+Nj2hEDqhaPzG8b86PN7UH1BL/OlMWc+p
 SRxtLZ/ej6m8yYittzkhO0md9ne5fkOObKN+eKLlrDRXBihJqxjPoOlGZUkQ+nBl2EMtp5R6ZEw
 GBGyLoIjaZt52CxOkn1aETq28dlMDzUFr9sUkNQzUIbDoeom4IlxIOBU/dxSTwClaRQmdYw2uki
 i2a0umN4/8O+RyMfvnW8Irjgmpiq0rArAH9KX/80=
X-Proofpoint-ORIG-GUID: JqiALsDHZRxidf3cjcEZnqpvwCKyX_YM

Hi Greg,

On 12/05/26 23:10, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> [ Upstream commit 980b5705f4e73f567e405cd18337cc32fd51cf79 ]
> 
> The only remaining user of 842 compression has been migrated to the
> acomp compression API, and so the NX hardware driver has to follow suit,
> given that no users of the obsolete 'comp' API remain, and it is going
> to be removed.
> 
> So migrate the NX driver code to scomp. These will be wrapped and
> exposed as acomp implementation via the crypto subsystem's
> acomp-to-scomp adaptation layer.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Stable-dep-of: adb3faf2db1a ("crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx")

Note: this is pulled in as a prerequisite. More comments inline.

> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/crypto/nx/nx-842.c            |   33 +++++++++++++++++++--------------
>   drivers/crypto/nx/nx-842.h            |   15 ++++++++-------
>   drivers/crypto/nx/nx-common-powernv.c |   31 +++++++++++++++----------------
>   drivers/crypto/nx/nx-common-pseries.c |   33 ++++++++++++++++-----------------
>   4 files changed, 58 insertions(+), 54 deletions(-)
> 
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -101,9 +101,13 @@ static int update_param(struct nx842_cry
>   	return 0;
>   }
>   
> -int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
> +void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
>   {
> -	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct nx842_crypto_ctx *ctx;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return ERR_PTR(-ENOMEM);
>   
>   	spin_lock_init(&ctx->lock);
>   	ctx->driver = driver;
> @@ -114,22 +118,23 @@ int nx842_crypto_init(struct crypto_tfm
>   		kfree(ctx->wmem);
>   		free_page((unsigned long)ctx->sbounce);
>   		free_page((unsigned long)ctx->dbounce);
> -		return -ENOMEM;
> +		kfree(ctx);
> +		return ERR_PTR(-ENOMEM);
>   	}
>   
> -	return 0;
> +	return ctx;
>   }
> -EXPORT_SYMBOL_GPL(nx842_crypto_init);
> +EXPORT_SYMBOL_GPL(nx842_crypto_alloc_ctx);
>   
> -void nx842_crypto_exit(struct crypto_tfm *tfm)
> +void nx842_crypto_free_ctx(void *p)
>   {
> -	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct nx842_crypto_ctx *ctx = p;
>   
>   	kfree(ctx->wmem);
>   	free_page((unsigned long)ctx->sbounce);
>   	free_page((unsigned long)ctx->dbounce);
>   }
> -EXPORT_SYMBOL_GPL(nx842_crypto_exit);
> +EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
>   
>   static void check_constraints(struct nx842_constraints *c)
>   {
> @@ -246,11 +251,11 @@ nospc:
>   	return update_param(p, slen, dskip + dlen);
>   }
>   
> -int nx842_crypto_compress(struct crypto_tfm *tfm,
> +int nx842_crypto_compress(struct crypto_scomp *tfm,
>   			  const u8 *src, unsigned int slen,
> -			  u8 *dst, unsigned int *dlen)
> +			  u8 *dst, unsigned int *dlen, void *pctx)
>   {
> -	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct nx842_crypto_ctx *ctx = pctx;
>   	struct nx842_crypto_header *hdr =
>   				container_of(&ctx->header,
>   					     struct nx842_crypto_header, hdr);
> @@ -431,11 +436,11 @@ usesw:
>   	return update_param(p, slen + padding, dlen);
>   }


I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:


Backport commit: 481ea90e8326 ("crypto: nx - Migrate to scomp API") 
migrates NX 842 registration to the no-tfm scomp API but 6.12.y still 
uses the old free_ctx(tfm, ctx) for freeing.

The required prerequisite commit commit: 0af7304c0696 ("crypto: scomp - 
Remove tfm argument from alloc/free_ctx") which is not in 6.12.y:

   mainline        : v6.15-rc1 - 0af7304c0696 crypto: scomp - Remove tfm 
argument from alloc/free_ctx

it is only in 6.15-rc1 +

So Upstream has:

struct scomp_alg {
         void *(*alloc_ctx)(void);
         void (*free_ctx)(void *ctx);
         int (*compress)(struct crypto_scomp *tfm, const u8 *src,
                         unsigned int slen, u8 *dst, unsigned int *dlen,
                         void *ctx);

Downstream 6.12.y has:

struct scomp_alg {
         void *(*alloc_ctx)(struct crypto_scomp *tfm);
         void (*free_ctx)(struct crypto_scomp *tfm, void *ctx);
         ...
};

.free_ctx = nx842_crypto_free_ctx,

void nx842_crypto_free_ctx(void *p)

Given that we don't have commit: 0af7304c0696 ("crypto: scomp - Remove 
tfm argument from alloc/free_ctx") in 6.12.y it feels wrong to pick up 
this patch. Thoughts ?


Thanks,
Harshit

