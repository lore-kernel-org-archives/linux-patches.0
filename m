Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4C3B27C6;
	Fri, 17 Apr 2026 08:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776415026; cv=fail; b=mb5Ed9dzGSvpeY6Ee/yQhIiaKyPSZpLnS14JfPEQg3L5DeVlbx4MrqtmuZYAu5Qi4J0/TlRq0Bqyv7UGq2XePnNvnJOlpiuX8aSq8gxY1U0JWSh4dijnQdt6mZX3Wsb2hzqZNHfFzA/dOWeRQOBD+huoltiCFFbyZFQVhG1CsG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776415026; c=relaxed/simple;
	bh=yJ0ojdieEV3etl8sXgcpoC0XJV2yDkhByRtSZZQEfUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IT/tMLxGcl9KlV/gGi66A8IRX0adOLImbCUgN9aafSRrmFIovQVQfKmOYcmK1pmIsmr89mqv3czMdGOFJG7Ss5kkepzdCJjIYCzWIy3H+0vdZo4oRKWtZFrWQhEgCA/DG0O0cUl+CGdAd18EijclBIHe3kro9z6ZjWo/dJstR+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YGM0XFwT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rGzfUlig; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YGM0XFwT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rGzfUlig"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GLtM3D693832;
	Fri, 17 Apr 2026 08:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QpL8vjOIudsHduQj62QNSYIhj3ViHni9YQ6MakuJKeA=; b=
	YGM0XFwT/eQ+/AUd1MGPj42+2W3xcJ3bxL6WKn4IQVDuClU8I84UyWU/t6LYnuNp
	9gtWR1wCdUcEQDuTlnQotp+KBzpVZre24ySYQUT/AXyyp1K7D8IRX0REY4HAZvPx
	adf7YBGhtqa+ntf6WDFyChoRSmigePuLGWn6SpzqK0Sx6Y68e5WgsQf+YC0T/n1U
	JjzHWvGw693bbHBJaRri3947IKoZcBCAHD9dyOrYen1ThoGshsEwn2QpHHF0jZmi
	47BVZjdzHNpuG+3U7FBUWW+ayWOkz3fTshPoV9q+pqvppHjcodhlwT6uRRItENlF
	R8+g+DLM7OGeKDUVG4phWw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh8689kdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 08:36:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63H8YN26002432;
	Fri, 17 Apr 2026 08:36:34 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nrj4jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 08:36:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nonKq9Jn2/OU6IFhKY/2iPBVk+sIclybKGdmWFtdP7e2dq2EuzB+JxeaMIIWj8rLLj9ahjZhl3TL4zfWXLwPHx9XRlsEyqhzob4PUXRUyEP8OS3mPz9ZbEnzFMSPhHABoRvIr481m4adoFDK5f4F++cryD5Bj/C4dZEbZiBGd72v7+2uuGWbw/VxudYHCA6go5LLh+IKOPrwvXtyNPgZejF1HPaA4njsAxGbHUkZrHIWG4J6vvjcYrCffbqBFuLsDIX2K36lePWpHX18iSgSItHLm/zMHh89cfCU/QIT14APL2U3ZP2FUwrt5mFel6hCBOf4mlPHWyyqT9nGl4z9DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpL8vjOIudsHduQj62QNSYIhj3ViHni9YQ6MakuJKeA=;
 b=WUzqKit8cO+O1CKVvjopD2iULpGwSgjFs9G98qkxn41JAD4JkzcIiPyNbWVNfvI5zMQ+TZwHis8eWjHGiuFdpTzNXiN4OoXE7mO0FkFlJ6I3TILnxv68b8AHW5Jty1GMKvGwjGviMCCXfKJYaLLtD+M8rbGuoqkh7dCmz54HkFdHKUvlVPVFltTElhpFTOkXrx7j/Hj3OOH5gYHtA241oiOv2wcZeK814bgckUvMtSgmBKCQHQHoNXraANDvZjIqNSDfuAL7yxx+X4IoN8cvokfwkvS+Yjky3SK5s8ObA9UVJyA1jR2icg9aViQdyO/L+xM3VvVvjdKAbpUoLyc3QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpL8vjOIudsHduQj62QNSYIhj3ViHni9YQ6MakuJKeA=;
 b=rGzfUligiWuqCk+zC3hk3m4Pmraz5syjLQ2macR4mGM6xoNHhLp2P2hkHCjRCUdUXoDWPZIRmTFNDEnBz0PRv4QprYc845MYJI+rDDIBuiu/JZxDIHcXRtivVCuZZzcJzW1DfRgveJ4ioV5wl6fnajqx1jRjrZJ1MZRxzzP1i1E=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH3PPFA3184E4F2.namprd10.prod.outlook.com (2603:10b6:518:1::7bb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Fri, 17 Apr
 2026 08:36:30 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 08:36:29 +0000
Message-ID: <a509b58a-986a-40c9-96bb-670562c0fcd0@oracle.com>
Date: Fri, 17 Apr 2026 14:06:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 177/570] scsi: core: Fix error handling for
 scsi_alloc_sdev()
To: junxiao.bi@oracle.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, John Garry <john.g.garry@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155837.087422683@linuxfoundation.org>
 <ed7ab018-9a77-4e8f-8480-cdd92c4758c5@oracle.com>
 <0c9b5caf-131a-4f47-8d9c-0fac3029e59d@oracle.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <0c9b5caf-131a-4f47-8d9c-0fac3029e59d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::10) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH3PPFA3184E4F2:EE_
X-MS-Office365-Filtering-Correlation-Id: d562cb3b-97df-468b-1f1c-08de9c5c6be5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	prYOZHmOEX5PJmkfL2TesUE+jvdpgf6xuBE6xyLEXr7cvH086l+xGjkssKADaJGJLopUx4GDqmJhYcCvPObMiJX8CLow2ykNxdiXJa03Xsm4WiXU8LS7TBXgcpgfwCH7GsW1BsUB08iFE3mEdzkaq1KGldnm8WZAhyKQWmnWZK305I/r6kVOUC7kBRd0f+K0IUqY/vTCnrfeu0Zs7XpKhkJ8TLQpP5maKdWRyH23KYf25C/EUA5dmmcZhaMSfohszafNHZIxHrqnEXZqohAsl5gPLdvS+dX7m3UG1Qu+NMieJyWK43NvOOg2I37Vv4s2rjNv2kxev0GjO+I8nWl4V5tzPJkp6V4O1n+8jWDoO9hHz3L+BCK8aNSoQyUghh1F0rYbGFr7phYNvgMdhcTuiGGVkA2O0SlqfjePyWbRoqmQJX1rGEpqHhHdCR7rQ/ZvCnvk5bzMOs6fxo11vkAi2WQWLbrIwiwj9kgTZ/JT8l5yvzmv8unPebPcUJVXC4goB4ATOY3luo+635GOl5CoOlyJyA3boslbIepVQoT6cGv/MzrfB7X/hvx8/1okIgBcVqEzrlo/rh+fGm756WWKbW+SiD6UvVc5EbrmY4VN9E/0u2nQpYfV1BUmAC9ZSV28b5bzfhhNRkK/J2Ta5+SuwX8tgUDW6eqAWvZcxyodKx5LkYJWZc5txrCIXRqyUXynvAoBLdfKkjWW8UyGDJNBR8z5nUFhFFtAm7qc5hOvS7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bG12SXBSVGRwRjNhRDgrZklQejVmYXVScTZJbEV5aTJjbkR2eUJzeHQwL3F2?=
 =?utf-8?B?Q1hCbzl0YndBMkVNVC9hWkUrdEI2VlpOR3ZFQUQzblRucHlKamdKdWZ4Tmsv?=
 =?utf-8?B?TVQwTkhCUm8wYktLTWtpK0Q0enptZ0FuV2tYaUJpdXdsZSs2QXh3UTNEbE1P?=
 =?utf-8?B?RVQ0V3h3RFMrVEFTZ3dKSVpFc3kyeWxhRmtWbUVqNERiVkk2UG1VK0x1eVJP?=
 =?utf-8?B?YU8yNVFWSjBqS2RBYmhEK29SRC9wYXQxSTFRM0Y5d2k0b3FRK3R6elU1UkRa?=
 =?utf-8?B?TElVR1o4WWhZdFVPaStnS0lZMjlLYkR5OGMxMHJCS2xhRUw5akZuS0VWWlRs?=
 =?utf-8?B?eC9jeUo5b21oOWdOaW1QUDY4UlJ1TitzemhXRURiYlBJME83YWNTMWFIZThi?=
 =?utf-8?B?Z25FT1UxNDhIQi9KSFUrQ0lwVVlNbUE3Mm80MG1XUjUyektGT1greXpUTTRW?=
 =?utf-8?B?YzdyZU01emEzcDUxZnpZU2pFU29uYjJBVHo1SmNsTlJsbEVJSk9yaWNTTjI4?=
 =?utf-8?B?TndZNStWelVTTktiK1pmanVaNWh1dmRBZmI5Mlc1TGYvNlo4RExyMHNoaThJ?=
 =?utf-8?B?M2crVzVIQ0NWLzRabWZyN3dKeDhQeWlqU2Vtem5TaXZiZHNudnEyV3BGZE1l?=
 =?utf-8?B?V3dvK2RhWWVUQW5jSysyN1ZPSG9DWVhNUlJjYmloK2NDRnErR0ZRKzBhYWll?=
 =?utf-8?B?dy9IaEJ2S25TK2VkVUdpVHB1SUdYKzdsbEw5NmkrR1oxSjEza3kycndCQzJj?=
 =?utf-8?B?NUxtOHlaKzBkdmlNZjkzRnRJZGVtTVprVGJ2T1hTbTJDdktCaGdKdXFPY2Ux?=
 =?utf-8?B?RGd4TTI5NjF0b0dhc0M2NlJyeGFxTnRlb3NkcDlvb0hVVVc1VzZ3MFJlZGFS?=
 =?utf-8?B?WFg1U1ZGM2c0SGRHTGtYNlR3VjE2ZURkYlVRODJ1b291L1FZQXJQYmttQlVM?=
 =?utf-8?B?K0Z1c25Fb2oxZGxDMWZhQkVPblNCMmpEZTBJWUFUVDFQbWhtOTN3VDc3Yy9h?=
 =?utf-8?B?OWlwaW4vSkV2cVQvUjE5VU41RVRYbnFkQ1BLZmFBTE9FbVlHZkRiQXY4OFQ5?=
 =?utf-8?B?eXJYeDFHQ1RzNCthVUJPNE4rNmd3dHRJRllKOTB2UGtRQktndUptdU1neHFs?=
 =?utf-8?B?bk1qcFNGTHBjUnRRVGF5T0l2TDJQMklmdnFmeUF3Z25Yc05nQjVhVzhiSnYr?=
 =?utf-8?B?YXlyVytVTytqd3FlNHZBY0ltWnM0M0VjbzdSeXlCT1VTTGg3Q3VQcExzb05u?=
 =?utf-8?B?WkVYRWt2a1krYjVzQkZISlFnTk5nRWxLVVhmdVBGTkp1czJaUm9IMHArYm1P?=
 =?utf-8?B?dWNTZGtEcFlDc0VSRjVSRGtNT3o1WndkZG5lRzJSYXQwS0FGb2xabzYzWmVm?=
 =?utf-8?B?VjluM2QrVXA2bkFQd2FKTTZ1RFJVNGR3OEI4L1R0SGhjWDFXOUZlSzJyemNx?=
 =?utf-8?B?Z1RmY21mY3NJVEhpYjc4QUpzc0NBc084NEtEbHBXV29ESmUyTVNqRkpJQVY0?=
 =?utf-8?B?Rys4b1Q0a2pJUnM3c1NrZEZuWHdSeUlyZGF1QVJtTkthNExsSzBTbkwyNG92?=
 =?utf-8?B?c3U2dkxtYlBtZjltcnBxUndQN2RIcFhsTFZhQWpCUi8yMjl5eTlMRm5XbTJl?=
 =?utf-8?B?NEh6WlZxR0FJOXdyQXhBenN0aTVWcitQMHRhS2JFYWl2Nno5WEpNMnB1WHA5?=
 =?utf-8?B?alNTRTZUMEE0UW1CbTM3MU4zS3F0amVwNUJiN1RlZ29xbUZ1dW80NTNUblZ0?=
 =?utf-8?B?MVo3K3VkcW43WDBhcDJLOXo2amduYW5ETWFLczZ0bEtrNmdOekxIY1N0b2Jr?=
 =?utf-8?B?ZGdlOW12K2I3SEY4MFJkNnpuN0NUdXhaN3FKMWNvQ09aRTJ6dmRWQzJJcHY4?=
 =?utf-8?B?NGpaM1Z1ZjRsQUNhU1NGNW51MWthelFkbm1CeVZsWjJ1WjRRUHBwc1BYbTg5?=
 =?utf-8?B?OENINWFvNW9pTXRkUk5GeUZ2cHAvY3JGNG9LNUJVSHdSdGJLb1haaE1ENXBO?=
 =?utf-8?B?alcxRitMcUR0ekFyd1VzcjNxcGVWZ2VPZ3J2Q2hmZ29JdE5YK1BmQzZkeWY1?=
 =?utf-8?B?THExbjV2eStLcGJuc1MreXFhY2ppVThwclJMeTY0UWRqMjQ0WUtMTXZZWUY1?=
 =?utf-8?B?Vks3Mi9oMnU3SWVPc0lEN1JGbUZjeVI5YkpXQUhELzFzcE9vV1FpUGhkTjJh?=
 =?utf-8?B?SjRJWVpoTjl1QzV4U0U4cDR5STVUVkdjbDNGdFpremxlYkZNbTVrY2RSU3hs?=
 =?utf-8?B?VWMwRVVhdG0vOFpzU0RaWFY0emdNandqMGdsdCtWLzYveDFvSDZRaTZ6dHJ3?=
 =?utf-8?B?c3I3WUtLN2F3ZnFCY1BzZXduWWpCSzVuYkhuMWN5MUduY0lZeUYrQzZkQS9G?=
 =?utf-8?Q?D/lkQBAvn3DCD2HD1liiOFyGpO6GpnoGovGH0?=
X-Exchange-RoutingPolicyChecked:
	BbptuVUVzdYCWfWJK+ffKoEm6/MlJrvOnNli5jJVZyAD2rVi/BvQNosAe+XEnY/wsBfNRM49KY1G8JFL0ChsJLmJtLCIP+edeXj9K42iT3I4petAqL7bji6UdooXJgZef8VI2rZJNMA1OOjPMDFP0fz0uZI8bsvdWVIN+eVkCbzgcpvfhvXQ7knWThCVaH8n5tLcvIzoAnaOWdPQTu1tbuHPUNp7+ht7DrCdFPLCHP+incFqFH8LLpcB/zbTBnuH0tyv3Q6CN2Cz4FtH0CD/ZseSAbSGHf8wH8VLPMT/iT5kI0dwFtkfbp3nQyVCs8po6Xiz/o1ROnd8gY2xkNM1hw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s8a4bp6QgXUITCB2vFEYEQb9VGL0JeH3VieKrOuK8v6Ga6xos8vmX+Z8V7DelOxaIAa3OUkjgcgZ8fOwn7LbiF4GHhKpoDM/jRB2iHuCGlYipWORdDUODIgyykCenw2PAhKR+/pnQkZMINwQspOQADXRdTMPiPiKGTz7+NM3eL4F+Ge0ar+UXUYwwnTsfuwUfHFDhkK+/JsOw2W1pESPF5cGw0GlSPTvUiA4v+VWZ9cGH/mbpXNUF2ArU89W5adn8JKeH8HKMLl5iJYo0Dyw1ABPpk4wu6ng+4OEl9vT7/aDYhX6B+S84Jc1ZYN5hB+74RLqT53zb3/dsgmIAInP5fEZ2q9RORRRjr+jyUXOB6J2oP6hVpslcaU1ABqe9EGOJcX+KgU9KMLW8N0vCFbG3QBAJwCiVNEDKoj6PjSetZFxRD6h3jZWqMzX3zduvchQNPLy4xqwcKFvF09BMfYky9iX72rDdZEUhhcKmsVjmXtiFgOc9X6xMcayOX0tgt1REPFSBnp2mAfZg7Wjgt9A7ucfUkSOPJuknBrLqGYvSRy/Jkcf+LBvSMVGK/Li9oel5PmWpw7ZVxAyFhCR7tzBIHT8H4hS/M08AAJQ2HGEfOM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d562cb3b-97df-468b-1f1c-08de9c5c6be5
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 08:36:29.5341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRzyXtuKFrcTGLE6gG7Kply5/kpvrtNJd/fe01OnN4xk1tZwRXcKy6in/+ke/m90IfsPJPZwXhBI+VFU773kVGDLBmu6UjUKSe0BHx8co0mf+jjWWrD+Hb9qo5mIUQ+V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFA3184E4F2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604070000
 definitions=main-2604170085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDA4NSBTYWx0ZWRfX/TrhF89xhV88
 W+bEGnqpF+r0BO8bNTCPK5pnbPNdqyHI4/vm8xWpFVFoeU3I6OD3pi/MnJcuiKEw4NuLmNP01j8
 eMMQfZn0Z6Yuea5m8c/o1kpvo0ZAs+Wtqr1KRsuiergi2zJItMFz8m8BRL+2ujZeBdqg4A5//es
 1RKbXI0RTZ3QXGtM5MOjWNKMLhJaRX1QsL33QxMJ6mB3hu+KGDejR6/IHSKk9l6jhGxmRPnNFEE
 fkZFiJoZSvV2QQJ9vgPGVUnIZtPizf7cZvS8dO+06fEVqEf/JIw0P9fsZjmc/Q23JstkXDzGL8f
 Of5CScwnrvpP8lR6lfkZjC+bfQJC0vsPlQ4KTJwbrB6OImCXvnDYghRBRS9yFVO5GigmjrJP9mG
 ElPNDoFnC2pZ7Y420ymT0lEa+Bx0c6/7Cz+rRFzxcypuuVJIYeClfOcOGRuqSoZJmp+jfNUtvVM
 GqNHDv/oUel2++O41cSHhIVxhHMP0d/U0hWTZpSQ=
X-Proofpoint-GUID: xKaSiZ-eiKgUcQC2RjgFcu9FBXvl3SWL
X-Proofpoint-ORIG-GUID: xKaSiZ-eiKgUcQC2RjgFcu9FBXvl3SWL
X-Authority-Analysis: v=2.4 cv=JY6Ma0KV c=1 sm=1 tr=0 ts=69e1f113 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=9N5c99XF6OqWaInu_CQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13825

Hi Junxiao,

>>> -    if (scsi_realloc_sdev_budget_map(sdev, depth)) {
>>> -        kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>>> -        put_device(&starget->dev);
>>> -        kfree(sdev);
>>> -        goto out;
>>> -    }
>>> +    if (scsi_realloc_sdev_budget_map(sdev, depth))
>>> +        goto out_device_destroy;
>>
>> I have run an AI assisted backport review and it spotted an issue: I
>> have taken a look and the issue is:
>>
>>
>> 5.15.y doesn't have commit: 21008cabc5d9 ("scsi: core: Move two 
>> statements") - v6.19-rc1 based so backporting this patch introduces 
>> something like:
>>
>>   if (scsi_realloc_sdev_budget_map(sdev, depth))
>>           goto out_device_destroy;
>>
>>   scsi_change_queue_depth(sdev, depth);
>>   scsi_sysfs_device_initialize(sdev);
>>
>>   ...
>>   out_device_destroy:
>>           __scsi_remove_device(sdev);
>>
>>
>> calling put_device() before  device_initialize(), so I think we should 
>> drop this patch in stable branches which don't have commit: 
>> 21008cabc5d9 ("scsi: core: Move two statements") in them. Upstream 
>> moved scsi_sysfs_device_initialize() above the budget_map() call.
>>
>> Thoughts ?
>>
> Right, this commit should be backported as well. Otherwise we could see 
> this warning.
> 
> "kobject: '%s' (%p): is not initialized, yet kobject_put() is being 
> called.\n"
> 


Thanks for confirming, Sasha dropped it from the stable queue for this 
release.

4th one in:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=f1885e089cd1533e346cb4845e5d6d101303dc44


Thanks,
Harshit

> Thanks,
> 
> Junxiao.
> 
>> I see the same problem in other stable branches as well.
>>
>> Thanks,
>> Harshit
>>
>>
>>>       scsi_change_queue_depth(sdev, depth);
>>>
>>>
>>>
>>

