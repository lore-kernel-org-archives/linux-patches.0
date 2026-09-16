Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6D2466B79
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547548; cv=fail; b=Nu/qHvcAtum8UoCRREBIzwIkS9FkrAGAyemFoG+UvmrORJuY3QwTFkQS/C+t2jQow4IpzyLhnlsEm1G7IfalqlTdwH9l586UGceck4uAlICe9j4+5WDPe6ZpP8chybmIEGEojATL3+CA6YblKIItcXO9P4yvFhLpSqtx75eXGzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547548; c=relaxed/simple;
	bh=EuLwsoig1gSQGTe+6FdcunMJhbyXiWjBxlazNbsCKFE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZNREa6VChrSgQMSae1fv122MY5L358r7IL9/Ss8qPU3IichPDb5sZX5OqfhuGxHn1hiLaNN4JAbHWF/Tn5xjAn0uhxV2+kIdpDYz7MDWpV6su2KpXtwUEX4m/Sx02oGupufBKEAZunBo0zSuWogKETASGUepJHFS69V+7UuGh74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d7CyHT76; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l4W8Mmnp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d7CyHT76";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l4W8Mmnp"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLX0sX698974;
	Wed, 16 Sep 2026 08:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8NM/2zL4n8mPqV7HUgPyWdfuuBuOCdiQQ6kuL2IMByU=; b=
	d7CyHT760+8Kt2WgMfNpCFDklGQl7xvLQ8FwCewyHN/GX31J6uE5dU5uj/DivUuH
	jlXUuEY8X7M04hvH5b6LXV4pjtYm2g9psxnl92jt2xF8o4rT6l0MhgXxfNo+c1OZ
	/19TIxa3EiAMoWATaXLc6t5osLev7XcSixxHuSAka91jI2HBRidvHbxWhUCoH5hF
	p202ydwYFXmeIDABIPVnCZn5yXF/c/iGJwvQP9ozd4HGMamlGxa7t0HtFdvLglNH
	ZmvugXjpL18X2OjHwzNT1ZoFqHofDpz39OeFvZLmOZgI0Xpm4OR69XUeyJJqsbmK
	TaFXLMyT+4CkDqfkcij5WA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7d6cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:32:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8TsNt010283;
	Wed, 16 Sep 2026 08:32:19 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010050.outbound.protection.outlook.com [52.101.85.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6avpmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:32:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJmI4X5gi8vp4rBstr5ZziLcQ8uvnLG2bgObFGqjbzoSb94Jy5Pz1z9f7ieSSKRQg7AJAgvf9n8BpJaJXPYo305TJk2f19Gy4koOFVBlg33ImJMNrk3siY2JKlN1F6SklSo4RGKV8ohbsWUm+3nschGFcNvkdx2PkcxA6e+PRrHPwiCNzWlq5eJfK9c8L7yKpvnzgP67U7SkWC+mQA66ozd4g2HiuV1ykjkr2YpVUgVmo1P3oj4xAEZnN+tq7nC9n5OTrxQUbAswwLEhlbHm7Ry/eQerJhpaMHtMCfIU+AF/Mj9k328NiFYMPW1QymGFdj0fnGboYTqQPAY4kRQoIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NM/2zL4n8mPqV7HUgPyWdfuuBuOCdiQQ6kuL2IMByU=;
 b=UgrxXaBUrHa8YpSvPlyuXvWL/fZzhdFq6BYQTGbpZB4zoKF4Vc3uInAmZJO4pUQ+qlAbFYnP3ulE8YksdngYVPUqkZ52hLqrPDEeWFI6mLf/Zv2Lsmwx5oBBS4yw0NMEcdp/a2OAYS4GD5p/ySyalYSMp34RxQRDJbR9f0hIpeGgMe8dzKmL03MTppnIYd6ww8GGCX7JVrDION4pBk4pUhIE0XzuOnrVKTaXtEMJNDk+AZhnp6IKsuJsv8YSOHQI3pKCXSKajCojsOqXZqIKekSyQT1DuFTCZpTw7OOufPXs7tfKt1Oc5WRKWk9PyhmncK7h9aFRJIr1PMZuKj3hYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NM/2zL4n8mPqV7HUgPyWdfuuBuOCdiQQ6kuL2IMByU=;
 b=l4W8MmnpOzztrrtqvrB3eWVFs4yT0kyMI0xYIAyp5Cv+qV6Wv4dnSa4sVqryGQRf5P8mslW1AwbQ3QwuVepc1yCHV/I8ekErAeALnjA9TY6j7WP+OWZKJlC/Dy9kgXJBU7oqWyJwXy+85dQLnsnUj8BGTR6IFWkVIonRvd3wblo=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS7PR10MB5055.namprd10.prod.outlook.com (2603:10b6:5:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 08:32:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:32:14 +0000
Message-ID: <9be379ae-7589-40fb-a0b0-4d4659f46e71@oracle.com>
Date: Wed, 16 Sep 2026 14:02:07 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1061/1376] nvme-apple: Drop the PRP null check
 chicken bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Joshua Peisach <jpeisach@ubuntu.com>,
        Janne Grunau <j@jannau.net>, Nick Chan <towinchenmi@gmail.com>,
        Sven Peter <sven@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065631.206877541@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065631.206877541@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0008.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS7PR10MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: f36655d2-5052-4483-a6e4-08df13cd02b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|6133799003|10067099003|3023799007|18002099003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	xN991mVuwsrY0CryGZjRaOtfZBNwK1MapFpQNzEPU/VVTY8ZKJDJSoOY/0QvfQ6QUIv6gZei3AfAWSCDCL0uqZVRdvjehkGF+wkT8HW8cPIzEOjSsvbg/sXoObJCHx0tx+BZtt0jsngxQj2+SBHrZ8RLUIwsHVRceDObP7P+lyQi2z3WeZDxfviu3IGat2oa7LS3ofj7Tu3vHp0Jgr+0hY7nUu/IAKVyS/uXZidasx8gImGjidSlihyRPyDF/2LSP1lvAly9R6zlZDu27J9jRikq6EY2KJTReYDD/d5cBkZASBT53Q9mgZDRY5fDqpJJhtzTHf5Cim4+vP10KWHS/6TGTya1feTgA0NELoBH2ua2tXZ/NY0jFixxcsLBXCnwn+Lv0cvpOAeQpj9sZaFgRSvOYZQFUvuEYOuwwDDSn5iJhIoOPkO6EmZ85h40r94sM75dEfLv8qD6737sUYoVoPH1/KeCLwDx7vNBDPEXVx/PmzZRlprtycTiblDd+XVJ8w4eTwofQNGyQz3JRy3V1ycNnIsZwQ8vvJJ/2I4ONWIQi2MQ3zai/jPRkD1UqiGt4GJ7aIJjPrnFC06GCmxnojjzg1g9vjTVZegTveE0cfYet41LFcDKXNzrgIHzfXriFa10FegphyYJQcJaoD+UCGz5PP1ofHfEgB19K5kw9OU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(6133799003)(10067099003)(3023799007)(18002099003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTk5ZUVLZW00WlRpUVhVSGNWaVJITFNUT2wvTy9aY2l3RHhYOGRWVkNWS0VC?=
 =?utf-8?B?UHFzRlFlaERQQWUwMkpkbTlCWFcxVDNJUVZSOHcrUTRablh4N0V5bzh3TXdI?=
 =?utf-8?B?a0syOVVjcDJuZ3hYNnVlbnk0Y1FnRzdxeGNzMFJYRm1HZnFGaytEYWVadUVl?=
 =?utf-8?B?VExmOGI0eStydVlXTHhNWjVzd0lFWnRJNDN3SlZVK2JJbGROOGlDOWtHdkZF?=
 =?utf-8?B?Zjh3bGtpaFJkbWZNTThvMEZkWnlSbmdLTk8rYTl5QkJvVU9uUDBwV1ZUMVV0?=
 =?utf-8?B?bDlwRnRYUXNEcjFqcklzcjhEaVBkdUdnMHlqMnZMWUlPQXZkQ0gzcHhWM2Iy?=
 =?utf-8?B?TWt6U2NkS1ZGUnMwWDY3QUtYeXpBRnk0RHJKc2hZVlZ1K0FmbmpaYUtyL3Rw?=
 =?utf-8?B?YlRFd1dzM2Q2czFLdG5OTTJwdmlPMXJnTm0xT1ZscmZNd0VERGVVTVdkTG1r?=
 =?utf-8?B?MlJnYnlQZEtMZWNZN0U4bTBvdEhkdjZUdy8yRExYYWlGTWRiVHp5bDFmNlI4?=
 =?utf-8?B?ZlEwTEVuaEhVa0tBdVZYYXl3N29TRS96bU5SOXFFbml4Q0wzeGtYZ0VFNUZv?=
 =?utf-8?B?ajNoNTlHNi9FY01UK3dJZ1dGaDN4NXhIdmZ3YThJWWpXUmxqZC9DbmRzMmVT?=
 =?utf-8?B?citOWThjMTdkdVlKdzgvZktFL3Z6OC82a3NOQVV1clR3L0sreTY3YUlSck1w?=
 =?utf-8?B?UlJJMTZMdEF0U3R0NitWSkYycEVtNjBzN2FhU1FUSDY5S3RmV3g1UW43dm5V?=
 =?utf-8?B?TWFLOFdPcnpSZ2taMTRHc1daMS9Galp0dWZ2SWh5WTFzVS9BM0VNbGc4Ui84?=
 =?utf-8?B?RnUycm1MWDRnSGVvb0hxbUN3OGJSck4zc3o2ZmdMZ3lveThTNlpmMTJXWitS?=
 =?utf-8?B?TkJNUEE1dXFHWnVGZTBqRWUrRHB0Q0cvWXhDT3BQSGx2SFBiWDJqNUx5MmZS?=
 =?utf-8?B?T3FodXp1eXJwelg5Uklkc1R5U2ZjNVkvOWFoTnRqVG9NUFEzZjVtMkwxV2Ru?=
 =?utf-8?B?ZWZOVU92TlNlTDM0YVF4a2llM1lpajN6VGkrYlRIN0ZGM2Zqd0FhSWd0SXlt?=
 =?utf-8?B?bVYxU1NZLzRlR0RJRWwyY2Y1UjV6Y3lJeWhTdjdpNGNPcnJwOU1yQ3B3R2w0?=
 =?utf-8?B?aHZQZFpwVVh3cFFLakxxczFOYy8xTUM5MDZRU1ZwelNvQkpyd0gxUy9FQzhG?=
 =?utf-8?B?QWhpcXNQcDBFSjY2Q25SQk1qV0h2QzZFM0VxVy9NZWJzdHR3S010WFdNUkwv?=
 =?utf-8?B?ZEw4VjA5d3ZzeVhJWHM3SS9ITHZydUNKZzhOQUQ5Q3djbzl2QWhvVkxlZzRi?=
 =?utf-8?B?MnpqNHZacWF5R1NweUZGT3VzMVJjWVdqV3NNTFJabWwyYi9IMHlYMk1LamdN?=
 =?utf-8?B?akVtZEVjMUdFTU85bXM4dkFMdjh5d0w3OVgwcENBc00ya0Q3My82OSt0bUs1?=
 =?utf-8?B?YTRtbVo5NDJxbVJSekErSXV4aVVjK29WLzJtc1hQV01OQm9CRFNLczdKTk9U?=
 =?utf-8?B?MU5Hck5pZkp5UDJTeHFBNGpvc05PRFhnbTNKWVlDd0kzSmJtY2NINFhrZk95?=
 =?utf-8?B?RVd4cGxPU25CVkVrSUp1aC9nM01EUGN2UkZlemVwVTdtT1FGaVAvR0tkT3Ji?=
 =?utf-8?B?LzBZNlR6bEozbTRoTWE4T3I1a3pCRk4rQkJVQ3dpUG5QeUxZd2tRMVYycGdl?=
 =?utf-8?B?dmp3a2ZnbHJKTHQ5Zzlaa25hSUQrZmxsak1KazhVN2JYRG5jaUg4UHBvME1r?=
 =?utf-8?B?Y2JGUEZZeHJjUUVLOW5jVXlsOENBUFhLTWRpZkFJcmU0N3BEeEZPNFNHMTE5?=
 =?utf-8?B?Vk0wa08weVFUOHBhRGcxUnFMS0U3Qmx0VWNVRGtRbWdvN2dyZGRib0twOCti?=
 =?utf-8?B?Q1BVSStQWmlJbDkyV0pKYm5pajJVb0gwc1BHSXJhZXVQSnJNcHljeFJvbVpP?=
 =?utf-8?B?ZHdmTXZyeVk1WGo5a0x2QjlsQTZpVHdIL0p0M1RYdmxXZ1g0OTNlVW1UOHJE?=
 =?utf-8?B?bUtnWXk0T2craDI4NnZSV1dKc2Q2cnNyRGxmTmY1T3d6V1phMnU1MXhOR0ZV?=
 =?utf-8?B?ZVA1VDM5by9pTTdqbHZ4eC9CMk1mTlR1OUZsSktXYnI3Rlp0MFVicFFpOTBU?=
 =?utf-8?B?Nks1Z3Y0enFKdXpxS1RxWGo0T3RRTlFrYVRUci9SMFd5UTA3SFdORXFrdUxh?=
 =?utf-8?B?L0wzc3ZISUVYejh6V3FPZzV0cTRGUEVmZHpISFhOTjZtY1VqNTR6dGVwc29w?=
 =?utf-8?B?NWJWTHg5dzN3eEtUSmdMV0tzdUF5cmhxYm9POWNUSEpuNkg3L0Fmb2RRVkEr?=
 =?utf-8?B?YTF3cER4R0dGSFdndllnL2krYU1WRCsvRjFzcDkwMFNsaGkrRGFXVWxSSkh1?=
 =?utf-8?Q?dspwPBe4lZv6ThTsRX2nyhbmET3huQejwn9J1?=
X-Exchange-RoutingPolicyChecked:
	a1NoUvSMVjrIIetLj54Uls9Q6lc42qquKQOt9CzYhcZxmQ8jF1TAd2DyCRevboZwXZaZPKD9DyaGSItskJVl3BcER9MlRmnfxdV17E9TpPFMieTFRkytWAxSiqHrkj8gEYwHD0+ItGh1WRDjXkAn9Y4UfwvDJcOAuJZAtLZsSN9LFD5a8iN0ucKTyZoG+67/moH+V+3SeWP4bzhyQnw6osEkLNhCVdCQsXtDHIHgX8lkYFkVxLNwz4zXFVQfL/aOe2xDABv1EDsIZPCBL9DCpHAIJow27r2A55M+cGpUyhuiD43aUjKzTIAsSg+Mal8fnwe+WfGW8zTtsV/8fS2nNw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FzNQKmf4ohLLd1fIQ4toS+BydKjCiKwmUoqeB6r2ZKJhN3Jx8gb5K6mFZfm/RTZ14LGg66vBvV5Jr7qmSyIa3Kj317nTQ/tvS6FptzCm89bAby54oNAvFQNnrFw8aMccrejYrxYQVqv2EFL3C9S1Bhr6ow9tNA5Bfpvu+PTwKCNU12NuqHIjml1stY55iPRX3gtex/hjoXjMPhtqtk7XrNZFJQDTsDJV8FBEhipLeL5KfP61n/KPnHjuLdQL3whfNoJUHT5vaEj2+hSQlFCmrKx9fYs4uDV+rYoS//ZF5wS3NYxXTReWCvOues/a6Q0CzCA8qfkcAFu5xvLPsTgo5+FopBGYRottA23kgx0OGfn4eUBWFzaBX8q1cisuN34B9lYNsXSvtTEWZSq6c2shFI8uoGzSwECO0KvZzjs65v8FNmHtdb/Zqf4A8XLN3Mi3yUCEn8ryOUKUV3DEu2KExSCLZFPEhbBEuo2k2rdB3vBfWGsiqgMQS5DBBgfj6rcncphRaVcD+Q9UiccfjTkAY+s0hQ0oJg54NAhESHo+9zY2jPnkK+4YQVCvMcuRPBsk22z53tFDVYJGF1IeNU/ho0sDJplc1GZEfh3mRKrxAhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36655d2-5052-4483-a6e4-08df13cd02b4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:32:14.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UDplP+No2AAMYYg7fCz320T83zDHlHHO9EnY4vcs1eDoCK3IEaNJliyWo05oXzhNrb9zpeq0/6jRCvLj5CzbGnKJeAVI2zIZFXmoWt+w++IeyMUJfabqc6V8R8/4YEr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160110
X-Proofpoint-GUID: pU_ja0zfHh8rPwLJjxNMouOLCW59Rwqr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfXyQlbpEH4hESe
 lIo6L/m0lqpJr/1gitFAqqtHMUs4nlWGGDjqG+Nm8IxXRqpH1BcyURtJ7LJFE5raKbingqCMrNW
 JQQtIFUcdujeYWt2ACHVj+RmIF516a4uVPzMUAQjj9wtZ7L6yIg3hW5o+ONIM589hPth6quOVbi
 y+ejpYW43MvW/A3nbbzqIdAngBWzoqxEP8+47Fhv7LUez42et4ipmar/bx+xDHi3U9OiYRDD/1W
 pMkWIc8IOq0vr6qBkzlYVciKdt7yMniO1wvK47klll6jTXSr1zRwvyeJmDa0UUqIulVdlH97WkZ
 tEE4K9jNdnvH6SxzFS2nBiatLyE79WzONUgsQwgrlz8P7L4ElvNba0c1hbroH0TC5R2RD7F658Q
 hraXPoovPzTubTmYe7NaQvIkOg+OYAptGQj1dNr12EzGSFjjKhOVtgjEv9ya4nfbrTrcbDy9OtI
 Ku2m5nh6xK8MV6w0aww==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX+rR61bpjQTpL
 cxZR4oOr+qUzBjvwseNIwBuSs7Ddf5ZgXrG/fcv8KT/TbvinYIvxamCHmkZFb+azpHITC8nDtjk
 FQ7SiBC1Ac5cGh/A9to5VmxLbBVC4NVwW/6lYjrFXK5lYwM6E8mL
X-Proofpoint-ORIG-GUID: pU_ja0zfHh8rPwLJjxNMouOLCW59Rwqr
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaa5413 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=fxJcL_dCAAAA:8 a=dOLNmq4gAAAA:8 a=pGLkceISAAAA:8 a=pLpwiRCpAv8Hh9CR-uYA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=_m6CO-mWuQdSFutSHjXj:22



On 12/09/26 12:28 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sven Peter <sven@kernel.org>
> 
> [ Upstream commit 8ce883fd068b7ba9ab493cd3ecca3a7ea868c375 ]
> 
> Now that we program the DMA direction correctly the NULL check that used
> to make commands fail passes. Another side effect of this bit was that
> non-align buffers on the admin queue were silently allowed and that's
> been fixed now as well and we this don't need this chicken bit anymore.
> More importantly, starting with the firmware installed with macOS 15,
> which is required for M4 but can also be installed on the previous SoCs,
> the controller no longer exposes this control register and any access
> SErrors instead. Just drop the write entirely.
> 
> Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
> Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
> Tested-by: Janne Grunau <j@jannau.net>
> Tested-by: Nick Chan <towinchenmi@gmail.com>
> Signed-off-by: Sven Peter <sven@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/nvme/host/apple.c | 14 --------------
>   1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
> index 8fc466588c4f2..5f745bf615fe7 100644
> --- a/drivers/nvme/host/apple.c
> +++ b/drivers/nvme/host/apple.c
> @@ -47,9 +47,6 @@
>   #define APPLE_ANS_BOOT_STATUS	 0x1300
>   #define APPLE_ANS_BOOT_STATUS_OK 0xde71ce55
>   
> -#define APPLE_ANS_UNKNOWN_CTRL	 0x24008
> -#define APPLE_ANS_PRP_NULL_CHECK BIT(11)
> -
>   #define APPLE_ANS_LINEAR_SQ_CTRL 0x24908
>   #define APPLE_ANS_LINEAR_SQ_EN	 BIT(0)
>   
> @@ -1130,17 +1127,6 @@ static void apple_nvme_reset_work(struct work_struct *work)
>   		/* Setup the NVMMU for the maximum admin and IO queue depth */
>   		writel(anv->hw->max_queue_depth - 1,
>   			anv->mmio_nvme + APPLE_NVMMU_NUM_TCBS);
> -
> -		/*
> -		 * This is probably a chicken bit: without it all commands
> -		 * where any PRP is set to zero (including those that don't use
> -		 * that field) fail and the co-processor complains about
> -		 * "completed with err BAD_CMD-" or a "NULL_PRP_PTR_ERR" in the
> -		 * syslog
> -		 */
> -		writel(readl(anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL) &
> -			~APPLE_ANS_PRP_NULL_CHECK,
> -			anv->mmio_nvme + APPLE_ANS_UNKNOWN_CTRL);
>   	}

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream removes the Apple PRP workaround only after
69d22a6b2f698 adds a page-alignment quirk and ea2160c7b7818 enables it 
for nvme-apple.

Upstream code with both alignment prerequisites:

     if (is_admin &&
         (ctrl->quirks & NVME_QUIRK_ADMIN_PAGE_ALIGN))
             lim->dma_alignment = NVME_CTRL_PAGE_SIZE - 1;

Downstream 6.12.y code:

     lim->dma_alignment = 3;
     NVME_QUIRK_SKIP_CID_GEN | NVME_QUIRK_IDENTIFY_CNS


Neither is present in 6.12, whose admin queue still permits four-byte
buffer alignment.

I suggest porting those two prerequisites to the older queue-limit API
and applying them before this deletion. Thoughts?

thanks,
Harshit
>   
>   	/* Setup the admin queue */

