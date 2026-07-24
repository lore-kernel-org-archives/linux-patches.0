Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B67432E86
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896982; cv=fail; b=O5c8g2QoBvIl8Lt2K6R1jBEb+bph1Uok0JVOZ+L0tSnEv2b931BliYqhesmgAk6YL6rTMgQsaKg1P7NePaCigfTY2U9cC0gwo31+ey0sE06HeFAuP1SFG0FtUjMY3dpabgPdVv3uVFxTjfwZPlFIMrxyWjdkOdeSqMdvPnfFxbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896982; c=relaxed/simple;
	bh=xcjHCK8L4YCByD0IxYa3cRGlWbHCDl83/Bk6wcmLM38=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gbEhRHJGKlQgbdsSy+ef6ON7T3cNAm07wikcnuFq6VVJ0XWxkRF9m2EHm1Pw7UsNP59yB3J+Yl1l/HSyjKeZJDOK4DeKJKZrz0684yjEZqRwf4BcJd6MbMM0m8GlNF+0F6q5Gv81muTV6MIKZBEnRbdiptAQVF9ghzbygGfZXmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p5nRd+CT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=APTKVaTR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p5nRd+CT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="APTKVaTR"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O7YYDe2132028;
	Fri, 24 Jul 2026 12:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rRzNZKSwoyntAltS6pz3I5gCNVebIHCjm3XDgMN7M14=; b=
	p5nRd+CTmDfWrBJzH8NJdQjVrunkBXvUtpB50zdNmiww5MMh+rakLoJEiYnqBdUF
	MWJlvcCo+9pTV6uFjY7fTI4V78DMSkP4HK1dK7aCtCxL05smavLkmHbo3DcroSLv
	ITYya5DQS0EJIXN+1ApaX0vB6K4rOtgF8ER7rwV7OF9QP3tN4b220kODUc+cWqZ0
	bIBiK0oOgnYMmqpxLdh24OMe3Jgczs+4kANXfnJet96DitpGX8KAMoz/MTxGlvOU
	z+jJEFthv5fTCJ6R3+2tVf7fJYRx27pbvPmQFYq8WusUKof7NKL5VZN8lnDrPjP8
	wIwmRmqXjtoqOC5WXPy0BQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n38n0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 12:42:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OCgn1J037020;
	Fri, 24 Jul 2026 12:42:54 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011012.outbound.protection.outlook.com [52.101.57.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxfyvnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 12:42:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J8Lw7VA+zu4pfmbUOm7sHf+jzMMcQXLT8EN258zuiExlfUgd4rbgVtpV0EHkHcwno3kBcYVUYSTYZI0cihL3c0bGtw0f8WqJm+uZonYPx6OVKPqaCO3wW86jPOwLRHjvu0KH2sV4GYXKAcwo/Bn7HL+5fdai8e7B8AhG2efyseA2VXMYtdB5qTAHiNs7I+M4uIDZrdmAB9qRLSkqdiZ3VuPC5liPv3mSKNUJ5OssGS3yOjtcGfDm9q4p3aSHjvVksXPdYmAJEhDNbKwR2WkNwIFJmlAK8JKU8u2kYh/7OqAUBRwqOEyHqQyG7JJRxn4XmLtqvlF9M/Dzh2jNAAw6hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRzNZKSwoyntAltS6pz3I5gCNVebIHCjm3XDgMN7M14=;
 b=dnD241yLq0D7ll/MTHcq7MXhb6dpPna9/c9GYTz49VpbS060I5U+Oc5qr78RFiJK3mxISwH2sHjozN4BH2t1JgtGswfpVNO2yjqJCcuIjviZCBcucpxvUuir8oRXAxbfDtX8Q0FkXxTsC6ltqY2wND0+I2WeHUDwB4bRedLTPUz4AfJQ00+C1u1IhfXow3Nck+2BG57OKm2jXfQGvxXEps+eQrZw+RI3iVCP+V4hjRDNRAOwjzlG+QmfsFq24hEmC0y26fWsQGukG5vIVbS3N+F5hxDbXf7vgE5Dn2SxaK35WEn6Uo0zToKmzdvv3O06T/Yh0iPYuOGXwwLdwgVCYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRzNZKSwoyntAltS6pz3I5gCNVebIHCjm3XDgMN7M14=;
 b=APTKVaTRcG0aRhI0MRdXV6hrT9QYssCR3OH8/jaDk0viUaub6Uc4EbVGDQO5lGumQlZztofA4WLnaWe91PH54gd/HDs3Tpix3mOnP4BtiZ/sY3jLQYGq2P+RfWLf6CuPMH4xxujLNSpbsdLqeat8QqwV0akPOaC1NqyblARvNOY=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH0PR10MB7497.namprd10.prod.outlook.com (2603:10b6:610:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 12:42:42 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 12:42:41 +0000
Message-ID: <636a3072-c74b-4548-8b4f-c2e07c5bb8b0@oracle.com>
Date: Fri, 24 Jul 2026 18:12:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0178/1276] gpu: host1x: Allow entries in BO caches to
 be freed
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Aaron Kling <webgeek1234@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding
 <treding@nvidia.com>, Sasha Levin <sashal@kernel.org>,
        vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152450.079694535@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152450.079694535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH0PR10MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: c38d6ade-70d8-4cc4-ef88-08dee9810d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|10067099003|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Rnee46Ss0FORUbz2JCxiQmoJJSV6BrKjRMiO/0gXn6L+pI+ByBE1Me8WQzamnyC1huSVrSH0fB6KXFgsTtT0oaGlRRCYYAYZw1kO4lNeb8Jh2O4KJdDnOaA64UI248C8ALjEZtVfk09Y53CMeQ/TI3TtEbPBZ4KlbNOL09AdxHW/lCVut5U4V4MqtJyQWVYl5TsY+g7kMFB+tws4vz01CYJQIpqJWm/1PUD6TL+EsutMiCNfN4B4nI1nuoYC7Wr3sRbh03avr+VVS5tHwerefstORV3j+0LuHUHoT9Aa9hCBOQ7pMbltuFOsgyzgm4wHjTVaq0Du3sPK4d1JG5f2eP65ORi1tom1bxyRd5Mji/xO2XozfURNMDAgsunrOrtLklrJrCAgJihUYbqvHZ8rmAYoXqhzGIJ9TrnWaGJanOiIXd6ntwsx1Tu3ryizl0GAyLUd2qlUkcDuJl6/WqVIAenz/2uvD4DA6+vpKOt1+okfvWlBBBh5nuZ98IvPnOAg/U/OFpd8ZoEVW7r8DAhm99O4+apsE8zo7rpPhKVOQ9XtXTZVVf2JmMVtEdrvkMXkGah0fS85rpdrhN1n0NF73WtWPzwGEW0SvnU3gUWlhOjENhjy6ZZosoWlt7l9kHSyUYOOieFk7Y29zLWgIFAMENOLElMW8YKe7iLKn2k/F7w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(10067099003)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SERVdmZyc0padXNPQ3V4ZWQzaEtzdjhDcGlDbnpzekhwT2xDK1VHS2hIcnhM?=
 =?utf-8?B?MUZ6S3JGNGhWOFk0ZGVQVkZnSGZJVTVzNEVFSk5hZFEwWmhxZkVuSjRCUmZ2?=
 =?utf-8?B?RWlpNWh0SFBzVUoxb3F3THVyL0FLK3JCMnR3VFdKMGh0VktJdk82Ri9FUXFY?=
 =?utf-8?B?TGRmdVl2RHlxeXBFZkRVTnRFSFduenZXaEpSbVhvZjRlUUx6WG1YR0JRVDFt?=
 =?utf-8?B?dHA1WUJRbnNBam1KcjFwb3JMYTh3cFFJS2VJQ2tlcWs4eEpGTGRLRXJmLzhL?=
 =?utf-8?B?VW9kbWpVZ1E1WHRYcVg5dkxvNnpmMlE5WTZzWVlJRmN5TEJ3YzFISGEwQ2Nt?=
 =?utf-8?B?alN6N2ltOUdlV0IwQkZMeDk4SXhJNWtqM3BsQmJqcXd3NmN3U0txOU1XSG41?=
 =?utf-8?B?YnlGc0V2c2pjeUxrMi9NWHE2R1huYUVaSEFzZDNMQng1WDBUbmhYRi8yamdJ?=
 =?utf-8?B?Y1RMd1FIZWlsT2k5ZncyRXZYVVhrWkg5MEtqbGdJdlVDc3RpU0FPVFFlRlVx?=
 =?utf-8?B?anRTeEl0b3d2UjJjM3BTRk5vdUFDMTNLdzZlTDg5eWYxOHd1OTdadjlhcjg5?=
 =?utf-8?B?R1dMNVdZTk9jODB2YjlQTEIzL1huUldFVlh1QlBXMndUQ1hiVzkwYnYyU29M?=
 =?utf-8?B?bGJINFY4QXZlUkxUd1paempPd1V6ZXEwWEJ0bTFsK050Z3hTdmhlNWRLMjR5?=
 =?utf-8?B?UWl4YjVyMjNVWnBlUFFZcWpzeHR1RVJVMEtuSWtHcWhVN2VvYzJhSlVhWFhq?=
 =?utf-8?B?TGFseU93T0NLR2hSWkYrNkZtWmJYeGNHSVFiVThOMWI0V21GMDBPcE02eHhE?=
 =?utf-8?B?bDlZU1Z2dmRzS0ZuZy9zcURhMDg1NTBIcVo5RWFqSUU0R0VvRTZ6ZG1lUllM?=
 =?utf-8?B?TTM5RzJVdE9lZVRDK3Q3SDVWcm83WllyK1RBbWQ4Y0RDMHk1QVEyWmY4b3Bx?=
 =?utf-8?B?SEQydWFBWVA4YmRnbklUWmlkMUpQdXJvZExHbkVTVWd3YTR2MU9PMGpvVzNU?=
 =?utf-8?B?M21XYjFVdFAxaWltNjF3UTlpRUhZcXpSMzMrbmwyZzFwejFDdEJkbWtxMGVp?=
 =?utf-8?B?MTZZd0x0RHRWZnZHODhzaDRYL3pPSjVKcTNCdEsrUkhWWXg2cVJpL3Q2bUlB?=
 =?utf-8?B?dVRadEdiK0V1NWhIRWlWenJKSUJXWFNNWnpXQ2U1cDJlR3VvbzVRZkZKemlH?=
 =?utf-8?B?UGV5Tlo1Y3MxOFQxTjEwRDZROU9pemxlN0JPWGgyZkpLU1ZsdThqSklhbXF3?=
 =?utf-8?B?b0ZBcUR5VStzSm8xbjQ5L3pkc1NjZFMxRG5DL3Bta05FQmx5YWZLTWloaE1n?=
 =?utf-8?B?OGJTZ2xrQkJzM0lSWEdya2hwWGVLcUM2V2xiKzh5cnRleEZRMkhQa3hoVUZ0?=
 =?utf-8?B?dklBeVlKOWYrbmYvTEx0TlQwVURuYVB4NVQxdXpkeW12MVpsaDJDVmtWUFYz?=
 =?utf-8?B?VS9TeEVBcjF2MTUrSEd6VU00TS83cGpDd0pMZ0w0R2NMUGhDRmxqUWJWQUtM?=
 =?utf-8?B?K3ViTFJoK3djQW9KcjNtaUtRUEYyWWJnOVNxMGhSbDNWTlVrQzIxc24rbmhN?=
 =?utf-8?B?ZUhiU2kzUnVrdy84bGFNazNiVjI4MDFkTW9JUFFwQVJUR0E3aXhMYlB0K1BU?=
 =?utf-8?B?Y0J2ZlQ1UG0yRk1vc0YxeUZ6bVZiazhRaTRVdmxIUlk2Yko0Y2VDSUpIUzhO?=
 =?utf-8?B?SmQ5SWNqOUt1Qi9hZDFlT1Q5ZHladFlTTmNNb3pLdmozemI2bzJBcnlFbGl6?=
 =?utf-8?B?ZU5MenFwZzBHeGxyRTl1ZnJ1YjFydVduT01lbWdvT2hIUXA1ZjA1Yzk1ZFQ2?=
 =?utf-8?B?cGlRTWNOTnBuWUsySmpnNFdMdnJMKzVLNGwxTkNYN0pRY0tVU1c1V1NZaGVq?=
 =?utf-8?B?TW9vNlZlaFdXd1U0ZFAxcVBQblRkZkl3SUMvcC9jMERsdWN1UVAwOGhMa1JB?=
 =?utf-8?B?ajJZMjRoaTVkd2NOUkdzY3VJNmN2VXNUOWtMQWZpQzBGZDdXMGpad0doaVNQ?=
 =?utf-8?B?dTNxWERzWnN3ZGNSWnlaNHhPMlVpcmJ0WExJTWV4aUtuYWJ1ZklXNmtHUlI1?=
 =?utf-8?B?ZXVxMjM1Um82b2RiMG5ESVJMRXZVUm1uUWRJWG14ekthRXhCSlRPc3FVMnRv?=
 =?utf-8?B?T2ZhUWF4dXNhWjZ3RzFZMlRlSUJ5VFhUTjJ6SXBkemo4TzlXcTFHdHEvRlUz?=
 =?utf-8?B?NHJ2MlZFYmZXblJNNmR3TW90VW5zR0RTVCtSQ2VadWdZUkNoV0xHcEduYUFz?=
 =?utf-8?B?WExZR05TSEVHVmsxR09FVWVrZVFNaitvWUZwcnZrRXBKOTI4eFNmVlEyaS8z?=
 =?utf-8?B?SnhTSkt5TnBWdXUzenBYOHFWUTRlVXE0c1dPTWdSWjBsVGZUTE0yUjc5WUQ1?=
 =?utf-8?Q?qAZYCva+NzIdL/XFLN9QnVeFy8DgY/Bp0nak5?=
X-Exchange-RoutingPolicyChecked:
	Gi2FcgsKck+7UKbFvrDj83MNBIk6CWf2jgvzHPEqOoxwTkFen9HpJkW5jQofFHplLJdkujTGXr02r7cPFiuWUBbIjo8QrFu4HDe+CBCoIOOTQBWCW1uR75FRl4oIieI6pGkd045FylY2kHH0QSf9fu50J31dAOD6iZvnpNvAq7kUYmXaKkoKLeW2azvowOwSFTqx7vtPzGMxjiPoNgpNFje+SnbGSevHxVTJcF9rlqKKuR7kUWeN8HzEAKFwVt9IzRl5Hw+cFwYpPBFCxE2xtmmP7kWAXXd/5+EovQKT8BS3xmaLRTvX9I3C0c4XUzvOE8C+HYRYD6mM/94xhWt9RQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vgs0KGvEKCtSxZa3Q/8l9TiEHfWSsnkv3kkzFAfZtee5az9+XnV927UZlPIlUJNxhwoyfFtVsj3/OIuzIvT+2gyk9QGs7whOyDejvMAwTlWRHGPS9k6W0l+SrsGJIu8bkSFDTBrSByU0uFcS3sbWcZBoqgD1ccFR9vnCCWr/OoW7rPYi9tRb+ppzIQGq1KtCqMc8MH5sn9P9qY+j6l/VqBYuK92fXIjR+UfUE0EpNr6CK15oNtkGic7pDidKcXavQVdFDbn1WfHubHlkTJwxob0IO46Yix6LrXpppR+r4aElq6de00FpJrN1UFoKcw4DuD5ZdcUnXF/5QIJhD7ntgBBnVR3orz7R5xXd5ALrn3QiCJk+TrCJtRoS+JLUf1Y8t2dpHu8PWHRF58Sxquinm+8D3pYtutumyOlk87PZGceWUQ8FHwwBg74Frpg6imcurodRQ6HYYgp2hIENZnbk+kcGTFGDIBnd+qk1KT3b+XNELcWxdVP/LHqdSZgTygqtSTpqWE3jV4cBOQ0je/04nqQUcnFRndOMv0jnmtBD88GH6WX5Vas3dLrgs4OX92m/up/hE4aeLALwuLZ2SdS5TQXGy7ODVBQCRoqSgz96Ezg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38d6ade-70d8-4cc4-ef88-08dee9810d4e
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 12:42:41.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Nb1zPC1O81kicQJ6qCrnIuggYoa8vj0zDHMuNhjP6Ii3S9hUfcDqozab4CdiJ3Q3mJjYkNmntN5x1VlMyYB1e8litdDo6j0T/w0L5W1q0ZWjFVCYoTZwfIZmWlC730p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_02,2026-07-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607240115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDExNSBTYWx0ZWRfXzzEqOxHcbS+f
 ggQU8qmMgumsXJnOJWeHFiudUvSbK7fc/zq/895GBMhlH1Zg5O6E/IfpdMRAW/Yv9v+n2UlGBXF
 jFk9tBhopCuXQKfqQYGbvGTNzM4F8yKrN14NUCggfIOoYxA78CeXoPTcQ8G3YrvOx1xVFWqdGwz
 o+Xjld9srJjGTeVCDjFdy0O9Xk4KMUgMTCLWTmDM9X1VrpwIoYuo9p1r92NEaFtwmbJk3GSN5+j
 WrrdSx+Yx6VU4vhvptRCH4b5rQ3xktxTAfjbnB0ZC7jKrDnz6NEM4zAd3ELLvjlDlssiLSHzcvN
 zy1UGofyjWf/hWLQbY6490FtG5StnVMyMitjXhsHxVV7jOe5DQJzcuc4ScJHOdU4CwUZlWlMk9u
 VJMk7ow55tsyQa0A39bL85BfuAVIASUfUpZT5PqZE6V36FBZkeGRaL4ZCg4t0yr00TADf9AGcWI
 6miiZbijori/14RAaOw==
X-Proofpoint-GUID: 6bU_zCgJGr65MsDKsnPNX0Ubo1pFwn0n
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDExNSBTYWx0ZWRfX+R9067X7wQuT
 lzGQqpbsv9+mHsdzgY2lUsnPLv++uvEUMWEcK/o3XSA1ughmIOhA6gOou2n8dlb1dMKquvJMjPh
 +Y3Lb5O70hWFTnhoo8MKrynoltlLhEx6agDv/X5ioIdM8JEsuYAb
X-Authority-Analysis: v=2.4 cv=JrfBas4C c=1 sm=1 tr=0 ts=6a635dcf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=Ikd4Dj_1AAAA:8
 a=G3J7LVJBeSarw4F71yAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6bU_zCgJGr65MsDKsnPNX0Ubo1pFwn0n

Hi Greg/Sasha,


On 21/07/26 8:40 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mikko Perttunen <mperttunen@nvidia.com>
> 
> [ Upstream commit 3cbf5e3c46e66d9b3b6b91099bb720c6cb1be3bc ]
> 
> When a buffer object is pinned via host1x_bo_pin() with a cache, the
> resulting mapping is kept in the cache so it can be reused on subsequent
> pins. Each mapping held a reference to the underlying host1x_bo (taken
> in tegra_bo_pin / gather_bo_pin), so as long as a mapping was cached,
> the bo itself could not be freed.
> 
> However, the only way to remove the cached mapping was through the free
> path of the buffer object. This meant that if a bo got cached, it could
> never get freed again.
> 
> Resolve the circularity by holding a weak reference to the bo from the
> cache side. This is done by having the .pin callbacks not bump the bo's
> refcount -- instead the common Host1x bo code does so, except for the
> cache reference.
> 
> Also move the remove-cache-mapping-on-free code into a common function
> inside Host1x code. This is only called from the TegraDRM GEM buffers
> since those are the only ones that can be cached at the moment.
> 


...
> + * host1x_bo_unpin() - Release an established DMA mapping of a buffer object
> + * @mapping: Mapping to release
> + *
> + * Unmaps the given @mapping, unless it is cached. Decreases the refcount on
> + * the underlying buffer object.
> + */
>   void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
>   {
>   	struct host1x_bo_cache *cache = mapping->cache;
> +	struct host1x_bo *bo = mapping->bo;
>   
>   	if (cache)
>   		mutex_lock(&cache->lock);
> @@ -953,5 +983,33 @@ void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
>   
>   	if (cache)
>   		mutex_unlock(&cache->lock);
> +
> +	host1x_bo_put(bo);
>   }
>   EXPORT_SYMBOL(host1x_bo_unpin);
> +
> +/**
> + * host1x_bo_clear_cached_mappings() - Remove all cached mappings pointing at a bo
> + * @bo: Buffer object to release mappings of
> + *
> + * Drops references to any mappings pointing to @bo left in any caches. This must
> + * be called by any host1x_bo implementers that may be pinned with caching enabled
> + * before freeing the bo.
> + */
> +void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
> +{
> +	struct host1x_bo_mapping *mapping, *tmp;
> +	struct host1x_bo_cache *cache;
> +
> +	list_for_each_entry_safe(mapping, tmp, &bo->mappings, list) {
> +		cache = mapping->cache;
> +		if (WARN_ON(!cache))
> +			continue;
> +
> +		mutex_lock(&mapping->cache->lock);
> +		WARN_ON(kref_read(&mapping->ref) != 1);
> +		__host1x_bo_unpin(&mapping->ref);
> +		mutex_unlock(&mapping->cache->lock);

I have run an AI assisted backport review and it spotted an issue. I
checked it, and 6.12.y after this backport still has:

         mutex_lock(&mapping->cache->lock);
         __host1x_bo_unpin(&mapping->ref);
         mutex_unlock(&mapping->cache->lock);

__host1x_bo_unpin() calls the .unpin callback, which frees mapping, so 
the final mapping->cache dereference is after free. Upstream fixes this 
in 266cddf7bd0f ("gpu: host1x: Fix use-after-free in 
host1x_bo_clear_cached_mappings") by using the saved cache pointer:

         mutex_lock(&cache->lock);
         __host1x_bo_unpin(&mapping->ref);
         mutex_unlock(&cache->lock);

There is also a provider-contract companion, f8c9c57d7503 ("crypto: 
tegra - Don't touch bo refcount in host1x bo pin/unpin").

6.12.y still has the old provider-side host1x_bo_get()/put() pairin 
Tegra crypto driver so its pin error path can leak that extra BO reference.

I think 6.12.y should take both 266cddf7bd0f and f8c9c57d7503 before 
release, both of them clean cherry-pick and build okay, so should we 
take them ?

thoughts?

Thanks,
Harshit

> +	}
> +}
