Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F49185099
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 08:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354467; cv=fail; b=L3aDDylSrAnAVnHVVKvkbJLP7Bvoiv6KBCraMazO3k3vEF2hnHPYTrPfZoNjSGcM+Q8IDqyARgBPk8bOdPL5xH4kZ6vVfbFrl2PrAt3rMzX0PErKeqNFXHrmp+Xb8DmGFBGE/VHnPYxzDNv1Ga/R37wPmOmv7csbQKqq7EJ0RNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354467; c=relaxed/simple;
	bh=CLIA2rKL6SLHkXt/DMY00gQq/C+lXfHgySxsGbII8dw=;
	h=Content-Type:Message-ID:Date:Subject:To:Cc:References:From:
	 In-Reply-To:MIME-Version; b=Zdy5ZupKqryp37PH6vexCFy0l0lg+Jr2n8zngkJ2ZKGKvV5oaeU75GxDvG0grK5v/BUa4FQuaWu7zadbEl9PM7Ievoi6jBwsRlMTSGjrT2JNicV/FLUtTVv87lyg6O7XZI2oieU6QyB1tNwp/3qOQ00vPPEnYuLhzPEagmb5sqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MrXn8mlP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tE+2rXVH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MrXn8mlP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tE+2rXVH"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fWGY006372;
	Fri, 14 Jun 2024 08:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:message-id:date:subject:to:cc:references:from
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=vqeKz/02oRYbdTD
	xzzP9VGaiPJns99cjR6dzav7VgJI=; b=MrXn8mlPnuDFg4LNlDubP4a04RxeA3m
	Xo89SX8ybFkks65P4+PcEP61x7yG1i1yDCtLF8jCj80rwlbXhpQTQ7k1BTR32X7C
	NhrCLBBkVzuymFGwcYW2P9ymU/q1xqMv3aDAnPMIDHayAxgeGUDI6nl0pI0nkXMU
	7pn/n6BHQqoQyQrsygkjCUkoDpt+ryCijzrKrj7QJv3LzfaI67EQWbR+Yym7AWwc
	nHqn3j8iXXzo2M9vP4chECwtkZH1Bd/gHD1rhQgrM55UyxVeQZ5ts52p36d6y5Y7
	gnWRdn/DcECOw/ZZiruucaoPwl1qWTRCUTkBPgE0Le/LAleJK42sckg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1k872-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 08:40:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E8AZcl019923;
	Fri, 14 Jun 2024 08:40:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync92acwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 08:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmC8q/QBXcXF0nYxOWOl7GqpS6QD4HlLWebpcwthZgSxoYniHOgMUkEf2HPNgcIkgkhfb2kXg49Sx9fz6W6JTunS4JzDBUV1gXLDlFDIVhXmYIXmYLFJ5GUN/OTAmJZmDh2SU39naHH7pOSz2hzgaCbvgF+WWUAEQCbf72oS5geH1D3zKf/PFFu/vBiB50YCkAxHPR3wTQeCQ8i/e19iQsbXkvzqRJBRW7rdjOWio01gcgTDenUbf49+NLKBCU0FZ0j2CtWwdRaMkAgcE2BwOpbjiL+XoNnLvw8zsdj+o4saXcdlrTSj9/XrOvcgNWvlHglpOEjdiIyAntzS/aOihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqeKz/02oRYbdTDxzzP9VGaiPJns99cjR6dzav7VgJI=;
 b=VwNQOdFtQ496xErYzNae5u3JMEBUzOpK+n6IbN7V41ZpvFZqwQWpvJ9oNrMAOnQOrbrSty3k18n+WHmpPZrUrU2MOwbQyRbA3sYPqhsrclDWS7pQsIVCu8nGJagklr5ZvKxMTaV+DmVLU8hJxnHtmKpW7ElS9n7Au1D/cxGiJbdzh70M78pjlupQqFW3JR5/kvN+odAynzm2Cq/HvBp6DEPZxGuNT3l5pqcaaiKwSsExRQrof+SzSkc8xE3+U33HN9b0ahaNtIO5pQ9IRBQJpEmwwOLUlEYXcXoDifaPm3uHq9Pysw+V457QjSi/yfiBpAYe+SPclmKXmDzxBokCZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqeKz/02oRYbdTDxzzP9VGaiPJns99cjR6dzav7VgJI=;
 b=tE+2rXVHaUnUFIUdC4yriNv3sghUbcZNmYVLLxb+qU5Cpn6PPWE8tj6RV0GNHe37wSAGLIP2aI6RbJ+ChZ/plhmBT0A7GpULe/XMOufuX1qOBPf3jh3SgJCxvn5bSjy0kw3tOJ2m4tWf1QIIen+pnZYcIeqXHR/n5n86CYzwoHY=
Received: from SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14)
 by IA1PR10MB6807.namprd10.prod.outlook.com (2603:10b6:208:429::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 08:40:42 +0000
Received: from SN7PR10MB6287.namprd10.prod.outlook.com
 ([fe80::5a47:2d75:eef9:1d29]) by SN7PR10MB6287.namprd10.prod.outlook.com
 ([fe80::5a47:2d75:eef9:1d29%6]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 08:40:42 +0000
Content-Type: multipart/mixed; boundary="------------S1EPsl0EBcVCec0Gdgw9bPyh"
Message-ID: <b6548098-de01-4ee1-87c8-6036cb1e3073@oracle.com>
Date: Fri, 14 Jun 2024 14:10:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Kamalesh Babulal
 <kamalesh.babulal@oracle.com>, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        allen.lkml@gmail.com, broonie@kernel.org, acme@redhat.com,
        namhyung@kernel.org, gpavithrasha@gmail.com, irogers@google.com,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240613113302.116811394@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To SN7PR10MB6287.namprd10.prod.outlook.com
 (2603:10b6:806:26d::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR10MB6287:EE_|IA1PR10MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d1bd57c-33cd-4b82-d3a5-08dc8c4dad25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|7416009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RWIrSjZuVFViV2RWSEcxcDdCdENxeFF0WnMwMkRpVmM3S0VuNjRnVTkyTUsx?=
 =?utf-8?B?UWNhOStCbmZsYUlGV3laV0o1VVM3cGd4cW1yaXRTa2IrQkM5U1FnTjFUZmNx?=
 =?utf-8?B?dVRkWUgrRFdrS0xMM2hFeHJJQlFZM1g4dTl6ejBGUEJ1WWR6VHBhUjZySEZq?=
 =?utf-8?B?bmJwZW0zOXdiL1FwM2l0V3N3clhlWDVWQ0hCYkJLMEN1MTFIVkJEMlRpbTZz?=
 =?utf-8?B?SjhIOHNENFZUQlBvOGNpOURhWWswd2lCTjdWRlE0ejlEa3dzOGcrNThnNVAx?=
 =?utf-8?B?OE5pS1RqZ3BKaklmdDlQVG9XTndXUHpMT0RnTVVwNUJZTEcyOVREa0FOcWp4?=
 =?utf-8?B?Y0NJWVRLMGNnc2RqNE8yczRMaDZRdUc3Snd5Z1VrWTVuWTdFeGNkUm0vUzkz?=
 =?utf-8?B?a2NpOFZQd2E4MzZuREhocXdUdDgxYUNyV2ZocjVPUDgwVEVrQkk2WFdwV1Ar?=
 =?utf-8?B?K1lESy9hQ0NSU2lxTTBKS1M0MVU5V05VSm4vVGR3cFBDOWt6NFAxSVJCSHhE?=
 =?utf-8?B?Y25rRkVyVm83d0ZPNkNWL2tzZmhSSlFZNUd2QmdFZk1hcFlJRzBkN1ZjSnEv?=
 =?utf-8?B?bDQwNTNNOHRRaFdrc21wL3VFaEtpeUx6ZnowWDlDMlRra0ZlelRvbkwrbGUv?=
 =?utf-8?B?YnlJNmR4NnhnQlZabUltRlNraHZ4ZHNzdkNUS0lXZGJucmtaOFBSRjFyK3lB?=
 =?utf-8?B?WDVORDVPcjEvOUMrVGJsV0ZwRFQ2RlplV2tqaHNKcHFzS2xEeXNoaU9jQWs2?=
 =?utf-8?B?WGFJcTFTeXlxbVJtLzFIVlo1NGJOYkJDbE9FT3hIbzJmRlBQWUk4SFJOUzNO?=
 =?utf-8?B?SnJ5aVd0blpTdmFSYjhoODUxeGlIRktJNmNWVUZvdkFNL1JuNHZXT3J1MzFV?=
 =?utf-8?B?Rmt6QWExdGNUV1pnYlhSV0g4TTFlYjNZa0tYSkc5SjJ3TncwNmF1RFQwWW9q?=
 =?utf-8?B?ci94My9RTDlDOG5SaEpyV2VPYjFBODJCcmtDMzFvT0prUER6clhVb3RMSjFo?=
 =?utf-8?B?d0pRM0hQeWxJd3AwZUxaU0JoejF4YU4wV1lNRURzcHJaMTZpRnUzTklLUzBD?=
 =?utf-8?B?VnhlOVV3TDBHdnNVRi9xWXZ4VkdlRytMbUQ1NGFGbGpucWlzMTZEYkpXRnNX?=
 =?utf-8?B?alhud0FmdDVnSlZzNVJrTml6aCsrVklWQzJWQXZVM3QyR1FnQ1B3UjNua0ZB?=
 =?utf-8?B?VGlGTU9mRi9RMFFGYnplcVd6ZGJESE1sUTBSK3dlQ3IwNVVVbFUxVlhmSmlZ?=
 =?utf-8?B?SE1icklhdENMaE1HQlEyVHNlTTVoUmxSN0hHendzWkJkQUxlanRxK2FKbTN4?=
 =?utf-8?B?Y0JrSGQwajlhTDVQaEZLT0FTOTFpZWdCZm93Rk1QWDk3UjZZOUkvclo1UlRw?=
 =?utf-8?B?SXZKWnZuUElVMU5MRENZVW9GMDBQdGNvVlVHVkh1U0VvRjlRSWRreWpTUU02?=
 =?utf-8?B?L01YNzYyVHB1UkRYVXp4OHpHZlZhc3VydEhWRDlVRFFhUXBQRkRyZlg1WXp4?=
 =?utf-8?B?V2MvTTY0akgvc05xWkN6a2JwQnNjMnNXMFFsWi9QUzIySmZoUFYzR2MwVFlD?=
 =?utf-8?B?cW1KeUR6cUc3dXZldEIwZ2lqTWNRNEVvUVF3SnJYNVVPczRZMnVaRzN5aUZV?=
 =?utf-8?B?WG1FVUI0NVhsN3g5ZkFJYTlpbTcrM1A4L2d3ZCtiU1JDd3VSa2g5dnNUOVdZ?=
 =?utf-8?Q?5s0r5pyJpttG2eP+vuE5?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR10MB6287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(7416009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TUJCcjFCaUpQMjloUmEzZUl4SklDNWNXNVZiYnZOYXVQdXR0TE5WQkZLM2Zh?=
 =?utf-8?B?YmptL1BPcFlMZmpZVnlnYkRrR3RyeURSVlQ5NDhyclgwZ0t3OGxaNmtEYlNI?=
 =?utf-8?B?V0lhV1ZUd29iVURpMm1oU25oVnBZd2tQckd1K0tVaS9tVmdITGxRanJMRFA3?=
 =?utf-8?B?Y1BaUUh0K01GWkZ3VllGeG5UaHFLb2RMYjdZUWtET3JPTGVmUlhtZ2RzT1FY?=
 =?utf-8?B?WjVaNjVPdUR4cmMzT1hkRW5mQXhuSlkrK3dGZUJoZXhZRmxlYy9kTmJyRUdp?=
 =?utf-8?B?bTN1S1ptaG1ieFNaeUFtTDJnK1VXTXJ2VkhSS3lTQzJwQlE4Vk9LQlhwUDN5?=
 =?utf-8?B?ODBXbW5OZnlON0xMUE1EYjkxTHY5SWY1OXZUbnA5L1I3NTFRN2RSY3RPU0I1?=
 =?utf-8?B?azBVVzJETWorcm9rOEV3YXUzV2g0SDdTTVFvaW1OT0FyUGVRNVI1UWwwRkRx?=
 =?utf-8?B?aFJBUGJMdThWUEIrVnI3S0U4S0FUSW5UM0tjajhydjhBQnE1ZkZSckxqd0t5?=
 =?utf-8?B?cFo0YWxEaG16aVBwQlNydzgxbllOdWxxZ2t1TlZrTFZrL3duSFdxbEc0eis4?=
 =?utf-8?B?aXVhYk1xQ0o5TlE4am9hdVRUMVA5ZGVqd3VoeVptczZtYlAwTTRIbjRhSklM?=
 =?utf-8?B?OE9STzRRRisrc1FOalVVdU1ybkdGRzBvT3dqWmF6aFNxWlNNcHFXTkQ4MWJx?=
 =?utf-8?B?Z3EvUjZkTDNER0dqUGZhS3lPTThxNnBXcWd2UmYrSUpMN21XOTVQeW95ckJE?=
 =?utf-8?B?eEo1aEpIMGdiMFd4WjRsMDJnLzl0VVdiWFFtbmhuRWMwZmozWlVFZHNSbUYv?=
 =?utf-8?B?dEd3N282UkRTek5rNkRjek4xSXgzS2grOG8zNmZBdFlzNGdJTjAyelR4Y1lG?=
 =?utf-8?B?bWMwdU91OW43Tmp4dlhVSTdrN1NPbXJIaGtGcGE4TUVpbWZQQ1ZId3l6N0x5?=
 =?utf-8?B?bVA2LzR1Nk80ZkNycngvZ3JWQ0U2ZUhEUWVjeWxjZ0JETGRSSy82Q3pGQ29O?=
 =?utf-8?B?ZEd2Q3RpaUdBcjArZEt3cWcycFNMeTFGRTVNNXQzQldycml4cUE5NUVscDI0?=
 =?utf-8?B?NjZYV3dMUTJIdnhJK2lObm04WjRZSGppS2VPeEEyZUg5ZlQxTVpoTUw1ZGk3?=
 =?utf-8?B?MFcxWkFOUCtVZWVkWE1pZE5xR1ZjNHNjMGVYL3pTNjNmVm1PY1BieERRaW9s?=
 =?utf-8?B?aU55UkdqRHU2UVRhZnA0a1Nsem4vUnFFY3htakhQZHNzTUYvbmpoQU9KanY0?=
 =?utf-8?B?TVZMeDRwd3lVVE9Ya0p5dUNJVng5QW0zaEpLQysyN0t4TjJUVUpCTkRaSTJR?=
 =?utf-8?B?RnRueUdkaGlteTlvdEQ1SUlGUlIvVGY2a0lCdi9ML3NuaTQyWlErcUowckEy?=
 =?utf-8?B?aDE1cTFxc2xmWjV6ajMrRXhUYU1nc1puemhNMGZJMDhJWnhveU9MZjZIQ0Ry?=
 =?utf-8?B?eDdYTHVTdWFKb2VUMFZuYTJxeDREZE0ySHVrd1kwYm8yZ1ZKMHFydG92bm9C?=
 =?utf-8?B?dWtsbXVYS1cxZFEwQ0l1dGpBdWlpNnFCY2QvRHpWWDlSUnlmOGsxZXlsaExI?=
 =?utf-8?B?akx0S0ljQkFvcGxaMHN5eWM3VlR4ZkdzVmFKWGpNSXlMZ1VBSnNEVDFvWWd4?=
 =?utf-8?B?aGZ6akJXdlM2ejBQaG85cTFwZkd5bDVobDBEaGxIU1JhUHlHa2FWL1BnSFVu?=
 =?utf-8?B?RjlVN0hYYUdTblpxaUJQcHRXaFVpZEN1MkFiSitDUWtpSEk0YzVpK3ljZ0Fo?=
 =?utf-8?B?Wmc2dzgrSm9DSEVZVFVGRzVKY28za01RRUlwam1aTEVWM0RONXE0SW02dk4v?=
 =?utf-8?B?STdkOFQvb1RXYTZndDI5SlRBUFJwWG5vSmdxU3hUUlVyS0VuSlR5dndRdjAy?=
 =?utf-8?B?R1RabVhJUXRPUE1mbmhoZjRCdnJBaFpCUmxPb3JURXR4enlrclhHVCtpMjFz?=
 =?utf-8?B?ZnlxSysxeE5OUWUyVzJmQmw2ZmxuNmhRVkR1aUZmRjl6djRMQ2dEWStMR1di?=
 =?utf-8?B?K1hxR3JJK0JoOWJjOWgzRXl2VlBGUENVNTNFNmpyQ2RUaUdvS25HaGlncEVX?=
 =?utf-8?B?eDdXQllPbVFvTlhRdm1FdEMwTHhQbWwwWlN3R3FXZ1VPSGdUeU1PR1RTU2t3?=
 =?utf-8?B?OWJoTzF4a0k0WGxDaDQ4clZoSmZsVlRBMUd6d3VVN0NqSDlaQVltQjFKSkdE?=
 =?utf-8?Q?dA4/i56DmMbbBqEBR28xr4k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Q7tdPBSvHoE2UuwN2Kz/pXAZbFPraee6K50x5C6o3AESLKiahk/aSoT77hYhiviouW6zwQ1KNqOd7vg3svsmPk0+jeaneUM1PBq7gZfAWeRaP+FuXGpjZ2HS/bIBo23FyywKkqfaHCaC7NcgkdIN7rqIHXRdUZYdcwTtk9ByghNaTpGGHfzOQY4c+aXCX1rCWut2cl4IZJ1Q31qb4n199Uuh2HWfsbBIArtMsiyo8ZuZaUwBOFYmYn+NDH1a1W31MJHeWBG+Z+Z3bKO6Tyd+z0CPaRCdmA0toej2z+mDg4rFTDcuOASpdz1MIMAwj7em6wd+UPDc+O/VXfWo2Gf+gslbOWXGZftMZ+nMOjhuPvrAHgEjmsa/BCnE8+Bg+d3741Y6Kj+8Ze7IFYpdCGggYSQXr+SGFqGcewg9+1BAMXFSoxSwgIvQ8tKPj+TSyK5SEDHnUOfgOzet8GfyrxUIgyR+3u5Y9P4KpiqeMkCBZhDdPogEgZeUoX0p/aAi0M/tdIfgcTpJL+Xv7fGnLs6iEnSKnvHSqbvXe4DDWYtdaJlZvnN4rEEJ/kaWS6Is9VbvS2sivoJxKjutJKHTtAJGpxd0m/wYkSaqkUqV3t04Fwo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1bd57c-33cd-4b82-d3a5-08dc8c4dad25
X-MS-Exchange-CrossTenant-AuthSource: SN7PR10MB6287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 08:40:42.7921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hglf8V3N9o7qnAQtBH9lvC5NTllf8MlqznNJPEFlXDo6S18FuPPsWJveFtBDmzdhvJhDXFkm4yvbYN6/4HID3obk0VNqPCtFdeNuMSR+tbjnkEmsfjdKKN6OlzIahv2w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140059
X-Proofpoint-ORIG-GUID: kJeQ_6SvGee-hxJIv5zh6i-m6bHqkf4n
X-Proofpoint-GUID: kJeQ_6SvGee-hxJIv5zh6i-m6bHqkf4n

--------------S1EPsl0EBcVCec0Gdgw9bPyh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Greg and Sasha,

On 13/06/24 16:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 

perf build breaks on 5.15.161:(and on 5.4.278, 5.10.219)


In file included from util/cache.h:7,
                  from builtin-annotate.c:13:
util/../ui/ui.h:5:10: fatal error: ../util/mutex.h: No such file or 
directory
     5 | #include "../util/mutex.h"
       |          ^~~~~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [/home/linux-stable-rc/tools/build/Makefile.build:97: 
builtin-annotate.o] Error 1
make[2]: *** [Makefile.perf:658: perf-in.o] Error 2
make[2]: *** Waiting for unfinished jobs....



 From the git log:

commit 83185fafbd143274c0313897fd8fda41aecffc93
Author: Ian Rogers <irogers@google.com>
Date:   Fri Aug 26 09:42:33 2022 -0700

     perf ui: Update use of pthread mutex

     [ Upstream commit 82aff6cc070417f26f9b02b26e63c17ff43b4044 ]

     Switch to the use of mutex wrappers that provide better error checking.


I think building perf while adding perf patches would help us prevent 
from running into this issue. cd tools/perf/ ; make -j$(nproc) all

We can choose one of the three ways to solve this :

1. Drop this patch and resolve conflicts in the next patch by keeping 
pthread_mutex_*, but this might not help future backports.

2. Add another dependency patch which introduces header file in util 
folder, that is also not clean backport due to a missing commit, but I 
have tried preparing a backport. I am not sure if that is a preferred 
way but with the backport inserted before: commit 
83185fafbd143274c0313897fd8fda41aecffc93 (between PATCH 224 and 225 in 
this series). Attached the backport. [ 
0001-perf-mutex-Wrapped-usage-of-mutex-and-cond.patch ]

3. Clean cherry-pick way: instead of resolving conflict add one more 
prerequisite patch:
just before commit 83185fafbd14 in 5.15.y: Cherry-pick:
	a. git cherry-pick -s 92ec3cc94c2c  // list_sort.h addition
	b. git cherry-pick -s e57d897703c3  // mutex.h addition

tools/perf builds with option 2/3, tested it.

For 5.10.y: Option 2 and 3 works.

For 5.4.y we need other way to fix this.

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
>
--------------S1EPsl0EBcVCec0Gdgw9bPyh
Content-Type: text/plain; charset=UTF-8;
 name="0001-perf-mutex-Wrapped-usage-of-mutex-and-cond.patch"
Content-Disposition: attachment;
 filename="0001-perf-mutex-Wrapped-usage-of-mutex-and-cond.patch"
Content-Transfer-Encoding: base64

RnJvbSA0YzBiNzUwZDgwOWJjYTgxMWE0MDJjNjkzMTc3NDQ0OWQ4NDRmMWY0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZpdGhyYSBHdXJ1c2hhbmthciA8Z3Bhdml0aHJhc2hhQGdt
YWlsLmNvbT4KRGF0ZTogRnJpLCAyNiBBdWcgMjAyMiAwOTo0MjoyNSAtMDcwMApTdWJqZWN0OiBb
UEFUQ0ggNS4xNS55XSBwZXJmIG11dGV4OiBXcmFwcGVkIHVzYWdlIG9mIG11dGV4IGFuZCBjb25k
Ck1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYt
OApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpbIFVwc3RyZWFtIGNvbW1pdCBlNTdk
ODk3NzAzYzNiZjhiNjY2ODBjNjljMGU3NWZiZDlkOTYxN2YxIF0KCkFkZGVkIGEgbmV3IGhlYWRl
ciBmaWxlIG11dGV4LmggdGhhdCB3cmFwcyB0aGUgdXNhZ2Ugb2YKcHRocmVhZF9tdXRleF90IGFu
ZCBwdGhyZWFkX2NvbmRfdC4gQnkgYWJzdHJhY3RpbmcgdGhlc2UgaXQgaXMKcG9zc2libGUgdG8g
aW50cm9kdWNlIGVycm9yIGNoZWNraW5nLgoKU2lnbmVkLW9mZi1ieTogUGF2aXRocmEgR3VydXNo
YW5rYXIgPGdwYXZpdGhyYXNoYUBnbWFpbC5jb20+ClJldmlld2VkLWJ5OiBBZHJpYW4gSHVudGVy
IDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4KQWNrZWQtYnk6IE5hbWh5dW5nIEtpbSA8bmFtaHl1
bmdAa2VybmVsLm9yZz4KQ2M6IEFsZXhhbmRlciBTaGlzaGtpbiA8YWxleGFuZGVyLnNoaXNoa2lu
QGxpbnV4LmludGVsLmNvbT4KQ2M6IEFsZXhhbmRyZSBUcnVvbmcgPGFsZXhhbmRyZS50cnVvbmdA
YXJtLmNvbT4KQ2M6IEFsZXhleSBCYXlkdXJhZXYgPGFsZXhleS52LmJheWR1cmFldkBsaW51eC5p
bnRlbC5jb20+CkNjOiBBbmRpIEtsZWVuIDxha0BsaW51eC5pbnRlbC5jb20+CkNjOiBBbmRyZXMg
RnJldW5kIDxhbmRyZXNAYW5hcmF6ZWwuZGU+CkNjOiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaUBr
ZXJuZWwub3JnPgpDYzogQW5kcsOpIEFsbWVpZGEgPGFuZHJlYWxtZWlkQGlnYWxpYS5jb20+CkNj
OiBBdGhpcmEgSmFqZWV2IDxhdHJhamVldkBsaW51eC52bmV0LmlibS5jb20+CkNjOiBDaHJpc3Rv
cGhlIEpBSUxMRVQgPGNocmlzdG9waGUuamFpbGxldEB3YW5hZG9vLmZyPgpDYzogQ29saW4gSWFu
IEtpbmcgPGNvbGluLmtpbmdAaW50ZWwuY29tPgpDYzogRGFyaW8gUGV0cmlsbG8gPGRhcmlvLnBr
MUBnbWFpbC5jb20+CkNjOiBEYXJyZW4gSGFydCA8ZHZoYXJ0QGluZnJhZGVhZC5vcmc+CkNjOiBE
YXZlIE1hcmNoZXZza3kgPGRhdmVtYXJjaGV2c2t5QGZiLmNvbT4KQ2M6IERhdmlkbG9ociBCdWVz
byA8ZGF2ZUBzdGdvbGFicy5uZXQ+CkNjOiBGYW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNv
bT4KQ2M6IEhld2VubGlhbmcgPGhld2VubGlhbmc0QGh1YXdlaS5jb20+CkNjOiBJbmdvIE1vbG5h
ciA8bWluZ29AcmVkaGF0LmNvbT4KQ2M6IEphbWVzIENsYXJrIDxqYW1lcy5jbGFya0Bhcm0uY29t
PgpDYzogSmFzb24gV2FuZyA8d2FuZ2Jvcm9uZ0BjZGpybGMuY29tPgpDYzogSmlyaSBPbHNhIDxq
b2xzYUBrZXJuZWwub3JnPgpDYzogS2Fqb2wgSmFpbiA8a2phaW5AbGludXguaWJtLmNvbT4KQ2M6
IEtpbSBQaGlsbGlwcyA8a2ltLnBoaWxsaXBzQGFtZC5jb20+CkNjOiBMZW8gWWFuIDxsZW8ueWFu
QGxpbmFyby5vcmc+CkNjOiBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29tPgpDYzog
TWFydGluIExpxaFrYSA8bWxpc2thQHN1c2UuY3o+CkNjOiBNYXNhbWkgSGlyYW1hdHN1IDxtaGly
YW1hdEBrZXJuZWwub3JnPgpDYzogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGhhbkBrZXJuZWwub3Jn
PgpDYzogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+CkNjOiBQZXRl
ciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkNjOiBRdWVudGluIE1vbm5ldCA8cXVl
bnRpbkBpc292YWxlbnQuY29tPgpDYzogUmF2aSBCYW5nb3JpYSA8cmF2aS5iYW5nb3JpYUBhbWQu
Y29tPgpDYzogUmVtaSBCZXJub24gPHJiZXJub25AY29kZXdlYXZlcnMuY29tPgpDYzogUmljY2Fy
ZG8gTWFuY2luaSA8cmlja3ltYW43QGdtYWlsLmNvbT4KQ2M6IFNvbmcgTGl1IDxzb25nbGl1YnJh
dmluZ0BmYi5jb20+CkNjOiBTdGVwaGFuZSBFcmFuaWFuIDxlcmFuaWFuQGdvb2dsZS5jb20+CkNj
OiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4KQ2M6IFRob21hcyBSaWNodGVy
IDx0bXJpY2h0QGxpbnV4LmlibS5jb20+CkNjOiBUb20gUml4IDx0cml4QHJlZGhhdC5jb20+CkNj
OiBXZWlndW8gTGkgPGxpd2cwNkBmb3htYWlsLmNvbT4KQ2M6IFdlbnl1IExpdSA8bGl1d2VueXU3
QGh1YXdlaS5jb20+CkNjOiBXaWxsaWFtIENvaGVuIDx3Y29oZW5AcmVkaGF0LmNvbT4KQ2M6IFpl
Y2h1YW4gQ2hlbiA8Y2hlbnplY2h1YW4xQGh1YXdlaS5jb20+CkNjOiBicGZAdmdlci5rZXJuZWwu
b3JnCkNjOiBsbHZtQGxpc3RzLmxpbnV4LmRldgpDYzogeWFvd2VuYmluIDx5YW93ZW5iaW4xQGh1
YXdlaS5jb20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMjA4MjYxNjQyNDIu
NDM0MTItMi1pcm9nZXJzQGdvb2dsZS5jb20KU2lnbmVkLW9mZi1ieTogSWFuIFJvZ2VycyA8aXJv
Z2Vyc0Bnb29nbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBBcm5hbGRvIENhcnZhbGhvIGRlIE1lbG8g
PGFjbWVAcmVkaGF0LmNvbT4KW0hhcnNoaXQ6IE1pbm9yIGNvbmZsaWN0IHJlc29sdXRpb24gZHVl
IHRvIG1pc3NpbmcgY29tbWl0OiA5MmVjM2NjOTRjMmMKKCJ0b29scyBsaWI6IEFkb3B0IGxpc3Rf
c29ydCgpIGZyb20gdGhlIGtlcm5lbCBzb3VyY2VzIikgaW4gNS4xNS55XQpTaWduZWQtb2ZmLWJ5
OiBIYXJzaGl0IE1vZ2FsYXBhbGxpIDxoYXJzaGl0Lm0ubW9nYWxhcGFsbGlAb3JhY2xlLmNvbT4K
LS0tCiB0b29scy9wZXJmL3V0aWwvQnVpbGQgICB8ICAgMSArCiB0b29scy9wZXJmL3V0aWwvbXV0
ZXguYyB8IDExNyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiB0b29s
cy9wZXJmL3V0aWwvbXV0ZXguaCB8ICA0OCArKysrKysrKysrKysrKysrKwogMyBmaWxlcyBjaGFu
Z2VkLCAxNjYgaW5zZXJ0aW9ucygrKQogY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3BlcmYvdXRp
bC9tdXRleC5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvcGVyZi91dGlsL211dGV4LmgKCmRp
ZmYgLS1naXQgYS90b29scy9wZXJmL3V0aWwvQnVpbGQgYi90b29scy9wZXJmL3V0aWwvQnVpbGQK
aW5kZXggN2QwODU5MjdkYTQxLi45ZDRmZWIxODZlYzAgMTAwNjQ0Ci0tLSBhL3Rvb2xzL3BlcmYv
dXRpbC9CdWlsZAorKysgYi90b29scy9wZXJmL3V0aWwvQnVpbGQKQEAgLTEzOCw2ICsxMzgsNyBA
QCBwZXJmLXkgKz0gZXhwci5vCiBwZXJmLXkgKz0gYnJhbmNoLm8KIHBlcmYteSArPSBtZW0ybm9k
ZS5vCiBwZXJmLXkgKz0gY2xvY2tpZC5vCitwZXJmLXkgKz0gbXV0ZXgubwogCiBwZXJmLSQoQ09O
RklHX0xJQkJQRikgKz0gYnBmLWxvYWRlci5vCiBwZXJmLSQoQ09ORklHX0xJQkJQRikgKz0gYnBm
X21hcC5vCmRpZmYgLS1naXQgYS90b29scy9wZXJmL3V0aWwvbXV0ZXguYyBiL3Rvb2xzL3BlcmYv
dXRpbC9tdXRleC5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uNTAy
OTIzNzE2NGU1Ci0tLSAvZGV2L251bGwKKysrIGIvdG9vbHMvcGVyZi91dGlsL211dGV4LmMKQEAg
LTAsMCArMSwxMTcgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCisjaW5j
bHVkZSAibXV0ZXguaCIKKworI2luY2x1ZGUgImRlYnVnLmgiCisjaW5jbHVkZSA8bGludXgvc3Ry
aW5nLmg+CisjaW5jbHVkZSA8ZXJybm8uaD4KKworc3RhdGljIHZvaWQgY2hlY2tfZXJyKGNvbnN0
IGNoYXIgKmZuLCBpbnQgZXJyKQoreworCWNoYXIgc2J1ZltTVFJFUlJfQlVGU0laRV07CisKKwlp
ZiAoZXJyID09IDApCisJCXJldHVybjsKKworCXByX2VycigiJXMgZXJyb3I6ICclcydcbiIsIGZu
LCBzdHJfZXJyb3JfcihlcnIsIHNidWYsIHNpemVvZihzYnVmKSkpOworfQorCisjZGVmaW5lIENI
RUNLX0VSUihlcnIpIGNoZWNrX2VycihfX2Z1bmNfXywgZXJyKQorCitzdGF0aWMgdm9pZCBfX211
dGV4X2luaXQoc3RydWN0IG11dGV4ICptdHgsIGJvb2wgcHNoYXJlZCkKK3sKKwlwdGhyZWFkX211
dGV4YXR0cl90IGF0dHI7CisKKwlDSEVDS19FUlIocHRocmVhZF9tdXRleGF0dHJfaW5pdCgmYXR0
cikpOworCisjaWZuZGVmIE5ERUJVRworCS8qIEluIG5vcm1hbCBidWlsZHMgZW5hYmxlIGVycm9y
IGNoZWNraW5nLCBzdWNoIGFzIHJlY3Vyc2l2ZSB1c2FnZS4gKi8KKwlDSEVDS19FUlIocHRocmVh
ZF9tdXRleGF0dHJfc2V0dHlwZSgmYXR0ciwgUFRIUkVBRF9NVVRFWF9FUlJPUkNIRUNLKSk7Cisj
ZW5kaWYKKwlpZiAocHNoYXJlZCkKKwkJQ0hFQ0tfRVJSKHB0aHJlYWRfbXV0ZXhhdHRyX3NldHBz
aGFyZWQoJmF0dHIsIFBUSFJFQURfUFJPQ0VTU19TSEFSRUQpKTsKKworCUNIRUNLX0VSUihwdGhy
ZWFkX211dGV4X2luaXQoJm10eC0+bG9jaywgJmF0dHIpKTsKKwlDSEVDS19FUlIocHRocmVhZF9t
dXRleGF0dHJfZGVzdHJveSgmYXR0cikpOworfQorCit2b2lkIG11dGV4X2luaXQoc3RydWN0IG11
dGV4ICptdHgpCit7CisJX19tdXRleF9pbml0KG10eCwgLypwc2hhcmVkPSovZmFsc2UpOworfQor
Cit2b2lkIG11dGV4X2luaXRfcHNoYXJlZChzdHJ1Y3QgbXV0ZXggKm10eCkKK3sKKwlfX211dGV4
X2luaXQobXR4LCAvKnBzaGFyZWQ9Ki90cnVlKTsKK30KKwordm9pZCBtdXRleF9kZXN0cm95KHN0
cnVjdCBtdXRleCAqbXR4KQoreworCUNIRUNLX0VSUihwdGhyZWFkX211dGV4X2Rlc3Ryb3koJm10
eC0+bG9jaykpOworfQorCit2b2lkIG11dGV4X2xvY2soc3RydWN0IG11dGV4ICptdHgpCit7CisJ
Q0hFQ0tfRVJSKHB0aHJlYWRfbXV0ZXhfbG9jaygmbXR4LT5sb2NrKSk7Cit9CisKK3ZvaWQgbXV0
ZXhfdW5sb2NrKHN0cnVjdCBtdXRleCAqbXR4KQoreworCUNIRUNLX0VSUihwdGhyZWFkX211dGV4
X3VubG9jaygmbXR4LT5sb2NrKSk7Cit9CisKK2Jvb2wgbXV0ZXhfdHJ5bG9jayhzdHJ1Y3QgbXV0
ZXggKm10eCkKK3sKKwlpbnQgcmV0ID0gcHRocmVhZF9tdXRleF90cnlsb2NrKCZtdHgtPmxvY2sp
OworCisJaWYgKHJldCA9PSAwKQorCQlyZXR1cm4gdHJ1ZTsgLyogTG9jayBhY3F1aXJlZC4gKi8K
KworCWlmIChyZXQgPT0gRUJVU1kpCisJCXJldHVybiBmYWxzZTsgLyogTG9jayBidXN5LiAqLwor
CisJLyogUHJpbnQgZXJyb3IuICovCisJQ0hFQ0tfRVJSKHJldCk7CisJcmV0dXJuIGZhbHNlOwor
fQorCitzdGF0aWMgdm9pZCBfX2NvbmRfaW5pdChzdHJ1Y3QgY29uZCAqY25kLCBib29sIHBzaGFy
ZWQpCit7CisJcHRocmVhZF9jb25kYXR0cl90IGF0dHI7CisKKwlDSEVDS19FUlIocHRocmVhZF9j
b25kYXR0cl9pbml0KCZhdHRyKSk7CisJaWYgKHBzaGFyZWQpCisJCUNIRUNLX0VSUihwdGhyZWFk
X2NvbmRhdHRyX3NldHBzaGFyZWQoJmF0dHIsIFBUSFJFQURfUFJPQ0VTU19TSEFSRUQpKTsKKwor
CUNIRUNLX0VSUihwdGhyZWFkX2NvbmRfaW5pdCgmY25kLT5jb25kLCAmYXR0cikpOworCUNIRUNL
X0VSUihwdGhyZWFkX2NvbmRhdHRyX2Rlc3Ryb3koJmF0dHIpKTsKK30KKwordm9pZCBjb25kX2lu
aXQoc3RydWN0IGNvbmQgKmNuZCkKK3sKKwlfX2NvbmRfaW5pdChjbmQsIC8qcHNoYXJlZD0qL2Zh
bHNlKTsKK30KKwordm9pZCBjb25kX2luaXRfcHNoYXJlZChzdHJ1Y3QgY29uZCAqY25kKQorewor
CV9fY29uZF9pbml0KGNuZCwgLypwc2hhcmVkPSovdHJ1ZSk7Cit9CisKK3ZvaWQgY29uZF9kZXN0
cm95KHN0cnVjdCBjb25kICpjbmQpCit7CisJQ0hFQ0tfRVJSKHB0aHJlYWRfY29uZF9kZXN0cm95
KCZjbmQtPmNvbmQpKTsKK30KKwordm9pZCBjb25kX3dhaXQoc3RydWN0IGNvbmQgKmNuZCwgc3Ry
dWN0IG11dGV4ICptdHgpCit7CisJQ0hFQ0tfRVJSKHB0aHJlYWRfY29uZF93YWl0KCZjbmQtPmNv
bmQsICZtdHgtPmxvY2spKTsKK30KKwordm9pZCBjb25kX3NpZ25hbChzdHJ1Y3QgY29uZCAqY25k
KQoreworCUNIRUNLX0VSUihwdGhyZWFkX2NvbmRfc2lnbmFsKCZjbmQtPmNvbmQpKTsKK30KKwor
dm9pZCBjb25kX2Jyb2FkY2FzdChzdHJ1Y3QgY29uZCAqY25kKQoreworCUNIRUNLX0VSUihwdGhy
ZWFkX2NvbmRfYnJvYWRjYXN0KCZjbmQtPmNvbmQpKTsKK30KZGlmZiAtLWdpdCBhL3Rvb2xzL3Bl
cmYvdXRpbC9tdXRleC5oIGIvdG9vbHMvcGVyZi91dGlsL211dGV4LmgKbmV3IGZpbGUgbW9kZSAx
MDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5jZmZmMzJhOTAyZDkKLS0tIC9kZXYvbnVsbAorKysg
Yi90b29scy9wZXJmL3V0aWwvbXV0ZXguaApAQCAtMCwwICsxLDQ4IEBACisvKiBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLworI2lmbmRlZiBfX1BFUkZfTVVURVhfSAorI2RlZmlu
ZSBfX1BFUkZfTVVURVhfSAorCisjaW5jbHVkZSA8cHRocmVhZC5oPgorI2luY2x1ZGUgPHN0ZGJv
b2wuaD4KKworLyoKKyAqIEEgd3JhcHBlciBhcm91bmQgdGhlIG11dGV4IGltcGxlbWVudGF0aW9u
IHRoYXQgYWxsb3dzIHBlcmYgdG8gZXJyb3IgY2hlY2sKKyAqIHVzYWdlLCBldGMuCisgKi8KK3N0
cnVjdCBtdXRleCB7CisJcHRocmVhZF9tdXRleF90IGxvY2s7Cit9OworCisvKiBBIHdyYXBwZXIg
YXJvdW5kIHRoZSBjb25kaXRpb24gdmFyaWFibGUgaW1wbGVtZW50YXRpb24uICovCitzdHJ1Y3Qg
Y29uZCB7CisJcHRocmVhZF9jb25kX3QgY29uZDsKK307CisKKy8qIERlZmF1bHQgaW5pdGlhbGl6
ZSB0aGUgbXR4IHN0cnVjdC4gKi8KK3ZvaWQgbXV0ZXhfaW5pdChzdHJ1Y3QgbXV0ZXggKm10eCk7
CisvKgorICogSW5pdGlhbGl6ZSB0aGUgbXR4IHN0cnVjdCBhbmQgc2V0IHRoZSBwcm9jZXNzLXNo
YXJlZCByYXRoZXIgdGhhbiBkZWZhdWx0CisgKiBwcm9jZXNzLXByaXZhdGUgYXR0cmlidXRlLgor
ICovCit2b2lkIG11dGV4X2luaXRfcHNoYXJlZChzdHJ1Y3QgbXV0ZXggKm10eCk7Cit2b2lkIG11
dGV4X2Rlc3Ryb3koc3RydWN0IG11dGV4ICptdHgpOworCit2b2lkIG11dGV4X2xvY2soc3RydWN0
IG11dGV4ICptdHgpOwordm9pZCBtdXRleF91bmxvY2soc3RydWN0IG11dGV4ICptdHgpOworLyog
VHJpZXMgdG8gYWNxdWlyZSB0aGUgbG9jayBhbmQgcmV0dXJucyB0cnVlIG9uIHN1Y2Nlc3MuICov
Citib29sIG11dGV4X3RyeWxvY2soc3RydWN0IG11dGV4ICptdHgpOworCisvKiBEZWZhdWx0IGlu
aXRpYWxpemUgdGhlIGNvbmQgc3RydWN0LiAqLwordm9pZCBjb25kX2luaXQoc3RydWN0IGNvbmQg
KmNuZCk7CisvKgorICogSW5pdGlhbGl6ZSB0aGUgY29uZCBzdHJ1Y3QgYW5kIHNwZWNpZnkgdGhl
IHByb2Nlc3Mtc2hhcmVkIHJhdGhlciB0aGFuIGRlZmF1bHQKKyAqIHByb2Nlc3MtcHJpdmF0ZSBh
dHRyaWJ1dGUuCisgKi8KK3ZvaWQgY29uZF9pbml0X3BzaGFyZWQoc3RydWN0IGNvbmQgKmNuZCk7
Cit2b2lkIGNvbmRfZGVzdHJveShzdHJ1Y3QgY29uZCAqY25kKTsKKwordm9pZCBjb25kX3dhaXQo
c3RydWN0IGNvbmQgKmNuZCwgc3RydWN0IG11dGV4ICptdHgpOwordm9pZCBjb25kX3NpZ25hbChz
dHJ1Y3QgY29uZCAqY25kKTsKK3ZvaWQgY29uZF9icm9hZGNhc3Qoc3RydWN0IGNvbmQgKmNuZCk7
CisKKyNlbmRpZiAvKiBfX1BFUkZfTVVURVhfSCAqLwotLSAKMi4zNC4xCgo=

--------------S1EPsl0EBcVCec0Gdgw9bPyh--
