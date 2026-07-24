Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD62931DC
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897550; cv=fail; b=aTf3Jdsu9iRIbjNP4jmQ+Q9cDG8MSI5eE19ofYxVF/D+2svrg7NRBknoEJH3ll+hrXh/FVbJbmK+ISNNw7muvTavIW0cG6WHQ827weZmPRbjPSAbu14TkK1rHOwyPUWYfT5WjPzfUpjujNUX2xrfd4K9g7LIUEr270cW4N+CS4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897550; c=relaxed/simple;
	bh=TncbwJubo1lUwCYPQWzEJRBho6BmuKJO17CutCDOo2c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tiSiw5xDVnPYHd0uqsmUvZW63+TapNIHKiGzTBXE358w7IbZjBoTrQXQYeNb2kHJ0MgVOC6DjMHejsh7Qig2t8skamJo64dOvdyvovWzMmLkd5fBtM4KlYNxS4EDpaoCNmAPAB0/tTDyXvpKvomcQBy9tIdJp2RnYgLKYElnR+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gZB/LZ03; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wTY+tw/I; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gZB/LZ03";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wTY+tw/I"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O89nMT1207874;
	Fri, 24 Jul 2026 12:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U9B7Kz0ueT8CGAP09oELqsaZ4RP4lxqu5I2+K7if8EA=; b=
	gZB/LZ030K+aZ3m/waE1tkofhtN6l0EWRnMY7kCD7PJGam4U51QdBbGlbYlJs2AM
	y7Sg7RJZzrumUei8gfw8GdwznjuSTznHkK86EZcchO42WQWFT4PIM1pZc/+vJLZ/
	ysdJhFJYOZRfbKcp5VqBHCEsBZ9xLFGy84iyeGHY0Lj5orG9OgOMJVd+/ztX/3Bs
	sMViRvE6YcgjaQ/jSOpGQ/7aP83iJwZyhMAv4GxXxLT7FKw6TonruuuPlOv9swRM
	pPDPWS6ksQh7xPESm5eANZys3q3/3ceYA8KN+FqTPgsbFQMkrRJxDzdIL777W60/
	pUUGQ5xGkeSvfYxelpMF7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q8h86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 12:52:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OCma5c012871;
	Fri, 24 Jul 2026 12:52:16 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxg05tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 12:52:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E7hBTA2dcgxLH6DB5kkaY2krc6JLvDKhdpswHvEPcbf7I1bCRQIUFnseE11IQtt2fbWKGDivFqZ5DbYYzfSRUKg/sqwUV5YlIaUyzs3GEZ4tSSkO5pfiPin6ECVgKyXFiDzabYQgKUkvqpmqiw3WGhP2iK3q4nNl9p4UJ0nzGAWgbCdG8Fx2VmAh2+I7JqPl2wtQV/nLw6RNqcd6kFandm0s00WrgvXemoSrcfqbMl1M8jdvmr99FWXQS5EgzJzV7B8HXFhaHnnOva47RtuU8eZVLpe60xV1p8dok/gl3MF4XApyv3feUFvk8LZHdHOuotcCysKk33GYPFdQj1dJ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9B7Kz0ueT8CGAP09oELqsaZ4RP4lxqu5I2+K7if8EA=;
 b=ff9hXYP/uFP/Gi3IugvuQmSe9o/Ug2NLd1Ax+ihJGv4IfXZ6o8wFHhqCg7TFaMrL4uP48epEKHDzSYSeSOzafx5w6LwDGF0BQg1cPV2yzK1aneaftlTqfzkJcrpU/brPcwd/OrrciPAtJP0eUNpuBCPR3rnWIbCkqA0cuaQIxCaRKiKpXc7CsOWEFmeX98sHts+qn/Bnj5JN1IXFQpfBtnUbSpIC4smEfX5NCX1Fr5V0vGm/wxnGhdApTgtfee/o/fUXVwZTfzVkNyzMCguug+c+mF5pX7pIjgAyrAxaUPwepmd5JQKF4OC92Vj6P7qnvFci4x4cZiQY0cFsAlzxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9B7Kz0ueT8CGAP09oELqsaZ4RP4lxqu5I2+K7if8EA=;
 b=wTY+tw/IS+m3Oic5hjXbdMsUloDuUcMywj9Xpc1/tc/dnTSBBlNwHnxtU6CSDUhxu9f3ZICRDTxfebfUKq/q86VIaz9sd3dweuSnEM1vtoxXnfVal6LWQ9HE376Oajr1YFBul7KKFJfEitx8g+hIr7jj0iajGdMF5Ezn76IQg8Q=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by LV8PR10MB7942.namprd10.prod.outlook.com (2603:10b6:408:209::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 12:52:08 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 12:52:08 +0000
Message-ID: <7ad0197d-d173-43fc-a71e-23f2c2b31161@oracle.com>
Date: Fri, 24 Jul 2026 18:21:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0222/1276] sched: restore timer_slack_ns when
 resetting RT policy on fork
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Qiaoting.Lin" <linqiaoting@xiaomi.com>,
        "Guanyou.Chen" <chenguanyou@xiaomi.com>,
        "Chunhui.Li"
 <chunhui.li@mediatek.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152451.057873718@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152451.057873718@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::14) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|LV8PR10MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a8aa04-36b6-4450-347b-08dee9825ece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|5023799004|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PpA/sud+BXdjCUeQKA34vNbtVBGA7z86StbMTk/cCHciFo6pYBgEnHeu/wTYA0vknKcIELtbfY4PJcfChIA4rQxG/0zUe0uVg//NmrmgmSD1u8p15EE4o7ngMUZ2lMfQBWBZg2zPr/hfO8tH/IU48QUUMZ0KTlGMw/zvCIV1AM2LGsj3pbwI7Y+2MbnPj3jNrl3ivlbEP//ZiO59nZzo5yTM4ArXqufdiPik86jWkMAAKJDMznUZaOeyp6XUGXGu65KdHW0u8ZVKC0w6iz94tMBDwYVB4TUe+OqZx5nhsC0k7fuc4kamx1T2Kc2xtjbGwD7DhlBOveqXRv8nEOFSNTutHlsujnfVuJeese8wSPtZ8jJlRt76BmGbLdBR3hjBCy7X6FraorVd3WA1rS403wj8iQItlTTD+9helRWI0cuGqyfEqzWjA6QoxdyewM1cez9fb0Q7S5a0HuwpNiAaMT/0PbTdVrU42DCgHSw+ouQTtKdMBKt0f/Z6DlamzmN3lh3sDXoGYBW6h4biJ7V4NAaK2CxWDGEL2mu6oGTf1uO279LgGsqXl1iQ67d8NNPCTzWmj6WFDIKLcv4tUZLEYhR9EIuaKOcXW2qLygiu+cy2zXesMaCZZ8fAppsFmiho
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(5023799004)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGxaakQ1VGFtdDgrdU85Wms5RDVzYmRZUDRvRENuV0pvYzNza0dzRWEwTm44?=
 =?utf-8?B?d1pEamY3N1huMVBTanlVditmc29CNkx4SUZ0N3poV1hUTVhHZCtvUyt1YTZB?=
 =?utf-8?B?VENyWENRVDRCRjlnaFdYaFY5THl3RVlWTkdGR2t4QnZVUitFL1VqWG85NDcz?=
 =?utf-8?B?WENoL3J4blhKaEVTbkJHUkVIUkJadVlMc0kyN2Era1AycDRFUFNLc0dCSEJw?=
 =?utf-8?B?NXBHMHFtQU95MXJIQkxXZXZyMVA5dzJURGlsVGpISzI2RkNCQ2dwZGRlS01x?=
 =?utf-8?B?MmFnLzVTTHNmRm8vZWxnNXlKQy9WdGQ3NnN1bHRyMGQyN0crYmxNR041elRE?=
 =?utf-8?B?aU5tbHcrRjFsZ2JFS2tvTEJzZ1JSaXc2MjdVK1lhWUtma0RZZ3pWYzQwVW1w?=
 =?utf-8?B?cFNVNVV0NlBxRlJJNmhvR21ienFpV0J5M2xlRDEwaURxL0NlWEVhK2dibVRv?=
 =?utf-8?B?L05SZE1uaXFtd3JUNFNiZVIvS0JpQ1JnekJsUm4vcUFRRTl3a3Y5YXUrNldC?=
 =?utf-8?B?aE15ditsckZxSDd1TWNlOTNnQ01TUm1RK2ZwSVA2TzFWdGR3OUVuUmM1bU9E?=
 =?utf-8?B?L1pGd1lBSm1lSjhtNElQTDFOdUpnR2VMSndvbFV5Qkc5aVNSSXhjNU5zOEpE?=
 =?utf-8?B?c0dTUnNyZ1drcEZrR01HZ2dtOE9GTHg1Um1KTnBDOTNUQmJObDIyOUV5Rnd0?=
 =?utf-8?B?MXFWREdtbDVib3V3bTVISFJrK3I0ZHVVc0o4R21ZMnRXbHVEWlZNUmF3WGdI?=
 =?utf-8?B?T2RkK1duL1IwZXBQeE5GZE5Mc3NyM1d2R09yTndlcWRGRXJtM1ZFUzhCN1JK?=
 =?utf-8?B?dFZPeU5PeWlNTE45VkNxZ1IwOTRXSHZTcHpKMVhNQUFmZ0pEQmtCd2NWeUpo?=
 =?utf-8?B?eTNtclRzMkJLTU9rQnUrb2VDdlN3WXo0VG9ZNTlMTE4xcFRuM21kZGF5bDBF?=
 =?utf-8?B?ZThBNXg0c2dHeFk3VDViS20zMEVNcnR0RVVveHp4dFpNUXZiR2lWUHRudDBD?=
 =?utf-8?B?bWVrVjE2SkdOYWVVR1RUcDR1bUNCcmIxV3ZtdzdRUGs5d3ZIbzdUV3ducEV0?=
 =?utf-8?B?b1VGOWF0SmN2RXQ2ZXIvZHlzdlI5MmZrU2FGTzIxYXhvMWRNNzA0UEtrSEVx?=
 =?utf-8?B?Y3dLVkdpeUFjSXNMNDc1b0RRMGYwMjJYdVlQM20rVTEwTW96RmEzbUsvNHZ2?=
 =?utf-8?B?dmowSVBYWDRVdHByMlRIL1JYTCs4bmxwOFpFSW5XS0U2bS9sYkhWUThWd2pq?=
 =?utf-8?B?QXljWFg0M3poYVdITnB4UVN3bUpHeG9LajFKTXhDUkVFOUkwVVU3OUZ4OFJr?=
 =?utf-8?B?Wk9PeFRZcEhxRHZlckkzYlJVWjFWNG1zdWtVdW40YTh6Z0tvNFBHV2tUcVNE?=
 =?utf-8?B?QWUvdit1TmlReVYySm41RzlvSHBpZGtBYWVoM3pNQVk4VVNOQkl0L1JBbDQ5?=
 =?utf-8?B?QzloTDlyRFRKZlo2a1ZKZGNZWjNoczMwb29Bdi93SVRQSlJCWFN6SEw5UlFO?=
 =?utf-8?B?RXZIWmVOTDhsOEJaOUF5Y013bnpiL00rWFgxWFNQS05ic1BaRU9jL0hOSFdp?=
 =?utf-8?B?OHpuSnpQaTVzd0wvYlNINWhnaFJRY2FNUS9lNDRGbllSYjhiZDJmdkw3MnBs?=
 =?utf-8?B?aG9RenM3azhDK0MrOTlTZksvOVZucHlaYmViWFZDOUZZUXNwMDZoM2hkTGFO?=
 =?utf-8?B?TEdVMk5MQUJlQkRhcFlqUEZ2VWxaY1hlVHp2V3pLM1ZoTmQxMnRWK3N3WTFs?=
 =?utf-8?B?NTAvSHlVTXRKQ2U2QVpzNkErOXJSMjhtUXFEUFEwMGJZUnlKeEE2UHhSdmsv?=
 =?utf-8?B?ek5lMkNqNG84bFQzV2hlb0lBV0RJeFdkejRHUUJnWTk0aVJ0THpLdENZbkF6?=
 =?utf-8?B?YVM5UlV3dnhaODluNUQzTFJYMitINklESjhaQThzR0pJSFFrb1VybWcyeHpO?=
 =?utf-8?B?dndqa3lrU05pWE9CTkZtaTR4MDRoNEZHTVNaRjFZWGZUZTJVdEdyUlpLbk4z?=
 =?utf-8?B?c2YvMm9OWUZ0dDdsUkZqdkdlSHpJL0N2RGxaNXRGeGFBbXB1dTQ2aTZMZy9J?=
 =?utf-8?B?UnRIZngxbkN1Y0hkelJxTlk2UDVhWEtCYVMvd3k0OVZPem5sZVY0NGZwMFdx?=
 =?utf-8?B?VjAxZVd4dnpzSnVldmFhTW9pWFlzUll3T1pWMllyUzJNa2lINGMvelV4dkNR?=
 =?utf-8?B?UmpBTzJ3ZDBabWRuM0c3MjFmK2U3VFlqTVAwV1RGT1JraFpOOVNWUnJ5Wnhh?=
 =?utf-8?B?am5qUjc5Sjh1NVhxVmpXM3V5QXZmOVVRbWZERmNKRjd1NkkrQWFXU0FINTdi?=
 =?utf-8?B?U1hpbTZBU21yQXFyNG5KTFBmYWVkc0poQ0l3MUtVU2UwNHlFTnRVVkFBV0lq?=
 =?utf-8?Q?5wIaETnSdnGyTQCQtUBA6S+49EMOoQkzEHZNg?=
X-Exchange-RoutingPolicyChecked:
	YnjxMWLOuv7uQITBiDr9qD6YFoX4VgPbLdbrl42QwO2KcmZDhbKQKqVx5NmpSMaZ7vk0N2BKuavsYPW1ZJDfpCPY+CveB5m/7zT7BWTJZclHB9jwUFwi6oLnB4jOw9SHvuZu1h4AhFCimxXEcTpVR7NeYaF2cAfctlzrUi7OH/KQBI1t37LoasEkeYTYBodAdODyKb0cOLYj01+t5KIiVnKeM5PbYVktNFAEZd0H6XTKSCx7ECTRyOFHrlirDuY/zsnzniqY/aCWl99hf8FUYXGca77T36qMn7XGuNZxCeUtEuAxoBZ6l5OA0lQJGJ+cmqaQHmYqVgC9VCSn/uCCYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ny+SeL8ROBnXQOjMqG2H1L1XjWFy5d5MdLOZ4+wzVPNeyldL1Qmp5YHTbaoB7QCW2SxUYkl05e6usC/D3Ju7Ny715mFu4xEiwcU12jSV+CczHkH8GGlswT1BdEH9ZLah4A4SiH+Sm53B9yy1Zt/EijsXWWRRMt3DUzvAxIu3niMVDE3D/35tYBP0wg6qHzA9i+fV8jwTG6Plmb9Ru5AcuT7XsMuts2pigyxrUB/vEEELRLTd6UhFrLcIsfWY+XFPkdDbbyC+/jVz649EXXD/LAZxTl6EHRhs1Wvj4OSiyBhY5hEtVZwI/X+/vr5b/08OW6CpameOuCTR1zsNrBqQUTx/xrOxEaieUBtVOkxUGUDdvKL7CpT0Hj7cCyl+WwWiQ9/9DNAhBZzCw5rWVekDZTyD64REPtz2QPOpwUhCzOWZoUcnq8/Bw1Z9ZOTxOMiFRS0YerPcTfbdWQyAX5vS8FWZIn07Ezmv9NezlcqK6HK6PQpfDEpz9Sg7oBCO4PPVWyawx+MpvLXkIzJtC00Nz6ZSwoOOyOJFqIQZl72Yt87WgFS+areJbgOKRYXE7a11qsMPvdydOiSwmofOS2OwISd0yzw+AEP/oygo867DG5w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a8aa04-36b6-4450-347b-08dee9825ece
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 12:52:07.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bs2cjR1ulaNNerh7W+gyt67LJ/zFWvTp6UrJ5tC31ujsDb47TTopT/1Mk3t9EjioWr6qYw9fj6NKFYcOfOjnGGm5P5cf1NoxoCDjoPbFkiXmJHNc73TJfKYrNRG0+Oq3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607240116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDExNSBTYWx0ZWRfX0nedOCdG7W29
 Bait2fwWTZKy4jRrERlbNVuznergOwfkZiKLRwqDiSBqxfNc1+xBhjOjApLWZWairYsjofrbTB5
 F7n5xz7N5VjuYH6s1LTWaGCwBWxI29sPhlXcaGubuz90mjRfJAIVS0OFD3qgkRh59e9rNvg5KqC
 8SYKHeF1PjF4OIg7gBYVc+H/AwInLta4SJ2t1ZlI6lEV/Q9NMKtMQW5xUj9rN/iF+k4oFScqtvC
 Wb3Rk1OtRSMFa52EkHcKDF03dbD4ravhsQLLFWRVm5cvRFOhLa5uOossPPyJiviN+ku13CkYf1n
 08R0WfS7cerMsBgYAIt1Rx069gska3jTQ+FDPIqqICHo743YS4MTKsTrLkKVrWklJQJkkpZmDvk
 5uH3EuBsPjDMdSqcjTsgE0Oo4JYSJ05G7y1kjGG0tWpcRrP3Y1fKZwNPMlVssnAW8ubNtcHzR3I
 r8838jSR8UNSVDvd8dA==
X-Proofpoint-GUID: PFPVRnEXzFtV-fAhrNzONNLgHkTCmMS4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDExNSBTYWx0ZWRfX/10VclXRja9F
 yd5S2zhF4QgOfagLLZiZGcYU1z1BBuxCPSHKJ/4OIQMUuuQUt05mkVaXPQpl7D38gu+V00upD0A
 lmmGwlxLLlrHncspaUTvrHMxxRNCFHqlU/p9Y+DSW9odIu0ORWTP
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a636000 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=IeNN-m2dAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=mpaa-ttXAAAA:8
 a=JfrnYn6hAAAA:8 a=4LMwG01ls71NsS99MkYA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: PFPVRnEXzFtV-fAhrNzONNLgHkTCmMS4

Hi Greg/Sasha,


On 21/07/26 8:41 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Guanyou.Chen <chenguanyou9338@gmail.com>
> 
> [ Upstream commit 63c1a12bc0e09af7dee919c4fb4a300a719d5125 ]
> 
> Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
> for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
> __setscheduler_params(). However, when an RT task with SCHED_RESET_ON_FORK
> creates child threads, the children inherit timer_slack_ns=0 from the
> parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
> not restore timer_slack_ns, leaving the child permanently running with
> zero slack.
> 
> Fix this by restoring timer_slack_ns from default_timer_slack_ns in
> sched_fork() when resetting from RT/DL to NORMAL policy, matching the
> existing behavior in __setscheduler_params().
> 
> Note: this fix alone requires a correct default_timer_slack_ns to be
> effective. See the following patch for that fix.
> 
> Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
> Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
> Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
> Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://patch.msgid.link/20260522131000.1664983-2-chenguanyou@xiaomi.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/sched/core.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 49dbb52842c95d..ea106403abd86f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4705,6 +4705,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
>   			p->policy = SCHED_NORMAL;
>   			p->static_prio = NICE_TO_PRIO(0);
>   			p->rt_priority = 0;
> +			p->timer_slack_ns = p->default_timer_slack_ns;
>   		} else if (PRIO_TO_NICE(p->static_prio) < 0)


I have run an AI assisted backport review and it spotted an issue. I
checked it:

The original commit explicitly says it needs the following patch. That 
v3 2/2 is "fork: fix default_timer_slack_ns inheritance from RT parent"
  https://lore.kernel.org/all/20260616105654.2451405-1-chenguanyou@xiaomi.com/ , but I could not find a canonical upstream commit for it

I think we should make a note that when that above 2/2 lands in upstream 
we need to take it. NO TODO for now, but a note.

Thanks,
harshit

>   			p->static_prio = NICE_TO_PRIO(0);
>   

