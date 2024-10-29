Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278AF2F56
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 05:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730178376; cv=fail; b=jDziNmnx7tSTrk7l5/8Fg2CtGUjTVqFlxVQFyAKp5MF1pFT1gIe/xZixTlIgMY+6lze/RdMNQignRai/6bnT1joMNYgUZ3vkyNazAo5M2uXfeh0xDgauB8OyfxjImXJmSPHZ7MGyebc0aqAgKkvnQoZ8MRa2nb0n7CZSKHngUfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730178376; c=relaxed/simple;
	bh=LWCya+hz083ih+so1kaQ0uF/FleUD9sQ0iEkbYfBDww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dzJkPI/55m/rYYY7XUSjbZ/xd7XNATDYUjwH5W7m+MV4NRaxuTnQAJvzOjaBq11YV+3lbvnlWiBxSrYGlTw5FJYCcd9DxGLGDVDB3T5VlS1yXKUdVbcNvj5oVGMW3qFzs6axfhEZ9A6PLyB7/WwiWYRVs8BQkbXobSWaQ5UlsIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f1CZojEK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U1OqRYmh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f1CZojEK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U1OqRYmh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SKtbrP031959;
	Tue, 29 Oct 2024 05:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=7lN7+n9/+WePb85VjQG4LgoOZLKG12Uw7469kZRDm2Q=; b=
	f1CZojEKG9YhEWjydFnQJI0I58Vpn6ti5NHB5PjB4/PcwjXsRiBdZ+r0u67WbMQF
	JG8tYF5BTu0FTVx/8B05DIA4YyOai4qpMcDQuGRzVtzJoTys4Bv1z2NVW2gaWyRv
	WiTU50jrfO67W0ct6fG1pv4rWZdgho6+pZKJQJAyJ+N5ZgV4zCcuNMDlL4yeP19n
	dZUaauSTWYUXkfPWss7lNfB5lcLkIU6FwyiTnY3t5c4InPOUDylx9VuzFoOyAW0h
	mc0Kj8AJDdDIthQifgPfKpyXAHr6BninenPTOhusDiz4XZU7a+tjtsgiTGPmCICo
	vyXKK/QQnHFT+F1xbXvVVQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc8vgb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 05:05:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49T4dKKA040322;
	Tue, 29 Oct 2024 05:05:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnank2ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 05:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=drBvTLaubGeFTrDBnJK6Ml7pfGpgTy0lN001cFS2fYvucVXcM6akuatses/uSfxo298cwA8F8gDFBNE9N+JawMbLWm7Qqmo/9jOsSbNZKZIfRx0qRpvBs2M9NZgs6YbZyXCJBXzFD712WVVBPbQaQL7BsgyCJ90JcvOgho5bw7NQxGFYlQ0lJS5UONAV4P8cDiJtUqMvqLnMr862sk2uw/h9qvfL3GFzWb+qyDZS9vzvYr9mq4/157FW7RsQhg/kA3fY7SihaEOAHwHG4WwAfONo5yS1xliIxJRD196HktCVgbO8HBgQzW8ibS5AyGfbAjJbjvlnm+5lPZbmM/5T5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lN7+n9/+WePb85VjQG4LgoOZLKG12Uw7469kZRDm2Q=;
 b=aG1MIisFRyLBuH4cvkpp8dvr03Z8f+pqIwDBnnMLeCwC040et2FbWDqJgV5R2K7L5jVwU9eVEnxOlDnKrix+T+Eq+OS3elXvIbOWkW2T1oRzL9dLbsq0dmiOw7NeeCX5C3W8Bfs0tKKC64q7guvg16prVZihm5VK/bq0UBQIEakB9rahRFOdGvrZED7ZrBAK32zhsE3KEGAAF/LiQ82qZjdBmr8M8BcX5GEvq2njP5fkR1R7Dj3ED48UdrZw/WoQGBme9bbLSDj0EjzmOFDFGYVV2LcEQ6zlrNGv5XIti6Y4peHXGmxz19wJYl3TUJLjjdTAHf5tE0mP/89JIAm56Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lN7+n9/+WePb85VjQG4LgoOZLKG12Uw7469kZRDm2Q=;
 b=U1OqRYmhQzQHxuhyVnHtlOKdMFO6rpAOu+4fZ87kx1/qNoP9CXTvb2vAK0Rqx3lf3wqDTr7dNu81+Os0P1fA9LdgsgwYhVTkqv+Jl24K7gZDp/p/Uw2EU7XivWSipZdyT+7X3L5mtuVutnc3hKji6a8Tpl6iYekLDG+sdHkWJSk=
Received: from CY8PR10MB6873.namprd10.prod.outlook.com (2603:10b6:930:84::15)
 by CH2PR10MB4198.namprd10.prod.outlook.com (2603:10b6:610:ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 05:05:46 +0000
Received: from CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0]) by CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0%5]) with mapi id 15.20.8093.021; Tue, 29 Oct 2024
 05:05:46 +0000
Message-ID: <8cd191cc-0d05-4710-b051-c917efa488d8@oracle.com>
Date: Tue, 29 Oct 2024 10:35:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/80] 5.15.170-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241028062252.611837461@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To CY8PR10MB6873.namprd10.prod.outlook.com
 (2603:10b6:930:84::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB6873:EE_|CH2PR10MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e9f6e2-b155-404d-8c92-08dcf7d758a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGRKdVVxZjFlY25uM3JUeW1DbjNqS3hYUFltZHlyTkFEZ0NrbmlwQmwxZ0ho?=
 =?utf-8?B?ZXBDUDFoclRJRlllNHdDRVk2LzNvbUE5Qzd2K2F6MHQyanFPUzYyRWl5Mjcy?=
 =?utf-8?B?dTlCR1RiMm9WU0RyZ0p4MG9RSVFNNUlJamRyeVJzQnA4c2RYdE1zREJ2NGxN?=
 =?utf-8?B?TWRTUmlDQWR5STVWRDBEVVRaUnJ5RU9CUy9mTCtDRjYyL3dRdE1BOVN0emNn?=
 =?utf-8?B?bFBESFBvWEwwZFdZdWhJakdEQnhxV0lsUmNjNWdlb2JvbHJuNHVRZ1ZFcW8z?=
 =?utf-8?B?R05sU3VHbkp6NDRpNmdWRm1FbFFnMGN4ekh5RWhRVWVtcml5TmM3b0ppTWtU?=
 =?utf-8?B?L2p5azJHYUo5M0ZuaWZmSUlTd2NXOVVLd1F0TnRiM3diVnVGcDlBQlN6TURo?=
 =?utf-8?B?a3VaamJkcng5d2lvazRrMnpxQ3pXWmJ0VkppL3p2cFNLNHhSMDBXbjZCMWx1?=
 =?utf-8?B?UlJRTU0vR2tWM2liNVlwM25teU05ZVRQQU1FNUM4aW5YVW9WUGxrTDV2OEZD?=
 =?utf-8?B?K2VoR1A5bkVNOXR0T3JkVVVjME1rT0l2TWRHUGJiNFU1YTVqS3gzWUtRc1o0?=
 =?utf-8?B?Uy9kdFd6M2hRRW5GbWZ3Q2dDVnVDQ2RWcFNIOWd1V1BldnNmMVhXaEhLWlhB?=
 =?utf-8?B?MnN6cHRwTGhldXNCSnZCbEhGajFOUXlTUElJYW9qazdpM2RnSW5rMjR2U2ha?=
 =?utf-8?B?Z1dtR1h4OEwySWN3Y1VmVStvQmVrais1QmV2aS8rcllHTTlBbitEUzIrcXRq?=
 =?utf-8?B?enplR2IvTERwdStRK0YrbzVQeWxkMlNsWnh1RWFkaEhKL0VBeTFTVXF3Tnd6?=
 =?utf-8?B?VExpdEZNd3NyUmQ5WEtXTlJGUmVjVGpmTXBXWGVmNGsybzFyRGQrSFF1eDJs?=
 =?utf-8?B?ZXIzYjBwOE5kVTV4RWpuWTl1c0RtTTBETDA3WWdUd29oMnhtK1EyNGpKUHY2?=
 =?utf-8?B?RXJ3c2N2dk5PNWJkQ1hVcStDUzd2SVJ3Q3lsNnAvMHBMZDVLdHMyem9ITHhU?=
 =?utf-8?B?cURSQmdSVjVQK1RqTExDNWsrSDdoRzR3YTRBQzdCdWlvQjBkMTc5Uk5sZThF?=
 =?utf-8?B?VFFOYkJoV1NsNitXTzVFaktNTWRLdmlYeDdFMlh6TnVmS3NFZGhzaGp4YklD?=
 =?utf-8?B?SlhFUnFZUitFNi9UZmMzNEdPMWZNcDdxZkh1ZHBsaWlvaktIWGhzUkx3ZGVn?=
 =?utf-8?B?aGlFcE9kbTVJSDZFRVMzemNQNUtPUG4rTnFYdzkzVHozQm4yMVNKRjdibWNo?=
 =?utf-8?B?YlllSHRhWTBkZi81R2ZYQVYyU3pQTDJBNFVGci9ld2JXZHlHMURkRnRHS0xX?=
 =?utf-8?B?N0VRSy9zQ0o3TmhUMEFDNkN3V2ZQR0xwbUV3bXhhMjg4ZGZTOGpNQzk2ZTI1?=
 =?utf-8?B?M21WZWcxcEZCb2FjRXVRRFBPemQzMTF6OVRyRnRnY1ZJV2NqSXVKbDhYSGJV?=
 =?utf-8?B?SUo0aFlWNm12RENkMy9Ua3MvTFU3OE5lejhEQzRHQUQ5VnVwTVptNDdVL0FZ?=
 =?utf-8?B?MWhvenhxaEVXV1BxWVZJUW1pNElkSjBRaTVoamowUzhyejlGK2JEa0NkWFZF?=
 =?utf-8?B?andVaC9sK1pmamtuQ1VUMmdSTUUwRkNrZEhRY1U0WTRDdFpaYTVOVGhOaXhX?=
 =?utf-8?B?Y0lpNWJmSzVrMTkyWDBnaXBNdXhYWWh1dEJ2Q2tXSzE4c2dDKzV1MmNkTnFR?=
 =?utf-8?B?ZUtMUTBBUmtlam9aS3pWMXpvd2lIdU9aeTRQMHpYRDd4L3ZIMzNYK3hONTJp?=
 =?utf-8?Q?LGnf25ckIvclNaYF12EkL4jdTs+kjUqgGcLk/HH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6873.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFd5V01PdUZBVjNHbGs5MjhvSCt4SFhiUVptdEhVeDNGcXIrMG1ycENsZjhz?=
 =?utf-8?B?aW92SXZGV0psWkVkMHhuNm1VRG5mOEx3c1lvL0d1WXNEYzROYmxiS3pSVWlP?=
 =?utf-8?B?TWRKejJQenBqN3BzRitIclZHazBzaGZYTXhueUVnYmowY3lGRE8xbTBJelY0?=
 =?utf-8?B?TVFxMGlLR2RxZGhJN1F4NXNDM0RWSG5qZ25ja2cvb2dFejhDOVNHbnJ0NzIy?=
 =?utf-8?B?TlUyanRtTjBXNlpuOG43bitHaUdDcWU0cWhZUm9iMVZLa1FmcEk3dXpWUGxW?=
 =?utf-8?B?dWkrblZhbDlMVGphY21JZWVrMDliN1JuRzFwU2ZlUGRBL3FxaFJEZUc1LzBN?=
 =?utf-8?B?RTlobjlmcVZyL1g0djZ4OExmNGN0eTJPaENXdW1UUkVDN2dmcHc1aVNmTFdH?=
 =?utf-8?B?L2syMjFyVkdpRG9aUXVpOEYzczB4bUxNbzgvRVZYeGM5WTRjY2tyYWFpUEFL?=
 =?utf-8?B?WEd5dWhVSE45ZHNVdm1YRVFPQkZtM0R6blhQcXFiWWxzK3JzVktYZEZFc3pn?=
 =?utf-8?B?dWJueVQrb2FXdFRzTk1UTnBVTnZUK1lVL08yTEdPUVJKQWFqTjQ0SkFldDln?=
 =?utf-8?B?UDNjK1U3R3ZsOUlORE5uWk1seDBCTzRURy9PRjRvMXF2ZmkzNzJGTGI0U2xs?=
 =?utf-8?B?TzRDVzdMZWZlK24wNmE0RXNHaDdxZUpPd1ZBaHcvaXRDdnY1MkVLSmw3TnVS?=
 =?utf-8?B?c0QwYTA4cXdFS3UwRTVwTFNBeS9TNy9VZG9jT2dzdXZXOVgxZDd5a3BOQi9u?=
 =?utf-8?B?V3MwNExlRXR4SVRYUGlmMi81Skw5c1lpNjc3SWpRenJ5S2lkQlpES0ZKd2Nw?=
 =?utf-8?B?VS93VW82a1VtQlY3bCt0Y0FFMHBqYlJpeDJ6OFZQUU9PRjhxVm9YYjA0eDRK?=
 =?utf-8?B?d3dHRlFXVHVyUHRxckQzdGFybjdvR1pZSUZJcTh1NVFnVURQeGpPMDRJNmlx?=
 =?utf-8?B?MkErZTNNSmQ1M1lRMmRDSHY5Wk9HVHp3b3ZaQmlyVXlmSDRVT1Avdi9OWjIx?=
 =?utf-8?B?d3dpSFQ0WjNUbEdLVWdPTmt2ZEVMSGJjWWJsdGpvaThNcTZPZ1RhYzJiNXk4?=
 =?utf-8?B?SFllWm5BSlM2a1BBNUFxaVNHQ1E4ZVRZKzhuTW1tcTZTVzFnNG9yM2VMOHJQ?=
 =?utf-8?B?bFBKdm1jWlV6ckRORFhVRWU0WC9BRDhWWHRnM1FubWhmY2pTMWZWUklCZktB?=
 =?utf-8?B?WnUxb0xselJLbFNaWTZpUjU3anQ5M1pjaFJId0p2SGZReXdNcWZ0aTl3a2JR?=
 =?utf-8?B?aXJ1NlZZK2l2QzQvNHphL3RzQ3R4RktTTitDV2hIcEhVSDJOMTh1UFNqcnNl?=
 =?utf-8?B?UENyckVFN2E2TElQallESUdRSXM3cWFKbm93VlJTNXBKVWFsRFNRbDVLcDdv?=
 =?utf-8?B?ak5WUUpnTFIvZlc0ejZENFhLM0x0TlhYL2wwQTVMYStqQ0NRcEw2czFoSjFi?=
 =?utf-8?B?bi9xT0c3UjJpdDVyY0lYUjU5b2toVTJGZWhyM1pSUWV5WWtHV3FUbUhZL2k2?=
 =?utf-8?B?b09sSjBaOStPcHpabE1WZ0pxUFJXVm8zSTVUR2xDVVpGZWdtNzk2MnNtK2FU?=
 =?utf-8?B?QytlQndhVlRyRlVWa0pVazlFSlFHMWVBcm9PN2hEL3NQTWN4K2xtbXE4Q2RW?=
 =?utf-8?B?OGJOL2phWHp3enpXOE9SVk9iVFo5Um5yUUpEbTJ3MXRGQlJnVDk1TzFxZzR0?=
 =?utf-8?B?ZmRkbk1KaXltZVNkRHhVUldhSUpOZ2VqT1d3dlNsRE9nUnMrVTFkbUdFUExr?=
 =?utf-8?B?cG0yYXJZZERjbHAyRjdCLzVpOUl6aHd2b2gwQjVWcjMwcUkwVFJhSzJtcHNN?=
 =?utf-8?B?NEtsbEt1M1RXZHQvNjBaM1dMWU5OcEJlSzlMdW1aQWF2WGNndzl6bVEycHo5?=
 =?utf-8?B?Z0ljaGZYdmVXZG9OaVd6ZGdYTnVkaGI3M0pTWExxRjNxbzNBTzBVV09iV3Nh?=
 =?utf-8?B?UUtZSnBURVpaYVhSQUt2b1QvVmpyRW1VbXBYRFJsbHNwS3RtWDJIcmg2eDBJ?=
 =?utf-8?B?a0YyS1MwWVZsSkJwRWFwVXlpT3dkVVRmYlZTeW9sUXNtc1FJNnVFc0FkQ1Av?=
 =?utf-8?B?Wi9ZOGVyTGQvOExqTWk4TU5qdFNBWkVnWE5leU5tN01NM044d0hWbHhBd1VJ?=
 =?utf-8?B?TTlNeG5Pei95SG5GakhZcWpjdUpuMUd6UzdOV0Y1VlFrUm1Qb0VWUkJuQWpQ?=
 =?utf-8?Q?Uw5D6bhBZDPXrfglxmvZAk4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hYpft0Pyvqv+4w4cCf0w3N5+1hCzM7ih0wM42AGL32Ac1d5MD+dPkx3hZjm4UiGXv55c+14WWPV3Od4LxzGdo+LRe6y5438htLVOt3EGYaF7sYDLhFvWz2ZaR2ZM7oD8ZIB0EPgL1/HuHcs+F5IaHnr4hReUMSqg5bAJ68Wn5VU35eMVHHnsD73lGHMpFeUq8no7XNQ8r23oO+yzByQhZP1zxEQuSOJ2dnd/gFzGi6/hhSCi7R/CPCMzrNWjP9JJbMu6fHwatoll7EzodK3ANvgSyPbIAddl0mK500+H2wyjRYEQdmlLcLXYBIIB6WaG0/d0SOZWmxUy3pQQQq/L21LzpJflSpCXzcorVP/cY1C/JCj2qhgC38plXzrpA0lzx4fFL3LbpTU1BnQzm93TyqkJYbYABicL/TH7T4L23ow5jsDYgOldmfgfqAJbP1SQ7/9fh8/EQPqhoH6Or6IB9757Ok6WKSdtDrU3rfG1sssq5jdBv/suFl5TzbdSY78AHM72/EAQcYFMe7jMAS9h4YRkEBHpLi9T7Y+thH9wanNL9+MGBgD7VVycR0QyJPmT7AK58u1grx+7l79o4IyZziQ+gCQyZJu6VuJ07s/twlQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e9f6e2-b155-404d-8c92-08dcf7d758a3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6873.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 05:05:45.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KM7zJtXGw4xVKHTdsVOBNYy6soNsF/QGOJiCss5X+MEHvFGKnXswl05y1X7tvtR8T5NBPQeDYYx3IDn2/NBz9YvkFbgpK9C5SHKCN9DHCglDARGvyZfydT2V2Ejbc26M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_02,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290038
X-Proofpoint-GUID: 3_Dx0IBjyvhHtu9gPBp4gZ21dTq6JlDj
X-Proofpoint-ORIG-GUID: 3_Dx0IBjyvhHtu9gPBp4gZ21dTq6JlDj

Hi Greg,

On 28/10/24 11:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.170 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
