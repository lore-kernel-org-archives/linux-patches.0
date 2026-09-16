Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F148420468E;
	Wed, 16 Sep 2026 08:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547440; cv=fail; b=ezJc7ZaaYX2q0pA/XrK1PRs4PsqyygOf95KyQTj38lw8HldnsXE+hTX2M0wwdEUqGDj0WbJ/ijRYt7x+MQivqhlbW5t2him+J0Z/BTKf6stl6IJhwXuUML3sS7qJEVJDJcxrvVDuA7KoPEh2sdW7x05cb2YVlb9NgGV+x5X5xPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547440; c=relaxed/simple;
	bh=dniysloR1DAZqmcT/szZT5pOBji6jyr5tM5gkKk5e3A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rj6WBVn0CfFBlB5/95B3UfKfPU4W3Asr6C+f3IPKPs4W9+PdWbn93KSMg4Zu0s7n1biMioYu0bmGd1pL5rbQsGDSKCFWeR4bGWGQdXP+1hUDgOkzMmfjm/IDXL93DfP3jArfU8py2EOM0Wc0D9GLnRT2Bpr7OQ0MRSC1k9NTYIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j5rVREQQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YoFwIFRK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j5rVREQQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YoFwIFRK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWimi641434;
	Wed, 16 Sep 2026 08:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kE3mW30+Y4ll0XdKUr+hMV9lRjz7ND/T8mWY1viUcUU=; b=
	j5rVREQQLxWjuOkKmdYAxr4T7OpLU7GqgxFlXom3Ru/W80at2OBRKlcy83lUbFtb
	mfn164o2ZKgNLs36qWgR9JOg+gf40sfeUchOwC+IcXftdj+mxAH0z5B+DgCFMo1R
	HinDKYRpACxLS859J9I7vYrEQlwp+4Zra/WBdzkDFdK5hyU0Tgyl2N7JC9WAFei+
	zsxC2hr+iRpMfi5Wn35es3kehxufHNf+FhUFm7DRkOAjbc81QJkgpo7+OKnaG5UZ
	8ikI6SNRLPlzAx2+9mDe6+NNflXsmRU8ljQmMrHN4wMacGnxBFPs6fxd4aL9c0ns
	iEDguFrSwuA+BKM/PW+Pwg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs565g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:30:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8UQHH036678;
	Wed, 16 Sep 2026 08:30:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6qa84u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:30:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrG81pDD5Ty8sj3G2zOPTtQTdiIC58OsItYbMjrajF9x5SBQS0fzfIoLKIZD+Y5GEnKIghU28SwzZtg6KWyW4wYyhzcaMLoDmvmOCavFnkbjM2GMwop0eiymxEnHTXaZkCpgOc+2FpB5qbwB397YtdNjxBeIjcHBYhiBxrHJfKORTib63vZxRqZGSC3WT+WkGBGAOLBYL1fxYvM2h5l4oECOmWMCHIiOohY2q+Vig1ndFKlBF8X/sC5LEUXfJEGKB8mEwkEL8Mlgb6s+A5wiH9hMe7X9b7OVcf9rin9BJFkIvcoiyaNrbtg3e8NpjvacljvX8mHPLuogDxANZAZSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kE3mW30+Y4ll0XdKUr+hMV9lRjz7ND/T8mWY1viUcUU=;
 b=FtSXHd5DyR3zIa3QP3lr1/2Pbt9aBl9eE+q2o+yrl+d7gRz5t11dnIkvgpePG02XKB4kTck9pa7d9c/XbXWJ7XbSlrw39Y/BlKg2noE2FcmRxxg5XfiYS3cDaT1YAQCdwav7s1RKNeZbDpuBwsdCFTxIeQUkZdoQrVcP1gJ+0a8JIkSOGIPi4gH2rB9QapfdW7KqRSoXCELghMwYHXVP8WWOX9Uz41bfoN/8EvQXphyIqYfQIsE/l0RymPcAHS+2kPhJHyd7M/CbeOIs0qKqkCHKLFYo5ZQMPS/388Ps/Hd+yefHVmepRxnpx91Exp1G6YNxSVNwpmnd+9Ct3cITRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE3mW30+Y4ll0XdKUr+hMV9lRjz7ND/T8mWY1viUcUU=;
 b=YoFwIFRKT2mJL6dF6xG9Irb8fP/FaH+1a1VGT0uYMemBIFb7TMPLUIdRf7KJcvlScd/Y8Lv7nmehjiz5kE2zXDDAmKd98xSkDdYaDvW9kHtL8WZKfNedeVZHl+rE+YVZHNMCftLGZzhFnyKrbZ/1FCL4aPL7Jo8Ww3aTjM3x1f0=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS7PR10MB5055.namprd10.prod.outlook.com (2603:10b6:5:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 16 Sep
 2026 08:30:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:30:14 +0000
Message-ID: <28b2ad9d-520b-48b0-a4df-d940bb21bbb5@oracle.com>
Date: Wed, 16 Sep 2026 14:00:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1031/1376] xdrgen: Do not declare union XDR functions
 in the definitions header
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chuck Lever <cel@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065630.538643686@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065630.538643686@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0022.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1e::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS7PR10MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fcb069d-dfe3-4108-abad-08df13ccba8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|6133799003|10067099003|18002099003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	Hyknxc+HdA6ll6lZTNRaYNNQqFjU/v5xcWKN3VLMXSNjVR/I3qdMpe7RzpunczODUj+oTCC0qzdBsAciAqsaIGfc8z4lfpapn28NL7ZwREyM/JN8U1mXJC+bHKGjFWnGQGSvYomkF1/rcmSTAhA4FK12SVgsXI6yR3LxwDWm2Fuz/BQ0eA03+Omxss18eiCcQv4KfInfAWvHe9VokaBVQAGZgiknXtvEdqa85CGbmuk6OCN3pMV2uSSjcINOXTs9h4SgGaSZ+2RD0QaaQwOQPsDIv4GnHBn+eavIuQA2d/0P70X539gAS1vuUmJr6vztpl5byBHLFcUyZZjYT94Y9KHT6i9q21r2WwZWsr3xvWcnwzfJSsfZMpifu68gyN6+x8HsqPBhiWByQoQNyxj1y2GBLKIESqh/g53+AnBxjvgo3tQBDMCt8CoDzcPTtciE5PrSAimzXCP+uQbML3nhguvOQkp6HJX5q8kVB2vSdAFoWpbEgpnkAsLtsOZ8UNPEJcplSeYO+XMngpBfT+/SlmMNWqQz2qG/EE6OM1+iX9uCTJ6/QBVS5SlLLV8Kbx8ept1Js6+4zxdGgVL9NcGzE4Zig2/EVxCjc1DhjtuXItDaecTIGC3OEpzRGERGgygD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0xkNUJDcndyOS9WaDZPSlBKNVRSZkM2bnVzNUFyOVY4bS9vK1dLMytaS0d3?=
 =?utf-8?B?Z2JRbXpwd2NoSGV0RW1wcnFEVjREd2FuNnJ5a2l1QlIyNEFYQUQ0L3pJVTlM?=
 =?utf-8?B?ODVLSFB2Y3MrMU1GQjhycUxrWGpjTEpwOGZDTlF1aGxBYjNrUzd4M2pOc3d0?=
 =?utf-8?B?WDNhS2dZcWk2aEJCZ09wK1VMVXhyRnlFaUp5d0Y4Sys2d0tQNjhCYXdteDlJ?=
 =?utf-8?B?eU90YVlpTW9kZ2NHdURMRHNFVEVZeHNidVBUV2ZIRnltWDlNTWhhaXdXV2xY?=
 =?utf-8?B?TVRmaVNiZnkrOHRZOG5YYVFOcFpyYXZya29UUThtMWFSdXhXK2QxMW5hcnhE?=
 =?utf-8?B?dDRac2VQSld4ZW1OUXgrWW9MOUl0RHRtNXBOVFM1WG03Y0h3dFFGVVFycE83?=
 =?utf-8?B?aU9lREkzSmJYVTlUSzlRZnFrWk5KZmNkQnc4ZkljVmE3VzViSExEakU5U09y?=
 =?utf-8?B?cFEwRlFDZXJPUW5ONHlXNHdRd1hpRDFQU2VVSEk0NGxpM09URGR6RmY2d3ha?=
 =?utf-8?B?dUhJcFF3VHhZMjJuSUdhamZ1VklwcXVzZmpVZ3lQWlRwY09xWUp0cVRZVy84?=
 =?utf-8?B?SXZKZllhQlRnVDlvOWNIdHV4OTdvSG1FL3VOVDdta2ZkR3VtcGRudkFhLzRO?=
 =?utf-8?B?aC9NNDRMN3ZaU1FiTUw4Sks2d3lheGRBeGRzOHdvVUdZeXRheTY4dTZ2d05J?=
 =?utf-8?B?RFlpQXhkYnQyZE9sOURUWWtmYUE1NTdBNkkzNk1WWVBiakNtYk12bGZ1a2Rh?=
 =?utf-8?B?cUxCVk5BaVNTU1I2TkFjS254bENHTkFNRUdpczMvdDE1YUxWcUxXQ2phOCtt?=
 =?utf-8?B?RFQ1MkI0RnozUGFPR1UxSWRMMXNmSWZXRVNFUXlpRVVGazJ5d1E2VG9Jby95?=
 =?utf-8?B?WjRYNUdlak44d2dFNW5Nd2RtZ3NaZ3Frd1N2L1BqR21tQ20wTWsya0hqWFRH?=
 =?utf-8?B?MkM3cWtrQ2NEWnBtWGVXQkhOUDNVOXg5bVFmRzYzYmRNci9acDEzUG9Ya2l5?=
 =?utf-8?B?YjJaaTFYckQydkZVb1p3VnVhTkhUaTlaU0JQRkVpV0FLbFM3enFYSnB4ZEFn?=
 =?utf-8?B?SjFwVnF1M0NJVGgrcWhRdjd4dFRSTnROdGRqQVlqdWt1SXVyV3QxSmhucFdr?=
 =?utf-8?B?MkxqWDQ1VFlGZ0c3MTJTTGJaT1J3VVBsMnhIY0pMcm82REdNVm5hUVprQ1ht?=
 =?utf-8?B?dGxaRTRGOWVHcHVkY0VNclhSdmYvUllIYWpaL1lybEVHYkoya2VaenpCVTVW?=
 =?utf-8?B?WFBNcEZhQlJ4OWsxNlhDL2tEYU1ETTV5YXpCZHIrdWNwNUpValNhNmd3TmFw?=
 =?utf-8?B?b1BwMWRtSWVUWXluVHFjSXlvTmhsQWtMQXRmRFNJY3o1NmpoeDlpWkdXRTFO?=
 =?utf-8?B?c0VuMUNCaEZXYkxtZ0dRbXhobUNRUzI2Q2MvQXJIYi9vZG15aTBDaUQrV2x6?=
 =?utf-8?B?cDhrQ2d0djVFTHV2R1pIbHFBUWJqd2lESkludkRndTJ4aEdnYlljb3dDS0hM?=
 =?utf-8?B?ekhXOFc5S3Ivd0VQN2ZVdWNzdWVOeGpRaU96ai9tSk5GY1JEZFdnM0xCRE1k?=
 =?utf-8?B?QmVjYkNmeWFwcXoraEpqQVBwYzdSUFV3aFBMVk0zM3doSGZPaVM1N0NDREpk?=
 =?utf-8?B?MmV0TXRwMzd6WTdPc2xCRGo5ajJrb1pYK2dINlFUNnJLdUhLa0FlODdwVDJZ?=
 =?utf-8?B?UTRvc0lPR3VjZXVPUGJ5bmxWdkZSVXI4Mk0zZm5Hd2dYUkkyclROQlo5ZlZL?=
 =?utf-8?B?TU9JRlkrdk1sNlEreFZaN3Azc0FHc082UnFsdTRxcVZnVEI3Z1hDY2xuNk10?=
 =?utf-8?B?d1JDMG94dDh0VDRDM2tQc0FmbFRJbk4vdGRzbVRESmJqMjJJUkVTWDRzNXlR?=
 =?utf-8?B?bnpBai8rRkVJUmpKOHFDL1U5S2I2VFh4TmNSUnM5dGNPTWlYMEhiZE9kZWhM?=
 =?utf-8?B?T0tILzY2aEFpSmRob1dnN045OFZHWXBJWWwxZC81Z1VHM2YycjN5SmtXUXZZ?=
 =?utf-8?B?aVNtUXR6K0ZaenViUk95bmNNM05XNTJiS0IzVGYyakVTeEpRUkI0TjJLM2s1?=
 =?utf-8?B?Z0w5Q0Qvb0o2NnN1N3NRcmtLcWZXckdnU2ZEd1RrY2hiZmlLL2lhRDNsZGJ0?=
 =?utf-8?B?S290NkY2VEpJbEM5UytWZnozY1pmWmNvTUxkUDlWVDByY1hoN3d5S1ZiSUUx?=
 =?utf-8?B?eVVmZHJNcHQxUnU3Tm4wNXlVL2VVWkFubWJ1aTBjMlZPK0o5dXphWGZOcVVZ?=
 =?utf-8?B?Tk9yNGV4K3EzZXkyOG5QSzNodGdBUkh2bHM3eXE4aU11dENlV05SbDJYRE9M?=
 =?utf-8?B?MWIvdHVhczVscDBEc1lKOWpKaVJXcHBKOUcyWjFuSCtUaTI0NTE0SnhMWkMr?=
 =?utf-8?Q?Zku+Qf3mstqbzA5mUhDKajQ0BZ2tWeHcWTtx4?=
X-Exchange-RoutingPolicyChecked:
	MqnuUUgJkmbU1hWMcgmqPiTpb2PV/abTlxyu/9sZBttwXNTNi0o2KyJjy3CpHbGwgEUtcUiNkTiNx0hAboBVg3DSwG4hUWBDfJbHcr+mYfDxfW1PH4g17/jwsBaFaQ/FkpPB9Qfw6+lwRX/itSvpbs7JL5fx4NlB34HPXcL6jK+/NX+QkS3nQOfIkZNoZBVhsRxleYjmqqkDWvHplTPyd8FR4EIj8MwQqdK9PkfUnEU5uhSrNGIc7YuiUF1Juc4Ac2StH4o5XEtGTlax0Cmjg95jqmAU8FjLr3fuuycXCKsxbH4ZB4ulIG4jd5ca2Kpzv3mWdE/nUjdGKWN0xf7tQA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9MAF8vF2rNuUJSQbfPBqmWEFuItEDBLXwaWPoJ7pBqSd9TgiyZPEXg6ByMWZ5fxnmuEBofWCEj/l43OvVjCvleOC6FmF+31s8dVwCeDdrCu0/OjDUY6tvZCmTXwoXr/mpXbq8TfuAQ87OhDtXGN5EOcEwl7JTJbaCaXvcVVr+yYq002S+73yT/jkdYcwVrWpr9vgmuIz81qysr+rNbK37r7Goxod7/aJx4SmweniQKW8Sth0xV3ewpKwhlNUSddBVyMSGhmFgQ7lbGAzlOxBD8PwwN8os+bB9Bo/37EDN+G/j0H+tIA6sekYye9NHEBmE/I784VcnYR7AZpFqE7L0JhLO1TiWKsiN5G5kFuqfeobpF/zUUy26gLoxLpEVmf8KKxwLoVc2lh63iA5bfugc4iFKCI2gXRp0n0dp8AIeQcqaaL8CuPxPOxqds6PQVhbO9MxtMLB/LDBUGZIAKa6Jv3+kkmBGhxCUQYmxqvO0uErxEq0gT1r3TSZ3vJ9SxgaY6P4rDfiIGWit2JLnsckjZEjinZjfUyUzMawaelhCS/1tFT6blQRGJJ1Wytwv2a6cMDzQhazgcv+iT+XIc/1+8dEpm1heKhHukGj4GFBfPo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcb069d-dfe3-4108-abad-08df13ccba8c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:30:13.9574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwhY/8Hfn9ePFfoULRq8cuTogWwFBs+1wGqqkoKyS8DzkaecjEQNnS0E28TiEd11BzOz4XnP4Gh+n5FevtCa7hi7bTRL6VeZNw5+dzjLXkRjFc2psc2GKTTut9T0qkU5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwOSBTYWx0ZWRfX23bXyV0okXYT
 afQplcK14W6u3LvrPvCvYzHDuwHEdNm+9vrlr7w1pWmpzoeNbGrXrefBwz8uTdCe3eVk5XXfpUI
 sdv0kDXCAd6eUQJExohw4mlQGKNF37+Wfr5gpS5QBcd8T2B0ZMkQnyoBJcRGinOoHrXwrSyEDo2
 C1aTI+sd1SeFdFZ9bt43qaH+oluxc8rQZEvDsIdihtJmZCO32fJVIUrsKJc73avbjmkW4T0tEDa
 ZLRsAyViKJyx9KBEogLdYjHO8cR/ocQ3BgjLKzx94QK7JcyDdq+zmaD1AEXbBiWiUrw7D8OU4/K
 5Ko0j/aNfmLQ4+5r6MqDmqXhZ5NejV+OfEWyHEhrOWKcjjhv0gl6z47ijIydpERyNRKEQkr11Br
 72OCoyrxdzKlU1am09jQqsvO4bDgZ+HwLXiblibaDwlYA4c7sTCtsawMncIvwDoH0w4ROdT91BC
 stWKmew9Y6yTkW309I+9C99Vs2rP3FyKA3BDxUzI=
X-Proofpoint-ORIG-GUID: mocF7_maSu9qHG3jixt_KSeGYbb2obbq
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwOSBTYWx0ZWRfX2Y8vEbRRYSwt
 kVFg5FuTmAu5Kld4t00yEDO3VOc1pU1y7D0dmtA8eUHO+uUIjdXAcLYT2hVDzHFe/xIxNyH8P1m
 xU/6WE1zUezRIx8+xTC36zaPtmYRizxAzXU0C8vDligsnHbtbxUl
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa53ab b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=VwQbUJbxAAAA:8 a=l6w4u4KpSsb12pjhPjYA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13532
X-Proofpoint-GUID: mocF7_maSu9qHG3jixt_KSeGYbb2obbq



On 12/09/26 12:27 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chuck Lever <cel@kernel.org>
> 
> [ Upstream commit d4ca0b0a6c62bc12407060754df11b23a90f3e57 ]
> 
> Unlike the struct, enum, typedef, and pointer templates, the union
> definitions template also emits xdrgen_decode_*() and
> xdrgen_encode_*() prototypes for a public union into that header.
> Those prototypes name struct xdr_stream, which the definitions
> header neither includes nor forward-declares, so any translation
> unit that includes the definitions header without xdr.h already in
> scope draws -Wvisibility warnings. The same public prototypes are
> emitted into the declarations header, which does include
> <linux/sunrpc/xdr.h>, making the definitions-header copies
> redundant.
> 
> Drop the prototype emission from the union definitions template so
> it matches the other type templates. Public unions keep their
> encode and decode prototypes through the declarations header.
> 
> Fixes: 4b132aacb076 ("tools: Add xdrgen")
> Link: https://patch.msgid.link/20260712193122.116845-4-cel@kernel.org
> Signed-off-by: Chuck Lever <cel@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../net/sunrpc/xdrgen/templates/C/union/definition/close.j2 | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
> index 5fc1937ba7744..19ee759d70c6a 100644
> --- a/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
> +++ b/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
> @@ -1,9 +1,3 @@
>   {# SPDX-License-Identifier: GPL-2.0 #}
>   	} u;
>   };
> -{%- if name in public_apis %}
> -
> -
> -bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, struct {{ name }} *ptr);
> -bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, const struct {{ name }} *ptr);

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The patch removes public-union XDR prototypes from the definitions
header, which is correct only when the declarations header emits them.
On 6.12, the declarations generator requests union/declaration/close.j2,
but that template is absent. Public-union generation therefore loses
both prototypes and its declarations path raises TemplateNotFound.

Upstream prerequisite template:

     bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr,
                                   struct {{ name }} *ptr);
     bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr,
                                   const struct {{ name }} *value);

Downstream 6.12.y generator code:

     template = get_jinja2_template(environment,
                                    "declaration", "close")

The requested downstream union template does not exist.

I think 6.12.y misses f7cb94fad4e6cec354a3ea779f91fe5560fb72b6, "xdrgen:
Fix union declarations". Thoughts?

thanks,
Harshit

> -{%- endif -%}

