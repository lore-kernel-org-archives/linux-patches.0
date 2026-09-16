Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC97B364942;
	Wed, 16 Sep 2026 08:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547684; cv=fail; b=PB66BtNN7mGGRDDqPPB5tNTqunQ5F2M9LOuW0ITaqfhV+QIj73oz/irJaL1ePezBzfc62Y2O/cxxMHGlfuPcXnJpSlWAlHaCJT6DDgjLXu7+3u0IaHbrRfsGyWq3VP/bDAN40I2nFEotmh4F/7dsW1ugkmSi//t3xtTl09+EC2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547684; c=relaxed/simple;
	bh=XBBcNWdnq7u+ISsrAcxgZmMXf8yYiy/CfuwaIm9GNaA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JdRbhkc9sa+ESRdfMtX20OrqGba/4wWoKIzsLSTHKryg9MMiP3Msjo8SxfI+5mgBq2GC7blWGflzXJDNZt6fLpUKljU9CDYL2ghIq1DAKzqo5Fit1Cx01PNsQ+nLO3m7x2YmRS8h1EWk9lHSqDjSR7ESQeOLZ3ccoAgkKB3HIro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WmpkWGyw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UKdFugNH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WmpkWGyw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UKdFugNH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWTBb641177;
	Wed, 16 Sep 2026 08:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GaSl5p72IbJwTwKRGZfgnEGmrcdNGG0YIGSPrp/R+1Y=; b=
	WmpkWGywuGKveO57xyaVCX9IN3ILM7h/FvzNE4ujR9wzRTDxDpJNueVcvbinzeO/
	46xzj67kuPHiTU+Nm7M6JTe3ngj2pieoMDXtBzq+AU8MFKdk72lcAyMLmf8/PJiw
	TDxPib1djCs76HK6PrDqtEH8dCFknD1+SNSDvD9F2qBIkpaCQyBmTdqOq/yXlTpY
	TU1t8tOJhp/o+/bUp2+0c0jkI+NTXNVrbEW1bKOjjwLuWSmFD5caGMPXZpRacDtO
	t64I/Rvn3b25LQ3DQlZpoz6TdsWCXMJUjeaP1FsegbZ+bvvjdd8Ie33eUKIb05TU
	OUr7CKyWyckX614WrLhOuA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs56cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:34:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8Tpos033826;
	Wed, 16 Sep 2026 08:34:22 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d3f58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:34:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcHMjrEonVro8IgNelL1aIhr/miUQP7WXGGn8ts4lqH1F3CDVSjQKbK+xZKj3byA4wrHQ59JDClk2ppj5o0BpZMWI/nNqap5vhs8L3icsopEeNgmKBr2Uo9MGhLlDypJS/rncN6xQ/kx0Z7l50+wRPpdNuNFIMeHNU+n0c9fxy481vF0IuWweUTp6briohjOJ2xY3kh48fvzPBOvkDQf2/g+O/jdu563w7FyJNEtCtMsRVT4hWOUixpjdP0nhaXOANHHqMOvQF5s9vP3WZsp8+VL4XJ2NfAAvfv9rQaFXear0p3XOb1K0Ca5ryGHenHTQ22dnfsVLzQq7rNO3cMSVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaSl5p72IbJwTwKRGZfgnEGmrcdNGG0YIGSPrp/R+1Y=;
 b=IE+IVqBGjVsnRjdNDSJ7mGEHRsFPOwk0hXgdULGrgCyGbcbatCzcZ3jq5rEfdQoZCiaVe6Yq2ff/vECZ504y1njyJvXx+W/wdCdEFE1PNhfEi9OTa5l3n5Qq2WNrGaShcZZcMk5aaAhSbFcFXY0/AYipuUZj+WVmEl5lhRNNJ2vQKeJrCEF1xDKM07Q3rsd4aFcaZcpvFXTrH2D5rRL2sTZTix74cebKEKx1LPgAvh1syaWbFWENrV1McjE3dWDfxfYib75CxpszGWjf4qScTShU9TEafJSNNCl1FMQ6dhzGSuJFaxp6eSjJheXxjkvwvUOPG5H09JHRmJ/M3NFn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaSl5p72IbJwTwKRGZfgnEGmrcdNGG0YIGSPrp/R+1Y=;
 b=UKdFugNHMNQgGuhDNCeC4gj4Ftxdz8Fe8adLQMeqoMHwcXS51ftKCavd9/iyqpQZiRokwnZc8o4HBnyknUUKVAtIshVeApTD+50X/SMXga6py4kr4/WEYBrgyavhucr+sbjQsH8Pax49tnmh8bo+4v/QEkOO2y3v7JrtoNciWpQ=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS7PR10MB5055.namprd10.prod.outlook.com (2603:10b6:5:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 08:34:18 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:34:18 +0000
Message-ID: <830fb27b-d5d3-4f7b-b074-d1b8762fbfde@oracle.com>
Date: Wed, 16 Sep 2026 14:04:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1094/1376] bpf, s390: Clear fetch destination on
 faulting arena atomic
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Eduard Zingerman <eddyz87@gmail.com>, Sasha Levin <sashal@kernel.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065631.943010912@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065631.943010912@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0370.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS7PR10MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 911c98c5-c8ba-4bb6-4cbd-08df13cd4c7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|6133799003|10067099003|18002099003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	SQD+6TGL77GUIuZoHE0fYEt5qAiHkZ25iTbgyaBgcsQbegeP0tVqmkGI2eGzgQiIVpUhCb/3QNn6+G7yLWWnIpj1Bv5t6CZ4f0DykYp0PSEpNwJm+s+Fedx+e34at6bZmAUI83NC8LJUANNRQKINGdzh6P2ptABs71nHRdp8bPkmITDd8WDrVaOLKzRzMr/c5s6jAZTWU1DZ1d4X/8rBo6zybydOUcfVHlDRiU9U4puwI8hcYSfuD6TmDl8wQu3xc9RKl67qHL4BrYoMhYm+PZPAK4R0IMRGERHifLus4MhHwmHWJrkwYnLF0Zu5kW/cmLh03GpZ3wX/8cjTC+bDVvm7hpsUKWN2qWF6/Hhiom6fHQdDEEM2NWNqweKwRCJwiTtZIaDlO64nn/+X1ZD6S1dtyN5qMdFdERVbBBC3YdIl7mJ0IBLThGK3L5xIbxS9NAfkNQi3pmMjqp9vnSDxj9J3CFuSzl3hdTbtSbjsv85+xVZJlKl+g7xPlSep+DllkCZDQ012BQDPucHCMkpFezO9+dkP3pI9Zl7KPyTa3QMzrNiz3OjKS4ELfwWYu6nHwCZZ3fspYn3R6R2uNlAaJbyI8qQk1haU0m6XaxD7iJWaFIk7IpVoB5pIcabGVqg0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXh2cnB0b0hrNUNlTHVYMHNySEI4bjhXbTFRakg3N09uZDVpODhoMWxTOEpM?=
 =?utf-8?B?RTdxSkhGZFowYVJkWmZGUEtQTEE5bTBTd2dXdzcwWmZZb0JZbGdNNkEvUC80?=
 =?utf-8?B?N21aRzI3MjIzOHdkODJzT2xGYllMSWIyeC9UaWtRU3dPaUp0dmVOTGszcHJx?=
 =?utf-8?B?S3piRVpiL3ZQZElaV3l6SFdPMC9sOVNsOWpBckdNWitza3RoaS9kUUU3VlZw?=
 =?utf-8?B?NXpEd0JxNDNVQnErWXZhZFQ3TlgwdFJMQjlxcS9VR3Niamtia1ByTVB4SUhx?=
 =?utf-8?B?NUl3bkRYOTZCZ0ExODBIblhCKy9TQUNJb3UrTW1KOXovUThvWkFJS0d3cDNx?=
 =?utf-8?B?ZUZpV3hVNm1KMjhjTExQZTZTbGYvRVo1ZHJSZFZCRmJkSzZ1M0tKanpkcmdD?=
 =?utf-8?B?MEdYb0JHSkI5RWczSnVTbFFva3VxcUNXM1h3Vk1XU2N0NHdpQlZITmhzOE9p?=
 =?utf-8?B?WEhDOFRxdG9BaFpnRHhKSElqWmo3YjE1ZGczckFkWTNoOTRQMU42L0tiSWRl?=
 =?utf-8?B?MFdZeDVBaGxlbGtEdHRMRTRiY3lzaVVIRHNrWHV3bzI0TW1IWEc0NGV0MlZk?=
 =?utf-8?B?OXo4a1crdlc3Y0cwWUdEYzVXTzFNWmpkYWxDZ1BZaDdNVXJlbTFIVjBLRFpV?=
 =?utf-8?B?a0I3dExpV2hQNlprUWF3TERCVnhqdFdiamhpRytxdUZRUnFQTWJZQVlkZzho?=
 =?utf-8?B?aHVWVEkwZ1pLTVRpcVduMVFJem03MkpLQzRRMlpiTDNKM2xVdGhCUVBrWGhP?=
 =?utf-8?B?RWp6UTFuRVdkSkQ2amc1OXo2U2RUN0lCZm1LMjV3UjR4Skw4Yis1TXcweVhM?=
 =?utf-8?B?QzJOSFZPQllEUkJLTFVQdjQvYUJXM0dNVGU5SHFJUDU1ZzJhVVI5Z1d5YU4x?=
 =?utf-8?B?cVdGNlVUNEl1N25vQlV2TmZ5czZhd3dKOTdhQWI5QWlNL0N5MCtFREhoQjY3?=
 =?utf-8?B?Y0h4bXhlQU8wNkNQUTFHUjlVUkptZzZDWVlwN2RoVW03UkVMUzJ5ODJnTHRv?=
 =?utf-8?B?VU8zK1JnbFdWU3Q2eFpkZ1puQ2hqRFRwaVNDNW85b3UwL1JqSHBCMEprYXV1?=
 =?utf-8?B?UHVFL2dpZmtVY21lUVljSU5maEJLZ1BwQUhQV3VkcUw2K2sxSE5QVWNuZjdU?=
 =?utf-8?B?Y3I4bjV1RHJzN1hMWHhRN3VJQmI2WThjbW9tQy8yeVpQNU1tVHNGNkZXbkdZ?=
 =?utf-8?B?R2FpejMyVG00QnQydWVxL29IYkpPbWtsa0tiMHM1eTdHVktybm9RVmZVYUZT?=
 =?utf-8?B?V21UZU1sTWhtZFpRTXVnWUoybklLRDJEMVdOYnZISkwyM2RXNWVWREwyM1ho?=
 =?utf-8?B?R05HVVlZa05WYWNOTXVJemFNYUNlYkdIaU9CK3AwUlFGaU41WkJYdzRVV0pq?=
 =?utf-8?B?Q0M5RDVqWVhhRDhNSjB1d1RYU3lPTFBvemhyTFNKLzBDdVlZYkppVkNUZ1B2?=
 =?utf-8?B?VURtK285RmlZV244VVRJcEYyNDJ1SFFhenNFWGM5clMxZGNibzU2Wm44S2U3?=
 =?utf-8?B?R1dZSTVEQ2x1ODJSSGMyNzdiejVXeDk3VGplU3A0a21yWWluUm9YcW5rblpQ?=
 =?utf-8?B?c0lEbkppdWN5ZkU4VzBKQ0w3UXpuWHhPaTdZV2RkR0J4cHFJdFhSL2svOVBm?=
 =?utf-8?B?Yzl4UHJkQ2ZLTmNGNWlrQXoyN3FBdVFTOVR0TUNJMmxvdkh6T05uM3hmZFdj?=
 =?utf-8?B?Wmx6eG9zNjFtd0huaGtYZlFhNS9ySUViSHlNaVJPTTRYcnN4ZmVEY0NWMzJo?=
 =?utf-8?B?L3UrV1NsOUtiVXhYOUNhSzRQRitIQ3hMZWpFT0JMWHprTXkvQTEydjdCT08r?=
 =?utf-8?B?VkFuZitNOHhwa2xtZDdabk9DZGV0dGpQYnZLa1VZWkVPVzNOTHI5Qlo2Um81?=
 =?utf-8?B?UlplVVAxVGNoNldkYmNMRU1oWDVTNEVodzcyRjN2SWw1SHF4RGg1WnllUzFx?=
 =?utf-8?B?dzV1TXNrK2RZcThXN0dPalFoZTFOSW5GdXhnTWMxUzQ5NkxNZW93dUZ3VWF2?=
 =?utf-8?B?LzFEcUhSRndOSnJqWlowaTVJbmNMWW8yYzMyS2ZGcHBUd0J0cTU2VGVhdW9l?=
 =?utf-8?B?b3EzNEFGVCtkS3ZOMlZpUWEvemtXWHpLTTNvT0Y4cTRla3ZWTVNmeHIxTTZv?=
 =?utf-8?B?ZnV3bzZTSXRSV0EveC9JQWNaS0tTWmpFRjlOU2hmbngyQVM4Rkg0a1hQOFRM?=
 =?utf-8?B?dldaaEg1OU9qdjgyb21TZSt0TERuVnVzSHQ4NTJ1T0ZjcGFXMHAwS2tIK000?=
 =?utf-8?B?ajd6dHZVOXZzZ21VMWc0aERzb2FnVDQ1elRaQkpVbjFlQWwxVGV0eDJCMWcr?=
 =?utf-8?B?dy9aemo1TTZBN1c3Uzd0MCtFOWNlTCtLZXVVZ0syNjBiUWMwb2NBZWMrRGZG?=
 =?utf-8?Q?f0H4cas3IDIUsdCid+UKCC9G24VwabshC/7F4?=
X-Exchange-RoutingPolicyChecked:
	FoCoenb3Z1jwtAzXJZBT/qMnegE3ZtLIQni+8rFcUAO6k7ACxl8p0EyNE9uPZ9Wkw7Y+4cGu6Z3bB10XyORS9+50yWr1Z5ypvhqj/72ReZHEHVsRFhOqT5kIbuHT6SfOwrmiySUHBnimlJWQx/I/C17ysHuIvwWR4q8RxoFwYlyPFeq5CKRicCQGcXwP5XgmiFiCoq7Lf6k4zIwM2f1ptdOvid2h/OQIijSCmJaZub1bbVxGz/s0gWFcQKgX2sQ6gjYUVjgAK7yqBAmupKRjv5PtUju/unDKd6D4ve7N8UE2edwTrDt/+RvjEycLfT92ClmwNtaOdpc4IN/oVh1WLw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+sDmFuVz5D8E1oDF1VNAF7+rJ+FNSGlfOYebkmnbKIXMTjmi1/kXKiCr7TM/qbrcZbUDbv2rlITAGEq4OGjRy1SqT8WgpZgWqWKmkkL4BgkfTpw18F8MAua8B4VSJxZenly1OqZpdeF293QDL5zy9nF57eOWWrPKfrqVrrlrFhf/SNXwe2ZLHbOIc2Nx6236LEpv1uc27FAy+30Fk+8w/IFuTgUVVgrHXT1+cdyWbwGHyhDiJYynvbhv4Mm+E6n56oQs7UhdxVaWn6WR5hRRg+VvkBVq1vmbivg8kuaolnY4SIxzSI/iQfMaMsr+tDAx2LGQNghnWHg58HMnRbgZCVNe+ipFpginYugD76S+EiQy0fuhMdAUktSHIfXbOgICKndHAB3WODqAfUp5Zlf7qfNepkoyuo6ZKV36z9mBzJLIXOa0PyyFlaqDNVt/itVV+HTKoygokgYpOf0NJzcWkUGhx+iuWIcvDIKK4EU4fD8mXImdndBi6V3dLEdlfZIdLhGMv3CMncog1FZEFHy2ECOK9ZLiNQ5mXy0FcM3l4PM9s8cDRzicMH17g98W5Kc4URLtbOyNoNZs1AF1rDNo6gWmZ+05Eu+yRMvOOQgVR4o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 911c98c5-c8ba-4bb6-4cbd-08df13cd4c7c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:34:18.5002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZxHqrIbByILb/KMncUj1Fk/xwLo5M+5hgPBiGOzs44P4TEjHW3Twj51Qwdy3Y8mJaarCHMAlW0fY4gUq64KwF0QoDQEvRalGn8f2CJ5Yb715QKJsU0Lg6te3j3eEluM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfXx4hOVVkqvl+v
 wopoHDzWEXsGwI5ImIyB8WYqppnKX27bcOeT8nTO5cRfRMw5uTXdPZWgOgUOCOpFmGi42ZkE0Vg
 6NqSb2Wfia+fFB7HjUllNPUadHOP8UMdEGcsDh7oqYVmvvI4mGxZsV+ravMJN/zXLe9tIlAw4Dw
 9zGyeFpkLRvzK2v61jAlmBhXewHRGmdSn+AiLXtsXcjbX0exET9bqPrM3vrM7dOyWxeI0PjYYY5
 UKlSpV2A55T+sfSKS6TecJ6Be4XU1qlc3tC4kK6zDdMc7yRxZgDR6Yf8Urf+BMzfxIu2fjCwtU0
 f9RoBif5QUUmsJkty/tEz4yD8T8ryHjOF8GTcKxZljgFfTma/IcFugPDMKrkNIjOqdrIbePWmLz
 AGdUuT4SW7oI/SYZgnIQtCAIYtVyNhu2JsMoTfuksZf/i2iR36wVGx9ySFL8F3S6H/5i3lxr12o
 Xd0u5iBBMFQ2RLJSZlg==
X-Proofpoint-ORIG-GUID: gvHPcJlcK3X65agdD1rv-Ujl0_NrsTw3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfXxqTl4MX6lQD5
 Js15WIvxyytKK1dq9gnYzf7evneEBwdQ4kt5YbWcwS4n5PIRpM1dSJcevXNCpPG/gSPGhdDmBgz
 aLYjT48AbYVeo1bT7Yog5qFDwBgGDiuYrHTbnE0YegQPxr+1aSER
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa548f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=hWMQpYRtAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=vAIO9dEPMllsHSo_9cUA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=KCsI-UfzjElwHeZNREa_:22
X-Proofpoint-GUID: gvHPcJlcK3X65agdD1rv-Ujl0_NrsTw3



On 12/09/26 12:28 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> [ Upstream commit cc3e12330599f097f0e1f792435686ddc276f26d ]
> 
> Same missing register clear as on riscv64. A RMW atomic on an arena pointer
> is converted to BPF_PROBE_ATOMIC and gets an exception table entry, but
> bpf_jit_probe_atomic_pre() only fills in the arena base and the probe
> offset, leaving probe->reg at the -1 that bpf_jit_probe_init() set, which
> bpf_jit_probe_post() writes into the entry and ex_handler_bpf() then reads
> back as "there is nothing to clear".
> 
> That is right for a plain BPF_{ADD,AND,OR,XOR}, which only writes memory,
> but an RMW carrying BPF_FETCH also reads the old value into a register:
> src_reg for BPF_{ADD,AND,OR,XOR} | BPF_FETCH and BPF_XCHG, and r0 for
> BPF_CMPXCHG. So on a fault over an unmapped arena page the program resumes
> at the landing pad with whatever that register held before the atomic
> instead of the 0 that every other BPF_PROBE_* access delivers.
> 
> Fill probe->reg in from bpf_atomic_load_reg(). Unlike x86-64 and arm64,
> s390x does not report arena violations from its exception handler, so there
> is no access direction to correct here, only the missing register clear.
> 
> Fixes: 2f9469484a3b ("s390/bpf: Support arena atomics")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Link: https://patch.msgid.link/20260811131600.506721-5-daniel@iogearbox.net
> Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/s390/net/bpf_jit_comp.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
> index c3ad3cf86ca64..55419813c570b 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -782,6 +782,8 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
>   				     struct bpf_insn *insn,
>   				     struct bpf_jit_probe *probe)
>   {
> +	int load_reg;
> +
>   	if (BPF_MODE(insn->code) != BPF_PROBE_ATOMIC)
>   		return;
>   
> @@ -791,6 +793,14 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
>   	EMIT4(0xb9080000, REG_W1, insn->dst_reg);
>   	probe->arena_reg = REG_W1;
>   	probe->prg = jit->prg;
> +	/*
> +	 * A read-modify-write carrying BPF_FETCH reads the old value into
> +	 * src_reg, or into r0 for a BPF_CMPXCHG. Clear that register on
> +	 * fault, the remaining atomics only write memory.
> +	 */
> +	load_reg = bpf_atomic_load_reg(insn);
> +	if (load_reg >= 0)
> +		probe->reg = reg2hex[load_reg];

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The new s390 call to bpf_atomic_load_reg() has no declaration or
definition in the destination, and the normal s390 build treats that
implicit call as fatal. Upstream obtains the helper from 41c5dbb4be3c,
but that version also assumes BPF_LOAD_ACQ and BPF_STORE_REL support
which 6.12 lacks.

Upstream helper code:

     switch (insn->imm) {
     case BPF_CMPXCHG:
             return BPF_REG_0;
     default:
             return (insn->imm & BPF_FETCH) ?
                    insn->src_reg : -1;
     }

Downstream 6.12.y code:

     load_reg = bpf_atomic_load_reg(insn);

The downstream call has no declaration or definition.

Maybe we should be adding  a minimal 6.12 helper covering only its 
existing atomic encodings, using the verifier's current result-register 
mapping, before retaining this patch. Thoughts?

thanks,
Harshit

>   }
>   
>   static int bpf_jit_probe_post(struct bpf_jit *jit, struct bpf_prog *fp,
> @@ -1653,6 +1663,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
>   			if (load_probe.prg != -1) {
>   				probe.prg = jit->prg;
>   				probe.arena_reg = load_probe.arena_reg;
> +				probe.reg = load_probe.reg;
>   			}
>   			loop_start = jit->prg;
>   			/* 0: {csy|csg} %w0,%src,off(%arena) */

