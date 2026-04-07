Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44671EA7F4;
	Tue,  7 Apr 2026 07:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775547213; cv=fail; b=Sl6xaAxeUxl/iTLjYlcgAqy6To1ZtZcLay+T5QY2I2IgRlqrReVJWS/RnFx+clIVQrx1QwewRFp7lSKQ2H9z981FgOdzsCxCt0m748rse/B65rFn3spy42gewDJwNlN7mlcNEbBI0e5b4jsO9kheAVsMXq0+GrLTXdLd2tLk32Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775547213; c=relaxed/simple;
	bh=F20TpsPywGFDrUkcJuEeT7KVcWmqJLiieceUdDZkwvE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lsMaTD5bJhhCoHuf+E6YerLgNqjyJWlyDCyNH4E1JyQKt/6sq3oHHPybHkzRMZpKMXFswWQCQqLFiwbMwu3TSObsc/pFbplePBGENCfXYT6nW6vxbiKj/lsVM7IADYU+MBoMmS4+EmBJDKzd4m7DrDFUJV3YNEM6LAo1yeBZPKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iB6IpiLM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HJ1XnulY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iB6IpiLM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HJ1XnulY"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6371BepD172591;
	Tue, 7 Apr 2026 07:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OlRBqZc232HO6oeCVs0xgiJcwzYboZcAKA6ehYBFkBY=; b=
	iB6IpiLMJexULZYQghGj3gNVOX7F32hFQTY237Lbb6tg8kdNLwOKm3f+Kp/Jndrg
	+aGgotvu8txS31P60PRjKzDfJ5y/OlJiMoj/KSOOil6WgTH8UYYkXaO223gXe5BL
	JY06Jvpbpnu/QYEb2fb78BjsEnE8loKmMdYrrobTBSZJutFrPzGpmRWAX+8E5Vcz
	POALs/Ub1rRxq8Dt7PKR6ShGcRXL0XwP89r0Mt7aQc990KA3pHp7v2ZtIGt6KRbV
	sGq58ro3c1VTTQNsx0w284FbD47f875Gdq2GCFAGs2EhcjiLPRKsQInVuHiZj5RJ
	JOtEjonsElgzCpAo9EfSQQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqarm46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Apr 2026 07:33:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6377G8DL003534;
	Tue, 7 Apr 2026 07:33:26 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010048.outbound.protection.outlook.com [52.101.193.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5uy899-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Apr 2026 07:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bq9zny1cfEyP3mrWvjJs5ZPLoOROy56lqWhCk8OIKEwgbtbJevUBJ5DD1IpN9FVypUyVamssZnNdyKkuruhJ0bdkxZK0OgtPzIVjfVT7yk1g73aZrz8NkB+fUax41uvU/TlHBE/hlP8/Gb4uY/FQuL4lVK6OrhW1g1O3THAtouVThp2TJ1EsCta21y0XxkZbiaO4WIe8RZb777rtPP8U4AR3Tm36f+ys7mlBMaB+2E9Xz2xQ/yWr8wKEcNB0U22XoyNmPeUvj62vtqFZnP5+kfl41dko7C9s+Dnx+2LDQX94tTR58ml2U4MDSAo6TLNIObx524+0Lb80+jBIrMuryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlRBqZc232HO6oeCVs0xgiJcwzYboZcAKA6ehYBFkBY=;
 b=Kcc62322Oa/VxhKNC8LBTGD0eXpo7it1dVVW/0BucyC4Bl7Qdh3Viq9yeEABZAfyGr6Abw3/HfRVdDVj3AzDyyT1461io2RA1+QGRU2ujyCQeE0UY+lVR0s7ADdiu/pbM14tBoVxFUViJQxAA5f+BbFY4Wjx6aeqW9CnH2t3u+9M3gcxiVVTBnUxbnkmJd4V5o7I/9wMtnCrOm0jJzG4wt8agsYVm2p3DbGg/W/NigIPTAUNDD5dcRW2ZYNRlbVOTOft53u7AysyaY0MAspkwsLPfUZrQuvmHAV72UHyQcECyCYTq76ufx7UGqduxQbcPLEJ2syhXWsu7r7tEF090A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlRBqZc232HO6oeCVs0xgiJcwzYboZcAKA6ehYBFkBY=;
 b=HJ1XnulYNX3y7e7T3owqekyKvGsH8Im3dJourQddFo5YaRu0UnjuvoXzlS4zjAU7JL87YGuas3CCRMqP+vE3MyC94Xa8vEQcB+lUufA6p1g8d411IfQ1tlTIU9GI8X3auBGDCDrh9nYzWjVId7wbtbbwkAJFYy5nOA5itCIugBs=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BL3PR10MB6187.namprd10.prod.outlook.com (2603:10b6:208:3be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 7 Apr
 2026 07:32:58 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Tue, 7 Apr 2026
 07:32:58 +0000
Message-ID: <6d9cdf5e-a146-424b-bcd2-8c68766d4dea@oracle.com>
Date: Tue, 7 Apr 2026 13:02:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 044/265] PCI: dw-rockchip: Dont wait for link since
 we can detect Link Up
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, Niklas Cassel <cassel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201019.793655649@linuxfoundation.org>
 <ffb3f43f-ffd0-4e60-9966-a77e8ed611cf@oracle.com> <adPUtsthYnKHekY3@laps>
 <f1c33cef-b20e-42f2-be2b-7c435796e2de@oracle.com> <adPocsaGAcsKSuR4@laps>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <adPocsaGAcsKSuR4@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::17) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BL3PR10MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b47aebe-5e5c-423f-3add-08de9477e3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QNMv1hwFzLu8Qmdg5XMSrcN45/MGuyO7/NWIIjM1IY7kEKNKTCkphk7UhiIccYqjLoH7n0d5tqz7i7GAs48dkapSZ2CDS/gTSTPakI3us5KTIkYSkA1Fjq8G0IbmgY2RvZBluiDmblSix14Jmd/fr/iZR3TDAYQuTRhlcd4Q5LVxQbwCkCfDYQv8f3GUeeTjQMcLHvbXbJhb9HV9lgAMsb1FZB8JfwxdirQufSZrdYrBXL2g6MqZT1dMZsQZNLsuaz4bLcQezl+WZ5Bjt/H8o9xfCj71jKsnMV1yRI+01xKfGP0bg0wzbik91uJvfeCk3m0qBS5Q6GDZ7dn/x0/MZDn0fsAuxXcLd88Ua9fgbWwgCn8ivVYklPXHgmBdrc5hZjOyWhh1pzwYBc2jFY6WFqS7zxyUOJ2tKtXShVtT5FehRGm93z0n70qWrGquZb0qln9rC6FlLUz7sqL4/vb6NeyOlsm4/hD+Jdrf9iu64UB3FjrB5t97hvfDHQ3U8fc7v98ABaSKt5vArCUo05TWy3fWueIjxVDqqcAla65fU2zL4Nj69prRgoVZR5rZMaZJGx6kPlf8DtR48yNFD8IzXbl0la4++i3RrLc9tfxYhaYauiVnq/0N4CcA6PJfLOe31BwoxLSlGc+oUCPXrs0iHFxHqVRgKEHIvLSj5bgeyXqbxjDeqjvn9tyksGhXDUfAi6ZMRQroRVN+RDbpLE7vYTV/2dtkqVj2oNekCyzUAW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cE9jTlVjb3lIMHRSR2tjbFVScnF2R0Ura3JmK1ZzNGJJRzE1ZmJsVk03REF1?=
 =?utf-8?B?TEtxSkVqYmtETVQvQVExZnlVWVlyd1VmS1F5aExzSjljYzJNbEhXc3lPeDF5?=
 =?utf-8?B?QjVFN2NkL0lnZWk2RkRCYTRMOERmdlRBdzlkWEthek4vTm02OGp2RU9URkc2?=
 =?utf-8?B?VllONWNJODRsYXF0ZTZieUxMZlNvbGpVNThkY2czeHBzUzlReWFnK1QrSDZx?=
 =?utf-8?B?ZHc1V29QeW9rQ0c1LzJTV1ZZRVNWSno2cEI0RUJyM3AybDFwRnp6M0tKUjh4?=
 =?utf-8?B?WFBTRUlMTWVFR2pXUmlVUGxkREFmcDJadFFrK1JSbVRxcVhPdE5QRDB6SXVj?=
 =?utf-8?B?dXB3WFZ6d1FBblFpRzF1MlN3cThiQUdTSXZJZk9TbWo2a2tzYTI4bWVtTWdl?=
 =?utf-8?B?b0MzcnhDY0tjU0RYOHhuM2hVd2UzY0p0OVZSeHJVV1hXUTBQajNYRmJCVmJJ?=
 =?utf-8?B?TUovcXVZUUNYTlkyWUVaZUdRSFVJL21MazBhcWYzVktkVkxrcUhxZmhXckxs?=
 =?utf-8?B?UmNLUlp6OEJKbVNvb1ZEbDc3dFFQdytvYjUwN29wTlFtdkZsZ2ZMem0vTXl0?=
 =?utf-8?B?cEk5ckkxOC9sRGRDc0dpOTRoVm0xWjJ3NCt4b1lQczZWbVBzUWdveXVONmpm?=
 =?utf-8?B?OFo4UjBwV0prU0N5SFlUOU1GeHRNOGFlSU1mSGRPV255VWpvU00zQnZhMmVl?=
 =?utf-8?B?eDJNQUdLdWNVN0dwSTZmTXFxT1JSTTNUK0FEKzEzbXpicWVLV2NCZUdSMVJJ?=
 =?utf-8?B?RVdnLzN0KzJEcVRHdHUvckY0b2JRMzUzZENodEtzclNKZkZqMnl1MnFRdHdt?=
 =?utf-8?B?eVFuSG5INTdrcjVUYWFneVFyNTh6YlpGaUd3N0F5bnN3N0xzUUtXNTNmczl4?=
 =?utf-8?B?SGY3cFp2Q2FvVjJqa2ZvRmh4SVlZdGVnTUNCOE1lSFJUVjVKWTg4V2RyQ3BR?=
 =?utf-8?B?L3RUOS9BRkhyUUhvUyt1b1krS1NuMXVSSG92RUJTMEd2bHY0VW01eGVvK3Br?=
 =?utf-8?B?L256THA5Nmc2Y2J3KzYrRWJ0aEp4ekxMcUF1clhXZnEvVWF3Q0VNem5kcWRy?=
 =?utf-8?B?SW5yNVpNU2xUOXNBT2FrQ3hkWDc1RTcxak1wNGdOMDNaRVorclV2YnhPN2xY?=
 =?utf-8?B?NHFRM0R1eHVyQnlzN29jRTZkUlJTWDVDckhZWndMMTRLVjFrRlI1bWY4Zy92?=
 =?utf-8?B?Y2tEcEQrV3Z1dWZDVHZXaWVpMHBIazZodEFzdldNUHFvTkZDMG1rc25nWmJu?=
 =?utf-8?B?clRrMXdsQWVYN1lTV21JQ3kxNVcrczI4VHJLVkMyN3lsdWNzM3k2RFcvSVR5?=
 =?utf-8?B?VmpKdU5ybW9qdTRhVVNGQUd4ams1VHhWKy82aDk3LzQwdTdUZktKRWNkVHUw?=
 =?utf-8?B?b2lPSEtZR3JFNEdFQmxVL3NvWWZHaUNxK0FuYW0wSUNMNTZrVVpQYzJ2UDJz?=
 =?utf-8?B?L2d0VmViV0JoNWxvTXJXZzk1dGU5UEdmZE90RmF6STNPZkYwUUp1SnRFTjN6?=
 =?utf-8?B?YUZwZHp6L201MmFqa3REUk1CWjJ4eW1MZ1A1bWFjcHIzMWl1aUNweDBGM293?=
 =?utf-8?B?VmJNa0VDRktGV2tiRS9vWVVTUUtPOVNuc2xzSUJ6azhmMFFIaXZJYThNOXUx?=
 =?utf-8?B?YWRHanlSZjJMVmdEd2pyZEZXSXY3dU1rWUJtZE5oMEQ3K0tFbzd2WWlDRmsz?=
 =?utf-8?B?UWZ4RzQwcVRkTlRQU1E0TzBtUGpUakpnYUlYR1Q0VnZhTkI2cWlIMmFDNnVK?=
 =?utf-8?B?d0hDNGlOWUZvS1c2cld0ODVDRnNlM0J3Y0xYSndjOTMwMzEvL2dXYUUyUkRu?=
 =?utf-8?B?R213L0QvMEZZc0dGa2lKSFJPdUwyMTJsSmpiRDdHc0xUY2lsUHYySzM0RSty?=
 =?utf-8?B?U2dvY2g5NE5KRUhubFRSU3diQ2tqS3pIWmJkOEdMOHQ4TGFGOFJyMitsN1Zw?=
 =?utf-8?B?cFAvcXFWTzJuazJiNlJKRTZPaklWWWgzc3MzNTIxTFVHRGlqVFJVTEN2RW5Y?=
 =?utf-8?B?L3Q0eE0yeWNaMTZZYWtneVo1cmlaZkpzc0NHd0cwdll3djNwempIWXB2cDhr?=
 =?utf-8?B?WnVlU29jeVFQdnVWSzBHbHZ3MlcrOVorN1NWeUxTcS9LUFhXSUdZU05DTVl6?=
 =?utf-8?B?STR6enNDM1lYbWxKMjNGaWk2dUtYaldKWDhJdWhFdjVwNW00VDVOT2kvVzE0?=
 =?utf-8?B?Rk5ScFdySFBNWUFzdTlRVm5WVG1TS1BuckpXZ2lzZDJ4M3FkSE1QcHpsUkw3?=
 =?utf-8?B?bWphN3lwWi9qU1RJYURPK3IrMGVwb0RyaWF0NjZtSW55WVVZb1FSYXg5YXZ1?=
 =?utf-8?B?enZaOS8vNlFQcjZiYVJKMTI1ZnNoS2RjMzYxaTRCN29nYzJDTVU3Vk1nWFFO?=
 =?utf-8?Q?20McTAsOIdkJZQvEsMfRb8l2xZIoLF1LH3heo?=
X-Exchange-RoutingPolicyChecked:
	WRdzX61i/3KDmtJYLDK90Bf4gkWWlgeQXQKX4r8Z747e3/JjPJZRwKAeBi+vWi6CNPejOvH7C3PU5bqbjN0auj/KSDWD40Vg7uGYvkLJj/6ke8T6GgDL3LXIkeu0HoD0rZKbJX1BMfa7lOb2jNSGzW+1ofoBtLxWaa+PiCZpVMMgsBP7a5Qw1EZ+iJzI5XeNMnUtiehlW/ReOTx0PTsz+/dgTZHRJuYhVLD3EaD1xs3EegEMKWJ5UFyvyFigq7Gq17t2AGW2ryBtVqQZRWL2d88oFyFDzL6bE14ns/j0utSwszzXdX7Zmn/+qdhA78AHaaKp6kMbc2EUmKTlFlf2+w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vdrz7gvh7gqib2KJ5wBDnFij1XsL1P5AN4NkFA4CnnclJfVSfku9Y6JPcJ6sozb8iRCMEHh/MeLMp2aO+QFQeQlTZWFG8+5h60D5cjTpUFwyUZrDDXT9FfrUfuhgptMaxOAHclZY17fH3IltNN5m6wYDqFmZABUwos9gZmNaybC3ZC+gmhjnrPpCCp1TLvBjWjE8JZxkmfrbpR4pxgj/5AQIH1MhwWM2fbQXkgT8S9FrGEDZx9I8hvV9OE5QaOOz0v0gP7NOqyCTk35KumEK7tEZDu5D0TKgMc6XXGm6NglnjRLQyGMoxwC3tp9l2cboOw/PCB+hShq4Y4xTk+VASpZNgywVo9Ri7AEyyvAoJm6bODwQsN+FcTsV7W+/iv5naOg6U7pZ39/GAVx8PI6N5q1BvzhvhKhIl84kqhhFaejqEI1Z0vod83MnY66VEigwAwZicMhTNtwQq2Rh1W9+jNQSdzSaej4ViH32Z6zoUA/GpZa+NcUy9kI+xJgUL/1mmIflB0On8vvlY3E+Jadu3lyaoKS2Ejfv0NHJCH0D8aaRl128WPG5b56pj6y0DmrcNcjx2QDGCTNErqyOa1PrEL4ZeU4FPJMB+zcHJGBZ1Lc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b47aebe-5e5c-423f-3add-08de9477e3cf
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 07:32:57.9386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCbBLOAfn5GZ34KwwrsNK3ovBn6PBY2GQ6W6AZ+8tc2wpy35qmrYAFsfWpWGgdQVqdbycevgPHkIieJYdrTjm+KYPD0R7dzlREF78PYbUAFeEK8RNuvw31VfQ/zysMTj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=960 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604070068
X-Proofpoint-ORIG-GUID: Mo3fcCtY4WssmMuXagg52itf1t4hgrX9
X-Proofpoint-GUID: Mo3fcCtY4WssmMuXagg52itf1t4hgrX9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDA2NyBTYWx0ZWRfX42dQ7LMQqQlx
 Z7/UWt0lrAD4Q+wh/avVZMRas2DS/cGO9SXkp8BspxyWbuc3zSf0RRdPhCTaMUTR2TIjkVOWW6c
 Zsk8wN5fbzBRKiiwLkoGx2Wigrc+rQWkh40BZmOSc2HLIAFsKp8vvEFBHR1suWJXlo0iBB2EFgh
 t0XtotqTWF2Xj5MicVSw59mTFA3XrW9DLgcQ8FAck9EplBgvQ2epHYXl7UAm3S6IpZhfKtbj0oq
 mDF5CAXAWHwrY2/neKA0TkYs+YgF4XCDBuPEBvO9Ap4DKExz98+7if7yM7Ptpq4x4wADXLt28+b
 8NijugGl6L+Pbo4ew3mK4ghI7fAjp0QB2byvlhAy+PsPux1RNbZA/QJfgvygtdHBYOlEgJbVexN
 03KWSuHohL37H1wP45PkjBBDEsSnT9unH7g49KZTFaM3eCQ/zGFOE7ZVDFC6Hg8ka/0lutvP3nu
 pJKeLzTizhXYINi2g24rlnoNRZ5m8iCUuQNrEYQU=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d4b347 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=wVtRmF4uRXkrm_P4lJ8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291

Hi Sasha,


On 06/04/26 22:38, Sasha Levin wrote:
>> I agree this has no effect, but couldn't we just say, the reason we 
>> never backported it because we never have the broken commit(vulnerable 
>> commit) backported ?
> 
> That's the correct response we should give, yes, but the question is how 
> do we
> store this information in a way that is easily accessible to us later 
> without
> having to dig through the tree.

Got it. Will think through as well and share if I get any idea on this.

Thanks for sharing your thoughts.


Regards,
Harshit

