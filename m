Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D316F27F
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993867; cv=fail; b=p+Uge9l/IVuhxfu8zhEaczSxPf1PbDJyF43UjaFNCl8BoX4z8akIIyGCN1vCnm+KYZ4oYVrq+l6lub+RAKPauwUDGNgwEXUK0LEpf23AuAP+e5W+tBObi7gYJd7pb4H21Eeofbzf/rTy5U6AOjjxGJnZVqOVVhiGGNs6zQNCF4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993867; c=relaxed/simple;
	bh=ydI1DRokImDyAdtt5uEu49laDtryzo7bizUnNNrsSDw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A5Vzv8vFtjJgZAoC34j7lq357DNrVT7rVH0c3IueEKq2oiGEdjAdNHAoV/wmsLYWNM7WyFNpcGjxh2dnl43Sa16SNNGqDQ1DdtNqQGz2Is1K5NQA9OhMt2gsck8kXllL+iuRaZ4jq5pQrgX2o0LGjXoc8Iy5yVh9rU+PCB/6WoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dnbC6iF9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PuWVnoF3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dnbC6iF9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PuWVnoF3"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHNa10014807;
	Tue, 10 Sep 2024 18:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=TI23inm3wzpPMQKRXpM5tifJN1aJKHU4u7xfnyQQHpk=; b=
	dnbC6iF9anTQniGfVK4HFCcDC6F+7KQCqDyDZi0rDHv8Yz/GAqMu4ZEQSVd58EIm
	t4HEnBvLkFqLxloIkpiskZEn2UENbk6JUwNk5j5cO6n2KACdCmOkUfQEC0lHkC8c
	DJZr1D4W7JqvAWrnohWFq4RDyVaWQtm86l77eT/MK4Z9zDNFzxXEKl4+sV6J2U+m
	aVW+cc6EjXTF7pcZYxK+30NZixKaUENEAdtErui0E7tLTnSANgX3HDKmxZEmsOQT
	9dYSq3iffK+iyrrNFWw9AofW2UPfN+hSZuYeeWnC3XJJ4SMPKzySr0wdHEivcEGI
	g5fOwI+Bnla1RrVbOMooAg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2pd4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:44:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AHDWkK040891;
	Tue, 10 Sep 2024 18:44:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9aew9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 18:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzE6Jgzj6wFjg+IwzX5+a1PsE7TlsBQXo9vZfKQS5z5JVa31HCCkxS73i9IBc7+qqRo56NRSW+RoO6Om5uCLTGeddYvRJMc+nY6sqBXBW3OrW+3LeeIJCzwuSvVGtJEd2BzFy7Mx0SbsUj6U76puURmbV0z9ItZeUOHXGFd+JanH3v6AepnJnMeclDmd+NxoFHdbf7X97wyMdVieGiFjSF625LdCRXC1ax7tKb2TSyv/Gjh6jL2cCdMlrmexgVytrJ0RQXUJkCUCIsUuiMMb1UXN7PTc+YcXDV9J7gvCgSeYFsygsuxHdbSPS1UfRXk7Ad2UznuCvZo0FPBC0eXA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI23inm3wzpPMQKRXpM5tifJN1aJKHU4u7xfnyQQHpk=;
 b=p1d2Xtdv3DiPDo/PuhxNovh9Hn0scgpxHjs+6OWhtlvON98wvFAenrS7B+fTRLqz2nussvN6HyI8KNHTwD3QcPuWLI/0AkoPm4hD/DoDSddsJcslu5XdNWdJg83BCdJTS0rpn9GQDvHIzyYzUwUtcaYtSOzZQ7/4RWPwtJVGB08yXK4teZF0pvnKFrXd7M/ATXJhM14B430am5AZ14yjImJq86UBJ29+QpUlSOp6yLrGPwKgYTi+a2FvlceNcwpa53eBsQHGcpMNKavAhNONOLpswKSgwhprlD+NzeRsYiFIS0i8p05jTsPSEOhxTIo+R0SihT866IPb5M8B/oJGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI23inm3wzpPMQKRXpM5tifJN1aJKHU4u7xfnyQQHpk=;
 b=PuWVnoF3Vj0UE0sW8hp+nk3oFhBGSNLm3JBho/dkcuJspa0q70e7kq8O+WfyHWEYa6iYi9zTIW1tNu1PbPA8h1TBGDl8u6BaFKcVp5P2qX+m4rjorVWwNj+FMT7UZO6ey5PRM9nMNAt7x4ZSbR7RwP8h1FaPCf2UrQgcx5sswS0=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB6172.namprd10.prod.outlook.com (2603:10b6:208:3a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Tue, 10 Sep
 2024 18:44:11 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.7962.008; Tue, 10 Sep 2024
 18:44:10 +0000
Message-ID: <17b21823-9472-46da-8103-16362af75246@oracle.com>
Date: Wed, 11 Sep 2024 00:13:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240910092558.714365667@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: ccea56f6-d548-4633-9c59-08dcd1c8784d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGp1aXdsRExiZTREOEpXUmlHM05xazF5MlFSK3ZOR0FXWG1tTjVXd3JCU1p2?=
 =?utf-8?B?VUx1WE9mS0RiYnYrcitkQ1lQd3dBbzRrRTYzVUJiMzhtVDNhcDljeUxTV25m?=
 =?utf-8?B?S08vTXM4TkhwTnpZUkZ5dVlFbmRmZGw3d1BSbm9nWmNacGoyN1N1anJzczBQ?=
 =?utf-8?B?QVNGWGcyaHRXVDZDMkY3SGNFQmgzbE9YcFlWZ0hyRERaRzVTUkx3MjRVeDZW?=
 =?utf-8?B?eW16ZHY5bjJuY0R1ZnpiSGUyL1Bod0xFcVp6TmMxbFpZZG5OU0xGWHVFWEN6?=
 =?utf-8?B?RTZwUzBGNnJLcm9sV0tka1A5S0o3N3lNK1hsd0lqQ25oZ3pYaEEyVE5CT2Ux?=
 =?utf-8?B?Tm5VSHp3QSsyN2hsWGFJWUtzUHNwYmxrMHVaSmpVWmFtL2o1enZyU2ptdTJR?=
 =?utf-8?B?c0hjdjU1eGE5cXRybUxWZ2hBNEkzTHRSYUF1ZEYvUmxkTENhRlJCYkJoTzZs?=
 =?utf-8?B?MHZ5QmVMbVNmODBPOEhxZGE2NGFhaUJ4M3NIYkprMEU2bXQ3WkJGVFNKaEp6?=
 =?utf-8?B?YXRXN21uRWRUTC95L3dCS3M0dWlHaUNTSGtOUWtEQVpIMjhZVlVldFQ2REQ4?=
 =?utf-8?B?RmFGU2J6ZFEyNlVzVnp4bjMxQ1Eyd3ptZHNPbEt6bGIwbEp4aitwdlBKTGYy?=
 =?utf-8?B?TnhxLzFoVHJzS2JqTFo4cUFEaks2OUJ0bXE2a044U1N3d3hlblM1UzA2SW1V?=
 =?utf-8?B?bWFlYm9sTVFUdEpmVXlEMm9Sa0FnZFdPazdJYmI1V1l4Z3ZhNGdhWVV2UEZh?=
 =?utf-8?B?MWZ6Y3lONk15aFIwVC91MHp1UmFtMytYdWovWlVnYnoxTFZQT1NnZEluY2p6?=
 =?utf-8?B?WFdHQjVnTnRTSGcxR2ZGZjZuNmUvV1p1T3IxR2RtK0FtdG1SWHMxem8yNTc1?=
 =?utf-8?B?dUNmWTBtRnRaelEzZWczL1FtT2VncjZnWkJ5dEgyak9ZQmp4MmdGOTE5OEgz?=
 =?utf-8?B?aGw0RjZpSDlvUTBKaGJ2WHFwR0Y4RGhnbVoxREE5S2JmbThISE01bDNwdnAw?=
 =?utf-8?B?bUFyWXNCYlBmeEtXRk9yRHo1d2tjSXY1Rk0vQUxWaktmQUF4QzcvOGF5Tkk2?=
 =?utf-8?B?RURmUVlRQXVmcVJDVU5ZcjVBc0RNbWZWR0NQYUxxUURhT0Ryb20ydVlFeEpm?=
 =?utf-8?B?SW4zTVV1ZVp1YWdNWERRbHM5cXQzWDN3TE52dlo1WjVwNjY1MkZRQXJFZDJq?=
 =?utf-8?B?NG1iaDVCTG9HQXlDRFYyQXg4T002WVYzWDlFVzFGV056eUhxQkNvSjE0TTNK?=
 =?utf-8?B?alFqdUlBeUlDWmF6ZEU0UDUzaFpra3hoZU9pWGhiQzhITXdFSFJ0MDdqN2Z1?=
 =?utf-8?B?MngzdGZsNlhiVjBTNmFjanZocmdwbzREWEZ0Tjh4bkNYMU5RU01Bcitpa25F?=
 =?utf-8?B?azZmUTFpalBpUGhHRzNjTnJBaWpOSnlxVkFnbXRLZGROZjZJQkNBOHlVOFJk?=
 =?utf-8?B?ZjlzdGh2Y204dy9xMm1rYkJoZ1N1Y1duejhSblZ4aEJIVG10YnFSZFEwVW5H?=
 =?utf-8?B?dU5nUzQybFgvMjlyYWtkbkJrVktNRG9kSGwyRmM3aHg5ZHBDcTZLQzFGZTQv?=
 =?utf-8?B?ZWRBejFhVEtTZmRuanpzM05idEN6VGNtNnRSOTlUVENYbU85RmxsemtEaHhF?=
 =?utf-8?B?dk1QT1RMZ1Mrem1MVk5TZjVLWnBmOFQ4a21kbzBuelIxOXBOMGkxd0owb2dU?=
 =?utf-8?B?bzJ0UVlCQWJHYXBRN2hidHhsWTVhUU1ScE1YYy9ZQVJBZ2dWeVhsNDlnKzVZ?=
 =?utf-8?B?b1V2b3dtS0p5ODZZRXpYMVhvYnkwQVI2ZDVSL3dXYWdhR2haRWFidUJEZjZp?=
 =?utf-8?B?a0ZYTXVvUWJuOHUwN2hvQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1pjaFI5MEJUSmp1alM0MHN1OXVDeTMyVE1EVkVkSnhYd0YvampudDAwWWdZ?=
 =?utf-8?B?cFZuTE9WZU1QSUNiVXNyOFc1cGhMVXpWbGI2VkVaQ1VTMG56ZHBKZGdpbHVt?=
 =?utf-8?B?Y3F3TDRTQ2twZnNQTGhhVXVkdHorYkxwM080TUFRdEVsMHp1WUg4ZG85WE5X?=
 =?utf-8?B?TENRWmZML1NJaC9HdHF5UElTaFlLbnN5d0NDSVRFWjlvV3F6bVVPOEJRTkp0?=
 =?utf-8?B?bzhsckdoRzV1VGVnWWZpTGg4ejdJcTZnOUpUUHliZjlQSGFJOGpqQ0ZETUZQ?=
 =?utf-8?B?M1ZsQnFqTXdiUnFFSTlsdERFNXYrb1lYejNGRXdrZDBRcW54b0hiLzJqNGlo?=
 =?utf-8?B?Z2RrVWVlVHNHR1lXQkhvL1NMUTdwTk9LTmttY1h6TXh2MWhYdTdFNnRhTENT?=
 =?utf-8?B?dUR0MlFIc01xK290enVMRGJrSmF4eE9GSU9SOEZRVm9tQmw2elRNVE9iMEVm?=
 =?utf-8?B?dnZUOUo4YnN1aTlVWk9yc1ErdzdLcXpzUEswYkZ1Y3JBc3I5MXp1TlBlWnM3?=
 =?utf-8?B?UWtzbmZGRXp1dnk3MzgxZm9yNkp5WlVoNUZOcHQreExNL2g1cGpjMmJpeUEx?=
 =?utf-8?B?bXdqT2dKR0U1eS9jR1ZyV0xZdXVxeUUzTElYZk5zRXNsNFRNSTlkWDVRejBO?=
 =?utf-8?B?M0hQMmpvdkFrYW1wT2E5V1p1cGlBS2p3YS94TnBaWHI4dGk1dlFjSERhTWh3?=
 =?utf-8?B?QUhvMW5sWm52Q2k0UndlZjZIb1NCcklObG5ZK2RPVHBYTGNlRStROFJUdVVD?=
 =?utf-8?B?aTJOUnNnbUFJRUlmUzRJM3lVOW5kMmxwTHVRMm42alJjVEhxNWVQNTZUekNQ?=
 =?utf-8?B?SmpOUHdLZTNNbU5tNzhYR2h5WjVkL1ZKQ05aemE4RlV1OWNiZGp4QlR5VDg2?=
 =?utf-8?B?VGhuV3FYRi8yQzR5R2QweTlORVZNWjFwSXYvM25hWXZ3eGltblpvTi9odFNN?=
 =?utf-8?B?bFFlU1JiSFcxWm0yVWt2VEtDUFhXaWZKOUZkN2R0UnlCS3ZFdWlOUjczU1dQ?=
 =?utf-8?B?dHJ3dnJPS1VWNzZzV0g0TDNML3dXOVVLL0RPSGNpWUpLMTMvZGtqeEkrUnVY?=
 =?utf-8?B?NDFKcHhhQWp0Tjh2MU8xeUlqU0daQUhtRk1IcVVUMmM2aDByQm5wbHluTDZh?=
 =?utf-8?B?MGh1eFErQUNDN1l3UW1IWmY0Q0pxL3plTS9HdDVxcE5vdFFoZ0w2RG9vbVFQ?=
 =?utf-8?B?ekY1UGY1dkNnSC9mVGlVOHlZbmRQRjBxaE1BdmIrc0ZocTFnbXl2WTlHZWZD?=
 =?utf-8?B?d0FiU3M0SUd1QnRGVVplbjFWYmdkS1Y4N2FKL3haeXQxY0RneXNjVWNiY01p?=
 =?utf-8?B?N2w1WTk0amIxYzFINmFuRVNJVUFJVGRhMW5TT1FhL05pdXd5RXd0VGY2UDlU?=
 =?utf-8?B?MHZtMkFrb0ZBVVZhMVg5Y25xNzh4MWxTVk9mRzNhbUZvTjBJT0p3NEdaMi9L?=
 =?utf-8?B?YkRaYXFkd2dyN0FRQ0g2WmxRS2JhaXBsMUpwaDdGVUtKSk0rc3hKT0tqZUlB?=
 =?utf-8?B?NXJnNk1BWDlIMExvUmFKTHdDZDhUQURBdGpITGRCc3NxMkhKaUpQclVuTG45?=
 =?utf-8?B?dndpNWNSOWNqbXdrL1FIcWVYMytUdTF3Nmtsa2JIZmhkWURBU2lqOUVpclR1?=
 =?utf-8?B?VGlxcm1tTlVDZWMvY1RuSFFJNzJycXpRRHh0TnJXbjNBb29IZ3FVM0JhVUZh?=
 =?utf-8?B?MUtHRGthak5aZ0drbEFwUkFsV29zUFp6VFNuYjV6S2NEOHk0akk4QXN6Kys0?=
 =?utf-8?B?dW5qMHFJbXF5c0RlYm5kdGdLejR6cGtmRnFDTWVraHk3SjdyRHFqVFlaTURL?=
 =?utf-8?B?RzhtSVFwWElMbmVsb1NpRFdLM2xtS2dFc0MwbVNrTkJSRzEzdmZWS1pXajMz?=
 =?utf-8?B?S2dPTWhncVA0WDcwVW5sRWg0cGptS1BoOWxQbGVzdXZRUUdPMFNlM0lkTGYz?=
 =?utf-8?B?c0NUSWhzcVNNZXByUmRjSnlkTmx6SDlla3R4Y3E5SXZMcDRaeVlZODR2QW94?=
 =?utf-8?B?WUJ1T3ZNaUVQcVBjV0o4ZXRmcUxXekJXNlhnbE0vV0dweDdaNVYyUTQ4eS9a?=
 =?utf-8?B?eGpkb0k1WlBmb09jV216Y0MxU25LalFwZ0w3K0YyVFJsK1VpeGVsYW5pVGdm?=
 =?utf-8?B?T0pCMlFBWmxvK2d1OWlOeEYwU0ZEL01VTHQ5TXd2TG1KbkxYVmxkWms0ZG93?=
 =?utf-8?Q?8m8ktjrYNp8SF7Lp7gnXOmk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YK0gubZJqLxJhGSdIhLVtk1d3PHa2OfbEo7M4durUt+Uhw6k30/6oDw7kEv1Hri55kpQ9X3KRmO4tULeSsePNOQkZNhaXi+H7R9kVl+LHYQyfOb+bDqEHoSTe3j8WSAKU1A8ID8J5diH4Wf+S4SI51FutiH+V/GV4OBp/p/A5J176C51mlZPzytWoX5qCdw+7ifizokQZTO+rl/96hNv/SZL7ty6ufX/QE5g9crm5QabmZXIIZteNmv+beGTX2lcieXbGn3nzUm1UmzTV6ZfOm7T46ADr2vVfKvneEY+aCk7EK+sTEe2MlQqq12+u4+rAtk6eZCcXjzLvGqcgLDOIO6Q0f9eK1AD5a5q3buCEBzW6XR43CFPdKulyn6Od3JHpc5XUv9pG8M96JnX2Jkm3FgrelBsu53w9ilq98x206pReKiK1UGHvGY/YM1ks47305awufUvHd+sSJ/K3Q9c7FKB37ygEu6EAvSy368ywbenCWPbThPGwjBWLMTuirCPIhvuyxFeMjCN/CCzfaZutdX+W8MTtxe602xKiJIUtB3N1QOvcbX61NDrOtnVb/dDQx44MS/16vUs1qB6ZSoyWJGsuHQeF5J8cz0N+/fUWUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccea56f6-d548-4633-9c59-08dcd1c8784d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 18:43:51.6985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1r2gyxHDJbgcKf507cou2BSwb9Qhn8cvF8FB/Cm4LlAjKUAPLuazMjnCifDve5fKk4I1FWZFyG2oq0gc0dmIqDV0cRqE/CJFGB7Tk4ZtVDo+aT3QkUn1XzCbviTJ3vrG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_06,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100139
X-Proofpoint-GUID: 2TCGkj4CDty1sX2bky8ZabDRIrehbqiG
X-Proofpoint-ORIG-GUID: 2TCGkj4CDty1sX2bky8ZabDRIrehbqiG

On 10/09/24 15:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.

Hi Greg,

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


