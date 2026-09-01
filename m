Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF90E261388
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 04:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788238648; cv=fail; b=jPH/xT0w3TTnWKu6M17Bex0IIodzySrYhUTrlMlzC/n1ZCJcG8DafjMZZtgiTeaF4yomnLf+yUqoEG+ewFeqdXwfLUvinGoBKLs3W0fw9bw0I34mXdcUYVZDE6DMLtmEc2WJQAqeHI3ZE9MY1BVlx/s+Td0XBkL0qPdPFN6IC1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788238648; c=relaxed/simple;
	bh=DHm4rcl4h6rQOYPrU+kU261Np6BDFgW2u0zZw36fqQA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZtZrv3EaM8YAfZHQb863SR7vnkRO0ETUqRW2Vqmj9j2yN2eY9RjBkIbjeNfVWoRR0gESvUry/Wuo3GZqbzzPmty22+JXDmIpNKRK7AOJ59G87SU3D6tizgjchcZb3AhHl+Z/6PFTi6ZDNqF1Fnl5neX/zYyU+8Ag/zx4AGQl4rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=APLM5SfL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R1JfyRHR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="APLM5SfL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R1JfyRHR"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLC7sT2229490;
	Tue, 1 Sep 2026 04:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5REbQlJepNH9aFOxJpzVK+tcaIfCIcKVZsaGrXL0Kt0=; b=
	APLM5SfLHfcJtqlc1Na15zu9S5ZCHOrKN0LoMujRwv9I4p9NtgO+ysh26ow0Z+vf
	A1a5GlYS5l4bDd36NUHMcFrDhRJ1sDbTt0oU0vUp3dbaW35PZCoQLbRgNR6pRCoK
	gMTPsdDeWcWsuhAFhwkYuDsv2XtrN4qBJBKmyk6IGDDyrOTPksBxw5rguLgaEabS
	8NcTop+a13nwOav6Ks5FMknDJ+GQfY7ab00QF8ZO/N7hymhNXcKYt/PCh4Oz5urm
	yj+CMtqiGZcWgPZJIWey6hMluGKt9HxXM661x6hj7zwFWqzvtnZ2lkKCtdvbrLic
	7bpkS/hwZcrjTU3F6WtUrw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbnubbuvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 04:57:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6814tV39037156;
	Tue, 1 Sep 2026 04:57:12 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvpyt5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 04:57:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNSOMNLkEV/CZY4AIVvr1m3qO4DN81kvz+1BBds9PueJMGjg3wFUb7D7Z7jY1yOSD9s9RWaXF7juKzE8Tqu7TS+JJKOkZ9yGOKo2KTtEnYuyZxykYEsm83VD6H8xMhiK4Ygn0t9kHr72lr59vQeUa6aSZjsVl4aiJBHlOBLU7kCZQKEMTTlSolxf/7qRaOFPlRJ/yvN+H4236XIStZoEhOb4YLjDn4BTaR3t+dNyUnP51XKydwp79pk4dDVYR4Z7df/FIgyPb6e8atjlUjTF/pYMdvlCtAAHo+/a+Bcr7r5KgnPtuSt73VwrTgTkfZfkZhigad+iBOiHOJOdUKsXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5REbQlJepNH9aFOxJpzVK+tcaIfCIcKVZsaGrXL0Kt0=;
 b=OJkYI68QEGpGk/L3hmzqRQqMYaWkqXgRPRlRAIOE7puhooEj7p0ZFTUfFIHIPVXem3XIVEmwzioPeeM77Hyi3IbLQjL5C+8iedAGX4vadrx+V2UlZSupJOLF+fRq3+scC9iK5Y2EbALM0Bcb/aexenkFeUj6k7b1anbJuszUcZyVz5j3/h2Wd8JADBju7fGeMdlIJEqlrsODruQdiLPcr8O7IkJExWRp9NxuYwpCuiRxGkP6if24VRe53O48cvz9T+WqtOIrz/pgJZ02J4mx1UnEyN60rYE13vi9TtrL/4DJ4LzAEmFwkN8XPrczUSE05bVV3xS5VQpPgl8vVFlMRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5REbQlJepNH9aFOxJpzVK+tcaIfCIcKVZsaGrXL0Kt0=;
 b=R1JfyRHRd76ANXGKxEnbJhCXYNUFH4C27IFdF6/56VwAPvcW142V+EhqnSPp+oTh+VnecyfvsYwP3hy+vmrCURbeRngQ/xQn0Hse7fbMPIXa3rp6PnCaE1G6VHbHe3TQeLfZRTH1GoOrLFoc7wYVCpNbnZ6K4Zvz96uEzmT5qUM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 04:57:09 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 04:57:09 +0000
Message-ID: <1db48a8c-c3d1-44a3-9b43-6239097ac55a@oracle.com>
Date: Tue, 1 Sep 2026 10:26:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.220-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260831133358.601894154@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0214.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb138bb-6657-4d12-5747-08df07e57a93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dvf9yys/47l7NM7htbaESKmUmiN7hWzlDbT8J9mK47NtTBT3Lbr96iG3pLxxuRB60zWpij3SP/df7+0TbGyq4m5nVTCQfcHKM+7rUn7MZ/SGG41+zgb5noXZfVTFogyxtFTKmKemaTbds4dVgY1fipuryb6hIzOBwQVpfr1SeLg8GSOHUqgw68cGsM2JTOh+H9XNZ+u3DhpSfFya4qpDS7toH5cKGFDhY49YMWJPCNaMsy4ialKUYOLbY0QPFXWgdq15iqbx6jqYwmnChoaQl85BTRdS1L6o+GyRfz1/rCX0pbm+I9trYEmTFDi9D70V5KWBjLObh5I3pJ4117/d1po+tMzR9Scw6FFgOSOOm3qMpdkDe90YGDULySnilg05cBMKbGr5rHrQQt6+RG0QZvwJomYZPII7dUiQX19FVUje7oB29sBLtJPWskFnkmbt0GIPxAY9ko8/T6RFswswUzKkYSTAjmUzrUgJM+rKQR5xF8QxsnxGzT+gpvMVmAyCWap7/b3X5D+5Sb4R7famq8jdXZeMzTq5ozYDKRIRfHPnAnjDTbnWcKgqiOXk/jvbPZja+MviTYATCHIK6Nc2X9nyos+YSIxz1nBy0BwQ7aE6q2qD8L4UZTi/i+BIdXFAyrQde6keLbR/fCZyjqFhz5w+WkxE+zoq42Fe4o4UBy4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkRndC9jMGVPQmRjbExESllhY09RajV1WG9RNHBtL001aWQ0djRUOThpOEFk?=
 =?utf-8?B?Z09haDBoNExxdC91QzJZNHlYWFpKbzcvVGlRdVNOWk1sT1hCdHF1Q1hMT0Ev?=
 =?utf-8?B?L0ZDVGRpUEpnOVMveEhFWUNCMVhjYU1UYkFkUjJVSGRheTlOemNIRHdsdTFv?=
 =?utf-8?B?aXBNZm5yUEU0am1pV2NBU3ZRYzJQU1NPb2I0RDBWUUIwU2x5VUVvb2d0L2d6?=
 =?utf-8?B?d25UUUFYUTNDSk1GOXJIdGdISi9IclFvVnNVNDBrbWMvVlppTmx4elhLRk93?=
 =?utf-8?B?Z1RkVXExc1RudnE0MkhQK0VRbXJWaXpjZmxURVlPOW12anRuNktVZ3F4VDJL?=
 =?utf-8?B?eEZmV3c4aGJ6UkZtSUViZzl0YnpxOGFXU2MyS0VyN1ZrbDFNc3VhekFjSTVN?=
 =?utf-8?B?aGZseFNBaENBSlpXVm5nWFBRRmsvUnRYbzRHNXpHOXBBR2NzK0hsUHlRUVpu?=
 =?utf-8?B?cDVKZVdqY3c4eWxySFRwRk5SMGhTcGRRdnA3YlBpc1ZkMG03bkN0ZlV2bkZz?=
 =?utf-8?B?UkVMcE5qNkJYby9pWkFrU0h4U1oya3NxVFBWSWFXTGF0K2xTZUdGTC80SFJz?=
 =?utf-8?B?dmJEWG8zZlZaSm1zVVM1Mmx6c2lrblFtMk5rOTZQeTFIOEZ2RktPSmNKbXN5?=
 =?utf-8?B?R1BkY2VUaGl6VVBTSUFyREsrcXNTQjBaQ2x5YzhibVVhZ3l5MVpJUVRkQlpM?=
 =?utf-8?B?UytxeC8rNW5vZ3pBdVFWK0tweWlmVUNxZE93Y1ZqanhySUp1U08rWUZydGhJ?=
 =?utf-8?B?Q1Z4cWgxQk9nV0ZhdjhnazhwOFk2dENVYjlGUWtvZ2lUNWFYV1hDNnlTc284?=
 =?utf-8?B?NzN3c21TQVBUUlFCRjVLRTltN3BFTjFtbjJlb0I0UkpHb2xjNnBmMlRrOWRG?=
 =?utf-8?B?TzJWMVROclkxZ25lSkZXTEZPaENVeE9VNkFMR1FXZ0x5cXcyZGVlTXoyZGdF?=
 =?utf-8?B?Z2s1UnIrSlZXc2h2ZDdWSlBGdUowR1ZIbDVBY3VLbmEvcEhoazVtNnFQSjhI?=
 =?utf-8?B?NWx6SksxRjZ3ZWxzOFRWbHFIWFZVbDVreEhxVm9lL1grNHozc2pMSE5HRFJE?=
 =?utf-8?B?SkhiRHZkdzQzR3NrcEVQM0hCbGZ4L0hNdXJOK2ZFeThWVzZFUElYOUM4bmhQ?=
 =?utf-8?B?SnVkS2VnV1RqVitBUFJiY21hN1hWNUdoTmZjVVRBSHdBNVdzQUI4TithVURp?=
 =?utf-8?B?NHlPMnQ2aUd6akNrdnBMaFQ2NXRST0lXTGNDQXAxWXpkVjhaaVBDMHZKaXNy?=
 =?utf-8?B?SnFtY2FIVk5ETzBYSkduWk5RUjVSak10cGYxcGRTTDdSWENURzFsVXRnRjN5?=
 =?utf-8?B?YnUwN2NJa0xqbUErUTFUUlE0QjhrbzEvaUd5TFgzYTBJSENVUkpSbVYwa2tQ?=
 =?utf-8?B?cEcvRm1ZYTczcVdaU29uVndKWkdMSlRXTXV1YnFmZkwxV0VuWm1LaG9wRUhK?=
 =?utf-8?B?cHhSaXVKd3o1Q25OU3diNXptSVRINjNOODhXb2lSQXk1MlRnNXpLMmdHYXJM?=
 =?utf-8?B?V3ZETUR3OUROZlg2c0tjK1REOTg0TUJ5UFd5VW1vVy9Jc3FRaURXMUdRZUJz?=
 =?utf-8?B?N0NaRWpXRFdFa2srUXhoVnJGMUwzcnVoVzFwVzExajVhN1pvOEo0Zi9DZ1Q3?=
 =?utf-8?B?TzlFOTNMbnJBQnNVOHdZYXIzWW9mNkxPSm10MGl3Mmx0d3NQTHY2Z3NYSytG?=
 =?utf-8?B?djRFeGJ2Njh6WkN5cGcxaEJsVGQwdnZ0T09uOU92dFJLbkFzKy9oMXRUK1c4?=
 =?utf-8?B?VXNmVWhWR0NOaTNQb0ZEYm5hZ3JPbHl2bWJiT0hnSkJVb3FlbStPMEhvcHQ2?=
 =?utf-8?B?TXorRmU4eERIRjVYTUlxYmxjYjA1UXZRTGlSTHdCeHhBdzB3anJKVXVESHpP?=
 =?utf-8?B?V0ozdjdzVmlhWlNPVE1SN3R4QURWYzBVRzRNUXM4WU82Z1p0VGFkYmNGWkZ1?=
 =?utf-8?B?UVRlVkhIbCtqcmNTUm5iZ3gvaDhrVmtyT0lQTCs4SGFXbUk0UGhpQW5vb2Ns?=
 =?utf-8?B?eElSZzdJSmVPcTRLTER6WjRvbUdNWUJ1SFZPMmZRdjRJbDEraitvZGhEU3Zn?=
 =?utf-8?B?NVprM05KSTcwc1d5QkZTdFpTZGQ2UEg0d1gxU05vazVtamxMVTBoL0V2ZFhT?=
 =?utf-8?B?VXlTb0dKRno4aGdvSE05cTRFb2VpbEVyTmdHanAwZlZRT0J6dVpaYnRVZmlz?=
 =?utf-8?B?SnNwMjZFZCsyNjExaUxmY09JQ2d0bUNLNEZ6aDRBd3ZsSFdkREZYVVpaOWdr?=
 =?utf-8?B?M2xSZWxiR2JhL0pJTUkzZHNIbDhvN3ZjUElHeW52d0U2UkNxd0JOeVJyb3Fl?=
 =?utf-8?B?cDZCcVdJUVNDN3lPdFBVeWFRZ2s2azMrSklWRkNTV0JYRjIwTXZrVE0wdFE3?=
 =?utf-8?Q?QQM7Oae/kt92n+bF0mQvyzJU1D+h3cag8LfrI?=
X-Exchange-RoutingPolicyChecked:
	anlbnKXHBoblbRHed6aMu7Wmg8xcG91PYOcaFOLNk/n3KNAYBGIYiicTAGaUv9C0+lSgp8v/7cn/U6vZq1nqkF68nirP4V1OQCttNaTppnb8wxg6F1zyUyYsb9/GGMTuxynEakB2o7rix2Ya1K+72hQXZFNYWstXywyoGaXm88WaEOmfNa6cy4FZGLu8gXv6mGXvjMZlvowoKWeaTTAQlF4yJOoE2dXRgxtVfQSSzXH5KDQq/9DYL9wog9RHyvskEz3WdwTPjxf8ZV00JU28tMhc7RuCls4HrFsdg9hdTo0BeCAaBWQ57WAM7dwhzCV2ynxtQoTlFY8hWOQESkluJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E90Y0UewjQL1uVEVg9bwCMI0Xw2StknFjRAID6HbCNNYMhutHxob/pBbHUu6hRuZLUEPvGEQWtc2SgC0p2+sOwjeuVBUMEBq1RnnjdS75Fmj+Xx/bfD3TTzSgbl76YsdigJvxkZNPrQ4s2wGodwNcNRfxXn8jsv4cP3pOG/eN1WSvqQxbVBsdStA/1LPCP3BcRBT9lbuErbCVhHLVp3mh0hF49uj6br2SIMojoGD/quQacjweVR39kLatRsENicR/WGTQlwfesCFQI369Z+G6hJ/NMr7uEtlpwekjK6lgMAovt+WKWd4mPj9QlDD7TI1oXnn5YgWMrFo0CKDOBOatpppNJzRBHjlXiYmj4n509P9+d6QJ7PqkNq8NppEI6sb2NHQafLwaifTSQa6uD31318ppea0LbWbB9jn5ZA1HvOzVq+zYJRcHUuf8QqH0hGe3K076rAKBl/KGFQ7KYkrGX+0/SNeRW4D+27xmEvATpPcQug8Sr0am4QSIfTgUwchnvw3POdLN1MpctsizW1iShAZyYfavPe1kaj0oohMfPOq4D7/sCmrAtDAW5BK9NA6uN3lcf7Bh5Sj2ZcQYktQTV0AIi7XuBj0TXbMXjJFgpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb138bb-6657-4d12-5747-08df07e57a93
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 04:57:09.5973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiGqLOg87TtYyf7yZiLx5it5ZS8R63gkiufeC4bkuBPxg3m+Q2HpAJ7EhhYbNhFVDrJ6lPJ6trHms9ToNIkRGKKC3SHTjUZdt12sKZVKBxYsQOfSAwwDnq+Xk2jnzHoa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_01,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609010041
X-Authority-Analysis: v=2.4 cv=QoJuG1yd c=1 sm=1 tr=0 ts=6a965b28 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=_oBsmuTpWIX2YvNKz4cA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: ZN4C9VFvVbPs8VKxYshB__I9QNAc2YjI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA0MSBTYWx0ZWRfX6Uqc+sAeCFPp
 aR32jaH/Nn0Kog9/68ZgwJqk8VsO7IHsdGOJBjhCkOtHzCL9fnAzqmeLury0YqMNN8khOc2/PRX
 OUSZDd8inXehCdIHMZA517rySVOWhdiokkx5dj/+IHVyBhrrCOFL1yhzrnRI/U9XqMMACXwSqTx
 k5fUa+2vUPPdS9KDN3ZzKoObgwuFt0x5cOR/dUJKdbGSwBJrmCATRSEeyUnX2ns0Tp+i9VQ3XYa
 Oz6QgBKr32Sg41YJnMvnQthlh3o5/LgBgP90tIJSSH5OUSyXBPJCMZzeaI8C0zZ2pMXixHadbmS
 Zooon3pyLLW8dLJSrdG2zXehXUwmyqIWv7KJzvVauJYiENBrBb7AkL6yX3r3zeh/ScBtvo5fIzn
 KxdqX+2TDU8xqZe8sIUXmxvC4bbSTSm91NtP5aKWcnv+BKiHTI3WSdfCjvnYMrbkMI8CCuN6+4k
 xZHh44oieiHT/SkG05R3raUxSOGWoHO6e450pBBw=
X-Proofpoint-ORIG-GUID: ZN4C9VFvVbPs8VKxYshB__I9QNAc2YjI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA0MSBTYWx0ZWRfX79coki/sWlzV
 iB8paCXsaQcJPgzO5AR9slrqLc9JFDQ5KB0UyH5KJOzVHbb4xn3JjGQjsxeHHhzYjPx5roTBSno
 SmwcDypd8m3cmBzpERhQQaGa2w13C2jpfwSOp7pzUaJGoJLprCA6

Hi Greg,


On 31/08/26 7:04 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.220 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

AI assisted reviews haven't spotted any problems

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>


Thanks,
Harshit

