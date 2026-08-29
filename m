Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9494502F
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035425; cv=fail; b=JMqzd/wkHYfpYoGsY8Z+K/luP91mnMo9BgdWk8btui7YviLEuVLYnjUFqxGNvBfDbQZPO5tlowrVwygH5yun17qQdd0Hx49lFpLf5Si08LHilGfdpAEq6tN4IUJ0WiLESnKJiwITNqhW/CT4lnIJZLBvv/TL36+2NxWPz+V9PJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035425; c=relaxed/simple;
	bh=HGE8VPX/5+HS3F2a0NANvt+MEjFGJroDIUJkFbg5+qI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zn3rFD6ypAoCwLGWK5jsoEV6A4DOsqNf6rfk8uCLnLJyJdi5AVoKxJ2gRhigTejbxVEBQaBaizQR/mAb4OG4F3oocm2E8ovlpi407oVU5rAVy5r/hUAgIdiIsKwhRUNNUgcHojGXcNFHOSULEp6mPG6MZEZDltB0Tmdzq5ZIgf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JifNpdB0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uOaf7jmw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JifNpdB0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uOaf7jmw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TJFTG41515337;
	Sat, 29 Aug 2026 20:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YuzAld19E1XaayCvkP8WOhCoDzOUjqzoerhQKPuW4C8=; b=
	JifNpdB0Tzd5z5Q+eI0XNn3UsLjUffUGqsWeRpVsLYCrofJ5Ti7H3Icv/NzNmKQD
	zekfVoDiOid1NDsklCHoZ+XUzalKf78132kvkM4n+Ff9UBc/0xLrkBmA9tAFfloN
	8BSTipdAtcYEWY4Pz0c4WyU3JczKhwji/JqaSmq/1MDnQIHPXm7wfXBrUuZ8z+IM
	xS32UI79W9GTSH4UhFCWZLodk5ReV7B0wM3Mz6vRkUeui401CJ5wJ6HuoGtggxyN
	RDCoGTLkSFF1rcPXy8N47zd8SkI7kqX6r1WWQROHIVi5dYO9/VHRCmd2o3+vtNlv
	+2oyp3bJcpTZWj5QCHaL+w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xrmbm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:30:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKPVO6022075;
	Sat, 29 Aug 2026 20:30:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvn7qkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:30:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lYvTpsyoFDgK8HQphbpQR0g0IBwF2TjvvOUwkrWjcxNwPdEMSixkoytrHg8LZt8NBeWSywzOTrVjd4NAH9fHVma+VVs9aMFA4DObe0l9dsMAjGA2pUjs4mxCJTwYYX+vnHYpbedGTaABzbR+78tUaWO5CRJyEvRP8mRHQytV73eA3N7ZW91C04kruxZ2w2HHCPRTNQLn7AVB77NASkQthqDN9iUauMk4YECEWqXNlgCy4dUMWFli+3zjWj0iaftNWrtei4Xl+ULnbhuhQsWz4hdmWMFtQs4+BooGnYMry56P7ApNRmaEOEdqVXG4VUTQRCRHQlc2O0lMJnRUUQ+gdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuzAld19E1XaayCvkP8WOhCoDzOUjqzoerhQKPuW4C8=;
 b=emOTJzeXo7kX92RWqEimDnRrUmm4JQu55qIJ01KV6fKvvxbxQ+pKiXj7srvJkMDgk6D20RWEeSQCIj3tjJ1WSUwq2rgpOKkhKHRl5DuZQuSbYw2PrR1Fem6wIk0y3vcF9owg1bbcm2711ZYgOcXTnNMnzoVqHFYR9pfcLpnD/Wmd8C7B0drGKzsgSU1nkUeyBng5HRib9Cky5Lc50Z3SpTqEAukHvA2Tx64IOXifiuALz9MFcIWQhO5grW24W79Wh2PNalI9tMWo/HAKA45gIz5bsY6JajOZLaQIYxC451LyF7bmEO5gLf4ZSfj35uX2kyRFaoQNAN5FKtRSZpJOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuzAld19E1XaayCvkP8WOhCoDzOUjqzoerhQKPuW4C8=;
 b=uOaf7jmwnf/iSdXEBMjIkF4jJgF4krzNikdykure+h+wwrm1g7omyssUcINxkW2j6G+xuxmjVSKyd1GtgomihFxq2PSi5mzWtdSZLk0VrFEC/n6rZ7XX6SrPVswK5ClOAnYKQP/SlV29An+JxgKrsb0quT0D2gxTSZs1ZZp6M0Y=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ5PPFDE7085185.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:30:13 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:30:12 +0000
Message-ID: <97b59b72-1d06-4700-ad23-84e61fd0d33e@oracle.com>
Date: Sun, 30 Aug 2026 02:00:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 006/272] selinux: require every boolean value to be
 defined
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bryam Vargas <hexlabsecurity@proton.me>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Paul Moore <paul@paul-moore.com>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145231.229664293@linuxfoundation.org>
 <20260820145231.426900054@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145231.426900054@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0210.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ5PPFDE7085185:EE_
X-MS-Office365-Filtering-Correlation-Id: 51ebaa38-6fdb-4867-8c11-08df060c53ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|4143699003|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0zJPreQHzogJnUtDQjqNypNkRwu3OhhDeGJHfjCbGKEZY21Y3JnxVvp8Cci6MXFd5Ub8H7gDC2ztFgQwa6NlKdJ57Y9wLI9yMviay/LRahel7ne9clQvP2T0I0oBTP+qRvAATd5p+JXlTxURSDgsjfWorJdi4cUfn2m17/i7yTwVW5GjZ0T9+vfins+CNsNG2289xwwE+7EwRPHXSao8z0Dj0bKmXG1cQi2uNkXvJGWEP7wG3y6/0qwxU6yQYgkVWUtIXjlqe+UCQlhs0YpQMUfJSjGTSqd5ABRBbAT1XeVwnfEDFTm2okZcp6ByqP2vBlSY1kW1bO62s9Ng0TrrD9hr4T8X61qok+ym3/PdZt87rqETM5IKnIruW/zThiM0tv6nvkZgbfD4842JtPMf9IjfY1/eC8qbHIOii/jIJhIlUgPENxCL31H0UOIHdQTnjxqI3fr5PV5xhxh9f+NBW7rKAGY4KTmrv3OCo7vobhHRiCd6LqLslpWf2TjH7PvFQzSDCy6bALOqBRnd4vtAiPYqDdPkDa8r58opK3ifv90+1IPaOKUfLKg16aKC374rWIiWfNW+YaZs02nyWLdG2wZtw602Gcai0+FFuaual+UaSSfSAMIwbjN4zXT6guHGnfCSkcFiXoCvRvTZdvO3clTWTt3ynz2Ud40RctE4pos=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUtpWC9vdHJpd3lkS2JjZ3VhbFhXaE1uM1dDa2JHcDJmaFFxWFQ1dDZvUXEx?=
 =?utf-8?B?MnczeEVFNXY0dWV0eHVPd3h3eU02UDdvYWhmZVF1dVhOWXpCQnFYaXBHam4r?=
 =?utf-8?B?VkQrQlB4VFl5anlzT001V3B6bXZXVzNpQ3dvSVl6VkhTWDJQU2hMQXFOSGV4?=
 =?utf-8?B?Wm1abjFBREczSDh0aG40ZHFUcW9ISTJrN0dzTHUvdnVHa3cyZkwxaHNmSTcy?=
 =?utf-8?B?YTJYK1BIOVA5TlV2Tk5aTjB1UUJHN3lLSU9zZDl6ZW5VYWp5OGJLdVZ1T2V1?=
 =?utf-8?B?L0lxRlpPRjFIZjF6cUFxTVFlMG13TGMxN2VmL3ZqUkFWb0NFYkoxV3lwc2Z4?=
 =?utf-8?B?UlBNZUY0dEFQNFZxNlEzbS9ob0xWV1lJZ3k3bHVjNjFiM0NHRHc2dEF4UlNS?=
 =?utf-8?B?bG5vemFqNXphNWlycEoxOEx5dkNJbStHN3pkV2swOFBxcmtyZEMxRHdXLzdH?=
 =?utf-8?B?OVlQNzFka1UyQXJyeVVwdkNsblNRQ2VSNEE5d085TDJuam9iTDNUL3NaK1NK?=
 =?utf-8?B?aTdUN2t1NG1Lcnp3TjVDR2U2WS9hOGlTSzZyMVNHVmFFUHh2bzZldGZzMFVK?=
 =?utf-8?B?MjRKelVkMllaU1RsdjcrSjRPTVRkOVBlMm9zUXpDRk9CN2x2YVBwZllDWUUv?=
 =?utf-8?B?eU5jK0N5cDg1YmppM05SR3FKdHZ3NzJCdUlPb3dCZ0JvR042VG9qN2kzQUVa?=
 =?utf-8?B?eDkyeXRLSVZtL21FRkxBM2VqRklxVEJTOW1qVjhNcVJ4T242dW5QY3hEVVli?=
 =?utf-8?B?aEIyMWJON29OeXg3SmVLVVhNVlA5aFRaVVlOZWg3alA1SkZpcmxnOXJSTTRJ?=
 =?utf-8?B?dW4rWHNQMFowL1hmUDBNeVdxd0FLNDRwWDhVRzVpMyt5SWo3SW5YL2dNYm02?=
 =?utf-8?B?NHNyQ1IwR29CMitmcEhrTWI5UU9jcnNqU0xKSXlRcjY0WEtMVWZXL3ZpV09h?=
 =?utf-8?B?RTBBaFozNzRhc0lHY2dwM0dqL2cyWXhuTDd6bng5ZWpkUlZYeEFKbHhNUHFr?=
 =?utf-8?B?VitCZ3Y4UHRYblg3ZnhDcG9pSkxQRkJsMzNlY1FnU2UvRVU3NkxlYkQra0cx?=
 =?utf-8?B?Mmt0QzllS2dxTlk0c1c5TnF5dzJKUlpEdDZHVjFmOURJdjlDa29JVUVHSHFh?=
 =?utf-8?B?NktKY041NWNEcm16Mm92dndLT1RQVjVKSUhQTGJVQis4Z2pIaEJkRzMvV0Jw?=
 =?utf-8?B?OU44aEZxQkNQeU9QZ3NJdThDTWtNMmRmSTZiM2hSdE9wQTJiZ2J0NEEwQUdw?=
 =?utf-8?B?RmVQY21pb3ZsSWlnK0RMeTV6dmZHczZKanZxdENtWEpPVDlic3cxYUFZUXNZ?=
 =?utf-8?B?eCtid2tpWmtWZkRqaXNYdFRUeWFGdDl1eFNBQkpjOEM4REJNbHdoVXB0ZW9M?=
 =?utf-8?B?UER1ZWxhZUNtcm1zbHlabXZIL0gra1FSNTlSdU1DT2tneXdqQ0V4aytoNXFS?=
 =?utf-8?B?bWJ0YnFzSDFtZkdZRGhaRXFOQUthTzFjRG5GZVYwK1RGb21KWDcraUN3VnBI?=
 =?utf-8?B?ekxGeUxWdlQ2Q0tvL3c2Q21QdmVkKzh3UHBJZU01a0tvWFNTT05BT2dpdGI3?=
 =?utf-8?B?UmxBZ0owMzUyVU5GNVp0WHJyVTI3N2dUZWhkVWtMeHFKRHZPSWVlbnovcmYv?=
 =?utf-8?B?N3JvRTZRRVRIT3FlcUlCSDNyaGFua2l3MU5UTFZ3MWFROGU2N1d2QnlWdUNt?=
 =?utf-8?B?amw0WTk3b0pLdXZLMTZtS2o3U05PVXYvdXlWbVNoNlN1N1YwYnZpRzAyK1cr?=
 =?utf-8?B?ZTRCSXNxZ3lLM05LbjB3eis1TENZVGVwVHhIOVFkYXVURTI0dGNLWTUxNStN?=
 =?utf-8?B?cmhhWlluS0crZlcyRXN6OXc5V0czOEV4Rk8wOVpPQWdlY3VnR2tRY1ZhTDFP?=
 =?utf-8?B?dlJ1QlJvZGpXeDc1Smoxb3JRcktBMXE4SkhaUWtMTkZTTDl1S3pHbEJpNkpB?=
 =?utf-8?B?TmZBamh6NDJ2Q29VSWIwQ3JCQWpHaWwzQ0ZWL0xRZnViVllYb28rNDB2bzI3?=
 =?utf-8?B?K1RaZ3B3ZjMyVUthSU1YV1luZU1qdGtMV1ZSeWhvTUdhdmdrVzllQ3czcWhn?=
 =?utf-8?B?RCtjaitOM010RUlPaFBRaHJsWFZPZ2FmekZ6ajF0SUJac2ZHWTVzWmVwOEpQ?=
 =?utf-8?B?RTdzbnd1SGdXa3Y1cTEzYzQ0Z1BOY2xYaXE0TXhWdnovYjN4WEh3Szk5YlVJ?=
 =?utf-8?B?K3N4NVkzaWJiOVAzRUsxeUhvS3V0ODJvSHk5RWNabFlrWU9zZGRLMDBBTTNT?=
 =?utf-8?B?OEliUmZBZVVMQjVEQ1B4elVQMGYxRHJJbnhrbkdLVXIraWRrQWlEQlJtL3A4?=
 =?utf-8?B?T1ZRRFdqTnFxd3hvU21UZEx1ckpOQ1BpNk9tcWhqNFV2R2FONDZsSU5XUzZn?=
 =?utf-8?Q?/IAa6S73t9MND5BNBlU+5zRoVuue9ACVm0o2Q?=
X-Exchange-RoutingPolicyChecked:
	hYQSOjpW81ORCN/XzqUWXxQhbk7CxnXca42IAKpVvHWSJvAc308wWZfVSGvWjKyZgkYH4ZLhgvo04O708ACcSBzKpPk3fOZjmFBmx/8Ql4aK5yok5pT8IlREWVana1QhT00Oxhrty88kIou0smMh0fOFXeJPfNeUio5pcnqePXPWLwyfnQUKtw3lEvZaOhUsaEduDO8CWXACsY6z72qz2TaRV3mr+wuoGnxE77Rs1CUa5L7QA7TztQdhoTLgUzyvnRgEAg2Cy7GAeVmVbGxRU+sP8pnj2dyc1nD2h2pfrPsPL+36SQdZuehFcsaMqe0fWVxHqkny19hs8uYmil7lKQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fjxALPCoM0QboPERwDrQ1ytnjjJziyFcclmh84Ax8zu0K4rpMp2D450XLgXJQj7wsD6l4TsVGtnQFNiI1VDrWorHNcsQXrFpNEiYAhyncRXDwUqG2o4QNoEl6p2ODUQVlZzFrFPhKsbfTiA+YdtVwQOOEk5Fcok8go49vuOmbvfSStTDCWgwF0qIXAMVdUdKTKuHAfsYch2SyMffRcb8ZB9KES/TWbzm7N/l+Ml6cRmftj25bWZ2eh4sIGGnDZ5WoDvUO02o90pvAFoXI4dLAh61mMUWPD1Ru0Is0H4rwJYe9bklN5UaQ7HIwHwt4I4/CveKRxMIR4xcfSM/1sTlTQCEo2P7CODdMyw7iSMfEovKpe0Q/2k8Ju6Zd6qaYQcXB05nKXVfq5Gxs/DJqcA1MAo6ejC+J7rMVejUNutNyMP4QjfogCcbQbHPXS0ZSVqCGrMy8g8tLXOXYDQIaAPWEH6nC+duKRecY8af8PGpSJrqW5t/GJSm0T9pZ6ryMrscRwSHtLMod3T/69r8Dow3rYcR+zJb0zY7upvwFFyFjueydoObxLGCgwDq34LAKYTL4zdZ0SHMKd51N7iAFt+hGGeK3Ne2YTXQ5bArO5rtueI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ebaa38-6fdb-4867-8c11-08df060c53ef
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:30:12.8260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/D08M4EC5wX5/bZZaQOLjZyc1x6wUchPAP+rwFR4YU2VeBx6Qhcuo7qIg+c0Q/hifT79OAc8UCH/lQW08s7HSW+9kCMWf8l1v7AczuSulR1CqGQHGmIUdtlCSAeb4fO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDE7085185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290177
X-Proofpoint-ORIG-GUID: __a8ATSUQzDLI0hzIbszYnSUMRNWtsMb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3NyBTYWx0ZWRfX8dLEl323JzGP
 C2OjMHZVfN4En879AgG2T2kOmKUZOQkLVtORwhvjZDv643m02UHq42BYUMlAbuw3fTNn19ECSY/
 eJcwX1RUUqSZ3Qu4NOxMpN5EHVA9U8Nlwi7ovnu4uazm6WF94nQ2H6DcNrMZzH2Q5ba0EPdbp0j
 KZGNbY6aCWmSNlMDPdQ8MRrso/l1/+6VhXRYVmdO0b1mgJdbZ1P6VZcFCKcnRGPAxEy8nSqPjyq
 xtjT9BfyupFCDtu2WQW337sDSkdQavDBmdMFSM1uBXQA5gRZ8H/c7WJXo5SqmNE3YLS48feO1z/
 XrMinow53f0SDLKrGIeLL31GwsUvolyL+eLUAynqBMgMoxoFAit7zRbxns9zVSKbSS8LscmHThn
 pmm1Cjoi2CPfR/V99mUAS8hs/HXge2uwStL1qAhxLszpTn1LjBKo3HzMusT4CE7cfTP9hPdPlun
 Oe/rLbeutzXa3iURpBhcPBENZRLzyiQYZRgY5Ylc=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a93415a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=xVhDTqbCAAAA:8 a=ag1SF4gXAAAA:8 a=Wp1ZUwTzx6LKGvzL5w4A:9
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10 a=GrmWmAYt4dzCMttCBZOh:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12101
X-Proofpoint-GUID: __a8ATSUQzDLI0hzIbszYnSUMRNWtsMb
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3NyBTYWx0ZWRfX++E2f6rxrNTF
 l6Z2BSsL8ZwOm+fI+siXl8ab1SiXBhBzzAdKBX3KTYIhn9U+d663YlXvs5pm6te8ekL65jSiMMz
 6vvV4IIBem/wqqQWzjsgu8SdhRMx6/ZGn9e0+1wMnHA2ttwIHnO8

Hi Greg/Sasha,

On 20/08/26 8:23 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> commit a93d37a09b863810653f93d371fb197457d59deb upstream.
> 
> p_bools.nprim comes from the policy image independently of how many
> booleans follow it, and cond_index_bool() fills bool_val_to_struct[] at
> value - 1, so a count larger than the values present leaves NULL entries.
> Every user of that array then walks it by index and dereferences each
> entry: cond_evaluate_expr() on the access-vector path,
> security_get_bools() and security_get_bool_value() behind selinuxfs, and
> security_set_bools(). A sparse class value is absorbed by
> policydb_class_isvalid() and its siblings; booleans have no such
> predicate, and no consumer that could use one.
> 


I have run an AI-assisted backport review of 3938c8494d3c and checked 
the finding. The backport appears incomplete.

Before a93d37a09b86, upstream has commit
cf6a513f1937581eb012a217b29817e025a1a0ef ("selinux: switch two 
allocations to use kzalloc_objs()"), so the array inspected by the new 
validation is zeroed:

         p->bool_val_to_struct =
                 kzalloc_objs(*p->bool_val_to_struct, p->p_bools.nprim);

The 5.15 endpoint instead has:

         p->bool_val_to_struct =
                 kmalloc_array(p->p_bools.nprim,
                               sizeof(*p->bool_val_to_struct),
                               GFP_KERNEL);

while 3938c8494d3c later checks:

         if (!p->bool_val_to_struct[v])

cond_index_bool() writes only indices corresponding to defined booleans.
Consequently, an undefined slot can retain a stale non-NULL value, pass 
the new check, and later be dereferenced unconditionally by boolean 
consumers, potentially causing a kernel fault during or after malformed 
policy loading.

I think 5.15.y needs an adapted backport of
cf6a513f1937581eb012a217b29817e025a1a0ef ("selinux: switch two 
allocations to use kzalloc_objs()"), using kcalloc() on this branch, 
before 3938c8494d3c, thoughts?

Same problem shuld be present in other stable kernels <=6.12.y as I have 
seen same problem in 6.12.y as well.

thanks,
harshit
> Reject a boolean value that no boolean defines, once, where the array is
> built. Conforming policies define every boolean they declare and are
> unaffected.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   security/selinux/ss/policydb.c |   19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> --- a/security/selinux/ss/policydb.c
> +++ b/security/selinux/ss/policydb.c
> @@ -718,6 +718,7 @@ static inline void hash_eval(struct hash
>   static int policydb_index(struct policydb *p)
>   {
>   	int i, rc;
> +	u32 v;
>   
>   	if (p->mls_enabled)
>   		pr_debug("SELinux:  %d users, %d roles, %d types, %d bools, %d sens, %d cats\n",
> @@ -775,6 +776,24 @@ static int policydb_index(struct policyd
>   		if (rc)
>   			goto out;
>   	}
> +
> +	/*
> +	 * A sparse class value is absorbed by policydb_class_isvalid() and
> +	 * its siblings, but no such predicate exists for booleans: every
> +	 * user of bool_val_to_struct[] walks it by index and dereferences
> +	 * each entry -- cond_evaluate_expr(), the two getters and
> +	 * security_set_bools() -- so an unclaimed one has no consumer that
> +	 * can tolerate it.
> +	 */
> +	for (v = 0; v < p->p_bools.nprim; v++) {
> +		if (!p->bool_val_to_struct[v]) {
> +			pr_err("SELinux:  boolean %u is declared but not defined\n",
> +			       v + 1);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
>   	rc = 0;
>   out:
>   	return rc;
> 
> 
> 

