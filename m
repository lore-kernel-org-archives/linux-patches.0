Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82EB22127C
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657761; cv=fail; b=Lk2dxqeDaAEP9dleXami5h26gEnm6FcRCEMmatI/6OtIRIOmW6V+1mB1vHcT9DwaVcfauCVNLZtFew6q8PFmY2a1OVtpANakvytHMljnd28QrstS/eb/UaQ3X4OP4WIWnPbWCr6EwvTydcxiufmhRd040jbyvwyrcqJn3DVCpSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657761; c=relaxed/simple;
	bh=AZDkDMAVAiytDqTIw7D8kVOoyqbmENQ7K2ICHIZ9e6g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UaUolc81fAQ+InnJeoM1/00kJ8PlNkN3tdF5KupA7PhGa+1MQ8dCaWpnW7JxF/y1dp7dSGKi0l4rycG7NzExvkE2qbC0p+0wE7SvCZzYdUpAD2f7ZcJLIkvE6udIwAfMrlitWb3KOpRwS0i6uC3fqADWMArvPDQg2uOrDaD93oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JklwvBhp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h8PZFaXk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JklwvBhp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h8PZFaXk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56G7fvqD004732;
	Wed, 16 Jul 2025 09:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hAs/3YtKTrMGB/KpLpJXoknrCkdR5sM29ImL5mkdQfE=; b=
	JklwvBhp4HPE3JPZgqDnNsuCrpNd+71BV3gd9S0csO2CTiAtD21RpJzerKbmx76q
	Bhq+VfoO6UtZarwwWU554LCgqNslmJjUMYH3p3TCDPHM7A+uUL4zzKmE1NToRpU0
	ZjEDcX876udfxXviN5aJ+7vrb0ovujyUJOfIF8T5eV+oczel8aMdvdsXB7N7iSDd
	lUlHqI8Uy74xjay3oatkvekt87IpXIrxV2NpPES4yX1xkJOyXDzv/fI/waVlizC5
	4EkdITX+nqHcSf7HWH6rpoVk1X8YUhzlRjfB4Ke78NwdS3OYNhvigXuxoO9UMx+8
	ZcarfowcgyVeTi4IQmkcGA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uhx80rjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 09:22:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56G81ltl012988;
	Wed, 16 Jul 2025 09:22:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5am82g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 09:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ysKobmzkCov7kVskLQnciXT3SZZoXhzeLka+DNvQ9IZhXBSlaMrMvAr/e+UCgs9X/dakm5bcHdRJGJaXcsCfKOvn1S94l1EXXjISPfUIDpV71YHomCo3Hyiy0oyFlDSQW7QRCN5D+wQMxVh84v38T+ZXSfq4jWLlD0LV4+wFCs9isFp55l0DjJPd/S8U7NnrVKzfQdyx2J9izH0WsKLFFk2qHgXUgPtrVCq5dpYLyHNaiV5pqw5qL2OEyGK1Olx0E0OaB0DxGF78Z2djxuOa1CZGpx+BXM26wgvSYcRu7aIC0JRW65l+3ZjzHho7Cs8VVB0dx4DW/jMdYXkupzy6CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAs/3YtKTrMGB/KpLpJXoknrCkdR5sM29ImL5mkdQfE=;
 b=u2VYljGVeP4rm6zw0NfHJawVm++lGJn5jo36kW+IQk28WhX7WBZcMn4fzm+SMPr0X0maaMloQ7yF7ZOyXhuV4ReDhFyKj+nwoZwL8B+rBpf4fceqe0v7sP5/GQXb7wfWrVM2pV7nVzPYei6fpLUIqeynzf96jVYt4a38yozYiGJ4MDB4AD6VpKk/nCFgK+ZWjB6r3QpTtd3CYJHxjEKjyYpZc+10DzilbMgsgmkHf9Vp71Pm1bArjR2/o2CrxZ3UXGg5SfwoelPojjCQ9ENyQBhvwEm7UdNd0+wdQIbufKeUP99myU5SlxWH2wYnbwEvXklelZfg65z2jwGwQdL2IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAs/3YtKTrMGB/KpLpJXoknrCkdR5sM29ImL5mkdQfE=;
 b=h8PZFaXkhho280qvSCse7CKhaGg2eZQPPWsfX5HeX6krplwI0IpBLlMkJGkc+51qEvW52vfjGCa0grnVb2aiKEIW88guVEDLhjT5BT/+wlaD3jTHkkVSVE69AQTSdRY1PUD6uvlub5z+rv7SdMQulQ9y0v7tMHUj4P8KLFVxbZo=
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17) by DS0PR10MB7361.namprd10.prod.outlook.com
 (2603:10b6:8:f8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 09:22:26 +0000
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428]) by CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 09:22:26 +0000
Message-ID: <c9d7db5d-762c-4f5a-a71e-fe8f9385d85c@oracle.com>
Date: Wed, 16 Jul 2025 14:52:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/111] 6.6.99-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Jann Horn <jannh@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
References: <20250715163542.059429276@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250715163542.059429276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0241.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::12) To CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2310:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: b4797517-7408-4db7-5269-08ddc44a4736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzBkOU5odzJtQTNGdURMbHNIUnRvc1FTTlBXZzNmMnpKdnBUajlUMy9WWFpx?=
 =?utf-8?B?aThHQ0NQVjlrMmpPdzZRMXEyOUpUMXFOVHlQRGI2amdTMmZvN1FNRStHU3do?=
 =?utf-8?B?enRnQnZZZTl0RVZvOGdqTlloaFkzZE0yRzhaSmwyVEJFQmtiSzJXM3NlODRv?=
 =?utf-8?B?Qno3YUhRVDk0elBOM3BjQXh6VFpUeWNTbXp2WUtrUzAvMVFmVEpxaWt2WmNR?=
 =?utf-8?B?bmh5VW1JNDdvblc0ZTFsVHFHdVByWHdZNEhsbnFHV3ZmVi8yRFI0T2YvMS9j?=
 =?utf-8?B?VUhtNzNZc0NOSDNnNGxWUlp1RmlkYit3RWprV3lrKzYzVzR1OTljWHp5c2du?=
 =?utf-8?B?RHhlTkFtVXUzQ2kzYXIxTUZ4c1ZJYm9pOEFhckJGbFVXMzN6Uis4U0xlZHEy?=
 =?utf-8?B?VVE4KzdNMGRsdk1EZ2gxS29mcngySTFpTUtacExxK1J6cjNJbzJ0TnV1bXlD?=
 =?utf-8?B?cVZ3K25wM2Y1UUxxblphN2x1bEs2K1dGZVJaQU9wamRzN3ZHUWR6K2tXSTlv?=
 =?utf-8?B?VkZ1ZzltK285NTBPMC9nN1piQndaYVFpbm5PRE5UL3JuclVhZXlwOVZnV2JJ?=
 =?utf-8?B?cklVL3FvVzdSQ3FjRFE1cHRUdk9ZbGxDTEwwT3BtNzZzTGtLWGFZYkVtZGs5?=
 =?utf-8?B?SE9WVTZqLzBFNEJTYVU4MFpVOUVlMDlyMFJPd1BuRVE3cDJEZ1RrZTBKZ2Fs?=
 =?utf-8?B?YjRMbS95cFZVY3E0K09kSUV5RDdOY2hsUXNSSi9wcmJlRmNHSkdPL3J2K281?=
 =?utf-8?B?VDJhVXgvdFA1OFg1T0l1aGh1Z01UTmpYbnJ1OHZjUFdFamxGcit2WUw1Zm5p?=
 =?utf-8?B?S3YramY5R3gycmk3ZjJnUlAzRTE4VGgyVk1GTTIxa3lNaGR6UEtGRml1ZDZO?=
 =?utf-8?B?OEJnUWU2eElqZkZMblpXR0VNQVJiOXA1M1pIMkdsUW9NV3MxQ21VYVViUW51?=
 =?utf-8?B?YnhXczBjMjZoWXhuSVJFSFdZdk5RaFVIVUJiMCtyeEhsR2c5TDJ1eGEyeWNX?=
 =?utf-8?B?RXg2OFp5YVZiSkcvZWsvWUJxN1RJcVgwZW9peUZuMENwU05CSFFFcEJvRVp3?=
 =?utf-8?B?OHJKOHZ3MnVXM3QrMUhUTk9wdy9ma3pHZG5tcm9FQklHWlZsaUt1ZWhkYUE0?=
 =?utf-8?B?VGxVQ2M0RWVCWmF2YzRLNzY0WlVtclVQNW9zSEwxcXlobXgwdEFrWlltZnZC?=
 =?utf-8?B?aUxKNWhUOUdLajM5RE10d1UzTWJSdlF3dEhBSld0NjU5M3JpdVFWNitMMXh0?=
 =?utf-8?B?eURES3Zic1FKZlZCQ0JrWFk2dm1QOFVOMEF0ODZPNGhmMEhFVTRNcVNkTGlV?=
 =?utf-8?B?V29CNnVQR1V4a1lKVDlSZUxHTGtDRk16OEpwQWMyZTNKc2t6UWEweTBzbnNY?=
 =?utf-8?B?SE5pOE5seVluK3Y3OHNOU0g5QTAvQ0dQWTFNa3ZUWGt0THdKYlJFNVE5YjBL?=
 =?utf-8?B?V2lOeFIxM2o3RW94NUQxM0t6Yy9VZU5uYmtBZkk1WDNpcStGSzRvSmtJVlFP?=
 =?utf-8?B?bCtpM2ROZ3FzTmdXYm5maXo2ZktiSHFldjJML2RFVnBBb2RTSUR3YkdEM0l0?=
 =?utf-8?B?bmlUNzNJb1B0NTJiUXVQbHlXU0hFYzZhcXVpSU5lSlVaZDAwWWNSNjVDLytw?=
 =?utf-8?B?NG92d2tHcUxiUnRXS3JWaXBsVUtHOUNnRW1MUUxuZ1dvcm5TejdBR3ZXSXpy?=
 =?utf-8?B?RkpxOG1relR6R3puUE9KQlBWaWFjcWRYZ0RYdWU5emxmTWorcmx5aDdSUnhq?=
 =?utf-8?B?eFpxdTZHVWhnQkJqTG1zREQ1dHQ2Y0wxaTJYbVJIQ1BrOFdxdzhuc1NDakk3?=
 =?utf-8?B?YnR6OHY2L0pJSmhaNzJNTTZNRVd1TzFVRjFLMmJmTHJCckQrM1hlSDVhbjBQ?=
 =?utf-8?B?a0Z4UEI4eW9uSm9wWUN5VVZneTBXTFRQc1RpanFaa1RvM2FLa0MzWG9ZRGhm?=
 =?utf-8?Q?2IaBP5gYhkQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2310.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWRaUzlRUEF1MHhXS3RsZTVESm94ZDZBcjYzYWJkeU9tM3o5UVI5SFdidXFI?=
 =?utf-8?B?ejh5UUFxYThscTBSWTJxRWVienptYkdQdTR5ancyeC8ydzZRYTlSSWtqWXJh?=
 =?utf-8?B?b3lDczdKb3VBcWxNTFRaWlRzUTNjOEg3NFBiMFA4RXZWOGljaDRJVnVyMjQv?=
 =?utf-8?B?QUJ1TzMxMmJ6cVc4S1NQdXp6UFRQOXEzNU5saVY3aDN2TytNeHp6NlNYcFUv?=
 =?utf-8?B?emxWQnRlcmd0SHlZUENrZU5YUGhuWUxhMitUVStDdTdWQVdvQ1o5U3kxeXd3?=
 =?utf-8?B?Um9UNDFWenV3aUVBSUZob3MrcTlYc3hNbG8yTDYvNlFrTElaOFNaU2tVQ0Jj?=
 =?utf-8?B?U240SVIyOVhJSmc5a2Y3R04xdjZXWHFFQ2MvbEhMZWlpT2FUNklJKzVvd0gr?=
 =?utf-8?B?WUJtQW53ZXNxNDVIeVFuTTJhSTBwenhVcHFZeHNvV2ZJY2RMdXA0NlYzUGZl?=
 =?utf-8?B?a2JRdlR2bGNlVWdsK01GR1JVZ0RjUDQyc0tDOUdhZWp2OExsM054YXdIUkpC?=
 =?utf-8?B?ditrZUZ1U3cvT2dmQlVRc2IxZFpoQURqMDlKc1NTRjRIZXlKcjU2UEMwczVV?=
 =?utf-8?B?TlFLVnRHVHJleGhPeFNGTEg0SjVWRWMwa0prUktaSDNSNWQzVHFMekQrbjBZ?=
 =?utf-8?B?U250ek4yVDNNazVsSVRYcFdjek9WS29VQjlIK1lPSW5COFpSbngvTWltbnFQ?=
 =?utf-8?B?UzBWUk51M3VMZ3cwRUxOd1NFZXk3L3pXVlpFR2J2UU9XL3dybUlnWElmcHdE?=
 =?utf-8?B?NkdGSnJqUG5JN0JSSWs1c2FiTWRsQm04LzhkSVVYT2ErSEZaTkFJa2VCUDhu?=
 =?utf-8?B?YzljY1pSYVdJVzMwODk5VjVXQTdJbXlmQm5EYVhJU1o4QUlyd0JCcVpRTmtN?=
 =?utf-8?B?WC9zMjJ3anNPZmZKRXpuenl1M0JVa2tHVUlDdTZNcS9kSnNyeE9lY2JUUXR0?=
 =?utf-8?B?cnAvakZiS2xlcmVOZ1BRWGI5NVJJenVwT2lCOHB5MTVzZ0RKTkI0VTM2aXN1?=
 =?utf-8?B?alR4VU1VSHU1SEpXKzB1TisxT1Q4cmdQbGd3RVlJSFV5VGlub04wTFM0VThO?=
 =?utf-8?B?MFRFNi92c0U3aDhQK3JtUllyVnR5d0dNcFZyY1dMSUtTUEFTK0JqUXhsbnhY?=
 =?utf-8?B?cVJyWEtZazVDSmM5QUNrTGhmZTkvdnVSbGd0RE95VlpBYnRmSmY5OWVYVEN2?=
 =?utf-8?B?NHRQaTc5TTFYWExLWGJrSHBpWGo4djlEK3dsTzFUUzQwS1ozZEpvakdiRzdp?=
 =?utf-8?B?ZUdvTVVqNG8wTUFVVTdZa1NSVXYzSE12ZE5OYnpYeVRiV1g4aWx0TzhJNEZC?=
 =?utf-8?B?bHo2ZXl3NEVScGtjc0ExVXFiU1RUTE55VmNVS00xTkdEaWxqdHNMcW81cGJM?=
 =?utf-8?B?L3dQUVRKMlY0NlZrcUY3Z1h6TnBFKzFMUHE4L3g5QmFmb3FyR2xNbnErZkVS?=
 =?utf-8?B?OWh6ZFdHdnEyZ3BJVnVDQjNsWlpvdGdxZ1E0U1FkSjZxK2tvYXlwaU1rRkt5?=
 =?utf-8?B?WFFJdGZjYk5UVUtXRmVTdnB1RzBYcjdsclpBTDJRSzVEYjZwYVJMRC9GR1Fk?=
 =?utf-8?B?RGRkMGdpcnJNNHBpUVZBVGRVN2NUNkppaUZONWJwNDZOelJvUEpHV1NBWHJ0?=
 =?utf-8?B?SDE4Q05DUjNZazdONWxQS3p6d2pDekVrRUQxV3ZXVFZUMmRIMEZJQ1FXQWxx?=
 =?utf-8?B?emZmbnh2d3Brei9pWEtFM1hEb3htUXRKNlVUMDBlMUo2YVcvSGpIVTBEVTkx?=
 =?utf-8?B?RndVa0tDcXFXQVIyNEVrUGlsdmpCQThUNllFbkVqQXYwb3VMU0ZOd2EzTWVL?=
 =?utf-8?B?RnpsMmVEYndjSEhwdnhrUDNFUkhVZTB6Ym9zNStEY3ovVTd5aWlNQ05uREpW?=
 =?utf-8?B?dUV3UncyMTNIZmNPYWttcEhtV3EyazlKbkxCeWRnWEZUWVlDeTdtNHY2eElk?=
 =?utf-8?B?TzFVcnhKbHhLb3l2ZHR6aFp5UUtVdTgzRjhLbVlIcUVrQ1RWV3lva0hxemVt?=
 =?utf-8?B?cUVDVG5sUERkVHB5RzFsNXU5Um9UdWduTjZEYVRZQWgvQ0RraWFwbGphSUFV?=
 =?utf-8?B?RlRYK3grNklWSmg2bUxMVmRQSWd2R09Sd3plTXAxQ2xJYytQUU5VMXVneFB6?=
 =?utf-8?B?Vm0yMXpTbXJuRFJ2Mk85MnhTM3VtRHB0SG4vTGUyOHZGY0lGNlRpSmd6cXhX?=
 =?utf-8?Q?SFNAy4b6GiTWufARuqhvp1k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w5anTmre2wRerio1n2pTXBbYhD1w5A+41xMYpCOFmkI8ey67jTye1VDFkddi4SlYhgpAQRgZdZVzfMYTUJkh/9HUtrKl9J39HQmE/puxq1EJ7LdN/vTvl1CT4BsaS1AFJ/8aYv5HhmA1Y3pWzri5LnCR9w0lq64g8iYUvniz21S7rumVXGKIKfgp0ivILUdD5a84O8dMhiWSTADn3iXncpgNUwefj4p7DNtDUiibxV/3s2s022hzNJCjQN5k6mextbO3yk0jhoWAUjM+BqRRS5I0AUSFKvu/RG84dimkk2vJRCm9y2uj7kn7CVr9HIJu1osQv5KvJ+6IGYzbTd06Xjef3FG59Sv0KyzI9Y2DQDv22jje2aFlF4OTfG+mpCAD7uvK3CmFIykQoWUatsx9vLKnL1Hq5OrtEY2bAoe+aeOc0KJiWIuOR41j++D/SzVDrxaeWA4+DbwbClN+bsPf28BL3Z2evnYYh6ZECANbS2Sn1RG4Gn6ZmDfVHdMP09+D4wXfFEJWU+ykTX7jnUoZnnJtwsuk3vZKyUurDt5NREyg66CdxDkc4ulyHxUv/ftmeiF+9SS7E50gdnpVMexi2Evkieus3qhYJvHUeGXS3Tw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4797517-7408-4db7-5269-08ddc44a4736
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2310.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 09:22:26.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vn2xo0y6YvVrJcm1xtxmqInCpJBwmLOFR717FkVVrS4Xiu/CzIXHegf53hZMGT5QphHf+yKxTLxV1ScPpLhxj/9BcE8W64A4nG6QmhMS4JmKhel4E8CvTLAXPH+uG78m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-16_01,2025-07-15_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507160083
X-Authority-Analysis: v=2.4 cv=auKyCTZV c=1 sm=1 tr=0 ts=68776f55 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=4zGr2OSdhf4Ttba-gDwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12061
X-Proofpoint-ORIG-GUID: nmy88Gzbj5fd6l-I4MGpMU4YoVPFg_Jy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE2MDA4MyBTYWx0ZWRfX0OZcQUQv4TEH 1MQMYhEZt3QRTxKAednvYjzItZWFg2O69entDhvyDvlyU6v8jjdqEUSgjKKDoTzwkKkaUe4AqJn oTjZUuIU97C84dqz0OWWUfGt+ol3N0Yyqz3LSGxx4s6VuWXeBTmhHVYAjVg9/phxgOSNYvWtYY6
 kCzolx3KXIOiqh4tz/Nf39aOxG2fIduJ22PpXk2HwgqsqVLLWiQ+DQkjYgEn3zgdXv5/i/m/6AR KYCxpqvlbngi8aDdhcWh8n2DJDtKMt8fDE2URvxuNT15pzmKQXQaLCoJutV2WquAUd74znYuEV7 OhQehAhar6QgmtPy+eOFs38ZMpxQ7CgD6pHPVmCVSevWQTBSqihPuZjwaIiPCdFbXj/Esonzy6k
 N9nQOHcnM1Ho1nHJvwkAO6TViNYF8iBgL3By4qxBpd0coQCa26OLNpsWHcXLRPKw+GFzPgci
X-Proofpoint-GUID: nmy88Gzbj5fd6l-I4MGpMU4YoVPFg_Jy

Hi Greg,
On 15/07/25 22:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.99 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:12 +0000.
> Anything received after that time might be too late.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
